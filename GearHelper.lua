-- https://mothereff.in/lua-minifier
-- Memory footprint 12048.4 k
-- TODO extract player inventory related function to an independant lib
-- TODO Move functions in split files
-- TODO check war item SetHyperlink in tooltip fail
-- TODO Expose more options to player
-- TODO : Repair GH :
-- 			- Sur mon Elfe du Vide Priest : Gants tissus n'affichent pas de message "est mieux" / "est moins bien"
--			- Sur le démo : Pas de message sur poignets tissu, bottes tissu, tête tissu, bâton, cou, tenu(e) en main gauche, dague, dos, baguette, canne a pêche
--				-- ça n'a l'air d'apparaitre que sur les bijoux et les doigts -- apparait sur les arc (cet item est moins bien)
-- TODO : Replace message "This item is worst than" by "This item cannot be eqquiped" on items that you can't eqquip (eg : on warlock --> shield)

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
		buildVersion = 5,
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
	GearHelper:BenchmarkCountFuncCall("OnMinimapTooltipShow")
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
	GearHelper:BenchmarkCountFuncCall("OnMinimapTooltipClick")
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
	GearHelper:BenchmarkCountFuncCall("CreateMinimapIcon")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:OnInitialize")
	self.db = LibStub("AceDB-3.0"):New("GearHelperDB", defaultsOptions)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetConfig")
	self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

	CreateMinimapIcon()
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:ResetConfig")
	nilTableValues(self.db.profile)
	nilTableValues(self.db.global)

	InterfaceOptionsFrame:Hide()
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:OnEnable()
	GearHelper:BenchmarkCountFuncCall("GearHelper:OnEnable")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:setDefault")
	self.db = nil
	ReloadUI()
end

function GearHelper:setInviteMessage(newMessage)
	GearHelper:BenchmarkCountFuncCall("GearHelper:setInviteMessage")
	if newMessage == nil then
		return
	end

	self.db.profile.inviteMessage = tostring(newMessage)
	print(L["InviteMessage"] .. tostring(self.db.profile.inviteMessage))
end

function GearHelper:showMessageSMN(channel, sender, msg)
	GearHelper:BenchmarkCountFuncCall("GearHelper:showMessageSMN")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:setMyNames")
	if not name then
		return
	end

	self.db.global.myNames = tostring(name .. ",")
end

function GearHelper:sendAskVersion()
	GearHelper:BenchmarkCountFuncCall("GearHelper:sendAskVersion")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:sendAnswerVersion")
	if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "RAID")
	end
	if IsInGuild() ~= nil and IsInGuild() == true then
		C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "GUILD")
	end
end

function GearHelper:receiveAnswer(msgV, msgC)
	GearHelper:BenchmarkCountFuncCall("GearHelper:receiveAnswer")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetEquippedItemLink")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:ScanCharacter")
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
		local _, _, _, itemEquipLocWeapon = GetItemInfoInstant(GearHelperVars.charInventory["MainHand"])

		if string.match(itemEquipLocWeapon, "INVTYPE_2HWEAPON") or string.match(itemEquipLocWeapon, "INVTYPE_RANGED") then
			GearHelperVars.charInventory["SecondaryHand"] = -1
		end
	end
end

function GearHelper:poseDot()
	GearHelper:BenchmarkCountFuncCall("GearHelper:poseDot")
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
	GearHelper:BenchmarkCountFuncCall("ApplyTemplateToDelta")
	local valueItem = 0
	local mainStat = GearHelper:FindHighestStatInTemplate()

	if GearHelper.db.profile.includeSocketInCompute == true then
		valueItem = delta.nbGem * GearHelper:GetGemValue() * GetStatFromTemplate(mainStat)
	end

	if GearHelper.db.profile.iLvlOption == true then
		valueItem = valueItem + delta.iLvl * GearHelper.db.profile.iLvlWeight
	end

	for k, v in pairs(delta) do
		if L.Tooltip.Stat[k] ~= nil and v ~= 0 then
			if GetStatFromTemplate(k) ~= 0 then
				valueItem = valueItem + GetStatFromTemplate(k) * v
			else
				valueItem = valueItem + GearHelper.db.profile.defaultWeightForStat * v
			end
		end
	end

	return valueItem
