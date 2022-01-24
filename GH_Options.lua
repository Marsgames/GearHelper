local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function GetInvMsg()
    GearHelper:BenchmarkCountFuncCall("GetInvMsg")
    return GearHelper.db.profile.inviteMessage
end

local function GetMyNames()
    GearHelper:BenchmarkCountFuncCall("GetMyNames")
    if (GearHelper.db.global.myNames == {}) then
        table.insert(GearHelper.db.global.myNames, GetUnitName("player") .. ",")
    end

    return GearHelper.db.global.myNames
end

local function GetStatCW(info, stat, bool)
    GearHelper:BenchmarkCountFuncCall("GetStatCW")
    if bool then
        local currentSpec = GetSpecializationInfo(GetSpecialization())
        return tostring(GearHelper.db.global.templates[(currentSpec)]["NOX"][stat])
    else
        if GearHelper.db.profile.CW[info[1]].DisplayAsPercentage then
            local valAsPercentage = (GearHelper.db.profile.CW[info[1]][stat] / 50) * 100
            return tostring(valAsPercentage)
        else
            return tostring(GearHelper.db.profile.CW[info[1]][stat])
        end
    end
end

local function SetStatCW(info, val, stat)
    GearHelper:BenchmarkCountFuncCall("SetStatCW")
    if GearHelper.db.profile.CW[info[1]].DisplayAsPercentage then
        GearHelper.db.profile.CW[info[1]][stat] = (tonumber(val) / 100) * 50
        return tostring(GearHelper.db.profile.CW[info[1]][stat])
    else
        GearHelper.db.profile.CW[info[1]][stat] = tonumber(val)
        return tostring(GearHelper.db.profile.CW[info[1]][stat])
    end
end

local function ValidateInputPattern(val, type, info)
    GearHelper:BenchmarkCountFuncCall("ValidateInputPattern")
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
            if sum > 99 then --Value is stored and if validation failed it's removed so it's taken into account
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
            args = {
                enable = {
                    order = 0,
                    name = L["enable"] .. " GearHelper",
                    desc = L["UIGHCheckBoxAddon"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.addonEnabled = val
                        if val == false then
                            PlaySoundFile(67898, "MASTER")
                        end
                        ---------- A ETUDIER --------
                        local icon = LibStub("LibDBIcon-1.0")
                        local ghIcon = icon:GetMinimapButton("GHIcon")
                        ghIcon.icon = GearHelper.db.profile.addonEnabled and "Interface\\AddOns\\GearHelper\\Textures\\flecheUp" or "Interface\\AddOns\\GearHelper\\Textures\\flecheUpR"
                        icon:Refresh("GHIcon")
                        -----------------------------
                    end,
                    get = function()
                        return GearHelper.db.profile.addonEnabled
                    end
                },
                debug = {
                    order = 1,
                    name = "Debug",
                    hidden = function()
                        if UnitName("player") ~= "Marsgames" and UnitName("player") ~= "Tempaxe" and UnitName("player") ~= "Faerlia" then
                            return true
                        end
                    end,
                    desc = L["UIGHCheckBoxAddon"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.debug = val
                    end,
                    get = function()
                        return GearHelper.db.profile.debug
                    end
                },
                minimapButton = {
                    order = 2,
                    name = L["UIMinimapIcon"],
                    --hidden = function() if UnitName("player") ~= "Marsgames" and UnitName("player") ~= "Tempaxe" then return true end end,
                    desc = L["UIMinimapIconDesc"],
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.minimap = {hide = not val}
                        local icon = LibStub("LibDBIcon-1.0")
                        if (val) then
                            icon:Show("GHIcon")
                        else
                            icon:Hide("GHIcon")
                        end
                    end,
                    get = function()
                        return not GearHelper.db.profile.minimap.hide
                    end
                }
            }
        },
        spacer1 = {
            order = 1,
            name = L["gearOptions"],
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
                    name = L["autoEquipLootedStuff"],
                    desc = L["UIGHCheckBoxAutoEquipLootedStuff"],
                    type = "toggle",
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
                    name = L["UIprintWhenEquip"],
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
                    name = L["lootInRaidAlert"],
                    desc = L["UIGHCheckBoxlootInRaidAlert"],
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
                    name = L["autoEquipSpecChangedStuff"],
                    desc = L["UIGHCheckBoxAutoEquipWhenSwitchSpe"],
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
                    name = L["UIGlobalComputeNotEquippable"],
                    desc = L["UIGlobalComputeNotEquippableDescription"],
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
        }
    }
}

