-- https://mothereff.in/lua-minifier
--------------------------- Définition des variables ---------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--ligne 609 le bloc a l'air foireux, le reprendre
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
		--minimapButton = false,
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
		buildVersion = 0,
		equipLocInspect = {}
	}
} -- NE PAS OUBLIER DE RAJOUTER LA VERSION PRÉCÉDENTE ICI APRÈS CHAQUE MISE A JOUR !!!!
--
--[[

--Supprimer les traduction doublon activé/désactivé et concatener phrase+activé/désactivé

]] local GHoldVersions = {
	"0.0",
	"0.1",
	"0.2",
	"0.3",
	"0.4",
	"0.5",
	"0.51",
	"0.6",
	"0.61",
	"0.7",
	"0.8",
	"0.9",
	"0.9.1",
	"1.0",
	"1.0.1",
	"1.0.2",
	"1.0.3",
	"1.1",
	"1.2",
	"1.3",
	"1.3.1",
	"1.3.2",
	"1.3.3",
	"1.4",
	"1.4.1",
	"1.4.2",
	"1.5",
	"1.5.1",
	"1.5.2",
	"1.5.3",
	"1.5.4",
	"1.5.5",
	"1.5.6",
	"1.5.7",
	"1.5.8",
	"1.5.9",
	"1.5.9.1",
	"1.6",
	"1.6.1",
	"1.6.2",
	"1.6.2.1",
	"1.6.3",
	"1.6.4",
	"1.6.5",
	"1.6.5.1",
	"1.6.5.2",
	"1.6.5.3",
	"1.6.5.4",
	"1.6.5.5",
	"1.6.5.6",
	"1.6.5.7",
	"1.6.5.8",
	"1.6.6",
	"1.6.6.1",
	"1.6.6.2",
	"1.7",
	"1.7.1",
	"1.7.2",
	"1.7.3",
	"1.7.4"
}

addonName = ... --, GH_Globals = ...
addonName = "GearHelper"
--L.stats = {}
--frameInterface = nil

version = GetAddOnMetadata(addonName, "Version")
versionCible = nil

waitingIDTable = {}

--print("Version actuelle : "..version)
local prefixAddon = "GeARHeLPeRPReFIX"
--..version -- rajouter version si on veut que notre addon ne comunique QUE avec les GH de la même version
local prefixForMars = "GHForMGTN"
-- ^ Pour le préfix, choisir un nom qu'on est sûr que personne d'autre ne réutilisera
--local L = AceLocale:GetLocale("GearHelper") -- permet de récupérer le text dans toutes les langues
local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

-- local allEvents = {}
local allPrefix = {["askVersion" .. prefixAddon] = sendAnswerVersion, ["answerVersion" .. prefixAddon] = receiveAnswer}
-- local nbSlotsBag = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
-- local eventHandler = CreateFrame("Frame")
local waitAnswerFrame = CreateFrame("Frame")
-- local loadFrame = CreateFrame("Frame")
local askTime, maxWaitTime = nil, 15
GearHelper.charInventory = {}

local specialisationID, specName, description, icon, background, role, primaryStat = nil
local itemLinkToAsk

-- waitSpeFrame = CreateFrame("Frame")
-- waitSpeTimer = nil
local waitNilFrame = CreateFrame("Frame")
local waitNilTimer = nil
numBag = 0

--local idMieux = {}

local nbRappels = 3

-- local function sendInfo()
-- 	local guid = UnitGUID(UnitName("player"))
-- 	local class, _, race, _, sex, name, realm = GetPlayerInfoByGUID(guid)
-- 	if sex == 1 then
-- 		sex = "Inconnu / Neutre"
-- 	elseif sex == 2 then
-- 		sex = "Male"
-- 	elseif sex == 3 then
-- 		sex = "Femelle"
-- 	end
-- 	local guildName, guildRankName = GetGuildInfo(name)
-- 	local message = (tostring(name).." utilise l'addon avec la version "..tostring(version).."\nc'est un "..tostring(race).." "..tostring(class).." "..tostring(sex).."\nGuilde : "..tostring(guildName).." / rang : "..tostring(guildRankName))
-- 	return message
-- end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
----------------- Fin de définition des variables -----------------

waitAnswerFrame:Hide()
-- waitSpeFrame:Hide()
waitNilFrame:Hide()

-------------------------------------------------------
-- Initialize addon configuration for the first time --
-- @author Raphaël Saget & Raphaël Daumas            --
-------------------------------------------------------
function GearHelper:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GearHelperDB", defaultsOptions)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetConfig")
	self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

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
				GearHelper:OnMinimapTooltipClick(button, tooltip)
			end,
			OnTooltipShow = function()
				GearHelper:OnMinimapTooltipShow(tooltip)
			end,
			OnLeave = function()
				tooltip:Hide()
			end
		}
	)
	icon:Register("GHIcon", GHIcon, self.db.profile.minimap)
end

--[[
Function :
Scope : GearHelper
Description :
Author : Raphaël Saget
]]
function GearHelper:RefreshConfig()
	-- C'est call quand ça ?
	-- GearHelper:Print("Refresh config called")

	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

--[[
Function : ResetConfig
Scope : GearHelper
Description : Reset addon to default value
Author : Raphaël Daumas
]]
function GearHelper:ResetConfig()
	GearHelper.db.profile.addonEnabled = nil --true
	GearHelper.db.profile.sellGreyItems = nil --true
	GearHelper.db.profile.autoGreed = nil --true
	GearHelper.db.profile.autoAcceptQuestReward = nil --false
	GearHelper.db.profile.autoNeed = nil --true
	GearHelper.db.profile.autoEquipLooted.actual = nil --false
	GearHelper.db.profile.autoEquipLooted.previous = nil --false
	GearHelper.db.profile.autoEquipWhenSwitchSpe = nil --false
	GearHelper.db.profile.weightTemplate = nil --"NOX"
	GearHelper.db.profile.lastWeightTemplate = nil --""
	--GearHelper.db.profile.minimapButton = false
	GearHelper.db.profile.autoRepair = nil --0
	GearHelper.db.profile.autoInvite = nil --true
	GearHelper.db.profile.autoTell = nil --true
	GearHelper.db.profile.inviteMessage = nil --"+GH123-"
	GearHelper.db.profile.askLootRaid = nil --true
	GearHelper.db.profile.printWhenEquip = nil --true
	GearHelper.db.profile.debug = nil --false
	GearHelper.db.profile.CW = nil --{}
	GearHelper.db.profile.ilvlOption = nil --false
	GearHelper.db.profile.ilvlWeight = nil --10
	GearHelper.db.profile.includeSocketInCompute = nil --true
	GearHelper.db.profile.computeNotEquippable = nil --true
	GearHelper.db.profile.whisperAlert = nil --true
	GearHelper.db.profile.sayMyName = nil --true
	GearHelper.db.profile.minimap = nil --{hide = false, isLock = false}
	GearHelper.db.profile.bossesKilled = nil --true
	GearHelper.db.profile.ilvlCharFrame = nil
	GearHelper.db.profile.ilvlInspectFrame = nil
	GearHelper.db.profile.inspectAin = nil

	GearHelper.db.global.ItemCache = nil --{}
	GearHelper.db.global.itemWaitList = nil --{}
	GearHelper.db.global.myNames = nil --""
	GearHelper.db.global.buildVersion = nil --0
	GearHelper.db.global.equipLocInspect = nil --{}

	InterfaceOptionsFrame:Hide()
	InterfaceOptionsFrame:Show()
	InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

