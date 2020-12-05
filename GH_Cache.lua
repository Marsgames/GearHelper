local function GetItemFromCache(itemLink)
    GearHelper:BenchmarkCountFuncCall("GetItemFromCache")
    for k, v in pairs(GearHelper.db.global.ItemCache) do
        if k == itemLink then
            return v
        end
    end
    return nil
end

local function PutItemInCache(itemLink, item)
    GearHelper:BenchmarkCountFuncCall("PutItemInCache")
    item.date = date("%y-%m-%d")
    GearHelper.db.global.ItemCache[itemLink] = item
end

function GearHelper:GetItemByLink(itemLink)
    self:BenchmarkCountFuncCall("GearHelper:GetItemByLink")

    local item = GetItemFromCache(itemLink)

    if not item then
        item = self:BuildItemFromTooltip(itemLink)
        if (false == item) then -- there was an error
            return
        end
        PutItemInCache(itemLink, item)
    else
        item.date = date("%y-%m-%d")
        GearHelper.db.global.ItemCache[itemLink] = item
    end

    return item
end

function GearHelper:CheckCacheDate()
    GearHelper:BenchmarkCountFuncCall("GearHlper:CheckCacheDate")

    local todayDate = GearHelper:MySplit(date("%y-%m-%d"), "-")
    local todayThreshold = ((todayDate[1] * 12 * 30) + (todayDate[2] * 30) + todayDate[3]) - 35

    for k, v in pairs(GearHelper.db.global.ItemCache) do
        if (nil == v.date) then
            GearHelper:RemoveItemByKey(GearHelper.db.global.ItemCache, k)
        else
            local itemDate = GearHelper:MySplit(v.date, "-")
            local itemDateNumber = (itemDate[1] * 12 * 30) + (itemDate[2] * 30) + itemDate[3]

            if (itemDateNumber < todayThreshold) then
                GearHelper:RemoveItemByKey(GearHelper.db.global.ItemCache, k)
            end
        end
    end
end

function GearHelper:ResetCache()
    self:BenchmarkCountFuncCall("GearHelper:ResetCache")
    self.db.global.ItemCache = {}
end
