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
                local slotConverter = {
                    -- Left
                    [1] = "CharacterHeadSlotFrame",
                    [2] = "CharacterNeckSlotFrame",
                    [3] = "CharacterShoulderSlotFrame",
                    [15] = "CharacterBackSlotFrame",
                    [5] = "CharacterChestSlotFrame",
                    [4] = "CharacterShirtSlotFrame",
                    [19] = "CharacterTabardSlotFrame",
                    [9] = "CharacterWristSlotFrame",
                    --- Right
                    [10] = "CharacterHandsSlotFrame",
                    [6] = "CharacterWaistSlotFrame",
                    [7] = "CharacterLegsSlotFrame",
                    [8] = "CharacterFeetSlotFrame",
                    [11] = "CharacterFinger0SlotFrame",
                    [12] = "CharacterFinger1SlotFrame",
                    [13] = "CharacterTrinket0SlotFrame",
                    [14] = "CharacterTrinket1SlotFrame",
                    -- Bottom
                    [16] = "CharacterMainHandSlotFrame",
                    [17] = "CharacterSecondaryHandSlotFrame"
                }

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

                local name = slotConverter[slotID]
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
    GearHelper:HideIlvlOnCharFrame()
end

function GearHelper:AddIlvlOnCharFrame()
    PaperDollItemsFrame:HookScript("OnShow", CharFrameShow)
    PaperDollItemsFrame:HookScript("OnHide", CharFrameHide)
end

function GearHelper:HideIlvlOnCharFrame()
    table.foreach(
        GearHelperVars.charInventory,
        function(slotID, _)
            if (_G["charIlvlSlotFrame" .. slotID]) then
                _G["charIlvlSlotFrame" .. slotID]:Hide()
            end
        end
    )
end

function GearHelper:ResetIlvlOnCharFrame()
    GearHelper:HideIlvlOnCharFrame()
    if (PaperDollItemsFrame:IsVisible()) then
        CharFrameShow()
    end
end
