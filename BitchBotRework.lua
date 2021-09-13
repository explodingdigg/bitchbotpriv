--[[
    Hi, this is WholeCream further known as NiceCream
    I've decided to completely rework it to use my libraries.
    For future reference these libraries can be separated in the future!\

    Your welcome - WholeCream
]]

local _BBOT = _G.BBOT
local BBOT = BBOT or { username = "dev", alias = "Bitch Bot" } -- I... um... fuck off ok?
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
        if BBOT.menu and BBOT.menu.console then
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

    _table.deepcopy = dcopy

    -- reverses a numerical table
    function _table.reverse(tbl)
        local new_tbl = {}
        for i = 1, #tbl do
            new_tbl[#tbl + 1 - i] = tbl[i]
        end
        return new_tbl
    end
end

-- Math
do
    local math = BBOT.table.deepcopy(math)
    BBOT.math = math

    -- Remaps a value to new min and max
    function math.remap( value, inMin, inMax, outMin, outMax ) -- ty gmod
        return outMin + ( ( ( value - inMin ) / ( inMax - inMin ) ) * ( outMax - outMin ) )
    end

    function math.round( num, idp ) -- ty gmod again
        local mult = 10 ^ ( idp or 0 )
        return math.floor( num * mult + 0.5 ) / mult
    end
end

BBOT.service = {}
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
    end)

    hook:bindEvent(userinputservice.InputBegan, "InputBegan")
    hook:bindEvent(userinputservice.InputEnded, "InputEnded")

    mouse.Move:Connect(function()
        hook:CallP("Mouse.Move", mouse.X, mouse.Y)
    end)

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

    function timer.HandleError()

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

--! POST LIBRARIES !--

-- Setup
do
    if game.PlaceId == 292439477 or game.PlaceId == 299659045 or game.PlaceId == 5281922586 or game.PlaceId == 3568020459 then
        BBOT.game = "pf"
    else
        BBOT.game = "universal"
    end

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
end

-- Notifications
do
    local hook = BBOT.hook
    local workspace = BBOT.service:GetService("Workspace")
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

        meta.Remove = function(self, d)
            if d.Position.x < d.Size.x then
                for k, drawing in pairs(self.drawings) do
                    drawing:Remove()
                    drawing = false
                end
                self.enabled = false
            end
        end

        meta.Update = function(self, num, listLength, dt)
            local pos = self.targetPos

            local indexOffset = (listLength - num) * gap
            if insety < indexOffset then
                insety -= (insety - indexOffset) * 0.2
            else
                insety = indexOffset
            end
            local size = self.size

            local tpos = Vector2.new(pos.x - size.x / time - map(alpha, 0, 255, size.x, 0), pos.y + insety)
            self.pos = tpos

            local locRect = {
                x = math.ceil(tpos.x),
                y = math.ceil(tpos.y),
                w = math.floor(size.x - map(255 - alpha, 0, 255, 0, 70)),
                h = size.y,
            }
            --pos.set(-size.x / fc - map(alpha, 0, 255, size.x, 0), pos.y)

            local fade = math.min(time * 12, alpha)
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

                time += estep * dt * 128 -- TODO need to do the duration
                estep += eestep * dt * 64
            end
        end

        meta.Fade = function(self, num, len, dt)
            if self.pos.x > self.targetPos.x - 0.2 * len or self.fading then
                if not self.fading then
                    estep = 0
                end
                self.fading = true
                alpha -= estep / 4 * len * dt * 50
                eestep += 0.01 * dt * 100
            end
            if alpha <= 0 then
                self:Remove(self.drawings[1])
            end
        end
    end

    function notification:Create(t, customcolor)
        local gap = 25
        local width = 18

        local alpha = 255
        local time = 0
        local estep = 0
        local eestep = 0.02

        local insety = 0

        local Note = {

            enabled = true,

            targetPos = Vector2.new(50, 33),

            size = Vector2.new(200, width),

            drawings = {
                outline = Rectangle(202, width + 2, false, Color3.new(0, 0, 0)),
                fade = Rectangle(202, width + 2, false, Color3.new(0, 0, 0)),
            },
        }

        setmetatable(Note, {__index = self.meta})

        for i = 1, Note.size.y - 2 do
            local c = 0.28 - i / 80
            Note.drawings[i] = Rectangle(200, 1, true, Color3.new(c, c, c))
        end

        local menu = BBOT.menu
        local color = (menu and menu.GetVal) and customcolor or menu:GetVal("Settings", "Cheat Settings", "Menu Accent") and Color3.fromRGB(unpack(menu:GetVal("Settings", "Cheat Settings", "Menu Accent", COLOR))) or Color3.fromRGB(127, 72, 163)

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
    local menu = {}
    BBOT.menu = {}

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

-- Init
do
    BBOT.hook:Call("PreInitalize")
    BBOT.hook:Call("Initalize")
    BBOT.hook:Call("PostInitalize")
end
end

local ran, err = xpcall(ISOLATION, debug.traceback, BBOT)
if not ran then
    BBOT.log(LOG_ERROR, "Error loading Bitch Bot -", err)
end