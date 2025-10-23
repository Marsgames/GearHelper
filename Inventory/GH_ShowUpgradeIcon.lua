-- _G["ContainerFrame1"] dump:
--[[
"0, userdata: 0xdde1c8548"
"Background1Slot, table: 0x770c69ee0"
"UpdateBackground, function: 0xdf287d7f0"
"UpdateFilterIcon, function: 0xdf2887a00"
"GetTitleText, function: 0xd34544b70"
"GetPaddingWidth, function: 0xdf287d978"
"SetPortraitTexCoord, function: 0xd34544ef0"
"ClearItems, function: 0xdf287db38"
"CheckUpdateDynamicContents, function: 0xdf287d860"
"UpdateIfShown, function: 0xdf287dda0"
"GetBagID, function: 0xdf287d5c0"
"TitleContainer, table: 0x770c69c10"
"UpdateItemContextMatching, function: 0xdf287de10"
"LayoutAddSlots, function: 0xdf2887e00"
"SetTitle, function: 0xd34544ba8"
"OnCloseClicked, function: 0xdf287d518"
"UpdateCurrencyFrames, function: 0xdf28d1488"
"GetInitialItemAnchor, function: 0xdf28d1530"
"CalculateHeight, function: 0xdf2887900"
"IsCombinedBagContainer, function: 0xdf287d1d0"
"SetFrameLevelsFromBaseLevel, function: 0xd3442dfa0"
"SetPortraitAtlasRaw, function: 0xd34544e48"
"CancelRefresh, function: 0xdf287dcc0"
"MatchesBagID, function: 0xdf287d630"
"UpdateAddSlots, function: 0xdf28d1290"
"IsExtended, function: 0xdf2887780"
"SetTitleFormatted, function: 0xd34544c18"
"UpdateItemSlots, function: 0xdf2887980"
"CalculateWidth, function: 0xdf28878c0"
"SetPortraitTextureSizeAndOffset, function: 0xd34544f60"
"Items, table: 0x770c92b80"
"OnTokenWatchChanged, function: 0xdf28d13a8"
"GetBackgroundColor, function: 0xdf287d7b8"
"GetRows, function: 0xdf287d710"
"AddItemsForRefresh, function: 0xdf287dcf8"
"SetPortraitShown, function: 0xd34544f28"
"AcquireNewItemButton, function: 0xdf287db00"
"GetExtraRows, function: 0xdf2887880"
"OnShow, function: 0xdf28d1338"
"MoneyFrame, table: 0x770c90240"
"EnumerateValidItems, function: 0xdf28877c0"
"FilterIcon, table: 0x770c90150"
"SetPortraitTextureRaw, function: 0xd34544e10"
"PortraitButton, table: 0x770c69f30"
"GetBagSize, function: 0xdf287d128"
"CalculateExtraHeight, function: 0xdf28d15a0"
"CloseButton, table: 0x770c69e40"
"Bg, table: 0x770c69cb0"
"UpdateMoneyFrame, function: 0xdf287d550"
"SetTitleMaxLinesAndHeight, function: 0xd34544c88"
"SetTitleColor, function: 0xd34544be0"
"NineSlice, table: 0x770c69300"
"UpdateItems, function: 0xdf287dd68"
"UpdateSearchResults, function: 0xdf287d2e8"
"SetTokenTracker, function: 0xdf28d13e0"
"EnumerateItems, function: 0xdf287d240"
"SetBackgroundColor, function: 0xd34545008"
"GetPaddingHeight, function: 0xdf28d1568"
"itemButtonPool, table: 0x770c92860"
"UpdateFrameSize, function: 0xdf287d9b0"
"GetFirstButtonOffsetY, function: 0xdf287d6a0"
"UpdateTokenTracker, function: 0xdf28d1418"
"onCloseCallback, function: 0xdf287d4e0"
"SetBorder, function: 0xd34544d30"
"layoutType, HeldBagLayout"
"GetContainedBagIDs, function: 0xdf287d5f8"
"CloseTutorial, function: 0xdf287dc88"
"CanUseForBagID, function: 0xdf28d14f8"
"SetPortraitToBag, function: 0xd34544dd8"
"PortraitContainer, table: 0x770c69b20"
"SetPortraitToUnit, function: 0xd34544da0"
"IsBackpack, function: 0xdf28d14c0"
"SetBagSize, function: 0xdf287d198"
"SetPortraitToClassIcon, function: 0xd34544e80"
"GetPortrait, function: 0xd34544cf8"
"UpdateMiscellaneousFrames, function: 0xdf28d15d8"
"IsPlusTwoBag, function: 0xdf287d748"
"GetAnchorLayout, function: 0x770c68c20"
"OnHide, function: 0xdf28d1370"
"SetPortraitToSpecIcon, function: 0xd34544eb8"
"SetPortraitToAsset, function: 0xd34544d68"
"GetColumns, function: 0xdf287d6d8"
"UpdateSearchBox, function: 0xdf287dc50"
"SetSearchBoxPoint, function: 0xdf287dc18"
"UpdateItemLayout, function: 0xdf28879c0"
"UpdateName, function: 0xdf287d780"
"SetBagID, function: 0xdf287d588"
"SetTitleOffsets, function: 0xd34544cc0"
"Update, function: 0xdf287dd30"
"UpdateCooldowns, function: 0xdf287ddd8"
]]
local function GetNameOrID(frame)
    if frame.GetName and frame:GetName() then
        return frame:GetName()
    elseif frame.GetID and frame:GetID() then
        return frame:GetID()
    end
