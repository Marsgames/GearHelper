local function ShouldDisplayNotEquippable(item)
    local inventoryType = C_Item.GetItemInventoryTypeByID(item.itemLink)

    if item.isEmpty or not inventoryType or INVTYPE_TO_IGNORE[inventoryType] or inventoryType == 0 then
        return false
    end

    return true
end

function GearHelper:HookItemTooltip()
    local OnToolTipSetItem = function(tooltip, data)

        local tooltipItemLink = select(2, TooltipUtil.GetDisplayedItem(tooltip))
        if not GearHelper.db or not GearHelper.db.profile.addonEnabled or not tooltip == GameTooltip or
            tooltipItemLink == LAST_OPENED_TOOLTIP_ITEMLINK then
            GearHelper:AddLinesOnTooltip(tooltip, LAST_OPENED_TOOLTIP_LINES)
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
            --
            GearHelper:Print("OnToolTipSetItem - Item not equipped, computing value...")
            local result = GearHelper:CompareWithEquipped(item)
            linesToAdd = GearHelper:GenerateScoreLines(result)
            for slotId, scoreDelta in pairs(result.delta) do
                local floorValue = math.floor(scoreDelta)
                if (floorValue < 0) then
                    GearHelper:Print(item.itemLink ..
                        " worser than " .. _G[GearHelper.slotToNameMapping[slotId]]:lower() .. " by " .. scoreDelta)
                    tooltip.NineSlice:SetBorderColor(1, 0, 0)
                else
                    GearHelper:Print(item.itemLink ..
                        " better than " .. _G[GearHelper.slotToNameMapping[slotId]]:lower() .. " by " .. scoreDelta)
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
        GearHelper:AddLinesOnTooltip(tooltip, LAST_OPENED_TOOLTIP_LINES)

        LAST_OPENED_TOOLTIP_LINES = linesToAdd
    end

    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnToolTipSetItem)

    GameTooltip:HookScript(
        "OnHide",
        function(tooltip)
            -- Reset tooltip border color when hiding toltip (to avoid something like player tooltip to be red)
            tooltip.NineSlice:SetBorderColor(1, 1, 1)
        end
    )
end