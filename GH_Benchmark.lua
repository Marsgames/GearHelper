local GHBenchmarkedFuncCount = {}
local BenchmarkMode = false or "Niisha" == UnitName("player")

function GearHelper:ResetBenchmark(type)
    if type == "Count" then
        GHBenchmarkedFuncCount = {}
    end
end

function GearHelper:SwapBenchmarkMode()
    BenchmarkMode = not BenchmarkMode
end

function GearHelper:GetBenchmarkMode()
    return BenchmarkMode
end

function GearHelper:GetBenchmarkResult(type)
    if type == "Count" then
        return GHBenchmarkedFuncCount
    end
end

function GearHelper:BenchmarkCountFuncCall(funcName)
    if (false == GearHelper:GetBenchmarkMode()) then
        return
    end

    if GHBenchmarkedFuncCount[funcName] == nil then
        GHBenchmarkedFuncCount[funcName] = 0
    end

    GHBenchmarkedFuncCount[funcName] = GHBenchmarkedFuncCount[funcName] + 1
end
