-- https://mothereff.in/lua-minifier
-- Memory footprint 12048.4 k
-- TODO extract player inventory related function to an independant lib
-- TODO check war item SetHyperlink in tooltip fail
-- TODO Expose more options to player
-- TODO: Repair GH :
--			- La prise en compte des châsses ne semble pas changer grand chose

-- #errors : 01

--{{ Global Vars }}
GearHelperVars = {
    version = GetAddOnMetadata("GearHelper", "Version"),
    prefixAddon = "GeARHeLPeRPReFIX",
    addonTruncatedVersion = 2,
    waitSpeTimer = nil,
    charInventory = {}
}

--{{ Local Vars }}
local allPrefix = {["askVersion" .. GearHelperVars.prefixAddon] = GearHelper.SendAnswerVersion, ["answerVersion" .. GearHelperVars.prefixAddon] = GearHelper.ReceiveAnswer}
local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local tooltipProcessed = {} -- this variable is used to save tooltip lines add by gearhelper, to avoid computation each frame
local delayNilTimer = 10
local waitNilFrame = CreateFrame("Frame")
local waitNilTimer = nil
local defaultsOptions = {
    profile = {
        addonEnabled = true,
        sellGreyItems = true,
        autoAcceptQuestReward = false,
        autoEquipLooted = {
            actual = false,
            previous = false
        },
        autoEquipWhenSwitchSpe = false,
        weightTemplate = "NOX",
        lastWeightTemplate = "",
        autoRepair = 0,
        autoInvite = true,
        autoTell = true,
        inviteMessage = "+GH123-",
        askLootRaid = true,
        printWhenEquip = true,
        debug = false,
        CW = {},
        iLvlOption = false,
        iLvlWeight = 10,
        includeSocketInCompute = true,
        computeNotEquippable = true,
        whisperAlert = true,
        sayMyName = true,
        minimap = {hide = false, isLock = false},
        bossesKilled = true,
        ilvlCharFrame = true,
        ilvlInspectFrame = true,
        inspectAin = {waitingIlvl = false, equipLoc = nil, ilvl = nil, linkItemReceived = nil, message = nil, target = nil},
        defaultWeightForStat = 1
    },
    global = {
        ItemCache = {},
        itemWaitList = {},
        myNames = "",
        buildVersion = 7,
        equipLocInspect = {},
        phrases = {}
    }
}
waitNilFrame:Hide()

function GearHelper:OnInitialize()
    GearHelper:BenchmarkCountFuncCall("GearHelper:OnInitialize")
    self.db = LibStub("AceDB-3.0"):New("GearHelperDB", defaultsOptions)
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "ResetConfig")
    self.LFG_UPDATE = GearHelper.UpdateGHLfrButton

    GearHelper:CreateMinimapIcon()
end

function GearHelper:RefreshConfig()
    GearHelper:BenchmarkCountFuncCall("GearHelper:RefreshConfig")
    InterfaceOptionsFrame:Show()
    InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:NilTableValues(tableToReset)
    GearHelper:BenchmarkCountFuncCall("GearHelper:NilTableValues")
    for key, v in pairs(tableToReset) do
        if type(tableToReset[key]) == "table" then
            GearHelper:NilTableValues(tableToReset[key])
        else
            tableToReset[key] = nil
        end
    end
end

