function GearHelper:ShowUpgradeOnItemsIcons()
    for bagId, items in pairs(GearHelperVars.bagsItems) do
        local bagSize = C_Container.GetContainerNumSlots(bagId)
        for _, itemInfo in pairs(items) do
            local button = _G["ContainerFrame" .. bagId + 1 .. "Item" .. (bagSize + 1) - itemInfo.slot]

            if button then
                if self:IsItemBetter(itemInfo.item) and not button.overlay then
                    GearHelper:Print("ShowUpgradeOnItemsIcons - " .. itemInfo.item.itemLink .. " is better", "showUpgradeIcon")
                    button.overlay = button:CreateTexture(nil, "OVERLAY")
                    button.overlay:SetSize(18, 18)
                    button.overlay:SetPoint("TOPLEFT")
                    button.overlay:SetAtlas("bags-greenarrow", true)
                    button.overlay:SetShown(true)
                end
            end
        end
    end

    ContainerFrame_UpdateAll()
end

function GearHelper:HideAllUpgradeItemIcons()
    for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local bagSize = C_Container.GetContainerNumSlots(bagId)
        for slotId = 1, bagSize do
            local button = _G["ContainerFrame" .. bagId + 1 .. "Item" .. (bagSize + 1) - slotId]
            if button and button.overlay then
                -- print("hidding icon for slot " .. slotId)
                -- print("ContainerFrame" .. bagId + 1 .. "Item" .. (bagSize + 1) - slotId)
                button.overlay:SetShown(false)
                button.overlay = nil
            end
        end
    end
end
