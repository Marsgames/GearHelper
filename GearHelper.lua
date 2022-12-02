-- Cleanup Trad data
-- Cleanup settings / db
-- Check why kill a mob trigger a bunch of "OnToolTipSetItem"
-- SetDotOnIcons is pete
-- On bag change do not trigger all items compare, only the new one
-- Move harcoded lines on tooltip to localization
-- Manage find a pairable item to compare with
-- Reset player templates on addon update major
-- Fix version messages ask/answer
function GearHelper:setInviteMessage(newMessage)
    if newMessage == nil then
        return
    end

    self.db.profile.inviteMessage = tostring(newMessage)
    print(self.locals["InviteMessage"] .. tostring(self.db.profile.inviteMessage))
end

function GearHelper:showMessageSMN(channel, sender, msg)
    if not self.db.profile.sayMyName or not msg then
        return
    end

    local stop = false
    local arrayNames = self:MySplit(self.db.global.myNames, ",")
    if arrayNames[1] == nil then
        return
    end

    local i = 1
    while (not stop and arrayNames[i]) do
        if (string.match(msg:lower(), arrayNames[i]:lower())) then
            UIErrorsFrame:AddMessage(channel .. " [" .. sender .. "]: " .. msg, 0.0, 1.0, 0.0)
            PlaySound(5275, "Master")
            stop = true
            return
        end
        i = i + 1
    end
end

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
                    self:Print("Scanning character slot " .. slotID .. " = " .. item:GetItemLink())
                    GearHelperVars.charInventory[slotID] = GHItem:Create(item:GetItemLink())
                end
            )
        end
    end
end

function GearHelper:SetDotOnIcons()
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local myBag = bag + 1
            local mySlot = C_Container.GetContainerNumSlots(bag) - (slot - 1)
            local button = _G["ContainerFrame" .. myBag .. "Item" .. mySlot]
            local itemLink = C_Container.GetContainerItemLink(bag, slot)

            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end

            if (itemLink and self:IsItemBetter(itemLink) and not button.overlay) then
                button.overlay = button:CreateTexture(nil, "OVERLAY")
                button.overlay:SetSize(18, 18)
                button.overlay:SetPoint("TOPLEFT")
                button.overlay:SetAtlas("bags-greenarrow", true)
                button.overlay:SetShown(true)
            end
        end
    end
    ContainerFrame_UpdateAll()
end
