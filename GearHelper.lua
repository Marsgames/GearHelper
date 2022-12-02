-- Cleanup Trad data
-- Cleanup settings
-- Check why kill a mob trigger a bunch of "OnToolTipSetItem"
-- SetDotOnIcons is pete
-- On bag change do not trigger all items compare, only the new one
-- Add line on tooltip compare

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
        elseif not itemCached.itemLink == item:GetItemLink() then
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

local function ShouldDisplayNotEquippable(item)
    local inventoryType = C_Item.GetItemInventoryTypeByID(item.itemLink)

    if item.isEmpty or not inventoryType or INVTYPE_TO_IGNORE[inventoryType] or inventoryType == 0 then
        return false
    end

    return true
end

local function OnToolTipSetItem(tooltip, data)
    local tooltipItemLink = select(2, TooltipUtil.GetDisplayedItem(tooltip))
    if not GearHelper.db or not GearHelper.db.profile.addonEnabled or not tooltip == GameTooltip or tooltipItemLink == LAST_OPENED_TOOLTIP_ITEMLINK then
        return
    end

    LAST_OPENED_TOOLTIP_ITEMLINK = tooltipItemLink
    local item = GHItem:Create(tooltipItemLink)
    if not item then
        return
    end

    local linesToAdd = {}

    if IsEquippedItem(item.itemLink) then -- Item equipped, yellow overlay on tooltip
        GearHelper:Print("OnToolTipSetItem - Item already equipped, applying yellow overlay")
        tooltip.NineSlice:SetBorderColor(FACTION_YELLOW_COLOR.r, FACTION_YELLOW_COLOR.g, FACTION_YELLOW_COLOR.b)
        table.insert(linesToAdd, GearHelper:ColorizeString(GearHelper.locals["itemEquipped"], "Yellow"))
    elseif item:IsEquippableByMe() and not IsEquippedItem(item.id) then
        --linesToAdd = GearHelper:LinesToAddToTooltip(result)
        GearHelper:Print("OnToolTipSetItem - Item not equipped, computing value...")
        local result = GearHelper:CompareWithEquipped(item)
        for slotId, scoreDelta in pairs(result) do
            local floorValue = math.floor(scoreDelta)
            if (floorValue < 0) then
                GearHelper:Print(item.itemLink .. " worser than " .. _G[GearHelper.slotToNameMapping[slotId]]:lower() .. " by " .. scoreDelta)
                tooltip.NineSlice:SetBorderColor(1, 0, 0)
            else
                GearHelper:Print(item.itemLink .. " better than " .. _G[GearHelper.slotToNameMapping[slotId]]:lower() .. " by " .. scoreDelta)
                tooltip.NineSlice:SetBorderColor(0, 255, 150)
            end
        end
    elseif ShouldDisplayNotEquippable(item) then -- Item not equippable, red overlay on tooltip
        GearHelper:Print("OnToolTipSetItem - Item not equippable, applying red overlay")
        table.insert(linesToAdd, GearHelper:ColorizeString(GearHelper.locals["itemNotEquippable"], "LightRed"))
        tooltip.NineSlice:SetBorderColor(255, 0, 0)
    end

    -- Add droprate to tooltip
    GearHelper:GetDropInfo(linesToAdd, itemLink)

    if linesToAdd then
        tooltip:AddLine(" ")
        for _, v in pairs(linesToAdd) do
            tooltip:AddLine(v)
        end
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnToolTipSetItem)
GameTooltip:HookScript(
    "OnHide",
    function(tooltip)
        GearHelper:Print("ON HIDE GAMETOOLTIP")
        -- Reset tooltip border color when hiding toltip (to avoid something like player tooltip to be red)
        tooltip.NineSlice:SetBorderColor(1, 1, 1)
    end
)

TooltipDataProcessor.AddTooltipPostCall(
    Enum.TooltipDataType.Money,
    function(self, amount)
        local _, itemLink = self:GetItem()
        if GearHelper.db.global.ItemCache[itemLink] and not GearHelper.db.global.ItemCache[itemLink].sellPrice then
            GearHelper.db.global.ItemCache[itemLink].sellPrice = amount
        end
    end
)
