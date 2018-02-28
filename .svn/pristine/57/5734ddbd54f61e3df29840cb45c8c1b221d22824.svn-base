--[[
Function : GetStat
Scope : Test
Description :
Input :
Output :
Author : Raphaël Daumas
]]
----------------------------------------- Corriger certains problèmes main gauche / main droite ----------------------------
--[[
Function : IsEquipableByMe
Scope : GearHelper
Description :
Input :
Output :
Author : Raphaël Daumas
Last Modified : Raphaël Saget
]]

function GearHelper:IsEquipableByMe(itemLink)
  if IsEquippableItem(itemLink) then
    local _, _, quality, _, reqLevel, _, subclass, _, equipSlot, _, _ = GetItemInfo(itemLink)
    local myLevel = UnitLevel("player")
    local _, myClass = UnitClass("player")
    local isItMadeForMe = false
    local currentSpec = GetSpecialization()
    local playerSpec = GetSpecializationInfo(currentSpec)
    local _, _, _, _, itemID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

    --Is it an item that i can equip with my character ?
    table.foreach(L.IsEquipable[tostring(myClass)], function(_, v)
      if subclass == v then
        isItMadeForMe = true
      end
    end)

    if isItMadeForMe == false then
      return false
      --Is the required level not too high ?
    elseif reqLevel ~= nil and reqLevel > myLevel then
      return false
      --Is it a common item shared by all classes ?
    elseif equipSlot == "INVTYPE_FINGER" or equipSlot == "INVTYPE_NECK" or equipSlot == "INVTYPE_TRINKET" or equipSlot == "INVTYPE_BODY" or equipSlot == "INVTYPE_TABARD" or equipSlot == "INVTYPE_CLOAK" and subclass == L["divers"] and equipSlot ~= "INVTYPE_BAG" then
      return true
      --Is it an artifact weapon ?
    elseif quality == 6 then
      if type(L.Artifact[tostring(playerSpec)]) == "string" then
        if tostring(itemID) == L.Artifact[tostring(playerSpec)] then
          return true
        end
      else
        table.foreach(L.Artifact[tostring(playerSpec)], function(_, v)
          if tostring(itemID) == v then
            return true
          end
        end)
      end
      --If this is an equipable item by me but not an item that require a specific return, just return true
    else
      return true
    end

  else
    return false
  end
end

--[[
Function : IsEquipped
Scope : GearHelper
Description :
Input :
Output :
Author : Raphaël Daumas
]]

function GearHelper:IsEquipped(itemLink)
  local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
  if itemEquipLoc == "INVTYPE_TRINKET" then
    if GearHelper.charInventory["Trinket0"] == itemLink or GearHelper.charInventory["Trinket1"] == itemLink then
      return true
    end
  elseif itemEquipLoc == "INVTYPE_FINGER" then
    if GearHelper.charInventory["Finger0"] == itemLink or GearHelper.charInventory["Finger1"] == itemLink then
      return true
    end
  elseif itemEquipLoc== "INVTYPE_WEAPON" then
    if GearHelper.charInventory["MainHand"] == itemLink or GearHelper.charInventory["SecondaryHand"] == itemLink then
      return true
    end
  else
    if GearHelper.charInventory[GearHelper.itemSlot[itemEquipLoc]] == itemLink then
      return true
    end
  end
  return false
end

