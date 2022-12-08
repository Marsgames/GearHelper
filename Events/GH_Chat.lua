function GearHelperEvents:ChatMsgChannel(_, _, msg, sender, lang, channel)
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

function GearHelperEvents:ChatMsgWhisper(_, _, msg, sender)
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

function GearHelperEvents:ChatMsgLoot(_, _, message, language, sender, channelString, target, flags, unknown1,
    channelNumber, channelName, unknown2, counter)
    GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1,
        channelNumber, channelName, unknown2, counter)
end

function GearHelperEvents:ChatMsgEmote(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Emote", sender, msg)
end

function GearHelperEvents:ChatMsgGuild(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Guild", sender, msg)
end

function GearHelperEvents:ChatMsgOfficer(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Officer", sender, msg)
end

function GearHelperEvents:ChatMsgParty(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Party", sender, msg)
end

function GearHelperEvents:ChatMsgPartyLeader(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Party", sender, msg)
end

function GearHelperEvents:ChatMsgRaid(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Raid", sender, msg)
end

function GearHelperEvents:ChatMsgRaidLeader(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Raid", sender, msg)
end

function GearHelperEvents:ChatMsgRaidWarning(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Raid_warning", sender, msg)
end

function GearHelperEvents:ChatMsgSay(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Say", sender, msg)
end

function GearHelperEvents:ChatMsgYell(_, _, msg, sender, _, _)
    GearHelper:showMessageSMN("Yell", sender, msg)
end

function GearHelperEvents:ChatMsgAddon(_, _, prefixMessage, message, _, sender)
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