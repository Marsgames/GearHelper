local function Header(text, order)
    return {
        order = order,
        type = "header",
        name = text
    }
end

local function Space(order)
    return {
        order = order,
        type = "description",
        name = " ",
        fontSize = "medium"
    }
end

local function Sample(text, order)
    local samp1 = {
        order = order,
        type = "description",
        name = "|cffffff00Sample: ",
        fontSize = "small"
    }
    local samp2 = {
        order = order + 0.1,
        type = "description",
        name = "    " .. text,
        fontSize = "small"
    }

    return samp1, samp2
end

local function GenerateTableForLang(languageName, msgDB, order, locale)
    local lang = {
        order = order,
        name = languageName,
        desc = "If your target is " .. languageName .. ", GearHelper will send this messages to him",
        type = "group",
        args = {
            QuestionTitle = Header("Question", 0),
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
            Empty1 = Space(3),
            Empty2 = Space(4),
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
            Empty3 = Space(8),
            Empty4 = Space(9),
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
            Empty4 = Space(12),
            Empty5 = Space(13),
            AnswerTitle = Header("Answer", 14),
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
            Empty6 = Space(17),
            Empty7 = Space(18),
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
            Empty8 = Space(22),
            Empty9 = Space(23),
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
