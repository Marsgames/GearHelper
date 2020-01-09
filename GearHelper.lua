-- https://mothereff.in/lua-minifier
-- Memory footprint 12048.4 k
-- TODO extract player inventory related function to an independant lib
-- TODO Move functions in split files
-- TODO check war item SetHyperlink in tooltip fail
-- TODO Expose more options to player
-- TODO: Repair GH :
-- 			- Quand on n'active pas le calcul d'ilvl, rien ne semble fonctionner correctement
--			- La prise en compte des châsses ne semble pas changer grand chose

-- #errors : 01

--{{ Global Vars }}
GearHelperVars = {
	version = GetAddOnMetadata("GearHelper", "Version"),
	prefixAddon = "GeARHeLPeRPReFIX",
	addonTruncatedVersion = 2,
	waitSpeFrame = CreateFrame("Frame"),
	waitSpeTimer = nil,
	charInventory = {}
}

--{{ Local Vars }}
local allPrefix = {["askVersion" .. GearHelperVars.prefixAddon] = sendAnswerVersion, ["answerVersion" .. GearHelperVars.prefixAddon] = receiveAnswer}
local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")
local delaySpeTimer = 0.5
local delayNilTimer = 10
local waitAnswerFrame = CreateFrame("Frame")
local askTime, maxWaitTime = nil, 15
local waitNilFrame = CreateFrame("Frame")
local waitNilTimer = nil
local updateAddonReminderCount = 3
local defaultsOptions = {
	profile = {
		addonEnabled = true,
		sellGreyItems = true,
		autoAcceptQuestReward = false,
		autoEquipLooted = {
			actual = false,
			previous = false
		},
		autoEquipWhenSwitchSpe = false,
		weightTemplate = "NOX",
		lastWeightTemplate = "",
		autoRepair = 0,
		autoInvite = true,
		autoTell = true,
		inviteMessage = "+GH123-",
		askLootRaid = true,
		printWhenEquip = true,
		debug = false,
		CW = {},
		iLvlOption = false,
		iLvlWeight = 10,
		includeSocketInCompute = true,
		computeNotEquippable = true,
		whisperAlert = true,
		sayMyName = true,
		minimap = {hide = false, isLock = false},
		bossesKilled = true,
		ilvlCharFrame = true,
		ilvlInspectFrame = true,
		inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil},
		defaultWeightForStat = 1
	},
	global = {
		ItemCache = {},
		itemWaitList = {},
		myNames = "",
		buildVersion = 7,
		equipLocInspect = {}
	}
}
waitAnswerFrame:Hide()
GearHelperVars.waitSpeFrame:Hide()
waitNilFrame:Hide()

function GearHelper:OnInitialize()
	GearHelper:BenchmarkCountFuncCall("GearHelper:OnInitialize")
	self.db = LibStub("AceDB-3.0"):New("GearHelperDB", defaultsOptions)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetConfig")
	self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

	GearHelper:CreateMinimapIcon()
end

function GearHelper:RefreshConfig()
	GearHelper:BenchmarkCountFuncCall("GearHelper:RefreshConfig")
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

local function nilTableValues(tableToReset)
	GearHelper:BenchmarkCountFuncCall("nilTableValues")
	for key, v in pairs(tableToReset) do
		if type(tableToReset[key]) == "table" then
			nilTableValues(tableToReset[key])
		else
			tableToReset[key] = nil
		end
	end
end

function GearHelper:ResetConfig()
	self:BenchmarkCountFuncCall("GearHelper:ResetConfig")
	nilTableValues(self.db.profile)
	nilTableValues(self.db.global)

	InterfaceOptionsFrame:Hide()
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:OnEnable()
	self:BenchmarkCountFuncCall("GearHelper:OnEnable")
	if not self.db.profile.addonEnabled then
		print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["DeactivatedRed"], "LightRed"))
		return
	end

	print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["ActivatedGreen"], "LightGreen"))
	self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
	if (#self.db.global.equipLocInspect == 0) then
		InitEquipLocInspect()
	end
end

function GearHelper:setDefault()
	self:BenchmarkCountFuncCall("GearHelper:setDefault")
	self.db = nil
	ReloadUI()
end

function GearHelper:setInviteMessage(newMessage)
	self:BenchmarkCountFuncCall("GearHelper:setInviteMessage")
	if newMessage == nil then
		return
	end

	self.db.profile.inviteMessage = tostring(newMessage)
	print(L["InviteMessage"] .. tostring(self.db.profile.inviteMessage))
end

function GearHelper:showMessageSMN(channel, sender, msg)
	self:BenchmarkCountFuncCall("GearHelper:showMessageSMN")
	if not self.db.profile.sayMyName or not msg then
		return
	end

	local stop = false
	local arrayNames = self:MySplit(self.db.global.myNames, ",")
	if arrayNames[1] == nil then
		return
	end

	local i = 1
	while (not stop and arrayNames[i]) do
		if (string.match(msg:lower(), arrayNames[i]:lower())) then
			UIErrorsFrame:AddMessage(channel .. " [" .. sender .. "]: " .. msg, 0.0, 1.0, 0.0, 5.0, 4)
			PlaySound(5275, "Master")
			stop = true
			return
		end
		i = i + 1
	end
end

function GearHelper:setMyNames(name)
	self:BenchmarkCountFuncCall("GearHelper:setMyNames")
	if not name then
		return
	end

	self.db.global.myNames = tostring(name .. ",")
end

function GearHelper:sendAskVersion()
	self:BenchmarkCountFuncCall("GearHelper:sendAskVersion")
	if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "askVersion;" .. GearHelperVars.version, "RAID")
	end
	if IsInGuild() ~= nil and IsInGuild() == true then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "askVersion;" .. GearHelperVars.version, "GUILD")
	end

	askTime = time()
	waitAnswerFrame:Show()