function GearHelper:weightCalculation(itemLootLink)
	if GearHelper.db.profile.addonEnabled then -- si addon activé
		local result = {} -- la table qui retourne le résultat. retourné -1010 si GetItemInfo nil. fonction qui s'en sert rappel weightCalc if -1010

		if itemLootLink ~= nil then -- si GetItemInfo de l'item qu'on vient de loot n'est pas nil
			local itemLootName, lootItem, itemLootRarity, _, _, itemType, itemSubType, _, itemLootEquipLoc, itemLootilvl, equipedItem, itemEquipRarity, Id, tabSpec, slotEmpty, nbGemmes, itemEquipilvl, delta = nil -- on crée les var dont on va se servir

			if GetItemInfo(itemLootLink) then -- si GetItemInfo(itemloot) n'est pas nil on initialise les var sinon on stop la fonction ici
				itemLootName, lootItem, itemLootRarity, _, _, itemType, itemSubType, _, itemLootEquipLoc = GetItemInfo(itemLootLink)
			else-- si GetItemInfo(itemloot) est nil on stop la fonction ici
				GearHelper:Print("Error1 : GetitemInfo("..itemLootLink..") == nil")
				-- si c'est un stuff equipable
				--[[]]return -1010
				-- sinon (si c'est un item genre pierre de foyer) ex :1 38019
				----- return un autre code erreur qui dit a la fonction de ne pas s'executer.
				-- end
			end
			if GetDetailedItemLevelInfo(itemLootLink) then
				itemLootilvl = GetDetailedItemLevelInfo(itemLootLink)
			else
				GearHelper:Print("Error2 : GetDdetailedItemLevelInfo("..itemLootLink..") == nil")
				return -1010
			end
			if not GearHelper:IsEquipped(itemLootLink) and GearHelper:IsEquipableByMe(itemLootLink) then -- si l'item n'est pas équipé mais est équipable

				if string.find(itemLootLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?") then
					_, _, _, _, Id = string.find(itemLootLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
				else
					GearHelper:Print("Error3 : impossible de trouver l'ID de "..itemLootLink)
					return -1010
				end
				if GetItemSpecInfo(itemLootLink) then
					tabSpec = GetItemSpecInfo(itemLootLink)  -- renvoi les spé qui peuvent utiliser cet item
				else
					GearHelper:Print("Error4 : tabSpec vide pour "..itemLootLink)
					return -1010
				end
				if GearHelper:IsSlotEmpty(itemLootEquipLoc) then
					slotEmpty = GearHelper:IsSlotEmpty(itemLootEquipLoc)
				else
					GearHelper:Print("Error5 : GearHelper:IsSlotEmpty("..itemLootEquipLoc..") == nil")
					return -1010
				end
				if GearHelper:GetNumSockets(itemLootLink) then
					nbGemmes = GearHelper:GetNumSockets(itemLootLink)
				else
					GearHelper:Print("Error6 : GetNumSockets("..itemLootLink..") == nil")
					return -1010
				end
				-- toutes les variables sont initialisées sinon on est sorti de la fonction avec un code erreur -1010, on sait qu'il faut relancer la fonction quand ITEM_INFO_RECEIVED

				if itemLootEquipLoc ~= nil then

					if itemLootEquipLoc == "INVTYPE_TRINKET" or itemLootEquipLoc == "INVTYPE_FINGER" then
						local slotsList = GearHelper.itemSlot[itemLootEquipLoc]
						for index, slot in pairs(slotsList) do
							if slotEmpty[index] == false then
								if (GetItemInfo(GearHelper.charInventory[slotsList[index]])) then
									_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory[slotsList[index]])
								else
									GearHelper:Print("Error7 : GetItemInfo("..GearHelper.charInventory[slotsList[index]]..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(GearHelper.charInventory[slotsList[index]]) then
									itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory[slotsList[index]])
								else
									GearHelper:Print("Error8 : GetDetailedItemLevelInfo("..GearHelper.charInventory[slotsList[index]]..") == nil")
									return -1010
								end
								if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
									delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
								else
									GearHelper:Print("Error9 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
									return -1010
								end

								local ilvlDelta = itemLootilvl - itemEquipilvl
								delta["ilvl"] = 0--ilvlDelta
								table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))

							else
								table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
							end
						end
					elseif itemLootEquipLoc == "INVTYPE_WEAPON" then -- Masse à une main / épée à 1 main / Dague 1 main
						if not slotEmpty[1] and not slotEmpty[2] then
							local MHequipedItem, MHitemEquipRarity, MHitemEquipilvl, MHdelta, MHilvlDelta = nil
							local SHequipedItem, SHitemEquipRarity, SHitemEquipilvl, SHdelta, SHilvlDelta = nil

							if GetItemInfo(GearHelper.charInventory["MainHand"]) then
								_, MHequipedItem, MHitemEquipRarity, MHitemEquipilvl = GetItemInfo(GearHelper.charInventory["MainHand"])
							else
								GearHelper:Print("Error10 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, MHequipedItem) then
								MHdelta = GearHelper:getStatsDeltaFromTooltip(lootItem, MHequipedItem)
							else
								GearHelper:Print("Error11 : getStatsDeltaFromTooltip("..lootItem..", "..MHequipedItem..") == nil")
								return -1010
							end

							MHilvlDelta = itemLootilvl - MHitemEquipilvl
							MHdelta["ilvl"] = 0--MHilvlDelta

							if GetItemInfo(GearHelper.charInventory["SecondaryHand"]) then
								_, SHequipedItem, SHitemEquipRarity = GetItemInfo(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error12 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
								SHitemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error13 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, SHequipedItem) then
								SHdelta = GearHelper:getStatsDeltaFromTooltip(lootItem, SHequipedItem)
							else
								GearHelper:Print("Error14 : getStatsDeltaFromTooltip("..lootItem..", "..SHequipedItem..") == nil")
								return -1010
							end

							SHilvlDelta = itemLootilvl - SHitemEquipilvl
							SHdelta["ilvl"] = 0--SHilvlDelta

							table.insert(result, GearHelper:diffItemValueTemplate(MHdelta, nbGemmes))
							table.insert(result, GearHelper:diffItemValueTemplate(SHdelta, nbGemmes))

						elseif not slotEmpty[1] and slotEmpty[2] then
							if GearHelper.charInventory["SecondaryHand"] == -1 then
								if GetItemInfo(GearHelper.charInventory["MainHand"]) then
									_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
								else
									GearHelper:Print("Error15 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
									itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
								else
									GearHelper:Print("Error16 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
									return -1010
								end
								if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
									delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
								else
									GearHelper:Print("Error17 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
									return -1010
								end

								local ilvlDelta = itemLootilvl - itemEquipilvl
								delta["ilvl"] = 0--ilvlDelta
								table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
							else
								local MHequipedItem, MHitemEquipRarity, MHitemEquipilvl, MHdelta, MHilvlDelta = nil

								if GetItemInfo(GearHelper.charInventory["MainHand"]) then
									_, MHequipedItem, MHitemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
								else
									GearHelper:Print("Error18 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
									MHitemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
								else
									GearHelper:Print("Error19 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") = nil")
									return -1010
								end


								local MHilvlDelta = itemLootilvl - MHitemEquipilvl
								MHdelta["ilvl"] = 0--MHilvlDelta

								table.insert(result, GearHelper:diffItemValueTemplate(MHdelta, nbGemmes))
								table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
							end
						elseif slotEmpty[1] and not slotEmpty[2] then
							table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))

							if GetItemInfo(GearHelper.charInventory["SecondaryHand"]) then
								_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error20 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error21 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end

							local delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						else
							table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
							table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
						end
					elseif itemLootEquipLoc == "INVTYPE_2HWEAPON" or itemLootEquipLoc == "INVTYPE_RANGED" or itemLootEquipLoc == "INVTYPE_RANGEDRIGHT" and slotEmpty[2] == false then -- baton / Canne à pêche / hache à 2 main / masse 2 main / épée 2 main AND arc
						if not slotEmpty[1] and not slotEmpty[2] then
							local mainHand, offHand, lootItemStats = nil
							local mainAndOff, delta = {}, {}

							if getStatsFromTooltip(GearHelper.charInventory["MainHand"]) then
								mainHand = getStatsFromTooltip(GearHelper.charInventory["MainHand"])
							else
								GearHelper:Print("Error22 : getStatsFromTooltip("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if getStatsFromTooltip(GearHelper.charInventory["SecondaryHand"]) then
								offHand = getStatsFromTooltip(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error23 : getStatsFromTooltip("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsFromTooltip(lootItem) then
								lootItemStats = GearHelper:getStatsFromTooltip(lootItem)
							else
								GearHelper:Print("Error24 : getStatsFromTooltip("..lootItem..") == nil")
								return -1010
							end


							table.foreach(mainHand, function(k, v)
								mainAndOff[k] = mainHand[k] + offHand[k]
							end)

							table.foreach(mainAndOff, function(k, v)
								delta[k] = lootItemStats[k] - mainAndOff[k]
							end)

							delta["ilvl"] = 0
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))

						elseif slotEmpty[1] and not slotEmpty[2] then
							if GetItemInfo(GearHelper.charInventory["SecondaryHand"]) then
								_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error25 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
							else
								GearHelper:Print("Error26 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								GearHelper:Print("Error27 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
								return -1010
							end

							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						elseif not slotEmpty[1] and slotEmpty[2] then
							if GetItemInfo(GearHelper.charInventory["MainHand"]) then
								_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
							else
								GearHelper:Print("Error28 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
							else
								GearHelper:Print("Error29 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								GearHelper:Print("Error30 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
								return -1010
							end

							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						else
							table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
						end
					elseif itemLootEquipLoc == "INVTYPE_WEAPONMAINHAND" then -- equipable uniquement en main droite (ex : glaive de guerre d'aziznoth)
						if GetItemInfo(GearHelper.charInventory["MainHand"]) then
							_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
						else
							GearHelper:Print("Error31 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
							return -1010
						end
						if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
							itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
						else
							GearHelper:Print("Error32 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
							return -1010
						end
						if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
							delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
						else
							GearHelper:Print("Error33 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
							return -1010
						end

						local ilvlDelta = itemLootilvl - itemEquipilvl
						delta["ilvl"] = 0--ilvlDelta
						table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
					elseif itemLootEquipLoc == "INVTYPE_WEAPONOFFHAND" then -- equipable uniquement en main gauche (ex : glaive de guerre d'aziznoth)
						if GetItemInfo(GearHelper.charInventory["SecondaryHand"]) then
							_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["SecondaryHand"])
						else
							GearHelper:Print("Error34 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
							return -1010
						end
						if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
							itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
						else
							GearHelper:Print("Error35 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
							return -1010
						end
						if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
							delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
						else
							GearHelper:Print("Error36 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
							return -1010
						end

						local ilvlDelta = itemLootilvl - itemEquipilvl
						delta["ilvl"] = 0--ilvlDelta
						table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
					elseif itemLootEquipLoc == "INVTYPE_HOLDABLE" or itemLootEquipLoc == "INVTYPE_SHIELD" then
						if slotEmpty[2] == false then
							if GetItemInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])) then
								_, equipedItem, itemEquipRarity = GetItemInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]]))
							else
								GearHelper:Print("Error37 : GetItemInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])) then
								itemEquipilvl = GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]]))
							else
								GearHelper:Print("Error38 : GetDetailedItemLevelInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								GearHelper:Print("Error39 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") = nil")
								return -1010
							end

							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						elseif slotEmpty[1] == false then
							if GetItemInfo(GearHelper.charInventory["MainHand"]) then
								_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
							else
								GearHelper:Print("Error40 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
							else
								GearHelper:Print("Error41 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								GearHelper:Print("Error42 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
								return -1010
							end

							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						else
							table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
						end
					else
						if slotEmpty[1] == false then -- Si il y a un item equipé
							if GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]] ~= nil then
								if GetItemInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])) then
									_, equipedItem, itemEquipRarity = GetItemInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]]))
								else
									GearHelper:Print("Error43 : GetItemInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])) then
									itemEquipilvl = GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]]))
								else
									GearHelper:Print("Error44 : GetDetailedItemLevelInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
									return -1010
								end
								if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
									delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
								else
									GearHelper:Print("Error45 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
									return -1010
								end
								local ilvlDelta = itemLootilvl - itemEquipilvl
								delta["ilvl"] = 0--ilvlDelta
								table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
							end
						else
							table.insert(result, GearHelper:diffItemValueTemplate(GearHelper:getStatsFromTooltip(lootItem), nbGemmes))
						end
					end
				end
			else -- Si l'item n'est pas équipable ou est déjà équipé
				if not GearHelper:IsEquipped(itemLootLink) and itemLootEquipLoc ~= nil and itemLootEquipLoc ~= "" then -- si l'item n'est juste pas équipable
					table.insert(result, -100000)
				end
			end

			return result -- tous les calculs sont fait, on peut retourner le résultat

		end -- fin GetItemInfo de l'item qu'on a loot n'est pas nil
	end -- fin si addon activé
	------------------------------------------ JE CROIS QUE JE VAIS M'ARRÊTER ICI ------------------------------------------
end

--------------------------------------------------------------------------
-- Parse an item tooltip to get all stats                               --
-- @author Raphaël Daumas                                               --
--------------------------------------------------------------------------
function GearHelper:getStatsFromTooltip(item)
	local tip = myTooltipFromTemplate or CreateFrame("GAMETOOLTIP", "myTooltipFromTemplate",nil,"GameTooltipTemplate")
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")
	local itemLink = string.match(item, "item[%-?%d:]+")
	tip:SetHyperlink(itemLink)

	-- si la 2ème ligne contient : outil raids forgé par les titans
	-- outil raid de guerre
	-- saison 5 dde légion délaissé de guerre
	--Héroïque
	--outil raids
	--héroïque de guerre
	-- outil raids de guerre
	-- délaissé
	-- de guerre
	-- forgé par les titans

	local itemLooted = {}
	for i=1,tip:NumLines() do
		local mytext = _G["myTooltipFromTemplateTextLeft" .. i]
		local text = mytext:GetText()
		if string.find(text, '+') and not string.find(text, "Bonus") and not string.find(text, "Enchanté") and not string.find(text, "à") then
			--print(text)
			local number, stat, j = "", "", 0
			for word in string.gmatch(text, '([^ ]+)') do
				if j == 0 then
					number = word:match("([^+]+)")
				elseif j == 1 then
					if string.find(L.Tooltip["Crit"], word) then
						stat = L.Tooltip["Crit"]
					else
						stat = tostring(word)
					end
				end
				j = j + 1
			end

			number = (number:gsub("[^1234567890]", ""))

			itemLooted[stat] = tonumber(number)
		end
	end

	local tableTemp = {}
	for k, v in pairs(itemLooted) do -- pour chaque element de la liste
		tableTemp[k] = k
	end
	for kk, vv in pairs(L.Tooltip) do
		if not GearHelper:IsInTable(tableTemp, vv) then
			itemLooted[vv] = 0
		end
	end

	itemLooted["Bonus"] = nil
	return itemLooted
	-- end
end

-----------------------------------------------------------------
-- Return the delta between 2 items                            --
-- @author Raphaël Daumas                                      --
-----------------------------------------------------------------
function GearHelper:getStatsDeltaFromTooltip(looted, equiped)

	if looted == nil then
		--print("getStatsDeltaFromTooltip looted nil, c'est pas normal, verifier pourquoi")
	end
	if equiped == nil then
		--print("getStatsDeltaFromTooltip equiped nil, vérifier si un item est equipé")
		--print("item test : "..looted)
	end

	local statsEquiped = GearHelper:getStatsFromTooltip(equiped)
	local statsLooted = GearHelper:getStatsFromTooltip(looted)

	local deltaTable = {}
	table.foreach(statsEquiped, function(k, v)

		local numberStatsEquiped = statsEquiped[k]--:gsub("[^1234567890]", "")

		local numberStatsLooted = statsLooted[k]--:gsub("[^1234567890]", "")

		if tonumber(numberStatsEquiped) == nil or tonumber(numberStatsLooted) == nil then
			print("please send a mail to marsgamess@gmail.com with : \"Erreur fonction getStatsFromTooltip. Tester avec stuff "..equiped.." et "..looted.."\" Thank you")
			print(cRose.."please send a mail to marsgamess@gmail.com with : \"Erreur fonction getStatsFromTooltip. Tester avec stuff "..equiped.." et "..looted.."\" Thank you")
			print("please send a mail to marsgamess@gmail.com with : \"Erreur fonction getStatsFromTooltip. Tester avec stuff "..equiped.." et "..looted.."\" Thank you")
		end

		if(tostring(numberStatsLooted - numberStatsEquiped) ~= 0) then
			deltaTable[k] = tostring(numberStatsLooted - numberStatsEquiped)
			-- print("==> "..deltaTable[k])
		end

	end)

	--table.foreach(deltaTable, print)
	return deltaTable
end
-----------------------------------------------------------------
-- Function to store actual equiped stuff in charInventory     --
-- @author Raphaël Saget                                       --
-----------------------------------------------------------------
function GearHelper:scanCharacter()
	local count = 0

	if GetInventoryItemID("player",GetInventorySlotInfo("HeadSlot")) ~= nil then
		GearHelper.charInventory["Head"] = GetInventoryItemID("player", GetInventorySlotInfo("HeadSlot"))
	else
		GearHelper.charInventory["Head"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("NeckSlot")) ~= nil then
		GearHelper.charInventory["Neck"] = GetInventoryItemID("player",GetInventorySlotInfo("NeckSlot"))
	else
		GearHelper.charInventory["Neck"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("ShoulderSlot")) ~= nil then
		GearHelper.charInventory["Shoulder"] = GetInventoryItemID("player",GetInventorySlotInfo("ShoulderSlot"))
	else
		GearHelper.charInventory["Shoulder"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("BackSlot")) ~= nil then
		GearHelper.charInventory["Back"] = GetInventoryItemID("player",GetInventorySlotInfo("BackSlot"))
	else
		GearHelper.charInventory["Back"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("ChestSlot")) ~= nil then
		GearHelper.charInventory["Chest"] = GetInventoryItemID("player",GetInventorySlotInfo("ChestSlot"))
	else
		GearHelper.charInventory["Chest"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("WristSlot")) ~= nil then
		GearHelper.charInventory["Wrist"] = GetInventoryItemID("player",GetInventorySlotInfo("WristSlot"))
	else
		GearHelper.charInventory["Wrist"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("HandsSlot")) ~= nil then
		GearHelper.charInventory["Hands"] = GetInventoryItemID("player", GetInventorySlotInfo("HandsSlot"))
	else
		GearHelper.charInventory["Hands"] =  0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("WaistSlot")) ~= nil then
		GearHelper.charInventory["Waist"] = GetInventoryItemID("player",GetInventorySlotInfo("WaistSlot"))
	else
		GearHelper.charInventory["Waist"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("LegsSlot")) ~= nil then
		GearHelper.charInventory["Legs"] = GetInventoryItemID("player",GetInventorySlotInfo("LegsSlot"))
	else
		GearHelper.charInventory["Legs"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("FeetSlot")) ~= nil then
		GearHelper.charInventory["Feet"] = GetInventoryItemID("player",GetInventorySlotInfo("FeetSlot"))
	else
		GearHelper.charInventory["Feet"] =  0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("Finger0Slot")) ~= nil then
		GearHelper.charInventory["Finger0"] = GetInventoryItemID("player",GetInventorySlotInfo("Finger0Slot"))
	else
		GearHelper.charInventory["Finger0"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("Finger1Slot")) ~= nil then
		GearHelper.charInventory["Finger1"] = GetInventoryItemID("player",GetInventorySlotInfo("Finger1Slot"))
	else
		GearHelper.charInventory["Finger1"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("Trinket0Slot")) ~= nil then
		GearHelper.charInventory["Trinket0"] = GetInventoryItemID("player",GetInventorySlotInfo("Trinket0Slot"))
	else
		GearHelper.charInventory["Trinket0"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("Trinket1Slot")) ~= nil then
		GearHelper.charInventory["Trinket1"] = GetInventoryItemID("player",GetInventorySlotInfo("Trinket1Slot"))
	else
		GearHelper.charInventory["Trinket1"] = 0
	end
	if GetInventoryItemID("player",GetInventorySlotInfo("MainHandSlot")) ~= nil then
		GearHelper.charInventory["MainHand"] = GetInventoryItemID("player",GetInventorySlotInfo("MainHandSlot"))

		local _, _, _, _, _, _, _, _, itemEquipLocWeapon = GetItemInfo(GearHelper.charInventory["MainHand"])

		if itemEquipLocWeapon == "INVTYPE_2HWEAPON" or itemEquipLocWeapon == "INVTYPE_RANGED" then
			GearHelper.charInventory["SecondaryHand"] = -1
		else
			if GetInventoryItemID("player",GetInventorySlotInfo("SecondaryHandSlot")) ~= nil then
				GearHelper.charInventory["SecondaryHand"] = GetInventoryItemID("player",GetInventorySlotInfo("SecondaryHandSlot"))
			else
				GearHelper.charInventory["SecondaryHand"] = 0
			end
		end
	else
		GearHelper.charInventory["MainHand"] = 0

		if GetInventoryItemID("player",GetInventorySlotInfo("SecondaryHandSlot")) ~= nil then
			GearHelper.charInventory["SecondaryHand"] = GetInventoryItemID("player",GetInventorySlotInfo("SecondaryHandSlot"))
		else
			GearHelper.charInventory["SecondaryHand"] = 0
		end
	end

	local length = 0
	for k, v in pairs(GearHelper.charInventory) do
		length = length + 1

		if GetItemInfo(v) then
		else
			if v ~= -1 and  v ~= 0 then
				tinsert(waitingIDTable, v)
			end
		end
	end
