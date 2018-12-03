do	-- string.format prints nils now: %s -> %t
local format = string.format
	function strF(str, ...)
	  local args = {...}
	  local boolargs = {}
	  str = str:gsub("%%t", "%%%%t")
	  for i = #args, 1, -1 do
		--if type(args[i]) == "boolean" or  type(args[i]) == "nil" then
		  table.insert(boolargs, 1, args[i])
		--table.remove(args, i)
		--end
	  end
	  str = format(str, unpack(args))

	  local j = 0
	  return (str:gsub("%%t", function(spec) j = j + 1; return tostring(boolargs[j]) end))
	end
end

function wowUnit:expect(numTests)
    wowUnit.currentTestResults.expect = numTests;
end

function wowUnit:assert(value, message)
	
    if (value) then
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message.." Expected: true");
    end
end

function wowUnit:assertEquals(value1, value2, message)
	
    if (value1 == value2) then
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message);
    end
end

function wowUnit:assertNonEquals(value1, value2, message)

    if (value1 ~= value2) then
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message);
    end
end

function wowUnit:assertSame(value1, value2, message)
	
    if (type(value1) == "table" and type(value2) == "table") then
        if (wowUnit:DeepEquals(value1, value2)) then
            wowUnit:CurrentTestSucceeded(message);
        else
			value1 = tostring(value1)
			value2 = tostring(value2)
	
			wowUnit:CurrentTestFailed(message);
        end
    else
        wowUnit:assertEquals(value1, value2, message);
    end
end

function wowUnit:DeepEquals(table1, table2)
    if (table1 == table2) then
        return true;
    else
        for k, v1 in pairs(table1) do
            local v2 = table2[k];
            if v1 ~= v2 then
                if (type(v1) == "table" and type(v2) == "table") then
                    if not wowUnit:DeepEquals(v1, v2) then
                        return false;
                    end
                else
                    return false;
                end
            end
        end
        for k, v2 in pairs(table2) do
            local v1 = table1[k];
            if v1 ~= v2 then
                if (type(v1) == "table" and type(v2) == "table") then
                    if not wowUnit:DeepEquals(v1, v2) then
                        return false;
                    end
                else
                    return false;
                end
            end
        end
    end
    return true;
end

function wowUnit:isTable(value, message)
	
    if (type(value) == "table")then
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message)
    end
end

function wowUnit:isString(value, message)

    if (type(value) == "string") then
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message)
    end
end

function wowUnit:isNumber(value, message)
    if (type(value) == "number") then
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message)
    end
end

function wowUnit:isNil(value, message)
    if (type(value) == "nil") then 
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message)
    end
end

function wowUnit:isFunction(value, message)
    if (type(value) == "function") then 
        wowUnit:CurrentTestSucceeded(message);
    else
        wowUnit:CurrentTestFailed(message);
    end
end
