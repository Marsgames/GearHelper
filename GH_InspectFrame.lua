local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function InspectFrameShow(_)
    GearHelper:BenchmarkCountFuncCall("InspectFrameShow")

    if not GearHelper.db.profile.ilvlInspectFrame then
        do
            return
        end
    end

    local arrayPos = {
        xINVTYPE_HEAD = -100,
        xINVTYPE_NECK = -100,
        xINVTYPE_SHOULDER = -100,
        xINVTYPE_BACK = -100,
        xINVTYPE_ROBE = -100,
        xINVTYPE_CLOAK = -100,
        xINVTYPE_CHEST = -100,
        xINVTYPE_BODY = -100,
        xINVTYPE_TABARD = -100,
        xINVTYPE_WRIST = -100,
        xINVTYPE_MAINHAND = -20,
        xINVTYPE_RANGED = -20,
        xINVTYPE_WEAPONMAINHAND = -20,
        xINVTYPE_2HWEAPON = -20,
        xINVTYPE_WEAPON = -20,
        xINVTYPE_RANGEDRIGHT = -20,
        xINVTYPE_HAND = 95,
        xINVTYPE_WAIST = 95,
        xINVTYPE_LEGS = 95,
        xINVTYPE_FEET = 95,
        xINVTYPE_FINGER = 95,
        xINVTYPE_TRINKET = 95,
        xINVTYPE_SECONDARYHAND = 20,
        xINVTYPE_WEAPONOFFHAND = 20,
        yINVTYPE_HEAD = 140,
        yINVTYPE_NECK = 99,
        yINVTYPE_SHOULDER = 58,
        yINVTYPE_BACK = 17,
        yINVTYPE_CLOAK = 17,
        yINVTYPE_CHEST = -24,
        yINVTYPE_ROBE = -24,
        yINVTYPE_BODY = -65,
        yINVTYPE_TABARD = -106,
        yINVTYPE_WRIST = -147,
        yINVTYPE_MAINHAND = -140,
        yINVTYPE_RANGED = -140,
        yINVTYPE_WEAPONMAINHAND = -140,
        yINVTYPE_2HWEAPON = -140,
        yINVTYPE_WEAPON = -140,
        yINVTYPE_RANGEDRIGHT = -140,
        yINVTYPE_HAND = 140,
        yINVTYPE_WAIST = 99,
        yINVTYPE_LEGS = 58,
        yINVTYPE_FEET = 17,
        yINVTYPE_FINGER = -24,
        yINVTYPE_FINGER1 = -65,
        yINVTYPE_TRINKET = -106,
        yINVTYPE_TRINKET1 = -147,
        yINVTYPE_SECONDARYHAND = -140,
        yINVTYPE_WEAPONOFFHAND = -140
    }

    local trinketAlreadyDone = false
    local fingerAlreadyDone = false
    local weaponAlreadyDone = false

    local arrayIlvl = {}

    for i = 1, 18 do
        local itemID = GetInventoryItemLink("target", i)
        if (itemID ~= nil and itemID ~= -1) then
            local itemScan = GearHelper:GetItemByLink(itemID, "GH_InspectFrame.InspectFrameShow()")
            local iR, itemLevel, itemEquipLoc = itemScan.rarity, itemScan.iLvl, itemScan.equipLoc

            iR = ((iR == "9d9d9d" and 0) or (iR == "ffffff" and 1) or (iR == "1eff00" and 2) or (iR == "0070dd" and 3) or (iR == "a335ee" and 4) or (iR == "ff8000" and 5) or (iR == "e6cc80" and 6) or (iR == "00ccff" and 7))

            if (itemEquipLoc ~= nil) then
                arrayIlvl[itemEquipLoc] = itemLevel

                local button
                if (itemEquipLoc == "INVTYPE_FINGER" and not fingerAlreadyDone) then
                    button = _G["charIlvlInspectButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_FINGER"])
                    fingerAlreadyDone = true
                elseif (itemEquipLoc == "INVTYPE_FINGER" and fingerAlreadyDone) then
                    button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_FINGER1"])
                elseif (itemEquipLoc == "INVTYPE_TRINKET" and not trinketAlreadyDone) then
                    button = _G["charIlvlButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_TRINKET"])
                    trinketAlreadyDone = true
                elseif (itemEquipLoc == "INVTYPE_TRINKET" and trinketAlreadyDone) then
                    button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["yINVTYPE_TRINKET1"])
                elseif (itemEquipLoc == "INVTYPE_WEAPON" and not weaponAlreadyDone) then
                    button = _G["charIlvlInspectButton" .. itemEquipLoc .. "0"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "0", InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["xINVTYPE_WEAPONMAINHAND"], arrayPos["yINVTYPE_WEAPONMAINHAND"])
                    weaponAlreadyDone = true
                elseif (itemEquipLoc == "INVTYPE_WEAPON" and weaponAlreadyDone) then
                    button = _G["charIlvlInspectButton" .. itemEquipLoc .. "1"] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc .. "1", InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["xINVTYPE_WEAPONOFFHAND"], arrayPos["yINVTYPE_WEAPONOFFHAND"])
                else
                    button = _G["charIlvlInspectButton" .. itemEquipLoc] or CreateFrame("Button", "charIlvlInspectButton" .. itemEquipLoc, InspectPaperDollItemsFrame)
                    button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", arrayPos["x" .. itemEquipLoc], arrayPos["y" .. itemEquipLoc])
                end
                button:SetSize(1, 1)
                button:SetText(itemLevel)
                button:SetNormalFontObject("GameFontNormalSmall")

                local font = _G["charIlvlInspectButton" .. itemEquipLoc .. itemID] or CreateFont("charIlvlInspectButton" .. itemEquipLoc .. itemID)
                local r, g, b = GetItemQualityColor(iR ~= nil and iR or 0)
                font:SetTextColor(r, g, b, 1)
                button:SetNormalFontObject(font)
                button:Show()
            end
        end
    end

    local ilvlAverage = 0
    local itemCount = 0
    table.foreach(
        arrayIlvl,
        function(equipLoc, ilvl)
            if (equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY") then
                ilvlAverage = ilvlAverage + ilvl
                itemCount = itemCount + 1
            end
        end
    )
    if (itemCount > 0) then
        local button = _G["ilvlAverageInspect"] or CreateFrame("Button", "ilvlAverageInspect", InspectPaperDollItemsFrame)
        button:SetPoint("CENTER", InspectPaperDollItemsFrame, "CENTER", 0, -110)

        button:SetSize(1, 1)
        button:SetText(L["ilvlInspect"] .. tostring(math.floor((ilvlAverage / itemCount) + .5)))
        button:SetNormalFontObject("GameFontNormalSmall")

        local font = ilvlAverageInspectFont or CreateFont("ilvlAverageInspectFont")
        local r, g, b = GetItemQualityColor(iR ~= nil and iR or 0)
        font:SetTextColor(1, 0.9, 0, 1)
        button:SetNormalFontObject(font)
    end
end

local function InspectFrameHide()
    GearHelper:BenchmarkCountFuncCall("InspectFrameHide")

    GearHelper:HideIlvlOnInspectFrame()
end

function GearHelper:AddIlvlOnInspectFrame()
    self:BenchmarkCountFuncCall("GearHelper:AddIlvlOnInspectFrame")

    InspectPaperDollItemsFrame:HookScript("OnShow", InspectFrameShow)
    InspectPaperDollItemsFrame:HookScript("OnHide", InspectFrameHide)
end

function GearHelper:HideIlvlOnInspectFrame()
    self:BenchmarkCountFuncCall("GearHelper:HideIlvlOnInspectFrame")

    table.foreach(
        self.db.global.equipLocInspect,
        function(equipLoc, _)
            if (_G["charIlvlInspectButton" .. equipLoc]) then
                _G["charIlvlInspectButton" .. equipLoc]:Hide()
                _G["charIlvlInspectButton" .. equipLoc] = nil
            end
            if (_G["ilvlAverageInspect"]) then
                _G["ilvlAverageInspect"]:Hide()
                _G["ilvlAverageInspect"] = nil
            end
        end
    )
end
