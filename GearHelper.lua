-- https://mothereff.in/lua-minifier
-- Memory footprint 12048.4 k
-- TODO Replace error code by proper exception
-- TODO extract player inventory related function to an independant lib
-- TODO Move functions in split files

-- #errors : 01

--{{ Local Vars }}
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
		autoGreed = true,
		autoAcceptQuestReward = false,
		autoNeed = true,
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
		inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil}
	},
	global = {
		ItemCache = {},
		itemWaitList = {},
		myNames = "",
		buildVersion = 1,
		equipLocInspect = {}
	}
}

--{{ Global Vars }}
GearHelperVars = {
	version = GetAddOnMetadata("GearHelper", "Version"),
	prefixAddon = "GeARHeLPeRPReFIX",
	addonTruncatedVersion = 2,
	waitSpeFrame = CreateFrame("Frame"),
	waitSpeTimer = nil,
	charInventory = {}
}

local allPrefix = {["askVersion" .. GearHelperVars.prefixAddon] = sendAnswerVersion, ["answerVersion" .. GearHelperVars.prefixAddon] = receiveAnswer}

waitAnswerFrame:Hide()
GearHelperVars.waitSpeFrame:Hide()
waitNilFrame:Hide()

local function OnMinimapTooltipShow(tooltip)
	tooltip:SetOwner(LibDBIcon10_GHIcon, "ANCHOR_TOPRIGHT", -15, -100)
	tooltip:SetText(GearHelper:ColorizeString("GearHelper", GearHelper.db.profile.addonEnabled and "LightGreen" or "LightRed"))
	
	if not GearHelper.db.profile.addonEnabled then
		tooltip:AddLine(GearHelper:ColorizeString(L["Addon"], "Yellow") .. GearHelper:ColorizeString(L["DeactivatedRed"], "LightRed"), 1, 1, 1)
	end

	tooltip:AddLine(GearHelper:ColorizeString(L["MmTtLClick"], "Yellow"), 1, 1, 1)

	if GearHelper.db.profile.addonEnabled then
		tooltip:AddLine(GearHelper:ColorizeString(L["MmTtRClickDeactivate"], "Yellow"), 1, 1, 1)

		if GearHelper.db.profile.minimap.isLock then
			tooltip:AddLine(GearHelper:ColorizeString(L["MmTtClickUnlock"], "Yellow"), 1, 1, 1)
		else
			tooltip:AddLine(GearHelper:ColorizeString(L["MmTtClickLock"], "Yellow"), 1, 1, 1)
		end

		tooltip:AddLine(GearHelper:ColorizeString(L["MmTtCtrlClick"], "Yellow"), 1, 1, 1)
	else
		tooltip:AddLine(GearHelper:ColorizeString(L["MmTtRClickActivate"], "Yellow"), 1, 1, 1)
	end

	tooltip:Show()
end

local function OnMinimapTooltipClick(button, tooltip)
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	else
		local icon = LibStub("LibDBIcon-1.0")

		if IsShiftKeyDown() then
			if (GearHelper.db.profile.minimap.isLock) then
				icon:Unlock("GHIcon")
			else
				icon:Lock("GHIcon")
			end

			GearHelper.db.profile.minimap.isLock = not GearHelper.db.profile.minimap.isLock
			tooltip:Hide()
			OnMinimapTooltipShow(tooltip)
		elseif IsControlKeyDown() then
			icon:Hide("GHIcon")
			GearHelper.db.profile.minimap.hide = true
		else
			if (button == "LeftButton") then
				InterfaceOptionsFrame:Show()
				InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
			else
				GearHelper.db.profile.addonEnabled = not GearHelper.db.profile.addonEnabled
				tooltip:Hide()
				OnMinimapTooltipShow(tooltip)
			end
		end
	end
end

local function CreateMinimapIcon()
	local tooltip = tooltip or CreateFrame("GameTooltip", "tooltip", nil, "GameTooltipTemplate")
	local icon = LibStub("LibDBIcon-1.0")
	local GHIcon =
		LibStub("LibDataBroker-1.1"):NewDataObject(
		"GHIcon",
		{
			type = "data source",
			text = "GearHelper",
			icon = "Interface\\AddOns\\GearHelper\\Textures\\flecheUp",
			label = "GearHelper",
			OnClick = function(_, button)
				OnMinimapTooltipClick(button, tooltip)
			end,
			OnTooltipShow = function()
				OnMinimapTooltipShow(tooltip)
			end,
			OnLeave = function()
				tooltip:Hide()
			end
		}
	)
	icon:Register("GHIcon", GHIcon, GearHelper.db.profile.minimap)
end

function GearHelper:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GearHelperDB", defaultsOptions)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetConfig")
	self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

	CreateMinimapIcon()
end

function GearHelper:RefreshConfig()
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

local function nilTableValues(tableToReset)
	for key, v in pairs(tableToReset) do
		if type(tableToReset[key]) == "table" then
			nilTableValues(tableToReset[key])
		else
			tableToReset[key] = nil
		end
	end
end

function GearHelper:ResetConfig()
	nilTableValues(self.db.profile)
	nilTableValues(self.db.global)

	InterfaceOptionsFrame:Hide()
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:OnEnable()
	if not self.db.profile.addonEnabled then
		print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["DeactivatedRed"], "LightRed"))
		return
	end
	
	print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["ActivatedGreen"], "LightGreen"))
	self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
	if (#self.db.global.equipLocInspect == 0) then
		self:InitEquipLocInspect()
	end
end

function GearHelper:setDefault()
	self.db = nil
	ReloadUI()
end

function GearHelper:setInviteMessage(newMessage)
	if newMessage == nil then
		return
	end

	self.db.profile.inviteMessage = tostring(newMessage)
	print(L["InviteMessage"] .. tostring(self.db.profile.inviteMessage))
end

function GearHelper:showMessageSMN(channel, sender, msg)
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
	if not name then 
		return
	end

	self.db.global.myNames = tostring(name .. ",")
end

function GearHelper:sendAskVersion()
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
	if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "RAID")
	end
	if IsInGuild() ~= nil and IsInGuild() == true then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "GUILD")
	end
