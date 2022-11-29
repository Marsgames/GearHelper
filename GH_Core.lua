GearHelper = LibStub("AceAddon-3.0"):NewAddon("GearHelper", "AceConsole-3.0", "AceEvent-3.0")

function GearHelper:Print(object)
    GearHelper:BenchmarkCountFuncCall("GearHelper:Print")
    local file, ln = strmatch(debugstack(2, 1, 0), "([%w_]*%.lua).*%:(%d+)")

    if (GearHelper.db.profile.debug) then
        if type(object) == "table" then
            print(WrapTextInColorCode("[GearHelper]", "FF00FF96"), WrapTextInColorCode(file .. ":" .. ln, "FF9482C9"),
                "\n-------------- TABLE --------------\n")
            DevTools_Dump(object)
            print("-------------- ENDTABLE -----------")
        else
            print(WrapTextInColorCode("[GearHelper]", "FF00FF96"), WrapTextInColorCode(file .. ":" .. ln, "FF9482C9"),
                "-", object or tostring(nil))
        end
    end
end

function GearHelper:OnInitialize()
    self:BenchmarkCountFuncCall("GearHelper:OnInitialize")

    local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

    self.db = LibStub("AceDB-3.0"):New("GearHelperDB", GearHelper.defaultSettings)
    self.db.RegisterCallback(self, "OnProfileChanged", "OnRefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "OnRefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "OnResetConfig")
    self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

    GearHelper:LoadBaseStatTemplates()

    print(GearHelper:ColorizeString(L["merci"], "LightGreen"))
    local runningBuild = select(4, GetBuildInfo())
    if GearHelper.db.global.buildVersion ~= runningBuild then
        GearHelper.db.global.buildVersion = runningBuild
    end

    self:CreateMinimapIcon()
end

function GearHelper:OnRefreshConfig()
    self:BenchmarkCountFuncCall("GearHelper:RefreshConfig")
    InterfaceOptionsFrame:Show()
    InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:OnResetConfig()
    self:BenchmarkCountFuncCall("GearHelper:ResetConfig")
    
    self:NilTableValues(self.db.profile)
    self:NilTableValues(self.db.global)

    InterfaceOptionsFrame:Hide()
    InterfaceOptionsFrame:Show()
    InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:OnEnable()
    local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

    self:BenchmarkCountFuncCall("GearHelper:OnEnable")
    if not self.db.profile.addonEnabled then
        print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["DeactivatedRed"], "LightRed"))
        return
    end

    print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["ActivatedGreen"], "LightGreen"))
    self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
end

function GearHelper:NilTableValues(tableToReset)
    self:BenchmarkCountFuncCall("GearHelper:NilTableValues")
    for key, _ in pairs(tableToReset) do
        if type(tableToReset[key]) == "table" then
            self:NilTableValues(tableToReset[key])
        else
            tableToReset[key] = nil
        end
    end
end

function GearHelper:GetArraySize(tab)
    if (type(tab) ~= "table") then
        error(GHExceptionParameterIsNotAnArray)
    end

    local count = 0
    for _, _ in pairs(tab) do
        count = count + 1
    end

    return count
end