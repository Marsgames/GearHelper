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
	GearHelper.db.global.ItemCache[itemLink] = item
end

function GearHelper:GetItemByLink(itemLink)
	self:BenchmarkCountFuncCall("GearHelper:GetItemByLink")

	local item = self:GetItemFromCache(itemLink)

	if not item then
		item = self:BuildItemFromTooltip(itemLink)
		self:PutItemInCache(itemLink, item)
	end

	return item
end

function GearHelper:ResetCache()
	self:BenchmarkCountFuncCall("GearHelper:ResetCache")
	self.db.global.ItemCache = {}
end