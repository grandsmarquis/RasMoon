--[[                                                                                                                                                                                                 

Copyright (C) 2011-2012 RasMoonDeveloppement team

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

local uid = 0

RasMoon.UID = {
   Get = function()
	    uid = uid + 1
	    return uid
	 end,
   GetString = function()
		  return (tostring(RasMoon.UID.Get()))
	       end
}

RasMoon.Data = {
   Copy = function(object)
      local lookup_table = {}
      local function _copy(object)
	 if type(object) ~= "table" then
            return object
	 elseif lookup_table[object] then
	    return lookup_table[object]
	 end
	 local new_table = {}
	 lookup_table[object] = new_table
	 for index, value in pairs(object) do
	    new_table[_copy(index)] = _copy(value)
	 end
	 return setmetatable(new_table, _copy(getmetatable(object)))
      end
      return _copy(object)
   end,
   Iterate = function(dataObject, callback)
		 while (0 < dataObject:size()) do
		    callback(dataObject:pop(), dataObject:size())
		 end
	      end,
   IterateCopy = function(Object, callback)
		    local dataObject = RasMoon.Data.Copy(Object)
		    RasMoon.Data.Iterate(dataObject, callback)
		 end,
   Stack = function()
      local res = {
	 push = function(self, ...)
		   for _,v in ipairs{...} do
		      self[#self + 1] = v
		   end
		end,
	 pop = function(self)
		  return(table.remove(self))
	       end,
	 size = function(self)
		   return (#self)
		end
      }
      return setmetatable(t or {}, {__index = res})
   end,
   PriorityQueue = function(sorter)
      local res = {
	 push = function(self, ...)
		   for _,v in ipairs{...} do
		      self[#self + 1] = v
		   end
		   table.sort(self, self.sorter)
		end,
	 pop = function(self)
		  return(table.remove(self))
	       end,
	 size = function(self)
		   return (#self)
		end,
	 sorter = sorter or function(a,b) return a > b end
      }
      return setmetatable(t or {}, {__index = res})
   end,
   Queue = function()
      local res = {
	 l = {
	    b = 1,
	    e = 1,
	 },
	 push = function(self, ...)
		   for _, v in ipairs{...} do
		      self[self.l.e] = v
		      self.l.e = self.l.e + 1
		   end
		end,
	 pop = function(self)
		  local res
		  if self.l.b ~= self.l.e then
		     res = self[self.l.b]
		     self[self.l.b] = nil
		     self.l.b = self.l.b + 1
		  end
		  return (res)
	       end,
	 size = function(self)
		   return (self.l.e - self.l.b)
		end
      }
      return setmetatable(t or {}, {__index = res})
   end
}

--[[
local myCallback = function(old, new)
		      if type(new) == "number" then
			 print("this is the callback!")
			 print("this is the old val ", old)
			 print("this is the new val ", new)
		      end
                   end

q = RasMoon.Data.Queue()
--q = RasMoon.Observer(q, myCallback)
q:push(1,9,4)
RasMoon.Data.IterateCopy(q, function(obj, size) print(obj, size) end)
print("Size = ", q:size()) --it did not change
RasMoon.Data.Iterate(q, function(obj, size) print(obj, size) end)
print("Size = ", q:size()) --nah copy was done

q = RasMoon.Data.Queue()
q:push(1)
q:push(2, 3)

--]]


RasMoon.Observer = function(t, callback)
		      local index = {}
   local mt = {
      __index = function (t,k)
                   callback(t[index][k])
                   return t[index][k]
                end,

      __newindex = function (t,k,v)
                      callback(t[index][k], v)
                      t[index][k] = v
                   end
   }
   local res = {}
   res[index] = t
   setmetatable(res, mt)
   return res
end

--[[
local myCallback = function(old, new)
                      print("this is the callback!")
                      if old ~= nil then print("this is the old val " .. old) end
                      if new ~= nil then print("this is the new val " .. new) end
                   end

myTable = {"orange", "red"}
myTable = observer(myTable, myCallback)

myTable[8] = 2
myTable[8] = 5
a = myTable[8]
]]--