end

local waitTable = {}
local waitFrame = nil

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

	for k, v in ipairs(equipSlot) do
		result[v] = GearHelperVars.charInventory[v]
	end

	return result
end

local function ShouldDisplayNotEquippable(subType)
	if GearHelper.db.profile.computeNotEquippable == true then
		return GearHelper:IsValueInTable(GearHelper:GetEquippableTypes(), subType)
	end

	return false
end

local function ShouldBeCompared(itemLink)
	if not itemLink or string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r") then
		error(GHExceptionInvalidItemLink)
	-- return GHExceptionInvalidItemLink
	end

	local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

	if IsEquippedItem(id) then
		return error(GHExceptionAlreadyEquipped)
	-- return GHExceptionAlreadyEquipped
	end

	if not GearHelper:IsEquippableByMe(GearHelper:GetItemByLink(itemLink)) then
		error(GHExceptionNotEquippable)
	-- return GHExceptionNotEquippable
	end

	return true
end

function GearHelper:IsItemBetter(itemLink)
	GearHelper:BenchmarkCountFuncCall("GearHelper:IsItemBetter")
	local item = {}
	local itemEquipped = nil
	local id, _, _, equipLoc = GetItemInfoInstant(itemLink)

	if not pcall(ShouldBeCompared, itemLink) then
		return false
	end
	item = self:GetItemByLink(itemLink)

	local status, res = pcall(GearHelper.NewWeightCalculation, self, item)

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

	return tonumber(n)
end

function GearHelper:BuildItemFromTooltip(itemLink)
	GearHelper:BenchmarkCountFuncCall("GearHelper:BuildItemFromTooltip")
	local tip = ""
	local item = {}

	if not itemLink then
		error(GHExceptionInvalidItemLink)
	end

	if string.find(itemLink, "battlepet") then -- @todo : doesn't this needs to be localized ???
		error(GHExceptionInvalidItem)
	end

	tip = myTooltipFromTemplate or CreateFrame("GAMETOOLTIP", "myTooltipFromTemplate", nil, "GameTooltipTemplate")
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")
	if itemLink == -1 then
		print(debugstack())
	end
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetItemFromCache")
	for k, v in pairs(GearHelper.db.global.ItemCache) do
		if k == itemLink then
			return v
		end
	end
	return nil
end

function GearHelper:PutItemInCache(itemLink, item)
	GearHelper:BenchmarkCountFuncCall("GearHelper:PutItemInCache")
	GearHelper.db.global.ItemCache[itemLink] = item
end

function GearHelper:GetItemByLink(itemLink)
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetItemByLink")

	local item = GearHelper:GetItemFromCache(itemLink)

	if not item then
		item = GearHelper:BuildItemFromTooltip(itemLink)
		GearHelper:PutItemInCache(itemLink, item)
	end

	return item
end

local function ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
	local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
	return ApplyTemplateToDelta(delta)
end

