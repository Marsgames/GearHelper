# GearHelper — Roadmap

Version actuelle : **3.3.17**

---

## Versions à venir

### 3.3.18 — Commandes slash

- Réintroduction des commandes `/gh` pour accéder aux options sans ouvrir l'interface
- Commandes de base : `/gh config`, `/gh debug`, `/gh reset`
- À programmer pour le 18 juillet 2026

### 3.3.19 — Auto-équipement

- Réactivation de `GH_AutoEquip` : équipement automatique d'un item si le score est supérieur à l'item actuellement porté
- Option pour activer/désactiver la fonctionnalité dans les options
- À programmer pour le 25 juillet 2026

### 3.3.20 — Récompenses de quête

- Réactivation de `GH_QuestReward` : affichage du score GearHelper directement sur les choix de récompense de quête
- Mise en évidence de la meilleure récompense pour la spé active
- À programmer pour le 1er août 2026

### 3.3.21 — Character Frame

- Réactivation de `GH_CharacterFrame` : affichage du score global de l'équipement sur la fiche personnage
- Score par slot et score total de l'équipement équipé
- À programmer pour le 8 août 2026

### 3.3.22 — Événements de quête

- Réactivation de `GH_Quest` dans les events : détection automatique lors de la remise de quête
- Suggestion de la meilleure récompense sans action supplémentaire du joueur
- À programmer pour le 15 août 2026

### 3.3.23 — Polish options

- Ajout de la page de remerciements (`GH_Thanks`) dans les options
- Nettoyage et réorganisation de l'interface des options
- À programmer pour le 22 août 2026

### 3.4.0 — Mise à jour automatique

- Réactivation de `GH_UpdateAddon` : notification en jeu quand une mise à jour est disponible
- Lien direct vers la page CurseForge / Wago
- À programmer pour le 29 août 2026

---

## Idées à explorer (non planifiées)

### GH_Social — Alertes de whisper avancées

Permettre de configurer des mots-clés multiples pour l'alerte de whisper, et jouer un son personnalisable plutôt qu'une simple notification.

### GH_Social — Suivi de boss enrichi

Afficher un résumé des boss tués cette semaine directement dans le LFR Finder, avec distinction par personnage si plusieurs alts sont connectés.

### Comparaison multi-spé

Afficher le score d'un item pour toutes les spés de la classe, pas seulement la spé active — utile pour les joueurs qui changent régulièrement de rôle.

### Profils d'options exportables

Permettre d'exporter/importer un profil de poids de stats via un string, comme le font les addons de type WeakAuras.

### Support des sets d'équipement WoW

Intégration avec les sets d'équipement natifs du jeu — détecter automatiquement quel set est actif et adapter les recommandations.

---

## Décisions déjà prises

| Sujet                        | Décision                                                          |
| ---------------------------- | ----------------------------------------------------------------- |
| Découplage Core / Social     | Fait — GearHelper (core), GH_Social, GH_Utils séparés            |
| AutoEquip                    | À réactiver, désactivé par défaut (opt-in)                        |
| QuestReward                  | À réactiver, lié aux events de quête                              |
| Mise à jour automatique      | Oui, via `GH_UpdateAddon`, notification non intrusive             |
| Monétisation                 | Non — addon gratuit, donations bienvenues                         |
| Support Retail uniquement    | Oui — Interface 120100, pas de fork Classic prévu                 |
