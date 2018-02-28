local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "deDE")
if not L then return end

	L["merci"] = 									"|cFF00FF00Thank you Salty for the translation"

	L["local"] = 									"DE"

	L["Addon"] = 									"GearHelper : |r"
	L["ActivatedGreen"] = 								"Aktiviert|r"
	L["DeactivatedRed"] = 							"|cFFFF0000Deaktiviert|r"
	L["addonActivated"] = 							"|cFF00FF00GearHelper |cFFFFFF00ist|r aktiviert|r"
	L["AutoNeed"] = 			"Automatisch Bedarf auf Instanzbeute würfeln, falls das Teil besser als deins ist : "
	L["AutoEquipLootedStuff"] = 				"Beute automatisch anlegen : "
	L["UIGHCheckBoxAddon"] = 						"Schalte GearHelper ein/aus"
	L["UIGHCheckBoxSellGrey"] = 				"Schalte automatisches Verkaufen von grauen Gegenständen ein/aus"
	L["UIGHCheckBoxAutoGreed"] = 						"Schalte automatisches Würfeln von Gier in Instanzen ein/aus"
	L["UIGHCheckBoxAutoAcceptQuestReward"] = 			"Schalte automatisches Akzeptieren von Questbelohnungen ein/aus"
	L["UIGHCheckBoxAutoNeed"] = 							"Schalte automatisches Würfeln von Bedarf in Instanzen ein/aus"
	L["CantRepair"] = 								"Du kannst nicht reparieren"
	L["DNR"] =										"Nicht automatisch reparieren"
	L["AutoRepair"] = 								"Repariere automatisch"
	L["maLangue"] = 								"deutsch"

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
        ["BonusGem"] = "^Sockelbonus",
        --["MainDroite"] = "Dégâts main droite",
      --["MainGauche"] = "Dégâts main gauche"
    }
