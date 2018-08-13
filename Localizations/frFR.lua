local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "frFR")
if not L then
	return
end

L["merci"] = "Auteurs : Marsgames - Temple Noir | Tempaxe - Temple Noir"
L["local"] = "FR"

-------------------------- CE QUI EST EN DDESSOUS DE CETTE LIGNE N'EST PAS DISPO SUR CURSE --------------------------
L["Addon"] = "GearHelper est : |r"
L["SellGrey"] = "La vente d'objets commun est : "
L["ActivatedGreen"] = "activé|r"
L["DeactivatedRed"] = "désactivé|r"
L["itemLessThanGeneral"] = "Cet item est moins bien"
L["itemBetterThan"] = "Cet item est mieux que votre"
L["itemBetterThan2"] = "avec une valeur de +"
L["itemBetterThanGeneral"] = "Cet item est mieux avec une valeur de +"
L["iNeededOn"] = "J'ai fait fait besoin sur "
L["UIGHCheckBoxAddon"] = "Active / désactive GearHelper"
L["UIGHCheckBoxSellGrey"] = "Active / désactive la vente automatique d'objets gris"
L["UIGHCheckBoxAutoGreed"] = "Active / désactive l'option de cupidité automatique en instance"
L["UIGHCheckBoxAutoAcceptQuestReward"] =
	"Active / désactive l'option pour recevoir automatiquement les récompenses de quêtes"
L["UIGHCheckBoxAutoNeed"] = "Active / désactive l'option de besoin automatique en instance"
L["UIGHCheckBoxAutoEquipLootedStuff"] = "Active / désactive l'option pour équiper automatiquement le stuff ramassé"
L["UIGHCheckBoxAutoEquipWhenSwitchSpe"] =
	"Active / désactive l'option pour équiper automatiquement le bon stuff au changement de spé"
L["CantRepair"] = "Vous ne pouvez pas réparer"
L["repairCost"] = "Coût des réparations : "
L["guildRepairCost"] = "Coût des réparations pour la guilde : "
L["gold"] = "po" -- g for Gold (in english)  / po for Piece d'Or (in french)...
L["dot"] = "," -- ex : 3.24 golds (3 gold and 24 silver)
L["DNR"] = "Ne pas réparer automatiquement"
L["AutoRepair"] = "Réparer automatiquement"
L["GuildAutoRepair"] = "Réparer avec guilde si possible"
L["itemEgal"] = "Cet item est équivalent à celui équipé"
L["itemEgala"] = "Cet item est équivalent à "
L["itemEgalMainD"] = "Cet item est équivalent à la Main Droite équipé"
L["itemEgalMainG"] = "Cet item est équivalent à la Main Gauche équipé"
L["itemLessThan"] --[[cMoinsB..]] = "Cet item est moins bien que votre"
L["mainD"] = " Main Droite "
L["mainG"] = " Main Gauche "
L["UIGHCheckBoxAutoInvite"] = "Invite automatiquement dans un groupe la personne qui vous chuchote "
L["checkGHAutoTell"] = "Active / désactive l'option pour annoncer automatiquement les loots en raid"
L["InviteMessage"] = "Le message à vous chuchoter pour que vous evoyiez une invitation automatique est : "
L["moneyEarned"] = "Argent obtenu en vendant : "
L["ask1"] = "Vous pouvez demander à [|r"
L["ask2"] = "] s'il a besoin de |r"
L["demande1"] = "Voulez-vous demander à "
L["demande2"] = " s'il a besoin de "
L["yes"] = "Oui"
L["no"] = "Non"
L["maj1"] = "Vous utilisez la version "
L["maj2"] = "|r de GearHelper. La version "
L["maj3"] = "|r a été trouvée chez "
L["equipVerbose"] = " vient d'être équipé par GearHelper"
L["maLangue"] = "français"
L["enable"] = "Activer"
L["gearOptions"] = "Options d'équipement"
L["autoGreed"] = "Cupidité automatique"
L["autoNeed"] = "Besoin automatique"
L["autoEquipLootedStuff"] = "Equiper automatiquement le stuff ramassé"
L["autoEquipSpecChangedStuff"] = "Changer l'équipement en même temps que la spé"
L["lootInRaidAlert"] = "Alerte des loots en raid"
L["UIGHCheckBoxlootInRaidAlert"] =
	"Active / Désactive l'option pour être informé si quelqu'un loot quelque chose de mieux que ce que vous avez, en instance"
