local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "koKR")
if not L then return end


	local nePasNeed = GHDontNeed


	L["merci"] = 									"|cFF00FF00"

	L["local"] = 									"KR"

	L["maLangue"] = 								"corean"



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
            ["Leech"] = "생기흡수",
            ["Avoidance"] = "광역회피",
            ["MovementSpeed"] = "이동 속도"
        },
        ["ItemLevel"] = "^아이템 레벨",
        ["LevelRequired"] = "^요구 레벨",
        ["GemSocketEmpty"] = "보석 홈",
        ["BonusGem"] = "^보석 장착 보너스",
        --["MainDroite"] = "Dégâts main droite",
        --["MainGauche"] = "Dégâts main gauche"
    }
