function GHSocialEvents:CHAT_MSG_CHANNEL(msg, sender, lang, channel)
    if not GH_Social.db.profile.autoInvite or not msg then
        GH_Social:ShowMessageSMN(channel, sender, msg)
        return
    end

    local playerIsNotMe = not string.find(sender, GetUnitName("player"))
    if msg:lower() == GH_Social.db.profile.inviteMessage:lower() and playerIsNotMe then
        if GetNumGroupMembers() == 5 then
            ConvertToRaid()
        end
        InviteUnit(sender)
    end

    GH_Social:ShowMessageSMN(channel, sender, msg)
end

function GHSocialEvents:CHAT_MSG_WHISPER(msg, sender)
    if GH_Social.db.profile.autoInvite and msg ~= nil then
        local playerIsNotMe = not string.find(sender, GetUnitName("player"))
        if msg:lower() == GH_Social.db.profile.inviteMessage:lower() and playerIsNotMe then
            if GetNumGroupMembers() == 5 then
                ConvertToRaid()
            end
            InviteUnit(sender)
        end
    end

    if GH_Social.db.profile.whisperAlert then
        PlaySound(SOUNDKIT.IG_CHAT_WHISPER_INFORM, "Master")
    end
end

function GHSocialEvents:CHAT_MSG_EMOTE(msg, sender)
    GH_Social:ShowMessageSMN("Emote", sender, msg)
end

function GHSocialEvents:CHAT_MSG_GUILD(msg, sender)
    GH_Social:ShowMessageSMN("Guild", sender, msg)
end

function GHSocialEvents:CHAT_MSG_OFFICER(msg, sender)
    GH_Social:ShowMessageSMN("Officer", sender, msg)
end

function GHSocialEvents:CHAT_MSG_PARTY(msg, sender)
    GH_Social:ShowMessageSMN("Party", sender, msg)
end

function GHSocialEvents:CHAT_MSG_PARTY_LEADER(msg, sender)
    GH_Social:ShowMessageSMN("Party", sender, msg)
end

function GHSocialEvents:CHAT_MSG_RAID(msg, sender)
    GH_Social:ShowMessageSMN("Raid", sender, msg)
end

function GHSocialEvents:CHAT_MSG_RAID_LEADER(msg, sender)
    GH_Social:ShowMessageSMN("Raid", sender, msg)
end

function GHSocialEvents:CHAT_MSG_RAID_WARNING(msg, sender)
    GH_Social:ShowMessageSMN("Raid_warning", sender, msg)
end

function GHSocialEvents:CHAT_MSG_SAY(msg, sender)
    GH_Social:ShowMessageSMN("Say", sender, msg)
end

function GHSocialEvents:CHAT_MSG_YELL(msg, sender)
    GH_Social:ShowMessageSMN("Yell", sender, msg)
end
