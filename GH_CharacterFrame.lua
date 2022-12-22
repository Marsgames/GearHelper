local slotConverter = {
    -- Left
    [1] = "HeadSlotFrame",
    [2] = "NeckSlotFrame",
    [3] = "ShoulderSlotFrame",
    [15] = "BackSlotFrame",
    [5] = "ChestSlotFrame",
    [4] = "ShirtSlotFrame",
    [19] = "TabardSlotFrame",
    [9] = "WristSlotFrame",
    --- Right
    [10] = "HandsSlotFrame",
    [6] = "WaistSlotFrame",
    [7] = "LegsSlotFrame",
    [8] = "FeetSlotFrame",
    [11] = "Finger0SlotFrame",
    [12] = "Finger1SlotFrame",
    [13] = "Trinket0SlotFrame",
    [14] = "Trinket1SlotFrame",
    -- Bottom
    [16] = "MainHandSlotFrame",
    [17] = "SecondaryHandSlotFrame"
}

-- ! ////////// ////////// Character Frame \\\\\\\\\\ \\\\\\\\\\ ! --

local function CharFrameShow(_)
    if not GearHelper.db.profile.ilvlCharFrame then
        do
            return
        end
    end

    table.foreach(
        GearHelperVars.charInventory,
        function(slotID, item, number)
            if (item ~= -1) then
                local xOffset = 0
                local yOffset = -2
                local parentAnchor = ""
                local childAnchor = ""

                if (slotID < 6 or slotID == 9 or slotID == 15 or slotID == 19) then
                    xOffset = 5
                    yOffset = 0
                    parentAnchor = "RIGHT"
                    childAnchor = "LEFT"
                elseif (slotID < 16) then
                    xOffset = -5
                    yOffset = 0
                    parentAnchor = "LEFT"
                    childAnchor = "RIGHT"
                else
                    xOffset = 0
                    yOffset = 5
                    parentAnchor = "TOP"
                    childAnchor = "BOTTOM"
                end

                local name = "Character" .. slotConverter[slotID]
                local pFrame = _G[name]

                local button = _G["charIlvlSlotFrame" .. slotID] or CreateFrame("Frame", "charIlvlSlotFrame" .. slotID, CharacterFrame) --    Our frame
                button:SetPoint(childAnchor, pFrame, parentAnchor, xOffset, yOffset)
                button:SetSize(50, 25)
                button:SetFrameStrata("HIGH")

                --  FontStrings only need a position set. By default, they size automatically according to the text shown.
                local text = _G["charIlvlSlotText" .. slotID] or button:CreateFontString("charIlvlSlotText" .. slotID, "OVERLAY", "GameFontNormal") --    Our text area
                text:SetPoint(childAnchor, pFrame, parentAnchor, xOffset, yOffset)

                local itemScan = GHItem:Create(item.itemLink)
                local itemLink, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc

                if (itemLevel > 0) then
                    text:SetText(itemLevel)
                    local r, g, b = GetItemQualityColor(iR and iR or 0)
                    text:SetTextColor(r, g, b, 1)
                    text:Show()
                end
                button:Show()
            end
        end
    )
end

local function CharFrameHide()
    table.foreach(
        GearHelperVars.charInventory,
        function(slotID, _)
            if (_G["charIlvlSlotFrame" .. slotID]) then
                _G["charIlvlSlotFrame" .. slotID]:Hide()
            end
        end
    )
end

function GearHelper:AddIlvlOnCharFrame()
    PaperDollItemsFrame:HookScript("OnShow", CharFrameShow)
    PaperDollItemsFrame:HookScript("OnHide", CharFrameHide)
end

function GearHelper:ResetIlvlOnCharFrame()
    CharFrameHide()
    if (PaperDollItemsFrame:IsVisible()) then
        CharFrameShow()
    end
end

-- ! ////////// ////////// Inspect Frame \\\\\\\\\\ \\\\\\\\\\ ! --

local function InspectFrameShow()
    if not GearHelper.db.profile.ilvlInspectFrame then
        do
            return
        end
    end

    -- For ids in slotConverter
    for slotID, slotName in pairs(slotConverter) do
        local itemLink = GetInventoryItemLink("target", slotID)
        if (itemLink) and (itemLink ~= -1) then
            local xOffset = 0
            local yOffset = -2
            local parentAnchor = ""
            local childAnchor = ""

            if (slotID < 6 or slotID == 9 or slotID == 15 or slotID == 19) then
                xOffset = 5
                yOffset = 0
                parentAnchor = "RIGHT"
                childAnchor = "LEFT"
            elseif (slotID < 16) then
                xOffset = -5
                yOffset = 0
                parentAnchor = "LEFT"
                childAnchor = "RIGHT"
            else
                xOffset = 0
                yOffset = 5
                parentAnchor = "TOP"
                childAnchor = "BOTTOM"
            end

            local name = "Inspect" .. slotConverter[slotID]
            local pFrame = _G[name]

            local button = _G["inspectIlvlSlotFrame" .. slotID] or CreateFrame("Frame", "inspectIlvlSlotFrame" .. slotID, InspectPaperDollItemsFrame) --    Our frame
            button:SetPoint(childAnchor, pFrame, parentAnchor, xOffset, yOffset)
            button:SetSize(50, 25)
            button:SetFrameStrata("TOOLTIP")

            --  FontStrings only need a position set. By default, they size automatically according to the text shown.
            local text = _G["inspectIlvlSlotText" .. slotID] or button:CreateFontString("inspectIlvlSlotText" .. slotID, "OVERLAY", "GameFontNormal") --    Our text area
            text:SetPoint(childAnchor, pFrame, parentAnchor, xOffset, yOffset)

            local itemScan = GHItem:Create(itemLink)
            local itemLink, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc

            if (itemLevel > 0) then
                text:SetText(itemLevel)
                local r, g, b = GetItemQualityColor(iR and iR or 0)
                text:SetTextColor(r, g, b, 1)
                text:Show()
            end
            button:Show()
        end
    end
end

local function InspectFrameHide()
    table.foreach(
        slotConverter,
        function(slotID, _)
            if (_G["inspectIlvlSlotFrame" .. slotID]) then
                _G["inspectIlvlSlotFrame" .. slotID]:Hide()
            end
        end
    )
    GearHelperVars.unitInspected = nil
end

function GearHelper:HookInspectFrame()
    InspectPaperDollItemsFrame:HookScript("OnShow", InspectFrameShow)
    InspectPaperDollItemsFrame:HookScript("OnHide", InspectFrameHide)
end
