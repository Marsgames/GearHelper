GearHelper = LibStub("AceAddon-3.0"):NewAddon("GearHelper", "AceConsole-3.0", "AceEvent-3.0")
GearHelper.locals = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function ResetProfileOnMajorUpdate()
    local dbMajorAddonVersion = tonumber(string.match(GearHelper.db.global.addonVersion or "0", "%d+"))
    local currentAddonVersion = tonumber(string.match(GearHelperVars.version, "%d+"))
    if not (dbMajorAddonVersion == currentAddonVersion) then
        GearHelper:Print("Major update detected, resetting whole database...")
        GearHelper.db:ResetDB()
        print("Major update detected database has been reset. Please verify your settings.")
        C_Timer.After(0, function() Settings.OpenToCategory("GearHelper") end)
    end
end

function GearHelper:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GearHelperDB", GearHelper.defaultSettings)

    ResetProfileOnMajorUpdate()

    if (type(GearHelper.db.profile.debug) == "boolean") then
        GearHelper:SlashResetDebug()
    end

    self.db.global.addonVersion = GearHelperVars.version

    GearHelper:LoadBaseStatTemplates()
    securecall(GHOptions.GenerateOptions)
end

function GearHelper:OnEnable()
    print(GHToolbox:ColorizeString(self.locals["Addon"], "LightGreen") .. GHToolbox:ColorizeString(self.locals["ActivatedGreen"], "LightGreen"))
    print(GHToolbox:ColorizeString(self.locals["merci"], "LightGreen"))
    GHEvents:RegisterEvents()
    self:HookItemTooltip()
    self:HookMoneyTooltip()
    self:HookBagOpen()
end

function GearHelper:OnDisable()
    print(GHToolbox:ColorizeString(self.locals["Addon"], "LightGreen") ..
    GHToolbox:ColorizeString(self.locals["DeactivatedRed"], "LightRed"))
    GHEvents:UnregisterEvents()
    --self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end

-- function GHEvents:ADDON_ACTION_BLOCKED(addonName, addonFunc)
--     if (addonName == "GearHelper") then
--         GearHelper:Print("----- ADDON_ACTION_BLOCKED -----")
--         GearHelper:Print(addonFunc .. " function is blocked by Blizzard")
--         GearHelper:Print(debugstack())
--     end
-- end

-- function GHEvents:ADDON_ACTION_FORBIDDEN(addonName, addonFunc)
--     if (addonName == "GearHelper") then
--         GearHelper:Print("----- ADDON_ACTION_FORBIDDEN -----")
--         GearHelper:Print(addonFunc .. " function is forbidden by Blizzard")
--         GearHelper:Print(debugstack())
--     end
-- end