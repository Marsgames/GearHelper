local L = LibStub("AceLocale-3.0"):NewLocale("GearHelper", "koKR")
if not L then
    return
end

local nePasNeed = GHDontNeed

L["merci"] = "|cFF00FF00"

L["local"] = "KR"

L["maLangue"] = "corean"

L["ActivatedGreen"] = "켜짐|r"
L["Addon"] = "GearHelper :"
L["AutoRepair"] = "자기 자금으로 수리"
L["auto-repair"] = "자동 수리"
L["auto-repairDesc"] = "자동 수리 사용 / 사용 안 함"
L["customWeights"] = "사용자 정의 가중치"
L["DeactivatedRed"] = "꺼짐|r"
L["DNR"] = "자동으로 수리 안 함"
L["dot"] = "."
L["DropZone"] = "위치 :"
L["gearOptions"] = "장비 옵션"
L["gold"] = "골"
L["GuildAutoRepair"] = "길드 자금으로 수리"
L["guildRepairCost"] = "길드 수리 비용 :"
L["helpConfig"] = "config - 설정창 열기"
L["helpCW"] = "cw - 사용자 정의 가중치 창 열기"
L["ilvlInspect"] = "평균 템렙 :"
L["miscOptions"] = "기타 옵션"
L["MmTtLClick"] = "좌클릭으로 옵션 열기"
L["MmTtRClickActivate"] = "우클릭으로 GearHelper 켜기"
L["MmTtRClickDeactivate"] = "우클릭으로 GearHelper 끄기"
L["noxxicWeights"] = "Noxxic 가중치"
L["UIBossesKilled"] = "처치한 우두머리"
L["UIcwIlvlWeight"] = "템렙 가중치"
L["UIGHCheckBoxAutoAcceptQuestReward"] = "퀘스트 보상 자동 수락 사용 / 사용 안 함"
L["UIIlvlCharFrame"] = "캐릭터창 템렙"
L["UIIlvlCharFrameDesc"] = "캐릭터창 아이템에 템렙을 표시합니다."
L["UIIlvlInspectFrame"] = "살펴보기 시 템렙"
L["UIIlvlInspectFrameDesc"] = "살펴보기 할 때 대상의 템렙을 표시합니다."
L["UIinviteMessage"] = "초대 메시지"
L["UIMinimapIcon"] = "미니맵 아이콘"
L["UIMinimapIconDesc"] = "미니맵 아이콘 표시"
L["UISayMyNameDesc"] = "누군가 내 이름을 부를 때 소리와 함께 경고를 표시합니다."

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
        ["Leech"] = "생기흡수",
        ["Avoidance"] = "광역회피",
        ["MovementSpeed"] = "이동 속도"
    },
    ["ItemLevel"] = "^아이템 레벨",
    ["LevelRequired"] = "^요구 레벨",
    ["GemSocketEmpty"] = "보석 홈",
    ["BonusGem"] = "^보석 장착 보너스"
    --["MainDroite"] = "Dégâts main droite",
    --["MainGauche"] = "Dégâts main gauche"
}
