local function CharFrameShow(_)
    GearHelper:BenchmarkCountFuncCall("CharFrameShow")
    if not GearHelper.db.profile.ilvlCharFrame then
        do
            return
        end
    end

    table.foreach(
        GearHelperVars.charInventory,
        function(slotName, item, number)
            if (item ~= -1) then
                local arrayPos = {
                    xHead = -204,
                    xNeck = -204,
                    xShoulder = -204,
                    xBack = -204,
                    xChest = -204,
                    xWrist = -204,
                    xMainHand = -125,
                    xHands = -3,
                    xWaist = -3,
                    xLegs = -3,
                    xFeet = -3,
                    xFinger0 = -3,
                    xFinger1 = -3,
                    xTrinket0 = -3,
                    xTrinket1 = -3,
                    xSecondaryHand = -77,
                    yHead = 140 - 15,
                    yNeck = 99 - 15,
                    yShoulder = 58 - 15,
                    yBack = 17 - 15,
                    yChest = -24 - 15,
                    yWrist = -147 - 15,
                    yMainHand = -140,
                    yHands = 140,
                    yWaist = 99 - 15,
                    yLegs = 58 - 15,
                    yFeet = 17 - 15,
                    yFinger0 = -24 - 15,
                    yFinger1 = -65 - 15,
                    yTrinket0 = -106 - 15,
                    yTrinket1 = -147 - 15,
                    ySecondaryHand = -140
                }

                local button = _G["charIlvlButton" .. slotName] or CreateFrame("Button", "charIlvlButton" .. slotName, PaperDollItemsFrame)
                button:SetPoint("CENTER", PaperDollItemsFrame, "CENTER", arrayPos["x" .. slotName], arrayPos["y" .. slotName])
                button:SetSize(1, 1)

                if (item ~= 0) then
                    local itemScan = GearHelper:GetItemByLink(item, "GH_CharacterFrame.CharFrameShow()")
                    local itemLink, iR, itemLevel, itemEquipLoc = itemScan.itemLink, itemScan.rarity, itemScan.iLvl, itemScan.equipLoc
                    iR = ((iR == "9d9d9d" and 0) or (iR == "ffffff" and 1) or (iR == "1eff00" and 2) or (iR == "0070dd" and 3) or (iR == "a335ee" and 4) or (iR == "ff8000" and 5) or (iR == "e6cc80" and 6) or (iR == "00ccff" and 7))

                    button:SetText(itemLevel)
                    button:SetNormalFontObject("GameFontNormalSmall")

                    local font = _G["charIlvlFont" .. slotName] or CreateFont("charIlvlFont" .. slotName)
                    local r, g, b = GetItemQualityColor(iR ~= nil and iR or 0)
                    font:SetTextColor(r, g, b, 1)
                    button:SetNormalFontObject(font)
                end
            end
        end
    )
end

local function CharFrameHide()
    GearHelper:BenchmarkCountFuncCall("CharFrameHide")
    GearHelper:HideIlvlOnCharFrame()
end

function GearHelper:AddIlvlOnCharFrame()
    self:BenchmarkCountFuncCall("GearHelper:AddIlvlOnCharFrame")

    PaperDollItemsFrame:HookScript("OnShow", CharFrameShow)
    PaperDollItemsFrame:HookScript("OnHide", CharFrameHide)
end

function GearHelper:HideIlvlOnCharFrame()
    GearHelper:BenchmarkCountFuncCall("GearHelper:HideIlvlOnCharFrame")
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
