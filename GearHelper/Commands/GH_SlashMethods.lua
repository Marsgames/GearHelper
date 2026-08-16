local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:SlashDisplayHelp()
    print("|cFF00FF00GearHelper|r :")
    print("  /gh            - " .. L["helpConfig"])
    print("  /gh help       - " .. L["helpHelp"])
    print("  /gh version    - " .. L["helpVersion"])
    print("  /gh cw         - " .. L["helpCW"])
    print("  /gh template   - " .. L["helpCW"])
    print("  /gh reset      - " .. L["helpReset"])
    if GearHelper:IsAdmin() then
        print("|cFFFF9900" .. L["helpAdminCommands"] .. "|r")
        print("  /gh debug          - " .. L["helpDebug"])
        print("  /gh resetdebug     - " .. L["helpResetDebug"])
        print("  /gh reload         - " .. L["helpReload"])
        print("  /gh ain            - " .. L["helpAin"])
        print("  /gh createitemlink - " .. L["helpCreateItemLink"])
    end
end

function GearHelper:SlashVersion()
    print("|cFF00FF00GearHelper|r |cFFFFFF00version : " .. GearHelperVars.version .. "|r")
end

function GearHelper:SlashCw()
    if GearHelper.cwCategoryID then
        Settings.OpenToCategory(GearHelper.cwCategoryID)
    elseif GearHelper.optionsCategoryID then
        Settings.OpenToCategory(GearHelper.optionsCategoryID)
    end
end

function GearHelper:SlashReset()
    GearHelper.db.profileKeys = nil
    GearHelper.db.global = nil
    GearHelper.db.profiles = nil
    GearHelper.db = nil
    ReloadUI()
end

function GearHelper:SlashAin()
    print("|cFF00FF00GearHelper|r - Testing AskIfNeeded (self-whisper)...")
    GearHelper:CreateLinkAskIfHeNeeds(1)
end

function GearHelper:SlashCreateItemLink()
    local tempItemLink = "|cff1eff00|Hitem:128942::::::::100:105::::::|h[/gh createItemLink]|h|r"
    local item = GHItem:Create(tempItemLink)
    if item and not item.isEmpty then
        print("itemLink : " .. tempItemLink)
        print("score : " .. tostring(item:GetScore()))
        print("isBetter : " .. tostring(GearHelper:IsItemBetter(item)))
    else
        print("Item data not cached yet, retry in a moment")
    end
end

-- Admin only --

function GearHelper:SlashDebug()
    GearHelper.db.profile.debug.general = not GearHelper.db.profile.debug.general
    print("GearHelper debug mode : " .. tostring(GearHelper.db.profile.debug.general))
    securecall(GHOptions.GenerateOptions)
end

function GearHelper:SlashResetDebug()
    GearHelper.db.profile.debug = GearHelper.defaultSettings.debug
    securecall(GHOptions.GenerateOptions)
end

function GearHelper:SlashReload()
    ReloadUI()
end