end

function GearHelper:receiveAnswer(msgV, msgC)
	if not askTime or updateAddonReminderCount <= 0 or tonumber(msgV) ~= nil and tonumber(msgV) <= GearHelperVars.addonTruncatedVersion then 
		return
	end

	message(L["maj1"] .. self:ColorizeString(GearHelperVars.version, "LightRed") .. L["maj2"] .. self:ColorizeString(msgV, "LightGreen") .. L["maj3"] .. msgC .. " (Curse)")
	askTime = nil
	waitAnswerFrame:Hide()
	updateAddonReminderCount = updateAddonReminderCount - 1
end

local function computeAskTime(frame, elapsed)
	if not askTime or (time() - askTime) <= maxWaitTime then
		return
	end
	askTime = nil
	frame:Hide()
end

waitAnswerFrame:SetScript(
	"OnUpdate",
	computeAskTime
)

local function delayBetweenEquip(frame)
	if time() <= GearHelperVars.waitSpeTimer + delaySpeTimer then
		return
	end
	for bag = 0,4 do
		numBag = bag
		GearHelper:equipItem()
	end
	frame:Hide()
end

GearHelperVars.waitSpeFrame:SetScript("OnUpdate", delayBetweenEquip)

local function delayNilFrame(frame)
	if time() <= waitNilTimer + delayNilTimer then
		do return end
	end
	setDefault()
	frame:Hide()
end

waitNilFrame:SetScript("OnUpdate",delayNilFrame)

function GearHelper:GetEquippedItemLink(slotID, slotName)
	local itemLink = GetInventoryItemLink("player", slotID)
	local itemID = GetInventoryItemID("player", slotID)
	local itemString, itemName

	if itemLink then
		itemString, itemName = itemLink:match("|H(.*)|h%[(.*)%]|h")
	end

	if itemID then
		if not itemName or itemName == "" then
			GetItemInfo(itemID)
			self.db.global.itemWaitList[itemID] = slotName
			return -2
		else
			return itemLink
		end
	else
		return 0
	end
end

