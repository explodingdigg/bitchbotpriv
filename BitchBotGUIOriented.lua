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
local username = (BBOT and BBOT.username or nil)
if BBOT and BBOT.__init then
    BBOT = nil
end
local BBOT = BBOT or { username = (username or "dev"), alias = "Bitch Bot", version = "¯\\_(?)_/¯", __init = true } -- I... um... fuck off ok?
_G.BBOT = BBOT
BBOT.game = "pf"
-- Locals/Upvalues
-- Critical for quick stuff
-- Note: Find a way to put this into an isolated global table
local LOG_NORMAL, LOG_DEBUG, LOG_WARN, LOG_ERROR, LOG_ANON = 1, 2, 3, 4, 5 -- Logs

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
        ["Vector3"] = {"Vector3.new(", ")"},
        ["Vector2"] = {"Vector2.new(", ")"},
        ["Color3"] = {"Color3.fromRGB(", ")"},
        ["CFrame"] = {"CFrame.new(", ")"}
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

    do
        local _string_rep = string.rep
        local _string_len = string.len
        local _string_sub = string.sub
        local _table_concat = table.concat
        local _print = print
        local _tostring = tostring
        local _pairs = pairs
        local _type = typeof
        local _string_find = string.find
        local function string_Explode(separator, str, withpattern)
            if ( withpattern == nil ) then withpattern = false end

            local ret = {}
            local current_pos = 1

            for i = 1, _string_len( str ) do
                local start_pos, end_pos = _string_find( str, separator, current_pos, not withpattern )
                if ( not start_pos ) then break end
                ret[ i ] = _string_sub( str, current_pos, start_pos - 1 )
                current_pos = end_pos + 1
            end

            ret[ #ret + 1 ] = _string_sub( str, current_pos )

            return ret
        end

        local _string_Replace = function( str, tofind, toreplace )
            local tbl = string_Explode( tofind, str )
            if ( tbl[ 1 ] ) then return _table_concat( tbl, toreplace ) end
            return str
        end

        local PrintTable_Restore = {['\b'] = '\\b', ['\f'] = '\\f', ['\v'] = '\\v', ['\0'] = '\\0', ['\r'] = '\\r', ['\n'] = '\\n', ['\t'] = '\\t'}
        function log.printtable(t, indent, c)
            if not indent then indent = 1 end
            local ind = _string_rep( '\t', indent )
            if _type(t) == 'table' then
                log.anonprint('{\n')
                for k,v in _pairs(t) do
                    if _type(k) ~= 'number' then
                        k = _tostring(k)
                        k = '"'..k..'"'
                    else
                        k = valuetoprintable(k)
                    end
                    for _k, _v in _pairs(PrintTable_Restore) do
                        k = _string_Replace(k, _k, _v)
                    end
                    log.anonprint(ind .. '['..k..'] = ')
                    log.printtable(v, indent + 1, true)
                    log.anonprint(',\n')
                end
                if c then
                    log.anonprint(_string_rep( '\t', (indent-1 > 0 and indent-1 or 0) ) .. '}')
                    return
                end
                log.anonprint('}\n')
            else
                if _type(t) == 'string' then
                    t = _tostring(t)
                    t = '"'..t..'"'
                else
                    t = valuetoprintable(t)
                end
                for k, v in _pairs(PrintTable_Restore) do
                    t = _string_Replace(t, k, v)
                end
                log.anonprint(t)
            end
        end
    end

    game:GetService("RunService"):UnbindFromRenderStep("FW0a9kf0w2of00-Last")
    game:GetService("RunService"):BindToRenderStep("FW0a9kf0w2of00-Last", Enum.RenderPriority.Last.Value, function(...)
        for i=1, #scheduler do
            local v = scheduler[i]
            if v[1] == 1 then
                local text = valuetoprintable(unpack(v[2]))
                rconsoleprint('@@WHITE@@')
                rconsoleprint(text)
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

function BBOT.halt() -- use this if u wana but breaks in the code
    BBOT.log(LOG_WARN, "Halted!")
    error()
end

do
    local function round( num, idp )
        local mult = 10 ^ ( idp or 0 )
        return math.floor( num * mult + 0.5 ) / mult
    end

    if _BBOT and BBOT.username == "dev" then
        BBOT.log(3, "Bitch Bot is already running")
        if not _BBOT.Unloaded and _BBOT.hook and _BBOT.hook.CallP then
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
    local _rawset = rawset
    local dcopy
    dcopy = function( t, lookup_table )
        if ( t == nil ) then return nil end
    
        local copy = {}
        setmetatable( copy, debug.getmetatable( t ) )
        for i, v in pairs( t ) do
            if ( typeof( v ) ~= "table" ) then
                if v ~= nil then
                    _rawset(copy, i, v)
                end
            else
                lookup_table = lookup_table or {}
                lookup_table[ t ] = copy
                if ( lookup_table[ v ] ) then
                    _rawset(copy, i, lookup_table[ v ])
                else
                    _rawset(copy, i, dcopy( v, lookup_table ))
                end
            end
        end
        return copy
    end

    local _table = dcopy(table)
    BBOT.table = _table
    local table = _table

    table.deepcopy = dcopy

    function table.quicksearch(tbl, value)
        for i=1, #tbl do
            if tbl[i] == value then return true end
        end
        return false
    end

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

    local function keyValuePairs( state )
        state.Index = state.Index + 1
        local keyValue = state.KeyValues[ state.Index ]
        if ( not keyValue ) then return end
        return keyValue.key, keyValue.val
    end

    local function toKeyValues( tbl )
        local result = {}
        for k,v in pairs( tbl ) do
            table.insert( result, { key = k, val = v } )
        end
        return result
    end

    function table.sortedpairs( pTable, Desc )
        local sortedTbl = toKeyValues( pTable )
        if ( Desc ) then
            table.sort( sortedTbl, function( a, b ) return a.key > b.key end )
        else
            table.sort( sortedTbl, function( a, b ) return a.key < b.key end )
        end
        return keyValuePairs, { Index = 0, KeyValues = sortedTbl }
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

    function math.timefraction( Start, End, Current )
        return ( Current - Start ) / ( End - Start )
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

    function string.random(len, len2)
        local str, length = "", (len2 and math.random(len, len2) or len)
        for i = 1, length do
            local typo = math.random(1, 3)
            if typo == 1 then
                str = str.. string.char(math.random(97, 122))
            elseif typo == 2 then
                str = str.. string.char(math.random(65, 90))
            elseif typo == 3 then
                str = str.. string.char(math.random(49, 57))
            end
        end
        return str
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
                local _name, func = v[1], v[2]
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
    local log = BBOT.log
    function hook:CallP(name, ...) -- Same as @hook:Call, put with error isolation
        if not self.registry[name] then return end
        local tbl, tbln = self._registry_qa[name], self.registry[name]
    
        if tbln[name] then
            local func = tbln[name]
            local ran, a, b, c, d, e, f = xpcall(func, debug.traceback, ...)
            if not ran then
                log(LOG_ERROR, "Hook Error - ", name, " - ", name)
                log(LOG_NORMAL, a)
                log(LOG_WARN, "Removing to prevent cascade!")
                for l=1, #tbl do
                    local v = tbl[l]
                    if v[1] == name then
                        table.remove(tbl, l); tbln[name] = nil
                        break
                    end
                end
            elseif a ~= nil then
                return a, b, c, d, e, f
            end
        end
        
        local _c = 0
        for l=1, #tbl do
            local k = l-_c
            local v = tbl[k]
            if v[1] ~= name then
                local _name, func = v[1], v[2]
                if not func then 
                    table.remove(tbl, k); _c = _c + 1; tbln[_name] = nil
                else
                    if not _name then 
                        table.remove(tbl, k); _c = _c + 1; tbln[_name] = nil
                    else
                        local ran, a, b, c, d, e, f = xpcall(func, debug.traceback, ...)
                        if not ran then
                            log(LOG_ERROR, "Hook Error - ", name, " - ", _name)
                            log(LOG_NORMAL, a)
                            log(LOG_WARN, "Removing to prevent cascade!")
                            table.remove(tbl, k); _c = _c + 1; tbln[_name] = nil
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
    local camera = BBOT.service:GetService("CurrentCamera")

    hook:bindEvent(userinputservice.InputBegan, "InputBegan")
    hook:bindEvent(userinputservice.InputEnded, "InputEnded")

    local lastMousePos = Vector2.new()
    hook:Add("RenderStep.First", "Mouse.Move", function()
        local x, y = mouse.X, mouse.Y
        hook:Call("Mouse.Move", lastMousePos ~= Vector2.new(x, y), x, y)
        lastMousePos = Vector2.new(x, y)
    end)

    local camera_changed = camera.Changed:Connect(function(property)
        if property == "ViewportSize" then
            hook:CallP("Camera.ViewportChanged", camera.ViewportSize)
        end
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

    hook:Add("Unload", "BBOT:Hooks.Services", function()
        camera_changed:Disconnect()
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-First")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Input")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Camera")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Character")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-Last")
        runservice:UnbindFromRenderStep("FW0a9kf0w2of0-R")
    end)
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
    local draw = {
        registry = {}
    }
    BBOT.draw = draw
    
    hook:Add("Unload", "BBOT:Draw.Unload", function()
		for k, v in pairs(draw.registry) do
            if v and type(v) ~= "number" and v.__OBJECT_EXISTS then
                v:Remove()
            end
		end
    end)

    function draw:IsValid(object)
        if object and type(object) ~= "number" and object.__OBJECT_EXISTS then
            return true
        end
    end

    function draw:Create(class)
        local object = Drawing.new(class)
        object.ZIndex = 0
        self.registry[#self.registry+1] = object
        return object
    end

    function draw:VerifyColor(c)
        local t = typeof(c)
        if t == "Color3" then
            return c
        elseif t == "table" and c[1] then
            return Color3.fromRGB(c[1], c[2], c[3])
        end
    end

    function draw:Quad(pa, pb, pc, pd, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Quad")
		object.Visible = visible
		object.Color = self:VerifyColor(color)
		object.Filled = true
		object.Thickness = thickness or 0
		object.Transparency = transparency
		if pa and pb and pc then
			object.PointA = Vector2.new(pa[1], pa[2])
			object.PointB = Vector2.new(pb[1], pb[2])
			object.PointC = Vector2.new(pc[1], pc[2])
            object.PointD = Vector2.new(pd[1], pd[2])
		end
		return object
    end

	function draw:BoxOutline(x, y, w, h, thickness, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Square")
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = Vector2.new(w, h)
		object.Color = self:VerifyColor(color)
		object.Filled = false
		object.Thickness = thickness or 0
		object.Transparency = transparency 
		return object
	end

	function draw:Box(x, y, w, h, thickness, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Square")
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = Vector2.new(w, h)
		object.Color = self:VerifyColor(color)
		object.Filled = true
		object.Thickness = thickness or 0
		object.Transparency = transparency 
		return object
	end

	function draw:Line(thickness, start_x, start_y, end_x, end_y, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Line")
		object.Visible = visible
		object.Thickness = thickness
		object.From = Vector2.new(start_x, start_y)
		object.To = Vector2.new(end_x, end_y)
		object.Color = self:VerifyColor(color)
		object.Transparency = transparency 
		return object
	end

	function draw:Image(imagedata, x, y, w, h, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Image")
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = Vector2.new(w, h)
		object.Transparency = transparency 
		object.Data = imagedata or placeholderImage
		return object
	end

	function draw:Text(text, font, x, y, size, centered, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Text")
		object.Text = text
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = size
		object.Center = centered
		object.Color = self:VerifyColor(color)
		object.Transparency = transparency 
		object.Outline = false
		object.Font = font
		return object
	end

	function draw:TextOutlined(text, font, x, y, size, centered, color, color2, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Text")
		object.Text = text
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = size
		object.Center = centered
		object.Color = self:VerifyColor(color)
		object.Transparency = transparency 
		object.Outline = true
		object.OutlineColor = color2
		object.Font = font
		return object
	end

	function draw:Triangle(pa, pb, pc, color, filled, transparency, visible)
        if filled == nil then filled = true end
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		color = color or { 255, 255, 255, 1 }
		local object = self:Create("Triangle")
		object.Visible = visible
		object.Transparency = transparency
		object.Color = self:VerifyColor(color)
		object.Thickness = 4.1
		if pa and pb and pc then
			object.PointA = Vector2.new(pa[1], pa[2])
			object.PointB = Vector2.new(pb[1], pb[2])
			object.PointC = Vector2.new(pc[1], pc[2])
		end
		object.Filled = filled
		return object
	end

	function draw:CircleOutline(x, y, size, thickness, sides, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Circle")
		object.Position = Vector2.new(x, y)
		object.Visible = visible
		object.Radius = size
		object.Thickness = thickness
		object.NumSides = sides
		object.Transparency = transparency 
		object.Filled = false
		object.Color = self:VerifyColor(color)
		return object
	end

	function draw:Circle(x, y, size, thickness, sides, color, transparency, visible)
        if visible == nil then visible = true end
        if transparency == nil then transparency = 1 end
		local object = self:Create("Circle")
		object.Position = Vector2.new(x, y)
		object.Visible = visible
		object.Radius = size
		object.Thickness = thickness
		object.NumSides = sides
		object.Transparency = transparency 
		object.Filled = true
		object.Color = self:VerifyColor(color)
		return object
	end
end

-- Setup
do
    -- There are two types of instruction
    -- 1. Config Instructions
    -- 2. Menu Instructions

    -- Config Instructions results in the building of the config module's quick access table
    -- Menu Instructions results in the generation and setup of all menus
    BBOT.configuration = {
        {
            -- The first layer here is the frame
            Id = "Env",
            name = "Environment",
            pos = UDim2.new(0, 520, 0, 100),
            size = UDim2.new(0, 599, 0, 501),
            type = "Tabs",
            content = { -- by default operation is tabs
                { -- Do not assign types in here, as tabs automatically assigns them as "Panel"
                    name = "Players",
                    pos = UDim2.new(0,10,0,10),
                    size = UDim2.new(1,-20,1,-20),
                    type = "Panel",
                    content = {
                        {
                            name = "Player List", -- No type means auto-set to panel
                            pos = UDim2.new(0,5,0,5),
                            size = UDim2.new(.5,-10,1,-10),
                            type = "Panel",
                            content = {},
                        },
                        {
                            name = "Player Control",
                            pos = UDim2.new(.5,10,0,5),
                            size = UDim2.new(.5,-15,1,-10),
                            type = "Panel",
                            content = {},
                        },
                    },
                },
            }
        }
    }
end

-- Configs
do
    -- To do, add a config verification system
    -- To do, menu shouldn't be tied together wirh config
        -- Configs should have it's own dedicated handle
    -- To do, I don't want to have to do this, but I might make an entirely new config system
        -- Cause why not... and also right now things are just all over the place...
    -- To do, make a parser for configs

    local hook = BBOT.hook
    local table = BBOT.table
    local userinputservice = BBOT.service:GetService("UserInputService")
    local httpservice = BBOT.service:GetService("HttpService")
    local config = {
        registry = {}, -- storage of the current configuration
        enums = {}
    }
    BBOT.config = config

    config.storage_pathway = "bitchbot/" .. BBOT.game
    config.storage_main = "bitchbot"
    config.storage_extension = ".bb"

    if not isfolder(config.storage_pathway) then
        makefolder(config.storage_pathway)
    end

    if not isfolder(config.storage_main) then
        makefolder(config.storage_main)
    end

    do -- key binds
        local enums = Enum.KeyCode:GetEnumItems()
        local enumstable, enumtoID, IDtoenum = {}, {}, {}
        for k, v in table.sortedpairs(enums) do
            local keyname = string.sub(tostring(v), 14)
            if not string.find( keyname, "World", 1, true ) then
                enumstable[#enumstable+1] = keyname
                enumtoID[keyname] = v
                IDtoenum[v] = keyname
            end
        end

        enumstable[#enumstable+1] = "MouseButton1"
        enumtoID["MouseButton1"] = Enum.UserInputType.MouseButton1
        IDtoenum[Enum.UserInputType.MouseButton1] = "MouseButton1"
        enumstable[#enumstable+1] = "MouseButton2"
        enumtoID["MouseButton2"] = Enum.UserInputType.MouseButton2
        IDtoenum[Enum.UserInputType.MouseButton2] = "MouseButton2"
        config.enums.KeyCode = {
            inverseId = IDtoenum,
            Id = enumtoID,
            List = enumstable
        }
    end

    do -- materials
        local mats, matstoid = {}, {}
        local enums = Enum.Material:GetEnumItems()
        for k, v in table.sortedpairs(enums) do
            local keyname = string.sub(tostring(v), 15)
            mats[#mats+1] = keyname
            matstoid[keyname] = v
        end

        config.enums.Material = {
            Id = matstoid,
            List = mats
        }
    end

    -- EX:
    --[[
        hook:Add("OnConfigChanged", "BBOT:ChamsChanged", function(path, old, new)
            if config:IsPathwayEqual(path, "Visuals", "Chams") then
                chams:Rebuild()
            end
        end)
    ]]
    function config:IsPathwayEqual(pathway, ...)
        local steps = {...}
        for i=1, #steps do
            if pathway[i] ~= steps[i] then
                return false
            end
        end
        return true
    end

    function config:GetKeyID(...)
        local key = self:GetValue(...)
        return config.enums.KeyCode.Id[key]
    end

    local userinputservice = BBOT.service:GetService("UserInputService")
    function config:IsKeyDown(...)
        local keyid = self:GetKeyID(...)
        if not keyid then return false end

        if keyid == Enum.UserInputType.MouseButton1 or keyid == Enum.UserInputType.MouseButton2 then
            return userinputservice:IsMouseButtonPressed(keyid)
        end

        return userinputservice:IsKeyDown(keyid)
    end

    function config:InputIsKeyDown(input, ...)
        local keyid = self:GetKeyID(...)
        if not keyid then return false end

        if keyid == Enum.UserInputType.MouseButton1 or keyid == Enum.UserInputType.MouseButton2 then
            if input.UserInputType == keyid then
                return true
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == keyid then
                return true
            end
        end
        return false
    end

    -- EX: config:GetValue("Aimbot", "Rage", "Silent Aim")
    -- You can also return a raw table for easier iteration of data
    function config:GetValue(...)
        local steps = {...}
        local reg = self.registry
        for i=1, #steps do
            reg = reg[steps[i]]
            if reg == nil then break end
        end
        if reg == nil then return end
        if typeof(reg) == "table" then
            if reg.self ~= nil then
                local s = reg.self
                if typeof(s) == "table" and reg.type and reg.type ~= BUTTON then
                    return s.value
                end
                return s
            end
            if reg.type and reg.type ~= BUTTON then
                return reg.value
            end
        end
        return reg
    end

    -- EX: config:SetValue(true, "Aimbot", "Rage", "Silent Aim")
    function config:SetValue(value, ...)
        local steps = {...}
        local reg, len = self.registry, #steps
        for i=1, len-1 do
            reg = reg[steps[i]]
            if reg == nil then break end
        end
        local final = steps[len]
        if reg[final] == nil then return false end
        local old = reg[final]
        if typeof(old) == "table" then
            if old.self ~= nil then
                local o = old.self
                if typeof(o) == "table" then
                    if o.type and o.type ~= BUTTON then
                        local oo = o.value
                        o.value = value
                        hook:Call("OnConfigChanged", steps, oo, value)
                    end
                else
                    old.self = value
                    hook:Call("OnConfigChanged", steps, o, value)
                end
            elseif old.type and old.type ~= BUTTON then
                local o = old.value
                old.value = value
                hook:Call("OnConfigChanged", steps, o, value)
            end
            return true
        end
        reg[final] = value
        hook:Call("OnConfigChanged", steps, old, value)
        return true
    end

    -- Habbit, fuck off.
    function config:GetTable()
        return self.registry
    end
end

-- GUI
do
    -- WholeCream's Drawing Library to GUI Library
    -- Extremely versatile and object oriented!
    local hook = BBOT.hook
    local draw = BBOT.draw
    local math = BBOT.math
    local mouse = BBOT.service:GetService("Mouse")
    local log = BBOT.log
    local gui = {
        registry = {}, -- contains all gui objects
        classes = {}
    }
    BBOT.gui = gui
    
    do
        local base = {}
        gui.base = base

        function base:Init()
            self.background_outline = self:Cache(draw:BoxOutline(0, 0, 0, 0, 6, Color3.fromRGB(21, 21, 21)))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, Color3.fromRGB(34, 34, 34)))
            self:Calculate()
        end
    
        function base:SetPos(xs, xo, ys, yo)
            if typeof(xs) == "UDim2" then
                self.pos = xs
            else
                self.pos = UDim2.new(xs, xo, ys, yo)
            end
            self:Calculate()
        end
    
        function base:SetSize(ws, wo, hs, ho)
            if typeof(ws) == "UDim2" then
                self.size = ws
            else
                self.size = UDim2.new(ws, wo, hs, ho)
            end
            self:Calculate()
        end

        function base:SetSizeConstraint(type)
            self.sizeconstraint = type
        end
    
        function base:GetPos()
            return self.pos
        end
    
        function base:PerformLayout(pos, size)
            self.background_outline.Position = pos
            self.background.Position = pos
            self.background_outline.Size = size
            self.background.Size = size
        end

        function base:Center()
            self:SetPos(.5, -self.absolutesize.X/2, .5, -self.absolutesize.Y/2)
        end
    
        local camera = BBOT.service:GetService("CurrentCamera")
        function base:GetLocalTranslation()
            local ppos, psize = (self.parent and self.parent.absolutepos or Vector2.new()), (self.parent and self.parent.absolutesize or camera.ViewportSize)

            local X = self.pos.X.Offset + (self.pos.X.Scale * psize.X)
            local Y = self.pos.Y.Offset + (self.pos.Y.Scale * psize.Y)
            local W = self.size.X.Offset + (self.size.X.Scale * psize.X)
            local H = self.size.Y.Offset + (self.size.Y.Scale * psize.Y)

            if self.sizeconstraint == "Y" and W > H then
                W = H
            elseif self.sizeconstraint == "X" and H > W then
                H = W
            end

            return Vector2.new(X, Y), Vector2.new(W, H)
        end

        function base:Calculate()
            local ppos = (self.parent and self.parent.absolutepos or Vector2.new())
            local pos, size = self:GetLocalTranslation()
            self.absolutepos = pos + ppos
            self.absolutesize = size
            self:PerformLayout(self.absolutepos, size)
            self._zindex = (self.parent and self.parent._zindex + self.zindex or self.zindex)

            local cache = self.objects
            for i=1, #cache do
                local v = cache[i]
                if draw:IsValid(v) then
                    v.ZIndex = self._zindex
                end
            end

            local children = self.children
            for i=1, #children do
                local v = children[i]
                if v.Calculate then
                    v:Calculate()
                end
            end
        end

        function base:SetParent(object)
            if not object and self.parent then
                local parent_children = self.parent.children
                self.parent = nil
                local c=0
                for i=1, #parent_children do
                    local v = parent_children[i-c]
                    if v == object then
                        table.remove(parent_children, i-c)
                        c=c+1
                    end
                end
            else
                self.parent = object
                local parent_children = self.parent.children
                parent_children[#parent_children+1] = self
                local c=0
                for i=1, #parent_children do
                    local v = parent_children[i-c]
                    if v.parent ~= object then
                        table.remove(parent_children, i-c)
                        c=c+1
                    end
                end
            end
            self:Calculate()
        end

        function base:RecursiveToNumeric(children, destination)
            for i=1, #children do
                local v = children[i]
                if v.children and #v.children > 0 then
                    self:RecursiveToNumeric(children, destination)
                end
                destination[#destination+1] = v
            end
        end

        function base:IsHovering()
            return self.ishovering == true
        end

        function base:OnMouseEnter() end
        function base:OnMouseExit() end

        function base:_Step() end

        function base:PreStep() end
        function base:Step() end
        function base:PostStep() end
        function base:PreRemove() end
        function base:PostRemove() end
        function base:PreDestroy() end
        function base:PostDestroy() end
        function base:Cache(object)
            self.objects[#self.objects+1] = object
            object.ZIndex = self._zindex
            return object
        end
        function base:Destroy()
            self:PreDestroy()
            local objects = self.objects
            while true do
                local v = objects[1]
                if not v then break end
                if v and type(v) ~= "number" and v.__OBJECT_EXISTS then
                    v:Remove()
                end
                table.remove(objects, 1)
            end
            self:PostDestroy()
        end
        function base:Remove()
            self:PreRemove()
            self:Destroy()
            local reg = gui.registry
            for i=1, #reg do
                local v = reg[i]
                if v.uid == self.uid then
                    table.remove(reg, i)
                    break
                end
            end
            local children = self.children
            for i=1, #children do
                local v = children[i]
                if v.Remove then
                    v:Remove()
                end
            end
            self:PostRemove()
            self.__INVALID = true
        end
        function base:SetTransparency(t)
            local parent_transparency = (self.parent and self.parent.transparency or 0)
            for i=1, #self.objects do
                local v = self.objects[i]
                v.Transparency = (v.Transparency/self.transparency) * math.clamp(t + parent_transparency, 0, 1)
            end
            self.transparency = t
            local children = self.children
            for i=1, #children do
                local v = children[i]
                if v.SetTransparency then
                    v:SetTransparency(t)
                end
            end
        end
        function base:GetAbsoluteZIndex() -- the true zindex of the rendering objects
            return self._zindex
        end
        function base:GetZIndex() -- get the zindex duhh
            return self.zindex
        end
        function base:SetZIndex(index) -- sets both the mouse, keyboard and rendering zindex
            self.zindex = index -- This controls both mouse inputs and rendering
            self:Calculate() -- Re-calculate ZIndex for drawings in cache
        end
    end

    function gui:Register(tbl, class, base)
        base = (base and self.classes[base] or self.base)
        if not base then base = self.base end
        setmetatable(tbl, {__index = base})
        tbl.class = class
        self.classes[class] = tbl
    end

    local uid = 0
    function gui:Create(class, parent)
        local struct = {
            uid = uid,
            objects = {},
            parent = parent,
            children = {},
            isgui = true,
            mouseinputs = true,
            class = class,

            active = true,
            visible = true,
            transparency = 0,
            zindex = 1,
            _zindex = 1,
            pos = UDim2.new(),
            absolutepos = Vector2.new(),
            size = UDim2.new(),
            absolutesize = Vector2.new(),
        }
        uid = uid + 1
        setmetatable(struct, {
            __index = self.classes[class],
            __tostring = function(self)
                return "GUI: " .. self.class .. "-" .. self.uid
            end
        })
        self.registry[#self.registry+1] = struct
        if struct.Init then
            struct:Init()
        end
        if parent then
            struct:SetParent(parent)
        end
        return struct
    end

    local ScheduledObjects = {}

    function gui:IsInAnimation(object)
        for i=1, #ScheduledObjects do
            local v = ScheduledObjects[i]
            if v.object == object then
                return true, v.type
            end
        end
    end

    do
        local function positioningfunc(data, fraction)
            local diff = data.target - data.origin
            local XDim = diff.X
            local YDim = diff.Y
            data.object:SetPos(data.origin + UDim2.new(XDim.Scale * fraction, XDim.Offset * fraction, YDim.Scale * fraction, YDim.Offset * fraction))
        end

        function gui:MoveTo(object, pos, length, delay, ease, callback)
            for i=1, #ScheduledObjects do
                local v = ScheduledObjects[i]
                if v.type == "MoveTo" and v.object == object then
                    table.remove(ScheduledObjects, i)
                    break
                end
            end

            ScheduledObjects[#ScheduledObjects+1] = {
                object = object,
                type = "MoveTo",

                starttime = tick()+delay,
                endtime = tick()+delay+length,

                origin = object.pos,
                target = pos,

                ease = ease or 1,
                callback = callback,
                step = positioningfunc
            }
        end
    end

    do
        local function scalingfunc(data, fraction)
            local diff = data.target - data.origin
            local XDim = diff.X
            local YDim = diff.Y
            data.object:SetSize(data.origin + UDim2.new(XDim.Scale * fraction, XDim.Offset * fraction, YDim.Scale * fraction, YDim.Offset * fraction))
        end

        function gui:SizeTo(object, size, length, delay, ease, callback)
            for i=1, #ScheduledObjects do
                local v = ScheduledObjects[i]
                if v.type == "SizeTo" and v.object == object then
                    table.remove(ScheduledObjects, i)
                    break
                end
            end

            ScheduledObjects[#ScheduledObjects+1] = {
                object = object,
                type = "SizeTo",

                starttime = tick()+delay,
                endtime = tick()+delay+length,

                origin = object.size,
                target = size,

                ease = ease or 1,
                callback = callback,
                step = scalingfunc
            }
        end
    end

    hook:Add("RenderStep.First", "BBOT:GUI.Animation", function()
        local c = 0
        for a = 1, #ScheduledObjects do
            local i = a-c
            local data = ScheduledObjects[i]
            if not data.object then
                table.remove(ScheduledObjects, i)
                c = c + 1
            elseif tick() >= data.starttime then
                local fraction = math.timefraction( data.starttime, data.endtime, tick() )
                if fraction > 1 then fraction = 1 elseif fraction < 0 then fraction = 0 end

                if data.step then
                    local frac = fraction ^ data.ease
                    if ( data.ease < 0 ) then
                        frac = fraction ^ ( 1.0 - ( ( fraction - 0.5 ) ) )
                    elseif ( data.ease > 0 and data.ease < 1 ) then
                        frac = 1 - ( ( 1 - fraction ) ^ ( 1 / data.ease ) )
                    end
    
                    data.step( data, frac )
                end

                if fraction == 1 then
                    table.remove(ScheduledObjects, i)
                    c = c + 1

                    if data.callback then
                        data.callback(data.object)
                    end
                end
            end
        end
    end)

    function gui:IsHovering(object)
        if not object.active then return end
        return mouse.X > object.absolutepos.X and mouse.X < object.absolutepos.X + object.absolutesize.X and mouse.Y > object.absolutepos.Y - 36 and mouse.Y < object.absolutepos.Y + object.absolutesize.Y - 36
    end

    hook:Add("RenderStepped", "BBOT:GUI.Hovering", function()
        local reg = gui.registry
        local inhover = {}
        for i=1, #reg do
            local v = reg[i]
            if v.mouseinputs and gui:IsHovering(v) then
                inhover[#inhover+1] = v
            end
        end
        
        table.sort(inhover, function(a, b) return a._zindex > b._zindex end)

        local result = inhover[1]
        if result ~= gui.hovering then
            if gui.hovering then
                gui.hovering.ishovering = false
                if gui.hovering.OnMouseExit then
                    gui.hovering:OnMouseExit(mouse.X, mouse.Y)
                end
            end
            gui.hovering = result
            if gui.hovering then
                gui.hovering.ishovering = true
                if gui.hovering.OnMouseEnter then
                    gui.hovering:OnMouseEnter(mouse.X, mouse.Y)
                end
            end
        end
    end)

    hook:Add("Camera.ViewportChanged", "BBOT:GUI.Transform", function()
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if v.active then
                v:Calculate()
            end
        end
    end)

    hook:Add("RenderStepped", "BBOT:GUI.Render", function()
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if v.active then
                v:_Step()
                if v.PreStep then
                    v:PreStep()
                end
                if v.Step then
                    v:Step()
                end
                if v.PostStep then
                    v:PostStep()
                end
            end
        end
    end)

    hook:Add("InputBegan", "BBOT:GUI.Input", function(input)
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if v.active then
                if v.InputBegan then
                    v:InputBegan(input)
                end
            end
        end
    end)

    hook:Add("InputEnded", "BBOT:GUI.Input", function(input)
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if v.active then
                if v.InputEnded then
                    v:InputEnded(input)
                end
            end
        end
    end)
end

-- Menu
do
    -- Menu Instructions is reponsible for the setup and configuration of all menus
    local hook = BBOT.hook
    local gui = BBOT.gui
    local color = BBOT.color
    local table = BBOT.table
    local timer = BBOT.timer
    local thread = BBOT.thread
    local draw = BBOT.draw
    local log = BBOT.log
    local config = BBOT.config

    local menu = {}
    BBOT.menu = menu

    do
        local GUI = {}
        function GUI:Init() end
        function GUI:PerformLayout(ppos, psize) end
        gui:Register(GUI, "Container")
    end

    do
        local GUI = {}

        function GUI:Init()
            if gui.mouse then
                gui.mouse:Remove()
            end
            gui.mouse = self
            self.mouse_mode = "normal"
            self:SetupMouse()
            self:SetZIndex(10000)
            self.mouseinputs = false -- wat
        end

        function GUI:SetupMouse()
            local pos = self.absolutepos
            -- cache is a garbage collector for the draw library
            if self.mouse_mode == "selectable" then
                self.mouse = self:Cache(draw:Box(-6,-6, 8, 8, 0, { 127, 72, 163, 255 }))
                self.mouse_outline = self:Cache(draw:BoxOutline(-6,-6, 8, 8, 1.1, { 0, 0, 0, 255 }))
            else
                self.mouse = self:Cache(draw:Triangle(
                    { pos.X, pos.Y },
                    { pos.X, pos.Y + 15 },
                    { pos.X + 10, pos.Y + 10 },
                    { 127, 72, 163, 255 },
                    true
                ))
                self.mouse_outline = self:Cache(draw:Triangle(
                    { pos.X, pos.Y },
                    { pos.X, pos.Y + 15 },
                    { pos.X + 10, pos.Y + 10 },
                    { 0, 0, 0, 255 },
                    false
                ))
            end
        end
    
        local inputservce = BBOT.service:GetService("UserInputService")
        function GUI:SetVisible(bool)
            -- Do we want the mouse to be visible?
            self.active = bool -- changing this will determine if it would be in calculation
            self.mouse.Visible = bool
            self.mouse_outline.Visible = bool
        end

        function GUI:SetMode(mode)
            self.mouse_mode = mode
            self:Destroy()
            self:SetupMouse()
            self:Calculate()
        end

        do
            local offset = Vector2.new(0,36)
            local selectable = Vector2.new(6,6)
            local pointa, pointb, pointc = Vector2.new(0, 0), Vector2.new(0, 15), Vector2.new(10, 10)
            function GUI:PerformLayout(pos, size)
                -- Calculate position and size changes here
                local mouse = self.mouse
                local mouse_outline = self.mouse_outline
                if self.mouse_mode == "selectable" then
                    mouse.Position = pos - selectable + offset
                    mouse_outline.Position = pos - selectable + offset
                else
                    mouse.PointA = pos + pointa + offset
                    mouse.PointB = pos + pointb + offset
                    mouse.PointC = pos + pointc + offset
                    local mouse_outline = self.mouse_outline
                    mouse_outline.PointA = mouse.PointA
                    mouse_outline.PointB = mouse.PointB
                    mouse_outline.PointC = mouse.PointC
                end
            end
        end

        local mouse = BBOT.service:GetService("Mouse")
        function GUI:Step()
            -- Step is equivilant to RenderStepped
            self.pos = UDim2.new(0, mouse.X, 0, mouse.Y)
            inputservce.MouseIconEnabled = not self.active

            -- Calling calculate will call performlayout & calculate parented GUI objects
            self:Calculate()
        end

        -- Register this as a generatable object
        gui:Register(GUI, "Mouse")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_outline = self:Cache(draw:BoxOutline(0, 0, 0, 0, 6, Color3.fromRGB(20, 20, 20)))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, Color3.fromRGB(35, 35, 35)))
            self.asthetic_line = self:Cache(draw:Box(0, 0, 0, 2, 0, Color3.fromRGB(127, 72, 163)))
            self.asthetic_line_alignment = "Top"

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, 1)
            self.gradient:SetSize(1, 0, 0, 20)
            self.gradient:Generate()

            self.sizablearearight = self:Cache(draw:Box(0, 0, 2, 6, 0, Color3.fromRGB(20, 20, 20), nil, false))
            self.sizableareabottom = self:Cache(draw:Box(0, 0, 6, 2, 0, Color3.fromRGB(20, 20, 20), nil, false))

            self.draggable = false
            self.sizable = false
            self.mouseinputs = true

            self:Calculate()
        end
        
        function GUI:AstheticLineAlignment(alignment)
            self.asthetic_line_alignment = alignment
            self:Calculate()
        end

        function GUI:PerformLayout(pos, size)
            self.background_outline.Position = pos
            self.background.Position = pos
            if self.asthetic_line_alignment == "Top" then
                self.asthetic_line.Position = pos
            else
                self.asthetic_line.Position = pos + Vector2.new(0,size.Y-2)
            end
            self.sizablearearight.Position = pos + size - Vector2.new(2, 6)
            self.sizableareabottom.Position = pos + size - Vector2.new(6, 2)
            self.background_outline.Size = size
            self.background.Size = size
            self.asthetic_line.Size = Vector2.new(size.X, 2)
        end

        function GUI:SetDraggable(bool)
            self.draggable = bool
        end

        function GUI:SetSizable(bool)
            self.sizable = bool
            self.sizablearearight.Visible = bool
            self.sizableareabottom.Visible = bool
        end

        local mouse = BBOT.service:GetService("Mouse")
        function GUI:InputBegan(input)
            if self.draggable and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                local mousepos = Vector2.new(mouse.X, mouse.Y)
                self.dragging = mousepos
                self.dragging_origin = self:GetLocalTranslation()
            end
        end

        local camera = BBOT.service:GetService("CurrentCamera")
        function GUI:Step()
            if self.dragging then
                local pos = (self.dragging_origin - self.dragging) + Vector2.new(mouse.X, mouse.Y)
                local parent = self.parent
                local X, Y = pos.X, pos.Y
                X = math.max(X, 0)
                Y = math.max(Y, 0)
                local xs, ys = self.pos.X.Scale, self.pos.Y.Scale
                if parent then
                    X = math.min(X+self.absolutesize.X, parent.absolutesize.X)-self.absolutesize.X
                    Y = math.min(Y+self.absolutesize.Y, parent.absolutesize.Y)-self.absolutesize.Y
                    self:SetPos(xs, X - (xs * parent.absolutesize.X), ys, Y - (ys * parent.absolutesize.Y))
                else
                    X = math.min(X+self.absolutesize.X, camera.ViewportSize.X)-self.absolutesize.X
                    Y = math.min(Y+self.absolutesize.Y, camera.ViewportSize.Y)-self.absolutesize.Y
                    self:SetPos(xs, X - (xs * camera.ViewportSize.X), ys, Y - (ys * camera.ViewportSize.Y))
                end
            end

            if self.resizing then
                local pos = Vector2.new(mouse.X, mouse.Y)-self.resizing
                self:SetSize(pos.X, pos.Y)
            end
        end

        function GUI:InputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self.dragging then
                self.dragging = nil
            end
        end

        function GUI:OnMouseEnter(x, y)
        end

        function GUI:OnMouseExit(x, y)
        end

        gui:Register(GUI, "Panel")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.container = {}
            self.color1 = Color3.fromRGB(50,50,50)
            self.color2 = Color3.fromRGB(35,35,35)
            self.mouseinputs = false
        end

        function GUI:Color(startc, endc)
            self.color1 = startc
            self.color2 = endc
        end

        function GUI:Generate()
            if #self.container > 0 then
                self:Destroy()
            end
            for i = 0, self.absolutesize.Y-1 do
                local object = self:Cache(draw:Box(0, i, self.absolutesize.X, 1, 0, self.color1))
                object.Color = color.range(i, {{start = 0, color = self.color1}, {start = 20, color = self.color2}})
                self.container[#self.container+1] = object
            end
            self.rendersize = self.absolutesize.Y
            self:Calculate()
        end

        function GUI:PreDestroy()
            self.container = {}
        end

        function GUI:PerformLayout(pos, size)
            local container = self.container
            for i=1, #container do
                local v = container[i]
                v.Position = Vector2.new(0, i) + pos
                v.Size = Vector2.new(size.X, 1)
                if self.parent then
                    if i > self.parent.absolutesize.Y then
                        v.Visible = false
                    else
                        v.Visible = true
                    end
                end
            end
        end

        gui:Register(GUI, "Gradient")
    end

    do 
        local GUI = {}

        function GUI:Init()
            self.text = self:Cache(draw:TextOutlined("", 2, 0, 0, 14, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)))
            self.content = ""
            self.textsize = 16
            self.font = 2
            self.mouseinputs = false
        end

        function GUI:SetFont(font)
            self.text.Font = font
            self.font = font
        end

        function GUI:GetText()
            return self.content
        end

        function GUI:SetText(txt)
            self.text.Text = txt
            self.content = txt
        end

        function GUI:SetTextSize(size)
            self.text.Size = size
            self.textsize = size
        end

        function GUI:PerformLayout(pos, size)
            self.text.Position = pos
            local x = self:GetTextSize(self.content)
            local pos = self:GetLocalTranslation()
            local size = self.parent.absolutesize
            if x - pos.X > size.X then
                local text = ""
                for i=1, #self.content do
                    local v = string.sub(self.content, i, i)
                    local pretext = text .. v
                    local prex = self:GetTextSize(pretext)
                    if prex - pos.X > size.X then
                        break 
                    end
                    text = pretext 
                end
                self.text.Text = text
            end
        end

        function GUI:GetTextSize(text)
            text = text or self.content
            local x, y = self:GetTextScale()
            return (#text)*x, y
        end

        function GUI:GetTextScale() -- This is a guessing game, not aproximation
            return (self.textsize/2)+(self.textsize/4), (self.textsize/2)+(self.textsize/4)
        end

        gui:Register(GUI, "Text")
    end

    do
        do -- key binds
            menu.enums = {}
            local enums = Enum.KeyCode:GetEnumItems()
            local enumstable, enumtoID, IDtoenum = {}, {}, {}
            for k, v in table.sortedpairs(enums) do
                local keyname = string.sub(tostring(v), 14)
                if not string.find( keyname, "World", 1, true ) then
                    enumstable[#enumstable+1] = keyname
                    enumtoID[keyname] = v
                    IDtoenum[v] = keyname
                end
            end

            enumstable[#enumstable+1] = "MouseButton1"
            enumtoID["MouseButton1"] = Enum.UserInputType.MouseButton1
            IDtoenum[Enum.UserInputType.MouseButton1] = "MouseButton1"
            enumstable[#enumstable+1] = "MouseButton2"
            enumtoID["MouseButton2"] = Enum.UserInputType.MouseButton2
            IDtoenum[Enum.UserInputType.MouseButton2] = "MouseButton2"
            menu.enums.KeyCode = {
                inverseId = IDtoenum,
                Id = enumtoID,
                List = enumstable
            }
        end

        local GUI = {}

        function GUI:Init()
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, Color3.fromRGB(35, 35, 35)))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 2, 0, 2)
            self.gradient:SetSize(1, -4, 0, 20)
            self.gradient:Generate()

            self.whitelist = {}
            for i=string.byte('A'), string.byte('Z') do
                self.whitelist[string.char(i)] = true
            end
            for i=string.byte('1'), string.byte('9') do
                self.whitelist[string.char(i)] = true
            end
            self.text = self:Cache(draw:TextOutlined("", 2, 3, 3, 16, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)))
            self.content = ""
            self.content_position = 1 -- I like scrolling text
            self.textsize = 16
            self.font = 2

            self.cursor_outline = self:Cache(draw:BoxOutline(0, 0, 1, self.textsize, 4, Color3.fromRGB(20, 20, 20)))
            self.cursor = self:Cache(draw:BoxOutline(0, 0, 1, self.textsize, 0, Color3.fromRGB(255,255,255), 0))
            self.cursor_position = 1

            self.background_outline = self:Cache(draw:BoxOutline(0, 0, 0, 0, 2, Color3.fromRGB(20, 20, 20)))

            self.editable = true
            self.highlightable = true
            self.mouseinputs = true

            self.input_repeater_start = 0
            self.input_repeater_key = nil
            self.input_repeater_delay = 0
        end

        local mouse = BBOT.service:GetService("Mouse")
        function GUI:ProcessClipping()
            local text = self:AutoTruncate()
            self.text.Text = text
        end

        function GUI:AutoTruncate()
            local position = self.content_position
            local w = self:GetTextSize(self.content)
            local pos, size = self:GetLocalTranslation()
            local scalew = self:GetTextScale()
            if pos.X + w > size.X then
                local text = ""
                for i=position, #self.content do
                    local v = string.sub(self.content, i, i)
                    local pretext = text .. v
                    local prew = self:GetTextSize(pretext)
                    if prew - (position*scalew) - pos.X - 6 > size.X then
                        break 
                    end
                    text = pretext 
                end
                return text, position
            end
            return self.content, 0
        end

        function GUI:DetermineTextCursorPosition(X)
            local text, offset = self:AutoTruncate()
            local pre, post = "", ""
            for i=1, #text do
                post = post .. string.sub(text, i, i)
                local min = self:GetTextSize(pre)
                min = min + 3
                local max = self:GetTextSize(post)
                max = max + 3

                if X >= min and X <= max then
                    return offset + i
                end
                pre = post
            end
            return offset + #text
        end

        function GUI:PerformLayout(pos, size)
            self.text.Position = pos + Vector2.new(3, 3)
            self.background_outline.Position = pos
            self.background.Position = pos
            self.background_outline.Size = size
            self.background.Size = size
            self:ProcessClipping()
        end

        function GUI:OnTextChanged(old, new)

        end

        function GUI:SetEditable(bool)
            self.editable = bool
            if not bool then
                self.editing = nil
                self.cursor.Transparency = 0
                self.cursor_outline.Transparency = 0
            end
        end

        function GUI:OnMouseEnter(x, y)
        end

        function GUI:OnMouseExit(x, y)
        end

        local inputservice = BBOT.service:GetService("UserInputService")
        function GUI:ProcessInput(text, keycode)
            local cursorpos = self.cursor_position
            local rtext = string.sub(text, cursorpos+1)
            local ltext = string.sub(text, 1, cursorpos)
            local set = false
            local enums = menu.enums.KeyCode
            if keycode == Enum.KeyCode.Backspace then
                ltext = string.sub(ltext, 0, #ltext - 1)
                set = true
            elseif keycode == Enum.KeyCode.Space then
                ltext ..= " "
                set = true
            elseif enums.inverseId[keycode] and self.whitelist[enums.inverseId[keycode]] then
                local key = enums.inverseId[keycode]
                if not inputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                    key = string.lower(key)
                end
                ltext ..= key
                set = true
            end
            text = ltext .. rtext
            return text, set, ltext
        end

        function GUI:DetermineFittable()
            local w = self:GetTextScale()
            return math.round(self.absolutesize.X/w)
        end

        function GUI:InputBegan(input)
            if not self.editable or not self.active then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.editing = true
                self.cursor_position = self:DetermineTextCursorPosition(mouse.X - self.absolutepos.X)
            elseif self.editing then
                if input.UserInputType == Enum.UserInputType.MouseButton1 and (not self:IsHovering() or (input.UserInputType == Enum.UserInputType.Keyboard and input.UserInputType == Enum.KeyCode.Return)) then
                    self.editing = nil
                    self.cursor_outline.Transparency = 0
                    self.cursor.Transparency = 0
                elseif input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode == Enum.KeyCode.Left then
                        self.cursor_position -= 1
                        if self.cursor_position < 0 then
                            self.cursor_position = 0
                        end
                        self.input_repeater_start = tick() + .5
                        self.input_repeater_key = input.KeyCode
                    elseif input.KeyCode == Enum.KeyCode.Right then
                        self.cursor_position += 1
                        if self.cursor_position > #self.content then
                            self.cursor_position -= 1
                        end
                        self.input_repeater_start = tick() + .5
                        self.input_repeater_key = input.KeyCode
                    else
                        local current_text = self:GetText()
                        local original_text = current_text
                        local new_text, success, ltext = self:ProcessInput(current_text, input.KeyCode)
                        if success then
                            self.input_repeater_start = tick() + .5
                            self.input_repeater_key = input.KeyCode
                            self:SetText(new_text)
                            self:OnTextChanged(original_text, new_text)
                            self.cursor_position = #ltext
                        end
                    end

                    local fittable = self:DetermineFittable()
                    if self.cursor_position < 4 then
                        self.content_position = 1
                    elseif self.cursor_position > self.content_position-1 + fittable then
                        self.content_position = self.cursor_position+1 - fittable
                    elseif self.cursor_position-3 < self.content_position-1 then
                        self.content_position = self.cursor_position+1-3
                    end
                    if self.content_position < 1 then
                        self.content_position = 1
                    end
                    self:ProcessClipping()
                end
            end
        end

        function GUI:InputEnded(input)
            if self.editing and input.UserInputType == Enum.UserInputType.Keyboard then
                if self.input_repeater_key == input.KeyCode then
                    self.input_repeater_key = nil
                end
            end
        end

        function GUI:Step()
            if self.editing then
                local t = tick()
                local wscale = self:GetTextScale()
                self.cursor.Transparency = math.sin(t * 8)
                self.cursor.Position = self.absolutepos + Vector2.new((self.cursor_position-(self.content_position-1))*wscale+1, 3)
                self.cursor_outline.Transparency = self.cursor.Transparency
                self.cursor_outline.Position = self.cursor.Position
                if self.input_repeater_key and self.input_repeater_start < t then
                    if self.input_repeater_delay < t then
                        self.input_repeater_delay = t + .025
                        if self.input_repeater_key == Enum.KeyCode.Left then
                            self.cursor_position -= 1
                            if self.cursor_position < 0 then
                                self.cursor_position = 0
                            end
                        elseif self.input_repeater_key == Enum.KeyCode.Right then
                            self.cursor_position += 1
                            if self.cursor_position > #self.content then
                                self.cursor_position -= 1
                            end
                        else
                            local current_text = self:GetText()
                            local original_text = current_text
                            local new_text, success, ltext = self:ProcessInput(current_text, self.input_repeater_key)
                            if success then
                                self:SetText(new_text)
                                self:OnTextChanged(original_text, new_text)
                                self.cursor_position = #ltext
                            end
                        end
                        local fittable = self:DetermineFittable()
                        if self.cursor_position < 4 then
                            self.content_position = 1
                        elseif self.cursor_position > self.content_position-1 + fittable then
                            self.content_position = self.cursor_position+1 - fittable
                        elseif self.cursor_position-3 < self.content_position-1 then
                            self.content_position = self.cursor_position+1-3
                        end
                        if self.content_position < 1 then
                            self.content_position = 1
                        end
                        self:ProcessClipping()
                    end
                end
            end
        end

        gui:Register(GUI, "TextEntry", "Text")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, Color3.fromRGB(35, 35, 35)))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 2, 0, 2)
            self.gradient:SetSize(1, -4, 0, 20)
            self.gradient:Generate()

            self.text = self:Cache(draw:TextOutlined("", 2, 3, 3, 16, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)))
            self.textsize = 16
            self.font = 2

            self.dropicon = self:Cache(draw:TextOutlined("-", 2, 3, 3, 16, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)))
            self.background_outline = self:Cache(draw:BoxOutline(0, 0, 0, 0, 2, Color3.fromRGB(20, 20, 20)))
            self.mouseinputs = true

            self.options = {}
            self.option = ""
        end

        function GUI:GetOption(txt)
            return self.option
        end

        function GUI:SetOption(txt)
            self.text.Text = text
            self.option = text
        end

        function GUI:AddOption(txt)
            self.options[#self.options+1] = txt
        end

        function GUI:PerformLayout(pos, size)
            self.text.Position = pos + Vector2.new(3, 3)
            self.dropicon.Position = pos + Vector2.new(size.X - 16 - 4, 3)
            self.background_outline.Position = pos
            self.background.Position = pos
            self.background_outline.Size = size
            self.background.Size = size
        end

        function GUI:OnSelect() end

        function GUI:Open()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
            local box = gui:Create("DropBoxSelection", self)
            self.selection = box
            box:SetPos(0,0,0,0)
            box:SetSize(1,0,0,(#self.options * self.textsize))
            box:SetOptions(self.options)
            function box.OnSelect(s, row)
                self.option = row
                self:OnSelect(row)
                self:Close()
            end
            box:Generate()
        end

        function GUI:Close()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
        end

        function GUI:InputBegan(input)
            if not self.active then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.open = true
                self:Open()
            elseif self.open and (not self.selection or not self.selection:IsHovering()) then
                self.open = false
                self:Close()
            end
        end

        gui:Register(GUI, "DropBox")
    end

    do 
        local GUI = {}

        function GUI:Init()

        end

        function GUI:PerformLayout(pos, size)

        end

        gui:Register(GUI, "MultiBox")
    end

    do
        local GUI = {}

        function GUI:Init()
        end

        function GUI:SetImage(img)
            self.image = self:Cache(draw:Image(img, 0, 0, 0, 0))
            self:Calculate()
        end

        function GUI:PerformLayout(pos, size)
            if self.image and draw:IsValid(self.image) then
                self.image.Position = pos
                self.image.Size = size
            end
        end

        gui:Register(GUI, "Image")
    end

    do
        local GUI = {}

        function GUI:Init()

        end

        function GUI:PerformLayout()

        end

        function GUI:InputBegan(input)
            if not self.active then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.panel:SetTransparency(1)
            end
        end

        gui:Register(GUI, "Tab")

        local GUI = {}

        function GUI:Init()
            local container = gui:Create("Container", self)
            container:SetPos(0,0,0,20)
            container:SetSize(1,0,1,-20)
            self.container = container

            local tablist = gui:Create("Container", self)
            tablist:SetPos(0,0,0,0)
            tablist:SetSize(1,0,0,20)
            self.tablist = tablist

            self.registry = {}
        end

        function GUI:PerformLayout(pos, size)

        end

        function GUI:Add(name, object)
            object:SetParent(self.container)
            local tab = gui:Create("Tab", self.tablist)
            tab:SetText(name)
            tab:SetPanel(object)
            local r = self.registry
            r[#r+1] = {tab, object}
            local l = #r
            for i=1, l do
                local v = r[i]
                v:SetSize(1/l,0,0,20)
                v:SetPos((1/l)*i,0,0,0)
            end
            return tab
        end

        gui:Register(GUI, "Tabs")
    end

    local camera = BBOT.service:GetService("CurrentCamera")

    menu.images = {}
    thread:CreateMulti({
        function()
            menu.images[1] = game:HttpGet("https://i.imgur.com/9NMuFcQ.png")
        end,
        function()
            menu.images[2] = game:HttpGet("https://i.imgur.com/jG3NjxN.png")
        end,
        function()
            menu.images[3] = game:HttpGet("https://i.imgur.com/2Ty4u2O.png")
        end,
        function()
            menu.images[4] = game:HttpGet("https://i.imgur.com/kNGuTlj.png")
        end,
        function()
            menu.images[5] = game:HttpGet("https://i.imgur.com/OZUR3EY.png")
        end,
        function()
            menu.images[6] = game:HttpGet("https://i.imgur.com/3HGuyVa.png")
        end,
        function()
            menu.images[7] = game:HttpGet("https://i.imgur.com/H7otBZX.png")
        end,
        function()
            menu.images[8] = game:HttpGet("https://i.imgur.com/qH0WziT.png")
        end
    })

    local loaded = {}
    do
        local function Loopy_Image_Checky()
            for i = 1, 7 do
                local v = menu.images[i]
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
    
    function menu:CreateOptions()

    end

    do
        local menu_generation = {
            ["Tabs"] = function(container, config)
                local name = config.name
                local frame = gui:Create("Panel", container)
                frame.Name = name
                if config.pos then
                    frame:SetPos(config.pos)
                end
                if config.size then
                    frame:SetSize(config.size)
                end
                local alias = gui:Create("Text", frame)
                frame.alias = alias
                alias:SetPos(0, 2, 0, 2)
                alias:SetText(name)

                local subcontainer = gui:Create("Panel", frame)
                frame.subcontainer = subcontainer
                subcontainer:SetPos(0, 0, 0, 6)
                subcontainer:SetSize(1, 0, 1, -12)

                return subcontainer
            end,
            ["Panel"] = function(container, config)
                local name = config.name
                local frame = gui:Create("Panel", container)
                frame.Name = name
                if config.pos then
                    frame:SetPos(config.pos)
                end
                if config.size then
                    frame:SetSize(config.size)
                end
                local alias = gui:Create("Text", frame)
                frame.alias = alias
                alias:SetPos(0, 2, 0, 2)
                alias:SetText(name)

                local subcontainer = gui:Create("Container", frame)
                frame.subcontainer = subcontainer
                subcontainer:SetPos(0, 0, 0, 6)
                subcontainer:SetSize(1, 0, 1, -12)

                return subcontainer
            end
        }

        function menu:HandleGeneration(container, configuration)
            for i=1, #configuration do
                local config = configuration[i]
                local type = config.type
                local subcontainer
                if menu_generation[type] then
                    subcontainer = menu_generation[type](container, config)
                end
                if config.content and subcontainer then
                    self:HandleGeneration(subcontainer, config.content)
                end
            end
        end
    end

    function menu:Initialize()
        local toolbar = gui:Create("Panel")
        gui.toolbar = toolbar
        toolbar:AstheticLineAlignment("Bottom")
        toolbar:SetSize(1, 0, 0, 0)
        gui:SizeTo(toolbar, UDim2.new(1, 0, 0, 30), 0.775, 0, 0.25)

        local image = gui:Create("Image", toolbar)
        image:SetImage(menu.images[8])
        image:SetPos(0, 2, 0, 2)
        image:SetSize(1, -2, 1, -2)
        image:SetSizeConstraint("Y")

        local intro = gui:Create("Panel")
        intro:SetSize(0, 0, 0, 0)
        intro:Center()

        do
            self.fw, self.fh = 100, 100

            local screensize = camera.ViewportSize
            local image = gui:Create("Image", intro)
            image:SetImage(menu.images[7])
            image:SetPos(0, 0, 0, 2)
            image:SetSize(1, 0, 1, -2)
            gui:SizeTo(intro, UDim2.new(0, self.fw, 0, self.fh), 0.775, 0, 0.25, function()
                gui:SizeTo(intro, UDim2.new(0, 0, 0, 0), 0.775, 0.5, 0.25, function()
                    image:Remove()
                    hook:Call("Menu.PreGenerate")
                    hook:Call("Menu.Generate")
                    hook:Call("Menu.PostGenerate")
                end)
            end)

            gui:MoveTo( intro, UDim2.new(.5, -self.fw/2, .5, -self.fh/2), 0.775, 0, 0.25, function()
                gui:MoveTo( intro, UDim2.new(.5, 0, .5, 0), 0.775, 0.5, 0.25)
            end)
        end

        hook:Add("Menu.PostGenerate", "BBOT:Menu.Mouse", function()
            self.mouse = gui:Create("Mouse")
            self.mouse:SetVisible(true)
        end)
    end

    --[[{
        activetab = 1
        name = "Bitch Bot",
        pos = UDim2.new(0, 520, 0, 100),
        size = UDim2.new(0, 500, 0, 600),
        center = true,
    },]]

    function menu:Create(configuration)
        local frame = gui:Create("Panel")
        frame.Id = configuration.Id
        if configuration.pos then
            frame:SetPos(configuration.pos)
        end
        if configuration.size then
            frame:SetSize(configuration.size)
        end
        if configuration.center then
            frame:Center()
        end
        frame:SetDraggable(true)

        local alias = gui:Create("Text", frame)
        frame.alias = alias
        alias:SetPos(0, 3, 0, 5)
        alias:SetText(configuration.name)

        local optionscontainer = gui:Create("Panel", frame)
        frame.optionscontainer = optionscontainer
        optionscontainer:SetPos(0, 10, 0, 10+20)
        optionscontainer:SetSize(1, -20, 1, -20-20)

        self:HandleGeneration(optionscontainer, configuration.content)
    end

    hook:Add("Menu.Generate", "BBOT:Menu.Main", function(frame)

        local setup_parameters = BBOT.configuration
        for i=1, #setup_parameters do
            menu:Create(setup_parameters[i])
        end
    end)

    hook:Add("Initialize", "BBOT:Menu", function()
        menu:Initialize()
    end)
end

BBOT.hook:CallP("PreInitialize")
BBOT.hook:CallP("Initialize")
BBOT.hook:CallP("PostInitialize")