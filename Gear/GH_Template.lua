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
            [ITEM_MOD_ATTACK_POWER_SHORT] = 0.45,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.17,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 2.69,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.39,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.4,
            [ITEM_MOD_STRENGTH_SHORT] = 0.53,
            [ITEM_MOD_VERSATILITY] = 0.39,
        }
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.35,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 9.21,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.1,
            [ITEM_MOD_VERSATILITY] = 1.56,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.88,
            [ITEM_MOD_AGILITY_SHORT] = 2.04,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.6,
        }
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 1.82,
            [ITEM_MOD_VERSATILITY] = 1.61,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = -0.02,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.8,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.23,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.74,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = -0.02,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.17,
            [ITEM_MOD_STAMINA_SHORT] = -0.03,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 9.92,
            [ARMOR] =  -0.02,
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
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.8,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.12,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.02,
            [ITEM_MOD_AGILITY_SHORT] = 1.18,
            [ITEM_MOD_VERSATILITY] = 0.88,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 6.72,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.53,
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
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.73,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.16,
            [ITEM_MOD_VERSATILITY] = 0.98,
            [ITEM_MOD_AGILITY_SHORT] = 1.21,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.6,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.95,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 3.36,
        }
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 1.4,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.71,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.38,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.79,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 8.06,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.35,
            [ITEM_MOD_VERSATILITY] = 1.06,
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
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.41,
            [ITEM_MOD_VERSATILITY] = 0.33,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.31,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0,
            [ITEM_MOD_SPELL_POWER_SHORT] = 0.43,
            [ITEM_MOD_INTELLECT_SHORT] = 0.48,
        }
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 0.9,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.44,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.46,
            [ITEM_MOD_SPELL_POWER_SHORT] = 0.81,
            [ITEM_MOD_VERSATILITY] = 0.68,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.66,
        }
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.68,
            [ITEM_MOD_SPELL_POWER_SHORT] = 0.85,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.33,
            [ITEM_MOD_INTELLECT_SHORT] = 0.94,
            [ITEM_MOD_VERSATILITY] = 0.85,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.76,
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
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = {
            [ITEM_MOD_ATTACK_POWER_SHORT] = 0.96,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.87,
            [ITEM_MOD_VERSATILITY] = 0.76,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.03,
            [ITEM_MOD_STAMINA_SHORT] = -0.02,
            [ITEM_MOD_AGILITY_SHORT] = 1.03,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.45,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 4.09,
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
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.33,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = 0.01,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.98,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.97,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 7.93,
            [ITEM_MOD_STRENGTH_SHORT] = 1.36,
            [ARMOR] =  0.01,
            [ITEM_MOD_VERSATILITY] = 1.34,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = 0.01,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.29,
            [ITEM_MOD_STAMINA_SHORT] = 0.01,
        }
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.63,
            [ITEM_MOD_VERSATILITY] = 1.51,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.82,
            [ITEM_MOD_STRENGTH_SHORT] = 1.91,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.28,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.48,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 10.74,
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
            [ITEM_MOD_SPELL_POWER_SHORT] = 1.54,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.22,
            [ITEM_MOD_VERSATILITY] = 1.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.98,
            [ITEM_MOD_INTELLECT_SHORT] = 1.73,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.64,
        }
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.14,
            [ITEM_MOD_AGILITY_SHORT] = 1.77,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.13,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 8.1,
            [ITEM_MOD_VERSATILITY] = 1.27,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.34,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.65,
        }
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.52,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.09,
            [ITEM_MOD_AGILITY_SHORT] = 1.32,
            [ITEM_MOD_VERSATILITY] = 1,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.92,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 6.04,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.23,
        }
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 1.93,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.25,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 9.35,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.66,
            [ITEM_MOD_VERSATILITY] = 1.39,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.8,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.1,
        }
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = {
            [ITEM_MOD_SPELL_POWER_SHORT] = 1.5,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.11,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.89,
            [ITEM_MOD_INTELLECT_SHORT] = 1.65,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.6,
            [ITEM_MOD_VERSATILITY] = 1.08,
        }
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = {
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 5.32,
            [ITEM_MOD_AGILITY_SHORT] = 1.1,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.66,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.91,
            [ITEM_MOD_VERSATILITY] = 0.96,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.71,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.03,
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
            [ITEM_MOD_INTELLECT_SHORT] = 1.13,
            [ITEM_MOD_VERSATILITY] = 0.77,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.76,
            [ITEM_MOD_SPELL_POWER_SHORT] = 1.03,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.75,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.01,
        }
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 1,
            [ITEM_MOD_STAMINA_SHORT] = 0.02,
            [ITEM_MOD_VERSATILITY] = 1.1,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.05,
            [ITEM_MOD_SPELL_POWER_SHORT] = 1.18,
            [ITEM_MOD_INTELLECT_SHORT] = 1.33,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.46,
        }
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 2.49,
            [ITEM_MOD_CRIT_RATING_SHORT] = 1.92,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.39,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 2.12,
            [ITEM_MOD_VERSATILITY] = 2,
            [ITEM_MOD_SPELL_POWER_SHORT] = 2.25,
        }
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.74,
            [ITEM_MOD_HASTE_RATING_SHORT] = 1.09,
            [ITEM_MOD_VERSATILITY] = 0.99,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.01,
            [ITEM_MOD_STRENGTH_SHORT] = 1.1,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.05,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 6.27,
        }
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = {
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 2.92,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.01,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 0.75,
            [ITEM_MOD_HASTE_RATING_SHORT] = 0.45,
            [ITEM_MOD_CRIT_RATING_SHORT] = 0.92,
            [ITEM_MOD_STRENGTH_SHORT] = 0.81,
            [ITEM_MOD_VERSATILITY] = 0.81,
        }
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 2.34,
            [ARMOR] =  0.57,
            [ITEM_MOD_VERSATILITY] = 1.81,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 1.37,
            [ITEM_MOD_ATTACK_POWER_SHORT] = 1.83,
            [ITEM_MOD_STRENGTH_SHORT] = 1.33,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.23,
            [ITEM_MOD_STAMINA_SHORT] = 0.42,
            [ITEM_MOD_EXTRA_ARMOR_SHORT] = 0.54,
            [ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 8.29,
            [ITEM_MOD_CR_LIFESTEAL_SHORT] = 0.47,
        }
    },
}

function GearHelper:LoadBaseStatTemplates()
    GearHelper.db.global.templates = baseStatTemplates
end