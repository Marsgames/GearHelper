function GearHelper:GetItemCoroutine(itemLink)
    self:BenchmarkCountFuncCall("GearHelper:GetItemByLink")
    self:Print("GetItemCoroutine - Generating item from "..itemLink)

    local item = Item:CreateFromItemLink(itemLink)

    if item:IsItemEmpty() or GearHelper.itemSlot[select(4, GetItemInfoInstant(itemLink))] == nil then
        self:Print("GetItemCoroutine - Not building item because invalid / not a stuff "..itemLink)
        return nil
    end

    if(item:IsItemDataCached() == false) then
        self:Print("GetItemCoroutine - Item "..itemLink.." not in cache, yielding")

        item:ContinueOnItemLoad(function()
            self:Print("GetItemCoroutine - Item "..itemLink.." received, resuming")
            coroutine.resume(GearHelperVars.coroutineQueue[itemLink])
        end)

        coroutine.yield()
    end

    local customItem = {}

    customItem.itemLink = itemLink
    customItem.itemString = string.match(customItem.itemLink, "item[%-?%d:]+")
    customItem.rarity = item:GetItemQuality()
    _, _, _, _, customItem.levelRequired = GetItemInfo(itemLink)
    customItem.id, customItem.type, customItem.subType, customItem.equipLoc = GetItemInfoInstant(customItem.itemLink)
    customItem.name = item:GetItemName()
    customItem.stats = GearHelper:GetItemStats(itemLink)
    customItem.iLvl = item:GetCurrentItemLevel()
    customItem.isEquippable = self:IsEquippableByMe(customItem) and not IsEquippedItem(customItem.id)

    self:Print("GetItemCoroutine - Custom Item build from "..itemLink)
    self:Print(customItem)
    self:Print("\n")

    return customItem
end

function GearHelper:GetItem(itemLink)
    local co = function()
        return self:GetItemCoroutine(itemLink)
    end

    GearHelperVars.coroutineQueue[itemLink] = coroutine.create(co)

    local _, item = coroutine.resume(GearHelperVars.coroutineQueue[itemLink])

    return item
end

function GearHelper:GetItemStats(itemLink)
    local tooltipData = self:GetTooltipDataForItem(itemLink)
    local stats = {}
    

    for _, line in ipairs(tooltipData.lines) do
        local idxStart, _, statValue, statName = string.find(line.leftText, "+(%d+) (.+)")
        if idxStart then
            stats[statName] = statValue
        end
    end

    self:Print("Statistics extracted from tooltip for "..itemLink)
    self:Print(stats)

    return stats
end
