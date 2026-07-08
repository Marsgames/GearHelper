function GHEvents:BAG_UPDATE(bagId)
    if time() - (GearHelperVars.lastBagUpdateEvent[bagId] or 0) < 1 or AUTO_EQUIP_ONGOING then
        do
            return
        end
    end

    GearHelperVars.lastBagUpdateEvent[bagId] = time()
    GearHelper:UpdateItemsInBags(bagId)
end

function GHEvents:BAG_UPDATE_DELAYED()
    for i = 0, NUM_BAG_SLOTS do
        GearHelper:UpdateItemsInBags(i)
    end

    GearHelper:ScanCharacter()

    for _, frame in ContainerFrameUtil_EnumerateContainerFrames() do
        GearHelper:HideUpgradeOnItemsIconsForContainer(frame)
        GearHelper:ShowUpgradeOnItemsIconsForContainer(frame)
    end
end

function GHEvents:BAG_UPDATE_COOLDOWN()
    for i = 0, NUM_BAG_SLOTS do
        GearHelper:UpdateItemsInBags(i)
    end

    GearHelper:ScanCharacter()

    for _, frame in ContainerFrameUtil_EnumerateContainerFrames() do
        GearHelper:HideUpgradeOnItemsIconsForContainer(frame)
        GearHelper:ShowUpgradeOnItemsIconsForContainer(frame)
    end
end
