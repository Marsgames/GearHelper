local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

--[[
Function : GetInvMsg
Scope : local
Description : Return the invite message set by the user
Output : the invite message
Author : Raphaël Daumas
]]
local function GetInvMsg()
	return GearHelper.db.profile.inviteMessage
end

--[[
Function : GetMyNames
Scope : local
Description : Return names 
Output : names
Author : Raphaël Daumas
]]
local function GetMyNames()
	if (GearHelper.db.global.myNames == {}) then
		table.insert(GearHelper.db.global.myNames, GetUnitName("player") .. ",")
	end

	return GearHelper.db.global.myNames
end

--[[
Function : GetStatCW
Scope : local
Description : Return a particular stat from a template
Input : info = name of the template, stat = stat name in template
Output : the value associated to the stat
Author : Raphaël Saget
]]
local function GetStatCW(info, stat, bool)
	if bool then
		local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))
		return tostring(GearHelper.db.global.templates[(currentSpec)]["NOX"][stat])
	else
		if GearHelper.db.profile.CW[info[1]].DisplayAsPercentage then
			local valAsPercentage = (GearHelper.db.profile.CW[info[1]][stat] / 50) * 100
			return tostring(valAsPercentage)
		else
			return tostring(GearHelper.db.profile.CW[info[1]][stat])
		end
	end
end

--[[
Function : SetStatCW
Scope : local
Description : Set a particular stat in a template
Input : info = name of the template, val = value of the stat, stat = stat name in template
Output : the value associated to the stat
Author : Raphaël Saget
]]
local function SetStatCW(info, val, stat)
	if GearHelper.db.profile.CW[info[1]].DisplayAsPercentage then
		GearHelper.db.profile.CW[info[1]][stat] = (tonumber(val) / 100) * 50
		return tostring(GearHelper.db.profile.CW[info[1]][stat])
	else
		GearHelper.db.profile.CW[info[1]][stat] = tonumber(val)
		return tostring(GearHelper.db.profile.CW[info[1]][stat])
	end
end

--[[
Function : ValidateInputPattern
Scope : local
Description : Validate if input is only composed of number or alphabetic character
Input : val = the string to check, stat = type to validate
Output : true if the string is compliant or a string with the error message if not
Author : Raphaël Saget
]]
local function ValidateInputPattern(val, type, info)
	if type == "number" then
		if string.match(val, "(%D+)") and string.len(val) ~= 0 then
			return "Please use numbers only"
		else
			return true
		end
	elseif type == "alpha" then
		if string.match(val, "(%A+)") and string.len(val) ~= 0 then
			return "Please use characters only"
		else
			return true
		end
	elseif type == "numberAnd100" then
		if string.match(val, "(%D+)") and string.len(val) ~= 0 then
			return "Please use numbers only"
		else
			if GearHelper.db.profile.CW[info[1]].DisplayAsPercentage then
				local sum = 0
				for _, v in pairs(GearHelper.db.profile.CW[info[1]]) do
					if tonumber(v) then
						sum = sum + (v / 50) * 100
					end
				end
				if sum > 99 then --Value is stored and if validation failed it's removed so it's taken into account
					return "Percentage sum is more than 100"
				else
					return true
				end
			else
				return true
			end
		end
	end
end

