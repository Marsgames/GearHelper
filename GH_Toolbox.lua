local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:Print(object)
	if object ~= nil then
		if GearHelper.db.profile.debug and type(object) == "table" then
			foreach(object, print)
		elseif GearHelper.db.profile.debug then
			print(object)
		end
	else
		print(tostring(nil))
	end
end

function GearHelper:SiObjetGris(itemID)
	local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemID)
	local result = {}

	if itemRarity == 0 then
		table.insert(result, true)
		table.insert(result, itemSellPrice)
		return result
	else
		table.insert(result, false)
		table.insert(result, 0)
		return result
	end
end

function GearHelper:IsEquippableByMe(item)
	local isItMadeForMe = false

	if not IsEquippableItem(item.id) then
		return false
	end

	local myLevel = UnitLevel("player")
	local _, myClass = UnitClass("player")
	local currentSpec = GetSpecialization()
	local playerSpec = GetSpecializationInfo(currentSpec)

	if item.levelRequired > myLevel or item.equipLoc == "INVTYPE_BAG" then
		--Is it a common item shared by all classes ?
		isItMadeForMe = false
	elseif item.equipLoc == "INVTYPE_FINGER" or item.equipLoc == "INVTYPE_NECK" or item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_CLOAK" and item.subType == L["divers"] or item.subType == L.IsEquipable.PRIEST.Tissu then
		--Is it an artifact weapon ?
		isItMadeForMe = true
	elseif item.rarity == "e6cc80" then
		if type(L.Artifact[tostring(playerSpec)]) == "string" then
			if tostring(item.id) == L.Artifact[tostring(playerSpec)] then
				isItMadeForMe = true
			end
		else
			table.foreach(
				L.Artifact[tostring(playerSpec)],
				function(_, v)
					if tostring(item.id) == v then
						isItMadeForMe = true
					end
				end
			)
		end
	elseif item.equipLoc == "INVTYPE_TABARD" or item.equipLoc == "INVTYPE_BODY" then -- Do not consider as equippable because they have no stats and we dont store them in charInventory
		isItMadeForMe = false
	else
		--Is it an item that i can equip with my character ?
		table.foreach(
			L.IsEquipable[tostring(myClass)],
			function(_, v)
				if item.subType == v then
					isItMadeForMe = true
				end
			end
		)
	end
	return isItMadeForMe
end