function GearHelper:NewWeightCalculation(item)
	GearHelper:BenchmarkCountFuncCall("GearHelper:NewWeightCalculation")

	local result = {}

	if GearHelper:IsInventoryInCache() == false then
		error(GHExceptionInventoryNotCached)
	end

	local equippedItems = GetItemsByEquipLoc(item.equipLoc)

	if item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_FINGER" then
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = ApplyTemplateToDelta(item)
			else
				equippedItem = GearHelper:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	elseif item.equipLoc == "INVTYPE_WEAPON" or item.equipLoc == "INVTYPE_HOLDABLE" then
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = ApplyTemplateToDelta(item)
			elseif equippedItemLink == -1 then
				equippedItem = GearHelper:GetItemByLink(GearHelperVars.charInventory["MainHand"])
				result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			else
				equippedItem = GearHelper:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then
		if tonumber(equippedItems["MainHand"]) and tonumber(equippedItems["SecondaryHand"]) then
			result["MainHand"] = ApplyTemplateToDelta(item)
		elseif tonumber(equippedItems["MainHand"]) then
			equippedItem = GearHelper:GetItemByLink(equippedItems["SecondaryHand"])
			result["SecondaryHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
		elseif tonumber(equippedItems["SecondaryHand"]) then
			equippedItem = GearHelper:GetItemByLink(equippedItems["MainHand"])
			result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
		else
			local combinedItems = GearHelper:CombineTwoItems(GearHelper:GetItemByLink(equippedItems["MainHand"]), self:GetItemByLink(equippedItems["SecondaryHand"]))
			result["MainHand"] = ComputeWithTemplateDeltaBetweenItems(item, combinedItems)
		end
	else
		for slot, equippedItemLink in pairs(equippedItems) do
			if equippedItemLink == 0 then
				result[slot] = ApplyTemplateToDelta(item)
			else
				equippedItem = GearHelper:GetItemByLink(equippedItemLink)
				result[slot] = ComputeWithTemplateDeltaBetweenItems(item, equippedItem)
			end
		end
	end

	return result
end

function GearHelper:equipItem(inThisBag)
	GearHelper:BenchmarkCountFuncCall("GearHelper:equipItem")
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
					local item = GearHelper:GetItemByLink(itemLink)
					local status, result = pcall(GearHelper.NewWeightCalculation, GearHelper, item)

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
	end
end

-- Return false if the string passed in parameter is nil, empty or contains player name otherwise return true
local function IsTargetValid(target)
	if nil == target or "" == target or string.find(target, GetUnitName("player")) then
		return false
	end

	return true
end

-- Create a cliquable link from the name of a player that will be used for whisper to a player
function GearHelper:CreateLinkAskIfHeNeeds(debug, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
	GearHelper:BenchmarkCountFuncCall("GearHelper:CreateLinkAskIfHeNeeds")
	local message = message or "|cff1eff00|Hitem:13262::::::::100:105::::::|h[Porte-cendres ma Gueule]|h|r"
	local target = target or GetUnitName("player")

	if not GearHelper.db.profile.askLootRaid or not IsTargetValid(target) or string.find(string.lower(message), "bonus") then
		return
	end

	local couleur, tar = ""
	local _, classFile = UnitClass(target)
	local tar = ""

	if classFile ~= nil then
		tar = GearHelper:CouleurClasse(classFile) .. tostring(target) .. "|r"
	end

	local nameLink

	local OldSetItemRef = SetItemRef
	function SetItemRef(link, text, button, chatFrame)
		GearHelper:BenchmarkCountFuncCall("SetItemRef")
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
		if pcall(ShouldBeCompared, itemLink) then
			local item = GearHelper:GetItemByLink(itemLink)
			local quality = GetQualityFromColor(item.rarity)

			if quality ~= nil and quality < 5 then
				nameLink = GearHelper:ReturnGoodLink(itemLink, target, tar)

				if GearHelper:IsItemBetter(itemLink) then
					UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0, 80)
					print(GearHelper:ColorizeString(L["ask1"], "Yellow") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Yellow") .. itemLink)
					PlaySound(5274, "Master")
				end
			end
		end
	end
end

function GearHelper:LinesToAddToTooltip(result)
	GearHelper:BenchmarkCountFuncCall("GearHelper:LinesToAddToTooltip")
	local linesToAdd = {}

	if GearHelper:CountArray(result) == 1 then
		for _, v in pairs(result) do
			if v < 0 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThanGeneral"], "LightRed"))
			elseif math.floor(v) == 0 then
				table.insert(linesToAdd, L["itemEgal"])
			elseif math.floor(v) > 0 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThanGeneral"], "Better") .. math.floor(v))
			end
		end
	elseif GearHelper:CountArray(result) == 2 then
		for slot, weight in pairs(result) do
			if weight < 0 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "LightRed") .. " " .. slot)
			elseif math.floor(weight) == 0 then
				table.insert(linesToAdd, L["itemEgala"] .. " " .. slot)
			elseif math.floor(weight) > 0 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Better") .. " " .. slot .. " " .. L["itemBetterThan2"] .. math.floor(weight))
			end
		end
	end
	return linesToAdd
