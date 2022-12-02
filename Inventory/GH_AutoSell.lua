function GearHelper:SellGreyItems()
    if not GearHelper.db.profile.sellGreyItems then
        do
            return
        end
    end

    for bag = Enum.BagIndex.Backpack, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local infos = C_Container.GetContainerItemInfo(bag, slot)
            if (infos) then
                local quality = infos.quality
                if (quality and quality == 0) then
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end
end
