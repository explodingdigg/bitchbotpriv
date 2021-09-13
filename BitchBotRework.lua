--[[
    Hi, this is WholeCream further known as NiceCream
    I've decided to completely rework it to use some of my libraries.
    For future reference these libraries can be separated in the future!

    Your welcome - WholeCream

    !!READ!!
    Seems that synapse X has another bug with drawings
    They tend to... Crash... A lot...
    Reloading is still fine thought...
]]

local _BBOT = _G.BBOT
local BBOT = BBOT or { username = "dev", alias = "Bitch Bot", version = "¯\\_(ツ)_/¯" } -- I... um... fuck off ok?
_G.BBOT = BBOT

-- Locals/Upvalues
-- Critical for quick stuff
-- Note: Find a way to put this into an isolated global table
local LOG_NORMAL, LOG_DEBUG, LOG_WARN, LOG_ERROR, LOG_ANON = 1, 2, 3, 4, 5 -- Logs
local COLOR, COLOR1, COLOR2 = 1, 2, 3 -- Menu.Colors
local COMBOBOX, TOGGLE, KEYBIND, DROPBOX, COLORPICKER, DOUBLE_COLORPICKERS, SLIDER, BUTTON, LIST, IMAGE, TEXTBOX = 4,5,6,7,8,9,10,11,12,13,14 -- Menu