end

function GearHelper:sendAnswerVersion()
	self:BenchmarkCountFuncCall("GearHelper:sendAnswerVersion")
	if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "RAID")
	end
	if IsInGuild() ~= nil and IsInGuild() == true then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "GUILD")
	end
end

function GearHelper:receiveAnswer(msgV, msgC)
	self:BenchmarkCountFuncCall("GearHelper:receiveAnswer")
	if not askTime or updateAddonReminderCount <= 0 or tonumber(msgV) ~= nil and tonumber(msgV) <= GearHelperVars.addonTruncatedVersion then
		return
	end

	message(L["maj1"] .. self:ColorizeString(GearHelperVars.version, "LightRed") .. L["maj2"] .. self:ColorizeString(msgV, "LightGreen") .. L["maj3"] .. msgC .. " (Curse)")
	askTime = nil
	waitAnswerFrame:Hide()
	updateAddonReminderCount = updateAddonReminderCount - 1
end

local function computeAskTime(frame, elapsed)
	GearHelper:BenchmarkCountFuncCall("computeAskTime")
	if not askTime or (time() - askTime) <= maxWaitTime then
		return
	end
	askTime = nil
	frame:Hide()
end
waitAnswerFrame:SetScript("OnUpdate", computeAskTime)

local function delayBetweenEquip(frame)
	GearHelper:BenchmarkCountFuncCall("delayBetweenEquip")
	if time() <= GearHelperVars.waitSpeTimer + delaySpeTimer then
		return
	end
	for bag = 0, 4 do
		numBag = bag
		GearHelper:equipItem()
	end
	frame:Hide()
end
GearHelperVars.waitSpeFrame:SetScript("OnUpdate", delayBetweenEquip)

local function delayNilFrame(frame)
	GearHelper:BenchmarkCountFuncCall("delayNilFrame")
	if time() <= waitNilTimer + delayNilTimer then
		do
			return
		end
	end
	setDefault()
	frame:Hide()
end
waitNilFrame:SetScript("OnUpdate", delayNilFrame)

function GearHelper:GetEquippedItemLink(slotID, slotName)
	self:BenchmarkCountFuncCall("GearHelper:GetEquippedItemLink")
	local itemLink = GetInventoryItemLink("player", slotID)
	local itemID = GetInventoryItemID("player", slotID)
	local itemName

	if not itemID then
		return 0
	end

	if itemLink then
		_, itemName = itemLink:match("|H(.*)|h%[(.*)%]|h")
	end

	if not itemName or itemName == "" then
		GetItemInfo(itemID)
		self.db.global.itemWaitList[itemID] = slotName
		return -2
	else
		return itemLink
	end
end

function GearHelper:ScanCharacter()
	self:BenchmarkCountFuncCall("GearHelper:ScanCharacter")
	GearHelperVars.charInventory["Head"] = self:GetEquippedItemLink(GetInventorySlotInfo("HeadSlot"), "HeadSlot")
	GearHelperVars.charInventory["Neck"] = self:GetEquippedItemLink(GetInventorySlotInfo("NeckSlot"), "NeckSlot")
	GearHelperVars.charInventory["Shoulder"] = self:GetEquippedItemLink(GetInventorySlotInfo("ShoulderSlot"), "ShoulderSlot")
	GearHelperVars.charInventory["Back"] = self:GetEquippedItemLink(GetInventorySlotInfo("BackSlot"), "BackSlot")
	GearHelperVars.charInventory["Chest"] = self:GetEquippedItemLink(GetInventorySlotInfo("ChestSlot"), "ChestSlot")
	GearHelperVars.charInventory["Wrist"] = self:GetEquippedItemLink(GetInventorySlotInfo("WristSlot"), "WristSlot")
	GearHelperVars.charInventory["Hands"] = self:GetEquippedItemLink(GetInventorySlotInfo("HandsSlot"), "HandsSlot")
	GearHelperVars.charInventory["Waist"] = self:GetEquippedItemLink(GetInventorySlotInfo("WaistSlot"), "WaistSlot")
	GearHelperVars.charInventory["Legs"] = self:GetEquippedItemLink(GetInventorySlotInfo("LegsSlot"), "LegsSlot")
	GearHelperVars.charInventory["Feet"] = self:GetEquippedItemLink(GetInventorySlotInfo("FeetSlot"), "FeetSlot")
	GearHelperVars.charInventory["Finger0"] = self:GetEquippedItemLink(GetInventorySlotInfo("Finger0Slot"), "Finger0Slot")
	GearHelperVars.charInventory["Finger1"] = self:GetEquippedItemLink(GetInventorySlotInfo("Finger1Slot"), "Finger1Slot")
	GearHelperVars.charInventory["Trinket0"] = self:GetEquippedItemLink(GetInventorySlotInfo("Trinket0Slot"), "Trinket0Slot")
	GearHelperVars.charInventory["Trinket1"] = self:GetEquippedItemLink(GetInventorySlotInfo("Trinket1Slot"), "Trinket1Slot")
	GearHelperVars.charInventory["MainHand"] = self:GetEquippedItemLink(GetInventorySlotInfo("MainHandSlot"), "MainHandSlot")
	GearHelperVars.charInventory["SecondaryHand"] = self:GetEquippedItemLink(GetInventorySlotInfo("SecondaryHandSlot"), "SecondaryHandSlot")

	if GearHelperVars.charInventory["MainHand"] ~= -2 and GearHelperVars.charInventory["MainHand"] ~= 0 then
		-- TODO: Why doesn't we use GH:GetItemInfo ?
		local _, _, _, itemEquipLocWeapon = GetItemInfoInstant(GearHelperVars.charInventory["MainHand"])

		if string.match(itemEquipLocWeapon, "INVTYPE_2HWEAPON") or string.match(itemEquipLocWeapon, "INVTYPE_RANGED") then
			GearHelperVars.charInventory["SecondaryHand"] = -1
		end
	end