local ghSecondaryOptionsTable = {
    name = L["secondaryOptions"],
    type = "group",
    childGroups = "select",
    args = {
        group3 = {
            order = 4,
            name = " ",
            type = "group",
            inline = true,
            args = {
                autoSell = {
                    order = 0,
                    name = L["sellGrey"],
                    desc = L["UIGHCheckBoxSellGrey"],
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
                    name = L["questRewars"],
                    desc = L["UIGHCheckBoxAutoAcceptQuestReward"],
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
                    name = L["auto-repair"],
                    desc = L["auto-repairDesc"],
                    type = "select",
                    values = {
                        [0] = L["DNR"],
                        [1] = L["AutoRepair"],
                        [2] = L["GuildAutoRepair"]
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
                    desc = L["checkGHAutoTell"],
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
                    name = L["UIautoInvite"],
                    desc = function()
                        return L["UIGHCheckBoxAutoInvite"] .. GearHelper:ColorizeString(GetInvMsg(), "LightGreen")
                    end,
                    type = "toggle",
                    set = function(_, val)
                        GearHelper.db.profile.autoInvite = val
                    end,
                    get = function()
                        return GearHelper.db.profile.autoInvite
                    end
                },
                inviteMessage = {
                    order = 5,
                    name = L["UIinviteMessage"],
                    desc = L["UIinviteMessageDesc"],
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
                    name = L["UIWhisperAlert"],
                    desc = L["UIWhisperAlertDesc"],
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
                    name = L["UISayMyName"],
                    desc = L["UISayMyNameDesc"],
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
                    name = L["UIMyNames"],
                    desc = L["UIMyNamesDesc"],
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
                    name = L["UIBossesKilled"],
                    desc = L["UIBossesKilledDesc"],
                    type = "toggle",
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
                    name = L["UIIlvlCharFrame"],
                    desc = L["UIIlvlCharFrameDesc"],
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
                    name = L["UIIlvlInspectFrame"],
                    desc = L["UIIlvlInspectFrameDesc"],
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
    GearHelper:BenchmarkCountFuncCall("DeleteTemplate")
    local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(L["customWeights"], "dialog", "GearHelper-1.0")

    configTable.args.TemplateSelection.values[info[1]] = nil
    configTable.args.TemplateSelection.values = configTable.args.TemplateSelection.values
    configTable.args[info[1]] = nil
    GearHelper.db.profile.CW[info[1]] = nil

    LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], configTable)
    LibStub("AceConfigRegistry-3.0"):NotifyChange(L["customWeights"])
end

local function CreateNewTemplate(templateName)
    GearHelper:BenchmarkCountFuncCall("CreateNewTemplate")
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
                name = L["UICWasPercentage"],
                desc = L["UICWasPercentageDescription"],
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
                name = L["Tooltip"]["Stat"]["Intellect"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Intellect")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Intellect")
                end
            },
            Strength = {
                order = 2,
                name = L["Tooltip"]["Stat"]["Strength"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Strength")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Strength")
                end
            },
            Agility = {
                order = 3,
                name = L["Tooltip"]["Stat"]["Agility"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Agility")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Agility")
                end
            },
            Stamina = {
                order = 4,
                name = L["Tooltip"]["Stat"]["Stamina"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Stamina")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Stamina")
                end
            },
            Haste = {
                order = 5,
                name = L["Tooltip"]["Stat"]["Haste"],
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
                    return GetStatCW(info, "Haste")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Haste")
                end
            },
            Mastery = {
                order = 6,
                name = L["Tooltip"]["Stat"]["Mastery"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Mastery")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Mastery")
                end
            },
            Critic = {
                order = 7,
                name = L["Tooltip"]["Stat"]["CriticalStrike"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "CriticalStrike")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "CriticalStrike")
                end
            },
            Armor = {
                order = 8,
                name = L["Tooltip"]["Stat"]["Armor"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Armor")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Armor")
                end
            },
            Versatility = {
                order = 9,
                name = L["Tooltip"]["Stat"]["Versatility"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Versatility")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Versatility")
                end
            },
            Leech = {
                order = 10,
                name = L["Tooltip"]["Stat"]["Leech"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Leech")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Leech")
                end
            },
            Avoidance = {
                order = 11,
                name = L["Tooltip"]["Stat"]["Avoidance"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "Avoidance")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "Avoidance")
                end
            },
            MovementSpeed = {
                order = 14,
                name = L["Tooltip"]["Stat"]["MovementSpeed"],
                validate = function(info, val)
                    if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
                        return ValidateInputPattern(val, "numberAnd100", info)
                    else
                        return ValidateInputPattern(val, "number")
                    end
                end,
                type = "input",
                get = function(info)
                    return GetStatCW(info, "MovementSpeed")
                end,
                set = function(info, val)
                    return SetStatCW(info, val, "MovementSpeed")
                end
            },
            ButtonDelete = {
                order = 15,
                name = L["remove"],
                func = function(info)
                    DeleteTemplate(info)
                end,
                type = "execute"
            }
        }
    }
    local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(L["customWeights"], "dialog", "GearHelper-1.0")
    configTable.args[templateName] = newGroup
    configTable.args.TemplateSelection.values[templateName] = templateName
    LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], configTable)
    LibStub("AceConfigRegistry-3.0"):NotifyChange(L["customWeights"])
