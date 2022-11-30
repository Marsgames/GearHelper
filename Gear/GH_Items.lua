GHItem = {
    itemLink = "",
    itemString = "",
    rarity = 0,
    levelRequired = 0,
    id = 0,
    type = "",
    subType = "",
    equipLoc = "",
    name = "",
    stats = {},
    iLvl = 0
}

function GHItem:Create(itemLink)
    local item = Item:CreateFromItemLink(itemLink)

    if item:IsItemEmpty() or GearHelper.itemSlot[select(4, GetItemInfoInstant(itemLink))] == nil then
        self:Print("GHItem:Create - Not building item because invalid / not a stuff "..itemLink)
        return nil
    end

    if(item:IsItemDataCached() == false) then
        self:Print("GHItem:Create - Item "..itemLink.." not in cache aborting waiting for loading")
        return nil
    end

    o = {}
    setmetatable(o, self)
    self.__index = self

    self.itemLink = itemLink
    self.itemString = string.match(self.itemLink, "item[%-?%d:]+")
    self.rarity = item:GetItemQuality()
    _, _, _, _, self.levelRequired = GetItemInfo(itemLink)
    self.id, self.type, self.subType, self.equipLoc = GetItemInfoInstant(self.itemLink)
    self.name = item:GetItemName()
    self.iLvl = item:GetCurrentItemLevel()

    return o
end

function GHItem:GetStats()
    if next(self.stats) == nil then
        local tooltipData = GearHelper:GetTooltipDataForItem(self.itemLink)
        
        for _, line in ipairs(tooltipData.lines) do
            if GetBasicStatFromLine(line) then
                local statName, statValue = GetBasicStatFromLine(line)
                self.stats[statName] = statValue
            else if GetArmorFromLine(line) then
                local statName, statValue = GetBasicStatFromLine(line)
                self.stats[statName] = statValue
            else if GetDPSFromLine(line) then
                local statName, statValue = GetBasicStatFromLine(line)
                self.stats[statName] = statValue
            end
        end
    
        self:Print("Statistics extracted from tooltip for "..self.itemLink)
        self:Print(stats)
    end

    return self.stats
end

-- TODO : Some improvement can be done here
function GHItem:IsEquippableByMe()
    self:Print("IsEquippableByMe - Testing item " .. self.itemLink)

    local isEquippable = false

    if (not IsEquippableItem(self.id) or string.match(self.itemLink, self.locals["mascotte"])) then
        self:Print("IsEquippableByMe - Not equippable / mascotte")
        return false
    end

    local myLevel = UnitLevel("player")
    local _, myClass = UnitClass("player")
    local playerSpec = GetSpecializationInfo(GetSpecialization())

    if self.levelRequired > myLevel or self.equipLoc == "INVTYPE_BAG" or self.equipLoc == "INVTYPE_TABARD" or
        self.equipLoc == "INVTYPE_BODY" then
        self:Print("IsEquippableByMe - No required level / wrong slot")
        return false
    elseif self.equipLoc == "INVTYPE_FINGER" or self.equipLoc == "INVTYPE_NECK" or self.equipLoc == "INVTYPE_TRINKET" or
        self.equipLoc == "INVTYPE_CLOAK" and self.subType == self.locals["divers"] or self.subType == L.IsEquippable.PRIEST.Tissu then
        return true
    elseif self.rarity == 6 then -- Artifacts
        if type(L.Artifact[tostring(playerSpec)]) == "string" then
            if tostring(self.id) == L.Artifact[tostring(playerSpec)] then
                return true
            end
        else
            table.foreach(
                L.Artifact[tostring(playerSpec)],
                function(_, v)
                    if tostring(self.id) == v then
                        isEquippable = true
                    end
                end
            )
        end
    else
        table.foreach(
            L.IsEquippable[tostring(myClass)],
            function(_, v)
                if self.subType == v then
                    isEquippable = true
                end
            end
        )
    end

    return isEquippable
end

-- TODO: Re-Add Gems handling when DF is out
function GHItem:GetItemScore()
    local valueItem = 0

    if GearHelper.db.profile.iLvlOption == true then
        if (GearHelper.db.profile.iLvlWeight == nil or GearHelper.db.profile.iLvlWeight == "") then
            GearHelper.db.profile.iLvlWeight = 10
        end

        valueItem = valueItem + item.iLvl * self.db.profile.iLvlWeight
    end

    for statName, statValue in pairs(item:GetStats()) do
        GearHelper:Print("GHItem:GetItemScore - StatName : "..statName.. " ValueInTemplate : "..GetStatFromTemplate(statName))

        valueItem = valueItem + GetStatFromTemplate(statName) * statValue
    end

    GearHelper:Print("GHItem:GetItemScore - Score : "..valueItem)

    return valueItem
end

local function GetBasicStatFromLine(line)
    local idxStart, _, statValue, statName = string.find(line.leftText, "+(%d+) (.+)")

    if idxStart then
        return statName, statValue
    end

    return nil
end

local function GetArmorFromLine(line)
    local fixedArmorTemplate = ARMOR_TEMPLATE:gsub("%%s", "(%%d+)")
    local idxStartArmor, _, statValueArmor, _ = string.find(line.leftText, fixedArmorTemplate)

    if idxStartArmor then
        return ARMOR, statValueArmor
    end

    return nil
end

local function GetDPSFromLine(line)
    local fixedDPSTemplate = DPS_TEMPLATE:gsub("%%s", "(%%d+,*%%d*)")
    local idxStartDPS, _, statValueDPS, _ = string.find(line.leftText, fixedDPSTemplate)

    if idxStartDPS then
        local formattedValue = statValueDPS:gsub(",", ".")
        return ITEM_MOD_DAMAGE_PER_SECOND_SHORT, tonumber(formattedValue)
    end

    return nil
end