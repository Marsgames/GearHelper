local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")
local itemsDropRates = {}

function GearHelper:LoadDropRates(value)
	self:BenchmarkCountFuncCall("GearHelper:LoadDropRates")

	itemsDropRates = value
end

function GearHelper:GetDropInfo(linesToAdd, itemLink)
	self:BenchmarkCountFuncCall("GearHelper:GetDropInfo")

	local _, _, _, _, itemId = string.find(tostring(itemLink), "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	if (itemsDropRates ~= nil and itemsDropRates[itemId] ~= nil) then
		table.insert(linesToAdd, L["DropRate"] .. itemsDropRates[itemId]["Rate"] .. "%")
		if itemsDropRates[itemId]["Zone"] ~= "" then
			table.insert(linesToAdd, L["DropZone"] .. itemsDropRates[itemId]["Zone"])
		end
		table.insert(linesToAdd, L["DropBy"] .. itemsDropRates[itemId]["Drop"])
	end
end
