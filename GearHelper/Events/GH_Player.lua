-- local waitSpeFrame = CreateFrame("Frame")

-- waitSpeFrame:Hide()

-- TODO: Split this shit too
function GHEvents:PLAYER_ENTERING_WORLD()
    local used = false
    for i = 1, NUM_CHAT_WINDOWS do
        local _, _, _, _, _, _, _, _, _, uninteractable = GetChatWindowInfo(i)
        if (uninteractable) then
            SetChatWindowUninteractable(i, false)
            used = true
        end
    end
    if used then
        ReloadUI()
    end

    securecall(GearHelper.BuildCWTable, GearHelper)

    -- This UpdateItemsInBags is causing an issue
    GearHelper:UpdateItemsInBags(0)

    GearHelper:ScanCharacter()
end

-- function GHEvents:ACTIVE_TALENT_GROUP_CHANGED()
--     if not GearHelper.db.profile.autoEquipWhenSwitchSpe then
--         GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
--         do
--             return
--         end
--     end

--     GearHelperVars.waitSpeTimer = time()
--     waitSpeFrame:Show()

--     for bag = Enum.BagIndex.Backpack, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
--         GHEvents:BagUpdate(nil, nil, bag)
--     end

--     GearHelper:ShowUpgradeOnItemsIcons()
-- end

function GHEvents:UNIT_INVENTORY_CHANGED(target)
    if target ~= "player" then
        do
            return
        end
    end

    GearHelper:Print("EVENT UNIT_INVENTORY_CHANGED", "events")
    GearHelper:ScanCharacter()
end