--[[
Function :
Scope : GearHelper
Description :
Author : Raphaël Saget
]]
function GearHelper:OnEnable()
	-- Called when the addon is enabled
	-- Affiche à chaque connection l'état de l'addon
	if GearHelper.db.profile.addonEnabled then
		print(GearHelper:ColorizeString(L["Addon"], "Vert") .. GearHelper:ColorizeString(L["ActivatedGreen"], "Vert"))
		GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
		if (#GearHelper.db.global.equipLocInspect == 0) then
			GearHelper:InitEquipLocInspect()
		end
	else
		print(GearHelper:ColorizeString(L["Addon"], "Vert") .. GearHelper:ColorizeString(L["DeactivatedRed"], "Rouge"))
	end
end

function GearHelper:OnMinimapTooltipShow(tooltip)
	-- local p=tooltip:CreateFontString("myFirstPanel","OVERLAY")
	-- p:SetFont('Fonts\\ARIALN.ttf', 15, 'outline')
	-- p:SetTextColor(1, 0.82, 0)
	-- p:SetPoint("TOPLEFT")
	-- p:SetText(GearHelper:ColorizeString("GearHelper", self.db.profile.addonEnabled and "Vert" or "Rouge"))

	-- tooltip:SetFont

	tooltip:SetOwner(LibDBIcon10_GHIcon, "ANCHOR_TOPRIGHT", -15, -100)
	tooltip:SetText(GearHelper:ColorizeString("GearHelper", self.db.profile.addonEnabled and "Vert" or "Rouge"))
	if (not self.db.profile.addonEnabled) then
		tooltip:AddLine(GearHelper:ColorizeString(L["Addon"], "Jaune") .. GearHelper:ColorizeString(L["DeactivatedRed"], "Rouge"), 1, 1, 1)
	end
	tooltip:AddLine(GearHelper:ColorizeString(L["MmTtLClick"], "Jaune"), 1, 1, 1)
	if (self.db.profile.addonEnabled) then
		tooltip:AddLine(GearHelper:ColorizeString(L["MmTtRClickDeactivate"], "Jaune"), 1, 1, 1)
		if self.db.profile.minimap.isLock then
			tooltip:AddLine(GearHelper:ColorizeString(L["MmTtClickUnlock"], "Jaune"), 1, 1, 1)
		else
			tooltip:AddLine(GearHelper:ColorizeString(L["MmTtClickLock"], "Jaune"), 1, 1, 1)
		end
		tooltip:AddLine(GearHelper:ColorizeString(L["MmTtCtrlClick"], "Jaune"), 1, 1, 1)
	else
		tooltip:AddLine(GearHelper:ColorizeString(L["MmTtRClickActivate"], "Jaune"), 1, 1, 1)
	end
	--tooltip:AddLine("<Addon Summary>", 1, 1, 1)
	tooltip:Show()
end

function GearHelper:OnMinimapTooltipClick(button, tooltip)
	if (InterfaceOptionsFrame:IsShown()) then
		InterfaceOptionsFrame:Hide()
	else
		local icon = LibStub("LibDBIcon-1.0")
		if IsShiftKeyDown() then
			if (self.db.profile.minimap.isLock) then
				icon:Unlock("GHIcon")
			else
				icon:Lock("GHIcon")
			end
			self.db.profile.minimap.isLock = not self.db.profile.minimap.isLock

			-- trouver un moyen de reset tooltip
			tooltip:Hide()
			GearHelper:OnMinimapTooltipShow(tooltip)
		elseif IsControlKeyDown() then
			icon:Hide("GHIcon")
			self.db.profile.minimap.hide = true
		else
			--GameTooltip:Show()
			if (button == "LeftButton") then
				InterfaceOptionsFrame:Show()
				InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
			else
				-- trouver un moyen de reset icon
				self.db.profile.addonEnabled = not self.db.profile.addonEnabled

				-- trouver un moyen de reset tooltip
				tooltip:Hide()
				GearHelper:OnMinimapTooltipShow(tooltip)
			end
		end
	end
end

--[[
Function :
Scope : GearHelper
Description :
Author : Raphaël Saget
]]
function GearHelper:OnDisable()
	-- Called when the addon is disabled
end

-- desc : Reset all options
-- entrée : ø
-- sortie : ø
-- commentaire :
function GearHelper:setDefault()
	GearHelper.db = nil
	-- GearHelper.db.profile.addonEnabled = nil
	-- GearHelper.db.profile.sellGreyItems = nil
	-- GearHelper.db.profile.autoGreed = nil
	-- GearHelper.db.profile.autoAcceptQuestReward = nil
	-- GearHelper.db.profile.autoNeed = nil
	-- GearHelper.db.profile.autoEquipLooted.actual = nil
	-- GearHelper.db.profile.autoEquipLooted.previous = nil
	-- GearHelper.db.profile.autoEquipWhenSwitchSpe = nil
	-- GearHelper.db.profile.weightTemplate = nil
	-- GearHelper.db.profile.lastWeightTemplate = nil
	-- GearHelper.db.profile.minimapButton = nil
	-- GearHelper.db.profile.autoRepair = nil
	-- GearHelper.db.profile.autoInvite = nil
	-- GearHelper.db.profile.autoTell = nil
	-- GearHelper.db.profile.inviteMessage = nil
	-- GearHelper.db.profile.askLootRaid = nil
	-- GearHelper.db.profile.printWhenEquip = nil
	-- GearHelper.db.profile.debug = nil
	-- GearHelper.db.profile.CW = nil
	-- GearHelper.db.profile.ilvlOption = nil
	-- GearHelper.db.profile.ilvlWeight = nil
	-- GearHelper.db.profile.includeSocketInCompute = nil
	-- GearHelper.db.profile.computeNotEquippable = nil
	-- GearHelper.db.profile.whisperAlert = nil
	-- GearHelper.db.profile.sayMyName = nil
	-- GearHelper.db.profile.minimap = nil

	-- GearHelper.db.global.ItemCache = nil
	-- GearHelper.db.global.itemWaitList = nil
	-- GearHelper.db.global.myNames = nil
	ReloadUI()
end

-- desc : Modify the message to whisp you to be invite in your group
-- entrée : The message to be whispered
-- sortie : ø
-- commentaire :
-- @author : Raphaël Daumas
function GearHelper:setInviteMessage(valeur)
	if valeur ~= nil then
		GearHelper.db.profile.inviteMessage = tostring(valeur)
		print(L["InviteMessage"] .. tostring(GearHelper.db.profile.inviteMessage))
	end
end

function GearHelper:ShowMessageSMN(channel, sender, msg)
	local stop = false
	local i = 1
	if (GearHelper.db.profile.sayMyName and msg ~= nil) then
		local arrayNames = GearHelper:MySplit(GearHelper.db.global.myNames, ",")
		if (msg ~= nil and arrayNames[i] ~= nil) then
			while (not stop and arrayNames[i]) do
				if (string.match(msg:lower(), arrayNames[i]:lower())) then
					UIErrorsFrame:AddMessage(channel .. " [" .. sender .. "]: " .. msg, 0.0, 1.0, 0.0, 5.0, 4)
					PlaySound(5275, "Master")
					stop = true
					do
						return
					end
				end
				i = i + 1
			end
		end
	end
end

-- desc : Add a string to the "array" of names
-- entrée :
-- sortie : ø
-- commentaire :
-- @author : Raphaël Daumas
function GearHelper:setMyNames(valeur)
	if valeur ~= nil then
		GearHelper.db.global.myNames = tostring(valeur .. ",")
	--print(L["InviteMessage"]..tostring( GearHelper.db.profile.inviteMessage ))
	end
end

-- desc : Envoie dans la guilde / raid / groupe une demande aux autres GH pour savoir s'ils sont à jour
-- entrée : ø
-- sortie : ø
-- commentaire :
-- @author : Raphaël Daumas
function GearHelper:sendAskVersion()
	if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
		C_ChatInfo.SendAddonMessageLogged(prefixAddon, "askVersion;" .. version, "RAID")
	end
	if IsInGuild() ~= nil and IsInGuild() == true then
		C_ChatInfo.SendAddonMessageLogged(prefixAddon, "askVersion;" .. version, "GUILD")
	end

	askTime = time()
	waitAnswerFrame:Show()
end

-- desc : Quand on reçoit une demande de version, l'addon utilise cette fonction qui envoit la réponse
-- entrée : ø
-- sortie : ø
-- commentaire :
-- @author : Raphaël Daumas
function GearHelper:sendAnswerVersion()
	if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
		C_ChatInfo.SendAddonMessageLogged(prefixAddon, "answerVersion;" .. version, "RAID")
	-- C_ChatInfo.SendAddonMessageLogged(prefixForMars, sendInfo(), "RAID")
	end
	if IsInGuild() ~= nil and IsInGuild() == true then
		C_ChatInfo.SendAddonMessageLogged(prefixAddon, "answerVersion;" .. version, "GUILD")
	-- C_ChatInfo.SendAddonMessageLogged(prefixForMars, sendInfo(), "GUILD")
	end
end

-- desc : Vérifie si l'addon est à jour quand il recoit une réponse
-- entrée : string (version de la cible), string (nom de la cible)
-- sortie : string (message si l'addon n'est pas à jour, sinon rien)
-- commentaire :
-- @author : Raphaël Daumas
function GearHelper:receiveAnswer(msgV, msgC)
	if askTime and nbRappels > 0 and not GearHelper:IsInTable(GHoldVersions, msgV) and versionCible ~= version then
		message(L["maj1"] .. GearHelper:ColorizeString(version, "Rouge") .. L["maj2"] .. GearHelper:ColorizeString(msgV, "Vert") .. L["maj3"] .. msgC .. " (Curse)")
		askTime = nil
		waitAnswerFrame:Hide()
		nbRappels = nbRappels - 1
	end
end

waitAnswerFrame:SetScript(
	"OnUpdate",
	function(self, elapsed)
		if askTime and (time() - askTime) > maxWaitTime then
			askTime = nil
			waitAnswerFrame:Hide()
		end
	end
)

-- waitSpeFrame:SetScript("OnUpdate", function( self )
-- 	if time() > waitSpeTimer + 0.5 then
-- 		for bag = 0,4 do
-- 			numBag = bag
-- 			GearHelper:equipItem()
-- 		end
-- 		self:Hide()
-- 	end
-- end)

waitNilFrame:SetScript(
	"OnUpdate",
	function(self)
		if time() > waitNilTimer + 10 then
			setDefault()
			self:Hide()
		end
	end
)

-------------------------------------------------------------------------------
-- FONCTIONS --
-------------------------------------------------------------------------------

--[[
Function : GetEquippedItemLink
Scope : GearHelper
Description : Get item link from an inventory slot
Input : slotID = the slot to query
Output : itemLink of the slot or 0 if no item and -2 if waiting for event
Author : Raphaël Saget
Thanks to : lightspark@wowinterface
]]
function GearHelper:GetEquippedItemLink(slotID, slotName)
	local itemLink = GetInventoryItemLink("player", slotID)
	local itemID = GetInventoryItemID("player", slotID)
	local itemString, itemName

	--If itemLink is not null (there is an object) try to get itemName
	if itemLink then
		itemString, itemName = itemLink:match("|H(.*)|h%[(.*)%]|h")
	end

	--If no itemID then there is no object in slot
	if itemID then
		--If no itemName there is an item but it is not in cache
		if not itemName or itemName == "" then
			GetItemInfo(itemID) -- for GET_ITEM_INFO_RECEIVED
			GearHelper.db.global.itemWaitList[itemID] = slotName
			return -2
		else
			return itemLink
		end
	else
		return 0
	end
end

--[[
Function :
Scope : GearHelper
Description :
Input :
Output :
Author : Raphaël Saget
]]
function GearHelper:ScanCharacter()
	GearHelper.charInventory["Head"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("HeadSlot"), "HeadSlot")
	GearHelper.charInventory["Neck"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("NeckSlot"), "NeckSlot")
	GearHelper.charInventory["Shoulder"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("ShoulderSlot"), "ShoulderSlot")
	GearHelper.charInventory["Back"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("BackSlot"), "BackSlot")
	GearHelper.charInventory["Chest"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("ChestSlot"), "ChestSlot")
	GearHelper.charInventory["Wrist"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("WristSlot"), "WristSlot")
	GearHelper.charInventory["Hands"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("HandsSlot"), "HandsSlot")
	GearHelper.charInventory["Waist"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("WaistSlot"), "WaistSlot")
	GearHelper.charInventory["Legs"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("LegsSlot"), "LegsSlot")
	GearHelper.charInventory["Feet"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("FeetSlot"), "FeetSlot")
	GearHelper.charInventory["Finger0"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Finger0Slot"), "Finger0Slot")
	GearHelper.charInventory["Finger1"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Finger1Slot"), "Finger1Slot")
	GearHelper.charInventory["Trinket0"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Trinket0Slot"), "Trinket0Slot")
	GearHelper.charInventory["Trinket1"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("Trinket1Slot"), "Trinket1Slot")
	GearHelper.charInventory["MainHand"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("MainHandSlot"), "MainHandSlot")
	GearHelper.charInventory["SecondaryHand"] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo("SecondaryHandSlot"), "SecondaryHandSlot")

	if GearHelper.charInventory["MainHand"] ~= -2 and GearHelper.charInventory["MainHand"] ~= 0 then
		local _, _, _, _, _, _, _, _, itemEquipLocWeapon = GetItemInfo(GearHelper.charInventory["MainHand"])

		if itemEquipLocWeapon == "INVTYPE_2HWEAPON" or itemEquipLocWeapon == "INVTYPE_RANGED" then
			GearHelper.charInventory["SecondaryHand"] = -1
		end
	end
end

-- -- desc : Fonction qui parse un link en ID
-- -- entrée : itemLink ( EX : |Hitem:124586:0:0:0:0:12254684455852 )
-- -- sortie : ID ( EX : 124586 )
-- -- commentaire :
-- function GearHelper:parseID(link)
-- 	local a = string.match(link, "item[%-?%d::]+")
-- 	local b = string.sub(a, 5, 12)
-- 	local c = string.gsub(b, ":", "")
-- 	return c
-- end

--[[
Function : poseDot
Scope : GearHelper
Description : Add a green dot on itemIcon in bag if it's better than what is equiped
Author : Raphaël Daumas
]]
function GearHelper:poseDot()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local myBag = bag + 1
			local mySlot = GetContainerNumSlots(bag) - (slot - 1)
			local button = _G["ContainerFrame" .. myBag .. "Item" .. mySlot]

			if button.overlay then
				button.overlay:SetShown(false)
				button.overlay = nil
			end

			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink then
				if GearHelper:DoDisplayOverlay(GearHelper:IsItemBetter(itemLink, "ItemLink")) then
					if not button.overlay then
						button.overlay = button:CreateTexture(nil, "OVERLAY")
						button.overlay:SetSize(18, 18)
						button.overlay:SetPoint("TOPLEFT")
						button.overlay:SetTexture("Interface\\AddOns\\GearHelper\\Textures\\flecheUp")
						button.overlay:SetShown(true)
					end
				end
			end
		end
	end
	ContainerFrame_UpdateAll()
end

--[[
Function : GetStatFromTemplate
Scope : local
Description : Get a stat based on a string from the selected stat template
Input : stat = string representing the stat we want
Output : nil if stat not found or the stat from the template
Author : Raphaël Saget
]]
local function GetStatFromTemplate(stat)
	if GearHelper.db.profile.weightTemplate == "NOX" or GearHelper.db.profile.weightTemplate == "NOX_ByDefault" then
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		if GearHelper.db.global.templates[currentSpec]["NOX"][stat] ~= nil then
			return GearHelper.db.global.templates[currentSpec]["NOX"][stat]
		else
			return nil
		end
	else
		if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate][stat] ~= nil then
			return GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate][stat]
		else
			return nil
		end
	end
end

--[[
Function : ApplyTemplateToDelta
Scope : GearHelper
Description : Apply weight value from selected template to delta
Input : delta = the delta between 2 items
Output : valueItem = number representing value diff between 2 items or "notAdapted" if all stat of the items are not relevant in the user template
Author : Raphaël Saget
]]
function GearHelper:ApplyTemplateToDelta(delta)
	local valueItem = 0
	local mainStat = GearHelper:FindHighestStatInTemplate()
	local areAllValueZero = true --Some items have all their stats out of template so the are barely useless but 0 mean equivalent so we put a negative value at end
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

--[[
Function : IsItemBetter
Scope : GearHelper
Description : Build item or retrieve it from cache and calculate is value
Input : object = tooltip or itemlink / type = "ItemLink" or "ToolTip", the type of input "object"
Output : the normalized value of the item
Author : Raphaël Saget
]]
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

--[[
Function : BuildItemFromTooltip
Scope : GearHelper
Description : Build an item object from a tooltip or an itemLink
Input : object = a tooltip or an itemLink, type = "ToolTip" or "ItemLink"
Output : item = the item builded
Author : Raphaël Saget
]]
function GearHelper:BuildItemFromTooltip(object, type)
	local tip = ""
	local item = {}
	local textures = {}
	local n = 0
	-- print("BuildItemFromTooltip "..type)
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

--[[
Function : GetItemFromCache
Scope : GearHelper
Description : Retrieve an item from cache based on his itemLink
Input : itemLink = itemLink of the object
Output : item = the item in cache or nil if not found
Author : Raphaël Saget
]]
function GearHelper:GetItemFromCache(itemLink)
	for k, v in pairs(GearHelper.db.global.ItemCache) do
		if k == itemLink then
			return v
		end
	end
	return nil
end

--[[
Function : PutItemInCache
Scope : GearHelper
Description : Put an item in global GH cache
Input : itemLink = itemLink of the object / item = the item to put in cache
Output :
Author : Raphaël Saget
]]
function GearHelper:PutItemInCache(itemLink, item)
	GearHelper.db.global.ItemCache[itemLink] = item
end

--[[
Function : GetItemByLink
Scope : GearHelper
Description : Retrieve an item object based on an itemLink
Input : itemLink = itemLink of the object
Output : item = the object
Author : Raphaël Saget
]]
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

--[[
Function : NewWeightCalculation
Scope : GearHelper
Description : The core calculation function
Input : item = an item to test | myEquipItem : another item to test instead of player equippedItem (FACULTATIF)
Output : result = the value of the item
Author : Raphaël Saget
]]
function GearHelper:NewWeightCalculation(item, myEquipItem)
	if GearHelper.db.profile.addonEnabled then -- si addon activé
		local result = {}
		if not IsEquippedItem(item.id) and GearHelper:IsEquippableByMe(item) then
			local tabSpec = GetItemSpecInfo(item.itemLink)
			local isSlotEmpty = GearHelper:IsSlotEmpty(item.equipLoc)
			--Item in inventory is not in cache, we return nil and the item that we were testing
			if not isSlotEmpty then
				-- GearHelper:Print("NewWeightCalculation : Inventory not cached")
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
							equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory[slotsList[index]])
						end
						local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
						table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
					else --The slot is empty, we pass directly the item
						local tmpResult = GearHelper:ApplyTemplateToDelta(item)
						if type(tmpResult) == "string" and tmpResult == "notAdapted" then
							table.insert(result, "betterThanNothing")
						else
							table.insert(result, tmpResult)
						end
					end
				end
			elseif item.equipLoc == "INVTYPE_WEAPON" then -- Masse à une main / épée à 1 main / Dague 1 main
				if isSlotEmpty[1] and isSlotEmpty[2] then --Nothing in both hands
					local tmpResult = GearHelper:ApplyTemplateToDelta(item)
					if type(tmpResult) == "string" and tmpResult == "notAdapted" then
						table.insert(result, "betterThanNothing")
					else
						table.insert(result, tmpResult)
					end
				elseif isSlotEmpty[1] and not isSlotEmpty[2] then -- Slot 1 empty / Slot 2 full
					local tmpResult = GearHelper:ApplyTemplateToDelta(item)
					if type(tmpResult) == "string" and tmpResult == "notAdapted" then
						table.insert(result, "betterThanNothing")
					else
						table.insert(result, tmpResult)
					end
				elseif not isSlotEmpty[1] and isSlotEmpty[2] and GearHelper.charInventory["SecondaryHand"] == -1 then -- Slot 2 empty because mainhand is 2 hand
					local equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["MainHand"])
					local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
					table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
				elseif not isSlotEmpty[1] and isSlotEmpty[2] and GearHelper.charInventory["SecondaryHand"] == 0 then
					local tmpResult = GearHelper:ApplyTemplateToDelta(item)
					if type(tmpResult) == "string" and tmpResult == "notAdapted" then
						table.insert(result, "betterThanNothing")
					else
						table.insert(result, tmpResult)
					end
				elseif not isSlotEmpty[1] and not isSlotEmpty[2] then
					local equippedItemMH = GearHelper:GetItemByLink(GearHelper.charInventory["MainHand"])
					local equippedItemSH = GearHelper:GetItemByLink(GearHelper.charInventory["SecondaryHand"])
					local deltaMH = GearHelper:GetStatDeltaBetweenItems(item, equippedItemMH)
					local deltaSH = GearHelper:GetStatDeltaBetweenItems(item, equippedItemSH)
					table.insert(result, GearHelper:ApplyTemplateToDelta(deltaMH))
					table.insert(result, GearHelper:ApplyTemplateToDelta(deltaSH))
				end
			elseif item.equipLoc == "INVTYPE_2HWEAPON" or item.equipLoc == "INVTYPE_RANGED" then -- baton / Canne à pêche / hache à 2 main / masse 2 main / épée 2 main AND arc
				if isSlotEmpty[1] and isSlotEmpty[2] then
					local tmpResult = GearHelper:ApplyTemplateToDelta(item)
					if type(tmpResult) == "string" and tmpResult == "notAdapted" then
						table.insert(result, "betterThanNothing")
					else
						table.insert(result, tmpResult)
					end
				elseif isSlotEmpty[1] and not isSlotEmpty[2] then
					local equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["SecondaryHand"])
					local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
					table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
				elseif not isSlotEmpty[1] and isSlotEmpty[2] then
					local equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["MainHand"])
					local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
					table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
				elseif not isSlotEmpty[1] and not isSlotEmpty[2] and GearHelper.charInventory["SecondaryHand"] == -1 then
					local equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["MainHand"])
					local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
					table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
				elseif not isSlotEmpty[1] and not isSlotEmpty[2] then
					local MHequippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["MainHand"])
					local SHequippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["SecondaryHand"])
					local totalMHandSH = {}
					for k, v in pairs(MHequippedItem) do
						if type(v) == "numbers" then
							totalMHandSH[k] = v + SHequippedItem[k]
						end
					end
					local delta = GearHelper:GetStatDeltaBetweenItems(item, totalMHandSH)
					table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
				end
			else
				if isSlotEmpty[1] == false then -- Si il y a un item equipé
					if GearHelper.charInventory[GearHelper.itemSlot[item.equipLoc]] == -1 then --If this is a offhand weapon and we have a 2h equipped
						local equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory["MainHand"])
						local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
						table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
					else
						local equippedItem = GearHelper:GetItemByLink(GearHelper.charInventory[GearHelper.itemSlot[item.equipLoc]])
						local delta = GearHelper:GetStatDeltaBetweenItems(item, equippedItem)
						table.insert(result, GearHelper:ApplyTemplateToDelta(delta))
					end
				else
					local tmpResult = GearHelper:ApplyTemplateToDelta(item)
					if type(tmpResult) == "string" and tmpResult == "notAdapted" then
						table.insert(result, "betterThanNothing")
					else
						table.insert(result, tmpResult)
					end
				end
			end
		else
			table.insert(result, "notEquippable")
		end
		return result
	end