function GearHelper:IsSlotEmpty(equipLoc)
	local result = {}
	if equipLoc == "INVTYPE_TRINKET" then
		--Item not cached yet
		if GearHelper.charInventory["Trinket0"] == -2 or GearHelper.charInventory["Trinket1"] == -2 then
			return nil
		end

		if GearHelper.charInventory["Trinket0"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["Trinket1"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	elseif equipLoc == "INVTYPE_FINGER" then
		--Item not cached yet
		if GearHelper.charInventory["Finger0"] == -2 or GearHelper.charInventory["Finger1"] == -2 then
			return nil
		end
		if GearHelper.charInventory["Finger0"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["Finger1"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	elseif equipLoc == "INVTYPE_WEAPON" then
		if GearHelper.charInventory["MainHand"] == -2 or GearHelper.charInventory["SecondaryHand"] == -2 then
			return nil
		end

		if GearHelper.charInventory["MainHand"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["SecondaryHand"] == 0 or GearHelper.charInventory["SecondaryHand"] == -1 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	elseif equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_2HWEAPON" then
		--Item not cached yet
		if GearHelper.charInventory["MainHand"] == -2 or GearHelper.charInventory["SecondaryHand"] == -2 then
			return nil
		end
		--If MainHand is empty
		if GearHelper.charInventory["MainHand"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["SecondaryHand"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	else
		--Item not cached yet
		if GearHelper.charInventory[GearHelper.itemSlot[equipLoc]] == -2 then
			return nil
		end

		if GearHelper.charInventory[GearHelper.itemSlot[equipLoc]] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	end
	return result
end

function GearHelper:IsInTable(array, data)
	local result = false
	table.foreach(
		array,
		function(k, _)
			local ret = strmatch(array[k], data)
			if ret ~= nil then
				result = true
			end
		end
	)
	return result
end

function GearHelper:IsEmptyTable(maTable)
	return (next(maTable) == nil)
end

function GearHelper:MySplit(inputString, separator)
	if separator == nil then
		separator = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function GearHelper:GetStatDeltaBetweenItems(looted, equipped)
	local delta = {}

	for k, v in pairs(looted) do
		if tonumber(v) and k ~= "id" and k ~= "levelRequired" then
			if equipped[k] == nil then --If looted item contain stat that are not on equipped item
				delta[k] = tonumber(v)
			else
				delta[k] = tonumber(v) - tonumber(equipped[k])
			end
		end
	end

	--We find stat that looted item doesn't have compared to equipped item
	for k, v in pairs(equipped) do
		if tonumber(v) and k ~= "id" and k ~= "levelRequired" then
			if looted[k] == nil then
				delta[k] = tonumber(v) * (-1)
			end
		end
	end
	return delta
end

function GearHelper:GetGemValue()
	local _, gemItemLink = GetItemInfo("151585")
	if gemItemLink == nil then
		return 0
	end
	local tip = ""

	tip = myTooltipFromTemplate or CreateFrame("GAMETOOLTIP", "myTooltipFromTemplate", nil, "GameTooltipTemplate")
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")
	tip:SetHyperlink(gemItemLink)

	for i = 1, tip:NumLines() do
		local line = _G["myTooltipFromTemplateTextLeft" .. i]
		local text = line:GetText()
		if text then
			if string.match(text, "%+%d+") then
				return tonumber(string.match(text, "%d+"))
			end
		end
	end
end

function GearHelper:ReturnGoodLink(itemLink, target, tar)
	local itemString = select(3, strfind(itemLink, "|H(.+)|h"))
	local _, itemId = strsplit(":", itemString)

	if tar == nil then
		tar = ""
	end

	return "|HGHWhispWhenClick:askIfHeNeed_" .. target .. "_" .. itemId .. "_|h" .. tar .. "|h"
end

function GearHelper:CouleurClasse(classFileName)
	local color = RAID_CLASS_COLORS[classFileName]

	return "|c" .. color.colorStr
end

function GearHelper:FindHighestStatInTemplate()
	if GearHelper.db.profile.weightTemplate == "NOX" then
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		if GearHelper.db.global.templates[currentSpec]["NOX"] ~= nil then
			local maxV = 0
			local maxK = "Nothing"
			for k, v in pairs(GearHelper.db.global.templates[currentSpec]["NOX"]) do
				if tonumber(v) > maxV then
					maxV = v
					maxK = k
				end
			end

			return maxK
		else
			return nil
		end
	else
		if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate] ~= nil then
			local maxV = 0
			local maxK = "Nothing"
			for k, v in pairs(GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate]) do
				if tonumber(v) then
					if v > maxV then
						maxV = v
						maxK = k
					end
				end
			end

			return maxK
		else
			return nil
		end
	end
end

function GearHelper:ColorizeString(text, color)
	local colorList = {}
	colorList.jaune = "|cFFFFFF00"
	colorList.vert = "|cFF00FF00"
	colorList.vertfonce = "|cFF1bad1b"
	colorList.rouge = "|cFFFF0000"
	colorList.rougefonce = "|cFFb51b1b"
	colorList.rose = "|cFFFF1493"
	colorList.mieux = "|cFF00FF96"
	colorList.blanc = "|cFFFFFFFF"
	colorList.noir = "|cFF000000"

	if colorList[color:lower()] ~= nil then
		return colorList[color:lower()] .. text
	else
		return text
	end
end

function GearHelper:NormalizeWeightResult(result)
	-- -10 not adapted (no stat in template)
	-- -20 not equippable
	-- -30 item worst than equipped one
	-- -40 nil
	-- -50 if better than nothing
	-- 0 item equal
	-- + the value for a better item
	local resultList = {}
	resultList["notAdapted"] = -10
	resultList["notEquippable"] = -20
	resultList["worstThanEquipped"] = -30
	resultList["nil"] = -40
	resultList["betterThanNothing"] = -50
	resultList["alreadyEquipped"] = -60
	if result == nil then
		return {resultList["nil"]}
	end

	for k, v in pairs(result) do
		if type(v) == "number" then
			if v < 0 then
				result[k] = resultList["worstThanEquipped"]
			end
		elseif type(v) == "string" then
			if resultList[v] ~= nil then
				result[k] = resultList[v]
			end
		end
	end
	return result
end

function GearHelper:DoDisplayOverlay(result)
	local doDisplay = {-50}
	local displayOverlay = false
	for _, v in pairs(result) do
		for _, y in pairs(doDisplay) do
			if v == y or v > 0 then
				displayOverlay = true
			end
		end
	end
	return displayOverlay
end

function GearHelper:parseID(link)
	local a = string.match(link, "item[%-?%d::]+")
	local b = string.sub(a, 5, 12)
	local c = string.gsub(b, ":", "")
	return c
end

function GearHelper:CountingSort(f)
	local min, max = math.min(unpack(f)), math.max(unpack(f))
	local count = {}
	for i = min, max do
		count[i] = 0
	end

	for i = 1, #f do
		count[f[i]] = count[f[i]] + 1
	end

	local z = 1
	for i = min, max do
		while count[i] > 0 do
			f[z] = i
			z = z + 1
			count[i] = count[i] - 1
		end
	end
end
