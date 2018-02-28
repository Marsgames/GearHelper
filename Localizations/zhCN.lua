local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "zhCN")
if not L then return end




L["merci"] = 									"|cFF00FF00"

L["local"] = 									"CN"

L["maLangue"] = 								"chinese"


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
		["Leech"] = "吸血",
		["Avoidance"] = "闪避",
		["MovementSpeed"] = "加速"
	},
	["ItemLevel"] = "^物品等级",
	["LevelRequired"] = "^需要等级",
	["GemSocketEmpty"] = "插槽",
	["BonusGem"] = "^镶孔奖励",
	--["MainDroite"] = "Dégâts main droite",
	--["MainGauche"] = "Dégâts main gauche"
}
