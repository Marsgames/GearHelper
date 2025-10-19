---Add lines on a given tooltip
---@param tooltip table GameTooltip
---@param linesToAdd table List of lines to add on the tooltip
function GearHelper:AddLinesOnTooltip(tooltip, linesToAdd)
    for _, v in pairs(linesToAdd) do
        tooltip:AddLine(v)
    end
    tooltip:AddLine(" ")
end

---Get localized slot name from its ID
---@param slotId number Slot ID
---@param scoreResult table Result of the score comparison --TODO: we should probably pass delta instead of the whole result
---@param itemIdx number Index of the item (for rings/trinkets)
---@return string Localized slot name
function GearHelper:GetLocalizedSlotNameFromId(slotId, scoreResult, itemIdx)
    local localizedSlotName = _G[GearHelper.slotToNameMapping[slotId]]:lower()

    if slotId == 0 then --Special slotId returned when we want to display that it's simply better/worser than your weapons combo
        localizedSlotName = AUCTION_CATEGORY_WEAPONS:lower()
    elseif GHToolbox:GetArraySize(scoreResult.delta) == 2 then --Format to add which trinket/ring index
        localizedSlotName = localizedSlotName .. " " .. itemIdx
    end

    return localizedSlotName
end

---Generate tooltip settings from comparison result
---@param result table Result of the score comparison
---@return table Tooltip settings
function GearHelper:GenerateTooltipSettings(result)
    local tooltipSettings = {
        lines = {},
        borderColor = nil
    }

    local slotUpgrade = self.locals["slotUpgrade"]
    local slotDowngrade = self.locals["slotDowngrade"]
    local pairUpgrade = self.locals["pairUpgrade"]
    local itemIdx = 1

    for slotId, deltaScore in pairs(result.delta) do
        local localizedSlotName = GearHelper:GetLocalizedSlotNameFromId(slotId, result, itemIdx)

        if result.combinable and result.combinable.combinedScoreDelta > 0 then
            table.insert(tooltipSettings.lines, GHToolbox:ColorizeString(string.format(pairUpgrade, result.combinable.item.name, localizedSlotName, result.combinable.combinedScoreDelta), self.colorsName.BETTER))
            tooltipSettings.borderColor = ITEM_UPGRADE_TOOLTIP_BORDER
        elseif (deltaScore < 0) then
            table.insert(tooltipSettings.lines, GHToolbox:ColorizeString(string.format(slotDowngrade, localizedSlotName, deltaScore), self.colorsName.LIGHTRED))
            if not tooltipSettings.borderColor then --Otherwise one item is better and we want a green border color
                tooltipSettings.borderColor = ITEM_DOWNGRADE_TOOLTIP_BORDER
            end
        elseif (deltaScore > 0) then
            table.insert(tooltipSettings.lines, GHToolbox:ColorizeString(string.format(slotUpgrade, localizedSlotName, deltaScore), self.colorsName.BETTER))
            tooltipSettings.borderColor = ITEM_UPGRADE_TOOLTIP_BORDER
        else
            table.insert(tooltipSettings.lines, self.locals["equalItemScore"])
            tooltipSettings.borderColor = ITEM_EQUAL_TOOLTIP_BORDER
        end

        itemIdx = itemIdx + 1
    end

    return tooltipSettings
end

function GearHelper:GetTooltipDataForItem(itemLink)
    local spec = GetSpecialization()
    local classID = select(3, UnitClass("player"))
    local specID = GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player"))

    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink, classID, specID)

    --This is required to populate .lefttext like fields
    --TooltipUtil.SurfaceArgs(tooltipData)
    --Magic happens in there, before processInfo data are wrong (same than GetItemStats)
    -- ScanningTooltip:ProcessInfo(tooltipData)
    -- for _, line in ipairs(tooltipData.lines) do
    --     TooltipUtil.SurfaceArgs(line)
    -- end

    return tooltipData
end
