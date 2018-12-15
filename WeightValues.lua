GearHelper.itemSlot = {INVTYPE_AMMO = "Ammo", INVTYPE_HEAD = "Head", INVTYPE_NECK = "Neck", INVTYPE_SHOULDER = "Shoulder", INVTYPE_BODY = "Body", INVTYPE_CHEST = "Chest", INVTYPE_ROBE = "Chest", INVTYPE_WAIST = "Waist", INVTYPE_LEGS = "Legs", INVTYPE_FEET = "Feet", INVTYPE_WRIST = "Wrist", INVTYPE_HAND = "Hands", INVTYPE_FINGER = {"Finger0", "Finger1"}, INVTYPE_TRINKET = {"Trinket0", "Trinket1"}, INVTYPE_CLOAK = "Back", INVTYPE_SHIELD = "SecondaryHand", INVTYPE_WEAPON = {"MainHand", "SecondaryHand"}, INVTYPE_2HWEAPON = "MainHand", INVTYPE_WEAPONMAINHAND = "MainHand", INVTYPE_WEAPONOFFHAND = "SecondaryHand", INVTYPE_HOLDABLE = "SecondaryHand", INVTYPE_RANGED = "MainHand", INVTYPE_RANGEDRIGHT = "MainHand"}

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
		["NOX"] = "Intellect [9.08] > Crit [7.58] > Mastery [6.08] > Versatility [4.58] >= Haste [4.43]"
	},
	-- MAGE FROST --
	["64"] = {
		["NOX"] = "Intellect [9.07] > Crit [7.57] > Haste [6.07] > Versatility [4.57] >= Mastery [4.27]"
	},
	-- PALADIN HOLY --
	["65"] = {
		["NOX"] = "Intellect [9.01] > Crit [7.51] > Mastery [6.01] >= Versatility [5.71] > Haste [3.01]"
	},
	-- PALADIN PROTECTION --
	["66"] = {
		["NOX"] = "Stamina [12.06] > Strength [9.06] > Haste [7.56] > Versatility [6.06] >= Mastery [5.76] > Crit [3.06]"
	},
	-- PALADIN RETRIBUTION --
	["70"] = {
		["NOX"] = "Strength [9.04] > Haste [7.54] > Crit [6.04] >= Versatility [5.82] > Mastery [4.54]"
	},
	-- WARRIOR ARMS --
	["71"] = {
		["NOX"] = "Strength [9.02] > Crit [7.52] > Haste [6.02] > Versatility [4.52] > Mastery [3.02]"
	},
	-- WARRIOR FURY --
	["72"] = {
		["NOX"] = "Strength [9.05] > Crit [7.55] > Haste [6.05] > Versatility [4.55] > Mastery [3.05]"
	},
	-- WARRIOR PROTECTION --
	["73"] = {
		["NOX"] = "Stamina [12.03] > Strength [9.03] > Haste [7.53] > Mastery [6.03] >= Versatility [5.73] > Crit [3.03]"
	},
	-- DRUID BALANCE --
	["102"] = {
		["NOX"] = "Intellect [9.05] > Haste [7.55] > Crit [6.05] >= Versatility [5.75] > Mastery [3.05]"
	},
	-- DRUID FERAL --
	["103"] = {
		["NOX"] = "Agility [9.06] > Haste [7.56] > Mastery [6.06] >= Crit [5.68] >= Versatility [5.31]"
	},
	-- DRUID GUARDIAN --
	["104"] = {
		["NOX"] = "Stamina [12.01] > Agility [9.01] > Mastery [7.51] > Versatility [6.01] > Crit [4.51] >= Haste [4.29]"
	},
	-- DRUID RESTORATION --
	["105"] = {
		["NOX"] = "Intellect [9.06] > Mastery [7.56] > Haste [6.06] > Crit [4.56] > Versatility [3.06]"
	},
	-- DK BLOOD --
	["250"] = {
		["NOX"] = "Stamina [12.04] > Strength [9.04] > Haste [7.54] > Versatility [6.04] > Mastery [4.54] > Crit [3.04]"
	},
	-- DK FROST --
	["251"] = {
		["NOX"] = "Strength [9.02] > Crit [7.52] >= Haste [7.14] >= Mastery [6.77] >= Versatility [6.39]"
	},
	-- DK UNHOLY --
	["252"] = {
		["NOX"] = "Strength [9.03] > Mastery [7.53] > Crit [6.03] > Haste [4.53] > Versatility [3.03]"
	},
	-- HUNTER BEAST MASTERY --
	["253"] = {
		["NOX"] = "Agility [9.01] > Haste [7.51] >= Crit [7.21] >= Versatility [7.06] >= Mastery [6.91]"
	},
	-- HUNTER MARKSMANSHIP --
	["254"] = {
		["NOX"] = "Agility [9.03] > Haste [7.53] = Versatility [7.53] > Crit [6.03] >= Mastery [5.66]"
	},
	-- HUNTER SURVIVAL --
	["255"] = {
		["NOX"] = "Agility [9.06] > Haste [7.56] > Versatility [6.06] > Crit [4.56] > Mastery [3.06]"
	},
	-- PRIEST DISCIPLINE --
	["256"] = {
		["NOX"] = "Intellect [9.08] > Haste [7.58] > Mastery [6.08] > Versatility [4.58] >= Crit [4.43]"
	},
	-- PRIEST HOLY --
	["257"] = {
		["NOX"] = "Intellect [9.01] > Mastery [7.51] > Crit [6.01] > Haste [4.51] > Versatility [3.01]"
	},
	-- PRIEST SHADOW --
	["258"] = {
		["NOX"] = "Intellect [9.03] > Haste [7.53] > Crit [6.03] > Versatility [4.53] > Mastery [1.53]"
	},
	-- ROGUE ASSASSINATION --
	["259"] = {
		["NOX"] = "Agility [9.06] > Haste [7.56] > Crit [6.06] > Mastery [4.56] > Versatility [3.06]"
	},
	-- ROGUE OUTLAW --
	["260"] = {
		["NOX"] = "Agility [9.07] > Versatility [7.57] > Haste [6.07] > Crit [4.57] >= Mastery [4.35]"
	},
	-- ROGUE SUBTLETY --
	["261"] = {
		["NOX"] = "Agility [9.05] > Haste [7.55] > Mastery [6.05] >= Versatility [5.83] > Crit [4.55]"
	},
	-- SHAMAN ELEMENTAL --
	["262"] = {
		["NOX"] = "Intellect [9.05] > Crit [7.55] > Haste [6.05] >= Versatility [5.83] >= Mastery [5.6]"
	},
	-- SHAMAN ENHANCEMENT --
	["263"] = {
		["NOX"] = "Agility [9.01] > Haste [7.51] > Crit [6.01] > Versatility [4.51] > Mastery [3.01]"
	},
	-- SHAMAN RESTORATION --
	["264"] = {
		["NOX"] = "Intellect [9.05] > Crit [7.55] > Versatility [6.05] > Haste [4.55] >= Mastery [4.33]"
	},
	-- WARLOCK AFFLICTION --
	["265"] = {
		["NOX"] = "Intellect [9.05] > Mastery [7.55] = Haste [7.55] > Crit [6.05] > Versatility [4.55]"
	},
	-- WARLOCK DEMONOLOGY --
	["266"] = {
		["NOX"] = "Intellect [9.01] > Mastery [7.51] > Haste [6.01] > Crit [4.51] >= Versatility [4.36]"
	},
	-- WARLOCK DESTRUCTION --
	["267"] = {
		["NOX"] = "Intellect [9.04] > Haste [7.54] >= Crit [7.17] > Versatility [4.54] > Mastery [3.04]"
	},
	-- MONK BREWMASTER --
	["268"] = {
		["NOX"] = "Stamina [12.04] > Agility [9.04] > Crit [7.54] > Versatility [6.04] > Mastery [4.54] > Haste [3.04]"
	},
	-- MONK WINDWALKER --
	["269"] = {
		["NOX"] = "Agility [9.03] > Versatility [7.53] > Mastery [6.03] > Crit [4.53] > Haste [3.03]"
	},
	-- MONK MISTWEAVER --
	["270"] = {
		["NOX"] = "Intellect [9.08] > Crit [7.58] > Versatility [6.08] > Haste [4.58] > Mastery [3.08]"
	},
	-- DEMON HUNTER HAVOC --
	["577"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] >= Versatility [7.17] > Crit [6.04] > Mastery [4.54]"
	},
	-- DEMON HUNTER VENGEANCE --
	["581"] = {
		["NOX"] = "Stamina [12.08] > Agility [9.08] > Haste [7.58] > Versatility [6.08] > Mastery [4.58] > Crit [3.08]"
	}
}

function GearHelper:InitTemplates()
	for spec, templates in pairs(rawValues) do
		for templateID, stats in pairs(templates) do
			ParseDefaultValues(stats, spec, templateID)
		end
	end
end

--[[

local pawnString = "( Pawn: v1: \"PvE-Demon_Hunter-Havoc-Noxxic\": Class=DemonHunter, Spec=1, CritRating=6.04, MasteryRating=4.54, Agility=9.04, HasteRating=7.54, Versatility=7.17)"

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local pawnSplit = split(pawnString, ",")

for key, value in pairs(pawnSplit) do
    print(key..'='..value)
end

---------------------------
-- print -->
---- 1=( Pawn: v1: "PvE-Demon_Hunter-Havoc-Noxxic": Class=DemonHunter
---- 2= Spec=1
---- 3= CritRating=6.04
---- 4= MasteryRating=4.54
---- 5= Agility=9.04
---- 6= HasteRating=7.54
---- 7= Versatility=7.17)

]] --
