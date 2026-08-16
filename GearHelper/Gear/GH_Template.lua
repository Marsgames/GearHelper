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
            [ITEM_MOD_STRENGTH_SHORT] = 29.16,
            [ITEM_MOD_CRIT_RATING_SHORT] = 23.05,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 20.22,
            [ITEM_MOD_VERSATILITY] = 20.03,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.52
        }
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 63.01,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 48.79,
            [ITEM_MOD_HASTE_RATING_SHORT] = 46.72,
            [ITEM_MOD_CRIT_RATING_SHORT] = 41.10,
            [ITEM_MOD_VERSATILITY] = 12.71
        }
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 54.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 40.40,
            [ITEM_MOD_CRIT_RATING_SHORT] = 38.05,
            [ITEM_MOD_HASTE_RATING_SHORT] = 31.30,
            [ITEM_MOD_VERSATILITY] = 19.02
        }
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 51.13,
            [ITEM_MOD_CRIT_RATING_SHORT] = 36.94,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 34.62,
            [ITEM_MOD_HASTE_RATING_SHORT] = 33.58,
            [ITEM_MOD_VERSATILITY] = 25.81
        }
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 33.75,
            [ITEM_MOD_CRIT_RATING_SHORT] = 23.05,
            [ITEM_MOD_VERSATILITY] = 21.86,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.37,
            [ITEM_MOD_HASTE_RATING_SHORT] = 20.18
        }
    },
    -- DEMON HUNTER DEVOURER --
    [1480] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 57.68,
            [ITEM_MOD_HASTE_RATING_SHORT] = 51.03,
            [ITEM_MOD_CRIT_RATING_SHORT] = 39.90,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 37.17,
            [ITEM_MOD_VERSATILITY] = 30.52
        }
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 51.63,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 34.57,
            [ITEM_MOD_HASTE_RATING_SHORT] = 31.74,
            [ITEM_MOD_CRIT_RATING_SHORT] = 26.87,
            [ITEM_MOD_VERSATILITY] = 19.53
        }
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 48.10,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 32.58,
            [ITEM_MOD_HASTE_RATING_SHORT] = 32.35,
            [ITEM_MOD_VERSATILITY] = 32.32,
            [ITEM_MOD_CRIT_RATING_SHORT] = 30.24
        }
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 27.94,
            [ITEM_MOD_HASTE_RATING_SHORT] = 23.65,
            [ITEM_MOD_VERSATILITY] = 17.60,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.74,
            [ITEM_MOD_CRIT_RATING_SHORT] = 14.97
        }
    },
    -- DRUID RESTORATION --
    [105] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.20,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 12.80,
            [ITEM_MOD_VERSATILITY] = 10.50,
            [ITEM_MOD_CRIT_RATING_SHORT] = 9.30
        }
    },
    -- EVOKER AUGMENTATION --
    [1473] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 15.82,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.63,
            [ITEM_MOD_VERSATILITY] = 9.83,
            [ITEM_MOD_CRIT_RATING_SHORT] = 8.52,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.53
        }
    },
    -- EVOKER DEVASTATION --
    [1467] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 56.96,
            [ITEM_MOD_VERSATILITY] = 33.15,
            [ITEM_MOD_HASTE_RATING_SHORT] = 32.81,
            [ITEM_MOD_CRIT_RATING_SHORT] = 32.31,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 31.64
        }
    },
    -- EVOKER PRESERVATION --
    [1468] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.50,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.30,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.80,
            [ITEM_MOD_VERSATILITY] = 9.20
        }
    },
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 57.72,
            [ITEM_MOD_HASTE_RATING_SHORT] = 46.72,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 35.52,
            [ITEM_MOD_CRIT_RATING_SHORT] = 34.16,
            [ITEM_MOD_VERSATILITY] = 27.61
        }
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 55.78,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 36.44,
            [ITEM_MOD_CRIT_RATING_SHORT] = 34.90,
            [ITEM_MOD_HASTE_RATING_SHORT] = 34.81,
            [ITEM_MOD_VERSATILITY] = 25.73
        }
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 55.58,
            [ITEM_MOD_HASTE_RATING_SHORT] = 48.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 43.21,
            [ITEM_MOD_CRIT_RATING_SHORT] = 41.13,
            [ITEM_MOD_VERSATILITY] = 25.76
        }
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 49.53,
            [ITEM_MOD_VERSATILITY] = 30.41,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 29.02,
            [ITEM_MOD_CRIT_RATING_SHORT] = 28.15,
            [ITEM_MOD_HASTE_RATING_SHORT] = 25.61
        }
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 57.63,
            [ITEM_MOD_VERSATILITY] = 34.29,
            [ITEM_MOD_HASTE_RATING_SHORT] = 31.44,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 30.48,
            [ITEM_MOD_CRIT_RATING_SHORT] = 17.21
        }
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 54.30,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 32.13,
            [ITEM_MOD_CRIT_RATING_SHORT] = 31.14,
            [ITEM_MOD_HASTE_RATING_SHORT] = 30.73,
            [ITEM_MOD_VERSATILITY] = 19.21
        }
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 22.20,
            [ITEM_MOD_VERSATILITY] = 13.67,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.82,
            [ITEM_MOD_HASTE_RATING_SHORT] = 11.90,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 11.43
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
            [ITEM_MOD_AGILITY_SHORT] = 42.94,
            [ITEM_MOD_HASTE_RATING_SHORT] = 30.55,
            [ITEM_MOD_CRIT_RATING_SHORT] = 28.57,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 27.22,
            [ITEM_MOD_VERSATILITY] = 23.00
        }
    },
    -- PALADIN HOLY --
    [65] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.30,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.70,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.70,
            [ITEM_MOD_VERSATILITY] = 10.50
        }
    },
    -- PALADIN PROTECTION --
    [66] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 31.68,
            [ITEM_MOD_HASTE_RATING_SHORT] = 19.59,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 19.02,
            [ITEM_MOD_CRIT_RATING_SHORT] = 17.41,
            [ITEM_MOD_VERSATILITY] = 14.61
        }
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 42.41,
            [ITEM_MOD_HASTE_RATING_SHORT] = 35.06,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 30.05,
            [ITEM_MOD_CRIT_RATING_SHORT] = 27.10,
            [ITEM_MOD_VERSATILITY] = 20.45
        }
    },
    -- PRIEST DISCIPLINE --
    [256] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.80,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 9.50,
            [ITEM_MOD_VERSATILITY] = 8.30
        }
    },
    -- PRIEST HOLY --
    [257] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 15.20,
            [ITEM_MOD_VERSATILITY] = 14.80,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 12.50,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.30
        }
    },
    -- PRIEST SHADOW --
    [258] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 62.88,
            [ITEM_MOD_CRIT_RATING_SHORT] = 37.40,
            [ITEM_MOD_HASTE_RATING_SHORT] = 33.66,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 31.38,
            [ITEM_MOD_VERSATILITY] = 24.41
        }
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 58.05,
            [ITEM_MOD_HASTE_RATING_SHORT] = 39.14,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 36.46,
            [ITEM_MOD_CRIT_RATING_SHORT] = 32.87,
            [ITEM_MOD_VERSATILITY] = 25.65
        }
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 59.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 40.81,
            [ITEM_MOD_VERSATILITY] = 37.12,
            [ITEM_MOD_CRIT_RATING_SHORT] = 33.84,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 25.14
        }
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 67.12,
            [ITEM_MOD_HASTE_RATING_SHORT] = 50.53,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 45.77,
            [ITEM_MOD_VERSATILITY] = 44.41,
            [ITEM_MOD_CRIT_RATING_SHORT] = 33.23
        }
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 61.90,
            [ITEM_MOD_CRIT_RATING_SHORT] = 42.60,
            [ITEM_MOD_HASTE_RATING_SHORT] = 39.73,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 36.38,
            [ITEM_MOD_VERSATILITY] = 29.99
        }
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 57.52,
            [ITEM_MOD_CRIT_RATING_SHORT] = 36.34,
            [ITEM_MOD_HASTE_RATING_SHORT] = 35.55,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 34.22,
            [ITEM_MOD_VERSATILITY] = 21.47
        }
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 15.20,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.50,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 10.80,
            [ITEM_MOD_VERSATILITY] = 10.80
        }
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 53.30,
            [ITEM_MOD_HASTE_RATING_SHORT] = 33.59,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 32.77,
            [ITEM_MOD_CRIT_RATING_SHORT] = 32.12,
            [ITEM_MOD_VERSATILITY] = 27.16
        }
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 48.38,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 27.80,
            [ITEM_MOD_HASTE_RATING_SHORT] = 27.31,
            [ITEM_MOD_CRIT_RATING_SHORT] = 25.99,
            [ITEM_MOD_VERSATILITY] = 23.92
        }
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 62.54,
            [ITEM_MOD_CRIT_RATING_SHORT] = 39.88,
            [ITEM_MOD_HASTE_RATING_SHORT] = 32.73,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 31.46,
            [ITEM_MOD_VERSATILITY] = 24.82
        }
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 47.45,
            [ITEM_MOD_HASTE_RATING_SHORT] = 44.18,
            [ITEM_MOD_CRIT_RATING_SHORT] = 35.59,
            [ITEM_MOD_VERSATILITY] = 34.87,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 34.09
        }
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = {
            [ITEM_MOD_HASTE_RATING_SHORT] = 47.33,
            [ITEM_MOD_STRENGTH_SHORT] = 46.25,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 38.29,
            [ITEM_MOD_VERSATILITY] = 36.36,
            [ITEM_MOD_CRIT_RATING_SHORT] = 27.26
        }
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 28.87,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.51,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 16.99,
            [ITEM_MOD_VERSATILITY] = 15.76,
            [ITEM_MOD_CRIT_RATING_SHORT] = 13.34
        }
    }
}

---Load default stats template into the database
function GearHelper:LoadBaseStatTemplates()
    GearHelper.db.global.templates = baseStatTemplates
end
