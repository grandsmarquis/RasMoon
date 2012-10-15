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

local apps = {}
local running = {}

RasMoon.App = {
   Starter = nil,
   Ender = nil,
   Runing = false,
   New = function(app)
	    if type(app) == "table" then
	       app.Name = app.Name or error("New app must specify a name")
	       app.Update = app.Update or function() end
	       app.Enter = app.Enter or function() end
	       app.Exit = app.Exit or function() end
	       app.Coroutine = nil
	       apps[app.Name] = app
	    else
	       error("New app must be a table")
	    end
	 end,
   Start = function(name, bundle)
	      if nil ~= apps[name] then
		 running[name] = apps[name]
		 running[name].Enter(bundle)
		 running[name].Coroutine = coroutine.create(running[name].Update)
	      end
	   end,
   End = function(name, bundle)
	    if running[name] ~= nil then
	       running[name].Exit(bundle)
	       running[name].Coroutine = nil
	    end
	 end,
   Sleep = function()
		coroutine.yield(-1)
	     end,
   IsStarted = function(name)
		  return running[name] ~= nil
	       end,
   Launch = function(sta, en)
	       RasMoon.App.Starter = sta or function() end
	       RasMoon.App.Ender = en or function() end
	       RasMoon.App.Running = true
	       while (RasMoon.App.Running) do
		  for i,v in pairs(running) do
		     if v.Coroutine ~= nil and coroutine.status(v.Coroutine) == "suspended" then
			coroutine.resume(v.Coroutine)
		     else if v.Coroutine ~= nil then
			   v.Exit()
			   running[i] = nil
			else
			   running[i] = nil
			end
		     end
		  end
	       end
	    end,
   Quit = function()
	     RasMoon.App.Running = false
	     for i,v in pairs(running) do
		v.Exit()
		running[i] = nil
	     end
	  end
}

--[[
bob = {
   Name = "Bob",
   Enter = function(bundle)
	      print("Bob just arrived and i'm " .. bundle)
	   end,
   Update = function()
	       while (true) do
		  print("Bob is working")
		  RasMoon.App.Sleep()
	       end
	    end,
   Exit = function(bundle)
	      print("Bob just left because he said : " .. bundle)
	   end
}

jack = {
   Name = "Jack",
   Enter = function()
	      print("Jack just arrived")
	   end,
   Update = function()
	       local i = 0
	       while (i < 3) do
		  print("Jack is working")
		  i = i + 1
		  RasMoon.App.Sleep()
	       end
	       RasMoon.App.End("Bob", "You did a mistake!")
	    end,
   Exit = function()
	      print("Jack just Left")
	   end
}

RasMoon.App.New(jack)
RasMoon.App.New(bob)

RasMoon.App.Start("Bob", "happy")
RasMoon.App.Start("Jack")

RasMoon.App.Launch()

]]--