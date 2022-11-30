local itemsDropRates = {}

function GearHelper:LoadDropRates(value)
	itemsDropRates = value
end

function GearHelper:GetDropInfo(linesToAdd, itemLink)
	local _, _, _, _, itemId = string.find(tostring(itemLink), "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	if (itemsDropRates ~= nil and itemsDropRates[itemId] ~= nil) then
		table.insert(linesToAdd, self.locals["DropRate"] .. itemsDropRates[itemId]["Rate"] .. "%")
		if itemsDropRates[itemId]["Zone"] ~= "" then
			table.insert(linesToAdd, self.locals["DropZone"] .. itemsDropRates[itemId]["Zone"])
		end
		table.insert(linesToAdd, self.locals["DropBy"] .. itemsDropRates[itemId]["Drop"])
	end
end
