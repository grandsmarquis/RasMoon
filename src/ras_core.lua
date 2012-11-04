--[[

Copyright (C) 2011-2012 RasMoon Developpement team

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.


]]--   

RasMoon = {}
RasMoon.CONDITIONS = {}
RasMoon.EXPRESSIONS = {}

local key, value

local function incremental(string)
   --this is X++ and X--
   string = string:gsub("(%w+)(%+%+)", "%1 = %1 + 1;")
   string = string:gsub("(%w+)(%-%-)", "%1 = %1 - 1;")
   --this is += -= *= /=
   string = string:gsub("(%w+) +(%+=) +(%w+)", "%1 = %1 + %3;")
   string = string:gsub("(%w+) +(%-=) +(%w+)", "%1 = %1 - %3;")
   string = string:gsub("(%w+) +(%*=) +(%w+)", "%1 = %1 * %3;")
   string = string:gsub("(%w+) +(/=) +(%w+)", "%1 = %1 / %3;")
   return (string)
end

--TODO: split with \n for return
local function stringtofunc(string, ret)
   local res
   ret = ret or false
   if "string" == Type { string } then
      if ret then
	 res = (loadstring("return(" .. string .. ")"))
      else
	 string = incremental(string)
	 res = (loadstring(string))
      end
      if nil == res then
	 error("Lua error in string to function.")
      end
      return (res)
   elseif "function" == Type { string } then
      return (string)
   else
      error("Bad type to transform in a function.")
   end
end

Type = function(param)
	  if (param == nil or param[1] == nil) then return ("nill") end
	  if nil ~= RasMoon.CONDITIONS[param[1]] then
	     return "condition"
	  elseif nil ~= RasMoon.EXPRESSIONS[param[1]] then
	     return "expression"
	  else
	     return (type(param[1]))
	  end
       end

Condition = function(param)
	       assert(nil ~= param and type(param) == "table" and nil ~= param[1] and nil ~= param[2])
	       RasMoon.CONDITIONS[param[1]] = stringtofunc(param[2], true)
	    end

Expression = function(param)
		assert(nil ~= param and type(param) == "table" and nil ~= param[1] and nil ~= param[2])
		RasMoon.EXPRESSIONS[param[1]] = stringtofunc(param[2])
	     end

Group = function(param)
	assert(nil ~= param and type(param) == "table")
	local res = function() 
		       for i,v in ipairs(param) do
			  local action
			  if "expression" == Type { v } then
			     action = RasMoon.EXPRESSIONS[v]
			  elseif "function" == Type { v } then
			     action = v
			  elseif "string" == Type { v } then
			     action = stringtofunc(v)
			  else
			     error("Param " .. i .. " of Do")
			  end
			  action()
		       end
		    end
	return (res)
     end

Do = function(param)
	local res = Group(param)
	res()
     end

While = function(param)
	 assert(nil ~= param and type(param) == "table" and nil ~= param[1] and nil ~= param[2])
	 local cond, expr
	 if "condition" == Type { param[1] } then
	    cond = RasMoon.CONDITIONS[param[1]]
	 elseif "function" == Type { param[1] } then
	    cond = param[1]
	 elseif "string" == Type { param[1] } then
	    cond = stringtofunc(param[1], true)
	 else
	    error("Invalid arg #1 for while")
	 end
	 if "expression" == Type { param[2] } then
	    expr = RasMoon.EXPRESSIONS[param[2]]
	 elseif "function" == Type { param[2] } then
	    expr = param[2]
	 elseif "string" == Type { param[2] } then
	    expr = stringtofunc(param[2])
	 else
	    error("Invalid arg #2 for while")
	 end
	 while cond() do expr() end
      end

If = function(param)
	assert(nil ~= param and type(param) == "table" and nil ~= param[1])
	local cond, expr, el
	if "condition" == Type { param[1] } then
	   cond = RasMoon.CONDITIONS[param[1]]
	elseif "function" == Type { param[1] } then
	   cond = param[1]
	elseif "string" == Type { param[1] } then
	   cond = stringtofunc(param[1], true)
	else
	   error("Invalid arg #1 for while")
	end
	if "expression" == Type { param[2] } then
	   expr = RasMoon.EXPRESSIONS[param[2]]
	elseif "function" == Type { param[2] } then
	   expr = param[2]
	elseif "string" == Type { param[2] } then
	   expr = stringtofunc(param[2])
	else
	   expr = function() end
	end
	if "expression" == Type { param[3] } then
	   el = RasMoon.EXPRESSIONS[param[3]]
	elseif "function" == Type { param[3] } then
	   el = param[2]
	elseif "string" == Type { param[3] } then
	   el = stringtofunc(param[3])
	else
	   el = function() end
	 end
	 if cond() then expr() else el() end
      end

For = function(param)
	 assert(nil ~= param and type(param) == "table")
	 assert(type(param[1]) == "table")
	 local expr
	 if "expression" == Type { param[2] } then
	    expr = RasMoon.EXPRESSIONS[param[2]]
	 elseif "function" == Type { param[2] } then
	    expr = param[2]
	 elseif "string" == Type { param[2] } then
	    expr = stringtofunc(param[2])
	 else
	    error("Invalid arg #2 for while")
	 end
	 for key, value in ipairs(param[1]) do
	    Key = key; Value = value
	    expr()
	 end
      end

Print = function(param)
	   assert(nil ~= param and type(param) == "table")
	   for i,v in pairs(param) do
	      if "table" == Type { v } then
		 print("table")
		 for j,k in pairs(v) do
		    print(j, k)
		 end
	      else
		 print(v)
	      end
	   end
	end


_ = function(param)
       return (param ~= nil)
    end
