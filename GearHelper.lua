-- Cleanup Trad data
-- CLeanup settings
local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

function GearHelper:setInviteMessage(newMessage)
    self:BenchmarkCountFuncCall("GearHelper:setInviteMessage")
    if newMessage == nil then
        return
    end

    self.db.profile.inviteMessage = tostring(newMessage)
    print(L["InviteMessage"] .. tostring(self.db.profile.inviteMessage))
end

function GearHelper:showMessageSMN(channel, sender, msg)
    self:BenchmarkCountFuncCall("GearHelper:showMessageSMN")
    if not self.db.profile.sayMyName or not msg then
        return
    end

    local stop = false
    local arrayNames = self:MySplit(self.db.global.myNames, ",")
    if arrayNames[1] == nil then
        return
    end

    local i = 1
    while (not stop and arrayNames[i]) do
        if (string.match(msg:lower(), arrayNames[i]:lower())) then
            UIErrorsFrame:AddMessage(channel .. " [" .. sender .. "]: " .. msg, 0.0, 1.0, 0.0)
            PlaySound(5275, "Master")
            stop = true
            return
        end
        i = i + 1
    end
end

function GearHelper:ScanCharacter()
    self:BenchmarkCountFuncCall("GearHelper:ScanCharacter")

    for slotID, _ in pairs(GearHelperVars.charInventory) do
        local item = Item:CreateFromEquipmentSlot(slotID)
        if item:IsItemEmpty() == false then
            if(item:IsItemDataCached() == false) then
                self:Print("Item in slot "..slotID.." not in cache")
            end
    
            item:ContinueOnItemLoad(function()
                self:Print("Scanning character slot "..slotID.." = "..item:GetItemLink())
                GearHelperVars.charInventory[slotID] = item:GetItemLink()
            end) 
        end
    end
end

function GearHelper:SetDotOnIcons()
    self:BenchmarkCountFuncCall("GearHelper:SetDotOnIcons")

    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local myBag = bag + 1
            local mySlot = C_Container.GetContainerNumSlots(bag) - (slot - 1)
            local button = _G["ContainerFrame" .. myBag .. "Item" .. mySlot]
            local itemLink = C_Container.GetContainerItemLink(bag, slot)

            if button.overlay then
                button.overlay:SetShown(false)
                button.overlay = nil
            end

            if (itemLink and self:IsItemBetter(itemLink) and not button.overlay) then
                button.overlay = button:CreateTexture(nil, "OVERLAY")
                button.overlay:SetSize(18, 18)
                button.overlay:SetPoint("TOPLEFT")
                button.overlay:SetTexture("Interface\\AddOns\\GearHelper\\Textures\\flecheUp")
                button.overlay:SetShown(true)
            end
        end
    end
    ContainerFrame_UpdateAll()
end

local function ShouldDisplayNotEquippable(subType)
    GearHelper:BenchmarkCountFuncCall("ShouldDisplayNotEquippable")

    if (GearHelper:IsValueInTable(L["TypeToNotNeed"], subType)) then
        return false
    end

    if GearHelper.db.profile.computeNotEquippable == true then
        return GearHelper:IsValueInTable(GearHelper:GetEquippableTypes(), tostring(subType))
    end

    return false
end

local function OnToolTipSetItem(tooltip, data)
    if not GearHelper.db or not GearHelper.db.profile.addonEnabled then
        return
    end

    local item = GearHelper:GetItem(select(2, TooltipUtil.GetDisplayedItem(tooltip)))

    if not item then return end

    GearHelper:Print("OnToolTipSetItem - New tooltip open "..item.itemLink)

    local linesToAdd = {}

    if IsEquippedItem(item.itemLink) then -- Item equipped, yellow overlay on tooltip
        GearHelper:Print("ModifyTooltip - Item already equipped, applying yellow overlay")
        tooltip.NineSlice:SetBorderColor(FACTION_YELLOW_COLOR.r, FACTION_YELLOW_COLOR.g, FACTION_YELLOW_COLOR.b)
        table.insert(linesToAdd, GearHelper:ColorizeString(L["itemEquipped"], "Yellow"))
    elseif item.isEquippable then
        GearHelper:Print("ModifyTooltip - Item not equipped, computing value...")
        local result = GearHelper:NewWeightCalculation(item)
        GearHelper:Print(result)

        if (type(result) == "table") then
            for _, v in pairs(result) do
                local floorValue = math.floor(v)

                if (floorValue < 0) then
                    self.NineSlice:SetBorderColor(1, 0, 0)
                else
                    self.NineSlice:SetBorderColor(0, 255, 150)
                end
            end
        end
        linesToAdd = GearHelper:LinesToAddToTooltip(result)
    elseif ShouldDisplayNotEquippable(tostring(item.subType)) then -- Item not equippable, red overlay on tooltip
        GearHelper:Print("ModifyTooltip - Item not equippable, applying red overlay")
        table.insert(linesToAdd, GearHelper:ColorizeString(L["itemNotEquippable"], "LightRed"))
        tooltip.NineSlice:SetBorderColor(FACTION_RED_COLOR.r, FACTION_RED_COLOR.g, FACTION_RED_COLOR.b)
    end

    -- Add droprate to tooltip
    GearHelper:GetDropInfo(linesToAdd, itemLink)

    if linesToAdd then
        tooltip:AddLine(" ")
        for _, v in pairs(linesToAdd) do
            tooltip:AddLine(v)
        end
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnToolTipSetItem)
GameTooltip:HookScript("OnHide", function(tooltip)
    -- Reset tooltip border color when hiding toltip (to avoid something like player tooltip to be red)
    tooltip.NineSlice:SetBorderColor(1, 1, 1)
end)

TooltipDataProcessor.AddTooltipPostCall(
    Enum.TooltipDataType.Money,
    function(self, amount)
        local _, itemLink = self:GetItem()
        if GearHelper.db.global.ItemCache[itemLink] and not GearHelper.db.global.ItemCache[itemLink].sellPrice then
            GearHelper.db.global.ItemCache[itemLink].sellPrice = amount
        end
    end
)