function GearHelper:ScanCharacter()
	GearHelperVars.charInventory["Head"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("HeadSlot"), "HeadSlot")
	GearHelperVars.charInventory["Neck"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("NeckSlot"), "NeckSlot")
	GearHelperVars.charInventory["Shoulder"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("ShoulderSlot"), "ShoulderSlot")
	GearHelperVars.charInventory["Back"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("BackSlot"), "BackSlot")
	GearHelperVars.charInventory["Chest"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("ChestSlot"), "ChestSlot")
	GearHelperVars.charInventory["Wrist"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("WristSlot"), "WristSlot")
	GearHelperVars.charInventory["Hands"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("HandsSlot"), "HandsSlot")
	GearHelperVars.charInventory["Waist"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("WaistSlot"), "WaistSlot")
	GearHelperVars.charInventory["Legs"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("LegsSlot"), "LegsSlot")
	GearHelperVars.charInventory["Feet"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("FeetSlot"), "FeetSlot")
	GearHelperVars.charInventory["Finger0"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Finger0Slot"), "Finger0Slot")
	GearHelperVars.charInventory["Finger1"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Finger1Slot"), "Finger1Slot")
	GearHelperVars.charInventory["Trinket0"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Trinket0Slot"), "Trinket0Slot")
	GearHelperVars.charInventory["Trinket1"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Trinket1Slot"), "Trinket1Slot")
	GearHelperVars.charInventory["MainHand"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("MainHandSlot"), "MainHandSlot")
	GearHelperVars.charInventory["SecondaryHand"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("SecondaryHandSlot"), "SecondaryHandSlot")

	if GearHelperVars.charInventory["MainHand"] ~= -2 and GearHelperVars.charInventory["MainHand"] ~= 0 then
		local _, _, _, _, _, _, _, _, itemEquipLocWeapon = GetItemInfo(GearHelperVars.charInventory["MainHand"])

		if itemEquipLocWeapon == "INVTYPE_2HWEAPON" or itemEquipLocWeapon == "INVTYPE_RANGED" then
			GearHelperVars.charInventory["SecondaryHand"] = -1
		end
	end
end

function GearHelper:poseDot()
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

			if itemLink 
			and self:DoDisplayOverlay(self:IsItemBetter(itemLink, "ItemLink")) 
			and not button.overlay then
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
	if GearHelper.db.profile.weightTemplate == "NOX" or GearHelper.db.profile.weightTemplate == "NOX_ByDefault" then
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
	local valueItem = 0
	local mainStat = GearHelper:FindHighestStatInTemplate()
	local areAllValueZero = true
	if mainStat ~= nil and mainStat ~= "Nothing" and GearHelper.db.profile.includeSocketInCompute then
		valueItem = delta.nbGem * GearHelper:GetGemValue() * GetStatFromTemplate(mainStat)
	end

	for k, v in pairs(delta) do
		if L.Tooltip.Stat[k] ~= nil then
			if GetStatFromTemplate(k) ~= 0 then
				areAllValueZero = false
			end
			valueItem = valueItem + GetStatFromTemplate(k) * v
		end
	end

	if GearHelper.db.profile.iLvlOption == true then
		valueItem = valueItem + delta.iLvl * GearHelper.db.profile.iLvlWeight
	end
	if valueItem == 0 and areAllValueZero then
		valueItem = "notAdapted"
	end
	return valueItem
end

local waitTable = {}
local waitFrame = nil

function GearHelper:IsItemBetter(object, type, objectEquipped)
	--The item to test
	local item = {}
	local itemEquipped = nil
	local itemLink = ""
	local itemEquippedLink = ""

	if (IsEquippedItem(object)) then
		return {-60}
	end

	if type:lower() == "itemlink" then
		--First we query the GearHelper cache to speed up process and avoid potential nil from GetItemInfo
		item = GearHelper:GetItemFromCache(object)
		itemLink = object
		if (objectEquipped) then
			itemEquipped = GearHelper:GetItemFromCache(objectEquipped)
			itemEquippedLink = objectEquipped
		end
	elseif type:lower() == "tooltip" then
		--We retrieve the hyperlink from the tooltip
		_, itemLink = object:GetItem()
		--We query the cache
		item = GearHelper:GetItemFromCache(itemLink)
	else
		--If argument are wrong we return nil
		return
	end
	--itemLink will always be set at this point so we just test for item
	if not item then
		--Item was not found in cache at this point so we create it
		item = GearHelper:BuildItemFromTooltip(object, type)
		--And we add it to the cache
		GearHelper:PutItemInCache(itemLink, item)
	end
	if (objectEquipped and not itemEquipped) then
		itemEquipped = GearHelper:BuildItemFromTooltip(objectEquipped, "itemLink")
		GearHelper:PutItemInCache(itemEquippedLink, itemEquipped)
	end
	--Normalize value to handle multiple cases
	return GearHelper:NormalizeWeightResult(GearHelper:NewWeightCalculation(item, itemEquipped))
end

function GearHelper:BuildItemFromTooltip(object, type)
	local tip = ""
	local item = {}
	local textures = {}
	local n = 0
	--Check if we have a tooltip or itemlink in input
	if type:lower() == "itemlink" then
		tip = myTooltipFromTemplate or CreateFrame("GAMETOOLTIP", "myTooltipFromTemplate", nil, "GameTooltipTemplate")
		tip:SetOwner(WorldFrame, "ANCHOR_NONE")
		tip:SetHyperlink(object)
	elseif type:lower() == "tooltip" then
		tip = object
	end

	--Get some info from GetItemInfoInstant because GetItemInfo is unreliable as of now
	_, item.itemLink = tip:GetItem()
	item.itemString = string.match(item.itemLink, "item[%-?%d:]+")
	_, _, item.rarity = string.find(item.itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	item.id, item.type, item.subType, item.equipLoc = GetItemInfoInstant(item.itemLink)
	item.name = _G["GameTooltipTextLeft1"]:GetText()
	if GetItemInfo(item.itemLink) then
		_, _, _, _, _, _, _, _, _, _, item.sellPrice = GetItemInfo(item.itemLink)
	end
	--Count the number of texture to know the number of gem on an item
	for i = 1, 10 do
		textures[i] = _G["GameTooltipTexture" .. i]
	end
	for i = 1, 10 do
		if textures[i]:IsShown() then
			n = n + 1
		end
	end
	item.nbGem = tonumber(n)

	--We parse the lines from the tooltip
	for i = 2, tip:NumLines() do
		local line = ""
		if type:lower() == "tooltip" then
			line = _G["GameTooltipTextLeft" .. i]
		elseif type:lower() == "itemlink" then
			line = _G["myTooltipFromTemplateTextLeft" .. i]
		end
		local text = line:GetText()
		if text then
			--Get the itemlevel
			if string.find(text, L["Tooltip"].ItemLevel) then
				--Get the required level to use the item
				for word in string.gmatch(text, "(%d+)") do
					item.iLvl = tonumber(word)
				end
			elseif string.find(text, L["Tooltip"].LevelRequired) then
				--Get the bonus associated to gem socket
				item.levelRequired = tonumber(string.match(text, "%d+"))
			elseif string.find(text, L["Tooltip"].BonusGem) then
				--Parse the stat from tooltip
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
	--To avoid error for useless objects like hearthstone
	if item.levelRequired == nil then
		item.levelRequired = 0
	end
	return item
end

function GearHelper:GetItemFromCache(itemLink)
	for k, v in pairs(GearHelper.db.global.ItemCache) do
		if k == itemLink then
			return v
		end
	end
	return nil
end

function GearHelper:PutItemInCache(itemLink, item)
	GearHelper.db.global.ItemCache[itemLink] = item
end

function GearHelper:GetItemByLink(itemLink)
	--Try to get item from GH Cache
	local item = GearHelper:GetItemFromCache(itemLink)

	--Not found in cache
	if not item then
		item = GearHelper:BuildItemFromTooltip(itemLink, "ItemLink")
		GearHelper:PutItemInCache(itemLink, item)
	end

	return item
end

function GearHelper:NewWeightCalculation(item, myEquipItem)
	if not GearHelper.db.profile.addonEnabled then
		do return end
	end
	if IsEquippedItem(item.id) or not GearHelper:IsEquippableByMe(item) then
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

function GearHelper:equipItem(inThisBag)
	local bagToEquip = inThisBag or 0
	local _, typeInstance, difficultyIndex = GetInstanceInfo()

	waitEquipFrame = CreateFrame("Frame")
	waitEquipTimer = time()
	waitEquipFrame:Hide()
	waitEquipFrame:SetScript(
		"OnUpdate",
		function(self, elapsed)
			if time() <= waitEquipTimer + 0.5 then
				do return end
			end
			-- if time() > waitEquipTimer + 0.5 then
				if typeInstance ~= "pvp" and tostring(difficultyIndex) ~= "24" then
					-- if numBag == nil then numBag = 0 end
					for slot = 1, GetContainerNumSlots(bagToEquip) do
						local itemLink = GetContainerItemLink(bagToEquip, slot)
						if itemLink ~= nil then
							local weightCalcResult = GearHelper:IsItemBetter(itemLink, "ItemLink")
							GearHelper:Print("----------")
							foreach(
								weightCalcResult,
								function(k, v)
									GearHelper:Print(k .. " " .. v)
								end
							)
							if weightCalcResult == -1010 then
								do
									return
								end
							else
								if not InCombatLockdown and weightCalcResult[1] ~= nil and weightCalcResult[1] > 0 or weightCalcResult[2] ~= nil and weightCalcResult[2] > 0 then
									local table = GearHelper:GetItemByLink(itemLink)
									local itemEquipLoc = table["equipLoc"]
									local name = table["name"]
									if itemEquipLoc == "INVTYPE_TRINKET" then
										if weightCalcResult[1] > weightCalcResult[2] then
											EquipItemByName(name, 13)
										else
											EquipItemByName(name, 14)
										end
									elseif itemEquipLoc == "INVTYPE_FINGER" then
										if weightCalcResult[1] > weightCalcResult[2] then
											EquipItemByName(name, 11)
										else
											EquipItemByName(name, 12)
										end
									elseif itemEquipLoc == "INVTYPE_WEAPON" then
										if weightCalcResult[1] > weightCalcResult[2] then
											EquipItemByName(name, 16)
										else
											EquipItemByName(name, 17)
										end
									else
										EquipItemByName(name)
									end
									GearHelper:ScanCharacter()
									if GearHelper.db.profile.printWhenEquip then
										print(itemLink .. L["equipVerbose"])
									end
								elseif InCombatLockdown() then
									waitEquipTimer = time()
									waitEquipFrame:Show()
								end
							end
						end
					end
					self:Hide()
			end
		end
	)
	waitEquipFrame:Show()
end

local function GetQualityFromColor(color)
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
	end
end

function GearHelper:CreateLinkAskIfHeNeeds(debug, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter) ------------------------------------------------------------------
	local message = message or "|cff1eff00|Hitem:13262::::::::100:105::::::|h[Porte-cendres ma Gueule]|h|r"
	local target = target or GetUnitName("player")

	if debug ~= 1 then
	if target == nil then
		do return end
	end
	if target == GetUnitName("player") then
		do return end
	end
	if target == "" then
		do return end
	end
	if not GearHelper.db.profile.askLootRaid then 
		do return end
	end
	if string.find(string.lower(message), "bonus") then
		do return end
	end
	end


			local couleur = ""
			local className, classFile, classID = UnitClass(target)
			local tar

			if classFile ~= nil and target ~= nil then
				tar = GearHelper:CouleurClasse(classFile) .. tostring(target) .. "|r"
			else
				tar = ""
			end
			local nameLink

			local OldSetItemRef = SetItemRef
			function SetItemRef(link, text, button, chatFrame)
				local func = strmatch(link, "^GHWhispWhenClick:(%a+)")
				if func == "askIfHeNeed" then
					local _, nomPerso, itID, persoLink = strsplit("_", link)
					local _, theItemLink = GetItemInfo(itID)
					local itemTable = GearHelper:GetItemByLink(theItemLink)
					local itLink1 = itemTable.itemLink

					GearHelper:askIfHeNeed(itLink1, nomPerso)
				else
					OldSetItemRef(link, text, button, chatFrame)
				end
			end

			for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
				local itemTable = GearHelper:GetItemByLink(itemLink)
				local quality = GetQualityFromColor(itemTable.rarity)

				if quality ~= nil and quality < 5 or debug == 1 then
					nameLink = GearHelper:ReturnGoodLink(itemLink, target, tar)

					if debug ~= 1 then
						local weightCalcResult = GearHelper:IsItemBetter(itemLink, "ItemLink")

						if weightCalcResult ~= nil then
							if #weightCalcResult == 1 then
								if weightCalcResult[1] > 0 then
									UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0, 80)
									print(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink)
									PlaySound(5274, "Master")
								end
							else
								if weightCalcResult[1] ~= nil and weightCalcResult[1] > 0 or weightCalcResult[2] ~= nil and weightCalcResult[2] > 0 then
									UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0, 80)
									print(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink)
									PlaySound(5274, "Master")
								end
							end
						else
							GearHelper:Print("WeightCalcResult nil")
							-- error("ERROR 01 : WeightCakcResult is nil in GearHelper.lua/CreateLinkAskIfHeNeeds line 880")
						end
					elseif debug == 1 then
						UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0, 80)
						print(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink)
						PlaySound(5274, "Master")
					end
				end
			end
end

function GearHelper:LinesToAddToTooltip(result, item)
	local linesToAdd = {}
	if GearHelper.db.profile.computeNotEquippable == false and result[1] == -20 or result[1] == -40 then --nil or not equippable
		do return end
	end

		if #result == 1 then
			if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThanGeneral"], "LightRed"))
			elseif result[1] == -60 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemEquipped"], "Yellow"))
			elseif result[1] == 0 then
				table.insert(linesToAdd, L["itemEgal"])
			elseif result[1] == -50 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better"))
			elseif result[1] > 0 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThanGeneral"], "Better") .. math.floor(result[1]))
			end
		elseif #result == 2 then
			if item.equipLoc == "INVTYPE_TRINKET" then
				if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
					-- avec une newMessage de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. " Trinket0")
				elseif result[1] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket0")
				elseif result[1] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better") .. " Trinket0")
				elseif result[1] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. " Trinket0 " .. L["itemBetterThan2"] .. math.floor(result[1]))
				end
				if result[2] == -30 or result[2] == -10 or IsEquippableItem(item.id) and result[2] == -20 then
					-- avec une newMessage de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. " Trinket1")
				elseif result[2] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket1")
				elseif result[2] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better") .. " Trinket1")
				elseif result[2] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. " Trinket1 " .. L["itemBetterThan2"] .. math.floor(result[2]))
				end
			elseif item.equipLoc == "INVTYPE_FINGER" then
				if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
					-- avec une newMessage de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. " Finger0")
				elseif result[1] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket0")
				elseif result[1] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better") .. " Finger0")
				elseif result[1] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. " Finger0 " .. L["itemBetterThan2"] .. math.floor(result[1]))
				end
				if result[2] == -30 or result[2] == -10 or IsEquippableItem(item.id) and result[2] == -20 then
					-- avec une newMessage de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. " Finger1")
				elseif result[2] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket1")
				elseif result[2] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better") .. " Finger1")
				elseif result[2] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. " Finger1 " .. L["itemBetterThan2"] .. math.floor(result[2]))
				end
			elseif item.equipLoc == "INVTYPE_WEAPON" then
				if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
					-- avec une newMessage de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. L["mainD"])
				elseif result[1] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket0")
				elseif result[1] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better") .. L["mainD"])
				elseif result[1] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. L["mainD"] .. L["itemBetterThan2"] .. math.floor(result[1]))
				end
				if result[2] == -30 or result[2] == -10 or IsEquippableItem(item.id) and result[2] == -20 then
					-- avec une newMessage de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. L["mainG"])
				elseif result[2] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket1")
				elseif result[2] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Better") .. L["mainG"])
				elseif result[2] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. L["mainG"] .. L["itemBetterThan2"] .. math.floor(result[2]))
				end
			else
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThanGeneral"], "LightRed"))
			end
		end
	return linesToAdd
