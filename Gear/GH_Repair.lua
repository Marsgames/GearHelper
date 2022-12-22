function GearHelper:RepairEquipment()
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
            print(self.locals["CantRepair"])
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
                print(self.locals["CantRepair"])
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
        print(GHToolbox:ColorizeString(self.locals["repairCost"], "Pink") .. math.floor(price / 10000) .. self.locals["dot"] .. math.floor((price % 10000) / 100) .. self.locals["gold"])
    elseif guildIsAbleToRepair then
        RepairAllItems(true)
        print(GHToolbox:ColorizeString(self.locals["guildRepairCost"], "Pink") .. math.floor(price / 10000) .. self.locals["dot"] .. math.floor((price % 10000) / 100) .. self.locals["gold"])
    else
        RepairAllItems(false)
        print(GHToolbox:ColorizeString(self.locals["repairCost"], "Pink") .. math.floor(price / 10000) .. self.locals["dot"] .. math.floor((price % 10000) / 100) .. self.locals["gold"])
    end
end
