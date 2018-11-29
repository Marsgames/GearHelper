local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

--[[
Function : Print
Scope : GearHelper
Description : Print object based on debug flag
Input : object = object to print
Output :
Author : Raphaël Saget
]]
function GearHelper:Print(object)
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

--[[
Function : SiObjetGris
Scope : GearHelper
Description : Retourne si un item passé en paramètre est un objet gris ou non
Input : number (id de l'item)
Output : bool (objet gris ? true / false)
Author : Raphaël Daumas
]]
function GearHelper:SiObjetGris(itemID)
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

--[[
Function : IsEquippableByMe
Scope : GearHelper
Description : Retourne si l'item passé en paramètre est équipable par mon perso ou non
Input : number ? (id ded l'item)
Output : bool (est équipable par moi ? true / false)
Author : Raphaël Daumas
Last Modified : Raphaël Saget
]]
function GearHelper:IsEquippableByMe(item)
	local isItMadeForMe = false

	if not IsEquippableItem(item.id) then
		return false
	end

	local myLevel = UnitLevel("player")
	local _, myClass = UnitClass("player")
	local currentSpec = GetSpecialization()
	local playerSpec = GetSpecializationInfo(currentSpec)

	if item.levelRequired > myLevel or item.equipLoc == "INVTYPE_BAG" then
		--Is it a common item shared by all classes ?
		isItMadeForMe = false
	elseif item.equipLoc == "INVTYPE_FINGER" or item.equipLoc == "INVTYPE_NECK" or item.equipLoc == "INVTYPE_TRINKET" or item.equipLoc == "INVTYPE_CLOAK" and item.subType == L["divers"] or item.subType == L.IsEquipable.PRIEST.Tissu then
		--Is it an artifact weapon ?
		isItMadeForMe = true
	elseif item.rarity == "e6cc80" then
		if type(L.Artifact[tostring(playerSpec)]) == "string" then
			if tostring(item.id) == L.Artifact[tostring(playerSpec)] then
				isItMadeForMe = true
			end
		else
			table.foreach(
				L.Artifact[tostring(playerSpec)],
				function(_, v)
					if tostring(item.id) == v then
						isItMadeForMe = true
					end
				end
			)
		end
	elseif item.equipLoc == "INVTYPE_TABARD" or item.equipLoc == "INVTYPE_BODY" then -- Do not consider as equippable because they have no stats and we dont store them in charInventory
		isItMadeForMe = false
	else
		--Is it an item that i can equip with my character ?
		table.foreach(
			L.IsEquipable[tostring(myClass)],
			function(_, v)
				if item.subType == v then
					isItMadeForMe = true
				end
			end
		)
	end
	return isItMadeForMe
end

--[[
Function : IsSlotEmpty
Scope : GearHelper
Description : Test an itemEquiLoc and return if it is empty
Input : equipLoc = item equip location
Output : nil = if item is not in cache / result = array containing true or false
Author : Raphaël Daumas & Raphaël Saget
Last Modified By : Raphaël Saget
]]
function GearHelper:IsSlotEmpty(equipLoc)
	local result = {}
	if equipLoc == "INVTYPE_TRINKET" then
		--Item not cached yet
		if GearHelper.charInventory["Trinket0"] == -2 or GearHelper.charInventory["Trinket1"] == -2 then
			return nil
		end

		if GearHelper.charInventory["Trinket0"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["Trinket1"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	elseif equipLoc == "INVTYPE_FINGER" then
		--Item not cached yet
		if GearHelper.charInventory["Finger0"] == -2 or GearHelper.charInventory["Finger1"] == -2 then
			return nil
		end
		if GearHelper.charInventory["Finger0"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["Finger1"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	elseif equipLoc == "INVTYPE_WEAPON" then
		if GearHelper.charInventory["MainHand"] == -2 or GearHelper.charInventory["SecondaryHand"] == -2 then
			return nil
		end

		if GearHelper.charInventory["MainHand"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["SecondaryHand"] == 0 or GearHelper.charInventory["SecondaryHand"] == -1 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	elseif equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_2HWEAPON" then
		--Item not cached yet
		if GearHelper.charInventory["MainHand"] == -2 or GearHelper.charInventory["SecondaryHand"] == -2 then
			return nil
		end
		--If MainHand is empty
		if GearHelper.charInventory["MainHand"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end

		if GearHelper.charInventory["SecondaryHand"] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	else
		--Item not cached yet
		if GearHelper.charInventory[GearHelper.itemSlot[equipLoc]] == -2 then
			return nil
		end

		if GearHelper.charInventory[GearHelper.itemSlot[equipLoc]] == 0 then
			table.insert(result, true)
		else
			table.insert(result, false)
		end
	end
	return result
end

--[[
Function : IsInTable
Scope : GearHelper
Description : Retourne si un élément est présent dans un tableau
Input : array (le tableau dans lequel on doit chercher), - (l'élément qu'on recherche)
Output : bool (présent ? true / false)
Author : Raphaël Daumas
]]
function GearHelper:IsInTable(array, data)
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

function GearHelper:IsEmptyTable(maTable)
	return (next(maTable) == nil)
end

-- Récupéré sur internet - tranqforme string en array
function GearHelper:MySplit(inputString, separator)
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

--[[
Function :GetStatDeltaBetweenItems
Scope : GearHelper
Description : Compute state delta between 2 item object
Input : looted = looted object / equipped = equipped object
Output : array of delta
Author : Raphaël Saget
]]
function GearHelper:GetStatDeltaBetweenItems(looted, equipped)
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

--[[
Function : GetGemValue
Scope : GearHelper
Description : Return the value of a gem according to the player lvl
Input :
Output :  Value of a gem at this level
Author : Raphaël Saget
]]
function GearHelper:GetGemValue()
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

--[[
Function : ReturnGoodLink
Scope : GearHelper
Description : Créer un item link spécial qui permet d'envoyer automatiquement un message à un joueur
Input : itemLink (le lien ded l'item qu'on veut demander au joueur), string (nom du joueur), string (nom du joueur avec la couleur)
Output : itemLink
Author : Raphaël Daumas
]]
function GearHelper:ReturnGoodLink(itemLink, target, tar)
	local itemString = select(3, strfind(itemLink, "|H(.+)|h"))
	local _, itemId = strsplit(":", itemString)

	if tar == nil then
		tar = ""
	end

	return "|HGHWhispWhenClick:askIfHeNeed_" .. target .. "_" .. itemId .. "_|h" .. tar .. "|h"
	-- return "|HGHWhispWhenClick:askIfHeNeed_"..target.."_"..itemLink.."_|h"..tar.."|h"
end

--[[
Function : CouleurClasse
Scope : GearHelper
Description : Renvoi la couleur de la classe d'un joueur
Input : string (nom anglais ded la classe)
Output : string (couleur de la classe)
Author : Raphaël Daumas
]]
function GearHelper:CouleurClasse(classFileName)
	local color = RAID_CLASS_COLORS[classFileName]

	return "|c" .. color.colorStr

	-- if classID == 1 then -- war
	--     return "|cFFC79C6E"
	-- elseif classID == 2 then -- pala
	--     return "|cFFF58CBA"
	-- elseif classID == 3 then -- hunter
	--     return "|cFFABD473"
	-- elseif classID == 4 then -- rogue
	--     return "|cFFFFF569"
	-- elseif classID == 5 then -- Pretre
	--     return "|cFFFFFFFF"
	-- elseif classID == 6 then -- dk
	--     return "|cFF41F3B"
	-- elseif classID == 7 then -- chamy
	--     return "|cFF0070DE"
	-- elseif classID == 8 then -- mage
	--     return "|cFF69CCF0"
	-- elseif classID == 9 then -- démo
	--     return "|cFF9482C9"
	-- elseif classID == 10 then -- moine
	--     return "|cFF00FF96"
	-- elseif classID == 11 then -- druid
	--     return "|cFFFF7D0A"
	-- elseif classID == 12 then -- DH
	--     return "|cFFA330C9"
	-- end
end

--[[
Function : FindHighestStatInTemplate
Scope : GearHelper
Description : Find the main stat of the actual template
Input :
Output : nil if template is not found / Nothing if template is empty or default / maxK the name of the stat
Author : Raphaël Saget
]]
function GearHelper:FindHighestStatInTemplate()
	if GearHelper.db.profile.weightTemplate == "NOX" then
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		if GearHelper.db.global.templates[currentSpec]["NOX"] ~= nil then
			local maxV = 0
			local maxK = "Nothing"
			for k, v in pairs(GearHelper.db.global.templates[currentSpec]["NOX"]) do
				if tonumber(v) > maxV then
					maxV = v
					maxK = k
				end
			end

			return maxK
		else
			return nil
		end
	else
		if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate] ~= nil then
			local maxV = 0
			local maxK = "Nothing"
			for k, v in pairs(GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate]) do
				if tonumber(v) then
					if v > maxV then
						maxV = v
						maxK = k
					end
				end
			end

			return maxK
		else
			return nil
		end
	end
end

--[[
Function : ColorizeString
Scope : GearHelper
Description : Colorize a string based on a parameter
Input : text = string to colorize / color = color to apply
Output : colorized string or just string if color is invalid
Author : Raphaël Saget
]]
function GearHelper:ColorizeString(text, color)
	local colorList = {}
	colorList.jaune = "|cFFFFFF00"
	colorList.vert = "|cFF00FF00"
	colorList.vertfonce = "|cFF1bad1b"
	colorList.rouge = "|cFFFF0000"
	colorList.rougefonce = "|cFFb51b1b"
	colorList.rose = "|cFFFF1493"
	colorList.mieux = "|cFF00FF96"
	colorList.blanc = "|cFFFFFFFF"
	colorList.noir = "|cFF000000"

	if colorList[color:lower()] ~= nil then
		return colorList[color:lower()] .. text
	else
		return text
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
function GearHelper:NormalizeWeightResult(result)
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

--[[
Function :
Scope : GearHelper
Description :
Input :
Output :
Author : Raphaël Saget
]]
function GearHelper:DoDisplayOverlay(result)
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

-- desc : Fonction qui parse un link en ID
-- entrée : itemLink ( EX : |Hitem:124586:0:0:0:0:12254684455852 )
-- sortie : ID ( EX : 124586 )
-- commentaire :
function GearHelper:parseID(link)
	local a = string.match(link, "item[%-?%d::]+")
	local b = string.sub(a, 5, 12)
	local c = string.gsub(b, ":", "")
	return c
end

--[[
Function : CountingSort
Scope : GearHelper
Description : Algo de tri d'entier qui n'a pas le temps
Input : table d'entiers
Author : Raphaël Daumas
]]
function GearHelper:CountingSort(f)
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
