local lfrCheckIsChecked = false
local waitSpeFrame = CreateFrame("Frame")
local delaySpeTimer = 0.5
local moneyFlux = 0

waitSpeFrame:Hide()

--------------------------------- Functions ---------------------------------
-- This function handle the BossesKilled function. It's called in PlayerLogin event.
local function BossesKilledFunctions()
    local theFrame = nil
    -- When the LFR frame shows up
    local function LfrFrameShow(frame)
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
        GearHelper:HideLfrButtons(theFrame)
        GearHelper:UnregisterEvent("LFG_UPDATE")
    end

    RaidFinderQueueFrame:HookScript("OnShow", LfrFrameShow)
    RaidFinderQueueFrame:HookScript("OnHide", LfrFrameHide)
    hooksecurefunc("RaidFinderQueueFrame_SetRaid", GearHelper.UpdateSelectCursor)
end

-- local function delayBetweenEquip(frame)
--     if time() <= GearHelperVars.waitSpeTimer + delaySpeTimer then
--         return
--     end
--     for bag = 0, 4 do
--         numBag = bag
--         GearHelper:EquipItem()
--     end
--     frame:Hide()
-- end

-- -- GearHelperVars.waitSpeFrame:SetScript("OnUpdate", delayBetweenEquip)
-- waitSpeFrame:SetScript("OnUpdate", delayBetweenEquip)

-----------------------------------------------------------------------------
----------------------------------- Events ----------------------------------
local function OnMerchantShow()
    moneyFlux = GetMoney()

    GearHelper:SellGreyItems()
    GearHelper:RepairEquipment()
end

local function test(bagId)
    GearHelper:Print("BAG " .. bagId .. "OPENED")
end

-- TODO: Split this shit too
local function PlayerEnteringWorld()
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
        GearHelper:UpdateItemsInBags(0) -- Backpack is the only bag to not throw BAG_UPDATE on login

        GearHelper:ScanCharacter()

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
        lfrCheckButton_GlobalNameText:SetText(self.locals["lfrCheckButtonText"])
        lfrCheckButton.tooltip = self.locals["lfrCheckButtonTooltip"]
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

local function QuestComplete()
    GearHelper.GetQuestRewardCoroutine =
        coroutine.create(
        function()
            GearHelper:GetQuestReward()
        end
    )
    coroutine.resume(GearHelper.GetQuestRewardCoroutine)
end

local function QuestFinished()
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
        local questItemLink = GetQuestItemLink("choice", i)
        if (questItemLink == nil) then
            -- Check other possibilities if choice is nil ?
            -- print("choice : " .. tostring(GetQuestItemLink("choice", i)))
            -- print("reward : " .. tostring(GetQuestItemLink("reward", i)))
            -- print("required : " .. tostring(GetQuestItemLink("required", i)))
            do
                return
            end
        end

        local item = GHItem:Create(questItemLink)
        if item.type ~= ARMOR and item.type ~= WEAPON then --TODO : Why ? We don't compare trinket etc... ?
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

            if GHToolbox:GetArraySize(tmpTable) == 0 then
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

    if nil ~= maxWeight and maxWeight > 0 and not isBetter then
        local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyWeight]
        if nil ~= button then
            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end

            if not button.overlay then
                button.overlay = button:CreateTexture(nil, "OVERLAY")
                button.overlay:SetSize(18, 18)
                button.overlay:SetPoint("TOPLEFT")
                button.overlay:SetAtlas("bags-greenarrow", true)
                button.overlay:SetShown(true)
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
                button.overlay:SetSize(20, 22)
                button.overlay:SetPoint("TOPLEFT")
                button.overlay:SetAtlas("bags-junkcoin", true)
                button.overlay:SetShown(true)
            end

            local objetI = GetQuestItemLink("choice", keyPrix)

            do
                return
            end
        end
    end
end

local function MerchantClosed()
    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    local actualMoney = GetMoney()
    local moneyEarned = actualMoney - moneyFlux

    if (moneyEarned > 0 and moneyEarned ~= actualMoney) then
        print(GHToolbox:ColorizeString(GearHelper.locals["moneyEarned"], "LightGreen") .. math.floor(moneyEarned / 10000) .. GearHelper.locals["dot"] .. math.floor((moneyEarned % 10000) / 100) .. GearHelper.locals["gold"])
        moneyFlux = 0
    end
end

