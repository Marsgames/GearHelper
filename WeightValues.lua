GearHelper.itemSlot = { INVTYPE_AMMO = "Ammo", INVTYPE_HEAD = "Head", INVTYPE_NECK = "Neck", INVTYPE_SHOULDER = "Shoulder", INVTYPE_BODY = "Body", INVTYPE_CHEST = "Chest", INVTYPE_ROBE = "Chest", INVTYPE_WAIST = "Waist", INVTYPE_LEGS = "Legs", INVTYPE_FEET = "Feet", INVTYPE_WRIST = "Wrist", INVTYPE_HAND = "Hands", INVTYPE_FINGER = { "Finger0", "Finger1" }, INVTYPE_TRINKET = { "Trinket0", "Trinket1" }, INVTYPE_CLOAK = "Back", INVTYPE_SHIELD = "SecondaryHand", INVTYPE_WEAPON = { "MainHand", "SecondaryHand" }, INVTYPE_2HWEAPON = "MainHand", INVTYPE_WEAPONMAINHAND = "MainHand", INVTYPE_WEAPONOFFHAND = "SecondaryHand", INVTYPE_HOLDABLE = "SecondaryHand", INVTYPE_RANGED = "MainHand", INVTYPE_RANGEDRIGHT = "MainHand" }

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
		["NOX"] = "Intellect [9.05] > Versatility [7.55] >= Crit [7.4] >= Haste [7.25] > Mastery [4.55]",
	},
	-- MAGE FIRE --
	["63"] = {
		["NOX"] = "Intellect [9.02] > Crit [7.52] > Mastery [6.02] > Versatility [4.52] >= Haste [4.37]",
	},
	-- MAGE FROST --
	["64"] = {
		["NOX"] = "Intellect [9.08] > Crit [7.58] > Haste [6.08] > Versatility [4.58] >= Mastery [4.28]",
	},
	-- PALADIN HOLY --
	["65"] = {
		["NOX"] = "Intellect [9.08] > Crit [7.58] > Mastery [6.08] >= Versatility [5.78] > Haste [3.08]",
	},
	-- PALADIN PROTECTION --
	["66"] = {
		["NOX"] = "Stamina [12.05] > Strength [9.05] > Haste [7.55] > Versatility [6.05] >= Mastery [5.75] > Crit [3.05]",
	},
	-- PALADIN RETRIBUTION --
	["70"] = {
		["NOX"] = "Strength [9.04] > Haste [7.54] > Crit [6.04] >= Versatility [5.82] > Mastery [4.54]",
	},
	-- WARRIOR ARMS --
	["71"] = {
		["NOX"] = "Strength [9.04] > Crit [7.54] > Haste [6.04] > Versatility [4.54] > Mastery [3.04]",
	},
	-- WARRIOR FURY --
	["72"] = {
		["NOX"] = "Strength [9.06] > Crit [7.56] > Haste [6.06] > Versatility [4.56] > Mastery [3.06]",
	},
	-- WARRIOR PROTECTION --
	["73"] = {
		["NOX"] = "Stamina [12.04] > Strength [9.04] > Haste [7.54] > Mastery [6.04] >= Versatility [5.74] > Crit [3.04]",
	},
	-- DRUID BALANCE --
	["102"] = {
		["NOX"] = "Intellect [9.02] > Haste [7.52] > Crit [6.02] >= Versatility [5.72] > Mastery [3.02]",
	},
	-- DRUID FERAL --
	["103"] = {
		["NOX"] = "Agility [9.06] > Haste [7.56] > Mastery [6.06] >= Crit [5.68] >= Versatility [5.31]",
	},
	-- DRUID GUARDIAN --
	["104"] = {
		["NOX"] = "Stamina [12.04] > Agility [9.04] > Mastery [7.54] > Versatility [6.04] > Crit [4.54] >= Haste [4.32]",
	},
	-- DRUID RESTORATION --
	["105"] = {
		["NOX"] = "Intellect [9.02] > Mastery [7.52] > Haste [6.02] > Crit [4.52] > Versatility [3.02]",
	},
	-- DK BLOOD --
	["250"] = {
		["NOX"] = "Stamina [12.08] > Strength [9.08] > Haste [7.58] > Versatility [6.08] > Mastery [4.58] > Crit [3.08]",
	},
	-- DK FROST --
	["251"] = {
		["NOX"] = "Strength [9.01] > Crit [7.51] >= Haste [7.13] >= Mastery [6.76] >= Versatility [6.38]",
	},
	-- DK UNHOLY --
	["252"] = {
		["NOX"] = "Strength [9.04] > Mastery [7.54] > Crit [6.04] > Haste [4.54] > Versatility [3.04]",
	},
	-- HUNTER BEAST MASTERY --
	["253"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] >= Crit [7.24] >= Versatility [7.09] >= Mastery [6.94]",
	},
	-- HUNTER MARKSMANSHIP --
	["254"] = {
		["NOX"] = "Agility [9.05] > Haste [7.55] = Versatility [7.55] > Crit [6.05] >= Mastery [5.67]",
	},
	-- HUNTER SURVIVAL --
	["255"] = {
		["NOX"] = "Agility [9.06] > Haste [7.56] > Versatility [6.06] > Crit [4.56] > Mastery [3.06]",
	},
	-- PRIEST DISCIPLINE --
	["256"] = {
		["NOX"] = "Intellect [9.08] > Haste [7.58] > Mastery [6.08] > Versatility [4.58] >= Crit [4.43]",
	},
	-- PRIEST HOLY --
	["257"] = {
		["NOX"] = "Intellect [9.01] > Mastery [7.51] > Crit [6.01] > Haste [4.51] > Versatility [3.01]",
	},
	-- PRIEST SHADOW --
	["258"] = {
		["NOX"] = "Intellect [9.04] > Haste [7.54] > Crit [6.04] > Versatility [4.54] > Mastery [1.54]",
	},
	-- ROGUE ASSASSINATION --
	["259"] = {
		["NOX"] = "Agility [9.05] > Haste [7.55] > Crit [6.05] > Mastery [4.55] > Versatility [3.05]",
	},
	-- ROGUE OUTLAW --
	["260"] = {
		["NOX"] = "Agility [9.07] > Versatility [7.57] > Haste [6.07] > Crit [4.57] >= Mastery [4.35]",
	},
	-- ROGUE SUBTLETY --
	["261"] = {
		["NOX"] = "Agility [9.01] > Haste [7.51] > Mastery [6.01] >= Versatility [5.79] > Crit [4.51]",
	},
	-- SHAMAN ELEMENTAL --
	["262"] = {
		["NOX"] = "Intellect [9.07] > Crit [7.57] > Haste [6.07] >= Versatility [5.85] >= Mastery [5.62]",
	},
	-- SHAMAN ENHANCEMENT --
	["263"] = {
		["NOX"] = "Agility [9.02] > Haste [7.52] > Crit [6.02] > Versatility [4.52] > Mastery [3.02]",
	},
	-- SHAMAN RESTORATION --
	["264"] = {
		["NOX"] = "Intellect [9.03] > Crit [7.53] > Versatility [6.03] > Haste [4.53] >= Mastery [4.31]",
	},
	-- WARLOCK AFFLICTION --
	["265"] = {
		["NOX"] = "Intellect [9.07] > Mastery [7.57] = Haste [7.57] > Crit [6.07] > Versatility [4.57]",
	},
	-- WARLOCK DEMONOLOGY --
	["266"] = {
		["NOX"] = "Intellect [9.07] > Mastery [7.57] > Haste [6.07] > Crit [4.57] >= Versatility [4.42]",
	},
	-- WARLOCK DESTRUCTION --
	["267"] = {
		["NOX"] = "Intellect [9.08] > Haste [7.58] >= Crit [7.21] > Versatility [4.58] > Mastery [3.08]",
	},
	-- MONK BREWMASTER --
	["268"] = {
		["NOX"] = "Stamina [12.06] > Agility [9.06] > Crit [7.56] > Versatility [6.06] > Mastery [4.56] > Haste [3.06]",
	},
	-- MONK WINDWALKER --
	["269"] = {
		["NOX"] = "Agility [9.01] > Versatility [7.51] > Mastery [6.01] > Crit [4.51] > Haste [3.01]",
	},
	-- MONK MISTWEAVER --
	["270"] = {
		["NOX"] = "Intellect [9.06] > Crit [7.56] > Versatility [6.06] > Haste [4.56] > Mastery [3.06]",
	},
	-- DEMON HUNTER HAVOC --
	["577"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] >= Versatility [7.17] > Crit [6.04] > Mastery [4.54]",
	},
	-- DEMON HUNTER VENGEANCE --
	["581"] = {
		["NOX"] = "Stamina [12.03] > Agility [9.03] > Haste [7.53] > Versatility [6.03] > Mastery [4.53] > Crit [3.03]",
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