end

--- Add an upgrade icon overlay to a frame
--- @param frame Frame The frame to add the icon to
--- @param suffix string|nil An optional suffix to identify the frame
--- @return Frame The created overlay frame
local function AddIconTo(frame, suffix)
    if not frame then
        print("No frame provided to add icon")
        return
    end
    if frame.GearHelperOverlay then
        return
    end

    if frame.GetName then
        suffix = suffix or tostring(frame:GetName())
    elseif frame.GetID then
        suffix = suffix or tostring(frame:GetID())
    end

    if suffix == nil or suffix == "nil" then
        print("An error occured while trying to add an icon to a frame")
    end

    local localFrame = CreateFrame("Frame", "GearHelperOverlay_" .. suffix, frame)
    frame.GearHelperOverlay = localFrame
    -- Get the frame to match the shape/size of its parent
    localFrame:SetAllPoints()

    -- Create the texture frame.
    localFrame.GearHelperIconTexture = localFrame:CreateTexture("GearHelperTextureFrame", "OVERLAY")
    localFrame.GearHelperIconTexture:SetWidth(18)
    localFrame.GearHelperIconTexture:SetHeight(18)
    localFrame.GearHelperIconTexture:SetPoint("TOPLEFT")
    localFrame.GearHelperIconTexture:SetAtlas("bags-greenarrow", true)
    localFrame.GearHelperIconTexture:SetShown(true)

    return localFrame
end

--- Show upgrade icons on items in a container
--- @param container ContainerFrame The container frame to show icons on
function GearHelper:ShowUpgradeOnItemsIconsForContainer(container)
    -- Continue if there is no equiped bag
    if container == nil then
        print("Container doesn't exists")
        do
            return
        end
    end

    local bagId = container:GetBagID()
    local bagSize = C_Container.GetContainerNumSlots(container:GetBagID())

    for slotId, slot in pairs(container.Items) do
        local itemLocation = ItemLocation:CreateFromBagAndSlot(bagId, slotId)

        -- Ensure there is an item in the slot
        if C_Item.DoesItemExist(itemLocation) then
            local itemName = C_Item.GetItemName(itemLocation)
            if itemName ~= nil then
                -- Ensure Blizzard is returning an item link
                local bagItemWoWLink = C_Item.GetItemLink(itemLocation)
                if bagItemWoWLink then
                    local ghItemLink = GHItem:Create(bagItemWoWLink)
                    local suffix = GetNameOrID(slot:GetParent()) .. "." .. GetNameOrID(slot)

                    -- Check if the item is better than the equipped one
                    if ghItemLink and self:IsItemBetter(ghItemLink) then
                        AddIconTo(container.Items[bagSize - slotId + 1], suffix)
                    end
                end
            end
        end
    end
end

--- Hide upgrade icons on items in a container
--- @param container ContainerFrame The container frame to hide icons on
function GearHelper:HideUpgradeOnItemsIconsForContainer(container)
    -- Continue if there is no equiped bag
    if container == nil then
        print("Container doesn't exists")
        do
            return
        end
    end

    for _, slot in pairs(container.Items) do
        if slot and slot.GearHelperOverlay then
            slot.GearHelperOverlay:Hide()
            slot.GearHelperOverlay = nil
        end
    end
end

--- Hook the bag open function to show upgrade icons on items
function GearHelper:HookBagOpen()
    for _, frame in ContainerFrameUtil_EnumerateContainerFrames() do
        hooksecurefunc(
            frame,
            "UpdateName",
            function(self)
                GearHelper:HideUpgradeOnItemsIconsForContainer(self)
                GearHelper:ShowUpgradeOnItemsIconsForContainer(self)
            end
        )
        return
    end
end
