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
	draw = isfile("bbddbg.txt"),
	libskip = isfile("bblsdbg.txt")
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

local localplayer = game:GetService("Players").LocalPlayer
BBOT.account = localplayer.Name
BBOT.accountId = tostring(localplayer.UserId)

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

BBOT.start_time = tick()

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

-- core library adder
do
	local log = BBOT.log
	local library = {
		registry = {},
	}
	BBOT.library = library

	library.types = {
		FILE = 0, -- local system
		CDN = 1, -- content delivery network
		PB = 2, -- pastebin
		RAW = 3, -- raw string
	}

	-- loads bbot with all packages/dependencies
	function library:Initialize()
		if not library:Request() then
			return
		end
		if not library:Load() then
			return
		end

		BBOT.hook:Call("PreInitialize")
		BBOT.hook:Call("Initialize")
		BBOT.hook:Call("PostInitialize")
	end

	-- fetches all CDN & File based packages
	function library:Request()
		log(LOG_NORMAL, "Fetching " .. #self.registry .. " libraries...")
		local libs, types = self.registry, self.types
		local alright = true
		for i=1, #libs do
			local lib = libs[i]
			local errored = false

			if lib.type == types.FILE then
				if isfile(lib.path) then
					lib.data = readfile(lib.path)
				else
					log(LOG_ERROR, "[LIB] " .. lib.name .. " does not exist in workspace! (" .. lib.path .. ")")
					errored = true
				end
			elseif lib.type == types.CDN then

			elseif lib.type == types.PB then

			elseif lib.type == types.RAW then

			end

			if lib.data then
				lib.downloaded = true
			elseif not errored then
				log(LOG_ERROR, "[LIB] " .. lib.name .. " contains null data! (" .. lib.path .. ")")
				errored = true
			end

			if errored then
				alright = false
			end
		end
		return alright
	end

	library.pre_run = "local ___={...};local BBOT=___[1];"

	-- runs all libraries successfully fetched
	function library:Load()
		log(LOG_NORMAL, "Loading up libraries...")
		local libs = self.registry
		for i=1, #libs do
			local lib = libs[i]
			if lib.running then continue end
			local data = lib.data
			local func, err = loadstring(self.pre_run .. lib.data)
			if not func then
				log(LOG_ERROR, "[LIB] An error occured compiling library \"" .. lib.name .. "\",\n" .. (err or "Unknown Error!"))
				return false
			end
			lib.compiled = true
			setfenv(func, getfenv())
			local ran, library_table = xpcall(func, debug.traceback, BBOT)
			if not ran then
				log(LOG_ERROR, "[LIB] An error occured executing library \"" .. lib.name .. "\",\n" .. (library_table or "Unknown Error!"))
				return false
			end
			lib.ran = true
            if library_table then
                BBOT[lib.name] = library_table
            end
		end
		return true
	end

	-- adds a package to loader
	function library:AddPackage(name, path, type)
		self.registry[#self.registry+1] = {
			name = name,
			path = path,
			type = type,
		}
	end

	-- adds multiple packages to loader
	function library:BulkAddPackage(t)
		for i=1, #t do
			local v = t[i]
			self:AddPackage(v[1], v[2], v[3])
		end
	end

	if BBOT.username == "dev" then
		local types = library.types
        library:BulkAddPackage({
			-- primitive libraries
			{"table", "bbotcdn/core/table.lua", types.FILE},
			{"math", "bbotcdn/core/math.lua", types.FILE},
			{"debug", "bbotcdn/core/debug.lua", types.FILE},
			{"string", "bbotcdn/core/string.lua", types.FILE},
			{"color", "bbotcdn/core/color.lua", types.FILE},
			{"vector", "bbotcdn/core/vector.lua", types.FILE},
			{"physics", "bbotcdn/core/physics.lua", types.FILE},
			{"pathing", "bbotcdn/core/pathing.lua", types.FILE},
			{"service", "bbotcdn/core/service.lua", types.FILE},
			{"thread", "bbotcdn/core/thread.lua", types.FILE},

			-- non-primitive libraries
			{"hook", "bbotcdn/core/hook.lua", types.FILE},
			{"hookadditions", "bbotcdn/core/hookadditions.lua", types.FILE},
			{"loop", "bbotcdn/core/loop.lua", types.FILE},
			{"iterators", "bbotcdn/core/iterators.lua", types.FILE},
			{"timer", "bbotcdn/core/timer.lua", types.FILE},
			{"asset", "bbotcdn/core/asset.lua", types.FILE},
			{"scripts", "bbotcdn/core/scripts.lua", types.FILE},
			{"statistics", "bbotcdn/core/statistics.lua", types.FILE},
			{"extras", "bbotcdn/core/extras.lua", types.FILE},
			{"draw", "bbotcdn/core/draw.lua", types.FILE},
			{"drawpather", "bbotcdn/core/drawpather.lua", types.FILE},
			{"config", "bbotcdn/core/config.lua", types.FILE},
			{"gui", "bbotcdn/core/gui.lua", types.FILE},
			{"font", "bbotcdn/core/font.lua", types.FILE},
			{"icons", "bbotcdn/core/icons.lua", types.FILE},
			{"guiobjects", "bbotcdn/core/guiobjects.lua", types.FILE},
			{"menu", "bbotcdn/core/menu.lua", types.FILE},
			{"notification", "bbotcdn/core/notification.lua", types.FILE},
		})

		library:AddPackage("presetup", "bbotcdn/loader/presetup.lua", types.FILE)

		if BBOT.game == "phantom forces" then
			library:AddPackage("setup", "bbotcdn/phantom forces/setup.lua", types.FILE)
		end

		library:AddPackage("postsetup", "bbotcdn/loader/postsetup.lua", types.FILE)

		if BBOT.game == "phantom forces" then
			library:BulkAddPackage({
				{"aux", "bbotcdn/phantom forces/auxillary.lua", types.FILE},
				{"chat", "bbotcdn/phantom forces/chat.lua", types.FILE},
				{"votekick", "bbotcdn/phantom forces/votekick.lua", types.FILE},
				{"serverhopper", "bbotcdn/phantom forces/serverhopper.lua", types.FILE},
				{"lighting", "bbotcdn/phantom forces/lighting.lua", types.FILE},
				{"soundoverrides", "bbotcdn/phantom forces/soundoverrides.lua", types.FILE},
				{"repupdate", "bbotcdn/phantom forces/replication.lua", types.FILE},
				{"misc", "bbotcdn/phantom forces/misc.lua", types.FILE},
				{"l3p_player", "bbotcdn/phantom forces/l3p.lua", types.FILE},
				{"spectator", "bbotcdn/phantom forces/spectator.lua", types.FILE},
				{"aimbot", "bbotcdn/phantom forces/aimbot.lua", types.FILE},
				{"esp", "bbotcdn/phantom forces/esp.lua", types.FILE},
				{"weapons", "bbotcdn/phantom forces/weapons.lua", types.FILE},
				{"tracker", "bbotcdn/phantom forces/tracker.lua", types.FILE},
			})
		end
	end
end

BBOT.library:Initialize()