end

function GearHelper:poseDot()
	self:BenchmarkCountFuncCall("GearHelper:poseDot")
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local myBag = bag + 1
			local mySlot = GetContainerNumSlots(bag) - (slot - 1)
			local button = _G["ContainerFrame" .. myBag .. "Item" .. mySlot]
			local itemLink = GetContainerItemLink(bag, slot)

			if button.overlay then
				button.overlay:SetShown(false)
				button.overlay = nil
			end

			if itemLink and self:IsItemBetter(itemLink) and not button.overlay then
				button.overlay = button:CreateTexture(nil, "OVERLAY")
				button.overlay:SetSize(18, 18)
				button.overlay:SetPoint("TOPLEFT")
				button.overlay:SetTexture("Interface\\AddOns\\GearHelper\\Textures\\flecheUp")
				button.overlay:SetShown(true)
			end
		end
	end
	ContainerFrame_UpdateAll()
end

local function GetStatFromTemplate(stat)
	GearHelper:BenchmarkCountFuncCall("GetStatFromTemplate")
	if (nil == GearHelper.db.profile.weightTemplate) then
		GearHelper:Print("WeightTemplate was nil, new value is NOX")
		GearHelper.db.profile.weightTemplate = "NOX"
	end

	if (GearHelper.db.profile.weightTemplate == "NOX" or GearHelper.db.profile.weightTemplate == "NOX_ByDefault") then
		-- Afficher le contenu pour voir
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		if GearHelper.db.global.templates[currentSpec]["NOX"][stat] ~= nil then
			return GearHelper.db.global.templates[currentSpec]["NOX"][stat]
		end
	else
		if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate][stat] ~= nil then
			return GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate][stat]
		end
	end
end

local function ApplyTemplateToDelta(delta)
	GearHelper:BenchmarkCountFuncCall("ApplyTemplateToDelta")
	local valueItem = 0
	local mainStat = GearHelper:FindHighestStatInTemplate()

	-- TODO: Check the GetGemValue() function
	if GearHelper.db.profile.includeSocketInCompute == true then
		valueItem = delta.nbGem * GearHelper:GetGemValue() * GetStatFromTemplate(mainStat)
	end

	if GearHelper.db.profile.iLvlOption == true then
		if (GearHelper.db.profile.iLvlWeight == nil or GearHelper.db.profile.iLvlWeight == "") then
			GearHelper.db.profile.iLvlWeight = 10
		end

		valueItem = valueItem + delta.iLvl * GearHelper.db.profile.iLvlWeight
	end

	for k, v in pairs(delta) do
		if (k ~= nil and v ~= nil and L.Tooltip.Stat[k] ~= nil) then -- or v < 0) then
			if (GetStatFromTemplate(k) ~= nil and GetStatFromTemplate(k) ~= 0) then
				valueItem = valueItem + GetStatFromTemplate(k) * v
			else
				if (GearHelper.db.profile.defaultWeightForStat == nil) then
					error(GHExceptionMissingDefaultWeight)
					return
				else
					valueItem = valueItem + GearHelper.db.profile.defaultWeightForStat * v
				end
			end
		end
	end

	return valueItem
end

local function GetSlotsByEquipLoc(equipLoc)
	GearHelper:BenchmarkCountFuncCall("GetSlotsByEquipLoc")
	local equipSlot = {}

	if equipLoc == "INVTYPE_WEAPON" then
		local _, myClass = UnitClass("player")
		local playerSpec = GetSpecializationInfo(GetSpecialization())
		local equipLocByClass = GearHelper.itemSlot[equipLoc][myClass]

		if equipLocByClass[tostring(playerSpec)] == nil then
			equipSlot = equipLocByClass
		else
			equipSlot = equipLocByClass[tostring(playerSpec)]
		end
	else
		equipSlot = GearHelper.itemSlot[equipLoc]
	end

	return equipSlot
end

local function GetItemsByEquipLoc(equipLoc)
	GearHelper:BenchmarkCountFuncCall("GetItemsByEquipLoc")
	local result = {}
	local equipSlot = GetSlotsByEquipLoc(equipLoc)

	-- TODO: si on remplace ça par Result[v] = true, on peut faire une recherche dans la table avec un if (Result[v]) then, ce qui evite de faire un foreach avec la fonction IsValueInTablr
	for k, v in ipairs(equipSlot) do
		result[v] = GearHelperVars.charInventory[v]
	end

	return result
end

local function ShouldDisplayNotEquippable(subType)
	GearHelper:BenchmarkCountFuncCall("ShouldDisplayNotEquippable")

	if (GearHelper:IsValueInTable(L["TypeToNotNeed"], subType)) then
		return false
	end

	if GearHelper.db.profile.computeNotEquippable == true then
		return GearHelper:IsValueInTable(GearHelper:GetEquippableTypes(), tostring(subType))
	end

	return false
end