end

---------------- Empecher si donjon marcheurs du temps    is in instance 		local _, _, difficulty = GetInstanceInfo()
--[[
Function : equipItem
Scope : GearHelper
Description : Equipe les items du sac qui sont mieux que ceeux équipés
Input : num du sac pour équiper le contenu d'un sac en particulier. Si rien est rentré, équipe le sac 0
Author : Raphaël Daumas
]]
function GearHelper:equipItem(inThisBag)
	local bagToEquip = inThisBag or 0
	local _, typeInstance, difficultyIndex = GetInstanceInfo()

	waitEquipFrame = CreateFrame("Frame")
	waitEquipTimer = time()
	waitEquipFrame:Hide()
	waitEquipFrame:SetScript(
		"OnUpdate",
		function(self, elapsed)
			if time() > waitEquipTimer + 0.5 then
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
								-- print("equipItem s'est prit un -1010, on annule")
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
						-- end
					end
					self:Hide()
				end
			end
		end
	)
	waitEquipFrame:Show()
end

--[[
Function : GetQualityFromColor
Scope : local
Description : Retourne l'entier qu'on aurait eu en utilisant GetItemInfo
Input : string (la couleur (hex) de l'item)
Output : number (la couleur reetournée par GetItemInfo)
Author : Raphaël Daumas
]]
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

------------------------------------------------------------------
-- Create a clickable link to ask a player if he needs his loot --
-- @author Raphaël Daumas                                       --
function GearHelper:CreateLinkAskIfHeNeeds(debug, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter) ------------------------------------------------------------------
	local message = message or "|cff1eff00|Hitem:13262::::::::100:105::::::|h[Porte-cendres ma Gueule]|h|r"
	-- local sender = sender or "sender"
	-- local language = language or "language"
	-- local channelString = channelString or "channelString"
	local target = target or GetUnitName("player")
	-- local flags = flags or "DND"
	-- local unknown1 = unknown1 or 1
	-- local channelNumber = channelNumber or 1
	-- local channelName = channelName or "channelName"
	-- local unknown2 = unknown2 or 0
	-- local counter = counter or 1
	if target ~= nil and target ~= GetUnitName("player") and target ~= "" and GearHelper.db.profile.askLootRaid or debug == 1 then
		if string.find(string.lower(message), "bonus") == nil or debug == 1 then
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
				-- print("link : "..link)
				if func == "askIfHeNeed" then
					local _, nomPerso, itID, persoLink = strsplit("_", link)
					local _, theItemLink = GetItemInfo(itID)
					local itemTable = GearHelper:GetItemByLink(theItemLink)
					local itLink1 = itemTable.itemLink
					-- local name, link, quality, iLevel, reqLevel, itLink1, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itID)

					GearHelper:askIfHeNeed(itLink1, nomPerso)
				else
					OldSetItemRef(link, text, button, chatFrame)
				end
			end

			for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
				local itemTable = GearHelper:GetItemByLink(itemLink)
				local quality = GetQualityFromColor(itemTable.rarity)

				if quality ~= nil and quality < 5 or debug == 1 then
					itemLinkToAsk = itemLink
					nameLink = GearHelper:ReturnGoodLink(itemLink, target, tar)

					if debug ~= 1 then
						local weightCalcResult = GearHelper:IsItemBetter(itemLink, "ItemLink")

						-- local itemScan = GearHelper:GetItemByLink(itemLink)
						-- local iL, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc
						-- print("----------")
						-- print("")

						if weightCalcResult ~= nil then
							if #weightCalcResult == 1 then
								if weightCalcResult[1] > 0 then
									UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Jaune") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Jaune") .. itemLink, 0.0, 1.0, 0.0, 80)
									print(GearHelper:ColorizeString(L["ask1"], "Jaune") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Jaune") .. itemLink)
									PlaySound(5274, "Master")
								end
							else
								if weightCalcResult[1] ~= nil and weightCalcResult[1] > 0 or weightCalcResult[2] ~= nil and weightCalcResult[2] > 0 then
									UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Jaune") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Jaune") .. itemLink, 0.0, 1.0, 0.0, 80)
									print(GearHelper:ColorizeString(L["ask1"], "Jaune") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Jaune") .. itemLink)
									PlaySound(5274, "Master")
								end
							end
						else
							GearHelper:Print("WeightCalcResult nil")
						end
					elseif debug == 1 then
						UIErrorsFrame:AddMessage(GearHelper:ColorizeString(L["ask1"], "Jaune") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Jaune") .. itemLink, 0.0, 1.0, 0.0, 80)
						print(GearHelper:ColorizeString(L["ask1"], "Jaune") .. nameLink .. GearHelper:ColorizeString(L["ask2"], "Jaune") .. itemLink)
						PlaySound(5274, "Master")
					end
				end
			end
		end
	end
end

--[[
Function : LinesToAddToTooltip
Scope : GearHelper
Description :
Input :
Output :
Author : Raphaël Saget
]]
function GearHelper:LinesToAddToTooltip(result, item)
	local linesToAdd = {}
	if GearHelper.db.profile.computeNotEquippable == false and result[1] == -20 or result[1] == -40 then --nil or not equippable
		do
			return
		end
	else
		if #result == 1 then
			if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThanGeneral"], "Rouge"))
			elseif result[1] == -60 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemEquipped"], "Jaune"))
			elseif result[1] == 0 then
				table.insert(linesToAdd, L["itemEgal"])
			elseif result[1] == -50 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux"))
			elseif result[1] > 0 then
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThanGeneral"], "Mieux") .. math.floor(result[1]))
			end
		elseif #result == 2 then
			if item.equipLoc == "INVTYPE_TRINKET" then
				if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
					-- avec une valeur de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "Rouge") .. " Trinket0")
				elseif result[1] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket0")
				elseif result[1] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux") .. " Trinket0")
				elseif result[1] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Mieux") .. " Trinket0 " .. L["itemBetterThan2"] .. math.floor(result[1]))
				end
				if result[2] == -30 or result[2] == -10 or IsEquippableItem(item.id) and result[2] == -20 then
					-- avec une valeur de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "Rouge") .. " Trinket1")
				elseif result[2] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket1")
				elseif result[2] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux") .. " Trinket1")
				elseif result[2] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Mieux") .. " Trinket1 " .. L["itemBetterThan2"] .. math.floor(result[2]))
				end
			elseif item.equipLoc == "INVTYPE_FINGER" then
				if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
					-- avec une valeur de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "Rouge") .. " Finger0")
				elseif result[1] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket0")
				elseif result[1] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux") .. " Finger0")
				elseif result[1] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Mieux") .. " Finger0 " .. L["itemBetterThan2"] .. math.floor(result[1]))
				end
				if result[2] == -30 or result[2] == -10 or IsEquippableItem(item.id) and result[2] == -20 then
					-- avec une valeur de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "Rouge") .. " Finger1")
				elseif result[2] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket1")
				elseif result[2] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux") .. " Finger1")
				elseif result[2] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Mieux") .. " Finger1 " .. L["itemBetterThan2"] .. math.floor(result[2]))
				end
			elseif item.equipLoc == "INVTYPE_WEAPON" then
				if result[1] == -30 or result[1] == -10 or IsEquippableItem(item.id) and result[1] == -20 then
					-- avec une valeur de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "Rouge") .. L["mainD"])
				elseif result[1] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket0")
				elseif result[1] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux") .. L["mainD"])
				elseif result[1] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Mieux") .. L["mainD"] .. L["itemBetterThan2"] .. math.floor(result[1]))
				end
				if result[2] == -30 or result[2] == -10 or IsEquippableItem(item.id) and result[2] == -20 then
					-- avec une valeur de "..math.floor(value))
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThan"], "Rouge") .. L["mainG"])
				elseif result[2] == 0 then
					table.insert(linesToAdd, L["itemEgala"] .. "Trinket1")
				elseif result[2] == -50 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["betterThanNothing"], "Mieux") .. L["mainG"])
				elseif result[2] > 0 then
					table.insert(linesToAdd, GearHelper:ColorizeString(L["itemBetterThan"], "Mieux") .. L["mainG"] .. L["itemBetterThan2"] .. math.floor(result[2]))
				end
			else
				table.insert(linesToAdd, GearHelper:ColorizeString(L["itemLessThanGeneral"], "Rouge"))
			end
		end
	end
	return linesToAdd
