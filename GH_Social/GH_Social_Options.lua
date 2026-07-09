GH_Social_Options = {}
GH_Social_Options.__index = GH_Social_Options

local optionsTable = {
    name = "GH Social",
    type = "group",
    childGroups = "select",
    args = {
        autoInviteHeader = {
            order = 0,
            name = "Auto-invite",
            type = "header",
        },
        autoInviteGroup = {
            order = 1,
            name = " ",
            type = "group",
            inline = true,
            args = {
                autoInvite = {
                    order = 0,
                    name = "Auto-invite",
                    desc = "Invite automatiquement un joueur qui envoie le message d'invitation en /say ou en whisper",
                    type = "toggle",
                    width = "double",
                    set = function(_, val)
                        GH_Social.db.profile.autoInvite = val
                    end,
                    get = function()
                        return GH_Social.db.profile.autoInvite
                    end
                },
                inviteMessage = {
                    order = 1,
                    name = "Message d'invitation",
                    desc = "Le message qui déclenche l'auto-invite",
                    type = "input",
                    disabled = function()
                        return not GH_Social.db.profile.autoInvite
                    end,
                    set = function(_, val)
                        GH_Social:SetInviteMessage(val)
                    end,
                    get = function()
                        return GH_Social.db.profile.inviteMessage
                    end
                },
            }
        },
        alertsHeader = {
            order = 2,
            name = "Alertes",
            type = "header",
        },
        alertsGroup = {
            order = 3,
            name = " ",
            type = "group",
            inline = true,
            args = {
                whisperAlert = {
                    order = 0,
                    name = "Alerte whisper",
                    desc = "Joue un son quand vous recevez un whisper",
                    type = "toggle",
                    set = function(_, val)
                        GH_Social.db.profile.whisperAlert = val
                    end,
                    get = function()
                        return GH_Social.db.profile.whisperAlert
                    end
                },
                sayMyName = {
                    order = 1,
                    name = "Alerte mention",
                    desc = "Affiche une alerte quand votre nom est écrit dans un canal",
                    type = "toggle",
                    set = function(_, val)
                        GH_Social.db.profile.sayMyName = val
                    end,
                    get = function()
                        return GH_Social.db.profile.sayMyName
                    end
                },
                myNames = {
                    order = 2,
                    name = "Noms à surveiller",
                    desc = "Liste de noms séparés par des virgules",
                    type = "input",
                    width = "full",
                    disabled = function()
                        return not GH_Social.db.profile.sayMyName
                    end,
                    set = function(_, val)
                        if val then
                            GH_Social.db.global.myNames = tostring(val .. ",")
                        end
                    end,
                    get = function()
                        return GH_Social.db.global.myNames
                    end
                },
            }
        },
        lfrHeader = {
            order = 4,
            name = "Raid Finder",
            type = "header",
        },
        lfrGroup = {
            order = 5,
            name = " ",
            type = "group",
            inline = true,
            args = {
                bossesKilled = {
                    order = 0,
                    name = "Boss tués",
                    desc = "Affiche les boss déjà tués sur le panneau LFG",
                    type = "toggle",
                    set = function(_, val)
                        GH_Social.db.profile.bossesKilled = val
                        if not val then
                            GH_Social:HideLfrButtons(RaidFinderQueueFrame)
                            GH_Social:UnregisterEvent("LFG_UPDATE")
                            GH_Social:UnregisterEvent("READY_CHECK")
                        elseif RaidFinderQueueFrame then
                            GH_Social:CreateLfrButtons(RaidFinderQueueFrame)
                            GH_Social:UpdateButtonsAndTooltips(RaidFinderQueueFrame)
                            GH_Social:UpdateGHLfrButton()
                            GH_Social:UpdateSelectCursor()
                            GH_Social:RegisterEvent("LFG_UPDATE", GHSocialEvents.LFG_UPDATE)
                            GH_Social:RegisterEvent("READY_CHECK", GHSocialEvents.READY_CHECK)
                        end
                    end,
                    get = function()
                        return GH_Social.db.profile.bossesKilled
                    end
                },
            }
        },
    }
}

function GH_Social_Options:GenerateOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("GH_Social", optionsTable)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GH_Social", "Social", "GearHelper")
end
