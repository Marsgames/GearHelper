local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local lfrCheckIsChecked = false
local lastBagUpdateEvent = time()
local waitSpeFrame = CreateFrame("Frame")
local delaySpeTimer = 0.5
local moneyFlux = 0

-- GearHelperVars.waitSpeFrame:Hide()
waitSpeFrame:Hide()

--------------------------------- Functions ---------------------------------
-- This function handle the BossesKilled function. It's called in PlayerLogin event.
local function BossesKilledFunctions()
    local theFrame = nil
    -- When the LFR frame shows up
    local function LfrFrameShow(frame)
        GearHelper:BenchmarkCountFuncCall("LfrFrameShow")
        if not GearHelper.db.profile.bossesKilled then
            do
                return
            end
        end
        theFrame = frame

        GearHelper:CreateLfrButtons(theFrame)
        GearHelper:UpdateButtonsAndTooltips(theFrame)
        GearHelper:UpdateGHLfrButton()
        GearHelper:UpdateSelectCursor()
        GearHelper:RegisterEvent("LFG_UPDATE")
        GearHelper.LFG_UPDATE = GearHelper.UpdateGHLfrButton
    end

    -- When the LFR frame is closed
    local function LfrFrameHide()
        GearHelper:BenchmarkCountFuncCall("LfrFrameHide")
        GearHelper:HideLfrButtons(theFrame)
        GearHelper:UnregisterEvent("LFG_UPDATE")
    end

    RaidFinderQueueFrame:HookScript("OnShow", LfrFrameShow)
    RaidFinderQueueFrame:HookScript("OnHide", LfrFrameHide)
    hooksecurefunc("RaidFinderQueueFrame_SetRaid", GearHelper.UpdateSelectCursor)
end

local function delayBetweenEquip(frame)
    GearHelper:BenchmarkCountFuncCall("delayBetweenEquip")
    if time() <= GearHelperVars.waitSpeTimer + delaySpeTimer then
        return
    end
    for bag = 0, 4 do
        numBag = bag
        GearHelper:EquipItem()
    end
    frame:Hide()
end

-- GearHelperVars.waitSpeFrame:SetScript("OnUpdate", delayBetweenEquip)
waitSpeFrame:SetScript("OnUpdate", delayBetweenEquip)

-----------------------------------------------------------------------------
----------------------------------- Events ----------------------------------

local function AddonLoaded(_, _, name)
    GearHelper:BenchmarkCountFuncCall("AddonLoaded")
    if GearHelper and GearHelper.db and GearHelper.db.global.templates == nil then
        GearHelper.db.global.templates = {}
    end

    GearHelper:InitTemplates()

    if name ~= addonName then
        do
            return
        end
    end

    print(GearHelper:ColorizeString(L["merci"], "LightGreen"))
    local runningBuild = select(4, GetBuildInfo())
    if GearHelper.db.global.buildVersion ~= runningBuild then
        GearHelper.db.global.buildVersion = runningBuild
        GearHelper:ResetCache()
    end
end

local function OnMerchantShow()
    GearHelper:BenchmarkCountFuncCall("OnMerchantShow")
    moneyFlux = GetMoney()

    GearHelper:SellGreyItems()
    GearHelper:RepairEquipment()

    GearHelper:ScanCharacter()
    GearHelper:SetDotOnIcons()
end

