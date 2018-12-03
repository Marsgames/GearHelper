local mainFrame = wowUnit.mainFrame

wowUnit.UI = {}

function wowUnit.UI:InitializeUI()
    wowUnit:Print("InitializeUI")
    if not wowUnit.interfaceInitialized then
        wowUnit.interfaceInitialized = true

        tinsert(UISpecialFrames, "wowUnitFrame")
        mainFrame:SetToplevel(true)
        mainFrame:ClearAllPoints()
        mainFrame:SetPoint("CENTER")
        mainFrame:SetBackdrop(
            {
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                tileSize = 32,
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = 1,
                edgeSize = 32,
                insets = {
                    top = 12,
                    right = 12,
                    left = 11,
                    bottom = 11
                }
            }
        )
        mainFrame:SetHeight(460)
        mainFrame:SetWidth(460)
        mainFrame:EnableMouse(true)
        -- local titleRegion = mainFrame:CreateTitleRegion()
        -- titleRegion:SetAllPoints(mainFrame)

        local closeButton = CreateFrame("Button", "$parentCloseButton", mainFrame, "UIPanelCloseButton")
        closeButton:SetWidth(30)
        closeButton:SetHeight(30)
        closeButton:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -4, -4)
        closeButton:SetScript(
            "OnClick",
            function(...)
                mainFrame:Hide()
            end
        )

        local titleText = mainFrame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        titleText:SetPoint("TOP", mainFrame, "TOP", 0, -15)
        titleText:SetText("wowUnit")

        mainFrame.testText = mainFrame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        mainFrame.testText:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -30)

        wowUnitTestsScrollFrame:SetParent(mainFrame)
        wowUnitTestsScrollFrame:SetPoint("LEFT", mainFrame, "LEFT", 10, 0)
        wowUnitTestsScrollFrame:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -32, 10)
        wowUnitTestsScrollFrame:SetPoint("TOP", mainFrame.testText, "BOTTOM", 0, -5)
        wowUnitTestsScrollFrame:Show()

        wowUnitTestsScrollChild:SetWidth(wowUnitTestsScrollFrame:GetWidth())
    end
end

function wowUnit.UI:SetTestSuiteName(name)
    mainFrame.testText:SetText('Testing "' .. wowUnit.testSuiteName .. '"')
end

function wowUnit.UI:AddTestCategory()
    local categoryFrame = _G["wowUnitTestCategory" .. wowUnit.currentCategoryIndex]

    if (not categoryFrame) then
        categoryFrame = CreateFrame("Frame", "wowUnitTestCategory" .. wowUnit.currentCategoryIndex, wowUnitTestsScrollChild, "wowUnitTestCategoryFrameTemplate")
        if (wowUnit.currentCategoryIndex == 1) then
            categoryFrame:SetPoint("TOPLEFT", wowUnitTestsScrollChild, "TOPLEFT", 2, -2)
        else
            categoryFrame:SetPoint("TOPLEFT", _G["wowUnitTestCategory" .. (wowUnit.currentCategoryIndex - 1)], "BOTTOMLEFT", 0, -2)
        end
        categoryFrame:SetPoint("RIGHT", wowUnitTestsScrollChild, "RIGHT", -2, 0)
        categoryFrame.catID = wowUnit.currentCategoryIndex
    end

    local currentCategory = wowUnit.currentTests[wowUnit.currentCategoryIndex]

    categoryFrame.NameText:SetText(currentCategory.title)
    categoryFrame.testCategory = currentCategory
    categoryFrame:Show()
    wowUnit.UI:UpdateTestCategoryFrame(categoryFrame)
end

function wowUnit.UI:UpdateCurrentTestResults(resultText)
    local categoryFrame = _G["wowUnitTestCategory" .. wowUnit.currentCategoryIndex]
    local testFrame = _G[categoryFrame:GetName() .. "Test" .. wowUnit.currentTestIndex]
    _G[testFrame:GetName() .. "StatText"]:SetText(resultText)
end

function wowUnit.UI:UpdateCurrentTestCategoryResults(resultText)
    local categoryFrame = _G["wowUnitTestCategory" .. wowUnit.currentCategoryIndex]
    categoryFrame.NameText:SetText(resultText)
end

function wowUnit.UI:ExpandCurrentCategory()
    local categoryFrame = _G["wowUnitTestCategory" .. wowUnit.currentCategoryIndex]
    wowUnit.UI:ExpandTestCategoryFrame(categoryFrame)
end

function wowUnit.UI:CollapseCurrentCategory()
    local categoryFrame = _G["wowUnitTestCategory" .. wowUnit.currentCategoryIndex]
    wowUnit.UI:CollapseTestCategoryFrame(categoryFrame)
