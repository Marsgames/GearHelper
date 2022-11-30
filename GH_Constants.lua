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
                demande4 = self.locals["demande4enUS"],
                demande42 = self.locals["demande4enUS2"],
                rep = self.locals["repenUS"],
                rep2 = self.locals["repenUS2"]
            },
            frFR = {
                demande4 = self.locals["demande4frFR"],
                demande42 = self.locals["demande4frFR2"],
                rep = self.locals["repfrFR"],
                rep2 = self.locals["repfrFR2"]
            },
            deDE = {
                demande4 = self.locals["demande4deDE"],
                demande42 = self.locals["demande4deDE2"],
                rep = self.locals["repdeDE"],
                rep2 = self.locals["repdeDE2"]
            },
            esES = {
                demande4 = self.locals["demande4esES"],
                demande42 = self.locals["demande4esES2"],
                rep = self.locals["repesES"],
                rep2 = self.locals["repesES2"]
            },
            esMX = {
                demande4 = self.locals["demande4esMX"],
                demande42 = self.locals["demande4esMX2"],
                rep = self.locals["repesMX"],
                rep2 = self.locals["repesMX2"]
            },
            itIT = {
                demande4 = self.locals["demande4itIT"],
                demande42 = self.locals["demande4itIT2"],
                rep = self.locals["repitIT"],
                rep2 = self.locals["repitIT2"]
            },
            koKR = {
                demande4 = self.locals["demande4koKR"],
                demande42 = self.locals["demande4koKR2"],
                rep = self.locals["repkoKR"],
                rep2 = self.locals["repkoKR2"]
            },
            ptBR = {
                demande4 = self.locals["demande4ptBR"],
                demande42 = self.locals["demande4ptBR2"],
                rep = self.locals["repptBR"],
                rep2 = self.locals["repptBR2"]
            },
            ruRU = {
                demande4 = self.locals["demande4ruRU"],
                demande42 = self.locals["demande4ruRU2"],
                rep = self.locals["repruRU"],
                rep2 = self.locals["repruRU2"]
            },
            zhCN = {
                demande4 = self.locals["demande4zhCN"],
                demande42 = self.locals["demande4zhCN2"],
                rep = self.locals["repzhCN"],
                rep2 = self.locals["repzhCN2"]
            },
            zhTW = {
                demande4 = self.locals["demande4zhTW"],
                demande42 = self.locals["demande4zhTW2"],
                rep = self.locals["repzhTW"],
                rep2 = self.locals["repzhTW2"]
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