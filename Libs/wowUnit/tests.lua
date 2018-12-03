
wowUnit.tests = {
    ["Test assertions"] = {
        ["assert"] = function()
            wowUnit:assert(true, "True is indeed true")
            wowUnit:assert(false, "False creates failure")
        end,
        ["assertEquals"] = function()
            wowUnit:assertEquals(1, 1, "1 and 1 are indeed equal")
            wowUnit:assertEquals(1, 0, "1 and 0 are not equal")
            wowUnit:assertEquals(1, "1", "1 and \"1\" are not equal")
        end,
        ["assertSame"] = function()
            local t1 = {
                ["a"] = {
                    1
                }
            }
            local t2 = {
                ["a"] = {
                    1
                }
            }
            local t3 = {
                ["a"] = {
                }
            }

            wowUnit:assertSame(t1, t1, "same table should be equal")
            wowUnit:assertSame(t1, t2, "similar table should be same")
            wowUnit:assertEquals(t1, t2, "similar table should not be equal")
            wowUnit:assertSame(t1, t3, "different table should not be equal")
            wowUnit:assertSame(t3, t1, "different table should not be equal (reversed to make sure all table entries are checked both ways")
            t3.a[1] = 2
            wowUnit:assertSame(t1, t3, "still not same")
            t3.a[1] = 1
            wowUnit:assertSame(t1, t3, "should be the same now")
            wowUnit._t1 = t1
            wowUnit._t3 = t3
            wowUnit:assertSame(1, 1, "2 equal non-tables should be considered same")
            wowUnit:assertSame(1, 2, "2 non-equal non-tables should not be considered same")
        end
    },
    ["Test type checks"] = {
        ["isTable"] = function()
            wowUnit:isTable(nil, "nil is not a table")
            wowUnit:isTable(1, "1 is not a table")
            wowUnit:isTable("a", "\"a\" is not a table")
            wowUnit:isTable({}, "{} is a table")
        end,
        ["isString"] = function()
            wowUnit:isString(nil, "nil is not a string")
            wowUnit:isString(1, "1 is not a string")
            wowUnit:isString("a", "\"a\" is a string")
            wowUnit:isString({}, "{} is not a string")
        end,
        ["isNumber"] = function()
            wowUnit:isNumber(nil, "nil is not a number")
            wowUnit:isNumber(1, "1 is a number")
            wowUnit:isNumber("a", "\"a\" is not a number")
            wowUnit:isNumber({}, "{} is not a number")
        end,
        ["isNil"] = function()
            wowUnit:isNil(nil, "nil is nil")
            wowUnit:isNil(1, "1 is not nil")
            wowUnit:isNil("a", "\"a\" is not nil")
            wowUnit:isNil({}, "{} is not nil")
        end,
        ["isFunction"] = function()
            wowUnit:isFunction(nil, "nil is not a function")
            wowUnit:isFunction(1, "1 is not a function")
            wowUnit:isFunction("a", "\"a\" is not a function")
            wowUnit:isFunction({}, "{} is not a function")
            wowUnit:isFunction(wowUnit.assert, "wowUnit.assert is a function")
        end
    },
    ["Test expectations"] = {
        ["No expectations"] = function()
            wowUnit:assert(true, "true")
        end,
        ["expectations met"] = function()
            wowUnit:expect(1)
            wowUnit:assert(true, "true")
        end,
        ["expectations not met"] = function()
            wowUnit:expect(2)
            wowUnit:assert(true, "true")
        end,
    },
    ["Test empty categories"] = {},
    ["Test Lua errors"] = {
        ["Simple reference error"] = function()
            iMnotafunction()
        end,
        ["reference error with stack"] = function()
            function func1()
                func2()
            end

            function func2()
                iMnotafunction()
            end

            func1()
        end
    },
    ["Some successful tests"] = {
        ["test 1"] = function()
            wowUnit:expect(1)
            wowUnit:assert(true, "The way it should be")
        end,
        ["test 2"] = function()
            wowUnit:expect(2)
            wowUnit:assertEquals(1, 1, "The way it should be")
            wowUnit:assertSame(1, 1, "The way it should be")
        end,
        ["test 3"] = function()
            --wowUnit:expect(3)
            wowUnit:isNil(theNumberJ)
            wowUnit:isNumber(9, "J is unfortunately not a number, Day[9]")
            wowUnit:isString("J", "J, by itself, is a letter, which constitutes a string")
        end
    },
    ["Asynchronous testing"] = {
        ["asynch fails"] = function()
            wowUnit:pauseTesting()
        end,
        ["asynch succeeds"] = function()
            local testID = wowUnit:pauseTesting()
            wowUnit:expect(2)

            local frameCount = 1
            local testFrame = CreateFrame("Frame")
            testFrame:Show()
            testFrame:SetScript("OnUpdate", function(self, elapsed)
                frameCount = frameCount - 1
                if (frameCount <= 0) then
                    testFrame:SetScript("OnUpdate", nil)
                    wowUnit:resumeTesting(testID)
                    wowUnit:assert(true, "Asynch function terminated 1")
                end
            end)
        end,
        ["asynch fails because of timeout"] = function()
            local testID = wowUnit:pauseTesting()

            local frameCount = 6
            local testFrame = CreateFrame("Frame")
            testFrame:Show()
            testFrame:SetScript("OnUpdate", function(self, elapsed)
                frameCount = frameCount - elapsed
                if (frameCount <= 0) then
                    testFrame:SetScript("OnUpdate", nil)
                    wowUnit:resumeTesting(testID)
                    wowUnit:assert(true, "Asynch function terminated 2")
                end
            end)
        end,
        ["asynch succeeds within timeframe"] = function()
            local testID = wowUnit:pauseTesting(10)
            wowUnit:expect(2)

            local frameCount = 8
            local testFrame = CreateFrame("Frame")
            testFrame:Show()
            testFrame:SetScript("OnUpdate", function(self, elapsed)
                frameCount = frameCount - elapsed
                if (frameCount <= 0) then
                    testFrame:SetScript("OnUpdate", nil)
                    wowUnit:resumeTesting(testID)
                    wowUnit:assert(true, "Asynch function terminated 3")
                end
            end)
        end,
        ["asynch fails after timeframe"] = function()
            local testID = wowUnit:pauseTesting(2)
            wowUnit:expect(2)

            local frameCount = 3
            local testFrame = CreateFrame("Frame")
            testFrame:Show()
            testFrame:SetScript("OnUpdate", function(self, elapsed)
                frameCount = frameCount - elapsed
                if (frameCount <= 0) then
                    testFrame:SetScript("OnUpdate", nil)
                    wowUnit:resumeTesting(testID)
                    wowUnit:assert(true, "Asynch function terminated 4")
                end
            end)
        end
    },
    ["Setup and Teardown"] = {
        setup = function()
            wowUnit:Print("setup")
            wowUnit.__setupTest = 3
            wowUnit.__oldStartTests = wowUnit.StartTests
            function iMnotafunction()
                wowUnit:assert(true, "global function defined")
            end
            wowUnit.StartTests = function()
                wowUnit:assert(true, "StartTests called")
            end
        end,
        teardown = function()
            wowUnit:Print("teardown")
            wowUnit.__setupTest = nil
            wowUnit.StartTests = wowUnit.__oldStartTests
            iMnotafunction = nil
        end,
        ["Check if setupped variable is correct"] = function()
            wowUnit:assertEquals(wowUnit.__setupTest, 3, "Setup is working")
        end,
        ["mocking a function the untidy way"] = function()
            wowUnit:Print("mock")
            wowUnit:expect(2)
            iMnotafunction()
            wowUnit:StartTests()
        end
    },
    ["Mocking"] = {
        mock = {
            UnitName = function(unit)
                wowUnit:assert(true, "Mocked UnitName function was called.")
                return "Pan-Galactic Gargle Blaster"
            end
        },
        ["Check mocked function"] = function()
            wowUnit:assertEquals(UnitName('player'), "Pan-Galactic Gargle Blaster", "Our mocked function was called and returned the correct value")
            wowUnit:expect(2)
        end
    },
}
