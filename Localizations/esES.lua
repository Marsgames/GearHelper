local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "esES")
if not L then
    return
end

L["merci"] = "|cFF00FF00"
L["local"] = "ES"

-------------------------- CE QUI EST EN DESSOUS DE CETTE LIGNE EST DISPO SUR CURSE --------------------------
L["ActivatedGreen"] = "|cFF00FF00Activado|r"
L["Addon"] = "|cFF00FF00GearHelper esta :"
L["ask1"] = "|cFFFFFF00Puedes preguntarle a ["
L["ask2"] = "si necesita"
L["autoEquipLootedStuff"] = "Poner automaticamente los objetos"
L["autoEquipSpecChangedStuff"] = "Poner automaticamente quando se cambia la especializacion"
L["AutoRepair"] = "Arreglar tu equipo con tu dinero"
L["auto-repair"] = "El arreglo automatico"
L["auto-repairDesc"] = "Activar / quitar el arreglo automatico"
L["betterThanNothing"] = "Este objeto es mejor que nada"
L["CantRepair"] = "No puedes arreglar tu equipo"
L["DeactivatedRed"] = "|cFFFF0000quitado|r"
L["demande1"] = "¿Quieres preguntarle a"
L["demande2"] = "si necesita"
L["DNR"] = "No arreglar autamàticamente"
L["dot"] = ","
L["DropBy"] = "Dejado por :"
L["DropRate"] = "Tasa de apariciòn : "
L["DropZone"] = "Localisaciòn"
L["enable"] = "Activar"
L["equipVerbose"] = " esta equipado por GearHelper"
L["gearOptions"] = "Opciones de equipo"
L["getLoot"] = " recibe "
L["GuildAutoRepair"] = "Arreglado con el dinero de la hermandad"
L["guildRepairCost"] = "Dinero que le cuesta a tu hermandad : "
L["helpConfig"] = "config - Abrir el panel de configuracion"
L["isAlive"] = " esta vivo."
L["isDead"] = " esta muerto."
L["itemBetterThan"] = "|cFF7FFFD4Este objeto esta mejor que tu "
L["itemBetterThan2"] = " con un valor de +"
L["itemBetterThanGeneral"] = "|cFF7FFFD4Este objeto esta mejor que los tuyos con un valor de +"
L["itemEgal"] = "Este objeto tiene el mismo valor que el tuyo"
L["itemEgala"] = "Este objeto tiene el mismo valor que "
L["itemEgalMainD"] = "Este objeto tiene el mismo valor que el en tu Mano Derecha"
L["itemEgalMainG"] = "Este objeto tiene el mismo valor que el en tu Mano Izquierda"
L["itemEquipped"] = "Este objeto esta equipado"
L["itemLessThan"] = "|cFFFF0066Ese objeto es peor que tu "
L["itemLessThanGeneral"] = "|cFFFF0066Ese objeto esta peor"
L["itemNotEquippable"] = "No se puede equipar ese objeto"
L["lootInRaidAlert"] = "Alertar si récites algo mejor"
L["mainD"] = "Mano derecha"
L["mainG"] = "Mano izquierda"
L["maj1"] = "Estas actualmente utilizando la version |cFFFF0000"
L["maj2"] = "|r de GearHelper. Hemos encontrado la version |cFF00FF00"
L["maj3"] = "|r utilizada por "
L["maLangue"] = "spanish"
L["maLanguedeDE"] = "Spanisch"
L["maLangueenUS"] = "Spanish"
L["maLangueesES"] = "Español"
L["maLangueesEX"] = "Español"
L["maLanguefrFR"] = "Espagnol"
L["maLangueitIT"] = "Spagnolo"
L["maLanguekoKR"] = "스페인어"
L["maLangueptBR"] = "Espanhol"
L["maLangueruRU"] = "испанский"
L["maLanguezhCN"] = "西班牙语"
L["maLanguezhTW"] = "西班牙語"
L["miscOptions"] = "Opciones segundarias"
L["MmTtLClick"] = "Clic izquierdo para abrir las opciones"
L["MmTtRClickActivate"] = "Clic derecho para activer GearHelper"
L["MmTtRClickDeactivate"] = "Clic derecho para quitar GearHelper"
L["moneyEarned"] = "Pasta generada vendiendo : "
L["no"] = "No"
L["remove"] = "Cancelar"
L["repairCost"] = "Los costes del arreglamiento :"
L["sellGrey"] = "Veder los objetos grises"
L["thanksPanel"] = "Agradecimientos"
L["UIinviteMessage"] = "Mensaje de invitacìon"
L["UIMyNames"] = "Nombres"
L["UISayMyName"] = "Dice mì nombre"
L["UItemplateName"] = "Nuevo modelo"
L["yes"] = "Sì"
-------------------------- CE QUI EST EN DESSOUS DE CETTE LIGNE N'EST PAS DISPO SUR CURSE ----------------------------

------------------------------------------------ SUPRIMER CETTE LIGNE ------------------------------------------------
-----

L["Tooltip"] = {
    Stat = {
        ["Intellect"] = ITEM_MOD_INTELLECT_SHORT,
        ["Haste"] = ITEM_MOD_HASTE_RATING_SHORT,
        ["CriticalStrike"] = ITEM_MOD_CRIT_RATING_SHORT,
        ["Versatility"] = ITEM_MOD_VERSATILITY,
        ["Mastery"] = ITEM_MOD_MASTERY_RATING_SHORT,
        ["Agility"] = ITEM_MOD_AGILITY_SHORT,
        ["Stamina"] = ITEM_MOD_STAMINA_SHORT,
        ["Strength"] = ITEM_MOD_STRENGTH_SHORT,
        ["Armor"] = RESISTANCE0_NAME,
        ["Multistrike"] = ITEM_MOD_CR_MULTISTRIKE_SHORT,
        ["DPS"] = ITEM_MOD_DAMAGE_PER_SECOND_SHORT,
        ["Leech"] = "restitución",
        ["Avoidance"] = "elusión",
        ["MovementSpeed"] = "velocidad"
    },
    ["ItemLevel"] = "^Nivel de objeto",
    ["LevelRequired"] = "^Necesitas ser de nivel",
    ["GemSocketEmpty"] = "Ranuras",
    ["BonusGem"] = "^Bonus de ranura"
    --["MainDroite"] = "Dégâts main droite",
    --["MainGauche"] = "Dégâts main gauche"
}