local function ShouldBeCompared(itemLink)
	GearHelper:BenchmarkCountFuncCall("ShouldBeCompared")

	if not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r") then
		error(GHExceptionInvalidItemLink)
	end

	local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

	if IsEquippedItem(id) then
		error(GHExceptionAlreadyEquipped)
	end

	if not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink)) then
		error(GHExceptionNotEquippable)
	end

	return true
end

function GearHelper:IsItemBetter(itemLink)
	self:BenchmarkCountFuncCall("GearHelper:IsItemBetter")
	local item = {}
	local itemEquipped = nil
	local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

	local shouldBeCompared, err = pcall(ShouldBeCompared, itemLink)
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

-- TODO: this function only return gems if there are on the item ?!
local function GetNumberOfGemsFromTooltip()
	GearHelper:BenchmarkCountFuncCall("GetNumberOfGemsFromTooltip")
	local n = 0
	local textures = {}

	for i = 1, 10 do
		textures[i] = _G["GameTooltipTexture" .. i]
	end

	for i = 1, 10 do
		if textures[i]:IsShown() then
			n = n + 1
		end
	end

	-- GearHelper:Print("Test nb of gems : " .. n)
	return tonumber(n)
end

function GearHelper:BuildItemFromTooltip(itemLink)
	self:BenchmarkCountFuncCall("GearHelper:BuildItemFromTooltip")
	local tip = ""
	local item = {}

	if not itemLink or itemLink == -1 then
		error(GHExceptionInvalidItemLink)
		return
	end

	if string.find(itemLink, L["mascotte"]) then
		error(GHExceptionInvalidItem)
		return
	end

	tip = myTooltipFromTemplate or CreateFrame("GAMETOOLTIP", "myTooltipFromTemplate", nil, "GameTooltipTemplate")
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")

	tip:SetHyperlink(itemLink)

	item.levelRequired = 0
	_, item.itemLink = tip:GetItem()
	item.itemString = string.match(item.itemLink, "item[%-?%d:]+")
	_, _, item.rarity = string.find(item.itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	item.id, item.type, item.subType, item.equipLoc = GetItemInfoInstant(item.itemLink)
	item.name = _G["GameTooltipTextLeft1"]:GetText()
	if GetItemInfo(item.itemLink) then
		_, _, _, _, _, _, _, _, _, _, item.sellPrice = GetItemInfo(item.itemLink)
	end

	item.nbGem = GetNumberOfGemsFromTooltip()

	for i = 2, tip:NumLines() do
		local text = _G["myTooltipFromTemplateTextLeft" .. i]:GetText()

		if text then
			if string.find(text, L["Tooltip"].ItemLevel) then
				for word in string.gmatch(text, "(%d+)") do
					item.iLvl = tonumber(word)
				end
			elseif string.find(text, L["Tooltip"].LevelRequired) then
				item.levelRequired = tonumber(string.match(text, "%d+"))
			elseif string.find(text, L["Tooltip"].BonusGem) then
				for k, v in pairs(L["Tooltip"].Stat) do
					if string.find(string.match(text, "%+(.*)"), v) then
						item.bonusGem = {}
						item.bonusGem[k] = (string.gsub(text, "%D+", ""))
					end
				end
			else
				for k, v in pairs(L["Tooltip"].Stat) do
					if string.find(text, v) and not string.match(text, "%:") then
						item[k] = tonumber((string.gsub(text, "%D+", "")))
					end
				end
			end
		end
	end

	return item
end

function GearHelper:GetItemFromCache(itemLink)
	self:BenchmarkCountFuncCall("GearHelper:GetItemFromCache")
	for k, v in pairs(self.db.global.ItemCache) do
		if k == itemLink then
			return v
		end
	end
	return nil
end

function GearHelper:PutItemInCache(itemLink, item)
	self:BenchmarkCountFuncCall("GearHelper:PutItemInCache")
	self.db.global.ItemCache[itemLink] = item
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

local function ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
	GearHelper:BenchmarkCountFuncCall("ComputeWithTemplateDeltaBetweenItems")
	local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)

	return ApplyTemplateToDelta(delta)
end

function GearHelper:NewWeightCalculation(item)
	self:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")

	local result = {}

	if self:IsInventoryInCache() == false then
		error(GHExceptionInventoryNotCached)
	end

	local equippedItems = GetItemsByEquipLoc(item.equipLoc)

	if item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_FINGER" then
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = ApplyTemplateToDelta(item)
			else
				equippedItem = self:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	elseif item.equipLoc == "INVTYPE_WEAPON" or item.equipLoc == "INVTYPE_HOLDABLE" then
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = ApplyTemplateToDelta(item)
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
			result["MainHand"] = ApplyTemplateToDelta(item)
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
				result[slot] = ApplyTemplateToDelta(item)
			else
				equippedItem = self:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	end

	return result
end

-- TODO: Rework this function
function GearHelper:equipItem(inThisBag)
	self:BenchmarkCountFuncCall("GearHelper:equipItem")
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
				if pcall(ShouldBeCompared, itemLink) then
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

local function GetQualityFromColor(color)
	GearHelper:BenchmarkCountFuncCall("GetQualityFromColor")
	if (color == "9d9d9d") then
		return 0
	elseif (color == "ffffff") then
		return 1
	elseif (color == "1eff00") then
		return 2
	elseif (color == "0070dd") then
		return 3
	elseif (color == "a335ee") then
		return 4
	elseif (color == "ff8000") then
		return 5
	elseif (color == "e6cc80") then
		return 6
	elseif (color == "00ccff") then
		return 7
	else
		error("Color " .. color .. " is not a possible choice")
	end
