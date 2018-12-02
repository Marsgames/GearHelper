local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "deDE")
if not L then
	return
end

L["merci"] = "|cFF00FF00Thank you Salty and gOOvER for the translations"

L["local"] = "DE"

L["Addon"] = "GearHelper : |r"
L["ActivatedGreen"] = "Aktiviert|r"
L["DeactivatedRed"] = "|cFFFF0000Deaktiviert|r"
L["addonActivated"] = "|cFF00FF00GearHelper |cFFFFFF00ist|r aktiviert|r"
L["autoNeed"] = "Automatisch Bedarf auf Instanzbeute würfeln, falls das Teil besser als deins ist : "
L["AutoEquipLootedStuff"] = "Beute automatisch anlegen : "
L["UIGHCheckBoxAddon"] = "Schalte GearHelper ein/aus"
L["UIGHCheckBoxSellGrey"] = "Schalte automatisches Verkaufen von grauen Gegenständen ein/aus"
L["UIGHCheckBoxAutoGreed"] = "Schalte automatisches Würfeln von Gier in Instanzen ein/aus"
L["UIGHCheckBoxAutoAcceptQuestReward"] = "Schalte automatisches Akzeptieren von Questbelohnungen ein/aus"
L["UIGHCheckBoxAutoNeed"] = "Schalte automatisches Würfeln von Bedarf in Instanzen ein/aus"
L["CantRepair"] = "Du kannst nicht reparieren"
L["DNR"] = "Nicht automatisch reparieren"
L["AutoRepair"] = "Repariere automatisch"
L["maLangue"] = "deutsch"
L["maLangueenUS"] = "German"
L["maLanguefrFR"] = "Allemand"
L["maLangueesES"] = "Alemán"
L["maLangueesEX"] = "Alemán"
L["maLanguedeDE"] = "Deutsch"
L["maLangueitIT"] = "Tedesco"
L["maLangueruRU"] = "немецкий"
L["maLanguekoKR"] = "독일의"
L["maLangueptBR"] = "Alemão"
L["maLanguezhCN"] = "德国"
L["maLanguezhTW"] = "德國"
L["ask1"] = "|cFFFFFF00Du kannst fragen ["
L["ask2"] = "|cFFFFFF00] ob er es braucht"
L["gold"] = "g"
L["mainD"] = "Rechte Hand"
L["mainG"] = "Linke Hand"

-------------------------- CE QUI EST EN DESSOUS DE CETTE LIGNE N'EST PAS DISPO SUR CURSE ----------------------------

------------------------------------------------ SUPRIMER CETTE LIGNE ------------------------------------------------
-----

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
		["Leech"] = "Lebensraub",
		["Avoidance"] = "Vermeidung",
		["MovementSpeed"] = "Bewegungsgeschwindigkeit"
	},
	["ItemLevel"] = "^Gegenstandsstufe",
	["LevelRequired"] = "^Benötigt Stufe",
	["GemSocketEmpty"] = "Sockel",
	["BonusGem"] = "^Sockelbonus"
	--["MainDroite"] = "Dégâts main droite",
	--["MainGauche"] = "Dégâts main gauche"
}