local function InitEquipLocInspect()
    GearHelper:BenchmarkCountFuncCall("InitEquipLocInspect")
    GearHelper.db.global.equipLocInspect["INVTYPE_HEAD"] = 1
    GearHelper.db.global.equipLocInspect["INVTYPE_NECK"] = 2
    GearHelper.db.global.equipLocInspect["INVTYPE_SHOULDER"] = 3
    GearHelper.db.global.equipLocInspect["INVTYPE_BACK"] = 15
    GearHelper.db.global.equipLocInspect["INVTYPE_CLOAK"] = 15
    GearHelper.db.global.equipLocInspect["INVTYPE_CHEST"] = 5
    GearHelper.db.global.equipLocInspect["INVTYPE_ROBE"] = 5
    GearHelper.db.global.equipLocInspect["INVTYPE_BODY"] = 4
    GearHelper.db.global.equipLocInspect["INVTYPE_TABARD"] = 19
    GearHelper.db.global.equipLocInspect["INVTYPE_WRIST"] = 9
    GearHelper.db.global.equipLocInspect["INVTYPE_MAINHAND"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_RANGED"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_WEAPONMAINHAND"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_2HWEAPON"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_WEAPON"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_WEAPON0"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_WEAPON1"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_RANGEDRIGHT"] = 16
    GearHelper.db.global.equipLocInspect["INVTYPE_HAND"] = 10
    GearHelper.db.global.equipLocInspect["INVTYPE_WAIST"] = 6
    GearHelper.db.global.equipLocInspect["INVTYPE_LEGS"] = 7
    GearHelper.db.global.equipLocInspect["INVTYPE_FEET"] = 8
    GearHelper.db.global.equipLocInspect["INVTYPE_FINGER"] = 11
    GearHelper.db.global.equipLocInspect["INVTYPE_FINGER0"] = 11
    GearHelper.db.global.equipLocInspect["INVTYPE_FINGER1"] = 12
    GearHelper.db.global.equipLocInspect["INVTYPE_TRINKET"] = 13
    GearHelper.db.global.equipLocInspect["INVTYPE_TRINKET0"] = 13
    GearHelper.db.global.equipLocInspect["INVTYPE_TRINKET1"] = 14
    GearHelper.db.global.equipLocInspect["INVTYPE_SECONDARYHAND"] = 17
    GearHelper.db.global.equipLocInspect["INVTYPE_WEAPONOFFHAND"] = 17
end

function GearHelper:ResetConfig()
    self:BenchmarkCountFuncCall("GearHelper:ResetConfig")
    Gearhelper:NilTableValues(self.db.profile)
    Gearhelper:NilTableValues(self.db.global)

    InterfaceOptionsFrame:Hide()
    InterfaceOptionsFrame:Show()
    InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
end

function GearHelper:OnEnable()
    self:BenchmarkCountFuncCall("GearHelper:OnEnable")
    if not self.db.profile.addonEnabled then
        print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["DeactivatedRed"], "LightRed"))
        return
    end

    print(self:ColorizeString(L["Addon"], "LightGreen") .. self:ColorizeString(L["ActivatedGreen"], "LightGreen"))
    self.cwTable.args["NoxGroup"].name = "Noxxic " .. (GetSpecialization() and select(2, GetSpecializationInfo(GetSpecialization())) or "None")
    if (0 == self:GetArraySize(self.db.global.equipLocInspect)) then
        InitEquipLocInspect()
    end
    if (0 == self:GetArraySize(self.db.global.phrases)) then
        self.db.global.phrases.enUS = {}
        self.db.global.phrases.enUS["demande4"] = L["demande4enUS"]
        self.db.global.phrases.enUS["demande42"] = L["demande4enUS2"]
        self.db.global.phrases.enUS["rep"] = L["repenUS"]
        self.db.global.phrases.enUS["rep2"] = L["repenUS2"]

        self.db.global.phrases.frFR = {}
        self.db.global.phrases.frFR.demande4 = L["demande4frFR"]
        self.db.global.phrases.frFR.demande42 = L["demande4frFR2"]
        self.db.global.phrases.frFR.rep = L["repfrFR"]
        self.db.global.phrases.frFR.rep2 = L["repfrFR2"]

        self.db.global.phrases.deDE = {}
        self.db.global.phrases.deDE.demande4 = L["demande4deDE"]
        self.db.global.phrases.deDE.demande42 = L["demande4deDE2"]
        self.db.global.phrases.deDE.rep = L["repdeDE"]
        self.db.global.phrases.deDE.rep2 = L["repdeDE2"]

        self.db.global.phrases.esES = {}
        self.db.global.phrases.esES.demande4 = L["demande4esES"]
        self.db.global.phrases.esES.demande42 = L["demande4esES2"]
        self.db.global.phrases.esES.rep = L["repesES"]
        self.db.global.phrases.esES.rep2 = L["repesES2"]

        self.db.global.phrases.esMX = {}
        self.db.global.phrases.esMX.demande4 = L["demande4esMX"]
        self.db.global.phrases.esMX.demande42 = L["demande4esMX2"]
        self.db.global.phrases.esMX.rep = L["repesMX"]
        self.db.global.phrases.esMX.rep2 = L["repesMX2"]

        self.db.global.phrases.itIT = {}
        self.db.global.phrases.itIT.demande4 = L["demande4itIT"]
        self.db.global.phrases.itIT.demande42 = L["demande4itIT2"]
        self.db.global.phrases.itIT.rep = L["repitIT"]
        self.db.global.phrases.itIT.rep2 = L["repitIT2"]

        self.db.global.phrases.koKR = {}
        self.db.global.phrases.koKR.demande4 = L["demande4koKR"]
        self.db.global.phrases.koKR.demande42 = L["demande4koKR2"]
        self.db.global.phrases.koKR.rep = L["repkoKR"]
        self.db.global.phrases.koKR.rep2 = L["repkoKR2"]

        self.db.global.phrases.ptBR = {}
        self.db.global.phrases.ptBR.demande4 = L["demande4ptBR"]
        self.db.global.phrases.ptBR.demande42 = L["demande4ptBR2"]
        self.db.global.phrases.ptBR.rep = L["repptBR"]
        self.db.global.phrases.ptBR.rep2 = L["repptBR2"]

        self.db.global.phrases.ruRU = {}
        self.db.global.phrases.ruRU.demande4 = L["demande4ruRU"]
        self.db.global.phrases.ruRU.demande42 = L["demande4ruRU2"]
        self.db.global.phrases.ruRU.rep = L["repruRU"]
        self.db.global.phrases.ruRU.rep2 = L["repruRU2"]

        self.db.global.phrases.zhCN = {}
        self.db.global.phrases.zhCN.demande4 = L["demande4zhCN"]
        self.db.global.phrases.zhCN.demande42 = L["demande4zhCN2"]
        self.db.global.phrases.zhCN.rep = L["repzhCN"]
        self.db.global.phrases.zhCN.rep2 = L["repzhCN2"]

        self.db.global.phrases.zhTW = {}
        self.db.global.phrases.zhTW.demande4 = L["demande4zhTW"]
        self.db.global.phrases.zhTW.demande42 = L["demande4zhTW2"]
        self.db.global.phrases.zhTW.rep = L["repzhTW"]
        self.db.global.phrases.zhTW.rep2 = L["repzhTW2"]
    end

    GearHelper:CheckCacheDate()
