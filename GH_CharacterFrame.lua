local function CharFrameShow(_)
    if not GearHelper.db.profile.ilvlCharFrame then
        do
            return
        end
    end

    table.foreach(
        GearHelperVars.charInventory,
        function(slotName, item, number)
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
                local yOffset = 0
                local parentAnchor = ""
                local childAnchor = ""

                if (slotName < 6 or slotName == 9 or slotName == 15 or slotName == 19) then
                    xOffset = 5
                    yOffset = 0
                    parentAnchor = "RIGHT"
                    childAnchor = "LEFT"
                elseif (slotName < 16) then
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

                local name = slotConverter[slotName]
                local pFrame = _G[name]

                local button = _G["charIlvlButton" .. name] or CreateFrame("Frame", "charIlvlButton" .. name, CharacterFrame) --    Our frame
                button:SetPoint(childAnchor, pFrame, parentAnchor, xOffset, yOffset)
                button:SetSize(50, 25)
                button:SetFrameStrata("HIGH")

                --  FontStrings only need a position set. By default, they size automatically according to the text shown.
                local text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") --    Our text area
                text:SetPoint(childAnchor, pFrame, parentAnchor, xOffset, yOffset)

                local itemScan = GHItem:Create(item.itemLink)
                local itemLink, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc

                if (itemLevel > 0) then
                    text:SetText(itemLevel)
                    local r, g, b = GetItemQualityColor(iR and iR or 0)
                    text:SetTextColor(r, g, b, 1)
                end
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
        function(slotName, _)
            if (_G["charIlvlButton" .. slotName]) then
                _G["charIlvlButton" .. slotName]:Hide()
                _G["charIlvlButton" .. slotName] = nil
            end
        end
    )
end
