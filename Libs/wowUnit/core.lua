--TODO: add auto-Test functionality (user can choose test suites to automatically run every reload)

do	-- string.format prints nils now: %s -> %t
local format = string.format
	function strF(str, ...)
	  local args = {...}
	  local boolargs = {}
	  str = str:gsub("%%t", "%%%%t")
	  for i = #args, 1, -1 do
		--if type(args[i]) == "boolean" or  type(args[i]) == "nil" then
		  table.insert(boolargs, 1, args[i])
		--table.remove(args, i)
		--end
	  end
	  str = format(str, unpack(args))

	  local j = 0
	  return (str:gsub("%%t", function(spec) j = j + 1; return tostring(boolargs[j]) end))
	end
end

local addonName, addonTable = ...;
local POSITIVE = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t";
local NEGATIVE = "|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t";

wowUnit = addonTable;

wowUnit.mainFrame = CreateFrame("Frame", "wowUnitFrame", UIParent);
wowUnit.mainFrame:RegisterEvent("ADDON_LOADED");

function wowUnit:eventHandler(event, arg1, ...)
    if (event == "ADDON_LOADED" and arg1 == addonName) then
        wowUnit.UI:InitializeUI();
        wowUnit:RegisterChatCommands();
        wowUnit:StartAutoTestsOnLogin();

        wowUnit.mainFrame:UnregisterEvent("ADDON_LOADED")
    end
end

wowUnit.mainFrame:SetScript("OnEvent", wowUnit.eventHandler);

function wowUnit:RegisterChatCommands()
    SLASH_wowUnit1 = "/test";
    SLASH_wowUnit2 = "/wowunit";
    SLASH_wowUnit3 = "/wu";
    SLASH_wowUnit4 = "/unittest";
    
    function SlashCmdList.wowUnit(message, editBox)
        local command, rest = message:match("^(%S*)%s*(.-)$");
        
        if (command == "whatever") then
            --TODO: remove this unless there is a reasonable command to add, like 'config'
        else
            if _G[command] then
				print("this is cmd: " ..command.. " Gcmd:")
                wowUnit:SetCurrentTestSuiteName(command);
                wowUnit:StartTests(_G[command]);
            else
                wowUnit:Print("Test suite "..(command or "").." not found.");
            end
        end
    end
end

function wowUnit:SetCurrentTestSuiteName(name)
    wowUnit.testSuiteName = name;
    wowUnit.UI:SetTestSuiteName();
end
function wowUnit:StartTests(testTable)
    if type(testTable) ~= "table" then
        wowUnit:Print("Invalid test suite supplied: Object is not a table.");
    else
        wowUnit:CreateTestSuiteTitle(testTable.title);
        wowUnit:IterateTestSuiteCategories(testTable);
    end
end

function wowUnit:CreateTestSuiteTitle(title)
    if (title) then
        wowUnit:SetCurrentTestSuiteName(title);
    end
    wowUnit:Print("Starting tests for "..(wowUnit.testSuiteName or "unknown test suite")..".")
end

function wowUnit:IterateTestSuiteCategories(testTable)
    if (not testTable.tests) then
        wowUnit:Print("No tests found.");
        return;
    end
    
    wowUnit:ResetAllTestingData();
    for testCategoryTitle, testCategoryTable in orderedPairs(testTable.tests) do
        wowUnit:PrepareCategoryForTesting(testCategoryTitle, testCategoryTable);
    end
    
    wowUnit:RunCurrentTests()
end

function wowUnit:ResetAllTestingData()
    wowUnit.currentTests = {};
    wowUnit.currentCategoryIndex = 1;
    wowUnit.currentTestIndex = 1;
    wowUnit.currentTestSuiteResults = {
        success = 0,
        failure = 0,
        total = 0
    };
    wowUnit.currentTestCategoryResults = {
        success = 0,
        failure = 0,
        total = 0
    };
    wowUnit.currentTestResults = {
        success = 0,
        failure = 0,
        total = 0,
        expect = nil
    };
    wowUnit.currentTest = nil;
    wowUnit.testTimeout = nil;
    wowUnit.testPaused = false;
    wowUnit.currentTestID = 0;

    local i = 1;
    while (_G["wowUnitTestCategory"..i]) do
        _G["wowUnitTestCategory"..i]:Hide();
        i = i + 1;
    end
