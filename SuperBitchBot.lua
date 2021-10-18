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
if not(game.PlaceId == 292439477 or game.PlaceId == 299659045 or game.PlaceId == 5281922586 or game.PlaceId == 3568020459) then
    return
end

local _BBOT = _G.BBOT
local username = (BBOT and BBOT.username or nil)
if BBOT and BBOT.__init then
    BBOT = nil
end
local BBOT = BBOT or { username = (username or "dev"), alias = "Bitch Bot", version = "¯\\_(?)_/¯", __init = true } -- I... um... fuck off ok?
_G.BBOT = BBOT

while true do
    if game:IsLoaded() then
        break
    end;
    wait(2)
end

-- This should always start before hand, this module is responsible for debugging
-- Example usage: BBOT.log(LOG_NORMAL, "How do I even fucking make this work?")
do
    local log = {}
    BBOT.log = log

    -- fallback on synapse x v2.9.1
    -- note: this is disabled due to problems with synapse's second console being all fucky wucky
    local _rconsoleprint = rconsoleprint
    local rconsoleprint = function() end
    --[[if BBOT.username == "dev" then
        rconsoleclear()
        rconsoleprint = _rconsoleprint
    end]]

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
                local rconsoleprint = _rconsoleprint
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
                local rconsoleprint = _rconsoleprint
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

    function table.fyshuffle( tInput )
        local tReturn = {}
        for i = #tInput, 1, -1 do
            local j = math.random(i)
            tInput[i], tInput[j] = tInput[j], tInput[i]
            table.insert(tReturn, tInput[i])
        end
        return tReturn
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
                log(LOG_ERROR, a)
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
                            log(LOG_ERROR, a)
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
        --[[self.registry = {}
        self._registry_qa = {}]]
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

    local camera = BBOT.service:GetService("CurrentCamera")
    local vport = camera.ViewportSize
    hook:Add("RenderStep.First", "ViewportSize.Changed", function()
        if camera.ViewportSize ~= vport then
            vport = camera.ViewportSize
            hook:CallP("Camera.ViewportChanged", vport)
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
            local t, index = timer:Get(identifier)
            if t then
                table.remove(timer.registry, index)
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
                        log(LOG_ERROR, "Error in timer library! - ", err)
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

    function draw:Quad(pa, pb, pc, pd, color, thickness, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Quad")
		object.Visible = visible
		object.Color = self:VerifyColor(color)
		object.Filled = true
		object.Thickness = thickness or 0
		object.Opacity = opacity
		if pa and pb and pc then
			object.PointA = Vector2.new(pa[1], pa[2])
			object.PointB = Vector2.new(pb[1], pb[2])
			object.PointC = Vector2.new(pc[1], pc[2])
            object.PointD = Vector2.new(pd[1], pd[2])
		end
		return object
    end

	function draw:BoxOutline(x, y, w, h, thickness, color, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Square")
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = Vector2.new(w, h)
		object.Color = self:VerifyColor(color)
		object.Filled = false
		object.Thickness = thickness or 0
		object.Opacity = opacity 
		return object
	end

	function draw:Box(x, y, w, h, thickness, color, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Square")
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = Vector2.new(w, h)
		object.Color = self:VerifyColor(color)
		object.Filled = true
		object.Thickness = thickness or 0
		object.Opacity = opacity 
		return object
	end

	function draw:Line(thickness, start_x, start_y, end_x, end_y, color, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Line")
		object.Visible = visible
		object.Thickness = thickness
		object.From = Vector2.new(start_x, start_y)
		object.To = Vector2.new(end_x, end_y)
		object.Color = self:VerifyColor(color)
		object.Opacity = opacity 
		return object
	end

    local placeholderImage = "iVBORw0KGgoAAAANSUhEUgAAAJYAAACWCAYAAAA8AXHiAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAJOgAACToAYJjBRwAADAPSURBVHhe7Z0HeFRV+sZDCyEJCQRICJA6k4plddddXf/KLrgurg1EXcXdZV0bVlCqDRQVAQstNKVJ0QVcAelIDz0UaSGBQChJII10Orz/9ztzJ5kk00lC2vs833NTZs69c85vvvOdc8/5rgvqVa9KUD1Y9aoU1YNVr0pRPVj1qhTVg1WvSlE9WPWqFNWDZUaFubk4sf8g9q5egw2zv8eKid/g5y9GY9HIr7FkzASsmjwVWxcsxMFNsUhPPqG9q16mqrNgpRxJwtKxEzFhQD+8fV8nPOzqiXtdXPBMx2gM/HMnjHm6B/7bsxfWvPk24t4fggOEKjFmMo5OnoKjM2ZiPy1u5iys/m425nw5FuMHD8Lc0ePx/Vdj8MOnIzC93yDsWb5KO1vdU50Ba93MOfj6tVfRw8sP0QToWdpnLk0wr4k3dvkG4Pzv7wVuuwvwaosrnn4436w1Cpq1Qp57a+TymOvmg5ymLXHOlcb35DRqjtwGHshzcaM1Rl7zNii6615cffFVXKV3w4qVSN2zGz9O+w7zYyZh8aRv8MPQYSjKy9euqHar1oKVknAEE/v2RTf3VriTEA12aYiFbq2Q7BcMhEYDQZG4FBCOwvZ65LXTI9svBFn+ocji72LZ9liHsBJjGVm+wchq2R5ZhDPL1RvZLk2Rw/MW/t+fceWjT4E9e7Bl7TosmDgF80d9ja3z/6ddbe1TrQIrKzUVY3u/hD8QpB60mU1a4GRbghQSjStB4cgPDMO5gDBkdtAjM0AsDFkClTloKsI06LJ8g5Dl3RaZDT0JmwsK/tgJ1whXXkoK5o2biAXsPncvX6l9itqhWgHWopgYPNTAHX9lo81hV5VPcBASicLA8BKQpIEFpDJmgEtnHozKMCNonr7I4vXmEvDrY8cjMy0NcyQ+o2e7dvWq9slqrmosWNevX8eInj0Rxcb5xMWVXVwQEByBAvFEbMAMwmQOJHNW5XAZTTxaW3bBjOky+TkK7+sCbNyIJf9biFlDPsHp+MPap615qnFgFZ7LwcAuD+IO8U5uLRkrRTBWki6HMLXXKaDEQ8nPcjQHkjkTuLL9bwJcRhNP1oaerJEXchp6ADETsWfHTswcNhzxGzZpn77mqMaAdfXSZfTv1Bl3Eajl7EakqytgzJROD5XBhjF0d6WtxsFlNHpP6SolHrv23hAc3r8fUwa8h1P7D2q1Uf1VI8D6rNuTuI2VvFgDSuKS9A46BZUCS0Big5QFS8wpuG5Gt2jWeE3e/ioWwyfDsW1jLL7+9wu4cvGiVjPVV9UarFXTp6kYanITbwVUXmAJUBkmVhlw3ZSYy5JJN9m8LT1YQ2DpUsybMRsz3x6g1VL1VLUE60J+Ph7z9MHzhKooKBzntS6vLFCmVrs9V4llNvZCQbsQXE5Oxif/7IWk7XFarVUvVTuwZg8dio4EKtanA71URAk0dlhdgSvbP1SNIvHG21i/ZRNGP/Mvrfaqj6oVWE/4+OFlqTDp9gQUdnvmALJmFQ6XTAlUR7ike/Rui9wmzXHt1Em81+0JZJ86rdXkzVe1ACtx53YVSy1r0RYIjUC6xFIaIObgsWWVBpfRyjbyzbR2/DzyZRw+AtPHjMfqWbO0Wr25uulgxbz4sroFk0WYCmhnBSrjUQPEHDy2zCZcclTQ8NguFBltg5DpF4hs30DktglAXusOKPBph0K/IBS2D0Eh4ZL7ioX+wSjk//Nb+COvZTvk+HDU5tMeWa06GGbU24ZUPXzivZr64PKdf8C+LZsx7C+PaLV783RTwXpJF6kCdEMspcOZDqE4y6PyWJUEl3grgUgBRHAuEaprt98DdHoYebQDd3TC6oi78EPI7YgJvxXjwm/HpPDfYcpt92Lq7f+Habf8EdPCf4u5tNW3/R8O3PNXFHR9Cuj6JC7d8wAKI+9APsE759UWma0InF9wlYEmYOe4NMaF48fRt+tDWi3fHN00sLq4NsOXjbwIVTjOBBiAEjMLl5N8Qlc6YQnizCJF7oSFAHc1xUJBGhmSDTe89dj2B/+jBGv9MaEIUOwbuFiHD9+DJe067SmQlpCYiKWz/sRcz/6DIsHD8XCp3phwe33Ialzd+DRZ3H+zvuQR7iyvH2R1YYesQogU4H9gX3o0/kBnM/LM1xsFavKwbpYUKhuxyz28sfVYEKlgWRqFQGXCvw5LM9r3R6IvgM5dz+AWcFReM27HQY+0g2zR41CekaGdlUVr8TkZPz01VisfHMQfv79A8h7/J+49Cd6RX6OrOaEjF2sOSgqxNg1qrhrzDi898TfcfrAIe2qqk5VClZ+RqZaZLeTLrswKByprIA0QnDWxGNZg8ueLjG9fSiH40G4yuP5uztjakAEerq2wEcv/geJe/dpV1L12hobi9UffoLl9/0NF3o8j6I/dMY5bz8Vm1WKF5O4y8UD6P0Gvnh7IBI2btaupGpUZWDlpp1FJKE6JF4kUEeo9IQqDKm0NAWT855LdXcEKadtgPJOcZF3oZdLE7zZ9a/YF1u1FWqPNv+yBuv7DEJ8lydxhfFZjnSVHAhUBmBZbj7Ak89iwmcjcHDdOu0KKl9VAlZ+RpaC6gg/aA7hSCVEacpK4DqjYHLcc0mXl9s2EOh4J5YFd0QXnmd037e1M1dvZV+7grWfjMKuLj1w9bHncE4A44CiogHLcm8DPNYDEz75HAmbquaLVulgXSwoUt3fIX96lEB2f5qHMoDlPFziubLp/RB2K1YFdcQfeY7pn36qnbVm6TJtw9cx2P/Xp3H5b08jq0VbQ6BvBhJnTcH1VE+MeLMfTh+s/Jir0sGSQH0HY6q8YqiMdgNw8f/XaIlRd6ITy//ixZe0s9VsFdE2fjQcpx/5B4rueQCZHq0q1HupbvHVNzHob91xIb/AcNJKUqWC1dnVTY3+Cjj6MwTqZa08XCk0w/SDebhyO4TgetRv8KZLMzyrj1ArSWubzuTmIPZfr+LS31/GOZkqac0A3wwozlhWAwb0Y8fjtc5dtLNVjioNrJd0UWqe6jKhSgkkMDTH4BKYSuASqEBvtSkgUq3N2rZsqXam2qtdi5ci+fF/c3TbBRmyEcMMKA6bcSri0EG83rmzdqaKV6WAFfPSy/g3L/56SBROM7hOITCpDsJl6BYNYGUIVAS1j0tTPBPAuKoOKTU7E5u/mojzX3ylFv2ZhcVR0+DKPxSPoZ0e1M5UsapwsI7s3I67edFXQjriZIdwnCIgKU7CJZ4rl79nBUeqJcmzPvxQO0vdkKwUHf0GR7izZiHTpZF5SG7Acl1csWvrZvzyw/faGStOFQ6WrFJIC4wgFAJVOE6qY3m40szCJVAZABP4LrCcbX4hqsyUGrxjxRkJVF+/3geYPZtQNVBexhwcN2Jyb/Ha7+/Fl+8MRt6Zs9qZK0YVClYPH18s8m6HLAJhAKoErtOEyl64Utn1XQsOw1wPX7Xy4eole+7c1R4pT/V6X3oqgcqlUqAymqyKwKiv8NajFbsiosLAmj1kqFqkdyU4il1gWDFUjsKVwt8REoYxDPy7enprpdcdXb5wAWPefEeDqnI8VSlj+bJZI3//fox67EntKm5cFQKWrFG/hRdXFBpt8FQqtipvtuBK6aAHGE+NbOiFHm38tNLrjgSqsW/102KqKoDKaO30KGjWEgsWL8Kpvfu1q7kxVQhYj3u2xLrWATgTFI4TgQTIAlhiluCSe4fXCNWYxt54oo5CNa5P/6qHSjNJZIK3B6LvI49qV3RjumGwVk6fpqYWLoZE4wS9zkmCZQuuEzRTuASs8yHhmMOYqqunl1Zy3ZFANb7vAA2qyo2pLJrWJWbu3ImpAwdrV+a8bhgs6QIzgiMIk14BI2DZA5fRc8k8Vw7B2tgmUAXqdU2Xzp9HzDsDge9ujqcyNUnjdEnXEcN7v6VdnfO6oZYc3u1JjHdtgcygCCTTWyU7CJe8VmbYJdiXKYW6NvoTqCb0G1SxUMm9xRtIzSS5IxC7Ee8+eGNLm50GS3Ip/IYwnNdFI4mxVTIBEq9lDi5LwbzYeXahUk5KfIJWct3QpaLzmNj/XQ2qiun+strqkK+PVGvtzf3fXstzaYIfZs5E5nHn86s6DdaAP3XBvOZ+SGU3eJxgHXMQLvFS1wjVc6zUOUOGaqXWDV0qKsKkge9VMFShuKKLwjx3d1zrPRhZ7j5mX2ePZbFdMXos3u3WQ7tix+UUWJJKSOKhi/poHGN8JGCVhyvMIlwSX2UHRmC2py96BYdppdYNXSRUkwd9QKi+Q7pLQ2SyXm50aYxAdTk0Ej81aYwzPMeUzg8Df+luWPZs5vU2jaDnsn1/otc6te+A4cIdlFNgDeryIH4k1adNoCoPl07FXSrOKgPXaYKVGhChttLXJSmoBn9YDFUW66PUhlhzjWzDjFAtJFRJ53LVec5dvYLlv+uMQtazs8lN5IY3Rn6B97o/pcp0VA63rKx/+i2BKNJH4WiQHkkc2TkGl6ELfJhlxK1crpVa+3WxsBBT3hsCzCwNVbnd1mYa2ZIZoVpkApVRP8+chdwnnkeWLBY08157LNelEeZMmODUfUSHwRrZ81lMd2uF08HhBCtM2bEO9sOVzhHkfO+2eCnyVq3E2i/Z8vbtBx9pUDUoB1UJXGxQO+Eqhsq1CY5ll4bKqNH3Pgh0edTpZc5ZHr7AnO/xIUf/jsphsG6lp8nRRSKJnieJUIk5AldRSFSd6gIVVB9+TKhmmvVUZU3BZSOroBGqxVagEqXl5mDNXZ2RK6NEZ7pEvqeQg4CR/R3PxeVQCy+OicEQl6ZI0xm8VSm4+LMluE4QrmTCdS44Ep+4eGBi79e0Emu3LhQUYOqQYcAM+6AymjXPZS9URo3u9SLQvZdhe5mZ8mxaE28UzP8Rk/oP1Eq0Tw6B9UiDZtjbLgRJHMkl0AQmI1iW4BKw5CgjwTTGZLKsuC5IQTX0UwXVWX7mDDMAWTKVUdAMXAaoIvCznVAZNS3styhkec4E8tKN4tEe+OCZ57TS7JPdrZyVkoaurKD8sCgkEpAjjsDFv2XzW/aeiyvmjRiplVh7daEgH9M+/oxQzVBQGbPaSEIScyCZs7JwGT3Vz00dg0o0acBgXO/+L+e8lpp6aIBFY8Ygec9erUTbshusca+8jG+btsSJkHAkEigByxpcSSZwJdPSGLTfXge8lSwhmjZsuAZVg5JUSZo5A1expxKoyoz+7NWEkNtRRFCc8lrNJYj/L4Y4EMTb3dLyZCyBJpHQCFimcMnPpnAVx18aXOnBERjZwBPTBg7SSqudupCXjxmffF7OU5U1h+Bqp8clDpaWNnUtN6XgiL5+mXHto885NWkqOb8uRd6Oob1f10qzLbvASkk8giekovSRiA/WI8FBuAr10bV+JKig+nSEguoMP2s6P7+lpG9i9sAlUF1knS9lTJV07sbSEclDVKbrbke+jxP3Edkd5nHQtmz0GBzetMVQoA3Z1dqT+/bFRNcWOM5uMJ4AiR22E65TtPkebTC0W3ettNqn84Rq5vBRbDkDVBmsA2OyEmfhUp6KUC1TUDnvqUw14qlngD8/4lQKJdUdzpyNYc+yDDtkF1g93H2wq12wAuewZvbAdTRQj3y6cXkS19EdO7XSapcksdmsz7/QoGpQDFVx0hIn4DJ6qoqESrR17Trs/v1fkOPd1iw81kxGh9cf7oYPuz2tlWZddoH1e4KRHR6NeI4GjWDZgku6wWPiuVixEp/VRp3PzcXskV8SqumlPFVZcwQuI1TLZUqhAqEyaljYbbgUEq0W9ZkDyKKxOyxwaYwxQ4bCnqQGNlt8/cw56Mdv4qnQcBwgKAomE7MGVwoD98nsQie8XvsmRIsI1ZxRX9uEymj2wGWEakUlQSX67PkXgAefcOo2T25THxwaOx4Lh9ND25BNsMa+/iq+a+aDI4yvDhGWg7RycBG4snDJXFcOK0mC/tO1bBGfgurL0cA0+6AymjW4MuhBLjBsWFnB3V9ZHdq7F6uj70a+E3Naklce4ybig7/bjrNsgvV3Lz9s9w9S3aCAZQ2uBLpyU7hSg8Pxu1rWDRbl5KoHihugKh9T2TLJ61UWrgx/HS6ERmClmlKo/GS0HwRG4CLP6+iclpqFf+QJvP+Q7YGYzVaXSc2MsCjsD9bhoANwJYeE4X9evhjWw/lViNVNhYTqh9HjcN3O7s+SmXquYqjcbmyeyhEN7c4A/L6HDKnCy8Bjy867NMPQ99/VSrIsq2ClHknCM6zAFH049hOq/UF2wEVLIGApjMk+dHHFknExWmk1W0XncvDDmPG4PnUa0lgnZ/kZnc0/L6ZyqWpQrXJrWmVQib4bNQrJv++CnDYBZuGxaBLAN/bCj/3fxZEd1h8OZRWsZWPZnxKO46Fh9Fh6HKDZBRf/f47xwkNsgMK8fK20mitZij1v3ARcmzpVQSWTnypdpUDiJFzp7IbO6yOwmlAdq4Luz1SZWVmYwZFhoROTpTnubZA4YhTmvm89849VsCYN6Idv3FqoLu4Au0IBy1640kIiVJrImq7Cc+cwf/xEBVUqP88ZAUozZ+ESqIp0EfhFQVV1nspU/RgvXeZ1OBxnebXF9bEx+PiVl7WSzMtqy/e//09Y3ao9QQrDrwTJXrgkcN/YpgNeruGrRAWqBTGTCdW3CioByZhd0Fm4jFCtaVb1nspUA267G7jjXnUf0BxAliyTo0kMfA/97/2zVpJ5WQWru0crNW3wK4PUvTRTuFTXaAYuASuJgfssdx/E9HlTK6nmqYBQ/ThxSjmojGDJ0VG4iqFSMdXNg0o09LXeuPbHvzh8e0dyauGBv2HAX6zneLAK1n3i+jki3MuK+5Vey164ToaE4zMXd/z4+QitpJqlguxs/DjpG1xloH7apQHBKUmwawqXI57L1FPdbKhE0z4ahvhb7kGugyND6TovE8Z+ct/RiqyC9TjBSmZl7JGuUEFlHi7TbvEgX3Oa73mN7927eq1WUs1RQRahmjwVV7/9llA1RFpgOCR15dmAELNwydEWXNUNKtHWZSuwJCAKBfRA5gCyaBwZnqfT+Ki/9Yc0WATr/IWLKpFaEofDewiMNbhMYy7xWGf0UWrGPTtNtk/WHAlUP30zjVB9Q6gk5WVJot1UJ+EyQrW2GkElSjt9GhP8g1Hk6K0dglXUyAuj+/VFfmaWVlp5WQTr9NFjeJeVG894aa+ARdtrAtceHmVuyxxcGQRLEvvXJEn399O303BFeaoGhMqYbLcELoPnKkkRbgsuI1TrbnKgbknvt/LHZYKVZQ4gS8YvTKGrD777z0s4ttfyUmWLrX9o6w58zgo+EKLHbkJjDi7xXKZwGbvFrLDoGrUMWXmqqTPoqaaW6v7S6KGchqu9DoUClTuhyq5+UIle8vDBVXaFDoFFK2jmg4WvvI49K1ZrJZWXxdbfvmQ5xjVyxT7CtJvgWILL4LlMvBZfm8oKrSn3CAuysrBo6kx6KlOoDKkrDUCVThFuD1wCVYE+Auurqacy6p8uzQAntuHnN2uFVa+/jQ1zftBKKi+Lrb9hwU/4poEb9mkea5cDcB0LDcP9NQCsAsYIi2Z8h8vs/k4SqlTZ9MEYogQsJ+BqF6Kg2lDNoRL1dGkOhEQ5DpZbK2wY8C5WMR61JIutv2bWD5jRxAO7Q8KLoZLjHitwydSDgJXIuOyBag6WBJ6S3+DyN9/iBLt8WYmhcqEKNBbhkq7RFC6BqQQuBZUuHBuk+6vmUImeaegF6G91GKw8grXpvSFYNmaCVlJ5WQHre8xo7IE9IRHYSYiM3aFNuBj0Ho8yPDewukqgWvrdbFwkVMfpqVIYE0nKyuJEuwKNnXAZn/ljhGpjDYFK9KSLJxB2G8FybDWpeKyNAz/A8rFOgLVh/k+Y3tgduwlMHL/NdsMllf6bO6vtcmQF1ey5CqpjhOpUYAQkKW8K4XAWrjQ2TH4Ng0rUzcUVCI12IsZqjV/6DMDqb6ZrJZWXxdbfyuD9mwZNCRGhYiXaC9de6RLuuEutk69ukmdSL5vzPS5O+YZQNVJQFWcYJCCOwWWIuVLbsWvQRSLW3Y1Q3Zwbys7qEWmj4EiHwSrwaIOfe72ITd/P00oqL4utf2DrdsQ0bIRdDGh3EJod7C5swiVg8bUnWemdGzTRSqoeEqhWzP0vLpmBqjRcutJwlQNLTHveT7tg5IVGYJN7sxoHlehRAYtfDjXd4ABchR6tMbvHs9i3xvKdFYtgnTyShFE88W4G4jsIzY4gPXYSmhK4Qi16rhOMN3q0aKmVdPOloOK367yCytD9lYXKAJYc7YMrld1fXmg4Yj1qJlSif3DQgg56w1Z+gcYeuPj6IrfWGNfzaZzcf1ArqbwsglV44QKGCFi6MGwnOObhKu+5dtOOtg3C64GByDh5Sivt5imPUK3873xcIFRJhOpkkPYAqQ6loTIHV+knZ5hCxe6Pnkq6v+M1FKqM1DT0dWmMqxpY9sIlr7nMGGvI44+i0MpntwiW6C2CtZfxw9ZQvRW4TD0XPRYt3rcDht9xO3YvXamVdHOUl5GBVfN+pKeagqPs/hRUgZIITgPIFlz0WmWf+SNQ5YYypqKnqqlQiXat/AXDmzRXmyoUVHbCJf+/5t4aL3ax/nRWq2C9QLAO6gWscItwxSm4TD1XGPb7B+L7e/+MuUM/1kqqeuWlZ2D1gv8VQ3UiRI9kgUagchKu06xUgWpzDe7+jPr+s88xu7kfCgiWcbNsMVz88liCSza6QheN7u15tCKrYL3q5Y+ksHBsYZy1jXBtM4FruxW4fmVQu+WxJ/Bl71e0kqpWAtWaH39C0eQpSGT3d1weyUJvY0hZ6Rhc6pk/EnOxImWf5BaPmjf6M6ev33oDG1oFIk+CdxOwiuFqT7AEsLJgtQkCejyDh92sP/PIKlhv3Hs/UsIYS7BBthIu8VymcMlI0Rxccf4ByHj5FfRs20ErqeqkoPrfQhTRUxmhUlkFBSRWmDNwneS395x4bdX91Zx5Kmv6d3i0+nznynisUnCZ8VrnfINw9sGH8frd92glmZdVsL7o9w72dQhELLuRrfRQ4rUMcIUqj7XdAly7AkNxLPoWPMtGrUoJVGt/WozCyZORoEFlTP6mEu2awqWBZQuuE+1Ywez+ttXwmKqsVMpO/S1qb6M5sMQUXGUS7eb7hWDjb+7GmLf7aCWZl1WwFnw1Hiu8WxGmMGymx9piAtd2wiXzWwLXdg2unYRrl4JLj/2eLTHs6SdxjqOPqlDe2XSsXfQzCghVPIfRxwiL6VMzzMJFcErBVQYsgSqbo7/aBlVBbi66C1iBEQZ4rJj835jFWQL3C77BGN8+GEvIhjVZBet4QiImNWiEbQIV4ZJYqzRcOnosA1w72Fcb4YojWHtb+WHpv1/AfAaJlS0F1eKlKJg0GYcJVRKvwZgi3CxcAg0rzBpcBk9FqDxrF1SiJWNj8LmLGy7x89oCS0zBxW5RwALteUKZknBUK828rIIl6s9CtgtU4rXMwlXiueTWjxGunb7tkfHxMPS5/z6tpMqRQLXuZ0JFT3VQg8o08ZstuCRNeNln/pxozwpl97ddoMqpHTGVqT56sgdWe/oycC8PkSVTABIuBNmXp9/mK95q2R5HwsOxISTUClz0XGXh4vHYb36LV+7ppJVU8colVOuXLCNUkxRUkhHniEBFkGzBpR6FJ3CxGzd9WlkyocrURWBHLQrUy0oe43dBYJHUSVZirLJ2jnbCNxA9vGw/WtkmWB/3fgXHORLcwKB8E4/m4ZLpiNJwxYVEIK6JF74bPAiJsVu10ipOuenp2ECo8gjVASNUPLfKdOMIXOz6jHAdN4WqFnoqkaSUelI8Dgc2GQRLzF648ll/C9188PXrr2qlWZZNsJZOm4XlzVtiU1AENnJ0aA2uUp6LDbWjVTucmTgFQ56quMfui8RTbVy2ArmTJmE/R38JhErSggtYjsJl7BaPd2Al68Kxo3kzJNdSTyWKeeM1zGjSEgX88stOIpXxxg645CFSV1hXg/klXjdzrlaaZdnuLKnPSPgmwrOJ8cvGEPs91/Z2wUju1AVv//VvWkk3rtyzZ7Fp+UpCNRH7+CEPEyqVPknMSbiSWGkZukjEMaaqzVCJ7mZbysI+yR8vMBnNFlzyP4RE40474iuRXa96x9sfCeERWE+INrEhNjJgtwoX4RO4drDRt7m4Yum4sdi1cKlWmvMSqGJXrkaOCVTGJCQOwcVvqylUZ/Xstpu713qoEnfEGbpB9j5GkEzNGlwqvvILRjd3H60067ILrOFvvIljDN4FrA3iuRyAa2ubdiiMmYhBXR/WSnNOAtXmlb8oqPYSqoMmUNmCS2AqC5ck3ZUc9ALVrlre/Rk1pFt3LPZorW7jWExZSbjKQiUjwkIObGY2boFJfftqpVmXXWAdjU/EnEaNsF66QoKzgY1qhCvWFC424pZgk5iLMCrP5e6N8UM+Bq5d00p0TALVllVrkD1pgoLqEM8vO65lS38psORIgOyBK5GVeJbdX12BShQl3iok0rBT2wJYYmXhkr/J+2R3e0qi9fkro+wCSzSQQfIuvQEqgWujCVybrcHFmGurZyucW7wEwx97XCvNfuWcOYutv6xD9sSJ2MUPtp8DiEMEw5iAxGG4aEdYUWn6SOypQ1DJ42a+buCB86wbtUvbAbiyafn8mzwH3F7Z/cqPX3gBp3R6rGYXp7yWDbjkpnVxtxgUjAMRt2Dky7aHqabKOXMG29YKVBMUVAdYpspwE6hTQFmFi5VhDi7xVGns/hRUtXRKwZxuYf0VcKSeKUBpZi9c0g3ObeqDsTaSrZnKbrBOnTyNOQ0b4Bc2zhp6obJwbSgDl9y0NoUr1s0duRs2Yuw/e2klWpdAtWPdBmRNmIjt9Jb7WVbJbmv74Cr7zJ/DrMgUQrVXRn91CKr/jhih8sHKdEG6TKuUgctW/nnZ1PpXgpnlwH1f+30b1b+ZDw6FR2ING3ltObgksLcM17agUPzasSPG9x2slWZZ0v3tWL8RmRMmYAeh+pWxncoTEWy6ld8xuOJZgakCFUd/J+oQVCLxVnL7xtRb2QuXrHE/7heErg3dtdLsk0NgTRs9FvHt22M1G2odwXEUro1unriyZxdGPP6EVmJ55aadxc4NmxRU2wjVXpZr3LMocJXKbkM7aAdch1g5p8Mi8Ktn3YNqQu/X8LmLBy6x/lSm5jJQGc0cXDKBeolAfkJvtyjG8uZUc3IILNFw0r9RT6gIiyW4JObaYg4u/n+LpxfWrlqFM2ZGF9L9xW3ajPQJMYSqgYLKuPPHEbhUjKXZQVbYKXqqfTJPVcegEqmRoNy+MYHIkpmDS+a8VBkOyuF3DHnyGaSFh2EVwbENFwP5MnBtbtUWGV9/hS97Pq+VaJBAtSt2C9JjYrCFH2QXX1t2z6KA5QhcpaGq+WnBHdWLkbdikaxrZ9CuAnU7zAiXeKtCequ5bi0x8rmeWon2y2Gw8i9fwVQ2/C8cHa7RESxH4eL/1/L92SdPYOFno1SZCqrNhIrdX6xLI7WXsWRzhv1wmcZc+1lBJ/WRCqoTdRCquJXLDTudZd6qTMBuyxSEErQHR6qVEHY97quMHPdx1LudH8SZyAisptdao9MruNYSnHX8vRguBtyb2MBm4SIAu2+5DbGr1uDotu34dUcczrD728SYSlZFWN0QawdcAtUJeqr9dRQqkXRfchvGUsBuzQSsXHq55Z6+GNjlQa1Ex+QUWKkZmfiBF76KDbmWXqsELh4Jj024+LdNzX2QOmY0fj0QT6gmYAOhknuLxvXzlvYsytEYb5mDa29AqILqQB2Gqhfr5QfPNijisWyiXXtMPBxCo3AX27gwJ0cr1TE5BZbo3U5dcDY6EqtCbMAVRLj493JwEaJ1Lo1xYuRIrG/QSEFVdltZ+d3W1uH6NUCH4/pwQuVR50Z/Rs0ZMhT/kO4rNMKQt4uexxG4xFvl8T2LCWb/P3XRSnVcToN1rugCvuMH+IUgCVil4dLZCRePvu2xTRfB2Mu+PYuW4NrNyhOoDnq542QdhSo1PkHlfr3GL6kxF6rKhyrQ2AlXOmGUCVHZxXP10mWtZMflNFiiD/7WHRmR4Vipea0SuBig2wMXf99KYAQw4xLn4j2L/JD2wrWLlZZEOA961V1PdfXiJUQShjR2Y5mEQ/KhOgqXeKsLrM9JTbzxWfcbW5x5Q2CJRvDDbAsLx5pynqs8XHLrxyxc9FCGWz+GzRnGPYvG9fPm4BKwxOL4GoHqUB32VCLJR7a5dQDyOXgxZBl0Dq5CguXMvFVZ3XAJMyZNQXJbXyxlYxvBKgvXeofhoudiRQhc1jzXLlbe0TCBygMnc+suVF09vTHXozUus56KMzc7CJcK2IMj1NauVdMtJ621VzeOJtW3jR9OdYxW0w/m4JKb1hvKwSXzXqXhKlkoWNpzme5Z3EWoBK4drLRExlTxdRyqJ1j3Yxq1wDVCURYqe+EyBuyxPgF4zLNi8ppVCFipWTn4nqSv09FDmYBlGy6Z9zLAJcF86VWoBriKN2eYwGWE6rC3J07V4e6vO6Ea2VBSakciRVIssY7MpQgvC5e5Z/7IZGg02/BCfoFW+o2pQsASfTVgMC++PZYGle4SbcFl2JyhswKXyc4fVsBWVsphfSQSvD3qNFRdPb0wprEXgQhXqZaMSeEk5ZIjcKkuMCQCrxAqmaqoKFUYWKI+7Tvg7C3RpUaJxXCxmzTGXObhMlkoaAYu6Ra3CFT0igJVXQ3UZfQngfpcD1/V/aUQFkOi3RK4JOmu2YcbaF2lKVwSrC/39kd3H9ubUB1RhYKVfx0Yxw+9KyKy1PyWAkuOGlzmPZfsWbTkucIQGxKCQ/RUiXXYU6UeOqymFGJbB+IC68yQvtI0i7MBLsn2bM/TyjJpWQRLyqxoVXiJ6zZvxg7PpsUz8pbgEs8lYNnjuTazG4yPjMZRf1/UrAfVVZykm5JJy9OEJjeQUBV7JyNckntewCqBy+C5LMMFXaTyfkd27tDOUnGqeFSpT557HplBHbAkKNQGXIab1gou/m5tQ6zAlX9bNPbffz+cu3tVc9WLn/05AnAlNJLdl8RRhEZ5K1OzH640ggXWt0wtxLxk/zp2R1QpYIn6RnREflQEg3lbcJl4LoFLPFdomT2LrFjZ+bOOrvtYGCvLqxnily7TzlR7JUtfJLPLHE8/XGeAbd/DDQQuw8MNSsNl8FLira6zPr9q5IUXdVHamSpelQaWqH/Lljh7azSWl5k8dRYuuf0TSw8mt4AK/dtgd6f7kXn5ina22qWXIm/Fw4QqLSAC2fJYFkJ0mmA4+uQMU7gEqgv0/j97+aGzazPtTJWjSgXrPE3yPhzr2NH8SLEYLjmah8vcnkUZKa4L1CEpnBXn7orNb7+DC4ZT1nhN7P2q8lLzm7ell4omTOGGNJbqKN2gvXCV91x5fP3ONoGGxXuVrEo/w6lzuZjED5LQMcohuAyrUM3DpdbP8zWbxYMFhyJLp8N+j2ZY9VnNfGq+aN6IESo4/9TFA+eDo5BBL3WSwJimrlSZBgmI/XAZPJeMEHMY8B/yD1WToBcLCrWzVp4qH10q4XQqZvIDHYy2MMel498IjcBVfs+ijW1l/D2WcZzMc+XrQ7DR1RX/7TcIRdq5q7tkh7IA9Z6LK84GRSAnOFIlgLOUxdlg9sOVSrBy6N2PtNeraQV5/EtVqErAEh08fgqz+cHioy15LoHL4LnWOQGXJCGJZUXv5N8LwvRYzXNNe+ppbIrdpl1B9VHi9p34qFt31eWNdGmOdHphAeoUgRKPpFJWCkAW4FIpwvk6W3DJPJd0f4f8gxVUsrWuqlRlYInEc8lGjKRbOloI6AmXAou/OwHXdsK1na/bzAqXG9fpYXT/3t4Y1cwdn7/SG4cPJmhXUvU6FZ+ACa+/pp7j2IM2z7MNCnXRSOdoTxLqSi7UZA0qo1mDS8zao/BSO+hRyFBih2+wAjg/I0u7kqpRlYIlOpmdg6/4QdNuibYwFWEdLsNNa0tw6QmX3nBvkbaNFb6NlR3P9+bSiy1s2gRv89wDuvfA/NHjkJdXeWviC/PysGRcDIb16KEevC6ZWia7tsBxaXAO808Hl2QUlOMJSVkZVDqLs7Nwyf3Cq/SAi738cQfPWxUxVVlVOVgiuX/+kY8P8qMj8LMFuAxdojW4GMjbgEtMUlbuZMNtZ4XvlliDr8/Q67DCq5V6ulk3Wq+IWzC6z1uYx+B/7+q1yDpj//x+dtoZ7F21BguGj0BMnzfxcsStqjEfokm+hIXNfZHG8+fqIg0w8TokL5cx8ZsRLslL7wxchhGjwGToFgUs2QjxZSMvdHF1066y6nVTwDLq/ahbURASgBUEwXQFanm4TLaV2QGXWj9fDFfJQkHZnLGLDRdH20OT/Yen9ZHqAU6rfPwwpYkXBhMImeWWh6ULILJTpZP2uzznWp7OLx5I1pbL3yUR/2u04S7umOXmg1jfDkgPZRDOctN4Lcd5TZKX6ygBlzRKxXm6zMClHstiBi57HssicMmM+/WQSDWj/iJBvpm6qWCJRvV8AYe93LE1LKJcUG+Ey6E9i6ZwBWvr58vAVWr9PP8nto9/P8jXHOFrkkPpXdgwGWFRSNGz0VlmAl97hA1+gtCk6aOQRcukSe7SVF0E4QxHEl8nqSklCUkCy0xU5Rl+L5dRsALhkmmJrEBeF01yWFXWbRpHdNPBEq3btAmLWCGnOkaV6xpLw1WyIkLBxb87D5f5PYuylWwvvYuYPJXfNMONMnanahs/yztAO0STFJXGfBHqyPeZpk8ywnXUDFzmsjgb4AqzCZfBU4XjSkgUFnu3U3NUR3Zu12r15qpagCXKuHoNXwYEoiA0AKsIhuky5xK4eDSFi43gCFyObiszJiOxlj7pAM00CYktuMp7LvMpwm3BJV7qLH+WydSXCFSPCl5PdaOqNmAZNeWdd7GzkQsSoyKxhJWqZuatwCWz80a4BCoFF383biszBPQl28qcgcvSVn5bcCUw7rEHrqMcxVmFS01FmIBFu0Qvtc4n0HCTemjFrfysKFU7sERJGdmY7B+A/KD2WEegJLi3BddG/n2Tqefi77LcRuCSe4s3ApcCzAxc1tInGeGy23Mx3rIIFwE1zHOFIzsoAllBkfg3gXrcs2WFrVGvaFVLsIyaP34CfmEFZkSFYxnhKp2EpPyeRYGrVLcoUBEiQ5dYsvNHxVxqGsIIl2Hnj224BCpTuHQq1rIKF99nzCpoBEtMcqOWhcvSkzMErjPipThQGO/aUnmpldOna7VUPVWtwRLJqoUZTz6D+MYNkRQepvYvrhKoOAoTuBzfs+jYhlibnovdtV1wifHnUnDxb9Y8lxxl7uuSPhoLPP3UqoTh3Sr28TGVpWoPllEn84vwY9eHkOzWBIkEbBkbVxLtSrdobVuZEa7SmzMs7Vm0F64ynssGXOpnvs8cXDIlYc5zpfJzXNR3xE/N/dQUQv9OnW8ol0JVq8aAZVRCWjqWPPIYjjZuhORwPVaxcZYHGZ6aYQkuFdSXg0u2lZX2XKYbYq3BJV7rV763IuBSXST/JhOox3lMpyfOCY3EdLdW+C2BGtTlQadTCd1M1TiwjDp98TJW9PoPdjZsgGxdMAHSYQUbVu4zigczxFyO7Vk0B1ecKVz8vyW41EjRDFxGsMzBlcjXHuXxBK8rXx+Ffe1CMMTFVWU5Htmzp1OZ9KqLaixYRl2i/TJ6HNaEhCKjpReS9YSJjSxJ4daz8TfIcppQk4WCpeCS6YjScEm8ZRUumrNwqYlU/k+6vxM8R7bcTuJ7prr5qDzqDzd0x+KYGMMHq+Gq8WCZ6sDxE9j4Rh+sb9kC59r44LgulCNABvts7LU8ytP4N9MELpnnMgsXuySbcPG11uAydosClRzFU8ltoRSeLyc8GnHtgjHRtYVa8fBH2rhXXkZWStU8lL2qVKvAMtXu/YcQO2AgNnXsiMMcUZ4L7oAjISHYRc+2gY2/ng2+MVBnCOwFNA0umYowhUugMlqpmEvg0qwYLgGKr0ugyc3nNF0EssOisdM/GLPcfdDPpYG6qd3DvRUm9+2LlMQj2tXWPtVasEwlz6Bf991cbOvTFxtvvRWb2biZfq2RGRzI+CYY8ewuxTPt4FFyQ8hW/q0cmclSm60B9GQB9HyBNB7jCOMe/l9m5PfTDvH/R4IiVNx0kh5pZ9sAzGjmg/cZK/2d55Flx3/38sOY117F+plzDBdUB1QnwDKnOHq0NTGTsaH/QKx59HGsiorCksauWEcQ4tya4XALbxxv3Qopbf1wpn07pHVoh1Pt/ZHg54u4lj5Y08wD3zdogi/5+rdoMhPe07MN+tzXCZP6v4NlYycg9UiSdra6pzoLljWlFRRif3wiYjdswYqflmDR3AX437TZ+GnaHCz9YQHWLFqKuNhtSDpyFPnnL2rvqpep6sGqV6WoHqx6VYrqwapXpagerHpViurBqlelqB6selWCgP8H0vxXZO18UWEAAAAASUVORK5CYII="
    placeholderImage = syn.crypt.base64.decode(placeholderImage)

	function draw:Image(imagedata, x, y, w, h, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Image")
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = Vector2.new(w, h)
		object.Opacity = opacity 
		object.Data = imagedata or placeholderImage
		return object
	end

	function draw:Text(text, font, x, y, size, centered, color, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Text")
		object.Text = text
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = size
		object.Center = centered
		object.Color = self:VerifyColor(color)
		object.Opacity = opacity 
		object.Outline = false
		object.Font = font
		return object
	end

	function draw:TextOutlined(text, font, x, y, size, centered, color, color2, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Text")
		object.Text = text
		object.Visible = visible
		object.Position = Vector2.new(x, y)
		object.Size = size
		object.Center = centered
		object.Color = self:VerifyColor(color)
		object.Opacity = opacity 
		object.Outline = true
		object.OutlineColor = self:VerifyColor(color2)
		object.Font = font
		return object
	end

	function draw:Triangle(pa, pb, pc, color, filled, opacity, visible)
        if filled == nil then filled = true end
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		color = color or { 255, 255, 255, 1 }
		local object = self:Create("Triangle")
		object.Visible = visible
		object.Opacity = opacity
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

	function draw:CircleOutline(x, y, size, thickness, sides, color, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Circle")
		object.Position = Vector2.new(x, y)
		object.Visible = visible
		object.Radius = size
		object.Thickness = thickness
		object.NumSides = sides
		object.Opacity = opacity 
		object.Filled = false
		object.Color = self:VerifyColor(color)
		return object
	end

	function draw:Circle(x, y, size, thickness, sides, color, opacity, visible)
        if visible == nil then visible = true end
        if opacity == nil then opacity = 1 end
		local object = self:Create("Circle")
		object.Position = Vector2.new(x, y)
		object.Visible = visible
		object.Radius = size
		object.Thickness = thickness
		object.NumSides = sides
		object.Opacity = opacity 
		object.Filled = true
		object.Color = self:VerifyColor(color)
		return object
	end
end

-- Font (done)
-- Manages fonts
do
    local hook = BBOT.hook
    local log = BBOT.log
	local font = {
		registry = {}
	}
    BBOT.font = font
    font.registered = {}

    local defaults = Font.ListDefault()
    for i=1, #defaults do
        local font = defaults[i]
        local font_object = Font.GetDefault(font)
        if not font_object then continue end
        font.registered[font] = font_object
    end

    function font:Register(font_name, font_data, pixel_size)
        local font_object = Font.Register(font_data, pixel_size)
        log(LOG_DEBUG, "Created font '" .. font_name .. "' with pixel-size '" .. pixel_size .. "'")
        self.registered[font_name] = font_object
        return font_object
    end

    function font:Create(category, font, size)
        local reg = self.registered[font]
        if not reg then return end
        log(LOG_DEBUG, "Created font-manager '" .. category .. "' with font '" .. font .. "' and size '" .. size .. "'")
        self.registry[category] = {font, size}
    end

    function font:Get(category)
        local reg = self.registry[category]
        if not reg then return end
        local font_object = self.registered[reg[1]]
        if not font_object then return end
        return font_object, reg[2]
    end

    function font:GetTextBounds(category, text)
        local font_registry = self.registry[category]
        if not font_registry then return end
        local font, size = font_registry[1], font_registry[2]
        local font_object = self.registered[font]
        if not font_object then return end
        return font_object:GetTextBounds(size, text)
    end

    function font:ChangeFont(category, new)
        if not self.registered[new] then return end
        log(LOG_DEBUG, "Changed font-manager '" .. category .. "' to '" .. new .. "'")
        local old = self.registry[category][1]
        self.registry[category][1] = new
        hook:Call("OnFontTypeChanged", category, old, new)
    end

    function font:ChangeSize(category, new)
        log(LOG_DEBUG, "Changed font-manager size '" .. category .. "' to '" .. new .. "'")
        local old = self.registry[category][2]
        self.registry[category][2] = new
        hook:Call("OnFontSizeChanged", category, old, new)
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
            if self.__INVALID then return end
            local last_trans, last_zind, last_vis = self._opacity, self._zindex, self._visible
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
                self._opacity = self.parent._opacity * self.opacity
                self._zindex = self.parent._zindex + self.zindex + (self.focused and 10000 or 0)
            else
                self._enabled = self.enabled
                self._visible = self.visible
                self._opacity = self.opacity
                self._zindex = self.zindex + (self.focused and 10000 or 0)
            end

            if self._enabled and gui:IsValid(self) then
                self:InvalidateLayout()
            end

            if last_trans ~= self._opacity or last_zind ~= self.zindex or last_vis ~= self._visible then
                local cache = self.objects
                for i=1, #cache do
                    local v = cache[i]
                    if v[1] and draw:IsValid(v[1]) then
                        local drawing = v[1]
                        drawing.Opacity = v[2] * self._opacity
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
                local c=0
                for i=1, #parent_children do
                    local v = parent_children[i-c]
                    if v == object then
                        table.remove(parent_children, i-c)
                        c=c+1
                    end
                end
                self.parent:Calculate()
                self.parent = nil
                self:Calculate()
            elseif object then
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
                self:Calculate()
            end
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
                    v[2] = object.Opacity
                    v[3] = object.ZIndex
                    v[4] = object.Visible
                    return object
                end
            end
            self.objects[#self.objects+1] = {object, object.Opacity, object.ZIndex, object.Visible}
            object.Opacity = object.Opacity * self._opacity
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
            self.__INVALID = true
            self:SetParent(nil)
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
        end
        function base:GetAbsoluteOpacity()
            return self._opacity
        end
        function base:GetOpacity()
            return self.opacity
        end
        function base:SetOpacity(t)
            self.opacity = t
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
            opacity = 1,
            _opacity = 1,
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
            data.object:SetOpacity(data.origin + (diff * fraction))
        end

        function gui:OpacityTo(object, opacity, length, delay, ease, callback)
            for i=1, #ScheduledObjects do
                local v = ScheduledObjects[i]
                if v.type == "OpacityTo" and v.object == object then
                    table.remove(ScheduledObjects, i)
                    break
                end
            end

            ScheduledObjects[#ScheduledObjects+1] = {
                object = object,
                type = "OpacityTo",

                starttime = tick()+delay,
                endtime = tick()+delay+length,

                origin = object:GetOpacity(),
                target = opacity,

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

    hook:Add("WheelForward", "BBOT:GUI.Input", function()
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if gui:IsValid(v) and v._enabled then
                if v.WheelForward then
                    v:WheelForward()
                end
            end
        end
    end)

    hook:Add("WheelBackward", "BBOT:GUI.Input", function()
        local reg = gui.registry
        for i=1, #reg do
            local v = reg[i]
            if gui:IsValid(v) and v._enabled then
                if v.WheelBackward then
                    v:WheelBackward()
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

-- Init, tell all modules we are ready
do
    BBOT.hook:Call("PreInitialize")
    BBOT.hook:Call("Initialize")
    BBOT.hook:Call("PostInitialize")
end

end

local ran, err = xpcall(ISOLATION, debug.traceback, BBOT)
if not ran then
    BBOT.log(LOG_ERROR, "Error loading Bitch Bot -", err)
end