GearHelper.tests = {
    ["GH_Toolbox"] = {
        ["IsInTable"] = function()
            wowUnit:assert(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, 21), "21 is in {1, 5, 3, 8, 21, 3, 5, 7}")
            wowUnit:assertEquals(GearHelper:IsInTable({8, 5, 3, 1, 2, 12}, 27), false, "27 is not in {8, 5, 3, 1, 2, 12}")
            wowUnit:assertEquals(GearHelper:IsInTable({}, nil), false, "nil is not in {}")
            wowUnit:assertEquals(GearHelper:IsInTable({}, 11), false, "11 is not in {}")
            -- wowUnit:assertEquals(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, nil), false, "nil is not in table") --> Toolbox.lua:167: bad argument #2 yo strmatch (string expected got nil)
            wowUnit:assert(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, "21"), '"21" is not in table but integer 21 is ({1, 5, 3, 8, 21, 3, 5, 7},)')
            wowUnit:assertEquals(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, "23"), false, '"23" is not in table but and integer 23 is not too ({1, 5, 3, 8, 21, 3, 5, 7})')
            wowUnit:assert(GearHelper:IsInTable({"1", "5", "3", "8", "21", "3", "5", "7"}, "21"), '"21" is in {"1", "5", "3", "8", "21", "3", "5", "7"}')
            wowUnit:assert(GearHelper:IsInTable({"1", "5", "3", "8", "21", "3", "5", "7"}, 21), '21 is not in {"1", "5", "3", "8", "21", "3", "5", "7"} but it returns true')
        end,
        ["IsEmptyTable"] = function()
            wowUnit:assert(GearHelper:IsEmptyTable({}), "{} is an empty table")
            wowUnit:assert(GearHelper:IsEmptyTable({nil}), "{nil} is an empty table")
            wowUnit:assertEquals(GearHelper:IsEmptyTable({21}), false, "{21} is not an empty table")
            wowUnit:assertEquals(GearHelper:IsEmptyTable({11, 21, 3, 46, 73, 7}), false, "{11, 21, 3, 46, 73, 7} is not an empty table")
            wowUnit:assertEquals(GearHelper:IsEmptyTable({""}), false, '{""} is not an empty table')
        end,
        ["parseID"] = function()
            wowUnit:assert(GearHelper:parseID("|cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0|h[Broken Fang]|h|r"), 7073, "Broken fang id is 7073")
        end,
        ["CountingSort"] = function()
            local tableUnsort = {3, 8, 5, 21, 1, 73, 7, 3}
            local tableSort = {1, 3, 3, 5, 7, 8, 21, 73}
            GearHelper:CountingSort(tableUnsort)
            wowUnit:assertSame(tableUnsort, tableSort, "table sorted")
        end
    }
}

