local waitAnswerFrame = CreateFrame("Frame")
local askTime, maxWaitTime = nil, 15
local updateAddonReminderCount = 3

waitAnswerFrame:Hide()

function GearHelper:SendAskVersion()
    if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
        C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "askVersion;" .. GearHelperVars.version, "RAID")
    end
    if IsInGuild() ~= nil and IsInGuild() == true then
        C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "askVersion;" .. GearHelperVars.version, "GUILD")
    end

    askTime = time()
    waitAnswerFrame:Show()
end

function GearHelper:SendAnswerVersion()
    if UnitInRaid("player") ~= nil and UnitInRaid("player") or UnitInParty("player") ~= nil and UnitInParty("player") then
        C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "RAID")
    end
    if IsInGuild() ~= nil and IsInGuild() == true then
        C_ChatInfo.SendAddonMessageLogged(GearHelperVars.prefixAddon, "answerVersion;" .. GearHelperVars.addonTruncatedVersion, "GUILD")
    end
end

function GearHelper:ReceiveAnswer(msgV, msgC)
    if not askTime or updateAddonReminderCount <= 0 or tonumber(msgV) ~= nil and tonumber(msgV) <= GearHelperVars.addonTruncatedVersion then
        return
    end

    message(self.locals["maj1"] .. GHToolbox:ColorizeString(GearHelperVars.version, "LightRed") .. self.locals["maj2"] .. GHToolbox:ColorizeString(msgV, "LightGreen") .. self.locals["maj3"] .. msgC .. " (Curse)")
    askTime = nil
    waitAnswerFrame:Hide()
    updateAddonReminderCount = updateAddonReminderCount - 1
end

local function ComputeAskTime(frame, elapsed)
    if not askTime or (time() - askTime) <= maxWaitTime then
        return
    end
    askTime = nil
    frame:Hide()
end

waitAnswerFrame:SetScript("OnUpdate", ComputeAskTime)
