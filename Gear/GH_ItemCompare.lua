function GearHelper:IsItemBetter(itemLink)
    GearHelper:Print("IsItemBetter - "..itemLink)

    local item = GHItem:Create(itemLink)

    if not item or (not item:IsEquippableByMe() and not IsEquippedItem(item.id))then return false end

    local res = self:CompareWithEquipped(item).delta

    for _, result in pairs(res) do
        if result > 0 then
            return true
        end
    end

    return false
end

local function AutoEquipShouldBeCompared(itemLink)
    if (not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r")) then
        return false
    end

    local id = GetItemInfoInstant(itemLink)

    if (IsEquippedItem(id)) then
        return false
    end

    if (not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink, "GH_StatComputation.AutoEquipShouldBeCompared()"))) then
        return false
    end

    return true
end

function GearHelper:EquipItem(inThisBag)
    local bagToEquip = inThisBag or 0
    local _, typeInstance, difficultyIndex = GetInstanceInfo()
    waitEquipFrame = CreateFrame("Frame")
    waitEquipTimer = time()
    waitEquipFrame:Hide()
    waitEquipFrame:SetScript(
        "OnUpdate",
        function(self, elapsed)
            if time() <= waitEquipTimer + 0.5 then
                do
                    return
                end
            end

            if "pvp" == typeInstance or "24" == tostring(difficultyIndex) or InCombatLockdown() then
                self:Hide()
                return
            end

            for slot = 1, C_Container.GetContainerNumSlots(bagToEquip) do
                local itemLink = C_Container.GetContainerItemLink(bagToEquip, slot)
                if (tostring(itemLink) ~= "nil") then
                    local shouldBeCompared = AutoEquipShouldBeCompared(itemLink)

                    if (shouldBeCompared) then
                        local item = GearHelper:GetItemByLink(itemLink, "GH_StatComputation.EquipItem()")
                        local status, result = pcall(GearHelper.NewWeightCalculation, self, item)

                        if status then
                            for _, v in pairs(result) do
                                if v > 0 then
                                    EquipItemByName(item.itemLink)
                                end
                            end
                        end
                    end
                end
            end

            GearHelper:ScanCharacter()
            GearHelper:SetDotOnIcons()

            self:Hide()
        end
    )
    waitEquipFrame:Show()
end

function GearHelper:GetEquippedItemsScore(equippedItems)
    local equippedItemsScores = {}

    for slotId, equippedItem in pairs(equippedItems.items) do
        local equippedItemScore = equippedItem:GetScore()
        if equippedItems.operator == GearHelper.operators.UNDEFINED or equippedItems.operator == GearHelper.operators.OR then
            equippedItemsScores[slotId] = equippedItemScore
        elseif equippedItems.operator == GearHelper.operators.AND then
            equippedItemsScores[0] = (equippedItemsScores[0] or 0) + equippedItemScore
        end
    end

    return equippedItemsScores
end

local function GetItemWithBestScore(itemList)
    local bestItem = GHItem:CreateEmpty()
    for _, item in pairs(itemList) do
        if item:GetScore() > bestItem:GetScore() then
            bestItem = item
        end
    end

    return bestItem
end

function GearHelper:CompareWithEquipped(item)
    local result = {}
    local equippedItems = GearHelper:GetEquippedItems(item.equipLoc)
    local equippedItemsScore = GearHelper:GetEquippedItemsScore(equippedItems)

    if GearHelper:IsComparedItem1HTestedAgainst2HWeapon(item.equipLoc) then
        GearHelper:Print("Comparing a 1 Hand weapon against a 2 Hands, trying to find a pairable in bags...")
        local pairableItems = {}

        if INVTYPE_1H_OFFHAND[item.equipLoc] then --Compared item is a offhand trying to find a mainhand
            GearHelper:Print("Item is a offhand trying to find a mainhand...")
            pairableItems = GearHelper:FindItemInBags(INVTYPE_1H_MAINHAND)
        else --Compared item is a main hand trying to find an offhand
            GearHelper:Print("Item is a mainhand trying to find a offhand...")
            pairableItems = GearHelper:FindItemInBags(INVTYPE_1H_OFFHAND)
        end

        result.combinable = {
            item = GetItemWithBestScore(pairableItems)
        }
        GearHelper:Print("Best item to pair is "..result.combinable.item.itemLink)
        result.combinable.combinedScoreDelta = (item:GetScore() + result.combinable.item:GetScore()) - equippedItemsScore[0]
    end

    result.comparedItemScore = item:GetScore()
    result.delta = {}
    for slotId, score in pairs(equippedItemsScore) do
        result.delta[slotId] = result.comparedItemScore - score
    end

    self:Print("Result score is : ")
    self:Print(result)

    return result
end