end

local ModifyTooltip = function(self, ...)
	if GearHelper.db ~= nil and GearHelper.db.profile.addonEnabled == true then
		local _, itemLink = self:GetItem()

		if itemLink and not string.match(itemLink, "|cffffffff|Hitem:::::::::(%d*):(%d*)::::::|h%[%]|h|r") then --The itemlink skipped is the one returned by dungeon reward so things turn wrong, thanks blizzard
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
					self:SetBackdropBorderColor(0, 255, 150) -- "vert"
				end

				if #result == 2 then
					if result[2] == 0 then
						self:SetBackdropBorderColor(255, 255, 0) -- Jaune
					elseif result[2] == -50 or result[2] > 0 then
						self:SetBackdropBorderColor(0, 255, 150) -- "Vert"
					end
				end

				for _, v in pairs(linesToAdd) do
					self:AddLine(v)
				end
			end
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

-----------------------------------------------------------------
-- Whisper to the right player, the right text,                --
--      in the right language to ask him if he needs his loot. --
-- @author Raphaël Daumas                                      --
-----------------------------------------------------------------
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
			--local unitLocale = "frFR"
			if unitLocale == nil then
				unitLocale = "enUS"
			end
			local theSource = "demande4" .. unitLocale
			local theSource2 = "demande4" .. unitLocale .. "2"
			local msg = L[theSource] .. itemLink .. L[theSource2] .. "?" ~= nil and L[theSource] .. itemLink .. L[theSource2] .. "?" or L["demande4enUS"] .. itemLink .. L["demande4enUS2"] .. "?"
			-- if msg == nil then
			--     msg = L["demande4enUS"]
			-- end
			local rep = "rep" .. unitLocale
			local rep2 = "rep" .. unitLocale .. "2"
			local msgRep = L[rep] .. L["maLangue"..unitLocale] .. L[rep2] ~= nil and L[rep] .. L["maLangue"..unitLocale] .. L[rep2] or L["repenUS"] .. L["maLangue"..unitLocale]

			-- if msgRep == nil then
			--     msgRep = L["repenUS"]..L["maLangue"]
			-- end
			-- if unitLocale == "deDE" then
			--     SendChatMessage(msg..itemLink..L["demande4deDE2"].." ?", "WHISPER", "Common", sendTo)
			-- else
			SendChatMessage(msg, "WHISPER", "Common", sendTo)
			SendChatMessage(msgRep, "WHISPER", "Common", sendTo)
			-- end
			StaticPopup_Hide("AskIfHeNeed")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3 -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show("AskIfHeNeed")
