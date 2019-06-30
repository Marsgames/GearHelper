local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local GHBenchmarkedFuncCount = {}
local BenchmarkMode = false

function GearHelper:ResetBenchmark(type)
	if type == "Count" then
		GHBenchmarkedFuncCount = {}
	end
end

function GearHelper:SwapBenchmarkMode()
	BenchmarkMode = not BenchmarkMode
end

function GearHelper:GetBenchmarkMode()
	return BenchmarkMode
end

function GearHelper:GetBenchmarkResult(type)
	if type == "Count" then
		return GHBenchmarkedFuncCount
	end
end

function GearHelper:BenchmarkCountFuncCall(funcName)
	if GearHelper:GetBenchmarkMode() == false then
		return
	end

	if GHBenchmarkedFuncCount[funcName] == nil then
		GHBenchmarkedFuncCount[funcName] = 0
	end

	GHBenchmarkedFuncCount[funcName] = GHBenchmarkedFuncCount[funcName] + 1
end

function GearHelper:Print(object)
	GearHelper:BenchmarkCountFuncCall("GearHelper:Print")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:SiObjetGris")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:IsEquippableByMe")
	local isEquippable = false

	if not IsEquippableItem(item.id) or string.match(item.itemLink, "battlepet") then
		return false
	end

	local myLevel = UnitLevel("player")
	local _, myClass = UnitClass("player")
	local playerSpec = GetSpecializationInfo(GetSpecialization())

	if item.levelRequired > myLevel or item.equipLoc == "INVTYPE_BAG" or item.equipLoc == "INVTYPE_TABARD" or item.equipLoc == "INVTYPE_BODY" then
		return false
	elseif item.equipLoc == "INVTYPE_FINGER" or item.equipLoc == "INVTYPE_NECK" or item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_CLOAK" and item.subType == L["divers"] or item.subType == L.IsEquipable.PRIEST.Tissu then
		isEquippable = true
	elseif item.rarity == "e6cc80" then
		if type(L.Artifact[tostring(playerSpec)]) == "string" then
			if tostring(item.id) == L.Artifact[tostring(playerSpec)] then
				isEquippable = true
			end
		else
			table.foreach(
				L.Artifact[tostring(playerSpec)],
				function(_, v)
					if tostring(item.id) == v then
						isEquippable = true
					end
				end
			)
		end
	else
		table.foreach(
			L.IsEquipable[tostring(myClass)],
			function(_, v)
				if item.subType == v then
					isEquippable = true
				end
			end
		)
	end
	return isEquippable
end

function GearHelper:IsInventoryInCache()
	GearHelper:BenchmarkCountFuncCall("GearHelper:IsInventoryInCache")
	local result = {}
	for _,v in pairs(GearHelperVars.charInventory) do
		if tonumber(v) == -2 then
			return false
		end
	end
	return true
end

-------------------------- C'EST LA MËME FONCTION QU'EN DESSOUS ?!
function GearHelper:IsInTable(array, data)
	GearHelper:BenchmarkCountFuncCall("GearHelper:IsInTable")
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
function GearHelper:IsValueInTable(tab, val)
	for _, v in pairs(tab) do
		if val == v then
			return true
		end
	end
	return false
end
-------------------------

function GearHelper:IsEmptyTable(maTable)
	GearHelper:BenchmarkCountFuncCall("GearHelper:IsEmptyTable")
	return (next(maTable) == nil)
end

function GearHelper:MySplit(inputString, separator)
	GearHelper:BenchmarkCountFuncCall("GearHelper:MySplit")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetStatDeltaBetweenItems")
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

local function AddStatToTab(item, tab)
	for k, v in pairs(item) do
		if tonumber(v) and k ~= "id" and k ~= "levelRequired" then
			if tab[k] == nil then 
				tab[k] = tonumber(v)
			else
				tab[k] = tonumber(v) + tonumber(tab[k])
			end
		end
	end

	return tab
end

