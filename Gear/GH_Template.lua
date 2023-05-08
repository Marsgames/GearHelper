function GearHelper:GetStatFromActiveTemplate(statName)
    if (nil == self.db.profile.weightTemplate) then
        self:Print("WeightTemplate was nil, new value is NOX")
        self.db.profile.weightTemplate = "NOX"
    end

    if (self.db.profile.weightTemplate == "NOX" or self.db.profile.weightTemplate == "NOX_ByDefault") then
        local currentSpec = GetSpecializationInfo(GetSpecialization())
        return self.db.global.templates[currentSpec]["NOX"][statName] or 0
    else
        return self.db.profile.CW[self.db.profile.weightTemplate][statName] or 0
    end
end

function GearHelper:SetStatToActiveTemplate(statName, value)
    if (nil == self.db.profile.weightTemplate) then
        self:Print("WeightTemplate was nil, new value is NOX")
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
            [ITEM_MOD_STRENGTH_SHORT] = 4.07,
            [ITEM_MOD_STAMINA_SHORT] = -0.01,
            [ARMOR] = -0.04,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.88,
            [ITEM_MOD_VERSATILITY] = 2.16,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 21.09,
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.16,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = -0.03,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 3.48,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.75,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = -0.02,
        }
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 9.89,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 6.3,
            [ITEM_MOD_VERSATILITY] = 4.38,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 24.17,
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.38,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 5.93,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.48,
        }
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 10.53,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.39,
            [ITEM_MOD_VERSATILITY] = 4.93,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 44.7,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.03,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 7.59,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.1,
        }
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 8.48,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.46,
            [ITEM_MOD_VERSATILITY] = 4.07,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 40.44,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.82,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 8.08,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.44,
        }
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = {
            [ITEM_MOD_STAMINA_SHORT] = 0,
            [ITEM_MOD_AGILITY_SHORT] = 3.95,
            [ARMOR] = -0.01,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.88,
            [ITEM_MOD_VERSATILITY] = 1.93,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 21.47,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.98,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = 0,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 3.98,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.59,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = 0,
        }
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.47,
            [ITEM_MOD_VERSATILITY] = 3.84,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.41,
            [ITEM_MOD_SPELL_POWER_SHORT] = 7.41,
            [ITEM_MOD_INTELLECT_SHORT] = 8.17,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.35,
        }
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 8.49,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.52,
            [ITEM_MOD_VERSATILITY] = 4.05,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 48.52,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.94,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 8.07,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.31,
        }
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = {
            [ITEM_MOD_STAMINA_SHORT] = -0.02,
            [ITEM_MOD_AGILITY_SHORT] = 5.2,
            [ARMOR] = 0.51,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.87,
            [ITEM_MOD_VERSATILITY] = 2.46,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 23.34,
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.4,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 3.88,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.08,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = -0.02,
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
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.15,
            [ITEM_MOD_VERSATILITY] = 4.18,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.04,
            [ITEM_MOD_SPELL_POWER_SHORT] = 7.65,
            [ITEM_MOD_INTELLECT_SHORT] = 8.43,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.57,
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
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 8.96,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.88,
            [ITEM_MOD_VERSATILITY] = 4.14,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 51.61,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.02,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 8.54,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.26,
        }
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 9.58,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.11,
            [ITEM_MOD_VERSATILITY] = 4.11,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 46.82,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.56,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 9.13,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.21,
        }
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.55,
            [ITEM_MOD_VERSATILITY] = 3.91,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.65,
            [ITEM_MOD_SPELL_POWER_SHORT] = 7.25,
            [ITEM_MOD_INTELLECT_SHORT] = 8.66,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.53,
        }
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.31,
            [ITEM_MOD_VERSATILITY] = 4.11,
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.81,
            [ITEM_MOD_SPELL_POWER_SHORT] = 7.44,
            [ITEM_MOD_INTELLECT_SHORT] = 8.67,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.83,
        }
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.29,
            [ITEM_MOD_VERSATILITY] = 4.59,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.5,
            [ITEM_MOD_SPELL_POWER_SHORT] = 8.4,
            [ITEM_MOD_INTELLECT_SHORT] = 9.25,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.27,
        }
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = {
            [ITEM_MOD_STAMINA_SHORT] = -0.11,
            [ITEM_MOD_AGILITY_SHORT] = 3.59,
            [ARMOR] = -0.07,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.46,
            [ITEM_MOD_VERSATILITY] = 1.92,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 18.31,
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.07,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = -0.04,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 3.55,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.04,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = -0.03,
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
            [ITEM_MOD_STAMINA_SHORT] = 0.1,
            [ITEM_MOD_AGILITY_SHORT] = 7.03,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.78,
            [ITEM_MOD_VERSATILITY] = 3.14,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 30.39,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.04,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 6.71,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.54,
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
            [ITEM_MOD_STRENGTH_SHORT] = 5.82,
            [ITEM_MOD_STAMINA_SHORT] = -0.05,
            [ARMOR] = -0.07,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.49,
            [ITEM_MOD_VERSATILITY] = 2.48,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 31.43,
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.54,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = -0.06,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 5.19,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.77,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = -0.09,
        }
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 8.26,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.43,
            [ITEM_MOD_VERSATILITY] = 3.56,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 45.2,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.25,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 7.57,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.91,
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
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.18,
            [ITEM_MOD_VERSATILITY] = 4.42,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.35,
            [ITEM_MOD_SPELL_POWER_SHORT] = 8,
            [ITEM_MOD_INTELLECT_SHORT] = 8.81,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.51,
        }
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 8.66,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.06,
            [ITEM_MOD_VERSATILITY] = 3.79,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 47.19,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.29,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 8.24,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.01,
        }
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 7.6,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.12,
            [ITEM_MOD_VERSATILITY] = 3.12,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 38.93,
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.78,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 7.23,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.92,
        }
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 8.2,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 3.66,
            [ITEM_MOD_VERSATILITY] = 3.64,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 45.2,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.65,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 7.8,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.28,
        }
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.85,
            [ITEM_MOD_VERSATILITY] = 4.14,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.6,
            [ITEM_MOD_SPELL_POWER_SHORT] = 8.6,
            [ITEM_MOD_INTELLECT_SHORT] = 9.49,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.58,
        }
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 8.48,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.52,
            [ITEM_MOD_VERSATILITY] = 3.95,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 36.37,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.48,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 8.06,
            [ITEM_MOD_HASTE_RATING_SHORT] = 3.65,
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
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.17,
            [ITEM_MOD_VERSATILITY] = 4.48,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.54,
            [ITEM_MOD_SPELL_POWER_SHORT] = 8.67,
            [ITEM_MOD_INTELLECT_SHORT] = 9.56,
            [ITEM_MOD_HASTE_RATING_SHORT] = 5.02,
        }
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.42,
            [ITEM_MOD_VERSATILITY] = 4.48,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.26,
            [ITEM_MOD_SPELL_POWER_SHORT] = 8.97,
            [ITEM_MOD_INTELLECT_SHORT] = 9.88,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.01,
        }
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 5.62,
            [ITEM_MOD_VERSATILITY] = 4.85,
            [ITEM_MOD_CRIT_RATING_SHORT] = 5.14,
            [ITEM_MOD_SPELL_POWER_SHORT] = 9.47,
            [ITEM_MOD_INTELLECT_SHORT] = 10.41,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.44,
        }
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 8.38,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.45,
            [ITEM_MOD_VERSATILITY] = 3.94,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 42.61,
            [ITEM_MOD_CRIT_RATING_SHORT] = 4.45,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 7.04,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.43,
        }
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 7.45,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 4.71,
            [ITEM_MOD_VERSATILITY] = 3.82,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 25.81,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.2,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 6.33,
            [ITEM_MOD_HASTE_RATING_SHORT] = 4.01,
        }
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 5.09,
            [ITEM_MOD_STAMINA_SHORT] = -0.01,
            [ARMOR] = 0.29,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.41,
            [ITEM_MOD_VERSATILITY] = 2.66,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 28.05,
            [ITEM_MOD_CRIT_RATING_SHORT] = 3.5,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = 0.29,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 4.66,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.83,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = -0.01,
        }
    },
}

function GearHelper:LoadBaseStatTemplates()
    GearHelper.db.global.templates = baseStatTemplates
end