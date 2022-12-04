local function IsPlayerEquippedWith2HandsWeapon()
    if not GearHelperVars.charInventory[INVSLOT_MAINHAND].isEmpty and (GearHelper.itemSlot[GearHelperVars.charInventory[INVSLOT_MAINHAND].equipLoc].operator == GearHelper.operators.AND) then
        GearHelper:Print("Player have a 2 hands weapon equipped")
        return true
    end

    GearHelper:Print("Player don't have a 2 hands weapon equipped")
    return false
end

function GearHelper:GetSlotsByEquipLoc(equipLoc)
    local equipSlots = {}
    local canDualWield = IsPlayerSpell(674) --Dual Wield spellId

    GearHelper:Print("GetSlotsByEquipLoc - Player can dual wield ? "..tostring(canDualWield))

    if canDualWield and (
        (equipLoc == "INVTYPE_2HWEAPON" and IsPlayerSpell(46917))  --Titan's Grip War Fury spellId
        or equipLoc == "INVTYPE_WEAPON") 
    then
        GearHelper:Print("GetSlotsByEquipLoc - Player can dual wield and it's a "..equipLoc)
        equipSlots = {
            slots = { INVSLOT_MAINHAND, INVSLOT_OFFHAND },
            operator = GearHelper.operators.OR
        }
    else
        if GearHelper:IsComparedItem1HTestedAgainst2HWeapon(equipLoc) then
            GearHelper:Print("Comparing 1H against 2H, returning main hand slot")
            equipSlots = GearHelper.itemSlot["INVTYPE_2HWEAPON"]
        else
            equipSlots = GearHelper.itemSlot[equipLoc]
        end
    end

    return equipSlots
end

function GearHelper:IsComparedItem1HTestedAgainst2HWeapon(comparedItemEquipLoc)
    if (INVTYPE_1H_MAINHAND[comparedItemEquipLoc] or INVTYPE_1H_OFFHAND[comparedItemEquipLoc]) and IsPlayerEquippedWith2HandsWeapon() then
        return true
    end

    return false
end

function GearHelper:GetEquippedItems(equipLoc)
    self:Print("GetEquippedItems - Gettin' slots ID for "..equipLoc)

    local result = GearHelper:GetSlotsByEquipLoc(equipLoc)

    result.items = {}

    for i,slotId in ipairs(result.slots) do
        result.items[slotId] = GearHelperVars.charInventory[slotId]
    end

    return result
end

function GearHelper:UpdateItemsInBags(bagId)
    for j = 1, C_Container.GetContainerNumSlots(bagId) do
        local itemlink = C_Container.GetContainerItemLink(bagId, j);

        if GearHelperVars.bagsItems[bagId] == nil then
            GearHelperVars.bagsItems[bagId] = {}
        end


        local item = GHItem:Create(itemlink)

        if not item.isEmpty then
            GearHelperVars.bagsItems[bagId][itemlink] = {
                item = item,
                slot = j
            } 
        end
    end
end

function GearHelper:FindItemInBags(equipLocs)
    local matchedItems = {}
    for _, items in pairs(GearHelperVars.bagsItems) do
        for _, item in pairs(items) do
            if equipLocs[item.item.equipLoc] then
                table.insert(matchedItems, item.item)
            end
        end
    end

    return matchedItems
end