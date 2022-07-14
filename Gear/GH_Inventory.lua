local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function GetSlotsByEquipLoc(equipLoc)
    GearHelper:BenchmarkCountFuncCall("GetSlotsByEquipLoc")
    local equipSlot = {}

    if equipLoc == "INVTYPE_WEAPON" then
        local _, myClass = UnitClass("player")
        local playerSpec = GetSpecializationInfo(GetSpecialization())
        local equipLocByClass = GearHelper.itemSlot[equipLoc][myClass]

        if equipLocByClass[tostring(playerSpec)] == nil then
            equipSlot = equipLocByClass
        else
            equipSlot = equipLocByClass[tostring(playerSpec)]
        end
    else
        equipSlot = GearHelper.itemSlot[equipLoc]
    end

    return equipSlot
end

function GearHelper:GetItemsByEquipLoc(equipLoc)
    self:BenchmarkCountFuncCall("GearHelper:GetItemsByEquipLoc")
    local result = {}
    local equipSlot = GetSlotsByEquipLoc(equipLoc)

    -- TODO: si on remplace ça par Result[v] = true, on peut faire une recherche dans la table avec un if (Result[v]) then, ce qui evite de faire un foreach avec la fonction IsValueInTablr
    for k, v in ipairs(equipSlot) do
        result[v] = GearHelperVars.charInventory[v]
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