local function BagUpdate(_, _, bagId)
    -- if time() - (GearHelperVars.lastBagUpdateEvent[bagId] or 0) < 1 or AUTO_EQUIP_ONGOING then
    --     do
    --         return
    --     end
    -- end

    -- GearHelperVars.lastBagUpdateEvent[bagId] = time()
    GearHelper:HideUpgradeItemsIcon(bagId)
    GearHelper:UpdateItemsInBags(bagId)
    GearHelper:AutoEquip(bagId)
    -- GearHelper:ScanCharacter()
    -- GearHelper:ShowUpgradeOnItemsIcons()
end

local function ActiveTalentGroupChanged()
    if not GearHelper.db.profile.autoEquipWhenSwitchSpe then
        GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
        do
            return
        end
    end

    GearHelperVars.waitSpeTimer = time()
    waitSpeFrame:Show()

    for bag = Enum.BagIndex.Backpack, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        BagUpdate(nil, nil, bag)
    end

    GearHelper:ShowUpgradeOnItemsIcons()
end

local function ChatMsgChannel(_, _, msg, sender, lang, channel)
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
    GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
end

local function ChatMsgEmote(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Emote", sender, msg)
end

local function ChatMsgGuild(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Guild", sender, msg)
end

local function ChatMsgOfficer(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Officer", sender, msg)
end

local function ChatMsgParty(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Party", sender, msg)
end

local function ChatMsgPartyLeader(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Party", sender, msg)
end

local function ChatMsgRaid(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Raid", sender, msg)
end

local function ChatMsgRaidLeader(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Raid", sender, msg)
end

local function ChatMsgRaidWarning(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Raid_warning", sender, msg)
end

local function ChatMsgSay(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Say", sender, msg)
end

local function ChatMsgYell(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Yell", sender, msg)
end

local function UnitInventoryChanged(_, _, target)
    if not GearHelper.db.profile.addonEnabled or target ~= "player" then
        do
            return
        end
    end

    GearHelper:Print("EVENT UNIT_INVENTORY_CHANGED")
    GearHelper:ScanCharacter()
end

local function QuestTurnedIn()
    if not GearHelper.db.profile.autoEquipLooted.actual then
        do
            return
        end
    end

    GearHelperVars.waitSpeTimer = time()
    -- GearHelperVars.waitSpeFrame:Show()
    waitSpeFrame:Show()
end

local function LfgUpdate(_, _)
    GearHelper:UpdateGHLfrButton()
end

local function PlayerLogin(_, _)
    if RaidFinderQueueFrame and RaidFinderQueueFrame_SetRaid then
        BossesKilledFunctions()
    end

    if (PaperDollItemsFrame) then
        GearHelper:AddIlvlOnCharFrame()
    end
end

local function ReadyCheck()
    if lfrCheckIsChecked then
        ConfirmReadyCheck(1)
        ReadyCheckFrame:Hide()
        print("Ready check accepted") -- TODO: Add localization
        UIErrorsFrame:AddMessage("Ready check accepted", 0.0, 1.0, 0.0)
    end
end

-- local function UnitInventoryChanged()
--     GHToolbox:DelayCallback(GearHelper.ResetIlvlOnCharFrame, 0.1)
-- end

local function BagUpdateDelayed()
    -- Update char frame when the bag is update because original UNIT_INVENTORY_CHANGED event is not fired when the player change trinkets or fingers
    GearHelper:ResetIlvlOnCharFrame()

    GearHelper:ScanCharacter()
    GearHelper:ShowUpgradeOnItemsIcons()
end

GearHelper:RegisterEvent("MERCHANT_SHOW", OnMerchantShow)
GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerEnteringWorld)
GearHelper:RegisterEvent("CHAT_MSG_ADDON", ChatMsgAddon, ...)
GearHelper:RegisterEvent("QUEST_COMPLETE", QuestComplete)
GearHelper:RegisterEvent("QUEST_DETAIL", QuestDetail)
GearHelper:RegisterEvent("MERCHANT_CLOSED", MerchantClosed)
GearHelper:RegisterEvent("BAG_UPDATE", BagUpdate, ...)
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
GearHelper:RegisterEvent("PLAYER_LOGIN", PlayerLogin, ...)
GearHelper:RegisterEvent("LFG_UPDATE", LfgUpdate, ...)
GearHelper:RegisterEvent("READY_CHECK", ReadyCheck, ...)
GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", UnitInventoryChanged, ...)
GearHelper:RegisterEvent("BAG_UPDATE_DELAYED", BagUpdateDelayed, ...)
