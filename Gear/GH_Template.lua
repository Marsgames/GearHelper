local function IgnoreSpec(currentSpec)
    -- We want to ignore initial specs

    -- https://wowpedia.fandom.com/wiki/SpecializationID
    local ignoredSpec = {
        [1455] = true,
        [1456] = true,
        [1447] = true,
        [1465] = true,
        [1448] = true,
        [1449] = true,
        [1450] = true,
        [1451] = true,
        [1452] = true,
        [1453] = true,
        [1444] = true,
        [1454] = true,
        [1446] = true,
    }

    if (ignoredSpec[currentSpec] ~= nil) then
        return true
    end

    return false
end


function GearHelper:GetStatFromActiveTemplate(statName)
    if (nil == self.db.profile.weightTemplate) then
        self:Print("WeightTemplate was nil, new value is NOX", "template")
        self.db.profile.weightTemplate = "NOX"
    end

    if (self.db.profile.weightTemplate == "NOX" or self.db.profile.weightTemplate == "NOX_ByDefault") then
        local currentSpec = GetSpecializationInfo(GetSpecialization())

        if (IgnoreSpec(currentSpec)) then
            return 0
        end

        if (self.db.global.templates[currentSpec] ~= nil) then
            if (self.db.global.templates[currentSpec]["NOX"] ~= nil) then
                if (self.db.global.templates[currentSpec]["NOX"][statName] ~= nil) then
                    return self.db.global.templates[currentSpec]["NOX"][statName]
                end
            end
        end
    else
        if (self.db.profile.CW[self.db.profile.weightTemplate] ~= nil) then
            if (self.db.profile.CW[self.db.profile.weightTemplate][statName] ~= nil) then
                return self.db.profile.CW[self.db.profile.weightTemplate][statName]
            end
        end
    end

    return 0
end

function GearHelper:SetStatToActiveTemplate(statName, value)
    if (nil == self.db.profile.weightTemplate) then
        self:Print("WeightTemplate was nil, new value is NOX", "template")
        self.db.profile.weightTemplate = "NOX"
    end
    value = tonumber(value) or 0

    if (self.db.profile.weightTemplate == "NOX" or self.db.profile.weightTemplate == "NOX_ByDefault") then
        local currentSpec = GetSpecializationInfo(GetSpecialization())
        self.db.global.templates[currentSpec]["NOX"][statName] = value
    else
        self.db.profile.CW[self.db.profile.weightTemplate][statName] = value
    end
end

