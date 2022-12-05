local L = LibStub("AceLocale-3.0"):GetLocale("GearHelper")

local function IsTargetValid(target)
    if nil == target or "" == target or string.find(target, GetUnitName("player")) then
        return false
    end

    return true
end

local function AskIfHeNeed(link, sendTo)
    local className, classFile, classID = UnitClass(sendTo)
    local itemTable = GHItem:Create(link)
    local itemLink = itemTable["itemLink"]
    local lienPerso = tostring(GearHelper:GetClassColor(classFile)) .. tostring(sendTo) .. "|r"
    StaticPopupDialogs["AskIfHeNeed"] = {
        text = GearHelper.locals["demande1"] .. lienPerso .. GearHelper.locals["demande2"] .. itemLink .. " ?",
        button1 = GearHelper.locals["yes"],
        button2 = GearHelper.locals["no"],
        OnAccept = function(GearHelper2, data, data2)
            local LibRealmInfo = LibStub:GetLibrary("LibRealmInfo")
            local _, _, _, _, unitLocale = LibRealmInfo:GetRealmInfoByUnit(sendTo)
            if unitLocale == nil then
                unitLocale = "enUS"
            end

            local theSource = GearHelper.db.global.messages[unitLocale].demande4 or GearHelper.locals["demande4enUS"]
            local theSource2 = GearHelper.db.global.messages[unitLocale].demande42 or GearHelper.locals["demande4enUS2"]
            local msg = theSource .. itemLink .. theSource2 .. "?"
            local rep = GearHelper.db.global.messages[unitLocale].rep or GearHelper.locals["repenUS"]
            local rep2 = GearHelper.db.global.messages[unitLocale].rep2 or ""
            local msgRep = rep .. GearHelper.locals["maLangue" .. unitLocale] .. rep2

            SendChatMessage(msg, "WHISPER", "Common", sendTo)
            SendChatMessage(msgRep, "WHISPER", "Common", sendTo)
            StaticPopup_Hide("AskIfHeNeed")
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3 -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }
    StaticPopup_Show("AskIfHeNeed")
end

function GearHelper:CreateLinkAskIfHeNeeds(debug, message, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter)
    -- local message = message or "|cffff8000|Hitem:13262::::::::100:105::::::|h[Porte-cendres ma Gueule]|h|r"
    local message = message or "|cffff8000|Hitem:19019::::::::120:::::::|h[Thunderfury ma Gueule]|h|r"
    -- local message = message or "|cffff8000|Hitem:30212::::::::120:::::::|h[Zeub zeub]|h|r"
    local target = target or GetUnitName("player")

    if (debug ~= 1) then
        if not self.db.profile.askLootRaid or not IsTargetValid(target) or string.find(string.lower(message), "bonus") then
            return
        end
    end

    local couleur, tar = ""
    local _, classFile = UnitClass(target)
    local tar = ""

    if classFile ~= nil then
        tar = self:GetClassColor(classFile) .. tostring(target) .. "|r"
    end

    local nameLink

    local OldSetItemRef = SetItemRef
    if (debug == 1) then
        AskIfHeNeed(message, target)
    end
    function SetItemRef(link, text, button, chatFrame)
        local func = strmatch(link, "^GHWhispWhenClick:(%a+)")
        if func == "askIfHeNeed" then
            local _, nomPerso, itID, persoLink = strsplit("_", link)
            local _, theItemLink = GetItemInfo(itID)
            local itemTable = GHItem:Create(theItemLink)
            local itLink1 = itemTable.itemLink

            AskIfHeNeed(itLink1, nomPerso)
        else
            OldSetItemRef(link, text, button, chatFrame)
        end
    end

    for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
        local shouldBeCompared, err = pcall(self.ShouldBeCompared, nil, itemLink)
        if (shouldBeCompared) then
            local item = GHItem:Create(itemLink)
            local quality = GearHelper:GetQualityFromColor(item.rarity)

            if quality ~= nil and quality < 5 then
                nameLink = self:ReturnGoodLink(itemLink, target, tar)
                local item = GHItem:Create(itemLink)
                local isItemBetter = self:IsItemBetter(item)
                if (isItemBetter) then
                    UIErrorsFrame:AddMessage(self:ColorizeString(self.locals["ask1"], "Yellow") .. nameLink .. self:ColorizeString(self.locals["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0)
                    print(self:ColorizeString(self.locals["ask1"], "Yellow") .. nameLink .. self:ColorizeString(self.locals["ask2"], "Yellow") .. itemLink)
                    PlaySound(5274, "Master")
                end
            end
        end
    end
end