-- TODO: Split this shit too
local function PlayerEnteringWorld()
    GearHelper:BenchmarkCountFuncCall("PlayerEnteringWorld")
    local used = false
    for i = 1, NUM_CHAT_WINDOWS do
        local _, _, _, _, _, _, _, _, _, uninteractable = GetChatWindowInfo(i)
        if (uninteractable) then
            SetChatWindowUninteractable(i, false)
            used = true
        end
    end
    if used then
        ReloadUI()
    end

    GearHelper:BuildCWTable()
    if GearHelper.db.profile.addonEnabled == true then
        GearHelper:SendAskVersion()
        GearHelper:ScanCharacter()
        GearHelper:SetDotOnIcons()

        if (not string.match(GearHelper.db.global.myNames, GetUnitName("player") .. ",")) then
            GearHelper.db.global.myNames = GearHelper.db.global.myNames .. GetUnitName("player") .. ","
        end
    end

    local _, instanceType, _, _, _, _, _, _, _, lfgDungeonsID = GetInstanceInfo()
    if "raid" == instanceType then
        if (nil == lfgDungeonsID) then
            lfrCheckIsChecked = false
            if (lfrCheckButton_GlobalName) then
                lfrCheckButton_GlobalName:Hide()
            end
            do
                return
            end
        end

        lfrCheckButton = lfrCheckButton_GlobalName or CreateFrame("CheckButton", "lfrCheckButton_GlobalName", UIParent, "ChatConfigCheckButtonTemplate")
        lfrCheckButton:SetPoint("TOPRIGHT", -325, -50)
        lfrCheckButton_GlobalNameText:SetText(L["lfrCheckButtonText"])
        lfrCheckButton.tooltip = L["lfrCheckButtonTooltip"]
        lfrCheckButton:SetScript(
            "OnClick",
            function()
                lfrCheckIsChecked = lfrCheckButton:GetChecked()
            end
        )
        -- else
        lfrCheckButton_GlobalName:Show()
        lfrCheckButton_GlobalName:SetChecked(lfrCheckIsChecked)
    else
        lfrCheckIsChecked = false
        if (lfrCheckButton_GlobalName) then
            lfrCheckButton_GlobalName:Hide()
        end
    end
end

local function ChatMsgAddon(_, _, prefixMessage, message, _, sender)
    GearHelper:BenchmarkCountFuncCall("ChatMsgAddon")
    if prefixMessage ~= GearHelperVars.prefixAddon then
        do
            return
        end
    end
    if not GearHelper.db.profile.addonEnabled then
        do
            return
        end
    end

    local emetteur = ""
    if sender:find("-") then
        emetteur = sender:sub(0, (sender:find("-") - 1))
    else
        emetteur = sender
    end

    if emetteur == GetUnitName("player") then
        do
            return
        end
    end
    local prefVersion = message:sub(0, (message:find(";") - 1))
    if prefVersion == "answerVersion" then
        local vVersion = message:sub(message:find(";") + 1, #message)
        versionCible = vVersion
        GearHelper:ReceiveAnswer(vVersion, sender)
    end
    if prefVersion == "askVersion" then
        GearHelper:SendAnswerVersion()
    end
end

local function ItemPush(_, _, bag)
    GearHelper:BenchmarkCountFuncCall("ItemPush")

    if not GearHelper.db.profile.autoEquipLooted.actual then
        do
            return
        end
    end

    local theBag = bag
    if bag == 23 then
        theBag = 4
    elseif bag == 22 then
        theBag = 3
    elseif bag == 21 then
        theBag = 2
    elseif bag == 20 then
        theBag = 1
    end

    GearHelper:EquipItem(theBag)
end

local function QuestComplete()
    GearHelper:BenchmarkCountFuncCall("QuestComplete")
    GearHelper.GetQuestRewardCoroutine =
        coroutine.create(
        function()
            GearHelper:GetQuestReward()
        end
    )
    coroutine.resume(GearHelper.GetQuestRewardCoroutine)
end

local function QuestFinished()
    GearHelper:BenchmarkCountFuncCall("QuestFinished")

    if (nil == GearHelper.ButtonQuestReward) then
        do
            return
        end
    end

    table.foreach(
        GearHelper.ButtonQuestReward,
        function(button)
            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end
        end
    )
end

-- TODO: Split that shit
local function QuestDetail()
    GearHelper:BenchmarkCountFuncCall("QuestDetail")

    local weightTable = {}
    local prixTable = {}
    local altTable = {}
    local numQuestChoices = GetNumQuestChoices()
    local isBetter = false

    if (0 == numQuestChoices) then
        do
            return
        end
    end

    for i = 1, numQuestChoices do
        local item = GearHelper:GetItemByLink(GetQuestItemLink("choice", i))

        if item.type ~= L["armor"] and item.type ~= L["weapon"] then
            do
                return
            end
        end

        local status, res = pcall(GearHelper.NewWeightCalculation, self, item)
        if (false == status) then
            GearHelper:Print('-----------------("if (true ~= status and true ~= res) then")-----------------')
            GearHelper:Print("status : " .. tostring(status))
            GearHelper:Print("status res : " .. tostring(res))
        end

        if status then
            local tmpTable = {}
            for _, result in pairs(res) do
                if result > 0 then
                    table.insert(tmpTable, result)
                end
            end

            if GearHelper:GetArraySize(tmpTable) == 0 then
                table.insert(weightTable, -10)
                table.insert(prixTable, item.sellPrice)
                table.insert(altTable, item.sellPrice, item.itemLink)
            else
                local highestResult = 0
                for _, v in ipairs(tmpTable) do
                    if v > highestResult then
                        highestResult = v
                    end
                end
                table.insert(weightTable, highestResult)
            end
        end
    end

    local maxWeight = weightTable[1]
    local keyWeight = 1
    local maxPrix = prixTable[1]
    local keyPrix = 1

    for i = 1, table.getn(weightTable) do
        if weightTable[i] > maxWeight then
            maxWeight = weightTable[i]
            keyWeight = i
        end
    end

    for i = 1, table.getn(prixTable) do
        if prixTable[i] > maxPrix then
            maxPrix = prixTable[i]
            keyPrix = i
        end
    end

    local prixTriee = prixTable
    table.sort(prixTriee)

    local xDif = 0
    if nil ~= maxWeight and maxWeight > 0 and not isBetter then
        local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyWeight]
        -- GearHelper.ButtonQuestReward = {}
        -- table.insert(GearHelper.ButtonQuestReward, button)
        if nil ~= button then
            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end

            if not button.overlay then
                button.overlay = button:CreateTexture(nil, "OVERLAY")
                button.overlay:SetSize(18, 18)
                button.overlay:SetPoint("TOPLEFT", -9 + xDif, 9)
                button.overlay:SetTexture("Interface\\AddOns\\GearHelper\\Textures\\flecheUp")
                button.overlay:SetShown(true)
                xDif = xDif + 11
            end

            isBetter = true
        end
    else
        local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyPrix]
        if nil ~= button then
            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end
            if not button.overlay then
                button.overlay = button:CreateTexture(nil, "OVERLAY")
                button.overlay:SetSize(18, 18)
                button.overlay:SetPoint("TOPLEFT", -9 + xDif, 9)
                button.overlay:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
                button.overlay:SetShown(true)
                xDif = xDif + 11
            end

            local objetI = GetQuestItemLink("choice", keyPrix)

            do
                return
            end
        end
    end
