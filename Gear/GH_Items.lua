GHItem = {}
GHItem.__index = GHItem

function GHItem:Create(itemLink)
    local this = {
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
        iLvl = 0,
        isEmpty = true
    }

    setmetatable(this, GHItem)

    if not itemLink or IsCosmeticItem(itemLink) then
        return this
    end

    local item = Item:CreateFromItemLink(itemLink)

    if item:IsItemEmpty() or GearHelper.itemSlot[select(4, GetItemInfoInstant(itemLink))] == nil then
        return this
    end

    if (item:IsItemDataCached() == false) then
        GearHelper:Print("GHItem:Create - Item " .. itemLink .. " not in cache aborting waiting for loading")
        return this
    end

    this.itemLink = itemLink
    this.itemString = string.match(this.itemLink, "item[%-?%d:]+")
    this.rarity = item:GetItemQuality()
    _, _, _, _, this.levelRequired = GetItemInfo(itemLink)
    this.id, this.type, this.subType, this.equipLoc = GetItemInfoInstant(this.itemLink)
    this.name = item:GetItemName()
    this.iLvl = item:GetCurrentItemLevel()
    this.isEmpty = false

    return this
end

function GHItem:CreateEmpty()
    return self:Create(nil)
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
    local fixedDPSTemplate = DPS_TEMPLATE:gsub("%(", ""):gsub("%)", ""):gsub("%%s", "(%%d+,*%%d*)")
    local idxStartDPS, _, statValueDPS, _ = string.find(line.leftText, fixedDPSTemplate)

    if idxStartDPS then
        local formattedValue = statValueDPS:gsub(",", ".")
        return ITEM_MOD_DAMAGE_PER_SECOND_SHORT, tonumber(formattedValue)
    end

    return nil
end

function GHItem:GetStats()
    if next(self.stats) == nil then
        local tooltipData = GearHelper:GetTooltipDataForItem(self.itemLink)

        for _, line in ipairs(tooltipData.lines) do
            if GetBasicStatFromLine(line) then
                local statName, statValue = GetBasicStatFromLine(line)
                self.stats[statName] = tonumber(statValue)
            elseif GetArmorFromLine(line) then
                local statName, statValue = GetArmorFromLine(line)
                self.stats[statName] = tonumber(statValue)
            elseif GetDPSFromLine(line) then
                local statName, statValue = GetDPSFromLine(line)
                self.stats[statName] = tonumber(statValue)
            end
        end

        GearHelper:Print("Statistics extracted from tooltip for " .. self.itemLink)
        GearHelper:Print(self.stats)
    end

    return self.stats
end

function GHItem:IsEquippableByMe()
    if (self.id == nil) then
        do
            return
        end
    end
    local inventoryType = C_Item.GetItemInventoryTypeByID(self.id)

    if INVTYPE_TO_IGNORE[inventoryType] or inventoryType == 0 then
        GearHelper:Print("IsEquippableByMe - InvType to ignore")
        return false
    end

    local myLevel = UnitLevel("player")
    local _, myClass = UnitClass("player")

    if self.levelRequired > myLevel then
        GearHelper:Print("IsEquippableByMe - Required level not met")
        return false
    elseif self.equipLoc == "INVTYPE_FINGER" or self.equipLoc == "INVTYPE_NECK" or self.equipLoc == "INVTYPE_TRINKET" or self.equipLoc == "INVTYPE_CLOAK" and self.subType == MISCELLANEOUS or self.subType == ITEM_TYPES_EQUIPPABLE_BY_CLASS.PRIEST.Tissu then -- Things that any class can equip
        return true
    else
        local isEquippable = false
        table.foreach(
            ITEM_TYPES_EQUIPPABLE_BY_CLASS[tostring(myClass)],
            function(_, v)
                if self.subType == v then
                    isEquippable = true
                end
            end
        )
        return isEquippable
    end
end

function GHItem:IsEquipped()
    if not IsEquippedItem(self.itemLink) then --Quick check, we can rely on value returned here
        return false
    else --However we can't rely on IsEquippedItem because it behaves weirdly on items with different bonusIDs
        local equippedItems = GearHelper:GetEquippedItems(self.equipLoc)

        for _, equippedItem in pairs(equippedItems.items) do
            if equippedItem.itemLink == self.itemLink then
                return true
            end
        end

        return false
    end
end

-- TODO: Re-Add Gems handling when DF is out
function GHItem:GetScore()
    local valueItem = 0

    if self.isEmpty then
        return 0
    end
    if GearHelper.db.profile.iLvlOption == true then
        if (GearHelper.db.profile.iLvlWeight == nil or GearHelper.db.profile.iLvlWeight == "") then
            GearHelper.db.profile.iLvlWeight = 10
        end

        valueItem = valueItem + self.iLvl * GearHelper.db.profile.iLvlWeight
    end

    for statName, statValue in pairs(self:GetStats()) do
        valueItem = valueItem + GearHelper:GetStatFromActiveTemplate(statName) * statValue
    end

    return valueItem
end
