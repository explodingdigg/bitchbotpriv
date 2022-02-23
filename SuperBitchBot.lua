--[[
	Hi, this is WholeCream further known as NiceCream
	I've decided to completely rework it to use some of my libraries.
	For future reference these libraries can be separated in the future!

	Your welcome - WholeCream

	!!READ!!
	Seems that synapse X has another bug with drawings
	They tend to... Crash... A lot...
	Reloading is still fine thought...

	PLEASE READ:
		The structure that each module should be loaded
		in the exact same order when file separation is done.

		DO NOT LEAVE THIS TO THE LAST MINUTE
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
local BBOT = BBOT or { username = (username or "dev"), alias = "Bitch Bot", version = "3.4.6d", __init = true } -- I... um... fuck off ok?
BBOT.Changelogs = [[N/A]]
_G.BBOT = BBOT

BBOT.Debug = {
	internal = isfile("bbdbg.txt"),
	menu = isfile("bbmdbg.txt"),
	draw = isfile("bbddbg.txt")
}

--[[while true do
	if game:IsLoaded() then
		break
	end;
	wait(.25)
end]]

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- This should always start before hand, this module is responsible for debugging
-- Example usage: BBOT.log(LOG_NORMAL, "How do I even fucking make this work?")
do
	local log = {}
	BBOT.log = log

	-- fallback on synapse x v2.9.1
	-- note: this is disabled due to problems with synapse's second console being all fucky wucky

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
		if not BBOT.Debug.internal then return end
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
				printconsole(text, white)
			elseif v[1] == 2 then
				local text = valuetoprintable(unpack(v[2]))
				printconsole("[" .. BBOT.alias .. "] " .. text)
			elseif v[1] == 3 then
				local text = valuetoprintable(unpack(v[2]))
				printconsole("[" .. BBOT.alias .. "] [WARN] " .. text, 240, 240, 0)
			elseif v[1] == 4 then
				local text = valuetoprintable(unpack(v[2]))
				printconsole("[" .. BBOT.alias .. "] [DEBUG] " .. text, 0, 120, 240)
			elseif v[1] == 5 then
				local text = valuetoprintable(unpack(v[2]))
				printconsole("[" .. BBOT.alias .. "] [ERROR] " .. text, 240, 0, 0)
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

	if _BBOT then
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

	function table.fyshuffle( tInput ) -- oh thats cool, fisher-yates shuffle (i think its called)
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
	local table = BBOT.table
	local math = table.deepcopy(math)
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

	-- floor to nearest multiple of x
	function math.multfloor( num, x )
		return num - (num % x)
	end

	-- ceil to nearest multiple of x
	function math.multceil( num, x )
		return num + (num % x)
	end

	function math.average(t)
		local sum = 0
		for i=1, #t do -- Get the sum of all numbers in t
			sum = sum + t[i]
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
	local _1_3 = 1/3;
	local _sqrt_3 = math.sqrt(3);

	-- ax + b (real roots)
	function math.linear(a, b) -- do I even need this? -- yea probably lol
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
				return k + (-2 * q) ^ _1_3;
			else
				return k - (2 * q) ^ _1_3;
			end
		elseif r < 0 then
			local m = (-p) ^ 0.5
			local d = math.atan2((-r) ^ 0.5, q) / 3;
			local u = m * math.cos(d);
			local v = m * math.sin(d);
			return k - 2 * u, k + u - _sqrt_3 * v, k + u + _sqrt_3 * v;
		elseif s < 0 then
			local m = -(-s) ^ _1_3;
			return k + p / m - m;
		else
			local m = s ^ _1_3;
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

-- Debug
do
	local table = BBOT.table
	local debug = table.deepcopy(debug)
	BBOT.debug = debug
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
		local font_system = BBOT.font
		local font_data = font
		if tostring(font_data) ~= "Font" then
			font_data = font_system:GetFont(font_data)
		end
		local font_size = font_data:GetTextBounds(size, ' ')
		if not font_size then return {text} end
		local sw = font_size.X

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
				local neww = font_data:GetTextBounds(size, t2[i2]).X
				
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

-- Color
do
	local math = BBOT.math
	local table = BBOT.table
	local string = BBOT.string
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

	function color.tostring(col, trans)
		return math.round(col.r*255) .. ", " .. math.round(col.g*255) .. ", " .. math.round(col.b*255) .. ", " .. math.round((trans or 1)*255)
	end

	function color.fromstring(str)
		local color_table = string.Explode(",", str)
		local r, g, b, a = tonumber(color_table[1]), tonumber(color_table[2]), tonumber(color_table[3]), (tonumber(color_table[4]) or 255)/255
		if not r or not g or not b then
			return false
		end
		r = math.clamp(r, 0, 255)
		g = math.clamp(g, 0, 255)
		b = math.clamp(b, 0, 255)
		a = math.clamp(a, 0, 255)
		return Color3.fromRGB(r, g, b), a
	end

	function color.tohex(col)
		return string.format("#%02X%02X%02X", col.r * 255, col.g * 255, col.b * 255)
	end

	function color.fromhex(hex)
		local r, g, b = string.match(hex, "^#?(%w%w)(%w%w)(%w%w)$")
		if not r or not g or not b then return false end
		return Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
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

	-- clamps the vector to a desired magnitude
	function vector.clamp(vec, min, max)
		if not max then
			max = min
			min = -math.huge
		end
		local unit = vec.Unit
		local magnitude = vec.Magnitude
		if magnitude < min then
			vec = unit * min
		elseif magnitude > max then
			vec = unit * max
		end
		return vec
	end

	function vector.floor(vec, spacing)
		return Vector3.new(vec.x - (vec.x % spacing), vec.y - (vec.y % spacing), vec.z - (vec.z % spacing))
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

	-- Used to determine the time of the bullet hitting, more like an assumption to be honest since you
	-- have a range which is basically max > t > min
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
		-- btw dot of itself is basically vector^2
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

-- Pathing
do
	local vector = BBOT.vector
	local pathing = {}
	BBOT.pathing = pathing

	function pathing.distance(a, b)
		local d = b - a
		return math.max(math.abs(d.x), math.abs(d.y), math.abs(d.z))
	end

	function pathing.sortbygoal(l, r)
		return l.global_goal < r.global_goal
	end

	function pathing.raycast(origin, direction, parameter, callback)
		local filter = parameter.FilterDescendantsInstances
		local whitelist = {}
		for i=1, #filter do
			whitelist[i] = filter[i]
		end
		local results
		local calls = 0
		while calls < 2000 do
			results = workspace:Raycast(origin, direction, parameter)
			if not results then break end
			if callback and callback(results) then
                table.insert(whitelist, results.Instance)
                parameter.FilterDescendantsInstances = whitelist
                calls = calls + 1
            else
                break 
            end
		end
		parameter.FilterDescendantsInstances = filter
		return results
	end

	do
		local blank_vector = Vector3.new()
		local meta = {}
		pathing.meta = {__index = meta}
	
		function meta:Init()
			self.path = {}
			self.success = false
			self.directions = {
				Vector3.xAxis,
				-Vector3.xAxis,
				Vector3.zAxis,
				-Vector3.zAxis,
				Vector3.yAxis,
				-Vector3.yAxis,
			}
			self.waypoint_spacing = 9
            self.distance_required = 9
			self.max_steps = 128
			self.from = blank_vector
			self.to = blank_vector
			self.node_query = {}
			self.node_recursion = {}
			self.raycast_parameter = RaycastParams.new()
			self.raycast_offset = Vector3.new()
		end
	
		function meta:Calculate()
			local raycast_parameter = self.raycast_parameter
			local raycast_callback = self.raycast_callback
			local node_recursion = self.node_recursion
			local node_query = self.node_query
			local directions = self.directions
			local waypoint_spacing = self.waypoint_spacing
            local distance_required = self.distance_required
			local to = self.to
	
            -- This is known as a best-first search (i think at least)
            -- https://en.wikipedia.org/wiki/Best-first_search
			node_query = {
				{ pos = self.from, visited = false, local_goal = 0, global_goal = pathing.distance(self.from, to), parent = nil }
			}
			node_recursion = {}
	
			self.node_query = node_query
			self.node_recursion = node_recursion
			self.success = false
	
			local path = {}
			for steps = 1, self.max_steps do
				if #node_query == 0 then
					break
				end
				table.sort(node_query, pathing.sortbygoal)
	
				local node = table.remove(node_query, 1)
                -- yeah.. i didnt put this in before for whatever reason
                while node.visited and #node_query > 0 do
                    node = table.remove(node_query, 1)
                end
				node.visited = true
	
				if pathing.distance(node.pos, to) <= distance_required then
					while node.parent do
						table.insert(path, 1, node.pos)
						node = node.parent
					end
					table.insert(path, 1, node.pos)
					self.success = true
					break
				end
	
				local node_pos = node.pos
				for i = 1, #directions do
					local dir = directions[i]
					local result = pathing.raycast(node_pos + self.raycast_offset, dir * waypoint_spacing, raycast_parameter, raycast_callback)
					if not result then
						local neighbor_pos = node_pos + waypoint_spacing * dir
						local floored = vector.floor(neighbor_pos, waypoint_spacing)
						local node_neighbor = node_recursion[floored]
						if not node_neighbor then
							local global = pathing.distance(neighbor_pos, to)
							-- This was not being used, and I have already
							-- fiddled with this before and it doesn't seem
							-- to change the contour of paths at all (at least,
							-- not in this implementation.)

							-- I'll leave it commented out for now, but
							-- generally the algorithm I implemented for
							-- pathfinding here is behaving as it should,
							-- so I don't think we'll need the local goal
							
							--local localg = pathing.distance(node_pos, to)
							node_neighbor = { pos = neighbor_pos, visited = false, --[[local_goal = localg,]] global_goal = global, parent = node }
							node_recursion[floored] = node_neighbor
						end
						if not node_neighbor.visited then
							table.insert(node_query, node_neighbor)
						end
					end
				end
			end

			self.path = path
			return path, self.success
		end
	
		-- acessors
		function meta:GetPath()
			return self.path, self.success
		end
	
		-- mutators
		function meta:SetWaypointSpacing(spacing)
			self.waypoint_spacing = spacing
		end

        -- Distance to target required for the pather
        -- to assume a valid path was found
        function meta:SetDistanceRequired(dist)
            self.distance_required = dist
        end
	
		function meta:SetFrom(from)
			self.from = from
		end
	
		function meta:SetTo(to)
			self.to = to
		end

        -- Max steps before the pather gives up
		function meta:SetMaxSteps(steps)
			self.max_steps = steps
		end
	
		function meta:SetRaycastParameter(param)
			self.raycast_parameter = param
		end
	
		function meta:SetRaycastCallback(func)
			self.raycast_callback = func
		end

		function meta:SetRaycastOffset(offset)
			self.raycast_offset = offset
		end
	end

	function pathing.new(from, to)
		local pather = setmetatable({}, pathing.meta)
		pather:Init()
		if from then pather:SetFrom(from) end
		if to then pather:SetTo(to) end
		return pather
	end

	function pathing.instant(from, to, waypoint_spacing, parameter, parameter_callback)
		local pather = pathing.new(from, to)
		pather:SetWaypointSpacing(waypoint_spacing)
		pather:SetRaycastParameter(parameter)
		pather:SetRaycastCallback(parameter_callback)
		return pather:Calculate()
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
	BBOT.account = localplayer.Name
	BBOT.accountId = tostring(localplayer.UserId)
	service:AddToServices("LocalPlayer", localplayer)
	service:AddToServices("CurrentCamera", service:GetService("Workspace").CurrentCamera)
	service:AddToServices("PlayerGui", localplayer:FindFirstChild("PlayerGui") or localplayer:WaitForChild("PlayerGui"))
	service:AddToServices("Mouse", localplayer:GetMouse())

	--rconsolename("Bitch Bot - Instance: " .. BBOT.account)
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
		if self.killed then return end
		if not self.registry[name] then return end
		local tbl, tbln = self._registry_qa[name], self.registry[name]
	
		if tbln[name] then
			local func = tbln[name]
			local ret = {func(...)}
			if ret[1] ~= nil then
				return unpack(ret)
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
						local ret = {func(...)}
						if ret[1] then
							return unpack(ret)
						end
					end
				end
			end
		end
	end

	function hook.ProcessHook(hookdata, ...)
		local name = hookdata.name
		local registry = hookdata.registry
		local name_registry = hookdata.name_registry
		local len = #registry

		if hookdata.index+1 < len then
			local _c = 0
			for l=hookdata.index+1, len do
				local k = l-_c
				hookdata.index = k
				local v = registry[k]
				if v[1] ~= name then
					local id, func = v[1], v[2]
					if not func then 
						table.remove(registry, k)
						_c = _c + 1
						name_registry[id] = nil
					else
						if not id then 
							table.remove(registry, k)
							_c = _c + 1
							name_registry[id] = nil
						else
							hookdata.id = id
							local ret = {func(...)}
							if ret[1] then
								hookdata.returns = ret
								break
							end
						end
					end
				end
			end
		end

		hookdata.finished = true
	end

	function hook.CatchHook(err)
		local hookdata = hook.Processing
		if not hookdata then return end
		log(LOG_ERROR, "Hook Error - " .. hookdata.name .. " - " .. hookdata.id .. " ->\n" .. err)
		log(LOG_ERROR, debug.traceback())
		log(LOG_WARN, "Removing to prevent cascade!")
		table.remove(hookdata.registry, hookdata.index)
		hookdata.name_registry[hookdata.id] = nil
		if (BBOT.notification) then
			BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in hook library.\nPlease check Synapse console!", 30):SetType("error")
		end
	end

	function hook:CallP(name, ...) -- Same as @hook:Call, put with error isolation
		if self.killed then return end
		if not self.registry[name] then return end
		local tbl, tbln = self._registry_qa[name], self.registry[name]

		if tbln[name] then
			local func = tbln[name]
			local ret = {xpcall(func, debug.traceback, ...)}
			if not ret[1] then
				log(LOG_ERROR, "Hook Error - ", name, " - ", name)
				log(LOG_ERROR, ret[2])
				log(LOG_WARN, "Removing to prevent cascade!")
				for l=1, #tbl do
					local v = tbl[l]
					if v[1] == name then
						table.remove(tbl, l); tbln[name] = nil
						break
					end
				end
				if (BBOT.notification) then
					BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in hook library.\nPlease check Synapse console!", 30):SetType("error")
				end
			elseif ret[2] then
				table.remove(ret, 1)
				return unpack(ret)
			end
		end

		local hookdata = {
			registry = tbl,
			name_registry = tbln,
			varargs = {...},
			index = 0,
			name = name,
			id = "",
		}
		local already_processing = self.Processing
		self.Processing = hookdata

		local count, max = 0, #tbl
		while true then
			count = count + 1
			xpcall(self.ProcessHook, self.CatchHook, hookdata, ...) -- instead of calling xpcall in a for loop, we invoke it only once
			if count >= max or hookdata.finished == true then break end
		end

		local returns = self.Processing.returns
		self.Processing = already_processing
		hookdata = nil
		if returns then
			return unpack(returns)
		end
	end

	function hook:GetTable() -- Need the table of hooks or no?
		return self.registry
	end
	local connections = {}
	hook.connections = connections
	function hook:bindEvent(event, name) -- Creates a hook instance for a roblox signal, only use this for permanent binds NOT temporary!
		local con = event:Connect(function(...)
			self:CallP(name, ...)
		end)
		table.insert(connections, con)
		return con
	end
	--[[
	function original_func = hook:BindFunction(function func, string name, any extra [vararg])
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

	local syn_error_bind = syn.on_error_report:Connect(function(thread, error_str, call_stack, options)
		if hook.binding_trace > 0 then
			hook.binding_trace = hook.binding_trace - 1
		end
	end)

	hook.bindings = {}
	hook.binding_trace = 0
	function hook:BindFunction(func, name, metafunction, ...)
		local t = {self, func, name, metafunction, {...}}
		t[2] = hookfunction(func, function(...)
			local hook = t[1]
			if hook.killed then return t[2](...) end
			local extra_add = {}
			local extra_len = #t[5]
			for i=1, extra_len do
				extra_add[i] = t[5][i]
			end
			local vararg = {...}
			for i=1, #vararg do
				extra_add[#extra_add+1] = vararg[i]
			end
			if t[4] then
				table.remove(extra_add, 1)
			end
			hook:CallP("Pre" .. t[3], unpack(extra_add))
			hook.binding_trace = hook.binding_trace + 1
			local args = {t[2](...)}
			hook.binding_trace = hook.binding_trace - 1
			if t[5] ~= nil then
				table.insert(args, 1, t[5])
			end
			for i=1, extra_len do
				table.insert(args, 1, t[5][extra_len-i+1])
			end
			for i=1, #vararg do
				args[#args+1] = vararg[i]
			end
			if t[4] then
				table.remove(args, 1)
			end
			hook:CallP("Post" .. t[3], unpack(args))
			return unpack(args)
		end)
		self.bindings[#self.bindings+1] = {name, func}
		return t[2]
	end

	function hook:BindFunctionOverride(func, name, metafunction, ...)
		local t = {self, func, name, metafunction, false, {...}}
		t[2] = hookfunction(func, function(...)
			local hook = t[1]
			if hook.killed then return t[2](...) end
			local extra_add = {}
			local extra_len = #t[6]
			for i=1, extra_len do
				extra_add[i] = t[6][i]
			end
			local vararg = {...}
			for i=1, #vararg do
				extra_add[#extra_add+1] = vararg[i]
			end
			local self_meta
			if t[4] then
				self_meta = vararg[1]
				table.remove(extra_add, 1)
			end
			if not t[5] then
				t[5] = true
				local s = hook:CallP("Suppress" .. t[3], unpack(extra_add))
				t[5] = false
				if s then return end
			end
			local override = {hook:CallP("Pre" .. t[3], unpack(extra_add))}
			local overwrite = override[1] == nil
			if overwrite then
				override = vararg
			elseif self_meta ~= nil then
				table.insert(override, 1, self_meta)
			end
			if overwrite then
				hook.binding_trace = hook.binding_trace + 1
			end
			local args = {t[2](unpack(override))}
			if overwrite then
				hook.binding_trace = hook.binding_trace - 1
			end
			local len = #override
			for i=1, len do
				table.insert(args, 1, override[len-i+1])
			end
			if self_meta ~= nil then
				table.remove(args, 1)
			end
			for i=1, extra_len do
				table.insert(args, 1, t[6][extra_len-i+1])
			end
			hook:CallP("Post" .. t[3], unpack(args))
			return unpack(args)
		end)
		self.bindings[#self.bindings+1] = {name, func}
		return t[2]
	end

	function hook:UnBindFunction(name)
		local bindings = self.bindings
		local c = 0
		for i=1, #bindings do
			local data = bindings[i-c]
			if data[1] == name then
				restorefunction(data[2])
				table.remove(bindings, i-c)
				c=c+1
			end
		end
	end
end

-- Hook additions
do
	-- From wholecream
	-- If you find that you need to make another connection, do add it here with a hook
	-- You never know if your gonna need to reuse it either way...
	local hook = BBOT.hook
	local localplayer = BBOT.service:GetService("LocalPlayer")
	local runservice = BBOT.service:GetService("RunService")
	local userinputservice = BBOT.service:GetService("UserInputService")
	local mouse = BBOT.service:GetService("Mouse")
	hook:Add("Unload", "Unload", function() -- Reloading the cheat? no problem.
		-- disconnect all rbx based connections
		local connections = hook.connections
		for i=1, #connections do
			connections[i]:Disconnect()
		end
		hook.connections = {}
		
		-- restore all hookfunction connections
		local bindings = hook.bindings
		for i=1, #bindings do
			restorefunction(bindings[i][2])
		end
		hook.bindings = {}

		-- assign a killed action to coroutine wrappers
		hook.killed = true

		-- wait and kill entire hook library
		coroutine.wrap(function()
			task.wait(1)
			hook.registry = {}
			hook._registry_qa = {}
		end)()
	end)


	hook:bindEvent(userinputservice.InputBegan, "InputBegan")
	hook:bindEvent(userinputservice.InputEnded, "InputEnded")

	local isholdingmouse1, isholdingmouse2 = false, false
	hook:Add("InputBegan", "InputBegan", function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isholdingmouse1 = true
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			isholdingmouse2 = true
		end
	end)

	hook:Add("InputEnded", "InputEnded", function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isholdingmouse1 = false
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			isholdingmouse2 = false
		end
	end)

	function hook:IsMouse1Down()
		return isholdingmouse1
	end

	function hook:IsMouse2Down()
		return isholdingmouse2
	end

	local lastMousePos = Vector2.new()
	hook:Add("RenderStepped", "Mouse.Move", function()
		local x, y = mouse.X, mouse.Y
		hook:Call("Mouse.Move", lastMousePos ~= Vector2.new(x, y), x, y)
		lastMousePos = Vector2.new(x, y)
	end)

	hook:bindEvent(userinputservice.InputChanged, "InputChanged")

	hook:Add("InputChanged", "InputChanged", function(userinput)
		if userinput.UserInputType.Name == "MouseMovement" then
			hook:Call("Mouse.OnMove", userinput.Delta)
		end
	end)

	local camera = BBOT.service:GetService("CurrentCamera")
	local vport = camera.ViewportSize
	hook:Add("RenderStepped", "ViewportSize.Changed", function()
		if camera.ViewportSize ~= vport then
			vport = camera.ViewportSize
			hook:Call("Camera.ViewportChanged", vport)
		end
	end)

	hook:bindEvent(mouse.WheelForward, "WheelForward")
	hook:bindEvent(mouse.WheelBackward, "WheelBackward")

	hook:bindEvent(runservice.Stepped, "Stepped")
	hook:bindEvent(runservice.Heartbeat, "Heartbeat")
	hook:bindEvent(runservice.RenderStepped, "RenderStepped")

	local players = BBOT.service:GetService("Players")
	hook:bindEvent(players.PlayerAdded, "PlayerAdded")
	hook:bindEvent(players.PlayerRemoving, "PlayerRemoving")
	hook:bindEvent(localplayer.Idled, "LocalPlayer.Idled")

	BBOT.renderstepped_rate = 0
	hook:Add("RenderStepped", "BBOT:Internal.Framerate", function(rate)
		BBOT.renderstepped_rate = rate
	end)
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
		if not waitt then waitt = 1 end
		local isuserdata = (type(waitt) == "userdata")

		loops[name] = {
			running = false,
			destroy = false,
			varargs = {...},
			Loop = coroutine.create(function(...)
				local loop_data = loops[name]
				while true do
					if loop_data.running then
						local ran, err = xpcall(func, debug.traceback, ...)
						if not ran then
							loops[name].destroy = true
							log(LOG_ERROR, "Error in loop library - " .. tostring(name), err)
							if (BBOT.notification) then
								BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in loop library.\nPlease check Synapse console!", 30):SetType("error")
							end
							break
						end
					end
					if loop_data.destroy then break end
					if isuserdata then
						waitt:wait()
					else
						task.wait(waitt)
					end
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
		local succ, out = coroutine.resume(loops[name].Loop, unpack(loops[name].varargs))
		if not succ then
			log(LOG_ERROR, "Error in loop library - " .. tostring(name) .. "\n" .. tostring(out))
			if (BBOT.notification) then
				BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in timer library.\nPlease check Synapse console!", 30):SetType("error")
			end
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

-- Iterators
do
	local iterators = {}
	BBOT.iterators = iterators

	function iterators.Wrapback(a, i, amt)
	    -- a = the array being passed into the iterator
	    -- i = current index to start at
	    -- amt = the amount of times to return shit
	    i -= 1
	    local j = 0
	    local s = #a
	    return function()
	    	-- TODO: optimize this into a for loop instead
	    	-- idk why its a while loop rn lol
	        while j < amt do
	            i = i % s + 1
	            j = j + 1
	            return i, a[i]
	        end
	        return nil
	    end
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
						if (BBOT.notification) then
							BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in timer library.\nPlease check Synapse console!", 30):SetType("error")
						end
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

-- Asset
do
	local hook = BBOT.hook
	local string = BBOT.string
	local httpservice = BBOT.service:GetService("HttpService")
	local asset = {
		registry = {}
	}
	BBOT.asset = asset

	-- THIS IS INTERNAL, DO NOT CALL THIS!
	function asset:Initialize()
		self.game = BBOT.game
		self.path = "bitchbot/"..self.game
	end

	-- registers a folder with an extensions whitelist
	function asset:Register(class, extensions)
		if not self.registry[class] then
			if not extensions then
				self.registry[class] = {
					__extensions = true
				}
			else
				local invert = {}
				for i=1, #extensions do
					invert[extensions[i]] = true
				end
				self.registry[class] = {
					__extensions = invert
				}
			end
		end
		local path = self.path .. "/" .. class
		if not isfolder(path) then
			makefolder(path)
		end
	end

	-- get's the file in the form of a synapse asset Id
	function asset:GetAsset(class, path)
		if not self.registry[class] then return end
		local reg = self.registry[class]
		local extension = string.match(path, "^.+(%..+)$")
		if reg.__extensions ~= true and not reg.__extensions[extension] then return false end
		if not reg[path] then
			if isfile(self.path .. "/" .. class .. "/" .. path) then
				reg[path] = getsynasset(self.path .. "/" .. class .. "/" .. path)
			else
				return false
			end
		end
		return reg[path]
	end

	-- get's the file name from a direct path
	function asset:GetFileName(path)
		path = string.match(path, "([^/]+)$")
		if path then
			return string.match(path, "(.+)%..+")
		end
	end

	-- get's the extension of a file path
	function asset:GetExtension(path)
		return string.match(path, "^.+(%..+)$")
	end

	-- is this a folder?
	function asset:IsFolder(class, path)
		return isfolder(self.path .. "/" .. class .. "/" .. path)
	end

	-- is this a file?
	function asset:IsFile(class, path)
		return isfile(self.path .. "/" .. class .. "/" .. path)
	end

	-- makes a god damn folder
	function asset:MakeFolder(class, path)
		if not isfolder(self.path .. "/" .. class .. "/" .. path) then
			makefolder(self.path .. "/" .. class .. "/" .. path)
			return true
		end
		return false
	end

	-- get's the raw data of a file
	function asset:Read(class, path)
		if not self.registry[class] then return end
		local reg = self.registry[class]
		local extension = string.match(path, "^.+(%..+)$")
		if reg.__extensions ~= true and not reg.__extensions[extension] then return false end
		if isfile(self.path .. "/" .. class .. "/" .. path) then
			return readfile(self.path .. "/" .. class .. "/" .. path)
		end
	end

	-- get's and converts a file to a table from j son format
	function asset:ReadJSON(class, path)
		local data = asset:Read(class, path)
		if not data then return end
		return httpservice:JSONDecode(data)
	end

	-- writes a data to a file
	function asset:Write(class, path, data)
		if not self.registry[class] then return end
		local reg = self.registry[class]
		local extension = string.match(path, "^.+(%..+)$")
		if not extension or (reg.__extensions ~= true and not reg.__extensions[extension]) then
			BBOT.log(LOG_ERROR, "Asset - Invalid extensions '" .. (extension or "UNK") .. "'\n" .. debug.traceback())
			return
		end
		writefile(self.path .. "/" .. class .. "/" .. path, data)
	end

	-- writes a table as a j son to a file
	function asset:WriteJSON(class, path, data)
		data = httpservice:JSONEncode(data)
		return asset:Write(class, path, data)
	end

	-- lists all files in an asset's folder/sub-folder
	function asset:ListFiles(class, path)
		if not self.registry[class] then return end
		local reg = self.registry[class]
		local extensions = reg.__extensions
		local ispath = (path ~= "" and path ~= nil)

		local files = {}
		local list = listfiles(self.path .. "/" .. class .. (ispath and "/" .. path or ""))
		for i=1, #list do
			local file = list[i]
			local filename = string.Explode("\\", file)
			filename = filename[#filename]
			local extension = string.match(filename, "^.+(%..+)$")
			if extensions == true or extensions[extension] then
				files[#files+1] = (ispath and path .. "/" or "") .. filename
			end
		end
		return files
	end

	hook:Add("PreStartup", "BBOT:Asset.Initialize", function()
		asset:Initialize()
		asset:Register("textures", {".png", ".jpg"})
		asset:Register("images", {".png", ".jpg"})
		asset:Register("sounds", {".ogg", ".mp3"})
		asset:Register("configs", {".json"})
		asset:Register("data")
	end)
end

-- Scripts
do
	local asset = BBOT.asset
	local log = BBOT.log
	local hook = BBOT.hook
	local scripts = {
		registry = {},
	}
	BBOT.scripts = scripts

	hook:Add("PreInitialize", "BBOT:Scripts.Initialize", function()
		asset:Register("scripts", {".json", ".lua"}) -- creates scripts folder and wl files
	end)

	hook:Add("PostInitialize", "BBOT:Scripts.Initialize", function()

		scripts.pre_run = [[local _={...};local BBOT=_[1];local script_name=_[2];]]

		local libraries = {}
		for k, v in pairs(BBOT) do
			if typeof(v) == "table" and not string.match(k, "%s") then
				scripts.pre_run = scripts.pre_run .. "local " .. k .. "=BBOT." .. k .. ";"
			end
		end

		if asset:IsFile("scripts", "autoexec.json") then
			local autoexec = asset:ReadJSON("scripts", "autoexec.json")

			local c = 0
			for i=1, #autoexec do
				local k = i-c
				local name = autoexec[k]
				if not asset:IsFile("scripts", name) then
					table.remove(autoexec, k)
					c = c + 1
					continue
				end
				scripts:Run(name)
			end
	
			asset:WriteJSON("scripts", "autoexec.json", autoexec)
	
			scripts.autoexec = autoexec
		else
			asset:Write("scripts", "autoexec.json", "[]")
			scripts.autoexec = {}
		end
	end)

	function scripts:AddToAutoExec(name, index)
		local autoexec = self.autoexec
		if not asset:IsFile("scripts", name) then return end
		if index > #autoexec then
			index = #autoexec+1
		end
		table.insert(autoexec, index, name)
		asset:WriteJSON("scripts", "autoexec.json", autoexec)
	end

	function scripts:RemoveFromAutoExec(name)
		local autoexec = self.autoexec
		for i=1, #autoexec do
			local v = autoexec[i]
			if v == name then
				table.remove(autoexec, i)
				break
			end
		end
		asset:WriteJSON("scripts", "autoexec.json", autoexec)
	end

	-- get's a script from with-in bitchbot/[gamehere]/scripts/*
	function scripts:Get(name)
		if asset:IsFile("scripts", name) then
			return asset:Read("scripts", name)
		end
	end

	function scripts:GetAll(path)
		local files = asset:ListFiles("scripts", path)
		local c = 0
		for i=1, #files do
			local v = files[i-c]
			if asset:GetExtension(v) ~= ".lua" then
				table.remove(files, i-c)
				c=c+1
			end
		end
		return files
	end

	-- runs it? duh?
	function scripts:Run(name)
		if asset:IsFile("scripts", name) then
			if self.registry[name] then
				log(LOG_WARN, "Script \"" .. name .. "\" is already running! Attempting unload...")
				hook:CallP(name .. ".Unload")
				log(LOG_NORMAL, "Re-running script -> " .. name)
			else
				log(LOG_NORMAL, "Running script -> " .. name)
			end
			local script = asset:Read("scripts", name)
			local func, err = loadstring(self.pre_run .. script)
			if not func then
				local msg = "An error occured executing script \"" .. name .. "\",\n" .. (err or "Unknown Error!")
				log(LOG_ERROR, msg)
				BBOT.notification:Create(msg, 20):SetType("error")
				self.registry[name] = {callback = func, state = "Compile Error"}
				hook:CallP("Scripts.Run", name, func, "Compile Error")
				return
			end
			setfenv(func, getfenv())
			local ran, err = xpcall(func, debug.traceback, BBOT, name) -- i forgot what to do here
			if not ran then
				hook:CallP(name .. ".Unload")
				local msg = "An error occured running script \"" .. name .. "\",\n" .. (err or "Unknown Error!")
				log(LOG_ERROR, msg)
				BBOT.notification:Create(msg, 20):SetType("error")
				self.registry[name] = {callback = func, state = "Execution Error"}
				hook:CallP("Scripts.Run", name, func, "Execution Error")
				return
			end
			BBOT.notification:Create("Executed script " .. name)
			self.registry[name] = {callback = func, state = "Running"}
			hook:CallP("Scripts.Run", name, func, "Running")
		end
	end

	function scripts:GetState(name)
		return (self.registry[name] ~= nil and self.registry[name].state or "Idle")
	end

	function scripts:IsAutoExec(name)
		local autoexec = self.autoexec
		for i=1, #autoexec do
			local v = autoexec[i]
			if v == name then
				return i
			end
		end
	end

	function scripts:Unload(name)
		if self.registry[name] then
			hook:CallP(name .. ".Unload")
			BBOT.notification:Create("Unloaded script " .. name)
			hook:CallP("Scripts.Unload", name)
			self.registry[name] = nil
		end
	end

	hook:Add("Unload", "BBOT:Scripts.Unload", function()
		for name, data in next, scripts.registry do
			hook:CallP(name .. ".Unload")
		end
	end)
end

-- Statistics
-- A system for recording informations about whatever the fuck we want
-- WARNING: This is a file system based approach, this is slower than MySQL!
-- Requirements to add MySQL compat is in the works
do
	local hook = BBOT.hook
	local service = BBOT.service
	local asset = BBOT.asset
	local loop = BBOT.loop
	local log = BBOT.log
	local statistics = {
		registry = {}
	}
	BBOT.statistics = statistics

	function statistics:Read()
		if asset:IsFile("data", self.path) then
			self.registry = asset:ReadJSON("data", self.path)
		end
	end

	function statistics:Write()
		asset:WriteJSON("data", self.path, self.registry)
	end

	function statistics:Initialize()
		self.game = BBOT.game
		self.session = BBOT.account

		self.path = self.session.."/statistics.json"
		asset:MakeFolder("data", self.session)

		self:Read()
	end

	function statistics:Create(Id, default)
		if self.registry[Id] then
			local data = self.registry[Id]
			if typeof(data) ~= typeof(default) then
				self.registry[Id] = default
			elseif typeof(default) == "table" then
				for k, v in pairs(default) do
					if data[k] == nil then
						data[k] = v
					end
				end
				for k, v in pairs(data) do
					if default[k] == nil then
						data[k] = nil
					end
				end
			end
		else
			self.registry[Id] = (default ~= nil and default or {})
		end
		self.modified = true
	end

	function statistics:Get(Id)
		return self.registry[Id] or {}
	end

	function statistics:Set(Id, new)
		self.modified = true
		if new == nil then return end
		self.registry[Id] = new
	end

	function statistics:Save()
		self.modified = false
		asset:WriteJSON("data", self.path, self.registry)
	end

	loop:Run("Statistics.Save", function(statistics)
		if not statistics.modified then return end
		statistics:Save()
	end, 0.1, statistics)

	hook:Add("PostStartup", "BBOT:Statistics.Initialize", function()
		statistics:Initialize()
	end)
end

-- Extras
do
	local hook = BBOT.hook
	local extras = {}
	BBOT.extras = extras

	local PingStat = BBOT.service:GetService("Stats").PerformanceStats.Ping
	local current_latency = 0
	hook:Add("RenderStepped", "BBOT:extras.getlatency", function()
		current_latency = PingStat:GetValue() / 1000
	end)

	function extras:getLatency()
		return current_latency
	end
end

-- Draw-Dyn - A sub-library to the drawing dynamic library with it's own referencing system
-- Similar to drawing depreciated for them OG people.
-- Note: this uses some of Bitch Bot's libraries, try to compensate by making your own!
-- WholeCream
do
	local hook = BBOT.hook
	local timer = BBOT.timer
	local log = BBOT.log
    local draw = {}
    BBOT.draw = draw
    draw.registry = {}
	draw.classes = {}
    draw.point_registry = {}
	draw.point_classes = {}
	
	--[[
		Property Identities
		0 - get
		1 - set
		2 - get, set
	]]
	draw.base_properties = {
		["Visible"] = 2,
		["ZIndex"] = 2,
		["Opacity"] = 2,
		["Color"] = 2,
		["Outlined"] = 2,
		["OutlineColor"] = 2,
		["OutlineOpacity"] = 2,
		["OutlineThickness"] = 2,
	}

	draw.base_pointproperties = {
		["ScreenPos"] = 0,
		["Visible"] = 0,
	}

	-- Metamethods are fun
	-- Use this to add some fancy stuff to all your drawing objects
	do
		local base_metamethods = {}
		draw.base_metamethods = base_metamethods

		function base_metamethods:Init() end

		function base_metamethods:IsPoint()
			return false
		end

		-- Since it is reference based :)
		local registry = draw.registry
		function base_metamethods:Remove()
			self.__INVALID = true
			-- 10/10 garbage collection ez
			if self.dynamic then
				self.dynamic.Visible = false
			end
			self.dynamic = nil
            self.point = nil
            self.points = nil
			for i=1, #registry do
				local v = registry[i]
				if v == self then
					table.remove(registry, i)
					break
				end
			end
		end

		-- Completely desintegrates everything
		function base_metamethods:Destroy()
			self.__INVALID = true
			if self.dynamic then
				self.dynamic.Visible = false
			end
			self.dynamic = nil
            self.point = nil
			local points = self.points
			for i=1, #points do
				local v = points[i]
				v:Remove()
			end
            self.points = nil
			for i=1, #registry do
				local v = registry[i]
				if v == self then
					table.remove(registry, i)
					break
				end
			end
		end
	end

	-- Metamethods are fun
	-- Use this to add some fancy stuff to all your point objects
	do
		local base_pointmetamethods = {}
		draw.base_pointmetamethods = base_pointmetamethods

		function base_pointmetamethods:Init() end

        function base_pointmetamethods:IsPoint()
            return true
        end

        -- Since it is reference based :)
        local registry = draw.point_registry
        function base_pointmetamethods:Remove()
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

	-- Registers a drawing dynamic system to this sub-system
	-- See examples bellow
	function draw:Register(generator, class, properties, metamethods, pointers)
		pointers = pointers or 1
		if properties then
			for k, v in pairs(self.base_properties) do
				if not properties[k] then
					properties[k] = v
				end
			end
		else
			properties = self.base_properties
		end
		if metamethods then
			metamethods = setmetatable(metamethods, {__index = self.base_metamethods})
		else
			metamethods = self.base_metamethods
		end
		self.classes[class] = {
			generator = generator,
			metamethods = metamethods,
			properties = properties,
			pointers = pointers
		}
	end

	-- Registers a point system to this sub-system
	-- See examples bellow
	function draw:RegisterPoint(generator, class, properties, metamethods)
		if properties then
			for k, v in pairs(self.base_pointproperties) do
				if not properties[k] then
					properties[k] = v
				end
			end
		else
			properties = self.base_pointproperties
		end
		if metamethods then
			metamethods = setmetatable(metamethods, {__index = self.base_metamethods})
		else
			metamethods = self.base_metamethods
		end
		local class_information = {
			generator = generator,
			metamethods = metamethods,
			properties = properties
		}
		self.point_classes[class] = class_information
		return class_information
	end

	-- If you want a class to have specific metamethods:
	--[[
		local extramethods = {}

		function extramethods:Init()
			print("the line is created!")
		end

		draw:Register(LineDynamic.new, "Line", {
			["Thickness"] = 2,
		}, extramethods, 2)
	]]
	draw:RegisterPoint(function(...)
		return PointOffset.new(Point2D.new(...))
	end, "2V", {
		["Offset"] = 2,
	})
	draw:RegisterPoint(Point2D.new, "2D", {
		["PointVec2"] = 1,
		["Point"] = 2,
	})
	draw:RegisterPoint(Point3D.new, "3D", {
		["Point"] = 2,
	})
	draw:RegisterPoint(PointInstance.new, "Instance", {
		["Instance"] = 2,
		["Offset"] = 2,
		["IgnoreRotation"] = 2,
		["WorldPos"] = 2,
	})
	draw:RegisterPoint(PointMouse.new, "Mouse")
	draw:RegisterPoint(PointOffset.new, "Offset", {
		["Point"] = 2,
		["Offset"] = 2,
	})

	draw:Register(LineDynamic.new, "Line", {
		["Thickness"] = 2,
	}, nil, 2)
	draw:Register(PolyLineDynamic.new, "PolyLine", {
		["Points"] = 2,
		["FillType"] = 2,
		["ReTriangulate"] = 0,
	}, nil, math.huge)
	draw:Register(TextDynamic.new, "Text", {
		["Text"] = 2,
		["TextBounds"] = 0,
		["Size"] = 2,
		["Position"] = 2,
		["Font"] = 2,
		["XAlignment"] = 2,
		["YAlignment"] = 2,
		["TextXAlignment"] = 2,
	})
	draw:Register(CircleDynamic.new, "Circle", {
		["Thickness"] = 2,
		["Radius"] = 2,
		["NumSides"] = 2,
		["Edge"] = 2,
		["Filled"] = 2,
		["Position"] = 2,
		["XAlignment"] = 2,
		["YAlignment"] = 2,
	})
	draw:Register(RectDynamic.new, "Rect", {
		["Thickness"] = 2,
		["Size"] = 2,
		["Filled"] = 2,
		["Rounding"] = 2,
		["XAlignment"] = 2,
		["YAlignment"] = 2,
	})
	draw:Register(GradientRectDynamic.new, "Gradient", {
		["Thickness"] = 2,
		["Size"] = 2,
		["XAlignment"] = 2,
		["YAlignment"] = 2,
		["ColorUpperLeft"] = 2,
		["ColorUpperRight"] = 2,
		["ColorBottomLeft"] = 2,
		["ColorBottomRight"] = 2,
	})
	draw:Register(ImageDynamic.new, "Image", {
		["Image"] = 2,
		["ImageSize"] = 0,
		["Size"] = 2,
		["Position"] = 2,
		["Rounding"] = 2,
		["XAlignment"] = 2,
		["YAlignment"] = 2,
	})

    -- Hello are you around?
    function draw:IsValid(object)
        return object and not object.__INVALID
    end

    local point_uniqueid = -1
	-- Creates a point
    function draw:CreatePoint(class, ...)
        local class_object = self.point_classes[class]
        if not class_object then
			error("draw:CreatePoint - No Such Class: " .. class)
			return
		end
        point_uniqueid = point_uniqueid + 1
        local meta = class_object.metamethods
		local properties = class_object.properties
        local object = setmetatable({
            point = class_object.generator(...),
			properties = properties,
            uniqueid = point_uniqueid,
            class = class,
			ispoint = true,
			traceback = debug.traceback()
        }, {
            __index = function(self, key)
				if in_index or rawget(self, "__INVALID") then return end

				local accessor = "get" .. key
				if meta[accessor] then
					if (properties[key] == 0 or properties[key] == 2) then
						local ret = {meta[accessor](self, 0)}
						return meta[accessor](self, 0)
					end
				elseif meta[key] then
					return meta[key]
				end

				local point = rawget(self, "point")
				if point and (properties[key] == 0 or properties[key] == 2) then return point[key] end
            end,
			__newindex = function(self, key, value)
				if rawget(self, "__INVALID") then return end
				local point = rawget(self, "point")
				if point and (properties[key] == 1 or properties[key] == 2) then
					if typeof(value) == 'Vector2' then
						if value.Magnitude ~= value.Magnitude then
							log(LOG_WARN, "WARNING - " .. tostring(self) .. " setting an invalid Vector2! (NAN)\nCREATE TR - " .. rawget(self, "traceback") .. "\nDIRECT TR - " .. debug.traceback())
							return
						end
						if value.Magnitude >= math.huge then
							log(LOG_WARN, "WARNING - " .. tostring(self) .. " setting an invalid Vector2! (INF)\nCREATE TR - " .. rawget(self, "traceback") .. "\nDIRECT TR - " .. debug.traceback())
							return
						end
						if value.Magnitude <= -math.huge then
							log(LOG_WARN, "WARNING - " .. tostring(self) .. " setting an invalid Vector2! (-INF)\nCREATE TR - " .. rawget(self, "traceback") .. "\nDIRECT TR - " .. debug.traceback())
							return
						end
					end
					local mutator = "set".. key
					if meta[mutator] then
						meta[mutator](self, value)
					else
						point[key] = value
					end
				end
				if not properties[key] then
					rawset(self, key, value)
				end
			end,
            __tostring = function(self)
                return "Point: " .. self.class .. "#" .. self.uniqueid
            end
        })
        local registry = draw.point_registry
        registry[#registry+1] = object
		object:Init()
        return object
    end

	-- Creates a drawing dynamic object
	-- Example,
	--[[
		local line = draw:Create("Line", "2V", "2V")
		line.Color = Color3.new(1,1,1)
		-- note how Point is renamed to Point1 and Point2
		-- if there is more than one point in the dynamic, it will do this
		line.Point1 = UDim2.new(0,0,.5,0)
		line.Point2 = UDim2.new(.5,0,.5,0)

		-- PolyLine can have as many points, so this goes on... and on...
		local poly = draw:Create("PolyLine", "2V", "2V", "2V")
		poly.Point1 = UDim2.new(0,0,.5,0)
		poly.Point2 = UDim2.new(.5,0,.5,0)
		poly.Point3 = UDim2.new(.5,0,0,0)

		-- if you need to iterate through points,
		for i=1, #poly.points do
			local point = poly.points[i]
			-- this is now the point objects
			-- so you can access with the numbers at the end like so
			-- point.Point = whatever the fuck
		end

		-- want to remove?
		wait(5)
		poly:Remove()
		line:Remove()
	]]

    local uniqueid = -1
    function draw:Create(class, ...)
        local class_object = self.classes[class]
        if not class_object then
			error("draw:Create - No Such Class: " .. class)
			return
		end
        uniqueid = uniqueid + 1
        local meta = class_object.metamethods
		local properties = class_object.properties
		local pointers = class_object.pointers

		local object = {
            uniqueid = uniqueid,
            class = class,
			properties = properties,
			pointers = pointers,
			isdraw = true,
			traceback = debug.traceback()
        }

		local args = {...}
		if pointers > 1 then
			local args_sub = {}
			for i=pointers+1, #args do
				args_sub[#args_sub+1] = args[i]
			end
			local points = {}
			local points_ = {}
			for i=1, pointers do
				local pointer_class = args[i]
				if not pointer_class then break end
				local point = self:CreatePoint(pointer_class, unpack(args_sub))
				object["point" .. i] = point
				points_[#points_+1] = point
				points[#points+1] = point.point
			end
			object.points = points_
			if class == "PolyLine" then
				object.dynamic = class_object.generator(points)
			else
            	object.dynamic = class_object.generator(unpack(points))
			end
		else
			local pointer_class = args[1]
			local args_sub = {}
			for i=2, #args do
				args_sub[#args_sub+1] = args[i]
			end
			local point = self:CreatePoint(args[1], unpack(args_sub))
			object.point = point
			object.points = {point}
            object.dynamic = class_object.generator(point.point)
		end

        object = setmetatable(object, {
			__index = function(self, key)
				if rawget(self, "__INVALID") then return end

				local accessor = "get" .. key
				if meta[accessor] then
					if (properties[key] == 0 or properties[key] == 2) then
						local ret = {meta[accessor](self, 0)}
						return meta[accessor](self, 0)
					end
				elseif meta[key] then
					return meta[key]
				end

				local dynamic = rawget(self, "dynamic")
				if dynamic and (properties[key] == 0 or properties[key] == 2) then return dynamic[key] end
				local point
				if pointers > 1 then
					point = rawget(self, "point" .. string.sub(key, #key))
					key = string.sub(key, 1, #key-1)
				else
					point = rawget(self, "point")
				end
				if point and point[key] ~= nil then return point[key] end
            end,
			__newindex = function(self, key, value)
				if rawget(self, "__INVALID") then return end
				local dynamic = rawget(self, "dynamic")
				if dynamic and (properties[key] == 1 or properties[key] == 2) then
					local mutator = "set".. key
					if meta[mutator] then
						meta[mutator](self, value)
					else
						dynamic[key] = value
					end
					return
				end
				local point
				if pointers > 1 then
					point = rawget(self, "point" .. string.sub(key, #key))
					key = string.sub(key, 1, #key-1)
				else
					point = rawget(self, "point")
				end
				if point and point[key] ~= nil then
					point[key] = value
					return
				end
				if not properties[key] then
					rawset(self, key, value)
				end
			end,
			__tostring = function(self)
				return "Draw: " .. self.class .. "#" .. self.uniqueid
			end
		})

        local registry = self.registry
        registry[#registry+1] = object
		object:Init()
        return object
    end

	-- Creates a new object with the same properties with new similar points
	-- DOES NOT COPY POINT PROPERTIES
	function draw:Clone(object)
		local point_classes = {}
		local pointers = object.points
		for i=1, #pointers do
			point_classes[#point_classes+1] = pointers[i].class
		end
		local new_object = self:Create(object.class, unpack(point_classes))
		for k, v in pairs(object.properties) do
			if v ~= 2 then continue end
			if k == "Point" or k == "Points" or k == "Position" then continue end
			new_object.dynamic[k] = object.dynamic[k]
		end
		return new_object
	end

	-- Creates a new object with the same properties and copies properties of points
	-- NOT TESTED DUE TO SYN 2021 BEING DOWN REEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	function draw:DeepClone(object)
		local point_classes = {}
		local point_properties = {}
		local pointers = object.points
		for i=1, #pointers do
			local point = pointers[i]
			point_classes[#point_classes+1] = point.class
			local properties = {}
			for k, v in pairs(point.properties) do
				if v ~= 2 then continue end
				properties[k] = point.point[k]
			end
			point_properties[#point_properties+1] = properties
		end
		local new_object = self:Create(object.class, unpack(point_classes))
		local len = #point_properties
		if len > 1 then
			for i=1, len do
				local properties = point_properties[i]
				local point = new_object["point" .. i]
				for k, v in pairs(properties) do
					point.point[k] = v
				end
			end
		else
			local properties = point_properties[1]
			local point = new_object["point"]
			for k, v in pairs(properties) do
				point.point[k] = v
			end
		end
		for k, v in pairs(object.properties) do
			if v ~= 2 then continue end
			new_object.dynamic[k] = object.dynamic[k]
		end
		return new_object
	end

    -- Allow hot-loading the script over and over...
	-- Replace this with your own way of doing this
    hook:Add("Unload", "BBOT:Draw.Remove", function()
        local registry = draw.registry
		local schedule_remove = {}
        for i=1, #registry do
            local v = registry[i]
            if v.__INVALID then continue end
			schedule_remove[#schedule_remove+1] = v
        end

        registry = draw.point_registry
        for i=1, #registry do
            local v = registry[i]
            if v.__INVALID then continue end
			schedule_remove[#schedule_remove+1] = v
        end

		for i=1, #schedule_remove do
			local v = schedule_remove[i]
			if not v or v.__INVALID then continue end
            v:Remove()
		end
    end)
end

-- Draw Pather
-- Creates lines in 3D space with both un-managed and managed processes
-- Useful for debugging and showing pathways of things like roblox's pathing service
-- Uses Draw-Dyn, so make sure to have that! - WholeCream
do 
	local camera = BBOT.service:GetService("CurrentCamera")
	local math = BBOT.math
	local table = BBOT.table
	local hook = BBOT.hook
	local draw = BBOT.draw
	local color = BBOT.color 
	local drawpather = {
		registry = {},
	}
	BBOT.drawpather = drawpather

	-- metamethods
	do
		local meta = {}
		drawpather.meta = meta

		function meta:Init()
			self.t0 = tick()
			self.outlined = false
			self.size = 2
			self.endsize = 6
		end

		function meta:Remove()
			self.__INVALID = true
			local objects = self.objects
			for k=1, #objects do
				local v = objects[k][1]
				if draw:IsValid(v) then
					v:Destroy()
				end
			end
		end

		function meta:ValidateCache()
			local objects = self.objects
			local c = 0
			for k=1, #objects do
				k = k - c
				local v = objects[k][1]
				if not draw:IsValid(v) then
					table.remove(objects, k)
					c=c+1
				end
			end
		end

		function meta:SetOpacity(opacity)
			self.opacity = opacity
		end

		function meta:SetOutlined(bool)
			self.outlined = bool
			local rendered = self.rendered
			for i=1, #rendered do
				local v = rendered[i]
				v.Outlined = bool
			end
			if self.object_end then
				self.object_end.Outlined = bool
			end
		end

		function meta:SetSize(num)
			self.size = num
			local rendered = self.rendered
			for i=1, #rendered do
				local v = rendered[i]
				v.Thickness = num
			end
		end

		function meta:SetEndSize(num)
			self.endsize = num
			if self.object_end then
				self.object_end.Radius = num
			end
		end

		function meta:SetOutlineSize(num)
			self.outlinesize = num
			local rendered = self.rendered
			for i=1, #rendered do
				local v = rendered[i]
				v.OutlineThickness = num
			end
			if self.object_end then
				self.object_end.OutlineThickness = num
			end
		end

		function meta:SetColor(col, alpha)
			local dark = color.darkness(col, .25)
			local rendered = self.rendered
			for i=1, #rendered do
				local v = rendered[i]
				v.Color = col
				v.OutlineColor = dark
			end

			if self.object_end then
				self.object_end.Color = col
				self.object_end.Visible = false
			end

			self.color = col
			self.color_dark = dark

			if alpha then
				self:SetOpacity(alpha)
			end
		end

		function meta:Clear()
			local rendered = self.rendered
			for i=1, #rendered do
				local v = rendered[i]
				v:Destroy()
			end

			if self.object_end then
				self.object_end.Visible = false
			end

			self.rendered = {}
			self.frames = {}
		end

		function meta:Update(frames)
			local rendered = self.rendered
			self.frames = frames

			local rendered_len, frame_len = #rendered, #frames

			if rendered_len < frame_len then
				local creates = frame_len - rendered_len
				for i=1, creates do
					local line = draw:Create("Line", "3D", "3D")
					line.Color = self.color
					line.Thickness = 2
					line.Outlined = self.outlined
					line.OutlineColor = self.color_dark
					line.OutlineThickness = 2
					rendered[#rendered+1] = self:Cache(line)
				end
			elseif rendered_len > frame_len then
				local c = 0
				for i=frame_len, rendered_len do
					if rendered[i-c] then
						if draw:IsValid(rendered[i-c]) then
							rendered[i-c]:Destroy()
						end
						table.remove(rendered, i-c)
						c=c+1
					end
				end
			end

			self:ShowEnd(self.showend)

			local last_frame = frames[1]
			if last_frame then
				for i=2, #frames do
					local current_frame = frames[i]
					local object = rendered[i-1]
					object.Point1 = last_frame
					object.Point2 = current_frame
					last_frame = current_frame
				end

				if self.object_end then
					self.object_end.Point = last_frame
				end
			end

			self:ValidateCache()
		end

		function meta:Cache(object)
			self.objects[#self.objects+1] = {object, object.Opacity, object.OutlineOpacity}
			return object
		end

		function meta:ShowEnd(bool)
			self.showend = bool
			if bool then
				if self.object_end then return end
				local circle = draw:Create("Circle", "3D")
				circle.Color = self.color
				circle.Radius = self.endsize
				circle.NumSides = 20
				circle.Filled = true
				circle.Outlined = self.outlined
				circle.OutlineColor = self.color_dark
				circle.OutlineThickness = 2
				circle.ZIndex = 1
				self.object_end = self:Cache(circle)
			elseif self.object_end then
				self.object_end:Destroy()
				self.object_end = nil
			end
		end

		function meta:ShouldRemove()
			if self.duration then
				return self.t0 + self.duration - tick() < 0
			else
				return false
			end
		end

		function meta:SetDuration(time)
			self.duration = time
		end

		function meta:Render()
			local frames = self.frames
			local objects = self.rendered
			if not frames[1] or not frames[2] then
				return
			end
			local opacity = 1
			if self.duration then
				local deltat = math.clamp(math.timefraction(self.t0, self.t0 + self.duration, tick()), 0, 1)
				opacity = math.remap(deltat,0,1,1,0) * self.opacity
			end

			-- 3D
			for k=1, #objects do
				local line = objects[k]
				line.Opacity = opacity
				line.OutlineOpacity = opacity
			end

			local object_end = self.object_end
			if object_end then
				object_end.Opacity = opacity
				object_end.OutlineOpacity = opacity
			end
		end
	end

	-- managed pathing system
	local creationid = 0
	function drawpather:Create()
		local construct = setmetatable({
			uid = creationid,
			cache = {},
			rendered = {},
			frames = {},
			objects = {},
		}, {
			__index = self.meta
		})
		construct:Init()
		construct:SetColor(Color3.new(), 1)
		self.registry[#self.registry+1] = construct
		return construct
	end

	function drawpather:Simple(pathway, col, opacity, time)
		local length = #pathway
		if length < 2 then return end
		local pather = self:Create()
		pather:SetColor(col)
		pather:SetOpacity(opacity)
		pather:SetDuration(time)
		pather:Update(pathway)
		return pather
	end

	function drawpather:SimpleWithEnd(pathway, col, opacity, time)
		local length = #pathway
		if length < 2 then return end
		local pather = self:Create()
		pather:SetColor(col)
		pather:ShowEnd(true)
		pather:SetOpacity(opacity)
		pather:SetDuration(time)
		pather:Update(pathway)
		return pather
	end

	hook:Add("RenderStepped", "BBOT:DrawPather.render", function(deltatime)
		local reg = drawpather.registry
		local c = 0
		for i=1, #reg do
			i=i-c
			local pather = reg[i]
			if pather:ShouldRemove() then
				table.remove(reg, i);c=c+1;
				pather:Remove()
				continue
			end
			pather:Render(deltatime)
		end
	end)
end

-- Configs
do
	local hook = BBOT.hook
	local table = BBOT.table
	local string = BBOT.string
	local timer = BBOT.timer
	local asset = BBOT.asset
	local userinputservice = BBOT.service:GetService("UserInputService")
	local localplayer = BBOT.service:GetService("LocalPlayer")
	local config = {
		registry = {}, -- storage of the current configuration
		enums = {}
	}
	BBOT.config = config
	config.storage_extension = ".json"

	-- priorities are stored like so
	-- ["player.UserId"] = -1 -> inf
	-- -1 is friendly, > 0 is priority
	config.priority = {}

	function config:SetPriority(pl, level)
		local last = config:GetPriority(pl)
		local new = tonumber(level)
		self.priority[pl.UserId] = new
		asset:WriteJSON("data", "priorities.json", self.priority)
		hook:Call("OnPriorityChanged", pl, last, config:GetPriority(pl))
	end

	function config:GetPriority(pl)
		if not pl then return end
		if pl == localplayer then return 0 end
		local level, reason = 0, nil
		if self.priority[pl.UserId] then
			level = self.priority[pl.UserId]
			if level == nil then level = 0 end
			if level ~= 0 then
				return level, reason
			end
		end
		level, reason = hook:Call("GetPriority", pl)
		if level == nil then level = 0 end
		return level, reason
	end

	hook:Add("PlayerAdded", "BBOT:Configs.SetupPriority", function(pl)
		local priority = config:GetPriority(pl)
		if priority == 0 then return end
		hook:Call("OnPriorityChanged", pl, 0, priority)
	end)

	hook:Add("PostInitialize", "BBOT:Configs.SetupPriority", function()
		local players = BBOT.service:GetService("Players")
		for k, pl in next, players:GetPlayers() do
			local priority = config:GetPriority(pl)
			if priority == 0 then return end
			hook:Call("OnPriorityChanged", pl, 0, priority)
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
		local list = asset:ListFiles("configs")
		local c=0
		for i=1, #list do
			local v = list[i-c]
			local file = string.Explode(".", v)[1]
			list[i-c]=file
		end
		return list
	end

	function config:Save(file)
		local reg = table.deepcopy( self.registry )
		reg["Main"]["Settings"]["Saves"]["Configs"] = nil
		reg = self:ConfigToSaveable(reg)
		asset:WriteJSON("configs", file .. self.storage_extension, reg)
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
						for i=1, #value.value do
							if typeof(value.value[i]) ~= typeof(newvalue[i]) then
								newvalue = nil
								break
							elseif value.value[i][1] ~= newvalue[i][1] then
								newvalue = nil
								break
							end
						end
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
		local path = file .. self.storage_extension
		if asset:IsFile("configs", path) then
			local configsection = self.registry["Main"]["Settings"]["Saves"]["Configs"]
			local old = table.deepcopy(self.registry)
			local newconfig = asset:ReadJSON("configs", path)
			self.Opening = true
			local ran, err = self:ProcessOpen(self.registry, nil, newconfig)
			if not ran then
				BBOT.log(LOG_WARN, "Error loading config '" .. file .. "', did you break something in it?")
				BBOT.log(LOG_ERROR, err)
				self.registry = old
				return
			end
			self.registry["Main"]["Settings"]["Saves"]["Configs"] = configsection
			hook:Call("OnConfigOpened", file)
			self.Opening = nil
		end
	end

	function config:SaveBase()
		local reg = table.deepcopy( self.registry["Main"]["Settings"]["Saves"]["Configs"] )
		reg = self:ConfigToSaveable(reg)
		asset:WriteJSON("data", "configs.json", reg)
	end

	function config:OpenBase()
		local path = "configs.json"
		if asset:IsFile("data", path) then
			local old = table.deepcopy(self.registry["Main"]["Settings"]["Saves"]["Configs"])
			local newconfig = asset:ReadJSON("data", path)
			self.Opening = true
			local ran, err = self:ProcessOpen(self.registry["Main"]["Settings"]["Saves"]["Configs"], {"Main", "Settings", "Saves", "Configs"}, newconfig)
			if not ran then
				BBOT.log(LOG_WARN, "Error loading base '" .. path .. "', did you break something in it?")
				BBOT.log(LOG_ERROR, err)
				self.registry["Main"]["Settings"]["Saves"]["Configs"] = old
				return
			end
			self.Opening = nil
		end
	end

	hook:Add("OnConfigChanged", "BBOT:config.autosave", function(steps)
		if config.Opening or config.Busy then return end
		config:SaveBase()
		if config:GetValue("Main", "Settings", "Saves", "Configs", "Auto Save Config") and not config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Configs") then
			local file = config:GetValue("Main", "Settings", "Saves", "Configs", "Autosave File")
			BBOT.log(LOG_NORMAL, "Autosaving config -> " .. file)
			config:Save(file)
		end
	end)

	hook:Add("Menu.PostGenerate", "BBOT:config.setup", function()
		local configs = BBOT.config:Discover()
		BBOT.config:GetRaw("Main", "Settings", "Saves", "Configs", "Configs").list = configs
		BBOT.menu.config_pathways[table.concat({"Main", "Settings", "Saves", "Configs", "Configs"}, ".")]:SetOptions(configs)
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
				if typeof(s) == "table" and s.type and s.type ~= "Button" then
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
		if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") and not new then
			timer:Async(function()
				config.Busy = true
				for i=1, #config.unsafe_paths do
					local path = string.Explode(".", config.unsafe_paths[i])
					config:SetValue(config:BaseGetNormal(unpack(path)), unpack(path))
				end
				config.Busy = false
			end)
		end
	end)


	hook:Add("PreInitialize", "BBOT:config.setup", function()
		config:Setup(BBOT.configuration)

		if asset:IsFile("data", "priorities.json") then
			local tbl = asset:ReadJSON("data", "priorities.json")
			for k, v in pairs(tbl) do
				config.priority[tonumber(k)] = v
			end
		end

		config:OpenBase()
		if config:GetValue("Main", "Settings", "Saves", "Configs", "Auto Load Config") then
			local file = config:GetValue("Main", "Settings", "Saves", "Configs", "Autoload File")
			BBOT.log(LOG_NORMAL, "Autoloading config -> " .. file)
			BBOT.notification:Create("Auto loaded config: " .. file)
			config:Open(file)
		end
	end)
end

-- GUI
do
	-- WholeCream's Drawing Library to GUI Library
	-- Extremely versatile and immediate!
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

	if BBOT.Debug.menu then
		local dbg = draw:Create("Rect", "2V")
        gui.drawing_debugger = dbg
		dbg.XAlignment = XAlignment.Right
		dbg.YAlignment = YAlignment.Bottom
		dbg.Color = Color3.new(1,1,1)
		dbg.Visible = false
		dbg.ZIndex = 2000000

		local dbgtext = draw:Create("Text", "2V")
        gui.drawing_debugger_text = dbgtext
		dbgtext.Color = Color3.fromRGB(255,255,255)
		dbgtext.Outlined = true
		dbgtext.XAlignment = XAlignment.Right
		dbgtext.YAlignment = YAlignment.Bottom
		dbgtext.TextXAlignment = XAlignment.Left
		dbgtext.OutlineColor = Color3.fromRGB(0,0,0)
		dbgtext.OutlineThickness = 2
		dbgtext.Visible = false
		dbgtext.ZIndex = 2000000

		local mouse = draw:CreatePoint("Mouse")
		local dbgtext = draw:Create("Text", "Offset")
        gui.drawing_debugger_actives = dbgtext
		dbgtext.Color = Color3.fromRGB(255,255,255)
		dbgtext.Outlined = true
		dbgtext.XAlignment = XAlignment.Right
		dbgtext.YAlignment = YAlignment.Bottom
		dbgtext.TextXAlignment = XAlignment.Left
		dbgtext.OutlineColor = Color3.fromRGB(0,0,0)
		dbgtext.OutlineThickness = 2
		dbgtext.Visible = true
		dbgtext.ZIndex = 2000000
		dbgtext.Offset = Vector2.new(10, 10)
		dbgtext.point.Point = mouse.point
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

		-- this is usually overwritten, called when the panel is created
		function base:Init()
			self:Calculate()
		end

		-- set's the position of the panel, you can put a UDim2 or just raw values for this
		function base:SetPos(xs, xo, ys, yo)
			if typeof(xs) == "UDim2" then
				self.pos = xs
			else
				self.pos = UDim2.new(xs, xo, ys, yo)
			end
			self:Calculate()
		end

		-- set's the size of the panel, you can put a UDim2 or just raw values for this
		function base:SetSize(ws, wo, hs, ho)
			if typeof(ws) == "UDim2" then
				self.size = ws
			else
				self.size = UDim2.new(ws, wo, hs, ho)
			end
			self:Calculate()
		end

		-- size constraints forces the panel to restrict it's size depending on it's length or width
		function base:SetSizeConstraint(type)
			self.sizeconstraint = type
		end

		-- returns a Vector2 of it's position local to it's parent
		function base:GetPos()
			return self.pos
		end

		-- PerformLayout is called when the panel changes it's position or size, use this for drawing objects
		function base:PerformLayout(pos, size)
		end

		-- Centers the panel to's parent
		function base:Center()
			self:SetPos(.5, -self.absolutesize.X/2, .5, -self.absolutesize.Y/2)
		end

		-- Get's the absolute position and size in screen space
		local camera = BBOT.service:GetService("CurrentCamera")
		function base:GetLocalTranslation()
			local psize = (self.parent and self.parent.absolutesize or camera.ViewportSize)

			local X = math.round(self.pos.X.Offset + (self.pos.X.Scale * psize.X))
			local Y = math.round(self.pos.Y.Offset + (self.pos.Y.Scale * psize.Y))
			local W = math.round(self.size.X.Offset + (self.size.X.Scale * psize.X))
			local H = math.round(self.size.Y.Offset + (self.size.Y.Scale * psize.Y))

			if self.sizeconstraint == "Y" and W > H then
				W = H
			elseif self.sizeconstraint == "X" and H > W then
				H = W
			end

			-- this is fucking retarded
			local ppos = (self.parent and self.parent.absolutepos or Vector2.new())
			if X > math.huge or X < -math.huge then
				X = self.absolutepos.X - ppos.X
			end

			if Y > math.huge or Y < -math.huge then
				Y = self.absolutepos.Y - ppos.Y
			end

			if W > math.huge or W < -math.huge then
				W = self.absolutesize.X
			end

			if H > math.huge or H < -math.huge then
				H = self.absolutesize.Y
			end

			return Vector2.new(X, Y), Vector2.new(W, H)
		end

		-- Forces a calculation of PerformLayout, put in positionshift or sizeshift to let em know if there was a change
		function base:InvalidateLayout(positionshift, sizeshift)
			self:PerformLayout(self.absolutepos, self.absolutesize, positionshift, sizeshift)
		end

		-- Recursively does layout recaluclations, same purpose of InvalidateLayout just recursive
		function base:InvalidateAllLayouts(positionshift, sizeshift)
			self:InvalidateLayout(positionshift, sizeshift)
			local children = self.children
			for i=1, #children do
				local v = children[i]
				if gui:IsValid(v) then
					v:InvalidateAllLayouts(positionshift, sizeshift)
				end
			end
		end

		-- Calculate is responsible for everything the panel needs to do, try not to override this ok?
		function base:Calculate()
			if self.__INVALID then return end
			local t = tick()
			local last_opacity, last_zind, last_vis = self._opacity, self._zindex, self._visible
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

			local positionshift, sizeshift = false, false
			do
				local ppos = (self.parent and self.parent.absolutepos or Vector2.new())
				local pos, size = self:GetLocalTranslation()
				local a = pos + ppos
				if self.absolutepos ~= a then
					self.absolutepos = a
					positionshift = true
				end
				if self.absolutesize ~= size then
					self.absolutesize = size
					sizeshift = true
				end
			end

			local changed = last_opacity ~= self._opacity or last_zind ~= self.zindex or last_vis ~= self._visible or wasenabled ~= self._enabled or positionshift or sizeshift
			if self._enabled and changed then
				self:InvalidateLayout(positionshift, sizeshift)
			end
			
			if changed then
				self:PerformDrawings()
			end

			if self.OnVisibleChanged and last_vis ~= self._visible then
				self:OnVisibleChanged(self._visible)
			end

			if self.OnZIndexChanged and last_zind ~= self.zindex then
				self:OnZIndexChanged(self.zindex)
			end

			if self.OnOpacityChanged and last_opacity ~= self._opacity then
				self:OnOpacityChanged(self._opacity)
			end

			if self.OnEnabledChanged and wasenabled ~= self._enabled then
				self:OnEnabledChanged(self._enabled)
			end

			-- Partly why this is expensive is recursion, we need to do this to make sure all sub panels inherit properties
			if (self._enabled or wasenabled) and changed then
				local children = self.children
				for i=1, #children do
					local v = children[i]
					if v.Calculate then
						v:Calculate()
					end
					if v.ParentPerformLayout and self._enabled and changed then
						v:ParentPerformLayout(self.absolutepos, self.absolutesize, positionshift, sizeshift)
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
			self._profile_calculate = tick() - t
		end

		-- This calculate all of the drawing object's behavior
		function base:PerformDrawings()
			local cache = self.objects
			for i=1, #cache do
				local v = cache[i]
				if v.object and draw:IsValid(v.object) then
					local drawing = v.object
					drawing.Opacity = v.opacity * self._opacity
					drawing.OutlineOpacity = v.outlineopacity * self._opacity
					drawing.ZIndex = v.zindex + self._zindex
					if not v.visible or not self._enabled then
						drawing.Visible = false
					elseif v.visible then
						if self._visible then
							drawing.Visible = self.local_visible
						else
							drawing.Visible = false
						end
					end
				end
			end
		end

		-- Set's what the parented panel should be, putting nil will remove the parent
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

		-- Get's every single child and sub children of a panel to a numerical table
		function base:RecursiveToNumeric(children, destination)
			destination = destination or {}
			children = children or self.children
			for i=1, #children do
				local v = children[i]
				if v ~= self then
					v:RecursiveToNumeric(v.children, destination)
				end
				destination[#destination+1] = v
			end
			return destination
		end

		-- I do not need to explain this
		function base:IsHovering()
			return self.ishovering == true
		end

		function base:IsAbsoluteHovering() -- absolute disregards priorities of ZIndexes
			return self.absoluteishovering == true
		end

		-- Called when a mouse enters the panel's bounds
		function base:OnMouseEnter() end
		function base:OnAbsoluteMouseEnter() end -- absolute disregards priorities of ZIndexes
		-- Called when a mouse leaves the panel's bounds
		function base:OnMouseExit() end
		function base:OnAbsoluteMouseExit() end -- absolute disregards priorities of ZIndexes

		-- Called the same way as "RenderStepped"
		function base:Step() end
		function base:Cache(object, opacity, outlineopacity, zindex, visible)
			if self.__INVALID then return end
			local objects = self.objects
			local exists = false
			for i=1, #objects do
				local v = objects[i]
				if v.object == object then
					v.opacity = opacity or object.Opacity
					v.outlineopacity = outlineopacity or object.OutlineOpacity
					v.zindex = zindex or object.ZIndex
					v.visible = visible or object.Visible
					object.Opacity = object.Opacity * self._opacity
					object.ZIndex = object.ZIndex + self._zindex
					if not object.Visible or not self._enabled then
						object.Visible = false
					elseif object.Visible then
						if self._visible then
							object.Visible = self.local_visible
						else
							object.Visible = false
						end
					end
					return object
				end
			end
			self.objects[#self.objects+1] = {
				object = object,
				opacity = object.Opacity,
				outlineopacity = object.OutlineOpacity,
				zindex = object.ZIndex,
				visible = object.Visible
			}
			object.Opacity = object.Opacity * self._opacity
			object.ZIndex = object.ZIndex + self._zindex
			if not object.Visible or not self._enabled then
				object.Visible = false
			elseif object.Visible then
				if self._visible then
					object.Visible = self.local_visible
				else
					object.Visible = false
				end
			end
			return object
		end

		-- Calling Destroy will remove all drawing objects associated with the panel
		function base:PreDestroy() end
		function base:PostDestroy() end
		function base:Destroy()
			self:PreDestroy()
			local objects = self.objects
			while true do
				local v = objects[1]
				if not v then break end
				v = v.object
				if draw:IsValid(v) then
					v:Remove()
				end
				table.remove(objects, 1)
			end
			self:PostDestroy()
		end

		-- Calling Remove will destory the panel and all drawing object associated
		function base:PreRemove() end
		function base:PostRemove() end
		function base:Remove()
			self:SetVisible(false)
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

		-- !!!!Absolute returns what the panel's total whatever is from it's parent!!!! --

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
		function base:SetLocalVisible(bool)
			self.local_visible = bool
			self:Calculate()
		end

		-- Focus is used to force the panel's ZIndex to be higher than others
		-- This is hover pretty shittily done
		function base:SetFocused(focus)
			self.focused = focus
			self:Calculate()
		end
		function base:SetMouseInputs(inputs)
			self.mouseinputs = inputs
		end
	end

	-- Use register to add a new panel class for creation, similar to like how base is done
	function gui:Register(tbl, class, base)
		base = (base and self.classes[base] or self.base)
		if not base then base = self.base end
		setmetatable(tbl, {__index = base})
		tbl.class = class
		tbl.super = base
		self.classes[class] = tbl
	end

	-- Create just makes the panel... Of course from the ones you have registered
	local uid = 0
	function gui:Create(class, parent)
		if not self.classes[class] then
			error("gui:Create - No Such Class: " .. class)
			return
		end
		local struct = {
			uid = uid,
			objects = {},
			parent = parent,
			children = {},
			isgui = true,
			mouseinputs = true,
			class = class,
			traceback = debug.traceback(),

			-- If only there was a better way of inheriting variables
			enabled = true,
			_enabled = true,
			visible = true,
			_visible = true,
			local_visible = true,
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
		self.active[#self.active+1] = struct
		if struct.Init then
			struct:Init()
		end
		if parent then
			struct:SetParent(parent)
		end
		return struct
	end

	-- Use this to check if a panel has been destroyed
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

		-- Sizes a GUI object to a certain UDim2 size
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

	hook:Add("RenderStepped", "BBOT:GUI.Animation", function()
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

	-- Checks if the panel is being hovered over
	function gui:IsHovering(object)
		if not object._enabled then return end
		return mouse.X > object.absolutepos.X and mouse.X < object.absolutepos.X + object.absolutesize.X and mouse.Y > object.absolutepos.Y - 36 and mouse.Y < object.absolutepos.Y + object.absolutesize.Y - 36
	end

	-- Check is the mouse is hovering any panel
	function gui:IsHoveringAnObject()
		return #gui.objects_hovering > 0
	end

	local function V2ToString(vec)
		return "V("..vec.X..", "..vec.Y..")"
	end

	local function UDToString(udim)
		return "D(".. udim.X.Scale ..",".. udim.X.Offset ..",".. udim.Y.Scale ..",".. udim.Y.Offset ..")"
	end

	gui.objects_hovering = {}
	gui.objects_keyhovering = {}
	hook:Add("RenderStepped", "BBOT:GUI.Hovering", function()
		local objects_hovering = gui.objects_hovering
		local objects_keyhovering = gui.objects_keyhovering
		local reg = gui.active
		local changed = false
		local c = 0
		for i=1, #objects_hovering do
			local k = i - c
			local v = objects_hovering[k]
			if (not v or v.__INVALID or not gui:IsHovering(v)) then
				if v.absoluteishovering ~= false then
					v.absoluteishovering = false
					if v.OnAbsoluteMouseExit then
						v:OnAbsoluteMouseExit(mouse.X, mouse.Y)
					end
				end
				objects_keyhovering[v] = nil
				table.remove(objects_hovering, k)
				c=c+1
				changed = true
			end
		end

		for i=1, #reg do
			local v = reg[i]
			if v and not objects_keyhovering[v] and not v.__INVALID and v.class ~= "Mouse" and v.class ~= "Container" and gui:IsHovering(v) then
				if v.absoluteishovering ~= true then
					v.absoluteishovering = true
					if v.OnAbsoluteMouseEnter then
						v:OnAbsoluteMouseEnter(mouse.X, mouse.Y)
					end
				end
				objects_keyhovering[v] = true
				objects_hovering[#objects_hovering+1] = v
				changed = true
			end
		end

		if changed then
			table.sort(objects_hovering, function(a, b) return a._zindex > b._zindex end)

			local set = false
			for i=1, #objects_hovering do
				local v = objects_hovering[i]
				if v.mouseinputs then
					if v ~= gui.hovering then
						if gui.hovering then
							gui.hovering.ishovering = false
							if gui.hovering.OnMouseExit then
								gui.hovering:OnMouseExit(mouse.X, mouse.Y)
							end
						end
						gui.hovering = v
						if gui.hovering then
							gui.hovering.ishovering = true
							if gui.hovering.OnMouseEnter then
								gui.hovering:OnMouseEnter(mouse.X, mouse.Y)
							end
						end
					end
					set = true
					break
				end
			end

			if not set then
				if gui.hovering ~= nil then
					if gui.hovering then
						gui.hovering.ishovering = false
						if gui.hovering.OnMouseExit then
							gui.hovering:OnMouseExit(mouse.X, mouse.Y)
						end
					end
					gui.hovering = nil
				end
			end
		end

		if gui.drawing_debugger then
			local result = objects_hovering[1]

			if result then
				gui.drawing_debugger.Visible = true
				gui.drawing_debugger.Offset = result.absolutepos
				gui.drawing_debugger.Size = result.absolutesize

				gui.drawing_debugger_text.Offset = result.absolutepos + Vector2.new(0, result.absolutesize.Y)
				gui.drawing_debugger_text.Visible = true
				local dbgmsg = tostring(result) .. "\n" ..
				"Position: " .. UDToString(result.pos) .. " - " .. V2ToString(result.absolutepos) .. "\n" ..
				"Size: " .. UDToString(result.size) .. " - " .. V2ToString(result.absolutesize) .. "\n" ..
				"Children: " .. #result.children .. " (" .. #result:RecursiveToNumeric() .. ")\n" ..
				"Calculate: " .. math.round((result._profile_calculate or 0) * 1000, 4) .. " ms\n" ..
				"Step: " .. math.round((result._step_profile or 0) * 1000, 4) .. " ms"

				gui.drawing_debugger_text.Text = dbgmsg
				gui.drawing_debugger_actives.Visible = false
			else
				gui.drawing_debugger.Visible = false
				gui.drawing_debugger_text.Visible = false
				gui.drawing_debugger_actives.Visible = true
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

	hook:Add("RenderStepped", "BBOT:GUI.Render", function(delta)
		
		local tt = tick()
		local mouse_reg = 0
		local reg = gui.active
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
				if v.Step then
					local t = tick()
					v:Step(delta)
					v._step_profile = tick() - t
				end
				if v.mouseinputs then
					mouse_reg = mouse_reg + 1
				end
			end
		end
		tt = tick() - tt
	
		if gui.drawing_debugger_actives then
			gui.drawing_debugger_actives.Text = "IGUI Debugger\nObjects: " .. #gui.registry ..
			"\nActive: " .. #gui.active ..
			"\nInput: " .. mouse_reg ..
			"\nStep: " .. math.round(tt * 1000, 4) .. " ms"
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

	hook:Add("Unload", "BBOT:GUI.Remove", function()
		local reg = gui.registry
		for i=1, #reg do
			local v = reg[i]
			if v and not v.__INVALID then
				v:Remove()
			end
		end
	end)
end

-- Font Manager
do
    local hook = BBOT.hook
	local draw = BBOT.draw
	local gui = BBOT.gui
	local string = BBOT.string
	local asset = BBOT.asset
    local log = BBOT.log
	local font = {
        registry = {},
		managers = {}
	}
    BBOT.font = font

	function font:GetFonts()
		local list = {}
		for k, v in pairs(font.registry) do
			list[#list+1] = k
		end
		table.sort(list, function(a, b) return a < b end)
		return list
	end

	-- { Bold = true, Italics = true }
    function font:Register(font_name, font_data, font_arguments)
		if not font:CanRegister(font_name, font_data) then return end
        local font_object = Font.Register(font_data, font_arguments or {})
        self.registry[font_name] = font_object
        return font_object
    end

	function font:CanRegister(font_name, font_data)
		if self.registry[font_name] then return false end
		return true
	end

    function font:Create(category, font, size)
        local reg = self.registry[font]
        if not reg then return end
        log(LOG_DEBUG, "Created font-manager '" .. category .. "' with font '" .. font .. "' and size '" .. size .. "'")
        self.managers[category] = {
			font = font,
			size = size,
			handles = {},
		}
    end

    function font:Get(category)
        local reg = self.managers[category]
        if not reg then return end
        local font_object = self.registry[reg.font]
        if not font_object then return end
        return font_object, reg.size
    end

	function font:GetFont(name)
		return self.registry[name]
	end

    function font:GetTextBounds(category, text)
        local font_registry = self.managers[category]
        if not font_registry then return end
        local font, size = font_registry.font, font_registry.size
        local font_object = self.registry[font]
        if not font_object then return end
        return font_object:GetTextBounds(size, text)
    end

	function font:AddToManager(object, category)
		local manager = self.managers[category]
		if not manager then return end
		manager.handles[#manager.handles+1] = object
		if object.isdraw then
			local font, size = font:Get(category)
			object.Font = font
			object.Size = size
		end
	end

	function font:RemoveFromManager(object, category)
		local manager = self.managers[category]
		if not manager then return end
		for i=1, #manager.handles do
			local v = manager.handles[i]
			if v == object then
				table.remove(manager.handles, i)
				break
			end
		end
	end

    function font:ChangeFont(category, new)
		local new_font = self.registry[new]
        if not new_font then return end
		local manager = self.managers[category]
		if not manager then return end
        log(LOG_DEBUG, "Changed font-manager '" .. category .. "' to '" .. new .. "'")
        local old = manager.font
        manager.font = new
		local handles = manager.handles
		local c = 0
		for i=1, #handles do
			local v = handles[i-c]
			if rawget(v, "isdraw") and draw:IsValid(v) then
				v.Font = new_font
			elseif rawget(v, "isgui") and gui:IsValid(v) then
				if v.OnFontChanged then
					v:OnFontChanged(old, new)
				end
			else
				table.remove(handles, i-c)
				c=c+1
			end
		end
        hook:Call("OnFontTypeChanged", category, old, new)
    end

    function font:ChangeSize(category, new)
		local manager = self.managers[category]
		if not manager then return end
        log(LOG_DEBUG, "Changed font-manager size '" .. category .. "' to '" .. new .. "'")
        local old = manager.size
        manager.size = new
		local handles = manager.handles
		local c = 0
		for i=1, #handles do
			local v = handles[i-c]
			if rawget(v, "isdraw") and draw:IsValid(v) then
				v.Size = new
			elseif rawget(v, "isgui") and gui:IsValid(v) then
				if v.OnFontSizeChanged then
					v:OnFontSizeChanged(old, new)
				end
			else
				table.remove(handles, i-c)
				c=c+1
			end
		end
        hook:Call("OnFontSizeChanged", category, old, new)
    end

	function font:GetDefault()
		return "IBMPlexMono Medium"
	end

    local defaults = Font.ListDefault()
    for i=1, #defaults do
        local font_name = defaults[i]
		local lower = string.lower(font_name)
		if string.find(lower, "italic")
			or string.find(lower, "thin")
			or string.find(lower, "light")
		then continue end
        local font_object = Font.RegisterDefault(font_name, {})
        if not font_object then continue end
		font_name = string.Replace( font_name, "_", " " )
        font.registry[font_name] = font_object
    end

	function font:RegisterAssets()
		local registered = false
		local list = asset:ListFiles("fonts", "")
		for i=1, #list do
			local fontdata = asset:Read("fonts", list[i])
			local name = asset:GetFileName(list[i])
			if font:CanRegister(name, fontdata) then
				font:Register(name, fontdata)
				registered = true
			end
		end
		return registered
	end

	hook:Add("Startup", "BBOT:Font.Setup", function()
		asset:Register("fonts", {".ttf", ".otf"})
		font:RegisterAssets()
	end)
end

-- Icons
do
	local icons = {
		registry = {},
	}
	BBOT.icons = icons
	local hook = BBOT.hook

	hook:Add("Startup", "BBOT:Icons.Load", function()
		icons.registry = {
				-- MENU
				["PISTOL"] = {"iVBORw0KGgoAAAANSUhEUgAAADQAAAAeCAYAAABjTz27AAACXUlEQVR4nNXYS6hNURzH8c9xLzeSR6SQgVIXA4k8SkhKSlHKAKUMjDBRZkZGSibKwISJUkqMiEylJMr7NZC886Z78/wbrHvrdJxz7ln77utc39qd3Vl7/fb/t57/tSsRYQAm4Dm24mzV/90Y26DOD9wcSLhEZuAovnYO8GAHdmEMTuEwRmEpFjWp18jQKxzHJzzGtD7tXHrwArMwHvswH58rTXqoE6exvsALW6EXXRhRoO4vfMfo2oJmho5he4GXtZVGhibjtWKt11aqA96A5X33q/2HZkjzpAM7cRCBHdjUzqAGwcdKRGyUJn8/gd+S0f+NA/1zaCwWYz+WtTWk4nzDzE5swx7MQ+UfB9BTgs5XvMFFvKxExBlpp+2nC3MMbsidwzOMxBpMryp7jL04L5kql4iod3VHxPXI43dE9EbE/YjoqNKaFBF3+555GBFTGryzlKvR0vwAm/Ezo20uSF1/UtrJ+3knDWl9v28y2zyLZnvNA1zL0LojDdP3dcqu4ItkekgZaPP8kqG1AJexsE7ZT6mnfmToFaKZoRHSytcqq/BUyp6n1pRNlI4hQ06z5HQ+bmTqPZGGXu1yPBsfsDJTL5tm56HcTHs3jkiZRtto1EPduCXtI61wDuvKCmowNJpDh7RuBi6VEEsp1DM0V35r3y4hllKoZ2hNAZ1bgw2kLOoZWp2p8Vb6+DEsqDXUiRWZGsOmd/jb0BKMy9QYNvOHvw3NLqAxrA0VOeA9LyOQsqg19KiAxpIyAimLWkNX5af4W/zbo3tTag31Yq20F51oof496Vt1W/O3av4ARjQk0oC+k4cAAAAASUVORK5CYII=", 52, 30},
				["RIFLE"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAdCAYAAABcz8ldAAAD+klEQVR4nO3aS2hcVRjA8d+MRqTahqj4bIUujIKPBitasQsfUXHTouhGMKLiTjeCoKCIDwTduPIFKoq1IFQXFS2iLVGoaNWmlmqVKloNihvTGG0yscm4+O4wk8nMeCfzTOofLpd7zp1zzpzvfI/znZvJ5/OWGMdgLfqxH3/hZKzBCchiM86ro80pjODvpo6UIbyGa/EhHNvkDtJyC64Sk9cKVuBqRWH0ltRNY1BMQlryeAkHMF6hfiy578LBOtq9Ibn3FAoyHdCQIbyKTLs7bjJTigu6cH8LN6f8fRZbMYMXsI32CuTEpNN1OqeZxGqfwSHsKSk/E2ck5T+UlJ8rtCwvhFBNQ87C6bgLr6QYxyVYhb3CvG6jvRPTj8va3GclMskYehVNDaxEHybLypcl1294TvifShwvVvzLwhw+jZ9qjGM9HkUOjwm/l83kG1eRI/hMOKVfS8p7xOo6HxfhlAb7OSpohkCOFnZgVJitSsyKBTiF1cnzOzXaW4EbhZn7GL/zv0Dq4Un1RVBpyArTuRm/0Hl73my24A/heCdxGNeLEJswr59iJ35M6qeSe07sM6ZFuPwPJpLf5JJ3Wk67NCQn/MwELsdJFd75Do/gXuHsxsRkDeB1fI2fFWP3SqxL+iklK4SyDNtFFNW1tFJDvsf7IpwbVtzljqgskAN4Exfgg5Ly0+roc8B8gcwmY1gUZJvUzhGxgjeJFX5Oct2Dd81NOTxcpY2Cpo6IFEc5U5L0Qg3Wpxxv17JQkzUmVv0OsSL3CZudhuX4s6xsAk/gRWH/+xT3AgO4Iulnt9C6wSptjwuNyqUcS9eRViCTwhFuT67dYre7EC4Uu9NShoSfWIVTy+oOik3XaPK8Fl/UaH+D2uFmV1NNIDP4UlEAO1WPv+vlITxe8jyKsxVN1n+REamN1VXqhxWjqkVHqVPfryiAYa2LRjaWPW+VXhiSd7fg/ir1V+J2kdZedGTy+fwgvjE37dEqVorQtTTTe525UVUaLhYaXI0xEa214z81laz5OahWstFcYRwS2lgvu9UWYh+eX0C7HadZYW9ays3Ve2JHvBDuUzua2oC7F9h2x2inQJYL+17Krgba2ydC5Vo8q3qI3JW0UyCHxQR+IjaSRAjcCE+JjWQ1esQp3jUN9tM2OnGES2hLP77V+IcDa/C5knPpCkzjTrzRYF8tp90+pMCEiJKa8RXHVyIZWYvjxMbzAV1+lt8pDWk2GZFHu1XsU6pN+iwuVTtk7iid0pBmkxcm6SO1NeAZXSwMlo6GFOjF2+KbrHL2Cu3o6sTjUtGQAuPiAGtTWXkOt+lyYbD0BEJEVEPmOvoHzc8wdyVLzWSVc4fIDtwkHHrX8y9c6Q6XYJwubQAAAABJRU5ErkJggg==", 100, 29},
				["SHOTGUN"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAbCAYAAACKlipAAAADgklEQVR4nO3aS2hcZRTA8V/StKYtEbGxLdr6QFsfUBHRhWhRqCiI2qAVXLkRurG4EVwpiK66caGg+Ni5UxeiFJQqiAaUFotB8bGoRRc+sLRFm1eT9Lg495rJdCaZZKYzaTt/uMw333fud8+d853vnHPv9ESEs8Q27MQQrscvuLkYGyn6+nEEa7Eex/E3ttaYbwx/NnjtF/DO0tTuMBHRqmNFRNwdES9HxOGYy1Ah81ZEvF60d0XEzxGxMiIGI2IiIrZERE9EDEdz7GnhfbX16GvSnmtwv/SEB7Gujtzl6JNeMI0VRd9aXIwNFX1/4Oom9Vpu9OASjGNiXsklWHF9RDwZER9GxNgiVu1onfZkREwX7ZmIGK8YOxkRuyPi9CKuE7H8PGSw0OuNhWQb9ZAtMhbsxB3obeCcGQzjAE4vIPtIcY1eGVdKLsJuucJqcQpf4WBxvZJR3NuAjovhS0wu8dyVxed9Cwn2xNygvglXSLfql0Z4GDctUZHzia9xcpHnrMFGDOCyom8Eq6ntDJUGGcDjCDwts6Qubaa00g687fwLpuccpYcM484O67LcGcOLcuuZlBnlqMwaDy9innVyN6qMw98Xc3YNsky4VhbODWVLXdpIGUNGO6rFucW/+EdmUKcwhb+anPP/dLo0yOcayJEr+AS/Fu3tuLGGzF68N88cq2R1Pyir/asqxo7gR7MevFHm8jfIir6TPIEPivZqWX23jDKGbMAreEz9ImxK5uLHZCFXFntXmjVOye/YbOGCsORRXNeA3Etmi6xOsV3G3LNCdWF4Fz6Sz12qmcYzsmh8s2psUq74kldlLdNqRqU3f4wfpHH65TZSPi86XsheKhdP2VbIbJNp/u3OLM7G5Y/9mSLIVjGGfU3fxTxUKzSM/dJTasmecGatMiT30oP4Bofwfgt1rGSH9NJmeBfPy63ylqLvkCyIR+W9dIxqgwxIL6nFAbkiT8i9/Cf5SKVPrsyZOue1kmaNUclRfNrC+VpC9Za1F8/WkJvBbfi2+H4rrsFv0jO6tIhKg2zFd+bGgpLX8FS7lLqQqTTIPjxQQ+aYfN16tF1KXciUef5DahsDntM1RtvoiYhVcquq9ceCCZkytrT46VKfXuxR2xjwha4x2kovds0zvr9dinRJeiJiSp3XibJwGmmfOl16zR+wN7VLkS5JL+6RDwNrsbl9qnSB/wBF8j6LJlmzYQAAAABJRU5ErkJggg==", 100, 27},
				["SMG"] = {"iVBORw0KGgoAAAANSUhEUgAAAE0AAAAeCAYAAABpE5PpAAADmklEQVR4nO3ZS4iVZRgH8N+Mk6FRNpXlQrPLBEVN2WUhJSUkXSgs6EZBSG0KWrQJIlu00YKgRSuJdrbKkDYVU9pNi2rRZVBrkyGWKQ4U5oxMXs7T4v2mvnPmO9+cc2bOnDnhH154r8/zfM/7fu9zeXsiQpdhJUaxuw20v8At6EVdxfS2gXE7sRAP4vZOCtHTZSdtOfZhf1afaTR00vrawLiduB4V9OOrrO/vmjl9mJdrV3CiZs589OTap3Ayow/v4v56QnSb0hZifa79Aha1gc+KssFuU9oqDOOPrH2yTXwuljbjSNFgN91pZ0pWM7/Rb0n320CuzNTJW4Uviwa66aRdZbK8b2JnTd9iXC4p8IpcfQDnN8Fv0P9AaYMFfbsK+kay8nXBWL/qUzmAtTi3QX5ISltTLuucwZ017T9xU4u0JhS7Ax9iE45hSW7OZfUW92Fbi4w7jX4zJ/sxHFCttLqOf7dFBHMCs3mn7cH4NNZfivNy7VEcnpZE/2Gx5APWYgkWqHaED/dEF/kcs4zfcIHk6gzjWilJsLmbrOdsY2mu3iudth4Mnj5pzeO70yetGJ/hI5wj+XB5gzk+V5RWwafYLBkM0q+wFs+oNgBleAnvZ/UBvCIZkGaxWopvHygcjc5iLCLWR8SyiFCnnB0ROxqg9UnB2sGIqLQo29Z6MnXaT3scL+PXkjlH8aySpGCG9wr6dmFryZrAB3gHQ1PQ/xed/D1/l5J9jWDP1FMmJRon8BAextsFYztxT679OW7N6nPyjeCsJuY+p9rBLMK9Uhy9omBsixRj1mKspj2aq89JpS2SLvoyzMPr2NgAvTukWPSNOuP7CvoOlNCb8o3gR8ly5bFSSZ68Diqa24hNOIRvCsZuxAbcVbL+IB6T7qUFWd91UuZ1f25eb0avFttLaNdV2oRzOyKFCnksxZUlRIswJJn5pyVzPb/Bdb9IL0Hj0m94M66eYs1fuA0/4KcaWYewTopNz5BckRdr1lek2HIk13c3lmX1vfi4iHE7090X4kk8hUtmmPZx6QLfLm3MUZM36Ah+xkWqQ6IJfI8bWuJe4h/NVOmNiDURsSUiTrToM+VRiYh1OfqDLdJ5NVr8ptlQWr4sj4iNEXGoxQ+NiHi+huajLdAYymTpCqVNlPkR8UhEHGziQ4cjYnUBrQ1N0NgbEfdNV/5OObfHJWfzCSlfVYRT+FYKnLcpfkSBaxrgNyYZqNdMLxEK/gEIMckYAgwqoQAAAABJRU5ErkJggg==", 77, 30},
				["SNIPER"] = {"iVBORw0KGgoAAAANSUhEUgAAAGQAAAAXCAYAAAD9VOo7AAADIklEQVR4nO3ZS2hdVRSA4e/mYa310VajlapYRQRtFScOfEFFcCIojhw4kIoVrQhSHSmIUwURHPmYqAOhA3HgQBQFURR0YBRRaw0+20SDL6y9sU27HKx9yU1Nbm5ubu4j6Q+bs/c+Z+29DuuctdZZpxIReph78DyOYA/u7K46y89AtxVYgH3lOFzXX9EMdXCvYTyJU8r4CMZxFH/jOZxWrvu1XDNWJ1/fP7vI/1FkLsc2bC3tDBwz+4Hbgc/bdjfLRKWDLmstDjU4/wPW42R8UeZOxaWlvx8Tpb8VU/gdF6LSxP7X4sPFKNwNeskgy01fGKTXY8iqo5MxZBovmYkh09LlrEcVj+Jl6aK2lGtOxyWlP44Dpf89vsIdZuLGFeW4DRvK+p28v7bQSZc1H7fLwAwP4HzsRMjAXM+ADNjP4kc8VebH8NGya9oBumGQs3CXfAtGcLN8E2ocw6fzyA7hyuPmpvC1zNbgHxyuO/+X/xu2Z+mGQZ7GQ53etF/ohI89D7fgGvl0b+zAnt3kM7zaqvB8b8ganItN0q2MlHGtv0m6lYcbrD2IR/AETmpVwT7kE1zdqvBcBhmWQfPeBWRDZjVfznFui8yYrmtVsT7mkExSWopbQ3gFF+McmcGc2aRsBbtx93HzO/CMmcxptVGVHqbainAlIl7HrS1ufhgXybLGCF5osNZv0uBLjVsTeF9+a9yEP+Xb2gtMyZT9jZZXiIhdsTTei4j7I2KiwTVjEXFBRGyOiD0R8VhEbIyIDXXtxYj4ron93owIEbEmIh6PiEoZr4g2hI+X+FTcUNp8jGE7firjD/AOLiv9GuN4V7q8ZvhXJgwrigEzFdTl4FuzjQF7sVkaoEZFftDVl9hXJZWIqAWgZkrYi2EfbsTPc5y7TVZ/p8t4EKO4Dw8usO4ormqHgr1ILe2tyv8Q7eIbaYz9i5S7Xn7jNOIoXmtFqX6gEhHrcLBF+arMt9fVze2Vxjgwp8QJGjKk8XfH27JwN4lfSpssbVwacq0sFu4u6203Oz6cYBHUXNZbss40KaujB+U/h11m/PxCDMp/EaPtVnI18R9vKf2ssOnBPwAAAABJRU5ErkJggg==", 100, 23},
				["SAVE"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAMUSURBVGhD7ZrNitRAFIXTCQ2OiqLiz0YREVy5EXUrCG7FEV34BOJ7uNI3cOfWrW5UBFeCgqvBJxhXA4qC2jRtd3tO5d6ykqkkVbHTpNv54FC3Ur8n9dNhmGRdGEiazOdziZITk8lkQ+ICw+FwezAYzCTbKaPRaCPLspOSLYB5fEdCkTnmZCdPI2ehd1AdR6R650yn0xuz2WyuKvEbegrtk+o5eDCAPkJNHIfsKnYJjNz0GCiA8sdSPUklPQ9dYoByJlWwfoo62i6Ihj53IfWHJlMDttQdCa0Ru2VQKFFOaRIsjF4R9sl+tC83JuUyoXEc1D0koTUSSqtthQH1BXAL85Ebk11laZryEDNfiVuuRmyPTueFWOADHdRssRBJG6UQo7yqLJO0DjtBNVK4UtG5zwTRgdiOA4VKzcSqCUwzfxFqpI+EGLEsy4i7vL6YqUpx40b6siJRb9/Hsoy4E62Lq8oaUSO2Ea80VUdox27qUwh2+6kR78o0mHH3dZMIx6DYaTn1SdvZW9SVYAOvgVWkz0a4KsEs2ohd6gUQ1deijUS9xUWyd0b6xv9pBPf3GQmXwWlJgzCHExO8iuQ94zL88XF+GLehZ1DsX1Jib7Oj0F3osPPjV0DmtAOdQpx/yzcZIR1+slRSZYKUjTRuLTYom+AAPil1ZTHo2D4Jdv4aRG0Vp6MCVZOuqr8AUvRtBly7W6uzV7Ys1m5F2p3GGjo8F15arwgnWie3zjIwo+CmuYLkA+NFgn63YOSzZEO4AJ3LwyC+ov9jEpsBL0OtcP/0X9Z4PL4nQwSB7h7lvQbzRZruXb+dgDd8QMJo9q7fLsDB/SVhNL3aWqD1C+3VivwLa3dG+rK1WqNGtqCXebiaqJExdBt6ZXIriHtGRtAm9NrkVozyYaeZW9Abk+s/PyW1X78mxQ+SuYaR34/kOXSd+TpQV6K/8NOdz/Hh+DDLspjt+gCK+dB8grHuMygYUWgIHET4ArpmHnrwmfBBYx3wFtpE39+YUSNMCPP2Pw7EzEWTKcIGMbMLcxzOD+gTX3ieXRuS5A+l9l54jQJiowAAAABJRU5ErkJggg==", 50, 50},
				["LUA"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADN0AAAzdAb7pMRcAAAPwSURBVGhD7ZpLiBRXFIa7NVFQI0RBR9GQ4BhUBhEfKKJiHiooKAqz0ZUgiAiuFB9L0bWzMJCVa0EQH4wLTUIQA0mMgmbQEB9INMFBFBxf+Gy/v+6py+3pV3WYse5Af/BNnTrV011/9e2qWz1TqEepVNqBj3EweYlb7CX/N0VbVsCTj2NxH4fjC/UGgY9xBL7BdcVi8YyaAwpBpulwwVUsDpK7MaUP59nLN80wW9aFI1UaDHlqmfIJnibM5261OTIF+YBMwm7CfOpWsxNbEDELjxNmpFvNRoxBxHI8QpjM+xdrELERD7iyMTEHEXt4V7ZaXZfYg+g6d5gwa9xqbWIPIj7Co4Spe40ZCkHEGDxFmNFutZK8g/yBj/FlA3XhnIxt2Byk91MUa+WG9sHtSmmatSoYKkOrIa0gsVFxP8I4VG8iTsfz+BeuxDw5izNwGd7AXps9V4cQHdijT1Xk/IkdttsJ/h1hg4ZZD85MGvFzHTt4Z95pJQwylcU/bs3zM2poiTm4yJUVdONdVxYW42xXei7j764s6BS6wpWe13gEw+GyASe4siafESR9XQdB2rE/m22ztu9yraqssofpcYdcq4yDtlnbO12rjJ9ss4del9tUl3Z7eDRnrVP6wY6FJ5+TtsxEVEFgNmG+sPoCPnRlY2II0sM4v231EvxaBT19bjJ/PRRDkPTdELrF/caVCZmHVzRBGFK67/gKV1otdCHM9OVg3kH+Q03lxQIcby5Ug+H1hEXFGa0aAxUkfJ5qU4ewFz62m519a/Uo/N4Mb6AyDa+BCqJvCVN0o9SfPluKsbYU/vNBoB9xm6khlXIa07A1GaggmmCm/GbLkIu2FJr8iafohw2fi7Gh1lZAfZGezgpq0kwQHdU7VdTRCmfHOprhcDiGmuqkF7zVquEHdvK5Cvqatuid9NILJ4XZL478Yt0pSi14zAN8h0utlewwzsIZqq2t/iZMCac/21yrjL22Wdv1PNXwUxSPmm5bGVmDiHvYf7LoYdsafKIHwhv0E0LqE0m3nF9scwLr1127DB8kPFpq6qYl5DhecmVN9mF6lnmFGkrn8F/U9UDPuxa/xfT1HmCXKxP2YHjCEBqy+1F/BBLrcb4rPdMZnjdVhEGmsCifEsfPVILcUxF+2HUEr7hySKB91T4n+CAk00WrE39F3XWFFzHVeZqiWvumfey0fU7wQyuEYaYx/yXqzu4aalaaJ5rS6w9Ac/FvAjxTMxOEaX3TmAetILHRChIbrSCxUfWCKOycrQlZL36nXo5sR/2FoJ2L4a2k0496QdJ/c9K/IsWAvudqI8gjt1pOzaFlv7ATw/vtvNA+7KwVolAoFN4DMgQTmSrqJqYAAAAASUVORK5CYII=", 50, 50},
				["PLAYERS"] = {"iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAS+SURBVGhD7ZpbiFVVGMdnRk3TpCxLLEXzWlpWair1YJkkqEgYpQ0oeAETexCMHjIfJggfRXqRHowgCIOIBG8gmGAUIoxiUYhMBeUlZbzgdXQcf/+1vz3WeM7Z69tntkxwfvBj7bXc37rsy1prn7GuRo0eQEdHRz32VWpF3U5hbVBhH1yO+/AS3rJUeZX3sVNzozqsrmLaoIKx2IyVOIxjLcQNsWOwuDYIHIknVEsEOm+khUajGIuNwd8GAXpOv1e0g/0Y/VzrXCy0DTUyO4T5mW1VZMK5ryUhbkq20WBpV96y1IsnrlvbKDeQZy31MsnSGPK2UTKu3ED6W+ql3VI9Og04HVfh+7gUx9g/i8/xWnLoYoCl2dDgbvTyKw61+EY8rsIuaH3QCz7FzpuJl9HDbsVGwcnrk5hoLuBo1F3YooIMruMSa2txKIlnfehkDJw8HK+GsDjWWtzHSTaKGzjL4raHkmzUp+GKiYaADSE0m7N4P47HNhU4OIbanswIuWw2WPfiIagXfhHCK6OXVudvSrJu5qMWxz9CrjzqS7nJqTIEqoH3UFe9FGcwLFCkR0OJn00Wvy3J3oXaVh8qruhRyz2VPEAyF6fhQ9iKB3FnfX39FWvkHD6IXr6ljoXUoSl/Hr6Ij6DqS9u4RFqRkgOh0kEkb6Ou9jjUQEqd24FraEjT9RmOB4dSH18Tv4j4Tzh+Jyn6D2pDAzmGe1Hna5DlobLeqKn3IsayzmIPJFk3TRa/K8lmor6pj70Vdxf8wyD07kbFdxb/QZJ1MxU1c50LuXjUVz05d6BAn5Z5r+g1HIK6EP+owEFYpUnfTLJu1Oe+YRCCzMZQnJ9PrZ4FeDOUZHMKR6DuxhEV5GRjOohhqKtaDer8HKtPL66+tyuhfdhEO7/ai6i+D9MCswzv3J58aBc7jwobmFG2cfwMfoaaplM0+7TgR/gc5/3C+UM4fgFvYV7U92Va8A5w8HIo8qNt+xZsomNaHDVFj8BRqO22ZhblNX1rej6J6vR5/I2Ys6S6K/qO0cIY9l45+EGVtGIeFPe6aiF9GJuwBWPR43gQ9XOPpn3tnD/EdvTSqk7kCTyPk20Qb6DuRjXo56CnrL53Q4mPdgV60cfRAmt0Nea5EKXQHdb2RPVuDiUO8gzkS2tsDsZOtbGcxKGozwLPY+oeiDquL0E19KcKCuAru1Arkmwc3oHssUb0g0JR6FEdhwMwes/n/VDZaWmjpUWgPi1mar5Muj+UROAdiGYXrQ36LimSlyxttjQT70C0oD2G/UKuONIfGE5YmokGshK/Qa22WVzHarczMaQXqs3Scmjb8yM2dn718cjojylTcQZOx+fxSbwPU7Td6IXaMxVJC++IZkftA7cmRQF1/C88hPtwB+eFvpT81E2hIg1Cf5N4HLXB24GP4r0ayASOdVG1+dQAfqf83xvRTioOpBRUrrt0TwZix1F4X/YeS20gPY08A9GUeCU5LAy92C7cL7vghdfX36uo7/RXULNLtXdX65j2ctpd7+Jl7/yjUQy5BtIVBqbfl/THG32yPo2acZ5A7QIGYjpIfeZexdP4N+rXw5/xJ2ym81kLYFm6ZSCVYJAaRPo/F9rorBa1GjX+H9TV3QbNg/HZu3wRkgAAAABJRU5ErkJggg==", 50, 50},
				["SORTARROW"] = {"iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAU0lEQVQYlX2PUQ7AIAhDi9lxuP/1WB4C0X2sCaZpaVW5+xMRksQxg8ZYmTKDDsc0+ErlB2zt2O6dhkYutPEFi3nFmZhkaasfc9UWx7t+cTZkUNILeVMshrLlQ3UAAAAASUVORK5CYII=", 8, 8},

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

		for k, v in pairs(icons.registry) do
			icons.registry[k][1] = ImageRef.new(syn.crypt.base64.decode(v[1]))
		end
	end)


	function icons:NameToIcon(name)
		return (self.registry[name] and self.registry[name] or nil)
	end
end

-- GUI Objects
do
	local timer = BBOT.timer
	local config = BBOT.config
	local math = BBOT.math
    local hook = BBOT.hook
	local table = BBOT.table
	local color = BBOT.color
	local font = BBOT.font
	local string = BBOT.string
    local draw = BBOT.draw
    local gui = BBOT.gui
	local camera = BBOT.service:GetService("CurrentCamera")
	local userinputservice = BBOT.service:GetService("UserInputService")
	local menu = {}
	BBOT.menu = menu
	local v1, v2, v3 = Vector2.new(1,1), Vector2.new(2,2), Vector2.new(4,4)
	local function default_panel_borders(self, pos, size)
		self.background_border.Offset = pos - v2
		self.background_outline.Offset = pos - v1
		self.background.Offset = pos
		self.background_border.Size = size + v3
		self.background_outline.Size = size + v2
		self.background.Size = size
	end

	local function default_panel_objects(self)

		-- create a rect with a Vector2 based point
		local border = draw:Create("Rect", "2V")
		border.Color = gui:GetColor("Border")
		border.Filled = true
		border.XAlignment = XAlignment.Right
		border.YAlignment = YAlignment.Bottom

		-- Clone from border (only properties not point data)
		local outline = draw:Clone(border)
		outline.Color = gui:GetColor("Outline")

		-- Clone again...
		local background = draw:Clone(border)
		background.Color = gui:GetColor("Background")

		self.background_border = self:Cache(border)
		self.background_outline = self:Cache(outline)
		self.background = self:Cache(background)
	end

	local function default_gradient(self)
		local gradient = draw:Create("Gradient", "2V")
		gradient.XAlignment = XAlignment.Right
		gradient.YAlignment = YAlignment.Bottom

		gradient.ColorUpperLeft = Color3.fromRGB(50,50,50)
		gradient.ColorUpperRight = Color3.fromRGB(50,50,50)
		gradient.ColorBottomLeft = Color3.fromRGB(35,35,35)
		gradient.ColorBottomRight = Color3.fromRGB(35,35,35)

		gradient.OpacityUpperLeft = 1
		gradient.OpacityUpperRight = 1
		gradient.OpacityBottomLeft = 1
		gradient.OpacityBottomRight = 1

		return gradient
	end

	-- Box
	do
		local GUI = {}
		function GUI:Init()
			default_panel_objects(self)
			self:SetMouseInputs(false)
		end
		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
		end
		gui:Register(GUI, "Box")
	end

	-- Mouse
	do
		local GUI = {}

		function GUI:Init()
			if gui.mouse then
				gui.mouse:Remove()
			end
			gui.mouse = self
			self.mouse_mode = "normal"
			self.mouse_controller = draw:CreatePoint("Mouse")
			self:SetupMouse()
			self:SetZIndex(1000000)
			self:SetMouseInputs(false)

			local text = gui:Create("Text", self)
			text:SetPos(1,12,1,45)
			text:SetClipping(false)
			text:SetXAlignment(XAlignment.Right)
			text:SetYAlignment(YAlignment.Bottom)
			text:SetTextSize(16)
			text:SetText("?")
			text:SetOpacity(0)
			self.questionmark = text
		end

		function GUI:SetupMouse()
			local pos = self.absolutepos
			-- cache is a garbage collector for the draw library
			local mouse, mouse_outline

			mouse = draw:Create("PolyLine", "Offset", "Offset", "Offset", "Offset")
			mouse.Color = Color3.fromRGB(127, 72, 163)
			mouse.FillType = PolyLineFillType.ConvexFilled
			for i=1, #mouse.points do
				local point = mouse.points[i]
				point.Point = self.mouse_controller.point
			end

			mouse.Offset1 = Vector2.new(2, 2)
			mouse.Offset2 = Vector2.new(2, 15)
			mouse.Offset3 = Vector2.new(6, 11)
			mouse.Offset4 = Vector2.new(11, 11)

			mouse_outline = draw:Create("PolyLine", "Offset", "Offset", "Offset", "Offset")
			mouse_outline.FillType = PolyLineFillType.Closed
			for i=1, #mouse_outline.points do
				local point = mouse_outline.points[i]
				point.Point = self.mouse_controller.point
			end
			mouse_outline.Color = Color3.new(0,0,0)
			mouse_outline.ZIndex = mouse.ZIndex + 1

			mouse_outline.Offset1 = Vector2.new(1, 1)
			mouse_outline.Offset2 = Vector2.new(1, 16)
			mouse_outline.Offset3 = Vector2.new(6, 11)
			mouse_outline.Offset4 = Vector2.new(11, 11)

			self.mouse = self:Cache(mouse)
			self.mouse_outline = self:Cache(mouse_outline)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.mouse.Color = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.mouse.Color = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
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
				-- none cause of point system... :D
			end
		end

		local mouse = BBOT.service:GetService("Mouse")
		function GUI:Step()
			-- Step is equivilant to RenderStepped
			local ishoverobj = gui:IsHoveringAnObject()
			if ishoverobj ~= self.ishoverobject then
				if ishoverobj then
					self:SetOpacity(1)
				else
					self:SetOpacity(0)
				end
				self.ishoverobject = ishoverobj
			end

			local objecthover = gui.hovering
			if objecthover ~= self.hoveractive and menu.tooltip then
				self.hoveractive = objecthover
				local tip = menu.tooltip
				if objecthover and objecthover.tooltip then
					self.questionmark:SetOpacity(1)
					timer:Create("Cursor.ToolTip.QuestionMark", .5, 1, function()
						if self.hoveractive ~= objecthover then return end
						gui:OpacityTo(self.questionmark, 0, 1, 0, 0.5, function()
							if self.hoveractive ~= objecthover then return end
							tip:SetEnabled(true)
							tip:SetTip(objecthover, objecthover.tooltip)
							gui:OpacityTo(tip, 1, 0.5, 0, 0.25)
						end)
					end)
				else
					timer:Remove("Cursor.ToolTip.QuestionMark")
					self.questionmark:SetOpacity(0)
					gui:OpacityTo(self.questionmark, 0, 0, 0, 0.25)
					gui:OpacityTo(tip, 0, 0.5, 0, 0.25, function()
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

	-- ToolTip
	do
		local GUI = {}
		
		function GUI:Init()
			self:SetMouseInputs(false)
			default_panel_objects(self)

			self.text = gui:Create("Text", self)
			self.text:SetPos(0, 6, .5, -1)
			self.text:SetClipping(false)
			self.text:SetXAlignment(XAlignment.Right)
			self.text:SetYAlignment(YAlignment.Center)
			self.text:SetText(" ")

			self.line = gui:Create("AstheticLine", self)
			self.line:SetPos(0, 1, 0, 1)
			self.line:SetSize(0, 2, 1, -2)
			self.line:SetAlignment("Left")
			
			self:SetOpacity(0)
			self:SetZIndex(900000)
			self.content = "LOL"
		end

		function GUI:SetTip(parent, text)
			local x, y = parent.absolutepos.X, parent.absolutepos.Y + parent.absolutesize.Y + 4
			local w = math.max(200, parent.absolutesize.X)
			self.content = text
			self.text:SetText(text)
			self.scalex, self.scaley = self.text:GetTextSize()
			if self.scalex > 200 then
				self.text:SetText(table.concat(string.WrapText(self.content, self.text.text.Font, self.text.text.Size, w), "\n"))
			end
			self.scalex, self.scaley = self.text:GetTextSize()
			self:SetSize(0, self.scalex+4, 0, self.scaley+4)
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
			self.background.Offset = pos + Vector2.new(1, 1)
			self.background.Size = size - Vector2.new(2, 2)
			self.background_outline.Offset = pos
			self.background_outline.Size = size
			self.background_border.Offset = pos - Vector2.new(1, 1)
			self.background_border.Size = size + Vector2.new(2, 2)
		end

		gui:Register(GUI, "ToolTip")
	end

	-- Container
	do
		local GUI = {}
		function GUI:Init()
			self:SetMouseInputs(false)
		end
		function GUI:PerformLayout(pos, size)
		end
		gui:Register(GUI, "Container")
	end

	-- AstheticLine
	do
		local GUI = {}

		function GUI:Init()
			local background_outline = draw:Create("Rect", "2V")
			background_outline.Color = gui:GetColor("Outline")
			background_outline.Filled = true
			background_outline.XAlignment = XAlignment.Right
			background_outline.YAlignment = YAlignment.Bottom
			self.background_outline = self:Cache(background_outline)
	
			local asthetic_line = draw:Clone(background_outline)
			asthetic_line.Color = gui:GetColor("Accent")
			self.asthetic_line = self:Cache(asthetic_line)

			local hue, saturation, darkness = Color3.toHSV(gui:GetColor("Accent"))
			darkness = darkness / 2

			local asthetic_line_dark = draw:Clone(background_outline)
			asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)
			self.asthetic_line_dark = self:Cache(asthetic_line_dark)

			self:SetMouseInputs(false)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				self:SetColor(config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent"))
			end

			hook:Add("OnAccentChanged", "Menu.AstheticLine" .. self.uid, function(col, alpha)
				self.asthetic_line.Color = col
				local hue, saturation, darkness = Color3.toHSV(col)
				darkness = darkness / 2
				self.asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)
			end)

			self.alignment = "Top"
		end

		function GUI:SetAlignment(align)
			self.alignment = align
		end

		function GUI:SetColor(col)
			self.asthetic_line.Color = col
			local hue, saturation, darkness = Color3.toHSV(col)
			darkness = darkness / 2
			self.asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu.AstheticLine" .. self.uid)
		end

		function GUI:PerformLayout(pos, size)
			self.asthetic_line.Offset = pos
			self.asthetic_line.Size = size
			local align = self.alignment
			if align == "Left" then
				self.asthetic_line_dark.Offset = pos + Vector2.new(size.X/2, 0)
				self.asthetic_line_dark.Size = Vector2.new(size.X/2, size.Y)
			else
				self.asthetic_line_dark.Offset = pos + Vector2.new(0, size.Y/2)
				self.asthetic_line_dark.Size = Vector2.new(size.X, size.Y/2)
			end
			self.background_outline.Offset = pos - Vector2.new(1,1)
			self.background_outline.Size = size + Vector2.new(2,2)
		end

		gui:Register(GUI, "AstheticLine")
	end

    -- Panel
	do
		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)

			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient) -- 1

			self.asthetic_line = gui:Create("AstheticLine", self)
			self.asthetic_line:SetSize(1, 0, 0, 2)

			self.draggable = false
			self.sizable = false
			self:SetMouseInputs(true)
			self.autofocus = false

			self:Calculate()
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.gradient.Offset = pos + Vector2.new(-1,2)
			self.gradient.Size = Vector2.new(size.X+1, math.min(20, size.Y - 3))
		end

		function GUI:SetSizable(bool)
			self.sizable = bool
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

	-- Text
	do
		local GUI = {}

		function GUI:Init()
			local text = draw:Create("Text", "2V")
			text.Color = Color3.fromRGB(255,255,255)
			text.Outlined = true
			text.OutlineColor = Color3.fromRGB(0,0,0)
			text.OutlineThickness = 1
			text.TextXAlignment = XAlignment.Left
			self.text = self:Cache(text)
			self.font = font:GetDefault()
			self.textsize = 16

			text.Font = font:GetFont(self.font)
			text.Size = self.textsize

			self.content = ""
			self.fontmanager = nil
			self.offset = Vector2.new(0, 0)
			self.clipping = true
			self.clipping_offset = 0
			self.internal_offset = Vector2.new()

			self:SetXAlignment(XAlignment.Right)
			self:SetYAlignment(YAlignment.Bottom)
			self:SetTextXAlignment(XAlignment.Left)
			self:SetTextYAlignment(YAlignment.Top)
			self:SetFontManager("Menu.BodyMedium")
			self.mouseinputs = false
		end

		function GUI:SetClipping(clipping)
			self.clipping = clipping
		end

		function GUI:SetXAlignment(align)
			self.text.XAlignment = align
			self:ProcessClipping()
		end

		function GUI:SetYAlignment(align)
			self.text.YAlignment = align
			self:ProcessClipping()
		end

		function GUI:SetTextXAlignment(align)
			self.text.TextXAlignment = align
			self.TextXAlignment = align
		end

		function GUI:SetTextYAlignment(align)
			self.TextYAlignment = align
		end

		function GUI:SetFont(font)
			if self.fontmanager then return end
			self.text.Font = font
			self.font = font
			self:ProcessClipping()
		end

		function GUI:SetTextSize(size)
			if self.fontmanager then return end
			self.text.Size = size + 1
			self.textsize = size
			self:ProcessClipping()
		end

		function GUI:OnFontChanged(old, new)
			self:ProcessClipping()
		end

		function GUI:OnFontSizeChanged(old, new)
			self:ProcessClipping()
		end

		function GUI:SetFontManager(manager)
			font:RemoveFromManager(self.text, self.fontmanager)
			font:RemoveFromManager(self, manager)
			if manager then
				font:AddToManager(self.text, manager)
				font:AddToManager(self, manager)
			end
			self.fontmanager = manager
			self:ProcessClipping()
		end

		function GUI:GetText()
			return self.content or ""
		end

		function GUI:SetColor(col)
			self.text.Color = col
		end

		function GUI:SetText(txt)
			self.text.Text = txt
			self.content = txt
			self:ProcessClipping()
		end

		function GUI:GetOffsets()
			local offset_x, offset_y = 0, 0
			local w, h = self:GetTextSize()

			local size = self.absolutesize
			if self.parent and size.X <= 2 then
				size = self.parent.absolutesize
			end

			local extra = self:GetTextScale()
			if self.text.XAlignment == XAlignment.Center then
				offset_x = - (w/2) - (extra/2)
			elseif self.text.XAlignment == XAlignment.Left then
				offset_x = - w - (extra/2)
			elseif self.text.XAlignment == XAlignment.Right then
				offset_x = 0
			end

			if self.text.YAlignment == YAlignment.Center then
				offset_y = -h/2
			elseif self.text.YAlignment == YAlignment.Top then
				offset_y = -h
			end

			self.offset = Vector2.new(offset_x, offset_y)

			offset_x, offset_y = 0, 0

			if self.TextXAlignment == XAlignment.Center then
				offset_x = (size.X/2) - (w/2)
			elseif self.TextXAlignment == XAlignment.Left then
				offset_x = 0
			elseif self.TextXAlignment == XAlignment.Right then
				offset_x = size.X - w
			end

			if self.TextYAlignment == YAlignment.Center then
				offset_y = (size.Y/2) - (h/2)
			elseif self.TextYAlignment == YAlignment.Top then
				offset_y = 0
			elseif self.TextYAlignment == YAlignment.Bottom then
				offset_y = size.Y - h
			end

			self.internal_offset = Vector2.new(offset_x, offset_y)
		end

		function GUI:OnEnabledChanged()
			self:ProcessClipping()
		end

		function GUI:PerformLayout(pos, size, poschanged, sizechanged)
			self:ProcessPosition()
			if not sizechanged then return end
			self:ProcessClipping()
		end

		function GUI:ProcessPosition()
			local clipping_offset = self.clipping_offset
			if self.text.XAlignment == XAlignment.Center then
				clipping_offset = 0
			elseif self.text.XAlignment == XAlignment.Left then
				clipping_offset = -clipping_offset
			elseif self.text.XAlignment == XAlignment.Right then
				clipping_offset = clipping_offset
			end
			self.text.Offset = self.absolutepos + Vector2.new(clipping_offset, 0) + self.internal_offset
		end

		function GUI:ProcessClipping()
			local text = self.content
			local cursize = self.absolutesize
			local useparent = cursize.X <= 2
			local clipping_offset = 0
			if self.content and (self.parent or not useparent) and self.clipping then
				self:GetOffsets()
				local x = self:GetTextSize(self.content)
				local localpos = self:GetLocalTranslation()
				local psize = (useparent and self.parent.absolutesize or cursize)
				local posx = (useparent and localpos.X + self.offset.X or self.offset.X) + self.internal_offset.X
				text = ""
				local pretext = ""
				for i=1, #self.content do
					local v = string.sub(self.content, i, i)
					local incsize = self:GetTextSize(v)
					pretext = pretext .. v
					local prex = self:GetTextSize(pretext .. " ")
					if prex + posx - 4 < psize.X then
						if prex + posx - 12 < 0 then
							clipping_offset = clipping_offset + incsize
						else
							text = text .. v
						end
					end
				end
			end
			self.clipping_offset = clipping_offset
			self:ProcessPosition()
			self.text.Text = text
		end

		function GUI:ParentPerformLayout(ppos, psize, poschanged, sizechanged)
			if not sizechanged then return end
			self:ProcessClipping()
		end

		function GUI:GetTextSize(text)
			text = text or self.content
			local font_data, size
			if self.fontmanager then
				font_data, size = font:Get(self.fontmanager)
			else
				font_data, size = font:GetFont(self.font), self.text.Size
			end
			if not font_data then
				return 0, 0
			end
			local vec = font_data:GetTextBounds(size, text)
			return vec.X, vec.Y
		end

		function GUI:GetTextScale()
			local font_data, size
			if self.fontmanager then
				font_data, size = font:Get(self.fontmanager)
			else
				font_data, size = font:GetFont(self.font), self.text.Size
			end
			if not font_data then
				return 0, 0
			end
			local vec = font_data:GetTextBounds(size, "A")
			return vec.X, vec.Y
		end

		gui:Register(GUI, "Text")
	end

	-- ScrollPanel
	do
		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background.Color = gui:GetColor("Accent")
			
			self.color = gui:GetColor("Accent")
			self:SetMouseInputs(true)
			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.color = col
				self.background.Color = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.color = col
				self.background.Color = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
		end

		function GUI:Scrolled()
			local canvas_size = self.parent:GetTall()
			local scroll_position = self.parent:GetTall(self.parent.Y_scroll-1)
			self.heightRatio = self.parent.absolutesize.Y / canvas_size
			self.height = math.max(math.ceil(self.heightRatio * self.parent.absolutesize.Y), 20)

			if self.height/self.parent.absolutesize.Y > 1 then
				self:SetEnabled(false)
			else
				self:SetEnabled(true)
			end

			self:SetSize(0, self.size.X.Offset, self.height/self.parent.absolutesize.Y, -6)
			if (scroll_position/canvas_size) + (self.height/self.parent.absolutesize.Y) > 1 then
				self:SetPos(1, -self.size.X.Offset-1, 1-(self.height/self.parent.absolutesize.Y), 4)
			else
				self:SetPos(1, -self.size.X.Offset-1, scroll_position/canvas_size, 4)
			end
		end

		gui:Register(GUI, "ScrollBar")

		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)

			self.scrollbar = gui:Create("ScrollBar", self)
			self.scrollbar:SetSize(0,2,0,1)
			self.scrollbar:SetPos(1,-2,0,0)
			self.scrollbar:SetZIndex(10)

			self.canvas = gui:Create("Container", self)
			self.canvas:SetSize(1,0,1,0)

			self.Y_scroll = 0 -- for now this is by object
			self.Y_scroll_delta = 0
			self.Spacing = 2
			self.Padding = 0
			self.lastsize = Vector2.new(0,0)
		end

		function GUI:SetPadding(num) -- Padding is the idents around the panels
			self.Padding = num
			self:PerformOrganization()
		end

		function GUI:SetSpacing(num) -- The spacing in-between panels
			self.Spacing = num
			self:PerformOrganization()
		end

		function GUI:ScrollBarMargin(bool)
			self.scrollbarmargin = bool
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			if size ~= self.lastsize then
				self.lastsize = size
				self:PerformOrganization()
			end
		end

		function GUI:GetCanvas()
			return self.canvas
		end

		function GUI:GetTall(max)
			local children = self.canvas.children
			local max_childs = #children
			max = max or max_childs
			max = math.min(max, max_childs)
			local remainder = max % 1
			local tosearch = max
			if remainder < .5 then tosearch = tosearch + .5 end
			tosearch = math.round(tosearch)
			local y_axis, count, count_children = 0, 0, 0
			while count < tosearch and count_children < max_childs do
				count_children = count_children + 1
				local v = children[count_children]
				if not gui:IsValid(v) then continue end
				if not v:GetVisible() then continue end
				count = count + 1
				local spacing = v.absolutesize.Y + self.Spacing
				if count == tosearch and remainder ~= 0 and remainder ~= 1 then
					spacing = spacing * remainder
				end
				y_axis = y_axis + spacing
			end
			return y_axis
		end

		function GUI:PerformOrganization()
			local max_h = self.absolutesize.Y
			local children = self.canvas.children
			if #children < 1 then return end
			local y_axis = 0

			local count, onpage = 0, 0
			local c = 0
			for i=1, #children do
				local v = children[i]
				if not gui:IsValid(v) then c=c+1 continue end
				if not v:GetVisible() then c=c+1 continue end
				i = i - c
				count = count + 1

				local sizeY = v.absolutesize.Y
				if i >= self.Y_scroll then
					if y_axis + sizeY + self.Spacing <= max_h then
						onpage = onpage + 1
					end
					y_axis = y_axis + sizeY + self.Spacing
				end
			end

			if self.Y_scroll > count-onpage then
				self.Y_scroll = math.max(0, count-onpage)
				self.Y_scroll_delta = self.Y_scroll
			end

			if self.Y_scroll > count then
				self.Y_scroll = 0
			end

			y_axis = 0
			c = 0

			for i=1, #children do
				local v = children[i]
				if not gui:IsValid(v) then c=c+1 continue end
				local enabled = v:GetEnabled()
				if not v:GetVisible() then
					c=c+1
					if enabled then
						v:SetEnabled(false)
					end
					continue
				end
				i=i-c
				local sizeY = v.absolutesize.Y

				if i <= self.Y_scroll then
					if enabled then
						v:SetPos(0, self.Padding+2, 0, -sizeY-4)
						v:SetEnabled(false)
					end
				else
					if y_axis + sizeY + self.Spacing > max_h then
						if enabled then
							v:SetEnabled(false)
						end
					else
						if not enabled then
							v:SetEnabled(true)
						end
						v:SetPos(0, self.Padding+2, 0, y_axis + self.Spacing)
					end
					y_axis = y_axis + sizeY + self.Spacing
				end

				if enabled then
					v:SetSize(1, -4-self.Padding*2, 0, sizeY)
				end
			end

			self.scrollbar:Scrolled()

			if self.scrollbarmargin and self.scrollbar:GetEnabled() then
				self.canvas:SetSize(1,-6,1,0)
			else
				self.canvas:SetSize(1,0,1,0)
			end

			self:OnPerformOrganization()

			--self:InvalidateLayout(true, true)
		end

		function GUI:IsAtStart(index)
			return index-1 <= self.Y_scroll
		end

		function GUI:IsAtEnd(index)
			local children = self.canvas.children
			local object = children[index]
			if not object or object.__INVALID then return false end
			local max_h = self.absolutesize.Y
			local lsize = object.absolutesize.Y
			local lpos = object:GetLocalTranslation().Y
			if (lpos + lsize < max_h) and (lpos + lsize*2 > max_h) then
				return true
			end
		end

		function GUI:OnPerformOrganization()

		end

		function GUI:WheelForward()
			if not gui:IsHovering(self) then return end
			self.Y_scroll = math.max(0, self.Y_scroll - 1)
			self:PerformOrganization()
		end

		function GUI:WheelBackward()
			if not gui:IsHovering(self) then return end
			self.Y_scroll = math.min(#self.canvas.children, self.Y_scroll + 1)
			self:PerformOrganization()
		end

		function GUI:Add(object) -- Add GUI objects here to add to the canvas
			object:SetParent(self.canvas)
		end

		gui:Register(GUI, "ScrollPanel")
	end

	-- Sliding Text
	do
		local GUI = {}

		function GUI:Step()
			local w, h = self:GetTextSize()
			local size = self.absolutesize
			if self.parent and size.X <= 2 then
				size = self.parent.absolutesize
			end
			if w + 2 > size.X then
				self:ProcessClipping()
			end
		end

		function GUI:GetOffsets()
			self.super.GetOffsets(self)
			local w, h = self:GetTextSize()
			local size = self.absolutesize
			local object = self
			if self.parent and size.X <= 2 then
				size = self.parent.absolutesize
				object = self.parent
			end

			local sweep = 0
			local wide = size.X
			if wide < w and object:IsAbsoluteHovering() then
				local speed = math.max((w - wide)/50, 1.5)
				sweep = (math.sin(tick() / speed) * (5 + (w - wide)/2))
				if self.text.XAlignment == XAlignment.Left then
					sweep = sweep + ((w-wide)/2) + 4
				elseif self.text.XAlignment == XAlignment.Right then
					sweep = sweep - ((w-wide)/2) - 4
				end
				self.offset = Vector2.new(sweep, self.offset.Y)
			end
			self.sweep = sweep
		end

		function GUI:ProcessPosition()
			self.super.ProcessPosition(self)
			self.text.Offset = self.text.Offset + Vector2.new(self.sweep or 0, 0)
		end

		gui:Register(GUI, "SlidingText", "Text")
	end

	-- Text Entry
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
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")

			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient)

			self.whitelist = {}
			for i=string.byte('A'), string.byte('Z') do
				self.whitelist[string.char(i)] = true
			end
			for k, v in pairs(keyNames) do
				self.whitelist[k] = v
			end

			local text = draw:Create("Text", "2V")
			text.Color = Color3.fromRGB(255,255,255)
			text.ZIndex = 2
			text.Outlined = true
			text.XAlignment = XAlignment.Right
			text.YAlignment = YAlignment.Bottom
			text.TextXAlignment = XAlignment.Left
			text.OutlineColor = Color3.fromRGB(0,0,0)
			text.OutlineThickness = 2
			self.text = self:Cache(text)
			self.font = font:GetDefault()
			self.textsize = 16

			text.Font = font:GetFont(self.font)
			text.Size = self.textsize

			self.content = ""
			self.content_position = 1 -- I like scrolling text
			self.fontmanager = nil
			self.offset = Vector2.new(0, 0)
			self.clipping = true

			local cursor = draw:Create("Rect", "2V")
			cursor.Color = gui:GetColor("Border")
			cursor.Visible = false
			cursor.Filled = true
			cursor.XAlignment = XAlignment.Right
			cursor.YAlignment = YAlignment.Center
			cursor.Color = Color3.fromRGB(127, 72, 163)
			cursor.ZIndex = 4

			local cursor_outline = draw:Clone(cursor)
			cursor_outline.Color = Color3.new(0,0,0)
			cursor_outline.ZIndex = 3

			self.cursor = self:Cache(cursor)
			self.cursor_outline = self:Cache(cursor_outline)


			self.editable = true
			self.highlightable = true
			self.mouseinputs = true
			self.placeholder = ""

			self.input_repeater_start = 0
			self.input_repeater_key = nil
			self.input_repeater_delay = 0
			self.texthighlight = Color3.fromRGB(127, 72, 163)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.texthighlight = col
				self.cursor.Color = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.texthighlight = col
				self.cursor.Color = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:SetPlaceholder(text)
			self.placeholder = text
			if self:GetText() == "" and not self.editing then
				self.text.Text = self.placeholder
			end
		end

		function GUI:SetTextSize(size)
			self.textsize = size
			self.text.Size = size
			self.cursor.Size = Vector2.new(1, size)
		end

		local mouse = BBOT.service:GetService("Mouse")
		function GUI:ProcessClipping()
			if self:GetText() == "" and not self.editing then
				self.text.Text = self.placeholder
			else
				self.text.Text = self:AutoTruncate()
			end
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

		function GUI:PerformLayout(pos, size, poschanged, sizechanged)
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = size + Vector2.new(1, 1)
			local w, h = self:GetTextSize(self.content)
			self.text.Offset = Vector2.new(pos.X+3,pos.Y - (h/2) + (size.Y/2))
			self.cursor.Size = Vector2.new(0,size.Y-4)
			self.cursor_outline.Size = Vector2.new(2,size.Y-2)
			default_panel_borders(self, pos, size)
			if sizechanged then
				self:ProcessClipping()
			end
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
				self.cursor.Visible = false
				self.cursor_outline.Visible = false
				self:Cache(self.cursor)
				self:Cache(self.cursor_outline)
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
			local w = self:GetTextScale() -- this is wrong lel...
			return math.round((self.absolutesize.X-18)/w)
		end

		function GUI:InputBegan(input)
			if not self.editable or not self._enabled then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
				self.editing = true
				self.cursor.Visible = true
				self.cursor_outline.Visible = true
				self:Cache(self.cursor)
				self:Cache(self.cursor_outline)
				self.text.Color = self.texthighlight
				self.cursor_position = self:DetermineTextCursorPosition(mouse.X - self.absolutepos.X)
				self:ProcessClipping()
			elseif self.editing then
				if input.UserInputType == Enum.UserInputType.MouseButton1 and (not self:IsHovering() or (input.UserInputType == Enum.UserInputType.Keyboard and input.UserInputType == Enum.KeyCode.Return)) then
					self.editing = nil
					self.text.Color = Color3.fromRGB(255, 255, 255)
					self.cursor.Visible = false
					self.cursor_outline.Visible = false
					self:Cache(self.cursor)
					self:Cache(self.cursor_outline)
					if self:GetText() == "" then
						self.text.Text = self.placeholder
					end
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
							self:OnValueChanged(new_text)
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
				local text_viewable = string.sub(self.text.Text, 1, (self.cursor_position-(self.content_position-1)))
				local wscale, hscale = self:GetTextSize(text_viewable)
				self.cursor.Opacity = math.sin(t * 8)
				self.cursor_outline.Opacity = self.cursor.Opacity
				self.cursor.Offset = self.absolutepos + Vector2.new(wscale+6, (self.absolutesize.Y)/2)
				self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1,0)
				self:Cache(self.cursor)
				self:Cache(self.cursor_outline)
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
								self:OnValueChanged(new_text)
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

	-- Drop Box
	do
		local GUI = {}

		function GUI:Init()
			self.super.Init(self)
			self.mouseinputs = true
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
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")

			self.scrollpanel = gui:Create("ScrollPanel", self)
			self.scrollpanel:SetPadding(3)
			self.scrollpanel:SetSpacing(2)
			self.scrollpanel:SetSize(1,0,1,0)
			self.scrollpanel:SetLocalVisible(false)

			self.options = {}
			self.buttons = {}
			self.max_length = 8
			self.Id = 0
			self.selectcolor = Color3.fromRGB(127, 72, 163)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.selectcolor = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.selectcolor = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
		end

		function GUI:SetOptions(options)
			for i=1, #self.buttons do
				local v = self.buttons[i]
				v:Remove()
			end
			self.options = options
			for i=1, #options do
				local v = options[i]
				local button = gui:Create("TextButton")
				self.buttons[#self.buttons+1] = button
				local _, scaley = button:GetTextSize(v)
				button:SetPos(0, 0, 0, 0)
				button:SetSize(1, 0, 0, scaley)
				button:SetText(v)
				function button.OnClick()
					self.parent:SetOption(i)
					self.parent:OnValueChanged(v)
					self.parent:Close()
				end
				self.scrollpanel:Add(button)
			end

			self:SetSize(1, 0, 0, self.scrollpanel:GetTall(8) + 5)
			self.scrollpanel:PerformOrganization()
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
			button:SetColor(self.selectcolor)
		end

		gui:Register(GUI, "DropBoxSelection")

		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")

			local gradient = default_gradient(self)
			gradient.Size = Vector2.new(0,10)
			self.gradient = self:Cache(gradient)

			local text = gui:Create("SlidingText", self)
			self.text = text
			text:SetPos(0, 4, .5, 0)
			text:SetSize(1, 0, 1, 0)
			text:SetXAlignment(XAlignment.Right)
			text:SetYAlignment(YAlignment.Center)
			text:SetText("")

			local dropicon = gui:Create("Text", self)
			self.dropicon = dropicon
			dropicon:SetPos(1, -10, .5, 0)
			dropicon:SetXAlignment(XAlignment.Center)
			dropicon:SetYAlignment(YAlignment.Center)
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
			if self.Id == 0 then return end
			for i=1, #self.options do
				if self.options[i] == self.option then
					self:SetOption(i)
					break
				end
			end
		end

		function GUI:PerformLayout(pos, size)
			self.gradient.Offset = pos + Vector2.new(-1, -1)
			self.gradient.Size = size + Vector2.new(1, 1)
			default_panel_borders(self, pos, size)
		end

		function GUI:OnValueChanged(i) end
		function GUI:OnOpen() end
		function GUI:OnClose() end

		function GUI:Open()
			if self.selection then
				self.selection:Remove()
				self.selection = nil
			end
			self:OnOpen()
			local box = gui:Create("DropBoxSelection", self)
			self.selection = box
			box:SetPos(0,0,1,2)
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
			self:OnClose()
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

	-- Combo Box
	do 
		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")

			self.scrollpanel = gui:Create("ScrollPanel", self)
			self.scrollpanel:SetPadding(3)
			self.scrollpanel:SetSpacing(2)
			self.scrollpanel:SetSize(1,0,1,0)
			self.scrollpanel:SetLocalVisible(false)

			self.options = {}
			self.buttons = {}
			self.Id = 0
			self.selectcolor = Color3.fromRGB(127, 72, 163)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.selectcolor = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.selectcolor = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
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
				local _, scaley = button:GetTextSize(v[1])
				button:SetPos(0, 0, 0, 0)
				button:SetSize(1, 0, 0, scaley)
				button:SetText(v[1])
				button:SetColor(v[2] and self.selectcolor or Color3.new(1,1,1))
				function button.OnClick()
					self.parent:SetOption(i, not v[2])
					button:SetColor(v[2] and self.selectcolor or Color3.new(1,1,1))
				end
				self.scrollpanel:Add(button)
			end
			self:SetSize(1, 0, 0, self.scrollpanel:GetTall(8) + 5)
			self.scrollpanel:PerformOrganization()
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
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")
			local gradient = default_gradient(self)
			gradient.Size = Vector2.new(0,10)
			self.gradient = self:Cache(gradient)

			self.textcontainer = gui:Create("Container", self)

			local text = gui:Create("SlidingText", self.textcontainer)
			self.text = text
			text:SetPos(0, 4, .5, 0)
			text:SetSize(1, 0, 1, 0)
			text:SetXAlignment(XAlignment.Right)
			text:SetYAlignment(YAlignment.Center)
			text:SetText("")

			local dropicon = gui:Create("Text", self)
			self.dropicon = dropicon
			dropicon:SetPos(1, -2, .5, 0)
			dropicon:SetClipping(false)
			dropicon:SetXAlignment(XAlignment.Left)
			dropicon:SetYAlignment(YAlignment.Center)
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
			self:OnValueChanged(self.options)
			self:Refresh()
		end

		function GUI:SetOptions(options)
			self.options = table.deepcopy(options)
			self:Refresh()
		end

		function GUI:SetValue(options)
			self:SetOptions(options)
		end

		function GUI:PerformLayout(pos, size)
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = Vector2.new(size.X+1, 11)
			default_panel_borders(self, pos, size)
		end

		function GUI:OnValueChanged() end
		function GUI:OnOpen() end
		function GUI:OnClose() end

		function GUI:Open()
			if self.selection then
				self.selection:Remove()
				self.selection = nil
			end
			self:OnOpen()
			local box = gui:Create("ComboBoxSelection", self)
			self.selection = box
			box:SetPos(0,0,1,2)
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
			self:OnClose()
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

	-- Image
	do
		local GUI = {}
		local icons = BBOT.icons

		function GUI:Init()
			local image = draw:Create("Image", "2V")
			image.XAlignment = XAlignment.Right
			image.YAlignment = YAlignment.Bottom
			self.image = self:Cache(image)
			self.image_dimensions = Vector2.new(50,50)
			self.image_scale = 1
			self.mouseinputs = false
		end

		function GUI:SetImage(img)
			self.image.Image = img
			self:InvalidateLayout()
		end

		function GUI:SetImageSize(x, y)
			self.image.ImageSize = Vector2.new(x, y)
			self.image_dimensions = Vector2.new(x, y)
			self:InvalidateLayout()
		end

		function GUI:PreserveDimensions(bool)
			self.preservedim = bool
			self:InvalidateLayout()
		end

		function GUI:SetRounding(rounding)
			self.image.Rounding = rounding
			self:InvalidateLayout()
		end

		function GUI:SetIcon(icon)
			local ico = icons:NameToIcon(icon)
			if not ico then return end
			self:SetImage(ico[1])
			self.image_dimensions = self.image.ImageSize
			self:InvalidateLayout()
		end

		function GUI:ScaleToFit(bool)
			self.scaletofit = bool
			self:InvalidateLayout()
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
					self.image.Offset = pos - (self.image.Size/2) + size/2
				else
					self.image.Offset = pos
					self.image.Size = size * self.image_scale
				end
			end
		end

		gui:Register(GUI, "Image")
	end

	-- Tabs
	do
		local GUI = {}

		function GUI:Init()
			self:SetMouseInputs(true)
			default_panel_objects(self)
			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient)

			self.text = gui:Create("Text", self)
			self.text:SetPos(.5, -2, .5, 0)
			self.text:SetClipping(false)
			self.text:SetXAlignment(XAlignment.Center)
			self.text:SetYAlignment(YAlignment.Center)
			self.text:SetText("")
			self.text:SetTextSize(13)

			local s = self
			function self.text:OnFontChanged(old, new)
				self:InvalidateLayout()
				s.controller:CalculateTabs()
			end

			local darken = gui:Create("Container", self)
			darken:SetPos(0,0,0,0)
			darken:SetSize(1,0,1,2)
			darken.background = draw:Create("Rect", "2V")
			function darken:PerformLayout(pos, size)
				self.background.Offset = pos
				self.background.Size = size
			end
			darken.background.Filled = true
			darken.background.Visible = true
			darken.background.Opacity = 1
			darken.background.ZIndex = 0
			darken.background.Color = Color3.new(0,0,0)
			darken.background.XAlignment = XAlignment.Right
			darken.background.YAlignment = YAlignment.Bottom
			darken:Cache(darken.background)
			darken:SetOpacity(.25)
			self.darken = darken
		end

		function GUI:PerformLayout(pos, size)
			self.background_border.Offset = pos - Vector2.new(2,2)
			self.background_outline.Offset = pos - Vector2.new(1,1)
			self.background.Offset = pos
			self.background_border.Size = size + Vector2.new(4,4)
			self.background_outline.Size = size + Vector2.new(2,2)
			if self.parent and self.parent.borderless then
				self.background.Size = size
			else
				self.background.Size = size + (self.activated and Vector2.new(0,4) or Vector2.new())
			end
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = Vector2.new(size.X+1, 21)
		end

		-- :Cache(object, opacity, outlineopacity, zindex, visible)

		function GUI:SetBorderless(bool)
			self.borderless = bool
			if bool then
				self.darken:SetOpacity(0)
				if self.activated then
					if self.icon then
						self.icon:SetOpacity(1)
					else
						self.text:SetOpacity(1)
					end
				else
					if self.icon then
						self.icon:SetOpacity(.5)
					else
						self.text:SetOpacity(.5)
					end
				end
				self.background_border.Visible = false
				self:Cache(self.background_border, 1, 1, 0, false)
				self.background_outline.Visible = false
				self:Cache(self.background_outline, 1, 1, 0, false)
				self.background.Visible = false
				self:Cache(self.background, 1, 1, 0, false)
				self.gradient.Visible = false
				self:Cache(self.gradient, 1, 1, 0, false)
			else
				if self.icon then
					self.icon:SetOpacity(1)
				else
					self.text:SetOpacity(1)
				end
				if self.activated then
					self.darken:SetOpacity(0)
				else
					self.darken:SetOpacity(.25)
				end
				self.background_border.Visible = true
				self:Cache(self.background_border, 1, 1, 0, true)
				self.background_outline.Visible = true
				self:Cache(self.background_outline, 1, 1, 0, true)
				self.background.Visible = true
				self:Cache(self.background, 1, 1, 0, true)
				self.gradient.Visible = true
				self:Cache(self.gradient, 1, 1, 0, true)
			end
		end

		function GUI:SetActive(value)
			self.activated = value
			if self.borderless then
				if self.icon then
					gui:OpacityTo(self.icon, (value and 1 or .5), 0.2, 0, 0.25)
				else
					gui:OpacityTo(self.text, (value and 1 or .5), 0.2, 0, 0.25)
				end
			else
				gui:OpacityTo(self.darken, (value and 0 or .25), 0.2, 0, 0.25)
			end
			self:InvalidateLayout()
		end

		function GUI:SetIcon(icon)
			if not icon then return end
			if not self.icon then
				self.icon = gui:Create("Image", self)
				self.icon:SetZIndex(0)
				self.icon:SetSize(1, 0, 1, 0)
				self.text:SetOpacity(0)
			end
			self.icon:PreserveDimensions(true)
			self.icon:ScaleToFit(true)
			self.icon:SetScale(0.75)
			self.icon:SetIcon(icon)
			self.icon_perfered = self.icon.image.Size
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
			default_panel_objects(self)

			local container = gui:Create("Container", self)
			container:SetPos(0,8,0,36+8)
			container:SetSize(1,-16,1,-36-16)
			self.top_margin = 36
			self.container = container

			local tablist = gui:Create("Container", self)
			tablist:SetPos(0,0,0,2)
			tablist:SetSize(1,0,0,36-2)

			local gradient = default_gradient(tablist)
			gradient.Visible = false
			tablist.gradient = tablist:Cache(gradient)

			function tablist:PerformLayout(pos, size)
				self.gradient.Offset = pos + Vector2.new(-1,-1)
				self.gradient.Size = Vector2.new(size.X+1, 21)
			end
			
			self.tablist = tablist

			local background = gui:Create("Container", tablist)
			background:SetPos(0,0,0,0)
			background:SetSize(1,0,1,-1)
			background:SetZIndex(0)
			background.background = draw:Create("Rect", "2V")
			function background:PerformLayout(pos, size)
				self.background.Offset = pos
				self.background.Size = size
			end
			background.background.Filled = true
			background.background.Visible = true
			background.background.Opacity = .25
			background.background.ZIndex = 0
			background.background.XAlignment = XAlignment.Right
			background.background.YAlignment = YAlignment.Bottom
			background.background.Color = Color3.new(0,0,0)
			background:Cache(background.background)

			local line = gui:Create("Container", tablist)
			line:SetPos(0,0,1,-1)
			line:SetSize(1,0,0,1)
			line.background = draw:Create("Rect", "2V")
			function line:PerformLayout(pos, size)
				self.background.Offset = pos
				self.background.Size = size
			end
			line.background.Filled = true
			line.background.Visible = true
			line.background.Color = gui:GetColor("Border")
			line.background.Opacity = 1
			line.background.ZIndex = 0
			line.background.XAlignment = XAlignment.Right
			line.background.YAlignment = YAlignment.Bottom
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
			self.top_margin = margin
			self.container:SetPos(0,8,0,margin+8)
			self.container:SetSize(1,-16,1,-margin-16)
			self.tablist:SetPos(0,0,0,2)
			self.tablist:SetSize(1,0,0,margin-2)
		end
	
		function GUI:PerformLayout(pos, size, poschanged, sizechanged)
			if self.borderless then
				self.background_border.Offset = pos - Vector2.new(2,2)
				self.background_outline.Offset = pos - Vector2.new(1,1)
				self.background.Offset = pos
				self.background_border.Size = Vector2.new(size.X, self.top_margin) + Vector2.new(4,2)
				self.background_outline.Size = Vector2.new(size.X, self.top_margin) + Vector2.new(2,1)
				self.background.Size = Vector2.new(size.X, self.top_margin)
			else
				self.background_border.Offset = pos - Vector2.new(2,2)
				self.background_outline.Offset = pos - Vector2.new(1,1)
				self.background.Offset = pos
				self.background_border.Size = size + Vector2.new(4,4)
				self.background_outline.Size = size + Vector2.new(2,2)
				self.background.Size = size
			end
			if sizechanged then
				self:CalculateTabs()
			end
		end

		function GUI:SetInnerBorderless(bool)
			self.innerborderless = bool
			if bool then
				self.tablist.gradient.Visible = true
				self.tablist:Cache(self.tablist.gradient, 1, 1, 0, true)
			else
				self.tablist.gradient.Visible = false
				self.tablist:Cache(self.tablist.gradient, 1, 1, 0, false)
			end
		end

		function GUI:SetBorderless(bool)
			self.borderless = bool
			if bool then
				self.container:SetPos(0,0,0,self.top_margin+8)
				self.container:SetSize(1,0,1,-self.top_margin-8)
				self.tablist.borderless = bool
			else
				self.container:SetPos(0,8,0,self.top_margin+8)
				self.container:SetSize(1,-16,1,-self.top_margin-16)
				self.tablist.borderless = bool
			end

			self.tablist:InvalidateLayout(true, true)
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
				gui:OpacityTo(active[2], 0, 0.2, 0, 0.25, function()
					pnl:SetEnabled(false)
				end)
			end
			new[1]:SetActive(true)
			new[2]:SetEnabled(true)
			new[2]:InvalidateLayout(true, true)
			gui:OpacityTo(new[2], 1, 0.2, 0, 0.25)
			self.activeId = num
		end

		function GUI:CalculateTabs()
			local r = self.registry
			local l = #r
			local x = 0
			for i=1, l do
				local v = r[i]
				if self.scalebycontent then
					local sizex = v[1].text:GetTextSize() + 12
					v[1]:SetSize(0,sizex,1,-2)
					v[1]:SetPos(0,x,0,0)
					x += sizex
				elseif v[1].icon_perfered then
					local sizex = v[1].icon_perfered.X + 6
					v[1]:SetSize(0,sizex,1,-2)
					v[1]:SetPos(0,x,0,0)
					x += sizex
				else
					v[1]:SetSize(1/l,0,1,-2)
					v[1]:SetPos((1/l)*(i-1),0,0,0)
				end
			end

			if x < self.tablist.absolutesize.X then
				local extra = self.tablist.absolutesize.X - x
				local x = 0
				for i=1, l do
					local v = r[i]
					if v[1].icon_perfered then
						local sizex = v[1].icon_perfered.X + 6 + (extra/l)
						v[1]:SetSize(0,sizex,1,-2)
						v[1]:SetPos(0,x,0,0)
						x += sizex
					end
				end
			end
		end

		function GUI:Add(name, icon, object)
			object:SetParent(self.container)
			object:SetOpacity(0)
			object:SetEnabled(false)
			local tab = gui:Create("Tab", self.tablist)
			local r = self.registry
			tab.Id = #r+1
			tab.controller = self
			tab:SetText(name)
			tab:SetPanel(object)
			tab:SetIcon(icon)
			tab:SetBorderless(self.innerborderless)
			r[#r+1] = {tab, object}
			self:CalculateTabs()
			if tab.Id == 1 then
				self:SetActive(tab.Id)
			end
			return tab
		end

		gui:Register(GUI, "Tabs")
	end

	-- Button
	do
		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")

			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient)

			self.text = gui:Create("Text", self)
			self.text:SetXAlignment(XAlignment.Center)
			self.text:SetYAlignment(YAlignment.Center)
			self.text:SetPos(.5, 0, .5, -1)
			self.defaultcolor = Color3.new(1,1,1)

			self.confirmation = false
			self.confirmcolor = gui:GetColor("Accent")
			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.confirmcolor = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.confirmcolor = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = Vector2.new(size.X+1, 16)
		end

		function GUI:SetColor(color)
			self.defaultcolor = color
			self.text:SetColor(color)
		end

		function GUI:SetText(txt)
			self.content = txt
			self.text:SetText(txt)
		end

		function GUI:SetConfirmation(txt)
			self.confirmation = txt
		end

		function GUI:OnClick() end

		function GUI:CanClick() return true end

		function GUI:InputBegan(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() and self:CanClick() then
				if self.confirmation and not self.confirm then
					self.confirm = true
					self.text:SetText(self.confirmation)
					self.text:SetColor(self.confirmcolor)
					timer:Simple(1, function()
						if not gui:IsValid(self) then return end
						self.text:SetText(self.content)
						self.text:SetColor(self.defaultcolor)
						self.confirm = nil
					end)
				elseif (not self.confirmation or (self.confirmation and self.confirm)) then
					self:OnClick()
				end
			end
		end

		gui:Register(GUI, "Button")
	end

	-- Toggle
	do
		local GUI = {}

		function GUI:Init()
			self.button = gui:Create("Button", self)
			self.button:SetSizeConstraint("Y")
			self.button:SetSize(1,0,1,0)
			function self.button:PerformLayout(pos, size, poschanged, sizechanged)
				default_panel_borders(self, pos, size)
				self.gradient.Offset = pos + Vector2.new(-1,-1)
				self.gradient.Size = Vector2.new(size.X+1, 9)
				if not sizechanged then return end
				self.parent.text:SetPos(0, self.absolutesize.X + 7, .5, -1)
			end
			self.button:SetMouseInputs(false)

			self.text = gui:Create("Text", self)
			self.text:SetYAlignment(YAlignment.Center)
			self.text:SetPos(0, 0, .5, 0)
			self.text:SetTextSize(13)

			self.toggle = false
			local col = Color3.fromRGB(127, 72, 163)
			self.on = {col, color.darkness(col, .5)}
			self.off = {self.button.gradient.ColorUpperLeft, self.button.gradient.ColorBottomLeft}

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.on = {col, color.darkness(col, .5)}
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.on = {col, color.darkness(col, .5)}
				local colors = self.off
				if self.toggle then
					colors = self.on
				end
				self:SetGradientColor(unpack(colors))
			end)
		end

		function GUI:SetGradientColor(top, bottom)
			self.button.gradient.ColorUpperLeft = top
			self.button.gradient.ColorUpperRight = top
			self.button.gradient.ColorBottomLeft = bottom
			self.button.gradient.ColorBottomRight = bottom
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged","Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:SetText(txt)
			self.text:SetText(txt)
			self:InvalidateLayout()
		end

		function GUI:SetTextColor(col)
			self.text:SetColor(col)
		end
		
		function GUI:PerformLayout(pos, size, poschanged, sizechanged)
		end

		function GUI:OnClick()
			self.toggle = not self.toggle
			local colors = self.off
			if self.toggle then
				colors = self.on
			end
			self:SetGradientColor(unpack(colors))
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
			self:SetGradientColor(unpack(colors))
		end

		function GUI:OnValueChanged() end

		gui:Register(GUI, "Toggle")
	end

	-- KeyBind
	do
		local GUI = {}
		local keybind_registry = {}

		function GUI:Init()
			local background_border = draw:Create("Rect", "2V")
			background_border.Filled = true
			background_border.Color = gui:GetColor("Border")
			background_border.XAlignment = XAlignment.Right
			background_border.YAlignment = YAlignment.Bottom
			local background = draw:Clone(background_border)
			background.Color = gui:GetColor("Outline")
			self.background_border = self:Cache(background_border)
			self.background = self:Cache(background)

			self.text = gui:Create("Text", self)
			self.text:SetXAlignment(XAlignment.Center)
			self.text:SetYAlignment(YAlignment.Center)
			self.text:SetPos(.5, 0, .5, -1)
			self.text:SetClipping(true)
			self.text:SetTextSize(13)
			self.text:SetText("None")

			self.key = nil
			self.value = false
			self.toggletype = 1
			self.config = {}
			self.name = "KeyBind"

			keybind_registry[#keybind_registry+1] = self
		end

		function GUI:SetToggleType(type)
			self.toggletype = type
		end

		function GUI:SetConfigurationPath(path)
			self.config = path
		end

		function GUI:SetAlias(alias)
			self.name = alias
		end

		function GUI:PostRemove()
			local c = 0
			for i=1, #keybind_registry do
				local v = keybind_registry[i-c]
				if v == self then
					table.remove(keybind_registry, i-c)
					c=c+1
				end
			end
		end

		function GUI:GetRelatedConfig()
			local cfg = table.deepcopy(self.config)
			cfg[#cfg] = nil
			return cfg
		end
		
		function GUI:PerformLayout(pos, size)
			self.background_border.Offset = pos - Vector2.new(1,1)
			self.background.Offset = pos
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

		hook:Add("OnConfigChanged", "BBOT:Menu.KeyBinds", function(steps)
			for i=1, #keybind_registry do
				local v = keybind_registry[i]
				local cfg = table.deepcopy(v.config)
				cfg[#cfg] = nil
				local parentoption = config:GetRaw(unpack(cfg))
				local nick = (v.name ~= "KeyBind" and v.name or nil)
				if not nick then
					local cfg = table.deepcopy(v.config)
					cfg[#cfg] = nil
					nick = cfg[#cfg]
				end
				if (typeof(parentoption) == "boolean" and not parentoption) or not v.key then
					menu:UpdateStatus(nick, nil, false, v.text:GetText())
				elseif v.toggletype == 4 then
					menu:UpdateStatus(nick, nil, true, v.text:GetText())
				else
					local state = menu:GetStatus(cfg[#cfg])
					menu:UpdateStatus(nick, (state and state[2] or "Disabled"), true, v.text:GetText())
				end
			end
		end)

		hook:Add("InputBegan", "BBOT:Menu.KeyBinds", function(input)
			--if not config:GetValue("Main", "Visuals", "Extra", "Enabled") then return end
			if not menu.main or userinputservice:GetFocusedTextBox() or menu.main:GetAbsoluteEnabled() then
				return
			end
			for i=1, #keybind_registry do
				local v = keybind_registry[i]
				if input and input.KeyCode == v.key then
					local last = v.value
					if input and input.KeyCode == v.key then
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
					if last ~= v.value or v.toggletype == 4 then
						local nick = (v.name ~= "KeyBind" and v.name or nil)
						if not nick then
							local cfg = table.deepcopy(v.config)
							cfg[#cfg] = nil
							nick = cfg[#cfg]
						end
						if v.toggletype == 4 then
                        	menu:UpdateStatus(nick, nil, true)
						else
                        	menu:UpdateStatus(nick, (v.value and "Enabled" or "Disabled"), true)
						end
                        config:GetRaw(unpack(v.config)).toggle = v.value
                        hook:Call("OnKeyBindChanged", v.config, last, v.value, v.toggletype)
						if v.toggletype == 4 then
							v.value = false
						end
                        config:GetRaw(unpack(v.config)).toggle = v.value
                    end
                end
			end
		end)

		hook:Add("InputEnded", "BBOT:Menu.KeyBinds", function(input)
			--if not config:GetValue("Main", "Visuals", "Extra", "Enabled") then return end
			if not menu.main or userinputservice:GetFocusedTextBox() or menu.main:GetAbsoluteEnabled() then
				return
			end
			for i=1, #keybind_registry do
				local v = keybind_registry[i]
				if input and input.KeyCode == v.key then
					local last = v.value
					if input.KeyCode == v.key then
						if v.toggletype == 1 then
							v.value = false
						elseif v.toggletype == 3 then
							v.value = true
						end
					end
					if last ~= v.value then
						local nick = (v.name ~= "KeyBind" and v.name or nil)
						if not nick then
							local cfg = table.deepcopy(v.config)
							cfg[#cfg] = nil
							nick = cfg[#cfg]
						end
						menu:UpdateStatus(nick, (v.value and "Enabled" or "Disabled"), true)
						config:GetRaw(unpack(v.config)).toggle = v.value
						hook:Call("OnKeyBindChanged", v.config, last, v.value, v.toggletype)
					end
				end
			end
		end)

		--[[local ignorenotify = false
		hook:Add("OnConfigChanged", "BBOT:Menu.KeyBinds.Reset", function(step, old, new)
			if config:IsPathwayEqual(step, "Main", "Visuals", "Extra", "Enabled") then
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

		hook:Add("OnKeyBindChanged", "BBOT:Notify", function(steps, old, new, toggletype)
			if ignorenotify then return end
			
			if config:GetValue("Main", "Visuals", "Extra", "Log Keybinds") and toggletype ~= 4 then
				local name = steps[#steps]
				if name == "KeyBind" then
					name = steps[#steps-1]
				end
				BBOT.notification:Create(name .. " has been " .. (new and "enabled" or "disabled"))
			end
		end)

		gui:Register(GUI, "KeyBind")
	end

	-- Progress Bar
	do
		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient)
			local col = Color3.fromRGB(127, 72, 163)
			self.basecolor = {col, color.darkness(col, .5)}
			self:SetGradientColor(unpack(self.basecolor))
			self.percentage = 0
			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.basecolor = {col, color.darkness(col, .5)}
				self:SetGradientColor(unpack(self.basecolor))
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.basecolor = {col, color.darkness(col, .5)}
				self:SetGradientColor(unpack(self.basecolor))
			end)
		end

		function GUI:SetGradientColor(top, bottom)
			self.gradient.ColorUpperLeft = top
			self.gradient.ColorUpperRight = top
			self.gradient.ColorBottomLeft = bottom
			self.gradient.ColorBottomRight = bottom
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:SetPercentage(perc)
			self.percentage = perc
			self:InvalidateLayout()
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.gradient.Offset = pos + Vector2.new(-1, -1)
			self.gradient.Size = Vector2.new((size.X+1)*self.percentage, size.Y+1)
		end

		gui:Register(GUI, "ProgressBar")
	end

	-- Slider
	do
		local GUI = {}

		local userinputservice = BBOT.service:GetService("UserInputService")

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")
			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient)


			local bar = default_gradient(self)
			self.bar = self:Cache(bar)
			local col = Color3.fromRGB(127, 72, 163)
			self.basecolor = {col, color.darkness(col, .5)}
			self:SetGradientColor(unpack(self.basecolor))
			self.percentage = math.random(0,1000)/1000

			self.buttoncontainer = gui:Create("Container", self)

			local onhover = Color3.fromRGB(127, 72, 163)
			local idle = Color3.new(1,1,1)

			self.add = gui:Create("TextButton", self.buttoncontainer)
			self.add:SetText("+")
			self.add:SetClipping(true)
			self.add:SetTextXAlignment(XAlignment.Right)
			self.add:SetXAlignment(XAlignment.Right)
			self.add:SetYAlignment(YAlignment.Bottom)
			local w, h = 10, 12
			self.add:SetPos(1, -w + 2, 0, 0)
			self.add:SetSize(0, w, 0, h)
			
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
						self:SetColor(onhover)
					else
						self:SetColor(idle)
					end
				end
			end

			self.deduct = gui:Create("TextButton", self.buttoncontainer)
			self.deduct:SetText("-")
			self.deduct:SetClipping(false)
			self.deduct:SetTextXAlignment(XAlignment.Right)
			self.deduct:SetXAlignment(XAlignment.Right)
			self.deduct:SetYAlignment(YAlignment.Bottom)
			local ww, hh = 10, 12
			self.deduct:SetPos(1, -w -ww + 2, 0, 0)
			self.deduct:SetSize(0, w, 0, h)
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
			self.buttoncontainer:SetOpacity(0)

			function self.add:OnFontChanged(old, new)
				self:InvalidateLayout()
				local w, h = self.add.text:GetTextSize()
				self.add:SetPos(1, -w + 2, 0, 0)
				self.add:SetSize(0, w, 0, 8)
				local ww, hh = self.deduct.text:GetTextSize()
				self.deduct:SetPos(1, -w -ww - 2, 0, 0)
				self.deduct:SetSize(0, w, 0, 8)
			end
	
			function self.add:OnFontSizeChanged(old, new)
				self:InvalidateLayout()
				local w, h = self.add.text:GetTextSize()
				self.add:SetPos(1, -w + 2, 0, 0)
				self.add:SetSize(0, w, 0, 8)
				local ww, hh = self.deduct.text:GetTextSize()
				self.deduct:SetPos(1, -w -ww - 2, 0, 0)
				self.deduct:SetSize(0, w, 0, 8)
			end

			function self.buttoncontainer:Step()
				local hover = (self:IsHovering() or self.add:IsHovering() or self.deduct:IsHovering())
				if hover ~= self.hover then
					self.hover = hover
					if hover then
						gui:OpacityTo(self, 1, 0.2, 0, 0.25)
					else
						gui:OpacityTo(self, 0, 0.2, 0, 0.25)
					end
				end
			end

			self.text = gui:Create("Text", self)
			self.text:SetXAlignment(XAlignment.Center)
			self.text:SetYAlignment(YAlignment.Center)
			self.text:SetTextSize(13)
			self.text:SetPos(.5,0,.5,-1)
			self.text:SetText("0%")

			self.suffix = "%"
			self.min = 0
			self.max = 100
			self.decimal = 1
			self.custom = {}
			self.mouseinputs = true

			self:SetPercentage(self.percentage)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				self.basecolor = {col, color.darkness(col, .5)}
				self:SetGradientColor(unpack(self.basecolor))
				onhover = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				self.basecolor = {col, color.darkness(col, .5)}
				self:SetGradientColor(unpack(self.basecolor))
				onhover = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:SetGradientColor(top, bottom)
			self.bar.ColorUpperLeft = top
			self.bar.ColorUpperRight = top
			self.bar.ColorBottomLeft = bottom
			self.bar.ColorBottomRight = bottom
		end

		function GUI:SetPercentage(perc)
			self.percentage = perc
			local value = math.round(math.remap(perc, 0, 1, self.min, self.max), self.decimal)
			if self.custom[value] then
				self.text:SetText(self.custom[value])
			else
				self.text:SetText(value .. self.suffix)
			end
			self.bar.Size = Vector2.new((self.absolutesize.X+1)*self.percentage, self.absolutesize.Y+1)
		end

		function GUI:_SetValue(value)
			self:SetPercentage(math.remap(math.clamp(value, self.min, self.max), self.min, self.max, 0, 1))
			self:OnValueChanged(self:GetValue())
		end

		function GUI:GetValue()
			return math.round(math.remap(self.percentage, 0, 1, self.min, self.max), self.decimal)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = size + Vector2.new(1,1)
			self.bar.Offset = pos + Vector2.new(-1,-1)
			self.bar.Size = Vector2.new((size.X+1)*self.percentage, size.Y+1)
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

	-- List
	do
		do
			local GUI = {}
			function GUI:Init()
				local borderleft = draw:Create("Line", "2V", "2V")
				borderleft.Color = gui:GetColor("Border")
				borderleft.Thickness = 1

				local borderright = draw:Clone(borderleft)
				local bordertop = draw:Clone(borderleft)
				local borderbottom = draw:Clone(borderleft)

				self.borderleft = self:Cache(borderleft)
				self.borderright = self:Cache(borderright)
				self.bordertop = self:Cache(bordertop)
				self.borderbottom = self:Cache(borderbottom)

				self:SetMouseInputs(false)
			end
			function GUI:SetLeftVisible(bool)
				self.borderleft.Visible = bool
				self:Cache(self.borderleft, 1, 1, 0, bool)
			end
			function GUI:SetRightVisible(bool)
				self.borderright.Visible = bool
				self:Cache(self.borderright, 1, 1, 0, bool)
			end
			function GUI:SetTopVisible(bool)
				self.bordertop.Visible = bool
				self:Cache(self.bordertop, 1, 1, 0, bool)
			end
			function GUI:SetBottomVisible(bool)
				self.borderbottom.Visible = bool
				self:Cache(self.borderbottom, 1, 1, 0, bool)
			end
			function GUI:PerformLayout(pos, size)
				self.borderleft.Offset1 = pos + Vector2.new(0,3)
				self.borderleft.Offset2 = pos + Vector2.new(0, size.Y-3)

				self.borderright.Offset1 = pos + Vector2.new(size.X, 3)
				self.borderright.Offset2 = pos + size + Vector2.new(0,-3)

				self.bordertop.Offset1 = pos
				self.bordertop.Offset2 = pos + Vector2.new(size.X, 0)

				self.borderbottom.Offset1 = pos + Vector2.new(0, size.Y)
				self.borderbottom.Offset2 = pos + size
			end
			gui:Register(GUI, "ListContainer")
		end

		local GUI = {}
		local icons = BBOT.icons

		function GUI:Init()
			default_panel_objects(self)
			self:SetMouseInputs(true)

			local gradient = default_gradient(self)
			gradient.ZIndex = 1
			self.gradient = self:Cache(gradient)

			self.title = gui:Create("Text", self)
			self.title:SetXAlignment(XAlignment.Center)
			self.title:SetYAlignment(YAlignment.Center)
			self.title:SetPos(.5,0,.5,-1)
			self.title:SetText("")

			local sort_arrow = draw:Create("Image", "2V")
			sort_arrow.Image = icons:NameToIcon("SORTARROW")[1]
			sort_arrow.Color = Color3.fromRGB(127, 72, 163)
			sort_arrow.Size = sort_arrow.ImageSize
			sort_arrow.XAlignment = XAlignment.Right
			sort_arrow.YAlignment = YAlignment.Center
			sort_arrow.Visible = false
			sort_arrow.ZIndex = 2
			self.sort_arrow = self:Cache(sort_arrow)

			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
				sort_arrow.Color = col
			end

			hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
				sort_arrow.Color = col
			end)
		end

		function GUI:PreRemove()
			hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = Vector2.new(size.X+1, 21)
			local ww, hh = self.title:GetTextSize()
			self.sort_arrow.Offset = pos + (size/2) + Vector2.new((ww/2) + 3, 0)
		end

		function GUI:InputBegan(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
				local descending = false
				if self.last_sorting == self.position then
					if self.last_decending then
						descending = false
					else
						descending = true
					end
				end
				self.parent:ChangeSorting(self.position, descending)
			end
		end

		function GUI:OnSortingChanged(position, descending)
			self.last_sorting = position
			self.last_decending = descending
			if self.position ~= position then
				self.sort_arrow.Visible = false
			elseif descending then
				self.sort_arrow.Visible = true
				self.sort_arrow.Size = Vector2.new(self.sort_arrow.ImageSize.X, -self.sort_arrow.ImageSize.Y)
			else
				self.sort_arrow.Visible = true
				self.sort_arrow.Size = Vector2.new(self.sort_arrow.ImageSize.X, self.sort_arrow.ImageSize.Y)
			end
		end

		gui:Register(GUI, "ListColumn")

		local GUI = {}

		function GUI:Init()
			
		end

		function GUI:PerformLayout(pos, size)

		end

		function GUI:SetTopLineVisible(bool)
			local columns = self.controller.columns
			for i=1, #columns do
				local child = self.children[i]
				local col = columns[i]
				child:SetTopVisible(bool)
			end
		end

		function GUI:SetBottomLineVisible(bool)
			local columns = self.controller.columns
			for i=1, #columns do
				local child = self.children[i]
				local col = columns[i]
				child:SetBottomVisible(bool)
			end
		end

		function GUI:Calibrate()
			local columns = self.controller.columns
			for i=1, #columns do
				local child = self.children[i]
				local col = columns[i]
				child:SetPos(col.pos.X.Scale, 0, 0, 0)
				child:SetSize(col.size.X.Scale, 0, 0, 20)
			end
		end

		function GUI:SetOptions(...)
			local options = {...}
			for i=1, #options do
				local container = gui:Create("ListContainer", self)

				if i == 1 then
					container:SetLeftVisible(false)
				end
				if i == #options then
					container:SetRightVisible(false)
				end

				local row_column = gui:Create("SlidingText", container)
				container.text = row_column
				row_column:SetXAlignment(XAlignment.Right)
				row_column:SetYAlignment(YAlignment.Center)
				row_column:SetPos(0,4,.5,0)
				row_column:SetText(options[i])
			end
			self:Calibrate()
		end

		function GUI:OnClick() end

		function GUI:InputBegan(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
				self:OnClick()
			end
		end

		gui:Register(GUI, "ListRow")

		local GUI = {}

		function GUI:Init()
			self.scrollpanel = gui:Create("ScrollPanel", self)
			self.scrollpanel:SetPos(0,0,0,22)
			self.scrollpanel:SetSize(1,0,1,-22)
			self.scrollpanel:SetPadding(0)
			self.scrollpanel:SetSpacing(0)
			self.scrollpanel.scrollbar:SetZIndex(50)

			function self.scrollpanel:OnPerformOrganization()
				local children = self.canvas.children
				local len = #children
				for i=1, len do
					local v = children[i]
					if self:IsAtStart(i) then
						v:SetTopLineVisible(false)
						v:SetBottomLineVisible(true)
					elseif self:IsAtEnd(i) then
						v:SetTopLineVisible(true)
						v:SetBottomLineVisible(false)
					else
						v:SetTopLineVisible(true)
						v:SetBottomLineVisible(true)
					end
				end
			end

			self.columns = {}
		end

		function GUI:PerformLayout() end

		function GUI:Recalibrate()
			self:RecalibrateColumns()
		end

		function GUI:RecalibrateColumns()
			local columns_len = #self.columns
			if ( columns_len == 0 ) then return end
			local ideal_wide = 1/columns_len

			for i=1, columns_len do
				local v = self.columns[i]
				v:SetPos(ideal_wide*(i-1), 0, 0, 0)
				v:SetSize(ideal_wide, 0, 0, 20)
			end
		end

		function GUI:AddLine(...)
			local row = gui:Create("ListRow")
			row.controller = self
			row:SetOptions(...)
			row:SetSize(1,0,0,20)
			row:SetZIndex(0)
			function row.OnClick(s)
				self:OnSelected(s)
			end
			self.scrollpanel:Add(row)
			if self.sort_position then
				self:ChangeSorting(self.sort_position, self.sort_descending)
			end
			return row
		end

		function GUI:OnSelected(row) end

		function GUI:PerformOrganization()
			self.scrollpanel:PerformOrganization()
		end

		function GUI:AddColumn(name, pos, wide)
			local newcolumn = gui:Create("ListColumn", self)
			newcolumn.title:SetText(name)
			newcolumn.name = name
			newcolumn.position = pos or (#self.columns+1)
			newcolumn.wide = wide
			self.columns[#self.columns+1] = newcolumn
			self:Recalibrate()
			return newcolumn
		end

		function GUI:ChangeSorting(position, descending)
			self.sort_position = position
			self.sort_descending = descending
			table.sort(self.scrollpanel.canvas.children, function(a, b)
				if descending then
					return a.children[position].text:GetText() > b.children[position].text:GetText()
				else
					return a.children[position].text:GetText() < b.children[position].text:GetText()
				end
			end)
			self.scrollpanel:PerformOrganization()
			for i=1, #self.columns do
				self.columns[i]:OnSortingChanged(position, descending)
			end
		end

		gui:Register(GUI, "List")
	end

	-- Color Picker
	do
		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")
			
			--(imagedata, x, y, w, h, transparency, visible)


			local color_fade = draw:Create("Rect", "2V")
			color_fade.Color = Color3.new(0,0,0)
			color_fade.XAlignment = XAlignment.Right
			color_fade.YAlignment = YAlignment.Bottom
			color_fade.Filled = true
	
			local white_black_fade = draw:Create("Image", "2V")
			white_black_fade.XAlignment = XAlignment.Right
			white_black_fade.YAlignment = YAlignment.Bottom
			white_black_fade.Image = BBOT.menu.images[1]

			local cursor_outline = draw:Clone(color_fade)
			cursor_outline.Filled = false
			cursor_outline.Size = Vector2.new(6,6)
			cursor_outline.Color = Color3.new(0,0,0)

			local cursor = draw:Clone(color_fade)
			cursor.Filled = false
			cursor.Size = Vector2.new(4,4)
			cursor.Color = Color3.new(1,1,1)


			self.color_fade = self:Cache(color_fade)
			self.white_black_fade = self:Cache(white_black_fade)
			self.cursor_outline = self:Cache(cursor_outline)
			self.cursor = self:Cache(cursor)
			self.cursor_position = Vector2.new(2,2)
			self:SetMouseInputs(true)

			--(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
			--[[
				ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
				ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
				ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
			]]
		end

		function GUI:SetColor(color, transparency)
			local h, s, v = Color3.toHSV(color)
			self.color_fade.Color = Color3.fromHSV(h, 1, 1)
			self.h = h
			self.s = s
			self.v = v
			self.t = transparency
			self.cursor_position = Vector2.new(self.s, 1-self.v) * self.absolutesize
			self:MoveCursor()
		end

		function GUI:MoveCursor()
			self.cursor.Offset = self.absolutepos + self.cursor_position - Vector2.new(2, 2)
			self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1, 1)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.color_fade.Offset = pos
			self.color_fade.Size = size
			self.white_black_fade.Offset = pos - Vector2.new(1,1)
			self.white_black_fade.Size = size + Vector2.new(1,1)
			self:MoveCursor()
		end

		function GUI:CalculateValue(X, Y)
			local APX = self.absolutepos.X
			local ASX = self.absolutesize.X
			local APY = self.absolutepos.Y
			local ASY = self.absolutesize.Y
			local newX = math.clamp(X, APX, APX + ASX )
			local newY = math.clamp(Y, APY, APY + ASY )
			local new_position = Vector2.new(newX-APX, newY-APY)
			self.cursor_position = new_position
			self:MoveCursor()

			-- calculate new color
			self.s = math.clamp(new_position.X/self.absolutesize.X, 0, 1)
			self.v = math.clamp(1-(new_position.Y/self.absolutesize.Y), 0, 1)

			self:OnValueChanged(Color3.fromHSV(self.h, self.s, self.v), self.t)
		end

		local mouse = BBOT.service:GetService("Mouse")
		function GUI:Step()
			if self.down then
				self:CalculateValue(mouse.X, mouse.Y+36)
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

		function GUI:OnValueChanged(color, transparency)
			
		end

		gui:Register(GUI, "ColorPallet")

		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")
			
			--(imagedata, x, y, w, h, transparency, visible)
			local color_fade = draw:Create("Image", "2V")
			color_fade.XAlignment = XAlignment.Right
			color_fade.YAlignment = YAlignment.Bottom
			color_fade.Image = BBOT.menu.images[3]

			local cursor_outline = draw:Create("Rect", "2V")
			cursor_outline.XAlignment = XAlignment.Right
			cursor_outline.YAlignment = YAlignment.Bottom
			cursor_outline.Color = Color3.new(0,0,0)

			local cursor = draw:Clone(cursor_outline)
			cursor.Color = Color3.new(1,1,1)

			self.color_fade = self:Cache(color_fade)
			self.cursor_outline = self:Cache(cursor_outline)
			self.cursor = self:Cache(cursor)
			self.cursor_position = Vector2.new(2,2)
			self:SetMouseInputs(true)

			--(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
			--[[
				ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
				ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
				ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
			]]
		end

		function GUI:SetColor(color, transparency)
			local h, s, v = Color3.toHSV(color)
			self.h = h
			self.s = s
			self.v = v
			self.t = transparency
			self.cursor_position = Vector2.new(0, 1-self.h) * self.absolutesize
			self:MoveCursor()
		end

		function GUI:MoveCursor()
			self.cursor.Offset = self.absolutepos + self.cursor_position - Vector2.new(2, 2)
			self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1, 1)
			self.cursor.Size = Vector2.new(self.absolutesize.X+4, 4)
			self.cursor_outline.Size = Vector2.new(self.absolutesize.X+6, 6)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.color_fade.Offset = pos - Vector2.new(1,1)
			self.color_fade.Size = size + Vector2.new(1,1)
			self:MoveCursor()
		end

		function GUI:CalculateValue(X, Y)
			local APY = self.absolutepos.Y
			local ASY = self.absolutesize.Y
			local newY = math.clamp(Y, APY, APY + ASY )
			self.cursor_position = Vector2.new(0, newY-APY)
			self:MoveCursor()

			-- calculate new color
			self.h = math.clamp(1-(self.cursor_position.Y/self.absolutesize.Y), 0, 1)
			self:OnValueChanged(Color3.fromHSV(self.h, self.s, self.v), self.t)
		end

		local mouse = BBOT.service:GetService("Mouse")
		function GUI:Step()
			if self.down then
				self:CalculateValue(mouse.X, mouse.Y+36)
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

		function GUI:OnValueChanged(color, transparency)
			
		end

		gui:Register(GUI, "ColorSlider")

		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")
			self.background.Color = Color3.new(1,1,1)
			
			--(imagedata, x, y, w, h, transparency, visible)
			local color_fade = draw:Create("Image", "2V")
			color_fade.XAlignment = XAlignment.Right
			color_fade.YAlignment = YAlignment.Bottom
			color_fade.Image = BBOT.menu.images[1]

			local cursor_outline = draw:Create("Rect", "2V")
			cursor_outline.XAlignment = XAlignment.Right
			cursor_outline.YAlignment = YAlignment.Bottom
			cursor_outline.Color = Color3.new(0,0,0)

			local cursor = draw:Clone(cursor_outline)
			cursor.Color = Color3.new(1,1,1)

			self.color_fade = self:Cache(color_fade)
			self.cursor_outline = self:Cache(cursor_outline)
			self.cursor = self:Cache(cursor)
			self.cursor_position = Vector2.new(2,2)
			self:SetMouseInputs(true)

			--(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
			--[[
				ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
				ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
				ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
			]]
		end

		function GUI:SetColor(color, transparency)
			local h, s, v = Color3.toHSV(color)
			self.h = h
			self.s = s
			self.v = v
			self.t = transparency
			self.cursor_position = Vector2.new(0, 1-transparency) * self.absolutesize
			self:MoveCursor()
		end

		function GUI:MoveCursor()
			self.cursor.Offset = self.absolutepos + self.cursor_position - Vector2.new(2, 2)
			self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1, 1)
			self.cursor.Size = Vector2.new(self.absolutesize.X+4, 4)
			self.cursor_outline.Size = Vector2.new(self.absolutesize.X+6, 6)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.color_fade.Offset = pos - Vector2.new(1,1)
			self.color_fade.Size = size + Vector2.new(1,1)
			self:MoveCursor()
		end

		function GUI:CalculateValue(X, Y)
			local APY = self.absolutepos.Y
			local ASY = self.absolutesize.Y
			local newY = math.clamp(Y, APY, APY + ASY )
			self.cursor_position = Vector2.new(0, newY-APY)
			self:MoveCursor()

			-- calculate new color
			self.t = math.clamp(1-(self.cursor_position.Y/self.absolutesize.Y), 0, 1)
			self:OnValueChanged(Color3.fromHSV(self.h, self.s, self.v), self.t)
		end

		local mouse = BBOT.service:GetService("Mouse")
		function GUI:Step()
			if self.down then
				self:CalculateValue(mouse.X, mouse.Y+36)
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

		function GUI:OnValueChanged(color, transparency)
			
		end

		gui:Register(GUI, "AlphaSlider")

		local GUI = {}

		function GUI:Init()
			default_panel_objects(self)
			self.background_border.Color = gui:GetColor("Outline-Light")
			self.background_outline.Color = gui:GetColor("Border")
			--(imagedata, x, y, w, h, transparency, visible)
			local transparency_background = draw:Create("Image", "2V")
			transparency_background.XAlignment = XAlignment.Right
			transparency_background.YAlignment = YAlignment.Bottom
			transparency_background.Image = BBOT.menu.images[5]
			self.transparency_background = self:Cache(transparency_background)
		end

		function GUI:SetColor(col, transparency)
			self.background.Color = col
			self.background.Opacity = transparency
			self:Cache(self.background)
		end

		function GUI:PerformLayout(pos, size, shiftpos, shiftsize)
			default_panel_borders(self, pos, size)
			self.transparency_background.Offset = pos - Vector2.new(1,1)
			self.transparency_background.Size = size + Vector2.new(1,1)
		end

		gui:Register(GUI, "ColorPreview")

		local GUI = {}
		local _color = color
		function GUI:Init()
			default_panel_objects(self)

			local gradient = default_gradient(self)
			self.gradient = self:Cache(gradient)

			local title = gui:Create("Text", self)
			self.title = title
			self.title_content = ""
			title:SetPos(0, 3, 0, 3)
			title:SetText("")

			self.pallet = gui:Create("ColorPallet", self)
			self.pallet:SetPos(0, 6, 0, 21)
			self.pallet:SetSize(1, -14-22*2, 1, -21-6-22)
			--self.pallet:SetSizeConstraint("Y")

			self.hslider = gui:Create("ColorSlider", self)
			self.hslider:SetPos(1, -22-17-6, 0, 21)
			self.hslider:SetSize(0, 16, 1, -21-6-22)

			self.tslider = gui:Create("AlphaSlider", self)
			self.tslider:SetPos(1, -22, 0, 21)
			self.tslider:SetSize(0, 16, 1, -21-6-22)

			self.hexbox = gui:Create("TextEntry", self)
			self.hexbox:SetText(color.tohex(Color3.new(1,1,1)))
			self.hexbox:SetPos(0, 6, 1, -22)
			self.hexbox:SetSize(0,60,0,16)
			self.hexbox:SetTextSize(13)

			self.rgbabox = gui:Create("TextEntry", self)
			self.rgbabox:SetText("")
			self.rgbabox:SetPos(0, 6+66, 1, -22)
			self.rgbabox:SetSize(1,-13-22-66,0,16)
			self.rgbabox:SetTextSize(13)

			self.colorpreview = gui:Create("ColorPreview", self)
			self.colorpreview.tooltip = "This is the preview of the chosen color"
			self.colorpreview:SetPos(1, -22, 1, -22)
			self.colorpreview:SetSize(0, 16, 0, 16)

			local s = self
			function self.pallet:OnValueChanged(color, transparency)
				s.hslider:SetColor(color, transparency)
				s.tslider:SetColor(color, transparency)
				s:OnChanged(color, transparency)
				s.hexbox:SetText(_color.tohex(color))
				s.rgbabox:SetText(_color.tostring(color, transparency))
				s.colorpreview:SetColor(color, transparency)
			end
			function self.hslider:OnValueChanged(color, transparency)
				s.pallet:SetColor(color, transparency)
				s.tslider:SetColor(color, transparency)
				s:OnChanged(color, transparency)
				s.hexbox:SetText(_color.tohex(color))
				s.rgbabox:SetText(_color.tostring(color, transparency))
				s.colorpreview:SetColor(color, transparency)
			end
			function self.tslider:OnValueChanged(color, transparency)
				s.pallet:SetColor(color, transparency)
				s.hslider:SetColor(color, transparency)
				s:OnChanged(color, transparency)
				s.hexbox:SetText(_color.tohex(color))
				s.rgbabox:SetText(_color.tostring(color, transparency))
				s.colorpreview:SetColor(color, transparency)
			end
			function self.hexbox:OnValueChanged(hex)
				local color = _color.fromhex(hex)
				local transparency = s.tslider.t
				if not color then return end
				s.pallet:SetColor(color, transparency)
				s.hslider:SetColor(color, transparency)
				s:OnChanged(color, transparency)
				s.rgbabox:SetText(_color.tostring(color, transparency))
				s.colorpreview:SetColor(color, transparency)
			end
			function self.rgbabox:OnValueChanged(textcolor)
				local color, transparency = _color.fromstring(textcolor)
				if not color then return end
				s.pallet:SetColor(color, transparency)
				s.hslider:SetColor(color, transparency)
				s.tslider:SetColor(color, transparency)
				s:OnChanged(color, transparency)
				s.hexbox:SetText(_color.tohex(color))
				s.colorpreview:SetColor(color, transparency)
			end

			self:SetOpacity(0)
			gui:OpacityTo(self, 1, 0.2, 0, 0.25)
		end

		function GUI:PerformLayout(pos, size)
			default_panel_borders(self, pos, size)
			self.gradient.Offset = pos + Vector2.new(-1,-1)
			self.gradient.Size = Vector2.new(size.X+1, 21)
		end

		function GUI:Close()
			gui:OpacityTo(self, 0, 0.2, 0, 0.25, function()
				self:Remove()
			end)
		end

		function GUI:SetTitle(txt)
			self.title_content = txt
			self.title:SetText(txt)
		end

		function GUI:SetColor(color, transparency)
			self.pallet:SetColor(color, transparency)
			self.hslider:SetColor(color, transparency)
			self.tslider:SetColor(color, transparency)
			self.hexbox:SetText(_color.tohex(color))
			self.rgbabox:SetText(_color.tostring(color, transparency))
			self.colorpreview:SetColor(color, transparency)
		end

		function GUI:OnChanged() end

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
			local border = draw:Create("Rect", "2V")
			border.Color = gui:GetColor("Border")
			border.Filled = true
			border.XAlignment = XAlignment.Right
			border.YAlignment = YAlignment.Bottom

			local nocolor = draw:Create("Image", "2V")
			nocolor.Image = BBOT.menu.images[4]
			nocolor.XAlignment = XAlignment.Right
			nocolor.YAlignment = YAlignment.Bottom

			local outline = draw:Clone(border)
			outline.Color = gui:GetColor("Border")

			local background = draw:Clone(border)
			background.Color = gui:GetColor("Background")
			background.ZIndex = 1

			self.background_border = self:Cache(border)
			self.background_nocolor = self:Cache(nocolor)
			self.background_outline = self:Cache(outline)
			self.background = self:Cache(background)
		end

		function GUI:PerformLayout(pos, size)
			self.background.Offset = pos + Vector2.new(2, 2)
			self.background.Size = size - Vector2.new(4, 4)
			self.background_outline.Offset = pos
			self.background_outline.Size = size
			self.background_nocolor.Offset = pos - Vector2.new(1,1)
			self.background_nocolor.Size = size + Vector2.new(1,1)
			self.background_border.Offset = pos - Vector2.new(1, 1)
			self.background_border.Size = size + Vector2.new(2, 2)
		end

		function GUI:SetColor(col, transparency)
			self.background.Color = col
			self:Cache(self.background_outline, transparency, 1, 0, true)
			self.background_outline.Color = color.darkness(col, .75)
			self:PerformDrawings()
			self.color_transparency = transparency
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
			picker:SetSize(0, 240, 0, 211)
			picker:SetTitle(self.title)
			picker:SetColor(self.background.Color, self.color_transparency)
			picker:SetZIndex(100)
			function picker.OnChanged(s, rgb, alpha)
				self:SetColor(rgb, alpha)
				self:OnValueChanged({rgb.R*255, rgb.G*255, rgb.B*255, alpha*255})
			end
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
			self:SetColor(Color3.fromRGB(unpack(col)), col[4] and (col[4]/255) or 1)
		end

		function GUI:OnValueChanged() end

		gui:Register(GUI, "ColorPicker", "Button")
	end

	-- Line Graph
	do
		local GUI = {}

		function GUI:Init()

		end

		function GUI:PerformLayout(pos, size, poschanged, sizechanged)

		end

		gui:Register(GUI, "LineGraph")
	end
end

-- Menu
do
	local timer = BBOT.timer
	local config = BBOT.config
	local math = BBOT.math
    local hook = BBOT.hook
	local table = BBOT.table
	local color = BBOT.color
	local thread = BBOT.thread
	local font = BBOT.font
	local asset = BBOT.asset
	local string = BBOT.string
    local draw = BBOT.draw
    local gui = BBOT.gui
	local camera = BBOT.service:GetService("CurrentCamera")
	local userinputservice = BBOT.service:GetService("UserInputService")
	local menu = BBOT.menu

	menu.images = {}
	thread:CreateMulti({
		function()
			menu.images[1] = ImageRef.new(game:HttpGet("https://i.imgur.com/9NMuFcQ.png"))
		end,
		function()
			menu.images[2] = ImageRef.new(game:HttpGet("https://i.imgur.com/jG3NjxN.png"))
		end,
		function()
			menu.images[3] = ImageRef.new(game:HttpGet("https://i.imgur.com/2Ty4u2O.png"))
		end,
		function()
			menu.images[4] = ImageRef.new(game:HttpGet("https://i.imgur.com/kNGuTlj.png"))
		end,
		function()
			menu.images[5] = ImageRef.new(game:HttpGet("https://i.imgur.com/OZUR3EY.png"))
		end,
		function()
			menu.images[6] = ImageRef.new(game:HttpGet("https://i.imgur.com/3HGuyVa.png"))
		end,
		function()
			menu.images[7] = ImageRef.new(game:HttpGet("https://i.imgur.com/H7otBZX.png"))
		end,
		function()
			menu.images[8] = ImageRef.new(game:HttpGet("https://i.imgur.com/qH0WziT.png"))
		end
	})

	local loaded = {}
	do
		local function Loopy_Image_Checky()
			for i = 1, 8 do
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


	font:Create("Menu.Title", font:GetDefault(), 16)
	font:Create("Menu.BodyBig", font:GetDefault(), 16)
	font:Create("Menu.BodyMedium", font:GetDefault(), 14)
	font:Create("Menu.BodySmall", font:GetDefault(), 12)

	hook:Add("OnConfigChanged", "BBOT:Menu.FontChanged", function(steps, old, new)
		if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Fonts", "Title Font") then
			font:ChangeFont("Menu.Title", new)
		elseif config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Fonts", "Body Font") then
			font:ChangeFont("Menu.BodyBig", new)
			font:ChangeFont("Menu.BodyMedium", new)
			font:ChangeFont("Menu.BodySmall", new)
		end
	end)

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
			picker:SetValue(_config_module:GetRaw(unpack(path)).value)
			picker.tooltip = config.tooltip
			picker.path = path
			function picker:OnValueChanged(new)
				menu:ConfigSetValue(new, path)
			end
			self.config_pathways[uid] = picker
			return 25 + 4
		elseif type == "KeyBind" then
			local keybind = gui:Create("KeyBind", container)
			keybind:SetPos(1, X-34, 0, Y)
			keybind:SetSize(0, 34, 0, 10)
			keybind.value = false
			keybind.tooltip = config.tooltip
			keybind:SetToggleType(config.toggletype)
			keybind:SetConfigurationPath(path)
			keybind:SetAlias(name)
			keybind:SetValue(_config_module:GetRaw(unpack(path)).value)
			keybind.path = path
			function keybind:OnValueChanged(new)
				menu:ConfigSetValue(new, path)
			end
			self.config_pathways[uid] = keybind
			return 33 + 4
		end
		return 0
	end

	local unsafe_color = Color3.fromRGB(245, 239, 120)
	local indev_color = Color3.fromRGB(0, 208, 255)
	local bl_color = Color3.fromRGB(255, 0, 0)
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
			toggle.text:SetFontManager("Menu.BodyMedium")
			if config.bl then
				toggle.text:SetColor(bl_color)
			elseif config.indev then
				toggle.text:SetColor(indev_color)
			elseif config.unsafe then
				toggle.text:SetColor(unsafe_color)
			end
			local w = toggle.text:GetTextSize()
			w = w + 8
			toggle:SetSize(0, 14 + w, 0, 8)
			function toggle.text:OnFontChanged(old, new)
				self:InvalidateLayout()
				local w = toggle.text:GetTextSize()
				toggle:SetSize(0, 14 + w, 0, 8)
			end
			function toggle.text:OnFontSizeChanged(old, new)
				self:InvalidateLayout()
				local w = toggle.text:GetTextSize()
				toggle:SetSize(0, 14 + w, 0, 8)
			end
			toggle:InvalidateLayout(true)
			toggle:SetValue(_config_module:GetValue(unpack(path)))
			toggle.tooltip = config.tooltip
			toggle.path = path
			function toggle:OnValueChanged(new)
				if config.indev and BBOT.username ~= "dev" then return end
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					toggle:SetValue(_config_module:GetValue(unpack(path)))
					return
				end
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
			text:SetFontManager("Menu.BodyMedium")
			if config.bl then
				text:SetColor(bl_color)
			elseif config.indev then
				text:SetColor(indev_color)
			elseif config.unsafe then
				text:SetColor(unsafe_color)
			end
			local slider = gui:Create("Slider", cont)
			slider.suffix = config.suffix or slider.suffix
			slider.min = config.min or slider.min
			slider.max = config.max or slider.max
			slider.decimal = config.decimal or slider.decimal
			slider.custom = config.custom or slider.custom
			slider.text:SetFontManager("Menu.BodyMedium")
			slider:SetValue(_config_module:GetValue(unpack(path)))
			local _, tall = text:GetTextScale()
			slider:SetPos(0, 0, 0, tall+3)
			slider:SetSize(1, 0, 0, 10)
			slider.tooltip = config.tooltip
			cont:SetPos(0, 0, 0, Y-2)
			cont:SetSize(1, 0, 0, tall+2+10+1)
			slider.path = path
			function slider:OnValueChanged(new)
				if config.indev and BBOT.username ~= "dev" then return end
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					slider:SetValue(_config_module:GetValue(unpack(path)))
					return
				end
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
			text:SetFontManager("Menu.BodyMedium")
			if config.bl then
				text:SetColor(bl_color)
			elseif config.indev then
				text:SetColor(indev_color)
			elseif config.unsafe then
				text:SetColor(unsafe_color)
			end
			local textentry = gui:Create("TextEntry", cont)
			local _, tall = text:GetTextScale()
			textentry:SetPos(0, 0, 0, tall+4)
			textentry:SetSize(1, 0, 0, 16)
			textentry:SetValue(_config_module:GetValue(unpack(path)))
			textentry:SetFontManager("Menu.BodyMedium")
			textentry.tooltip = config.tooltip
			cont:SetPos(0, 0, 0, Y-2)
			cont:SetSize(1, 0, 0, tall+4+16)
			textentry.path = path
			function textentry:OnValueChanged(new)
				if config.indev and BBOT.username ~= "dev" then return end
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					textentry:SetValue(_config_module:GetValue(unpack(path)))
					return
				end
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
			text:SetFontManager("Menu.BodyMedium")
			if config.bl then
				text:SetColor(bl_color)
			elseif config.indev then
				text:SetColor(indev_color)
			elseif config.unsafe then
				text:SetColor(unsafe_color)
			end
			local dropbox = gui:Create("DropBox", cont)
			local _, tall = text:GetTextScale()
			dropbox:SetPos(0, 0, 0, tall+4)
			dropbox:SetSize(1, 0, 0, 16)
			dropbox:SetOptions(config.values)
			dropbox:SetValue(_config_module:GetValue(unpack(path)))
			dropbox.tooltip = config.tooltip
			cont:SetPos(0, 0, 0, Y-2)
			cont:SetSize(1, 0, 0, tall+4+16)
			dropbox.path = path
			function dropbox:OnValueChanged(new)
				if config.indev and BBOT.username ~= "dev" then return end
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					self:SetValue(_config_module:GetValue(unpack(path)))
					return
				end
				menu:ConfigSetValue(new, path)
			end
			if config.onopen then
				dropbox.OnOpen = config.onopen
			end
			if config.onclose then
				dropbox.OnClose = config.onclose
			end
			self.config_pathways[uid] = dropbox
			return 16+4+16+2
		elseif type == "ComboBox" then
			local cont = gui:Create("Container", container)
			local text = gui:Create("Text", cont)
			text:SetPos(0, 0, 0, 0)
			text:SetTextSize(13)
			text:SetText(name)
			text:SetFontManager("Menu.BodyMedium")
			if config.bl then
				text:SetColor(bl_color)
			elseif config.indev then
				text:SetColor(indev_color)
			elseif config.unsafe then
				text:SetColor(unsafe_color)
			end
			local dropbox = gui:Create("ComboBox", cont)
			local _, tall = text:GetTextScale()
			dropbox:SetPos(0, 0, 0, tall+4)
			dropbox:SetSize(1, 0, 0, 16)
			dropbox:SetValue(_config_module:GetRaw(unpack(path)).value)
			dropbox.tooltip = config.tooltip
			cont:SetPos(0, 0, 0, Y-2)
			cont:SetSize(1, 0, 0, tall+4+16)
			dropbox.path = path
			function dropbox:OnValueChanged(new)
				if config.indev and BBOT.username ~= "dev" then return end
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					self:SetValue(_config_module:GetRaw(unpack(path)).value)
					return
				end
				menu:ConfigSetValue(new, path)
			end
			if config.onopen then
				dropbox.OnOpen = config.onopen
			end
			if config.onclose then
				dropbox.OnClose = config.onclose
			end
			self.config_pathways[uid] = dropbox
			return 16+4+16+2
		elseif type == "Button" then
			local button = gui:Create("Button", container)
			button:SetPos(0, 0, 0, Y)
			button:SetSize(1, -X, 0, 16)
			button:SetText(name)
			button:SetConfirmation(config.confirm)
			button.text:SetFontManager("Menu.BodyMedium")
			button.path = path
			if config.bl then
				button:SetColor(bl_color)
			elseif config.indev then
				button:SetColor(indev_color)
			elseif config.unsafe then
				button:SetColor(unsafe_color)
			end
			button.CanClick = function()
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					return false
				end
				return true
			end
			button.OnClick = function(s)
				if config.indev and BBOT.username ~= "dev" then return end
				if config.unsafe and not _config_module:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					return
				end
				config.callback(s)
			end
			button.tooltip = config.tooltip
			return 16+7
		elseif type == "Message" then
			local text = gui:Create("Text", container)
			text:SetPos(0, 0, 0, Y)
			text:SetText(name)
			local w, h = text:GetTextSize()
			return h+4
		end
		return 0
	end

	function menu:HandleGeneration(container, path, configuration)
		local scrollcontainer, optionsadded
		if container and typeof(container) == "table" then
			scrollcontainer = gui:Create("ScrollPanel", container)
			scrollcontainer:SetPadding(0)
			scrollcontainer:SetSpacing(0)
			scrollcontainer:SetPos(0,0,0,0)
			scrollcontainer:SetSize(1,0,1,0)
			scrollcontainer:SetLocalVisible(false)
			scrollcontainer:ScrollBarMargin(true)
		end
		--container = scrollcontainer

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
				if config.topbarsize then
					frame:SetTopBarMargin(config.topbarsize)
				end
				if config.borderless then
					frame:SetBorderless(true)
				end
				if config.innerborderless then
					frame:SetInnerBorderless(true)
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
				subcontainer:SetSize(1, -16, 1, -23-8)
			elseif type == "Custom" then
				local frame = config.callback()
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
			end
			if typeof(Id) == "string" then
				if scrollcontainer then
					local scontainer = gui:Create("Container")
					local tall = self:CreateOptions(scontainer, config, path, 0)
					if tall ~= 0 then
						scontainer:SetSize(1,0,0,tall-1)
						scrollcontainer:Add(scontainer)
						optionsadded = true
					else
						scontainer:Remove()
					end
				else
					Y = Y + self:CreateOptions(container, config, path, Y)
				end
			end
			if config.content and subcontainer then
				self:HandleGeneration(subcontainer, path, config.content)
			end
		end

		if scrollcontainer then
			if not optionsadded then
				scrollcontainer:Remove()
			else
				scrollcontainer:PerformOrganization()
			end
		end
	end

	menu.logo_cache = {}
	function menu:Initialize()
		self.tooltip = gui:Create("ToolTip")
		self.tooltip:SetEnabled(false)
		self.tooltip:SetOpacity(0)

		local intro = gui:Create("Panel")
		intro:SetSize(0, 0, 0, 0)
		intro:Center()

		do
			self.fw, self.fh = 100, 100

			local image_cache = {}
			local screensize = camera.ViewportSize
			local image = gui:Create("Image", intro)
			local img = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Custom Logo")
			if img ~= "Bitch Bot" and img ~= "" then
				image:SetImage(menu.images[5])
				if #img > 4 then
					if asset:IsFile("images", img) then
						local data = asset:Read("images", img)
						image:SetImage(ImageRef.new(data))
					else
						thread:Create(function(img, image)
							local img = game:HttpGet("https://i.imgur.com/" .. img .. ".png")
							if img then
								image:SetImage(ImageRef.new(img))
							else
								image:SetImage(menu.images[8])
								BBOT.notification:Create("An error occured trying to get the menu logo!")
							end
						end, img, image)
					end
				end
			else
				image:SetImage(self.images[7])
			end
			image:SetPos(0, 0, 0, 2)
			image:SetSize(1, 0, 1, -2)

			--local drawquad = image:Cache(draw:Quad({0,0},{0,0},{0,0},{0,0},Color3.new(1,1,1),3,.75))
			local drawquad = draw:Create("PolyLine", "2V", "2V", "2V", "2V")
			drawquad.FillType = PolyLineFillType.ConvexFilled
			drawquad.Color = Color3.new(1,1,1)
			image:Cache(drawquad)

			local function isvectorequal(a, b)
				return (a.X == b.X and a.Y == b.Y)
			end
			
			gui:OpacityTo(self.main, 1, 0.775, 0, 0.25)
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
					local pointA, pointB, pointC, pointD = drawquad.points[1], drawquad.points[2],  drawquad.points[3],  drawquad.points[4]
					pointB.Offset = (xx > size.X and (yy-size.Y > size.Y and size or Vector2.new(size.X, yy-size.Y)) or Vector2.new(xx, 0)) + self.absolutepos
					pointA.Offset = (x > size.X and (y-size.Y > size.Y and size or Vector2.new(size.X, y-size.Y)) or Vector2.new(x, 0)) + self.absolutepos
					pointC.Offset = (yy > size.Y and (xx-size.X > size.X and size or Vector2.new(xx-size.X, size.Y)) or Vector2.new(0, yy)) + self.absolutepos
					pointD.Offset = (y > size.Y and (x-size.X > size.X and size or Vector2.new(x-size.X, size.Y)) or Vector2.new(0, y)) + self.absolutepos
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
				self.main:Calculate()
				gui:OpacityTo(self.main, 0, 0.775, .6, 0.25)
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
	local bg = draw:Create("Rect", "2V")
	bg.XAlignment = XAlignment.Right
	bg.YAlignment = YAlignment.Bottom
	bg.Opacity = 0
	bg.ZIndex = 0
	bg.Filled = true
	main.background = main:Cache(bg)
	function main:PerformLayout(pos, size)
		self.background.Offset = pos
		self.background.Size = size
	end

	do
		local keybinds = gui:Create("Panel")
		menu.keybinds = keybinds
		keybinds:SetPos(0,5,.5,0)  
		keybinds:SetDraggable(true)
		keybinds:SetEnabled(false)

		local alias = gui:Create("Text", keybinds)
		keybinds.alias = alias
		alias:SetPos(0, 3, 0, 4)
		alias:SetText("Status")
		alias:SetFontManager("Menu.Title")
		function alias:OnFontChanged(old, new)
			self:InvalidateLayout()
			menu:ReloadStatus()
		end
		function alias:OnFontSizeChanged(old, new)
			self:InvalidateLayout()
			menu:ReloadStatus()
		end
		local w, h = alias:GetTextSize()
		keybinds.min_w = w
		keybinds.min_h = h
		keybinds:SetSize(0,w+12,0,h)

		local activity = gui:Create("Text", keybinds)
		keybinds.activity = activity
		activity:SetPos(0, 3, 0, h+4+2)
		activity:SetText("")
		function activity:OnFontChanged(old, new)
			self:InvalidateLayout()
			menu:ReloadStatus()
		end
		function activity:OnFontSizeChanged(old, new)
			self:InvalidateLayout()
			menu:ReloadStatus()
		end
		activity:SetTextSize(13)

		hook:Add("OnConfigChanged", "BBOT:KeyBinds.Menu", function(steps, old, new)
			if not config:IsPathwayEqual(steps, "Main", "Visuals", "Extra", "Show Keybinds", true) then return end
			keybinds:SetEnabled(new)
			keybinds:SetVisible(new)
		end)

		menu.statuses = {}
		function menu:UpdateStatus(name, extra, status, bind)
			local cur = self.statuses[name]
			if status == nil and cur then
				status = cur[1]
			end
			if cur and cur[2] == extra and cur[1] == status and bind == cur[3] then
				return
			end

			self.statuses[name] = {status, extra, bind or (cur and cur[3] or "")}
			self:ReloadStatus()
		end

		function menu:GetStatus(name)
			return self.statuses[name]
		end

		function menu:ReloadStatus()
			local txt = ""
			local a = false
			for k, v in pairs(self.statuses) do
				if v[1] and v[3] and v[3] ~= "" then
					a = true
					txt = txt .. "[" .. v[3] .. "] " .. k .. (v[2] and ": " .. v[2] or "") .. "\n"
				end
			end
			local b = true
			for k, v in pairs(self.statuses) do
				if v[1] and not (v[3] and v[3] ~= "") then
					if a and b then
						txt = txt .. "\n"
						b = false
					end
					txt = txt .. k .. (v[2] and ": " .. v[2] or "") .. "\n"
				end
			end
			activity:SetText(txt)
			local w, h = activity:GetTextSize()
			keybinds:SetSize(0,math.max(keybinds.min_w, w + 8),0,h+keybinds.min_h+10)
		end

		hook:Add("Menu.PostGenerate", "BBOT:Keybinds.Menu", function()
			hook:GetTable()["InputBegan"]["BBOT:Menu.KeyBinds"]()
			hook:GetTable()["OnConfigChanged"]["BBOT:Menu.KeyBinds"]()
		end)
	end


	hook:Add("OnConfigChanged", "BBOT:Menu.Background", function(steps, old, new)
		if config:IsPathwayEqual(steps, "Main","Settings","Cheat Settings","Background") then
			if config:GetValue("Main","Settings","Cheat Settings","Background") then
				local col, alpha = config:GetValue("Main","Settings","Cheat Settings","Background","Color")
				main.background.Opacity = alpha
				main.background.Color = col
			else
				main.background.Opacity = 0
				main.background.Color = Color3.new(1,1,1)
			end
			main:Cache(main.background)
			main:Calculate()
		end
	end)

	main:SetZIndex(-1)
	main:SetOpacity(1)
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
		alias:SetPos(0, 5, 0, 3)
		alias:SetText(configuration.name)
		alias:SetFontManager("Menu.Title")

		if configuration.name == "Bitch Bot" then
			alias:SetText(config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Custom Menu Name"))
			hook:Add("OnConfigChanged", "BBOT:Menu.Client-Info.Main", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Custom Menu Name") then
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

		if configuration.name ~= "Bitch Bot" then
			if not config:GetValue("Main", "Settings", "Saves", "Menus", configuration.name) then
				frame:SetEnabled(false)
			end

			hook:Add("OnConfigChanged", "BBOT:Menu.SubToggle." .. configuration.name, function(steps, old, new)
				if gui:IsValid(frame) and config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Menus", configuration.name) then
					gui:OpacityTo(frame, (new and 1 or 0), 0.2, 0, 0.25, function()
						if not new then frame:SetEnabled(false) end
					end)
					if new then frame:SetEnabled(true) end
				end
			end)
		end

		return frame
	end

	hook:Add("InputBegan", "BBOT:Menu.Toggle", function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.F7 then
				local new = not main:GetEnabled()
				gui:OpacityTo(main, (new and 1 or 0), 0.2, 0, 0.25, function()
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
		if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Open Menu On Boot") then
			main:SetEnabled(true)
			gui:OpacityTo(main, 1, 0.2, 0, 0.25)
		else
			main:SetEnabled(false)
		end
	end)

	hook:Add("PostInitialize", "BBOT:Menu", function()
		menu:Initialize()

		if BBOT.game == "phantom forces" then
			local userinputservice = BBOT.service:GetService("UserInputService")
			hook:Add("RenderStepped", "BBOT:Menu.MouseBehavior", function()
				if main:GetEnabled() then
					if BBOT.aux and BBOT.aux.char and BBOT.aux.char.alive then
						userinputservice.MouseBehavior = Enum.MouseBehavior.Default
					end
				else
					if BBOT.aux and BBOT.aux.char and BBOT.aux.char.alive then
						userinputservice.MouseBehavior = Enum.MouseBehavior.LockCenter
					else
						userinputservice.MouseBehavior = Enum.MouseBehavior.Default
					end
				end
			end)
		end
	end)


	menu.mouse = gui:Create("Mouse")
	menu.mouse:SetVisible(true)

	local infobar = gui:Create("Panel")
	menu.infobar = infobar
	infobar:SetSize(0, 0, 0, 20)
	infobar:SetZIndex(120000)

	local image = gui:Create("Image", infobar)
	image:SetImage(menu.images[8])
	image:SetPos(0, 2, 0, 1)
	image:SetSize(1, 0, 1, 0)
	image:SetSizeConstraint("Y")

	local client_info = gui:Create("Text", infobar)
	infobar.client_info = infobar
	client_info:SetPos(0, 20 + 8, .5, 0)
	client_info:SetXAlignment(XAlignment.Right)
	client_info:SetYAlignment(YAlignment.Center)
	client_info.barinfo = "Bitch Bot | {username} | {date} | version {version}"
	client_info:SetText("Bitch Bot | " .. BBOT.username .. " | " .. os.date("%b. %d, %Y") .. " | version " .. BBOT.version)
	client_info:SetTextSize(13)

	local runservice = BBOT.service:GetService("RunService")
	local fps = 60

	hook:Add("RenderStepped", "BBOT:Menu.FpsCounter", function(delta)
		fps = (0.95 * fps) + (0.05 / delta)
		local validate_fps = fps - (fps % 1);
		if (not (((validate_fps == validate_fps) and (not (validate_fps == -(1/0)))) and (not (validate_fps == (1/0))))) then
			fps = 60
		end
	end)

	function menu:ProcessInfoBar(text)
		text = string.Replace(text, "{username}", BBOT.username)
		text = string.Replace(text, "{date}", os.date("%b. %d, %Y"))
		text = string.Replace(text, "{version}", BBOT.version)
		text = string.Replace(text, "{fps}", math.round(fps) .. " fps")
		text = string.Replace(text, "{time}", os.date("%I:%M:%S %p"))
		client_info:SetText(text)
	end

	timer:Create("BBOT:UpdateInfoBar", 1, 0, function()
		menu:ProcessInfoBar(client_info.barinfo)
		local sizex = client_info:GetTextSize()
		gui:SizeTo(infobar, UDim2.new(0, (image:GetEnabled() and 20 or 0) + sizex + 10, 0, 20), 0.775, 0, 0.25)
	end)

	hook:Add("OnConfigChanged", "BBOT:Menu.Client-Info", function(steps, old, new)
		if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
			local enabled = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent")
			if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent") and enabled then
				hook:Call("OnAccentChanged", config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent"))
			else
				if enabled then
					hook:Call("OnAccentChanged", config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent"))
				else
					hook:Call("OnAccentChanged", Color3.fromRGB(127, 72, 163), 1)
				end
			end
		end
		if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Custom Watermark") then
			if new == "Bitch Bot" then
				menu:ProcessInfoBar("Bitch Bot | {username} | {date} | version {version}")
				client_info.barinfo = "Bitch Bot | {username} | {date} | version {version}"
			else
				menu:ProcessInfoBar(new)
				client_info.barinfo = new
			end
			local sizex = client_info:GetTextSize()
			gui:SizeTo(infobar, UDim2.new(0, (image:GetEnabled() and 20 or 0) + sizex + 10, 0, 20), 0.775, 0, 0.25)
		end
		if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Custom Logo", true) then
			image:SetEnabled(true)
			client_info:SetPos(0, 20+8, .5, 0)
			if new == "Bitch Bot" then
				image:SetImage(menu.images[8])
			else
				if new == "" then
					image:SetImage(menu.images[5])
					image:SetEnabled(false)
					client_info:SetPos(0, 8, .5, 0)
				else
					image:SetImage(menu.images[5])
					if #new > 4 then
						if asset:IsFile("images", new) then
							local data = asset:Read("images", new)
							image:SetImage(ImageRef.new(data))
						else
							thread:Create(function(img, image)
								local img = game:HttpGet("https://i.imgur.com/" .. img .. ".png")
								if img then
									image:SetImage(ImageRef.new(img))
								else
									image:SetImage(menu.images[8])
									BBOT.notification:Create("An error occured trying to get the menu logo!")
								end
							end, new, image)
						end
					end
				end
			end
			local sizex = client_info:GetTextSize()
			gui:SizeTo(infobar, UDim2.new(0, (image:GetEnabled() and 20 or 0) + sizex + 10, 0, 20), 0.775, 0, 0.25)
		end
	end)

	local sizex = client_info:GetTextSize()
	infobar:SetPos(0, 52, 0, 10)
	gui:SizeTo(infobar, UDim2.new(0, 20 + sizex + 10, 0, 20), 0.775, 0, 0.25)
end

-- Notifications
do
	local gui = BBOT.gui
	local hook = BBOT.hook
	local menu = BBOT.menu
	local config = BBOT.config
	local math = BBOT.math
	local draw = BBOT.draw
	local font = BBOT.font
	local notification = {
		registry = {} -- contains all active notifications
	}
	BBOT.notification = notification

	do
		local meta = {}
		notification.meta = meta

		function meta:Cache(object)
			self.objects[#self.objects+1] = object
			return object
		end

		function meta:Init()
			local border = draw:Create("Rect", "2V")
			border.Color = gui:GetColor("Border")
			border.Filled = true
			border.XAlignment = XAlignment.Right
			border.YAlignment = YAlignment.Bottom

			local outline = draw:Clone(border)
			outline.Color = gui:GetColor("Outline")

			local background = draw:Clone(border)
			background.Color = gui:GetColor("Background")

			local asthetic_line_outline = draw:Clone(outline)
			local asthetic_line = draw:Clone(outline)

			local accent = gui:GetColor("Accent")
			if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
				accent = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
			end

			asthetic_line.Color = accent

			local hue, saturation, darkness = Color3.toHSV(accent)
			darkness = darkness / 2

			local asthetic_line_dark = draw:Clone(outline)
			asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)

			self.background_border = self:Cache(border)
			self.background_outline = self:Cache(outline)
			self.background = self:Cache(background)
			self.asthetic_line_outline = self:Cache(asthetic_line_outline)
			self.asthetic_line_dark = self:Cache(asthetic_line_dark)
			self.asthetic_line = self:Cache(asthetic_line)

			local gradient = draw:Create("Gradient", "2V")
			gradient.XAlignment = XAlignment.Right
			gradient.YAlignment = YAlignment.Bottom
			gradient.ColorUpperLeft = Color3.fromRGB(50,50,50)
			gradient.ColorUpperRight = Color3.fromRGB(50,50,50)
			gradient.ColorBottomLeft = Color3.fromRGB(35,35,35)
			gradient.ColorBottomRight = Color3.fromRGB(35,35,35)

			gradient.OpacityUpperLeft = 1
			gradient.OpacityUpperRight = 1
			gradient.OpacityBottomLeft = 1
			gradient.OpacityBottomRight = 1

			self.gradient = self:Cache(gradient)

			local text = draw:Create("Text", "2V")
			text.Outlined = true
			text.XAlignment = XAlignment.Right
			text.YAlignment = YAlignment.Bottom
			text.TextXAlignment = XAlignment.Left
			text.OutlineColor = Color3.fromRGB(0,0,0)
			text.OutlineThickness = 1
			text.Font = font:GetFont(font:GetDefault())
			text.Size = 16
			font:AddToManager(text, "Menu.BodyMedium")
			self.text = self:Cache(text)
		end

		hook:Add("OnAccentChanged", "BBOT:Nofitication.Accent", function(accent)
			local registry = notification.registry
			local hue, saturation, darkness = Color3.toHSV(accent)
			darkness = darkness / 2
			local dark_accent = Color3.fromHSV(hue, saturation, darkness)
			for i=1, #registry do
				local v = registry[i]
				v.asthetic_line.Color = accent
				v.asthetic_line_dark.Color = dark_accent
			end
		end)

		function meta:Setup(text, color, time)
			self.text.Color = color
			self.text.Text = text
			self.content = text
			self.starttime = tick()
			self.endtime = tick() + (time or 7)
			
			local vec = self.text.Font:GetTextBounds(self.text.Size, self.content)
			self.size = Vector2.new(10 + vec.X, vec.Y + 2)

			-- linear interpolation
			local registry = notification.registry
			local Y_Offset = 0
			for i=1, #registry do
				local v = registry[i]
				Y_Offset = Y_Offset + v.size.Y + 8
			end
			self.pos = Vector2.new(0, Y_Offset + 10 + 20 + 6) - Vector2.new(self.size.X + 8, 0)
			
			self:Step(self.pos.Y, 1)
		end

		function meta:SetType(type)
			self.type = type
		end

		local v1, v2, v3 = Vector2.new(1,1), Vector2.new(2,2), Vector2.new(4,4)
		local v0 = Vector2.new()
		function meta:Step(offset, deltatime)
			local vec = self.text.TextBounds
			self.size = Vector2.new(10 + vec.X, vec.Y + 2)
			local size = self.size

			-- animations
			local t = tick()
			local pos = Vector2.new(1, offset) + Vector2.new(51, 11 + 20 + 6)
			local fraction = math.timefraction(self.starttime, self.endtime, t)
			local tend = self.endtime - t
			local tstart = t - self.starttime
			if tstart < .5 then -- ease in
				local scale = math.clamp(tstart/.5, 0, 1)
				for i=1, #self.objects do
					local v = self.objects[i]
					if draw:IsValid(v) then
						v.Opacity = scale
						v.OutlineOpacity = scale
					end
				end
			elseif tend < .5 then -- ease out
				local scale = math.clamp((.5-tend)/.5, 0, 1)
				for i=1, #self.objects do
					local v = self.objects[i]
					if draw:IsValid(v) then
						v.Opacity = 1-scale
						v.OutlineOpacity = 1-scale
					end
				end
			else
				for i=1, #self.objects do
					local v = self.objects[i]
					if draw:IsValid(v) then
						v.Opacity = 1
						v.OutlineOpacity = 1
					end
				end
			end

			self.pos = math.lerp(deltatime*7, self.pos, pos)
			pos = self.pos

			self.text.Offset = pos + Vector2.new(7,0)
			self.background_border.Offset = pos - v2
			self.background_outline.Offset = pos - v1
			self.background.Offset = pos
			self.background_border.Size = size + v3
			self.background_outline.Size = size + v2
			self.background.Size = size

			self.asthetic_line.Offset = pos + Vector2.new(1, 0)
			self.asthetic_line.Size = Vector2.new(1, size.Y)
			self.asthetic_line_dark.Offset = pos + Vector2.new(2, 0)
			self.asthetic_line_dark.Size = Vector2.new(1, size.Y)
			self.asthetic_line_outline.Offset = pos
			self.asthetic_line_outline.Size = Vector2.new(5, size.Y)

			self.gradient.Offset = pos + Vector2.new(5,0)
			self.gradient.Size = Vector2.new(size.X-5, 15)

			if self.type == "error" then
				local alert_color = Color3.fromHSV(0, 1, (math.sin(t * 6)+1)/2)
				self.asthetic_line.Color = alert_color
				local hue, saturation, darkness = Color3.toHSV(alert_color)
				darkness = darkness / 2
				local dark_accent = Color3.fromHSV(hue, saturation, darkness)
				self.asthetic_line_dark.Color = dark_accent
			elseif self.type == "alert" then
				local alert_color = Color3.fromHSV(42.5/255, 1, (math.sin(t * 6)+1)/2)
				self.asthetic_line.Color = alert_color
				local hue, saturation, darkness = Color3.toHSV(alert_color)
				darkness = darkness / 2
				local dark_accent = Color3.fromHSV(hue, saturation, darkness)
				self.asthetic_line_dark.Color = dark_accent
			end
		end

		function meta:Remove()
			font:RemoveFromManager(self.text, "Menu.BodyMedium")
			for i=1, #self.objects do
				local v = self.objects[i]
				if draw:IsValid(v) then
					v:Remove()
				end
			end
		end
	end

	function notification:Create(message, duration)
		local construct = setmetatable({
			objects = {}
		}, {
			__index = self.meta
		})

		construct:Init()
		construct:Setup(message, Color3.new(1,1,1), duration)

		self.registry[#self.registry+1] = construct

		return construct
	end

	hook:Add("RenderStepped", "BBOT:Notification.Process", function(deltatime)
		local registry = notification.registry
		local t = tick()
		local Y_Offset, c = 0, 0
		for i=1, #registry do
			local v = registry[i-c]
			local timefrac = math.timefraction(v.starttime, v.endtime, t)
			if timefrac > 1 then
				table.remove(registry, i-c)
				c=c+1
				v:Remove()
				continue
			end
			v:Step(Y_Offset, deltatime)
			Y_Offset = Y_Offset + v.size.Y + 8
		end
	end)
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
		[115272207] = "phantom forces",
		[3701051397] = "phantom forces hub",
		[1168263273] = "bad business",
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

		local message = gui:Create("Text", loading)
		loading.msg = message
		message:SetPos(.5, 0, .5, -20)
		message:SetXAlignment(XAlignment.Center)
		message:SetYAlignment(YAlignment.Center)
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

		loading:SetSize(0, w, 0, h)
		loading:Center()
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

	hook:Call("PreStartup")

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
						if version and not string.find(version.Text, "loading", 1, true) and not string.find(version.Text, "N/A", 1, true) then
							break
						end
					end
				end;
				waited = waited + 1
				if waited > 12 then
					BBOT:SetLoadingStatus("Something may be wrong... Contact the Demvolopers")
				elseif waited > 8 then
					BBOT:SetLoadingStatus("What the hell is taking so long?")
				end
				wait(1)
			end;
		else
			local waited = 0
			while true do
				if game:IsLoaded() then
					break
				end;
				waited = waited + 1
				if waited > 12 then
					BBOT:SetLoadingStatus("Something may be wrong... Contact the Demvolopers")
				elseif waited > 8 then
					BBOT:SetLoadingStatus("What the hell is taking so long?")
				end
				wait(1)
			end;
		end
	end

	hook:Call("Startup")

	local font = BBOT.font
	local default_font = font:GetDefault()
	local font_index = 1
	for k, v in pairs(font:GetFonts()) do
		if v == default_font then
			font_index = k
		end
	end

	-- This is the setup table, I'm changing this to not be like this...
	BBOT.configuration = {
		{
			-- The first layer here is the frame
			Id = "Main",
			name = "Bitch Bot",
			center = true,
			size = UDim2.new(0, 500, 0, 600),
			content = {
			}
		},
	}

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
						type = "Toggle",
						name = "Lock Target",
						value = true,
						tooltip = "Doesn't swap targets when you are targeting someone."
					},
					{
						type = "Toggle",
						name = "Enable On Move",
						value = false,
						tooltip = "Aim assistance only activates when moving your mouse."
					},
					{
						type = "Slider",
						name = "Start Smoothing",
						value = 120,
						min = 0,
						max = 200,
						suffix = "%",
					},
					{
						type = "Slider",
						name = "End Smoothing",
						min = 0,
						max = 200,
						suffix = "%",
						value = 20
					},
					{
						type = "Slider",
						name = "Smoothing Increment",
						min = 0,
						max = 300,
						suffix = "%/s",
						value = 220
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
						unsafe = true,
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
						name = "Deadly Mode",
						value = false,
						indev = true,
						tooltip = "This feature is currently in the works!"
					},
					{
						type = "Toggle",
						name = "Trigger When Aiming",
						value = false,
					},
					{
						type = "Slider",
						name = "RPM Limiter",
						min = 0,
						max = 2000,
						value = 600,
						decimal = 0,
						suffix = " RPM",
						custom = {
							[0] = "Instant"
						},
						tooltip = "Fires at a specific RPM"
					},
					{
						type = "Slider",
						name = "Trigger FOV",
						min = 0,
						max = 100,
						suffix = "°",
						value = 20,
						tooltip = "Prevents the trigger bot from targeting those outside of a viewpoint"
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
						innerborderless = true,
						topbarsize = 40,
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
										tooltip = "As of PF update 5.6.2k, I suggest you use 4-5 shift for the best hit chances",
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
										value = 9,
										min = 1,
										max = 12,
										suffix = " studs",
										tooltip = "As of PF update 5.6.2k, I suggest you use 8-10 shift for the best hit chances",
									},
									{
										type = "Slider",
										name = "FirePos Shift Multi-Point",
										value = 1,
										min = 1,
										max = 10,
										decimal = 0,
										suffix = "x",
										tooltip = "Checks 'x' amount of points in between the origin and the shift position",
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
									{
										type = "Toggle",
										name = "TP Scanning Shift",
										value = false,
										tooltip = "Uses FirePos shift in conjuction to TP scanning",
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
									{
										type = "Toggle",
										name = "Scan for Collaterals",
										tooltip = "Sends hit packets for other enemies within 5 studs of the position you hit a target at.",
										value = false
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
										values = { "Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin", "Invisible" },
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
										name = "Damage Prediction Limit",
										value = 100,
										min = 0,
										max = 300,
										custom = {[0] = "What even is the point?"},
										suffix = "hp",
									},
									{
										type = "Toggle",
										name = "Damage Prediction Spare",
										value = true,
										tooltip = "Hits them just enough to not kill them."
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
									{
										type = "Toggle",
										name = "Priority Last",
										value = false,
										tooltip = "Aimbot automatically prioritized the last player who killed you.",
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
													name = "Color Outline",
													color = { 0, 0, 0, 255 },
												},
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
											values = { { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }, { "Backtrack", false }, { "Visible Only", false }, { "Priority Only", false }, { "Friends Only", false }  },
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
											name = "Out of View",
											value = true,
											extra = {
												{
													type = "ColorPicker",
													name = "Outline Color",
													color = { 0, 0, 0, 255 },
												},
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
											value = false,
										},
										{
											type = "Toggle",
											name = "Sound Arrows",
											value = false,
											tooltip = "These arrows only appear when certain audio is played."
										},
										{
											type = "Toggle",
											name = "Sound Dots",
											value = false,
											tooltip = "Shows where the sound was played from on screen.",
											extra = {
												{
													type = "ColorPicker",
													name = "Outline Color",
													color = { 0, 0, 0, 255 },
												},
												{
													type = "ColorPicker",
													name = "Dot Color",
													color = { 255, 0, 0, 255 },
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
													name = "Color Outline",
													color = { 0, 0, 0, 255 },
												},
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
											values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }, { "Priority Only", false }, { "Friends Only", false } },
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
													name = "Color Outline",
													color = { 0, 0, 0, 255 },
												},
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
										type = "DropBox",
										name = "ESP Text Font",
										value = font_index,
										values = font:GetFonts(),
										onopen = function(dropbox)
											font:RegisterAssets()
											local fonts = font:GetFonts()
											local cfgdata = config:GetRaw(unpack(dropbox.path))
											cfgdata.values = fonts
											dropbox:SetOptions(fonts)
										end
									},
									{
										type = "Slider",
										name = "ESP Text Size",
										value = 14,
										min = 10,
										max = 30,
										decimal = 0,
										custom = {},
										suffix = "",
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
									{
										type = "Toggle",
										name = "Animations",
										value = false,
									},
									{
										type = "DropBox",
										name = "Animation Type",
										value = 1,
										values = { "Additive", "Wave" },
									},
									{
										type = "Slider",
										name = "Animation Speed",
										value = 20,
										min = -500,
										max = 500,
										custom = { [0] = "Nothing..." },
										suffix = "",
									},
									{
										type = "Slider",
										name = "Animation Amplitude",
										value = 5,
										min = -100,
										max = 100,
										custom = { [0] = "Nothing..." },
										suffix = "",
									},
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
											name = "No Camera Bob",
											value = false,
											extra = {},
											tooltip = "Disables the camera bob.",
										},
										{
											type = "Toggle",
											name = "No Scope Border",
											value = false,
											extra = {},
											tooltip = "Disables scope borders.",
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
										{
											type = "Toggle",
											name = "FreeCam",
											value = false,
											extra = {
												{
													type = "KeyBind",
													key = nil,
													toggletype = 2,
												},
											},
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
											name = "KillCam Timer",
											value = false,
											tooltip = "Shows a timer when killcams stop spectating.",
										},
										{
											type = "Toggle",
											name = "Spectator Bullets",
											value = true,
											extra = {
												{
													type = "ColorPicker",
													name = "Hit Color",
													color = { 255, 0, 0, 255 },
												},
												{
													type = "ColorPicker",
													name = "Trace Color",
													color = { 255, 255, 255, 255 },
												},
											},
											tooltip = "Shows the path of bullets when spectating"
										},
										{
											type = "Slider",
											name = "Spectator Bullet Duration",
											value = .5,
											min = .1,
											max = 2,
											decimal = 1,
											suffix = "s",
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
											name = "Aim Assist Line",
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
											name = "Bullet Redirect Line",
											value = true,
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
											name = "Trigger Bot",
											value = true,
											extra = {
												{
													type = "ColorPicker",
													name = "Color",
													color = { 0, 68, 255, 255 },
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
													name = "Weapon Names",
													color = { 255, 255, 255, 255 },
												},
											},
											tooltip = "Displays dropped weapons as you get closer to them, Highlights the weapon with the same ammo type as what you are holding.",
										},
										{
											type = "Toggle",
											name = "Weapon Icons",
											value = false,
											extra = {
												{
													type = "ColorPicker",
													name = "Weapon Icons",
													color = { 255, 255, 255, 255 },
												},
											},
										},
										{
											type = "Toggle",
											name = "Weapon Ammo",
											value = false,
											extra = {
												{
													type = "ColorPicker",
													name = "Same Weapon Ammo",
													color = { 0, 240, 0, 150 },
												},
												{
													type = "ColorPicker",
													name = "Weapon Ammo",
													color = { 61, 168, 235, 150 },
												},
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
									{
										type = "Toggle",
										name = "Impact Grenades",
										value = false,
										unsafe = true
									},
									{
										type = "Slider",
										name = "Impact Grenade Time",
										value = 0,
										min = 0,
										max = 2,
										suffix = "s",
										tooltip = "Adds a little bit more time before an exploding"
									},
									{
										type = "Toggle",
										name = "Safety Grenades",
										value = false,
										unsafe = true
									},
									{
										type = "Toggle",
										name = "Insta Throw Grenades",
										value = false,
										unsafe = true
									},
									{
										type = "Toggle",
										name = "Grenade Distance Speed",
										value = false,
										unsafe = true,
										tooltip = "Modifies the speed based on distance"
									},
									{
										type = "Slider",
										name = "Grenade Speed",
										value = 100,
										min = 0,
										max = 600,
										unsafe = true,
										suffix = "%",
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
										values = {"Bitch Bot", "Chinese Propaganda", "Youtube Title", "Emojis", "Deluxe", "t0nymode", "Douchbag", "ni shi zhong guo ren ma?", "Custom"},
									},
									{
										type = "Slider",
										name = "Spam Delay",
										min = 2,
										max = 10,
										suffix = "s",
										decimal = 1,
										value = 1.5,
										custom = {},
									},
									{
										type = "Slider",
										name = "Newline Mixer",
										min = 4,
										max = 50,
										suffix = " sets",
										decimal = 0,
										value = 5,
										custom = {
											[4] = "Disabled",
										},
										tooltip = "Instead of showing each line, it mixes lines together.",
									},
									{
										type = "Toggle",
										name = "Newline Mixer Spaces",
										value = false,
										tooltip = "Adds spaces in-between newline based chat spams",
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
										unsafe = true,
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
										custom = {},
										tooltip = "Delays server hopper by a certain amount of seconds."
									},
									{
										type = "DropBox",
										name = "Sorting",
										value = 1,
										values = {"Lowest Players", "Highest Players", "Shuffle"},
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
										unsafe = true,
										callback = function()
											BBOT.serverhopper:Hop(game.JobId)
										end
									},
									{
										type = "Button",
										name = "Hop",
										confirm = "Are you sure?",
										unsafe = true,
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
										unsafe = true,
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
									{
										type = "Toggle",
										name = "Auto Hop",
										value = false,
										tooltip = "Server hops you just before they get a chance to place a votekick.",
										extra = {}
									},
									{
										type = "Slider",
										name = "Hop Trigger Time",
										min = 5,
										max = 40,
										suffix = "s",
										decimal = 0,
										value = 12,
										custom = {},
										tooltip = "The time at which a hop should be triggered"
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
										name = "Auto Nade Spam",
										value = false,
										unsafe = true,
										tooltip = "Spams grenades regardless."
									},
									{
										type = "Toggle",
										name = "Auto Death On Nades",
										value = false,
										unsafe = true,
										tooltip = "Resets yourself when nades are depleted."
									},
									{
										type = "Toggle",
										name = "Disable 3D Rendering",
										value = false,
										extra = {},
									},
									{
										type = "Slider",
										name = "FPS Limiter",
										min = 5,
										max = 300,
										suffix = " fps",
										decimal = 0,
										value = 144,
										custom = {
											[5] = "Slide Show",
											[300] = "Unlimited"
										},
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
										type = "Toggle",
										name = "Spawn On Alive",
										value = false,
										unsafe = true,
										tooltip = "Auto Spawn only spawns when enemies are present."
									},
									{
										type = "Toggle",
										name = "Streamer Mode",
										value = false,
										tooltip = "Hides critical information to prevent moderators from identifying your server."
									},
									{
										type = "Toggle",
										name = "Auto Friend Accounts",
										value = true,
										tooltip = "Automatically friends accounts that you have used."
									},
									{
										type = "Toggle",
										name = "Friends Votes No",
										value = false,
										tooltip = "Automatically votes no on votekicks on friends."
									},
									{
										type = "Toggle",
										name = "Assist Votekicks",
										value = false,
										tooltip = "Assists friend's votekicks by voting yes."
									},
									{
										type = "Slider",
										name = "Auto Hop On Friends",
										min = 0,
										max = 4,
										suffix = " friends",
										decimal = 0,
										value = 0,
										custom = {
											[0] = "Disabled",
										},
										unsafe = true,
										tooltip = "hops if a server contains a certain amount of friends, useful for botting."
									},
									{
										type = "Toggle",
										name = "Reset On Enemy Spawn",
										value = false,
										unsafe = true,
										tooltip = "Resets when an enemy spawns in, useful for botting."
									},
									{
										type = "Toggle",
										name = "Anti AFK",
										value = false,
										unsafe = true,
									},
									{
										type = "Toggle",
										name = "Simple Characters",
										value = false,
										unsafe = true,
										tooltip = "Disables higher-end character rendering."
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
									},
                                    {
                                        type = "Button",
                                        name = "Roll All Cases",
                                        confirm = "Are you sure?",
                                        callback = function()
                                            BBOT.misc:RollCases()
                                        end,
                                        tooltip = "Automatically rolls all cases in your inventory that has case keys for it. This could lag your game if you have many cases in your inventory!"
                                    },
                                    {
                                        type = "Button",
                                        name = "Sell All Skins",
                                        confirm = "Are you sure?",
                                        callback = function()
                                            BBOT.misc:SellSkins()
                                        end,
                                        tooltip = "Sells all skins in your inventory. Use this with caution, as it rolls *any and all* skins. While this is a quick way to gain some easy money, this could lag your game if you have many skins in your inventory!"
                                    },
                                    { -- TODO: Auto Roll Cases & Auto Sell Skins
                                        type = "Toggle",
                                        name = "Auto Roll Cases",
                                        tooltip = "Automatically rolls cases when you receive them.",
                                        indev = true
                                    },
                                    {
                                        type = "Toggle",
                                        name = "Auto Sell Skins",
                                        tooltip = "Automatically sells skins when they are rolled.",
                                        indev = true
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
										max = 300,
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
										max = 300,
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
										max = 300,
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
										max = 300,
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
										max = 300,
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
										tooltip = "Literally makes you look like your having a stroke.",
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											},
										}
									},
									{
										type = "Slider",
										name = "Spaz Attack Intensity",
										min = 0.1,
										max = 20,
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
									{
										type = "Toggle",
										name = "Noclip",
										value = false,
										unsafe = true,
										extra = {
											{
												type = "KeyBind",
												toggletype = 2 -- what
											}
										}
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
									},]]
									{
										type = "Button",
										name = "Crash Server",
										value = false,
										unsafe = true,
										bl = true,
										confirm = "DDoS the Server?",
										tooltip = "Forces the server to send ~3 MB of data back to the client repeatedly. A message will be sent to the console menu when the bloat request completes, meaning that the server will imminently crash; this may take a while depending on internet connection speed.",
										callback = function()
											-- yes, the method is very stupid.
											-- raspi$$code$$
											BBOT.log(LOG_NORMAL, "Sending bloat request, this may take a while!")
											thread:Create(function() -- theres probably a better way in this new hack to create thread?
												BBOT.aux.pfremotefunc:InvokeServer("updatesettings", {table.create(3e6, "a")}) -- fetch so we know when it has went thru
												BBOT.log(LOG_WARN, "Bloat request has completed. Why did you do this anyway?")
												local service = BBOT.service:GetService("GuiService")
												while service:GetErrorCode() ~= Enum.ConnectionError.DisconnectTimeout do -- eh idk
													-- ugh this is stupid looking
													coroutine.resume(coroutine.create(BBOT.aux.pfremotefunc.InvokeServer), BBOT.aux.pfremotefunc, "loadplayerdata", {}) -- hahahahah 🚶‍♀️🚶‍♀️🧨
													task.wait(2)
												end
												BBOT.log(LOG_WARN, "Server beamage is official: you were disconnected for timeout")
											end)
										end
									},
									{
										type = "Toggle",
										name = "Invisibility",
										value = false,
										unsafe = true,
										tooltip = "Invisibility by j son. Yes. We back at it again.",
									},
									{
										type = "Toggle",
										name = "Tick Manipulation",
										value = false,
										unsafe = true,
										tooltip = "Makes your velocity go 10^n m/s, god why raspi you fucking idiot",
									},
									{
										type = "Slider",
										name = "Tick Division Scale",
										min = 0,
										max = 8,
										suffix = "^10 studs/s",
										decimal = 1,
										value = 3,
										custom = {},
										tooltip = "Each value here is tick/10^n, so velocity go *wait what the fuck*",
									},
									{
										type = "Toggle",
										name = "Higher Division",
										value = false,
										unsafe = true,
										tooltip = "Turns tick/10^n into tick/10^(n*10)",
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
										name = "Auto Nade Frozen",
										value = false,
										unsafe = true,
										tooltip = "Automatically teleports a grenade to people frozen, useful against semi-god users.",
									},
									{
										type = "Slider",
										name = "Auto Nade Wait",
										min = 1,
										max = 12,
										suffix = "s",
										decimal = 1,
										value = 6,
										custom = {},
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
										name = "Blink On Fire",
										value = false,
										tooltip = "Forces an update when you fire your gun, perfect for being a dick.",
									},
									{
										type = "Slider",
										name = "Blink Min Buffer",
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
										type = "Slider",
										name = "Blink Max Buffer",
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
										name = "Floor TP",
										value = false,
										unsafe = true,
										tooltip = "Spawns you into the floor, so you can get out of the map.",
									},
									{
										type = "Toggle",
										name = "Disable Collisions",
										value = false,
										unsafe = true,
										tooltip = "Useful for Floor TP",
										extra = {
											{
												type = "KeyBind",
												toggletype = 2,
											},
										}
									},
									--[[{
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
									},]]
								}},
							},
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
								name = "Accuracy",
								pos = UDim2.new(0,0,0,0),
								size = UDim2.new(.5,-4,5/10,-4),
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
									{
										type = "Toggle",
										name = "No Scope Sway",
										value = false,
										unsafe = true,
									},
									{
										type = "Toggle",
										name = "Straight Bolt Pull",
										value = false,
										unsafe = true,
									}
								}
							},
							{
								name = "Handling",
								pos = UDim2.new(0,0,5/10,4),
								size = UDim2.new(.5,-4,5/10,-4),
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
										name = "Hip Spread",
										min = 0,
										max = 100,
										suffix = "%",
										decimal = 1,
										value = 100,
										unsafe = true,
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
								name = "Ballistics",
								pos = UDim2.new(.5,4,0,0),
								size = UDim2.new(.5,-4,1/3,-4),
								type = "Panel",
								content = {
									{
										type = "ComboBox",
										name = "Fire Modes",
										values = {
											{ "Semi-Auto", false },
											{ "Burst-2", false },
											{ "Burst-3", false },
											{ "Burst-4", false },
											{ "Burst-5", false },
											{ "Full-Auto", false },
										},
										unsafe = true,
									},
									{
										type = "Toggle",
										name = "Burst-Lock",
										value = false,
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
									{
										type = "Slider",
										name = "Burst Cap",
										min = 0,
										max = 2000,
										suffix = " RPM",
										decimal = 0,
										value = 0,
										custom = {
											[0] = "Disabled"
										},
										unsafe = true,
									},
								}
							},
							{
								name = "Movement",
								pos = UDim2.new(.5,4,1/3,4),
								size = UDim2.new(.5,-4,4/10,-4),
								type = "Panel",
								content = {
									{
										type = "DropBox",
										name = "Weapon Style",
										value = 1,
										values = {"Off", "Rambo", "Doom", "Quake III", "Half-Life"}
									},
									{
										type = "Toggle",
										name = "OG Bob",
										value = false,
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
								pos = UDim2.new(.5,4,1/3 + 4/10,8),
								size = UDim2.new(.5,-4,1-(1/3 + 4/10),-8),
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
						max = 200,
						suffix = "%",
						decimal = 1,
						custom = { [0] = "Off" },
					},
					{
						type = "Slider",
						name = "Barrel Comp Y",
						value = 100,
						min = 0,
						max = 200,
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
						name = "Deadly Mode",
						value = false,
						indev = true,
						tooltip = "This feature is currently in the works!"
					},
					{
						type = "Toggle",
						name = "Trigger When Aiming",
						value = false,
					},
					{
						type = "Slider",
						name = "RPM Limiter",
						min = 0,
						max = 2000,
						value = 600,
						decimal = 0,
						suffix = " RPM",
						custom = {
							[0] = "Instant"
						},
						tooltip = "Fires at a specific RPM"
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
				}
			},
		}
	end

	local main_panel = BBOT.configuration[1].content
	main_panel[#main_panel+1] = {
		name = "Settings",
		pos = UDim2.new(0,0,0,0),
		size = UDim2.new(1,0,1,0),
		borderless = true,
		innerborderless = true,
		topbarsize = 50,
		type = "Tabs",
		content = {
			{
				name = "Saves",
				icon = "SAVE",
				pos = UDim2.new(0,0,0,0),
				size = UDim2.new(1,0,1,0),
				type = "Container",
				content = {
					{
						name = "Configs",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(.5,-4,1,-4),
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
									local s = BBOT.config:GetValue("Main", "Settings", "Saves", "Configs", "Config Name")
									BBOT.config:Save(s)
									BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autosave File")
									BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autoload File")
									local configs = BBOT.config:Discover()
									BBOT.config:GetRaw("Main", "Settings", "Saves", "Configs", "Configs").list = configs
									menu.config_pathways[table.concat({"Main", "Settings", "Saves", "Configs", "Configs"}, ".")]:SetOptions(configs)
									BBOT.notification:Create("Saved config: " .. s)
								end
							},
							{
								type = "Button",
								name = "Load",
								confirm = "Are you sure?",
								callback = function()
									local s = BBOT.config:GetValue("Main", "Settings", "Saves", "Configs", "Configs")
									BBOT.config:Open(s)
									BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Config Name")
									BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autosave File")
									BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autoload File")
									local configs = BBOT.config:Discover()
									BBOT.config:GetRaw("Main", "Settings", "Saves", "Configs", "Configs").list = configs
									menu.config_pathways[table.concat({"Main", "Settings", "Saves", "Configs", "Configs"}, ".")]:SetOptions(configs)
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
					},
					{
						name = "Cheat Settings",
						pos = UDim2.new(.5,4,0,0),
						size = UDim2.new(.5,-4,1/2,-4),
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
								extra = {
									{
										type = "ColorPicker",
										name = "Color",
										color = { 255, 255, 255, 255 },
									}
								},
								tooltip = "Use can use either a file, or an imgur image Id, for the imgur image Id you will need this -> https://i.imgur.com/g2k0at.png, only input the 'g2k0at' part! Changing this to a blank box will remove the logo."
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
						pos = UDim2.new(.5,4,1/2,4),
						size = UDim2.new(.5,-4,2/10,-4),
						type = "Panel",
						content = {
							{
								type = "Toggle",
								name = "Weapon Customization",
								value = false,
								extra = {},
							},
						}
					},
				}
			},
			{
				name = "Environment",
				icon = "PLAYERS",
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
							local gui = BBOT.gui
							local container = gui:Create("Container")
							local search = gui:Create("TextEntry", container)
							search:SetFontManager("Menu.BodySmall")
							search:SetText("")
							search:SetSize(1,0,0,16)
							search:SetPlaceholder("Search Here")

							local playerbox_size = 115
							local playerlist = gui:Create("List", container)
							playerlist:SetPos(0,0,0,16+6)
							playerlist:SetSize(1,0,1,-16-6-playerbox_size-8)

							playerlist:AddColumn("Name")
							playerlist:AddColumn("State")
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
										local priority, extra = config:GetPriority(v)
										if priority then
											if extra then
												state = extra .. " (" .. priority .. ")"
											elseif priority > 0 then
												state = "Priority (" .. priority .. ")"
											elseif priority < 0 then
												state = "Friendly (" .. (-priority) .. ")"
											end
										end
										local line = playerlist:AddLine(v.Name, "Unknown", v.Team.Name, state)
										line.player = v

										local team_line = line.children[3]
										function team_line:Step()
											if not self:GetAbsoluteVisible() then return end
											local pl = self.parent.player
											if pl and pl.Team and pl.Team.TeamColor and pl.Team.TeamColor.Color then
												if pl.Team.Name ~= self.parent.team then
													self.text:SetColor(pl.Team.TeamColor.Color)
													self.text:SetText(pl.Team.Name)
													self.parent.team = pl.Team.Name
												end
											end
										end

										local state_line = line.children[2]
										function state_line:Step()
											local pl = self.parent.player
											if pl and BBOT.aux then
												local updater = BBOT.aux.replication.getupdater(pl)
												if updater then
													local hp = (updater.alive and math.round(BBOT.aux.hud:getplayerhealth(pl)) or 0)
													if updater.alive ~= self.alive or hp ~= self.hp then
														self.alive = updater.alive
														self.hp = hp
														if self.alive then
															self.text:SetColor(Color3.new(0,1,0))
															self.text:SetText(math.round(hp) .. " HP")
														else
															self.text:SetColor(Color3.new(1,0,0))
															self.text:SetText("Dead")
														end
													end
												end
											end
										end

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
							playerbox:SetPos(0,0,1,-playerbox_size)
							playerbox:SetSize(1,0,0,playerbox_size)

							local draw = BBOT.draw
							local aline = gui:Create("Container", playerbox)
							local background_border = draw:Create("Rect", "2V")
							background_border.Color = gui:GetColor("Border")
							background_border.Filled = true
							background_border.XAlignment = XAlignment.Right
							background_border.YAlignment = YAlignment.Bottom
							aline.background_border = aline:Cache(background_border)
							function aline:PerformLayout(pos, size)
								self.background_border.Offset = pos
								self.background_border.Size = size
							end
							aline:SetPos(.7,-1,0,2)
							aline:SetSize(0,2,1,-4)

							local image_container = gui:Create("Box", playerbox)
							image_container:SetPos(0, 4, 0, 4)
							image_container:SetSize(0, playerbox_size-8, 0, playerbox_size-8)

							local player_image = gui:Create("Image", image_container)
							player_image:SetPos(0, 0, 0, 0)
							player_image:SetSize(1, 0, 1, 0)
							player_image:SetImage(BBOT.menu.images[5])

							local player_name = gui:Create("Text", playerbox)
							player_name:SetPos(0, playerbox_size+4, 0, 2)
							player_name:SetText("No Player Selected")

							local w, h = player_name:GetTextSize()
							local player_state = gui:Create("Text", playerbox)
							player_state:SetPos(0, playerbox_size+4, 0, 2 + (2 + h))
							player_state:SetText("State: Disconnected")

							local player_rank = gui:Create("Text", playerbox)
							player_rank:SetPos(0, playerbox_size+4, 0, 2 + (4 + h*2))
							player_rank:SetText("Rank: N/A")

							local player_kd = gui:Create("Text", playerbox)
							player_kd:SetPos(0, playerbox_size+4, 0, 2 + (6 + h*3))
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
								text:SetText("Status")
								local dropbox = gui:Create("DropBox", cont)
								player_priority = dropbox
								local _, tall = text:GetTextScale()
								dropbox:SetPos(0, 0, 0, tall+4)
								dropbox:SetSize(1, 0, 0, 16)
								dropbox:SetOptions({"None", "Friendly", "Priority"})
								dropbox:SetValue(1)
								dropbox.tooltip = "Change the priority of an individual"
								cont:SetPos(0, 0, 0, Y-2)
								cont:SetSize(1, 0, 0, tall+4+16)
								function dropbox:OnValueChanged(new)
									if not target then return end
									local level = 0
									if new == "None" then
										level = 0
									elseif new == "Friendly" then
										level = -1
									elseif new == "Priority" then
										level = 1
									end
									config:SetPriority(target, level)
								end
								Y=Y+16+4+16+2
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
								hook:Add("Spectator.Spectate", "BBOT:Menu.SpectateButton-" .. button.uid, function(target)
									if target then
										button:SetText("Stop Spectating")
									else
										button:SetText("Spectate")
									end
								end)
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
									BBOT.votekick:Call(target.Name, "cheating")
								end
								Y=Y+16+7
							end

							-- Get UID
							do
								local button = gui:Create("Button", options_container)
								button:SetPos(0, 0, 0, Y)
								button:SetSize(1, 0, 0, 16)
								button:SetText("Get UserId")
								button:SetConfirmation("Are you sure?")
								button.OnClick = function()
									if not target then return end
									setclipboard(tostring(target.UserId))
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
								local level = config.priority[uid] or 0
								if level == 0 then
									player_priority:SetValue("None")
								elseif level == -1 then
									player_priority:SetValue("Friendly")
								elseif level == 1 then
									player_priority:SetValue("Priority")
								end
								BBOT.thread:Create(function()
									local data = game:HttpGet(string.format(
										"https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=100&height=100&format=png",
										uid
									))
									if not gui:IsValid(player_image) or target ~= selected then return end
									player_image:SetImage(ImageRef.new(data))
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
							hook:Add("RenderStepped", "BBOT:PlayerManager.Tick", function()
								if nextcheck > tick() then return end
								nextcheck = tick() + .05
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
									local priority, extra = config:GetPriority(player)
									if extra then
										state = extra .. " (" .. priority .. ")"
									elseif priority > 0 then
										state = "Priority (" .. priority .. ")"
									elseif priority < 0 then
										state = "Friendly (" .. (-priority) .. ")"
									end
								end
								for i, v in next, playerlist.scrollpanel.canvas.children do
									if v.player == player then
										v.children[4].text:SetText(state)
										break
									end
								end
							end)

							return container
						end,
						content = {},
					},
				}
			},
			{
				name = "Lua",
				icon = "LUA",
				pos = UDim2.new(0,0,0,0),
				size = UDim2.new(1,0,1,0),
				type = "Container",
				content = {
					{
						name = "Lua Stuff",
						pos = UDim2.new(0,0,0,0),
						size = UDim2.new(1,0,1,0),
						type = "Custom",
						callback = function()
							local gui = BBOT.gui
							local asset = BBOT.asset
							local scripts = BBOT.scripts
							local table = BBOT.table

							local container = gui:Create("Container")
							local search = gui:Create("TextEntry", container)
							search:SetFontManager("Menu.BodySmall")
							search:SetText("")
							search:SetSize(1,0,0,16)
							search:SetPlaceholder("Search Here")

							local scriptbox_size = 90
							local lualist = gui:Create("List", container)
							lualist:SetPos(0,0,0,16+6)
							lualist:SetSize(1,0,1,-16-6-scriptbox_size-8)

							lualist:AddColumn("File Name")
							lualist:AddColumn("State")
							lualist:AddColumn("AutoExec")

							local function Refresh_List()
								local tosearch = search:GetText()
								local checked = {}

								for i, v in next, scripts:GetAll() do
									local children = lualist.scrollpanel.canvas.children
									for i=1, #children do
										if children[i].path == v then
											checked[v] = true
											break 
										end
									end
									if not checked[v] then
										local autoexec = "No"
										local autoexec_id = scripts:IsAutoExec(v)
										if autoexec_id then
											autoexec = "ID " .. autoexec_id
										end
										local line = lualist:AddLine(v, scripts:GetState(v), autoexec )
										line.path = v
										checked[v] = true
									end
								end

								for i, v in next, lualist.scrollpanel.canvas.children do
									if not v.path or not checked[v.path] then
										v:Remove()
									elseif tosearch == "" or string.find(string.lower(v.children[1].text:GetText()), string.lower(tosearch), 1, true) then
										v:SetVisible(true)
									else
										v:SetVisible(false)
									end
								end

								lualist:PerformOrganization()
							end

							function search:OnValueChanged()
								Refresh_List()
							end

							BBOT.timer:Simple(.1, Refresh_List)
							
							local scriptbox = gui:Create("Box", container)
							scriptbox:SetPos(0,0,1,-scriptbox_size)
							scriptbox:SetSize(1,0,0,scriptbox_size)

							local draw = BBOT.draw
							local aline = gui:Create("Container", scriptbox)
							local background_border = draw:Create("Rect", "2V")
							background_border.Color = gui:GetColor("Border")
							background_border.Filled = true
							background_border.XAlignment = XAlignment.Right
							background_border.YAlignment = YAlignment.Bottom
							aline.background_border = aline:Cache(background_border)
							function aline:PerformLayout(pos, size)
								self.background_border.Offset = pos
								self.background_border.Size = size
							end
							aline:SetPos(.7,-1,0,2)
							aline:SetSize(0,2,1,-4)

							local script_name = gui:Create("Text", scriptbox)
							script_name:SetPos(0, 4, 0, 2)
							script_name:SetText("No Script Selected")
							script_name:SetFontManager("Menu.BodyBig")

							local w, h = script_name:GetTextSize()
							local script_state = gui:Create("Text", scriptbox)
							script_state:SetPos(0, 4, 0, 2 + (2 + h))
							script_state:SetText("State: N/A")
							script_state:SetFontManager("Menu.BodyBig")

							local script_size = gui:Create("Text", scriptbox)
							script_size:SetPos(0, 4, 0, 2 + (4 + h*2))
							script_size:SetText("Size: N/A")
							script_size:SetFontManager("Menu.BodyBig")

							local options_container = gui:Create("Container", scriptbox)
							options_container:SetPos(.7, 6, 0, 4)
							options_container:SetSize(.3, -10, 1, -8)

							local script = ""
							local Y = 0

							-- Execute
							local execute_button
							do
								local button = gui:Create("Button", options_container)
								execute_button = button
								button:SetPos(0, 0, 0, Y)
								button:SetSize(1, 0, 0, 16)
								button:SetText("Execute")
								button.OnClick = function()
									if script ~= "" then
										local state = scripts:GetState(script)
										if state ~= "Running" then
											scripts:Run(script)
										else
											scripts:Unload(script)
										end
									end
								end
								Y=Y+16+7
							end

							-- Auto Exec
							local autoexec_button
							do
								local button = gui:Create("Button", options_container)
								autoexec_button = button
								button:SetPos(0, 0, 0, Y)
								button:SetSize(1, 0, 0, 16)
								button:SetText("Add AutoExec")
								button.OnClick = function()
									if script ~= "" then
										if scripts:IsAutoExec(script) then
											scripts:RemoveFromAutoExec(script)
										else
											scripts:AddToAutoExec(script, 1)
										end
										
										local autoexecon = scripts:IsAutoExec(script)
										if autoexecon then
											autoexec_button:SetText("Remove AutoExec")
										else
											autoexec_button:SetText("Add AutoExec")
										end

										for i, v in next, lualist.scrollpanel.canvas.children do
											local autoexecstate = scripts:IsAutoExec(v.path)
											v.children[3].text:SetText(autoexecstate and "ID " .. autoexecstate or "No")
										end
									end
								end
								Y=Y+16+7
							end

							function lualist:OnSelected(row)
								if script == row.path then
									script = ""
									script_name:SetText("No Script Selected")
									script_state:SetText("State: N/A")
									execute_button:SetText("Execute")
									autoexec_button:SetText("Add AutoExec")
									return
								end
								script = row.path

								local state = scripts:GetState(script)
								if state ~= "Running" then
									execute_button:SetText("Execute")
								elseif state == "Running" then
									execute_button:SetText("Unload")
								end
								
								if scripts:IsAutoExec(script) then
									autoexec_button:SetText("Remove AutoExec")
								else
									autoexec_button:SetText("Add AutoExec")
								end

								script_name:SetText("Script: " .. script)
								script_state:SetText("State: " .. scripts:GetState(script))
							end

							hook:Add("Scripts.Run", "BBOT:Menu.Scripts", function(name, func, state)
								Refresh_List()
								if script == name then
									local state = scripts:GetState(script)
									script_state:SetText("State: " .. state)
									if state ~= "Running" then
										execute_button:SetText("Execute")
									elseif state == "Running" then
										execute_button:SetText("Unload")
									end
									for i, v in next, lualist.scrollpanel.canvas.children do
										if v.path == name then
											v.children[2].text:SetText(state)
											break
										end
									end
								end
							end)

							hook:Add("Scripts.Unload", "BBOT:Menu.Scripts", function(name, func, state)
								Refresh_List()
								if script == name then
									script_state:SetText("State: Idle")
									execute_button:SetText("Execute")
									for i, v in next, lualist.scrollpanel.canvas.children do
										if v.path == name then
											v.children[2].text:SetText("Idle")
											break
										end
									end
								end
							end)

							return container
						end,
						content = {},
					},
				}
			},
		}
	}

	hook:Call("PostStartup")
end

if not BBOT.Debug.menu then
	if BBOT.game == "phantom forces" then
		-- Auxillary, responsible for fetching, modifying,  (Done)
		-- If AUX cannot find or a check is invalidated, it will prevent BBOT from loading
		-- This should in theory prevent most bans related to updates by PF as it would prevent
		-- The cheat from having a colossal error
		do
			BBOT:SetLoadingStatus("Loading Auxillary...", 20)
			local math = BBOT.math
			local table = BBOT.table
			local hook = BBOT.hook
			local debug = BBOT.debug
			local timer = BBOT.timer
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local remotefunc = BBOT.service:GetService("ReplicatedStorage").RemoteFunction -- for fetching shit
			local remoteevent = BBOT.service:GetService("ReplicatedStorage").RemoteEvent
			local aux = {
				pfremoteevent = remoteevent,
				pfremotefunc = remotefunc
			}
			BBOT.aux = aux

			-- This is my automated way of fetching and finding shared modules pf uses
			-- How to access -> BBOT.aux.replication
			local aux_tables = {
				{
					Name = "vector",
					Keys = {"random", "anglesyx"},
				},
				{
					Name = "animation",
					Keys = {"player", "reset"},
				},
				{
					Name = "particle",
					Sources = {
						["new"] = "particle",
					},
					Keys = {"new", "step", "reset"},
				},
				{
					Name = "gamelogic",
					Keys = {"controllerstep", "setsprintdisable"},
				},
				{
					Name = "camera",
					Keys = {"setaimsensitivity", "magnify"},
				},
				{
					Name = "network",
					Keys = {"servertick", "send"},
				},
				{
					Name = "hud",
					Keys = {"addnametag"},
				},
				{
					Name = "roundsystem",
					Keys = {"lock", "raycastwhitelist"},
				},
				{
					Name = "playerdata",
					Keys = {"getattloadoutdata", "getgunattdata", "getattachdata", "updatesettings"},
				},
				{
					Name = "char",
					Keys = {"unloadguns", "getslidecondition", "sprinting"},
				},
				{
					Name = "replication",
					Keys = {"getplayerhit"},
				},
				{
					Name = "cframe",
					Keys = {"fromaxisangle", "toaxisangle", "direct"},
				},
				{
					Name = "sound",
					Keys = {"PlaySound", "play"},
				},
				{
					Name = "raycast",
					Keys = {"raycast", "raycastSingleExit"},
				},
				{
					Name = "menu",
					Keys = {"isdeployed"},
				},
				{
					Name = "ScreenCull",
					Keys = {"point", "sphere", "localSegment", "segment"},
				},
				{
					Name = "GunDataGetter",
					Keys = {"getGunModule", "getGunModel", "getGunList"}
				},
			}

			-- fetches by function name
			-- index is the function you are finding
			-- value is where to put it in aux
			-- true = aux.bulletcheck, replication = aux.replication.bulletcheck
			local aux_functions = {
				{
					Name = "bulletcheck",
					Store = "raycast",
				},
				{
					Name = "rankcalculator",
					Store = "playerdata",
				},
				{
					Name = "call",
				},
				{
					Name = "gunbob",
				},
				{
					Name = "gunsway",
				},
				{
					Name = "addplayer",
				},
				{
					Name = "removeplayer",
				},
				{
					Name = "loadplayer",
				},
				{
					Name = "updateplayernames",
				},
			}

			function aux:_Scan()
				local core_aux, core_aux_sub = {}, {}

				BBOT.log(LOG_DEBUG, "Scanning...")
				BBOT:SetLoadingStatus(nil, 30)

				BBOT.log(LOG_DEBUG, "Scanning auxillaries...")

				for _=1, #aux_tables do
					local data = aux_tables[_]
					local name = data.Name
					local sources = data.Sources
					data.IgnoreSyn = true -- This should already be set to true[?] (as-per synv3 docs)
					local gc = filtergc("table", data)
					for i=1, #gc do
						local gc_data = gc[i]
						if sources then
							local success = false
							for fname, path in next, sources do
								local value = rawget(gc_data, fname)
								if typeof(value) == "function" and string.find(debug.getinfo(value).source, path, 1, true) then
									success = true
									break
								end
							end
							if not success then continue end
						end
						if core_aux[name] ~= gc_data then
							if core_aux[name] ~= nil then
								BBOT.log(LOG_WARN, 'Warning: Auxillary overload for "' .. name .. '"')
								for kk, vv in pairs(core_aux[name]) do
									if vv ~= rawget(gc_data, kk) then
										return "Duplicate auxillary \"" .. name .. "\""
									end
								end
								core_aux[name] = gc_data
								BBOT.log(LOG_DEBUG, 'Found Auxillary "' .. name .. '"')
							else
								core_aux[name] = gc_data
								BBOT.log(LOG_DEBUG, 'Found Auxillary "' .. name .. '"')
							end
						end
					end
				end

				for _=1, #aux_functions do
					local data = aux_functions[_]
					local name = data.Name
					data.IgnoreSyn = true
					local gc = filtergc("function", data)
					for i=1, #gc do
						local gc_data = gc[i]
						BBOT.log(LOG_DEBUG, 'Found Auxillary Function "' .. name .. '"')
						core_aux_sub[name] = gc_data
					end
				end

				BBOT:SetLoadingStatus(nil, 40)

				BBOT.log(LOG_DEBUG, "Checking auxillaries...")
				for _=1, #aux_tables do
					local data = aux_tables[_]
					if not core_aux[data.Name] then
						return "Couldn't find auxillary \"" .. k ..  "\""
					end
				end

				for _=1, #aux_functions do
					local data = aux_functions[_]
					if not core_aux_sub[data.Name] then
						return "Couldn't find auxillary \"" .. k ..  "\""
					end
				end

				for k, v in next, core_aux do
					self[k] = v
				end

				for _=1, #aux_functions do
					local data = aux_functions[_]
					local k, v = data.Name, core_aux_sub[data.Name]
					local saveas = data.Store
					if saveas then
						if not self[saveas] then
							self[saveas] = {}
						end
						local t = self[saveas]
						rawset(t, k, v)
						hook:Add("Unload", "BBOT:Aux.RemoveAuxSub-" .. k, function()
							rawset(t, k, nil)
						end)
						BBOT.log(LOG_DEBUG, 'Auxillary Function "' .. k .. '" sorted into ' .. saveas)
					else
						self[k] = v
					end
				end

				local reg = getgc()
				for i=1, #reg do
					local v = reg[i]
					if typeof(v) == "function" then
						local dbg = debug.getinfo(v)
						if string.find(dbg.short_src, "network", 1, true) then
							local consts = debug.getconstants(v)
							if table.quicksearch(consts, "warn") and table.quicksearch(consts, "Tried to call a unregistered network event %s") then
								local ups = debug.getupvalues(v)
								if typeof(ups[1]) == "table" then
									rawset(aux.network, "receivers", ups[1])
								end
								hook:BindFunctionOverride(v, "NetworkReceive")
							end
						end
					end
				end

				--[[local onclientevent_connections = getconnections(aux.pfremoteevent.OnClientEvent)
				for k, v in pairs(onclientevent_connections) do
					print(1, v)
					if not isluaconnection(v) then continue end
					print(2, v)
					local func = getconnectionfunction(v)
					if not func then continue end
					local dbg = debug.getinfo(func)
					print(dbg.short_src)
					if string.find(dbg.short_src, "network", 1, true) then
						hook:BindFunctionOverride(func, "NetworkReceive")
						local ups = debug.getupvalues(func)
						for k=1, #ups do
							local vv = ups[k]
							if typeof(vv) == "table" then
								if rawget(vv, "ping") then -- yes, I grab ur network shit 😂😂😂
									rawset(aux.network, "receivers", vv)
									break
								end
							end
						end
					end
				end]]

				if not aux.network.receivers then
					return "Couldn't find auxillary \"network.receivers\""
				end

				hook:Add("Unload", "BBOT:Aux.NetworkReceivers", function()
					rawset(aux.network, "receivers", nil)
				end)

				local function override_Position(controller)
					--[[if not controller.alive or not controller.receivedPosition then
						controller.__spawn_position = nil
					elseif controller.__spawn_position then
						controller.receivedPosition = controller.__spawn_absolute
						controller.__spawn_position = nil
					end]]
					if controller.__just_spawned then
						controller.__just_spawned = false
						hook:Call("updateReplicationJustSpawned", controller)
					end
				end

				local function override_spawn(controller, pos)
					if typeof(pos) == "Vector3" then
						controller.__spawn_position = pos
						controller.__spawn_absolute = controller.getpos()
						controller.receivedPosition = controller.__spawn_position
						controller.__t_received = tick()
					end
					controller.__spawn_time = tick()
					controller.__just_spawned = true
				end

				local function override_Updater(player, controller)
					if player == localplayer then
						hook:CallP("CreateUpdater", player)
						return
					end
					local upd_updateReplication = controller.updateReplication
					controller._upd_updateReplication = upd_updateReplication
					function controller.updateReplication(...)
						hook:CallP("PreupdateReplication", player, controller, ...)
						return upd_updateReplication(...), override_Position(controller), hook:CallP("PostupdateReplication", player, controller, ...)
					end
					local upd_spawn = controller.spawn
					controller._upd_spawn = upd_spawn
					function controller.spawn(pos, ...)
						hook:CallP("Preupdatespawn", player, controller, pos, ...)
						controller.__stance = "stand"
						return upd_spawn(pos, ...), override_spawn(controller, pos), hook:CallP("Postupdatespawn", player, controller, pos, ...)
					end
					local upd_step = controller.step
					controller._upd_step = upd_step
					function controller.step(renderscale, shouldrender, ...)
						local a, b = hook:CallP("PreupdateStep", player, controller, renderscale, shouldrender, ...)
						if a ~= nil then renderscale = a end
						if b ~= nil then shouldrender = b end
						return upd_step(renderscale, shouldrender, ...), hook:CallP("PostupdateStep", player, controller, renderscale, shouldrender, ...)
					end
					local upd_setstance = controller.setstance
					controller._upd_setstance = upd_setstance
					function controller.setstance(stance, ...)
						controller.__stance = stance
						return upd_setstance(stance, ...)
					end
					hook:CallP("CreateUpdater", player)
				end

				local updater = aux.replication.getupdater
				local ups = debug.getupvalues(aux.replication.getupdater)
				for k, v in pairs(ups) do
					if typeof(v) == "table" then
						rawset(aux.replication, "player_registry", v)
						for player, v in pairs(v) do
							if (localplayer ~= player and v.updater) then
								local controller = v.updater
								override_Updater(player, controller)
							end
						end
					elseif typeof(v) == "function" then
						local function createupdater(player)
							local controller = v(player)
							if (localplayer ~= player) then
								override_Updater(player, controller)
							end
							return controller
						end
						rawset(aux.replication, "_updater", v)
						debug.setupvalue(updater, k, newcclosure(createupdater))
						hook:Add("Unload", "BBOT:Aux.Replication.UndoUpdaterDetour", function()
							debug.setupvalue(updater, k, v)
						end)
					end
				end
		
				hook:Add("Unload", "BBOT:Aux.Replication.Updater", function()
					for k, v in pairs(aux.replication.player_registry) do
						if v.updater and v.updater._upd_updateReplication then
							v.updater.updateReplication = v.updater._upd_updateReplication
							v.updater._upd_updateReplication = nil

							v.updater.spawn = v.updater._upd_spawn or v.updater.spawn
							v.updater._upd_spawn = nil

							v.updater.step = v.updater._upd_step or v.updater.step
							v.updater._upd_step = nil

							v.updater.setstance = v.updater._upd_setstance or v.updater.setstance
							v.updater._upd_setstance = nil
						end
					end
					aux.replication.player_registry[localplayer] = nil
					rawset(aux.replication, "player_registry", nil)
					rawset(aux.replication, "_updater", nil)
				end)

				if not aux.replication.player_registry then
					return "Couldn't find auxillary \"replication.player_registry\""
				end

				if not aux.replication._updater then
					return "Couldn't find auxillary \"replication._updater\""
				end
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

			--[[do -- using rawget just in case...
				local send = rawget(aux.network, "send")
				local osend = rawget(aux.network, "_send")
				hook:Add("Unload", "BBOT:NetworkOverride", function()
					rawset(aux.network, "send", osend or send)
				end)
				local function sender(self, ...)
					local _BB = BBOT
					local _aux = _BB.aux
					local _hook, _send = _BB.hook, _aux.network._send -- something about synapses hooking system I tried...
					if not _aux.network_supressing then
						_aux.network_supressing = true
						if _hook:CallP("SuppressNetworkSend", ...) then
							_aux.network_supressing = false
							return
						end
						_aux.network_supressing = false
					end
					local override = {_hook:CallP("PreNetworkSend", ...)}
					if override[1] ~= nil then
						return _send(self, unpack(override)), _hook:CallP("PostNetworkSend", unpack(override))
					end
					return _send(self, ...), _hook:CallP("PostNetworkSend", ...)
				end
				local function newsend(self, netname, ...)
					local ran, a, b, c, d, e = xpcall(sender, debug.traceback, self, netname, ...)
					if not ran then
						BBOT.log(LOG_ERROR, "Networking Error - ", netname, " - ", a)
					else
						return a, b, c, d, e
					end
				end
				rawset(aux.network, "_send", send)
				rawset(aux.network, "send", newcclosure(newsend))
			end]]

			do
				local oplay = rawget(aux.sound, "PlaySound")
				local oplayid = rawget(aux.sound, "PlaySoundId")
				hook:Add("Unload", "BBOT:Aux.SoundDetour", function()
					rawset(aux.sound, "PlaySound", oplay)
					rawset(aux.sound, "PlaySoundId", oplayid)
				end)
				local supressing = false
				local function newplay(...)
					if supressing then return oplay(...) end
					supressing = true
					if hook:CallP("SuppressSound", ...) then
						supressing = false
						return
					end
					supressing = false
					return oplay(...)
				end
				local supressing = false
				local function newplayid(...)
					if supressing then return oplayid(...) end
					supressing = true
					if hook:CallP("SuppressSoundId", ...) then
						supressing = false
						return
					end
					supressing = false
					return oplayid(...)
				end
				aux.sound._play = oplay
				aux.sound._playid = oplayid
				function aux.sound.playid(p39, p40, p41, p42, p43, p44)
					aux.sound._playid(p39, p40, p41, nil, nil, p42, nil, nil, nil, p43, p44);
				end
				rawset(aux.sound, "PlaySound", newcclosure(newplay))
				rawset(aux.sound, "PlaySoundId", newcclosure(newplayid))
			end

			local ups = debug.getupvalues(aux.replication.getupdater)
			for k, v in pairs(ups) do
				if typeof(v) == "function" then
					local name = debug.getinfo(v).name
					if name == "loadplayer" then
						hook:BindFunction(v, "LoadPlayer")
					end
				end
			end
			
			local players = BBOT.service:GetService("Players")
			hook:Add("Initialize", "BBOT:Aux.SetupPlayerReplication", function()
				for i, v in next, players:GetChildren() do
					local controller = aux.replication.getupdater(v)
					if controller and not controller.setup then
						hook:Call("PostLoadPlayer", controller)
					end
				end
			end)

			hook:Add("Initialize", "BBOT:Aux.BigRewardDetour", function()
				local receivers = aux.network.receivers
				for k, v in pairs(receivers) do
					local a = debug.getupvalues(v)[1]
					if typeof(a) == "function" then
						local run, consts = pcall(debug.getconstants, a)
						if run then
							if table.quicksearch(consts, "killshot") and table.quicksearch(consts, "kill") then
								hook:BindFunction(receivers[k], "BigAward")
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

			--hook:BindFunctionOverride(aux.network.send, "NetworkSend")
			hook:Add("PostNetworkSend", "BBOT:Aux.FrameworkLogging", function(net, ...)
				if net == "logmessage" or net == "debug" then
					local args = {...}
					local message = ""
					for i = 1, #args - 1 do
						message ..= tostring(args[i]) .. ", "
					end
					message ..= tostring(args[#args])
					BBOT.log(LOG_WARN, "Framework Internal Message -> " .. message)
					hook:Call("InternalMessage", message)
				end

				if BBOT.Debug.internal and net ~= "ping" then
					BBOT.log(LOG_DEBUG, net, ...)
				end
			end)

			hook:BindFunctionOverride(aux.network.send, "NetworkSend", true)
			hook:BindFunction(aux.char.updatecharacter, "LoadCharacter")
			hook:BindFunction(aux.ScreenCull.step, "ScreenCullStep")
			hook:BindFunction(aux.char.step, "CharacterStep")
			hook:BindFunction(aux.camera.step, "CameraStep")

			--[[hook:Add("Initialize", "FindnewBullet", function()
				local receivers = network.receivers

				local function quickhasvalue(tbl, value)
					for i=1, #tbl do
						if tbl[i] == value then return true end
					end
					return false
				end

				for k, v in pairs(receivers) do
					local ran, const = pcall(debug.getconstants, v)
					if ran and quickhasvalue(const, "firepos") and quickhasvalue(const, "bullets") and quickhasvalue(const, "bulletcolor") and quickhasvalue(const, "penetrationdepth") then
						receivers[k] = function(data)
							hook:CallP("PreNewBullets", data)
							v(data)
							hook:CallP("PostNewBullets", data)
						end
						hook:Add("Unload", "BBOT:NewBullet.Ups." .. tostring(k), function()
							receivers[k] = v
						end)
					end
				end
			end)]]

			local dt = tick() - profiling_tick
			BBOT.log(LOG_NORMAL, "Took " .. math.round(dt, 2) .. "s to load auxillary")
			BBOT:SetLoadingStatus(nil, 50)
		end

		-- Chat, allows for chat manipulations, or just being a dick with the chat spammer (Conversion In Progress)
		do
			local network = BBOT.aux.network
			local hook = BBOT.hook
			local table = BBOT.table
			local notification = BBOT.notification
			local string = BBOT.string
			local config = BBOT.config
			local timer = BBOT.timer
			local chat = {}
			BBOT.chat = chat

			do
				local chat_netindex, console_netindex

				local receivers = network.receivers
				for netindex, callback in pairs(receivers) do
					local const = debug.getconstants(callback)
					if table.quicksearch(const, "Tag") and table.quicksearch(const, "rbxassetid://") then
						chat_netindex = netindex
					elseif table.quicksearch(const, "[Console]: ") and table.quicksearch(const, "Tag") then
						console_netindex = netindex
					end
				end

				hook:Add("PostNetworkReceive", "BBOT:Chat.Network", function(netname, ...)
					if netname == chat_netindex then
						hook:Call("Chatted", ...)
					elseif netname == console_netindex then
						hook:Call("Console", ...)
					end
				end)
			end


			-- This is now useless :D
			--[[hook:Add("Initialize", "BBOT:ChatDetour", function()
				local receivers = network.receivers

				for k, v in pairs(receivers) do
					local const = debug.getconstants(v)
					if table.quicksearch(const, "Tag") and table.quicksearch(const, "rbxassetid://") then
						receivers[k] = function(p20, p21, p22, p23, p24)
							timer:Async(function() hook:CallP("Chatted", p20, p21, p22, p23, p24) end)
							return v(p20, p21, p22, p23, p24)
						end
						hook:Add("Unload", "ChatDetour." .. tostring(k), function()
							receivers[k] = v
						end)
					elseif table.quicksearch(const, "[Console]: ") and table.quicksearch(const, "Tag") then
						receivers[k] = function(p18)
							timer:Async(function() hook:CallP("Console", p18) end)
							return v(p18)
						end
						hook:Add("Unload", "ChatDetour." .. tostring(k), function()
							receivers[k] = v
						end)
					end
				end
			end)]]

			function chat:Say(str, un)
				if string.sub(str, 1, 1) == "/" then
					network:send("modcmd", str)
					return
				end
				network:send("chatted", str, un or false)
				chat.last_say = tick()
			end

			chat.commands = {}

			function chat:AddCommand(name, callback, help)
				chat.commands[name] = {callback, help}
			end

			function chat:RemoveCommand(name)
				chat.commands[name] = nil
			end

			chat:AddCommand("rank", function(num)
				num = tonumber(num)
				if not num then return end
				notification:Create("Rank: " .. BBOT.aux.playerdata.rankcalculator(num))
			end)

			local players = BBOT.service:GetService("Players")
			chat:AddCommand("priority", function(pl, level)
				if not level then return end
				local target = nil
				for k, v in pairs(players:GetPlayers()) do
					if string.find(v.Name, pl, 1, true) then
						target = v
						break
					end
				end

				if target then
					notification:Create("Set priority for " .. target.Name .. " to " .. level)
					config:SetPriority(target, level)
				else
					notification:Create("Player " .. pl .. " not found")
				end
			end)

			chat:AddCommand("help", function(...)
				notification:Create("WIP, please wait a bit!")
			end, "Shows all command information.")

			hook:Add("SuppressNetworkSend", "BBOT:Chat.Commands", function(netname, message)
				if netname ~= "chatted" then return end
				if string.sub(message, 1, 1) ~= "." or string.sub(message, 2, 2) == "." then return end
				local command_line = string.sub(message, 2)
				command_line = string.Explode(" ", command_line)
				local command = command_line[1]
				table.remove(command_line, 1)
				local args = command_line

				if chat.commands[command] then
					local cmd = chat.commands[command]
					local exec = cmd[1](unpack(args))
					if exec == nil then exec = true end
					return exec
				else
					notification:Create("Not a command, try \".help\" to see available commands.")
				end
				return true
			end)

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
				local msgquery = self.buffer
				msgquery[#msgquery+1] = msg .. spaces
				chat:BufferStep()
			end
			
			function chat:CheckIfValid(msg)
				for i=1, #msg do
					local str = string.sub(msg, i, i)
					if str ~= "\n" or str ~= " " then
						return true
					end
				end
			end

			chat.spammer_presets = {
				["Bitch Bot"] = {
					"BBOT ON TOP ",
					"BBOT ON TOP 🔥🔥🔥🔥",
					"BBot top i think ",
					"bbot > all ",
					"BBOT > ALL🧠 ",
					"WHAT SCRIPT IS THAT???? BBOT! ",
					"日工tch ",
					".gg/bbot",
				},
				["Chinese Propaganda"] = {
					"音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
					"持有毁灭性的神经重景气游行脸红青铜色类别创意案",
					"诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
					"完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
					"庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
					"坐下，一直保持着安静的状态。 谁把他拥有的东西给了他，所以他不那么爱欠债务，却拒��参加锻炼，这让他爱得更少了",
					", yīzhí bǎochízhe ānjìng de zhuàngtài. Shéi bǎ tā yǒngyǒu de dōngxī gěile tā, suǒyǐ tā bù nàme ài qiàn zhàiwù, què jùjué cānjiā duànliàn, z",
					"他，所以他不那r给了他东西给了他爱欠s，却拒绝参加锻炼，这让他爱得更UGT少了",
					"bbot 有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
					"wocky slush他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼",
					"坐下，一直保持着安静的状态bbot 谁把他拥有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
					"免费手榴弹bbot hack绕过作弊工作Phantom Force roblox aimbot瞄准无声目标绕过2020工作真正免费下载和使用",
					"zal發明了roblox汽車貿易商的船長ro blocks，並將其洩漏到整個宇宙，還修補了虛假的角神模式和虛假的身體，還發明了基於速度的AUTOWALL和無限制的自動壁紙遊戲 ",
					"彼が誤って禁止されたためにファントムからautowallgamingを禁止解除する請願とそれはでたらめですそれはまったく意味がありませんなぜあなたは合法的なプレーヤーを禁止するのですか ",
					"ジェイソンは私が神に誓う女性的な男の子ではありません ",
					"傑森不是我向上帝發誓女性男孩 ",
				},
				["Youtube Title"] = { 
					"Hack", "Unlock", "Cheat", "Roblox", "Mod Menu", "Mod", "Menu", "God Mode", "Kill All", "Silent", "Silent Aim", "X Ray", "Aim", "Bypass", "Glitch", "Wallhack", "ESP", "Infinite", "Infinite Credits",
					"XP", "XP Hack", "Infinite Credits", "Unlook All", "Server Backdoor", "Serverside", "2021", "Working", "(WORKING)", "瞄准无声目标绕过", "Gamesense", "Onetap", "PF Exploit", "Phantom Force",
					"Cracked", "TP Hack", "PF MOD MENU", "DOWNLOAD", "Paste Bin", "download", "Download", "Teleport", "100% legit", "100%", "pro", "Professional", "灭性的神经",
					"No Virus All Clean", "No Survey", "No Ads", "Free", "Not Paid", "Real", "REAL 2020", "2020", "Real 2017", "BBot", "Cracked", "BBOT CRACKED by vw", "2014", "desuhook crack",
					"Aimware", "Hacks", "Cheats", "Exploits", "(FREE)", "🕶😎", "😎", "😂", "😛", "paste bin", "bbot script", "hard code", "正免费下载和使", "SERVER BACKDOOR",
					"Secret", "SECRET", "Unleaked", "Not Leaked", "Method", "Minecraft Steve", "Steve", "Minecraft", "Sponge Hook", "Squid Hook", "Script", "Squid Hack",
					"Sponge Hack", "(OP)", "Verified", "All Clean", "Program", "Hook", "有毁灭", "desu", "hook", "Gato Hack", "Blaze Hack", "Fuego Hack", "Nat Hook",
					"vw HACK", "Anti Votekick", "Speed", "Fly", "Big Head", "Knife Hack", "No Clip", "Auto", "Rapid Fire",
					"Fire Rate Hack", "Fire Rate", "God Mode", "God", "Speed Fly", "Cuteware", "Knife Range", "Infinite XRay", "Kill All", "Sigma", "And", "LEAKED",
					"🥳🥳🥳", "RELEASE", "IP RESOLVER", "Infinite Wall Bang", "Wall Bang", "Trickshot", "Sniper", "Wall Hack", "😍😍", "🤩", "🤑", "😱😱", "Free Download EHUB", "Taps", "Owns",
					"Owns All", "Trolling", "Troll", "Grief", "Kill", "弗吉艾尺艾杰开", "Nata", "Alan", "JSON", "BBOT Developers", "Logic", "And", "and", "Glitch", 
					"Server Hack", "Babies", "Children", "TAP", "Meme", "MEME", "Laugh", "LOL!", "Lol!", "ROFLSAUCE", "Rofl", ";p", ":D", "=D", "xD", "XD", "=>", "₽", "$", "8=>", "😹😹😹", "🎮🎮🎮", "🎱", "⭐", "✝", 
					"Ransomware", "Malware", "SKID", "Pasted vw", "Encrypted", "Brute Force", "Cheat Code", "Hack Code", ";v", "No Ban", "Bot", "Editing", "Modification", "injection", "Bypass Anti Cheat",
					"铜色类别创意", "Cheat Exploit", "Hitbox Expansion", "Cheating AI", "Auto Wall Shoot", "Konami Code", "Debug", "Debug Menu", "🗿", "£", "¥", "₽", "₭", "€", "₿", "Meow", "MEOW", "meow",
					"Under Age", "underage", "UNDER AGE", "18-", "not finite", "Left", "Right", "Up", "Down", "Left Right Up Down A B Start", "Noclip Cheat", "Bullet Check Bypass",
					"client.char:setbasewalkspeed(999) SPEED CHEAT.", "diff = dot(bulletpos, intersection - step_pos) / dot(bulletpos, bulletpos) * dt", "E = MC^2", "Beyond superstring theory", 
					"It is conceivable that the five superstring theories are approximated to a theory in higher dimensions possibly involving membranes.",
				},
				["Emojis"] = {
					"🔥🔥🔥🔥🔥🔥🔥🔥",
					"😅😅😅😅😅😅😅😅",
					"😂😂😂😂😂😂😂😂",
					"😹😹😹😹😹😹😹😹",
					"😛😛😛😛😛😛😛😛",
					"🤩🤩🤩🤩🤩🤩🤩🤩",
					"🌈🌈🌈🌈🌈🌈🌈🌈",
					"😎😎😎😎😎😎😎😎",
					"🤠🤠🤠🤠🤠🤠🤠🤠",
					"😔😔😔😔😔😔😔😔",
				},
				["Deluxe"] = {
					"gEt OuT oF tHe GrOuNd 🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡 ",
					"brb taking a nap 💤💤💤 ",
					"gonna go take a walk 🚶‍♂️🚶‍♀️🚶‍♂️🚶‍♀️ ",
					"low orbit ion cannon booting up ",
					"how does it feel to not have bbot 🤣🤣🤣😂😂😹😹😹 ",
					"im a firing my laza! 🙀🙀🙀 ",
					"😂😂😂😂😂GAMING CHAIR😂😂😂😂😂",
					"retardheadass",
					"can't hear you over these kill sounds ",
					"i'm just built different yo 🧱🧱🧱 ",
					"📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈",
					"OFF📈THE📈CHART📈",
					"KICK HIM 🦵🦵🦵",
					"THE AMOUNT THAT I CARE --> 🤏 ",
					"🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏",
					"SORRY I HURT YOUR ROBLOX EGO BUT LOOK -> 🤏 I DON'T CARE ",
					'table.find(charts, "any other script other than bbot") -> nil 💵💵💵',
					"LOL WHAT ARE YOU SHOOTING AT BRO ",
					"🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
					"BRO UR SHOOTING AT LIKE NOTHING LOL UR A CLOWN",
					"🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
					"ARE U USING EHUB? 🤡🤡🤡🤡🤡",
					"'EHUB IS THE BEST' 🤡 PASTED LINES OF CODE WITH UNREFERENCED AND UNINITIALIZED VARIABLES AND PEOPLE HAVE NO IDEA WHY IT'S NOT WORKING ",
					"LOL",
					"GIVE UP ",
					"GIVE UP BECAUSE YOU'RE NOT GOING TO BE ABLE TO KILL ME OR WIN LOL",
					"Can't hear you over these bands ",
					"I’m better than you in every way 🏆",
					"I’m smarter than you (I can verify this because I took an online IQ test and got 150) 🧠",
					"my personality shines and it’s generally better than your personality. Yours has flaws",
					"I’m more ambitious than you 🏆💰📣",
					"I’m more funny than you (long shot) ",
					"I’m less turbulent and more assertive and calm than you (proof) 🎰",
					"I’m stronger than you 💪 🦵 ",
					"my attention span is greater and better than yours (proven from you not reading entire list) ",
					"I am more creative and expressive than you will ever be 🎨 🖌️",
					"I’m a faster at typing than you 💬 ",
					"In 30 minutes, I will have lifted more weights than you can solve algebraic equations 📓 ",
					"By the time you have completed reading this very factual and groundbreaking evidence that I am truly more superior, thoughtful, and presentable than you are, I will have prospered (that means make negotiable currency or the American Dollar) more than your entire family hierarchy will have ever made in its time span 💰",
					"I am more seggsually stable and better looking than you are 👨",
					"I get along with women easier than you do 👩‍🚀", -- end
					"I am very good at debating 🗣️🧑‍⚖️ ",
					"I hit more head than you do 🏆", -- end
					"I win more hvh than you do 🏆", -- end yes this is actually how im going to fix this stupid shit
					"I am more victorious than you are 🏆",
					"Due to my agility, I am better than you at basketball, and all of your favorite sports or any sport for that matter (I will probably break your ankles in basketball by pure accident) ",
					"WE THE BEST CHEATS 🔥🔥🔥🔥 ",
					"Phantom Force Hack Unlook Gun And Aimbot ",
					"banlands 🔨 🗻 down 🏚️  ⏬ STOP CRASHING BANLANDS!! 🤣",
					"antares hack client isn't real ",
					"squidhook.xyz 🦑 ",
					"squidhook > all ",
					"spongehook 🤣🤣🤣💕",
					"retardheadass ",
					"interpolation DWORD* C++ int 32 bit programming F# c# coding",
					"Mad?",
					"are we in a library? 🤔 📚 cause you're 👉 in hush 🤫 mode 🤣 😂",
					"please help, my name is john escopetta, normally I would not do this, but under the circumstances I must ask for assistance, please send 500 United States dollars to my paypal, please",
					"🏀🏀 did i break your ankles brother ",
					"he has access to HACK SERVER AND CHANGE WEIGHTS!!!!! STOOOOOOP 😡😒😒😡😡😡😡😡",
					'"cmon dude don\'t use that" you asked for it LOL ',
					"ima just quit mid hvh 🚶‍♀️ ",
					"BABY 😭",
					"BOO HOO 😢😢😭😭😭 STOP CRYING D∪MBASS",
					"BOO HOO 😢😢😭😭😭 STOP CRYING ",
					"🤏",
					"🤏 <-- just to elaborate that i have no care for this situation or you at all, kid (not that you would understand anyways, you're too stupid to understand what i'm saying to begin with)",
					"before bbot 😭 📢				after bbot 😁😁😜					don't be like the person who doesn't have bbot",
					"							MADE YOU LOOK ",
					"							LOOK BRO LOOK LOOK AT ME ",
					"			B		B		O		T	",
					"																																																																																																																								I HAVE AJAX YALL BETTER WATCH OUT OR YOU'LL DIE, WATCH WHO YOU'RE SHOOTING",
					"																																																																																																																								WATCH YOUR STEP KID",
					"BROOOO HE HAS																										GOD MODE BRO HE HAS GOD MODE 🚶‍♀️🚶‍♀️🚶‍♀️😜😂😂🤦‍♂️🤦‍♂️😭😭😭👶",
					'"guys what hub has auto shooting" 																										',
					"god i wish i had bbot..... 🙏🙏🥺🥺🥺													plzzzzz brooooo 🛐 GIVE IT🛐🛐",
					"buh bot 												",
					"votekick him!!!!!!! 😠 vk VK VK VK VOTEKICK HIM!!!!!!!!! 😠 😢 VOTE KICK !!!!! PRESS Y WHY DIDNT U PRESS Y LOL!!!!!! 😭 ", -- shufy made this
					"Bbot omg omggg omggg its BBot its BBOt OMGGG!!!  🙏🙏🥺🥺😌😒😡",
					"HOw do you get ACCESS to this BBOT ", -- end
					"I NEED ACCESS 🔑🔓 TO BBOT 🤖📃📃📃 👈 THIS THING CALLED BBOT SCRIPT, I NEED IT ",
					'"this god mode guy is annoying", Pr0blematicc says as he loses roblox hvh ',
					"you can call me crimson chin 🦹‍♂️🦹‍♂️ cause i turned your screen red 🟥🟥🟥🟥 									",
					"clipped that 🤡 ",
					"Clipped and Uploaded. 🤡",
					"nodus client slime castle crashers minecraft dupeing hack wizardhax xronize grief ... Tlcharger minecraft crack Oggi spiegheremo come creare un ip grabber!",
					"Off synonyme syls midge, smiled at mashup 2 mixed in key free download procom, ... Okay, love order and chaos online gameplayer hack amber forcen ahdistus",
					"ˢᵗᵃʸ ᵐᵃᵈ ˢᵗᵃʸ ᵇᵇᵒᵗˡᵉˢˢ $ ",
					"bbot does not relent ",
				},
				["t0nymode"] = {
					"but doctor prognosis: OWNED ",
					"but doctor results: 🔥",
					"looks like you need to talk to your doctor ",
					"speak to your doctor about this one ",
					"but analysis: PWNED ",
					"but diagnosis: OWND ",
				},
				["Douchbag"] = {
					"BBot - Drool Bot ver 1.0.0, making people face reality with uncomfortable jokes",
					"I love it when your mom takes my wood with extra syrup 😚",
					"I know you guys love it when I come in with my massive oak log 😋",
					"I have like 200 extra rounds of juice in my barrel 😋, want some?",
					"Please eat my barrel, it's so long and filled with rounds, I even have a muzzle booster on it 😚",
					"Your complaints just makes my wood turn into a 12 inch log",
					"Mmmmm, take my wood a put right in that hole you got 😚",
					"MMMmmm, let's touch barrels 😚, we bouta makes a whole new team if you know what I mean",
					"Take my entire mag, I know you love it when it gets unloaded right in your face 😌",
					"I'm bouta make a whole new category in the weapons menu with you 😌",
					"You better gobble up all my rounds, body bag 😋",
					"I want you to take my wood personally, we bouta make a whole new team 😋",
					"I heard you drop your mag when I came in, and honestly it made my wood hard",
					"I love the fact you guys are enjoying this, my barrel hasn't been this straight in ages",
					"I want you to eat my barrel like it was a family dinner my kitten 😋",
					"My barrel has not been this hard since I was banlands",
					"Eat my barrel pretty please daddy 😋, I put 9mm on it for extra action",
					"Take my barrel please daddy 😋, my bfg 50 can't take it much longer",
					"I love it when you take in my bfg 50 .17 wildcat, it makes me drool 😋",
					"I know you love it when I spread you open with my remington 870 😚",
					"I'm gonna make you spill your rounds all over me 😚",
					"Take my wood kitten, you will enjoy my delicious log",
				},
				["ni shi zhong guo ren ma?"] = {
					"诶",
					"比",
					"西",
					"迪",
					"伊",
					"艾",
					"弗",
					"吉",
					"艾",
					"尺",
					"艾",
					"杰",
					"开",
					"艾",
					"勒",
					"艾",
					"马",
					"艾",
					"娜",
					"哦",
					"屁",
					"吉",
					"吾",
					"艾",
					"儿",
					"艾"
				}
			}

			chat.spammer_delay = 0
			chat.spammer_startdelay = 0
			chat.spammer_kills = 0
			chat.spammer_alive = false
			chat.spammer_lines = chat.spammer_presets["Bitch Bot"]

			hook:Add("PostInitialize", "BBOT:Chat.Spam", function()
				timer:Async(function()
					local preset = chat.spammer_presets[config:GetValue("Main", "Misc", "Chat Spam", "Presets")]
					if not preset then return end
					chat.spammer_lines = preset
				end)
			end)

			hook:Add("OnConfigChanged", "BBOT:Chat.Spam", function(steps, old, new)
				if not config:IsPathwayEqual(steps, "Main", "Misc", "Chat Spam", "Presets") then return end
				local preset = chat.spammer_presets[new]
				if not preset then return end
				chat.spammer_lines = preset
			end)

			function chat:SpamStep(ignore_delay)
				if not self.spammer_alive then return end
				if self.spammer_startdelay and self.spammer_startdelay > tick() then return end
				if self.spammer_kills < config:GetValue("Main", "Misc", "Chat Spam", "Minimum Kills") then return end
				if #self.buffer > 20 then return end
				if not ignore_delay and self.spammer_delay > tick() then return end
				local msg
				local mixer = config:GetValue("Main", "Misc", "Chat Spam", "Newline Mixer")
				if mixer > 4 then
					local allow_spaces = config:GetValue("Main", "Misc", "Chat Spam", "Newline Mixer Spaces")
					local words = self.spammer_lines
					local message = ""
					for i = 1, mixer do
						message = message .. (allow_spaces and " " or "") .. words[math.random(#words)]
					end
					msg = message
				else
					msg = self.spammer_lines[math.random(1, #self.spammer_lines)]
				end
				if not msg then return end
				if not ignore_delay then self.spammer_delay = tick() + config:GetValue("Main", "Misc", "Chat Spam", "Spam Delay") end
				self:AddToBuffer(msg)
			end

			hook:Add("PreBigAward", "BBOT:Chat.Spam", function()
				chat.spammer_kills = chat.spammer_kills + 1
				if not config:GetValue("Main", "Misc", "Chat Spam", "Enabled") or not config:GetValue("Main", "Misc", "Chat Spam", "Spam On Kills") then return end
				--chat:SpamStep(true)
			end)

			hook:Add("RenderStepped", "BBOT:Chat.Spam", function()
				if not config:GetValue("Main", "Misc", "Chat Spam", "Enabled") then return end
				if config:GetValue("Main", "Misc", "Chat Spam", "Spam On Kills") then return end
				chat:SpamStep()
			end)

			hook:Add("OnAliveChanged", "BBOT:Chat.Spam", function(alive)
				if alive and not chat.spammer_alive then
					chat.spammer_startdelay = tick() + config:GetValue("Main", "Misc", "Chat Spam", "Start Delay")
					chat.spammer_alive = true
				end
			end)

			hook:Add("OnConfigOpened", "BBOT:Chat.Spam", function()
				chat.spammer_alive = false
			end)

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

			chat.last_say = 0

			hook:Add("PostNetworkSend", "BBOT:Chat.Query", function(netname, msg)
				if netname ~= "chatted" then return end
				chat.last_say = tick()
			end)

			function chat:BufferStep()
				if self.last_say + 2 > tick() then return end
				local msg = self.buffer[1]
				if not msg then return end
				table.remove(self.buffer, 1)
				local vkinprogress = BBOT.votekick:IsCalling()
				if not vkinprogress or vkinprogress > 5 then
					self:Say(msg)
				end
			end

			hook:Add("RenderStepped", "BBOT:Chat.Query", function()
				chat:BufferStep()
			end)
		end

		-- Votekick, handles the votekicks system (Conversion In Progress)
		-- Anti-Votekick
		do
			local config = BBOT.config
			local hook = BBOT.hook
			local timer = BBOT.timer
			local math = BBOT.math
			local notification = BBOT.notification
			local table = BBOT.table
			local statistics = BBOT.statistics
			local hud = BBOT.aux.hud
			local playerdata = BBOT.aux.playerdata
			local char = BBOT.aux.char
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local votekick = {}
			BBOT.votekick = votekick
			votekick.CallDelay = 90
			votekick.NextCall = 0
			votekick.Called = 3

			statistics:Create("votekick", {
				calls = 0,
				kicks = 0,
				kicked = {}
			})

			do
				local startvotekick_netindex
				local receivers = BBOT.aux.network.receivers
				for netindex, callback in pairs(receivers) do
					local consts = debug.getconstants(callback)
					for i=1, #consts do
						local vv = consts[i]
						if typeof(vv) == "string" and string.find(vv, "Votekick", 1, true) then
							startvotekick_netindex = netindex
							function votekick:GetVotes()
								return debug.getupvalue(callback, 9)
							end
						end
					end
				end

				hook:Add("PostNetworkReceive", "BBOT:Votekick.Network", function(netname, ...)
					if netname == startvotekick_netindex then
						hook:Call("Votekick.Start", ...)
					end
				end)
			end
			
			local invote = false
			hook:Add("Votekick.Start", "Votekick.Start", function(target, delay, votesrequired)
				delay = tonumber(delay)
				timer:Create("Votekick.Tick", delay, 1, function()
					hook:Remove("RenderStepped", "Votekick.Step")
					hook:Call("Votekick.End", target, delay, votesrequired, false)
				end)
				hook:Add("RenderStepped", "Votekick.Step", function()
					if votekick:GetVotes() >= votesrequired then
						hook:Remove("RenderStepped", "Votekick.Step")
						timer:Remove("Votekick.Tick")
						hook:Call("Votekick.End", target, delay, votesrequired, true)
					end
				end)
				if config:GetValue("Main", "Misc", "Votekick", "Anti Votekick") then
					timer:Simple(delay+2, function()
						votekick.called_user = nil
						votekick:RandomCall()
					end)
				end
			
				if target == localplayer.Name then
					timer:Simple(.5, function() hud:vote("no") end)
				end
			
				invote = votesrequired
				notification:Create("Votekick called on " .. target .. "; time till end: " .. delay .. "; votes required: " .. votesrequired)
				if votekick.Called == 1 then
					votekick.Called = 2
					votekick.NextCall = tick() + votekick.CallDelay + delay
				elseif votekick.Called == 2 or votekick.Called == 0 then
					votekick.Called = 3
					votekick.called_user = nil
					votekick.NextCall = tick() + votekick.CallDelay + delay
				end
			end)
			
			hook:Add("Console", "BBOT:Votekick.AntiVotekick", function(msg)
				if string.find(msg, "has been kicked out", 1, true) then
					if votekick.called_user then
						local data = statistics:Get("votekick")
						data.kicks = data.kicks + 1
						if data.kicked[votekick.called_user] then
							data.kicked[votekick.called_user] = data.kicked[votekick.called_user] + 1
						else
							data.kicked[votekick.called_user] = 1
						end
						statistics:Set("votekick")
					end
					votekick.called_user = nil
				elseif string.find(msg, "The last votekick was initiated by you", 1, true) then
					if votekick.NextCall <= tick() then
						votekick.Called = 2
						votekick.called_user = nil
						BBOT.menu:UpdateStatus("Anti-Votekick", "!!! Kickable !!! (Unknown duration)")
					end
				elseif string.find(msg, "seconds before initiating a votekick", 1, true) then
					votekick.Called = 0
					votekick.called_user = nil
					votekick.NextCall = tick() + (tonumber(string.match(msg, "%d+")) or 0)-(.5+BBOT.extras:getLatency())
				end
			end)
			
			function votekick:IsVoteActive()
				return debug.getupvalue(BBOT.aux.hud.votestep, 2)
			end
			
			local players = BBOT.service:GetService("Players")
			function votekick:GetTargets()
				local targetables = {}
				for i, v in pairs(players:GetPlayers()) do
					local inpriority = config:GetPriority(v)
					if (not inpriority or inpriority >= 0) and v ~= localplayer then
						targetables[#targetables+1] = v
					end
				end
				return targetables
			end
			
			function votekick:CanCall(target, reason)
				if self:IsVoteActive() then return false, "VoteActive" end
				if self.NextCall > tick() or (self.Called > 0 and self.Called < 3) then return false, "RateLimit" end
				return true
			end
			
			function votekick:Call(target, reason)
				BBOT.chat:Say("/votekick:"..target..":"..reason)
				local data = statistics:Get("votekick")
				data.calls = data.calls + 1
				statistics:Set("votekick")
				self.called_user = target
				if self.Called ~= 2 and self.NextCall <= tick() then
					self.Called = 1
					self.NextCall = 0
					BBOT.menu:UpdateStatus("Anti-Votekick", "Server response...")
				end
			end
			
			function votekick:RandomCall()
				local targets = votekick:GetTargets()
				local target = table.fyshuffle(targets)[1]
				votekick:Call(target.Name, config:GetValue("Main", "Misc", "Votekick", "Reason"))
			end

			local totalkills = 0
			hook:Add("PreBigAward", "BBOT:Votekick.Kills", function()
				totalkills = totalkills + 1
			end)

			hook:Add("OnConfigChanged", "BBOT:Votekick.AntiVotekick", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Misc", "Votekick", "Anti Votekick") then
					if playerdata.rankcalculator(playerdata:getdata().stats.experience) < 25 then
						BBOT.menu:UpdateStatus("Anti-Votekick", "Rank 25 required", new)
					else
						local state = BBOT.menu:GetStatus("Anti-Votekick")
						BBOT.menu:UpdateStatus("Anti-Votekick", (state and state[2] or "Waiting..."), new)
					end
				end
			end)

			function votekick:IsCalling()
				if not config:GetValue("Main", "Misc", "Votekick", "Anti Votekick") then return end
				if not votekick.WasAlive then return end
				if playerdata.rankcalculator(playerdata:getdata().stats.experience) < 25 then return end
				if votekick.Called == 3 or votekick.Called == 0 then
					return votekick.NextCall-tick()
				end
			end
			
			hook:Add("OnConfigOpened", "BBOT:Votekick.AntiVotekick", function()
				votekick.WasAlive = false
			end)

			local hop_called = 0
			hook:Add("RenderStepped", "BBOT:Votekick.AntiVotekick", function()
				if not config:GetValue("Main", "Misc", "Votekick", "Anti Votekick") then return end
				if char.alive == true then
					votekick.WasAlive = true
				end
				if not votekick.WasAlive then return end
				if playerdata.rankcalculator(playerdata:getdata().stats.experience) < 25 then return end
				if votekick.Called == 3 or votekick.Called == 0 then
					local t = votekick.NextCall-tick()
					if t < 0 then
						BBOT.menu:UpdateStatus("Anti-Votekick", "Waiting for server...")
					else
						BBOT.menu:UpdateStatus("Anti-Votekick", "Calling in " .. math.round(votekick.NextCall-tick()) .. "s")
					end
				elseif votekick.Called == 2 then
					local t = votekick.NextCall-tick()
					local amount = ""
					for i=1, math.round(tick()%4) do
						amount = amount .. "!"
					end
					if t < 0 then
						BBOT.menu:UpdateStatus("Anti-Votekick", "Kickable" .. amount)
					else
						BBOT.menu:UpdateStatus("Anti-Votekick", "Kickable in " .. math.round(t) .. "s" .. (t < 15 and amount or ""))
					end

					if hop_called < tick() and config:GetValue("Main", "Misc", "Votekick", "Auto Hop") and config:GetValue("Main", "Misc", "Votekick", "Hop Trigger Time") > t then
						BBOT.serverhopper:RandomHop()
						hop_called = tick() + 1
					end
				end
				if votekick:CanCall() then
					local kills = config:GetValue("Main", "Misc", "Votekick", "Votekick On Kills")
					if kills == 0 or totalkills >= kills then
						votekick:RandomCall()
					elseif kills > 0 then
						BBOT.menu:UpdateStatus("Anti-Votekick", (kills - totalkills) .. " kills remaining")
					end
				end
			end)
		end

		-- Server Hopper, redirects and moves the user to other server instances (Conversion In Progress)
		-- Votekick-blacklist (prevents user from joining voted out servers)
		do
			local config = BBOT.config
			local hook = BBOT.hook
			local votekick = BBOT.votekick
			local log = BBOT.log
			local timer = BBOT.timer
			local table = BBOT.table
			local notification = BBOT.notification
			local statistics = BBOT.statistics
			local asset = BBOT.asset
			local TeleportService = game:GetService("TeleportService")
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local httpservice = BBOT.service:GetService("HttpService")
			local serverhopper = {}
			BBOT.serverhopper = serverhopper

			statistics:Create("serverhopper", {
				redirects = 0,
				interacted = {}
			})

			serverhopper.file = "server-blacklist.json"
			serverhopper.blacklist = {}
			serverhopper.UserId = tostring(localplayer.UserId)

			hook:Add("PostInitialize", "BBOT:ServerHopper.Load", function()
				if asset:IsFile("data", serverhopper.file) then
					serverhopper.blacklist = asset:ReadJSON("data", serverhopper.file) or {}
					local otime = os.time()
					for _, userblacklist in pairs(serverhopper.blacklist) do
						for k, v in pairs(userblacklist) do
							if otime > v then
								userblacklist[k] = nil
								log(LOG_NORMAL, "Removed server-hop blacklist " .. k)
							end
						end
					end
					asset:WriteJSON("data", serverhopper.file, serverhopper.blacklist)
					local plbllist = serverhopper.blacklist[serverhopper.UserId]
					if plbllist then
						local c = 0
						for k, v in pairs(plbllist) do
							c = c + 1
						end
						--BBOT.chat:Message("You have been votekicked from " .. c .. " server(s)!")
						log(LOG_NORMAL, "You have been votekicked from " .. c .. " server(s)!")
						notification:Create("You have been votekicked from " .. c .. " server(s)!")
					end
				end
			end)

			function serverhopper:ClearBlacklist()
				serverhopper.blacklist = {}
				asset:WriteJSON("data", serverhopper.file, serverhopper.blacklist)
				notification:Create("Server hop blacklist cleared!")
			end

			function serverhopper:IsBlacklisted(id)
				local plbllist = serverhopper.blacklist[self.UserId]
				if plbllist and plbllist[id] then
					return true
				end
			end

			function serverhopper:RandomHop()
				local delay = config:GetValue("Main", "Misc", "Server Hopper", "Hop Delay")
				if delay > 0 then
					notification:Create("Hopping in " .. delay .. "s")
				end
				timer:Simple(delay, function()
					log(LOG_NORMAL, "Commencing Server-Hop...")
					local data = httpservice:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
					local mode = config:GetValue("Main", "Misc", "Server Hopper", "Sort By")
					if mode == "Highest Players" then
						table.sort(data, function(a, b) return a.playing > b.playing end)
					elseif mode == "Lowest Players" then
						table.sort(data, function(a, b) return a.playing < b.playing end)
					else
						data = table.fyshuffle(data)
					end
					for _, s in pairs(data) do
						local id = s.id
						if not serverhopper:IsBlacklisted(id) and id ~= game.JobId then
							if s.playing < s.maxPlayers then
								--syn.queue_on_teleport(<string> code)
								log(LOG_NORMAL, "Hopping to server Id: " .. id .. "; Players: " .. s.playing .. "/" .. s.maxPlayers .. "; " .. s.ping .. " ms")
								notification:Create("Hopping to new server -> Players: " .. s.playing .. "/" .. s.maxPlayers)
								timer:Simple(1, function()
									local data = statistics:Get("serverhopper")
									data.redirects = data.redirects + 1
									if data.interacted[id] then
										data.interacted[id] = data.interacted[id] + 1
									else
										data.interacted[id] = 1
									end
									statistics:Save()
									TeleportService:TeleportToPlaceInstance(game.PlaceId, id)
									local connection
									connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
										connection:Disconnect()
										data.redirects = data.redirects - 1
										if data.interacted[id] then
											data.interacted[id] = data.interacted[id] - 1
										else
											data.interacted[id] = 0
										end
										statistics:Save()
									end)
								end)
								return
							end
						end
					end
					log(LOG_ERROR, "No servers to hop towards... Wow... You really got votekicked off every server now did ya? Impressive...")
				end)
			end

			function serverhopper:AddToBlacklist(id, removaltime)
				self.blacklist = asset:ReadJSON("data", self.file) or self.blacklist
				local plbllist = self.blacklist[self.UserId]
				if not plbllist then
					plbllist = {}
					self.blacklist[self.UserId] = plbllist
				end
				plbllist[id] = (removaltime and removaltime + os.time() or -1)
				asset:WriteJSON("data", serverhopper.file, serverhopper.blacklist)
				log(LOG_NORMAL, "Added " .. game.JobId .. " to server-hop blacklist")
				notification:Create("Added " .. game.JobId .. " to server-hop blacklist")
			end

			function serverhopper:Hop(id)
				log(LOG_NORMAL, "Hopping to server " .. id)
				if serverhopper:IsBlacklisted(id) then
					log(LOG_NORMAL, "This server ID is blacklisted! Where you votekicked from here?")
					notification:Create("This server Id (" .. id .. ") is blacklisted! Where you votekicked from here?")
					return
				end
				local data = statistics:Get("serverhopper")
				data.redirects = data.redirects + 1
				if data.interacted[id] then
					data.interacted[id] = data.interacted[id] + 1
				else
					data.interacted[id] = 1
				end
				statistics:Save()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, id)
				local connection
				connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
					connection:Disconnect()
					data.redirects = data.redirects - 1
					if data.interacted[id] then
						data.interacted[id] = data.interacted[id] - 1
					else
						data.interacted[id] = 0
					end
					statistics:Save()
				end)
			end

			BBOT.chat:AddCommand("hop", function(id)
				if not config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					notification:Create("Cannot hop servers due to unsafe features being disabled!\n[Note: This feature is detected!]")
					return
				end
				if not id or id == "" then
					serverhopper:RandomHop()
					return
				end
				serverhopper:Hop(id)
			end, "Hops to a server instance.")

			BBOT.chat:AddCommand("blacklist", function(id)
				if not id or id == "" then
					return
				end
				serverhopper:AddToBlacklist(id, 86400)
			end, "Adds a server instance to the blacklist.")

			BBOT.chat:AddCommand("rejoin", function()
				if not config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
					notification:Create("Cannot hop servers due to unsafe features being disabled!\n[Note: This feature is detected!]")
					return
				end
				BBOT.serverhopper:Hop(game.JobId)
			end, "Rejoin the current server instance.")

			local autohop = nil
			hook:Add("InternalMessage", "BBOT:ServerHopper.HopOnKick", function(message)
				if not string.find(message, "Server Kick Message:", 1, true) or not string.find(message, "votekicked", 1, true) then return end
				if not serverhopper:IsBlacklisted(game.JobId) then
					serverhopper:AddToBlacklist(game.JobId, 86400)
				end
				if not config:GetValue("Main", "Misc", "Server Hopper", "Hop On Kick") then return end
				autohop = 0
			end)

			hook:Add("RenderStepped", "BBOT:ServerHopper.HopOnKick", function()
				if not autohop or autohop > tick() then return end
				serverhopper:RandomHop()
				autohop = tick() + 3
			end)

			hook:Add("OnKeyBindChanged", "BBOT:ServerHopper.Hop", function(steps)
				if config:IsPathwayEqual(steps, "Main", "Misc", "Server Hopper", "Hop On Kick", "Force Server Hop") and config:GetValue("Main", "Misc", "Server Hopper", "Hop On Kick") then
					serverhopper:RandomHop()
				end
			end)
		end

		-- Lighting
		do
			local math = BBOT.math
			local color = BBOT.color
			local vector = BBOT.vector
			local config = BBOT.config
			local hook = BBOT.hook
			local timer = BBOT.timer
			local loop = BBOT.loop
			local lighting = {}
			BBOT.lighting = lighting

			function lighting.step()
				if not game.Lighting then return end
				if config:GetValue("Main", "Visuals", "World", "Force Time") then
					game.Lighting.ClockTime = config:GetValue("Main", "Visuals", "World", "Custom Time")
				end

				if config:GetValue("Main", "Visuals", "World", "Ambience") then
					game.Lighting.Ambient = config:GetValue("Main", "Visuals", "World", "Ambience", "Inside Ambience")
					game.Lighting.OutdoorAmbient = config:GetValue("Main", "Visuals", "World", "Ambience", "Outside Ambience")
				else
					game.Lighting.Ambient = game.Lighting.MapLighting.Ambient.Value
					game.Lighting.OutdoorAmbient = game.Lighting.MapLighting.OutdoorAmbient.Value
				end

				--[[if config:GetValue("Main", "Visuals", "World", "Specular") then
					game.Lighting.EnvironmentSpecularScale = config:GetValue("Main", "Visuals", "World", "Specular Scale")/100
				end]]
				
				--[[if config:GetValue("Main", "Visuals", "World", "Custom Saturation") and game.Lighting.MapSaturation then
					game.Lighting.MapSaturation.TintColor = config:GetValue("Main", "Visuals", "World", "Custom Saturation", "Saturation Tint")
					game.Lighting.MapSaturation.Saturation = config:GetValue("Main", "Visuals", "World", "Saturation Density") / 50
				end]]
			end

			local runservice = BBOT.service:GetService("RunService")
			loop:Run("BBOT:Lighting.Step", lighting.step, runservice.RenderStepped)
		end

		-- Sound overrides
		do
			local hook = BBOT.hook
			local config = BBOT.config
			local sound = BBOT.aux.sound
			local table = BBOT.table
			local string = BBOT.string
			local asset = BBOT.asset
			local cache = {
				["Headshot Kill"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Headshot Kill") or ""),
				["Kill"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Kill") or ""),
				["Headshot"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Headshot") or ""),
				["Hit"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Hit") or ""),
				["Fire"] = "",
			}

			hook:Add("OnConfigChanged", "BBOT:Sounds.Cache", function(path, old, new)
				local final = path[#path]
				local cacheid = cache[final]
				if cacheid and config:IsPathwayEqual(path, "Main", "Misc", "Sounds", final) then
					if new ~= "" and asset:IsFolder("sounds", new) then
						local o = cache[final]
						local files = {}
						local list = asset:ListFiles("sounds", new)
						for i=1, #list do
							files[#files+1] = asset:GetAsset("sounds", list[i])
						end
						cache[final] = table.fyshuffle(files)
					elseif asset:IsFile("sounds", new) then
						cache[final] = asset:GetAsset("sounds", new)
					else
						local snd = (new or "")
						if snd == "" then
							cache[final] = ""
						elseif snd:match("%a") then
							cache[final] = snd
						else
							cache[final] = "rbxassetid://" .. snd
						end
					end
				end
			end)

			local position = 0
			local function play_sound(name, ...)
				if name == "" then return end
				local soundid = cache[name]
				if soundid == "" then return end
				if typeof(soundid) == "table" then
					position = position + 1
					local ssound = soundid[position]
					if not ssound then
						soundid = table.fyshuffle( soundid )
						position = 1
						ssound = soundid[1]
						cache[name] = soundid
					end
					sound.playid(ssound, ...)
				elseif string.find(soundid, "rbxasset", 1, true) then
					sound.playid(soundid, ...)
				end
				return true
			end

			hook:Add("SuppressSound", "BBOT:Sounds.Overrides", function(soundname, ...)
				if soundname == "headshotkill" then
					return play_sound("Headshot Kill", config:GetValue("Main", "Misc", "Sounds", "Headshot Kill Volume")/100)
				end
				if soundname == "killshot" then
					return play_sound("Kill", config:GetValue("Main", "Misc", "Sounds", "Kill Volume")/100)
				end
				if soundname == "hitmarker" and (cache["Headshot"] ~= "" or cache["Hit"] ~= "") then
					return true
				end
			end)

			hook:Add("WeaponModifyData", "BBOT:Sounds.Override", function(gundata)
				local snd = cache["Fire"]
				if snd ~= "" then
					gundata.firevolume = 0
				end
				--[[local snd = cache["Fire"]
				if snd ~= "" then
					gundata.firesoundid = snd
					gundata.firepitch = nil
				end
				local vol = config:GetValue("Main", "Misc", "Sounds", "Fire Volume")/100
				if vol < 1 then
					gundata.firevolume = vol
				end]]
			end)

			hook:Add("PostNetworkSend", "BBOT:Sounds.Kills", function(netname, Entity, HitPos, Part, bulletID)
				if netname == "newbullets" then
					local gun = BBOT.aux.gamelogic.currentgun
					if gun and gun.data and gun.data.barrel then
						play_sound("Fire", config:GetValue("Main", "Misc", "Sounds", "Fire Volume")/100, nil, gun.data.barrel)
					end
				elseif netname == "bullethit" then
					if Part == "Head" then
						play_sound("Headshot", config:GetValue("Main", "Misc", "Sounds", "Headshot Volume")/100)
					else
						play_sound("Hit", config:GetValue("Main", "Misc", "Sounds", "Hit Volume")/100)
					end
				end
			end)
		end

		-- Replication
		do
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local camera = BBOT.service:GetService("CurrentCamera")
			local config = BBOT.config
			local network = BBOT.aux.network
			local char = BBOT.aux.char
			local roundsystem = BBOT.aux.roundsystem
			local pathing = BBOT.pathing
			local drawpather = BBOT.drawpather
			local hook = BBOT.hook
			local repupdate = {}
			BBOT.repupdate = repupdate

            local map = BBOT.service:GetService("Workspace"):FindFirstChild("Map")
            local map_center, map_min, map_max
            if map then
                local cf, bounds = map:GetBoundingBox()
                map_center = cf.p
                map_min = map_center - 0.5 * bounds
                map_max = map_center + 0.5 * bounds
            end

            -- Detour 'newmap' for restricting repupdate to the inside of map bounds
            hook:Add("Initialize", "BBOT:Newmap.Detour", function()
                for hash, func in next, network.receivers do
                    local consts = getconstants(func)
                    if BBOT.table.quicksearch(consts, "AGMP") then
                        -- we found newmap
                        hook:BindFunction(func, "Newmap")
                        -- hook onto it so we can do stuff
                        hook:Add("PreNewmap", "BBOT:Newmap.SetBounds", function(map)
                            local cf, bounds = map:GetBoundingBox()
                            map_center = cf.p
                            map_min = map_center - 0.5 * bounds
                            map_max = map_center + 0.5 * bounds
                        end)
                        return
                    end
                end
            end)

			-- this is the raycasting for replication, kinda like the server-side version
			-- function -> repupdate:Raycast(origin, offset)
			do
				local rcastparam = RaycastParams.new();
				rcastparam.IgnoreWater = true;

				-- this is the raycasting for replication, kinda like the server-side version
				function repupdate:Raycast(origin, offset, extra, callback)
					local whitelist = { workspace.Ignore, workspace.Players, extra }
					local results
					local calls = 0
					rcastparam.FilterDescendantsInstances = whitelist;
					while calls < 2000 do
						results = workspace:Raycast(origin, offset, rcastparam)
						if not results then break end
						local instance = results.Instance
						if instance.Name ~= "Window" and instance.CanCollide and instance.Transparency ~= 1 then
							break
						end
						if callback and not callback(results) then break end
						table.insert(whitelist, results.Instance)
						rcastparam.FilterDescendantsInstances = whitelist
						calls = calls + 1
					end;
					return results
				end
			end

			-- current position of our replication server-side
			function repupdate:GetPosition()
				return self.position or char.rootpart.Position
			end

            -- check if position is within map bounds (used for teleporting and stuff)
            function repupdate:IsPosWithinMapBounds(p)
                p = p or self:GetPosition()
                return p.x > map_min.x and p.x < map_max.x
                   and p.y > map_min.y and p.y < map_max.y
                   and p.z > map_min.z and p.z < map_max.z
            end

            -- return the closest point from 'p' to the map's bounding box
            function repupdate:ClampPosToMapBounds(p)
                p = p or self:GetPosition()
                local x = p.x < map_min.x and map_min.x or math.min(p.x, map_max.x)
                local y = p.y < map_min.y and map_min.y or math.min(p.y, map_max.y)
                local z = p.z < map_min.z and map_min.z or math.min(p.z, map_max.z)
                return Vector3.new(x, y, z)
            end

			-- can we move to this position?
			function repupdate:CanMoveTo(position)
				local lastpos = self:GetPosition()
				local stanceoffset = self:GetStanceOffset()
				local occupied = self:Raycast(lastpos+stanceoffset, position-lastpos+stanceoffset)
				if occupied then return false else return true end
			end

			-- if we cannot move to a position, find the minimum that we can travel (this is like a TP scanning thing)
			function repupdate:FindMinimumMoveTo(position)
				local lastpos = self:GetPosition()
				local stanceoffset = self:GetStanceOffset()
				local offset = position-lastpos
				local results = self:Raycast(lastpos+stanceoffset, offset+stanceoffset)
				if results then
					return true, results.Position - (offset.Unit * 0.1) - stanceoffset, offset.Unit
				end
				return false, position, offset.Unit
			end

            local dot = Vector3.zero.Dot
			-- moves the player to a position, basially teleport
			function repupdate:MoveTo(position, move_char)
				if not char.alive then return end
				local current_position = self:GetPosition()
				if not self:CanMoveTo(position) then return end

				local diff = (position-current_position)

				if dot(diff, diff) > 81 --[[ diff.Magnitude > 8]] then
                    local mag = diff.magnitude
                    local unit = diff / mag
                    for dt = 9, mag, 9 do
                        network:send("repupdate", current_position + dt * unit, repupdate.angle or Vector2.new(), tick())
                    end
					--[[local timescale = math.round(diff.Magnitude/8)+1
					local tdiff = diff/timescale
					for i=1, timescale do
						network:send("repupdate", current_position + (tdiff*i), repupdate.angle or Vector2.new(), tick())
					end]]
				end

                network:send("repupdate", position, repupdate.angle or Vector2.new(), tick())

				if move_char then
					char.rootpart.CFrame = CFrame.new(current_position + diff, char.rootpart.CFrame.LookVector)
				end
                self.position = position -- i cant believe this wasnt being set
			end

			-- this only moves the character (roblox) and not repupdate
			function repupdate:MoveCharTo(position)
				if not char.alive then return end
				local current_position = self:GetPosition()
				if not self:CanMoveTo(position) then return end
				local diff = (position-current_position)
				char.rootpart.CFrame = CFrame.new(current_position + diff, char.rootpart.CFrame.LookVector)
			end

			do
				local rcastparam = RaycastParams.new()
				rcastparam.IgnoreWater = true
				rcastparam.FilterType = Enum.RaycastFilterType.Blacklist
			
				local pather = pathing.new()
				pather:SetWaypointSpacing(8)
				pather:SetRaycastParameter(rcastparam)
				pather:SetRaycastCallback(function(results)
					local p = results.Instance
					if p.Name:lower() == "killwall" then
						return false
					end
					if not p.CanCollide then
						return true
					end
					if p.Name ~= "Window" then
						return false
					end
					return true
				end)
			
				function repupdate:TeleportTo(position, move_char)
					if not char.alive then return end
					rcastparam.FilterDescendantsInstances = {workspace.Terrain, localplayer.Character, workspace.Ignore, workspace.Players}
					local current_position = self:GetPosition()
					local stanceoffset = self:GetStanceOffset()
					pather:SetRaycastOffset(stanceoffset)
					pather:SetFrom(current_position)
					pather:SetTo(position)
					local path, success = pather:Calculate()
					if success then
						for i=1, #path do
							repupdate:MoveTo(path[i]-stanceoffset, move_char)
						end
					end
					return path, success
				end
			end

			function repupdate:PathTo(path, move_char, reverse)
				for i = (reverse and #path or 1), (reverse and 1 or #path), (reverse and -1 or 1) do
					repupdate:MoveTo(path[i], move_char)
				end
			end

			-- forces the replication system to update regardless
			function repupdate:Force(pos, ang)
				local l__angles__1304 = BBOT.aux.camera.angles;
				network:send("repupdate", pos or char.rootpart.Position, ang or Vector2.new(l__angles__1304.x, l__angles__1304.y), tick())
			end

			local invis_set, invis_time = false, 0
			hook:Add("OnAliveChanged", "BBOT:RepUpdate.Invis", function(alive)
				if not alive then
					invis_set = true
					invis_time = 0
				end
			end)

			-- get's the tick or manipulates the input tick [t] to repupdate's tick
			function repupdate:Tick(t)
				t = t or tick()
				if config:GetValue("Main", "Misc", "Exploits", "Invisibility") then
					if invis_set then
						invis_time = t
						invis_set = false
					end
					t = (t - invis_time) * (0.1^128) -- ^ -99 is wat we want
				elseif config:GetValue("Main", "Misc", "Exploits", "Tick Manipulation") then
					local scalar = (config:GetValue("Main", "Misc", "Exploits", "Higher Division") and 10 or 1)
					return (t/(10^(config:GetValue("Main", "Misc", "Exploits", "Tick Division Scale")*scalar)))
				end
				return t
			end	

			-- stances
			do
				local fake_stance = false
				hook:Add("SuppressNetworkSend", "BBOT:RepUpdate.Stance", function(netname, mode)
					if netname == "stance" and config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance") ~= "Off" and not fake_stance then
						return true
					end
				end)
			
				hook:Add("OnConfigChanged", "BBOT:RepUpdate.Stance", function(steps, old, new)
					if not char.alive then return end
					if not config:IsPathwayEqual(steps, "Main", "Rage", "Anti Aim", "Fake Stance") then return end
					if new ~= "Off" then
						if char.movementmode ~= "prone" then
							fake_stance = true
							network:send("stance", string.lower(new));
							fake_stance = false
						end
					elseif char.movementmode ~= string.lower(new) then
						network:send("stance", char.movementmode);
					end
				end)

				hook:Add("OnAliveChanged", "BBOT:RepUpdate.Stance", function(alive)
					if not alive then return end
					local stance = config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance")
					if stance ~= "Off" then
						fake_stance = true
						network:send("stance", string.lower(stance))
						fake_stance = false
					end
				end)

				function repupdate:GetStance()
					local stance = config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance")
					if stance ~= "Off" then
						return string.lower(stance)
					end
					return char.movementmode
				end

				local vec0 = Vector3.new(0,0,0)
				local stand = Vector3.new(0,1.5,0) -- those values were not right bruh????????
				local crouch = Vector3.new(0,0,0)
				local prone = Vector3.new(0,-1.5,0)
				function repupdate:GetStanceOffset()
					local stance = self:GetStance()
					if stance == "stand" then
						return stand
					elseif stance == "crouch" then
						return crouch
					elseif stance == "prone" then
						return prone
					end
					return vec0
				end
			end

			-- blink (internal, we recommend scripts to not touch these)
			repupdate.blink_record = {}
			repupdate.blink_sending = false
			repupdate.blink_ignore = false
			repupdate.blink_active = false
			repupdate.blink_last = 0

			function repupdate:BlinkUpdate()
				self.blink_sending = true
				local blink_record = self.blink_record
				if #blink_record > 0 then
					local a = {}
					local len = #blink_record
					for i=1, len do
						network:send("repupdate", blink_record[i][1], blink_record[i][2], blink_record[i][3])
						a[#a+1]=blink_record[i][1]
					end
					local col, transparency = config:GetValue("Main", "Misc", "Exploits", "Blink", "Path Color")
					if transparency > 0 then
						drawpather:Simple(a, col, transparency, 4)
					end
				end
				self.blink_record = {}
				self.blink_sending = false
				self.blink_active = false
				self.blink_nextbuffer = math.random(config:GetValue("Main", "Misc", "Exploits", "Blink Min Buffer")*10000, config:GetValue("Main", "Misc", "Exploits", "Blink Max Buffer")*10000)/10000
			end

			hook:Add("Aimbot.NewBullets", "BBOT:RepUpdate.Blink.OnFire", function()
				if repupdate.blink_active and config:GetValue("Main", "Misc", "Exploits", "Blink On Fire") then
					BBOT.menu:UpdateStatus("Blink", "Buffering...")
					repupdate:BlinkUpdate()
				end
			end)

			hook:Add("PreNetworkSend", "BBOT:RepUpdate.Blink.OnFire", function(netname)
				if netname == "newbullets" then
					if repupdate.blink_active and config:GetValue("Main", "Misc", "Exploits", "Blink On Fire") then
						BBOT.menu:UpdateStatus("Blink", "Buffering...")
						repupdate:BlinkUpdate()
					end
				end
			end)

			-- spaz attack
			hook:Add("OnKeyBindChanged", "BBOT:RepUpdate.SpazAttack", function(steps, old, new)
				if not config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Spaz Attack", "KeyBind") then return end
				if new then return end
				if not char.alive then return end
				repupdate:MoveTo(char.rootpart.Position)
			end)

			-- calculations
			hook:Add("SuppressNetworkSend", "BBOT:RepUpdate.Calculate", function(netname, pos, ang, time)
				if netname ~= "repupdate" then return end
				if not repupdate.alive then
					repupdate.blink_record = {}
					repupdate.blink_sending = false
					repupdate.blink_active = false
					repupdate.blink_last = tick()
					repupdate.blink_nextbuffer = nil
					return
				end

				if config:GetValue("Main", "Misc", "Exploits", "Blink") and config:GetValue("Main", "Misc", "Exploits", "Blink", "KeyBind") then
					if BBOT.aimbot.tp_scanning then
						if repupdate.blink_active then
							repupdate:BlinkUpdate()
							repupdate.blink_active = false
							repupdate.blink_nextbuffer = nil
						end
						return
					end

					if not repupdate.blink_ignore and not repupdate.blink_sending then
						local t = repupdate.blink_nextbuffer or config:GetValue("Main", "Misc", "Exploits", "Blink Min Buffer")
						if repupdate.blink_record[1] and repupdate.blink_last + t < tick() and t > 0 then
							BBOT.menu:UpdateStatus("Blink", "Buffering...")
							repupdate:BlinkUpdate()
							repupdate.blink_sending = true
							network:send(netname, pos, ang, time)
							repupdate.blink_sending = false
							repupdate.blink_last = tick()
							repupdate.blink_active = false
							repupdate.blink_nextbuffer = math.random(config:GetValue("Main", "Misc", "Exploits", "Blink Min Buffer")*10000, config:GetValue("Main", "Misc", "Exploits", "Blink Max Buffer")*10000)/10000
						else
							BBOT.menu:UpdateStatus("Blink", "Active"
							.. (t > 0 and " [" .. math.abs(math.round(repupdate.blink_last+t-tick(),1)) .. "s]" or "")
							.. (allowmove and " [" .. math.round((pos-repupdate:GetPosition()).Magnitude, 1) .. " studs]" or ""))
							repupdate.blink_active = true
							local blink_record = repupdate.blink_record
							blink_record[#blink_record+1] = {pos, ang, time}
						end
						return true
					end
				elseif #repupdate.blink_record > 0 then
					repupdate:BlinkUpdate()
					repupdate.blink_last = tick()
					repupdate.blink_active = false
				else
					repupdate.blink_last = tick()
					repupdate.blink_active = false
					repupdate.blink_nextbuffer = nil
				end
			end)

			repupdate.spaz_active = false
			repupdate.antiaim_stutterframes = 0
			hook:Add("PreNetworkSend", "BBOT:RepUpdate.Calculate", function(netname, pos, ang, time)
				if netname ~= "repupdate" then return end
				local modified, tick_changed = false, false
				if not BBOT.aimbot.in_ragebot and not BBOT.aimbot.tp_scanning then
					if config:GetValue("Main", "Misc", "Exploits", "Spaz Attack") and config:GetValue("Main", "Misc", "Exploits", "Spaz Attack", "KeyBind") and not repupdate.spaz_active then
						local intensity = config:GetValue("Main", "Misc", "Exploits", "Spaz Attack Intensity")
						local offset = Vector3.new(math.random(-1000,1000)/1000, math.random(-1000,1000)/1000, math.random(-1000,1000)/1000)*config:GetValue("Main", "Misc", "Exploits", "Spaz Attack Intensity")
						local results = BBOT.aimbot:raycastbullet(pos, offset)
						if results then
							offset = offset - (offset.Unit * 2)
						end
						pos = pos + offset
						repupdate.spaz_active = true
						repupdate:MoveTo(pos - (offset.Unit/100))
						repupdate.spaz_active = false
						time = repupdate:Tick()
						tick_changed = true
						modified = true
					end

					local infloor = config:GetValue("Main", "Rage", "Anti Aim", "In Floor")
					if infloor > 0 then
						pos = pos + Vector3.new(0,-infloor,0)
						modified = true
					end
				end
				
				if config:GetValue("Main", "Rage", "Anti Aim", "Enabled") then
					repupdate.antiaim_stutterframes += 1
					local pitch = ang.x
					local yaw = ang.y
					local pitchChoice = config:GetValue("Main", "Rage", "Anti Aim", "Pitch")
					local yawChoice = config:GetValue("Main", "Rage", "Anti Aim", "Yaw")
					local spinRate = config:GetValue("Main", "Rage", "Anti Aim", "Spin Rate")

					---"off,down,up,roll,upside down,random"
					--"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random", "Bob", "Glitch",
					local new_angles
					if pitchChoice == "Up" then
						pitch = -4
					elseif pitchChoice == "Zero" then
						pitch = 0
					elseif pitchChoice == "Down" then
						pitch = 4.7
					elseif pitchChoice == "Upside Down" then
						pitch = -math.pi
					elseif pitchChoice == "Roll Forward" then
						pitch = (tick() * spinRate) % 6.28
					elseif pitchChoice == "Roll Backward" then
						pitch = (-tick() * spinRate) % 6.28
					elseif pitchChoice == "Random" then
						pitch = math.random(-99999,99999)/99999
						pitch = pitch*1.47262156
					elseif pitchChoice == "Bob" then
						pitch = math.sin((tick() % 6.28) * spinRate)
					elseif pitchChoice == "Glitch" then
						pitch = 2 ^ 127 + 1
					end

					--"Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin"
					if yawChoice == "Backward" then
						yaw += math.pi
					elseif yawChoice == "Spin" then
						yaw = (tick() * spinRate) % 360
					elseif yawChoice == "Random" then
						yaw = math.random(-99999,99999)
					elseif yawChoice == "Glitch Spin" then
						yaw = 16478887
					elseif yawChoice == "Invisible" then
						yaw = (2.0^127) + 2
					elseif yawChoice == "Stutter Spin" then
						yaw = repupdate.antiaim_stutterframes % (6 * (spinRate / 4)) >= ((6 * (spinRate / 4)) / 2) and 2 or -2
					end

					ang = Vector2.new(math.clamp(pitch, -1.47262156, 1.47262156), yaw)
					modified = true
				end

				if modified then
					return netname, pos, ang, (tick_changed and time or repupdate:Tick(time))
				else
					return netname, pos, ang, repupdate:Tick(time)
				end
			end)

			hook:Add("OnAliveChanged", "BBOT:RepUpdate.Alive", function(alive)
				if not alive then
					repupdate.position = nil
					repupdate.angle = nil
					repupdate.time = nil
					repupdate.alive = false
				end
			end)

			hook:Add("PostNetworkSend", "BBOT:RepUpdate.Calculate", function(netname, pos, ang, time)
				if netname ~= "repupdate" then return end
				repupdate.position = pos
				repupdate.angle = ang
				repupdate.time = time
				repupdate.alive = true
			end)
		end

		-- Misc
		--misc for failsafe :3
		do
			local notification = BBOT.notification
			local userinputservice = BBOT.service:GetService("UserInputService")
			local camera = BBOT.service:GetService("CurrentCamera")
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local _players = BBOT.service:GetService("Players")
			local hook = BBOT.hook
			local math = BBOT.math
			local timer = BBOT.timer
			local config = BBOT.config
			local roundsystem = BBOT.aux.roundsystem
			local network = BBOT.aux.network
			local char = BBOT.aux.char
			local loop = BBOT.loop
			local string = BBOT.string
			local table = BBOT.table
			local aux_camera = BBOT.aux.camera
			local vector = BBOT.vector
			local hud = BBOT.aux.hud
			local replication = BBOT.aux.replication
			local gamelogic = BBOT.aux.gamelogic
			local gamemenu = BBOT.aux.menu
			local repupdate = BBOT.repupdate
			local misc = {}
			BBOT.misc = misc

			local CACHED_VEC3 = Vector3.new()

			do
				hook:Add("OnConfigChanged", "BBOT:Misc.KillCamTimer", function(steps, old, new)
					if not config:IsPathwayEqual(steps, "Main", "Visuals", "Extra", "KillCam Timer") then return end
					BBOT.menu:UpdateStatus("Kill Cam", "None", new)
				end)

				local kill_time, kill_name = 0, ""
				hook:Add("PreBigAward", "BBOT:Misc.KillCamTimer", function(type, entity, gunname, earnings)
					kill_time = tick() + 5
					kill_name = entity.Name
				end)

				hook:Add("RenderStepped", "BBOT:Misc.KillCamTimer", function()
					if not config:GetValue("Main", "Visuals", "Extra", "KillCam Timer") then return end
					if kill_time > tick() then
						BBOT.menu:UpdateStatus("Kill Cam", kill_name .. " [" .. math.round(kill_time-tick(), 1) .. "]")
					else
						BBOT.menu:UpdateStatus("Kill Cam", "None")
					end
				end)
			end

			do
				-- Removes camera bob lul
				local char_distance, char_speed = 0, 0
				hook:Add("PreCameraStep", "BBOT:Misc.NoCameraBob", function()
					if config:GetValue("Main", "Visuals", "Camera Visuals", "No Camera Bob") then
						char_distance = char.distance
						char_speed = char.speed
						char.distance = 0
						char.speed = 0
					end
				end)

				hook:Add("PostCameraStep", "BBOT:Misc.NoCameraBob", function()
					if config:GetValue("Main", "Visuals", "Camera Visuals", "No Camera Bob") then
						char.distance = char_distance
						char.speed = char_speed
					end
				end)
			end

			local virtualuser = BBOT.service:GetService("VirtualUser")
			hook:Add("LocalPlayer.Idled", "BBOT:Misc.AntiAFK", function()
				if config:GetValue("Main", "Misc", "Extra", "Anti AFK") then
					virtualuser:CaptureController()
					virtualuser:ClickButton2(Vector2.new())
				end
			end)

			local wasalive = false
			local last_alive = 0
			hook:Add("OnAliveChanged", "BBOT:AutoDeath", function()
				wasalive = true
				last_alive = tick()
			end)

			local game_version

			local streamermode_old = hud.streamermode
			hook:Add("Unload", "BBOT:StreamerMode", function()
				hud.streamermode = streamermode_old
			end)

			function hud.streamermode()
				return streamermode_old() or config:GetValue("Main", "Misc", "Extra", "Streamer Mode")
			end

			hook:Add("OnConfigChanged", "BBOT:StreamerMode", function(steps, old, new)
				if not config:IsPathwayEqual(steps, "Main", "Misc", "Extra", "Streamer Mode") then return end
				local chatgame = localplayer.PlayerGui:FindFirstChild("ChatGame")
				if chatgame then
					local version = chatgame:FindFirstChild("Version")
					if new then
						if not game_version then
							game_version = version.Text
						end
						version.Text = "Streamer-Mode"
					elseif game_version then
						version.Text = game_version
					end
				end
			end)

			hook:Add("PreupdateStep", "BBOT:Misc.DeRenderAll", function(player, controller, renderscale, shouldrender)
				if config:GetValue("Main", "Misc", "Extra", "Simple Characters") then
					return 0, false
				end
			end)

			do
				local function findplayer(name)
					local target = nil
					for k, v in pairs(_players:GetPlayers()) do
						if string.find(v.Name, name, 1, true) then
							target = v
							break
						end
					end
					return target
				end

				local httpservice = BBOT.service:GetService("HttpService")
				local path = "bitchbot/"..BBOT.game.."/data/accounts.json"
				local accounts, accounts_invert = {}, {}
				if isfile(path) then
					accounts = httpservice:JSONDecode(readfile(path))
				end
				
				accounts[BBOT.accountId] = BBOT.account or true
				for k, v in pairs(accounts) do accounts_invert[v] = k end
				writefile(path, httpservice:JSONEncode(accounts))

				loop:Run("BBOT:AutoFriendAccounts", function()
					if not isfile(path) then return end
					accounts = httpservice:JSONDecode(readfile(path))
					for k, v in pairs(accounts) do accounts_invert[v] = k end
				end, 5)

				hook:Add("GetPriority", "BBOT:AutoFriendAccounts", function(player)
					if not config:GetValue("Main", "Misc", "Extra", "Auto Friend Accounts") then return end
					if accounts[tostring(player.UserId)] then
						return -1, "Bot/Account"
					end
				end)

				hook:Add("Votekick.Start", "BBOT:AutoVoteNoOnFriends", function(target, delay, votesrequired)
					if target ~= localplayer.Name and config:GetPriority(findplayer(target)) < 0 and config:GetValue("Main", "Misc", "Extra", "Friends Votes No") then
						timer:Simple(.5, function() hud:vote("no") end)
					end
				end)

				hook:Add("Console", "BBOT:AutoVoteYesOnEnemy", function(message)
					if string.find(message, "has initiated a votekick on", 1, true) then
						local name = string.Explode(" ", message)
						name = name[1]
						if config:GetPriority(findplayer(name)) < 0 and config:GetValue("Main", "Misc", "Extra", "Assist Votekicks") then
							timer:Simple(math.random(2,15)/10, function() hud:vote("yes") end)
						end
					end
				end)

				hook:Add("PostInitialize", "BBOT:AutoHopOnFriends", function()
					local amount = config:GetValue("Main", "Misc", "Extra", "Auto Hop On Friends")
					if amount > 0 then
						local c = 0
						for k, v in pairs(_players:GetPlayers()) do
							local value, reason = config:GetPriority(v)
							if value == -1 then
								c = c + 1
							end
						end
						if c >= amount then
							BBOT.serverhopper:RandomHop()
						end
					end
				end)
			end

			local runservice = BBOT.service:GetService("RunService")
			local rendering3d_last = false
			hook:Add("Heartbeat", "BBOT:3DRendering", function()
				local rendering = config:GetValue("Main", "Misc", "Extra", "Disable 3D Rendering")
				if rendering ~= rendering3d_last then
					runservice:Set3dRenderingEnabled(not rendering)
					rendering3d_last = rendering
				end
			end)

			setfpscap(144)
			hook:Add("OnConfigChanged", "BBOT:FPSCap", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Misc", "Extra", "FPS Limiter") then
					if new == 300 then
						new = 1000
					end
					setfpscap(new)
				end
			end)

			local function checkaliveenemies()
				for player, controller in pairs(replication.player_registry) do
					if controller.updater and player ~= localplayer and player.Team ~= localplayer.Team and controller.updater.alive then
						if config:GetPriority(player) >= 0 then
							return true
						end
					end
				end
			end

			hook:Add("RenderStepped", "BBOT:AutoDeath", function()
				if wasalive and config:GetValue("Main", "Misc", "Extra", "Auto Death On Nades") and gamelogic.gammo < 1 and last_alive + .25 < tick() then
					hook:Call("AutoDeath")
					wasalive = false
					network:send("forcereset")
				elseif config:GetValue("Main", "Misc", "Extra", "Auto Spawn") and config:GetValue("Main", "Misc", "Extra", "Auto Spawn", "KeyBind") and not gamemenu.isdeployed() then
					local onalive = config:GetValue("Main", "Misc", "Extra", "Spawn On Alive")
					if not onalive or (onalive and checkaliveenemies()) then
						gamemenu:deploy()
						hook:Call("Spawn")
					end
				end
			end)

			hook:Add("Preupdatespawn", "BBOT:AutoDeath", function(player)
				if wasalive and player.Team ~= localplayer.Team and config:GetValue("Main", "Misc", "Extra", "Reset On Enemy Spawn") and config:GetPriority(player) >= 0 then
					hook:Call("AutoDeath")
					wasalive = false
					network:send("forcereset")
				end
			end)
			
			do
				function misc:TeleportToClosest()
					if BBOT.aimbot.tp_scanning then return end
					local players = {}
					for i, Player in pairs(_players:GetPlayers()) do
						if Player.Team == localplayer.Team then continue end
						local updater = replication.getupdater(Player)
						if updater and updater.alive then
							players[#players+1] = {Player, updater, updater.getpos()}
						end
					end

					if #players < 1 then return end

					local root_position = char.rootpart.Position
					table.sort(players, function(a, b)
						return (a[3] - root_position).Magnitude < (b[3] - root_position).Magnitude
					end)

					local points
					for i=1, #players do
						local player = players[i]
						if not char.alive or not player[2].alive then continue end
						local path, success = repupdate:TeleportTo(player[3], true)
						if success then
							local color, color_transparency = config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "Path Color")
							BBOT.drawpather:Simple(path, color, color_transparency, 4)
							return
						end
					end
				end

				function misc:IsPointInsidePart(part, point)
					local r = part.CFrame:PointToObjectSpace(point)
					local s = part.Size
					return math.abs(r.x) <= s.x/2 and math.abs(r.y) <= s.y/2 and math.abs(r.z) <= s.z/2
				end

				local mapRaycastParams = RaycastParams.new()
				mapRaycastParams.FilterType = Enum.RaycastFilterType.Whitelist
				mapRaycastParams.IgnoreWater = true

				-- direction must be unit
				-- literally only works sometimes but idfk
				function misc:GetNoclipSequence(origin, direction, stepDistance, maxSteps)
					mapRaycastParams.FilterDescendantsInstances = roundsystem.raycastwhitelist or {}

					local origin = origin or char.rootpart.Position
					local unit = direction
					local dir = unit * stepDistance

					local headheight = char.headheight
					-- for correcting stance bullshiz
					local headheightVec = Vector3.new(0, headheight)
					local correctedOrigin = origin + headheightVec
					local sequence = {correctedOrigin}

					local pass = true

					for _ = 1, maxSteps do
						local cast = workspace:Raycast(sequence[#sequence], dir, mapRaycastParams)
						if cast then
							local partHit = cast.Instance
							if partHit.ClassName == "Part" and partHit.Shape == Enum.PartType.Block and not partHit:FindFirstChildWhichIsA("Mesh") then
								-- might need to add a congruency check
								if misc:IsPointInsidePart(partHit, cast.Position) then
									sequence[#sequence + 1] = cast.Position
								else
									-- point is probably just before the surface
									pass = false
									break
								end
							else
								-- cant pass through stupid slanted crazy looking ass parts
								-- because roblox can solve those better and that function above
								-- which tells if a point is inside of a part or not won't work on it 
								-- as intended if it has a custom mesh (duh..)
								pass = false
								break
							end
						else
							sequence[#sequence + 1] = correctedOrigin + dir
						end
					end

					-- verify sequence isnt actually intersecting anything for some reason?? (roblo$$$raycasting$$)
					-- no, i shouldn't do this, but for some reason creams pathfinding shit isnt
					-- uber slow either??? even though it verifies paths like this

					for i = 1, #sequence - 1 do
						local current, next = sequence[i], sequence[i + 1]
						local diff = next - current
						if workspace:Raycast(current, diff, mapRaycastParams) then
							pass = false
							break
						end
					end

					return sequence, pass
				end

				local mouse = BBOT.service:GetService("Mouse")

				hook:Add("OnKeyBindChanged", "BBOT.Misc.ClickTP", function(steps, old, new)
					if char.alive and config:GetValue("Main", "Misc", "Exploits", "Click TP")
					and config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Click TP", "KeyBind") then
						local range = config:GetValue("Main", "Misc", "Exploits", "Click TP Range")
						local tp = BBOT.aimbot:raycastbullet(camera.CFrame.p, camera.CFrame.lookVector * (range == 0 and 2000 or range))
						if tp then
							repupdate:MoveTo(tp.Position - (camera.CFrame.lookVector * .5) + Vector3.new(0,3,0), true)
						elseif range ~= 0 then
							local pos = camera.CFrame.p + camera.CFrame.lookVector * range
							repupdate:MoveTo(pos - (camera.CFrame.lookVector * .5) + Vector3.new(0,3,0), true)
						end
					end
				end)

				hook:Add("OnKeyBindChanged", "BBOT.Misc.NoclipTest", function(steps, old, new)
					if char.alive and config:GetValue("Main", "Misc", "Exploits", "Noclip")
					and config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Noclip", "KeyBind") then
						-- (origin, direction, stepDistance, maxSteps)
						local directions = {
							-Vector3.xAxis,
							Vector3.xAxis,
							Vector3.zAxis,
							-Vector3.zAxis
						}

						local noclipSequence
						local rootPos = char.rootpart.Position

						for j = 1, #directions do
							local tempSequence, canNoclip = misc:GetNoclipSequence(rootPos, directions[j], 100, 16)

							if canNoclip then
								noclipSequence = tempSequence
								break
							end
						end

						if not noclipSequence then
							notification:Create("Noclip check failure")
							return
						else
							local camAngles = Vector2.new(BBOT.aux.camera.angles.x, BBOT.aux.camera.angles.y)
							if #noclipSequence > 2 then
								local headheight = char.headheight
								local headheightVec = Vector3.new(0, headheight)
								BBOT.aux.network:send("repupdate", rootPos, camAngles, tick())
								for i = 2, #noclipSequence do
									local pos = noclipSequence[i] - headheightVec
									repupdate:MoveTo(pos, false)
								end

								char.rootpart.Position = noclipSequence[#noclipSequence] - headheightVec
								notification:Create("Noclip (probably) success")
							else
								notification:Create("Not enough points in noclip sequence")
							end
						end
					end
				end)

				hook:Add("OnKeyBindChanged", "BBOT.Misc.Teleport", function(steps, old, new)
					if char.alive and config:GetValue("Main", "Misc", "Exploits", "Teleport to Player") and config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Teleport to Player", "KeyBind") then
						if BBOT.aimbot.tp_scanning then return end
						local players = {}
						for i, Player in pairs(_players:GetPlayers()) do
							if Player.Team == localplayer.Team then continue end
							local updater = replication.getupdater(Player)
							if updater and updater.alive then
								local abspos = updater.getpos()
								local pos, onscreen = camera:WorldToViewportPoint(abspos)
								if onscreen then
									players[#players+1] = {Player, pos, abspos, updater}
								end
							end
						end

						local mousePos = Vector3.new(mouse.x, mouse.y + 36, 0)
						table.sort(players, function(a, b)
							return (a[2] - mousePos).Magnitude < (b[2] - mousePos).Magnitude
						end)

						local player = players[1]
						if not char.alive then return end
						local path, success = repupdate:TeleportTo(player[3], true)
						local color, color_transparency = config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "Path Color")
						BBOT.drawpather:Simple(path, color, color_transparency, 4)
					end
				end)
			end

			local next_teleport = 0
			hook:Add("OnAliveChanged", "BBOT:Misc.AutoTeleport", function(alive)
				if alive and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport")["On Spawn"] and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "KeyBind") then
					next_teleport = tick() + 1
					misc:TeleportToClosest()
				end
			end)

			hook:Add("Postupdatespawn", "BBOT:Misc.AutoTeleport", function()
				if char.alive and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport")["On Enemy Spawn"] and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "KeyBind") then
					next_teleport = tick() + 1
					misc:TeleportToClosest()
				end
			end)

			hook:Add("RenderStepped", "BBOT:Misc.AutoTeleport", function()
				if char.alive and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport")["Enemies Alive"] and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "KeyBind")  and next_teleport < tick() then
					next_teleport = tick() + 1
					misc:TeleportToClosest()
				end
			end)

			hook:Add("OnConfigChanged", "BBOT:Misc.Fly", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Misc", "Movement", "Fly") and not config:IsPathwayEqual(steps, "Main", "Misc", "Movement", "Fly", "KeyBind") then
					if not new and char.alive and misc.rootpart then
						misc.rootpart.Anchored = false
					end
				end
			end)

			hook:Add("OnKeyBindChanged", "BBOT:Misc.Fly", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Misc", "Movement", "Fly", "KeyBind") then
					if not new and char.alive and misc.rootpart then
						misc.rootpart.Anchored = false
					end
				end
			end)
			
			hook:Add("SuppressNetworkSend", "BBOT:Misc.Tweaks", function(networkname, Entity, HitPos, Part, bulletID, ...)
				if networkname == "falldamage" and config:GetValue("Main", "Misc", "Tweaks", "Prevent Fall Damage") then
					return true
				end
			end)

			function misc:Fly(delta)
				if not config:GetValue("Main", "Misc", "Movement", "Fly") or not config:GetValue("Main", "Misc", "Movement", "Fly", "KeyBind") then return end
				local speed = config:GetValue("Main", "Misc", "Movement", "Fly Speed")
				local rootpart = self.rootpart -- Invis compatibility

				local travel = CACHED_VEC3
				local looking = camera.CFrame.lookVector --getting camera looking vector
				local rightVector = camera.CFrame.RightVector
				if userinputservice:IsKeyDown(Enum.KeyCode.W) then
					travel += looking
				end
				if userinputservice:IsKeyDown(Enum.KeyCode.S) then
					travel -= looking
				end
				if userinputservice:IsKeyDown(Enum.KeyCode.D) then
					travel += rightVector
				end
				if userinputservice:IsKeyDown(Enum.KeyCode.A) then
					travel -= rightVector
				end
				if userinputservice:IsKeyDown(Enum.KeyCode.Space) then
					travel += Vector3.new(0, 1, 0)
				end
				if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
					travel -= Vector3.new(0, 1, 0)
				end

				if config:GetValue("Main", "Misc", "Movement", "Circle Strafe") and config:GetValue("Main", "Misc", "Movement", "Circle Strafe", "KeyBind") then
					if misc.speedDirection.x ~= misc.speedDirection.x then 
						misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
					end
					local origin = travel.Y
					misc.circleStrafeAngle = -0.1
					if userinputservice:IsKeyDown(Enum.KeyCode.D) then
						misc.circleStrafeAngle = 0.1
					end
					if userinputservice:IsKeyDown(Enum.KeyCode.A) then
						misc.circleStrafeAngle = -0.1
					end
					local cd = Vector2.new(misc.speedDirection.x, misc.speedDirection.z)
					local scale = delta * config:GetValue("Main", "Misc", "Movement", "Circle Strafe Scale")
					cd = vector.rotate(cd, misc.circleStrafeAngle * scale)
					misc.speedDirection = Vector3.new(cd.x, travel.Y, cd.y)
					travel = misc.speedDirection
				end

				if travel.Unit.x == travel.Unit.x then
					rootpart.Anchored = false
					rootpart.Velocity = travel.Unit * speed --multiplaye the unit by the speed to make
				else
					rootpart.Velocity = Vector3.new(0, 0, 0)
					rootpart.Anchored = true
				end
			end

			misc.speedDirection = Vector3.new(1,0,0)
			function misc:Speed(delta)
				if config:GetValue("Main", "Misc", "Movement", "Fly") and config:GetValue("Main", "Misc", "Movement", "Fly", "KeyBind") then return end
				local speedtype = config:GetValue("Main", "Misc", "Movement", "Speed Type")
				local rootpart = self.rootpart
				if config:GetValue("Main", "Misc", "Movement", "Speed") then
					local speed = config:GetValue("Main", "Misc", "Movement", "Speed Factor")

					local travel = CACHED_VEC3
					local looking = camera.CFrame.LookVector
					local rightVector = camera.CFrame.RightVector
					local moving = false
					if not config:GetValue("Main", "Misc", "Movement", "Circle Strafe") or not config:GetValue("Main", "Misc", "Movement", "Circle Strafe", "KeyBind") then
						if userinputservice:IsKeyDown(Enum.KeyCode.W) then
							travel += looking
						end
						if userinputservice:IsKeyDown(Enum.KeyCode.S) then
							travel -= looking
						end
						if userinputservice:IsKeyDown(Enum.KeyCode.D) then
							travel += rightVector
						end
						if userinputservice:IsKeyDown(Enum.KeyCode.A) then
							travel -= rightVector
						end
						misc.speedDirection = Vector3.new(travel.x, 0, travel.z).Unit
						-- if misc.speedDirection.x ~= misc.speedDirection.x then 
						-- 	misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
						-- end
						misc.circleStrafeAngle = -0.1
					else
						if misc.speedDirection.x ~= misc.speedDirection.x then 
							misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
						end
						travel = misc.speedDirection
						misc.circleStrafeAngle = -0.1
						
						if userinputservice:IsKeyDown(Enum.KeyCode.D) then
							misc.circleStrafeAngle = 0.1
						end
						if userinputservice:IsKeyDown(Enum.KeyCode.A) then
							misc.circleStrafeAngle = -0.1
						end
						local cd = Vector2.new(misc.speedDirection.x, misc.speedDirection.z)
						local scale = delta * config:GetValue("Main", "Misc", "Movement", "Circle Strafe Scale")
						cd = vector.rotate(cd, misc.circleStrafeAngle * scale)
						misc.speedDirection = Vector3.new(cd.x, 0, cd.y)
					end

					travel = misc.speedDirection
					if config:GetValue("Main", "Misc", "Movement", "Avoid Collisions") and config:GetValue("Main", "Misc", "Movement", "Avoid Collisions", "KeyBind") then
						if config:GetValue("Main", "Misc", "Movement", "Circle Strafe") and config:GetValue("Main", "Misc", "Movement", "Circle Strafe", "KeyBind") then
							local scale = config:GetValue("Main", "Misc", "Movement", "Avoid Collisions Scale") / 1000
							local position = char.rootpart.CFrame.p
							local part, position, normal = workspace:FindPartOnRayWithWhitelist(
								Ray.new(position, (travel * speed * scale)),
								roundsystem.raycastwhitelist
							) 
							if part then
								for i = -10, 10 do
									local cd = Vector2.new(travel.x, travel.z)
									cd = vector.rotate(cd, misc.circleStrafeAngle * i * -1)
									cd = Vector3.new(cd.x, 0, cd.y)
									local part, position, normal = workspace:FindPartOnRayWithWhitelist(
										Ray.new(position, (cd * speed * scale)),
										roundsystem.raycastwhitelist
									) 
									misc.normal = normal
									if not part then 
										travel = cd
									end
								end
							end
						else
							local position = char.rootpart.CFrame.p
							for i = 1, 10 do
								local part, position, normal = workspace:FindPartOnRayWithWhitelist(
									Ray.new(position, (travel * speed / 10) + Vector3.new(0,rootpart.Velocity.y/10,0)),
									roundsystem.raycastwhitelist
								) 
								misc.normal = normal
								if part then 
									local dot = normal.Unit:Dot((char.rootpart.CFrame.p - position).Unit)
									misc.normalPositive = dot
									if dot > 0 then
										travel += normal.Unit * dot
										travel = travel.Unit
										if travel.x == travel.x then
											misc.circleStrafeDirection = travel
										end
									end
								end
							end
						end
					end
					local humanoid = self.humanoid
					if travel.x == travel.x and humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
						if speedtype == "In Air" and (humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or not humanoid.Jump) then
							return
						elseif speedtype == "On Hop" and not userinputservice:IsKeyDown(Enum.KeyCode.Space) then
							return
						end
					
						if config:GetValue("Main", "Misc", "Movement", "Speed", "KeyBind") then
							rootpart.Velocity = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.z * speed)
						end
					end
				end
			end

			function misc:AutoJump()
				if config:GetValue("Main", "Misc", "Movement", "Auto Jump") and userinputservice:IsKeyDown(Enum.KeyCode.Space) then
					misc.humanoid.Jump = true
				end
			end

			local CHAT_GAME = localplayer.PlayerGui.ChatGame
			local CHAT_BOX = CHAT_GAME:FindFirstChild("TextBox")

			function misc:BypassSpeedCheck()
				local val = config:GetValue("Main", "Misc", "Exploits", "Bypass Speed Checks")
				local character = localplayer.Character
				if not character then return end
				local rootpart = character:FindFirstChild("HumanoidRootPart")
				if not rootpart then
					return
				end
				rootpart.Anchored = false
				self.oldroot = rootpart

				if val and char.alive and not self.newroot then
					copy = rootpart:Clone()
					copy.Parent = character
					self.newroot = copy
				elseif self.newroot then
					if ((not val) or (not gamelogic.currentgun) or (not char.alive) or (not gamemenu.isdeployed())) then
						self.newroot:Destroy()
						self.newroot = nil
					else
						-- client.char.rootpart.CFrame = self.newroot.CFrame
						--idk if i can manipulate this at all
					end
				end
			end

			do
				local oldjump = char.jump
				function char:jump(height)
					height = config:GetValue("Main", "Misc", "Tweaks", "Jump Power") and (height * config:GetValue("Main", "Misc", "Tweaks", "Jump Power Percentage") / 100) or height
					return oldjump(self, height)
				end

				hook:Add("Unload", "BBOT:Misc.JumpPower", function()
					char.jump = oldjump
				end)
			end

			misc.beams = {}
			local debris = BBOT.service:GetService("Debris")
			local tween = BBOT.service:GetService("TweenService")
			function misc:CreateBeam(origin_att, ending_att, texture)
				local beam = Instance.new("Beam")
				beam.Texture = texture or "http://www.roblox.com/asset/?id=446111271"
				beam.TextureMode = Enum.TextureMode.Wrap
				beam.TextureSpeed = 8
				beam.LightEmission = 1
				beam.LightInfluence = 1
				beam.TextureLength = 12
				beam.FaceCamera = true
				beam.Enabled = true
				beam.ZOffset = -1
				beam.Transparency = NumberSequence.new(0,0)
				beam.Color = ColorSequence.new(config:GetValue("Main", "Visuals", "Misc", "Bullet Tracers", "Tracer Color"), Color3.new(0, 0, 0))
				beam.Attachment0 = origin_att
				beam.Attachment1 = ending_att
				debris:AddItem(beam, 3)
				debris:AddItem(origin_att, 3)
				debris:AddItem(ending_att, 3)

				local speedtween = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
				tween:Create(beam, speedtween, { TextureSpeed = 2 }):Play()
				beam.Parent = workspace
				table.insert(misc.beams, { beam = beam, time = tick() })
				return beam
			end

			function misc:UpdateBeams()
				local time = tick()
				for i = #self.beams, 1, -1 do
					if self.beams[i].beam  then
						local transparency = (time - self.beams[i].time) - 2
						self.beams[i].beam.Transparency = NumberSequence.new(transparency, transparency)
					else
						table.remove(self.beams, i)
					end
				end
			end

            function misc:RollCases()
                local inventoryData = BBOT.aux.playerdata.getdata().settings.inventorydata
                local availableCases = {}
                local availableCaseKeys = {}

                for i = 1, #inventoryData do
                    local data = inventoryData[i]
                    local type = data.Type
                    if type:match("^Case") then
                        local dataName = data.Name
                        local isKey = type:match("Key$") ~= nil
                        local insertingInto = isKey and availableCaseKeys or availableCases
                        if not insertingInto[dataName] then
                            insertingInto[dataName] = {}
                        end
                        local array = insertingInto[dataName]
                        array[#array + 1] = data
                    end
                end

                local casesRolled = {}

                for caseName, cases in next, availableCases do
                    local caseKeys = availableCaseKeys[caseName]
                    local keyAmount = caseKeys and #caseKeys or 0
                    if keyAmount > 0 then
                        casesRolled[caseName] = keyAmount
                    end
                end

                local casesRolledNum = 0
                for caseName, caseRollAmount in next, casesRolled do
                    casesRolledNum += caseRollAmount
                    for _ = 1, caseRollAmount do
                        BBOT.aux.network:send("startrollrequest", caseName)
                    end
                end

                if casesRolledNum > 0 then
                    BBOT.notification:Create(string.format("Rolled %d case%s from inventory", casesRolledNum, casesRolledNum > 1 and "s" or ""), 10)
                else
                    BBOT.notification:Create("No cases available", 5)
                end
            end

            function misc:SellSkins()
                local inventoryData = BBOT.aux.playerdata.getdata().settings.inventorydata
                
                local skinsSold = 0
                for i = 1, #inventoryData do 
                    local data = inventoryData[i]
                    if data.Type == "Skin" then
                    	BBOT.aux.network:send("sellskinrequest", data.Name, data.Wep)
                    	skinsSold += 1
                    end
                end

                if skinsSold > 0 then
                	BBOT.notification:Create(string.format("Sold %d skin%s", skinsSold, skinsSold > 1 and "s" or ""), 10)
                else
                	BBOT.notification:Create("You don't seem to have skins on this account!", 5)
                end
            end

			local bullet_query = {}
			hook:Add("PostNetworkSend", "BBOT:Misc.BulletTracer", function(networkname, ...)
				if networkname == "newbullets" then
					if not config:GetValue("Main", "Visuals", "Misc", "Bullet Tracers") then return end
					local args = {...}
					if not args[1] then return end
					local reg = args[1]
					local bullettable = reg.bullets
					for i=1, #bullettable do
						local v = bullettable[i]
						bullet_query[v[2]] = reg.firepos
					end
				elseif networkname == "bullethit" then
					local args = {...}
					local Entity, HitPos, Part, bulletID = args[1], args[2], args[3], args[4]
					if bullet_query[bulletID] then
						local attach_origin = Instance.new("Attachment", workspace.Terrain)
						attach_origin.Position = bullet_query[bulletID]
						local attach_ending = Instance.new("Attachment", workspace.Terrain)
						attach_ending.Position = HitPos
						local beam = misc:CreateBeam(attach_origin, attach_ending)
						beam.Parent = workspace
					end
				end
			end)

			hook:Add("RenderStepped", "BBOT:Misc.Calculate", function(delta)
				misc:UpdateBeams()
				misc:BypassSpeedCheck()
				if not char.alive then
					misc.humanoid = nil
					misc.rootpart = nil
					return
				end
				if not misc.humanoid then
					misc.humanoid = localplayer.Character:FindFirstChild("Humanoid")
					misc.rootpart = localplayer.Character:FindFirstChild("HumanoidRootPart")
				end
				misc.rootpart = (misc.newroot or misc.oldroot)
				char.rootpart = misc.rootpart
				if not CHAT_BOX.Active then
					misc:Fly(delta)
					misc:Speed(delta)
					misc:AutoJump(delta)
				end
			end)

			function misc:GrenadeTP(position)
				if gamelogic.gammo < 1 then return end
				local args = {
					"FRAG",
					{
						frames = {
							{
								v0 = Vector3.new(),
								glassbreaks = {},
								t0 = 0,
								offset = Vector3.new(),
								rot0 = CFrame.new(),
								a = Vector3.new(0 / 0),
								p0 = char.rootpart.Position,
								rotv = Vector3.new(),
							},
							{
								v0 = Vector3.new(),
								glassbreaks = {},
								t0 = 0.002,
								offset = Vector3.new(),
								rot0 = CFrame.new(),
								a = Vector3.new(0 / 0),
								p0 = Vector3.new(0 / 0),
								rotv = Vector3.new(),
							},
							{
								v0 = Vector3.new(),
								glassbreaks = {},
								t0 = 0.003,
								offset = Vector3.new(),
								rot0 = CFrame.new(),
								a = Vector3.new(),
								p0 = position,
								rotv = Vector3.new(),
							},
						},
						time = tick(),
						blowuptime = 0.003,
					},
				}
				gamelogic.gammo = gamelogic.gammo - 1
				hud:updateammo("GRENADE");
				network:send("newgrenade", unpack(args))
			end

			hook:Add("LocalKilled", "BBOT:RevengeGrenade", function(player)
				if player == localplayer then return end
				if not config:GetValue("Main", "Misc", "Exploits", "Revenge Grenade") then return end
				local controller = replication.getupdater(player)
				misc:GrenadeTP(controller.receivedPosition or controller.getpos())
			end)

			function misc:AutoGrenadeFrozen()
				if not char.alive then return end
				if gamelogic.gammo < 1 then return end
				local autonade = config:GetValue("Main", "Misc", "Extra", "Auto Nade Spam")
				if not autonade and not config:GetValue("Main", "Misc", "Exploits", "Auto Nade Frozen") then return end
				local t = config:GetValue("Main", "Misc", "Exploits", "Auto Nade Wait")
				for player, v in pairs(replication.player_registry) do
					if player ~= localplayer and player.Team and localplayer.Team and player.Team.Name ~= localplayer.Team.Name then
						local priority = config:GetPriority(player)
						if priority and priority < 0 then continue end
						local controller = v.updater
						if controller.alive and (autonade or (controller.__t_received and controller.__t_received + t < tick())) then
							misc:GrenadeTP(controller.receivedPosition or controller.getpos())
						end
					end
				end
			end

			hook:Add("Postupdatespawn", "BBOT:Misc.AutoGrandeFrozen", function()
				misc:AutoGrenadeFrozen()
			end)

			hook:Add("OnAliveChanged", "BBOT:Misc.AutoGrandeFrozen", function()
				misc:AutoGrenadeFrozen()
			end)

			timer:Create("BBOT:Misc.AutoGrenadeFrozen", 1, 0, function()
				misc:AutoGrenadeFrozen()
			end)

			hook:Add("AutoDeath", "BBOT:Misc.AutoGrenadeFrozen", function()
				misc:AutoGrenadeFrozen()
			end)

			hook:Add("Spawn", "BBOT:Misc.AutoGrenadeFrozen", function()
				misc:AutoGrenadeFrozen()
			end)

			do -- note: move this to aux?
				local killed_netindex

				local receivers = network.receivers
				for netindex, callback in pairs(receivers) do
					local const = debug.getconstants(callback)
					if table.quicksearch(const, "setfixedcam") and table.quicksearch(const, "setspectate") and table.quicksearch(const, "isplayeralive") and table.quicksearch(const, "Killer") then
						killed_netindex = netindex
					end
				end

				hook:Add("PostNetworkReceive", "BBOT:LocalKilled.Network", function(netname, ...)
					if netname == killed_netindex then
						hook:Call("LocalKilled", ...)
					end
				end)
			end

			--Disable Collisions
			hook:Add("OnKeyBindChanged", "NoCollisionsChanged", function(steps, old, new)
				if not config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
				if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions") then return end
				if not char.alive then return end
				local v1057 = localplayer:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = (new == true and false or true)
					end
				end
				local v1057 = localplayer.Character:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = (new == true and false or true)
					end
				end
			end)
			hook:Add("OnConfigChanged", "NoCollisionsChanged", function(steps, old, new)
				if not config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Disable Collisions") then return end
				if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
				if not char.alive then return end
				local v1057 = localplayer:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = (new == true and false or true)
					end
				end
				local v1057 = localplayer.Character:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = (new == true and false or true)
					end
				end
			end)
		
			hook:Add("PostLoadCharacter", "NoCollisions", function(char, pos)
				if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions") or not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
				local v1057 = localplayer:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = false
					end
				end
				local v1057 = localplayer.Character:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = false
					end
				end
			end)
		
			hook:Add("Stepped", "CollisionOverride", function()
				if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions") or not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
				if not char.alive then return end
				local v1057 = localplayer:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = false
					end
				end
				local v1057 = localplayer.Character:GetDescendants()
				for v1058 = 1, #v1057 do
					local object = v1057[v1058]
					if object:IsA("BasePart") then
						object.CanCollide = false
					end
				end
			end)
		end

		-- L3P player
		do
			local hook = BBOT.hook
			local config = BBOT.config
			local timer = BBOT.timer
			local camera = BBOT.aux.camera
			local char = BBOT.aux.char
			local replication = BBOT.aux.replication
			local gamelogic = BBOT.aux.gamelogic
			local loop = BBOT.loop
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local l3p = {}
			BBOT.l3p_player = l3p

			function l3p:Init() -- Come on PF this is pathetic
				local localplayer_check = debug.getupvalue(replication._updater, 1)
				debug.setupvalue(replication._updater, 1, "_")
				self.controller = replication._updater(localplayer)
				self.player = localplayer
				debug.setupvalue(replication._updater, 1, localplayer_check)

				-- MAJOR NOTE: this is here because synapse 2.0 was being a dick with environments
				-- Synapse 3.0 has this fixed
				local lookangle_spring = debug.getupvalues(self.controller.getlookangles, 1)[1]
				local _update = lookangle_spring.update
				function lookangle_spring:update(...)
					_update(self, ...)
				end

				if config:GetValue("Main", "Visuals", "Local", "Enabled") then
					BBOT.esp:CreatePlayer(self.player, self.controller)
				end
			end

			hook:Add("PostInitialize", "BBOT:L3P.CreateUpdater", function()
				l3p:Init()
			end)

			function l3p:SetAlive(alive)
				if not self.controller then return end
				if not self.controller.alive and alive and self.enabled then
					if self.controller._weapon_slot then
						self.networking["equip"](l3p.controller, l3p.controller._weapon_slot)
					else
						self.networking["equip"](l3p.controller, -1)
					end
					local old_char
					if self.player == localplayer then
						old_char = self.player.Character
					end
					self.controller.spawn(char.rootpart.Position)
					self.controller.setsprint(char.sprinting())
					local mode = config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance")
					if mode ~= "Off" then
						self.controller.setstance(string.lower(mode))
					else
						self.controller.setstance(char.movementmode)
					end
					if old_char then
						self.player.Character = old_char
					end
				elseif self.controller.alive then
					local objects = self.controller.died()
					if objects then
						objects:Destroy()
					end
				end
			end

			function l3p:GetCharacter()
				if self.controller and self.controller.alive then
					return self.controller.gethead().Parent
				end
			end

			function l3p:Enabled(on)
				l3p.enabled = on
				if char.alive and on then
					self:SetAlive(true)
				else
					self:SetAlive(false)
				end
			end

			hook:Add("Unload", "BBOT:L3P.Remove", function()
				if l3p.controller then l3p.controller.died() end
				l3p.controller = nil
				l3p.player = nil
			end)

			local vec0 = Vector3.new()
			l3p.networking = {
				["newbullets"] = function(controller)
					if not char.alive or not controller.alive then return end
					local gun = gamelogic.currentgun
					if not gun or not gun.data then return end
					local gundata = gun.data
					-- gundata.firevolume
					controller.kickweapon(gundata.hideflash, gundata.firesoundid, (gundata.firepitch and gundata.firepitch * (1 + 0.05 * math.random()) or nil), 0)
				end,
				["stab"] = function(controller)
					if not char.alive or not controller.alive then return end
					controller.stab()
				end,
				["equip"] = function(controller, slot)
					if not char.alive then return end
					controller._weapon_slot = slot
					local gun = gamelogic.currentgun.name
					local data = game:service("ReplicatedStorage").GunModules:FindFirstChild(gun)
					if not data then
						gun = "AK12"
						data = game:service("ReplicatedStorage").GunModules:FindFirstChild(gun)
					end
					local external = game:service("ReplicatedStorage").ExternalModels:FindFirstChild(gun)
					if not data or not external then return end
					local gundata, gunmodel = require(data), external:Clone()
					if gundata.type ~= "KNIFE" then
						controller.equip(gundata, gunmodel)
					else
						controller.equipknife(gundata, gunmodel)
					end
					controller.setaim(false)
				end,
				["aim"] = function(controller, status)
					controller.setaim(status)
				end,
				["sprint"] = function(controller, status)
					controller.setsprint(status)
				end,
				["stance"] = function(controller, status)
					controller.setstance(status)
				end,
				["repupdate"] = function(controller, pos, ang, timestep)
					if not char.alive or not controller.alive then return end
					local blank_vector = Vector3.new()
					local delta_position = blank_vector
					if not pos then
						pos = controller.receivedPosition
						if not pos then return end
					end
					if not ang then
						ang = controller.receivedLookAngles
						if not ang then return end
					end
					if controller.receivedPosition and controller.receivedFrameTime then
						delta_position = (pos - controller.receivedPosition) / (timestep - controller.receivedFrameTime);
					end;

					controller.receivedFrameTime = timestep;
					controller.receivedPosition = pos;
					controller.receivedVelocity = delta_position;
					controller.receivedDataFlag = true;
					controller.receivedLookAngles = ang;

					if config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Absolute") then
						delta_position = vec0
						controller.receivedVelocity = delta_position
						local u315 = debug.getupvalue(controller.getpos, 2)
						u315.t = pos
						u315.p = pos
						u315.v = vec0
						local u319 = debug.getupvalue(controller.step, 5)
						u319.t = pos
						u319.p = pos
						u319.v = pos
						local u320 = debug.getupvalue(controller.step, 6)
						u320._p0 = vec0
						u320._p1 = vec0
						u320._a0 = vec0
						u320._j0 = vec0
						u320._v0 = vec0
						u320._t0 = tick()
						controller.step(3, true)
					end

					if config:GetValue("Main", "Visuals", "Camera Visuals", "First Person Third") then
						local tick = debug.getupvalue(BBOT.aux.camera.step, 1)
						BBOT.aux.camera.step(tick)
					end
				end
			}

			hook:Add("RenderStepped", "BBOT:L3P.Render", function(delta)
				if not l3p.controller or not l3p.controller.alive then return end
				if config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Absolute") then
					local l__angles__1304 = BBOT.aux.camera.angles;
					l3p.networking["repupdate"](l3p.controller, char.rootpart.CFrame.p, nil, tick())
				end
				l3p.controller.step(3, true)
			end)

			hook:Add("SuppressNetworkSend", "BBOT:L3P.StopReplication", function(netname, ...)
				local args = {...} -- I was going to use this for something else...
				if netname == "state" and (args[1] == localplayer or args[1] == l3p.player) then return true end
			end)

			hook:Add("OnAliveChanged", "BBOT:L3P.UpdateDeath", function(alive)
				if alive then l3p:SetAlive(alive) end
			end)

			local connection = char.ondied:connect(function()
				l3p:SetAlive(false)
			end);

			hook:Add("Unload", "BBOT:L3P.RemoveOnDied", function()
				connection:disconnect()
			end)

			hook:Add("PostNetworkSend", "BBOT:L3P.UpdateStates", function(netname, ...)
				if not l3p.controller or not l3p.enabled then return end
				if not l3p.networking[netname] then return end
				l3p.networking[netname](l3p.controller, ...)
			end)

			hook:Add("OnKeyBindChanged", "BBOT:L3P.Enable", function(steps, old, new)
				if not config:IsPathwayEqual(steps, "Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind") then return end
				if config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person") then l3p:Enabled(new) end
			end)

			hook:Add("OnConfigChanged", "BBOT:L3P.Enable", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Visuals", "Local", "Enabled") then
					if not l3p.controller then return end
					if new then
						BBOT.esp:CreatePlayer(l3p.player, l3p.controller)
					else
						BBOT.esp:Remove("PLAYER_"..l3p.player.UserId)
					end
				elseif config:IsPathwayEqual(steps, "Main", "Visuals", "Camera Visuals", "Third Person", true) then
					if new then
						timer:Async(function()
							l3p:Enabled(new and config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind"))
						end)
					else
						l3p:Enabled(false)
					end
				end
			end)

			do
				local camera = BBOT.service:GetService("CurrentCamera")
				-- P.S this is broken, find a replacement to hide weapons on thirdperson
				--[[local function hideweapon()
					if not char.alive then return end
					if not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person") or not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind") then
						if gamelogic.currentgun.___ta then
							gamelogic.currentgun.___ta = nil
							gamelogic.currentgun:show()
						end
						return
					end
					if gamelogic.currentgun and gamelogic.currentgun.hide then
						gamelogic.currentgun:show()
						gamelogic.currentgun:hide(true)
						gamelogic.currentgun.___ta = true
					end
				end

				hook:Add("PreWeaponStep", "BBOT:Misc.Thirdperson", hideweapon)
				hook:Add("PreKnifeStep", "BBOT:Misc.Thirdperson", hideweapon)]]
				hook:Add("PreScreenCullStep", "BBOT:Misc.Thirdperson", function()
					if not char.alive or not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person") or not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind") then return end
					if BBOT.spectator and BBOT.spectator:IsSpectating() then return end
					if config:GetValue("Main", "Visuals", "Camera Visuals", "First Person Third") and BBOT.l3p_player and BBOT.l3p_player.controller then
						local head = BBOT.l3p_player.controller.gethead()
						if not head then return end
						local p, y, rr = camera.CFrame:ToOrientation()
						camera.CFrame = CFrame.new(head.CFrame.Position)
						local _, __, r = head.CFrame:ToOrientation()
						camera.CFrame *= CFrame.fromOrientation(p,y,r)
					end
					local val = camera.CFrame
					local dist = Vector3.new(
						config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person X Offset"),
						config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Y Offset"),
						config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Distance")
					)/10
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Blacklist
					params.FilterDescendantsInstances = { camera, workspace.Ignore, localplayer.Character, workspace.Players }
					local hit = workspace:Raycast(val.p, (val * CFrame.new(dist)).p-val.p, params)
					val *= CFrame.new(hit and dist*((hit.Position - val.p).Magnitude/dist.Magnitude) or dist)
					camera.CFrame = val
				end)
			end
		end

		-- Spectator
		do
			local hook = BBOT.hook
			local config = BBOT.config
			local math = BBOT.math
			local replication = BBOT.aux.replication
			local menu = BBOT.menu
			local aux_camera = BBOT.aux.camera
			local vector = BBOT.aux.vector
			local particle = BBOT.aux.particle
			local runservice = BBOT.service:GetService("RunService")
			local players = BBOT.service:GetService("Players")
			local camera = BBOT.service:GetService("CurrentCamera")
			local drawpather = BBOT.drawpather
			local spectator = {}
			BBOT.spectator = spectator

			spectator.spectating = false
			
			function spectator:Spectate(player)
				self.spectating = player
				if player then
					menu:UpdateStatus("Spectator", player.Name, true)
					hook:Call("Spectator.Spectate", player)
					local updater = replication.getupdater(player)
					if not updater or not updater.alive then return end
					if updater.receivedPosition and updater.receivedLookAngles then
						self.repupdate_position = updater.receivedPosition
						self.repupdate_angles = updater.receivedLookAngles
						self.lookangle = updater.receivedLookAngles
						self.position = updater.receivedPosition
					end
				else
					menu:UpdateStatus("Spectator", nil, false)
					hook:Call("Spectator.Spectate", nil)
				end
			end

			function spectator:IsSpectating()
				return self.spectating
			end

			local offset_velocity = Vector3.new(0,-10000,0)
			hook:Add("PostupdateReplication", "BBOT:Spectator.Offset", function(player, controller)
				if player ~= spectator:IsSpectating() then return end
				spectator.repupdate_position = controller.receivedPosition
				spectator.repupdate_angles = controller.receivedLookAngles
				controller.receivedPosition = Vector3.new(0,-10000,0)
			end)

			hook:Add("PreupdateStep", "BBOT:Spectator.RenderAll", function(player, controller, renderscale, shouldrender)
				if spectator:IsSpectating() or spectator.freecam_enabled then
					return 3, true
				end
			end)

			hook:Add("Postupdatespawn", "BBOT:Spectator.Reset", function(player, controller)
				if spectator:IsSpectating() ~= player then return end
				if controller.receivedPosition and controller.receivedLookAngles then
					spectator.lookangle = controller.receivedLookAngles
					spectator.position = controller.receivedPosition
				end
			end)

			do
				local getweaponpos_detour, particle_detour, particle_readonly
				hook:Add("PreNewBullets", "BBOT:Spectator.BulletOverride", function(data)
					if not data.player or spectator:IsSpectating() ~= data.player then return end
					local updater = replication.getupdater(data.player)
					if not updater or not updater.alive then return end
					getweaponpos_detour = updater.getweaponpos
					function updater.getweaponpos()
						return data.firepos
					end
					local duration = config:GetValue("Main", "Visuals", "Extra", "Spectator Bullet Duration")
					local hit_color, hit_opacity = config:GetValue("Main", "Visuals", "Extra", "Spectator Bullets", "Hit Color")
					local bullet_color, bullet_opacity = config:GetValue("Main", "Visuals", "Extra", "Spectator Bullets", "Trace Color")
					local player = data.player
					local team = (player.Team and player.Team.Name or "NA")
					local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]

					particle_readonly = isreadonly(particle)
					if particle_readonly then
						setreadonly(particle, false)
					end
					particle_detour = rawget(particle, "new")
					local function particle_new(bullet, ...)
						if config:GetValue("Main", "Visuals", "Extra", "Spectator Bullets") then
							local pather = drawpather:Create()
							pather:SetColor(bullet_color, bullet_opacity)
							pather:SetSize(1)
							pather:SetEndSize(3)
							pather:ShowEnd(true)
							pather:SetDuration(duration)
							local dir = bullet.velocity.Unit * 50000
							local firepos = bullet.position
							local raydata = BBOT.aimbot:raycastbullet(firepos, dir, playerteamdata)
							local final = raydata and raydata.Position or dir
							pather:Update({firepos, final})

							bullet.physicsignore = {workspace.Terrain, workspace.Ignore, camera}
							bullet.onplayerhit = function(self, pl, part, hitpos)
								pather:SetColor(hit_color, hit_opacity)
								pather:Update({firepos, hitpos})
							end
						end
						particle_detour(bullet, ...)
					end
					rawset(particle, "new", particle_new)
					if particle_readonly then
						setreadonly(particle, true)
					end
				end)

				hook:Add("PostNewBullets", "BBOT:Spectator.BulletOverride", function(data)
					if particle_detour then
						if particle_readonly then
							setreadonly(particle, false)
						end
						rawset(particle, "new", particle_detour)
						particle_detour = nil
						if particle_readonly then
							setreadonly(particle, true)
						end
					end
					local updater = replication.getupdater(data.player)
					if getweaponpos_detour and updater then
						updater.getweaponpos = getweaponpos_detour
						getweaponpos_detour = nil
					end
				end)
			end

			hook:Add("PlayerRemoving", "BBOT:Spectator.Remove", function(player)
				if spectator.spectating == player then
					spectator.spectating = nil
					menu:UpdateStatus("Spectator", nil, false)
					hook:Call("Spectator.Spectate", nil)
				end
			end)

			local vector_blank = Vector3.new()
			local stand, crouch, prone = Vector3.new(0,1.5,0), Vector3.new(0,0,0), Vector3.new(0,-1,0)

			spectator.lookangle = Vector2.new()
			spectator.position = Vector3.new()
			spectator.freecam_angles = Vector3.new()
			spectator.freecam_position = Vector3.new()
			spectator.freecam_cframe = CFrame.new()
			spectator.freecam_enabled = false
			spectator.camera_final = CFrame.new()

			local l__CFrame_Angles__14 = CFrame.Angles;
			hook:Add("Mouse.OnMove", "BBOT:Spectator.FreeCam", function(mouse_delta)
				if config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam") and config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam", "KeyBind") then
					local sensitivity = aux_camera.sensitivity * aux_camera.sensitivitymult * math.atan(math.tan(aux_camera.basefov * (math.pi / 180) / 2) / 2.718281828459045 ^ aux_camera.magspring.p) / (32 * math.pi);
					local pitch_cos = math.cos(spectator.freecam_angles.x);
					local delta = Vector3.new(-sensitivity * mouse_delta.y * aux_camera.xinvert, -(sensitivity * (1 - (1 - pitch_cos) ^ (aux_camera.sensitivity * aux_camera.sensitivitymult * math.atan(math.tan(aux_camera.basefov * (math.pi / 180) / 2)) / (32 * math.pi) / sensitivity)) / pitch_cos) * mouse_delta.x, 0);
					
					local pitch = math.clamp(spectator.freecam_angles.x + delta.x, aux_camera.minangle, aux_camera.maxangle);
					local yaw = spectator.freecam_angles.y + delta.y
					spectator.freecam_angles = Vector3.new(pitch, yaw)
				end
			end)

			local userinputservice = BBOT.service:GetService("UserInputService")
			local localplayer = BBOT.service:GetService("LocalPlayer")
			function spectator.step()
				local self = spectator
				if config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam") and config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam", "KeyBind") then
					if not self.freecam_enabled then
						self.freecam_angles = Vector3.new(self.camera_final:ToEulerAnglesXYZ())
						self.freecam_position = self.camera_final.p
					end
					self.freecam_enabled = true
					userinputservice.MouseBehavior = Enum.MouseBehavior.LockCenter
					local look_cframe = CFrame.Angles(0, self.freecam_angles.Y, 0) * CFrame.Angles(self.freecam_angles.X, 0, 0)

					local LookVector = look_cframe.LookVector
					local RightVector = look_cframe.RightVector
					if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
						LookVector = LookVector * 2
						RightVector = RightVector * 2
					end
					if userinputservice:IsKeyDown(Enum.KeyCode.W) then
						self.freecam_position += LookVector
					end
					if userinputservice:IsKeyDown(Enum.KeyCode.S) then
						self.freecam_position -= LookVector
					end
					if userinputservice:IsKeyDown(Enum.KeyCode.D) then
						self.freecam_position += RightVector
					end
					if userinputservice:IsKeyDown(Enum.KeyCode.A) then
						self.freecam_position -= RightVector
					end

					local new_cframe = look_cframe + self.freecam_position
					spectator.freecam_cframe = new_cframe
					aux_camera.basecframe = new_cframe
					aux_camera.cframe = new_cframe
					camera.CFrame = new_cframe
				else
					self.freecam_enabled = false
					if not self.spectating then return end
					local target = self.spectating
					local updater = replication.getupdater(target)
					if not updater or not updater.alive then return end

					local stance = updater.__stance or "stand"
					local offset = vector_blank
					if stance == "stand" then
						offset = stand
					elseif stance == "crouch" then
						offset = crouch
					else
						offset = prone
					end
					if self.repupdate_position and self.repupdate_angles then
						local renderstep_tick = BBOT.renderstepped_rate
						self.position = math.lerp(renderstep_tick*25, self.position, self.repupdate_position+offset)
						camera.CFrame = CFrame.new(self.position)
						self.lookangle = math.lerp(renderstep_tick*25, self.lookangle, self.repupdate_angles)
						camera.CFrame *= CFrame.fromOrientation(self.lookangle.X,self.lookangle.Y,0)
					end
					aux_camera.basecframe = camera.CFrame
					aux_camera.cframe = camera.CFrame
				end
			end

			hook:Add("PreScreenCullStep", "BBOT:Spectator.Spectate", spectator.step)

			hook:Add("PostScreenCullStep", "BBOT:Spectator.Spectate", function()
				spectator.camera_final = aux_camera.cframe
			end)
		end

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
			local log = BBOT.log
			local draw = BBOT.draw
			local replication = BBOT.aux.replication
			local extras = BBOT.extras
			local physics = BBOT.physics
			local raycast = BBOT.aux.raycast
			local roundsystem = BBOT.aux.roundsystem
			local repupdate = BBOT.repupdate
			local cam = BBOT.aux.camera
			local localplayer = BBOT.service:GetService("LocalPlayer")
			local userinputservice = BBOT.service:GetService("UserInputService")
			local players = BBOT.service:GetService("Players")
			local camera = BBOT.service:GetService("CurrentCamera")
			local mouse = BBOT.service:GetService("Mouse")
			local aux_camera = BBOT.aux.camera
			local aimbot = {}
			BBOT.aimbot = aimbot
			
			do
				local table = BBOT.table
				local receivers = network.receivers
				for netindex, callback in next, receivers do
					local const = debug.getconstants(callback)
					if table.quicksearch(const, "firepos") and table.quicksearch(const, "bullets") and table.quicksearch(const, "bulletcolor") and table.quicksearch(const, "penetrationdepth") then
						hook:Add("PreNetworkReceive", "BBOT:NewBullets.Network", function(netname, ...)
							if netname == netindex then
								hook:Call("PreNewBullets", ...)
							end
						end)
						hook:Add("PostNetworkReceive", "BBOT:NewBullets.Network", function(netname, ...)
							if netname == netindex then
								hook:Call("PostNewBullets", ...)
							end
						end)
					end
				end
			end

			do
				local function raycastbullet(p1)
					local instance = p1.Instance
					if instance.Name == "Window" then return true end
					return not instance.CanCollide or instance.Transparency == 1
				end

				local workspace = BBOT.service:GetService("Workspace")
				local v4 = RaycastParams.new();
				v4.IgnoreWater = true;
				function aimbot:fullcast(p7, p8, p9, p10, p11)
					local v3=nil;
					local calls = 0;
					v4.FilterDescendantsInstances = p9;
					while calls < 2000 do
						v3 = workspace:Raycast(p7, p8, v4);
						if not v3 or not p10(v3) then
							break;
						end;
						table.insert(p9, v3.Instance);
						v4.FilterDescendantsInstances = p9;
						calls = calls + 1
					end;
					return v3;
				end;

				local camera = BBOT.service:GetService("CurrentCamera")
				function aimbot:raycastbullet(vec, dir, extra, cb)
					return aimbot:fullcast(vec, dir, {camera, workspace.Terrain, localplayer.Character, workspace.Ignore, workspace.Players, extra}, cb or raycastbullet)
				end
			end

			-- This is for predicting the rocket travel
			function aimbot:VelocityPrediction(startpos, endpos, vel, speed) -- Kinematics is fun
				if not vel then
					vel = Vector3.new()
				end
				local t = (endpos-startpos).Magnitude/speed
				return endpos + (vel * t)
			end

			do
				local rcast_params = RaycastParams.new()
				rcast_params.FilterType = Enum.RaycastFilterType.Whitelist
				rcast_params.IgnoreWater = true
				rcast_params.FilterDescendantsInstances = roundsystem.raycastwhitelist
				local player_ground = Vector3.new(0,3,0)
				function aimbot:ProjectileRaycasting(startpos, pred_results)
					startpos = Vector3.new(pred_results.X, startpos.Y, pred_results.Z)
					local results = workspace:Raycast(startpos, (pred_results-startpos)+player_ground, rcast_params)
					if results then
						return results.Position+player_ground
					end
					return pred_results
				end

				-- note: switch gravity to parabolic
				-- note: roblox gravity workspace seem incorrect, value aren't justified to their physics engine, maybe it's multiplied by mass?
				function aimbot:ProjectilePrediction(startpos, endpos, player_velocity, player_gravity, projectile_speed)
					player_velocity = player_velocity or Vector3.new()
					local t = (endpos-startpos).Magnitude/projectile_speed
					if player_gravity then
						--return self:ProjectileRaycasting(startpos, endpos + (player_velocity * t) + (.5*player_gravity*(t*t)))
						return endpos + (player_velocity * t)
					else
						return endpos + (player_velocity * t)
					end
				end
			end

			aimbot.bullet_gravity = Vector3.new(0, -196.2, 0) -- Todo: get the velocity from the game public settings

			function aimbot:DropPrediction(startpos, finalpos, speed)
				local a, b = physics.trajectory(startpos, self.bullet_gravity, finalpos, speed)
				if a then
					return a
				else
					return (finalpos-startpos)
				end
			end

			function aimbot:CanBarrelPredict(gun)
				local stopon = self:GetLegitConfig("Ballistics", "Disable Barrel Comp While")
				if stopon["Scoping In"] then
					local sight = BBOT.weapons.GetToggledSight(gun)
					if sight and sight.sightspring and (sight.sightspring.p > 0.1 and sight.sightspring.p < 0.9) then
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
					return (((dir - part.CFrame.LookVector) * math.pi) - (dir - (target - part.CFrame.Position).Unit))
				end
			end

			function aimbot:GetParts(player)
				if not hud:isplayeralive(player) then return end
				return replication.getbodyparts(player)
			end

			local types = {
				-- Weapon Based
				["E SHOTGUN"] = "Smg",

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
				if gun.name and types[gun.name] then
					self.gun_type = gun.name
					return
				end

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
				["torso"] = "Body",
				["larm"] = "Arms",
				["rarm"] = "Arms",
				["lleg"] = "Legs",
				["rleg"] = "Legs",
			}

			local function Move_Mouse(delta)
				local coef = cam.sensitivitymult * math.atan(
					math.tan(cam.basefov * (math.pi / 180) / 2) / 2.718281828459045 ^ cam.magspring.p
				) / (32 * math.pi)
				local x = cam.angles.x - coef * delta.y
				x = x > cam.maxangle and cam.maxangle or x < cam.minangle and cam.minangle or x
				local y = cam.angles.y - coef * delta.x
				local newangles = Vector3.new(x, y, 0)
				cam.delta = (newangles - cam.angles) / 0.016666666666666666
				cam.angles = newangles
			end

			function aimbot:GetLegitTarget(fov, dzFov, hitscan_points, hitscan_priority, scan_part, multi, sticky)
				local mousePos = Vector3.new(mouse.x, mouse.y, 0)
				local cam_position = camera.CFrame.p
				local team = (localplayer.Team and localplayer.Team.Name or "NA")
				local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]
				local organizedPlayers = {}
				local plys = players:GetPlayers()
				for i=1, #plys do
					local v = plys[i]
					if v == localplayer then
						continue
					end

					local parts = self:GetParts(v)
					if not parts then continue end
				
					if v.Team and v.Team == localplayer.Team or config:GetPriority(v) < 0 then
						continue
					end

					local updater = replication.getupdater(v)
					local prioritize
					if hitscan_priority == "Head" then
						prioritize = replication.getbodyparts(v).head
					elseif hitscan_priority == "Body" then
						prioritize = replication.getbodyparts(v).torso
					end

					local inserted_priority
					if prioritize then
						local part = prioritize
						local pos = prioritize.Position
						local point, onscreen = camera:WorldToViewportPoint(pos)
						if onscreen then
							if (not fov or vector.dist2d(fov.Position, point) <= fov.Radius) then
								local raydata = self:raycastbullet(cam_position,pos-cam_position,playerteamdata)
								if not ((not raydata or not raydata.Instance:IsDescendantOf(updater.gethead().Parent)) and (raydata and raydata.Position ~= pos)) then
									table.insert(organizedPlayers, {v, part, point, prioritize, (dzFov and vector.dist2d(dzFov.Position, point) < dzFov.Radius)})
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
							if (fov and vector.dist2d(fov.Position, point) > fov.Radius) then continue end
							local raydata = self:raycastbullet(cam_position,pos-cam_position,playerteamdata)
							if (not raydata or not raydata.Instance:IsDescendantOf(updater.gethead().Parent)) and (raydata and raydata.Position ~= pos) then continue end
							table.insert(organizedPlayers, {v, part, point, name, (dzFov and vector.dist2d(dzFov.Position, point) < dzFov.Radius)})
						end
					end
				end

				if sticky then
					local founds = {}
					for i=1, #organizedPlayers do
						local v = organizedPlayers[i]
						if sticky[1] == v[1] then
							founds[#founds+1] = v
						end
					end
					if #founds > 0 then
						table.sort(founds, function(a, b)
							return (a[3] - mousePos).Magnitude < (b[3] - mousePos).Magnitude
						end)
						return (multi and founds or founds[1])
					end
				end
				
				table.sort(organizedPlayers, function(a, b)
					return (a[3] - mousePos).Magnitude < (b[3] - mousePos).Magnitude
				end)
				
				return (multi and organizedPlayers or organizedPlayers[1])
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
						smoothing_incrimental = math.approach( smoothing_incrimental, aimbot:GetLegitConfig("Aim Assist", "End Smoothing"), aimbot:GetLegitConfig("Aim Assist", "Smoothing Increment") * delta )
					end)

					hook:Add("MouseBot.Changed", "BBOT:Aimbot.Assist.CalcSmoothing", function()
						smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
					end)

					function aimbot:MouseResetSmoothing()
						smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
					end
				end

				do
					local target_line = draw:Create("Line", "2V", "3D")
					target_line.Color = Color3.fromRGB(127, 72, 163)
					target_line.Thickness = 2
					target_line.ZIndex = 3
					target_line.Offset1 = Vector2.new()
					target_line.Point2 = Vector3.new()
					target_line.Visible = false
					target_line.Outlined = true
					target_line.OutlineColor = Color3.new(0,0,0)
					target_line.OutlineThickness = 1

					hook:Add("OnConfigChanged", "BBOT:Aimbot.MouseStep.Line", function(steps, old, new)
						if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Aim Assist Line", true) and not new then
							target_line.Visible = false
						elseif config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Aim Assist Line", "Color") then
							local color, opacity = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Line", "Color")
							target_line.Color = color
							target_line.Opacity = opacity
							target_line.OutlineOpacity = opacity
						end
					end)

					hook:Add("PreCalculateCrosshair", "BBOT:Aimbot.MouseStep.Line", function(screenpos, onscreen)
						if not config:GetValue("Main", "Visuals", "FOV", "Aim Assist Line") then return end
						local pos = Vector2.new(screenpos.X, screenpos.Y)
						local barrel_calc = aimbot:GetLegitConfig("Aim Assist", "Use Barrel")
						if not barrel_calc then
							pos = camera.ViewportSize/2
						end
						if char.alive and aimbot.mouse_target and aimbot.mouse_target[2] then
							target_line.Offset1 = pos
							target_line.Point2 = aimbot.mouse_target[2].Position
							target_line.Visible = true
						else
							target_line.Visible = false
						end
					end)
				end

				function aimbot:MouseChanged(target)
					if (target == nil and self.mouse_target) or (self.mouse_target == nil and target) or (target and self.mouse_target and target[1] ~= self.mouse_target[1]) then
						hook:Call("MouseBot.Changed", (target and unpack(target) or nil))
					end
				end

				function aimbot:MouseStep(gun)
					if not self:GetLegitConfig("Aim Assist", "Enabled") then
						self:MouseChanged()
						self.mouse_target = nil
						return
					end
					local aimkey = self:GetLegitConfig("Aim Assist", "Aimbot Key")
					if aimkey == "Mouse 1" or aimkey == "Mouse 2" then
						if not userinputservice:IsMouseButtonPressed((aimkey == "Mouse 1" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)) then
							self:MouseChanged()
							self.mouse_target = nil
							return
						end
					elseif aimkey == "Dynamic Always" then
						if not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
							self:MouseChanged()
							self.mouse_target = nil
							return
						end
					end

					local hitscan_priority = self:GetLegitConfig("Aim Assist", "Hitscan Priority")
					local hitscan_points = self:GetLegitConfig("Aim Assist", "Hitscan Points")
					local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
					local barrel_calc = self:GetLegitConfig("Aim Assist", "Use Barrel")

					local previous_target = (self:GetLegitConfig("Aim Assist", "Lock Target") and self.mouse_target or nil)
					local target = self:GetLegitTarget(aimbot.fov_circle_last, aimbot.dzfov_circle_last, hitscan_points, hitscan_priority, (barrel_calc and part or nil), nil, previous_target)
					self:MouseChanged(target)
					self.mouse_target = target
					if not target or target[5] then return end

					if self:GetLegitConfig("Aim Assist", "Enable On Move") then
						local mouse_delta = userinputservice:GetMouseDelta()
						if mouse_delta.Magnitude == 0 then
							self:MouseResetSmoothing()
							return
						end
					end

					local position = target[2].Position
					local cam_position = camera.CFrame.p

					if self:GetLegitConfig("Ballistics", "Movement Prediction") then
						position = self:ProjectilePrediction(cam_position, position, replication.getupdater(target[1]).receivedVelocity, Vector3.new(0,-workspace.Gravity,0) * char.rootpart:GetMass(), gun.data.bulletspeed)
					end

					local dir = (position-cam_position).Unit
					local magnitude = (position-cam_position).Magnitude
					if self:GetLegitConfig("Ballistics", "Drop Prediction") then
						dir = self:DropPrediction(cam_position, position, gun.data.bulletspeed).Unit
					end

					if self:GetLegitConfig("Ballistics", "Barrel Compensation") and self:CanBarrelPredict(gun) then
						local X, Y = self:GetLegitConfig("Ballistics", "Barrel Comp X")/100, self:GetLegitConfig("Ballistics", "Barrel Comp Y")/100
						local correction_dir = self:BarrelPrediction(position, dir, gun)
						dir = dir + Vector3.new(correction_dir.X * X, correction_dir.Y * Y, 0)
						dir = dir.Unit
					end

					local pos, onscreen = camera:WorldToViewportPoint(cam_position + (dir*magnitude))
					if onscreen then
						local randMag = self:GetLegitConfig("Aim Assist", "Randomization")
						local smoothing = smoothing_incrimental * 5 + 5
						local inc = Vector2.new((pos.X - mouse.X + (math.noise(time() * 0.1, 0.1) * randMag)) / smoothing, (pos.Y - 36 - mouse.Y + (math.noise(time() * 0.1, 0.1) * randMag)) / smoothing)
						Move_Mouse(inc)
					end
				end
			end

			do
				do
					local target_line = draw:Create("Line", "2V", "3D")
					target_line.Color = Color3.fromRGB(163, 72, 127)
					target_line.Thickness = 2
					target_line.ZIndex = 3
					target_line.Offset1 = Vector2.new()
					target_line.Point2 = Vector3.new()
					target_line.Visible = false
					target_line.Outlined = true
					target_line.OutlineColor = Color3.new(0,0,0)
					target_line.OutlineThickness = 1

					hook:Add("OnConfigChanged", "BBOT:Aimbot.RedirectionStep.Line", function(steps, old, new)
						if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Bullet Redirect Line", true) and not new then
							target_line.Visible = false
						elseif config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Bullet Redirect Line", "Color") then
							local color, opacity = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect Line", "Color")
							target_line.Color = color
							target_line.Opacity = opacity
							target_line.OutlineOpacity = opacity
						end
					end)

					hook:Add("PreCalculateCrosshair", "BBOT:Aimbot.RedirectionStep.Line", function(screenpos, onscreen)
						if not config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect Line") then return end
						local pos = Vector2.new(screenpos.X, screenpos.Y)
						local barrel_calc = aimbot:GetLegitConfig("Bullet Redirect", "Use Barrel")
						if not barrel_calc then
							pos = camera.ViewportSize/2
						end
						if char.alive and aimbot.redirection_target and aimbot.redirection_target[2] then
							target_line.Offset1 = pos
							target_line.Point2 = aimbot.redirection_target[2].Position
							target_line.Visible = true
						else
							target_line.Visible = false
						end
					end)
				end

				function aimbot:RedirectionChanged(target)
					if (target == nil and self.redirection_target) or (self.redirection_target == nil and target) or (target and self.redirection_target and target[1] ~= self.redirection_target[1]) then
						hook:Call("RedirectionBot.Changed", (target and unpack(target) or nil))
					end
				end

				function aimbot:RedirectionStep(gun)
					self.redirection_target = nil
					if not self:GetLegitConfig("Bullet Redirect", "Enabled") then
						self:RedirectionChanged()
						return
					end
					local aimkey = self:GetLegitConfig("Aim Assist", "Aimbot Key")
					if aimkey == "Mouse 1" or aimkey == "Mouse 2" then
						if not userinputservice:IsMouseButtonPressed((aimkey == "Mouse 1" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)) then
							self:RedirectionChanged()
							return
						end
					elseif aimkey == "Dynamic Always" then
						if not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
							self:RedirectionChanged()
							return
						end
					end
					if math.random(0, 100) > self:GetLegitConfig("Bullet Redirect", "Hit Chance") then
						return
					end

					local hitscan_priority = self:GetLegitConfig("Bullet Redirect", "Hitscan Priority")
					local hitscan_points = self:GetLegitConfig("Bullet Redirect", "Hitscan Points")
					local barrel_calc = self:GetLegitConfig("Bullet Redirect", "Use Barrel")
					local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)

					local target = self:GetLegitTarget(aimbot.sfov_circle_last, nil, hitscan_points, hitscan_priority, (barrel_calc and part or nil))
					self:RedirectionChanged(target)
					if not target then return end
					self.redirection_target = target
					local position = target[2].Position
					local part_pos = part.Position

					if self:GetLegitConfig("Ballistics", "Movement Prediction") then
						position = self:ProjectilePrediction(part_pos, position, replication.getupdater(target[1]).receivedVelocity, Vector3.new(0,-workspace.Gravity,0) * char.rootpart:GetMass(), gun.data.bulletspeed)
					end

					local dir = (position-part_pos).Unit
					local magnitude = (position-part_pos).Magnitude
					if self:GetLegitConfig("Ballistics", "Drop Prediction") then
						dir = self:DropPrediction(part_pos, position, gun.data.bulletspeed).Unit
					end

					local X, Y = CFrame.new(part_pos, part_pos+dir):ToOrientation()
					
					local accuracy = math.remap(self:GetLegitConfig("Bullet Redirect", "Accuracy")/100, 0, 1, .3, 0)
					X += ((math.pi/2) * (math.random(-accuracy*1000, accuracy*1000)/1000))/100
					Y += ((math.pi/2) * (math.random(-accuracy*1000, accuracy*1000)/1000))/100

					self.silent_data = {part.Position, part.Orientation}
					part.Orientation = Vector3.new(math.deg(X), math.deg(Y), 0)
					self.silent = part
				end
			end

			do
				local assist_prediction_outline = draw:Create("Circle", "2V")
				assist_prediction_outline.Thickness = 6
				assist_prediction_outline.NumSides = 25
				assist_prediction_outline.Size = 4
				assist_prediction_outline.Filled = true
				local assist_prediction = draw:Create("Circle", "2V")
				assist_prediction.Thickness = 1
				assist_prediction.NumSides = 25
				assist_prediction.Size = 3
				assist_prediction.Filled = true

				hook:Add("RenderStepped", "BBOT:Aimbot.TriggerBot", function()
					local mycurgun = gamelogic.currentgun
					if mycurgun and mycurgun.data and mycurgun.data.bulletspeed then
						aimbot:SetCurrentType(mycurgun)
						if not aimbot:GetLegitConfig("Trigger Bot", "Enabled") then return end
						local col, transparency = aimbot:GetLegitConfig("Trigger Bot", "Enabled", "Dot Color")
						assist_prediction.Color = col
						assist_prediction.Opacity = transparency
						assist_prediction_outline.Opacity = transparency
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

				local isaiming, aimtime = nil, 0
				local firetime = 0
				local sprinttofiretime = 0
				function aimbot:TriggerBotStep(gun)
					self.trigger_target = nil
					if assist_prediction.Visible then
						assist_prediction.Visible = false
						assist_prediction_outline.Visible = assist_prediction.Visible
					end
					if not self:GetLegitConfig("Trigger Bot", "Enabled") then return end
					local aim_percentage = self:GetLegitConfig("Trigger Bot", "Aim In Time")
					if isaiming ~= gun.isaiming() then
						isaiming = gun.isaiming()
						aimtime = tick()
					end
					if self:GetLegitConfig("Trigger Bot", "Trigger When Aiming") and (not isaiming or (tick() - aimtime < aim_percentage)) then return end
					if char.sprinting() then
						sprinttofiretime = tick() + self:GetLegitConfig("Trigger Bot", "Sprint to Fire Time")
						return
					elseif sprinttofiretime > tick() then return end
					local hitscan_points = self:GetLegitConfig("Trigger Bot", "Trigger Bot Hitboxes")
					local multitarget = self:GetLegitTarget(aimbot.tfov_circle_last, nil, hitscan_points, nil, nil, true)
					local target_main = multitarget[1]

					if not target_main then return end
					self.trigger_target = target_main

					local cam_position = camera.CFrame.p
					local movement_prediction = self:GetLegitConfig("Ballistics", "Movement Prediction")
					local drop_prediction = self:GetLegitConfig("Ballistics", "Drop Prediction")
					local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
					local part_pos = part.Position
					local team = (localplayer.Team and localplayer.Team.Name or "NA")
					local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]
					local t = tick()
					local hit = false

					local velocity = replication.getupdater(target_main[1]).receivedVelocity
					local bulletspeed = gun.data.bulletspeed
					for i=1, #multitarget do
						local target = multitarget[i]
						if target[1] ~= target_main[1] then continue end
						local position = target[2].Position
						if movement_prediction then
							position = self:ProjectilePrediction(cam_position, position, velocity, Vector3.new(0,-workspace.Gravity,0) * char.rootpart:GetMass(), bulletspeed)
						end

						local dir = (position-cam_position).Unit
						local magnitude = (position-cam_position).Magnitude
						if drop_prediction then
							dir = self:DropPrediction(cam_position, position, bulletspeed).Unit
						end

						local trigger_position, onscreen = camera:WorldToViewportPoint(cam_position + (dir*magnitude))
						if onscreen then
							trigger_position = Vector2.new(trigger_position.X, trigger_position.Y)

							if i == 1 then
								assist_prediction.Visible = true
								assist_prediction_outline.Visible = assist_prediction.Visible
								assist_prediction.Offset = trigger_position
								assist_prediction_outline.Offset = assist_prediction.Offset
							end

							local radi = (target[4] == "Body" and 700 or 450)*(char.unaimedfov/camera.FieldOfView)/magnitude
							if gun.data.hipchoke and gun.data.hipchoke > 0 then
								local o = radi
								local mul = gun.data.crosssize * gun.data.hipchoke --(gun.data.aimchoke * p367 + gun.data.hipchoke * (1 - p367))
								radi = (2.25 * (math.pi^2) * mul)
								radi = radi * (char.unaimedfov/camera.FieldOfView)/magnitude
								if magnitude < gun.data.range0 then
									radi = radi * math.clamp(magnitude/gun.data.range0, .5, 1)
								end
								if radi < o then
									radi = o
								end
							end

							if i == 1 then
								assist_prediction.Radius = radi
								assist_prediction_outline.Radius = radi
							end

							local endpositon = part.CFrame.LookVector*70000
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
								hit = true
								break
							end
						end
					end

					if hit then
						local rpm = self:GetLegitConfig("Trigger Bot", "RPM Limiter")
						if gamelogic.currentgun ~= self.trigger_lastgun then
							self.trigger_lastgun = gamelogic.currentgun
							self.trigger_nextfire = nil
						end
						if firetime < t and (rpm == 0 or not self.trigger_nextfire or self.trigger_nextfire < tick()) then
							aimbot.fire = true
							gun:shoot(true)
							self.trigger_nextfire = tick() + (60 / rpm)
						end
					else
						firetime = t + self:GetLegitConfig("Trigger Bot", "Fire Time")
					end
				end
			end

			local Resolver_NewBullet = {}
			hook:Add("PreNewBullets", "BBOT:Aimbot.Resolver", function(data)
				local firepos, player = data.firepos, data.player
				local isalive = hud:isplayeralive(player)
				if isalive then
					local headpart = aimbot:GetParts(player).torso
					local mag = (firepos-headpart.Position).Magnitude
					if mag > 12 then
						Resolver_NewBullet[player.UserId] = (firepos-headpart.Position)
					else
						Resolver_NewBullet[player.UserId] = nil
					end
				end
			end)

			local vector_cache = Vector3.new()
			local height_offset = Vector3.new(0,1.25,0)
			function aimbot:GetResolvedPosition(player)
				if not self:GetRageConfig("Settings", "Resolver") then
					--[[local updater = replication.getupdater(player)
					if updater and updater.tickVelocity then
						local vel_resolver = aimbot:GetRageConfig("Settings", "Velocity Resolver")
						if vel_resolver == "Tick" and updater.tickVelocity then
							return height_offset+updater.tickVelocity
						elseif vel_resolver == "Ping" and updater.pingVelocity then
							return height_offset+updater.pingVelocity
						end
					end]]
					return height_offset
				end
				--[[local bodyparts, rootpart = aimbot:GetParts(player)
				local resolvedoffset = vector_cache
				-- method 1
				local root_cframe, torso_cframe = rootpart.CFrame, bodyparts.torso.CFrame
				if (root_cframe.Position - torso_cframe.Position).Magnitude > 18 then
					resolvedoffset = root_cframe.Position - torso_cframe.Position
				end
				return resolvedoffset]]
				local updater = replication.getupdater(player)
				local velocity_addition = vector_cache
				--[[if updater and updater.tickVelocity then
					local vel_resolver = aimbot:GetRageConfig("Settings", "Velocity Resolver")
					if vel_resolver == "Tick" and updater.tickVelocity then
						velocity_addition = updater.tickVelocity
					elseif vel_resolver == "Ping" and updater.pingVelocity then
						velocity_addition = updater.pingVelocity
					end
				end]]

				local parts = aimbot:GetParts(player)
				if updater and updater.receivedPosition and parts then
					--[[local offset = (updater.receivedPosition-updater.getpos())
					if offset.Magnitude >= 10000 or offset.Magnitude > math.huge or offset.Magnitude < -math.huge then
						return updater.receivedPosition + velocity_addition, true
					else
						return offset + velocity_addition
					end]]
					return updater.receivedPosition + velocity_addition, true
				end

				if Resolver_NewBullet[player.UserId] then
					return Resolver_NewBullet[player.UserId] + velocity_addition
				end

				return vector_cache + velocity_addition
			end

			function aimbot:GetDamage(data, distance, headshot)
				local r0, r1, d0, d1 = data.range0, data.range1, data.damage0, data.damage1
				return (distance < r0 and d0 or distance < r1 and (d1 - d0) / (r1 - r0) * (distance - r0) + d0 or d1)  * (headshot and data.multhead or 1)
			end

			-- This is broken because of the new ragebot... cba to fix this rn

			--aimbot.predictedDamageDealt = {}
			--aimbot.predictedLastHealth = {}
			--aimbot.predictedDamageUpdate = {}
			--aimbot.BulletQuery = {}
			--hook:Add("PostNetworkSend", "BBOT:RageBot.DamagePrediction", function(netname, ...)
			--	if netname == "bullethit" then
			--		local curthread = syn.get_thread_identity()
			--		syn.set_thread_identity(1)
			--		local a = {...}
			--		local Entity, HitPos, Part, bulletID = a[1], a[2], a[3], a[4]
			--		if Entity and Entity:IsA("Player") and aimbot:GetRageConfig("Settings", "Damage Prediction") and aimbot.BulletQuery[bulletID] then
			--			local bullet_data = aimbot.BulletQuery[bulletID]
			--			local damageDealt = aimbot:GetDamage(bullet_data[1], (HitPos-bullet_data[2]).Magnitude, Part == "Head")
			--			if not aimbot.predictedDamageDealt[Entity] then
			--				aimbot.predictedDamageDealt[Entity] = (100-hud:getplayerhealth(Entity))
			--			end
			--			local limit = aimbot:GetRageConfig("Settings", "Damage Prediction Limit")
			--			aimbot.predictedDamageDealt[Entity] += damageDealt
			--			aimbot.predictedDamageUpdate[Entity] = tick() + (extras:getLatency() * 5)
			--			if aimbot.predictedDamageDealt[Entity] >= limit then
			--				hook:Call("RageBot.DamagePredictionKilled", Entity)
			--			end
			--		end
			--		syn.set_thread_identity(curthread)
			--	elseif netname == "newbullets" and gamelogic.currentgun and gamelogic.currentgun.data then
			--		local args = {...}
			--		local bullettable = args[1]
			--		local dataset = {gamelogic.currentgun.data, bullettable.firepos}
			--		for i=1, #bullettable.bullets do
			--			local v = bullettable.bullets[i]
			--			aimbot.BulletQuery[v[2]] = dataset
			--		end
			--		timer:Simple(1.5, function()
			--			for i=1, #bullettable.bullets do
			--				local v = bullettable.bullets[i]
			--				aimbot.BulletQuery[v[2]] = nil
			--			end
			--		end)
			--	end
			--end)
--
			--hook:Add("OnConfigChanged", "BBOT:RageBot.DamagePredictionReset", function(steps, old, new)
			--	if config:IsPathwayEqual(steps, "Main", "Rage", "Settings", "Damage Prediction Limit") then
			--		for k, v in next, players:GetPlayers() do
			--			aimbot.predictedDamageDealt[v] = (100-hud:getplayerhealth(v))
			--			aimbot.predictedLastHealth[v] = hud:getplayerhealth(v)
			--		end
			--	end
			--end)
--
			--hook:Add("OnAliveChanged", "BBOT:RageBot.DamagePredictionReset", function()
			--	for k, v in next, players:GetPlayers() do
			--		aimbot.predictedDamageDealt[v] = (100-hud:getplayerhealth(v))
			--		aimbot.predictedLastHealth[v] = hud:getplayerhealth(v)
			--	end
			--end)
--
			--hook:Add("Postupdatespawn", "BBOT:RageBot.DamagePredictionReset", function(player, controller)
			--	aimbot.predictedLastHealth[player] = 100
			--	aimbot.predictedDamageDealt[player] = 0
			--	aimbot.predictedDamageUpdate[player] = tick() + (extras:getLatency() * 5)
			--end)
--
			--hook:Add("PlayerAdded", "BBOT:RageBot.DamagePredictionReset", function(player, controller)
			--	aimbot.predictedLastHealth[player] = 100
			--	aimbot.predictedDamageDealt[player] = 0
			--	aimbot.predictedDamageUpdate[player] = tick() + (extras:getLatency() * 5)
			--end)
--
			--hook:Add("PlayerRemoving", "BBOT:RageBot.DamagePredictionReset", function(player, controller)
			--	aimbot.predictedLastHealth[player] = nil
			--	aimbot.predictedDamageDealt[player] = nil
			--	aimbot.predictedDamageUpdate[player] = nil
			--end)
--
			--local dmg_last = 0
--
			--hook:Add("RenderStepped", "BBOT:RageBot.DamagePrediction", function()
			--	for index, time in next, aimbot.predictedDamageUpdate do
			--		if time < tick() then
			--			aimbot.predictedDamageDealt[index] = (100-hud:getplayerhealth(index))
			--			aimbot.predictedLastHealth[index] = hud:getplayerhealth(index)
			--			aimbot.predictedDamageUpdate[index] = nil
			--		end
			--	end
--
			--	for index, time in next, aimbot.predictedDamageDealt do
			--		local hpnew = hud:getplayerhealth(index)
			--		if not aimbot.predictedLastHealth[index] then
			--			aimbot.predictedLastHealth[index] = hpnew
			--		end
			--		if hpnew > aimbot.predictedLastHealth[index] then
			--			aimbot.predictedLastHealth[index] = hpnew
			--			if not aimbot.predictedDamageUpdate[index] then
			--				aimbot.predictedDamageUpdate[index] = tick() + (extras:getLatency() * 5)
			--			end
			--		elseif hpnew < aimbot.predictedLastHealth[index] then
			--			aimbot.predictedLastHealth[index] = hpnew
			--			aimbot.predictedDamageUpdate[index] = tick() + (extras:getLatency() * 5)
			--		end
			--	end
			--end)

			local last_repupdate_position
			hook:Add("PostNetworkSend", "BBOT:RageBot.LastPosition", function(netname, pos, ang, t)
				if netname ~= "repupdate" then return end
				last_repupdate_position = pos
			end)

			hook:Add("PreupdateReplication", "BBOT:Aimbot.updateReplication", function(player, controller)
				controller._receivedPosition = controller.receivedPosition
				controller._receivedVelocity = controller.receivedVelocity
				controller._receivedFrameTime = controller.receivedFrameTime
			end)

			local vec0 = Vector3.zero
			hook:Add("PostupdateReplication", "BBOT:RageBot.CheckAlive", function(player, controller)
				local t, last_t = tick(), controller.__t_received
				if controller._receivedPosition and controller._receivedFrameTime and last_t then
					controller.tickVelocity = (controller.receivedPosition - controller._receivedPosition) * (last_t - t)/2;
					controller.pingVelocity = (controller.receivedPosition - controller._receivedPosition) * extras:getLatency()/2;
				end
				local vel_resolver = aimbot:GetRageConfig("Settings", "Velocity Modifications")
				if vel_resolver == "Zero" then
					controller.receivedVelocity = vec0
				elseif vel_resolver == "Tick" and controller.tickVelocity then
					controller.receivedVelocity = controller.tickVelocity
				elseif vel_resolver == "Ping" and controller.pingVelocity then
					controller.receivedVelocity = controller.pingVelocity
				end
				controller.__t_received = t
			end)

			hook:Add("Postupdatespawn", "BBOT:RageBot.CheckAlive", function(player, controller)
				controller.__t_received = tick()
			end)

			hook:Add("OnAliveChanged", "BBOT:RageBot.LastPosition", function()
				last_repupdate_position = nil
			end)

			do
				local auto_wall = aimbot:GetRageConfig("Aimbot", "Auto Wallbang")
				local hitscan_priority = aimbot:GetRageConfig("Aimbot", "Hitscan Priority")
				local aimbot_fov = aimbot:GetRageConfig("Aimbot", "Aimbot FOV")
				
				local hitbox_shift_points = aimbot:GetRageConfig("HVH", "Hitbox Hitscan Points")
				local hitbox_shift_distance = aimbot:GetRageConfig("HVH", "Hitbox Shift Distance")
				local max_players = aimbot:GetRageConfig("Settings", "Max Players")
				local relative_only = aimbot:GetRageConfig("Settings", "Relative Points Only")
				local cross_relative_only = aimbot:GetRageConfig("Settings", "Cross Relative Points Only")
				
				local hitbox_points, hitbox_points_name = {}, {}
				hitbox_points[#hitbox_points+1] = CFrame.new(0,0,0) hitbox_points_name[#hitbox_points_name+1] = "Origin"

				local firepos_shift_points = aimbot:GetRageConfig("HVH", "FirePos Hitscan Points")
				local firepos_shift_distance = aimbot:GetRageConfig("HVH", "FirePos Shift Distance")
				local firepos_shift_multi = aimbot:GetRageConfig("HVH", "FirePos Shift Multi-Point")
				
				local firepos_points, firepos_points_name = {}, {}
				firepos_points[#firepos_points+1] = CFrame.new(0,0,0) firepos_points_name[#firepos_points_name+1] = "Origin"
				
				local tp_scanning_points = #firepos_points
				local points_allowed = aimbot:GetRageConfig("HVH", "TP Scanning Points")
				local tp_scan_dist = aimbot:GetRageConfig("HVH", "TP Scanning Distance")
				local tp_scan_multi = aimbot:GetRageConfig("HVH", "TP Scanning Multi-Point")
				local tp_scan_shift = aimbot:GetRageConfig("HVH", "TP Scanning Shift")
				--[[if aimbot:GetRageConfig("HVH", "TP Scanning") then
					local points_allowed = aimbot:GetRageConfig("HVH", "TP Scanning Points")
					local tp_scan_dist = aimbot:GetRageConfig("HVH", "TP Scanning Distance")
					local tp_scan_multi = aimbot:GetRageConfig("HVH", "TP Scanning Multi-Point")
					for i=1, tp_scan_multi do
						local scan_dist = (tp_scan_dist/tp_scan_multi)*i
						if points_allowed.Up then firepos_points[#firepos_points+1] = CFrame.new(0,scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Up" end
						if points_allowed.Down then firepos_points[#firepos_points+1] = CFrame.new(0,-scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Down" end
						if points_allowed.Left then firepos_points[#firepos_points+1] = CFrame.new(-scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Left" end
						if points_allowed.Right then firepos_points[#firepos_points+1] = CFrame.new(scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Right" end
						if points_allowed.Forward then firepos_points[#firepos_points+1] = CFrame.new(0,0,-scan_dist) firepos_points_name[#firepos_points_name+1] = "Forward" end
						if points_allowed.Backward then firepos_points[#firepos_points+1] = CFrame.new(0,0,scan_dist) firepos_points_name[#firepos_points_name+1] = "Backward" end
					end
				end]]
				
				local damage_prediction = aimbot:GetRageConfig("Settings", "Damage Prediction")
				local damage_prediction_limit = aimbot:GetRageConfig("Settings", "Damage Prediction Limit")

				local hitbox_random = 0
				local firepos_random = 0

				hook:Add("OnConfigChanged", "BBOT:RageBot.CacheConfig", function(steps)
					if not config:IsPathwayEqual(steps, "Main", "Rage") then return end
					local self = aimbot
					auto_wall = self:GetRageConfig("Aimbot", "Auto Wallbang")
					hitscan_priority = self:GetRageConfig("Aimbot", "Hitscan Priority")
					aimbot_fov = self:GetRageConfig("Aimbot", "Aimbot FOV")
					
					hitbox_shift_points = self:GetRageConfig("HVH", "Hitbox Hitscan Points")
					hitbox_shift_distance = self:GetRageConfig("HVH", "Hitbox Shift Distance")
					max_players = self:GetRageConfig("Settings", "Max Players")
					relative_only = self:GetRageConfig("Settings", "Relative Points Only")
					cross_relative_only = self:GetRageConfig("Settings", "Cross Relative Points Only")
					
					hitbox_points, hitbox_points_name = {}, {}
					if hitbox_shift_points.Origin then hitbox_points[#hitbox_points+1] = CFrame.new(0,0,0) hitbox_points_name[#hitbox_points_name+1] = "Origin" end
					if hitbox_shift_points.Forward then hitbox_points[#hitbox_points+1] = CFrame.new(0,0,-hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Forward" end
					if hitbox_shift_points.Backward then hitbox_points[#hitbox_points+1] = CFrame.new(0,0,hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Backward" end
					if hitbox_shift_points.Up then hitbox_points[#hitbox_points+1] = CFrame.new(0,hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Up" end
					if hitbox_shift_points.Down then hitbox_points[#hitbox_points+1] = CFrame.new(0,-hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Down" end
					if hitbox_shift_points.Left then hitbox_points[#hitbox_points+1] = CFrame.new(-hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Left" end
					if hitbox_shift_points.Right then hitbox_points[#hitbox_points+1] = CFrame.new(hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Right" end

					local hitbox_shift_static_points = self:GetRageConfig("HVH Extras", "Hitbox Static Points")
					if hitbox_shift_static_points.Forward then hitbox_points[#hitbox_points+1] = Vector3.new(0,0,-hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Any" end
					if hitbox_shift_static_points.Backward then hitbox_points[#hitbox_points+1] = Vector3.new(0,0,hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Any" end
					if hitbox_shift_static_points.Up then hitbox_points[#hitbox_points+1] = Vector3.new(0,hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end
					if hitbox_shift_static_points.Down then hitbox_points[#hitbox_points+1] = Vector3.new(0,-hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end
					if hitbox_shift_static_points.Left then hitbox_points[#hitbox_points+1] = Vector3.new(-hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end
					if hitbox_shift_static_points.Right then hitbox_points[#hitbox_points+1] = Vector3.new(hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end

					firepos_shift_points = self:GetRageConfig("HVH", "FirePos Hitscan Points")
					firepos_shift_distance = self:GetRageConfig("HVH", "FirePos Shift Distance")
					firepos_shift_multi = self:GetRageConfig("HVH", "FirePos Shift Multi-Point")
					
					firepos_points, firepos_points_name = {}, {}
					if firepos_shift_points.Origin then firepos_points[#firepos_points+1] = CFrame.new(0,0,0) firepos_points_name[#firepos_points_name+1] = "Origin" end
					if firepos_shift_points.Forward then firepos_points[#firepos_points+1] = CFrame.new(0,0,-firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Forward" end
					if firepos_shift_points.Backward then firepos_points[#firepos_points+1] = CFrame.new(0,0,firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Backward" end

					local firepos_shift_static_points = self:GetRageConfig("HVH Extras", "FirePos Static Points")
					if firepos_shift_static_points.Up then firepos_points[#firepos_points+1] = Vector3.new(0,firepos_shift_distance,0) firepos_points_name[#firepos_points_name+1] = "Any" end
					if firepos_shift_static_points.Down then firepos_points[#firepos_points+1] = Vector3.new(0,-firepos_shift_distance,0) firepos_points_name[#firepos_points_name+1] = "Any" end
					if firepos_shift_static_points.Left then firepos_points[#firepos_points+1] = Vector3.new(-firepos_shift_distance,0,0) firepos_points_name[#firepos_points_name+1] = "Any" end
					if firepos_shift_static_points.Right then firepos_points[#firepos_points+1] = Vector3.new(firepos_shift_distance,0,0) firepos_points_name[#firepos_points_name+1] = "Any" end
					if firepos_shift_static_points.Forward then firepos_points[#firepos_points+1] = Vector3.new(0,0,-firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Any" end
					if firepos_shift_static_points.Backward then firepos_points[#firepos_points+1] = Vector3.new(0,0,firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Any" end

					for i=1, firepos_shift_multi do
						local scale = (firepos_shift_distance/firepos_shift_multi)*i
						if firepos_shift_points.Up then firepos_points[#firepos_points+1] = CFrame.new(0,scale,0) firepos_points_name[#firepos_points_name+1] = "Up" end
						if firepos_shift_points.Down then firepos_points[#firepos_points+1] = CFrame.new(0,-scale,0) firepos_points_name[#firepos_points_name+1] = "Down" end
						if firepos_shift_points.Left then firepos_points[#firepos_points+1] = CFrame.new(-scale,0,0) firepos_points_name[#firepos_points_name+1] = "Left" end
						if firepos_shift_points.Right then firepos_points[#firepos_points+1] = CFrame.new(scale,0,0) firepos_points_name[#firepos_points_name+1] = "Right" end
					end

					hitbox_random = #hitbox_points
					local hitbox_randompoints = self:GetRageConfig("HVH Extras", "Hitbox Random Points")
					for i=1, hitbox_randompoints do
						hitbox_points[#hitbox_points+1] = CFrame.new(0,0,0)
						hitbox_points_name[#hitbox_points_name+1] = "Random"
					end

					firepos_random = #firepos_points
					local firepos_randompoints = self:GetRageConfig("HVH Extras", "FirePos Random Points")
					for i=1, firepos_randompoints do
						firepos_points[#firepos_points+1] = CFrame.new(0,0,0)
						firepos_points_name[#firepos_points_name+1] = "Random"
					end

					tp_scanning_points = #firepos_points
					points_allowed = self:GetRageConfig("HVH", "TP Scanning Points")
					tp_scan_dist = self:GetRageConfig("HVH", "TP Scanning Distance")
					tp_scan_multi = self:GetRageConfig("HVH", "TP Scanning Multi-Point")
					tp_scan_shift = aimbot:GetRageConfig("HVH", "TP Scanning Shift")
					for i=1, tp_scan_multi do
						scan_dist = (tp_scan_dist/tp_scan_multi)*i
						if points_allowed.Up then firepos_points[#firepos_points+1] = CFrame.new(0,scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Up" end
						if points_allowed.Down then firepos_points[#firepos_points+1] = CFrame.new(0,-scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Down" end
						if points_allowed.Left then firepos_points[#firepos_points+1] = CFrame.new(-scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Left" end
						if points_allowed.Right then firepos_points[#firepos_points+1] = CFrame.new(scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Right" end
						if points_allowed.Forward then firepos_points[#firepos_points+1] = CFrame.new(0,0,-scan_dist) firepos_points_name[#firepos_points_name+1] = "Forward" end
						if points_allowed.Backward then firepos_points[#firepos_points+1] = CFrame.new(0,0,scan_dist) firepos_points_name[#firepos_points_name+1] = "Backward" end
					end
					
					damage_prediction = self:GetRageConfig("Settings", "Damage Prediction")
					damage_prediction_limit = self:GetRageConfig("Settings", "Damage Prediction Limit")
				end)
				
				local cross_relatives = {
					["Up"] = "Down",
					["Down"] = "Up",
					["Left"] = "Right",
					["Right"] = "Left",
					["Forward"] = "Backward",
					["Backward"] = "Forward",
				}

				aimbot.ragebot_next = {}
				aimbot.ragebot_prioritynext = {}

				hook:Add("OnPriorityChanged", "BBOT:RageBot.Organize", function(player, old, new)
					if new and new > 0 then
						local found = false
						local c = 0
						for i=1, #aimbot.ragebot_next do
							local v = aimbot.ragebot_next[i-c]
							if v == player then
								table.remove(aimbot.ragebot_next, i-c)
								c=c+1
								found = true
							end
						end
						if found then
							aimbot.ragebot_prioritynext[#aimbot.ragebot_prioritynext+1] = player
						end
					else
						local found = false
						local c = 0
						for i=1, #aimbot.ragebot_prioritynext do
							local v = aimbot.ragebot_prioritynext[i-c]
							if v == player then
								table.remove(aimbot.ragebot_prioritynext, i-c)
								c=c+1
								found = true
							end
						end
						c = 0
						for i=1, #aimbot.ragebot_next do
							local v = aimbot.ragebot_next[i-c]
							if v == player then
								table.remove(aimbot.ragebot_next, i-c)
								c=c+1
							end
						end
						if found and (not new or new == 0) then
							aimbot.ragebot_next[#aimbot.ragebot_next+1] = player
						end
					end
				end)

				hook:Add("PostInitialize", "BBOT:RageBot.Organize", function()
					hook:Add("PlayerAdded", "BBOT:RageBot.Organize", function(player)
						local inpriority = config:GetPriority(player)
						if inpriority > 0 then
							aimbot.ragebot_prioritynext[#aimbot.ragebot_prioritynext+1] = player
						elseif inpriority == 0 then
							aimbot.ragebot_next[#aimbot.ragebot_next+1] = player
						end
					end)
		
					hook:Add("PlayerRemoving", "BBOT:RageBot.Organize", function(player)
						local c = 0
						for i=1, #aimbot.ragebot_prioritynext do
							local v = aimbot.ragebot_prioritynext[i-c]
							if v == player then
								table.remove(aimbot.ragebot_prioritynext, i-c)
								c=c+1
							end
						end
						c = 0
						for i=1, #aimbot.ragebot_next do
							local v = aimbot.ragebot_next[i-c]
							if v == player then
								table.remove(aimbot.ragebot_next, i-c)
								c=c+1
							end
						end
					end)

					local p = players:GetPlayers()
					for i=1, #p do
						local v = p[i]
						local priority = config:GetPriority(v) or 0
						if priority > 0 then
							aimbot.ragebot_prioritynext[#aimbot.ragebot_prioritynext+1] = v
						elseif priority == 0 then
							aimbot.ragebot_next[#aimbot.ragebot_next+1] = v
						end
					end
				end)

				local last_prioritized = nil
				hook:Add("OnConfigChanged", "BBOT:Aimbot.PriorityAuto", function(steps, old, new)
					if not config:IsPathwayEqual(steps, "Main", "Rage", "Settings", "Priority Last") then return end
					for i, v in pairs(players:GetPlayers()) do
						if v == last_prioritized then
							hook:Call("OnPriorityChanged", last_prioritized, 10, config:GetPriority(last_prioritized))
							break
						end
					end
					last_prioritized = nil
				end)

				hook:Add("LocalKilled", "BBOT:Aimbot.PriorityLast", function(player)
					if not aimbot:GetRageConfig("Settings", "Priority Last") then return end
					if not player then return end
					local old, lastpriority = last_prioritized, config:GetPriority(player)
					last_prioritized = player
					hook:Call("OnPriorityChanged", player, lastpriority, 10)
					for i, v in pairs(players:GetPlayers()) do
						if v == old then
							hook:Call("OnPriorityChanged", old, 10, config:GetPriority(old))
							break
						end
					end
				end)

				hook:Add("GetPriority", "BBOT:Aimbot.PriorityAuto", function(player)
					if not aimbot:GetRageConfig("Settings", "Priority Last") then return end
					if player == last_prioritized then
						return 10, "Auto"
					end
				end)
			end

			-------------------------------------
			-- Ragebot
			-------------------------------------
			do
				local replication   = BBOT.aux.replication
				local char          = BBOT.aux.char
				local caster        = BBOT.aux.raycast
				local network       = BBOT.aux.network
				local sound         = BBOT.aux.sound

				local localplayer   = BBOT.service:GetService("LocalPlayer")
				local repupdate     = BBOT.repupdate
				local pathing       = BBOT.pathing
				local vector        = BBOT.vector
				local wrapback      = BBOT.iterators.Wrapback

				local phantoms      = game.Teams.Phantoms
				local ghosts        = game.Teams.Ghosts

				local charsbyplayer = getupvalue(replication.getallparts, 1)

				local dot = Vector3.zero.Dot

				-- a better implementation for profiling should be made later lol
				--[[profiles = {};]] 
				local pather = pathing.new()
				pather:SetRaycastCallback(function(data) -- collision filter
					local p = data.Instance
					if p.Name:lower() == "killwall" then
						return false
					end
					if not p.CanCollide then
						return true
					end
					if p.Name ~= "Window" then
						return false
					end
					return true
				end)
				local ragebot = { tpmethods = {}; hitboxshiftmethods = {}; next_shot = -1;
								  pather = pathing.new() }

				local cardinals = {
					-- Used for cardinal scanning
					Vector3.yAxis, -Vector3.yAxis,
					Vector3.xAxis, -Vector3.xAxis,
					-Vector3.zAxis, Vector3.zAxis
					--[[
						The cardinals covered
						(pretend the slashes next to the vertical bars are z-axis)

						 \|/
						----
						/|\
					]]
				}

				local function bullet_filter(p)
					if not p.CanCollide then
					    return true
					end
					if p.Transparency == 1 then
					    return true
					end
					if p.Name ~= "Window" then
					    return
					end
					return true
				end

				-- Does not use destination
				function aimbot:BulletCheck(origin, init_velocity, time, acceleration, penetration, step)
					if --[[coolmath.isNaN(time, true) or]] time > 1.5 then
						return
					end

					local ignore_env = { workspace.Players, workspace.Ignore }
					local reaches_target = true
					local passed = 0
					local step = step or (1 / 30)
					local bullet_pos = origin
					local bullet_vel = init_velocity
					local pen_power = penetration

					while passed < time do
						local dt = math.min(step, time - passed)
						local step_vel = dt * bullet_vel + 0.5 * acceleration * dt * dt
						-- vec, dir, extra, cb
						local enter_data = caster.raycast(bullet_pos, step_vel, ignore_env, bullet_filter, true)

						if enter_data then
							local unit = step_vel.Unit
							local enter = enter_data.Position
							local hit = enter_data.Instance

							local exit_data = caster.raycastSingleExit(enter, hit.Size.magnitude * unit, hit)
							if exit_data then
								local dist = dot(unit, exit_data.Position - enter)
								pen_power = pen_power - dist
								if pen_power < 0 then
									reaches_target = false
									break
								end
							end
							
							local true_dt = dot(step_vel, enter - bullet_pos) / dot(step_vel, step_vel) * dt
							bullet_pos = enter + 0.01 * unit
							bullet_vel = bullet_vel + true_dt * acceleration
							passed = passed + true_dt
							ignore_env[#ignore_env + 1] = hit
						else
							bullet_pos = bullet_pos + step_vel
							bullet_vel = bullet_vel + dt * acceleration
							passed = passed + dt
						end
					end

					return reaches_target
				end

				-------------------------------------
				-- TP scan methods
				-------------------------------------

				-- All TP method functions should
				-- at the very least take two arguments:
				-- from: Vector3, to: Vector3

				-- This ensures that they will work in compliance
				-- with the ragebot system
				do
					function ragebot.tpmethods.pathfinding(from, to)
						pather:SetFrom(from)
						pather:SetTo(to)
						return pather:Calculate()
					end

					-- I'm not sure how configurating the "resolution"
					-- of Frisbee scanning is going to work, but for
					-- all intents and purposes 5 is generally enough,
					-- plus the randomization...
					local angles = {}

					do
						local frisbee_res = 5
						-- horizontal
					    for angle = -math.pi, math.pi, math.pi/frisbee_res do
					        angles[#angles + 1] = Vector3.new(math.sin(angle), 0, math.cos(angle))
					    end
					    -- vertical	
					    for angle = -math.pi, math.pi, math.pi/frisbee_res do
					        angles[#angles + 1] = Vector3.new(0, math.sin(angle))
					    end
					end

					-- This is called "frisbee" since it behaves somewhat
					-- like a frisbee: you toss the frisbee into multiple
					-- directions and measure how far the frisbee traveled
					-- in each direction, and choose the direction which
					-- ran the furthest distance.  

					-- This works very well for peeking outdoors and for
					-- moving to random locations on the map
					function ragebot.tpmethods.frisbee(from, to, steps)
						local path = { from }
						local last_dir
						for step = 1, (steps or 8) do
						    local best_dist = -1/0
						    local best_pos
						    local rand_dist = math.random(9, 500)
						    local cur_pos = path[#path]
						    for i = 1, #angles do
						        local unit = angles[i] + 0.08 * vector.randomspherepoint(1)
						        if (not last_dir) or dot(unit, last_dir) > -0.5 then
						            local hit = repupdate:Raycast(cur_pos, unit * rand_dist)
						            local next_pos = hit and hit.Position - 0.1 * unit or cur_pos + (rand_dist - 5) * unit
						            local diff = next_pos - cur_pos
						            local dist_sq = dot(diff, diff)
						            if dist_sq > best_dist then
						                best_dist = dist_sq
						                best_pos = next_pos
						                last_dir = unit
						            end
						        end
						    end
						    if best_pos then
						    	path[#path + 1] = best_pos
						    end
						end
						return path
					end

					--[[function ragebot.tpmethods.spiralUpwards(from, to)
						local path = { from }

						local angle = 2 * math.random() * tau
						local yAngle = 0

						do
						    local unit = Vector3.new(sin(angle), 0, cos(angle))
						    local initialDirection = unit * 2048
						    local cast = raycast.cast(from, initialDirection, {workspace.Players, workspace.Ignore}, collisionFilter)
						    if not cast then
						        return
						    end
						    path[#path + 1] = cast.Position - 0.01 * unit
						end

						for i = 1, 16 do
						    angle += rad(65)
						    yAngle += 0.02
						    local unit = Vector3.new(sin(angle), yAngle, cos(angle))
						    local direction = unit * 4096
						    local cast = raycast.cast(path[#path], direction, {workspace.Players, workspace.Ignore}, collisionFilter)
						    path[#path + 1] = cast and cast.Position - unit or path[#path] + direction
						end

						return path
					end]]
				end

				-------------------------------------
				-- Hitbox shift methods
				-------------------------------------

				-- All hitbox shift method functions should
				-- at the very least take three arguments:
				-- from: Vector3, to: Vector3, dist: number
				do
					-- This attempts to return the closest position of visibility
					-- so that the first obstructing wall from "to" to "from"
					-- is visible to a potential second wall, or visible to "from"
					function ragebot.hitboxshiftmethods.raycasting(from, to, dist)
					    local dir = from - to
					    local cast = caster.raycast(to, dir, { workspace.Players, workspace.Ignore }, bullet_filter)
					    return cast and to - dist * cast.Normal or to - dist * dir.Unit
					end

					-- Theres probably a better name for this one(?)
					function ragebot.hitboxshiftmethods.clamping(from, to, dist)
					    local diff = from - to
					    local shift = Vector3.new(diff.x > 0 and 1 or -1, diff.y > 0 and 1 or -1, diff.z > 0 and 1 or -1)
					    return to + dist * shift.unit
					end

					function ragebot.hitboxshiftmethods.random(from, to, dist)
					    return to + dist * vector.randomspherepoint(1)
					end

					local cardinal_cursor = 1
					function ragebot.hitboxshiftmethods.cardinals(from, to, dist)
					    local offset = cardinals[cardinal_cursor]
					    cardinal_cursor = (cardinal_cursor - 1) % #cardinals + 1
					    return to + dist * offset
					end

					-- Pushes "to" towards "from" by "dist" studs
					function ragebot.hitboxshiftmethods.push(from, to, dist)
						return to + dist * (from - to).unit
					end
				end

				-- This WILL BE REQUIRED for ensuring players do not go outside
				-- of the map bounds (the default method preventing people from
				-- getting extremely far from the map)

				-- This method is present on every map in the game, so we will need
				-- to set this up later.

				function ragebot.fixPath(path)
					for i = 1, #path do
						local pos = path[i]
						if not repupdate:IsPosWithinMapBounds(pos) then
							path[i] = repupdate:ClampPosToMapBounds(pos)
						end
					end
				end

				-------------------------------------
				-- Method management
				-------------------------------------

				local tp_method_order = {}
				local hb_shift_method_order = {}

				for name, func in next, ragebot.tpmethods do
					tp_method_order[#tp_method_order + 1] = { name = name; func = func; success = false; successfulattempts = 0 }
				end

				for name, func in next, ragebot.hitboxshiftmethods do
					hb_shift_method_order[#hb_shift_method_order + 1] = { name = name; func = func; success = false; successfulattempts = 0 }
				end

				-- The above is done to minimize wasting time using
				-- methods that are not expedient to use at a given position.
				-- (implementation for sorting is in scanTargetSingle)

				-- Ex: one method may work better indoors than the other, so
				-- this will make sure that method will be used more supremely
				-- The moment a method fails, another method may be used which could work more often

				local function method_sort_predicate(l, r)
					local left_score = (l.success and 2 or 1) * l.successfulattempts
					local right_score = (r.success and 2 or 1) * r.successfulattempts
					return left_score > right_score
				end

				local function rage_target_sort_predicate(l, r)
					local server_pos = repupdate:GetPosition()

					local left_pos, right_pos = l.position, r.position

					local l_delta = left_pos  - server_pos
					local r_delta = right_pos - server_pos

					-- On most maps, getting very high in the sky means
					-- less walls will be obstructing the target, so we 
					-- want to make sure we are getting rid of these idiots first

					-- However, we still prefer also having the closest
					-- people in the list first, so we also consider
					-- horizontal distance
					local left_score  = math.abs( l_delta.x * l_delta.x  +  l_delta.z * l_delta.z ) + math.abs( l_delta.y ^ 4 )
					local right_score = math.abs( r_delta.x * r_delta.x  +  r_delta.z * r_delta.z ) + math.abs( r_delta.y ^ 4 )

					-- TODO: Add spawn time as a heuristic to maximize spawn-killing
					-- TODO: Add priority

					return right_score > left_score
				end

				-- Start actual ragebot scanning stuff

				-- Cream, do your organization magic (make this not super weird)
				local cardinal_cursor     = 1 -- Used for wrapback iteration
				local tp_method_cursor    = 1
				local hb_method_cursor    = 1
				local ticket              = -1 -- Used for sending bullets
				local next_teleport       = -1 -- Used for throttling teleport scanning
				local flip                = true -- Used for other things that occur every other frame or check (?) i guess

				function aimbot:ScanRageTargetSingle(origin, gun, target, target_data)
					--[[
					    Target information structure
					 	{
					 		firepos = <Vector3> position
					 		waypoints = Array<Vector3>? waypoints
					    	targets = {
					    		an array of these kinds of tables
								{
							    	player = <Player> player
							    	launchvelocity = <Vector3> velocity
							    	hitpos = <Vector3> position
									traveltime = <number> duration
								}, ...
					    	}
					    }
					]]

					local multipoint_amt           = 3
					local tp_methods_per_player    = 2
					local max_teleports_per_second = 8
					local waypoint_skip            = 2

					local data = gun.data

					local hb_shift_method              = hb_shift_method_order[hb_method_cursor]
					local hitbox_pos                   = flip and hb_shift_method.func(origin, target.position, 5) or target.position
					-- This is corrected for the bullet congruency check
					local firepos                      = target_data and target_data.firepos or origin + 0.01 * (hitbox_pos - origin).unit
					-- Check normally
					local launch_velocity, travel_time = physics.trajectory(firepos, self.bullet_gravity, hitbox_pos, data.bulletspeed)
					local reaches_target               = self:BulletCheck(firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
					if reaches_target then
						if target_data then
							target_data.targets[#target_data.targets + 1] = {
								player         = target.player,
								hitpos         = hitbox_pos,
								launchvelocity = launch_velocity,
								traveltime     = travel_time
							}
						end

						return target_data or {
							firepos = firepos,
							targets = {
								{
									player         = target.player,
									hitpos         = hitbox_pos,
									launchvelocity = launch_velocity,
									traveltime     = travel_time
								}
							}
						}
					elseif not target_data then
						-- Proceed with alternative techniques

						-- This is where the ragebot becomes unsafe to use without being banned
						if flip then
							-- Try a bunch of random points

							-- Cream - you'll probably just condense these into something
							-- like the old loop over the points setup in the rage config
							for i = 1, multipoint_amt do
								local new_firepos = origin + 9.9 * vector.randomspherepoint(1)
								local new_hitpos = flip and hb_shift_method.func(new_firepos, target.position, 5) or hitbox_pos
								local launch_velocity, travel_time = physics.trajectory(new_firepos, self.bullet_gravity, new_hitpos, data.bulletspeed)
								local reaches_target = self:BulletCheck(new_firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
								if reaches_target then
									return {
										firepos = new_firepos,
										--hitboxmethod = flip and hb_shift_method.name or nil,
										targets = {
											{
												player = target.player,
												hitpos = new_hitpos,
												launchvelocity = launch_velocity,
												traveltime = travel_time
											}
										}
									}
								end
							end
						else
							-- Good old cardinal scanning
							for j, vec in wrapback(cardinals, cardinal_cursor, multipoint_amt) do
								local new_firepos = origin + 9.9 * vec
								local new_hitpos = flip and hb_shift_method.func(new_firepos, target.position, 5) or hitbox_pos
								local launch_velocity, travel_time = physics.trajectory(new_firepos, self.bullet_gravity, new_hitpos, data.bulletspeed)
								local reaches_target = self:BulletCheck(new_firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
								if reaches_target then
									return {
										firepos = new_firepos,
										--hitboxmethod = flip and hb_shift_method.name or nil,
										targets = {
											{
												player = target.player,
												hitpos = new_hitpos,
												launchvelocity = launch_velocity,
												traveltime = travel_time
											}
										}
									}
								end
							end

							cardinal_cursor += multipoint_amt -- not wrapped around
						end

						-- It probably still didn't hit, lets teleport scan
						-- Are we on a cooldown?
						local now = os.clock()
						if now > next_teleport then
							table.sort(tp_method_order, method_sort_predicate) -- sort first

							for j, method_data in wrapback(tp_method_order, tp_method_cursor, tp_methods_per_player) do
								local path = method_data.func(origin, hitbox_pos)
								if (not path) or #path == 0 then
									method_data.success = false
									continue
								end
								ragebot.fixPath(path) -- fucking annoying that i have to do this
								for k = 2, #path, waypoint_skip + 1 do
									local new_firepos = path[k]
									local new_hitpos = flip and hb_shift_method.func(new_firepos, target.position, 5) or hitbox_pos
									local launch_velocity, travel_time = physics.trajectory(new_firepos, self.bullet_gravity, new_hitpos, data.bulletspeed)
									local reaches_target = self:BulletCheck(new_firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
									method_data.success = reaches_target

									if reaches_target then
										method_data.successfulattempts += 1
										if hb_shift_method then
											hb_shift_method.successfulattempts += 1
										end
										next_teleport = now + (1/max_teleports_per_second)
										return {
											firepos = new_firepos,
											waypoints = table.pack(table.unpack(path, 1, k)), -- Trimming the path from 1 to k (where we are on the path)
											--[[method = method_data.name, 		This was just some debug stuff in my hack to see which methods were used
											hitboxmethod = flip and hb_shift_method.name or nil,]]
											targets = {
												{
													player = target.player,
													hitpos = new_hitpos,
													launchvelocity = launch_velocity,
													traveltime = travel_time
												}
											}
										}
									else
										if method_data.successfulattempts > 0 then
											method_data.successfulattempts -= 1
										end
										if flip and hb_shift_method.successfulattempts > 0 then
											hb_shift_method.successfulattempts -= 1
										end
									end
								end
							end

							tp_method_cursor += tp_methods_per_player
							if flip then
								hb_method_cursor = hb_method_cursor % #hb_shift_method_order + 1
							end
						end
					end
				end

				function aimbot:GetRageTargets(gun)
					local valid_targets = {}
					do
						local other_team = localplayer.Team == phantoms and ghosts or phantoms
						local p_list = other_team:GetPlayers()

						for i = 1, #p_list do
							local player = p_list[i]
							local updater = replication.getupdater(player)

							if updater and updater.alive then
								-- TODO: change the backup position to something that will fail less
								table.insert(valid_targets, {
									player = player,
									position = updater.receivedPosition or charsbyplayer[player].torso.Position,
									updater = updater
								})
							end
						end
					end

					if #valid_targets == 0 then
						return
					end
					-- there's no real reason to sort when theres only one guy
					if #valid_targets > 1 then
					    -- sort the targets using the predicate
					    table.sort(valid_targets, rage_target_sort_predicate)
					end

					--local playersScanned = math.min(#valid_targets, menu.flags.aimbot_ppf)

					-- There is an exception to this value
					-- which will be explained further down
					-- in the targetting scheme
					local players_scanned = #valid_targets -- fuck
					local target_data
					local origin = repupdate:GetPosition()
					for i = 1, players_scanned do
						local target = valid_targets[i]
						target_data = self:ScanRageTargetSingle(origin, gun, target)

						if target_data then
							-- Might add this back later
							--[[if (i + 1 + menu.flags.aimbot_maxbulktargets) <= #valid_targets then
								for ii = i+1, i + 1 + menu.flags.aimbot_maxbulktargets do
									local other_target = valid_targets[ii]
									self:ScanRageTargetSingle(origin, gun, other_target, target_data)
								end
							end]]
							break
						end
					end

					return target_data
				end

				function aimbot:RageStep(gun)
					local now = os.clock()
					if now >= ragebot.next_shot then
						local target_data = self:GetRageTargets(gun)
						if target_data then
							-- teleport if needs be
							if target_data.waypoints then
								local headheight_vec = Vector3.new(0, char.headheight)
								-- I have to do this for now
								for i = 1, #target_data.waypoints do
									repupdate:MoveTo(target_data.waypoints[i] - headheight_vec)
								end
                                --pathway, col, opacity, time
                                BBOT.drawpather:Simple(target_data.waypoints, Color3.new(1, 1), 1, 5)
							end

							local data = gun.data
							local server_pos = repupdate:GetPosition()

                            do
                                local circ = BBOT.draw:Create("Circle", "3D")
                                circ.Point = server_pos
                                circ.Visible = true
                                circ.Thickness = 2
                                circ.Radius = 10
                                circ.Opacity = 0.8
                                circ.NumSides = 10
                                circ.Filled = false
                                circ.Color = Color3.new(0.262745, 0.960784, 0.262745)

                                BBOT.timer:Simple(5, function()
                                    circ:Remove()
                                end)

                                local circ = BBOT.draw:Create("Circle", "3D")
                                circ.Point = target_data.firepos
                                circ.Visible = true
                                circ.Thickness = 2
                                circ.Radius = 10
                                circ.Opacity = 0.8
                                circ.NumSides = 10
                                circ.Filled = false
                                circ.Color = Color3.new(1.0, 0.0, 0.298039)

                                BBOT.timer:Simple(5, function()
                                    circ:Remove()
                                end)
                            end

							-- shoot bullets
							for i = 1, #target_data.targets do
								local target_info = target_data.targets[i]
								local bullets = {}
								local packets = {}
								local new_ticket = ticket - ((data.pelletcount or 1)-1)
								for id = ticket, new_ticket, -1 do
									bullets[#bullets + 1] = { target_info.launchvelocity, id }
									packets[#packets + 1] = { target_info.player, target_info.hitpos, "Head", id }
								end

								network:send("newbullets", {
									firepos = target_data.firepos,
									camerapos = server_pos, -- If you don't do this you will just dump
									bullets = bullets
								}, tick())
								-- Hit
								for j = 1, #packets do
									network:send("bullethit", unpack(packets[j]))
								end
								-- I'll send the timestamp even though
								-- they don't really use it anymore(?)
								-- better safe than sorry

								ticket = new_ticket - 1
							end

							local firerate = typeof(data.firerate) == "number" and data.firerate or data.firerate[1]
							ragebot.next_shot = math.min(now + (#target_data.targets * (60 / (firerate * 3))), now + 1) -- cool

							-- teleport back if needs be
							if target_data.waypoints then
								local headheight_vec = Vector3.new(0, char.headheight)
								-- I have to do this for now
								for i = #target_data.waypoints, 1, -1 do
									repupdate:MoveTo(target_data.waypoints[i] - headheight_vec)	
								end
							end

							-- Play fire sound just for auditory feedback
							sound.PlaySoundId(data.firesoundid, data.firevolume, data.firepitch, nil, nil, 0, 0.05)
						end
					end
				end
			end

			function aimbot:LegitStep(gun)
				if not gun or gun.knife or not gun.data.bulletspeed then return end
				--local profilename = "BBOT.Aimbot:LegitStep[" .. gun.name .. "]"
				--debug.profilebegin(profilename)

				--debug.profilebegin("SetCurrentType")
				self:SetCurrentType(gun)
				--debug.profileend()

				--debug.profilebegin("MouseStep")
				self:MouseStep(gun)
				--debug.profileend()

				--debug.profilebegin("TriggerBotStep")
				self:TriggerBotStep(gun)
				--debug.profileend()

				--debug.profilebegin("RedirectionStep")
				self:RedirectionStep(gun)
				--debug.profileend()

				--debug.profileend()
			end

			do
				--(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
				--[[Draw:Circle(false, 20, 20, 10, 3, 20, { 10, 10, 10, 215 }, menu.fovcircle)
				Draw:Circle(false, 20, 20, 10, 1, 20, { 255, 255, 255, 255 }, menu.fovcircle)]]
				local draw = BBOT.draw
				--(x, y, size, thickness, sides, color, transparency, visible)
				local fov = draw:Create("Circle", "2V") -- draw:Circle(0, 0, 1, 3, 314, { 10, 10, 10, 215 }, 1, false)
				fov.Radius = 1
				fov.NumSides = 314
				fov.Thickness = 1
				fov.Outlined = true
				fov.OutlineColor = Color3.new(0,0,0)
				fov.OutlineThickness = 1
				fov.Color = Color3.new(1,1,1)

				aimbot.fov_circle = fov
				aimbot.fov_circle_last = {Position = Vector2.new(), Radius = 0}

				local dzfov = draw:Clone(fov)
				aimbot.dzfov_circle = dzfov
				aimbot.dzfov_circle_last = {Position = Vector2.new(), Radius = 0}

				local sfov = draw:Clone(fov)
				aimbot.sfov_circle = sfov
				aimbot.sfov_circle_last = {Position = Vector2.new(), Radius = 0}

				local rfov = draw:Clone(fov)
				aimbot.rfov_circle = rfov
				aimbot.rfov_circle_last = {Position = Vector2.new(), Radius = 0}

				local tfov = draw:Clone(fov)
				aimbot.tfov_circle = tfov
				aimbot.tfov_circle_last = {Position = Vector2.new(), Radius = 0}

				hook:Add("Initialize", "BBOT:Visuals.Aimbot.FOV", function()
					local color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist", "Color")
					fov.Color = color
					fov.Opacity = transparency
					fov.OutlineOpacity = transparency
					color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone", "Color")
					dzfov.Color = color
					dzfov.Opacity = transparency
					dzfov.OutlineOpacity = transparency
					color, transparency = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect", "Color")
					sfov.Color = color
					sfov.Opacity = transparency
					sfov.OutlineOpacity = transparency
					color, transparency = config:GetValue("Main", "Visuals", "FOV", "Ragebot", "Color")
					rfov.Color = color
					rfov.Opacity = transparency
					rfov.OutlineOpacity = transparency
					color, transparency = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot", "Color")
					tfov.Color = color
					tfov.Opacity = transparency
					tfov.OutlineOpacity = transparency
				end)
				
				hook:Add("OnConfigChanged", "BBOT:Visuals.Aimbot.FOV", function(steps, old, new)
					if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV") or config:IsPathwayEqual(steps, "Main", "Legit") or config:IsPathwayEqual(steps, "Main", "Rage", "Aimbot") then
						local center = camera.ViewportSize/2
						fov.Offset = center
						dzfov.Offset = center
						sfov.Offset = center
						tfov.Offset = center
						rfov.Offset = center

						local color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist", "Color")
						fov.Color = color
						fov.Opacity = transparency
						fov.OutlineOpacity = transparency
						color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone", "Color")
						dzfov.Color = color
						dzfov.Opacity = transparency
						dzfov.OutlineOpacity = transparency
						color, transparency = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect", "Color")
						sfov.Color = color
						sfov.Opacity = transparency
						sfov.OutlineOpacity = transparency
						color, transparency = config:GetValue("Main", "Visuals", "FOV", "Ragebot", "Color")
						rfov.Color = color
						rfov.Opacity = transparency
						rfov.OutlineOpacity = transparency
						color, transparency = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot", "Color")
						tfov.Color = color
						tfov.Opacity = transparency
						tfov.OutlineOpacity = transparency

						fov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist")
						dzfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone")
						sfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect")
						tfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot")
						rfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Ragebot")
			
						local yport = camera.ViewportSize.y
						
						if not char.alive and config:IsPathwayEqual(steps, "Main", "Legit") and steps[3] then
							local _fov = config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Aimbot FOV")
							local _dzfov = config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Deadzone FOV")
							local _sfov = config:GetValue("Main", "Legit", steps[3], "Bullet Redirect", "Redirection FOV")
							local _tfov = config:GetValue("Main", "Legit", steps[3], "Trigger Bot", "Trigger FOV")
							if config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Dynamic FOV") then
								_fov = camera.FieldOfView / char.unaimedfov * _fov
								_dzfov = camera.FieldOfView / char.unaimedfov * _dzfov
								_sfov = camera.FieldOfView / char.unaimedfov * _sfov
								_tfov = camera.FieldOfView / char.unaimedfov * _tfov
							end
							fov.Radius = _fov / camera.FieldOfView  * yport
							aimbot.fov_circle_last.Radius = _fov / camera.FieldOfView  * yport

							dzfov.Radius = _dzfov / camera.FieldOfView  * yport
							aimbot.dzfov_circle_last.Radius = _dzfov / camera.FieldOfView  * yport

							sfov.Radius = _sfov / camera.FieldOfView  * yport
							aimbot.sfov_circle_last.Radius = _sfov / camera.FieldOfView  * yport

							tfov.Radius = _tfov / camera.FieldOfView  * yport
							aimbot.tfov_circle_last.Radius = _tfov / camera.FieldOfView  * yport
						end

						
						local _rfov = config:GetValue("Main", "Rage", "Aimbot", "Aimbot FOV")
						_rfov = camera.FieldOfView / char.unaimedfov * _rfov
						rfov.Radius = _rfov / camera.FieldOfView  * yport
						aimbot.rfov_circle_last.Radius = _rfov / camera.FieldOfView  * yport
						aimbot.rfov_circle_last = {Position = center, Radius = rfov.Radius}

						if not config:GetValue("Main", "Visuals", "FOV", "Enabled") then
							fov.Visible = false
							dzfov.Visible = false
							sfov.Visible = false
							rfov.Visible = false
							tfov.Visible = false
						end
					end
				end)
				
				local alive, curgun = false, false
				hook:Add("PreCalculateCrosshair", "BBOT:Visuals.Aimbot.FOV", function(position_override, onscreen)
					local enabled = config:GetValue("Main", "Visuals", "FOV", "Enabled")
					position_override = Vector2.new(position_override.X, position_override.Y)
					local set = false
					if enabled and alive ~= char.alive then
						alive = char.alive
						local bool = (alive and true or false)
						fov.Visible = bool
						dzfov.Visible = bool
						sfov.Visible = bool
						rfov.Visible = bool
						tfov.Visible = bool
						set = true
					end
				
					local mycurgun = gamelogic.currentgun
					if enabled and mycurgun and mycurgun.data and mycurgun.data.bulletspeed then
						aimbot:SetCurrentType(mycurgun)
						local _fov = aimbot:GetLegitConfig("Aim Assist", "Aimbot FOV")
						local _dzfov = aimbot:GetLegitConfig("Aim Assist", "Deadzone FOV")
						local _sfov = aimbot:GetLegitConfig("Bullet Redirect", "Redirection FOV")
						local _tfov = aimbot:GetLegitConfig("Trigger Bot", "Trigger FOV")
						if aimbot:GetLegitConfig("Aim Assist", "Dynamic FOV") then
							_fov = camera.FieldOfView / char.unaimedfov * _fov
							_dzfov = camera.FieldOfView / char.unaimedfov * _dzfov
							_sfov = camera.FieldOfView / char.unaimedfov * _sfov
							_tfov = camera.FieldOfView / char.unaimedfov * _tfov
						end

						local yport = camera.ViewportSize.y
						fov.Radius = _fov / camera.FieldOfView  * yport
						dzfov.Radius = _dzfov / camera.FieldOfView  * yport
						sfov.Radius = _sfov / camera.FieldOfView  * yport
						tfov.Radius = _tfov / camera.FieldOfView  * yport

						
						aimbot.fov_circle_last.Radius = fov.Radius
						aimbot.dzfov_circle_last.Radius = dzfov.Radius
						aimbot.sfov_circle_last.Radius = sfov.Radius
						aimbot.tfov_circle_last.Radius = tfov.Radius

						if aimbot:GetLegitConfig("Aim Assist", "Use Barrel") then
							fov.Offset = position_override
							dzfov.Offset = position_override
							aimbot.fov_circle_last.Position = position_override
							aimbot.dzfov_circle_last.Position = position_override
						else
							local center = camera.ViewportSize/2
							fov.Offset = center
							dzfov.Offset = center
							aimbot.fov_circle_last.Position = center
							aimbot.dzfov_circle_last.Position = center
						end

						if aimbot:GetLegitConfig("Bullet Redirect", "Use Barrel") then
							sfov.Offset = position_override
							aimbot.sfov_circle_last.Position = position_override
						else
							local center = camera.ViewportSize/2
							sfov.Offset = center
							aimbot.sfov_circle_last.Position = center
						end

						local center = camera.ViewportSize/2
						tfov.Offset = center
						aimbot.tfov_circle_last.Position = center
					end
					
					if enabled and curgun ~= gamelogic.currentgun or set then
						curgun = gamelogic.currentgun
						if curgun and curgun.data and curgun.data.bulletspeed then
							aimbot:SetCurrentType(curgun)

							local _fov_enabled = aimbot:GetLegitConfig("Aim Assist", "Enabled")
							local _sfov_enabled = aimbot:GetLegitConfig("Bullet Redirect", "Enabled")
							local _tfov_enabled = aimbot:GetLegitConfig("Trigger Bot", "Enabled")

							fov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist") and _fov_enabled
							dzfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone") and _fov_enabled
							sfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect") and _sfov_enabled
							tfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot") and _tfov_enabled
						else
							local bool = false
							fov.Visible = bool
							dzfov.Visible = bool
							sfov.Visible = bool
							tfov.Visible = bool
						end
					end
				end)
			end

			do -- Crosshair
				--draw:Box(x, y, w, h, thickness, color, transparency, visible)
				--draw:Line(thickness, start_x, start_y, end_x, end_y, color, transparency, visible)\
				--[[
				object.Visible = visible
				object.Thickness = thickness
				object.From = Vector2.new(start_x, start_y)
				object.To = Vector2.new(end_x, end_y)
				object.Color = self:VerifyColor(color)
				object.Transparency = transparency 
				]]

				local center_outline = draw:Create("Rect", "2V")
				center_outline.XAlignment = XAlignment.Right
				center_outline.YAlignment = YAlignment.Bottom
				center_outline.Color = Color3.new(1,1,1)

				local top_outline = draw:Create("Line", "2V", "2V")
				top_outline.Color = Color3.new(1,1,1)
				top_outline.Thickness = 2

				local top = draw:Create("Line", "2V", "2V")
				top.Color = Color3.new(0,0,0)

				local crosshair_objects = {
					center_outline = center_outline,
					top_outline = top_outline,
					bottom_outline = draw:Clone(top_outline),
					left_outline = draw:Clone(top_outline),
					right_outline = draw:Clone(top_outline),
					center = draw:Clone(center_outline),
					top = top,
					bottom = draw:Clone(top),
					left = draw:Clone(top),
					right = draw:Clone(top),
				}

				hook:Add("OnConfigChanged", "BBOT:Crosshair.Changed", function(steps, old, new)
					if config:IsPathwayEqual(steps, "Main", "Visuals", "Crosshair") then
						local enabled = config:GetValue("Main", "Visuals", "Crosshair", "Enabled")
						local inner, inner_transparency = config:GetValue("Main", "Visuals", "Crosshair", "Enabled", "Inner")
						local outter, outter_transparency = config:GetValue("Main", "Visuals", "Crosshair", "Enabled", "Outter")
						local width = config:GetValue("Main", "Visuals", "Crosshair", "Width")
						local height = config:GetValue("Main", "Visuals", "Crosshair", "Height")
						if not enabled then
							for k, v in pairs(crosshair_objects) do
								v.Visible = false
							end
						else
							for k, v in pairs(crosshair_objects) do
								if string.find(k, "outline", 1, true) then
									v.Color = outter
									v.Transparency = outter_transparency
								else
									v.Color = inner
									v.Transparency = inner_transparency
								end
							end

							local setup = config:GetValue("Main", "Visuals", "Crosshair", "Setup")
							crosshair_objects.center.Visible = setup.Center
							crosshair_objects.top.Visible = setup.Top
							crosshair_objects.bottom.Visible = setup.Bottom
							crosshair_objects.left.Visible = setup.Left
							crosshair_objects.right.Visible = setup.Right

							crosshair_objects.center_outline.Visible = setup.Center
							crosshair_objects.top_outline.Visible = setup.Top
							crosshair_objects.bottom_outline.Visible = setup.Bottom
							crosshair_objects.left_outline.Visible = setup.Left
							crosshair_objects.right_outline.Visible = setup.Right


							crosshair_objects.center.Size = Vector2.new(2, 2)
							crosshair_objects.top.Thickness = width
							crosshair_objects.bottom.Thickness = width
							crosshair_objects.left.Thickness = width
							crosshair_objects.right.Thickness = width

							width, height = width+2, height+2
							crosshair_objects.center_outline.Size = Vector2.new(2+2, 2+2)
							crosshair_objects.top_outline.Thickness = width
							crosshair_objects.bottom_outline.Thickness = width
							crosshair_objects.left_outline.Thickness = width
							crosshair_objects.right_outline.Thickness = width
						end
					end
				end)

				local lastrot = 0
				function aimbot:CrosshairStep(delta, gun)
					local enabled = config:GetValue("Main", "Visuals", "Crosshair", "Enabled")
					local positionoverride, ondascreen
					if gun then
						local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
						if part then
							if enabled then
								for k, v in pairs(crosshair_objects) do
									v.Visible = false
								end
							end
							ondascreen = false

							local raycastdata = self:raycastbullet(camera.CFrame.Position,part.CFrame.Position-camera.CFrame.Position)
							if raycastdata and raycastdata.Position then
								local point, onscreen = camera:WorldToViewportPoint(raycastdata.Position)
								positionoverride = point
							else
								raycastdata = self:raycastbullet(part.CFrame.Position,part.CFrame.LookVector * 10000)
								if raycastdata and raycastdata.Position then
									local point, onscreen = camera:WorldToViewportPoint(raycastdata.Position)
									positionoverride = point
								else
									local point, onscreen = camera:WorldToViewportPoint(part.CFrame.Position + part.CFrame.LookVector * 10000)
									positionoverride = point
								end
							end
							if positionoverride then
								if enabled then
									for k, v in pairs(crosshair_objects) do
										v.Visible = true
									end
								end
								ondascreen = true
							end
						end
					end

					hook:Call("PreCalculateCrosshair", (positionoverride and positionoverride or (camera.ViewportSize/2)), ondascreen)
					if not enabled then return end

					local setup = config:GetValue("Main", "Visuals", "Crosshair", "Setup")
					local gap = config:GetValue("Main", "Visuals", "Crosshair", "Gap")
					local width = config:GetValue("Main", "Visuals", "Crosshair", "Width")
					local height = config:GetValue("Main", "Visuals", "Crosshair", "Height")

					local addrot = 0
					if config:GetValue("Main", "Visuals", "Crosshair", "Animations") then
						local type = config:GetValue("Main", "Visuals", "Crosshair", "Animation Type")
						if type == "Wave" then
							addrot = math.sin(config:GetValue("Main", "Visuals", "Crosshair", "Animation Speed") * tick()) * config:GetValue("Main", "Visuals", "Crosshair", "Animation Amplitude")
						else
							addrot = lastrot + config:GetValue("Main", "Visuals", "Crosshair", "Animation Speed") * delta
							if addrot > 360 then
								addrot = addrot - 360
							end
							lastrot = addrot
						end
					end
					
					local rot = 0 + addrot
					local rad = math.rad(rot)
					local cs, sn = math.cos(rad), math.sin(rad)
					local outline_vec = Vector2.new(1,1)
					
					if setup.Center then
						local part = crosshair_objects.center
						local part_outline = crosshair_objects.center_outline
						if positionoverride then
							part.Offset = Vector2.new(positionoverride.x-part.Size.X/2,positionoverride.y-part.Size.Y/2)
						else
							part.Offset = (camera.ViewportSize/2) + Vector2.new(-part.Size.X/2,-part.Size.Y/2)
						end
						part_outline.Offset = part.Offset-outline_vec
						--part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot
					elseif crosshair_objects.center_outline.Visible then
						crosshair_objects.center.Visible = false
						crosshair_objects.center_outline.Visible = false
					end
					
					local addgap = 0
					--[[if config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Enable") then
						local type = config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Type")
						if type == "Wave" then
							addgap = math.sin(config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Speed") * tick()) * config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Amplitude")
						else
							addgap = lastgap + config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Speed") * DeltaTime
							if addgap > config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Max") then
								addgap = addgap - config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Max")
								addgap = addgap + config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Min")
							end
							lastgap = addgap
						end
					end]]
					
					gap = gap + addgap
					
					if setup.Top then
						local part = crosshair_objects.top
						local part_outline = crosshair_objects.top_outline
						local gapx = 0 * cs - (-gap) * sn;
						local gapy = 0 * sn + (-gap) * cs;
						local heightx = 0 * cs - (-height) * sn;
						local heighty = 0 * sn + (-height) * cs;
					
						if positionoverride then
							part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
						else
							part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
						end
						part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
						local outlinex = 0 * cs - (-1) * sn;
						local outliney = 0 * sn + (-1) * cs;
						part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
						part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
						
						--part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot
					elseif crosshair_objects.top_outline.Visible then
						crosshair_objects.top.Visible = false
						crosshair_objects.top_outline.Visible = false
					end
					
					if setup.Bottom then
						local part = crosshair_objects.bottom
						local part_outline = crosshair_objects.bottom_outline
						local gapx = 0 * cs - (gap) * sn;
						local gapy = 0 * sn + (gap) * cs;
						local heightx = 0 * cs - (height) * sn;
						local heighty = 0 * sn + (height) * cs;
					
						if positionoverride then
							part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
						else
							part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
						end
						part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
						local outlinex = 0 * cs - (1) * sn;
						local outliney = 0 * sn + (1) * cs;
						part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
						part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
						
						--part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot - 180
					elseif crosshair_objects.bottom_outline.Visible then
						crosshair_objects.bottom.Visible = false
						crosshair_objects.bottom_outline.Visible = false
					end
					
					if setup.Left then
						local part = crosshair_objects.left
						local part_outline = crosshair_objects.left_outline
						local gapx = (-gap) * cs - 0 * sn;
						local gapy = (-gap) * sn + 0 * cs;
						local heightx = (-height) * cs - 0 * sn;
						local heighty = (-height) * sn + 0 * cs;
					
						if positionoverride then
							part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
						else
							part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
						end
						part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
						local outlinex = (-1) * cs - 0 * sn;
						local outliney = (-1) * sn + 0 * cs;
						part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
						part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
						
						--part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot - 90
					elseif crosshair_objects.left_outline.Visible then
						crosshair_objects.left.Visible = false
						crosshair_objects.left_outline.Visible = false
					end
					
					if setup.Right then
						local part = crosshair_objects.right
						local part_outline = crosshair_objects.right_outline
						local gapx = (gap) * cs - 0 * sn;
						local gapy = (gap) * sn + 0 * cs;
						local heightx = (height) * cs - 0 * sn;
						local heighty = (height) * sn + 0 * cs;
					
						if positionoverride then
							part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
						else
							part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
						end
						part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
						local outlinex = (1) * cs - 0 * sn;
						local outliney = (1) * sn + 0 * cs;
						part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
						part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
						
						--part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot + 90
					elseif crosshair_objects.right_outline.Visible then
						crosshair_objects.right.Visible = false
						crosshair_objects.right_outline.Visible = false
					end
				end
			end

			local t = 0
			hook:Add("RenderStepped", "BBOT:Aimbot.CrosshairStep", function(DeltaTime)
				if gamelogic.currentgun and gamelogic.currentgun.data and gamelogic.currentgun.data.bulletspeed then return end
				t = tick()
				aimbot:CrosshairStep(DeltaTime)
			end)

			-- Do aimbot stuff here
			hook:Add("PreFireStep", "BBOT:Aimbot.Calculate", function(gun)
				if config:GetValue("Main", "Rage", "Aimbot", "Rage Bot") then
					aimbot:RageStep(gun)
				else
					aimbot:LegitStep(gun)
				end
			end)

			-- If the aimbot stuff before is persistant, use this to restore
			hook:Add("PostFireStep", "BBOT:Aimbot.Calculate", function(gun)
				if aimbot.silent and aimbot.silent.Parent then
					if aimbot.silent_data then
						aimbot.silent.Position = aimbot.silent_data[1]
						aimbot.silent.Orientation = aimbot.silent_data[2]
					else
						aimbot.silent.Orientation = aimbot.silent.Parent.Trigger.Orientation
					end
					aimbot.silent_data = false
					aimbot.silent = false
				end

				if aimbot.fire then
					if gun.getfiremode then
						local mode, rate = gun:getfiremode()
						if mode == true and not hook:IsMouse1Down() then
							gun:shoot(false)
						end
					else
						gun:shoot(false)
					end
					aimbot.fire = nil
				end

				aimbot:CrosshairStep(tick()-t, gun)
				t = tick()
			end)

			-- Knife Aura --
			function aimbot:kniferaycast(campos,diff,playerteamdata)
				return self:raycastbullet(campos,diff,playerteamdata,function(p1)
					local instance = p1.Instance
					if instance.Name == "Window" then return true end
					return not instance.CanCollide or instance.Transparency == 1
				end)
			end
			
			function aimbot:GetKnifeTarget()
				local mousePos = Vector3.new(mouse.x, mouse.y - 36, 0)
				local cam_position = camera.CFrame.p
				local team = (localplayer.Team and localplayer.Team.Name or "NA")
				local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]
				local aura_type = config:GetValue("Main", "Rage", "Extra", "Knife Bot Type")
				local hitscan_points = config:GetValue("Main", "Rage", "Extra", "Knife Hitscan")
				local visible_only = config:GetValue("Main", "Rage", "Extra", "Knife Visible Only")
				local range = config:GetValue("Main", "Rage", "Extra", "Knife Range")
				local priority_only = self:GetRageConfig("Settings", "Priority Only")
			
				local organizedPlayers = {}
				local plys = players:GetPlayers()
				local isteleport
				for i=1, #plys do
					local v = plys[i]
					if v == localplayer then
						continue
					end

					local parts = self:GetParts(v)
					if not parts then continue end
				
					if v.Team and v.Team == localplayer.Team then
						continue
					end

					local priority, reason = config:GetPriority(v)
					if priority_only and priority <= 0 then continue end

					local updater = replication.getupdater(v)

					if not updater.alive or not updater.receivedPosition then continue end

					local pos = updater.receivedPosition
					if (pos-cam_position).Magnitude > range then
						continue
					end

					if visible_only then
						local raydata = self:kniferaycast(cam_position,pos-cam_position,playerteamdata)
						if (not raydata or not raydata.Instance:IsDescendantOf(parts.head.Parent)) and (raydata and raydata.Position ~= pos) then continue end
					end
			
					for name, part in pairs(parts) do
						local name = partstosimple[name]
						if not name or hitscan_points ~= name then continue end
						table.insert(organizedPlayers, {v, part, name, pos})
					end
				end

				return organizedPlayers
			end

			local nextstab, block_equip = tick(), false
			hook:Add("RenderStepped", "KnifeAura", function()
				if not char.alive or not config:GetValue("Main", "Rage", "Extra", "Knife Bot") or not config:GetValue("Main", "Rage", "Extra", "Knife Bot", "KeyBind") then return end
				local target = aimbot:GetKnifeTarget()
				if not target or not target[1] then return end
				if nextstab > tick() then return end
				block_equip = true
				local lastequipped = aimbot.equipped
				if lastequipped ~= 3 then
					network:send("equip", 3);
				end
				network:send("stab");
				for i=1, #target do
					local v = target[i]
					network:send("knifehit", v[1], tick(), v[2].Name)
				end
				if lastequipped ~= 3 then
					network:send("equip", lastequipped);
				end
				block_equip = false
				nextstab = tick() + config:GetValue("Main", "Rage", "Extra", "Knife Delay")
			end)
			
			aimbot.equipped = 1
			hook:Add("PostNetworkSend", "Aimbot.Equipped", function(netname, slot)
				if netname ~= "equip" or block_equip then return end
				aimbot.equipped = slot
			end)
		end

		-- ESP
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
			local draw = BBOT.draw
			local log = BBOT.log
			local spectator = BBOT.spectator
			local math = BBOT.math
			local string = BBOT.string
			local service = BBOT.service
			local loop = BBOT.loop
			local esp = {
				registry = {}
			}
			BBOT.esp = esp

			local localplayer = service:GetService("LocalPlayer")
			local playergui = service:GetService("PlayerGui")
			local camera = BBOT.service:GetService("CurrentCamera")

			esp.container = Instance.new("Folder")
			esp.container.Name = string.random(8, 14) -- you gonna try that GetChildren attack anytime soon?
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
				local c = 0
				for i=1, #reg do
					if reg[i-c].uniqueid == uniqueid then
						local v = reg[i-c]
						table.remove(reg, i-c)
						c=c+1
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
				timer:Create("BBOT:ESP.Rebuild", 0.05, 1, function() self:_Rebuild() end)
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

			function esp.GetBoundingBox(parts)

			end

			local errors = 0
			local runservice = BBOT.service:GetService("RunService")
			loop:Run("BBOT:ESP.Render", function()
				if errors > 20 then return end
				local controllers = esp.registry
				local istablemissalined = false
				local c = 0
				for i=1, #controllers do
					local v = controllers[i-c]
					if v then
						local ran, destroy = xpcall(esp.Render, debug.traceback, v)
						if not ran then
							log(LOG_ERROR, "ESP render error - ", destroy)
							log(LOG_ANON, "Object - ", v.uniqueid)
							log(LOG_WARN,"Auto removing to prevent error cascade!")
							table.remove(controllers, i-c)
							c = c + 1
							errors = errors + 1
							if (BBOT.notification) then
								BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in ESP library.\nPlease check Synapse console!", 30):SetType("error")
							end
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
			end, runservice.RenderStepped)

			hook:Add("OnConfigChanged", "BBOT:ESP.Reload", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Visuals") then
					esp:Rebuild()
				end
			end)

			hook:Add("Spectator.Spectate", "BBOT:ESP.Reload", function()
				esp:Rebuild()
			end)

			font:Create("ESP.Global", font:GetDefault(), 16)

			hook:Add("OnConfigChanged", "BBOT:ESP.Global.Font", function(steps, old, new)
				if config:IsPathwayEqual(steps, "Main", "Visuals", "ESP Settings", "ESP Text Font") then
					font:ChangeFont("ESP.Global", new)
				elseif config:IsPathwayEqual(steps, "Main", "Visuals", "ESP Settings", "ESP Text Size") then
					font:ChangeSize("ESP.Global", new)
				end
			end)

			-- players
			do
				local workspace = BBOT.service:GetService("Workspace")
				local players = BBOT.service:GetService("Players")
				local replication = BBOT.aux.replication
				local hud = BBOT.aux.hud
				local aimbot = BBOT.aimbot
				local color = BBOT.color
				local vector = BBOT.vector
				local camera_aux = BBOT.aux.camera
				local updater = replication.getupdater
				local player_registry = replication.player_registry

				esp.playercontainer = Instance.new("Folder", esp.container)
				esp.playercontainer.Name = "Players"

				do
					local player_meta = {}
					esp.player_meta = {__index = player_meta}

					function player_meta:IsValid()
						return self.player:IsDescendantOf(players)
					end

					function player_meta:OnRemove()
						self:Destroy(true, true)
						self.removed = true
						log(LOG_DEBUG, "Player ESP: Removing ", self.player.Name)
					end

					function player_meta:CanRender()
						local alive = hud:isplayeralive(self.player)

						if alive ~= self.alive then
							self.alive = alive
							if self.alive then
								self:Setup()
							else
								self:Destroy()
							end
						end
						
						self:KillRender()

						if self.alive then
							return true
						else
							return false
						end
					end

					function player_meta:Cache(object)
						for i=1, #self.draw_cache do
							if self.draw_cache[i][1] == object then
								self.draw_cache[i][2] = object.Opacity
								self.draw_cache[i][3] = object.OutlineOpacity
								return object
							end
						end
						self.draw_cache[#self.draw_cache+1] = {object, object.Opacity, object.OutlineOpacity}
						return object
					end

					local whitelisted_parts = {
						["head"] = true,
						["torso"] = false,
						["larm"] = false,
						["rarm"] = false,
						["lleg"] = true,
						["rleg"] = true,
					}

					local visible_only_parts = {
						"head",
						--"torso",
						--"larm",
						--"rarm",
						"lleg",
						"rleg"
					}

					-- for outofview stuff
					local size = math.floor(camera.ViewportSize.x * 0.0078125)
					local big_size = math.floor(camera.ViewportSize.x * 0.0260416666667)

					hook:Add("Camera.ViewportChanged", "BBOT:ESP.Players.OutofView", function(newport)
						size = math.floor(newport.x * 0.0078125)
						big_size = math.floor(newport.x * 0.0240416666667)
					end)

					local dot = Vector3.new().Dot
					function player_meta:Render(points)
						if not self.parts and not points then return end

						local flags = self:GetConfig("Flags")
						local visible_only = flags["Visible Only"]

						local points = points
						if not points then
							points = {}
							self._points = points
							local offset, absolute = Vector3.new(), false
							if flags.Resolved then
								if self.player == localplayer and self.controller.receivedPosition then
									offset, absolute = self.controller.receivedPosition, true
								else
									offset, absolute = BBOT.aimbot:GetResolvedPosition(self.player)
								end
							end
							self.offset = offset
							self.absolute = absolute
	
							local torso_cf = self.parts.torso.CFrame
							local points_i = #points -- i did not know that # was a metamethod for a long time and that code snippet below taught me that, thank you cream
							
							for i = 1, 7 do -- 7 for accuracy also i just wanna be able to find this code with ctrl f lmao
								-- we need to get a circle of points around the player basically and then it will be nice and static
								local angle = (i - 1) * (math.pi * 2 / 7) -- there really should be a tau constant somewhere mayb?
								local offset_v3 = Vector3.new(math.cos(angle), 0, math.sin(angle)) * 2
								
								if absolute then
									points[points_i + i] = (CFrame.new(Vector3.new(), torso_cf.LookVector) * offset_v3) + offset
								else
									points[points_i + i] = (torso_cf * offset_v3) + offset
								end
	
							end
							points_i = #points
							
							if absolute then
								points[points_i] = (offset + torso_cf.UpVector * 2.8) -- above head
								points[points_i+1] = (offset - torso_cf.UpVector * 3.5) -- below legs and shit
							else
								points[points_i] = (torso_cf.Position + torso_cf.UpVector * 2.8) + offset -- above head
								points[points_i+1] = (torso_cf.Position - torso_cf.UpVector * 3.5) + offset -- below legs and shit
							end
						end

						-- L, W, H
						--[[local points2d = worldtoscreen(points)

						local fail = 0
						for i=1, #points2d do
							local v = points2d[i]
							if v.Z <= 0 then
								fail = fail + 1
							end
						end]]

						local fail = 0
						local points2d = {}
						for i=1, #points do
							local point, onscreen = camera:WorldToViewportPoint(points[i])
							if not onscreen then
								fail = fail + 1
							end
							points2d[#points2d+1] = point
						end

						if fail >= #points then
							fail = true
						else
							fail = false
						end

						if visible_only and self.alive then
							local visible = false
							for i=1, #visible_only_parts do
								local part_name = visible_only_parts[i]
								local part = self.parts[part_name]
								if not part then continue end
								if not BBOT.aimbot:raycastbullet(camera.CFrame.p, part.CFrame.p-camera.CFrame.p) then
									visible = true
									break
								end
							end
							if self.visible ~= visible then
								self.visible = visible
								self.visible_time = tick()
							end

							local fraction = math.timefraction(self.visible_time, self.visible_time+.1, tick())
							if not self.visible then
								fraction = math.remap(fraction, 0, 1, 1, 0)
							end

							for i=1, #self.draw_cache do
								local v = self.draw_cache[i]
								if v[1].Visible then
									v[1].Opacity = v[2]*fraction
									v[1].OutlineOpacity = v[3]*fraction
								end
							end

							if fraction <= 0 then
								return
							end
						end

						local bounding_box = {x=0,y=0,w=0,h=0}
						if not fail then
							local left = points2d[1].X
							local top = points2d[1].Y
							local right = points2d[1].X
							local bottom = points2d[1].Y
							
							for i=1,#points2d do
								if(points2d[i]) then
									if (left > points2d[i].X) then
										left = points2d[i].X
									end
									if (bottom < points2d[i].Y) then
										bottom = points2d[i].Y
									end
									if (right < points2d[i].X) then
										right = points2d[i].X
									end
									if (top > points2d[i].Y) then
										top = points2d[i].Y
									end
								end
							end

							bounding_box.x = math.floor(left)
							bounding_box.y = math.floor(top)
							bounding_box.w = math.floor(right - left)
							bounding_box.h = math.floor(bottom - top)
						end

						local vectest, vectest2 = Vector2.new(bounding_box.x, bounding_box.y), Vector2.new(bounding_box.w, bounding_box.h)
						if vectest ~= vectest or vectest2 ~= vectest2 then
							return
						end

						local lefty, righty = 0, 0

						if self.box and self.box_enabled then
							if fail then
								self.box_fill.Visible = false
								self.box_outline.Visible = false
								self.box.Visible = false
							else
								self.box_fill.Visible = true
								self.box_outline.Visible = true
								self.box.Visible = true

								local pos, size = Vector2.new(bounding_box.x, bounding_box.y), Vector2.new(bounding_box.w, bounding_box.h)

								self.box_fill.Offset = pos
								self.box_fill.Size = size
								self.box_outline.Offset = pos
								self.box_outline.Size = size
								self.box.Offset = pos
								self.box.Size = size
							end
						end

						if self.name and self.name_enabled then
							if fail then
								self.name.Visible = false
							else
								self.name.Visible = true
								self.name.Offset = Vector2.new(bounding_box.x + (bounding_box.w/2) - (self.name.TextBounds.X/2), bounding_box.y - self.name.TextBounds.Y)
							end
						end

						local health = math.ceil(hud:getplayerhealth(self.player))
						self.health_lerp = math.lerp(BBOT.renderstepped_rate * 5, self.health_lerp, health)
						if self.healthbar and self.healthbar_enabled then
							if fail then
								self.healthbar.Visible = false
								self.healthbar_outline.Visible = false
							else
								self.healthbar.Visible = true
								self.healthbar_outline.Visible = true
								self.healthbar.Color = color.range(self.health_lerp, {
									[1] = {
										start = 0,
										color = self:GetConfig("Health Bar", "Color Low"),
									},
									[2] = {
										start = 100,
										color = self:GetConfig("Health Bar", "Color Max"),
									},
								})
								self.healthbar.Offset = Vector2.new(bounding_box.x - 6, bounding_box.y + (bounding_box.h * math.clamp(1-(self.health_lerp/100), 0, 1))+1)
								self.healthbar.Size = Vector2.new(2, bounding_box.h * math.clamp(self.health_lerp/100, 0, 1)-2)
								self.healthbar_outline.Offset = Vector2.new(bounding_box.x - 6 - 1, bounding_box.y)
								self.healthbar_outline.Size = Vector2.new(2+2, bounding_box.h)
							end
						end

						if self.healthtext and self.healthtext_enabled then
							if fail then
								self.healthtext.Visible = false
							else
								if math.round(self.health_lerp) >= 100 then
									self.healthtext.Visible = false
								else
									self.healthtext.Visible = true
									local offsety = (self.healthbar_enabled and (bounding_box.h * math.remap(math.clamp(self.health_lerp/100, 0, 1),0,1,1,0)) or lefty)
									self.healthtext.Text = (self.healthbar_enabled and tostring(math.round(self.health_lerp)) or tostring(math.round(self.health_lerp)) .. "hp")
									self.healthtext.Offset = Vector2.new(bounding_box.x - self.healthtext.TextBounds.X - (self.healthbar_enabled and 8 or 1), bounding_box.y + offsety - (self.healthbar_enabled and self.healthtext.TextBounds.Y/2 or 0))
									lefty = lefty + self.healthtext.TextBounds.Y + 2
								end
							end
						end

						if self.distance and self.distance_enabled then
							if fail then
								self.distance.Visible = false
							else
								self.distance.Visible = true
								local pos = self.controller.receivedPosition or self.controller.gethead().Position
								self.distance.Text = math.round((pos-camera.CFrame.p).Magnitude/5) .. "m"
								self.distance.Offset = Vector2.new(bounding_box.x + bounding_box.w + 2, bounding_box.y + righty)
								righty = righty + self.distance.TextBounds.Y + 2
							end
						end

						if self.frozen and self.frozen_enabled then
							local on = self.controller.__t_received and self.controller.__t_received + (BBOT.extras:getLatency()*2)+.25 < tick()
							if fail or not on then
								self.frozen.Visible = false
							else
								self.frozen.Visible = true
								self.frozen.Offset = Vector2.new(bounding_box.x + bounding_box.w + 2, bounding_box.y + righty)
								righty = righty + self.frozen.TextBounds.Y + 2
							end
						end

						if self.resolved and self.resolved_enabled then
							if fail or not self.offset then
								self.resolved.Visible = false
								self.resolved_background.Visible = false
							else
								local pos
								if self.absolute then
									pos = camera:WorldToViewportPoint(self.offset)
								elseif self.controller.getpos() then
									pos = camera:WorldToViewportPoint(self.controller.getpos() + self.offset)
								end
								if pos then
									self.resolved.Visible = true
									self.resolved_background.Visible = true
									
									local x, y = pos.X, pos.Y
									if x >= math.huge or x <= -math.huge or y >= math.huge or y <= -math.huge then
										x = 0
										y = 0
									end

									if Vector2.new(x, y) ~= Vector2.new(x, y) then
										x = 0
										y = 0
									end

									self.resolved.Offset = Vector2.new(x, y)
									self.resolved_background.Offset = Vector2.new(x, y)
								else
									self.resolved.Visible = false
									self.resolved_background.Visible = false
								end
							end
						end

						if self.outofview and self.outofview_enabled then
							local soundsteps = self:GetConfig("Sound Arrows")
							local arrow_dist = self:GetConfig("Arrow Distance")
							if fail and self.controller.receivedPosition and arrow_dist then
								self.outofview.Visible = true
								self.outofview_outline.Visible = true
								local position = self.controller.receivedPosition
								if soundsteps then
									if self.footstep_time and self.weaponstep_time then
										if self.footstep_time > self.weaponstep_time then
											position = self.footstep_position
										else
											position = self.weaponstep_position
										end
									elseif self.footstep_time then
										position = self.footstep_position
									elseif self.weaponstep_time then
										position = self.weaponstep_position
									end
								end
								if position then
									local relativePos = camera.CFrame:PointToObjectSpace(position)
									local angle = math.atan2(-relativePos.Y, relativePos.X)

									local distance = dot(relativePos.Unit, relativePos)
									local arrow_size = self:GetConfig("Dynamic Arrow Size") and math.remap(distance, 1, 100, big_size, size) or size
									arrow_size = arrow_size > big_size and big_size or arrow_size < size and size or arrow_size

									local direction = Vector2.new(math.cos(angle), math.sin(angle))
									local SCREEN_SIZE = camera.ViewportSize
									local pos
									if arrow_dist ~= 101 then
										pos = (direction * SCREEN_SIZE.X * arrow_dist / 200) + (SCREEN_SIZE * 0.5)
									end
									if not pos or pos.Y > SCREEN_SIZE.Y - 5 or pos.Y < 5 then
										pos = camera:AngleToEdge(angle, 5)
									end

									self.outofview.Offset1 = pos
									self.outofview.Offset2 = pos - vector.rotate(direction, 0.5) * arrow_size
									self.outofview.Offset3 = pos - vector.rotate(direction, -0.5) * arrow_size

									self.outofview_outline.Offset1 = pos + direction * 2
									self.outofview_outline.Offset2 = pos - vector.rotate(direction, 0.52) * (arrow_size+2)
									self.outofview_outline.Offset3 = pos - vector.rotate(direction, -0.52) * (arrow_size+2)

									if soundsteps then
										local mul_opacity = 0
										if self.footstep_time then
											mul_opacity = (1-math.clamp(math.timefraction(self.footstep_time, self.footstep_time+.25, tick()), 0, 1))
											mul_opacity = mul_opacity * (1-math.clamp(self.footstep_distance/(128/1.25), 0, 1))
										end

										if self.weaponstep_time then
											local _mul_opacity = 0
											_mul_opacity = (1-math.clamp(math.timefraction(self.weaponstep_time, self.weaponstep_time+.3, tick()), 0, 1))
											_mul_opacity = _mul_opacity * (1-math.clamp(self.weaponstep_distance/(512/1.75), 0, 1)) * self.weaponstep_volume
											mul_opacity = mul_opacity + _mul_opacity
										end

										mul_opacity = math.clamp(mul_opacity, 0, 1)

										local color, color_transparency = self:GetConfig("Out of View", "Arrow Color")
										color_transparency = color_transparency or 0
										self.outofview.Opacity = color_transparency * mul_opacity
										self.outofview.OutlineOpacity = color_transparency * mul_opacity
										self:Cache(self.outofview)
				
										color, color_transparency = self:GetConfig("Out of View", "Outline Color")
										color_transparency = color_transparency or 0
										self.outofview_outline.Opacity = color_transparency * mul_opacity
										self.outofview_outline.OutlineOpacity = color_transparency * mul_opacity
										self:Cache(self.outofview_outline)
									end
								end
							else
								self.outofview.Visible = false
								self.outofview_outline.Visible = false
							end
						end

						if self.sounddot and self.sounddot_enabled then
							if self.controller.receivedPosition and (self.footstep_time or self.weaponstep_time) then
								self.sounddot.Visible = true
								local mul_opacity = 0
								if self.footstep_time then
									mul_opacity = (1-math.clamp(math.timefraction(self.footstep_time, self.footstep_time+.25, tick()), 0, 1))
									mul_opacity = mul_opacity * (1-math.clamp(self.footstep_distance/(128/1.25), 0, 1))
								end

								if self.weaponstep_time then
									local _mul_opacity = 0
									_mul_opacity = (1-math.clamp(math.timefraction(self.weaponstep_time, self.weaponstep_time+.3, tick()), 0, 1))
									_mul_opacity = _mul_opacity * (1-math.clamp(self.weaponstep_distance/(512/1.75), 0, 1)) * self.weaponstep_volume
									mul_opacity = mul_opacity + _mul_opacity
								end

								mul_opacity = math.clamp(mul_opacity, 0, 1)

								local position = self.controller.receivedPosition
								if self.footstep_time and self.weaponstep_time then
									if self.footstep_time > self.weaponstep_time then
										position = self.footstep_position
									else
										position = self.weaponstep_position
									end
								elseif self.footstep_time then
									position = self.footstep_position
								elseif self.weaponstep_time then
									position = self.weaponstep_position
								end

								if position then
									local dist = (position - camera.CFrame.p).Magnitude
									self.sounddot.Radius = math.clamp(math.remap(dist, 256, 0, 4, 10), 3, 12)
									self.sounddot.Point = position
								end

								local color, color_transparency = self:GetConfig("Sound Dots", "Dot Color")
								color_transparency = color_transparency or 0
								self.sounddot.Opacity = color_transparency * mul_opacity
								local color, color_transparency = self:GetConfig("Sound Dots", "Outline Color")
								color_transparency = color_transparency or 0
								self.sounddot.OutlineOpacity = color_transparency * mul_opacity
								self:Cache(self.sounddot)
							else
								self.sounddot.Visible = false
							end
						end
					end

					hook:Add("SuppressSound", "BBOT:ESP.Players.soundsteps", function(name, soundgroup, volume, pitch, pitchmin, pitchmax, part, max_distance, emitter_size, rolloffmode, playonremove, loop)
						if not part then return end
						local iswalk, isrun = string.find(name, "walk"), string.find(name, "run")
						if not iswalk and not isrun then return end
						for i, player in next, players:GetPlayers() do
							if player == localplayer then continue end
							local parts = replication.getbodyparts(player)
							if not parts then continue end
							local found = false
							for k, v in next, parts do
								if v == part then
									found = true
									break
								end
							end
							if found then
								local object = esp:Find("PLAYER_" .. player.UserId)
								if object and object.alive and object.parts and object.parts.torso and (object.parts.torso.CFrame.p - camera.CFrame.p).Magnitude < 128 then
									object.footstep_time = tick()
									object.footstep_volume = volume
									object.footstep_distance = (object.parts.torso.CFrame.p - camera.CFrame.p).Magnitude
									object.footstep_position = object.parts.torso.CFrame.p
								end
								break
							end
						end
					end)

					hook:Add("PreNewBullets", "BBOT:ESP.Players.WeaponSounds", function(data)
						if not data.player or spectator:IsSpectating() == data.player then return end
						local updater = replication.getupdater(data.player)
						if not updater or not updater.alive then return end
						local object = esp:Find("PLAYER_" .. data.player.UserId)
						if object and object.alive and object.parts and object.parts.torso then
							object.weaponstep_time = tick()
							object.weaponstep_volume = data.volume
							object.weaponstep_distance = (object.parts.torso.CFrame.p - camera.CFrame.p).Magnitude
							object.weaponstep_position = object.parts.torso.CFrame.p
						end
					end)

					function player_meta:GetConfig(...)
						local lp = localplayer
						local spectating = spectator:IsSpectating()
						if spectating then
							lp = spectating
						end
						if self.player == localplayer then
							return config:GetValue("Main", "Visuals", "Local", ...)
						elseif self.player and self.player.Team ~= lp.team then
							return config:GetValue("Main", "Visuals", "Enemy ESP", ...)
						else
							return config:GetValue("Main", "Visuals", "Team ESP", ...)
						end
					end

					-- draw:TextOutlined(text, font, x, y, size, centered, color, color2, transparency, visible)
					-- draw:BoxOutline(x, y, w, h, thickness, color, transparency, visible)
					local black = Color3.new(0,0,0)
					function player_meta:OnCreate()
						local color, color_transparency = self:GetConfig("Name", "Color")
						local name = draw:Create("Text", "2V")
						name.Color = color
						name.Text = self.player.name
						name.Outlined = true
						name.OutlineColor = Color3.fromRGB(0,0,0)
						name.OutlineThickness = 2
						name.Opacity = color_transparency
						name.OutlineOpacity = color_transparency
						name.XAlignment = XAlignment.Right
						name.YAlignment = YAlignment.Bottom
						font:AddToManager(name, "ESP.Global")
						self.name = self:Cache(name)

						color, color_transparency = self:GetConfig("Box", "Color Fill")

						local box_fill = draw:Create("Rect", "2V")
						box_fill.Color = color
						box_fill.Filled = true
						box_fill.Opacity = color_transparency
						box_fill.XAlignment = XAlignment.Right
						box_fill.YAlignment = YAlignment.Bottom
						self.box_fill = self:Cache(box_fill)

						color, color_transparency = self:GetConfig("Box", "Color Outline")
						local box_outline = draw:Clone(box_fill)
						box_outline.Color = color
						box_outline.Filled = false
						box_outline.Opacity = color_transparency
						box_outline.Thickness = 3
						self.box_outline = self:Cache(box_outline)

						color, color_transparency = self:GetConfig("Box", "Color Box")
						local box = draw:Clone(box_outline)
						box.Color = color
						box.Opacity = color_transparency
						box.Thickness = 1
						self.box = self:Cache(box)
						
						color, color_transparency = self:GetConfig("Health Bar", "Color Max")

						local healthbar_outline = draw:Clone(box_fill)
						healthbar_outline.Color = Color3.new(0,0,0)
						healthbar_outline.Opacity = color_transparency
						self.healthbar_outline = self:Cache(healthbar_outline)

						local healthbar = draw:Clone(healthbar_outline)
						healthbar.Color = color
						healthbar.Opacity = color_transparency
						self.healthbar = self:Cache(healthbar)
						
						color, color_transparency = self:GetConfig("Health Number", "Color")
						local healthtext = draw:Clone(name)
						healthtext.Color = color
						healthtext.Opacity = color_transparency
						healthtext.Text = "100"
						healthtext.OutlineOpacity = color_transparency
						font:AddToManager(healthtext, "ESP.Global")
						self.healthtext = self:Cache(healthtext)

						local distance = draw:Clone(name)
						distance.Color = color
						distance.Opacity = color_transparency
						distance.Text = "0 studs"
						distance.OutlineOpacity = color_transparency
						font:AddToManager(distance, "ESP.Global")
						self.distance = self:Cache(distance)

						local frozen = draw:Clone(name)
						frozen.Color = color
						frozen.Opacity = color_transparency
						frozen.Text = "FROZEN"
						frozen.OutlineOpacity = color_transparency
						font:AddToManager(frozen, "ESP.Global")
						self.frozen = self:Cache(frozen)

						local resolved_background = draw:Create("Circle", "2V")
						resolved_background.Radius = 4
						resolved_background.NumSides = 10
						resolved_background.Filled = true
						resolved_background.Color = Color3.new(0,0,0)
						self.resolved_background = self:Cache(resolved_background)

						local resolved = draw:Clone(resolved_background)
						resolved.Radius = 3
						self.resolved = self:Cache(resolved)

						color, color_transparency = self:GetConfig("Out of View", "Outline Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						local outofview_outline = draw:Create("PolyLine", "2V", "2V", "2V")
						outofview_outline.Color = color
						outofview_outline.Opacity = color_transparency
						outofview_outline.OutlineOpacity = color_transparency
						outofview_outline.FillType = PolyLineFillType.ConvexFilled
						self.outofview_outline = self:Cache(outofview_outline)

						color, color_transparency = self:GetConfig("Out of View", "Arrow Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						local outofview = draw:Create("PolyLine", "2V", "2V", "2V")
						outofview.Color = color
						outofview.Opacity = color_transparency
						outofview.OutlineOpacity = color_transparency
						outofview.FillType = PolyLineFillType.ConvexFilled
						self.outofview = self:Cache(outofview)

						local sounddot = draw:Create("Circle", "3D")
						sounddot.Radius = 4
						sounddot.NumSides = 10
						sounddot.Filled = true
						sounddot.Color = Color3.new(0,0,0)
						sounddot.Outlined = true
						sounddot.OutlineThickness = 1
						self.sounddot = self:Cache(sounddot)
					end

					function player_meta:GetColor(...)
						local color, color_transparency = self:GetConfig(...)
						local priority = config:GetPriority(self.player)
						if config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Target") and aimbot.rage_target and aimbot.rage_target[1] == self.player then
							color = config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Target", "Aimbot Target")
						elseif config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Friends") and priority and priority < 0 then
							color = config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Friends", "Friended Players")
						elseif config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Priority") and priority and priority > 0 then
							color = config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Priority", "Priority Players")
						end
						return color, color_transparency
					end

					function player_meta:Setup()
						self.begin_fading = false
						local parts = replication.getbodyparts(self.player)
						if not parts then return end

						local flags = self:GetConfig("Flags")
						self.model = parts.head.Parent
						self.parts = parts
						local esp_enabled = self:GetConfig("Enabled")
						local priority_level = config:GetPriority(self.player)
						if flags["Friends Only"] and flags["Priority Only"] then
							if priority_level == 0 then
								esp_enabled = false
							end
						elseif (flags["Friends Only"] and priority_level >= 0) then
							esp_enabled = false
						elseif (flags["Priority Only"] and priority_level <= 0) then
							esp_enabled = false
						end
						local spectating = spectator:IsSpectating()
						if spectating == self.player then
							esp_enabled = false
						elseif spectating and hud:isplayeralive(self.player) then
							esp_enabled = true
						end
						
						local color, color_transparency = self:GetColor("Name", "Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.name_enabled = (esp_enabled and self:GetConfig("Name") or false)
						self.name.Visible = self.name_enabled
						self.name.Color = color
						self.name.Opacity = color_transparency
						self.name.OutlineOpacity = color_transparency
						self:Cache(self.name)

						self.box_enabled = (esp_enabled and self:GetConfig("Box") or false)
						self.box_fill.Visible = self.box_enabled
						self.box_outline.Visible = self.box_enabled
						self.box.Visible = self.box_enabled

						color, color_transparency = self:GetColor("Box", "Color Fill")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.box_fill.Color = color
						self.box_fill.Opacity = color_transparency

						color, color_transparency = self:GetConfig("Box", "Color Outline")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.box_outline.Color = color
						self.box_outline.Opacity = color_transparency

						color, color_transparency = self:GetColor("Box", "Color Box")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.box.Color = color
						self.box.Opacity = color_transparency
						self.box_outline.Opacity = color_transparency
						self:Cache(self.box)
						self:Cache(self.box_outline)
						self:Cache(self.box_fill)
						
						color, color_transparency = self:GetConfig("Health Bar", "Color Max")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.healthbar_enabled = (esp_enabled and self:GetConfig("Health Bar") or false)
						self.healthbar.Color = color
						self.healthbar.Opacity = color_transparency
						self.healthbar_outline.Opacity = color_transparency
						self.healthbar.Visible = self.healthbar_enabled
						self.healthbar_outline.Visible = self.healthbar_enabled
						self.health_lerp = 100
						self:Cache(self.healthbar)
						self:Cache(self.healthbar_outline)
						
						color, color_transparency = self:GetConfig("Health Number", "Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.healthtext_enabled = (esp_enabled and self:GetConfig("Health Number") or false)
						self.healthtext.Visible = self.healthtext_enabled
						self.healthtext.Color = color
						self.healthtext.Opacity = color_transparency
						self.healthtext.OutlineOpacity = color_transparency
						self:Cache(self.healthtext)

						self.distance_enabled = (esp_enabled and flags.Distance or false)
						self.distance.Visible = self.distance_enabled
						self.distance.Color = color
						self.distance.Opacity = color_transparency
						self.distance.OutlineOpacity = color_transparency
						self:Cache(self.distance)

						self.frozen_enabled = (esp_enabled and flags.Frozen or false)
						self.frozen.Visible = self.frozen_enabled
						self.frozen.Color = color
						self.frozen.Opacity = color_transparency
						self.frozen.OutlineOpacity = color_transparency
						self:Cache(self.frozen)

						color, color_transparency = self:GetColor("Box", "Color Box")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.resolved_enabled = (esp_enabled and flags.Resolved or false)
						self.resolved.Visible = self.resolved_enabled
						self.resolved_background.Visible = self.resolved_enabled
						self.resolved.Color = color
						self.resolved.Opacity = color_transparency
						self.resolved.OutlineOpacity = color_transparency
						self:Cache(self.resolved)

						color, color_transparency = self:GetConfig("Out of View", "Arrow Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.outofview_enabled = self:GetConfig("Out of View")
						self.outofview.Visible = false
						self.outofview.Color = color
						self.outofview.Opacity = color_transparency
						self.outofview.OutlineOpacity = color_transparency
						self:Cache(self.outofview)

						color, color_transparency = self:GetConfig("Out of View", "Outline Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.outofview_outline.Visible = false
						self.outofview_outline.Color = color
						self.outofview_outline.Opacity = color_transparency
						self.outofview_outline.OutlineOpacity = color_transparency
						self:Cache(self.outofview_outline)

						self.sounddot_enabled = self:GetConfig("Sound Dots")
						color, color_transparency = self:GetConfig("Sound Dots", "Dot Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.sounddot.Visible = false
						self.sounddot.Color = color
						self.sounddot.Opacity = color_transparency
						color, color_transparency = self:GetConfig("Sound Dots", "Outline Color")
						color = color or Color3.new(1,1,1)
						color_transparency = color_transparency or 0
						self.sounddot.OutlineColor = color
						self.sounddot.OutlineOpacity = color_transparency
						self:Cache(self.sounddot)

						if flags["Visible Only"] then
							for i=1, #self.draw_cache do
								local v = self.draw_cache[i]
								if v[1].Visible then
									v[1].Opacity = v[2]
									v[1].OutlineOpacity = v[3]
								end
							end
						end

						if spectator:IsSpectating() == self.player then
							for i=1, #self.draw_cache do
								local v = self.draw_cache[i]
								if v[1].Visible then
									v[1].Visible = false
								end
							end
						end

						self:RemoveInstances()

						local container = Instance.new("Folder", esp.playercontainer)
						self.container = container
						container.Name = self.player.Name

						if self:GetConfig("Chams") then
							local visible, transparency = self:GetConfig("Chams", "Visible Chams")
							local invisible, itransparency = self:GetConfig("Chams", "Invisible Chams")
							local scale = 0.1
							local chams = {}
							self.chams = chams
							for k, v in pairs(parts) do
								if k ~= "rootpart" then
									local boxhandle
									if v.Name ~= "Head" then
										boxhandle = Instance.new("BoxHandleAdornment", Part)
										chams[#chams+1] = {k, boxhandle, itransparency}
										boxhandle.Size = (v.Size + Vector3.new(0.1, 0.1, 0.1))
									else
										boxhandle = Instance.new("CylinderHandleAdornment", Part)
										chams[#chams+1] = {k, boxhandle, itransparency}
										boxhandle.Height = v.Size.y + 0.3
										boxhandle.Radius = v.Size.x * 0.5 + 0.2
										boxhandle.Height -= 0.2
										boxhandle.Radius -= 0.2
										boxhandle.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 1, 0))
									end
									boxhandle.Parent = container
									boxhandle.Name = "Chams_"..k
									boxhandle.Adornee = v
									boxhandle.AlwaysOnTop = true
									boxhandle.Color3 = invisible
									boxhandle.Transparency = 1-itransparency
									boxhandle.Visible = true
									boxhandle.ZIndex = 1
								end
							end
							scale = 0.25
							for k, v in pairs(parts) do
								if k ~= "rootpart" then
									local boxhandle
									if v.Name ~= "Head" then
										boxhandle = Instance.new("BoxHandleAdornment", Part)
										chams[#chams+1] = {k, boxhandle, transparency}
										boxhandle.Size = (v.Size + Vector3.new(0.25, 0.25, 0.25))
									else
										boxhandle = Instance.new("CylinderHandleAdornment", Part)
										chams[#chams+1] = {k, boxhandle, transparency}
										boxhandle.Height = v.Size.y + 0.3
										boxhandle.Radius = v.Size.x * 0.5 + 0.2
										boxhandle.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 1, 0))
									end
									boxhandle.Parent = container
									boxhandle.Name = "UChams_"..k
									boxhandle.Adornee = v
									boxhandle.AlwaysOnTop = false
									boxhandle.Color3 = visible
									boxhandle.Transparency = 1-transparency
									boxhandle.Visible = true
									boxhandle.ZIndex = 1
								end
							end
						end

						log(LOG_DEBUG, "Player ESP: Now Alive ", self.player.Name)
					end

					function player_meta:Rebuild()
						self:Destroy(true)
						if self.alive then
							self:Setup()
						end
					end

					function player_meta:RemoveInstances()
						if self.chams then
							for i=1, #self.chams do
								local v = self.chams[i]
								if v[2] then
									v[2]:Destroy()
								end
							end
							self.chams = nil
						end
						
						if self.container then
							self.container:Destroy()
							self.container = nil
						end
					end

					function player_meta:KillRender()
						if self.alive or not self.timedestroyed or not self.begin_fading then return end
						local fadetime = config:GetValue("Main", "Visuals", "ESP Settings", "ESP Fade Time")
						local fraction = math.timefraction(self.timedestroyed, self.timedestroyed+fadetime, tick())

						if fraction > 1 then
							for i=1, #self.draw_cache do
								local v = self.draw_cache[i]
								if v[1].Visible then
									v[1].Visible = false
								end
							end

							self:RemoveInstances()
						else
							self:Render(self._points)

							fraction = math.remap(fraction, 0, 1, 1, 0)
							for i=1, #self.draw_cache do
								local v = self.draw_cache[i]
								if v[1].Visible and v[1].Opacity > 0 then
									v[1].Opacity = v[2]*fraction
									v[1].OutlineOpacity = v[3]*fraction
								end
							end

							if self.chams then
								for i=1, #self.chams do
									local v = self.chams[i]
									if v[2] then
										v[2].Transparency = 1-(v[3]*fraction)
									end
								end
							end
						end
					end

					function player_meta:Destroy(forced, kill)
						self.timesdestroyed = self.timesdestroyed + 1
						self.timedestroyed = tick()
						self.fulldestroy = (forced or kill)
						self.begin_fading = not (forced or kill)

						for i=1, #self.draw_cache do
							local v = self.draw_cache[i][1]
							if draw:IsValid(v) then
								if kill then
									v:Remove()
								elseif forced then
									v.Visible = false
								end
							end
						end

						if forced or kill then
							self:RemoveInstances()
						end

						self.parts = nil
						log(LOG_DEBUG, "Player ESP: Died ", self.player.Name)
					end
				end

				local localplayer = service:GetService("LocalPlayer")
				function esp:CreatePlayer(player, controller)
					local uid = "PLAYER_" .. player.UserId
					local esp_controller = setmetatable({
						draw_cache = {},
						position_cache = {},
						uniqueid = uid,
						player = player,
						players = players,
						controller = controller,
						parent = workspace.Players,
						timesdestroyed = 0,
					}, self.player_meta)
					self:Remove(uid)
					self:Add(esp_controller)

					log(LOG_DEBUG, "Player ESP: Created ", player.Name)
					return esp_controller
				end

				local last = ""
				hook:Add("RageBot.Changed", "BBOT:ESP.Players.Targeted", function(target)
					if not config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Target") then return end
					local oldobject = esp:Find("PLAYER_" .. last)
					if oldobject then
						oldobject:Rebuild()
					end
					if target then
						local object = esp:Find("PLAYER_" .. target.UserId)
						last = target.UserId
						if object then
							object:Rebuild()
						end
					end
				end)

				hook:Add("OnPriorityChanged", "BBOT:ESP.Players.Changed", function(player, old_priority, priority)
					local object = esp:Find("PLAYER_" .. player.UserId)
					if object then
						object:Rebuild()
					end
				end)

				hook:Add("PostInitialize", "BBOT:ESP.Players.Load", function()
					timer:Create("esp.checkplayers", 5, 0, function()
						for player, controller in pairs(player_registry) do
							if controller.updater and player ~= localplayer and not esp:Find("PLAYER_" .. player.UserId) then
								esp:CreatePlayer(player, controller.updater)
							end
						end
					end)

					hook:Add("PlayerAdded", "BBOT:ESP.Players", function(player)
						timer:Create("BBOT:ESP.Players."..player.UserId, 1, 0, function()
							if not player_registry[player] or not player_registry[player].updater then return end
							timer:Remove("BBOT:ESP.Players."..player.UserId)
							esp:CreatePlayer(player, player_registry[player].updater)
						end)
					end)

					hook:Add("PlayerRemoving", "BBOT:ESP.Players", function(player)
						timer:Remove("BBOT:ESP.Players."..player.UserId)
					end)

					hook:Add("CreateUpdater", "BBOT:ESP.Players", function(player)
						if player_registry[player] and player_registry[player].updater then
							timer:Remove("BBOT:ESP.Players."..player.UserId)
							esp:CreatePlayer(player, player_registry[player].updater)
						end
					end)
				end)
			end

			-- weapon drop ESP
			do
				local icons = BBOT.icons
				local gamelogic = BBOT.aux.gamelogic
				local GunDataGetter = BBOT.aux.GunDataGetter
				do
					local drop_meta = {}
					esp.weapon_drop_meta = {__index = drop_meta}

					function drop_meta:IsValid()
						return self.object:IsDescendantOf(workspace.Ignore)
					end

					function drop_meta:CanRender()
						return true
					end

					function drop_meta:OnRemove()
						self:Destroy()
					end

					function drop_meta:Rebuild()
						self:Setup()
					end

					function drop_meta:Cache(object)
						for i=1, #self.draw_cache do
							if self.draw_cache[i][1] == object then
								self.draw_cache[i][2] = object.Opacity
								self.draw_cache[i][3] = object.OutlineOpacity
								return object
							end
						end
						self.draw_cache[#self.draw_cache+1] = {object, object.Opacity, object.OutlineOpacity}
						return object
					end

					local function getguninformation(name)	
						local filename = GunDataGetter.getGunModule(name)
						if not filename then
							return
						end
						return require(filename)
					end

					local vec2_0 = Vector2.new(0, 0)
					function drop_meta:Render()
						local object_position = self.object.Slot1.Position
						self.object_point.Point = object_position -- I love meta tables & inheritances
						local visible = self.object_point.Visible
						if gamelogic.currentgun ~= self.last_current then
							self.last_current = gamelogic.currentgun

							if self.ammo then
								local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo", "Weapon Ammo")
								if self.last_current and self.last_current.data then
									local gundata = self.last_current.data
									local dropdata = getguninformation(self.object_name)
									if dropdata and (gundata.ammotype == dropdata.ammotype or gundata.type == dropdata.type) then
										color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo", "Same Weapon Ammo")
									end
								end

								self.ammo.Color = color
								self.ammo.Opacity = color_transparency
								self.ammo.OutlineOpacity = color_transparency
								self.ammo = self:Cache(self.ammo)
							end
						end

						if self.name then
							-- not really much to do here lmao
						end

						if self.ammo then
							self.ammo.Text = tostring(self.object.Spare.Value)
						end

						if self.image then
							if self.name and self.name.Visible then
								self.image.Offset = Vector2.new(0, -self.name.TextBounds.Y)
							else
								self.image.Offset = vec2_0
							end
						end

						local fraction = math.clamp(math.remap((object_position-camera.CFrame.p).Magnitude, 30, 75, 1, 0), 0, 1)
						for i=1, #self.draw_cache do
							local v = self.draw_cache[i]
							if v[1].Visible then
								v[1].Opacity = v[2]*fraction
								v[1].OutlineOpacity = v[3]*fraction
							end
						end
					end

					function drop_meta:OnCreate()
						--[[config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Highlighted Weapons")
						config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Weapon Names")
						config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons")
						config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo")
						config:GetValue("Main", "Visuals", "Weapons", "Dropped Weapon Chams")]]

						self.object_name = "Unknown"
						if self.object:FindFirstChild("Gun") then
							self.object_name = self.object.Gun.Value
						elseif self.object:FindFirstChild("Knife") then
							self.object_name = self.object.Knife.Value
						end

						self.object_point = draw:CreatePoint("3D")

						local name = draw:Create("Text", "Offset")
						name.Text = self.object_name
						name.Outlined = true
						name.OutlineColor = Color3.fromRGB(0,0,0)
						name.OutlineThickness = 2
						name.XAlignment = XAlignment.Center
						name.YAlignment = YAlignment.Top
						font:AddToManager(name, "ESP.Global")

						if self.object:FindFirstChild("Spare") then
							local ammo = draw:Clone(name)
							ammo.Text = tostring(self.object.Spare.Value)
							ammo.YAlignment = YAlignment.Bottom
							font:AddToManager(ammo, "ESP.Global")
							ammo.point.Point = self.object_point.point
							self.ammo = self:Cache(ammo)
						end

						name.point.Point = self.object_point.point
						self.name = self:Cache(name)

						local imagedata = icons:NameToIcon(self.object_name)
						if imagedata then
							local image = draw:Create("Image", "Offset")
							image.Image = imagedata[1]
							image.Size = image.ImageSize * 1
							image.XAlignment = XAlignment.Center
							image.YAlignment = YAlignment.Top
							image.point.Point = self.object_point.point
							self.image = self:Cache(image)
						end
						self:Setup()
						self:Render()
					end

					function drop_meta:Setup()
						self.name.Visible = config:GetValue("Main", "Visuals", "Weapons", "Weapon Names")
						local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Weapon Names")
						self.name.Color = color
						self.name.Opacity = color_transparency
						self.name.OutlineOpacity = color_transparency
						self.name = self:Cache(self.name)
						
						if self.ammo then
							self.ammo.Visible = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo")
							local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo", "Weapon Ammo")
							self.ammo.Color = color
							self.ammo.Opacity = color_transparency
							self.ammo.OutlineOpacity = color_transparency
							self.ammo = self:Cache(self.ammo)
						end

						if self.image then
							self.image.Visible = config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons")
							local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons", "Weapon Icons")
							self.image.Color = color
							self.image.Opacity = color_transparency
							self.image.OutlineOpacity = color_transparency
							self.image = self:Cache(self.image)
						end
					end

					function drop_meta:Destroy()
						for i=1, #self.draw_cache do
							local v = self.draw_cache[i][1]
							if draw:IsValid(v) then
								v:Remove()
							end
						end
					end
				end

				function esp:CreateWeaponDrop(object)
					local uid = "WEAPONDROP_" .. object:GetDebugId()
					local esp_controller = setmetatable({
						draw_cache = {},
						uniqueid = uid,
						object = object,
					}, self.weapon_drop_meta)
					self:Remove(uid)
					self:Add(esp_controller)
					return esp_controller
				end

				hook:Add("PostInitialize", "BBOT:ESP.WeaponDrops", function()
					local dropguns = workspace.Ignore.GunDrop
					local children = dropguns:GetChildren()
					for i=1, #children do
						local drop = children[i]
						if drop:FindFirstChild("Slot1") and (drop:FindFirstChild("Gun") or drop:FindFirstChild("Knife")) then
							esp:CreateWeaponDrop(drop)
						end
					end

					hook:Add("RenderStepped", "BBOT:ESP.WeaponDrops.Find", function()
						local children = dropguns:GetChildren()
						for i=1, #children do
							local drop = children[i]
							if not esp:Find("WEAPONDROP_" .. drop:GetDebugId()) and drop:FindFirstChild("Slot1") and (drop:FindFirstChild("Gun") or drop:FindFirstChild("Knife")) then
								esp:CreateWeaponDrop(drop)
							end
						end
					end)
				end)
			end

			do
				local icons = BBOT.icons
				local color = BBOT.color
				local roundsystem = BBOT.aux.roundsystem
				local char = BBOT.aux.char
				local localplayer = service:GetService("LocalPlayer")
				do
					local grenade_meta = {}
					esp.grenade_meta = {__index = grenade_meta}
			
					--[[{
						curi = 1, 
						time = initiatetime, 
						blowuptime = delaytime - initiatetime, 
						frames = { {
								t0 = 0, 
								p0 = u195, 
								v0 = u193, 
								offset = Vector3.new(), 
								a = gravity, 
								rot0 = grenade_mainpart_cframe - grenade_mainpart_cframe.p,
								timedelta = 0,
								hit = false,
								hitnormal = Vector3.new(0,1,0),
								rotv = u197, 
								glassbreaks = {}
							} }
					};]]
			
					function grenade_meta:IsValid()
						return self.object:IsDescendantOf(workspace.Ignore.Misc)
					end
			
					function grenade_meta:CanRender()
						return true
					end
			
					function grenade_meta:OnRemove()
						self:Destroy()
					end
			
					function grenade_meta:Rebuild()
						self:Setup()
					end
			
					function grenade_meta:Cache(object)
						for i=1, #self.draw_cache do
							if self.draw_cache[i][1] == object then
								self.draw_cache[i][2] = object.Opacity
								self.draw_cache[i][3] = object.OutlineOpacity
								return object
							end
						end
						self.draw_cache[#self.draw_cache+1] = {object, object.Opacity, object.OutlineOpacity}
						return object
					end
			
					local col1 = Color3.fromRGB(20, 20, 20)
					local col2 = Color3.fromRGB(150, 20, 20)
					local col3 = Color3.fromRGB(50, 50, 50)
					local col4 = Color3.fromRGB(220, 20, 20)
					local camera = BBOT.service:GetService("CurrentCamera")
					local vec2_0 = Vector2.new(0, 0)
					function grenade_meta:Render()
						if not self.final_position or not config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning") then return end
						local position = self.final_position.p0
						local cam_position = camera.CFrame.p
						local point, onscreen = camera:WorldToViewportPoint(position)
						local screensize = camera.ViewportSize
						if not onscreen or point.x > screensize.x - 36 or point.y > screensize.y - 72 or point.y - 16 < 0 then
							local relativePos = camera.CFrame:PointToObjectSpace(position)
							local angle = math.atan2(-relativePos.y, relativePos.x)
							local ox = math.cos(angle)
							local oy = math.sin(angle)
							local slope = oy / ox
			
							local h_edge = screensize.x - 36
							local v_edge = screensize.y - 72
							if oy < 0 then
								v_edge = 36
							end
							if ox < 0 then
								h_edge = 36
							end
							local y = (slope * h_edge) + (screensize.y / 2) - slope * (screensize.x / 2)
							if y > 0 and y < screensize.y - 72 then
								point = Vector2.new(h_edge, y)
							else
								point = Vector2.new(
									(v_edge - screensize.y / 2 + slope * (screensize.x / 2)) / slope,
									v_edge
								)
							end
						end
						local nade_dist = (position - cam_position).Magnitude
			
						local textbounds = self.warning.TextBounds
						self.background.Offset = Vector2.new(math.floor(point.x), math.floor(point.y))
						self.icon.Offset = Vector2.new(math.floor(point.x), math.floor(point.y))
						self.warning.Offset = Vector2.new(math.floor(point.x), math.floor(point.y + 18))
			
						local d0 = 250 -- max damage
						local d1 = 15 -- min damage
						local r0 = 8 -- maximum range before the damage starts dropping off due to distance
						local r1 = 30 -- minimum range i think idk
						local damage = nade_dist < r0 and d0 or nade_dist < r1 and (d1 - d0) / (r1 - r0) * (nade_dist - r0) + d0 or 0
						local wall
						if damage > 0 then
							wall = workspace:FindPartOnRayWithWhitelist(
								Ray.new(cam_position, (position - cam_position)),
								roundsystem.raycastwhitelist
							)
							if wall then
								damage = 0
							end
						end
			
						local health = char:gethealth()
						local str = damage == 0 and "Safe" or damage >= health and "LETHAL" or string.format("-%d hp", damage)
						local nade_percent = math.clamp(math.timefraction(self.physics.time, self.physics.time + self.physics.blowuptime, tick()), 0, 1)
						self.warning.Text = str
			
						self.background.Color = color.range(damage, {
							[1] = { start = 15, color = col1 },
							[2] = { start = health, color = col2 },
						})
			
						self.background.OutlineColor = color.range(damage, {
							[1] = { start = 15, color = col3 },
							[2] = { start = health, color = col4 },
						})
			
						self.progress_container.Offset = Vector2.new(math.floor(point.x) - 16, math.floor(point.y + 18 + textbounds.Y + 2))
						self.progress_bar.Size = Vector2.new(30 * (1 - nade_percent), 4)
						self.progress_bar.Offset = Vector2.new(math.floor(point.x) - 15, math.floor(point.y + 18 + textbounds.Y + 3))
			
						local fraction = math.clamp(math.remap(nade_dist, 50, 70, 1, 0), 0, 1)
						for i=1, #self.draw_cache do
							local v = self.draw_cache[i]
							if v[1].Visible then
								v[1].Opacity = v[2]*fraction
								v[1].OutlineOpacity = v[3]*fraction
							end
						end
			
						if nade_percent == 1 then
							esp:Remove(self.uniqueid)
						end
					end
			
					function grenade_meta:OnCreate()
						if self.player ~= localplayer and self.player.Team == localplayer.Team then return end
						--[[config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Highlighted Weapons")
						config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Weapon Names")
						config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons")
						config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo")
						config:GetValue("Main", "Visuals", "Weapons", "Dropped Weapon Chams")]]
			
						self.final_position = self.physics.frames[#self.physics.frames]
			
						local background = draw:Create("Circle", "2V")
						background.Color = Color3.fromRGB(20, 20, 20)
						background.Radius = 15
						background.Filled = true
						background.NumSides = 20
						background.Outlined = true
						background.OutlineColor = Color3.fromRGB(50, 50, 50)
						background.OutlineThickness = 2
						background.XAlignment = XAlignment.Center
						background.YAlignment = YAlignment.Center
						self.background = self:Cache(background)
			
						local imagedata = icons:NameToIcon("FRAG")
						local icon = draw:Create("Image", "2V")
						icon.Color = Color3.new(1,1,1)
						icon.Image = imagedata[1]
						icon.Size = icon.ImageSize * 1.25
						icon.XAlignment = XAlignment.Center
						icon.YAlignment = YAlignment.Center
						self.icon = self:Cache(icon)
			
						local warning = draw:Create("Text", "2V")
						warning.Text = ""
						warning.Color = Color3.new(1,1,1)
						warning.Outlined = true
						warning.OutlineColor = Color3.fromRGB(0,0,0)
						warning.OutlineThickness = 2
						warning.XAlignment = XAlignment.Center
						warning.YAlignment = YAlignment.Bottom
						font:AddToManager(warning, "ESP.Global")
						self.warning = self:Cache(warning)
			
						local progress_container = draw:Create("Rect", "2V")
						progress_container.Size = Vector2.new(32, 6)
						progress_container.Color = Color3.fromRGB(30, 30, 30)
						progress_container.Filled = true
						progress_container.Outlined = true
						progress_container.OutlineColor = Color3.fromRGB(50, 50, 50)
						progress_container.OutlineThickness = 1
						progress_container.XAlignment = XAlignment.Right
						progress_container.YAlignment = YAlignment.Bottom
						self.progress_container = self:Cache(progress_container)
			
						local progress_bar = draw:Create("Gradient", "2V")
						progress_bar.OpacityUpperLeft = 1
						progress_bar.OpacityUpperRight = 1
						progress_bar.OpacityBottomLeft = 1
						progress_bar.OpacityBottomRight = 1
						progress_bar.XAlignment = XAlignment.Right
						progress_bar.YAlignment = YAlignment.Bottom
						self.progress_bar = self:Cache(progress_bar)
			
						self:Setup()
						self:Render()
					end
			
					function grenade_meta:Setup()
						if not self.final_position then return end
						local enabled = config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning")
						for i=1, #self.draw_cache do
							local v = self.draw_cache[i][1]
							v.Visible = enabled
						end
			
						local newcolor, transparency = config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning", "Warning Color")
						local colordark = color.darkness(newcolor, .7)
						local progress_bar = self.progress_bar
						progress_bar.ColorUpperLeft = newcolor
						progress_bar.ColorUpperRight = newcolor
						progress_bar.ColorBottomLeft = colordark
						progress_bar.ColorBottomRight = colordark
					end
			
					function grenade_meta:Destroy()
						for i=1, #self.draw_cache do
							local v = self.draw_cache[i][1]
							if draw:IsValid(v) then
								v:Remove()
							end
						end
					end
				end
			
				function esp:CreateGrenade(object, player, name, physics)
					local uid = "GRENADE_" .. object.Name .. "_" .. object:GetDebugId()
					local esp_controller = setmetatable({
						draw_cache = {},
						uniqueid = uid,
						object = object,
						name = name,
						physics = physics,
						player = player
					}, self.grenade_meta)
					self:Remove(uid)
					self:Add(esp_controller)
					return esp_controller
				end
			
				hook:Add("GrenadeCreated", "BBOT:ESP.Grenade", function(object, player, name, physics)
					esp:CreateGrenade(object, player, name, physics)
				end)
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
			local timer = BBOT.timer
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

			local u41 = CFrame.new
			local u11 = math.pi;
			local u21 = u11 * 2;
			local u13 = math.sin;
			local u61 = math.cos;
			local cframe = BBOT.aux.cframe

			-- u174(0.7 - 0.3 * l__p__958, 1 - 0.8 * l__p__958)
			-- l__p__958 = aimspring.p
			local slidespring_lerp = 0
			local function gunbob_old(p272, p273)
				local v714 = nil;
				local v715 = nil;
				-- what is dis?
				-- a way of not relying on springs for procedural velocity animations :)
				local char_multi = math.clamp(math.remap(char.speed, -5, 13, 0, 1)^3,0,1)
				
				-- just some base multipliers
				local v716 = 0.7 * char_multi -- the Y offset movement
				local v717 = 1 * char_multi -- angular movement
				v714 = char.distance * u21 * 3 / 4;
				v715 = -char.velocity;
				local v718 = char.speed * (1 - char.slidespring.p * 0.9) -- make sliding not look stupid lol

				-- the mmmmm formula
				local swap = char.slidespring.p
				local cf_pos_x = math.remap(swap, 1, 0, v718, (5 * v718 - 56))
				local cf_ang_xy = math.remap(swap, 1, 0, 1, v718 / 20 * u21)
				local cf_ang_z = math.remap(swap, 1, 0, 1, (5 * v718 - 56) / 20 * u21)
				local cf_ang = math.remap(swap, 1, 0, v718 / 20 * u21, 1)

				return u41(v717 * u61(v714 / 8 - 1) * cf_pos_x / (196/((char_multi+.5)/2)), 1.25 * v716 * u13(v714 / 4) * v718 / 512, 0)
				* cframe.fromaxisangle(
					Vector3.new(
						(v717 * u13(v714 / 4 - 1) / 256 + v717 * (u13(v714 / 64) - v717 * v715.z / 4) / 512) * cf_ang_xy,
						(v717 * u61(v714 / 128) / 256 - v717 * u61(v714 / 8) / 256) * cf_ang_xy,
						v717 * u13(v714 / 8) / 128 * cf_ang_z + v717 * v715.x / 1024
					) * cf_ang
				);
			end;

			local function DetourGunBob(related_func, index, gunmovement)
				local newfunc = function(...)
					local cf
					if config:GetValue("Weapons", "Stats Changer", "Movement", "OG Bob") then
						local ran, _cf = pcall(gunbob_old, ...)
						if not ran then
							BBOT.log(LOG_ERROR, _cf)
							cf = gunmovement(...)
						end
						cf = _cf
					else
						cf = gunmovement(...)
					end

					local mul = config:GetValue("Weapons", "Stats Changer", "Movement", "Bob Scale")/100 -- bob factor config here
					if mul == 0 then
						return CFrame.new()
					end
					local style = config:GetValue("Weapons", "Stats Changer", "Movement", "Weapon Style")
					if style == "Doom" then
						local mul2 = (math.clamp(char.velocity.Magnitude, 0, 30)/25)
						cf = CFrame.Angles((math.sin(tick()*5.5)^2) * (mul*mul2)/16, -math.sin(tick()*5.5) * (mul*mul2)/8, 0) + Vector3.new(math.sin(tick()*5.5) * mul/6, (math.sin(tick()*5.5)^2) * mul/6, 0)*mul2
						return cf
					elseif style == "Quake III" then
						local mul2 = (math.clamp(char.velocity.Magnitude, 0, 30)/25)
						cf = CFrame.Angles(0, -math.sin(tick()*8) * (mul*mul2)/8, 0) + Vector3.new(math.sin(tick()*8) * mul/5, -(math.sin(tick()*8)^2) * mul/5, 0)*mul2
						return cf
					elseif style == "Half-Life" then
						cf = CFrame.Angles(0, 0, 0) + Vector3.new(0, 0, (math.sin(tick()*8) * mul/6))*(math.clamp(char.velocity.Magnitude, 0, 35)/30)
						return cf
					else
						local x, y, z = cf:GetComponents()
						x = x * mul
						y = y * mul
						z = z * mul
						local pitch, yaw, roll = cf:ToEulerAnglesYXZ()
						pitch, yaw, roll = pitch * mul, yaw * mul, roll * mul
						cf = CFrame.Angles(pitch, yaw, roll) + Vector3.new(x, y, z)
						return cf
					end
				end
				upvaluemods[#upvaluemods+1] = {related_func, index, gunmovement}
				debug.setupvalue(related_func, index, newcclosure(newfunc))
			end

			local workspace = BBOT.service:GetService("Workspace")
			hook:Add("Initialize", "BBOT:Weapons.Detour", function()
				local receivers = network.receivers
				for k, v in pairs(receivers) do
					local const = debug.getconstants(v)
					if table.quicksearch(const, "Trigger") and table.quicksearch(const, "Indicator") and table.quicksearch(const, "Ticking") then
						local thingy
						hook:Add("PreNetworkReceive", "BBOT:Weapons.Grenades", function(netindex, player, grenadename, animtable)
							if netindex ~= k then return end
							thingy = workspace.Ignore.Misc.DescendantAdded:Connect(function(descendant)
								if descendant.Name ~= "Trigger" then return end
								timer:Async(function() hook:Call("GrenadeCreated", descendant, player, grenadename, animtable) end)
							end)
						end)
						hook:Add("PostNetworkReceive", "BBOT:Weapons.Grenades", function(netindex, player, grenadename, animtable)
							if netindex ~= k then return end
							thingy:Disconnect()
						end)
					end
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


				local ups = debug.getupvalues(gundata.playanimation)
				for k, v in pairs(ups) do
					local t = typeof(v)
					if t == "table" and v.camodata and typeof(v.larm) == "table" and v.larm.basec0 then
						gundata._anims = v
					end
				end

				local oldstep = gundata.step
				function gundata.step(...)
					hook:CallP("PreKnifeStep", gundata)
					local a, b, c, d = oldstep(...)
					hook:CallP("PostKnifeStep", gundata)
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

				local ups = debug.getupvalues(gundata.setequipped)
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
							local function replacement(...)
								hook:CallP("PreFireStep", gundata)
								local a, b, c, d = v(...)
								hook:CallP("PostFireStep", gundata)
								return a, b, c, d
							end
							debug.setupvalue(oldstep, k, replacement)
							gundata.firestep = replacement
						end
					end
				end

				function gundata.step(...)
					-- this is where the aimbot controller will be
					hook:CallP("PreWeaponStep", gundata)
					local a, b, c, d = oldstep(...)
					hook:CallP("PostWeaponStep", gundata)
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

			-- Grenades Wow
			-- config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning")

			do
				local camera = BBOT.service:GetService("CurrentCamera")
				local localplayer = BBOT.service:GetService("LocalPlayer")
				local char = BBOT.aux.char
				local roundsystem = BBOT.aux.roundsystem
				local cframe = BBOT.aux.cframe
				local draw = BBOT.draw
				local grenade_prediction_lines = {}

				local function CalculateGrenadePathway(grenade_mainpart, grenadedata, delaytime)
					local initiatetime = 0
				
					local me_HumanoidRootPart = localplayer.Character:FindFirstChild("HumanoidRootPart")
					local u193 = char.alive and (camera.CFrame * CFrame.Angles(math.rad(grenadedata.throwangle and 0), 0, 0)).lookVector * grenadedata.throwspeed + me_HumanoidRootPart.Velocity or Vector3.new(math.random(-3, 5), math.random(0, 2), math.random(-3, 5));
					local u195 = char.deadcf and char.deadcf.p or grenade_mainpart.CFrame.p;
					local u197 = (camera.CFrame - camera.CFrame.p) * Vector3.new(19.539, -5, 0);
					local u198 = grenade_mainpart.CFrame - grenade_mainpart.CFrame.p;
					local grenade_mainpart_cframe = grenade_mainpart.CFrame;
					local gravity = Vector3.new(0, -80, 0)
					local windowsbroken = 0
					local u202 = Vector3.new()
					local u146 = u202.Dot
					local u203 = false
					local timedelta = 0.016666666666666666
					local pathtable = {
						curi = 1, 
						time = initiatetime, 
						blowuptime = delaytime - initiatetime, 
						frames = { {
								t0 = 0, 
								p0 = u195, 
								v0 = u193, 
								offset = Vector3.new(), 
								a = gravity, 
								rot0 = grenade_mainpart_cframe - grenade_mainpart_cframe.p,
								timedelta = 0,
								hit = false,
								hitnormal = Vector3.new(0,1,0),
								rotv = u197, 
								glassbreaks = {}
							} }
					};
					local timedeltaacc = (timedelta ^ 2)*0.5
					for v765 = 1, (delaytime - initiatetime) / timedelta + 1 do
						local v766 = u195 + timedelta * u193 + timedeltaacc * gravity; -- kinematics basically
						local v767, v768, v769 = workspace:FindPartOnRayWithWhitelist(Ray.new(u195, v766 - u195 - 0.05 * u202),roundsystem.raycastwhitelist);
						local v770 = timedelta * v765;
						if v767 and v767.Name ~= "Window" and v767.Name ~= "Col" then
							u198 = grenade_mainpart.CFrame - grenade_mainpart.CFrame.p;
							u202 = 0.2 * v769;
							u197 = v769:Cross(u193) / 0.2;
							local v771 = v768 - u195;
							local v772 = 1 - 0.001 / v771.magnitude;
							if v772 < 0 then
								local v773 = 0;
							else
								v773 = v772;
							end;
							u195 = u195 + v773 * v771 + 0.05 * v769;
							local v774 = u146(v769, u193) * v769;
							local v775 = u193 - v774;
							local v776 = -u146(v769, gravity);
							local v777 = -1.2 * u146(v769, u193);
							local v778 = 0;
							if v776 < 0 then
								v778 = 0;
							else
								v778 = v776;
							end;
							local v779 = 0;
							if v777 < 0 then
								v779 = 0;
							else
								v779 = v777;
							end;
							local v780 = 1 - 0.08 * (10 * v778 * timedelta + v779) / v775.magnitude;
							local v781 = 0;
							if v780 < 0 then
								v781 = 0;
							else
								v781 = v780;
							end;
							u193 = v781 * v775 - 0.2 * v774;
							if u193.magnitude < 1 then
								local l__frames__782 = pathtable.frames;
								l__frames__782[#l__frames__782 + 1] = {
									t0 = v770 - timedelta * (v766 - v768).magnitude / (v766 - u195).magnitude, 
									p0 = u195, 
									v0 = u161, 
									a = u161, 
									rot0 = cframe.fromaxisangle (v770 * u197) * u198, 
									offset = 0.2 * v769, 
									rotv = u161,
									hitnormal = v769,
									hit = true,
									timedelta = timedelta * v765,
									glassbreaks = {}
								};
								break;
							end;
							local l__frames__783 = pathtable.frames;
							l__frames__783[#l__frames__783 + 1] = {
								t0 = v770 - timedelta * (v766 - v768).magnitude / (v766 - u195).magnitude, 
								p0 = u195, 
								v0 = u193, 
								a = u203 and u161 or gravity, 
								rot0 = cframe.fromaxisangle (v770 * u197) * u198, 
								offset = 0.2 * v769, 
								rotv = u197,
								timedelta = timedelta * v765,
								hitnormal = v769,
								hit = true,
								glassbreaks = {}
							};
							u203 = true;
						else
							u195 = v766;
							u193 = u193 + timedelta * gravity;
							u203 = false;
							local l__frames__783 = pathtable.frames;
							l__frames__783[#l__frames__783 + 1] = {
								t0 = v770 - timedelta * (v766 - v768).magnitude / (v766 - u195).magnitude, 
								p0 = u195, 
								v0 = u193, 
								a = u203 and u161 or gravity, 
								rot0 = cframe.fromaxisangle (v770 * u197) * u198, 
								offset = 0.2 * v769, 
								rotv = u197,
								timedelta = timedelta * v765,
								hitnormal = Vector3.new(0,1,0),
								hit = false,
								glassbreaks = {}
							};
							--[[if v767 and v767.Name == "Window" and windowsbroken < 5 then
								windowsbroken = windowsbroken + 1;
								local l__frames__784 = pathtable.frames;
								local l__glassbreaks__785 = l__frames__784[#l__frames__784].glassbreaks;
								l__glassbreaks__785[#l__glassbreaks__785 + 1] = {
									t = v770, 
									part = v767
								};
							end;]]
						end;
					end;
					return pathtable
				end

				local pather = BBOT.drawpather:Create()
				pather:ShowEnd(true)
				
				hook:Add("OnConfigChanged", "BBOT:GrenadePrediction", function(steps, old, new)
					if config:IsPathwayEqual(steps, "Main", "Visuals", "Grenades", "Grenade Prediction", "Prediction Color") then
						pather:SetColor(config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction", "Prediction Color"))
					elseif config:IsPathwayEqual(steps, "Main", "Visuals", "Grenades", "Grenade Prediction", true) and not new then
						pather:Clear()
					end
				end)

				hook:Add("OnAliveChanged", "BBOT:GrenadePrediction", function(alive)
					if not alive then
						pather:Clear()
					end
				end)
				
				local dark = Color3.new(0,0,0)

				hook:Add("PostLoadGrenade", "PostLoadGrenade", function(grenadehandler)
					local ups = debug.getupvalues(grenadehandler.throw)
					local createnade, createnadeid
					for k, v in pairs(ups) do
						if typeof(v) == "function" then
							local name = debug.getinfo(v).name
							if name == "createnade" then
								createnade = v
								createnadeid = k
							end
						end
					end

					local mainpart = debug.getupvalue(createnade, 2)
					if typeof(mainpart) ~= "Instance" then
						mainpart = nil
					end
		
					local pull = grenadehandler.pull
					local ups = debug.getupvalues(pull)
					local grenadedataindex
					local grenadedata
					for k, v in pairs(ups) do
						if typeof(v) == "table" then
							if v.throwspeed then
								grenadedata = v
								grenadedata = table.deepcopy(grenadedata)
								grenadedataindex = k
								debug.setupvalue(pull, k, grenadedata)
							end
						end
					end

					grenadedata.createnade = createnade

					hook:Call("MakeGrenade", grenadedata, grenadehandler)

					hook:BindFunction(createnade, "ThrowGrenade", false, mainpart, grenadedata, grenadehandler)
					hook:BindFunction(grenadehandler.step, "GrenadeStep", false, mainpart, grenadedata, grenadehandler)
				end)

				hook:Add("MakeGrenade", "MakeGrenade", function(grenadedata, grenadehandler)
					if config:GetValue("Main", "Misc", "Tweaks", "Insta Throw Grenades") then
						grenadedata.animations = table.deepcopy(grenadedata.animations)
						for i, v in next, grenadedata.animations do
							if string.find(string.lower(i), "pull") then
								grenadedata.animations[i].timescale = 0.001
							end
						end
					end

					local speed = config:GetValue("Main", "Misc", "Tweaks", "Grenade Speed")

					grenadedata._throwspeed = grenadedata.throwspeed
					local ups = debug.getupvalues(grenadedata.createnade)
					for k, v in pairs(ups) do
						if typeof(v) == "number" then
							if v == grenadedata.throwspeed then
								grenadedata._throwspeedindex = k
							end
						end
					end

					if speed ~= 100 then
						grenadedata.throwspeed = grenadedata.throwspeed * (speed/100)
						debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, grenadedata.throwspeed)
					end
				end)

				hook:Add("PreThrowGrenade", "PreThrowGrenade", function()
					hook:UnBindFunction("GrenadeStep")
				end)

				hook:Add("PostThrowGrenade", "PostThrowGrenade", function()
					timer:Async(function()
						hook:UnBindFunction("ThrowGrenade")
					end)
				end)

				hook:Add("PreThrowGrenade", "BBOT:Weapons.Grenades.ShowPath", function(mainpart, grenadedata, grenadehandler)
					local pull = grenadehandler.pull
					local ups = debug.getupvalues(pull)
					local blowuptimeindex = #ups
					local blowtime = debug.getupvalue(pull, blowuptimeindex)-tick()

					local speed = config:GetValue("Main", "Misc", "Tweaks", "Grenade Speed")
					if config:GetValue("Main", "Misc", "Tweaks", "Grenade Distance Speed") then
						local raycastdata = BBOT.aimbot:raycastbullet(camera.CFrame.p, camera.CFrame.LookVector * 2000)
						if raycastdata then
							local newspeed = (raycastdata.Position-camera.CFrame.p).Magnitude * (speed/100) * 2
							debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
							grenadedata.throwspeed = newspeed
						else
							local newspeed = 2000 * (speed/100)
							debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
							grenadedata.throwspeed = newspeed
						end
					end

					pather:Clear()
					local frames = CalculateGrenadePathway(mainpart, grenadedata, blowtime).frames
					if config:GetValue("Main", "Misc", "Tweaks", "Impact Grenades") then
						for i=1, #frames do
							local v = frames[i]
							if v.hit then
								blowtime = v.timedelta
								blowtime = math.clamp(blowtime + config:GetValue("Main", "Misc", "Tweaks", "Impact Grenade Time"), 0, 5)
								debug.setupvalue(pull, blowuptimeindex, blowtime+tick())
								break
							end
						end
					end
					if config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction") then
						local pathway = {}
						for i=1, #frames do
							if not frames[i].p0 or frames[i].timedelta > blowtime then break end
							if i%2 == 0 then continue end
							pathway[#pathway+1] = frames[i].p0
						end
						local a, b = config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction", "Prediction Color")
						BBOT.drawpather:SimpleWithEnd(pathway, a, b, blowtime)
					end
				end)

				hook:Add("PostGrenadeStep", "BBOT:Weapons.Grenades.ShowPath", function(mainpart, grenadedata, grenadehandler)
					if not mainpart then return end
					local pull = grenadehandler.pull
					local ups = debug.getupvalues(pull)
					local blowuptimeindex = #ups
					local blowtime = debug.getupvalue(pull, blowuptimeindex)-tick()

					local speed = config:GetValue("Main", "Misc", "Tweaks", "Grenade Speed")
					if config:GetValue("Main", "Misc", "Tweaks", "Grenade Distance Speed") then
						local raycastdata = BBOT.aimbot:raycastbullet(camera.CFrame.p, camera.CFrame.LookVector * 2000)
						if raycastdata then
							local newspeed = (raycastdata.Position-camera.CFrame.p).Magnitude * (speed/100) * 2
							debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
							grenadedata.throwspeed = newspeed
						else
							local newspeed = 2000 * (speed/100)
							debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
							grenadedata.throwspeed = newspeed
						end
					end

                    if config:GetValue("Main", "Misc", "Tweaks", "Safety Grenades") then
						local throwinhandindex = #ups-2
                        debug.setupvalue(pull, throwinhandindex, tick() + 10)
                    end

					local impact = config:GetValue("Main", "Misc", "Tweaks", "Impact Grenades")
					if impact then
						blowtime = (grenadedata.fusetime or 5)
						debug.setupvalue(pull, blowuptimeindex, blowtime+tick())
					end
					local frames = CalculateGrenadePathway(mainpart, grenadedata, blowtime).frames
					if impact then
						for i=1, #frames do
							local v = frames[i]
							if v.hit then
								blowtime = v.timedelta
								blowtime = math.clamp(blowtime + config:GetValue("Main", "Misc", "Tweaks", "Impact Grenade Time"), 0, 5)
								break
							end
						end
					end
					if config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction") then
						local pathway = {}
						for i=1, #frames do
							if not frames[i].p0 or frames[i].timedelta > blowtime then break end
							if i%2 == 0 then continue end
							pathway[#pathway+1] = frames[i].p0
						end
						pather:Update(pathway)
					end
				end)
			end

			-- Modifications
			hook:Add("WeaponModifyData", "ModifyWeapon.Recoil", function(modifications)
				local rot = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Rotation Kick")/100
				local trans = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Displacement Kick")/100
				local cam = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Camera Kick")/100
				local aim = 1
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

				local hchoke = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Hip Choke")/100
				local achoke = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Aim Choke")/100

				if modifications.hipchoke then
					modifications.hipchoke = modifications.hipchoke * hchoke
				end

				if modifications.aimchoke then
					modifications.aimchoke = modifications.aimchoke * achoke
				end

				if config:GetValue("Weapons", "Stats Changer", "Accuracy", "No Scope Sway") then
					modifications.swayamp = 0
				end

				if config:GetValue("Weapons", "Stats Changer", "Accuracy", "Straight Bolt Pull") then
					modifications.pullout = false
					modifications.zoompullout = true
				end
		
				--[[local cks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "CamKickSpeed")
				local acks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "AimCamKickSpeed")
				local mks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelKickSpeed")
				local mrs = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelRecoverSpeed")
				local mkd = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelKickDamper")
		
				modifications.camkickspeed = modifications.camkickspeed * cks;
				modifications.aimcamkickspeed = modifications.aimcamkickspeed * acks;
				modifications.modelkickspeed = modifications.modelkickspeed * mks;
				modifications.modelrecoverspeed = modifications.modelrecoverspeed * mrs;
				modifications.modelkickdamper = modifications.modelkickdamper * mkd;]]
			end)

			hook:Add("WeaponModifyData", "ModifyWeapon.Burst", function(modifications)
				modifications.burstlock = modifications.burstlock or config:GetValue("Weapons", "Stats Changer", "Ballistics", "Burst-Lock");
				local cap = config:GetValue("Weapons", "Stats Changer", "Ballistics", "Burst Cap")
				if cap > 0 then
					modifications.firecap = cap;
				end
			end)

			hook:Add("WeaponModifyData", "ModifyWeapon.FireModes", function(modifications)
				local firemodes = table.deepcopy(modifications.firemodes)
				local firerates = (typeof(modifications.firerate) == "table" and table.deepcopy(modifications.firerate) or nil)
				local firerates_addition = config:GetValue("Weapons", "Stats Changer", "Ballistics", "Fire Modes")
				local single = firerates_addition["Semi-Auto"] and 1 or nil
				if single and not table.quicksearch(firemodes, single) then
					table.insert(firemodes, 1, single)
				end
				local burst2 = firerates_addition["Burst-2"] and 2 or nil
				if burst2 and not table.quicksearch(firemodes, burst2) then
					table.insert(firemodes, 1, burst2)
				end
				local burst3 = firerates_addition["Burst-3"] and 3 or nil
				if burst3 and not table.quicksearch(firemodes, burst3) then
					table.insert(firemodes, 1, burst3)
				end
				local burst4 = firerates_addition["Burst-4"] and 4 or nil
				if burst4 and not table.quicksearch(firemodes, burst4) then
					table.insert(firemodes, 1, burst4)
				end
				local burst5 = firerates_addition["Burst-5"] and 5 or nil
				if burst5 and not table.quicksearch(firemodes, burst5) then
					table.insert(firemodes, 1, burst5)
				end
				local auto = firerates_addition["Full-Auto"] and true or nil
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
				local mul = config:GetValue("Weapons", "Stats Changer", "Ballistics", "Firerate")/100
				if firerates then
					for i=1, #firerates do
						firerates[i] = firerates[i] * mul
					end
					modifications.firerate = firerates
				else
					modifications.firerate = modifications.firerate * mul;
				end
			end)

			hook:Add("WeaponModifyData", "ModifyWeapon.Reload", function(modifications)
				--if not config:GetValue("Weapons", "Stat Modifications", "Enable") then return end
				local timescale = config:GetValue("Weapons", "Stats Changer", "Animations", "Reload Scale")/100
				for i, v in next, modifications.animations do
					if string.find(string.lower(i), "reload") then
						if typeof(modifications.animations[i]) == "table" and modifications.animations[i].timescale then
							modifications.animations[i].timescale = (modifications.animations[i].timescale or 1) * timescale
						end
					end
				end
			end)

			hook:Add("PreKnifeStep", "BBOT:Weapon.SwaySpring", function()
				local swayspring = debug.getupvalue(BBOT.aux.char.reloadsprings, 6)
				swayspring.t = swayspring.t*(config:GetValue("Weapons", "Stats Changer", "Movement", "Swing Scale")/100)
			end)
			
			hook:Add("PreWeaponStep", "BBOT:Weapon.SwaySpring", function()
				local swayspring = debug.getupvalue(BBOT.aux.char.reloadsprings, 6)
				swayspring.t = swayspring.t*(config:GetValue("Weapons", "Stats Changer", "Movement", "Swing Scale")/100)
			end)

			hook:Add("WeaponModifyData", "ModifyWeapon.OnFire", function(modifications)
				local timescale = config:GetValue("Weapons", "Stats Changer", "Animations", "OnFire Scale")/100
				for i, v in next, modifications.animations do
					if string.find(string.lower(i), "onfire") then
						if typeof(modifications.animations[i]) == "table" and modifications.animations[i].timescale then
							modifications.animations[i].timescale = (modifications.animations[i].timescale or 1) * timescale
						end
					end
				end
			end)

			hook:Add("WeaponModifyData", "ModifyWeapon.Offsets", function(modifications)
				local style = config:GetValue("Weapons", "Stats Changer", "Movement", "Weapon Style")
				if style == "Doom" or style == "Quake III" or style == "Rambo" then
					local ang = Vector3.new(0, 0, 0)
					modifications.mainoffset = CFrame.new(Vector3.new(0,-1.5,-1.25)) * CFrame.Angles(ang.X, ang.Y, ang.Z)

					local ang = Vector3.new(-0.479, 0.610, 0.779)
					modifications.sprintoffset = CFrame.new(Vector3.new(0.1,0,-0.25)) * CFrame.Angles(ang.X, ang.Y, ang.Z)

					local ang = Vector3.new(0, 0, 0)
					modifications.crouchoffset = CFrame.new(Vector3.new(0.25,0.25,0.25)) * CFrame.Angles(ang.X, ang.Y, ang.Z)
				end
			end)

			hook:Add("WeaponModifyData", "ModifyWeapon.Speeds", function(modifications)
				modifications.hipfirespread = modifications.hipfirespread * (config:GetValue("Weapons", "Stats Changer", "Handling", "Hip Spread")/100)
				modifications.aimspeed = modifications.aimspeed * (config:GetValue("Weapons", "Stats Changer", "Handling", "Aiming Speed")/100)
				modifications.equipspeed = modifications.equipspeed * (config:GetValue("Weapons", "Stats Changer", "Handling", "Equip Speed")/100)
				modifications.sprintspeed = modifications.sprintspeed * (config:GetValue("Weapons", "Stats Changer", "Handling", "Ready Speed")/100)
			end)

			do -- no scope pasted from v1 lol -- yes... omg
				local localplayer = BBOT.service:GetService("LocalPlayer")
				local gui = localplayer.PlayerGui
				local frame = gui.NonScaled.ScopeFrame
				--[[hook:Add("OnConfigChanged", "BBOT:Misc.NoScopeBorders", function(steps, old, new)
					if config:IsPathwayEqual(steps, "Main", "Visuals", "Camera Visuals", "No Scope Border") then return end
					if not frame then return end
					local sightRear = frame:FindFirstChild("SightRear")
					if not sightRear then return end
					if new then
						local children = sightRear:GetChildren()
						for i = 1, #children do
							local thing = children[i]
							if thing.ClassName == "Frame" then
								thing.Visible = false
							end
						end
						frame.SightFront.Visible = false
						sightRear.ImageTransparency = 1
					else
						local children = sightRear:GetChildren()
						for i = 1, #children do
							local thing = children[i]
							if thing.ClassName == "Frame" then
								thing.Visible = true
							end
						end
						frame.SightFront.Visible = true
						sightRear.ImageTransparency = 0
					end
				end)]]

				hook:Add("RenderStepped", "BBOT:Weapons.ScopeBorders", function()
					local new = config:GetValue("Main", "Visuals", "Camera Visuals", "No Scope Border")
					if not frame then return end
					local sightRear = frame:FindFirstChild("SightRear")
					if not sightRear then return end
					if new then
						local children = sightRear:GetChildren()
						for i = 1, #children do
							local thing = children[i]
							if thing.ClassName == "Frame" then
								thing.Visible = false
							end
						end
						frame.SightFront.Visible = false
						sightRear.ImageTransparency = 1
					else
						local children = sightRear:GetChildren()
						for i = 1, #children do
							local thing = children[i]
							if thing.ClassName == "Frame" then
								thing.Visible = true
							end
						end
						frame.SightFront.Visible = true
						sightRear.ImageTransparency = 0
					end
				end)
			end

			-- Skins
			do
				local texture_animtypes = {
					["OffsetStudsU"] = true,
					["OffsetStudsV"] = true,
					["StudsPerTileU"] = true,
					["StudsPerTileV"] = true,
					["Transparency"] = true,
				}

				local animation_to_simple = {
					["OSU"] = "OffsetStudsU",
					["OSV"] = "OffsetStudsV",
					["SPTU"] = "StudsPerTileU",
					["SPTV"] = "StudsPerTileV",
					["BC"] = "BrickColor",
					["TC"] = "TextureColor",
				}

				function weapons:SetupAnimations(reg, objects, type, animtable, extra)
					for k, v in pairs(reg) do
						if typeof(v) == "table" and v.Enabled then
							k = animation_to_simple[k] or k
							if texture_animtypes[k] and type == "Texture" then
								if v.Type.value == "Additive" then
									animtable[#animtable+1] = {
										t = "Additive",
										s = v.Speed,
										p0 = -1,
										min = -1,
										max = 1,
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
								if v.Type.self.value == "Fade" then
									animtable[#animtable+1] = {
										t = "Fade",
										s = v.Speed,
										c0 = Color3.fromRGB(unpack(v.Type["Primary Color"].value)),
										c1 = Color3.fromRGB(unpack(v.Type["Secondary Color"].value)),
										m = extra or 1,
										objects = objects,
										property = col
									}
								else
									animtable[#animtable+1] = {
										t = "Cycle",
										s = v.Speed,
										m = extra or 1,
										sa = v.Saturation/100,
										da = v.Darkness/100,
										objects = objects,
										property = col
									}
								end
							end
						end
					end
				end

				local color = BBOT.color
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
							position = color.mul(position, anim.m)
						elseif anim.t == "Cycle" then
							position = Color3.fromHSV(((tick() * anim.s) % 90) / 90, anim.sa, anim.da)
							position = color.mul(position, anim.m)
						end
						if position then
							for i=1, #anim.objects do
								local object = anim.objects[i]
								object[anim.property] = position or object[anim.property]
							end
						end
					end
				end

				local asset = BBOT.asset
				function weapons:CreateSkin(skin_databank, config_data, gun_objects, gun_data)
					skin_databank.objects = gun_objects
					local textures = {}
					for i=1, #gun_objects do
						local object = gun_objects[i]
						object.Color = color.mul(Color3.fromRGB(unpack(config_data.Basics["Material"]["Brick Color"].value)), config_data.Basics["Color Modulation"])
						object.Material = config.enums.Material.Id[config_data.Basics["Material"]["self"].value]
						object.Reflectance = config_data.Basics["Reflectance"]/100
						if object:IsA("UnionOperation") then
							object.UsePartColor = true
						end
						local texture = config_data["Texture"]
						if texture.Enabled and object.Transparency < 1 and not object:FindFirstChild("OtherHide") and texture["Asset-Id"] ~= "" and (object:IsA("MeshPart") or object:IsA("UnionOperation")) then
							for i=0, 5 do
								local itexture = Instance.new("Texture")
								itexture.Parent = object
								itexture.Face = i
								itexture.Name = "Slot1"
								itexture.Color3 = color.mul(Color3.fromRGB(unpack(texture["Asset-Id"]["Texture Color"].value)), texture["Color Modulation"])

								local trueassetid = ""
								local assetid = texture["Asset-Id"].self
								if asset:IsFile("textures", assetid) then
									trueassetid = asset:GetAsset("textures", assetid)
								else
									trueassetid = "rbxassetid://" .. assetid
								end

								itexture.Texture = trueassetid
								itexture.Transparency = 1-(texture["Asset-Id"]["Texture Color"].value[4]/255)
								itexture.OffsetStudsU = texture.OffsetStudsU
								itexture.OffsetStudsV = texture.OffsetStudsV
								itexture.StudsPerTileU = texture.StudsPerTileU
								itexture.StudsPerTileV = texture.StudsPerTileV
								if gun_data then
									if not gun_data._anims.camodata[object] then
										gun_data._anims.camodata[object] = {}
									end
									gun_data._anims.camodata[object][itexture] = {
										Transparency = itexture.Transparency
									}
								end
								skin_databank.textures[#skin_databank.textures+1] = {object, itexture}
								textures[#textures+1] = itexture
							end
						end
					end
					self:SetupAnimations(config_data.Animations, textures, "Texture", skin_databank.animations, config_data["Texture"]["Color Modulation"])
					self:SetupAnimations(config_data.Animations, gun_objects, "Part", skin_databank.animations, config_data.Basics["Color Modulation"])
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
					local slot1_data = reg["Slot1"]
					if slot1_data.Basics.Enabled then
						self:CreateSkin(skins.slot1, slot1_data, slot1, gundata)
					end

					local slot2_data = reg["Slot2"]
					if slot2_data.Basics.Enabled then
						self:CreateSkin(skins.slot2, slot2_data, slot2, gundata)
					end

					return skins
				end

				hook:Add("PreInitialize", "BBOT:Weapons.SkinDB", function()
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
						if config:IsPathwayEqual(steps, "Weapons", "Skins") then
							local reg = config:GetValue("Weapons", "Skins")
							if not reg.Enabled then return end
							for k, v in pairs(weapons.weaponstorage) do
								weapons:SkinApplyGun(v)
							end
						end
					end)
				end

				function weapons:SkinApplyGun(gundata, slot)
					local slot = slot or gundata.gunnumber
					local model = gundata._model
					if not model then return end
					local reg = config:GetValue("Weapons", "Skins")
					if not reg.Enabled then return end
					local slot1, slot2 = weapons:PrepareSkins(model)
					weapons:ApplySkin(reg, gundata, slot1, slot2)
				end

				function weapons:PrepareSkins(model)
					local descendants = model:GetDescendants()
					local slot1, slot2 = {}, {}
					for k, v in pairs(descendants) do
						if v.ClassName == 'Texture' and (v.Name == "Slot1" or v.Name == "Slot2") then
							v:Destroy()
						end
					end

					for k, v in pairs(descendants) do
						if v.ClassName == 'Part' or v.ClassName == 'MeshPart' or v.ClassName == 'UnionOperation' then
							if v:FindFirstChild("Slot1") then
								slot1[#slot1+1] = v
							elseif v:FindFirstChild("Slot2") then
								slot2[#slot2+1] = v
							end
						end
					end

					return slot1, slot2
				end

				hook:Add("PostLoadGun", "Skin.Apply", function(gundata, name)
					weapons:SkinApplyGun(gundata)
				end)

				hook:Add("PostInitialize", "Skin.LiveApply", function()
					local workspace = BBOT.service:GetService("Workspace")
					local gunstage_connection_add = false
					local gunstage_connection_remove = false

					hook:Add("Unload", "BBOT:Skins.StagePreview", function()
						if gunstage_connection_add then
							gunstage_connection_add:Disconnect()
							gunstage_connection_add = nil
						end
						if gunstage_connection_remove then
							gunstage_connection_remove:Disconnect()
							gunstage_connection_remove = nil
						end
					end)

					local function performchanges(gunmodel)
						local model = gunmodel:GetChildren()[1]
						if not model then return end
						local reg = config:GetValue("Weapons", "Skins")
						if not reg.Enabled then return end

						local slot1, slot2 = weapons:PrepareSkins(model)
						local applied = weapons:ApplySkin(reg, nil, slot1, slot2)
						
						hook:Add("RenderStepped", "Skin.Preview.Animations", function(delta)
							if not reg.Enabled then return end
							weapons:RenderAnimations(applied.slot1.animations, delta)
							weapons:RenderAnimations(applied.slot2.animations, delta)
						end)
					end


					local changing = false
					hook:Add("Skins.GunStageChanged", "Skins.GunStageChanged", function(gunmodel)
						timer:Create("Skins.ReloadStage", 0, 1, function()
							changing = true
							performchanges(gunmodel)
							changing = false
						end)
					end)

					local function refresh()
						if not workspace:FindFirstChild("MenuLobby") then return end
						if not workspace.MenuLobby:FindFirstChild("GunStage") then return end
						if not workspace.MenuLobby.GunStage:FindFirstChild("GunModel") then return end
						local gunmodel = workspace.MenuLobby.GunStage.GunModel
						
						if gunstage_connection_add then
							gunstage_connection_add:Disconnect()
							gunstage_connection_add = nil
						end

						if gunstage_connection_remove then
							gunstage_connection_remove:Disconnect()
							gunstage_connection_remove = nil
						end

						gunstage_connection_add = gunmodel.DescendantAdded:Connect(function()
							if changing then return end

							changing = true
							hook:CallP("Skins.GunStageChanged", gunmodel)
							changing = false
						end)

						gunstage_connection_remove = gunmodel.DescendantRemoving:Connect(function()
							if changing then return end

							changing = true
							hook:CallP("Skins.GunStageChanged", gunmodel)
							changing = false
						end)

						changing = true
						performchanges(gunmodel)
						changing = false
					end

					hook:Add("OnConfigChanged", "Skin.Preview", function(steps, old, new)
						if not config:IsPathwayEqual(steps, "Weapons", "Skins") then return end
						refresh()
					end)

					timer:Async(refresh)
				end)

				hook:Add("PostLoadKnife", "Skin.Apply", function(gundata, name)
					local model = gundata._model
					gundata._isknife = true
					if not model then return end
					local reg = config:GetValue("Weapons", "Skins")
					if not reg.Enabled then return end

					local slot1, slot2 = weapons:PrepareSkins(model)

					weapons:ApplySkin(reg, gundata, slot1, slot2)
				end)

				hook:Add("PostWeaponStep", "Skin.Animation", function(gundata, partdata)
					if not gundata._skins then return end
					local reg = config:GetValue("Weapons", "Skins")
					if not reg.Enabled then return end
					if not gundata._skinlast then
						gundata._skinlast = tick()
						return
					end
					local delta = tick()
					weapons:RenderAnimations(gundata._skins.slot1.animations, delta-gundata._skinlast)
					weapons:RenderAnimations(gundata._skins.slot2.animations, delta-gundata._skinlast)
					gundata._skinlast = delta
				end)

				hook:Add("PostKnifeStep", "Skin.Animation", function(gundata, partdata)
					if not gundata._skins then return end
					local reg = config:GetValue("Weapons", "Skins")
					if not reg.Enabled then return end
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

		-- Logging
		-- Cause why not
		do
			local statistics = BBOT.statistics
			local hook = BBOT.hook
		
			statistics:Create("stats", {
				kills = 0,
				deaths = 0,
				killed = {},
			})

			hook:Add("PreBigAward", "BBOT:Statistics.Kills", function(type, entity, gunname, earnings)
				local name = tostring(entity.Name)
				local stats = statistics:Get("stats")
				stats.kills = stats.kills + 1
				if not stats.killed[name] then
					stats.killed[name] = 0
				end
				stats.killed[name] = stats.killed[name] + 1
				statistics:Set("stats")
			end)

			hook:Add("LocalKilled", "BBOT:Statistics.Deaths", function(player)
				local stats = statistics:Get("stats")
				stats.deaths = stats.deaths + 1
				statistics:Set("stats")
			end)
		end
	elseif BBOT.universal then

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
		local dbgfeatures = {}
		for k, v in next, BBOT.Debug do
			if v then
				dbgfeatures[#dbgfeatures+1] = k
			end
		end

		if #dbgfeatures > 0 then
			BBOT.notification:Create("!!! WARNING !!!\nThe following debugging features are enabled:\n" .. table.concat(dbgfeatures, "\n"), 30):SetType("alert")
		end

		BBOT.notification:Create("!!! IMPORTANT !!!\nThis is the Synapse 3.0 version,\nthere may be a lot of internal issues!\nReport any issues to WholeCream!", 30):SetType("alert")
		BBOT.notification:Create("!!! IMPORTANT !!!\nScripts system has been enabled, you have full access to the bitch bot environment!", 10):SetType("alert")
		if _BBOT then
			BBOT.notification:Create("There was an already active version of bbot running, this has been unloaded")
		end
		BBOT.notification:Create(string.format("Done loading the " .. BBOT.game .. " cheat. (%d ms)", loadtime*1000))
		BBOT.notification:Create("Press DELETE to open and close the menu!")
	end)
end
end

local ran, err = xpcall(ISOLATION, debug.traceback, BBOT)
if not ran then
	BBOT.log(LOG_ERROR, "Error loading Bitch Bot -", err)
end