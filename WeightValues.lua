GearHelper.itemSlot = {INVTYPE_AMMO = "Ammo", INVTYPE_HEAD = "Head", INVTYPE_NECK = "Neck", INVTYPE_SHOULDER = "Shoulder", INVTYPE_BODY = "Body", INVTYPE_CHEST = "Chest", INVTYPE_ROBE = "Chest", INVTYPE_WAIST = "Waist", INVTYPE_LEGS = "Legs", INVTYPE_FEET = "Feet", INVTYPE_WRIST = "Wrist", INVTYPE_HAND = "Hands", INVTYPE_FINGER = {"Finger0", "Finger1"}, INVTYPE_TRINKET = {"Trinket0", "Trinket1"}, INVTYPE_CLOAK = "Back", INVTYPE_SHIELD = "SecondaryHand", INVTYPE_WEAPON = {"MainHand", "SecondaryHand"}, INVTYPE_2HWEAPON = "MainHand", INVTYPE_WEAPONMAINHAND = "MainHand", INVTYPE_WEAPONOFFHAND = "SecondaryHand", INVTYPE_HOLDABLE = "SecondaryHand", INVTYPE_RANGED = "MainHand", INVTYPE_RANGEDRIGHT = "MainHand"}

--[[
Function : ParseDefaultValues
Scope : local
Description : Parse template strings to get each stat and store them in database
Input : rawValues = stat string, specID = specialization associated to the template, templateID = name of the template
Author : Raphaël Saget
]]
local function ParseDefaultValues(rawValues, specID, templateID)
	local rawCopy = rawValues
	local tmpTemplate = {
		["Intellect"] = 0,
		["Haste"] = 0,
		["CriticalStrike"] = 0,
		["Versatility"] = 0,
		["Mastery"] = 0,
		["Agility"] = 0,
		["Stamina"] = 0,
		["Strength"] = 0,
		["Armor"] = 0,
		["Leech"] = 0,
		["Avoidance"] = 0,
		["MainHandDps"] = 0,
		["MovementSpeed"] = 0,
		["OffHandDps"] = 0,
		["Max"] = 0
	}
	local lastWord = ""
	local count = 1

	for token in string.gmatch(rawCopy, "[^%s]+") do
		if count == 1 or count == 4 or count == 7 or count == 10 or count == 13 or count == 16 or count == 19 or count == 22 or count == 25 or count == 28 or count == 31 then
			lastWord = token
		end

		if count == 2 or count == 5 or count == 8 or count == 11 or count == 14 or count == 17 or count == 20 or count == 23 or count == 26 or count == 29 or count == 32 then
			--Refactoring some spelling from Noxxic and AMR
			if lastWord == "Crit" then
				lastWord = "CriticalStrike"
			end

			if lastWord == "OffHandDamage" then
				lastWord = "OffHandDps"
			end

			if lastWord == "MainHandDamage" then
				lastWord = "MainHandDps"
			end

			if string.gsub(token, "%[", "") then
				token = string.gsub(token, "%[", "")
			end
			if string.gsub(token, "%]", "") then
				token = string.gsub(token, "%]", "")
			end

			tmpTemplate[lastWord] = tonumber(token)
		end

		count = count + 1
	end

	for _, value in pairs(tmpTemplate) do
		if tmpTemplate.Max < value then
			tmpTemplate.Max = value
		end
	end

	if GearHelper.db.global.templates[specID] == nil then
		GearHelper.db.global.templates[specID] = {}
	end
	GearHelper.db.global.templates[specID][templateID] = tmpTemplate
end

