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

    -- Pattern is : "Word > [value] Word > [value]"
    for word in string.gmatch(rawCopy, "%S+") do
        if count == 1 then
            lastWord = word
            if lastWord == "Crit" then
                lastWord = "CriticalStrike"
            end

            if lastWord == "OffHandDamage" or "Off-Hand-Weapon-Dps" == lastWord then
                lastWord = "OffHandDps"
            end

            if lastWord == "MainHandDamage" or "Weapon-Dps" == lastWord then
                lastWord = "MainHandDps"
            end
        elseif count == 2 then
            -- continue
        elseif count == 3 then
            -- remove first and last char from word
            word = string.sub(word, 2, -2) -- remove first and last char from word
            if tmpTemplate[lastWord] then
                tmpTemplate[lastWord] = tonumber(word)
            end
            if tmpTemplate.Max < tonumber(word) then
                tmpTemplate.Max = tonumber(word)
                print(lastWord, word) -- debug
            end
        end
        count = count + 1
        if count > 3 then
            count = 1
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
        ["NOX"] = "Stamina > [-0.05] Attack-Power > [3.34] Mastery > [3.83] Versatility > [4.23] Haste > [3] Armor > [-0.05] Bonus-Armor > [-0.04] Weapon-Dps > [20.34] Leech > [-0.06] Str > [6.19] Crit > [4.29]"
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = "Attack-Power > [5.25] Weapon-Dps > [21.93] Haste > [6.14] Str > [7.55] Crit > [6.27] OffHandDps > [9.51] Mastery > [6.27] Versatility > [5.17]"
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = "Weapon-Dps > [33.58] Crit > [5.15] Str > [6.67] Mastery > [4.56] Attack-Power > [5.6] Haste > [5.34] Versatility > [5.39]"
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = "Attack-Power > [6.12] Agility > [6.25] Versatility > [4.33] Weapon-Dps > [30.01] Crit > [4.5] Mastery > [4.13] Haste > [4.32] OffHandDps > [6.57]"
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = "Agility > [2.84] Attack-Power > [2.85] Bonus-Armor > [-0.02] Haste > [1.72] Armor > [-0.03] Weapon-Dps > [15.32] Crit > [2.54] Mastery > [1.84] Versatility > [1.56] Stamina > [-0.02] OffHandDps > [1.89] Leech > [-0.02]"
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = "Spell-Power > [6.79] Crit > [4.56] Mastery > [5.92] Haste > [4.82] Versatility > [4.5] Intellect > [7.54]"
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = "Attack-Power > [6.44] Weapon-Dps > [37.94] Agility > [6.75] Mastery > [4.69] Versatility > [4.35] Haste > [4.68] Crit > [4.13]"
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = "Haste > [2.3] Leech > [-0.03] Agility > [3.99] Versatility > [2.74] Armor > [0.04] Weapon-Dps > [23.95] Stamina > [0.01] Crit > [2.97] Mastery > [2.26] Attack-Power > [4.02]"
    },
    -- DRUID RESTORATION --
    [105] = {
        ["NOX"] = "Crit > [6.57] Haste > [6.59] Intellect > [7.21] Mastery > [6.61] Versatility > [6.54]"
    },
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = "Haste > [3.42] Versatility > [4.23] Weapon-Dps > [23.64] Attack-Power > [6.45] Agility > [6.75] Mastery > [4.07] Crit > [4.31]"
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = "Mastery > [4.39] Versatility > [4.54] Crit > [4.32] Attack-Power > [5.96] Weapon-Dps > [35.68] Haste > [4.47] Agility > [6.26]"
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = "Haste > [2.96] Versatility > [4.3] Crit > [4.74] Agility > [6.91] Weapon-Dps > [32.45] Mastery > [2.37] Attack-Power > [6.56]"
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = "Mastery > [5.27] Spell-Power > [6.09] Versatility > [4.6] Intellect > [6.84] Haste > [3.2] Crit > [4.36]"
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = "Mastery > [4.45] Versatility > [4.49] Crit > [3.45] Haste > [3.32] Intellect > [7.56] Spell-Power > [6.81]"
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = "Mastery > [4.47] Versatility > [4.71] Crit > [1.42] Haste > [4.82] Intellect > [7.28] Spell-Power > [6.59]"
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = "Crit > [1.97] Weapon-Dps > [15.91] Armor > [-0.41] Haste > [2.08] Leech > [0.05] Versatility > [2] Stamina > [0.06] Mastery > [0.93] Attack-Power > [2.67] Bonus-Armor > [-0.38] Agility > [2.84]"
    },
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = "Attack-Power > [5.71] Haste > [3.29] Agility > [6] Weapon-Dps > [34.14] Mastery > [3.85] Versatility > [3.82] Crit > [3.67] Stamina > [0.25]"
    },
    -- MONK MISTWEAVER --
    [270] = {
        ["NOX"] = "Crit > [6.01] Haste > [3.01] Intellect > [7.51] Mastery > [1.51] Versatility > [4.51]"
    },
    -- PALADIN HOLY --
    [65] = {
        ["NOX"] = "Crit > [6.18] Haste > [6.56] Intellect > [6.58] Mastery > [6.42] Versatility > [6.22]"
    },
    -- PALADIN PROTECTION --
    [66] = {
        ["NOX"] = "Stamina > [-0.01] Armor > [0] Versatility > [3.08] Attack-Power > [4.46] Leech > [-0.01] Haste > [3.06] Bonus-Armor > [-0.01] Crit > [3] Weapon-Dps > [26.75] Str > [4.68] Mastery > [3.46]"
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = "Haste > [4.23] Crit > [4.68] Mastery > [4.62] Versatility > [4.42] Weapon-Dps > [36.24] Attack-Power > [5.96] Str > [6.25]"
    },
    -- PRIEST DISCIPLINE --
    [256] = {
        ["NOX"] = "Crit > [4.52] Haste > [6.02] Intellect > [7.52] Mastery > [4.48] Versatility > [4.48]"
    },
    -- PRIEST HOLY --
    [257] = {
        ["NOX"] = "Crit > [5.72] Haste > [6.11] Intellect > [7.52] Mastery > [5.11] Versatility > [5.72]"
    },
    -- PRIEST SHADOW --
    [258] = {
        ["NOX"] = "Haste > [5.45] Versatility > [5.2] Mastery > [5.24] Intellect > [7.17] Crit > [5.75] Spell-Power > [6.55]"
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = "Weapon-Dps > [36.02] Attack-Power > [6.51] Crit > [4.78] Versatility > [4.45] Haste > [4.35] Agility > [7] OffHandDps > [3.04] Mastery > [5.41]"
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = "Crit > [3.5] Haste > [3.84] Mastery > [2.89] OffHandDps > [4.86] Versatility > [4.46] Attack-Power > [5.95] Weapon-Dps > [31.07] Agility > [6.43]"
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = "Haste > [2.82] Agility > [6.58] OffHandDps > [1.56] Crit > [4.01] Weapon-Dps > [34.9] Attack-Power > [6.14] Mastery > [3.76] Versatility > [4.08]"
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = "Versatility > [4.5] Crit > [3.81] Haste > [4.32] Intellect > [7.6] Spell-Power > [6.89] Mastery > [4.05]"
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = "Versatility > [5.03] OffHandDps > [13.42] Mastery > [5.21] Haste > [5.47] Weapon-Dps > [33.03] Agility > [8.35] Attack-Power > [7.79] Crit > [5.24]"
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = "Crit > [4.08] Haste > [3.67] Intellect > [5.58] Mastery > [3.67] Versatility > [4.08]"
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = "Intellect > [6.74] Crit > [4.65] Mastery > [4.43] Versatility > [4.54] Spell-Power > [5.97] Haste > [3.99]"
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = "Versatility > [4.74] Spell-Power > [4.73] Crit > [4.86] Haste > [4.81] Intellect > [5.32] Stamina > [0.9] Mastery > [4.37]"
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = "Versatility > [4.65] Crit > [4.8] Spell-Power > [5.99] Intellect > [6.71] Haste > [4.2] Mastery > [4.92]"
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = "Versatility > [5.18] Attack-Power > [6.05] Crit > [5.86] Haste > [3.65] Mastery > [4.61] Str > [6.99] Weapon-Dps > [36.59]"
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = "Versatility > [4.84] Haste > [3.12] Str > [6.11] Mastery > [5.45] OffHandDps > [10.77] Attack-Power > [5.73] Crit > [4.88] Weapon-Dps > [23.62]"
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = "Mastery > [2.88] Crit > [3.11] Stamina > [0.02] Str > [5.23] Versatility > [3.29] Leech > [-0.04] Bonus-Armor > [0.02] Weapon-Dps > [24.6] Armor > [0] Attack-Power > [4.12] Haste > [3.07]"
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