end

local function GetDropInfo(linesToAdd, itemLink)
	GearHelper:BenchmarkCountFuncCall("GetDropInfo")
	_, _, _, _, itemId = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	if GearHelper.itemsDropRate[itemId] ~= nil then
		table.insert(linesToAdd, L["DropRate"] .. GearHelper.itemsDropRate[itemId]["Rate"] .. "%")
		if GearHelper.itemsDropRate[itemId]["Zone"] ~= "" then
			table.insert(linesToAdd, L["DropZone"] .. GearHelper.itemsDropRate[itemId]["Zone"])
		end
		table.insert(linesToAdd, L["DropBy"] .. GearHelper.itemsDropRate[itemId]["Drop"])
	end
end

local function IsItemEquipLocValid(equipLoc)
	GearHelper:BenchmarkCountFuncCall("IsItemEquipLocValid")
	if equipLoc ~= nil and equipLoc ~= "" then
		return true
	end
	return false
end

local ModifyTooltip = function(self, ...)
	-- local pcallWorked, err = pcall() -- if no error : pcallWorked == true and err == nil
	--									-- if error : pcallWorked == false and err == "some error"
	if not GearHelper.db or not GearHelper.db.profile.addonEnabled then
		return
	end

	local _, itemLink = self:GetItem()
	local pcallWorked, err = pcall(ShouldBeCompared, itemLink)
	local linesToAdd = {}

	if (false == pcallWorked and GHExceptionAlreadyEquipped ~= err and not string.find(tostring(err), GHExceptionNotEquippable)) then
		GearHelper:Print("-----------------(pcall ShouldBeCompared false)-----------------")
		GearHelper:Print("error : " .. tostring(res))
	end

	if not pcallWorked and err == GHExceptionAlreadyEquipped then
		table.insert(linesToAdd, GearHelper:ColorizeString(L["itemEquipped"], "Yellow"))
	elseif not pcallWorked and string.find(tostring(err), GHExceptionNotEquippable) then
		local item = GearHelper:GetItemByLink(itemLink)
		if IsItemEquipLocValid(item.equipLoc) and ShouldDisplayNotEquippable(item.subType) then
			table.insert(linesToAdd, GearHelper:ColorizeString(L["itemNotEquippable"], "LightRed"))
			self:SetBackdropBorderColor(255, 0, 0)
		end
	elseif not pcallWorked then
		return
	elseif pcallWorked then
		local item = GearHelper:GetItemByLink(itemLink)
		local weightCalStatus, res = pcall(GearHelper.NewWeightCalculation, GearHelper, item)

		if (false == weightCalStatus) then -- and true ~= res) then
			GearHelper:Print("-----------------(pcall NewWeightCalculation false)-----------------")
			GearHelper:Print("error / res : " .. tostring(res))
		end

		if weightCalStatus then
			for _, v in pairs(res) do
				if math.floor(v) == 0 then
					self:SetBackdropBorderColor(255, 255, 0)
				elseif math.floor(v) > 0 then
					self:SetBackdropBorderColor(0, 255, 150)
				else
					self:SetBackdropBorderColor(255, 0, 0)
				end
			end
			linesToAdd = GearHelper:LinesToAddToTooltip(res)
		end
	end

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

-- Whisper to player a message asking him if he needs the item he just loots
function GearHelper:askIfHeNeed(link, sendTo)
	GearHelper:BenchmarkCountFuncCall("GearHelper:askIfHeNeed")
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