end

-- tabWaitItem = {}
-- local function RegisterItemInfo(item)
-- 	if GetItemInfo(item) == nil then
-- 		local isItemAlreadyInTab = false
-- 		for i=0, #tabWaitItem do
-- 			if tabWaitItem[i] == item then
-- 				isItemAlreadyInTab = true
-- 			end
-- 		end
-- 		if isItemAlreadyInTab == false then
-- 			table.insert(tabWaitItem, item)
-- 		end
-- 		return false
-- 	else
-- 		return GetItemInfo(item)
-- 	end
-- end

-- GearHelper:Print("")
--[[
Function : GetQuestReward
Scope : GearHelper
Description : Accept quest if theres one or less items. If there's more, chose the best or the most expensive
Input : ø
Output :ø
Author : Raphaël Daumas
]]
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
			-- subType = itemTable.subType
			itemSellPrice1 = itemTable.sellPrice

			-- , , _, _, _, typeI, subTypeI, _, _, _, itemSellPrice1 = GetItemInfo(objetI)
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
				-- local _, _, _, _, _, _, _, _, _, _, itemSellPrice1 = GetItemInfo(objetI)
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
		-- table.sort( prixTriee )

		-- print("prix table ----")
		-- foreach(prixTriee, print)
		-- print("fin prix table ------")

		--print("maxweight : "..maxWeight)
		-- button = nil
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
				--GetQuestReward(keyWeight) -- normalement c'est bon
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
				--GetQuestReward(keyPrix) -- normalement c'est bon
				local objetI = GetQuestItemLink("choice", keyPrix)
				print("On prend " .. objetI)
			end

			do
				return
			end
		end
	end
