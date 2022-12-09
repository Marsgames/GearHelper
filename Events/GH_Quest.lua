-- TODO: Split that shit
function GHEvents:QUEST_DETAIL()
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
        if item.type ~= ARMOR and item.type ~= WEAPON then -- TODO : Why ? We don't compare trinket etc... ?
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

function GHEvents:QUEST_TURNED_IN()
    if not GearHelper.db.profile.autoEquipLooted.actual then
        do
            return
        end
    end

    GearHelperVars.waitSpeTimer = time()
    -- GearHelperVars.waitSpeFrame:Show()
    waitSpeFrame:Show()
end

function GHEvents:QUEST_FINISHED()
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

function GHEvents:QUEST_COMPLETE()
    GearHelper.GetQuestRewardCoroutine =
        coroutine.create(
        function()
            GearHelper:GetQuestReward()
        end
    )
    coroutine.resume(GearHelper.GetQuestRewardCoroutine)
end