--[[
Function :
Scope : local
Description : Template of setting for the addon main GUI
Input :
Output :
Author : Raphaël Saget
]]
local ghOptionsTable = {
	name = "GearHelper",
	type = "group",
	childGroups = "select",
	args = {
		group1 = {
			order = 0,
			name = " ",
			type = "group",
			inline = true,
			args = {
				enable = {
					order = 0,
					name = L["enable"] .. " GearHelper",
					desc = L["UIGHCheckBoxAddon"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.addonEnabled = val
						if val == false then
							PlaySoundFile("sound\\Creature\\Malfurion_Stormrage\\VO_703_Malfurion_Stormrage_37.ogg", "MASTER")
						end
						---------- A ETUDIER --------
						local icon = LibStub("LibDBIcon-1.0")
						local ghIcon = icon:GetMinimapButton("GHIcon")
						ghIcon.icon = GearHelper.db.profile.addonEnabled and "Interface\\AddOns\\GearHelper\\Textures\\flecheUp" or "Interface\\AddOns\\GearHelper\\Textures\\flecheUpR"
						icon:Refresh("GHIcon")
						-----------------------------
					end,
					get = function()
						return GearHelper.db.profile.addonEnabled
					end
				},
				debug = {
					order = 1,
					name = "Debug",
					hidden = function()
						if UnitName("player") ~= "Marsgames" and UnitName("player") ~= "Tempaxe" then
							return true
						end
					end,
					desc = L["UIGHCheckBoxAddon"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.debug = val
					end,
					get = function()
						return GearHelper.db.profile.debug
					end
				},
				minimapButton = {
					order = 2,
					name = L["UIMinimapIcon"],
					--hidden = function() if UnitName("player") ~= "Marsgames" and UnitName("player") ~= "Tempaxe" then return true end end,
					desc = L["UIMinimapIconDesc"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.minimap = {hide = not val}
						local icon = LibStub("LibDBIcon-1.0")
						if (val) then
							icon:Show("GHIcon")
						else
							icon:Hide("GHIcon")
						end
					end,
					get = function()
						return not GearHelper.db.profile.minimap.hide
					end
				}
			}
		},
		spacer1 = {
			order = 1,
			name = L["gearOptions"],
			type = "header"
		},
		group2 = {
			order = 2,
			name = " ",
			type = "group",
			inline = true,
			args = {
				autoGreed = {
					order = 2,
					name = L["autoGreed"],
					desc = L["UIGHCheckBoxAutoGreed"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.autoGreed = val
					end,
					get = function()
						return GearHelper.db.profile.autoGreed
					end
				},
				autoNeed = {
					order = 3,
					name = L["autoNeed"],
					desc = L["UIGHCheckBoxAutoNeed"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.autoNeed = val
					end,
					get = function()
						return GearHelper.db.profile.autoNeed
					end
				},
				autoEquipLootedStuff = {
					order = 4,
					name = L["autoEquipLootedStuff"],
					desc = L["UIGHCheckBoxAutoEquipLootedStuff"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.autoEquipLooted.actual = val
						GearHelper.db.profile.autoEquipLooted.previous = val
					end,
					get = function()
						return GearHelper.db.profile.autoEquipLooted.actual
					end
				},
				printWhenEquip = {
					order = 5,
					name = L["UIprintWhenEquip"],
					disabled = function()
						if GearHelper.db.profile.autoEquipWhenSwitchSpe == false and GearHelper.db.profile.autoEquipLooted.actual == false then
							return true
						end
					end,
					desc = "Enables / disables print when equip",
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.printWhenEquip = val
					end,
					get = function()
						return GearHelper.db.profile.printWhenEquip
					end
				},
				askLootRaid = {
					order = 6,
					name = L["lootInRaidAlert"],
					desc = L["UIGHCheckBoxlootInRaidAlert"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.askLootRaid = val
					end,
					get = function()
						return GearHelper.db.profile.askLootRaid
					end,
					width = "double"
				},
				autoEquipWhenSwitchSpe = {
					order = 7,
					name = L["autoEquipSpecChangedStuff"],
					desc = L["UIGHCheckBoxAutoEquipWhenSwitchSpe"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.autoEquipWhenSwitchSpe = val
					end,
					get = function()
						return GearHelper.db.profile.autoEquipWhenSwitchSpe
					end,
					width = "double"
				},
				computeNotEquippable = {
					order = 8,
					name = L["UIGlobalComputeNotEquippable"],
					desc = L["UIGlobalComputeNotEquippableDescription"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.computeNotEquippable = val
					end,
					get = function()
						return GearHelper.db.profile.computeNotEquippable
					end,
					width = "double"
				}
			}
		}
	}
}

local ghSecondaryOptionsTable = {
	name = "Options secondaires",
	type = "group",
	childGroups = "select",
	args = {
		group3 = {
			order = 4,
			name = " ",
			type = "group",
			inline = true,
			args = {
				autoSell = {
					order = 0,
					name = L["sellGrey"],
					desc = L["UIGHCheckBoxSellGrey"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.sellGreyItems = val
					end,
					get = function()
						return GearHelper.db.profile.sellGreyItems
					end
				},
				autoAcceptQuestReward = {
					order = 1,
					name = L["questRewars"],
					desc = L["UIGHCheckBoxAutoAcceptQuestReward"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.autoAcceptQuestReward = val
					end,
					get = function()
						return GearHelper.db.profile.autoAcceptQuestReward
					end,
					width = "double"
				},
				autoRepair = {
					order = 2,
					name = L["auto-repair"],
					desc = L["auto-repairDesc"],
					type = "select",
					values = {
						[0] = L["DNR"],
						[1] = L["AutoRepair"],
						[2] = L["GuildAutoRepair"]
					},
					set = function(info, val)
						GearHelper.db.profile.autoRepair = val
					end,
					get = function(info)
						return GearHelper.db.profile.autoRepair
					end,
					style = "dropdown",
					width = "double"
				},
				autoTell = {
					order = 3,
					name = "Loot Announcement",
					desc = L["checkGHAutoTell"],
					hidden = true,
					type = "toggle",
					width = "full",
					set = function(_, val)
						GearHelper.db.profile.autoTell = val
					end,
					get = function()
						return GearHelper.db.profile.autoTell
					end
				},
				autoInvite = {
					order = 4,
					name = L["UIautoInvite"],
					desc = function()
						return L["UIGHCheckBoxAutoInvite"] .. GearHelper:ColorizeString(GetInvMsg(), "Vert")
					end,
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.autoInvite = val
					end,
					get = function()
						return GearHelper.db.profile.autoInvite
					end
				},
				inviteMessage = {
					order = 5,
					name = L["UIinviteMessage"],
					desc = L["UIinviteMessageDesc"],
					type = "input",
					set = function(_, val)
						GearHelper:setInviteMessage(val)
					end,
					get = function()
						return GearHelper.db.profile.inviteMessage
					end
				},
				whisperAlert = {
					order = 6,
					name = L["UIWhisperAlert"],
					desc = L["UIWhisperAlertDesc"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.whisperAlert = val
					end,
					get = function()
						return GearHelper.db.profile.whisperAlert
					end
				},
				sayMyName = {
					order = 7,
					name = L["UISayMyName"],
					desc = L["UISayMyNameDesc"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.sayMyName = val
					end,
					get = function()
						return GearHelper.db.profile.sayMyName
					end
				},
				myNames = {
					order = 8,
					name = L["UIMyNames"],
					desc = L["UIMyNamesDesc"],
					type = "input",
					width = "full",
					set = function(_, val)
						GearHelper:setMyNames(val)
					end,
					get = function()
						return GearHelper.db.global.myNames
					end
				},
				bossesKilled = {
					order = 9,
					name = L["UIBossesKilled"],
					desc = L["UIBossesKilledDesc"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.bossesKilled = val
						if val == false then
							GearHelper:HideLfrButtons()
						elseif (RaidFinderQueueFrame) then
							GearHelper:CreateLfrButtons(RaidFinderQueueFrame)
							GearHelper:UpdateButtonsAndTooltips(RaidFinderQueueFrame)
							GearHelper:UpdateGHLfrButton()
							GearHelper:UpdateSelecCursor()
							GearHelper:RegisterEvent("LFG_UPDATE")
							GearHelper.LFG_UPDATE = GearHelper.UpdateGHLfrButton
						end
					end,
					get = function()
						return GearHelper.db.profile.bossesKilled
					end
				},
				ilvlCharFrame = {
					order = 10,
					name = L["UIIlvlCharFrame"],
					desc = L["UIIlvlCharFrameDesc"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.ilvlCharFrame = val
						if (val) then
							GearHelper:AddIlvlOnCharFrame(true)
						else
							GearHelper:HideIlvlOnCharFrame()
						end
					end,
					get = function()
						return GearHelper.db.profile.ilvlCharFrame
					end
				},
				ilvlInspectFrame = {
					order = 11,
					name = L["UIIlvlInspectFrame"],
					desc = L["UIIlvlInspectFrameDesc"],
					type = "toggle",
					set = function(_, val)
						GearHelper.db.profile.ilvlInspectFrame = val
						if (val) then
							if (InspectPaperDollItemsFrame and UnitGUID("target")) then
								GearHelper:AddIlvlOnInspectFrame(UnitGUID("target"), true)
							end
						else
							GearHelper:HideIlvlOnInspectFrame()
						end
					end,
					get = function()
						return GearHelper.db.profile.ilvlInspectFrame
					end
				}
			}
		}
	}
}

--[[
Function : DeleteTemplate
Scope : local
Description : Delete a template from database and from GUI
Input : info = the name of the template
Output :
Author : Raphaël Saget
]]
local function DeleteTemplate(info)
	local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(L["customWeights"], "dialog", "GearHelper-1.0")

	configTable.args.TemplateSelection.values[info[1]] = nil
	configTable.args.TemplateSelection.values = configTable.args.TemplateSelection.values
	configTable.args[info[1]] = nil
	GearHelper.db.profile.CW[info[1]] = nil

	LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], configTable)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(L["customWeights"])
end

--[[
Function : CreateNewTemplate
Scope : local
Description : Called when user add a new template of stat, it create a new stat template in DB and add new GUI elements for the new template
Input : templateName = the name of the template
Output :
Author : Raphaël Saget
]]
local function CreateNewTemplate(templateName)
	for _, v in pairs(GearHelper.db.profile.CW) do
		if (v.Name == templateName) then
			return
		end
	end
	local tmpTemplate = {
		["Intellect"] = 0,
		["Haste"] = 0,
		["CriticalStrike"] = 0,
		["Versatility"] = 0,
		["Mastery"] = 0,
		["Agility"] = 0,
		["Stamina"] = 0,
		["Strength"] = 0,
		["Armor"] = 0,
		["Leech"] = 0,
		["Avoidance"] = 0,
		["MainHandDps"] = 0,
		["MovementSpeed"] = 0,
		["OffHandDps"] = 0,
		["Max"] = 0,
		["Name"] = templateName,
		["DisplayAsPercentage"] = false
	}
	GearHelper.db.profile.CW[templateName] = tmpTemplate
	local newGroup = {
		name = templateName,
		type = "group",
		hidden = function()
			if GearHelper.db.profile.weightTemplate == "NOX" then
				return true
			end
		end,
		args = {
			asPercentage = {
				order = 0,
				name = L["UICWasPercentage"],
				desc = L["UICWasPercentageDescription"],
				type = "toggle",
				width = "double",
				set = function(_, val)
					for k, v in pairs(GearHelper.db.profile.CW[templateName]) do
						if tonumber(v) then
							GearHelper.db.profile.CW[templateName][k] = 0
						end
					end
					GearHelper.db.profile.CW[templateName].DisplayAsPercentage = val
				end,
				get = function()
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return GearHelper.db.profile.CW[templateName].DisplayAsPercentage
					else
						GearHelper.db.profile.CW[templateName].DisplayAsPercentage = false
						return GearHelper.db.profile.CW[templateName].DisplayAsPercentage
					end
				end
			},
			Intell = {
				order = 1,
				name = L["Tooltip"]["Stat"]["Intellect"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Intellect")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Intellect")
				end
			},
			Strength = {
				order = 2,
				name = L["Tooltip"]["Stat"]["Strength"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Strength")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Strength")
				end
			},
			Agility = {
				order = 3,
				name = L["Tooltip"]["Stat"]["Agility"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Agility")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Agility")
				end
			},
			Stamina = {
				order = 4,
				name = L["Tooltip"]["Stat"]["Stamina"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Stamina")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Stamina")
				end
			},
			Haste = {
				order = 5,
				name = L["Tooltip"]["Stat"]["Haste"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Haste")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Haster")
				end
			},
			Mastery = {
				order = 6,
				name = L["Tooltip"]["Stat"]["Mastery"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Mastery")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Mastery")
				end
			},
			Critic = {
				order = 7,
				name = L["Tooltip"]["Stat"]["CriticalStrike"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "CriticalStrike")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "CriticalStrike")
				end
			},
			Armor = {
				order = 8,
				name = L["Tooltip"]["Stat"]["Armor"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Armor")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Armor")
				end
			},
			Versatility = {
				order = 9,
				name = L["Tooltip"]["Stat"]["Versatility"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Versatility")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Versatility")
				end
			},
			Leech = {
				order = 10,
				name = L["Tooltip"]["Stat"]["Leech"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Leech")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Leech")
				end
			},
			Avoidance = {
				order = 11,
				name = L["Tooltip"]["Stat"]["Avoidance"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "Avoidance")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "Avoidance")
				end
			},
			MovementSpeed = {
				order = 14,
				name = L["Tooltip"]["Stat"]["MovementSpeed"],
				validate = function(info, val)
					if GearHelper.db.profile.CW[templateName].DisplayAsPercentage then
						return ValidateInputPattern(val, "numberAnd100", info)
					else
						return ValidateInputPattern(val, "number")
					end
				end,
				type = "input",
				get = function(info)
					return GetStatCW(info, "MovementSpeed")
				end,
				set = function(info, val)
					return SetStatCW(info, val, "MovementSpeed")
				end
			},
			ButtonDelete = {
				order = 15,
				name = L["remove"],
				func = function(info)
					DeleteTemplate(info)
				end,
				type = "execute"
			}
		}
	}
	local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable(L["customWeights"], "dialog", "GearHelper-1.0")
	configTable.args[templateName] = newGroup
	configTable.args.TemplateSelection.values[templateName] = templateName
	LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], configTable)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(L["customWeights"])
end

--[[
Function :
Scope : local
Description : Template of setting for the addon custom weight GUI
Input :
Output :
Author : Raphaël Saget
]]
GearHelper.cwTable = {
	name = L["customWeights"],
	type = "group",
	childGroups = "tree",
	args = {
		Select = {
			order = 0,
			name = L["UIstatsTemplateToUse"],
			type = "select",
			style = "radio",
			values = {
				[0] = L["noxxicWeights"],
				[1] = L["customWeights"]
			},
			get = function()
				if GearHelper.db.profile.weightTemplate == "NOX" then
					return 0
				else
					return 1
				end
			end,
			set = function(_, val)
				if val == 1 then
					if #GearHelper.db.profile.CW == 0 or not GearHelper.db.profile.lastWeightTemplate then --To avoid error if we select custome weight and we do not create a template
						GearHelper.db.profile.weightTemplate = "NOX_ByDefault"
					else
						GearHelper.db.profile.weightTemplate = GearHelper.db.profile.lastWeightTemplate
						LibStub("AceConfigDialog-3.0"):SelectGroup(L["customWeights"], GearHelper.db.profile.weightTemplate)
					end
				elseif val == 0 then
					GearHelper.db.profile.lastWeightTemplate = GearHelper.db.profile.weightTemplate
					GearHelper.db.profile.weightTemplate = "NOX"
				end
			end
		},
		group1 = {
			order = 2,
			name = "Options de calcul",
			type = "group",
			inline = true,
			args = {
				GemSocketCompute = {
					order = 1,
					name = L["UIcwGemSocketCompute"],
					type = "toggle",
					width = "double",
					--width = "double",
					get = function()
						return GearHelper.db.profile.includeSocketInCompute
					end,
					set = function(_, val)
						GearHelper.db.profile.includeSocketInCompute = val
					end
				},
				IlvlOption = {
					order = 2,
					name = L["UIcwIlvlOption"],
					type = "toggle",
					get = function()
						return GearHelper.db.profile.iLvlOption
					end,
					set = function(_, val)
						GearHelper.db.profile.iLvlOption = val
					end
				},
				IlvlWeight = {
					order = 3,
					name = L["UIcwIlvlWeight"],
					width = "half",
					type = "input",
					disabled = function()
						return not GearHelper.db.profile.iLvlOption
					end,
					validate = function(_, val)
						return ValidateInputPattern(val, "number")
					end,
					get = function()
						return GearHelper.db.profile.iLvlWeight
					end,
					set = function(_, val)
						GearHelper.db.profile.iLvlWeight = val
					end
				}
			}
		},
		templateName = {
			order = 4,
			name = L["UItemplateName"],
			type = "input",
			width = "double",
			validate = function(_, val)
				return ValidateInputPattern(val, "alpha")
			end,
			get = function()
			end,
			set = function(_, val)
				CreateNewTemplate(val)
				LibStub("AceConfigDialog-3.0"):SelectGroup(L["customWeights"], val)
			end
		},
		TemplateSelection = {
			order = 3,
			name = L["UIcwTemplateToUse"],
			type = "select",
			style = "dropdown",
			disabled = function()
				if GearHelper.db.profile.weightTemplate == "NOX" then
					return true
				end
			end,
			get = function()
				return GearHelper.db.profile.weightTemplate
			end,
			set = function(_, val)
				GearHelper.db.profile.weightTemplate = val
				LibStub("AceConfigDialog-3.0"):SelectGroup(L["customWeights"], val)
			end,
			values = {}
		},
		NoxGroup = {
			name = "Noxxic",
			type = "group",
			args = {
				Intell = {
					order = 1,
					name = L["Tooltip"]["Stat"]["Intellect"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Intellect", 1)
					end,
					hidden = function()
						if GetStatCW("", "Intellect", 1) == 0 then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Strength = {
					order = 2,
					name = L["Tooltip"]["Stat"]["Strength"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Strength", 1)
					end,
					disabled = function()
						return true
					end,
					hidden = function(info)
						if GetStatCW(info, "Agility", 1) == "0" then
							return true
						end
					end
				},
				Agility = {
					order = 3,
					name = L["Tooltip"]["Stat"]["Agility"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Agility", 1)
					end,
					disabled = function()
						return true
					end,
					hidden = function()
						if GetStatCW("", "Agility", 1) == "0" then
							return true
						end
					end
				},
				Stamina = {
					order = 4,
					name = L["Tooltip"]["Stat"]["Stamina"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Stamina", 1)
					end,
					hidden = function()
						if GetStatCW("", "Stamina", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Haste = {
					order = 5,
					name = L["Tooltip"]["Stat"]["Haste"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Haste", 1)
					end,
					hidden = function()
						if GetStatCW("", "Haste", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Mastery = {
					order = 6,
					name = L["Tooltip"]["Stat"]["Mastery"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Mastery", 1)
					end,
					hidden = function()
						if GetStatCW("", "Mastery", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Critic = {
					order = 7,
					name = L["Tooltip"]["Stat"]["CriticalStrike"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "CriticalStrike", 1)
					end,
					hidden = function()
						if GetStatCW("", "CriticalStrike", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Armor = {
					order = 8,
					name = L["Tooltip"]["Stat"]["Armor"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Armor", 1)
					end,
					hidden = function()
						if GetStatCW("", "Armor", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Versatility = {
					order = 9,
					name = L["Tooltip"]["Stat"]["Versatility"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Versatility", 1)
					end,
					hidden = function()
						if GetStatCW("", "Versatility", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Leech = {
					order = 10,
					name = L["Tooltip"]["Stat"]["Leech"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Leech", 1)
					end,
					hidden = function()
						if GetStatCW("", "Leech", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				Avoidance = {
					order = 11,
					name = L["Tooltip"]["Stat"]["Avoidance"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "Avoidance", 1)
					end,
					hidden = function()
						if GetStatCW("", "Avoidance", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				},
				MovementSpeed = {
					order = 14,
					name = L["Tooltip"]["Stat"]["MovementSpeed"],
					type = "input",
					get = function(info)
						return GetStatCW(info, "MovementSpeed", 1)
					end,
					hidden = function()
						if GetStatCW("", "MovementSpeed", 1) == "0" then
							return true
						end
					end,
					disabled = function()
						return true
					end
				}
			}
		}
	}
}

--[[
Function : BuildCWTable
Scope : GearHelper
Description : Dynamically build custom weight GUI based on registered template in DB
Input :
Output :
Author : Raphaël Saget
]]
function GearHelper:BuildCWTable()
	for _, v in pairs(self.db.profile.CW) do
		if (v.Name ~= nil) then
			local newGroup = {
				name = "GHDefaultName",
				type = "group",
				disabled = function()
					if GearHelper.db.profile.weightTemplate == "NOX" then
						return true
					end
				end,
				args = {
					asPercentage = {
						order = 0,
						name = L["UICWasPercentage"],
						desc = L["UICWasPercentageDescription"],
						type = "toggle",
						width = "double",
						set = function(_, val)
							for x, y in pairs(v) do
								if tonumber(y) then
									v[x] = 0
								end
							end
							v.DisplayAsPercentage = val
						end,
						get = function()
							if v.DisplayAsPercentage then
								return v.DisplayAsPercentage
							else
								v.DisplayAsPercentage = false
								return v.DisplayAsPercentage
							end
						end
					},
					Intell = {
						order = 1,
						name = L["Tooltip"]["Stat"]["Intellect"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Intellect")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Intellect")
						end
					},
					Strength = {
						order = 2,
						name = L["Tooltip"]["Stat"]["Strength"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Strength")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Strength")
						end
					},
					Agility = {
						order = 3,
						name = L["Tooltip"]["Stat"]["Agility"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Agility")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Agility")
						end
					},
					Stamina = {
						order = 4,
						name = L["Tooltip"]["Stat"]["Stamina"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Stamina")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Stamina")
						end
					},
					Haste = {
						order = 5,
						name = L["Tooltip"]["Stat"]["Haste"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Haste")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Haste")
						end
					},
					Mastery = {
						order = 6,
						name = L["Tooltip"]["Stat"]["Mastery"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Mastery")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Mastery")
						end
					},
					Critic = {
						order = 7,
						name = L["Tooltip"]["Stat"]["CriticalStrike"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "CriticalStrike")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "CriticalStrike")
						end
					},
					Armor = {
						order = 8,
						name = L["Tooltip"]["Stat"]["Armor"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Armor")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Armor")
						end
					},
					Versatility = {
						order = 9,
						name = L["Tooltip"]["Stat"]["Versatility"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Versatility")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Versatility")
						end
					},
					Leech = {
						order = 10,
						name = L["Tooltip"]["Stat"]["Leech"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Leech")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Leech")
						end
					},
					Avoidance = {
						order = 11,
						name = L["Tooltip"]["Stat"]["Avoidance"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "Avoidance")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "Avoidance")
						end
					},
					MovementSpeed = {
						order = 14,
						name = L["Tooltip"]["Stat"]["MovementSpeed"],
						validate = function(info, val)
							if v.DisplayAsPercentage then
								return ValidateInputPattern(val, "numberAnd100", info)
							else
								return ValidateInputPattern(val, "number")
							end
						end,
						type = "input",
						get = function(info)
							return GetStatCW(info, "MovementSpeed")
						end,
						set = function(info, val)
							return SetStatCW(info, val, "MovementSpeed")
						end
					},
					ButtonDelete = {
						order = 15,
						name = L["remove"],
						func = function(info)
							DeleteTemplate(info)
						end,
						type = "execute"
					}
				}
			}
			newGroup.name = v.Name
			GearHelper.cwTable.args[v.Name] = newGroup
			GearHelper.cwTable.args.TemplateSelection.values[v.Name] = v.Name
		end
	end
	LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], GearHelper.cwTable)
	LibStub("AceConfigRegistry-3.0"):NotifyChange(L["customWeights"])
end

--[[
Function :
Scope : local
Description : Template setting for the addon about GUI
Input :
Output :
Author : Raphaël Saget
]]
local aboutTable = {
	name = "About",
	type = "group",
	args = {
		version = {
			order = 0,
			fontSize = "medium",
			name = "\n\n\n\n\n                |cFFFFFF00Version :|r " .. version --[[4124.27.0.2.0.31]] .. "\n",
			type = "description"
		},
		author = {
			order = 1,
			fontSize = "medium",
			name = "                |cFFFFFF00Author :|r Marsgames - Temple Noir\n                               Tempaxe - Temple Noir" --[[Ta mère]] .. " \n",
			type = "description"
		},
		email = {
			order = 2,
			fontSize = "medium",
			name = "                |cFFFFFF00E-Mail :|r marsgames@gmail.com" --[[fdp@fdp.land]] .. " \n",
			type = "description"
		},
		bug = {
			order = 3,
			fontSize = "medium",
			name = "                |cFFFFFF00BugReport :|r http://vu.fr/GearHelperbugs  \n",
			type = "description"
		},
		credits = {
			order = 4,
			fontSize = "medium",
			name = "                |cFFFFFF00Credits :|r Big up\n",
			type = "description"
		},
		bug2 = {
			name = "                   |cFFFFFF00BugReport : ",
			desc = "Click then ctrl + A to select and ctrl + C to copy",
			type = "input",
			get = function()
				return "|cFF4477c9https://wow.curseforge.com/projects/gearhelper/issues"
			end,
			width = "double"
		}
	}
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("GearHelper", ghOptionsTable, "ghOption")
LibStub("AceConfig-3.0"):RegisterOptionsTable("Options secondaires", ghSecondaryOptionsTable)
LibStub("AceConfig-3.0"):RegisterOptionsTable(L["customWeights"], GearHelper.cwTable)
-- LibStub("AceConfig-3.0"):RegisterOptionsTable("About", aboutTable)
GearHelper.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GearHelper")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Options secondaires", "Options secondaires", "GearHelper")
GearHelper.cwFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L["customWeights"], L["customWeights"], "GearHelper")
LibStub("LibAboutPanel").new("GearHelper", "GearHelper")
-- LibStub("AceConfigDialog-3.0"):AddToBlizOptions("About", "About", "GearHelper")
