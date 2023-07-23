local waitSpeFrame = CreateFrame("Frame")

waitSpeFrame:Hide()

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

-- TODO: Split this shit too
function GHEvents:PLAYER_ENTERING_WORLD()
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
    GearHelper:SendAskVersion()
    -- This UpdateItemsInBags is causing an issue
    GearHelper:UpdateItemsInBags(0) -- Backpack is the only bag to not throw BAG_UPDATE on login

    GearHelper:ScanCharacter()

    if (not string.match(GearHelper.db.global.myNames, GetUnitName("player") .. ",")) then
        GearHelper.db.global.myNames = GearHelper.db.global.myNames .. GetUnitName("player") .. ","
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
        lfrCheckButton_GlobalNameText:SetText(GearHelper.locals["lfrCheckButtonText"])
        lfrCheckButton.tooltip = GearHelper.locals["lfrCheckButtonTooltip"]
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

    if (PaperDollItemsFrame) then
        GearHelper:AddIlvlOnCharFrame()
    end
end

function GHEvents:ACTIVE_TALENT_GROUP_CHANGED()
    if not GearHelper.db.profile.autoEquipWhenSwitchSpe then
        GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
        do
            return
        end
    end

    GearHelperVars.waitSpeTimer = time()
    waitSpeFrame:Show()

    for bag = Enum.BagIndex.Backpack, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        GHEvents:BagUpdate(nil, nil, bag)
    end

    GearHelper:ShowUpgradeOnItemsIcons()
end

function GHEvents:UNIT_INVENTORY_CHANGED(target)
    if target ~= "player" then
        do
            return
        end
    end

    GearHelper:Print("EVENT UNIT_INVENTORY_CHANGED")
    GearHelper:ScanCharacter()
end

function GHEvents:PLAYER_LOGIN()
    if RaidFinderQueueFrame and RaidFinderQueueFrame_SetRaid then
        BossesKilledFunctions()
    end
end
