local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:ForEachItemInBag(callback)
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            if GetContainerItemID(bag, slot) ~= nil then
                callback(bag, slot)
            end
        end
    end
end

function GearHelper:SellGreyItems()
    GearHelper:BenchmarkCountFuncCall("SellGreyItems")

    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    GearHelper:ForEachItemInBag(
        function(bag, slot)
            local id = GetContainerItemID(bag, slot)
            if id then
                local isValueAvailable, sellPrice = GearHelper:GetItemSellPrice(id)
                if isValueAvailable then
                    UseContainerItem(bag, slot)
                end
            end
        end
    )
end