-- Overlay buttons needs to be rework, because they don't seems to work
function GearHelper:GetQuestReward()
	GearHelper:BenchmarkCountFuncCall("GearHelper:GetQuestReward")

	local numQuestChoices = GetNumQuestChoices()
	local isBetter = false

	if GearHelper.db.profile.autoAcceptQuestReward and numQuestChoices < 1 then
		GetQuestReward()
	elseif GearHelper.db.profile.autoAcceptQuestReward and numQuestChoices == 1 then
		GetQuestReward(1)
	else
		local weightTable = {}
		local prixTable = {}
		local altTable = {}

		for i = 1, numQuestChoices do
			local item = GearHelper:GetItemByLink(GetQuestItemLink("choice", i))

			if item.type ~= L["armor"] and item.type ~= L["weapon"] then
				return
			end

			local status, res = pcall(GearHelper.NewWeightCalculation, self, item)
			if (false == status) then
				GearHelper:Print('-----------------("if (true ~= status and true ~= res) then")-----------------')
				GearHelper:Print("status : " .. tostring(status))
				GearHelper:Print("status res : " .. tostring(res))
			end

			if status then
				local tmpTable = {}
				for _, result in pairs(res) do
					if result > 0 then
						table.insert(tmpTable, result)
					end
				end

				if GearHelper:CountArray(tmpTable) == 0 then
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:CreateLfrButtons")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:UpdateButtonsAndTooltips")
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
				textBoss = GearHelper:ColorizeString(bossName, "Red") .. GearHelper:ColorizeString(" " .. L["isDead"], "LightRed")
				bossTues = bossName and bossTues + 1
			elseif not isDead and bossName then
				textBoss = GearHelper:ColorizeString(bossName, "Green") .. GearHelper:ColorizeString(" " .. L["isAlive"], "LightGreen")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:UpdateSelecCursor")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:UpdateGHLfrButton")
	if not RaidFinderQueueFrame.GHLfrButtons then
		do
			return
		end
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:HideLfrButtons")
	local nbInstance = GetNumRFDungeons()
	for i = 1, nbInstance do
		local id, name = GetRFDungeonInfo(i)
		if _G["RaidFinderQueueFrameGHLfrButtons" .. id] then
			_G["RaidFinderQueueFrameGHLfrButtons" .. id]:Hide()
		end
	end
end

function GearHelper:ResetCache()
	GearHelper:BenchmarkCountFuncCall("GearHelper:ResetCache")
	GearHelper.db.global.ItemCache = {}
end

function GearHelper:AddIlvlOnCharFrame(show)
	GearHelper:BenchmarkCountFuncCall("GearHelper:AddIlvlOnCharFrame")
	local function CharFrameShow(frame)
		GearHelper:BenchmarkCountFuncCall("CharFrameShow")
		if not GearHelper.db.profile.ilvlCharFrame then
			do
				return
			end
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
		GearHelper:BenchmarkCountFuncCall("CharFrameHide")
		GearHelper:HideIlvlOnCharFrame()
	end

	PaperDollItemsFrame:HookScript("OnShow", CharFrameShow)
	PaperDollItemsFrame:HookScript("OnHide", CharFrameHide)

	if (show) then
		CharFrameShow()
	end
end

function GearHelper:HideIlvlOnCharFrame()
	GearHelper:BenchmarkCountFuncCall("GearHelper:HideIlvlOnCharFrame")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:AddIlvlOnInspectFrame")
	local function InspectFrameShow(frame)
		GearHelper:BenchmarkCountFuncCall("InspectFrameShow")
		if not GearHelper.db.profile.ilvlInspectFrame then
			do
				return
			end
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
		GearHelper:BenchmarkCountFuncCall("InspectFrameHide")
		GearHelper:HideIlvlOnInspectFrame()
	end

	InspectPaperDollItemsFrame:HookScript("OnShow", InspectFrameShow)
	InspectPaperDollItemsFrame:HookScript("OnHide", InspectFrameHide)

	if (show) then
		InspectFrameShow()
	end
end

function GearHelper:HideIlvlOnInspectFrame()
	GearHelper:BenchmarkCountFuncCall("GearHelper:HideIlvlOnInspectFrame")
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
	GearHelper:BenchmarkCountFuncCall("GearHelper:InitEquipLocInspect")
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
