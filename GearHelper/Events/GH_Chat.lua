function GHEvents:CHAT_MSG_LOOT(message, language, sender, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
    GearHelper:CreateLinkAskIfHeNeeds(0, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
end

-- function GHEvents:CHAT_MSG_ADDON(prefixMessage, message, _, sender)
--     if prefixMessage ~= GearHelperVars.prefixAddon then
--         do
--             return
--         end
--     end

--     local emetteur = ""
--     if sender:find("-") then
--         emetteur = sender:sub(0, (sender:find("-") - 1))
--     else
--         emetteur = sender
--     end

--     if emetteur == GetUnitName("player") then
--         do
--             return
--         end
--     end
--     local prefVersion = message:sub(0, (message:find(";") - 1))
--     if prefVersion == "answerVersion" then
--         local vVersion = message:sub(message:find(";") + 1, #message)
--         versionCible = vVersion
--         GearHelper:ReceiveAnswer(vVersion, sender)
--     end
--     if prefVersion == "askVersion" then
--         GearHelper:SendAnswerVersion()
--     end
-- end
