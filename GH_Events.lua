local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local gagne = 0
lfrCheckIsChecked = false

waitingIDTable = waitingIDTable

local function AddonLoaded(_, _, name)
	if GearHelper.db.global.templates == nil then
		GearHelper.db.global.templates = {}
	end

	GearHelper:InitTemplates()

	if name ~= addonName then
		do
			return
		end
	end

	print(GearHelper:ColorizeString(L["merci"], "Vert"))
	local runningBuild = select(4, GetBuildInfo())
	if GearHelper.db.global.buildVersion ~= runningBuild then
		GearHelper.db.global.buildVersion = runningBuild
		GearHelper:ResetCache()
	end
end

local function OnMerchantShow()
	gagne = 0
	if GearHelper.db.profile.sellGreyItems then
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				if GetContainerItemID(bag, slot) ~= nil then
					local id = GetContainerItemID(bag, slot)
					if id then
						local result = GearHelper:SiObjetGris(id)
						if result[1] then
							UseContainerItem(bag, slot)
							gagne = gagne + result[2]
						end
					end
				end
			end
		end
	end

	if CanMerchantRepair() and GearHelper.db.profile.autoRepair == 1 or GearHelper.db.profile.autoRepair == 2 then
		local argentPossedee = GetMoney()
		local prix = GetRepairAllCost()
		local droitGuilde = ""
		local argentGuilde = ""

		if IsInGuild() and CanGuildBankRepair() then
			droitGuilde = GetGuildBankWithdrawMoney()
			argentGuilde = GetGuildBankMoney()
		end
		if prix > 0 then
			if GearHelper.db.profile.autoRepair == 1 then
				if argentPossedee >= prix then
					RepairAllItems(false)
					print(GearHelper:ColorizeString(L["repairCost"], "Rose") .. math.floor(prix / 10000) .. L["dot"] .. math.floor((prix % 10000) / 100) .. L["gold"])
				else
					print(L["CantRepair"])
				end
			elseif GearHelper.db.profile.autoRepair == 2 then
				if droitGuilde ~= nil and (droitGuilde == -1 or (droitGuilde > argentGuilde and argentGuilde > prix)) then
					RepairAllItems(true)
					print(cRose .. L["guildRepairCost"] .. math.floor(prix / 10000) .. L["dot"] .. math.floor((prix % 10000) / 100) .. L["gold"])
				else
					if argentPossedee >= prix then
						RepairAllItems(false)
						print(cRose .. L["repairCost"] .. math.floor(prix / 10000) .. L["dot"] .. math.floor((prix % 10000) / 100) .. L["gold"])
					else
						print(L["CantRepair"])
					end
				end
			end
		end
	end

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if GetContainerItemID(bag, slot) ~= nil then
				local _, itemCount = GetContainerItemInfo(bag, slot)
				local id = GetContainerItemID(bag, slot)
				if id then
					local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(id)
					if vendorPrice ~= nil then
						gagne = gagne + (vendorPrice * itemCount)
					end
				end
			end
		end
	end
end

local function PlayerEnteringWorld()
	local used = false
	for i = 1, NUM_CHAT_WINDOWS do
		local _, _, _, _, _, _, _, _, _, uninteractable = GetChatWindowInfo(i)
		if (uninteractable) then
			SetChatWindowUninteractable(i, false)
			used = true
		end
	end
	if used then
		ReloadUI()
	end

	GearHelper:BuildCWTable()
	if GearHelper.db.profile.addonEnabled == true then
		GearHelper:sendAskVersion()
		GearHelper:ScanCharacter()
		GearHelper:poseDot()
		if (not string.match(GearHelper.db.global.myNames, GetUnitName("player") .. ",")) then
			GearHelper.db.global.myNames = GearHelper.db.global.myNames .. GetUnitName("player") .. ","
		end
	end

	local _, instanceType, _, _, _, _, _, _, _, lfgDungeonsID = GetInstanceInfo()
	if "raid" == instanceType then
		if (nil == lfgDungeonsID) then
			lfrCheckIsChecked = false
			if (lfrCheckButton_GlobalName) then
				lfrCheckButton_GlobalName:Hide()
			end
			do
				return
			end
		end
		-- si le joueur est dans un groupe LFR afficher sous la minimap une case cochable permettant d'accepter automatiquement les appels

		lfrCheckButton = lfrCheckButton_GlobalName or CreateFrame("CheckButton", "lfrCheckButton_GlobalName", UIParent, "ChatConfigCheckButtonTemplate")
		lfrCheckButton:SetPoint("TOPRIGHT", -325, -45)
		lfrCheckButton_GlobalNameText:SetText(L["lfrCheckButtonText"])
		lfrCheckButton.tooltip = L["lfrCheckButtonTooltip"]
		lfrCheckButton:SetScript(
			"OnClick",
			function()
				lfrCheckIsChecked = lfrCheckButton:GetChecked()
				print(lfrCheckIsChecked)
			end
		)
		-- else
		lfrCheckButton_GlobalName:Show()
		lfrCheckButton_GlobalName:SetChecked(lfrCheckIsChecked)
	else
		lfrCheckIsChecked = false
		if (lfrCheckButton_GlobalName) then
			lfrCheckButton_GlobalName:Hide()
		end
	end
