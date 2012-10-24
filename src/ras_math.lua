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

RasMoon.Math =
   {
   Distance = function(x1,y1, x2,y2)
		 return ((x2-x1)^2+(y2-y1)^2)^0.5
	      end,
   Distance = function(x1,y1,z1, x2,y2,z2)
		 return ((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)^0.5
	      end,
   Multiple = function(n, size)
		 size = size or 10
		 return RasMoon.Math.Round(n/size)*size
	      end,
   Round = function(n, deci)
	      deci = 10^(deci or 0)
	      return math.floor(n*deci+.5)/deci
	   end,
   RandSign = function()
		   return math.random(2) == 2 and 1 or -1
		end,
   RandBit = function()
		  return math.random(2) == 2 and 1 or 0
	       end,
   Average = function(numlist)
		if type(numlist) ~= 'table' then
		   return numlist
		end
		local num = 0
		table.foreach(numlist,function(i,v) num=num+v end)
		return num / #numlist
	     end
  
}

