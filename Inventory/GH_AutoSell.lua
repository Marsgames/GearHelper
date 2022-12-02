function GearHelper:SellGreyItems()
    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    for bag = Enum.BagIndex.Backpack, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local id = C_Container.GetContainerItemID(bag, slot)
            if (id) then
                local _, _, quality = GetItemInfo(id)
                if (quality and quality == 0) then
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end
end
