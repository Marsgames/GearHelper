files['*.rockspec'].global = false
files['.luacheckrc'].global = false
exclude_files  = {"Libs", ".svn", "Problèmes", "Localizations"}
std = {
   globals = {"_G","GetItemInfoInstant","_","ContainerFrame_UpdateAll","IsEquipped","GetItemSpecInfo","WorldFrame","myTooltipFromTemplate","CreateFrame","GetInventoryItemID","SendChatMessage","StaticPopup_Hide","StaticPopup_Show","StaticPopupDialogs","IsInGuild","RepairAllItems","math","GetUnitName","GetNumQuestChoices","GetQuestReward","GetQuestItemLink","GetLootRollItemInfo","UIErrorsFrame","ConfirmLootRoll","waitSpeFrame","waitSpeTimer","GetNumGroupMembers","ConvertToRaid","InviteUnit","NUM_CHAT_WINDOWS","GetInventoryItemLink","GetInventorySlotInfo", "GetGuildBankWithdrawMoney", "GetGuildBankMoney","UseContainerItem", "CanMerchantRepair", "GetMoney", "GetRepairAllCost", "CanGuildBankRepair", "table", "strmatch", "InterfaceOptionsFrame", "GetContainerItemLink","GetItemStatDelta", "ReloadUI", "SetChatWindowUninteractable", "GetChatWindowInfo", "time", "InterfaceOptionsFrame_OpenToCategory", "DeleteEquipmentSet", "UseEquipmentSet", "RegisterAddonMessagePrefix", "SaveEquipmentSet", "GetAddOnMemoryUsage", "select", "strsplit", "strfind", "foreach", "GetCombatRating", "IsEquippableItem", "UnitLevel", "UnitClass", "type", "GetSpecialization", "GetSpecializationInfo", "C_MountJournal", "GetItemInfo", "C_PetJournal", "PlaySoundFile", "GetContainerItemID", "GetContainerItemInfo", "GetContainerNumSlots", "pairs", "print", "tostring", "string", "LibStub", "GearHelper", "tonumber"}
}
ignore = {"212/self"}
max_line_length = 1000