end

local ModifyTooltip = function(self, ...)
	if not GearHelper.db then 
		do return end
	end
	if not GearHelper.db.profile.addonEnabled then
		do return end
	end

	local _, itemLink = self:GetItem()

	if not itemLink then
		do return end
	end
	if string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r") then
		do return end
	end


			local result = GearHelper:IsItemBetter(itemLink, "ItemLink")
			local item = GearHelper:GetItemByLink(itemLink)
			local linesToAdd = GearHelper:LinesToAddToTooltip(result, item)
			_, _, _, _, itemId = string.find(item.itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

			if GearHelper.itemsDropRate[itemId] ~= nil then
				table.insert(linesToAdd, L["DropRate"] .. GearHelper.itemsDropRate[itemId]["Rate"] .. "%")
				if GearHelper.itemsDropRate[itemId]["Zone"] ~= "" then
					table.insert(linesToAdd, L["DropZone"] .. GearHelper.itemsDropRate[itemId]["Zone"])
				end
				table.insert(linesToAdd, L["DropBy"] .. GearHelper.itemsDropRate[itemId]["Drop"])
			end
			if linesToAdd then
				if (result[1] == -30 or result[1] == -10 or GearHelper.db.profile.computeNotEquippable == true and result[1] == -20 and IsEquippableItem(item.id)) then
					self:SetBackdropBorderColor(255, 0, 0) -- Rouge
				elseif result[1] == 0 or result[1] == -60 then
					self:SetBackdropBorderColor(255, 255, 0) -- Jaune
				elseif result[1] == -50 or result[1] > 0 then
					self:SetBackdropBorderColor(0, 255, 150) -- "LightGreen"
				end

				if #result == 2 then
					if result[2] == 0 then
						self:SetBackdropBorderColor(255, 255, 0) -- Jaune
					elseif result[2] == -50 or result[2] > 0 then
						self:SetBackdropBorderColor(0, 255, 150) -- "LightGreen"
					end
				end

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
	local className, classFile, classID = UnitClass(sendTo)
	local itemTable = GearHelper:GetItemByLink(link)
	local itemLink = itemTable["itemLink"]
	local lienPerso = tostring(GearHelper:CouleurClasse(classFile)) .. tostring(sendTo) .. "|r"
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
			local theSource2 = "demande4" .. unitLocale .. "2"
			local msg = L[theSource] .. itemLink .. L[theSource2] .. "?" ~= nil and L[theSource] .. itemLink .. L[theSource2] .. "?" or L["demande4enUS"] .. itemLink .. L["demande4enUS2"] .. "?"
			local rep = "rep" .. unitLocale
			local rep2 = "rep" .. unitLocale .. "2"
			local msgRep = L[rep] .. L["maLangue"..unitLocale] .. L[rep2] ~= nil and L[rep] .. L["maLangue"..unitLocale] .. L[rep2] or L["repenUS"] .. L["maLangue"..unitLocale]

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

function GearHelper:GetQuestReward()
	local numQuestChoices = GetNumQuestChoices()
	local name, link, typeI, subTypeI, itemSellPrice1
	local isBetter = false
	if numQuestChoices < 1 then
		if GearHelper.db.profile.autoAcceptQuestReward then
			GetQuestReward()
		end
	elseif numQuestChoices == 1 then
		if GearHelper.db.profile.autoAcceptQuestReward then
			GetQuestReward(1)
		end
	else
		local weightTable = {}
		local prixTable = {}
		local altTable = {}

		for i = 1, numQuestChoices do
			local objetI = GetQuestItemLink("choice", i)
			local itemTable = GearHelper:GetItemByLink(objetI)
			name = itemTable.name
			link = itemTable.itemLink
			typeI = itemTable.type
			itemSellPrice1 = itemTable.sellPrice

			if not GetItemInfo(objetI) then
				GearHelper.idNilGetQuestReward = objetI
				coroutine.yield()
			end
			if typeI ~= L["armor"] and typeI ~= L["weapon"] then
				GearHelper:Print("on stop pour : " .. typeI)
				do
					return
				end
			end
			local res = GearHelper:IsItemBetter(objetI, "ItemLink")
			if res[1] ~= nil and res[1] > 0 or res[2] ~= nil and res[2] > 0 then
				if res[1] > 0 then
					table.insert(weightTable, res[1])
				else
					table.insert(weightTable, res[2])
				end
				if res[1] == -1010 or res[2] == -1010 then
					GearHelper:Print("On a un -1010 dans GetQuestReward")
				end
			else
				table.insert(weightTable, -10)

				table.insert(prixTable, itemSellPrice1)
				table.insert(altTable, itemSellPrice1, objetI)
			end
		end -- FIN DU FOR QUI PARSE TOUS LES ITEMS EN RECOMPENSE DE QUETE

		local maxWeight = weightTable[1]
		local keyWeight = 1
		local maxPrix = prixTable[1]
		local keyPrix = 1

		for i = 1, #weightTable do
			if weightTable[i] > maxWeight then
				maxWeight = weightTable[i]
				keyWeight = i
			end
		end

		for i = 1, #prixTable do
			if prixTable[i] > maxPrix then
				maxPrix = prixTable[i]
				keyPrix = i
			end
		end

		local prixTriee = prixTable
		GearHelper:CountingSort(prixTriee)

		local xDif = 0
		if maxWeight > 0 and not isBetter then
			local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. keyWeight]

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
				print("On prend " .. objetI)
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

			if GearHelper.db.profile.autoAcceptQuestReward then
				local objetI = GetQuestItemLink("choice", keyPrix)
				print("On prend " .. objetI)
			end

			do
				return
			end
		end
	end
