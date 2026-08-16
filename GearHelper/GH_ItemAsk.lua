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
    local itemLink = itemTable["itemLink"] ~= "" and itemTable["itemLink"] or link
    local lienPerso = tostring(GHToolbox:GetClassColor(classFile)) .. tostring(sendTo) .. "|r"

    -- Résoudre la locale avant la popup pour déclencher l'unpacking de LibRealmInfo
    -- maintenant plutôt qu'au moment du clic sur "Oui"
    local LibRealmInfo = LibStub:GetLibrary("LibRealmInfo")
    local _, _, _, _, unitLocale = LibRealmInfo:GetRealmInfoByUnit(sendTo)
    if unitLocale == nil then
        unitLocale = "enUS"
    end

    StaticPopupDialogs["AskIfHeNeed"] = {
        text = GearHelper.locals["demande1"] .. lienPerso .. GearHelper.locals["demande2"] .. itemLink .. " ?",
        button1 = GearHelper.locals["yes"],
        button2 = GearHelper.locals["no"],
        OnAccept = function(GearHelper2, data, data2)
            local theSource = GearHelper.db.global.messages[unitLocale].demande4 or GearHelper.locals["demande4enUS"]
            local theSource2 = GearHelper.db.global.messages[unitLocale].demande42 or GearHelper.locals["demande4enUS2"]
            local msg = theSource .. itemLink .. theSource2 .. "?"
            local rep = GearHelper.db.global.messages[unitLocale].rep or GearHelper.locals["repenUS"]
            local rep2 = GearHelper.db.global.messages[unitLocale].rep2 or ""
            local msgRep = rep .. GearHelper.locals["maLangue" .. unitLocale] .. rep2

            SendChatMessage(msg, "WHISPER", nil, sendTo)
            SendChatMessage(msgRep, "WHISPER", nil, sendTo)
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

    if debug ~= 1 then
        if not self.db.profile.askLootRaid or not IsTargetValid(target) or string.find(string.lower(message), "bonus") then
            return
        end
    end

    local _, classFile = UnitClass(target)
    local tar = ""

    if classFile ~= nil then
        tar = GHToolbox:GetClassColor(classFile) .. tostring(target) .. "|r"
    end

    local OldSetItemRef = SetItemRef
    function SetItemRef(link, text, button, chatFrame)
        local func = strmatch(link, "^GHWhispWhenClick:(%a+)")
        if func == "askIfHeNeed" then
            local _, nomPerso, itID, persoLink = strsplit("_", link)
            local _, theItemLink = C_Item.GetItemInfo(itID)
            -- Fallback sur le link brut si l'item n'est pas en cache
            local itemTable = GHItem:Create(theItemLink)
            local itLink1 = itemTable.itemLink ~= "" and itemTable.itemLink or theItemLink or link

            AskIfHeNeed(itLink1, nomPerso)
        else
            OldSetItemRef(link, text, button, chatFrame)
        end
    end

    for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
        local item = GHItem:Create(itemLink)
        -- En mode debug : bypass IsItemBetter pour tester le flow complet
        if debug == 1 or (not item.isEmpty and self:IsItemBetter(item)) then
            local nameLink = GHToolbox:ReturnGoodLink(itemLink, target, tar)
            UIErrorsFrame:AddMessage(GHToolbox:ColorizeString(self.locals["ask1"], "Yellow") .. nameLink .. GHToolbox:ColorizeString(self.locals["ask2"], "Yellow") .. itemLink, 0.0, 1.0, 0.0)
            print(GHToolbox:ColorizeString(self.locals["ask1"], "Yellow") .. nameLink .. GHToolbox:ColorizeString(self.locals["ask2"], "Yellow") .. itemLink)
            PlaySound(5274, "Master")
        end
    end
end