function GearHelper:NewWeightCalculation(item, myEquipItem)
	GearHelper:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")
	if not GearHelper.db.profile.addonEnabled then
		do
			return
		end
	end

	if item == nil or IsEquippedItem(item.id) or not GearHelper:IsEquippableByMe(item) then
		return {"notEquippable"}
	end

	local result = {}
	-- if not IsEquippedItem(item.id) and GearHelper:IsEquippableByMe(item) then
	local tabSpec = GetItemSpecInfo(item.itemLink)
	local isSlotEmpty = GearHelper:IsSlotEmpty(item.equipLoc)
	--Item in inventory is not in cache, we return nil and the item that we were testing
	if not isSlotEmpty then
		return nil, item
	end

	if item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_FINGER" then --If item to test is a Trinket or a Finger
		--Get the two slots name
		local slotsList = GearHelper.itemSlot[item.equipLoc]
		for index, _ in pairs(slotsList) do --For each slot (2)
			if isSlotEmpty[index] == false then --The slot is not empty, we calculate delta
				local equippedItem
				if (myEquipItem) then
					equippedItem = GearHelper:GetItemByLink(myEquipItem)
				else
					equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory[slotsList[index]])
				end
				local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
				table.insert(result, ApplyTemplateToDelta(delta))
			else --The slot is empty, we pass directly the item
				local tmpResult = ApplyTemplateToDelta(item)
				if type(tmpResult) == "string" and tmpResult == "notAdapted" then
					table.insert(result, "betterThanNothing")
				else
					table.insert(result, tmpResult)
				end
			end
		end
	elseif item.equipLoc == "INVTYPE_WEAPON" then -- Masse à une main / épée à 1 main / Dague 1 main
		if isSlotEmpty[1] and isSlotEmpty[2] then --Nothing in both hands
			local tmpResult = ApplyTemplateToDelta(item)
			if type(tmpResult) == "string" and tmpResult == "notAdapted" then
				table.insert(result, "betterThanNothing")
			else
				table.insert(result, tmpResult)
			end
		elseif isSlotEmpty[1] and not isSlotEmpty[2] then -- Slot 1 empty / Slot 2 full
			local tmpResult = ApplyTemplateToDelta(item)
			if type(tmpResult) == "string" and tmpResult == "notAdapted" then
				table.insert(result, "betterThanNothing")
			else
				table.insert(result, tmpResult)
			end
		elseif not isSlotEmpty[1] and isSlotEmpty[2] and GearHelperVars.charInventory["SecondaryHand"] == -1 then -- Slot 2 empty because mainhand is 2 hand
			local equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
			local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
			table.insert(result, ApplyTemplateToDelta(delta))
		elseif not isSlotEmpty[1] and isSlotEmpty[2] and GearHelperVars.charInventory["SecondaryHand"] == 0 then
			local tmpResult = ApplyTemplateToDelta(item)
			if type(tmpResult) == "string" and tmpResult == "notAdapted" then
				table.insert(result, "betterThanNothing")
			else
				table.insert(result, tmpResult)
			end
		elseif not isSlotEmpty[1] and not isSlotEmpty[2] then
			local equippedItemMH = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
			local equippedItemSH = GearHelper:GetItemByLink(GearHelperVars.charInventory["SecondaryHand"])
			local deltaMH = GearHelper:GetStatDeltaBetweenItems(item, equippedItemMH)
			local deltaSH = GearHelper:GetStatDeltaBetweenItems(item, equippedItemSH)
			table.insert(result, ApplyTemplateToDelta(deltaMH))
			table.insert(result, ApplyTemplateToDelta(deltaSH))
		end
	elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then -- baton / Canne à pêche / hache à 2 main / masse 2 main / épée 2 main AND arc
		if isSlotEmpty[1] and isSlotEmpty[2] then
			local tmpResult = ApplyTemplateToDelta(item)
			if type(tmpResult) == "string" and tmpResult == "notAdapted" then
				table.insert(result, "betterThanNothing")
			else
				table.insert(result, tmpResult)
			end
		elseif isSlotEmpty[1] and not isSlotEmpty[2] then
			local equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["SecondaryHand"])
			local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
			table.insert(result, ApplyTemplateToDelta(delta))
		elseif not isSlotEmpty[1] and isSlotEmpty[2] then
			local equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
			local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
			table.insert(result, ApplyTemplateToDelta(delta))
		elseif not isSlotEmpty[1] and not isSlotEmpty[2] and GearHelperVars.charInventory["SecondaryHand"] == -1 then
			local equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
			local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
			table.insert(result, ApplyTemplateToDelta(delta))
		elseif not isSlotEmpty[1] and not isSlotEmpty[2] then
			local MHequippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
			local SHequippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["SecondaryHand"])
			local totalMHandSH = {}
			for k, v in pairs(MHequippedItem) do
				if type(v) == "numbers" then
					totalMHandSH[k] = v + SHequippedItem[k]
				end
			end
			local delta = GearHelper:GetStatDeltaBetweenItems(item, totalMHandSH)
			table.insert(result, ApplyTemplateToDelta(delta))
		end
	else
		if isSlotEmpty[1] == false then -- Si il y a un item equipé
			if GearHelperVars.charInventory[GearHelper.itemSlot[item.equipLoc]] == -1 then --If this is a offhand weapon and we have a 2h equipped
				local equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
				local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
				table.insert(result, ApplyTemplateToDelta(delta))
			else
				local equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory[GearHelper.itemSlot[item.equipLoc]])
				local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
				table.insert(result, ApplyTemplateToDelta(delta))
			end
		else
			local tmpResult = ApplyTemplateToDelta(item)
			if type(tmpResult) == "string" and tmpResult == "notAdapted" then
				table.insert(result, "betterThanNothing")
			else
				table.insert(result, tmpResult)
			end
		end
	end

	return result
end