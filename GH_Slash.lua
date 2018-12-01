local slashCmd = {
	help = function(msg)
		GearHelper:Print("state --> affiche l'état de l'addon")
		GearHelper:Print("list --> ScanBag() + scanCharacter()")
		print("config --> affiche le panneau de config")
		print("version --> affiche la version de l'addon")
		GearHelper:Print("im msg --> change le message d'auto invite par msg")
		GearHelper:Print("createItemLink --> crée un faux itemLink (qui marche)")
		GearHelper:Print("debug --> active / désactive le mode debug (prints)")
		GearHelper:Print("optimize --> calcul le stuff le plus opti ?")
		GearHelper:Print("save --> crée un equipmentSet")
		GearHelper:Print("equip --> équipe l'equipementSet précédement crée")
		GearHelper:Print("remove --> supprime l'equipmentSet précédement crée")
		GearHelper:Print("askloot --> active / désactive l'option pour annoncer les loots mieux que les notres en instance")
		GearHelper:Print('dot --> affiche les icones des "meilleurs items" sur les icones des stuffs')
		GearHelper:Print('suppdot --> supprime les icones de "meilleurs item" sur les icones des stuffs')
		print("cw --> Ouvre le panneau des Customs Weights")
		GearHelper:Print("eccip --> equip le meilleur stuff des sacs")
		GearHelper:Print("ain --> test la fonction Ask If He Needs")
		GearHelper:Print("reset --> reset GearHelper")
	end,
	printCache = function()
		for k, v in pairs(GearHelper.db.global.ItemCache) do
			print(k)
			foreach(v, print)
		end
	end,
	clearCache = function()
		GearHelper.db.global.ItemCache = {}
	end,
	list = function()
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local _, _, _, _, _, _, link = GetContainerItemInfo(bag, slot)
				if link ~= nil then
					if (strfind(link, "|H(.+)|h") ~= nil) then
						link = "|cff9d9d9d" .. link .. "|h|h|r"
					end
					print(bag .. " " .. slot)
					print(link)
				end
			end
		end
	end,
	config = function()
		InterfaceOptionsFrame:Show()
		InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
	end,
	version = function()
		print("|cFF00FF00GearHelper|r|cFFFFFF00 version : " .. version)
	end,
	im = function(msg)
		GearHelper:setInviteMessage(tostring(msg:sub(4)))
	end,
	ram = function()
		local ramExact = tonumber(GetAddOnMemoryUsage("GearHelper"))
		local ramUse = tonumber(string.format("%.0f", ramExact))
		print("RAM used by GearHelper : " .. ramUse .. "ko")
	end,
	createitemlink = function()
		local aze = "|cff1eff00|Hitem:128942::::::::100:105::::::|h[/gh createItemLink]|h|r"
		print(aze)
		print("GearHelper:IsEquipped = " .. tostring(GearHelper:IsEquipped(aze)))
		table.foreach(GearHelper:weightCalculation(aze), print)
	end,
	il = function()
		local equiped = "|cff1eff00|Hitem:40018::::::::100:105::::::|h[Ulthalesh]|h|r"
		table.foreach(GearHelper:getStatsFromTooltip(equiped), print)
	end,
	optimize = function()
		GearHelper:ScanBag()
		GearHelper:scanCharacter()
		local tabEquipLoc = {}
		local tabItemMeta = {}
		local idItemTypeExist = 0
		for a = 1, #bagInventory do
			local _, itemLink, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(bagInventory[a])
			local itemTypeExist = false

			for b = 0, #tabEquipLoc do
				if itemEquipLoc == tabEquipLoc[b] then
					idItemTypeExist = b
					itemTypeExist = true
				end
			end
			if itemTypeExist == false then
				table.insert(tabEquipLoc, itemEquipLoc)
				table.insert(tabEquipLoc, 1)
				local tabItem = {}

				table.insert(tabItem, itemLink)
				table.insert(tabItemMeta, itemEquipLoc)
				table.insert(tabItemMeta, tabItem)
			else
				tabEquipLoc[idItemTypeExist + 1] = tabEquipLoc[idItemTypeExist + 1] + 1
				local tmpTab = tabItemMeta[idItemTypeExist + 1]
				table.insert(tmpTab, itemLink)
				tabItemMeta[idItemTypeExist + 1] = tmpTab
			end
		end

		for a = 1, #tabItemMeta do
			if a % 2 == 0 then
				local v = tabItemMeta[a]
				for b = 1, #v do
					print(v[b])
				end
			else
				print(tabItemMeta[a])
			end
		end
		local stuffBefore = GearHelper.charInventory

		for a = 1, #bagInventory do
			local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(bagInventory[a])
			if itemEquipLoc ~= "INVTYPE_WEAPON" and itemEquipLoc ~= "INVTYPE_2HWEAPON" and itemEquipLoc ~= "INVTYPE_FINGER" and itemEquipLoc ~= "INVTYPE_TRINKET" then
				print("On test " .. bagInventory[a])

				local exItem = stuffBefore[GearHelper.itemSlot[itemEquipLoc]]
				local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(exItem, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
			end
		end
		waitEquipTimer = time()
		waitEquipFrame:Show()
	end,
	save = function()
		SaveEquipmentSet("GHEquip", 769) -- Saves the currently equipped items in a set.
	end,
	equip = function()
		UseEquipmentSet("GHEquip") -- Equips an equipment set.
	end,
	remove = function()
		DeleteEquipmentSet("GHEquip") -- Forgets an equipment set.
	end,
	askloot = function()
		if GearHelper.db.profile.askLootRaid == true then
			GearHelper:setGHAskLootRaid(false)
		else
			GearHelper:setGHAskLootRaid(true)
		end
	end,
	dot = function()
		GearHelper:BuildCWTable()
		GearHelper:sendAskVersion()
		GearHelper:ScanCharacter()
		GearHelper:poseDot()
	end,
	suppdot = function()
		GearHelper:suppDot()
	end,
	cw = function()
		InterfaceOptionsFrame:Show()
		InterfaceOptionsFrame_OpenToCategory(GearHelper.cwFrame)
	end,
	eccip = function()
		GearHelper.equipItem(0)
		GearHelper.equipItem(1)
		GearHelper.equipItem(2)
		GearHelper.equipItem(3)
		GearHelper.equipItem(4)
	end,
	ain = function()
		GearHelper:CreateLinkAskIfHeNeeds(1)
	end,
	reset = function()
		GearHelper:setDefault()
	end,
	aze = function()
		GearHelper:CreateLinkAskIfHeNeeds(1)

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
	end,
	reload = function()
		ReloadUI()
	end,
	testdelta = function()
		local equiped = "|cff1eff00|Hitem:128942::::::::100:105::::::|h[Ulthalesh]|h|r"
		local looted = "|cff1eff00|Hitem:71086::::::::100:105::::::|h[Tarecogosa]|h|r"

		local aze = GetItemStatDelta(looted, equiped)

		local tab = GearHelper:getStatsDeltaFromTooltip(looted, equiped)
		table.foreach(tab, print)
		print("++++++++++++++++++++")
		table.foreach(aze, print)
		print("--------------------")
	end,
	jb = function()
		local itemLink = GetContainerItemLink(1, 14)
		local aze = GearHelper:weightCalculation(itemLink)

		table.foreach(aze, print)
	end,
	feet = function()
		local _, equipedItem = GetItemInfo(132455)
		print(equipedItem)
	end,
	printTable = function()
		foreach(waitingIDTable, print)
		print("---")
	end,
	resetCache = function()
		GearHelper:ResetCache()
	end,
	inspect = function()
		if (CheckInteractDistance("target", 1)) then
			if CanInspect("target", true) then
				NotifyInspect("target")
				print("------ NotifyInspect() ------")
			else
				print("impossible d'inspecter ce personnage")
				InspectUnit("target")
			end
		else
			print("trop loin")
		end
	end
}

GearHelper:RegisterChatCommand("GearHelper", "MySlashCommand")
GearHelper:RegisterChatCommand("GH", "MySlashCommand")

function GearHelper:MySlashCommand(input)
	for cmd, action in pairs(slashCmd) do
		if input == cmd then
			action()
			do
				return
			end
		end
	end

	if input == "" then
		InterfaceOptionsFrame:Show()
		InterfaceOptionsFrame_OpenToCategory(GearHelper.cwFrame)
		InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
	else
		slashCmd["help"]()
	end
end
