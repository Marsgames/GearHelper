local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

-- TODO: Replace that by @Marsgames suggestion about = true test
function GearHelper:IsValueInTable(tab, val)
    for _, v in pairs(tab) do
        if val == v then
            return true
        end
    end
    return false
end

-- Remove an item from table and return elem
function GearHelper:RemoveItemByKey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

function GearHelper:MySplit(inputString, separator)
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

function GearHelper:GetStatDeltaBetweenItems(looted, equipped)
    local delta = {}

    for k, v in pairs(looted) do
        if tonumber(v) and k ~= "id" and k ~= "levelRequired" then
            if equipped[k] == nil then --If looted item contain stat that are not on equipped item
                delta[k] = tonumber(v)
            else
                delta[k] = tonumber(v) - tonumber(equipped[k])
            end
        end
    end

    --We find stat that looted item doesn't have compared to equipped item
    for k, v in pairs(equipped) do
        if tonumber(v) and k ~= "id" and k ~= "levelRequired" then
            if looted[k] == nil then
                delta[k] = tonumber(v) * (-1)
            end
        end
    end
    return delta
end

local function AddStatToTab(item, tab)
    for k, v in pairs(item) do
        if tonumber(v) and k ~= "id" and k ~= "levelRequired" then
            if tab[k] == nil then
                tab[k] = tonumber(v)
            else
                tab[k] = tonumber(v) + tonumber(tab[k])
            end
        end
    end

    return tab
end

function GearHelper:CombineTwoItems(first, second)
    return AddStatToTab(second, AddStatToTab(first, {}))
end

local function CombineArraysOfEquippableTypes(arraysOfEquippableByClasses)
    local mergedArrays = {}
    for _, array in pairs(arraysOfEquippableByClasses) do
        for k, v in pairs(array) do
            mergedArrays[k] = v
        end
    end
    return mergedArrays
end

function GearHelper:GetEquippableTypes()
    return CombineArraysOfEquippableTypes(ITEM_TYPES_EQUIPPABLE_BY_CLASS)
end

function GearHelper:ReturnGoodLink(itemLink, target, tar)
    local itemString = select(3, strfind(itemLink, "|H(.+)|h"))
    local _, itemId = strsplit(":", itemString)

    if tar == nil then
        tar = ""
    end

    return "|HGHWhispWhenClick:askIfHeNeed_" .. target .. "_" .. itemId .. "_|h" .. tar .. "|h"
end

function GearHelper:GetClassColor(classFileName)
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

function GearHelper:FindHighestStatInTemplate()
    local template = GetActiveTemplate()

    if (nil == template) then
        error(GHExceptionTemplateIsNil)
    end

    local maxV = 0
    local maxK = template[0]

    for k, v in pairs(template) do
        if (tonumber(v) and tonumber(v) > maxV) then
            maxV = v
            maxK = k
        end
    end

    return maxK
end

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

function GearHelper:ColorizeString(text, color)
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

function GearHelper:HexColorToRGB(hexColor)
    local rhex, ghex, bhex = string.sub(hexColor, 1, 2), string.sub(hexColor, 3, 4), string.sub(hexColor, 5, 6)
    return tonumber(rhex, 16), tonumber(ghex, 16), tonumber(bhex, 16)
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