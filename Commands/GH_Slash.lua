local slashCmd = {
    help = function()
        GearHelper:SlashDisplayHelp()
    end,
    printCache = function()
        GearHelper:SlashPrintCache()
    end,
    list = function()
        GearHelper:SlashList()
    end,
    config = function()
        GearHelper:SlashConfig()
    end,
    version = function()
        GearHelper:SlashVersion()
    end,
    im = function()
        GearHelper:SlashIm()
    end,
    createItemlink = function()
        GearHelper:SlashCreateItemLink()
    end,
    -- askLoot = function()
    -- 	GearHelper:SlashAskLoot()
    -- end,
    dot = function()
        GearHelper:SlashDot()
    end,
    suppDot = function()
        GearHelper:SlashSuppDot()
    end,
    cw = function()
        GearHelper:SlashCw()
    end,
    ain = function()
        GearHelper:SlashAin()
    end,
    reset = function()
        GearHelper:SlashReset()
    end,
    resetCache = function()
        GearHelper:SlashResetCache()
    end,
    debug = function()
        GearHelper:SlashDebug()
    end,
    inspect = function()
        GearHelper:SlashInspect()
    end,
    check = function()
        GearHelper:SlashCheck()
    end,
    test = function()
        GearHelper:SlashTest()
    end,
    benchmark = function()
        GearHelper:SlashBenchmark()
    end,
    benchmarkCountResult = function()
        GearHelper:SlashBenchmarkCountResult()
    end,
    benchmarkResetCountResult = function()
        GearHelper:SlashBenchmarkResetCountResult()
    end,
    countCache = function()
        GearHelper:SlashCountCache()
    end
}

GearHelper:RegisterChatCommand("GearHelper", "MySlashCommand")
GearHelper:RegisterChatCommand("GH", "MySlashCommand")

function GearHelper:MySlashCommand(input)
    for cmd, action in pairs(slashCmd) do
        if input:lower() == cmd:lower() then
            action()
            do
                return
            end
        end
    end

    if input == "" then
        InterfaceOptionsFrame:Show()
        InterfaceOptionsFrame_OpenToCategory(GearHelper.cwFrame)
        InterfaceOptionsFrame_OpenToCategory(GearHelper.optionsFrame)
    else
        slashCmd["help"]()
    end
end