end

local function MerchantClosed()
    GearHelper:BenchmarkCountFuncCall("MerchantClosed")
    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    local actualMoney = GetMoney()
    local moneyEarned = actualMoney - moneyFlux

    if (moneyEarned > 0 and moneyEarned ~= actualMoney) then
        print(GearHelper:ColorizeString(L["moneyEarned"], "LightGreen") .. math.floor(moneyEarned / 10000) .. L["dot"] .. math.floor((moneyEarned % 10000) / 100) .. L["gold"])
        moneyFlux = 0
    end
end

local function BagUpdate()
    GearHelper:BenchmarkCountFuncCall("BagUpdate")
    if time() - lastBagUpdateEvent < 2 then
        do
            return
        end
    end
    lastBagUpdateEvent = time()
    if not GearHelperVars.charInventory["MainHand"] then
        do
            return
        end
    end
    if GearHelperVars.charInventory["MainHand"] == "" then
        do
            return
        end
    end
    -- Random check to verify that charInventory is initialized because BagUpdate is fired before PlayerEnteringWorld
    GearHelper:ScanCharacter()
    GearHelper:SetDotOnIcons()
end

local function ActiveTalentGroupChanged()
    GearHelper:BenchmarkCountFuncCall("ActiveTalentGroupChanged")
    if not GearHelper.db.profile.autoEquipWhenSwitchSpe then
        GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
        do
            return
        end
    end

    GearHelperVars.waitSpeTimer = time()
    -- GearHelperVars.waitSpeFrame:Show()
    waitSpeFrame:Show()
    GearHelper:EquipItem(0)
    GearHelper:EquipItem(1)
    GearHelper:EquipItem(2)
    GearHelper:EquipItem(3)
    GearHelper:EquipItem(4)

    GearHelper:ScanCharacter()
    GearHelper:SetDotOnIcons()
