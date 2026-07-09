GH_Social = LibStub("AceAddon-3.0"):NewAddon("GH_Social", "AceConsole-3.0", "AceEvent-3.0")

GH_Social.defaultSettings = {
    profile = {
        autoInvite = false,
        inviteMessage = "inv",
        whisperAlert = false,
        sayMyName = false,
        myNames = "",
        bossesKilled = false,
    }
}

function GH_Social:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GH_SocialDB", GH_Social.defaultSettings)
    GH_Social_Options:GenerateOptions()
end

function GH_Social:OnEnable()
    GHSocialEvents:RegisterEvents()

    if self.db.profile.bossesKilled and RaidFinderQueueFrame then
        self:CreateLfrButtons(RaidFinderQueueFrame)
        self:UpdateButtonsAndTooltips(RaidFinderQueueFrame)
        self:UpdateGHLfrButton()
        self:UpdateSelectCursor()
    end
end

function GH_Social:OnDisable()
    GHSocialEvents:UnregisterEvents()
end

function GH_Social:SetInviteMessage(newMessage)
    if newMessage == nil then
        return
    end
    self.db.profile.inviteMessage = tostring(newMessage)
    print("GH_Social: Invite message set to: " .. tostring(self.db.profile.inviteMessage))
end

function GH_Social:ShowMessageSMN(channel, sender, msg)
    if not self.db.profile.sayMyName or not msg then
        return
    end

    local arrayNames = GHToolbox:MySplit(self.db.global.myNames or "", ",")
    if arrayNames[1] == nil then
        return
    end

    for _, name in ipairs(arrayNames) do
        if string.match(msg:lower(), name:lower()) then
            UIErrorsFrame:AddMessage(channel .. " [" .. sender .. "]: " .. msg, 0.0, 1.0, 0.0)
            PlaySound(5275, "Master")
            return
        end
    end
end
