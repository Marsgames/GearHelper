GHOptions = {}
GHOptions.__index = GHOptions

local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")
--[[ Proposition for a single page, with a scroll view - Each option on a new line (as actual Blizzard options)
    Debug options

    ----- Gear Options -----
    Show border color on tooltip
    Red tooltip + message when item is not equippable
    Alert loot in instance + ask if the player needs
    Auto equip best item
    Verbose equip
    Auto sell grey items
    Auto repair

    ----- Messages options -----
    Auto invite on whisper
    Invite message
    Alert when someone whisper you
    Alert when you name is written in any channel
    Wich names to alert

    ----- Misc options -----
    Auto accept quest reward
    Bosses killed on LFG panel
    Show ilvl on char panel
    Show ilvl on inspect panel
]] local function GetInvMsg()
    return GearHelper.db.profile.inviteMessage
end

local function ValidateInputPattern(val, type, info)
    if type == "number" then
        if (string.len(val) > 0 and tonumber(val)) then
            return true
        end

        return "Please use numbers only"
    elseif type == "alpha" then
        if string.match(val, "(%A+)") and string.len(val) ~= 0 then
            return "Please use characters only"
        else
            return true
        end
    elseif type == "numberAnd100" then
        if (string.len(val) <= 0 or not tonumber(val)) then
            return "Please use numbers only"
        end

        if GearHelper.db.profile.CW[info[1]].DisplayAsPercentage then
            local sum = 0
            for _, v in pairs(GearHelper.db.profile.CW[info[1]]) do
                if tonumber(v) then
                    sum = sum + (v / 50) * 100
                end
            end
            if sum > 99 then -- Value is stored and if validation failed it's removed so it's taken into account
                return "Percentage sum is more than 100"
            else
                return true
            end
        else
            return true
        end
    end
end

