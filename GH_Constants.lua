local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

GearHelper.defaultSettings = {
    profile = {
        addonEnabled = true,
        sellGreyItems = true,
        autoAcceptQuestReward = false,
        autoEquipLooted = {
            actual = false,
            previous = false
        },
        autoEquipWhenSwitchSpe = false,
        weightTemplate = "NOX",
        lastWeightTemplate = "",
        autoRepair = 0,
        autoInvite = true,
        autoTell = true,
        inviteMessage = "+GH123-",
        askLootRaid = true,
        printWhenEquip = true,
        debug = false,
        CW = {},
        iLvlOption = false,
        iLvlWeight = 10,
        includeSocketInCompute = true,
        computeNotEquippable = true,
        whisperAlert = true,
        sayMyName = true,
        minimap = {hide = false, isLock = false},
        bossesKilled = true,
        ilvlCharFrame = true,
        ilvlInspectFrame = true,
        inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil},
        defaultWeightForStat = 1
    },
    global = {
        ItemCache = {},
        itemWaitList = {},
        myNames = "",
        buildVersion = 7,
        equipLocInspect = {},
        phrases = {
            enUS = {
                demande4 = L["demande4enUS"],
                demande42 = L["demande4enUS2"],
                rep = L["repenUS"],
                rep2 = L["repenUS2"]
            },
            frFR = {
                demande4 = L["demande4frFR"],
                demande42 = L["demande4frFR2"],
                rep = L["repfrFR"],
                rep2 = L["repfrFR2"]
            },
            deDE = {
                demande4 = L["demande4deDE"],
                demande42 = L["demande4deDE2"],
                rep = L["repdeDE"],
                rep2 = L["repdeDE2"]
            },
            esES = {
                demande4 = L["demande4esES"],
                demande42 = L["demande4esES2"],
                rep = L["repesES"],
                rep2 = L["repesES2"]
            },
            esMX = {
                demande4 = L["demande4esMX"],
                demande42 = L["demande4esMX2"],
                rep = L["repesMX"],
                rep2 = L["repesMX2"]
            },
            itIT = {
                demande4 = L["demande4itIT"],
                demande42 = L["demande4itIT2"],
                rep = L["repitIT"],
                rep2 = L["repitIT2"]
            },
            koKR = {
                demande4 = L["demande4koKR"],
                demande42 = L["demande4koKR2"],
                rep = L["repkoKR"],
                rep2 = L["repkoKR2"]
            },
            ptBR = {
                demande4 = L["demande4ptBR"],
                demande42 = L["demande4ptBR2"],
                rep = L["repptBR"],
                rep2 = L["repptBR2"]
            },
            ruRU = {
                demande4 = L["demande4ruRU"],
                demande42 = L["demande4ruRU2"],
                rep = L["repruRU"],
                rep2 = L["repruRU2"]
            },
            zhCN = {
                demande4 = L["demande4zhCN"],
                demande42 = L["demande4zhCN2"],
                rep = L["repzhCN"],
                rep2 = L["repzhCN2"]
            },
            zhTW = {
                demande4 = L["demande4zhTW"],
                demande42 = L["demande4zhTW2"],
                rep = L["repzhTW"],
                rep2 = L["repzhTW2"]
            }
        }    
    }
}

GearHelperVars = {
    version = GetAddOnMetadata("GearHelper", "Version"),
    prefixAddon = "GeARHeLPeRPReFIX",
    addonTruncatedVersion = 3,
    waitSpeTimer = nil,
    charInventory = {
        [INVSLOT_HEAD] = 0,
        [INVSLOT_NECK] = 0,
        [INVSLOT_SHOULDER] = 0,
        [INVSLOT_CHEST] = 0,
        [INVSLOT_WAIST] = 0,
        [INVSLOT_LEGS] = 0,
        [INVSLOT_FEET] = 0,
        [INVSLOT_WRIST] = 0,
        [INVSLOT_HAND] = 0,
        [INVSLOT_FINGER1] = 0,
        [INVSLOT_FINGER2] = 0,
        [INVSLOT_TRINKET1] = 0,
        [INVSLOT_TRINKET2] = 0,
        [INVSLOT_MAINHAND] = 0,
        [INVSLOT_OFFHAND] = 0
    },
    coroutineQueue = {},
}

