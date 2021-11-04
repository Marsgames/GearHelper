local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function OnMinimapTooltipShow(tooltip)
    GearHelper:BenchmarkCountFuncCall("OnMinimapTooltipShow")
    tooltip:SetOwner(LibDBIcon10_GHIcon, "ANCHOR_TOPRIGHT", -15, -100)
    tooltip:SetText(GearHelper:ColorizeString("GearHelper", GearHelper.db.profile.addonEnabled and "LightGreen" or "LightRed"))

    if not GearHelper.db.profile.addonEnabled then
        tooltip:AddLine(GearHelper:ColorizeString(L["Addon"], "Yellow") .. GearHelper:ColorizeString(L["DeactivatedRed"], "LightRed"), 1, 1, 1)
    end

    tooltip:AddLine(GearHelper:ColorizeString(L["MmTtLClick"], "Yellow"), 1, 1, 1)

    if GearHelper.db.profile.addonEnabled then
        tooltip:AddLine(GearHelper:ColorizeString(L["MmTtRClickDeactivate"], "Yellow"), 1, 1, 1)

        if GearHelper.db.profile.minimap.isLock then
            tooltip:AddLine(GearHelper:ColorizeString(L["MmTtClickUnlock"], "Yellow"), 1, 1, 1)
        else
            tooltip:AddLine(GearHelper:ColorizeString(L["MmTtClickLock"], "Yellow"), 1, 1, 1)
        end

        tooltip:AddLine(GearHelper:ColorizeString(L["MmTtCtrlClick"], "Yellow"), 1, 1, 1)
    else
        tooltip:AddLine(GearHelper:ColorizeString(L["MmTtRClickActivate"], "Yellow"), 1, 1, 1)
    end

    tooltip:Show()
end

local function OnMinimapTooltipClick(button, tooltip)
    GearHelper:BenchmarkCountFuncCall("OnMinimapTooltipClick")
    if InterfaceOptionsFrame:IsShown() then
        InterfaceOptionsFrame:Hide()
    else
        local icon = LibStub("LibDBIcon-1.0")

        if IsShiftKeyDown() then
            if (GearHelper.db.profile.minimap.isLock) then
                icon:Unlock("GHIcon")
            else
                icon:Lock("GHIcon")
            end

            GearHelper.db.profile.minimap.isLock = not GearHelper.db.profile.minimap.isLock
            tooltip:Hide()
            OnMinimapTooltipShow(tooltip)
        elseif IsControlKeyDown() then
            icon:Hide("GHIcon")
            GearHelper.db.profile.minimap.hide = true
        else
            if (button == "LeftButton") then
                InterfaceOptionsFrame:Show()
                InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
            else
                GearHelper.db.profile.addonEnabled = not GearHelper.db.profile.addonEnabled
                tooltip:Hide()
                OnMinimapTooltipShow(tooltip)
            end
        end
    end
end

function GearHelper:CreateMinimapIcon()
    GearHelper:BenchmarkCountFuncCall("CreateMinimapIcon")
    local tooltip = tooltip or CreateFrame("GameTooltip", "tooltip", nil, BackdropTemplateMixin and "BackdropTemplate")
    local icon = LibStub("LibDBIcon-1.0")
    local GHIcon =
        LibStub("LibDataBroker-1.1"):NewDataObject(
        "GHIcon",
        {
            type = "data source",
            text = "GearHelper",
            icon = "Interface\\AddOns\\GearHelper\\Textures\\flecheUp",
            label = "GearHelper",
            OnClick = function(_, button)
                OnMinimapTooltipClick(button, tooltip)
            end,
            OnTooltipShow = function()
                OnMinimapTooltipShow(tooltip)
            end,
            OnLeave = function()
                tooltip:Hide()
            end
        }
    )
    icon:Register("GHIcon", GHIcon, GearHelper.db.profile.minimap)
end