local ghOptionsTable = {
    name = "GearHelper",
    type = "group",
    childGroups = "select",
    args = {
        group1 = {
            order = 0,
            name = " ",
            type = "group",
            inline = true,
            hidden = function()
                if UnitName("player") ~= "Marsgames" and UnitName("player") ~= "Tempaxe" and UnitName("player") ~= "Niisha" then
                    return true
                end
            end,
            args = {
                debug = {
                    order = 1,
                    name = "Debug",
                    desc = GearHelper.locals["UIGHCheckBoxAddon"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.debug = val
                    end,
                    get = function()
                        return GearHelper.db.profile.debug
                    end
                }
            }
        },
        spacer1 = {
            order = 1,
            name = GearHelper.locals["gearOptions"],
            type = "header"
        },
        group2 = {
            order = 2,
            name = " ",
            type = "group",
            inline = true,
            args = {
                autoEquipLootedStuff = {
                    order = 4,
                    name = GearHelper.locals["autoEquipLootedStuff"],
                    desc = GearHelper.locals["UIGHCheckBoxAutoEquipLootedStuff"],
                    type = "toggle",
                    width = "double",
                    set = function(_, val)
                        GearHelper.db.profile.autoEquipLooted.actual = val
                        GearHelper.db.profile.autoEquipLooted.previous = val
                    end,
                    get = function()
                        return GearHelper.db.profile.autoEquipLooted.actual
                    end
                },
                printWhenEquip = {
                    order = 5,
                    name = GearHelper.locals["UIprintWhenEquip"],
                    disabled = function()
                        if GearHelper.db.profile.autoEquipWhenSwitchSpe == false and GearHelper.db.profile.autoEquipLooted.actual == false then
                            return true
                        end
                    end,
                    desc = "Enables / disables print when equip",
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.printWhenEquip = val
                    end,
                    get = function()
                        return GearHelper.db.profile.printWhenEquip
                    end
                },
                askLootRaid = {
                    order = 6,
                    name = GearHelper.locals["lootInRaidAlert"],
                    desc = GearHelper.locals["UIGHCheckBoxlootInRaidAlert"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.askLootRaid = val
                    end,
                    get = function()
                        return GearHelper.db.profile.askLootRaid
                    end,
                    width = "double"
                },
                autoEquipWhenSwitchSpe = {
                    order = 7,
                    name = GearHelper.locals["autoEquipSpecChangedStuff"],
                    desc = GearHelper.locals["UIGHCheckBoxAutoEquipWhenSwitchSpe"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.autoEquipWhenSwitchSpe = val
                    end,
                    get = function()
                        return GearHelper.db.profile.autoEquipWhenSwitchSpe
                    end,
                    width = "double"
                },
                computeNotEquippable = {
                    order = 8,
                    name = GearHelper.locals["UIGlobalComputeNotEquippable"],
                    desc = GearHelper.locals["UIGlobalComputeNotEquippableDescription"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.computeNotEquippable = val
                    end,
                    get = function()
                        return GearHelper.db.profile.computeNotEquippable
                    end,
                    width = "double"
                }
            }
        },
        spacer2 = {
            order = 3,
            name = GearHelper.locals["secondaryOptions"],
            type = "header"
        },
        group3 = {
            order = 4,
            name = " ",
            type = "group",
            inline = true,
            args = {
                autoSell = {
                    order = 0,
                    name = GearHelper.locals["sellGrey"],
                    desc = GearHelper.locals["UIGHCheckBoxSellGrey"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.sellGreyItems = val
                    end,
                    get = function()
                        return GearHelper.db.profile.sellGreyItems
                    end
                },
                autoAcceptQuestReward = {
                    order = 1,
                    name = GearHelper.locals["questRewars"],
                    desc = GearHelper.locals["UIGHCheckBoxAutoAcceptQuestReward"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.autoAcceptQuestReward = val
                    end,
                    get = function()
                        return GearHelper.db.profile.autoAcceptQuestReward
                    end,
                    width = "double"
                },
                autoRepair = {
                    order = 2,
                    name = GearHelper.locals["auto-repair"],
                    desc = GearHelper.locals["auto-repairDesc"],
                    type = "select",
                    values = {
                        [0] = GearHelper.locals["DNR"],
                        [1] = GearHelper.locals["AutoRepair"],
                        [2] = GearHelper.locals["GuildAutoRepair"]
                    },
                    set = function(info, val)
                        GearHelper.db.profile.autoRepair = val
                    end,
                    get = function(info)
                        return GearHelper.db.profile.autoRepair
                    end,
                    style = "dropdown",
                    width = "double"
                },
                autoTell = {
                    order = 3,
                    name = "Loot Announcement",
                    desc = GearHelper.locals["checkGHAutoTell"],
                    hidden = true,
                    type = "toggle",
                    width = "full",
                    set = function(_, val)
                        GearHelper.db.profile.autoTell = val
                    end,
                    get = function()
                        return GearHelper.db.profile.autoTell
                    end
                },
                autoInvite = {
                    order = 4,
                    name = GearHelper.locals["UIautoInvite"],
                    desc = function()
                        return GearHelper.locals["UIGHCheckBoxAutoInvite"] .. GHToolbox:ColorizeString(GetInvMsg(), "LightGreen")
                    end,
                    type = "toggle",
                    width = "double",
                    set = function(_, val)
                        GearHelper.db.profile.autoInvite = val
                    end,
                    get = function()
                        return GearHelper.db.profile.autoInvite
                    end
                },
                inviteMessage = {
                    order = 5,
                    name = GearHelper.locals["UIinviteMessage"],
                    desc = GearHelper.locals["UIinviteMessageDesc"],
                    type = "input",
                    set = function(_, val)
                        GearHelper:setInviteMessage(val)
                    end,
                    get = function()
                        return GearHelper.db.profile.inviteMessage
                    end
                },
                whisperAlert = {
                    order = 6,
                    name = GearHelper.locals["UIWhisperAlert"],
                    desc = GearHelper.locals["UIWhisperAlertDesc"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.whisperAlert = val
                    end,
                    get = function()
                        return GearHelper.db.profile.whisperAlert
                    end
                },
                sayMyName = {
                    order = 7,
                    name = GearHelper.locals["UISayMyName"],
                    desc = GearHelper.locals["UISayMyNameDesc"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.sayMyName = val
                    end,
                    get = function()
                        return GearHelper.db.profile.sayMyName
                    end
                },
                myNames = {
                    order = 8,
                    name = GearHelper.locals["UIMyNames"],
                    desc = GearHelper.locals["UIMyNamesDesc"],
                    type = "input",
                    width = "full",
                    set = function(_, val)
                        if not val then
                            return
                        end

                        GearHelper.db.global.myNames = tostring(val .. ",")
                    end,
                    get = function()
                        return GearHelper.db.global.myNames
                    end
                },
                bossesKilled = {
                    order = 9,
                    name = GearHelper.locals["UIBossesKilled"],
                    desc = GearHelper.locals["UIBossesKilledDesc"],
                    type = "toggle",
                    -- width = "full",
                    set = function(_, val)
                        GearHelper.db.profile.bossesKilled = val
                        if val == false then
                            GearHelper:HideLfrButtons()
                        elseif (RaidFinderQueueFrame) then
                            GearHelper:CreateLfrButtons(RaidFinderQueueFrame)
                            GearHelper:UpdateButtonsAndTooltips(RaidFinderQueueFrame)
                            GearHelper:UpdateGHLfrButton()
                            GearHelper:UpdateSelectCursor()
                            GearHelper:RegisterEvent("LFG_UPDATE")
                            GearHelper.LFG_UPDATE = GearHelper.UpdateGHLfrButton
                        end
                    end,
                    get = function()
                        return GearHelper.db.profile.bossesKilled
                    end
                },
                ilvlCharFrame = {
                    order = 10,
                    name = GearHelper.locals["UIIlvlCharFrame"],
                    desc = GearHelper.locals["UIIlvlCharFrameDesc"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.ilvlCharFrame = val
                        if (val) then
                            GearHelper:AddIlvlOnCharFrame()
                        else
                            GearHelper:HideIlvlOnCharFrame()
                        end
                    end,
                    get = function()
                        return GearHelper.db.profile.ilvlCharFrame
                    end
                },
                ilvlInspectFrame = {
                    order = 11,
                    name = GearHelper.locals["UIIlvlInspectFrame"],
                    desc = GearHelper.locals["UIIlvlInspectFrameDesc"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.ilvlInspectFrame = val
                        if (val) then
                            if (InspectPaperDollItemsFrame and UnitGUID("target")) then
                                GearHelper:AddIlvlOnInspectFrame()
                            end
                        else
                            GearHelper:HideIlvlOnInspectFrame()
                        end
                    end,
                    get = function()
                        return GearHelper.db.profile.ilvlInspectFrame
                    end
                }
            }
        }
    }
}

local function DeleteTemplate(info)
    local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(GearHelper.locals["customWeights"], "dialog", "GearHelper-1.0")

    configTable.args.TemplateSelection.values[info[1]] = nil
    configTable.args.TemplateSelection.values = configTable.args.TemplateSelection.values
    configTable.args[info[1]] = nil
    GearHelper.db.profile.CW[info[1]] = nil

    LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["customWeights"], configTable)
    LibStub("AceConfigRegistry-3.0"):NotifyChange(GearHelper.locals["customWeights"])
end

local function CreateNewTemplate(templateName)
    for _, v in pairs(GearHelper.db.profile.CW) do
        if (v.Name == templateName) then
            return
        end
    end
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
        ["Max"] = 0,
        ["Name"] = templateName,
        ["DisplayAsPercentage"] = false
    }
    GearHelper.db.profile.CW[templateName] = tmpTemplate
    local newGroup = {
        name = templateName,
        type = "group",
        hidden = function()
            if GearHelper.db.profile.weightTemplate == "NOX" then
                return true
            end
        end,
        args = {
            asPercentage = {
                order = 0,
                name = GearHelper.locals["UICWasPercentage"],
                desc = GearHelper.locals["UICWasPercentageDescription"],
                type = "toggle",
                hidden = true, ---------------------------------------------------- REMOVE HERE TO RESTORE STATS AS PERCENTAGE ----------------------------------------------------
                width = "double",
                set = function(_, val)
                    for k, v in pairs(GearHelper.db.profile.CW[templateName]) do
                        if tonumber(v) then
                            GearHelper.db.profile.CW[templateName][k] = 0
                        end
                    end
                    GearHelper.db.profile.CW[templateName].DisplayAsPercentage = val
                end,
                get = function()
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return GearHelper.db.profile.CW[templateName].DisplayAsPercentage
                    else
                        GearHelper.db.profile.CW[templateName].DisplayAsPercentage = false
                        return GearHelper.db.profile.CW[templateName].DisplayAsPercentage
                    end
                end
            },
            Intell = {
                order = 1,
                name = ITEM_MOD_INTELLECT_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_INTELLECT_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_INTELLECT_SHORT, val)
                end
            },
            Strength = {
                order = 2,
                name = ITEM_MOD_STRENGTH_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STRENGTH_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_STRENGTH_SHORT, val)
                end
            },
            Agility = {
                order = 3,
                name = ITEM_MOD_AGILITY_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_AGILITY_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_AGILITY_SHORT, val)
                end
            },
            Stamina = {
                order = 4,
                name = ITEM_MOD_STAMINA_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STAMINA_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_STAMINA_SHORT, val)
                end
            },
            Haste = {
                order = 5,
                name = ITEM_MOD_HASTE_RATING_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        local validated = ValidateInputPattern(val, "number")
                        return validated
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_HASTE_RATING_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_HASTE_RATING_SHORT, val)
                end
            },
            Mastery = {
                order = 6,
                name = ITEM_MOD_MASTERY_RATING_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_MASTERY_RATING_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_MASTERY_RATING_SHORT, val)
                end
            },
            Critic = {
                order = 7,
                name = ITEM_MOD_CRIT_RATING_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CRIT_RATING_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CRIT_RATING_SHORT, val)
                end
            },
            Armor = {
                order = 8,
                name = ITEM_MOD_EXTRA_ARMOR_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_EXTRA_ARMOR_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_EXTRA_ARMOR_SHORT, val)
                end
            },
            Versatility = {
                order = 9,
                name = ITEM_MOD_VERSATILITY,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_VERSATILITY)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_VERSATILITY, val)
                end
            },
            Leech = {
                order = 10,
                name = ITEM_MOD_CR_LIFESTEAL_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_LIFESTEAL_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CR_LIFESTEAL_SHORT, val)
                end
            },
            Avoidance = {
                order = 11,
                name = ITEM_MOD_CR_AVOIDANCE_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_AVOIDANCE_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CR_AVOIDANCE_SHORT, val)
                end
            },
            MovementSpeed = {
                order = 14,
                name = ITEM_MOD_CR_SPEED_SHORT,
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_SPEED_SHORT)
                end,
                set = function(info, val)
                    return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CR_SPEED_SHORT, val)
                end
            },
            ButtonDelete = {
                order = 15,
                name = GearHelper.locals["remove"],
                func = function(info)
                    DeleteTemplate(info)
                end,
                type = "execute"
            }
        }
    }
    local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(GearHelper.locals["customWeights"], "dialog", "GearHelper-1.0")
    configTable.args[templateName] = newGroup
    configTable.args.TemplateSelection.values[templateName] = templateName
    LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["customWeights"], configTable)
    LibStub("AceConfigRegistry-3.0"):NotifyChange(GearHelper.locals["customWeights"])