end

-- GearHelper:Print("")
--[[
Function : AutoGreedAndNeed
Scope : GearHelper
Description : Automatically chose the best option when loot roll in instance
Input : number --> loot number in order of appearence
Output :ø
Améliorations : Ajouter auto dez si besoin
Author : Raphaël Daumas
]]
function GearHelper:AutoGreedAndNeed(number)
	-- number = ID de l'id du roll (1, 2, 3)
	-- rollType = 0 pass, 1 need, 2 cupi, 3 dez
	-- ConfirmLootRoll(number, rollType)
	if (GearHelper.db.profile.autoNeed or GearHelper.db.profile.autoGreed) then
		local link, name, _, _, _, canNeed, canGreed = GetLootRollItemInfo(number)
		local itemTable = GearHelper:GetItemByLink(link)
		local itemType = itemTable.type
		local itemSubType = itemTable.subType

		local weightCalcResult = GearHelper:IsItemBetter(link, "ItemLink")

		if canNeed then
			if GearHelper.db.profile.autoNeed then
				if itemType == L["armor"] or itemType == L["weapon"] then
					if (weightCalcResult[1] ~= nil and weightCalcResult[1] > 0) or (weightCalcResult[2] ~= nil and weightCalcResult[2] > 0) then
						-- print("J'ai need 1 "..name)
						ConfirmLootRoll(number, 1)
						UIErrorsFrame:AddMessage(L["iNeededOn"] .. name, 0.0, 1.0, 0.0, 150) -----------          DEBUG MODE        -----------
					elseif GearHelper.db.profile.autoGreed then
						-- print("J'ai cupi 2 "..name)
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
end

