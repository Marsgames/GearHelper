GearHelper = LibStub("AceAddon-3.0"):NewAddon("GearHelper", "AceConsole-3.0", "AceEvent-3.0")
GearHelper.locals = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function ResetProfileOnMajorUpdate()
    local dbMajorAddonVersion = tonumber(string.match(GearHelper.db.global.addonVersion or "0", "%d+"))
    local currentAddonVersion = tonumber(string.match(GearHelperVars.version, "%d+"))
    if not (dbMajorAddonVersion == currentAddonVersion) then
        GearHelper:Print("Major update detected, resetting whole database...")
        GearHelper.db:ResetDB()
    end
end

function GearHelper:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GearHelperDB", GearHelper.defaultSettings)

    ResetProfileOnMajorUpdate()

    self.db.global.addonVersion = GearHelperVars.version
    self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

    GearHelper:LoadBaseStatTemplates()
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

function GHEvents:RegisterEvents()
    GearHelper:RegisterEvent("MERCHANT_SHOW", self.MERCHANT_SHOW)
    GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD)
    GearHelper:RegisterEvent("CHAT_MSG_ADDON", self.CHAT_MSG_ADDON)
    GearHelper:RegisterEvent("QUEST_COMPLETE", self.QUEST_COMPLETE)
    GearHelper:RegisterEvent("QUEST_DETAIL", self.QUEST_DETAIL)
    GearHelper:RegisterEvent("MERCHANT_CLOSED", self.MERCHANT_CLOSED)
    GearHelper:RegisterEvent("BAG_UPDATE", self.BAG_UPDATE)
    GearHelper:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", self.ACTIVE_TALENT_GROUP_CHANGED)
    GearHelper:RegisterEvent("CHAT_MSG_CHANNEL", self.CHAT_MSG_CHANNEL)
    GearHelper:RegisterEvent("CHAT_MSG_WHISPER", self.CHAT_MSG_WHISPER)
    GearHelper:RegisterEvent("CHAT_MSG_LOOT", self.CHAT_MSG_LOOT)
    GearHelper:RegisterEvent("CHAT_MSG_EMOTE", self.CHAT_MSG_EMOTE)
    GearHelper:RegisterEvent("CHAT_MSG_GUILD", self.CHAT_MSG_GUILD)
    GearHelper:RegisterEvent("CHAT_MSG_OFFICER", self.CHAT_MSG_OFFICER)
    GearHelper:RegisterEvent("CHAT_MSG_PARTY", self.CHAT_MSG_PARTY)
    GearHelper:RegisterEvent("CHAT_MSG_PARTY_LEADER", self.CHAT_MSG_PARTY_LEADER)
    GearHelper:RegisterEvent("CHAT_MSG_RAID", self.CHAT_MSG_RAID)
    GearHelper:RegisterEvent("CHAT_MSG_RAID_LEADER", self.CHAT_MSG_RAID_LEADER)
    GearHelper:RegisterEvent("CHAT_MSG_RAID_WARNING", self.CHAT_MSG_RAID_WARNING)
    GearHelper:RegisterEvent("CHAT_MSG_SAY", self.CHAT_MSG_SAY)
    GearHelper:RegisterEvent("CHAT_MSG_YELL", self.CHAT_MSG_YELL)
    GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
    GearHelper:RegisterEvent("QUEST_TURNED_IN", self.QUEST_TURNED_IN)
    GearHelper:RegisterEvent("PLAYER_LOGIN", self.PLAYER_LOGIN)
    GearHelper:RegisterEvent("LFG_UPDATE", self.LFG_UPDATE)
    GearHelper:RegisterEvent("READY_CHECK", self.READY_CHECK)
    GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
    GearHelper:RegisterEvent("BAG_UPDATE_DELAYED", self.BAG_UPDATE_DELAYED)
end

function GHEvents:UnregisterEvents()
    GearHelper:UnregisterEvent("MERCHANT_SHOW", self.ON_MERCHANT_SHOW)
    GearHelper:UnregisterEvent("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD)
    GearHelper:UnregisterEvent("CHAT_MSG_ADDON", self.CHAT_MSG_ADDON)
    GearHelper:UnregisterEvent("QUEST_COMPLETE", self.QUEST_COMPLETE)
    GearHelper:UnregisterEvent("QUEST_DETAIL", self.QUEST_DETAIL)
    GearHelper:UnregisterEvent("MERCHANT_CLOSED", self.MERCHANT_CLOSED)
    GearHelper:UnregisterEvent("BAG_UPDATE", self.BAG_UPDATE)
    GearHelper:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED", self.ACTIVE_TALENT_GROUP_CHANGED)
    GearHelper:UnregisterEvent("CHAT_MSG_CHANNEL", self.CHAT_MSG_CHANNEL)
    GearHelper:UnregisterEvent("CHAT_MSG_WHISPER", self.CHAT_MSG_WHISPER)
    GearHelper:UnregisterEvent("CHAT_MSG_LOOT", self.CHAT_MSG_LOOT)
    GearHelper:UnregisterEvent("CHAT_MSG_EMOTE", self.CHAT_MSG_EMOTE)
    GearHelper:UnregisterEvent("CHAT_MSG_GUILD", self.CHAT_MSG_GUILD)
    GearHelper:UnregisterEvent("CHAT_MSG_OFFICER", self.CHAT_MSG_OFFICER)
    GearHelper:UnregisterEvent("CHAT_MSG_PARTY", self.CHAT_MSG_PARTY)
    GearHelper:UnregisterEvent("CHAT_MSG_PARTY_LEADER", self.CHAT_MSG_PARTY_LEADER)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID", self.CHAT_MSG_RAID)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID_LEADER", self.CHAT_MSG_RAID_LEADER)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID_WARNING", self.CHAT_MSG_RAID_WARNING)
    GearHelper:UnregisterEvent("CHAT_MSG_SAY", self.CHAT_MSG_SAY)
    GearHelper:UnregisterEvent("CHAT_MSG_YELL", self.CHAT_MSG_YELL)
    GearHelper:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
    GearHelper:UnregisterEvent("QUEST_TURNED_IN", self.QUEST_TURNED_IN)
    GearHelper:UnregisterEvent("PLAYER_LOGIN", self.PLAYER_LOGIN)
    GearHelper:UnregisterEvent("LFG_UPDATE", self.LFG_UPDATE)
    GearHelper:UnregisterEvent("READY_CHECK", self.READY_CHECK)
    GearHelper:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
    GearHelper:UnregisterEvent("BAG_UPDATE_DELAYED", self.BAG_UPDATE_DELAYED)
end
