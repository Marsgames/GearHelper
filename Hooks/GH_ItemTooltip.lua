local function ShouldDisplayNotEquippable(item)
    local inventoryType = C_Item.GetItemInventoryTypeByID(item.itemLink)

    if item.isEmpty or not inventoryType or INVTYPE_TO_IGNORE[inventoryType] or inventoryType == 0 then
        return false
    end

    return true
end

function GearHelper:HookItemTooltip()
    local OnToolTipSetItem = function(tooltip, _)
        local tooltipItemLink = select(2, TooltipUtil.GetDisplayedItem(tooltip))
        if not GearHelper.db or not tooltip == GameTooltip then
            return
        end

        local item = GHItem:Create(tooltipItemLink)
        if item.isEmpty then
            return
        end

        local tooltipSettings = {
            lines = {},
            borderColor = nil
        }

        if item:IsEquipped() then -- Item equipped, yellow overlay on tooltip
            GearHelper:Print("OnToolTipSetItem - Item already equipped, applying yellow overlay", "itemTooltip")
            tooltipSettings.borderColor = ITEM_EQUAL_TOOLTIP_BORDER
            table.insert(tooltipSettings.lines, GHToolbox:ColorizeString(GearHelper.locals["itemEquipped"], "Yellow"))
        elseif item:IsEquippableByMe() then
            GearHelper:Print("OnToolTipSetItem - Item not equipped, comparing score...", "itemTooltip")
            local result = GearHelper:CompareWithEquipped(item)
            tooltipSettings = GearHelper:GenerateTooltipSettings(result)
        elseif ShouldDisplayNotEquippable(item) then -- Item not equippable, red overlay on tooltip
            GearHelper:Print("OnToolTipSetItem - Item not equippable, applying red overlay", "itemTooltip")
            table.insert(tooltipSettings.lines, GHToolbox:ColorizeString(GearHelper.locals["itemNotEquippable"], "LightRed"))
            tooltipSettings.borderColor = ITEM_DOWNGRADE_TOOLTIP_BORDER
        end

        if tooltipSettings.borderColor then
            tooltip.NineSlice:SetBorderColor(tooltipSettings.borderColor.r, tooltipSettings.borderColor.g, tooltipSettings.borderColor.b)
        end
        tooltipSettings.lines = GHToolbox:TableConcat(tooltipSettings.lines, GearHelper:GetDropInfo(item))

        GearHelper:AddLinesOnTooltip(tooltip, tooltipSettings.lines)
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
