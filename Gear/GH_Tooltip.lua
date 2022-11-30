local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:LinesToAddToTooltip(result)

    local linesToAdd = {}

    if self:GetArraySize(result) == 1 then
        for _, v in pairs(result) do
            local flooredValue = math.floor(v)
            if (flooredValue < 0) then
                table.insert(linesToAdd, self:ColorizeString(self.locals["itemLessThanGeneral"], "LightRed"))
            elseif (flooredValue > 0) then
                table.insert(linesToAdd, self:ColorizeString(self.locals["itemBetterThanGeneral"], "Better") .. flooredValue)
            else
                table.insert(linesToAdd, self.locals["itemEgal"])
            end
        end
    elseif self:GetArraySize(result) == 2 then
        for slot, weight in pairs(result) do
            local slotId = GetInventorySlotInfo(slot .. "Slot")
            local itemLink = self:GetEquippedItemLink(slotId, slot)

            local flooredValue = math.floor(weight)
            if (flooredValue < 0) then
                table.insert(linesToAdd, self:ColorizeString(self.locals["itemLessThan"], "LightRed") .. " " .. itemLink)
            elseif (flooredValue > 0) then
                table.insert(linesToAdd, self:ColorizeString(self.locals["itemBetterThan"], "Better") .. " " .. itemLink .. " " .. self:ColorizeString(self.locals["itemBetterThan2"], "Better") .. flooredValue)
            else
                table.insert(linesToAdd, self.locals["itemEgala"] .. " " .. itemLink)
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
    --TooltipUtil.SurfaceArgs(tooltipData)
    --Magic happens in there, before processInfo data are wrong (same than GetItemStats)
    ScanningTooltip:ProcessInfo(tooltipData)
    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)
    end

    return tooltipData
end