L["UIprintWhenEquip"] = "Mode verbal"
L["miscOptions"] = "Options secondaires"
L["sellGrey"] = "Vente d'objets gris"
L["questRewars"] = "Récupération des récompenses de quête"
L["auto-repair"] = "Réparation-Auto"
L["auto-repairDesc"] = "Active / Désactive les réparations automatiques"
L["UIautoInvite"] = "Invitation par chuchotement"
L["UIinviteMessage"] = "Messagee à chuchoter"
L["UIinviteMessageDesc"] = "Message à vouos chuchoter pour se faire inviter"
L["remove"] = "Supprimer"
L["UIcwTemplateToUse"] = "Template à utiliser"
L["UIstatsTemplateToUse"] = "Template de stats à utiliser"
L["UItemplateName"] = "Nouveau template"
L["customWeights"] = "Template personnalisé"
L["noxxicWeights"] = "Template Noxxic"
L["UIcwIlvlWeight"] = "Facteur iLvl"
L["UIcwIlvlOption"] = "Activer calcul de l'iLvl"
L["UIcwGemSocketCompute"] = "Compter les châsses vides"
L["betterThanNothing"] = "Cet item est mieux que rien"
L["UIGlobalComputeNotEquippable"] = "Afficher item non equippable"
L["UIGlobalComputeNotEquippableDescription"] = "Afficher si un item est meilleur meme si il n'est pas équipable"
L["UICWasPercentage"] = "Valeur en pourcentage"
L["UICWasPercentageDescription"] =
	"Decrire l'importance de chaque statistique par un chiffre représentant un pourcentage, la somme des valeurs doit faire 100"
L["UIWhisperAlert"] = "Alerte chuchotement"
L["UIWhisperAlertDesc"] = "Joue un son quand un joueur vous /w"
L["UISayMyName"] = "Dis mon nom"
L["UISayMyNameDesc"] = "Alerte visuelle et sonore quand votre pseudo est cité"
L["UIMyNames"] = "Noms"
L["UIMyNamesDesc"] = "Liste des noms, séparés par une virgule. (Pas d'espace)"
L["itemEquipped"] = "Cet item est équippé"
L["UIMinimapIcon"] = "Bouton minimap"
L["UIMinimapIconDesc"] = "Afficher le bouton sur la minimap"
L["MmTtLClick"] = "Clique gauche pour ouvrir le menu"
L["MmTtRClickActivate"] = "Clique droit pour activer GearHelper"
L["MmTtRClickDeactivate"] = "Clique droit pour désactiver GearHelper"
L["MmTtClickUnlock"] = "Shift + clique pour |cFF00FF00dévérouiller|cFFFFFF00 le bouton"
L["MmTtClickLock"] = "Shift + clique pour |cFFFF0000vérouiller|cFFFFFF00 le bouton"
L["MmTtCtrlClick"] = "Ctrl + clique pour |cFF00FF00cacher|cFFFFFF00 le bouton"
L["DropRate"] = "Taux d'obtention : "
L["DropZone"] = "Zone : "
L["DropBy"] = "Obtenu sur : "
L["ilvlInspect"] = "ilvl moyen : "
L["UIBossesKilled"] = "Bosses tués"
L["UIBossesKilledDesc"] = "Affiche les bosses tués sur le menu LFR"
-------------------------- CE QUI EST EN DESSOUS DE CETTE LIGNE N'EST PAS DISPO SUR CURSE --------------------------


L["Tooltip"] = {
	Stat = {
		["Intellect"] = ITEM_MOD_INTELLECT_SHORT,
		["Haste"] = ITEM_MOD_HASTE_RATING_SHORT,
		["CriticalStrike"] = ITEM_MOD_CRIT_RATING_SHORT,
		["Versatility"] = ITEM_MOD_VERSATILITY,
		["Mastery"] = ITEM_MOD_MASTERY_RATING_SHORT,
		["Agility"] = ITEM_MOD_AGILITY_SHORT,
		["Stamina"] = ITEM_MOD_STAMINA_SHORT,
		["Strength"] = ITEM_MOD_STRENGTH_SHORT,
		["Armor"] = RESISTANCE0_NAME,
		["Multistrike"] = ITEM_MOD_CR_MULTISTRIKE_SHORT,
		["DPS"] = ITEM_MOD_DAMAGE_PER_SECOND_SHORT,
		["Leech"] = "Ponction",
		["Avoidance"] = "Évitement",
		["MovementSpeed"] = "Vitesse"
	},
	["ItemLevel"] = "^Niveau d'objet",
	["LevelRequired"] = "^Niveau (.*) requis$",
	["GemSocketEmpty"] = "^Châsse prismatique$",
	["BonusGem"] = "^Bonus de sertissage"
}
