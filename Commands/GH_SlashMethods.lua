local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:SlashDisplayHelp()
    GearHelper:Print("state - Display the addon status")
    GearHelper:Print("list - Run a scanBag + scanCharacter")
    print(L["helpConfig"])
    print(L["helpCW"])
    print(L["helpVersion"])
    GearHelper:Print("im 'newMsg' - Change the auto invite token by newMsg")
    GearHelper:Print("createItemLink - Generate a fake itemLink")
    print(L["helpDebug"])
    -- GearHelper:Print("askLoot - Enable the feature (auto ask for loot)")
    GearHelper:Print("dot - Enable the dot on better items icons")
    GearHelper:Print("suppDot - Disable the dot on better items icons")
    GearHelper:Print("ain - Test the ask if needed function")
    GearHelper:Print("reset - Reset GearHelper")
    GearHelper:Print("resetCache - Clear the GearHelper cache")
    GearHelper:Print("printCache - Print the GearHelper cache")
    GearHelper:Print("countCache - count number of items in cache")
    -- GearHelper:Print("test - run unit tests")
end

function GearHelper:SlashCountCache()
    GearHelper:Print(GearHelper:GetArraySize(GearHelper.db.global.ItemCache))
end

function GearHelper:SlashPrintCache()
    for k, v in pairs(GearHelper.db.global.ItemCache) do
        GearHelper:Print("--- " .. k)
        if (GearHelper.db.profile.debug) then
            for kk, vv in pairs(v) do
                print("   " .. kk .. " - " .. tostring(vv))
            end
        end
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
    print("|cFF00FF00GearHelper|r|cFFFFFF00 version : " .. GearHelperVars.version)
end

function GearHelper:SlashIm()
    GearHelper:setInviteMessage(tostring(msg:sub(4)))
end

function GearHelper:SlashCreateItemLink()
    local tempItemLink = "|cff1eff00|Hitem:128942::::::::100:105::::::|h[/gh createItemLink]|h|r"
    GearHelper:Print(tempItemLink)
    GearHelper:Print("GearHelper:IsEquipped = " .. tostring(IsEquippedItem(tempItemLink)))
    table.foreach(GearHelper:NewWeightCalculation(tempItemLink), GearHelper.Print)
end

-- function GearHelper:SlashAskLoot()
-- if GearHelper.db.profile.askLootRaid == true then
--     GearHelper:setGHAskLootRaid(false)
-- else
--     GearHelper:setGHAskLootRaid(true)
-- end
-- end

function GearHelper:SlashDot()
    GearHelper:BuildCWTable()
    -- GearHelper:SendAskVersion()
    GearHelper:ScanCharacter()
    GearHelper:SetDotOnIcons()
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
    GearHelper:ResetCache()
    GearHelper.db.profileKeys = {}
    GearHelper.db.profileKeys = nil
    GearHelper.db.global = {}
    GearHelper.db.global = nil
    GearHelper.db.profiles = {}
    GearHelper.db.profiles = nil
    GearHelper.db = {}
    GearHelper.db = nil
    ReloadUI()
end

function GearHelper:SlashResetCache()
    GearHelper:ResetCache()
    print("cache reseted")
end

function GearHelper:SlashDebug()
    GearHelper.db.profile.debug = not GearHelper.db.profile.debug
    print("debug mode set to " .. tostring(GearHelper.db.profile.debug))
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

function GearHelper:SlashCheck()
    if (not lfrCheckButton_GlobalName) then
        lfrCheckButton = CreateFrame("CheckButton", "lfrCheckButton_GlobalName", UIParent, "ChatConfigCheckButtonTemplate")
        lfrCheckButton:SetPoint("TOPRIGHT", -325, -45)
        lfrCheckButton_GlobalNameText:SetText(L["lfrCheckButtonText"])
        lfrCheckButton.tooltip = L["lfrCheckButtonTooltip"]
        lfrCheckButton:SetScript(
            "OnClick",
            function()
                azeCheck = lfrCheckButton:GetChecked()
            end
        )
    else
        lfrCheckButton_GlobalName:Show()
    end
end

function GearHelper:SlashTest()
    local editbox = ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME) --  Get an editbox
    ChatEdit_ActivateChat(editbox) --   Show the editbox
    editbox:SetText("/test GearHelper") -- Command goes here
    ChatEdit_OnEnterPressed(editbox) -- Process command and hide (runs ChatEdit_SendText() and ChatEdit_DeactivateChat() respectively)
end

function GearHelper:SlashBenchmark()
    GearHelper:SwapBenchmarkMode()
    GearHelper:Print("Benchmark Mode : " .. tostring(GearHelper:GetBenchmarkMode()))
end

function GearHelper:SlashBenchmarkCountResult()
    if not GearHelper:GetBenchmarkMode() then
        print("Benchmark Mode not enabled ! Use /gh benchmark")
        return
    end

    function createTuples(array)
        local tuples = {}
        for k, v in pairs(array) do
            tuples[#tuples + 1] = {v, k}
        end
        return tuples
    end
    function compare(a, b)
        return a[1] > b[1]
    end

    local query = GearHelper:GetBenchmarkResult("Count")
    local tuples = createTuples(query)
    table.sort(tuples, compare)

    print("-----")
    for k, v in pairs(tuples) do
        print(v[2] .. " -> " .. v[1])
    end
end

function GearHelper:SlashBenchmarkResetCountResult()
    GearHelper:ResetBenchmark("Count")
end
