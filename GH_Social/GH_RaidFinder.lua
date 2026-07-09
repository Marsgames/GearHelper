function GH_Social:CreateLfrButtons(frameParent)
    local nbInstance = GetNumRFDungeons()
    local scale = min(480 / ((nbInstance - 6) * 24), 1)

    if not frameParent.GHLfrButtons then
        frameParent.GHLfrButtons = {}
    end

    local buttons = frameParent.GHLfrButtons

    for i = 1, nbInstance do
        local id, name = GetRFDungeonInfo(i)
        local _, availableForPlayer = IsLFGDungeonJoinable(id)

        if not buttons[id] and availableForPlayer then
            local button = CreateFrame("CheckButton", frameParent:GetName() .. "GHLfrButtons" .. tostring(id), frameParent, "SpellBookSkillLineTabTemplate")

            if frameParent.lastButton then
                button:SetPoint("TOPLEFT", frameParent.lastButton, "BOTTOMLEFT", 0, -15)
            else
                button:SetPoint("TOPLEFT", frameParent, "TOPRIGHT", 3, -50)
            end

            button:SetScale(scale)
            button:SetWidth(32 + 16)

            -- TODO: Find a cleaner way to resize the tab texture
            for _, region in ipairs({button:GetRegions()}) do
                if type(region) ~= "userdata" and region.GetTexture and region:GetTexture() == "Interface\\SpellBook\\SpellBook-SkillLineTab" then
                    region:SetWidth(64 + 24)
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

            button:SetScript("OnEnter", function(this)
                if this.tooltip then
                    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
                    for _, tip in ipairs(button.tooltip) do
                        GameTooltip:AddLine(tip.text or tip)
                    end
                    GameTooltip:Show()
                end
            end)

            button:SetScript("OnClick", function(this)
                RaidFinderQueueFrame_SetRaid(this.dungeonID)
                this:SetChecked(this.checked)
            end)

            button.checked = false
        end

        if buttons[id] then
            _G[frameParent:GetName() .. "GHLfrButtons" .. tostring(id)]:Show()
        end
    end
end

function GH_Social:UpdateButtonsAndTooltips(frameParent)
    local buttons = frameParent.GHLfrButtons

    for id, button in pairs(buttons) do
        local bossKilled = 0
        local bossCount = GetLFGDungeonNumEncounters(id)
        local tooltip = {{text = button.dungeonName}}

        for i = 0, bossCount do
            local bossName, _, isDead = GetLFGDungeonEncounterInfo(id, i)
            if bossName then
                local text
                if isDead then
                    text = GHToolbox:ColorizeString(bossName, "Red") .. GHToolbox:ColorizeString(" (mort)", "LightRed")
                    bossKilled = bossKilled + 1
                else
                    text = GHToolbox:ColorizeString(bossName, "Green") .. GHToolbox:ColorizeString(" (vivant)", "LightGreen")
                end
                table.insert(tooltip, text)
            end
        end

        button.tooltip = tooltip

        local result = bossKilled .. "/" .. bossCount
        if bossKilled == bossCount then
            result = GHToolbox:ColorizeString(result, "LightRed")
        elseif bossKilled == 0 then
            result = GHToolbox:ColorizeString(result, "LightGreen")
        else
            result = GHToolbox:ColorizeString(result, "Yellow")
        end

        if button.number.SetFormattedText then
            button.number:SetFormattedText(result)
        end
        button.number = result
    end
end

function GH_Social:UpdateSelectCursor()
    if not GH_Social.cursor then
        local cursor = GroupFinderFrame:CreateTexture("GHLfrCursor", "ARTWORK")
        cursor:SetTexture("Interface\\Minimap\\MinimapArrow")
        cursor:SetRotation(1.65)
        cursor:SetSize(80, 80)
        cursor:Hide()
        GH_Social.cursor = cursor
    end

    local parentFrame = (RaidFinderQueueFrame ~= nil and RaidFinderQueueFrame:IsVisible()) and RaidFinderQueueFrame or nil
    if not parentFrame then
        GH_Social.cursor:Hide()
        return
    end

    if parentFrame.raid and parentFrame.GHLfrButtons[parentFrame.raid] then
        local button = parentFrame.GHLfrButtons[parentFrame.raid]
        GH_Social.cursor:SetParent(button)
        GH_Social.cursor:SetPoint("LEFT", button, "RIGHT")
        GH_Social.cursor:Show()
    end
end

function GH_Social:UpdateGHLfrButton()
    if not RaidFinderQueueFrame.GHLfrButtons then
        return
    end

    for id, button in pairs(RaidFinderQueueFrame.GHLfrButtons) do
        local mode = GetLFGMode(LE_LFG_CATEGORY_RF, id)
        local queued = mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended"
        button:SetChecked(queued)
        button.checked = queued
    end
end

function GH_Social:HideLfrButtons(frameParent)
    local nbInstance = GetNumRFDungeons()
    for i = 1, nbInstance do
        local id = GetRFDungeonInfo(i)
        local btn = _G["RaidFinderQueueFrameGHLfrButtons" .. id]
        if btn then
            btn:Hide()
        end
    end

    if frameParent and frameParent.GHLfrButtons then
        for id in pairs(frameParent.GHLfrButtons) do
            frameParent.GHLfrButtons[id] = nil
        end
    end
end
