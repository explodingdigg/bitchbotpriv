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
--[[
	Next on da list
	Bad Business
]]

local _BBOT = _G.BBOT
local username = (BBOT and BBOT.username or nil)
if BBOT and BBOT.__init then
	BBOT = nil
end

--[[
	version numbers go as so
	0.0.0a
	digit 1. Major Update
	digit 2. Minor Update
	digit 3. Major Patch
	letter 4. Minor Patch
]]
local BBOT = BBOT or { username = (username or "dev"), alias = "Bitch Bot", version = "3.0.0 [BETA]", __init = true } -- I... um... fuck off ok?
_G.BBOT = BBOT

while true do
	if game:IsLoaded() then
		break
	end;
	wait(.25)
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

	local err = 1.0E-10;

	-- ax + b (real roots)
	function math.linear(a, b) -- do I even need this?
		return -b / a;
	end
	
	-- ax^2 + bx + c (real roots)
	function math.quadric(a, b, c)
		local k = -b / (2 * a);
		local u2 = k * k - c / a;
		if u2 > -err and u2 < err then
			return;
		else
			local u = u2 ^ 0.5;
			return k - u, k + u;
		end
	end
	
	-- ax^3 + bx^2 + cx + d (real roots)
	function math.cubic(a, b, c, d)
		local k = -b / (3 * a);
		local p = (3 * a * c - b * b) / (9 * a * a);
		local q = (2 * b * b * b - 9 * a * b * c + 27 * a * a * d) / (54 * a * a * a);
		local r = p * p * p + q * q;
		local s = r ^ 0.5 + q;
		if s > -err and s < err then
			if q < 0 then
				return k + (-2 * q) ^ 0.3333333333333333;
			else
				return k - (2 * q) ^ 0.3333333333333333;
			end
		elseif r < 0 then
			local m = (-p) ^ 0.5
			local d = math.atan2((-r) ^ 0.5, q) / 3;
			local u = m * math.cos(d);
			local v = m * math.sin(d);
			return k - 2 * u, k + u - 1.7320508075688772 * v, k + u + 1.7320508075688772 * v;
		elseif s < 0 then
			local m = -(-s) ^ 0.3333333333333333;
			return k + p / m - m;
		else
			local m = s ^ 0.3333333333333333;
			return k + p / m - m;
		end
	end
	
	-- ax^4 + bx^3 + cx^2 + dx + e (real roots)
	local quadric, cubic = math.quadric, math.cubic
	function math.quartic(a, b, c, d, e)
		local k = -b / (4 * a);
		local p = (8 * a * c - 3 * b * b) / (8 * a * a);
		local q = (b * b * b + 8 * a * a * d - 4 * a * b * c) / (8 * a * a * a);
		local r = (16 * a * a * b * b * c + 256 * a * a * a * a * e - 3 * a * b * b * b * b - 64 * a * a * a * b * d) / (256 * a * a * a * a * a);
		local h0, h1, h2 = cubic(1, 2 * p, p * p - 4 * r, -q * q);
		local s = h2 or h0;
		if s < err then
			local f0, f1 = quadric(1, p, r);
			if not f1 or f1 < 0 then
				return;
			else
				local f = f1 ^ 0.5;
				return k - f, k + f;
			end
		else
			local h = s ^ 0.5;
			local f = (h * h * h + h * p - q) / (2 * h);
			if f > -err and f < err then
				return k - h, k;
			else
				local r0, r1 = quadric(1, h, f);
				local r2, r3 = quadric(1, -h, r / f);
				if r0 and r2 then
					return k + r0, k + r1, k + r2, k + r3;
				elseif r0 then
					return k + r0, k + r1;
				elseif r2 then
					return k + r2, k + r3;
				else
					return;
				end
			end
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

	function color.darkness(col, scale)
		local h, s, v = Color3.toHSV(col)
		return Color3.fromHSV(h, s, v*scale)
	end

	function color.tohex(col)
		return string.format("#%02X%02X%02X", col.r * 255, col.g * 255, col.b * 255)
	end
end

-- Vector
do 
	local vec0 = Vector3.new()
	local dot = vec0.Dot
	local math = BBOT.math
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
	function vector.dist2d ( pos1, pos2 )
		local dx = pos1.X - pos2.X
		local dy = pos1.Y - pos2.Y
		return math.sqrt ( dx * dx + dy * dy )
	end

	-- creates a random point around a sphere
	function vector.randomspherepoint(radius)
		local theta = math.random() * 2 * math.pi
		local phi = math.acos(2 * math.random() - 1)
		return Vector3.new(radius * math.sin(phi) * math.cos(theta), radius * math.sin(phi) * math.sin(theta), radius * math.cos(phi))
	end
end

