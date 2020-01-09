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
	waitSpeTimer = nil,
	charInventory = {}
}

--{{ Local Vars }}
local allPrefix = {["askVersion" .. GearHelperVars.prefixAddon] = GearHelper.SendAnswerVersion, ["answerVersion" .. GearHelperVars.prefixAddon] = GearHelper.ReceiveAnswer}
local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")
local delaySpeTimer = 0.5
local delayNilTimer = 10
local waitNilFrame = CreateFrame("Frame")
local waitNilTimer = nil
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

-- TODO: Still useful ?
local function delayNilFrame(frame)
	GearHelper:BenchmarkCountFuncCall("delayNilFrame")
	if time() <= waitNilTimer + delayNilTimer then
		do
			return
		end
	end
	self.db = nil
	ReloadUI()
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

function GearHelper:SetDotOnIcons()
	self:BenchmarkCountFuncCall("GearHelper:SetDotOnIcons")
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

local ModifyTooltip = function(self, ...)
	-- local pCallWorked, err = pcall(anyFunction) 	-- if no error : pCallWorked == true and err == nil
	--												-- if error : pCallWorked == false and err == "some error"
	if not GearHelper.db or not GearHelper.db.profile.addonEnabled then
		return
	end

	local _, itemLink = self:GetItem()
	local shouldBeCompared, err = pcall(GearHelper.ShouldBeCompared, itemLink)
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