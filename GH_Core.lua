GearHelper = LibStub("AceAddon-3.0"):NewAddon("GearHelper", "AceConsole-3.0", "AceEvent-3.0")
GearHelper.locals = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

GHToolbox = _G["GHToolbox"]

local function ResetProfileOnMajorUpdate()
    local dbMajorAddonVersion = tonumber(string.match(GearHelper.db.global.addonVersion or "0", "%d+"))
    local currentAddonVersion = tonumber(string.match(GearHelperVars.version, "%d+"))
    if not (dbMajorAddonVersion == currentAddonVersion) then
        GearHelper:Print("Major update detected, resetting whole database...")
        GearHelper.db:ResetDB()
        print("Major update detected database has been reset. Please verify your settings.")
        Settings.OpenToCategory("GearHelper")
    end
end

function GearHelper:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GearHelperDB", GearHelper.defaultSettings)

    ResetProfileOnMajorUpdate()

    if (type(GearHelper.db.profile.debug) == "boolean") then
        GearHelper:SlashResetDebug()
    end

    -- TODO: Remove this when autoEquip will be fixed
    GearHelper.db.profile.autoEquipLooted.actual = false

    self.db.global.addonVersion = GearHelperVars.version
    self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

    GearHelper:LoadBaseStatTemplates()
    securecall(GHOptions.GenerateOptions)
end

function GearHelper:OnEnable()
    print(GHToolbox:ColorizeString(self.locals["Addon"], "LightGreen") .. GHToolbox:ColorizeString(self.locals["ActivatedGreen"], "LightGreen"))
    print(GHToolbox:ColorizeString(self.locals["merci"], "LightGreen"))
    GHEvents:RegisterEvents()
    self:HookItemTooltip()
    self:HookMoneyTooltip()
    --self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end

function GearHelper:OnDisable()
    print(GHToolbox:ColorizeString(self.locals["Addon"], "LightGreen") .. GHToolbox:ColorizeString(self.locals["DeactivatedRed"], "LightRed"))
    GHEvents:UnregisterEvents()
    --self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end

function GHEvents:ADDON_ACTION_BLOCKED(addonName, addonFunc)
    if (addonName == "GearHelper") then
        GearHelper:Print("----- ADDON_ACTION_BLOCKED -----")
        GearHelper:Print(addonFunc .. " function is blocked by Blizzard")
        GearHelper:Print(debugstack())
    end
end

function GHEvents:ADDON_ACTION_FORBIDDEN(addonName, addonFunc)
    if (addonName == "GearHelper") then
        GearHelper:Print("----- ADDON_ACTION_FORBIDDEN -----")
        GearHelper:Print(addonFunc .. " function is forbidden by Blizzard")
        GearHelper:Print(debugstack())
    end
end

function GHEvents:RegisterEvents()
    GearHelper:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", self.ACTIVE_TALENT_GROUP_CHANGED)
    GearHelper:RegisterEvent("BAG_UPDATE", self.BAG_UPDATE)
    GearHelper:RegisterEvent("BAG_UPDATE_DELAYED", self.BAG_UPDATE_DELAYED)
    GearHelper:RegisterEvent("CHAT_MSG_ADDON", self.CHAT_MSG_ADDON)
    GearHelper:RegisterEvent("CHAT_MSG_CHANNEL", self.CHAT_MSG_CHANNEL)
    GearHelper:RegisterEvent("CHAT_MSG_EMOTE", self.CHAT_MSG_EMOTE)
    GearHelper:RegisterEvent("CHAT_MSG_GUILD", self.CHAT_MSG_GUILD)
    GearHelper:RegisterEvent("CHAT_MSG_LOOT", self.CHAT_MSG_LOOT)
    GearHelper:RegisterEvent("CHAT_MSG_OFFICER", self.CHAT_MSG_OFFICER)
    GearHelper:RegisterEvent("CHAT_MSG_PARTY", self.CHAT_MSG_PARTY)
    GearHelper:RegisterEvent("CHAT_MSG_PARTY_LEADER", self.CHAT_MSG_PARTY_LEADER)
    GearHelper:RegisterEvent("CHAT_MSG_RAID", self.CHAT_MSG_RAID)
    GearHelper:RegisterEvent("CHAT_MSG_RAID_LEADER", self.CHAT_MSG_RAID_LEADER)
    GearHelper:RegisterEvent("CHAT_MSG_RAID_WARNING", self.CHAT_MSG_RAID_WARNING)
    GearHelper:RegisterEvent("CHAT_MSG_SAY", self.CHAT_MSG_SAY)
    GearHelper:RegisterEvent("CHAT_MSG_WHISPER", self.CHAT_MSG_WHISPER)
    GearHelper:RegisterEvent("CHAT_MSG_YELL", self.CHAT_MSG_YELL)
    GearHelper:RegisterEvent("INSPECT_READY", self.INSPECT_READY)
    GearHelper:RegisterEvent("LFG_UPDATE", self.LFG_UPDATE)
    GearHelper:RegisterEvent("MERCHANT_CLOSED", self.MERCHANT_CLOSED)
    GearHelper:RegisterEvent("MERCHANT_SHOW", self.MERCHANT_SHOW)
    GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD)
    GearHelper:RegisterEvent("PLAYER_LOGIN", self.PLAYER_LOGIN)
    GearHelper:RegisterEvent("QUEST_COMPLETE", self.QUEST_COMPLETE)
    GearHelper:RegisterEvent("QUEST_DETAIL", self.QUEST_DETAIL)
    GearHelper:RegisterEvent("QUEST_TURNED_IN", self.QUEST_TURNED_IN)
    GearHelper:RegisterEvent("READY_CHECK", self.READY_CHECK)
    GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)

    GearHelper:RegisterEvent("ADDON_ACTION_BLOCKED", self.ADDON_ACTION_BLOCKED)
    GearHelper:RegisterEvent("ADDON_ACTION_FORBIDDEN", self.ADDON_ACTION_FORBIDDEN)
