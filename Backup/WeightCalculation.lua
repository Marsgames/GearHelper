function GearHelper:weightCalculation(itemLootLink)
	if GearHelper.db.profile.addonEnabled then -- si addon activé

		local result = {} -- la table qui retourne le résultat. retourné -1010 si GetItemInfo nil. fonction qui s'en sert rappel weightCalc if -1010

		if itemLootLink ~= nil then -- si GetItemInfo de l'item qu'on vient de loot n'est pas nil
			local itemLootName, lootItem, itemLootRarity, _, _, itemType, itemSubType, _, itemLootEquipLoc, itemLootilvl, equipedItem, itemEquipRarity, Id, tabSpec, slotEmpty, nbGemmes, itemEquipilvl, delta = nil -- on crée les var dont on va se servir

			if GetItemInfo(itemLootLink) then -- si GetItemInfo(itemloot) n'est pas nil on initialise les var sinon on stop la fonction ici
				itemLootName, lootItem, itemLootRarity, _, _, itemType, itemSubType, _, itemLootEquipLoc = GetItemInfo(itemLootLink)
			else-- si GetItemInfo(itemloot) est nil on stop la fonction ici
				print("Error1 : GetitemInfo("..itemLootLink..") == nil")
				-- si c'est un stuff equipable
				--[[]]return -1010
				-- sinon (si c'est un item genre pierre de foyer) ex :1 38019
				----- return un autre code erreur qui dit a la fonction de ne pas s'executer.
				-- end
			end
			if GetDetailedItemLevelInfo(itemLootLink) then
				itemLootilvl = GetDetailedItemLevelInfo(itemLootLink)
			else
				print("Error2 : GetDdetailedItemLevelInfo("..itemLootLink..") == nil")
				return -1010
			end
			if not GearHelper:IsEquipped(itemLootLink) and GearHelper:IsEquipableByMe(itemLootLink) then -- si l'item n'est pas équipé mais est équipable

				if string.find(itemLootLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?") then
					_, _, _, _, Id = string.find(itemLootLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
				else
					print("Error3 : impossible de trouver l'ID de "..itemLootLink)
					return -1010
				end
				if GetItemSpecInfo(itemLootLink) then
					tabSpec = GetItemSpecInfo(itemLootLink)  -- renvoi les spé qui peuvent utiliser cet item
				else
					print("Error4 : tabSpec vide pour "..itemLootLink)
					return -1010
				end
				if GearHelper:IsSlotEmpty(itemLootEquipLoc) then
					slotEmpty = GearHelper:IsSlotEmpty(itemLootEquipLoc)
				else
					print("Error5 : GearHelper:IsSlotEmpty("..itemLootEquipLoc..") == nil")
					return -1010
				end
				if GearHelper:GetNumSockets(itemLootLink) then
					nbGemmes = GearHelper:GetNumSockets(itemLootLink)
				else
					print("Error6 : GetNumSockets("..itemLootLink..") == nil")
					return -1010
				end
				-- toutes les variables sont initialisées sinon on est sorti de la fonction avec un code erreur -1010, on sait qu'il faut relancer la fonction quand ITEM_INFO_RECEIVED

				if itemLootEquipLoc ~= nil then

					if itemLootEquipLoc == "INVTYPE_TRINKET" or itemLootEquipLoc == "INVTYPE_FINGER" then
						local slotsList = GearHelper.itemSlot[itemLootEquipLoc]
						for index, slot in pairs(slotsList) do
							if slotEmpty[index] == false then
								if(GetItemInfo(GearHelper.charInventory[slotsList[index]])) then
									_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory[slotsList[index]])
								else
									print("Error7 : GetItemInfo("..GearHelper.charInventory[slotsList[index]]..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(GearHelper.charInventory[slotsList[index]]) then
									itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory[slotsList[index]])
								else
									print("Error8 : GetDetailedItemLevelInfo("..GearHelper.charInventory[slotsList[index]]..") == nil")
									return -1010
								end
								if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
									delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
								else
									print("Error9 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
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
								print("Error10 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, MHequipedItem) then
								MHdelta = GearHelper:getStatsDeltaFromTooltip(lootItem, MHequipedItem)
							else
								print("Error11 : getStatsDeltaFromTooltip("..lootItem..", "..MHequipedItem..") == nil")
								return -1010
							end

							MHilvlDelta = itemLootilvl - MHitemEquipilvl
							MHdelta["ilvl"] = 0--MHilvlDelta

							if GetItemInfo(GearHelper.charInventory["SecondaryHand"]) then
								_, SHequipedItem, SHitemEquipRarity = GetItemInfo(GearHelper.charInventory["SecondaryHand"])
							else
								print("Error12 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
								SHitemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
							else
								print("Error13 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, SHequipedItem) then
								SHdelta = GearHelper:getStatsDeltaFromTooltip(lootItem, SHequipedItem)
							else
								print("Error14 : getStatsDeltaFromTooltip("..lootItem..", "..SHequipedItem..") == nil")
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
									print("Error15 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
									itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
								else
									print("Error16 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
									return -1010
								end
								if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
									delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
								else
									print("Error17 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
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
									print("Error18 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
									MHitemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
								else
									print("Error19 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") = nil")
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
								print("Error20 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
							else
								print("Error21 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
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
								print("Error22 : getStatsFromTooltip("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if getStatsFromTooltip(GearHelper.charInventory["SecondaryHand"]) then
								offHand = getStatsFromTooltip(GearHelper.charInventory["SecondaryHand"])
							else
								print("Error23 : getStatsFromTooltip("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsFromTooltip(lootItem) then
								lootItemStats = GearHelper:getStatsFromTooltip(lootItem)
							else
								print("Error24 : getStatsFromTooltip("..lootItem..") == nil")
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
								print("Error25 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
							else
								print("Error26 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								print("Error27 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
								return -1010
							end

							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						elseif not slotEmpty[1] and slotEmpty[2] then
							if GetItemInfo(GearHelper.charInventory["MainHand"]) then
								_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
							else
								print("Error28 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
							else
								print("Error29 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								print("Error30 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
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
							print("Error31 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
							return -1010
						end
						if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
							itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
						else
							print("Error32 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
							return -1010
						end
						if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
							delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
						else
							print("Error33 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
							return -1010
						end

						local ilvlDelta = itemLootilvl - itemEquipilvl
						delta["ilvl"] = 0--ilvlDelta
						table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
					elseif itemLootEquipLoc == "INVTYPE_WEAPONOFFHAND" then -- equipable uniquement en main gauche (ex : glaive de guerre d'aziznoth)
						if GetItemInfo(GearHelper.charInventory["SecondaryHand"]) then
							_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["SecondaryHand"])
						else
							print("Error34 : GetItemInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
							return -1010
						end
						if GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"]) then
							itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["SecondaryHand"])
						else
							print("Error35 : GetDetailedItemLevelInfo("..GearHelper.charInventory["SecondaryHand"]..") == nil")
							return -1010
						end
						if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
							delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
						else
							print("Error36 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
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
								print("Error37 : GetItemInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])) then
								itemEquipilvl = GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]]))
							else
								print("Error38 : GetDetailedItemLevelInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								print("Error39 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") = nil")
								return -1010
							end

							local ilvlDelta = itemLootilvl - itemEquipilvl
							delta["ilvl"] = 0--ilvlDelta
							table.insert(result, GearHelper:diffItemValueTemplate(delta, nbGemmes))
						elseif slotEmpty[1] == false then
							if GetItemInfo(GearHelper.charInventory["MainHand"]) then
								_, equipedItem, itemEquipRarity = GetItemInfo(GearHelper.charInventory["MainHand"])
							else
								print("Error40 : GetItemInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"]) then
								itemEquipilvl = GetDetailedItemLevelInfo(GearHelper.charInventory["MainHand"])
							else
								print("Error41 : GetDetailedItemLevelInfo("..GearHelper.charInventory["MainHand"]..") == nil")
								return -1010
							end
							if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
								delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
							else
								print("Error42 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
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
									print("Error43 : GetItemInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
									return -1010
								end
								if GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])) then
									itemEquipilvl = GetDetailedItemLevelInfo(tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]]))
								else
									print("Error44 : GetDetailedItemLevelInfo("..tostring(GearHelper.charInventory[GearHelper.itemSlot[itemLootEquipLoc]])..") == nil")
									return -1010
								end
								if GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem) then
									delta = GearHelper:getStatsDeltaFromTooltip(lootItem, equipedItem)
								else
									print("Error45 : getStatsDeltaFromTooltip("..lootItem..", "..equipedItem..") == nil")
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
