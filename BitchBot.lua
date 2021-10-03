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


    function table.recursion( tbl, cb, pathway )
        pathway = pathway or {}
        for k, v in pairs( tbl ) do
            local newpathway = table.deepcopy(pathway)
            newpathway[#newpathway+1] = k
            if typeof( v ) == "table" and cb(newpathway, v) ~= false then
                table.recursion( v, cb, newpathway)
            else
                cb(newpathway, v)
            end
        end
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

    function math.approach( cur, target, inc )
        inc = math.abs( inc )
        if ( cur < target ) then
            return math.min( cur + inc, target )
        elseif ( cur > target ) then
            return math.max( cur - inc, target )
        end
        return target
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

    function color.darkness(col, scale)
        local h, s, v = Color3.toHSV(col)
        return Color3.fromHSV(h, s, v*scale)
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

    -- msg from cream - this is called pythagorean theorem btw, the guy you found it from doesn't know math...
	function vector.dist2d ( pos1, pos2 ) -- found this func here https://love2d.org/forums/viewtopic.php?t=1951 ty to whoever did this
		local dx = pos1.X - pos2.X
		local dy = pos1.Y - pos2.Y
		return math.sqrt ( dx * dx + dy * dy )
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


    local _string_rep = string.rep
    local _string_len = string.len
    local _string_sub = string.sub
    local _table_concat = table.concat
    local _tostring = tostring
    local _string_find = string.find
    function string.Explode(separator, str, withpattern)
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

    function string.Replace( str, tofind, toreplace )
        local tbl = string.Explode( tofind, str )
        if ( tbl[ 1 ] ) then return _table_concat( tbl, toreplace ) end
        return str
    end

    function string.WrapText(text, font, size, width)
        local sw = BBOT.gui:GetTextSize(' ', font, size).X
        local ret = {}

        local t2 = string.Explode('\n', text, false)
        for k=1, #t2 do
            local v = t2[k]
            ret[#ret + 1] = v
        end

        local ret_proccessed = {}

        local w = 0
        local s = ''
        for k=1, #ret do
            local text = ret[k]

            local t2 = string.Explode(' ', text, false)
            for i2 = 1, #t2 do
                local neww = BBOT.gui:GetTextSize(t2[i2], font, size).X
                
                if (w + neww >= width) then
                    ret_proccessed[#ret_proccessed + 1] = s
                    w = neww + sw
                    s = t2[i2] .. ' '
                else
                    s = s .. t2[i2] .. ' '
                    w = w + neww + sw
                end
            end
            ret_proccessed[#ret_proccessed + 1] = s
            w = 0
            s = ''
            
            if (s ~= '') then
                ret_proccessed[#ret_proccessed + 1] = s
            end
        end

        return ret_proccessed
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
    hook:Add("Unload", "Unload", function() -- Reloading the cheat? no problem.
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

    -- dafuq you think...
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

    function draw:Quad(pa, pb, pc, pd, color, thickness, transparency, visible)
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

    local placeholderImage = "iVBORw0KGgoAAAANSUhEUgAAAJYAAACWCAYAAAA8AXHiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAJOgAACToAYJjBRwAADAPSURBVHhe7Z0HeFRV+sZDCyEJCQRICJA6k4plddddXf/KLrgurg1EXcXdZV0bVlCqDRQVAQstNKVJ0QVcAelIDz0UaSGBQChJII10Orz/9ztzJ5kk00lC2vs833NTZs69c85vvvOdc8/5rgvqVa9KUD1Y9aoU1YNVr0pRPVj1qhTVg1WvSlE9WPWqFNWDZUaFubk4sf8g9q5egw2zv8eKid/g5y9GY9HIr7FkzASsmjwVWxcsxMFNsUhPPqG9q16mqrNgpRxJwtKxEzFhQD+8fV8nPOzqiXtdXPBMx2gM/HMnjHm6B/7bsxfWvPk24t4fggOEKjFmMo5OnoKjM2ZiPy1u5iys/m425nw5FuMHD8Lc0ePx/Vdj8MOnIzC93yDsWb5KO1vdU50Ba93MOfj6tVfRw8sP0QToWdpnLk0wr4k3dvkG4Pzv7wVuuwvwaosrnn4436w1Cpq1Qp57a+TymOvmg5ymLXHOlcb35DRqjtwGHshzcaM1Rl7zNii6615cffFVXKV3w4qVSN2zGz9O+w7zYyZh8aRv8MPQYSjKy9euqHar1oKVknAEE/v2RTf3VriTEA12aYiFbq2Q7BcMhEYDQZG4FBCOwvZ65LXTI9svBFn+ocji72LZ9liHsBJjGVm+wchq2R5ZhDPL1RvZLk2Rw/MW/t+fceWjT4E9e7Bl7TosmDgF80d9ja3z/6ddbe1TrQIrKzUVY3u/hD8QpB60mU1a4GRbghQSjStB4cgPDMO5gDBkdtAjM0AsDFkClTloKsI06LJ8g5Dl3RaZDT0JmwsK/tgJ1whXXkoK5o2biAXsPncvX6l9itqhWgHWopgYPNTAHX9lo81hV5VPcBASicLA8BKQpIEFpDJmgEtnHozKMCNonr7I4vXmEvDrY8cjMy0NcyQ+o2e7dvWq9slqrmosWNevX8eInj0Rxcb5xMWVXVwQEByBAvFEbMAMwmQOJHNW5XAZTTxaW3bBjOky+TkK7+sCbNyIJf9biFlDPsHp+MPap615qnFgFZ7LwcAuD+IO8U5uLRkrRTBWki6HMLXXKaDEQ8nPcjQHkjkTuLL9bwJcRhNP1oaerJEXchp6ADETsWfHTswcNhzxGzZpn77mqMaAdfXSZfTv1Bl3Eajl7EakqytgzJROD5XBhjF0d6WtxsFlNHpP6SolHrv23hAc3r8fUwa8h1P7D2q1Uf1VI8D6rNuTuI2VvFgDSuKS9A46BZUCS0Big5QFS8wpuG5Gt2jWeE3e/ioWwyfDsW1jLL7+9wu4cvGiVjPVV9UarFXTp6kYanITbwVUXmAJUBkmVhlw3ZSYy5JJN9m8LT1YQ2DpUsybMRsz3x6g1VL1VLUE60J+Ph7z9MHzhKooKBzntS6vLFCmVrs9V4llNvZCQbsQXE5Oxif/7IWk7XFarVUvVTuwZg8dio4EKtanA71URAk0dlhdgSvbP1SNIvHG21i/ZRNGP/Mvrfaqj6oVWE/4+OFlqTDp9gQUdnvmALJmFQ6XTAlUR7ike/Rui9wmzXHt1Em81+0JZJ86rdXkzVe1ACtx53YVSy1r0RYIjUC6xFIaIObgsWWVBpfRyjbyzbR2/DzyZRw+AtPHjMfqWbO0Wr25uulgxbz4sroFk0WYCmhnBSrjUQPEHDy2zCZcclTQ8NguFBltg5DpF4hs30DktglAXusOKPBph0K/IBS2D0Eh4ZL7ioX+wSjk//Nb+COvZTvk+HDU5tMeWa06GGbU24ZUPXzivZr64PKdf8C+LZsx7C+PaLV783RTwXpJF6kCdEMspcOZDqE4y6PyWJUEl3grgUgBRHAuEaprt98DdHoYebQDd3TC6oi78EPI7YgJvxXjwm/HpPDfYcpt92Lq7f+Habf8EdPCf4u5tNW3/R8O3PNXFHR9Cuj6JC7d8wAKI+9APsE759UWma0InF9wlYEmYOe4NMaF48fRt+tDWi3fHN00sLq4NsOXjbwIVTjOBBiAEjMLl5N8Qlc6YQnizCJF7oSFAHc1xUJBGhmSDTe89dj2B/+jBGv9MaEIUOwbuFiHD9+DJe067SmQlpCYiKWz/sRcz/6DIsHD8XCp3phwe33Ialzd+DRZ3H+zvuQR7iyvH2R1YYesQogU4H9gX3o0/kBnM/LM1xsFavKwbpYUKhuxyz28sfVYEKlgWRqFQGXCvw5LM9r3R6IvgM5dz+AWcFReM27HQY+0g2zR41CekaGdlUVr8TkZPz01VisfHMQfv79A8h7/J+49Cd6RX6OrOaEjF2sOSgqxNg1qrhrzDi898TfcfrAIe2qqk5VClZ+RqZaZLeTLrswKByprIA0QnDWxGNZg8ueLjG9fSiH40G4yuP5uztjakAEerq2wEcv/geJe/dpV1L12hobi9UffoLl9/0NF3o8j6I/dMY5bz8Vm1WKF5O4y8UD6P0Gvnh7IBI2btaupGpUZWDlpp1FJKE6JF4kUEeo9IQqDKm0NAWT855LdXcEKadtgPJOcZF3oZdLE7zZ9a/YF1u1FWqPNv+yBuv7DEJ8lydxhfFZjnSVHAhUBmBZbj7Ak89iwmcjcHDdOu0KKl9VAlZ+RpaC6gg/aA7hSCVEacpK4DqjYHLcc0mXl9s2EOh4J5YFd0QXnmd037e1M1dvZV+7grWfjMKuLj1w9bHncE4A44CiogHLcm8DPNYDEz75HAmbquaLVulgXSwoUt3fIX96lEB2f5qHMoDlPFziubLp/RB2K1YFdcQfeY7pn36qnbVm6TJtw9cx2P/Xp3H5b08jq0VbQ6BvBhJnTcH1VE+MeLMfTh+s/Jir0sGSQH0HY6q8YqiMdgNw8f/XaIlRd6ITy//ixZe0s9VsFdE2fjQcpx/5B4rueQCZHq0q1HupbvHVNzHob91xIb/AcNJKUqWC1dnVTY3+Cjj6MwTqZa08XCk0w/SDebhyO4TgetRv8KZLMzyrj1ArSWubzuTmIPZfr+LS31/GOZkqac0A3wwozlhWAwb0Y8fjtc5dtLNVjioNrJd0UWqe6jKhSgkkMDTH4BKYSuASqEBvtSkgUq3N2rZsqXam2qtdi5ci+fF/c3TbBRmyEcMMKA6bcSri0EG83rmzdqaKV6WAFfPSy/g3L/56SBROM7hOITCpDsJl6BYNYGUIVAS1j0tTPBPAuKoOKTU7E5u/mojzX3ylFv2ZhcVR0+DKPxSPoZ0e1M5UsapwsI7s3I67edFXQjriZIdwnCIgKU7CJZ4rl79nBUeqJcmzPvxQO0vdkKwUHf0GR7izZiHTpZF5SG7Acl1csWvrZvzyw/faGStOFQ6WrFJIC4wgFAJVOE6qY3m40szCJVAZABP4LrCcbX4hqsyUGrxjxRkJVF+/3geYPZtQNVBexhwcN2Jyb/Ha7+/Fl+8MRt6Zs9qZK0YVClYPH18s8m6HLAJhAKoErtOEyl64Utn1XQsOw1wPX7Xy4eole+7c1R4pT/V6X3oqgcqlUqAymqyKwKiv8NajFbsiosLAmj1kqFqkdyU4il1gWDFUjsKVwt8REoYxDPy7enprpdcdXb5wAWPefEeDqnI8VSlj+bJZI3//fox67EntKm5cFQKWrFG/hRdXFBpt8FQqtipvtuBK6aAHGE+NbOiFHm38tNLrjgSqsW/102KqKoDKaO30KGjWEgsWL8Kpvfu1q7kxVQhYj3u2xLrWATgTFI4TgQTIAlhiluCSe4fXCNWYxt54oo5CNa5P/6qHSjNJZIK3B6LvI49qV3RjumGwVk6fpqYWLoZE4wS9zkmCZQuuEzRTuASs8yHhmMOYqqunl1Zy3ZFANb7vAA2qyo2pLJrWJWbu3ImpAwdrV+a8bhgs6QIzgiMIk14BI2DZA5fRc8k8Vw7B2tgmUAXqdU2Xzp9HzDsDge9ujqcyNUnjdEnXEcN7v6VdnfO6oZYc3u1JjHdtgcygCCTTWyU7CJe8VmbYJdiXKYW6NvoTqCb0G1SxUMm9xRtIzSS5IxC7Ee8+eGNLm50GS3Ip/IYwnNdFI4mxVTIBEq9lDi5LwbzYeXahUk5KfIJWct3QpaLzmNj/XQ2qiun+strqkK+PVGvtzf3fXstzaYIfZs5E5nHn86s6DdaAP3XBvOZ+SGU3eJxgHXMQLvFS1wjVc6zUOUOGaqXWDV0qKsKkge9VMFShuKKLwjx3d1zrPRhZ7j5mX2ePZbFdMXos3u3WQ7tix+UUWJJKSOKhi/poHGN8JGCVhyvMIlwSX2UHRmC2py96BYdppdYNXSRUkwd9QKi+Q7pLQ2SyXm50aYxAdTk0Ej81aYwzPMeUzg8Df+luWPZs5vU2jaDnsn1/otc6te+A4cIdlFNgDeryIH4k1adNoCoPl07FXSrOKgPXaYKVGhChttLXJSmoBn9YDFUW66PUhlhzjWzDjFAtJFRJ53LVec5dvYLlv+uMQtazs8lN5IY3Rn6B97o/pcp0VA63rKx/+i2BKNJH4WiQHkkc2TkGl6ELfJhlxK1crpVa+3WxsBBT3hsCzCwNVbnd1mYa2ZIZoVpkApVRP8+chdwnnkeWLBY08157LNelEeZMmODUfUSHwRrZ81lMd2uF08HhBCtM2bEO9sOVzhHkfO+2eCnyVq3E2i/Z8vbtBx9pUDUoB1UJXGxQO+Eqhsq1CY5ll4bKqNH3Pgh0edTpZc5ZHr7AnO/xIUf/jsphsG6lp8nRRSKJnieJUIk5AldRSFSd6gIVVB9+TKhmmvVUZU3BZSOroBGqxVagEqXl5mDNXZ2RK6NEZ7pEvqeQg4CR/R3PxeVQCy+OicEQl6ZI0xm8VSm4+LMluE4QrmTCdS44Ep+4eGBi79e0Emu3LhQUYOqQYcAM+6AymjXPZS9URo3u9SLQvZdhe5mZ8mxaE28UzP8Rk/oP1Eq0Tw6B9UiDZtjbLgRJHMkl0AQmI1iW4BKw5CgjwTTGZLKsuC5IQTX0UwXVWX7mDDMAWTKVUdAMXAaoIvCznVAZNS3styhkec4E8tKN4tEe+OCZ57TS7JPdrZyVkoaurKD8sCgkEpAjjsDFv2XzW/aeiyvmjRiplVh7daEgH9M+/oxQzVBQGbPaSEIScyCZs7JwGT3Vz00dg0o0acBgXO/+L+e8lpp6aIBFY8Ygec9erUTbshusca+8jG+btsSJkHAkEigByxpcSSZwJdPSGLTfXge8lSwhmjZsuAZVg5JUSZo5A1expxKoyoz+7NWEkNtRRFCc8lrNJYj/L4Y4EMTb3dLyZCyBJpHQCFimcMnPpnAVx18aXOnBERjZwBPTBg7SSqudupCXjxmffF7OU5U1h+Bqp8clDpaWNnUtN6XgiL5+mXHto885NWkqOb8uRd6Oob1f10qzLbvASkk8giekovSRiA/WI8FBuAr10bV+JKig+nSEguoMP2s6P7+lpG9i9sAlUF1knS9lTJV07sbSEclDVKbrbke+jxP3Edkd5nHQtmz0GBzetMVQoA3Z1dqT+/bFRNcWOM5uMJ4AiR22E65TtPkebTC0W3ettNqn84Rq5vBRbDkDVBmsA2OyEmfhUp6KUC1TUDnvqUw14qlngD8/4lQKJdUdzpyNYc+yDDtkF1g93H2wq12wAuewZvbAdTRQj3y6cXkS19EdO7XSapcksdmsz7/QoGpQDFVx0hIn4DJ6qoqESrR17Trs/v1fkOPd1iw81kxGh9cf7oYPuz2tlWZddoH1e4KRHR6NeI4GjWDZgku6wWPiuVixEp/VRp3PzcXskV8SqumlPFVZcwQuI1TLZUqhAqEyaljYbbgUEq0W9ZkDyKKxOyxwaYwxQ4bCnqQGNlt8/cw56Mdv4qnQcBwgKAomE7MGVwoD98nsQie8XvsmRIsI1ZxRX9uEymj2wGWEakUlQSX67PkXgAefcOo2T25THxwaOx4Lh9ND25BNsMa+/iq+a+aDI4yvDhGWg7RycBG4snDJXFcOK0mC/tO1bBGfgurL0cA0+6AymjW4MuhBLjBsWFnB3V9ZHdq7F6uj70a+E3Naklce4ybig7/bjrNsgvV3Lz9s9w9S3aCAZQ2uBLpyU7hSg8Pxu1rWDRbl5KoHihugKh9T2TLJ61UWrgx/HS6ERmClmlKo/GS0HwRG4CLP6+iclpqFf+QJvP+Q7YGYzVaXSc2MsCjsD9bhoANwJYeE4X9evhjWw/lViNVNhYTqh9HjcN3O7s+SmXquYqjcbmyeyhEN7c4A/L6HDKnCy8Bjy867NMPQ99/VSrIsq2ClHknCM6zAFH049hOq/UF2wEVLIGApjMk+dHHFknExWmk1W0XncvDDmPG4PnUa0lgnZ/kZnc0/L6ZyqWpQrXJrWmVQib4bNQrJv++CnDYBZuGxaBLAN/bCj/3fxZEd1h8OZRWsZWPZnxKO46Fh9Fh6HKDZBRf/f47xwkNsgMK8fK20mitZij1v3ARcmzpVQSWTnypdpUDiJFzp7IbO6yOwmlAdq4Luz1SZWVmYwZFhoROTpTnubZA4YhTmvm89849VsCYN6Idv3FqoLu4Au0IBy1640kIiVJrImq7Cc+cwf/xEBVUqP88ZAUozZ+ESqIp0EfhFQVV1nspU/RgvXeZ1OBxnebXF9bEx+PiVl7WSzMtqy/e//09Y3ao9QQrDrwTJXrgkcN/YpgNeruGrRAWqBTGTCdW3CioByZhd0Fm4jFCtaVb1nspUA267G7jjXnUf0BxAliyTo0kMfA/97/2zVpJ5WQWru0crNW3wK4PUvTRTuFTXaAYuASuJgfssdx/E9HlTK6nmqYBQ/ThxSjmojGDJ0VG4iqFSMdXNg0o09LXeuPbHvzh8e0dyauGBv2HAX6zneLAK1n3i+jki3MuK+5Vey164ToaE4zMXd/z4+QitpJqlguxs/DjpG1xloH7apQHBKUmwawqXI57L1FPdbKhE0z4ahvhb7kGugyND6TovE8Z+ct/RiqyC9TjBSmZl7JGuUEFlHi7TbvEgX3Oa73mN7927eq1WUs1RQRahmjwVV7/9llA1RFpgOCR15dmAELNwydEWXNUNKtHWZSuwJCAKBfRA5gCyaBwZnqfT+Ki/9Yc0WATr/IWLKpFaEofDewiMNbhMYy7xWGf0UWrGPTtNtk/WHAlUP30zjVB9Q6gk5WVJot1UJ+EyQrW2GkElSjt9GhP8g1Hk6K0dglXUyAuj+/VFfmaWVlp5WQTr9NFjeJeVG894aa+ARdtrAtceHmVuyxxcGQRLEvvXJEn399O303BFeaoGhMqYbLcELoPnKkkRbgsuI1TrbnKgbknvt/LHZYKVZQ4gS8YvTKGrD777z0s4ttfyUmWLrX9o6w58zgo+EKLHbkJjDi7xXKZwGbvFrLDoGrUMWXmqqTPoqaaW6v7S6KGchqu9DoUClTuhyq5+UIle8vDBVXaFDoFFK2jmg4WvvI49K1ZrJZWXxdbfvmQ5xjVyxT7CtJvgWILL4LlMvBZfm8oKrSn3CAuysrBo6kx6KlOoDKkrDUCVThFuD1wCVYE+Auurqacy6p8uzQAntuHnN2uFVa+/jQ1zftBKKi+Lrb9hwU/4poEb9mkea5cDcB0LDcP9NQCsAsYIi2Z8h8vs/k4SqlTZ9MEYogQsJ+BqF6Kg2lDNoRL1dGkOhEQ5DpZbK2wY8C5WMR61JIutv2bWD5jRxAO7Q8KLoZLjHitwydSDgJXIuOyBag6WBJ6S3+DyN9/iBLt8WYmhcqEKNBbhkq7RFC6BqQQuBZUuHBuk+6vmUImeaegF6G91GKw8grXpvSFYNmaCVlJ5WQHre8xo7IE9IRHYSYiM3aFNuBj0Ho8yPDewukqgWvrdbFwkVMfpqVIYE0nKyuJEuwKNnXAZn/ljhGpjDYFK9KSLJxB2G8FybDWpeKyNAz/A8rFOgLVh/k+Y3tgduwlMHL/NdsMllf6bO6vtcmQF1ey5CqpjhOpUYAQkKW8K4XAWrjQ2TH4Ng0rUzcUVCI12IsZqjV/6DMDqb6ZrJZWXxdbfyuD9mwZNCRGhYiXaC9de6RLuuEutk69ukmdSL5vzPS5O+YZQNVJQFWcYJCCOwWWIuVLbsWvQRSLW3Y1Q3Zwbys7qEWmj4EiHwSrwaIOfe72ITd/P00oqL4utf2DrdsQ0bIRdDGh3EJod7C5swiVg8bUnWemdGzTRSqoeEqhWzP0vLpmBqjRcutJwlQNLTHveT7tg5IVGYJN7sxoHlehRAYtfDjXd4ABchR6tMbvHs9i3xvKdFYtgnTyShFE88W4G4jsIzY4gPXYSmhK4Qi16rhOMN3q0aKmVdPOloOK367yCytD9lYXKAJYc7YMrld1fXmg4Yj1qJlSif3DQgg56w1Z+gcYeuPj6IrfWGNfzaZzcf1ArqbwsglV44QKGCFi6MGwnOObhKu+5dtOOtg3C64GByDh5Sivt5imPUK3873xcIFRJhOpkkPYAqQ6loTIHV+knZ5hCxe6Pnkq6v+M1FKqM1DT0dWmMqxpY9sIlr7nMGGvI44+i0MpntwiW6C2CtZfxw9ZQvRW4TD0XPRYt3rcDht9xO3YvXamVdHOUl5GBVfN+pKeagqPs/hRUgZIITgPIFlz0WmWf+SNQ5YYypqKnqqlQiXat/AXDmzRXmyoUVHbCJf+/5t4aL3ax/nRWq2C9QLAO6gWscItwxSm4TD1XGPb7B+L7e/+MuUM/1kqqeuWlZ2D1gv8VQ3UiRI9kgUagchKu06xUgWpzDe7+jPr+s88xu7kfCgiWcbNsMVz88liCSza6QheN7u15tCKrYL3q5Y+ksHBsYZy1jXBtM4FruxW4fmVQu+WxJ/Bl71e0kqpWAtWaH39C0eQpSGT3d1weyUJvY0hZ6Rhc6pk/EnOxImWf5BaPmjf6M6ev33oDG1oFIk+CdxOwiuFqT7AEsLJgtQkCejyDh92sP/PIKlhv3Hs/UsIYS7BBthIu8VymcMlI0Rxccf4ByHj5FfRs20ErqeqkoPrfQhTRUxmhUlkFBSRWmDNwneS395x4bdX91Zx5Kmv6d3i0+nznynisUnCZ8VrnfINw9sGH8frd92glmZdVsL7o9w72dQhELLuRrfRQ4rUMcIUqj7XdAly7AkNxLPoWPMtGrUoJVGt/WozCyZORoEFlTP6mEu2awqWBZQuuE+1Ywez+ttXwmKqsVMpO/S1qb6M5sMQUXGUS7eb7hWDjb+7GmLf7aCWZl1WwFnw1Hiu8WxGmMGymx9piAtd2wiXzWwLXdg2unYRrl4JLj/2eLTHs6SdxjqOPqlDe2XSsXfQzCghVPIfRxwiL6VMzzMJFcErBVQYsgSqbo7/aBlVBbi66C1iBEQZ4rJj835jFWQL3C77BGN8+GEvIhjVZBet4QiImNWiEbQIV4ZJYqzRcOnosA1w72Fcb4YojWHtb+WHpv1/AfAaJlS0F1eKlKJg0GYcJVRKvwZgi3CxcAg0rzBpcBk9FqDxrF1SiJWNj8LmLGy7x89oCS0zBxW5RwALteUKZknBUK828rIIl6s9CtgtU4rXMwlXiueTWjxGunb7tkfHxMPS5/z6tpMqRQLXuZ0JFT3VQg8o08ZstuCRNeNln/pxozwpl97ddoMqpHTGVqT56sgdWe/oycC8PkSVTABIuBNmXp9/mK95q2R5HwsOxISTUClz0XGXh4vHYb36LV+7ppJVU8colVOuXLCNUkxRUkhHniEBFkGzBpR6FJ3CxGzd9WlkyocrURWBHLQrUy0oe43dBYJHUSVZirLJ2jnbCNxA9vGw/WtkmWB/3fgXHORLcwKB8E4/m4ZLpiNJwxYVEIK6JF74bPAiJsVu10ipOuenp2ECo8gjVASNUPLfKdOMIXOz6jHAdN4WqFnoqkaSUelI8Dgc2GQRLzF648ll/C9188PXrr2qlWZZNsJZOm4XlzVtiU1AENnJ0aA2uUp6LDbWjVTucmTgFQ56quMfui8RTbVy2ArmTJmE/R38JhErSggtYjsJl7BaPd2Al68Kxo3kzJNdSTyWKeeM1zGjSEgX88stOIpXxxg645CFSV1hXg/klXjdzrlaaZdnuLKnPSPgmwrOJ8cvGEPs91/Z2wUju1AVv//VvWkk3rtyzZ7Fp+UpCNRH7+CEPEyqVPknMSbiSWGkZukjEMaaqzVCJ7mZbysI+yR8vMBnNFlzyP4RE40474iuRXa96x9sfCeERWE+INrEhNjJgtwoX4RO4drDRt7m4Yum4sdi1cKlWmvMSqGJXrkaOCVTGJCQOwcVvqylUZ/Xstpu713qoEnfEGbpB9j5GkEzNGlwqvvILRjd3H60067ILrOFvvIljDN4FrA3iuRyAa2ubdiiMmYhBXR/WSnNOAtXmlb8oqPYSqoMmUNmCS2AqC5ck3ZUc9ALVrlre/Rk1pFt3LPZorW7jWExZSbjKQiUjwkIObGY2boFJfftqpVmXXWAdjU/EnEaNsF66QoKzgY1qhCvWFC424pZgk5iLMCrP5e6N8UM+Bq5d00p0TALVllVrkD1pgoLqEM8vO65lS38psORIgOyBK5GVeJbdX12BShQl3iok0rBT2wJYYmXhkr/J+2R3e0qi9fkro+wCSzSQQfIuvQEqgWujCVybrcHFmGurZyucW7wEwx97XCvNfuWcOYutv6xD9sSJ2MUPtp8DiEMEw5iAxGG4aEdYUWn6SOypQ1DJ42a+buCB86wbtUvbAbiyafn8mzwH3F7Z/cqPX3gBp3R6rGYXp7yWDbjkpnVxtxgUjAMRt2Dky7aHqabKOXMG29YKVBMUVAdYpspwE6hTQFmFi5VhDi7xVGns/hRUtXRKwZxuYf0VcKSeKUBpZi9c0g3ObeqDsTaSrZnKbrBOnTyNOQ0b4Bc2zhp6obJwbSgDl9y0NoUr1s0duRs2Yuw/e2klWpdAtWPdBmRNmIjt9Jb7WVbJbmv74Cr7zJ/DrMgUQrVXRn91CKr/jhih8sHKdEG6TKuUgctW/nnZ1PpXgpnlwH1f+30b1b+ZDw6FR2ING3ltObgksLcM17agUPzasSPG9x2slWZZ0v3tWL8RmRMmYAeh+pWxncoTEWy6ld8xuOJZgakCFUd/J+oQVCLxVnL7xtRb2QuXrHE/7heErg3dtdLsk0NgTRs9FvHt22M1G2odwXEUro1unriyZxdGPP6EVmJ55aadxc4NmxRU2wjVXpZr3LMocJXKbkM7aAdch1g5p8Mi8Ktn3YNqQu/X8LmLBy6x/lSm5jJQGc0cXDKBeolAfkJvtyjG8uZUc3IILNFw0r9RT6gIiyW4JObaYg4u/n+LpxfWrlqFM2ZGF9L9xW3ajPQJMYSqgYLKuPPHEbhUjKXZQVbYKXqqfTJPVcegEqmRoNy+MYHIkpmDS+a8VBkOyuF3DHnyGaSFh2EVwbENFwP5MnBtbtUWGV9/hS97Pq+VaJBAtSt2C9JjYrCFH2QXX1t2z6KA5QhcpaGq+WnBHdWLkbdikaxrZ9CuAnU7zAiXeKtCequ5bi0x8rmeWon2y2Gw8i9fwVQ2/C8cHa7RESxH4eL/1/L92SdPYOFno1SZCqrNhIrdX6xLI7WXsWRzhv1wmcZc+1lBJ/WRCqoTdRCquJXLDTudZd6qTMBuyxSEErQHR6qVEHY97quMHPdx1LudH8SZyAisptdao9MruNYSnHX8vRguBtyb2MBm4SIAu2+5DbGr1uDotu34dUcczrD728SYSlZFWN0QawdcAtUJeqr9dRQqkXRfchvGUsBuzQSsXHq55Z6+GNjlQa1Ex+QUWKkZmfiBF76KDbmWXqsELh4Jj024+LdNzX2QOmY0fj0QT6gmYAOhknuLxvXzlvYsytEYb5mDa29AqILqQB2Gqhfr5QfPNijisWyiXXtMPBxCo3AX27gwJ0cr1TE5BZbo3U5dcDY6EqtCbMAVRLj493JwEaJ1Lo1xYuRIrG/QSEFVdltZ+d3W1uH6NUCH4/pwQuVR50Z/Rs0ZMhT/kO4rNMKQt4uexxG4xFvl8T2LCWb/P3XRSnVcToN1rugCvuMH+IUgCVil4dLZCRePvu2xTRfB2Mu+PYuW4NrNyhOoDnq542QdhSo1PkHlfr3GL6kxF6rKhyrQ2AlXOmGUCVHZxXP10mWtZMflNFiiD/7WHRmR4Vipea0SuBig2wMXf99KYAQw4xLn4j2L/JD2wrWLlZZEOA961V1PdfXiJUQShjR2Y5mEQ/KhOgqXeKsLrM9JTbzxWfcbW5x5Q2CJRvDDbAsLx5pynqs8XHLrxyxc9FCGWz+GzRnGPYvG9fPm4BKwxOL4GoHqUB32VCLJR7a5dQDyOXgxZBl0Dq5CguXMvFVZ3XAJMyZNQXJbXyxlYxvBKgvXeofhoudiRQhc1jzXLlbe0TCBygMnc+suVF09vTHXozUus56KMzc7CJcK2IMj1NauVdMtJ621VzeOJtW3jR9OdYxW0w/m4JKb1hvKwSXzXqXhKlkoWNpzme5Z3EWoBK4drLRExlTxdRyqJ1j3Yxq1wDVCURYqe+EyBuyxPgF4zLNi8ppVCFipWTn4nqSv09FDmYBlGy6Z9zLAJcF86VWoBriKN2eYwGWE6rC3J07V4e6vO6Ea2VBSakciRVIssY7MpQgvC5e5Z/7IZGg02/BCfoFW+o2pQsASfTVgMC++PZYGle4SbcFl2JyhswKXyc4fVsBWVsphfSQSvD3qNFRdPb0wprEXgQhXqZaMSeEk5ZIjcKkuMCQCrxAqmaqoKFUYWKI+7Tvg7C3RpUaJxXCxmzTGXObhMlkoaAYu6Ra3CFT0igJVXQ3UZfQngfpcD1/V/aUQFkOi3RK4JOmu2YcbaF2lKVwSrC/39kd3H9ubUB1RhYKVfx0Yxw+9KyKy1PyWAkuOGlzmPZfsWbTkucIQGxKCQ/RUiXXYU6UeOqymFGJbB+IC68yQvtI0i7MBLsn2bM/TyjJpWQRLyqxoVXiJ6zZvxg7PpsUz8pbgEs8lYNnjuTazG4yPjMZRf1/UrAfVVZykm5JJy9OEJjeQUBV7JyNckntewCqBy+C5LMMFXaTyfkd27tDOUnGqeFSpT557HplBHbAkKNQGXIab1gou/m5tQ6zAlX9bNPbffz+cu3tVc9WLn/05AnAlNJLdl8RRhEZ5K1OzH640ggXWt0wtxLxk/zp2R1QpYIn6RnREflQEg3lbcJl4LoFLPFdomT2LrFjZ+bOOrvtYGCvLqxnily7TzlR7JUtfJLPLHE8/XGeAbd/DDQQuw8MNSsNl8FLira6zPr9q5IUXdVHamSpelQaWqH/Lljh7azSWl5k8dRYuuf0TSw8mt4AK/dtgd6f7kXn5ina22qWXIm/Fw4QqLSAC2fJYFkJ0mmA4+uQMU7gEqgv0/j97+aGzazPtTJWjSgXrPE3yPhzr2NH8SLEYLjmah8vcnkUZKa4L1CEpnBXn7orNb7+DC4ZT1nhN7P2q8lLzm7ell4omTOGGNJbqKN2gvXCV91x5fP3ONoGGxXuVrEo/w6lzuZjED5LQMcohuAyrUM3DpdbP8zWbxYMFhyJLp8N+j2ZY9VnNfGq+aN6IESo4/9TFA+eDo5BBL3WSwJimrlSZBgmI/XAZPJeMEHMY8B/yD1WToBcLCrWzVp4qH10q4XQqZvIDHYy2MMel498IjcBVfs+ijW1l/D2WcZzMc+XrQ7DR1RX/7TcIRdq5q7tkh7IA9Z6LK84GRSAnOFIlgLOUxdlg9sOVSrBy6N2PtNeraQV5/EtVqErAEh08fgqz+cHioy15LoHL4LnWOQGXJCGJZUXv5N8LwvRYzXNNe+ppbIrdpl1B9VHi9p34qFt31eWNdGmOdHphAeoUgRKPpFJWCkAW4FIpwvk6W3DJPJd0f4f8gxVUsrWuqlRlYInEc8lGjKRbOloI6AmXAou/OwHXdsK1na/bzAqXG9fpYXT/3t4Y1cwdn7/SG4cPJmhXUvU6FZ+ACa+/pp7j2IM2z7MNCnXRSOdoTxLqSi7UZA0qo1mDS8zao/BSO+hRyFBih2+wAjg/I0u7kqpRlYIlOpmdg6/4QdNuibYwFWEdLsNNa0tw6QmX3nBvkbaNFb6NlR3P9+bSiy1s2gRv89wDuvfA/NHjkJdXeWviC/PysGRcDIb16KEevC6ZWia7tsBxaXAO808Hl2QUlOMJSVkZVDqLs7Nwyf3Cq/SAi738cQfPWxUxVVlVOVgiuX/+kY8P8qMj8LMFuAxdojW4GMjbgEtMUlbuZMNtZ4XvlliDr8/Q67DCq5V6ulk3Wq+IWzC6z1uYx+B/7+q1yDpj//x+dtoZ7F21BguGj0BMnzfxcsStqjEfokm+hIXNfZHG8+fqIg0w8TokL5cx8ZsRLslL7wxchhGjwGToFgUs2QjxZSMvdHF1066y6nVTwDLq/ahbURASgBUEwXQFanm4TLaV2QGXWj9fDFfJQkHZnLGLDRdH20OT/Yen9ZHqAU6rfPwwpYkXBhMImeWWh6ULILJTpZP2uzznWp7OLx5I1pbL3yUR/2u04S7umOXmg1jfDkgPZRDOctN4Lcd5TZKX6ygBlzRKxXm6zMClHstiBi57HssicMmM+/WQSDWj/iJBvpm6qWCJRvV8AYe93LE1LKJcUG+Ey6E9i6ZwBWvr58vAVWr9PP8nto9/P8jXHOFrkkPpXdgwGWFRSNGz0VlmAl97hA1+gtCk6aOQRcukSe7SVF0E4QxHEl8nqSklCUkCy0xU5Rl+L5dRsALhkmmJrEBeF01yWFXWbRpHdNPBEq3btAmLWCGnOkaV6xpLw1WyIkLBxb87D5f5PYuylWwvvYuYPJXfNMONMnanahs/yztAO0STFJXGfBHqyPeZpk8ywnXUDFzmsjgb4AqzCZfBU4XjSkgUFnu3U3NUR3Zu12r15qpagCXKuHoNXwYEoiA0AKsIhuky5xK4eDSFi43gCFyObiszJiOxlj7pAM00CYktuMp7LvMpwm3BJV7qLH+WydSXCFSPCl5PdaOqNmAZNeWdd7GzkQsSoyKxhJWqZuatwCWz80a4BCoFF383biszBPQl28qcgcvSVn5bcCUw7rEHrqMcxVmFS01FmIBFu0Qvtc4n0HCTemjFrfysKFU7sERJGdmY7B+A/KD2WEegJLi3BddG/n2Tqefi77LcRuCSe4s3ApcCzAxc1tInGeGy23Mx3rIIFwE1zHOFIzsoAllBkfg3gXrcs2WFrVGvaFVLsIyaP34CfmEFZkSFYxnhKp2EpPyeRYGrVLcoUBEiQ5dYsvNHxVxqGsIIl2Hnj224BCpTuHQq1rIKF99nzCpoBEtMcqOWhcvSkzMErjPipThQGO/aUnmpldOna7VUPVWtwRLJqoUZTz6D+MYNkRQepvYvrhKoOAoTuBzfs+jYhlibnovdtV1wifHnUnDxb9Y8lxxl7uuSPhoLPP3UqoTh3Sr28TGVpWoPllEn84vwY9eHkOzWBIkEbBkbVxLtSrdobVuZEa7SmzMs7Vm0F64ynssGXOpnvs8cXDIlYc5zpfJzXNR3xE/N/dQUQv9OnW8ol0JVq8aAZVRCWjqWPPIYjjZuhORwPVaxcZYHGZ6aYQkuFdSXg0u2lZX2XKYbYq3BJV7rV763IuBSXST/JhOox3lMpyfOCY3EdLdW+C2BGtTlQadTCd1M1TiwjDp98TJW9PoPdjZsgGxdMAHSYQUbVu4zigczxFyO7Vk0B1ecKVz8vyW41EjRDFxGsMzBlcjXHuXxBK8rXx+Ffe1CMMTFVWU5Htmzp1OZ9KqLaixYRl2i/TJ6HNaEhCKjpReS9YSJjSxJ4daz8TfIcppQk4WCpeCS6YjScEm8ZRUumrNwqYlU/k+6vxM8R7bcTuJ7prr5qDzqDzd0x+KYGMMHq+Gq8WCZ6sDxE9j4Rh+sb9kC59r44LgulCNABvts7LU8ytP4N9MELpnnMgsXuySbcPG11uAydosClRzFU8ltoRSeLyc8GnHtgjHRtYVa8fBH2rhXXkZWStU8lL2qVKvAMtXu/YcQO2AgNnXsiMMcUZ4L7oAjISHYRc+2gY2/ng2+MVBnCOwFNA0umYowhUugMlqpmEvg0qwYLgGKr0ugyc3nNF0EssOisdM/GLPcfdDPpYG6qd3DvRUm9+2LlMQj2tXWPtVasEwlz6Bf991cbOvTFxtvvRWb2biZfq2RGRzI+CYY8ewuxTPt4FFyQ8hW/q0cmclSm60B9GQB9HyBNB7jCOMe/l9m5PfTDvH/R4IiVNx0kh5pZ9sAzGjmg/cZK/2d55Flx3/38sOY117F+plzDBdUB1QnwDKnOHq0NTGTsaH/QKx59HGsiorCksauWEcQ4tya4XALbxxv3Qopbf1wpn07pHVoh1Pt/ZHg54u4lj5Y08wD3zdogi/5+rdoMhPe07MN+tzXCZP6v4NlYycg9UiSdra6pzoLljWlFRRif3wiYjdswYqflmDR3AX437TZ+GnaHCz9YQHWLFqKuNhtSDpyFPnnL2rvqpep6sGqV6WoHqx6VYrqwapXpagerHpViurBqlelqB6selWCgP8H0vxXZO18UWEAAAAASUVORK5CYII="
    placeholderImage = syn.crypt.base64.decode(placeholderImage)

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
    local string = BBOT.string
    local userinputservice = BBOT.service:GetService("UserInputService")
    local httpservice = BBOT.service:GetService("HttpService")
    local config = {
        registry = {}, -- storage of the current configuration
        enums = {}
    }
    BBOT.config = config

    -- priorities are stored like so
    -- ["player.UserId"] = -1 -> inf
    -- -1 is friendly, > 0 is priority
    config.priority = {}

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
        local key = self:GetNormal(...)
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
                if typeof(s) == "table" and s.type and s.type ~= "Button" then
                    if s.type == "KeyBind" then
                        return s.toggle
                    elseif s.type == "ComboBox" then
                        local t, v = {}, s.value
                        for i=1, #v do local c = v[i]; t[c[1]] = c[2]; end
                        return t
                    end
                    return s.value
                end
                return s
            end
            if reg.type and reg.type ~= "Button" then
                if reg.type == "KeyBind" then
                    return reg.toggle
                elseif reg.type == "ComboBox" then
                    local t, v = {}, reg.value
                    for i=1, #v do local c = v[i]; t[c[1]] = c[2]; end
                    return t
                end
                return reg.value
            end
        end
        return reg
    end

    function config:GetNormal(...)
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
                if typeof(s) == "table" and reg.type and reg.type ~= "Button" then
                    return s.value
                end
                return s
            end
            if reg.type and reg.type ~= "Button" then
                return reg.value
            end
        end
        return reg
    end

    function config:GetRaw(...)
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
                if typeof(s) == "table" and reg.type and reg.type ~= "Button" then
                    return s
                end
                return s
            end
            if reg.type and reg.type ~= "Button" then
                return reg
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
                    if o.type and o.type ~= "Button" then
                        local oo = o.value
                        o.value = value
                        hook:Call("OnConfigChanged", steps, oo, value)
                    end
                else
                    old.self = value
                    hook:Call("OnConfigChanged", steps, o, value)
                end
            elseif old.type and old.type ~= "Button" then
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


    --"ComboBox", "Toggle", "KeyBind", "DropBox", COLORPICKER, DOUBLE_COLORPICKER, "Slider", BUTTON, LIST, IMAGE, TEXTBOX 
    config.parsertovalue = {
        ["Text"] = function(v) return v.value end,
        ["Toggle"] = function(v) return v.value end,
        ["Slider"] = function(v) return v.value end,
        ["KeyBind"] = function(v) return {type = "KeyBind", value = v.key, toggle = false} end,
        ["DropBox"] = function(v) return {type = "DropBox", value = v.values[v.value], list = v.values} end,
        ["ColorPicker"] = function(v) return {type = "ColorPicker", value = Color3.fromRGB(unpack(v.color))} end,
        ["ComboBox"] = function(v) return {type = "ComboBox", value = v.values} end,
    }

    -- Converts a setup table (which is a mix of menu params and config) into a config quick lookup table
    function config:ParseSetupToConfig(tbl, source)
        for i=1, #tbl do
            local v = tbl[i]
            if v.content or v[1] then
                local ismulti = typeof(v.name) == "table"
                for i=1, (ismulti and #v.name or 1) do
                    local name = (ismulti and v.name[i] or (v.Id or v.name))
                    source[name] = {}
                    self:ParseSetupToConfig((ismulti and v[i].content or v.content), source[name])
                end
            elseif v.type and self.parsertovalue[v.type] then
                if not v.name then v.name = v.type end
                local name = v.Id or v.name
                local conversion = self.parsertovalue[v.type]
                if conversion then
                    source[name] = conversion(v)
                end
                if v.extra then
                    local extra = v.extra
                    if extra[1] then
                        source[name] = {
                            ["self"] = source[name]
                        }
                        for c=1, #extra do
                            local extra = extra[c]
                            if extra.type and self.parsertovalue[extra.type] then
                                if not extra.name then extra.name = extra.type end
                                local ismulti = typeof(extra.name) == "table"
                                for i=1, (ismulti and #extra.name or 1) do
                                    local _name = (ismulti and extra.name[i] or (extra.Id or extra.name))
                                    local conversion = self.parsertovalue[extra.type]
                                    if conversion then
                                        source[name][_name] = conversion(extra, i)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Setup for the config system to start it's managing process
    function config:Setup(configtable)
        local raw = table.deepcopy(configtable)
        self.raw = raw
        local reg = {}
        self:ParseSetupToConfig(raw, reg)
        self.registry = reg
    end

    hook:Add("PreInitialize", "BBOT:config.setup", function()
        config:Setup(BBOT.configuration)
    end)

    function config:GetTableValue(tbl, ...)
        local steps = {...}
        for i=1, #steps do
            if typeof(tbl) ~= "table" then return end
            tbl = tbl[steps[i]]
            if tbl == nil then break end
        end
        if tbl == nil then return end
        return tbl
    end

    function config:ConfigToSaveable(reg)
        table.recursion( reg, function(pathway, value)
            local optionname = pathway[#pathway]
            if typeof(value) == "table" then
                if optionname == "configuration" then return false end
                if value.type == "Button" then
                    return false
                elseif value.type then
                    if value.type == "Message" then return false end
                    local pathway = table.deepcopy(pathway)
                    pathway[#pathway] = nil
                    local val = value.value
                    local type = typeof(val)
                    if value.type == "ComboBox" then
                        config:GetTableValue(reg, unpack(pathway))[optionname] = {
                            T = "ComboBox",
                            F = val
                        }
                    elseif type == "Color3" then
                        config:GetTableValue(reg, unpack(pathway))[optionname] = {
                            T = "Color3",
                            R = val.R,
                            G = val.G,
                            B = val.B,
                        }
                    elseif type == "Vector3" then
                        config:GetTableValue(reg, unpack(pathway))[optionname] = {
                            T = "Vector3",
                            X = val.X,
                            Y = val.Y,
                            Z = val.Z,
                        }
                    else
                        config:GetTableValue(reg, unpack(pathway))[optionname] = value.value
                    end
                    return false
                end
                if value.T then return false end
            end
        end)
        return reg
    end

    function config:Discover()
        local list = listfiles(self.storage_pathway)
        local c=0
        for i=1, #list do
            local v = list[i-c]
            local file = v:match("^.+/(.+)$"):match("(.+)%..+")
            if string.find(file, "\\") then
                file = string.Explode("\\", file)[2]
            end
            if v:match("^.+(%..+)$") ~= ".bb" then
                table.remove(list, i-c)
                c=c+1
            end
            list[i-c]=file
        end
        return list
    end

    function config:Save(file)
        local reg = table.deepcopy( self.registry )
        reg["Main"]["Settings"]["Configs"] = nil
        reg = self:ConfigToSaveable(reg)
        writefile(self.storage_pathway .. "/" .. file .. self.storage_extension, httpservice:JSONEncode(reg))
        hook:Call("OnConfigSaved", file)
    end

    function config:ProcessOpen(target, path, newconfig)
        return xpcall(function(target, path, newconfig) table.recursion( target, function(pathway, value)
            local optionname = pathway[#pathway]
            if optionname == "self" then
                optionname = pathway[#pathway-1]
            end
            local natural_path = pathway
            if path then
                local newpath = {}
                for i=#path+1, #pathway do
                    newpath[#newpath+1] = pathway[i]
                end
                natural_path = newpath
            end
            local T = typeof(value)
            if T == "Vector3" then
                local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
                if not newvalue or typeof(newvalue) ~= "table" or not newvalue.X then return end
                config:SetValue(Vector3.new(newvalue.X, newvalue.Y, newvalue.Z), unpack(pathway))
                return false
            elseif T == "Color3" then
                local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
                if not newvalue or typeof(newvalue) ~= "table" or not newvalue.R then return end
                config:SetValue(Color3.new(newvalue.R, newvalue.G, newvalue.B), unpack(pathway))
                return false
            elseif T == "ComboBox" then
                local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
                if not newvalue or typeof(newvalue) ~= "table" or (#newvalue < 1) then return end
                config:SetValue(newvalue, unpack(pathway))
                return false
            elseif T=="table" then
                if value.type then
                    if value.type == "Message" then return false end
                    local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
                    if newvalue == nil then return end
                    if value.type == "ColorPicker" and newvalue.T == "ColorPicker" then
                        newvalue = Color3.new(newvalue.R, newvalue.G, newvalue.B)
                    elseif value.type == "ComboBox" and newvalue.T == "ComboBox" then
                        newvalue = newvalue.F
                    elseif value.type == "DropBox" then
                        if not table.quicksearch(value.list, newvalue) then
                            newvalue = value.value
                        end
                    elseif value.type == "Slider" then
                        if typeof(newvalue) ~= "number" then
                            newvalue = value.value
                        elseif newvalue > value.max then
                            newvalue = value.max
                        elseif newvalue < value.min then
                            newvalue = value.min
                        end
                    else
                        newvalue = nil
                    end
                    if newvalue ~= nil then
                        config:SetValue(newvalue, unpack(pathway))
                    end
                    return false
                end
                return true
            end
            local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
            if newvalue == nil then return end
            config:SetValue(newvalue, unpack(pathway))
        end, path) end, debug.traceback, target, path, newconfig)
    end

    function config:Open(file)
        local path = config.storage_pathway .. "/" .. file .. self.storage_extension
        if isfile(path) then
            local configsection = self.registry["Main"]["Settings"]["Configs"]
            local old = table.deepcopy(self.registry)
            local newconfig = httpservice:JSONDecode(readfile(path))
            self.Opening = true
            local ran, err = self:ProcessOpen(self.registry, nil, newconfig)
            if not ran then
                BBOT.log(LOG_WARN, "Error loading config '" .. file .. "', did you break something in it?")
                BBOT.log(LOG_ERROR, err)
                self.registry = old
                return
            end
            self.Opening = nil
            self.registry["Main"]["Settings"]["Configs"] = configsection
            hook:Call("OnConfigOpened", file)
        end
    end

    function config:SaveBase()
        local reg = table.deepcopy( self.registry["Main"]["Settings"]["Configs"] )
        reg = self:ConfigToSaveable(reg)
        writefile(self.storage_main .. "/configs" .. self.storage_extension, httpservice:JSONEncode(reg))
    end

    function config:OpenBase()
        local path = config.storage_main .. "/configs" .. self.storage_extension
        if isfile(path) then
            local old = table.deepcopy(self.registry["Main"]["Settings"]["Configs"])
            local newconfig = httpservice:JSONDecode(readfile(path))
            self.Opening = true
            local ran, err = self:ProcessOpen(self.registry["Main"]["Settings"]["Configs"], {"Main", "Settings", "Configs"}, newconfig)
            if not ran then
                BBOT.log(LOG_WARN, "Error loading base '" .. path .. "', did you break something in it?")
                BBOT.log(LOG_ERROR, err)
                self.registry["Main"]["Settings"]["Configs"] = old
                return
            end
            self.Opening = nil
        end
    end

    hook:Add("OnConfigChanged", "BBOT:config.autosave", function()
        if config.Opening then return end
        config:SaveBase()
        if config:GetValue("Main", "Settings", "Configs", "Auto Save Config") then
            local file = config:GetValue("Main", "Settings", "Configs", "Autosave File")
            BBOT.log(LOG_NORMAL, "Autosaving config -> " .. file)
            config:Save(file)
        end
    end)

    hook:Add("PostInitialize", "BBOT:config.setup", function()
        config:OpenBase()
        if config:GetValue("Main", "Settings", "Configs", "Auto Load Config") then
            local file = config:GetValue("Main", "Settings", "Configs", "Autoload File")
            BBOT.log(LOG_NORMAL, "Autoloading config -> " .. file)
            config:Open(file)
        end
    end)

    hook:Add("Menu.PostGenerate", "BBOT:config.setup", function()
        local configs = BBOT.config:Discover()
        BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
        BBOT.menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
    end)
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

    --[[if BBOT.username == "dev" then
        gui.drawing_debugger = draw:BoxOutline(0, 0, 0, 0, 1, Color3.fromRGB(0, 255, 255))
        gui.drawing_debugger.Visible = false
        gui.drawing_debugger.ZIndex = 2000000
    end]]

    gui.colors = {
        ["Default"] = Color3.new(1,1,1),
        ["Accent"] = Color3.fromRGB(127, 72, 163),
        ["Border"] = Color3.fromRGB(0,0,0),
        ["Outline"] = Color3.fromRGB(20,20,20),
        ["Outline-Light"] = Color3.fromRGB(30,30,30),
        ["Background"] = Color3.fromRGB(35,35,35),
        ["Background-Light"] = Color3.fromRGB(40,40,40),
    }

    function gui:GetColor(color)
        return gui.colors[color] or gui.colors["Default"]
    end

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

        function base:InvalidateLayout(recursive, force)
            local ppos = (self.parent and self.parent.absolutepos or Vector2.new())
            local pos, size = self:GetLocalTranslation()
            local a = pos + ppos
            local set
            if not recursive or force or (self.absolutepos ~= a or self.absolutesize ~= size) then
                self.absolutepos = a
                self.absolutesize = size
                self:PerformLayout(a, size)
                if recursive then set = true end
            end
            if set then
                local children = self.children
                for i=1, #children do
                    local v = children[i]
                    if gui:IsValid(v) and (force or v._enabled) then
                        v:InvalidateLayout(true, true)
                    end
                end
            end
        end

        function base:Calculate()
            local last_trans, last_zind, last_vis = self._transparency, self._zindex, self._visible
            local wasenabled = self._enabled

            if self.parent then
                if not self.parent._enabled then
                    self._enabled = false
                else
                    self._enabled = self.enabled
                end
                if not self.parent._visible then
                    self._visible = false
                else
                    self._visible = self.visible
                end
                self._transparency = self.parent._transparency * self.transparency
                self._zindex = self.parent._zindex + self.zindex + (self.focused and 10000 or 0)
            else
                self._enabled = self.enabled
                self._visible = self.visible
                self._transparency = self.transparency
                self._zindex = self.zindex + (self.focused and 10000 or 0)
            end

            if self._enabled and gui:IsValid(self) then
                self:InvalidateLayout()
            end

            if last_trans ~= self._transparency or last_zind ~= self.zindex or last_vis ~= self._visible then
                local cache = self.objects
                for i=1, #cache do
                    local v = cache[i]
                    if v[1] and draw:IsValid(v[1]) then
                        local drawing = v[1]
                        drawing.Transparency = v[2] * self._transparency
                        drawing.ZIndex = v[3] + self._zindex
                        if not v[4] or not self._enabled then
                            drawing.Visible = false
                        elseif self._visible then
                            drawing.Visible = self._visible
                        end
                    end
                end
            end

            if self._enabled or wasenabled then
                local children = self.children
                for i=1, #children do
                    local v = children[i]
                    if v.Calculate then
                        v:Calculate()
                    end
                end
            end

            self._absolutepos = self.absolutepos
            self._absolutesize = self.absolutesize
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

        function base:Step() end
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
                    v[3] = object.ZIndex
                    v[4] = object.Visible
                    return object
                end
            end
            self.objects[#self.objects+1] = {object, object.Transparency, object.ZIndex, object.Visible}
            object.Transparency = object.Transparency * self._transparency
            object.ZIndex = object.ZIndex + self._zindex
            if not object.Visible or not self._enabled then
                object.Visible = false
            elseif self._visible then
                object.Visible = self._visible
            end
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
            local c = 0
            for i=1, #reg do
                local v = reg[i-c]
                if v.uid == self.uid then
                    table.remove(reg, i-c)
                    c = c + 1
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
        function base:GetAbsoluteVisible()
            return self._visible
        end
        function base:GetVisible()
            return self.visible
        end
        function base:SetVisible(bool)
            self.visible = bool
            self:Calculate()
        end
        function base:SetFocused(focus)
            self.focused = focus
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

            -- If only there was a better way of inheriting variables
            enabled = true,
            _enabled = true,
            visible = true,
            _visible = true,
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

    function gui:IsValid(object)
        if object and not object.__INVALID then
            return true
        end
    end

    do
        local a = draw:TextOutlined("", 2, 0, 0, 14, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0), 1, false)
        function gui:GetTextSize(content, font, size)
            a.Text = content
            a.Font = font
            a.Size = size
            local bounds = a.TextBounds
            return bounds
        end
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

        -- Moves a GUI object to a certain UDim2 location
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

    do
        local function step(data, fraction)
            local diff = data.target - data.origin
            data.object:SetTransparency(data.origin + (diff * fraction))
        end

        function gui:TransparencyTo(object, transparency, length, delay, ease, callback)
            for i=1, #ScheduledObjects do
                local v = ScheduledObjects[i]
                if v.type == "TransparencyTo" and v.object == object then
                    table.remove(ScheduledObjects, i)
                    break
                end
            end

            ScheduledObjects[#ScheduledObjects+1] = {
                object = object,
                type = "TransparencyTo",

                starttime = tick()+delay,
                endtime = tick()+delay+length,

                origin = object:GetTransparency(),
                target = transparency,

                ease = ease or 1,
                callback = callback,
                step = step
            }
        end
    end

    hook:Add("RenderStep.First", "BBOT:GUI.Animation", function()
        local c = 0
        for a = 1, #ScheduledObjects do
            local i = a-c
            local data = ScheduledObjects[i]
            if not data.object or not gui:IsValid(data.object) then
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

    local ishoveringuniversal
    function gui:IsHoveringAnObject()
        return ishoveringuniversal
    end

    hook:Add("RenderStepped", "BBOT:GUI.Hovering", function()
        ishoveringuniversal = nil
        local reg = gui.registry
        local inhover = {}
        for i=1, #reg do
            local v = reg[i]
            if gui:IsValid(v) and v._enabled and v.class ~= "Mouse" and gui:IsHovering(v) then
                if v.mouseinputs then
                    inhover[#inhover+1] = v
                end
                ishoveringuniversal = true
            end
        end
        
        table.sort(inhover, function(a, b) return a._zindex > b._zindex end)

        local result = inhover[1]

        if gui.drawing_debugger then
            if result then
                gui.drawing_debugger.Visible = true
                gui.drawing_debugger.Position = result.absolutepos
                gui.drawing_debugger.Size = result.absolutesize
            else
                gui.drawing_debugger.Visible = false
            end
        end

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
            if gui:IsValid(v) and v._enabled and not v.parent then
                v:Calculate()
            end
        end
    end)

    hook:Add("RenderStepped", "BBOT:GUI.Render", function()
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if gui:IsValid(v) and v._enabled then
                if v.Step then
                    v:Step()
                end
            end
        end
    end)

    hook:Add("InputBegan", "BBOT:GUI.Input", function(input)
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if gui:IsValid(v) and v._enabled then
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
            if gui:IsValid(v) and v._enabled then
                if v.InputEnded then
                    v:InputEnded(input)
                end
            end
        end
    end)
end

-- Icons
do
    local icons = {
        registry = {},
    }
    BBOT.icons = icons
    local hook = BBOT.hook
    hook:Add("PreInitialize", "BBOT.Icons:Load", function()
        if BBOT.game == "pf" then
            icons.registry = {
                ["1858 CARBINE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABHUlEQVR4nNXUTyuEURQG8N/LSEiSv7GzseMjkI/B3sqSvY/hYxBJsZCVwUIRamRnMyl/R2ia1+K+Y2YxmsHL5Knbvfd07j3Pec7pRHEcSwkjGMVSla0dByhW2frQg1sU8JZC7IkoxURacY1BRImtiEwN3wfcIMYmnn8avFaQr6IFk5jDkIrCbVjAPHI4w4lQiWPcpRD7A9UV6cAAhpO9v+pePndiJSE1jRlMoVdQN48dvGAVu3hKk/BniOI4XsQyur75Rw6H2BKUvhd6/9UfJUFIJMI5xht8k8cG9oRe30/2Arrx+As86yIjtEShjt8p1pOVRSmxtwvKl9GUJAgVGcOlyqQp4UIgnMU2rppDr3FkMIs1Yd5ncSS0yr/CO58sURmvjH21AAAAAElFTkSuQmCC", 50, 9},
                ["1858 NEW ARMY"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAABhUlEQVR4nM3VPWsVQRTG8d9efAVFBG0kpBIFtRRsAgpWphAsLIKVIH4E/Qo2phU7LawUG8HCSlEUJOlEsVKITUgUBV8iV3ksZoV1c+PdEO/FPwwMZ2bOPDzn7GyVxBCOYg7b8RST+Njasw378BDPEXxGf1jyIZzF7aqDyFM4j9NYwa4NXrxuuoiEuzgzYi2/+YL7zcCmDoe24sCQPfN18in0Oorp4yreDMg13wx0EXkDh+v5N6U329zBFSxhT2ttCU/wAm/xCR/wEosd7l+z3JO4hOM40ogHX+vkuxvxR1hWXF/GPcWp93jVRch6Rc7gmm4fyBwe1CIfK07/e5I0x4kkP7OafpLXSWaTTCU5mOR6kqp1fiSj2ZM7cdOfjb+CC3iGY1hQ+kvtXqenYaM0RV5UerHJLG7V85PYj73YoTT+eKgt3ZJkYUCZp1vWT9R7R17iQeU+h4m2fqXMTd6N3LUBVEkq5Q071Fr7gc3jl7SanvJPbgukPLr/BT1cXmPt+ziF/I1fmt1T3HjM+CIAAAAASUVORK5CYII=", 41, 15},
                ["AA-12"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABdElEQVR4nM3Vv0odQRQG8J9iKgXjDQQ7DVgknU1ICKkkWFmk0MoulT5BCh8hL5A8gyDYpEkr5A9RbIKVhSIIFjfR/FFvNJNizoXNYszuXgl+MMyZmbNnvv327DlSSmqOuymlzQbPVRlLxXW/+niAhYq+Qxiv6HsHU8WNATxDH44qBBjBQxzjZwX/OXTwDoP/8H2Mm8WNvpRSqnDJ/8JnWcFDsnLXCaeY7i6um3In+NRdVFXuGz5iD0/lRL8M51iX87iD73HxcdgdfMWZ/AnP8SXiv+0GuUi5s2D/Hh9i3ooAMIvlsNewH/YUboX9CzdibowB7AaBLpmNeLu/ofhXz4jkxRs8Cbsfw3KC90RurIb/MF6F/RqjaOERyl+g1Su5uhX8Rco4TCndLp29TH/ifq8do26HmC+odlA6a5fWrUZqFVCX3Cp2sH3B2ZWTq1uEF2OexHO5na3IZaOMkea0Mpp2iM0YE7gnV/U1/JAVbMu1sSf8Bjx4QyzAKlIYAAAAAElFTkSuQmCC", 39, 15},
                ["AG-3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABjUlEQVR4nL3UPU8VURDG8d/CqqgJ+BJDwLcYOqJiiDbGQkyM34HCxljYWNlY+Q38CDZWVBAa6NTE2kKlI6iFmqDeoBEJKK7FmRvXl724dyP/ZLNzzj5zzszsnJMVRaEmp7Efj+o6NuAhLnYS5DUWu46zuIw+fEQ/spKmXZXy3DqmauxTZhOfMIbDeF0lzIqimMQ8Wh0WHMMchroMqAmfsQs3pC74Xvo2JBVvR1ak3prBcofFRnGhQTAF3kkVfo9hrOILDmEldPtCtwd78QZHY+5V6MpnYQAv0Z/jHq5tEchB3MH52GykRhLHpBY8gw2p1XZHUptStddDuzM0vVLbf42E7v+WwB/kfv1VVXzAzbAP4DZuxXgxNm5FgKs4V/L9hoV4/hu5dJjq0MKsn4lcwXE8wEmsScm1GcTbZmFuTQ/uduE3Ee92P2cYj/GS1B5tBpsE+K/kOlxpFWS4GvY8nv9Fs4wjYW9LIj1d+JzCibAfV2jKN+C2/ZG6PJVuokuYrtC8kG6ZZ3jSXWj1+AH54FX7iZqi9gAAAABJRU5ErkJggg==", 50, 11},
                ["AK103"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAB0ElEQVR4nLXVPWuUQRAH8N+d52sQTUS4gGinZSpBBBsb0SLkQwg2gljoZ7ASsbCxEbGSCDYWWogWCr5Uoo0h0eRAFCHxDaMk3ljsJvfk4fBevPvDMjuzs7vPzPyf2UpE6AN7cQFbOvhVstyTRw1/8AKbS77zmCnZFvC2ZLuMO3iy4aKIuNThYz7iBr5kfRI3savDvn/hK5ol2yM0sJz13TiIKXwr+E1hVQp6Ze28SnRXkh9SFnfiUJaDxmNslyqzhglsxfOs78M46tiWbVew3G0g3WLFRsrM4o2UiFGclKj1EO9Ke1/jXpsz6xIrSJRexA6pIj/XvaIzmhHxISKeRcR0RJyJiPnC+t2IOB4RIuJaRKwW1s5lu4ioRsRoRIwUbAMbNfySytmQfq4FvM+ykcfvUpYmsT9n+zo+54zfwgGcyn7jhT1NLLXJ+EBQk8rUC7024UieT9tIh6d4qRXIxP9+YLeo6i0IOIyxPL/fZv1VYX5M4vXQUe1jz4ksl7S6SREPtCg0gvN93NEz+glkTmrFM1IHKuM7rhb0s1LLHioqg+2+6xiTGsbaezOHo/g0jMvoryLdYBGntV7vWa1XeCioDfHs21IrruOi9jQcGP4COQMMvMuv7DoAAAAASUVORK5CYII=", 50, 13},
                ["AK105"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAABwElEQVR4nL3Wu2sUURTH8c9uooKFIOIjguCrEJQ0NjY2RtIoQQTBzjJ/gjbWgoKt/gPaidiImKiF2gVtxCeSqPho4iNGjWKyFmcGbsZxM86sfmHYc7nn3vubMz/O3Van01GT1TiOBbTQh3yzhSRuZ/NtrMNXbMA87mJ5yd5X8QUrsQKnMIrJPKEfRyqIvI13yXgE57CxwtpuHBIvXGREvCCswit8TxNanWoln8NFPBBij2FtTbEpM6LyKX2isvfxIzvnAL6JLzmDW1WF/29O4AlmhVX2ZDF8wmRd4dNYk4zf4CkeYT0OF/IPCqvNYhC7hRWu4GUhd15UtSvdhM/hBaaS57X4jBOZ0E1Z7gVcxiXsF7ZKrbQdz5cS8zf0YywTM1V43i6xNvfmTZzEMmzFM5zGmSR3l38gfLjGui3YnMXjkjaVcacw3its0TPaNdcNJfF4yfyExT4dKslpRF3h+7Lfj7hXMv9T9P6cQc17/iLqCm8Jjz/0ex/OuV4452jNs8oFNLzytwlblDEgbrz8ZnyMneISaUzdisMHfxZNdKWxZLxD9POe0ER4Fc4m8XvxJ6snNLFKVa7hBs7jc682/QW/sHjrCuQ/hgAAAABJRU5ErkJggg==", 46, 15},
                ["AK12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABtUlEQVR4nL3Vz4tOURzH8dczHiNqhAgbaWpsxXL+ASmSlWyYrZ34I5Riwx/AwkZJSZSm2MgkC81GslGkZkZjZsiP0eNrcc7tua7b47mTO+/6ds+93/Pj+z3fzzm3ExEaMIbrWMYrfPlH/07lfQ/mULfovdz/54B5H+AqpquOLg7nCfZic8U/X5l0EmcGx75mlvQT/IavmKj0eYZe3eBORCxie0vBNeGaFHzBFO7jkxT8KE7hjbTBBS/xriuVukjkFxawG++zzWZfYD+O5PceXmfr4jh+YFP2z2JGqvYw+n0oyapgGgdy0EvYKFXqMxZL/VawLCKeROJxRFyMiJ0RMR4RYxGhYhPR53tEHI2IbRGxIX97WvLfqRnfmhUVgUfSYfqYrY6yBG/jBbbk3ZrKFZvM/oNDVOG/MYK3kg53STfRIE6W2jckGX7Iz5tSYgXj0gWyPjQs4UyWTS8idtT4t0bEakleZ9dLWiMN8z6Hy7jrzwNXsCJdkQUn1ri/jelEsx/iMFzAldxexT79c9gaTSsyDLf0r9FRnG9hjb9oI5E5KZmCY1JCrdJGInAJz3EahySJtcpvOtqVG6/0I4sAAAAASUVORK5CYII=", 50, 13},
                ["AK12BR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABoElEQVR4nL3VO2tVQRTF8d+N9xLwGXyAIrEI2AhWwc4PIXZ+AEH8BlaaJpZWWtha2ViJoIKvSkNIq/gqjPiKmqeFSLIszhw8Xm/IjYn+YThzZs8e1qy9OaeVxDrYhktYxCSW0H1Aqzx7rR/EByz3OLuFlVXOqjmHMdzuTm5jtMz3Y2tXfKaIrjmO0z1EbAbxp/BuruNHr0AryRx2bbKomn7E1VwsOs7gvMrUASyoKtjBWTzHp0beU7xv46PfL7KIHZgt8yeN2AFVVWo+4y224Ci+Y7DEFvAY34qItZgsOfcxj504jOmisY1rKmO+NPJmMCvJo1RMJRlPMpxkNMm+JLrGkSQrZf9yklNJOklaZW0iv3jWI/+fjXajTDdwtzgwvYprzVa5h4cYLk6OYQ+OlfhIcXWhj2psmAFV2RRBE2vsP9GYX8Y7vFa12AXV5Wo6OLkZIvsiye4kI0mG+ijhg0brHOoR355kvrHnZZLB/9FaA/haXJ3r495XcAcv8KZHfAlXG++vsHdjVvdHK+v7IdZ0rPI9xxBuYhy3/k7W+vkJAjiOxDLReeUAAAAASUVORK5CYII=", 50, 10},
                ["AK12C"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB2ElEQVR4nM3Wv2tUQRDA8c/lzh9JwB8giIWFooKVINiLhZUI6l8g2NgIYm8rForaCDYi2FpIChUhplAwQkQDghaKP/BHjBBOg54kYSx2jzwvOfLu4YFfWNiZN7Mzsztv36tFhApcwU+0MJF1xYVqhfly+hp24iPms65esH2JyY6Yx3EYR5ZLqIHteb4xj07eYaEgr8PJ7Nsv5gvrz6KJOdzr5lCLiGZO7n9iHDekDQwM4SheSBtb5BN+NPBF90Ja0k5MF3Q1bOshqZBaaA5rrNx2MCB1SrsTBjGFQ3jVsf5DzDTwFbvyouM4i73ZaATvpeNtsznrVmf5Al7javabwCgO5Oe/sXXleksxJL2bS2ifCIzhGu7n0Y0pqZAdWf6OJ3newlN8KNivxRZ87j3vJSxbBOkIp/L8kb9bqBu7LRYxiXN4I10U09iHxx0+e3pIthIN6SZYJbXKWAmf4vX3TOr9mQ6b5x3yQdytlGFZIqLXcT0WOd3FZjAivhXsZiNiU4VYpcdAhdpPYD8u4k4Xm1+4XJCHcaZCrNLUKn7Zy7Aeb7Ehyws4htv9CFblRMrSxKWCXMdNi38S/5Z+9m1E1CNiJL8ncxFxql+x+tlabYZxC+fxoF9B/gAcy5p3z7j4hwAAAABJRU5ErkJggg==", 50, 14},
                ["AK47"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB4klEQVR4nLXWzYvNURzH8dcdkyyIwZSVEE1CWUnyUGZjYaE8LVAaf4O1v0GZYmWhPGwkDytFVsxGDTbKU0kieahhPN6Pxe9MruvOg3vvvOt0Tud8v+d8P+f77fc7tSTaZBm2ojZD+35sLOMVeIFFLex+4iJeNcx9xNMWtoM4iiO9Mwyimc04h9Vt+kNdFexbDJT+AzZgG76X1ot52I7nTXssxA2oJTkzzYHvcRdfsBjrsB9rOxAxwTi+YgG+lcAX4h3uNNitVIm9Unwm2FX6kVo6qK0uUscnRFVGwxhrWO/FfHxWZW6C5arSvt1Oab3GiOo25pW56yWA+ziAPtUNTnAZx1VZ3YmluIWXRUDHTCekjicYxT3cxMOydg27y/gCHuEB1qvSvwY9ZX0VnpXx+W4E/g/5m3qSB0lOJtmTpC+JSdrp4nMjyeJi25dkSZI5Sc427T0wxV4dN0lGkwwn2Zekf4aOPUlelQB3TWIz2CTk6mwLaadtKcF9SDJ3CrGjTWKGZktIz/TF15JNpX+k+mS2oo4h/GiYO4UdbZ45NR3cwrIka2Zgd6IpK+NJDnY7I7Vk1n8jc3AJexvm3qheBWMtPdqg3dL6H37hkD+f3eCYLopg+v9It/iGw3is4X3UTX4DquzM63GDCPgAAAAASUVORK5CYII=", 50, 14},
                ["AK74"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB6ElEQVR4nL3VO2tUQRTA8d+G+CZiwGJFfKGRFIJgI0QFG7USQQQVIb2fwMavIIidhZ1WKmIrGjExvg1YKBqSRgxEUBIf+CDosZhZdt24N8lu1j8Md+bMmTmvuTOliNAES3ASy+epX85tDdZhDJv/oXcPj+pkbzFaJzuK3ThTEZSaCGQVruPQQhfWMYRl2IEH2IQNUpA/a2w9RX/d2mOYwc2KoBQRF9FdYHAML9CB7ejDwRaDKGJINZAuqXJP8CPLVmCPlISp7NtAKSJG0dNGxyr8lpIBgeks+4Rf+IxnuJvlsrPl/K0cr30YRwkf8AWTCw1kCgPYgl1ZNozn0tk+jiN1a/pxA99xAu9xXzXDi0LnHPPvpCyN4A4eS9k7gFtZ5yXOSz/lRnzLDpfy/FZ8zf0ri+T3bCJiNKp8jIhrEXE6InoiQoPWl/UnImJtRHTntjoilkbEcM2egwX7LFrrlG6MSznjI6rns4jD+XtVOqf1DEqXAuyVqjLeUsbnoskMvMrZ3t9gvjf+5nK7K9Ixd6iz6FJ9CN800HmN2zXjU6pVbAvNPIgVypgsmN8m3fEr83hCevymmzVYRDMVqVAUBOkhPVszXo9zLdgrpJVA5sMFPMz9GSn4UmP1FvgPV2NvRAxFxM522vkDiYU2tM7CwnkAAAAASUVORK5CYII=", 50, 14},
                ["AKM"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAByklEQVR4nL3VzYuNYRgG8N9hRPIxvhL5iBkLSoxiNdmyUKLE0s6S8gfM/yDZoFmwkIkpJVmPBcIkUcwsqJlYTONjfEeXxXnV22nmOM6cM1fdvb33fT3PdV/389RTSaJJdGMX5jXI78IGdGIdXmHVNLz3GKjJPcfbabgXcRN3OhpsohYHcAVrmlwPvapmfmArXmO+6oAO4XvB+6xq4nDBLeMJvkAlySX8riP4EQ/wVXWSO3BcdbqzxVSh3VnoVLAMT1VN/sX+ouHHpVwHjmAY5yqZxd1qIabwS/UURnG1pr4QSzFSylXQg/sYa8bICJ7haCk3gHd4ibNFU9tK9b6iuU+qpzmBexj/T+2ZkX9jPMm1JKeSbEkiSSXJoxKnN0lXURtKcr5mj8tFrW0xnZHRJP1JTibprrP4dsG/kKQzyYoiVhdGH5b2nEiyqN1GhosJnkiyvsGFS5J8K5rcPgPnTM2A+tptpJk4VjT3og5nZZLJkpGfSfa0y0ijj1kt9hbf4TqcSZwu/S/AIDY1qVkfs5jCxiSbG+AN1lyxsSQ9rT6RStL2Z2Q5hrCzlLuLg60UmQsjsBa3sA8fsBtvWikwV0ZgMfpxA9dbvfkfBORvDGB21QAAAAAASUVORK5CYII=", 50, 14},
                ["AKU12"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAAB6UlEQVR4nLXWz4uNURgH8M+duSYjl+GGMikWUpIkCwtloUw2FjYWs7CzsPc/2FhZUFYskDJFyUKmLJUoGwkzSiPSNIQZLuaxOOc2r7d7x7g/vnV6z3nO8zzn+XnOW4kIHeA8fuIXHqGopJK/rWhF+g7MZD1l/nlMYg4H8Lp4eLUDg9fjDFZ3ILtSfMcURlptViUPZ/Emzz9hQ4FnEZ/zvJYV9dNg2Z4n2I2zeIcGFjBdiYgGxqVULGd0HZektPYb3/AcG7ENqzJ9DrOViFjAcBvhYRyXnNqHu1Kt3Szw3MErXMMm3MPbfFgTu/BRcnwxDxi0VO+/paA119P5uyfvNTL/lIhYiAiFMRgRRyPiSkTMRMTViBjL9CbP41jCxYg4FhFDETGSaRPxNw6WzuhqVCLiR/amjpM4gWc5crelTi5iXY7akFRKh/E17w1gLXaWsnEal9tk879RzYdP5nTcwH6pEdphLMvAC8nBMsqOHtJjo0fx3lKd/QtHCvOnbXheSh2/tYVM1xjIyldqMEzgvvSwPGzDE3hQWI9ibycGttbeeUPUI6K2zP54qRnP9bIRexaAEmpS2a3J6w/YLr12XWGgWwXL4AtuFdZbcKoXivtpNOnHqpnKeWzuhdJ+lkcT16Xb5IJ0v3eNPxBaj7M/EmAxAAAAAElFTkSuQmCC", 45, 15},
                ["AN-94"] = {"iVBORw0KGgoAAAANSUhEUgAAADEAAAAPCAYAAABN7CfBAAAB00lEQVR4nMXWv2sUQRTA8c/FOz2jIIrBgNgKIqiIoILYWdj5q7NRRERs0/gf2NiksbCyTyOCheRiYaeCgoLgryKiiPE3Mf4ieRY7kmPdu9tL9vALw86bN+/Ne7tvZ6YWEUrSwD7sxhN8KGtYwBr8TP0aIj0X8BwfO9idxdX8YL2Pha/gTB/zl8op3CkYX4uT2IMd+IYNGKtFxDWs7uG4gSOVhdmdB/79ygfQxCP8wjDeYhPe1CJiTu8kBslvzFksq9f43qbfKgt6AufwJe+gnpx0S+IpLmMXzreNT+AWPuM0DufsxjEq+4+GMYOXspp/gWepPy17u53YidlkU0xEzEYx9yPiREQMRYSIGEvjXyPiQkRsi4i9STceEfM5++NJN/AmIuZyi7ci4lDB5JtJfyPJIxGxPrUtEXHxfyXxt5xW4Tou4W7BB1uJg6nfSs+ZNv0n/MjZrOtSIpVSx1G8ktVoJ/bL9nYWk8jzLiePLC+08tQxVWJeA/ewGY87zMknMbqMuPqi7GE3mVpTtg0WMZ2Tty81qH6pRflrRy9WyLbCZpLfyw6jhaoW6MRQhb7m8bBN3ijb4wdOlUmQlVw7xyr2X0g/F8AyTMnuWK3Ublfsv5A/SBySI+YtT1UAAAAASUVORK5CYII=", 49, 15},
                ["ARM PISTOL-ALT"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAABtklEQVR4nNXWPWgUQRjG8d9eLgYRFawEFSUoNjZ+FCksFKy0UXvRxt5GQVMKQoqUgq2lhTa2WtgkNrGxMKJEERsJSoKcBj94LWZP7ta53O3lRPzDsLvvvDPvs8/ODFtExH280p8Wbg6QV+U8HmAf3g4xHiZwHI/bgSIiVrFtyAlzPMeH8n4vDmAFr/Gm5lyBAg3cwaN2x98QXpeQXqx6D2vYhP24gLl2RxERa9Kn+B9oYRGbm/jm3woPLOl2+qvkNhzEHmmZLOMzxoqImMfUCAQ8LIs9wyfJjGvY3WfcF2xZp/8uDpVz/d6cImIqIlZjY8xExHhEqLTZTO6liLgdEUfLdiYzrm9r4ikO47p0ZPWigZPSLu/kI27gZx9n2yziBRbK58kBx3XRLK9LuDxA/gq2Z2I50RM4W4ktY4d0nk+W9ccHEVql2T+li7FMrJfTV3S72cIxvKtZM0ujZn5O+I9MbCemK7EZIxJNfeG5L5QTfgtbO57fY7ZmrXXZqOPfpXXbyRFcrMSuSsfeyKi7xuelH7IF6WR44k/Hp3Ub8hL3hhXYiyIiRj3nLpzDaZyQ/i9OjbrIL+XD/twN05nXAAAAAElFTkSuQmCC", 46, 15},
                ["ARM PISTOL"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABmklEQVR4nL3Vv2sUURAH8M95hyIo0UKDwVIQLCQBC8HKv8BCYmVh6R8REAVtLCwtFETQ1l7FX6hFtBAiClrZaIJVTM7EcNw9i7eLy97e5d5u8AsDM/PmzXxneDvbCiHMmwyPsTZhLNzAQxzEV/QS7ub4g83caIUQ1rC/RiJYxo8RZ8cwVTNvjmu4khudhsmOZFIHP3FPnHi34F/HFu7iEGbRJk52C7trFvwfCFhFuyN20YTsLwwy/QBaE95bxdNM7/r3pgfiRM/jGZ7kOTt4jnMNyH7CmUxfwD5M49I2977hwoizU3iPN3ibO1shhBNYzIqkoouj4nSLmMWHku+quE1eYY/Y4M2UYh18xlncwsyY2MOGG/pYQXQv7pd865jDCo6jL661NIQQJpUHYRivK+Jul2K+hxBOJtQZKbsS+mpX+AYlex6XC3YfF7GUOMNKNCXbL+hTuFM6v44XqaRGIYVsVWyRbE/ciUU8SmY0Bil/sO2ewYb4Ec7htLgrv9SnNoymZJdLdg/vMtlxpJD9LU7qZUFWdpzRGPwFoGrg1hC6LbEAAAAASUVORK5CYII=", 43, 15},
                ["AS VAL"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAB/klEQVR4nLXWzYvNURgH8M9ljPFOyk7IAiVNFmpQNBYWykZZWFlY2vMH2LCgrGZDyD9gIUpWRhQ1SixFSCJvM8Zr92txfpo7v5lp7tyZ+dbp/s5zznOe1+85t5HELLAZ+/EbS6pfWIRRLKtkP7BxEv0tWI5VGMLpDnw4hv7GLALZhzuK09PhuxJUHU0sqMmG8XcGfnRjWRc24YuSwV/VwRvwBn+q+Rqsxlpsw8FKr50goGsKeT0IWNHmmRMMPMB7xWloYAfe4hMW4nM1RpVSwsPaWSMtZ6ww3vnFLd+/8BSP8dHEZHRUEUleJGkkUY31Sd4lOVnN1yU5k+RJkqEk95PcSHI5STMFf5OcT9Jb6QxkPJpJTlTri1pszdnownO0EuU1XmI7LqAfF9GnkLY1E0eV3h/BT6VFu5XK/URPtbeBm3g3g0zPCAuwsibbpNwkB/AIO3HJ+CBgjzECX8cAvlayqzhb279xrpyeFEk+J9ma5FCSa0keJjmepGeacp5taZ3dtbXFlawVx+ajpf6PRpJBpeSvcAt328zBoFKVpvIOjNTWe/DNGJnP4dRsEz8VurC3Q93/Dr40MQgKR56ht5r3dWinLUx1v7eDKwqJPyhca06y556xQHYp1/LwLGxOjfns2ySHazw5Mp8cmZcEVViqPH6Dyt+Z28ojOOf4ByC7Nc+GCt/WAAAAAElFTkSuQmCC", 50, 13},
                ["ASP BATON"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAMklEQVR4nGP8////WwYGBhYGBgY+BvLBZwYGhpMU6L/NwMDwiUy93xgYGH4zUWD5oAIA3Q0Jetjcu8gAAAAASUVORK5CYII=", 50, 2},
                ["AUG A1"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAAB4UlEQVR4nK3WO2gVQRQG4O/Gi0bEB0lhESvFJkpKG8EmpSCIYDqbNBaK1oKFdsFCESsbIWDhA0QIIiLa2FpoiKYwEoIQUBM1ilHzOBY7S5Zlb7ivH4bZ/c+Zc3b+OTOztYjQJkZxqcR9wr8K3yWcajdRjnoHYxfxscQNoIbJAteDgziEqQ7yqXWgbBW24CbOoRh4F85iP+7hZTvB6+jFGM7LVOkGlvGlgt+HF3iEp4lbxc8GcVawjt+o1yJiCoNd+sh2MIsPDWz5x87iTy26XAdNYk22ikdkdf+tmUF12e7d2kbCv3iCedmSX8Tugn0Uv3Adz/EK35PtKI7hdUsZI2Iu2sO1iJDatohYSPxSRNyPiJ2JHy/45e1B8t1RYWvYejaZx1fMYRxDSaWysjmuok+2vIM4Lds0xzFREbs39f2dKrseEbcioi8pk89spuR3O/EDEbGauGclNe5ExPYKlaaTf3+nyl6RnZOLJfXmS34HUj8iO1/hbsG+J41frsiRK7vWgq6VN1ij0+G9bGPkOJz6oQI3U3gewcMGscZkF0XVRBqiFhFnbMw08BifK3wv4EaJ24uTGE7vKzZqewGXtajepmihZobLx0FEnGil5jptrfzITOIHpvEGb/Gua6o1gf/niwh4NmNiowAAAABJRU5ErkJggg==", 43, 15},
                ["AUG A2"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAAB8klEQVR4nL3WT4hNYRgG8N89M7gsZiFpNJli1KXZiY2GBWVxi1KUouwkZWNjQWhiYTULsmDLQpMUZSeWCqWU/6WYhoxkxr+LOBbfuebMde695869PPX1nvN+73nf5zzn/b7vFOI41iZ2oII7eNMk9jD6sL/dot3tJsBDLMMQFmIP1uEH5mTYd3iMa3gx26KFRPHVOI75s02UQiQQXI8y3qbmluIVDmArdgsvUcUHZLVAAUV8w2SV+DAOYW4HSP8PjKNSiDvQ5G3gl/CFzgtr5LJsxWP8xHdB9e5/TfwjJrAAvQmBMXxN5sawApsFJXMjwus2iD3CWqF3izhXMz+KAWzADSxCP0pYgykMoqfVwpEgfzNM4laG/wLuCspF2JT4n2InhpP7Mk7hfZ38i/PRnUaj7fAlTgs7xFmsxO0GBU8K6sIJXErNbcSZjBpLElvMyfcP6hEfwRF8SfkmMuJ6E9uDfcn1Z1xJxZTwTFhctehP7FQesmlkEb+Ogxn+8aR4V8q3KrFbTJ8BV/EpFbMLF+vUj3IzrUEW8b46sRU8FxSsoiS00kDKF2F5ct0lHG5H6+TchnlmHkK5UIjjeMjMHnsinG5ZGMX2Gt+gsFuUGzxzr1ViTRHHcSvjWPw39raYoyOj1Z+s+8JP0oPUuNlhLXPhN0TD/Cfdw9YjAAAAAElFTkSuQmCC", 46, 15},
                ["AUG A3 PARA"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABuUlEQVR4nM3Vz4tOURzH8dcd48fjRxNqkNnIQspCVmJtY2NhY2EjG/kDsEH8D5YaZSGKSJSyI03ZkC2P1BBGTDLGr3ws7p1xezzPzJ2nWXjX6Xw73++953O+55zvKZJYJJbhKF7gGT7VfEXNrk94ButxEpOzwZWoAnuxok9BW3AOmzomL7qH/8PHStysqI24iP19CurFLwzOE/MV3/ED19DGSJFkEkOLLKgffuIsNgz6PwTBAzzH0yLJtP7PEtzCK0xgGw7XfA+VZ63AKO7hPnZjH75gRy2+wFtJXqZ/7iZpJVG1EzVfO8nparyV5Hotbs4230Ecx1rlFR/C9g7/O0xX9ghOVfYY9vh7/Q9UGW1Gj0x9SHI8ydIk5+fI1J3aCi/Xxo91rP5qktVNM9VN1HiSrR2BR5J87iLqceVfk2SqGvuWZF3t2+Ekl5oKSmKgS/ImlVW5zih24gZu18aXVP0urKzsJ8piOMMhXGm8dcriNqa8ijM86hHbxsHKnqqJgOX4jYFK4E1lQYQWLixE1Mwzs1DayqflDTb384O56LZ9TXhf9cOav2+Nma8k9OK1MksTWKUsgovGH0jxzXyX+j5jAAAAAElFTkSuQmCC", 37, 15},
                ["AUG A3"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAAB40lEQVR4nMXWz4tOURgH8M8dP0JMo4QmWWEos5HEQmgUUiglsmL+BmtLK5YWxMpikjSWdrJgZWb8KDbMLCyIoYxpGPJYnDN13e47c98x8a2n55zveZ5zv+9zn3PuW0SEBcQ9dOJAw/hBnGi6+eL29bTcpw8H8Sb7chWKbDOIbNtwBPfxa66HFLmyXTiPJfMUexa9FTFFi9g6PME+TM4WVETEIVzDxnYV/iV+YqI0H8YX/Mjzbql47/AMm4tY4KZtAzPVH5eEPsT70voqqb0mpMr3/k+xH/Eat3GlSUKH9Mvmi2GpX/uknh2trB+XqncRV7EFizK3QTpgexs/LSLGYm5MR8RoDX8sImTrjoipzI9ExLnMiYiBiFheihURS3PsUIVvabNdXeO4i2+4jJ24U4lZWxrfwDKpF09KrxjWSQdnqpLblX1n08K2EnsTF/CpxNXdFuuz34XDefyoJBTOYKAmd1P2EzVrteio4QbRXxEKb2tie7I/XeJuVWL240FN7kyh5vwYVBPKWNMidgxfsbLEbc++p8RNY3Ueb8WrFoJe4hQ+N9SqiIijWFHihvz5Gst4jN2l+XdJfD921MRP4hI+NBU0K5qexGzXa26EPW3uMW9r94/MiPT5e46neCG1xz/Bb86uexoVUGNgAAAAAElFTkSuQmCC", 43, 15},
                ["AUG HBAR"] = {"iVBORw0KGgoAAAANSUhEUgAAADEAAAAPCAYAAABN7CfBAAACDUlEQVR4nLXWO2uUQRQG4Gc1qy6KEu8oCGqTgPYWNqKFgrWXH+AFhCjWotgoiJhK8AekNIWVgiKxULERNAZsVLzgLfFCNDGSsGMxs2bYfCab3fWFYWbeOWe+c+Y758yUQghawCm8w4M0X4IJLMR3dGAKF/Aal1v52L/Q0aL+HSxGFzbhIioYw4dMbgMeo4p+0aG2oRRCKOM8jrdpz6W4jqcZV8EvHMEKnEAtBMbxO5MtY7JgXMOyxP3VKYUQBrGtPfY3hIBSNn+EbixvQHcUi/AcI/iE4VJoMSmawISYO6dxA2+TYWMN6q8X822iRnTgvRiz88UX3MIwfuJMtvYQvejEJVzFkBgGozgrht3LJF8fMrPh4wwmhPAmzI1qAbc/hCC17owfCiGcTPyOEEJPJldrUyGEmwV8U2226vRC/MX9GMC9uvXx1C9IJ13T2S5WITgkltcclaSzsrGDnxtFTkziHK6YrgCrCuTWpX4fdqVxn2kHymI4fa7T2yom9o/mTJ6JIid6cK2O+yZeWrn82tQfzri+bLxXzJl6lFNfLVhrCkVOVAq4qljONmbc5tR31RnVKZ70QRwt2OsVDqT92oJSCGGnWPKINfy+rHxluI092fwuduOYaYdyDCj+E21HaR7XRK/4VqphBGvabVAzWDAP2cG6+WpsaaMtTWM+D8BBfBUvrWd4ovFb9r/iD1BPGUL5VqhSAAAAAElFTkSuQmCC", 49, 15},
                ["AUTO 9"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABPklEQVR4nL3UPUtcQRjF8d8uuwYiKVTWQlzBRkk6Y5UUAVPapQvJJ7HTzsoqYG3hV4gG89JKlmAZEQKGVCoqmBgtlMdids1wUUHXm383Z+6dM8+cZ6YSETI+YAR72MEPzOHE9YxhGNuZ1ovjbDyKASxiqpKZNvEFgzjLfviKoxtMX6CBjUzrw2E2/o0ePMFaJSKamMVjPLth8W74iSrqWBIRgxHxPv4PrYhQwwP8ko60VtjhjpTNHym3/vsoO890GW+yuQW8wzhW25trSU0yIzXZbfmL73llE4UPGlIWQ1IW51J3z2P/DoaXdCp9im+FuWns+nfsPVhH6JJOpW8L+hZWul38Oqp4iNcF/VNZhh3TV1JuOQdlm768Qt8t23RSauUOp/hYpmklIh5JV6De1jalJ7E0qnieGcLnMg3hAkvWtlcmHbfCAAAAAElFTkSuQmCC", 29, 15},
                ["AWS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABHElEQVR4nMXTsUpcYRDF8d/qEhWxEkQWQTAGMUKKVKnS2MXSR7Cy9SGshDxBLKxMo5YWQlJoUgVCithskY2VlUVEFHFPinurZdds9or+YaqZM9+Z4ZtaEhVYw4ceuQbmcFzlgX6pDTjIO7zFK/zoUdNAHX8Gs/ZfpJZkBTNY7kie430X0Tg+YvEBjVzhSwV9aklamFQYfCqaeFGlQf0f+TY2cITn2McQ1hVfagHbHZpr7OFEcR+Xffi47d9yD5K0klylO+0k40kkGUlyk+RbkpdJ5pO8SXLQoflV1j9q1DGKsXKuTWxhFrvlxr/iFEt4hkP8LOub2MFnnOE3WpW3OwB1hfFPGMYdLsp4jVVMYRoTijv63tFj75G83stfjl3YXlWyhK8AAAAASUVORK5CYII=", 50, 8},
                ["BANJO"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABIUlEQVR4nN3WMUujQRDG8d8boqAochaCYGljfWghiCBoc1hfc2IvXH2NVqeFWFlY+TkEv4BgYWdznYVg4IiF3R2oj0UQXoKGJKJJ/MPAPgwzu8sOM1skUWIcW1jDHEbwB2c4xLV+JcmzfUtSz+v8T/IrSVGK6Rt7XqwnuW9xiTK/e33ol6xIMoErfGn3EbGI83crky6o4Kf2LwEFdt647xI2uow9btK7GK1itYtkq7ho4R/DUAt/Ffv42uG+sxjGd5xiHjP4USS5xWSHCfuBaFQHGqU1qBRlUcUlljtM8k9jrnw0sxrz7RInWMAKbiTZbrPtljnpYas9atIHSUYHsf1Oo1bSU6hXcIdNPLSZaE9vZ0itSf/F46f5ohTJ5/g0PgGQZbQmy/b+pgAAAABJRU5ErkJggg==", 50, 14},
                ["BASEBALL BAT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAS0lEQVR4nM3OOwqAMABEwUlQUVTi/Stv5FmsLGMTQYJNOl+17Ac25Jx3HLi00WEtekPAjAE9lqr/ZG9GTJX3tY1IHx9Syc7YcPzX3MgVBvHSNhaEAAAAAElFTkSuQmCC", 50, 2},
                ["BEOWULF ECR"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABv0lEQVR4nLXWv48NURQH8M/w/MrGJmQLkfiVrGYL0YiGhEIl4Q/gf1BJFBLR6VWUQii3ZiOiUCCEKERkC4pHgbWxll3vHcW97Ji3nnlvnm9ykjv3/JhzvnPuPVNEhAbYj2942STIKpjEKVysKloNAy9hAicwjusN443hMNbh+WoGRQOGL2FKSnQn9uA2nmEZa7MsYDbbLmMRnbz+gi4+Yz7H3Iw7OCMR0pPwxyGSDWytadvFmgHiFniNu1LCC2WDFrbUDFYNXBfFALZvJPbnpLyWsL5s0LSH6+ApbuFATiTwHV9zcvN5r40b0hf5K4oYrInf4onUp21ctlL0jywbKz4H8XCAd/RH/BtzEXE1Ig5FRBERSvIu2zyKiNMRMR4R7yv++yo+jaRlpdHL6Egn9RqmpZNdxV5/HrxZbNPb351REPsbEdEtsfEiIs5GxPYa1U5nn25ETJX2L1QYnhw1wx9wM7P5uGadR3Eyr6/gVUnXrtjukq6p0SAixoao9EFmbzEiJiq6IxWGz4+S4WEn3Q4cx26cq+g24RM25OcZHBuSzx40Gc39cF/6JyDdt7+GQGP8r8Exk2Pfy9J3GAyCn1DyDO+30BjQAAAAAElFTkSuQmCC", 44, 15},
                ["BEOWULF TCR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABx0lEQVR4nL3Wv29OURjA8c/bvrQEibQhIhITkf4Bfqw2f4FIJEQwWInJYDAYTRYWk4VFTLRDYxCLRCTUUJJSIaJSSVstHsO5jdPbt+99e/u23+Qk9zznnOfnee69jYiwRq7gEd6uVVELTuIlxqo29nTBWG8XdKzEbmztZGOzpoGDOIu/OIe9+CYlJgp5j/+J+lPIn2MCjQr9RzGI8xiXqtKWRkRMor/Nnnf4mc03YwgDVcpb8GLRbiaLYh6WB9iPSUxjBr+ytQFcwAHMNbGnwvjhwsgIvkuBzK/C+WmpIvAD27GpmJedK7MFn/Glhb7Zwq85zIvEWEQ8iYjfsZTXEbEjIpTG9eiMiYjYVzq7PyIORcRQROxsobvWaOIr+nBcukJ3sFBEer/IQJmbRSZvZJl9jGNSvyzyQOqJnA9tKlCbpnQvhzGFu3jTwbkZvM/mV3EPp3A7k/d1x81qmrgoBdIq8yvRi8vF8ycp+EEpGTnlaqwfNe/kpawPzmTyZkQsZGu3utUDVaPOoV0RMVU4OtxifTwLZHSjAqnzZZ/FNTyUXgxlRrPnI9hWw8bqWYfsnI6lnNiIitT9RWnHU3zEs2K8Wgcby/gH8jbLOOESHgwAAAAASUVORK5CYII=", 50, 14},
                ["BFG 50"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABWElEQVR4nMXUv0vVYRTH8dc3b5ZpZC3lUIKLINHi6N/R4B+QTu7N4daug3+C0tTQGIgKDkFTQRimqEMgopbJtU7D+V66onjzfq37hsP3+cJ5nud8zo+niAht0oVHOMEeDjCKVxgsfa5jCH0IvGv3slYUFYQM42O5/oY6DnEfW7iDXnSXPvWm9ZVTq7B3GxOyIoFJzMvgr2EEc1JwH35WirQFRUSsYQNvKpzzBI/xyx9hdSzKanXjSArax218xw0psAefS/sbvuJH0//dIir0Vgd5iSUUMmnPGkI+SYU1OcC7eIh1zMh22ZetNHzOwe/xXFajXS5TkTM0ZuRAlr4ft7CCKbyWpR/AMRbwATexis1y/4R8uTpGQ8gDGchbPJXBNrNTfsdkP69iGsu4p8MiQCSzETEaES6woYjYjYiNiBhs4fvfrSYzeuT0K3Ae43JOXuDLP87vpfkNyofv/8tF7+MAAAAASUVORK5CYII=", 50, 10},
                ["BOTTLE"] = {"iVBORw0KGgoAAAANSUhEUgAAADEAAAAPCAYAAABN7CfBAAAA5ElEQVR4nO3WP05CQRDH8c9TYqFnEDR2XkIOQu1ZvAGU3kCNFMYzSEJiaMTKBG0ogEJNXsha7COBgiBQuI/47TaZmd1fZudPFkKAMzRQRxVj9PGAewwtcoAaTnFS+NRwXpy/cDhnP8I7BujhqYjZwdSWZCGEJi6xt8Rmime84UgUfIz9bS8XhbRxg0d8bxIkC0UqEmCCa1zhYx3HlETM+MQt7sTvPFnlkKKIeXK84kWs0VltXqAr1t0gdRG/Id8FEUs7Uqn4F5EIeeWvX7CC0nantedESpnYeGJX0LIDuxMl32J/AFNeaeJY2r1GAAAAAElFTkSuQmCC", 49, 15},
                ["BRASS KNUCKLE"] = {"iVBORw0KGgoAAAANSUhEUgAAABIAAAAPCAYAAADphp8SAAABc0lEQVR4nI3TsWoVYRAF4O8uIngJomJjMCRlGjEqBBRBURB8AAkEVJJCVCzSWZjGF9BCIZLSzlcQTOUDiCIpbFUUCzUQCEI4FndW1usGHBiWOefMP/Pv2ZVET57bA5fkbB/e6I+bONqDH8GNvoYGMz34JK714As43oPPNLiNiR7y5H9iE7jTYIiVMXITFzDdwaYL2xzTruBAgy0sd4gz2MFVo6s8qFwobAenO/plbEkym+RnkqVy5FGSQceRjcq2HiR5Utql6p1tsIj7+ITHOIZ0Jn6obCNGjq7jc/Uu7iviWYne49XYOxj4N07hcg2Hh+1BbXzDFF5gA3O4VNwa3lQ9Vdo/W7autVPnq96thi+4aOTW18J2SzPf2Xg4SDKHW0buHTL6cq/gdc+V4Dxe4jl+4CDWB0nGhWs19d4eBz01+iPu/oV2bB0mWU3yPcl2kutJmg7fFLZdmtXqkcT4RvtxopOH8bE2mKyrvMPbev5qG38DD4zt9GPY6RcAAAAASUVORK5CYII=", 18, 15},
                ["C7A2"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABtklEQVR4nMXWO2sVQRTA8d/1LqiND9B0ESPYRAsjchsbBfEj2NrZKH4GUwjiB9DCxlYEay0EQfFJLkgI+IwSIUFFFCXRxOSOxYy43Ozl7kPxD4ednTl7zsw5Z2a2FULQgC/4igl8amJoAHtxBUeGKW5o4OQstmIUIw3sDGIEO/C+jHKG85hFwNMCnQXM9/UdxikxI9twBy/TWD7FGaawD6tYEzMY8CPJTyyn5woWU7uDccyVWUgrhDCLsTLK/4ke3hb0r4hB2YL5DN/xBm3s6lN+hxkxKp9xW4zmBC6WnEgXBytM/Bs+JJ/78QCX8ahgIYvYiV4mpruLjQULOYYXBc4e4xBODJnUVZzBgSRtcV+u4SFei4FZxtIQW4P4SCyt59iNa9gjRmBazMSMWMeDWMJm3MB1bMel3PgkztWcYCUy3MQFcVOPiWVWhg42pfar9N1qkiz1NzrbKxFCqCPtEMJUiDwLIWS5sbnwh8ma9itL3XvktLiBezgpZuE3+eNyvKb9ytRdSFu8H+5Zf5rcz7WPNvBRiVbDX5QijuNW7r2DJ3/bST/ZcJXK3BXLq5vaC//Axzp+Ac7nBz2s99AmAAAAAElFTkSuQmCC", 50, 13},
                ["CANDY CANE"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAABZ0lEQVR4nNXWsWoUURQG4G/CFmo2G0VIF1KFQAQLg2IhpPMRArGySJPGPqmTPIKFaO0DCJpXEFGxEURimhBI5cZs2AjBY7Fn4Sak2IVdhvxwmHP/e878/wxz594qIowYk2hhKuP2FXkL02gm18q+Ozl/Cw3s4z1eYq8vUBWmp/JGlwUnky8FWy6aaBaCjVE9fYG/eIFXfdM/MI9qDGKjxhreVBHRxY0aDPxGGycZHfzJaGMCT/Cw6OlisZENg5o+z/pSsJPX4+TayZ0m3y6MlPWDYhPbmd/E8yoi1jGboseFWCfN9fkTnA0hNkp8xKPMP1Vj+HuMA9t6bxw6E3U6GQJHRd68LqbvFvnpdTBd4Wkx/jmOjWAYLGAF3/AFB1fUbOFxMX5X90LcwUYxPsRnfNXbYZdxv5jv4p6IqDM+xOD4FxGrEaHub/p8wLozPMNbLh6Y6sIMlvAgYwlzeoek79jFa/zqN/wHqCb0Y2EfwxkAAAAASUVORK5CYII=", 45, 15},
                ["CHOSEN ONE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAT0lEQVR4nM3PoQ2AQBREwTkBVSBwVEAfVEEtCDqkARzJGTDkY0iOUMGNfFmzKSJmLIpAwonrbR02ZLTqs6eIGDB9Ysb9GzboMWJVDtbieADxkRHkoyqOkQAAAABJRU5ErkJggg==", 50, 2},
                ["CLEAVER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAAuUlEQVR4nO3UMWpCURBG4e8+mxSCjc+AILYGJCSlYIyLcDtp0giWrijYmCatO0iTRWQsfI1FQIxXn+CBgSmGmfM3kyLCldHAM6Z4xQTrVMMgd2hXdY+y6ks84gUt/GCGJyxTRAyxRP/8znsUdsLNA+c/MUIX3ykiNnjIJJebL3TQSxHxi3RhoX9TYHVpiVOQIqLEAj18VLXBMV+ggTHmGJxG8TByfa03vOdY/BfFOY/l5BakbtyC1I0tOzomc2n0nSwAAAAASUVORK5CYII=", 50, 13},
                ["CLEMENTINE"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABc0lEQVR4nM2WPUscURSGn41iNiL+AkkQUfyoLQULbWLA2i6VXdr8AgshioWl2mhjqRa2NhaCQbS021WEwAomu1q4qz4Ws+JlnMUJuM6+cOCeO4c7z7ycMzM5dRA4BPaBVWAHqNGKUvPqkc/6o86r/SqtFE+LL2rJl/qtzqqdWYOGsKiT6l0CsOqluqQOtwos6s8GsKH21e9m4HZODVt4CFgAvqZo93/AXL3+LdUG/ADOgDKQBwaAlTgsQBdwDPSlPPwQKAAPRA8Q6gaoBvkdUInVlIH7IB8HZhLus9aesHkNHPwH7Gg9mqEqcEpkQnsS7AjwLeVhFWAZKAICf2PX465VidwOdRXLx4FfwEUdtABsA8V4E/eoZymG7F7dVceaNEwD6rT6KdwPC7rV41cgL4w+GL3NnPpG8bT4qO41AKypW+qU2pYFZAibUzcSIM/rLn7OEjAOuxgA3qqb6oT6IWu4eOTUE6CD6I9rHSilfBO8ux4BVoQAWAGhrhYAAAAASUVORK5CYII=", 43, 15},
                ["CLONKER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABYklEQVR4nNXVzUocQRQF4K8lYMa/MTAKBgIhuxAC7gQfQH0JwScR3KkLX0DiLnGbLJNNXBohCK7MJu78N+AiIkmwXFTJtMMMjNUDkgMNfW/Rt8+pOvdWEUKQiQEsYQoTaOBZbrGqeJL53SQ+4HVLvoHzKoRykSOkjm30p/gPjvCrlOuEwfQMYbQUD6e6d/FIyt3FozjAGvbbFS6StZ6L9vjehZAGztJ7wPskpN7m50OluBe2u8EnrOBbeaEIISxgHRfYEHf1NwqxD67xF7VEbA6vekCqKrawjM9EIScYf0xGFbGL1T7xuP53hCKEMI93uNTZWv/wVLTWLF4+BtsWfBWt9YVms09gDHtdFGjX7IfuT6FOU6mvIvkbfBSbfae8UGRciHUciydEHASn4v0xk947oaY5Xkc0hXYz8X6K4/dHu8I5QuAtNvGmJT+Iq5yCVZErhLi7i5gWrVnDix7xejBuASoAVAF0wMlOAAAAAElFTkSuQmCC", 50, 12},
                ["COLT LMG"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB30lEQVR4nL3Vz4uNYRTA8c+drgVj5NdGfmRlI9SwUiQiaZStbCVlI/8AZWNnZy2F1GzZaMZmhCFZiUKUhZlGzKCLmTvH4n0077z3uve+d8Z869R53vec857znPM+TyUilKSCZ9iMV3iLz/iEiaSP40nZwAWO4gTOdmJc7eID+9Gf9GOyoopclRX5Gj/Ss15cx7uc3Xc8Lvj+wkq8xECnSVUi4kqnxokBbE/6eEpmXswk37CjZGyYxQO8kRV/sYlNHT1Jr6JeiS5mawmYxDRW4VHS89RxSLZhwxjrZrQ64a5sNE6ndRV9LexnZB2En7iAUZzDEFZgNdZgebLbiQ84QjZa7ToynYINp+QmcAPbUEtJ78HWnM9uPM+tq1jW4huXMZVbf0nytYleaxohmjMTEUMRcSYi1kWEgrxIdjcjohoRpwr+/U18WsmmkvYNkh+tWTzEHQxi7B+7dxy7ZONwC1tkR3CeqaJTGz6WtG8kIp5GxPmI2NhB5b0R8T7t+rXCu8lcRw4udIfLSlmHkxHxOyJqEdFXeDeSK+TSUhfS075n87iNtdhn7pT5y/2cfnghU9INlVi8a2Sv7B8j+3/Wy+6DJaFsR1oxai7xKg4sYuy2LOaFOIN72IARjSfZf+UPY2o8Vu7ICHMAAAAASUVORK5CYII=", 50, 14},
                ["COLT SMG 635"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABaUlEQVR4nMXTz4uNURgH8M+9vQxNTE0WbGyU2YiNBaUUNf+AsrO0UBbKyk62JHt/BMqOsiILG5QyKQtDhpoppMFcX4tzyjXN3HfeO2q+dTrPeX6e5znf00tiDDzBLizgIz7VfQGf8RSLI+LPYFGSrut0kkEK9q9h35vkSkuO40lmG5zFT7xYdbse3uL3kG4a59Gv5xtYWhU3Vf1mcAjf8aPavqHBJK710n3uczjYMWYtfGjwFcHuIcMAX/Coyg+VDqdxqSVp8B47sGeE3/UG97GCc0OGVzi8TtBRZaS9dewrOKE85aQy9gEmFDL2sRPLKnEeJ3mZ5GaSy0mOtRBmrsbdTTKT5E7+Ymmj5G0wiwc4guctI6WMfl+VX+MX3iikmsBVbKv60Rjjq92qHb5Lsn1I/6zqpzaaq996u39xABeqfFF517HRdPQ/hWXM495mCqNz57eV73Nys4XHKU4h0vxWFf9v2NLifwBur2bP2wW9HAAAAABJRU5ErkJggg==", 31, 15},
                ["CRANE"] = {"iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAAAsklEQVR4nO3TPUoDURTF8d+EMWgjWrmEELBwA+7Byj24DfcgLsBFuJDUIWnSWKtoVI6FVwzDBDJgJf7h8L7uO+++4jRJdDjCGRZ4whvWGOEV790L37Q1NjgoPdZ6gjn2qq4ps318lLmav+C5xQNucFqHd7gos9W2LnpYSXKVZJREaZzkPsnlxt5OanHbeWGNJaYDumLj333MftNsMP9mf93sGIc48ZXD3emJxXV+OB8Sp09OyY4hBg1cSAAAAABJRU5ErkJggg==", 19, 15},
                ["CRICKET BAT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAGCAYAAACB1M0KAAAAgElEQVR4nM3TvQkCURRE4e/Jooj4B1uA+RZiGTYi2IP12IlgBQbqgphdE42MdC/qiYdhBmZKREig4IBFhtmbHLGsEowqrP2mBNRYlYjYocENY1wwxQkznDFBixGuGD70A/Qx/272F/a9BJOUbXaklISPPKe16Z7nY7YZRfiDs98By3wc4fma3AQAAAAASUVORK5CYII=", 50, 6},
                ["CROWBAR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAAk0lEQVR4nNXSPwrBYRzH8dfPIjeQYuEORmUwkrJZbG5iMrqIAygZrMriAAwkkwM8Bj2Lkj+Dn+d1gs/72zcLIfTQwRYr7CQoCyFAGVMMccQcG4T8pr3l7H78SwyJ2pigmceqL13RfwyJamig8NNJn6tghsOzkJQs0Eo9pIg9Tv/+Oq8MUMI49ZARulin/Fp1VLGEGyOxKRfVq1bPAAAAAElFTkSuQmCC", 50, 9},
                ["CUTTER"] = {"iVBORw0KGgoAAAANSUhEUgAAACIAAAAPCAYAAACBdR0qAAABPUlEQVR4nLXUsUscQRQG8N9GLwQRiQmx8T8ICEkhhAMbm1gk/4C9ECNYirWdjb2kshUEQyBgmcY6ELFTgk0KhUMxR8ixvhQ3F84jbvZk94PHvjf73sw337yZLCLUgEV8xM+yBQ/qYIEMQ+2wLiKP0R6mYLQGEs9w/Y/xabzCE5zhC379/RsRVdtSRDT64omI2ImITtzGeUQs9/KyiPiMqZK77SQbK8i5wELyx3GImYL8Taxn0b02eRocKUmoCDmukt9IZIoQmO8R2cAjrFVA5D7Yr1ORMmr08KO/R26whVndc32JVrImXqRFcjwsmLTXI2/wqSSRdh235n36Po/y+Fb1g9bE1+Qf46hk3W7VaqwMxK8jIv+PGqcRMVm1Ip2B+ADv8PuO/BO8RauOJ34QH3SbfxVzeIrv2MM2LuEPYkKR10ZxY1YAAAAASUVORK5CYII=", 34, 15},
                ["DARKHEART"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAABjUlEQVR4nNXWT0uVQRQG8N9rN0ipILsLWykItjUoWxnUoo2r1rWoXR/BbW1dmKs+RDsXBdpCCkEIAi2EFoqJYGnRxj+V2nHxTt3b9b1q6Av2wGEOc+bMPHPmnJnJIkLJyHAD9zGAaYwlmcGBBLKSSZ5LRLqa2D/jpRrpT0WDyiZZxeohxwbeycmO4nXNElGmVONvPIiIpxExFwdjNCK6I+JPJFtxDUuYLzGSVXxNejduJ7mF8wX+3zFUwRU8R4c85E/wCBfxBadS/ybakvMazhbo67iMdvnR3W1YtF+ehzexk/qmMIGPiUsfvqXNrWI+i4gpXG+YbBmXsIXT/0iyFS2YRQ8qdfOuYBFX7cVk8vmAV3jz25BFxCbOFDiVhR356eyHn/JK70K0yO+tRiyndiu1gY06+1oTfR2/kj6L7YZ5V/C2CbFnGMRD9KIzrSuLiF68UMvJYTx2tJy8gPe4h5E6InfszUnyAtk3Jznh1f1f3ZNl4VhenEozj2PCDyw44W83xb+g8URq2iF+Qbv3DaP4pXIShgAAAABJRU5ErkJggg==", 41, 15},
                ["DBV12"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAAByUlEQVR4nLXWvWsUQRzG8c+dSXxBJCCKhYVGkCCmE0FsE5CUlv4dNtbWYiE2VmJnrWITsFGigoj4gpjCRoIagyQaA3l7LHaPbI7L5XK5+8LAb/aZ+e0zMz9mt5bELqjhPubxET+aNGhOWH1+spy73KTBS8yVcR1/cLhFPrUkI2V8Aoea9LlycoNzeLTNgvbKKgaxgUUMK8y3NL2AI30yshseY7aMx3AJ93BacUJreIKzA/hpq+kVDClWu4q3FW0YFyr9f/hVJhzBOvaV2ipe40CHppcr8Rd8K+Ml/FacwF8sSvI8BZ+S3EkymmQ8yZkkQ0lU2miStXL8WpJrSY6V2vckr7LJSpL9TfN70ho7DQ/xDJ/L1oo5mzU2g2kcL3fhARZwsdQHMYp3He50x9Qrpo/ixQ7jJzFQxrfxVXGLzOMGpprGj/XG5lbquIUJ3FXUZDsmK/GbJm1dsYBqjst7NdiSXdbT9SSzSZaSHNxmzHSlrmf6UdPdTKonOd9Gv5mtnOq16XoXh7OBD2305roe7+IdbenG9E5MK+7TBld7/YJ+mF7B00p/QvGL0DP6YZrizm4wgCu9TF7L7v7yOmVQ8QmfUizgfS+T/wfEDAK1oC5O4QAAAABJRU5ErkJggg==", 45, 15},
                ["DEAGLE 44"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABKklEQVR4nK3TQSuEURTG8d+MkSk2FnbCwkY2FjbKZsoH8AVk5wso38BGslQie3vZscXSAslCE2KkFJMyg2sxr0zvzGuGeZ+6dTr3Of3vufeeTAhBTBs4xSX6cRHlJ1CM4lccoqG4icaxmoslV7DQRjHco4oPvKMniqvI4xMllNGTiToaQA63yLQJakc3uEY+q9ZBEespQ2AQU+jK4gz7mE0ZUq/tHApqj/+AOXQnmHexh3lMYhE7eGsBKaMqhFC/lkNzHYcQpiPPUAhhM1bXcmVj9KuEU91hOIpLOG/RRYPi37uQ4KvgBTNqs3X0V9D394YxnGj+RiN+hvVfqr+6pQTIA546gcRBMwmeAzynBRpVG65m6usUUg/K/+LZShN0jjU8xvYr6E0D9AXA3pDZrXRslAAAAABJRU5ErkJggg==", 26, 15},
                ["DEAGLE 50"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABF0lEQVR4nL2UoUsEQRSHvz0viVkspgP/hQsiYrtoMdusYhU0CVaD/ZJgt5oEg0EwKKKCQcQoiJ7owvoZbg6W4eZ0dfUHj9mZeew37zePyVRKyoAucAHcAfPAWNgrgLPwnQPHwBMwwXAVIa8NbKGWY9dqeh+x96Hmg0kWKmoBb8B94nS/VgNYA66B/b+CALdN4Ia+33M/+EGP/j2M0guwjbqsrqgb6nPC70LdUzvqgfqqLqqN6I6TES+sJ0BH6mzImVR3vgsYRCMq8zFRfg5Ml6yo3DTNaN5J5F2GcQkYBw6rgsrltUPvxzqpatNX1q3SfxlinVY+/RANQBmwkMg5rxM0A0z9ByjuvrJ6dYKugE3gYQikVQfoE6lqjTYJGXlDAAAAAElFTkSuQmCC", 26, 15},
                ["DRAGUNOV SVDS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAHCAYAAABKiB6vAAABW0lEQVR4nK3SvWqUQRjF8V/CKjFaRAW1iKIIqdNob6HgZ2kRAqkFL8BOvIRgo5BLSBkheAFG0CKQJgixUlyE+LVZEjVwLOYtJsuuG3T/MLzvA+eZOc/MGUuih0mcq+rP2KnqG7jY23QIzuMIdrE3RNvBu6ruYq2P7joWMN/Cc3zBN/zGJTysxEt4gwllyMfN/yjYw3dM4StOYRunsdn4gTNYxVZP/3Szx82xJDt40mxIubUTlbiLfdzHtX80vIo2xhuD20P0H/DWwUEo6aiZwDH8kKSdRJ81meRekqUka0kWk9xO8iyF/SRPk1xt9BeSHE0ym2QrB5kfcMbIVqtnwrO4izvKc7/EIjYqzZXqlh/huBKJNn5hHXN4XfXMDHmB/6aFk1hWctnBCh7g04CeW813RYldt49mHe+VTG/i1cgcD6Cl3N4GPg4wVTOu5LuDF3/R/cTlURg8LH8A7IDlsCBMiSEAAAAASUVORK5CYII=", 50, 7},
                ["DRAGUNOV SVU"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABs0lEQVR4nL3Uv2tUQRAH8M8zx/kjxpAiKIqIFmKhWKiFBsTGRrAQW0GwFKwUsRZtbAX/Au0kRpuAIFHQLoU/wVYiIkbRBA1yp67FTvC4vNzhyyNfGHZ35s3M+87ObJFSUhG7cB6/4vwYs9iJgyFb8QAv8QlDaCDhbtXEZShWQGQvXlX0/YOBqonL0FiB7xyuxL6FKYzgMg7jXuiP4xKeyze0Tr6RWlGklEZxA4M1xNuCMXzGU/zGEbzGfB/fAczIBVqPZ7gftqM4IRd+CBfxPWxNtIuU0jhO1UCC3DJretjmMIw2fsZ+Qb6hQXnOvsT32+Q5msFJnOmINS8XaZHIzQYO1USC5Uks2kZivzYENsTawke8i/N77A5ZkAltD9umrtgbi1Rt2n9Y2ornMCG31yR24BuuyRW/hdH4oSrYr3ymm5guM0zK/bgczuICDnTpG/ga8kEmAo8i2Wa5pariRU9rWoqxlJIe0kwp7Snxuxr24ZRSO3R3+sSqTbp7+on8WvRCC2/lyndiX6zH/GuBh33rXBO6W+v6f/hOya/Om5Dp0M/itjwPq0akc9jHcXq1EteNv5A2BF7pvrjaAAAAAElFTkSuQmCC", 50, 12},
                ["EXECUTIONER"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAABbElEQVR4nLXVsWsUURDH8c+eB4KI4RQEEbEIAUkXK/8BsQj2CqnS2VgIVoH06ZLKImkCgRDExk4Qwb9AYqWRkCIQhBg0UULQSybFe8J67C6Xu/iDZXnzhvm+eTszW0SEBt3DW6xht8Gvg23sYB13sZntBfYwhtt4jPdFDfghRvAMEzjAlaYTnlE/WjUbH/AoQ+FiQ5BfA4C/9YLHsYyPmCzZLzQE+T4AeKVdWkxhHtcqHI9wuSbIHm5hBm/6BG+UwfdroPBbKp4qeCe/X+JLn2B/r/oSHjT4Xc3Q1zjMsK50zcdSBe/3CwURISJmo15bEfEiItay7/WIWIyIVl4P9LRxA88rzrQu9eVXPMFstnfxDidnyrBHRUQs4GnF3qRULNPSt+tIQ+AnlvBnWPBGDljWLm6Wgt+RWuqzlPHQaldASRVazujTecDKqptcq+cN6lUREV3/TqYtjKLx7zGsWngl9eKJNCTm/jcUTgGHOrFGuXB0YgAAAABJRU5ErkJggg==", 30, 15},
                ["FAL 50.00"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABl0lEQVR4nLXVzYtIYRQG8N8do0byMT4WigUyk7/AnsiCsrBjJx8liQX5IxRNs7BhZzPK0grJxlIaJJJIZkFjmsTMMI/Ffadu0wx3bjNPnc499z3Pueec933PrZLogI04i2M4jJ6WvC2YwDb0tuTM4Afu4yReLOiVZCmyJkl/kpdJZtMNi/FmktxL8jHJSJJPxZ5u+NxdLLcqyXH8REqnNxQ9J/2NdzuxtWUnu2Ac6zDZ0P2N9XeYxeYiMIXpKsloITxWb/s4vhe5iiG8L6QzOI83GOyQ6Dn0qY/WYvilbuwcpvC5PI8UvQrrGz6pkgwV40JjYRA3sV19PifUha3GDgzjNz7gCo4U3hhG8RWHsKkRc3yevazoVXf7YLH7cA1HcRFPW8Q4UfQkTuGhOuE9eNLw6zRV2qIHX7AbB/BMvZX7/L+ICtfV0wtOF/5a9e6NLX+6/0CS/WWSPEiyq+X0qpLcbkyT4QV8BuZNpW8tY3eSXrzFLVxSX7RW9eMG/mAvLq9Ek5eCKt1+iG0wgEd4hdd4jjsr9bG/36imFGTzFhEAAAAASUVORK5CYII=", 50, 10},
                ["FAL 50.63 PARA"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABl0lEQVR4nLXVzYtIYRQG8N8do0byMT4WigUyk7/AnsiCsrBjJx8liQX5IxRNs7BhZzPK0grJxlIaJJJIZkFjmsTMMI/Ffadu0wx3bjNPnc499z3Pueec933PrZLogI04i2M4jJ6WvC2YwDb0tuTM4Afu4yReLOiVZCmyJkl/kpdJZtMNi/FmktxL8jHJSJJPxZ5u+NxdLLcqyXH8REqnNxQ9J/2NdzuxtWUnu2Ac6zDZ0P2N9XeYxeYiMIXpKsloITxWb/s4vhe5iiG8L6QzOI83GOyQ6Dn0qY/WYvilbuwcpvC5PI8UvQrrGz6pkgwV40JjYRA3sV19PifUha3GDgzjNz7gCo4U3hhG8RWHsKkRc3yevazoVXf7YLH7cA1HcRFPW8Q4UfQkTuGhOuE9eNLw6zRV2qIHX7AbB/BMvZX7/L+ICtfV0wtOF/5a9e6NLX+6/0CS/WWSPEiyq+X0qpLcbkyT4QV8BuZNpW8tY3eSXrzFLVxSX7RW9eMG/mAvLq9Ek5eCKt1+iG0wgEd4hdd4jjsr9bG/36imFGTzFhEAAAAASUVORK5CYII=", 50, 10},
                ["FAL PARA SHORTY"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABlUlEQVR4nL2Uv0tcURCFv923CYiIBgyIGgVNlUZsRAL+gIBlwCak0t6/ICmFFBYpRAKKjXUgdjZpAiGghZUiSURS6CI2QQQVNRK/FO8K6+Pu010wBy7cO/PmnJn7Zi4qaqNaVt+F832sJ+qh2nttKwHvgX6gE3gFtAIF6sNT4BL4DZxW2LuBNuARMA+MA6cF1TqF8nBEWkBzxLcGjAEn9yWeB4ELICmRZtnyH8UXgTMgQZ2zNvzNsbepTepztUNdV7fUHnVUfV3ZhEXgHNjPyfSyYn8A7Fb5rggsAMfAauB8QNpsZeA7sHcjImTxWJ1Sp6vcxB/1Y6hoJoxMDG+9OV47wf7MyPhlDYm6XEG2pw6pb9QNdVPtVr9EhK/U9gzf1+AbvE28qC5lyF6oXab/rE9dUQ/UXxHxckRgSd1Xh/PEC+p8hmw2EpCYXnsMP2MCeet68yFD9ENtyAn8FhHfrlW8FPpuFngITAAJMBlmsRpivtqf5Ew27erLO2T9OVL5Tq2VF6zvdf0EdAAb4TwAjJDO+J3xD3mTbSbom+uYAAAAAElFTkSuQmCC", 31, 15},
                ["FAMAS"] = {"iVBORw0KGgoAAAANSUhEUgAAACgAAAAPCAYAAACWV43jAAAB0klEQVR4nMXUz4tOYRQH8M878zavQmnKgkxkIaWXYmtBkYj/wg41ZWXFamLF3p6lhcKGWCgbk/ErFppGTWj8GF6GGWOOxfOMruuaH/ctvnW7557vc89znnO+52lEhJo4jgvoxXd8xjSm8A1fsz2NL5jBJ/zAR8yhg0ncwIuqTRpdJHgLezGBlzVjNNCWklyP2T9WRETd524kbO8ihogYynEGqvgmLuNAIecrGEJgJfoqTj6FFdneILV3IQyihbc4hAd4I8mgldf0VJY4Ip5jyyIb/AscxnVJmz0YQG8jImYlof9PRH7uSd1Zi80Yb6qf3AQu4iHW4BQ21ozVwSZ8KBPNmgEfYz9eF3zrcDrb5/Aee3BfqsoxnJRaWMZYVXIgqjEaEYMRsS8iLpW4TkS0S9PWHxHvMj8XETvyv/N8T0QcrDPlxQqO46l0N53FzezfXTrTMB6VfEfRn+1rGPH79O8sxFsWmlLpn+GOJNSqFszjiXRBl3EkvwPnsz1T4PtK30vHEsp8ptDekQq+ERGTmR+r4NsRsbpOeyOi+nIsn2ERfpUkDzhR4rZKkukss26/UHeKi+hgm6SzFnZlfwujeNVN8KUmOIbbuLrAmuFuEvkbfgLCvN9GPBQiawAAAABJRU5ErkJggg==", 40, 15},
                ["FIRE AXE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABPklEQVR4nNXVSyuEYRQH8N+45NoIUS4LKcpWSlZKlJ2SknwSGx/AF7BgY6t8CiWKlS8gC0Wm3GbcjcX7TPOaZmpcwvuv03nP/32e0/k/t5PK5/MSiB6sYxGPUPOn5XwPc1grBEkWAktIkXwhXeiEuj8u5LMYxDTGY9wIdv+7kDTmsYxJPKGlZMysIGQLbzgPP7owhL4QZ0MCyCGDS1wEnwn8VfA53OAOz2FutoqiG9AfbAxTwRpjY+rLzOslOlozoufst3CD1zJ8+xfz3REJWcVGIM+xgyOc4hbNqEWr6GJ1BB//TqMtWKtodSsh/cWCK+GKSMhmKPQW23j5geT1IkGFVW7y8YhUiwfcx+JHHCgee7iGVMI6+wT2SrgTDCetj6yU4QawnKQdGcWh0MlLsJ+kHVnAMc4U2wHRne5+BzbzQJPooZf9AAAAAElFTkSuQmCC", 50, 14},
                ["FIVE SEVEN"] = {"iVBORw0KGgoAAAANSUhEUgAAABYAAAAPCAYAAADgbT9oAAABD0lEQVR4nLXSTytEYRTH8c+9Rv6WkIUs2WrKfmoWysY7sPEilC07O2t/XoKNNZI3ICk7sbJSSgYzqGMxd2oa18hcfnU6T52n73PO7zlJRMAepnGIc8W0g/UkIqo4LQjrVCPF0h9Doe+/wHeppre96ANPeMV7lmvYwnwSEWWsYBVTOYBjzGEbdYxjDRXcYggDeMsiQU1EtGI3vqoREaMRsRkRadvdjbZzbiTZus3gGoMd3dZRRT/GcI9ZjGC/m0+lLC/nQOEiA7/gIfP1ElfdoNBq/SDHhoiIyk8jd7MizUac6HizhknND/m1UizkQOGsV2gLvPhN7aRXaAtc/qZ2VARcwo2mn89ZPGpuwXAR8Cccv8rWqd2QmgAAAABJRU5ErkJggg==", 22, 15},
                ["FRAG"] = {"iVBORw0KGgoAAAANSUhEUgAAAAsAAAAPCAYAAAAyPTUwAAAA0klEQVR4nI2SMWoCURRFz4zaSSC9lRY2NlaKRfrgErIBi4CltQtwF1Y2gtO4AAMpsgaFWAhCmlRhCJ4UmcGvqOOBV93z+ZfHQyWYZ//5VdfqOMxDsaS+eco8lGOOvAB1bpDLVaALLIAkyPcndvbFUH1Um+okqJGoPTXKO9cyeaYevMyHWo/UEVADXm/1Bd5j4AdoF4gAnRiIsikiyuX0DjmNgQqwuUNel4Fd9qCIFeqD2le3V9ammqqt8DZ66vcF8aAOzg8JtaFO1U/1S12qT3n+BxKfG6GUHtoVAAAAAElFTkSuQmCC", 11, 15},
                ["FRYING PAN"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAAA7UlEQVR4nNWVPUpDQRRGD75BELFRxMLC0kpIoWtQxM4NBJIqNmndQMgObIONuAGxcgPWNoLiT8wSYqHx2OSBBJQ38yaFH9xmmMNpLt9FJePsqGfqnfqujtQbtaUuzf7PJS3Uvvrl73lR9+Yhv/xD+jNjdTenvFNRXOZBXckhD+owUq56orJAvRwAmwlcEyAAG8ByBFgAW8Ai0EoQAzSA4wCcAlfABbBaAXwC9oF7oJ0oD8B6ALrTh7UIcBs4BCaJ8g/gte7CHSUsm+ptjoW7Bt4SuAFQW/4J9CKZR+Ac+P8NV7Xbn51Tt5cTddW+AYZBqQeVEH41AAAAAElFTkSuQmCC", 31, 15},
                ["G11K2"] = {"iVBORw0KGgoAAAANSUhEUgAAACgAAAAPCAYAAACWV43jAAABKElEQVR4nM3Vuy5FQRTG8d85FCQuiUKiJrQSiYhGQsEDUCupFN5BR6NU8BAKHVGIJ0CiIEFQ6cgRYin2JI77YY7LP5nM3mvN+vY3O3MREerQJiJi6IN8OSKWvqNdVh86MMq7ei0YSOO+RCkiRtBZw9j+9KHzqlg3JtGEZpziPuWaUtvAMdpwiS3sfsXgDoZrLfgGy55P6jPWcZGeb37DYA4L9VqDP8XUfzfYW0bDX7v4gNtGxU78KU5wmFF/VoqIdk/nVzPmEFjEQ4p3oTXF26oErjGNmfS+jTvsoYIjrGQYVI9bZDyeGI+IwapcT65+Y9bsCmZTX8GV4g8Opv7ivaJaKUVETn0f9hVLZBNjuYZeknvMzFdpbGdqvUmuwTWsKjbPQb6d1zwC+CMsNCrWQC8AAAAASUVORK5CYII=", 40, 15},
                ["G3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABaUlEQVR4nL3UPUscURTG8d/qiAoLmyZaWKRSG0FIkSIhiGiTQpJPkG9h48ewFyVNCosUgVRJkxQJqURLsRDFqEV8Ib5tomNx74CZ3ZWZEf3DcJkz55z7PJx7p5amqZI8wnP8wO+yxRX5hDdodkpICjYawSwaqOMVPuLX3fS1cInjXOwfhjEtGGpLgg9RXCcaeIruXHympMgUtZI1GReYxF4uXkcP1NI0XcH4PQuBK3RVrF3FEXZz8QY2UU+0umzHMdZvvI+ht6CIWSygD+cFazL6Y90W/t6WmGC/TbwpXObP+IKfwlnNeIn3GBJM7uOPMOYzPMHjmFvDQUkDGYXrEuH8pcL4MuFfcXJL3be4yRAWsSyYHcU2lvA65g6Ukl6RBPOY034ynRiLD+wI03gRexzmeg3eWWUBEmESZXkb1ybeab2EN+/dgxip+heZiuuGVhP8b+TBjlYVnmECpx2+7wom1/C94h6luAbtLU9JNGp1kwAAAABJRU5ErkJggg==", 50, 11},
                ["G36"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB6ElEQVR4nL3VO2hUQRTG8d+uMQkYNIgKxvgqFCwEEQJqaxobLS0UBAsbG4tYCVqqtZ1YJIgsItgKMa1E8FWpKX2DEVFDXE18HIuZ6HVd4+bG5A/DzO7MmTnnO2fmViJCSbbhcUnbXbhd9uBmtJW024caJlHP+1Ql565hKb7jKzpyX0Ul2x/FFQyVdbyRuQbSg8M4jhW5FXmHviZ2n/Epj2t4gDHsx0t0Flod45IQy/AC9zAym2OViLguKfYs95P4gqm8aR/WYTO2YElLIc+PD5IoXVIgb3BBymg9r1mJ7jz+1oadWCuVQDOWY1BS9Rz6/7/ff1DM9qrcv5WErhfWdOMjptvwSlK8GT3YLmWhA70lHbsv3Z2Zl6UT7ZjIvzfgtVQFf+OSFExTKhExgr0YwFNJgbpUo8/xSFKikdM4IZXhmFTHW7GnYd1ZnCoEsTBExM1ITETEwYioRIQW2uVsNxgR/fm/MxExFb/T1eJ+82pV6amEI7jaonK7cSiPh/Ae6zEqvURFVs9b7VaIiNGIeDiH6KsRcSerPdxkfk1DRg4sVkZu4OQcYu/160U532R+XLpbMzTemYWhpALtEXFslvlaISN3FysjZZjGxVnmhwvjHdhU8pyWKRvIv7glfTsGsBFPFuicn/wATdwxlPjWUp4AAAAASUVORK5CYII=", 50, 14},
                ["G36C"] = {"iVBORw0KGgoAAAANSUhEUgAAACYAAAAPCAYAAACInr1QAAAB8ElEQVR4nLXVzauNURQG8N/hupebMEAikVs+y2c3mUiEMrxlJB8TGUkmpvwFBqaUkoGJUiZXKUoZSEImlIHkI5Krq3ze+xi8+/DinJxzylOrd++91l57rWetvd9GEj1iO5bjLCa62DcDz7AJz9sZ9fUY1C6MIliFj5hS/N3FN/SrAp7EdHzCIObhMw7jVNH/hUYPjA3iJE600H3Dlj/WxtAo40l8wRtcwTjO1WwfFp1Gkh1lczv0YxaWYBh7MbvTLAq+4xVm4j2uYzPWlUAHit0tbG0GNlYOOqCieExVovHi8AiWFYdrVKX7n3iMeZLcT4W+JFrIodr4aP4/didZ30hyA9uwAk9K1ItUt2YOhlTNG1UpphVZrSpHJ7isavQXtbX5eFv8DmChqndHMCHJaIn0RpILSY4n2ZNkbhsGmzJUy/J8yXRnCwau/sNPUxpJ1jbnfZhay2AfXnbIwrHyfYhLuIOluI2NheWmvhPkN9skN5NMJtnQYWaSrEzytTCyP8nsJIuS9CdZnORujbGLXfj9KZLcKY662Xi1HPo8ybQW+gu1wB71EtgUnMbBDummeuEfqJ6WM6pH9U/cq41XqS5Rd+glm/xq/gVtdMP5HSO9MNYrnuJ1G909vKvNd3XrvNef+L8wgWv4gIuqm9oVfgDr8cpHGQRouwAAAABJRU5ErkJggg==", 38, 15},
                ["G36K"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAACKklEQVR4nK3Wz4vVVRgG8M91ZmzMNH9gmrkJEV0EKigIigi1qV1Qbt1IMCBZC9Gl4EZo179Q6dIIcSGKmxJhNlYui8ZEaPzBoNaUU93HxTnXuc6MM3Pvdx544Xzf8z7nvOc57znn20qiAd7BrT65+/FDP8RWg6RP4xOM4/9qr+AnfIchPMVAtTZalRscxDA+x5NeJh7sI9lNOIITeBVvzuifwLraXtXlDyaxEr/hGL7FdXz9krna+FJZ/HO0kpycJ8F2JazGZuxQFBqYh/MyPK1Jw5+4h7eVBU7UMf/BGzVmCr/iM2WRqzs5tZKM18B9uF0Hn8JfNehdfIQxrMGpPhJuggksV0rvLqZaSUaxBxvwYA7SoUr6pcbcaJDAPUXlDjbhj9peruzmWFf/EH7Hge5BBvGotnfiKl7HbmxVDtdwl49ppYdxHGsXkexjZZu/wn+LiO9gKz6d5U1yKQV3klxJMpJke5JWEgvYxcq9lOR4ko1JzmQ2ji5irLlsKMn6mf5B0zfIfXys1NBisAfv1/Y5/I0VVckL+LAr9nYP6nbjXzyc5U1yraqxqwcFWkm+r7wf6/eq2rcxybYZSo/0qfScNqjcmz/jZg8KHFZeNPhCuYM7D8S4cqAnlXuc6fOwNEjyQZItPa52b5LRJGO17uaK6exEktxaSqWbkJctUFJnu5JuJ3lrqZJe1mCT2uYvqcszvt9rMNcLaPLDtBBeUx6i8/jGi49GIzwDdb6ek0arAxsAAAAASUVORK5CYII=", 45, 15},
                ["GB-22"] = {"iVBORw0KGgoAAAANSUhEUgAAABwAAAAPCAYAAAD3T6+hAAABUUlEQVR4nK3UPUtcQRQG4GeXBSVIAgYLSZUmBCRFCoOCrV0Ka+3FIhD8ESlEEJI0FnaGKFgEf4DZwmBno5WEVGoRIaRLFNSTYmfx5jp3ZeW+cOB8zbxnzpmZRkQs46EOGniNUb1xhOOkP8J4IfYXWzhP9jq+dYONiIg7Ns/hLT4kfRJ7PXJP8LNrtO5B1i/+4HeRcAVDyR7GTPK38b20uIU5TGMq+R5nSHbwI+mfsNsNNDIdfY6v8nNcwBu8T0SDWExFX6ScY2wgP6qIyMlG5PExIpZKuZsVe2Slma2CsQr/FQ5KvgcVuVnkLs0EXmT8v3CGEcwn3xM802nteWbNbWSO/aWine/6aV2VlC/NS+zrfABFXOGpm8d+bxRn2MJqhgy26yArE87iVUXeWh1k+G+G7YrZnUZEs475lZ/FSEVNh7iu64BFws+4zOQM1EUG/wAKREZ/zXo9+wAAAABJRU5ErkJggg==", 28, 15},
                ["GLOCK 17"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAA7UlEQVR4nK3Tr0pEQRgF8N9eZQ2aFN/AYLBYrYLNpPgCFl9Bk48gYtksgj6ACGajIAgWETGLLAYNpmPZCxedvbB/DnwwzDdzvnMOM50kGzjDlcmwg3NJTjJFVOhMqKyJfoVL3E2JcKaTBLp4wsqQg0d4wTK2cK3srC9JXReFSD6TnCZZa5w7aKz/VdVgXy1MfMAhtlENFHbbPNeWl/A+uNTEMb4w29h7xM1QxoHU3SGvYK7NXpvlzcKsN/y02SuhwgL2Cr3eqGQ14T4WC73XcQgluS9k95FkftT86gzXC3Oe8T2OwPrr/cXtOGTwC3lWNDiscuQ8AAAAAElFTkSuQmCC", 20, 15},
                ["GLOCK 18"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAA6UlEQVR4nK3RPUpDURQE4C/P30orEawtbMwCLMXWVreQFdiJra2QKr2CnV1wAS5AEURsrEQEXYCIY6EPQrx5kJ+BA5d7DjNn5rSS7KCLS9OhjWtJupkhqim3GsZHhXPczIiwaiWBJdxjc8TgCR6wjl300SrMvUlS10UhkvckZ0naA3Odgfe/Gsxwq6B4h2PsYw4bWGjyXFtewyuGj3SETywPifRHMv6teliw+51kvslek+W9gtYjvprslVBhFQeFXm9cspqwg5VC73kSQkluC/m9JFkcN786w+2CzpPf646NCqeF/6tJyOAHPB00BQ9CloEAAAAASUVORK5CYII=", 20, 15},
                ["GROZA-1"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABv0lEQVR4nJ2UvWsVQRTFf6tPIipRMCGIiChBUDD4AbGxMURJJ9iJoIUfhZUK/gk2NiIoltomhRBsA9ZWIfiwsFAUSWHziIkGYl5+FnvXjI/dl3UvXGbm3LPnMDt3JlNpGFPAI2ABWASWgaUYl4EVYAIYAB6WCbSaOofhSWAc6FZwMmCwSqAFzADfgH3AnprGg8ApYDvwChgt4awCG8C5Et02cLkFXAR+A8M1jXvjILCjorYXWAM+AG8CGyPf9IlM7ZDvuklsANu24KySn3svz1YIVEXRjVmCvQO+kjfVGvALeJDU2+Q7/QzsJ2/IZ8Au4DtwHXgNvERdV3+qU+pZdVQdUXerqCv+G1cCT7Od1J+ok4GfVs/HfGfUr8X6AOqceqtEsMgz6vtE/EUJZz5qs+oR9Wjk4YRzKDj3CqzKsDfvJ+YddTipDandqN3tozEUnDsFtlWzFDEd5wt5cz5NahNsNtNcH41O9FCnAOqaLwKPk/VV4EbMJ2P8Anzso9Elv26fCiCz/vM6AMwDx2O9Dtwm/yM3Q/xSXTGg9pkXOab+SM6/qx77T42/2eSjC+pSmD9vatzUvLi/b918CxrlHxyykmaYSfikAAAAAElFTkSuQmCC", 31, 15},
                ["GROZA-4"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAByElEQVR4nL3WPWtUQRQG4GfjwqoorhIIGkgIqKVVQNBGwcLKStDGSvwJorWdjT8gNhb+ArEQ3E78KCWgERvFgEGLxM2uRqNyLGaWjZf98u7iC8Odlzkz8875mDuViDAGjuMemniHTXxBG638beJi5tfLbFIdR2EWdgKX8XCA3W78KrtJFTek00P9H+YewUl8x3mc62PXxFGs41EZkZWIaGMVx7CrzCJ4itN9xlYkL77K/VnslxzUlsQv4zC+YgvT+IFv2K5ExEfMYKqkwMgLbw+wqWFPyfVVpXwpK5Akcm9ug/AA85jLtjXdQnuDs/iQ+zXJ+y3Zk53yfok1KQQbutW5gEt5YgdLuC3l25YUliVc22FzBzfxU8rZadzPY/NS/r/N8wcjItYjYjUi6hGhRzsVEc/jb9zqYXdlx/iLiFiMiLk8thAR+/qsP7RNZY9c0K3wIp7h7tDTpjuzg6tS6Fo4qHt3lkI1ixyGzQLvdQt0rqA1vJZydSIYtWA2CvxQgdexmPsNExTI6CI/F/hMgZ/R/Xs1xhHUC6OK/FTgswW+IuXteyncE0VlxAdGRQr5gczbUoh/T1pQL4z6wAg8kaq1gcf+k0D4A0358UBFsaTkAAAAAElFTkSuQmCC", 41, 15},
                ["HATTORI"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAECAYAAADMHGwBAAAAnUlEQVR4nLXOS2pCURAE0HMlfmIUNCCuKzvI0py5hywkOHYBOvEXBdtJDx5BHhfFgqYKquiqEhEq0cG1NvwgCj4xTW7qNv4pEfGNeUVJD6sW/w1jdDHK/Af6GOIdg9T99HqZ7eaoScWOCzbYYo0FliUijlnwapxwzDvhgL8Gb/M2d7ipd/eel4j4wqxiyAC/Lf4lS87Y/xt5qPj/FG6GtjGY12SQPQAAAABJRU5ErkJggg==", 50, 4},
                ["HAVOC BLADE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABpElEQVR4nLXVu2tVQRDH8c/1QRQNKFgZRLGwVhHSCtZqZWejpYWNNqKi/gMWAQsF0UJtg4gSotiLL0QjCIJEBAmRGImPGEJ+FmcvHJJcb3Jz84Xl7JwzO7OzZ2a2kcQqsBGDeIBr2INZ/MZfTOPPf9ZvRh/24zG+tXPYKIGsxSHs6mDTn/AEzRPZh6s4WOQf6MWaRdbO4JcqyKliYxK7sRVzZTzCdQwVeSFJ+pOMZGWMJrmf5FWSuRXaavI+yUCx17Q5muRikr4k6kOSmSRDXXLeTZ4mOdni22ySh0mOJelJopEkOI47HaRVO8ZxoSafxzCeF3kvjuJKTecStrewVy/oRnlO4EwzkAGcXtmeW/K9Nt+iKvTpIveoGsPkPJ2GhWTe+zHcxS28k+RUkp9dSIWxVGm6FKaSTJQUWQ4zSQaTHEmyPrUaaXatHTihannt6MW6mjyCm/iCTbiMs0uwsxze4LbqD4wvptAMpJtsK85e4BwOqO6Pj2X+ARtUh/dMVSdzeIt+fMYNVTu+p0qd1+2crkYgvWWzh/GyQxs78VV1zyyJfxkRnYFvaWCLAAAAAElFTkSuQmCC", 50, 10},
                ["HECATE II"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABu0lEQVR4nL3VT4jNURQH8M+b+cmfMv6FopAFGlHDStnJRoqNxE4WktlY21gpG0UWw1JNWSglFNlaqikUg1HqUSQxkaF5x+L+1OvH75n7Zp5v3X731z3nfs+953vObUSEHmIHxtDqJQn0deGzNMP2I5Z3wZGNItO+gdX4ip9YjPU4jFt4hAEMYis24R4ezFG89YFlSmsDXmdynMRIpk82cjPyRpJKYAorcAH3cRyHpIwNYg3WYQLLSv/dpX0fTktZnA36JQVoRMR57JS0P4X5kmz6S+NpzMMlXGvb5CYOdiBpYm2H9XFMlpzNzAOQLuo9LuJIgSHsmYHjASxo+x/6h33dIUKqtXG8lS7qywz4q/iOH1KdNnKktRLD2JZJ2JJa8CS24BzeSQ3gU+ZedbhdYGEHg5cYLccL7MOdcm1U6khnsbHG/xXOYAm+YRGu6y4DnRERz+NPXI2IXRGhMjaX69MRMRwR2yPiSkS0Kv6tiJiIiGN/2aMno8CqtnM1cQp3pYKv4nct3cDlcn5C0ukHPMFjPJWk9N9QYL9UfAN4JrXLOuwtv9UH7ujch5aHAg8z7Mekt+BzT6KZBX4BjRT2nNo+BfYAAAAASUVORK5CYII=", 50, 13},
                ["HENRY 45-70"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABIklEQVR4nMXUu0qdURQE4O83okjUQkGxsRESxCBa+AaCRRB7S0GLFD5GUlsKtj6CD6GgiOaiiUWEBEmiEgSNeMlY/Kew8ZzjhePALtZe+zIze9hFEo/ENNrv6J3jEv34jmM8+kJ0YR7vcQHFA4W0oA8TWHwCYsHfe+55iVO8wF6RpBqREyzgB5owinG8U7r8VKgl5Ha/A81ow68Kj9YiyRrGqhxyhlUMo/vW/Dmu8AFHeItJ/McUDuog/weH+FdjbW0kWcr9sJFkNslQkrkkr5NIMpBkN8lypW7oaMZWnZp/YwYrylwO4CdG0IleDCpfpOGoJuQa+8oMHipjs443yp/oG742gGNdKJJ04yM2sY1PlfqzMrs9eIUvStd3PJPr1XADdZTrpjR8aVoAAAAASUVORK5CYII=", 50, 8},
                ["HK21"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABhElEQVR4nLXUPWsVQRTG8d/K6uVKhFwriyRoLGxUBCt7sZKAoDYW+j1srMTORhubfAkLUUidBAWJEhGMovhSeDV4IyYQcsdiprhZdpPJav4wzO4+z5xzZs8wRQhBC05hDC+x1SbAHrmOcTxqMhR72Mgl3EAXPVzEM3zDRsU7joBfNXF6uQlHmMQXXG0yFCGEWZzZJdBRnMAnTLUoJJff6OBgjbaMO5VvQ/xBWeIxbmUmGmT63qOPY5jAgcx1Y2leQzHyviF2/lrFP8RPHCqxkJlkDd+xmgKvY7rB20vaZiroLmbxDveStoQHSR9l3fajejx5PuxUXBFCmMZKg76C+5jDmxp9gCNJ7+ArXmMG50d8h1OB+0Yptr6JF3jYoF0QN7GJKzid/JO4XPEO/63M3SnFv/UEP8Sj0xfPY19sfxM307wktn8LZ/F8n2rdmRBCm9ENIayGyO0afTFsp9MyT/bIvU2qTOFjen6a4e+2zJNN2XLdW5zDSXyu0QeYxyv1l8R/5y914O4uU5hBIgAAAABJRU5ErkJggg==", 50, 11},
                ["HK416"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABx0lEQVR4nLXWu2sUURQG8N+uGw0qIS4+EBXBxkp8BLGzNo2FWNhaW4i21nYBwU78C6wkgq9yk0pRAipBBUXEBxKIhCwY0eyxuFeZDOs+spsPLnPnnjvf/c453zBTiQgD4DDeDELQBufwGU/aBasDEI/jKHZg8wA8ZezuFKz1SXYElySBFwvr9/EOLakIFWzFKFbzniqitGc1a/iFu2hgL17+T0AlIhrY30HkJ3zDGCaws48E4SeWsQnfsQdLWMHBLLyaxU9hEi8wm58fzYmOoFWTWnuow4HjOaGxdYiVD1vBtjaxZha7iK/YhVdZ/ERB8I/Ms1CJiPlMtiBlX6z2e1zBPWyR2jbZg8jfmJes080SXzCHGTzoyhwRz2MtmhGxmMfxiFAYZyLiWXTHndJzQxtVyRt/8RT7UM9jrpTfI0wX7k/mSl0r7VvuWql1opZFvZb8dFV6ITrhWL62pGTrUquLGLFR6LMlpwttv11Y316yxK2NtESvqOJGni/heiHWtNYGBwasY0cRveICTuT5FD6U4m8L81N9cveMfkincR438bBNvFGY16Wv4vAxRH+dLfn48kZ4uN9/iU6YxUfpA9DA4yFy/8MfO2b75SIbwhAAAAAASUVORK5CYII=", 44, 15},
                ["HK417"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB7ElEQVR4nLXVv2+OURQH8M/zpqWt3yJBWEwSIWFAYhIqxCgxsUknEavJajXaicHgH5AIkSqCSJpIKh0YiK20Wu1b7THcK63H03rex+ubnDzPPffcc77n3nPuLSJCF7APb7vhqALXcBsfVzNqdSHQZhzEFvR3wV8Z2+sY9TR0fhrnMICLy/RP8FTaoLaU2GyO05917TxeWMZhDn15rpWlByPYU4dQERH3snGxit2bHHgNDmFnJrahTpCMWBZjNpOdz+TXZ92P7LOFr9iU/y/jecnfujw3g4UiIl7g8F9IfMtBW9n5v2ICvZjOsiMT/45t0mmszePPmex8RSJ9+IK5IiJGpR0Zx0YcKS0YkUppKicyhFsNyE9LJzqZiS5Kp1RVWm3ckU7+Qh3nRUQM49gK8w9xsqQ7gLM5yNUOEtmFTx3Yd4aIGI0lTEbE8YhQQwYiYjGvG4+ImxExGBF3oxp9Nf02kh6MSXUYuI5nNfdgv6XmncMjqaYnKmynpD5433zLV0fR8EFsSdfsUWkDTkiJ/MKk32+0eakP241Y1iTUBJekJOA+hkvzY6Vxr5X7sCtokshW3Mj/M7jiz6vxccW6Mw1i1UaT0urFeZySHrChCptBPCjp3mFvp8HqommP/A278TrLq/x9iQ//Ixj8BCDzFJ97l5j+AAAAAElFTkSuQmCC", 50, 14},
                ["HK51B"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABnklEQVR4nLXVPWtVQRAG4CeXo6iJiaQRG21E/MCPmDIiIlb+AVFSCv4Af4adnZ2doIW1IkJEuxQmETQEbMQvojeKN6JG77GYBQ+ba/TknvvCsrM7Ozsv887ZM1SWpQyj2IF3uWMAeIWDWK1uFmnejj0ocQ+7MYmPfSTsYO0fZ1o4hNlepC7jehaw1AehOhjJNwrcxPkBJXyDYSHPML6K1hgTKowKRUaEWisYGyrLcganGyDwA9+x8z/Pd9P8XrRNC89woEAbTzBVk8RzPMUvHMVxUZF5HEtn2inpsvhwqvYsXqaYn9WLC3zGtD8SjuMkTuHwXwh9wVZczPbf4kLyL4vq1UYhyriKO5nvWoXUfSHLQlp3RMmvZjG38GIzRHJSbdFoncx3rmJfwQTuppgJUZEc6x69zaCFG6JBqziCE8n+hH34IGQ9KyrWtR6NkCr0fo+mK/ZtPMKutF7EtyaSb0QqRwuXKusHogIrgySSE8gxhb3J7uJhjfu29c1I70o9xhkh4X71/n9bGuDUk1SJmTQ2wpp4PBfSmMPrJkj9Bv08X2HuQWD8AAAAAElFTkSuQmCC", 37, 15},
                ["HOCKEY STICK"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAApElEQVR4nNXSsQ1BURyF8R9RaRQSE2gsIDYwhcIMZrCCSggljS0sINEpqREJCa7iPaFARCIv96tO7m2+k//JhRAOOGGLq9fscX7zlwUXjNC7PxSwkhT5xBrH/3l9TRFNiXdd4jSAXAghQ6+faEvlJSuqYZPPzudnhlimuYQuxFgE+k+5hWqM04IKNh6HGMdaBOZopHkX67Rg+pRnMV+kjAUm6NwAvEgp7xTIxOwAAAAASUVORK5CYII=", 50, 9},
                ["HONEY BADGER"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABeElEQVR4nK3Vv0tVYRgH8M89qJQOQi0tIQ4JbWKDgmEudwxxksaWwv+gIXJxCPoDdKi5KajdQacC3QKHgkCJphpEMPOCj8N5hcvpXm/nPX3h5f3xfZ7vec7zvD9EhAZtJiIeZ/q+H2RTaIYCNzJ9xwcZDGUKz+EB5tHGLXzBedIs0ME1tHCC4eTbSfw8PuI13vT6SCsi9vAIXytcGy9wvYffpH/LWKTgstCKiMA7/KpwU1jMFU74L8G18a0HP46baTyBVdyroX+MjRRkP/zGfo/1cxFxFhEjNU7ZXEQ8i4iDGIynTW6DQrnXzmpk4xNe4kOad/AQY9iq2B7V0P0LBT5n+k6nPvBHeWJPKzbDmiAiRjNSvtRVuudd64uVsq40LetJzf8Zwas0PsRmF/ejYns7M2eQ9UI8wZ00XsPPLu5QWeJLzGbGhbwX4q0y2wvYqXCn2MX9NF9Q3nNXXSX90WRP9GnrlX13N1cr9229CttYTv02vucKXQAZXiZ33EcJAwAAAABJRU5ErkJggg==", 39, 15},
                ["HUNTING KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAA60lEQVR4nNXTvUpDQRDF8d/FWEVEMKQRtBPRFzAggpWFj+PrpBJsfQMbsdLCRgRBrAIqRK0s4tex2GuhhR94FfzDMDAsZ2dnz1RJNEgfW9hrUvQrtOpcYRZddDBd505dm/pEZwILmMMjeg30NsIBDvHwwbkuZqokPWWSiw1c/hvcY4Dbd/W2MrhLrFdJTjH/x801xRE2cFEleVas9V+4wT52sK1YWQvPGMNQWdIrXGNc8X1b8egZTnBX1zt4wjmCFaxhs9ZZwnKDDxjUusd1z29JMkyym2QyiR9GP8lqAzrfjpayMKPXL/qvvAC4rMwnD9xXDwAAAABJRU5ErkJggg==", 50, 8},
                ["ICE PICK"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABcUlEQVR4nL3UMUjVURQG8N/TCkIhHBIiCXESMhqipoKmEEKHxkApp6aQdnc3hyDaoiEa2iKoJYQ2EYoIWmyMWpIHQlCafg3v/unPH8t6vvzgg3PPvfd899x7z2klcUAYwiU87TsoRbQxg9ahHgQ7gjPF3sYXfC52ExdwtlvRc7iGqziNZpxNfMAqlvEMOxjGdOsf3nQINzCHiZo/+KST4Y+ybkTnBipsYQ1v0L9Xpn2YxCymcbSceAUv8LJk862x7zDGcR4XcbnEeoJ5SXbjsSTzSdbyC6+T3E4y/Js9f2IryVyJ87E5OZrkbpKNsmAnyfMk75Pc7EKszsEkX5O0646lJJtFbCvJwyQTZX6gZnfLhSTbSaYkOZnkcS2zR0nG9inQ5PEk6+XJSHIryZ0iOtljsYpLSR5U46pkxnAf7/Cq/Mzve9XQX2IAb8tPbkOzTvvt3kn2g+s4hcXK0ey9vRaEK7hXd/zvhn9Cpwtt1J0/AQI+AwH0NOaQAAAAAElFTkSuQmCC", 29, 15},
                ["ICEMOURNE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABPElEQVR4nM3Vyy5lURAG4O8chwShW4h4AiHmPegJiRfoMPIAhDD2Et7CxIgXMDBmYqSZGUnc4hrE7ZTBWh0n4tK2kzh/UlkrWVX/rqp/1V4iwietEhGzEXGUbbIAR92t7POoYhk7WEEZPQV46opKgZgqJtCFQUwj6plUEZQiCuXQigWcoF9S6C8OcIOreiX4v6igDb+xh2Opu224zz7NuM7rKH5iDGfYwh+MoEW6Zj/wgLvMdY6mvD9Eu6TqRU0eZ55VvcqxcJu/DY+vxBxiDbuliFjHrxrnpg+Kr2IOGznxQSy+8GnGJobe4dlHX+Y7Rbek5r9GnqMTJVyio6bQ9ry/z+fzpYj4iiKrmEGvBlDknaa9iYackSKYlubiBMMa4K9V5B0pY0m619uY0gDvSNFCxjEgzUpVmq1vxRNXRwR/GJ3ktgAAAABJRU5ErkJggg==", 50, 11},
                ["INTERVENTION"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABxUlEQVR4nL3VO2hUURDG8V/iGhUUiRiFFAqJYKMBA2qjIoKQxk7BLoWNjaCVpaVt+oCQWnsrK0ERGy1EUogYENRExCcmxnwW92yyLrvZzUP/MNzzmHvPfDNnuD1JrJMd+IyruLPej2wWtS589uE+lrCIl2U8h18Yw7HiO4AjGCzztzi6ifG2pRshWzHaMD+IbXiNeYxge/HbU8Z1vm1OmJ2pYahhvoiZJp/3OIQeXFdV4SzuNvicKO8+V4l5iF7MNpyzC7/xZRPjX6YnfzfJjCrjzUzgCnZ28c1F1dXrxdey1klIMNldyMv8xH5M4003VwtO6k4EVeX6yri/aW9LizUqIUMt1lejLuQ75qViJslwkt1JNNlIkqV0z6skh5NMJekvdr7sTTesNVvzuWuyekUWcLGN8gMly52YwDuMq8o93rC3gGGcwqc1Zr47SqYerKL2dPF5nGQwyZk2lbicpC/JbJLRJHuLDSS5kWQsyfGNZr5TRVbjWnlOqvpkDve0rmBN1cy3VY3da6XxH+HpBvPelrqQZ232z+GS6s89VYKDJ1oL+aG6Qv+dWjl4rs3+BXzETSsiqDJ7Cx9U/5lZvPh3YXbmD1gslWkEpeM2AAAAAElFTkSuQmCC", 50, 12},
                ["JASON"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAECAYAAADMHGwBAAAAkElEQVR4nM3QuwkCURCF4W9hYX3LJnZgA1ZgAyaWYCBWZmYiNiGCmYGpqZmCaCDXYK/huqCI/nCYYTgMcyYJIcAKQzS95oxjhecXHFIk6OGkOkg76p+4YppiiT4mio+XMcAIKTJ00Yh9/tVTy9lihk0SQhhjj92HSzNFsA5qaEU9Q9fjPH/Te8Ml1jXmWOAOD3rDGjgve6YhAAAAAElFTkSuQmCC", 50, 4},
                ["JKEY"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABjklEQVR4nM3WPWtUURAG4GfDTREUBMVCm0DAH6CFhfgTtIuNnYiWWlgKolhYaiWCoDZiIRaWfiHBwsJCUAvxo1BQQVTWgOJHzGtx7uJ1NzFuvLh5YWDO3HuGmTnvmTOSWEJO5nd8TDL+F/tal8riOIO1mOyzf8PFWj+B+3/w0So6SZrrddhc68ewbYn9u9DFWzxoO7gB9JV6Q5L5DI8j/4MGnSTbsaMR/wFMDJnzJ4Ue53GopToOoJNklcK7TS34u4Gzi3ybUeiybHSSTOEwnmCvdoJeCMELzDdsE/iACuO1bRarlZMaw1ec7gU7g0t4plRmxaLCHqWya/DUaCo7ZeF78kap9D3cWSmcfYX1eK309S7mcBBXlQuswhbcwnX8wD7L7wYPcXnIvT28xDkcVRKbVR6faVzBQJ/dOKI+ezzJqdrX/iR3kzxOsjvJzmafbWY3iheswjXlNOcUbvcQXKhlYDZ4j5u1Pq1waRJbG/+8w+1af+7fZ4MxPFJa1xd87wv286/V8FNXNyOaun4C7uyPkfZxtm4AAAAASUVORK5CYII=", 43, 15},
                ["JUDGE"] = {"iVBORw0KGgoAAAANSUhEUgAAABkAAAAPCAYAAAARZmTlAAABX0lEQVR4nK3Tv49NQRjG8c+5Nn4kiO00K0Ej0fgLRCUSShW9RDSiVMvWColKJxKJUGjo0GokCg13E2ILimWDyHLvozhzk7M3Z04s+ySTOXnf8873nXlmmiQGdAp3sI6v2Fvi3/CrfE/wEe/xs1N7CBfwqqlAzuIoLuNYgewf6mZIo0r8JU4XAOwaWOPHQO43nknSHSeSPEqyns3aSF0rA7nzSSx0qJdwE3t6OvqOA5Vuv5T5Kh534sEKNkFOVgCzgjVsFGBXu8v8FOO+4pkn+3CmAoBFTHG/AI90GtqJt6WJSoutFzcGznWcZDnJvfLvYpLbSZo5P6tjhCVc6+G/xhO8wHW8QYMdeF529FdqktzClZ7cuQK5iM/asz+OT9oHOtkK5J32jLtaw0Gt0XBY6994KzuYaaEHAA86AMpV/FfVXvzd/1l0Xk2SyRxsVXsZptsFGeGh1sQpPmB5OwHwBwIu/VPhwT22AAAAAElFTkSuQmCC", 25, 15},
                ["JURY"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABVklEQVR4nMXUPUtcQRQG4OeuSwJrUmxIE+wEMfgBQQiRNPkPYi2CIFiIBBKwshT8BenszE8IJF2KYCUmaVJoYWGi+I2aQlkZixnxclHiXZfNC4cZzrzn4505TBZC0AJkmMAxAo7S2pF8y4lXRz/GsYC1Juu9wjvsYhbHWQuE9GAKb/ELD3NnD/BMFCOd1dL+Iucvi8eopv0pzm8TUsPTZE+wgfUC5xGmMYIhVNDIFYCDFF8Wo1gtE1DFe3QmG05N1Qq8c7zGSs43hvkCr3grFfxGV4mevuILTkrEyEII29hH3z+43/FSvPUMPzGQO9/AJuYwg8/i+PzFYCFXSDX3cuueOPNHZQRcoYotnN2B+wKLWMLzgohJ8RUPU845UWjbkIUQPqUm3jSZ44co8r+iIr5I4x45PrSol3vharTq+OZ6XneT5Wd4HzvoFv/wXvzBx7Z3fQMuAd7aWIxR7/0uAAAAAElFTkSuQmCC", 50, 9},
                ["K14"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABRklEQVR4nL3Tv0vVYRQG8M8VLUshaBFxkEahXPwDmtqipaYaQl2E9hZxbO0/aGkIAkehrUH6ExqCaLApAuVqSWje+zTcU30NhfujeuDA+T7f933Pc877vJIYMR4kuTLiGXdG1TFuOMxhAfPYwBq26t91LGEcHbTRwldcQhcnmMRhcdfwDRlQx8Wqc9hKsoJ3+ISbuN9Y+LmEqiItXMZtPMFYH8UO8L2aaooPjuo8eDlkI21stZL0s7lbgqb5dYvtyoMpp5vq1PoPWC4uFWPnfL8dsInTSH+4W1681+BuJJlK8jDJ8wa/n+TqX3h7A8VZ1tjFceVvGtO64LfNHtckZ7GNL439R9gbabpD4M/H/gzviz/BCz1rbGIHi3iNp3r2+YlX+Fh5R6/J7j9TfRaSrCa5lWQmycQ5VzeTZD3JTpJH/9s2/cQPqeoUgESrhlcAAAAASUVORK5CYII=", 50, 8},
                ["K1A"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABsklEQVR4nLXWPWsUURTG8d+sk8T4BoqFYqcRRBAsFFELGxsb+1TGT2EnCFb5DvoBRKyCEWyCooLgCyioUVFIYVgFIwaCxngs7kgmk92NM7v+4TIzd849z7kz58wZEaHPcS4iHkbE/AB8dRoXImJ6I7tcczK8xOHSXNRY/w2bsFz4WsAQfmAEt/ERx7Fjw2Ai4gQe1wwCzmCm5pqmvMZlbMWh0vwyFjGSRcQ8HqGN7/jcw+EithXnOa4OOuIOvMcezEmx7SvdeyVlxakcz3ANUw1ExjBRw34SN7Db2nTZIqVTmVv4gmG0pBR+2s1xjreFUZONXMQHXCnN3S/Ef+Nkxf4OntTU+FkcZ3sZZRExKdXHpZoCZd7hQOFnM47hBZ5jf8lup1TUA6eFXVLRNGXcarDnpbR5g+24W7HN+tDpSY4lzZ/SaVyXApyyPj3bleu9+NpQqzcRkUfEcINGNRYR7UisRMSRLs2szMR/appa+GW1oOowhJvS27wn1USVmcr12QY6/0QWUbcPrmMUR6Ve1IlZHCzOP0l9oG/RKv38ovxlSfdNwLTUDx5In+YWVgagu4Y/cguKMaEeSIYAAAAASUVORK5CYII=", 50, 13},
                ["K2"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABu0lEQVR4nLXVu2vTURTA8U80IUUsig9oFVQUBEHi4CLo0j9AEdwcnFx0dXGwk7OLxUHd3QQVpCI4SNXBCoqVDp20U0F8YDDgi+Nwb+DXmKTJL/YLFw73PH73vPiJCCXP1oh4GxFLEXFyhDhrnbmI2LuWXdXwjGMGR3E4393CVXzssG3gJ36hluUqfqOZ7ypoYbmL/27swx586PeoKq5jI57iEb71sB3DEVzG6Q7dBG70+9AAPMZr1DGJFezEDqkg7zrsN+CgVBSViFjEoREfMQot/JC60ZQS2Y/3+b6BRambRdqJLGCsihd6J/LH6g5tyQEG5S5mpY4XqWFzlufyG4ocx/MsH8MrufI9iYjpWM33iJiJiBMRUeuyWJsi4kxEvCn4PIyIexEx3xHrfMkFHx/Wp4qvhbzu4JI0n71o5UofkHbmMy7kqm/Llaxn26W+VexNc1iHKl7ipjQC9wf0a+BKlk/hS461IiXaTqT+r+s6UaLtkxGxnEfnQRf9QmG0LpYcraHPMIvb5iy2Z3m6i36+IE+ViF+KMolcwy6cw6cu+icFearkN4amEhH/O+aE1JVn0uLflv4H68pfhbQeLlaOUcIAAAAASUVORK5CYII=", 50, 12},
                ["K7"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABZElEQVR4nOXVPWsUURTG8d+uGxuDkHyHWASxUhBTLQiCvaCFhWJnl9ZWexsrUZJmGyvBT5BGQSs3GjsxIBaiSHyJEfWxmFmyC8nszrja5A8Dd87bPHPm3DuSaHjNJekn2UhypkH+g3ExHfU5jNs4ieOl7R5uYGsoro1F9PENX0v7DOZxbNyDWknqiruEXt2kfXiHt3i9h2+nleQJ1vAbb/Brj8Afio5BFxenJK6SVpKnOIePE+Ys4BmOThD7COcVL7dT2jo4Uq638cI+nZOkl2Sp5jCfSPIhu2wmWU/yOaMsjqlzqsrfVgzq/IRdG/Act4buuziL63hV2q7h5Zg6G1XONubws6a4WVwp11cVn20WD7FS2j9NUOdLlbODTbyvIayF+4pjZB2ris00YLtGrUo6WK6Zs4wL5fqmUWFTpckhfBffcRmPpytnlHaDnC3cwWnFSPwzmoj7bxw4cYOf9aG/LfQH6uc0rKhFHCkAAAAASUVORK5CYII=", 39, 15},
                ["KAC SSR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABX0lEQVR4nMXVP68NURQF8N9lcl1XFCSeAkGiUJFbCInyVUQl0WgUGpWI6DSiUCpE4QuoJBo+ASJPpRCUHiHxUEiukFctxZyXN5m4cifjz0p2Vs6eM/usteecOYMkemAjhriJw3iNVQywXOaMcBLv0GuxGRhiMuhpZAOu4jqm2IrvGPeW1xFV4RE2lxg1eIxNLb6vFl3hNhZLjUHhz9jbQ9MTXOowf4iRJB+S3EnyJvNhWxJJTrfyq4Wnc9aZha9JqrLG3FHhFS5gu3qv7y5d/YIjOIDnjQ7cwgImjdwL3MUDnMJOHFN/xa5YLlo+dXorydMkR3/hcpjk5YxnFxsdnCY5k2SS5FCSLV27+SeiwgrO41nL42U8bOXH2I/jjdxj3OvUvb+ANSNn8Uh9cHZhD87hrVr4vhI78KNVY+nfSP09KrxX/4Wu4KP183FNbXJtvKLet99wAjdw0Pp98V/xE8OTiZ82/I/mAAAAAElFTkSuQmCC", 50, 9},
                ["KARAMBIT R"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABm0lEQVR4nMWVP0hVYRiHn3sUlKAWwcElKajNP6uDoA5hEJGDoEtDTjWH4JIGiiDo4lLSbhQUrhEo6hIIuhQiDhVFg5qCXBRvPg73XDx86L3nojd/8HI43/vy/Z73nO89J6NyQVUDc8BbYAvYBfbi6y6wX/aOatqoU7vV2sRagzpnca2qw2pLWq80RY3qe/VfbLKtflKX1MMSQKG+qg8vAnVNfalmyzROo89qc7lQveqPCsAklTPfdEmoJnW+wjChRkOo6sSZfwK8AqpKzMYRMAjMAvXAFNAR1GSB5Xj6CsoATcCdoHYIyAEvwul77OlBPk+b6gf1WdDZDXVH/auOq51qTdh9Im6qA+aHJ5fY/7mJ1/coSJ6l12pVEaM+9XaR/HnRqi7GHgfqrQLURLz4RX2jfo/vc+pHdSp+GuUapo2M2q/+Ud8loSbjZOFTsKD2VBDkrLir/lbbIiACRoDC/yYLjAE/Sxz4y9Y60AU8iIBm4DAoOCYP+7/1DZiOgDXgaSIRAfeBlSuAAviVUQHuAe3AAXAdmAE2rgiKE+MJmz/k8x3oAAAAAElFTkSuQmCC", 37, 15},
                ["KEY"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABOklEQVR4nLXVsUscQRTH8c+dSSHYWIjE2KQT0loJgjZaSgqbWFvapoh1ipSmVStRxDZdCnN/gI2IFukSSJkmREUl/CzuJJvF25DT+cJj2beP4bsz82YkUYnxJO+TfElyk+RnksMkr2t1RaKeeJf+PC8t0/Y38/oz1/DtUajKjGC6oXaurMofmUls4GlD7QKWsYShEjKtJLP4iHOMYnjAsa5w8QCXsVaSk57MW0zgCM8eMOigLEryO8nLyq7ebeiokly0cYaVnt2E5o5qIuj0nnV+4Pie3B03WHmsPXOFVezo/tg0FrGHFvbxDes4xQzeYA1TOMCnu6WZTLL9j2n8mmQ5yVKSdgqfwCNJrhtkNksIVKN66P3S7aR+dAZYvv+ifh18bqjtFPQAT2rvH3q5V3iBS93Z2sL30jK3a+J1LqWZOigAAAAASUVORK5CYII=", 35, 15},
                ["KEYBOARD"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAACCAYAAAAaRY8cAAAAc0lEQVR4nNXNvQkCURBF4e/5u6CY2YGBgYmVCNudbdiAmVYgKFiBoZGw8sZkxG3Bmxxmzgy3RMQeLV6Y4YkFOjS44YId7ljhijXOmGPjlwEqIlkxSfdGyd04O6fJUd58/bA3d+lrjwds8/9YIuKBpf/O6QOxmx5W4Igb8QAAAABJRU5ErkJggg==", 50, 2},
                ["KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABJ0lEQVR4nO3VzysEcRjH8ddolxQ5UyhnNzcnB+XgwMnRH+Dg4O6fkFKbk1KOclG4uSnFwYk9+JmIUNTu2sZhvrStlW0b+ZH35fuZ+X6fzzPP88w0URzHUmAV42kYNUrTdyZPk/9CfhoZDFdcnyKP5zpiW9EZdBs2q/ZLmMYM5jGFHCaxggmsYxA7GMAB+nCCrvBspeD3iGLQTygE/YCLKH7/tR+jF7fIoj0Y9+AsJCjiGt2fFFtASzjfHNaspFEZlBEhDqsKHYczi9gI93LoqMpxj6Fahfw09nAY9JikIa+cYxT7v6GQWpSxgFnckYxut2Izj231vVo36A+xIyHmKyngCMtYkkzjjSilgaxhLg2jKsq4wqWkcR+SSSlhjK2UvBriz/xHXgBHZVKFWT6XkAAAAABJRU5ErkJggg==", 50, 12},
                ["KOMMANDO"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAGCAYAAACB1M0KAAAAyElEQVR4nM3SoUrDcRTF8c8fQYfBooIWo8knEIt7BDGKD+Ab2IxiExb2DJZteUkMJtNwTKNJ1GKVzWOYYQxRwR/ML9x07j2cC6dKMo8T7GADq1g0W55wgSZusYV9vOFlYu7xCJIc539zmeQwydUXWj9JLQlJBhNCI8nwG9PzYvHKcZpEleQVS3+owRAPWDObSo6wXSUJ3tFGB3d4/uF4wbizuzjCwPiRHlY+d25QRxdzhcNP06+StHCG6wKGm1jGOg6wV8DzV3wAbRawFwKF/QUAAAAASUVORK5CYII=", 50, 6},
                ["KRAMPUS KUKRI"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABPElEQVR4nM3VP0vWURjG8c8vREltEBUdc+gPSrs0t9jeuxCcdQ4C6QU0BEWja6EujkLQoi0NgjjolJhZYEV6OZwf+iQq+vgkzxcOnPvc933g4pzrnCrJLDpxW+EvBuv5Twwh+FPn9tCN/TqGH3iKbXzD77ruAN9xWO/V61+60VXXrWEVK9hxRaokuWrTDfAZ8/iAj4rQC2lXIY1s4h3eKqd2Jv9TyBfcQ0cL91zEcyyfTlRJXuJOw9oh+hviPif+6MSWcrc7sKv4B8bxos5T7vuoIuYrHuAJxlDh7jUELWEan45XkrRqzCYZvmTtQJKpJAtJfqU5DpK8TtKfpKVCJpL0NtHXk2QmyXqTgtaTPKrSPl6/hceYxLM63nfyLZzHBt60k5BGhvBQ8d8r5V8aUbw1h/vKa/ZeeQB2jwCwkpt9G7GegwAAAABJRU5ErkJggg==", 50, 9},
                ["KRINKOV"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAByklEQVR4nLWWPWtUQRSGn2v8CEhABCPZQIzgB1go2ESQmH9gQBTESlIKlrHQVjvFSm0EFYSQJqRJoSiW2RSColHwq4im2WAkMeCCmMfijngdrsnubPaFF2Y4c85558xhZjKVNqACTAPDwDKwBRgCvgE1oLvE5xdwCrgJPP/HoqZwUF12Y7EaYp6I82XqALDQYIUyoB94BHQ0Xd+/+BR4CHgD7AH2AlNAF/A5VHYO+Jmpc+RHsB66gH3AphbESb7RMqwCD4HjQE8QWQMWNwNPgJF1gleA88AosKPE/gP4HkTsjmwvgCqwRN6XfcBj4D1QB1YC68BE+dZ0Ru2M+mC/OqLeVz+oH8P4knpMvVDopWl1SM3U02o96rWxuMeaJeo99bB6UR1X59VX6i31rFopcdwaGl31rtqt9qoDwWemIPLtRohcUqvqdfWkurMBxyNBwIK6LbJ1qJejah5sVeSuBMcrIfmD/9iPRiKvtSoyhdWQ/Mwaa14XRK6o/akiU6+TWeALML/GmhuF8XbgTmKu5Eo2wkx9Fh37uZRYmbbl7f6DA8BLoDPMa+SvzNdmgrTyejSCd8DVwvwp+YXfFNpdSch/QFPAbWAyJcBvZZriwvQUZB0AAAAASUVORK5CYII=", 41, 15},
                ["KRISS VECTOR"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABjElEQVR4nLXUPWvUQRAG8N8lRxA0iJ3GwhQWihZKECzEIo1gZ2NAAsbC0tLCxtIv4AcwYGWtohZisJDYWHgIEcQqimAgiETFt8cicxCP+1/iER9YdnZ23p7ZYSUxxNqb5OI/+sx15bbhcAi7MYEWftU+gt8lt0pW+pOYh1aSfkHnKnAvTpR+Yshid2GtlWQK3/CqLk7hKdbwo8fpIxZwupKv4BGWMV1FqXhfsRNjG/z34YMky0ne5W+sJNkz4H0uld1CkpnSXc3muJ/kXhuv8RO3MYNJXMfqgDZ1Gb2pDk0V0168xCK+YBQ3ukwfJJmvam8l6SQZ3WQSl6ry2Q26F32Y9e1Wd3rHcRmzOGt9GpswhoMld2o/h2M9dsuN3UrypN4wSe5uwlCSsSQ3y286yfkkn/uwfNgUo43D9S6PcWcAwy6+48qG8wQuYEedr+E4njVGSHIgyeQWGG51vS2mZ5psmj6HYTGOT9Z/o/14389oZDsz4kglXG1K+D+SHq29M8hou5OuYQnPBxn9AaaqFSn0yNjQAAAAAElFTkSuQmCC", 29, 15},
                ["KS-23M"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABQ0lEQVR4nMXUv0pcURAG8J/Loqws6gbEBLvF2FhYausjxMLSN7CR+AopFHyE9CmChW2alBbWgq2IWURFWFf8A5PinCWrqNG7F/eD4c4M937nm5kzdygilIgxLOEjmpjI+UY2GMYVjnLcwR9cvOGcCsbxAVOYrfaj+hGWsSUV8O6olMSziZ9SEbclcb6ENk7xS5pKs4p1bPdBuoqN7N9krgbm8RvnWMPX7I/kw2ewiDlMP8N9hLsn8oF71KQreSEidiOiHhEKWD0iDuMfvuX8UEQsRESzx57jGM1WK6hBRKjiUlqctnTVJrNNSUvbjT/l5ziquSvwuadTP3o6tve/UWZ0Xvnei+gu+w6us3+GE+kOnkrj3c9+y8O/Sx0rmM3xQRmiiqBbyBccF/i+je/lySmOilTM/aCF9IuKtAutQQvpF38BaOXOEPWpp44AAAAASUVORK5CYII=", 50, 10},
                ["KSG 12"] = {"iVBORw0KGgoAAAANSUhEUgAAAC0AAAAPCAYAAABwfkanAAABoUlEQVR4nNXVPWsVQRTG8d/q9SViIJGYVKKFWkXRJliphSCkMSD4AUxl4wdI5WdIF8HaFH6AVEFQFKKgTbAQVEQMGhsTjYjJPSlmr2xWs/e6iwb/MOyeeXl4mDlzRkT4R206IrKGGjMRoeXvk+EwTuIq5rGO/fiGvWhjI+9by7/r+fo9+bw+XMBYFhEzWEV/DUMbWOnB9HU8xlLFvCMY7qJ1CNNZRARe4kSPRnecXTttoAZL/6PpZ1lEtPECiziOU2jhB55gGR9wBmMlgc/SJaoiw4CU+58q5hzV/eQnsdBC4Auu4QpuSBdnNW9F7mAIj0r94zhf6ruHp/n/MWkTblYYuihVik5lWcM+aVPaUpWZw5aSN4CDeIj32whPbtO/XDL9Fbek05OPvakwDPe7jP+keBzncBq3e11c4FIpfi2l2aB0Mrvxtobub+mkRx8mpLz7+Ica/VJadXhXiAfz74P6Fn+lhSl8l/JotobGBA4U4rt41dhZBVl6Wxoxh8uF+CyeNxWtoqnpIelp7lzoRYw2NdWNpo/LiK0VaL6hXk9sAkCW3l2tgZsfAAAAAElFTkSuQmCC", 45, 15},
                ["L115A3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABLUlEQVR4nL3UMUvVYRQG8J95wRTvoLg0ag7aEikEgSCBQ4ObENEH8RM4ioOtTS41NYhbhBAhiIMShOB2E1xdjBrMx+G+w58/lvd6Lz5wOIfDeQ7PezjnlcQdrZnkdQ/8qvXcp+FueIlXmMSTSj7FD5f4BBc17gweYKCSe17hdorBouMQPxpYwBSWa4Vn2LyhQRPvC6df+In5LjmDeKM9lMmBJC2MY7SPwrrFVyz20uC21brCKj7jKbZK/q322rzAuxrnAp/wDXv43YGOPx3q/TeStJL8ys34m+RhOaixJFdJ9pLMJplLspRku8Y56tMH0PWxD2GkvGsNG5jGBzzGfpn+M+0D3cFxZRYT+IIWTou/dzSwjt0SX+IcB9qrtIJHRWyz1Hyv9fh4X2L/h2vr/2Uq5peL5QAAAABJRU5ErkJggg==", 50, 8},
                ["L22"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABoklEQVR4nK3UPWsVURAG4OeaFeKNIlgkIiqiIIJio4IEUws2/oNU1nbW2oqtjZb6Byy1ECxUUGPAkAQbDaKEqIUYQgzmmrE458bjsne9hS8sOztf75nZmdOJCEPgFr5jER8K/eua30+cw5t6gmoYFhzBTcxiK+smG/zeY2dTgmGJ1rGEvRjDJvbXfMZwDKODiF5gFYcaTrOJjziP6UL/A1Ho9uVDVLiIp3WiTkSsYGKoutqxji7m8CXrdqOH1Urq6/8g6ub3Z6nNfVzHSoUDDUE9jKCTv7/iPpazPIUrhf9bPMRdHMaNnPda9icitiJiNiIuR8TJiBiPCBGxFn/wMuv6z0hEvCvsjyJiOtsORsTViHhQxlTYMaAVSziV5fpe/MrVHcUMLuGENFDfMJ6fbQwigeeFvFyzdXE2y/OZeEGa0DVpxP8a8zaijULeU7NNFonmG2J7mXwbbQv7qZCP12ynC3mhIfY27pWKtopeFfIFaQr7eIY70mpMDTjkYqnotFyqo9KP7bfojHTX1bFLuila0da6DTyWKnkiLWIT/kkCvwE+t6q0jK8+kgAAAABJRU5ErkJggg==", 26, 15},
                ["L2A3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAACEUlEQVR4nL3Vy4uOYRgG8N8wExrGoWbMQs7KYUSysFI2dooFyh9hhSwtUchKlsp/oCSHkrKgEEkhp0+Z5DDjOA7DZfE+X76mj8Z8M666e59T131d73M/zyOJFqMtydUkp0eMz01yahz4/xYzk6xJoi2JFnASm7AMX3CmYa4H83BzlFxDeIr3mIR+TC48w3iB2ejCOwxgK5ZibytGZuBeETteCL6qDHwtY1PxHT/QVvpf8LNogKH2FpJ+LAlbwbsiqBMduFa+HXhY+JeVXE+wE29wA29LfxKej2ZHpmEh5pdYUL5dWI1FJdFrPMe30v+OT9hehDbDC/SV9pDqjw+rdqajjH8rhiajt6wbLHM/MB2D7ejGHKwsAuui64K78QE1VQ3X8Aob8RK7ca6QNkMf1jf0a6qzdBePVLXeDMMN7Tr3kybrBqAtyXVMKU5rDfEUz0q7nqwHe7AOR3H2DyLqWI47qr/7CpdwHcfK/JJipmW0Y1YhPvGXdXOxF2twBPtGyX9cZWIY+/FZVTbdqtJ8ORbRTZGkP8n0P9zTvUmOJjmfZPM/3vHb8huHy1hXksVJliTpHM83RZJakhkjJnqSHExyIcmWMRBPS/K4mOgvBibyYSTJgyR9IwycH6OBehxo2I1dE20i5WW/rTofq1Sv5CFcbrFib2Et7mOF6lxMKNpxETtwAFfGiXeD6lqe6T+YgF+o8Nsuh04prAAAAABJRU5ErkJggg==", 50, 13},
                ["L85A2"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABsUlEQVR4nLXVz2oUQRAG8N/GFcSs/xAkKgqC8RLIUVDQgyA+gB715oP4AD6AePAkePDgyYMXQVEUxESQqDlIFGIEY6KgISom5aFbth1md8e4ftBQU/XVzFc13dWtiNAAl7GEWbzNvsBUk2Tcx3Vc7UdqN3zZIdzANNaz73jDXPiA1iBSUzEreIMd2IZVjPXgjmFrxXcAm5uIeSKp7tQk/MA8juFC4V/CGs7m5z3YiUmpc58L7jr2YVPhn83f/QOtiHivd5UbwU98x6i0r75ge4Uzh9fZ7uScZRHxMIaDhYiYioj1BtxLEaG62thbU90qtuhuuo+4gsW8TuFiwZ/BTVzDURwe0L07td6IWIuIxxFxJiKOREQnK10uKnlaqaIdEfNF/FZEnM+xg3VVN1ltaWPVYQ67sv2oEkv/mP24i3MYl0bA4oCu9MRIn9izwl6oxHZjItvPpZP1Sirg6/8Q862wO5XYiSJ3ZqMf/xsx7wp7vBKbLOyXwxLTbwKXQ+mkdLJ+X2S3pdlxOsceDENMK3pflKP4pDuVJ/Cihjeie1/9E/p1ZkU6KWu4l4XVYShC4BfK10i/1Nww+gAAAABJRU5ErkJggg==", 35, 15},
                ["L86 LSW"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAB4ElEQVR4nLWWT0uUURTGf+84SeEfJLCVjeRCxKhFkZE710IfJPoWbdvoRltFLgShj9CiCKJFCYPJIBEOJTSDpDGjoCbzuDjnpet1ZnqdZh64vOee89x7n/vnvPcmksiABaAClIAf7hOwnqUx8BooAs8y8s8hn5FXAF76QOmsZi8xThU4uQT/HLKKrAM14BZw1QcsAB8iXgKMNGk/BvzqTCIkkj5hqzMI9EfxP9j2PgIGAv8e0ADeeNtR9z8EhlqM9dH76UhkFbjRSeMIv/070iJeB3Yz9nUKXMfy4Gse+EZ3RB4Dh8AwkGsRf+W2nBue035sN1M89u+TRFIZGI86PMC2N/F6FVjGVuInMAc8DfiHWOauYAn1oInIbeBFs9n9E5IaktYlrUk6lrQkCUk1/cVn96UlJ2kriBclzXtsLOL+d8kDE0DZNX8HVt0uA3fcfh/NreErOglsAPeBKSzj9ztarTbIBQJTpMKKga8Sca5hmQwm8hT4gk2y3l2JFw/4AXDT7aPAPxjxZrD/JS6up4hF7mCpn9opJiPe3cDe7LaoC4gO6W1JBbfng8SoSEoC3j1Ji5JKkp53O1HikrR5YAxjN0uf16exB0aMK9jN1DO0u7trwFvsbL6jddb2VCDAGb65Zt3fD7LLAAAAAElFTkSuQmCC", 41, 15},
                ["LINKED SWORD"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABBUlEQVR4nM3WsS4EURTG8d+wsaJQiWJblcILKPQKUYhOxAso1N5DqdyICm+gJpFtFDo0WgpkE65iZ+IKiXHvyM4/mcw9mZzJd843594pQggyWcI+dvCa+7JUOpn5qzjAijEWQV4hyzjBLu4bUZNBkfhpTeEaPczhuUlRKVSO9Mr1Xc28dSzgFot4wxPe8Rjdf2MWk1HcxUwUV+uqUS94wLfuFyGEU6yVD/u4KoVAUV5x3MUe5msI/Q+GuMEAlzjHoAgNbFst4LCDM5+OHOHCz05U8bSWOsLfZ2QTx0YzsqElM1JT+xdat2tNJOYNsW3Uza3m5KST6khFfLKP9VDMLYSW/Gt9AABUWPTDV0pUAAAAAElFTkSuQmCC", 50, 13},
                ["LONGSWORD"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAAArUlEQVR4nM3TvQlCMRhG4UfxfwUbC7G0EZzAUmysHMMR3MBZxEpcQERwAAuHEMFCYuFtLXJjxFMlgRfOy5evEkIQyQALrGKDOamWyCyx/bZIKrFFOhjjlMElidgifVwzeCRTCSFs0MC5eGujVZxvqKNZ3LuY4P5Dx088ccQeuzI78i9Uvb96G50aZhHhIR6YZxBLInYiF/QyeCQTW+SOA0YZXJIosyNrTL/skcwL7OoXItfN2nkAAAAASUVORK5CYII=", 50, 10},
                ["M107"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABgklEQVR4nM3VvWpWQRDG8d+Jx6BvjFgEBBWEgKA2WgSEaJXCQiwEvQHb9OI9eA+KaCuIWCmCH42kSplglcKPYCUIxmiSSTGrvp4Ino0R8sBwdjmzs/vfmd1tIkKF9uIAvmMF67iOq7hcfEYwiYP4gsWaCbarphLkCh6W9nsJ0+AQPmAURzBWfF5jegfW+Ve1lf4fcV9m5BNO4LHM1CTG8RWnsQ9vcBRRjAQ31F8vcf9JTUTcwLUywYY/w63K3Z/G/or4UcaRgO/8DgWn1GdtgHNYkGseNBGxhOOVgfpqwy+QFVmOXZCzeIVvFXEncBg3ZeZPtniOS3gpa5wkftAZPIszPSaZwx1cwBLeDv2bkuUYeIHl0r4toftqgD34XPqtiLgbEXMRMRIRis0MtX/YsUg9i4hbEbEYW/U0IiaKfxsRTSdGt79j1sq6ncL5n3RJ29VM+T7CE3nYL2J+yBawVvzWbFXVFVmjvtfvuHwPluXBXP1fC9qu+l6/Y7gn34VdBwGbHFf3mJfeNPwAAAAASUVORK5CYII=", 50, 10},
                ["M16A3"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABuUlEQVR4nL3VPWvUQRDH8c8lp8aIIj5gYRuM2KQWCx+IL0GwshYrC9+CvVikESwtFOxiQBDURgsLC/EhwcaARgwY0JBo9H4W/w35cyZ3l+PIFwaW3ZnZ2ZnZ3UYSfXAe0/iGWXwt40Us4Dve4n0/ztu4ijHc6KiVpB+ZTsW7LdabSab69F2XiSQnktzuptvE5DYzdLxkaBEnVdlvL+swPuMFjqCBUbSKrJS5EQwVWS62Q9iNV5jHS6x2C6qRPntrh/iBJRxUte5mjGKh2YfzqLLZjS/4aaMiu1TZ/q2qChvZb2Gt5nsXXuMWHuIBLheddvZiZTsVWcIbfMApnO6iP4E5HC4BDuMPmvhbAm6U8frcULFtlf2W9Uo6s5TkbpKLSYZrl2uypnM9ybEkT9ps9w/gsvcsTf+3yorqab2HGZtftLM13XnsUz3BdXppv8GRpJVkLclMkitJDnQ5/ViS1ZL1m1tUKUkO7WRFJLmW5Og2jB6VQGeT7KnNj7cd5MxOHmQIU7Z+2toZwSd8xB38qq3Nqf6WdS4MomN6pZHBfiP3camMn+HcIJ13op9/pBOPMY7neDpg3x35B+Ddzaaa0l23AAAAAElFTkSuQmCC", 50, 13},
                ["M16A4"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABuUlEQVR4nL3VPWvUQRDH8c8lp8aIIj5gYRuM2KQWCx+IL0GwshYrC9+CvVikESwtFOxiQBDURgsLC/EhwcaARgwY0JBo9H4W/w35cyZ3l+PIFwaW3ZnZ2ZnZ3UYSfXAe0/iGWXwt40Us4Dve4n0/ztu4ijHc6KiVpB+ZTsW7LdabSab69F2XiSQnktzuptvE5DYzdLxkaBEnVdlvL+swPuMFjqCBUbSKrJS5EQwVWS62Q9iNV5jHS6x2C6qRPntrh/iBJRxUte5mjGKh2YfzqLLZjS/4aaMiu1TZ/q2qChvZb2Gt5nsXXuMWHuIBLheddvZiZTsVWcIbfMApnO6iP4E5HC4BDuMPmvhbAm6U8frcULFtlf2W9Uo6s5TkbpKLSYZrl2uypnM9ybEkT9ps9w/gsvcsTf+3yorqab2HGZtftLM13XnsUz3BdXppv8GRpJVkLclMkitJDnQ5/ViS1ZL1m1tUKUkO7WRFJLmW5Og2jB6VQGeT7KnNj7cd5MxOHmQIU7Z+2toZwSd8xB38qq3Nqf6WdS4MomN6pZHBfiP3camMn+HcIJ13op9/pBOPMY7neDpg3x35B+Ddzaaa0l23AAAAAElFTkSuQmCC", 50, 13},
                ["M1911"] = {"iVBORw0KGgoAAAANSUhEUgAAABgAAAAPCAYAAAD+pA/bAAABFUlEQVR4nK3STytFURQF8N/1XkLGDEgMmCgTKUbmRkoGJvIVDOSTeRmJkVK+gCgihREG8u9tA/fqeO7znq5Vu3M6+5y19t5nZREhwRZW8Og73lrO+tDvd4zhOmsRuMRoh4d/QhYRM7jBE+7/kxwndWxiBM//TA4vdZxjCEsdLu/hDAtoYht3Sb7p5wSeREQRixHxGuW4i4je/N5ARKwl736NnkTtACdtqu9BLdlfdOj2C6mLJnCaE6S4QgNHOXH4HFfoAvVkv15C/oBZ3HZbcSsKwho2SvK7VchTgWWMl+R3qpBD8dv7Jc55j4jhbt3SLkTEdEQ0SwQOq5IXNl1FVtJco/J4fNp0EPOYwySm8nUJx1UFPgAHuCAfqpubJQAAAABJRU5ErkJggg==", 24, 15},
                ["M231"] = {"iVBORw0KGgoAAAANSUhEUgAAACoAAAAPCAYAAACSol3eAAABjUlEQVR4nLXVv2pUQRTH8c8mKyYiSazSKWKvdRoFS58hhY8gVjbaqZXgAwgWNtaCCIKinZ2ondhEEP+hMcSYGJMci5nFm+GyO272fmG458w9M3Pu+c3c6UWECk7hNb7hCz7ha35+btgv8b1mwv+lXxl3EUdyW8ablphFXMOlSSRW0ouIRWwPiVnAE5zM/i2pgiUzOIOnONvoX23YO1jHHkJSaAa38WtUolXaV7KJ2THG3cRaS/825rBVK30t02OOm8dUS/8WjmK3j8OGS7+Me5UL3sc7+6XfzAsOWJe2wJ5UxcB1/Bw6c0SMaici4kbs531EbBR9GxExVTHfWK2t3CUruIM/2X+I4zhdxO3k6nRC7R5dwqFsr2b/GH5LW4eUaN+/D5osFWWfjYiVLO+H7A/ePWhIv9aV7LXSX5akhqvS4RjwsWHPSf/cThiV6AKuZPsV7hbv3xb+0gRyamXUHv2B87ggVa88LM8L/xweTSSzgt4BL6Zp6Rqcz/4LHVX1oDfTLh5LiT6T7vlO+AvryV2hWKLF3QAAAABJRU5ErkJggg==", 42, 15},
                ["M3A1"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAAA6UlEQVR4nO3TPUpDQRSG4SfhWlhFdAduwdYd2Cu4Dgs3ki2YDfgHinZpBQshpdgEIWAM/iHeazERNcydO4p2eathzuF7mTkzraqqZNDGNgYoI/UOtvCIBTzjCvu4jQW2MsXLGOU0znCJo1ihwPp0/ZQI6PxCWqGP0zrxGk6wmAgZ4wAbmdJSuKVxXUOBB2EeTQy+iHu4wabPmV+gizO84j4VVog/lhgfIxniEOfYFa50lrJm/5s4hyVhJLCDvUTwHSZNgQWuM8QrwglfcJyQmva8NQXmfqefMBT+82qqqf3X1lzm4rn433gHBZ040gudpfUAAAAASUVORK5CYII=", 30, 15},
                ["M4"] = {"iVBORw0KGgoAAAANSUhEUgAAADAAAAAPCAYAAACiLkz/AAACCklEQVR4nLXWS0vUURgG8J8XwiyLgkJbBEUEUYsoaFO71mVkmwpsF/QB+gbRjWgZRLXpA3RZ1MIwEoqgVhFZEAoRxVRmYhdHcHxbnCOMgzp/HeaBw7m9572c9zmXlojQAK7iLEr4kUsJ33P7Wy4vMbMMvb3oR189wfbl+TsPnTiN9RjFMcwuINePLjwuqHcnxrCxiHA7tuf2V5QLGoGjWI1pbMPFReR24xGOYEcdnXcxhUG8LuJES0SM4Rcq+LOAzBgma8Z6sBdrixiR6FPGJ3RgHf5le51Shn6jO9sqYQNu5HYrNmddZSnTXai0RPFDEHgjBdqDLQXXza0tS7vbmp0u58DapExO5foV3uOUlImPec2amgACP9txC+M4ia1VRidwEy8kek1gpGr+OQ4WcL6CKziEXbk/jpbs2IyUjTZcwz0MSxS6LzFgcUTEZESMR8RMzMdIRFii9EbE26iPB3X0NFRaJS4N5+g/YA+OY1+dnX2IJ1X9M3lXL9XI/a2jpyG04zCeSvS5LFHlXcH1+3Ndwarc76iRaeihqYsG0tdXRZPrVeObaih0u5kUWunCjogYzQ6WIqK7aq41IqarAhho9hlYCc5JjxdckO7qOcxKV98cDkg3TFOw0q/EHXyRrsbBBeafSS8w6auxT8GXddloUmpP1JyD882iUCOfuaUwhM+5HsJAk+z4D05vz1lTmv18AAAAAElFTkSuQmCC", 48, 15},
                ["M41A"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAAB70lEQVR4nKXVTYuOYRQH8N8zHmbGWzMpk91ERnnZUErS2CArxUpSfAAfQPEFJFnYSElqrFirKUpYKFGzoIyMt0zyksjMYPS3eO5pbk8zj/sx/zp13edc53/Ofa5znauWREUsxi3sKunu4kKx7pnHbwpXqwaBeht7TxQJXcSXkn5rC58OHMN33KgcKUkVWZfkS5K7FffPSC3JzSRjSbqq+knSO48MJfmU5F2S6TSwO8m+JH3/IN6Q5GeSb5nFqapJ1ZKM4F5xlCvxGTUcwJpyUTGGFZjEdIsD6G7yVRzhUAufTnThbB1XMDLHpk1NxDWsbUHajGm8xCq8wmocLtaLMYp+vC14r2Mp3tSSDOLOHKR92IY92I9zhb4Hp7G8jQRnMIEf89g+YhyvJRn8xxl3Jxlo0j0u+uRnkvNJtiR5noXjc5LRKiNhEs9K3xuxuVi/xzV80Cj9QtGLo3WtG3YunNW4FF+xXaPk8NRsD04U9vcF/wuzPboEy+bg/Y0zeFDH/TYSWq/RXzSm9HjJViutT+AyTmIAx0u2HUWCM9VfVCQ0gYeoPDxnpDPJoyRTacyysu12qTe6kvQnmUyyt80YbT0zNG7OThzy91PTjIM4gtsYbjNG25VqJcNNN+lXko3/w9XR9l/Mj+b5cwlP/ofoD7wmpH/PtLzMAAAAAElFTkSuQmCC", 37, 15},
                ["M45A1"] = {"iVBORw0KGgoAAAANSUhEUgAAABMAAAAPCAYAAAAGRPQsAAABAklEQVR4nKXTvUpDQRCG4Sfx+APaWQg2opJGsBOxslWwsBPsvAQrL8EL8CZsBUkpFhZWNilEEQQLwR8QRDBKwLFIAsf1hJjjB1Ps7My73wxsJSJ0tI9tXOIcLXzivXM/gnHFWsBUJQdrYLFH8Z+UYQ0vqP0HhOcME9jF2IDNLRzlzo8ZTrCM9R5Nq3jAFg61d9jEKJ5+VEZEN67it74iYjIiKhGxkqstjKzDnMZc4ugMdSzhFRf95u7CdjCcyzexgbd+gHTMoYi4TcY77jdSUVSxidnkjfpAjnLOTgsWP1PWWTXhN3BXxlgVe0nuowyoC5tPcvdlYRlucKD9N2u4Lgv7Bshx4GsGwxQKAAAAAElFTkSuQmCC", 19, 15},
                ["M4A1"] = {"iVBORw0KGgoAAAANSUhEUgAAADAAAAAPCAYAAACiLkz/AAACCklEQVR4nLXWS0vUURgG8J8XwiyLgkJbBEUEUYsoaFO71mVkmwpsF/QB+gbRjWgZRLXpA3RZ1MIwEoqgVhFZEAoRxVRmYhdHcHxbnCOMgzp/HeaBw7m9572c9zmXlojQAK7iLEr4kUsJ33P7Wy4vMbMMvb3oR189wfbl+TsPnTiN9RjFMcwuINePLjwuqHcnxrCxiHA7tuf2V5QLGoGjWI1pbMPFReR24xGOYEcdnXcxhUG8LuJES0SM4Rcq+LOAzBgma8Z6sBdrixiR6FPGJ3RgHf5le51Shn6jO9sqYQNu5HYrNmddZSnTXai0RPFDEHgjBdqDLQXXza0tS7vbmp0u58DapExO5foV3uOUlImPec2amgACP9txC+M4ia1VRidwEy8kek1gpGr+OQ4WcL6CKziEXbk/jpbs2IyUjTZcwz0MSxS6LzFgcUTEZESMR8RMzMdIRFii9EbE26iPB3X0NFRaJS4N5+g/YA+OY1+dnX2IJ1X9M3lXL9XI/a2jpyG04zCeSvS5LFHlXcH1+3Ndwarc76iRaeihqYsG0tdXRZPrVeObaih0u5kUWunCjogYzQ6WIqK7aq41IqarAhho9hlYCc5JjxdckO7qOcxKV98cDkg3TFOw0q/EHXyRrsbBBeafSS8w6auxT8GXddloUmpP1JyD882iUCOfuaUwhM+5HsJAk+z4D05vz1lTmv18AAAAAElFTkSuQmCC", 48, 15},
                ["M60"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAAByklEQVR4nMXWTYhOURgH8N8118fwlo8lJRIyNshOsRY2SFaUrZWSpWJhoazs5WNhIWJKYmFhZWMkinxMKWOGLGimGDOvY3HOW9f13jvvvOPNv07d5znn/M/zP8/znG4WQtADHMDNXhBjATbiedE5r0eHTfWIF3bhbNmZd7h5OU5gK7YhiJeQ4VfBnsIQnuAx7mASo7iPy3MQ0MIWPCg7sxDCBywu+eejMYfD3mNYFLoeq0SRE23WXsDrCp5G2pOnsQw7xIu7hWaKtS8LIQxjbU1QE6pLpZGIukHAD0ynUcVfFNJMvmmMJ3sMC3N8Vi+km8y8xScMYInYoGVk6Pd3RvqxKH0fw6UU3xq8FLM7iVNiyUayEMIg9lUE9EJUXMamRPg/cRRXW0Yu3lwRH3Ed1/CsguQKjojZfIjDhbkhnBHreQB7sTnNfRVLql2WxrEfK9LedmhgA37ibnGiLOQcTou1V4XVOJi+H+F2ScgoBgv2RaxMAp4m7nVYir7kb+I7XtWcW4tWj7RwT70IOC++cm9wEttnWD+SRhHvZhFjR8jFW7oh9sKXGdbvxCGx2XaLz+yIP8V8+9dBdoJslr8ox8WXZAx7ehJRl/gNvhRxDqBRSKMAAAAASUVORK5CYII=", 50, 12},
                ["M79 THUMPER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABcUlEQVR4nM3VO2sVURTF8d+Ya5r4AEFNsBKttBHRTsVCSBEs8gEEGwv9AlZaCoIWgp2VjZ2NgvgoDIqgqKTwhY2CiqA2JsQHid5lcQYyDEFuEm7IvznMXofF7D3nrKmSTGInfuIJzuOR1cEadHvZWCV5in2N2l+cxsU+vNhiGMFDnMVhvMXnWutiBnN4g3MdzLYMBnABJ/EcL/CyXt/rbULHMIgxbFMmWzX0O7iKP//x2FGvj/Ea0y19vdLsXhypktxXOu6FH3iFSVxWGmxzHOPYpRzZlSHJ7SyN30nOJNmcZDDJaJIHS/RaNlWSGzi6YpPrEwvdkdXMdZxo1TpY18H2RZp1MYXv2ISNDW0OE8rdGcZW3MUefDWfOm0GsKHxPFvXDuGaEhSfcMvCAfGtoyTIM+U/Mo0PSuIM1yapTadqfaZhsBY3MVr7nMI7HMR+XFLi/Ao+KmnYF6oky/UYwgHcMx/NW7AbX5Sv9EuZaN/4Bx/WHO3vIhLtAAAAAElFTkSuQmCC", 50, 10},
                ["M9"] = {"iVBORw0KGgoAAAANSUhEUgAAABcAAAAPCAYAAAAPr1RWAAABHUlEQVR4nK3SsSuFYRTH8c+9bopiQIqUMlAWZTAQZTGwMfgXJKt/wW4yGAzKn2DBpkhKzKJIKcUiETqG+17drvflzb2/OvV0fs/zPc9zzlOICFVaxDKO/NQt3lPytWrFCjYLEdGDZ8xiB8UcgFwqYQ2j6GokGKtFbCDQ20AwXJcwgc5/HL7DLh5r8pc4w1UhGWgz9jFZs/FTecADuMAxZrCEcbz8Wj4iKrEeP3WeeEMRsVC1d7FqnRmlpEYR8ym1BzGGE+WBdyu38e2vnuEbPo2+FH8bH4nfhGEc4iEPvPKErZSWREQM5nl+VhQiogX3aK+pe4P+XDfMUBFzKWA4qAdcgU9leKeNgL9meJ/1wkvYU/5aI+hIog1P9cK/AGgLxyuYNzzEAAAAAElFTkSuQmCC", 23, 15},
                ["M93R"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAABKklEQVR4nKWUu0pDQRRF171GIYL4iFhYpJOIlY0ECztBxMJS/8DaTjvBUuwEK8HeH/AbgmhlL4IYCwUfKIbgsshE481NiLkbppkzs84+Zx6RStAGsA3c8qsP4J7OGgLWgFPgCZiM1C2gCpwBg102d9M58AbkUXfVT7NpVEUlF8i1YL9XXQCXwCNwBbz/RAJ5KZHxS11XD9Rxtajuh1il6SZtdALW1GF1Xi2FNSX1Qa2rh+pAGjAORjcTJVWBVSAGxoAFoAAUgTIwBRwBUVsz1FzI3KqdbmWFsRxa0lbySsqplXsAoi6qs0ngcQL2Elz3AkztYSHRhWeg/o8r9EcxcALctMzt9QsDiGy85TtgmoazCeC1X2AMzAUYQCULrAmcAa5p/Cp5YCQL8Bvg6bq9FCiAqQAAAABJRU5ErkJggg==", 20, 15},
                ["MAC10"] = {"iVBORw0KGgoAAAANSUhEUgAAAA4AAAAPCAYAAADUFP50AAAAxUlEQVR4nOXQzyqEARQF8N+MqcmGKAtbJAsZr2Cn7OQZPIEXsbL0CtZewl6xQf4MhYUUOTY3ps/m+9ZOnbp17/nT7SXZxQhTeMU9HrCJU7+YwzYOQJKtJCdph5sk60mWBrphEft46yU5wgyWMY2NOvqo2s+1P8cXdvApyTjJShJJZpM8Va1xkr0k/SRrtf/hAAsTVV5wgfl61DVWcfendMNpmOS9Es+aKZPsN3xGGLb5UlP4iOOab7sIL3FY81UXYWv8B+E3bBmtOuCg9UQAAAAASUVORK5CYII=", 14, 15},
                ["MACHETE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABaklEQVR4nM3WvWpVQRTF8d+9udFYiB9ISOMTCFaKVVCEoJVYSBBLW0srwUdI5TtYxBewEGLjBwYRohK7kEbEGBHBD2JyWRZnRBHheu4Zon8YBjazFjOzz559eklUYh53apm1pV/J5xxeVPIaiwGO4koHj73Yg1dYxAEEW9iHIbYxVeZhiW/9ov+KieLzpcwTJT71m98OFvAAs1jF816SBVzvcJCPZfO7zY4mEfCsl4pF8g/5NBi9Zld5hJc4jEstdOuSXE7yJOOzkWQpyXIHjx/MJpGkn+Rbid1IcnWE7vYAj3ETa5rieoj7mmL6/Be3cbqsvYCTLW7xT1zDG1zEZIm9x+sRupVeupfIHJ7iIE600E3jTBlHOu7hvJLKLmMuyaEO+n6SU0nuJhmO+UnO1MjIpOYprPH6ncUtHGuheYuZGp19W51DwJKmyS230Kzws6H8T3zQ/PIs4rim8+/XZH0TG5osbOId7sF3oU6xy/7UmiwAAAAASUVORK5CYII=", 50, 13},
                ["MAGLITE CLUB"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAAdUlEQVR4nO3UMQ6CQBCF4W8NpR0mgrUeQ3vCtTwD8XK21JZ2ayF0qzQG3IS/nb94L5OZEGOUATWuaLFPCQU67GYMlaLHAyc8cccR22F+8aHASIiZrGSKzdIBfsVa5N8ocEO5dJAJzqi+CSGTW6+832+DQ0p4ARGeEgUAyWGcAAAAAElFTkSuQmCC", 50, 8},
                ["MATEBA 6"] = {"iVBORw0KGgoAAAANSUhEUgAAABoAAAAPCAYAAAD6Ud/mAAABO0lEQVR4nLXUMWtUQRiF4Wd1A4kWFhLFQAq1sLUMJFbptJOgEEhIZWXrD0lhLaSw0jJtinRWQZAUKQKiEAsLQY2CMSfFzsJlvDery3rgMsz5hu89c5mZXhKV1rBUm0Vb2O+o1bqDh3iGhV4L6AU2RjR5g7eN+SPs4lOZT2O9UX9Sg+ZwgMstzT9gHkf4Ubyp4o3SZh99XMMlvOqAwPcy3viLxrXuSbKR5GuSn/mPGv66+9geI+lQ3/DrnPpHSSSZ6QhynOQwyWqSx0n2W9a8TjJf+nR+/UJcbEkR3MRTvCze+5bkezgdteUhaLWltoOrBkd5uUCOyvjP6iWZNjj/Vxr+O9zF7ZL2M76MAxiqjwcVBJ7jt8GdmoguYKXF35kUoAm6VXknJriTJuh65f3x+E0KNFt5F3U/Q2PrDBP/+u9+r6RCAAAAAElFTkSuQmCC", 26, 15},
                ["MC51SD"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABiUlEQVR4nM3VP2sVQRQF8N9uFtQuCgkRG0FB/AMBSzuLpLGwMYWF30Bs7C20ljTxC1gpQiAgCCJYpAoShWARiGAEwWdERFGCmpexmAlM1rc8eL59eGCZe++ZuXv27p2ZIoSghgM4ik/4USdHhFsIuFMnqsw+jhJXcRtLeI5VdBoSnxU/7tmQhG7jQ7LP9ZpQpAofw/shvfRf0cWOWLxTeJuTFZ7iyOh1NWIsPfAEkxnXLUIIuyhGLmtAVNjEG8wMKecjse8v4GIWL7Gb+XtFCrXYnv8bL2u5uxW+YxY3MZGIGzg0oOAHWBxwbV9UYpMXuJvF57GAK8kPYvMfxpcUO4jPOG3/adPqfiixgfFa/COWM/8VTuB6Gs/gMi75+8ib1CJK3G/gTmb2Sho74t+Yxpp4Zm7V1rUquMLjhvhc5m+Jm+grzuMnfmVcjtYF98IMppK9jXviVd0LdcETPWcNCWVD/Fpmv9MslhFXuEnwC6wn+2GfHP9FS8ynZwrf+uToiBfPGl6nsTX8AR7pUnTliEKNAAAAAElFTkSuQmCC", 44, 15},
                ["MEKLETH"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABxklEQVR4nL2UP0hWURiHn2uiWVFWFhE1aEm05dQqEm4hTQnRkkThIk0tjVGLNNRQQUt/aGsSoyFoKoUPGgJDCqF0MCiiGlLLvqfhOx8ervdePy58/uAH93Le877PeXnPSVQydBA4CRwDOoHdQALcAmajuAToBvqBAaAH2AccAFqBr8AiMAe8DJ7PKgiAWnevelddsFjv1Al1Rl3aIDZLr9UzaktUG5VEHQSuhtO15FLn6x8wA3wEtgFdwNHQzSK9B84Db+POPMmgX1XfqOPqPfWBWlGXU3HP1O70CYMPq+fUp+qvnC4tq1fURAX1c7S4oF5Q9+QUOKT+CLFz6tacuLR3qmPqhxyo5+p+1LPqF/Wmun2DpG3q95Cg0iBI7C3qZfVbBtB8PaijgUSt6uNo888G92W5S51MwSw1urlXnc44zcPQrTJAifooyvW7NjjFukjtfdkBVIFXQAX4BLQDU+G/jNrCrToC/CkiP66+CNSr6h21p2QXijymrqjDWYt71dvq3wAyrfY1AaLuIfW6SnphxLWrW1VvWBvcZoHUZ6czDXN6bZasqpeaDLHO8fN/IvoeBe6XHMrSim/TLuAU0Adc22wQgP8p+KVO5YBdrAAAAABJRU5ErkJggg==", 35, 15},
                ["MG36"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABvElEQVR4nMXUv2/NURjH8dfVplqlpCREVCJ+RcSfYDKIFKPNZOjAYmDpPyAd7CY6iY3E77EJAyFiEZF0EA2DoH5cpE0/hnOa3EjruqW8k5PvOec5zznP5znP+TaSWAL9GMEkrnboO1a/Z5dy8GJ0L9HvHE5hGk+xAo3av44uBHMtfXXNVxzA4br2r9CpkK04huE6Xov9LfY+Rdw839HEN0VsD67gFu7jIqbQW317MIu3iuB+vMIzTPwqsEaS2/iIJ/XQZrVNKxk9hO3Yhi1KVpebaXxQhEzhPcaVm52PbxDrauwzjSQvMKRkZSFOKhls4gKOLk/sbRlTbnZeyCqsVITMduONku2BOkmp653Yjb1YXR178Kiu2VfH7ZhRsnkXG7G+ntnuLzOAHUoF7MJlpWoWpLuq7FLqdVKpx894jpu4tojvaZzHa9yogR7B8ZY1c3XuTpug/5hu5RFSsjWiPLR29OBE7V/CQzzAHnzCmmpLy/7LS5KJJM0km5P4zTaawrska5P01fnBJPeq7UuSl0nOdLDvkpskj5OMd+A0VIWnCvrZvinJhn8RfGtrJOlV3kknDGMUB5VS+u/8ANPhlY/CBHGDAAAAAElFTkSuQmCC", 50, 11},
                ["MG3KWS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABnUlEQVR4nLXUu2pVURAG4O+cHI05Bg1iEAneUvgAgo3BR7BSsBAEtbDRzlvlA9j6BoKIaGMVJKiFhYqFgqA2WlioEUlMvCZexmJNcGeDes7x+MOw1541M2v++dfejYiQGMB3/cUY3mKhD7UO4sLvNlu4gW14iFncwxPcRlsh2Eo7iyN4hlVYjyH8UIbwOHM+4SQ24ShmMJiEzmMFPlTqfsHqzGtgTfbXxH28Sv/ejHmJ6VzPQyMirmZAFfNZZLiTUeFzHjbeYXy3+KgQHsz311irDGQKoy1FiTqRy1jEHr8mtz33FioFlzBkOYlZRZ2JWtw0ruX+oqL2gDLZNr4p6q6s+AJbsRNfcRcPsFFRcXKJSBVzOJFE3uNY+sdwPNcvcBqbcVORfjd2VepM4jCuY102NIoN2dgZ/UZEHIiIWxFxJSK2RIS/WDMinkfB/ogYj4gdsRwXK7HNSm47IhodnNG19ZK0L5t9VGlquEbk0v9o9k/W7EHEQ/k8p1wTGKnFvOvxgvSM+jfSCWYUAncqvjc4pfy55vD031vrDj8BuOiKGiBTnAEAAAAASUVORK5CYII=", 50, 9},
                ["MG42"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABU0lEQVR4nLXUT4uOURzG8c/d3CMmMU2YbCQLeQNegCI7S9PsrKwtZusNsDR5C9hSLOyU1CSFEpPMSjQaZphJw4zL4pxy9yiexz2+9ev+c851ndN1Or8myVWFW3js/3AMy1jv6TOj7PM32rrAFczhBRawiCV8wjZWMI1d2I+PmMJBHKp1uPqtYw/G8B0P8QYX6/yv1X8e49ionp+xGz+q7kD1Xa7rNziDo3iHD9jCIzRNktO43yOlQVYxuYN+f2IF3zDVKkkMsonzeFu/t3FSORG4piT0EicGtJOd93u4oZxKl7HqOQqnqu4L7ta9HMFTbElyIb/YSPI8yYMkE0n8pZoka0k2k8wk2ZvkVcfv+hAeO1ItzuIm7uC20S7kOeyrCS0o9+Y1jtfx8RFT/2dazPbQX6rPy0pzgInOeN8uNTRtT32UrvKk829eaZHv8ayn/9D8BNb65Uw6yMdEAAAAAElFTkSuQmCC", 50, 8},
                ["MICRO UZI"] = {"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAABBklEQVR4nKXTvy6EQRQF8N+ysd1qiRAV0SglVB5AoqVXeglPoPMMNLK1klLlT6IjUZIgdIKj+L7Nbta3+xEnuZnJvXPO3DkzI4kyxpLsJzlJ0urLV8VOOU4n6SRpd2uNJErM466cn+ILc6oxgwtMYhErOIdGklUcYXYI+Te4xR7Gm7jBxz/EYAob3Q63EHziBevYVRxnFJ6xXfIecNkVrFrcxho6aPXlN7GMKzzhbJDYHLL7q8Lk1kD+tKy9oVFFHCZIYUM/PrCkuP1H3FezRr+34/TwXrNWEmMjOoSFmvoP1AnW1f9MONTzsoGJWsVf+HJQenidpPlfDyluleIB1/6oP3tUh2/zbeu7PlyXMQAAAABJRU5ErkJggg==", 20, 15},
                ["MJOLNIR"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAAAoElEQVR4nMWUPQrCQBBG3w4rglfQ1sIjWNt7EO+Y2iNY2Cp4AiH481kkRZpkmnz4wbLDPtg3W8wWSZhyA9Yj7Bgm6W5CCnBwifcZd4mXGXeJ3wlfBeCQLxK+rcAd+AAtUPs6gELXeZ3Yv/1FMTgLYJN1VmScp6lU4MEfXoykkMTM66QkMeh6zrwSfnWNU0340yVuM+4SnzPuEl/o/oexND/i84psRuKqjAAAAABJRU5ErkJggg==", 30, 15},
                ["MK11"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABkElEQVR4nL3VO2uUURAG4Cd7ySpeIAREUbC2EGz8ERZBKy3SWomFjYU/QLSztLXVQtA/kYiCYuEFYyGKhaKRhYR42W8s5ixslmzcb7PuC8M3MPOe751z5swRESa0axHR3gO/rt3YLd4wOU7i8h74U0ULCzU5l3Adi9iHK2hgDj00EajQxhr240iJ9Upuo/j9zaxKvCr85sB6K/iym6i5iIiahfwvBLaKNWWBv3EA83iLl0OcbziE7iwK+VFEHd4htomfxW9iXZ5CDx38kkU8wy18H+L31223agjq4ik2sCTb41+4i6s4Ktv4T/lGscH2CnyqoWcbRhUS8ihXZX+u4FX5KdzHxeK/xmOcwPLQOu9lz3+eVOC46BfSxRMpeLXY+gjOPE4VP3BHFraF8zg4kNuZst6RaOG03O1qTM7twoGb+CpbpyMn1JmB3HdTUTkOaj5K5yKiisTziFgYij+I7Via1YNZ50E8hnvykm/igtHtR06jjUk3uC7qTK3jeISz+IgPO+Q8lBf/Bd7IKTUT/AXKuom/Yr6sdwAAAABJRU5ErkJggg==", 50, 12},
                ["MORNING STAR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAA0UlEQVR4nNXVoUqEQRQF4G90gyDYNv2CweITCIsYzQaLUew+iC/hoxhkMfsARoNBw7KCsIjHMuLwWzQtc+DCPfcMhzMMlylJdIhL3LSDjTUF+S8KhtrPcIFp5QP9XCS4whz3OMZj5QNMcI4ltrFV+wk+qskmPquZkTY+d4KXOn/FO94afdGEW+FpFHjZ+H1jD7s4wFEz38E+HqCk0yVpcIubkqSXFznD6Uh7rvpKkl7qOsk8P1hUfpjEusP9tUqSofazJHdJppUPSZROV+TXP/IFsqFsUJMYmAoAAAAASUVORK5CYII=", 50, 9},
                ["MOSIN NAGANT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAHCAYAAABKiB6vAAAA/0lEQVR4nNXSTSuEYRTG8d+TYVZsSYqlwdJiyoLvIB/IR1B2ylpJWVCWFkrJTjKL2XgLeRdCdCyeezGMxcyzEP86m+t0zt117iuLCAUoYxyjOMdpQ28MfXjCW9L6MYAeHOESD/ho890S3vH67c1qVsBIBbOYaXewIJuY+kE/w5zcWL2EXoxgOFUFQ+jAFWqooxMTmEy9Voi04xqHOEj7athX/EcayXCTRcQDultc9IwlnMiNLWJVHrEn7GALC7hNWqHstksWEduoftMv5BkexAvWsIINuZmuNPMoz/4x9jRf6/eIiPlo5i4iliNiOiLKEeGvVwm7ydM91n29/L/hE8EM4YhbYPVlAAAAAElFTkSuQmCC", 50, 7},
                ["MP10"] = {"iVBORw0KGgoAAAANSUhEUgAAACEAAAAPCAYAAABqQqYpAAABkElEQVR4nLXUz4vNURgG8M8d94pIkZqdzZRSFrJQfm9MVv4ByUJhISuhSLKwsLCymVKSf2BqNiILI4vZWbixG42NhSipIYzX4ryX63bvnXtuPPV2vue8z3nf9zzf9xwRodImI+JIRLTG2NuxOxGxoTNvqsM2nMcFXMUWNLr8gQk8x9sBMdZiBw7hITQi4vIIyTflpv09SWvwGp+75g+wgMVGRPzAFD7iKfbiWxd5HR7j4JjJB+EDPlGk+46lrHIG53rIXzvkCtzFNM4O4VxSDj/VzEJaWcx9vMA7RYGfivz3cFFR6AZOrFLEKzzJ2DexdRi5iXlcwyJWcBptf/+/biznOIs5PMN25Z9fwZlck4c4gI194iz9/qq8Wq2IeB8FtyLicERsjojd6T+VvpM1cWuv6FF/pJ1RmmsNXuZaO8edNUFrizie45u0XrSVvtlXE3SisoiFTDQ/wL+cnD3690F/jPnsrh/iu559cWzUeLVKdPBliG9Web5735t/rsRq9ijV2PU/bseouK3028oo5F9aKtp9IuT0cQAAAABJRU5ErkJggg==", 33, 15},
                ["MP1911"] = {"iVBORw0KGgoAAAANSUhEUgAAAA0AAAAPCAYAAAA/I0V3AAAA9klEQVR4nI2RPUpDQRRGT54xYGknRCwtkhAsxE4sLCVY6wbcgavIDrKFVCmsFLEQSy3cgIUipjGVEH+OzR2dvLzifXCZmW/mcL+ZaagATaAN3AOPwCvL2gKmwLQZRg84BdaB/QpgQQlaA45Ke0OgA2zGegTcAaCmOvFfM/VAPVYn4Q3S2RwaZ1A/87fDOy9DbXUem29qkUEt9Uu9Tl4Rec+A1ZhfAD/Z3ebAE/D55wS9G10+1J2sS6oNtZHW6fX6Md4CDxWvvPBvKd5hjFeVH1NWtH2JeHsV0ZYKtRvAu7pSByqyaDfAd510OXRZ6z4BCTxHp1r6BZSjGC4UypD2AAAAAElFTkSuQmCC", 13, 15},
                ["MP40"] = {"iVBORw0KGgoAAAANSUhEUgAAACQAAAAPCAYAAACMa21tAAABWUlEQVR4nO3TPWtUURDG8d+udxVjAgFRREEsrCy0CUJSaSHYJq0Qa7+BX8BKSGdtYWGlNhYiFlkwXyDVClokIIJCwCKurzwW9wiLYO6JsmLhH4Yz5zAz95m55/SSHMdb3ZzEObzGp4nzBWzi88TZAF8m9gcxjzfY+kX9ZZxucB23O8ScwjrOVgjfi294gTE+aBvbxYy22a8NznQUmcO1fYoZ4/DE/j7e4yVG6JeYMT6W+jew20vyFEM02rEfKoEzpQsl6SZOVAq6i1lcwjFc0P7WbpLcSaLCHqVlJ8likotJVpMMkqwkuZVkI8koyVLJWSs55yu/ocF2he5ZXCn+UPsIeniivbwPi/3MgbI2VdMpgQ8q4pZxpPhreFVZ/8frfVcrqK+9aF2slnULz2uL/w79ipijuFz8x8j05NQJ2sFV3FM3zT+i5rIFz4pNnZoJ/VX+C+rinxP0HXZCsUHF4lUZAAAAAElFTkSuQmCC", 36, 15},
                ["MP412 REX"] = {"iVBORw0KGgoAAAANSUhEUgAAABwAAAAPCAYAAAD3T6+hAAABJklEQVR4nLWUoU4DQRRFzzataSAYBLJBIEDiqgGFAcEf8AEEAwnB8BVgSfAoBH9AEKiGYBpMHSEIaEJJDmJ3YTtst+xme5IR+2Y2d+59MxOp5NAAOsA2sAYIRJn58Hsac8AGcIM6aRypH8Z8Os6rFWnm7OYY6CbuUlol3BSSJ7gUiE3iHXgsqTfKE+z/48cWcAiclxQk7FtTvctEPlTv1YG6oy4n46Cg94UjLJwGPb5M6mfBus2qgo2M2RXgJAigQ3z8n+Fn7QLwVTrKhMjfe3gB7Afze8AQGAHzwFtSv60qmFrtJn3K0lejqtFNi3QdxuIFuCJ+UepFbau9v2+Cq3W7Sx1uAYvBPh6AXu3uiGPcBdpB/XoWYqngC/AEDIhPI8QncyZ8A6Aa7h5KlouLAAAAAElFTkSuQmCC", 28, 15},
                ["MP5-10"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAABXElEQVR4nK3Uu0odURQG4O/oYMSIhYogwdhFooKNTSpJ6wNYWvkAnvo0FiGkT5VnSBmJjdqInZWK2EkM4iUqFl5CRLfF3sIpjmf2QH74WcOstf912bNGCEEFTocQZiqeaeby83MhD7OoYxw92ErvB3Gb2IFXuMM17pvOPyT7Ab24roUQvuAbrl5I2o0VTGUW2Q7/0MCvAvP4mypthS68yxS+wes2/p94i8EC37FUIriOBXHkQ23ifuBP4jHOEk9wqqm5Ao8lSWEzsYFPOMI+LtEnTuVjEl/M0FPgd05gwkyyX8V738Z7sZMDjOUK1UIIubHDYpGdmEuJHnGIc3Gk93iTpVZhB+sh4iSEUGvhX03+/hy9jtx2MSru4xpajWk32YkcsSqJFzGCzy/495KdzBHL/XM94zixFXaS/e8dl2FXvIKsjqt81Tk4EPd6oCyw6qjLsCGu0wAu2gU+Ae6NAO3PKv5YAAAAAElFTkSuQmCC", 30, 15},
                ["MP5"] = {"iVBORw0KGgoAAAANSUhEUgAAACMAAAAPCAYAAABut3YUAAABk0lEQVR4nLXVvWtUQRQF8N/KovELK4X4UViISNSoCIKFihY2WqTxfwhWFmJhZf4ES1v7lKKoEMRGEAxLKhXBQolZwUKj+IHH4s2GRdbd9xZz4PLu3Llz5sy7l5lWEmNgBw6jg8/jEBRcxBnchHaDhSdxofj7MIs7eFFik/jSJ25bGcOnAXw/cQzTvUAryXVsGCKiVYTMjMgbB7/xHJfQbSVZwc7/vEldBN/wCx/bWC8xK/iBvWX8FR+wjG7xO3iilLMnZmoIabCI132xCVweIWY7Tqt6aBmro9T3xPyNd3hY7NGAnIN9YhZwv/iTqlPPYk/h6Y4SsYYkt5OsJrmX5FqSqSRG2I1U+J7kXJLNJT6dZGuS+TJ/tgbXmkmyO8mmJouSdMpmi0lOFTuRZFeZv1XmrzbhbeN97d9Y4SiOFH8ezwbkLJXv8SbE49wbV/r8x//Ieapq/PONmBuWR5KNSWaS3E0yMSRvqZTqUJOeWS+bK2Lm6q5pZbyHsg4O4CXeYr+qbEPR5KFsild4gDfYosal9wdOMvzoLZjPiQAAAABJRU5ErkJggg==", 35, 15},
                ["MP5K"] = {"iVBORw0KGgoAAAANSUhEUgAAABEAAAAPCAYAAAACsSQRAAABTUlEQVR4nI3TsWoVYRAF4O9eV0ijBuIFwUrRIigWKlgYJMTKJvgc1mLpG/gAikUE8waCCCoIFoKogRRBEBFJYadRlCSQHIudq5fFmD2w7M6ZYf5zZvYfJFE4hcN4qz+m8KSpYA53MYPbxR3EcXyquCnuJzYQ/MIZSS4nuZdkN/2wM1G7mWS7wQhXMehpYTjx3WDQYAsvcKJHo2Ws4iIWsYSRJJJcSPKqh5VbVT9XlkZJFsaDfYMVXMIHPMU7HNBubQo3cHTSBmbxfKxkmGS9TruT5Erxs0mmk5yv3KPiT1e8mMRYybx2nfAZX3FSu8ZvWMMOzlbNx8qvw1jJ/eq8neRQcd3nfc1hppsblu/rdcJr/NhjMy9rDvPdxLBknsNNPNijATyr97VuYpC/d2c/HMEXbOKY9v/6o6QvNvAY0101zb+q/4OH2kv6fZL8DULeHvZfhuAuAAAAAElFTkSuQmCC", 17, 15},
                ["MP5SD"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAABlElEQVR4nLXWPWsUURTG8d/EBCQaBDVELIKkDCkExVIUA4pfwE6wsPQTWFj5EawsRLC2UgxuFFEbbW0SLISoGNOIL+RFF4/FvcJs2Mnu3k3+cJm5c84855mZew9TRYQC9uEMPuFjiUCNBVzFWlPC6ABiJ3EFFdq4idd4lOMTOIDVPB/DCLawgc1tem3pYY/hFJ40Fa4i4nZO3ok5XOojr5QHeNUQiyoiVjG1R8V3hVF8tXcmH0qf/D9/G+YbWKld38J63WTjgs208SaPPzXxGzjY494F3O2R05Mmk0tYRAsv8GNbfATXJZMtvMQyjksPchrXMDmswbrJNTzLBRf1bivncDSf38EXvJU6wHt8zibndsOkiDgUEVVEGGDci8RmRMxHxGxEzETEiRyfyfF3A+p2HVVBMx+XeuEEnuNCl5wK37Efh/FriPfYsdP65bxkkLQ0uhFS3xvD2YIaHZSYfIxZ3MLTHfJa+Xi5oEYHJZ+7X6bxAd+kXf+7VKjkTfbLitSajuDiMEKD/GCUcF9anz+HEfkHQgfUlgZnscIAAAAASUVORK5CYII=", 41, 15},
                ["MP7"] = {"iVBORw0KGgoAAAANSUhEUgAAABwAAAAPCAYAAAD3T6+hAAABNElEQVR4nL3UT0uUURgF8J/jtAoiFKx14sJFgrgewm8QuIr2QR9AoX1LdwotRfDrOAtRDCpoEyiCRJRQM3pavHdkGKZ3/gRz4OFw33Of53DPe7lzSYyBh3iBBezgHTq4RQN3Q7iFU5zj7H5SkmdJ5pOoqVf5P2z2ZjXxBfv4VXPClXFiqEEL12jOpcr0KS5rGl7jaMj3LoKfeKCKGebxCL9xgzb20FWOvDgi0qUkb0q9T3LXF9dh2bPWt3+laFtl3WOSdJI0RhgOVrsM/J7kbZKNJMt9+vOivxzsbeJKdasmwUesq27gh0kaG7iY0Izqv9Xhqs5wbwrDUbjGLr4NCk0cTDHwc+GTf+h/sD1MaExhBl8LH0/aOK3hj8KPZ2XYeySezMrwU+HVWRleFtMb1ZM2Nv4CumVMM5mtS2kAAAAASUVORK5CYII=", 28, 15},
                ["MSG90"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABNElEQVR4nL3UzSpFURQH8N/RIeVSRDEzMFEGxooHYGbmBUw9gJkpA0/gNXwUSgzExMxEknwNhOujENtgb8WV2z23y79W+5y11n/1X2vtdhZCUADtGMcyykWIBTGESczVSshqaKQN8xhDEwZxjXO8fMlrRheuatcLAm4rfCUMYBSHtRTJQgiLiTTxS04ZHQXFNQqrOKnwtYgD7Ejf1wi5OMGZKsXqaeIm2See8YR3casveEyxd7ym+Nf8B6zh4JdG2tP/PeS4qyJoHbM4wlvyNWEf/ThDlmLP4maJ12GkSt2GI0cfLtIpCdrFBpZwWsHpRK84gGF0i1O9xAqOsf3Hun8gF9e0gB5R/I7va67EFFqxJTaVpfyyf97CN4QQitpeiJiug/tnlhfsOxdfkhI2Gz/W+vEBSIjfes9qxc0AAAAASUVORK5CYII=", 50, 9},
                ["NIGHTSTICK"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAAAxUlEQVR4nM2WMQoCMRBFX9a1Uqy00gt4EhuvaW+hF7GwtBREm0UUkbhjkYBBWHQnu8YHgT8hE/6HhMSICDWZAwvgCsyATd0N2iBX9ByAgR+7Zu3oyRQ9w0CPmjISiybIuEInRROkH+heU0Zi0QQxkf2toDFyqdBJ0QTZV+ik5MAEKHwtQOnnLe4YZcDD13fgFPQff+b0A0ZEtsD0i7UWOANdXhe+wAVPzcqIiAU6qZ1EcsuBJe6VFj/AHal3bXHfkn+jBNZPkrIq9nsKo+oAAAAASUVORK5CYII=", 50, 12},
                ["NOOBSLAYER"] = {"iVBORw0KGgoAAAANSUhEUgAAACoAAAAPCAYAAACSol3eAAABwUlEQVR4nM3VTYiOYRQG4OvDYDZCjNIwM0nK/2YWtiNZSTaUtVgo2bCgJAtbViwRs0HZizJslJ9SjI3IX/ktKYqY2+J5/STfV+/rS+469XQ65zx393vu520l8R+jH8O4MKlB8wLM6C6fttiM9dCE6A68xknM7x6nP2IrRmBKg+ZxBLvxvsrNrM4Tf8/tB5ZitSLmQF1FV+MBpuFAdb6FmziFtZiL7VXNd8yqeU8/RjEZLYy0aprpOK5iHz5iHgba1N7GJTzFIRzG4za1LQxhZRVL0KMIMR1jrSS7sA578aIDyVU4XxF8h2X4hF580WyN2uGV4oEj1ewFrXTnfdqCt5jdhVnjuKeofE0RaGcryQnlCdiDlx0GrFQ+3yR8UAz0HZ8xtQskKUZ9rih6TDHo3Lo7ehpXsEnZoykYbFN7F2PKju7HUTzrMLsfKxRBhhRF7ys7el2SOrE2yXAKziR5luR+kidJzibZkGQwye4kvb/09dW8Z1GS8fzEtrpEJdmYZCLJwiQ9VW5OkskNZnWK5b8QHWryZ1quOPEg+qrcG3xtMKsT7uIOHuJRkyflIi7jhu6T+x2jWAx1zfSv0Y81OPcNyo9lXlsJCwsAAAAASUVORK5CYII=", 42, 15},
                ["NORDIC WAR AXE"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAABDUlEQVR4nMXUvUoDURCG4ScSQcWfKoK1io0WImgpeBEWegneg4XXYSVaehGCYGdhWhFBbEQNRkULYSw2IUuiuxjMycDCsPN9h3fP7EwlIiSOE9xjH59FwsoQ4GAT29grEo2kYemJM4xiskg0LDhoYLpIMKy2TqGOBXz9Jqomw8mAahjHAT4UgJHB1XHTymv+v9WzrXPHut6/lRmrOMQ1JjAn+7KfotEHWDUHN4dFLLdqd6XuiEj5bEUndsr0qad1LZfPl6oT3tp6RDznbu4xIpaKPClWyZFsZWzoHbZ3nOJCNph1NNvFQcOt4vKPnlsZ5PGg/7ndPn1PeBj0En7FOVYw01Vr6rTyKpe/tAXfHswkRn5JJ08AAAAASUVORK5CYII=", 39, 15},
                ["OBREZ"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABd0lEQVR4nLXVz0tUURQH8M+LoR8LS/FHRW3btzQEcScIupPaFq2ittEf0Lply1qq5NJFbRRBq4WKhWa2iqYQbAqSSErzurh3aJKZ3mhvvnDg3XfOvd/v97zLeVkIwRHQj7M169dYz9kzhIs169/YqlO3m3J3sY0zuIT2lF/HA3SkeIdH2SGN3EEfrh54v4W9RLzdYO8FnDgMWQ4CMuxgo1kj53EbN3CuQDFFYBX3SzlFXbiHWzhVIPkejhV0Vhnj9YycxjBGMYiTBRHW4n9MlPEWaykWoGqkDSNaK75Z/EIlxXt/BK+JBuoNCCVxmjxGTw5B9Tp8xTcsid0ZwOUmRQaMYSIJbhOHQ1X4ZiOhechCCBV0NshXEumT9DyLa2IDnqaaAcz8g+M7XmIOU1g8itA8lPDB30Z2MC2KnxS7X8VDvMJNUfxP/DhwZhnP8QLzWBb/DS1FFkLowXXxs3/EM3xpUN+LK/gsXrVddOM43mAFn1qsuS72AT7eZ3QJztt/AAAAAElFTkSuQmCC", 50, 10},
                ["P90"] = {"iVBORw0KGgoAAAANSUhEUgAAACYAAAAPCAYAAACInr1QAAABvElEQVR4nM3WTUtXURAG8N/fBGlRWZC9kiG9Y4sWQUH7Fq0K2kYEEbVtWW0k/AJFH6CgTUS0DKJtUIEISWBGGpHYohKyTejT4h7rclHRzGpgOOfMPDPzcO7cuVcSK6CdSY4vAT+YZG3d1m5l5BTOoQutmj1lbdo2YB+ezRpXitg33MZV7FlkzEl/gdgV9OIahrGr6O6im+aI6a0f2tHzh0mtwt6yH8QQXjQwa1RE9+MyOnGgDmgliX8rY+jGOLbOGn+H2AwmF/C3YV3Zf15Evln8Z1VfTmPof7ixpkxh5E80/3c8wgdVnxybA/MEo6o3b/08eZ6jD6sxI8uT+0m6GsPyegPzJUlH8Z1OMl3zfUoykGQmyWg9T9syb+sWPjZsY43zDLaX/T1cqPn6cQgDfg1fVI03hcdFF9OsdTmrGg/Keh43a/7hUnAEO4vtVc3/tqzTzcStJH14X85bVM+4KW/wDpdwokYGPpUC27C5Zp/AUdzFETzFHVzEQdVNbizx+1Qz9eXP6CV8aGe1O0l/kokFeu9rksNJWkkm58E8XKjOcv4gOpI8aBR7neRGkp6C2TEHofEkZwrpefP/AOBlSTxrU6/FAAAAAElFTkSuQmCC", 38, 15},
                ["PP-19 BIZON"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAAB7klEQVR4nL3VvWuUQRAG8N9dLipR9DQWgjGSWkUkECWIIGiRRktBxNJWsfYPsPJPsAj2BkSxUAs/UdFEECMookGFiBiMwc/kxmL3zCV4l+Ry+sCw+87uzszzzsxuISK0CGvxHe2YRhsqea2YddW1IgIl9OAQXmIfTuPHAr62YBgbq4pSCwgUcA4n83y5GJBIzkcHypjEBK7ULhZb4PgqTmkNCVKGOnENL/Auz39iEG+xwVyy5UJEDGG8CYclKcUHm4+5LioYkUqnHe+xHaNZ14UZPMEKRCEinmNoCU7K2Ik9LQq6iik8wq8Gey5hBz7hjdRvHVhXiIhbUpMtpus34wh6cbTOnml8kUphHN3SRfBZ+tOddc6N5bMLoTPb65UaHqk8VmE/bsw70IZt2Iv+PHbhKe7jDC5jDW6a7ZG7OC7V8TAuZvsT2NogwO5FkKhFaf7Ht0xiNfpqAu/PZB7gNi7kICf/YvQ6DuT5lJT2aoafZTKDeIxdSwy4HuZcLoWIeIWP2cEH3KmREYtL9z2pZ8akLK40+4ZU8FWq/WGNs7KY4Mt53oeHf1Yi4nxEHIuInojQhGyKiJlIOLvA3oEmfdRKOSLWR0SxVr9coyLiRMxidwvsNSWteBAP53F8Tqr/M1pBZBSvpT6oNN767/AbCJKhK/ppxRkAAAAASUVORK5CYII=", 50, 13},
                ["PPK12"] = {"iVBORw0KGgoAAAANSUhEUgAAACkAAAAPCAYAAAB5lebdAAAB6UlEQVR4nL3WTYhOURgH8N87mBkkyqTUmKKUyMeeElmxwUaxUBZkpWZnoVgoH2VlyYYoGytZisWsLEQ+8lVSzKRZIFNGM/O3uGeaG6+Zeedt/Ot0zzn3ec75n//znOfeRhItohsX8AOf8A4NBBM1u47ybJT5idJvYAl68B5jxe4JXmMfntU3XNiExCJcrY0/4nxtvBmnWjrW7PAWvc1eLFSd5ptKkQmM4FjNZhh9pb8cG+aBIHzAepxRRWgUP/GykWQM1/C1kPyOtTXn0eIE/Vg1TyQHVKm0EYvL3DCGGklGsHQa5y4cxAlsw2Psqb2/hE7cVSlxvckaz3C5EAkWmMrjyfZZJUgvxku/G4OSjCTRpK1PcjnJlyQPkhxK0plkUZKfmcLRJPuKz8ok4/kbp/+xx6zanxenE/txHFtwAzvwpmazvag7GaKHRZl1WFH8J8N2VlUFbk4TqZmR5FeSk0kuJhlK8ijJkSRd/zjZxZpCV6ZRYHXNrqcdJTtK7Peqbvpu7MStMt8Mu2r9p9Ocf1CV+LC1XSVbbQeS3Ct5uWYG2/tFyXPtKDlnxyTLZmHTX0gOtEOykdY/i61gE56r6m+fqXrbEjpmNmkLL1Q1sgOH57rIfJNkqvwcnesC/4PkbbzCHc1/aGbEbzIYXZKpnhe5AAAAAElFTkSuQmCC", 41, 15},
                ["PPSH-41"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB5ElEQVR4nL3WO2sUYRQG4GfiGoxGo0JQhAhKCoVsRETBRlQQLATBxkos7K0sLP0PIv4BRSyEgIhWYqWNl2BAUmgUQSGSRI3XmGzG4nxhQ9xdNpOJLwwDc+a833nPbSbL89wqYAdqGF8NcpzHBZzET6isgOwALoqg4TmeYgCnhZAhjLbg2IAM35d59jF0CkETmM8KViTDLZwt4twA8+jAJF5gLQ7iSbIfFkn6g314j8/oxyUcb1WRzSK7XzGy6PlOXMOpkkQQIog2GcMafErBwhSmRZUn8FuIGscgRitYh70p6AFU070vkeRJyBtsw350FQj2JfaIloBhnMGXRe/MJDHLRgU/1DPSCJlQPdjA9k4I3IRuzGEjPibOTpGIbmwXLdGffO/gbZGgG6GitYhmuIErQgQcQi/uiar1JFst2bdiFy6rCxkrFHETLBUxL/pvroXPVZxTFwHrxSztFpuoS10E0ePP0rWAo4UiboKlw14TM7OASdzGQ9EyvbjegOdRm+ctXhon2vRpC1n+7/79hbu4iQdiO5SFPjEnMCtmpxT+LM/zWbwW2bovhnC6DPImmMIWsQR68K0M0orIykwZZG1iBEfENqzicRmkHf6vCOJ7soBqWaQr+dcqimHx//UKH8oi/Qu3jXF9n30YrwAAAABJRU5ErkJggg==", 50, 14},
                ["RAILGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABuklEQVR4nM3Wv49MURQH8M+bnRlCiMJS+5EoRYhCQ2IVJCgkCqWOQiT+Aoot+A/0Go1OFAphFWQ3oRCFEIUoJDIbsmTMmqN4d7IvmzdvJm9ms77JyTv33Pu959x7T855IsIU5faU9xsl1wZ603DsxfaKefiVpI0+ZnEOr9FLa1r4m6SVbD000MRq4rYRaW4mSZGX4U+B18dpfMJSFhGPCw7KDtJOAW4ZcpifeJX0rSmAlREXAPtwoDBeQqdi/QlsS3oXL5KvU7ibRcQznBzD8f+MSw283+wopoEGvm92ENNAE4dqcpexqya3j881uWVYaeJYTfI7fF1na+GstcLQlVc1eIK3Sf+CBzX9liMiLkfEjYiYi4jlyHEzIq5ENc4Pqe3XC2uuFuxnNrKnNPBQXsaKWMRCzbspltCDOJqkqmdNjMHmvXX23fLU6RreP47jd4n9Vvrex72k7zS6uU6G9DQXI+JjRKymlHgTETMRMV+RWv0kZehExJ7C01+IiGyjUwue4w5+pPFhvJR3zWHIKubm8S3p++W/EVH7tsfAILU68nT6YO0wAzyt4Gc4ovxQc+m7A48miHEs/AM96SZT05tTrgAAAABJRU5ErkJggg==", 50, 14},
                ["REAPER"] = {"iVBORw0KGgoAAAANSUhEUgAAACAAAAAPCAYAAACFgM0XAAABFElEQVR4nMXVwSpEURzH8c+dJhFZKJ5ArJCFQrZ4CVkoD+Il7Cw8gb0FO1mwUUQNJWWaMSGhJMZiztGkE1cy91f/zu3+zv9/vud/b+dkzWbTH7WMK+zmnD+IcXSjVMYMen9IauAI7wmvgqlvALowiwXM4QH7KGGyHIyeMDnDNC5RRWzPAMZwge0Q1eAdY+XLoiOh7nzI3Qs5a3jBIpZwnSU+wSrOsZPYzXBb4SE8ox+jOMET+kJXImgtUWcjQG+WE2Y9FE+pEmK97V2m1ak45tEnVClhnuEuZyFti/7mb76JD6kOnIb4T9XD+JrqQCcUARpFATxGkKIAogoHqBUJ8IaDIgEOcV8kwBakjuJOaELrBr39ADheRQQ3V2w2AAAAAElFTkSuQmCC", 32, 15},
                ["REDHAWK 44"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABSUlEQVR4nLWTu0pDQRCGvxyDN7QIeEE7BcFCCWplpeALWKnPYGFjIYLv4ANYio1a2Vn7CCraiCBEgoUekBgv0d/i7JF1sxtMzPlh2LMzc+bbnWFzkghoCxg33+fAuxWLgZvQjwEVgR3gIOeBrgFVYBfoBHqtmIA+429ZPmgXcAWMAffAqBX7JLlxT4OasTlcWJJcK0p6VqI3/daLpJLqVZG0J2nGU6/O7M26pEdJNavYnVM8lnQh6VhSwbLuv8BSy1uXXgEKnlY/WftXk1Ny/E0pMuscsOCJDwH9QNnABkjmWW0VCPy099Azp5qkVUmbJmdD0kQzbWw00xFnjqlOTNK8pEFJS+0ASiICZoEOpwFnwDawCHwBk8D1v1pqKQ9Me/ynwGW7IK6iAPQoK2AKnXJ8HyRPIlPosON7ACpZQ5eBfQMDuM0SCPANMWCr7GWj+gYAAAAASUVORK5CYII=", 29, 15},
                ["REMINGTON 700"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABaElEQVR4nMXVO0sdYRDG8d/RLYQUIl4SG8EgCGr8BFokpAgWImIhBO3UKpBvIWJpk5DeQgSLJARioQQLSxuxEAtFQVEUjleI8Vi8Kyzrfc8x/mGKYWbefWZn3t1coVBQQlqwjC78KuXB9xFlrPuEzzjFEebxD3/j+Ad0oAz1aEVj7MMbbGV89o1kbaQOrxN+s9DIIQ7QgxfIoRLlqfoyJSaXcbVq0YBz9KFGmMYUCoLQEaGxH8LkGuPaPH7ipBjhabI2Uocv6Hb9bT8LydWqEna7JrZazGA2kdOLMTT9L4EJhvHttmCEr8K+X1mSTrSjGhPofxqND+LO+xzhJd7fEm/DJN4J6wRLGMJHTOMM43ibqh3ABjYziE5zgfW7EiKs3nNIcgqLwj/iABVCE3lhBdONlOPPI8QWRYTjB+bOCZf7KPYXErFDrKTy14qT9jgi4dOYxz5+4zv2sINdvMIgRuPcm9iO7dm4BPG6ST7TpSsKAAAAAElFTkSuQmCC", 50, 11},
                ["REMINGTON 870"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABNklEQVR4nM3SPUucURAF4GfZVzDIIolbqY2JlZYhhYVELaxsAulCynT5CalDGmv/ioWVSBoRC7Gw0JCQRfwKIQSyosmkeEdYYVk3umoODPfcmbncMx+ViHADVDGD99jDGproy/gZPmesV3iACRSo4Q3eVq5RSIE5vMQL1Hso8tooOsQGMJT8S57zWMLj2xTVBgf4mvxiIpv4k76PBZ7jYYqcUoqv5wPYwTQW8Tp951jFM2zjJyZxivUWATX8wlEbcQsY/odCNpJX88/vuFinXRFxEhFb0Rk/WngjIqYjQkTMRsTT5PMRMZa8GxvvMq8/IkavyqtExDYGMdJFZ1bwCod5f6Sc4LlyKu06fycosI8nyjFVOuR+wDv8bvF9S7t3FGgo9+0TlvM8wbGyw0eZ13S5iP8KfwHBduFeUw7c1QAAAABJRU5ErkJggg==", 50, 8},
                ["RITUAL SICKLE"] = {"iVBORw0KGgoAAAANSUhEUgAAABsAAAAPCAYAAAAVk7TYAAABT0lEQVR4nJ2UsStFYRiHn8tJhDAgg2xSShbJYpTJf2FhQcokm7/AJovZIGVCGe7AplgYDIrFVZe6pHQfw3lvJHG/+9bX13f6Pf3e7/eec1BpcBXUOXVPvTevd/VC3VQHfzKNGg2pRb+qqn7EXqs3dS2aQqWgklgjwCnQD7wAd0ARuAVagUlgDBgM/Q4wDyTfqF29/hbZgtr3i25KPVIroV1pJMaNgEvq0j/abvU0oq2o/SlGmfoYZrtqUx3MpPoUzHqK2XRAz+pMAncY3FkGTAPDQAEw9lq1AO/AJbAcz8rAVcILdQLMAqMZsA/0JMBV4DlB/xRMRwZMAEP8fbMbYDs6bAM6gUqdZr1AE1BOmdlUZP+qdiVwB8EVs4Q4zoEH8pnVG+M4+UcOcJxiViWf734CMwD0kTe3lWIGsAq8JeibY18ESo3+iOtdHep27fwJbGPXE3snskwAAAAASUVORK5CYII=", 27, 15},
                ["RPK"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABz0lEQVR4nM2Vv2sUURSFv010N4tBjFFYVDbRIiKmF7QyCiaCf4ONoNhYWgVFsNLCQjSFNtYiiHYGIiEmjYiFqSKYQrGwUFl/JGb1s5gnPofZzaxm1AOXB/fc++49c2BeSaUD1IHRnHV1oAYsAZ+ArohfBiZDHuAF8LiTRQK2AM+A2roOmurALLD9NwbOAx+BXcBTYD+wDXge+CFgHJjJ6O0GqsCHVH4jcAS4DvSVUo7UgAF+ftEBYBDYGYaVO1j+G7+6EGMJeBBOwr1VYDGjtgz0A69T+T3ACrAXmC6pt4HhsHRPm8WWw1kBJLH0FbCbROgP3AcehpqjJC4uAg2gCWwF3gOngS9t5q2GMnALuAmAOmc2Guoj9bJ6WK2o5wL3VR1Su9QJdT7qu6GySnSrG3LU5Q7UaxkiLoYl0w0nA39W7QuxWd0RxKm+UatruWReIadSIl6qvS0a7qlNtT+Dm4ruuPQvhOxT76pn1GG11KK4V/2sTrfgD0SuNNVDf1tI3qiox9UTbWquRK401NH/UUie6FFnIjEr6nl1fdFC0u/IWmATcAc4GOWeACMkv91C0OrB+hO8A8aAqyRvCcACBYoACnEkxghwATgGvC1y0Hf7SvNx2X9kUQAAAABJRU5ErkJggg==", 50, 13},
                ["RPK12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABxUlEQVR4nMXVsW/NURQH8M+vXpValKRSiVQM5E2NxWQTmyYSiVFMBoO/AoM/wCxMJGxiYCCihKliEINIeASJIvqq0vYY7q3ePO3r7yVPfZOT37nn3HvuOfd77u9WEaEGKtzCIh5iCZvyd9lf2qqs78KHvG4Age94l/WPaON1nSQKXMID3F42NHABmzHeMbmF+ayP4HjWT/S4aSc+5STgB/biqFRsiQpbMFfYhjGEmSIvWKgi4j3GOoIsZpktgm6vkeQvqfhB6cRJTJSMtDGdYw5hKz7j2yqFHMDLwtbM3x25wK94i+cNid4xPMZF7M6LX+BLXjiKN3nTm7iBu5jKm1USg3uKAtZDE/ukVlzyNyMkRn4W4/3YicvZPvvHExF3ImImIo5FhDVkJCLmI+FMRIxn2+mIuBcrmOgSo1OqLHXnd5UG7meaWl1Ob1K6R21cs9K3V6S+PZLHJ6W2qYO6zNWMVq/isxExFxFPV/GNFmy1ImKwX6fci/QyeVtENNfwXS/a69z/KKSKeu/IepjAM+lv1cZBvOpH4LoY6FOcaZzP+jCuSm/UhqFfjJASf4RD0kWeVLy8/xr9YgQWcApPcNgGFgG/Acl2LyU01kx/AAAAAElFTkSuQmCC", 50, 12},
                ["RPK74"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB3ElEQVR4nL3WzYvNYRQH8M+dYbwNGSHvbwuyYJSNxFqKlSwtFGvZSbb+ALKRjWRnhSkWMmSEpCQvCxuTJQsamSYvX4vfs/g17nXv5ZpvnZ7Tc87395zzO+d5aSTRBTbgMPra+K3AUqzCJwxO40zgOr7W5kbxsZtgsBJPsWZWF6TNuFfI3eKVKuj1eIH9WIy3xT5cxmtNuP2Yhy/T5tfgIK5iqFGryADWYl2RDTV9Y5F2lagjaLSwfcObMsJszMe7Jr4DWOT3aq0o8SzHaCPJbWxT/elWC8MkfmIBfuAZxrEdW2p+NzFS9H14VPwm8B3L8BmnMPWH9dphCJdwESR5mOYYT3IjyekkO5P0JzlTbFNJNiVpJDmf5GmNdyWJNtKXZLADv45FkgtNkjjZgnCi2I8lGShzg0lW17jvS4I9C7LTRI7XgviR5HGSOS0Id5NMJlnYxPay9p3hmU6kD09wAYdK/+5q0btLsBdjpd+nY6SmH/mH3v8r1E+tduhXJTIPt5rYt+J10T+ojtrJfw2wY/S4xA9q7XV2Jlurm4p0gj24rzrfv2O36ub97+jmgusEYzhX9Fm4jLk9XqMpel0Rqj30XPWkmcIB3On1ItPR64pQbfCjqkfgDjOQBPwCKfbHJlUgKu0AAAAASUVORK5CYII=", 50, 14},
                ["SA58 SPR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABcElEQVR4nM3UsUtWYRQG8N+nF00RBYMiEqQlGhyanBqE/oKgIRpbm42GxmhxaW10yHBz6y8ImqNSQSlycBBKw9AvsePwvh9e3i/8vJLSAy/33HvPed7zPOe+txURGmASD/ALP2vPOySt2n0LK9jBwSn5R/AYb7HUpLGqFk9hsHi/ju28wRTmcKfJBjXs4AeGJKG/MSwZMpqvNyQDJvChB98QLuU4KixkwhmMFclfcsFVx26fFX159eNPjjtGVgX/OF714OsIaWO/yk22dYsgOQSHWMVe3nASl4vctu6J3sI13OzRVMmzJE3w9IiIlxGxEX/HWkQ8iYgrEaG2rtdy5iPibkTci4jlon60qDu3VWFDOgsTWdv3mjO3sVto78fzHL/Di1yzj2k8beTkP0KFTWn029Ih3JNEvNctYgCvcV9q/iG+XVCvJ6LCIt44/oWehDF8lUQ/8p+IIAk5bJC/hVk8k6ZW4gAf8RmfpM/tQnAEhj3qWWVxduQAAAAASUVORK5CYII=", 50, 9},
                ["SAIGA-12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABfElEQVR4nMXUv2oUURTH8c+EYOJKrGysUuUFLBMtLERFrLS19gESS3uFPIJgqQ8QCEnURrBQQRD/gBBJNhERhYiiJgZyLO4I4+7szmRnwC9c7rl3fnfOOTP3nCwiNOAo5g55ZgrzeIPn2MbvIe+/gO/YxD18LRNmEXEJexXO9/Ekn/8yh7uYqRV+O5zCi7IHWdT/JV3cwXucxE0cbyW8agKvlX/wCXQOk8j/5hkelexPoDPesrNveIVMut/ruNKj2cU17Bhw3wfwSaqnUuokEvgoFVu3MK/gAaYL2jVcze3p3PECbhU0k3iHl7XCr0kWEXvYKgRZHN382aBm8Binc/u2lNwX/MABNnAEH3CicO4GFlvMg4iYiggjjGMRsRuJXxHRGaK9H/+yOqLPgWNM6tGjcE4qNFIR/hyiXetZn5FqqDXGGpy9WLCXK7SrPetJnG3gu48miZwv2CsV2i287dm73sB3H03a72UpmVmp7VaxhM94KHW7pw189/EHRhD21effCJUAAAAASUVORK5CYII=", 50, 12},
                ["SAIGA-12U"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABX0lEQVR4nMXSu2tUURTF4e9egpo0ioiCqQwWlhYWtr5AqzSpBRvLFCnzN6RLZyeIYmOlkjQ2NgEVsdFYSEBiIahE8gB1cFl4xOt4YcaZkVmwOa+9Ob+9zqmSKNqPKYPrBjbxEht4g60eNccxiw/YwxO8lqRKcjXJZsavx0nUWMRNTA/h0ij0zE+HL1ZJ3uPomIH+UJX8/lRjVgd3cGDiH4q+YBuH0Fa3hpWSszMA1C7uoiPJfJKnLZ+uk+RsksNJTiS5kkSSW0m+tuSvlvOh49fkWssl95PMNpJnyjid5GFL/l6SyVFA1cW6usvK61jAK8yUqMrZO6y22D+J8wM8298qdLcbHX9LcrBHN6danEpxcCRO1bjU4FzD5x69rONtY/0R9/CgODaUJnAGRxp7K33WLmEfHuEFvg8L04S63LXXL9TyqCC6VeNCY/0Jz//XZf2qSnIacziHkzg2ViL8ABDnNNdpL/l3AAAAAElFTkSuQmCC", 37, 15},
                ["SAWED OFF"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAABUElEQVR4nMXUsUocURTG8d/sJmgSCdjYqNgFwS5WEdKIYCGSerGxFfIOlnmAhLRrZSBYiKUPIEJCsBdhwWZ3s8JqCNkIyaS4MzBZTYaddZ0/XIY5994z3zf33BPFcawA01jGKtbwFJUiie6KBwOs3RbET2F+NHKKk2dkDhvCn1/Ek5ErGowz7PFvI4/xBq8NVzIxoiH2p3xDC18zo4l9fOZ2I0uo41lO8iZOko9kucRvdAUj6XPxP7m+o52I7SRCW0msg16OlhtGtvAW1b54D5/wKBnv8REP8SMRWypRpms9xxHGMvM/cYh3aOCXUGqnmTWzOB+10DzSE5nAB3+b6GAdX3AtlFwDF0LnamMymSud9ETq2Oybe4WDzPs4ZoTLWxHq/kq4K6UTxXFcw25f/BgvStBTmAoWhA6RZef+pQxHWlpVrKCGl0Kr7JYna3D+AF43ThjDJPReAAAAAElFTkSuQmCC", 50, 12},
                ["SCAR HAMR"] = {"iVBORw0KGgoAAAANSUhEUgAAADAAAAAPCAYAAACiLkz/AAABwUlEQVR4nLXWu2tUQRTH8U/i3WwiRMEougrWYiHYSFCxUCsrCyEW+hdY+ehFwUoUtLGzUiGIYKMQ0qS3igYUtQyCSrYJPsDIsZir3r3srvfuul8YmJkz58xv3iMiDJjORkRzCP9e6Xmd9uMG5xh2DuHfi591Gmc1g2/FKezFUbzANWzUjNONKSxgtY7TWETM5k5fCvVbcByHsQs70JJmvPkfxPbiEc7gBq5XcchwCZvwDuewZ1TqKjCDCZzH6y72fXiT579jMsMnXBixsDa2VWjXwGPpHJzsYj+Np3n+Gz7/HsAo+YhbGM877UUDz/yd4W5cwXqxItO59+EiVjCJ3X2CNaW9Op2XA1+lw1i83e7gZp84dVgvV2TYXCgv5R1GxYBzOIJXuIsH0i31pNBmagChlRnH/jy/gcuqiz+IQ3n+PV5KK1beJstDauxPRKxE4l6NF3AiIpZzv3ZENAq2VnSyMILX+k/KcF+6kh7WGPdVHJBWaw4/CrbyuZmVbqD24NPcmwy3a/o0JZGreIvFkv1EqTwtDXZpAH3/ZCyi6pbvygzWSnUtfCiU17B9mE76UfcvVKYsns7P2CLmh+yjL78Afadxcy8/WcUAAAAASUVORK5CYII=", 48, 15},
                ["SCAR PDW"] = {"iVBORw0KGgoAAAANSUhEUgAAACEAAAAPCAYAAABqQqYpAAABlklEQVR4nLXVu2tVQRAG8N+VaLgIEREVCx8xiq0g9ilSWYqWYiUINpJK8F8QxFYE0VYsBbUJEhQLwVgJAb2FYBExRMVXfHwW95xkvSbk3AN+MOzuzM63c2Z29kiihZxp6VfLxSRT9XqTdjjd0q/Ez3oy0tBhD6ZwCF9wAg9wt8XhixhFb0WTPr4lWazkUpWmg/k/eJtkNslMkgNJVjIxWgmcwjg6eFaNNXZiX4uvL9HFbhzGWbxYqxxdbK/mvUI/hmMtDn2DvcX6Nx5hDltxvJMkxYavOI/ba5BtxvKQATzGFeyvuOsgbpSbyiC+4ykm1yEcwU3M4gimC9IOPulna9Dn14ahVpdlIcnEEH2+q7hol5Ocq/T3Cv2PJNua8NXvxB282jDiVVyoxs9YwnP9y7xU7OnhQyO2KuprQ2ThaJLlyu/6gG26yMRSU876PdjR0GFLkrnqkPkkYwP2k/kb403L8RrvG5ZhAvNYwFV8HLA/Qdltk03L0UY6Sbrr2F4WmbjVhK/pv+Of2K32/SAe4h1mcL8J2R+bdL9CKghLtgAAAABJRU5ErkJggg==", 33, 15},
                ["SCAR SSR"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABYUlEQVR4nMXUPWhVQRAF4O89ryIEg+KDCApiY6eNYmNhChtTiGIhCKK1tZ2lpEgXxELETmwtxcJSsLEMgvaCPwHjT0TQ5FjcDVzk5b57JdEDwy675+zs7MyOJHra9b/Q9LH5JKO+ukp37MIULmMJr7Be9oZbOD+EQY97gUGSo/iBWy28YA+u9HXQgk94joeNtRuYxSU87nNYhUWca+G8xwXc7nNwB+zDafUjbuBIGa/i1Ca6dXzGbhzAClYqvGtx9g3X8KGIumINT7Df5HI6WPgDvC32FC8n+Kiwt2hVWG4hf8VxHMYq7qtreK7BWVX/nSZm1WXz75DkTsbjUZJqTIc4U/a/JDmfZEeSBw3dWpKT29zZxnatY3iDiyW2oTpdH/Hrj7h3YqHM76rTP43vDc5Pk8ti65HkWZJ7HSNfKK/+IslMY32U5ETDhv8jI2c7xjyFEV7jprqbbWBZ+1/bdvwGWBAPCE3D7DEAAAAASUVORK5CYII=", 50, 10},
                ["SCAR-H"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABn0lEQVR4nLXWy6uNURgG8J/dcok4TlFy6nAyEAMyMZBLRjIgAwORDOQfMDFSyh9AiZm5YkqSsZJ/QGfiILl0ctsR59hnGayl9t59e5/v5qm33rXW+6yeZ31va31ijGrGZIzxVAP+qNgZY7xVlddRHzM40IA/DotVCaFC7XpM4wT2YRMOYz9eYkWOUVgas/aPuxL38K6CLiQj5/AT3b75dTiEg5jKoteM2ONIjrawBzvQw82ypIDj2Iw5HMO2FkXVQcQELmBLwfqMZLIr6f+GhYAP0lf533iEo/hlsAUX8SfnAQ9wH/N4XbDPbqzC91wf0Qv4NFT4W2q1jnQyRejhLbaXNPEEF6VDa4qnRZMBC33jJanfnxtvJOIr7uAMNuAxZvP8NYOn/lk7JkYiGOzDu5IJkqkvy/CnMJnz63iB1biCtX11s42VLoMO9uZ8HlcrcM/iZM4vSf08IV3Tb4Zq5+pLLIcgGeniMj6W5E3jds6f4aHB1um1JbAsArbW4N3ARukGOo/3LWqqhSovez9OY5f0qr8qWP8xNG7yK1QKfwGUvd7WolZqhgAAAABJRU5ErkJggg==", 50, 13},
                ["SCAR-L"] = {"iVBORw0KGgoAAAANSUhEUgAAAC4AAAAPCAYAAACbSf2kAAABqklEQVR4nMXUz4uNYRQH8M+9c2nUqAmNKUwoC2LNcoosbaSkLFDKTrIVZSt7Cysb6f4DGhvJgpqyUCSKhs0ls/FjTDOOxfvI4/KO973v3HzrWbznfL9P33Oe8x4RYcBzsoG27FyPiF1VuG2D41gD7UpYqkLq1Lx0Cw5hEgfxAN2ad5Shh7V4XYXciogDmMOXLL4xGduPzdmZVL/YqniOz5jH6eSpFK2I6GId3uJoMv0/MIdlbMeF5CfHuKJ5b7DQUTzRuSGbeojWPzif8EIxLuuxsy8/jglso3j23qpa/BP3cA27sbgC7yNuV720o5irn/iOE3iJDdhRovuKKVxOZkbxLuWm+rhHEv9uVVOVEBFX4he6NXbuWKa7FBGnUvxOFl+KiE1D2Pfa2JN18WKNms9nuvd4opjL+YzTw4dGnS1DRDxL3blao+J9EfEt6W715c5mHV+MiPYwOi4izkTE8YgYrShaExGzydirv+gOx+/YOwzjHdys+UhbMYsx3MBCX/6RYh+PpO9pPB18JkrQsPKRkvjjrON1fvhaHW+C5ZL4jGJN3rfaazDhB3/ZCvQhZGtMAAAAAElFTkSuQmCC", 46, 15},
                ["SERBU SHOTGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABa0lEQVR4nMXVsUpcQRTG8d/qriIhIb6AiFpIXiBFqqQ0YOFaBLSIrV1IEyzS2Nulj2lShVQKWogvIFgoKlFIwIAIKYIgJGomxZ2L191xV1x294NTzJk5M/975py5pRCCJirhGaZQxSAuo1XQi7/4h/5C3CccN9s8eWACqoQneICXmMXIfTa/r8o14xFMYAZPI2A79QuH8awz7GFbCCG3UgjhQwjhKnRP+yGEG9dXwZ8OZKeRDjBevL4LLON1YvEmPuJnHFcxJyv+/Zq1g9F+4FsDgFf4jAWsy5rknJs1NYAXieDfeCvrsJ3o28ERVhsc2kzf45672CpOFKHeYygRvILHGHPd8o+w1AIQDKMPo7UTOdQbvEsErmFelq2NFiHurDKmpb96FZO46hRMrh5Z0aa0rAtAZFDPE/6v0dqp/C2qe4J6cFLjO5W1+0WboXKYuv9cGV/wsOBblBV2u3VrpsoRYrEDELepLlP/AXEf0pvsdGTCAAAAAElFTkSuQmCC", 37, 15},
                ["SFG 50"] = {"iVBORw0KGgoAAAANSUhEUgAAACUAAAAPCAYAAABjqQZTAAABpklEQVR4nMXUO2tVQRwE8N+9RCW+go0EG42IoJggCGJlo42lKIJgZRG/g7WFrU2QdBYKCvkKolWKIPgmiiCIgsYHJhqieTgWeySHkMTc61UH/rB79szu7OzuSOIf1ekUHP7dv106jxvowiw+YBxT2FWNH0Q/FrAdB7C34sClRpJOi/qGDX/AH/wbTl1FN77gLY5iBM+wWXHtHD7jOQawH+vRwJtGkuPVZKOY7rDAflypRDbxSXFyKyZwdjlSI4vn9xRPOiyqR7kzG6v+NKI40o2XuI0XeIBNmK2L+t84hm1I/U79qLWbVb+5hBg8Ul7NDPrWsNgEvq4yPorXinsL+C6LGKlVktxN8r5qzyW5nmQgyY4k40l6ktzP6hhLsqfVTKuLulWrX5hJMpRkd420LsnJqr0zybsVBL1K0tuqoKWiblaVJJNJLq9x0tGK8zDJYO37vnYEZUmin1Gy4yKGMLmG+3IeRzCvvKJ5HMKckkftoXZMg0lOtLCjviRTFf9Ou66s5NSwEmjDLeyliWvYogTiqbZdWQZduNAGrxePlWS+h4+dFPUTOhukC3UWCCwAAAAASUVORK5CYII=", 37, 15},
                ["SKORPION"] = {"iVBORw0KGgoAAAANSUhEUgAAABgAAAAPCAYAAAD+pA/bAAABlklEQVR4nK3T32vOURwH8Nfz9PjVYhsz2YW4kJpyQ24oRSm5IJJ7Lmn8BWp/AuVGspuVWlzwD7g1saQIe8wdhYsRGxveLr7f6buHPdvkXafOOe/P+bzP5/05p5bkME6jH1OYRTceYxpf0Yk6Pld4+IQVOIoxNHEDr0peAycwjuOYxFbUsNfy8BSvcRVHsBP9tSTj5Y02LDPhQpjGfaxGVx2X8Og/JYe3GMYQxuq4idF/SDSFAfRiPToU1g7jFkbQbKAHp1oOf1c0cw2+KHo1g7Ulfx7X8W0B4W6FVSQ5mT9xL8lAkt4kfUm2JRms8GeTWGBsTHI5yZUkmxu4g4fYU7nFT7zAu3Ldh+cVflcb697jwtyiXtrR/ItFz0qLehA8qPAH2gjMR5KVSSYr5Y8m6UjSWdqzqlL+RCVuRxubfo869it+6hyGFI39iDfmN3KkMj+3lALqONiyN9Mm/hp+lPMz2LQUgd0te11t4idwu5x3YHApAtuXIUDx82fxAXcXE6glOYYtOIR1uIgni5zbh5eKJ9kWvwDzG+/7GHEBdAAAAABJRU5ErkJggg==", 24, 15},
                ["SKS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABgklEQVR4nL3UOWtUURgG4GeSIRFX0ESIEYKgIAjaxs4irQiKtYWW9v4GO/+AiJ2FIKQLWhg7BSEIiqQQmyioEEHRmMXX4h7JNcxM7iAzL3yc5duXc1pJ9IE9ONNQ9gDWcB6jOIzpGr+Fb1jGhy42XuLdLn7u41q7YVBj2IezeNpQB9YRjOMtNnFIFfhJvMINPOugO44V3N0lrhnMtZK8x1YXwdWynsLBPhLoB79wp8P9SPH5tYfuDE5joY0j2FCNwt8ObRUDT8q5jaOYKufv+Kkajf2F96XwJmqOPquqv9whiDW8KTTfI9hmSLKU5HGS1WzjdRI7aCzJo8KfT3Kl3B8v694kE0k2anZud7AzEBrBOcyp2vgQN3G9Q87rWCz7T1jCpKoz8EPVlRc1nUv/XemmSPI7yYMkJxpkvlgqfbmHzK38i9lhdESSYw2Fp7I9fpM95KaTbNYSuTes0er2h+/ER9Vjv6h6xN2wgoXaeVb1TQ4WA6rQhSTPk1xNMjqMjvwBBYyqLfSB7OsAAAAASUVORK5CYII=", 50, 10},
                ["SL-8"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB3ElEQVR4nMXWy4uPYRQH8M9vZhiNS64xIbGQrYWdlQWbsWQlGitlx5pi5w9gJVtSJHJdKUlsKLeiiKQRi5lcG8bX4n0nPz/v7zc/84Zvnd73ec45z/c5zznPpZHENDEXO/AY16c7yBRYh1tYiI4T7atBcqckeoMb6ME4FjfZfGr6LkKjqT3QBccKzMcQLnQybJQZmYUvTf3zm0hb8QHbcQIzK/SP8Ln8n8BJzMBSfCv7j2IDzuAl3uI9PpYyWvJMtuE+LnUK5DA2+7U89pXkVbiL9e0G7IBRP8tjDP0Y/AP/F9jUTtlI8grLpzGx/4F7eFel6FOk9l8E8hgPurQdUJRnFHtvHtbgCE5VeiS5lu6xM8mCUrYk+Vr2jyV5mORcks8tPhNJdiXpSaKGrErS204vyZUug5hIMqfJuTfJ6yTfkwwlWVn2j7T4na8ZQFfSp/2mhrOKk2UmhhU1+rzUDZZyHA+xTHHS7cF+bCzt+rssp3pIcrNNBg5URL41RQlNYjzJ6gq7Y002I/8iI40kB/2+2W8r7okq9CqycwhXsbvCZrjFfy2e1lvyKVBjFWYnWdJGt6Ylu3v/dkZ6aqzBR8WNXIVneNLU3laDpyvUeWtNhYuKV8BpXP6LPOAHvHrfSg5u5VkAAAAASUVORK5CYII=", 50, 14},
                ["SLEDGE HAMMER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAAAg0lEQVR4nN3UMQrCUBCE4S8xRQQbG88gBIxXzpE8h2KVIij40qRInoiFSnz5u2GWZRdmNwshSJADTiN9zeea5EPKWKe6yBMFapxxwW3ecV6ywQ7bQe8jP8/C747kjvYLfUqs3xUtKlpH6UWrQjPyu8L0jf0rrWlMV5H/WEy0Ul2ki3UPNEUZDinIJnkAAAAASUVORK5CYII=", 50, 10},
                ["SPAS-12"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAABsElEQVR4nM3Wv29OURjA8c+9bkUUlTZq0DYsGEQkYmPBQBphE6PB4A8wicFgEpEY+AcMto4kGKwGiRgIEVRCIhHeolI/cg3PaXLcVnvf0ni/yc055znnPuf5cc5zb1HXtRYMYzw9w3iMGjsxkeRvcCKt/4JvDR23cbzNZkuhWmBulzDwCPagTPKX+CQc2YCtqV2BH3iI3ehv6Fvzj2xeiTO4kAuLlJF+DGFHMnwco/MomcKzhmwQW/6waY2n+IzvqW3DvbS+SYmNOI2LskQUdV2P4YqI4kjLjZabacwssmatzJEKB3F0GY1aCh/QQR/eWziTE7ha4WsXG7xrKB3E+tSfSfN9WIfVXehtsgmTomB8NLdw5EwTR2sI13Eom3yOS7iR2pMiSiOzLyYqURQOiPswlRw5jP14gSI9P0VBIC7saDYmCsVk6tfYh7eL+xwUWfl9hbHUv4nzuI+zGMAt3G2pdxte+93pJgPYKy5wBw+0LwZzmHXkmDhrRFS3i6OxCk9ENHuaShh8OZOd00VKe4VSGL45jTu49t+s+QtKnMrGd8z/Iep5SjzKxq1+vHqRXyITY0mbtafdAAAAAElFTkSuQmCC", 50, 13},
                ["SR-3M"] = {"iVBORw0KGgoAAAANSUhEUgAAACgAAAAPCAYAAACWV43jAAACMElEQVR4nL3WwYtVVRwH8M+b3pRlMhJikSJOk9BGCyqqjTBh5DJctAna9gfkMgKxNpIrdy4EoSBa5SYrFKrFqKCCpjAUgSSCzgxB4TTjgPNtcc+budx5781zHvSFy/2d3/mec7/nnN/vd64k/qfn4yTfJpkYgPt9x24bDk/hEP7GdizgIcbwFzZhFLN4B+/iDZzuM+f9Mg60kmxU3Gb8gWcH5C/gyQG5c/gUv21E4DhexXHsetTBA2IZl/GwleQSHisdS5gvIuYwgy14pjzwHBsKjWWM1NpLqhOYw108wAdoFf9bmG1jB14rIp8og7/BFZzCP6rjPIh9eK+HwBs4iWnsxyeN/nnVYi/gS3ytitM6XlbF7EequCXJz40M2p5kOsmxJM8nOVHah5PsT7IvybYku5OczSrOJXkpydNJ3s5aHClz98vehcId7fhGVpSuYgYX8T5+ws2yc1/gF1wvx3ILL5Yxi2Xn7mEr/rU2U3eUuXthp9UTnFjxJrleW8HWJEeT3Csr3tRntbtru/NVo+/xJHuSLNY4P66ze+M17t56HdyDz8r7dVUcTajqUT8cqNk3Gn1L+B1TmCy+F9aZryvaRdwdnMeHqmwaBBM1+9cenJsNgWOqot4NrW52G58PKKiJ5Zp9uwfnauOjb+KHHtx0s4e56k6pysYWVQnphqlGe1JvgQ+s1srFjnOYq25Q3FZlKFzDK324u1QCb3Ucw/4sDIIzqgQ8i+/W4f7ZdPwH4dnnxjgQtLwAAAAASUVORK5CYII=", 40, 15},
                ["STEVENS DB"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABAElEQVR4nNXUuUpFMRDG8d/hxqUSQQSxtFK0sBDfQCx8CQsLn8DeJ/CCjY2dtWBhY2+njyCC4L4X1xWNxYlwcUHPuYv4h5DJZGbyDQnJYoxKMolhTCU7lC3UBEKZw6cxjxl0NCjgEuvYabCO7Isb6UN/3RhADzawgNkU94yzJOQw+Wp4QiXlvPOI8xR/muyLVKMpZDHGOUxgFGPo/SFnD4vYTcJu0Zma+DOyGOMDun4Zf4cRHMgbruAV1y1RV4Agf6eD3+y/YDPN49iWNwE3LdZWiIAjnxupYRVV7Cdfhu62KStIwHHd+gTLWMHVh9iI+zbpKkzAFoawhDX5D/PveAOhkDzBunVvSAAAAABJRU5ErkJggg==", 50, 9},
                ["STEYR SCOUT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABPklEQVR4nL3UTUtXQRTH8c/FW6grlQSNwP+mjdTCTYsWvQBB8E0IrnwvbVu1THAZBb4DF7WqFtEmKhLEh/AhSuvXYiYwyf7Xh/zCcC8zc875nTNzpkniggzgNm7iFl7iU11rcB9D+Invdf5atTvCYZ0bqt8ZvMBrvKt7+tKihxvYqcFOcogPp9hfx1tMdQl2DnaxeoquP0nyJP35nGQpyUASSXpJVpK872B7UdaTDNe4fxtNktEWYx0qM4GHWMArzGOwrh1hCz8w2a9uysnDl1rp3epjTzn9A3xTruF+9d308bndYqRDIr+5U0fwGNtKYsvKHb+HrzWp/Sp685j4/0aL0XPYLeJR/e9hWqnss8uRdXaaJBtKs8Nz5cU53lx7SjM/wDieYu4qRXahxRvcxRpm/7G3UZ7Zj1eg68z8AnHM/AdN6FVoAAAAAElFTkSuQmCC", 50, 8},
                ["STICK GRENADE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAAAlUlEQVR4nN3VTQ5BMRSG4edKzcTE1MwQWxFbuCuUWAGbEBOxDULUoBWGJW403kl/0q85X9tz2sQYVcoSLc4Fa/chd/q4ohZXk9wuSgUBG8wk5yfccMQuj7tgjCmGL3MNRtKhBmU38RTHit/WO/R+HcC3+BsjAVv15sigdMMmp0iNVWuOVangUX4vnYTzOQfJyFrhP3IH6RImezn8IfwAAAAASUVORK5CYII=", 50, 9},
                ["STREITER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAYAAADRGVy5AAAAf0lEQVR4nM3QMQ5BYRSE0XMlGlahVIhGp7AMicJ2rEGlsQeNNdgHUT1eCImr+AsUEtWLr5tkMpmZyMwV5l4k4k0HDqh9csMWPezRwQNXjNHWDBUWkZkDTHD+YmzhiClmWGKEIU4NFIWLctBd6VkrAzZYo4rM/DWsix36yvN/xRNzkSJRssjMKwAAAABJRU5ErkJggg==", 50, 3},
                ["STYLIS BRUSH"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAYAAADRGVy5AAAAlUlEQVR4nKXSTQrCMBCG4adaf0AQqUtv4MITufQuXsiDeABXLgXrpohgS1w0BYUW1L4wTCYZMt9MkoQQRCbIsIx+7H8CjrhihDUWyONejscP9+2wxyXGczxRRT9IcY7CZz2Ed1FgirTl7O6zsWZ9a8ndqIdTIlE30MQlVkkIYevzJRprK96H6k1wgWFH3Uz9O77lhMMLwL0nKYwtr4kAAAAASUVORK5CYII=", 50, 3},
                ["SVK12E"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAMCAYAAAAgT+5sAAAB2ElEQVR4nLXUz4tNYRgH8M8dd0T5kR9l0k2xsUFpLNiRKcVGahb+grG0uwv/gS1LCzZENuxETSxGIhkWbDBK8mP8aOZeEuOxeM/pHsfBvebeb729532e57zv831+1SJCH7AT97EXN/txYa+o92g/jia+4hum8AN5NA7hAL6jge3YjBra2LR4l6vRK5EGRgvn3ViQHIdjGMaSbC+ifO4reiXyGZfxBk+wKlvns30OE5jGSykjWyViG7FDh3SONl50+f44VuNMWVHHmuy7gaUl/YxUOrJ9HPsrHmh26ch0hewT3ma+tDCPizhVYbsBX6ourkvRWNmlI3P4+AfdCv9XPrM4qxOwtTgqZWq+ZLtPIrK+IHuF2boUjZxISI28LLvkeaYn9cIenQzm8paUzSKJBUxmsmL5Vo3IdwUS8AFXcBB3S7ZtjGBLQVbDsIiYioTJiGhGxK6IGIuIdRGhtC5EBxMRcTiTX49f0ar4d6ArzwjcwDm8rohaMdKk8prB+yw6VzFWsFueZaLc2APDkDSBcvyNRF1KN9zGNdzDM5yWmrZ470jfvOwCQzguNdjJf9iO6vTHg5Iu8LQk27ZI33pCXZoClSOthMc4gSO4VaG/hDt4iEd+JztQ/AR21QEhh3ph1gAAAABJRU5ErkJggg==", 50, 12},
                ["TACTICAL SPATULA"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAALCAYAAAA9St7UAAABEklEQVR4nM2UIUtDURiGn3tdmwpb9F+MBcFgENP8B6bJgliMVsEg2FwXxGAUNgWzCGsyi8F1xeDAPEGfhSsynWI491x84JTvHN6P93znPahEWhtqorbVirqt1tVltaVW1UN1Rh0YxkksE5sfDc7VJ7Wn3qn36pX6rJ6pr+qpOgowMVBnE5WcWQM6QClv4R8YAUtAvwQsAgvABbAKzAUIzwNtijEBsAP0AVAP1Jp6rL4HjLhoumYZRCUFXoBb4AZICrrJUB6AFvCZixSoADWgPrnxj3kD1oHhZDFRY2SkHKDxF7vA3vdijF+rAXSJE/hrYIVsKl9IIzS7BLYi6A7JntSUCYhjBOAI2M9RT6AJPP52YAxkSz5bbrNGwQAAAABJRU5ErkJggg==", 50, 11},
                ["TANZANITE BLADE-ALT"] = {"iVBORw0KGgoAAAANSUhEUgAAAA4AAAAPCAYAAADUFP50AAAA3ElEQVR4nI3Pr0pEQRTH8YNJQYNYLItpg6CIPoBgEowW9xXsvoDdps0XEJNi9CX8gwhbZDEYbxJsH8u5ODvuZe8XDsww5zvn/ALRsxZxK+krLeNSQR9pBeemGc+TlnBWSa9YnyeeVtITthFl0xB7xX1USS/Yb9/bpgFu8IgtnKAppHccldu0h4Oi6QGT4j7BcR2jnljT5PR/+euM95U4miUhFuKPjYjYjGkOo4v8YRfjnHKB5zz/4Kpr1Td8ZOM11nLtr6xhl9hyh9XicZDVmXEnt/6OiKZI8Zk1k18tZmJJn30IFwAAAABJRU5ErkJggg==", 14, 15},
                ["TANZANITE BLADE"] = {"iVBORw0KGgoAAAANSUhEUgAAACEAAAAPCAYAAABqQqYpAAABRElEQVR4nM2UTSvEURTGfzNMmoVmYWWHFbJQklJeNpKVjbIijRIbKwv5DMrnICu7YYG1svK6kZHERkmZovGzmP80L6W5i5nhqdM5t845Pfee5x5UAiylZtQxdU+dDawLslZqIwVkgBFgCogBZwF1wYgH5PQAvVEcA3LASbNJXFB58yQwX08Sxbn0qwu/zGxU/bSED7VHnVOH1HF1Ru1TF9VOdV1tVzfVNnVLTaobaoe6EvVApUjgWc2r6ag4rSbUVbVFPbAST+qX+qq+qzn1JerxGOU81PBZtbtI4riseV69juLLKt8I3KtdMXUQOKcgur/AaRzYKSPwDdxE8VWVbwSywBIWBFWtiWULmlizSZr4F7+jliXUo6qX2A6oC7aQZTUADJedc8BuPYURQuKOklilsDEnm03iDZgGDoEJYB+4rSeJH3i4Mu/3nJ3cAAAAAElFTkSuQmCC", 33, 15},
                ["TANZANITE PICK-ALT"] = {"iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAA5klEQVR4nJWRMUpDQRCGv1zCE1ilSSOYPq0oCM8DeA8rz5BKvEkuIA/SpIwWQhqbR0Ah6T6beTiu+546MDDD7Lf/vzsTlYFYAh1wN3QANedK7SKP6iHqh+IcKpNCuQXOKhofwFvUr8CipjxTnxyP5yFlgDlwkvor4Db1L8BpTbnMRl0Xyu/9H4yBN2obwFp9TBd0Y3CTwDb6ywQf1PsaeJ2stuGAAj6qyxK8UDfJapNmGf5he6FuY7gJB3k+92uN3+BzdReDbTioPWkWT1n18FTdB7gLB7+tkB7uYx8O/gSW8PQ/oMonaJhuTL57J60AAAAASUVORK5CYII=", 15, 15},
                ["TANZANITE PICK"] = {"iVBORw0KGgoAAAANSUhEUgAAABEAAAAPCAYAAAACsSQRAAAA40lEQVR4nK3TMUpDYRAE4O/FB4EgFuIJBEVBUEirlnoGT+CVtBObdDZaxFpvoJ1oJWJlIWIjOBZ5D2JI8T/IwMI//8CyO8NKorCGSa6TDGa10gZLSZ4ywTjJWpLdVu8pwy8emvcxnnHaiqVNKnxN8RUMmv/idSSpk1zlP066eNJWP8lt0+AnyV4SNTZwjje8Ygt9PGIV63jBB3aQZqUaYxxUSe6wX+jNPNxXSTZx1mGSyiQheMfhQjwpjbj1YISjKb6N4nR6SS5n4r1IUnWZJFie4p/41ia1iNvpYuowyU3mXPEftSjMQJ/z9ZcAAAAASUVORK5CYII=", 17, 15},
                ["TAR-21"] = {"iVBORw0KGgoAAAANSUhEUgAAACcAAAAPCAYAAABnXNZuAAAB9ElEQVR4nK2WTWsUQRCGn9kPhCgRTNQoiAgGzGEPBhERPAfEH6DgzT/hRW+C/oTgSRBFkOBB0IOBHAUVA3tYBDUHUWNEWTWGDSZ5PEwFx2V2Zz/yQlPdVdVdL2/1NJOo9IkaUO93Uw5OAq+7JVT6PHAE2B92HagCAglQipzNsKXwt6+3Yk8NWIx5LhJ1EpgH9hQQ2wTGogCk6p0IgnnYAr4Cv3Nio8A4MAm87VSwAtwBjhQQy0Mt7BdgCWiRqgkwQ6rUQaAZBH8BH0mVOgrsA451I5eoLWDXAOS28Qf4AWzwr8UTPe5dBtbaOZESJ1GbwN4hyA2DU8D7HH8J0ra26J/cQ2A2s54GbsW8TtrqaUKBDvgAvOpWZJtcP1gF7gHPMr7dYdeC1AZwGnhOqsxLYAVoAN+BMnC8sJLa8H+8U5sx/6SuZ2J19Zw6pRKjor6J+BU1Cf+U+kgtZ3L7GqiLmeINdUI9oN5Ux9S5TPxFziHnI7YcRFGr6pM4ayBiKhXSuzIO/AQeA99C1KthVzJCH84R/3LYB9FOgOvAbdKvcWBUgPsFOUtt5A4BnzO+EdIH926sz0TOtWGIAfQi79m2O3mpLV5WL6o31Bl1Xh0dpp3ZO1c0qupqhtxsh7wk7t+FnSCmktjbX8kc6XOxADyl4G9ip/AXghhMT6fnhg4AAAAASUVORK5CYII=", 39, 15},
                ["TEC-9"] = {"iVBORw0KGgoAAAANSUhEUgAAABsAAAAPCAYAAAAVk7TYAAABLElEQVR4nLXUvy5EURAG8N+yJIhGgo7YSkOCR1BIFGg0Qq33AuIF1AqtSiFR2HcgKiQKjYRi240/iZUdzb3J3Ws37rK+ZJKZc7453zkzk1OKCJjCAUa0xweeMvE4ZnCJITTw2Savgn7s47aUiO3iqINQL/CCal8SrP2jEAygUk6Cxh8Pe8VF4g9qbUcdx6imYpdY/6XQAzZw9yMzIlI7jVbUI2I4s59aM8fbacNpa30Z3dHcPc7wVuBlzaIlSMUmsJzbOyl6SFGkPdvK+FDDGDZ7qpbU8yrXh8MOdR+KiL2IqGW4K0V7JiJm4zuWOiSUEsHHDHehmwHZzj32HtedCoF3WgarqwFZza31fDBSlLGIacxjDucF8koZP4qKpR9xN+jHMyaTeB43RRK/AHQWNXJ8THmUAAAAAElFTkSuQmCC", 27, 15},
                ["TOMAHAWK"] = {"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAPCAYAAADzun+cAAABBUlEQVR4nL3VTyuEURTH8c+MZ6LGiMlKkmIhmXdgKbGQBcnCSnk1rL0FC3kTY6GsLa2lNJspGgzH4t5iMTWJeX51O+d26nzvuef+qUSEErWHK6iUDL7HOh6rJUKbWMIRlAluZbtVNriZ7Srl9ngWT9mvFxjDGZZRQYEPvKOW42/ZyvF2TtLAGm6GQMdx/GPeqETEJfb/WM1vtVhIq21hTqq4ik/0sz+BF6niAoFrdDEp9ex2CKiGTXRyvtcCPaz8az2DtY0TzOC5wHkJUJjHg7STvbKu0w5OMS0dyL6IGNWoR8RBRLTjW52I6EbE1CjBGxFxF4O1O+oHpCqd5kPpc1iQenzxBbos7//aspntAAAAAElFTkSuQmCC", 30, 15},
                ["TOMMY GUN"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAANCAYAAADrEz3JAAACJUlEQVR4nMXVO2iUQRAH8F9CIDFGjBEVbMTCF4gWPgorDUIQGysRtLGRFDYKEhAEK1EQIoKCiNgIIgoWioXRWFlE0NiIT3yALyQEY2KMmjgW3164HF8ud2fhHwZmd3Zm57WzdRGhRvRhY+IDK/ASHWjFlVoN14DDdTUGchRHUF+09wUjaE77I1XafIAx/Ek0kYgsURMYx+8c3c6GKi8roM3UIGBhouJ1HkaKnGlGY+JvYFQWxHjam4V5+CwLckI+LlUSSBs2YzVuYS2W55wbw0fMxqIy9prQkvhuPEv8CVlLDuAmdqR1AaNYV3R+KiKilOZExPaIOBkRjyJiIirDxaRfFxEXcuSfIuJpyV5H0b19EXE8Iuam9cGSs505vk5Sg6x8m9COLdiAalruA3rQVcgNfpac2Sar1gDeTWN/K4YT34bdJfK75ZxowBMsrdRrfMVt3EMvXpTIF2NP0foVfmEIq/AGy3LsFoJoTbbXpPV77JIlbHpExPMKW6c/InZGRGO5EkfE5SKd1xHRUiLvnqa1CnSqSD4aEQdmuG+ytX7MUIFhHMJ52UQph/UpewV0qX4MLynkWPYXdVeiVC97I9OhV1bic2YOgmw8Fj6mh7hfiRMlOCObgI+xt1KleszP2R/CftkDfFuFE/3Yh2+4Lnvg1eIOVuKsaoZOTB2v3yPidEQsqKQvy1BTojzZsYgYTNT+j/dMUl1E9KSYruEqBmvI4n/HXywSWo5LRNnyAAAAAElFTkSuQmCC", 50, 13},
                ["TOY GUN"] = {"iVBORw0KGgoAAAANSUhEUgAAACAAAAAPCAYAAACFgM0XAAABpklEQVR4nL2VvUpcURSFv3EUB3SCNmqllTYW5g1CClstYhNEBoKFVtpEA5oHkITkKawstEmXwgSClURFAwmMQgIWEiJG0IyKn8U9g3fM9Tri6IIDh3X32T/r7H0uKjVYPepU2OfVZ9WevWvgZnVe/aOeqDvqZ7XzvhPIqWPqhnqg7qo/vURBzaqP1ZlaJpBXX6o/QuDTWNDvVuKfeh72k7VIIBMLsuz/OFV/J/BlvA+qVPit42bUA8PAOtATuCxwlmD3K8XPJLAINFewKRXn1HF1+5pqd65wJ+pmigJlLMeVyKgAXUB3yKkb6AMGgY6ESgQywCfgCVAC/gYFWm/UM8IrYC6uwEIVme8azXqXuqUeqmtGzWjYf1Rn1dEYn4SS2mdowg51NcW4aDRyOS+vZ+SKzZ7aojaog8GmYPRGlK7xu642on5NMXhuQueGQB/UYbXJqGLUdrVXbVP7AzedUtxcRn0BDAHvgG/AMbBf5V2WkQeehn4QOARWwre64Hsi4dxRuQnvG1mgSNTscby967/gNmsgJv25+sbYGD4UloBHwGvgC8AFDJdenNPvBQ8AAAAASUVORK5CYII=", 32, 15},
                ["TRENCH KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAACwAAAAPCAYAAACfvC2ZAAABoUlEQVR4nMXVvWtUQRTG4WcXDUSM6dQQKxEFK9FC0ogGRawtLARB0CJgs0Uq/wFBsLHQzo8igoWFpaKFjVVSiChaxELED9AgSr5QX4u7C7MGdtXd1R8M3JeZOfe9Z86cW0uiA1OYwBCu4gXOYwMe4XqnzYNg3S96L85iBTPYjlOo4xaCBt5iGkfxGLvwpLlvsCRpja1JbiYZTjKe5HWSk8X8TJKLhd6SZC7JjSRTSW4n2VnMD2TUC++HcA1LeIO7WC3mv2G20BuxgNO4ojqZc4NMLu0lMYpaoZ9rN/wdc4Xeg0v40dSfMdx/i+2UGR7F/kK/0/4Bm/Gl0AfxrNDrsanP/tZQZngS+zCvymYDixjDbhzDHVzGDpzBuOpyruDEvzBca7a1STzoQ7yXqm5ywN+bX8Jy8/kjnqpK8SGWa0kuNF8w0ZvXgfMejbqqNkf+s5nfYQRjrZI4jPt9CPoK93BEdWE7/ka7sICvqm41q2qzH1qGh7CtJ6vVSU3jeI9xOtLqEquq7tAL8/jUY4yu1Lsv+SNq3Zf0Rr8NL/Y53hp+AosL2uQMlUOhAAAAAElFTkSuQmCC", 44, 15},
                ["TRENCH MACE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAABZ0lEQVR4nN2WMUvEQBCFv7sEDhuxtRHBzsI7uEpIp4WlgnZ2ooWFxWHvPxDxF4idCoI/wsZCgyDnoaWlYKGggnfPYvdgEzYa8DaFD5bkvZ3ZmWFnN0ESFYwFSc2c1snxuqSdnLYiabpMjDrVYA5o5bQ1YMzhM0BSws+Lqgpp2jFEZPnsDzZFmhfxX7L7BVPAkn1vAW/AluUNzG6sA22rJcCkYwOm0HFHOwNefMFqkkaUd3Zd4AHTLqPEBbDsm4iBTWAeGJDdob59Ro72hWnHYUvK2kWY5LHrDBh9EQATRRM1BdqSQHgFroB7TKt+Aj2gW9VhD44Yc5BCtNZGgHyvgUXfxL857KEKgez1u43p6WPLG8AhcAB0rZbYJHedNTrAE3BqeeH1W8XvCZKOJO07PJL0LqntaKuSejm/c0l7ZWKE/CC6uAWeHd4HUuAuZ3Pj8UvLBKiqkJRsIQAnwIfDH4FLj19aJsA3/5h5NAUQJ9wAAAAASUVORK5CYII=", 50, 14},
                ["TRG-42"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABGElEQVR4nM3TvS5EURDA8d9lKSQSlY6EkkbpBbQiEQWJmkajIVFphCfQSLyGTqIRhcRHoyQKIhIJ62sTRnFPsVjZ3btb+CeTe87MnDkzc+eICC1IKSLmfuimWoxZSLKIUJAhLGAROygjMIlLbCe/F7xjGKPJJ0vfc5wUTaCaLCKWUUrBB9CPCp5xgQMcV50ZxCw223D/G17bEIeoz2dEjKVfuNKAfzNsFBmjWlJqoNayfFQmsJ50V9jHNaYxUuNcBTf4wEPSPaZ9GT04Ldj/XzRSSG9KqBsd8lHbTcmcJdsabtP6LtkPU9J/0VnH3hRZxLfXvoentO7DuLyQalax1a4E2kUJR/LuZJjHfZW9CzNYkhdF3vV/xxeS+4V6sDXUbAAAAABJRU5ErkJggg==", 50, 8},
                ["TYPE 88"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABUklEQVR4nK3TsWtUQRDH8c9dDi+agCKS4sQINnZWYm8n2pgyTQJ2afKnBNJaKf4HSgpJI2KpcqggmoBFOC+EVL4mMTFjsXv4PI0ne/eFZWfn7fx25g3TiAhjcCuvGVSYRQPHOMLZfO8QF3ADbbTwGlNDej3sZruNc3ic4wfcxzWs1QMbYxSyjtXSYOz7s5BtvMBJPs9jBw8xSPQmrmAPB1mn3ypI4C42CuKGufQXXwcX8SOfD7Eidf2z1KF5qdBKKuQV5hoR8civdv4Pt3E92+dr/i/oZnuh5j/Oj37L56t57+PrkPYnqQN1WriMxX9mFRFLEaFgnYmIKhK9iHiQfZ2I+BCT5emofJrScJYwi+lsL+OZNPRHeFKoeRrdURdKZmTAnRxf4SW+1769xZsxtId5PupCC+8Lxe/lfdPvRQx8m4W6RTSlv1fCFj7i3eTSKecnEwDv8Lz2H3MAAAAASUVORK5CYII=", 50, 9},
                ["UKULELE"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAABO0lEQVR4nNWWvUqDMRiFn2or/lGLmy7iLtLN0QsQr8DZW3Cou5MK3oGboqvFC1AER0FadHHoIKKIVUv9KT4OXwpdLBYjbQ8EzpuEcHJySIJKaHn1UH0xwYN6oC62zOlqa5Ilte7P2FMnuy02pU4BZWCC9rgHdoBrYBZYBhaAV2AfWAv8/6ButHG0E5yomQgODqoFdb2Fb6rDqBeRxKquRhCbVcvqlZoLJtyqMyn1HRiKdFBnwDZQDXUN+AAEnkLfG1APvAp8BT4ArAAFYBzIAhlgJIwXU6qRhP4FnySbGmsz56ZXxP4GjYFuKwhokESmHSppEvtjZnYLeA51M7OQZFY6y2waGA3jpV68DXLqpVpSp9Vz9U6dSwNFYD6Cq6fAboR1asARidOPwDGJy5W+e8H65m/QWuTt8V/XN9cZJHogLHAJAAAAAElFTkSuQmCC", 43, 15},
                ["UMP45"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABbUlEQVR4nL2UO0tdURCFvytXBUUTIihWvhDEWKRJYyVYBC2stBEhnXaChVj5D2wsLK3Fylb7QIpYqohCksJCQS8+UCQ+Pos7moOo51y5umCYzbBn1pq9Z29USrBGdURtLTEPdUmdUsmTDQ3ABDANfAR+An+AC+AKqADywDVwC1QCy4n8ZmAI2AVIU9ekTqqHlgdzKjn1FFgFaoCvwG+gG6jPeAql4ATYQd1OdLYWfly9SSg8U9fD9jN0dK7uqZexvlD/qfNqVZK0Vj1Qe9WFIP0VAuoSwqpDhFGsoF4lCPvUKp++ri4V1CN1IIhUj2P95ZnEDvU2CAcjtuD/e//2TN6DEUoL6g/1u1qTkjQbxVfUdrVT/aDORHwsjTQPfCpxGIbDL1Icuntshu9JK5D1nSbRD4wC64/iG+E/pxXIqa/gfboWcAwUgLaXNlaUixEQ2AJaSHnj5SSF4hHnKH4u70aaaZjeotO/QONLm+4AiM1w4f2iFXkAAAAASUVORK5CYII=", 29, 15},
                ["UTILITY KNIFE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAA9UlEQVR4nL3UPUqDQRDG8V9C8CMaglhYBNTaUkxnYWflDbyHtY0nEFurXEALBcUTCPZiaSMaFTGSiGEs3hWCRUDerH8Yltkdnmd2GbYSES08YBVbWFQwixlMo44pzKGGBqpoptqFtDbTfiPVdXGFU5zjUS4ioh0RJxExjLz0ImI3IuSIKtrYSS+ZkzqOsZZDvIbtHMJj/M6UG7E+nnCLa1ziuYav0u39jeUUk6KPgyo6ExT9b14U/XcqEQF72Ff8ULno4kYxAYcYlNAK3OMOQ/i5CCxhEyuYRwsbWE/nPXyOiA3wMZIP8fbL8DWZXuAI7yWaH8s324HgmwHy84AAAAAASUVORK5CYII=", 50, 8},
                ["UZI"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABbUlEQVR4nLXTPWuUURAF4GfX9aPwI35hYZNCsE4nWKTxDySIlcRfYZVeEH+Bnb2oCCIBK7XQRrSyEpIiImgiq0bJBuOx2Bu5rG42+5ocGO68885wZu6cK4lid5N8TnKhiu3UDia5neRkFZtIcj/JpWF1HX2cwuXiX8ctTOAIjuMw9huOn5jDO7zEOi5iBt/wAt//qkrSTjKfvUM3yc0kc4OTt5JMYnGbqXYLPbyvAx3M7jHpFzzBEm7UP1pJPuI01rCJY6XLHziKp5gq/r5S9wFfS82JUtNCBs7HeIB7/2wrSa/s5kqSO0lminolmSqq7VY77CU5l2Sy5DR5HX/Uvo4DmMc0ulVvr8v5q4qt4my5zkOlthHahXwT1waIayxX/ic8wwbO43lT8q3Jr+LNNnlnBr6Dt01Jt9DWF9erEXmNr3YU+QJWRuQ9rPzO0KxxMYY6F4raHyVpNVV4be0x+two55r+zv8b45DvOn4D3E7UPCcemn4AAAAASUVORK5CYII=", 31, 15},
                ["VOID STAFF"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAJCAYAAABwgn/fAAABIklEQVR4nNXVv0qcQRQF8N+nrmgMcaNg0qSxSiQEQh5DUgTyGkKKbCvYRPBRbNIFOyshATsLm/wjErTdIlsoy0kx88GH1Wqje2C4M3fuzD1zZoYriSlrL5N8STJM8jPJxyS9JokpwgfsYQaf8RV/cDV3h6QmxQJe4x0GuMBbHHeD5rCOFfSr7/E120dT+7MY4W8d/8PlDQhtYIg1LNX8a3XONR4wj+fodXw7+FG5jFtnk+QcTyckc98QHGG3SbKoKNLah4oCy4piy52FPUWF7xMkafdrsYAXyo30FfUbPMGDGrPayfeo5numqN9iG4fKSxjjFKNp+OxLeIP32MIZNnHSDZqGg3QxwCflSe3jG35jfNc14TbtVZKDWkd+JRkkmf8PguhkfiyUgawAAAAASUVORK5CYII=", 50, 9},
                ["VSS VINTOREZ"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAKCAYAAAD2Fg1xAAABi0lEQVR4nLXVv2sVQRDA8c97XCBiLIyghSiJoOIPRFFJq4ilRcAihYj+E5a28sBWCwsL/wOxFkQbCxFFQhARsXiCIBhDjEQhY3H7yL7z1He+8wvLzTAzuzO7s7ediDAmW3AVO5I+ieWkr6KLCXzC4UpsB9PYwCxu4RG+NFj/PC52xizkAG7iwjiTtEGB7VjD+ogx05jHOezF6f+TWjM6EfEW+1qabxWPlcXuwe4anz6eZ+OrssUGbGjWWhOYKvDSZiHruI2PmeNxLCT5He5g0I9HcSnJkRK6nuIn8aay6Am8aJDk6ERELzbpRYTKKCLie7JfqbE/zOL7ETEbEUci4lBEvI5h5mriWxldfMjq2lpT607l8cGzGvsgJnBGeWqLWMK1iu/MP+73X+kavh+nanxOZnK/YpvCsSS/92sr3Tfc7zPNUxyNAgczfQ73lDs64HIm38XTTD+rfEf4fe/fwA/lJtSdaCsU2IZX+IYV7FJe1FA+bE/wIPl/Tt/l9N2fzZX/IHJ6rWX7B34CvKzpPjgLsUwAAAAASUVORK5CYII=", 50, 10},
                ["WA2000"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAB8klEQVR4nMXWT4hOURgG8N838zWN5G/5hvwpyWiYWCoLsrGylVhIrOxmI3sLpVlIItbWJCtJGtlIqSHF1JSMmUgifTFjZnzX4j3T3JlmuN/9ME+d7u2c+5z7Pud9z3NOJcsyJfEaNXzHAJ5jM16iG6dwAyPowSh6U+tBJ/pwuWwAeVRaEPIe61v8f5+/JKTaAvcFxjCBxxhCP46hA8vxLT2viKB3Yxd2iEXYiiNN/PMgVuP4/IF8Rg5jlSiZP2EE21KAVfxMwXfjFRqopG/bsBOXcBGfU38/zjYhYoazH3sXEvIQ0ziQgimC8cRZ0WQgP8SeeoqpNE8z2IcufMKG/EAly7IptItVbC84YUOsdFncwccSvI1CyB7UzWa9URXqukR5FBXSKuoleWO4L5zvgVkhWSXLsiFsF6kuWlqtYhzLSnJv4RBW5jvbUMZ/3+JNjjud2m08KcAvK4KomvPzO6vCqVi85jOzKYSbOJHer+GMsOC7OJm+vYrhFoL9He6Jw3cO8pv9KM4JYR1iQ1/HaVF6MxgV7tHAI2HDveJcqAufH8DkP5GxCCpZll3AV+Hxm0T91kWGJoUZrMlxBrFFlFIt9a3Fl/8T8sIockXpxDrhbDV8wLPc+LC5GVsSFLmiTOBdajMYFNeNNnHItQv7XjL8AtVxf+1zfjOnAAAAAElFTkSuQmCC", 50, 14},
                ["WAR FAN"] = {"iVBORw0KGgoAAAANSUhEUgAAABgAAAAPCAYAAAD+pA/bAAABKElEQVR4nLWUvy4EURhHz9hFPIBGI5uoFEQkEgodWglPsK+g1ngHBQrRaCQ0JFiJ2JAgNP48gETjFWx2j2L3ymQys2Y34yRfcyff+d07882NVLowD6wCi8A00AQawBBwB1wAN8BzpkFNq1n12vzcqgtpruRCWd1Rmz3IAy11Wx3MChhWj/sQJzmKh8TlVwXIA6chJARsFigPbKlEagV4B0a6jVMffANTkXoJLBUsD5wNAAfAyz/Iv4D78A0idUWtFfDuX9Wq7cFJ/dFm1EO1EWtqqY/qrrqnPnXW4s/P1eXOZn99kdlXRQXYAKpArXPkOSACHoAxYBI4AfaBt1RLygmSNaquq/XYjuvqmlr6qz9PQKgJ9VP9UMfz9pV7mIoS7dlu0r5Nc/EDbRMgY2WoQNkAAAAASUVORK5CYII=", 24, 15},
                ["WARHAMMER"] = {"iVBORw0KGgoAAAANSUhEUgAAACsAAAAPCAYAAAB9YDbgAAAA9UlEQVR4nM3WsS5EQRTG8d9em3gAzSYKoVRpdRq1B/AEaLyAV0A8gMYL6LYguzReYAvR0GqUorGO4t6bMGY3iNj5kslk/jkz+c7JmcmICIWN+Yg4jM8aRcRqJyIUpi2cZ3i/+mcj39HyBL5SotkznCbsFjslmn3CRcIecV1iz8IN1hO21sUB9vCMS1zhFWPMfZhl2F/HVFhCL5PARicixk1Q6Rp0cYxdvKgrO1RnmqvImzqx31St3TstpsIitn19FQZtz1bNYaUo27NtpiUZhZNkPcSoxF5dwGbCepoLNgM/U7WPowy/K7GyDxP4/ax/WD/6db0DbndSEZVbeYYAAAAASUVORK5CYII=", 43, 15},
                ["WORLD BUSTER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAAAqElEQVR4nNXUvwpBARTH8c/VtckjGOzyCCYymKweyaPYjLKalSwGsUixKFmkruGmpFvuJRff8fyp3+l3zgmiKJKSAUroY522KScuQYZBZqh9UMyrnNELMzQUPqXkDU7oYhRiiAbGSLInQB3V3OSl44AOJhCKV6aMRUJxJHaigAqKuUh8zg5tTG+Bf7yRLVqY3wez3MgvsEITy8dElkEW2Pju+93jmJS4AjlvJGu/bS3RAAAAAElFTkSuQmCC", 50, 8},
                ["X95 SMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAB0AAAAPCAYAAAAYjcSfAAABVUlEQVR4nMXUu2oVURQG4O/oCAFvICohnRfirbCwsg3a5xW09hFsFPRN7H0AY2MsBLVQEQQl6ZSDoIQDHhXPb3H2hEEmw2QS8IfFXmvNuu89a5TEQFzG+562pzDCGA4MzYiju7D9iYu1UOFTD6cZTjTkKT7jTIvtCCnnqOiCp1jHrMLZXVTcxFLHtzGe4bR5h3/wY7uqJLNGRfuJutsa37CBVNjUPqY2jDEp/BIWOmz/beQ57tVJ35Wkr3CtI8gWbuBtkVewZn63j3ABV3AXL1r8L+ElSPIgO+N7g99IcjKJQreL/nWSY0lullh2oIWar/AYBxsVTXCkjOdcGeN1rOJrw+5WOZ/gN95o/BYtmG5zHZXV9LB0dLWhO5zkV5JpkvNFdyfJYo94g5fDcRwyfw8fi24RX/o4VwOTbuEDlnHffHms93UemnSi+/46sZfdOxj/Jelfh0r3n91oDZEAAAAASUVORK5CYII=", 29, 15},
                ["X95R"] = {"iVBORw0KGgoAAAANSUhEUgAAAB8AAAAPCAYAAAAceBSiAAABkElEQVR4nLXUz4uNURwG8M+duTEUmSzIkpSVxGiUGptJWfBfSNbKH2ApO1s2tiwkKSxM2AqTX1nYaZQYGcVM7jwW77l13DT3vaN56vT98Z7zPuc55/s9nSTWiX34iF8jrDmEF/1gbL3M2IodmEC32AlsKeNf2F8HXTxsSTaPKdzDB8zgLIKXOFjmdYqdxacS98q8AxrBq9DJf5z7ECxjBd8xXsh/YxoLG02uEHaqeAnX8BW9MXzZQPLOQNyvse2YlGQuDd5kOOaTnEwym+RUkuclv5LkZ5LlIetfJdEfXbzGCexuoeQtHlTxtKZ9ruAWduIcrmrud1D9xF9/S3K+heI+zlQ7H0+yUPJ3kmxOsjfJpVrdWqOL67hf7WcJ24p/HDeqb73KP1yd1kVNdR/B3RYniKbPVzR9W+NzsYsD+T2Vf6zY23hX/KO42ZZ82Au3OLCBqcrv31+feBLf2hLTKB+Gpzhd/Jkq/wTPNC/ZODbh8ijkbQrjQlVwq0l2tS2oNgU3DI/xHo8whx8jqVsDfwBaPIPgIwLktwAAAABJRU5ErkJggg==", 31, 15},
                ["ZERO CUTTER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAADCAYAAADRGVy5AAAAq0lEQVR4nL3RzUqCURDG8d+rgQmZWu1btAuCbq1lN9SmW3AheAvpqoWbhBRTgoqCmBbviC78CAQfGP5nzmEOD88UEXGBe7xjYLN+UcU3PvPuBx9bZnYpMF/pj9DIcwMnyVO00EQbZzjP9y4eiojo43oPM4fWGD108IgpFBFxhTs8Y6RMqYZbXGKo3MZN8s0ypSYqypSsEI5R/6e5WXKxoS9M8Jp8wVPWcN0Hf3zHKylcKx3UAAAAAElFTkSuQmCC", 50, 3},
                ["ZIP 22"] = {"iVBORw0KGgoAAAANSUhEUgAAABsAAAAPCAYAAAAVk7TYAAABF0lEQVR4nL3TsStFYRzG8c897mRUdoO6WbEoMZspsZBJBovR5E9QRExS/gQpFjvFoKQYDFwZ7qAk5DXcc/N26DoH11NPvef9Pb/3e97T75RCCBWcYwQXfq5RDGIe1wifEiGElfD3mgkhyLr8i5s00xAeMnv7rYJNpY7Vm6CvRcCsthN0/hOsJ8FegYbnKH+Kg8i1KLeIjtSl1G3l9IC8OsIuhtGP16g2h9V0Xc3AQYLHArDGv/OWAfHx0rfY+ao5KQDKqzs8fVUoOvoVdKMdy7iJamPfNReF1XCG2WivhPU8zUVhVWxEzwmmcY9J9anMDbvEeJP8UrQewAIO0SXHoJXVP80VTrCJ4yb5Layp3/AKE3j5DtLQOxU/nR3e/F9+AAAAAElFTkSuQmCC", 27, 15},
                ["ZIRCON SLAMSICKLE"] = {"iVBORw0KGgoAAAANSUhEUgAAABAAAAAPCAYAAADtc08vAAABGElEQVR4nJWRu0pDQRRFFxIDISrRQvADJKJgYxcsTKWFfyD5hVj6E1Y+PsHKKiIodil8gCja2knA0gcKFyWyLDKRy3VuMBs2zJyZvZhzBpXgqrql7thTEvYrqTt/3F/sqx/Glagn6kQeYFf9Vp/UltrOAR2rlRjAAKmGYlmtqdtqJwNpqZNZwLpazOlxPvKSa/VAXUjPYJAPc1r6UhuDghV1T71UP3Mg3bzwlHobLl2oJfUxE07U5Vh4Wr1RT+0NdDTUG6nwm1qPzWBGvbL3ZeXMWSkM71ld7dez4XP1yMh/B4+rs+laAdgAloA7oAasAa/E9R78qwIwBmwCD0A7gP6tEaADdIE54B54GRawCBSBM6AJ1IcB/ADDcl/CIOsnNwAAAABJRU5ErkJggg==", 16, 15},
                ["ZIRCON TRIDENT"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAICAYAAAC73qx6AAABG0lEQVR4nM2UsS5FQRCGvz3u2StUwhuISqH0BgrxAirvQELFO5B4A4ncXiWhVBGFUqsVHXEc51ecf282N/eIgjiTTHZ3/szszsz+EyTRI1kCRsA+cGfbBrAHDAEB79Yr4GTsKakvWkq6VysvkpYlbUp6U7fsJP+B84nAFrAIPAMXwKexmSmVa6yDKZiAGig7qv5hvzBhz23R+yNg1vFOgQKYM14Cl95XQdIhsA2sOFgNPHpNiURrDVR+DA4cadve0La8MhYyjAxrJrAiw1azxJ6AeWDB54cs4ZRIbd/zoqNqP5HvyPXXxAvW8T3BZO/L17oB1oBXr2fAOt1fa9fvrf6b4L9G9tSRvkgavwfArW1p/Eaf0/i9Bo6T4xdM44pWBHcfuQAAAABJRU5ErkJggg==", 50, 8},
                ["ZWEIHANDER"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAOCAYAAABth09nAAAA7ElEQVR4nM3UPUpDQRTF8Z8mRBQUrBKwiJDWHdi4DXtrV+HCbFxBasFSLRIRMX4gz+I9IYYRfXcmPP8wMHOGC+cwc+9GVVVaMsIZLtoWrpPNQM0YR6WN5BIJcofb0kZyiQa5L20kl0iQBa5LG8klEmSA44Q+yfSSRR8n2G/2sIUd7KHXrI/mbhcznKqn1xcHzXm+pD0u1f1EhYeE/ornhP6OJ7yof8Zc/c2nqRf5yyutzuzfDK+dPi5b1gxwiPMVfaLD3on0yBuuEnqnAyASZFvHjZ0iEmSEYWkjuUSCDH2fWP+CSJAbTAv7yOYTCAcjy7oQ9i0AAAAASUVORK5CYII=", 50, 14},
            }
        end

        for k, v in pairs(icons.registry) do
            icons.registry[k][1] = syn.crypt.base64.decode(v[1])
        end
    end)

    function icons:NameToIcon(name)
        return (self.registry[name] and self.registry[name] or nil)
    end
end

-- Menu
do
    -- Menu Instructions is reponsible for the setup and configuration of all menus
    local hook = BBOT.hook
    local gui = BBOT.gui
    local color = BBOT.color
    local math = BBOT.math
    local table = BBOT.table
    local timer = BBOT.timer
    local thread = BBOT.thread
    local draw = BBOT.draw
    local string = BBOT.string
    local log = BBOT.log
    local config = BBOT.config
    local userinputservice = BBOT.service:GetService("UserInputService")

    local menu = {}
    BBOT.menu = menu

    do
        local GUI = {}
        function GUI:Init()
            self.mouseinputs = false
        end
        function GUI:PerformLayout(pos, size)
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

        function GUI:SetMode(mode)
            self.mouse_mode = mode
            self:Destroy()
            self:SetupMouse()
            self:InvalidateLayout()
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
            local ishoverobj = gui:IsHoveringAnObject()
            if ishoverobj ~= self.ishoverobject then
                if ishoverobj then
                    self:SetTransparency(1)
                else
                    self:SetTransparency(0)
                end
                self.ishoverobject = ishoverobj
            end

            local objecthover = gui.hovering
            if objecthover ~= self.hoveractive and menu.tooltip then
                self.hoveractive = objecthover
                local tip = menu.tooltip
                if objecthover and objecthover.tooltip then
                    tip:SetEnabled(true)
                    tip:SetTip(objecthover.absolutepos.X, objecthover.absolutepos.Y + objecthover.absolutesize.Y + 4, objecthover.tooltip)
                    gui:TransparencyTo(tip, 1, 0.2, 0, 0.25)
                else
                    gui:TransparencyTo(tip, 0, 0.2, 0, 0.25, function()
                        tip:SetEnabled(false)
                    end)
                end
            end

            if ishoverobj then
                self.pos = UDim2.new(0, mouse.X, 0, mouse.Y)
                userinputservice.MouseIconEnabled = not self._enabled
                -- Calling calculate will call performlayout & calculate parented GUI objects
                self:Calculate()
            end
        end

        -- Register this as a generatable object
        gui:Register(GUI, "Mouse")
    end

    do
        local GUI = {}
        local camera = BBOT.service:GetService("CurrentCamera")
        
        function GUI:Init()
            self.mouseinputs = false
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 1, 0, 0)
            self.gradient:SetSize(1, -2, 0, 15)
            self.gradient:Generate()
            self.gradient:SetSize(1, -2, 1, 0)

            self.text = gui:Create("Text", self)
            self.text:SetPos(0, 9, .5, -1)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetText(" ")

            self.line = gui:Create("AstheticLine", self)
            self.line:SetPos(0, 1, 0, 1)
            self.line:SetSize(0, 2, 1, -2)
            self.line.left = true
            
            self:SetTransparency(0)
            self:SetZIndex(600000)
            self.content = "LOL"
        end

        function GUI:SetTip(x, y, text)
            self.content = text
            self.text:SetText(text)
            self.scalex, self.scaley = self.text:GetTextSize()
            if self.scalex > 200 then
                self.text:SetText(table.concat(string.WrapText(self.content, self.text.font, self.text.textsize, 250), "\n"))
            end
            self.scalex, self.scaley = self.text:GetTextSize()
            self:SetSize(0, self.scalex+8, 0, self.scaley+4)
            self:SetPos(0, x, 0, y)
            self:Calculate()
            local pos, size = self.absolutepos, self.absolutesize
            if pos.X + size.X > camera.ViewportSize.X then
                local diff = (pos.X + size.X)-(camera.ViewportSize.X-10)
                local x = size.X - diff
                self:SetPos(0, pos.X - x, 0, y)
            end
            if pos.Y + size.Y > camera.ViewportSize.Y then
                local diff = (pos.Y + size.Y)-(camera.ViewportSize.Y-10)
                local y = size.Y - diff
                self:SetPos(0, pos.X, 0, pos.Y-y)
            end
        end

        function GUI:PerformLayout(pos, size)
            self.background.Position = pos + Vector2.new(1, 1)
            self.background.Size = size - Vector2.new(2, 2)
            self.background_outline.Position = pos
            self.background_outline.Size = size
            self.background_border.Position = pos - Vector2.new(1, 1)
            self.background_border.Size = size + Vector2.new(2, 2)
        end

        gui:Register(GUI, "ToolTip")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.asthetic_line = self:Cache(draw:Box(0, 0, 0, 2, 0, gui:GetColor("Accent")))
            local hue, saturation, darkness = Color3.toHSV(gui:GetColor("Accent"))
            darkness = darkness / 2
            self.asthetic_line_dark = self:Cache(draw:Box(0, 0, 0, 1, 0, Color3.fromHSV(hue, saturation, darkness)))
            self.mouseinputs = false
        end

        function GUI:PerformLayout(pos, size)
            self.asthetic_line.Position = pos
            self.asthetic_line.Size = size
            if self.left then
                self.asthetic_line_dark.Position = pos + Vector2.new(size.X/2, 0)
                self.asthetic_line_dark.Size = Vector2.new(size.X/2, size.Y)
            else
                self.asthetic_line_dark.Position = pos + Vector2.new(0, size.Y/2)
                self.asthetic_line_dark.Size = Vector2.new(size.X, size.Y/2)
            end
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background_outline.Size = size + Vector2.new(2,2)
        end

        gui:Register(GUI, "AstheticLine")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.asthetic_line_alignment = "Top"
            self.asthetic_line = gui:Create("AstheticLine", self)
            self.asthetic_line:SetSize(1, 0, 0, 2)

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, 2)
            self.gradient:SetSize(1, 0, 0, 20)
            self.gradient:Generate()

            self.sizablearearight = self:Cache(draw:Box(0, 0, 2, 6, 0, gui:GetColor("Border"), nil, false))
            self.sizableareabottom = self:Cache(draw:Box(0, 0, 6, 2, 0, gui:GetColor("Border"), nil, false))

            self.draggable = false
            self.sizable = false
            self.mouseinputs = true
            self.autofocus = false

            self:Calculate()
        end
        
        function GUI:AstheticLineAlignment(alignment)
            self.asthetic_line_alignment = alignment
            if alignment == "Top" then
                self.asthetic_line:SetPos(0, 0, 0, 0)
            else
                self.asthetic_line:SetPos(0, 0, 1, -2)
            end
        end

        function GUI:ShowAstheticLine(value)
            self.gradient:SetPos(0, 0, 0, (value and 1 or 0))
            self.asthetic_line:SetTransparency((value and 1 or 0))
        end

        function GUI:ShowGradient(value)
            self.gradient:SetTransparency(value and 1 or 0)
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
            self.sizablearearight.Position = pos + size - Vector2.new(2, 6)
            self.sizableareabottom.Position = pos + size - Vector2.new(6, 2)
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
            if self.autofocus then
                self:SetFocused(true)
            end
        end

        function GUI:OnMouseExit(x, y)
            if self.autofocus then
                self:SetFocused(false)
            end
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

        function GUI:SetColor(startc, endc)
            self.color1 = startc
            self.color2 = endc
            local container = self.container
            for i=1, #container do
                local v = container[i]
                v.Color = color.range(i, {{start = 0, color = self.color1}, {start = self.absolutesize.Y-1, color = self.color2}})
            end
        end

        function GUI:Generate()
            if #self.container > 0 then
                self:Destroy()
            end
            for i = 0, self.absolutesize.Y-1 do
                local object = self:Cache(draw:Box(0, i, self.absolutesize.X, 1, 0, self.color1))
                object.Color = color.range(i, {{start = 0, color = self.color1}, {start = self.absolutesize.Y-1, color = self.color2}})
                self.container[#self.container+1] = object
            end
            self.rendersize = self.absolutesize.Y
            self:InvalidateLayout()
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
            self.text = self:Cache(draw:TextOutlined("", 2, 0, 0, 13, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)))
            self.content = ""
            self.textsize = 13
            self.font = 2
            self.mouseinputs = false

            self.textalignmentx = Enum.TextXAlignment.Left
            self.textalignmenty = Enum.TextYAlignment.Top
            self.offset = Vector2.new(0, 0)
        end

        function GUI:SetTextAlignmentX(align)
            self.textalignmentx = align
            self:InvalidateLayout()
        end

        function GUI:SetTextAlignmentY(align)
            self.textalignmenty = align
            self:InvalidateLayout()
        end

        function GUI:SetFont(font)
            self.text.Font = font
            self.font = font
            self:InvalidateLayout()
        end

        function GUI:GetText()
            return self.content
        end

        function GUI:SetColor(col)
            self.text.Color = col
        end

        function GUI:SetText(txt)
            self.text.Text = txt
            self.content = txt
            self:GetOffsets()
            self:InvalidateLayout()
        end

        function GUI:SetTextSize(size)
            self.text.Size = size
            self.textsize = size
            self:InvalidateLayout()
        end

        function GUI:GetOffsets()
            local offset_x, offset_y = 0, 0
            local w, h = self:GetTextSize(self.content)
            if self.textalignmentx == Enum.TextXAlignment.Center then
                local extra = self:GetTextScale()
                offset_x = (-w/2) + (extra/2)
            elseif self.textalignmentx == Enum.TextXAlignment.Right then
                offset_x = -w
            end

            if self.textalignmenty == Enum.TextYAlignment.Center then
                offset_y = -h/2
            elseif self.textalignmenty == Enum.TextYAlignment.Bottom then
                offset_y = -h
            end
            self.offset = Vector2.new(offset_x, offset_y)
        end

        function GUI:PerformLayout(pos, size)
            self.text.Position = pos + self.offset
            local x = self:GetTextSize(self.content)
            local pos = self:GetLocalTranslation()
            local size = self.parent.absolutesize
            local text = self.content
            if x + pos.X + self.offset.X - 4 >= size.X then
                text = ""
                for i=1, #self.content do
                    local v = string.sub(self.content, i, i)
                    local pretext = text .. v
                    local prex = self:GetTextSize(pretext)
                    if prex + pos.X + self.offset.X - 4 > size.X then
                        break 
                    end
                    text = pretext 
                end
            end
            self.text.Text = text
        end

        function GUI:GetTextSize(text)
            text = text or self.content
            local vec = gui:GetTextSize(text, self.font, self.textsize)
            local scale = gui:GetTextSize(" ", self.font, self.textsize)
            return vec.X + scale.X, vec.Y
        end

        function GUI:GetTextScale()
            local vec = gui:GetTextSize(" ", self.font, self.textsize)
            return vec.X, vec.Y
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


        local keyNames = { One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0", LeftBracket = "[", RightBracket = "]", Semicolon = ";", BackSlash = "\\", Slash = "/", Minus = "-", Equals = "=", Backquote = "`", Plus = "+", Multiplaye = "x", Comma = ",", Period = ".", }
        local keymodifiernames = { ["`"] = "~", ["1"] = "!", ["2"] = "@", ["3"] = "#", ["4"] = "$", ["5"] = "%", ["6"] = "^", ["7"] = "&", ["8"] = "*", ["9"] = "(", ["0"] = ")", ["-"] = "_", ["="] = "+", ["["] = "{", ["]"] = "}", ["\\"] = "|", [";"] = ":", ["'"] = '"', [","] = "<", ["."] = ".", ["/"] = "?", }

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            --[[self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 2, 0, 0)
            self.gradient:SetSize(1, -4, 0, 10)
            self.gradient:SetZIndex(0)
            self.gradient:Generate()]]
            self.whitelist = {}
            for i=string.byte('A'), string.byte('Z') do
                self.whitelist[string.char(i)] = true
            end
            for k, v in pairs(keyNames) do
                self.whitelist[k] = v
            end

            self.text = self:Cache(draw:TextOutlined("", 2, 3, 3, 16, false, Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)))
            self.content = ""
            self.content_position = 1 -- I like scrolling text
            self.textsize = 16
            self.font = 2

            self.cursor_outline = self:Cache(draw:BoxOutline(0, 0, 1, self.textsize, 4, gui:GetColor("Border")))
            self.cursor = self:Cache(draw:BoxOutline(0, 0, 1, self.textsize, 0, Color3.fromRGB(127, 72, 163), 0))
            self.cursor_position = 1

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
            local pos, size = self:GetLocalTranslation()
            local scalew = self:GetTextSize()
            if scalew >= size.X then
                local text = ""
                for i=position, #self.content do
                    local v = string.sub(self.content, i, i)
                    local pretext = text .. v
                    local prew = self:GetTextSize(pretext)
                    if prew > size.X then
                        return text, position
                    end
                    text = pretext 
                end
            end
            return string.sub(self.content, position), position
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
                    return offset + i - 1
                end
                pre = post
            end
            return offset + #text - 1
        end

        function GUI:PerformLayout(pos, size)
            local w, h = self:GetTextSize(self.content)
            self.text.Position = Vector2.new(pos.X+3,pos.Y - (h/2) + (size.Y/2))
            self.cursor.Size = Vector2.new(1,h)
            self.cursor_outline.Size = Vector2.new(1,h)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
            self:ProcessClipping()
        end

        function GUI:SetValue(value)
            self:SetText(value)
        end
        
        function GUI:OnValueChanged() end

        function GUI:SetEditable(bool)
            self.editable = bool
            if not bool then
                self.editing = nil
                self.text.Color = Color3.fromRGB(255, 255, 255)
                self.cursor.Transparency = 0
                self.cursor_outline.Transparency = 0
                self:Cache(self.cursor);self:Cache(self.cursor_outline);
            end
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
                if self.whitelist[key] ~= true then
                    key = self.whitelist[key]
                end
                if not inputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                    key = string.lower(key)
                elseif keymodifiernames[key] then
                    key = keymodifiernames[key]
                end
                ltext ..= key
                set = true
            end
            text = ltext .. rtext
            return text, set, ltext
        end

        function GUI:DetermineFittable()
            local w = self:GetTextScale()
            return math.round((self.absolutesize.X-18)/w)
        end

        function GUI:InputBegan(input)
            if not self.editable or not self._enabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.editing = true
                self.text.Color = Color3.fromRGB(127, 72, 163)
                self.cursor_position = self:DetermineTextCursorPosition(mouse.X - self.absolutepos.X)
            elseif self.editing then
                if input.UserInputType == Enum.UserInputType.MouseButton1 and (not self:IsHovering() or (input.UserInputType == Enum.UserInputType.Keyboard and input.UserInputType == Enum.KeyCode.Return)) then
                    self.editing = nil
                    self.text.Color = Color3.fromRGB(255, 255, 255)
                    self.cursor_outline.Transparency = 0
                    self.cursor.Transparency = 0
                    self:Cache(self.cursor);self:Cache(self.cursor_outline);
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
                            self:OnValueChanged(new_text)
                            self:SetText(new_text)
                            self.cursor_position = #ltext
                        end
                    end

                    local fittable = self:DetermineFittable()
                    if self.cursor_position < 4 then
                        self.content_position = 1
                    elseif self.cursor_position > self.content_position-1 + fittable then
                        self.content_position = self.cursor_position - fittable
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
                local wscale, hscale = self:GetTextScale()
                self.cursor.Transparency = math.sin(t * 8)
                self.cursor.Position = self.absolutepos + Vector2.new((self.cursor_position-(self.content_position-1))*wscale+6, -(hscale/2) + (self.absolutesize.Y/2))
                self.cursor_outline.Transparency = self.cursor.Transparency
                self.cursor_outline.Position = self.cursor.Position
                self:Cache(self.cursor);self:Cache(self.cursor_outline);
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
                                self:OnValueChanged(new_text)
                                self:SetText(new_text)
                                self.cursor_position = #ltext
                            end
                        end
                        local fittable = self:DetermineFittable()
                        if self.cursor_position < 4 then
                            self.content_position = 1
                        elseif self.cursor_position > self.content_position-1 + fittable then
                            self.content_position = self.cursor_position - fittable
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
            self.text = gui:Create("Text", self)
            self.text:SetTextAlignmentX(Enum.TextXAlignment.Left)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetPos(0, 0, .5, 0)
            self.mouseinput = true
        end

        function GUI:PerformLayout(pos, size)
        end

        function GUI:SetText(txt)
            self.text:SetText(txt)
        end

        function GUI:SetTextAlignmentX(txt)
            self.text:SetTextAlignmentX(txt)
        end

        function GUI:SetTextAlignmentY(txt)
            self.text:SetTextAlignmentY(txt)
        end

        function GUI:SetTextColor(col)
            self.text:SetColor(col)
        end

        function GUI:OnClick() end

        function GUI:InputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self:OnClick()
            end
        end

        gui:Register(GUI, "TextButton", "Text")

        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.options = {}
            self.buttons = {}
            self.Id = 0
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:SetOptions(options)
            for i=1, #self.buttons do
                local v = self.buttons[i]
                v:Remove()
            end
            local offset = 0
            self.options = options
            for i=1, #options do
                local v = options[i]
                local button = gui:Create("TextButton", self)
                self.buttons[#self.buttons+1] = button
                local _, scaley = button.text:GetTextSize(v)
                button:SetPos(0, 5, 0, 4 + (scaley+4) * (i-1))
                button:SetSize(1, -5, 0, scaley)
                offset = 4 + (scaley+4) * i
                button:SetText(v)
                function button.OnClick()
                    self.parent:SetOption(i)
                    self.parent:OnValueChanged(v)
                    self.parent:Close()
                end
            end

            self:SetSize(1, 0, 0, offset)
        end

        function GUI:IsHoverTotal()
            if self:IsHovering() then return true end
            local buttons = self.buttons
            for i=1, #buttons do
                if buttons[i]:IsHovering() then return true end
            end
        end

        function GUI:SetOption(Id)
            self.Id = Id
            local button = self.buttons[Id]
            if not button then return end
            button:SetTextColor(Color3.fromRGB(127, 72, 163))
        end

        gui:Register(GUI, "DropBoxSelection")

        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, -1)
            self.gradient:SetSize(1, 0, 0, 10)
            self.gradient:Generate()

            local text = gui:Create("Text", self)
            self.text = text
            text:SetPos(0, 6, .5, 0)
            text:SetTextAlignmentX(Enum.TextXAlignment.Left)
            text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            text:SetText("")

            local dropicon = gui:Create("Text", self)
            self.dropicon = dropicon
            dropicon:SetPos(1, -10, .5, 0)
            dropicon:SetTextAlignmentX(Enum.TextXAlignment.Center)
            dropicon:SetTextAlignmentY(Enum.TextYAlignment.Center)
            dropicon:SetText("-")
            self.mouseinputs = true

            self.Id = 0
            self.options = {}
            self.option = ""
        end

        function GUI:GetOption()
            return self.option, self.Id
        end

        function GUI:SetOption(num)
            local opt = self.options[num]
            if not opt then return end
            self.Id = num
            self.text:SetText(opt)
            self.option = opt
        end

        function GUI:SetValue(value)
            local num = 1
            for i=1, #self.options do
                if self.options[i] == value then
                    num = i
                    break
                end
            end
            self:SetOption(num)
        end

        function GUI:AddOption(txt)
            self.options[#self.options+1] = txt
        end

        function GUI:SetOptions(options)
            self.options = options
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:OnValueChanged(i)
            
        end

        function GUI:Open()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
            local box = gui:Create("DropBoxSelection", self)
            self.selection = box
            box:SetPos(0,0,1,1)
            box:SetOptions(self.options)
            box:SetOption(self.Id)
            box:SetZIndex(100)
            self.open = true
        end

        function GUI:Close()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
            self.open = false
        end

        function GUI:InputBegan(input)
            if not self._enabled then return end
            if not self.open and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self:Open()
            elseif self.open and (not self.selection or not self.selection:IsHoverTotal()) then
                self:Close()
            end
        end

        gui:Register(GUI, "DropBox")
    end

    do 

        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.options = {}
            self.buttons = {}
            self.Id = 0
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:SetOptions(options)
            for i=1, #self.buttons do
                local v = self.buttons[i]
                v:Remove()
            end
            local offset = 0
            self.options = options
            for i=1, #options do
                local v = options[i]
                local button = gui:Create("TextButton", self)
                self.buttons[#self.buttons+1] = button
                local _, scaley = button.text:GetTextSize(v[1])
                button:SetPos(0, 5, 0, 4 + (scaley+4) * (i-1))
                button:SetSize(1, -5, 0, scaley)
                offset = 4 + (scaley+4) * i
                button:SetText(v[1])
                button:SetTextColor(v[2] and Color3.fromRGB(127, 72, 163) or Color3.new(1,1,1))
                function button.OnClick()
                    self.parent:SetOption(i, not v[2])
                    button:SetTextColor(v[2] and Color3.fromRGB(127, 72, 163) or Color3.new(1,1,1))
                end
            end

            self:SetSize(1, 0, 0, offset)
        end

        function GUI:IsHoverTotal()
            if self:IsHovering() then return true end
            local buttons = self.buttons
            for i=1, #buttons do
                if buttons[i]:IsHovering() then return true end
            end
        end

        gui:Register(GUI, "ComboBoxSelection")

        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))
            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, -1)
            self.gradient:SetSize(1, 0, 0, 10)
            self.gradient:Generate()

            self.textcontainer = gui:Create("Container", self)

            local text = gui:Create("Text", self.textcontainer)
            self.text = text
            text:SetPos(0, 6, .5, 0)
            text:SetTextAlignmentX(Enum.TextXAlignment.Left)
            text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            text:SetText("")

            local dropicon = gui:Create("Text", self)
            self.dropicon = dropicon
            dropicon:SetPos(1, -2, .5, 0)
            dropicon:SetTextAlignmentX(Enum.TextXAlignment.Right)
            dropicon:SetTextAlignmentY(Enum.TextYAlignment.Center)
            dropicon:SetText("...")
            local w = dropicon:GetTextSize()
            self.textcontainer:SetSize(1, -w - 12, 1, 0)
            self.mouseinputs = true

            self.options = {}
        end

        function GUI:GetOptions()
            return self.option, self.Id
        end

        function GUI:Refresh()
            local options = self.options
            local text = ""
            local c = 0
            for i=1, #options do
                local v = options[i]
                if v[2] then
                    c = c + 1
                    text = text .. (c~=1 and ", " or "") .. v[1]
                end
            end
            self.text:SetText(text)
        end

        function GUI:SetOption(num, value)
            local opt = self.options[num]
            if not opt then return end
            opt[2] = value
            self:Refresh()
            self:OnValueChanged(self.options)
        end

        function GUI:SetOptions(options)
            self.options = options
            self:Refresh()
        end

        function GUI:SetValue(options)
            self:SetOptions(options)
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:OnValueChanged() end

        function GUI:Open()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
            local box = gui:Create("ComboBoxSelection", self)
            self.selection = box
            box:SetPos(0,0,1,1)
            box:SetOptions(self.options)
            box:SetZIndex(100)
            self.open = true
        end

        function GUI:Close()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
            self.open = false
        end

        function GUI:InputBegan(input)
            if not self._enabled then return end
            if not self.open and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self:Open()
            elseif self.open and (not self.selection or not self.selection:IsHoverTotal()) then
                self:Close()
            end
        end

        gui:Register(GUI, "ComboBox")
    end

    do
        local GUI = {}
        local icons = BBOT.icons

        function GUI:Init()
            self.image = self:Cache(draw:Image(nil, 0, 0, 0, 0))
            self.image_dimensions = Vector2.new(50,50)
            self.image_scale = 1
            self.mouseinputs = false
        end

        function GUI:SetImage(img)
            self.image.Data = img
            self:InvalidateLayout()
        end

        function GUI:PreserveDimensions(bool)
            self.preservedim = bool
            self:InvalidateLayout()
        end

        function GUI:SetIcon(icon)
            local ico = icons:NameToIcon(icon)
            if not ico then return end
            self.image_dimensions = Vector2.new(ico[2], ico[3])
            self:SetImage(ico[1])
        end

        function GUI:ScaleToFit(bool)
            self.scaletofit = bool
        end

        function GUI:SetScale(scale)
            self.image_scale = scale
            self:InvalidateLayout()
        end

        function GUI:PerformLayout(pos, size)
            if self.image and draw:IsValid(self.image) then
                if self.preservedim then
                    if self.scaletofit then
                        local scalex, scaley = 1, 1
                        if self.image_dimensions.X < size.X then
                            scalex = size.X/self.image_dimensions.X
                        end
                        if self.image_dimensions.Y < size.Y then
                            scaley = size.Y/self.image_dimensions.Y
                        end
                        if scalex > scaley then
                            scalex = scaley
                        end
                        if scaley > scalex then
                            scaley = scalex
                        end
                        self.image.Size = self.image_dimensions * self.image_scale * Vector2.new(scalex, scaley)
                    else
                        self.image.Size = self.image_dimensions * self.image_scale
                    end
                    self.image.Position = pos - (self.image.Size/2) + size/2
                else
                    self.image.Position = pos
                    self.image.Size = size * self.image_scale
                end
            end
        end

        gui:Register(GUI, "Image")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.mouseinputs = true
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, 0)
            self.gradient:SetSize(1, 0, 0, 20)
            self.gradient:SetZIndex(0)
            self.gradient:Generate()

            self.text = gui:Create("Text", self)
            self.text:SetPos(.5, 0, .5, 0)
            self.text:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetText("")
            self.text:SetTextSize(13)

            local darken = gui:Create("Container", self)
            darken:SetPos(0,0,0,0)
            darken:SetSize(1,0,1,2)
            darken.background = darken:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background"), nil, false))
            function darken:PerformLayout(pos, size)
                self.background.Position = pos
                self.background.Size = size
            end
            darken.background.Visible = true
            darken.background.Transparency = 1
            darken.background.ZIndex = 0
            darken.background.Color = Color3.new(0,0,0)
            darken:Cache(darken.background)
            darken:SetTransparency(.25)
            self.darken = darken
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size + (self.activated and Vector2.new(0,4) or Vector2.new())
        end

        function GUI:SetActive(value)
            self.activated = value
            gui:TransparencyTo(self.darken, (value and 0 or .25), 0.2, 0, 0.25)
            self:InvalidateLayout()
        end

        function GUI:SetIcon(icon)
            if not icon then return end
            if not self.icon then
                self.icon = gui:Create("Image", self)
                self.icon:SetSize(1, 0, 1, 0)
                self.text:SetTransparency(0)
            end
            self.icon:PreserveDimensions(true)
            self.icon:ScaleToFit(true)
            self.icon:SetScale(0.75)
            self.icon:SetIcon(icon)
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
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            local container = gui:Create("Container", self)
            container:SetPos(0,8,0,36+8)
            container:SetSize(1,-16,1,-36-16)
            self.container = container

            local tablist = gui:Create("Container", self)
            tablist:SetPos(0,0,0,2)
            tablist:SetSize(1,0,0,36-2)
            self.tablist = tablist

            local background = gui:Create("Container", tablist)
            background:SetPos(0,0,0,0)
            background:SetSize(1,0,1,-1)
            background:SetZIndex(0)
            background.background = background:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background"), nil, false))
            function background:PerformLayout(pos, size)
                self.background.Position = pos
                self.background.Size = size
            end
            background.background.Visible = true
            background.background.Transparency = .25
            background.background.ZIndex = 0
            background.background.Color = Color3.new(0,0,0)
            background:Cache(background.background)

            local line = gui:Create("Container", tablist)
            line:SetPos(0,0,1,-2)
            line:SetSize(1,0,0,2)
            line.background = line:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background"), nil, false))
            function line:PerformLayout(pos, size)
                self.background.Position = pos
                self.background.Size = size
            end
            line.background.Visible = true
            line.background.Color = gui:GetColor("Border")
            line.background.Transparency = 1
            line.background.ZIndex = 0
            line:Cache(line.background)
            self.line = line

            local astheticline = gui:Create("AstheticLine", self)
            astheticline:SetPos(0,0,0,0)
            astheticline:SetSize(1, 0, 0, 2)
            astheticline:SetZIndex(2)

            self.registry = {}
            self.activeId = 0
        end

        function GUI:SetTopBarMargin(margin)
            self.container:SetPos(0,8,0,margin+8)
            self.container:SetSize(1,-16,1,-margin-16)
            self.tablist:SetPos(0,0,0,2)
            self.tablist:SetSize(1,0,0,margin-2)
        end
    
        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:GetActive()
            return self.registry[self.activeId]
        end

        function GUI:SizeByContent(bool)
            self.scalebycontent = bool
            self:CalculateTabs()
        end

        function GUI:SetActive(num)
            if self.activeId == num then return end
            local new = self.registry[num]
            if not new then return end
            local active = self:GetActive()
            if active then
                active[1]:SetActive(false)
                local pnl = active[2]
                gui:TransparencyTo(active[2], 0, 0.2, 0, 0.25, function()
                    pnl:SetEnabled(false)
                end)
            end
            new[1]:SetActive(true)
            new[2]:SetEnabled(true)
            new[2]:InvalidateLayout(true, true)
            gui:TransparencyTo(new[2], 1, 0.2, 0, 0.25)
            self.activeId = num
        end

        function GUI:CalculateTabs()
            local r = self.registry
            local l = #r
            local x = 0
            for i=1, l do
                local v = r[i]
                if self.scalebycontent then
                    local sizex = v[1].text:GetTextSize() + 6
                    v[1]:SetSize(0,sizex,1,-2)
                    v[1]:SetPos(0,x,0,0)
                    x += sizex
                else
                    v[1]:SetSize(1/l,0,1,-2)
                    v[1]:SetPos((1/l)*(i-1),0,0,0)
                end
            end
        end

        function GUI:Add(name, icon, object)
            object:SetParent(self.container)
            object:SetTransparency(0)
            object:SetEnabled(false)
            local tab = gui:Create("Tab", self.tablist)
            local r = self.registry
            tab.Id = #r+1
            tab.controller = self
            tab:SetText(name)
            tab:SetPanel(object)
            tab:SetIcon(icon)
            r[#r+1] = {tab, object}
            self:CalculateTabs()
            if tab.Id == 1 then
                self:SetActive(tab.Id)
            end
            return tab
        end

        gui:Register(GUI, "Tabs")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, -1)
            self.gradient:SetSize(1, 0, 0, 15)
            self.gradient:Generate()

            self.text = gui:Create("Text", self)
            self.text:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetPos(.5, 0, .5, -1)

            self.confirmation = false
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:SetText(txt)
            self.content = txt
            self.text:SetText(txt)
        end

        function GUI:SetConfirmation(txt)
            self.confirmation = txt
        end

        function GUI:OnClick() end

        function GUI:InputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                if self.confirmation and not self.confirm then
                    self.confirm = true
                    self.text:SetText(self.confirmation)
                    self.text:SetColor(gui:GetColor("Accent"))
                    timer:Simple(1, function()
                        if not gui:IsValid(self) then return end
                        self.text:SetText(self.content)
                        self.text:SetColor(Color3.new(1,1,1))
                        self.confirm = nil
                    end)
                elseif (not self.confirmation or (self.confirmation and self.confirm)) then
                    self:OnClick()
                end
            end
        end

        gui:Register(GUI, "Button")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.button = gui:Create("Button", self)
            self.button:SetSizeConstraint("Y")
            self.button:SetSize(1,0,1,0)
            self.button.gradient:SetPos(0, 0, 0, -1)
            self.button.gradient:SetSize(1, 0, 0, 8)
            self.button.gradient:Generate()
            self.button.mouseinputs = false

            self.text = gui:Create("Text", self)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetPos(0, 0, .5, 0)
            self.text:SetTextSize(13)

            self.toggle = false
            local col = Color3.fromRGB(127, 72, 163)
            self.on = {col, color.darkness(col, .5)}
            self.off = {self.button.gradient.color1, self.button.gradient.color2}
        end

        function GUI:SetText(txt)
            self.text:SetText(txt)
            self:InvalidateLayout()
        end
        
        function GUI:PerformLayout(pos, size)
            self.text:SetPos(0, self.button.absolutesize.X + 7, .5, -1)
        end

        function GUI:OnClick()
            self.toggle = not self.toggle
            local colors = self.off
            if self.toggle then
                colors = self.on
            end
            self.button.gradient:SetColor(unpack(colors))
            self:OnValueChanged(self.toggle)
        end

        function GUI:InputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self:OnClick()
            end
        end

        function GUI:SetValue(value)
            self.toggle = value
            local colors = self.off
            if self.toggle then
                colors = self.on
            end
            self.button.gradient:SetColor(unpack(colors))
        end

        function GUI:OnValueChanged() end

        gui:Register(GUI, "Toggle")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))

            self.text = gui:Create("Text", self)
            self.text:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetPos(.5, 0, .5, 0)
            self.text:SetTextSize(13)
            self.text:SetText("None")

            self.key = nil
            self.value = false
            self.toggletype = 1
            self.config = {}
        end
        
        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:InputBegan(input)
            if not self.editting and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.editting = true
                self.text:SetText("...")
            elseif self.editting and input.UserInputType == Enum.UserInputType.MouseButton1 and not self:IsHovering() then
                self.editting = false
                self.key = nil
                self:OnValueChanged(nil)
                self.text:SetText((self.key and (config.enums.KeyCode.inverseId[self.key] or "Unk") or "None"))
            elseif self.editting and input.UserInputType == Enum.UserInputType.Keyboard then
                self.editting = false
                self.key = input.KeyCode
                self.value = false
                local name = config.enums.KeyCode.inverseId[self.key]
                self.text:SetText(name)
                self:OnValueChanged(name)
            end
        end

        function GUI:SetValue(key)
            if key == nil then
                self.key = nil
                self.text:SetText("None")
                return
            end
            local name = key
            key = config.enums.KeyCode.Id[key]
            self.key = key
            self.text:SetText(name)
        end

        function GUI:OnValueChanged() end

        hook:Add("InputBegan", "BBOT:Menu.KeyBinds", function(input)
            --if not config:GetValue("Main", "Visuals", "Keybinds", "Enabled") then return end
            if not menu.main or userinputservice:GetFocusedTextBox() or menu.main:GetEnabled() then
                return
            end
            local guis = gui.registry
            for i=1, #guis do
                local v = guis[i]
                if gui:IsValid(v) and v.class == "KeyBind" then
                    local last = v.value
                    if input.KeyCode == v.key then
                        if v.toggletype == 2 then
                            v.value = not v.value
                        elseif v.toggletype == 1 then
                            v.value = true
                        elseif v.toggletype == 3 then
                            v.value = false
                        end
                    elseif v.toggletype == 4 then
                        v.value = true
                    end
                    if last ~= v.value then
                        config:GetRaw(unpack(v.config)).toggle = v.value
                        hook:Call("OnKeyBindChanged", v.config, last, v.value)
                    end
                end
            end
        end)

        hook:Add("InputEnded", "BBOT:Menu.KeyBinds", function(input)
            --if not config:GetValue("Main", "Visuals", "Keybinds", "Enabled") then return end
            if not menu.main or userinputservice:GetFocusedTextBox() or menu.main:GetEnabled() then
                return
            end
            local guis = gui.registry
            for i=1, #guis do
                local v = guis[i]
                if gui:IsValid(v) and v.class == "KeyBind" then
                    local last = v.value
                    if input.KeyCode == v.key then
                        if v.toggletype == 1 then
                            v.value = false
                        elseif v.toggletype == 3 then
                            v.value = true
                        end
                    end
                    if last ~= v.value then
                        config:GetRaw(unpack(v.config)).toggle = v.value
                        hook:Call("OnKeyBindChanged", v.config, last, v.value)
                    end
                end
            end
        end)

        --[[local ignorenotify = false
        hook:Add("OnConfigChanged", "BBOT:Menu.KeyBinds.Reset", function(step, old, new)
            if config:IsPathwayEqual(step, "Main", "Visuals", "Keybinds", "Enabled") then
                if new == false then
                    local guis = gui.registry
                    for i=1, #guis do
                        local v = guis[i]
                        if gui:IsValid(v) and v.class == "KeyBind" then
                            if v.value ~= true then
                                config:GetRaw(unpack(v.config)).toggle = true
                                ignorenotify = true
                                hook:Call("OnKeyBindChanged", v.config, v.value, true)
                                ignorenotify = false
                                v.value = true
                            end
                        end
                    end
                else
                    local guis = gui.registry
                    for i=1, #guis do
                        local v = guis[i]
                        if gui:IsValid(v) and v.class == "KeyBind" then
                            if v.value ~= false then
                                config:GetRaw(unpack(v.config)).toggle = false
                                ignorenotify = true
                                hook:Call("OnKeyBindChanged", v.config, last, false)
                                ignorenotify = false
                                v.value = false
                            end
                        end
                    end
                end
            end
        end)]]

        hook:Add("OnKeyBindChanged", "BBOT:Notify", function(steps, old, new)
            if ignorenotify then return end
            if config:GetValue("Main", "Visuals", "Keybinds", "Log Keybinds") then
                local name = steps[#steps]
                if name == "KeyBind" then
                    name = steps[#steps-1]
                end
                BBOT.notification:Create(name .. " has been " .. (new and "enabled" or "disabled"))
            end
        end)

        gui:Register(GUI, "KeyBind")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))
            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, -1)
            self.gradient:SetSize(0, 0, 0, 10)
            self.gradient:Generate()
            local col = Color3.fromRGB(127, 72, 163)
            self.basecolor = {col, color.darkness(col, .5)}
            self.gradient:SetColor(unpack(self.basecolor))
            self.percentage = 0
        end

        function GUI:SetPercentage(perc)
            self.percentage = perc
            self:InvalidateLayout()
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
            self.gradient:SetSize(self.percentage, 0, 0, 8)
        end

        gui:Register(GUI, "ProgressBar")
    end

    do
        local GUI = {}

        local userinputservice = BBOT.service:GetService("UserInputService")

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline-Light")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 0, 0, -1)
            self.gradient:SetSize(1, 0, 0, 10)
            self.gradient:Generate()

            self.bar = gui:Create("Gradient", self)
            self.bar:SetPos(0, 0, 0, -1)
            local col = Color3.fromRGB(127, 72, 163)
            self.basecolor = {col, color.darkness(col, .5)}
            self.bar:SetColor(unpack(self.basecolor))
            self.percentage = math.random(0,1000)/1000
            self.bar:SetSize(self.percentage, 0, 0, 10)
            self.bar:Generate()

            self.buttoncontainer = gui:Create("Container", self)

            local onhover = Color3.fromRGB(127, 72, 163)
            local idle = Color3.new(1,1,1)

            self.add = gui:Create("TextButton", self.buttoncontainer)
            self.add:SetText("+")
            self.add:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.add:SetTextAlignmentY(Enum.TextYAlignment.Bottom)
            local w, h = self.add.text:GetTextSize()
            self.add:SetPos(1, -w + 2, 0, 0)
            self.add:SetSize(0, w, 0, h)
            self.add.text:SetPos(0.25, 0, .5, 0)
            
            function self.add.OnClick()
                local value = 1
                if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                    value = value / (10^self.decimal)
                end
                self:_SetValue(self:GetValue()+value)
            end

            function self.add:Step()
                local hover = (self:IsHovering())
                if hover ~= self.hover then
                    self.hover = hover
                    if hover then
                        self:SetTextColor(onhover)
                    else
                        self:SetTextColor(idle)
                    end
                end
            end

            self.deduct = gui:Create("TextButton", self.buttoncontainer)
            self.deduct:SetText("-")
            self.deduct:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.deduct:SetTextAlignmentY(Enum.TextYAlignment.Bottom)
            local ww, hh = self.deduct.text:GetTextSize()
            self.deduct:SetPos(1, -w -ww + 2, 0, 0)
            self.deduct:SetSize(0, w, 0, h)
            self.deduct.text:SetPos(0.25, 0, .5, 0)
            self.deduct.Step = self.add.Step
            function self.deduct.OnClick()
                local value = 1
                if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                    value = value / (10^self.decimal)
                end
                self:_SetValue(self:GetValue()-value)
            end
            self.buttoncontainer.add = self.add
            self.buttoncontainer.deduct = self.deduct

            self.buttoncontainer:SetSize(0, w + ww, 0, h + 2)
            self.buttoncontainer:SetPos(1, -(w + ww), 0, - (h + 3))
            self.buttoncontainer:SetTransparency(0)

            function self.buttoncontainer:Step()
                local hover = (self:IsHovering() or self.add:IsHovering() or self.deduct:IsHovering())
                if hover ~= self.hover then
                    self.hover = hover
                    if hover then
                        gui:TransparencyTo(self, 1, 0.2, 0, 0.25)
                    else
                        gui:TransparencyTo(self, 0, 0.2, 0, 0.25)
                    end
                end
            end

            self.text = gui:Create("Text", self)
            self.text:SetTextAlignmentX(Enum.TextXAlignment.Center)
            self.text:SetTextAlignmentY(Enum.TextYAlignment.Center)
            self.text:SetPos(.5,0,.5,0)
            self.text:SetText("0%")

            self.suffix = "%"
            self.min = 0
            self.max = 100
            self.decimal = 1
            self.custom = {}
            self.mouseinputs = true

            self:SetPercentage(self.percentage)
        end

        function GUI:SetPercentage(perc)
            self.percentage = perc
            local value = math.round(math.remap(perc, 0, 1, self.min, self.max), self.decimal)
            if self.custom[value] then
                self.text:SetText(self.custom[value])
            else
                self.text:SetText(value .. self.suffix)
            end
            self.bar:SetSize(self.percentage, 0, 1, 0)
        end

        function GUI:_SetValue(value)
            self:SetPercentage(math.remap(math.clamp(value, self.min, self.max), self.min, self.max, 0, 1))
            self:OnValueChanged(self:GetValue())
        end

        function GUI:GetValue()
            return math.round(math.remap(self.percentage, 0, 1, self.min, self.max), self.decimal)
        end

        function GUI:PerformLayout(pos, size)
            self.background_border.Position = pos - Vector2.new(2,2)
            self.background_outline.Position = pos - Vector2.new(1,1)
            self.background.Position = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end

        function GUI:CalculateValue(X)
            local APX = self.absolutepos.X
            local ASX = self.absolutesize.X
            local position = math.clamp(X, APX, APX + ASX )
            local last = self:GetValue()
            self:SetPercentage((position - APX)/ASX)
            local new = self:GetValue()
            if last ~= new then
                self:OnValueChanged(new)
            end
        end

        local mouse = BBOT.service:GetService("Mouse")
        function GUI:Step()
            if self.down then
                self:CalculateValue(mouse.X)
            end
        end

        function GUI:InputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self.down = true
            end
        end

        function GUI:InputEnded(input)
            if self.down and input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.down = false
            end
        end

        function GUI:SetValue(value)
            self:SetPercentage(math.remap(math.clamp(value, self.min, self.max), self.min, self.max, 0, 1))
        end

        function GUI:OnValueChanged() end

        gui:Register(GUI, "Slider")
    end

    do
        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Outline")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))

            self.gradient = gui:Create("Gradient", self)
            self.gradient:SetPos(0, 2, 0, 2)
            self.gradient:SetSize(1, -4, 0, 20)
            self.gradient:Generate()

            local title = gui:Create("Text", self)
            self.title = title
            title:SetPos(0, 5, 0, 5)
            title:SetText("")

            self:SetTransparency(0)
            gui:TransparencyTo(self, 1, 0.2, 0, 0.25)
        end

        function GUI:PerformLayout(pos, size)
            self.background.Position = pos + Vector2.new(2, 2)
            self.background.Size = size - Vector2.new(4, 4)
            self.background_outline.Position = pos
            self.background_outline.Size = size
            self.background_border.Position = pos - Vector2.new(1, 1)
            self.background_border.Size = size + Vector2.new(2, 2)
        end

        function GUI:Close()
            gui:TransparencyTo(self, 0, 0.2, 0, 0.25, function()
                self:Remove()
            end)
        end

        function GUI:SetTitle(txt)
            self.title:SetText(txt)
        end

        function GUI:SetColor() end

        function GUI:IsHoverTotal()
            if self:IsHovering() then return true end
            local buttons = self.buttons
            for i=1, #buttons do
                if buttons[i]:IsHovering() then return true end
            end
        end

        gui:Register(GUI, "ColorPickerChange")

        local GUI = {}

        function GUI:Init()
            self.background_border = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background_outline = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
            self.background = self:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Background")))
        end

        function GUI:PerformLayout(pos, size)
            self.background.Position = pos + Vector2.new(2, 2)
            self.background.Size = size - Vector2.new(4, 4)
            self.background_outline.Position = pos
            self.background_outline.Size = size
            self.background_border.Position = pos - Vector2.new(1, 1)
            self.background_border.Size = size + Vector2.new(2, 2)
        end

        function GUI:SetColor(col)
            self.background.Color = col
            self.background_outline.Color = color.darkness(col, .5)
        end

        function GUI:SetTitle(txt)
            self.title = txt
        end

        function GUI:Open()
            if self.selection then
                self.selection:Remove()
                self.selection = nil
            end
            local picker = gui:Create("ColorPickerChange", self)
            self.picker = picker
            picker:SetPos(.5,0,.5,0)
            picker:SetSize(0, 280, 0, 211)
            picker:SetColor(self.background.Color)
            picker:SetTitle(self.title)
            picker:SetZIndex(100)
            self.open = true
        end

        function GUI:Close()
            if self.picker then
                self.picker:Close()
                self.picker = nil
            end
            self.open = false
        end

        function GUI:InputBegan(input)
            if not self._enabled then return end
            if not self.open and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
                self:Open()
            elseif self.open and (not self.picker or not gui:IsHovering(self.picker)) then
                self:Close()
            end
        end

        function GUI:SetValue(col)
            self:SetColor(col)
        end

        function GUI:OnValueChanged() end

        gui:Register(GUI, "ColorPicker", "Button")
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

    menu.config_pathways = {}

    hook:Add("OnConfigChanged", "BBOT:Menu.UpdateConfiguration", function(path, old, new)
        if menu._config_changed then return end
        local path = table.concat(path, ".")
        local pathways = menu.config_pathways
        if pathways[path] and pathways[path].SetValue then
            pathways[path]:SetValue(new)
        end
    end)

    function menu:ConfigSetValue(new, path)
        menu._config_changed = true
        config:SetValue(new, unpack(path))
        menu._config_changed = false
    end

    local _config_module = config

    function menu:CreateExtra(container, config, path, X, Y)
        local name = (config.name or config.type)
        local Id = (config.Id or config.name or config.type)
        local type = config.type
        local path = table.deepcopy(path)
        path[#path+1] = Id
        local uid = table.concat(path, ".")
        if type == "ColorPicker" then
            local picker = gui:Create("ColorPicker", container)
            picker:SetPos(1, X-26, 0, Y)
            picker:SetSize(0, 26, 0, 10)
            picker:SetTitle(name)
            picker:SetValue(_config_module:GetValue(unpack(path)))
            picker.tooltip = config.tooltip
            function picker:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = picker
            return 25 + 9
        elseif type == "KeyBind" then
            local keybind = gui:Create("KeyBind", container)
            keybind:SetPos(1, X-32, 0, Y-2)
            keybind:SetSize(0, 32, 0, 14)
            keybind:SetValue(_config_module:GetRaw(unpack(path)).value)
            keybind.value = false
            keybind.toggletype = config.toggletype
            keybind.config = path
            keybind.tooltip = config.tooltip
            function keybind:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = keybind
            return 31 + 9
        end
        return 0
    end

    function menu:CreateOptions(container, config, path, Y)
        local name = config.name
        local Id = (config.Id or config.name)
        local type = config.type
        local uid = table.concat(path, ".")

        local X = 0
        if config.extra then
            local extra = config.extra
            for i=1, #extra do
                X = X - self:CreateExtra(container, extra[i], path, X, Y)
            end
        end
        if type == "Toggle" then
            local toggle = gui:Create("Toggle", container)
            toggle:SetPos(0, 0, 0, Y)
            toggle:SetSize(1, -X, 0, 8)
            toggle:SetText(name)
            local w = toggle.text:GetTextSize()
            toggle:SetSize(0, 14 + w, 0, 8)
            toggle:InvalidateLayout(true)
            toggle:SetValue(_config_module:GetValue(unpack(path)))
            toggle.tooltip = config.tooltip
            function toggle:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = toggle
            return 8+7
        elseif type == "Slider" then
            local cont = gui:Create("Container", container)
            local text = gui:Create("Text", cont)
            text:SetPos(0, 0, 0, 0)
            text:SetTextSize(13)
            text:SetText(name)
            local slider = gui:Create("Slider", cont)
            slider.suffix = config.suffix or slider.suffix
            slider.min = config.min or slider.min
            slider.max = config.max or slider.max
            slider.decimal = config.decimal or slider.decimal
            slider.custom = config.custom or slider.custom
            slider:SetValue(_config_module:GetValue(unpack(path)))
            local _, tall = text:GetTextScale()
            slider:SetPos(0, 0, 0, tall+3)
            slider:SetSize(1, 0, 0, 10)
            slider.tooltip = config.tooltip
            cont:SetPos(0, 0, 0, Y-2)
            cont:SetSize(1, 0, 0, tall+2+10+1)
            function slider:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = slider
            return tall+2+10+5
        elseif type == "Text" then
            local cont = gui:Create("Container", container)
            local text = gui:Create("Text", cont)
            text:SetPos(0, 0, 0, 0)
            text:SetTextSize(13)
            text:SetText(name)
            local textentry = gui:Create("TextEntry", cont)
            local _, tall = text:GetTextScale()
            textentry:SetPos(0, 0, 0, tall+4)
            textentry:SetSize(1, 0, 0, 16)
            textentry:SetValue(_config_module:GetValue(unpack(path)))
            textentry:SetTextSize(13)
            textentry.tooltip = config.tooltip
            cont:SetPos(0, 0, 0, Y-2)
            cont:SetSize(1, 0, 0, tall+4+16)
            function textentry:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = textentry
            return tall+4+16+4
        elseif type == "DropBox" then
            local cont = gui:Create("Container", container)
            local text = gui:Create("Text", cont)
            text:SetPos(0, 0, 0, 0)
            text:SetTextSize(13)
            text:SetText(name)
            local dropbox = gui:Create("DropBox", cont)
            local _, tall = text:GetTextScale()
            dropbox:SetPos(0, 0, 0, tall+4)
            dropbox:SetSize(1, 0, 0, 16)
            dropbox:SetOptions(config.values)
            dropbox:SetValue(_config_module:GetValue(unpack(path)))
            dropbox.tooltip = config.tooltip
            cont:SetPos(0, 0, 0, Y-2)
            cont:SetSize(1, 0, 0, tall+4+16)
            function dropbox:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = dropbox
            return 16+4+16+2
        elseif type == "ComboBox" then
            local cont = gui:Create("Container", container)
            local text = gui:Create("Text", cont)
            text:SetPos(0, 0, 0, 0)
            text:SetTextSize(13)
            text:SetText(name)
            local dropbox = gui:Create("ComboBox", cont)
            local _, tall = text:GetTextScale()
            dropbox:SetPos(0, 0, 0, tall+4)
            dropbox:SetSize(1, 0, 0, 16)
            dropbox:SetValue(_config_module:GetRaw(unpack(path)).value)
            dropbox.tooltip = config.tooltip
            cont:SetPos(0, 0, 0, Y-2)
            cont:SetSize(1, 0, 0, tall+4+16)
            function dropbox:OnValueChanged(new)
                menu:ConfigSetValue(new, path)
            end
            self.config_pathways[uid] = dropbox
            return 16+4+16+2
        elseif type == "Button" then
            local button = gui:Create("Button", container)
            button:SetPos(0, 0, 0, Y)
            button:SetSize(1, -X, 0, 16)
            button:SetText(name)
            button:SetConfirmation(config.confirm)
            button.OnClick = config.callback
            button.tooltip = config.tooltip
            return 16+7
        end
        return 0
    end

    do
        function menu:HandleGeneration(container, path, configuration)
            local Y = 0
            for i=1, #configuration do
                local config = configuration[i]
                local type = config.type
                local name = (config.name or config.type)
                local Id = (config.Id or config.name or config.type)
                local path = table.deepcopy(path)
                if typeof(Id) == "string" then
                    path[#path+1] = Id
                end
                local subcontainer
                if type == "Tabs" or typeof(name) == "table" then
                    local istable = typeof(name) == "table"
                    local nums = (istable and #name or 1)
                    local frame = gui:Create("Tabs")
                    if istable then
                        frame:SetTopBarMargin(25)
                        frame:SizeByContent(true)
                    end
                    if typeof(container) == "function" then
                        container(config, frame)
                    else
                        frame:SetParent(container)
                    end
                    frame.Name = name
                    if config.pos then
                        frame:SetPos(config.pos)
                    end
                    if config.size then
                        frame:SetSize(config.size)
                    end
                    subcontainer = function(config, panel)
                        frame:Add(config.name, config.icon, panel)
                    end
                    if istable then
                        for i=1, nums do
                            local subconfig = config[i]
                            local name = name[i]
                            if subconfig.content and subcontainer then
                                subconfig.name = name
                                subconfig.type = "Container"
                                subconfig.pos = UDim2.new(0,0,0,0)
                                subconfig.size = UDim2.new(1,0,1,0)
                            end
                        end
                        self:HandleGeneration(subcontainer, path, config)
                        subcontainer = nil
                    end
                elseif type == "Container" then
                    local frame = gui:Create("Container")
                    if typeof(container) == "function" then
                        container(config, frame)
                    else
                        frame:SetParent(container)
                    end
                    frame.Name = name
                    if config.pos then
                        frame:SetPos(config.pos)
                    end
                    if config.size then
                        frame:SetSize(config.size)
                    end
                    subcontainer = frame
                elseif type == "Panel" then
                    local frame = gui:Create("Panel")
                    if typeof(container) == "function" then
                        container(config, frame)
                    else
                        frame:SetParent(container)
                    end
                    frame.Name = name
                    if config.pos then
                        frame:SetPos(config.pos)
                    end
                    if config.size then
                        frame:SetSize(config.size)
                    end
                    local alias = gui:Create("Text", frame)
                    frame.alias = alias
                    alias:SetPos(0, 3, 0, 4)
                    alias:SetText(name)
                    alias:SetTextSize(13)

                    subcontainer = gui:Create("Container", frame)
                    frame.subcontainer = subcontainer
                    subcontainer:SetPos(0, 8, 0, 23)
                    subcontainer:SetSize(1, -16, 1, -23)
                end
                if typeof(Id) == "string" then
                    Y = Y + self:CreateOptions(container, config, path, Y)
                end
                if config.content and subcontainer then
                    self:HandleGeneration(subcontainer, path, config.content)
                end
            end
        end
    end

    function menu:Initialize()
        self.tooltip = gui:Create("ToolTip")
        self.tooltip:SetTip(0,0,"LOL")
        self.tooltip:SetEnabled(false)
        self.tooltip:SetTransparency(0)

        local intro = gui:Create("Panel")
        intro:SetSize(0, 0, 0, 0)
        intro:Center()

        do
            self.fw, self.fh = 100, 100

            local screensize = camera.ViewportSize
            local image = gui:Create("Image", intro)
            image:SetImage(self.images[7])
            image:SetPos(0, 0, 0, 2)
            image:SetSize(1, 0, 1, -2)

            local drawquad = image:Cache(draw:Quad({0,0},{0,0},{0,0},{0,0},Color3.new(1,1,1),3,.75))

            local function isvectorequal(a, b)
                return (a.X == b.X and a.Y == b.Y)
            end

            gui:SizeTo(intro, UDim2.new(0, self.fw, 0, self.fh), 0.775, 0, 0.25, function()
                local start = tick()
                function image:Step()
                    local fraction = math.timefraction(start, start+.45, tick())
                    local size = self.absolutesize
                    local x, y = 0, 0
                    x = size.X * fraction * 2
                    y = size.Y * fraction * 2
                    local xx = math.max(0, x - 13)
                    local yy = math.max(0, y - 13)
                    drawquad.PointB = (xx > size.X and (yy-size.Y > size.Y and size or Vector2.new(size.X, yy-size.Y)) or Vector2.new(xx, 0)) + self.absolutepos
                    drawquad.PointA = (x > size.X and (y-size.Y > size.Y and size or Vector2.new(size.X, y-size.Y)) or Vector2.new(x, 0)) + self.absolutepos
                    drawquad.PointC = (yy > size.Y and (xx-size.X > size.X and size or Vector2.new(xx-size.X, size.Y)) or Vector2.new(0, yy)) + self.absolutepos
                    drawquad.PointD = (y > size.Y and (x-size.X > size.X and size or Vector2.new(x-size.X, size.Y)) or Vector2.new(0, y)) + self.absolutepos
                    if (xx > size.X and yy-size.Y > size.Y) and (x > size.X and y-size.Y > size.Y) and (yy > size.Y and xx-size.X > size.X) and (y > size.Y and x-size.X > size.X) then
                        drawquad:Remove()
                        image.Step = nil
                    end
                end

                gui:SizeTo(intro, UDim2.new(0, 0, 0, 0), 0.775, .6, 0.25, function()
                    image:Remove()
                    intro:Remove()
                    hook:Call("Menu.PreGenerate")
                    hook:Call("Menu.Generate")
                    hook:Call("Menu.PostGenerate")
                end)
            end)

            gui:MoveTo( intro, UDim2.new(.5, -self.fw/2, .5, -self.fh/2), 0.775, 0, 0.25, function()
                gui:MoveTo( intro, UDim2.new(.5, 0, .5, 0), 0.775, .6, 0.25)
            end)
        end
    end

    --[[{
        activetab = 1
        name = "Bitch Bot",
        pos = UDim2.new(0, 520, 0, 100),
        size = UDim2.new(0, 500, 0, 600),
        center = true,
    },]]

    local main = gui:Create("Container")
    menu.main = main
    main.background = main:Cache(draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border"), nil, false))
    function main:PerformLayout(pos, size)
        self.background.Position = pos
        self.background.Size = size
    end
    main.background.Transparency = 0
    main.background.ZIndex = 0
    main.background.Visible = true
    main:Cache(main.background)

    hook:Add("OnConfigChanged", "BBOT:Menu.Background", function(steps, old, new)
        if config:IsPathwayEqual(steps, "Main","Settings","Cheat Settings","Background Transparency") then
            main.background.Transparency = 1-(config:GetValue("Main","Settings","Cheat Settings","Background Transparency")/100)
            main.background.Color = config:GetValue("Main","Settings","Cheat Settings","Background Transparency","Color")
            main:Cache(main.background)
        end
    end)

    main:SetZIndex(-1)
    main:SetTransparency(0)
    main:SetSize(1,0,1,0)

    function menu:Create(configuration)
        local frame = gui:Create("Panel", main)
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
        frame.autofocus = true
        frame:SetDraggable(true)

        local alias = gui:Create("Text", frame)
        frame.alias = alias
        alias:SetPos(0, 3, 0, 5)
        alias:SetText(configuration.name)

        if configuration.name == "Bitch Bot" then
            hook:Add("OnConfigChanged", "BBOT:Menu.Client-Info.Main", function(steps, old, new)
                if config:IsPathwayEqual(steps, "Main", "Settings", "Cheat Settings", "Custom Menu Name") then
                    alias:SetText(new)
                end
            end)
        end

        local tabs = gui:Create("Tabs", frame)
        tabs:SetPos(0, 10, 0, 10+15)
        tabs:SetSize(1, -20, 1, -20-15)

        local path = {frame.Id}

        self:HandleGeneration(function(config, panel)
            tabs:Add(config.name, config.icon, panel)
        end, path, configuration.content)
        return frame
    end

    hook:Add("InputBegan", "BBOT:Menu.Toggle", function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Delete then
                local new = not main:GetEnabled()
                gui:TransparencyTo(main, (new and 1 or 0), 0.2, 0, 0.25, function()
                    if not new then main:SetEnabled(false) end
                end)
                if new then main:SetEnabled(true) end
            end
        end
    end)

    hook:Add("Menu.Generate", "BBOT:Menu.Main", function()
        local setup_parameters = BBOT.configuration
        for i=1, #setup_parameters do
            menu:Create(setup_parameters[i]):SetZIndex(100*i)
        end
    end)

    hook:Add("Menu.PostGenerate", "BBOT:Menu.Main", function()
        gui:TransparencyTo(main, 1, 0.2, 0, 0.25)
    end)

    hook:Add("Initialize", "BBOT:Menu", function()
        menu:Initialize()
    end)

    menu.mouse = gui:Create("Mouse")
    menu.mouse:SetVisible(true)

    local infobar = gui:Create("Panel")
    menu.infobar = infobar
    infobar.gradient:SetSize(1, 0, 0, 15)
    infobar.gradient:Generate()
    infobar:AstheticLineAlignment("Top")
    infobar:SetSize(0, 0, 0, 20)
    infobar:SetZIndex(120000)

    local image = gui:Create("Image", infobar)
    image:SetImage(menu.images[8])
    image:SetPos(0, 2, 0, 1)
    image:SetSize(1, 0, 1, 0)
    image:SetSizeConstraint("Y")

    local client_info = gui:Create("Text", infobar)
    infobar.client_info = infobar
    client_info:SetPos(0, 20 + 8, .5, 1)
    client_info:SetTextAlignmentY(Enum.TextYAlignment.Center)
    client_info:SetText("Bitch Bot | " .. BBOT.username .. " | " .. os.date("%b. %d, %Y") .. " | Ver " .. BBOT.version)
    client_info:SetTextSize(13)

    hook:Add("OnConfigChanged", "BBOT:Menu.Client-Info", function(steps, old, new)
        if config:IsPathwayEqual(steps, "Main", "Settings", "Cheat Settings", "Custom Menu Name") then
            client_info:SetText(new .. " | " .. BBOT.username .. " | " .. os.date("%b. %d, %Y") .. " | Ver " .. BBOT.version)
            local sizex = client_info:GetTextSize()
            gui:SizeTo(infobar, UDim2.new(0, 20 + sizex + 8, 0, 20), 0.775, 0, 0.25)
        end
        if config:IsPathwayEqual(steps, "Main", "Settings", "Cheat Settings", "Custom Menu Logo") then
            image:SetImage(menu.images[5])
            if #new > 4 then
                thread:Create(function(img, image)
                    local img = game:HttpGet("https://i.imgur.com/" .. img .. ".png")
                    if img then
                        image:SetImage(img)
                    else
                        image:SetImage(menu.images[8])
                        BBOT.notification:Create("An error occured trying to get the menu logo!")
                    end
                end, new, image)
            end
        end
    end)

    local sizex = client_info:GetTextSize()
    infobar:SetPos(0, 50, 0, 8)
    gui:SizeTo(infobar, UDim2.new(0, 20 + sizex + 8, 0, 20), 0.775, 0, 0.25)
end

--! POST LIBRARIES !--
-- WholeCream here, do remember to sort all of this in order for a possible module based loader

local loadstart = tick()
-- Setup, are we playing PF, Universal or... Bad Business 😉
do
    local thread = BBOT.thread
    local hook = BBOT.hook
    local menu = BBOT.menu
    local gui = BBOT.gui
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

	--[[do
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
	end -- wait for framwork to load]]

    BBOT.log(LOG_NORMAL, "Waiting for Phantom Forces...")

    local loading
    function BBOT:SetLoadingText(txt)
        if loading then
            loading.msg:SetText(txt)
            local w, h = loading.msg:GetTextSize()
            w = w + 20
            h = h + 60
            if w < 270 then
                w = 270
            end
            gui:SizeTo(loading, UDim2.new(0, w, 0, h), 0.775, 0, 0.25)
            gui:MoveTo(loading, UDim2.new(.5, -w/2, .5, -h/2), 0.775, 0, 0.25)
        end
    end

    function BBOT:SetLoadingProgressBar(perc)
        if loading then
            loading.progress:SetPercentage(perc/100)
        end
    end

    function BBOT:SetLoadingStatus(txt, perc)
        if not loading then return end
        if txt then self:SetLoadingText(txt) end
        if perc then self:SetLoadingProgressBar(perc) end
        wait()
    end

    if menu and gui then
        loading = gui:Create("Panel")
        loading:Center()

        local message = gui:Create("Text", loading)
        loading.msg = message
        message:SetPos(.5, 0, .5, -20)
        message:SetTextAlignmentX(Enum.TextXAlignment.Center)
        message:SetTextAlignmentY(Enum.TextYAlignment.Center)
        message:SetText("Waiting for Phantom Forces...")
        local w, h = message:GetTextSize()

        local progress = gui:Create("ProgressBar", loading)
        loading.progress = progress
        progress:SetPos(0, 10, .5, 10)
        progress:SetSize(1, -20, 0, 10)

        w = w + 20
        h = h + 50

        if w < 270 then
            w = 270
        end

        gui:SizeTo(loading, UDim2.new(0, w, 0, h), 0.775, 0, 0.25)
        gui:MoveTo(loading, UDim2.new(.5, -w/2, .5, -h/2), 0.775, 0, 0.25)
    end

    BBOT:SetLoadingStatus(nil, 5)

    hook:Add("PreInitialize", "PreInitialize", function()
        BBOT:SetLoadingStatus("Pre-Initializing...", 65)
    end)
    
    hook:Add("Initialize", "Initialize", function()
        BBOT:SetLoadingStatus("Initializing...", 80)
    end)

    hook:Add("PostInitialize", "PostInitialize", function()
        BBOT:SetLoadingStatus("Post-Setups...", 100)
        if loading then
            loading:Remove()
            loading = nil
        end
    end)

    -- Why spend the time using getgc, when you can simply check an object!
    local waited = 0
    while true do
        if game:IsLoaded() then
            local lp = game:GetService("Players").LocalPlayer;
            local chatgame = lp.PlayerGui:FindFirstChild("ChatGame")
            if chatgame then
                local version = chatgame:FindFirstChild("Version")
                if version and not string.find(version.Text, "loading", 1, true) then
                    wait(1)
                    break
                end
            end
        end;
        waited = waited + 1
        if waited > 7 then
            BBOT:SetLoadingStatus("Something may be wrong... Contact the Demvolopers")
        elseif waited > 5 then
            BBOT:SetLoadingStatus("What the hell is taking so long?")
        end
        wait(5)
    end;

    hook:Add("PreInitialize", "BBOT:SetupConfigurationScheme", function()
    
        local menu = BBOT.menu
        local config = BBOT.config
        if BBOT.game == "pf" then
            local table = BBOT.table
            local anims = {
                {
                    type = "Toggle",
                    name = "Enable",
                    value = false,
                },
                {
                    type = "DropBox",
                    name = "Type",
                    value = 1,
                    values = {"Additive", "Wave"},
                },
                {
                    type = "Slider",
                    name = "Offset",
                    min = -1,
                    max = 1,
                    value = 0,
                    suffix = "studs"
                },
                {
                    type = "Slider",
                    name = "Amplitude",
                    min = 0,
                    max = 10,
                    value = 0,
                    suffix = "studs"
                },
                {
                    type = "Slider",
                    name = "Speed",
                    min = 0,
                    max = 10,
                    value = 0,
                    suffix = "studs"
                },
            }
            local skins_anims = {
                {
                    type = "Toggle",
                    name = "Enable",
                    value = false,
                    extra = {},
                },
                {
                    name = "OffsetStudsU",
                    pos = UDim2.new(0,0,0,20),
                    size = UDim2.new(.5,-3,0,175),
                    type = "Panel",
                    content = anims,
                    tooltip = "OffsetStuds changes the position of texture."
                },
                {
                    name = "OffsetStudsV",
                    pos = UDim2.new(.5,3,0,20),
                    size = UDim2.new(.5,-3,0,175),
                    type = "Panel",
                    content = anims,
                    tooltip = "OffsetStuds changes the position of texture."
                },
                {
                    name = "StudsPerTileU",
                    pos = UDim2.new(0,0,0,20+(175+6)),
                    size = UDim2.new(.5,-3,0,175),
                    type = "Panel",
                    content = anims,
                    tooltip = "StudsPerTile changes the scale of texture."
                },
                {
                    name = "StudsPerTileV",
                    pos = UDim2.new(.5,3,0,20+(175+6)),
                    size = UDim2.new(.5,-3,0,175),
                    type = "Panel",
                    content = anims,
                    tooltip = "StudsPerTile changes the scale of texture."
                }
            }
            local skins_content = {
                {
                    type = "Toggle",
                    name = "Enable",
                    value = false,
                    extra = {},
                    tooltip = "Do note this is not server-sided!"
                },
                {
                    type = "DropBox",
                    name = "Material",
                    value = 1,
                    values = {"Plastic", "Ghost", "Forcefield", "Neon", "Foil", "Glass"},
                    extra = {
                        {
                            type = "ColorPicker",
                            name = "Brick Color",
                            color = { 255, 255, 255, 255 },
                            tooltip = "Changes the base color of the material, not the texture."
                        },
                    },
                },
                {
                    type = "Slider",
                    name = "Reflectance",
                    value = 0,
                    min = 0,
                    max = 100,
                    suffix = "%",
                    decimal = 1,
                    extra = {},
                    tooltip = "Gives the material reflectance, this may be buggy or not work on some materials."
                },
                {
                    name = "Textures",
                    pos = UDim2.new(0,0,0,90),
                    size = UDim2.new(1,0,1,-96),
                    type = "Panel",
                    content = {
                        {
                            type = "Toggle",
                            name = "Enable",
                            value = false,
                            extra = {},
                        },
                        {
                            type = "Text",
                            name = "Asset-Id",
                            value = "3643887058",
                            extra = {},
                        },
                        {
                            type = "Slider",
                            name = "OffsetStudsU",
                            value = 0,
                            min = 0,
                            max = 10,
                            suffix = "studs",
                            decimal = 1,
                            extra = {},
                        },
                        {
                            type = "Slider",
                            name = "OffsetStudsV",
                            value = 0,
                            min = 0,
                            max = 10,
                            suffix = "studs",
                            decimal = 1,
                            extra = {},
                        },
                        {
                            type = "Slider",
                            name = "StudsPerTileU",
                            value = 1,
                            min = 0,
                            max = 10,
                            suffix = "studs/tile",
                            decimal = 1,
                            extra = {},
                        },
                        {
                            type = "Slider",
                            name = "StudsPerTileV",
                            value = 1,
                            min = 0,
                            max = 10,
                            suffix = "studs/tile",
                            decimal = 1,
                            extra = {},
                        },
                        {
                            type = "Slider",
                            name = "Transparency",
                            value = 0,
                            min = 0,
                            max = 100,
                            suffix = "%",
                            decimal = 1,
                            extra = {},
                        },
                    },
                }
            }
            local skins = {
                {
                    name = { "Slot1", "Slot1-Animations", "Slot2", "Slot2-Animations", },
                    pos = UDim2.new(0,0,0,0),
                    size = UDim2.new(1,0,1,0),
                    type = "Tabs",
                    {content=skins_content},
                    {content=skins_anims},
                    {content=skins_content},
                    {content=skins_anims},
                }
            }
            local weapon_legit = {
                {
                    name = "Aim Assist",
                    pos = UDim2.new(0,0,0,0),
                    size = UDim2.new(.5,-4,1,0),
                    type = "Panel",
                    content = {
                        {
                            type = "Toggle",
                            name = "Enabled",
                            value = true,
                            tooltip = "Aim assistance only moves your mouse towards targets"
                        },
                        {
                            type = "Slider",
                            name = "Aimbot FOV",
                            min = 0,
                            max = 100,
                            suffix = "°",
                            value = 20
                        },
                        {
                            type = "Toggle",
                            name = "Dynamic FOV",
                            value = false,
                            tooltip = "Changes all FOV to change depending on the magnification."
                        },
                        {
                            type = "Slider",
                            name = "Start Smoothing",
                            value = 20,
                            min = 0,
                            max = 100,
                            suffix = "%",
                        },
                        {
                            type = "Slider",
                            name = "End Smoothing",
                            min = 0,
                            max = 100,
                            suffix = "%",
                            value = 20
                        },
                        {
                            type = "Slider",
                            name = "Smoothing Increment",
                            min = 0,
                            max = 100,
                            suffix = "%/s",
                            value = 20
                        },
                        {
                            type = "Slider",
                            name = "Randomization",
                            value = 5,
                            min = 0,
                            mas = 20,
                            suffix = "",
                            custom = { [0] = "Off" },
                        },
                        {
                            type = "Slider",
                            name = "Deadzone FOV",
                            value = 1,
                            min = 0,
                            max = 50,
                            suffix = "°",
                            decimal = 1,
                            custom = { [0] = "Off" },
                        },
                        {
                            type = "DropBox",
                            name = "Aimbot Key",
                            value = 1,
                            values = { "Mouse 1", "Mouse 2", "Always", "Dynamic Always" },
                        },
                        {
                            type = "DropBox",
                            name = "Hitscan Priority",
                            value = 1,
                            values = { "Head", "Body", "Closest" },
                        },
                        {
                            type = "ComboBox",
                            name = "Hitscan Points",
                            values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
                        },
                    },
                },
                {
                    name = "Ballistics",
                    pos = UDim2.new(.5,4,0,0),
                    size = UDim2.new(.5,-4,1/2,-4),
                    type = "Panel",
                    content = {
                        {
                            type = "Toggle",
                            name = "Barrel Compensation",
                            value = true,
                            tooltip = "Attempts to aim based on the direction of the barrel",
                            extra = {}
                        },
                        {
                            type = "ComboBox",
                            name = "Disable Barrel Comp While",
                            values = { { "Fire Animation", true }, { "Scoping In", true }, { "Reloading", true } }
                        },
                        {
                            type = "Toggle",
                            name = "Drop Prediction",
                            value = true,
                        },
                        {
                            type = "Toggle",
                            name = "Movement Prediction",
                            value = true,
                        },
                        {
                            type = "Toggle",
                            name = "Enable Recoil Control",
                            value = true,
                        },
                        {
                            type = "ComboBox",
                            name = "Disable RCS While",
                            values = { { "Holding Sniper", false }, { "Scoping In", false }, { "Not Shooting", true } }
                        },
                        {
                            type = "Slider",
                            name = "Recoil Control X",
                            value = 45,
                            min = 0,
                            max = 100,
                            suffix = "%",
                        },
                        {
                            type = "Slider",
                            name = "Recoil Control Y",
                            value = 80,
                            min = 0,
                            max = 150,
                            suffix = "%",
                        },
                    }
                },
                {
                    name = {"Bullet Redirect", "Trigger Bot"},
                    pos = UDim2.new(.5,4,1/2,4),
                    size = UDim2.new(.5,-4,1/2,-4),
                    type = "Panel",
                    {content = {
                        {
                            type = "Toggle",
                            name = "Enabled",
                            value = false,
                        },
                        {
                            type = "Slider",
                            name = "Redirection FOV",
                            value = 5,
                            min = 0,
                            max = 180,
                            suffix = "°",
                        },
                        {
                            type = "Slider",
                            name = "Hit Chance",
                            value = 30,
                            min = 0,
                            max = 100,
                            suffix = "%",
                        },
                        {
                            type = "Slider",
                            name = "Accuracy",
                            value = 90,
                            min = 0,
                            max = 100,
                            suffix = "%",
                        },
                        {
                            type = "DropBox",
                            name = "Hitscan Priority",
                            value = 1,
                            values = { "Head", "Body", "Closest" },
                        },
                        {
                            type = "ComboBox",
                            name = "Hitscan Points",
                            values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
                        },
                    }},
                    {content = {
                        {
                            type = "Toggle",
                            name = "Enabled",
                            value = false,
                            extra = {
                                {
                                    type = "ColorPicker",
                                    name = "Dot Color",
                                    color = { 255, 0, 0, 255 },
                                },
                                {
                                    type = "KeyBind",
                                    key = nil,
                                    toggletype = 2,
                                },
                            },
                        },
                        {
                            type = "ComboBox",
                            name = "Trigger Bot Hitboxes",
                            values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
                        },
                        {
                            type = "Toggle",
                            name = "Trigger When Aiming",
                            value = false,
                        },
                        {
                            type = "Slider",
                            name = "Aim Percentage",
                            min = 0,
                            max = 100,
                            value = 90,
                            suffix = "%",
                        },
                    }},
                },
            }

            BBOT.configuration = {
                {
                    -- The first layer here is the frame
                    Id = "Main",
                    name = "Bitch Bot",
                    center = true,
                    size = UDim2.new(0, 500, 0, 600),
                    content = {
                        {
                            name = "Legit",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Tabs",
                            content = {
                                {
                                    name = "Pistol",
                                    icon = "M9",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(1,0,1,0),
                                    type = "Container",
                                    content = weapon_legit
                                },
                                {
                                    name = "Smg",
                                    icon = "MP5K",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(1,0,1,0),
                                    type = "Container",
                                    content = weapon_legit
                                },
                                {
                                    name = "Rifle",
                                    icon = "M4A1",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(1,0,1,0),
                                    type = "Container",
                                    content = weapon_legit
                                },
                                {
                                    name = "Shotgun",
                                    icon = "REMINGTON 870",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(1,0,1,0),
                                    type = "Container",
                                    content = weapon_legit
                                },
                                {
                                    name = "Sniper",
                                    icon = "INTERVENTION",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(1,0,1,0),
                                    type = "Container",
                                    content = weapon_legit
                                },
                            }
                        },
                        {
                            name = "Rage",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {},
                        },
                        {
                            name = "Visuals",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {
                                {
							        name = { "Enemy ESP", "Team ESP", "Local" },
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(.5,-4,11/20,-4),
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Enabled",
                                                value = true,
                                                tooltip = "Enables 2D rendering, disabling this could improve performance. Does not affect Chams."
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Name",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Name",
                                                        color = { 255, 255, 255, 200 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Box",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Box Fill",
                                                        color = { 255, 0, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Box",
                                                        color = { 255, 0, 0, 150 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Health Bar",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Box Fill",
                                                        color = { 255, 0, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Box",
                                                        color = { 0, 255, 0, 150 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Health Number",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Health Number",
                                                        color = { 255, 255, 255, 255 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Held Weapon",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Held Weapon",
                                                        color = { 255, 255, 255, 200 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Held Weapon Icon",
                                                value = false,
                                            },
                                            {
                                                type = "ComboBox",
                                                name = "Flags",
                                                values = { { "Use Large Text", false }, { "Level", true }, { "Distance", true }, { "Resolved", false }, { "Backtrack", false },  },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Chams",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Visible Enemy Chams",
                                                        color = { 255, 0, 0, 200 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Invisible Enemy Chams",
                                                        color = { 100, 0, 0, 100 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Skeleton",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy skeleton",
                                                        color = { 255, 255, 255, 120 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Out of View",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Arrow Color",
                                                        color = { 255, 255, 255, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Slider",
                                                name = "Arrow Distance",
                                                value = 50,
                                                min = 10,
                                                max = 101,
                                                custom = { [101] = "Max" },
                                                suffix = "%",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Dynamic Arrow Size",
                                                value = true,
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Enabled",
                                                value = false,
                                                tooltip = "Enables 2D rendering, disabling this could improve performance. Does not affect Chams."
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Name",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Team Name",
                                                        color = { 255, 255, 255, 200 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Box",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Box Fill",
                                                        color = { 0, 255, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Box",
                                                        color = { 0, 255, 0, 150 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Health Bar",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Team Low Health",
                                                        color = { 255, 0, 0, 255 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Team Max Health",
                                                        color = { 0, 255, 0, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Health Number",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Team Health Number",
                                                        color = { 255, 255, 255, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Held Weapon",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Team Held Weapon",
                                                        color = { 255, 255, 255, 200 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Held Weapon Icon",
                                                value = false,
                                            },
                                            {
                                                type = "ComboBox",
                                                name = "Flags",
                                                values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false },  },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Visible Team Chams",
                                                        color = { 0, 255, 0, 200 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Invisible Team Chams",
                                                        color = { 0, 100, 0, 100 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Skeleton",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Team skeleton",
                                                        color = { 255, 255, 255, 120 },
                                                    },
                                                },
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Arm Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Sleeve Color",
                                                        color = { 106, 136, 213, 255 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Hand Color",
                                                        color = { 181, 179, 253, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "DropBox",
                                                name = "Arm Material",
                                                value = 1,
                                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Animate Ghost Material",
                                                value = false,
                                                tooltip = "Toggles whether or not the 'Ghost' material will be animated or not.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Remove Weapon Skin",
                                                value = false,
                                                tooltip = "If a loaded weapon has a skin, it will remove it.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Third Person",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "KeyBind",
                                                        key = nil,
                                                        toggletype = 2,
                                                    },
                                                },
                                            },
                                            {
                                                type = "Slider",
                                                name = "Third Person Distance",
                                                value = 60,
                                                min = 1,
                                                max = 150,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Local Player Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Local Player Chams",
                                                        color = { 106, 136, 213, 255 },
                                                    },
                                                },
                                                tooltip = "Changes the color and material of the local third person body when it is on.",
                                            },
                                            {
                                                type = "DropBox",
                                                name = "Local Player Material",
                                                value = 1,
                                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                                            },
                                        },
                                    },
                                },
                                {
                                    name = "ESP Settings",
                                    pos = UDim2.new(0,0,11/20,4),
                                    size = UDim2.new(.5,-4,9/20,-4),
                                    type = "Panel",
                                    content = {
                                        {
                                            type = "Slider",
                                            name = "Max HP Visibility Cap",
                                            value = 90,
                                            min = 50,
                                            max = 100,
                                            suffix = "hp",
                                            custom = {
                                                [100] = "Always"
                                            }
                                        },
                                        {
                                            type = "DropBox",
                                            name = "Text Case",
                                            value = 2,
                                            values = { "lowercase", "Normal", "UPPERCASE" },
                                        },
                                        {
                                            type = "Slider",
                                            name = "Max Text Length",
                                            value = 0,
                                            min = 0,
                                            max = 32,
                                            custom = { [0] = "Unlimited" },
                                            suffix = " letters",
                                        },
                                        {
                                            type = "Slider",
                                            name = "ESP Fade Time", 
                                            value = 0.5,
                                            min = 0,
                                            max = 2,
                                            suffix = "s",
                                            decimal = 1,
                                            custom = { [0] = "Off" }
                                        },
                                        {
                                            type = "Toggle",
                                            name = "Highlight Target",
                                            value = false,
                                            extra = {
                                                {
                                                    type = "ColorPicker",
                                                    name = "Aimbot Target",
                                                    color = { 255, 0, 0, 255 },
                                                }
                                            },
                                        },
                                        {
                                            type = "Toggle",
                                            name = "Highlight Friends",
                                            value = true,
                                            extra = {
                                                {
                                                    type = "ColorPicker",
                                                    name = "Friended Players",
                                                    color = { 0, 255, 255, 255 },
                                                }
                                            },
                                        },
                                        {
                                            type = "Toggle",
                                            name = "Highlight Priority",
                                            value = true,
                                            extra = {
                                                {
                                                    type = "ColorPicker",
                                                    name = "Priority Players",
                                                    color = { 255, 210, 0, 255 },
                                                }
                                            },
                                        },
                                    },
                                },
                                {
                                    name = {"Camera Visuals", "Viewmodel"},
                                    pos = UDim2.new(.5,4,0,0),
                                    size = UDim2.new(.5,-8,1/2,-4),
                                    {
                                        content = {
                                            {
                                                type = "Slider",
                                                name = "Camera FOV",
                                                value = 80,
                                                min = 60,
                                                max = 120,
                                                suffix = "°",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "No Camera Bob",
                                                value = false,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "No Scope Sway",
                                                value = false,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Disable ADS FOV",
                                                value = false,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "No Scope Border",
                                                value = false,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "No Visual Suppression",
                                                value = false,
                                                tooltip = "Removes the suppression of enemies' bullets.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "No Gun Bob or Sway",
                                                value = false,
                                                tooltip = "Removes the bob and sway of weapons when walking. This does not remove the swing effect when moving the mouse.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Reduce Camera Recoil",
                                                value = false,
                                                tooltip = "Reduces camera recoil by X%. Does not affect visible weapon recoil or kick.",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Camera Recoil Reduction",
                                                value = 10,
                                                min = 0,
                                                max = 100,
                                                suffix = "%",
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Enabled",
                                                value = false,
                                            },
                                            {
                                                type = "Slider",
                                                name = "Offset X",
                                                value = 0,
                                                min = -3,
                                                max = 3,
                                                decimal = 0.01,
                                                suffix = " studs",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Offset Y",
                                                value = 0,
                                                min = -3,
                                                max = 3,
                                                decimal = 0.01,
                                                suffix = " studs",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Offset Z",
                                                value = 0,
                                                min = -3,
                                                max = 3,
                                                decimal = 0.01,
                                                suffix = " studs",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Pitch",
                                                value = 0,
                                                min = -360,
                                                max = 360,
                                                suffix = "°",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Yaw",
                                                value = 0,
                                                min = -360,
                                                max = 360,
                                                suffix = "°",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Roll",
                                                value = 0,
                                                min = -360,
                                                max = 360,
                                                suffix = "°",
                                            },
                                        },
                                    },
                                },
                                {
                                    name = {"World", "Misc", "Keybinds", "FOV"},
                                    pos = UDim2.new(.5,4,1/2,4),
                                    size = UDim2.new(.5,-8,(12/20)/2,-8),
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Ambience",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Inside Ambience",
                                                        color = { 117, 76, 236 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Outside Ambience",
                                                        color = { 117, 76, 236 },
                                                    }
                                                },
                                                tooltip = "Changes the map's ambient colors to your defined colors.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Force Time",
                                                value = false,
                                                tooltip = "Forces the time to the time set by your below.",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Custom Time",
                                                value = 0,
                                                min = 0,
                                                max = 24,
                                                decimal = 0.1,
                                                suffix = "hr",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Custom Saturation",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Saturation Tint",
                                                        color = { 255, 255, 255 },
                                                    },
                                                },
                                                tooltip = "Adds custom saturation the image of the game.",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Saturation Density",
                                                value = 0,
                                                min = 0,
                                                max = 100,
                                                suffix = "%",
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Aimbot Prediction",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Color",
                                                        color = { 127, 72, 163, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Ragdoll Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Ragdoll Chams",
                                                        color = { 106, 136, 213, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "DropBox",
                                                name = "Ragdoll Material",
                                                value = 1,
                                                values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Bullet Tracers",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Bullet Tracers",
                                                        color = { 201, 69, 54, 255 },
                                                    },
                                                },
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Enabled",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Text Color",
                                                        color = { 127, 72, 163, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Use List Sizes",
                                                value = false,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Log Keybinds",
                                                value = false
                                            },
                                            {
                                                type = "Slider",
                                                name = "Keybinds List X",
                                                value = 0,
                                                min = 0,
                                                max = 100,
                                                shift_stepsize = 0.05,
                                                suffix = "%",
                                            },
                                            {
                                                type = "Slider",
                                                name = "Keybinds List Y",
                                                value = 50,
                                                min = 0,
                                                max = 100,
                                                shift_stepsize = 0.05,
                                                suffix = "%",
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Enabled",
                                                value = true,
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Aim Assist",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Color",
                                                        color = { 127, 72, 163, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Aim Assist Deadzone",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Color",
                                                        color = { 50, 50, 50, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Bullet Redirect",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Color",
                                                        color = { 163, 72, 127, 255 },
                                                    },
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Ragebot",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Color",
                                                        color = { 255, 210, 0, 255 },
                                                    },
                                                },
                                            },
                                        },
                                    },
                                },
                                {
                                    name = {"Weapons", "Grenades", "Pickups"},
                                    pos = UDim2.new(.5,4,(1/2) + ((12/20)/2),4),
                                    size = UDim2.new(.5,-8,(8/20)/2,-4),
                                    type = "Tabs",
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Weapon Names",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Highlighted Weapons",
                                                        color = { 255, 125, 255, 255 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Weapon Names",
                                                        color = { 255, 255, 255, 255 },
                                                    },
                                                },
                                                tooltip = "Displays dropped weapons as you get closer to them, Highlights the weapon you are holding in the second color.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Weapon Icons",
                                                value = false
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Weapon Ammo",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Weapon Ammo",
                                                        color = { 61, 168, 235, 150 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Dropped Weapon Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Dropped Weapon Color",
                                                        color = { 3, 252, 161, 150 },
                                                    }
                                                },
                                            },
                                        }
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "Grenade Warning",
                                                value = true,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Slider Color",
                                                        color = { 68, 92, 227 },
                                                    }
                                                },
                                                tooltip = "Displays where grenades that will deal damage to you will land and the damage they will deal.",
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Grenade ESP",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Inner Color",
                                                        color = { 195, 163, 255 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Outer Color",
                                                        color = { 123, 69, 224 },
                                                    },
                                                },
                                                tooltip = "Displays the full path of any grenade that will deal damage to you is thrown.",
                                            },
                                        },
                                    },
                                    {
                                        content = {
                                            {
                                                type = "Toggle",
                                                name = "DogTags",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Color",
                                                        color = { 240, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Friendly Color",
                                                        color = { 0, 240, 240 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "DogTag Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Color",
                                                        color = { 240, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Friendly Color",
                                                        color = { 0, 240, 240 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Flags",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Color",
                                                        color = { 240, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Friendly Color",
                                                        color = { 0, 240, 240 },
                                                    }
                                                },
                                            },
                                            {
                                                type = "Toggle",
                                                name = "Flag Chams",
                                                value = false,
                                                extra = {
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Enemy Color",
                                                        color = { 240, 0, 0 },
                                                    },
                                                    {
                                                        type = "ColorPicker",
                                                        name = "Friendly Color",
                                                        color = { 0, 240, 240 },
                                                    }
                                                },
                                            },
                                        },
                                    }
                                },
                            },
                        },
                        {
                            name = "Misc",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {},
                        },
                        {
                            name = "Settings",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {
                                {
                                    name = "Cheat Settings",
                                    pos = UDim2.new(0,0,6/10,4),
                                    size = UDim2.new(.5,-4,4/10,-4),
                                    type = "Panel",
                                    content = {
                                        {
                                            type = "Toggle",
                                            name = "Menu Accent",
                                            value = false,
                                            extra = {
                                                {
                                                    type = "ColorPicker",
                                                    name = "Accent",
                                                    color = { 127, 72, 163, 255 },
                                                }
                                            },
                                        },
                                        {
                                            type = "Slider",
                                            name = "Background Transparency",
                                            value = 80,
                                            min = 0,
                                            max = 100,
                                            suffix = "%",
                                            custom = {
                                                [100] = "Off"
                                            },
                                            extra = {
                                                {
                                                    type = "ColorPicker",
                                                    name = "Color",
                                                    color = { 0, 0, 0, 255 },
                                                }
                                            },
                                        },
                                        {
                                            type = "Text",
                                            name = "Custom Menu Name",
                                            value = "Bitch Bot",
                                            extra = {},
                                        },
                                        {
                                            type = "Text",
                                            name = "Custom Menu Logo",
                                            value = "qH0WziT",
                                            extra = {},
                                        },
                                        {
                                            type = "Toggle",
                                            name = "Allow Unsafe Features",
                                            value = false,
                                            extra = {},
                                        },
                                        {
                                            type = "Button",
                                            name = "Unload Cheat",
                                            confirm = "Are you sure?",
                                            callback = function()
                                                BBOT.hook:Call("Unload")
                                                BBOT.Unloaded = true
                                            end
                                        }
                                    },
                                },
                                {
                                    name = "Configs",
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(.5,-4,6/10,-4),
                                    type = "Panel",
                                    content = {
                                        {
                                            type = "Text",
                                            name = "Config Name",
                                            value = "Default",
                                            extra = {},
                                        },
                                        {
                                            type = "DropBox",
                                            name = "Configs",
                                            value = 1,
                                            values = {"Default"}
                                        },
                                        {
                                            type = "Button",
                                            name = "Save",
                                            confirm = "Are you sure?",
                                            callback = function()
                                                BBOT.config:Save(BBOT.config:GetValue("Main", "Settings", "Configs", "Config Name"))
                                                local configs = BBOT.config:Discover()
                                                BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
                                                menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
                                            end
                                        },
                                        {
                                            type = "Button",
                                            name = "Load",
                                            confirm = "Are you sure?",
                                            callback = function()
                                                BBOT.config:Open(BBOT.config:GetValue("Main", "Settings", "Configs", "Configs"))
                                                BBOT.config:SetValue(BBOT.config:GetValue("Main", "Settings", "Configs", "Configs"), "Main", "Settings", "Configs", "Config Name")
                                                BBOT.config:SetValue(BBOT.config:GetValue("Main", "Settings", "Configs", "Configs"), "Main", "Settings", "Configs", "Autosave File")
                                                local configs = BBOT.config:Discover()
                                                BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
                                                menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
                                            end
                                        },
                                        {
                                            type = "Toggle",
                                            name = "Auto Save Config",
                                            value = false,
                                            extra = {},
                                        },
                                        {
                                            type = "Text",
                                            name = "Autosave File",
                                            value = "Default",
                                            extra = {},
                                        },
                                        {
                                            type = "Toggle",
                                            name = "Auto Load Config",
                                            value = false,
                                            extra = {},
                                        },
                                        {
                                            type = "Text",
                                            name = "Autoload File",
                                            value = "Default",
                                            extra = {},
                                        },
                                    }
                                }
                            },
                        },
                    }
                },
                --[[{
                    Id = "Weapons",
                    name = "Weapon Customization",
                    pos = UDim2.new(.75, 0, 0, 100),
                    size = UDim2.new(0, 425, 0, 575),
                    type = "Tabs",
                    content = {
                        {
                            name = "Stats Changer",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Enable",
                                    value = false,
                                    extra = {},
                                    tooltip = "Do note that modifying weapons can make things obvious like firerate!"
                                },
                            }
                        },
                        {
                            name = "Skins",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Enable",
                                    value = false,
                                    extra = {},
                                },
                                {
                                    name = { "Primary", "Secondary", "Tertiary" },
                                    pos = UDim2.new(0,0,0,20),
                                    size = UDim2.new(1,0,1,-20),
                                    {
                                        content = table.deepcopy(skins),
                                    },
                                    {
                                        content = table.deepcopy(skins),
                                    },
                                    {
                                        content = table.deepcopy(skins),
                                    }
                                },
                            }
                        },
                    }
                },
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
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {
                                {
                                    name = "Player List", -- No type means auto-set to panel
                                    pos = UDim2.new(0,8,0,8),
                                    size = UDim2.new(1,-16,1,-40-16),
                                    type = "Panel",
                                    content = {},
                                },
                                {
                                    name = "Player Control",
                                    pos = UDim2.new(0,8,1,-80-8),
                                    size = UDim2.new(1,-16,0,80),
                                    type = "Panel",
                                    content = {},
                                },
                            },
                        },
                        { -- Do not assign types in here, as tabs automatically assigns them as "Panel"
                            name = "Priorties And Friends",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {},
                        },
                        {
                            name = "Bitch Bot Users",
                            pos = UDim2.new(0,0,0,0),
                            size = UDim2.new(1,0,1,0),
                            type = "Container",
                            content = {},
                        },
                    }
                }]]
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
    BBOT:SetLoadingStatus("Loading Auxillary...", 20)
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

        BBOT:SetLoadingStatus(nil, 30)

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

        BBOT:SetLoadingStatus(nil, 40)

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

    BBOT:SetLoadingStatus(nil, 45)

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
                    --_BB.log(LOG_DEBUG, unpack(override))
                end
                return _send(self, unpack(override)), _hook:Call("PostNetworkSend", unpack(override))
            end
            if _BB.username == "dev" then
                --_BB.log(LOG_DEBUG, ...)
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

    local isalive = false
    hook:Add("RenderStepped", "BBOT:Aux.IsAlive", function()
        if isalive ~= aux.char.alive then
            isalive = aux.char.alive
            hook:Call("OnAliveChanged", (isalive and true or false))
        end
    end)
    
    hook:Add("Unload", "BBOT:Aux.UpValues.1", function()
        for i=1, #setupvalueundo do
            debug.setupvalue(unpack(setupvalueundo[i]))
        end
    end)

    local dt = tick() - profiling_tick
    BBOT.log(LOG_NORMAL, "Took " .. math.round(dt, 2) .. "s to load auxillary")
    BBOT:SetLoadingStatus(nil, 50)
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
end]=]

-- Aimbot (Conversion In Progress)
-- Knife Aura
-- Bullet Network Manipulation
do
    local timer = BBOT.timer
    local hook = BBOT.hook
    local config = BBOT.config
    local network = BBOT.aux.network
    local gamelogic = BBOT.aux.gamelogic
    local math = BBOT.math
    local vector = BBOT.vector
    local char = BBOT.aux.char
    local hud = BBOT.aux.hud
    local physics = BBOT.aux.physics
    local draw = BBOT.draw
    local replication = BBOT.aux.replication
    local raycast = BBOT.aux.raycast
    local cam = BBOT.aux.camera
    local localplayer = BBOT.service:GetService("LocalPlayer")
    local userinputservice = BBOT.service:GetService("UserInputService")
    local players = BBOT.service:GetService("Players")
    local camera = BBOT.service:GetService("CurrentCamera")
    local mouse = BBOT.service:GetService("Mouse")
    local aimbot = {}
    BBOT.aimbot = aimbot
    
    do
        local function raycastbullet(p1)
            local instance = p1.Instance
            if instance.Name == "Window" then return true end
            return not instance.CanCollide or instance.Transparency == 1
        end

        local workspace = BBOT.service:GetService("Workspace")
        function aimbot:fullcast(p7, p8, p9, p10, p11)
            local v3 = nil;
            local v4 = RaycastParams.new();
            v4.FilterDescendantsInstances = p9;
            v4.IgnoreWater = true;
            local calls = 0;
            while calls < 2000 do
                v3 = workspace:Raycast(p7, p8, v4);
                if not p10 then
                    break;
                end;
                if not v3 then
                    break;
                end;
                local ran, err = pcall(p10, v3)
                if not ran or not err then
                    break;
                end;
                table.insert(p9, v3.Instance);
                v4.FilterDescendantsInstances = p9;
                calls = calls + 1
            end;
            if not p11 then
                for v5 = #p9, #p9 + 1, -1 do
                    p9[v5] = nil;
                end;
            end;
            return v3;
        end;

        local currentcamera = BBOT.service:GetService("CurrentCamera")
        function aimbot:raycastbullet(vec, dir, extra, cb)
            return aimbot:fullcast(vec, dir, {currentcamera, workspace.Terrain, localplayer.Character, workspace.Ignore, extra}, cb or raycastbullet)
        end
    end

    function aimbot:VelocityPrediction(startpos, endpos, vel, speed) -- Kinematics is fun
        local len = (endpos-startpos).Magnitude
        local t = len/speed
        return endpos + (vel * t)
    end

    aimbot.bullet_gravity = Vector3.new(0, -196.2, 0) -- Todo: get the velocity from the game public settings

    function aimbot:DropPrediction(startpos, finalpos, speed)
        return physics.trajectory(startpos, self.bullet_gravity, finalpos, speed)
    end

    function aimbot:CanBarrelPredict(gun)
        local stopon = self:GetLegitConfig("Ballistics", "Disable Barrel Comp While")
        if stopon["Scoping In"] then
            local sight = BBOT.weapons.GetToggledSight(gun)
            if sight and (sight.sightspring.p > 0.1 and sight.sightspring.p < 0.9) then
                return false
            end
        end
        if stopon["Fire Animation"] then
        end
        if stopon["Reloading"] then
            if debug.getupvalue(gun.reloadcancel, 1) then return false end
        end
        return true
    end

    function aimbot:BarrelPrediction(target, dir, gun)
        local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
        if part then
            return (dir - part.CFrame.LookVector) - (dir - (target - part.CFrame.Position).Unit)
        end
    end

    function aimbot:GetParts(player)
        if not hud:isplayeralive(player) then return end
        return replication.getbodyparts(player)
    end

    local types = {
        -- Type Based
        ["PISTOL"] = "Pistol",
        ["REVOLVER"] = "Pistol",
        ["PDW"] = "Smg",
        ["DMR"] = "Rifle",
        ["LMG"] = "Rifle",
        ["CARBINE"] = "Rifle",
        ["ASSAULT"] = "Rifle",
        ["SHOTGUN"] = "Shotgun",
        ["SNIPER"] = "Sniper",

        -- Class Based
		["ASSAULT RIFLE"] = "Rifle",
        DMR = "Rifle",
        ["BATTLE RIFLE"] = "Rifle",
        PDW = "Smg",
        LMG = "Rifle",
        ["SNIPER RIFLE"] = "Sniper",
        CARBINE = "Rifle",
        SHOTGUN = "Shotgun",
		PISTOLS = "Pistol",
        ["MACHINE PISTOLS"] = "Pistol"
    }

    aimbot.gun_type = "ASSAULT"
    function aimbot:GetLegitConfig(...)
        local type = types[self.gun_type]
        if not type then
            type = "Rifle"
        end
        return config:GetValue("Main", "Legit", type, ...) 
    end

    function aimbot:GetLegitConfigR(...)
        local type = types[self.gun_type]
        if not type then
            type = "Rifle"
        end
        return config:GetRaw("Main", "Legit", type, ...) 
    end

    function aimbot:SetCurrentType(gun)
        if not gun.___class or not types[gun.___class] then
            self.gun_type = gun.type
            return
        end
        self.gun_type = (gun.___class or gun.type)
    end

    function aimbot:GetRageConfig(...)
        return config:GetValue("Main", "Rage", ...)
    end

    local partstosimple = {
        ["head"] = "Head",
        ["rootpart"] = "Body",
        ["larm"] = "Arms",
        ["rarm"] = "Arms",
        ["lleg"] = "Legs",
        ["rleg"] = "Legs",
    }

    local function Move_Mouse(delta)
        local coef = cam.sensitivitymult * math.atan(
            math.tan(cam.basefov * (math.pi / 180) / 2) / 2.72 ^ cam.magspring.p
        ) / (32 * math.pi)
        local x = cam.angles.x - coef * delta.y
        x = x > cam.maxangle and cam.maxangle or x < cam.minangle and cam.minangle or x
        local y = cam.angles.y - coef * delta.x
        local newangles = Vector3.new(x, y, 0)
        cam.delta = (newangles - cam.angles) / 0.016666666666666666
        cam.angles = newangles
    end

    function aimbot:GetFOV(Part, originPart)
        originPart = originPart or workspace.Camera
        local directional = CFrame.new(originPart.CFrame.Position, Part.Position)
        local ang = Vector3.new(directional:ToOrientation()) - Vector3.new(originPart.CFrame:ToOrientation())
        return math.deg(ang.Magnitude)
    end

    function aimbot:GetLegitTarget(fov, dzFov, hitscan_points, hitscan_priority)
        local mousePos = Vector3.new(mouse.x, mouse.y + 36, 0)
        local cam_position = camera.CFrame.p
        local team = (localplayer.Team and localplayer.Team.Name or "NA")
        local playerteamdata = workspace["Players"][team]

        local organizedPlayers = {}
        local plys = players:GetPlayers()
        for i=1, #plys do
            local v = plys[i]
            if v == localplayer then
                continue
            end
        
            if config.priority[v.UserId] then continue end
            local parts = self:GetParts(v)
            if not parts then continue end
        
            if v.Team and v.Team == localplayer.Team then
                continue
            end

            local updater = replication.getupdater(v)
            local prioritize
            if hitscan_priority == "Head" then
                prioritize = updater.gethead()
            elseif hitscan_priority == "Body" then
                prioritize = replication.getbodyparts(v).rootpart
            end

            local inserted_priority
            if prioritize then
                local part = prioritize
                local pos = prioritize.Position
                local point, onscreen = camera:WorldToViewportPoint(pos)
                if onscreen then
                    local object_fov = self:GetFOV(part)
                    if fov > object_fov and dzFov < object_fov then
                        local raydata = self:raycastbullet(cam_position,pos-cam_position,playerteamdata)
                        if (raydata and raydata.Instance:IsDescendantOf(updater.gethead().Parent)) then
                            table.insert(organizedPlayers, {v, part, point})
                            inserted_priority = true
                        end
                    end
                end
            end
            
            if not inserted_priority then
                for name, part in pairs(parts) do
                    local name = partstosimple[name]
                    if part == prioritize or not name or not hitscan_points[name] then continue end
                    local pos = part.Position
                    local point, onscreen = camera:WorldToViewportPoint(pos)
                    if not onscreen then continue end
                    local object_fov = self:GetFOV(part)
                    if fov <= object_fov or dzFov >= object_fov then continue end
                    local raydata = self:raycastbullet(cam_position,pos-cam_position,playerteamdata)
                    if (not raydata or not raydata.Instance:IsDescendantOf(updater.gethead().Parent)) and (raydata and raydata.Position ~= pos) then continue end
                    table.insert(organizedPlayers, {v, part, point})
                end
            end
        end
        
        table.sort(organizedPlayers, function(a, b)
            return (a[3] - mousePos).Magnitude < (b[3] - mousePos).Magnitude
        end)
        
        return organizedPlayers[1]
    end

    do
        local smoothing_incrimental = 0
        do
            local last_target
            hook:Add("RenderStepped", "BBOT:Aimbot.Assist.CalcSmoothing", function(delta)
                if not gamelogic.currentgun or not gamelogic.currentgun.data or not gamelogic.currentgun.data.bulletspeed then
                    smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
                    return
                end
                aimbot:SetCurrentType(gamelogic.currentgun)
                if (last_target == nil and aimbot.mouse_target) or (aimbot.mouse_target == nil and last_target) or (aimbot.mouse_target and last_target and aimbot.mouse_target[1] ~= last_target[1]) then
                    last_target = aimbot.mouse_target
                    smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
                elseif aimbot.mouse_target then
                    smoothing_incrimental = math.approach( smoothing_incrimental, aimbot:GetLegitConfig("Aim Assist", "End Smoothing"), aimbot:GetLegitConfig("Aim Assist", "Smoothing Increment") * delta )
                end
            end)
        end

        local assist_prediction_outline = draw:Circle(0, 0, 4, 6, 25, { 0, 0, 0, 255 }, 1, false)
        local assist_prediction = draw:Circle(0, 0, 3, 1, 25, { 255, 255, 255, 255 }, 1, false)
        hook:Add("Initialize", "BBOT:Aimbot.Assist.DotPrediction", function()
            assist_prediction.Color = config:GetValue("Main", "Visuals", "Misc", "Aimbot Prediction", "Color")
        end)

        hook:Add("OnConfigChanged", "BBOT:Aimbot.Assist.DotPrediction", function(steps, old, new)
            if config:IsPathwayEqual(steps, "Main", "Visuals", "Misc", "Aimbot Prediction", "Color") then
                assist_prediction.Color = new
            end
        end)

        hook:Add("OnAliveChanged", "BBOT:Aimbot.Assist.Hide", function(isalive)
            if not isalive then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
        end)

        function aimbot:MouseStep(gun)
            self.mouse_target = nil
            if assist_prediction.Visible then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
            if not self:GetLegitConfig("Aim Assist", "Enabled") then return end
            local aimkey = self:GetLegitConfig("Aim Assist", "Aimbot Key")
            if aimkey == "Mouse 1" or aimkey == "Mouse 2" then
                if not userinputservice:IsMouseButtonPressed((aimkey == "Mouse 1" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)) then return end
            elseif aimkey == "Dynamic Always" then
                if not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
            end

            local hitscan_priority = self:GetLegitConfig("Aim Assist", "Hitscan Priority")
            local hitscan_points = self:GetLegitConfig("Aim Assist", "Hitscan Points")
            local fov = self:GetLegitConfig("Aim Assist", "Aimbot FOV")
            local dzFov = self:GetLegitConfig("Aim Assist", "Deadzone FOV")

            if self:GetLegitConfig("Aim Assist", "Dynamic FOV") then
                fov = camera.FieldOfView / char.unaimedfov * fov
                if dzFov ~= 0 then
                    dzFov = camera.FieldOfView / char.unaimedfov * dzFov
                end
            end

            local target = self:GetLegitTarget(fov, dzFov, hitscan_points, hitscan_priority)
            if not target then return end
            self.mouse_target = target
            local position = target[2].Position
            local cam_position = camera.CFrame.p

            if self:GetLegitConfig("Ballistics", "Movement Prediction") then
                position = self:VelocityPrediction(cam_position, position, self:GetParts(target[1]).rootpart.Velocity, gun.data.bulletspeed)
            end

            local dir = (position-cam_position).Unit
            local magnitude = (position-cam_position).Magnitude
            if self:GetLegitConfig("Ballistics", "Drop Prediction") then
                dir = self:DropPrediction(cam_position, position, gun.data.bulletspeed).Unit
            end
            local pos, onscreen = camera:WorldToViewportPoint(cam_position + (dir*magnitude))
            if onscreen then
                if config:GetValue("Main", "Visuals", "Misc", "Aimbot Prediction") then
                    assist_prediction.Visible = true
                    assist_prediction_outline.Visible = assist_prediction.Visible
                    assist_prediction.Position = Vector2.new(pos.X, pos.Y)
                    assist_prediction_outline.Position = assist_prediction.Position
                end
            end

            if self:GetLegitConfig("Ballistics", "Barrel Compensation") and self:CanBarrelPredict(gun) then
                dir = dir + self:BarrelPrediction(position, dir, gun)
            end

            pos, onscreen = camera:WorldToViewportPoint(cam_position + (dir*magnitude))
            if onscreen then
                local randMag = self:GetLegitConfig("Aim Assist", "Randomization")
                local smoothing = smoothing_incrimental * 5 + 10
                local inc = Vector2.new((pos.X - mouse.X + (math.noise(time() * 0.1, 0.1) * randMag)) / smoothing, (pos.Y - mouse.Y - 36 + (math.noise(time() * 0.1, 0.1) * randMag)) / smoothing)
                Move_Mouse(inc)
            end
        end
    end

    do
        local assist_prediction_outline = draw:Circle(0, 0, 4, 6, 25, { 0, 0, 0, 255 }, 1, false)
        local assist_prediction = draw:Circle(0, 0, 3, 1, 25, { 255, 255, 255, 255 }, 1, false)
        hook:Add("Initialize", "BBOT:Aimbot.Redirection.DotPrediction", function()
            assist_prediction.Color = config:GetValue("Main", "Visuals", "Misc", "Aimbot Prediction", "Color")
        end)

        hook:Add("OnConfigChanged", "BBOT:Aimbot.Redirection.DotPrediction", function(steps, old, new)
            if config:IsPathwayEqual(steps, "Main", "Visuals", "Misc", "Aimbot Prediction", "Color") then
                assist_prediction.Color = new
            end
        end)

        hook:Add("OnAliveChanged", "BBOT:Aimbot.Redirection.Hide", function(isalive)
            if not isalive then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
        end)
    
        function aimbot:RedirectionStep(gun)
            self.redirection_target = nil
            if assist_prediction.Visible then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
            if not self:GetLegitConfig("Bullet Redirect", "Enabled") then return end
            local aimkey = self:GetLegitConfig("Aim Assist", "Aimbot Key")
            if aimkey == "Mouse 1" or aimkey == "Mouse 2" then
                if not userinputservice:IsMouseButtonPressed((aimkey == "Mouse 1" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)) then return end
            elseif aimkey == "Dynamic Always" then
                if not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
            end
            if math.random(0, 100) > self:GetLegitConfig("Bullet Redirect", "Hit Chance") then
                return
            end

            local sFov = self:GetLegitConfig("Bullet Redirect", "Redirection FOV")
            if self:GetLegitConfig("Aim Assist", "Dynamic FOV") then
                sFov = camera.FieldOfView / char.unaimedfov * sFov
            end

            local hitscan_priority = self:GetLegitConfig("Bullet Redirect", "Hitscan Priority")
            local hitscan_points = self:GetLegitConfig("Bullet Redirect", "Hitscan Points")

            local target = self:GetLegitTarget(sFov, 0, hitscan_points, hitscan_priority)
            if not target then return end
            self.redirection_target = target
            local position = target[2].Position
            local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
            local part_pos = part.Position

            if self:GetLegitConfig("Ballistics", "Movement Prediction") then
                position = self:VelocityPrediction(part_pos, position, self:GetParts(target[1]).rootpart.Velocity, gun.data.bulletspeed)
            end

            local dir = (position-part_pos).Unit
            local magnitude = (position-part_pos).Magnitude
            if self:GetLegitConfig("Ballistics", "Drop Prediction") then
                dir = self:DropPrediction(part_pos, position, gun.data.bulletspeed).Unit
            end
            local pos, onscreen = camera:WorldToViewportPoint(camera.CFrame.p + (dir*magnitude))
            if onscreen then
                if config:GetValue("Main", "Visuals", "Misc", "Aimbot Prediction") then
                    assist_prediction.Visible = true
                    assist_prediction_outline.Visible = assist_prediction.Visible
                    assist_prediction.Position = Vector2.new(pos.X, pos.Y)
                    assist_prediction_outline.Position = assist_prediction.Position
                end
            end

            local X, Y = CFrame.new(part_pos, part_pos+dir):ToOrientation()
            
            local accuracy = math.remap(self:GetLegitConfig("Bullet Redirect", "Accuracy")/100, 0, 1, .3, 0)
            X += ((math.pi/2) * (math.random(-accuracy*1000, accuracy*1000)/1000))
            Y += ((math.pi/2) * (math.random(-accuracy*1000, accuracy*1000)/1000))

            part.Orientation = Vector3.new(math.deg(X), math.deg(Y), 0)
            self.silent = part
        end
    end

    do
        local assist_prediction_outline = draw:Circle(0, 0, 4, 6, 25, { 0, 0, 0, 255 }, 1, false)
        local assist_prediction = draw:Circle(0, 0, 3, 1, 25, { 255, 255, 255, 255 }, 1, false)

        hook:Add("RenderStepped", "BBOT:Aimbot.TriggerBot", function()
            local mycurgun = gamelogic.currentgun
            if mycurgun and mycurgun.data and mycurgun.data.bulletspeed then
                aimbot:SetCurrentType(mycurgun)
                if not aimbot:GetLegitConfig("Trigger Bot", "Enabled") then return end
                assist_prediction.Color = aimbot:GetLegitConfig("Trigger Bot", "Enabled", "Dot Color")
            elseif assist_prediction.Visible then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
        end)

        hook:Add("OnAliveChanged", "BBOT:Aimbot.TriggerBot.Hide", function(isalive)
            if not isalive then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
        end)

        local zoomspring = debug.getupvalue(char.step, 1)
        function aimbot:TriggerBotStep(gun)
            self.trigger_target = nil
            if assist_prediction.Visible then
                assist_prediction.Visible = false
                assist_prediction_outline.Visible = assist_prediction.Visible
            end
            if not self:GetLegitConfig("Trigger Bot", "Enabled") then return end
            local aim_percentage = self:GetLegitConfig("Trigger Bot", "Aim Percentage")/100
            if self:GetLegitConfig("Trigger Bot", "Trigger When Aiming") and (not gun.isaiming() or not (zoomspring.p >= aim_percentage)) then return end
            local hitscan_points = self:GetLegitConfig("Trigger Bot", "Trigger Bot Hitboxes")
            local target = self:GetLegitTarget(camera.FieldOfView / char.unaimedfov * 180, 0, hitscan_points)
            if not target then return end
            self.trigger_target = target

            local position = target[2].Position
            local cam_position = camera.CFrame.p

            if self:GetLegitConfig("Ballistics", "Movement Prediction") then
                position = self:VelocityPrediction(cam_position, position, self:GetParts(target[1]).rootpart.Velocity, gun.data.bulletspeed)
            end

            local dir = (position-cam_position).Unit
            local magnitude = (position-cam_position).Magnitude
            if self:GetLegitConfig("Ballistics", "Drop Prediction") then
                dir = self:DropPrediction(cam_position, position, gun.data.bulletspeed).Unit
            end
            local trigger_position, onscreen = camera:WorldToViewportPoint(cam_position + dir)
            if onscreen then
                trigger_position = Vector2.new(trigger_position.X, trigger_position.Y)
                assist_prediction.Visible = true
                assist_prediction_outline.Visible = assist_prediction.Visible
                assist_prediction.Position = trigger_position
                assist_prediction_outline.Position = assist_prediction.Position
                local radi = 125*(char.unaimedfov/camera.FieldOfView)/(magnitude/2)
                assist_prediction.Radius = radi
                assist_prediction_outline.Radius = radi
            
                local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
                local part_pos = part.Position
                local team = (localplayer.Team and localplayer.Team.Name or "NA")
                local playerteamdata = workspace["Players"][team]

                local endpositon = part_pos+(part.CFrame.LookVector*70000)
                local raydata = self:raycastbullet(part_pos,endpositon,playerteamdata)
                local pointhit
                if raydata and raydata.Position then
                    pointhit = raydata.Position
                else
                    pointhit = endpositon
                end
                local barrel_end_positon, onscreen = camera:WorldToViewportPoint(pointhit)
                barrel_end_positon = Vector2.new(barrel_end_positon.X, barrel_end_positon.Y)
                if onscreen and vector.dist2d(trigger_position, barrel_end_positon) <= radi then
                    aimbot.fire = true
                    gun:shoot(true)
                end
            end
        end
    end

    function aimbot:RageStep(data)

    end

    function aimbot:LegitStep(gun)
        if not gun or not gun.data.bulletspeed then return end
        self:SetCurrentType(gun)
        self:MouseStep(gun)
        self:TriggerBotStep(gun)
        self:RedirectionStep(gun)
    end

    -- Do aimbot stuff here
    hook:Add("PreFireStep", "BBOT:Aimbot.Calculate", function(gun)
        if aimbot:GetRageConfig("Enabled") then
            aimbot:RageStep(gun)
        else
            aimbot:LegitStep(gun)
        end
    end)

    -- If the aimbot stuff before is persistant, use this to restore
    hook:Add("PostFireStep", "BBOT:Aimbot.Calculate", function(gun)
        if aimbot.silent and aimbot.silent.Parent then
            aimbot.silent.Orientation = aimbot.silent.Parent.Trigger.Orientation
            aimbot.silent = false
        end

        if aimbot.fire then
            aimbot.fire = nil
            gun:shoot(false)
        end
    end)
    
    do
        --(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
        --[[Draw:Circle(false, 20, 20, 10, 3, 20, { 10, 10, 10, 215 }, menu.fovcircle)
        Draw:Circle(false, 20, 20, 10, 1, 20, { 255, 255, 255, 255 }, menu.fovcircle)]]
        local draw = BBOT.draw
        --(x, y, size, thickness, sides, color, transparency, visible)
        local fov_outline = draw:Circle(0, 0, 1, 3, 314, { 10, 10, 10, 215 }, 1, false)
        local fov = draw:Circle(0, 0, 1, 1, 314, { 255, 255, 255, 255 }, 1, false)
        fov.Filled = false
        fov_outline.Filled = false
        aimbot.fov_circle = fov
        aimbot.fov_outline_circle = fov_outline

        local dzfov_outline = draw:Circle(0, 0, 1, 3, 314, { 10, 10, 10, 215 }, 1, false)
        local dzfov = draw:Circle(0, 0, 1, 1, 314, { 255, 255, 255, 255 }, 1, false)
        dzfov.Filled = false
        dzfov_outline.Filled = false
        aimbot.dzfov_circle = dzfov
        aimbot.dzfov_outline_circle = dzfov_outline

        local sfov_outline = draw:Circle(0, 0, 1, 3, 314, { 10, 10, 10, 215 }, 1, false)
        local sfov = draw:Circle(0, 0, 1, 1, 314, { 255, 255, 255, 255 }, 1, false)
        sfov.Filled = false
        sfov_outline.Filled = false
        aimbot.sfov_circle = sfov
        aimbot.sfov_outline_circle = sfov_outline
        
        hook:Add("Initialize", "BBOT:Visuals.Aimbot.FOV", function()
            fov.Color = config:GetValue("Main", "Visuals", "FOV", "Aim Assist", "Color")
            dzfov.Color = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone", "Color")
            sfov.Color = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect", "Color")
        end)
        
        hook:Add("OnConfigChanged", "BBOT:Visuals.Aimbot.FOV", function(steps, old, new)
            if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV") or config:IsPathwayEqual(steps, "Main", "Legit") then
                if not config:GetValue("Main", "Visuals", "FOV", "Enabled") then
                    fov.Visible = false
                    fov_outline.Visible = fov.Visible
                    dzfov.Visible = false
                    dzfov_outline.Visible = dzfov.Visible
                    sfov.Visible = false
                    sfov_outline.Visible = sfov.Visible
                    return
                end
                local center = camera.ViewportSize/2
                fov.Position = center
                fov_outline.Position = fov.Position
                dzfov.Position = center
                dzfov_outline.Position = dzfov.Position
                sfov.Position = center
                sfov_outline.Position = sfov.Position
                
                fov.Color = config:GetValue("Main", "Visuals", "FOV", "Aim Assist", "Color")
                dzfov.Color = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone", "Color")
                sfov.Color = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect", "Color")
                
                fov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist")
                fov_outline.Visible = fov.Visible
                dzfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone")
                dzfov_outline.Visible = dzfov.Visible
                sfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect")
                sfov_outline.Visible = sfov.Visible
                
                if not char.alive and config:IsPathwayEqual(steps, "Main", "Legit") and steps[3] then
                    local _fov = config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Aimbot FOV")
                    local _dzfov = config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Deadzone FOV")
                    local _sfov = config:GetValue("Main", "Legit", steps[3], "Bullet Redirect", "Redirection FOV")
                    if config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Dynamic FOV") then
                        _fov = camera.FieldOfView / char.unaimedfov * _fov
                        _dzfov = camera.FieldOfView / char.unaimedfov * _dzfov
                        _sfov = camera.FieldOfView / char.unaimedfov * _sfov
                    end
                    local yport = camera.ViewportSize.y
                    fov.Radius = _fov / camera.FieldOfView  * yport
                    fov_outline.Radius = fov.Radius
                    dzfov.Radius = _dzfov / camera.FieldOfView  * yport
                    dzfov_outline.Radius = dzfov.Radius
                    sfov.Radius = _sfov / camera.FieldOfView  * yport
                    sfov_outline.Radius = sfov.Radius
                end
            end
        end)
        
        local alive, curgun = false, false
        hook:Add("RenderStepped", "BBOT:Visuals.Aimbot.FOV", function()
            if not config:GetValue("Main", "Visuals", "FOV", "Enabled") then return end
            local set = false
            if alive ~= char.alive then
                alive = char.alive
                local bool = (alive and true or false)
                fov.Visible = bool
                fov_outline.Visible = fov.Visible
                dzfov.Visible = bool
                dzfov_outline.Visible = dzfov.Visible
                sfov.Visible = bool
                sfov_outline.Visible = sfov.Visible
                set = true
            end
        
            local mycurgun = gamelogic.currentgun
            if mycurgun and mycurgun.data and mycurgun.data.bulletspeed then
                aimbot:SetCurrentType(mycurgun)
                local _fov = aimbot:GetLegitConfig("Aim Assist", "Aimbot FOV")
                local _dzfov = aimbot:GetLegitConfig("Aim Assist", "Deadzone FOV")
                local _sfov = aimbot:GetLegitConfig("Bullet Redirect", "Redirection FOV")
                if aimbot:GetLegitConfig("Aim Assist", "Dynamic FOV") then
                    _fov = camera.FieldOfView / char.unaimedfov * _fov
                    _dzfov = camera.FieldOfView / char.unaimedfov * _dzfov
                    _sfov = camera.FieldOfView / char.unaimedfov * _sfov
                end
                local yport = camera.ViewportSize.y
                fov.Radius = _fov / camera.FieldOfView  * yport
                fov_outline.Radius = fov.Radius
                dzfov.Radius = _dzfov / camera.FieldOfView  * yport
                dzfov_outline.Radius = dzfov.Radius
                sfov.Radius = _sfov / camera.FieldOfView  * yport
                sfov_outline.Radius = sfov.Radius
            end
            
            if curgun ~= gamelogic.currentgun or set then
                curgun = gamelogic.currentgun
                if curgun and curgun.data and curgun.data.bulletspeed then
                    fov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist")
                    fov_outline.Visible = fov.Visible
                    dzfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone")
                    dzfov_outline.Visible = dzfov.Visible
                    sfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect")
                    sfov_outline.Visible = sfov.Visible
                else
                    local bool = false
                    fov.Visible = bool
                    fov_outline.Visible = fov.Visible
                    dzfov.Visible = bool
                    dzfov_outline.Visible = dzfov.Visible
                    sfov.Visible = bool
                    sfov_outline.Visible = sfov.Visible
                end
            end
        end)
    end

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
    --[=[hook:Add("SuppressNetworkSend", "BBOT:Aimbot.Silent", function(networkname, bullettable, timestamp)
        if networkname == "newbullets" then
            if not gamelogic.currentgun or not gamelogic.currentgun.data then return end
            local silent = config:GetValue("Rage", "Aimbot", "Silent Aim")
            if silent and aimbot.target then -- who are we targeting today?
                local target = aimbot.target
                -- timescale is to determine how quick the bullet hits
                -- don't want to get too cocky or the system might silent flag
                local timescale = config:GetValue("Legit", "Bullet Redirect", "TimeScale")
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
    
    end)]=]
end

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
    local math = BBOT.math
    local table = BBOT.table
    local config = BBOT.config
    local char = BBOT.aux.char
    local gamelogic = BBOT.aux.gamelogic
    local network = BBOT.aux.network

    weapons.WeaponDB = require(game:GetService("ReplicatedStorage").AttachmentModules.GunDatabase)

    function weapons.GetToggledSight(weapon)
        local updateaimstatus = debug.getupvalue(weapon.toggleattachment, 3)
        return debug.getupvalue(updateaimstatus, 1)
    end

    -- Welcome to my hell.
    -- ft. debug.setupvalue
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
    hook:Add("Initialize", "BBOT:Weapons.Detour", function()
        local receivers = network.receivers
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
    end)

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
        function gundata.destroy(...)
            hook:Call("PreDestroyKnife", gundata, ...)
            return olddestroy(...), hook:Call("PostDestroyKnife", gundata, ...)
        end

        local oldsetequipped = gundata.setequipped
        function gundata.setequipped(...)
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

        local ups = debug.getupvalues(oldstep)
        for k, v in pairs(ups) do
            if typeof(v) == "function" then
                local ran, consts = pcall(debug.getconstants, v)
                if ran and table.quicksearch(consts, "onfire") and table.quicksearch(consts, "pullout") and table.quicksearch(consts, "straightpull") and table.quicksearch(consts, "zoom") and table.quicksearch(consts, "zoompullout") then
                    debug.setupvalue(oldstep, k, function(...)
                        if gamelogic.currentgun == gundata then
                            hook:CallP("PreFireStep", gundata)
                        end
                        local a, b, c, d = v(...)
                        if gamelogic.currentgun == gundata then
                            hook:CallP("PostFireStep", gundata)
                        end
                        return a, b, c, d
                    end)
                end
            end
        end

        function gundata.step(...)
            -- this is where the aimbot controller will be
            if gamelogic.currentgun == gundata then
                hook:CallP("PreWeaponStep", gundata)
            end
            local a, b, c, d = oldstep(...)
            if gamelogic.currentgun == gundata then
                hook:CallP("PostWeaponStep", gundata)
            end
            return a, b, c, d
        end

        for class, v in pairs(weapons.WeaponDB.weplist) do
            for i=1, #v do
                if v[i] == gunname then
                    gundata.___class = class
                    return
                end
            end
        end
    end)

    -- Modifications
    hook:Add("WeaponModifyData", "ModifyWeapon.FireModes", function(modifications)
        if not config:GetValue("Weapons", "Stat Modifications", "Enable") then return end
        local firemodes = table.deepcopy(modifications.firemodes)
        local firerates = (typeof(modifications.firerate) == "table" and table.deepcopy(modifications.firerate) or nil)
        local single = config:GetValue("Weapons", "Stat Modifications", "FireModes", "Single") and 1 or nil
        if single and not table.quicksearch(firemodes, single) then
            table.insert(firemodes, 1, single)
        end
        local burst3 = config:GetValue("Weapons", "Stat Modifications", "FireModes", "Burst3") and 3 or nil
        if burst3 and not table.quicksearch(firemodes, burst3) then
            table.insert(firemodes, 1, burst3)
        end
        local auto = config:GetValue("Weapons", "Stat Modifications", "FireModes", "Auto") and true or nil
        if auto and not table.quicksearch(firemodes, auto) then
            table.insert(firemodes, 1, auto)
        end
        modifications.firemodes = firemodes
        if firerates and #firerates < #firemodes then
            local default = firerates[#firerates]
            for i=1, #firemodes-#firerates do
                table.insert(firerates, 1, default)
            end
            modifications.firerate = firerates
        end
        local mul = config:GetValue("Weapons", "Stat Modifications", "Bullet", "Firerate")
        if firerates then
            for i=1, #firerates do
                firerates[i] = firerates[i] * mul
            end
            modifications.firerate = firerates
        else
            modifications.firerate = modifications.firerate * mul;
        end
    end)

    --[[hook:Add("WeaponModifyData", "ModifyWeapon.Reload", function(modifications)
        --if not config:GetValue("Weapons", "Stat Modifications", "Enable") then return end
        local timescale = .5--config:GetValue("Weapons", "Stat Modifications", "Animation", "ReloadFactor")
        for i, v in next, modifications.animations do
            if string.find(string.lower(i), "reload") then
                if typeof(modifications.animations[i]) == "table" and modifications.animations[i].timescale then
                    modifications.animations[i].timescale = (modifications.animations[i].timescale or 1) * timescale
                end
            end
        end
    end)]]

    -- Skins
    do
        local texture_animtypes = {
            ["OffsetStudsU"] = true,
            ["OffsetStudsV"] = true,
            ["StudsPerTileU"] = true,
            ["StudsPerTileV"] = true,
            ["Transparency"] = true,
        }
        function weapons:SetupAnimations(reg, objects, type, animtable)
            if not reg.Enable then return end
            for k, v in pairs(reg) do
                if typeof(v) == "table" and v.Enable then
                    if texture_animtypes[k] and type == "Texture" then
                        if v.Type.value == "Additive" then
                            animtable[#animtable+1] = {
                                t = "Additive",
                                s = v.Speed,
                                p0 = v.Min,
                                min = v.Min,
                                max = v.Max,
                                objects = objects,
                                property = k
                            }
                        else
                            animtable[#animtable+1] = {
                                t = "Wave",
                                a = v.Amplitude,
                                o = v.Offset,
                                s = v.Speed,
                                objects = objects,
                                property = k
                            }
                        end
                    elseif (k == "BrickColor" and type ~= "Texture") or (k == "TextureColor" and type == "Texture") then
                        local col = (type == "Texture" and "Color3" or "Color")
                        if v.Type.value == "Fade" then
                            animtable[#animtable+1] = {
                                t = "Fade",
                                s = v.Speed,
                                c0 = v.Color1,
                                c1 = v.Color2,
                                objects = objects,
                                property = col
                            }
                        else
                            animtable[#animtable+1] = {
                                t = "Cycle",
                                s = v.Speed,
                                sa = v.Saturation,
                                da = v.Darkness,
                                objects = objects,
                                property = col
                            }
                        end
                    end
                end
            end
        end

        function weapons:RenderAnimations(animtable, delta)
            for i=1, #animtable do
                local anim = animtable[i]
                local position
                if anim.t == "Wave" then
                    position = anim.o + math.sin(anim.s * tick()) * anim.a
                elseif anim.t == "Additive" then
                    position = anim.p0 + anim.s * delta
                    if position > anim.max then
                        position = position - anim.max
                        position = position + anim.min
                    end
                    anim.p0 = position
                elseif anim.t == "Fade" then
                    local pos = math.sin(anim.s * tick())
                    local c0, c1 = anim.c0, anim.c1
                    c0, c1 = Vector3.new(c0.r, c0.g, c0.b), Vector3.new(c1.r, c1.g, c1.b)
                    local dc = math.remap(pos, -1, 1, c0, c1)
                    position = Color3.new(dc.x, dc.y, dc.z)
                elseif anim.t == "Cycle" then
                    position = Color3.fromHSV((tick() * anim.s) % 360, anim.sa, anim.da)
                end
                if position then
                    for i=1, #anim.objects do
                        local object = anim.objects[i]
                        object[anim.property] = position or object[anim.property]
                    end
                end
            end
        end

        function weapons:ApplySkin(reg, gundata, slot1, slot2)
            local skins = {
                slot1 = {
                    objects = {},
                    textures = {},
                    animations = {}
                },
                slot2 = {
                    objects = {},
                    textures = {},
                    animations = {}
                },
            }
            if gundata then
                gundata._skins = skins
            end
            local slot1_data = reg["Slot 1"]
            if slot1_data.Enable then
                skins.slot1.objects = slot1
                local textures = {}
                for i=1, #slot1 do
                    local object = slot1[i]
                    object.Color = slot1_data["Brick Color"]
                    object.Material = config.matstoid[slot1_data["Material"].value]
                    object.Reflectance = slot1_data["Reflectance"].value
                    if object:IsA("UnionOperation") then
                        object.UsePartColor = true
                    end
                    local texture = slot1_data["Texture"]
                    if texture.Enable and texture.AssetID ~= "" and (object:IsA("MeshPart") or object:IsA("UnionOperation")) then
                        for i=0, 5 do
                            local itexture = Instance.new("Texture")
                            itexture.Parent = object
                            itexture.Face = i
                            itexture.Name = "Slot1"
                            itexture.Color3 = texture.Color
                            itexture.Texture = texture.AssetID
                            itexture.Transparency = texture.Transparency.value
                            itexture.OffsetStudsU = texture.OffsetStudsU.value
                            itexture.OffsetStudsV = texture.OffsetStudsV.value
                            itexture.StudsPerTileU = texture.StudsPerTileU.value
                            itexture.StudsPerTileV = texture.StudsPerTileV.value
                            if gundata then
                                if not gundata._anims.camodata[object] then
                                    gundata._anims.camodata[object] = {}
                                end
                                gundata._anims.camodata[object][itexture] = {
                                    Transparency = itexture.Transparency
                                }
                            end
                            skins.slot1.textures[#skins.slot1.textures+1] = {object, itexture}
                            textures[#textures+1] = itexture
                        end
                    end
                end
                self:SetupAnimations(slot1_data.Animation, textures, "Texture", skins.slot1.animations)
                self:SetupAnimations(slot1_data.Animation, slot1, "Part", skins.slot1.animations)
            end

            local slot2_data = reg["Slot 2"]
            if slot2_data.Enable then
                skins.slot2.objects = slot2
                local textures = {}
                for i=1, #slot2 do
                    local object = slot2[i]
                    object.Color = slot2_data["Brick Color"]
                    object.Material = config.matstoid[slot2_data["Material"].value]
                    object.Reflectance = slot2_data["Reflectance"].value
                    if object:IsA("UnionOperation") then
                        object.UsePartColor = true
                    end
                    local texture = slot2_data["Texture"]
                    if texture.Enable and texture.AssetID ~= "" and (object:IsA("MeshPart") or object:IsA("UnionOperation")) then
                        for i=0, 5 do
                            local itexture = Instance.new("Texture")
                            itexture.Parent = object
                            itexture.Name = "Slot2"
                            itexture.Face = i
                            itexture.Color3 = texture.Color
                            itexture.Texture = texture.AssetID
                            itexture.Transparency = texture.Transparency.value
                            itexture.OffsetStudsU = texture.OffsetStudsU.value
                            itexture.OffsetStudsV = texture.OffsetStudsV.value
                            itexture.StudsPerTileU = texture.StudsPerTileU.value
                            itexture.StudsPerTileV = texture.StudsPerTileV.value
                            if gundata then
                                if not gundata._anims.camodata[object] then
                                    gundata._anims.camodata[object] = {}
                                end
                                gundata._anims.camodata[object][itexture] = {
                                    Transparency = itexture.Transparency
                                }
                            end
                            skins.slot1.textures[#skins.slot1.textures+1] = {object, itexture}
                            textures[#textures+1] = itexture
                        end
                    end
                end
                self:SetupAnimations(slot2_data.Animation, textures, "Texture", skins.slot2.animations)
                self:SetupAnimations(slot2_data.Animation, slot2, "Part", skins.slot2.animations)
            end

            return skins
        end

        hook:Add("Initialize", "BBOT:Weapons.SkinDB", function()
            local receivers = network.receivers
            for k, v in pairs(receivers) do
                local ups = debug.getupvalues(v)
                for kk, vv in pairs(ups) do
                    if typeof(vv) == "function" then
                        local ran, consts = pcall(debug.getconstants, vv)
                        if ran and table.quicksearch(consts, " times this month)") then
                            weapons.skindatabase = debug.getupvalue(vv, 4)
                        end
                    end
                end
            end
        end)

        do
            weapons.weaponstorage = debug.getupvalue(char.unloadguns, 2)

            hook:Add("OnConfigChanged", "Skin.LiveChanger", function(steps, old, new)
                if config:IsPathwayEqual(steps, "Weapons", "Skins", "Primary") then
                    local wep
                    for k, v in pairs(weapons.weaponstorage) do
                        if v.gunnumber == 1 then
                            wep = v
                            break
                        end
                    end
                    if not wep then return end
                    weapons:SkinApplyGun(wep, 1)
                elseif config:IsPathwayEqual(steps, "Weapons", "Skins", "Secondary") then
                    local wep
                    for k, v in pairs(weapons.weaponstorage) do
                        if v.gunnumber == 2 then
                            wep = v
                            break
                        end
                    end
                    if not wep then return end
                    weapons:SkinApplyGun(wep, 2)
                elseif config:IsPathwayEqual(steps, "Weapons", "Skins", "Tertiary") then
                    local wep
                    for k, v in pairs(weapons.weaponstorage) do
                        if v._isknife then
                            wep = v
                            break
                        end
                    end
                    if not wep then return end
                    weapons:SkinApplyGun(wep, 3)
                end
            end)
        end

        function weapons:SkinApplyGun(gundata, slot)
            if not config:GetValue("Weapons", "Skins", "Enable") then return end
            local slot = slot or gundata.gunnumber
            local model = gundata._model
            if not model then return end

            local classtype = "Tertiary"
            if slot == 1 then
                classtype = "Primary"
            elseif slot == 2 then
                classtype = "Secondary"
            end


            local reg = config:GetValue("Weapons", "Skins", classtype)
            if not reg.Enable then return end

            local descendants = model:GetDescendants()
            local slot1, slot2 = {}, {}
            for k, v in pairs(descendants) do
                if v.ClassName == 'Texture' and (v.Name == "Slot1" or v.Name == "Slot2") then
                    v:Destroy()
                elseif v.ClassName == 'Part' or v.ClassName == 'MeshPart' or v.ClassName == 'UnionOperation' then
                    if v:FindFirstChild("Slot1") then
                        slot1[#slot1+1] = v
                    elseif v:FindFirstChild("Slot2") then
                        slot2[#slot2+1] = v
                    end
                end
            end

            weapons:ApplySkin(reg, gundata, slot1, slot2)
        end

        hook:Add("PostLoadGun", "Skin.Apply", function(gundata, name)
            if not config:GetValue("Weapons", "Skins", "Enable") then return end
            weapons:SkinApplyGun(gundata)
        end)

        hook:Add("FullyLoaded", "Skin.LiveApply", function()
            timer:Simple(1, function()
                local workspace = BBOT.service:GetService("Workspace")
                hook:Add("OnConfigChanged", "Skin.Preview", function(steps, old, new)
                    if not config:IsPathwayEqual(steps, "Weapons", "Skins", "Preview") then return end
                    local model = workspace.MenuLobby.GunStage.GunModel:GetChildren()[1]
                    if not model then return end
                    local reg = config:GetValue("Weapons", "Skins", "Preview")
                    if not reg.Enable then return end

                    local descendants = model:GetDescendants()
                    local slot1, slot2 = {}, {}
                    for k, v in pairs(descendants) do
                        if v.ClassName == 'Texture' and (v.Name == "Slot1" or v.Name == "Slot2") then
                            v:Destroy()
                        elseif v.ClassName == 'Part' or v.ClassName == 'MeshPart' or v.ClassName == 'UnionOperation' then
                            if v:FindFirstChild("Slot1") then
                                slot1[#slot1+1] = v
                            elseif v:FindFirstChild("Slot2") then
                                slot2[#slot2+1] = v
                            end
                        end
                    end

                    local applied = weapons:ApplySkin(reg, nil, slot1, slot2)
                    
                    hook:Add("RenderStep.First", "Skin.Preview.Animations", function(delta)
                        weapons:RenderAnimations(applied.slot1.animations, delta)
                        weapons:RenderAnimations(applied.slot2.animations, delta)
                    end)

                    local connection
                    connection = workspace.MenuLobby.GunStage.GunModel.ChildRemoved:Connect(function()
                        hook:Remove("RenderStep.First", "Skin.Preview.Animations")
                        connection:Disconnect()
                    end)
                end)
            end)
        end)

        hook:Add("PostLoadKnife", "Skin.Apply", function(gundata, name)
            if not config:GetValue("Weapons", "Skins", "Enable") then return end
            local model = gundata._model
            gundata._isknife = true
            if not model then return end
            local reg = config:GetValue("Weapons", "Skins", "Tertiary")
            if not reg.Enable then return end

            local descendants = model:GetDescendants()
            local slot1, slot2 = {}, {}
            for k, v in pairs(descendants) do
                if v.ClassName == 'Texture' and (v.Name == "Slot1" or v.Name == "Slot2") then
                    v:Destroy()
                elseif v.ClassName == 'Part' or v.ClassName == 'MeshPart' or v.ClassName == 'UnionOperation' then
                    if v:FindFirstChild("Slot1") then
                        slot1[#slot1+1] = v
                    elseif v:FindFirstChild("Slot2") then
                        slot2[#slot2+1] = v
                    end
                end
            end

            weapons:ApplySkin(reg, gundata, slot1, slot2)
        end)

        hook:Add("PostWeaponThink", "Skin.Animation", function(gundata, partdata)
            if not config:GetValue("Weapons", "Skins", "Enable") then return end
            if not gundata._skins then return end
            if not gundata._skinlast then
                gundata._skinlast = tick()
                return
            end
            local delta = tick()
            weapons:RenderAnimations(gundata._skins.slot1.animations, delta-gundata._skinlast)
            weapons:RenderAnimations(gundata._skins.slot2.animations, delta-gundata._skinlast)
            gundata._skinlast = delta
        end)

        hook:Add("PostKnifeThink", "Skin.Animation", function(gundata, partdata)
            if not config:GetValue("Weapons", "Skins", "Enable") then return end
            if not gundata._skins then return end
            if not gundata._skinlast then
                gundata._skinlast = tick()
                return
            end
            local delta = tick()
            weapons:RenderAnimations(gundata._skins.slot1.animations, delta-gundata._skinlast)
            weapons:RenderAnimations(gundata._skins.slot2.animations, delta-gundata._skinlast)
            gundata._skinlast = delta
        end)
    end
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