end

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
            UIErrorsFrame:AddMessage(channel .. " [" .. sender .. "]: " .. msg, 0.0, 1.0, 0.0, 5.0, 4)
            PlaySound(5275, "Master")
            stop = true
            return
        end
        i = i + 1
    end
end

-- TODO: Still useful ?
local function delayNilFrame(frame)
    GearHelper:BenchmarkCountFuncCall("delayNilFrame")
    if time() <= waitNilTimer + delayNilTimer then
        do
            return
        end
    end
    self.db = nil
    ReloadUI()
    frame:Hide()
end
waitNilFrame:SetScript("OnUpdate", delayNilFrame)

function GearHelper:GetEquippedItemLink(slotID, slotName)
    self:BenchmarkCountFuncCall("GearHelper:GetEquippedItemLink")
    local itemLink = GetInventoryItemLink("player", slotID)
    local itemID = GetInventoryItemID("player", slotID)
    local itemName

    if not itemID then
        return 0
    end

    if itemLink then
        _, itemName = itemLink:match("|H(.*)|h%[(.*)%]|h")
    end

    if not itemName or itemName == "" then
        GetItemInfo(itemID)
        self.db.global.itemWaitList[itemID] = slotName
        return -2
    else
        return itemLink
    end
end

function GearHelper:ScanCharacter()
    self:BenchmarkCountFuncCall("GearHelper:ScanCharacter")

    local function scanCoroutine()
        GearHelperVars.charInventory["Head"] = self:GetEquippedItemLink(GetInventorySlotInfo("HeadSlot"), "HeadSlot")
        GearHelperVars.charInventory["Neck"] = self:GetEquippedItemLink(GetInventorySlotInfo("NeckSlot"), "NeckSlot")
        GearHelperVars.charInventory["Shoulder"] = self:GetEquippedItemLink(GetInventorySlotInfo("ShoulderSlot"), "ShoulderSlot")
        GearHelperVars.charInventory["Back"] = self:GetEquippedItemLink(GetInventorySlotInfo("BackSlot"), "BackSlot")
        GearHelperVars.charInventory["Chest"] = self:GetEquippedItemLink(GetInventorySlotInfo("ChestSlot"), "ChestSlot")
        GearHelperVars.charInventory["Wrist"] = self:GetEquippedItemLink(GetInventorySlotInfo("WristSlot"), "WristSlot")
        GearHelperVars.charInventory["Hands"] = self:GetEquippedItemLink(GetInventorySlotInfo("HandsSlot"), "HandsSlot")
        GearHelperVars.charInventory["Waist"] = self:GetEquippedItemLink(GetInventorySlotInfo("WaistSlot"), "WaistSlot")
        GearHelperVars.charInventory["Legs"] = self:GetEquippedItemLink(GetInventorySlotInfo("LegsSlot"), "LegsSlot")
        GearHelperVars.charInventory["Feet"] = self:GetEquippedItemLink(GetInventorySlotInfo("FeetSlot"), "FeetSlot")
        GearHelperVars.charInventory["Finger0"] = self:GetEquippedItemLink(GetInventorySlotInfo("Finger0Slot"), "Finger0Slot")
        GearHelperVars.charInventory["Finger1"] = self:GetEquippedItemLink(GetInventorySlotInfo("Finger1Slot"), "Finger1Slot")
        GearHelperVars.charInventory["Trinket0"] = self:GetEquippedItemLink(GetInventorySlotInfo("Trinket0Slot"), "Trinket0Slot")
        GearHelperVars.charInventory["Trinket1"] = self:GetEquippedItemLink(GetInventorySlotInfo("Trinket1Slot"), "Trinket1Slot")
        GearHelperVars.charInventory["MainHand"] = self:GetEquippedItemLink(GetInventorySlotInfo("MainHandSlot"), "MainHandSlot")
        GearHelperVars.charInventory["SecondaryHand"] = self:GetEquippedItemLink(GetInventorySlotInfo("SecondaryHandSlot"), "SecondaryHandSlot")

        if GearHelperVars.charInventory["MainHand"] ~= -2 and GearHelperVars.charInventory["MainHand"] ~= 0 then
            -- TODO: Why doesn't we use GH:GetItemInfo ?
            local _, _, _, itemEquipLocWeapon = GetItemInfoInstant(GearHelperVars.charInventory["MainHand"])

            if string.match(itemEquipLocWeapon, "INVTYPE_2HWEAPON") or string.match(itemEquipLocWeapon, "INVTYPE_RANGED") then
                GearHelperVars.charInventory["SecondaryHand"] = -1
            end
        end
    end

    coroutine.resume(coroutine.create(scanCoroutine))
