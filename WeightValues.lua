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
		["NOX"] = "Intellect [7.03] > Mastery [6.02] >= Crit [5.7] > Versatility [4.7] > Haste [4.0]"
	},
	-- MAGE FIRE --
	["63"] = {
		["NOX"] = "Intellect [6.15] > Haste [5.4] > Mastery [4.8] > Crit [4.0] = Versatility [4.0]"
	},
	-- MAGE FROST --
	["64"] = {
		["NOX"] = "Intellect [7.55] > Crit [7.0] > Versatility [6.53] >= Haste [6.49] > Mastery [6.02]"
	},
	-- PALADIN HOLY --
	["65"] = {
		["NOX"] = "Intellect [7.53] > Crit [6.53] > Haste [6.0] > Versatility [4.8] >= Mastery [4.5]"
	},
	-- PALADIN PROTECTION --
	["66"] = {
		["NOX"] = "Stamina [9.07] > Strength [7.57] > Haste [6.07] > Mastery [4.57] >= Versatility [4.27] > Crit [1.57]"
	},
	-- PALADIN RETRIBUTION --
	["70"] = {
		["NOX"] = "Strength [7.57] > Haste [4.6] >= Crit [4.59] >= Versatility [4.58] >= Mastery [4.57]"
	},
	-- WARRIOR ARMS --
	["71"] = {
		["NOX"] = "Haste [3.3] >= Crit [3.29] > Versatility [2.7] >= Mastery [2.6] > Strength [2.0]"
	},
	-- WARRIOR FURY --
	["72"] = {
		["NOX"] = "Weapon-Dps [7.5] > Crit [3.6] >= Off-Hand-Weapon-Dps [3.52] >= Mastery [3.15] >= Haste [3.0] >= Versatility [2.78] > Strength [2.0]"
	},
	-- WARRIOR PROTECTION --
	["73"] = {
		["NOX"] = "Stamina [9.08] > Strength [7.58] > Haste [6.08] > Versatility [4.58] > Mastery [3.08] > Crit [1.58]"
	},
	-- DRUID BALANCE --
	["102"] = {
		["NOX"] = "Intellect [7.51] > Haste [6.01] >= Crit [5.8] > Versatility [4.92] > Mastery [4.41]"
	},
	-- DRUID FERAL --
	["103"] = {
		["NOX"] = "Crit [7.56] > Mastery [6.46] > Versatility [5.92] > Haste [5.51] > Agility [5.1]"
	},
	-- DRUID GUARDIAN --
	["104"] = {
		["NOX"] = "Stamina [7.82] >= Agility [7.54] > Versatility [6.04] > Mastery [5.63] > Haste [5.21] >= Crit [5.01]"
	},
	-- DRUID RESTORATION --
	["105"] = {
		["NOX"] = "Mastery [6.82] >= Haste [6.59] >= Crit [6.48] >= Versatility [6.41] >= Intellect [6.3]"
	},
	-- DK BLOOD --
	["250"] = {
		["NOX"] = "Stamina [9.07] > Strength [7.57] > Versatility [6.01] >= Haste [5.67] > Crit [4.77] >= Mastery [4.57]"
	},
	-- DK FROST --
	["251"] = {
		["NOX"] = "Crit [6.02] = Mastery [6.02] > Haste [3.06] >= Versatility [3.02] >= Strength [3.01]"
	},
	-- DK UNHOLY --
	["252"] = {
		["NOX"] = "Haste [6.03] > Crit [5.43] > Versatility [4.73] >= Mastery [4.34] >= Strength [4.12]"
	},
	-- HUNTER BEAST MASTERY --
	["253"] = {
		["NOX"] = "Agility [7.56] > Crit [6.16] >= Haste [6.06] >= Versatility [6.02] >= Mastery [5.96]"
	},
	-- HUNTER MARKSMANSHIP --
	["254"] = {
		["NOX"] = "Versatility [6.1] >= Mastery [6.04] >= Crit [5.93] > Haste [5.51] > Agility [5.01]"
	},
	-- HUNTER SURVIVAL --
	["255"] = {
		["NOX"] = "Agility [7.54] > Haste [6.04] > Crit [4.54] >= Versatility [4.45] > Mastery [3.0]"
	},
	-- PRIEST DISCIPLINE --
	["256"] = {
		["NOX"] = "Intellect [7.52] > Haste [6.02] > Crit [4.52] >= Mastery [4.48] = Versatility [4.48]"
	},
	-- PRIEST HOLY --
	["257"] = {
		["NOX"] = ""
	},
	-- PRIEST SHADOW --
	["258"] = {
		["NOX"] = "Crit [7.51] = Haste [7.51] > Mastery [5.51] = Versatility [5.51] >= Intellect [5.5]"
	},
	-- ROGUE ASSASSINATION --
	["259"] = {
		["NOX"] = "Weapon-Dps [14.0] > Haste [5.7] >= Crit [5.6] >= Mastery [5.53] >= Versatility [5.45] > Agility [2.9] > Off-Hand-Weapon-Dps [1.5]"
	},
	-- ROGUE OUTLAW --
	["260"] = {
		["NOX"] = ""
	},
	-- ROGUE SUBTLETY --
	["261"] = {
		["NOX"] = "Weapon-Dps [12.9] > Crit [4.72] >= Versatility [4.65] >= Mastery [4.62] >= Haste [4.6] > Agility [2.6] > Off-Hand-Weapon-Dps [1.5]"
	},
	-- SHAMAN ELEMENTAL --
	["262"] = {
		["NOX"] = "Intellect [7.56] > Versatility [6.05] > Crit [4.5] > Haste [3.05] > Mastery [1.52]"
	},
	-- SHAMAN ENHANCEMENT --
	["263"] = {
		["NOX"] = "Haste [7.51] > Crit [6.51] >= Versatility [6.5] > Mastery [6.01] > Agility [1.51]"
	},
	-- SHAMAN RESTORATION --
	["264"] = {
		["NOX"] = "Intellect [7.58] > Crit [6.08] > Versatility [4.58] > Haste [3.08] = Mastery [3.08]"
	},
	-- WARLOCK AFFLICTION --
	["265"] = {
		["NOX"] = "Intellect [7.5] > Haste [6.01] >= Mastery [6.0] > Crit [3.1] >= Versatility [3.0]"
	},
	-- WARLOCK DEMONOLOGY --
	["266"] = {
		["NOX"] = "Haste [7.0] = Mastery [7.0] >= Intellect [6.98] > Crit [4.56] > Versatility [3.06]"
	},
	-- WARLOCK DESTRUCTION --
	["267"] = {
		["NOX"] = "Mastery [6.5] >= Haste [6.35] > Crit [4.5] > Intellect [4.0] = Versatility [4.0]"
	},
	-- MONK BREWMASTER --
	["268"] = {
		["NOX"] = "Stamina [9.06] > Agility [7.56] > Crit [6.06] >= Versatility [6.0] > Mastery [4.56] >= Haste [4.3]"
	},
	-- MONK WINDWALKER --
	["269"] = {
		["NOX"] = "Agility [7.57] > Versatility [6.07] > Mastery [4.57] >= Crit [4.3] > Haste [1.57]"
	},
	-- MONK MISTWEAVER --
	["270"] = {
		["NOX"] = "Intellect [7.51] > Crit [6.01] > Versatility [4.51] > Haste [3.01] > Mastery [1.51]"
	},
	-- DEMON HUNTER HAVOC --
	["577"] = {
		["NOX"] = "Agility [7.58] > Versatility [7.17] > Crit [6.73] >= Haste [6.66] > Mastery [6.21]"
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
