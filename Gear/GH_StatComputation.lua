function GearHelper:IsItemBetter(itemLink)
    self:BenchmarkCountFuncCall("GearHelper:IsItemBetter")
    local item = {}
    local itemEquipped = nil
    local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

    -- See in GearHelper.lua/ModifyTooltip()
    local shouldBeCompared, err = pcall(self.ShouldBeCompared, nil, itemLink)
    if (not shouldBeCompared) then
        return false
    end
    item = self:GetItemByLink(itemLink)

    local status, res = pcall(self.NewWeightCalculation, self, item)
    if not status then
        return false
    end

    for _, result in pairs(res) do
        if result > 0 then
            return true
        end
    end

    return false
end

function GearHelper:ShouldBeCompared(itemLink)
    GearHelper:BenchmarkCountFuncCall("GearHelper:ShouldBeCompared")

    if (not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r")) then
        error(GHExceptionInvalidItemLink)
    end

    local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

    if (IsEquippedItem(id)) then
        error(GHExceptionAlreadyEquipped)
    end

    if (not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink))) then
        error(GearHelper:GetItemByLink(itemLink).itemLink .. " - " .. GHExceptionNotEquippable)
    end

    return true
end

local function AutoEquipShouldBeCompared(itemLink)
    GearHelper:BenchmarkCountFuncCall("AutoEquipShouldBeCompared")

    if (not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r")) then
        return false
    end

    local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

    if (IsEquippedItem(id)) then
        --print(GHExceptionAlreadyEquipped)
        return false
    end

    if (not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink))) then
        --print(GearHelper:GetItemByLink(itemLink).itemLink .. " - " .. GHExceptionNotEquippable)
        return false
    end

    return true
end

local function ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
    GearHelper:BenchmarkCountFuncCall("ComputeWithTemplateDeltaBetweenItems")
    local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)

    return GearHelper:ApplyTemplateToDelta(delta)
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
                do return end
            end

            if "pvp" == typeInstance or "24" == tostring(difficultyIndex) or InCombatLockdown() then
                 self:Hide()
                return
            end

            for slot = 1, GetContainerNumSlots(bagToEquip) do
                local itemLink = GetContainerItemLink(bagToEquip, slot)
                if (tostring(itemLink) ~= "nil") then
                    -- local status, shouldBeCompared = pcall(self.ShouldBeCompared, itemLink)
                    local shouldBeCompared = AutoEquipShouldBeCompared(itemLink)

                    if (shouldBeCompared) then
                        local item = GearHelper:GetItemByLink(itemLink)
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
    GearHelper:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")

    local result = {}

    if (GearHelper:IsInventoryInCache() == false) then
        -- ?: why don't we cached the inventory here ?
        GearHelper:ScanCharacter() -- is this the function to cache the inventory ?
        error(GHExceptionInventoryNotCached)
    end

    local equippedItems = GearHelper:GetItemsByEquipLoc(item.equipLoc)

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
                equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
                result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink)
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then
        if tonumber(equippedItems["MainHand"]) and tonumber(equippedItems["SecondaryHand"]) then
            result["MainHand"] = GearHelper:ApplyTemplateToDelta(item)
        elseif tonumber(equippedItems["MainHand"]) then
            equippedItem = GearHelper:GetItemByLink(equippedItems["SecondaryHand"])
            result["SecondaryHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
        elseif tonumber(equippedItems["SecondaryHand"]) then
            equippedItem = GearHelper:GetItemByLink(equippedItems["MainHand"])
            result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
        else
            local combinedItems = GearHelper:CombineTwoItems(GearHelper:GetItemByLink(equippedItems["MainHand"]), GearHelper:GetItemByLink(equippedItems["SecondaryHand"]))
            result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, combinedItems)
        end
    else
        -- ?: Why is there a for loop ?
        for slot, equippedItemLink in pairs(equippedItems) do
            if equippedItemLink == 0 then -- 0 if no item is equipped
                result[slot] = GearHelper:ApplyTemplateToDelta(item)
            else
                equippedItem = GearHelper:GetItemByLink(equippedItemLink)
                result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
            end
        end
    end

    return result
end
