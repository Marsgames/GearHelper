local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:CreateLfrButtons(frameParent)
    self:BenchmarkCountFuncCall("GearHelper:CreateLfrButtons")
    local nbInstance = GetNumRFDungeons()
    local scale = min(480 / ((nbInstance - 6) * 24), 1) --> Adjust size of buttons depending on number of buttons

    if not frameParent.GHLfrButtons then
        frameParent.GHLfrButtons = {}
    end

    local buttons = frameParent.GHLfrButtons

    for i = 1, nbInstance do
        local id, name = GetRFDungeonInfo(i)
        local available, availableForPlayer = IsLFGDungeonJoinable(id)

        if (not buttons[id] and availableForPlayer) then
            local button = CreateFrame("CheckButton", frameParent:GetName() .. "GHLfrButtons" .. tostring(id), frameParent, "SpellBookSkillLineTabTemplate")

            if frameParent.lastButton then
                button:SetPoint("TOPLEFT", frameParent.lastButton, "BOTTOMLEFT", 0, -15)
            else
                button:SetPoint("TOPLEFT", frameParent, "TOPRIGHT", 3, -50)
            end

            button:SetScale(scale)
            button:SetWidth(32 + 16) -- Originally 32

            -- Need to find the button's texture in the regions so we can resize it. I don't like this part, but I can't think of a better way in case it's not the first region returned. (Is it ever not?)
            -- TODO: You don't like this part, do something
            for _, region in ipairs({button:GetRegions()}) do
                if type(region) ~= "userdata" and region.GetTexture and region:GetTexture() == "Interface\\SpellBook\\SpellBook-SkillLineTab" then
                    region:SetWidth(64 + 24) -- Originally 64
                    break
                end
            end

            buttons[id] = button

            button.dungeonID = id
            button.dungeonName = name

            frameParent.lastButton = button

            local number = button:CreateFontString(button:GetName() .. "Number", "OVERLAY", "SystemFont_Shadow_Huge3")
            number:SetPoint("TOPLEFT", -4, 4)
            number:SetPoint("BOTTOMRIGHT", 5, -5)
            button.number = number

            button:SetScript(
                "OnEnter",
                function(this)
                    if this.tooltip then
                        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
                        for i = 1, #button.tooltip do
                            tooltip = button.tooltip[i]
                            GameTooltip:AddLine(tooltip.text)
                            GameTooltip:AddLine(tooltip)
                        end
                        GameTooltip:Show()
                    end
                end
            )

            button:SetScript(
                "OnClick",
                function(this)
                    RaidFinderQueueFrame_SetRaid(this.dungeonID)

                    -- This is to override the automatic highlighting when you click the button, while we want to use that to show queue status instead.
                    -- I've no idea why simply overriding this OnClick and not doing a SetChecked doesn't disable the behavior.
                    -- I probably shouldn't be using a CheckButton at all, but the SpellBookSkillLineTabTemplate looks pretty nice for the job.
                    this:SetChecked(this.checked)
                end
            )
            button.checked = false
        end

        if (buttons[id]) then
            local button = _G[frameParent:GetName() .. "GHLfrButtons" .. tostring(id)]
            button:Show()
        end
    end
end

function GearHelper:UpdateButtonsAndTooltips(frameParent)
    self:BenchmarkCountFuncCall("GearHelper:UpdateButtonsAndTooltips")

    local buttons = frameParent.GHLfrButtons

    for id, button in pairs(buttons) do
        local bossKilled = 0
        local index = 0
        local bossCount = GetLFGDungeonNumEncounters(id)

        local tooltip = {{text = button.dungeonName}}
        for i = index, bossCount do
            local textBoss = ""
            local bossName, _, isDead = GetLFGDungeonEncounterInfo(id, i)

            if (isDead and bossName) then
                textBoss = self:ColorizeString(bossName, "Red") .. self:ColorizeString(" " .. L["isDead"], "LightRed")
                bossKilled = bossKilled + 1
            elseif (not isDead and bossName) then
                textBoss = self:ColorizeString(bossName, "Green") .. self:ColorizeString(" " .. L["isAlive"], "LightGreen")
            end
            table.insert(tooltip, textBoss)
        end

        button.tooltip = nil
        button.tooltip = tooltip
        local result = bossKilled .. "/" .. bossCount
        if (bossKilled == bossCount) then
            result = self:ColorizeString(result, "LightRed")
        elseif (bossKilled == 0) then
            result = self:ColorizeString(result, "LightGreen")
        else
            result = self:ColorizeString(result, "Yellow")
        end

        if (button.number.SetFormattedText) then
            button.number:SetFormattedText(result)
        end

        button.number = result
    end
end

function GearHelper:UpdateSelectCursor()
    GearHelper:BenchmarkCountFuncCall("GearHelper:UpdateSelectCursor")

    if not GearHelper.cursor then
        local cursor = GroupFinderFrame:CreateTexture("GHLfrCursor", "ARTWORK")
        cursor:SetTexture("Interface\\Minimap\\MinimapArrow")
        cursor:SetRotation(1.65)
        cursor:SetSize(80, 80)
        cursor:Hide()
        GearHelper.cursor = cursor
    end

    local parentFrame = (RaidFinderQueueFrame ~= nil and RaidFinderQueueFrame:IsVisible() and RaidFinderQueueFrame or nil)
    if (not parentFrame) then
        GearHelper.cursor:Hide()
        return
    end

    if parentFrame.raid and parentFrame.GHLfrButtons[parentFrame.raid] then
        local button = parentFrame.GHLfrButtons[parentFrame.raid]
        GearHelper.cursor:SetParent(button)
        GearHelper.cursor:SetPoint("LEFT", button, "RIGHT")
        GearHelper.cursor:Show()
    end
end

function GearHelper:UpdateGHLfrButton()
    self:BenchmarkCountFuncCall("GearHelper:UpdateGHLfrButton")
    if not RaidFinderQueueFrame.GHLfrButtons then
        return
    end

    for id, button in pairs(RaidFinderQueueFrame.GHLfrButtons) do
        local mode = GetLFGMode(LE_LFG_CATEGORY_RF, id)
        if mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended" then
            button:SetChecked(true)
            button.checked = true
        else
            button:SetChecked(false)
            button.checked = false
        end
    end
end

function GearHelper:HideLfrButtons(frameParent)
    self:BenchmarkCountFuncCall("GearHelper:HideLfrButtons")
    local nbInstance = GetNumRFDungeons()

    for i = 1, nbInstance do
        local id, name = GetRFDungeonInfo(i)
        if _G["RaidFinderQueueFrameGHLfrButtons" .. id] then
            _G["RaidFinderQueueFrameGHLfrButtons" .. id]:Hide()
        end
    end

    local buttons = frameParent.GHLfrButtons
    for id, button in pairs(buttons) do
        button = nil
    end
end
