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

    log.enums = {
        ["LOG_NORMAL"]=1,
        ["LOG_DEBUG"]=2,
        ["LOG_WARN"]=3,
        ["LOG_ERROR"]=4,
        ["LOG_ANON"]=5
    }

    for k, v in pairs(log.enums) do
        getfenv()[k] = v
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
            if type and log.types[type] then
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

-- for now
local function ISOLATION(BBOT)
local BBOT = BBOT
local loadstart = tick()

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
    local math = BBOT.math
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
    local hook = {
        registry = {},
        _registry_qa = {}
    }
    BBOT.hook = hook
    local log = BBOT.log
    function hook:Add(name, ident, func) -- Adds a function to a hook array
        local hooks = self.registry
        
        log(LOG_DEBUG, 'Added hook "' .. name .. '" with identity "' .. ident .. '"')

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

        log(LOG_DEBUG, 'Removed hook "' .. name .. '" with identity "' .. ident .. '"')

        hooks[name][ident] = nil
    
        local QA = {}
        for k, v in next, hooks[name] do
            QA[#QA+1] = {k, v}
        end
        self._registry_qa[name] = QA
    end
    function hook:Clear(name) -- Clears an entire array of hooks
        local hooks = self.registry

        log(LOG_DEBUG, 'Cleared hook "' .. name .. '" callbacks')

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
    local loop = {
        registry = {}
    }
    BBOT.loop = loop
    local log = BBOT.log
    local hook = BBOT.hook
    hook:Add("Unload", "KillLoops", function()
        log(LOG_DEBUG, "Purging old loops...")
        BBOT.loop:KillAll()
        log(LOG_DEBUG, "Done")
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

        log(LOG_DEBUG, 'Creating loop "' .. name .. '"')

        loops[name] = { }
        loops[name].Running = false
        loops[name].Destroy = false
        loops[name].Loop = coroutine.create(function(...)
            while true do
                if loops[name].Running then
                    local ran, err = xpcall(func, debug.traceback, ...)
                    if not ran then
                        loops[name].Destroy = true
                        log(LOG_ERROR, "Error in loop library - ", err)
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
        
        log(LOG_DEBUG, 'Running loop "' .. name .. '"')

        loops[name].Running = true
        local succ, out = coroutine.resume(loops[name].Loop)
        if not succ then
            warn("Loop: " .. tostring(name) .. " ERROR: " .. tostring(out))
        end
    end
    function loop:Stop(name)
        local loops = self.registry
        if loops[name] == nil then return end

        log(LOG_DEBUG, 'Stopping loop "' .. name .. '"')

        loops[name].Running = false
    end
    function loop:Remove(name)
        local loops = self.registry
        if loops[name] == nil then return end
        self:Stop(name)
        log(LOG_DEBUG, 'Removing loop "' .. name .. '"')
        loops[name].Destroy = true
        loops[name] = nil
    end
    function loop:GetTable()
        return self.registry
    end
end

-- Timers
do  
    local timer = {
        registry = {}
    }
    BBOT.timer = timer
    local loop = BBOT.loop
    local log = BBOT.log
    
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
            log(LOG_DEBUG, "Created timer '" .. ident .. "'")
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
                log(LOG_DEBUG, "Removed timer '" .. identifier .. "'")
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
                        log(LOG_ERROR, "Error in timer library! - ", errlog[1])
                        log(LOG_ANON, "Traceback,")
                        if #errlog > 1 then
                            for i=2, #errlog do
                                log(LOG_ANON, errlog[i])
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
                log(LOG_DEBUG, "Removed timer '" .. t.identifier .. "'")
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

    hook:Add("PreInitialize", "BBOT:ConfigSetup", function()
        config.storage_pathway = "bitchbot/" .. BBOT.game
        config.storage_main = "bitchbot"
        config.storage_extension = ".bb"

        if not isfolder(config.storage_pathway) then
            makefolder(config.storage_pathway)
        end

        if not isfolder(config.storage_main) then
            makefolder(config.storage_main)
        end
    end)

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
            local psize = (self.parent and self.parent.absolutesize or camera.ViewportSize)

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

            self._enabled = (self.parent and (not self.parent._enabled and false or self.enabled) or self.enabled)
            self._transparency = (self.parent and self.parent._transparency * self.transparency or self.transparency)
            self._zindex = (self.parent and self.parent._zindex + self.zindex or self.zindex)
            local cache = self.objects
            for i=1, #cache do
                local v = cache[i]
                if v[1] and draw:IsValid(v[1]) then
                    local drawing = v[1]
                    drawing.ZIndex = self._zindex
                    drawing.Transparency = v[2] * self._transparency
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
            local objects = self.objects
            for i=1, #objects do
                local v = objects[i]
                if v[1] == object then
                    v[2] = object.Transparency
                    return object
                end
            end
            self.objects[#self.objects+1] = {object, object.Transparency}
            object.ZIndex = self._zindex
            return object
        end
        function base:Destroy()
            self:PreDestroy()
            local objects = self.objects
            while true do
                local v = objects[1]
                if not v then break end
                v = v[1]
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
        function base:GetAbsoluteTransparency()
            return self._transparency
        end
        function base:GetTransparency()
            return self.transparency
        end
        function base:SetTransparency(t)
            self.transparency = t
            self:Calculate()
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
        function base:GetAbsoluteEnabled()
            return self._enabled
        end
        function base:GetEnabled()
            return self.enabled
        end
        function base:SetEnabled(bool)
            self.enabled = bool
            self:Calculate()
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

            enabled = true,
            _enabled = true,
            transparency = 1,
            _transparency = 1,
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
        if not object._enabled then return end
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
            if v._enabled then
                v:Calculate()
            end
        end
    end)

    hook:Add("RenderStepped", "BBOT:GUI.Render", function()
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if v._enabled then
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
            if v._enabled then
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
            if v._enabled then
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
        function GUI:Init()
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, Color3.fromRGB(35, 35, 35)))
            self.background.Visible = false
            self.mouseinputs = false
        end
        function GUI:PerformLayout(pos, size)
            self.background.Position = pos
            self.background.Size = size
        end
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
            self:SetZIndex(1000000)
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
            self:SetEnabled(bool)
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
            inputservce.MouseIconEnabled = not self._enabled

            -- Calling calculate will call performlayout & calculate parented GUI objects
            self:Calculate()
        end

        -- Register this as a generatable object
        gui:Register(GUI, "Mouse")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.asthetic_line = self:Cache(draw:Box(0, 0, 0, 2, 0, Color3.fromRGB(127, 72, 163)))
            self.mouseinputs = false
        end

        function GUI:PerformLayout(pos, size)
            self.asthetic_line.Position = pos
            self.asthetic_line.Size = size
        end

        gui:Register(GUI, "AstheticLine")
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

        function GUI:ShowAstheticLine(value)
            self.gradient:SetPos(0, 0, 0, (value and 1 or 0))
            self.asthetic_line.Visible = value
        end

        function GUI:ShowGradient(value)
            self.gradient:SetTransparency(value and 1 or 0)
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

            self.textalignmentx = Enum.TextXAlignment.Left
            self.textalignmenty = Enum.TextYAlignment.Top
        end

        function GUI:SetTextAlignmentX(align)
            self.textalignmentx = align
        end

        function GUI:SetTextAlignmentY(align)
            self.textalignmenty = align
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
            local offset_x, offset_y = 0, 0
            local w, h = self:GetTextSize(self.content)
            if self.textalignmentx == Enum.TextXAlignment.Center then
                offset_x = -w/2
            elseif self.textalignmentx == Enum.TextXAlignment.Right then
                offset_x = -w
            end

            if self.textalignmenty == Enum.TextYAlignment.Center then
                offset_y = -h/2
            elseif self.textalignmenty == Enum.TextYAlignment.Bottom then
                offset_y = -h
            end

            self.text.Position = pos + Vector2.new(offset_x, offset_y)
            --[[local x = self:GetTextSize(self.content)
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
            end]]
        end

        function GUI:GetTextSize(text)
            text = text or self.content
            local x, y = self:GetTextScale()
            return (#text*x)+(self.textsize/4), y+(self.textsize/4)
        end

        function GUI:GetTextScale() -- This is a guessing game, not aproximation
            return (self.textsize/2), (self.textsize/2)
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
            if not self.editable or not self._enabled then return end
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
            if not self._enabled then return end
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
            self.background_outline = self:Cache(draw:BoxOutline(0, 0, 0, 0, 6, Color3.fromRGB(20, 20, 20)))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, Color3.fromRGB(35, 35, 35)))
            self.mouseinputs = true

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, 0)
            self.gradient:SetSize(1, -3, 0, 20)
            self.gradient:Generate()

            self.text = gui:Create("Text", self)
            self.text:SetPos(.5, 0, .5, 0)
            self.text:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetText("")

            local darken = gui:Create("Container", self)
            darken:SetPos(0,0,0,0)
            darken:SetSize(1,0,1,0)
            darken.background.Visible = true
            darken.background.Transparency = .25
            darken.background.Color = Color3.new(0,0,0)
            darken:Cache(darken.background)
            self.darken = darken
        end

        function GUI:PerformLayout(pos, size)
            self.background_outline.Position = pos
            self.background.Position = pos
            self.background_outline.Size = size
            self.background.Size = size + (self.activated and Vector2.new(0,4) or Vector2.new())
        end

        function GUI:SetActive(value)
            self.activated = value
            self.darken.background.Visible = not value
            self:Calculate()
        end

        function GUI:SetText(text)
            self.content = text
            self.text:SetText(text)
        end

        function GUI:SetPanel(panel)
            self.panel = panel
        end

        function GUI:InputBegan(input)
            if not self._enabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.controller:SetActive(self.Id)
            end
        end

        gui:Register(GUI, "Tab")

        local GUI = {}

        function GUI:Init()
            self.background_outline = self:Cache(draw:BoxOutline(0, 0, 0, 0, 6, Color3.fromRGB(20, 20, 20)))

            local container = gui:Create("Panel", self)
            container:SetPos(0,0,0,42+2)
            container:SetSize(1,0,1,-42-2)
            container:ShowAstheticLine(false)
            container:ShowGradient(false)
            container.background_outline.Thickness = 0
            self.container = container

            local tablist = gui:Create("Panel", self)
            tablist:SetPos(0,0,0,2)
            tablist:SetSize(1,0,0,42-2)
            tablist:ShowAstheticLine(false)
            tablist.background_outline.Thickness = 0
            self.tablist = tablist

            local astheticline = gui:Create("AstheticLine", self)
            astheticline:SetSize(1, 0, 0, 2)
            astheticline:SetZIndex(2)

            self.registry = {}
            self.activeId = 0

            for i=1, math.random(2,5) do
                local basic = gui:Create("Panel")
                basic:SetPos(0,2,0,2)
                basic:SetSize(0,math.random(20,100),0,math.random(20,100))
                basic:SetDraggable(true)
                self:Add("Test-"..i, basic)
            end
        end

        function GUI:PerformLayout(pos, size)
            self.background_outline.Position = pos
            self.background_outline.Size = size
        end

        function GUI:GetActive()
            return self.registry[self.activeId]
        end

        function GUI:SetActive(num)
            if self.activeId == num then return end
            local new = self.registry[num]
            if not new then return end
            local active = self:GetActive()
            if active then
                active[1]:SetActive(false)
                active[2]:SetTransparency(0)
                active[2]:SetEnabled(false)
            end
            new[1]:SetActive(true)
            new[2]:SetEnabled(true)
            new[2]:SetTransparency(1)
            self.activeId = num
        end

        function GUI:Add(name, object)
            object:SetParent(self.container)
            object:SetTransparency(0)
            object:SetEnabled(false)
            local r = self.registry
            local tab = gui:Create("Tab", self.tablist)
            tab.Id = #r+1
            tab.controller = self
            tab:SetText(name)
            tab:SetPanel(object)
            r[#r+1] = {tab, object}
            local l = #r
            for i=1, l do
                local v = r[i]
                v[1]:SetSize(1/l,0,1,0)
                v[1]:SetPos((1/l)*(i-1),0,0,0)
            end
            if tab.Id == 1 then
                self:SetActive(tab.Id)
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
        function menu:HandleGeneration(container, configuration)
            for i=1, #configuration do
                local config = configuration[i]
                local type = config.type
                local name = config.name
                local subcontainer
                if type == "Tabs" then
                    local frame = gui:Create("Tabs", container)
                    frame.Name = name
                    if config.pos then
                        frame:SetPos(config.pos)
                    end
                    if config.size then
                        frame:SetSize(config.size)
                    end
                    subcontainer = frame.container
                else
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

                    subcontainer = gui:Create("Container", frame)
                    frame.subcontainer = subcontainer
                    subcontainer:SetPos(0, 0, 0, 6)
                    subcontainer:SetSize(1, 0, 1, -12)
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
        toolbar:SetZIndex(10000)
        gui:SizeTo(toolbar, UDim2.new(1, 0, 0, 34), 0.775, 0, 0.25)

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

        local tabs = gui:Create("Tabs", frame)
        tabs:SetPos(0, 10, 0, 10+20)
        tabs:SetSize(1, -20, 1, -20-20)

        --self:HandleGeneration(tabs.container, configuration.content)
        return frame
    end

    hook:Add("Menu.Generate", "BBOT:Menu.Main", function(frame)

        local setup_parameters = BBOT.configuration
        for i=1, #setup_parameters do
            menu:Create(setup_parameters[i]):SetZIndex(100*i)
        end
    end)

    hook:Add("Initialize", "BBOT:Menu", function()
        menu:Initialize()
    end)
end

--! POST LIBRARIES !--
-- WholeCream here, do remember to sort all of this in order for a possible module based loader

-- Setup, are we playing PF, Universal or... Bad Business 😉
do
    local thread = BBOT.thread
    local hook = BBOT.hook
    local NetworkClient = BBOT.service:GetService("NetworkClient")
    if game.PlaceId == 292439477 or game.PlaceId == 299659045 or game.PlaceId == 5281922586 or game.PlaceId == 3568020459 then
        BBOT.game = "pf"
    else
        BBOT.game = "uni"
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

    hook:Add("PreInitialize", "BBOT:SetupConfigurationScheme", function()
        local menu = BBOT.menu
        local config = BBOT.config
        if BBOT.game == "pf" then
            BBOT.configuration = {
                {
                    -- The first layer here is the frame
                    Id = "Main",
                    name = "The Main Attraction",
                    center = true,
                    size = UDim2.new(0, 500, 0, 600),
                    content = {}
                },
                {
                    -- The first layer here is the frame
                    Id = "Env",
                    name = "Environment",
                    pos = UDim2.new(0, 520, 0, 100),
                    size = UDim2.new(0, 599, 0, 501),
                    content = { -- by default operation is tabs
                        { -- Do not assign types in here, as tabs automatically assigns them as "Panel"
                            name = "Players",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(0,0,0,0),
                            type = "Panel",
                            content = {
                                {
                                    name = "Player List", -- No type means auto-set to panel
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(0,0,0,0),
                                    type = "Panel",
                                    content = {},
                                },
                                {
                                    name = "Player Control",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(0,0,0,0),
                                    type = "Panel",
                                    content = {},
                                },
                            },
                        },
                    }
                }
            }
        else
            BBOT.configuration = {}
        end
    end)
end

-- Notifications, nice... but some aspects of it still bugs me... (Done)
do
    -- I kinda like how this can run standalone
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
                        if BBOT.menu then
                            local mencol = customcolor or Color3.fromRGB(127, 72, 163)
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

        local color = Color3.fromRGB(127, 72, 163)

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

-- Auxillary, responsible for fetching, modifying,  (Done)
-- If AUX cannot find or a check is invalidated, it will prevent BBOT from loading
-- This should in theory prevent most bans related to updates by PF as it would prevent
-- The cheat from having a colossal error
do
    if BBOT.game ~= "pf" then return end
    local math = BBOT.math
    local table = BBOT.table
    local hook = BBOT.hook
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
                    local path = aux_functions[name]
                    BBOT.log(LOG_DEBUG, 'Found Auxillary Function "' .. name .. '"' .. (path ~= true and " sorted into " .. path or ""))
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

        for _,v in next, reg do
            if typeof(v) == "function" then
                local dbg = debug.getinfo(v)
                if string.find(dbg.short_src, "network", 1, true) and dbg.name ~= "call" then
                    local ups = debug.getupvalues(v)
                    for k, vv in pairs(ups) do
                        if typeof(vv) == "table" then
                            if #vv > 10 then
                                rawset(aux.network, "receivers", vv)
                                BBOT.log(LOG_DEBUG, "Found network receivers")
                            end
                        end
                    end
                end
            end
        end

        if not aux.network.receivers then
            return "Couldn't find auxillary \"network.receivers\""
        end

        hook:Add("Unload", "BBOT:NetworkReceivers", function()
            rawset(aux.network, "receivers", nil)
        end)
    end

    local profiling_tick = tick()
    local error = aux:_Scan()
    if error then
        BBOT.log(LOG_ERROR, error)
        BBOT.log(LOG_WARN, "For safety reasons this process has been halted")
        messagebox("For safety reasons this process has been halted\nError: " .. error .. "\nPlease contact the Demvolopers!", "BBOT: Critical Error", 0)
        return true
    end

    do -- using rawget just in case...
        local send = rawget(aux.network, "send")
        local osend = rawget(aux.network, "_send")
        hook:Add("Unload", "BBOT:NetworkOverride", function()
            rawset(aux.network, "send", osend or send)
        end)
        local function sender(self, ...)
            local _BB = BBOT
            local _aux = _BB.aux
            local _hook, _send = _BB.hook, _aux.network._send -- something about synapses hooking system I tried...
            if _aux.network_supressing then return _send(self, ...) end
            _aux.network_supressing = true
            if _hook:Call("SuppressNetworkSend", ...) then
                _aux.network_supressing = false
                return
            end
            _aux.network_supressing = false
            local override = _hook:Call("PreNetworkSend", ...)
            if override then
                if _BB.username == "dev" then
                    _BB.log(LOG_DEBUG, unpack(override))
                end
                return _send(self, unpack(override)), _hook:Call("PostNetworkSend", unpack(override))
            end
            if _BB.username == "dev" then
                _BB.log(LOG_DEBUG, ...)
            end
            return _send(self, ...), _hook:Call("PostNetworkSend", ...)
        end
        local function newsend(self, netname, ...)
            local ran, a, b, c, d, e = xpcall(sender, debug.traceback, self, netname, ...)
            if not ran then
                aux.timer:Async(function() BBOT.log(LOG_ERROR, "Networking Error - ", netname, " - ", a) end)
            else
                return a, b, c, d, e
            end
        end
        rawset(aux.network, "_send", send)
        rawset(aux.network, "send", newcclosure(newsend))
    end

    hook:Add("PostNetworkSend", "BBOT:FrameworkErrorLog", function(net, ...)
        if net == "logmessage" or net == "debug" then
            local args = {...}
            local message = ""
            for i = 1, #args - 1 do
                message ..= tostring(args[i]) .. ", "
            end
            message ..= tostring(args[#args])
            BBOT.log(LOG_WARN, "Framework Internal Message -> " .. message)
        end
    end)
    
    do
        local old = aux.char.loadcharacter
        function aux.char.loadcharacter(char, pos, ...)
            hook:Call("PreLoadCharacter", char, pos, ...)
            return old(char, pos, ...), hook:Call("PostLoadCharacter", char, pos, ...)
        end
        hook:Add("Unload", "BBOT:LoadCharacter", function()
            aux.char.loadcharacter = old
        end)
    end
    
    do
        function aux.sound.playid(p39, p40, p41, p42, p43, p44)
            aux.sound.PlaySoundId(p39, p40, p41, nil, nil, p42, nil, nil, nil, p43, p44);
        end
        local oplay = rawget(aux.sound, "PlaySound")
        hook:Add("Unload", "BBOT:SoundDetour", function()
            rawset(aux.sound, "PlaySound", oplay)
        end)
        local supressing = false
        local function newplay(...)
            if supressing then return oplay(...) end
            supressing = true
            if hook:Call("SupressSound", ...) then
                supressing = false
                return
            end
            supressing = false
            return oplay(...)
        end
        rawset(aux.sound, "PlaySound", newcclosure(newplay))
    end
    
    local setupvalueundo = {}
    local ups = debug.getupvalues(aux.replication.getupdater)
    for k, v in pairs(ups) do
        if typeof(v) == "function" then
            local name = debug.getinfo(v).name
            if name == "loadplayer" then
                local function LoadPlayer(...)
                    hook:Call("PreLoadPlayer", ...)
                    local ctlr, a, b = v(...)
                    if ctlr then
                        hook:Call("PostLoadPlayer", ctlr)
                    end
                    return ctlr, a, b
                end
                debug.setupvalue(aux.replication.getupdater, k, newcclosure(LoadPlayer))
                setupvalueundo[#setupvalueundo+1] = {aux.replication.getupdater, k, v}
            end
        end
    end
    
    local ups = debug.getupvalues(aux.hud.isplayeralive)
    for k, v in pairs(ups) do
        if typeof(v) == "function" then
            local name = debug.getinfo(v).name -- are you ok pf?
            if name == "gethealthstate" then
                aux.hud.gethealthstate = newcclosure(function(self, player)
                    return v(player)
                end)
            end
        end
    end
    
    local players = BBOT.service:GetService("Players")
    hook:Add("Initialize", "BBOT:SetupPlayerReplication", function()
        for i, v in next, players:GetChildren() do
            local controller = aux.replication.getupdater(v)
            if controller and not controller.setup then
                hook:Call("PostLoadPlayer", controller)
            end
        end
    end)
    
    local old = aux.char.step
    function aux.char.step(...)
        hook:Call("PreCharacterStep")
        local a, b, c, d = old(...)
        hook:Call("PostCharacterStep")
        return a, b, c, d
    end
    hook:Add("Unload", "BBOT:CharStepDetour", function()
        aux.char.step = old
    end)
    
    hook:Add("FullyLoaded", "BigRewardDetour", function()
        local receivers = aux.network.receivers
        for k, v in pairs(receivers) do
            local a = debug.getupvalues(v)[1]
            if typeof(a) == "function" then
                local run, consts = pcall(debug.getconstants, a)
                if run then
                    if table.quicksearch(consts, "killshot") and table.quicksearch(consts, "kill") then
                        receivers[k] = function(type, entity, gunname, earnings, ...)
                            hook:Call("PreBigAward", type, entity, gunname, earnings, ...)
                            v(type, entity, gunname, earnings, ...)
                            hook:Call("PostBigAward", type, entity, gunname, earnings, ...)
                        end
    
                        hook:Add("Unload", "BBOT:RewardDetour." .. tostring(k), function()
                            receivers[k] = v
                        end)
                    end
                end
            end
        end
    end)
    
    hook:Add("Unload", "BBOT:Aux.UpValues.1", function()
        for i=1, #setupvalueundo do
            debug.setupvalue(unpack(setupvalueundo[i]))
        end
    end)

    local dt = tick() - profiling_tick
    BBOT.log(LOG_NORMAL, "Took " .. math.round(dt, 2) .. "s to load auxillary")
end

-- Chat, allows for chat manipulations, or just being a dick with the chat spammer (Conversion In Progress)
do
    local network = BBOT.aux.network
    local hook = BBOT.hook
    local table = BBOT.table
    local timer = BBOT.timer
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

    hook:Add("Initialize", "BBOT:ChatDetour", function()
        local receivers = network.receivers

        for k, v in pairs(receivers) do
            local const = debug.getconstants(v)
            if table.quicksearch(const, "Tag") and table.quicksearch(const, "rbxassetid://") then
                receivers[k] = function(p20, p21, p22, p23, p24)
                    timer:Async(function() hook:Call("Chatted", p20, p21, p22, p23, p24) end)
                    return v(p20, p21, p22, p23, p24)
                end
                hook:Add("Unload", "ChatDetour." .. tostring(k), function()
                    receivers[k] = v
                end)
            elseif table.quicksearch(const, "[Console]: ") and table.quicksearch(const, "Tag") then
                receivers[k] = function(p18)
                    timer:Async(function() hook:Call("Console", p18) end)
                    return v(p18)
                end
                hook:Add("Unload", "ChatDetour." .. tostring(k), function()
                    receivers[k] = v
                end)
            end
        end
    end)

    function chat:Say(str, un)
        if string.sub(str, 1, 1) == "/" then
            network:send("modcmd", str);
            return
        end
        network:send("chatted", str, un or false);
    end

    chat.buffer = {}
    local lasttext = ""
    function chat:AddToBuffer(msg)
        local spaces = ""
        if msg == lasttext then
            for i=1, a do
                spaces = spaces .. "."
            end
            a = a + 1
            if a > 1 then a = 0 end
        else
            a = 0
            lasttext = msg
        end
        msgquery[#msgquery+1] = msg .. spaces
    end
    
    function chat:CheckIfValid(msg)
        for i=1, #msg do
            local str = string.sub(msg, i, i)
            if str ~= "\n" or str ~= " " then
                return true
            end
        end
    end

    --[[
    local lastkillsay = ""
    local killsay = lastkillsay
    while killsay == lastkillsay do
        killsay = math.random(#customKillSay)
    end
    lastkillsay = killsay
    local message = customKillSay[killsay]
    message = message:gsub("%[hitbox%]", head and "head" or "body")
    message = message:gsub("%[name%]", victim.Name)
    message = message:gsub("%[weapon%]", weapon)
    chat:AddToBuffer(message)
    ]]

    timer:Create("Chat.Spam", 1.5, 0, function() -- fuck you stylis
        local msg = chat.buffer[1]
        if not msg then return end
        table.remove(chat.buffer, 1)
        chat:Say(msg)
    end)
end

-- VoteKick, handles the votekicks system (Conversion In Progress)
-- Anti-Votekick
--[=[do
    local config = BBOT.config
    local hook = BBOT.hook
    local timer = BBOT.timer
    local localplayer = BBOT.service:GetService("LocalPlayer")
    local votekick = {}
    BBOT.votekick = votekick
    votekick.CallDelay = 90
    votekick.NextCall = 0
    votekick.Called = 0
    
    local receivers = BBOT.network.receivers
    for k, v in pairs(receivers) do
        local consts = debug.getconstants(v)
        local has = false
        for kk, vv in pairs(consts) do
            if typeof(vv) == "string" and string.find(vv, "Votekick", 1, true) then
                local function callvotekick(target, delay, votesrequired, ...)
                    timer:Async(function() hook:Call("StartVoteKick", target, delay, votesrequired) end)
                    return v(target, delay, votesrequired, ...)
                end
                rawset(receivers, k, callvotekick)
                hook:Add("Unload", "UndoVotekickDetour-"..k, function()
                    rawset(receivers, k, v)
                end)
    
                function votekick:GetVotes()
                    return debug.getupvalue(v, 9)
                end
                break
            end
        end
    end
    
    local invote = false
    hook:Add("StartVoteKick", "StartVoteKick", function(target, delay, votesrequired)
        delay = tonumber(delay)
        timer:Create("VoteKickCalled", delay, 1, function()
            hook:Remove("RenderStep.First", "Votekick.Step")
            hook:Call("EndVoteKick", target, delay, votesrequired, false)
        end)
        hook:Add("RenderStep.First", "Votekick.Step", function()
            if votekick:GetVotes() >= votesrequired then
                hook:Remove("RenderStep.First", "Votekick.Step")
                timer:Remove("VoteKickCalled")
                hook:Call("EndVoteKick", target, delay, votesrequired, true)
            end
        end)
        if config:GetValue("Misc", "Exploits", "Anti-Votekick", "Enable") then
            timer:Simple(delay+2, function()
                votekick:RandomCall()
            end)
        end
    
        if target == localplayer.Name then
            timer:Simple(.5, function() BBOT.hud:vote("no") end)
        end
    
        invote = votesrequired
        BBOT.print("Votekick called on " .. target .. "; time till end: " .. delay .. "; votes required: " .. votesrequired)
        if votekick.Called == 1 then
            votekick.Called = 2
        elseif votekick.Called == 2 or votekick.Called == 0 then
            votekick.Called = 0
            votekick.NextCall = tick() + 1000000
        end
    end)
    
    hook:Add("Console", "VoteKickExploit", function(msg)
        if string.find(msg, "The last votekick was initiated by you", 1, true) then
            votekick.Called = 2
        elseif string.find(msg, "seconds before initiating a votekick", 1, true) then
            votekick.Called = 0
            votekick.NextCall = tick() + (tonumber(string.match(msg, "%d+")) or 0)
        end
    end)
    
    function votekick:IsVoteActive()
        return debug.getupvalue(BBOT.hud.votestep, 2)
    end
    
    local players = BBOT.service:GetService("Players")
    function votekick:GetTargets()
        local targetables = {}
        for i, v in pairs(players:GetPlayers()) do
            local inpriority = config.prioritylist[v.UserId]
            if (not inpriority or inpriority >= 0) and v ~= localplayer then
                targetables[#targetables+1] = v
            end
        end
        return targetables
    end
    
    function votekick:CanCall(target, reason)
        if self:IsVoteActive() then return false, "VoteActive" end
        if self.NextCall > tick() or self.Called > 0 then return false, "RateLimit" end
        return true
    end
    
    function votekick:Call(target, reason)
        BBOT.chat:Say("/votekick:"..target..":"..reason)
        self.NextCall = 0
        self.Called = 1
    end
    
    function votekick:RandomCall()
        local targets = votekick:GetTargets()
        local target = BBOT.FYShuffle(targets)[1]
        votekick:Call(target.Name, config:GetValue("Misc", "Exploits", "Anti-Votekick", "Reason"))
    end
    
    votekick.autohopping = false
    hook:Add("RenderStep.First", "VoteKickExploit", function()
        if not config:GetValue("Misc", "Exploits", "Anti-Votekick", "Enable") then return end
        if config:GetValue("Misc", "Exploits", "Anti-Votekick", "WaitTillAlive") and not votekick.WasAlive then return end
        if votekick:CanCall() then
            local targets = votekick:GetTargets()
            local target = BBOT.FYShuffle(targets)[1]
            votekick:Call(target.Name, config:GetValue("Misc", "Exploits", "Anti-Votekick", "Reason"))
        end
    
        local t = config:GetValue("Misc", "Exploits", "Anti-Votekick", "Auto-Hop", "Delay")
        if not votekick.autohopping and config:GetValue("Misc", "Exploits", "Anti-Votekick", "Auto-Hop", "Enable") and votekick.Called == 2 and votekick.NextCall ~= 0 and votekick.NextCall - (10 + (t < 0 and -t or 0)) <= tick() then
            votekick.autohopping = true
            log(LOG_NORMAL, "WARNING: Hopping in " .. (10+(t > 0 and t or 0)) .. " seconds")
            timer:Simple(10+(t > 0 and t or 0), function()
                BBOT.serverhop:RandomHop()
            end)
        end
    end)
    
    hook:Add("PreUpdatePersonalHealth", "VoteKickExploit", function(hp, time, healrate, maxhealth, alive)
        if alive == true then
            votekick.WasAlive = true
        end
    end)
end

-- Server-Hopper, redirects and moves the user to other server instances (Conversion In Progress)
-- Votekick-blacklist (prevents user from joining voted out servers)
do
    local config = BBOT.config
    local hook = BBOT.hook
    local votekick = BBOT.votekick
    local log = BBOT.log
    local TeleportService = game:GetService("TeleportService")
    local localplayer = BBOT.service:GetService("LocalPlayer")
    local httpservice = BBOT.service:GetService("HttpService")
    local serverhop = {}
    BBOT.serverhop = serverhop

    serverhop.file = "bitchbot/votedoff-servers.txt"
    serverhop.blacklist = {}
    serverhop.UserId = tostring(localplayer.UserId)

    hook:Add("FullyLoaded", "LoadServer-Hop", function()
        if isfile(serverhop.file) then
            serverhop.blacklist = httpservice:JSONDecode(readfile(serverhop.file))
            local otime = os.time()
            for _, userblacklist in pairs(serverhop.blacklist) do
                for k, v in pairs(userblacklist) do
                    if otime > v then
                        userblacklist[k] = nil
                        log(LOG_NORMAL, "Removed server-hop blacklist " .. k)
                    end
                end
            end
            writefile(serverhop.file, httpservice:JSONEncode(serverhop.blacklist))
            local plbllist = serverhop.blacklist[serverhop.UserId]
            if plbllist then
                local c = 0
                for k, v in pairs(plbllist) do
                    c = c + 1
                end
                --BBOT.chat:Message("You have been votekicked from " .. c .. " server(s)!")
                log(LOG_NORMAL, "You have been votekicked from " .. c .. " server(s)!")
            end
        end
    end)

    function serverhop:IsBlacklisted(id)
        local plbllist = serverhop.blacklist[self.UserId]
        if plbllist and plbllist[id] then
            return true
        end
    end

    function serverhop:RandomHop()
        log(LOG_NORMAL, "Commencing Server-Hop...")
        local data = httpservice:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
        local mode = config:GetValue("Misc", "Exploits", "Server-Hopper", "Sort By")
        if mode == "Lowest Ping" then
            table.sort(data, function(a, b) return a.ping < b.ping end)
        elseif mode == "Highest Ping" then
            table.sort(data, function(a, b) return a.ping > b.ping end)
        elseif mode == "Highest Players" then
            table.sort(data, function(a, b) return a.playing > b.playing end)
        elseif mode == "Lowest Players" then
            table.sort(data, function(a, b) return a.playing < b.playing end)
        end
        for _, s in pairs(data) do
            if not serverhop:IsBlacklisted(s.id) and s.id ~= game.JobId then
                if s.playing ~= s.maxPlayers then
                    log(LOG_NORMAL, "Hopping to server Id: " .. s.id .. "; Players: " .. s.playing .. "/" .. s.maxPlayers .. "; " .. s.ping .. " ms")
                    --syn.queue_on_teleport(<string> code)
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                    return
                end
            end
        end
        log(LOG_ERROR, "No servers to hop towards... Wow... You really got votekicked off every server now did ya? Impressive...")
    end

    function serverhop:AddToBlacklist(id, removaltime)
        local plbllist = self.blacklist[self.UserId]
        if not plbllist then
            plbllist = {}
            self.blacklist[self.UserId] = plbllist
        end
        plbllist[id] = (removaltime and removaltime + os.time() or -1)
    end

    function serverhop:Hop(id)
        log(LOG_NORMAL, "Hopping to server " .. id)
        if serverhop:IsBlacklisted(id) then
            log(LOG_ERROR, "This server ID is blacklisted! Where you votekicked from here?")
            return
        end
        TeleportService:TeleportToPlaceInstance(game.PlaceId, id)
    end

    hook:Add("EndVoteKick", "Server-Hopper", function(target, delay, required, successful)
        if target == localplayer.Name and successful then
            if not serverhop:IsBlacklisted(game.JobId) then
                serverhop:AddToBlacklist(game.JobId, 86400)
                log(LOG_NORMAL, "Added " .. game.JobId .. " to server-hop blacklist")
                writefile(serverhop.file, httpservice:JSONEncode(serverhop.blacklist))
            end
            if not config:GetValue("Misc", "Exploits", "Server-Hopper", "Enable") then return end
            serverhop:RandomHop()
        end
    end)
end

-- Generalized Aimbot (Conversion In Progress)
-- Knife Aura
-- Bullet Network Manipulation
do
    local timer = BBOT.timer
    local hook = BBOT.hook
    local config = BBOT.config
    local network = BBOT.network
    local gamelogic = BBOT.gamelogic
    local hud = BBOT.hud
    local physics = BBOT.physics
    local localplayer = BBOT.service:GetService("LocalPlayer")
    local aimbot = {}
    BBOT.aimbot = aimbot

    function aimbot:VelocityPrediction(startpos, endpos, vel, speed)
        local len = (endpos-startpos).Magnitude
        local t = len/speed
        return endpos + (vel * t)
    end

    aimbot.bullet_gravity = Vector3.new(0, -196.2, 0) -- Todo: get the velocity from the game public settings

    function aimbot:DropPrediction(startpos, finalpos, speed)
        return physics.trajectory(startpos, self.bullet_gravity, finalpos, speed)
    end

    -- Scan targets here
    function aimbot.Step()

    end

    -- Do aimbot stuff here
    hook:Add("PreWeaponStep", "BBOT:Aimbot.Calculate", function(gundata, partdata)

    end)

    -- If the aimbot stuff before is persistant, use this to restore
    hook:Add("PostWeaponStep", "BBOT:Aimbot.Calculate", function(gundata, partdata)
    
    end)

    local enque = {}
    aimbot.silent_bullet_query = enque
    -- Ta da magical right?
    hook:Add("SuppressNetworkSend", "BBOT:Aimbot.Silent", function(networkname, Entity, HitPos, Part, bulletID, ...)
        if networkname == "bullethit" then
            if enque[bulletID] == Entity then
                return true
            end
        end
    end)

    -- When silent aim isn't enough, resort to this, and make even cheaters rage that their config is garbage
    hook:Add("SuppressNetworkSend", "BBOT:Aimbot.Silent", function(networkname, bullettable, timestamp)
        if networkname == "newbullets" then
            if not gamelogic.currentgun or not gamelogic.currentgun.data then return end
            local silent = config:GetValue("Rage", "Aimbot", "Silent Aim")
            if silent and aimbot.target then -- who are we targeting today?
                local target = aimbot.target
                -- timescale is to determine how quick the bullet hits
                -- don't want to get too cocky or the system might silent flag
                local timescale = config:GetValue("Legit", "Bullet Redirection", "TimeScale")
                local campos = currentcamera.CFrame.p
                local dir = target.selected_part.Position-campos
                local X, Y = CFrame.new(campos, campos+dir):ToOrientation()
                local firepos = bullettable.firepos
                local gundata = gamelogic.currentgun.data
                local campos = currentcamera.CFrame.p
                local dir = target.selected_part.Position-campos
                local t = dir.Magnitude/gundata.bulletspeed -- get the time it takes for the bullet to arrive
                -- remind me to not do this, some cheats fucks with velocity...
                local targetpos = aimbot:VelocityPrediction(firepos, target.selected_position, target.parts.HumanoidRootPart.Velocity, gundata.bulletspeed)
                bullettable.firepos = campos + ((firepos-campos).Unit + ((targetpos-campos).Unit - (firepos-campos).Unit)) * (firepos-campos).Magnitude

                for i=1, #bullettable.bullets do
                    local bullet = bullettable.bullets[i]
                    -- we need the direction we are firing at
                    -- using kinematics, find the direction needed to fire from long distance and compensate for drop
                    -- set the new velocity of the bullet directly towards them
                    bullet[1] = aimbot:DropPrediction(bullettable.firepos, targetpos, gundata.bulletspeed).Unit * bullet[1].Magnitude
                    timer:Simple(1.5, function() -- bullets last 1.5 seconds, this is basically garbage cleanup
                        enque[bullet[2]] = nil
                    end)
                    timer:Simple(t * timescale, function() -- We need to simulate it being a true bullet arrival
                        -- enque means we have a bullet to be hit, if it is in the table then it's ready
                        if not enque[bullet[2]] then return end
                        if not hud:isplayeralive(target.player) then return end
                        enque[bullet[2]] = nil
                        -- Simulate a direct hit, fooling the system with a confirmed hit
                        network:send("bullethit", target.player, targetpos, target.selected_part, bullet[2])
                        enque[bullet[2]] = target.player
                    end)
                    enque[bullet[2]] = target.player -- this bullet is a magic bullet now, supress networking for this bullet!
                end
                network:send(networkname, bullettable, timestamp)
                
                return true
            end
        end
    end)

    -- Knife Aura --
    hook:Add("PreKnifeStep", "BBOT:KnifeAura.Calculate", function(knifedata)
    
    end)
end]=]

-- Entity Visuals Controller [ESP, Chams, Grenades, etc] (Conversion In Progress)
-- Styled as a constructor with meta tables btw, I'll tell ya later - WholeCream
do
    -- Why this?
    -- Because it's more organized :|
    local hook = BBOT.hook
    local timer = BBOT.timer
    local config = BBOT.config
    local font = BBOT.font
    local gui = BBOT.gui
    local log = BBOT.log
    local math = BBOT.math
    local string = BBOT.string
    local service = BBOT.service
    local esp = {
        registry = {}
    }
    BBOT.esp = esp

    local localplayer = service:GetService("LocalPlayer")
    local playergui = service:GetService("PlayerGui")
    local currentcamera = BBOT.service:GetService("CurrentCamera")

    esp.container = Instance.new("Folder")
    esp.container.Name = string.random(8, 14) -- you gonna try that GetChildren attack anytime soon?
    syn.protect_gui(esp.container) -- for chams only!
    esp.container.Parent = playergui.MainGui

    -- Adds an ESP object to the rendering query
    function esp:Add(construct)
        local reg = self.registry
        for i=1, #reg do
            if reg[i].uniqueid == construct.uniqueid then return false end
        end
        reg[#reg+1] = construct
        if construct.OnCreate then
            construct:OnCreate()
        end
    end

    -- Use this to find an esp object
    function esp:Find(uniqueid)
        local reg = self.registry
        for i=1, #reg do
            if reg[i].uniqueid == uniqueid then
                return reg[i], i
            end
        end
    end

    -- Self-explanitory
    function esp:Remove(uniqueid)
        local reg = self.registry
        for i=1, #reg do
            if reg[i].uniqueid == uniqueid then
                local v = reg[i]
                table.remove(reg, i)
                if v.OnRemove then
                    v:OnRemove()
                end
                break
            end
        end
    end

    hook:Add("Unload", "BBOT:ESP.Destroy", function()
        local reg = esp.registry
        for i=1, #reg do
            local v = reg[i]
            if v.OnRemove then
                v:OnRemove()
            end
        end
        esp.registry = {}
        esp.container:Destroy()
    end)

    function esp.Render(v)
        if v.IsValid and v:IsValid() then
            if v:CanRender() then
                if v.PreRender then
                    v:PreRender()
                end
                if v.Render then
                    v:Render()
                end
                if v.PostRender then
                    v:PostRender()
                end
            end
        else
            return true
        end
    end

    function esp:Rebuild()
        timer:Create("BBOT:ESP.Rebuild", 1, 1, function() self:_Rebuild() end)
    end

    function esp:_Rebuild()
        local controllers = self.registry
        for i=1, #controllers do
            local v = controllers[i]
            if v.Rebuild then
                v:Rebuild()
            end
        end
    end

    function esp.EmptyTable( tab )
        for k, v in pairs( tab ) do
            tab[ k ] = nil
        end
    end

    local errors = 0
    hook:Add("RenderStep.Last", "BBOT:ESP.Render", function()
        if errors > 20 then return end
        local controllers = esp.registry
        local istablemissalined = false
        local c = 0
        for i=1, #controllers do
            local v = controllers[i-c]
            if v then
                local ran, destroy = pcall(esp.Render, v)
                if not ran then
                    log(LOG_ERROR, "ESP render error - ", destroy)
                    log(LOG_ANON, "Object - ", v.uniqueid)
                    log(LOG_WARN,"Auto removing to prevent error cascade!")
                    table.remove(controllers, i-c)
                    c = c + 1
                    errors = errors + 1
                elseif destroy then
                    table.remove(controllers, i-c)
                    c = c + 1
                    if v.OnRemove then
                        v:OnRemove()
                    end
                end
            else
                istablemissalined = true
            end
        end

        if istablemissalined then
            local sorted = {}
            for k, v in pairs(controllers) do
                sorted[#sorted+1] = v
            end
            esp.EmptyTable(controllers)
            for i=1, #sorted do
                controllers[i] = sorted[i]
            end
        end
    end)


    do -- players

    end

    -- Will make examples...
end

-- Weapon Modifications, I know you cannot do changes while playing, but this allows you to customize the entire gun (Conversion In Progress)
-- Skin changer
do
    -- From wholecream
    -- configs aren't done so they are default to screw-pf aka my stuff...
    -- this weapon module allows complete utter freedom of the gun's functions
    -- this is also exactly why a skin changer client-side works fantasticly well...
    local weapons = {}
    BBOT.weapons = weapons
    local hook = BBOT.hook
    local char = BBOT.aux.char
    local gamelogic = BBOT.aux.gamelogic
    local config = BBOT.config

    -- Welcome to my hell.
    -- ft. debug.setupvalue
    local profiling_tick = tick()

    local receivers = BBOT.aux.network.receivers
    local upvaluemods = {} -- testing? no problem reloading the script...
    hook:Add("Unload", "BBOT:WeaponModifications", function()
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
            hook:CallP("WeaponModifyData", modifications)
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
            local mul = 1 -- sway factor config here
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
            local mul = 1 -- bob factor config here
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
            if gamelogic.currentgun == gundata then
                hook:CallP("PreKnifeStep", gundata)
            end
            local a, b, c, d = oldstep(...)
            if gamelogic.currentgun == gundata then
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
            if gamelogic.currentgun == gundata then
                if not gundata.partdata then
                    gundata.partdata = partdata
                end
                hook:CallP("PreWeaponStep", gundata, partdata)
            end
            local a, b, c, d = oldstep(...)
            if gamelogic.currentgun == gundata then
                hook:CallP("PostWeaponStep", gundata, partdata)
            end
            return a, b, c, d
        end
    end)
end

-- Init, tell all modules we are ready
do
    BBOT.hook:Call("PreInitialize")
    BBOT.hook:Call("Initialize")
    BBOT.hook:Call("PostInitialize")
end

-- The Moment, just some print stuff for the user to see on init, like has the cheat reloaded?
do
    local loadtime = (BBOT.math.round(tick()-loadstart, 6))
    BBOT.timer:Async(function()
        if _BBOT then
            BBOT.notification:Create("There was an already active version of bbot running, this has been unloaded")
        end
        BBOT.notification:Create(string.format("Done loading the " .. BBOT.game .. " cheat. (%d ms)", loadtime*1000))
        BBOT.notification:Create("Press DELETE to open and close the menu!")
        if BBOT.username == "dev" then
            BBOT.notification:Create("So what are we doin today? mr.dev")
        end
    end)
end
end

local ran, err = xpcall(ISOLATION, debug.traceback, BBOT)
if not ran then
    BBOT.log(LOG_ERROR, "Error loading Bitch Bot -", err)
end