function GearHelper:CombineTwoItems(first, second)
	GearHelper:BenchmarkCountFuncCall("GearHelper:CombineTwoItems")

	return AddStatToTab(second, AddStatToTab(first, {}))
end

local function CombineArraysOfEquippableTypes(arraysOfEquippableByClasses)
	local mergedArrays = {}
	for _, array in pairs(arraysOfEquippableByClasses) do
		for k, v in pairs(array) do
			mergedArrays[k] = v
		end
	end
	return mergedArrays
end

function GearHelper:GetEquippableTypes()
	return CombineArraysOfEquippableTypes(L.IsEquipable)
end

function GearHelper:GetGemValue()
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetGemValue")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:ReturnGoodLink")
	local itemString = select(3, strfind(itemLink, "|H(.+)|h"))
	local _, itemId = strsplit(":", itemString)

	if tar == nil then
		tar = ""
	end

	return "|HGHWhispWhenClick:askIfHeNeed_" .. target .. "_" .. itemId .. "_|h" .. tar .. "|h"
end

function GearHelper:CouleurClasse(classFileName)
	GearHelper:BenchmarkCountFuncCall("GearHelper:CouleurClasse")
	local color = RAID_CLASS_COLORS[classFileName]

	return "|c" .. color.colorStr
end

local function GetActiveTemplate()
	if GearHelper.db.profile.weightTemplate == "NOX" then
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		if GearHelper.db.global.templates[currentSpec]["NOX"] == nil then
			error(GHExceptionMissingNoxTemplate)
		end

		return GearHelper.db.global.templates[currentSpec]["NOX"]
	else
		if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate] ~= nil then
			error(GHExceptionMissingCustomTemplate)
		end

		return GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate]
	end
end

function GearHelper:FindHighestStatInTemplate()
	GearHelper:BenchmarkCountFuncCall("GearHelper:FindHighestStatInTemplate")

	local template = GetActiveTemplate()
	local maxV = 0
	local maxK = template[0]

	for k, v in pairs(template) do
		if tonumber(v) > maxV then
			maxV = v
			maxK = k
		end
	end

	return maxK
end

local function GetColor(name)
	GearHelper:BenchmarkCountFuncCall("GetColor")

	local colorList = {}
	colorList.yellow = "|cFFFFFF00"
	colorList.lightgreen = "|cFF00FF00"
	colorList.green = "|cFF1bad1b"
	colorList.lightred = "|cFFFF0000"
	colorList.red = "|cFFb51b1b"
	colorList.pink = "|cFFFF1493"
	colorList.better = "|cFF00FF96"
	colorList.white = "|cFFFFFFFF"
	colorList.black = "|cFF000000"

	return colorList[name:lower()]
end

function GearHelper:ColorizeString(text, color)
	GearHelper:BenchmarkCountFuncCall("GearHelper:ColorizeString")
	local colorList = {}
	colorList.yellow = "|cFFFFFF00"
	colorList.lightgreen = "|cFF00FF00"
	colorList.green = "|cFF1bad1b"
	colorList.lightred = "|cFFFF0000"
	colorList.red = "|cFFb51b1b"
	colorList.pink = "|cFFFF1493"
	colorList.better = "|cFF00FF96"
	colorList.white = "|cFFFFFFFF"
	colorList.black = "|cFF000000"

	if GetColor(color) ~= nil then
		return GetColor(color) .. text
	else
		return text
	end
end

function GearHelper:NormalizeWeightResult(result)
	GearHelper:BenchmarkCountFuncCall("GearHelper:NormalizeWeightResult")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:DoDisplayOverlay")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:parseID")
	local a = string.match(link, "item[%-?%d::]+")
	local b = string.sub(a, 5, 12)
	local c = string.gsub(b, ":", "")
	return c
end

function GearHelper:CountingSort(f)
	GearHelper:BenchmarkCountFuncCall("GearHelper:CountingSort")
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

function GearHelper:CountArray(tab)
	local count = 0
	for _,_ in pairs(tab) do
		count = count + 1
	end
	return count
end
