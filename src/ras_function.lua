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

RasMoon.Function = {
   Memoize = function(func, hard)
		local mem = {}
		hard = hard or false
		if not hard then
		   setmetatable(mem, {__mode = "v"})
		end
		return function(param)
			  if param ~= nil and mem[param] ~= nil then
			     return mem[param]
			  else
			     mem[param] = func(param)
			     return (mem[param])
			  end
		       end
	     end,
   Curry = function(func, ...)
	      local params = {...}
	      return function(param)
			func(param, unpack(params))
		     end
	   end
}

--[[
function test(s)
   print("working")
   return (s .. "funny!")
end

mtest = RasMoon.Function.Memoize(test)
print(mtest("this is "))
print(mtest("this is "))
print(mtest("this is not "))
print(mtest("this is "))
print(mtest("this is not "))


function test2(name, x, y)
   print("my name is " .. name .." and i'm at " .. x .. "/" .. y ..".")
end

ctest = RasMoon.Function.Curry(test2, 10, 12)
ctest("Bob")
--]]