end
-- desc : Inventoriage des sacs
-- entrée :
-- sortie :
-- commentaire :
function GearHelper:ScanBag()
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink ~= nil and GearHelper:IsEquippableByMe(itemLink) then
				table.insert(GearHelper.bagInventory, itemLink)
			end
		end
	end
end
function GearHelper:GetStat(nomStat)

    local statTable = {}
    statTable["crit"] = 10
    statTable["ponction"] = 17
    statTable["haste"] = 20
    statTable["avoid"] = 21
    statTable["mastery"] = 26
    statTable["vers"] = 30

    statTable["versatility"] = statTable["vers"]
    statTable["poly"] = statTable["vers"]
    statTable["polyvalence"] = statTable["vers"]
    statTable["maitrise"] = statTable["mastery"]
    statTable["avoidance"] = statTable["avoid"]
    statTable["evitement"] = statTable["avoid"]
    statTable["hate"] = statTable["haste"]
    statTable["lifesteal"] = statTable["ponction"]
    statTable["critique"] = statTable["crit"]
    statTable["critic"] = statTable["crit"]

    if statTable[nomStat] == nil then
        return -1
    else
        return GetCombatRating(statTable[string.lower(nomStat)])
    end
end

--[[
Function : IsMonture
Scope : Test
Description :
Input :
Output :
Author : Raphaël Daumas
]]