local rawValues = {
	-- MAGE ARCANE --
	["62"] = {
		["NOX"] = "Intellect [9.06] > Versatility [7.56] >= Crit [7.41] >= Haste [7.26] > Mastery [4.56]"
	},
	-- MAGE FIRE --
	["63"] = {
		["NOX"] = "Intellect [9.05] > Crit [7.55] > Mastery [6.05] > Versatility [4.55] >= Haste [4.4]"
	},
	-- MAGE FROST --
	["64"] = {
		["NOX"] = "Intellect [9.05] > Crit [7.55] > Haste [6.05] > Versatility [4.55] >= Mastery [4.25]"
	},
	-- PALADIN HOLY --
	["65"] = {
		["NOX"] = "Intellect [9.06] > Crit [7.56] > Mastery [6.06] >= Versatility [5.76] > Haste [3.06]"
	},
	-- PALADIN PROTECTION --
	["66"] = {
		["NOX"] = "Stamina [12.06] > Strength [9.06] > Haste [7.56] > Versatility [6.06] >= Mastery [5.76] > Crit [3.06]"
	},
	-- PALADIN RETRIBUTION --
	["70"] = {
		["NOX"] = "Strength [9.07] > Haste [7.57] > Crit [6.07] >= Versatility [5.85] > Mastery [4.57]"
	},
	-- WARRIOR ARMS --
	["71"] = {
		["NOX"] = "Strength [9.06] > Crit [7.56] > Haste [6.06] > Versatility [4.56] > Mastery [3.06]"
	},
	-- WARRIOR FURY --
	["72"] = {
		["NOX"] = "Strength [9.02] > Crit [7.52] > Haste [6.02] > Versatility [4.52] > Mastery [3.02]"
	},
	-- WARRIOR PROTECTION --
	["73"] = {
		["NOX"] = "Stamina [12.07] > Strength [9.07] > Haste [7.57] > Mastery [6.07] >= Versatility [5.77] > Crit [3.07]"
	},
	-- DRUID BALANCE --
	["102"] = {
		["NOX"] = "Intellect [9.03] > Haste [7.53] > Crit [6.03] >= Versatility [5.73] > Mastery [3.03]"
	},
	-- DRUID FERAL --
	["103"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] > Mastery [6.04] >= Crit [5.67] >= Versatility [5.29]"
	},
	-- DRUID GUARDIAN --
	["104"] = {
		["NOX"] = "Stamina [12.08] > Agility [9.08] > Mastery [7.58] > Versatility [6.08] > Crit [4.58] >= Haste [4.36]"
	},
	-- DRUID RESTORATION --
	["105"] = {
		["NOX"] = "Intellect [9.02] > Mastery [7.52] > Haste [6.02] > Crit [4.52] > Versatility [3.02]"
	},
	-- DK BLOOD --
	["250"] = {
		["NOX"] = "Stamina [12.01] > Strength [9.01] > Haste [7.51] > Versatility [6.01] > Mastery [4.51] > Crit [3.01]"
	},
	-- DK FROST --
	["251"] = {
		["NOX"] = "Strength [9.03] > Crit [7.53] >= Haste [7.16] >= Mastery [6.78] >= Versatility [6.41]"
	},
	-- DK UNHOLY --
	["252"] = {
		["NOX"] = "Strength [9.08] > Mastery [7.58] > Crit [6.08] > Haste [4.58] > Versatility [3.08]"
	},
	-- HUNTER BEAST MASTERY --
	["253"] = {
		["NOX"] = "Agility [9.01] > Haste [7.51] >= Crit [7.21] >= Versatility [7.06] >= Mastery [6.91]"
	},
	-- HUNTER MARKSMANSHIP --
	["254"] = {
		["NOX"] = "Agility [9.08] > Haste [7.58] = Versatility [7.58] > Crit [6.08] >= Mastery [5.71]"
	},
	-- HUNTER SURVIVAL --
	["255"] = {
		["NOX"] = "Agility [9.08] > Haste [7.58] > Versatility [6.08] > Crit [4.58] > Mastery [3.08]"
	},
	-- PRIEST DISCIPLINE --
	["256"] = {
		["NOX"] = "Intellect [9.05] > Haste [7.55] > Mastery [6.05] > Versatility [4.55] >= Crit [4.4]"
	},
	-- PRIEST HOLY --
	["257"] = {
		["NOX"] = "Intellect [9.07] > Mastery [7.57] > Crit [6.07] > Haste [4.57] > Versatility [3.07]"
	},
	-- PRIEST SHADOW --
	["258"] = {
		["NOX"] = "Intellect [9.03] > Haste [7.53] > Crit [6.03] > Versatility [4.53] > Mastery [1.53]"
	},
	-- ROGUE ASSASSINATION --
	["259"] = {
		["NOX"] = "Agility [9.05] > Haste [7.55] > Crit [6.05] > Mastery [4.55] > Versatility [3.05]"
	},
	-- ROGUE OUTLAW --
	["260"] = {
		["NOX"] = "Agility [9.08] > Versatility [7.58] > Haste [6.08] > Crit [4.58] >= Mastery [4.36]"
	},
	-- ROGUE SUBTLETY --
	["261"] = {
		["NOX"] = "Agility [9.02] > Haste [7.52] > Mastery [6.02] >= Versatility [5.79] > Crit [4.52]"
	},
	-- SHAMAN ELEMENTAL --
	["262"] = {
		["NOX"] = "Intellect [9.05] > Crit [7.55] > Haste [6.05] >= Versatility [5.83] >= Mastery [5.6]"
	},
	-- SHAMAN ENHANCEMENT --
	["263"] = {
		["NOX"] = "Agility [9.07] > Haste [7.57] > Crit [6.07] > Versatility [4.57] > Mastery [3.07]"
	},
	-- SHAMAN RESTORATION --
	["264"] = {
		["NOX"] = "Intellect [9.01] > Crit [7.51] > Versatility [6.01] > Haste [4.51] >= Mastery [4.29]"
	},
	-- WARLOCK AFFLICTION --
	["265"] = {
		["NOX"] = "Intellect [9.03] > Mastery [7.53] = Haste [7.53] > Crit [6.03] > Versatility [4.53]"
	},
	-- WARLOCK DEMONOLOGY --
	["266"] = {
		["NOX"] = "Intellect [9.05] > Mastery [7.55] > Haste [6.05] > Crit [4.55] >= Versatility [4.4]"
	},
	-- WARLOCK DESTRUCTION --
	["267"] = {
		["NOX"] = "Intellect [9.07] > Haste [7.57] >= Crit [7.2] > Versatility [4.57] > Mastery [3.07]"
	},
	-- MONK BREWMASTER --
	["268"] = {
		["NOX"] = "Stamina [12.06] > Agility [9.06] > Crit [7.56] > Versatility [6.06] > Mastery [4.56] > Haste [3.06]"
	},
	-- MONK WINDWALKER --
	["269"] = {
		["NOX"] = "Agility [9.05] > Versatility [7.55] > Mastery [6.05] > Crit [4.55] > Haste [3.05]"
	},
	-- MONK MISTWEAVER --
	["270"] = {
		["NOX"] = "Intellect [9.05] > Crit [7.55] > Versatility [6.05] > Haste [4.55] > Mastery [3.05]"
	},
	-- DEMON HUNTER HAVOC --
	["577"] = {
		["NOX"] = "Agility [9.05] > Haste [7.55] >= Versatility [7.17] > Crit [6.05] > Mastery [4.55]"
	},
	-- DEMON HUNTER VENGEANCE --
	["581"] = {
		["NOX"] = "Stamina [12.07] > Agility [9.07] > Haste [7.57] > Versatility [6.07] > Mastery [4.57] > Crit [3.07]"
	}
}

--[[
Function : InitTemplates
Scope : GearHelper
Description : Global function to process every templates strings
Input :
Output :
Author : Raphaël Saget
]]
function GearHelper:InitTemplates()
	for spec, templates in pairs(rawValues) do
		for templateID, stats in pairs(templates) do
			ParseDefaultValues(stats, spec, templateID)
		end
	end
end
