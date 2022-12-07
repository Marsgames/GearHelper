function GearHelper:ShowUpgradeOnItemsIcons()
    for bagId, items in pairs(GearHelperVars.bagsItems) do
        local bagSize = C_Container.GetContainerNumSlots(bagId)
        for _, itemInfo in pairs(items) do
            local button = _G["ContainerFrame" .. bagId + 1 .. "Item" .. (bagSize + 1) - itemInfo.slot]

            if button then
                if button.overlay then
                    button.overlay:SetShown(false)
                    button.overlay = nil
                end
                if self:IsItemBetter(itemInfo.item) and not button.overlay then
                    GearHelper:Print("ShowUpgradeOnItemsIcons - " .. itemInfo.item.itemLink .. " is better")
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
