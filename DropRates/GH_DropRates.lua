local itemsDropRates = {}

function GearHelper:LoadDropRates(value)
    self:BenchmarkCountFuncCall("GearHelper:LoadDropRates")
    itemsDropRates = value
end

function GearHelper:GetDropInfo(linesToAdd, itemLink)
	self:BenchmarkCountFuncCall("GearHelper:GetDropInfo")
	local _, _, _, _, itemId = string.find(tostring(itemLink), "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	if itemsDropRate[itemId] ~= nil then
		table.insert(linesToAdd, L["DropRate"] .. itemsDropRate[itemId]["Rate"] .. "%")
		if itemsDropRate[itemId]["Zone"] ~= "" then
			table.insert(linesToAdd, L["DropZone"] .. itemsDropRate[itemId]["Zone"])
		end
		table.insert(linesToAdd, L["DropBy"] .. itemsDropRate[itemId]["Drop"])
	end
end