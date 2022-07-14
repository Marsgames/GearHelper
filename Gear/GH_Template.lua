local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function GetStatFromTemplate(stat)
    GearHelper:BenchmarkCountFuncCall("GetStatFromTemplate")
    if (nil == GearHelper.db.profile.weightTemplate) then
        GearHelper:Print("WeightTemplate was nil, new value is NOX")
        GearHelper.db.profile.weightTemplate = "NOX"
    end

    if (GearHelper.db.profile.weightTemplate == "NOX" or GearHelper.db.profile.weightTemplate == "NOX_ByDefault") then
        local currentSpec = GetSpecializationInfo(GetSpecialization())
        if GearHelper.db.global.templates[currentSpec]["NOX"][stat] ~= nil then
            return GearHelper.db.global.templates[currentSpec]["NOX"][stat]
        end
    else
        if GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate][stat] ~= nil then
            return GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate][stat]
        end
    end
end

function GearHelper:ApplyTemplateToDelta(delta)
    self:BenchmarkCountFuncCall("GearHelper:ApplyTemplateToDelta")
    local valueItem = 0
    local mainStat = self:FindHighestStatInTemplate()

    -- TODO: Check the GetGemValue() function
    if self.db.profile.includeSocketInCompute == true then
        valueItem = delta.nbGem * self:GetGemValue() * GetStatFromTemplate(mainStat)
    end

    if self.db.profile.iLvlOption == true then
        if (self.db.profile.iLvlWeight == nil or self.db.profile.iLvlWeight == "") then
            self.db.profile.iLvlWeight = 10
        end

        valueItem = valueItem + delta.iLvl * self.db.profile.iLvlWeight
    end

    for k, v in pairs(delta) do
        if (k ~= nil and v ~= nil and L.Tooltip.Stat[k] ~= nil) then -- or v < 0) then
            if (GetStatFromTemplate(k) ~= nil and GetStatFromTemplate(k) ~= 0) then
                valueItem = valueItem + GetStatFromTemplate(k) * v
            else
                if (self.db.profile.defaultWeightForStat == nil) then
                    error(GHExceptionMissingDefaultWeight)
                    return
                else
                    valueItem = valueItem + self.db.profile.defaultWeightForStat * v
                end
            end
        end
    end

    return valueItem
end
