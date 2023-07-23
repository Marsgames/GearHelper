-- Remove unused localization
-- Localize all plain text found in code
-- Cleanup settings
-- Make bosses killed icons update when reopening LFG panel
-- Check why kill a mob trigger a bunch of "OnTooltipSetItem"
-- Fix version messages ask/answer
-- Remove Gearhelper.lua and split remaining function in appropriate folders/files
-- Fix TODOs in GH_QuestReward.lua
-- Fix TODOs in GH_RaidFinder.lua
-- Fix TODOs in GH_Slash.lua
-- Fix TODOs in GH_Group.lua
-- Fix TODOs in GH_Player.lua
-- Fix TODOs in GH_Quest.lua
-- Fix TODOs in GH_AutoEquip.lua
-- Fix TODOs in GH_Items.lua
-- Fix TODOs in GH_Messages.lua
-- Fix error when deactivating Bosses Killed option

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
    local arrayNames = GHToolbox:MySplit(self.db.global.myNames, ",")
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
                    -- self:Print("Scanning character slot " .. slotID .. " = " .. item:GetItemLink())
                    GearHelperVars.charInventory[slotID] = GHItem:Create(item:GetItemLink())
                end
            )
        end
    end
end
