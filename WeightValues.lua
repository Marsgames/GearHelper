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

			if lastWord == "OffHandDamage" or "Off-Hand-Weapon-Dps" == lastWord then
				lastWord = "OffHandDps"
			end

			if lastWord == "MainHandDamage" or "Weapon-Dps" == lastWord then
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
    -- DEATH KNIGHT BLOOD --
    [250] = {
        ["NOX"] = "Stamina [9.07] > Strength [7.57] > Versatility [6.01] >= Haste [5.67] > Crit [4.77] >= Mastery [4.57]"
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = "Strength [7.03] > Crit [4.65] > Haste [3.99] >= Mastery [3.92] >= Versatility [3.61]"
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = "Strength [5.86] > Haste [3.66] >= Crit [3.4] = Versatility [3.4] >= Mastery [3.21]"
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = "Agility [5.9] > Versatility [3.51] >= Crit [3.35] >= Mastery [3.17] >= Haste [3.15]"
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = "Agility [6.15] >= Haste [6.05] >= Versatility [5.65] > Mastery [5.05] > Crit [4.59]"
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = "Intellect [7.01] > Mastery [4.71] > Versatility [3.93] >= Haste [3.91] >= Crit [3.64]"
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = "Agility [5.96] > Mastery [3.52] >= Crit [3.5] >= Haste [3.23] >= Versatility [3.19]"
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = "Stamina [7.82] >= Agility [7.54] > Versatility [6.04] > Mastery [5.63] > Haste [5.21] >= Crit [5.01]"
    },
    -- DRUID RESTORATION --
    [105] = {
        ["NOX"] = "Intellect [7.21] > Mastery [6.61] >= Haste [6.59] >= Crit [6.57] >= Versatility [6.54]"
    },
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = "Agility [5.99] > Crit [3.04] >= Haste [2.91] >= Versatility [2.85] >= Mastery [2.8]"
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = "Agility [5.9] > Mastery [3.48] >= Crit [3.34] = Haste [3.34] >= Versatility [3.28]"
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = "Agility [6.07] > Crit [3.57] >= Versatility [3.39] > Haste [2.89] > Mastery [1.48]"
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = "Intellect [6.21] > Versatility [3.58] >= Crit [3.42] >= Mastery [3.35] >= Haste [3.23]"
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = "Intellect [6.25] > Haste [3.49] >= Mastery [3.36] >= Versatility [3.11] > Crit [2.56]"
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = "Intellect [6.87] > Haste [3.77] >= Versatility [3.75] >= Mastery [3.6] > Crit [1.15]"
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = "Versatility [6.11] >= Crit [6.06] > Mastery [4.56] >= Haste [4.3] >= Agility [3.9]"
    },
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = "Agility [4.99] > Versatility [2.71] >= Mastery [2.41] >= Crit [2.34] > Haste [0.8] > Stamina [0.18]"
    },
    -- MONK MISTWEAVER --
    [270] = {
        ["NOX"] = "Intellect [7.51] > Crit [6.01] > Versatility [4.51] > Haste [3.01] > Mastery [1.51]"
    },
    -- PALADIN HOLY --
    [65] = {
        ["NOX"] = "Intellect [6.58] >= Haste [6.56] >= Mastery [6.42] >= Versatility [6.22] >= Crit [6.18]"
    },
    -- PALADIN PROTECTION --
    [66] = {
        ["NOX"] = "Strength [7.57] > Haste [6.07] > Mastery [5.26] = Versatility [5.26] > Crit [4.85]"
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = "Strength [5.55] > Mastery [3.37] >= Haste [3.1] >= Crit [3.03] >= Versatility [2.96]"
    },
    -- PRIEST DISCIPLINE --
    [256] = {
        ["NOX"] = "Intellect [7.52] > Haste [6.02] > Crit [4.52] >= Mastery [4.48] = Versatility [4.48]"
    },
    -- PRIEST HOLY --
    [257] = {
        ["NOX"] = "Intellect [7.52] > Haste [6.11] >= Crit [5.72] = Versatility [5.72] > Mastery [5.11]"
    },
    -- PRIEST SHADOW --
    [258] = {
        ["NOX"] = "Intellect [6.61] > Mastery [4.59] >= Crit [4.32] >= Haste [4.13] >= Versatility [4.0]"
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = "Agility [6.26] > Mastery [3.89] >= Haste [3.78] >= Crit [3.71] >= Versatility [3.36]"
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = "Agility [5.41] > Versatility [3.1] >= Crit [2.87] >= Haste [2.7] > Mastery [1.97]"
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = "Agility [6.38] > Versatility [3.44] > Mastery [3.02] >= Crit [2.98] > Haste [2.28]"
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = "Intellect [6.38] > Versatility [3.45] > Mastery [3.03] >= Haste [2.77] >= Crit [2.53]"
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = "Agility [7.61] > Haste [5.54] > Versatility [4.26] >= Crit [3.98] > Mastery [3.57]"
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = "Intellect [5.58] > Crit [4.08] = Versatility [4.08] > Haste [3.67] = Mastery [3.67]"
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = "Intellect [5.87] > Mastery [3.57] >= Crit [3.47] >= Versatility [3.42] >= Haste [3.3]"
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = "Intellect [5.36] > Mastery [3.79] >= Crit [3.73] >= Versatility [3.72] > Haste [3.23] > Stamina [1.15]"
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = "Intellect [6.79] > Haste [4.21] >= Crit [4.18] >= Versatility [3.96] >= Mastery [3.87]"
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = "Strength [5.84] > Crit [3.94] > Versatility [3.4] >= Mastery [3.36] >= Haste [3.02]"
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = "Strength [5.59] > Mastery [4.25] > Crit [3.47] >= Versatility [3.44] > Haste [2.83]"
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = "Haste [6.08] > Crit [5.67] = Versatility [5.67] > Mastery [5.24] > Strength [4.83]"
    },
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