--All available stats in 10.0.0 builds
--[[
[ITEM_MOD_ITEM_MOD_AGILITY_SHORT_SHORT] = "ITEM_MOD_AGILITY_SHORT";
[ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT] = "ARMOR Penetration";
[ITEM_MOD_ATTACK_POWER_SHORT] = "Attack Power";
[ITEM_MOD_BLOCK_RATING_SHORT] = "Block";
[ITEM_MOD_BLOCK_VALUE_SHORT] = "Block Value";
[ITEM_MOD_CORRUPTION] = "Corruption";
[ITEM_MOD_CORRUPTION_RESISTANCE] = "Corruption Resistance";
[ITEM_MOD_CRAFTING_SPEED_SHORT] = "Crafting Speed";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_MELEE_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike (Melee)";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_RANGED_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike (Ranged)";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_SPELL_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike (Spell)";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_TAKEN_MELEE_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike Avoidance (Melee)";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_TAKEN_RANGED_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike Avoidance (Ranged)";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_TAKEN_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike Avoidance";
[ITEM_MOD_ITEM_MOD_CRIT_RATING_SHORT_TAKEN_SPELL_RATING_SHORT] = "ITEM_MOD_CRIT_RATING_SHORTical Strike Avoidance (Spell)";
[ITEM_MOD_CR_AVOIDANCE_SHORT] = "Avoidance";
[ITEM_MOD_CR_LIFESTEAL_SHORT] = "ITEM_MOD_CR_LIFESTEAL_SHORT";
[ITEM_MOD_CR_MULTISTRIKE_SHORT] = "Multistrike";
[ITEM_MOD_CR_SPEED_SHORT] = "Speed";
[ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = "Damage Per Second";
[ITEM_MOD_DEFENSE_SKILL_RATING_SHORT] = "Defense";
[ITEM_MOD_DEFTNESS_SHORT] = "Deftness";
[ITEM_MOD_DODGE_RATING_SHORT] = "Dodge";
[ITEM_MOD_EXPERTISE_RATING_SHORT] = "Expertise";
[ITEM_MOD_EXTRA_ARMOR_SHORT] = "Bonus ARMOR";
[ITEM_MOD_FERAL_ATTACK_POWER_SHORT] = "Attack Power In Forms";
[ITEM_MOD_FINESSE_SHORT] = "Finesse";
[ITEM_MOD_ITEM_MOD_HASTE_RATING_SHORT_RATING_SHORT] = "ITEM_MOD_HASTE_RATING_SHORT";
[ITEM_MOD_HEALTH_REGENERATION_SHORT] = "Health Regeneration";
[ITEM_MOD_HEALTH_REGEN_SHORT] = "Health Per 5 Sec.";
[ITEM_MOD_HEALTH_SHORT] = "Health";
[ITEM_MOD_HIT_MELEE_RATING_SHORT] = "Hit (Melee)";
[ITEM_MOD_HIT_RANGED_RATING_SHORT] = "Hit (Ranged)";
[ITEM_MOD_HIT_RATING_SHORT] = "Hit";
[ITEM_MOD_HIT_SPELL_RATING_SHORT] = "Hit (Spell)";
[ITEM_MOD_HIT_TAKEN_MELEE_RATING_SHORT] = "Hit Avoidance (Melee)";
[ITEM_MOD_HIT_TAKEN_RANGED_RATING_SHORT] = "Hit Avoidance (Ranged)";
[ITEM_MOD_HIT_TAKEN_RATING_SHORT] = "Hit Avoidance";
[ITEM_MOD_HIT_TAKEN_SPELL_RATING_SHORT] = "Hit Avoidance (Spell)";
[ITEM_MOD_INSPIRATION_SHORT] = "Inspiration";
[ITEM_MOD_INTELLECT_SHORT] = "Intellect";
[ITEM_MOD_MANA_REGENERATION_SHORT] = "Mana Regeneration";
[ITEM_MOD_MANA_SHORT] = "Mana";
[ITEM_MOD_ITEM_MOD_MASTERY_RATING_SHORT_RATING_SHORT] = "ITEM_MOD_MASTERY_RATING_SHORT";
[ITEM_MOD_MELEE_ATTACK_POWER_SHORT] = "Melee Attack Power";
[ITEM_MOD_PARRY_RATING_SHORT] = "Parry";
[ITEM_MOD_PERCEPTION_SHORT] = "Perception";
[ITEM_MOD_POWER_REGEN0_SHORT] = "Mana Per 5 Sec.";
[ITEM_MOD_POWER_REGEN1_SHORT] = "Rage Per 5 Sec.";
[ITEM_MOD_POWER_REGEN2_SHORT] = "Focus Per 5 Sec.";
[ITEM_MOD_POWER_REGEN3_SHORT] = "Energy Per 5 Sec.";
[ITEM_MOD_POWER_REGEN4_SHORT] = "Happiness Per 5 Sec.";
[ITEM_MOD_POWER_REGEN5_SHORT] = "Runes Per 5 Sec.";
[ITEM_MOD_POWER_REGEN6_SHORT] = "Runic Power Per 5 Sec.";
[ITEM_MOD_PVP_POWER_SHORT] = "PvP Power";
[ITEM_MOD_PVP_PRIMARY_STAT_SHORT] = "PvP Power";
[ITEM_MOD_RANGED_ATTACK_POWER_SHORT] = "Ranged Attack Power";
[ITEM_MOD_RESILIENCE_RATING_SHORT] = "PvP Resilience";
[ITEM_MOD_RESOURCEFULNESS_SHORT] = "Resourcefulness";
[ITEM_MOD_SPELL_DAMAGE_DONE_SHORT] = "Bonus Damage";
[ITEM_MOD_SPELL_HEALING_DONE_SHORT] = "Bonus Healing";
[ITEM_MOD_SPELL_PENETRATION_SHORT] = "Spell Penetration";
[ITEM_MOD_SPELL_POWER_SHORT] = "Spell Power";
[ITEM_MOD_SPIRIT_SHORT] = "Spirit";
[ITEM_MOD_ITEM_MOD_STAMINA_SHORT_SHORT] = "ITEM_MOD_STAMINA_SHORT";
[ITEM_MOD_STRENGTH_SHORT] = "Strength";
[ITEM_MOD_ITEM_MOD_VERSATILITY] = "ITEM_MOD_VERSATILITY";
]]

local baseStatTemplates = {
    -- DEATH KNIGHT BLOOD --
    [250] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.77,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.67,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.57,
            [ITEM_MOD_STAMINA_SHORT] = 9.07,
            [ITEM_MOD_STRENGTH_SHORT] = 7.57,
            [ITEM_MOD_VERSATILITY] = 6.01,
        }
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.02,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.06,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.02,
            [ITEM_MOD_STRENGTH_SHORT] = 3.01,
            [ITEM_MOD_VERSATILITY] = 3.02,
        }
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.43,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.99,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.99,
            [ITEM_MOD_STRENGTH_SHORT] = 4.12,
            [ITEM_MOD_VERSATILITY] = 4.73,
        }
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7.58,
            [ITEM_MOD_CRIT_RATING_SHORT] = 7.02,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.72,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.21,
            [ITEM_MOD_VERSATILITY] = 7.17,
        }
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 6.15,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.59,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.05,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.05,
            [ITEM_MOD_VERSATILITY] = 5.65,
        }
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 6,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6,
            [ITEM_MOD_INTELLECT_SHORT] = 7.51,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.3,
            [ITEM_MOD_VERSATILITY] = 5.3,
        }
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7,
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.5,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.5,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6,
            [ITEM_MOD_VERSATILITY] = 5.5,
        }
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7.54,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.01,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.63,
            [ITEM_MOD_STAMINA_SHORT] = 7.82,
            [ITEM_MOD_VERSATILITY] = 6.04,
        }
    },
    -- DRUID RESTORATION --
    [105] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.57,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.59,
            [ITEM_MOD_INTELLECT_SHORT] = 7.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.61,
            [ITEM_MOD_VERSATILITY] = 6.54,
        }
    },
    -- EVOKER DEVASTATION --
    [1467] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 6.05,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6,
            [ITEM_MOD_HASTE_RATING_SHORT] = 7.51,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.3,
            [ITEM_MOD_VERSATILITY] = 5.3,
        }
    },
    -- EVOKER PRESERVATION --
    [1468] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.57,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.59,
            [ITEM_MOD_INTELLECT_SHORT] = 7.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.61,
            [ITEM_MOD_VERSATILITY] = 6.54,
        }
    },
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7.56,
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.16,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.06,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.04,
            [ITEM_MOD_VERSATILITY] = 6.02,
        }
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.13,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.12,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.66,
            [ITEM_MOD_VERSATILITY] = 4.6,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 8,
        }
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7.54,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.54,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.04,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3,
            [ITEM_MOD_VERSATILITY] = 4.13,
        }
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.7,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.5,
            [ITEM_MOD_INTELLECT_SHORT] = 7.03,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.02,
            [ITEM_MOD_VERSATILITY] = 4.7,
        }
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.4,
            [ITEM_MOD_INTELLECT_SHORT] = 6.15,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.8,
            [ITEM_MOD_VERSATILITY] = 4.8,
        }
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 7,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.56,
            [ITEM_MOD_INTELLECT_SHORT] = 7.55,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.01,
            [ITEM_MOD_VERSATILITY] = 6.08,
        }
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 3.9,
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.06,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.3,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.56,
            [ITEM_MOD_VERSATILITY] = 6.11,
        }
    },
    -- MONK MISTWEAVER --
    [270] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.01,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.01,
            [ITEM_MOD_INTELLECT_SHORT] = 7.51,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.51,
            [ITEM_MOD_VERSATILITY] = 4.51,
        }
    },
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7.57,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.3,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.57,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.57,
            [ITEM_MOD_VERSATILITY] = 6.07,
        }
    },
    -- PALADIN HOLY --
    [65] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.18,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.56,
            [ITEM_MOD_INTELLECT_SHORT] = 6.58,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.42,
            [ITEM_MOD_VERSATILITY] = 6.22,
        }
    },
    -- PALADIN PROTECTION --
    [66] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.85,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.07,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.26,
            [ITEM_MOD_STRENGTH_SHORT] = 7.57,
            [ITEM_MOD_VERSATILITY] = 5.26,
        }
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.59,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.12,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.11,
            [ITEM_MOD_STRENGTH_SHORT] = 7.57,
            [ITEM_MOD_VERSATILITY] = 4.58,
        }
    },
    -- PRIEST DISCIPLINE --
    [256] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.52,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.02,
            [ITEM_MOD_INTELLECT_SHORT] = 7.52,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.48,
            [ITEM_MOD_VERSATILITY] = 4.48,
        }
    },
    -- PRIEST HOLY --
    [257] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.72,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.11,
            [ITEM_MOD_INTELLECT_SHORT] = 7.52,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.11,
            [ITEM_MOD_VERSATILITY] = 5.72,
        }
    },
    -- PRIEST SHADOW --
    [258] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.01,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.12,
            [ITEM_MOD_INTELLECT_SHORT] = 7.12,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.51,
            [ITEM_MOD_VERSATILITY] = 4.04,
        }
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 6.93,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.04,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.22,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.63,
            [ITEM_MOD_VERSATILITY] = 5.45,
        }
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 5.46,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.31,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.18,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.69,
            [ITEM_MOD_VERSATILITY] = 4.72,
        }
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 5.69,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.31,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.89,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.72,
            [ITEM_MOD_VERSATILITY] = 4.72,
        }
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.05,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.05,
            [ITEM_MOD_INTELLECT_SHORT] = 5.56,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.96,
            [ITEM_MOD_VERSATILITY] = 4.05,
        }
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 1.51,
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.51,
            [ITEM_MOD_HASTE_RATING_SHORT] = 7.51,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.01,
            [ITEM_MOD_VERSATILITY] = 6.5,
        }
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.08,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.67,
            [ITEM_MOD_INTELLECT_SHORT] = 5.58,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.67,
            [ITEM_MOD_VERSATILITY] = 4.08,
        }
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.1,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.01,
            [ITEM_MOD_INTELLECT_SHORT] = 7.5,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6,
            [ITEM_MOD_VERSATILITY] = 3,
        }
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.51,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.92,
            [ITEM_MOD_INTELLECT_SHORT] = 6.98,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.51,
            [ITEM_MOD_VERSATILITY] = 5.09,
        }
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.26,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.41,
            [ITEM_MOD_INTELLECT_SHORT] = 6.42,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.41,
            [ITEM_MOD_VERSATILITY] = 4.61,
        }
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.29,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.3,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.6,
            [ITEM_MOD_STRENGTH_SHORT] = 2,
            [ITEM_MOD_VERSATILITY] = 2.7,
        }
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.6,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.15,
            [ITEM_MOD_STRENGTH_SHORT] = 2,
            [ITEM_MOD_VERSATILITY] = 2.78,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 7.5,
        }
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.67,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.08,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.24,
            [ITEM_MOD_STRENGTH_SHORT] = 4.83,
            [ITEM_MOD_VERSATILITY] = 5.67,
        }
    },
}

function GearHelper:LoadBaseStatTemplates()
    GearHelper.db.global.templates = baseStatTemplates
end