-- This should always start before hand, this module is responsible for debugging
-- Example usage: BBOT.log(LOG_NORMAL, "How do I even fucking make this work?")
do
    local log = {}
    BBOT.log = log

    -- fallback on synapse x v2.9.1
    -- note: this is disabled due to problems with synapse's second console being all fucky wucky
    local _rconsoleprint = rconsoleprint
    local rconsoleprint = function() end
    if BBOT.username == "dev" then
        rconsoleclear()
        rconsoleprint = _rconsoleprint
    end

    log.async_registery = {}
    local printingvaluetypes = {
        ["Vector3"] = {"V(", ")"},
        ["Vector2"] = {"V(", ")"},
        ["Color3"] = {"C(", ")"},
        ["CFrame"] = {"CF(", ")"}
    }

    local function makereadable(...)
        local txt = {...}
        for i=1, #txt do
            local typee = typeof(txt[i])
            local prefix, suffix = "", ""
            if printingvaluetypes[typee] then
                prefix = printingvaluetypes[typee][1]
                suffix = printingvaluetypes[typee][2]
            elseif typee == "Instance" then
                local class = txt[i].ClassName
                prefix = class .. "("
                suffix = ")"
            end
            txt[i] = prefix .. tostring(txt[i]) .. suffix
        end
        return txt
    end

    local function valuetoprintable(...)
        return table.concat(makereadable(...), " ")
    end
    local white = Color3.new(1,1,1)
    local green = Color3.fromRGB(0,240,0)
    local yellow = Color3.fromRGB(240,240,0)
    local red = Color3.fromRGB(240,0,0)
    local blue = Color3.fromRGB(0,120,240)
    local bbot = Color3.fromRGB(127, 72, 163)

    function log.menu_display(...)
        if BBOT.menu and BBOT.menu.Log then
            BBOT.menu:Log(...)
        end
    end

    local scheduler = {} -- Async due to fucking roblox. Roblox you need to stop being retarded.

    function log.anonprint(...)
        scheduler[#scheduler+1] = {1, {...}}
    end

    function log.print(...)
        scheduler[#scheduler+1] = {2, {...}}
    end

    function log.printwarn(...)
        scheduler[#scheduler+1] = {3, {...}}
    end

    function log.printdebug(...)
        if BBOT.username ~= "dev" then return end
        scheduler[#scheduler+1] = {4, {...}}
    end

    function log.printerror(...)
        scheduler[#scheduler+1] = {5, {...}}
    end

    log.types = {
        [LOG_NORMAL]=log.print,
        [LOG_DEBUG]=log.printdebug,
        [LOG_WARN]=log.printwarn,
        [LOG_ERROR]=log.printerror,
        [LOG_ANON]=log.anonprint
    }

    -- This allows you to do this
    -- BBOT.log(LOG_NORMAL, "Hello world!")
    setmetatable(log, {
        __call = function(self, type, ...)
            if log.types[type] then
                log.types[type](...)
            end
        end
    })

    game:GetService("RunService"):UnbindFromRenderStep("FW0a9kf0w2of00-Last")
    game:GetService("RunService"):BindToRenderStep("FW0a9kf0w2of00-Last", Enum.RenderPriority.Last.Value, function(...)
        for i=1, #scheduler do
            local v = scheduler[i]
            if v[1] == 1 then
                local text = valuetoprintable(unpack(v[2]))
                rconsoleprint('@@WHITE@@')
                rconsoleprint(text .. "\n")
                log.menu_display(white, text)
            elseif v[1] == 2 then
                local text = valuetoprintable(unpack(v[2]))
                rconsoleprint('@@WHITE@@')
                rconsoleprint('[')
                rconsoleprint('@@MAGENTA@@')
                rconsoleprint(BBOT.alias)
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] ' .. text .. "\n")
                log.menu_display(white, "[", green, "System", white, "] ", unpack(makereadable(unpack(v[2]))))
            elseif v[1] == 3 then
                local text = valuetoprintable(unpack(v[2]))
                rconsoleprint('@@WHITE@@')
                rconsoleprint('[')
                rconsoleprint('@@MAGENTA@@')
                rconsoleprint(BBOT.alias)
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] [')
                rconsoleprint('@@YELLOW@@')
                rconsoleprint('WARN')
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] ' .. text .. "\n")
                log.menu_display(white, "[", green, "System", white, "] ", "[", yellow, "WARN", white, "] ", unpack(makereadable(unpack(v[2]))))
            elseif v[1] == 4 then
                local text = valuetoprintable(unpack(v[2]))
                rconsoleprint('@@WHITE@@')
                rconsoleprint('[')
                rconsoleprint('@@MAGENTA@@')
                rconsoleprint(BBOT.alias)
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] [')
                rconsoleprint('@@CYAN@@')
                rconsoleprint('DEBUG')
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] ' .. text .. "\n")
                log.menu_display(white, "[", green, "System", white, "] ", "[", blue, "DEBUG", white, "] ", unpack(makereadable(unpack(v[2]))))
            elseif v[1] == 5 then
                local text = valuetoprintable(unpack(v[2]))
                rconsoleprint('@@WHITE@@')
                rconsoleprint('[')
                rconsoleprint('@@MAGENTA@@')
                rconsoleprint(BBOT.alias)
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] [')
                rconsoleprint('@@RED@@')
                rconsoleprint('ERROR')
                rconsoleprint('@@WHITE@@')
                rconsoleprint('] ' .. text .. "\n")
                log.menu_display(white, "[", green, "System", white, "] ", "[", red, "ERROR", white, "] ", unpack(makereadable(unpack(v[2]))))
            end
        end
        scheduler = {}
    end)

    function log.error(...)
        log.printerror(...)
        log.printwarn("Process has been halted")
        error()
    end

    log(LOG_NORMAL, "Loading up Bitch Bot...")
end

-- for now
local function ISOLATION(BBOT)
local BBOT = BBOT
local loadstart = tick()

do
    local function round( num, idp )
        local mult = 10 ^ ( idp or 0 )
        return math.floor( num * mult + 0.5 ) / mult
    end

    if _BBOT and BBOT.username == "dev" then
        BBOT.log(3, "Bitch Bot is already running")
        if _BBOT.hook and _BBOT.hook.CallP then
            BBOT.log(3, "Unloading...")
            local t = tick()
            _BBOT.hook:CallP("Unload")
            t = tick() - t
            BBOT.log(3, "Unloading took " .. round(t, 5) .. "s")
        end
        _BBOT.Unloaded = true
    end
end

-- Table
do
    local dcopy = function( t, lookup_table )
        if ( t == nil ) then return nil end
    
        local copy = {}
        setmetatable( copy, debug.getmetatable( t ) )
        for i, v in pairs( t ) do
            if ( typeof( v ) ~= "table" ) then
                if v ~= nil then
                    rawset(copy, i, v)
                end
            else
                lookup_table = lookup_table or {}
                lookup_table[ t ] = copy
                if ( lookup_table[ v ] ) then
                    rawset(copy, i, lookup_table[ v ])
                else
                    rawset(copy, i, dcopy( v, lookup_table ))
                end
            end
        end
        return copy
    end

    local _table = dcopy(table)
    BBOT.table = _table
    local table = _table

    table.deepcopy = dcopy

    -- reverses a numerical table
    function table.reverse(tbl)
        local new_tbl = {}
        for i = 1, #tbl do
            new_tbl[#tbl + 1 - i] = tbl[i]
        end
        return new_tbl
    end

    function table.deeprestore(tbl)
        for k, v in next, tbl do
            if type(v) == "function" and is_synapse_function(v) then
                for k1, v1 in next, getupvalues(v) do
                    if type(v1) == "function" and islclosure(v1) and not is_synapse_function(v1) then
                        tbl[k] = v1
                    end
                end
            end
            if type(v) == "table" then
                table.deeprestore(v)
            end
        end
    end

    function table.deepcleanup(tbl)
        local numTable = #tbl
        local isTableArray = numTable > 0
        if isTableArray then
            for i = 1, numTable do
                local entry = tbl[i]
                local entryType = type(entry)
                if entryType == "table" then
                    table.deepcleanup(tbl)
                end
                tbl[i] = nil
            end
        else
            for k, v in next, tbl do
                if type(v) == "table" then
                    table.deepcleanup(tbl)
                end
            end
            tbl[k] = nil
        end
    end
end

-- Math
do
    local math = BBOT.table.deepcopy(math)
    BBOT.math = math

    function math.lerp(delta, from, to) -- wtf why were these globals thats so exploitable!
        if (delta > 1) then
            return to
        end
        if (delta < 0) then
            return from
        end
        return from + (to - from) * delta
    end

    -- Remaps a value to new min and max
    function math.remap( value, inMin, inMax, outMin, outMax ) -- ty gmod
        return outMin + ( ( ( value - inMin ) / ( inMax - inMin ) ) * ( outMax - outMin ) )
    end

    function math.round( num, idp ) -- ty gmod again
        local mult = 10 ^ ( idp or 0 )
        return math.floor( num * mult + 0.5 ) / mult
    end

    function math.average(t)
        local sum = 0
        for _, v in pairs(t) do -- Get the sum of all numbers in t
            sum = sum + v
        end
        return sum / #t
    end

    function math.clamp(a, lowerNum, higher) -- DONT REMOVE this clamp is better then roblox's because it doesnt error when its not lower or heigher
        if a > higher then
            return higher
        elseif a < lowerNum then
            return lowerNum
        else
            return a
        end
    end
end

-- Color
do
    local math = BBOT.math
    local color = {}
    BBOT.color = color

    function color.range(value, ranges) -- ty tony for dis function u a homie
        if value <= ranges[1].start then
            return ranges[1].color
        end
        if value >= ranges[#ranges].start then
            return ranges[#ranges].color
        end

        local selected = #ranges
        for i = 1, #ranges - 1 do
            if value < ranges[i + 1].start then
                selected = i
                break
            end
        end
        local minColor = ranges[selected]
        local maxColor = ranges[selected + 1]
        local lerpValue = (value - minColor.start) / (maxColor.start - minColor.start)
        return Color3.new(
            math.lerp(lerpValue, minColor.color.r, maxColor.color.r),
            math.lerp(lerpValue, minColor.color.g, maxColor.color.g),
            math.lerp(lerpValue, minColor.color.b, maxColor.color.b)
        )
    end

    -- I also wish we could just add this to the Color3 metatable...
    function color.mul(col, mult)
		return Color3.new(col.R * mult, col.G * mult, col.B * mult)
	end

    function color.add(col, num)
		return Color3.new(col.R + num, col.G + num, col.B + num)
	end
end

-- Vector
do 
    local vector = {}
    BBOT.vector = vector

    -- I also wish we could just add this to the Vector3 metatable...
    function vector.rotate(Vec, Rads)
		local vec = Vec.Unit
		--x2 = cos β x1 − sin β y1
		--y2 = sin β x1 + cos β y1
		local sin = math.sin(Rads)
		local cos = math.cos(Rads)
		local x = (cos * vec.x) - (sin * vec.y)
		local y = (sin * vec.x) + (cos * vec.y)

		return Vector2.new(x, y).Unit * Vec.Magnitude
	end
end

-- String
do
    local string = BBOT.table.deepcopy(string)
    BBOT.string = string

    function string.cut(s1, num)
        return num == 0 and s1 or string.sub(s1, 1, num)
    end
end

-- Services
do
    local service = {
        registry = {}
    }
    BBOT.service = service
    function service:GetService(name)
        local services = self.registry
        if not services[name] then
            services[name] = game:GetService(name)
        end
        return services[name]
    end

    function service:AddToServices(name, service)
        self.registry[name] = service
    end

    local localplayer = service:GetService("Players").LocalPlayer
    service:AddToServices("LocalPlayer", localplayer)
    service:AddToServices("CurrentCamera", service:GetService("Workspace").CurrentCamera)
    service:AddToServices("PlayerGui", localplayer:FindFirstChild("PlayerGui") or localplayer:WaitForChild("PlayerGui"))
    service:AddToServices("Mouse", localplayer:GetMouse())
end

-- Threading
do
    local thread = {}
    BBOT.thread = thread

    function thread:Create(func, ...) -- improved... yay.
        local thread = coroutine.create(func)
        coroutine.resume(thread, ...)
        return thread
    end

    function thread:CreateMulti(obj, ...)
        local n = #obj
        if n > 0 then
            for i = 1, n do
                local t = obj[i]
                if type(t) == "table" then
                    local d = #t
                    assert(d ~= 0, "table inserted was not an array or was empty")
                    assert(d < 3, ("invalid number of arguments (%d)"):format(d))
                    local thetype = type(t[1])
                    assert(
                        thetype == "function",
                        ("invalid argument #1: expected 'function', got '%s'"):format(tostring(thetype))
                    )

                    self:Create(t[1], unpack(t[2]))
                else
                    self:Create(t, ...)
                end
            end
        else
            for i, v in pairs(obj) do
                self:Create(v, ...)
            end
        end
    end
end

-- Hooks
do
    BBOT.log(LOG_DEBUG, "Hook library...")
    local hook = {
        registry = {},
        _registry_qa = {}
    }
    BBOT.hook = hook
    function hook:Add(name, ident, func) -- Adds a function to a hook array
        local hooks = self.registry
        
        BBOT.log(LOG_DEBUG, 'Added hook "' .. name .. '" with identity "' .. ident .. '"')

        hooks[name] = hooks[name] or {}
        hooks[name][ident] = func
    
        local QA = {}
        for k, v in next, hooks[name] do
            QA[#QA+1] = {k, v}
        end
        self._registry_qa[name] = QA
    end
    function hook:Remove(name, ident) -- Removes a function from a hook array
        local hooks = self.registry
        if not hooks[name] then return end

        BBOT.log(LOG_DEBUG, 'Removed hook "' .. name .. '" with identity "' .. ident .. '"')

        hooks[name][ident] = nil
    
        local QA = {}
        for k, v in next, hooks[name] do
            QA[#QA+1] = {k, v}
        end
        self._registry_qa[name] = QA
    end
    function hook:Clear(name) -- Clears an entire array of hooks
        local hooks = self.registry

        BBOT.log(LOG_DEBUG, 'Cleared hook "' .. name .. '" callbacks')

        hooks[name] = nil
        self._registry_qa[name] = {}
    end
    function hook:AsyncCall(name, ...) -- Need async? no problem
        coroutine.resume(coroutine.create(hook.Call), hook, name, ...)
    end
    function hook:Call(name, ...) -- Calls an array of hooks, and returns anything if needed
        if not self.registry[name] then return end
        local tbl, tbln = self._registry_qa[name], self.registry[name]
    
        if tbln[name] then
            local func = tbln[name]
            local a, b, c, d, e, f = func(...)
            if a ~= nil then
                return a, b, c, d, e, f
            end
        end
    
        local c = 0
        for l=1, #tbl do
            local k = l-c
            local v = tbl[k]
            if v[1] ~= name then
                local name, func = v[1], v[2]
                if not func then 
                    table.remove(tbl, k); c = c + 1; tbln[_name] = nil
                else
                    if not name then 
                        table.remove(tbl, k); c = c + 1; tbln[_name] = nil
                    else
                        local a, b, c, d, e, f = func(...)
                        if a ~= nil then
                            return a, b, c, d, e, f
                        end
                    end
                end
            end
        end
    end
    function hook:CallP(name, ...) -- Same as @hook:Call, put with error isolation
        if not self.registry[name] then return end
        local tbl, tbln = self._registry_qa[name], self.registry[name]
    
        if tbln[name] then
            local func = tbln[name]
            local ran, a, b, c, d, e, f = xpcall(func, debug.traceback, ...)
            if not ran then
                BBOT.log(LOG_ERROR, "Hook Error - ", name, " - ", name)
                BBOT.log(LOG_NORMAL, a)
                BBOT.log(LOG_WARN, "Removing to prevent cascade!")
                for l=1, #tbl do
                    local v = tbl[l]
                    if v[1] == name then
                        table.remove(tbl, l); c = c + 1; tbln[name] = nil
                        break
                    end
                end
            elseif a ~= nil then
                return a, b, c, d, e, f
            end
        end
        
        local c = 0
        for l=1, #tbl do
            local k = l-c
            local v = tbl[k]
            if v[1] ~= name then
                local _name, func = v[1], v[2]
                if not func then 
                    table.remove(tbl, k); c = c + 1; tbln[_name] = nil
                else
                    if not _name then 
                        table.remove(tbl, k); c = c + 1; tbln[_name] = nil
                    else
                        local ran, a, b, c, d, e, f = xpcall(func, debug.traceback, ...)
                        if not ran then
                            BBOT.log(LOG_ERROR, "Hook Error - ", name, " - ", _name)
                            BBOT.log(LOG_NORMAL, a)
                            BBOT.log(LOG_WARN, "Removing to prevent cascade!")
                            table.remove(tbl, k); c = c + 1; tbln[_name] = nil
                        elseif a ~= nil then
                            return a, b, c, d, e, f
                        end
                    end
                end
            end
        end
    end
    function hook:GetTable() -- Need the table of hooks or no?
        return self.registry
    end
    local connections = {}
    function hook:bindEvent(event, name) -- Creates a hook instance for a roblox signal, only use this for permanent binds NOT temporary!
        local con = event:Connect(function(...)
            self:CallP(name, ...)
        end)
        table.insert(connections, con)
        return con
    end
    hook:Add("Unload", "Unload", function() -- Reloading the cheat? no problem.\
        for i=1, #connections do
            connections[i]:Disconnect()
        end
    end)
end

-- Hook additions
do
    -- From wholecream
    -- If you find that you need to make another connection, do add it here with a hook
    -- You never know if your gonna need to reuse it either way...
    local hook = BBOT.hook
    local runservice = BBOT.service:GetService("RunService")
    local userinputservice = BBOT.service:GetService("UserInputService")
    local mouse = BBOT.service:GetService("Mouse")
    hook:Add("Unload", "BBOT:Hooks.Services", function()
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-First")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Input")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Camera")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Character")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Last")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-R")
    end)

    hook:bindEvent(userinputservice.InputBegan, "InputBegan")
    hook:bindEvent(userinputservice.InputEnded, "InputEnded")

    local lastMousePos = Vector2.new()
    hook:Add("RenderStep.First", "Mouse.Move", function()
        local x, y = mouse.X, mouse.Y
        hook:Call("Mouse.Move", lastMousePos ~= Vector2.new(x, y), x, y)
        lastMousePos = Vector2.new(x, y)
    end)

    hook:bindEvent(mouse.WheelForward, "WheelForward")
    hook:bindEvent(mouse.WheelBackward, "WheelBackward")

    hook:bindEvent(runservice.Stepped, "Step")
    hook:bindEvent(runservice.Heartbeat, "Heartbeat")

    runservice:BindToRenderStep("FW0a9kf0w2of0-First", Enum.RenderPriority.First.Value, function(...)
        hook:CallP("RenderStep.First", ...)
    end)
    runservice:BindToRenderStep("FW0a9kf0w2of0-Input", Enum.RenderPriority.Input.Value, function(...)
        hook:CallP("RenderStep.Input", ...)
    end)
    runservice:BindToRenderStep("FW0a9kf0w2of0-Camera", Enum.RenderPriority.Camera.Value, function(...)
        hook:CallP("RenderStep.Camera", ...)
    end)
    runservice:BindToRenderStep("FW0a9kf0w2of0-Character", Enum.RenderPriority.Character.Value, function(...)
        hook:CallP("RenderStep.Character", ...)
    end)
    runservice:BindToRenderStep("FW0a9kf0w2of0-Last", Enum.RenderPriority.Last.Value, function(...)
        hook:CallP("RenderStep.Last", ...)
    end)
    hook:bindEvent(runservice.RenderStepped, "RenderStepped")

    local players = BBOT.service:GetService("Players")
    hook:bindEvent(players.PlayerAdded, "PlayerAdded")
    hook:bindEvent(players.PlayerRemoving, "PlayerRemoving")
end

-- Loops
do
    BBOT.log(LOG_DEBUG, "Loops library...")
    local loop = {
        registry = {}
    }
    BBOT.loop = loop
    local hook = BBOT.hook
    hook:Add("Unload", "KillLoops", function()
        BBOT.log(LOG_DEBUG, "Purging old loops...")
        BBOT.loop:KillAll()
        BBOT.log(LOG_DEBUG, "Done")
    end)
    function loop:KillAll()
        local tbl = self:GetTable()
        for k, v in pairs(tbl) do
            self:Stop(k)
        end
    end
    function loop:IsRunning(name)
        return self.registry[name].Running
    end
    function loop:Create(name, func, waitt, ...)
        local loops = self.registry
        if loops[name] ~= nil then return end

        BBOT.log(LOG_DEBUG, 'Creating loop "' .. name .. '"')

        loops[name] = { }
        loops[name].Running = false
        loops[name].Destroy = false
        loops[name].Loop = coroutine.create(function(...)
            while true do
                if loops[name].Running then
                    local ran, err = xpcall(func, debug.traceback, ...)
                    if not ran then
                        loops[name].Destroy = true
                        BBOT.log(LOG_ERROR, "Error in loop library - ", err)
                        break
                    end
                end
    
                if loops[name].Destroy then
                    break
                end
    
                if type(wait) == "userdata" then
                    waitt:wait()
                else
                    wait(waitt)
                end
            end
        end)
    end
    function loop:Run(name, func, waitt, ...)
        local loops = self.registry
        if loops[name] == nil then
            if func ~= nil then
                self:Create(name, func, waitt, ...)
            end
        end
        
        BBOT.log(LOG_DEBUG, 'Running loop "' .. name .. '"')

        loops[name].Running = true
        local succ, out = coroutine.resume(loops[name].Loop)
        if not succ then
            warn("Loop: " .. tostring(name) .. " ERROR: " .. tostring(out))
        end
    end
    function loop:Stop(name)
        local loops = self.registry
        if loops[name] == nil then return end

        BBOT.log(LOG_DEBUG, 'Stopping loop "' .. name .. '"')

        loops[name].Running = false
    end
    function loop:Remove(name)
        local loops = self.registry
        if loops[name] == nil then return end
        self:Stop(name)
        BBOT.log(LOG_DEBUG, 'Removing loop "' .. name .. '"')
        loops[name].Destroy = true
        loops[name] = nil
    end
    function loop:GetTable()
        return self.registry
    end
end

-- Timers
do
    BBOT.log(LOG_DEBUG, "Timer library...")
    local timer = {
        registry = {}
    }
    BBOT.timer = timer
    local loop = BBOT.loop
    
    function timer:Get(ident)
        local reg = self.registry
        for i=1, #reg do
            if reg[i].identifier == ident then
                return reg[i], i
            end
        end
    end
    
    timer.ToCreate = {}
    function timer:Create(ident, delay, reps, func)
        self:Remove(ident)

        if self.incalls then
            self.ToCreate[#self.ToCreate+1] = {ident, delay, reps, func}
        else
            local reg = self.registry
            local index = #reg+1
            BBOT.log(LOG_DEBUG, "Created timer '" .. ident .. "'")
            reg[index] = {
                identifier = ident,
                delay = delay,
                repetitions = reps,
                callback = func,
                ticks = tick(),
                timesran = 0,
                paused = false
            }
        end
    end
    
    timer.ToRemove = {}
    function timer:Remove(identifier)
        if self.incalls then
            self.ToRemove[#self.ToRemove+1] = identifier
        else
            local t, index = timer:Get(timer.ToRemove[i])
            if t then
                table.remove(timer.registry, index)
                BBOT.log(LOG_DEBUG, "Removed timer '" .. identifier .. "'")
            end
        end
    end
    
    local T_Simple = 0
    function timer:Simple(delay, func)
        self:Create("__T_Simple" .. T_Simple, delay, 1, func)
        T_Simple = T_Simple + 1
    end
    
    function timer:Adjust(ident, delay, repetitions, func)
        local t = self:Get(ident)
        if not t then return end
        t.delay = t.delay or delay
        t.repetitions = t.repetitions or repetitions
        t.callback = t.callback or func
    end
    
    function timer:Exists(ident)
        return self:Get(ident) ~= nil
    end
    
    function timer:Pause(ident)
        local t = self:Get(ident)
        if not t then return end
        t.paused = tick()
    end
    
    function timer:UnPause(ident)
        local t = self:Get(ident)
        if not t then return end
        t.paused = false
    end
    
    function timer:Start(ident)
        local t = self:Get(ident)
        if not t then return end
        t.ticks = tick()
        t.paused = false
    end
    
    function timer:Stop(ident)
        local t = self:Get(ident)
        if not t then return end
        t.paused = tick()
        t.ticks = t.paused
    end
    
    function timer:Toggle(ident)
        local t = self:Get(ident)
        if not t then return end
        if t.paused then
            t.paused = false
        else
            t.paused = tick()
        end
    end
    
    function timer:TimeLeft(ident)
        local t = self:Get(ident)
        if not t then return end
        return (t.ticks + t.delay - tick())
    end
    
    function timer:RepsLeft(ident)
        local t = self:Get(ident)
        if not t then return end
        return t.repetitions - t.timesran
    end

    function timer:Async(f)
        self:Simple(0,f)
    end
    
    local runservice = BBOT.service:GetService("RunService")
    loop:Run("TIMER", function()
        local c, ticks, timers = 0, tick(), timer.registry

        timer.incalls = true
        for i=1, #timers do
            local v = timers[i-c]
            if v.paused then
                v.ticks = (v.paused - ticks) + ticks
            else
                if v.ticks + v.delay < ticks then
                    v.timesran = v.timesran + 1
                    local ran, err = xpcall(v.callback, debug.traceback)
                    if ran then
                        v.ticks = ticks
                        if v.repetitions > 0 and v.timesran >= v.repetitions then
                            table.remove(timers, i-c)
                            c = c + 1
                        end
                    else
                        local errlog = BBOT.stringExplode("\n", err, false)
                        BBOT.log(LOG_ERROR, "Error in timer library! - ", errlog[1])
                        BBOT.log(LOG_ANON, "Call stack,")
                        if #errlog > 1 then
                            for i=2, #errlog do
                                BBOT.log(LOG_ANON, errlog[i])
                            end
                        end
                        table.remove(timers, i-c)
                        c = c + 1
                    end
                end
            end
        end
        timer.incalls = false

        for i=1, #timer.ToRemove do
            local t, index = timer:Get(timer.ToRemove[i])
            if t then
                table.remove(timer.registry, index)
                BBOT.log(LOG_DEBUG, "Removed timer '" .. t.identifier .. "'")
            end
        end

        timer.ToRemove = {}

        for i=1, #timer.ToCreate do
            timer:Create(unpack(timer.ToCreate[i]))
        end

        timer.ToCreate = {}
    end, runservice.RenderStepped)
end

-- Draw
do
    local hook = BBOT.hook
    local draw = {}
    BBOT.draw = draw
    local allrender = {}
    local RGB = Color3.fromRGB
	function draw:UnRender()
		for k, v in pairs(allrender) do
			for k1, v1 in pairs(v) do
				if v1 and type(v1) ~= "number" and v1.__OBJECT_EXISTS then
					v1:Remove()
                end
			end
		end
	end
    
    hook:Add("Unload", "BBOT:Draw.Unload", function()
        draw:UnRender()
    end)

	function draw:OutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
		local temptable = Drawing.new("Square")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Filled = false
		temptable.Thickness = 0
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:FilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
		local temptable = Drawing.new("Square")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Filled = true
		temptable.Thickness = 0
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:Line(visible, thickness, start_x, start_y, end_x, end_y, clr, tablename)
		temptable = Drawing.new("Line")
		temptable.Visible = visible
		temptable.Thickness = thickness
		temptable.From = Vector2.new(start_x, start_y)
		temptable.To = Vector2.new(end_x, end_y)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:Image(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		local temptable = Drawing.new("Image")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Transparency = transparency
		temptable.Data = imagedata or placeholderImage
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:Text(text, font, visible, pos_x, pos_y, size, centered, clr, tablename)
		local temptable = Drawing.new("Text")
		temptable.Text = text
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = size
		temptable.Center = centered
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Transparency = clr[4] / 255
		temptable.Outline = false
		temptable.Font = font
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:OutlinedText(text, font, visible, pos_x, pos_y, size, centered, clr, clr2, tablename)
		local temptable = Drawing.new("Text")
		temptable.Text = text
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = size
		temptable.Center = centered
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Transparency = clr[4] / 255
		temptable.Outline = true
		temptable.OutlineColor = RGB(clr2[1], clr2[2], clr2[3])
		temptable.Font = font
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
		if tablename then
			table.insert(tablename, temptable)
		end
		return temptable
	end

	function draw:Triangle(visible, filled, pa, pb, pc, clr, tablename)
		clr = clr or { 255, 255, 255, 1 }
		local temptable = Drawing.new("Triangle")
		temptable.Visible = visible
		temptable.Transparency = clr[4] or 1
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Thickness = 4.1
		if pa and pb and pc then
			temptable.PointA = Vector2.new(pa[1], pa[2])
			temptable.PointB = Vector2.new(pb[1], pb[2])
			temptable.PointC = Vector2.new(pc[1], pc[2])
		end
		temptable.Filled = filled
		table.insert(tablename, temptable)
		if tablename and not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:Circle(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
		local temptable = Drawing.new("Circle")
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Visible = visible
		temptable.Radius = size
		temptable.Thickness = thickness
		temptable.NumSides = sides
		temptable.Transparency = clr[4]
		temptable.Filled = false
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function draw:FilledCircle(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
		local temptable = Drawing.new("Circle")
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Visible = visible
		temptable.Radius = size
		temptable.Thickness = thickness
		temptable.NumSides = sides
		temptable.Transparency = clr[4]
		temptable.Filled = true
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end
end

--! POST LIBRARIES !--

-- Setup
do
    local thread = BBOT.thread
    local NetworkClient = BBOT.service:GetService("NetworkClient")
    if game.PlaceId == 292439477 or game.PlaceId == 299659045 or game.PlaceId == 5281922586 or game.PlaceId == 3568020459 then
        BBOT.game = "pf"
    else
        BBOT.game = "universal"
    end

    BBOT.networksettings = settings().Network
    NetworkClient:SetOutgoingKBPSLimit(0)

    setfpscap(getgenv().maxfps or 144)

    if not isfolder("bitchbot") then
        makefolder("bitchbot")
        if not isfile("bitchbot/relations.bb") then
            writefile("bitchbot/relations.bb", "bb:{{friends:}{priority:}")
        end
    else
        if not isfile("bitchbot/relations.bb") then
            writefile("bitchbot/relations.bb", "bb:{{friends:}{priority:}")
        end
        writefile("bitchbot/debuglog.bb", "")
    end

    if not isfolder("bitchbot/" .. BBOT.game) then
        makefolder("bitchbot/" .. BBOT.game)
    end

    local BBOT_IMAGES = {}
    thread:CreateMulti({
        function()
            BBOT_IMAGES[1] = game:HttpGet("https://i.imgur.com/9NMuFcQ.png")
        end,
        function()
            BBOT_IMAGES[2] = game:HttpGet("https://i.imgur.com/jG3NjxN.png")
        end,
        function()
            BBOT_IMAGES[3] = game:HttpGet("https://i.imgur.com/2Ty4u2O.png")
        end,
        function()
            BBOT_IMAGES[4] = game:HttpGet("https://i.imgur.com/kNGuTlj.png")
        end,
        function()
            BBOT_IMAGES[5] = game:HttpGet("https://i.imgur.com/OZUR3EY.png")
        end,
        function()
            BBOT_IMAGES[6] = game:HttpGet("https://i.imgur.com/3HGuyVa.png")
        end,
    })
    BBOT.BBOT_IMAGES = BBOT_IMAGES

    -- I am so baffled about this part - wholecream
    local loaded = {}
    do
        local function Loopy_Image_Checky()
            for i = 1, 6 do
                local v = BBOT_IMAGES[i]
                if v == nil then
                    return true
                elseif not loaded[i] then
                    loaded[i] = true
                end
            end
            return false
        end
        while Loopy_Image_Checky() do
            wait(0)
        end
    end

	do
		local net

		repeat
			local gc = getgc(true)

			for i = 1, #gc do
				local garbage = gc[i]

				local garbagetype = type(garbage)

				if garbagetype == "table" then
					net = rawget(garbage, "fetch")
					if net then
						break
					end
				end
			end

			gc = nil
			game.RunService.RenderStepped:Wait()
		until net

		net = nil

		local annoyingFuckingMusic = workspace:FindFirstChild("memes")
		if annoyingFuckingMusic then
			annoyingFuckingMusic:Destroy()
		end
	end -- wait for framwork to load
end

-- Configs
do
    -- To do, add a config verification system
    -- To do, menu shouldn't be tied together wirh config
        -- Configs should have it's own dedicated handle
    -- To do, I don't want to have to do this, but I might make an entirely new config system
        -- Cause why not... and also right now things are just all over the place...
end

-- Notifications
do
    local hook = BBOT.hook
    local math = BBOT.math
    local notification = {
        registry = {},
    }
    BBOT.notification = notification

	local function DrawingObject(t, col)
		local d = Drawing.new(t)

		d.Visible = true
		d.Transparency = 1
		d.Color = col

		return d
	end

	local function Rectangle(sizex, sizey, fill, col)
		local s = DrawingObject("Square", col)

		s.Filled = fill
		s.Thickness = 1
		s.Position = Vector2.new()
		s.Size = Vector2.new(sizex, sizey)

		return s
	end

	local function Text(text)
		local s = DrawingObject("Text", Color3.new(1, 1, 1))

		s.Text = text
		s.Size = 13
		s.Center = false
		s.Outline = true
		s.Position = Vector2.new()
		s.Font = 2

		return s
	end

    do
        local meta = {}
        notification.meta = meta

        function meta:Remove(d)
            if d.Position.x < d.Size.x then
                for k, drawing in pairs(self.drawings) do
                    drawing:Remove()
                    drawing = false
                end
                self.enabled = false
            end
        end

        function meta:Update(num, listLength, dt)
            local pos = self.targetPos

            local indexOffset = (listLength - num) * self.gap
            if self.insety < indexOffset then
                self.insety -= (self.insety - indexOffset) * 0.2
            else
                self.insety = indexOffset
            end
            local size = self.size

            local tpos = Vector2.new(pos.x - size.x / self.time - math.remap(self.alpha, 0, 255, size.x, 0), pos.y + self.insety)
            self.pos = tpos

            local locRect = {
                x = math.ceil(tpos.x),
                y = math.ceil(tpos.y),
                w = math.floor(size.x - math.remap(255 - self.alpha, 0, 255, 0, 70)),
                h = size.y,
            }
            --pos.set(-size.x / fc - math.remap(self.alpha, 0, 255, size.x, 0), pos.y)

            local fade = math.min(self.time * 12, self.alpha)
            fade = fade > 255 and 255 or fade < 0 and 0 or fade

            if self.enabled then
                local linenum = 1
                for i, drawing in pairs(self.drawings) do
                    drawing.Transparency = fade / 255

                    if type(i) == "number" then
                        drawing.Position = Vector2.new(locRect.x + 1, locRect.y + i)
                        drawing.Size = Vector2.new(locRect.w - 2, 1)
                    elseif i == "text" then
                        drawing.Position = tpos + Vector2.new(6, 2)
                    elseif i == "outline" then
                        drawing.Position = Vector2.new(locRect.x, locRect.y)
                        drawing.Size = Vector2.new(locRect.w, locRect.h)
                    elseif i == "fade" then
                        drawing.Position = Vector2.new(locRect.x - 1, locRect.y - 1)
                        drawing.Size = Vector2.new(locRect.w + 2, locRect.h + 2)
                        local t = (200 - fade) / 255 / 3
                        drawing.Transparency = t < 0.4 and 0.4 or t
                    elseif i:find("line") then
                        drawing.Position = Vector2.new(locRect.x + linenum, locRect.y + 1)
                        if menu then
                            local mencol = customcolor or (
                                    menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and Color3.fromRGB(unpack(menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR))) or Color3.fromRGB(127, 72, 163)
                                )
                            local color = linenum == 1 and mencol or Color3.fromRGB(mencol.R * 255 - 40, mencol.G * 255 - 40, mencol.B * 255 - 40) -- super shit
                            if drawing.Color ~= color then
                                drawing.Color = color
                            end
                        end
                        linenum += 1
                    end
                end

                self.time += self.estep * dt * 128 -- TODO need to do the duration
                self.estep += self.eestep * dt * 64
            end
        end

        function meta:Fade(num, len, dt)
            if self.pos.x > self.targetPos.x - 0.2 * len or self.fading then
                if not self.fading then
                    self.estep = 0
                end
                self.fading = true
                self.alpha -= self.estep / 4 * len * dt * 50
                self.eestep += 0.01 * dt * 100
            end
            if self.alpha <= 0 then
                self:Remove(self.drawings[1])
            end
        end
    end

    function notification:Create(t, customcolor)
		local width = 18

        local Note = {
            enabled = true,
            targetPos = Vector2.new(50, 33),
            size = Vector2.new(200, width),
            drawings = {
                outline = Rectangle(202, width + 2, false, Color3.new(0, 0, 0)),
                fade = Rectangle(202, width + 2, false, Color3.new(0, 0, 0)),
            },
            gap = 25,
            width = width,
            alpha = 255,
            time = 0,
            estep = 0,
            eestep = 0.02,
            insety = 0
        }

        setmetatable(Note, {__index = self.meta})

        for i = 1, Note.size.y - 2 do
            local c = 0.28 - i / 80
            Note.drawings[i] = Rectangle(200, 1, true, Color3.new(c, c, c))
        end

        local menu = BBOT.menu
        local color = (menu and menu.GetVal) and (customcolor or menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and Color3.fromRGB(unpack(menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR)))) or (customcolor or Color3.fromRGB(127, 72, 163))

        Note.drawings.text = Text(t)
        if Note.drawings.text.TextBounds.x + 7 > Note.size.x then -- expand the note size to fit if it's less than the default size
            Note.size = Vector2.new(Note.drawings.text.TextBounds.x + 7, Note.size.y)
        end
        Note.drawings.line = Rectangle(1, Note.size.y - 2, true, color)
        Note.drawings.line1 = Rectangle(1, Note.size.y - 2, true, color)

        self.registry[#self.registry + 1] = Note
    end

    hook:Add("RenderStep.First", "BBOT:Notifications.Render", function(dt)
		local smallest = math.huge
        local notes = notification.registry
		for k = 1, #notes do
			local v = notes[k]
			if v and v.enabled then
				smallest = k < smallest and k or smallest
			else
				table.remove(notes, k)
			end
		end
		local length = #notes
		for k = 1, #notes do
			local note = notes[k]
			note:Update(k, length, dt)
			if k <= math.ceil(length / 10) or note.fading then
				note:Fade(k, length, dt)
			end
		end
    end)

    hook:Add("Unload", "BBOT:Notifications", function()
        local notes = notification.registry
		for k = 1, #notes do
			local v = notes[k]
            for index, drawing in pairs(v.drawings) do
                drawing:Remove()
                drawing = false
            end
        end
        notification.registry = {}
    end)
end

-- Menu
do
    local draw = BBOT.draw
    local hook = BBOT.hook
    local string = BBOT.string
    local LOCAL_MOUSE = BBOT.service:GetService("Mouse")
    
    local color = BBOT.color
    local menuWidth, menuHeight = 500, 600
    -- What in the fuck - WholeCream
    -- I am going to have so much fun splitting the menu and the config apart
    local menu = { -- this is for menu stuffs n shi
        w = menuWidth,
        h = menuHeight,
        x = 0,
        y = 0,
        columns = {
            width = math.floor((menuWidth - 40) / 2),
            left = 17,
            right = math.floor((menuWidth - 20) / 2) + 13,
        },
        activetab = 1,
        open = true,
        fadestart = 0,
        fading = false,
        mousedown = false,
        postable = {},
        options = {},
        clrs = {
            norm = {},
            dark = {},
            togz = {},
        },
        mc = { 127, 72, 163 },
        watermark = {},
        connections = {},
        list = {},
        unloaded = false,
        copied_clr = nil,
        game = "uni",
        tabnames = {}, -- its used to change the tab num to the string (did it like this so its dynamic if u add or remove tabs or whatever :D)
        friends = {},
        priority = {},
        muted = {},
        spectating = false,
        stat_menu = false,
        load_time = 0,
        log_multi = nil,
        mgrouptabz = {},
        backspaceheld = false,
        backspacetime = -1,
        backspaceflags = 0,
        selectall = false,
        modkeys = {
            alt = {
                direction = nil,
            },
            shift = {
                direction = nil,
            },
        },
        modkeydown = function(self, key, direction)
            local keydata = self.modkeys[key]
            return keydata.direction and keydata.direction == direction or false
        end,
        keybinds = {},
        values = {}
    }
    BBOT.menu = menu
    menu.mousebehavior = Enum.MouseBehavior.Default -- wtf?

    local textBoxLetters = {
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "S",
        "T",
        "U",
        "V",
        "W",
        "X",
        "Y",
        "Z",
    }

    local keyNames = {
        One = "1",
        Two = "2",
        Three = "3",
        Four = "4",
        Five = "5",
        Six = "6",
        Seven = "7",
        Eight = "8",
        Nine = "9",
        Zero = "0",
        LeftBracket = "[",
        RightBracket = "]",
        Semicolon = ";",
        BackSlash = "\\",
        Slash = "/",
        Minus = "-",
        Equals = "=",
        Return = "Enter",
        Backquote = "`",
        CapsLock = "Caps",
        LeftShift = "LShift",
        RightShift = "RShift",
        LeftControl = "LCtrl",
        RightControl = "RCtrl",
        LeftAlt = "LAlt",
        RightAlt = "RAlt",
        Backspace = "Back",
        Plus = "+",
        Multiplaye = "x",
        PageUp = "PgUp",
        PageDown = "PgDown",
        Delete = "Del",
        Insert = "Ins",
        NumLock = "NumL",
        Comma = ",",
        Period = ".",
    }
    local colemak = {
        E = "F",
        R = "P",
        T = "G",
        Y = "J",
        U = "L",
        I = "U",
        O = "Y",
        P = ";",
        S = "R",
        D = "S",
        F = "T",
        G = "D",
        J = "N",
        K = "E",
        L = "I",
        [";"] = "O",
        N = "K",
    }

    local keymodifiernames = {
        ["`"] = "~",
        ["1"] = "!",
        ["2"] = "@",
        ["3"] = "#",
        ["4"] = "$",
        ["5"] = "%",
        ["6"] = "^",
        ["7"] = "&",
        ["8"] = "*",
        ["9"] = "(",
        ["0"] = ")",
        ["-"] = "_",
        ["="] = "+",
        ["["] = "{",
        ["]"] = "}",
        ["\\"] = "|",
        [";"] = ":",
        ["'"] = '"',
        [","] = "<",
        ["."] = ".",
        ["/"] = "?",
    }

    local function KeyEnumToName(key) -- did this all in a function cuz why not
        if key == nil then
            return "None"
        end
        local _key = tostring(key) .. "."
        local _key = _key:gsub("%.", ",")
        local keyname = nil
        local looptime = 0
        for w in _key:gmatch("(.-),") do
            looptime = looptime + 1
            if looptime == 3 then
                keyname = w
            end
        end
        if string.match(keyname, "Keypad") then
            keyname = string.gsub(keyname, "Keypad", "")
        end

        if keyname == "Unknown" or key.Value == 27 then
            return "None"
        end

        if keyNames[keyname] then
            keyname = keyNames[keyname]
        end
        if Nate then
            return colemak[keyname] or keyname
        else
            return keyname
        end
    end

    local invalidfilekeys = {
        ["\\"] = true,
        ["/"] = true,
        [":"] = true,
        ["*"] = true,
        ["?"] = true,
        ['"'] = true,
        ["<"] = true,
        [">"] = true,
        ["|"] = true,
    }

    local function KeyModifierToName(key, filename)
        if keymodifiernames[key] ~= nil then
            if filename then
                if invalidfilekeys[keymodifiernames[key]] then
                    return ""
                else
                    return keymodifiernames[key]
                end
            else
                return keymodifiernames[key]
            end
        else
            return ""
        end
    end
    
    local BBOT_IMAGES = BBOT.BBOT_IMAGES
    local RGB = Color3.fromRGB
    -- You don't have to do this but ok...
    do -- Draw-Extended
        --ANCHOR MENU ELEMENTS
        function draw:MenuOutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
            draw:OutlinedRect(visible, pos_x + menu.x, pos_y + menu.y, width, height, clr, tablename)
            table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

            if menu.log_multi ~= nil then
                table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
            end
        end

        function draw:MenuFilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
            draw:FilledRect(visible, pos_x + menu.x, pos_y + menu.y, width, height, clr, tablename)
            table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

            if menu.log_multi ~= nil then
                table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
            end
        end

        function draw:MenuImage(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
            draw:Image(visible, imagedata, pos_x + menu.x, pos_y + menu.y, width, height, transparency, tablename)
            table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

            if menu.log_multi ~= nil then
                table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
            end
        end

        function draw:MenuBigText(text, visible, centered, pos_x, pos_y, tablename)
            local text = draw:OutlinedText(
                text,
                2,
                visible,
                pos_x + menu.x,
                pos_y + menu.y,
                13,
                centered,
                { 255, 255, 255, 255 },
                { 0, 0, 0 },
                tablename
            )
            table.insert(menu.postable, { tablename[#tablename], pos_x, pos_y })

            if menu.log_multi ~= nil then
                table.insert(menu.mgrouptabz[menu.log_multi[1]][menu.log_multi[2]], tablename[#tablename])
            end

            return text
        end

        function draw:CoolBox(name, x, y, width, height, tab)
            draw:MenuOutlinedRect(true, x, y, width, height, { 0, 0, 0, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, width - 2, height - 2, { 20, 20, 20, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 2, y + 2, width - 3, 1, { 127, 72, 163, 255 }, tab)
            table.insert(menu.clrs.norm, tab[#tab])
            draw:MenuOutlinedRect(true, x + 2, y + 3, width - 3, 1, { 87, 32, 123, 255 }, tab)
            table.insert(menu.clrs.dark, tab[#tab])
            draw:MenuOutlinedRect(true, x + 2, y + 4, width - 3, 1, { 20, 20, 20, 255 }, tab)

            for i = 0, 7 do
                draw:MenuFilledRect(true, x + 2, y + 5 + (i * 2), width - 4, 2, { 45, 45, 45, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(45, 45, 45) }, [2] = { start = 7, color = RGB(35, 35, 35) } }
                )
            end

            draw:MenuBigText(name, true, false, x + 6, y + 5, tab)
        end

        function draw:CoolMultiBox(names, x, y, width, height, tab)
            draw:MenuOutlinedRect(true, x, y, width, height, { 0, 0, 0, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, width - 2, height - 2, { 20, 20, 20, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 2, y + 2, width - 3, 1, { 127, 72, 163, 255 }, tab)
            table.insert(menu.clrs.norm, tab[#tab])
            draw:MenuOutlinedRect(true, x + 2, y + 3, width - 3, 1, { 87, 32, 123, 255 }, tab)
            table.insert(menu.clrs.dark, tab[#tab])
            draw:MenuOutlinedRect(true, x + 2, y + 4, width - 3, 1, { 20, 20, 20, 255 }, tab)

            --{35, 35, 35, 255}

            draw:MenuFilledRect(true, x + 2, y + 5, width - 4, 18, { 30, 30, 30, 255 }, tab)
            draw:MenuFilledRect(true, x + 2, y + 21, width - 4, 2, { 20, 20, 20, 255 }, tab)

            local selected = {}
            for i = 0, 8 do
                draw:MenuFilledRect(true, x + 2, y + 5 + (i * 2), width - 159, 2, { 45, 45, 45, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 8, color = RGB(35, 35, 35) } }
                )
                table.insert(selected, { postable = #menu.postable, drawn = tab[#tab] })
            end

            local length = 2
            local selected_pos = {}
            local click_pos = {}
            local nametext = {}
            for i, v in ipairs(names) do
                draw:MenuBigText(v, true, false, x + 4 + length, y + 5, tab)
                if i == 1 then
                    tab[#tab].Color = RGB(255, 255, 255)
                else
                    tab[#tab].Color = RGB(170, 170, 170)
                end
                table.insert(nametext, tab[#tab])

                draw:MenuFilledRect(true, x + length + tab[#tab].TextBounds.X + 8, y + 5, 2, 16, { 20, 20, 20, 255 }, tab)
                table.insert(selected_pos, { pos = x + length, length = tab[#tab - 1].TextBounds.X + 8 })
                table.insert(click_pos, {
                    x = x + length,
                    y = y + 5,
                    width = tab[#tab - 1].TextBounds.X + 8,
                    height = 18,
                    name = v,
                    num = i,
                })
                length += tab[#tab - 1].TextBounds.X + 10
            end

            local settab = 1
            for k, v in pairs(selected) do
                menu.postable[v.postable][2] = selected_pos[settab].pos
                v.drawn.Size = Vector2.new(selected_pos[settab].length, 2)
            end

            return { bar = selected, barpos = selected_pos, click_pos = click_pos, nametext = nametext }

            --draw:MenuBigText(str, true, false, x + 6, y + 5, tab)
        end

        function draw:Toggle(name, value, unsafe, x, y, tab)
            draw:MenuOutlinedRect(true, x, y, 12, 12, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, 10, 10, { 0, 0, 0, 255 }, tab)

            local temptable = {}
            for i = 0, 3 do
                draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), 8, 2, { 0, 0, 0, 255 }, tab)
                table.insert(temptable, tab[#tab])
                if value then
                    tab[#tab].Color = color.range(i, {
                        [1] = { start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3]) },
                        [2] = { start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40) },
                    })
                else
                    tab[#tab].Color = color.range(i, {
                        [1] = { start = 0, color = RGB(50, 50, 50) },
                        [2] = { start = 3, color = RGB(30, 30, 30) },
                    })
                end
            end

            draw:MenuBigText(name, true, false, x + 16, y - 1, tab)
            if unsafe == true then
                tab[#tab].Color = RGB(245, 239, 120)
            end
            table.insert(temptable, tab[#tab])
            return temptable
        end

        function draw:Keybind(key, x, y, tab)
            local temptable = {}
            draw:MenuFilledRect(true, x, y, 44, 16, { 25, 25, 25, 255 }, tab)
            draw:MenuBigText(KeyEnumToName(key), true, true, x + 22, y + 1, tab)
            table.insert(temptable, tab[#tab])
            draw:MenuOutlinedRect(true, x, y, 44, 16, { 30, 30, 30, 255 }, tab)
            table.insert(temptable, tab[#tab])
            draw:MenuOutlinedRect(true, x + 1, y + 1, 42, 14, { 0, 0, 0, 255 }, tab)

            return temptable
        end

        function draw:ColorPicker(color, x, y, tab)
            local temptable = {}

            draw:MenuOutlinedRect(true, x, y, 28, 14, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, 26, 12, { 0, 0, 0, 255 }, tab)

            draw:MenuFilledRect(true, x + 2, y + 2, 24, 10, { color[1], color[2], color[3], 255 }, tab)
            table.insert(temptable, tab[#tab])
            draw:MenuOutlinedRect(true, x + 2, y + 2, 24, 10, { color[1] - 40, color[2] - 40, color[3] - 40, 255 }, tab)
            table.insert(temptable, tab[#tab])
            draw:MenuOutlinedRect(true, x + 3, y + 3, 22, 8, { color[1] - 40, color[2] - 40, color[3] - 40, 255 }, tab)
            table.insert(temptable, tab[#tab])

            return temptable
        end

        function draw:Slider(name, stradd, value, minvalue, maxvalue, customvals, rounded, x, y, length, tab)
            draw:MenuBigText(name, true, false, x, y - 3, tab)

            for i = 0, 3 do
                draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 3, color = RGB(30, 30, 30) } }
                )
            end

            local temptable = {}
            for i = 0, 3 do
                draw:MenuFilledRect(
                    true,
                    x + 2,
                    y + 14 + (i * 2),
                    (length - 4) * ((value - minvalue) / (maxvalue - minvalue)),
                    2,
                    { 0, 0, 0, 255 },
                    tab
                )
                table.insert(temptable, tab[#tab])
                tab[#tab].Color = color.range(i, {
                    [1] = { start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3]) },
                    [2] = { start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40) },
                })
            end
            draw:MenuOutlinedRect(true, x, y + 12, length, 12, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 10, { 0, 0, 0, 255 }, tab)

            local textstr = ""

            if stradd == nil then
                stradd = ""
            end

            local decplaces = rounded and string.rep("0", math.log(1 / rounded) / math.log(10)) or 1
            if rounded and value == math.floor(value * decplaces) then
                textstr = tostring(value) .. "." .. decplaces .. stradd
            else
                textstr = tostring(value) .. stradd
            end

            draw:MenuBigText(customvals[value] or textstr, true, true, x + (length * 0.5), y + 11, tab)
            table.insert(temptable, tab[#tab])
            table.insert(temptable, stradd)
            return temptable
        end

        function draw:Dropbox(name, value, values, x, y, length, tab)
            local temptable = {}
            draw:MenuBigText(name, true, false, x, y - 3, tab)

            for i = 0, 7 do
                draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 7, color = RGB(35, 35, 35) } }
                )
            end

            draw:MenuOutlinedRect(true, x, y + 12, length, 22, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 20, { 0, 0, 0, 255 }, tab)

            draw:MenuBigText(tostring(values[value]), true, false, x + 6, y + 16, tab)
            table.insert(temptable, tab[#tab])

            draw:MenuBigText("-", true, false, x - 17 + length, y + 16, tab)
            table.insert(temptable, tab[#tab])

            return temptable
        end

        function draw:Combobox(name, values, x, y, length, tab)
            local temptable = {}
            draw:MenuBigText(name, true, false, x, y - 3, tab)

            for i = 0, 7 do
                draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 7, color = RGB(35, 35, 35) } }
                )
            end

            draw:MenuOutlinedRect(true, x, y + 12, length, 22, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 20, { 0, 0, 0, 255 }, tab)
            local textthing = ""
            for k, v in pairs(values) do
                if v[2] then
                    if textthing == "" then
                        textthing = v[1]
                    else
                        textthing ..= ", " .. v[1]
                    end
                end
            end
            textthing = string.cut(textthing, 25)
            textthing = textthing ~= "" and textthing or "None"
            draw:MenuBigText(textthing, true, false, x + 6, y + 16, tab)
            table.insert(temptable, tab[#tab])

            draw:MenuBigText("...", true, false, x - 27 + length, y + 16, tab)
            table.insert(temptable, tab[#tab])

            return temptable
        end

        function draw:Button(name, x, y, length, tab)
            local temptable = {}

            for i = 0, 8 do
                draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 8, color = RGB(35, 35, 35) } }
                )
                table.insert(temptable, tab[#tab])
            end

            draw:MenuOutlinedRect(true, x, y, length, 22, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, { 0, 0, 0, 255 }, tab)
            temptable.text = draw:MenuBigText(name, true, true, x + math.floor(length * 0.5), y + 4, tab)

            return temptable
        end

        function draw:List(name, x, y, length, maxamount, columns, tab)
            local temptable = { uparrow = {}, downarrow = {}, liststuff = { rows = {}, words = {} } }

            for i, v in ipairs(name) do
                draw:MenuBigText(
                    v,
                    true,
                    false,
                    (math.floor(length / columns) * i) - math.floor(length / columns) + 30,
                    y - 3,
                    tab
                )
            end

            draw:MenuOutlinedRect(true, x, y + 12, length, 22 * maxamount + 4, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 22 * maxamount + 2, { 0, 0, 0, 255 }, tab)

            draw:MenuFilledRect(true, x + length - 7, y + 16, 1, 1, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, tab)
            table.insert(temptable.uparrow, tab[#tab])
            table.insert(menu.clrs.norm, tab[#tab])
            draw:MenuFilledRect(true, x + length - 8, y + 17, 3, 1, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, tab)
            table.insert(temptable.uparrow, tab[#tab])
            table.insert(menu.clrs.norm, tab[#tab])
            draw:MenuFilledRect(true, x + length - 9, y + 18, 5, 1, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, tab)
            table.insert(temptable.uparrow, tab[#tab])
            table.insert(menu.clrs.norm, tab[#tab])

            draw:MenuFilledRect(
                true,
                x + length - 7,
                y + 16 + (22 * maxamount + 4) - 9,
                1,
                1,
                { menu.mc[1], menu.mc[2], menu.mc[3], 255 },
                tab
            )
            table.insert(temptable.downarrow, tab[#tab])
            table.insert(menu.clrs.norm, tab[#tab])
            draw:MenuFilledRect(
                true,
                x + length - 8,
                y + 16 + (22 * maxamount + 4) - 10,
                3,
                1,
                { menu.mc[1], menu.mc[2], menu.mc[3], 255 },
                tab
            )
            table.insert(temptable.downarrow, tab[#tab])
            table.insert(menu.clrs.norm, tab[#tab])
            draw:MenuFilledRect(
                true,
                x + length - 9,
                y + 16 + (22 * maxamount + 4) - 11,
                5,
                1,
                { menu.mc[1], menu.mc[2], menu.mc[3], 255 },
                tab
            )
            table.insert(temptable.downarrow, tab[#tab])
            table.insert(menu.clrs.norm, tab[#tab])

            for i = 1, maxamount do
                temptable.liststuff.rows[i] = {}
                if i ~= maxamount then
                    draw:MenuOutlinedRect(true, x + 4, (y + 13) + (22 * i), length - 8, 2, { 20, 20, 20, 255 }, tab)
                    table.insert(temptable.liststuff.rows[i], tab[#tab])
                end

                if columns ~= nil then
                    for i1 = 1, columns - 1 do
                        draw:MenuOutlinedRect(
                            true,
                            x + math.floor(length / columns) * i1,
                            (y + 13) + (22 * i) - 18,
                            2,
                            16,
                            { 20, 20, 20, 255 },
                            tab
                        )
                        table.insert(temptable.liststuff.rows[i], tab[#tab])
                    end
                end

                temptable.liststuff.words[i] = {}
                if columns ~= nil then
                    for i1 = 1, columns do
                        draw:MenuBigText(
                            "",
                            true,
                            false,
                            (x + math.floor(length / columns) * i1) - math.floor(length / columns) + 5,
                            (y + 13) + (22 * i) - 16,
                            tab
                        )
                        table.insert(temptable.liststuff.words[i], tab[#tab])
                    end
                else
                    draw:MenuBigText("", true, false, x + 5, (y + 13) + (22 * i) - 16, tab)
                    table.insert(temptable.liststuff.words[i], tab[#tab])
                end
            end

            return temptable
        end

        function draw:ImageWithText(size, image, text, x, y, tab)
            local temptable = {}
            draw:MenuOutlinedRect(true, x, y, size + 4, size + 4, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, size + 2, size + 2, { 0, 0, 0, 255 }, tab)
            draw:MenuFilledRect(true, x + 2, y + 2, size, size, { 40, 40, 40, 255 }, tab)

            draw:MenuBigText(text, true, false, x + size + 8, y, tab)
            table.insert(temptable, tab[#tab])

            draw:MenuImage(true, BBOT_IMAGES[5], x + 2, y + 2, size, size, 1, tab)
            table.insert(temptable, tab[#tab])

            return temptable
        end

        function draw:TextBox(name, text, x, y, length, tab)
            for i = 0, 8 do
                draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, { 0, 0, 0, 255 }, tab)
                tab[#tab].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 8, color = RGB(35, 35, 35) } }
                )
            end

            draw:MenuOutlinedRect(true, x, y, length, 22, { 30, 30, 30, 255 }, tab)
            draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, { 0, 0, 0, 255 }, tab)
            draw:MenuBigText(text, true, false, x + 6, y + 4, tab)

            return tab[#tab]
        end
    end

    local configs = {}

    local function GetConfigs()
        local result = {}
        local directory = "bitchbot\\" .. menu.game
        for k, v in pairs(listfiles(directory)) do
            local clipped = v:sub(#directory + 2)
            if clipped:sub(#clipped - 2) == ".bb" then
                clipped = clipped:sub(0, #clipped - 3)
                result[k] = clipped
                configs[k] = v
            end
        end
        if #result <= 0 then
            writefile("bitchbot/" .. menu.game .. "/Default.bb", "")
        end
        return result
    end

    local Camera = BBOT.service:GetService("CurrentCamera")
    local SCREEN_SIZE = Camera.ViewportSize

    menu.x = math.floor((SCREEN_SIZE.x / 2) - (menu.w / 2))
    menu.y = math.floor((SCREEN_SIZE.y / 2) - (menu.h / 2))

    local RGB = Color3.fromRGB
    function menu:Initialize(menutable)
        local bbmenu = {} -- this one is for the rendering n shi
        do
            draw:MenuOutlinedRect(true, 0, 0, self.w, self.h, { 0, 0, 0, 255 }, bbmenu) -- first gradent or whatever
            draw:MenuOutlinedRect(true, 1, 1, self.w - 2, self.h - 2, { 20, 20, 20, 255 }, bbmenu)
            draw:MenuOutlinedRect(true, 2, 2, self.w - 3, 1, { 127, 72, 163, 255 }, bbmenu)
            table.insert(self.clrs.norm, bbmenu[#bbmenu])
            draw:MenuOutlinedRect(true, 2, 3, self.w - 3, 1, { 87, 32, 123, 255 }, bbmenu)
            table.insert(self.clrs.dark, bbmenu[#bbmenu])
            draw:MenuOutlinedRect(true, 2, 4, self.w - 3, 1, { 20, 20, 20, 255 }, bbmenu)
    
            for i = 0, 19 do
                draw:MenuFilledRect(true, 2, 5 + i, self.w - 4, 1, { 20, 20, 20, 255 }, bbmenu)
                bbmenu[6 + i].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 20, color = RGB(35, 35, 35) } }
                )
            end
            draw:MenuFilledRect(true, 2, 25, self.w - 4, self.h - 27, { 35, 35, 35, 255 }, bbmenu)
    
            draw:MenuBigText(MenuName or "Bitch Bot", true, false, 6, 6, bbmenu)
    
            draw:MenuOutlinedRect(true, 8, 22, self.w - 16, self.h - 30, { 0, 0, 0, 255 }, bbmenu) -- all this shit does the 2nd gradent
            draw:MenuOutlinedRect(true, 9, 23, self.w - 18, self.h - 32, { 20, 20, 20, 255 }, bbmenu)
            draw:MenuOutlinedRect(true, 10, 24, self.w - 19, 1, { 127, 72, 163, 255 }, bbmenu)
            table.insert(self.clrs.norm, bbmenu[#bbmenu])
            draw:MenuOutlinedRect(true, 10, 25, self.w - 19, 1, { 87, 32, 123, 255 }, bbmenu)
            table.insert(self.clrs.dark, bbmenu[#bbmenu])
            draw:MenuOutlinedRect(true, 10, 26, self.w - 19, 1, { 20, 20, 20, 255 }, bbmenu)
    
            for i = 0, 14 do
                draw:MenuFilledRect(true, 10, 27 + (i * 2), self.w - 20, 2, { 45, 45, 45, 255 }, bbmenu)
                bbmenu[#bbmenu].Color = color.range(
                    i,
                    { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 15, color = RGB(35, 35, 35) } }
                )
            end
            draw:MenuFilledRect(true, 10, 57, self.w - 20, self.h - 67, { 35, 35, 35, 255 }, bbmenu)
        end
        -- ok now the cool part :D
        --ANCHOR self stuffz
    
        local tabz = {}
        for i = 1, #menutable do
            tabz[i] = {}
        end
    
        local tabs = {} -- i like tabby catz 🐱🐱🐱
    
        self.multigroups = {}
    
        for k, v in pairs(menutable) do
            draw:MenuFilledRect(
                true,
                10 + ((k - 1) * ((self.w - 20) / #menutable)),
                27,
                ((self.w - 20) / #menutable),
                32,
                { 30, 30, 30, 255 },
                bbmenu
            )
            draw:MenuOutlinedRect(
                true,
                10 + ((k - 1) * ((self.w - 20) / #menutable)),
                27,
                ((self.w - 20) / #menutable),
                32,
                { 20, 20, 20, 255 },
                bbmenu
            )
            draw:MenuBigText(
                v.name,
                true,
                true,
                math.floor(10 + ((k - 1) * ((self.w - 20) / #menutable)) + (((self.w - 20) / #menutable) * 0.5)),
                35,
                bbmenu
            )
            table.insert(tabs, { bbmenu[#bbmenu - 2], bbmenu[#bbmenu - 1], bbmenu[#bbmenu] })
            table.insert(self.tabnames, v.name)
    
            self.options[v.name] = {}
            self.multigroups[v.name] = {}
            self.mgrouptabz[v.name] = {}
    
            local y_offies = { left = 66, right = 66 }
            if v.content ~= nil then
                for k1, v1 in pairs(v.content) do
                    if v1.autopos ~= nil then
                        v1.width = self.columns.width
                        if v1.autopos == "left" then
                            v1.x = self.columns.left
                            v1.y = y_offies.left
                        elseif v1.autopos == "right" then
                            v1.x = self.columns.right
                            v1.y = y_offies.right
                        end
                    end
    
                    local groups = {}
    
                    if type(v1.name) == "table" then
                        groups = v1.name
                    else
                        table.insert(groups, v1.name)
                    end
    
                    local y_pos = 24
    
                    for g_ind, g_name in ipairs(groups) do
                        self.options[v.name][g_name] = {}
                        if type(v1.name) == "table" then
                            self.mgrouptabz[v.name][g_name] = {}
                            self.log_multi = { v.name, g_name }
                        end
    
                        local content = nil
                        if type(v1.name) == "table" then
                            y_pos = 28
                            content = v1[g_ind].content
                        else
                            y_pos = 24
                            content = v1.content
                        end
    
    
                        if content ~= nil then
                            for k2, v2 in pairs(content) do
                                if v2.type == TOGGLE then
                                    self.options[v.name][g_name][v2.name] = {}
                                    local unsafe = false
                                    if v2.unsafe then
                                        unsafe = true
                                    end
                                    self.options[v.name][g_name][v2.name][4] = draw:Toggle(v2.name, v2.value, unsafe, v1.x + 8, v1.y + y_pos, tabz[k])
                                    self.options[v.name][g_name][v2.name][1] = v2.value
                                    self.options[v.name][g_name][v2.name][7] = v2.value
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1 }
                                    self.options[v.name][g_name][v2.name][6] = unsafe
                                    self.options[v.name][g_name][v2.name].tooltip = v2.tooltip or nil
                                    if v2.extra ~= nil then
                                        if v2.extra.type == KEYBIND then
                                            self.options[v.name][g_name][v2.name][5] = {}
                                            self.options[v.name][g_name][v2.name][5][4] = draw:Keybind(
                                                v2.extra.key,
                                                v1.x + v1.width - 52,
                                                y_pos + v1.y - 2,
                                                tabz[k]
                                            )
                                            self.options[v.name][g_name][v2.name][5][1] = v2.extra.key
                                            self.options[v.name][g_name][v2.name][5][2] = v2.extra.type
                                            self.options[v.name][g_name][v2.name][5][3] = { v1.x + v1.width - 52, y_pos + v1.y - 2 }
                                            self.options[v.name][g_name][v2.name][5][5] = false
                                            self.options[v.name][g_name][v2.name][5].toggletype = v2.extra.toggletype == nil and 1 or v2.extra.toggletype
                                            self.options[v.name][g_name][v2.name][5].relvalue = false
                                            --[[local event = event.new(("%s %s %s"):format(v.name, g_name, v2.name))
                                            event:connect(function(newval) 
                                                if self:GetVal("Visuals", "Keybinds" ,"Log Keybinds") then 
                                                    CreateNotification(("%s %s %s has been set to %s"):format(v.name, g_name, v2.name, newval and "true" or "false")) 
                                                end 
                                            end)]]
                                            self.options[v.name][g_name][v2.name][5].event = event
                                            self.options[v.name][g_name][v2.name][5].bind = table.insert(self.keybinds, {
                                                    self.options[v.name][g_name][v2.name],
                                                    tostring(v2.name),
                                                    tostring(g_name),
                                                    tostring(v.name),
                                                })
                                        elseif v2.extra.type == COLORPICKER then
                                            self.options[v.name][g_name][v2.name][5] = {}
                                            self.options[v.name][g_name][v2.name][5][4] = draw:ColorPicker(
                                                v2.extra.color,
                                                v1.x + v1.width - 38,
                                                y_pos + v1.y - 1,
                                                tabz[k]
                                            )
                                            self.options[v.name][g_name][v2.name][5][1] = v2.extra.color
                                            self.options[v.name][g_name][v2.name][5][2] = v2.extra.type
                                            self.options[v.name][g_name][v2.name][5][3] = { v1.x + v1.width - 38, y_pos + v1.y - 1 }
                                            self.options[v.name][g_name][v2.name][5][5] = false
                                            self.options[v.name][g_name][v2.name][5][6] = v2.extra.name
                                        elseif v2.extra.type == DOUBLE_COLORPICKER then
                                            self.options[v.name][g_name][v2.name][5] = {}
                                            self.options[v.name][g_name][v2.name][5][1] = {}
                                            self.options[v.name][g_name][v2.name][5][1][1] = {}
                                            self.options[v.name][g_name][v2.name][5][1][2] = {}
                                            self.options[v.name][g_name][v2.name][5][2] = v2.extra.type
                                            for i = 1, 2 do
                                                self.options[v.name][g_name][v2.name][5][1][i][4] = draw:ColorPicker(
                                                    v2.extra.color[i],
                                                    v1.x + v1.width - 38 - ((i - 1) * 34),
                                                    y_pos + v1.y - 1,
                                                    tabz[k]
                                                )
                                                self.options[v.name][g_name][v2.name][5][1][i][1] = v2.extra.color[i]
                                                self.options[v.name][g_name][v2.name][5][1][i][3] = { v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1 }
                                                self.options[v.name][g_name][v2.name][5][1][i][5] = false
                                                self.options[v.name][g_name][v2.name][5][1][i][6] = v2.extra.name[i]
                                            end
                                        end
                                    end
                                    y_pos += 18
                                elseif v2.type == SLIDER then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][4] = draw:Slider(
                                        v2.name,
                                        v2.stradd,
                                        v2.value,
                                        v2.minvalue,
                                        v2.maxvalue,
                                        v2.custom or {},
                                        v2.decimal,
                                        v1.x + 8,
                                        v1.y + y_pos,
                                        v1.width - 16,
                                        tabz[k]
                                    )
                                    self.options[v.name][g_name][v2.name][1] = v2.value
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
                                    self.options[v.name][g_name][v2.name][5] = false
                                    self.options[v.name][g_name][v2.name][6] = { v2.minvalue, v2.maxvalue }
                                    self.options[v.name][g_name][v2.name][7] = { v1.x + 7 + v1.width - 38, v1.y + y_pos - 1 }
                                    self.options[v.name][g_name][v2.name].decimal = v2.decimal == nil and nil or v2.decimal
                                    self.options[v.name][g_name][v2.name].stepsize = v2.stepsize
                                    self.options[v.name][g_name][v2.name].shift_stepsize = v2.shift_stepsize
                                    self.options[v.name][g_name][v2.name].custom = v2.custom or {}
    
                                    y_pos += 30
                                elseif v2.type == DROPBOX then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][1] = v2.value
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name][5] = false
                                    self.options[v.name][g_name][v2.name][6] = v2.values
    
                                    if v2.x == nil then
                                        self.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
                                        self.options[v.name][g_name][v2.name][4] = draw:Dropbox(
                                            v2.name,
                                            v2.value,
                                            v2.values,
                                            v1.x + 8,
                                            v1.y + y_pos,
                                            v1.width - 16,
                                            tabz[k]
                                        )
                                        y_pos += 40
                                    else
                                        self.options[v.name][g_name][v2.name][3] = { v2.x + 7, v2.y - 1, v2.w }
                                        self.options[v.name][g_name][v2.name][4] = draw:Dropbox(v2.name, v2.value, v2.values, v2.x + 8, v2.y, v2.w, tabz[k])
                                    end
                                elseif v2.type == COMBOBOX then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][4] = draw:Combobox(
                                            v2.name,
                                            v2.values,
                                            v1.x + 8,
                                            v1.y + y_pos,
                                            v1.width - 16,
                                            tabz[k]
                                        )
                                    self.options[v.name][g_name][v2.name][1] = v2.values
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
                                    self.options[v.name][g_name][v2.name][5] = false
                                    y_pos += 40
                                elseif v2.type == BUTTON then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][1] = false
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name].name = v2.name
                                    self.options[v.name][g_name][v2.name].groupbox = g_name
                                    self.options[v.name][g_name][v2.name].tab = v.name -- why is it all v, v1, v2 so ugly
                                    self.options[v.name][g_name][v2.name].doubleclick = v2.doubleclick
    
                                    if v2.x == nil then
                                        self.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
                                        self.options[v.name][g_name][v2.name][4] = draw:Button(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
                                        y_pos += 28
                                    else
                                        self.options[v.name][g_name][v2.name][3] = { v2.x + 7, v2.y - 1, v2.w }
                                        self.options[v.name][g_name][v2.name][4] = draw:Button(v2.name, v2.x + 8, v2.y, v2.w, tabz[k])
                                    end
                                elseif v2.type == TEXTBOX then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][4] = draw:TextBox(v2.name, v2.text, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
                                    self.options[v.name][g_name][v2.name][1] = v2.text
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name][3] = { v1.x + 7, v1.y + y_pos - 1, v1.width - 16 }
                                    self.options[v.name][g_name][v2.name][5] = false
                                    self.options[v.name][g_name][v2.name][6] = v2.file and true or false
                                    y_pos += 28
                                elseif v2.type == "list" then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][4] = draw:List(
                                        v2.multiname,
                                        v1.x + 8,
                                        v1.y + y_pos,
                                        v1.width - 16,
                                        v2.size,
                                        v2.columns,
                                        tabz[k]
                                    )
                                    self.options[v.name][g_name][v2.name][1] = nil
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                    self.options[v.name][g_name][v2.name][3] = 1
                                    self.options[v.name][g_name][v2.name][5] = {}
                                    self.options[v.name][g_name][v2.name][6] = v2.size
                                    self.options[v.name][g_name][v2.name][7] = v2.columns
                                    self.options[v.name][g_name][v2.name][8] = { v1.x + 8, v1.y + y_pos, v1.width - 16 }
                                    y_pos += 22 + (22 * v2.size)
                                elseif v2.type == IMAGE then
                                    self.options[v.name][g_name][v2.name] = {}
                                    self.options[v.name][g_name][v2.name][1] = draw:ImageWithText(v2.size, nil, v2.text, v1.x + 8, v1.y + y_pos, tabz[k])
                                    self.options[v.name][g_name][v2.name][2] = v2.type
                                end
                            end
                        end
    
                        self.log_multi = nil
                    end
    
                    y_pos += 2
    
                    if type(v1.name) ~= "table" then
                        if v1.autopos == nil then
                            draw:CoolBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
                        else
                            if v1.autofill then
                                y_pos = (self.h - 17) - v1.y
                            elseif v1.size ~= nil then
                                y_pos = v1.size
                            end
                            draw:CoolBox(v1.name, v1.x, v1.y, v1.width, y_pos, tabz[k])
                            y_offies[v1.autopos] += y_pos + 6
                        end
                    else
                        if v1.autofill then
                            y_pos = (self.h - 17) - v1.y
                            y_offies[v1.autopos] += y_pos + 6
                        elseif v1.size ~= nil then
                            y_pos = v1.size
                            y_offies[v1.autopos] += y_pos + 6
                        end
    
                        local drawn
    
                        if v1.autopos == nil then
                            drawn = draw:CoolMultiBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
                        else
                            drawn = draw:CoolMultiBox(v1.name, v1.x, v1.y, v1.width, y_pos, tabz[k])
                        end
    
                        local group_vals = {}
    
                        for _i, _v in ipairs(v1.name) do
                            if _i == 1 then
                                group_vals[_v] = true
                            else
                                group_vals[_v] = false
                            end
                        end
                        table.insert(self.multigroups[v.name], { vals = group_vals, drawn = drawn })
                    end
                end
            end
        end
    
        self.list.addval = function(list, option)
            table.insert(list[5], option)
        end
    
        self.list.removeval = function(list, optionnum)
            if list[1] == optionnum then
                list[1] = nil
            end
            table.remove(list[5], optionnum)
        end
    
        self.list.removeall = function(list)
            list[5] = {}
            for k, v in pairs(list[4].liststuff) do
                for i, v1 in ipairs(v) do
                    for i1, v2 in ipairs(v1) do
                        v2.Visible = false
                    end
                end
            end
        end
    
        self.list.setval = function(list, value)
            list[1] = value
        end
    
        draw:MenuOutlinedRect(true, 10, 59, self.w - 20, self.h - 69, { 20, 20, 20, 255 }, bbmenu)
    
        draw:MenuOutlinedRect(true, 11, 58, ((self.w - 20) / #menutable) - 2, 2, { 35, 35, 35, 255 }, bbmenu)
        local barguy = { bbmenu[#bbmenu], self.postable[#self.postable] }
    
        local function setActiveTab(slot)
            barguy[1].Position = Vector2.new(
                (self.x + 11 + ((((self.w - 20) / #menutable) - 2) * (slot - 1))) + ((slot - 1) * 2),
                self.y + 58
            )
            barguy[2][2] = (11 + ((((self.w - 20) / #menutable) - 2) * (slot - 1))) + ((slot - 1) * 2)
            barguy[2][3] = 58
    
            for k, v in pairs(tabs) do
                if k == slot then
                    v[1].Visible = false
                    v[3].Color = RGB(255, 255, 255)
                else
                    v[3].Color = RGB(170, 170, 170)
                    v[1].Visible = true
                end
            end
    
            for k, v in pairs(tabz) do
                if k == slot then
                    for k1, v1 in pairs(v) do
                        v1.Visible = true
                    end
                else
                    for k1, v1 in pairs(v) do
                        v1.Visible = false
                    end
                end
            end
    
            for k, v in pairs(self.multigroups) do
                if self.tabnames[self.activetab] == k then
                    for k1, v1 in pairs(v) do
                        for k2, v2 in pairs(v1.vals) do
                            for k3, v3 in pairs(self.mgrouptabz[k][k2]) do
                                v3.Visible = v2
                            end
                        end
                    end
                end
            end
        end
    
        setActiveTab(self.activetab)
    
        local plusminus = {}
    
        draw:OutlinedText("_", 1, false, 10, 10, 14, false, { 225, 225, 225, 255 }, { 20, 20, 20 }, plusminus)
        draw:OutlinedText("+", 1, false, 10, 10, 14, false, { 225, 225, 225, 255 }, { 20, 20, 20 }, plusminus)
    
        function self:SetPlusMinus(value, x, y)
            for i, v in ipairs(plusminus) do
                if value == 0 then
                    v.Visible = false
                else
                    v.Visible = true
                end
            end
    
            if value ~= 0 then
                plusminus[1].Position = Vector2.new(x + 3 + self.x, y - 5 + self.y)
                plusminus[2].Position = Vector2.new(x + 13 + self.x, y - 1 + self.y)
    
                if value == 1 then
                    for i, v in ipairs(plusminus) do
                        v.Color = RGB(225, 225, 225)
                        v.OutlineColor = RGB(20, 20, 20)
                    end
                else
                    for i, v in ipairs(plusminus) do
                        if i + 1 == value then
                            v.Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                        else
                            v.Color = RGB(255, 255, 255)
                        end
                        v.OutlineColor = RGB(0, 0, 0)
                    end
                end
            end
        end
    
        self:SetPlusMinus(0, 20, 20)
    
        --DROP BOX THINGY
        local dropboxthingy = {}
        local dropboxtexty = {}
    
        draw:OutlinedRect(false, 20, 20, 100, 22, { 20, 20, 20, 255 }, dropboxthingy)
        draw:OutlinedRect(false, 21, 21, 98, 20, { 0, 0, 0, 255 }, dropboxthingy)
        draw:FilledRect(false, 22, 22, 96, 18, { 45, 45, 45, 255 }, dropboxthingy)
    
        for i = 1, 30 do
            draw:OutlinedText("", 2, false, 20, 20, 13, false, { 255, 255, 255, 255 }, { 0, 0, 0 }, dropboxtexty)
        end
    
        function self:SetDropBox(visible, x, y, length, value, values)
            for k, v in pairs(dropboxthingy) do
                v.Visible = visible
            end
    
            local size = Vector2.new(length, 21 * (#values + 1) + 3)
            -- if y + size.y > SCREEN_SIZE.y then
            -- 	y = SCREEN_SIZE.y - size.y
            -- end
            -- if x + size.x > SCREEN_SIZE.x then
            -- 	x = SCREEN_SIZE.x - size.x
            -- end
            -- if y < 0 then
            -- 	y = 0
            -- end
            -- if x < 0 then
            -- 	x = 0
            -- end
    
            local pos = Vector2.new(x, y)
            dropboxthingy[1].Position = pos
            dropboxthingy[2].Position = Vector2.new(x + 1, y + 1)
            dropboxthingy[3].Position = Vector2.new(x + 2, y + 22)
    
            dropboxthingy[1].Size = size
            dropboxthingy[2].Size = Vector2.new(length - 2, (21 * (#values + 1)) + 1)
            dropboxthingy[3].Size = Vector2.new(length - 4, (21 * #values) + 1 - 1)
    
    
            
            if visible then
                for i = 1, #values do
                    dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 21))
                    dropboxtexty[i].Visible = true
                    dropboxtexty[i].Text = values[i]
                    if i == value then
                        dropboxtexty[i].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                    else
                        dropboxtexty[i].Color = RGB(255, 255, 255)
                    end
                end
            else
                for k, v in pairs(dropboxtexty) do
                    v.Visible = false
                end
            end
            return pos
        end
    
        local function set_comboboxthingy(visible, x, y, length, values)
            for k, v in pairs(dropboxthingy) do
                v.Visible = visible
            end
            local size = Vector2.new(length, 22 * (#values + 1) + 2)
    
            if y + size.y > SCREEN_SIZE.y then
                y = SCREEN_SIZE.y - size.y
            end
            if x + size.x > SCREEN_SIZE.x then
                x = SCREEN_SIZE.x - size.x
            end
            if y < 0 then
                y = 0
            end
            if x < 0 then
                x = 0
            end
            local pos = Vector2.new(x,y)
            dropboxthingy[1].Position = pos
            dropboxthingy[2].Position = Vector2.new(x + 1, y + 1)
            dropboxthingy[3].Position = Vector2.new(x + 2, y + 22)
    
            dropboxthingy[1].Size = size
            dropboxthingy[2].Size = Vector2.new(length - 2, (22 * (#values + 1)))
            dropboxthingy[3].Size = Vector2.new(length - 4, (22 * #values))
    
            if visible then
                for i = 1, #values do
                    dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 22))
                    dropboxtexty[i].Visible = true
                    dropboxtexty[i].Text = values[i][1]
                    if values[i][2] then
                        dropboxtexty[i].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                    else
                        dropboxtexty[i].Color = RGB(255, 255, 255)
                    end
                end
            else
                for k, v in pairs(dropboxtexty) do
                    v.Visible = false
                end
            end
            return pos
        end
    
        self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
    
        --MODE SELECT THING
        local modeselect = {}
    
        draw:OutlinedRect(false, 20, 20, 100, 22, { 20, 20, 20, 255 }, modeselect)
        draw:OutlinedRect(false, 21, 21, 98, 20, { 0, 0, 0, 255 }, modeselect)
        draw:FilledRect(false, 22, 22, 96, 18, { 45, 45, 45, 255 }, modeselect)
    
        local modeselecttext = { "Hold", "Toggle", "Hold Off", "Always" }
        for i = 1, 4 do
            draw:OutlinedText(
                modeselecttext[i],
                2,
                false,
                20,
                20,
                13,
                false,
                { 255, 255, 255, 255 },
                { 0, 0, 0 },
                modeselect
            )
        end
    
        function self:SetKeybindSelect(visible, x, y, value)
            for k, v in pairs(modeselect) do
                v.Visible = visible
            end
    
            if visible then
                modeselect[1].Position = Vector2.new(x, y)
                modeselect[2].Position = Vector2.new(x + 1, y + 1)
                modeselect[3].Position = Vector2.new(x + 2, y + 2)
    
                modeselect[1].Size = Vector2.new(70, 22 * 4 - 1)
                modeselect[2].Size = Vector2.new(70 - 2, 22 * 4 - 3)
                modeselect[3].Size = Vector2.new(70 - 4, 22 * 4 - 5)
    
                for i = 1, 4 do
                    modeselect[i + 3].Position = Vector2.new(x + 6, y + 4 + ((i - 1) * 21))
                    if value == i then
                        modeselect[i + 3].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                    else
                        modeselect[i + 3].Color = RGB(255, 255, 255)
                    end
                end
            end
        end
    
        self:SetKeybindSelect(false, 200, 400, 1)
    
        --COLOR PICKER
        local cp = {
            x = 400,
            y = 40,
            w = 280,
            h = 211,
            alpha = false,
            dragging_m = false,
            dragging_r = false,
            dragging_b = false,
            hsv = {
                h = 0,
                s = 0,
                v = 0,
                a = 0,
            },
            postable = {},
            drawings = {},
        }
    
        local function ColorpickerOutline(visible, pos_x, pos_y, width, height, clr, tablename) -- doing all this shit to make it easier for me to make this beat look nice and shit ya fell dog :dog_head:
            draw:OutlinedRect(visible, pos_x + cp.x, pos_y + cp.y, width, height, clr, tablename)
            table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        local function ColorpickerRect(visible, pos_x, pos_y, width, height, clr, tablename)
            draw:FilledRect(visible, pos_x + cp.x, pos_y + cp.y, width, height, clr, tablename)
            table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        local function ColorpickerImage(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
            draw:Image(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
            table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        local function ColorpickerText(text, visible, centered, pos_x, pos_y, tablename)
            draw:OutlinedText(
                text,
                2,
                visible,
                pos_x + cp.x,
                pos_y + cp.y,
                13,
                centered,
                { 255, 255, 255, 255 },
                { 0, 0, 0 },
                tablename
            )
            table.insert(cp.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        ColorpickerRect(false, 1, 1, cp.w, cp.h, { 35, 35, 35, 255 }, cp.drawings)
        ColorpickerOutline(false, 1, 1, cp.w, cp.h, { 0, 0, 0, 255 }, cp.drawings)
        ColorpickerOutline(false, 2, 2, cp.w - 2, cp.h - 2, { 20, 20, 20, 255 }, cp.drawings)
        ColorpickerOutline(false, 3, 3, cp.w - 3, 1, { 127, 72, 163, 255 }, cp.drawings)
        table.insert(self.clrs.norm, cp.drawings[#cp.drawings])
        ColorpickerOutline(false, 3, 4, cp.w - 3, 1, { 87, 32, 123, 255 }, cp.drawings)
        table.insert(self.clrs.dark, cp.drawings[#cp.drawings])
        ColorpickerOutline(false, 3, 5, cp.w - 3, 1, { 20, 20, 20, 255 }, cp.drawings)
        ColorpickerText("color picker :D", false, false, 7, 6, cp.drawings)
    
        ColorpickerText("x", false, false, 268, 4, cp.drawings)
    
        ColorpickerOutline(false, 10, 23, 160, 160, { 30, 30, 30, 255 }, cp.drawings)
        ColorpickerOutline(false, 11, 24, 158, 158, { 0, 0, 0, 255 }, cp.drawings)
        ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
        local maincolor = cp.drawings[#cp.drawings]
        ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
    
        --https://i.imgur.com/jG3NjxN.png
        local alphabar = {}
        ColorpickerOutline(false, 10, 189, 160, 14, { 30, 30, 30, 255 }, cp.drawings)
        table.insert(alphabar, cp.drawings[#cp.drawings])
        ColorpickerOutline(false, 11, 190, 158, 12, { 0, 0, 0, 255 }, cp.drawings)
        table.insert(alphabar, cp.drawings[#cp.drawings])
        ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
        table.insert(alphabar, cp.drawings[#cp.drawings])
    
        ColorpickerOutline(false, 176, 23, 14, 160, { 30, 30, 30, 255 }, cp.drawings)
        ColorpickerOutline(false, 177, 24, 12, 158, { 0, 0, 0, 255 }, cp.drawings)
        --https://i.imgur.com/2Ty4u2O.png
        ColorpickerImage(false, BBOT_IMAGES[3], 178, 25, 10, 156, 1, cp.drawings)
    
        ColorpickerText("New Color", false, false, 198, 23, cp.drawings)
        ColorpickerOutline(false, 197, 37, 75, 40, { 30, 30, 30, 255 }, cp.drawings)
        ColorpickerOutline(false, 198, 38, 73, 38, { 0, 0, 0, 255 }, cp.drawings)
        ColorpickerImage(false, BBOT_IMAGES[4], 199, 39, 71, 36, 1, cp.drawings)
    
        ColorpickerRect(false, 199, 39, 71, 36, { 255, 0, 0, 255 }, cp.drawings)
        local newcolor = cp.drawings[#cp.drawings]
    
        ColorpickerText("copy", false, true, 198 + 36, 41, cp.drawings)
        ColorpickerText("paste", false, true, 198 + 37, 56, cp.drawings)
        local newcopy = { cp.drawings[#cp.drawings - 1], cp.drawings[#cp.drawings] }
    
        ColorpickerText("Old Color", false, false, 198, 77, cp.drawings)
        ColorpickerOutline(false, 197, 91, 75, 40, { 30, 30, 30, 255 }, cp.drawings)
        ColorpickerOutline(false, 198, 92, 73, 38, { 0, 0, 0, 255 }, cp.drawings)
        ColorpickerImage(false, BBOT_IMAGES[4], 199, 93, 71, 36, 1, cp.drawings)
    
        ColorpickerRect(false, 199, 93, 71, 36, { 255, 0, 0, 255 }, cp.drawings)
        local oldcolor = cp.drawings[#cp.drawings]
    
        ColorpickerText("copy", false, true, 198 + 36, 103, cp.drawings)
        local oldcopy = { cp.drawings[#cp.drawings] }
    
        --ColorpickerRect(false, 197, cp.h - 25, 75, 20, {30, 30, 30, 255}, cp.drawings)
        ColorpickerText("[ Apply ]", false, true, 235, cp.h - 23, cp.drawings)
        local applytext = cp.drawings[#cp.drawings]
    
        local function set_newcolor(r, g, b, a)
            newcolor.Color = RGB(r, g, b)
            if a ~= nil then
                newcolor.Transparency = a / 255
            else
                newcolor.Transparency = 1
            end
        end
    
        local function set_oldcolor(r, g, b, a)
            oldcolor.Color = RGB(r, g, b)
            cp.oldcolor = oldcolor.Color
            cp.oldcoloralpha = a
            if a ~= nil then
                oldcolor.Transparency = a / 255
            else
                oldcolor.Transparency = 1
            end
        end
        -- all this color picker shit is disgusting, why can't it be in it's own fucking scope. these are all global
        local dragbar_r = {}
        draw:OutlinedRect(true, 30, 30, 16, 5, { 0, 0, 0, 255 }, cp.drawings)
        table.insert(dragbar_r, cp.drawings[#cp.drawings])
        draw:OutlinedRect(true, 31, 31, 14, 3, { 255, 255, 255, 255 }, cp.drawings)
        table.insert(dragbar_r, cp.drawings[#cp.drawings])
    
        local dragbar_b = {}
        draw:OutlinedRect(true, 30, 30, 5, 16, { 0, 0, 0, 255 }, cp.drawings)
        table.insert(dragbar_b, cp.drawings[#cp.drawings])
        table.insert(alphabar, cp.drawings[#cp.drawings])
        draw:OutlinedRect(true, 31, 31, 3, 14, { 255, 255, 255, 255 }, cp.drawings)
        table.insert(dragbar_b, cp.drawings[#cp.drawings])
        table.insert(alphabar, cp.drawings[#cp.drawings])
    
        local dragbar_m = {}
        draw:OutlinedRect(true, 30, 30, 5, 5, { 0, 0, 0, 255 }, cp.drawings)
        table.insert(dragbar_m, cp.drawings[#cp.drawings])
        draw:OutlinedRect(true, 31, 31, 3, 3, { 255, 255, 255, 255 }, cp.drawings)
        table.insert(dragbar_m, cp.drawings[#cp.drawings])
    
        function self:SetDragBarR(x, y)
            dragbar_r[1].Position = Vector2.new(x, y)
            dragbar_r[2].Position = Vector2.new(x + 1, y + 1)
        end
    
        function self:SetDragBarB(x, y)
            dragbar_b[1].Position = Vector2.new(x, y)
            dragbar_b[2].Position = Vector2.new(x + 1, y + 1)
        end
    
        function self:SetDragBarM(x, y)
            dragbar_m[1].Position = Vector2.new(x, y)
            dragbar_m[2].Position = Vector2.new(x + 1, y + 1)
        end
    
        function self:SetColorPicker(visible, color, value, alpha, text, x, y)
            for k, v in pairs(cp.drawings) do
                v.Visible = visible
            end
            cp.oldalpha = alpha
            if visible then
                cp.x = clamp(x, 0, SCREEN_SIZE.x - cp.w)
                cp.y = clamp(y, 0, SCREEN_SIZE.y - cp.h)
                for k, v in pairs(cp.postable) do
                    v[1].Position = Vector2.new(cp.x + v[2], cp.y + v[3])
                end
    
                local tempclr = RGB(color[1], color[2], color[3])
                local h, s, v = tempclr:ToHSV()
                cp.hsv.h = h
                cp.hsv.s = s
                cp.hsv.v = v
    
                self:SetDragBarR(cp.x + 175, cp.y + 23 + math.floor((1 - h) * 156))
                self:SetDragBarM(cp.x + 9 + math.floor(s * 156), cp.y + 23 + math.floor((1 - v) * 156))
                if not alpha then
                    set_newcolor(color[1], color[2], color[3])
                    set_oldcolor(color[1], color[2], color[3])
                    cp.alpha = false
                    for k, v in pairs(alphabar) do
                        v.Visible = false
                    end
                    cp.h = 191
                    for i = 1, 2 do
                        cp.drawings[i].Size = Vector2.new(cp.w, cp.h)
                    end
                    cp.drawings[3].Size = Vector2.new(cp.w - 2, cp.h - 2)
                else
                    cp.hsv.a = color[4]
                    cp.alpha = true
                    set_newcolor(color[1], color[2], color[3], color[4])
                    set_oldcolor(color[1], color[2], color[3], color[4])
                    cp.h = 211
                    for i = 1, 2 do
                        cp.drawings[i].Size = Vector2.new(cp.w, cp.h)
                    end
                    cp.drawings[3].Size = Vector2.new(cp.w - 2, cp.h - 2)
                    self:SetDragBarB(cp.x + 12 + math.floor(156 * (color[4] / 255)), cp.y + 188)
                end
    
                applytext.Position = Vector2.new(235 + cp.x, cp.y + cp.h - 23)
                maincolor.Color = Color3.fromHSV(h, 1, 1)
                cp.drawings[7].Text = text
            end
        end
    
        self:SetColorPicker(false, { 255, 0, 0 }, nil, false, "", 0, 0)
    
        --TOOL TIP
        local tooltip = {
            x = 0,
            y = 0,
            time = 0,
            active = false,
            text = "This does this and that i guess\npooping 24/7",
            drawings = {},
            postable = {},
        }
    
        local function ttOutline(visible, pos_x, pos_y, width, height, clr, tablename)
            draw:OutlinedRect(visible, pos_x + tooltip.x, pos_y + tooltip.y, width, height, clr, tablename)
            table.insert(tooltip.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        local function ttRect(visible, pos_x, pos_y, width, height, clr, tablename)
            draw:FilledRect(visible, pos_x + tooltip.x, pos_y + tooltip.y, width, height, clr, tablename)
            table.insert(tooltip.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        local function ttText(text, visible, centered, pos_x, pos_y, tablename)
            draw:OutlinedText(
                text,
                2,
                visible,
                pos_x + tooltip.x,
                pos_y + tooltip.y,
                13,
                centered,
                { 255, 255, 255, 255 },
                { 0, 0, 0 },
                tablename
            )
            table.insert(tooltip.postable, { tablename[#tablename], pos_x, pos_y })
        end
    
        ttRect(
            false,
            tooltip.x + 1,
            tooltip.y + 1,
            1,
            28,
            { self.mc[1], self.mc[2], self.mc[3], 255 },
            tooltip.drawings
        )
        ttRect(
            false,
            tooltip.x + 2,
            tooltip.y + 1,
            1,
            28,
            { self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40, 255 },
            tooltip.drawings
        )
        ttOutline(false, tooltip.x, tooltip.y, 4, 30, { 20, 20, 20, 255 }, tooltip.drawings)
        ttRect(false, tooltip.x + 4, tooltip.y, 100, 30, { 40, 40, 40, 255 }, tooltip.drawings)
        ttOutline(false, tooltip.x - 1, tooltip.y - 1, 102, 32, { 0, 0, 0, 255 }, tooltip.drawings)
        ttOutline(false, tooltip.x + 3, tooltip.y, 102, 30, { 20, 20, 20, 255 }, tooltip.drawings)
        ttText(tooltip.text, false, false, tooltip.x + 7, tooltip.y + 1, tooltip.drawings)
    
        local bbmouse = {}
        function self:SetToolTip(x, y, text, visible, dt)
            dt = dt or 0
            x = x or tooltip.x
            y = y or tooltip.y
            tooltip.x = x
            tooltip.y = y
            if tooltip.time < 1 and visible then
                if tooltip.time < -1 then
                    tooltip.time = -1
                end
                tooltip.time += dt
            else
                tooltip.time -= dt
                if tooltip.time < -1 then
                    tooltip.time = -1
                end
            end
            if not visible and tooltip.time < 0 then
                tooltip.time = -1
            end
            if tooltip.time > 1 then
                tooltip.time = 1
            end
            for k, v in ipairs(tooltip.drawings) do
                v.Visible = tooltip.time > 0
            end
    
            tooltip.active = visible
            if text then
                tooltip.drawings[7].Text = text
            end
            for k, v in pairs(tooltip.postable) do
                v[1].Position = Vector2.new(x + v[2], y + v[3])
                v[1].Transparency = math.min((0.3 + tooltip.time) ^ 3 - 1, self.fade_amount or 1)
            end
            tooltip.drawings[1].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
            tooltip.drawings[2].Color = RGB(self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40)
    
            local tb = tooltip.drawings[7].TextBounds
    
            tooltip.drawings[1].Size = Vector2.new(1, tb.Y + 3)
            tooltip.drawings[2].Size = Vector2.new(1, tb.Y + 3)
            tooltip.drawings[3].Size = Vector2.new(4, tb.Y + 5)
            tooltip.drawings[4].Size = Vector2.new(tb.X + 6, tb.Y + 5)
            tooltip.drawings[5].Size = Vector2.new(tb.X + 12, tb.Y + 7)
            tooltip.drawings[6].Size = Vector2.new(tb.X + 7, tb.Y + 5)
            if bbmouse[#bbmouse] then
                bbmouse[#bbmouse].Visible = visible
                bbmouse[#bbmouse].Transparency = 1 - tooltip.time
            end
        end
    
        self:SetToolTip(500, 500, "", false)
    
        -- mouse shiz
        local mousie = {
            x = 100,
            y = 240,
        }
        draw:Triangle(
            true,
            true,
            { mousie.x, mousie.y },
            { mousie.x, mousie.y + 15 },
            { mousie.x + 10, mousie.y + 10 },
            { 127, 72, 163, 255 },
            bbmouse
        )
        table.insert(self.clrs.norm, bbmouse[#bbmouse])
        draw:Triangle(
            true,
            false,
            { mousie.x, mousie.y },
            { mousie.x, mousie.y + 15 },
            { mousie.x + 10, mousie.y + 10 },
            { 0, 0, 0, 255 },
            bbmouse
        )
        draw:OutlinedText("", 2, false, 0, 0, 13, false, { 255, 255, 255, 255 }, { 15, 15, 15 }, bbmouse)
        draw:OutlinedText("?", 2, false, 0, 0, 13, false, { 255, 255, 255, 255 }, { 15, 15, 15 }, bbmouse)

        hook:Add("Mouse.Move", "BBOT:Menu.Cursor", function(b, x, y)
            for k = 1, #bbmouse do
                local v = bbmouse[k]
                if k ~= #bbmouse and k ~= #bbmouse - 1 then
                    v.PointA = Vector2.new(x, y + 36)
                    v.PointB = Vector2.new(x, y + 36 + 15)
                    v.PointC = Vector2.new(x + 10, y + 46)
                else
                    v.Position = Vector2.new(x + 10, y + 46)
                end
            end
        end)
    
        function self:SetColor(r, g, b)
            self.watermark.rect[1].Color = RGB(r - 40, g - 40, b - 40)
            self.watermark.rect[2].Color = RGB(r, g, b)
    
            for k, v in pairs(self.clrs.norm) do
                v.Color = RGB(r, g, b)
            end
            for k, v in pairs(self.clrs.dark) do
                v.Color = RGB(r - 40, g - 40, b - 40)
            end
            local menucolor = { r, g, b }
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == TOGGLE then
                            if not v2[1] then
                                for i = 0, 3 do
                                    v2[4][i + 1].Color = color.range(i, {
                                        [1] = { start = 0, color = RGB(50, 50, 50) },
                                        [2] = { start = 3, color = RGB(30, 30, 30) },
                                    })
                                end
                            else
                                for i = 0, 3 do
                                    v2[4][i + 1].Color = color.range(i, {
                                        [1] = { start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3]) },
                                        [2] = {
                                            start = 3,
                                            color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40),
                                        },
                                    })
                                end
                            end
                        elseif v2[2] == SLIDER then
                            for i = 0, 3 do
                                v2[4][i + 1].Color = color.range(i, {
                                    [1] = { start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3]) },
                                    [2] = {
                                        start = 3,
                                        color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40),
                                    },
                                })
                            end
                        end
                    end
                end
            end
        end
    
        local function UpdateConfigs()
            local configthing = self.options["Settings"]["Configuration"]["Configs"]
    
            configthing[6] = GetConfigs()
            if configthing[1] > #configthing[6] then
                configthing[1] = #configthing[6]
            end
            configthing[4][1].Text = configthing[6][configthing[1]]
        end
    
        self.keybind_open = nil
    
        self.dropbox_open = nil
    
        self.colorPickerOpen = false
    
        self.textboxopen = nil
    
        local shooties = {}
        local isPlayerScoped = false
    
        function self:InputBeganMenu(key) --ANCHOR self input
            if key.KeyCode == Enum.KeyCode.Delete then
                cp.dragging_m = false
                cp.dragging_r = false
                cp.dragging_b = false
    
                customChatSpam = {}
                customKillSay = {}
                local customtxt = readfile("bitchbot/chatspam.txt")
                for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
                    table.insert(customChatSpam, s)
                end
                customtxt = readfile("bitchbot/killsay.txt")
                for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
                    table.insert(customKillSay, s)
                end
                UpdateConfigs()
                if self.open and not self.fading then
                    for k = 1, #self.options do
                        local v = self.options[k]
                        for k1, v1 in pairs(v) do
                            for k2, v2 in pairs(v1) do
                                if v2[2] == SLIDER and v2[5] then
                                    v2[5] = false
                                elseif v2[2] == DROPBOX and v2[5] then
                                    v2[5] = false
                                elseif v2[2] == COMBOBOX and v2[5] then
                                    v2[5] = false
                                elseif v2[2] == TOGGLE then
                                    if v2[5] ~= nil then
                                        if v2[5][2] == KEYBIND and v2[5][5] then
                                            v2[5][4][2].Color = RGB(30, 30, 30)
                                            v2[5][5] = false
                                        elseif v2[5][2] == COLORPICKER and v2[5][5] then
                                            v2[5][5] = false
                                        end
                                    end
                                elseif v2[2] == BUTTON then
                                    if v2[1] then
                                        for i = 0, 8 do
                                            v2[4][i + 1].Color = color.range(i, {
                                                [1] = { start = 0, color = RGB(50, 50, 50) },
                                                [2] = { start = 8, color = RGB(35, 35, 35) },
                                            })
                                        end
                                        v2[1] = false
                                    end
                                end
                            end
                        end
                    end
                    self.keybind_open = nil
                    self:SetKeybindSelect(false, 20, 20, 1)
                    self.dropbox_open = nil
                    self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
                    self.colorPickerOpen = nil
                    self:SetToolTip(nil, nil, nil, false)
                    self:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
                end
                if not self.fading then
                    self.fading = true
                    self.fadestart = tick()
                end
            end
    
            if self == nil then
                return
            end
    
            if self.textboxopen then
                if key.KeyCode == Enum.KeyCode.Delete or key.KeyCode == Enum.KeyCode.Return then
                    for k, v in pairs(self.options) do
                        for k1, v1 in pairs(v) do
                            for k2, v2 in pairs(v1) do
                                if v2[2] == TEXTBOX then
                                    if v2[5] then
                                        v2[5] = false
                                        v2[4].Color = RGB(255, 255, 255)
                                        self.textboxopen = false
                                        v2[4].Text = v2[1]
                                    end
                                end
                            end
                        end
                    end
                end
            end
    
            if self.open and not self.fading then
                for k, v in pairs(self.options) do
                    for k1, v1 in pairs(v) do
                        for k2, v2 in pairs(v1) do
                            if v2[2] == TOGGLE then
                                if v2[5] ~= nil then
                                    if v2[5][2] == KEYBIND and v2[5][5] and key.KeyCode.Value ~= 0 then
                                        v2[5][4][2].Color = RGB(30, 30, 30)
                                        v2[5][4][1].Text = KeyEnumToName(key.KeyCode)
                                        if KeyEnumToName(key.KeyCode) == "None" then
                                            v2[5][1] = nil
                                        else
                                            v2[5][1] = key.KeyCode
                                        end
                                        v2[5][5] = false
                                    end
                                end
                            elseif v2[2] == TEXTBOX then --ANCHOR TEXTBOXES
                                if v2[5] then
                                    if not INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftControl) then
                                        if string.len(v2[1]) <= 28 then
                                            if table.find(textBoxLetters, KeyEnumToName(key.KeyCode)) then
                                                if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
                                                    v2[1] ..= string.upper(KeyEnumToName(key.KeyCode))
                                                else
                                                    v2[1] ..= string.lower(KeyEnumToName(key.KeyCode))
                                                end
                                            elseif KeyEnumToName(key.KeyCode) == "Space" then
                                                v2[1] ..= " "
                                            elseif keymodifiernames[KeyEnumToName(key.KeyCode)] ~= nil then
                                                if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
                                                    v2[1] ..= KeyModifierToName(KeyEnumToName(key.KeyCode), v2[6])
                                                else
                                                    v2[1] ..= KeyEnumToName(key.KeyCode)
                                                end
                                            elseif KeyEnumToName(key.KeyCode) == "Back" and v2[1] ~= "" then
                                                v2[1] = string.sub(v2[1], 0, #v2[1] - 1)
                                            end
                                        end
                                        v2[4].Text = v2[1] .. "|"
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        local INPUT_SERVICE = BBOT.service:GetService("UserInputService")
        function self:InputBeganKeybinds(key) -- this is super shit because once we add mouse we need to change all this shit to be the contextaction stuff
            if INPUT_SERVICE:GetFocusedTextBox() or self.textboxopen then
                return
            end
            for i = 1, #self.keybinds do
                local value = self.keybinds[i][1]
                if key.KeyCode == value[5][1] then
                    value[5].lastvalue = value[5].relvalue
                    if value[5].toggletype == 2 then
                        value[5].relvalue = not value[5].relvalue
                    elseif value[5].toggletype == 1 then
                        value[5].relvalue = true
                    elseif value[5].toggletype == 3 then
                        value[5].relvalue = false
                    end
                elseif value[5].toggletype == 4 then
                    value[5].relvalue = true
                end
                if value[5].lastvalue ~= value[5].relvalue then
                    --value[5].event:fire(value[5].relvalue)
                end
            end
        end
    
        function self:InputEndedKeybinds(key)
            for i = 1, #self.keybinds do
                local value = self.keybinds[i][1]
                value[5].lastvalue = value[5].relvalue
                if key.KeyCode == value[5][1] then
                    if value[5].toggletype == 1 then
                        value[5].relvalue = false
                    elseif value[5].toggletype == 3 then
                        value[5].relvalue = true
                    end
                end
                if value[5].lastvalue ~= value[5].relvalue then
                    --value[5].event:fire(value[5].relvalue)
                end
            end
        end
    
        function self:SetMenuPos(x, y)
            for k, v in pairs(self.postable) do
                if v[1].Visible then
                    v[1].Position = Vector2.new(x + v[2], y + v[3])
                end
            end
        end
    
        function self:MouseInArea(x, y, width, height)
            return LOCAL_MOUSE.x > x and LOCAL_MOUSE.x < x + width and LOCAL_MOUSE.y > 36 + y and LOCAL_MOUSE.y < 36 + y + height
        end
    
        function self:MouseInMenu(x, y, width, height)
            return LOCAL_MOUSE.x > self.x + x and LOCAL_MOUSE.x < self.x + x + width and LOCAL_MOUSE.y > self.y - 36 + y and LOCAL_MOUSE.y < self.y - 36 + y + height
        end
    
        function self:MouseInColorPicker(x, y, width, height)
            return LOCAL_MOUSE.x > cp.x + x and LOCAL_MOUSE.x < cp.x + x + width and LOCAL_MOUSE.y > cp.y - 36 + y and LOCAL_MOUSE.y < cp.y - 36 + y + height
        end
    
        local keyz = {}
        for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
            keyz[v.Value] = v
        end
    
    
        function self:GetVal(tab, groupbox, name, ...)
            local args = { ... }
    
            local option = self.options[tab][groupbox][name]
            if not option then print(tab, groupbox, name) end
            if args[1] == nil then
                if option[2] == TOGGLE then
                    local lastval = option[7]
                    option[7] = option[1]
                    return option[1], lastval
                elseif option[2] ~= COMBOBOX then
                    return option[1]
                else
                    local temptable = {}
                    for k = 1, #option[1] do
                        local v = option[1][k]
                        table.insert(temptable, v[2])
                    end
                    return temptable
                end
            else
                if args[1] == KEYBIND or args[1] == COLOR then
                    if args[2] then
                        return RGB(option[5][1][1], option[5][1][2], option[5][1][3])
                    else
                        return option[5][1]
                    end
                elseif args[1] == COLOR1 then
                    if args[2] then
                        return RGB(option[5][1][1][1][1], option[5][1][1][1][2], option[5][1][1][1][3])
                    else
                        return option[5][1][1][1]
                    end
                elseif args[1] == COLOR2 then
                    if args[2] then
                        return RGB(option[5][1][2][1][1], option[5][1][2][1][2], option[5][1][2][1][3])
                    else
                        return option[5][1][2][1]
                    end
                end
            end
        end
    
        function self:GetKey(tab, groupbox, name)
            local option = self.options[tab][groupbox][name][5]
            local return1, return2, return3
            if self:GetVal(tab, groupbox, name) then
                if option.toggletype ~= 0 then
                    if option.lastvalue == nil then
                        option.lastvalue = option.relvalue
                    end
                    return1, return2, return3 = option.relvalue, option.lastvalue, option.event
                    option.lastvalue = option.relvalue
                end
            end
            return return1, return2, return3
        end
    
        function self:SetKey(tab, groupbox, name, val)
            val = val or false
            local option = self.options[tab][groupbox][name][5]
            if option.toggletype ~= 0 then
                option.lastvalue = option.relvalue
                option.relvalue = val
                if option.lastvalue ~= option.relvalue then
                    --option.event:fire(option.relvalue)
                end
            end
        end
    
        local menuElementTypes = { [TOGGLE] = "toggle", [SLIDER] = "slider", [DROPBOX] = "dropbox", [TEXTBOX] = "textbox" }
        local doubleclickDelay = 1
        local buttonsInQue = {}
    
        local function SaveCurSettings() --ANCHOR figgies
            local figgy = "BitchBot v2\nmade with <3 by nata and bitch\n\n" -- screw zarzel XD (and json and classy) 
    
            for k, v in next, menuElementTypes do
                figgy ..= v .. "s {\n"
                for k1, v1 in pairs(self.options) do
                    for k2, v2 in pairs(v1) do
                        for k3, v3 in pairs(v2) do
                            if v3[2] == k and k3 ~= "Configs" and k3 ~= "Player Status" and k3 ~= "ConfigName"
                            then
                                figgy ..= k1 .. "|" .. k2 .. "|" .. k3 .. "|" .. tostring(v3[1]) .. "\n"
                            end
                        end
                    end
                end
                figgy = figgy .. "}\n"
            end
            figgy = figgy .. "comboboxes {\n"
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == COMBOBOX then
                            local boolz = ""
                            for k3, v3 in pairs(v2[1]) do
                                boolz = boolz .. tostring(v3[2]) .. ", "
                            end
                            figgy = figgy .. k .. "|" .. k1 .. "|" .. k2 .. "|" .. boolz .. "\n"
                        end
                    end
                end
            end
            figgy = figgy .. "}\n"
            figgy = figgy .. "keybinds {\n"
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == TOGGLE then
                            if v2[5] ~= nil then
                                if v2[5][2] == KEYBIND then
                                    local toggletype = "|" .. tostring(v2[5].toggletype)
    
                                    if v2[5][1] == nil then
                                        figgy = figgy
                                            .. k
                                            .. "|"
                                            .. k1
                                            .. "|"
                                            .. k2
                                            .. "|nil"
                                            .. "|"
                                            .. tostring(v2[5].toggletype)
                                            .. "\n"
                                    else
                                        figgy = figgy
                                            .. k
                                            .. "|"
                                            .. k1
                                            .. "|"
                                            .. k2
                                            .. "|"
                                            .. tostring(v2[5][1].Value)
                                            .. "|"
                                            .. tostring(v2[5].toggletype)
                                            .. "\n"
                                    end
                                end
                            end
                        end
                    end
                end
            end
            figgy = figgy .. "}\n"
            figgy = figgy .. "colorpickers {\n"
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == TOGGLE then
                            if v2[5] ~= nil then
                                if v2[5][2] == COLORPICKER then
                                    local clrz = ""
                                    for k3, v3 in pairs(v2[5][1]) do
                                        clrz = clrz .. tostring(v3) .. ", "
                                    end
                                    figgy = figgy .. k .. "|" .. k1 .. "|" .. k2 .. "|" .. clrz .. "\n"
                                end
                            end
                        end
                    end
                end
            end
            figgy = figgy .. "}\n"
            figgy = figgy .. "double colorpickers {\n"
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == TOGGLE then
                            if v2[5] ~= nil then
                                if v2[5][2] == DOUBLE_COLORPICKER then
                                    local clrz1 = ""
                                    for k3, v3 in pairs(v2[5][1][1][1]) do
                                        clrz1 = clrz1 .. tostring(v3) .. ", "
                                    end
                                    local clrz2 = ""
                                    for k3, v3 in pairs(v2[5][1][2][1]) do
                                        clrz2 = clrz2 .. tostring(v3) .. ", "
                                    end
                                    figgy = figgy .. k .. "|" .. k1 .. "|" .. k2 .. "|" .. clrz1 .. "|" .. clrz2 .. "\n"
                                end
                            end
                        end
                    end
                end
            end
            figgy = figgy .. "}\n"
    
            return figgy
        end
    
        local function LoadConfig(loadedcfg)
            local lines = {}
    
            for s in loadedcfg:gmatch("[^\r\n]+") do
                table.insert(lines, s)
            end
    
            if lines[1] == "BitchBot v2" then
                local start = nil
                for i, v in next, lines do
                    if v == "toggles {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
    
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                    then
                        if tt[4] == "true" then
                            self.options[tt[1]][tt[2]][tt[3]][1] = true
                        else
                            self.options[tt[1]][tt[2]][tt[3]][1] = false
                        end
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "sliders {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                    then
                        self.options[tt[1]][tt[2]][tt[3]][1] = tonumber(tt[4])
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "dropboxs {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
    
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                    then
                        local num = tonumber(tt[4])
                        if num > #self.options[tt[1]][tt[2]][tt[3]][6] then
                            num = #self.options[tt[1]][tt[2]][tt[3]][6]
                        elseif num < 0 then
                            num = 1
                        end
                        self.options[tt[1]][tt[2]][tt[3]][1] = num
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "textboxs {" then
                        start = i
                        break
                    end
                end
                if start ~= nil then
                    local end_ = nil
                    for i, v in next, lines do
                        if i > start and v == "}" then
                            end_ = i
                            break
                        end
                    end
                    for i = 1, end_ - start - 1 do
                        local tt = string.split(lines[i + start], "|")
                        if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                        then
                            self.options[tt[1]][tt[2]][tt[3]][1] = tostring(tt[4])
                        end
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "comboboxes {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                    then
                        local subs = string.split(tt[4], ",")
    
                        for i, v in ipairs(subs) do
                            local opt = string.gsub(v, " ", "")
                            if opt == "true" then
                                self.options[tt[1]][tt[2]][tt[3]][1][i][2] = true
                            else
                                self.options[tt[1]][tt[2]][tt[3]][1][i][2] = false
                            end
                            if i == #subs - 1 then
                                break
                            end
                        end
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "keybinds {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil and self.options[tt[1]][tt[2]][tt[3]][5] ~= nil
                    then
                        if tt[5] ~= nil then
                            local toggletype = clamp(tonumber(tt[5]), 1, 4)
                            if self.options[tt[1]][tt[2]][tt[3]][5].toggletype ~= 0 then
                                self.options[tt[1]][tt[2]][tt[3]][5].toggletype = toggletype
                            end
                        end
    
                        if tt[4] == "nil" then
                            self.options[tt[1]][tt[2]][tt[3]][5][1] = nil
                        else
                            self.options[tt[1]][tt[2]][tt[3]][5][1] = keyz[tonumber(tt[4])]
                        end
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "colorpickers {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                    then
                        local subs = string.split(tt[4], ",")
    
                        if type(self.options[tt[1]][tt[2]][tt[3]][5][1][1]) == "table" then
                            continue
                        end
                        for i, v in ipairs(subs) do
                            if self.options[tt[1]][tt[2]][tt[3]][5][1][i] == nil then
                                break
                            end
                            local opt = string.gsub(v, " ", "")
                            self.options[tt[1]][tt[2]][tt[3]][5][1][i] = tonumber(opt)
                            if i == #subs - 1 then
                                break
                            end
                        end
                    
                    end
                end
    
                local start = nil
                for i, v in next, lines do
                    if v == "double colorpickers {" then
                        start = i
                        break
                    end
                end
                local end_ = nil
                for i, v in next, lines do
                    if i > start and v == "}" then
                        end_ = i
                        break
                    end
                end
                for i = 1, end_ - start - 1 do
                    local tt = string.split(lines[i + start], "|")
                    if self.options[tt[1]] ~= nil and self.options[tt[1]][tt[2]] ~= nil and self.options[tt[1]][tt[2]][tt[3]] ~= nil
                    then
                        local subs = { string.split(tt[4], ","), string.split(tt[5], ",") }
    
                        for i, v in ipairs(subs) do
                            if type(self.options[tt[1]][tt[2]][tt[3]][5][1][i]) == "number" then
                                break
                            end
                            for i1, v1 in ipairs(v) do
                                
                                    
                                if self.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] == nil then
                                    break
                                end
                                local opt = string.gsub(v1, " ", "")
                                self.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] = tonumber(opt)
                                if i1 == #v - 1 then
                                    break
                                end
                            end
                        end
                    end
                end
    
                for k, v in pairs(self.options) do
                    for k1, v1 in pairs(v) do
                        for k2, v2 in pairs(v1) do
                            if v2[2] == TOGGLE then
                                if not v2[1] then
                                    for i = 0, 3 do
                                        v2[4][i + 1].Color = color.range(i, {
                                            [1] = { start = 0, color = RGB(50, 50, 50) },
                                            [2] = { start = 3, color = RGB(30, 30, 30) },
                                        })
                                    end
                                else
                                    for i = 0, 3 do
                                        v2[4][i + 1].Color = color.range(i, {
                                            [1] = { start = 0, color = RGB(self.mc[1], self.mc[2], self.mc[3]) },
                                            [2] = {
                                                start = 3,
                                                color = RGB(self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40),
                                            },
                                        })
                                    end
                                end
                                if v2[5] ~= nil then
                                    if v2[5][2] == KEYBIND then
                                        v2[5][4][2].Color = RGB(30, 30, 30)
                                        v2[5][4][1].Text = KeyEnumToName(v2[5][1])
                                    elseif v2[5][2] == COLORPICKER then
                                        v2[5][4][1].Color = RGB(v2[5][1][1], v2[5][1][2], v2[5][1][3])
                                        for i = 2, 3 do
                                            v2[5][4][i].Color = RGB(v2[5][1][1] - 40, v2[5][1][2] - 40, v2[5][1][3] - 40)
                                        end
                                    elseif v2[5][2] == DOUBLE_COLORPICKER then
                                        if type(v2[5][1][1]) == "table" then 
                                            for i, v3 in ipairs(v2[5][1]) do
                                                v3[4][1].Color = RGB(v3[1][1], v3[1][2], v3[1][3])
                                                for i1 = 2, 3 do
                                                    v3[4][i1].Color = RGB(v3[1][1] - 40, v3[1][2] - 40, v3[1][3] - 40)
                                                end
                                            end
                                        end
                                    end
                                end
                            elseif v2[2] == SLIDER then
                                if v2[1] < v2[6][1] then
                                    v2[1] = v2[6][1]
                                elseif v2[1] > v2[6][2] then
                                    v2[1] = v2[6][2]
                                end
    
                                local decplaces = v2.decimal and string.rep("0", math.log(1 / v2.decimal) / math.log(10))
                                if decplaces and math.abs(v2[1]) < v2.decimal then
                                    v2[1] = 0
                                end
                                v2[4][5].Text = v2.custom[v2[1]] or (v2[1] == math.floor(v2[1]) and v2.decimal) and tostring(v2[1]) .. "." .. decplaces .. v2[4][6] or tostring(v2[1]) .. v2[4][6]
                                -- v2[4][5].Text = tostring(v2[1]).. v2[4][6]
    
                                for i = 1, 4 do
                                    v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
                                end
                            elseif v2[2] == DROPBOX then
                                if v2[6][v2[1]] == nil then
                                    v2[1] = 1
                                end
                                v2[4][1].Text = v2[6][v2[1]]
                            elseif v2[2] == COMBOBOX then
                                local textthing = ""
                                for k3, v3 in pairs(v2[1]) do
                                    if v3[2] then
                                        if textthing == "" then
                                            textthing = v3[1]
                                        else
                                            textthing = textthing .. ", " .. v3[1]
                                        end
                                    end
                                end
                                textthing = textthing ~= "" and textthing or "None"
                                textthing = string.cut(textthing, 25)
                                v2[4][1].Text = textthing
                            elseif v2[2] == TEXTBOX then
                                v2[4].Text = v2[1]
                            end
                        end
                    end
                end
            end
        end
        function self.saveconfig()
            local figgy = SaveCurSettings()
            writefile(
                "bitchbot/"
                    .. self.game
                    .. "/"
                    .. self.options["Settings"]["Configuration"]["ConfigName"][1]
                    .. ".bb",
                figgy
            )
            CreateNotification('Saved "' .. self.options["Settings"]["Configuration"]["ConfigName"][1] .. '.bb"!')
            UpdateConfigs()
        end
        
        function self.loadconfig()
            local configname = "bitchbot/"
                .. self.game
                .. "/"
                .. self.options["Settings"]["Configuration"]["ConfigName"][1]
                .. ".bb"
            if not isfile(configname) then
                CreateNotification(
                    '"'
                        .. self.options["Settings"]["Configuration"]["ConfigName"][1]
                        .. '.bb" is not a valid config.'
                )
                return
            end
        
            local curcfg = SaveCurSettings()
            local loadedcfg = readfile(configname)
        
            if pcall(LoadConfig, loadedcfg) then
                CreateNotification('Loaded "' .. self.options["Settings"]["Configuration"]["ConfigName"][1] .. '.bb"!')
            else
                LoadConfig(curcfg)
                CreateNotification(
                    'There was an issue loading "'
                        .. self.options["Settings"]["Configuration"]["ConfigName"][1]
                        .. '.bb"'
                )
            end
        end
    
        local function buttonpressed(bp)
            if bp.doubleclick then
                if buttonsInQue[bp] and tick() - buttonsInQue[bp] < doubleclickDelay then
                    buttonsInQue[bp] = 0
                else
                    for button, time in next, buttonsInQue do
                        buttonsInQue[button] = 0
                    end
                    buttonsInQue[bp] = tick()
                    return
                end
            end
           -- FireEvent("bb_buttonpressed", bp.tab, bp.groupbox, bp.name)
            --ButtonPressed:Fire(bp.tab, bp.groupbox, bp.name)
            if bp == self.options["Settings"]["Cheat Settings"]["Unload Cheat"] then
                self.fading = true
                wait()
                self:unload()
            elseif bp == self.options["Settings"]["Cheat Settings"]["Set Clipboard Game ID"] then
                setclipboard(game.JobId)
                CreateNotification("Set Clipboard Game ID! (".. tostring(game.JobId)..")")
            elseif bp == self.options["Settings"]["Configuration"]["Save Config"] then
                self.saveconfig()
            elseif bp == self.options["Settings"]["Configuration"]["Delete Config"] then
                delfile(
                    "bitchbot/"
                        .. self.game
                        .. "/"
                        .. self.options["Settings"]["Configuration"]["ConfigName"][1]
                        .. ".bb"
                )
                CreateNotification('Deleted "' .. self.options["Settings"]["Configuration"]["ConfigName"][1] .. '.bb"!')
                UpdateConfigs()
            elseif bp == self.options["Settings"]["Configuration"]["Load Config"] then
                self.loadconfig()
            end
        end
    
        local function MouseButton2Event()
            if self.colorPickerOpen or self.dropbox_open then
                return
            end
    
            for k, v in pairs(self.options) do
                if self.tabnames[self.activetab] == k then
                    for k1, v1 in pairs(v) do
                        local pass = true
                        for k3, v3 in pairs(self.multigroups) do
                            if k == k3 then
                                for k4, v4 in pairs(v3) do
                                    for k5, v5 in pairs(v4.vals) do
                                        if k1 == k5 then
                                            pass = v5
                                        end
                                    end
                                end
                            end
                        end
    
                        if pass then
                            for k2, v2 in pairs(v1) do --ANCHOR more self bs
                                if v2[2] == TOGGLE then
                                    if v2[5] ~= nil then
                                        if v2[5][2] == KEYBIND then
                                            if self:MouseInMenu(v2[5][3][1], v2[5][3][2], 44, 16) then
                                                if self.keybind_open ~= v2 and v2[5].toggletype ~= 0 then
                                                    self.keybind_open = v2
                                                    self:SetKeybindSelect(
                                                        true,
                                                        v2[5][3][1] + self.x,
                                                        v2[5][3][2] + 16 + self.y,
                                                        v2[5].toggletype
                                                    )
                                                else
                                                    self.keybind_open = nil
                                                    self:SetKeybindSelect(false, 20, 20, 1)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        local function menucolor()
            if self.open then
                if self:GetVal("Settings", "Cheat Settings", "Menu Accent") then
                    local clr = self:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR, true)
                    self.mc = { clr.R * 255, clr.G * 255, clr.B * 255 }
                else
                    self.mc = { 127, 72, 163 }
                end
                self:SetColor(self.mc[1], self.mc[2], self.mc[3])
    
                local wme = self:GetVal("Settings", "Cheat Settings", "Watermark")
                for k, v in pairs(self.watermark.rect) do
                    v.Visible = wme
                end
                self.watermark.text[1].Visible = wme
            end
        end
        local function MouseButton1Event() --ANCHOR self mouse down func
            self.dropbox_open = nil
            self.textboxopen = false
    
            self:SetKeybindSelect(false, 20, 20, 1)
            if self.keybind_open then
                local key = self.keybind_open
                local foundkey = false
                for i = 1, 4 do
                    if self:MouseInMenu(key[5][3][1], key[5][3][2] + 16 + ((i - 1) * 21), 70, 21) then
                        foundkey = true
                        self.keybind_open[5].toggletype = i
                        self.keybind_open[5].relvalue = false
                    end
                end
                self.keybind_open = nil
                if foundkey then
                    return
                end
            end
    
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == DROPBOX and v2[5] then
                            if not self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) then
                                self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
                                v2[5] = false
                            else
                                self.dropbox_open = v2
                            end
                        end
                        if v2[2] == COMBOBOX and v2[5] then
                            if not self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) then
                                self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
                                v2[5] = false
                            else
                                self.dropbox_open = v2
                            end
                        end
                        if v2[2] == TOGGLE then
                            if v2[5] ~= nil then
                                if v2[5][2] == KEYBIND then
                                    if v2[5][5] == true then
                                        v2[5][4][2].Color = RGB(30, 30, 30)
                                        v2[5][5] = false
                                    end
                                elseif v2[5][2] == COLORPICKER then
                                    if v2[5][5] == true then
                                        if not self:MouseInColorPicker(0, 0, cp.w, cp.h) then
                                            if self.colorPickerOpen then
                                                
                                                local tempclr = cp.oldcolor
                                                self.colorPickerOpen[4][1].Color = tempclr
                                                for i = 2, 3 do
                                                    self.colorPickerOpen[4][i].Color = RGB(
                                                        math.floor(tempclr.R * 255) - 40,
                                                        math.floor(tempclr.G * 255) - 40,
                                                        math.floor(tempclr.B * 255) - 40
                                                    )
                                                end
                                                if cp.alpha then
                                                    self.colorPickerOpen[1] = {
                                                        math.floor(tempclr.R * 255),
                                                        math.floor(tempclr.G * 255),
                                                        math.floor(tempclr.B * 255),
                                                        cp.oldcoloralpha,
                                                    }
                                                else
                                                    self.colorPickerOpen[1] = {
                                                        math.floor(tempclr.R * 255),
                                                        math.floor(tempclr.G * 255),
                                                        math.floor(tempclr.B * 255),
                                                    }
                                                end
                                            end
                                            self:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
                                            v2[5][5] = false
                                            self.colorPickerOpen = nil -- close colorpicker
                                        end
                                    end
                                elseif v2[5][2] == DOUBLE_COLORPICKER then
                                    for k3, v3 in pairs(v2[5][1]) do
                                        if v3[5] == true then
                                            if not self:MouseInColorPicker(0, 0, cp.w, cp.h) then
                                                if self.colorPickerOpen then
                                                    local tempclr = cp.oldcolor
                                                    self.colorPickerOpen[4][1].Color = tempclr
                                                    for i = 2, 3 do
                                                        self.colorPickerOpen[4][i].Color = RGB(
                                                            math.floor(tempclr.R * 255) - 40,
                                                            math.floor(tempclr.G * 255) - 40,
                                                            math.floor(tempclr.B * 255) - 40
                                                        )
                                                    end
                                                    if cp.alpha then
                                                        self.colorPickerOpen[1] = {
                                                            math.floor(tempclr.R * 255),
                                                            math.floor(tempclr.G * 255),
                                                            math.floor(tempclr.B * 255),
                                                            cp.oldcoloralpha,
                                                        }
                                                    else
                                                        self.colorPickerOpen[1] = {
                                                            math.floor(tempclr.R * 255),
                                                            math.floor(tempclr.G * 255),
                                                            math.floor(tempclr.B * 255),
                                                        }
                                                    end
                                                end
                                                self:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
                                                v3[5] = false
                                                self.colorPickerOpen = nil -- close colorpicker
                                                
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if v2[2] == TEXTBOX and v2[5] then
                            v2[4].Color = RGB(255, 255, 255)
                            v2[5] = false
                            v2[4].Text = v2[1]
                        end
                    end
                end
            end
            for i = 1, #menutable do
                if self:MouseInMenu(
                        10 + ((i - 1) * math.floor((self.w - 20) / #menutable)),
                        27,
                        math.floor((self.w - 20) / #menutable),
                        32
                    )
                then
                    self.activetab = i
                    setActiveTab(self.activetab)
                    self:SetMenuPos(self.x, self.y)
                    self:SetToolTip(nil, nil, nil, false)
                end
            end
            if self.colorPickerOpen then
                if self:MouseInColorPicker(197, cp.h - 25, 75, 20) then
                    --apply newcolor to oldcolor
                    local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
                    self.colorPickerOpen[4][1].Color = tempclr
                    for i = 2, 3 do
                        self.colorPickerOpen[4][i].Color = RGB(
                            math.floor(tempclr.R * 255) - 40,
                            math.floor(tempclr.G * 255) - 40,
                            math.floor(tempclr.B * 255) - 40
                        )
                    end
                    if cp.alpha then
                        self.colorPickerOpen[1] = {
                            math.floor(tempclr.R * 255),
                            math.floor(tempclr.G * 255),
                            math.floor(tempclr.B * 255),
                            cp.hsv.a,
                        }
                    else
                        self.colorPickerOpen[1] = {
                            math.floor(tempclr.R * 255),
                            math.floor(tempclr.G * 255),
                            math.floor(tempclr.B * 255),
                        }
                    end
                    self.colorPickerOpen = nil
                    self:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
                end
                if self:MouseInColorPicker(264, 2, 14, 14) then
                    -- x out
                    local tempclr = cp.oldcolor
                    self.colorPickerOpen[4][1].Color = tempclr
                    for i = 2, 3 do
                        self.colorPickerOpen[4][i].Color = RGB(
                            math.floor(tempclr.R * 255) - 40,
                            math.floor(tempclr.G * 255) - 40,
                            math.floor(tempclr.B * 255) - 40
                        )
                    end
                    if cp.alpha then
                        self.colorPickerOpen[1] = {
                            math.floor(tempclr.R * 255),
                            math.floor(tempclr.G * 255),
                            math.floor(tempclr.B * 255),
                            cp.oldcoloralpha,
                        }
                    else
                        self.colorPickerOpen[1] = {
                            math.floor(tempclr.R * 255),
                            math.floor(tempclr.G * 255),
                            math.floor(tempclr.B * 255),
                        }
                    end
                    self.colorPickerOpen = nil
                    self:SetColorPicker(false, { 255, 0, 0 }, nil, false, "hahaha", 400, 200)
                end
                if self:MouseInColorPicker(10, 23, 160, 160) then
                    cp.dragging_m = true
                    --set value and saturation
                elseif self:MouseInColorPicker(176, 23, 14, 160) then
                    cp.dragging_r = true
                    --set hue
                elseif self:MouseInColorPicker(10, 189, 160, 14) and cp.alpha then
                    cp.dragging_b = true
                    --set transparency
                end
    
                if self:MouseInColorPicker(197, 37, 75, 20) then
                    self.copied_clr = newcolor.Color
                    --copy newcolor
                elseif self:MouseInColorPicker(197, 57, 75, 20) then
                    --paste newcolor
                    if self.copied_clr ~= nil then
                        local cpa = false
                        local clrtable = { self.copied_clr.R * 255, self.copied_clr.G * 255, self.copied_clr.B * 255 }
                        if self.colorPickerOpen[1][4] ~= nil then
                            cpa = true
                            table.insert(clrtable, self.colorPickerOpen[1][4])
                        end
    
                        self:SetColorPicker(true, clrtable, self.colorPickerOpen, cpa, self.colorPickerOpen[6], cp.x, cp.y)
                        cp.oldclr = self.colorPickerOpen[4][1].Color
                        local oldclr = cp.oldclr
                        if self.colorPickerOpen[1][4] ~= nil then
                            set_oldcolor(oldclr.R * 255, oldclr.G * 255, oldclr.B * 255, self.colorPickerOpen[1][4])
                        else
                            set_oldcolor(oldclr.R * 255, oldclr.G * 255, oldclr.B * 255)
                        end
                    end
                end
    
                if self:MouseInColorPicker(197, 91, 75, 40) then
                    self.copied_clr = oldcolor.Color --copy oldcolor
                end
            else
                for k, v in pairs(self.multigroups) do
                    if self.tabnames[self.activetab] == k then
                        for k1, v1 in pairs(v) do
                            local c_pos = v1.drawn.click_pos
                            --local selected = v1.drawn.bar
                            local selected_pos = v1.drawn.barpos
    
                            for k2, v2 in pairs(v1.drawn.click_pos) do
                                if self:MouseInMenu(v2.x, v2.y, v2.width, v2.height) then
                                    for _k, _v in pairs(v1.vals) do
                                        if _k == v2.name then
                                            v1.vals[_k] = true
                                        else
                                            v1.vals[_k] = false
                                        end
                                    end
    
                                    local settab = v2.num
                                    for _k, _v in pairs(v1.drawn.bar) do
                                        self.postable[_v.postable][2] = selected_pos[settab].pos
                                        _v.drawn.Size = Vector2.new(selected_pos[settab].length, 2)
                                    end
    
                                    for i, v in pairs(v1.drawn.nametext) do
                                        if i == v2.num then
                                            v.Color = RGB(255, 255, 255)
                                        else
                                            v.Color = RGB(170, 170, 170)
                                        end
                                    end
    
                                    self:setMenuVisible(true)
                                    setActiveTab(self.activetab)
                                    self:SetMenuPos(self.x, self.y)
                                end
                            end
                        end
                    end
                end
                local newdropbox_open
                for k, v in pairs(self.options) do
                    if self.tabnames[self.activetab] == k then
                        for k1, v1 in pairs(v) do
                            local pass = true
                            for k3, v3 in pairs(self.multigroups) do
                                if k == k3 then
                                    for k4, v4 in pairs(v3) do
                                        for k5, v5 in pairs(v4.vals) do
                                            if k1 == k5 then
                                                pass = v5
                                            end
                                        end
                                    end
                                end
                            end
    
                            if pass then
                                for k2, v2 in pairs(v1) do
                                    if v2[2] == TOGGLE and not self.dropbox_open then
                                        if self:MouseInMenu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16) then
                                            if v2[6] then
                                                if self:GetVal(
                                                        "Settings",
                                                        "Cheat Settings",
                                                        "Allow Unsafe Features"
                                                    ) and v2[1] == false
                                                then
                                                    v2[1] = true
                                                else
                                                    v2[1] = false
                                                end
                                            else
                                                v2[1] = not v2[1]
                                            end
                                            if not v2[1] then
                                                for i = 0, 3 do
                                                    v2[4][i + 1].Color = color.range(i, {
                                                        [1] = { start = 0, color = RGB(50, 50, 50) },
                                                        [2] = { start = 3, color = RGB(30, 30, 30) },
                                                    })
                                                end
                                            else
                                                for i = 0, 3 do
                                                    v2[4][i + 1].Color = color.range(i, {
                                                        [1] = {
                                                            start = 0,
                                                            color = RGB(self.mc[1], self.mc[2], self.mc[3]),
                                                        },
                                                        [2] = {
                                                            start = 3,
                                                            color = RGB(
                                                                self.mc[1] - 40,
                                                                self.mc[2] - 40,
                                                                self.mc[3] - 40
                                                            ),
                                                        },
                                                    })
                                                end
                                            end
                                            --TogglePressed:Fire(k1, k2, v2)
                                            --FireEvent("bb_togglepressed", k1, k2, v2)
                                        end
                                        if v2[5] ~= nil then
                                            if v2[5][2] == KEYBIND then
                                                if self:MouseInMenu(v2[5][3][1], v2[5][3][2], 44, 16) then
                                                    v2[5][4][2].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                                                    v2[5][5] = true
                                                end
                                            elseif v2[5][2] == COLORPICKER then
                                                if self:MouseInMenu(v2[5][3][1], v2[5][3][2], 28, 14) then
                                                    v2[5][5] = true
                                                    self.colorPickerOpen = v2[5]
                                                    self.colorPickerOpen = v2[5]
                                                    if v2[5][1][4] ~= nil then
                                                        self:SetColorPicker(
                                                            true,
                                                            v2[5][1],
                                                            v2[5],
                                                            true,
                                                            v2[5][6],
                                                            LOCAL_MOUSE.x,
                                                            LOCAL_MOUSE.y + 36
                                                        )
                                                    else
                                                        self:SetColorPicker(
                                                            true,
                                                            v2[5][1],
                                                            v2[5],
                                                            false,
                                                            v2[5][6],
                                                            LOCAL_MOUSE.x,
                                                            LOCAL_MOUSE.y + 36
                                                        )
                                                    end
                                                end
                                            elseif v2[5][2] == DOUBLE_COLORPICKER then
                                                for k3, v3 in pairs(v2[5][1]) do
                                                    if self:MouseInMenu(v3[3][1], v3[3][2], 28, 14) then
                                                        v3[5] = true
                                                        self.colorPickerOpen = v3
                                                        self.colorPickerOpen = v3
                                                        if v3[1][4] ~= nil then
                                                            self:SetColorPicker(
                                                                true,
                                                                v3[1],
                                                                v3,
                                                                true,
                                                                v3[6],
                                                                LOCAL_MOUSE.x,
                                                                LOCAL_MOUSE.y + 36
                                                            )
                                                        else
                                                            self:SetColorPicker(
                                                                true,
                                                                v3[1],
                                                                v3,
                                                                false,
                                                                v3[6],
                                                                LOCAL_MOUSE.x,
                                                                LOCAL_MOUSE.y + 36
                                                            )
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    elseif v2[2] == SLIDER and not self.dropbox_open then
                                        if self:MouseInMenu(v2[7][1], v2[7][2], 22, 13) then
                                            local stepval = 1
                                            if v2.stepsize then
                                                stepval = v2.stepsize
                                            end
                                            if self:modkeydown("shift", "left") then
                                                stepval = v2.shift_stepsize or 0.1
                                            end
                                            if self:MouseInMenu(v2[7][1], v2[7][2], 11, 13) then
                                                v2[1] -= stepval
                                            elseif self:MouseInMenu(v2[7][1] + 11, v2[7][2], 11, 13) then
                                                v2[1] += stepval
                                            end
    
                                            if v2[1] < v2[6][1] then
                                                v2[1] = v2[6][1]
                                            elseif v2[1] > v2[6][2] then
                                                v2[1] = v2[6][2]
                                            end
                                            local decplaces = v2.decimal and string.rep("0", math.log(1 / v2.decimal) / math.log(10))
                                            if decplaces and math.abs(v2[1]) < v2.decimal then
                                                v2[1] = 0
                                            end
                                            v2[4][5].Text = v2.custom[v2[1]] or (v2[1] == math.floor(v2[1]) and v2.decimal) and tostring(v2[1]) .. "." .. decplaces .. v2[4][6] or tostring(v2[1]) .. v2[4][6]
    
                                            for i = 1, 4 do
                                                v2[4][i].Size = Vector2.new(
                                                    (v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])),
                                                    2
                                                )
                                            end
                                        elseif self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 28) then
                                            v2[5] = true
                                        end
                                    elseif v2[2] == DROPBOX then
                                        if self.dropbox_open then
                                            if v2 ~= self.dropbox_open then
                                                continue
                                            end
                                        end
                                        if self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 36) then
                                            if not v2[5] then
                                                v2[5] = self:SetDropBox(
                                                    true,
                                                    v2[3][1] + self.x + 1,
                                                    v2[3][2] + self.y + 13,
                                                    v2[3][3],
                                                    v2[1],
                                                    v2[6]
                                                )
                                                newdropbox_open = v2
                                            else
                                                self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
                                                v2[5] = false
                                                newdropbox_open = nil
                                            end
                                        elseif self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) and v2[5]
                                        then
                                            for i = 1, #v2[6] do
                                                if self:MouseInMenu(
                                                        v2[3][1],
                                                        v2[3][2] + 36 + ((i - 1) * 21),
                                                        v2[3][3],
                                                        21
                                                    )
                                                then
                                                    v2[4][1].Text = v2[6][i]
                                                    v2[1] = i
                                                    self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
                                                    v2[5] = false
                                                    newdropbox_open = nil
                                                end
                                            end
    
                                            if v2 == self.options["Settings"]["Configuration"]["Configs"] then
                                                local textbox = self.options["Settings"]["Configuration"]["ConfigName"]
                                                local relconfigs = GetConfigs()
                                                textbox[1] = relconfigs[self.options["Settings"]["Configuration"]["Configs"][1]]
                                                textbox[4].Text = textbox[1]
                                            end
                                        end
                                    elseif v2[2] == COMBOBOX then
                                        if self.dropbox_open then
                                            if v2 ~= self.dropbox_open then
                                                continue
                                            end
                                        end
                                        if self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 36) then
                                            if not v2[5] then
                                                
                                                v2[5] = set_comboboxthingy(
                                                    true,
                                                    v2[3][1] + self.x + 1,
                                                    v2[3][2] + self.y + 13,
                                                    v2[3][3],
                                                    v2[1],
                                                    v2[6]
                                                )
                                                newdropbox_open = v2
                                            else
                                                self:SetDropBox(false, 400, 200, 160, 1, { "HI q", "HI q", "HI q" })
                                                v2[5] = false
                                                newdropbox_open = nil
                                            end
                                        elseif self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) and v2[5]
                                        then
                                            for i = 1, #v2[1] do
                                                if self:MouseInMenu(
                                                        v2[3][1],
                                                        v2[3][2] + 36 + ((i - 1) * 22),
                                                        v2[3][3],
                                                        23
                                                    )
                                                then
                                                    v2[1][i][2] = not v2[1][i][2]
                                                    local textthing = ""
                                                    for k, v in pairs(v2[1]) do
                                                        if v[2] then
                                                            if textthing == "" then
                                                                textthing = v[1]
                                                            else
                                                                textthing = textthing .. ", " .. v[1]
                                                            end
                                                        end
                                                    end
                                                    textthing = textthing ~= "" and textthing or "None"
                                                    textthing = string.cut(textthing, 25)
                                                    v2[4][1].Text = textthing
                                                    set_comboboxthingy(
                                                        true,
                                                        v2[3][1] + self.x + 1,
                                                        v2[3][2] + self.y + 13,
                                                        v2[3][3],
                                                        v2[1],
                                                        v2[6]
                                                    )
                                                end
                                            end
                                        end
                                    elseif v2[2] == BUTTON and not self.dropbox_open then
                                        if self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 22) then
                                            if not v2[1] then
                                                buttonpressed(v2)
                                                if k2 == "Unload Cheat" then
                                                    return
                                                end
                                                for i = 0, 8 do
                                                    v2[4][i + 1].Color = color.range(i, {
                                                        [1] = { start = 0, color = RGB(35, 35, 35) },
                                                        [2] = { start = 8, color = RGB(50, 50, 50) },
                                                    })
                                                end
                                                v2[1] = true
                                            end
                                        end
                                    elseif v2[2] == TEXTBOX and not self.dropbox_open then
                                        if self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 22) then
                                            if not v2[5] then
                                                self.textboxopen = v2
    
                                                v2[4].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                                                v2[5] = true
                                            end
                                        end
                                    elseif v2[2] == "list" then
                                        --[[
                                        self.options[v.name][v1.name][v2.name] = {}
                                        self.options[v.name][v1.name][v2.name][4] = draw:List(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.columns, tabz[k])
                                        self.options[v.name][v1.name][v2.name][1] = nil
                                        self.options[v.name][v1.name][v2.name][2] = v2.type
                                        self.options[v.name][v1.name][v2.name][3] = 1
                                        self.options[v.name][v1.name][v2.name][5] = {}
                                        self.options[v.name][v1.name][v2.name][6] = v2.size
                                        self.options[v.name][v1.name][v2.name][7] = v2.columns
                                        self.options[v.name][v1.name][v2.name][8] = {v1.x + 8, v1.y + y_pos, v1.width - 16}
                                        ]]
                                        --
                                        if #v2[5] > v2[6] then
                                            for i = 1, v2[6] do
                                                if self:MouseInMenu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22)
                                                then
                                                    if v2[1] == tostring(v2[5][i + v2[3] - 1][1][1]) then
                                                        v2[1] = nil
                                                    else
                                                        v2[1] = tostring(v2[5][i + v2[3] - 1][1][1])
                                                    end
                                                end
                                            end
                                        else
                                            for i = 1, #v2[5] do
                                                if self:MouseInMenu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22)
                                                then
                                                    if v2[1] == tostring(v2[5][i + v2[3] - 1][1][1]) then
                                                        v2[1] = nil
                                                    else
                                                        v2[1] = tostring(v2[5][i + v2[3] - 1][1][1])
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                self.dropbox_open = newdropbox_open
            end
            for k, v in pairs(self.options) do
                for k1, v1 in pairs(v) do
                    for k2, v2 in pairs(v1) do
                        if v2[2] == TOGGLE then
                            if v2[6] then
                                if not self:GetVal("Settings", "Cheat Settings", "Allow Unsafe Features") then
                                    v2[1] = false
                                    for i = 0, 3 do
                                        v2[4][i + 1].Color = color.range(i, {
                                            [1] = { start = 0, color = RGB(50, 50, 50) },
                                            [2] = { start = 3, color = RGB(30, 30, 30) },
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            menucolor()
        end
    
        
    
        local function mousebutton1upfunc()
            cp.dragging_m = false
            cp.dragging_r = false
            cp.dragging_b = false
            for k, v in pairs(self.options) do
                if self.tabnames[self.activetab] == k then
                    for k1, v1 in pairs(v) do
                        for k2, v2 in pairs(v1) do
                            if v2[2] == SLIDER and v2[5] then
                                v2[5] = false
                            end
                            if v2[2] == BUTTON and v2[1] then
                                for i = 0, 8 do
                                    v2[4][i + 1].Color = color.range(i, {
                                        [1] = { start = 0, color = RGB(50, 50, 50) },
                                        [2] = { start = 8, color = RGB(35, 35, 35) },
                                    })
                                end
                                v2[1] = false
                            end
                        end
                    end
                end
            end
        end
    
        local clickspot_x, clickspot_y, original_menu_x, original_menu_y = 0, 0, 0, 0
        
        -- Ya wana know what ur missing?
        -- Mouse Move Delta!
        hook:Add("WheelForward", "BBOT:Menu", function()
            if self.open then
                for k, v in pairs(self.options) do
                    if self.tabnames[self.activetab] == k then
                        for k1, v1 in pairs(v) do
                            for k2, v2 in pairs(v1) do
                                if v2[2] == "list" then
                                    if v2[3] > 1 then
                                        v2[3] -= 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        hook:Add("WheelBackward", "BBOT:Menu", function()
            if self.open then
                for k, v in pairs(self.options) do
                    if self.tabnames[self.activetab] == k then
                        for k1, v1 in pairs(v) do
                            for k2, v2 in pairs(v1) do
                                if v2[2] == "list" then
                                    if v2[5][v2[3] + v2[6]] ~= nil then
                                        v2[3] += 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    
        function self:setMenuAlpha(transparency)
            for k, v in pairs(bbmouse) do
                v.Transparency = transparency
            end
            for k, v in pairs(bbmenu) do
                v.Transparency = transparency
            end
            for k, v in pairs(tabz[self.activetab]) do
                v.Transparency = transparency
            end
        end
    
        function self:setMenuVisible(visible)
            for k, v in pairs(bbmouse) do
                v.Visible = visible
            end
            for k, v in pairs(bbmenu) do
                v.Visible = visible
            end
            for k, v in pairs(tabz[self.activetab]) do
                v.Visible = visible
            end
    
            if visible then
                for k, v in pairs(self.multigroups) do
                    if self.tabnames[self.activetab] == k then
                        for k1, v1 in pairs(v) do
                            for k2, v2 in pairs(v1.vals) do
                                for k3, v3 in pairs(self.mgrouptabz[k][k2]) do
                                    v3.Visible = v2
                                end
                            end
                        end
                    end
                end
            end
        end
    
        self:setMenuAlpha(0)
        self:setMenuVisible(false)
        self.lastActive = true
        self.open = false
        self.windowactive = true
        hook:Add("Mouse.Move", "Menu.WindowActivity", function(moved, x, y)
            self.windowactive = iswindowactive() or moved
        end)
        
        local Camera = BBOT.service:GetService("CurrentCamera")
        local function renderSteppedMenu(fdt)
            if cp.dragging_m or cp.dragging_r or cp.dragging_b then
                menucolor()
            end
            self.dt = fdt
            if self.unloaded then
                return
            end
            SCREEN_SIZE = Camera.ViewportSize
            if bbmouse[#bbmouse-1] then
                if self.inmenu and not self.inmiddlemenu and not self.intabs then
                    bbmouse[#bbmouse-1].Visible = true
                    bbmouse[#bbmouse-1].Transparency = 1
                else
                    bbmouse[#bbmouse-1].Visible = false
                end
            end
            -- i pasted the old self working ingame shit from the old source nate pls fix ty
            -- this is the really shitty alive check that we've been using since day one
            -- removed it :DDD
            -- im keepin all of our comments they're fun to look at
            -- i wish it showed comment dates that would be cool
            -- nah that would suck fk u (comment made on 3/4/2021 3:35 pm est by bitch)
    
            
            self.lastActive = self.windowactive
            for button, time in next, buttonsInQue do
                if time and tick() - time < doubleclickDelay then
                    button[4].text.Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                    button[4].text.Text = "Confirm?"
                else
                    button[4].text.Color = Color3.new(1, 1, 1)
                    button[4].text.Text = button.name
                end
            end
            if self.open then
                if self.backspaceheld then
                    local dt = tick() - self.backspacetime
                    if dt > 0.4 then
                        self.backspaceflags += 1
                        if self.backspaceflags % 5 == 0 then
                            local textbox = self.textboxopen
                            textbox[1] = string.sub(textbox[1], 0, #textbox[1] - 1)
                            textbox[4].Text = textbox[1] .. "|"
                        end
                    end
                end
            end
            if self.fading then
                if self.open then
                    self.timesincefade = tick() - self.fadestart
                    self.fade_amount = 1 - (self.timesincefade * 10)
                    self:SetPlusMinus(0, 20, 20)
                    self:setMenuAlpha(self.fade_amount)
                    if self.fade_amount <= 0 then
                        self.open = false
                        self.fading = false
                        self:setMenuAlpha(0)
                        self:setMenuVisible(false)
                    else
                        self:setMenuAlpha(self.fade_amount)
                    end
                else
                    self:setMenuVisible(true)
                    setActiveTab(self.activetab)
                    self.timesincefade = tick() - self.fadestart
                    self.fade_amount = (self.timesincefade * 10)
                    self.fadeamount = self.fade_amount
                    self:setMenuAlpha(self.fade_amount)
                    if self.fade_amount >= 1 then
                        self.open = true
                        self.fading = false
                        self:setMenuAlpha(1)
                    else
                        self:setMenuAlpha(self.fade_amount)
                    end
                end
            end
            if self.game == "uni" then
                if self.open then
                    INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
                else
                    if INPUT_SERVICE.MouseBehavior ~= self.mousebehavior then
                        INPUT_SERVICE.MouseBehavior = self.mousebehavior
                    end
                end
            end
            local settooltip = true
            if self.open or self.fading then
                self:SetPlusMinus(0, 20, 20)
                for k, v in pairs(self.options) do
                    if self.tabnames[self.activetab] == k then
                        for k1, v1 in pairs(v) do
                            local pass = true
                            for k3, v3 in pairs(self.multigroups) do
                                if k == k3 then
                                    for k4, v4 in pairs(v3) do
                                        for k5, v5 in pairs(v4.vals) do
                                            if k1 == k5 then
                                                pass = v5
                                            end
                                        end
                                    end
                                end
                            end
    
                            if pass then
                                for k2, v2 in pairs(v1) do
                                    if v2[2] == TOGGLE then
                                        if not self.dropbox_open and not self.colorPickerOpen then
                                            if self.open and self:MouseInMenu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16)
                                            then
                                                if v2.tooltip and settooltip then
                                                    self:SetToolTip(
                                                        self.x + v2[3][1],
                                                        self.y + v2[3][2] + 18,
                                                        v2.tooltip,
                                                        true,
                                                        fdt--[[this is really fucking stupid]] -- this is no longer really fucking stupid
                                                    )
                                                    settooltip = false
                                                end
                                            end
                                        end
                                    elseif v2[2] == SLIDER then
                                        if v2[5] then
                                            local new_val = (v2[6][2] - v2[6][1])  * (
                                                    (
                                                        LOCAL_MOUSE.x
                                                        - self.x
                                                        - v2[3][1]
                                                    ) / v2[3][3]
                                                )
                                            v2[1] = (
                                                    not v2.decimal and math.floor(new_val) or math.floor(new_val / v2.decimal) * v2.decimal
                                                ) + v2[6][1]
                                            if v2[1] < v2[6][1] then
                                                v2[1] = v2[6][1]
                                            elseif v2[1] > v2[6][2] then
                                                v2[1] = v2[6][2]
                                            end
                                            local decplaces = v2.decimal and string.rep("0", math.log(1 / v2.decimal) / math.log(10))
                                            if decplaces and math.abs(v2[1]) < v2.decimal then
                                                v2[1] = 0
                                            end
    
                                            v2[4][5].Text = v2.custom[v2[1]] or (v2[1] == math.floor(v2[1]) and v2.decimal) and tostring(v2[1]) .. "." .. decplaces .. v2[4][6] or tostring(v2[1]) .. v2[4][6]
                                            for i = 1, 4 do
                                                v2[4][i].Size = Vector2.new(
                                                    (v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])),
                                                    2
                                                )
                                            end
                                            self:SetPlusMinus(1, v2[7][1], v2[7][2])
                                        else
                                            if not self.dropbox_open then
                                                if self:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 28) then
                                                    if self:MouseInMenu(v2[7][1], v2[7][2], 22, 13) then
                                                        if self:MouseInMenu(v2[7][1], v2[7][2], 11, 13) then
                                                            self:SetPlusMinus(2, v2[7][1], v2[7][2])
                                                        elseif self:MouseInMenu(v2[7][1] + 11, v2[7][2], 11, 13) then
                                                            self:SetPlusMinus(3, v2[7][1], v2[7][2])
                                                        end
                                                    else
                                                        self:SetPlusMinus(1, v2[7][1], v2[7][2])
                                                    end
                                                end
                                            end
                                        end
                                    elseif v2[2] == "list" then
                                        for k3, v3 in pairs(v2[4].liststuff) do
                                            for i, v4 in ipairs(v3) do
                                                for i1, v5 in ipairs(v4) do
                                                    v5.Visible = false
                                                end
                                            end
                                        end
                                        for i = 1, v2[6] do
                                            if v2[5][i + v2[3] - 1] ~= nil then
                                                for i1 = 1, v2[7] do
                                                    v2[4].liststuff.words[i][i1].Text = v2[5][i + v2[3] - 1][i1][1]
                                                    v2[4].liststuff.words[i][i1].Visible = true
    
                                                    if v2[5][i + v2[3] - 1][i1][1] == v2[1] and i1 == 1 then
                                                        if self.options["Settings"]["Cheat Settings"]["Menu Accent"][1]
                                                        then
                                                            local clr = self.options["Settings"]["Cheat Settings"]["Menu Accent"][5][1]
                                                            v2[4].liststuff.words[i][i1].Color = RGB(clr[1], clr[2], clr[3])
                                                        else
                                                            v2[4].liststuff.words[i][i1].Color = RGB(self.mc[1], self.mc[2], self.mc[3])
                                                        end
                                                    else
                                                        v2[4].liststuff.words[i][i1].Color = v2[5][i + v2[3] - 1][i1][2]
                                                    end
                                                end
                                                for k3, v3 in pairs(v2[4].liststuff.rows[i]) do
                                                    v3.Visible = true
                                                end
                                            elseif v2[3] > 1 then
                                                v2[3] -= 1
                                            end
                                        end
                                        if v2[3] == 1 then
                                            for k3, v3 in pairs(v2[4].uparrow) do
                                                if v3.Visible then
                                                    v3.Visible = false
                                                end
                                            end
                                        else
                                            for k3, v3 in pairs(v2[4].uparrow) do
                                                if not v3.Visible then
                                                    v3.Visible = true
                                                    self:SetMenuPos(self.x, self.y)
                                                end
                                            end
                                        end
                                        if v2[5][v2[3] + v2[6]] == nil then
                                            for k3, v3 in pairs(v2[4].downarrow) do
                                                if v3.Visible then
                                                    v3.Visible = false
                                                end
                                            end
                                        else
                                            for k3, v3 in pairs(v2[4].downarrow) do
                                                if not v3.Visible then
                                                    v3.Visible = true
                                                    self:SetMenuPos(self.x, self.y)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                self.inmenu = LOCAL_MOUSE.x > self.x and LOCAL_MOUSE.x < self.x + self.w and LOCAL_MOUSE.y > self.y - 32 and LOCAL_MOUSE.y < self.y + self.h - 34
                self.intabs = LOCAL_MOUSE.x > self.x + 9 and LOCAL_MOUSE.x < self.x + self.w - 9 and LOCAL_MOUSE.y > self.y - 9 and LOCAL_MOUSE.y < self.y + 24
                self.inmiddlemenu = LOCAL_MOUSE.x > self.x + 18 and LOCAL_MOUSE.x < self.x + self.w - 18 and LOCAL_MOUSE.y > self.y + 33 and LOCAL_MOUSE.y < self.y + self.h - 56
                if (
                        --[[(
                            LOCAL_MOUSE.x > self.x and LOCAL_MOUSE.x < self.x + self.w and LOCAL_MOUSE.y > self.y - 32 and LOCAL_MOUSE.y < self.y - 11
                        )]]
                        (
                            self.inmenu and 
                            not self.intabs and
                            not self.inmiddlemenu
                        ) or self.dragging
                    ) and not self.dontdrag
                then
                    if self.mousedown and not self.colorPickerOpen and not dropbox_open then
                        if not self.dragging then
                            clickspot_x = LOCAL_MOUSE.x
                            clickspot_y = LOCAL_MOUSE.y - 36 original_menu_X = self.x original_menu_y = self.y
                            self.dragging = true
                        end
                        self.x = (original_menu_X - clickspot_x) + LOCAL_MOUSE.x
                        self.y = (original_menu_y - clickspot_y) + LOCAL_MOUSE.y - 36
                        if self.y < 0 then
                            self.y = 0
                        end
                        if self.x < -self.w / 4 * 3 then
                            self.x = -self.w / 4 * 3
                        end
                        if self.x + self.w / 4 > SCREEN_SIZE.x then
                            self.x = SCREEN_SIZE.x - self.w / 4
                        end
                        if self.y > SCREEN_SIZE.y - 20 then
                            self.y = SCREEN_SIZE.y - 20
                        end
                        self:SetMenuPos(self.x, self.y)
                    else
                        self.dragging = false
                    end
                elseif self.mousedown then
                    self.dontdrag = true
                elseif not self.mousedown then
                    self.dontdrag = false
                end
                if self.colorPickerOpen then
                    if cp.dragging_m then
                        self:SetDragBarM(
                            clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - 2,
                            clamp(LOCAL_MOUSE.y + 36, cp.y + 25, cp.y + 180) - 2
                        )
    
                        cp.hsv.s = (clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - cp.x - 12) / 155
                        cp.hsv.v = 1 - ((clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23) / 155)
                        newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
                        local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
                        self.colorPickerOpen[4][1].Color = tempclr
                        for i = 2, 3 do
                            self.colorPickerOpen[4][i].Color = RGB(
                                math.floor(tempclr.R * 255) - 40,
                                math.floor(tempclr.G * 255) - 40,
                                math.floor(tempclr.B * 255) - 40
                            )
                        end
                        if cp.alpha then
                            self.colorPickerOpen[1] = {
                                math.floor(tempclr.R * 255),
                                math.floor(tempclr.G * 255),
                                math.floor(tempclr.B * 255),
                                cp.hsv.a,
                            }
                        else
                            self.colorPickerOpen[1] = {
                                math.floor(tempclr.R * 255),
                                math.floor(tempclr.G * 255),
                                math.floor(tempclr.B * 255),
                            }
                        end
                    elseif cp.dragging_r then
                        self:SetDragBarR(cp.x + 175, clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178))
    
                        maincolor.Color = Color3.fromHSV(
                                1 - ((clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23) / 155),
                                1,
                                1
                            )
    
                        cp.hsv.h = 1 - ((clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23) / 155)
                        newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
                        local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
                        self.colorPickerOpen[4][1].Color = tempclr
                        for i = 2, 3 do
                            self.colorPickerOpen[4][i].Color = RGB(
                                math.floor(tempclr.R * 255) - 40,
                                math.floor(tempclr.G * 255) - 40,
                                math.floor(tempclr.B * 255) - 40
                            )
                        end
                        if cp.alpha then
                            self.colorPickerOpen[1] = {
                                math.floor(tempclr.R * 255),
                                math.floor(tempclr.G * 255),
                                math.floor(tempclr.B * 255),
                                cp.hsv.a,
                            }
                        else
                            self.colorPickerOpen[1] = {
                                math.floor(tempclr.R * 255),
                                math.floor(tempclr.G * 255),
                                math.floor(tempclr.B * 255),
                            }
                        end
                    elseif cp.dragging_b then
                        local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
                        self.colorPickerOpen[4][1].Color = tempclr
                        for i = 2, 3 do
                            self.colorPickerOpen[4][i].Color = RGB(
                                math.floor(tempclr.R * 255) - 40,
                                math.floor(tempclr.G * 255) - 40,
                                math.floor(tempclr.B * 255) - 40
                            )
                        end
                        if cp.alpha then
                            self.colorPickerOpen[1] = {
                                math.floor(tempclr.R * 255),
                                math.floor(tempclr.G * 255),
                                math.floor(tempclr.B * 255),
                                cp.hsv.a,
                            }
                        else
                            self.colorPickerOpen[1] = {
                                math.floor(tempclr.R * 255),
                                math.floor(tempclr.G * 255),
                                math.floor(tempclr.B * 255),
                            }
                        end
                        self:SetDragBarB(clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168), cp.y + 188)
                        newcolor.Transparency = (clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168) - cp.x - 10) / 158
                        cp.hsv.a = math.floor(((clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168) - cp.x - 10) / 158) * 255)
                    else
                        local setvisnew = self:MouseInColorPicker(197, 37, 75, 40)
                        for i, v in ipairs(newcopy) do
                            v.Visible = setvisnew
                        end
    
                        local setvisold = self:MouseInColorPicker(197, 91, 75, 40)
                        for i, v in ipairs(oldcopy) do
                            v.Visible = setvisold
                        end
                    end
                end
            else
                self.dragging = false
            end
            if settooltip then
                self:SetToolTip(nil, nil, nil, false, fdt)
            end
        end
    
        hook:Add("InputBegan", "BBOT:Menu", function(input)
            if self then -- wat?
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    self.mousedown = true
                    if self.open and not self.fading then
                        MouseButton1Event()
                    end
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if self.open and not self.fading then
                        MouseButton2Event()
                    end
                end
    
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode.Name:match("Shift") then
                        local kcn = input.KeyCode.Name
                        local direction = kcn:split("Shift")[1]
                        self.modkeys.shift.direction = direction:lower()
                    end
                    if input.KeyCode.Name:match("Alt") then
                        local kcn = input.KeyCode.Name
                        local direction = kcn:split("Alt")[1]
                        self.modkeys.alt.direction = direction:lower()
                    end
                end
                if not self then
                    return
                end -- this fixed shit with unload
                self:InputBeganMenu(input)
                self:InputBeganKeybinds(input)
                if self.open then
                    if self.tabnames[self.activetab] == "Settings" then
                        local menutext = self:GetVal("Settings", "Cheat Settings", "Custom Menu Name") and self:GetVal("Settings", "Cheat Settings", "MenuName") or "Bitch Bot"
    
                        bbmenu[27].Text = menutext
    
                        self.watermark.text[1].Text = menutext.. self.watermark.textString
    
                        for i, v in ipairs(self.watermark.rect) do
                            local len = #self.watermark.text[1].Text * 7 + 10
                            if i == #self.watermark.rect then
                                len += 2
                            end
                            v.Size = Vector2.new(len, v.Size.y)
                        end
                    end
                end
                if input.KeyCode == Enum.KeyCode.F2 then
                    self.stat_menu = not self.stat_menu
    
                    for k, v in pairs(graphs) do
                        if k ~= "other" then
                            for k1, v1 in pairs(v) do
                                if k1 ~= "pos" then
                                    for k2, v2 in pairs(v1) do
                                        v2.Visible = self.stat_menu
                                    end
                                end
                            end
                        end
                    end
    
                    for k, v in pairs(graphs.other) do
                        v.Visible = self.stat_menu
                    end
                end
            end
        end)

        hook:Add("InputEnded", "BBOT:Menu", function(input)
            self:InputEndedKeybinds(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.mousedown = false
                if self.open and not self.fading then
                    mousebutton1upfunc()
                end
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode.Name:match("Shift") then
                    self.modkeys.shift.direction = nil
                end
                if input.KeyCode.Name:match("Alt") then
                    self.modkeys.alt.direction = nil
                end
            end
        end)

        -- fucking asshole 🖕🖕🖕
        -- who now? - WholeCream
        hook:Add("RenderStepped", "BBOT:Menu", renderSteppedMenu)
    
        function self:unload()
            getgenv().v2 = nil
            self.unloaded = true
    
            for k, conn in next, self.connections do
                if not getrawmetatable(conn) then
                    conn()
                else
                    conn:Disconnect()
                end
                self.connections[k] = nil
            end
    
            game:service("ContextActionService"):UnbindAction("BB Keycheck")
            if self.game == "pf" then
                game:service("ContextActionService"):UnbindAction("BB PF check")
            elseif self.game == "uni" then
                game:service("ContextActionService"):UnbindAction("BB UNI check")
            end
    
            local mt = getrawmetatable(game)
    
            setreadonly(mt, false)
    
            local oldmt = self.oldmt
    
            if oldmt then
                for k, v in next, mt do
                    if oldmt[k] then
                        mt[k] = oldmt[k]
                    end
                end
            else
                --TODO nate do this please
                -- remember to store any "game" metatable hooks PLEASE PLEASE because this will ensure it replaces the meta so that it UNLOADS properly
                -- rconsoleerr("fatal error: no old game meta found! (UNLOAD PROBABLY WON'T WORK AS EXPECTED)")

                -- How about fuck that and I just make it hook related - WholeCream
            end
    
            setreadonly(mt, true)
    
            if self.game == "pf" or self.pfunload then
                self:pfunload()
            end
    
            draw:UnRender()
            CreateNotification = nil
            allrender = nil
            self = nil
            draw = nil
            self.unloaded = true
        end
    end

    menu:Initialize({
        { --ANCHOR stuffs
            name = "Legit",
            content = {
                {
                    name = "Aim Assist",
                    autopos = "left",
                    autofill = true,
                    content = {
                        {
                            type = TOGGLE,
                            name = "Enabled",
                            value = true,
                        },
                        {
                            type = SLIDER,
                            name = "Aimbot FOV",
                            value = 10,
                            minvalue = 0,
                            maxvalue = 180,
                            stradd = "°",
                        },
                        {
                            type = TOGGLE,
                            name = "Dynamic FOV",
                            value = false,
                            tooltip = "Changes all FOV settings in the Legit tab\nto change depending on the magnification.",
                        },
                        {
                            type = SLIDER,
                            name = "Smoothing",
                            value = 20,
                            minvalue = 0,
                            maxvalue = 100,
                            stradd = "%",
                        },
                        {
                            type = DROPBOX,
                            name = "Smoothing Type",
                            value = 2,
                            values = { "Exponential", "Linear" },
                        },
                        {
                            type = SLIDER,
                            name = "Randomization",
                            value = 5,
                            minvalue = 0,
                            maxvalue = 20,
                            custom = { [0] = "Off" },
                        },
                        {
                            type = SLIDER,
                            name = "Deadzone FOV",
                            value = 1,
                            minvalue = 0,
                            maxvalue = 50,
                            stradd = "°",
                            decimal = 0.1,
                            custom = { [0] = "Off" },
                        },
                        {
                            type = DROPBOX,
                            name = "Aimbot Key",
                            value = 1,
                            values = { "Mouse 1", "Mouse 2", "Always", "Dynamic Always" },
                        },
                        {
                            type = DROPBOX,
                            name = "Hitscan Priority",
                            value = 1,
                            values = { "Head", "Body", "Closest" },
                        },
                        {
                            type = COMBOBOX,
                            name = "Hitscan Points",
                            values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
                        },
                        {
                            type = TOGGLE,
                            name = "Adjust for Bullet Drop",
                            value = true,
                        },
                        {
                            type = TOGGLE,
                            name = "Target Prediction",
                            value = true,
                        },
                    },
                },
                {
                    name = "Trigger Bot",
                    autopos = "right",
                    content = {
                        {
                            type = TOGGLE,
                            name = "Enabled",
                            value = false,
                            extra = {
                                type = KEYBIND,
                                key = Enum.KeyCode.M,
                            },
                        },
                        {
                            type = COMBOBOX,
                            name = "Trigger Bot Hitboxes",
                            values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
                        },
                        {
                            type = TOGGLE,
                            name = "Trigger When Aiming",
                            value = false,
                        },
                        {
                            type = SLIDER,
                            name = "Aim Percentage",
                            minvalue = 0,
                            maxvalue = 100,
                            value = 90,
                            stradd = "%",
                        },
                        --[[
                {
                    type = TOGGLE,
                    name = "Magnet Triggerbot",
                    value = false
                },
                {
                    type = SLIDER,
                    name = "Magnet FOV",
                    value = 80,
                    minvalue = 0,
                    maxvalue = 180,
                    stradd = "°"
                },
                {
                    type = SLIDER,
                    name = "Magnet Smoothing Factor",
                    value = 20,
                    minvalue = 0,
                    maxvalue = 50,
                    stradd = "%"
                },
                {
                    type = DROPBOX,
                    name = "Magnet Priority",
                    value = 1,
                    values = {"Head", "Body"}
                },]]
                    },
                },
                {
                    name = "Bullet Redirection",
                    autopos = "right",
                    content = {
                        {
                            type = TOGGLE,
                            name = "Silent Aim",
                            value = false,
                        },
                        {
                            type = SLIDER,
                            name = "Silent Aim FOV",
                            value = 5,
                            minvalue = 0,
                            maxvalue = 180,
                            stradd = "°",
                        },
                        {
                            type = SLIDER,
                            name = "Hit Chance",
                            value = 30,
                            minvalue = 0,
                            maxvalue = 100,
                            stradd = "%",
                        },
                        {
                            type = SLIDER,
                            name = "Accuracy",
                            value = 90,
                            minvalue = 0,
                            maxvalue = 100,
                            stradd = "%",
                        },
                        {
                            type = DROPBOX,
                            name = "Hitscan Priority",
                            value = 1,
                            values = { "Head", "Body", "Closest" },
                        },
                        {
                            type = COMBOBOX,
                            name = "Hitscan Points",
                            values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
                        },
                    },
                },
                {
                    name = "Recoil Control",
                    autopos = "right",
                    autofill = true,
                    content = {
                        {
                            type = TOGGLE,
                            name = "Weapon RCS",
                            value = true,
                        },
                        {
                            type = COMBOBOX,
                            name = "Disable RCS While",
                            values = { { "Holding Sniper", false }, { "Scoping In", false }, { "Not Shooting", true } }
                        },
                        {
                            type = SLIDER,
                            name = "Recoil Control X",
                            value = 45,
                            minvalue = 0,
                            maxvalue = 100,
                            stradd = "%",
                        },
                        {
                            type = SLIDER,
                            name = "Recoil Control Y",
                            value = 80,
                            minvalue = 0,
                            maxvalue = 150,
                            stradd = "%",
                        },
                    },
                },
            },
        },
        {
            name = "Rage",
            content = {
                {
                    name = "Aimbot",
                    autopos = "left",
                    content = {
                        {
                            type = TOGGLE,
                            name = "Enabled",
                            value = false,
                            extra = {
                                type = KEYBIND,
                                toggletype = 4,
                            },
                            unsafe = true,
                        },
                        {
                            type = TOGGLE,
                            name = "Silent Aim",
                            value = false,
                            tooltip = "Stops the camera from rotating toward targetted players.",
                        },
                        {
                            type = TOGGLE,
                            name = "Rotate Viewmodel",
                            value = false,
                            tooltip = "Rotates weapon viewmodel toward the targetted player."
                        },
                        {
                            type = SLIDER,
                            name = "Aimbot FOV",
                            value = 180,
                            minvalue = 0,
                            maxvalue = 181,
                            stradd = "°",
                            custom = { [181] = "Ignored" },
                        },
                        {
                            type = TOGGLE,
                            name = "Auto Wallbang",
                            value = false
                        },
                        {
                            type = TOGGLE,
                            name = "Auto Shoot",
                            value = false,
                            tooltip = "Automatically shoots players when a target is found."
                        },
                        {
                            type = TOGGLE,
                            name = "Double Tap",
                            value = false,
                            tooltip = "Shoots twice when target is found when Auto Shoot is enabled.",
                            extra = {
                                type = KEYBIND,
                                toggletype = 4,
                            },
                        },
                        {
                            type = DROPBOX,
                            name = "Hitscan Priority",
                            value = 1,
                            values = { "Head", "Body" },
                        },
                    },
                },
                {
                    name = "Hack vs. Hack",
                    autopos = "left",
                    autofill = true,
                    content = {
                        --[[{
                            type = TOGGLE,
                            name = "Extend Penetration",
                            value = false
                        },]]
                        -- {
                        -- 	type = SLIDER,
                        -- 	name = "Extra Penetration",
                        -- 	value = 11,
                        -- 	minvalue = 1,
                        -- 	maxvalue = 20,
                        -- 	stradd = " studs",
                        -- 	tooltip = "does nothing",
                        -- }, -- fuck u json
                        {
                            type = TOGGLE,
                            name = "Autowall Hitscan",
                            value = false,
                            unsafe = true,
                            tooltip = "While using Auto Wallbang, this will hitscan multiple points\nto increase penetration and help for peeking.",
                        },
                        {
                            type = COMBOBOX,
                            name = "Hitscan Points",
                            values = {
                                { "Up", true },
                                { "Down", true },
                                { "Left", false },
                                { "Right", false },
                                { "Forward", true },
                                { "Backward", true },
                                { "Origin", true },
                                { "Towards", true },
                            },
                        },
                        {
                            type = TOGGLE,
                            name = "Hitbox Shifting",
                            value = false,
                            tooltip = "Increases possible penetration with Autowall. The higher\nthe Hitbox Shift Distance the more likely it is to miss shots.\nWhen it misses it will try disable this.",
                        },
                        {
                            type = SLIDER,
                            name = "Hitbox Shift Distance",
                            value = 4,
                            minvalue = 1,
                            maxvalue = 12,
                            stradd = " studs",
                        },
                        {
                            type = TOGGLE,
                            name = "Force Player Stances",
                            value = false,
                            tooltip = "Changes the stance of other players to the selected Stance Choice.",
                        },
                        {
                            type = DROPBOX,
                            name = "Stance Choice",
                            value = 1,
                            values = { "Stand", "Crouch", "Prone" },
                        },
                        {
                            type = TOGGLE, 
                            name = "Backtracking",
                            value = false,
                            tooltip = "Attempts to abuse lag compensation and shoot players where they were in the past.\nUsing Visuals->Enemy ESP->Flags->Backtrack will help illustrate this."
                        },
                        {
                            type = SLIDER,
                            name = "Backtracking Time",
                            value = 4000,
                            minvalue = 0,
                            maxvalue = 5000,
                            stradd = "ms",
                        },
                        {
                            type = TOGGLE,
                            name = "Freestanding",
                            value = false,
                            extra = {
                                type = KEYBIND,
                            },
                        },
                    },
                },
                {
                    name = { "Anti Aim", "Fake Lag" },
                    x = menu.columns.right,
                    y = 66,
                    width = menu.columns.width,
                    height = 253,
                    [1] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = false,
                                tooltip = "When this is enabled, your server-side yaw, pitch and stance are set to the values in this tab.",
                            },
                            {
                                type = DROPBOX,
                                name = "Pitch",
                                value = 4,
                                values = {
                                    "Off",
                                    "Up",
                                    "Zero",
                                    "Down",
                                    "Upside Down",
                                    "Roll Forward",
                                    "Roll Backward",
                                    "Random",
                                    "Bob",
                                    "Glitch",
                                },
                            },
                            {
                                type = DROPBOX,
                                name = "Yaw",
                                value = 2,
                                values = { "Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin" },
                            },
                            {
                                type = SLIDER,
                                name = "Spin Rate",
                                value = 10,
                                minvalue = -100,
                                maxvalue = 100,
                                stradd = "°/s",
                            },
                            {
                                type = DROPBOX,
                                name = "Force Stance",
                                value = 4,
                                values = { "Off", "Stand", "Crouch", "Prone" },
                            },
                            {
                                type = TOGGLE,
                                name = "Hide in Floor",
                                value = true,
                                tooltip = "Shifts your body slightly under the ground\nso as to hide it when Force Stance is set to Prone.",
                            },
                            {
                                type = TOGGLE,
                                name = "Lower Arms",
                                value = false,
                                tooltip = "Lowers your arms on the server.",
                            },
                            {
                                type = TOGGLE,
                                name = "Tilt Neck",
                                value = false,
                                tooltip = "Forces the replicated aiming state so that it appears as though your head is tilted.",
                            },
                        },
                    },
                    [2] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = false,
                            },
                            {
                                type = SLIDER,
                                name = "Fake Lag Amount",
                                value = 1,
                                minvalue = 1,
                                maxvalue = 1000,
                                stradd = " kbps",
                            },
                            {
                                type = SLIDER,
                                name = "Fake Lag Distance",
                                value = 1,
                                minvalue = 1,
                                maxvalue = 40,
                                stradd = " studs",
                            },
                            {
                                type = TOGGLE,
                                name = "Manual Choke",
                                extra = {
                                    type = KEYBIND,
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Release Packets on Shoot",
                                value = false,
                            },
                        },
                    },
                },
                {
                    name = { "Extra", "Settings" },
                    y = 325,
                    x = menu.columns.right,
                    width = menu.columns.width,
                    height = 258,
                    [1] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Knife Bot",
                                value = false,
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 4,
                                },
                                unsafe = true,
                            },
                            {
                                type = DROPBOX,
                                name = "Knife Bot Type",
                                value = 2,
                                values = { "Assist", "Multi Aura", "Flight Aura", "Assist+" },
                            },
                            {
                                type = DROPBOX,
                                name = "Knife Hitscan",
                                value = 1,
                                values = { "Head", "Torso", "Other" },
                            },
                            {
                                type = TOGGLE,
                                name = "Knife Visible Only",
                                value = false,
                            },
                            {
                                type = SLIDER,
                                name = "Knife Range",
                                value = 26,
                                minvalue = 1,
                                maxvalue = 26,
                                custom = {[26] = "Max"},
                                stradd = " studs",
                            },
                            {
                                type = TOGGLE,
                                name = "Auto Peek",
                                value = false,
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 1,
                                },
                                tooltip = "Hitscans from in front of your camera,\nif a target is found it will move you towards the point automatically",
                            },
                        },
                    },
                    [2] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Aimbot Performance Mode",
                                value = true,
                                tooltip = "Lowers polling rate for targetting in Rage Aimbot.",
                            },
                            {
                                type = TOGGLE,
                                name = "Resolve Fake Positions",
                                value = true,
                                tooltip = "Rage aimbot attempts to resolve Crimwalk on other players.\nDisable if you are having issues with resolver.",
                            },
                            {
                                type = TOGGLE,
                                name = "Aimbot Damage Prediction",
                                value = true,
                                tooltip = "Predicts damage done to enemies as to prevent wasting ammo and time on certain players.\nHelps for users, and against players with high latency.",
                            },
                            {
                                type = SLIDER,
                                name = "Damage Prediction Limit",
                                value = 100,
                                minvalue = 0,
                                maxvalue = 300,
                                stradd = "hp",
                            },
                            {
                                type = SLIDER,
                                name = "Damage Prediction Time",
                                value = 200,
                                minvalue = 100,
                                maxvalue = 500,
                                stradd = "%",
                            },
                            {
                                type = SLIDER,
                                name = "Max Hitscan Points",
                                value = 30,
                                minvalue = 0,
                                maxvalue = 300,
                                stradd = " points",
                            },
                        },
                    },
                },
            },
        },
        {
            name = "Visuals",
            content = {
                {
                    name = { "Enemy ESP", "Team ESP", "Local" },
                    autopos = "left",
                    size = 300,
                    [1] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = true,
                                tooltip = "Enables 2D rendering, disabling this could improve performance.\nDoes not affect Chams."
                            },
                            {
                                type = TOGGLE,
                                name = "Name",
                                value = true,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Enemy Name",
                                    color = { 255, 255, 255, 200 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Box",
                                value = true,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Enemy Box Fill", "Enemy Box" },
                                    color = { { 255, 0, 0, 0 }, { 255, 0, 0, 150 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Health Bar",
                                value = true,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Enemy Low Health", "Enemy Max Health" },
                                    color = { { 255, 0, 0 }, { 0, 255, 0 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Health Number",
                                value = true,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Enemy Health Number",
                                    color = { 255, 255, 255, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Held Weapon",
                                value = true,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Enemy Held Weapon",
                                    color = { 255, 255, 255, 200 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Held Weapon Icon",
                                value = false,
                            },
                            {
                                type = COMBOBOX,
                                name = "Flags",
                                values = { { "Use Large Text", false }, { "Level", true }, { "Distance", true }, { "Resolved", false }, { "Backtrack", false },  },
                            },
                            {
                                type = TOGGLE,
                                name = "Chams",
                                value = true,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Visible Enemy Chams", "Invisible Enemy Chams" },
                                    color = { { 255, 0, 0, 200 }, { 100, 0, 0, 100 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Skeleton",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Enemy skeleton",
                                    color = { 255, 255, 255, 120 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Out of View",
                                value = true,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Arrow Color",
                                    color = { 255, 255, 255, 255 },
                                },
                            },
                            {
                                type = SLIDER,
                                name = "Arrow Distance",
                                value = 50,
                                minvalue = 10,
                                maxvalue = 101,
                                custom = { [101] = "Max" },
                                stradd = "%",
                            },
                            {
                                type = TOGGLE,
                                name = "Dynamic Arrow Size",
                                value = true,
                            },
                        },
                    },
                    [2] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = false,
                                tooltip = "Enables 2D rendering, disabling this could improve performance.\nDoes not affect Chams."
                            },
                            {
                                type = TOGGLE,
                                name = "Name",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Team Name",
                                    color = { 255, 255, 255, 200 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Box",
                                value = true,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Enemy Box Fill", "Enemy Box" },
                                    color = { { 0, 255, 0, 0 }, { 0, 255, 0, 150 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Health Bar",
                                value = false,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Team Low Health", "Team Max Health" },
                                    color = { { 255, 0, 0 }, { 0, 255, 0 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Health Number",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Team Health Number",
                                    color = { 255, 255, 255, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Held Weapon",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Team Held Weapon",
                                    color = { 255, 255, 255, 200 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Held Weapon Icon",
                                value = false,
                            },
                            {
                                type = COMBOBOX,
                                name = "Flags",
                                values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false },  },
                            },
                            {
                                type = TOGGLE,
                                name = "Chams",
                                value = false,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Visible Team Chams", "Invisible Team Chams" },
                                    color = { { 0, 255, 0, 200 }, { 0, 100, 0, 100 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Skeleton",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Team skeleton",
                                    color = { 255, 255, 255, 120 },
                                },
                            },
                        },
                    },
                    [3] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Arm Chams",
                                value = false,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Sleeve Color", "Hand Color" },
                                    color = { { 106, 136, 213, 255 }, { 181, 179, 253, 255 } },
                                },
                            },
                            {
                                type = DROPBOX,
                                name = "Arm Material",
                                value = 1,
                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                            },
                            {
                                type = TOGGLE,
                                name = "Weapon Chams",
                                value = false,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Weapon Color", "Laser Color" },
                                    color = { { 106, 136, 213, 255 }, { 181, 179, 253, 255 } },
                                },
                            },
                            {
                                type = DROPBOX,
                                name = "Weapon Material",
                                value = 1,
                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                            },
                            {
                                type = TOGGLE,
                                name = "Animate Ghost Material",
                                value = false,
                                tooltip = "Toggles whether or not the 'Ghost' material will be animated or not.",
                            },
                            {
                                type = TOGGLE,
                                name = "Remove Weapon Skin",
                                value = false,
                                tooltip = "If a loaded weapon has a skin, it will remove it.",
                            },
                            {
                                type = TOGGLE,
                                name = "Third Person",
                                value = false,
                                extra = {
                                    type = KEYBIND,
                                    key = nil,
                                    toggletype = 2,
                                },
                            },
                            {
                                type = SLIDER,
                                name = "Third Person Distance",
                                value = 60,
                                minvalue = 1,
                                maxvalue = 150,
                            },
                            {
                                type = TOGGLE,
                                name = "Local Player Chams",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Local Player Chams",
                                    color = { 106, 136, 213, 255 },
                                },
                                tooltip = "Changes the color and material of the local third person body when it is on.",
                            },
                            {
                                type = DROPBOX,
                                name = "Local Player Material",
                                value = 1,
                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                            },
                        },
                    },
                },
                {
                    name = "ESP Settings",
                    autopos = "left",
                    autofill = true,
                    content = {
                        {
                            type = SLIDER,
                            name = "Max HP Visibility Cap",
                            value = 90,
                            minvalue = 50,
                            maxvalue = 100,
                            stradd = "hp",
                            custom = {
                                [100] = "Always"
                            }
                        },
                        {
                            type = DROPBOX,
                            name = "Text Case",
                            value = 2,
                            values = { "lowercase", "Normal", "UPPERCASE" },
                        },
                        {
                            type = SLIDER,
                            name = "Max Text Length",
                            value = 0,
                            minvalue = 0,
                            maxvalue = 32,
                            custom = { [0] = "Unlimited" },
                            stradd = " letters",
                        },
                        {
                            type = SLIDER,
                            name = "ESP Fade Time", 
                            value = 0.5,
                            minvalue = 0,
                            maxvalue = 2,
                            stradd = "s",
                            decimal = 0.1,
                            custom = { [0] = "Off" }
                        },
                        {
                            type = TOGGLE,
                            name = "Highlight Target",
                            value = false,
                            extra = {
                                type = COLORPICKER,
                                name = "Aimbot Target",
                                color = { 255, 0, 0, 255 },
                            },
                        },
                        {
                            type = TOGGLE,
                            name = "Highlight Friends",
                            value = true,
                            extra = {
                                type = COLORPICKER,
                                name = "Friended Players",
                                color = { 0, 255, 255, 255 },
                            },
                        },
                        {
                            type = TOGGLE,
                            name = "Highlight Priority",
                            value = true,
                            extra = {
                                type = COLORPICKER,
                                name = "Priority Players",
                                color = { 255, 210, 0, 255 },
                            },
                        },
                        -- {
                        -- 	type = SLIDER,
                        -- 	name = "Max Player Text",
                        -- 	value = 0,
                        -- 	minvalue = 0,
                        -- 	maxvalue = 32,
                        -- 	custom = {[0] = "None"},
                        -- }
                    },
                },
                {
                    name = { "Camera Visuals", "Viewmodel" },
                    autopos = "right",
                    size = 228,
                    [1] = {
                        content = {
                            {
                                type = SLIDER,
                                name = "Camera FOV",
                                value = 80,
                                minvalue = 60,
                                maxvalue = 120,
                                stradd = "°",
                            },
                            {
                                type = TOGGLE,
                                name = "No Camera Bob",
                                value = false,
                            },
                            {
                                type = TOGGLE,
                                name = "No Scope Sway",
                                value = false,
                            },
                            {
                                type = TOGGLE,
                                name = "Disable ADS FOV",
                                value = false,
                            },
                            {
                                type = TOGGLE,
                                name = "No Scope Border",
                                value = false,
                            },
                            {
                                type = TOGGLE,
                                name = "No Visual Suppression",
                                value = false,
                                tooltip = "Removes the suppression of enemies' bullets.",
                            },
                            {
                                type = TOGGLE,
                                name = "No Gun Bob or Sway",
                                value = false,
                                tooltip = "Removes the bob and sway of weapons when walking.\nThis does not remove the swing effect when moving the mouse.",
                            },
                            {
                                type = TOGGLE,
                                name = "Reduce Camera Recoil",
                                value = false,
                                tooltip = "Reduces camera recoil by X%. Does not affect visible weapon recoil or kick.",
                            },
                            {
                                type = SLIDER,
                                name = "Camera Recoil Reduction",
                                value = 10,
                                minvalue = 0,
                                maxvalue = 100,
                                stradd = "%",
                            },
                        },
                    },
                    [2] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = false,
                            },
                            {
                                type = SLIDER,
                                name = "Offset X",
                                value = 0,
                                minvalue = -3,
                                maxvalue = 3,
                                decimal = 0.01,
                                stradd = " studs",
                            },
                            {
                                type = SLIDER,
                                name = "Offset Y",
                                value = 0,
                                minvalue = -3,
                                maxvalue = 3,
                                decimal = 0.01,
                                stradd = " studs",
                            },
                            {
                                type = SLIDER,
                                name = "Offset Z",
                                value = 0,
                                minvalue = -3,
                                maxvalue = 3,
                                decimal = 0.01,
                                stradd = " studs",
                            },
                            {
                                type = SLIDER,
                                name = "Pitch",
                                value = 0,
                                minvalue = -360,
                                maxvalue = 360,
                                stradd = "°",
                            },
                            {
                                type = SLIDER,
                                name = "Yaw",
                                value = 0,
                                minvalue = -360,
                                maxvalue = 360,
                                stradd = "°",
                            },
                            {
                                type = SLIDER,
                                name = "Roll",
                                value = 0,
                                minvalue = -360,
                                maxvalue = 360,
                                stradd = "°",
                            },
                        },
                    },
                },
                {
                    name = { "World", "Misc", "Keybinds", "FOV", "Spawn" },
                    subtabfill = true,
                    autopos = "right",
                    size = 144,
                    [1] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Ambience",
                                value = false,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Inside Ambience", "Outside Ambience" },
                                    color = { { 117, 76, 236 }, { 117, 76, 236 } },
                                },
                                tooltip = "Changes the map's ambient colors to your defined colors.",
                            },
                            {
                                type = TOGGLE,
                                name = "Force Time",
                                value = false,
                                tooltip = "Forces the time to the time set by your below.",
                            },
                            {
                                type = SLIDER,
                                name = "Custom Time",
                                value = 0,
                                minvalue = 0,
                                maxvalue = 24,
                                decimal = 0.1,
                                stradd = "hr",
                            },
                            {
                                type = TOGGLE,
                                name = "Custom Saturation",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Saturation Tint",
                                    color = { 255, 255, 255 },
                                },
                                tooltip = "Adds custom saturation the image of the game.",
                            },
                            {
                                type = SLIDER,
                                name = "Saturation Density",
                                value = 0,
                                minvalue = 0,
                                maxvalue = 100,
                                stradd = "%",
                            },
                        },
                    },
                    [2] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Crosshair Color",
                                value = false,
                                extra = {
                                    type = DOUBLE_COLORPICKER,
                                    name = { "Inline", "Outline" },
                                    color = { { 127, 72, 163 }, { 25, 25, 25 } },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Laser Pointer",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Laser Pointer Color",
                                    color = { 255, 255, 255, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Ragdoll Chams",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Ragdoll Chams",
                                    color = { 106, 136, 213, 255 },
                                },
                            },
                            {
                                type = DROPBOX,
                                name = "Ragdoll Material",
                                value = 1,
                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                            },
                            {
                                type = TOGGLE,
                                name = "Bullet Tracers",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Bullet Tracers",
                                    color = { 201, 69, 54 },
                                },
                            },
                        },
                    },
                    [3] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Text Color",
                                    color = { 127, 72, 163, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Use List Sizes",
                                value = false,
                            },
                            {
                                type = TOGGLE,
                                name = "Log Keybinds",
                                value = false
                            },
                            {
                                type = SLIDER,
                                name = "Keybinds List X",
                                value = 0,
                                minvalue = 0,
                                maxvalue = 100,
                                shift_stepsize = 0.05,
                                stradd = "%",
                            },
                            {
                                type = SLIDER,
                                name = "Keybinds List Y",
                                value = 50,
                                minvalue = 0,
                                maxvalue = 100,
                                shift_stepsize = 0.05,
                                stradd = "%",
                            },
                        },
                    },
                    [4] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enabled",
                                value = false,
                            },
                            {
                                type = TOGGLE,
                                name = "Aim Assist",
                                value = true,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Aim Assist FOV",
                                    color = { 127, 72, 163, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Aim Assist Deadzone",
                                value = true,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Deadzone FOV",
                                    color = { 50, 50, 50, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Bullet Redirection",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Bullet Redirection FOV",
                                    color = { 163, 72, 127, 255 },
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Ragebot",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Ragebot FOV",
                                    color = { 255, 210, 0, 255 },
                                },
                            },
                        },
                    },
                    [5] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Enemy Spawns",
                                value = false,
                                extra = {
                                    type = COLORPICKER,
                                    name = "Enemy Spawns",
                                    color = { 255, 255, 255, 255 }
                                }
                            }
                        }
                    }
                },
                {
                    name = "Dropped ESP",
                    autopos = "right",
                    autofill = true,
                    content = {
                        {
                            type = TOGGLE,
                            name = "Weapon Names",
                            value = false,
                            extra = {
                                type = DOUBLE_COLORPICKER,
                                name = { "Highlighted Weapons", "Weapon Names" },
                                color = { { 255, 125, 255, 255 }, { 255, 255, 255, 255 } },
                            },
                            tooltip = "Displays dropped weapons as you get closer to them,\nHighlights the weapon you are holding in the second color.",
                        },
                        {
                            type = TOGGLE,
                            name = "Weapon Icons",
                            value = false
                        },
                        {
                            type = TOGGLE,
                            name = "Weapon Ammo",
                            value = false,
                            extra = {
                                type = COLORPICKER,
                                name = "Weapon Ammo",
                                color = { 61, 168, 235, 150 },
                            },
                        },
                        {
                            type = TOGGLE,
                            name = "Dropped Weapon Chams",
                            value = false,
                            extra = {
                                type = COLORPICKER,
                                name = "Dropped Weapon Color",
                                color = { 3, 252, 161, 150 },
                            },
                        },
                        {
                            type = TOGGLE,
                            name = "Grenade Warning",
                            value = true,
                            extra = {
                                type = COLORPICKER,
                                name = "Slider Color",
                                color = { 68, 92, 227 },
                            },
                            tooltip = "Displays where grenades that will deal\ndamage to you will land and the damage they will deal.",
                        },
                        {
                            type = TOGGLE,
                            name = "Grenade ESP",
                            value = false,
                            extra = {
                                type = DOUBLE_COLORPICKER,
                                name = { "Inner Color", "Outer Color" },
                                color = { { 195, 163, 255 }, { 123, 69, 224 } },
                            },
                            tooltip = "Displays the full path of any grenade that will deal damage to you is thrown.",
                        },
                    },
                },
            },
        },
        {
            name = "Misc",
            content = {
                {
                    name = { "Movement", "Tweaks" },
                    autopos = "left",
                    size = 300,
                    [1] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Fly",
                                value = false,
                                unsafe = true,
                                tooltip = "Manipulates your velocity to make you fly.\nUse 60 speed or below to never get flagged.",
                                extra = {
                                    type = KEYBIND,
                                    key = Enum.KeyCode.B,
                                    toggletype = 2,
                                },
                            },
                            {
                                type = SLIDER,
                                name = "Fly Speed",
                                value = 60,
                                minvalue = 1,
                                maxvalue = 400,
                                stradd = " stud/s",
                            },
                            {
                                type = TOGGLE,
                                name = "Auto Jump",
                                value = false,
                                tooltip = "When you hold the spacebar, it will automatically jump repeatedly, ignoring jump delay.",
                            },
                            {
                                type = TOGGLE,
                                name = "Speed",
                                value = false,
                                unsafe = true,
                                tooltip = "Manipulates your velocity to make you move faster, unlike fly it doesn't make you fly.\nUse 60 speed or below to never get flagged.",
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 4,
                                },
                            },
                            {
                                type = DROPBOX,
                                name = "Speed Type",
                                value = 1,
                                values = { "Always", "In Air", "On Hop" },
                            },
                            {
                                type = SLIDER,
                                name = "Speed Factor",
                                value = 40,
                                minvalue = 1,
                                maxvalue = 400,
                                stradd = " stud/s",
                            },
                            {
                                type = TOGGLE,
                                name = "Avoid Collisions",
                                value = false,
                                tooltip = "Attempts to stops you from running into obstacles\nfor Speed and Circle Strafe.",
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 4,
                                }
                            },
                            {
                                type = SLIDER,
                                name = "Avoid Collisions Scale",
                                value = 100,
                                minvalue = 0,
                                maxvalue = 100,
                                stradd = "%",
                            },
                            {
                                type = TOGGLE,
                                name = "Circle Strafe",
                                value = false,
                                extra = {
                                    type = KEYBIND,
                                },
                                tooltip = "When you hold this keybind, it will strafe in a perfect circle.\nSpeed of strafing is borrowed from Speed Factor.",
                            },
                        },
                    },
                    [2] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Gravity Shift",
                                value = false,
                                tooltip = "Shifts movement gravity by X%. (Does not affect bullet acceleration.)",
                            },
                            {
                                type = SLIDER,
                                name = "Gravity Shift Percentage",
                                value = -50,
                                minvalue = -500,
                                maxvalue = 500,
                                stradd = "%",
                            },
                            {
                                type = TOGGLE,
                                name = "Jump Power",
                                value = false,
                                tooltip = "Shifts movement jump power by X%.",
                            },
                            {
                                type = SLIDER,
                                name = "Jump Power Percentage",
                                value = 150,
                                minvalue = 0,
                                maxvalue = 1000,
                                stradd = "%",
                            },
                            {
                                type = TOGGLE,
                                name = "Prevent Fall Damage",
                                value = false,
                            },
                        },
                    },
                },
                {
                    name = "Weapon Modifications",
                    autopos = "left",
                    autofill = true,
                    content = {
                        {
                            type = TOGGLE,
                            name = "Enabled",
                            value = false,
                            tooltip = "Allows Bitch Bot to modify weapons.",
                        },
                        {
                            type = SLIDER,
                            name = "Fire Rate Scale",
                            value = 150,
                            minvalue = 50,
                            maxvalue = 500,
                            stradd = "%",
                            tooltip = "Scales all weapons' firerate by X%.\n100% = Normal firerate",
                        },
                        {
                            type = SLIDER,
                            name = "Recoil Scale",
                            value = 10,
                            minvalue = 0,
                            maxvalue = 100,
                            stradd = "%",
                            tooltip = "Scales all weapons' recoil by X%.\n0% = No recoil | 50% = Halved recoil",
                        },
                        {
                            type = TOGGLE,
                            name = "Remove Animations",
                            value = true,
                            tooltip = "Removes all animations from any gun.\nThis will also completely remove the equipping animations.",
                        },
                        {
                            type = TOGGLE,
                            name = "Instant Equip",
                            value = true,
                        },
                        {
                            type = TOGGLE,
                            name = "Fully Automatic",
                            value = true,
                        },
                        {
                            type = TOGGLE,
                            name = "Run and Gun",
                            value = false,
                            tooltip = "Makes it so that your weapon does not\nsway due to mouse movement, or turns over while sprinting.",
                        },
                    },
                },
                {
                    name = { "Extra", "Exploits" },
                    autopos = "right",
                    autofill = true,
                    [1] = {
                        content = {
                            {
                                type = TOGGLE,
                                name = "Ignore Friends",
                                value = true,
                                tooltip = "When turned on, bullets do not deal damage to friends,\nand Rage modules won't target friends.",
                            },
                            {
                                type = TOGGLE,
                                name = "Target Only Priority Players",
                                value = false,
                                tooltip = "When turned on, all modules except for Aim Assist that target players\nwill ignore anybody that isn't on the Priority list.",
                            },
                            {
                                type = TOGGLE,
                                name = "Disable 3D Rendering",
                                value = false,
                                tooltip = "When turned on, all 3D rendering will be disabled.\nThis helps with running multiple instances at once."
                            },
                            {
                                type = TOGGLE,
                                name = "Suppress Only",
                                value = false,
                                tooltip = "When turned on, bullets do not deal damage.",
                            },
                            {
                                type = TOGGLE,
                                name = "Auto Respawn",
                                value = false,
                                tooltip = "Automatically respawns after deaths.",
                            },
                            -- {
                            -- 	type = TOGGLE,
                            -- 	name = "Disable Team Sounds",
                            -- 	value = false,
                            -- 	tooltip = "Disables sounds from all teammates and local player.",
                            -- },
                            {
                                type = DROPBOX,
                                name = "Vote Friends",
                                value = 1,
                                values = { "Off", "Yes", "No" },
                            },
                            {
                                type = DROPBOX,
                                name = "Vote Priority",
                                value = 1,
                                values = { "Off", "Yes", "No" },
                            },
                            {
                                type = DROPBOX,
                                name = "Default Vote",
                                value = 1,
                                values = { "Off", "Yes", "No" },
                            },
                            {
                                type = TOGGLE,
                                name = "Kill Sound",
                                value = false,
                            },
                            {
                                type = TEXTBOX,
                                name = "killsoundid",
                                text = "6229978482",
                                tooltip = "The Roblox sound ID or file inside of synapse\n workspace to play when Kill Sound is on.",
                            },
                            {
                                type = SLIDER,
                                name = "Kill Sound Volume",
                                value = 20,
                                minvalue = 0,
                                maxvalue = 100,
                                stradd = "%",
                            },
                            {
                                type = TOGGLE,
                                name = "Kill Say",
                                value = false,
                                tooltip = "Kill say messages, located in bitchbot/killsay.txt \n[name] is the target's name\n[weapon] is the weapon used\n[hitbox] says head or body depending on where you shot the player",
                            },
                            {
                                type = DROPBOX,
                                name = "Chat Spam",
                                value = 1,
                                values = {
                                    "Off",
                                    "Original",
                                    "t0nymode",
                                    "Chinese Propaganda",
                                    "Emojis",
                                    "Deluxe",
                                    "Youtube Title",
                                    "Custom",
                                    "Custom Combination",
                                },
                                tooltip = "Spams chat, Custom options are located in the bitchbot/chatspam.txt",
                            },
                            {
                                type = TOGGLE,
                                name = "Chat Spam Repeat",
                                value = false,
                                tooltip = "Repeats the same Chat Spam message in chat.",
                            },
                            {
                                type = SLIDER,
                                name = "Chat Spam Delay",
                                minvalue = 1,
                                maxvalue = 10,
                                value = 5,
                                stradd = "s",
                            },
                            -- {
                            -- 	type = TOGGLE,
                            -- 	name = "Impact Grenade",
                            -- 	value = false,
                            -- 	tooltip = "Explodes grenades on impact."
                            -- },
                            -- {
                            -- 	type = TOGGLE,
                            -- 	name = "Auto Martyrdom",
                            -- 	value = false,
                            -- 	tooltip = "Whenever you die to an enemy, this will drop a grenade\nat your death position.",
                            -- },
                            {
                                type = TOGGLE,
                                name = "Break Windows",
                                value = false,
                                tooltip = "Breaks all windows in the map when you spawn."
                            },
                            {
                                type = TOGGLE,
                                name = "Join New Game On Kick",
                                value = false,
                            },
                            {
                                type = BUTTON,
                                name = "Join New Game",
                                unsafe = false,
                                doubleclick = true,
                            },

                        },
                    },
                    [2] = {
                        content = {

                            --[[{
                                type = TOGGLE,
                                name = "Super Invisibility",
                                value = false,
                                extra = {
                                    type = KEYBIND
                                }
                            },]]
                            {
                                type = TOGGLE,
                                unsafe = true,
                                name = "Crash Server",
                                tooltip = "Attempts to overwhelm the server so that users are kicked\nfor internet connection problems.\nThe higher the Crash Intensity the faster it will be,\nbut the higher the chance for it to fail.",
                            },
                            {
                                type = SLIDER, 
                                name = "Crash Intensity",
                                minvalue = 1, 
                                maxvalue = 16,
                                value = 8
                            },
                            -- {
                            -- 	type = TOGGLE,
                            -- 	unsafe = true,
                            -- 	name = "Invisibility",
                            -- 	extra = {
                            -- 		type = KEYBIND,
                            -- 		toggletype = 0,
                            -- 	},
                            -- },
                            {
                                type = TOGGLE,
                                unsafe = true,
                                name = "Rapid Kill",
                                value = false,
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 0,
                                },
                                tooltip = "Throws 3 grenades instantly on random enemies.",
                            },
                            {
                                type = TOGGLE,
                                unsafe = true,
                                name = "Auto Rapid Kill",
                                value = false,
                                tooltip = "Throws 3 grenades instantly on random enemies,\nthen kills itself to do it again.\nWorks only when Rapid Kill is enabled.\nAuto Respawn in Misc->Extra will automate this further.",
                            },
                            {
                                type = TOGGLE,
                                unsafe = true,
                                name = "Grenade Teleport",
                                value = false,
                                tooltip = "Teleports grenades to other players when enabled."
                            },
                            {
                                type = COMBOBOX,
                                name = "Grenade Changes",
                                values = { { "Martyrdom", false } , { "Impact", false }, }
                            },
                            {
                                type = TOGGLE,
                                unsafe = true,
                                name = "Crimwalk",
                                value = false,
                                extra = {
                                    type = KEYBIND,
                                },
                            },
                            {
                                type = TOGGLE,
                                name = "Disable Crimwalk on Shot",
                                value = true,
                                unsafe = true,
                            },
                            {
                                type = TOGGLE,
                                name = "Bypass Speed Checks",
                                value = false,
                                unsafe = true,
                                tooltip = "Attempts to bypass maximum speed limit on the server.",
                            },
                            {
                                type = TOGGLE,
                                name = "Teleport",
                                value = false,
                                unsafe = true,
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 0,
                                },
                                tooltip = "When key pressed you will teleport to the mouse position.\nDoes not work when Bypass Speed Checks is enabled.",
                            },
                            {
                                type = TOGGLE,
                                name = "Vertical Floor Clip",
                                value = false,
                                unsafe = true,
                                extra = {
                                    type = KEYBIND,
                                    toggletype = 0,
                                },
                                tooltip = "Teleports you 19 studs under the ground. Must be over glass or non-collidable parts to work. \nHold Alt to go up, and Shift to go forwards.",
                            },
                            {
                                type = TOGGLE,
                                name = "Fake Equip",
                                value = false,
                                unsafe = true,
                            },
                            {
                                type = DROPBOX,
                                name = "Fake Slot",
                                values = { "Primary", "Secondary", "Melee" },
                                value = 1,
                            },

                            -- {
                            -- 	type = TOGGLE,
                            -- 	name = "Noclip",
                            -- 	value = false,
                            -- 	extra = {
                            -- 		type = KEYBIND,
                            -- 		key = nil
                            -- 	},
                            -- 	unsafe = true,
                            -- 	tooltip = "Allows you to noclip through most parts of the map. Must be over glass or non-collidable parts to work."
                            -- },
                            -- {
                            -- 	type = TOGGLE,
                            -- 	name = "Fake Position",
                            -- 	value = false,
                            -- 	extra = {
                            -- 		type = KEYBIND
                            -- 	},
                            -- 	unsafe = true,
                            -- 	tooltip = "Fakes your server-side position. Works best when stationary, and allows you to be unhittable."
                            -- },
                            {
                                type = TOGGLE,
                                name = "Lock Player Positions",
                                value = false,
                                unsafe = true,
                                extra = {
                                    type = KEYBIND,
                                },
                                tooltip = "Locks all other players' positions.",
                            },
                            -- {
                            -- 	type = TOGGLE,
                            -- 	name = "Skin Changer",
                            -- 	value = false,
                            -- 	tooltip = "While this is enabled, all custom skins will apply with the custom settings below.",
                            -- 	extra = {
                            -- 		type = COLORPICKER,
                            -- 		name = "Weapon Skin Color",
                            -- 		color = { 127, 72, 163, 255 },
                            -- 	},
                            -- },
                            -- {
                            -- 	type = TEXTBOX,
                            -- 	name = "skinchangerTexture",
                            -- 	text = "6156783684",
                            -- },
                            -- {
                            -- 	type = SLIDER,
                            -- 	name = "Scale X",
                            -- 	value = 10,
                            -- 	minvalue = 1,
                            -- 	maxvalue = 500,
                            -- 	stradd = "%",
                            -- },
                            -- {
                            -- 	type = SLIDER,
                            -- 	name = "Scale Y",
                            -- 	value = 10,
                            -- 	minvalue = 1,
                            -- 	maxvalue = 500,
                            -- 	stradd = "%",
                            -- },
                            -- {
                            -- 	type = DROPBOX,
                            -- 	name = "Skin Material",
                            -- 	value = 1,
                            -- 	values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                            -- },
                        },
                    },
                },
            },
        },
        {
            name = "Settings",
            content = {
                {
                    name = "Player List",
                    x = menu.columns.left,
                    y = 66,
                    width = menuWidth - 34,
                    height = 328,
                    content = {
                        {
                            type = "list",
                            name = "Players",
                            multiname = { "Name", "Team", "Status" },
                            size = 9,
                            columns = 3,
                        },
                        {
                            type = IMAGE,
                            name = "Player Info",
                            text = "No Player Selected",
                            size = 72,
                        },
                        {
                            type = DROPBOX,
                            name = "Player Status",
                            x = 307,
                            y = 314,
                            w = 160,
                            value = 1,
                            values = { "None", "Friend", "Priority" },
                        },
                        {
                            type = BUTTON,
                            name = "Votekick",
                            doubleclick = true,
                            x = 307,
                            y = 356,
                            w = 76,
                        },
                        {
                            type = BUTTON,
                            name = "Spectate",
                            x = 391,
                            y = 356,
                            w = 76,
                        },
                    },
                },
                {
                    name = "Cheat Settings",
                    x = menu.columns.left,
                    y = 400,
                    width = menu.columns.width,
                    height = 183,
                    content = {
                        {
                            type = TOGGLE,
                            name = "Menu Accent",
                            value = false,
                            extra = {
                                type = COLORPICKER,
                                name = "Accent Color",
                                color = { 127, 72, 163 },
                            },
                        },
                        {
                            type = TOGGLE,
                            name = "Watermark",
                            value = true,
                        },
                        {
                            type = TOGGLE,
                            name = "Custom Menu Name",
                            value = MenuName and true or false,
                        },
                        {
                            type = TEXTBOX,
                            name = "MenuName",
                            text = MenuName or "Bitch Bot",
                        },
                        {
                            type = BUTTON,
                            name = "Set Clipboard Game ID",
                        },
                        {
                            type = BUTTON,
                            name = "Unload Cheat",
                            doubleclick = true,
                        },
                        {
                            type = TOGGLE,
                            name = "Allow Unsafe Features",
                            value = false,
                        },
                    },
                },
                {
                    name = "Configuration",
                    x = menu.columns.right,
                    y = 400,
                    width = menu.columns.width,
                    height = 183,
                    content = {
                        {
                            type = TEXTBOX,
                            name = "ConfigName",
                            file = true,
                            text = "",
                        },
                        {
                            type = DROPBOX,
                            name = "Configs",
                            value = 1,
                            values = GetConfigs(),
                        },
                        {
                            type = BUTTON,
                            name = "Load Config",
                            doubleclick = true,
                        },
                        {
                            type = BUTTON,
                            name = "Save Config",
                            doubleclick = true,
                        },
                        {
                            type = BUTTON,
                            name = "Delete Config",
                            doubleclick = true,
                        },
                    },
                },
            },
        },
    })

    do -- Watermark setup
        local wm = menu.watermark
        wm.textString = " | " .. BBOT.username .. " | " .. os.date("%b. %d, %Y") .. " | Ver " .. BBOT.version
        wm.pos = Vector2.new(50, 9)
        wm.text = {}
        local fulltext = "Bitch Bot" .. wm.textString
        wm.width = #fulltext * 7 + 10
        wm.height = 19
        wm.rect = {}

        draw:FilledRect(
            false,
            wm.pos.x,
            wm.pos.y + 1,
            wm.width,
            2,
            { menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40, 255 },
            wm.rect
        )
        draw:FilledRect(false, wm.pos.x, wm.pos.y, wm.width, 2, { menu.mc[1], menu.mc[2], menu.mc[3], 255 }, wm.rect)
        draw:FilledRect(false, wm.pos.x, wm.pos.y + 3, wm.width, wm.height - 5, { 50, 50, 50, 255 }, wm.rect)
        for i = 0, wm.height - 4 do
            draw:FilledRect(
                false,
                wm.pos.x,
                wm.pos.y + 3 + i,
                wm.width,
                1,
                { 50 - i * 1.7, 50 - i * 1.7, 50 - i * 1.7, 255 },
                wm.rect
            )
        end
        draw:OutlinedRect(false, wm.pos.x, wm.pos.y, wm.width, wm.height, { 0, 0, 0, 255 }, wm.rect)
        draw:OutlinedRect(false, wm.pos.x - 1, wm.pos.y - 1, wm.width + 2, wm.height + 2, { 0, 0, 0, 255 * 0.4 }, wm.rect)
        draw:OutlinedText(
            fulltext,
            2,
            false,
            wm.pos.x + 5,
            wm.pos.y + 3,
            13,
            false,
            { 255, 255, 255, 255 },
            { 0, 0, 0, 255 },
            wm.text
        )
    end

    hook:Add("AliasChanged", "BBOT:WaterMark", function(old, new)
        bbmenu[27].Text = new
        menu.watermark.text[1].Text = new.. menu.watermark.textString
        for i=1, #menu.watermark.rect do
            local v = menu.watermark.rect[i]
            local len = #menu.watermark.text[1].Text * 7 + 10
            if i == #menu.watermark.rect then
                len += 2
            end
            v.Size = Vector2.new(len, v.Size.y)
        end
    end)
    
    hook:Add("PostInitialize", "BBOT:WaterMark", function()
        for k, v in pairs(menu.watermark.rect) do
            v.Visible = true
        end
        menu.watermark.text[1].Visible = true
    end)
end

-- Auxillary - Responsible for fetching and modifying phantom forces
do
    local math = BBOT.math
    local aux = {}
    BBOT.aux = aux

    -- This is my automated way of fetching and finding shared modules pf uses
    -- How to access -> BBOT.aux.replication
    local aux_tables = {
        ["vector"] = {"random", "anglesyx"},
        ["physics"] = {"timehit"},
        ["animation"] = {"player", "reset"},
        ["gamelogic"] = {"controllerstep", "setsprintdisable"},
        ["camera"] = {"setaimsensitivity", "magnify"},
        ["network"] = {"servertick", "send"},
        ["hud"] = {"addnametag"},
        ["char"] = {"unloadguns", "setunaimedfov", "loadcharacter"},
        ["replication"] = {"getplayerhit"},
        ["roundsystem"] = {"updatekillzone"},
        ["cframe"] = {"fromaxisangle", "toaxisangle", "direct"},
        ["sound"] = {"PlaySound", "play"},
        ["raycast"] = {"raycast", "raycastSingleExit"}
    }

    -- fetches by function name
    -- index is the function you are finding
    -- value is where to put it in aux
    -- true = aux.bulletcheck, replication = aux.replication.bulletcheck
    local aux_functions = {
        ["bulletcheck"] = "raycast",
        ["trajectory"] = "physics",
        ["getupdater"] = "replication",

        -- Not sure where this is supposed to go but ok...
        -- TODO: Nata/Bitch
        ["call"] = true,
        ["gunbob"] = true,
        ["gunsway"] = true,
        ["rankcalculator"] = true,
        ["addplayer"] = true,
        ["removeplayer"] = true,
        ["loadplayer"] = true,
        ["updateplayernames"] = true,
    }

    function aux:_Scan()
        local core_aux, core_aux_sub = {}, {}

        function self._CheckTable(result) -- for now...
            for k, v in next, aux_tables do
                local failed = false
                for i=1, #v do
                    if not rawget(result, v[i]) then
                        failed = true
                        break
                    end
                end
                if not failed then
                    if core_aux[k] ~= result then
                        if core_aux[k] ~= nil then
                            return k
                        else
                            core_aux[k] = result
                            BBOT.log(LOG_DEBUG, 'Found Auxillary "' .. k .. '"')
                        end
                    end
                end
            end
        end

        BBOT.log(LOG_DEBUG, "Scanning...")
        local reg = getgc(true)
        for _,v in next, reg do
            if(typeof(v) == 'table')then
                local ax = self._CheckTable(v)
                if ax then
                    return "Duplicate auxillary \"" .. ax .. "\""
                end
            elseif(typeof(v) == 'function')then
                local ups = debug.getupvalues(v)
                for k, v in pairs(ups) do
                    if typeof(v) == "table" then
                        local succ, ax = pcall(self._CheckTable, v)
                        if succ and ax ~= nil then
                            return "Duplicate auxillary \"" .. ax .. "\""
                        end
                    end
                end

                local name = debug.getinfo(v).name
                if aux_functions[name] then
                    BBOT.log(LOG_DEBUG, 'Found Auxillary Function "' .. name .. '"')
                    core_aux_sub[name] = v
                end
            end
        end

        BBOT.log(LOG_DEBUG, "Scanning auxillaries...")
        for k, v in next, core_aux do
            for kk, vv in next, v do
                if typeof(vv) == "function" then
                    local ups = debug.getupvalues(vv)
                    for kkk, vvv in pairs(ups) do
                        if typeof(vvv) == "table" then
                            local ax = self._CheckTable(vvv)
                            if ax then
                                return "Duplicate auxillary \"" .. ax .. "\""
                            end
                        end
                    end
                end
            end
        end

        BBOT.log(LOG_DEBUG, "Checking auxillaries...")
        for k, v in next, aux_tables do
            if not core_aux[k] then
                return "Couldn't find auxillary \"" .. k ..  "\""
            end
        end

        for k, v in next, core_aux_sub do
            if not aux_functions[k] then
                return "Couldn't find auxillary \"" .. k ..  "\""
            end
        end

        for k, v in next, core_aux do
            self[k] = v
        end

        for k, v in next, core_aux_sub do
            local saveas = aux_functions[k]
            if saveas == true then
                self[k] = v
            else
                if not self[saveas] then
                    self[saveas] = {}
                end
                self[saveas][k] = v
            end
        end
    end

    local profiling_tick = tick()
    local error = aux:_Scan()
    if error then
        BBOT.log(LOG_ERROR, error)
        BBOT.log(LOG_WARN, "For safety reasons this process has been halted")
        return
    end
    local dt = tick() - profiling_tick
    BBOT.log(LOG_NORMAL, "Took " .. math.round(dt, 2) .. "s to load auxillary")
end

-- Chat
do
    local chat = {}
    BBOT.chat = chat
    chat.spam_chat = {}
    chat.spam_kill = {}

    if not isfile("bitchbot/chatspam.txt") then --idk help the user out lol, prevent stupid errors --well it would kinda ig
        writefile(
            "bitchbot/chatspam.txt",
            "WSUP FOOL\nGET OWNED KID\nBBOAT ON TOP\nI LOVE BBOT YEAH\nPLACEHOLDER TEXT \ndear bbot user, edit your chat spam\n	"
        )
    end
    
    if not isfile("bitchbot/killsay.txt") then
        writefile(
            "bitchbot/killsay.txt",
            "WSUP FOOL [name]\nGET OWNED [name]\n[name] just died to my [weapon] everybody laugh\n[name] got owned roflsauce\nPLACEHOLDER TEXT \ndear bbot user, edit your kill say\n	"
        )
    end

    local customtxt = readfile("bitchbot/chatspam.txt")
    for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
        table.insert(chat.spam_chat, s) -- I'm care
    end

    customtxt = readfile("bitchbot/killsay.txt")
    for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
        table.insert(chat.spam_kill, s)
    end
end

-- Weapon Modifications
do
    -- From wholecream
    -- configs aren't done so they are default to screw-pf aka my stuff...
    -- this weapon module allows complete utter freedom of the gun's functions
    local weapons = {}
    BBOT.weapons = weapons
    local hook = BBOT.hook
    local char = BBOT.aux.char
    local config = BBOT.config

    -- Welcome to my hell.
    -- ft. debug.setupvalue
    local profiling_tick = tick()

    local receivers = BBOT.network.receivers
    local upvaluemods = {} -- testing? no problem reloading the script...
    hook:Add("Unload", "UndoWeaponMods", function()
        for i=1, #upvaluemods do
            local v = upvaluemods[i]
            debug.setupvalue(unpack(v))
        end
    end)

    local function DetourKnifeLoader(related_func, index, knifeloader)
        local newfunc = function(...)
            hook:CallP("PreLoadKnife", ...)
            local knifedata = knifeloader(...)
            hook:CallP("PostLoadKnife", knifedata, ...)
            return knifedata
        end
        upvaluemods[#upvaluemods+1] = {related_func, index, knifeloader}
        debug.setupvalue(related_func, index, newcclosure(newfunc))
    end

    local function DetourGunLoader(related_func, index, gunloader)
        local newfunc = function(...)
            hook:CallP("PreLoadGun", ...)
            local gundata = gunloader(...)
            hook:CallP("PostLoadGun", gundata, ...)
            return gundata
        end
        upvaluemods[#upvaluemods+1] = {related_func, index, gunloader}
        debug.setupvalue(related_func, index, newcclosure(newfunc))
    end

    local done = false -- Causes synapse to crash LOL
    local function DetourWeaponRequire(related_func, index, getweapoondata)
        --[[if done then return end
        done = true
        local newfunc = function(...)
            local modifications = getweapoondata(...)
            modifications = BBOT.CopyTable(modifications)
            hook:Call("GetWeaponData", modifications)
            return modifications
        end
        upvaluemods[#upvaluemods+1] = {related_func, index, getweapoondata}
        debug.setupvalue(related_func, index, newfunc)]]
    end

    local function DetourModifyData(related_func, index, modifydata)
        local newfunc = function(...)
            local modifications = modifydata(...)
            hook:CallP("ApplyGunModifications", modifications)
            return modifications
        end
        upvaluemods[#upvaluemods+1] = {related_func, index, modifydata}
        debug.setupvalue(related_func, index, newcclosure(newfunc))
    end

    local done = false
    local function DetourGunSway(related_func, index, gunmovement)
        if done then return end
        done = true
        local newfunc = function(...)
            local cf = gunmovement(...)
            mul = config:GetValue("Weapons", "Stat Modifications", "Movement", "SwayFactor")
            if mul == 0 then
                return CFrame.new()
            end
            local x, y, z = cf:GetComponents()
            x = x * mul
            y = y * mul
            z = z * mul
            local pitch, yaw, roll = cf:ToEulerAnglesYXZ()
            pitch, yaw, roll = pitch * mul, yaw * mul, roll * mul
            cf = CFrame.Angles(pitch, yaw, roll) + Vector3.new(x, y, z)
            return cf
        end
        upvaluemods[#upvaluemods+1] = {related_func, index, gunmovement}
        debug.setupvalue(related_func, index, newcclosure(newfunc))
    end

    local function DetourGunBob(related_func, index, gunmovement)
        local newfunc = function(...)
            local cf = gunmovement(...)
            mul = config:GetValue("Weapons", "Stat Modifications", "Movement", "BobFactor")
            if mul == 0 then
                return CFrame.new()
            end
            local x, y, z = cf:GetComponents()
            x = x * mul
            y = y * mul
            z = z * mul
            local pitch, yaw, roll = cf:ToEulerAnglesYXZ()
            pitch, yaw, roll = pitch * mul, yaw * mul, roll * mul
            cf = CFrame.Angles(pitch, yaw, roll) + Vector3.new(x, y, z)
            return cf
        end
        upvaluemods[#upvaluemods+1] = {related_func, index, gunmovement}
        debug.setupvalue(related_func, index, newcclosure(newfunc))
    end

    local function hasvalue(tbl, value)
        for i=1, #tbl do
            local v = tbl[i]
            if v == value then
                return true
            end
        end
    end

    local workspace = BBOT.service:GetService("Workspace")
    for k, v in pairs(receivers) do
        local ups = debug.getupvalues(v)
        for upperindex, related_func in pairs(ups) do
            if typeof(related_func) == "function" then
                local funcname = debug.getinfo(related_func).name
                if funcname == "loadgun" then
                    local _ups = debug.getupvalues(related_func)
                    for index, modifydata in pairs(_ups) do
                        if typeof(modifydata) == "function" then
                            -- this also contains "gunbob" and "gunsway"
                            -- we can change these as well...
                            local name = debug.getinfo(modifydata).name
                            if name == "gunrequire" then
                                DetourWeaponRequire(related_func, index, modifydata)
                            elseif name == "modifydata" then
                                DetourModifyData(related_func, index, modifydata) -- Stats modification
                            elseif name == "gunbob" then
                                DetourGunBob(related_func, index, modifydata)
                            elseif name == "gunsway" then
                                DetourGunSway(related_func, index, modifydata)
                            end
                        end
                    end

                    DetourGunLoader(v, upperindex, related_func) -- this will allow us to modify before and after events of gun loading
                    -- Want rainbow guns? well there ya go
                elseif funcname == "loadknife" then
                    local _ups = debug.getupvalues(related_func)
                    for index, modifydata in pairs(_ups) do
                        if typeof(modifydata) == "function" then
                            -- this also contains "gunbob" and "gunsway"
                            -- we can change these as well...
                            local name = debug.getinfo(modifydata).name
                            if name == "gunbob" then
                                DetourGunBob(related_func, index, modifydata)
                            elseif name == "gunsway" then
                                DetourGunSway(related_func, index, modifydata)
                            end
                        end
                    end

                    DetourKnifeLoader(v, upperindex, related_func)
                end
            end
        end
    end

    do
        local ogrenadeloader = rawget(char, "loadgrenade")
        hook:Add("Unload", "UndoWeaponDetourGrenades", function()
            rawset(char, "loadgrenade", ogrenadeloader)
        end)
        local function loadgrenadee(self, ...)
            hook:CallP("PreLoadGrenade", ...)
            local gundata = ogrenadeloader(self, ...)
            hook:CallP("PostLoadGrenade", gundata)
            return gundata
        end
        rawset(char, "loadgrenade", newcclosure(loadgrenadee))
    end

    -- setup of our detoured controllers
    hook:Add("PostLoadKnife", "PostLoadKnife", function(gundata, gunname)
        local ups = debug.getupvalues(gundata.destroy)
        for k, v in pairs(ups) do
            local t = typeof(v)
            if t == "Instance" and v.ClassName == "Model" then
                gundata._model = v
            end
        end

        local oldhide = gundata.hide
        function gundata.hide(...)
            hook:Call("PreHideKnife", gundata, ...)
            return oldhide(...), hook:Call("PostHideKnife", gundata, ...)
        end

        local oldshow = gundata.show
        function gundata.show(...)
            hook:Call("PreShowKnife", gundata, ...)
            return oldshow(...), hook:Call("PostShowKnife", gundata, ...)
        end

        local olddestroy = gundata.destroy
        function gundata.show(...)
            hook:Call("PreDestroyKnife", gundata, ...)
            return olddestroy(...), hook:Call("PostDestroyKnife", gundata, ...)
        end

        local oldsetequipped = gundata.setequipped
        function gundata.show(...)
            hook:Call("PreEquippedKnife", gundata, ...)
            return oldsetequipped(...), hook:Call("PostEquippedKnife", gundata, ...)
        end

        local ups = debug.getupvalues(gundata.playanimation)
        for k, v in pairs(ups) do
            local t = typeof(v)
            if t == "table" and v.camodata and typeof(v.larm) == "table" and v.larm.basec0 then
                gundata._anims = v
            end
        end

        local oldstep = gundata.step
        function gundata.step(...)
            if core.gamelogic.currentgun == gundata then
                hook:CallP("PreKnifeStep", gundata)
            end
            local a, b, c, d = oldstep(...)
            if core.gamelogic.currentgun == gundata then
                hook:CallP("PostKnifeStep", gundata)
            end
            return a, b, c, d
        end
    end)

    hook:Add("PostLoadGun", "PostLoadGun", function(gundata, gunname)
        local oldstep = gundata.step
        local ups = debug.getupvalues(oldstep)
        local partdata
        for k, v in pairs(ups) do
            if typeof(v) == "function" then
                local sups = debug.getupvalues(v)
                for kk, vv in pairs(sups) do
                    local t = typeof(vv)
                    if t == "table" and vv.sightpart and vv.sight then
                        partdata = vv
                    end
                end
            end
        end

        local ups = debug.getupvalues(gundata.playanimation)
        for k, v in pairs(ups) do
            local t = typeof(v)
            if t == "table" and v.camodata and typeof(v.larm) == "table" and v.larm.basec0 then
                gundata._anims = v
            end
        end

        local ups = debug.getupvalues(gundata.destroy)
        for k, v in pairs(ups) do
            local t = typeof(v)
            if t == "Instance" and v.ClassName == "Model" then
                gundata._model = v
            end
        end

        local oldreloadcancel = gundata.reloadcancel
        function gundata.reloadcancel(self, force, ...)
            if force then
                gundata._lastreloadcancel = tick()
            end
            return oldreloadcancel(self, force, ...)
        end

        local oldhide = gundata.hide
        function gundata.hide(...)
            hook:Call("PreHideWeapon", gundata, ...)
            return oldhide(...), hook:Call("PostHideWeapon", gundata, ...)
        end

        local oldshow = gundata.show
        function gundata.show(...)
            hook:Call("PreShowWeapon", gundata, ...)
            return oldshow(...), hook:Call("PostShowWeapon", gundata, ...)
        end

        local olddestroy = gundata.destroy
        function gundata.destroy(...)
            hook:Call("PreDestroyWeapon", gundata, ...)
            return olddestroy(...), hook:Call("PostDestroyWeapon", gundata, ...)
        end

        local oldsetequipped = gundata.setequipped
        function gundata.setequipped(...)
            hook:Call("PreEquippedWeapon", gundata, ...)
            return oldsetequipped(...), hook:Call("PostEquippedWeapon", gundata, ...)
        end

        local ups = debug.getupvalues(oldsetequipped)
        for k, v in pairs(ups) do
            if typeof(v) == "function" then
                local name = debug.getinfo(v).name
                if name == "updatefiremodestability" then
                    local ups = debug.getupvalues(v)
                    for kk, vv in pairs(ups) do
                        if typeof(vv) == "number" then
                            if kk == 4 and vv == 1 then
                                function gundata:getfiremode()
                                    local mode = debug.getupvalue(v, kk) or 1
                                    local rate
                                    if typeof(self.data.firerate) == "table" then
                                        rate = self.data.firerate[mode]
                                    else
                                        rate = self.data.firerate
                                    end
                                    return self.data.firemodes[mode], rate
                                end
                            end
                        end
                    end
                end
            end
        end

        function gundata.step(...)
            -- this is where the aimbot controller will be
            if core.gamelogic.currentgun == gundata then
                if not gundata.partdata then
                    gundata.partdata = partdata
                end
                hook:CallP("PreWeaponStep", gundata, partdata)
            end
            local a, b, c, d = oldstep(...)
            if core.gamelogic.currentgun == gundata then
                hook:CallP("PostWeaponStep", gundata, partdata)
            end
            return a, b, c, d
        end
    end)

    -- @nata and @bitch, here is how your new modifications will now work, this is a sample from screw-pf

    hook:Add("ApplyGunModifications", "BBOT:ModifyWeapon.Recoil", function(modifications)
        if not config:GetValue("Weapons", "Stat Modifications", "Enable") then return end
        local rot = config:GetValue("Weapons", "Stat Modifications", "Recoil", "RotationFactor")
        local trans = config:GetValue("Weapons", "Stat Modifications", "Recoil", "TransitionFactor")
        local cam = config:GetValue("Weapons", "Stat Modifications", "Recoil", "CameraFactor")
        local aim = config:GetValue("Weapons", "Stat Modifications", "Recoil", "AimFactor")
        modifications.rotkickmin = modifications.rotkickmin * rot;
        modifications.rotkickmax = modifications.rotkickmax * rot;
        
        modifications.transkickmin = modifications.transkickmin * trans;
        modifications.transkickmax = modifications.transkickmax * trans;
        
        modifications.camkickmin = modifications.camkickmin * cam;
        modifications.camkickmax = modifications.camkickmax * cam;
        
        modifications.aimrotkickmin = modifications.aimrotkickmin * rot * aim;
        modifications.aimrotkickmax = modifications.aimrotkickmax * rot * aim;
        
        modifications.aimtranskickmin = modifications.aimtranskickmin * trans * aim;
        modifications.aimtranskickmax = modifications.aimtranskickmax * trans * aim;
        
        modifications.aimcamkickmin = modifications.aimcamkickmin * cam * aim;
        modifications.aimcamkickmax = modifications.aimcamkickmax * cam * aim;

        local cks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "CamKickSpeed")
        local acks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "AimCamKickSpeed")
        local mks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelKickSpeed")
        local mrs = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelRecoverSpeed")
        local mkd = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelKickDamper")

        modifications.camkickspeed = modifications.camkickspeed * cks;
        modifications.aimcamkickspeed = modifications.aimcamkickspeed * acks;
        modifications.modelkickspeed = modifications.modelkickspeed * mks;
        modifications.modelrecoverspeed = modifications.modelrecoverspeed * mrs;
        modifications.modelkickdamper = modifications.modelkickdamper * mkd;
    end)
end

-- Init
do
    BBOT.hook:Call("PreInitialize")
    BBOT.hook:Call("Initialize")
    BBOT.hook:Call("PostInitialize")
end

-- The Moment
do
    local loadtime = (BBOT.math.round(tick()-loadstart, 6))
    BBOT.timer:Async(function()
        BBOT.notification:Create(string.format("Done loading the " .. BBOT.game .. " cheat. (%d ms)", loadtime*1000))
        BBOT.notification:Create("Press DELETE to open and close the menu!")
    end)
end
end

local ran, err = xpcall(ISOLATION, debug.traceback, BBOT)
if not ran then
    BBOT.log(LOG_ERROR, "Error loading Bitch Bot -", err)
end