end

GearHelper.cwTable = {
    name = L["customWeights"],
    type = "group",
    childGroups = "tree",
    args = {
        Select = {
            order = 0,
            name = L["UIstatsTemplateToUse"],
            type = "select",
            style = "radio",
            values = {
                [0] = L["noxxicWeights"],
                [1] = L["customWeights"]
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
                    if GearHelper:GetArraySize(GearHelper.db.profile.CW) == 0 or not GearHelper.db.profile.lastWeightTemplate then --To avoid error if we select custome weight and we do not create a template
                        GearHelper.db.profile.weightTemplate = "NOX_ByDefault"
                    else
                        GearHelper.db.profile.weightTemplate = GearHelper.db.profile.lastWeightTemplate
                        LibStub("AceConfigDialog-3.0"):SelectGroup(L["customWeights"], GearHelper.db.profile.weightTemplate)
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
                    name = L["UIcwGemSocketCompute"],
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
                    name = L["UIcwIlvlOption"],
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
                    name = L["UIcwIlvlWeight"],
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
            name = L["UItemplateName"],
            type = "input",
            width = "double",
            validate = function(_, val)
                return ValidateInputPattern(val, "alpha")
            end,
            get = function()
            end,
            set = function(_, val)
                CreateNewTemplate(val)
                LibStub("AceConfigDialog-3.0"):SelectGroup(L["customWeights"], val)
            end
        },
        TemplateSelection = {
            order = 3,
            name = L["UIcwTemplateToUse"],
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
                LibStub("AceConfigDialog-3.0"):SelectGroup(L["customWeights"], val)
            end,
            values = {}
        },
        NoxGroup = {
            name = "Noxxic",
            type = "group",
            args = {
                Intell = {
                    order = 1,
                    name = L["Tooltip"]["Stat"]["Intellect"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Intellect", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Intellect", 1) == 0 then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Strength = {
                    order = 2,
                    name = L["Tooltip"]["Stat"]["Strength"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Strength", 1)
                    end,
                    disabled = function()
                        return true
                    end,
                    hidden = function(info)
                        if GetStatCW(info, "Agility", 1) == "0" then
                            return true
                        end
                    end
                },
                Agility = {
                    order = 3,
                    name = L["Tooltip"]["Stat"]["Agility"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Agility", 1)
                    end,
                    disabled = function()
                        return true
                    end,
                    hidden = function()
                        if GetStatCW("", "Agility", 1) == "0" then
                            return true
                        end
                    end
                },
                Stamina = {
                    order = 4,
                    name = L["Tooltip"]["Stat"]["Stamina"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Stamina", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Stamina", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Haste = {
                    order = 5,
                    name = L["Tooltip"]["Stat"]["Haste"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Haste", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Haste", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Mastery = {
                    order = 6,
                    name = L["Tooltip"]["Stat"]["Mastery"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Mastery", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Mastery", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Critic = {
                    order = 7,
                    name = L["Tooltip"]["Stat"]["CriticalStrike"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "CriticalStrike", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "CriticalStrike", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Armor = {
                    order = 8,
                    name = L["Tooltip"]["Stat"]["Armor"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Armor", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Armor", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Versatility = {
                    order = 9,
                    name = L["Tooltip"]["Stat"]["Versatility"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Versatility", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Versatility", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Leech = {
                    order = 10,
                    name = L["Tooltip"]["Stat"]["Leech"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Leech", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Leech", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                Avoidance = {
                    order = 11,
                    name = L["Tooltip"]["Stat"]["Avoidance"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "Avoidance", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "Avoidance", 1) == "0" then
                            return true
                        end
                    end,
                    disabled = function()
                        return true
                    end
                },
                MovementSpeed = {
                    order = 14,
                    name = L["Tooltip"]["Stat"]["MovementSpeed"],
                    type = "input",
                    get = function(info)
                        return GetStatCW(info, "MovementSpeed", 1)
                    end,
                    hidden = function()
                        if GetStatCW("", "MovementSpeed", 1) == "0" then
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
    GearHelper:BenchmarkCountFuncCall("GearHelper:BuildCWTable")
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
                        name = L["UICWasPercentage"],
                        desc = L["UICWasPercentageDescription"],
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
                        name = L["Tooltip"]["Stat"]["Intellect"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Intellect")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Intellect")
                        end
                    },
                    Strength = {
                        order = 2,
                        name = L["Tooltip"]["Stat"]["Strength"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Strength")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Strength")
                        end
                    },
                    Agility = {
                        order = 3,
                        name = L["Tooltip"]["Stat"]["Agility"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Agility")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Agility")
                        end
                    },
                    Stamina = {
                        order = 4,
                        name = L["Tooltip"]["Stat"]["Stamina"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Stamina")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Stamina")
                        end
                    },
                    Haste = {
                        order = 5,
                        name = L["Tooltip"]["Stat"]["Haste"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Haste")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Haste")
                        end
                    },
                    Mastery = {
                        order = 6,
                        name = L["Tooltip"]["Stat"]["Mastery"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Mastery")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Mastery")
                        end
                    },
                    Critic = {
                        order = 7,
                        name = L["Tooltip"]["Stat"]["CriticalStrike"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "CriticalStrike")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "CriticalStrike")
                        end
                    },
                    Armor = {
                        order = 8,
                        name = L["Tooltip"]["Stat"]["Armor"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Armor")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Armor")
                        end
                    },
                    Versatility = {
                        order = 9,
                        name = L["Tooltip"]["Stat"]["Versatility"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Versatility")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Versatility")
                        end
                    },
                    Leech = {
                        order = 10,
                        name = L["Tooltip"]["Stat"]["Leech"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Leech")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Leech")
                        end
                    },
                    Avoidance = {
                        order = 11,
                        name = L["Tooltip"]["Stat"]["Avoidance"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "Avoidance")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "Avoidance")
                        end
                    },
                    MovementSpeed = {
                        order = 14,
                        name = L["Tooltip"]["Stat"]["MovementSpeed"],
                        validate = function(info, val)
                            if v.DisplayAsPercentage then
                                return ValidateInputPattern(val, "numberAnd100", info)
                            else
                                return ValidateInputPattern(val, "number")
                            end
                        end,
                        type = "input",
                        get = function(info)
                            return GetStatCW(info, "MovementSpeed")
                        end,
                        set = function(info, val)
                            return SetStatCW(info, val, "MovementSpeed")
                        end
                    },
                    ButtonDelete = {
                        order = 15,
                        name = L["remove"],
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
    LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], GearHelper.cwTable)
    LibStub("AceConfigRegistry-3.0"):NotifyChange(L["customWeights"])
end

local phrasesTable = {
    name = L["phrases"],
    type = "group",
    args = {
        english = {
            order = 0,
            name = "English",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "english",
                    fontSize = "medium"
                },
                -- Rep2 = {
                --     order = 15,
                --     name = "",
                --     type = "input",
                --     width = "double",
                --     get = function(info)
                --         return GearHelper.db.global.phrases.enUS.rep2
                --     end,
                --     set = function(info, val)
                --         GearHelper.db.global.phrases.enUS.rep2 = val
                --     end
                -- },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.enUS = {}
                        GearHelper.db.global.phrases.enUS.demande4 = L["demande4enUS"]
                        GearHelper.db.global.phrases.enUS.demande42 = L["demande4enUS2"]
                        GearHelper.db.global.phrases.enUS.rep = L["repenUS"]
                        GearHelper.db.global.phrases.enUS.rep2 = L["repenUS2"]
                    end
                }
            }
        },
        french = {
            order = 1,
            name = "French",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.frFR.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.frFR.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.frFR.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.frFR.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.frFR.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.frFR.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "français",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.frFR.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.frFR.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.frFR = {}
                        GearHelper.db.global.phrases.frFR.demande4 = L["demande4frFR"]
                        GearHelper.db.global.phrases.frFR.demande42 = L["demande4frFR2"]
                        GearHelper.db.global.phrases.frFR.rep = L["repfrFR"]
                        GearHelper.db.global.phrases.frFR.rep2 = L["repfrFR2"]
                    end
                }
            }
        },
        German = {
            order = 2,
            name = "German",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.deDE.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.deDE.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.deDE.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.deDE.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.deDE.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.deDE.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "deutsch",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.deDE.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.deDE.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.deDE = {}
                        GearHelper.db.global.phrases.deDE.demande4 = L["demande4deDE"]
                        GearHelper.db.global.phrases.deDE.demande42 = L["demande4deDE2"]
                        GearHelper.db.global.phrases.deDE.rep = L["repdeDE"]
                        GearHelper.db.global.phrases.deDE.rep2 = L["repdeDE2"]
                    end
                }
            }
        },
        Spanish = {
            order = 3,
            name = "Spanish",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.esES.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esES.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.esES.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esES.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.esES.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esES.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "español",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.esES.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esES.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.esES = {}
                        GearHelper.db.global.phrases.esES.demande4 = L["demande4esES"]
                        GearHelper.db.global.phrases.esES.demande42 = L["demande4esES2"]
                        GearHelper.db.global.phrases.esES.rep = L["repesES"]
                        GearHelper.db.global.phrases.esES.rep2 = L["repesES2"]
                    end
                }
            }
        },
        Mexican = {
            order = 4,
            name = "Mexican",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.esMX.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esMX.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.esMX.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esMX.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.esMX.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esMX.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "español",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.esMX.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.esMX.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.esMX = {}
                        GearHelper.db.global.phrases.esMX.demande4 = L["demande4esMX"]
                        GearHelper.db.global.phrases.esMX.demande42 = L["demande4esMX2"]
                        GearHelper.db.global.phrases.esMX.rep = L["repesMX"]
                        GearHelper.db.global.phrases.esMX.rep2 = L["repesMX2"]
                    end
                }
            }
        },
        Italian = {
            order = 5,
            name = "Italian",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.itIT.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.itIT.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.itIT.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.itIT.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "italiano",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.itIT.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.itIT.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.itIT = {}
                        GearHelper.db.global.phrases.itIT.demande4 = L["demande4itIT"]
                        GearHelper.db.global.phrases.itIT.demande42 = L["demande4itIT2"]
                        GearHelper.db.global.phrases.itIT.rep = L["repitIT"]
                        GearHelper.db.global.phrases.itIT.rep2 = L["repitIT2"]
                    end
                }
            }
        },
        Korean = {
            order = 6,
            name = "Korean",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.koKR.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.koKR.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.koKR.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.koKR.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "한국어",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.koKR.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.koKR.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.koKR = {}
                        GearHelper.db.global.phrases.koKR.demande4 = L["demande4koKR"]
                        GearHelper.db.global.phrases.koKR.demande42 = L["demande4koKR2"]
                        GearHelper.db.global.phrases.koKR.rep = L["repkoKR"]
                        GearHelper.db.global.phrases.koKR.rep2 = L["repkoKR2"]
                    end
                }
            }
        },
        Portuguese = {
            order = 7,
            name = "Portuguese",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.ptBR.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.ptBR.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.ptBR.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.ptBR.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "Português",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.ptBR.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.ptBR.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.ptBR = {}
                        GearHelper.db.global.phrases.ptBR.demande4 = L["demande4ptBR"]
                        GearHelper.db.global.phrases.ptBR.demande42 = L["demande4ptBR2"]
                        GearHelper.db.global.phrases.ptBR.rep = L["repptBR"]
                        GearHelper.db.global.phrases.ptBR.rep2 = L["repptBR2"]
                    end
                }
            }
        },
        Russian = {
            order = 8,
            name = "Russian",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.ruRU.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.ruRU.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.ruRU.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.ruRU.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "русский",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.ruRU.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.ruRU.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.ruRU = {}
                        GearHelper.db.global.phrases.ruRU.demande4 = L["demande4ruRU"]
                        GearHelper.db.global.phrases.ruRU.demande42 = L["demande4ruRU2"]
                        GearHelper.db.global.phrases.ruRU.rep = L["repruRU"]
                        GearHelper.db.global.phrases.ruRU.rep2 = L["repruRU2"]
                    end
                }
            }
        },
        SimplifiedChinese = {
            order = 9,
            name = "Simplified Chinese",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.zhCN.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.zhCN.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.zhCN.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.zhCN.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "中文",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.zhCN.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.zhCN.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.zhCN = {}
                        GearHelper.db.global.phrases.zhCN.demande4 = L["demande4zhCN"]
                        GearHelper.db.global.phrases.zhCN.demande42 = L["demande4zhCN2"]
                        GearHelper.db.global.phrases.zhCN.rep = L["repzhCN"]
                        GearHelper.db.global.phrases.zhCN.rep2 = L["repzhCN2"]
                    end
                }
            }
        },
        TraditionalChinese = {
            order = 10,
            name = "Traditional Chinese",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.phrases.zhTW.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.zhTW.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.zhTW.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.zhTW.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "中文",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.phrases.zhTW.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.phrases.zhTW.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.phrases.zhTW = {}
                        GearHelper.db.global.phrases.zhTW.demande4 = L["demande4zhTW"]
                        GearHelper.db.global.phrases.zhTW.demande42 = L["demande4zhTW2"]
                        GearHelper.db.global.phrases.zhTW.rep = L["repzhTW"]
                        GearHelper.db.global.phrases.zhTW.rep2 = L["repzhTW2"]
                    end
                }
            }
        }
    }
}

