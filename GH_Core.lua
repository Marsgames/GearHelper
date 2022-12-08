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
    GearHelperEvents:RegisterEvents()
    self:HookItemTooltip()
    self:HookMoneyTooltip()
    --self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end

function GearHelper:OnDisable()
    print(GHToolbox:ColorizeString(self.locals["Addon"], "LightGreen") .. GHToolbox:ColorizeString(self.locals["DeactivatedRed"], "LightRed"))
    GearHelperEvents:UnregisterEvents()
    --self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end

function GearHelperEvents:RegisterEvents()
    GearHelper:RegisterEvent("MERCHANT_SHOW", self.OnMerchantShow)
    GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", self.PlayerEnteringWorld)
    GearHelper:RegisterEvent("CHAT_MSG_ADDON", self.ChatMsgAddon, ...)
    GearHelper:RegisterEvent("QUEST_COMPLETE", self.QuestComplete)
    GearHelper:RegisterEvent("QUEST_DETAIL", self.QuestDetail)
    GearHelper:RegisterEvent("MERCHANT_CLOSED", self.MerchantClosed)
    GearHelper:RegisterEvent("BAG_UPDATE", self.BagUpdate, ...)
    GearHelper:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", self.ActiveTalentGroupChanged)
    GearHelper:RegisterEvent("CHAT_MSG_CHANNEL", self.ChatMsgChannel, ...)
    GearHelper:RegisterEvent("CHAT_MSG_WHISPER", self.ChatMsgWhisper, ...)
    GearHelper:RegisterEvent("CHAT_MSG_LOOT", self.ChatMsgLoot, ...)
    GearHelper:RegisterEvent("CHAT_MSG_EMOTE", self.ChatMsgEmote, ...)
    GearHelper:RegisterEvent("CHAT_MSG_GUILD", self.ChatMsgGuild, ...)
    GearHelper:RegisterEvent("CHAT_MSG_OFFICER", self.ChatMsgOfficer, ...)
    GearHelper:RegisterEvent("CHAT_MSG_PARTY", self.ChatMsgParty, ...)
    GearHelper:RegisterEvent("CHAT_MSG_PARTY_LEADER", self.ChatMsgPartyLeader, ...)
    GearHelper:RegisterEvent("CHAT_MSG_RAID", self.ChatMsgRaid, ...)
    GearHelper:RegisterEvent("CHAT_MSG_RAID_LEADER", self.ChatMsgRaidLeader, ...)
    GearHelper:RegisterEvent("CHAT_MSG_RAID_WARNING", self.ChatMsgRaidWarning, ...)
    GearHelper:RegisterEvent("CHAT_MSG_SAY", self.ChatMsgSay, ...)
    GearHelper:RegisterEvent("CHAT_MSG_YELL", self.ChatMsgYell, ...)
    GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UnitInventoryChanged, ...)
    GearHelper:RegisterEvent("QUEST_TURNED_IN", self.QuestTurnedIn)
    GearHelper:RegisterEvent("PLAYER_LOGIN", self.PlayerLogin, ...)
    GearHelper:RegisterEvent("LFG_UPDATE", self.LfgUpdate, ...)
    GearHelper:RegisterEvent("READY_CHECK", self.ReadyCheck, ...)
    GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UnitInventoryChanged, ...)
    GearHelper:RegisterEvent("BAG_UPDATE_DELAYED", self.BagUpdateDelayed, ...)
end

function GearHelperEvents:UnregisterEvents()
    GearHelper:UnregisterEvent("MERCHANT_SHOW", self.OnMerchantShow)
    GearHelper:UnregisterEvent("PLAYER_ENTERING_WORLD", self.PlayerEnteringWorld)
    GearHelper:UnregisterEvent("CHAT_MSG_ADDON", self.ChatMsgAddon, ...)
    GearHelper:UnregisterEvent("QUEST_COMPLETE", self.QuestComplete)
    GearHelper:UnregisterEvent("QUEST_DETAIL", self.QuestDetail)
    GearHelper:UnregisterEvent("MERCHANT_CLOSED", self.MerchantClosed)
    GearHelper:UnregisterEvent("BAG_UPDATE", self.BagUpdate, ...)
    GearHelper:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED", self.ActiveTalentGroupChanged)
    GearHelper:UnregisterEvent("CHAT_MSG_CHANNEL", self.ChatMsgChannel, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_WHISPER", self.ChatMsgWhisper, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_LOOT", self.ChatMsgLoot, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_EMOTE", self.ChatMsgEmote, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_GUILD", self.ChatMsgGuild, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_OFFICER", self.ChatMsgOfficer, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_PARTY", self.ChatMsgParty, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_PARTY_LEADER", self.ChatMsgPartyLeader, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID", self.ChatMsgRaid, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID_LEADER", self.ChatMsgRaidLeader, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_RAID_WARNING", self.ChatMsgRaidWarning, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_SAY", self.ChatMsgSay, ...)
    GearHelper:UnregisterEvent("CHAT_MSG_YELL", self.ChatMsgYell, ...)
    GearHelper:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UnitInventoryChanged, ...)
    GearHelper:UnregisterEvent("QUEST_TURNED_IN", self.QuestTurnedIn)
    GearHelper:UnregisterEvent("PLAYER_LOGIN", self.PlayerLogin, ...)
    GearHelper:UnregisterEvent("LFG_UPDATE", self.LfgUpdate, ...)
    GearHelper:UnregisterEvent("READY_CHECK", self.ReadyCheck, ...)
    GearHelper:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UnitInventoryChanged, ...)
    GearHelper:UnregisterEvent("BAG_UPDATE_DELAYED", self.BagUpdateDelayed, ...)
end
