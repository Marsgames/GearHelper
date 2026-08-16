#!/usr/bin/env python3
"""
CurseForge uploader for GearHelper.

Builds a zip from the GearHelper/ addon directory and uploads it
to CurseForge via their file upload API.

USAGE
-----
Upload the current state of the repo:
    python curseforge_uploader.py

Upload a specific git tag (checks it out first):
    python curseforge_uploader.py --tag 3.3.19

Dry-run (builds the zip, prints what would be uploaded, no HTTP request):
    python curseforge_uploader.py --tag 3.3.19 --dry-run

CF_PUBLIC_API_TOKEN is read from the CF_PUBLIC_API_TOKEN environment variable.
"""

import argparse
import io
import json
import os
import re
import ssl
import subprocess
import urllib.request
import zipfile
from pathlib import Path

# ── Config ────────────────────────────────────────────────────────────────────

CF_PROJECT_ID = 101055
CF_BASE_URL   = "https://wow.curseforge.com"

# WoW Retail game version type ID on CurseForge
CF_GAME_VERSION_TYPE_RETAIL = 517

# Répertoire de l'addon dans le repo
ADDON_DIR = "GearHelper"

# Dossiers/fichiers à exclure du zip (relatifs à GearHelper/)
IGNORED = {
    "Scraper",
    ".luacheckrc",
    ".pkgmeta",
    # LibBabble-Inventory-3.0 et LibRealmInfo sont des RequiredDeps (addons séparés),
    # pas bundlées dans le zip.
}


# ── SSL ───────────────────────────────────────────────────────────────────────

def _ssl_ctx() -> ssl.SSLContext:
    try:
        import certifi
        return ssl.create_default_context(cafile=certifi.where())
    except ImportError:
        pass
    if os.path.exists("/etc/ssl/cert.pem"):
        return ssl.create_default_context(cafile="/etc/ssl/cert.pem")
    return ssl.create_default_context()

_SSL_CTX = _ssl_ctx()


# ── Token ─────────────────────────────────────────────────────────────────────

def _cf_token() -> str:
    token = os.environ.get("CF_PUBLIC_API_TOKEN")
    if not token:
        raise RuntimeError(
            "CF_PUBLIC_API_TOKEN non configuré. "
            "Exporte la variable d'environnement avant de lancer le script."
        )
    return token


# ── .toc helpers ──────────────────────────────────────────────────────────────

def _repo_root() -> Path:
    return Path(__file__).parent.resolve()

def _read_toc_field(field: str) -> str:
    toc = _repo_root() / ADDON_DIR / f"{ADDON_DIR}.toc"
    with open(toc) as f:
        for line in f:
            m = re.match(rf"##\s+{field}:\s+(.+)", line.strip())
            if m:
                return m.group(1).strip()
    raise RuntimeError(f"Champ '{field}' introuvable dans {ADDON_DIR}.toc")

def _interface_to_semver(interface: int) -> str:
    """120100 -> '12.1.0'"""
    major = interface // 10000
    minor = (interface % 10000) // 100
    patch = interface % 100
    return f"{major}.{minor}.{patch}"


# ── Game version lookup ────────────────────────────────────────────────────────

