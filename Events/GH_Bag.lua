function GHEvents:BAG_UPDATE(bagId)
    if time() - (GearHelperVars.lastBagUpdateEvent[bagId] or 0) < 1 or AUTO_EQUIP_ONGOING then
        do
            return
        end
    end

    GearHelperVars.lastBagUpdateEvent[bagId] = time()
    GearHelper:HideUpgradeItemsIcon(bagId)
    GearHelper:UpdateItemsInBags(bagId)
    GearHelper:AutoEquip(bagId)
end

function GHEvents:BAG_UPDATE_DELAYED()
    -- Update char frame when the bag is update because original UNIT_INVENTORY_CHANGED event is not fired when the player change trinkets or fingers
    GearHelper:ResetIlvlOnCharFrame()

    GearHelper:ScanCharacter()
    GearHelper:ShowUpgradeOnItemsIcons()
end
