local function GetDebugChatFrame()
    local found
    for i = 1, NUM_CHAT_WINDOWS do
        local name = GetChatWindowInfo(i)
        if name == "GH Debug" then
            found = i
            break
        end
    end

    if found then
        return _G["ChatFrame" .. found]
    else
        return FCF_OpenNewWindow("GH Debug", true)
    end
end

local function WriteMessage(self, msg)
    GetDebugChatFrame():AddMessage(msg)
end

local function DevTools_InitFunctionCache(context)
    local ret = {}

    for _, k in ipairs(DT.functionSymbols) do
        local v = getglobal(k)
        if (type(v) == "function") then
            ret[v] = "[" .. k .. "]"
        end
    end

    for k, v in pairs(getfenv(0)) do
        if (type(v) == "function") then
            if (not ret[v]) then
                ret[v] = "[" .. k .. "]"
            end
        end
    end

    return ret
end

local function DevTools_InitUserdataCache(context)
    local ret = {}

    for _, k in ipairs(DT.userdataSymbols) do
        local v = getglobal(k)
        if (type(v) == "table") then
            local u = rawget(v, 0)
            if (type(u) == "userdata") then
                ret[u] = k .. "[0]"
            end
        end
    end

    for k, v in pairs(getfenv(0)) do
        if (type(v) == "table") then
            local u = rawget(v, 0)
            if (type(u) == "userdata") then
                if (not ret[u]) then
                    ret[u] = k .. "[0]"
                end
            end
        end
    end

    return ret
end

local function DevTools_Cache_Function(self, value, newName)
    if (not self.fCache) then
        self.fCache = DevTools_InitFunctionCache(self)
    end
    local name = self.fCache[value]
    if ((not name) and newName) then
        self.fCache[value] = newName
    end
    return name
end

local function DevTools_Cache_Userdata(self, value, newName)
    if (not self.uCache) then
        self.uCache = DevTools_InitUserdataCache(self)
    end
    local name = self.uCache[value]
    if ((not name) and newName) then
        self.uCache[value] = newName
    end
    return name
end

local function DevTools_Cache_Table(self, value, newName)
    if (not self.tCache) then
        self.tCache = {}
    end
    local name = self.tCache[value]
    if ((not name) and newName) then
        self.tCache[value] = newName
    end
    return name
end

local function DevTools_Cache_Nil(self, value, newName)
    return nil
end

local function Pick_Cache_Function(func, setting)
    if (setting) then
        return func
    else
        return DevTools_Cache_Nil
    end
end

function GearHelper:DevToolsDump(value, startKey)
    local context = {
        depth = 0,
        key = startKey
    }

    context.GetTableName = Pick_Cache_Function(DevTools_Cache_Table, DEVTOOLS_USE_TABLE_CACHE)
    context.GetFunctionName = Pick_Cache_Function(DevTools_Cache_Function, DEVTOOLS_USE_FUNCTION_CACHE)
    context.GetUserdataName = Pick_Cache_Function(DevTools_Cache_Userdata, DEVTOOLS_USE_USERDATA_CACHE)
    context.Write = WriteMessage

    DevTools_RunDump(value, context)
end

function GearHelper:Print(object)
    local file, ln = strmatch(debugstack(2, 1, 0), "([%w_]*%.lua).*%:(%d+)")

    if (GearHelper.db.profile.debug) then
        if type(object) == "table" then
            GetDebugChatFrame():AddMessage(WrapTextInColorCode("[GearHelper] ", "FF00FF96") .. WrapTextInColorCode(tostring(file) .. ":" .. tostring(ln), "FF9482C9") .. "\n-------------- TABLE --------------\n")
            GearHelper:DevToolsDump(object)
            GetDebugChatFrame():AddMessage("-------------- ENDTABLE -----------")
        else
            GetDebugChatFrame():AddMessage(WrapTextInColorCode("[GearHelper] ", "FF00FF96") .. WrapTextInColorCode(tostring(file) .. ":" .. tostring(ln), "FF9482C9") .. " - " .. tostring(object))
        end
    end
end
