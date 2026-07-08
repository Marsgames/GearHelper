GHEvents = {}
GHEvents.__index = GHEvents

local lfrCheckIsChecked = false
local waitSpeFrame = CreateFrame("Frame")

waitSpeFrame:Hide()

function GHEvents:RegisterEvents()
    GearHelper:RegisterEvent("BAG_UPDATE", self.BAG_UPDATE)
    GearHelper:RegisterEvent("BAG_UPDATE_DELAYED", self.BAG_UPDATE_DELAYED)
    GearHelper:RegisterEvent("CHAT_MSG_LOOT", self.CHAT_MSG_LOOT)
    GearHelper:RegisterEvent("MERCHANT_CLOSED", self.MERCHANT_CLOSED)
    GearHelper:RegisterEvent("MERCHANT_SHOW", self.MERCHANT_SHOW)
    GearHelper:RegisterEvent("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD)
    -- GearHelper:RegisterEvent("QUEST_COMPLETE", self.QUEST_COMPLETE)
    -- GearHelper:RegisterEvent("QUEST_DETAIL", self.QUEST_DETAIL)
    -- GearHelper:RegisterEvent("QUEST_TURNED_IN", self.QUEST_TURNED_IN)
    GearHelper:RegisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
    GearHelper:RegisterEvent("BAG_UPDATE_COOLDOWN", self.BAG_UPDATE_COOLDOWN)

    -- GearHelper:RegisterEvent("ADDON_ACTION_BLOCKED", self.ADDON_ACTION_BLOCKED)
    -- GearHelper:RegisterEvent("ADDON_ACTION_FORBIDDEN", self.ADDON_ACTION_FORBIDDEN)
end

function GHEvents:UnregisterEvents()
    GearHelper:UnregisterEvent("BAG_UPDATE", self.BAG_UPDATE)
    GearHelper:UnregisterEvent("BAG_UPDATE_DELAYED", self.BAG_UPDATE_DELAYED)
    GearHelper:UnregisterEvent("CHAT_MSG_LOOT", self.CHAT_MSG_LOOT)
    GearHelper:UnregisterEvent("MERCHANT_CLOSED", self.MERCHANT_CLOSED)
    GearHelper:UnregisterEvent("MERCHANT_SHOW", self.ON_MERCHANT_SHOW)
    GearHelper:UnregisterEvent("PLAYER_ENTERING_WORLD", self.PLAYER_ENTERING_WORLD)
    -- GearHelper:UnregisterEvent("QUEST_COMPLETE", self.QUEST_COMPLETE)
    -- GearHelper:UnregisterEvent("QUEST_DETAIL", self.QUEST_DETAIL)
    -- GearHelper:UnregisterEvent("QUEST_TURNED_IN", self.QUEST_TURNED_IN)
    GearHelper:UnregisterEvent("UNIT_INVENTORY_CHANGED", self.UNIT_INVENTORY_CHANGED)
    GearHelper:UnregisterEvent("BAG_UPDATE_COOLDOWN", self.BAG_UPDATE_COOLDOWN)
end
