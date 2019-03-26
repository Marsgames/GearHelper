local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "esMX")
if not L then return end




	L["merci"] = 									"|cFF00FF00"

	L["local"] = 									"MX"

	L["maLangue"] = 								"spanish"


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
            ["Leech"] = "restitución",
            ["Avoidance"] = "elusión",
            ["MovementSpeed"] = "velocidad"
        },
        ["ItemLevel"] = "^Nivel de objeto",
        ["LevelRequired"] = "^Necesitas ser de nivel",
        ["GemSocketEmpty"] = "Ranuras",
        ["BonusGem"] = "^Bonus de ranura",
        --["MainDroite"] = "Dégâts main droite",
        --["MainGauche"] = "Dégâts main gauche"
    }