end

local function IsTargetValid(target)
	if nil == target or "" == target or string.find(target, GetUnitName("player")) then
		return false
	end

	return true
end

function GearHelper:CreateLinkAskIfHeNeeds(debug, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
	self:BenchmarkCountFuncCall("GearHelper:CreateLinkAskIfHeNeeds")
	local message = message or "|cff1eff00|Hitem:13262::::::::100:105::::::|h[Porte-cendres ma Gueule]|h|r"
	local target = target or GetUnitName("player")

	if not self.db.profile.askLootRaid or not IsTargetValid(target) or string.find(string.lower(message), "bonus") then
		return
	end

	local couleur, tar = ""
	local _, classFile = UnitClass(target)
	local tar = ""

	if classFile ~= nil then
		tar = self:GetClassColor(classFile) .. tostring(target) .. "|r"
	end

	local nameLink

	local OldSetItemRef = SetItemRef
	function SetItemRef(link, text, button, chatFrame)
		self:BenchmarkCountFuncCall("SetItemRef")
		local func = strmatch(link, "^GHWhispWhenClick:(%a+)")
		if func == "askIfHeNeed" then
			local _, nomPerso, itID, persoLink = strsplit("_", link)
			local _, theItemLink = GetItemInfo(itID)
			local itemTable = self:GetItemByLink(theItemLink)
			local itLink1 = itemTable.itemLink

			self:askIfHeNeed(itLink1, nomPerso)
		else
			OldSetItemRef(link, text, button, chatFrame)
		end
	end

	for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
		if pcall(ShouldBeCompared, itemLink) then
			local item = self:GetItemByLink(itemLink)
			local quality = GetQualityFromColor(item.rarity)

			if quality ~= nil and quality < 5 then
				nameLink = self:ReturnGoodLink(itemLink, target, tar)

				if self:IsItemBetter(itemLink) then
					UIErrorsFrame:AddMessage(self:ColorizeString(L["ask1"], "Yellow") .. nameLink .. self:ColorizeString(L["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0, 80)
					print(self:ColorizeString(L["ask1"], "Yellow") .. nameLink .. self:ColorizeString(L["ask2"], "Yellow") .. itemLink)
					PlaySound(5274, "Master")
				end
			end
		end
	end
end

function GearHelper:LinesToAddToTooltip(result)
	self:BenchmarkCountFuncCall("GearHelper:LinesToAddToTooltip")
	local linesToAdd = {}

	if self:GetArraySize(result) == 1 then
		for _, v in pairs(result) do
			local flooredValue = math.floor(v)
			if (flooredValue < 0) then
				table.insert(linesToAdd, self:ColorizeString(L["itemLessThanGeneral"], "LightRed"))
			elseif (flooredValue > 0) then
				table.insert(linesToAdd, self:ColorizeString(L["itemBetterThanGeneral"], "Better") .. flooredValue)
			else
				table.insert(linesToAdd, L["itemEgal"])
			end
		end
	elseif self:GetArraySize(result) == 2 then
		for slot, weight in pairs(result) do
			local slotId = GetInventorySlotInfo(slot .. "Slot")
			local itemLink = self:GetEquippedItemLink(slotId, slot)

			local flooredValue = math.floor(weight)
			if (flooredValue < 0) then
				table.insert(linesToAdd, self:ColorizeString(L["itemLessThan"], "LightRed") .. " " .. itemLink)
			elseif (flooredValue > 0) then
				table.insert(linesToAdd, self:ColorizeString(L["itemBetterThan"], "Better") .. " " .. itemLink .. " " .. self:ColorizeString(L["itemBetterThan2"], "Better") .. flooredValue)
			else
				table.insert(linesToAdd, L["itemEgala"] .. " " .. itemLink)
			end
		end
	end
	return linesToAdd
end

local function GetDropInfo(linesToAdd, itemLink)
	GearHelper:BenchmarkCountFuncCall("GetDropInfo")
	local _, _, _, _, itemId = string.find(tostring(itemLink), "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	if GearHelper.itemsDropRate[itemId] ~= nil then
		table.insert(linesToAdd, L["DropRate"] .. GearHelper.itemsDropRate[itemId]["Rate"] .. "%")
		if GearHelper.itemsDropRate[itemId]["Zone"] ~= "" then
			table.insert(linesToAdd, L["DropZone"] .. GearHelper.itemsDropRate[itemId]["Zone"])
		end
		table.insert(linesToAdd, L["DropBy"] .. GearHelper.itemsDropRate[itemId]["Drop"])
	end
end

local ModifyTooltip = function(self, ...)
	-- local pCallWorked, err = pcall(anyFunction) 	-- if no error : pCallWorked == true and err == nil
	--												-- if error : pCallWorked == false and err == "some error"
	if not GearHelper.db or not GearHelper.db.profile.addonEnabled then
		return
	end

	local _, itemLink = self:GetItem()
	local shouldBeCompared, err = pcall(ShouldBeCompared, itemLink)
	local linesToAdd = {}
	local isItemEquipped = IsEquippedItem(itemLink)

	if (not isItemEquipped) then
		if (not shouldBeCompared) then
			if (string.find(tostring(err), GHExceptionNotEquippable)) then
				-- Show message only on equippable items
				local item = GearHelper:GetItemByLink(itemLink)

				-- print("subtype : " .. tostring(item.subType))
				if (IsEquippableItem(itemLink) and ShouldDisplayNotEquippable(tostring(item.subType))) then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemNotEquippable"], "LightRed"))
					self:SetBackdropBorderColor(255, 0, 0)
				end
			end
		else
			-- end
			local item = GearHelper:GetItemByLink(itemLink)
			local weightCalcGotResult, result = pcall(GearHelper.NewWeightCalculation, GearHelper, item)

			-- N'est pas censé arriver
			if (not weightCalcGotResult) then
				error(result)
			end

			if (type(result) == "table") then
				for _, v in pairs(result) do
					local floorValue = math.floor(v)

					if (floorValue < 0) then
						self:SetBackdropBorderColor(255, 0, 0)
					else
						self:SetBackdropBorderColor(0, 255, 150)
					end
				end
			else
				-- Got an error with warlock when showing tooltip of left hand Illidan's Warglaive of Azzinoth
				-- print("result : " .. tostring(result))
			end
			linesToAdd = GearHelper:LinesToAddToTooltip(result)
		end
	else
		self:SetBackdropBorderColor(255, 255, 0)
		table.insert(linesToAdd, GearHelper:ColorizeString(L["itemEquipped"], "Yellow"))
	end

	-- Add droprate to tooltip
	GetDropInfo(linesToAdd, itemLink)

	if linesToAdd then
		for _, v in pairs(linesToAdd) do
			self:AddLine(v)
		end
	end
end

for _, obj in next, {
	GameTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	ItemRefTooltip
} do
	obj:HookScript("OnTooltipSetItem", ModifyTooltip)
end

GameTooltip:HookScript(
	"OnTooltipAddMoney",
	function(self, amount)
		local _, itemLink = self:GetItem()
		if GearHelper.db.global.ItemCache[itemLink] and not GearHelper.db.global.ItemCache[itemLink].sellPrice then
			GearHelper.db.global.ItemCache[itemLink].sellPrice = amount
		end
	end
)

function GearHelper:askIfHeNeed(link, sendTo)
	self:BenchmarkCountFuncCall("GearHelper:askIfHeNeed")
	local className, classFile, classID = UnitClass(sendTo)
	local itemTable = self:GetItemByLink(link)
	local itemLink = itemTable["itemLink"]
	local lienPerso = tostring(self:GetClassColor(classFile)) .. tostring(sendTo) .. "|r"
	StaticPopupDialogs["AskIfHeNeed"] = {
		text = L["demande1"] .. lienPerso .. L["demande2"] .. itemLink .. " ?",
		button1 = L["yes"],
		button2 = L["no"],
		OnAccept = function(self, data, data2)
			local LibRealmInfo = LibStub:GetLibrary("LibRealmInfo")
			local _, _, _, _, unitLocale = LibRealmInfo:GetRealmInfoByUnit(sendTo)
			if unitLocale == nil then
				unitLocale = "enUS"
			end
			local theSource = "demande4" .. unitLocale
			local theSource2 = theSource .. "2"
			local msg = L[theSource] .. itemLink .. L[theSource2] .. "?" ~= nil and L[theSource] .. itemLink .. L[theSource2] .. "?" or L["demande4enUS"] .. itemLink .. L["demande4enUS2"] .. "?"
			local rep = "rep" .. unitLocale
			local rep2 = "rep" .. unitLocale .. "2"
			local msgRep = L[rep] .. L["maLangue" .. unitLocale] .. L[rep2] ~= nil and L[rep] .. L["maLangue" .. unitLocale] .. L[rep2] or L["repenUS"] .. L["maLangue" .. unitLocale]

			SendChatMessage(msg, "WHISPER", "Common", sendTo)
			SendChatMessage(msgRep, "WHISPER", "Common", sendTo)
			StaticPopup_Hide("AskIfHeNeed")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3 -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show("AskIfHeNeed")
end

-- TODO: Overlay buttons needs to be rework, because they don't seems to work
-- TODO: Split that shit
function GearHelper:GetQuestReward()
	self:BenchmarkCountFuncCall("GearHelper:GetQuestReward")

	local numQuestChoices = GetNumQuestChoices()
	local isBetter = false

	if self.db.profile.autoAcceptQuestReward and numQuestChoices < 1 then
		GetQuestReward()
	elseif self.db.profile.autoAcceptQuestReward and numQuestChoices == 1 then
		GetQuestReward(1)
	else
		local weightTable = {}
		local prixTable = {}
		local altTable = {}

		for i = 1, numQuestChoices do
			local item = self:GetItemByLink(GetQuestItemLink("choice", i))

			if item.type ~= L["armor"] and item.type ~= L["weapon"] then
				return
			end

			local status, res = pcall(self.NewWeightCalculation, self, item)
			if (false == status) then
				self:Print('-----------------("if (true ~= status and true ~= res) then")-----------------')
				self:Print("status : " .. tostring(status))
				self:Print("status res : " .. tostring(res))
			end

			if status then
				local tmpTable = {}
				for _, result in pairs(res) do
					if result > 0 then
						table.insert(tmpTable, result)
					end
				end

				if self:GetArraySize(tmpTable) == 0 then
					table.insert(weightTable, -10)
					table.insert(prixTable, item.sellPrice)
					table.insert(altTable, item.sellPrice, item.itemLink)
				else
					local highestResult = 0
					for _, v in ipairs(tmpTable) do
						if v > highestResult then
							highestResult = v
						end
					end
					table.insert(weightTable, highestResult)
				end
			end
		end

		local maxWeight = weightTable[1]
		local keyWeight = 1
		local maxPrix = prixTable[1]
		local keyPrix = 1

		for i = 1, table.getn(weightTable) do
			if weightTable[i] > maxWeight then
				maxWeight = weightTable[i]
				keyWeight = i
			end
		end

		for i = 1, table.getn(prixTable) do
			if prixTable[i] > maxPrix then
				maxPrix = prixTable[i]
				keyPrix = i
			end
		end

		local prixTriee = prixTable
		table.sort(prixTriee)

		local xDif = 0
		if maxWeight > 0 and not isBetter then
			local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyWeight]
			-- table.insert(GearHelper.ButtonQuestReward, button)

			if button.overlay then
				button.overlay:SetShown(false)
				button.overlay = nil
			end

			if not button.overlay then
				button.overlay = button:CreateTexture(nil, "OVERLAY")
				button.overlay:SetSize(18, 18)
				button.overlay:SetPoint("TOPLEFT", -9 + xDif, 9)
				button.overlay:SetTexture("Interface\\AddOns\\GearHelper\\Textures\\flecheUp")
				button.overlay:SetShown(true)
				xDif = xDif + 11
			end

			if GearHelper.db.profile.autoAcceptQuestReward then
				local objetI = GetQuestItemLink("choice", keyWeight)
				-- print("On prend " .. objetI)
				GetQuestReward(keyWeight)

				if button.overlay then
					button.overlay:SetShown(false)
					button.overlay = nil
				end
			end
			isBetter = true
		else
			local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyPrix]

			if button.overlay then
				button.overlay:SetShown(false)
				button.overlay = nil
			end
			if not button.overlay then
				button.overlay = button:CreateTexture(nil, "OVERLAY")
				button.overlay:SetSize(18, 18)
				button.overlay:SetPoint("TOPLEFT", -9 + xDif, 9)
				button.overlay:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
				button.overlay:SetShown(true)
				xDif = xDif + 11
			end

			local objetI = GetQuestItemLink("choice", keyPrix)

			do
				return
			end
		end
	end
end

function GearHelper:CreateLfrButtons(frameParent)
	self:BenchmarkCountFuncCall("GearHelper:CreateLfrButtons")
	local nbInstance = GetNumRFDungeons()
	local scale = min(480 / ((nbInstance - 6) * 24), 1) --> Adjust size of buttons depending on number of buttons

	if not frameParent.GHLfrButtons then
		frameParent.GHLfrButtons = {}
	end

	local buttons = frameParent.GHLfrButtons

	for i = 1, nbInstance do
		local id, name = GetRFDungeonInfo(i)
		local available, availableForPlayer = IsLFGDungeonJoinable(id)

		if (not buttons[id] and availableForPlayer) then
			local button = CreateFrame("CheckButton", frameParent:GetName() .. "GHLfrButtons" .. tostring(id), frameParent, "SpellBookSkillLineTabTemplate")

			if frameParent.lastButton then
				button:SetPoint("TOPLEFT", frameParent.lastButton, "BOTTOMLEFT", 0, -15)
			else
				button:SetPoint("TOPLEFT", frameParent, "TOPRIGHT", 3, -50)
			end

			button:SetScale(scale)
			button:SetWidth(32 + 16) -- Originally 32

			-- Need to find the button's texture in the regions so we can resize it. I don't like this part, but I can't think of a better way in case it's not the first region returned. (Is it ever not?)
			-- TODO: You don't like this part, do something
			for _, region in ipairs({button:GetRegions()}) do
				if type(region) ~= "userdata" and region.GetTexture and region:GetTexture() == "Interface\\SpellBook\\SpellBook-SkillLineTab" then
					region:SetWidth(64 + 24) -- Originally 64
					break
				end
			end

			buttons[id] = button

			button.dungeonID = id
			button.dungeonName = name

			frameParent.lastButton = button

			-- I just realised a CheckButton might already have it's own FontString, but uh... whatever.
			-- TODO: Do we let this comment ?
			local number = button:CreateFontString(button:GetName() .. "Number", "OVERLAY", "SystemFont_Shadow_Huge3")
			number:SetPoint("TOPLEFT", -4, 4)
			number:SetPoint("BOTTOMRIGHT", 5, -5)
			button.number = number

			button:SetScript(
				"OnEnter",
				function(this)
					if this.tooltip then
						GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
						for i = 1, #button.tooltip do
							tooltip = button.tooltip[i]
							GameTooltip:AddLine(tooltip.text)
							GameTooltip:AddLine(tooltip)
						end
						GameTooltip:Show()
					end
				end
			)

			button:SetScript(
				"OnClick",
				function(this)
					RaidFinderQueueFrame_SetRaid(this.dungeonID)

					-- This is to override the automatic highlighting when you click the button, while we want to use that to show queue status instead.
					-- I've no idea why simply overriding this OnClick and not doing a SetChecked doesn't disable the behavior.
					-- I probably shouldn't be using a CheckButton at all, but the SpellBookSkillLineTabTemplate looks pretty nice for the job.
					this:SetChecked(this.checked)
				end
			)
			button.checked = false
		end

		if (buttons[id]) then
			local button = _G[frameParent:GetName() .. "GHLfrButtons" .. tostring(id)]
			button:Show()
		end
	end
end

function GearHelper:UpdateButtonsAndTooltips(frameParent)
	self:BenchmarkCountFuncCall("GearHelper:UpdateButtonsAndTooltips")

	local buttons = frameParent.GHLfrButtons

	for id, button in pairs(buttons) do
		local bossKilled = 0
		local index = 0
		local bossCount = GetLFGDungeonNumEncounters(id)

		local tooltip = {{text = button.dungeonName}}
		for i = index, bossCount do
			local textBoss = ""
			local bossName, _, isDead = GetLFGDungeonEncounterInfo(id, i)

			if (isDead and bossName) then
				textBoss = self:ColorizeString(bossName, "Red") .. self:ColorizeString(" " .. L["isDead"], "LightRed")
				bossKilled = bossKilled + 1
			elseif (not isDead and bossName) then
				textBoss = self:ColorizeString(bossName, "Green") .. self:ColorizeString(" " .. L["isAlive"], "LightGreen")
			end
			table.insert(tooltip, textBoss)
		end

		button.tooltip = nil
		button.tooltip = tooltip
		local result = bossKilled .. "/" .. bossCount
		if (bossKilled == bossCount) then
			result = self:ColorizeString(result, "LightRed")
		elseif (bossKilled == 0) then
			result = self:ColorizeString(result, "LightGreen")
		else
			result = self:ColorizeString(result, "Yellow")
		end

		if (button.number.SetFormattedText) then
			button.number:SetFormattedText(result)
		end

		button.number = result
	end
end

function GearHelper:UpdateSelecCursor()
	self:BenchmarkCountFuncCall("GearHelper:UpdateSelecCursor")

	if not self.cursor then
		local cursor = GroupFinderFrame:CreateTexture("GHLfrCursor", "ARTWORK")
		cursor:SetTexture("Interface\\Minimap\\MinimapArrow")
		cursor:SetRotation(1.65)
		cursor:SetSize(80, 80)
		cursor:Hide()
		self.cursor = cursor
	end

	local parentFrame = (RaidFinderQueueFrame ~= nil and RaidFinderQueueFrame:IsVisible() and RaidFinderQueueFrame or nil)
	if (not parentFrame) then
		self.cursor:Hide()
		return
	end

	if parentFrame.raid and parentFrame.GHLfrButtons[parentFrame.raid] then
		local button = parentFrame.GHLfrButtons[parentFrame.raid]
		self.cursor:SetParent(button)
		self.cursor:SetPoint("LEFT", button, "RIGHT")
		self.cursor:Show()
	end
end

function GearHelper:UpdateGHLfrButton()
	self:BenchmarkCountFuncCall("GearHelper:UpdateGHLfrButton")
	if not RaidFinderQueueFrame.GHLfrButtons then
		return
	end

	for id, button in pairs(RaidFinderQueueFrame.GHLfrButtons) do
		local mode = GetLFGMode(LE_LFG_CATEGORY_RF, id)
		if mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended" then
			button:SetChecked(true)
			button.checked = true
		else
			button:SetChecked(false)
			button.checked = false
		end
	end
end

function GearHelper:HideLfrButtons()
	self:BenchmarkCountFuncCall("GearHelper:HideLfrButtons")
	local nbInstance = GetNumRFDungeons()

	for i = 1, nbInstance do
		local id, name = GetRFDungeonInfo(i)
		if _G["RaidFinderQueueFrameGHLfrButtons" .. id] then
			_G["RaidFinderQueueFrameGHLfrButtons" .. id]:Hide()
		end
	end
end

function GearHelper:ResetCache()
	self:BenchmarkCountFuncCall("GearHelper:ResetCache")
	self.db.global.ItemCache = {}
end

local function InitEquipLocInspect()
	GearHelper:BenchmarkCountFuncCall("InitEquipLocInspect")
	GearHelper.db.global.equipLocInspect["INVTYPE_HEAD"] = 1
	GearHelper.db.global.equipLocInspect["INVTYPE_NECK"] = 2
	GearHelper.db.global.equipLocInspect["INVTYPE_SHOULDER"] = 3
	GearHelper.db.global.equipLocInspect["INVTYPE_BACK"] = 15
	GearHelper.db.global.equipLocInspect["INVTYPE_CLOAK"] = 15
	GearHelper.db.global.equipLocInspect["INVTYPE_CHEST"] = 5
	GearHelper.db.global.equipLocInspect["INVTYPE_ROBE"] = 5
	GearHelper.db.global.equipLocInspect["INVTYPE_BODY"] = 4
	GearHelper.db.global.equipLocInspect["INVTYPE_TABARD"] = 19
	GearHelper.db.global.equipLocInspect["INVTYPE_WRIST"] = 9
	GearHelper.db.global.equipLocInspect["INVTYPE_MAINHAND"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_RANGED"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_WEAPONMAINHAND"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_2HWEAPON"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_WEAPON"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_WEAPON0"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_WEAPON1"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_RANGEDRIGHT"] = 16
	GearHelper.db.global.equipLocInspect["INVTYPE_HAND"] = 10
	GearHelper.db.global.equipLocInspect["INVTYPE_WAIST"] = 6
	GearHelper.db.global.equipLocInspect["INVTYPE_LEGS"] = 7
	GearHelper.db.global.equipLocInspect["INVTYPE_FEET"] = 8
	GearHelper.db.global.equipLocInspect["INVTYPE_FINGER"] = 11
	GearHelper.db.global.equipLocInspect["INVTYPE_FINGER0"] = 11
	GearHelper.db.global.equipLocInspect["INVTYPE_FINGER1"] = 12
	GearHelper.db.global.equipLocInspect["INVTYPE_TRINKET"] = 13
	GearHelper.db.global.equipLocInspect["INVTYPE_TRINKET0"] = 13
	GearHelper.db.global.equipLocInspect["INVTYPE_TRINKET1"] = 14
	GearHelper.db.global.equipLocInspect["INVTYPE_SECONDARYHAND"] = 17
	GearHelper.db.global.equipLocInspect["INVTYPE_WEAPONOFFHAND"] = 17
end
