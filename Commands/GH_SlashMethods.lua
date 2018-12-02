local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:SlashDisplayHelp()
    GearHelper:Print("state - Display the addon status")
	GearHelper:Print("list - Run a scanBag + scanCharacter")
	print(L["slashCommandConfig"])
	print(L["slashCommandVersion"])
	GearHelper:Print("im 'newMsg' - Change the auto invite token by newMsg")
	GearHelper:Print("createItemLink - Generate a fake itemLink")
	GearHelper:Print("debug - Enable the debug print mode")
	GearHelper:Print("askLoot - Enable the feature (auto ask for loot)")
	GearHelper:Print('dot - Enable the dot on better items icons')
	GearHelper:Print('suppDot - Disable the dot on better items icons')
	print(L["slashCommandCw"])
	GearHelper:Print("ain - Test the ask if needed function")
	GearHelper:Print("reset - Reset GearHelper")
	GearHelper:Print("resetCache - Clear the GearHelper cache")
	GearHelper:Print("printCache - Print the GearHelper cache")
end

function GearHelper:SlashPrintCache()
    for k, v in pairs(GearHelper.db.global.ItemCache) do
        GearHelper:Print(k)
        foreach(v, print)
    end
end

function GearHelper:SlashList()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local _, _, _, _, _, _, link = GetContainerItemInfo(bag, slot)
            if link ~= nil then
                if (strfind(link, "|H(.+)|h") ~= nil) then
                    link = "|cff9d9d9d" .. link .. "|h|h|r"
                end
                GearHelper:Print(bag .. " " .. slot)
                GearHelper:Print(link)
            end
        end
    end
end

function GearHelper:SlashConfig()
    InterfaceOptionsFrame:Show()
    InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:SlashVersion()
    print("|cFF00FF00GearHelper|r|cFFFFFF00 version : " .. version)
end

function GearHelper:SlashIm()
    GearHelper:setInviteMessage(tostring(msg:sub(4)))
end

function GearHelper:SlashCreateItemLink()
    local tempItemLink = "|cff1eff00|Hitem:128942::::::::100:105::::::|h[/gh createItemLink]|h|r"
    GearHelper:Print(tempItemLink)
    GearHelper:Print("GearHelper:IsEquipped = " .. tostring(GearHelper:IsEquipped(tempItemLink)))
    table.foreach(GearHelper:weightCalculation(tempItemLink), print)
end

function GearHelper:SlashAskLoot()
    if GearHelper.db.profile.askLootRaid == true then
        GearHelper:setGHAskLootRaid(false)
    else
        GearHelper:setGHAskLootRaid(true)
    end
end

function GearHelper:SlashDot()
    GearHelper:BuildCWTable()
    GearHelper:sendAskVersion()
    GearHelper:ScanCharacter()
    GearHelper:poseDot()
end

function GearHelper:SlashSuppDot()
    GearHelper:suppDot()
end

function GearHelper:SlashCw()
    InterfaceOptionsFrame:Show()
    InterfaceOptionsFrame_OpenToCategory(GearHelper.cwFrame)
end

function GearHelper:SlashAin()
    GearHelper:CreateLinkAskIfHeNeeds(1)
end

function GearHelper:SlashReset()
    GearHelper:setDefault()
end

function GearHelper:SlashResetCache()
    GearHelper:ResetCache()
end

function GearHelper:SlashDebug()
    GearHelper.db.profile.debug = not GearHelper.db.profile.debug
end

function GearHelper:SlashInspect()
    if (CheckInteractDistance("target", 1)) then
        if CanInspect("target", true) then
            NotifyInspect("target")
            print("------ NotifyInspect() ------")
        else
            print("impossible d'inspecter ce personnage")
            InspectUnit("target")
        end
    else
        print("trop loin")
    end
end