end

GearHelper.cwTable = {
    name = GearHelper.locals["customWeights"],
    type = "group",
    childGroups = "tree",
    args = {
        Select = {
            order = 0,
            name = GearHelper.locals["UIstatsTemplateToUse"],
            type = "select",
            style = "radio",
            values = {
                [0] = GearHelper.locals["noxxicWeights"],
                [1] = GearHelper.locals["customWeights"]
            },
            get = function()
                if GearHelper.db.profile.weightTemplate == "NOX" then
                    return 0
                else
                    return 1
                end
            end,
            set = function(_, val)
                if val == 1 then
                    if GHToolbox:GetArraySize(GearHelper.db.profile.CW) == 0 or not GearHelper.db.profile.lastWeightTemplate then --To avoid error if we select custome weight and we do not create a template
                        GearHelper.db.profile.weightTemplate = "NOX_ByDefault"
                    else
                        GearHelper.db.profile.weightTemplate = GearHelper.db.profile.lastWeightTemplate
                        LibStub("AceConfigDialog-3.0"):SelectGroup(GearHelper.locals["customWeights"], GearHelper.db.profile.weightTemplate)
                    end
                elseif val == 0 then
                    GearHelper.db.profile.lastWeightTemplate = GearHelper.db.profile.weightTemplate
                    GearHelper.db.profile.weightTemplate = "NOX"
                end
            end
        },
        group1 = {
            order = 2,
            name = "Options de calcul",
            type = "group",
            inline = true,
            args = {
                GemSocketCompute = {
                    order = 1,
                    name = GearHelper.locals["UIcwGemSocketCompute"],
                    type = "toggle",
                    width = "double",
                    --width = "double",
                    get = function()
                        return GearHelper.db.profile.includeSocketInCompute
                    end,
                    set = function(_, val)
                        GearHelper.db.profile.includeSocketInCompute = val
                    end
                },
                IlvlOption = {
                    order = 2,
                    name = GearHelper.locals["UIcwIlvlOption"],
                    type = "toggle",
                    get = function()
                        return GearHelper.db.profile.iLvlOption
                    end,
                    set = function(_, val)
                        GearHelper.db.profile.iLvlOption = val
                    end
                },
                IlvlWeight = {
                    order = 3,
                    name = GearHelper.locals["UIcwIlvlWeight"],
                    width = "half",
                    type = "input",
                    disabled = function()
                        return not GearHelper.db.profile.iLvlOption
                    end,
                    validate = function(_, val)
                        return ValidateInputPattern(val, "number")
                    end,
                    get = function()
                        return GearHelper.db.profile.iLvlWeight
                    end,
                    set = function(_, val)
                        GearHelper.db.profile.iLvlWeight = val
                    end
                }
            }
        },
        templateName = {
            order = 4,
            name = GearHelper.locals["UItemplateName"],
            type = "input",
            width = "double",
            validate = function(_, val)
                return ValidateInputPattern(val, "alpha")
            end,
            get = function()
            end,
            set = function(_, val)
                CreateNewTemplate(val)
                LibStub("AceConfigDialog-3.0"):SelectGroup(GearHelper.locals["customWeights"], val)
            end
        },
        TemplateSelection = {
            order = 3,
            name = GearHelper.locals["UIcwTemplateToUse"],
            type = "select",
            style = "dropdown",
            disabled = function()
                if GearHelper.db.profile.weightTemplate == "NOX" then
                    return true
                end
            end,
            get = function()
                return GearHelper.db.profile.weightTemplate
            end,
            set = function(_, val)
                GearHelper.db.profile.weightTemplate = val
                LibStub("AceConfigDialog-3.0"):SelectGroup(GearHelper.locals["customWeights"], val)
            end,
            values = {}
        },
        NoxGroup = {
            name = "Noxxic",
            type = "group",
            args = {
                Intell = {
                    order = 1,
                    name = ITEM_MOD_INTELLECT_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_INTELLECT_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_INTELLECT_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Strength = {
                    order = 2,
                    name = ITEM_MOD_STRENGTH_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STRENGTH_SHORT))
                    end,
                    disabled = function()
                        return true
                    end,
                    hidden = function(info)
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STRENGTH_SHORT) == 0 then
                            return true
                        end
                    end
                },
                Agility = {
                    order = 3,
                    name = ITEM_MOD_AGILITY_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_AGILITY_SHORT))
                    end,
                    disabled = function()
                        return true
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_AGILITY_SHORT) == 0 then
                            return true
                        end
                    end
                },
                Stamina = {
                    order = 4,
                    name = ITEM_MOD_STAMINA_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STAMINA_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STAMINA_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Haste = {
                    order = 5,
                    name = ITEM_MOD_HASTE_RATING_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_HASTE_RATING_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_HASTE_RATING_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Mastery = {
                    order = 6,
                    name = ITEM_MOD_MASTERY_RATING_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_MASTERY_RATING_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_MASTERY_RATING_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Critic = {
                    order = 7,
                    name = ITEM_MOD_CRIT_RATING_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CRIT_RATING_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CRIT_RATING_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Armor = {
                    order = 8,
                    name = ITEM_MOD_EXTRA_ARMOR_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_EXTRA_ARMOR_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_EXTRA_ARMOR_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Versatility = {
                    order = 9,
                    name = ITEM_MOD_VERSATILITY,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_VERSATILITY))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_VERSATILITY) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Leech = {
                    order = 10,
                    name = ITEM_MOD_CR_LIFESTEAL_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_LIFESTEAL_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_LIFESTEAL_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Avoidance = {
                    order = 11,
                    name = ITEM_MOD_CR_AVOIDANCE_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_AVOIDANCE_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_AVOIDANCE_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                MovementSpeed = {
                    order = 14,
                    name = ITEM_MOD_CR_SPEED_SHORT,
                    type = "input",
                    get = function(info)
                        return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_SPEED_SHORT))
                    end,
                    hidden = function()
                        if GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_SPEED_SHORT) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                }
            }
        }
    }
}

