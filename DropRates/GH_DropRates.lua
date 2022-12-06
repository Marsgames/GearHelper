local itemsDropRates = {}

function GearHelper:LoadDropRates(value)
    itemsDropRates = value
end

function GearHelper:GetDropInfo(item)
    local lines = {}
    if (itemsDropRates ~= nil and itemsDropRates[item.id] ~= nil) then
        table.insert(lines, self.locals["DropRate"] .. itemsDropRates[item.id]["Rate"] .. "%")
        if itemsDropRates[item.id]["Zone"] ~= "" then
            table.insert(lines, self.locals["DropZone"] .. itemsDropRates[item.id]["Zone"])
        end
        table.insert(lines, self.locals["DropBy"] .. itemsDropRates[item.id]["Drop"])
    end

    return lines
end