end

function GHEvents:UnregisterEvents()
    GearHelper:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED", self.ACTIVE_TALENT_GROUP_CHANGED)
    GearHelper:UnregisterEvent("BAG_UPDATE", self.BAG_UPDATE)
    GearHelper:UnregisterEvent("BAG_UPDATE_DELAYED", self.BAG_UPDATE_DELAYED)
    GearHelper:UnregisterEvent("CHAT_MSG_ADDON", self.CHAT_MSG_ADDON)
    GearHelper:UnregisterEvent("CHAT_MSG_CHANNEL", self.CHAT_MSG_CHANNEL)
    GearHelper:UnregisterEvent("CHAT_MSG_EMOTE", self.CHAT_MSG_EMOTE)
    GearHelper:UnregisterEvent("CHAT_MSG_GUILD", self.CHAT_MSG_GUILD)
    GearHelper:UnregisterEvent("CHAT_MSG_LOOT", self.CHAT_MSG_LOOT)
    GearHelper:UnregisterEvent("CHAT_MSG_OFFICER", self.CHAT_MSG_OFFICER)
    GearHelper:UnregisterEvent("CHAT_MSG_PARTY", self.CHAT_MSG_PARTY)
    GearHelper:UnregisterEvent("CHAT_MSG_PARTY_LEADER", self.CHAT_MSG_PARTY_LEADER)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID", self.CHAT_MSG_RAID)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID_LEADER", self.CHAT_MSG_RAID_LEADER)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID_WARNING", self.CHAT_MSG_RAID_WARNING)
    GearHelper:UnregisterEvent("CHAT_MSG_SAY", self.CHAT_MSG_SAY)
    GearHelper:UnregisterEvent("CHAT_MSG_WHISPER", self.CHAT_MSG_WHISPER)
    GearHelper:UnregisterEvent("CHAT_MSG_YELL", self.CHAT_MSG_YELL)
    GearHelper:UnregisterEvent("INSPECT_READY", self.INSPECT_READY)
    GearHelper:UnregisterEvent("LFG_UPDATE", self.LFG_UPDATE)
    GearHelper:UnregisterEvent("MERCHANT_CLOSED", self.MERCHANT_CLOSED)
    GearHelper:UnregisterEvent("MERCHANT_SHOW", self.ON_MERCHANT_SHOW)
    GearHelper:UnregisterEvent("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD)
    GearHelper:UnregisterEvent("PLAYER_LOGIN", self.PLAYER_LOGIN)
    GearHelper:UnregisterEvent("QUEST_COMPLETE", self.QUEST_COMPLETE)
    GearHelper:UnregisterEvent("QUEST_DETAIL", self.QUEST_DETAIL)
    GearHelper:UnregisterEvent("QUEST_TURNED_IN", self.QUEST_TURNED_IN)
    GearHelper:UnregisterEvent("READY_CHECK", self.READY_CHECK)
    GearHelper:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
end
