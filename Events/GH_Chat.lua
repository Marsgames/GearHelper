function GHEvents:CHAT_MSG_CHANNEL(msg, sender, lang, channel)
    if not GearHelper.db.profile.autoInvite or not msg then
        GearHelper:showMessageSMN(channel, sender, msg)
        do
            return
        end
    end

    local playerIsNotMe = not string.find(sender, GetUnitName("player"))
    if msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe and GetNumGroupMembers() == 5 then
        ConvertToRaid()
        InviteUnit(sender)
    elseif msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe then
        InviteUnit(sender)
    end

    GearHelper:showMessageSMN(channel, sender, msg)
end

function GHEvents:CHAT_MSG_WHISPER(msg, sender)
    if GearHelper.db.profile.autoInvite and msg ~= nil then
        local playerIsNotMe = not string.find(sender, GetUnitName("player"))
        if msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe and GetNumGroupMembers() == 5 then
            ConvertToRaid()
            InviteUnit(sender)
        elseif msg:lower() == GearHelper.db.profile.inviteMessage:lower() and playerIsNotMe then
            InviteUnit(sender)
        end
    end
    if (GearHelper.db.profile.whisperAlert) then
        PlaySoundFile("Interface\\AddOns\\GearHelper\\Textures\\whisper.ogg", "Master")
    end
end

function GHEvents:CHAT_MSG_LOOT(message, language, sender, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
    GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
end

function GHEvents:CHAT_MSG_EMOTE(msg, sender)
    GearHelper:showMessageSMN("Emote", sender, msg)
end

function GHEvents:CHAT_MSG_GUILD(msg, sender)
    GearHelper:showMessageSMN("Guild", sender, msg)
end

function GHEvents:CHAT_MSG_OFFICER(msg, sender)
    GearHelper:showMessageSMN("Officer", sender, msg)
end

function GHEvents:CHAT_MSG_PARTY(msg, sender)
    GearHelper:showMessageSMN("Party", sender, msg)
end

function GHEvents:CHAT_MSG_PARTY_LEADER(msg, sender)
    GearHelper:showMessageSMN("Party", sender, msg)
end

function GHEvents:CHAT_MSG_RAID(msg, sender)
    GearHelper:showMessageSMN("Raid", sender, msg)
end

function GHEvents:CHAT_MSG_RAID_LEADER(msg, sender)
    GearHelper:showMessageSMN("Raid", sender, msg)
end

function GHEvents:CHAT_MSG_RAID_WARNING(msg, sender)
    GearHelper:showMessageSMN("Raid_warning", sender, msg)
end

function GHEvents:CHAT_MSG_SAY(msg, sender)
    GearHelper:showMessageSMN("Say", sender, msg)
end

function GHEvents:CHAT_MSG_YELL(msg, sender)
    GearHelper:showMessageSMN("Yell", sender, msg)
end

function GHEvents:CHAT_MSG_ADDON(prefixMessage, message, _, sender)
    if prefixMessage ~= GearHelperVars.prefixAddon then
        do
            return
        end
    end

    local emetteur = ""
    if sender:find("-") then
        emetteur = sender:sub(0, (sender:find("-") - 1))
    else
        emetteur = sender
    end

    if emetteur == GetUnitName("player") then
        do
            return
        end
    end
    local prefVersion = message:sub(0, (message:find(";") - 1))
    if prefVersion == "answerVersion" then
        local vVersion = message:sub(message:find(";") + 1, #message)
        versionCible = vVersion
        GearHelper:ReceiveAnswer(vVersion, sender)
    end
    if prefVersion == "askVersion" then
        GearHelper:SendAnswerVersion()
    end
end