end

function wowUnit.UI:ExpandTestCategoryFrame(statGroup)
    statGroup.collapsed = false
    statGroup.CollapsedIcon:Hide()
    statGroup.ExpandedIcon:Show()
    wowUnit.UI:UpdateTestCategoryFrame(statGroup)
    statGroup.BgMinimized:Hide()
    statGroup.BgTop:Show()
    statGroup.BgMiddle:Show()
    statGroup.BgBottom:Show()
end

function wowUnit.UI:CollapseTestCategoryFrame(statGroup)
    statGroup.collapsed = true
    statGroup.CollapsedIcon:Show()
    statGroup.ExpandedIcon:Hide()
    local i = 1
    while (_G[statGroup:GetName() .. "Test" .. i]) do
        _G[statGroup:GetName() .. "Test" .. i]:Hide()
        i = i + 1
    end
    statGroup:SetHeight(18)
    statGroup.BgMinimized:Show()
    statGroup.BgTop:Hide()
    statGroup.BgMiddle:Hide()
    statGroup.BgBottom:Hide()
end

function wowUnit.UI:UpdateTestCategoryFrame(statGroup)
    local STRIPE_COLOR = {r = 0.9, g = 0.9, b = 1}
    local currentCategory = statGroup.testCategory
    local i = 1
    local totalHeight = statGroup.NameText:GetHeight() + 10
    for i = 1, #currentCategory.tests do
        local statFrame = _G[statGroup:GetName() .. "Test" .. i]

        if not statFrame then
            statFrame = CreateFrame("Button", statGroup:GetName() .. "Test" .. i, statGroup, "wowUnitTestFrameTemplate")
            statFrame:SetPoint("TOPLEFT", _G[statGroup:GetName() .. "Test" .. (i - 1)], "BOTTOMLEFT", 0, 0)
            statFrame:SetPoint("TOPRIGHT", _G[statGroup:GetName() .. "Test" .. (i - 1)], "BOTTOMRIGHT", 0, 0)
        end

        _G[statFrame:GetName() .. "Label"]:SetText(currentCategory.tests[i].title)
        --_G[statFrame:GetName().."StatText"]:SetText(--[[TODO]]"")
        statFrame:Show()
        statFrame.test = currentCategory.tests[i]
        statFrame.parentCategory = statGroup

        totalHeight = totalHeight + statFrame:GetHeight()

        if (i % 2 == 0) then
            if (not statFrame.Bg) then
                statFrame.Bg = statFrame:CreateTexture(statFrame:GetName() .. "Bg", "BACKGROUND")
                statFrame.Bg:SetPoint("LEFT", statGroup, "LEFT", 1, 0)
                statFrame.Bg:SetPoint("RIGHT", statGroup, "RIGHT", 0, 0)
                statFrame.Bg:SetPoint("TOP")
                statFrame.Bg:SetPoint("BOTTOM")
                statFrame.Bg:SetTexture(STRIPE_COLOR.r, STRIPE_COLOR.g, STRIPE_COLOR.b)
                statFrame.Bg:SetAlpha(0.1)
            end
        end
    end
    statGroup:SetHeight(totalHeight)

    -- fix for groups with only 1 item
    if (totalHeight < 44) then
        statGroup.BgBottom:SetHeight(totalHeight - 2)
    else
        statGroup.BgBottom:SetHeight(46)
    end

    -- hide extra statframes from old testing
    i = #currentCategory.tests + 1
    while (_G[statGroup:GetName() .. "Test" .. i]) do
        _G[statGroup:GetName() .. "Test" .. i]:Hide()
        i = i + 1
    end
end

function wowUnit.UI:ToggleTestFrame(frame)
    if not frame.opened then
        if not frame.resultString then
            frame.resultString = frame:CreateFontString(nil, "MEDIUM", "GameFontHighlightSmall")
            frame.resultString:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -frame.startingHeight)
            --frame.resultString:SetPoint("LEFT")
            frame.resultString:SetPoint("RIGHT")
            frame.resultString:SetWidth(frame:GetWidth())
            frame.resultString:SetJustifyH("LEFT")
            frame.resultString:SetJustifyV("TOP")
            --frame.resultString:SetTextHeight(10)
            frame.resultString:SetWordWrap(true)
        end

        frame.resultString:SetText(frame.test.result)
        frame.resultString:Show()
        frame:SetHeight(frame.resultString:GetHeight() + frame.startingHeight)

        frame.opened = true
    else
        frame.resultString:Hide()
        frame:SetHeight(frame.startingHeight)

        frame.opened = false
    end

    wowUnit.UI:UpdateTestCategoryFrame(frame.parentCategory)
end
