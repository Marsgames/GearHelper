GearHelper = LibStub("AceAddon-3.0"):NewAddon("GearHelper", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "enUS", true)
-- local BT = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()

L["merci"] = "Author Marsgames - Temple Noir & Tempaxe - Temple Noir. Special thanks for Nirek for his amazing work."
L["local"] = "EN"

-------------------------- CE QUI EST EN DESSOUS DE CETTE LIGNE EST DISPO SUR CURSE --------------------------
L["Addon"] = "GearHelper is : "
L["ActivatedGreen"] = "Activated|r"
L["DeactivatedRed"] = "Deactivated|r"
L["itemLessThan"] = "This item is worse than your"
L["itemLessThanGeneral"] = "This item is worse than yours"
L["itemBetterThan"] = "This item is better than your "
L["itemBetterThan2"] = "with a value of +"
L["itemBetterThanGeneral"] = "This item is better than yours with a value of +"
L["UIGHCheckBoxAddon"] = " Enable / disable GearHelper"
L["UIGHCheckBoxSellGrey"] = "Enable / disable auto sell grey items"
L["UIGHCheckBoxAutoAcceptQuestReward"] = "Enable / disable auto accept quest reward"
L["UIGHCheckBoxAutoEquipLootedStuff"] = "Enable / disable auto equip stuff when looted"
L["UIGHCheckBoxAutoEquipWhenSwitchSpe"] = "Enable / disable auto equip stuff when change specialization"
L["CantRepair"] = "You can't repair"
L["repairCost"] = "Repair cost : "
L["guildRepairCost"] = "Guild repair cost : "
L["gold"] = "g" -- g for Gold (in english)  / po for Piece d'Or (in french)...
L["dot"] = "." -- ex : 3.24 golds (3 gold and 24 silver)
L["DNR"] = "Do not repair automatically"
L["AutoRepair"] = "Repair with own funds"
L["GuildAutoRepair"] = "Repair with guild funds"
L["itemEgal"] = "This item is equal as yours"
L["itemEgala"] = "This item is equal as "
L["itemEgalMainD"] = "This item is equal as your Right Hand"
L["itemEgalMainG"] = "This item is equal as your Left Hand"
L["mainD"] = " Right Hand "
L["mainG"] = " Left Hand "
L["UIGHCheckBoxAutoInvite"] = "Automatically invite the person who /w you the text         "
L["checkGHAutoTell"] = "Enable / disable auto tell loot in raid"
L["InviteMessage"] = "The message to whisper you for you to send an automatic invitation is : "
L["moneyEarned"] = "Money earned by selling : "
L["ask1"] = "You can ask ["
L["ask2"] = "] if he needs "
L["demande1"] = "Do you want to ask to "
L["demande2"] = " if he needs "
L["yes"] = "Yes"
L["no"] = "No"
L["demande4frFR"] --[[don't translate this]] = "[GearHelper] - Salut, je voulais savoir si tu avais besoin de "
L["demande4frFR2"] --[[don't translate this]] = " que tu viens juste de gagner "
L["demande4deDE"] --[[don't translate this]] = "[GearHelper] - Hey, ich würde gerne wissen, ob du dein "
L["demande4deDE2"] --[[don't translate this]] = " brauchst"
L["demande4enUS"] --[[don't translate this]] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4enUS2"] --[[don't translate this]] = " that you just won "
L["demande4ruRU"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4ruRU2"] = " that you just won "
L["demande4itIT"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4itIT2"] = " that you just won "
L["demande4esES"] --[[don't translate this]] = "[GearHelper] - ¿Hola, necesitas esto "
L["demande4esES2"] --[[don't translate this]] = " que acabas de recibir "
L["demande4esMX"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4esMX2"] = " that you just won "
L["demande4koKR"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4koKR2"] = " that you just won "
L["demande4ptBR"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4ptBR2"] = " that you just won "
L["demande4zhCN"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4zhCN2"] = " that you just won "
L["demande4zhTW"] = "[GearHelper] - Hey, I would like to know if you need your "
L["demande4zhTW2"] = " that you just won "
L["repfrFR"] --[[don't translate this]] = "S'il te plait, réponds en "
L["repfrFR2"] --[[don't translate this]] = " ou en anglais."
L["repenUS"] --[[don't translate this]] = "Please, answer in "
L["repenUS2"] --[[don't translate this]] = ""
L["repdeDE"] = "Please, answer in "
L["repdeDE2"] = "or in english."
L["repitIT"] = "Please, answer in "
L["repitIT2"] = "or in english."
L["repruRU"] = "Please, answer in "
L["repruRU2"] = "or in english."
L["repesES"] --[[don't translate this]] = "Por favor, contesta en "
L["repesES2"] --[[don't translate this]] = "o en inglès."
L["repesMX"] = "Please, answer in "
L["repesMX2"] = "or in english."
L["repkoKR"] = "Please, answer in "
L["repkoKR2"] = "or in english."
L["repptBR"] = "Please, answer in "
L["repptBR2"] = "or in english."
L["repzhCN"] = "Please, answer in "
L["repzhCN2"] = "or in english."
L["repzhTW"] = "Please, answer in "
L["repzhTW2"] = "or in english."
L["maLangue"] = "english."
L["maj1"] = "You are using version "
L["maj2"] = "|r of GearHelper. Version "
L["maj3"] = "|r was find from "
L["equipVerbose"] = " has just been equipped by GearHelper"
L["enable"] = "Enable"
L["gearOptions"] = "Gear Options"
L["autoEquipLootedStuff"] = "Auto equip looted stuff"
L["autoEquipSpecChangedStuff"] = "Auto equip when spec is changed"
L["lootInRaidAlert"] = "Alert if something better is loot"
L["UIGHCheckBoxlootInRaidAlert"] = "Enable / disable option to be informed if someone loot something better than what you have equipped"
L["UIprintWhenEquip"] = "Print when auto equip"
L["miscOptions"] = "Misc Options"
L["sellGrey"] = "Sell Grey Items"
L["questRewars"] = "Auto accept quest reward"
L["auto-repair"] = "Auto-Repair"
L["auto-repairDesc"] = "Enables / disables automatic reparation"
L["UIautoInvite"] = "Invite On Whisper"
L["UIinviteMessage"] = "Invite Message"
L["UIinviteMessageDesc"] = "Invite message to tell you to be invited"
L["remove"] = "Remove"
L["UIcwTemplateToUse"] = "Template to use"
L["UIstatsTemplateToUse"] = "Stats template to use"
L["UItemplateName"] = "New template"
L["customWeights"] = "Custom Weights"
L["noxxicWeights"] = "Noxxic Weights"
L["UIcwIlvlWeight"] = "iLvl Weight"
L["UIcwIlvlOption"] = "Consider iLvl into calculation"
L["UIcwGemSocketCompute"] = "Consider empty socket in computing"
L["betterThanNothing"] = "This item is better than nothing"
L["UIGlobalComputeNotEquippable"] = "Show non equippable items"
L["UIGlobalComputeNotEquippableDescription"] = 'Show "This item is worst than yours" on non equippable items'
L["UICWasPercentage"] = "Value in percentage"
L["UICWasPercentageDescription"] = "Describe the importance of each statistic by a number representing a percentage, the sum of the values ​​must be 100"
L["UIWhisperAlert"] = "Whisper Alert"
L["UIWhisperAlertDesc"] = "Play a sound when you're whispered"
L["UISayMyName"] = "Say my name"
L["UISayMyNameDesc"] = "Show an alert with sound when someone call your name"
L["UIMyNames"] = "Names"
L["UIMyNamesDesc"] = "Names list for the alert. Separates by comma (no spaces)"
L["itemEquipped"] = "This item is equipped"
L["UIMinimapIcon"] = "Minimap icon"
L["UIMinimapIconDesc"] = "Show the minimap icon"
L["MmTtLClick"] = "Left click to open options"
L["MmTtRClickActivate"] = "Right click to activate GearHelper"
L["MmTtRClickDeactivate"] = "Right click to deactivate GearHelper"
L["MmTtClickUnlock"] = "Shift + click to |cFF00FF00unlock|cFFFFFF00 minimap icon"
L["MmTtClickLock"] = "Shift + click to |cFFFF0000lock|cFFFFFF00 minimap icon"
L["MmTtCtrlClick"] = "Ctrl + click to |cFF00FF00hide|cFFFFFF00 minimap icon"
L["DropRate"] = "Drop rate : "
L["DropZone"] = "Location : "
L["DropBy"] = "Dropped by : "
L["ilvlInspect"] = "Average ilvl : "
L["UIBossesKilled"] = "Bosses killed"
L["UIBossesKilledDesc"] = "Show bosses killed on LFG panel"
L["UIIlvlCharFrame"] = "ilvl char panel"
L["UIIlvlCharFrameDesc"] = "Show your items ilvl on char panel"
L["UIIlvlInspectFrame"] = "ilvl on inspect"
L["UIIlvlInspectFrameDesc"] = "Show your target's ilvl when inspect"
L["getLoot"] = "receives" -- text when another player get a loot ()
L["maLangueenUS"] = "English."
L["maLanguefrFR"] = "Anglais."
L["maLangueesES"] = "Inglés."
L["maLangueesEX"] = "Inglés."
L["maLanguedeDE"] = "Englisch."
L["maLangueitIT"] = "Inglese."
L["maLangueruRU"] = "Английский."
L["maLanguekoKR"] = "영어."
L["maLangueptBR"] = "Inglês."
L["maLanguezhCN"] = "英语."
L["maLanguezhTW"] = "英語."
L["isAlive"] = "is alive !"
L["isDead"] = "is dead !"
L["slashCommandConfig"] = "config - Open the configuration panel"
L["slashCommandVersion"] = "version - Display the addon version"
L["slashCommandCw"] = "cw - Open the custom weight panel"
L["lfrCheckButtonText"] = "Auto accept rdy check"
L["lfrCheckButtonTooltip"] = "Check this box to auto accept ready check when you are in LFR"
L["secondaryOptions"] = "Secondary options"
L["thanksPanel"] = "Thanks"
L["itemNotEquippable"] = "This item is not equippable"
L["helpConfig"] = "config - Open the config panel"
L["helpVersion"] = "version - Print your actual version of GH"
L["helpCW"] = "cw - Open the Custom Weights panel"
L["helpDebug"] = "debug - Enable the debug print mode"
L["phrases"] = "Phrases"
-------------------------- CE QUI EST EN DESSOUS DE CETTE LIGNE N'EST PAS DISPO SUR CURSE ----------------------------

------------------------------------------------ SUPRIMER CETTE LIGNE ------------------------------------------------
-----

L["Tooltip"] = {
    Stat = {
        ["Intellect"] = ITEM_MOD_INTELLECT_SHORT,
        ["Haste"] = ITEM_MOD_HASTE_RATING_SHORT,
        ["CriticalStrike"] = ITEM_MOD_CRIT_RATING_SHORT,
        ["Versatility"] = ITEM_MOD_VERSATILITY,
        ["Mastery"] = ITEM_MOD_MASTERY_RATING_SHORT,
        ["Agility"] = ITEM_MOD_AGILITY_SHORT,
        ["Stamina"] = ITEM_MOD_STAMINA_SHORT,
        ["Strength"] = ITEM_MOD_STRENGTH_SHORT,
        ["Armor"] = RESISTANCE0_NAME,
        ["Multistrike"] = ITEM_MOD_CR_MULTISTRIKE_SHORT,
        ["DPS"] = ITEM_MOD_DAMAGE_PER_SECOND_SHORT,
        ["Leech"] = "Leech",
        ["Avoidance"] = "Avoidance",
        ["MovementSpeed"] = "Speed"
    },
    ["ItemLevel"] = "^Item Level",
    ["LevelRequired"] = "^Requires Level",
    ["GemSocketEmpty"] = "^Sockets",
    ["BonusGem"] = "^Socket bonus"
}

L["Artifact"] = {
    ["251"] = {
        "128293",
        "128292"
    },
    ["259"] = {
        "128869",
        "128870"
    },
    ["260"] = {
        "128872",
        "134552"
    },
    ["103"] = {
        "128859",
        "128860"
    },
    ["104"] = {
        "128821",
        "128822"
    },
    ["269"] = {
        "128940",
        "133948"
    },
    ["66"] = {
        "128866",
        "128867"
    },
    ["258"] = {
        "128827",
        "133958"
    },
    ["262"] = {
        "128935",
        "128936"
    },
    ["263"] = {
        "128819",
        "128873"
    },
    ["264"] = {
        "128911",
        "128934"
    },
    ["266"] = {
        "128943",
        "137246"
    },
    ["72"] = {
        "128908",
        "134553"
    },
    ["73"] = {
        "128289",
        "128288"
    },
    ["577"] = {
        "127829",
        "127830"
    },
    ["581"] = {
        "128832",
        "128831"
    },
    ["250"] = "128402",
    ["252"] = "128403",
    ["102"] = "128858",
    ["105"] = "128306",
    ["253"] = "128861",
    ["254"] = "128826",
    ["255"] = "128808",
    ["62"] = "127857",
    ["63"] = "128820",
    ["64"] = "128862",
    ["268"] = "128938",
    ["270"] = "128937",
    ["65"] = "128823",
    ["70"] = "120978",
    ["256"] = "128868",
    ["257"] = "128825",
    ["261"] = "128476",
    ["265"] = "128942",
    ["267"] = "128941",
    ["71"] = "128910"
}

local BabbleI = LibStub("LibBabble-Inventory-3.0")
local BT = BabbleI:GetLookupTable()

L["armor"] = BT["Armor"]
L["weapon"] = BT["Weapon"]
L["divers"] = BT["Miscellaneous"]
L["cannapeche"] = BT["Fishing Poles"] -- supprimer le doublon ?
L["monture"] = BT["Mount"]
L["mascotte"] = BT["Companion Pets"]
L["TypeToNotNeed"] = {
    ["sac"] = BT["Bag"],
    ["conteneur"] = BT["Container"],
    ["consommable"] = BT["Consumable"],
    ["autre"] = BT["Other"],
    ["glyphe"] = BT["Glyph"],
    ["artisanat"] = BT["Trade Goods"],
    ["element"] = BT["Parts"],
    ["recette"] = BT["Recipe"],
    ["gemme"] = BT["Gem"],
    ["relique"] = BT["Relic"],
    ["divers"] = BT["Miscellaneous"],
    ["camelote"] = BT["Junk"],
    ["quete"] = BT["Quest"],
    ["cle"] = BT["Key"],
    ["monture"] = BT["Mount"],
    ["mascotte"] = BT["Companion Pets"],
    ["cosmetique"] = BT["Cosmetic"],
    ["elixir"] = BT["Elixir"],
    ["cannapeche"] = BT["Fishing Poles"]
}

L["IsEquippable"] = {
    -- War
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
    -- Pala
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
    -- Chassou
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
    -- Fufu
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
    -- Priest
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
    -- DK
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
    -- Sham
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
    -- Mage
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
    -- Démo
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
    -- Monk
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
    -- Druide de la tribue de Dana
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
    -- DH
    ["DEMONHUNTER"] = {
        ["Cuir"] = BT["Leather"],
        ["Glaives"] = BT["Warglaives"],
        ["Dague"] = BT["Dagger"],
        ["Dagues"] = BT["Daggers"],
        ["Pugilat"] = BT["Fist Weapon"],
        ["Pugilats"] = BT["Fist Weapons"],
        ["Hache1H"] = BT["One-Handed Axes"],
        ["Epee1H"] = BT["One-Handed Swords"]
    }
}