end

function GearHelper:AutoGreedAndNeed(number)
if not GearHelper.db.profile.autoNeed and not GearHelper.db.profile.autoGreed then
	do return end
end

		local link, name, _, _, _, canNeed, canGreed = GetLootRollItemInfo(number)
		local itemTable = GearHelper:GetItemByLink(link)
		local itemType = itemTable.type
		local itemSubType = itemTable.subType

		local weightCalcResult = GearHelper:IsItemBetter(link, "ItemLink")

		if canNeed then
			if GearHelper.db.profile.autoNeed then
				if itemType == L["armor"] or itemType == L["weapon"] then
					if (weightCalcResult[1] ~= nil and weightCalcResult[1] > 0) or (weightCalcResult[2] ~= nil and weightCalcResult[2] > 0) then
						ConfirmLootRoll(number, 1)
						UIErrorsFrame:AddMessage(L["iNeededOn"] .. name, 0.0, 1.0, 0.0, 150) -----------          DEBUG MODE        -----------
					elseif GearHelper.db.profile.autoGreed then
						ConfirmLootRoll(number, 2)
					end
				end
			else
				do
					return
				end
			end
		elseif canGreed then
			if GearHelper.db.profile.autoGreed then
				for _, v in pairs(L["TypeToNotNeed"]) do
					if itemType == v or itemSubType == v then
						do
							return
						end
					end
				end
				ConfirmLootRoll(number, 2)
			end
		end
