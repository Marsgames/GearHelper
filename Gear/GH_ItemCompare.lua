function GearHelper:IsItemBetter(item)
    GearHelper:Print("IsItemBetter - " .. item.itemLink, "itemCompare")

    if item.isEmpty or not item:IsEquippableByMe() or IsEquippedItem(item.id) then
        return false
    end

    local result = self:CompareWithEquipped(item)
    local isBetter = false

    if result.combinable and result.combinable.combinedScoreDelta > 0 then
        isBetter = true
    else
        for _, deltaScore in pairs(result.delta) do
            if deltaScore > 0 then
                isBetter = true
            end
        end
    end

    return isBetter
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
    GearHelper:Print("CompareWithEquipped - " .. item.itemLink, "itemCompare")
    local result = {}
    local equippedItems = GearHelper:GetEquippedItems(item.equipLoc)
    local equippedItemsScore = GearHelper:GetEquippedItemsScore(equippedItems)
    
    if GearHelper:IsComparedItem1HTestedAgainst2HWeapon(item.equipLoc) then
        GearHelper:Print("Comparing a 1 Hand weapon against a 2 Hands, trying to find a pairable in bags...", "itemCompare")
        local pairableItems = {}

        if INVTYPE_1H_OFFHAND[item.equipLoc] then -- Compared item is a offhand trying to find a mainhand
            GearHelper:Print("Item is a offhand trying to find a mainhand...", "itemCompare")
            pairableItems = GearHelper:FindItemInBags(INVTYPE_1H_MAINHAND)
        else -- Compared item is a main hand trying to find an offhand
            GearHelper:Print("Item is a mainhand trying to find a offhand...", "itemCompare")
            pairableItems = GearHelper:FindItemInBags(INVTYPE_1H_OFFHAND)
        end

        result.combinable = {
            item = GetItemWithBestScore(pairableItems)
        }
        GearHelper:Print("Best item to pair is " .. result.combinable.item.itemLink, "itemCompare")

        local itemScore = item:GetScore()
        local pairableItemScore = result.combinable.item:GetScore()
        
        -- TODO: Not sure at all about this
        local score = 0
        if (equippedItemsScore[0] == nil) then
            for k, v in pairs(equippedItemsScore) do
                score = score + v
            end
        else
            score = equippedItemsScore[0]
        end
        GearHelper:Print("Result : " .. ((itemScore + pairableItemScore) - score), "itemCompare")
        
        result.combinable.combinedScoreDelta = (itemScore + pairableItemScore) - score
    end

    result.comparedItemScore = item:GetScore()
    result.delta = {}
    for slotId, score in pairs(equippedItemsScore) do
        result.delta[slotId] = result.comparedItemScore - score
    end

    GearHelper:Print("Result score is : ", "itemCompare")
    GearHelper:Print(result, "itemCompare")

    return result
end
