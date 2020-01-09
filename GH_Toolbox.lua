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
	if (false == GearHelper:GetBenchmarkMode()) then
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

function GearHelper:GetItemSellPrice(itemID)
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetItemSellPrice")
	local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemID)

	if itemRarity == 0 then
		return true, itemSellPrice
	else
		return false, 0
	end
end

-- TODO: Rework this function
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
	elseif item.equipLoc == "INVTYPE_FINGER" or item.equipLoc == "INVTYPE_NECK" or item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_CLOAK" and item.subType == L["divers"] or item.subType == L.IsEquippable.PRIEST.Tissu then
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
			L.IsEquippable[tostring(myClass)],
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
	for _, v in pairs(GearHelperVars.charInventory) do
		if tonumber(v) == -2 then
			return false
		end
	end
	return true
end

-- TODO: Replace that by @Marsgames suggestion about = true test
function GearHelper:IsValueInTable(tab, val)
	GearHelper:BenchmarkCountFuncCall("GearHelper:IsValueInTable")

	for _, v in pairs(tab) do
		if val == v then
			return true
		end
	end
	return false
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:AddStatToTab")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:CombineArraysOfEquippableTypes")
	local mergedArrays = {}
	for _, array in pairs(arraysOfEquippableByClasses) do
		for k, v in pairs(array) do
			mergedArrays[k] = v
		end
	end
	return mergedArrays
end

function GearHelper:GetEquippableTypes()
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetEquippableTypes")
	return CombineArraysOfEquippableTypes(L.IsEquippable)
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

function GearHelper:GetClassColor(classFileName)
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetClassColor")
	local color = RAID_CLASS_COLORS[classFileName]

	return "|c" .. color.colorStr
end

local function GetActiveTemplate()
	local returnValue

	-- Can occurs if you select CustomTemplate but you did not set a template
	if (nil == GearHelper.db.profile.weightTemplate or "" == GearHelper.db.profile.weightTemplate) then
		GearHelper.db.profile.weightTemplate = "NOX"
	end

	if GearHelper.db.profile.weightTemplate == "NOX" or GearHelper.db.profile.weightTemplate == "NOX_ByDefault" then
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		if GearHelper.db.global.templates[currentSpec]["NOX"] == nil then
			-- TODO: Do all the exceptions
			error(GHExceptionMissingNoxTemplate)
		end

		returnValue = GearHelper.db.global.templates[currentSpec]["NOX"]
	else
		if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate] ~= nil then
			error(GHExceptionMissingCustomTemplate)
		end

		returnValue = GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate]
	end

	return returnValue
end

function GearHelper:FindHighestStatInTemplate()
	GearHelper:BenchmarkCountFuncCall("GearHelper:FindHighestStatInTemplate")

	local template = GetActiveTemplate()

	if (nil == template) then
		error(GHExceptionTemplateIsNil)
	end

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

function GearHelper:GetArraySize(tab)
	if (type(tab) ~= "table") then
		error(GHExceptionParameterIsNotAnArray)
	end

	local count = 0
	for _, _ in pairs(tab) do
		count = count + 1
	end

	return count
end
