local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:LinesToAddToTooltip(result)
    self:BenchmarkCountFuncCall("GearHelper:LinesToAddToTooltip")
    local linesToAdd = {}

    if self:GetArraySize(result) == 1 then
        for _, v in pairs(result) do
            local flooredValue = math.floor(v)
            if (flooredValue < 0) then
                table.insert(linesToAdd, self:ColorizeString(L["itemLessThanGeneral"], "LightRed"))
            elseif (flooredValue > 0) then
                table.insert(linesToAdd, self:ColorizeString(L["itemBetterThanGeneral"], "Better") .. flooredValue)
            else
                table.insert(linesToAdd, L["itemEgal"])
            end
        end
    elseif self:GetArraySize(result) == 2 then
        for slot, weight in pairs(result) do
            local slotId = GetInventorySlotInfo(slot .. "Slot")
            local itemLink = self:GetEquippedItemLink(slotId, slot)

            local flooredValue = math.floor(weight)
            if (flooredValue < 0) then
                table.insert(linesToAdd, self:ColorizeString(L["itemLessThan"], "LightRed") .. " " .. itemLink)
            elseif (flooredValue > 0) then
                table.insert(linesToAdd, self:ColorizeString(L["itemBetterThan"], "Better") .. " " .. itemLink .. " " .. self:ColorizeString(L["itemBetterThan2"], "Better") .. flooredValue)
            else
                table.insert(linesToAdd, L["itemEgala"] .. " " .. itemLink)
            end
        end
    end
    return linesToAdd
end

function GearHelper:GetTooltipDataForItem(itemLink)
    local spec = GetSpecialization();
    local classID = select(3, UnitClass("player"))
    local specID = GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player"));

    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink, classID, specID)

    --This is required to populate .lefttext like fields
    TooltipUtil.SurfaceArgs(tooltipData)
    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)
    end
    --Magic happens in there, before processInfo data are wrong (same than GetItemStats)
    GameTooltip:ProcessInfo(tooltipData)

    return GameTooltip:GetTooltipData()
end