local aboutTable = {
    name = "About",
    type = "group",
    args = {
        version = {
            order = 0,
            fontSize = "medium",
            name = "\n\n\n\n\n                |cFFFFFF00Version :|r " .. GearHelperVars.version .. "\n",
            type = "description"
        },
        author = {
            order = 1,
            fontSize = "medium",
            name = "                |cFFFFFF00Author :|r Marsgames - Temple Noir\n                               Tempaxe - Temple Noir" --[[Ta mère]] .. " \n",
            type = "description"
        },
        email = {
            order = 2,
            fontSize = "medium",
            name = "                |cFFFFFF00E-Mail :|r marsgames@gmail.com" .. " \n",
            type = "description"
        },
        bug = {
            order = 3,
            fontSize = "medium",
            name = "                |cFFFFFF00BugReport :|r http://vu.fr/GearHelperbugs  \n",
            type = "description"
        },
        credits = {
            order = 4,
            fontSize = "medium",
            name = "                |cFFFFFF00Credits :|r Big up\n",
            type = "description"
        },
        bug2 = {
            name = "                   |cFFFFFF00BugReport : ",
            desc = "Click then ctrl + A to select and ctrl + C to copy",
            type = "input",
            get = function()
                return "|cFF4477c9https://github.com/Marsgames/GearHelper/issues"
            end,
            width = "double"
        }
    }
}

