GearHelper.itemSlot = {
	INVTYPE_AMMO = {"Ammo"},
	INVTYPE_HEAD = {"Head"},
	INVTYPE_NECK = {"Neck"},
	INVTYPE_SHOULDER = {"Shoulder"},
	INVTYPE_BODY = {"Body"},
	INVTYPE_CHEST = {"Chest"},
	INVTYPE_ROBE = {"Chest"},
	INVTYPE_WAIST = {"Waist"},
	INVTYPE_LEGS = {"Legs"},
	INVTYPE_FEET = {"Feet"},
	INVTYPE_WRIST = {"Wrist"},
	INVTYPE_HAND = {"Hands"},
	INVTYPE_FINGER = {"Finger0", "Finger1"},
	INVTYPE_TRINKET = {"Trinket0", "Trinket1"},
	INVTYPE_CLOAK = {"Back"},
	INVTYPE_SHIELD = {"SecondaryHand"},
	INVTYPE_WEAPON = {
		WARRIOR = {
			["72"] = {"MainHand", "SecondaryHand"},
			["71"] = {"MainHand"},
			["73"] = {"MainHand"}
		},
		SHAMAN = {
			["263"] = {"MainHand", "SecondaryHand"},
			["262"] = {"MainHand"},
			["264"] = {"MainHand"}
		},
		HUNTER = {"MainHand"},
		DEATHKNIGHT = {
			["250"] = {"MainHand", "SecondaryHand"},
			["251"] = {"MainHand"},
			["252"] = {"MainHand"}
		},
		ROGUE = {"MainHand", "SecondaryHand"},
		DEMONHUNTER = {"MainHand", "SecondaryHand"},
		DRUID = {"MainHand"},
		MONK = {"MainHand"},
		WARLOCK = {"MainHand"},
		MAGE = {"MainHand"},
		PRIEST = {"MainHand"},
		PALADIN = {"MainHand"}
	},
	INVTYPE_2HWEAPON = {"MainHand", "SecondaryHand"},
	INVTYPE_WEAPONMAINHAND = {"MainHand"},
	INVTYPE_WEAPONOFFHAND = {"SecondaryHand"},
	INVTYPE_HOLDABLE = {"SecondaryHand"},
	INVTYPE_RANGED = {"MainHand", "SecondaryHand"},
	INVTYPE_RANGEDRIGHT = {"MainHand"}
}

