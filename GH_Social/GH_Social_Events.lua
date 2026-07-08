GHSocialEvents = {}
GHSocialEvents.__index = GHSocialEvents

function GHSocialEvents:RegisterEvents()
    GH_Social:RegisterEvent("CHAT_MSG_CHANNEL", self.CHAT_MSG_CHANNEL)
    GH_Social:RegisterEvent("CHAT_MSG_WHISPER", self.CHAT_MSG_WHISPER)
    GH_Social:RegisterEvent("CHAT_MSG_EMOTE", self.CHAT_MSG_EMOTE)
    GH_Social:RegisterEvent("CHAT_MSG_GUILD", self.CHAT_MSG_GUILD)
    GH_Social:RegisterEvent("CHAT_MSG_OFFICER", self.CHAT_MSG_OFFICER)
    GH_Social:RegisterEvent("CHAT_MSG_PARTY", self.CHAT_MSG_PARTY)
    GH_Social:RegisterEvent("CHAT_MSG_PARTY_LEADER", self.CHAT_MSG_PARTY_LEADER)
    GH_Social:RegisterEvent("CHAT_MSG_RAID", self.CHAT_MSG_RAID)
    GH_Social:RegisterEvent("CHAT_MSG_RAID_LEADER", self.CHAT_MSG_RAID_LEADER)
    GH_Social:RegisterEvent("CHAT_MSG_RAID_WARNING", self.CHAT_MSG_RAID_WARNING)
    GH_Social:RegisterEvent("CHAT_MSG_SAY", self.CHAT_MSG_SAY)
    GH_Social:RegisterEvent("CHAT_MSG_YELL", self.CHAT_MSG_YELL)
end

function GHSocialEvents:UnregisterEvents()
    GH_Social:UnregisterEvent("CHAT_MSG_CHANNEL", self.CHAT_MSG_CHANNEL)
    GH_Social:UnregisterEvent("CHAT_MSG_WHISPER", self.CHAT_MSG_WHISPER)
    GH_Social:UnregisterEvent("CHAT_MSG_EMOTE", self.CHAT_MSG_EMOTE)
    GH_Social:UnregisterEvent("CHAT_MSG_GUILD", self.CHAT_MSG_GUILD)
    GH_Social:UnregisterEvent("CHAT_MSG_OFFICER", self.CHAT_MSG_OFFICER)
    GH_Social:UnregisterEvent("CHAT_MSG_PARTY", self.CHAT_MSG_PARTY)
    GH_Social:UnregisterEvent("CHAT_MSG_PARTY_LEADER", self.CHAT_MSG_PARTY_LEADER)
    GH_Social:UnregisterEvent("CHAT_MSG_RAID", self.CHAT_MSG_RAID)
    GH_Social:UnregisterEvent("CHAT_MSG_RAID_LEADER", self.CHAT_MSG_RAID_LEADER)
    GH_Social:UnregisterEvent("CHAT_MSG_RAID_WARNING", self.CHAT_MSG_RAID_WARNING)
    GH_Social:UnregisterEvent("CHAT_MSG_SAY", self.CHAT_MSG_SAY)
    GH_Social:UnregisterEvent("CHAT_MSG_YELL", self.CHAT_MSG_YELL)
end
