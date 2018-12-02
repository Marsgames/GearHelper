
local slashCmd = {
	help = GearHelper:SlashDisplayHelp(),
	printCache = GearHelper:SlashPrintCache(),
	list = GearHelper:SlashList(),
	config = GearHelper:SlashConfig(),
	version = GearHelper:SlashVersion(),
	im = GearHelper:SlashIm(),
	createItemlink = GearHelper:SlashCreateItemLink(),
	askLoot = GearHelper:SlashAskLoot(),
	dot = GearHelper:SlashDot(),
	suppDot = GearHelper:SlashSuppDot(),
	cw = GearHelper:SlashCw(),
	ain = GearHelper:SlashAin(),
	reset = GearHelper:SlashReset(),
	resetCache = GearHelper:SlashResetCache(),
	debug = GearHelper:SlashDebug(),
	inspect = GearHelper:SlashInspect()
}

GearHelper:RegisterChatCommand("GearHelper", "MySlashCommand")
GearHelper:RegisterChatCommand("GH", "MySlashCommand")

function GearHelper:MySlashCommand(input)
	for cmd, action in pairs(slashCmd) do
		if input == cmd then
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