local function ParseDefaultValues(rawValues, specID, templateID)
	GearHelper:BenchmarkCountFuncCall("ParseDefaultValues")
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
		["NOX"] = "Intellect [7.52] > Crit [6.02] > Haste [4.52] > Mastery [3.02] > Versatility [1.52]"
	},
	-- MAGE FIRE --
	["63"] = {
		["NOX"] = "Intellect [7.52] > Mastery [6.02] > Versatility [4.52] > Haste [3.02] > Crit [1.52]"
	},
	-- MAGE FROST --
	["64"] = {
		["NOX"] = "Intellect [7.55] > Mastery [6.05] >= Crit [5.67] > Versatility [3.05] > Haste [1.55]"
	},
	-- PALADIN HOLY --
	["65"] = {
		["NOX"] = "Intellect [7.53] > Crit [6.03] > Haste [4.53] > Versatility [3.03] > Mastery [1.53]"
	},
	-- PALADIN PROTECTION --
	["66"] = {
		["NOX"] = "Stamina [9.07] > Strength [7.57] > Haste [6.07] > Mastery [4.57] > Versatility [3.07] > Crit [1.57]"
	},
	-- PALADIN RETRIBUTION --
	["70"] = {
		["NOX"] = "Strength [7.57] > Haste [6.07] > Crit [4.57] = Mastery [4.57] = Versatility [4.57]"
	},
	-- WARRIOR ARMS --
	["71"] = {
		["NOX"] = "Haste [7.51] > Crit [6.01] > Strength [4.51] > Mastery [3.01] > Versatility [1.51]"
	},
	-- WARRIOR FURY --
	["72"] = {
		["NOX"] = "Strength [7.57] > Haste [6.07] > Mastery [4.57] > Versatility [3.07] > Crit [1.57]"
	},
	-- WARRIOR PROTECTION --
	["73"] = {
		["NOX"] = "Stamina [9.08] > Strength [7.58] > Haste [6.08] > Versatility [4.58] > Mastery [3.08] > Crit [1.58]"
	},
	-- DRUID BALANCE --
	["102"] = {
		["NOX"] = "Intellect [7.51] > Haste [6.01] > Mastery [4.51] > Crit [3.01] > Versatility [1.51]"
	},
	-- DRUID FERAL --
	["103"] = {
		["NOX"] = "Crit [7.56] > Mastery [6.06] > Haste [4.56] > Agility [3.06] > Versatility [1.56]"
	},
	-- DRUID GUARDIAN --
	["104"] = {
		["NOX"] = "Stamina [9.04] > Agility [7.54] > Mastery [6.04] > Versatility [4.54] > Haste [3.04] > Crit [1.54]"
	},
	-- DRUID RESTORATION --
	["105"] = {
		["NOX"] = "Intellect [7.51] > Mastery [6.01] > Haste [5.26] > Crit [4.51] > Versatility [3.76]"
	},
	-- DK BLOOD --
	["250"] = {
		["NOX"] = "Stamina [9.07] > Strength [7.57] > Versatility [6.07] > Haste [4.57] > Crit [3.07] > Mastery [1.57]"
	},
	-- DK FROST --
	["251"] = {
		["NOX"] = "Strength [7.52] > Mastery [6.02] > Crit [4.52] > Versatility [3.02] > Haste [1.52]"
	},
	-- DK UNHOLY --
	["252"] = {
		["NOX"] = "Strength [7.53] > Haste [6.03] > Crit [4.53] = Versatility [4.53] > Mastery [3.03]"
	},
	-- HUNTER BEAST MASTERY --
	["253"] = {
		["NOX"] = "Agility [7.56] > Haste [6.06] > Crit [4.56] > Mastery [3.06] > Versatility [1.56]"
	},
	-- HUNTER MARKSMANSHIP --
	["254"] = {
		["NOX"] = "Agility [7.54] > Mastery [6.04] > Haste [4.54] > Crit [3.04] > Versatility [1.54]"
	},
	-- HUNTER SURVIVAL --
	["255"] = {
		["NOX"] = "Agility [7.54] > Haste [6.04] > Crit [4.54] > Versatility [3.04] > Mastery [1.54]"
	},
	-- PRIEST DISCIPLINE --
	["256"] = {
		["NOX"] = "Intellect [7.52] > Haste [6.02] > Crit [4.52] = Mastery [4.52] = Versatility [4.52]"
	},
	-- PRIEST HOLY --
	["257"] = {
		["NOX"] = "Intellect [7.52] > Crit [6.02] = Mastery [6.02] > Versatility [4.52] > Haste [3.02]"
	},
	-- PRIEST SHADOW --
	["258"] = {
		["NOX"] = "Crit [7.51] = Haste [7.51] > Intellect [6.01] > Mastery [4.51] > Versatility [3.01]"
	},
	-- ROGUE ASSASSINATION --
	["259"] = {
		["NOX"] = "Agility [7.51] > Haste [6.01] > Crit [4.51] > Mastery [3.01] > Versatility [1.51]"
	},
	-- ROGUE OUTLAW --
	["260"] = {
		["NOX"] = "Agility [7.51] > Crit [6.01] > Haste [4.51] > Versatility [3.01] > Mastery [1.51]"
	},
	-- ROGUE SUBTLETY --
	["261"] = {
		["NOX"] = "Agility [7.56] > Crit [6.06] > Versatility [4.56] > Mastery [3.06] > Haste [1.56]"
	},
	-- SHAMAN ELEMENTAL --
	["262"] = {
		["NOX"] = "Intellect [7.56] > Crit [6.06] > Haste [4.56] > Versatility [3.06] > Mastery [1.56]"
	},
	-- SHAMAN ENHANCEMENT --
	["263"] = {
		["NOX"] = "Haste [7.51] > Mastery [6.01] > Crit [4.51] > Versatility [3.01] > Agility [1.51]"
	},
	-- SHAMAN RESTORATION --
	["264"] = {
		["NOX"] = "Intellect [7.58] > Crit [6.08] > Versatility [4.58] > Mastery [3.08] = Haste [3.08]"
	},
	-- WARLOCK AFFLICTION --
	["265"] = {
		["NOX"] = "Intellect [7.54] > Mastery [6.04] > Haste [4.54] > Crit [3.04] = Versatility [3.04]"
	},
	-- WARLOCK DEMONOLOGY --
	["266"] = {
		["NOX"] = "Intellect [7.56] > Haste [6.06] > Crit [4.56] = Mastery [4.56] > Versatility [3.06]"
	},
	-- WARLOCK DESTRUCTION --
	["267"] = {
		["NOX"] = "Mastery [7.51] >= Haste [7.13] > Crit [4.51] > Intellect [3.01] > Versatility [1.51]"
	},
	-- MONK BREWMASTER --
	["268"] = {
		["NOX"] = "Stamina [9.06] > Agility [7.56] > Crit [6.06] = Versatility [6.06] > Mastery [4.56] > Haste [3.06]"
	},
	-- MONK WINDWALKER --
	["269"] = {
		["NOX"] = "Agility [7.57] > Versatility [6.07] > Mastery [4.57] > Crit [3.07] > Haste [1.57]"
	},
	-- MONK MISTWEAVER --
	["270"] = {
		["NOX"] = "Intellect [7.51] > Crit [6.01] > Versatility [4.51] > Haste [3.01] > Mastery [1.51]"
	},
	-- DEMON HUNTER HAVOC --
	["577"] = {
		["NOX"] = "Versatility [7.58] > Crit [6.08] = Haste [6.08] > Agility [4.58] > Mastery [3.08]"
	},
	-- DEMON HUNTER VENGEANCE --
	["581"] = {
		["NOX"] = "Stamina [9.05] > Agility [7.55] > Haste [6.05] > Versatility [4.55] > Mastery [3.05] > Crit [1.55]"
	}
}

function GearHelper:InitTemplates()
	GearHelper:BenchmarkCountFuncCall("GearHelper:InitTemplates")
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
