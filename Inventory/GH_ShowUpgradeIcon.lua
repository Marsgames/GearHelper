local function GetNameOrID(frame)
    if frame.GetName and frame:GetName() then
        return frame:GetName()
    elseif frame.GetID and frame:GetID() then
        return frame:GetID()
    end
end

local function AddIconTo(frame, icon, suffix)
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
    for bagId, items in pairs(GearHelperVars.bagsItems) do
        -- if not IsBagOpen(bagId) then
        --     print("Skip bag " .. bagId)
        --     do return end
        -- end

        local bagSize = C_Container.GetContainerNumSlots(bagId)
        for _, itemInfo in pairs(items) do
            local container = _G["ContainerFrame" .. bagId + 1] -- .. "Item" .. (bagSize + 1) - itemInfo.slot]
            -- print("------------")
            -- print("item : " .. tostring(itemInfo.item))
            -- print("slot : " .. tostring((bagSize + 1) - itemInfo.slot))
            local frame = container.Items[(bagSize + 1) - itemInfo.slot]
            if not frame then
               do return end
            end
            local suffix = GetNameOrID(frame:GetParent()) .. "." .. GetNameOrID(frame)

            if self:IsItemBetter(itemInfo.item) then
                AddIconTo(frame, "", suffix)
            end

            -- if button then
            --     if self:IsItemBetter(itemInfo.item) and not button.overlay then
            --         GearHelper:Print("ShowUpgradeOnItemsIcons - " .. itemInfo.item.itemLink .. " is better", "showUpgradeIcon")
            --         button.overlay = button:CreateTexture(nil, "OVERLAY")
            --         button.overlay:SetSize(18, 18)
            --         button.overlay:SetPoint("TOPLEFT")
            --         button.overlay:SetAtlas("bags-greenarrow", true)
            --         button.overlay:SetShown(true)
            --     end
            -- end
        end
    end

    ContainerFrame_UpdateAll()
end

function GearHelper:HideUpgradeOnItemsIcons()
    for bagId = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
        local bagSize = C_Container.GetContainerNumSlots(bagId)
        for slotId = 1, bagSize do
            local container = _G["ContainerFrame" .. bagId + 1] -- .. "Item" .. (bagSize + 1) - itemInfo.slot]
            -- print("------------")
            -- print("item : " .. tostring(itemInfo.item))
            -- print("slot : " .. tostring((bagSize + 1) - itemInfo.slot))
            local frame = container.Items[(bagSize + 1) - slotId]
            if not frame then
                do return end
            end
            if frame and frame.GearHelperOverlay then
                frame.GearHelperOverlay:Hide()
                frame.GearHelperOverlay = nil
            end



            -- local button = _G["ContainerFrame" .. bagId + 1 .. "Item" .. (bagSize + 1) - slotId]
            -- if button and button.overlay then
            --     -- print("hidding icon for slot " .. slotId)
            --     -- print("ContainerFrame" .. bagId + 1 .. "Item" .. (bagSize + 1) - slotId)
            --     button.overlay:SetShown(false)
            --     button.overlay = nil
            -- end
        end
    end
end