end

function GearHelper:SetDotOnIcons()
    self:BenchmarkCountFuncCall("GearHelper:SetDotOnIcons")

    -- local bag = 0
    -- local slot = 2
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local myBag = bag + 1
            local mySlot = GetContainerNumSlots(bag) - (slot - 1)
            local button = _G["ContainerFrame" .. myBag .. "Item" .. mySlot]
            local itemLink = GetContainerItemLink(bag, slot)

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

local ModifyTooltip = function(self, ...)
    -- local pCallWorked, err = pcall(anyFunction) 	-- if no error : pCallWorked == true and err == nil
    --												-- if error : pCallWorked == false and err == "some error"
    if not GearHelper.db or not GearHelper.db.profile.addonEnabled then
        return
    end

    local name, itemLink = self:GetItem()

    -- Do not redo all the tooltip processing if we already did it
    if tooltipProcessed[name] then
        self = tooltipProcessed[name]
        local lines = tooltipProcessed["lines" .. name]

        if lines then
            for _, v in pairs(lines) do
                self:AddLine(v)
            end
        end

        do
            return
        end
    end

    -- TODO: Improve backdrop to restore old one (without the frame border)
    if not self.Backdrop then
        self.Backdrop = CreateFrame("Frame", "GHGameTooltipBackdrop", self, "BackdropTemplate")
        self.Backdrop:SetAllPoints()
        self.Backdrop.backdropInfo = {
            -- bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32
            -- insets = {left = 11, right = 12, top = 12, bottom = 9}
        }
        self.Backdrop:SetBackdrop(self.Backdrop.backdropInfo)
        self.Backdrop:ApplyBackdrop()
    end

    -- Do not ask me why, but itemLink is the 2nd parameter IN __THIS__ CASE
    -- Something to do with the difference between GearHelper:Sommething() and GearHelper.Something
    -- https://stackoverflow.com/questions/29047541/how-to-pass-arguments-to-a-function-within-a-table (find the solution after this (non related ?) "solution")
    local shouldBeCompared, err = pcall(GearHelper.ShouldBeCompared, nil, itemLink)

    local linesToAdd = {}
    local isItemEquipped = IsEquippedItem(itemLink)

    if (not isItemEquipped) then
        if (not shouldBeCompared) then
            if (string.find(tostring(err), GHExceptionNotEquippable)) then
                -- Show message only on equippable items
                local item = GearHelper:GetItemByLink(itemLink, "GearHelper.ModifyTooltip 1")

                -- print("subtype : " .. tostring(item.subType))
                if (IsEquippableItem(itemLink) and ShouldDisplayNotEquippable(tostring(item.subType))) then
                    table.insert(linesToAdd, GearHelper:ColorizeString(L["itemNotEquippable"], "LightRed"))
                    self.Backdrop:SetBackdropBorderColor(255, 0, 0, 255)
                else
                    self.Backdrop:SetBackdrop(nil)
                    self.Backdrop = nil
                end
            end
        else
            -- end
            local item = GearHelper:GetItemByLink(itemLink, "GearHelper.ModifyTooltip 2")
            local weightCalcGotResult, result = pcall(GearHelper.NewWeightCalculation, GearHelper, item)

            -- N'est pas censé arriver
            if (not weightCalcGotResult) then
                error(result)
            end

            if (type(result) == "table") then
                for _, v in pairs(result) do
                    local floorValue = math.floor(v)

                    if (floorValue < 0) then
                        self.Backdrop:SetBackdropBorderColor(255, 0, 0, 255)
                    else
                        self.Backdrop:SetBackdropBorderColor(0, 255, 150, 255)
                    end
                end
            else
                -- Got an error with warlock when showing tooltip of left hand Illidan's Warglaive of Azzinoth
                -- print("result : " .. tostring(result))
                -- self.Backdrop:SetBackdrop(nil)
                -- self.Backdrop = nil
            end
            linesToAdd = GearHelper:LinesToAddToTooltip(result)
        end
    else
        self.Backdrop:SetBackdropBorderColor(255, 255, 0)
        table.insert(linesToAdd, GearHelper:ColorizeString(L["itemEquipped"], "Yellow"))
    end

    -- Add droprate to tooltip
    GearHelper:GetDropInfo(linesToAdd, itemLink)

    if linesToAdd then
        for _, v in pairs(linesToAdd) do
            self:AddLine(v)
        end
    end

    if name then
        tooltipProcessed[name] = self
        tooltipProcessed["lines" .. name] = linesToAdd
    end
end

for _, obj in next, {
    GameTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2,
    ShoppingTooltip3,
    ItemRefTooltip
} do
    obj:HookScript("OnTooltipSetItem", ModifyTooltip)
    obj:HookScript(
        "OnHide",
        function()
            if obj.Backdrop then
                obj.Backdrop:SetBackdrop(nil)
                obj.Backdrop = nil
            end
            tooltipProcessed = {}
        end
    )
end

GameTooltip:HookScript(
    "OnTooltipAddMoney",
    function(self, amount)
        local _, itemLink = self:GetItem()
        if GearHelper.db.global.ItemCache[itemLink] and not GearHelper.db.global.ItemCache[itemLink].sellPrice then
            GearHelper.db.global.ItemCache[itemLink].sellPrice = amount
        end
    end
)