function GearHelper:BuildCWTable()
    for _, v in pairs(self.db.profile.CW) do
        if (v.Name ~= nil) then
            local newGroup = {
                name = "GHDefaultName",
                type = "group",
                disabled = function()
                    if GearHelper.db.profile.weightTemplate == "NOX" then
                        return true
                    end
                end,
                args = {
                    asPercentage = {
                        order = 0,
                        name = GearHelper.locals["UICWasPercentage"],
                        desc = GearHelper.locals["UICWasPercentageDescription"],
                        type = "toggle",
                        hidden = true, ---------------------------------------------------- REMOVE HERE TO RESTORE STATS AS PERCENTAGE ----------------------------------------------------
                        width = "double",
                        set = function(_, val)
                            for x, y in pairs(v) do
                                if tonumber(y) then
                                    v[x] = 0
                                end
                            end
                            v.DisplayAsPercentage = val
                        end,
                        get = function()
                            if v.DisplayAsPercentage then
                                return v.DisplayAsPercentage
                            else
                                v.DisplayAsPercentage = false
                                return v.DisplayAsPercentage
                            end
                        end
                    },
                    Intell = {
                        order = 1,
                        name = ITEM_MOD_INTELLECT_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_INTELLECT_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_INTELLECT_SHORT, val)
                        end
                    },
                    Strength = {
                        order = 2,
                        name = ITEM_MOD_STRENGTH_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STRENGTH_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_STRENGTH_SHORT, val)
                        end
                    },
                    Agility = {
                        order = 3,
                        name = ITEM_MOD_AGILITY_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_AGILITY_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_AGILITY_SHORT, val)
                        end
                    },
                    Stamina = {
                        order = 4,
                        name = ITEM_MOD_STAMINA_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_STAMINA_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_STAMINA_SHORT, val)
                        end
                    },
                    Haste = {
                        order = 5,
                        name = ITEM_MOD_HASTE_RATING_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_HASTE_RATING_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_HASTE_RATING_SHORT, val)
                        end
                    },
                    Mastery = {
                        order = 6,
                        name = ITEM_MOD_MASTERY_RATING_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_MASTERY_RATING_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_MASTERY_RATING_SHORT, val)
                        end
                    },
                    Critic = {
                        order = 7,
                        name = ITEM_MOD_CRIT_RATING_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CRIT_RATING_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CRIT_RATING_SHORT, val)
                        end
                    },
                    Armor = {
                        order = 8,
                        name = ITEM_MOD_EXTRA_ARMOR_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_EXTRA_ARMOR_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_EXTRA_ARMOR_SHORT, val)
                        end
                    },
                    Versatility = {
                        order = 9,
                        name = ITEM_MOD_VERSATILITY,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_VERSATILITY))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_VERSATILITY, val)
                        end
                    },
                    Leech = {
                        order = 10,
                        name = ITEM_MOD_CR_LIFESTEAL_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_LIFESTEAL_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CR_LIFESTEAL_SHORT, val)
                        end
                    },
                    Avoidance = {
                        order = 11,
                        name = ITEM_MOD_CR_AVOIDANCE_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_AVOIDANCE_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CR_AVOIDANCE_SHORT, val)
                        end
                    },
                    MovementSpeed = {
                        order = 14,
                        name = ITEM_MOD_CR_SPEED_SHORT,
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return tostring(GearHelper:GetStatFromActiveTemplate(ITEM_MOD_CR_SPEED_SHORT))
                        end,
                        set = function(info, val)
                            return GearHelper:SetStatToActiveTemplate(ITEM_MOD_CR_SPEED_SHORT, val)
                        end
                    },
                    ButtonDelete = {
                        order = 15,
                        name = GearHelper.locals["remove"],
                        func = function(info)
                            DeleteTemplate(info)
                        end,
                        type = "execute"
                    }
                }
            }
            newGroup.name = v.Name
            GearHelper.cwTable.args[v.Name] = newGroup
            GearHelper.cwTable.args.TemplateSelection.values[v.Name] = v.Name
        end
    end
    LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["customWeights"], GearHelper.cwTable)
    LibStub("AceConfigRegistry-3.0"):NotifyChange(GearHelper.locals["customWeights"])
end

function GHOptions:GenerateOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("GearHelper", ghOptionsTable, "ghOption")
    LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["customWeights"], GearHelper.cwTable)
    GearHelper.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GearHelper")
    GearHelper.cwFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(GearHelper.locals["customWeights"], GearHelper.locals["customWeights"], "GearHelper")

    LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["messages"], GHOptions:GenerateMessagesTable())
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(GearHelper.locals["messages"], GearHelper.locals["messages"], "GearHelper")
end
