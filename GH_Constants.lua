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
        debug = {
            general = false,
            bypassAll = false,
            itemCompare = false,
            events = false,
            quest = false,
            autoEquip = false,
            item = false,
            showUpgradeIcon = false,
            inventory = false,
            itemTooltip = false,
            template = false
        },
        CW = {},
        iLvlOption = false,
        iLvlWeight = 10,
        includeSocketInCompute = true,
        computeNotEquippable = true,
        whisperAlert = true,
        sayMyName = true,
        bossesKilled = true,
        ilvlCharFrame = true,
        ilvlInspectFrame = true,
        inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil},
        defaultWeightForStat = 1
    },
    global = {
        SellPrices = {},
        myNames = "",
        messages = {
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
    lastBagUpdateEvent = {},
    charInventory = {
        [INVSLOT_HEAD] = GHItem:CreateEmpty(),
        [INVSLOT_NECK] = GHItem:CreateEmpty(),
        [INVSLOT_SHOULDER] = GHItem:CreateEmpty(),
        [INVSLOT_CHEST] = GHItem:CreateEmpty(),
        [INVSLOT_WAIST] = GHItem:CreateEmpty(),
        [INVSLOT_LEGS] = GHItem:CreateEmpty(),
        [INVSLOT_FEET] = GHItem:CreateEmpty(),
        [INVSLOT_WRIST] = GHItem:CreateEmpty(),
        [INVSLOT_HAND] = GHItem:CreateEmpty(),
        [INVSLOT_FINGER1] = GHItem:CreateEmpty(),
        [INVSLOT_FINGER2] = GHItem:CreateEmpty(),
        [INVSLOT_TRINKET1] = GHItem:CreateEmpty(),
        [INVSLOT_TRINKET2] = GHItem:CreateEmpty(),
        [INVSLOT_MAINHAND] = GHItem:CreateEmpty(),
        [INVSLOT_OFFHAND] = GHItem:CreateEmpty(),
        [INVSLOT_BACK] = GHItem:CreateEmpty()
    },
    bagsItems = {}
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
    [INVSLOT_TABARD] = "TABARDSLOT"
}

-- GearHelper.typeToSlotMapping = {
--     ["INVTYPE_AMMO"] = { [1] = 0 },
--     ["INVTYPE_HEAD"] = { [1] = 1 },
--     ["INVTYPE_NECK"] = { [1] = 2 },
--     ["INVTYPE_SHOULDER"] = { [1] = 3 },
--     ["INVTYPE_BODY"] = { [1] = 4 },
--     ["INVTYPE_CHEST"] = { [1] = 5 },
--     ["INVTYPE_ROBE"] = { [1] = 5 },
--     ["INVTYPE_WAIST"] = { [1] = 6 },
--     ["INVTYPE_LEGS"] = { [1] = 7 },
--     ["INVTYPE_FEET"] = { [1] = 8 },
--     ["INVTYPE_WRIST"] = { [1] = 9 },
--     ["INVTYPE_HAND"] = { [1] = 10 },
--     ["INVTYPE_FINGER"] = { [1] = 11, [2] = 12 },
--     ["INVTYPE_TRINKET"] = { [1] = 13, [2] = 14 },
--     ["INVTYPE_CLOAK"] = { [1] = 15 },
--     ["INVTYPE_WEAPON"] = { [1] = 16, [2] = 17 },
--     ["INVTYPE_SHIELD"] = { [1] = 17 },
--     ["INVTYPE_2HWEAPON"] = { [1] = 16 },
--     ["INVTYPE_WEAPONMAINHAND"] = { [1] = 16 },
--     ["INVTYPE_WEAPONOFFHAND"] = { [1] = 17 },
--     ["INVTYPE_HOLDABLE"] = { [1] = 17 },
--     ["INVTYPE_RANGED"] = { [1] = 18 },
--     ["INVTYPE_THROWN"] = { [1] = 18 },
--     ["INVTYPE_RANGEDRIGHT"] = { [1] = 18 },
--     ["INVTYPE_RELIC"] = { [1] = 18 },
--     ["INVTYPE_TABARD"] = { [1] = 19 },
--     ["INVTYPE_BAG"] = { [1] = 20, [2] = 21, [3] = 22, [4] = 23 }
-- }

AUTO_EQUIP_ONGOING = false --Used to prevent BAG_UPDATE events fired during auto equip to be processed

-- WEAPON both hand for Dual Wield class / spe
-- Dual Wield = Rogue / DH / Frost DK / Fury War / Enhancement Shaman / Brewmaster and Windwalker Monk = IsPlayerSpell(674)
GearHelper.operators = {
    ["UNDEFINED"] = 0,
    ["OR"] = 1,
    ["AND"] = 2
}

GearHelper.itemSlot = {
    INVTYPE_AMMO = {
        slots = {INVSLOT_AMMO},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_HEAD = {
        slots = {INVSLOT_HEAD},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_NECK = {
        slots = {INVSLOT_NECK},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_SHOULDER = {
        slots = {INVSLOT_SHOULDER},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_BODY = {
        slots = {INVSLOT_BODY},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_CHEST = {
        slots = {INVSLOT_CHEST},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_ROBE = {
        slots = {INVSLOT_CHEST},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_WAIST = {
        slots = {INVSLOT_WAIST},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_LEGS = {
        slots = {INVSLOT_LEGS},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_FEET = {
        slots = {INVSLOT_FEET},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_WRIST = {
        slots = {INVSLOT_WRIST},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_HAND = {
        slots = {INVSLOT_HAND},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_FINGER = {
        slots = {INVSLOT_FINGER1, INVSLOT_FINGER2},
        operator = GearHelper.operators.OR
    },
    INVTYPE_TRINKET = {
        slots = {INVSLOT_TRINKET1, INVSLOT_TRINKET2},
        operator = GearHelper.operators.OR
    },
    INVTYPE_CLOAK = {
        slots = {INVSLOT_BACK},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_SHIELD = {
        slots = {INVSLOT_OFFHAND},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_WEAPON = {
        slots = {INVSLOT_MAINHAND},
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
        slots = {INVSLOT_OFFHAND},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_HOLDABLE = {
        slots = {INVSLOT_OFFHAND},
        operator = GearHelper.operators.UNDEFINED
    },
    INVTYPE_RANGED = {
        slots = {INVSLOT_MAINHAND, INVSLOT_OFFHAND},
        operator = GearHelper.operators.AND
    },
    INVTYPE_RANGEDRIGHT = {
        slots = {INVSLOT_MAINHAND},
        operator = GearHelper.operators.UNDEFINED
    }
}

INVTYPE_1H_OFFHAND = {
    INVTYPE_HOLDABLE = true,
    INVTYPE_WEAPONOFFHAND = true,
    INVTYPE_SHIELD = true
}

INVTYPE_1H_MAINHAND = {
    INVTYPE_RANGEDRIGHT = true,
    INVTYPE_WEAPON = true
}

INVTYPE_TO_IGNORE = {
    [Enum.InventoryType.IndexNonEquipType] = true,
    [Enum.InventoryType.IndexBodyType] = true,
    [Enum.InventoryType.IndexBagType] = true,
    [Enum.InventoryType.IndexTabardType] = true,
    [Enum.InventoryType.IndexQuiverType] = true,
    [Enum.InventoryType.IndexRelicType] = true,
    [Enum.InventoryType.IndexProfessionToolType] = true,
    [Enum.InventoryType.IndexProfessionGearType] = true,
    [Enum.InventoryType.IndexEquipablespellOffensiveType] = true,
    [Enum.InventoryType.IndexEquipablespellUtilityType] = true,
    [Enum.InventoryType.IndexEquipablespellDefensiveType] = true
}

local BabbleI = LibStub("LibBabble-Inventory-3.0")
local BT = BabbleI:GetLookupTable()

-- https://worldofwarcraft.blizzard.com/en-us/game/classes
ITEM_TYPES_EQUIPPABLE_BY_CLASS = {
    ["WARRIOR"] = {
        ["Plaque"] = BT["Plate"],
        ["Maille"] = BT["Mail"],
        ["Cuir"] = BT["Leather"],
        ["Bouclier"] = BT["Shield"],
        ["Boucliers"] = BT["Shields"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Hast"] = BT["Polearm"],
        ["Hasts"] = BT["Polearms"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Hache2H"] = BT["Two-Handed Axes"],
        ["Epee2H"] = BT["Two-Handed Swords"],
        ["Mace2H"] = BT["Two-Handed Maces"],
        ["Jet"] = BT["Thrown"],
        ["Arbalete"] = BT["Crossbow"],
        ["Arbaletes"] = BT["Crossbows"],
        ["Arc"] = BT["Bow"],
        ["Arcs"] = BT["Bows"],
        ["TenuMainGauche"] = BT["Held in Off-Hand"],
        ["MainGauche"] = BT["Off Hand"],
        ["UneMain"] = BT["One-Hand"],
        ["Holdable"] = BT["Miscellaneous"],
        ["Gun"] = BT["Gun"],
        ["ArmeAFeus"] = BT["Guns"]
    },
    ["PALADIN"] = {
        ["Plaque"] = BT["Plate"],
        ["Maille"] = BT["Mail"],
        ["Cuir"] = BT["Leather"],
        ["Bouclier"] = BT["Shield"],
        ["Boucliers"] = BT["Shields"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Masse2H"] = BT["Two-Handed Maces"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Hache2H"] = BT["Two-Handed Axes"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Epee2H"] = BT["Two-Handed Swords"],
        ["Hast"] = BT["Polearm"],
        ["Hasts"] = BT["Polearms"],
        ["Holdable"] = BT["Miscellaneous"],
        ["UneMain"] = BT["One-Hand"]
    },
    ["HUNTER"] = {
        ["Maille"] = BT["Mail"],
        ["Arc"] = BT["Bow"],
        ["Arcs"] = BT["Bows"],
        ["Arbalete"] = BT["Crossbow"],
        ["Arbaletes"] = BT["Crossbows"],
        ["ArmeAFeus"] = BT["Guns"],
        ["Hast"] = BT["Polearm"],
        ["Hasts"] = BT["Polearms"]
    },
    ["ROGUE"] = {
        ["Cuir"] = BT["Leather"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Epee1H"] = BT["One-Handed Swords"]
    },
    ["PRIEST"] = {
        ["Tissu"] = BT["Cloth"],
        ["Baguette"] = BT["Wand"],
        ["Baguettes"] = BT["Wands"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Holdable"] = BT["Miscellaneous"]
    },
    ["DEATHKNIGHT"] = {
        ["Plaque"] = BT["Plate"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Hast"] = BT["Polearm"],
        ["Hasts"] = BT["Polearms"],
        ["Hache2H"] = BT["Two-Handed Axes"],
        ["Masse2H"] = BT["Two-Handed Maces"],
        ["Epee2H"] = BT["Two-Handed Swords"]
    },
    ["SHAMAN"] = {
        ["Maille"] = BT["Mail"],
        ["Bouclier"] = BT["Shield"],
        ["Boucliers"] = BT["Shields"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Hache2H"] = BT["Two-Handed Axes"],
        ["Masse2H"] = BT["Two-Handed Maces"],
        ["Holdable"] = BT["Miscellaneous"]
    },
    ["MAGE"] = {
        ["Tissu"] = BT["Cloth"],
        ["Baguette"] = BT["Wand"],
        ["Baguettes"] = BT["Wands"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Holdable"] = BT["Miscellaneous"]
    },
    ["WARLOCK"] = {
        ["Tissu"] = BT["Cloth"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Baguette"] = BT["Wand"],
        ["Baguettes"] = BT["Wands"],
        ["Holdable"] = BT["Miscellaneous"]
    },
    ["MONK"] = {
        ["Cuir"] = BT["Leather"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Hast"] = BT["Polearm"],
        ["Hasts"] = BT["Polearms"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Holdable"] = BT["Miscellaneous"]
    },
    ["DRUID"] = {
        ["Cuir"] = BT["Leather"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Hast"] = BT["Polearm"],
        ["Hasts"] = BT["Polearms"],
        ["Baton"] = BT["Staff"],
        ["Batons"] = BT["Staves"],
        ["Masse2H"] = BT["Two-Handed Maces"],
        ["Holdable"] = BT["Miscellaneous"]
    },
    ["DEMONHUNTER"] = {
        ["Cuir"] = BT["Leather"],
        ["Glaives"] = BT["Warglaives"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Epee1H"] = BT["One-Handed Swords"]
    },
    ["EVOKER"] = {
        ["Maille"] = BT["Mail"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Masse1H"] = BT["One-Handed Maces"],
        ["Epee1H"] = BT["One-Handed Swords"],
        ["Holdable"] = BT["Miscellaneous"]
    }
}

ITEM_UPGRADE_TOOLTIP_BORDER = {r = 0, g = 255, b = 150}
ITEM_DOWNGRADE_TOOLTIP_BORDER = {r = 255, g = 0, b = 0}
ITEM_EQUAL_TOOLTIP_BORDER = FACTION_YELLOW_COLOR
