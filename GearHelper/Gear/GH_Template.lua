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
                return self.db.global.templates[currentSpec]["NOX"][statName] or 0
            end
        end
    else
        if (self.db.profile.CW[self.db.profile.weightTemplate] ~= nil) then
            return self.db.profile.CW[self.db.profile.weightTemplate][statName] or 0
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
            [ITEM_MOD_STRENGTH_SHORT] = 20.44,
            [ITEM_MOD_CRIT_RATING_SHORT] = 11.52,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 10.27,
            [ITEM_MOD_VERSATILITY] = 10.25,
            [ITEM_MOD_HASTE_RATING_SHORT] = 9.96
        }
    },
    -- DEATH KNIGHT FROST --
    [251] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 50.29,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 27.64,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.36,
            [ITEM_MOD_CRIT_RATING_SHORT] = 19.47,
            [ITEM_MOD_VERSATILITY] = 17.47
        }
    },
    -- DEATH KNIGHT UNHOLY --
    [252] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 43.80,
            [ITEM_MOD_CRIT_RATING_SHORT] = 23.89,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.36,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.78,
            [ITEM_MOD_VERSATILITY] = 16.18
        }
    },
    -- DEMON HUNTER HAVOC --
    [577] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 46.35,
            [ITEM_MOD_CRIT_RATING_SHORT] = 23.59,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 22.88,
            [ITEM_MOD_VERSATILITY] = 15.42,
            [ITEM_MOD_HASTE_RATING_SHORT] = 14.45
        }
    },
    -- DEMON HUNTER VENGEANCE --
    [581] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 28.82,
            [ITEM_MOD_CRIT_RATING_SHORT] = 14.25,
            [ITEM_MOD_HASTE_RATING_SHORT] = 13.62,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 13.46,
            [ITEM_MOD_VERSATILITY] = 13.41
        }
    },
    -- DEMON HUNTER DEVOURER --
    [1480] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 39.90,
            [ITEM_MOD_CRIT_RATING_SHORT] = 25.09,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.49,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 18.55,
            [ITEM_MOD_VERSATILITY] = 14.19
        }
    },
    -- DRUID BALANCE --
    [102] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 40.72,
            [ITEM_MOD_HASTE_RATING_SHORT] = 23.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 20.96,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 20.26,
            [ITEM_MOD_VERSATILITY] = 19.51
        }
    },
    -- DRUID FERAL --
    [103] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 45.32,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.75,
            [ITEM_MOD_CRIT_RATING_SHORT] = 22.37,
            [ITEM_MOD_VERSATILITY] = 22.22,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.44
        }
    },
    -- DRUID GUARDIAN --
    [104] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 27.71,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.46,
            [ITEM_MOD_VERSATILITY] = 12.06,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 11.89,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.78
        }
    },
    -- DRUID RESTORATION --
    [105] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 15.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.50,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 9.20,
            [ITEM_MOD_VERSATILITY] = 7.80,
            [ITEM_MOD_CRIT_RATING_SHORT] = 6.50
        }
    },
    -- EVOKER AUGMENTATION --
    [1473] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 20.62,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.64,
            [ITEM_MOD_CRIT_RATING_SHORT] = 10.48,
            [ITEM_MOD_VERSATILITY] = 7.64,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 0.74
        }
    },
    -- EVOKER DEVASTATION --
    [1467] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 41.05,
            [ITEM_MOD_CRIT_RATING_SHORT] = 21.61,
            [ITEM_MOD_HASTE_RATING_SHORT] = 20.40,
            [ITEM_MOD_VERSATILITY] = 20.04,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 19.39
        }
    },
    -- EVOKER PRESERVATION --
    [1468] = {
        ["NOX"] = {
            [ITEM_MOD_MASTERY_RATING_SHORT] = 17.20,
            [ITEM_MOD_INTELLECT_SHORT] = 15.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 10.50,
            [ITEM_MOD_VERSATILITY] = 8.30,
            [ITEM_MOD_CRIT_RATING_SHORT] = 7.90
        }
    },
    -- HUNTER BEAST MASTERY --
    [253] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 43.16,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.41,
            [ITEM_MOD_VERSATILITY] = 20.90,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 19.67,
            [ITEM_MOD_CRIT_RATING_SHORT] = 19.44
        }
    },
    -- HUNTER MARKSMANSHIP --
    [254] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 44.03,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 22.62,
            [ITEM_MOD_VERSATILITY] = 21.39,
            [ITEM_MOD_CRIT_RATING_SHORT] = 19.75,
            [ITEM_MOD_HASTE_RATING_SHORT] = 14.32
        }
    },
    -- HUNTER SURVIVAL --
    [255] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 43.64,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 26.14,
            [ITEM_MOD_CRIT_RATING_SHORT] = 25.49,
            [ITEM_MOD_HASTE_RATING_SHORT] = 24.42,
            [ITEM_MOD_VERSATILITY] = 20.18
        }
    },
    -- MAGE ARCANE --
    [62] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 39.88,
            [ITEM_MOD_CRIT_RATING_SHORT] = 18.98,
            [ITEM_MOD_VERSATILITY] = 17.98,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.93,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.83
        }
    },
    -- MAGE FIRE --
    [63] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 40.78,
            [ITEM_MOD_VERSATILITY] = 19.75,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 17.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 16.89,
            [ITEM_MOD_CRIT_RATING_SHORT] = 7.24
        }
    },
    -- MAGE FROST --
    [64] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 43.79,
            [ITEM_MOD_CRIT_RATING_SHORT] = 21.75,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.23,
            [ITEM_MOD_HASTE_RATING_SHORT] = 19.54,
            [ITEM_MOD_VERSATILITY] = 15.90
        }
    },
    -- MONK BREWMASTER --
    [268] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 30.38,
            [ITEM_MOD_CRIT_RATING_SHORT] = 15.06,
            [ITEM_MOD_VERSATILITY] = 14.06,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 12.46,
            [ITEM_MOD_HASTE_RATING_SHORT] = 2.84
        }
    },
    -- MONK MISTWEAVER --
    [270] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.50,
            [ITEM_MOD_VERSATILITY] = 11.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 8.30
        }
    },
    -- MONK WINDWALKER --
    [269] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 40.86,
            [ITEM_MOD_HASTE_RATING_SHORT] = 20.08,
            [ITEM_MOD_CRIT_RATING_SHORT] = 18.71,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 17.94,
            [ITEM_MOD_VERSATILITY] = 13.04
        }
    },
    -- PALADIN HOLY --
    [65] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 15.20,
            [ITEM_MOD_CRIT_RATING_SHORT] = 12.80,
            [ITEM_MOD_HASTE_RATING_SHORT] = 12.80,
            [ITEM_MOD_VERSATILITY] = 10.50
        }
    },
    -- PALADIN PROTECTION --
    [66] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 22.56,
            [ITEM_MOD_CRIT_RATING_SHORT] = 10.95,
            [ITEM_MOD_VERSATILITY] = 10.62,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 10.11,
            [ITEM_MOD_HASTE_RATING_SHORT] = 9.34
        }
    },
    -- PALADIN RETRIBUTION --
    [70] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 39.49,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 20.58,
            [ITEM_MOD_VERSATILITY] = 19.66,
            [ITEM_MOD_HASTE_RATING_SHORT] = 19.47
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
            [ITEM_MOD_MASTERY_RATING_SHORT] = 12.80,
            [ITEM_MOD_VERSATILITY] = 10.50,
            [ITEM_MOD_HASTE_RATING_SHORT] = 8.30
        }
    },
    -- PRIEST SHADOW --
    [258] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 40.77,
            [ITEM_MOD_CRIT_RATING_SHORT] = 24.46,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.63,
            [ITEM_MOD_HASTE_RATING_SHORT] = 21.10,
            [ITEM_MOD_VERSATILITY] = 20.26
        }
    },
    -- ROGUE ASSASSINATION --
    [259] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 40.18,
            [ITEM_MOD_CRIT_RATING_SHORT] = 22.52,
            [ITEM_MOD_VERSATILITY] = 19.08,
            [ITEM_MOD_HASTE_RATING_SHORT] = 18.67,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 17.05
        }
    },
    -- ROGUE OUTLAW --
    [260] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 46.13,
            [ITEM_MOD_CRIT_RATING_SHORT] = 22.97,
            [ITEM_MOD_VERSATILITY] = 21.25,
            [ITEM_MOD_HASTE_RATING_SHORT] = 18.44,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 14.61
        }
    },
    -- ROGUE SUBTLETY --
    [261] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 43.21,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 24.67,
            [ITEM_MOD_CRIT_RATING_SHORT] = 22.27,
            [ITEM_MOD_VERSATILITY] = 21.46,
            [ITEM_MOD_HASTE_RATING_SHORT] = 14.45
        }
    },
    -- SHAMAN ELEMENTAL --
    [262] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 48.40,
            [ITEM_MOD_CRIT_RATING_SHORT] = 26.97,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 24.48,
            [ITEM_MOD_VERSATILITY] = 22.20,
            [ITEM_MOD_HASTE_RATING_SHORT] = 21.82
        }
    },
    -- SHAMAN ENHANCEMENT --
    [263] = {
        ["NOX"] = {
            [ITEM_MOD_AGILITY_SHORT] = 39.73,
            [ITEM_MOD_CRIT_RATING_SHORT] = 22.01,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.92,
            [ITEM_MOD_HASTE_RATING_SHORT] = 20.68,
            [ITEM_MOD_VERSATILITY] = 19.80
        }
    },
    -- SHAMAN RESTORATION --
    [264] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 19.00,
            [ITEM_MOD_CRIT_RATING_SHORT] = 14.50,
            [ITEM_MOD_HASTE_RATING_SHORT] = 14.50,
            [ITEM_MOD_VERSATILITY] = 11.20,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 8.30
        }
    },
    -- WARLOCK AFFLICTION --
    [265] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 38.16,
            [ITEM_MOD_CRIT_RATING_SHORT] = 21.95,
            [ITEM_MOD_HASTE_RATING_SHORT] = 19.56,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 19.22,
            [ITEM_MOD_VERSATILITY] = 18.52
        }
    },
    -- WARLOCK DEMONOLOGY --
    [266] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 44.18,
            [ITEM_MOD_CRIT_RATING_SHORT] = 21.66,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 19.99,
            [ITEM_MOD_VERSATILITY] = 16.46,
            [ITEM_MOD_HASTE_RATING_SHORT] = 15.47
        }
    },
    -- WARLOCK DESTRUCTION --
    [267] = {
        ["NOX"] = {
            [ITEM_MOD_INTELLECT_SHORT] = 42.44,
            [ITEM_MOD_CRIT_RATING_SHORT] = 21.63,
            [ITEM_MOD_VERSATILITY] = 20.08,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 19.49,
            [ITEM_MOD_HASTE_RATING_SHORT] = 19.16
        }
    },
    -- WARRIOR ARMS --
    [71] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 35.83,
            [ITEM_MOD_CRIT_RATING_SHORT] = 23.71,
            [ITEM_MOD_HASTE_RATING_SHORT] = 22.80,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.49,
            [ITEM_MOD_VERSATILITY] = 19.18
        }
    },
    -- WARRIOR FURY --
    [72] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 36.33,
            [ITEM_MOD_CRIT_RATING_SHORT] = 21.61,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 21.29,
            [ITEM_MOD_HASTE_RATING_SHORT] = 21.13,
            [ITEM_MOD_VERSATILITY] = 20.04
        }
    },
    -- WARRIOR PROTECTION --
    [73] = {
        ["NOX"] = {
            [ITEM_MOD_STRENGTH_SHORT] = 29.68,
            [ITEM_MOD_CRIT_RATING_SHORT] = 14.29,
            [ITEM_MOD_HASTE_RATING_SHORT] = 13.16,
            [ITEM_MOD_MASTERY_RATING_SHORT] = 12.81,
            [ITEM_MOD_VERSATILITY] = 11.50
        }
    }
}

---Load default stats template into the database
function GearHelper:LoadBaseStatTemplates()
    GearHelper.db.global.templates = baseStatTemplates
end
