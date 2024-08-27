local function GetNameOrID(frame)
    if frame.GetName and frame:GetName() then
        return frame:GetName()
    elseif frame.GetID and frame:GetID() then
        return frame:GetID()
    end
end

local function AddIconTo(frame, suffix)
    if not frame then
        return
    end
    if frame.GearHelperOverlay then
        return
    end

    if frame.GetName then
        suffix = suffix or tostring(frame:GetName())
    elseif frame.GetID then
        suffix = suffix or tostring(frame:GetID())
    end
        
    if suffix == nil or suffix == "nil" then
        print("An error occured while trying to add an icon to a frame")
    end


    local localFrame = CreateFrame("Frame", "GearHelperOverlay_"..suffix, frame)
    frame.GearHelperOverlay = localFrame
    -- Get the frame to match the shape/size of its parent
    localFrame:SetAllPoints()

    -- Create the texture frame.
    localFrame.GearHelperIconTexture = localFrame:CreateTexture("GearHelperTextureFrame", "OVERLAY")
    localFrame.GearHelperIconTexture:SetWidth(18)
    localFrame.GearHelperIconTexture:SetHeight(18)
    localFrame.GearHelperIconTexture:SetPoint("TOPLEFT")
    localFrame.GearHelperIconTexture:SetAtlas("bags-greenarrow", true)
    localFrame.GearHelperIconTexture:SetShown(true)
    -- localFrame:SetScript("OnUpdate", CIMIOnUpdateFuncMaker(updateIconFunc))
    return localFrame
end

function GearHelper:ShowUpgradeOnItemsIcons()
    for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        -- local bagSize = C_Container.GetContainerNumSlots(bagId)
        local container = _G["ContainerFrame" .. bagId + 1]

        -- Continue if there is no equiped bag
        if container == nil then
            do return end
        end

        for slotId, slot in pairs(container.Items) do
            -- Simple check to remove everything that is not a single item
            local count = slot.count
            if count == 1 then
                -- print("bag" .. bagId + 1 .. " slot" .. slotId .. " count: " .. count)
                -- local success, wowItemLink = pcall(slot.GetItemInfo)
                -- if success then
                    local wowItemLink = slot:GetItemLink()
                    local ghItemLink = GHItem:Create(wowItemLink)

                    -- Check if item is equippable
                    if wowItemLink and C_Item.IsEquippableItem(wowItemLink) then
                        local suffix = GetNameOrID(slot:GetParent()) .. "." .. GetNameOrID(slot)

                        if ghItemLink and self:IsItemBetter(ghItemLink) then
                        AddIconTo(slot, suffix)
                            print("Add icon")
                        end
                    end
                -- end
            end
        end
    end
    
    ContainerFrame_UpdateAll()
end

function GearHelper:HideUpgradeOnItemsIcons()
    for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        -- local bagSize = C_Container.GetContainerNumSlots(bagId)
        local container = _G["ContainerFrame" .. bagId + 1]

        -- Continue if there is no equiped bag
        if container == nil then
            do return end
        end

        for slotId, slot in pairs(container.Items) do
            -- Simple check to remove everything that is not a single item
            local count = slot.count
            if count == 1 then
                local wowItemLink = slot:GetItemLink()

                -- Check if item is equippable
                if wowItemLink and C_Item.IsEquippableItem(wowItemLink) then
                    if slot and slot.GearHelperOverlay then
                        slot.GearHelperOverlay:Hide()
                        slot.GearHelperOverlay = nil
                    end
                end
            end
        end
    end
end
