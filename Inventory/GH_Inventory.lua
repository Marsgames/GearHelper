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
        equipSlots = GearHelper.itemSlot[equipLoc]
    end

    return equipSlots
end

function GearHelper:GetEquippedItems(equipLoc)
    self:Print("GetEquippedItems - Gettin' slots ID for "..equipLoc)

    local result = GearHelper:GetSlotsByEquipLoc(equipLoc)

    result.items = {}


    for i,slotId in ipairs(result.slots) do
        result.items[i] = GearHelperVars.charInventory[slotId]
    end

    return result
end