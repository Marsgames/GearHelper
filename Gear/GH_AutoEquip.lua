function GearHelper:AutoEquip(bag)
    if not GearHelper.db.profile.autoEquipLooted.actual then
        do
            return
        end
    end
    AUTO_EQUIP_ONGOING = true --Used to prevent BAG_UPDATE events fired during auto equip to be processed

    local theBag = bag
    if bag == 23 then -- TODO : Check if this is necessary and can't be changed for something like bag % 19
        theBag = 4
    elseif bag == 22 then
        theBag = 3
    elseif bag == 21 then
        theBag = 2
    elseif bag == 20 then
        theBag = 1
    end

    GearHelper:Print("Auto equip best items in bag " .. tostring(theBag))

    GearHelper:EquipItem(theBag)
    AUTO_EQUIP_ONGOING = false
    GearHelper:UpdateItemsInBags(bagId) --Force an update at the items in bags at the end cause we are gating with AUTO_EQUIP_ONGOING
end

function GearHelper:EquipItem(inThisBag)
    local bagToEquip = inThisBag or 0
    local _, typeInstance, difficultyIndex = GetInstanceInfo()

    waitEquipFrame = CreateFrame("Frame")
    waitEquipTimer = time()
    waitEquipFrame:Hide()

    waitEquipFrame:SetScript(
        "OnUpdate",
        function(self, elapsed)
            if time() <= waitEquipTimer + 0.5 then
                do
                    return
                end
            end

            if "pvp" == typeInstance or "24" == tostring(difficultyIndex) or InCombatLockdown() then
                self:Hide()
                return
            end

            local bagsItems = GearHelperVars.bagsItems[bagToEquip]
            if (bagsItems == nil) then
                self:Hide()
                return
            end
            for _, slotData in pairs(bagsItems) do
                if slotData.item:IsEquippableByMe() and not IsEquippedItem(slotData.item.id) then
                    GearHelper:Print("AutoEquipItem - Item not equipped, comparing score...")
                    local result = GearHelper:CompareWithEquipped(slotData.item)

                    if result.combinable and result.combinable.combinedScoreDelta > 0 then
                        EquipItemByName(slotData.item.itemLink)
                        EquipItemByName(result.combinable.item.itemLink)
                    else
                        local shouldEquip = false
                        for _, deltaScore in pairs(result.delta) do
                            if deltaScore > 0 then
                                shouldEquip = true
                            end
                        end

                        if shouldEquip then
                            EquipItemByName(slotData.item.itemLink)
                        end
                    end
                end
            end

            self:Hide()
        end
    )
    waitEquipFrame:Show()
end