-- Créer les boutons le long du panel LFR
-- Adaptation de l'addon BossesKilled
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
					--self.UpdateSelecCursor()

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

-- Reset les textes des tooltips et des boutons
-- Adaptation de l'addon BossesKilled
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
				textBoss = GearHelper:ColorizeString(bossName, "rougefonce") .. GearHelper:ColorizeString(" est mort !", "Rouge")
				bossTues = bossName and bossTues + 1
			elseif not isDead and bossName then
				textBoss = GearHelper:ColorizeString(bossName, "vertfonce") .. GearHelper:ColorizeString(" est vivant !", "Vert")
			end
			table.insert(tooltip, textBoss)
		end

		-- Implémente le couleur + le text des boutons
		button.tooltip = tooltip
		local result = bossTues .. "/" .. nbBoss
		if (bossTues == nbBoss) then
			result = GearHelper:ColorizeString(result, "Rouge")
		elseif (bossTues == 0) then
			result = GearHelper:ColorizeString(result, "Vert")
		else
			result = GearHelper:ColorizeString(result, "Jaune")
		end

		-- Utilise cette fonction pour ajouter du text si elle est dispo (évite des erreurs)
		if (button.number.SetFormattedText) then
			button.number:SetFormattedText(result)
		end

		button.number = result
	end
end

-- Crée / modifie le curseur des boutons LFR
-- Adaptation de l'addon BossesKilled
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
	if (RaidFinderQueueFrame.GHLfrButtons) then
		for id, buttodn in pairs(RaidFinderQueueFrame.GHLfrButtons) do
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
end

