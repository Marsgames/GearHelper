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