end

function wowUnit:PrepareCategoryForTesting(testCategoryTitle, testCategoryTable)
    local tempTable = {
        title = testCategoryTitle,
        tests = wowUnit:PrepareTestsTable(testCategoryTable)
    };
    if (testCategoryTable.setup and type(testCategoryTable.setup) == "function") then
        tempTable.setup = testCategoryTable.setup;
    end
    if (testCategoryTable.teardown and type(testCategoryTable.teardown) == "function") then
        tempTable.teardown = testCategoryTable.teardown;
    end
    tinsert(wowUnit.currentTests, tempTable);
end

function wowUnit:PrepareTestsTable(testCategoryTable)
    local testsTable = {};
    for testTitle, testFunc in orderedPairs(testCategoryTable) do
        if (testTitle ~= "setup" and testTitle ~= "teardown") then
            tinsert(testsTable, {
                title = testTitle,
                func = testFunc,
                result = ""
            });
        end
    end
    return testsTable;
end

function wowUnit:RunCurrentTests()
    wowUnit.mainFrame:SetScript("OnUpdate", wowUnit.TestIteration);
    wowUnit.mainFrame:Show();
    
    wowUnit.testsAreRunning = true;
end

function wowUnit:TestIteration(elapsedTime)
    if (wowUnit.testPaused) then
        wowUnit.testTimeout = wowUnit.testTimeout - elapsedTime;
        if (wowUnit.testTimeout < 0) then
            wowUnit:CurrentTestFailed("timeout has been reached");
            wowUnit.testPaused = false;
            wowUnit.testTimeout = nil;
        end
    else
        if (wowUnit.currentTest) then
            wowUnit:TeardownTest();
            wowUnit:CompleteTest();
            wowUnit:SelectNextTest();
        end
        wowUnit:SetupTest();
        wowUnit:RunCurrentTest();
    end
end

function wowUnit:CompleteTest()
    local expectationMet = true;
    if (wowUnit.currentTestResults.expect ~= nil) then
        if (wowUnit.currentTestResults.expect == wowUnit.currentTestResults.total) then
            wowUnit:CurrentTestSucceeded("Expected number of tests ran");
        else
            wowUnit:CurrentTestFailed("Expected number of tests not met - Expected: "..wowUnit.currentTestResults.expect.."; Ran: "..wowUnit.currentTestResults.total);
            expectationMet = false;
        end
    end

    if (wowUnit.currentResult and not wowUnit.currentResult[1]) then
        wowUnit:CurrentTestFailed("Lua Error:\n  "..wowUnit.currentResult[2]);
    end

    local resultString;
    if (wowUnit.currentTestResults.failure > 0) or (wowUnit.currentTestResults.total ~= (wowUnit.currentTestResults.success)) then
        resultString = NEGATIVE;
    else
        resultString = POSITIVE;
    end
    resultString = resultString.." |cff00ff00"..wowUnit.currentTestResults.success.."|r";
    resultString = resultString.."/|cffff0000"..wowUnit.currentTestResults.failure.."|r";

    if (wowUnit.currentTestResults.expect == nil) then
        resultString = resultString.."/"..wowUnit.currentTestResults.total;
    else
        if (expectationMet) then
            resultString = resultString.."/|cff00ff00"..wowUnit.currentTestResults.total.."|r";
        else
            resultString = resultString.."/|cffff0000"..wowUnit.currentTestResults.total.."|r";
        end
    end

    wowUnit.UI:UpdateCurrentTestResults(resultString);

    wowUnit.currentTestResults.success = 0;
    wowUnit.currentTestResults.failure = 0;
    wowUnit.currentTestResults.total = 0;
    wowUnit.currentTestResults.expect = nil;
    wowUnit.testsAreRunning = true;
