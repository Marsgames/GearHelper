--------------------------------------------------------------------------
--[[

http://lua-users.org/wiki/SortedIteration

Ordered table iterator, allow to iterate on the natural order of the keys of a
table.

Example:

t = {
   ['1'] = nil,
   ['2'] = nil,
   ['3'] = 'xxx',
   ['4'] = 'xxx',
   ['5'] = 'xxx',
}

print("Ordered iterating")
for key, val in orderedPairs(t) do
   print(key.." : "..val)
end

Output:
Ordered iterating
3: xxx
4: xxx
5: xxx
]]

function cmp_multitype(op1, op2)
    local type1, type2 = type(op1), type(op2)
    if type1 ~= type2 then --cmp by type
        return type1 < type2
    elseif type1 == "number" and type2 == "number"
        or type1 == "string" and type2 == "string" then
        return op1 < op2 --comp by default
    elseif type1 == "boolean" and type2 == "boolean" then
        return op1 == true
    else
        return tostring(op1) < tostring(op2) --cmp by address
    end
end

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex, cmp_multitype ) --### CANGE ###
    
	return orderedIndex
end

function orderedNext(t, state)
   -- Equivalent of the next function, but returns the keys in the alphabetic
   -- order. We use a temporary ordered key table that is stored in the
   -- table being iterated.
   
   --print("orderedNext: state = "..tostring(state) )
   if state == nil then
      -- the first time, generate the index
      t.__orderedIndex = __genOrderedIndex( t )
      key = t.__orderedIndex[1]
      
	  if key ~= "__orderedIndex" then
		return key, t[key]
	  end
   end
   -- fetch the next value
   key = nil
   for i = 1,table.getn(t.__orderedIndex) do
      if t.__orderedIndex[i] == state then
         key = t.__orderedIndex[i+1]
      end
   end
   
   if key and key ~= "__orderedIndex "then
   
    
	return key, t[key]
	
   end
   
   -- no more value to return, cleanup
   t.__orderedIndex = nil
   return
end

function orderedPairs(t)
   -- Equivalent of the pairs() function on tables. Allows to iterate
   -- in order
   return orderedNext, t, nil
end