end

function GearHelper:CreateLfrButtons(frameParent)
	local nbInstance = GetNumRFDungeons()
	local scale = min(480 / ((nbInstance - 6) * 24), 1) --> Ajuste la taille des boutons en fonction de leur nombre

	if not frameParent.GHLfrButtons then
		frameParent.GHLfrButtons = {}
	end
	local buttons = frameParent.GHLfrButtons

	for i = 1, nbInstance do
		local id, name = GetRFDungeonInfo(i)
		local dispo, dispoPourJoueur = IsLFGDungeonJoinable(id)
		local nbBoss = GetLFGDungeonNumEncounters(id)

		-- Only make a button if there's data for it, and it hasn't been already made. This gets called multiple times so it updates correctly when you open up more raids
		if dispo and dispoPourJoueur and not buttons[id] and nbBoss then
			local button = CreateFrame("CheckButton", frameParent:GetName() .. "GHLfrButtons" .. tostring(id), frameParent, "SpellBookSkillLineTabTemplate")

			if frameParent.lastButton then
				button:SetPoint("TOPLEFT", frameParent.lastButton, "BOTTOMLEFT", 0, -15)
			else
				local x = 3
				-- SocialTabs compatibility
				if IsAddOnLoaded("SocialTabs") then
					x = x + ceil(32 / scale)
				end

				button:SetPoint("TOPLEFT", frameParent, "TOPRIGHT", x, -50)
			end

			button:SetScale(scale)
			button:SetWidth(32 + 16) -- Originally 32

			-- Need to find the button's texture in the regions so we can resize it. I don't like this part, but I can't think of a better way in case it's not the first region returned. (Is it ever not?)
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
	local buttons = frameParent.GHLfrButtons

	for id, button in pairs(buttons) do
		local bossTues = 0
		local index = 0
		local nbBoss = GetLFGDungeonNumEncounters(id)

		-- Pour chaque raid on récupère le nombre de boss tués, et on ajoute le text "boss mort" ou "boss vivant"
		local tooltip = {{text = button.dungeonName}}
		for i = index, nbBoss do
			local textBoss = ""
			local bossName, _, isDead = GetLFGDungeonEncounterInfo(id, i)

			if isDead and bossName ~= nil then
				textBoss = GearHelper:ColorizeString(bossName, "Red") .. GearHelper:ColorizeString(" "..L["isDead"], "LightRed")
				bossTues = bossName and bossTues + 1
			elseif not isDead and bossName then
				textBoss = GearHelper:ColorizeString(bossName, "Green") .. GearHelper:ColorizeString(" "..L["isAlive"], "LightGreen")
			end
			table.insert(tooltip, textBoss)
		end

		-- Implémente le couleur + le text des boutons
		button.tooltip = tooltip
		local result = bossTues .. "/" .. nbBoss
		if (bossTues == nbBoss) then
			result = GearHelper:ColorizeString(result, "LightRed")
		elseif (bossTues == 0) then
			result = GearHelper:ColorizeString(result, "LightGreen")
		else
			result = GearHelper:ColorizeString(result, "Yellow")
		end

		-- Utilise cette fonction pour ajouter du text si elle est dispo (évite des erreurs)
		if (button.number.SetFormattedText) then
			button.number:SetFormattedText(result)
		end

		button.number = result
	end
end