end

local function ChatMsgAddon(_, _, prefixMessage, message, _, sender)
	if prefixMessage ~= GearHelperVars.prefixAddon then
		do
			return
		end
	end
	if not GearHelper.db.profile.addonEnabled then
		do
			return
		end
	end

	local emetteur = ""
	if sender:find("-") then
		emetteur = sender:sub(0, (sender:find("-") - 1))
	else
		emetteur = sender
	end

	if emetteur == GetUnitName("player") then
		do
			return
		end
	end
	local prefVersion = message:sub(0, (message:find(";") - 1))
	if prefVersion == "answerVersion" then
		local vVersion = message:sub(message:find(";") + 1, #message)
		versionCible = vVersion
		GearHelper:receiveAnswer(vVersion, sender)
	end
	if prefVersion == "askVersion" then
		GearHelper:sendAnswerVersion()
	end
end

local function ItemPush(_, _, bag)
	if not GearHelper.db.profile.autoEquipLooted.actual then
		do
			return
		end
	end

	local theBag = bag
	if bag == 23 then
		theBag = 4
	elseif bag == 22 then
		theBag = 3
	elseif bag == 21 then
		theBag = 2
	elseif bag == 20 then
		theBag = 1
	end
	GearHelper:equipItem(theBag)
end

local function QuestComplete()
	GearHelper.GetQuestRewardCoroutine =
		coroutine.create(
		function()
			GearHelper:GetQuestReward()
		end
	)
	coroutine.resume(GearHelper.GetQuestRewardCoroutine)
end

local function StartLootRoll(_, _, number)
	GearHelper.AutoGreedAndNeedCoroutine =
		coroutine.create(
		function()
			GearHelper:AutoGreedAndNeed(number)
		end
	)
	coroutine.resume(GearHelper.AutoGreedAndNeedCoroutine)
end

local function MerchantClosed()
	if not GearHelper.db.profile.sellGreyItems then
		do
			return
		end
	end

	local argentFin = 0
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if GetContainerItemID(bag, slot) ~= nil then
				local _, itemCount = GetContainerItemInfo(bag, slot)
				local id = GetContainerItemID(bag, slot)
				if id then
					local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(id)
					argentFin = argentFin + (vendorPrice * itemCount)
				end
			end
		end
	end
	if (gagne - argentFin > 0) then
		print(GearHelper:ColorizeString(L["moneyEarned"], "Vert") .. math.floor((gagne - argentFin) / 10000) .. L["dot"] .. math.floor(((gagne - argentFin) % 10000) / 100) .. L["gold"])
		gagne = 0
	end
end

local function BagUpdate()
	if not GearHelperVars.charInventory["MainHand"] then
		do
			return
		end
	end
	if GearHelperVars.charInventory["MainHand"] == "" then
		do
			return
		end
	end

	-- Random check to verify that charInventory is initialized because BagUpdate is fired before PlayerEnteringWorld
	GearHelper:ScanCharacter()
	GearHelper:poseDot()
end

local function ActiveTalentGroupChanged()
	if not GearHelper.db.profile.autoEquipWhenSwitchSpe then
		GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
		do
			return
		end
	end

	GearHelperVars.waitSpeTimer = time()
	GearHelperVars.waitSpeFrame:Show()
	GearHelper:equipItem(0)
	GearHelper:equipItem(1)
	GearHelper:equipItem(2)
	GearHelper:equipItem(3)
	GearHelper:equipItem(4)
end

local function ChatMsgChannel(_, _, msg, sender, lang, channel)
	if not GearHelper.db.profile.autoInvite or not msg then
		GearHelper:ShowMessageSMN(channel, sender, msg)
		do
			return
		end
	end

	local playerIsNotMe = not string.find(sender, GetUnitName("player"))
	if msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe and GetNumGroupMembers() == 5 then
		ConvertToRaid()
		InviteUnit(sender)
	elseif msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe then
		InviteUnit(sender)
	end

	GearHelper:ShowMessageSMN(channel, sender, msg)
end

local function ChatMsgWhisper(_, _, msg, sender)
	if GearHelper.db.profile.autoInvite and msg ~= nil then
		local playerIsNotMe = not string.find(sender, GetUnitName("player"))
		if msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe and GetNumGroupMembers() == 5 then
			ConvertToRaid()
			InviteUnit(sender)
		elseif msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe then
			InviteUnit(sender)
		end
	end
	if (GearHelper.db.profile.whisperAlert) then
		PlaySoundFile("Interface\\AddOns\\GearHelper\\Textures\\whisper.ogg", "Master")
	end
end

local function ChatMsgLoot(_, _, message, language, sender, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
	GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
end

local function ChatMsgBattleground(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("BG", sender, msg)
end

local function ChatMsgBattlegroundLeader(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("BG", sender, msg)
end

local function ChatMsgEmote(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Emote", sender, msg)
end

local function ChatMsgGuild(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Guild", sender, msg)
end

local function ChatMsgOfficer(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Officer", sender, msg)
end

local function ChatMsgParty(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Party", sender, msg)
end

local function ChatMsgPartyLeader(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Party", sender, msg)
end

local function ChatMsgRaid(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Raid", sender, msg)
end

local function ChatMsgRaidLeader(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Raid", sender, msg)
end

local function ChatMsgRaidWarning(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Raid_warning", sender, msg)
end

local function ChatMsgSay(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Say", sender, msg)
end

local function ChatMsgYell(_, _, msg, sender, lang, channel)
	GearHelper:ShowMessageSMN("Yell", sender, msg)
end

local function UnitInventoryChanged(_, _, joueur)
	if not GearHelper.db.profile.addonEnabled then
		do
			return
		end
	end
	if joueur ~= "player" then
		do
			return
		end
	end

	GearHelper:ScanCharacter()

	if not GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")) then
		do
			return
		end
	end

	local _, _, _, _, _, _, subclass = GetItemInfo(GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot")))
	if subclass == L["cannapeche"] then
		GearHelper.db.profile.autoEquipLooted.previous = GearHelper.db.profile.autoEquipLooted.actual
		GearHelper.db.profile.autoEquipLooted.actual = false
	else
		GearHelper.db.profile.autoEquipLooted.actual = GearHelper.db.profile.autoEquipLooted.previous
	end
end

local function QuestTurnedIn()
	if not GearHelper.db.profile.autoEquipLooted.actual then
		do
			return
		end
	end

	GearHelperVars.waitSpeTimer = time()
	GearHelperVars.waitSpeFrame:Show()
end

local function GetItemInfoReceived(_, _, item)
	if GearHelper.db.global.itemWaitList[item] then
		local slotName = GearHelper.db.global.itemWaitList[item]
		GearHelper.db.global.itemWaitList[item] = nil
		GearHelperVars.charInventory[string.sub(slotName, 1, -5)] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo(slotName), slotName)
	end
	if item ~= nil then
		if GearHelper.idNilGetQuestReward ~= nil then
			if item == GearHelper.idNilGetQuestReward then
				GearHelper:Print(tostring(item) .. " était nil")
				coroutine.resume(GearHelper.GetQuestRewardCoroutine)
			end
		end
		if GearHelper.idNilAutoGreedAndNeed ~= nil then
			if item == GearHelper.idNilAutoGreedAndNeed then
				coroutine.resume(GearHelper.AutoGreedAndNeedCoroutine)
			end
		end
	end

	if (InspectPaperDollItemsFrame) then
		NotifyInspect("target")
	end
end

local function ReadyCheck(_, _)
	local players = GetHomePartyInfo()
end

local function LfgUpdate(_, _)
	GearHelper:UpdateGHLfrButton()
end

local function PlayerLogin(_, _)
	-- Si la frame recherche donjon est ouverte et que la fonction de selection de donjon est dispo (sur la page lfr en gros)
	if RaidFinderQueueFrame and RaidFinderQueueFrame_SetRaid then
		local function LfrFrameShow(frame)
			if not GearHelper.db.profile.bossesKilled then
				do
					return
				end
			end

			GearHelper:CreateLfrButtons(frame)
			GearHelper:UpdateButtonsAndTooltips(frame)
			GearHelper:UpdateGHLfrButton()
			GearHelper:UpdateSelecCursor()
			GearHelper:RegisterEvent("LFG_UPDATE")
			GearHelper.LFG_UPDATE = GearHelper.UpdateGHLfrButton
		end
		local function LfrFrameHide()
			GearHelper:HideLfrButtons()
			GearHelper:UnregisterEvent("LFG_UPDATE")
		end

		RaidFinderQueueFrame:HookScript("OnShow", LfrFrameShow)
		RaidFinderQueueFrame:HookScript("OnHide", LfrFrameHide)
		hooksecurefunc("RaidFinderQueueFrame_SetRaid", GearHelper.UpdateSelecCursor)
	end

	-- Si la page du personnage s'affiche, on affiche l'ilvl
	if (PaperDollItemsFrame) then
		GearHelper:AddIlvlOnCharFrame()
	end
end

local function InspectReady(_, _, target)
	if GearHelper.db.profile.inspectAin.waitingIlvl then ---------------- /GH AIN AVEC UN MESSAGE SPÉCIALE SI L'ILVL DE L'OBJET LOOT EST MOINS BON QUE CELUI ÉQUIPPÉ PAR CELUI QUI L'A LOOT
		local itemLoot = GearHelper.db.profile.inspectAin.linkItemReceived
		local itemLootTable = GearHelper:GetItemByLink(itemLoot)
		local itemLootEquipLoc = GearHelper.db.global.equipLocInspect[itemLootTable.equipLoc]

		if (itemLootEquipLoc ~= 11 and itemLootEquipLoc ~= 12 and itemLootEquipLoc ~= 13 and itemLootEquipLoc ~= 14) then
			local itemEquipped = GetInventoryItemLink(target, itemLootEquipLoc)
			if (not itemEquipped) then
				do
					return
				end
			end
			local itemEquippedTable = GearHelper:GetItemByLink(itemEquipped)
			local itemEquippedIlvl = itemEquippedTable.iLvl
			local itemLootIlvl = itemLootTable.iLvl

			print("-------------")
			print("item équippé par " .. GearHelper.db.profile.inspectAin.target .. " : " .. itemEquipped)
			print("item reçu : " .. itemLoot)
			if (itemEquippedIlvl >= itemLootIlvl) then
				print("Vous pouvez essayer de demander cet objet")
			else
				print("L'item loot à un meilleur ilvl, + de chances de refus")
			end
		end

		GearHelper.db.profile.inspectAin.waitingIlvl = false
		GearHelper.db.profile.inspectAin.linkItemReceived = nil
		GearHelper.db.profile.inspectAin.message = nil
		GearHelper.db.profile.inspectAin.target = nil

		ClearInspectPlayer()
	elseif (InspectPaperDollItemsFrame) then -------------------- AFFICHE L'ILVL DES ITEMS D'UN JOUEUR SUR LA FICHE D'INSPECTION
		GearHelper:AddIlvlOnInspectFrame(target)
	else ------------------- AFFICHE L'ILVL MOYEN D'UN MEC SUR SON TOOLTIP
		if not GameTooltip:IsVisible() then
			do
				return
			end
		end

		local arrayIlvl = {}
		for i = 1, 19 do
			local itemLink = GetInventoryItemLink("mouseover", i)
			if (itemLink) then
				local itemScan = GearHelper:GetItemByLink(itemLink)
				local itemLvl, equipLoc = itemScan.iLvl, itemScan.equipLoc
				if equipLoc ~= nil then
					arrayIlvl[equipLoc] = itemLvl
					table.insert(arrayIlvl, itemLvl)
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
		if (itemCount ~= 0) then
			GameTooltip:AddLine(L["ilvlInspect"] .. tostring(math.floor((ilvlAverage / itemCount) + .5)))
		end

		ClearInspectPlayer()
		GameTooltip:Show()
	end
end

local function UpdateMouseOverUnit()
	if not CanInspect("mouseover") then
		do
			return
		end
	end
	if not CheckInteractDistance("mouseover", 1) then
		do
			return
		end
	end

	NotifyInspect("mouseover")
end

local function ReadyCheck()
	if lfrCheckIsChecked then
		print("on utilise ConfirmReadyCheck(1)")
		ConfirmReadyCheck(1)
		ReadyCheckFrame:Hide()
	else
		print("lfrCheckIsChecked : " .. tostring(lfrCheckIsChecked))
	end
end

GearHelper:RegisterEvent("ADDON_LOADED", AddonLoaded, ...)
GearHelper:RegisterEvent("MERCHANT_SHOW", OnMerchantShow)
GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerEnteringWorld)
GearHelper:RegisterEvent("CHAT_MSG_ADDON", ChatMsgAddon, ...)
GearHelper:RegisterEvent("ITEM_PUSH", ItemPush, ...)
GearHelper:RegisterEvent("QUEST_COMPLETE", QuestComplete)
GearHelper:RegisterEvent("START_LOOT_ROLL", StartLootRoll, ...)
GearHelper:RegisterEvent("MERCHANT_CLOSED", MerchantClosed)
GearHelper:RegisterEvent("BAG_UPDATE", BagUpdate)
GearHelper:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", ActiveTalentGroupChanged)
GearHelper:RegisterEvent("CHAT_MSG_CHANNEL", ChatMsgChannel, ...)
GearHelper:RegisterEvent("CHAT_MSG_WHISPER", ChatMsgWhisper, ...)
GearHelper:RegisterEvent("CHAT_MSG_LOOT", ChatMsgLoot, ...)
GearHelper:RegisterEvent("CHAT_MSG_EMOTE", ChatMsgEmote, ...)
GearHelper:RegisterEvent("CHAT_MSG_GUILD", ChatMsgGuild, ...)
GearHelper:RegisterEvent("CHAT_MSG_OFFICER", ChatMsgOfficer, ...)
GearHelper:RegisterEvent("CHAT_MSG_PARTY", ChatMsgParty, ...)
GearHelper:RegisterEvent("CHAT_MSG_PARTY_LEADER", ChatMsgPartyLeader, ...)
GearHelper:RegisterEvent("CHAT_MSG_RAID", ChatMsgRaid, ...)
GearHelper:RegisterEvent("CHAT_MSG_RAID_LEADER", ChatMsgRaidLeader, ...)
GearHelper:RegisterEvent("CHAT_MSG_RAID_WARNING", ChatMsgRaidWarning, ...)
GearHelper:RegisterEvent("CHAT_MSG_SAY", ChatMsgSay, ...)
GearHelper:RegisterEvent("CHAT_MSG_YELL", ChatMsgYell, ...)
GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", UnitInventoryChanged, ...)
GearHelper:RegisterEvent("QUEST_TURNED_IN", QuestTurnedIn)
GearHelper:RegisterEvent("GET_ITEM_INFO_RECEIVED", GetItemInfoReceived, ...)
GearHelper:RegisterEvent("PLAYER_LOGIN", PlayerLogin, ...)
GearHelper:RegisterEvent("LFG_UPDATE", LfgUpdate, ...)
GearHelper:RegisterEvent("INSPECT_READY", InspectReady, ...)
GearHelper:RegisterEvent("UPDATE_MOUSEOVER_UNIT", UpdateMouseOverUnit, ...)
GearHelper:RegisterEvent("READY_CHECK", ReadyCheck, ...)
