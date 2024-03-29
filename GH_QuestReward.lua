local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

-- TODO: Overlay buttons needs to be rework, because they don't seems to work
-- TODO: Split that shit
function GearHelper:GetQuestReward()
    local numQuestChoices = GetNumQuestChoices()
    local isBetter = false

    if self.db.profile.autoAcceptQuestReward and numQuestChoices < 1 then
        GetQuestReward()
    elseif self.db.profile.autoAcceptQuestReward and numQuestChoices == 1 then
        GetQuestReward(1)
    else
        local weightTable = {}
        local prixTable = {}
        local altTable = {}

        for i = 1, numQuestChoices do
            local item = GHItem:Create(GetQuestItemLink("choice", i))

            if item.type ~= ARMOR and item.type ~= WEAPON then
                return
            end

            local status, res = pcall(self.NewWeightCalculation, self, item)
            if (false == status) then
                self:Print('-----------------("if (true ~= status and true ~= res) then")-----------------', 'quest')
                self:Print("status : " .. tostring(status), 'quest')
                self:Print("status res : " .. tostring(res), 'quest')
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

        if maxWeight > 0 and not isBetter then
            local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyWeight]
            -- table.insert(GearHelper.ButtonQuestReward, button)

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

            if GearHelper.db.profile.autoAcceptQuestReward then
                local objetI = GetQuestItemLink("choice", keyWeight)
                -- print("On prend " .. objetI)
                GetQuestReward(keyWeight)

                if button.overlay then
                    button.overlay:SetShown(false)
                    button.overlay = nil
                end
            end
            isBetter = true
        else
            local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyPrix]

            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end
            if not button.overlay then
                button.overlay = button:CreateTexture(nil, "OVERLAY")
                button.overlay:SetSize(18, 18)
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