def _fetch_game_version_ids(token: str, interface: int) -> list:
    url = f"{CF_BASE_URL}/api/game/versions"
    req = urllib.request.Request(
        url, headers={"X-Api-Token": token, "Accept": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=10, context=_SSL_CTX) as resp:
        versions = json.loads(resp.read())

    target = _interface_to_semver(interface)
    retail = [v for v in versions if v.get("gameVersionTypeID") == CF_GAME_VERSION_TYPE_RETAIL]
    exact  = [v for v in retail   if v.get("name") == target]
    if exact:
        return [exact[0]["id"]]
    if retail:
        latest = retail[-1]
        print(f"  ⚠️  Pas de correspondance exacte pour {target}, utilisation de : {latest['name']}")
        return [latest["id"]]
    raise RuntimeError(
        f"Aucune version CurseForge trouvée pour l'interface {interface} ({target}). "
        f"Type IDs disponibles : {set(v.get('gameVersionTypeID') for v in versions)}"
    )


# ── Zip builder ───────────────────────────────────────────────────────────────

def _should_ignore(rel: Path) -> bool:
    """Retourne True si le chemin (relatif à GearHelper/) doit être exclu."""
    parts = rel.parts
    return bool(parts) and parts[0] in IGNORED

def _build_zip(repo_path: Path) -> bytes:
    """
    Construit le zip en mémoire.
    Structure dans le zip :
      GearHelper/
        GearHelper.toc
        GH_Core.lua
        Commands/
        ...
    """
    addon_path = repo_path / ADDON_DIR
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        for src in sorted(addon_path.rglob("*")):
            if not src.is_file():
                continue
            rel = src.relative_to(addon_path)
            if _should_ignore(rel):
                continue
            arc_name = f"{ADDON_DIR}/{rel}"
            zf.write(src, arc_name)
            print(f"    + {arc_name}")
    return buf.getvalue()


# ── Git helpers ───────────────────────────────────────────────────────────────

def _checkout_tag(repo_path: Path, tag: str) -> None:
    result = subprocess.run(
        ["git", "-C", str(repo_path), "checkout", f"tags/{tag}"],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"git checkout tags/{tag} échoué : {result.stderr.strip()}")
    print(f"  🏷️  Tag {tag} checké out")


# ── Upload ────────────────────────────────────────────────────────────────────

def upload(tag: str = None, version_override: str = None, dry_run: bool = False) -> str:
    if CF_PROJECT_ID is None:
        raise RuntimeError("CF_PROJECT_ID non configuré dans curseforge_uploader.py")

    repo_path = _repo_root()

    if tag:
        _checkout_tag(repo_path, tag)

    token     = _cf_token()
    interface = int(_read_toc_field("Interface"))
    version   = version_override or tag or _read_toc_field("Version")

    print(f"  📦 Récupération des game version IDs CurseForge pour l'interface {interface}...")
    game_version_ids = _fetch_game_version_ids(token, interface)

    print(f"  📦 Construction du zip pour v{version} (game versions : {game_version_ids})")
    zip_bytes = _build_zip(repo_path)
    print(f"  📦 Taille du zip : {len(zip_bytes) / 1024:.1f} KB")

    metadata = {
        "changelog":     f"Version {version}",
        "changelogType": "text",
        "displayName":   f"GearHelper {version}",
        "gameVersions":  game_version_ids,
        "releaseType":   "release",
    }

    if dry_run:
        print(f"  [dry-run] POST sur le projet {CF_PROJECT_ID} avec : {metadata}")
        return "dry-run"

    boundary = "----GearHelperBoundary7x3k"
    crlf     = b"\r\n"
    body     = (
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="metadata"\r\n'
        f"Content-Type: application/json\r\n\r\n"
        f"{json.dumps(metadata)}\r\n"
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="file"; filename="GearHelper-{version}.zip"\r\n'
        f"Content-Type: application/zip\r\n\r\n"
    ).encode() + zip_bytes + crlf + f"--{boundary}--\r\n".encode()

    url = f"{CF_BASE_URL}/api/projects/{CF_PROJECT_ID}/upload-file"
    req = urllib.request.Request(
        url, data=body,
        headers={
            "X-Api-Token":  token,
            "Content-Type": f"multipart/form-data; boundary={boundary}",
        },
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=30, context=_SSL_CTX) as resp:
        result = json.loads(resp.read())

    file_id = str(result.get("id", "?"))
    print(f"  ✅ Uploadé sur CurseForge — file ID : {file_id}")
    return file_id


# ── CLI ───────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Upload GearHelper sur CurseForge")
    parser.add_argument("--tag",      default=None,
                        help="Tag git à checker out avant l'upload (ex: 3.3.19)")
    parser.add_argument("--version",  default=None,
                        help="Override de la version affichée sur CurseForge (défaut : lu depuis le .toc ou --tag)")
    parser.add_argument("--dry-run",  action="store_true",
                        help="Construit le zip et affiche ce qui serait uploadé, sans faire de requête HTTP")
    args = parser.parse_args()

    file_id = upload(args.tag, args.version, args.dry_run)
    print(f"Terminé — CurseForge file ID : {file_id}")