function GearHelper:UpdateSelecCursor()
	-- Création du curseur s'il n'existe pas
	if not GearHelper.cursor then
		local cursor = GroupFinderFrame:CreateTexture("GHLfrCursor", "ARTWORK")
		cursor:SetTexture("Interface\\Minimap\\MinimapArrow")
		cursor:SetRotation(1.65)
		cursor:SetSize(80, 80)
		cursor:Hide()
		GearHelper.cursor = cursor
	end

	-- Si on ferme la fenêtre LFR on cache le curseur
	local parentFrame = (RaidFinderQueueFrame ~= nil and RaidFinderQueueFrame:IsVisible() and RaidFinderQueueFrame or nil)
	if (not parentFrame) then
		GearHelper.cursor:Hide()
		return
	end

	-- Si on change de raid dans la fenêtre LFR, on modifie la position du curseur
	if parentFrame.raid and parentFrame.GHLfrButtons[parentFrame.raid] then
		local button = parentFrame.GHLfrButtons[parentFrame.raid]
		GearHelper.cursor:SetParent(button)
		GearHelper.cursor:SetPoint("LEFT", button, "RIGHT")
		GearHelper.cursor:Show()
	end
end

-- "check" le bouton si on est en attente d'un raid (crée le contour doré)
-- Adaptation de l'addon BossesKilled
function GearHelper:UpdateGHLfrButton()
	if not RaidFinderQueueFrame.GHLfrButtons then 
		do return end
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
	local nbInstance = GetNumRFDungeons()
	for i = 1, nbInstance do
		local id, name = GetRFDungeonInfo(i)
		if _G["RaidFinderQueueFrameGHLfrButtons" .. id] then
			_G["RaidFinderQueueFrameGHLfrButtons" .. id]:Hide()
		end
	end
end

function GearHelper:ResetCache()
	GearHelper.db.global.ItemCache = {}
end

function GearHelper:AddIlvlOnCharFrame(show)
	local function CharFrameShow(frame)
		if not GearHelper.db.profile.ilvlCharFrame then
			do return end
		end

			table.foreach(
				GearHelperVars.charInventory,
				function(slotName, item, number)
					if (item ~= -1) then
						local arrayPos = {
							xHead = -204,
							xNeck = -204,
							xShoulder = -204,
							xBack = -204,
							xChest = -204,
							xWrist = -204,
							xMainHand = -125,
							xHands = -3,
							xWaist = -3,
							xLegs = -3,
							xFeet = -3,
							xFinger0 = -3,
							xFinger1 = -3,
							xTrinket0 = -3,
							xTrinket1 = -3,
							xSecondaryHand = -77,
							yHead = 140,
							yNeck = 99,
							yShoulder = 58,
							yBack = 17,
							yChest = -24,
							yWrist = -147,
							yMainHand = -140,
							yHands = 140,
							yWaist = 99,
							yLegs = 58,
							yFeet = 17,
							yFinger0 = -24,
							yFinger1 = -65,
							yTrinket0 = -106,
							yTrinket1 = -147,
							ySecondaryHand = -140
						}

						local button = _G["charIlvlButton" .. slotName] or CreateFrame("Button", "charIlvlButton" .. slotName, PaperDollItemsFrame)
						button:SetPoint("CENTER", PaperDollItemsFrame, "CENTER", arrayPos["x" .. slotName], arrayPos["y" .. slotName])
						button:SetSize(1, 1)

						if (item ~= 0) then
							local itemScan = GearHelper:GetItemByLink(item)
							local itemLink, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc
							iR = ((iR == "9d9d9d" and 0) or (iR == "ffffff" and 1) or (iR == "1eff00" and 2) or (iR == "0070dd" and 3) or (iR == "a335ee" and 4) or (iR == "ff8000" and 5) or (iR == "e6cc80" and 6) or (iR == "00ccff" and 7))

							button:SetText(itemLevel)
							button:SetNormalFontObject("GameFontNormalSmall")

							local font = _G["charIlvlFont" .. slotName] or CreateFont("charIlvlFont" .. slotName)
							local r, g, b = GetItemQualityColor(iR ~= nil and iR or 0)
							font:SetTextColor(r, g, b, 1)
							button:SetNormalFontObject(font)
						end
					end
				end
			)
	end

	local function CharFrameHide()
		GearHelper:HideIlvlOnCharFrame()
	end

	PaperDollItemsFrame:HookScript("OnShow", CharFrameShow)
	PaperDollItemsFrame:HookScript("OnHide", CharFrameHide)

	if (show) then
		CharFrameShow()
	end
end

function GearHelper:HideIlvlOnCharFrame()
	table.foreach(
		GearHelperVars.charInventory,
		function(slotName, item)
			if (_G["charIlvlButton" .. slotName]) then
				_G["charIlvlButton" .. slotName]:Hide()
				_G["charIlvlButton" .. slotName] = nil
			end
		end
	)
end

