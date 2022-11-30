function GearHelper:SellGreyItems()
    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            if C_Container.GetContainerItemID(bag, slot) == nil then
                local id = C_Container.GetContainerItemID(bag, slot)

                --Test if itemRarity (3) is grey
                if id and select(3, GetItemInfo(id)) == 0 then
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end
end
