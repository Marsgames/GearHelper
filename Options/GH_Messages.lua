local function GenerateTableForLang(languageName, msgDB, order, locale)
    local lang = {
        order = order,
        name = languageName,
        desc = "If your target is " .. languageName .. ", GearHelper will send this messages to him",
        type = "group",
        args = {
            QuestionTitle = {
                order = 0,
                type = "header",
                name = "Question"
            },
            SampleDescription = {
                order = 1,
                type = "description",
                name = "|cffffff00Sample: ",
                fontSize = "small"
            },
            Sample = {
                order = 2,
                type = "description",
                name = "    " .. GearHelper.locals["demande4" .. locale] .. " |cff1eff00[random item]|h|r " .. GearHelper.locals["demande4" .. locale .. "2"] .. "?",
                fontSize = "small"
            },
            Empty1 = {
                order = 3,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Empty2 = {
                order = 4,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Ask1 = {
                order = 5,
                name = "",
                type = "input",
                width = "double",
                get = function(info)
                    return msgDB.demande4
                end,
                set = function(info, val)
                    msgDB.demande4 = val
                end
            },
            ItemLink = {
                order = 6,
                type = "description",
                name = "|cff1eff00[random item]|h|r",
                fontSize = "medium"
            },
            Ask2 = {
                order = 7,
                name = "",
                type = "input",
                width = "double",
                get = function(info)
                    return msgDB.demande42
                end,
                set = function(info, val)
                    msgDB.demande42 = val
                end
            },
            Empty3 = {
                order = 8,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Empty4 = {
                order = 9,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            ResultDescription = {
                order = 10,
                type = "description",
                name = "|cffffff00Result",
                fontSize = "small"
            },
            -- TODO: Update this message when Ask1 or Ask2 is updated
            ResultQuestion = {
                order = 11,
                type = "description",
                name = "    " .. tostring(msgDB.demande4) .. "|cff1eff00[random item]|h|r" .. tostring(msgDB.demande42) .. "?",
                fontSize = "small"
            },
            Empty4 = {
                order = 12,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Empty5 = {
                order = 13,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            AnswerTitle = {
                order = 14,
                type = "header",
                name = "Answer"
            },
            SampleAnsDescription = {
                order = 15,
                type = "description",
                name = "|cffffff00Sample: ",
                fontSize = "small"
            },
            SampleAns = {
                order = 16,
                type = "description",
                name = "    " .. GearHelper.locals["rep" .. locale] .. GearHelper.locals["maLangue" .. locale] .. GearHelper.locals["rep" .. locale .. "2"],
                fontSize = "small"
            },
            Empty6 = {
                order = 17,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Empty7 = {
                order = 18,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Answer1 = {
                order = 19,
                name = "",
                type = "input",
                width = "double",
                get = function(info)
                    return msgDB.rep
                end,
                set = function(info, val)
                    msgDB.rep = val
                end
            },
            myLanguage = {
                order = 20,
                type = "description",
                name = GearHelper.locals["maLangue" .. locale],
                fontSize = "medium"
            },
            Answer2 = {
                order = 21,
                name = "",
                type = "input",
                width = "double",
                get = function(info)
                    return msgDB.rep2
                end,
                set = function(info, val)
                    msgDB.rep2 = val
                end
            },
            Empty8 = {
                order = 22,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            Empty9 = {
                order = 23,
                type = "description",
                name = " ",
                fontSize = "medium"
            },
            ResultAnsDescription = {
                order = 24,
                type = "description",
                name = "|cffffff00Result",
                fontSize = "small"
            },
            -- TODO: Update this message when Answer1 or Answer2 is updated
            ResultAns = {
                order = 25,
                type = "description",
                name = "    " .. tostring(msgDB.rep) .. GearHelper.locals["maLangue" .. locale] .. tostring(msgDB.rep2),
                fontSize = "small"
            }
        }
    }

    return lang
end

function GHOptions:GenerateMessagesTable()
    local msg = GearHelper.db.global.messages
    local messagesTable = {
        name = GearHelper.locals["messages"],
        type = "group",
        args = {
            English = GenerateTableForLang("English", msg.enUS, 0, "enUS"),
            French = GenerateTableForLang("Français", msg.frFR, 1, "frFR"),
            German = GenerateTableForLang("Deutsch", msg.deDE, 2, "deDE"),
            Spanish = GenerateTableForLang("Español", msg.esES, 3, "esES"),
            Mexican = GenerateTableForLang("Español (Latinoamérica)", msg.esMX, 4, "esMX"),
            Italian = GenerateTableForLang("Italiano", msg.itIT, 5, "itIT"),
            Korean = GenerateTableForLang("한국어", msg.koKR, 6, "koKR"),
            Portuguese = GenerateTableForLang("Português", msg.ptBR, 7, "ptBR"),
            Russian = GenerateTableForLang("Русский", msg.ruRU, 8, "ruRU"),
            SimplifiedChinese = GenerateTableForLang("简体中文", msg.zhCN, 9, "zhCN"),
            TraditionalChinese = GenerateTableForLang("繁體中文", msg.zhTW, 10, "zhTW")
        }
    }
    return messagesTable
end
