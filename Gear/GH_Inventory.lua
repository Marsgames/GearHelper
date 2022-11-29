local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:GetSlotsByEquipLoc(equipLoc)
    GearHelper:BenchmarkCountFuncCall("GetSlotsByEquipLoc")
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
    self:BenchmarkCountFuncCall("GearHelper:GetEquippedItems")
    self:Print("GetEquippedItems - Gettin' slots ID for "..equipLoc)

    local result = GearHelper:GetSlotsByEquipLoc(equipLoc)

    result.items = {}


    for i,slotId in ipairs(result.slots) do
        result.items[i] = GearHelperVars.charInventory[slotId]
    end

    return result
end

function GearHelper:RepairEquipment()
    GearHelper:BenchmarkCountFuncCall("GearHelper:RepairEquipment")

    local ghRepair = GearHelper.db.profile.autoRepair
    local canUseAutoRepair = 1 == ghRepair or 2 == ghRepair

    if not CanMerchantRepair() or not canUseAutoRepair then
        do
            return
        end
    end

    local ownedGolds = GetMoney()
    local price = GetRepairAllCost()
    local canRepairWithGuild = nil
    local guildGolds = ""
    local guildIsAbleToRepair = false

    if price <= 0 then
        do
            return
        end
    end

    if IsInGuild() and CanGuildBankRepair() then
        canRepairWithGuild = GetGuildBankWithdrawMoney()
        guildGolds = GetGuildBankMoney()
    end

    if 1 == ghRepair then
        if ownedGolds < price then
            print(L["CantRepair"])
            do
                return
            end
        end
    else -- if 2 == ghRepair then
        if
            (nil == canRepairWithGuild) or -- Player cannot use guild to repair
                (tonumber(canRepairWithGuild) < price) or -- Player canot use enough guild money to repair
                (guildGolds < price)
         then -- Guild has not enough money to repair
            if ownedGolds < price then -- Player cannot repair by himself
                print(L["CantRepair"])
                do
                    return
                end
            end
        else
            guildIsAbleToRepair = true
        end
    end

    if 1 == ghRepair then
        RepairAllItems(false)
        print(GearHelper:ColorizeString(L["repairCost"], "Pink") .. math.floor(price / 10000) .. L["dot"] .. math.floor((price % 10000) / 100) .. L["gold"])
    elseif guildIsAbleToRepair then
        RepairAllItems(true)
        print(GearHelper:ColorizeString(L["guildRepairCost"], "Pink") .. math.floor(price / 10000) .. L["dot"] .. math.floor((price % 10000) / 100) .. L["gold"])
    else
        RepairAllItems(false)
        print(GearHelper:ColorizeString(L["repairCost"], "Pink") .. math.floor(price / 10000) .. L["dot"] .. math.floor((price % 10000) / 100) .. L["gold"])
    end
end