end

local function ChatMsgChannel(_, _, msg, sender, lang, channel)
    GearHelper:BenchmarkCountFuncCall("ChatMsgChannel")
    if not GearHelper.db.profile.autoInvite or not msg then
        GearHelper:showMessageSMN(channel, sender, msg)
        do
            return
        end
    end

    local playerIsNotMe = not string.find(sender, GetUnitName("player"))
    if msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe and GetNumGroupMembers() == 5 then
        ConvertToRaid()
        InviteUnit(sender)
    elseif msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe then
        InviteUnit(sender)
    end

    GearHelper:showMessageSMN(channel, sender, msg)
end

local function ChatMsgWhisper(_, _, msg, sender)
    GearHelper:BenchmarkCountFuncCall("ChatMsgWhisper")
    if GearHelper.db.profile.autoInvite and msg ~= nil then
        local playerIsNotMe = not string.find(sender, GetUnitName("player"))
        if msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe and GetNumGroupMembers() == 5 then
            ConvertToRaid()
            InviteUnit(sender)
        elseif msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe then
            InviteUnit(sender)
        end
    end
    if (GearHelper.db.profile.whisperAlert) then
        PlaySoundFile("Interface\\AddOns\\GearHelper\\Textures\\whisper.ogg", "Master")
    end
end