function GearHelper:AddIlvlOnInspectFrame(target, show)
	local function InspectFrameShow(frame)
		if not GearHelper.db.profile.ilvlInspectFrame then 
			do return end
		end
			local arrayPos = {
				xINVTYPE_HEAD = -100,
				xINVTYPE_NECK = -100,
				xINVTYPE_SHOULDER = -100,
				xINVTYPE_BACK = -100,
				xINVTYPE_ROBE = -100,
				xINVTYPE_CLOAK = -100,
				xINVTYPE_CHEST = -100,
				xINVTYPE_BODY = -100,
				xINVTYPE_TABARD = -100,
				xINVTYPE_WRIST = -100,
				xINVTYPE_MAINHAND = -20,
				xINVTYPE_RANGED = -20,
				xINVTYPE_WEAPONMAINHAND = -20,
				xINVTYPE_2HWEAPON = -20,
				xINVTYPE_WEAPON = -20,
				xINVTYPE_RANGEDRIGHT = -20,
				xINVTYPE_HAND = 95,
				xINVTYPE_WAIST = 95,
				xINVTYPE_LEGS = 95,
				xINVTYPE_FEET = 95,
				xINVTYPE_FINGER = 95,
				xINVTYPE_TRINKET = 95,
				xINVTYPE_SECONDARYHAND = 20,
				xINVTYPE_WEAPONOFFHAND = 20,
				yINVTYPE_HEAD = 140,
				yINVTYPE_NECK = 99,
				yINVTYPE_SHOULDER = 58,
				yINVTYPE_BACK = 17,
				yINVTYPE_CLOAK = 17,
				yINVTYPE_CHEST = -24,
				yINVTYPE_ROBE = -24,
				yINVTYPE_BODY = -65,
				yINVTYPE_TABARD = -106,
				yINVTYPE_WRIST = -147,
				yINVTYPE_MAINHAND = -140,
				yINVTYPE_RANGED = -140,
				yINVTYPE_WEAPONMAINHAND = -140,
				yINVTYPE_2HWEAPON = -140,
				yINVTYPE_WEAPON = -140,
				yINVTYPE_RANGEDRIGHT = -140,
				yINVTYPE_HAND = 140,
				yINVTYPE_WAIST = 99,
				yINVTYPE_LEGS = 58,
				yINVTYPE_FEET = 17,
				yINVTYPE_FINGER = -24,
				yINVTYPE_FINGER1 = -65,
				yINVTYPE_TRINKET = -106,
				yINVTYPE_TRINKET1 = -147,
				yINVTYPE_SECONDARYHAND = -140,
				yINVTYPE_WEAPONOFFHAND = -140
			}

			local trinketAlreadyDone = false
			local fingerAlreadyDone = false
			local weaponAlreadyDone = false

			local arrayIlvl = {}

			for i = 1, 18 do
				local itemID = GetInventoryItemLink("target", i)
				if (itemID ~= nil and itemID ~= -1) then
					local itemScan = GearHelper:GetItemByLink(itemID)
					local itemLink, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc

					iR = ((iR == "9d9d9d" and 0) or (iR == "ffffff" and 1) or (iR == "1eff00" and 2) or (iR == "0070dd" and 3) or (iR == "a335ee" and 4) or (iR == "ff8000" and 5) or (iR == "e6cc80" and 6) or (iR == "00ccff" and 7))

					if (itemEquipLoc ~= nil) then
						arrayIlvl[itemEquipLoc] = itemLevel

						local button
						if (itemEquipLoc == "INVTYPE_FINGER" and not fingerAlreadyDone) then
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_FINGER"])
							fingerAlreadyDone = true
						elseif (itemEquipLoc == "INVTYPE_FINGER" and fingerAlreadyDone) then
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_FINGER1"])
						elseif (itemEquipLoc == "INVTYPE_TRINKET" and not trinketAlreadyDone) then
							button = _G["charIlvlButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_TRINKET"])
							trinketAlreadyDone = true
						elseif (itemEquipLoc == "INVTYPE_TRINKET" and trinketAlreadyDone) then
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_TRINKET1"])
						elseif (itemEquipLoc == "INVTYPE_WEAPON" and not weaponAlreadyDone) then
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["xINVTYPE_WEAPONMAINHAND"], arrayPos["yINVTYPE_WEAPONMAINHAND"])
							weaponAlreadyDone = true
						elseif (itemEquipLoc == "INVTYPE_WEAPON" and weaponAlreadyDone) then
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["xINVTYPE_WEAPONOFFHAND"], arrayPos["yINVTYPE_WEAPONOFFHAND"])
						else
							button = _G["charIlvlInspectButton" .. itemEquipLoc] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc, InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["y" .. itemEquipLoc])
						end
						button:SetSize(1, 1)
						button:SetText(itemLevel)
						button:SetNormalFontObject("GameFontNormalSmall")

						local font = _G["charIlvlInspectButton" .. itemEquipLoc .. itemID] or CreateFont("charIlvlInspectButton" .. itemEquipLoc .. itemID)
						local r, g, b = GetItemQualityColor(iR ~= nil and iR or 0)
						font:SetTextColor(r, g, b, 1)
						button:SetNormalFontObject(font)
						button:Show()
					end
				end
			end

			local ilvlAverage = 0
			local itemCount = 0
			table.foreach(
				arrayIlvl,
				function(equipLoc, ilvl)
					if (equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY") then
						ilvlAverage = ilvlAverage + ilvl
						itemCount = itemCount + 1
					end
				end
			)
			if (itemCount > 0) then
				local button = _G["ilvlAverageInspect"] or CreateFrame("Button", "ilvlAverageInspect", InspectPaperDollItemsFrame)
				button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", 0, -110)

				button:SetSize(1, 1)
				button:SetText(L["ilvlInspect"] .. tostring(math.floor((ilvlAverage / itemCount) + .5)))
				button:SetNormalFontObject("GameFontNormalSmall")

				local font = ilvlAverageInspectFont or CreateFont("ilvlAverageInspectFont")
				local r, g, b = GetItemQualityColor(iR ~= nil and iR or 0)
				font:SetTextColor(1, 0.9, 0, 1)
				button:SetNormalFontObject(font)
			end
	end

	local function InspectFrameHide()
		GearHelper:HideIlvlOnInspectFrame()
	end

	InspectPaperDollItemsFrame:HookScript("OnShow", InspectFrameShow)
	InspectPaperDollItemsFrame:HookScript("OnHide", InspectFrameHide)

	if (show) then
		InspectFrameShow()
	end
end

function GearHelper:HideIlvlOnInspectFrame()
	table.foreach(
		GearHelper.db.global.equipLocInspect,
		function(equipLoc, number)
			if (_G["charIlvlInspectButton" .. equipLoc]) then
				_G["charIlvlInspectButton" .. equipLoc]:Hide()
				_G["charIlvlInspectButton" .. equipLoc] = nil
			end
			if (_G["ilvlAverageInspect"]) then
				_G["ilvlAverageInspect"]:Hide()
				_G["ilvlAverageInspect"] = nil
			end
		end
	)
end

function GearHelper:InitEquipLocInspect()
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