GearHelper.slotToNameMapping = {
    [INVSLOT_AMMO] = "AMMOSLOT", 
    [INVSLOT_HEAD] = "HEADSLOT", 
    [INVSLOT_NECK] = "NECKSLOT", 
    [INVSLOT_SHOULDER] = "SHOULDERSLOT", 
    [INVSLOT_BODY] = "SHIRTSLOT", 
    [INVSLOT_CHEST] = "CHESTSLOT", 
    [INVSLOT_WAIST] = "WAISTSLOT", 
    [INVSLOT_LEGS] = "LEGSSLOT", 
    [INVSLOT_FEET] = "FEETSLOT", 
    [INVSLOT_WRIST] = "WRISTSLOT", 
    [INVSLOT_HAND] = "HANDSSLOT", 
    [INVSLOT_FINGER1] = "FINGER0SLOT", 
    [INVSLOT_FINGER2] = "FINGER1SLOT", 
    [INVSLOT_TRINKET1] = "TRINKET0SLOT", 
    [INVSLOT_TRINKET2] = "TRINKET1SLOT", 
    [INVSLOT_BACK] = "BACKSLOT", 
    [INVSLOT_MAINHAND] = "MAINHANDSLOT", 
    [INVSLOT_OFFHAND] = "SECONDARYHANDSLOT", 
    [INVSLOT_RANGED] = "RANGEDSLOT", 
    [INVSLOT_TABARD] = "TABARDSLOT", 
}

-- WEAPON both hand for Dual Wield class / spe
-- Dual Wield = Rogue / DH / Frost DK / Fury War / Enhancement Shaman / Brewmaster and Windwalker Monk = IsPlayerSpell(674)
GearHelper.operators = {
    ["UNDEFINED"] = 0,
    ["OR"] = 1,
    ["AND"] = 2
}

GearHelper.itemSlot = {
    INVTYPE_AMMO = {
        slots = { INVSLOT_AMMO },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_HEAD = {
        slots = { INVSLOT_HEAD },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_NECK = {
        slots = { INVSLOT_NECK },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_SHOULDER = {
        slots = { INVSLOT_SHOULDER },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_BODY = {
        slots = { INVSLOT_BODY },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_CHEST = {
        slots = { INVSLOT_CHEST },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_ROBE = {
        slots = { INVSLOT_CHEST },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_WAIST = {
        slots = { INVSLOT_WAIST },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_LEGS = {
        slots = { INVSLOT_LEGS },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_FEET = {
        slots = { INVSLOT_FEET },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_WRIST = {
        slots = { INVSLOT_WRIST },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_HAND = {
        slots = { INVSLOT_HAND },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_FINGER = {
        slots = { INVSLOT_FINGER1, INVSLOT_FINGER2 },
        operator = GearHelper.operators.OR
    },
    INVTYPE_TRINKET = {
        slots = {INVSLOT_TRINKET1, INVSLOT_TRINKET2},
        operator = GearHelper.operators.OR
    },
    INVTYPE_CLOAK = {
        slots = { INVSLOT_BACK },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_SHIELD = {
        slots = { INVSLOT_OFFHAND },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_WEAPON = {
        slots = { INVSLOT_MAINHAND },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_2HWEAPON = {
        slots = {INVSLOT_MAINHAND, INVSLOT_OFFHAND},
        operator = GearHelper.operators.AND
    },
    INVTYPE_WEAPONMAINHAND = {
        slots = {INVSLOT_MAINHAND, INVSLOT_OFFHAND},
        operator = GearHelper.operators.AND
    },
    INVTYPE_WEAPONOFFHAND = {
        slots = { INVSLOT_OFFHAND },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_HOLDABLE = {
        slots = { INVSLOT_OFFHAND },
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_RANGED = {
        slots = {INVSLOT_MAINHAND, INVSLOT_OFFHAND},
        operator = GearHelper.operators.AND
    },
    INVTYPE_RANGEDRIGHT = {
        slots = { INVSLOT_MAINHAND },
        operator = GearHelper.operators.UNDEFINED
    }
}