function GearHelper:IsItemBetter(itemLink)
	self:BenchmarkCountFuncCall("GearHelper:IsItemBetter")
	local item = {}
	local itemEquipped = nil
	local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

	-- See in GearHelper.lua/ModifyTooltip()
	local shouldBeCompared, err = pcall(self.ShouldBeCompared, nil, itemLink)
	if (not shouldBeCompared) then
		return false
	end
	item = self:GetItemByLink(itemLink)

	local status, res = pcall(self.NewWeightCalculation, self, item)
	if not status then
		return false
	end

	for _, result in pairs(res) do
		if result > 0 then
			return true
		end
	end

	return false
end

function GearHelper:ShouldBeCompared(itemLink)
	GearHelper:BenchmarkCountFuncCall("GearHelper:ShouldBeCompared")

	if (not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r")) then
		error(GHExceptionInvalidItemLink)
	end

	local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

	if (IsEquippedItem(id)) then
		error(GHExceptionAlreadyEquipped)
	end

	if (not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink))) then
		error(GHExceptionNotEquippable)
	end

	return true
end

local function ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
	GearHelper:BenchmarkCountFuncCall("ComputeWithTemplateDeltaBetweenItems")
	local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)

	return GearHelper:ApplyTemplateToDelta(delta)
end

-- TODO: Rework this function
function GearHelper:EquipItem(inThisBag)
	self:BenchmarkCountFuncCall("GearHelper:EquipItem")
	local bagToEquip = inThisBag or 0
	local _, typeInstance, difficultyIndex = GetInstanceInfo()
	waitEquipFrame = CreateFrame("Frame")
	waitEquipTimer = time()
	waitEquipFrame:Hide()
	waitEquipFrame:SetScript(
		"OnUpdate",
		function(self, elapsed)
			if time() <= waitEquipTimer + 0.5 then
				do
					return
				end
			end

			if "pvp" == typeInstance or "24" == tostring(difficultyIndex) or InCombatLockdown() then
				self:Hide()
				return
			end

			for slot = 1, GetContainerNumSlots(bagToEquip) do
				local itemLink = GetContainerItemLink(bagToEquip, slot)
				if pcall(self.ShouldBeCompared, itemLink) then
					local item = self:GetItemByLink(itemLink)
					local status, result = pcall(self.NewWeightCalculation, self, item)

					if status then
						for _, v in pairs(result) do
							if v > 0 then
								EquipItemByName(item.itemLink)
							end
						end
					end
				end
			end
			self:Hide()
		end
	)
	waitEquipFrame:Show()
end

function GearHelper:NewWeightCalculation(item)
	self:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")

	local result = {}

	if (self:IsInventoryInCache() == false) then
		-- TODO: why don't we cached the inventory here ?
		GearHelper:ScanCharacter() -- is this the function to cache the inventory ?
		error(GHExceptionInventoryNotCached)
	end

	local equippedItems = GearHelper:GetItemsByEquipLoc(item.equipLoc)

	if item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_FINGER" then
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = self:ApplyTemplateToDelta(item)
			else
				equippedItem = self:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	elseif item.equipLoc == "INVTYPE_WEAPON" or item.equipLoc == "INVTYPE_HOLDABLE" then
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = self:ApplyTemplateToDelta(item)
			elseif equippedItemLink == -1 then
				equippedItem = self:GetItemByLink(GearHelperVars.charInventory["MainHand"])
				result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			else
				equippedItem = self:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then
		if tonumber(equippedItems["MainHand"]) and tonumber(equippedItems["SecondaryHand"]) then
			result["MainHand"] = self:ApplyTemplateToDelta(item)
		elseif tonumber(equippedItems["MainHand"]) then
			equippedItem = self:GetItemByLink(equippedItems["SecondaryHand"])
			result["SecondaryHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
		elseif tonumber(equippedItems["SecondaryHand"]) then
			equippedItem = self:GetItemByLink(equippedItems["MainHand"])
			result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
		else
			local combinedItems = self:CombineTwoItems(self:GetItemByLink(equippedItems["MainHand"]), self:GetItemByLink(equippedItems["SecondaryHand"]))
			result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, combinedItems)
		end
	else
		-- TODO: Why is there a for loop ?
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then -- 0 if no item is equipped
				result[slot] = self:ApplyTemplateToDelta(item)
			else
				equippedItem = self:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	end

	return result
end