end

function wowUnit:SelectNextTest()
    wowUnit.currentTestIndex = wowUnit.currentTestIndex + 1;

    if (wowUnit.currentTestIndex > #(wowUnit.currentTests[wowUnit.currentCategoryIndex].tests)) then
        wowUnit:CompleteTestCategory();
        wowUnit.currentTestIndex = 1;
        wowUnit.currentCategoryIndex = wowUnit.currentCategoryIndex + 1;
    end

    if (wowUnit.currentCategoryIndex > #(wowUnit.currentTests)) then
        wowUnit:EndTesting();
    end
end

function wowUnit:CompleteTestCategory()
    local resultString;
    if (wowUnit.currentTestCategoryResults.failure > 0) or (wowUnit.currentTestCategoryResults.total ~= wowUnit.currentTestCategoryResults.success) then
        resultString = NEGATIVE;
        wowUnit.UI:ExpandCurrentCategory();
    else
        resultString = POSITIVE;
        wowUnit.UI:CollapseCurrentCategory();
    end
    resultString = resultString..wowUnit.currentTests[wowUnit.currentCategoryIndex].title;
    resultString = resultString.." (|cff00ff00"..wowUnit.currentTestCategoryResults.success.."|r";
    resultString = resultString.."/|cffff0000"..wowUnit.currentTestCategoryResults.failure.."|r";
    resultString = resultString.."/"..wowUnit.currentTestCategoryResults.total..")";

    wowUnit.UI:UpdateCurrentTestCategoryResults(resultString);

    --wowUnit:Print(resultString);
    wowUnit.currentTestCategoryResults.success = 0;
    wowUnit.currentTestCategoryResults.failure = 0;
    wowUnit.currentTestCategoryResults.total = 0;
end

function wowUnit:RunCurrentTest()
    wowUnit:Print("RunCurrentTest", wowUnit.currentCategoryIndex, wowUnit.currentTestIndex);
    local currentCategory = wowUnit.currentTests[wowUnit.currentCategoryIndex];
    if (not currentCategory) then return; end

    if (wowUnit.currentTestIndex == 1) then
        wowUnit.UI:AddTestCategory();
    end

    wowUnit.currentTest = currentCategory.tests[wowUnit.currentTestIndex];

    if (wowUnit.currentTest) then
        wowUnit:Print('running test', wowUnit.currentTest.title);
        -- wowUnit.currentResult = { pcall(wowUnit.currentTest.func) , };
		 
		wowUnit.currentResult = { xpcall(wowUnit.currentTest.func, function(err) return debugstack(2,20,20)  end) , };
		
  
	else
        wowUnit:SelectNextTest();
    end
end

function wowUnit:RunTestCategoryTests(testCategoryTable)
    if (not testCategoryTable) or (type(testCategoryTable) ~= "table") then
        wowUnit:Print("    No Tests defined.");
        return;
    end
    
    for testName, testfunc in pairs(testCategoryTable) do
        wowUnit:PrepareTest();
    end
end

function wowUnit:EndTesting()
    wowUnit.mainFrame:SetScript("OnUpdate", nil);
    wowUnit:PrintFinalTestResults();
    wowUnit.testsAreRunning = false;
end

function wowUnit:PrintFinalTestResults()
    wowUnit:Print("Testing finished.");
    wowUnit:Print("|cff00ff00"..wowUnit.currentTestSuiteResults.success.."|r Successful, ".."|cffff0000"..wowUnit.currentTestSuiteResults.failure.."|r Failed");
end

function wowUnit:SetupTest()
    local currentCategory = wowUnit.currentTests[wowUnit.currentCategoryIndex];
    if (not currentCategory) then return; end

    if (currentCategory.setup and type (currentCategory.setup == "function")) then
        local result = {pcall(currentCategory.setup)};
        if not result[1] then
            wowUnit:CurrentTestFailed("Setup Error: "..result[2]..debugstack(2, 3, 2));
        end
    end
end

function wowUnit:TeardownTest()
    local currentCategory = wowUnit.currentTests[wowUnit.currentCategoryIndex];
    if (not currentCategory) then return; end

    if (currentCategory.teardown and type (currentCategory.teardown == "function")) then
        local result = {pcall(currentCategory.teardown)};
        if not result[1] then
            wowUnit:CurrentTestFailed("Teardown Error: "..result[2]..debugstack(2, 3, 2));
        end
    end
end

function wowUnit:pauseTesting(timeout)
    if (timeout and type(timeout) == "number" and timeout > 0) then
        wowUnit.testTimeout = timeout;
    else
        wowUnit.testTimeout = 5;
    end
    wowUnit.testPaused = true;
    wowUnit.currentTestID = wowUnit.currentTestID + 1;
    return wowUnit.currentTestID;
end

function wowUnit:resumeTesting(testID)
    if wowUnit.testPaused then
        if (testID ~= nil) then
            if (testID == wowUnit.currentTestID) then
                wowUnit.testPaused = false;
                wowUnit.testTimeout = nil;
                wowUnit:CurrentTestSucceeded("testing resumed normally");
            else
                -- wrong test ID, this is not the resume we're looking for
            end
        else
            wowUnit.testPaused = false;
            wowUnit.testTimeout = nil;
            wowUnit:CurrentTestSucceeded("testing resumed normally");
        end
    else
        -- testing does not need to be resumed...
    end
end

function wowUnit:Print(...)
    wowUnit:PrintString(string.join(", ", tostringall(...)))
end

function wowUnit:PrintString(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cffaaaadd"..addonName.."|r: "..text);
end

function wowUnit:CurrentTestSucceeded(message)
    if not wowUnit.testsAreRunning then return end
    wowUnit.currentTestSuiteResults.success = wowUnit.currentTestSuiteResults.success + 1;
    wowUnit.currentTestCategoryResults.success = wowUnit.currentTestCategoryResults.success + 1;
    wowUnit.currentTestResults.success = wowUnit.currentTestResults.success + 1;
    wowUnit.currentTestSuiteResults.total = wowUnit.currentTestSuiteResults.total + 1;
    wowUnit.currentTestCategoryResults.total = wowUnit.currentTestCategoryResults.total + 1;
    wowUnit.currentTestResults.total = wowUnit.currentTestResults.total + 1;

    local currentCategory = wowUnit.currentTests[wowUnit.currentCategoryIndex];
    local currentTest = currentCategory.tests[wowUnit.currentTestIndex];
    if (message ~= nil) then
        currentTest.result = currentTest.result..POSITIVE.." |cff00ff00"..message.."|r\n";
    else
        currentTest.result = currentTest.result..POSITIVE.."\n";
    end
end

function wowUnit:CurrentTestFailed(message)
    if not wowUnit.testsAreRunning then return end
    wowUnit.currentTestSuiteResults.failure = wowUnit.currentTestSuiteResults.failure + 1;
    wowUnit.currentTestCategoryResults.failure = wowUnit.currentTestCategoryResults.failure + 1;
    wowUnit.currentTestResults.failure = wowUnit.currentTestResults.failure + 1;
    wowUnit.currentTestSuiteResults.total = wowUnit.currentTestSuiteResults.total + 1;
    wowUnit.currentTestCategoryResults.total = wowUnit.currentTestCategoryResults.total + 1;
    wowUnit.currentTestResults.total = wowUnit.currentTestResults.total + 1;

    local currentCategory = wowUnit.currentTests[wowUnit.currentCategoryIndex];
    local currentTest = currentCategory.tests[wowUnit.currentTestIndex];
    if (message ~= nil) then
        currentTest.result = currentTest.result..NEGATIVE.." |cffff0000"..message.."|r\n";
    else
        currentTest.result = currentTest.result..NEGATIVE.."\n";
    end
end

function wowUnit:StartAutoTestsOnLogin()
    wowUnit:StartTests(wowUnit);
end
