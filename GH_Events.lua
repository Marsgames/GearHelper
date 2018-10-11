local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local prefixAddon = "GeARHeLPeRPReFIX"
local gagne = 0

waitingIDTable = waitingIDTable

--[[
Function : AddonLoaded
Scope : local
Description : Initialise l'addon au moment de son chargement
Input : string (le nom de l'addono chargé)
Author : Raphaël Daumas
]]
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

	--RegisterAddonMessagePrefix(prefixAddon)
	print(GearHelper:ColorizeString(L["merci"], "Vert"))
	local runningBuild = select(4, GetBuildInfo())
	if GearHelper.db.global.buildVersion ~= runningBuild then
		GearHelper.db.global.buildVersion = runningBuild
		GearHelper:ResetCache()
	end
end

--[[
Function : OnMerchantShow
Scope : local
Description : Vend / répare automatiquement quand la fenetre d'un marchant s'ouvre
Author : Raphaël Daumas
]]
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

--[[
Function : PlayerEnteringWorld
Scope : local
Description : Quand le joueur se connecte : - crée les cw - check si l'addon est à jour - scan l'équipement du joueur - fixe les greens dots ?
Author : Raphaël Daumas
]]
local function PlayerEnteringWorld()
	-- Si le joueur n'a pas activé les fenêtre interractives, fait du sale (les activz + reload)
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
end

-- GearHelper:Print("")
--[[
Function : ChatMsgAddon
Scope : local
Description : Envoi une demande de version ou sa réponse (pour vérifier si l'addon est up to date)
Input : string (le prefixe du message), string (le message envoyé par / reçu par l'addon), string (le nom du joueur qui à envoyé le msg (peut être soit même))
Author : Raphaël Daumas
]]
local function ChatMsgAddon(_, _, prefixMessage, message, _, sender)
	if prefixMessage ~= prefixAddon then
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

--[[
Function : ItemPush
Scope : local
Description : Appelé quand un item est envoyé dans un sac. Equipe les items de ce sac qui seraient mieux que ceux équipés.
Input : number (le numéro du sac ddans lequel l'item à été envoyé)
Author : Raphaël Daumas
]]
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

--[[
Function : QuestComplete
Scope : local
Description : Accepte la récompensee de quête automatiquement si l'option est activée.
Author : Raphaël Daumas
]]
local function QuestComplete()
	GearHelper.GetQuestRewardCoroutine =
		coroutine.create(
		function()
			GearHelper:GetQuestReward()
		end
	)
	coroutine.resume(GearHelper.GetQuestRewardCoroutine)
end

--[[
Function : StartLootRoll
Scope : local
Description : Auto need ou auto greed un item en instance si l'option est activée
Input : number (index du jet (si 3 items tombent en même temps :  0, 1, 2))
Author : Raphaël Daumas
]]
local function StartLootRoll(_, _, number)
	GearHelper.AutoGreedAndNeedCoroutine =
		coroutine.create(
		function()
			GearHelper:AutoGreedAndNeed(number)
		end
	)
	coroutine.resume(GearHelper.AutoGreedAndNeedCoroutine)
	-- GearHelper:AutoGreedAndNeed(number)
end

--[[
Function : MerchantClosed
Scope : local
Description : Appelé quand la fenetre d'un marchant se ferme. calcul l'argent gagné pour l'afficher
Author : Raphaël Daumas
]]
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

--[[
Function : BagUpdate
Scope : local
Description : ... Bonne question ... fired un peu n'importe quand ?
Author : Raphaël Daumas
]]
local function BagUpdate()
	if not GearHelper.charInventory["MainHand"] then
		do
			return
		end
	end
	if GearHelper.charInventory["MainHand"] == "" then
		do
			return
		end
	end

	-- Random check to verify that charInventory is initialized because BagUpdate is fired before PlayerEnteringWorld
	GearHelper:ScanCharacter()
	GearHelper:poseDot()
end

--[[
Function : ActiveTalentGroupChanged
Scope : local
Description : Appelé quand l'utilisateur change de spé. Utilisé pour équiper les bons items et changer le nom ded la spé dans les CW
Author : Raphaël Daumas
]]
local function ActiveTalentGroupChanged()
	if not GearHelper.db.profile.autoEquipWhenSwitchSpe then
		GearHelper.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
		do
			return
		end
	end

	-- waitSpeTime:Show()
	GearHelper:equipItem(0)
	GearHelper:equipItem(1)
	GearHelper:equipItem(2)
	GearHelper:equipItem(3)
	GearHelper:equipItem(4)
end

--[[
Function : ChatMsgChannel
Scope : local
Description : Invite le joueur qui envoit le bon msg dans un groupe
Description : Affiche une alerte si votre nom est cité
Input : string (le message reçu), string (le joueur qui l'a envoyé)
Author : Raphaël Daumas
]]
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

--[[
Function : ChatMsgWhisper
Scope : local
Description : Invite le joueur qui vous chuchote le bon msg dans un groupe
Input : string (le message reçu), string (le joueur qui l'a envoyé)
Author : Raphaël Daumas
]]
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

--[[
Function : ChatMsgLoot
Scope : local
Description : Si quelqu'un loot quelque chose de mieux que ce qu'on a en instance, crée un lien pour lui demander facilement s'il en a besoin
Input : Trop d'infos envoyées par la fonction de Blizzard
Author : Raphaël Daumas
]]
local function ChatMsgLoot(_, _, message, language, sender, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
	GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)

	-- if not target then
	-- 	do return end
	-- end
	-- if target == GetUnitName("player") then
	-- 	do return end
	-- end
	-- if target == "" then
	--  do return end
	-- end
	-- if not GearHelper.db.profile.askLootRaid then
	-- 	do return end
	-- end
	-- if string.find(string.lower(message), L["getLoot"]) then
	-- 	do return end
	-- end

	-- inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil}
	-- GearHelper.db.profile.inspectAin.waitingIlvl = true
	-- GearHelper.db.profile.inspectAin.message = message
	-- GearHelper.db.profile.inspectAin.target = target

	-- for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
	-- 	local itemTable = GearHelper:GetItemByLink(itemLink)
	-- 	GearHelper.db.profile.inspectAin.linkItemReceived = itemTable.itemLink
	-- 	do
	-- 		return
	-- 	end
	-- end
	--NotifyInspect(target)
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

--[[
Function : UnitInventoryChanged
Scope : local
Description : Évite d'équiper la meilleur arme si le joueur est en train ed pêcher
Input : string (le joueur qui à changé de stuff ?)
Author : Raphaël Daumas
]]
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

--[[
Function : QuestTurnedIn
Scope : local
Description : Bonne question ? Equipe les bons items quand on accepte une quête ?
Author : Raphaël Daumas
]]
local function QuestTurnedIn()
	if not GearHelper.db.profile.autoEquipLooted.actual then
		do
			return
		end
	end

	waitSpeTimer = time()
	waitSpeFrame:Show()
end

--[[
Function : GetItemInfoReceived
Scope : local
Description : Appelé quand un item arrivee en cache
Input : number (id de l'item)
Author : Raphaël Daumas
]]
local function GetItemInfoReceived(_, _, item)
	-- print("GetItemInfoReceived fired")

	if GearHelper.db.global.itemWaitList[item] then
		local slotName = GearHelper.db.global.itemWaitList[item]
		GearHelper.db.global.itemWaitList[item] = nil
		GearHelper.charInventory[string.sub(slotName, 1, -5)] = GearHelper:GetEquippedItemLink(GetInventorySlotInfo(slotName), slotName)
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
		-- print("------------")
		-- print("item : " .. item)
		-- print("AddIlvlOnInspectFrame appelé depuis GetItemInfoReceived")
		-- print("target : " .. UnitGUID("target"))
		--GearHelper:AddIlvlOnInspectFrame(UnitGUID("target"))
		NotifyInspect("target")
	end
end

local function PlayerFlagsChanged(_, _)
	-- if not GearHelper.db.profile.debug then
	-- 	do return end
	-- end
	-- PlaySound(5804, "Master")
end

local function ReadyCheck(_, _)
	local players = GetHomePartyInfo()
end

-- local function QuestFiniched()
-- 	button.overlay = nil
-- end

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

	-- if (TargetFrame) then
	-- 	print("TargetFrame registered")
	-- 	local function TargetFrameShow(frame)
	-- 		if (UnitIsPlayer("target")) then
	-- 			NotifyInspect("target")
	-- 		else
	-- 			print("unit is not a player")
	-- 		end
	-- 		print("target affiché")
	-- 	end
	-- 	local function TargetFrameHide()
	-- 		print("target caché")
	-- 	end

	-- 	TargetFrame:HookScript("OnShow", TargetFrameShow)
	-- 	TargetFrame:HookScript("OnHide", TargetFrameHide)
	-- else
	-- 	print("impossible de register TargetFrame")
	-- end

	-- if (WardrobeCollectionFrame) then
	-- 	-- Récupérer la page active :
	-- 	-- table.foreach(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.itemFramesPool, print)
	-- 	print("WardrobeCollectionFrame ok")
	-- else
	-- 	print("pas ok wardrobe")
	-- end
end

-- last loading event fired
local function PlayerAlive()
	-- if HeirloomsJournal then
	-- 	local function HjFrameShow(frame)
	-- 		print("Bonjour HeirloomsJournal")
	-- 		table.foreach(HeirloomsJournal.heirloomLayoutData, function(pageIndex, pageValeur)
	-- 			table.foreach(HeirloomsJournal.heirloomLayoutData[pageIndex], function(heirloomIndex, heirloomId)
	-- 				if (heirloomId ~= -1) then
	-- 					local name, id = GetItemInfo(heirloomId)
	-- 					table.foreach(GearHelper:IsItemBetter(id, "itemlink"), function(item, stats)
	-- 						if (stats > 0 or stats == -50) then -- item mieux, cadre mieux + icon
	-- 							if (heirloomIndex <= 18) then
	-- local f = _G["HJIcon"..id] or CreateFrame("Frame", "HJIcon"..id, HeirloomsJournal)
	-- f:SetFrameStrata("TOOLTIP")
	-- f:SetWidth(18) -- Set these to whatever height/width is needed
	-- f:SetHeight(18) -- for your Texture
	-- local t = f:CreateTexture(nil, "TOOLTIP")
	-- local xCompte = (heirloomIndex % 3 == 1 and 0) or (heirloomIndex % 3 == 2 and 1) or (heirloomIndex % 3 == 0 and 2)
	-- t:SetTexture("Interface\\AddOns\\GearHelper\\Textures\\flecheUp")
	-- t:SetAllPoints(f)
	-- f.texture = t
	-- f:SetPoint("CENTER", HeirloomsJournal, "CENTER", (-305 + (xCompte * 210)), (190 - (((math.ceil(heirloomIndex / 3)) - 1) * 65)))
	-- f:Show()
	-- 								end
	-- 						elseif (stats == -30) then -- moins bien, cadre rouge
	-- 						elseif (stats == -60 or stats == 0) then -- déjà équippé ou équivalent, cadre jaune
	-- 						end
	-- 					end)
	-- 				end
	-- 			end)
	-- 		end)
	-- 	end
	-- 	local function HjFrameHide()
	-- 		print("Au revoir HeirloomsJournal")
	-- 	end
	-- 	HeirloomsJournal:HookScript("OnShow", HjFrameShow)
	-- 	HeirloomsJournal:HookScript("OnHide", HjFrameHide)
	-- 	print("Heirlooms registered")
	-- else
	-- 	print("impossible de register HeirloomsJournal")
	-- end
end

local function InspectReady(_, _, target)
	-- inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil}
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
		-- GameTooltip:HookScript(
		-- 	"OnHide",
		-- 	function()
		ClearInspectPlayer()
		-- 	end
		-- )
		GameTooltip:Show()
	end
	--ClearInspectPlayer()
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
--GearHelper:RegisterEvent("CHAT_MSG_BATTLEGROUND", ChatMsgBattleground, ...)
--GearHelper:RegisterEvent("CHAT_MSG_BATTLEGROUND_LEADER", ChatMsgBattlegroundLeader, ...)
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
GearHelper:RegisterEvent("PLAYER_FLAGS_CHANGED", PlayerFlagsChanged, ...)
--GearHelper:RegisterEvent("READY_CHECK", ReadyCheck, ...)
-- GearHelper:RegisterEvent("QUEST_FINISHED", QuestFiniched, ...)
GearHelper:RegisterEvent("PLAYER_LOGIN", PlayerLogin, ...)
GearHelper:RegisterEvent("LFG_UPDATE", LfgUpdate, ...)
GearHelper:RegisterEvent("PLAYER_ALIVE", PlayerAlive, ...)
GearHelper:RegisterEvent("INSPECT_READY", InspectReady, ...)
GearHelper:RegisterEvent("UPDATE_MOUSEOVER_UNIT", UpdateMouseOverUnit, ...)