local thanksTable = {
    name = L["thanksPanel"],
    type = "group",
    args = {
        name1 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Nirek |r - Bug report + bug fix",
            type = "description"
        },
        name2 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 titaniumcoder |r - Bug report + bug fix",
            type = "description"
        },
        name3 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 deathcore01 |r - Bug report + DE translation",
            type = "description"
        },
        name4 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Ricosoft |r - DE translation",
            type = "description"
        },
        name5 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 gOOvER |r - DE translation",
            type = "description"
        },
        name6 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 yasen |r - ZH translation",
            type = "description"
        },
        name7 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 ArnosEmpero |r - Bug report",
            type = "description"
        },
        name8 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Schwoops |r - Bug report",
            type = "description"
        },
        name9 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 666cursed666 |r - Bug report",
            type = "description"
        },
        name10 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 xevilgrin |r - Bug report",
            type = "description"
        },
        name11 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Comicus |r - Bug report",
            type = "description"
        },
        name12 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Merxion |r - Bug report",
            type = "description"
        },
        name13 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 treyer75 |r - Bug report",
            type = "description"
        },
        name14 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 canlo21 |r - Bug report",
            type = "description"
        },
        name15 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Veritias |r - Bug report",
            type = "description"
        },
        name16 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 aresyyywang |r - Bug report",
            type = "description"
        },
        name17 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Seanross19 |r - Bug report",
            type = "description"
        },
        name18 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 jmac420 |r - Bug report",
            type = "description"
        },
        name19 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 cptcl |r - Bug report",
            type = "description"
        },
        name20 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 NaomiErin |r - Bug report",
            type = "description"
        },
        name21 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 CeloSG |r - Bug report + DE translation",
            type = "description"
        },
        name22 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 MaYcKe25 |r - BR translation",
            type = "description"
        },
        name23 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 john_yasen |r - CN translation",
            type = "description"
        },
        name24 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Imna1975 |r - Bug report",
            type = "description"
        },
        name25 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 the777ahmad |r - Bug report",
            type = "description"
        },
        name26 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Newill-Kristin |r - Bug report",
            type = "description"
        },
        name27 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 zloy-online |r - Bug report",
            type = "description"
        },
        name28 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 vaendryl |r - Bug report",
            type = "description"
        },
        name29 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 TheRedBull |r - Bug report",
            type = "description"
        },
        name30 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 MarshallBuhl |r - Bug report",
            type = "description"
        },
        name31 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Zallanon |r - Bug report",
            type = "description"
        },
        name32 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 cz016m |r - Bug report",
            type = "description"
        },
        name33 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 tomas352000 |r - Bug report",
            type = "description"
        },
        name34 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 keithgeeker |r - Bug report + improvement",
            type = "description"
        },
        name35 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 knightfire120 |r - Bug report",
            type = "description"
        },
        name36 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 netaras |r - KR translation",
            type = "description"
        }
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("GearHelper", ghOptionsTable, "ghOption")
LibStub("AceConfig-3.0"):RegisterOptionsTable(L["secondaryOptions"], ghSecondaryOptionsTable)
LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], GearHelper.cwTable)
LibStub("AceConfig-3.0"):RegisterOptionsTable(L["phrases"], phrasesTable)
LibStub("AceConfig-3.0"):RegisterOptionsTable(L["thanksPanel"], thanksTable)
GearHelper.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GearHelper")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["secondaryOptions"], L["secondaryOptions"], "GearHelper")
GearHelper.cwFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["customWeights"], L["customWeights"], "GearHelper")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["phrases"], L["phrases"], "GearHelper")
LibStub("LibAboutPanel").new("GearHelper", "GearHelper")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["thanksPanel"], L["thanksPanel"], "GearHelper")