function GearHelper:IsMonture(lootName)

    -- test si monture
    local i = 1
    local creatureName  = C_MountJournal.GetDisplayedMountInfo(i)
    while creatureName ~= nil do
        if creatureName == lootName then
            return true
        end
        i = i + 1
        creatureName  = C_MountJournal.GetDisplayedMountInfo(i)
    end

    -- test mascotte
    i = 1
    local _, _, owned, _, _, _, _, speciesName, _, _, _, _, _, _, _, isTradeable = C_PetJournal.GetPetInfoByIndex(i)
    while speciesName ~= nil do
        if creatureName == speciesName then
            if not owned then
                return true
            elseif owned and isTradeable then
                return true
            end
        end
        i = i+1
        _, _, owned, _, _, _, _, speciesName, _, _, _, _, _, _, _, isTradeable = C_PetJournal.GetPetInfoByIndex(i)
    end
    -- test jouet

    --test légendaire
    local _, _, itemRarity = GetItemInfo(lootName)
    if itemRarity ~= nil and itemRarity > 4 then
        return true
    end


    return false
end

function GearHelper:nbSlotsTotal()
    local nbSlots = 0
    local i = 0
    while i <= 23 do
        if GetContainerNumSlots(i)  then
            nbSlots = nbSlots + GetContainerNumSlots(i)
        end
        i = i + 1
    end
    return nbSlots
end

function GearHelper:isPossibleEquip(itemLink)
    -- Pourquoi ne pas utiliser IsEquippableItem() ? (fonction api)
    local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)

    if itemEquipLoc == "" then
        if UnitName("player") == "Marsgames nil" then
            print("isPossibleEquip = false (result : \"\") --> "..itemLootLink)
        end
        return false
    elseif itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPON" then
        if GearHelper.charInventory["SecondaryHand"] == -1 then
            return false
        else
            return true
        end
    else
        return true
    end
end

function table.isEmpty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end
