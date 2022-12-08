local moneyFlux = 0

function GearHelperEvents:MerchantClosed()
    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    local actualMoney = GetMoney()
    local moneyEarned = actualMoney - moneyFlux

    if (moneyEarned > 0 and moneyEarned ~= actualMoney) then
        print(GHToolbox:ColorizeString(GearHelper.locals["moneyEarned"], "LightGreen") ..
                  math.floor(moneyEarned / 10000) .. GearHelper.locals["dot"] .. math.floor((moneyEarned % 10000) / 100) ..
                  GearHelper.locals["gold"])
        moneyFlux = 0
    end
end

function GearHelperEvents:OnMerchantShow()
    moneyFlux = GetMoney()

    GearHelper:SellGreyItems()
    GearHelper:RepairEquipment()
end