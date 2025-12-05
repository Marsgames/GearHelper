---Check if the current specialization should be ignored
---@param currentSpec number Current specialization ID
---@return boolean True if the specialization should be ignored, false otherwise
local function SpecShouldBeIgnored(currentSpec)
    -- We want to ignore initial specs (default one when creating a new character)

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
        [1446] = true
    }

    return ignoredSpec[currentSpec] ~= nil
end

---Get stat value from the active template
---@param statName string Name of the statistic
---@return number Value of the statistic
function GearHelper:GetStatFromActiveTemplate(statName)
    if (nil == self.db.profile.weightTemplate) then
        self:Print("WeightTemplate was nil, new value is NOX", "template")
        self.db.profile.weightTemplate = "NOX"
    end

    if (self.db.profile.weightTemplate == "NOX" or self.db.profile.weightTemplate == "NOX_ByDefault") then
        local currentSpec = GetSpecializationInfo(GetSpecialization())

        if (SpecShouldBeIgnored(currentSpec)) then
            return 1
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

    return 1
end

---Save stat value to the active template
---Used to create custom templates
---@param statName string Name of the statistic
---@param value number Value of the statistic
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

--All available stats in 10.0.0 builds TODO: source?
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
            [ITEM_MOD_VERSATILITY] = 42.67,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 42.08,
            [ITEM_MOD_CRIT_RATING_SHORT] = 38.40,
            [ITEM_MOD_HASTE_RATING_SHORT] = 30.69,
            [ITEM_MOD_STRENGTH_SHORT] = 29.61
        }
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 71.28,
            [ITEM_MOD_CRIT_RATING_SHORT] = 70.98,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 67.66,
            [ITEM_MOD_VERSATILITY] = 66.09,
            [ITEM_MOD_STRENGTH_SHORT] = 41.93
        }
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 100.34,
            [ITEM_MOD_VERSATILITY] = 64.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 62.13,
            [ITEM_MOD_HASTE_RATING_SHORT] = 52.49,
            [ITEM_MOD_STRENGTH_SHORT] = 44.71
        }
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 57.70,
            [ITEM_MOD_CRIT_RATING_SHORT] = 54.79,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 54.10,
            [ITEM_MOD_HASTE_RATING_SHORT] = 41.80,
            [ITEM_MOD_AGILITY_SHORT] = 36.49
        }
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 30.52,
            [ITEM_MOD_CRIT_RATING_SHORT] = 27.60,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 25.42,
            [ITEM_MOD_HASTE_RATING_SHORT] = 21.90,
            [ITEM_MOD_AGILITY_SHORT] = 18.49
        }
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 64.55,
            [ITEM_MOD_VERSATILITY] = 63.05,
            [ITEM_MOD_HASTE_RATING_SHORT] = 57.60,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 53.45,
            [ITEM_MOD_INTELLECT_SHORT] = 41.77
        }
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 60.60,
            [ITEM_MOD_VERSATILITY] = 60.31,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 56.87,
            [ITEM_MOD_HASTE_RATING_SHORT] = 51.05,
            [ITEM_MOD_AGILITY_SHORT] = 38.31
        }
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 36.99,
            [ITEM_MOD_CRIT_RATING_SHORT] = 35.82,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 32.42,
            [ITEM_MOD_HASTE_RATING_SHORT] = 27.75,
            [ITEM_MOD_AGILITY_SHORT] = 23.54
        }
    },
    -- DRUID RESTORATION --
    [105] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.20,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 14.80,
            [ITEM_MOD_VERSATILITY] = 11.50,
            [ITEM_MOD_CRIT_RATING_SHORT] = 9.30
        }
    },
    -- EVOKER AUGMENTATION --
    [1473] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.80,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.50,
            [ITEM_MOD_VERSATILITY] = 8.30
        }
    },
    -- EVOKER DEVASTATION --
    [1467] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 53.81,
            [ITEM_MOD_VERSATILITY] = 52.43,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 47.33,
            [ITEM_MOD_HASTE_RATING_SHORT] = 38.64,
            [ITEM_MOD_INTELLECT_SHORT] = 37.91
        }
    },
    -- EVOKER PRESERVATION --
    [1468] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.80,
            [ITEM_MOD_HASTE_RATING_SHORT] = 11.50,
            [ITEM_MOD_VERSATILITY] = 9.30
        }
    },
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 83.08,
            [ITEM_MOD_CRIT_RATING_SHORT] = 81.60,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 80.47,
            [ITEM_MOD_VERSATILITY] = 66.88,
            [ITEM_MOD_AGILITY_SHORT] = 40.69
        }
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 64.49,
            [ITEM_MOD_VERSATILITY] = 59.57,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 59.42,
            [ITEM_MOD_HASTE_RATING_SHORT] = 53.53,
            [ITEM_MOD_AGILITY_SHORT] = 32.03
        }
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 68.22,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 63.56,
            [ITEM_MOD_CRIT_RATING_SHORT] = 61.66,
            [ITEM_MOD_HASTE_RATING_SHORT] = 55.99,
            [ITEM_MOD_AGILITY_SHORT] = 40.26
        }
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 58.66,
            [ITEM_MOD_VERSATILITY] = 58.52,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 57.90,
            [ITEM_MOD_HASTE_RATING_SHORT] = 52.83,
            [ITEM_MOD_INTELLECT_SHORT] = 41.14
        }
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 67.86,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 48.84,
            [ITEM_MOD_VERSATILITY] = 43.51,
            [ITEM_MOD_CRIT_RATING_SHORT] = 40.73,
            [ITEM_MOD_INTELLECT_SHORT] = 33.82
        }
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 64.14,
            [ITEM_MOD_CRIT_RATING_SHORT] = 63.32,
            [ITEM_MOD_HASTE_RATING_SHORT] = 47.85,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 43.69,
            [ITEM_MOD_INTELLECT_SHORT] = 40.36
        }
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 8.90,
            [ITEM_MOD_VERSATILITY] = 8.90,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 7.50,
            [ITEM_MOD_HASTE_RATING_SHORT] = 6.80
        }
    },
    -- MONK MISTWEAVER --
    [270] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.80,
            [ITEM_MOD_VERSATILITY] = 10.50,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 8.30
        }
    },
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 70.29,
            [ITEM_MOD_VERSATILITY] = 70.28,
            [ITEM_MOD_HASTE_RATING_SHORT] = 60.29,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 51.47,
            [ITEM_MOD_AGILITY_SHORT] = 37.09
        }
    },
    -- PALADIN HOLY --
    [65] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 14.50,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 11.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 10.80,
            [ITEM_MOD_VERSATILITY] = 9.50
        }
    },
    -- PALADIN PROTECTION --
    [66] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 30.14,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 28.17,
            [ITEM_MOD_CRIT_RATING_SHORT] = 27.34,
            [ITEM_MOD_HASTE_RATING_SHORT] = 21.39,
            [ITEM_MOD_STRENGTH_SHORT] = 19.72
        }
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 64.58,
            [ITEM_MOD_VERSATILITY] = 62.17,
            [ITEM_MOD_CRIT_RATING_SHORT] = 58.86,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 56.75,
            [ITEM_MOD_STRENGTH_SHORT] = 38.39
        }
    },
    -- PRIEST DISCIPLINE --
    [256] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 15.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.50,
            [ITEM_MOD_CRIT_RATING_SHORT] = 9.80,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 9.80,
            [ITEM_MOD_VERSATILITY] = 8.30
        }
    },
    -- PRIEST HOLY --
    [257] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 15.20,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.50,
            [ITEM_MOD_VERSATILITY] = 10.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 9.80
        }
    },
    -- PRIEST SHADOW --
    [258] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 69.90,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 62.59,
            [ITEM_MOD_VERSATILITY] = 61.14,
            [ITEM_MOD_HASTE_RATING_SHORT] = 58.01,
            [ITEM_MOD_INTELLECT_SHORT] = 41.80
        }
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 50.68,
            [ITEM_MOD_CRIT_RATING_SHORT] = 45.56,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 44.94,
            [ITEM_MOD_HASTE_RATING_SHORT] = 42.52,
            [ITEM_MOD_AGILITY_SHORT] = 32.74
        }
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 35.60,
            [ITEM_MOD_AGILITY_SHORT] = 29.12,
            [ITEM_MOD_CRIT_RATING_SHORT] = 28.65,
            [ITEM_MOD_HASTE_RATING_SHORT] = 24.33,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 22.74
        }
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = {
            [ITEM_MOD_CRIT_RATING_SHORT] = 42.93,
            [ITEM_MOD_VERSATILITY] = 42.13,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 38.09,
            [ITEM_MOD_AGILITY_SHORT] = 34.22,
            [ITEM_MOD_HASTE_RATING_SHORT] = 26.62
        }
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 68.45,
            [ITEM_MOD_CRIT_RATING_SHORT] = 60.79,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 56.06,
            [ITEM_MOD_HASTE_RATING_SHORT] = 50.91,
            [ITEM_MOD_INTELLECT_SHORT] = 44.87
        }
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 58.09,
            [ITEM_MOD_CRIT_RATING_SHORT] = 54.88,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 49.02,
            [ITEM_MOD_HASTE_RATING_SHORT] = 39.59,
            [ITEM_MOD_AGILITY_SHORT] = 37.75
        }
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 15.20,
            [ITEM_MOD_VERSATILITY] = 13.50,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.80,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 9.60
        }
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 64.83,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 61.47,
            [ITEM_MOD_HASTE_RATING_SHORT] = 58.48,
            [ITEM_MOD_CRIT_RATING_SHORT] = 58.05,
            [ITEM_MOD_INTELLECT_SHORT] = 41.29
        }
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 56.32,
            [ITEM_MOD_CRIT_RATING_SHORT] = 53.82,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 42.94,
            [ITEM_MOD_INTELLECT_SHORT] = 36.27,
            [ITEM_MOD_HASTE_RATING_SHORT] = 31.84
        }
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 66.18,
            [ITEM_MOD_HASTE_RATING_SHORT] = 64.71,
            [ITEM_MOD_CRIT_RATING_SHORT] = 61.74,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 59.96,
            [ITEM_MOD_INTELLECT_SHORT] = 41.96
        }
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 59.07,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 55.51,
            [ITEM_MOD_CRIT_RATING_SHORT] = 53.77,
            [ITEM_MOD_HASTE_RATING_SHORT] = 51.61,
            [ITEM_MOD_STRENGTH_SHORT] = 34.80
        }
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = {
            [ITEM_MOD_VERSATILITY] = 54.51,
            [ITEM_MOD_CRIT_RATING_SHORT] = 49.12,
            [ITEM_MOD_HASTE_RATING_SHORT] = 48.29,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 42.75,
            [ITEM_MOD_STRENGTH_SHORT] = 30.45
        }
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 15.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.50,
            [ITEM_MOD_CRIT_RATING_SHORT] = 10.80,
            [ITEM_MOD_VERSATILITY] = 10.50,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 8.20
        }
    }
}

---Load default stats template into the database
function GearHelper:LoadBaseStatTemplates()
    GearHelper.db.global.templates = baseStatTemplates
end
