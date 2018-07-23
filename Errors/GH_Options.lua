local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function GetInvMsg(info, val)
    return GearHelper.db.profile.inviteMessage
end

local ghOptionsTable = {
    name = "GearHelper",
    type = "group",
    childGroups  = "select",
    args = {
        group1 = {
            order = 0,
            name = " ",
            type = "group",
            inline = true,
            args = {
                enable = {
                    order = 0,
                    name = "Enable GearHelper",
                    desc = L["UIGHCheckBoxAddon"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.addonEnabled = val; if val == false then PlaySoundFile("sound\\Creature\\Malfurion_Stormrage\\VO_703_Malfurion_Stormrage_37.ogg", "MASTER") end end,
                    get = function(info) return GearHelper.db.profile.addonEnabled end
                },
                debug = {
                    order = 1,
                    name = "Debug",
                    desc = L["UIGHCheckBoxAddon"],
                    type = "toggle",
                    set = function(info,val) end,
                    get = function(info) end
                }
            }
        },
        spacer1  = {
            order = 1,
            name = "Gear Options",
            type = "header",
        },
        group2 = {
            order = 2,
            name = " ",
            type = "group",
            inline = true,
            args = {
                autoGreed = {
                    order = 2,
                    name = "Greed",
                    desc = L["UIGHCheckBoxAutoGreed"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.autoGreed = val end,
                    get = function(info) return GearHelper.db.profile.autoGreed end
                },
                autoNeed = {
                    order = 3,
                    name = "Need",
                    desc = L["UIGHCheckBoxAutoNeed"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.autoNeed = val end,
                    get = function(info) return GearHelper.db.profile.autoNeed end
                },
                autoEquipLootedStuff = {
                    order = 4,
                    name = "Auto equip looted stuff",
                    desc = L["UIGHCheckBoxAutoEquipLootedStuff"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.autoEquipLooted.actual = val end,
                    get = function(info) return GearHelper.db.profile.autoEquipLooted.actual end
                },
                autoEquipWhenSwitchSpe = {
                    order = 7,
                    name = "Spec Switch",
                    desc = L["UIGHCheckBoxAutoEquipWhenSwitchSpe"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.autoEquipWhenSwitchSpe = val end,
                    get = function(info) return GearHelper.db.profile.autoEquipWhenSwitchSpe end
                },
                askLootRaid = {
                    order = 6,
                    name = "Loot in raid",
                    desc = "Enables / disables ask for loot in raid",
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.askLootRaid = val end,
                    get = function(info) return GearHelper.db.profile.askLootRaid end
                },
                printWhenEquip = {
                    order = 5,
                    name = "Print When Equip",
                    desc = "Enables / disables print when equip",
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.printWhenEquip = val end,
                    get = function(info) return GearHelper.db.profile.printWhenEquip end
                }
            }
        },
        spacer2 = {
            order = 3,
            name = "Misc Options",
            type = "header",
        },
        group3 = {
            order = 4,
            name = " ",
            type = "group",
            inline = true,
            args = {
                autoSell = {
                    order = 0,
                    name = "Sell Grey Items",
                    desc = L["UIGHCheckBoxSellGrey"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.sellGreyItems = val end,
                    get = function(info) return GearHelper.db.profile.sellGreyItems end
                },
                autoAcceptQuestReward = {
                    order = 1,
                    name = "Quests Rewards",
                    desc = L["UIGHCheckBoxAutoAcceptQuestReward"],
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.autoAcceptQuestReward = val end,
                    get = function(info) return GearHelper.db.profile.autoAcceptQuestReward end
                },
                autoRepair = {
                    order = 2,
                    name = "Auto-Repair",
                    desc = "Enables / disables automatic reparation",
                    type = "select",
                    values = {
                        [0] = "Do Not Repair",
                        [1] = "Repair with own gold",
                        [2] = "Repair with guild gold",
                    },
                    set = function(info,val) GearHelper.db.profile.autoRepair = val end,
                    get = function(info) return GearHelper.db.profile.autoRepair end,
                    style = "dropdown",
                },
                autoTell = {
                    order = 3,
                    name = "Loot Announcement",
                    desc = L["checkGHAutoTell"],
                    type = "toggle",
                    width = "full",
                    set = function(info,val) GearHelper.db.profile.autoTell = val end,
                    get = function(info) return GearHelper.db.profile.autoTell end
                },
                autoInvite = {
                    order = 4,
                    name = "Invite On Whisper",
                    desc = function(info, vak) return L["UIGHCheckBoxAutoInvite"]..GetInvMsg(info, val) end,
                    type = "toggle",
                    set = function(info,val) GearHelper.db.profile.autoInvite = val end,
                    get = function(info) return GearHelper.db.profile.autoInvite end
                },
                inviteMessage = {
                    order = 5,
                    name = "Invite Message",
                    desc = "Invite message to tell you to be invited",
                    type = "input",
                    --set = function(info,val) GearHelper.db.profile.inviteMessage = val end,
                    set = function(info,val) GearHelper:setInviteMessage(val) end,
                    get = function(info) return GearHelper.db.profile.inviteMessage end
                },
            }
        },
        -- moreoptions={
        --   name = "More Options",
        --   type = "group",
        --   args={
        --     -- more options go here
        --   }
        -- }
    }
}

local function CreateNewTemplate(val)
  local actualCWConfig = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("Custom Weights", "dialog", "GearHelper-1.0")

  for k,v in pairs(GearHelper.db.profile.CW) do
    if (v.Name == val) then
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
      ["Name"] = val
  }

  GearHelper.db.profile.CW[val] = tmpTemplate

  local newGroup  = {
    name = val,
    type = "group",
    args =  {
      Intell = {
          order = 1,
          name = "Intell",
          type = "input"
      },
      Strength = {
          order = 2,
          name = "Force",
          type = "input"
      },
      Agility = {
          order = 3,
          name = "Agi",
          type = "input"
      },
      Stamina = {
          order = 4,
          name = "Endu",
          type = "input"
      },
      Haste = {
          order = 5,
          name = "Hate",
          type = "input"
      },
      Mastery = {
          order = 6,
          name = "Maitrise",
          type = "input"
      },
      Critic = {
          order = 7,
          name = "Crit",
          type = "input"
      },
      Armor = {
          order = 8,
          name = "Armure",
          type = "input"
      },
      Versatility = {
          order = 9,
          name = "Polyvalence",
          type = "input"
      },
      Leech = {
          order = 10,
          name = "Ponction",
          type = "input"
      },
      Avoidance= {
          order = 11,
          name = "Evitement",
          type = "input"
      },
      MainHandDamage= {
          order = 12,
          name = "Dégats main droite",
          type = "input"
      },
      OffHandDamage = {
          order = 13,
          name = "Dégats main gauche",
          type = "input"
      },
      MovementSpeed= {
          order = 14,
          name = "Vitesse",
          type = "input"
      },
    }
  }

  local configTable = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("Custom Weights", "dialog", "GearHelper-1.0")

  configTable.args[val] = newGroup
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Custom Weights", configTable)
  LibStub("AceConfigRegistry-3.0"):NotifyChange("Custom Weights")
end

local function GetSelectCW(info, val)
    if GearHelper.db.profile.weightTemplate == "NOX" then
        return 1
    elseif GearHelper.db.profile.weightTemplate == "CW" then
        return 0
    end
end

local function SetSelectCW(info, val)
    local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))

    if val == 0 then
        GearHelper.db.profile.weightTemplate = "CW"
        if not GearHelper.db.profile.CW[currentSpec] then
            GearHelper.db.profile.CW[currentSpec] = GearHelper.db.global.templates[currentSpec]["NOX"]
            print("CW = nox")
        end
    elseif val == 1 then
        GearHelper.db.profile.weightTemplate = "NOX"
    end
end

local cwTable = {
    name = "Custom Weights",
    type = "group",
    childGroups = "tree",
    args  = {
      templateName = {
        order =  0,
        name = "Template Name",
        type = "input",
        get  =  function(info, val) end,
        set = function(info,val) CreateNewTemplate(val) end,
      },
        Select = {
            order = 100,
            name = "Stats Template",
            type = "select",
            style = "radio",
            values = {
                [0] = "Custom Weights",
                [1] = "Noxxic Weights"
            },
            get = function(info, val)
                if GearHelper.db.profile.weightTemplate == "NOX" then
                    return 1
                elseif GearHelper.db.profile.weightTemplate == "CW" then
                    return 0
                end
            end,--GetSelectCW(),
            set = function(info, val)
                local currentSpec = tostring(GetSpecializationInfo(GetSpecialization()))

                if val == 0 then
                    GearHelper.db.profile.weightTemplate = "CW"
                    if not GearHelper.db.profile.CW[currentSpec] then
                        GearHelper.db.profile.CW[currentSpec] = GearHelper.db.global.templates[currentSpec]["NOX"]
                    end
                elseif val == 1 then
                    GearHelper.db.profile.weightTemplate = "NOX"
                end
            end,--SetSelectCW(),
        },
        --[[Intell = {
            order = 1,
            name = "Intell",
            type = "input"
        },
        Strength = {
            order = 2,
            name = "Force",
            type = "input"
        },
        Agility = {
            order = 3,
            name = "Agi",
            type = "input"
        },
        Stamina = {
            order = 4,
            name = "Endu",
            type = "input"
        },
        Haste = {
            order = 5,
            name = "Hate",
            type = "input"
        },
        Mastery = {
            order = 6,
            name = "Maitrise",
            type = "input"
        },
        Critic = {
            order = 7,
            name = "Crit",
            type = "input"
        },
        Armor = {
            order = 8,
            name = "Armure",
            type = "input"
        },
        Versatility = {
            order = 9,
            name = "Polyvalence",
            type = "input"
        },
        Leech = {
            order = 10,
            name = "Ponction",
            type = "input"
        },
        Avoidance= {
            order = 11,
            name = "Evitement",
            type = "input"
        },
        MainHandDamage= {
            order = 12,
            name = "Dégats main droite",
            type = "input"
        },
        OffHandDamage = {
            order = 13,
            name = "Dégats main gauche",
            type = "input"
        },
        MovementSpeed= {
            order = 14,
            name = "Vitesse",
            type = "input"
        },]]--
    }
}

function GearHelper:buildCWTable()
  local newGroup  = {
    name = "GHDefaultName",
    type = "group",
    args =  {
      Intell = {
          order = 1,
          name = "Intell",
          type = "input"
      },
      Strength = {
          order = 2,
          name = "Force",
          type = "input"
      },
      Agility = {
          order = 3,
          name = "Agi",
          type = "input"
      },
      Stamina = {
          order = 4,
          name = "Endu",
          type = "input"
      },
      Haste = {
          order = 5,
          name = "Hate",
          type = "input"
      },
      Mastery = {
          order = 6,
          name = "Maitrise",
          type = "input"
      },
      Critic = {
          order = 7,
          name = "Crit",
          type = "input"
      },
      Armor = {
          order = 8,
          name = "Armure",
          type = "input"
      },
      Versatility = {
          order = 9,
          name = "Polyvalence",
          type = "input"
      },
      Leech = {
          order = 10,
          name = "Ponction",
          type = "input"
      },
      Avoidance= {
          order = 11,
          name = "Evitement",
          type = "input"
      },
      MainHandDamage= {
          order = 12,
          name = "Dégats main droite",
          type = "input"
      },
      OffHandDamage = {
          order = 13,
          name = "Dégats main gauche",
          type = "input"
      },
      MovementSpeed= {
          order = 14,
          name = "Vitesse",
          type = "input"
      },
    }
  }

  for k,v in pairs(self.db.profile.CW) do
      if(v.Name ~= nil) then
        newGroup.name = v.Name
        cwTable.args[v.Name] = newGroup
      end
  end

  LibStub("AceConfig-3.0"):RegisterOptionsTable("Custom Weights", cwTable)
  LibStub("AceConfigRegistry-3.0"):NotifyChange("Custom Weights")
  local a = LibStub("AceConfigRegistry-3.0"):GetOptionsTable("Custom Weights", "dialog", "zeub-1.0")


end

local aboutTable = {
    name = "About",
    type = "group",
    args  = {
        version = {
            order = 0,
            fontSize = "medium",
            name = "\n\n\n\n\n                |cFFFFFF00Version :|r "..version..--[[4124.27.0.2.0.31]]"\n",
            type = "description",
        },
        author = {
            order =  1,
            fontSize = "medium",
            name = "                |cFFFFFF00Author :|r Marsgames - Temple Noir\n                               Tempaxe - Temple Noir"..--[[Ta mère]]" \n",
            type = "description",
        },
        email = {
            order =  2,
            fontSize = "medium",
            name = "                |cFFFFFF00E-Mail :|r marsgames@gmail.com"..--[[fdp@fdp.land]]" \n",
            type = "description",
        },
        bug = {
            order =  3,
            fontSize = "medium",
            name = "                |cFFFFFF00BugReport :|r https://wow.curseforge.com/projects/gearhelper/issues \n",
            type = "description",
        },
        credits = {
            order =  4,
            fontSize = "medium",
            name = "                |cFFFFFF00Credits :|r A leurs tantes les putes\n",
            type = "description",
        },
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("GearHelper", ghOptionsTable, "ghOption")
LibStub("AceConfig-3.0"):RegisterOptionsTable("Custom Weights", cwTable)
LibStub("AceConfig-3.0"):RegisterOptionsTable("About", aboutTable)

GearHelper.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GearHelper")
GearHelper.cwFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Custom Weights", "Custom Weights", "GearHelper")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("About", "About", "GearHelper")
