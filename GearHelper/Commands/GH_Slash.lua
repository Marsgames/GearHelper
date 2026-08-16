local slashCmd = {
    help = function()
        GearHelper:SlashDisplayHelp()
    end,
    version = function()
        GearHelper:SlashVersion()
    end,
    cw = function()
        GearHelper:SlashCw()
    end,
    template = function()
        GearHelper:SlashCw()
    end,
    reset = function()
        GearHelper:SlashReset()
    end
}

local adminSlashCmd = {
    debug = function()
        GearHelper:SlashDebug()
    end,
    resetdebug = function()
        GearHelper:SlashResetDebug()
    end,
    reload = function()
        GearHelper:SlashReload()
    end,
    ain = function()
        GearHelper:SlashAin()
    end,
    createitemlink = function()
        GearHelper:SlashCreateItemLink()
    end,
}

function GearHelper:MySlashCommand(input)
    local cmd = strtrim(input):lower()

    if cmd == "" then
        if GearHelper.optionsCategoryID then
            Settings.OpenToCategory(GearHelper.optionsCategoryID)
        end
        return
    end

    if slashCmd[cmd] then
        slashCmd[cmd]()
        return
    end

    if GearHelper:IsAdmin() and adminSlashCmd[cmd] then
        adminSlashCmd[cmd]()
        return
    end

    slashCmd["help"]()
end

GearHelper:RegisterChatCommand("GearHelper", "MySlashCommand")
GearHelper:RegisterChatCommand("gh", "MySlashCommand")
