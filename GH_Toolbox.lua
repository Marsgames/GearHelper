GHToolbox = {}
GHToolbox.__index = GHToolbox

function GHToolbox:MySplit(inputString, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}
    i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function GHToolbox:ReturnGoodLink(itemLink, target, tar)
    local itemString = select(3, strfind(itemLink, "|H(.+)|h"))
    local _, itemId = strsplit(":", itemString)

    if tar == nil then
        tar = ""
    end

    return "|HGHWhispWhenClick:askIfHeNeed_" .. target .. "_" .. itemId .. "_|h" .. tar .. "|h"
end

function GHToolbox:GetClassColor(classFileName)
    local color = RAID_CLASS_COLORS[classFileName]

    return "|c" .. color.colorStr
end

local function GetActiveTemplate()
    local returnValue

    -- Can occurs if you select CustomTemplate but you did not set a template
    if (nil == GearHelper.db.profile.weightTemplate or "" == GearHelper.db.profile.weightTemplate) then
        GearHelper.db.profile.weightTemplate = "NOX"
    end

    if GearHelper.db.profile.weightTemplate == "NOX" or GearHelper.db.profile.weightTemplate == "NOX_ByDefault" then
        local currentSpec = GetSpecializationInfo(GetSpecialization())
        if GearHelper.db.global.templates[currentSpec]["NOX"] == nil then
            error(GHExceptionMissingNoxTemplate)
        end

        returnValue = GearHelper.db.global.templates[currentSpec]["NOX"]
    else
        if (nil == GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate]) then
            error(GHExceptionMissingCustomTemplate)
        end

        returnValue = GearHelper.db.profile.CW[GearHelper.db.profile.weightTemplate]
    end

    return returnValue
end

-- function GearHelper:FindHighestStatInTemplate()
--     local template = GetActiveTemplate()

--     if (nil == template) then
--         error(GHExceptionTemplateIsNil)
--     end

--     local maxV = 0
--     local maxK = template[0]

--     for k, v in pairs(template) do
--         if (tonumber(v) and tonumber(v) > maxV) then
--             maxV = v
--             maxK = k
--         end
--     end

--     return maxK
-- end

local function GetColor(name)
    local colorList = {}
    colorList.yellow = "|cFFFFFF00"
    colorList.lightgreen = "|cFF00FF00"
    colorList.green = "|cFF1bad1b"
    colorList.lightred = "|cFFFF0000"
    colorList.red = "|cFFb51b1b"
    colorList.pink = "|cFFFF1493"
    colorList.better = "|cFF00FF96"
    colorList.white = "|cFFFFFFFF"
    colorList.black = "|cFF000000"

    return colorList[name:lower()]
end

function GHToolbox:ColorizeString(text, color)
    if GetColor(color) ~= nil then
        return GetColor(color) .. text
    else
        return text
    end
end

function GearHelper:GetQualityFromColor(color)
    if (color == "9d9d9d") then
        return 0
    elseif (color == "ffffff") then
        return 1
    elseif (color == "1eff00") then
        return 2
    elseif (color == "0070dd") then
        return 3
    elseif (color == "a335ee") then
        return 4
    elseif (color == "ff8000") then
        return 5
    elseif (color == "e6cc80") then
        return 6
    elseif (color == "00ccff") then
        return 7
    else
        error("Color " .. color .. " is not a possible choice")
    end
end

function GHToolbox:GetArraySize(tab)
    if (type(tab) ~= "table") then
        error(GHExceptionParameterIsNotAnArray)
    end

    local count = 0
    for _, _ in pairs(tab) do
        count = count + 1
    end

    return count
end

function GHToolbox:TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function GHToolbox:DelayedCallback(func, delay, ...)
    local args = {...}
    C_Timer.After(
        delay,
        function()
            func(unpack(args))
        end
    )
end
