local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

-- TODO: this function only return gems if there are on the item ?!
local function GetNumberOfGemsFromTooltip()
    GearHelper:BenchmarkCountFuncCall("GetNumberOfGemsFromTooltip")
    local n = 0
    local textures = {}

    for i = 1, 10 do
        textures[i] = _G["GameTooltipTexture" .. i]
    end

    for i = 1, 10 do
        if textures[i]:IsShown() then
            n = n + 1
        end
    end

    return tonumber(n)
end

function GearHelper:BuildItemFromTooltip(itemLink)
    self:BenchmarkCountFuncCall("GearHelper:BuildItemFromTooltip")
    local tip = ""
    local item = {}

    if not itemLink or itemLink == -1 then
        error(GHExceptionInvalidItemLink .. " : " .. tostring(itemLink))
        return false
    end

    if string.find(itemLink, L["mascotte"]) then
        error(GHExceptionInvalidItem .. " : " .. tostring(itemLink))
        return false
    end

    tip = myTooltipFromTemplate or CreateFrame("GAMETOOLTIP", "myTooltipFromTemplate", nil, "GameTooltipTemplate", BackdropTemplateMixin and "BackdropTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")

    tip:SetHyperlink(itemLink)

    item.levelRequired = 0
    _, item.itemLink = tip:GetItem()
    item.itemString = string.match(item.itemLink, "item[%-?%d:]+")
    _, _, item.rarity = string.find(item.itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
    item.id, item.type, item.subType, item.equipLoc = GetItemInfoInstant(item.itemLink)
    item.name = _G["GameTooltipTextLeft1"]:GetText()
    if GetItemInfo(item.itemLink) then
        _, _, _, _, _, _, _, _, _, _, item.sellPrice = GetItemInfo(item.itemLink)
    end

    item.nbGem = GetNumberOfGemsFromTooltip()

    for i = 2, tip:NumLines() do
        local text = _G["myTooltipFromTemplateTextLeft" .. i]:GetText()

        if text then
            if string.find(text, L["Tooltip"].ItemLevel) then
                for word in string.gmatch(text, "(%d+)") do
                    item.iLvl = tonumber(word)
                end
            elseif string.find(text, L["Tooltip"].LevelRequired) then
                item.levelRequired = tonumber(string.match(text, "%d+"))
            elseif string.find(text, L["Tooltip"].BonusGem) then
                for k, v in pairs(L["Tooltip"].Stat) do
                    if string.find(string.match(text, "%+(.*)"), v) then
                        item.bonusGem = {}
                        item.bonusGem[k] = (string.gsub(text, "%D+", ""))
                    end
                end
            else
                for k, v in pairs(L["Tooltip"].Stat) do
                    if string.find(text, v) and not string.match(text, "%:") then
                        item[k] = tonumber((string.gsub(text, "%D+", "")))
                    end
                end
            end
        end
    end

    return item
end

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
