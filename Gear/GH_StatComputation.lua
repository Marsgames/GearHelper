function GearHelper:IsItemBetter(itemLink)
    self:BenchmarkCountFuncCall("GearHelper:IsItemBetter")
    GearHelper:Print("IsItemBetter - "..itemLink)

    local item = self:GetItem(itemLink)

    if not item or not item.isEquippable then return false end

    local res = self:NewWeightCalculation(item)
    for _, result in pairs(res) do
        if result > 0 then
            return true
        end
    end

    return false
end

local function AutoEquipShouldBeCompared(itemLink)
    GearHelper:BenchmarkCountFuncCall("AutoEquipShouldBeCompared")

    if (not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r")) then
        return false
    end

    local id = GetItemInfoInstant(itemLink)

    if (IsEquippedItem(id)) then
        return false
    end

    if (not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink, "GH_StatComputation.AutoEquipShouldBeCompared()"))) then
        --print(GearHelper:GetItemByLink(itemLink).itemLink .. " - " .. GHExceptionNotEquippable)
        return false
    end

    return true
end

local function ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
    GearHelper:BenchmarkCountFuncCall("ComputeWithTemplateDeltaBetweenItems")
    local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)

    return GearHelper:GetItemStatsScore(delta)
end

function GearHelper:EquipItem(inThisBag)
    self:BenchmarkCountFuncCall("GearHelper:EquipItem")
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

function GearHelper:NewWeightCalculation(item)
    self:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")

    local result = {}
    
    local equippedItems = GearHelper:GetEquippedItems(item.equipLoc)
    
    for slotId, equippedItem in pairs(equippedItems.items) do
        self:Print("NewWeightCalculation - Localized slot name is ".._G[GearHelper.slotToNameMapping[slotId]]:lower())
        local bbb = GearHelper:GetItemStatsScore(item)
        if equippedItems.operator == GearHelper.operators.UNDEFINED or equippedItems.operator == GearHelper.operators.OR then
        elseif equippedItems.operator == GearHelper.operators.AND then
        end

        self:Print(equippedItem)
    end


    --[[
    if item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_FINGER" then
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then
                result[slot] = GearHelper:ApplyTemplateToDelta(item)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink)
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    elseif item.equipLoc == "INVTYPE_WEAPON" or item.equipLoc == "INVTYPE_HOLDABLE" then
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then
                result[slot] = GearHelper:ApplyTemplateToDelta(item)
            elseif equippedItemLink == -1 then
                equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"], "GH_StatComputation.NewWeightCalculation() Mainhand")
                result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink, "GH_StatComputation.NewWeightCalculation() Holdable")
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then
        if tonumber(equippedItems["MainHand"]) and tonumber(equippedItems["SecondaryHand"]) then
            result["MainHand"] = GearHelper:ApplyTemplateToDelta(item)
        elseif tonumber(equippedItems["MainHand"]) then
            equippedItem = GearHelper:GetItemByLink(equippedItems["SecondaryHand"], "GH_StatComputation.NewWeightCalculation() SecondaryHand")
            result["SecondaryHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
        elseif tonumber(equippedItems["SecondaryHand"]) then
            equippedItem = GearHelper:GetItemByLink(equippedItems["MainHand"], "GH_StatComputation.NewWeightCalculation() MainHand 2Weapon")
            result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
        else
            local combinedItems = GearHelper:CombineTwoItems(GearHelper:GetItemByLink(equippedItems["MainHand"], "GH_StatComputation.NewWeightCalculation() 1"), GearHelper:GetItemByLink(equippedItems["SecondaryHand"], "GH_StatComputation.NewWeightCalculation() 2"))
            result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, combinedItems)
        end
    else
        -- ?: Why is there a for loop ?
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then -- 0 if no item is equipped
                result[slot] = GearHelper:ApplyTemplateToDelta(item)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink, "GH_StatComputation.NewWeightCalculation() other ?")
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    end]]

    return result
end

function GearHelper:TestCalc(item)
    self:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")

    local result = {}

    local equippedItems = GearHelper:GetEquippedItems(item.equipLoc)

    if item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_FINGER" then
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then
                result[slot] = GearHelper:GetItemStatsScore(item)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink, "GH_StatComputation.NewWeightCalculation() Trinket / Finger")
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    elseif item.equipLoc == "INVTYPE_WEAPON" or item.equipLoc == "INVTYPE_HOLDABLE" then
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then
                result[slot] = GearHelper:GetItemStatsScore(item)
            elseif equippedItemLink == -1 then
                equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"], "GH_StatComputation.NewWeightCalculation() Mainhand")
                result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink, "GH_StatComputation.NewWeightCalculation() Holdable")
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then
        if tonumber(equippedItems["MainHand"]) and tonumber(equippedItems["SecondaryHand"]) then
            result["MainHand"] = GearHelper:GetItemStatsScore(item)
        elseif tonumber(equippedItems["MainHand"]) then
            equippedItem = GearHelper:GetItemByLink(equippedItems["SecondaryHand"], "GH_StatComputation.NewWeightCalculation() SecondaryHand")
            result["SecondaryHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
        elseif tonumber(equippedItems["SecondaryHand"]) then
            equippedItem = GearHelper:GetItemByLink(equippedItems["MainHand"], "GH_StatComputation.NewWeightCalculation() MainHand 2Weapon")
            result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
        else
            local combinedItems = GearHelper:CombineTwoItems(GearHelper:GetItemByLink(equippedItems["MainHand"], "GH_StatComputation.NewWeightCalculation() 1"), GearHelper:GetItemByLink(equippedItems["SecondaryHand"], "GH_StatComputation.NewWeightCalculation() 2"))
            result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, combinedItems)
        end
    else
        -- ?: Why is there a for loop ?
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then -- 0 if no item is equipped
                result[slot] = GearHelper:GetItemStatsScore(item)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink, "GH_StatComputation.NewWeightCalculation() other ?")
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    end

    return result
end