local function ChatMsgLoot(_, _, message, language, sender, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
    GearHelper:BenchmarkCountFuncCall("ChatMsgLoot")
    GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
end

local function ChatMsgEmote(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgEmote")
    GearHelper:showMessageSMN("Emote", sender, msg)
end

local function ChatMsgGuild(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgGuild")
    GearHelper:showMessageSMN("Guild", sender, msg)
end

local function ChatMsgOfficer(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgOfficer")
    GearHelper:showMessageSMN("Officer", sender, msg)
end

local function ChatMsgParty(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgParty")
    GearHelper:showMessageSMN("Party", sender, msg)
end

local function ChatMsgPartyLeader(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgPartyLeader")
    GearHelper:showMessageSMN("Party", sender, msg)
end

local function ChatMsgRaid(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgRaid")
    GearHelper:showMessageSMN("Raid", sender, msg)
end

local function ChatMsgRaidLeader(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgRaidLeader")
    GearHelper:showMessageSMN("Raid", sender, msg)
end

local function ChatMsgRaidWarning(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgRaidWarning")
    GearHelper:showMessageSMN("Raid_warning", sender, msg)
end

local function ChatMsgSay(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgSay")
    GearHelper:showMessageSMN("Say", sender, msg)
end

local function ChatMsgYell(_, _, msg, sender, _, _)
    GearHelper:BenchmarkCountFuncCall("ChatMsgYell")
    GearHelper:showMessageSMN("Yell", sender, msg)
end

local function UnitInventoryChanged(_, _, joueur)
    GearHelper:BenchmarkCountFuncCall("UnitInventoryChanged")
    if not GearHelper.db.profile.addonEnabled then
        do
            return
        end
    end
    if joueur ~= "player" then
        do
            return
        end
    end

    GearHelper:ScanCharacter()

    if not GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")) then
        do
            return
        end
    end

    local _, _, _, _, _, _, subclass = GetItemInfo(GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")))
    if subclass == L["cannapeche"] then
        GearHelper.db.profile.autoEquipLooted.previous = GearHelper.db.profile.autoEquipLooted.actual
        GearHelper.db.profile.autoEquipLooted.actual = false
    else
        GearHelper.db.profile.autoEquipLooted.actual = GearHelper.db.profile.autoEquipLooted.previous
    end
end

local function QuestTurnedIn()
    GearHelper:BenchmarkCountFuncCall("QuestTurnedIn")
    if not GearHelper.db.profile.autoEquipLooted.actual then
        do
            return
        end
    end

    GearHelperVars.waitSpeTimer = time()
    -- GearHelperVars.waitSpeFrame:Show()
    waitSpeFrame:Show()
end

local function GetItemInfoReceived(_, _, item)
    GearHelper:BenchmarkCountFuncCall("GetItemInfoReceived")
    if GearHelper.db.global.itemWaitList[item] then
        local slotName = GearHelper.db.global.itemWaitList[item]
        if (not string.find(slotName, "Slot")) then
            slotName = slotName + "Slot"
        end
        local slotID = GetInventorySlotInfo(slotName)
        GearHelper.db.global.itemWaitList[item] = nil
        GearHelperVars.charInventory[string.sub(slotName, 1, -5)] = GearHelper:GetEquippedItemLink(slotID, slotName)
    end
    if item ~= nil then
        if GearHelper.idNilGetQuestReward ~= nil then
            if item == GearHelper.idNilGetQuestReward then
                GearHelper:Print(tostring(item) .. " était nil")
                coroutine.resume(GearHelper.GetQuestRewardCoroutine)
            end
        end
    end

    if (InspectPaperDollItemsFrame) then
        NotifyInspect("target")
    end
end

local function ReadyCheck(_, _)
    GearHelper:BenchmarkCountFuncCall("ReadyCheck")
    local players = GetHomePartyInfo()
end

local function LfgUpdate(_, _)
    GearHelper:BenchmarkCountFuncCall("LfgUpdate")
    GearHelper:UpdateGHLfrButton()
end

local function PlayerLogin(_, _)
    GearHelper:BenchmarkCountFuncCall("PlayerLogin")

    if RaidFinderQueueFrame and RaidFinderQueueFrame_SetRaid then
        BossesKilledFunctions()
    end

    if (PaperDollItemsFrame) then
        GearHelper:AddIlvlOnCharFrame()
    end
end

local function InspectReady(_, _, target)
    GearHelper:BenchmarkCountFuncCall("InspectReady")

    if GearHelper.db.profile.inspectAin.waitingIlvl then ---------------- /GH AIN AVEC UN MESSAGE SPÉCIALE SI L'ILVL DE L'OBJET LOOT EST MOINS BON QUE CELUI ÉQUIPPÉ PAR CELUI QUI L'A LOOT
        local itemLoot = GearHelper.db.profile.inspectAin.linkItemReceived
        local itemLootTable = GearHelper:GetItemByLink(itemLoot)
        local itemLootEquipLoc = GearHelper.db.global.equipLocInspect[itemLootTable.equipLoc]

        if (itemLootEquipLoc ~= 11 and itemLootEquipLoc ~= 12 and itemLootEquipLoc ~= 13 and itemLootEquipLoc ~= 14) then
            local itemEquipped = GetInventoryItemLink(target, itemLootEquipLoc)
            if (not itemEquipped) then
                do
                    return
                end
            end
            local itemEquippedTable = GearHelper:GetItemByLink(itemEquipped)
            local itemEquippedIlvl = itemEquippedTable.iLvl
            local itemLootIlvl = itemLootTable.iLvl
        end

        GearHelper.db.profile.inspectAin.waitingIlvl = false
        GearHelper.db.profile.inspectAin.linkItemReceived = nil
        GearHelper.db.profile.inspectAin.message = nil
        GearHelper.db.profile.inspectAin.target = nil

        ClearInspectPlayer()
    elseif (InspectPaperDollItemsFrame) then
        GearHelper:AddIlvlOnInspectFrame()
    else
        if not GameTooltip:IsVisible() then
            do
                return
            end
        end

        local function computeIlvl()
            local arrayIlvl = {}
            for i = 1, 19 do
                local itemLink = GetInventoryItemLink("mouseover", i)
                if (itemLink) then
                    local itemScan = GearHelper:GetItemByLink(itemLink)
                    local itemLvl, equipLoc = itemScan.iLvl, itemScan.equipLoc
                    if equipLoc ~= nil then
                        arrayIlvl[equipLoc] = itemLvl
                        table.insert(arrayIlvl, itemLvl)
                    end
                end
            end
            local ilvlAverage = 0
            local itemCount = 0
            table.foreach(
                arrayIlvl,
                function(equipLoc, ilvl)
                    if (equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY") then
                        ilvlAverage = ilvlAverage + ilvl
                        itemCount = itemCount + 1
                    end
                end
            )
            if (itemCount ~= 0) then
                GameTooltip:AddLine(L["ilvlInspect"] .. tostring(math.floor((ilvlAverage / itemCount) + .5)))
            end

            ClearInspectPlayer()
            GameTooltip:Show()
        end

        coroutine.resume(coroutine.create(computeIlvl))
    end
end

local function UpdateMouseOverUnit()
    GearHelper:BenchmarkCountFuncCall("UpdateMouseOverUnit")
    if not CanInspect("mouseover") or not CheckInteractDistance("mouseover", 1) then
        do
            return
        end
    end

    NotifyInspect("mouseover")
end

local function ReadyCheck()
    GearHelper:BenchmarkCountFuncCall("ReadyCheck")
    if lfrCheckIsChecked then
        ConfirmReadyCheck(1)
        ReadyCheckFrame:Hide()
        print("Ready check accepted") -- TODO: Add localization
        UIErrorsFrame:AddMessage("Ready check accepted", 0.0, 1.0, 0.0, 80)
    end
end

GearHelper:RegisterEvent("ADDON_LOADED", AddonLoaded, ...)
GearHelper:RegisterEvent("MERCHANT_SHOW", OnMerchantShow)
GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerEnteringWorld)
GearHelper:RegisterEvent("CHAT_MSG_ADDON", ChatMsgAddon, ...)
GearHelper:RegisterEvent("ITEM_PUSH", ItemPush, ...)
GearHelper:RegisterEvent("QUEST_COMPLETE", QuestComplete)
GearHelper:RegisterEvent("QUEST_DETAIL", QuestDetail)
GearHelper:RegisterEvent("MERCHANT_CLOSED", MerchantClosed)
GearHelper:RegisterEvent("BAG_UPDATE", BagUpdate)
GearHelper:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", ActiveTalentGroupChanged)
GearHelper:RegisterEvent("CHAT_MSG_CHANNEL", ChatMsgChannel, ...)
GearHelper:RegisterEvent("CHAT_MSG_WHISPER", ChatMsgWhisper, ...)
GearHelper:RegisterEvent("CHAT_MSG_LOOT", ChatMsgLoot, ...)
GearHelper:RegisterEvent("CHAT_MSG_EMOTE", ChatMsgEmote, ...)
GearHelper:RegisterEvent("CHAT_MSG_GUILD", ChatMsgGuild, ...)
GearHelper:RegisterEvent("CHAT_MSG_OFFICER", ChatMsgOfficer, ...)
GearHelper:RegisterEvent("CHAT_MSG_PARTY", ChatMsgParty, ...)
GearHelper:RegisterEvent("CHAT_MSG_PARTY_LEADER", ChatMsgPartyLeader, ...)
GearHelper:RegisterEvent("CHAT_MSG_RAID", ChatMsgRaid, ...)
GearHelper:RegisterEvent("CHAT_MSG_RAID_LEADER", ChatMsgRaidLeader, ...)
GearHelper:RegisterEvent("CHAT_MSG_RAID_WARNING", ChatMsgRaidWarning, ...)
GearHelper:RegisterEvent("CHAT_MSG_SAY", ChatMsgSay, ...)
GearHelper:RegisterEvent("CHAT_MSG_YELL", ChatMsgYell, ...)
GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", UnitInventoryChanged, ...)
GearHelper:RegisterEvent("QUEST_TURNED_IN", QuestTurnedIn)
GearHelper:RegisterEvent("GET_ITEM_INFO_RECEIVED", GetItemInfoReceived, ...)
GearHelper:RegisterEvent("PLAYER_LOGIN", PlayerLogin, ...)
GearHelper:RegisterEvent("LFG_UPDATE", LfgUpdate, ...)
GearHelper:RegisterEvent("INSPECT_READY", InspectReady, ...)
GearHelper:RegisterEvent("UPDATE_MOUSEOVER_UNIT", UpdateMouseOverUnit, ...)
GearHelper:RegisterEvent("READY_CHECK", ReadyCheck, ...)
