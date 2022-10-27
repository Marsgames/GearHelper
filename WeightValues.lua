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
        ["NOX"] = "Strength [6.84] > Haste [4.81] = Mastery [4.81] >= Crit [4.79] > Versatility [3.86]"
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = "Strength [6.05] > Haste [4.17] >= Versatility [4.0] >= Crit [3.76] >= Mastery [3.64]"
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = "Agility [5.88] > Crit [3.47] >= Versatility [3.37] >= Haste [3.36] >= Mastery [3.23]"
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = "Agility [6.15] >= Haste [6.05] >= Versatility [5.65] > Mastery [5.05] > Crit [4.59]"
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = "Intellect [7.03] > Mastery [4.69] > Haste [3.76] >= Crit [3.56] = Versatility [3.56]"
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = "Agility [6.16] > Mastery [3.63] >= Crit [3.62] >= Haste [3.36] >= Versatility [3.31]"
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
        ["NOX"] = "Agility [6.39] > Crit [3.55] >= Versatility [3.35] >= Mastery [3.24] >= Haste [2.91]"
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = "Agility [5.79] > Mastery [3.67] >= Crit [3.61] >= Haste [3.57] >= Versatility [3.5]"
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = "Agility [6.18] > Crit [3.59] >= Versatility [3.3] > Haste [2.75] > Mastery [1.5]"
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = "Intellect [6.35] > Mastery [4.38] > Versatility [3.63] >= Crit [3.5] > Haste [1.56]"
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = "Intellect [7.11] > Haste [4.2] > Mastery [3.67] >= Versatility [3.6] > Crit [2.93]"
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = "Intellect [6.92] > Haste [4.22] > Versatility [3.74] >= Mastery [3.52] > Crit [1.19]"
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = "Versatility [6.11] >= Crit [6.06] > Mastery [4.56] >= Haste [4.3] >= Agility [3.9]"
    },
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = "Agility [5.66] > Crit [3.22] >= Mastery [3.02] >= Versatility [2.97] > Haste [2.18] > Stamina [0.18]"
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
        ["NOX"] = "Strength [6.03] > Mastery [3.83] >= Crit [3.63] >= Versatility [3.55] >= Haste [3.49]"
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
        ["NOX"] = "Intellect [6.78] > Crit [4.4] >= Haste [4.36] = Mastery [4.36] >= Versatility [4.17]"
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = "Agility [6.54] > Mastery [4.13] >= Crit [4.05] >= Haste [3.79] >= Versatility [3.42]"
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = "Agility [5.95] > Versatility [3.3] >= Crit [3.07] >= Haste [2.75] > Mastery [2.18]"
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = "Agility [6.18] > Versatility [3.46] >= Crit [3.24] >= Mastery [2.89] > Haste [2.17]"
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = "Intellect [7.09] > Versatility [3.57] >= Haste [3.39] >= Mastery [3.37] > Crit [2.92]"
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = "Agility [7.61] > Haste [4.45] >= Mastery [4.34] >= Crit [3.96] >= Versatility [3.85]"
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = "Intellect [5.58] > Crit [4.08] = Versatility [4.08] > Haste [3.67] = Mastery [3.67]"
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = "Intellect [6.22] > Crit [3.64] >= Mastery [3.59] >= Versatility [3.58] >= Haste [3.38]"
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = "Intellect [5.07] > Haste [3.82] >= Mastery [3.79] >= Crit [3.74] >= Versatility [3.68] > Stamina [0.87]"
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = "Intellect [6.22] > Crit [3.77] >= Mastery [3.62] = Versatility [3.62] >= Haste [3.6]"
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = "Strength [6.5] > Crit [4.39] >= Versatility [4.03] >= Mastery [3.77] > Haste [3.26]"
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = "Strength [5.62] > Mastery [4.29] > Versatility [3.69] >= Crit [3.63] > Haste [2.74]"
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = "Haste [6.08] > Crit [5.67] = Versatility [5.67] > Mastery [5.24] > Strength [4.83]"
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
