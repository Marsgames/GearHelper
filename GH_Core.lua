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

    self:CreateMinimapIcon()
    self:HookItemTooltip()
    self:HookMoneyTooltip()
end

function GearHelper:OnEnable()
    if not self.db.profile.addonEnabled then
        print(self:ColorizeString(self.locals["Addon"], "LightGreen") .. self:ColorizeString(self.locals["DeactivatedRed"], "LightRed"))
        return
    end

    print(self:ColorizeString(self.locals["Addon"], "LightGreen") .. self:ColorizeString(self.locals["ActivatedGreen"], "LightGreen"))
    print(GearHelper:ColorizeString(self.locals["merci"], "LightGreen"))

    --self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end