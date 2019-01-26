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
		["NOX"] = "Intellect [9.01] > Versatility [7.51] >= Crit [7.36] >= Haste [7.21] > Mastery [4.51]"
	},
	-- MAGE FIRE --
	["63"] = {
		["NOX"] = "Intellect [9.06] > Crit [7.56] > Mastery [6.06] > Versatility [4.56] >= Haste [4.41]"
	},
	-- MAGE FROST --
	["64"] = {
		["NOX"] = "Intellect [9.04] > Crit [7.54] > Haste [6.04] > Versatility [4.54] >= Mastery [4.24]"
	},
	-- PALADIN HOLY --
	["65"] = {
		["NOX"] = "Intellect [9.03] > Crit [7.53] > Mastery [6.03] >= Versatility [5.73] > Haste [3.03]"
	},
	-- PALADIN PROTECTION --
	["66"] = {
		["NOX"] = "Stamina [12.06] > Strength [9.06] > Haste [7.56] > Versatility [6.06] >= Mastery [5.76] > Crit [3.06]"
	},
	-- PALADIN RETRIBUTION --
	["70"] = {
		["NOX"] = "Strength [9.06] > Haste [7.56] > Crit [6.06] >= Versatility [5.83] > Mastery [4.56]"
	},
	-- WARRIOR ARMS --
	["71"] = {
		["NOX"] = "Strength [9.01] > Crit [7.51] > Haste [6.01] > Versatility [4.51] > Mastery [3.01]"
	},
	-- WARRIOR FURY --
	["72"] = {
		["NOX"] = "Strength [9.05] > Crit [7.55] > Haste [6.05] > Versatility [4.55] > Mastery [3.05]"
	},
	-- WARRIOR PROTECTION --
	["73"] = {
		["NOX"] = "Stamina [12.02] > Strength [9.02] > Haste [7.52] > Mastery [6.02] >= Versatility [5.72] > Crit [3.02]"
	},
	-- DRUID BALANCE --
	["102"] = {
		["NOX"] = "Intellect [9.08] > Haste [7.58] > Crit [6.08] >= Versatility [5.78] > Mastery [3.08]"
	},
	-- DRUID FERAL --
	["103"] = {
		["NOX"] = "Agility [9.03] > Haste [7.53] > Mastery [6.03] >= Crit [5.66] >= Versatility [5.28]"
	},
	-- DRUID GUARDIAN --
	["104"] = {
		["NOX"] = "Stamina [12.07] > Agility [9.07] > Mastery [7.57] > Versatility [6.07] > Crit [4.57] >= Haste [4.35]"
	},
	-- DRUID RESTORATION --
	["105"] = {
		["NOX"] = "Intellect [9.03] > Mastery [7.53] > Haste [6.03] > Crit [4.53] > Versatility [3.03]"
	},
	-- DK BLOOD --
	["250"] = {
		["NOX"] = "Stamina [12.06] > Strength [9.06] > Haste [7.56] > Versatility [6.06] > Mastery [4.56] > Crit [3.06]"
	},
	-- DK FROST --
	["251"] = {
		["NOX"] = "Strength [9.01] > Crit [7.51] >= Haste [7.13] >= Mastery [6.76] >= Versatility [6.38]"
	},
	-- DK UNHOLY --
	["252"] = {
		["NOX"] = "Strength [9.08] > Mastery [7.58] > Crit [6.08] > Haste [4.58] > Versatility [3.08]"
	},
	-- HUNTER BEAST MASTERY --
	["253"] = {
		["NOX"] = "Agility [9.05] > Haste [7.55] >= Crit [7.25] >= Versatility [7.1] >= Mastery [6.95]"
	},
	-- HUNTER MARKSMANSHIP --
	["254"] = {
		["NOX"] = "Agility [9.08] > Haste [7.58] = Versatility [7.58] > Crit [6.08] >= Mastery [5.71]"
	},
	-- HUNTER SURVIVAL --
	["255"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] > Versatility [6.04] > Crit [4.54] > Mastery [3.04]"
	},
	-- PRIEST DISCIPLINE --
	["256"] = {
		["NOX"] = "Intellect [9.07] > Haste [7.57] > Mastery [6.07] > Versatility [4.57] >= Crit [4.42]"
	},
	-- PRIEST HOLY --
	["257"] = {
		["NOX"] = "Intellect [9.01] > Mastery [7.51] > Crit [6.01] > Haste [4.51] > Versatility [3.01]"
	},
	-- PRIEST SHADOW --
	["258"] = {
		["NOX"] = "Intellect [9.06] > Haste [7.56] > Crit [6.06] > Versatility [4.56] > Mastery [1.56]"
	},
	-- ROGUE ASSASSINATION --
	["259"] = {
		["NOX"] = "Agility [9.07] > Haste [7.57] > Crit [6.07] > Mastery [4.57] > Versatility [3.07]"
	},
	-- ROGUE OUTLAW --
	["260"] = {
		["NOX"] = "Agility [9.02] > Versatility [7.52] > Haste [6.02] > Crit [4.52] >= Mastery [4.29]"
	},
	-- ROGUE SUBTLETY --
	["261"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] > Mastery [6.04] >= Versatility [5.82] > Crit [4.54]"
	},
	-- SHAMAN ELEMENTAL --
	["262"] = {
		["NOX"] = "Intellect [9.02] > Crit [7.52] > Haste [6.02] >= Versatility [5.79] >= Mastery [5.57]"
	},
	-- SHAMAN ENHANCEMENT --
	["263"] = {
		["NOX"] = "Agility [9.04] > Haste [7.54] > Crit [6.04] > Versatility [4.54] > Mastery [3.04]"
	},
	-- SHAMAN RESTORATION --
	["264"] = {
		["NOX"] = "Intellect [9.02] > Crit [7.52] > Versatility [6.02] > Haste [4.52] >= Mastery [4.29]"
	},
	-- WARLOCK AFFLICTION --
	["265"] = {
		["NOX"] = "Intellect [9.07] > Mastery [7.57] = Haste [7.57] > Crit [6.07] > Versatility [4.57]"
	},
	-- WARLOCK DEMONOLOGY --
	["266"] = {
		["NOX"] = "Intellect [7.56] > Haste [6.06] > Crit [4.56] = Mastery [4.56] > Versatility [3.06]"
	},
	-- WARLOCK DESTRUCTION --
	["267"] = {
		["NOX"] = "Intellect [9.08] > Haste [7.58] >= Crit [7.21] > Versatility [4.58] > Mastery [3.08]"
	},
	-- MONK BREWMASTER --
	["268"] = {
		["NOX"] = "Stamina [12.06] > Agility [9.06] > Crit [7.56] > Versatility [6.06] > Mastery [4.56] > Haste [3.06]"
	},
	-- MONK WINDWALKER --
	["269"] = {
		["NOX"] = "Agility [9.08] > Versatility [7.58] > Mastery [6.08] > Crit [4.58] > Haste [3.08]"
	},
	-- MONK MISTWEAVER --
	["270"] = {
		["NOX"] = "Intellect [9.07] > Crit [7.57] > Versatility [6.07] > Haste [4.57] > Mastery [3.07]"
	},
	-- DEMON HUNTER HAVOC --
	["577"] = {
		["NOX"] = "Agility [9.08] > Haste [7.58] >= Versatility [7.21] > Crit [6.08] > Mastery [4.58]"
	},
	-- DEMON HUNTER VENGEANCE --
	["581"] = {
		["NOX"] = "Stamina [12.07] > Agility [9.07] > Haste [7.57] > Versatility [6.07] > Mastery [4.57] > Crit [3.07]"
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
