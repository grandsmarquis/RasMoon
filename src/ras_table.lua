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

local function exportstring( s )
   return string.format("%q", s)
end

RasMoon.Table =
   {
   From =
      {
      String = function(string,delim)
		  local i1 = 1
		  local res = {}
		  if not delim then delim = '%s+' end
		  if delim == '' then return {string} end
		  while true do
		     local i2, i3 = string:find(delim, i1)
		     if not i2 then
			local last = string:sub(i1)
			if last ~= '' then table.insert(res,last) end
			if #res == 1 and res[1] == '' then
			   return {}
			else
			   return res
			end
		     end
		     table.insert(res, string:sub(i1,i2-1))
		     i1 = i3+1
		  end
	       end,
      File = function(sfile)
		local ftables,err = loadfile( sfile )
		if err then return _,err end
		local tables = ftables()
		for idx = 1,#tables do
		   local tolinki = {}
		   for i,v in pairs( tables[idx] ) do
		      if type( v ) == "table" then
			 tables[idx][i] = tables[v[1]]
		      end
		      if type( i ) == "table" and tables[i[1]] then
			 table.insert( tolinki,{ i,tables[i[1]] } )
		      end
		   end
		   -- link indices
		   for _,v in ipairs( tolinki ) do
		      tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
		   end
		end
		return tables[1]
	     end
   },
   To =
      {
      String = function(tab, delim)
		  delim = delim or ""
		  local res = ""
		  for i,v in ipairs(tab) do
		     res = res .. delim .. tostring(v)
		  end
		  return res
	       end,
      --// The Save Function
      File = function(tbl, filename)
		local charS,charE = "   ","\n"
		local file,err = io.open( filename, "wb" )
		if err then return err end
		-- initiate variables for save procedure
		local tables,lookup = { tbl },{ [tbl] = 1 }
		file:write( "return {"..charE )
		for idx,t in ipairs( tables ) do
		   file:write( "-- Table: {"..idx.."}"..charE )
		   file:write( "{"..charE )
		   local thandled = {}
		   for i,v in ipairs( t ) do
		      thandled[i] = true
		      local stype = type( v )
		      -- only handle value
		      if stype == "table" then
			 if not lookup[v] then
			    table.insert( tables, v )
			    lookup[v] = #tables
			 end
			 file:write( charS.."{"..lookup[v].."},"..charE )
		      elseif stype == "string" then
			 file:write(  charS..exportstring( v )..","..charE )
		      elseif stype == "number" then
			 file:write(  charS..tostring( v )..","..charE )
		      end
		   end
		   for i,v in pairs( t ) do
		      -- escape handled values
		      if (not thandled[i]) then
			 local str = ""
			 local stype = type( i )
			 -- handle index
			 if stype == "table" then
			    if not lookup[i] then
			       table.insert( tables,i )
			       lookup[i] = #tables
			    end
			    str = charS.."[{"..lookup[i].."}]="
			 elseif stype == "string" then
			    str = charS.."["..exportstring( i ).."]="
			 elseif stype == "number" then
			    str = charS.."["..tostring( i ).."]="
			 end
			 if str ~= "" then
			    stype = type( v )
			    -- handle value
			    if stype == "table" then
			       if not lookup[v] then
				  table.insert( tables,v )
				  lookup[v] = #tables
			       end
			       file:write( str.."{"..lookup[v].."},"..charE )
			    elseif stype == "string" then
			       file:write( str..exportstring( v )..","..charE )
			    elseif stype == "number" then
			       file:write( str..tostring( v )..","..charE )
			    end
			 end
		      end
		   end
		   file:write( "},"..charE )
		end
		file:write( "}" )
		file:close()
	     end
   }
}
--[[
tab = RasMoon.Table.From.String("Hello, my name is Bob.", " ")

print("table:")
for i,v in ipairs(tab) do
   print(i,v)
end

print("to string:", RasMoon.Table.To.String(tab))
]]--
--RasMoon.Table.To.File(tab, "lol.save")
--new = RasMoon.Table.From.File("lol.save")
--for i,v in ipairs(new) do
--   print(i,v)
--end