-- Physics
do
	local vec0 = Vector3.new()
	local dot = vec0.Dot
	local vector = BBOT.vector
	local math = BBOT.math
	local physics = {}
	BBOT.physics = physics

	-- Used to determine the domain of time, of a bullet
	function physics.timehit(pos_f, v_i, g, pos_i)
		local delta_d = pos_f - pos_i;
		local roots = { math.quartic(dot(g, g), 3 * dot(g, v_i), 2 * (dot(g, delta_d) + dot(v_i, v_i)), 2 * dot(delta_d, v_i)) };
		local min = 0;
		local max = (1 / 0);
		for v37 = 1, #roots do
			local t = roots[v37];
			local t_max = (delta_d + t * v_i + t * t / 2 * g).magnitude;
			if min < t and t_max < max then
				min = t;
				max = t_max;
			end;
		end;
		return min, max;
	end;

	-- used to find a unit vector of theta in projectile motion of a 3D space
	function physics.trajectory(pos_i, g, pos_f, v_i)
		local delta_d = pos_f - pos_i
		g = -g
		local r_1, r_2, r_3, r_4 = math.quartic(dot(g, g) / 4, 0, dot(g, delta_d) - v_i * v_i, 0, dot(delta_d, delta_d))
		if r_1 and r_1 > 0 then
			return g * r_1 / 2 + delta_d / r_1, r_1
		end;
		if r_2 and r_2 > 0 then
			return g * r_2 / 2 + delta_d / r_2, r_2
		end;
		if r_3 and r_3 > 0 then
			return g * r_3 / 2 + delta_d / r_3, r_3
		end;
		if not r_4 or not (r_4 > 0) then
			return;
		end;
		return g * r_4 / 2 + delta_d / r_4, r_4
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
				local _name, func = v[1], v[2]
				if not func then 
					table.remove(tbl, k); c = c + 1; tbln[_name] = nil
				else
					if not _name then 
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
	--[[
	function original_func = hook:bindFunction(function func, string name, any extra)
	- Automatically hooks a function and adds it to the hook registry
	- hooks called: Pre[name], Post[name]
		- Pre: ran before the function, use this for pre stuff
		- Post: ran after the function, use this for post stuff

	function original_func = hook:bindFunctionReturn(function func, string name, any extra)
	- Automatically hooks a function and adds it to the hook registry with return override capabilities
	- hooks called: Suppress[name], Pre[name], Post[name]
		- Suppress: ran before the function, by returning true, you will prevent anything else from running
		- Pre: ran before the function, by returning values in table format will override the inputs to the function
			ex: return {networkname, arguments_of_network}
		- Post: ran after the function, use this for post stuff
	]]

	function hook:bindFunction(func, name, extra)
		local t = {self, func, name, extra}
		t[2] = hookfunction(func, function(...)
			if t[1].killed then return end
			local extra_add = {}
			if t[4] ~= nil then
				extra_add[1] = t[4]
			end
			local vararg = {...}
			for i=1, #vararg do
				extra_add[#extra_add+1] = vararg[i]
			end
			t[1]:CallP("Pre" .. t[3], unpack(extra_add))
			local a, b, c, d, e, f = t[2](...)
			local args = {a, b, c, d, e, f}
			if t[4] ~= nil then
				table.insert(args, 1, t[4])
			end
			for i=1, #vararg do
				args[#args+1] = vararg[i]
			end
			t[1]:CallP("Post" .. t[3], unpack(args))
			return unpack(args)
		end)
		return t[2]
	end

	function hook:bindFunctionReturn(func, name, extra)
		local t = {self, func, name, extra, false}
		t[2] = hookfunction(func, function(...)
			if t[1].killed then return end
			local extra_add = {}
			if t[4] ~= nil then
				extra_add[1] = t[4]
			end
			local vararg = {...}
			for i=1, #vararg do
				extra_add[#extra_add+1] = vararg[i]
			end
			if not t[5] then
				t[5] = true
				local s = t[1]:CallP("Suppress" .. t[3], unpack(extra_add))
				t[5] = false
				if s then return end
			end
			local override = t[1]:CallP("Pre" .. t[3], unpack(extra_add)) or vararg
			local a, b, c, d, e, f = t[2](unpack(override))
			local args = {a, b, c, d, e, f}
			if t[4] ~= nil then
				table.insert(args, 1, t[4])
			end
			for i=1, #override do
				args[#args+1] = override[i]
			end
			t[1]:CallP("Post" .. t[3], unpack(args))
			return unpack(args)
		end)
		return t[2]
	end
	hook:Add("Unload", "Unload", function() -- Reloading the cheat? no problem.
		for i=1, #connections do
			connections[i]:Disconnect()
		end
		hook.killed = true
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

	hook:bindEvent(runservice.Stepped, "Stepped")
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
		loop:KillAll()
	end)
	function loop:KillAll()
		local tbl = self:GetTable()
		for k, v in pairs(tbl) do
			self:Stop(k)
		end
	end
	function loop:IsRunning(name)
		return self.registry[name].running
	end
	function loop:Create(name, func, waitt, ...)
		local loops = self.registry
		if loops[name] ~= nil then return end

		log(LOG_DEBUG, 'Creating loop "' .. name .. '"')
		local isuserdata = (type(wait) == "userdata")

		loops[name] = {
			running = false,
			destroy = false,
			Loop = coroutine.create(function(...)
				local loop_data = loops[name]
				while true do
					if loop_data.running then
						local ran, err = xpcall(func, debug.traceback, ...)
						if not ran then
							loops[name].destroy = true
							log(LOG_ERROR, "Error in loop library - ", err)
							break
						end
					end
					if loop_data.destroy then break end
					if isuserdata then waitt:wait() else task.wait(waitt) end
				end
			end)
		}
	end
	function loop:Run(name, func, waitt, ...)
		local loops = self.registry
		if loops[name] == nil then
			if func ~= nil then
				self:Create(name, func, waitt, ...)
			end
		end
		
		log(LOG_DEBUG, 'running loop "' .. name .. '"')

		loops[name].running = true
		local succ, out = coroutine.resume(loops[name].Loop)
		if not succ then
			log(LOG_ERROR, "Error in loop service - " .. tostring(name) .. " ERROR: " .. tostring(out))
		end
	end
	function loop:Stop(name)
		local loops = self.registry
		if loops[name] == nil then return end

		log(LOG_DEBUG, 'Stopping loop "' .. name .. '"')

		loops[name].running = false
	end
	function loop:Remove(name)
		local loops = self.registry
		if loops[name] == nil then return end
		self:Stop(name)
		log(LOG_DEBUG, 'Removing loop "' .. name .. '"')
		loops[name].destroy = true
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

	function timer:Step()
		local c, ticks, timers = 0, tick(), self.registry

		self.incalls = true
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
		self.incalls = false
		
		for i=1, #self.ToRemove do
			local t, index = self:Get(self.ToRemove[i])
			if t then
				table.remove(self.registry, index)
				log(LOG_DEBUG, "Removed timer '" .. t.identifier .. "'")
			end
		end
		
		self.ToRemove = {}
		
		for i=1, #self.ToCreate do
			self:Create(unpack(self.ToCreate[i]))
		end
		
		self.ToCreate = {}
	end
	
	local runservice = BBOT.service:GetService("RunService")
	loop:Run("BBOT:Timer.Step", function()
		timer:Step()
	end)
end

-- Extras
do
	local hook = BBOT.hook
	local extras = {}
	BBOT.extras = extras

	local PingStat = BBOT.service:GetService("Stats").PerformanceStats.Ping
	local current_latency = 0
	hook:Add("RenderStep.Last", "BBOT:extras.getlatency", function()
		current_latency = PingStat:GetValue() / 1000
	end)

	function extras:getLatency()
		return current_latency
	end
end

-- Draw-Dyn
do
	local hook = BBOT.hook
    local draw = {}
    BBOT.draw = draw
    draw.registry = {}
    draw.classes = {
        ["Line"] = LineDynamic.new,
        ["PolyLine"] = PolyLineDynamic.new,
        ["Text"] = TextDynamic.new,
        ["Circle"] = CircleDynamic.new,
        ["Circle2P"] = Circle2PDynamic.new,
        ["Rect"] = RectDynamic.new,
        ["Gradient"] = GradientRectDynamic.new,
        ["Image"] = ImageDynamic.new,
    }

    draw.point_registry = {}
    draw.point_classes = {
        ["Point"] = Point.new,
        ["Point2D"] = Point2D.new,
        ["Point3D"] = Point3D.new,
        ["PointInstance"] = PointInstance.new,
        ["PointMouse"] = PointMouse.new,
        ["PointOffset"] = PointOffset.new,
    }

    -- Seems a bit overdone but ok
    do
        local draw_meta = {}
        draw.draw_meta = draw_meta

        function draw_meta:IsPoint()
            return false
        end

        -- Since it is reference based :)
        local registry = draw.registry
        function draw_meta:Remove()
            self.__INVALID = true
            self.dynamic.Visible = false
            self.dynamic = nil
            for i=1, #registry do
                local v = registry[i]
                if v == self then
                    table.remove(registry, i)
                    break
                end
            end
        end
    end

    do
        local point_meta = {}
        draw.point_meta = point_meta

        function point_meta:IsPoint()
            return true
        end

        -- Since it is reference based :)
        local registry = draw.point_registry
        function point_meta:Remove()
            self.__INVALID = true
            self.point = nil
            for i=1, #registry do
                local v = registry[i]
                if v == self then
                    table.remove(registry, i)
                    break
                end
            end
        end
    end

    -- Hello are you around?
    function draw:IsValid(object)
        return object and not object.__INVALID
    end

    -- construct a dyn object
    local uniqueid = -1

    function draw:CreatePoint(class, ...)
        local object_generator = self.point_classes[class]
        if not object_generator then return end
        uniqueid = uniqueid + 1
        local meta = self.point_meta
        local object = setmetatable({
            point = object_generator(...),
            uniqueid = uniqueid,
            class = class,
        }, {
            __index = function(self, key)
                return meta[key] or self[key]
            end,
            __tostring = function(self)
                return "Point: " .. self.class .. "-" .. self.uniqueid
            end
        })
        local registry = draw.point_registry
        registry[#registry+1] = object
        return object
    end

    function draw:Create(class, pointclass, ...)
        local object_generator = self.classes[class]
        if not object_generator then return object end
        local point = self:CreatePoint(pointclass, ...)
        uniqueid = uniqueid + 1
        local meta = self.draw_meta
        local object = setmetatable({
            dynamic = object_generator(point.point),
            point = point,
            uniqueid = uniqueid,
            class = class,
        }, {
			__index = function(self, key)
                if key == "Position" then
                    return self.point.Point.Point
                end
                return meta[key] or self[key]
            end,
            __newindex = function(self, key, value)
                if key == "Position" then
                    self.point.Point.Point = value
                end
                self[key] = value
            end,
			__tostring = function(self)
				return "Draw: " .. self.class .. "-" .. self.uniqueid
			end
		})
        local registry = draw.registry
        registry[#registry+1] = object
        return object
    end

    -- Allow hot-loading the script over and over...
    hook:Add("Unload", "BBOT:Draw.Remove", function()
        local registry = draw.registry
        for i=1, #registry do
            local v = registry[i]
            if v.__INVALID then continue end
            v:Remove()
        end

        registry = draw.point_registry
        for i=1, #registry do
            local v = registry[i]
            if v.__INVALID then continue end
            v:Remove()
        end
    end)
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
	local timer = BBOT.timer
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

	function config:SetPriority(pl, level)
		local last = self.priority[pl.UserId]
		local new = tonumber(level)
		self.priority[pl.UserId] = new
		writefile(self.storage_pathway .. "/priorities.json", httpservice:JSONEncode(self.priority))
		hook:Call("OnPriorityChanged", pl, last, new)
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
		local isabsolute = steps[#steps]
		if isabsolute == true then
			for i=1, #steps-1 do
				if pathway[i] ~= steps[i] then
					return false
				end
			end
			if #pathway ~= #steps-1 then return false end
		else
			for i=1, #steps do
				if pathway[i] ~= steps[i] then
					return false
				end
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
	local valuetypetoconfig = {
		["KeyBind"] = function(reg)
			if reg.value ~= nil then
				return reg.toggle
			else
				return true
			end
		end,
		["ComboBox"] = function(reg)
			local t, v = {}, reg.value
			for i=1, #v do local c = v[i]; t[c[1]] = c[2]; end
			return t
		end,
		["ColorPicker"] = function(reg) return Color3.fromRGB(unpack(reg.value)), (reg.value[4]or 255)/255 end,
	}

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
					local valuet = valuetypetoconfig[s.type]
					if valuet then
						return valuet(s)
					end
					return s.value
				end
				return s
			end
			if reg.type and reg.type ~= "Button" then
				local valuet = valuetypetoconfig[reg.type]
				if valuet then
					return valuet(reg)
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
		["ColorPicker"] = function(v)
			if not v.color[4] then
				v.color[4] = 255
			end
			return {type = "ColorPicker", value = v.color}
		end,
		["ComboBox"] = function(v) return {type = "ComboBox", value = v.values} end,
	}

	config.unsafe_paths = {}

	-- Converts a setup table (which is a mix of menu params and config) into a config quick lookup table
	function config:ParseSetupToConfig(tbl, source, path)
		path = path or ""
		for i=1, #tbl do
			local v = tbl[i]
			if v.content or v[1] then
				local ismulti = typeof(v.name) == "table"
				for i=1, (ismulti and #v.name or 1) do
					local name = (ismulti and v.name[i] or (v.Id or v.name))
					source[name] = {}
					self:ParseSetupToConfig((ismulti and v[i].content or v.content), source[name], path .. (path ~= "" and "." or "") .. name)
				end
			elseif v.type and self.parsertovalue[v.type] then
				if not v.name then v.name = v.type end
				local name = v.Id or v.name
				local _path = path .. (path ~= "" and "." or "") .. name
				local conversion = self.parsertovalue[v.type]
				if conversion then
					source[name] = conversion(v)
					if v.unsafe then
						config.unsafe_paths[#config.unsafe_paths+1] = _path
					end
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
		self._base_registry = table.deepcopy(reg)
	end

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
							V = val
						}
					elseif value.type == "ColorPicker" then
						config:GetTableValue(reg, unpack(pathway))[optionname] = {
							T = "ColorPicker",
							V = val
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
			if v:match("^.+(%..+)$") ~= ".bb" then
				table.remove(list, i-c)
				c=c+1
				continue
			end
			local file = v:match("^.+/(.+)$"):match("(.+)%..+")
			if string.find(file, "\\") then
				file = string.Explode("\\", file)[2]
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
			local isself = false
			if optionname == "self" then
				isself = true
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
			if isself then
				pathway = table.deepcopy(pathway)
				pathway[#pathway] = nil
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
			elseif T=="table" then
				if value.type then
					if value.type == "Message" then return false end
					local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
					if value.type == "KeyBind" then
						config:SetValue(newvalue, unpack(pathway))
						return false
					end
					if newvalue == nil then return false end
					if value.type == "ColorPicker" and newvalue.T == "ColorPicker" then
						newvalue = newvalue.V
					elseif value.type == "ComboBox" and newvalue.T == "ComboBox" and #newvalue.V == #value.value then
						newvalue = newvalue.V
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
			if typeof(newvalue) ~= typeof(config:GetValue(unpack(pathway))) then return end
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
		writefile(self.internal_pathway .. "/configs.json", httpservice:JSONEncode(reg))
	end

	function config:OpenBase()
		local path = self.internal_pathway .. "/configs.json"
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

	hook:Add("OnConfigChanged", "BBOT:config.autosave", function(steps)
		if config.Opening then return end
		config:SaveBase()
		if config:GetValue("Main", "Settings", "Configs", "Auto Save Config") and not config:IsPathwayEqual(steps, "Main", "Settings", "Configs") then
			local file = config:GetValue("Main", "Settings", "Configs", "Autosave File")
			BBOT.log(LOG_NORMAL, "Autosaving config -> " .. file)
			config:Save(file)
		end
	end)

	hook:Add("Menu.PostGenerate", "BBOT:config.setup", function()
		local configs = BBOT.config:Discover()
		BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
		BBOT.menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
	end)

	function config:BaseGetNormal(...)
		local steps = {...}
		local reg = self._base_registry
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

	hook:Add("OnConfigChanged", "BBOT:config.unsafefeatures", function(steps, old, new)
		if config:IsPathwayEqual(steps, "Main", "Settings", "Cheat Settings", "Allow Unsafe Features") and not new then
			timer:Async(function()
				for i=1, #config.unsafe_paths do
					local path = string.Explode(".", config.unsafe_paths[i])
					config:SetValue(config:BaseGetNormal(unpack(path)), unpack(path))
				end
			end)
		end
	end)


	hook:Add("PreInitialize", "BBOT:config.setup", function()
		config.storage_pathway = "bitchbot/" .. BBOT.game .. "/configs"
		config.internal_pathway = "bitchbot/" .. BBOT.game .. "/data"
		config.storage_main = "bitchbot"
		config.storage_extension = ".bb"

		config:Setup(BBOT.configuration)

		if isfile(config.storage_pathway .. "/priorities.json") then
			local tbl = httpservice:JSONDecode(readfile(config.storage_pathway .. "/priorities.json"))
			for k, v in pairs(tbl) do
				config.priority[tonumber(k)] = v
			end
		end

		config:OpenBase()
		if config:GetValue("Main", "Settings", "Configs", "Auto Load Config") then
			local file = config:GetValue("Main", "Settings", "Configs", "Autoload File")
			BBOT.log(LOG_NORMAL, "Autoloading config -> " .. file)
			BBOT.notification:Create("Auto loaded config: " .. file)
			config:Open(file)
		end
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
		active = {}, -- contains only enabled gui objects
		classes = {}
	}
	BBOT.gui = gui

	if BBOT.username == "dev" then
		local dbg = draw:Create("Rect", "Point2D", 0, 0)
        gui.drawing_debugger = dbg
		dbg.Visible = true
		dbg.ZIndex = 2000000
        dbg.Size = Vector2.new(20,20)
	end

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
				self._opacity = self.parent._opacity * self.transparency
				self._zindex = self.parent._zindex + self.zindex + (self.focused and 10000 or 0)
			else
				self._enabled = self.enabled
				self._visible = self.visible
				self._opacity = self.transparency
				self._zindex = self.zindex + (self.focused and 10000 or 0)
			end

			if self._enabled and gui:IsValid(self) then
				self:InvalidateLayout()
			end

			if last_trans ~= self._opacity or last_zind ~= self.zindex or last_vis ~= self._visible or wasenabled ~= self._enabled then
				self:PerformDrawings()
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

			if self._enabled ~= wasenabled then
				local actives_list = gui.active
				if self._enabled then
					actives_list[#actives_list+1] = self
				else
					for i=1, #actives_list do
						if actives_list[i] == self then
							table.remove(actives_list, i)
							break
						end
					end
				end
			end
		end

		function base:PerformDrawings()
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
		function base:Cache(object, transparency, zindex, visible)
			local objects = self.objects
			local exists = false
			for i=1, #objects do
				local v = objects[i]
				if v[1] == object then
					v[2] = transparency or object.Opacity
					v[3] = zindex or object.ZIndex
					v[4] = visible or object.Visible
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
				if v == self then
					table.remove(reg, i-c)
					c = c + 1
				end
			end
			c = 0
			local actives_list = gui.active
			for i=1, #actives_list do
				local v = actives_list[i-c]
				if v == self then
					table.remove(actives_list, i-c)
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
			return self.transparency
		end
		function base:SetOpacity(t)
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
		self.active[#self.active+1] = struct
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

		function gui:OpacityTo(object, transparency, length, delay, ease, callback)
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

	hook:Add("RenderStep.Input", "BBOT:GUI.Hovering", function()
		ishoveringuniversal = nil
		local reg = gui.active
		local inhover = {}
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID and v.class ~= "Mouse" and gui:IsHovering(v) then
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
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
				if v.WheelForward then
					v:WheelForward()
				end
			end
		end
	end)

	hook:Add("WheelBackward", "BBOT:GUI.Input", function()
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
				if v.WheelBackward then
					v:WheelBackward()
				end
			end
		end
	end)

	hook:Add("Camera.ViewportChanged", "BBOT:GUI.Transform", function()
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID and not v.parent then
				v:Calculate()
			end
		end
	end)

	hook:Add("RenderStep.Input", "BBOT:GUI.Render", function(delta)
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
				if v.Step then
					v:Step(delta)
				end
			end
		end
	end)

	hook:Add("InputBegan", "BBOT:GUI.Input", function(input)
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
				if v.InputBegan then
					v:InputBegan(input)
				end
			end
		end
	end)

	hook:Add("InputEnded", "BBOT:GUI.Input", function(input)
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
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
		if BBOT.game == "phantom forces" then
			icons.registry = {
				-- MENU
				["PISTOL"] = {"iVBORw0KGgoAAAANSUhEUgAAADQAAAAeCAYAAABjTz27AAACXUlEQVR4nNXYS6hNURzH8c9xLzeSR6SQgVIXA4k8SkhKSlHKAKUMjDBRZkZGSibKwISJUkqMiEylJMr7NZC886Z78/wbrHvrdJxz7ln77utc39qd3Vl7/fb/t57/tSsRYQAm4Dm24mzV/90Y26DOD9wcSLhEZuAovnYO8GAHdmEMTuEwRmEpFjWp18jQKxzHJzzGtD7tXHrwArMwHvswH58rTXqoE6exvsALW6EXXRhRoO4vfMfo2oJmho5he4GXtZVGhibjtWKt11aqA96A5X33q/2HZkjzpAM7cRCBHdjUzqAGwcdKRGyUJn8/gd+S0f+NA/1zaCwWYz+WtTWk4nzDzE5swx7MQ+UfB9BTgs5XvMFFvKxExBlpp+2nC3MMbsidwzOMxBpMryp7jL04L5kql4iod3VHxPXI43dE9EbE/YjoqNKaFBF3+555GBFTGryzlKvR0vwAm/Ezo20uSF1/UtrJ+3knDWl9v28y2zyLZnvNA1zL0LojDdP3dcqu4ItkekgZaPP8kqG1AJexsE7ZT6mnfmToFaKZoRHSytcqq/BUyp6n1pRNlI4hQ06z5HQ+bmTqPZGGXu1yPBsfsDJTL5tm56HcTHs3jkiZRtto1EPduCXtI61wDuvKCmowNJpDh7RuBi6VEEsp1DM0V35r3y4hllKoZ2hNAZ1bgw2kLOoZWp2p8Vb6+DEsqDXUiRWZGsOmd/jb0BKMy9QYNvOHvw3NLqAxrA0VOeA9LyOQsqg19KiAxpIyAimLWkNX5af4W/zbo3tTag31Yq20F51oof496Vt1W/O3av4ARjQk0oC+k4cAAAAASUVORK5CYII=", 52, 30},
				["RIFLE"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAdCAYAAABcz8ldAAAD+klEQVR4nO3aS2hcVRjA8d+MRqTahqj4bIUujIKPBitasQsfUXHTouhGMKLiTjeCoKCIDwTduPIFKoq1IFQXFS2iLVGoaNWmlmqVKloNihvTGG0yscm4+O4wk8nMeCfzTOofLpd7zp1zzpzvfI/znZvJ5/OWGMdgLfqxH3/hZKzBCchiM86ro80pjODvpo6UIbyGa/EhHNvkDtJyC64Sk9cKVuBqRWH0ltRNY1BMQlryeAkHMF6hfiy578LBOtq9Ibn3FAoyHdCQIbyKTLs7bjJTigu6cH8LN6f8fRZbMYMXsI32CuTEpNN1OqeZxGqfwSHsKSk/E2ck5T+UlJ8rtCwvhFBNQ87C6bgLr6QYxyVYhb3CvG6jvRPTj8va3GclMskYehVNDaxEHybLypcl1294TvifShwvVvzLwhw+jZ9qjGM9HkUOjwm/l83kG1eRI/hMOKVfS8p7xOo6HxfhlAb7OSpohkCOFnZgVJitSsyKBTiF1cnzOzXaW4EbhZn7GL/zv0Dq4Un1RVBpyArTuRm/0Hl73my24A/heCdxGNeLEJswr59iJ35M6qeSe07sM6ZFuPwPJpLf5JJ3Wk67NCQn/MwELsdJFd75Do/gXuHsxsRkDeB1fI2fFWP3SqxL+iklK4SyDNtFFNW1tFJDvsf7IpwbVtzljqgskAN4Exfgg5Ly0+roc8B8gcwmY1gUZJvUzhGxgjeJFX5Oct2Dd81NOTxcpY2Cpo6IFEc5U5L0Qg3Wpxxv17JQkzUmVv0OsSL3CZudhuX4s6xsAk/gRWH/+xT3AgO4Iulnt9C6wSptjwuNyqUcS9eRViCTwhFuT67dYre7EC4Uu9NShoSfWIVTy+oOik3XaPK8Fl/UaH+D2uFmV1NNIDP4UlEAO1WPv+vlITxe8jyKsxVN1n+REamN1VXqhxWjqkVHqVPfryiAYa2LRjaWPW+VXhiSd7fg/ir1V+J2kdZedGTy+fwgvjE37dEqVorQtTTTe525UVUaLhYaXI0xEa214z81laz5OahWstFcYRwS2lgvu9UWYh+eX0C7HadZYW9ays3Ve2JHvBDuUzua2oC7F9h2x2inQJYL+17Krgba2ydC5Vo8q3qI3JW0UyCHxQR+IjaSRAjcCE+JjWQ1esQp3jUN9tM2OnGES2hLP77V+IcDa/C5knPpCkzjTrzRYF8tp90+pMCEiJKa8RXHVyIZWYvjxMbzAV1+lt8pDWk2GZFHu1XsU6pN+iwuVTtk7iid0pBmkxcm6SO1NeAZXSwMlo6GFOjF2+KbrHL2Cu3o6sTjUtGQAuPiAGtTWXkOt+lyYbD0BEJEVEPmOvoHzc8wdyVLzWSVc4fIDtwkHHrX8y9c6Q6XYJwubQAAAABJRU5ErkJggg==", 100, 29},
				["SHOTGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAbCAYAAACKlipAAAADgklEQVR4nO3aS2hcZRTA8V/StKYtEbGxLdr6QFsfUBHRhWhRqCiI2qAVXLkRurG4EVwpiK66caGg+Ni5UxeiFJQqiAaUFotB8bGoRRc+sLRFm1eT9Lg495rJdCaZZKYzaTt/uMw333fud8+d853vnHPv9ESEs8Q27MQQrscvuLkYGyn6+nEEa7Eex/E3ttaYbwx/NnjtF/DO0tTuMBHRqmNFRNwdES9HxOGYy1Ah81ZEvF60d0XEzxGxMiIGI2IiIrZERE9EDEdz7GnhfbX16GvSnmtwv/SEB7Gujtzl6JNeMI0VRd9aXIwNFX1/4Oom9Vpu9OASjGNiXsklWHF9RDwZER9GxNgiVu1onfZkREwX7ZmIGK8YOxkRuyPi9CKuE7H8PGSw0OuNhWQb9ZAtMhbsxB3obeCcGQzjAE4vIPtIcY1eGVdKLsJuucJqcQpf4WBxvZJR3NuAjovhS0wu8dyVxed9Cwn2xNygvglXSLfql0Z4GDctUZHzia9xcpHnrMFGDOCyom8Eq6ntDJUGGcDjCDwts6Qubaa00g687fwLpuccpYcM484O67LcGcOLcuuZlBnlqMwaDy9innVyN6qMw98Xc3YNsky4VhbODWVLXdpIGUNGO6rFucW/+EdmUKcwhb+anPP/dLo0yOcayJEr+AS/Fu3tuLGGzF68N88cq2R1Pyir/asqxo7gR7MevFHm8jfIir6TPIEPivZqWX23jDKGbMAreEz9ImxK5uLHZCFXFntXmjVOye/YbOGCsORRXNeA3Etmi6xOsV3G3LNCdWF4Fz6Sz12qmcYzsmh8s2psUq74kldlLdNqRqU3f4wfpHH65TZSPi86XsheKhdP2VbIbJNp/u3OLM7G5Y/9mSLIVjGGfU3fxTxUKzSM/dJTasmecGatMiT30oP4Bofwfgt1rGSH9NJmeBfPy63ylqLvkCyIR+W9dIxqgwxIL6nFAbkiT8i9/Cf5SKVPrsyZOue1kmaNUclRfNrC+VpC9Za1F8/WkJvBbfi2+H4rrsFv0jO6tIhKg2zFd+bGgpLX8FS7lLqQqTTIPjxQQ+aYfN16tF1KXciUef5DahsDntM1RtvoiYhVcquq9ceCCZkytrT46VKfXuxR2xjwha4x2kovds0zvr9dinRJeiJiSp3XibJwGmmfOl16zR+wN7VLkS5JL+6RDwNrsbl9qnSB/wBF8j6LJlmzYQAAAABJRU5ErkJggg==", 100, 27},
				["SMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAE0AAAAeCAYAAABpE5PpAAADmklEQVR4nO3ZS4iVZRgH8N+Mk6FRNpXlQrPLBEVN2WUhJSUkXSgs6EZBSG0KWrQJIlu00YKgRSuJdrbKkDYVU9pNi2rRZVBrkyGWKQ4U5oxMXs7T4v2mvnPmO9+cc2bOnDnhH154r8/zfM/7fu9zeXsiQpdhJUaxuw20v8At6EVdxfS2gXE7sRAP4vZOCtHTZSdtOfZhf1afaTR00vrawLiduB4V9OOrrO/vmjl9mJdrV3CiZs589OTap3Ayow/v4v56QnSb0hZifa79Aha1gc+KssFuU9oqDOOPrH2yTXwuljbjSNFgN91pZ0pWM7/Rb0n320CuzNTJW4Uviwa66aRdZbK8b2JnTd9iXC4p8IpcfQDnN8Fv0P9AaYMFfbsK+kay8nXBWL/qUzmAtTi3QX5ISltTLuucwZ017T9xU4u0JhS7Ax9iE45hSW7OZfUW92Fbi4w7jX4zJ/sxHFCttLqOf7dFBHMCs3mn7cH4NNZfivNy7VEcnpZE/2Gx5APWYgkWqHaED/dEF/kcs4zfcIHk6gzjWilJsLmbrOdsY2mu3iudth4Mnj5pzeO70yetGJ/hI5wj+XB5gzk+V5RWwafYLBkM0q+wFs+oNgBleAnvZ/UBvCIZkGaxWopvHygcjc5iLCLWR8SyiFCnnB0ROxqg9UnB2sGIqLQo29Z6MnXaT3scL+PXkjlH8aySpGCG9wr6dmFryZrAB3gHQ1PQ/xed/D1/l5J9jWDP1FMmJRon8BAextsFYztxT679OW7N6nPyjeCsJuY+p9rBLMK9Uhy9omBsixRj1mKspj2aq89JpS2SLvoyzMPr2NgAvTukWPSNOuP7CvoOlNCb8o3gR8ly5bFSSZ68Diqa24hNOIRvCsZuxAbcVbL+IB6T7qUFWd91UuZ1f25eb0avFttLaNdV2oRzOyKFCnksxZUlRIswJJn5pyVzPb/Bdb9IL0Hj0m94M66eYs1fuA0/4KcaWYewTopNz5BckRdr1lek2HIk13c3lmX1vfi4iHE7090X4kk8hUtmmPZx6QLfLm3MUZM36Ah+xkWqQ6IJfI8bWuJe4h/NVOmNiDURsSUiTrToM+VRiYh1OfqDLdJ5NVr8ptlQWr4sj4iNEXGoxQ+NiHi+huajLdAYymTpCqVNlPkR8UhEHGziQ4cjYnUBrQ1N0NgbEfdNV/5OObfHJWfzCSlfVYRT+FYKnLcpfkSBaxrgNyYZqNdMLxEK/gEIMckYAgwqoQAAAABJRU5ErkJggg==", 77, 30},
				["SNIPER"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAXCAYAAAD9VOo7AAADIklEQVR4nO3ZS2hdVRSA4e/mYa310VajlapYRQRtFScOfEFFcCIojhw4kIoVrQhSHSmIUwURHPmYqAOhA3HgQBQFURR0YBRRaw0+20SDL6y9sU27HKx9yU1Nbm5ubu4j6Q+bs/c+Z+29DuuctdZZpxIReph78DyOYA/u7K46y89AtxVYgH3lOFzXX9EMdXCvYTyJU8r4CMZxFH/jOZxWrvu1XDNWJ1/fP7vI/1FkLsc2bC3tDBwz+4Hbgc/bdjfLRKWDLmstDjU4/wPW42R8UeZOxaWlvx8Tpb8VU/gdF6LSxP7X4sPFKNwNeskgy01fGKTXY8iqo5MxZBovmYkh09LlrEcVj+Jl6aK2lGtOxyWlP44Dpf89vsIdZuLGFeW4DRvK+p28v7bQSZc1H7fLwAwP4HzsRMjAXM+ADNjP4kc8VebH8NGya9oBumGQs3CXfAtGcLN8E2ocw6fzyA7hyuPmpvC1zNbgHxyuO/+X/xu2Z+mGQZ7GQ53etF/ohI89D7fgGvl0b+zAnt3kM7zaqvB8b8ganItN0q2MlHGtv0m6lYcbrD2IR/AETmpVwT7kE1zdqvBcBhmWQfPeBWRDZjVfznFui8yYrmtVsT7mkExSWopbQ3gFF+McmcGc2aRsBbtx93HzO/CMmcxptVGVHqbainAlIl7HrS1ufhgXybLGCF5osNZv0uBLjVsTeF9+a9yEP+Xb2gtMyZT9jZZXiIhdsTTei4j7I2KiwTVjEXFBRGyOiD0R8VhEbIyIDXXtxYj4ron93owIEbEmIh6PiEoZr4g2hI+X+FTcUNp8jGE7firjD/AOLiv9GuN4V7q8ZvhXJgwrigEzFdTl4FuzjQF7sVkaoEZFftDVl9hXJZWIqAWgZkrYi2EfbsTPc5y7TVZ/p8t4EKO4Dw8usO4ormqHgr1ILe2tyv8Q7eIbaYz9i5S7Xn7jNOIoXmtFqX6gEhHrcLBF+arMt9fVze2Vxjgwp8QJGjKk8XfH27JwN4lfSpssbVwacq0sFu4u6203Oz6cYBHUXNZbss40KaujB+U/h11m/PxCDMp/EaPtVnI18R9vKf2ssOnBPwAAAABJRU5ErkJggg==", 100, 23},

				-- WEAPONS
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
		else
			icons.registry = {
				-- MENU
				["PISTOL"] = {"iVBORw0KGgoAAAANSUhEUgAAADQAAAAeCAYAAABjTz27AAACXUlEQVR4nNXYS6hNURzH8c9xLzeSR6SQgVIXA4k8SkhKSlHKAKUMjDBRZkZGSibKwISJUkqMiEylJMr7NZC886Z78/wbrHvrdJxz7ln77utc39qd3Vl7/fb/t57/tSsRYQAm4Dm24mzV/90Y26DOD9wcSLhEZuAovnYO8GAHdmEMTuEwRmEpFjWp18jQKxzHJzzGtD7tXHrwArMwHvswH58rTXqoE6exvsALW6EXXRhRoO4vfMfo2oJmho5he4GXtZVGhibjtWKt11aqA96A5X33q/2HZkjzpAM7cRCBHdjUzqAGwcdKRGyUJn8/gd+S0f+NA/1zaCwWYz+WtTWk4nzDzE5swx7MQ+UfB9BTgs5XvMFFvKxExBlpp+2nC3MMbsidwzOMxBpMryp7jL04L5kql4iod3VHxPXI43dE9EbE/YjoqNKaFBF3+555GBFTGryzlKvR0vwAm/Ezo20uSF1/UtrJ+3knDWl9v28y2zyLZnvNA1zL0LojDdP3dcqu4ItkekgZaPP8kqG1AJexsE7ZT6mnfmToFaKZoRHSytcqq/BUyp6n1pRNlI4hQ06z5HQ+bmTqPZGGXu1yPBsfsDJTL5tm56HcTHs3jkiZRtto1EPduCXtI61wDuvKCmowNJpDh7RuBi6VEEsp1DM0V35r3y4hllKoZ2hNAZ1bgw2kLOoZWp2p8Vb6+DEsqDXUiRWZGsOmd/jb0BKMy9QYNvOHvw3NLqAxrA0VOeA9LyOQsqg19KiAxpIyAimLWkNX5af4W/zbo3tTag31Yq20F51oof496Vt1W/O3av4ARjQk0oC+k4cAAAAASUVORK5CYII=", 52, 30},
				["RIFLE"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAdCAYAAABcz8ldAAAD+klEQVR4nO3aS2hcVRjA8d+MRqTahqj4bIUujIKPBitasQsfUXHTouhGMKLiTjeCoKCIDwTduPIFKoq1IFQXFS2iLVGoaNWmlmqVKloNihvTGG0yscm4+O4wk8nMeCfzTOofLpd7zp1zzpzvfI/znZvJ5/OWGMdgLfqxH3/hZKzBCchiM86ro80pjODvpo6UIbyGa/EhHNvkDtJyC64Sk9cKVuBqRWH0ltRNY1BMQlryeAkHMF6hfiy578LBOtq9Ibn3FAoyHdCQIbyKTLs7bjJTigu6cH8LN6f8fRZbMYMXsI32CuTEpNN1OqeZxGqfwSHsKSk/E2ck5T+UlJ8rtCwvhFBNQ87C6bgLr6QYxyVYhb3CvG6jvRPTj8va3GclMskYehVNDaxEHybLypcl1294TvifShwvVvzLwhw+jZ9qjGM9HkUOjwm/l83kG1eRI/hMOKVfS8p7xOo6HxfhlAb7OSpohkCOFnZgVJitSsyKBTiF1cnzOzXaW4EbhZn7GL/zv0Dq4Un1RVBpyArTuRm/0Hl73my24A/heCdxGNeLEJswr59iJ35M6qeSe07sM6ZFuPwPJpLf5JJ3Wk67NCQn/MwELsdJFd75Do/gXuHsxsRkDeB1fI2fFWP3SqxL+iklK4SyDNtFFNW1tFJDvsf7IpwbVtzljqgskAN4Exfgg5Ly0+roc8B8gcwmY1gUZJvUzhGxgjeJFX5Oct2Dd81NOTxcpY2Cpo6IFEc5U5L0Qg3Wpxxv17JQkzUmVv0OsSL3CZudhuX4s6xsAk/gRWH/+xT3AgO4Iulnt9C6wSptjwuNyqUcS9eRViCTwhFuT67dYre7EC4Uu9NShoSfWIVTy+oOik3XaPK8Fl/UaH+D2uFmV1NNIDP4UlEAO1WPv+vlITxe8jyKsxVN1n+REamN1VXqhxWjqkVHqVPfryiAYa2LRjaWPW+VXhiSd7fg/ir1V+J2kdZedGTy+fwgvjE37dEqVorQtTTTe525UVUaLhYaXI0xEa214z81laz5OahWstFcYRwS2lgvu9UWYh+eX0C7HadZYW9ays3Ve2JHvBDuUzua2oC7F9h2x2inQJYL+17Krgba2ydC5Vo8q3qI3JW0UyCHxQR+IjaSRAjcCE+JjWQ1esQp3jUN9tM2OnGES2hLP77V+IcDa/C5knPpCkzjTrzRYF8tp90+pMCEiJKa8RXHVyIZWYvjxMbzAV1+lt8pDWk2GZFHu1XsU6pN+iwuVTtk7iid0pBmkxcm6SO1NeAZXSwMlo6GFOjF2+KbrHL2Cu3o6sTjUtGQAuPiAGtTWXkOt+lyYbD0BEJEVEPmOvoHzc8wdyVLzWSVc4fIDtwkHHrX8y9c6Q6XYJwubQAAAABJRU5ErkJggg==", 100, 29},
				["SHOTGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAbCAYAAACKlipAAAADgklEQVR4nO3aS2hcZRTA8V/StKYtEbGxLdr6QFsfUBHRhWhRqCiI2qAVXLkRurG4EVwpiK66caGg+Ni5UxeiFJQqiAaUFotB8bGoRRc+sLRFm1eT9Lg495rJdCaZZKYzaTt/uMw333fud8+d853vnHPv9ESEs8Q27MQQrscvuLkYGyn6+nEEa7Eex/E3ttaYbwx/NnjtF/DO0tTuMBHRqmNFRNwdES9HxOGYy1Ah81ZEvF60d0XEzxGxMiIGI2IiIrZERE9EDEdz7GnhfbX16GvSnmtwv/SEB7Gujtzl6JNeMI0VRd9aXIwNFX1/4Oom9Vpu9OASjGNiXsklWHF9RDwZER9GxNgiVu1onfZkREwX7ZmIGK8YOxkRuyPi9CKuE7H8PGSw0OuNhWQb9ZAtMhbsxB3obeCcGQzjAE4vIPtIcY1eGVdKLsJuucJqcQpf4WBxvZJR3NuAjovhS0wu8dyVxed9Cwn2xNygvglXSLfql0Z4GDctUZHzia9xcpHnrMFGDOCyom8Eq6ntDJUGGcDjCDwts6Qubaa00g687fwLpuccpYcM484O67LcGcOLcuuZlBnlqMwaDy9innVyN6qMw98Xc3YNsky4VhbODWVLXdpIGUNGO6rFucW/+EdmUKcwhb+anPP/dLo0yOcayJEr+AS/Fu3tuLGGzF68N88cq2R1Pyir/asqxo7gR7MevFHm8jfIir6TPIEPivZqWX23jDKGbMAreEz9ImxK5uLHZCFXFntXmjVOye/YbOGCsORRXNeA3Etmi6xOsV3G3LNCdWF4Fz6Sz12qmcYzsmh8s2psUq74kldlLdNqRqU3f4wfpHH65TZSPi86XsheKhdP2VbIbJNp/u3OLM7G5Y/9mSLIVjGGfU3fxTxUKzSM/dJTasmecGatMiT30oP4Bofwfgt1rGSH9NJmeBfPy63ylqLvkCyIR+W9dIxqgwxIL6nFAbkiT8i9/Cf5SKVPrsyZOue1kmaNUclRfNrC+VpC9Za1F8/WkJvBbfi2+H4rrsFv0jO6tIhKg2zFd+bGgpLX8FS7lLqQqTTIPjxQQ+aYfN16tF1KXciUef5DahsDntM1RtvoiYhVcquq9ceCCZkytrT46VKfXuxR2xjwha4x2kovds0zvr9dinRJeiJiSp3XibJwGmmfOl16zR+wN7VLkS5JL+6RDwNrsbl9qnSB/wBF8j6LJlmzYQAAAABJRU5ErkJggg==", 100, 27},
				["SMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAE0AAAAeCAYAAABpE5PpAAADmklEQVR4nO3ZS4iVZRgH8N+Mk6FRNpXlQrPLBEVN2WUhJSUkXSgs6EZBSG0KWrQJIlu00YKgRSuJdrbKkDYVU9pNi2rRZVBrkyGWKQ4U5oxMXs7T4v2mvnPmO9+cc2bOnDnhH154r8/zfM/7fu9zeXsiQpdhJUaxuw20v8At6EVdxfS2gXE7sRAP4vZOCtHTZSdtOfZhf1afaTR00vrawLiduB4V9OOrrO/vmjl9mJdrV3CiZs589OTap3Ayow/v4v56QnSb0hZifa79Aha1gc+KssFuU9oqDOOPrH2yTXwuljbjSNFgN91pZ0pWM7/Rb0n320CuzNTJW4Uviwa66aRdZbK8b2JnTd9iXC4p8IpcfQDnN8Fv0P9AaYMFfbsK+kay8nXBWL/qUzmAtTi3QX5ISltTLuucwZ017T9xU4u0JhS7Ax9iE45hSW7OZfUW92Fbi4w7jX4zJ/sxHFCttLqOf7dFBHMCs3mn7cH4NNZfivNy7VEcnpZE/2Gx5APWYgkWqHaED/dEF/kcs4zfcIHk6gzjWilJsLmbrOdsY2mu3iudth4Mnj5pzeO70yetGJ/hI5wj+XB5gzk+V5RWwafYLBkM0q+wFs+oNgBleAnvZ/UBvCIZkGaxWopvHygcjc5iLCLWR8SyiFCnnB0ROxqg9UnB2sGIqLQo29Z6MnXaT3scL+PXkjlH8aySpGCG9wr6dmFryZrAB3gHQ1PQ/xed/D1/l5J9jWDP1FMmJRon8BAextsFYztxT679OW7N6nPyjeCsJuY+p9rBLMK9Uhy9omBsixRj1mKspj2aq89JpS2SLvoyzMPr2NgAvTukWPSNOuP7CvoOlNCb8o3gR8ly5bFSSZ68Diqa24hNOIRvCsZuxAbcVbL+IB6T7qUFWd91UuZ1f25eb0avFttLaNdV2oRzOyKFCnksxZUlRIswJJn5pyVzPb/Bdb9IL0Hj0m94M66eYs1fuA0/4KcaWYewTopNz5BckRdr1lek2HIk13c3lmX1vfi4iHE7090X4kk8hUtmmPZx6QLfLm3MUZM36Ah+xkWqQ6IJfI8bWuJe4h/NVOmNiDURsSUiTrToM+VRiYh1OfqDLdJ5NVr8ptlQWr4sj4iNEXGoxQ+NiHi+huajLdAYymTpCqVNlPkR8UhEHGziQ4cjYnUBrQ1N0NgbEfdNV/5OObfHJWfzCSlfVYRT+FYKnLcpfkSBaxrgNyYZqNdMLxEK/gEIMckYAgwqoQAAAABJRU5ErkJggg==", 77, 30},
				["SNIPER"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAXCAYAAAD9VOo7AAADIklEQVR4nO3ZS2hdVRSA4e/mYa310VajlapYRQRtFScOfEFFcCIojhw4kIoVrQhSHSmIUwURHPmYqAOhA3HgQBQFURR0YBRRaw0+20SDL6y9sU27HKx9yU1Nbm5ubu4j6Q+bs/c+Z+29DuuctdZZpxIReph78DyOYA/u7K46y89AtxVYgH3lOFzXX9EMdXCvYTyJU8r4CMZxFH/jOZxWrvu1XDNWJ1/fP7vI/1FkLsc2bC3tDBwz+4Hbgc/bdjfLRKWDLmstDjU4/wPW42R8UeZOxaWlvx8Tpb8VU/gdF6LSxP7X4sPFKNwNeskgy01fGKTXY8iqo5MxZBovmYkh09LlrEcVj+Jl6aK2lGtOxyWlP44Dpf89vsIdZuLGFeW4DRvK+p28v7bQSZc1H7fLwAwP4HzsRMjAXM+ADNjP4kc8VebH8NGya9oBumGQs3CXfAtGcLN8E2ocw6fzyA7hyuPmpvC1zNbgHxyuO/+X/xu2Z+mGQZ7GQ53etF/ohI89D7fgGvl0b+zAnt3kM7zaqvB8b8ganItN0q2MlHGtv0m6lYcbrD2IR/AETmpVwT7kE1zdqvBcBhmWQfPeBWRDZjVfznFui8yYrmtVsT7mkExSWopbQ3gFF+McmcGc2aRsBbtx93HzO/CMmcxptVGVHqbainAlIl7HrS1ufhgXybLGCF5osNZv0uBLjVsTeF9+a9yEP+Xb2gtMyZT9jZZXiIhdsTTei4j7I2KiwTVjEXFBRGyOiD0R8VhEbIyIDXXtxYj4ron93owIEbEmIh6PiEoZr4g2hI+X+FTcUNp8jGE7firjD/AOLiv9GuN4V7q8ZvhXJgwrigEzFdTl4FuzjQF7sVkaoEZFftDVl9hXJZWIqAWgZkrYi2EfbsTPc5y7TVZ/p8t4EKO4Dw8usO4ormqHgr1ILe2tyv8Q7eIbaYz9i5S7Xn7jNOIoXmtFqX6gEhHrcLBF+arMt9fVze2Vxjgwp8QJGjKk8XfH27JwN4lfSpssbVwacq0sFu4u6203Oz6cYBHUXNZbss40KaujB+U/h11m/PxCDMp/EaPtVnI18R9vKf2ssOnBPwAAAABJRU5ErkJggg==", 100, 23},
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

-- GUI Objects
do
    local hook = BBOT.hook
    local draw = BBOT.draw
    local gui = BBOT.gui

    -- Panel
	do
		local GUI = {}

		function GUI:Init()
			self.draggable = false
			self.sizable = false
			self.mouseinputs = true
			self.autofocus = false

			self:Calculate()
		end

		function GUI:PerformLayout(pos, size)
		end

		function GUI:SetDraggable(bool)
			self.draggable = bool
		end

		local last_focused = nil
		local mouse = BBOT.service:GetService("Mouse")
		function GUI:InputBegan(input)
			if self.draggable and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
				local mousepos = Vector2.new(mouse.X, mouse.Y)
				self.dragging = mousepos
				self.dragging_origin = self:GetLocalTranslation()
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() and self.autofocus then
				if gui:IsValid(last_focused) then
					last_focused:SetFocused(false)
				end
				self:SetFocused(true)
				last_focused = self
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

		gui:Register(GUI, "Panel")
	end
end

--! POST LIBRARIES !--
-- WholeCream here, do remember to sort all of this in order for a possible module based loader

local loadstart = tick()
-- Setup, are we playing PF, Universal or... Bad Business 😉
do
	local thread = BBOT.thread
	local hook = BBOT.hook
	local menu = BBOT.menu
	local config = BBOT.config
	local gui = BBOT.gui

	local supported_games = {
		[113491250] = "phantom forces",
		[1256867479] = "phantom forces",
		[1168263273] = "bad business"
	}

	if supported_games[game.GameId] then
		BBOT.game = tostring(supported_games[game.GameId])
	else
		BBOT.universal = true
		BBOT.game = tostring(game.GameId)
	end

	BBOT.rootpath = "bitchbot"

	-- Folder Generation
	local function CreateFolder(path)
		if not isfolder(BBOT.rootpath .. "/" .. BBOT.game .. "/" .. path) then
			makefolder(BBOT.rootpath .. "/" .. BBOT.game .. "/" .. path)
		end
	end
	if not isfolder(BBOT.rootpath) then
		makefolder(BBOT.rootpath)
	end
	if not isfolder(BBOT.rootpath .. "/" .. BBOT.game) then
		makefolder(BBOT.rootpath .. "/" .. BBOT.game)
	end
	CreateFolder("configs")
	CreateFolder("data")
	CreateFolder("scripts")

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
		message:SetText("Waiting for "..game.Name.."...")
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
	if not _BBOT then
		if BBOT.game == "phantom forces" then
			local waited = 0
			while true do
				if game:IsLoaded() then
					local lp = game:GetService("Players").LocalPlayer;
					local chatgame = lp.PlayerGui:FindFirstChild("ChatGame")
					if chatgame then
						local version = chatgame:FindFirstChild("Version")
						if version and not string.find(version.Text, "loading", 1, true) then
							wait(5)
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
		else
			local waited = 0
			while true do
				if game:IsLoaded() then
					wait(5)
					break
				end;
				waited = waited + 1
				if waited > 7 then
					BBOT:SetLoadingStatus("Something may be wrong... Contact the Demvolopers")
				elseif waited > 5 then
					BBOT:SetLoadingStatus("What the hell is taking so long?")
				end
				wait(5)
			end;
		end
	end

	if BBOT.game == "phantom forces" then
		local table = BBOT.table
		local anims = {
			{
				type = "Toggle",
				name = "Enabled",
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
				decimal = 2,
				suffix = " stud(s)"
			},
			{
				type = "Slider",
				name = "Amplitude",
				min = -10,
				max = 10,
				value = 0,
				decimal = 2,
				suffix = "x"
			},
			{
				type = "Slider",
				name = "Speed",
				min = -10,
				max = 10,
				value = 0,
				decimal = 2,
				suffix = "x"
			},
		}

		local anims_color = {
			{
				type = "Toggle",
				name = "Enabled",
				value = false,
			},
			{
				type = "DropBox",
				name = "Type",
				value = 1,
				values = {"Fade", "Cycle"},
				extra = {
					{
						type = "ColorPicker",
						name = "Primary Color",
						color = { 255, 255, 255, 255 },
					},
					{
						type = "ColorPicker",
						name = "Secondary Color",
						color = { 0, 0, 0, 255 },
					},
				},
			},
			{
				type = "Slider",
				name = "Saturation",
				min = 0,
				max = 100,
				value = 0,
				decimal = 1,
				suffix = "%"
			},
			{
				type = "Slider",
				name = "Darkness",
				min = 0,
				max = 100,
				value = 0,
				decimal = 1,
				suffix = "%"
			},
			{
				type = "Slider",
				name = "Speed",
				min = -10,
				max = 10,
				value = 0,
				decimal = 2,
				suffix = "x"
			},
		}

		local skins_content = {
			{
				name = "Basics",
				pos = UDim2.new(0,0,0,0),
				size = UDim2.new(.5,-4,1/3,-4),
				type = "Panel",
				content = {
					{
						type = "Toggle",
						name = "Enabled",
						value = false,
						extra = {},
						tooltip = "Do note this is not server-sided!"
					},
					{
						type = "DropBox",
						name = "Material",
						value = 1,
						values = BBOT.config.enums.Material.List,
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
						max = 200,
						suffix = "%",
						decimal = 1,
						extra = {},
						tooltip = "Gives the material reflectance, this may be buggy or not work on some materials."
					},
					{
						type = "Slider",
						name = "Color Modulation",
						value = 0,
						min = 1,
						max = 20,
						suffix = "x",
						decimal = 1,
						extra = {},
						tooltip = "Pushes the color system even further by multiplying it"
					},
				},
			},
			{
				name = "Texture",
				pos = UDim2.new(0,0,(1/3),4),
				size = UDim2.new(.5,-4,1-(1/3),-4),
				type = "Panel",
				content = {
					{
						type = "Toggle",
						name = "Enabled",
						value = false,
						extra = {},
					},
					{
						type = "Text",
						name = "Asset-Id",
						value = "3643887058",
						extra = {
							{
								type = "ColorPicker",
								name = "Texture Color",
								color = { 255, 255, 255, 255 },
							},
						},
					},
					{
						type = "Slider",
						name = "Color Modulation",
						value = 0,
						min = 1,
						max = 20,
						suffix = "x",
						decimal = 1,
						extra = {},
						tooltip = "Pushes the color system even further by multiplying it"
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
				},
			},
			{
				name = "Animations",
				pos = UDim2.new(.5,4,0,0),
				size = UDim2.new(.5,-4,1,0),
				type = "Panel",
				content = {
					{
						name = { "OSU", "OSV", "SPTU", "SPTV" },
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,.5,0),
						borderless = true,
						type = "Tabs",
						{
							content = anims,
							tooltip = "OffsetStuds changes the position of texture."
						},
						{
							content = anims,
							tooltip = "OffsetStuds changes the position of texture."
						},
						{
							content = anims,
							tooltip = "StudsPerTile changes the scale of texture."
						},
						{
							content = anims,
							tooltip = "StudsPerTile changes the scale of texture."
						},
					},
					{
						name = {"BC", "TC" },
						pos = UDim2.new(0,0,.5,0),
						size = UDim2.new(1,0,.5,0),
						borderless = true,
						type = "Tabs",
						{
							content = anims_color,
							tooltip = "Color change of brick color."
						},
						{
							content = anims_color,
							tooltip = "Color change of texture color."
						},
					},
				}
			},
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
						type = "Toggle",
						name = "Use Barrel",
						value = false,
						tooltip = "Instead of calculating the FOV from the camera, it uses the weapon barrel's direction."
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
				size = UDim2.new(.5,-4,4/10,-4),
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
						type = "Slider",
						name = "Barrel Comp X",
						value = 100,
						min = 0,
						max = 1000,
						suffix = "%",
						decimal = 1,
						custom = { [0] = "Off" },
					},
					{
						type = "Slider",
						name = "Barrel Comp Y",
						value = 100,
						min = 0,
						max = 1000,
						suffix = "%",
						decimal = 1,
						custom = { [0] = "Off" },
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
				}
			},
			{
				name = {"Bullet Redirect", "Trigger Bot"},
				pos = UDim2.new(.5,4,4/10,4),
				size = UDim2.new(.5,-4,6/10,-4),
				type = "Panel",
				{content = {
					{
						type = "Toggle",
						name = "Enabled",
						value = false,
					},
					{
						type = "Toggle",
						name = "Use Barrel",
						value = true,
						tooltip = "Instead of calculating the FOV from the camera, it uses the weapon barrel's direction."
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
						name = "Aim In Time",
						min = 0,
						max = 2,
						value = .75,
						decimal = 2,
						suffix = "s",
						tooltip = "Time it takes to activate trigger bot by aiming in"
					},
					{
						type = "Slider",
						name = "Fire Time",
						min = 0,
						max = .5,
						value = .1,
						decimal = 3,
						suffix = "s",
						tooltip = "How long you need to stay in the circle to fire"
					},
					{
						type = "Slider",
						name = "Sprint to Fire Time",
						min = 0,
						max = .5,
						value = .1,
						decimal = 3,
						suffix = "s",
						tooltip = "Time from sprinting to the ability to fire"
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
						borderless = true,
						type = "Tabs",
						content = {
							{
								name = "Pistol",
								icon = "PISTOL",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Smg",
								icon = "SMG",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Rifle",
								icon = "RIFLE",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Shotgun",
								icon = "SHOTGUN",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Sniper",
								icon = "SNIPER",
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
						content = {
							{
								name = "Aimbot",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(.5,-4,3.5/10,-4),
								type = "Panel",
								content = {
									{
										type = "Toggle",
										name = "Rage Bot",
										value = false,
										unsafe = true,
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											},
										}
									},
									{
										type = "Slider",
										name = "Aimbot FOV",
										value = 180,
										min = 0,
										max = 181,
										suffix = "°",
										custom = { [181] = "Ignored" },
									},
									{
										type = "Toggle",
										name = "Auto Wallbang",
										value = false
									},
									{
										type = "Slider",
										name = "Auto Wallbang Scale",
										value = 100,
										min = 0,
										max = 121,
										suffix = "%",
										custom = { [121] = "Screw Walls" },
									},
									{
										type = "Toggle",
										name = "Auto Shoot",
										value = false,
										tooltip = "Automatically shoots players when a target is found."
									},
									{
										type = "DropBox",
										name = "Hitscan Priority",
										value = 1,
										values = { "Head", "Body" },
									},
								}
							},
							{
								name = {"HVH", "HVH Extras"},
								pos = UDim2.new(0,0,3.5/10,4),
								size = UDim2.new(.5,-4,1-(3.5/10),-4),
								type = "Panel",
								{content = {
									{
										type = "ComboBox",
										name = "Hitbox Hitscan Points",
										values = {
											{ "Up", false },
											{ "Down", false },
											{ "Left", false },
											{ "Right", false },
											{ "Forward", false },
											{ "Backward", false },
											{ "Origin", true },
										},
										tooltip = "You do not need to turn these all on, points are rotated relative to the direction of the ragebot",
									},
									{
										type = "Slider",
										name = "Hitbox Shift Distance",
										value = 4,
										min = 1,
										max = 12,
										suffix = " studs",
										tooltip = "As of PF update 5.6.2k, I suggest you use 4.1-4.5 shift for the best hit chances",
									},
									{
										type = "ComboBox",
										name = "FirePos Hitscan Points",
										values = {
											{ "Up", false },
											{ "Down", false },
											{ "Left", false },
											{ "Right", false },
											{ "Forward", false },
											{ "Backward", false },
											{ "Origin", true },
										},
										tooltip = "You do not need to turn these all on, points are rotated relative to the direction of the ragebot",
									},
									{
										type = "Slider",
										name = "FirePos Shift Distance",
										value = 4,
										min = 1,
										max = 12,
										suffix = " studs",
										tooltip = "As of PF update 5.6.2k, I suggest you use 8.5-9.8 shift for the best hit chances",
									},
									{
										type = "Slider",
										name = "FirePos Shift Multi-Point",
										value = 1,
										min = 1,
										max = 10,
										decimal = 0,
										suffix = "x",
										tooltip = "Adds multiple of the same points at different distances from the fire position",
									},
									{
										type = "ComboBox",
										name = "TP Scanning Points",
										values = {
											{ "Up", false },
											{ "Down", false },
											{ "Left", false },
											{ "Right", false },
											{ "Forward", false },
											{ "Backward", false },
										},
									},
									{
										type = "Slider",
										name = "TP Scanning Multi-Point",
										min = 1,
										max = 8,
										suffix = "x",
										decimal = 0,
										value = 1,
										custom = {},
										tooltip = "Creates multiple points to teleport towards",
									},
									{
										type = "Slider",
										name = "TP Scanning Distance",
										min = 2,
										max = 300,
										suffix = " studs",
										decimal = 1,
										value = 25,
										custom = {},
									},
								}},
								{content={
									{
										type = "Slider",
										name = "Hitbox Random Points",
										min = 0,
										max = 8,
										suffix = " point(s)",
										decimal = 0,
										value = 0,
										custom = {
											[0] = "Off"
										},
										tooltip = "Points that are placed randomly",
									},
									{
										type = "ComboBox",
										name = "Hitbox Static Points",
										values = {
											{ "Up", false },
											{ "Down", false },
											{ "Left", false },
											{ "Right", false },
											{ "Forward", false },
											{ "Backward", false },
										},
										tooltip = "Points that do not rotate towards the target, in otherwords, static points",
									},
									{
										type = "Slider",
										name = "FirePos Random Points",
										min = 0,
										max = 8,
										suffix = " point(s)",
										decimal = 0,
										value = 0,
										custom = {
											[0] = "Off"
										},
										tooltip = "Points that are placed randomly",
									},
									{
										type = "ComboBox",
										name = "FirePos Static Points",
										values = {
											{ "Up", false },
											{ "Down", false },
											{ "Left", false },
											{ "Right", false },
											{ "Forward", false },
											{ "Backward", false },
										},
										tooltip = "Points that do not rotate towards the target, in otherwords, static points",
									},
								}}
							},
							{
								name = { "Anti Aim", "Fake Lag" },
								pos = UDim2.new(.5,4,0,0),
								size = UDim2.new(.5,-4,1-(5.5/10),-4),
								{content = {
									{
										type = "Toggle",
										name = "Enabled",
										value = false,
										unsafe = true,
										tooltip = "When this is enabled, your server-side yaw, pitch and stance are set to the values in this tab.",
									},
									{
										type = "DropBox",
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
										type = "DropBox",
										name = "Yaw",
										value = 2,
										values = { "Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin" },
									},
									{
										type = "Slider",
										name = "Spin Rate",
										value = 10,
										min = -100,
										max = 100,
										suffix = "°/s",
									},
									{
										type = "Slider",
										name = "In Floor",
										value = 0,
										min = 0,
										max = 5,
										suffix = " studs",
										custom = {[0] = "Disabled"},
										unsafe = true,
										tooltip = "Puts you into the floor kinda..."
									},
									{
										type = "DropBox",
										name = "Fake Stance",
										value = 1,
										unsafe = true,
										values = {"Off", "Stand", "Crouch", "Prone"},
										tooltip = "Changes your stance server-side for others."
									},
								}},
								{content = {}},
							},
							{
								name = { "Extra", "Settings" },
								pos = UDim2.new(.5,4,1-(5.5/10),4),
								size = UDim2.new(.5,-4,(5.5/10),-4),
								{content = {
									{
										type = "Toggle",
										name = "Knife Bot",
										value = false,
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											}
										},
										unsafe = true,
									},
									{
										type = "DropBox",
										name = "Knife Bot Type",
										value = 1,
										values = { "Multi Aura" },
									},
									{
										type = "DropBox",
										name = "Knife Hitscan",
										value = 1,
										values = { "Head", "Body" },
									},
									{
										type = "Toggle",
										name = "Knife Visible Only",
										value = false,
									},
									{
										type = "Slider",
										name = "Knife Range",
										value = 26,
										min = 1,
										max = 26,
										custom = {[26] = "Max"},
										suffix = " studs",
									},
									{
										type = "Slider",
										name = "Knife Delay",
										value = 0,
										min = 0,
										max = 1,
										decimal = 2,
										custom = {[0] = "Knife Party"},
										suffix = "s",
									},
								}},
								{content = {
									{
										type = "Toggle",
										name = "Damage Prediction",
										value = true,
									},
									{
										type = "Slider",
										name = "Damage Prediction Time",
										value = 200,
										min = 100,
										max = 500,
										suffix = "%",
									},
									{
										type = "Slider",
										name = "Damage Prediction Limit",
										value = 100,
										min = 0,
										max = 300,
										custom = {[0] = "What even is the point?"},
										suffix = "hp",
									},
									{
										type = "Slider",
										name = "Max Players",
										value = 2,
										min = 1,
										max = 100,
										decimal = 0,
										custom = {[100] = "Are you good?"},
										suffix = " player(s)",
										tooltip = "The maximum amount of players to scan for each frame."
									},
									{
										type = "Toggle",
										name = "Relative Points Only",
										value = true,
										tooltip = "Makes the firepos and hitbox points align, so less calculations.",
									},
									{
										type = "Toggle",
										name = "Cross Relative Points Only",
										value = true,
										tooltip = "Makes the firepos and hitbox points align by cross, so less calculations.",
									},
									{
										type = "Toggle",
										name = "Resolver",
										value = false,
										unsafe = true,
										tooltip = "Rage aimbot attempts to resolve player offsets and positions, Disable if you are having issues with resolver.",
									},
									{
										type = "DropBox",
										name = "Velocity Modifications",
										value = 1,
										unsafe = true,
										values = { "Off", "Zero", "Tick", "Ping" },
										tooltip = "Corrects velocity of players.",
									},
									{
										type = "Toggle",
										name = "Priority Only",
										value = false,
										tooltip = "Aimbot only targets prioritized players.",
									},
								}},
							}
						},
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
											value = false,
											tooltip = "Enables 2D rendering, disabling this could improve performance. Does not affect Chams."
										},
										{
											type = "Toggle",
											name = "Name",
											value = true,
											extra = {
												{
													type = "ColorPicker",
													name = "Color",
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
													name = "Color Fill",
													color = { 255, 0, 0, 0 },
												},
												{
													type = "ColorPicker",
													name = "Color Box",
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
													name = "Color Low",
													color = { 255, 0, 0, 0 },
												},
												{
													type = "ColorPicker",
													name = "Color Max",
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
													name = "Color",
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
													name = "Color",
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
											values = { { "Use Large Text", false }, { "Level", true }, { "Distance", true }, { "Frozen", true }, { "Resolved", false }, { "Backtrack", false },  },
										},
										{
											type = "Toggle",
											name = "Chams",
											value = false,
											extra = {
												{
													type = "ColorPicker",
													name = "Visible Chams",
													color = { 255, 0, 0, 200 },
												},
												{
													type = "ColorPicker",
													name = "Invisible Chams",
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
													name = "Color",
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
													name = "Color Fill",
													color = { 0, 255, 0, 0 },
												},
												{
													type = "ColorPicker",
													name = "Color Box",
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
													name = "Color Low",
													color = { 255, 0, 0, 255 },
												},
												{
													type = "ColorPicker",
													name = "Color Max",
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
													name = "Color",
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
													name = "Color",
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
											values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }  },
										},
										{
											type = "Toggle",
											name = "Chams",
											value = false,
											extra = {
												{
													type = "ColorPicker",
													name = "Visible Chams",
													color = { 0, 255, 0, 200 },
												},
												{
													type = "ColorPicker",
													name = "Invisible Chams",
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
													name = "Color",
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
													name = "Color Fill",
													color = { 127, 72, 163, 0 },
												},
												{
													type = "ColorPicker",
													name = "Color Box",
													color = { 127, 72, 163, 150 },
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
													name = "Color Low",
													color = { 255, 0, 0, 255 },
												},
												{
													type = "ColorPicker",
													name = "Color Max",
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
													name = "Color",
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
													name = "Color",
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
											values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }  },
										},
										{
											type = "Toggle",
											name = "Chams",
											value = false,
											extra = {
												{
													type = "ColorPicker",
													name = "Visible Chams",
													color = { 127, 72, 163, 200 },
												},
												{
													type = "ColorPicker",
													name = "Invisible Chams",
													color = { 127, 72, 163, 100 },
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
									}
								},
							},
							{
								name = {"ESP Settings", "Crosshair"},
								pos = UDim2.new(0,0,11/20,4),
								size = UDim2.new(.5,-4,9/20,-4),
								type = "Panel",
								{content = {
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
								}},
								{content={
									{
										name = {"Basic", "Advanced"},
										borderless = true,
										pos = UDim2.new(0,0,0,0),
										size = UDim2.new(1,0,1,0),
										{content={
											{
												type = "Toggle",
												name = "Enabled",
												value = false,
												extra = {
													{
														type = "ColorPicker",
														name = "Outter",
														color = { 0, 0, 0, 255 },
													},
													{
														type = "ColorPicker",
														name = "Inner",
														color = { 127, 72, 163, 255 },
													},
												},
											},
											{
												type = "ComboBox",
												name = "Setup",
												values = {{"Top",true},{"Bottom",true},{"Left",true},{"Right",true},{"Center",true}}
											},
											{
												type = "Slider",
												name = "Width",
												value = 2,
												min = 1,
												max = 200,
												decimal = 0,
												suffix = "px",
											},
											{
												type = "Slider",
												name = "Height",
												value = 15,
												min = 1,
												max = 200,
												decimal = 0,
												suffix = "px",
											},
											{
												type = "Slider",
												name = "Gap",
												value = 25,
												min = 0,
												max = 200,
												decimal = 0,
												suffix = "px",
											},
										}},
										{content={
											{
												type = "Toggle",
												name = "Enabled",
												value = false,
											},
											{
												type = "DropBox",
												name = "Type",
												value = 1,
												values = { "Additive", "Wave" },
											},
											{
												type = "Slider",
												name = "Speed",
												value = 20,
												min = -500,
												max = 500,
												custom = { [0] = "Nothing..." },
												suffix = "",
											},
											{
												type = "Slider",
												name = "Amplitude",
												value = 5,
												min = -100,
												max = 100,
												custom = { [0] = "Nothing..." },
												suffix = "",
											},
										}},
									}
								}}
							},
							{
								name = {"Camera Visuals", "Extra"},
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
											type = "Toggle",
											name = "Third Person Absolute",
											value = false,
											extra = {},
											tooltip = "Forces the L3P character to be exactly on you.",
										},
										{
											type = "Toggle",
											name = "First Person Third",
											value = false,
											extra = {},
											tooltip = "See through the eyes of L3P",
										},
										{
											type = "Slider",
											name = "Third Person Distance",
											value = 60,
											min = -10,
											max = 150,
										},
										{
											type = "Slider",
											name = "Third Person X Offset",
											value = 0,
											min = -50,
											max = 50,
										},
										{
											type = "Slider",
											name = "Third Person Y Offset",
											value = 0,
											min = -50,
											max = 50,
										},
									},
								},
								{
									content = {
										{
											type = "Toggle",
											name = "Show Keybinds",
											value = false,
											extra = {},
										},
										{
											type = "Toggle",
											name = "Log Keybinds",
											value = false
										},
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
											name = "Remove Weapon Skin",
											value = false,
											tooltip = "If a loaded weapon has a skin, it will remove it.",
										},
										{
											type = "Toggle",
											name = "Absolute Spectator",
											value = false,
											extra = {},
											tooltip = "Makes the spectator use repupdate instead of parts"
										},
									},
								},
							},
							{
								name = {"World", "Misc", "FOV"},
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
											decimal = 1,
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
													name = "Tracer Color",
													color = { 201, 69, 54, 255 },
												},
											},
										}
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
													name = "Warning Color",
													color = { 68, 92, 227 },
												}
											},
											tooltip = "Displays where grenades that will deal damage to you will land and the damage they will deal.",
										},
										{
											type = "Toggle",
											name = "Grenade Prediction",
											value = true,
											extra = {
												{
													type = "ColorPicker",
													name = "Prediction Color",
													color = { 68, 92, 227 },
												}
											},
											tooltip = "Shows where your grenades may land before throwing it.",
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
						content = {
							{
								name = {"Movement", "Tweaks", "Chat Spam"},
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(.5,-4,5.5/10,-4),
								type = "Panel",
								{content = {
									{
										type = "Toggle",
										name = "Fly",
										value = false,
										unsafe = true,
										tooltip = "Manipulates your velocity to make you fly.\nUse 60 speed or below to never get flagged.",
										extra = {
											{
												type = "KeyBind",
												key = "B",
												toggletype = 2,
											}
										},
									},
									{
										type = "Slider",
										name = "Fly Speed",
										min = 0,
										max = 400,
										suffix = " stud/s",
										decimal = 1,
										value = 55,
										custom = {
											[400] = "Absurdly Fast",
										},
									},
									{
										type = "Toggle",
										name = "Auto Jump",
										value = false,
										tooltip = "When you hold the spacebar, it will automatically jump repeatedly, ignoring jump delay.",
									},
									{
										type = "Toggle",
										name = "Speed",
										value = false,
										unsafe = true,
										tooltip = "Manipulates your velocity to make you move faster, unlike fly it doesn't make you fly.\nUse 60 speed or below to never get flagged.",
										extra = {
											{
												type = "KeyBind",
												key = nil,
												toggletype = 4,
											}
										},
									},
									{
										type = "DropBox",
										name = "Speed Type",
										value = 1,
										values = { "Always", "In Air", "On Hop" },
									},
									{
										type = "Slider",
										name = "Speed Factor",
										value = 40,
										min = 1,
										max = 400,
										suffix = " stud/s",
									},
									{
										type = "Toggle",
										name = "Avoid Collisions",
										value = false,
										tooltip = "Attempts to stops you from running into obstacles\nfor Speed and Circle Strafe.",
										extra = {
											{
												type = "KeyBind",
												toggletype = 4,
											}
										}
									},
									{
										type = "Slider",
										name = "Avoid Collisions Scale",
										value = 100,
										min = 0,
										max = 100,
										suffix = "%",
									},
									{
										type = "Toggle",
										name = "Circle Strafe",
										value = false,
										tooltip = "When you hold this keybind, it will strafe in a perfect circle.\nSpeed of strafing is borrowed from Speed Factor.",
										extra = {
											{
												type = "KeyBind",
												key = nil,
												toggletype = 2,
											}
										},
									},
									{
										type = "Slider",
										name = "Circle Strafe Scale",
										value = 20,
										min = 0,
										max = 100,
										suffix = "x",
									},
								}},
								{content = {
									{
										type = "Toggle",
										name = "Jump Power",
										value = false,
										tooltip = "Shifts movement jump power by X%.",
										unsafe = true
									},
									{
										type = "Slider",
										name = "Jump Power Percentage",
										value = 150,
										min = 0,
										max = 1000,
										suffix = "%",
									},
									{
										type = "Toggle",
										name = "Prevent Fall Damage",
										value = false,
										unsafe = true
									},
								}},
								{content = {
									{
										type = "Toggle",
										name = "Enabled",
										value = false,
										tooltip = "Try not to turn this on when playing legit :)\nWARNING: This could make anti-votekick break due to chat limitations!",
										unsafe = true
									},
									{
										type = "DropBox",
										name = "Presets",
										value = 1,
										values = {"Bitch Bot", "Chinese Propaganda", "Youtube Title", "Emojis", "Deluxe", "t0nymode", "Douchbag", "Custom"},
									},
									{
										type = "Slider",
										name = "Spam Delay",
										min = 1.5,
										max = 10,
										suffix = "s",
										decimal = 1,
										value = 1.5,
										custom = {
											[1.5] = "Chat Rape",
										},
									},
									{
										type = "Toggle",
										name = "Newline Mixer",
										value = true,
										tooltip = "Instead of showing each line, it mixes lines together.",
									},
									{
										type = "Toggle",
										name = "Spam On Kills",
										value = true,
										tooltip = "Makes the chat spammer only spam per kill, extra synatxes are added such as {weapon}, {player}, {hitpart}",
									},
									{
										type = "Slider",
										name = "Minimum Kills",
										min = 0,
										max = 15,
										suffix = " kill(s)",
										decimal = 0,
										value = 0,
										custom = {
											[0] = "Spam Immediately",
										},
									},
									{
										type = "Slider",
										name = "Start Delay",
										min = 0,
										max = 10,
										suffix = "s",
										decimal = 1,
										value = 0,
										custom = {
											[0] = "Spam Immediately",
										},
									},
								}}
							},
							{
								name = {"Server Hopper", "Votekick"},
								pos = UDim2.new(0,0,5.5/10,4),
								size = UDim2.new(.5,-4,1-(5.5/10),-4),
								type = "Panel",
								{content = {
									{
										type = "Toggle",
										name = "Hop On Kick",
										value = false,
										tooltip = "This will auto-hop you to your desired servers when kicked.",
										extra = {
											{
												type = "KeyBind",
												name = "Force Server Hop",
												toggletype = 4,
												tooltip = "This will hop you when you press this."
											}
										}
									},
									{
										type = "Slider",
										name = "Hop Delay",
										min = 0,
										max = 20,
										suffix = "s",
										decimal = 1,
										value = 0,
										custom = {
											[0] = "Instantaneous Hop",
										},
										tooltip = "Delays server hopper by a certain amount of seconds."
									},
									{
										type = "DropBox",
										name = "Sorting",
										value = 1,
										values = {"Lowest Players", "Highest Players"},
									},
									{
										type = "Button",
										name = "Get JobId",
										confirm = "Are you sure?",
										clicked = "Copied to clipboard!",
										callback = function()
											setclipboard(game.JobId)
										end
									},
									{
										type = "Button",
										name = "Clear Blacklist",
										confirm = "Are you sure 100%?",
										tooltip = "This will clear the server blacklist, careful as this would mean you may join votekicked servers!",
										callback = function()
											BBOT.serverhopper:ClearBlacklist()
										end
									},
									{
										type = "Button",
										name = "Rejoin",
										confirm = "Are you sure?",
										callback = function()
											BBOT.serverhopper:Hop(game.JobId)
										end
									},
									{
										type = "Button",
										name = "Hop",
										confirm = "Are you sure?",
										callback = function()
											BBOT.serverhopper:RandomHop()
										end
									},
								}},
								{content = {
									{
										type = "Toggle",
										name = "Anti Votekick",
										value = false,
										tooltip = "WARNING: This requires 2 or more rank 25 accounts to work! You can do 1 rank 25 but it would only delay a votekick by ~90-120 seconds",
									},
									{
										type = "Text",
										name = "Reason",
										value = "Aimbot",
									},
									{
										type = "Slider",
										name = "Votekick On Kills",
										min = 0,
										max = 30,
										suffix = " kills",
										decimal = 0,
										value = 4,
										custom = {
											[0] = "Instantaneous Kick",
										},
										tooltip = "Delays votekick once at a certain amount of kills."
									},
								}},
							},
							{
								name = {"Extra", "Sounds", "Exploits"},
								pos = UDim2.new(.5,4,0,0),
								size = UDim2.new(.5,-4,1,0),
								type = "Panel",
								{content = {
									{
										type = "Toggle",
										name = "Auto Death",
										value = false,
										tooltip = "Lowers your total KD so that you don't get flagged for bans."
									},
									{
										type = "Toggle",
										name = "Auto Spawn",
										value = false,
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											}
										}
									},
									{
										type = "Button",
										name = "Banlands",
										confirm = "Are you 100% sure?",
										unsafe = true,
										callback = function()
											BBOT.aux.network:send("logmessage", "Fuck this shit I'm out")
										end,
										tooltip = "Yeets you to the banlands private server, (DOING THIS WILL BAN YOUR ACCOUNT)"
									}
								}},
								{content = {
									{
										type = "Text",
										name = "Hit",
										value = "6229978482",
										tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
									},
									{
										type = "Slider",
										name = "Hit Volume",
										min = 0,
										max = 100,
										suffix = "%",
										decimal = 1,
										value = 100,
										custom = {},
									},
									{
										type = "Text",
										name = "Headshot",
										value = "6229978482",
										tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
									},
									{
										type = "Slider",
										name = "Headshot Volume",
										min = 0,
										max = 100,
										suffix = "%",
										decimal = 1,
										value = 100,
										custom = {},
									},
									{
										type = "Text",
										name = "Kill",
										value = "6229978482",
										tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
									},
									{
										type = "Slider",
										name = "Kill Volume",
										min = 0,
										max = 100,
										suffix = "%",
										decimal = 1,
										value = 100,
										custom = {},
									},
									{
										type = "Text",
										name = "Headshot Kill",
										value = "6229978482",
										tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
									},
									{
										type = "Slider",
										name = "Headshot Kill Volume",
										min = 0,
										max = 100,
										suffix = "%",
										decimal = 1,
										value = 100,
										custom = {},
									},
									{
										type = "Text",
										name = "Fire",
										value = "",
										tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
									},
									{
										type = "Slider",
										name = "Fire Volume",
										min = 0,
										max = 100,
										suffix = "%",
										decimal = 1,
										value = 100,
										custom = {},Fire
									},
								}},
								{content = {
									--[[{
										type = "Toggle",
										name = "Bypass Speed Checks",
										value = false,
										tooltip = "Attempts to bypass maximum speed limit on the server."
									},]]
									{
										type = "Toggle",
										name = "Spaz Attack",
										value = false,
										unsafe = true,
										tooltip = "Literally makes you look like your having a stroke."
									},
									{
										type = "Slider",
										name = "Spaz Attack Intensity",
										min = 0.1,
										max = 6,
										suffix = "",
										decimal = 1,
										value = 3,
										custom = {
											[8] = "Unbearable",
										},
									},
									{
										type = "Toggle",
										name = "Click TP",
										value = false,
										unsafe = true,
										extra = {
											{
												type = "KeyBind",
												key = nil,
												toggletype = 4
											}
										},
										tooltip = "Ez clap TP",
									},
									{
										type = "Slider",
										name = "Click TP Range",
										min = 0,
										max = 200,
										suffix = " studs",
										decimal = 1,
										value = 50,
										custom = {
											[0] = "Fucking Insane",
										},
									},
									{
										type = "Toggle",
										name = "Teleport to Player",
										value = false,
										unsafe = true,
										extra = {
											{
												type = "KeyBind",
												key = nil,
												toggletype = 4--? i'm not sure
											}
										},
									},
									{
										type = "ComboBox",
										name = "Auto Teleport",
										values = {
											{ "On Spawn", false },
											{ "On Enemy Spawn", false },
											{ "Enemies Alive", false },
										},
										unsafe = true,
										extra = {
											{
												type = "KeyBind",
												key = nil,
												toggletype = 2--? i'm not sure
											},
											{
												type = "ColorPicker",
												name = "Path Color",
												color = { 127, 72, 163, 150 },
											}
										},
									},
									--[[{
										type = "Toggle",
										name = "Invisibility",
										value = false,
										tooltip = "Wtf where did he go?",
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											}
										}
									},
									{
										type = "Toggle",
										name = "Client Crasher",
										value = false,
										tooltip = "Dear god...",
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											}
										}
									},
									{
										type = "Toggle",
										name = "Server Crasher",
										value = false,
										tooltip = "Dear god...",
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											}
										}
									},
									{
										type = "Slider",
										name = "Server Crasher Intensity",
										min = 1,
										max = 16,
										suffix = "",
										decimal = 0,
										value = 4,
										custom = {
											[15] = "Literally Unplayable",
											[16] = "Insta-Crash",
										},
									},]]
									{
										type = "Toggle",
										name = "Tick Division Manipulation",
										value = false,
										unsafe = true,
										tooltip = "Makes your velocity go 10^n m/s, god why raspi you fucking idiot",
									},
									{
										type = "Slider",
										name = "Tick Division Scale",
										min = 0.1,
										max = 12,
										suffix = "^10 studs/s",
										decimal = 1,
										value = 3,
										custom = {
											[12] = "Fucking Insane",
										},
										tooltip = "Each value here is tick/10^n, so velocity go *wait what the fuck*",
									},
									{
										type = "Toggle",
										name = "Revenge Grenade",
										value = false,
										unsafe = true,
										tooltip = "Automatically teleports a grenade to the person who killed you.",
									},
									{
										type = "Toggle",
										name = "Auto Grenade Frozen",
										value = false,
										unsafe = true,
										tooltip = "Automatically teleports a grenade to people frozen, useful against semi-god users.",
									},
									{
										type = "Slider",
										name = "Auto Grenade Wait",
										min = 0,
										max = 12,
										suffix = "s",
										decimal = 1,
										value = 6,
										custom = {
											[0] = "Full Send It Bro",
										},
										tooltip = "Time till auto nade should send",
									},
									{
										type = "Toggle",
										name = "Blink",
										value = false,
										unsafe = true,
										tooltip = "Enables when you are standing still. Staying longer than 8 seconds may result in a auto-slay when you move. Grenades and knives still affect you!",
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											},
											{
												type = "ColorPicker",
												name = "Path Color",
												color = { 127, 72, 163, 150 },
											}
										}
									},
									{
										type = "Toggle",
										name = "Blink Allow Movement",
										value = false,
										tooltip = "Won't check if you are standling still, it will just activate immediately",
									},
									{
										type = "Slider",
										name = "Blink Keep Alive",
										min = 0,
										max = 12,
										suffix = "s",
										decimal = 1,
										value = 7,
										custom = {
											[0] = "Invulnerable",
										},
										tooltip = "Attempts to allow movement when in temp-god when needed, WARNING: This can make you vulnerable for a split second",
									},
									{
										type = "Toggle",
										name = "Repupdate Spammer",
										value = false,
										unsafe = true,
										tooltip = "Sends repupdate per frame, just so you can move faster :)",
									},
									{
										type = "Toggle",
										name = "Anti Grenade TP",
										value = false,
										unsafe = true,
										tooltip = "Moves you right after a kill, to hopefully... HOPEFULLY. Avoid a grenade TP.",
									},
									{
										type = "ComboBox",
										name = "Anti Grenade TP Points",
										values = {
											{ "Up", true },
											{ "Down", true },
											{ "Left", false },
											{ "Right", false },
											{ "Forward", true },
											{ "Backward", true },
										},
									},
									{
										type = "Slider",
										name = "Anti Grenade TP Distance",
										min = 2,
										max = 100,
										suffix = " studs",
										decimal = 1,
										value = 25,
										custom = {},
									},
								}},
							},
						},
					},
					{
						name = "Settings",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Container",
						content = {
							{
								name = "Cheat Settings",
								pos = UDim2.new(0,0,5.5/10,4),
								size = UDim2.new(.5,-4,1-5.5/10,-4),
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
										type = "Toggle",
										name = "Open Menu On Boot",
										value = true,
										extra = {},
									},
									{
										type = "Toggle",
										name = "Background",
										value = false,
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
										tooltip = "Changes the menu name, not the watermark"
									},
									{
										type = "Text",
										name = "Custom Watermark",
										value = "Bitch Bot",
										extra = {},
										tooltip = "Changes the watermark at the top left, there are text arguments as well such as {username}, {version}, {date}, {time} and {fps}"
									},
									{
										type = "Text",
										name = "Custom Logo",
										value = "Bitch Bot",
										extra = {},
										tooltip = "To put a custom logo, you need an imgur image Id, like this -> https://i.imgur.com/g2k0at.png, only input the 'g2k0at' part! Changing this to a blank box will remove the logo."
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
								name = "Menus",
								pos = UDim2.new(.5,4,0,0),
								size = UDim2.new(.5,-4,5/10,-4),
								type = "Panel",
								content = {
									{
										type = "Toggle",
										name = "Weapon Customization",
										value = false,
										extra = {},
									},
									{
										type = "Toggle",
										name = "Environment",
										value = false,
										extra = {},
									},
								}
							},
							{
								name = "Configs",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(.5,-4,5.5/10,-4),
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
											local s = BBOT.config:GetValue("Main", "Settings", "Configs", "Config Name")
											BBOT.config:Save(s)
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autosave File")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autoload File")
											local configs = BBOT.config:Discover()
											BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
											menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
											BBOT.notification:Create("Saved config: " .. s)
										end
									},
									{
										type = "Button",
										name = "Load",
										confirm = "Are you sure?",
										callback = function()
											local s = BBOT.config:GetValue("Main", "Settings", "Configs", "Configs")
											BBOT.config:Open(s)
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Config Name")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autosave File")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autoload File")
											local configs = BBOT.config:Discover()
											BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
											menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
											BBOT.notification:Create("Loaded config: " .. s)
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
			{
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
								name = "Ballistics",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(.5,-4,2/10,-4),
								type = "Panel",
								content = {
									{
										type = "ComboBox",
										name = "Fire Modes",
										values = {
											{ "Semi-Auto", false },
											{ "Burst-2", false },
											{ "Burst-3", false },
											{ "Full-Auto", false },
										},
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Firerate",
										min = 0,
										max = 2000,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
								}
							},
							{
								name = "Accuracy",
								pos = UDim2.new(0,0,2/10,4),
								size = UDim2.new(.5,-4,4/10,-4),
								type = "Panel",
								content = {
									{
										type = "Slider",
										name = "Camera Kick",
										min = 0,
										max = 600,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Displacement Kick",
										min = 0,
										max = 600,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Rotation Kick",
										min = 0,
										max = 600,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Hip Choke",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Aim Choke",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
								}
							},
							{
								name = "Handling",
								pos = UDim2.new(0,0,6/10,8),
								size = UDim2.new(.5,-4,4/10,-8),
								type = "Panel",
								content = {
									{
										type = "Slider",
										name = "Crosshair Spread",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
										tooltip = "This does affect the spread of your guns by the ways..."
									},
									{
										type = "Slider",
										name = "Aiming Speed",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Equip Speed",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "Ready Speed",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
										tooltip = "The time it takes to go from a sprinting stance to a \"ready to fire\" stance"
									},
								}
							},
							{
								name = "Movement",
								pos = UDim2.new(.5,4,0,0),
								size = UDim2.new(.5,-4,.5,-4),
								type = "Panel",
								content = {
									{
										type = "DropBox",
										name = "Weapon Style",
										value = 1,
										values = {"Off", "Rambo", "Doom", "Quake III", "Half-Life"}
									},
									{
										type = "Slider",
										name = "Bob Scale",
										min = -200,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100
									},
									{
										type = "Slider",
										name = "Sway Scale",
										min = -200,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100
									},
									{
										type = "Slider",
										name = "Swing Scale",
										min = -200,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100
									},
								}
							},
							{
								name = "Animations",
								pos = UDim2.new(.5,4,.5,4),
								size = UDim2.new(.5,-4,.5,-4),
								type = "Panel",
								content = {
									{
										type = "Slider",
										name = "Reload Scale",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
									{
										type = "Slider",
										name = "OnFire Scale",
										min = 0,
										max = 200,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
									},
								}
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
								name = "Enabled",
								value = false,
								extra = {},
								tooltip = "Do note this is not server-sided!"
							},
							{
								name = { "Slot1", "Slot2", "SkinDB" },
								pos = UDim2.new(0,0,0,21),
								size = UDim2.new(1,0,1,-21),
								borderless = true,
								type = "Tabs",
								{content=skins_content},
								{content=skins_content},
								{
									content = {
										{
											name = "SkinDBList", -- No type means auto-set to panel
											pos = UDim2.new(0,0,0,0),
											size = UDim2.new(1,0,1,0),
											type = "Custom",
											callback = function()
												local container = gui:Create("Container")
												local search = gui:Create("TextEntry", container)
												search:SetTextSize(13)
												search:SetText("")
												search:SetSize(1,0,0,16)

												local skinlist = gui:Create("List", container)
												skinlist:SetPos(0,0,0,16+4)
												skinlist:SetSize(1,0,1,-16-4)

												skinlist:AddColumn("Name")
												skinlist:AddColumn("AssetId")
												skinlist:AddColumn("Case")
												
												--[[if not BBOT.weapons or not BBOT.weapons.skindatabase then return container end

												for name, skinId in next, BBOT.weapons.skindatabase do
													local a, b, c = tostring(name), tostring(skinId.TextureId or "Unknown"), tostring(skinId.Case or "Unknown")
													local line = skinlist:AddLine(a, b, c)
													line.searcher = a .. " " .. b .. " " .. c
												end

												local function Refresh_List()
													if not BBOT.weapons.skindatabase then return end
													local tosearch = search:GetText()
													for i, v in next, skinlist.scrollpanel.canvas.children do
														if tosearch == "" or string.find(string.lower(v.searcher), string.lower(tosearch), 1, true) then
															v:SetVisible(true)
														else
															v:SetVisible(false)
														end
													end
													skinlist:PerformOrganization()
												end

												function search:OnValueChanged()
													Refresh_List()
												end

												Refresh_List()]]
												return container
											end,
											content = {}
										}
									}
								},
							}
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
						name = "Priorties And Friends",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Container",
						content = {
							{
								name = "Player List", -- No type means auto-set to panel
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Custom",
								callback = function()
									local container = gui:Create("Container")
									local search = gui:Create("TextEntry", container)
									search:SetTextSize(13)
									search:SetText("")
									search:SetSize(1,0,0,16)
									search:SetPlaceholder("Search Here")

									local playerlist = gui:Create("List", container)
									playerlist:SetPos(0,0,0,16+6)
									playerlist:SetSize(1,0,1,-16-6-108)

									playerlist:AddColumn("Name")
									playerlist:AddColumn("Team")
									playerlist:AddColumn("Priority")

									local function Refresh_List()
										local tosearch = search:GetText()
										local table = BBOT.table
										local players = BBOT.service:GetService("Players")
										local localplayer = BBOT.service:GetService("LocalPlayer")
										local checked = {}

										for i, v in next, players:GetChildren() do
											if v == localplayer then continue end
											local children = playerlist.scrollpanel.canvas.children
											for i=1, #children do
												if children[i].player == v then
													checked[v] = true
													break 
												end
											end
											if not checked[v] then
												local state = "Neutral"
												local priority = config.priority[v.UserId]
												if priority then
													if priority > 0 then
														state = "Priority (" .. priority .. ")"
													elseif priority < 0 then
														state = "Friendly (" .. (-priority) .. ")"
													end
												end
												local line = playerlist:AddLine(v.Name, v.Team.Name, state)
												line.team = v.Team.Name
												line.player = v
												checked[v] = true
											end
										end

										for i, v in next, playerlist.scrollpanel.canvas.children do
											if not v.player or not checked[v.player] then
												v:Remove()
											elseif tosearch == "" or string.find(string.lower(v.children[1].text:GetText()), string.lower(tosearch), 1, true) then
												v:SetVisible(true)
											else
												v:SetVisible(false)
											end
										end

										playerlist:PerformOrganization()
									end

									function search:OnValueChanged()
										Refresh_List()
									end

									local target = nil

									BBOT.timer:Simple(.1, Refresh_List)

									local playerbox = gui:Create("Box", container)
									playerbox:SetPos(0,0,1,-100)
									playerbox:SetSize(1,0,0,100)

									local aline = gui:Create("Container", playerbox)
									aline.background_border = aline:Cache(BBOT.draw:Box(0, 0, 0, 0, 0, gui:GetColor("Border")))
									function aline:PerformLayout(pos, size)
										self.background_border.Position = pos
										self.background_border.Size = size
									end
									aline:SetPos(.7,-1,0,2)
									aline:SetSize(0,2,1,-4)

									local image_container = gui:Create("Box", playerbox)
									image_container:SetPos(0, 4, 0, 4)
									image_container:SetSize(0, 100-8, 0, 100-8)

									local player_image = gui:Create("Image", image_container)
									player_image:SetPos(0, 0, 0, 0)
									player_image:SetSize(1, 0, 1, 0)
									player_image:SetImage(BBOT.menu.images[5])

									local player_name = gui:Create("Text", playerbox)
									player_name:SetPos(0, 104, 0, 2)
									player_name:SetText("No Player Selected")

									local w, h = player_name:GetTextSize()
									local player_state = gui:Create("Text", playerbox)
									player_state:SetPos(0, 104, 0, 2 + (2 + h))
									player_state:SetText("State: Disconnected")

									local player_rank = gui:Create("Text", playerbox)
									player_rank:SetPos(0, 104, 0, 2 + (4 + h*2))
									player_rank:SetText("Rank: N/A")

									local player_kd = gui:Create("Text", playerbox)
									player_kd:SetPos(0, 104, 0, 2 + (6 + h*3))
									player_kd:SetText("KD: N/A")

									local options_container = gui:Create("Container", playerbox)
									options_container:SetPos(.7, 6, 0, 4)
									options_container:SetSize(.3, -10, 1, -8)

									local Y = 0
									-- priority
									local player_priority
									do
										local cont = gui:Create("Container", options_container)
										local text = gui:Create("Text", cont)
										text:SetPos(0, 0, 0, 0)
										text:SetTextSize(13)
										text:SetText("Priority")
										if config.unsafe then
											text:SetColor(unsafe_color)
										end
										local slider = gui:Create("Slider", cont)
										player_priority = slider
										slider.suffix = ""
										slider.min = -1
										slider.max = 10
										slider.decimal = 0
										slider.custom = {}
										slider:SetValue(0)
										local _, tall = text:GetTextScale()
										slider:SetPos(0, 0, 0, tall+3)
										slider:SetSize(1, 0, 0, 10)
										cont:SetPos(0, 0, 0, 0)
										cont:SetSize(1, 0, 0, tall+2+10+1)
										function slider:OnValueChanged(new)
											if not target then return end
											config:SetPriority(target, new)
										end
										Y=Y+tall+2+10+7
									end

									-- Spectate
									do
										local button = gui:Create("Button", options_container)
										button:SetPos(0, 0, 0, Y)
										button:SetSize(1, 0, 0, 16)
										button:SetText("Spectate")
										button.OnClick = function()
											local spectator = BBOT.spectator
											if not target then
												if spectator:IsSpectating() then
													spectator:Spectate(nil)
												end
												return
											end
											if spectator:IsSpectating() == target then
												spectator:Spectate(nil)
												return
											end
											spectator:Spectate(target)
										end
										Y=Y+16+7
									end

									-- VoteKick
									do
										local button = gui:Create("Button", options_container)
										button:SetPos(0, 0, 0, Y)
										button:SetSize(1, 0, 0, 16)
										button:SetText("Votekick")
										button:SetConfirmation("Are you sure?")
										button.OnClick = function()
											if not target then return end
											votekick:Call(target, "Cheating")
										end
										Y=Y+16+7
									end

									function playerlist:OnSelected(row)
										target = row.player
										local selected = target
										player_name:SetText("Name: " .. target.Name)
										player_state:SetText("State: In-Lobby")

										--[[local data = BBOT.aux:GetPlayerData(target.Name)
										local playerrank = playerdata.Rank.Text
										local kills = playerdata.Kills.Text
										local deaths = playerdata.Deaths.Text

										player_rank:SetText("Rank: " .. playerrank)
										player_kd:SetText("KD: " .. kills .. "/" .. deaths)]]

										local uid = target.UserId
										player_priority:SetValue(config.priority[uid] or 0)
										BBOT.thread:Create(function()
											local data = game:HttpGet(string.format(
												"https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=100&height=100&format=png",
												uid
											))
											if not gui:IsValid(player_image) or target ~= selected then return end
											player_image:SetImage(data)
										end)
									end

									hook:Add("PlayerAdded", "BBOT:PlayerManager.Add", function(player)
										Refresh_List()
									end)

									hook:Add("PlayerRemoving", "BBOT:PlayerManager.Add", function(player)
										if target == player then
											target = nil
											player_state:SetText("State: Disconnected")
											player_rank:SetText("Rank: N/A")
										end
										Refresh_List()
									end)

									local wasalive, nextcheck = false, 0
									hook:Add("RenderStep.Last", "BBOT:PlayerManager.Tick", function()
										if nextcheck > tick() then return end
										nextcheck = tick() + .05
										for i, v in next, playerlist.scrollpanel.canvas.children do
											if v.Team and v.team ~= v.Team.Name then
												v.team = v.Team.Name
												v.children[2].text:SetText(v.Team.Name)
											end
										end

										if not target then return end
										local updater = BBOT.aux.replication.getupdater(target)
										if updater.alive ~= wasalive then
											wasalive = updater.alive
											if wasalive then
												player_state:SetText("State: In-Game")
											else
												player_state:SetText("State: In-Lobby")
											end
										end
									end)

									hook:Add("OnPriorityChanged", "BBOT:PlayerManager.Changed", function(player, old_priority, priority)
										local state = "Neutral"
										if priority then
											if priority > 0 then
												state = "Priority (" .. priority .. ")"
											elseif priority < 0 then
												state = "Friendly (" .. (-priority) .. ")"
											end
										end
										for i, v in next, playerlist.scrollpanel.canvas.children do
											if v.player == player then
												v.children[3].text:SetText(state)
												break
											end
										end
									end)

									return container
								end,
								content = {},
							},
						},
					},
					{
						name = "Bitch Bot Users",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Container",
						content = {
							{
								name = "Bitch Bot Room", -- No type means auto-set to panel
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Custom",
								callback = function()
									local container = gui:Create("Container")
									local search_users = gui:Create("TextEntry", container)
									search_users:SetTextSize(13)
									search_users:SetText("")
									search_users:SetPos(.75,4,0,0)
									search_users:SetSize(.25,-4,0,16)
									search_users:SetPlaceholder("Search Here")

									local userlist = gui:Create("ScrollPanel", container)
									userlist:SetPos(.75,4,0,16+6)
									userlist:SetSize(.25,-4,1,-16-6)

									local chatroom_container = gui:Create("Container", container)
									chatroom_container:SetPos(0,0,0,0)
									chatroom_container:SetSize(.75,-4,1,0)

									local search_chatroom = gui:Create("TextEntry", chatroom_container)
									search_chatroom:SetTextSize(13)
									search_chatroom:SetText("")
									search_chatroom:SetPos(0,0,0,0)
									search_chatroom:SetSize(1,0,0,16)
									search_chatroom:SetPlaceholder("Search Here")

									local chatroom = gui:Create("ScrollPanel", chatroom_container)
									chatroom:SetPos(0,0,0,16+6)
									chatroom:SetSize(1,0,1,-16-6-18-6)

									local chatbox = gui:Create("TextEntry", chatroom_container)
									chatbox:SetTextSize(13)
									chatbox:SetText("")
									chatbox:SetPos(0,0,1,-18)
									chatbox:SetSize(1,0,0,18)
									chatbox:SetPlaceholder("Type Here")

									local bbotusers = {
										{"eprosync", "alhIteraa2413", "No"},
										{"toyko", "Gamerrrz25", "Yes"},
									}

									local function AddToChat(txt)
										local panel = gui:Create("Container")
										panel:SetSize(1, 0, 0, 16)
										panel.mouseinputs = true
										chatroom:Add(panel)
										local username = gui:Create("Text", panel)
										username:SetText(txt)
										username:SetTextAlignmentX(Enum.TextXAlignment.Left)
										username:SetTextAlignmentY(Enum.TextYAlignment.Center)
										username:SetSize(1, 0, 1, 0)
										chatroom:PerformOrganization()
									end

									AddToChat("Client: Connected to websocket #########")
									AddToChat("Server: Welcome to the chat room")

									local function Refresh_List()
										local tosearch = search_users:GetText()
										local checked = {}

										for i=1, #bbotusers do
											local v = bbotusers[i]
											local children = userlist.canvas.children
											for i=1, #children do
												if children[i].data[1] == v[1] then
													checked[v[1]] = true
													break 
												end
											end
											if not checked[v[1]] then
												local panel = gui:Create("Container")
												panel:SetSize(1, 0, 0, 16)
												panel.mouseinputs = true
												userlist:Add(panel)
												panel.tooltip = "Account: " .. v[2] .. "\nJoinable: " .. v[3]
												local username = gui:Create("Text", panel)
												username:SetText(v[1])
												username:SetTextAlignmentX(Enum.TextXAlignment.Left)
												username:SetTextAlignmentY(Enum.TextYAlignment.Center)
												username:SetSize(1, 0, 1, 0)
												panel.data = v
												panel.search = v[1] .. v[2]
												checked[v[1]] = true
											end
										end

										for i, v in next, userlist.canvas.children do
											if not checked[v.data[1]] then
												v:Remove()
											elseif tosearch == "" or string.find(string.lower(v.search), string.lower(tosearch), 1, true) then
												v:SetVisible(true)
											else
												v:SetVisible(false)
											end
										end

										userlist:PerformOrganization()
									end

									function search_users:OnValueChanged()
										Refresh_List()
									end

									BBOT.timer:Simple(.1, Refresh_List)

									return container
								end,
								content = {},
							},
						},
					},
				}
			}
		}
	elseif BBOT.game == "bad business" then

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
						type = "Toggle",
						name = "Use Barrel",
						value = false,
						tooltip = "Instead of calculating the FOV from the camera, it uses the weapon barrel's direction."
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
				size = UDim2.new(.5,-4,4/10,-4),
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
						type = "Slider",
						name = "Barrel Comp X",
						value = 100,
						min = 0,
						max = 1000,
						suffix = "%",
						decimal = 1,
						custom = { [0] = "Off" },
					},
					{
						type = "Slider",
						name = "Barrel Comp Y",
						value = 100,
						min = 0,
						max = 1000,
						suffix = "%",
						decimal = 1,
						custom = { [0] = "Off" },
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
				}
			},
			{
				name = {"Bullet Redirect", "Trigger Bot"},
				pos = UDim2.new(.5,4,4/10,4),
				size = UDim2.new(.5,-4,6/10,-4),
				type = "Panel",
				{content = {
					{
						type = "Toggle",
						name = "Enabled",
						value = false,
					},
					{
						type = "Toggle",
						name = "Use Barrel",
						value = true,
						tooltip = "Instead of calculating the FOV from the camera, it uses the weapon barrel's direction."
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
						name = "Aim In Time",
						min = 0,
						max = 2,
						value = .75,
						decimal = 2,
						suffix = "s",
						tooltip = "Time it takes to activate trigger bot by aiming in"
					},
					{
						type = "Slider",
						name = "Fire Time",
						min = 0,
						max = .5,
						value = .1,
						decimal = 3,
						suffix = "s",
						tooltip = "How long you need to stay in the circle to fire"
					},
					{
						type = "Slider",
						name = "Sprint to Fire Time",
						min = 0,
						max = .5,
						value = .1,
						decimal = 3,
						suffix = "s",
						tooltip = "Time from sprinting to the ability to fire"
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
						borderless = true,
						type = "Tabs",
						content = {
							{
								name = "Pistol",
								icon = "PISTOL",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Smg",
								icon = "SMG",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Rifle",
								icon = "RIFLE",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Shotgun",
								icon = "SHOTGUN",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(1,0,1,0),
								type = "Container",
								content = weapon_legit
							},
							{
								name = "Sniper",
								icon = "SNIPER",
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
						content = {}
					},
					{
						name = "Visuals",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Container",
						content = {},
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
								pos = UDim2.new(0,0,5.5/10,4),
								size = UDim2.new(.5,-4,1-5.5/10,-4),
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
										type = "Toggle",
										name = "Open Menu On Boot",
										value = true,
										extra = {},
									},
									{
										type = "Toggle",
										name = "Background",
										value = false,
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
										tooltip = "Changes the menu name, not the watermark"
									},
									{
										type = "Text",
										name = "Custom Watermark",
										value = "Bitch Bot",
										extra = {},
										tooltip = "Changes the watermark at the top left, there are text arguments as well such as {username}, {version}, {date}, {time} and {fps}"
									},
									{
										type = "Text",
										name = "Custom Logo",
										value = "Bitch Bot",
										extra = {},
										tooltip = "To put a custom logo, you need an imgur image Id, like this -> https://i.imgur.com/g2k0at.png, only input the 'g2k0at' part! Changing this to a blank box will remove the logo."
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
								name = "Menus",
								pos = UDim2.new(.5,4,0,0),
								size = UDim2.new(.5,-4,5/10,-4),
								type = "Panel",
								content = {
									{
										type = "Toggle",
										name = "Weapon Customization",
										value = false,
										extra = {},
									},
									{
										type = "Toggle",
										name = "Environment",
										value = false,
										extra = {},
									},
								}
							},
							{
								name = "Configs",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(.5,-4,5.5/10,-4),
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
											local s = BBOT.config:GetValue("Main", "Settings", "Configs", "Config Name")
											BBOT.config:Save(s)
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autosave File")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autoload File")
											local configs = BBOT.config:Discover()
											BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
											menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
											BBOT.notification:Create("Saved config: " .. s)
										end
									},
									{
										type = "Button",
										name = "Load",
										confirm = "Are you sure?",
										callback = function()
											local s = BBOT.config:GetValue("Main", "Settings", "Configs", "Configs")
											BBOT.config:Open(s)
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Config Name")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autosave File")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autoload File")
											local configs = BBOT.config:Discover()
											BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
											menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
											BBOT.notification:Create("Loaded config: " .. s)
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
		}
	else
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
						borderless = true,
						type = "Tabs",
						content = {}
					},
					{
						name = "Rage",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Container",
						content = {}
					},
					{
						name = "Visuals",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Container",
						content = {},
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
								pos = UDim2.new(0,0,5.5/10,4),
								size = UDim2.new(.5,-4,1-5.5/10,-4),
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
										type = "Toggle",
										name = "Open Menu On Boot",
										value = true,
										extra = {},
									},
									{
										type = "Slider",
										name = "Background Opacity",
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
										tooltip = "Changes the menu name, not the watermark"
									},
									{
										type = "Text",
										name = "Custom Watermark",
										value = "Bitch Bot",
										extra = {},
										tooltip = "Changes the watermark at the top left, there are text arguments as well such as {username}, {version}, {date}, {time} and {fps}"
									},
									{
										type = "Text",
										name = "Custom Logo",
										value = "Bitch Bot",
										extra = {},
										tooltip = "To put a custom logo, you need an imgur image Id, like this -> https://i.imgur.com/g2k0at.png, only input the 'g2k0at' part! Changing this to a blank box will remove the logo."
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
								size = UDim2.new(.5,-4,5.5/10,-4),
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
											local s = BBOT.config:GetValue("Main", "Settings", "Configs", "Config Name")
											BBOT.config:Save(s)
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autosave File")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autoload File")
											local configs = BBOT.config:Discover()
											BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
											menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
											BBOT.notification:Create("Saved config: " .. s)
										end
									},
									{
										type = "Button",
										name = "Load",
										confirm = "Are you sure?",
										callback = function()
											local s = BBOT.config:GetValue("Main", "Settings", "Configs", "Configs")
											BBOT.config:Open(s)
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Config Name")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autosave File")
											BBOT.config:SetValue(s, "Main", "Settings", "Configs", "Autoload File")
											local configs = BBOT.config:Discover()
											BBOT.config:GetRaw("Main", "Settings", "Configs", "Configs").list = configs
											menu.config_pathways[table.concat({"Main", "Settings", "Configs", "Configs"}, ".")]:SetOptions(configs)
											BBOT.notification:Create("Loaded config: " .. s)
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
		}
	end
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