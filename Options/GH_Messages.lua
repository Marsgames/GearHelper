local messagesTable = {
    name = GearHelper.locals["messages"],
    type = "group",
    args = {
        english = {
            order = 0,
            name = "English",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "english",
                    fontSize = "medium"
                },
                -- Rep2 = {
                --     order = 15,
                --     name = "",
                --     type = "input",
                --     width = "double",
                --     get = function(info)
                --         return GearHelper.db.global.messages.enUS.rep2
                --     end,
                --     set = function(info, val)
                --         GearHelper.db.global.messages.enUS.rep2 = val
                --     end
                -- },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.enUS = {}
                        GearHelper.db.global.messages.enUS.demande4 = GearHelper.locals["demande4enUS"]
                        GearHelper.db.global.messages.enUS.demande42 = GearHelper.locals["demande4enUS2"]
                        GearHelper.db.global.messages.enUS.rep = GearHelper.locals["repenUS"]
                        GearHelper.db.global.messages.enUS.rep2 = GearHelper.locals["repenUS2"]
                    end
                }
            }
        },
        french = {
            order = 1,
            name = "French",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.frFR.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.frFR.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.frFR.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.frFR.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.frFR.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.frFR.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "français",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.frFR.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.frFR.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.frFR = {}
                        GearHelper.db.global.messages.frFR.demande4 = GearHelper.locals["demande4frFR"]
                        GearHelper.db.global.messages.frFR.demande42 = GearHelper.locals["demande4frFR2"]
                        GearHelper.db.global.messages.frFR.rep = GearHelper.locals["repfrFR"]
                        GearHelper.db.global.messages.frFR.rep2 = GearHelper.locals["repfrFR2"]
                    end
                }
            }
        },
        German = {
            order = 2,
            name = "German",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.deDE.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.deDE.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.deDE.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.deDE.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.deDE.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.deDE.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "deutsch",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.deDE.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.deDE.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.deDE = {}
                        GearHelper.db.global.messages.deDE.demande4 = GearHelper.locals["demande4deDE"]
                        GearHelper.db.global.messages.deDE.demande42 = GearHelper.locals["demande4deDE2"]
                        GearHelper.db.global.messages.deDE.rep = GearHelper.locals["repdeDE"]
                        GearHelper.db.global.messages.deDE.rep2 = GearHelper.locals["repdeDE2"]
                    end
                }
            }
        },
        Spanish = {
            order = 3,
            name = "Spanish",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.esES.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esES.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.esES.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esES.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.esES.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esES.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "español",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.esES.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esES.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.esES = {}
                        GearHelper.db.global.messages.esES.demande4 = GearHelper.locals["demande4esES"]
                        GearHelper.db.global.messages.esES.demande42 = GearHelper.locals["demande4esES2"]
                        GearHelper.db.global.messages.esES.rep = GearHelper.locals["repesES"]
                        GearHelper.db.global.messages.esES.rep2 = GearHelper.locals["repesES2"]
                    end
                }
            }
        },
        Mexican = {
            order = 4,
            name = "Mexican",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.esMX.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esMX.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.esMX.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esMX.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.esMX.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esMX.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "español",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.esMX.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.esMX.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.esMX = {}
                        GearHelper.db.global.messages.esMX.demande4 = GearHelper.locals["demande4esMX"]
                        GearHelper.db.global.messages.esMX.demande42 = GearHelper.locals["demande4esMX2"]
                        GearHelper.db.global.messages.esMX.rep = GearHelper.locals["repesMX"]
                        GearHelper.db.global.messages.esMX.rep2 = GearHelper.locals["repesMX2"]
                    end
                }
            }
        },
        Italian = {
            order = 5,
            name = "Italian",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.itIT.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.itIT.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.itIT.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.itIT.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "italiano",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.itIT.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.itIT.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.itIT = {}
                        GearHelper.db.global.messages.itIT.demande4 = GearHelper.locals["demande4itIT"]
                        GearHelper.db.global.messages.itIT.demande42 = GearHelper.locals["demande4itIT2"]
                        GearHelper.db.global.messages.itIT.rep = GearHelper.locals["repitIT"]
                        GearHelper.db.global.messages.itIT.rep2 = GearHelper.locals["repitIT2"]
                    end
                }
            }
        },
        Korean = {
            order = 6,
            name = "Korean",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.koKR.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.koKR.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.koKR.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.koKR.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "한국어",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.koKR.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.koKR.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.koKR = {}
                        GearHelper.db.global.messages.koKR.demande4 = GearHelper.locals["demande4koKR"]
                        GearHelper.db.global.messages.koKR.demande42 = GearHelper.locals["demande4koKR2"]
                        GearHelper.db.global.messages.koKR.rep = GearHelper.locals["repkoKR"]
                        GearHelper.db.global.messages.koKR.rep2 = GearHelper.locals["repkoKR2"]
                    end
                }
            }
        },
        Portuguese = {
            order = 7,
            name = "Portuguese",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.ptBR.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.ptBR.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.ptBR.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.ptBR.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "Português",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.ptBR.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.ptBR.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.ptBR = {}
                        GearHelper.db.global.messages.ptBR.demande4 = GearHelper.locals["demande4ptBR"]
                        GearHelper.db.global.messages.ptBR.demande42 = GearHelper.locals["demande4ptBR2"]
                        GearHelper.db.global.messages.ptBR.rep = GearHelper.locals["repptBR"]
                        GearHelper.db.global.messages.ptBR.rep2 = GearHelper.locals["repptBR2"]
                    end
                }
            }
        },
        Russian = {
            order = 8,
            name = "Russian",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.ruRU.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.ruRU.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.ruRU.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.ruRU.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "русский",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.ruRU.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.ruRU.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.ruRU = {}
                        GearHelper.db.global.messages.ruRU.demande4 = GearHelper.locals["demande4ruRU"]
                        GearHelper.db.global.messages.ruRU.demande42 = GearHelper.locals["demande4ruRU2"]
                        GearHelper.db.global.messages.ruRU.rep = GearHelper.locals["repruRU"]
                        GearHelper.db.global.messages.ruRU.rep2 = GearHelper.locals["repruRU2"]
                    end
                }
            }
        },
        SimplifiedChinese = {
            order = 9,
            name = "Simplified Chinese",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.zhCN.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.zhCN.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.zhCN.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.zhCN.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "中文",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.zhCN.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.zhCN.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.zhCN = {}
                        GearHelper.db.global.messages.zhCN.demande4 = GearHelper.locals["demande4zhCN"]
                        GearHelper.db.global.messages.zhCN.demande42 = GearHelper.locals["demande4zhCN2"]
                        GearHelper.db.global.messages.zhCN.rep = GearHelper.locals["repzhCN"]
                        GearHelper.db.global.messages.zhCN.rep2 = GearHelper.locals["repzhCN2"]
                    end
                }
            }
        },
        TraditionalChinese = {
            order = 10,
            name = "Traditional Chinese",
            type = "group",
            args = {
                Ask1 = {
                    order = 0,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.enUS.demande4
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.enUS.demande4 = val
                    end
                },
                Empty1 = {
                    order = 1,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                ItemLink = {
                    order = 2,
                    type = "description",
                    name = "|cff1eff00|Hitem:36156:0:0:0:0:0:-18:1209139262:76:0:0:0:0|h[Wendigo Boots of Agility]|h|r",
                    fontSize = "medium"
                },
                Empty2 = {
                    order = 3,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Ask2 = {
                    order = 4,
                    name = "",
                    type = "input",
                    get = function(info)
                        return GearHelper.db.global.messages.zhTW.demande42
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.zhTW.demande42 = val
                    end
                },
                Empty7 = {
                    order = 5,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                QuestionMark = {
                    order = 6,
                    type = "description",
                    name = "?",
                    fontSize = "medium"
                },
                Empty8 = {
                    order = 7,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty3 = {
                    order = 8,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty4 = {
                    order = 9,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Header = {
                    order = 10,
                    type = "header",
                    name = "Answer"
                },
                Empty5 = {
                    order = 11,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Empty6 = {
                    order = 12,
                    type = "description",
                    name = "",
                    fontSize = "medium"
                },
                Rep = {
                    order = 13,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.zhTW.rep
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.zhTW.rep = val
                    end
                },
                myLang = {
                    order = 14,
                    type = "description",
                    name = "中文",
                    fontSize = "medium"
                },
                Rep2 = {
                    order = 15,
                    name = "",
                    type = "input",
                    width = "double",
                    get = function(info)
                        return GearHelper.db.global.messages.zhTW.rep2
                    end,
                    set = function(info, val)
                        GearHelper.db.global.messages.zhTW.rep2 = val
                    end
                },
                ResetButton = {
                    order = 16,
                    type = "execute",
                    name = "Reset",
                    func = function()
                        GearHelper.db.global.messages.zhTW = {}
                        GearHelper.db.global.messages.zhTW.demande4 = GearHelper.locals["demande4zhTW"]
                        GearHelper.db.global.messages.zhTW.demande42 = GearHelper.locals["demande4zhTW2"]
                        GearHelper.db.global.messages.zhTW.rep = GearHelper.locals["repzhTW"]
                        GearHelper.db.global.messages.zhTW.rep2 = GearHelper.locals["repzhTW2"]
                    end
                }
            }
        }
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["messages"], messagesTable)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(GearHelper.locals["messages"], GearHelper.locals["messages"], "GearHelper")

