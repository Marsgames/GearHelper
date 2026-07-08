function GearHelper:ScanCharacter()
    for slotID, itemCached in pairs(GearHelperVars.charInventory) do
        local item = Item:CreateFromEquipmentSlot(slotID)

        if item:IsItemEmpty() then
            GearHelperVars.charInventory[slotID] = GHItem:CreateEmpty()
        elseif not (itemCached.itemLink == item:GetItemLink()) then
            if (item:IsItemDataCached() == false) then
                self:Print("Item in slot " .. slotID .. " not in cache")
            end

            item:ContinueOnItemLoad(
                function()
                    -- self:Print("Scanning character slot " .. slotID .. " = " .. item:GetItemLink())
                    GearHelperVars.charInventory[slotID] = GHItem:Create(item:GetItemLink())
                end
            )
        end
    end
end
