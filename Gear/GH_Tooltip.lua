function GearHelper:AddLinesOnTooltip(tooltip, linesToAdd)
    for _, v in pairs(linesToAdd) do
        tooltip:AddLine(v)
    end
    tooltip:AddLine(" ")
end

function GearHelper:GenerateScoreLines(result)

    local linesToAdd = {}

    local slotUpgrade = "It's an upgrade to your %s by %.1f"
    local slotDowngrade = "It's a downgrade to your %s by %.1f"
    local pairUpgrade = "Paired with %s, it's an upgrade to your %s by %.1f"
    local itemIdx = 1

    for slotId, deltaScore in pairs(result.delta) do
        local localizedSlotName = _G[GearHelper.slotToNameMapping[slotId]]:lower()

        if slotId == 0 then --Special slotId returned when we want to display that it's simply better/worser than your weapons combo 
            localizedSlotName = AUCTION_CATEGORY_WEAPONS:lower()
        elseif self:GetArraySize(result.delta) == 2 then --Format to add which trinket/ring index
            localizedSlotName = localizedSlotName.." "..itemIdx
        end

        if (deltaScore < 0) then
            table.insert(linesToAdd, self:ColorizeString(string.format(slotDowngrade, localizedSlotName, deltaScore), "LightRed"))
        elseif (deltaScore > 0) then
            table.insert(linesToAdd, self:ColorizeString(string.format(slotUpgrade, localizedSlotName, deltaScore), "Better"))
        else
            table.insert(linesToAdd, self.locals["itemEgal"])
        end
        itemIdx = itemIdx + 1
    end
    return linesToAdd
end

function GearHelper:GetTooltipDataForItem(itemLink)
    local spec = GetSpecialization();
    local classID = select(3, UnitClass("player"))
    local specID = GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player"));

    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink, classID, specID)

    --This is required to populate .lefttext like fields
    --TooltipUtil.SurfaceArgs(tooltipData)
    --Magic happens in there, before processInfo data are wrong (same than GetItemStats)
    ScanningTooltip:ProcessInfo(tooltipData)
    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)
    end

    return tooltipData
end