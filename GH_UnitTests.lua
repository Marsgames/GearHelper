GearHelper.tests = {
    ["GH_Toolbox"] = {
        ["IsInTable"] = function()
            wowUnit:assert(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, 21), "21 is in table")
            wowUnit:assertEquals(GearHelper:IsInTable({8, 5, 3, 1, 2, 12}, 27), false, "27 is not in table")
            wowUnit:assertEquals(GearHelper:IsInTable({}, nil), false, "nil is not in empty table")
            wowUnit:assertEquals(GearHelper:IsInTable({}, 11), false, "11 is not in empty table")
            -- wowUnit:assertEquals(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, nil), false, "nil is not in table") --> Toolbox.lua:167: bad argument #2 yo strmatch (string expected got nil)
            wowUnit:assert(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, "21"), '"21" is not in table but integer 21 is')
            wowUnit:assertEquals(GearHelper:IsInTable({1, 5, 3, 8, 21, 3, 5, 7}, "23"), false, '"23" is not in table but and integer 23 is not too')
            wowUnit:assert(GearHelper:IsInTable({"1", "5", "3", "8", "21", "3", "5", "7"}, "21"), '"21" is in table')
        end,
        ["IsEmptyTable"] = function()
            wowUnit:assert(GearHelper:IsEmptyTable({}), "{} is an empty table")
            wowUnit:assert(GearHelper:IsEmptyTable({nil}), "{nil} is an empty table")
            wowUnit:assertEquals(GearHelper:IsEmptyTable({21}), false, "{21} is not an empty table")
            wowUnit:assertEquals(GearHelper:IsEmptyTable({11, 21, 3, 46, 73, 7}), false, "table not empty")
            wowUnit:assertEquals(GearHelper:IsEmptyTable({""}), false, '{""} is not an empty table')
        end,
        ["parseID"] = function()
            wowUnit:assert(GearHelper:parseID("|cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0|h[Broken Fang]|h|r"), 7073, "Broken fang id is 7073")
        end,
        ["CountingSort"] = function()
            local tableUnsort = {3, 8, 5, 21, 1, 73, 7, 3}
            local tableSort = {1, 3, 3, 5, 7, 8, 21, 73}
            GearHelper:CountingSort(tableUnsort)
            wowUnit:assertSame(tableUnsort, tableSort, "table sorted")
        end
    }
}