function GearHelper:HideLfrButtons()
	local nbInstance = GetNumRFDungeons()
	for i = 1, nbInstance do
		local id, name = GetRFDungeonInfo(i)
		if _G["RaidFinderQueueFrameGHLfrButtons" .. id] then
			_G["RaidFinderQueueFrameGHLfrButtons" .. id]:Hide()
		--_G["RaidFinderQueueFrameGHLfrButtons" .. id] = nil
		end
	end
end

function GearHelper:ResetCache()
	--print("Cache reseted")
	GearHelper.db.global.ItemCache = {}
end

function GearHelper:AddIlvlOnCharFrame(show)
	local function CharFrameShow(frame)
		if GearHelper.db.profile.ilvlCharFrame then
			table.foreach(
				GearHelper.charInventory,
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
							--local _, _, iR, itemLevel = GetItemInfo(item)

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
		GearHelper.charInventory,
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
		if (GearHelper.db.profile.ilvlInspectFrame) then
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

					--table.insert(arrayIlvl, itemLevel)
					iR = ((iR == "9d9d9d" and 0) or (iR == "ffffff" and 1) or (iR == "1eff00" and 2) or (iR == "0070dd" and 3) or (iR == "a335ee" and 4) or (iR == "ff8000" and 5) or (iR == "e6cc80" and 6) or (iR == "00ccff" and 7))
					--local poor, uncommon, common, rare, epic, legendary, artifact, heirloom = 128824, 146976, 132930, 153256, 96707, 147297, 127830, 133597

					if (itemEquipLoc ~= nil) then
						arrayIlvl[itemEquipLoc] = itemLevel
						-- print("----------")
						-- print("itemID : " .. itemID)
						-- print("itemLink : " .. itemLink)
						-- print("itemLevel : " .. itemLevel)
						-- print("itemEquipLoc : " .. itemEquipLoc)
						-- print("iR : " .. iR)

						local button
						if (itemEquipLoc == "INVTYPE_FINGER" and not fingerAlreadyDone) then
							-- print("xPos : " .. tostring(arrayPos["x" .. itemEquipLoc]))
							-- print("yPos : " .. tostring(arrayPos["yINVTYPE_FINGER"]))
							-- print("Finger0")
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_FINGER"])
							fingerAlreadyDone = true
						elseif (itemEquipLoc == "INVTYPE_FINGER" and fingerAlreadyDone) then
							-- print("xPos : " .. tostring(arrayPos["x" .. itemEquipLoc]))
							-- print("yPos : " .. tostring(arrayPos["yINVTYPE_FINGER1"]))
							-- print("Finger1")
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_FINGER1"])
						elseif (itemEquipLoc == "INVTYPE_TRINKET" and not trinketAlreadyDone) then
							-- print("xPos : " .. tostring(arrayPos["x" .. itemEquipLoc]))
							-- print("yPos : " .. tostring(arrayPos["yINVTYPE_TRINKET"]))
							-- print("Trinket0")
							button = _G["charIlvlButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_TRINKET"])
							trinketAlreadyDone = true
						elseif (itemEquipLoc == "INVTYPE_TRINKET" and trinketAlreadyDone) then
							-- print("xPos : " .. tostring(arrayPos["x" .. itemEquipLoc]))
							-- print("yPos : " .. tostring(arrayPos["yINVTYPE_TRINKET1"]))
							-- print("Trinket1")
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_TRINKET1"])
						elseif (itemEquipLoc == "INVTYPE_WEAPON" and not weaponAlreadyDone) then
							-- print("xPos : " .. tostring(arrayPos["xINVTYPE_WEAPONMAINHAND"]))
							-- print("yPos : " .. tostring(arrayPos["yINVTYPE_WEAPONMAINHAND"]))
							-- print("Arme0")
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["xINVTYPE_WEAPONMAINHAND"], arrayPos["yINVTYPE_WEAPONMAINHAND"])
							weaponAlreadyDone = true
						elseif (itemEquipLoc == "INVTYPE_WEAPON" and weaponAlreadyDone) then
							-- print("xPos : " .. tostring(arrayPos["xINVTYPE_WEAPONOFFHAND"]))
							-- print("yPos : " .. tostring(arrayPos["yINVTYPE_WEAPONOFFHAND"]))
							-- print("Arme1")
							button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
							button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["xINVTYPE_WEAPONOFFHAND"], arrayPos["yINVTYPE_WEAPONOFFHAND"])
						else
							-- print("xPos : " .. tostring(arrayPos["x" .. itemEquipLoc]))
							-- print("yPos : " .. tostring(arrayPos["y" .. itemEquipLoc]))
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
					-- print("equipLoc : " .. equipLoc)
					if (equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY") then
						ilvlAverage = ilvlAverage + ilvl
						itemCount = itemCount + 1
					end
				end
			)
			-- print("itemCount : "..itemCount)
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

--[[
-- Se déclenche quand on rentre en combat
function allEvents:PLAYER_REGEN_DISABLED( ... )
GearHelper.db.profile.addonEnabled= false
end

-- Se déclenche quand on sort du combat
function allEvents:PLAYER_REGEN_ENABLED( ... )
if startState == nil then
startState = true
end
print("startState = "..tostring( startState ))
GearHelper.db.profile.addonEnabled= startState
end
]]
--

------------------------------------------------          ----------------------------------------------          ------------------------------------------------
-- xxxxxxx xxxxxxx --      -- xxxxxxx xxxxxxx --          -- xxxxxxx xxxxxxx --      -- xxxxx xxxxxxx --          -- xxxxxxx xxxxxxx --      -- xxxxxxx xxxxxxx --
------------------------------------------------          ----------------------------------------------          ------------------------------------------------

-- for event, _ in pairs(allEvents) do
--   eventHandler:RegisterEvent(event)
-- end
-- eventHandler:SetScript("OnEvent", function ( self, event, ... )
--   --if GearHelper.db.profile.addonEnabledor GearHelper.db.profile.addonEnabled== nil then
--   allEvents[event](self, ...)
--   --end
-- end)

--------------

-- pour chaques piece de stuff
-- faire une recherche dans l'inventaire
-- regarder s'il existe un stuff du même type
-- si oui, regarder s'il est meilleurs que celui qu'on à
-- si oui l'équiper
-- si non, le laisser dans l'inventaire
-- fonction GearHelper:weightCalculation si finger ou trinket abs ca doit planter
--recup le retour de la tabcaracter et pour chaque faire un GearHelper:weightCalculation ca economise des lignes pour trinket et bague

-- Répertorier les pièces d'inventaire
-- Répertorier les pièces dispo dans le sac (spé)
-- Marquer les pièces de l'inventaire qui peuvent etre swap par celle du sac
-- Définir le nombre de pièces Y à tester et les lister
-- Définir le nombre de commutations possibles (nbPieceSlotX * nbPieceSlotY * nbPieceSlotZ etc...)
-- Equiper les pièces pour chaque commutation et recuperer stat
-- Comparer stat par rapport au caps
