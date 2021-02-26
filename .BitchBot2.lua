local menu
assert(getgenv().v2 == nil)
getgenv().v2 = true

local MenuName = isfile("bitchbot/menuname.txt") and readfile("bitchbot/menuname.txt") or nil
local loadstart = tick()
local Nate = isfile("cole.mak")

local customChatSpam = {}
local e = 2.718281828459045
if isfile("bitchbot/chatspam.txt") then
	local customtxt = readfile("bitchbot/chatspam.txt")
	for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
		table.insert(customChatSpam, s)
	end
end
function map(X, A, B, C, D)
	return (X-A)/(B-A) * (D-C) + C
end
do
	local notes = {}
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
		
		local s = DrawingObject("Text", Color3.new(1,1,1))
		
		s.Text = text
		s.Size = 13
		s.Center = false
		s.Outline = true
		s.Position = Vector2.new()
		s.Font = 2
		
		return s
		
	end
	
	
	function CreateNotification(t, customcolor) -- TODO i want some kind of prioritized message to the notification list, like a warning or something. warnings have icons too maybe? idk??
		
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
				outline = Rectangle(202, width + 2, false, Color3.new(0,0,0)),
				fade = Rectangle(202, width + 2, false, Color3.new(0,0,0)),
			},
			
			Remove = function(self, d)
				if d.Position.x < d.Size.x then
					for k, drawing in pairs(self.drawings) do
						drawing:Remove()
						drawing = false
					end
					self.enabled = false
				end
			end,
			
			Update = function(self, num, listLength, dt)
				local pos = self.targetPos
				
				local indexOffset = (listLength-num)*gap
				if insety < indexOffset then
					insety -= (insety - indexOffset)*0.2
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
				
				local fade = math.min(time*12, alpha)
				fade = fade > 255 and 255 or fade < 0 and 0 or fade
				
				if self.enabled then
					for i, drawing in pairs(self.drawings) do
						drawing.Transparency = fade/255
						
						
						if type(i) == "number" then
							drawing.Position = Vector2.new(locRect.x + 1, locRect.y + i)
							drawing.Size = Vector2.new(locRect.w - 2, 1)
						elseif i == "text" then
							drawing.Position = tpos + Vector2.new(6,2)
						elseif i == "outline" then
							drawing.Position = Vector2.new(locRect.x, locRect.y)
							drawing.Size = Vector2.new(locRect.w, locRect.h)
						elseif i == "fade" then
							drawing.Position = Vector2.new(locRect.x-1, locRect.y-1)
							local t = (200-fade)/255/3
							drawing.Transparency = t < 0.4 and 0.4 or t
						elseif i == "line" then
							drawing.Position = Vector2.new(locRect.x+1, locRect.y+1)
						end
						
					end
					
					time += estep * dt * 128-- TODO need to do the duration
					estep += eestep * dt * 64
					
					
				end
			end,
			
			Fade = function(self, num, len, dt)
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
		}
		
		for i = 1, Note.size.y - 2 do
			local c = 0.28-i/80
			Note.drawings[i] = Rectangle(200, 1, true, Color3.new(c,c,c))
		end
		local color = (menu and menu.GetVal) and customcolor or menu:GetVal("Settings", "Menu Settings", "Menu Accent") and Color3.fromRGB(unpack(menu:GetVal("Settings", "Menu Settings", "Menu Accent", "color"))) or Color3.fromRGB(127, 72, 163)
		
		Note.drawings.text = Text(t)
		if Note.drawings.text.TextBounds.x + 7 > Note.size.x then -- expand the note size to fit if it's less than the default size
			Note.size = Vector2.new(Note.drawings.text.TextBounds.x + 7, Note.size.y)
		end
		Note.drawings.line = Rectangle(1, Note.size.y - 2, true, color)
		
		notes[#notes+1] = Note
		
	end
	
	
	renderStepped = game.RunService.RenderStepped:Connect(function(dt)
		Camera = workspace.CurrentCamera
		local smallest = math.huge
		for k, v in pairs(notes) do
			if v.enabled then
				smallest = k < smallest and k or smallest
			else
				table.remove(notes, k)
			end
		end
		local length = #notes
		for k, note in pairs(notes) do
			note:Update(k, length, dt)
			if k <= math.ceil(length/10) or note.fading then
				note:Fade(k, length, dt)
			end
		end
	end)
	--ANCHOR how to create notification
	--CreateNotification("Loading...")
end

menu = { -- this is for menu stuffs n shi
	w = 500,
	h = 650,
	x = 200,
	y = 300,
	columns = {
		width = 230,
		left = 17,
		right = 253
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
		togz = {}
	},
	mc = {127, 72, 163},
	watermark = {},
	connections = {},
	list = {},
	unloaded = false,
	copied_clr = nil,
	game = "uni",
	tabnames = {}, -- its used to change the tab num to the string (did it like this so its dynamic if u add or remove tabs or whatever :D)
	friends = {},
	priority = {},
	spectating = false,
	stat_menu = false,
	load_time = 0,
	modkeys = {
		alt = {
			direction = nil
		},
		shift = {
			direction = nil
		}
	}
}

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function average(t)
	local sum = 0
		for _,v in pairs(t) do -- Get the sum of all numbers in t
			sum = sum + v
		end
	return sum / #t
end

setreadonly(math, false)

math.clamp = function(a, lowerNum, higher) -- DONT REMOVE this math.clamp is better then roblox's because it doesnt error when its not lower or heigher
	if a > higher then
		return higher
	elseif a < lowerNum then
		return lowerNum
	else
		return a
	end
end

setreadonly(math, true)

function menu:modkeydown(key, direction)
	local keydata = self.modkeys[key]
	return keydata.direction and keydata.direction == direction or false
end

function CreateThread(func, ...) -- improved... yay.
	local thread = coroutine.create(func)
	coroutine.resume(thread, ...)
	return thread
end

function MultiThreadList(obj, ...)
	for i, v in pairs(obj) do
		CreateThread(v, ...)
	end
end

local DeepRestoreTableFunctions
DeepRestoreTableFunctions = function(tbl)
	for k, v in next, tbl do
		if type(v) == "function" and is_synapse_function(v) then
			for k1, v1 in next, getupvalues(v) do
				if type(v1) == "function" and islclosure(v1) and not is_synapse_function(v1) then
					tbl[k] = v1
				end
			end
		end

		if type(v) == "table" then
			DeepRestoreTableFunctions(v)
		end
	end
end

local event = {}

local allevent = {}

function event.new(eventname, eventtable, requirename) -- fyi you can put in a table of choice to make the table you want an "event" pretty cool its like doing & in c lol!
	if eventname then
		assert(allevent[eventname] ~= nil, ("the event '%s' already exists in the event table"):format(eventname))
	end
	local newevent = eventtable or {}
	local funcs = {}
	local disconnectlist = {}

	function newevent:connect(func)
		funcs[#funcs + 1] = func
		local disconnected = false
		local function disconnect()
			if not disconnected then
				disconnected = true
				disconnectlist[func] = true
			end
		end
		return disconnect
	end

	local function fire(...)
		local n = #funcs
		local j = 0
		for i = 1, n do
			local func = funcs[i]
			if disconnectlist[func] then
				disconnectlist[func] = nil
			else
				j = j + 1
				funcs[j] = func
			end
		end
		for i = j + 1, n do
			funcs[i] = nil
		end
		for i = 1, j do
			CreateThread(function(...)
				pcall(funcs[i], ...)
			end, ...)
		end
	end

	if eventname then
		allevent[eventname] = {
			event = newevent,
			fire = fire
		}
	end

	return newevent, fire
end

local function FireEvent(eventname, ...)
	if allevent[eventname] then
		return allevent[eventname].fire(...)
	else
		warn(("Event %s does not exist!"):format(eventname))
	end
end

local function GetEvent(eventname)
	return allevent[eventname]
end


local BBOT_IMAGES = {}
MultiThreadList({
	function() BBOT_IMAGES[1] = game:HttpGet("https://i.imgur.com/9NMuFcQ.png") end,
	function() BBOT_IMAGES[2] = game:HttpGet("https://i.imgur.com/jG3NjxN.png") end,
	function() BBOT_IMAGES[3] = game:HttpGet("https://i.imgur.com/2Ty4u2O.png") end,
	function() BBOT_IMAGES[4] = game:HttpGet("https://i.imgur.com/kNGuTlj.png") end,
	function() BBOT_IMAGES[5] = game:HttpGet("https://i.imgur.com/OZUR3EY.png") end,
	function() BBOT_IMAGES[6] = game:HttpGet("https://i.imgur.com/3HGuyVa.png") end
})

-- MULTITHREAD DAT LOADING SO FAST!!!!
local loaded = {}
do
	local function Loopy_Image_Checky()
		for i = 1, 5 do
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

loadstart = tick()

if game.PlaceId == 292439477 or game.PlaceId == 299659045 or game.PlaceId == 5281922586 or game.PlaceId == 3568020459 then -- they sometimes open 5281922586
	menu.game = "pf"
	do
		for _,v in pairs(getgc()) do
			if type(v) == 'function' then
				for _,u in pairs(debug.getupvalues(v)) do
					if type(u) == 'table'and rawget(u, 'send') then
						net = u
					end
				end
			end
		end
		
		repeat
			game.RunService.Heartbeat:Wait()
		until net and not net.add
		local annoyingFuckingMusic = workspace:FindFirstChild"memes"
		if annoyingFuckingMusic then
			annoyingFuckingMusic:Destroy()
		end
	end -- wait for framwork to load
end

-- nate i miss u D:

-- im back
local NETWORK = game:service("NetworkClient")
NETWORK:SetOutgoingKBPSLimit(0)

setfpscap(300)

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

if not isfolder("bitchbot/".. menu.game) then
	makefolder("bitchbot/".. menu.game)
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
		writefile("bitchbot/".. menu.game .."/Default.bb", "")
	end
	return result
end

local Players = game:GetService("Players")
local stats = game:GetService("Stats")

local function UnpackRelations()
	local str = isfile("bitchbot/relations.bb") and readfile("bitchbot/relations.bb") or nil
	
	local final = {
		friends = {},
		priority = {}
	}
	
	if str then
		local tb = {}
		for k,v in str:gmatch "{[%a]+:.[%d,%s+]+[}]" do
			tb[#tb + 1] = k
		end
		
		for _, data in next, tb do
			local cellname = data:match("%a+")
			if final[cellname] then
				for k,v in data:gmatch "%d+[^,}]" do
					local status, ret = pcall(function() -- wrapping this in a pcall since roblox will throw an error if the player user ID does not exist
						local playername = Players:GetNameFromUserIdAsync(tonumber(k))
						table.insert(final[cellname], 1, playername)
					end)
					if not status then
						CreateNotification(string.format("Error occurred while identifying player \"%s\" (%s player). See debuglog.bb", k, cellname))
						appendfile("bitchbot/debuglog.bb", tostring(ret) .. "\n" .. debug.traceback() .. "\n\n")
					end
				end
			end
		end
	end
	
	menu.friends = final.friends
	menu.priority = final.priority
end

CreateThread(function()
	UnpackRelations()
	if (not menu or not menu.GetVal) then
		repeat game.RunService.Heartbeat:Wait() until (menu and menu.GetVal)
	end
	if #menu.friends > 0 and #menu.priority > 0 then
		CreateNotification(string.format("Finished reading relations.bb file with %d friends and %d priority players", #menu.friends, #menu.priority))
	end
end)

local function WriteRelations()
	local str = "bb:{{friends:"
	
	for k,v in next, menu.friends do
		local playerobj
		local userid
		local pass, ret = pcall(function()
			playerobj = Players[v]
		end)
		
		if not pass then
			local newpass, newret = pcall(function()
				userid = Players:GetUserIdFromNameAsync(v)
			end)
		end
		
		if userid then
			str = str .. tostring(userid) .. ","
		else
			str = str .. tostring(playerobj.UserId) .. ","
		end
	end
	
	str = str .. "}{priority:"
	
	for k,v in next, menu.priority do
		local playerobj
		local userid
		local pass, ret = pcall(function()
			playerobj = Players[v]
		end)
		
		if not pass then
			local newpass, newret = pcall(function()
				userid = Players:GetUserIdFromNameAsync(v)
			end)
		end
		
		if userid then
			str = str .. tostring(userid) .. ","
		else
			str = str .. tostring(playerobj.UserId) .. ","
		end
	end
	
	str = str .. "}}"
	
	writefile("bitchbot/relations.bb", str)
end

local LOCAL_PLAYER = Players.LocalPlayer
local LOCAL_MOUSE = LOCAL_PLAYER:GetMouse()
local TEAMS = game:GetService("Teams")
local INPUT_SERVICE = game:GetService("UserInputService")
--local GAME_SETTINGS = UserSettings():GetService("UserGameSettings")
local CACHED_VEC3 = Vector3.new()
local Camera = workspace.CurrentCamera
local SCREEN_SIZE = Camera.ViewportSize
local ButtonPressed = Instance.new("BindableEvent")
local TogglePressed = Instance.new("BindableEvent")
--local PATHFINDING = game:GetService("PathfindingService")
local GRAVITY = Vector3.new(0,-192.6, 0)

menu.x = math.floor((SCREEN_SIZE.x/2) - (menu.w/2))
menu.y = math.floor((SCREEN_SIZE.y/2) - (menu.h/2))

local function IsKeybindDown(tab, group, name, on_nil)
	local key = menu:GetVal(tab, group, name, "keybind")
	if on_nil then
		return key == nil or INPUT_SERVICE:IsKeyDown(key)
	elseif key ~= nil then
		return INPUT_SERVICE:IsKeyDown(key)
	end
	return false
end


Lerp = function(delta, from, to)
	if (delta > 1) then
		return to
	end
	if (delta < 0) then
		return from
	end
	return from + ( to - from ) * delta
end

ColorRange = function(value, ranges) -- ty tony for dis function u a homie
	if value <= ranges[1].start then return ranges[1].color end
	if value >= ranges[#ranges].start then return ranges[#ranges].color end
	
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
	return Color3.new(Lerp( lerpValue, minColor.color.r, maxColor.color.r ), Lerp( lerpValue, minColor.color.g, maxColor.color.g ), Lerp( lerpValue, minColor.color.b, maxColor.color.b ))
end


local bVector2 = {}
do -- vector functions
	function bVector2:getRotate(Vec, Rads)
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
local bColor = {}
do -- color functions
	function bColor:Mult(col, mult)
		return Color3.new(col.R*mult,col.G*mult,col.B*mult)
	end
	function bColor:Add(col, num)
		return Color3.new(col.R+num,col.G+num,col.B+num)
	end
	
end
function string_cut(s1, num)
	return num == 0 and s1 or string.sub(s1, 1, num)
end

local textBoxLetters = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	
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
	"Z"
}

local keyNames = {
	One    = "1",
	Two    = "2",
	Three  = "3",
	Four   = "4",
	Five   = "5",
	Six    = "6",
	Seven  = "7",
	Eight  = "8",
	Nine   = "9",
	Zero   = "0",
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
	Multiply = "x",
	PageUp = "PgUp",
	PageDown = "PgDown",
	Delete = "Del",
	Insert = "Ins",
	NumLock = "NumL",
	Comma = ",",
	Period = "."
}
local colemak = {
	E = "F", R = "P", T = "G", Y = "J", U = "L", I = "U", O = "Y", P = ";",
	S = "R", D = "S", F = "T", G = "D", J = "N", K = "E", L = "I", [";"] = "O",
	N = "K",
}
local function KeyEnumToName(key) -- did this all in a function cuz why not
	if key == nil then
		return "None"
	end
	local _key = tostring(key).. "."
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

local allrender = {}


local RGB = Color3.fromRGB
local Draw = {}
do
	function Draw:UnRender()
		for k, v in pairs(allrender) do
			for k1, v1 in pairs(v) do
				v1:Remove()
			end
		end
	end
	--TODO rename all the functions to be CamelCased and
	--put all related funcs into tables
	function Draw:OutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
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
	
	function Draw:FilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
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
	
	function Draw:Line(visible, thickness, start_x, start_y, end_x, end_y, clr, tablename)
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
	
	function Draw:Image(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		local temptable = Drawing.new("Image")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, height)
		temptable.Transparency = transparency
		temptable.Data = imagedata
		table.insert(tablename, temptable)
		if not table.find(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end
	
	function Draw:Text(text, font, visible, pos_x, pos_y, size, centered, clr, tablename)
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
	
	function Draw:OutlinedText(text, font, visible, pos_x, pos_y, size, centered, clr, clr2, tablename)
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
	
	function Draw:Triangle(visible, filled, pa, pb, pc, clr, tablename)
		clr = clr or {255,255,255,1}
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
	
	function Draw:Circle(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
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
	
	function Draw:FilledCircle(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
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
	
	
	--ANCHOR MENU ELEMENTS
	
	function Draw:MenuOutlinedRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:OutlinedRect(visible, pos_x + menu.x, pos_y + menu.y, width, height, clr, tablename)
		table.insert(menu.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	function Draw:MenuFilledRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:FilledRect(visible, pos_x + menu.x, pos_y + menu.y, width, height, clr, tablename)
		table.insert(menu.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	function Draw:MenuImage(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		Draw:Image(visible, imagedata, pos_x + menu.x, pos_y + menu.y, width, height, transparency, tablename)
		table.insert(menu.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	function Draw:MenuBigText(text, visible, centered, pos_x, pos_y, tablename)
		local text = Draw:OutlinedText(text, 2, visible, pos_x + menu.x, pos_y + menu.y, 13, centered, {255, 255, 255, 255}, {0, 0, 0}, tablename)
		table.insert(menu.postable, {tablename[#tablename], pos_x, pos_y})
		return text
	end
	
	
	function Draw:CoolBox(name, x, y, width, height, tab)
		Draw:MenuOutlinedRect(true, x, y, width, height, {0, 0, 0, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, width - 2, height - 2, {20, 20, 20, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 2, y + 2, width - 3, 1, {127, 72, 163, 255}, tab)
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 3, width - 3, 1, {87, 32, 123, 255}, tab)
		table.insert(menu.clrs.dark, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 4, width - 3, 1, {20, 20, 20, 255}, tab)
		Draw:MenuBigText(name, true, false, x + 6, y + 5, tab)
	end
	
	
	
	function Draw:Toggle(name, value, unsafe, x, y, tab)
		Draw:MenuOutlinedRect(true, x, y, 12, 12, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, 10, 10, {0, 0, 0, 255}, tab)
		
		local temptable = {}
		for i = 0, 3 do
			Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), 8, 2, {0, 0, 0, 255}, tab)
			table.insert(temptable, tab[#tab])
			if value then
				tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])}, [2] = {start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40)}})
			else
				tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
			end
		end
		
		Draw:MenuBigText(name, true, false, x + 16, y - 1, tab)
		if unsafe == true then
			tab[#tab].Color = RGB(245, 239, 120)
		end
		table.insert(temptable, tab[#tab])
		return temptable
	end
	
	function Draw:Keybind(key, x, y, tab)
		local temptable = {}
		Draw:MenuFilledRect(true, x, y, 44, 16, {25, 25, 25, 255}, tab)
		Draw:MenuBigText(KeyEnumToName(key), true, true, x + 22, y + 1, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x, y, 44, 16, {30, 30, 30, 255}, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 1, y + 1, 42, 14, {0, 0, 0, 255}, tab)
		
		return temptable
	end
	
	function Draw:ColorPicker(color, x, y, tab)
		local temptable = {}
		
		Draw:MenuOutlinedRect(true, x, y, 28, 14, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, 26, 12, {0, 0, 0, 255}, tab)
		
		Draw:MenuFilledRect(true, x + 2, y + 2, 24, 10, {color[1], color[2], color[3], 255}, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 2, y + 2, 24, 10, {color[1] - 40, color[2] - 40, color[3] - 40, 255}, tab)
		table.insert(temptable, tab[#tab])
		Draw:MenuOutlinedRect(true, x + 3, y + 3, 22, 8, {color[1] - 40, color[2] - 40, color[3] - 40, 255}, tab)
		table.insert(temptable, tab[#tab])
		
		return temptable
	end
	
	function Draw:Slider(name, stradd, value, minvalue, maxvalue, x, y, length, tab)
		Draw:MenuBigText(name, true, false, x, y - 3, tab)
		
		for i = 0, 3 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
		end
		
		local temptable = {}
		for i = 0, 3 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), (length - 4) * ((value - minvalue) / (maxvalue - minvalue)), 2, {0, 0, 0, 255}, tab)
			table.insert(temptable, tab[#tab])
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])}, [2] = {start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40)}})
		end
		Draw:MenuOutlinedRect(true, x, y + 12, length, 12, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 10, {0, 0, 0, 255}, tab)
		
		if stradd == nil then
			stradd = ""
		end
		Draw:MenuBigText(tostring(value).. stradd, true, true, x + (length * 0.5) , y + 11 , tab)
		table.insert(temptable, tab[#tab])
		table.insert(temptable, stradd)
		return temptable
	end
	
	function Draw:Dropbox(name, value, values, x, y, length, tab)
		local temptable = {}
		Draw:MenuBigText(name, true, false, x, y - 3, tab)
		
		for i = 0, 7 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
		end
		
		Draw:MenuOutlinedRect(true, x, y + 12, length, 22, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 20, {0, 0, 0, 255}, tab)
		
		Draw:MenuBigText(tostring(values[value]), true, false, x + 6, y + 16 , tab)
		table.insert(temptable, tab[#tab])
		
		Draw:MenuBigText("-", true, false, x - 17 + length, y + 16, tab)
		table.insert(temptable, tab[#tab])
		
		return temptable
	end
	
	function Draw:Combobox(name, values, x, y, length, tab)
		local temptable = {}
		Draw:MenuBigText(name, true, false, x, y - 3, tab)
		
		for i = 0, 7 do
			Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
		end
		
		Draw:MenuOutlinedRect(true, x, y + 12, length, 22, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 20, {0, 0, 0, 255}, tab)
		local textthing = ""
		for k, v in pairs(values) do
			if v[2] then
				if textthing == "" then
					textthing = v[1]
				else
					textthing = textthing.. ", ".. v[1]
				end
			end
		end
		if string.len(textthing) > 25 then
			textthing = string_cut(textthing, 25)
		end
		textthing = textthing ~= "" and textthing or "None"
		Draw:MenuBigText(textthing, true, false, x + 6, y + 16 , tab)
		table.insert(temptable, tab[#tab])
		
		Draw:MenuBigText("...", true, false, x - 27 + length, y + 16, tab)
		table.insert(temptable, tab[#tab])
		
		return temptable
	end
	
	function Draw:Button(name, x, y, length, tab)
		local temptable = {}
		
		for i = 0, 8 do
			Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
			table.insert(temptable, tab[#tab])
		end
		
		Draw:MenuOutlinedRect(true, x, y, length, 22, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, {0, 0, 0, 255}, tab)
		temptable.text = Draw:MenuBigText(name, true, true, x + math.floor(length * 0.5), y + 4 , tab)
		
		return temptable
	end
	
	function Draw:List(name, x, y, length, maxamount, colums, tab)
		local temptable = {uparrow = {}, downarrow = {}, liststuff = {rows = {}, words = {}}}
		
		for i, v in ipairs(name) do
			Draw:MenuBigText(v, true, false, (math.floor(length/colums) * i) - math.floor(length/colums) + 30, y - 3, tab)
		end
		
		Draw:MenuOutlinedRect(true, x, y + 12, length, 22 * maxamount + 4, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 22 * maxamount + 2, {0, 0, 0, 255}, tab)
		
		Draw:MenuFilledRect(true, x + length - 7, y + 16, 1, 1, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, tab)
		table.insert(temptable.uparrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(true, x + length - 8, y + 17, 3, 1, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, tab)
		table.insert(temptable.uparrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(true, x + length - 9, y + 18, 5, 1, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, tab)
		table.insert(temptable.uparrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		
		Draw:MenuFilledRect(true, x + length - 7, y + 16 + (22 * maxamount + 4) - 9, 1, 1, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, tab)
		table.insert(temptable.downarrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(true, x + length - 8, y + 16 + (22 * maxamount + 4) - 10, 3, 1, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, tab)
		table.insert(temptable.downarrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		Draw:MenuFilledRect(true, x + length - 9, y + 16 + (22 * maxamount + 4) - 11, 5, 1, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, tab)
		table.insert(temptable.downarrow, tab[#tab])
		table.insert(menu.clrs.norm, tab[#tab])
		
		
		for i = 1, maxamount do
			temptable.liststuff.rows[i] = {}
			if i ~= maxamount then
				Draw:MenuOutlinedRect(true, x + 4, (y + 13) + (22 * i) , length - 8, 2, {20, 20, 20, 255}, tab)
				table.insert(temptable.liststuff.rows[i], tab[#tab])
			end
			
			if colums ~= nil then
				for i1 = 1, colums - 1 do
					Draw:MenuOutlinedRect(true, x + math.floor(length/colums) * i1, (y + 13) + (22 * i) - 18 , 2, 16, {20, 20, 20, 255}, tab)
					table.insert(temptable.liststuff.rows[i], tab[#tab])
				end
			end
			
			temptable.liststuff.words[i] = {}
			if colums ~= nil then
				for i1 = 1, colums do
					Draw:MenuBigText("", true, false, (x + math.floor(length/colums) * i1) - math.floor(length/colums) + 5 , (y + 13) + (22 * i) - 16, tab)
					table.insert(temptable.liststuff.words[i], tab[#tab])
				end
			else
				Draw:MenuBigText("", true, false, x + 5, (y + 13) + (22 * i) - 16, tab)
				table.insert(temptable.liststuff.words[i], tab[#tab])
			end
		end
		
		return temptable
	end
	
	function Draw:ImageWithText(size, image, text, x, y, tab)
		local temptable = {}
		Draw:MenuOutlinedRect(true, x, y, size + 4, size + 4, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, size + 2, size + 2, {0, 0, 0, 255}, tab)
		Draw:MenuFilledRect(true, x + 2, y + 2, size, size, {40, 40, 40, 255}, tab)
		
		Draw:MenuBigText(text, true, false, x + size + 8, y, tab)
		table.insert(temptable, tab[#tab])
		
		Draw:MenuImage(true, BBOT_IMAGES[5], x + 2, y + 2, size, size, 1, tab)
		table.insert(temptable, tab[#tab])
		
		return temptable
	end
	
	function Draw:TextBox(name, text, x, y, length, tab)
		for i = 0, 8 do
			Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
		end
		
		Draw:MenuOutlinedRect(true, x, y, length, 22, {30, 30, 30, 255}, tab)
		Draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, {0, 0, 0, 255}, tab)
		Draw:MenuBigText(text, true, false, x + 6, y + 4 , tab)
		
		return tab[#tab]
	end
end

--funny graf
local networkin = {
	incoming = {},
	outgoing = {}
}

for i = 1, 21 do
	networkin.incoming[i] = 20
	networkin.outgoing[i] = 2
end
local lasttick = tick()

local infopos = 400

local graphs = {
	incoming = {
		pos = {
			x = 35,
			y = infopos
		},
		sides = {},
		graph = {}
	},
	outgoing = {
		pos = {
			x = 35,
			y = infopos + 97
		},
		sides = {},
		graph = {}
	},
	other = {}
}
--- incoming
Draw:OutlinedText("incoming kbps: 20", 2, false, graphs.incoming.pos.x - 1, graphs.incoming.pos.y - 15, 13, false, {255, 255, 255, 255}, {10, 10, 10}, graphs.incoming.sides)
Draw:OutlinedText("80", 2, false, graphs.incoming.pos.x - 21, graphs.incoming.pos.y - 7, 13, false, {255, 255, 255, 255}, {10, 10, 10}, graphs.incoming.sides)

Draw:FilledRect(false,  graphs.incoming.pos.x - 1, graphs.incoming.pos.y - 1, 222, 82, {10, 10, 10, 50}, graphs.incoming.sides)

Draw:Line(false, 3, graphs.incoming.pos.x, graphs.incoming.pos.y - 1, graphs.incoming.pos.x, graphs.incoming.pos.y + 82, {20, 20, 20, 225}, graphs.incoming.sides)
Draw:Line(false, 3, graphs.incoming.pos.x, graphs.incoming.pos.y + 80, graphs.incoming.pos.x + 221, graphs.incoming.pos.y + 80, {20, 20, 20, 225}, graphs.incoming.sides)
Draw:Line(false, 3, graphs.incoming.pos.x, graphs.incoming.pos.y, graphs.incoming.pos.x - 6, graphs.incoming.pos.y, {20, 20, 20, 225}, graphs.incoming.sides)

Draw:Line(false, 1, graphs.incoming.pos.x, graphs.incoming.pos.y, graphs.incoming.pos.x, graphs.incoming.pos.y + 80, {255, 255, 255, 225}, graphs.incoming.sides)
Draw:Line(false, 1, graphs.incoming.pos.x, graphs.incoming.pos.y + 80, graphs.incoming.pos.x + 220, graphs.incoming.pos.y + 80, {255, 255, 255, 225}, graphs.incoming.sides)
Draw:Line(false, 1, graphs.incoming.pos.x, graphs.incoming.pos.y, graphs.incoming.pos.x - 5, graphs.incoming.pos.y, {255, 255, 255, 225}, graphs.incoming.sides)

for i = 1, 20 do
	Draw:Line(false, 1, 10, 10, 10, 10, {255, 255, 255, 225}, graphs.incoming.graph)
end

Draw:Line(false, 1, 10, 10, 10, 10, {68, 255, 0, 255}, graphs.incoming.graph)
Draw:OutlinedText("avg: 20", 2, false, 20, 20, 13, false, {68, 255, 0, 255}, {10, 10, 10}, graphs.incoming.graph)

--- outgoing
Draw:OutlinedText("outgoing kbps: 5", 2, false, graphs.outgoing.pos.x - 1, graphs.outgoing.pos.y - 15, 13, false, {255, 255, 255, 255}, {10, 10, 10}, graphs.outgoing.sides)
Draw:OutlinedText("10", 2, false, graphs.outgoing.pos.x - 21, graphs.outgoing.pos.y - 7, 13, false, {255, 255, 255, 255}, {10, 10, 10}, graphs.outgoing.sides)

Draw:FilledRect(false,  graphs.outgoing.pos.x - 1, graphs.outgoing.pos.y - 1, 222, 82, {10, 10, 10, 50}, graphs.outgoing.sides)

Draw:Line(false, 3, graphs.outgoing.pos.x, graphs.outgoing.pos.y - 1, graphs.outgoing.pos.x, graphs.outgoing.pos.y + 82, {20, 20, 20, 225}, graphs.outgoing.sides)
Draw:Line(false, 3, graphs.outgoing.pos.x, graphs.outgoing.pos.y + 80, graphs.outgoing.pos.x + 221, graphs.outgoing.pos.y + 80, {20, 20, 20, 225}, graphs.outgoing.sides)
Draw:Line(false, 3, graphs.outgoing.pos.x, graphs.outgoing.pos.y, graphs.outgoing.pos.x - 6, graphs.outgoing.pos.y, {20, 20, 20, 225}, graphs.outgoing.sides)

Draw:Line(false, 1, graphs.outgoing.pos.x, graphs.outgoing.pos.y, graphs.outgoing.pos.x, graphs.outgoing.pos.y + 80, {255, 255, 255, 225}, graphs.outgoing.sides)
Draw:Line(false, 1, graphs.outgoing.pos.x, graphs.outgoing.pos.y + 80, graphs.outgoing.pos.x + 220, graphs.outgoing.pos.y + 80, {255, 255, 255, 225}, graphs.outgoing.sides)
Draw:Line(false, 1, graphs.outgoing.pos.x, graphs.outgoing.pos.y, graphs.outgoing.pos.x - 5, graphs.outgoing.pos.y, {255, 255, 255, 225}, graphs.outgoing.sides)

for i = 1, 20 do
	Draw:Line(false, 1, 10, 10, 10, 10, {255, 255, 255, 225}, graphs.outgoing.graph)
end

Draw:Line(false, 1, 10, 10, 10, 10, {68, 255, 0, 255}, graphs.outgoing.graph)
Draw:OutlinedText("avg: 20", 2, false, 20, 20, 13, false, {68, 255, 0, 255}, {10, 10, 10}, graphs.outgoing.graph)
-- the fuckin fps and stuff i think xDDDDDd

Draw:OutlinedText("loading...", 2, false, 35, infopos + 180, 13, false, {255, 255, 255, 255}, {10, 10, 10}, graphs.other)

-- finish

local loadingthing = Draw:OutlinedText("Loading...", 2, true, math.floor(SCREEN_SIZE.x/16), math.floor(SCREEN_SIZE.y/16), 13, true, {255, 50, 200, 255}, {0, 0, 0})

function menu.Initialize(menutable)
	local bbmenu = {} -- this one is for the rendering n shi
	do
		Draw:MenuOutlinedRect(true, 0, 0, menu.w, menu.h, {0, 0, 0, 255}, bbmenu)  -- first gradent or whatever
		Draw:MenuOutlinedRect(true, 1, 1, menu.w - 2, menu.h - 2, {20, 20, 20, 255}, bbmenu)
		Draw:MenuOutlinedRect(true, 2, 2, menu.w - 3, 1, {127, 72, 163, 255}, bbmenu)
		table.insert(menu.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 3, menu.w - 3, 1, {87, 32, 123, 255}, bbmenu)
		table.insert(menu.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 4, menu.w - 3, 1, {20, 20, 20, 255}, bbmenu)
		
		for i = 0, 19 do
			Draw:MenuFilledRect(true, 2, 5 + i, menu.w - 4, 1, {20, 20, 20, 255}, bbmenu)
			bbmenu[6 + i].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 20, color = RGB(35, 35, 35)}})
		end
		Draw:MenuFilledRect(true, 2, 25, menu.w - 4, menu.h - 27, {35, 35, 35, 255}, bbmenu)
		
		Draw:MenuBigText("Bitch Bot", true, false, 6, 6, bbmenu)
		
		Draw:MenuOutlinedRect(true, 8, 22, menu.w - 16, menu.h - 30, {0, 0, 0, 255}, bbmenu)    -- all this shit does the 2nd gradent
		Draw:MenuOutlinedRect(true, 9, 23, menu.w - 18, menu.h - 32, {20, 20, 20, 255}, bbmenu)
		Draw:MenuOutlinedRect(true, 10, 24, menu.w - 19, 1, {127, 72, 163, 255}, bbmenu)
		table.insert(menu.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 10, 25, menu.w - 19, 1, {87, 32, 123, 255}, bbmenu)
		table.insert(menu.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 10, 26, menu.w - 19, 1, {20, 20, 20, 255}, bbmenu)
		
		for i = 0, 14 do
			Draw:MenuFilledRect(true, 10, 27 + (i * 2), menu.w - 20, 2, {45, 45, 45, 255}, bbmenu)
			bbmenu[#bbmenu].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 15, color = RGB(35, 35, 35)}})
		end
		Draw:MenuFilledRect(true, 10, 57, menu.w - 20, menu.h - 67, {35, 35, 35, 255}, bbmenu)
		
		
	end
	-- ok now the cool part :D
	--ANCHOR menu stuffz
	
	local tabz = {}
	for i = 1, #menutable do
		tabz[i] = {}
	end
	
	local tabs = {} -- i like tabby catz 🐱🐱🐱
	
	for k, v in pairs(menutable) do
		Draw:MenuFilledRect(true, 10 + ((k - 1) * ((menu.w - 20)/#menutable)), 27, ((menu.w - 20)/#menutable), 32, {30, 30, 30, 255}, bbmenu)
		Draw:MenuOutlinedRect(true, 10 + ((k - 1) * ((menu.w - 20)/#menutable)), 27, ((menu.w - 20)/#menutable), 32, {20, 20, 20, 255}, bbmenu)
		Draw:MenuBigText(v.name, true, true, math.floor(10 + ((k - 1) * ((menu.w - 20)/#menutable)) + (((menu.w - 20)/#menutable)*0.5)), 35, bbmenu)
		table.insert(tabs, {bbmenu[#bbmenu - 2], bbmenu[#bbmenu - 1], bbmenu[#bbmenu]})
		table.insert(menu.tabnames, v.name)
		
		menu.options[v.name] = {}
		
		local y_offies = {left = 66, right = 66}
		if v.content ~= nil then
			for k1, v1 in pairs(v.content) do
				if v1.autopos ~= nil then
					v1.width = 230
					if v1.autopos == "left" then
						v1.x = 17
						v1.y = y_offies.left
					elseif v1.autopos == "right" then
						v1.x = 253
						v1.y = y_offies.right
					end
				end
				
				local y_pos = 24
				
				menu.options[v.name][v1.name] = {}
				if v1.content ~= nil then
					
					for k2, v2 in pairs(v1.content) do
						if v2.type == "toggle" then
							menu.options[v.name][v1.name][v2.name] = {}
							local unsafe = false
							if v2.unsafe then
								unsafe = true
							end
							menu.options[v.name][v1.name][v2.name][4] = Draw:Toggle(v2.name, v2.value, unsafe, v1.x + 8, v1.y + y_pos, tabz[k])
							menu.options[v.name][v1.name][v2.name][1] = v2.value
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1}
							menu.options[v.name][v1.name][v2.name][6] = unsafe
							if v2.extra ~= nil then
								if v2.extra.type == "keybind" then
									menu.options[v.name][v1.name][v2.name][5] = {}
									menu.options[v.name][v1.name][v2.name][5][4] = Draw:Keybind(v2.extra.key, v1.x + v1.width - 52, y_pos + v1.y - 2, tabz[k])
									menu.options[v.name][v1.name][v2.name][5][1] = v2.extra.key
									menu.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
									menu.options[v.name][v1.name][v2.name][5][3] = {v1.x + v1.width - 52, y_pos + v1.y - 2}
									menu.options[v.name][v1.name][v2.name][5][5] = false
								elseif v2.extra.type == "single colorpicker" then
									menu.options[v.name][v1.name][v2.name][5] = {}
									menu.options[v.name][v1.name][v2.name][5][4] = Draw:ColorPicker(v2.extra.color, v1.x + v1.width - 38, y_pos + v1.y - 1, tabz[k])
									menu.options[v.name][v1.name][v2.name][5][1] = v2.extra.color
									menu.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
									menu.options[v.name][v1.name][v2.name][5][3] = {v1.x + v1.width - 38, y_pos + v1.y - 1}
									menu.options[v.name][v1.name][v2.name][5][5] = false
									menu.options[v.name][v1.name][v2.name][5][6] = v2.extra.name
								elseif v2.extra.type == "double colorpicker" then
									menu.options[v.name][v1.name][v2.name][5] = {}
									menu.options[v.name][v1.name][v2.name][5][1] = {}
									menu.options[v.name][v1.name][v2.name][5][1][1] = {}
									menu.options[v.name][v1.name][v2.name][5][1][2] = {}
									menu.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
									for i = 1, 2 do
										menu.options[v.name][v1.name][v2.name][5][1][i][4] = Draw:ColorPicker(v2.extra.color[i], v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1, tabz[k])
										menu.options[v.name][v1.name][v2.name][5][1][i][1] = v2.extra.color[i]
										menu.options[v.name][v1.name][v2.name][5][1][i][3] = {v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1}
										menu.options[v.name][v1.name][v2.name][5][1][i][5] = false
										menu.options[v.name][v1.name][v2.name][5][1][i][6] = v2.extra.name[i]
									end
								end
							end
							y_pos += 18
						elseif v2.type == "slider" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][4] = Draw:Slider(v2.name, v2.stradd, v2.value, v2.minvalue, v2.maxvalue, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							menu.options[v.name][v1.name][v2.name][1] = v2.value
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							menu.options[v.name][v1.name][v2.name][5] = false
							menu.options[v.name][v1.name][v2.name][6] = {v2.minvalue, v2.maxvalue}
							menu.options[v.name][v1.name][v2.name][7] = {v1.x + 7 + v1.width - 38, v1.y + y_pos - 1}
							menu.options[v.name][v1.name][v2.name].round = v2.rounded == nil and true or v2.rounded
							menu.options[v.name][v1.name][v2.name].stepsize = v2.stepsize
							menu.options[v.name][v1.name][v2.name].custom = v2.custom or {}
							
							y_pos += 30
						elseif v2.type == "dropbox" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][1] = v2.value
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name][5] = false
							menu.options[v.name][v1.name][v2.name][6] = v2.values
							
							if v2.x == nil then
								menu.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
								menu.options[v.name][v1.name][v2.name][4] = Draw:Dropbox(v2.name, v2.value, v2.values, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
								y_pos += 40
							else
								menu.options[v.name][v1.name][v2.name][3] = {v2.x + 7, v2.y - 1, v2.w}
								menu.options[v.name][v1.name][v2.name][4] = Draw:Dropbox(v2.name, v2.value, v2.values, v2.x + 8, v2.y, v2.w, tabz[k])
							end
						elseif v2.type == "combobox" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][4] = Draw:Combobox(v2.name, v2.values, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							menu.options[v.name][v1.name][v2.name][1] = v2.values
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							menu.options[v.name][v1.name][v2.name][5] = false
							y_pos += 40
						elseif v2.type == "button" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][1] = false
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name].name = v2.name
							menu.options[v.name][v1.name][v2.name].groupbox = v1.name
							menu.options[v.name][v1.name][v2.name].tab = v.name -- why is it all v, v1, v2 so ugly
							menu.options[v.name][v1.name][v2.name].doubleclick = v2.doubleclick
							
							if v2.x == nil then
								menu.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
								menu.options[v.name][v1.name][v2.name][4] = Draw:Button(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
								y_pos += 28
							else
								menu.options[v.name][v1.name][v2.name][3] = {v2.x + 7, v2.y - 1, v2.w}
								menu.options[v.name][v1.name][v2.name][4] = Draw:Button(v2.name, v2.x + 8, v2.y, v2.w, tabz[k])
							end
						elseif v2.type == "textbox" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][4] = Draw:TextBox(v2.name, v2.text, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							menu.options[v.name][v1.name][v2.name][1] = v2.text
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							menu.options[v.name][v1.name][v2.name][5] = false
							y_pos += 28
						elseif v2.type == "list" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][4] = Draw:List(v2.multiname, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.colums, tabz[k])
							menu.options[v.name][v1.name][v2.name][1] = nil
							menu.options[v.name][v1.name][v2.name][2] = v2.type
							menu.options[v.name][v1.name][v2.name][3] = 1
							menu.options[v.name][v1.name][v2.name][5] = {}
							menu.options[v.name][v1.name][v2.name][6] = v2.size
							menu.options[v.name][v1.name][v2.name][7] = v2.colums
							menu.options[v.name][v1.name][v2.name][8] = {v1.x + 8, v1.y + y_pos, v1.width - 16}
							y_pos += 22 + (22 * v2.size)
						elseif v2.type == "image" then
							menu.options[v.name][v1.name][v2.name] = {}
							menu.options[v.name][v1.name][v2.name][1] = Draw:ImageWithText(v2.size, nil, v2.text, v1.x + 8, v1.y + y_pos, tabz[k])
							menu.options[v.name][v1.name][v2.name][2] = v2.type
						end
					end
				end
				y_pos += 2
				if v1.autopos == nil then
					Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
				else
					if v1.autofill then
						y_pos = (menu.h - 17) - (v1.y)
					end
					Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, y_pos, tabz[k])
					y_offies[v1.autopos] += y_pos + 6
				end
			end
		end
	end
	
	menu.list.addval = function(list, option)
		table.insert(list[5], option)
	end
	
	menu.list.removeval = function(list, optionnum)
		if list[1] == optionnum then
			list[1] = nil
		end
		table.remove(list[5], optionnum)
	end
	
	menu.list.removeall = function(list)
		list[5] = {}
		for k, v in pairs(list[4].liststuff) do
			for i, v1 in ipairs(v) do
				for i1, v2 in ipairs(v1) do
					v2.Visible = false
				end
			end
		end
	end
	
	menu.list.setval = function(list, value)
		list[1] = value
	end
	
	Draw:MenuOutlinedRect(true, 10, 59, menu.w - 20, menu.h - 69, {20, 20, 20, 255}, bbmenu)
	
	Draw:MenuOutlinedRect(true, 11, 58, ((menu.w - 20)/#menutable) - 2, 2, {35, 35, 35, 255}, bbmenu)
	local barguy = {bbmenu[#bbmenu], menu.postable[#menu.postable]}
	
	local function setActiveTab(slot)
		barguy[1].Position = Vector2.new((menu.x + 11 + (((((menu.w - 20)/#menutable) - 2)) * (slot - 1))) + ((slot - 1) * 2), menu.y + 58)
		barguy[2][2] = (11 + (((((menu.w - 20)/#menutable) - 2)) * (slot - 1))) + ((slot - 1) * 2)
		barguy[2][3] = 58
		
		for k, v in pairs(tabs) do
			if k == slot then
				v[1].Visible = false
			else
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
	end
	
	setActiveTab(menu.activetab)
	
	local plusminus = {}
	
	Draw:OutlinedText("_", 1, false, 10, 10, 14, false, {225, 225, 225, 255}, {20, 20, 20}, plusminus)
	Draw:OutlinedText("+", 1, false, 10, 10, 14, false, {225, 225, 225, 255}, {20, 20, 20}, plusminus)
	
	local function set_plusminus(value, x, y)
		for i, v in ipairs(plusminus) do
			if value == 0 then
				v.Visible = false
			else
				v.Visible = true
			end
		end
		
		if value ~= 0 then
			plusminus[1].Position = Vector2.new(x + 3 + menu.x, y - 5 + menu.y)
			plusminus[2].Position = Vector2.new(x + 13 + menu.x, y - 1 + menu.y)
			
			if value == 1 then
				
				for i, v in ipairs(plusminus) do
					v.Color = RGB(225, 225, 225)
					v.OutlineColor = RGB(20, 20, 20)
				end
				
			else
				for i, v in ipairs(plusminus) do
					if i + 1 == value then
						v.Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
					else
						v.Color = RGB(255, 255, 255)
					end
					v.OutlineColor = RGB(0, 0, 0)
				end
				
			end
			
		end
	end
	
	set_plusminus(0, 20, 20)
	
	local dropboxthingy = {}
	local dropboxtexty = {}
	
	Draw:OutlinedRect(false, 20, 20, 100, 22, {20, 20, 20, 255}, dropboxthingy)
	Draw:OutlinedRect(false, 21, 21, 98, 20, {0, 0, 0, 255}, dropboxthingy)
	Draw:FilledRect(false, 22, 22, 96, 18, {45, 45, 45, 255}, dropboxthingy)
	
	for i = 1, 30 do
		Draw:OutlinedText("nigga balls", 2, false, 20, 20, 13, false, {255, 255, 255, 255}, {0, 0, 0}, dropboxtexty)
	end
	
	local function set_dropboxthingy(visible, x, y, length, value, values)
		for k, v in pairs(dropboxthingy) do
			v.Visible = visible
		end
		
		dropboxthingy[1].Position = Vector2.new(x, y)
		dropboxthingy[2].Position = Vector2.new(x + 1, y + 1)
		dropboxthingy[3].Position = Vector2.new(x + 2, y + 22)
		
		dropboxthingy[1].Size = Vector2.new(length, 21 * (#values + 1) + 3)
		dropboxthingy[2].Size = Vector2.new(length - 2, (21 * (#values + 1)) + 1)
		dropboxthingy[3].Size = Vector2.new(length - 4, (21 * #values) + 1 - 1)
		
		if visible then
			for i = 1, #values do
				dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 21) )
				dropboxtexty[i].Visible = true
				dropboxtexty[i].Text = values[i]
				if i == value then
					dropboxtexty[i].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
				else
					dropboxtexty[i].Color = RGB(255, 255, 255)
				end
			end
		else
			for k, v in pairs(dropboxtexty) do
				v.Visible = false
			end
		end
	end
	
	local function set_comboboxthingy(visible, x, y, length, values)
		for k, v in pairs(dropboxthingy) do
			v.Visible = visible
		end
		
		dropboxthingy[1].Position = Vector2.new(x, y)
		dropboxthingy[2].Position = Vector2.new(x + 1, y + 1)
		dropboxthingy[3].Position = Vector2.new(x + 2, y + 22)
		
		dropboxthingy[1].Size = Vector2.new(length, 22 * (#values + 1) - 1)
		dropboxthingy[2].Size = Vector2.new(length - 2, (22 * (#values + 1)) - 3)
		dropboxthingy[3].Size = Vector2.new(length - 4, (22 * #values) - 3)
		
		if visible then
			for i = 1, #values do
				dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 21) )
				dropboxtexty[i].Visible = true
				dropboxtexty[i].Text = values[i][1]
				if values[i][2] then
					dropboxtexty[i].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
				else
					dropboxtexty[i].Color = RGB(255, 255, 255)
				end
			end
		else
			for k, v in pairs(dropboxtexty) do
				v.Visible = false
			end
		end
	end
	
	set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
	
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
			a = 0
		},
		postable = {},
		drawings = {}
	}
	
	local function ColorpickerOutline(visible, pos_x, pos_y, width, height, clr, tablename)    -- doing all this shit to make it easier for me to make this beat look nice and shit ya fell dog :dog_head:
		Draw:OutlinedRect(visible, pos_x + cp.x, pos_y + cp.y, width, height, clr, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	local function ColorpickerRect(visible, pos_x, pos_y, width, height, clr, tablename)
		Draw:FilledRect(visible, pos_x + cp.x, pos_y + cp.y, width, height, clr, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	local function ColorpickerImage(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		Draw:Image(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	local function ColorpickerText(text, visible, centered, pos_x, pos_y, tablename)
		Draw:OutlinedText(text, 2, visible, pos_x + cp.x, pos_y + cp.y, 13, centered, {255, 255, 255, 255}, {0, 0, 0}, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end
	
	ColorpickerRect(false, 1, 1, cp.w, cp.h, {35, 35, 35, 255}, cp.drawings)
	ColorpickerOutline(false, 1, 1, cp.w, cp.h, {0, 0, 0, 255}, cp.drawings)
	ColorpickerOutline(false, 2, 2, cp.w - 2, cp.h - 2, {20, 20, 20, 255}, cp.drawings)
	ColorpickerOutline(false, 3, 3, cp.w - 3, 1, {127, 72, 163, 255}, cp.drawings)
	table.insert(menu.clrs.norm, cp.drawings[#cp.drawings])
	ColorpickerOutline(false, 3, 4, cp.w - 3, 1, {87, 32, 123, 255}, cp.drawings)
	table.insert(menu.clrs.dark, cp.drawings[#cp.drawings])
	ColorpickerOutline(false, 3, 5, cp.w - 3, 1, {20, 20, 20, 255}, cp.drawings)
	ColorpickerText("color picker :D", false, false, 7, 6, cp.drawings)
	
	ColorpickerText("x", false, false, 268, 4, cp.drawings)
	
	ColorpickerOutline(false, 10, 23, 160, 160, {30, 30, 30, 255}, cp.drawings)
	ColorpickerOutline(false, 11, 24, 158, 158, {0, 0, 0, 255}, cp.drawings)
	ColorpickerRect(false, 12, 25, 156, 156, {0, 0, 0, 255}, cp.drawings)
	local maincolor = cp.drawings[#cp.drawings]
	ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
	
	--https://i.imgur.com/jG3NjxN.png
	local alphabar = {}
	ColorpickerOutline(false, 10, 189, 160, 14, {30, 30, 30, 255}, cp.drawings)
	table.insert(alphabar, cp.drawings[#cp.drawings])
	ColorpickerOutline(false, 11, 190, 158, 12, {0, 0, 0, 255}, cp.drawings)
	table.insert(alphabar, cp.drawings[#cp.drawings])
	ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
	table.insert(alphabar, cp.drawings[#cp.drawings])
	
	ColorpickerOutline(false, 176, 23, 14, 160, {30, 30, 30, 255}, cp.drawings)
	ColorpickerOutline(false, 177, 24, 12, 158, {0, 0, 0, 255}, cp.drawings)
	--https://i.imgur.com/2Ty4u2O.png
	ColorpickerImage(false, BBOT_IMAGES[3], 178, 25, 10, 156, 1, cp.drawings)
	
	ColorpickerText("New Color", false, false, 198, 23, cp.drawings)
	ColorpickerOutline(false, 197, 37, 75, 40, {30, 30, 30, 255}, cp.drawings)
	ColorpickerOutline(false, 198, 38, 73, 38, {0, 0, 0, 255}, cp.drawings)
	ColorpickerImage(false, BBOT_IMAGES[4], 199, 39, 71, 36, 1, cp.drawings)
	
	ColorpickerRect(false, 199, 39, 71, 36, {255, 0, 0, 255}, cp.drawings)
	local newcolor = cp.drawings[#cp.drawings]
	
	ColorpickerText("copy", false, true, 198 + 36, 41, cp.drawings)
	ColorpickerText("paste", false, true, 198 + 37, 56, cp.drawings)
	local newcopy = {cp.drawings[#cp.drawings - 1], cp.drawings[#cp.drawings]}
	
	ColorpickerText("Old Color", false, false, 198, 77, cp.drawings)
	ColorpickerOutline(false, 197, 91, 75, 40, {30, 30, 30, 255}, cp.drawings)
	ColorpickerOutline(false, 198, 92, 73, 38, {0, 0, 0, 255}, cp.drawings)
	ColorpickerImage(false, BBOT_IMAGES[4], 199, 93, 71, 36, 1, cp.drawings)
	
	ColorpickerRect(false, 199, 93, 71, 36, {255, 0, 0, 255}, cp.drawings)
	local oldcolor = cp.drawings[#cp.drawings]
	
	ColorpickerText("copy", false, true, 198 + 36, 103	, cp.drawings)
	local oldcopy = {cp.drawings[#cp.drawings]}
	
	--ColorpickerRect(false, 197, cp.h - 25, 75, 20, {30, 30, 30, 255}, cp.drawings)
	ColorpickerText("[ Apply ]", false, true, 235, cp.h - 23, cp.drawings)
	local applytext = cp.drawings[#cp.drawings]
	
	local function set_newcolor(r, g, b, a)
		
		newcolor.Color = RGB(r, g, b)
		if a ~= nil then
			newcolor.Transparency = a/255
		else
			newcolor.Transparency = 1
		end
	end
	
	local function set_oldcolor(r, g, b, a)
		oldcolor.Color = RGB(r, g, b)
		if a ~= nil then
			oldcolor.Transparency = a/255
		else
			oldcolor.Transparency = 1
		end
	end
	-- all this color picker shit is disgusting, why can't it be in it's own fucking scope. these are all global 
	local dragbar_r = {}
	Draw:OutlinedRect(true, 30, 30, 16, 5, {0, 0, 0, 255}, cp.drawings)
	table.insert(dragbar_r, cp.drawings[#cp.drawings])
	Draw:OutlinedRect(true, 31, 31, 14, 3, {255, 255, 255, 255}, cp.drawings)
	table.insert(dragbar_r, cp.drawings[#cp.drawings])
	
	local dragbar_b = {}
	Draw:OutlinedRect(true, 30, 30, 5, 16, {0, 0, 0, 255}, cp.drawings)
	table.insert(dragbar_b, cp.drawings[#cp.drawings])
	table.insert(alphabar, cp.drawings[#cp.drawings])
	Draw:OutlinedRect(true, 31, 31, 3, 14, {255, 255, 255, 255}, cp.drawings)
	table.insert(dragbar_b, cp.drawings[#cp.drawings])
	table.insert(alphabar, cp.drawings[#cp.drawings])
	
	local dragbar_m = {}
	Draw:OutlinedRect(true, 30, 30, 5, 5, {0, 0, 0, 255}, cp.drawings)
	table.insert(dragbar_m, cp.drawings[#cp.drawings])
	Draw:OutlinedRect(true, 31, 31, 3, 3, {255, 255, 255, 255}, cp.drawings)
	table.insert(dragbar_m, cp.drawings[#cp.drawings])
	
	local function set_dragbar_r(x, y)
		dragbar_r[1].Position = Vector2.new(x, y)
		dragbar_r[2].Position = Vector2.new(x + 1, y + 1)
	end
	
	local function set_dragbar_b(x, y)
		dragbar_b[1].Position = Vector2.new(x, y)
		dragbar_b[2].Position = Vector2.new(x + 1, y + 1)
	end
	
	local function set_dragbar_m(x, y)
		dragbar_m[1].Position = Vector2.new(x, y)
		dragbar_m[2].Position = Vector2.new(x + 1, y + 1)
	end
	
	local function set_colorpicker(visible, color, value, alpha, text, x, y)
		for k, v in pairs(cp.drawings) do
			v.Visible = visible
		end
		
		if visible then
			cp.x = x
			cp.y = y
			for k, v in pairs(cp.postable) do
				v[1].Position = Vector2.new(x + v[2], y + v[3])
			end
			
			local tempclr = RGB(color[1], color[2], color[3])
			local h, s, v = tempclr:ToHSV()
			cp.hsv.h = h
			cp.hsv.s = s
			cp.hsv.v = v
			
			set_dragbar_r(cp.x + 175, cp.y + 23 + math.floor((1 - h) * 156))
			set_dragbar_m(cp.x + 9 + math.floor(s * 156), cp.y + 23 + math.floor((1 - v)* 156))
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
				set_dragbar_b(cp.x + 12 + math.floor(156 * (color[4]/255)), cp.y + 188)
			end
			
			applytext.Position = Vector2.new(235 + cp.x, cp.y + cp.h - 23)
			maincolor.Color = Color3.fromHSV(h, 1, 1)
			cp.drawings[7].Text = text
		end
	end
	
	set_colorpicker(false, {255, 0, 0}, nil, false, "", 0, 0)
	
	local bbmouse = {}
	local mousie = {
		x = 100,
		y = 240
	}
	Draw:Triangle(true, true, {mousie.x, mousie.y}, {mousie.x, mousie.y + 15}, {mousie.x + 10, mousie.y + 10}, {127, 72, 163, 255}, bbmouse)
	table.insert(menu.clrs.norm, bbmouse[#bbmouse])
	Draw:Triangle(true, false, {mousie.x, mousie.y}, {mousie.x, mousie.y + 15}, {mousie.x + 10, mousie.y + 10}, {0, 0, 0, 255}, bbmouse)
	
	function menu:set_mouse_pos(x, y)
		for k, v in pairs(bbmouse) do
			v.PointA = Vector2.new(x, y + 36)
			v.PointB = Vector2.new(x, y + 36 + 15)
			v.PointC = Vector2.new(x + 10, y + 46)
		end
	end
	
	function menu:set_menu_clr(r, g, b)
		menu.watermark.rect[1].Color = RGB(r - 40, g - 40, b - 40)
		menu.watermark.rect[2].Color = RGB(r, g, b)
		
		for k, v in pairs(menu.clrs.norm) do
			v.Color = RGB(r, g, b)
		end
		for k, v in pairs(menu.clrs.dark) do
			v.Color = RGB(r - 40, g - 40, b - 40)
		end
		local menucolor = {r, g, b}
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == "toggle" then
						if not v2[1] then
							for i = 0, 3 do
								v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
							end
						else
							for i = 0, 3 do
								v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3])}, [2] = {start = 3, color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40)}})
							end
						end
					elseif v2[2] == "slider" then
						for i = 0, 3 do
							v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3])}, [2] = {start = 3, color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40)}})
						end
					end
				end
			end
		end
		
	end
	
	local function UpdateConfigs()
		local configthing = menu.options["Settings"]["Configuration"]["Configs"]
		
		configthing[6] = GetConfigs()
		if configthing[1] > #configthing[6] then
			configthing[1] = #configthing[6]
		end
		configthing[4][1].Text = configthing[6][configthing[1]]
		
	end
	
	menu.dropbox_open = nil
	
	menu.colorpicker_open = false
	
	menu.textboxopen = nil
	
	local shooties = {}
	
	function InputBeganMenu(key)
		
		if key.KeyCode == Enum.KeyCode.Delete and not loadingthing.Visible then
			cp.dragging_m = false
			cp.dragging_r = false
			cp.dragging_b = false
			UpdateConfigs()
			if menu.open and not menu.fading then
				for k, v in pairs(menu.options) do
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "slider" and v2[5] then
								v2[5] = false
							elseif v2[2] == "dropbox" and v2[5] then
								v2[5] = false
							elseif v2[2] == "combobox" and v2[5] then
								v2[5] = false
							elseif v2[2] == "toggle" then
								if v2[5] ~= nil then
									if v2[5][2] == "keybind" and v2[5][5] then
										v2[5][4][2].Color = RGB(30, 30, 30)
										v2[5][5] = false
									elseif v2[5][2] == "single colorpicker" and v2[5][5] then
										v2[5][5] = false
									end
								end
							elseif v2[2] == "button" then
								if v2[1] then
									for i = 0, 8 do
										v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
									end
									v2[1] = false
								end
							end
						end
					end
				end
				set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
				menu.colorpicker_open = nil
				menu.colorpicker_open = nil
				set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
				
			end
			if not menu.fading then
				menu.fading = true
				menu.fadestart = tick()
			end
		end
		
		if menu == nil then return end

		if menu.textboxopen then
			if key.KeyCode == Enum.KeyCode.Delete or key.KeyCode == Enum.KeyCode.Return then
				for k, v in pairs(menu.options) do
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "textbox" then
								if v2[5] then
									v2[5] = false
									v2[4].Color = RGB(255, 255, 255)
									menu.textboxopen = false
									v2[4].Text = v2[1]
								end
							end
						end
					end
				end
			end
		end

		if menu.open and not menu.fading then
			for k, v in pairs(menu.options) do
				
				for k1, v1 in pairs(v) do
					
					for k2, v2 in pairs(v1) do
						
						if v2[2] == "toggle" then
							if v2[5] ~= nil then
								if v2[5][2] == "keybind" and v2[5][5] and key.KeyCode.Value ~= 0 then
									
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
						elseif v2[2] == "textbox" then
							if v2[5] then
								if table.find(textBoxLetters, KeyEnumToName(key.KeyCode)) and string.len(v2[1]) <= 28 then
									--print(tostring(INPUT_SERVICE:IsModifierKeyDown()))
									if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
										v2[1] = v2[1].. string.upper(KeyEnumToName(key.KeyCode))
									else
										v2[1] = v2[1].. string.lower(KeyEnumToName(key.KeyCode))
									end
								elseif KeyEnumToName(key.KeyCode) == "Space" then
									v2[1] = v2[1].. " "
								elseif KeyEnumToName(key.KeyCode) == "-" then
									if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
										v2[1] = v2[1].. "_"
									else
										v2[1] = v2[1].. "-"
									end
								elseif KeyEnumToName(key.KeyCode) == "Back" and v2[1] ~= "" then
									v2[1] = string.sub(v2[1], 0, #(v2[1]) - 1)
								end
								v2[4].Text = v2[1] .. "|"
							end
						end
						
					end
					
				end
				
			end
		end
	end
	
	function menu:SetMenuPos(x, y)
		for k, v in pairs(menu.postable) do
			if v[1].Visible then
				v[1].Position = Vector2.new(x + v[2], y + v[3])
			end
		end
	end
	
	function menu:MouseInMenu(x, y, width, height)
		if LOCAL_MOUSE.x > menu.x + x and LOCAL_MOUSE.x < menu.x + x + width and LOCAL_MOUSE.y > menu.y - 36 + y and LOCAL_MOUSE.y < menu.y - 36 + y + height then
			return true
		else
			return false
		end
	end
	
	function menu:MouseInColorPicker(x, y, width, height)
		if LOCAL_MOUSE.x > cp.x + x and LOCAL_MOUSE.x < cp.x + x + width and LOCAL_MOUSE.y > cp.y - 36 + y and LOCAL_MOUSE.y < cp.y - 36 + y + height then
			return true
		else
			return false
		end
	end
	
	local keyz = {}
	for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
		keyz[v.Value] = v
	end
	
	function menu:GetVal(tab, groupbox, name, ...)
		local args = {...}
		
		if args[1] == nil then
			if menu.options[tab][groupbox][name][2] ~= "combobox" then
				return menu.options[tab][groupbox][name][1]
			else
				local temptable = {}
				for k, v in ipairs(menu.options[tab][groupbox][name][1]) do
					table.insert(temptable, v[2])
				end
				return temptable
			end
		else
			if args[1] == "keybind" or args[1] == "color" then
				if args[2] then
					return RGB(menu.options[tab][groupbox][name][5][1][1], menu.options[tab][groupbox][name][5][1][2], menu.options[tab][groupbox][name][5][1][3])
				else
					return menu.options[tab][groupbox][name][5][1]
				end
			elseif args[1] == "color1" then
				if args[2] then
					return RGB(menu.options[tab][groupbox][name][5][1][1][1][1], menu.options[tab][groupbox][name][5][1][1][1][2], menu.options[tab][groupbox][name][5][1][1][1][3])
				else
					return menu.options[tab][groupbox][name][5][1][1][1]
				end
			elseif args[1] == "color2" then
				if args[2] then
					return RGB(menu.options[tab][groupbox][name][5][1][2][1][1], menu.options[tab][groupbox][name][5][1][2][1][2], menu.options[tab][groupbox][name][5][1][2][1][3])
				else
					return menu.options[tab][groupbox][name][5][1][2][1]
				end
			end
		end
	end
	
	local menuElementTypes = {"toggle", "slider", "dropbox", "textbox"}
	local doubleclickDelay = 1
	local buttonsInQue = {}
	local function buttonpressed(bp)
		
		if bp.doubleclick then
			if buttonsInQue[bp] and tick() - buttonsInQue[bp] < doubleclickDelay then
				buttonsInQue[bp] = 0
			else
				buttonsInQue[bp] = tick()
				return
			end
		end
		ButtonPressed:Fire(bp.tab, bp.groupbox, bp.name)
		if bp == menu.options["Settings"]["Extra"]["Unload Cheat"] then
			menu.fading = true
			wait(0.3)
			menu:unload()
		elseif bp == menu.options["Settings"]["Extra"]["Set Clipboard Game ID"] then
			setclipboard(game.JobId)
		elseif bp == menu.options["Settings"]["Configuration"]["Save Config"] then
			
			local figgy = "BitchBot v2\nmade with <3 from Nate, Bitch, Classy, and Json\n\n" -- screw zarzel XD
			
			for k, v in next, menuElementTypes do
				figgy = figgy.. v.. "s {\n"
				for k1, v1 in pairs(menu.options) do
					for k2, v2 in pairs(v1) do
						for k3, v3 in pairs(v2) do
							
							if v3[2] == tostring(v) and k3 ~= "Configs" and k3 ~= "Player Status" and k3 ~= "ConfigName" then
								figgy = figgy..k1.. "|".. k2.."|".. k3.."|"..tostring(v3[1]).. "\n"
							end
						end
					end
				end
				figgy = figgy.."}\n"
			end
			figgy = figgy.."comboboxes {\n"
			for k, v in pairs(menu.options) do
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "combobox" then
							local boolz = ""
							for k3, v3 in pairs(v2[1]) do
								boolz = boolz.. tostring(v3[2]).. ", "
							end
							figgy = figgy..k.."|"..k1.."|"..k2.."|"..boolz.."\n"
						end
					end
				end
			end
			figgy = figgy.."}\n"
			figgy = figgy.."keybinds {\n"
			for k, v in pairs(menu.options) do
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "toggle" then
							if v2[5] ~= nil then
								if v2[5][2] == "keybind" then
									if v2[5][1] == nil then
										figgy = figgy..k.."|"..k1.."|"..k2.."|nil\n"
									else
										figgy = figgy..k.."|"..k1.."|"..k2.."|"..tostring(v2[5][1].Value).."\n"
									end
								end
							end
						end
					end
				end
			end
			figgy = figgy.."}\n"
			figgy = figgy.."colorpickers {\n"
			for k, v in pairs(menu.options) do
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "toggle" then
							if v2[5] ~= nil then
								if v2[5][2] == "single colorpicker" then
									local clrz = ""
									for k3, v3 in pairs(v2[5][1]) do
										clrz = clrz.. tostring(v3).. ", "
									end
									figgy = figgy..k.."|"..k1.."|"..k2.."|"..clrz.."\n"
								end
							end
						end
					end
				end
			end
			figgy = figgy.."}\n"
			figgy = figgy.."double colorpickers {\n"
			for k, v in pairs(menu.options) do
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "toggle" then
							if v2[5] ~= nil then
								if v2[5][2] == "double colorpicker" then
									local clrz1 = ""
									for k3, v3 in pairs(v2[5][1][1][1]) do
										clrz1 = clrz1.. tostring(v3).. ", "
									end
									local clrz2 = ""
									for k3, v3 in pairs(v2[5][1][2][1]) do
										clrz2 = clrz2.. tostring(v3).. ", "
									end
									figgy = figgy..k.."|"..k1.."|"..k2.."|"..clrz1.."|"..clrz2.."\n"
								end
							end
						end
					end
				end
			end
			figgy = figgy.."}\n"
			writefile("bitchbot/"..menu.game.. "/".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb", figgy)
			CreateNotification("Saved \"".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb\"!")
			UpdateConfigs()
		elseif bp == menu.options["Settings"]["Configuration"]["Delete Config"] then
			
			delfile("bitchbot/"..menu.game.. "/".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb")
			CreateNotification("Deleted \"".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb\"!")
			UpdateConfigs()
			
			
		elseif bp == menu.options["Settings"]["Configuration"]["Load Config"]  then
			
			local configname = "bitchbot/"..menu.game.. "/".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb"
			if not isfile(configname) then
				CreateNotification("\"".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb\" is not a valid config.")
				return
			end
			local loadedcfg = readfile(configname)
			
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
					
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						if tt[4] == "true" then
							menu.options[tt[1]][tt[2]][tt[3]][1] = true
						else
							menu.options[tt[1]][tt[2]][tt[3]][1] = false
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
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						menu.options[tt[1]][tt[2]][tt[3]][1] = tonumber(tt[4])
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
					

					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						local num = tonumber(tt[4])
						if num > #menu.options[tt[1]][tt[2]][tt[3]][6] then
							num = #menu.options[tt[1]][tt[2]][tt[3]][6]
						end
						menu.options[tt[1]][tt[2]][tt[3]][1] = num
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
						if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
							menu.options[tt[1]][tt[2]][tt[3]][1] = tostring(tt[4])
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
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						
						local subs = string.split(tt[4], ",")
						
						for i, v in ipairs(subs) do
							local opt = string.gsub(v, " ", "")
							if opt == "true" then
								menu.options[tt[1]][tt[2]][tt[3]][1][i][2] = true
							else
								menu.options[tt[1]][tt[2]][tt[3]][1][i][2] = false
							end
							if i == #subs - 1 then break end
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
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						if tt[4] == "nil" then
							menu.options[tt[1]][tt[2]][tt[3]][5][1] = nil
						else
							menu.options[tt[1]][tt[2]][tt[3]][5][1] = keyz[tonumber(tt[4])]
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
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						local subs = string.split(tt[4], ",")
						
						for i, v in ipairs(subs) do
							if menu.options[tt[1]][tt[2]][tt[3]][5][1][i] == nil then
								break
							end
							local opt = string.gsub(v, " ", "")
							menu.options[tt[1]][tt[2]][tt[3]][5][1][i] = tonumber(opt)
							if i == #subs - 1 then break end
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
					if menu.options[tt[1]] ~= nil and menu.options[tt[1]][tt[2]] ~= nil and menu.options[tt[1]][tt[2]][tt[3]] ~= nil then
						
						local subs = {string.split(tt[4], ","), string.split(tt[5], ",")}
						
						for i, v in ipairs(subs) do
							for i1, v1 in ipairs(v) do
								if menu.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] == nil then
									break
								end
								local opt = string.gsub(v1, " ", "")
								menu.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] = tonumber(opt)
								if i1 == #v - 1 then break end
							end
						end
					end
				end
				
				for k, v in pairs(menu.options) do
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "toggle" then
								if not v2[1] then
									for i = 0, 3 do
										v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
									end
								else
									for i = 0, 3 do
										v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])}, [2] = {start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40)}})
									end
								end
								if v2[5] ~= nil then
									if v2[5][2] == "keybind" then
										
										v2[5][4][2].Color = RGB(30, 30, 30)
										v2[5][4][1].Text = KeyEnumToName(v2[5][1])
									elseif v2[5][2] == "single colorpicker" then
										v2[5][4][1].Color = RGB(v2[5][1][1], v2[5][1][2], v2[5][1][3])
										for i = 2, 3 do
											v2[5][4][i].Color = RGB(v2[5][1][1] - 40, v2[5][1][2] - 40, v2[5][1][3] - 40)
										end
									elseif v2[5][2] == "double colorpicker" then
										for i, v3 in ipairs(v2[5][1]) do

											v3[4][1].Color = RGB(v3[1][1], v3[1][2], v3[1][3])
											for i1 = 2, 3 do
												v3[4][i1].Color = RGB(v3[1][1] - 40, v3[1][2] - 40, v3[1][3] - 40)
											end
										end
									end
								end
							elseif v2[2] == "slider" then
								if v2[1] < v2[6][1] then
									v2[1] = v2[6][1]
								elseif v2[1] > v2[6][2] then
									v2[1] = v2[6][2]
								end
								
								v2[4][5].Text = v2.custom[v2[1]] or tostring(v2[1]) .. v2[4][6]
								--v2[4][5].Text = tostring(v2[1]).. v2[4][6]
								
								for i = 1, 4 do
									v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
								end
							elseif v2[2] == "dropbox" then
								v2[4][1].Text = v2[6][v2[1]]
							elseif v2[2] == "combobox" then
								local textthing = ""
								for k3, v3 in pairs(v2[1]) do
									if v3[2] then
										if textthing == "" then
											textthing = v3[1]
										else
											textthing = textthing.. ", ".. v3[1]
										end
									end
								end
								textthing = textthing ~= "" and textthing or "None"
								if string.len(textthing) > 25 then
									textthing = string_cut(textthing, 25)
								end
								v2[4][1].Text = textthing
							elseif v2[2] == "textbox" then
								v2[4].Text = v2[1]
							end
						end
					end
				end
			end
			CreateNotification("Loaded \"".. menu.options["Settings"]["Configuration"]["ConfigName"][1].. ".bb\"!")
		end
	end
	
	local function mousebutton1downfunc()
		menu.dropbox_open = nil
		menu.textboxopen = false
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == "dropbox" and v2[5] then
						if not menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) then
							set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
							v2[5] = false
						else
							menu.dropbox_open = v2
							menu.dropbox_open = v2
						end
					end
					if v2[2] == "combobox" and v2[5] then
						if not menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) then
							set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
							v2[5] = false
						else
							menu.dropbox_open = v2
							menu.dropbox_open = v2
						end
					end
					if v2[2] == "toggle" then
						if v2[5] ~= nil then
							if v2[5][2] == "keybind" then
								if v2[5][5] == true then
									v2[5][4][2].Color = RGB(30, 30, 30)
									v2[5][5] = false
								end
							elseif v2[5][2] == "single colorpicker" then
								if v2[5][5] == true then
									if not menu:MouseInColorPicker(0, 0, cp.w, cp.h) then
										set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
										v2[5][5] = false
										menu.colorpicker_open = nil
										menu.colorpicker_open = nil
									end
								end
							elseif v2[5][2] == "double colorpicker" then
								for k3, v3 in pairs(v2[5][1]) do
									if v3[5] == true then
										if not menu:MouseInColorPicker(0, 0, cp.w, cp.h) then
											set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
											v3[5] = false
											menu.colorpicker_open = nil
											menu.colorpicker_open = nil
										end
									end
								end
							end
						end
					end
					if v2[2] == "textbox" and v2[5] then
						v2[4].Color = RGB(255, 255, 255)
						v2[5] = false
						v2[4].Text = v2[1]
					end
				end
			end
		end
		for i = 1, #menutable do
			if menu:MouseInMenu(10 + ((i - 1) * math.floor((menu.w - 20)/#menutable)), 27, math.floor((menu.w - 20)/#menutable), 32) then
				menu.activetab = i
				setActiveTab(menu.activetab)
				menu:SetMenuPos(menu.x, menu.y)
			end
		end
		if menu.colorpicker_open then
			if menu:MouseInColorPicker(197, cp.h - 25, 75, 20) then
				local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				menu.colorpicker_open[4][1].Color = tempclr
				for i = 2, 3 do
					menu.colorpicker_open[4][i].Color = RGB(math.floor(tempclr.R * 255) - 40, math.floor(tempclr.G * 255) - 40, math.floor(tempclr.B * 255) - 40)
				end
				if cp.alpha then
					menu.colorpicker_open[1] = {math.floor(tempclr.R * 255), math.floor(tempclr.G * 255), math.floor(tempclr.B * 255), cp.hsv.a}
				else
					menu.colorpicker_open[1] = {math.floor(tempclr.R * 255), math.floor(tempclr.G * 255), math.floor(tempclr.B * 255)}
				end
				menu.colorpicker_open = nil
				menu.colorpicker_open = nil
				set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
			end
			if menu:MouseInColorPicker(264, 2, 14, 14) then
				menu.colorpicker_open = nil
				menu.colorpicker_open = nil
				set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
			end
			if menu:MouseInColorPicker(10, 23, 160, 160) then
				cp.dragging_m = true
			elseif menu:MouseInColorPicker(176, 23, 14, 160) then
				cp.dragging_r = true
			elseif menu:MouseInColorPicker(10, 189, 160, 14) and cp.alpha then
				cp.dragging_b = true
			end
			
			--[[
			menu.options[v.name][v1.name][v2.name][5][4] = Draw:ColorPicker(v2.extra.color, v1.x + v1.width - 38, y_pos + v1.y - 1, tabz[k])
			menu.options[v.name][v1.name][v2.name][5][1] = v2.extra.color
			menu.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
			menu.options[v.name][v1.name][v2.name][5][3] = {v1.x + v1.width - 38, y_pos + v1.y - 1}
			menu.options[v.name][v1.name][v2.name][5][5] = false
			menu.options[v.name][v1.name][v2.name][5][6] = v2.extra.name
			]]
			if menu:MouseInColorPicker(197, 37, 75, 20) then
				menu.copied_clr = newcolor.Color
			elseif menu:MouseInColorPicker(197, 57, 75, 20) then
				if menu.copied_clr ~= nil then
					local cpa = false
					local clrtable = {menu.copied_clr.R * 255, menu.copied_clr.G * 255, menu.copied_clr.B * 255}
					if menu.colorpicker_open[1][4] ~= nil then
						cpa = true
						table.insert(clrtable, menu.colorpicker_open[1][4])
					end
					
					set_colorpicker(true, clrtable, menu.colorpicker_open, cpa, menu.colorpicker_open[6], cp.x, cp.y)
					local oldclr = menu.colorpicker_open[4][1].Color
					if menu.colorpicker_open[1][4] ~= nil then
						set_oldcolor(oldclr.R * 255, oldclr.G * 255, oldclr.B * 255, menu.colorpicker_open[1][4])
					else
						set_oldcolor(oldclr.R * 255, oldclr.G * 255, oldclr.B * 255)
					end
				end
			end
			
			if menu:MouseInColorPicker(197, 91, 75, 40) then
				menu.copied_clr = oldcolor.Color
			end
		else
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "toggle" and not menu.dropbox_open then
								if menu:MouseInMenu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16) then
									if v2[6] then
										if menu:GetVal("Settings", "Extra", "Allow Unsafe Features") and v2[1] == false then
											v2[1] = true
										else
											v2[1] = false
										end
									else
										v2[1] = not v2[1]
									end
									if not v2[1] then
										for i = 0, 3 do
											v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
										end
									else
										for i = 0, 3 do
											v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])}, [2] = {start = 3, color = RGB(menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40)}})
										end
									end
									TogglePressed:Fire(k1, k2, v2)
								end
								if v2[5] ~= nil then
									if v2[5][2] == "keybind" then
										if menu:MouseInMenu(v2[5][3][1], v2[5][3][2], 44, 16) then
											v2[5][4][2].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
											v2[5][5] = true
										end
									elseif v2[5][2] == "single colorpicker" then
										if menu:MouseInMenu(v2[5][3][1], v2[5][3][2], 28, 14) then
											v2[5][5] = true
											menu.colorpicker_open = v2[5]
											menu.colorpicker_open = v2[5]
											if v2[5][1][4] ~= nil then
												set_colorpicker(true, v2[5][1], v2[5], true, v2[5][6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
											else
												set_colorpicker(true, v2[5][1], v2[5], false, v2[5][6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
											end
										end
									elseif v2[5][2] == "double colorpicker" then
										for k3, v3 in pairs(v2[5][1]) do
											if menu:MouseInMenu(v3[3][1], v3[3][2], 28, 14) then
												v3[5] = true
												menu.colorpicker_open = v3
												menu.colorpicker_open = v3
												if v3[1][4] ~= nil then
													set_colorpicker(true, v3[1], v3, true, v3[6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
												else
													set_colorpicker(true, v3[1], v3, false, v3[6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
												end
											end
										end
									end
								end
							elseif v2[2] == "slider" and not menu.dropbox_open then
								if menu:MouseInMenu(v2[7][1], v2[7][2], 22, 13) then
									local stepval = 1
									if v2.stepsize then 
										stepval = v2.stepsize
									end
									if menu:modkeydown("shift", "left") then
										stepval = 0.1
									end
									if menu:MouseInMenu(v2[7][1], v2[7][2], 11, 13) then
										v2[1] -= stepval
									elseif menu:MouseInMenu(v2[7][1] + 11, v2[7][2], 11, 13) then
										v2[1] += stepval
									end
									
									if v2[1] < v2[6][1] then
										v2[1] = v2[6][1]
									elseif v2[1] > v2[6][2] then
										v2[1] = v2[6][2]
									end
									
									v2[4][5].Text = v2.custom[v2[1]] or tostring(v2[1]) .. v2[4][6]
									
									for i = 1, 4 do
										v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
									end
									
								elseif menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 28) then
									v2[5] = true
								end
							elseif v2[2] == "dropbox" then
								if menu.dropbox_open then
									if v2 ~= menu.dropbox_open then
										continue
									end
								end
								if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 36) then
									if not v2[5] then
										set_dropboxthingy(true, v2[3][1] + menu.x + 1, v2[3][2] + menu.y + 13, v2[3][3], v2[1], v2[6])
										v2[5] = true
									else
										set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
										v2[5] = false
									end
								elseif menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) and v2[5] then
									for i = 1, #v2[6] do
										if menu:MouseInMenu(v2[3][1], v2[3][2] + 36 + ((i - 1) * 21), v2[3][3], 21) then
											v2[4][1].Text = v2[6][i]
											v2[1] = i
											set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
											v2[5] = false
										end
									end
									
									if v2 == menu.options["Settings"]["Configuration"]["Configs"] then
										local textbox = menu.options["Settings"]["Configuration"]["ConfigName"]
										local relconfigs = GetConfigs()
										textbox[1] = relconfigs[menu.options["Settings"]["Configuration"]["Configs"][1]]
										textbox[4].Text = textbox[1]
									end
								end
							elseif v2[2] == "combobox" then
								if menu.dropbox_open then
									if v2 ~= menu.dropbox_open then
										continue
									end
								end
								if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 36) then
									if not v2[5] then
										set_comboboxthingy(true, v2[3][1] + menu.x + 1, v2[3][2] + menu.y + 13, v2[3][3], v2[1], v2[6])
										v2[5] = true
									else
										set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
										v2[5] = false
									end
								elseif menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) and v2[5] then
									for i = 1, #v2[1] do
										if menu:MouseInMenu(v2[3][1], v2[3][2] + 36 + ((i - 1) * 22), v2[3][3], 23) then
											v2[1][i][2] = not v2[1][i][2]
											local textthing = ""
											for k, v in pairs(v2[1]) do
												if v[2] then
													if textthing == "" then
														textthing = v[1]
													else
														textthing = textthing.. ", ".. v[1]
													end
												end
											end
											textthing = textthing ~= "" and textthing or "None"
											if string.len(textthing) > 25 then
												textthing = string_cut(textthing, 25)
											end
											v2[4][1].Text = textthing
											set_comboboxthingy(true, v2[3][1] + menu.x + 1, v2[3][2] + menu.y + 13, v2[3][3], v2[1], v2[6])
										end
									end
								end
							elseif v2[2] == "button" and not menu.dropbox_open then
								if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 22) then
									if not v2[1] then
										buttonpressed(v2)
										if k2 == "Unload Cheat" then return end
										for i = 0, 8 do
											v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(35, 35, 35)}, [2] = {start = 8, color = RGB(50, 50, 50)}})
										end
										v2[1] = true
									end
								end
							elseif v2[2] == "textbox" and not menu.dropbox_open then
								if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 22) then
									if not v2[5] then
										menu.textboxopen = v2
										
										v2[4].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
										v2[5] = true
									end
									
								end
							elseif v2[2] == "list" then
								--[[
								menu.options[v.name][v1.name][v2.name] = {}
								menu.options[v.name][v1.name][v2.name][4] = Draw:List(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.colums, tabz[k])
								menu.options[v.name][v1.name][v2.name][1] = nil
								menu.options[v.name][v1.name][v2.name][2] = v2.type
								menu.options[v.name][v1.name][v2.name][3] = 1
								menu.options[v.name][v1.name][v2.name][5] = {}
								menu.options[v.name][v1.name][v2.name][6] = v2.size
								menu.options[v.name][v1.name][v2.name][7] = v2.colums
								menu.options[v.name][v1.name][v2.name][8] = {v1.x + 8, v1.y + y_pos, v1.width - 16}
								]]--
								if #v2[5] > v2[6] then
									for i = 1, v2[6] do
										if menu:MouseInMenu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22) then
											if v2[1] == tostring(v2[5][i + v2[3] - 1][1][1]) then
												v2[1] = nil
											else
												v2[1] = tostring(v2[5][i + v2[3] - 1][1][1])
											end
										end
									end
								else
									for i = 1, #v2[5] do
										if menu:MouseInMenu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22) then
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
		for k, v in pairs(menu.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == "toggle" then
						if v2[6] then
							if not menu:GetVal("Settings", "Extra", "Allow Unsafe Features") then
								v2[1] = false
								for i = 0, 3 do
									v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
								end
							end
						end
					end
				end
			end
		end
		if menu.open then
			if menu.options["Settings"]["Menu Settings"]["Menu Accent"][1] then
				local clr = menu.options["Settings"]["Menu Settings"]["Menu Accent"][5][1]
				menu.mc = {clr[1], clr[2], clr[3]}
			else
				menu.mc = {127, 72, 163}
			end
			menu:set_menu_clr(menu.mc[1], menu.mc[2], menu.mc[3])
			
			local wme = menu:GetVal("Settings", "Menu Settings", "Watermark")
			for k, v in pairs(menu.watermark.rect) do
				v.Visible = wme
			end
			menu.watermark.text[1].Visible = wme
		end
	end
	
	local function mousebutton1upfunc()
		cp.dragging_m = false
		cp.dragging_r = false
		cp.dragging_b = false
		for k, v in pairs(menu.options) do
			if menu.tabnames[menu.activetab] == k then
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "slider" and v2[5] then
							v2[5] = false
						end
						if v2[2] == "button" and v2[1] then
							for i = 0, 8 do
								v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
							end
							v2[1] = false
						end
					end
				end
			end
		end
	end
	
	
	local dragging = false
	local dontdrag = false
	local clickspot_x, clickspot_y, original_menu_x, original_menu_y = 0, 0, 0, 0
	
	menu.connections.mwf = LOCAL_MOUSE.WheelForward:Connect(function()
		if menu.open then
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
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
	
	menu.connections.mwb = LOCAL_MOUSE.WheelBackward:Connect(function()
		if menu.open then
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
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
	
	function menu:set_menu_transparency(transparency)
		for k, v in pairs(bbmouse) do
			v.Transparency = transparency/255
		end
		for k, v in pairs(bbmenu) do
			v.Transparency = transparency/255
		end
		for k, v in pairs(tabz[menu.activetab]) do
			v.Transparency = transparency/255
		end
	end
	
	function menu:set_menu_visibility(visible)
		for k, v in pairs(bbmouse) do
			v.Visible = visible
		end
		for k, v in pairs(bbmenu) do
			v.Visible = visible
		end
		for k, v in pairs(tabz[menu.activetab]) do
			v.Visible = visible
		end
	end
	
	menu:set_menu_transparency(0)
	menu:set_menu_visibility(false)
	menu.open = false
	local function renderSteppedMenu()
		SCREEN_SIZE = Camera.ViewportSize
		-- i pasted the old menu working ingame shit from the old source nate pls fix ty
		-- this is the really shitty alive check that we've been using since day one
		-- removed it :DDD
		-- im keepin all of our comments they're fun to look at
		-- i wish it showed comment dates that would be cool
		for button, time in next, buttonsInQue do
			if tick() - time < doubleclickDelay then
				button[4].text.Color = menu:GetVal("Settings", "Menu Settings", "Menu Accent", "color", true)
				button[4].text.Text = "Confirm?"
			else
				button[4].text.Color = Color3.new(1,1,1)
				button[4].text.Text = button.name
			end
		end
		if menu.fading then
			if menu.open then
				local timesincefade = tick() - menu.fadestart
				local fade_amount = 255 - math.floor((timesincefade * 10) * 255)
				set_plusminus(0, 20, 20)
				menu:set_menu_transparency(fade_amount)
				if fade_amount <= 0 then
					menu.open = false
					menu.fading = false
					menu:set_menu_transparency(0)
					menu:set_menu_visibility(false)
				else
					menu:set_menu_transparency(fade_amount)
				end
			else
				menu:set_menu_visibility(true)
				setActiveTab(menu.activetab)
				local timesincefade = tick() - menu.fadestart
				local fade_amount = math.floor((timesincefade * 10) * 255)
				menu:set_menu_transparency(fade_amount)
				if fade_amount >= 255 then
					menu.open = true
					menu.fading = false
					menu:set_menu_transparency(255)
				else
					menu:set_menu_transparency(fade_amount)
				end
			end
		end
		
		if menu.open or menu.fading then
			menu:set_mouse_pos(LOCAL_MOUSE.x, LOCAL_MOUSE.y)
			set_plusminus(0, 20, 20)
			for k, v in pairs(menu.options) do
				if menu.tabnames[menu.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "slider" then
								if v2[5] then
									--ANCHOR rounding in sliders
									local new_val = (v2[6][2] - v2[6][1]) * ((LOCAL_MOUSE.x - menu.x - v2[3][1])/v2[3][3])
									v2[1] = (v2.round and math.floor(new_val) or math.floor(new_val * 10) / 10) + v2[6][1]
									if v2[1] < v2[6][1] then
										v2[1] = v2[6][1]
									elseif v2[1] > v2[6][2] then
										v2[1] = v2[6][2]
									end
									v2[4][5].Text = v2.custom[v2[1]] or tostring(v2[1]) .. v2[4][6]
									for i = 1, 4 do
										v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
									end
									set_plusminus(1, v2[7][1], v2[7][2])
								else
									if not menu.dropbox_open then
										if menu:MouseInMenu(v2[3][1], v2[3][2], v2[3][3], 28) then
											if menu:MouseInMenu(v2[7][1], v2[7][2], 22, 13) then
												
												if menu:MouseInMenu(v2[7][1], v2[7][2], 11, 13) then
													
													set_plusminus(2, v2[7][1], v2[7][2])
													
												elseif menu:MouseInMenu(v2[7][1] + 11, v2[7][2], 11, 13) then
													
													set_plusminus(3, v2[7][1], v2[7][2])
													
												end
												
											else
												
												set_plusminus(1, v2[7][1], v2[7][2])
												
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
												
												if menu.options["Settings"]["Menu Settings"]["Menu Accent"][1] then
													local clr = menu.options["Settings"]["Menu Settings"]["Menu Accent"][5][1]
													v2[4].liststuff.words[i][i1].Color = RGB(clr[1], clr[2], clr[3])
												else
													v2[4].liststuff.words[i][i1].Color = RGB(menu.mc[1], menu.mc[2], menu.mc[3])
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
											menu:SetMenuPos(menu.x, menu.y)
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
											menu:SetMenuPos(menu.x, menu.y)
										end
									end
								end
							end
						end
					end
				end
			end
			
			if ((LOCAL_MOUSE.x > menu.x and LOCAL_MOUSE.x < menu.x + menu.w and LOCAL_MOUSE.y > menu.y - 32 and LOCAL_MOUSE.y < menu.y - 11) or dragging) and not dontdrag then
				if menu.mousedown then
					if dragging == false then
						clickspot_x = LOCAL_MOUSE.x
						clickspot_y = LOCAL_MOUSE.y - 36
						original_menu_X = menu.x
						original_menu_y = menu.y
						dragging = true
					end
					menu.x = (original_menu_X - clickspot_x) + LOCAL_MOUSE.x
					menu.y = (original_menu_y - clickspot_y) + LOCAL_MOUSE.y - 36
					menu:SetMenuPos(menu.x, menu.y)
					-- if menu.y < 0 then
					-- 	menu.y = 0
					-- 	menu:SetMenuPos(menu.x, 0)
					-- end
					-- if menu.x < 0 then
					-- 	menu.x = 0
					-- 	menu:SetMenuPos(0, menu.y)
					-- end
					-- if menu.x + menu.w > SCREEN_SIZE.x then
					-- 	menu.x = SCREEN_SIZE.x - menu.w
					-- 	menu:SetMenuPos(SCREEN_SIZE.x - menu.w, menu.y)
					-- end
					-- if menu.y > SCREEN_SIZE.y - 20 then
					-- 	menu.y = SCREEN_SIZE.y - 20
					-- 	menu:SetMenuPos(menu.x, SCREEN_SIZE.y - 20)
					-- end
				else
					dragging = false
				end
			elseif menu.mousedown then
				dontdrag = true
			elseif not menu.mousedown then
				dontdrag = false
			end
			if menu.colorpicker_open then
				if cp.dragging_m then
					set_dragbar_m(math.clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - 2, math.clamp(LOCAL_MOUSE.y + 36, cp.y + 25, cp.y + 180) - 2)
					
					cp.hsv.s = (math.clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - cp.x - 12)/155
					cp.hsv.v = 1 - ((math.clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
					newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				elseif cp.dragging_r then
					set_dragbar_r(cp.x + 175, math.clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178))
					
					maincolor.Color = Color3.fromHSV(1 - ((math.clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155), 1, 1)
					
					cp.hsv.h = 1 - ((math.clamp(LOCAL_MOUSE.y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
					newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				elseif cp.dragging_b then
					set_dragbar_b(math.clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168 ), cp.y + 188)
					newcolor.Transparency = (math.clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158
					cp.hsv.a = math.floor(((math.clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158) * 255)
				else
					local setvisnew = menu:MouseInColorPicker(197, 37, 75, 40)
					for i, v in ipairs(newcopy) do
						v.Visible = setvisnew
					end
					
					local setvisold = menu:MouseInColorPicker(197, 91, 75, 40)
					for i, v in ipairs(oldcopy) do
						v.Visible = setvisold
					end
				end
			end
		else
			if dragging then
				dragging = false
			end
		end
	end
	
	menu.connections.inputstart = INPUT_SERVICE.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			menu.mousedown = true
			if menu.open and not menu.fading then
				mousebutton1downfunc()
			end
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode.Name:match("Shift") then
				local kcn = input.KeyCode.Name
				local direction = kcn:split("Shift")[1]
				menu.modkeys.shift.direction = direction:lower()
			end
			if input.KeyCode.Name:match("Alt") then
				local kcn = input.KeyCode.Name
				local direction = kcn:split("Alt")[1]
				menu.modkeys.alt.direction = direction:lower()
			end
		end
		InputBeganMenu(input)

		if menu == nil then return end

		if menu.open then
			if menu.tabnames[menu.activetab] == "Settings" then
				if menu:GetVal("Settings", "Menu Settings", "Custom Menu Name") then
					bbmenu[27].Text = menu.options["Settings"]["Menu Settings"]["MenuName"][1]

					menu.watermark.text[1].Text = menu.options["Settings"]["Menu Settings"]["MenuName"][1].. menu.watermark.textString

					for i, v in ipairs(menu.watermark.rect) do
						v.Size = Vector2.new((#menu.watermark.text[1].Text) * 7 + 10, v.Size.y)
					end
				else 
					if bbmenu[27].Text ~= "Bitch Bot" then
						bbmenu[27].Text = "Bitch Bot"
					end

					if menu.watermark.text[1].Text ~= "Bitch Bot".. menu.watermark.textString then
						menu.watermark.text[1].Text = "Bitch Bot".. menu.watermark.textString

						for i, v in ipairs(menu.watermark.rect) do
							v.Size = Vector2.new((#menu.watermark.text[1].Text) * 7 + 10, v.Size.y)
						end
					end
				end
			end
		end

		if input.KeyCode == Enum.KeyCode.Home then
			menu.stat_menu = not menu.stat_menu

			for k, v in pairs(graphs) do
				if k ~= "other" then
					for k1, v1 in pairs(v) do
						if k1 ~= "pos" then
							for k2, v2 in pairs(v1) do
								v2.Visible = menu.stat_menu
							end
						end
					end
				end
			end

			for k, v in pairs(graphs.other) do
				v.Visible = menu.stat_menu
			end
		end
	end)
	
	menu.connections.inputended = INPUT_SERVICE.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			menu.mousedown = false
			if menu.open and not menu.fading then
				mousebutton1upfunc()
			end
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode.Name:match("Shift") then
				menu.modkeys.shift.direction = nil
			end
			if input.KeyCode.Name:match("Alt") then
				menu.modkeys.alt.direction = nil
			end
		end
	end)
	
	menu.connections.renderstepped = game.RunService.RenderStepped:Connect(function()
		renderSteppedMenu()
	end)
	function menu:unload()
		getgenv().v2 = nil
		self.unloaded = true
		for k, v in pairs(self.connections) do
			v:Disconnect()
		end
		
		local mt = getrawmetatable(game)
		
		setreadonly(mt, false)
		
		local oldmt = menu.oldmt
		
		if not oldmt then -- remember to store any "game" metatable hooks PLEASE PLEASE because this will ensure it replaces the meta so that it UNLOADS properly
			rconsoleerr("fatal error: no old game meta found! (UNLOAD PROBABLY WON'T WORK AS EXPECTED)")
		end
		
		for k,v in next, mt do
			if oldmt[k] then
				mt[k] = oldmt[k]
			end
		end
		
		setreadonly(mt, true)
		
		if menu.game == "pf" or menu.pfunload then
			menu:pfunload()
		end
		
		
		CreateNotification = nil
		Draw:UnRender()
		allrender = nil
		menu = nil
		Draw = nil
		self.unloaded = true
	end
end

local function GetPTlayerHumanoid(player)
	local character = player.Character
	
	if character then
		return character:FindFirstChildOfClass("Humanoid")
	else
		return nil
	end
end

local LastIteration
local Start = tick()
local FrameUpdateTable = { }

-- I STOLE THE FPS COUNTER FROM https://devforum.roblox.com/t/get-client-fps-trough-a-script/282631/14 😿😿😿😢😭
menu.connections.information_shit = game.RunService.Heartbeat:Connect(function()
	
	if menu.stat_menu == false then return end

	LastIteration = tick()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
	end
	
	FrameUpdateTable[1] = LastIteration
	local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
	CurrentFPS = math.floor(CurrentFPS)

	if tick() > lasttick + 0.25 then
		table.remove(networkin.incoming, 1)
		table.insert(networkin.incoming, stats.DataReceiveKbps)

		table.remove(networkin.outgoing, 1)
		table.insert(networkin.outgoing, stats.DataSendKbps)

		--incoming
		local biggestnum = 80
		for i = 1, 21 do
			if math.ceil(networkin.incoming[i]) > biggestnum - 10 then
				biggestnum = (math.ceil(networkin.incoming[i]/10) + 1) * 10
				--graphs.incoming.pos.x - 21, graphs.incoming.pos.y - 7,
			end
		end

		local numstr = tostring(biggestnum)
		graphs.incoming.sides[2].Text = numstr
		graphs.incoming.sides[2].Position = Vector2.new(graphs.incoming.pos.x - ((#numstr + 1)* 7) , graphs.incoming.pos.y - 7)
			

		for i = 1, 20 do
			local line = graphs.incoming.graph[i]
			
			line.From = Vector2.new(((i - 1) * 11) + graphs.incoming.pos.x, graphs.incoming.pos.y + 80 - math.floor(networkin.incoming[i] / biggestnum * 80))

			line.To = Vector2.new((i * 11) + graphs.incoming.pos.x ,  graphs.incoming.pos.y + 80 - math.floor(networkin.incoming[i + 1] / biggestnum * 80))
		end

		local avgbar_h = average(networkin.incoming)

		graphs.incoming.graph[21].From = Vector2.new(graphs.incoming.pos.x + 1, graphs.incoming.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80))
		graphs.incoming.graph[21].To = Vector2.new(graphs.incoming.pos.x + 220, graphs.incoming.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80))

		graphs.incoming.graph[22].Position = Vector2.new(graphs.incoming.pos.x + 222, graphs.incoming.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80) - 8)
		graphs.incoming.graph[22].Text = "avg: ".. tostring(round(avgbar_h, 2))

		graphs.incoming.sides[1].Text = "incoming kbps: ".. tostring(round(networkin.incoming[21], 2))

		-- outgoing
		local biggestnum = 10
		for i = 1, 21 do
			if math.ceil(networkin.outgoing[i]) > biggestnum - 5 then
				biggestnum = (math.ceil(networkin.outgoing[i]/5) + 1) * 5
			end
		end
		
		local numstr = tostring(biggestnum)
		graphs.outgoing.sides[2].Text = numstr
		graphs.outgoing.sides[2].Position = Vector2.new(graphs.outgoing.pos.x - ((#numstr + 1)* 7) , graphs.outgoing.pos.y - 7)
		

		for i = 1, 20 do
			local line = graphs.outgoing.graph[i]
			
			line.From = Vector2.new(((i - 1) * 11) + graphs.outgoing.pos.x, graphs.outgoing.pos.y + 80 - math.floor(networkin.outgoing[i] / biggestnum * 80))

			line.To = Vector2.new((i * 11) + graphs.outgoing.pos.x ,  graphs.outgoing.pos.y + 80 - math.floor(networkin.outgoing[i + 1] / biggestnum * 80))
		end

		local avgbar_h = average(networkin.outgoing)

		graphs.outgoing.graph[21].From = Vector2.new(graphs.outgoing.pos.x + 1, graphs.outgoing.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80))
		graphs.outgoing.graph[21].To = Vector2.new(graphs.outgoing.pos.x + 220, graphs.outgoing.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80))

		graphs.outgoing.graph[22].Position = Vector2.new(graphs.outgoing.pos.x + 222, graphs.outgoing.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80) - 8)
		graphs.outgoing.graph[22].Text = "avg: ".. tostring(round(avgbar_h, 2))

		graphs.outgoing.sides[1].Text = "outgoing kbps: ".. tostring(round(networkin.outgoing[21], 2))

		local drawnobjects = 0
		for k, v in pairs(allrender) do
			drawnobjects += #v
		end

		graphs.other[1].Text = string.format("initiation time: %d ms\ndrawn objects: %d\ntick: %d\nfps: %d", menu.load_time, drawnobjects, tick(), CurrentFPS)
		lasttick = tick()
	end
end)

if menu.game == "uni" then --SECTION UNIVERSAL
	menu.activetab = 4

	local allesp = {
		headdotoutline = {},
		headdot = {},
		name = {},
		outerbox = {},
		box = {},
		innerbox = {},
		healthouter = {},
		healthinner = {},
		hptext = {},
		distance = {},
		team = {},
	}
	
	for i = 1, Players.MaxPlayers do
		Draw:Circle(false, 20, 20, 10, 3,10,  {10, 10, 10, 215}, allesp.headdotoutline)
		Draw:Circle(false, 20, 20, 10, 1, 10, {255, 255, 255, 255}, allesp.headdot)
		
		Draw:OutlinedRect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.outerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.innerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, {255, 255, 255, 255}, allesp.box)
		
		Draw:FilledRect(false, 20, 20, 4, 20, {10, 10, 10, 215}, allesp.healthouter)
		Draw:FilledRect(false, 20, 20, 20, 20, {255, 255, 255, 255}, allesp.healthinner)
		
		Draw:OutlinedText("", 1, false, 20, 20, 13, false, {255, 255, 255, 255}, {0, 0, 0}, allesp.hptext)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.distance)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.name)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.team)
	end
	
	menu.crosshair = {outline = {}, inner = {}}
	for i, v in pairs(menu.crosshair) do
		for i = 1, 2 do
			Draw:FilledRect(false, 20, 20, 20, 20, {10, 10, 10, 215}, v)
		end
	end
	
	menu.fovcircle = {}
	Draw:Circle(false, 20, 20, 10, 3, 20, {10, 10, 10, 215}, menu.fovcircle)
	Draw:Circle(false, 20, 20, 10, 1, 20, {255, 255, 255, 255}, menu.fovcircle)
	
	menu.Initialize({
		{
			name = "Aimbot",
			content = {
				{
					name = "Aimbot",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = false,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.J,
							},
						},
						{
							type = "combobox",
							name = "Checks",
							values = {{"Alive", true}, {"Same Team", false}, {"Distance", false}},
						},
						{
							type = "slider",
							name = "Max Distance",
							value = 100,
							minvalue = 30,
							maxvalue = 500,
							stradd = "m"
						},
						{
							type = "slider",
							name = "Aimbot FOV",
							value = 0,
							minvalue = 0,
							maxvalue = 360,
							stradd = "°"
						},
						{
							type = "dropbox",
							name = "FOV Calculation",
							value = 1,
							values = {"Static", "Actual FOV"}
						},
						{
							type = "toggle",
							name = "Visibility Check",
							value = false,
						},
						{
							type = "toggle",
							name = "Auto Shoot",
							value = false,
						},
						{
							type = "toggle",
							name = "Smoothing",
							value = false,
						},
						{
							type = "slider",
							name = "Smoothing Value",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
					}
				},
			}
		},
		{
			name = "Visuals",
			content = {
				{
					name = "Player ESP",
					autopos = "left",
					content = {
						{
							type = "toggle",
							name = "Name",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Name ESP",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Head Dot",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Head Dot",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Box",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Box ESP",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Health Bar",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Low Health", "Max Health"},
								color = {{255, 0, 0}, {0, 255, 0}}
							}
						},
						{
							type = "toggle",
							name = "Health Number",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Health Number ESP",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Team",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Team ESP",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Team Color Based",
							value = false,
						},
						{
							type = "toggle",
							name = "Distance",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Distance ESP",
								color = {255, 255, 255, 255}
							}
						},
					}
				},
				{
					name = "Misc Visuals",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Custom Crosshair",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Crosshair Color",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "dropbox",
							name = "Crosshair Position",
							value = 1,
							values = {"Center Of Screen", "Mouse"}
						},
						{
							type = "slider",
							name = "Crosshair Size",
							value = 10,
							minvalue = 5,
							maxvalue = 15,
							stradd = "px"
						},
						{
							type = "toggle",
							name = "Draw Aimbot FOV",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Aimbot FOV Circle Color",
								color = {255, 255, 255, 255}
							}
						}
					}
				},
				{
					name = "ESP Settings",
					autopos = "right",
					content = {
						{
							type = "dropbox",
							name = "ESP Sorting",
							value = 1,
							values = {"None", "Distance"}
						},
						{
							type = "combobox",
							name = "Checks",
							values = {{"Alive", true}, {"Same Team", false}, {"Distance", false} },
						},
						{
							type = "slider",
							name = "Max Distance",
							value = 100,
							minvalue = 30,
							maxvalue = 500,
							stradd = "m"
						},
						{
							type = "toggle",
							name = "Highlight Aimbot Target",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Aimbot Target",
								color = {255, 0, 0, 255}
							}
						},
						{
							type = "toggle",
							name = "Highlight Friends",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Friended Players",
								color = {0, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Highlight Priority",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Priority Players",
								color = {255, 210, 0, 255}
							}
						},
					}
				},
				{
					name = "Local Visuals",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Change FOV",
							value = false,
						},
						{
							type = "slider",
							name = "Camera FOV",
							value = 60,
							minvalue = 60,
							maxvalue = 120,
							stradd = "°"
						},
					}
				},
			}
		},
		{
			name = "Misc",
			content = {
				{
					name = "Movement",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Speed",
							value = false
						},
						{
							type = "slider",
							name = "Speed Factor",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s"
						},
						{
							type = "dropbox",
							name = "Speed Method",
							value = 1,
							values = {"Velocity", "Walk Speed"}
						},
						-- {
						-- 	type = "combobox",
						-- 	name = "Combobox",
						-- 	values = {{"Head", true}, {"Body", true}, {"Arms", false}, {"Legs", false}}
						-- },
						{
							type = "toggle",
							name = "Fly",
							value = false,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.B,
							},
						},
						{
							type = "dropbox",
							name = "Fly Method",
							value = 1,
							values = {"Fly", "Noclip"}
						},
						{
							type = "slider",
							name = "Fly Speed",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s",
						},
						{
							type = "toggle",
							name = "Mouse Teleport",
							value = false,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.Q,
							},
						},
					}
				},
				{
					name = "Exploits",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Enable Tick Manipulation",
							value = false,
							unsafe = true,
						},
						{
							type = "toggle",
							name = "Shift Tick Base",
							value = false,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.E,
							},
						},
						{
							type = "slider",
							name = "Shifted Tick Base Add",
							value = 20,
							minvalue = 1,
							maxvalue = 1000,
							stradd = "ms"
						}
					}
				}
			}
		},
		{
			name = "Settings",
			content = {
				{
					name = "Player List",
					x = menu.columns.left,
					y = 66,
					width = 466,
					height = 328,
					content = {
						{
							type = "list",
							name = "Players",
							multiname = {"Name", "Team", "Status"},
							size = 9,
							colums = 3
						},
						{
							type = "image",
							name = "Player Info",
							text = "No Player Selected",
							size = 72
						},
						{
							type = "dropbox",
							name = "Player Status",
							x = 307,
							y = 314,
							w = 160,
							value = 1,
							values = {"None", "Friend", "Priority"}
						}
					}
				},
				{
					name = "Menu Settings",
					x = menu.columns.left,
					y = 400,
					width = menu.columns.width,
					height = 108,
					content = {
						{
							type = "toggle",
							name = "Menu Accent",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Accent Color",
								color = {127, 72, 163}
							}
						},
						{
							type = "toggle",
							name = "Watermark",
							value = true,
						},
						{
							type = "toggle",
							name = "Custom Menu Name",
							value = MenuName and true or false,
						},
						{
							type = "textbox",
							name = "MenuName",
							text = MenuName or "Bitch Bot"
						}
					}
				},
				{
					name = "Extra",
					x = menu.columns.left,
					y = 514,
					width = menu.columns.width,
					height = 119,
					content = {
						{
							type = "button",
							name = "Set Clipboard Game ID",
						},
						{
							type = "button",
							name = "Unload Cheat",
							doubleclick = true,
						},
						{
							type = "toggle",
							name = "Allow Unsafe Features",
							value = false,
						},
					}
				},
				{
					name = "Configuration",
					x = menu.columns.right,
					y = 400,
					width = menu.columns.width,
					height = 233,
					content = {
						{
							type = "textbox",
							name = "ConfigName",
							text = ""
						},
						{
							type = "dropbox",
							name = "Configs",
							value = 1,
							values = GetConfigs()
						},
						{
							type = "button",
							name = "Load Config",
							doubleclick = true,
						},
						{
							type = "button",
							name = "Save Config",
							doubleclick = true,
						},
						{
							type = "button",
							name = "Delete Config",
							doubleclick = true,
						},
					}
				}
			}
		},
	})
	
	local selectedPlayer = nil
	local plistinfo = menu.options["Settings"]["Player List"]["Player Info"][1]
	local plist = menu.options["Settings"]["Player List"]["Players"]
	local function updateplist()
		if menu == nil then return end
		local playerlistval = menu:GetVal("Settings", "Player List", "Players")
		local playerz = {}
		
		for i, team in pairs(TEAMS:GetTeams()) do
			local sorted_players = {}
			for i1, player in pairs(team:GetPlayers()) do
				table.insert(sorted_players, player.Name)
			end
			table.sort(sorted_players)
			for i1, player_name in pairs(sorted_players) do
				table.insert(playerz, Players:FindFirstChild(player_name))
			end
		end
		
		local sorted_players = {}
		for i, player in pairs(Players:GetPlayers()) do
			if player.Team == nil then
				table.insert(sorted_players, player.Name)
			end
		end
		table.sort(sorted_players)
		for i, player_name in pairs(sorted_players) do
			table.insert(playerz, Players:FindFirstChild(player_name))
		end
		sorted_players = nil
		
		local templist = {}
		for k, v in pairs(playerz) do
			local plyrname = {v.Name, RGB(255, 255, 255)}
			local teamtext = {"None", RGB(255, 255, 255)}
			local plyrstatus = {"None", RGB(255, 255, 255)}
			if v.Team ~= nil then
				teamtext[1] = v.Team.Name
				teamtext[2] = v.TeamColor.Color
			end
			if v == LOCAL_PLAYER then
				plyrstatus[1] = "Local Player"
				plyrstatus[2] = RGB(66, 135, 245)
			elseif table.find(menu.friends, v.Name) then
				plyrstatus[1] = "Friend"
				plyrstatus[2] = RGB(0, 255, 0)
			elseif table.find(menu.priority, v.Name) then
				plyrstatus[1] = "Priority"
				plyrstatus[2] = RGB(255, 210, 0)
			end
			
			table.insert(templist, {plyrname, teamtext, plyrstatus})
		end
		plist[5] = templist
		if playerlistval ~= nil then
			for i, v in ipairs(playerz) do
				if v.Name == playerlistval then
					selectedPlayer = v
					break
				end
				if i == #playerz then
					selectedPlayer = nil
					menu.list.setval(plist, nil)
				end
			end
		end
		menu:SetMenuPos(menu.x, menu.y)
	end
	
	local function setplistinfo(player, textonly)
		if not menu then return end
		if player ~= nil then
			local playerteam = "None"
			if player.Team ~= nil then
				playerteam = player.Team.Name
			end
			local playerhealth = "?"
			
			if player.Character ~= nil then
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoid ~= nil then
					if humanoid.Health ~= nil then
						playerhealth = tostring(humanoid.Health).. "/".. tostring(humanoid.MaxHealth)
					else
						playerhealth = "No health found"
					end
				else
					playerhealth = "Humanoid not found"
				end
			end
			
			plistinfo[1].Text = "Name: ".. player.Name.."\nTeam: ".. playerteam .."\nHealth: ".. playerhealth
			
			if textonly == nil then
				plistinfo[2].Data = BBOT_IMAGES[5]
				plistinfo[2].Data = game:HttpGet(Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100))
			end
		else
			plistinfo[2].Data = BBOT_IMAGES[5]
			plistinfo[1].Text = "No Player Selected"
		end
	end
	
	
	
	menu.list.removeall(menu.options["Settings"]["Player List"]["Players"])
	updateplist()
	setplistinfo(nil)
	
	
	local cachedValues = {
		FieldOfView = Camera.FieldOfView,
		FlyToggle = false
	}
	
	function menu:SetVisualsColor()
		if menu.unloaded == true then return end
		for i = 1, Players.MaxPlayers do
			local hdt = menu:GetVal("Visuals", "Player ESP", "Head Dot", "color")[4]
			allesp.headdot[i].Color = menu:GetVal("Visuals", "Player ESP", "Head Dot", "color", true)
			allesp.headdot[i].Transparency = hdt/255
			allesp.headdotoutline[i].Transparency = (hdt - 40)/255
			
			local boxt =menu:GetVal("Visuals", "Player ESP", "Box", "color")[4]
			allesp.box[i].Color = menu:GetVal("Visuals", "Player ESP", "Box", "color", true)
			allesp.box[i].Transparency = boxt
			allesp.innerbox[i].Transparency = boxt
			allesp.outerbox[i].Transparency = boxt
			
			allesp.hptext[i].Color = menu:GetVal("Visuals", "Player ESP", "Health Number", "color", true)
			allesp.hptext[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Health Number", "color")[4]/255
			
			allesp.name[i].Color = menu:GetVal("Visuals", "Player ESP", "Name", "color", true)
			allesp.name[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Name", "color")[4]/255
			
			
			allesp.team[i].Color = menu:GetVal("Visuals", "Player ESP", "Team", "color", true)
			allesp.team[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Team", "color")[4]/255
			
			allesp.distance[i].Color = menu:GetVal("Visuals", "Player ESP", "Distance", "color", true)
			allesp.distance[i].Transparency = menu:GetVal("Visuals", "Player ESP", "Distance", "color")[4]/255
		end
	end
	
	menu.tickbase_manip_added = false
	menu.tickbaseadd = 0
	
	local function SpeedHack()
		local speed = menu:GetVal("Misc", "Movement", "Speed Factor")

		if menu:GetVal("Misc", "Movement", "Speed") and LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Humanoid then
			if menu:GetVal("Misc", "Movement", "Speed Method") == 1 then
				local rootpart = LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart")
				
				if rootpart ~= nil then
					
					local travel = Vector3.new()
					local looking = Workspace.CurrentCamera.CFrame.lookVector
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
						travel += Vector3.new(looking.x,0,looking.Z)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
						travel -= Vector3.new(looking.x,0,looking.Z)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
						travel += Vector3.new(-looking.Z, 0, looking.x)
					end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
						travel += Vector3.new(looking.Z, 0, -looking.x)
					end
					
					travel = travel.Unit
					
					
					local newDir = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.Z * speed)
					
					if travel.Unit.x == travel.Unit.x then
						rootpart.Velocity = newDir
					end
				end
			elseif LOCAL_PLAYER.Character.Humanoid then
				LOCAL_PLAYER.Character.Humanoid.WalkSpeed = speed
			end
		end
	end
	
	local function FlyHack()
		if menu:GetVal("Misc", "Movement", "Fly") then
			local rootpart = LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart")
			if rootpart == nil then return end
			if menu:GetVal("Misc", "Movement", "Fly Method") == 2 then
				for lI, lV in pairs(LOCAL_PLAYER.Character:GetDescendants()) do
					if lV:IsA("BasePart") then
						lV.CanCollide = false
					end
				end
			end
			
			if cachedValues.FlyToggle then
				
				local speed = menu:GetVal("Misc", "Movement", "Fly Speed")
				
				local travel = Vector3.new()
				local looking = workspace.CurrentCamera.CFrame.lookVector --getting camera looking vector
				
				do
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W)         then travel += looking                               end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S)         then travel -= looking                               end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D)         then travel += Vector3.new(-looking.Z, 0, looking.x) end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A)         then travel += Vector3.new(looking.Z, 0, -looking.x) end
					
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space)     then travel += Vector3.new(0, 1, 0)                  end
					if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then travel -= Vector3.new(0, 1, 0)                  end
				end
				
				if travel.Unit.x == travel.Unit.x then
					rootpart.Anchored = false
					rootpart.Velocity = travel.Unit * speed --multiply the unit by the speed to make
				else
					rootpart.Velocity = Vector3.new(0, 0, 0)
					rootpart.Anchored = true
				end
				
			elseif cachedValues.FlyToggle then
				
				rootpart.Anchored = false
				cachedValues.FlyToggle = false
				
			end
		end
	end
	
	local function Aimbot()
		if menu:GetVal("Aimbot", "Aimbot", "Enabled") and INPUT_SERVICE:IsKeyDown(menu:GetVal("Aimbot", "Aimbot", "Enabled", "keybind")) then
			local organizedPlayers = {}
			local fovType = menu:GetVal("Aimbot", "Aimbot", "FOV Calculation")
			local fov = menu:GetVal("Aimbot", "Aimbot", "Aimbot FOV")
			local mousePos = Vector3.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36, 0)
			for i, v in ipairs(Players:GetPlayers()) do
				if v == LOCAL_PLAYER then
					continue
				end
				
				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
					
					local checks = menu:GetVal("Aimbot", "Aimbot", "Checks")
					local humanoid = v.Character:FindFirstChild("Humanoid")
					if humanoid then
						if checks[1] and humanoid.Health <= 0 then
							continue
						end
					end
					local pos = Camera:WorldToViewportPoint(v.Character.Head.Position)
					if fovType == 1 and(pos - mousePos).Magnitude > fov and fov ~= 0 then
						continue
					end
					if checks[2] and v.Team and v.Team == LOCAL_PLAYER.Team then
						continue
					end
					if checks[3] and LOCAL_PLAYER:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)/5 > menu:GetVal("Aimbot", "Aimbot", "Max Distance") then
						continue
					end
					
					table.insert(organizedPlayers, v)
					
				end
			end
			
			
			table.sort(organizedPlayers, function(a, b)
				local aPos, aVis = workspace.CurrentCamera:WorldToViewportPoint(a.Character.Head.Position)
				local bPos, bVis = workspace.CurrentCamera:WorldToViewportPoint(b.Character.Head.Position)
				if aVis and not bVis then return true end
				if bVis and not aVis then return false end
				return (aPos-mousePos).Magnitude < (bPos-mousePos).Magnitude
			end)
			
			for i, v in ipairs(organizedPlayers) do
				local humanoid = v.Character:FindFirstChild("Humanoid")
				local rootpart = v.Character.HumanoidRootPart.Position
				local head = v.Character:FindFirstChild("Head")
				
				if head then
					local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
					
					if onscreen then
						if INPUT_SERVICE.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
							mousemoveabs(pos.x, pos.y) --TODO NATE FIX THIS AIMBOT MAKE IT HEAT AND MAKE IT SORT BY FOV
						else
							Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
						end
						return
					end
				end
			end
		end
	end
	
	local oldslectedplyr = nil
	menu.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
		if input.KeyCode == menu:GetVal("Misc", "Exploits", "Shift Tick Base", "keybind") then
			menu.tickbaseadd = 0
		end
		if menu:GetVal("Misc", "Movement", "Fly") and input.KeyCode == menu:GetVal("Misc", "Movement", "Fly", "keybind") then
			cachedValues.FlyToggle = not cachedValues.FlyToggle
			LOCAL_PLAYER.Character.HumanoidRootPart.Anchored = false
		end
		if menu:GetVal("Misc", "Movement", "Mouse Teleport") and input.KeyCode == menu:GetVal("Misc", "Movement", "Mouse Teleport", "keybind") then
			local targetPos = LOCAL_MOUSE.Hit.p
			local RP = LOCAL_PLAYER.Character.HumanoidRootPart
			RP.CFrame = CFrame.new(targetPos + Vector3.new(0,7,0))
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if menu.open then
				if menu.tickbase_manip_added == false and menu:GetVal("Misc", "Exploits", "Enable Tick Manipulation") then
					shared.tick_ref = hookfunc(tick, function()
						if not menu then
							return shared.tick_ref()
						elseif menu:GetVal("Misc", "Exploits", "Enable Tick Manipulation") and menu:GetVal("Misc", "Exploits", "Shift Tick Base") and INPUT_SERVICE:IsKeyDown(menu:GetVal("Misc", "Exploits", "Shift Tick Base", "keybind")) then
							menu.tickbaseadd += menu:GetVal("Misc", "Exploits", "Shifted Tick Base Add") * 0.001
							return shared.tick_ref() + menu.tickbaseadd
						else
							return shared.tick_ref()
						end
					end)
					menu.tickbase_manip_added = true
				end
				
				if menu.tabnames[menu.activetab] == "Settings" and menu.open then
					game.RunService.Stepped:wait()
					
					updateplist()
					
					if selectedPlayer ~= nil then
						--print(LOCAL_MOUSE.x - menu.x, LOCAL_MOUSE.y - menu.y)
						if menu:MouseInMenu(28, 68, 448, 238) then
							if table.find(menu.friends, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 2
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Friend"
							elseif table.find(menu.priority, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 3
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Priority"
							else
								menu.options["Settings"]["Player List"]["Player Status"][1] = 1
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
							end
						end
						
						
						for k, table_ in pairs({menu.friends, menu.priority}) do
							for index, plyrname in pairs(table_) do
								if selectedPlayer.Name == plyrname then
									table.remove(table_, index)
								end
							end
						end
						if menu:GetVal("Settings", "Player List", "Player Status") == 2 then
							if not table.find(menu.friends, selectedPlayer.Name) then
								table.insert(menu.friends, selectedPlayer.Name)
								WriteRelations()
							end
						elseif menu:GetVal("Settings", "Player List", "Player Status") == 3 then
							if not table.find(menu.priority, selectedPlayer.Name) then
								table.insert(menu.priority, selectedPlayer.Name)
								WriteRelations()
							end
						end
					else
						menu.options["Settings"]["Player List"]["Player Status"][1] = 1
						menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
					end
					
					updateplist()
					
					if plist[1] ~= nil then
						if oldslectedplyr ~= selectedPlayer then
							setplistinfo(selectedPlayer)
							oldslectedplyr = selectedPlayer
						end
					else
						setplistinfo(nil)
					end
					
					
				end
				
				game.RunService.Stepped:wait()
				if not menu then return end
				local crosshairvis = menu:GetVal("Visuals", "Misc Visuals", "Custom Crosshair")
				for k, v in pairs(menu.crosshair) do
					v[1].Visible = crosshairvis
					v[2].Visible = crosshairvis
				end
				if menu:GetVal("Visuals", "Misc Visuals", "Draw Aimbot FOV") and menu:GetVal("Aimbot", "Aimbot", "Enabled") then
					menu.fovcircle[1].Visible = true
					menu.fovcircle[2].Visible = true
					
					menu.fovcircle[2].Color = menu:GetVal("Visuals", "Misc Visuals", "Draw Aimbot FOV", "color", true)
					local transparency = menu:GetVal("Visuals", "Misc Visuals", "Draw Aimbot FOV", "color")[4]
					menu.fovcircle[1].Transparency = (transparency - 40) /255
					menu.fovcircle[2].Transparency = transparency/255
				else
					menu.fovcircle[1].Visible = false
					menu.fovcircle[2].Visible = false
				end
				if menu:GetVal("Visuals", "Misc Visuals", "Custom Crosshair") then
					local size = menu:GetVal("Visuals", "Misc Visuals", "Crosshair Size")
					local color = menu:GetVal("Visuals", "Misc Visuals", "Custom Crosshair", "color", true)
					menu.crosshair.inner[1].Size = Vector2.new(size * 2 + 1, 1)
					menu.crosshair.inner[2].Size = Vector2.new(1, size * 2 + 1)
					
					menu.crosshair.inner[1].Color = color
					menu.crosshair.inner[2].Color = color
					
					
					menu.crosshair.outline[1].Size = Vector2.new(size * 2 + 3, 3)
					menu.crosshair.outline[2].Size = Vector2.new(3, size * 2 + 3)
				end
				menu:SetVisualsColor()
			end
		end
	end)
	
	-- local function Aimbot()
	-- 	if
	-- end
	
	
	menu.connections.renderstepped2 = game.RunService.RenderStepped:Connect(function()
		
		SpeedHack()
		FlyHack()
		Aimbot()
		
		if menu.open then
			if menu.tabnames[menu.activetab] == "Settings" then
				if plist[1] ~= nil then
					setplistinfo(selectedPlayer, true)
				end
			end
		end
		
		if menu:GetVal("Visuals", "Misc Visuals", "Custom Crosshair") then
			local size = menu:GetVal("Visuals", "Misc Visuals", "Crosshair Size")
			if menu:GetVal("Visuals", "Misc Visuals", "Crosshair Position") == 1 then
				menu.crosshair.inner[1].Position = Vector2.new(SCREEN_SIZE.x/2 - size, SCREEN_SIZE.y/2)
				menu.crosshair.inner[2].Position = Vector2.new(SCREEN_SIZE.x/2, SCREEN_SIZE.y/2 - size)
				
				menu.crosshair.outline[1].Position = Vector2.new(SCREEN_SIZE.x/2 - size - 1, SCREEN_SIZE.y/2 - 1)
				menu.crosshair.outline[2].Position = Vector2.new(SCREEN_SIZE.x/2 - 1, SCREEN_SIZE.y/2 - 1 - size)
			else
				-- INPUT_SERVICE.MouseIconEnabled = false
				menu.crosshair.inner[1].Position = Vector2.new(LOCAL_MOUSE.x - size, LOCAL_MOUSE.y + 36)
				menu.crosshair.inner[2].Position = Vector2.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36 - size)
				
				menu.crosshair.outline[1].Position = Vector2.new(LOCAL_MOUSE.x - size - 1, LOCAL_MOUSE.y + 35)
				menu.crosshair.outline[2].Position = Vector2.new(LOCAL_MOUSE.x - 1, LOCAL_MOUSE.y + 35 - size)
			end
		end
		
		if menu:GetVal("Visuals", "Local Visuals", "Change FOV") then
			Camera.FieldOfView = menu:GetVal("Visuals", "Local Visuals", "Camera FOV")
		end
		
		if menu:GetVal("Visuals", "Misc Visuals", "Draw Aimbot FOV") and menu:GetVal("Aimbot", "Aimbot", "Enabled") then
			menu.fovcircle[1].Position = Vector2.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
			menu.fovcircle[2].Position = Vector2.new(LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
			
			local aimfov = menu:GetVal("Aimbot", "Aimbot", "Aimbot FOV")
			if menu:GetVal("Aimbot", "Aimbot", "FOV Calculation") == 2 then
				menu.fovcircle[1].Radius = aimfov / Camera.FieldOfView * Camera.ViewportSize.y
				menu.fovcircle[2].Radius = aimfov / Camera.FieldOfView * Camera.ViewportSize.y
			elseif menu.open then
				menu.fovcircle[1].Radius = aimfov
				menu.fovcircle[2].Radius = aimfov
			end
		end
		
		CreateThread(function()
			for k, v in pairs(allesp) do
				for k1, v1 in ipairs(v) do
					if v1.Visible then
						v1.Visible = false
					end
				end
			end
			
			local organizedPlayers = {}
			for i, v in ipairs(Players:GetPlayers()) do
				if v == LOCAL_PLAYER then
					continue
				end
				
				if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
					
					local checks = menu:GetVal("Visuals", "ESP Settings", "Checks")
					local humanoid = v.Character:FindFirstChild("Humanoid")
					if humanoid then
						if checks[1] and humanoid.Health <= 0 then
							continue
						end
					end
					if v.Team ~= nil then
						if checks[2] and v.Team == LOCAL_PLAYER.Team then
							continue
						end
					end
					if checks[3] and LOCAL_PLAYER:DistanceFromCharacter(v.Character.HumanoidRootPart.Position)/5 > menu:GetVal("Visuals", "ESP Settings", "Max Distance") then
						continue
					end
					
					table.insert(organizedPlayers, v)
					
				end
			end
			
			if menu:GetVal("Visuals", "ESP Settings", "ESP Sorting") == 2 then
				table.sort(organizedPlayers, function(a, b)
					return LOCAL_PLAYER:DistanceFromCharacter(a.Character.HumanoidRootPart.Position) > LOCAL_PLAYER:DistanceFromCharacter(b.Character.HumanoidRootPart.Position)
				end)
			end
			
			for i, v in ipairs(organizedPlayers) do
				local humanoid = v.Character:FindFirstChild("Humanoid")
				local rootpart = v.Character.HumanoidRootPart.Position
				
				local cam = Camera.CFrame
				local torso = v.Character.PrimaryPart.CFrame
				local head = v.Character.Head.CFrame
				-- local vTop = torso.Position + (torso.UpVector * 1.8) + cam.UpVector
				-- local vBottom = torso.Position - (torso.UpVector * 2.5) - cam.UpVector
				local top, top_isrendered = workspace.CurrentCamera:WorldToViewportPoint(head.Position + (torso.UpVector * 1.3) + cam.UpVector)
				local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToViewportPoint(torso.Position - (torso.UpVector * 3) - cam.UpVector)
				
				local minY = math.abs(bottom.y - top.y)
				local sizeX = math.ceil(math.max(math.clamp(math.abs(bottom.x - top.x) * 2, 0, minY), minY / 2))
				local sizeY = math.ceil(math.max(minY, sizeX * 0.5))
				
				if top_isrendered or bottom_isrendered then
					local boxtop = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - sizeX * 0.5), math.floor(math.min(top.y, bottom.y)))
					local boxsize = {w = sizeX, h =  sizeY}
					
					if menu:GetVal("Visuals", "Player ESP", "Head Dot") then
						local head = v.Character:FindFirstChild("Head")
						if head then
							local headpos = head.Position
							local headdotpos = workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(headpos.x, headpos.y, headpos.z))
							local headdotpos_b = workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(headpos.x, headpos.y - 0.3, headpos.z))
							local difference = headdotpos_b.y - headdotpos.y
							allesp.headdot[i].Visible = true
							allesp.headdot[i].Position = Vector2.new(headdotpos.x, headdotpos.y - difference)
							allesp.headdot[i].Radius = difference * 2
							
							allesp.headdotoutline[i].Visible = true
							allesp.headdotoutline[i].Position = Vector2.new(headdotpos.x, headdotpos.y - difference)
							allesp.headdotoutline[i].Radius = difference * 2
						end
					end
					if menu:GetVal("Visuals", "Player ESP", "Box") then
						allesp.outerbox[i].Position = Vector2.new(boxtop.x - 1, boxtop.y - 1)
						allesp.outerbox[i].Size = Vector2.new(boxsize.w + 2, boxsize.h + 2)
						allesp.outerbox[i].Visible = true
						
						allesp.innerbox[i].Position = Vector2.new(boxtop.x + 1, boxtop.y + 1)
						allesp.innerbox[i].Size = Vector2.new(boxsize.w - 2, boxsize.h - 2)
						allesp.innerbox[i].Visible = true
						
						allesp.box[i].Position = Vector2.new(boxtop.x, boxtop.y)
						allesp.box[i].Size = Vector2.new(boxsize.w, boxsize.h)
						allesp.box[i].Visible = true
					end
					if humanoid then
						local health = math.ceil(humanoid.Health)
						local maxhealth = humanoid.MaxHealth
						if menu:GetVal("Visuals", "Player ESP", "Health Bar") then
							allesp.healthouter[i].Position = Vector2.new(boxtop.x - 6, boxtop.y - 1)
							allesp.healthouter[i].Size = Vector2.new(4, boxsize.h + 2)
							allesp.healthouter[i].Visible = true
							
							
							local ySizeBar = -math.floor(boxsize.h * health / maxhealth)
							
							allesp.healthinner[i].Position = Vector2.new(boxtop.x - 5, boxtop.y + boxsize.h)
							allesp.healthinner[i].Size = Vector2.new(2, ySizeBar)
							allesp.healthinner[i].Visible = true
							allesp.healthinner[i].Color = ColorRange(health, {
								[1] = {start = 0, color = menu:GetVal("Visuals", "Player ESP", "Health Bar", "color1", true)},
								[2] = {start = 100, color = menu:GetVal("Visuals", "Player ESP", "Health Bar", "color2", true)}
							})
							
							if menu:GetVal("Visuals", "Player ESP", "Health Number") then
								allesp.hptext[i].Text = tostring(health)
								local textsize = allesp.hptext[i].TextBounds
								allesp.hptext[i].Position = Vector2.new(boxtop.x - 7 - textsize.x, boxtop.y + math.clamp(boxsize.h + ySizeBar - 8, -4, boxsize.h - 10))
								allesp.hptext[i].Visible = true
							end
							
						elseif menu:GetVal("Visuals", "Player ESP", "Health Number") then
							allesp.hptext[i].Text = tostring(health)
							local textsize = allesp.hptext[i].TextBounds
							allesp.hptext[i].Position = Vector2.new(boxtop.x - 2 - textsize.x, boxtop.y - 4)
							allesp.hptext[i].Visible = true
						end
					end
					if menu:GetVal("Visuals", "Player ESP", "Name") then
						local name_pos = Vector2.new(math.floor(boxtop.x + boxsize.w*0.5), math.floor(boxtop.y - 15))
						allesp.name[i].Text = v.Name
						allesp.name[i].Position = name_pos
						allesp.name[i].Visible = true
						
					end
					local y_spot = 0
					if menu:GetVal("Visuals", "Player ESP", "Team") then
						if v.Team == nil then
							allesp.team[i].Text = "None"
						else
							allesp.team[i].Text = v.Team.Name
						end
						if menu:GetVal("Visuals", "Player ESP", "Team Color Based") then
							if v.Team == nil then
								allesp.team[i].Color = RGB(255, 255, 255)
							else
								allesp.team[i].Color = v.TeamColor.Color
							end
						end
						local team_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h)
						allesp.team[i].Position = team_pos
						allesp.team[i].Visible = true
						y_spot += 14
					end
					if menu:GetVal("Visuals", "Player ESP", "Distance") then
						local dist_pos = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h + y_spot)
						allesp.distance[i].Text = tostring(math.ceil(LOCAL_PLAYER:DistanceFromCharacter(rootpart) / 5)).. "m"
						allesp.distance[i].Position = dist_pos
						allesp.distance[i].Visible = true
					end
				end
			end
		end)
	end)
	
	menu.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
		updateplist()
		if plist[1] ~= nil then
			setplistinfo(selectedPlayer)
		else
			setplistinfo(nil)
		end
	end)
	
	menu.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
		updateplist()
	end)
	
elseif menu.game == "pf" then --!SECTION
	menu.activetab = 6
	menu.annoylist = table.create(game.Players.MaxPlayers - 1)

	local sphereHitbox = Instance.new("Part", workspace)
	sphereHitbox.Name = "abcdefg"
	local diameter
	do
		diameter = 11 -- up to 12 works
		sphereHitbox.Size = Vector3.new(diameter, diameter, diameter)
		sphereHitbox.Position = Vector3.new()
		sphereHitbox.Shape = Enum.PartType.Ball
		sphereHitbox.Transparency = 1
		sphereHitbox.Anchored = true
		sphereHitbox.CanCollide = false
	end
	
	local keybindtoggles = {
		crash = false, 
		flyhack = false,
		thirdperson = false,
		fakebody = false, 
		invis = false,
		fakelag = false,
		crimwalk = false,
		freeze = false
	}
	
	menu.activenades = {}
	
	local shitting_my_pants = false
	local stylis = {
		[525919] = true, 
		[1667819] = true, 
		[195329] = true, 
		[5725475] = true, 
		[52250025] = true, 
		[18659509] = true, 
		[31137804] = true, 
		[484782977] = true, -- superusers end here, anything else following is just people i know that could probably have direct access to a developer console or data store or anything to catch us in the act of creating and abusing and exploiting their game
		[750972253] = true, 
		[169798359] = true, -- not confirmed but this dude has a tag with no equal signs so kinda sus and he respond to ltierally no fucking body
		[94375158] = true,
		[53275569] = true, -- banlands advocate
		[2346908601] = true, -- sus
		[192018294] = true,
		[73654327] = true,
		[1509251] = true,
		[151207617] = true,
	}
	
	CreateThread(function()
		while wait(2) do -- fuck off
			local count = 0
			for _, player in next, Players:GetPlayers() do
				local d = stylis[player.UserId]
				if d then count += 1 end
			end
			shitting_my_pants = count > 0
		end
	end)
	
	--SECTION PF BEGIN
	
	local allesp = {
		skel = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
		},
		box = {[1] = {}, [2] = {}, [3] = {}},
		hp = {
			outer = {},
			inner = {},
			text = {}
		},
		text = {
			name = {},
			weapon = {},
			distance = {}
		},
		arrows = {
			[1] = {},
			[2] = {},
		},
		watermark = {},
	}
	
	local wepesp = {
		name = {},
		ammo = {}
	}
	
	local nadeesp = {
		outer_c = {},
		inner_c = {},
		distance = {},
		text = {},
		bar_outer = {},
		bar_inner = {},
		bar_moving_1 = {},
		bar_moving_2 = {}
	}
	
	for i = 1, 50 do
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, wepesp.name)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, wepesp.ammo)
	end
	
	for i = 1, 20 do
		Draw:FilledCircle(false, 60, 60, 32, 1, 20, {20, 20, 20, 215}, nadeesp.outer_c)
		Draw:Circle(false, 60, 60, 30, 1, 20, {50, 50, 50, 255}, nadeesp.inner_c)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, nadeesp.distance)
		Draw:Image(false, BBOT_IMAGES[6], 20, 20, 23, 30, 1, nadeesp.text)
		--Draw:OutlinedText("NADE", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, nadeesp.text)
		
		Draw:OutlinedRect(false, 20, 20, 32, 6, {50, 50, 50, 255}, nadeesp.bar_outer)
		Draw:FilledRect(false, 20, 20, 30, 4, {30, 30, 30, 255}, nadeesp.bar_inner)
		
		Draw:FilledRect(false, 20, 20, 2, 20, {30, 30, 30, 255}, nadeesp.bar_moving_1)
		Draw:FilledRect(false, 20, 20, 2, 20, {30, 30, 30, 255}, nadeesp.bar_moving_2)
	end

	for i = 1, 35 do
		for i_ = 1, 2 do
			Draw:Triangle(false, i_ == 1, nil, nil, nil, {255}, allesp.arrows[i_])
		end
		for i_, v in ipairs(allesp.skel) do
			Draw:Line(false, 1, 30, 30, 50, 50, {255, 255, 255, 255}, v)
		end
		for i_, v in pairs(allesp.box) do
			Draw:OutlinedRect(false, 20, 20, 20, 20, {0, 0, 0, 220}, v)
		end
		
		Draw:FilledRect(false, 20, 20, 20, 20, {10, 10, 10, 210}, allesp.hp.outer)
		Draw:FilledRect(false, 20, 20, 20, 20, {10, 10, 10, 255}, allesp.hp.inner)
		Draw:OutlinedText("", 1, false, 20, 20, 13, false, {255, 255, 255, 255}, {0, 0, 0}, allesp.hp.text)
		
		for i_, v in pairs(allesp.text) do
			Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, v)
		end
	end
	
	local bodysize = {
		["Head"] = Vector3.new(2, 1, 1),
		["Torso"] = Vector3.new(2, 2, 1),
		["HumanoidRootPart"] = Vector3.new(0.2, 0.2, 0.2),
		["Left Arm"] = Vector3.new(1, 2, 1),
		["Right Arm"] = Vector3.new(1, 2, 1),
		["Left Leg"] = Vector3.new(1, 2, 1),
		["Right Leg"] = Vector3.new(1, 2, 1)
	}
	
	local client = {}
	local legitbot = {}
	local misc = {}
	local ragebot = {}
	local camera = {}
	
	
	client.loadedguns = {}
	
	local raycastutil
	
	for k, v in pairs(getgc(true)) do
		if type(v) == "function" then
			if getinfo(v).name == "bulletcheck" then
				client.bulletcheck = v
			elseif getinfo(v).name == "trajectory" then
				client.trajectory = v
			elseif getinfo(v).name == "call" then
				client.call = v
			elseif getinfo(v).name == "loadplayer" then
				client.loadplayer = v
			elseif getinfo(v).name == "rankcalculator" then
				client.rankcalculator = v
			elseif getinfo(v).name == "gunbob" then
				client.gunbob = v
			elseif getinfo(v).name == "gunsway" then
				client.gunsway = v
			end
			for k1, v1 in pairs(debug.getupvalues(v)) do
				if type(v1) == "table" then
					if rawget(v1, "send") then
						client.net = v1
					elseif rawget(v1, "gammo") then
						client.logic = v1
					elseif rawget(v1, "setbasewalkspeed") then
						client.char = v1
					elseif rawget(v1, "basecframe") then
						client.cam = v1
					elseif rawget(v1, "votestep") then
						client.hud = v1
					elseif rawget(v1, "getbodyparts") then
						client.replication = v1
					elseif rawget(v1, "play") then
						client.sound = v1
					elseif rawget(v1, "checkkillzone") then
						client.roundsystem = v1
					end
				end
			end
		end
		
		if type(v) == "table" then
			if rawget(v, "deploy") then
				client.menu = v
				local olddeploy = v.deploy
			elseif rawget(v, "new") and rawget(v, "step") and rawget(v, "reset") then
				client.particle = v
			elseif rawget(v, "unlocks") then
				client.dirtyplayerdata = v
			elseif rawget(v, "toanglesyx") then
				client.vectorutil = v
			elseif rawget(v, "IsVIP") then
				client.instancetype = v
			elseif rawget(v, "timehit") then
				client.physics = v
			elseif rawget(v, "raycastSingleExit") then
				raycastutil = v
			elseif rawget(v, "bulletLifeTime") then
				client.publicsettings = v
			elseif rawget(v, "player") and rawget(v, "reset") then
				client.animation = v
				client.animation.oldplayer = client.animation.player
			elseif rawget(v, "task") and rawget(v, "dependencies") and rawget(v, "name") == "camera" then
				local oldtask = rawget(v, "task")
				rawset(v, "task", function(...)
					oldtask(...)
					local newCF = (ragebot.silentVector and menu:GetVal("Rage", "Aimbot", "Rotate Viewmodel") and client.logic.currentgun and client.logic.currentgun.type ~= "KNIFE") and CFrame.lookAt(ragebot.firepos + (ragebot.firepos - client.cam.basecframe.p), ragebot.targetpart.Position) or nil
					client.cam.shakecframe = newCF and newCF or client.cam.cframe
					return
				end)
			end
		end
	end
	
	local function animhook(...)
		return function(...) end
	end

	client.loadedguns = getupvalue(client.char.unloadguns, 2) -- i hope this works
	
	client.roundsystem.lock = nil -- we do a little trolling

	client.lastlock = false -- fucking dumb

	setrawmetatable(client.roundsystem, {
		__index = function(self, val)
			if not menu then
				setrawmetatable(self, nil)
				return false
			end

			if val == "lock" then
				if menu.textboxopen then 
					return true 
				end

				if menu:GetVal("Misc", "Movement", "Ignore Round Freeze") then
					return false
				else
					return client.lastlock
				end
			end
		end,
		__newindex = function(self, key, value)
			if not menu then
				setrawmetatable(self, nil)
				pcall(rawset, self, key, value)
				return
			end

			if key == "lock" then
				client.lastlock = value
				return
			end
		end
	})

	local debris = game:service("Debris")
	local teamdata = {}
	do
		local pgui = game.Players.LocalPlayer.PlayerGui
		local board = pgui:WaitForChild("Leaderboard")
		local main = board:WaitForChild("Main")
		local global = board:WaitForChild("Global")
		local ghost = main:WaitForChild("Ghosts")
		local phantom = main:WaitForChild("Phantoms")
		local gdataframe = ghost:WaitForChild("DataFrame")
		local pdataframe = phantom:WaitForChild("DataFrame")
		local ghostdata = gdataframe:WaitForChild("Data")
		local phantomdata = pdataframe:WaitForChild("Data")
		teamdata[1] = phantomdata
		teamdata[2] = ghostdata
	end
	
	local GetPlayerData = function(player_name)
		return teamdata[1]:FindFirstChild(player_name) or teamdata[2]:FindFirstChild(player_name)
	end
	
	local CommandInfo = {
		targetbelowrank = "<number> rank",
		friendaboverank = "<number> rank",
		annoy = "player name",
		clearannoylist = "clear the annoy list, if anyone exists in it",
		friend = "player name",
		target = "player name",
		updatechatspam = "",
		cmdlist = "list commands, idk how you're even seeing this right now you're not supposed to see this bimbo"
	}
	
	local CommandFunctions = {
		targetbelowrank = function(min)
			local targetted = 0
			for k, player in pairs(Players:GetPlayers()) do
				local data = GetPlayerData(player.Name)
				if data.Rank.Text < min then
					table.insert(menu.priority, player.Name)
					targetted += 1
				end
			end
			CreateNotification(("Targetted %d players below rank %d"):format(targetted, min))
		end,
		friendaboverank = function(max)
			local targetted = 0
			for k, player in pairs(Players:GetPlayers()) do
				local data = GetPlayerData(player.Name)
				if data.Rank.Text > max then
					table.insert(menu.friends, player.Name)
					targetted += 1
				end
			end
			CreateNotification(("Friended %d players below rank %d"):format(targetted, max))
		end,
		annoy = function(name)
			if name:lower():match(LOCAL_PLAYER.Name:lower()) then
				return CreateNotification("You cannot annoy yourself!")
			end
			for _, player in next, Players:GetPlayers() do
				if player.Name:lower():match(name:lower()) then
					local exists = table.find(menu.annoylist, player.Name)
					if not exists then
						table.insert(menu.annoylist, player.Name)
					else
						table.remove(menu.annoylist, exists)
						return CreateNotification("No longer repeating everything " .. player.Name .. " says in chat.")
					end
					return CreateNotification("Now repeating everything " .. player.Name .. " says in chat.")
				end
			end
			CreateNotification("No such player by the name '" .. name .. "' was found in the game.")
		end,
		clearannoylist = function()
			table.clear(menu.annoylist)
		end,
		friend = function(name)
			for _, player in next, Players:GetPlayers() do
				if player.Name:lower():match(name:lower()) then
					table.insert(menu.friends, name)
					return CreateNotification("Friended " .. name)
				end
			end
			CreateNotification("No such player by the name '" .. name .. "' was found in the game.")
		end,
		target = function(name)
			for _, player in next, Players:GetPlayers() do
				if player.Name:lower():match(name:lower()) then
					table.insert(menu.priority, name)
					return CreateNotification("Prioritized " .. name)
				end
			end
			CreateNotification("No such player by the name '" .. name .. "' was found in the game.")
		end,
		updatechatspam = function()
			customChatSpam = {}
			if isfile("bitchbot/chatspam.txt") then
				local customtxt = readfile("bitchbot/chatspam.txt")
				for s in customtxt:gmatch("[^\n]+") do -- I'm Love String:Match
					table.insert(customChatSpam, s)
				end
			end
			CreateNotification("Custom Chatspam Updated")
		end,
		cmdlist = function(self)
			client.bbconsole("k")
			for cmdname, _ in next, self do
				if cmdname ~= "cmdlist" then
					local cmdinfo = CommandInfo[cmdname] or ""
					client.bbconsole(("\\%s: %s"):format(cmdname, cmdinfo))
				end
			end
		end
	}

	menu.pfunload = function(self)
		for k,v in next, Players:GetPlayers() do
			local bodyparts = client.replication.getbodyparts(v)
			if bodyparts then
				bodyparts.head.HELMET.Slot1.Transparency = 0
				bodyparts.head.HELMET.Slot2.Transparency = 0
			end
		end
		
		local funcs = getupvalue(client.call, 1)
		
		for hash, func in next, funcs do
			if is_synapse_function(func) then
				for k,v in next, getupvalues(func) do
					if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
						funcs[hash] = v
					end
				end
			end
		end
		
		setupvalue(client.call, 1, funcs)
		
		for k,v in next, getinstances() do -- hacky way of getting rid of bbot adornments and such, but oh well lol it works
			if v.ClassName:match("Adornment") then
				v.Visible = false
				v:Destroy()
			end
		end
		
		for k,v in next, getgc(true) do
			if type(v) == "table" then
				if rawget(v, "task") and rawget(v, "dependencies") and rawget(v, "name") == "camera" then
					for k1, v1 in next, getupvalues(rawget(v, "task")) do
						if type(v1) == "function" and islclosure(v1) and not is_synapse_function(v1) then
							v.task = v1
						end
					end
					break
				end
			end
		end
		
		if client.char.alive then
			for id, gun in next, client.loadedguns do
				for k,v in next, gun do
					
					if type(v) == "function" then
						
						local upvs = getupvalues(v)
						
						for k1, v1 in next, upvs do
							
							if type(v1) == "function" and is_synapse_function(v1) then
								
								for k2, v2 in next, getupvalues(v1) do
									
									if type(v2) == "function" and islclosure(v2) and not is_synapse_function(v2) then
										
										setupvalue(v, k1, v2)
										
									end
								end
							end
						end
					end
				end
			end
		end
		
		local spring = require(game.ReplicatedFirst.SharedModules.Utilities.Math.spring)
		spring.__index = client.springindex

		client.fake_upvs = nil
		DeepRestoreTableFunctions(client)
		
		local gunstore = game.ReplicatedStorage.GunModules
		gunstore:Destroy()
		game.ReplicatedStorage:FindFirstChild(client.acchash).Name = "GunModules" -- HACK DETECTED.
		
		local lighting = game.Lighting
		local defaults = lighting.MapLighting
		
		lighting.Ambient = defaults.Ambient.Value
		lighting.OutdoorAmbient = defaults.OutdoorAmbient.Value
		lighting.Brightness = defaults.Brightness.Value
		
		workspace.Ignore.DeadBody:ClearAllChildren()
		
		for k,v in next, client do
			client[k] = nil
		end
		
		for k,v in next, ragebot do
			ragebot[k] = nil
		end
		
		for k,v in next, legitbot do
			legitbot[k] = nil
		end
		
		for k,v in next, misc do
			misc[k] = nil
		end
		
		for k,v in next, camera do
			camera[k] = nil
		end
		
		client = nil
		ragebot = nil
		legitbot = nil
		misc = nil
		camera = nil
		DeepRestoreTableFunctions = nil
	end
	
	local charcontainer = game.ReplicatedStorage.Character.Bodies
	local ghostchar = game.ReplicatedStorage.Character.Bodies.Ghost
	local phantomchar = game.ReplicatedStorage.Character.Bodies.Phantom
	
	local repupdates = {}
	
	for _, player in next, Players:GetPlayers() do
		if player == LOCAL_PLAYER then continue end
		repupdates[player] = {}
	end
	
	client.localrank = client.rankcalculator(client.dirtyplayerdata.stats.experience)
	
	client.fakeplayer = Instance.new("Player", Players) -- thank A_003 for this (third person body)🔥
	client.fakeplayer.Name = " "
	client.fakeplayer.Team = LOCAL_PLAYER.Team
	
	debug.setupvalue(client.loadplayer, 1, client.fakeplayer)
	client.fakeupdater = client.loadplayer(LOCAL_PLAYER)
	debug.setupvalue(client.loadplayer, 1, LOCAL_PLAYER)
	
	client.fakeplayer.Parent = nil
	do
		local updatervalues = getupvalues(client.fakeupdater.step)
		
		--[[updatervalues[11].s = 7
		updatervalues[15].s = 100]]
		client.fake_upvs = updatervalues
	end
	
	local PLAYER_GUI = LOCAL_PLAYER.PlayerGui
	local CHAT_GAME = LOCAL_PLAYER.PlayerGui.ChatGame
	local CHAT_BOX = CHAT_GAME:FindFirstChild("TextBox")
	
	local shooties = {}
	
	local OLD_GUNS = game:GetService("ReplicatedStorage").GunModules:Clone()
	OLD_GUNS.Name = tostring(math.random(1e5, 9e5))
	client.acchash = OLD_GUNS.Name
	OLD_GUNS.Parent = game:GetService("ReplicatedStorage")
	
	local CUR_GUNS = game:GetService("ReplicatedStorage").GunModules

	
	local selectedPlayer = nil
	
	local players = {
		Enemy = {},
		Team = {}
	}
	
	local mats = {"SmoothPlastic", "ForceField", "Neon", "Foil", "Glass"}
	local chatspams = {
		["lastchoice"] = 0,
		[1] = nil,
		[2] = {
			"㭁ITCH BOT ON TOP ",
			"BBOT ON TOP 🔥🔥🔥🔥",
			"b个tchbot on top i think ",
			"bbot > all ",
			"㭁ITCH BOT > ALL🧠 ",
			"WHAT SCRIPT IS THAT???? BBOT! ",
			"b㐃tch bot ",
		},
		[3] = {
			"but doctor prognosis: OWNED ",
			"but doctor results: 🔥",
			"looks like you need to talk to your doctor ",
			"speak to your doctor about this one ",
			"but analysis: PWNED ",
			"but diagnosis: OWND ",
		},
		[4] = {
			"音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
			"持有毁灭性的神经重景气游行脸红青铜色类别创意案",
			"诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
			"完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
			"庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
			"坐下，一直保持着安静的状态。 谁把他拥有的东西给了他，所以他不那么爱欠债务，却拒绝参加锻炼，这让他爱得更少了",
			", yīzhí bǎochízhe ānjìng de zhuàngtài. Shéi bǎ tā yǒngyǒu de dōngxī gěile tā, suǒyǐ tā bù nàme ài qiàn zhàiwù, què jùjué cānjiā duànliàn, z",
			"他，所以他不那r给了他东西给了他爱欠s，却拒绝参加锻炼，这让他爱得更UGT少了",
			"bbot 有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
			"wocky slush他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼",
			"坐下，一直保持着安静的状态bbot 谁把他拥有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
			"免费手榴弹bbot hack绕过作弊工作Phantom Force roblox aimbot瞄准无声目标绕过2020工作真正免费下载和使用",
			"zal發明了roblox汽車貿易商的船長ro blocks，並將其洩漏到整個宇宙，還修補了虛假的角神模式和虛假的身體，還發明了基於速度的AUTOWALL和無限制的自動壁紙遊戲 ",
			"彼が誤って禁止されたためにファントムからautowallgamingを禁止解除する請願とそれはでたらめですそれはまったく意味がありませんなぜあなたは合法的なプレーヤーを禁止するのですか ",
			"ジェイソンは私が神に誓う女性的な男の子ではありません ",
			"傑森不是我向上帝發誓女性男孩 "
		},
		[5] = {
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
		[6] = {
			"gEt OuT oF tHe GrOuNd 🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡 ",
			"brb taking a nap 💤💤💤 ",
			"gonna go take a walk 🚶‍♂️🚶‍♀️🚶‍♂️🚶‍♀️ ",
			"low orbit ion cannon booting up ",
			"how does it feel to not have bbot 🤣🤣🤣😂😂😹😹😹 ",
			"im a firing my laza! 🙀🙀🙀 ",
			"😂😂😂😂😂GAMING CHAIR😂😂😂😂😂",
			"NEXUS ",
			"NEXUS ON TOP ",
			"ｎｅｘｕｓ ｄｏｅｓｎ＇ｔ ｃａｒｅ 🤏",
			"ｈｔｔｐｓ_ｇｅｔｕｇｔ_ｃｏｍ 🔥",
			"retardheadass",
			"can't hear you over these kill sounds ",
			"i'm just built different yo 🧱🧱🧱 ",
			"📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈",
			"OFF📈THE📈CHART📈",
			"KICK HIM 🦵🦵🦵",
			"THE AMOUNT THAT I CARE --> 🤏 ",
			"🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏",
			"SORRY I HURT YOUR ROBLOX EGO BUT LOOK -> 🤏 I DON'T CARE ",
			"table.find(charts, \"any other script other than nexus and bbot\") -> nil 💵💵💵",
			"LOL WHAT ARE YOU SHOOTING AT BRO ",
			"🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
			"BRO UR SHOOTING AT LIKE NOTHING LOL UR A CLOWN",
			"🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
			"ARE U USING EHUB? 🤡🤡🤡🤡🤡",
			"'EHUB IS THE BEST' 🤡 PASTED LINES OF CODE WITH UNREFERENCED AND UNINITIALIZED VARIABLES AND PEOPLE HAVE NO IDEA WHY IT'S NOT WORKING",
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
			"I am more victorious than you are🏆",
			"Due to my agility, I am better than you at basketball, and all of your favorite sports or any sport for that matter (I will probably break your ankles in basketball by pure accident) ",
			"WE THE BEST CHEATS 🔥🔥🔥🔥 ",
			"Phantom Force Hack Unlook Gun And Aimbot ",
			"banlands 🔨 🗻 down 🏚️  ⏬ STOP CRASHING BANLANDS!! 🤣",
			"antares hack client isn't real ",
			"squidhook.xyz 🦑 ",
			"squidhook > all ",
			"spongehook 🤣🤣🤣💕",
			"retardheadass ",
			"🏀🏀 did i break your ankles brother ",
			"he has access to HACK SERVER AND CHANGE WEIGHTS!!!!! STOOOOOOP 😡😒😒😡😡😡😡😡",
			"\"cmon dude don't use that\" you asked for it LOL ",
			"ima just quit mid hvh 🚶‍♀️ ",
			"BABY 👶👶👶👶🤱🤱🤱🤱🤱",
			"BOO HOO 😢😢😭😭😭 STOP CRYING D∪MBASS",
			"BOO HOO 😢😢😭😭😭 STOP CRYING ",
			"🤏",
			"🤏 <-- just to elaborate that i have no care for this situation or you at all, kid (not that you would understand anyways, you're too stupid to understand what i'm saying to begin with)",
			"y",
			"b",
			"before bbot 😭 📢				after bbot 😁😁😜					don't be like the person who doesn't have bbot",
			"							MADE YOU LOOK ",
			"							LOOK BRO LOOK LOOK AT ME ",
			"	A	",
			"			B		B		O		T	",
			"																																																																																																																								I HAVE AJAX YALL BETTER WATCH OUT OR YOU'LL DIE, WATCH WHO YOU'RE SHOOTING",
			"																																																																																																																								WATCH YOUR STEP KID",
			"BROOOO HE HAS																										GOD MODE BRO HE HAS GOD MODE 🚶‍♀️🚶‍♀️🚶‍♀️😜😂😂🤦‍♂️🤦‍♂️😭😭😭👶",
			"\"guys what hub has auto shooting\" 																										",
			"god i wish i had bbot..... 🙏🙏🥺🥺🥺													plzzzzz brooooo 🛐 GIVE IT🛐🛐",
			"buh bot 												",
			"votekick him!!!!!!! 😠 vk VK VK VK VOTEKICK HIM!!!!!!!!! 😠 😢 VOTE KICK !!!!! PRESS Y WHY DIDNT U PRESS Y LOL!!!!!! 😭 ", -- shufy made this
			"Bbot omg omggg omggg its BBot its BBOt OMGGG!!!  🙏🙏🥺🥺😌😒😡",
			"HOw do you get ACCESS to this BBOT ", -- end
			"I NEED ACCESS 🔑🔓 TO BBOT 🤖📃📃📃 👈 THIS THING CALLED BBOT SCRIPT, I NEED IT ",
			"\"this god mode guy is annoying\", Pr0blematicc says as he loses roblox hvh ",
			"you can call me crimson chin 🦹‍♂️🦹‍♂️ cause i turned your screen red 🟥🟥🟥🟥 									",
			"clipped that 🤡 ",
			"Clipped and Uploaded. 🤡",
			"nodus client slime castle crashers minecraft dupeing hack wizardhax xronize grief ... Tlcharger minecraft crack Oggi spiegheremo come creare un ip grabber!",
			"Off synonyme syls midge, smiled at mashup 2 mixed in key free download procom, ... Okay, love order and chaos online gameplayer hack amber forcen ahdistus",
			"ˢᵗᵃʸ ᵐᵃᵈ ˢᵗᵃʸ ᵇᵇᵒᵗˡᵉˢˢ $ ",
			"bbot does not relent "
		}
	}
	--local
	-- "音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
	-- "持有毁灭性的神经重景气游行脸红青铜色类别创意案",
	-- "诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
	-- "完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
	-- "庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
	local spam_words = {
		"Hack", "Unlock", "Cheat", "Roblox", "Mod Menu", "Mod", "Menu", "God Mode", "Kill All",
		"Silent", "Silent Aim", "X Ray", "Aim", "Bypass", "Glitch", "Wallhack", "ESP", "Infinite",
		"Infinite Credits", "XP", "XP Hack", "Infinite Credits", "Unlook All", "Server Backdoor",
		"Serverside", "2021", "Working", "(WORKING)", "瞄准无声目标绕过", "Gamesense", "Onetap",
		"PF Exploit", "Phantom Force", "Cracked", "TP Hack", "PF MOD MENU", "DOWNLOAD", "Paste Bin",
		"download", "Download", "Teleport", "100% legit", "100%", "pro", "Professional", "灭性的神经",
		"No Virus All Clean", "No Survey", "No Ads", "Free", "Not Paid", "Real", "REAL 2020",
		"2020", "Real 2017", "BBot", "Cracked", "BBOT CRACKED by vw", "2014", "desuhook crack",
		"Aimware", "Hacks", "Cheats", "Exploits", "(FREE)", "🕶😎", "😎", "😂", "😛", "paste bin",
		"bbot script", "hard code", "正免费下载和使", "SERVER BACKDOOR", "Secret", "SECRET", "Unleaked",
		"Not Leaked", "Method", "Minecraft Steve", "Steve", "Minecraft", "Sponge Hook", "Squid Hook", "Script",
		"Squid Hack", "Sponge Hack", "(OP)", "Verified", "All Clean", "Program", "Hook", "有毁灭",
		"desu", "hook", "vw HACK", "Anti Votekick", "Speed", "Fly", "Big Head", "Knife Hack",
		"No Clip", "Auto", "Rapid Fire", "Fire Rate Hack", "Fire Rate", "God Mode", "God",
		"Speed Fly", "Cuteware", "Nexus", "Knife Range", "Infinite XRay", "Kill All", "Sigma",
		"And", "LEAKED", "🥳🥳🥳", "RELEASE", "IP RESOLVER","Infinite Wall Bang", "Wall Bang",
		"Trickshot", "Sniper", "Wall Hack", "😍😍", "🤩", "🤑", "😱😱","Free Download EHUB",
		"Taps", "Owns", "Owns All", "Trolling", "Troll", "Grief", "Kill", "弗吉艾尺艾杰开",
		"Nate", "Alan", "JSON", "Classy", "BBOT Developers", "Logic", "And", "and", "Glitch", "Server Hack",
		"Babies", "Children", "TAP", "Meme", "MEME", "Laugh", "LOL!", "Lol!", "ROFLSAUCE", "Rofl",
		";p", ":D", "=D", "xD", "XD", "=>", "₽", "$", "8=>", "😹😹😹", "🎮🎮🎮", "🎱", "⭐", "✝",
		"Gato Hack", "Blaze Hack", "Fuego Hack", "Nat Hook", "Ransomware", "Malware",
		"SKID", "Pasted vw", "Encrypted", "Brute Force", "Cheat Code", "Hack Code", ";v",
		"No Ban", "Bot", "Editing", "Modification", "injection", "Bypass Anti Cheat", "铜色类别创意",
		"Cheat Exploit", "Hitbox Expansion", "Cheating AI", "Auto Wall Shoot", "Konami Code",
		"Debug", "Debug Menu", "🗿", "£", "¥", "₽", "₭", "€", "₿", "Meow", "MEOW", "meow", "Under Age",
		"underage", "UNDER AGE", "18-", "not finite", "Left", "Right", "Up", "Down", 
		"Left Right Up Down A B Start", "Noclip Cheat", "Bullet Check Bypass", 
		"client.char:setbasewalkspeed(999) SPEED CHEAT.", "diff = dot(bulletpos, intersection - step_pos) / dot(bulletpos, bulletpos) * dt",
		"E = MC^2", "Beyond superstring theory", "It is conceivable that the five superstring theories are approximated to a theory in higher dimensions possibly involving membranes."
	}
	
	setrawmetatable(chatspams, { -- this is the dumbest shit i've ever fucking done
	__call = function(self, type, debounce)
		if type ~= 1 then
			if type == 7 or type == 9 then
				local words = type == 7 and spam_words or customChatSpam
				local message = ""
				for i = 1, math.random(25) do
					message = message .. " " .. words[math.random(#words)]
				end
				return message
			end
			local chatspamtype = type == 8 and customChatSpam or self[type]
			local rand = math.random(1, #chatspamtype)
			if debounce then
				if self.lastchoice == rand then
					repeat
						rand = math.random(1, #chatspamtype)
					until rand ~= self.lastchoice
				end
				self.lastchoice = rand
			end
			local curchoice = chatspamtype[rand]
			return curchoice
		end
	end,
	__metatable = "neck yourself weird kid the fuck you trying to do"
	})
	
	local skelparts = {"Head", "Right Arm", "Right Leg", "Left Leg", "Left Arm"}
	
	local function MouseUnlockAndShootHook()
		if client.logic.currentgun and client.logic.currentgun.shoot then
			local shootgun = client.logic.currentgun.shoot
			if not shooties[client.logic.currentgun.shoot] then
				client.logic.currentgun.shoot = function(...)
					if menu and ragebot and menu.GetVal then
						if menu.open and not (ragebot.target and menu:GetVal("Rage", "Aimbot", "Auto Shoot")) then return end
					end
					shootgun(...)
				end
			end
			shooties[client.logic.currentgun.shoot] = true
		end
		if menu.open then
			if client.char.alive then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
			else
				INPUT_SERVICE.MouseIconEnabled = false
			end
		else
			if client.char.alive then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.LockCenter
				INPUT_SERVICE.MouseIconEnabled = false
			else
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
				INPUT_SERVICE.MouseIconEnabled = true
			end
		end
	end
	
	local invisibility = function()
		if client.invismodel then
			client.invismodel:Destroy()
			client.invismodel = nil
			return
		end
		local oldsend = client.net.send
		
		client.net.send = function(self, event, ...)
			if event == "repupdate" then return end
			oldsend(self, event, ...)
		end
		
		local char = game.Players.LocalPlayer.Character
		if not char then return end
		local getChild = char.FindFirstChild
		
		local root = getChild(char, "HumanoidRootPart")
		
		local op = root.CFrame
		root.Velocity = Vector3.new(0, 300, 0) -- this right here
		root.CFrame += CFrame.new(0, math.huge, 0)
		--yes
		wait(0.2) -- (json)had to change this to 0.2 because apparently the interval for the first wait can't be more than this wtf
		do
			local clone = root:Clone()
			client.invismodel = clone
		end
		wait(0)
		root.CFrame = op
		-- come bak
		root.Velocity = Vector3.new()
		client.net.send = oldsend
	end
	
	
	local function renderChams() -- this needs to be optimized a fucking lot i legit took this out and got 100 fps -- FUCK YOU JSON FROM MONTHS AGO YOU UDCK
		for k, Player in pairs(Players:GetPlayers()) do
			if Player == LOCAL_PLAYER then continue end -- doing this for now, i'll have to change the way the third person model will end up working
			local Body = client.replication.getbodyparts(Player)
			if Body then
				local enabled
				local col
				local vTransparency
				
				local xqz
				local ivTransparency
				
				if Player.Team ~= Players.LocalPlayer.Team then
					enabled = menu:GetVal("ESP", "Enemy ESP", "Chams")
					col = menu:GetVal("ESP", "Enemy ESP", "Chams", "color2", true)
					vTransparency = 1 - menu:GetVal("ESP", "Enemy ESP", "Chams", "color2")[4]/255
					xqz = menu:GetVal("ESP", "Enemy ESP", "Chams", "color1", true)
					ivTransparency = 1 - menu:GetVal("ESP", "Enemy ESP", "Chams", "color1")[4]/255
				else
					enabled = menu:GetVal("ESP", "Team ESP", "Chams")
					col = menu:GetVal("ESP", "Team ESP", "Chams", "color2", true)
					vTransparency = 1 - menu:GetVal("ESP", "Team ESP", "Chams", "color2")[4]/255
					xqz = menu:GetVal("ESP", "Team ESP", "Chams", "color1", true)
					ivTransparency = 1 - menu:GetVal("ESP", "Team ESP", "Chams", "color1")[4]/255
				end
				
				
				Player.Character = Body.rootpart.Parent
				for k1, Part in pairs(Player.Character:GetChildren()) do
					--debug.profilebegin("renderChams " .. Player.Name)
					if Part.ClassName ~= "Model" and Part.Name ~= "HumanoidRootPart" then
						
						local helmet = Part:FindFirstChild("HELMET")
						if helmet then
							helmet.Slot1.Transparency = enabled and 1 or 0
							helmet.Slot2.Transparency = enabled and 1 or 0
						end
						
						if not Part:FindFirstChild("c88") then
							
							for i = 0, 1 do
								
								local box
								
								if Part.Name ~= "Head" then
									box = Instance.new("BoxHandleAdornment", Part)
									box.Size = Part.Size + Vector3.new(0.1, 0.1, 0.1)
									if i == 0 then
										box.Size -= Vector3.new(0.25, 0.25, 0.25)
									end
								else
									box = Instance.new("CylinderHandleAdornment", Part)
									box.Height = Part.Size.y + 0.3
									box.Radius = Part.Size.x * 0.5 + 0.2
									if i == 0 then
										box.Height -= 0.2
										box.Radius -= 0.2
									end
									box.CFrame = CFrame.new(CACHED_VEC3, Vector3.new(0,1,0))
								end
								
								box.Name = i == 0 and "c88" or "c99"
								box.Adornee = Part
								box.ZIndex = 1
								
								box.AlwaysOnTop = i == 0 -- ternary sex
								box.Color3 = i == 0 and col or xqz
								box.Transparency = i == 0 and vTransparency or ivTransparency
								
								box.Visible = enabled
								
							end
						else
							for i = 0, 1 do
								local adorn = i == 0 and Part.c88 or Part.c99
								if menu:GetVal("ESP", "ESP Settings", "Highlight Priority") and table.find(menu.priority, Player.Name) then
									xqz = menu:GetVal("ESP", "ESP Settings", "Highlight Priority", "color", true)
									col = bColor:Mult(xqz, 0.6)
								elseif menu:GetVal("ESP", "ESP Settings", "Highlight Friends", "color") and table.find(menu.friends, Player.Name) then
									xqz = menu:GetVal("ESP", "ESP Settings", "Highlight Friends", "color", true)
									col = bColor:Mult(xqz, 0.6)
								elseif menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target") and (Player == legitbot.target or Player == ragebot.target) then
									xqz = menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target", "color", true)
									col = bColor:Mult(xqz, 0.6)
								end
								adorn.Color3 = i == 0 and col or xqz
								adorn.Visible = enabled
								adorn.Transparency = i == 0 and vTransparency or ivTransparency
							end
						end
					end
					--debug.profileend("renderChams " .. Player.Name)
				end
			end
		end
	end
	
	local send = client.net.send
	
	CreateThread(function()
		repeat wait() until menu.fading -- this is fucking bad
		while true do
			if not menu then return end
			local s = menu:GetVal("Misc", "Extra", "Chat Spam Delay")
			local tik = math.floor(tick())
			if math.floor(tick()) % s == 0 and chatspams.t ~= tik then
				chatspams.t = tik
				local cs = menu:GetVal("Misc", "Extra", "Chat Spam")
				if cs ~= 1 then
					local curchoice = chatspams(cs, true)
					curchoice = menu:GetVal("Misc", "Extra", "Chat Spam Repeat") and string.rep(curchoice, 100) or curchoice
					send(nil, "chatted", curchoice)
				end
			end
			game.RunService.RenderStepped:Wait()
		end
		return
	end)
	
	do --ANCHOR metatable hookz
		
		local mt = getrawmetatable(game)
		
		local oldNewIndex = mt.__newindex
		local oldIndex = mt.__index
		local oldNamecall = mt.__namecall
		
		setreadonly(mt, false)
		
		
		mt.__newindex = newcclosure(function(self, id, val)
			if client.char.alive then
				if menu:GetVal("Visuals", "Local Visuals", "Third Person") and keybindtoggles.thirdperson then
					if self == workspace.Camera then
						if id == "CFrame" then
							local dist = menu:GetVal("Visuals", "Local Visuals", "Third Person Distance") / 10
							local params = RaycastParams.new()
							params.FilterType = Enum.RaycastFilterType.Blacklist
							params.FilterDescendantsInstances = {Camera, workspace.Ignore, workspace.Players}
							
							local hit = workspace:Raycast(val.p, -val.LookVector * dist, params)
							if hit and not hit.Instance.CanCollide then return oldNewIndex(self, id, val * CFrame.new(0, 0, dist)) end
							local mag = hit and (hit.Position - val.p).Magnitude or nil
							
							val *= CFrame.new(0, 0, mag and mag or dist)
						end
					end
				end
				
				if menu:GetVal("Rage", "Anti Aim", "Noclip") and keybindtoggles.fakebody then -- yes this works i dont know why and im not assed to do this a different way but this is retarrded enough
					if id == "CFrame" then
						if self == client.char.rootpart then
							local offset = Vector3.new(0, client.fakeoffset, 0)
							self.Position = val.p - offset
							self.Position = val.p + offset
						end
					end
				end
			end

			return oldNewIndex(self, id, val)
		end)
		
		mt.__namecall = newcclosure(function(self, ...)
			if not checkcaller() then
				local namecallmethod = getnamecallmethod()
				local fkunate = {...}
				if self == workspace and namecallmethod == "FindPartsInRegion3" then
					if menu.spectating then
						-- sphereraycast cheat 2021	
						fkunate[2] = workspace.CurrentCamera
					end
					return oldNamecall(self, unpack(fkunate))
				end
			end
			
			return oldNamecall(self, ...)
		end)

		menu.oldmt = {
			__newindex = oldNewIndex,
			__index = oldIndex,
			__namecall = oldNamecall
		}
		
		setreadonly(mt, true)
	end
	
	do--ANCHOR camera function definitions.
		function camera:GetGun()
			for k, v in pairs(Camera:GetChildren()) do
				if v.Name ~= "Right Arm" and v.Name ~= "Left Arm" then
					return v
				end
			end
		end
		
		function camera:SetArmsVisible(flag)
			local larm, rarm = Camera:FindFirstChild("Left Arm"), Camera:FindFirstChild("Right Arm")
			assert(larm, "arms are missing")
			for k,v in next, larm:GetChildren() do
				if v:IsA("Part") then
					v.Transparency = flag and 0 or 1
				end
			end
			for k,v in next, rarm:GetChildren() do
				if v:IsA("Part") then
					v.Transparency = flag and 0 or 1
				end
			end
		end
		
		function camera:GetFOV(Part, originPart)
			originPart = originPart or workspace.Camera
			local directional = CFrame.new(originPart.CFrame.Position, Part.Position)
			local ang = Vector3.new(directional:ToOrientation()) - Vector3.new(originPart.CFrame:ToOrientation())
			return math.deg(ang.Magnitude)
		end

		function camera:GetPlayersOrganizedByFov(players)
			local result = {}
			local playerobjects = {}
			players = players or Players:GetPlayers()
			for i, player in next, players do
				
				local curbodyparts = client.replication.getbodyparts(player)
				if curbodyparts and client.hud:isplayeralive(player) then
					local fov = camera:GetFOV(curbodyparts.rootpart)
					result[i] = fov
				else
					result[i] = 999
				end
			end
			table.sort(result)
			for i, fov in next, result do
				playerobjects[fov] = players[i]
			end
			return playerobjects
		end
		
		function camera:IsVisible(Part, Parent, origin)
			
			
			origin = origin or Camera.CFrame.Position
			
			local hit, position = workspace:FindPartOnRayWithWhitelist(Ray.new(origin, Part.Position - origin), client.roundsystem.raycastwhitelist)
			
			if hit then
				if hit.CanCollide and hit.Transparency == 0 then
					return false
				else
					return self:IsVisible(Part, Parent, position + (Part.Position - origin).Unit * 0.01)
				end
			else
				return true
			end
			
			-- return (position == Part.Position or (Parent and hit and Parent:IsAncestorOf(hit)))
			
		end
		
		function camera:LookAt(pos)
			local angles = camera:GetAnglesTo(pos, true)
			local delta = client.cam.angles - angles
			client.cam.angles = angles
			client.cam.delta = delta
		end
		
		function camera:GetAngles()
			local pitch, yaw = Camera.CFrame:ToOrientation()
			return {["pitch"] = pitch, ["yaw"] = yaw, ["x"] = pitch, ["y"] = yaw}
		end
		
		function camera:GetAnglesTo(Pos, useVector)
			
			
			local pitch, yaw = CFrame.new(Camera.CFrame.Position, Pos):ToOrientation()
			if useVector then
				return Vector3.new(pitch, yaw, 0)
			else
				return {["pitch"] = pitch, ["yaw"] = yaw}
			end
			
		end
		
		function camera:GetTrajectory(pos, origin)
			
			if client.logic.currentgun and client.logic.currentgun.data then
				origin = origin or Camera.CFrame.Position
				local traj = client.trajectory(origin, GRAVITY, pos, client.logic.currentgun.data.bulletspeed)
				return traj and origin + traj or false
			end
		end
	end
	
	do--ANCHOR ragebot definitions
		ragebot.sprint = true
		ragebot.shooting = false
		do
			local function GetPartTable(ply)
				local tbl = {}
				for k, v in pairs(ply) do
					tbl[v] = true
				end
				return tbl
			end
		end
		
		local timehit = client.physics.timehit
		
		local function isdirtyfloat(f) -- if we dont use this theres a large chance the autowall will break
			local dirtyflag = true -- that being said this function is actually useful, pretty much a QNAN check or whatever
			if f == f then
				dirtyflag = true
				if f ~= (1 / 0) then
					dirtyflag = f == (-1 / 0)
				end
			end
			return dirtyflag
		end
		
		local bulletLifeTime = client.publicsettings.bulletLifeTime
		
		local function ignorecheck(p)
			if p.Name == "abcdefg" then
				return false
			end
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
		
		local dot = Vector3.new().Dot
		
		function ragebot.bulletcheck(origin, dest, velocity, acceleration, bulletspeed, whitelist) -- reversed
			local ignorelist = { workspace.Terrain--[[, workspace.Players]], workspace.Ignore, workspace.CurrentCamera }
			local bullettime = 0
			local exited = false
			local penetrated = true
			local step_pos = origin
			local s = bulletspeed
			local maxtime = timehit(step_pos, velocity, acceleration, dest)
			--local bulletintersection
			if not (not isdirtyfloat(maxtime)) or bulletLifeTime < maxtime or maxtime == 0 then
				return false
			end
			while bullettime < maxtime do
				local dt = maxtime - bullettime
				if dt > 0.03333333333333333 then
					dt = 0.03333333333333333
				end
				local bulletvelocity = dt * velocity + dt * dt / 2 * acceleration
				local enter = raycastutil.raycast(step_pos, bulletvelocity, ignorelist, ignorecheck, true)
				if enter then
					local hit = enter.Instance
					local intersection = enter.Position
					local normalized = bulletvelocity.unit
					if whitelist and whitelist[hit] then
						penetrated = true
						step_pos = intersection
						break
					end
					local exit = raycastutil.raycastSingleExit(intersection, hit.Size.magnitude * normalized, hit)
					if exit then
						local norm = exit.Normal
						local dist = dot(normalized, exit.Position - intersection)
						local diff = dot(bulletvelocity, intersection - step_pos) / dot(bulletvelocity, bulletvelocity) * dt
						step_pos = intersection + 0.01 * normalized
						velocity = velocity + diff * acceleration
						bullettime = bullettime + diff
						if not (dist < s) then
							penetrated = false
							break
						end
						s = s - dist
						table.insert(ignorelist, hit)
						exited = true
					else
						step_pos = step_pos + bulletvelocity
						velocity = velocity + dt * acceleration
						bullettime = bullettime + dt
					end
				else
					step_pos = step_pos + bulletvelocity
					velocity = velocity + dt * acceleration
					bullettime = bullettime + dt
				end
			end
			
			return penetrated, exited, step_pos
		end
		
		function ragebot:CanPenetrateFast(origin, target, penetration, whitelist)
			local d = client.trajectory(origin, GRAVITY, target.Position, client.logic.currentgun.data.bulletspeed * 25)
			local z = d.Unit * client.logic.currentgun.data.bulletspeed * 25 -- bullet speed cheat
			-- bulletcheck dumps if you fucking do origin + traj idk why you do it but i didnt do it and it fixed the dumping
			return ragebot.bulletcheck(origin, target.Position, z, GRAVITY, penetration, whitelist)
		end
		
		function ragebot:AimAtTarget(part, target, origin)
			local origin = origin or client.cam.cframe.p
			if not part then
				ragebot.silentVector = nil
				ragebot.firepos = nil
				if ragebot.shooting and menu:GetVal("Rage", "Aimbot", "Auto Shoot") then
					client.logic.currentgun:shoot(false)
				end
				ragebot.target = nil
				ragebot.shooting = false
				return
			end
			
			local target_pos = part.Position
			local dir = camera:GetTrajectory(part.Position, origin) - origin
			if not menu:GetVal("Rage", "Aimbot", "Silent Aim") then
				camera:LookAt(dir + origin)
			end
			ragebot.silentVector = dir.unit
			ragebot.target = target
			ragebot.targetpart = part
			ragebot.firepos = origin
			ragebot.shooting = true
			if menu:GetVal("Rage", "Aimbot", "Auto Shoot") then
				client.logic.currentgun:shoot(true)
			end
		end
		
		local rageHitboxSize = Vector3.new(11, 11, 11)
		
		function ragebot:GetTarget(hitboxPriority, hitscan, players)
			if keybindtoggles.freeze then
				return nil
			end
			
			ragebot.intersection = nil
			
			--debug.profilebegin("BB Ragebot GetTarget")
			--local hitscan = hitscan or {}
			local partPreference = hitboxPriority or "you know who i am? well you about to find out, your barbecue boy"
			local closest, cpart, theplayer = math.huge, nil, nil
			
			local players = players or Players:GetPlayers()
			
			local autowall = menu:GetVal("Rage", "Aimbot", "Auto Wall")
			local aw_resolve = menu:GetVal("Rage", "Hack vs. Hack", "Autowall Resolver")
			local resolvertype = menu:GetVal("Rage", "Hack vs. Hack", "Resolver Type")
			local campos = client.cam.basecframe
			local camposreal = keybindtoggles.fakebody and campos - Vector3.new(0, client.fakeoffset, 0) or campos
			local camposv3 = camposreal.p
			local firepos

			local aimbotFov = menu:GetVal("Rage", "Aimbot", "Aimbot FOV")
			
			for i, player in next, players do
				local usedhitscan = hitscan -- should probably do this a different way
				if table.find(menu.friends, player.Name) then continue end
				if player.Team ~= LOCAL_PLAYER.Team and player ~= LOCAL_PLAYER then
					local curbodyparts = client.replication.getbodyparts(player)
					if curbodyparts and client.hud:isplayeralive(player) then
						for k, bone in next, curbodyparts do
							if bone.ClassName == "Part" and usedhitscan[k] then
								local fovToBone = camera:GetFOV(bone)
								if fovToBone < aimbotFov or aimbotFov > 180 then -- Awesome
									if camera:IsVisible(bone, bone.Parent, camposv3) then
										if fovToBone < closest then
											closest = fovToBone
											cpart = bone
											theplayer = player
											firepos = camposv3
											if menu.priority[player.Name] then break end
										else
											continue
										end
									elseif autowall then
										--debug.profilebegin("BB Ragebot Penetration Check " .. player.Name)
										local directionVector = camera:GetTrajectory(bone.Position, camposv3)
										-- ragebot:CanPenetrate(LOCAL_PLAYER, player, directionVector, bone.Position, barrel, menu:GetVal("Rage", "Hack vs. Hack", "Extend Penetration"))
										-- ragebot:CanPenetrateFast(origin, target, velocity, penetration)
										if directionVector and ragebot:CanPenetrateFast(camposv3, bone, client.logic.currentgun.data.penetrationdepth) then
											cpart = bone
											theplayer = player
											firepos = camposv3
											if menu.priority[player.Name] then break end
										elseif aw_resolve then
											if resolvertype == 1 then -- cubic hitscan
												--debug.profilebegin("BB Ragebot Cubic Resolver")
												local resolvedPosition = ragebot:CubicHitscan(8, camposv3, bone)
												--debug.profileend("BB Ragebot Cubic Resolver")
												if resolvedPosition then
													ragebot.firepos = resolvedPosition
													--ragebot.intersection = intersection
													cpart = bone
													theplayer = player
													firepos = resolvedPosition
													if menu.priority[player.Name] then break end
												end
											elseif resolvertype == 2 then -- axes fast
												--debug.profilebegin("BB Ragebot Axis Shifting Resolver")
												local resolvedPosition = ragebot:HitscanOnAxes(camposreal, player, bone, 1, 8)
												--debug.profileend("BB Ragebot Axis Shifting Resolver")
												if resolvedPosition then
													ragebot.firepos = resolvedPosition
													cpart = bone
													theplayer = player
													firepos = resolvedPosition
													if menu.priority[player.Name] then break end
												end
											elseif resolvertype == 3 then -- random
												--debug.profilebegin("BB Ragebot Random Resolver")
												local resolvedPosition = ragebot:HitscanRandom(camposv3, player, bone)
												--debug.profileend("BB Ragebot Random Resolver")
												if resolvedPosition then
													ragebot.firepos = resolvedPosition
													cpart = bone
													theplayer = player
													firepos = resolvedPosition
													if menu.priority[player.Name] then break end
												end
											elseif resolvertype == 4 then -- teleport
												--debug.profilebegin("BB Ragebot Teleport Resolver")
												local up = camposreal + Vector3.new(0, 18, 0)
												local pen = ragebot:CanPenetrateFast(up, bone, client.logic.currentgun.data.penetrationdepth)
												--debug.profileend("BB Ragebot Teleport Resolver") -- fuck
												if pen then
													ragebot.firepos = up
													ragebot.needsTP = true
													cpart = bone
													theplayer = player
													firepos = up
													if menu.priority[player.Name] then break end
												else
													ragebot.needsTP = false
												end
											elseif resolvertype == 5 then -- "combined"
												-- basically combines fast axis shifting with offsetting the hitbox or just sending a raycast to the hitbox for the intersection point, really broken
												
												local extendSize = 4.5833333333333
												
												local boneX = bone.Position.X
												local boneY = bone.Position.Y
												local boneZ = bone.Position.Z
												
												local localX = camposv3.X
												local localY = camposv3.Y
												local localZ = camposv3.Z
												
												local extendX = Vector3.new(extendSize, 0, 0)
												local extendY = Vector3.new(0, extendSize, 0)
												local extendZ = Vector3.new(0, 0, extendSize)
												
												local bestDirection =
												boneY < localY and extendY or
												boneY > localY and -extendY or
												boneX < localX and extendX or
												boneX > localX and -extendX or
												boneZ < localZ and extendZ or
												boneZ > localZ and -extendZ or "wtf"
												
												local newTargetPosition = bone.Position + bestDirection
												
												--local pVelocity = camera:GetTrajectory(newTargetPosition, barrel)
												
												sphereHitbox.Position = newTargetPosition -- ho. ly. fu. cking. shit,.,m
												
												if sphereHitbox.Size ~= rageHitboxSize then
													sphereHitbox.Size = rageHitboxSize
												end
												
												--local penetrated = ragebot:CanPenetrate(LOCAL_PLAYER, player, pVelocity, newTargetPosition, barrel, false, sphereHitbox)
												local wl = {
													[sphereHitbox] = true
												}
												
												local penetrated, exited, intersectionpos = ragebot:CanPenetrateFast(camposv3, sphereHitbox, client.logic.currentgun.data.penetrationdepth, wl)
												if penetrated then
													ragebot.firepos = camposv3
													cpart = bone
													theplayer = player
													ragebot.intersection = newTargetPosition
													firepos = camposv3
													--warn("penetrated normally")
												else
													-- ragebot:HitscanOnAxes(origin, person, bodypart, max_step, step, whitelist)
													local resolvedPosition, bulletintersection = ragebot:HitscanOnAxes(camposreal, player, sphereHitbox, 1, 8, wl)
													if resolvedPosition then
														ragebot.firepos = resolvedPosition
														cpart = bone
														theplayer = player
														ragebot.intersection = newTargetPosition
														firepos = resolvedPosition
														if menu.priority[player.Name] then break end
													else
														--warn("no axes")
														-- --local _, intersection = workspace:FindPartOnRayWithWhitelist(Ray.new(args[1].firepos, (part.Position - args[1].firepos) * 3000), {sphereHitbox})
														sphereHitbox.Position = bone.Position
														
														if sphereHitbox.Size ~= rageHitboxSize then
															sphereHitbox.Size = rageHitboxSize
														end
														
														-- dick sucking god.
														local penetrated, exited, newintersection = ragebot:CanPenetrateFast(camposv3, sphereHitbox, client.logic.currentgun.data.penetrationdepth, wl)
														
														--warn(penetrated, intersectionPoint)
														
														if penetrated then
															ragebot.firepos = camposv3
															cpart = bone
															theplayer = player
															ragebot.intersection = newintersection
															firepos = camposv3
														else
															--warn("no standardized autowall hit")
														end
													end
												end
											end
										end
										--debug.profileend("BB Ragebot Penetration Check " .. player.Name)
									end
								end
							end
						end
					end
				end
			end
			--debug.profileend("BB Ragebot GetTarget")
			
			return cpart, theplayer, closest, firepos
		end
		
		function ragebot:GetKnifeTargets()
			
			local results = {}
			
			for i, ply in ipairs(Players:GetPlayers()) do
				if table.find(menu.friends, ply.Name) then continue end
				
				if ply.Team ~= LOCAL_PLAYER.Team and client.hud:isplayeralive(ply) then
					local parts = client.replication.getbodyparts(ply)
					if not parts then continue end
					
					local target_pos = parts.rootpart.Position
					local target_direction = target_pos - client.cam.cframe.p
					local target_dist = (target_pos - client.cam.cframe.p).Magnitude
					local ignore = {LOCAL_PLAYER, Camera, workspace.Ignore, workspace.Players}
					
					local part1, ray_pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(client.cam.cframe.p, target_direction), ignore)
					local part2, ray_pos = workspace:FindPartOnRayWithIgnoreList(Ray.new(client.cam.cframe.p - Vector3.new(0,2,0), target_direction), ignore)
					
					local ray_distance = (target_pos - ray_pos).Magnitude
					
					table.insert(results, {player = ply, part = parts.head, tppos = ray_pos, direction = target_direction, dist = target_dist, insight = ray_distance < 15 and part1 == part2})
				end
				
			end
			
			return results
			
		end
		
		function ragebot:KnifeBotMain()
			if keybindtoggles.crash then return end
			if not client.char.alive then return end
			if not LOCAL_PLAYER.Character or not LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart") then return end
			
			if menu:GetVal("Rage", "Extra", "Knife Bot") and IsKeybindDown("Rage", "Extra", "Knife Bot", true) then
				local knifetype = menu:GetVal("Rage", "Extra", "Knife Bot Type")
				if knifetype == 2 then
					ragebot:KnifeAura()
				elseif knifetype == 3 then
					ragebot:FlightAura()
				end
			end
		end
		
		function ragebot:FlightAura()
			local targets = ragebot:GetKnifeTargets()
			
			for i, target in pairs(targets) do
				if not target.insight then continue end
				LOCAL_PLAYER.Character.HumanoidRootPart.Anchored = false
				LOCAL_PLAYER.Character.HumanoidRootPart.Velocity = target.direction.Unit * 130
				
				return ragebot:KnifeAura(targets)
			end
		end
		
		
		function ragebot:KnifeAura(t)
			
			local targets = t or ragebot:GetKnifeTargets()
			for i, target in ipairs(targets) do
				if target.player then
					ragebot:KnifeTarget(target)
				end
			end
			
		end
		
		function ragebot:KnifeTarget(target, stab)
			local cfc = client.cam.cframe
			--send(client.net, "repupdate", cfc.p, client.cam.angles) -- Makes knife aura work with anti nade tp
			if stab then send(client.net, "stab") end
			local newhit = nil
			newhit = {Name = target.part.Name, Position = Vector3.new(math.random(-2^12, 2^12))} -- fuckin hack
			send(client.net, "knifehit", target.player, tick(), newhit or target.part)
		end
		
		
		function ragebot:GetCubicMultipoints(origin, extent)
			assert(extent % 2 == 0, "extent value must be even")
			local start = origin or client.cam.basecframe.p
			local max_step = extent or 8
			
			start -= Vector3.new(max_step, -max_step, max_step) / 2
			
			local pos = start
			local half = max_step / 2
			
			local points = {corner = table.create(8), inside = table.create(19)}
			
			for x = 0, max_step do
				for y = 0, -max_step, -1 do
					for z = 0, max_step do
						local isPositionCorner = x % max_step == 0 and y % max_step == 0 and z % max_step == 0
						local isPositionInside = x % half == 0 and y % half == 0 and z % half == 0
						if isPositionCorner then
							pos = start + Vector3.new(x, y, z)
							
							table.insert(points.corner, 1, pos)
						elseif isPositionInside then
							pos = start + Vector3.new(x, y, z)
							
							table.insert(points.inside, 1, pos)
						end
					end
				end
			end
			
			return points
		end
		
		function ragebot:CubicHitscan(studs, origin, selectedpart) -- Scans in a cubic square area of size (studs) and resolves a position to hit target at
			assert(studs, "what are you trying to do young man, this is illegal.  you do know that you have to provide us with shit to use to calculate this, you do realize this right?") -- end
			assert(origin, "just like before, we need information to even apply this to our things we made to provide you with ease of p100 hits 🤡")
			assert(selectedpart, "what are you attempting to do what the fuck are you dumb?? you are just testing my patience") -- end
			
			local dapointz = ragebot:GetCubicMultipoints(origin, studs or 18*2)
			
			local pos
			-- ragebot:CanPenetrateFast(origin, target, velocity, penetration)
			for i, point in pairs(dapointz.corner) do
				local penetrated = ragebot:CanPenetrateFast(point, selectedpart, client.logic.currentgun.data.penetrationdepth)
				
				if penetrated then
					pos = point
					return
				end
			end
			
			if pos then
				return pos
			end
			
			for i, point in pairs(dapointz.inside) do
				local penetrated = ragebot:CanPenetrateFast(point, selectedpart, client.logic.currentgun.data.penetrationdepth)
				
				if penetrated then
					pos = point
					return
				end
			end
			
			if pos then
				return pos
			end
			
			return nil
		end
		
		local hitpoints = {}
		function ragebot:HitscanRandom(origin, bodypart)
			local offset
			if #hitpoints < 50 or math.random() < 0.2 then
				offset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5).Unit * 8
			else
				offset = hitpoints[math.random(#points)]
			end
			local position = origin + offset
			if ragebot:CanPenetrateRaycast(position, bodypart.Position, client.logic.currentgun.data.penetrationdepth) then
				table.insert(hitpoints, offset)
				return position
			end
		end
		
		function ragebot:HitscanOnAxes(origin, person, bodypart, max_step, step, whitelist)
			assert(bodypart, "hello")
			
			local dest = typeof(bodypart) ~= "Vector3" and bodypart.Position or bodypart -- fuck
			
			assert(person, "something went wrong in your nasa rocket launch")
			assert(typeof(origin) == "CFrame", "what are you trying to do young man") -- end
			local position = origin
			-- ragebot:CanPenetrateRaycast(barrel, bone.Position, client.logic.currentgun.data.penetrationdepth, true, sphereHitbox)
			for i = 1, max_step do
				position = position * CFrame.new(0, step, 0)
				local pen, exited, bulletintersection = ragebot:CanPenetrateFast(position.p, bodypart, client.logic.currentgun.data.penetrationdepth, whitelist)
				if pen then
					return position.p, bulletintersection
				end
			end
			
			position = origin
			
			for i = 1, max_step do
				position = position * CFrame.new(0, -step, 0)
				local pen, exited, bulletintersection = ragebot:CanPenetrateFast(position.p, bodypart, client.logic.currentgun.data.penetrationdepth, whitelist)
				if pen then
					return position.p, bulletintersection
				end
			end
			
			position = origin
			
			for i = 1, max_step do
				position = position * CFrame.new(0, 0, step)
				local pen, exited, bulletintersection = ragebot:CanPenetrateFast(position.p, bodypart, client.logic.currentgun.data.penetrationdepth, whitelist)
				if pen then
					return position.p, bulletintersection
				end
			end
			
			position = origin
			
			for i = 1, max_step do
				position = position * CFrame.new(0, 0, -step)
				local pen, exited, bulletintersection = ragebot:CanPenetrateFast(position.p, bodypart, client.logic.currentgun.data.penetrationdepth, whitelist)
				if pen then
					return position.p, bulletintersection
				end
			end
			
			position = origin
			
			for i = 1, max_step do
				position = position * CFrame.new(step, 0, 0)
				local pen, exited, bulletintersection = ragebot:CanPenetrateFast(position.p, bodypart, client.logic.currentgun.data.penetrationdepth, whitelist)
				if pen then
					return position.p, bulletintersection
				end
			end
			
			position = origin
			
			for i = 1, max_step do
				position = position * CFrame.new(-step, 0, 0)
				local pen, exited, bulletintersection = ragebot:CanPenetrateFast(position.p, bodypart, client.logic.currentgun.data.penetrationdepth, whitelist)
				if pen then
					return position.p, bulletintersection
				end
			end
			
			return nil
		end
		
		local fakelagpos, fakelagtime
		function ragebot:MainLoop() -- lfg
			ragebot.silentVector = nil
			local hitscanpreference = misc:GetParts(menu:GetVal("Rage", "Aimbot", "Hitscan Points"))
			local prioritizedpart = menu:GetVal("Rage", "Aimbot", "Hitscan Priority")
			
			ragebot:Stance()
			if menu:GetVal("Rage", "Extra", "Fake Lag") and not menu:GetVal("Rage", "Extra", "Manual Choke") then
				if (not fakelagpos or not fakelagtime) or ((client.cam.cframe.p - fakelagpos).Magnitude > menu:GetVal("Rage", "Extra", "Fake Lag Distance") or tick() - fakelagtime > 1) or not client.char.alive then
					fakelagtime = tick()
					fakelagpos = client.cam.cframe.p
					NETWORK:SetOutgoingKBPSLimit(0)
					if client.char.alive then
						--CreateNotification("Choking")
					end
				else
					NETWORK:SetOutgoingKBPSLimit(menu:GetVal("Rage", "Extra", "Fake Lag Amount"))
				end
			end
			
			if client.char.alive then
				if menu:GetVal("Misc", "Movement", "Circle Strafe") and IsKeybindDown("Misc", "Movement", "Circle Strafe") then
					local speedcheatspeed = menu:GetVal("Misc", "Movement", "Speed Factor")
					local rootpart = client.char.rootpart
					rootpart.Velocity = Vector3.new(math.sin(tick() * speedcheatspeed / 10) * speedcheatspeed, rootpart.Velocity.Y, math.cos(tick() * speedcheatspeed / 10) * speedcheatspeed)
				end
			end
			
			if client.char.alive and menu:GetVal("Rage", "Aimbot", "Enabled") then
				if client.logic.currentgun and client.logic.currentgun.type ~= "KNIFE" then -- client.loogic.poop.falsified_directional_componenet = Vector8.new(math.huge) [don't fuck with us]
					
					local playerlist = Players:GetPlayers()
					
					if not client then return end
					local priority_list = {}
					for k, PlayerName in pairs(menu.priority) do
						if Players:FindFirstChild(PlayerName) then
							table.insert(priority_list, game.Players[PlayerName])
						end
					end
					local targetPart, targetPlayer, fov, firepos = ragebot:GetTarget(prioritizedpart, hitscanpreference, priority_list)
					if not targetPart and not menu:GetVal("Rage", "Aimbot", "Target Only Priority Players") then
						targetPart, targetPlayer, fov, firepos = ragebot:GetTarget(prioritizedpart, hitscanpreference, playerlist)
					end
					ragebot:AimAtTarget(targetPart, targetPlayer, firepos)
				else
					self.target = nil
				end
			end
		end
		
		ragebot.stance = 'prone'
		ragebot.sprint = false
		ragebot.stancetick = tick()
		function ragebot:Stance()
			if LOCAL_PLAYER.Character and LOCAL_PLAYER.Character:FindFirstChild("Humanoid") then
				if menu:GetVal("Rage", "Anti Aim", "Hide in Floor") and menu:GetVal("Rage", "Anti Aim", "Enabled") and not LOCAL_PLAYER.Character.Humanoid.Jump then
					LOCAL_PLAYER.Character.Humanoid.HipHeight = -1.9
				else
					LOCAL_PLAYER.Character.Humanoid.HipHeight = 0
				end
			end
			if menu:GetVal("Rage", "Anti Aim", "Enabled") then
				if (tick() - ragebot.stancetick) >= 0.5 then
					ragebot.stancetick = tick()
					local stanceId = menu:GetVal("Rage", "Anti Aim", "Force Stance")
					if stanceId ~= 1 then
						newStance = --ternary sex
						stanceId == 2 and "stand"
						or stanceId == 3 and "crouch"
						or stanceId == 4 and "prone"
						ragebot.stance = newStance
						send(client.net, "stance", newStance)
					end
					if menu:GetVal("Rage", "Anti Aim", "Lower Arms") then
						ragebot.sprint = true
						send(nil, "sprint", true)
					end
					if menu:GetVal("Rage", "Anti Aim", "Tilt Neck") then
						ragebot.tilt = true
						send(nil, "aim", true)
					end
				end
			end
		end
	end
	
	local _3pweps = {}
	
	do
		local VirtualUser = game:GetService("VirtualUser")
		menu.connections.local_player_id_connect = LOCAL_PLAYER.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		
		local oldmag = client.cam.setmagnification
		local oldmenufov = client.cam.changemenufov
		client.cam.changemenufov = function(...)
			if menu.open then return end
			oldmenufov(...)
		end
		
		local shake = client.cam.shake
		client.cam.shake = function(self, magnitude)
			if menu:GetVal("Visuals", "Camera Visuals", "Reduce Camera Recoil") then
				local scale = 1 - menu:GetVal("Visuals", "Camera Visuals", "Camera Recoil Reduction") * 0.01
				magnitude *= scale
			end
			return shake(client.cam, magnitude)
		end
		
		local suppress = client.cam.suppress
		client.cam.suppress = function(...)
			if menu:GetVal("Visuals", "Camera Visuals", "No Visual Suppression") then return end
			return suppress(...)
		end
		
		-- client event hooks! for grenade paths... and other shit (idk where to put this)
		local clienteventfuncs = getupvalue(client.call, 1)
		
		local function create_outlined_square(pos, destroydelay, colordata)
			local newpart = Instance.new("Part", workspace)
			newpart.CanCollide = false
			newpart.Anchored = true
			newpart.Size = Vector3.new(0.35, 0.35, 0.35)
			newpart.Position = pos
			newpart.Material = Enum.Material.Neon
			newpart.Transparency = 0.85
			
			local colors = colordata or {Color3.fromRGB(255, 255, 255), Color3.fromRGB(239, 62, 62)}
			
			for i = 1, 2 do
				local box = Instance.new("BoxHandleAdornment", newpart)
				box.AlwaysOnTop = true
				box.Adornee = box.Parent
				box.ZIndex = i == 1 and 5 or 1
				box.Color3 = i == 1 and colors[1] or colors[2]
				box.Size = i == 1 and newpart.Size / 1.3 or newpart.Size * 1.3
				box.Transparency = i == 1 and 0 or 0.3
			end
			
			debris:AddItem(newpart, destroydelay)
		end
		
		local function create_line(origin_att, ending_att, destroydelay) -- pasting this from the misc create beam but oh well im a faggot so yeah :troll:
			local beam = Instance.new("Beam")
			beam.LightEmission = 1
			beam.LightInfluence = 1
			beam.Enabled = true
			beam.Color = ColorSequence.new(menu:GetVal("ESP", "Dropped ESP", "Grenade ESP", "color2", true))
			beam.Attachment0 = origin_att
			beam.Attachment1 = ending_att
			beam.Width0 = 0.2
			beam.Width1 = 0.2
			
			beam.Parent = workspace
			
			debris:AddItem(beam, destroydelay)
			debris:AddItem(origin_att, destroydelay)
			debris:AddItem(ending_att, destroydelay)
		end
		
		for hash, func in next, clienteventfuncs do
			local curconstants = getconstants(func)
			local found = table.find(curconstants, "Frag")
			local found1 = table.find(curconstants, "removecharacterhash")
			local found2 = getinfo(func).name == "swapgun"
			local found3 = table.find(curconstants, "updatecharacter")
			local found4 = getinfo(func).name == "swapknife"
			local found5 = table.find(curconstants, "Votekick ")
			local found6 = table.find(curconstants, " studs")
			local found7 = table.find(curconstants, "setstance")
			local found8 = table.find(curconstants, "setfixedcam")
			local found9 = table.find(curconstants, "kickweapon")
			local found10 = table.find(curconstants, "equip")
			local found11 = table.find(curconstants, "equipknife")
			local found12 = table.find(curconstants, "setlookangles")
			local found13 = table.find(curconstants, "Msg")
			local found14 = table.find(curconstants, "[Console]: ")
			if found then
				clienteventfuncs[hash] = function(thrower, gtype, gdata, displaytrail)
					if gdata.blowuptime > 0 and thrower.team ~= LOCAL_PLAYER.Team or thrower == LOCAL_PLAYER then
						local lastrealpos
						
						local frames = gdata.frames
						local blowup, st = gdata.blowuptime, gdata.time
						local inc = 0.016666666666666666
						
						local curtick = tick()
						local dst = st - curtick
						local realtime = curtick + dst * (st + blowup - curtick) / (blowup + dst)
						local err = realtime - curtick
						
						local j = 1
						
						for dt = 0, blowup / inc do
							local t = inc * dt
							
							do
								local realtime = tick() + t
								local time = realtime + dst * (st + blowup - realtime) / (blowup + dst)
								
								local rtnext = tick() + (inc * (dt + 1))
								local next_time = rtnext + dst * (st + blowup - rtnext) / (blowup + dst)
								
								local frame = frames[j]
								local nextframe = j + 1 <= #frames and frames[j + 1] or nil
								
								if nextframe and time > st + nextframe.t0 then
									j += 1
									frame = nextframe
								end
								
								local t = time - (st + frame.t0)
								local next_t = next_time - (st + frame.t0)
								
								local pos = frame.p0 + t * frame.v0 + t * t / 2 * frame.a + frame.offset
								local nextpos = frame.p0 + next_t * frame.v0 + next_t * next_t / 2 * frame.a + frame.offset
								--local rot = client.cframe.fromaxisangle(t * frame.rotv) * frame.rot0
								lastrealpos = pos
								
								if menu:GetVal("ESP", "Dropped ESP", "Grenade ESP") then
									local c1 = menu:GetVal("ESP", "Dropped ESP", "Grenade ESP", "color1", true)
									local c2 = menu:GetVal("ESP", "Dropped ESP", "Grenade ESP", "color2", true)
									local colorz = {c1, c2}
									if nextpos then
										--local mag = (nextpos - pos).magnitude
										-- magnitude stuff wont work because the line will just end for no reason
										create_outlined_square(pos, blowup, colorz)
										local a1 = Instance.new("Attachment", workspace.Terrain)
										a1.Position = pos
										local a2 = Instance.new("Attachment", workspace.Terrain)
										a2.Position = nextpos
										
										create_line(a1, a2, blowup, colorz)
									else
										create_outlined_square(pos, blowup, colorz)
									end
								end
							end
						end
						
						if menu:GetVal("ESP", "Dropped ESP", "Nade Warning") then
							local btick = curtick + (math.abs((curtick + gdata.blowuptime) - curtick) - math.abs(err))
							if curtick < btick then
								table.insert(menu.activenades, {
									thrower = thrower.Name,
									blowupat = lastrealpos,
									blowuptick = btick, -- might need to be tested more
									start = curtick
								})
							end
						end
					end
					return func(thrower, gtype, gdata, displaytrail)
				end
			end
			if found1 then
				clienteventfuncs[hash] = function(charhash, bodyparts)
					local modparts = bodyparts
					for k,v in next, modparts:GetChildren() do
						if not v:IsA("Model") and not v:IsA("Humanoid") then
							v.Size = bodysize[v.Name] -- reset the ragdolls to their defaulted size defined at bodysize, in case of hitbox expansion
						end
					end
					return func(charhash, modparts)
				end
			end
			if found3 then
				clienteventfuncs[hash] = function(player, parts)
					if player.Team ~= LOCAL_PLAYER.Team then
						for k,v in next, parts do
							if v:IsA("Part") then
								local formattedval = (menu:GetVal("Legit", "Aim Assist", "Enlarge Enemy Hitboxes") / 95) + 1
								v.Size *= v.Name == "Head" and Vector3.new(formattedval, v.Size.y * (1 + formattedval / 100), formattedval) or formattedval -- hitbox expander
							end
						end
					end
					return func(player, parts)
				end
			end
			if found5 then
				clienteventfuncs[hash] = function(name, countdown, endtick, reqs)
					func(name, countdown, endtick, reqs)
					local allowautovote = menu:GetVal("Misc", "Extra", "Auto Vote")
					local friends = menu:GetVal("Misc", "Extra", "Vote Friends")
					local priority = menu:GetVal("Misc", "Extra", "Vote Priority")
					local default = menu:GetVal("Misc", "Extra", "Default Vote")
					if allowautovote then
						if name == LOCAL_PLAYER.Name then
							client.hud:vote("no")
						else
							if table.find(menu.friends, name) and friends ~= 1 then
								local choice = friends == 2 and "yes" or "no"
								client.hud:vote(choice)
							end
							if table.find(menu.priority, name) and priority ~= 1 then
								local choice = priority == 2 and "yes" or "no"
								client.hud:vote(choice)
							end
							if default ~= 1 then
								local choice = default == 2 and "yes" or "no"
								client.hud:vote(choice)
							end
						end
					end
				end
			end
			if found6 then
				clienteventfuncs[hash] = function(killer, victim, dist, weapon, head)
					if killer == LOCAL_PLAYER and victim ~= LOCAL_PLAYER then
						if menu:GetVal("Misc", "Extra", "Kill Sound") then
							client.sound.PlaySoundId("rbxassetid://6229978482", 5.0, 1.0, workspace, nil, 0, 0.03)
						end
					end
					
					if victim ~= LOCAL_PLAYER then
						if not repupdates[victim] then
							printconsole("Unable to find position data for " .. victim.Name)
						end
						repupdates[victim] = {}
					end
					
					return func(killer, victim, dist, weapon, head)
				end
			end
			if found7 then
				clienteventfuncs[hash] = function(player, newstance)
					local ting = menu:GetVal("Rage", "Hack vs. Hack", "Force Player Stances")
					local choice = menu:GetVal("Rage", "Hack vs. Hack", "Stance Choice")
					choice = choice == 1 and "stand" or choice == 2 and "crouch" or "prone"
					local chosenstance = ting and choice or newstance
					return func(player, chosenstance)
				end
			end
			if found8 then
				clienteventfuncs[hash] = function(...)
					local args = {...}
					
					if menu:GetVal("Misc", "Extra", "Auto Martyrdom") then
						local fragargs = {
							"FRAG",
							{
								frames = {
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0,
										offset = Vector3.new(0/0, 0/0, 0/0),
										rot0 = CFrame.new(),
										a = Vector3.new(0, -80, 0),
										p0 = client.lastrepupdate or client.char.head.Position,
										rotv = Vector3.new()
									}
								},
								time = tick(),
								curi = 1,
								blowuptime = 0.2
							}
						}
						
						if menu:GetVal("Misc", "Exploits", "Grenade Teleport") and args[1] ~= LOCAL_PLAYER then
							fragargs.blowuptime = 1
							
							local killerbodyparts = client.replication.getbodyparts(args[1])
							
							if not killerbodyparts then
								return func(...)
							end
							
							fragargs[2].frames[1].a = Vector3.new(0/0)
							fragargs[2].frames[2] = {
								v0 = Vector3.new(0/0, 0/0, 0/0),
								glassbreaks = {},
								t0 = 0/0,
								offset = Vector3.new(0/0, 0/0, 0/0),
								rot0 = CFrame.new(0/0, 0/0, 0/0),
								a = Vector3.new(0/0),
								p0 = Vector3.new(0/0),
								rotv = Vector3.new()
							}
							fragargs[2].frames[3] = {
								v0 = Vector3.new(),
								glassbreaks = {},
								t0 = 0,
								offset = Vector3.new(),
								rot0 = CFrame.new(),
								a = Vector3.new(),
								p0 = killerbodyparts.rootpart.Position + Vector3.new(0, 2, 0),
								rotv = Vector3.new()
							}
						end
						CreateThread(function()
							local bp = client.replication.getbodyparts(args[1])
							for i = 1, menu:GetVal("Misc", "Exploits", "Grenade Teleport") and 3 or 1 do
								send(nil, "newgrenade", unpack(fragargs))
								if not bp.rootpart then break end
								fragargs[2].frames[2].p0 += bp.rootpart.Velocity * 0.5
							end
						end)
					end
					
					return func(...)
				end
			end
			if found9 then
				clienteventfuncs[hash] = function(bulletdata)
					local vec = Vector3.new()
					for k, bullet in next, bulletdata.bullets do
						if typeof(bullet) ~= "Vector3" then
							bulletdata.bullets[k][1] = vec
						end
					end
					
					if typeof(bulletdata.firepos) ~= "Vector3" then
						bulletdata.firepos = vec
					end
					
					return func(bulletdata)
				end
			end
			if found10 then
				clienteventfuncs[hash] = function(player, weapon, camodata, attachments)
					_3pweps[player] = weapon
					return func(player, weapon, camodata, attachments)
				end
			end
			if found11 then
				clienteventfuncs[hash] = function(player, weapon, camodata)
					_3pweps[player] = weapon
					return func(player, weapon, camodata)
				end
			end
			if found12 then
				clienteventfuncs[hash] = function(player, newangles)
					local bodyparts = client.replication.getbodyparts(player)
					if bodyparts then
						if not repupdates[player] then
							repupdates[player] = {}
						end
						local data = repupdates[player]
						local pos = bodyparts.rootpart.Position
						table.insert(data, 1, {
							["position"] = pos,
							["tick"] = tick()
						})
						table.remove(data, 19)
					end
					
					if newangles.Magnitude >= 2 ^ 10 then
						return
					end
					
					return func(player, newangles)
				end
			end
			if found13 then
				clienteventfuncs[hash] = function(chatter, text, tag, tagcolor, teamchat, chattername)
					if table.find(menu.annoylist, chatter.Name) and not text:find("gay") then -- lel
						send(nil, "chatted", text)
					end
					return func(chatter, text, tag, tagcolor, teamchat, chattername)
				end
				if found2 then
					clienteventfuncs[hash] = function(gun, mag, spare, attachdata, camodata, gunn, ggequip)
						func(gun, mag, spare, attachdata, camodata, gunn, ggequip)
						if client.fakecharacter then
							client.fakeupdater.equip(require(game:service("ReplicatedStorage").GunModules[gun]), game:service("ReplicatedStorage").ExternalModels[gun]:Clone())
						end
					end
				end
			end
			if found14 then
				client.console = func
				local console_upvs = getupvalues(func)
				client.bbconsole = function(txt, name)
					name = name or "bitchbot"
					local misc = game.ReplicatedStorage.Misc
					local chatgui = console_upvs[4].Parent
					
					local msg = console_upvs[2]
					local message = msg:Clone()
					local tag = message.Tag
					local offset = 5
					
					message.Parent = chatgui.GlobalChat
					message.Text = "[" .. name .. "]: "
					message.Msg.Text = txt
					message.Msg.Position = UDim2.new(0, message.TextBounds.x, 0, 0)
					message.Visible = true
					message.Msg.Visible = true
					
					CreateThread(function()
						while message.Parent == chatgui.GlobalChat do
							message.TextColor3 = RGB(unpack(menu.mc))
							game.RunService.RenderStepped:Wait()
						end
					end)
				end
			end
		end
	end
	
	do
		local tween = game:service("TweenService")
		
		client.closecast = require(game.ReplicatedFirst.SharedModules.Utilities.Geometry.CloseCast)
		local partnames = { "head", "torso", "lleg", "rleg", "larm", "rarm" }
		local partexpansionarray = { 0.75, 1.5, 1.5, 1.5, 1.5, 1.5 }

		local nv = Vector3.new()
		local dot = nv.Dot

		local bodyarrayinfo = getupvalue(client.replication.thickcastplayers, 8)
		local chartable = getupvalue(client.replication.getallparts, 1)
		client.chartable = chartable

		function client.thickcastplayers(origin, direction) -- i might attempt to use this on bulletcheck later
			local castresults = nil
			for player, bodyparts in next, chartable do
				local delta = bodyparts.torso.Position - origin
				local directiondot = dot(direction, direction)
				local diff = dot(direction, delta)
				if diff > 0 and diff < directiondot and directiondot * dot(delta, delta) - diff * diff < directiondot * 6 * 6 then
					for i = 1, #partnames do
						local maxdist = 0.0425 -- regular on pc with controller is just this
						--[[if lol then
							if i == 1 then
								maxexpansion = lol / 2
							else
								maxexpansion = lol
							end
						elseif partexpansionarray then
							maxexpansion = partexpansionarray[i]
						end]]
						maxdist = partexpansionarray[i]
						local curbodypart = bodyparts[partnames[i]]
						local pos, what, hitpos, dist = closecast.closeCastPart(curbodypart, origin, direction)
						if pos and dist < maxdist then
							if not castresults then
								castresults = {}
							end
							castresults[#castresults + 1] = { bodyarrayinfo[curbodypart], curbodypart, hitpos, (what - hitpos).unit, what, dist }
							break
						end
					end
				end
			end
			return castresults
		end

		function misc:CreateBeam(origin_att, ending_att)
			local beam = Instance.new("Beam")
			beam.Texture = "http://www.roblox.com/asset/?id=446111271"
			beam.TextureMode = Enum.TextureMode.Wrap
			beam.TextureSpeed = 8
			beam.LightEmission = 1
			beam.LightInfluence = 1
			beam.TextureLength = 12
			beam.FaceCamera = true
			beam.Enabled = true
			beam.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1)
			}
			beam.Color = ColorSequence.new(menu:GetVal("Visuals", "Misc Visuals", "Bullet Tracers", "color", true), Color3.new(0, 0, 0))
			beam.Attachment0 = origin_att
			beam.Attachment1 = ending_att
			debris:AddItem(beam, 3)
			debris:AddItem(origin_att, 3)
			debris:AddItem(ending_att, 3)
			
			local speedtween = TweenInfo.new(3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
			tween:Create(beam, speedtween, {TextureSpeed = 0}):Play()
			
			beam.Parent = workspace
			return beam
		end
		
		local setsway = client.cam.setswayspeed
		client.cam.setswayspeed = function(self,v)
			setsway(self, menu:GetVal("Visuals", "Camera Visuals", "No Scope Sway") and 0 or v)
		end
		
		function misc:GetParts(parts)
			parts["Head"] =      parts[1]
			parts["Torso"] =     parts[2]
			parts["Right Arm"] = parts[3]
			parts["Left Arm"] =  parts[3]
			parts["Right Leg"] = parts[4]
			parts["Left Leg"] =  parts[4]
			parts["rleg"] =      parts[4]
			parts["lleg"] =      parts[4]
			parts["rarm"] =      parts[3]
			parts["larm"] =      parts[3]
			parts["head"] =      parts[1]
			parts["torso"] =     parts[2]
			return parts
		end
		local rootpart
		local humanoid
		
		function misc:SpotPlayers()
			if not menu:GetVal("Misc", "Extra", "Auto Spot") then return end
			local players = {}
			for k, player in pairs(game.Players:GetPlayers()) do
				if player == game.Players.LocalPlayer then continue end
				table.insert(players, player)
			end
			return send("spotplayers", players)
		end
		
		function misc:ApplyGunMods()
			
			local mods_enabled = menu:GetVal("Misc", "Weapon Modifications", "Enabled")
			local firerate_scale = menu:GetVal("Misc", "Weapon Modifications", "Fire Rate Scale") / 100
			local recoil_scale = menu:GetVal("Misc", "Weapon Modifications", "Recoil Scale") / 100
			local empty_animations = menu:GetVal("Misc", "Weapon Modifications", "Remove Animations")
			local instant_equip = menu:GetVal("Misc", "Weapon Modifications", "Instant Equip")
			local fully_auto = menu:GetVal("Misc", "Weapon Modifications", "Fully Automatic")
			
			for i, gun_module in pairs(CUR_GUNS:GetChildren()) do
				local gun = require(gun_module)
				local old_gun = require(OLD_GUNS[gun_module.Name])
				for k, v in pairs(old_gun) do
					gun[k] = v
				end
				
				if mods_enabled then
					do --firerate
						if gun.variablefirerate then
							for k, v in pairs(gun.firerate) do
								v *= firerate_scale
							end
						elseif gun.firerate then
							gun.firerate *= firerate_scale
						end
					end
					if fully_auto and gun.firemodes then
						gun.firemodes = {true, 3, 1}
					end
					if gun.camkickmin then	--recoil
						gun.camkickmin *= recoil_scale
						gun.camkickmax *= recoil_scale
						gun.aimcamkickmin *= recoil_scale
						gun.aimcamkickmax *= recoil_scale
						gun.aimtranskickmin *= recoil_scale
						gun.aimtranskickmax *= recoil_scale
						gun.transkickmin *= recoil_scale
						gun.transkickmax *= recoil_scale
						gun.rotkickmin *= recoil_scale
						gun.rotkickmax *= recoil_scale
						gun.aimrotkickmin *= recoil_scale
						gun.aimrotkickmax *= recoil_scale
						gun.hipfirespreadrecover *= recoil_scale
						gun.hipfirespread *= recoil_scale
						gun.hipfirestability *= recoil_scale
					end
					if instant_equip then
						gun.equipspeed = 99999
					end
					if empty_animations then
						client.animation.player = animhook
					else
						client.animation.player = client.animation.oldplayer
					end
				end
			end
		end
		do 
			local spring = require(game.ReplicatedFirst.SharedModules.Utilities.Math.spring)
			local old_index = spring.__index
			local swingspring = debug.getupvalue(client.char.step, 21)
			local sprintspring = debug.getupvalue(client.char.setsprint, 10)
			local zoommodspring = debug.getupvalue(client.char.step, 1) -- sex.
			client.zoommodspring = zoommodspring -- fuck
			
			client.springindex = old_index
			
			spring.__index = newcclosure(function(t, k)
				local result = old_index(t, k)
				if t == swingspring then
					if k == "v" and menu:GetVal("Misc", "Weapon Modifications", "Run and Gun") then
						return Vector3.new()
					end
				end
				if t == sprintspring then
					if k == "p" and menu:GetVal("Misc", "Weapon Modifications", "Run and Gun") then
						return 0
					end
				end
				
				if t == zoommodspring then
					if k == "p" and menu:GetVal("Visuals", "Camera Visuals", "Disable ADS FOV") then 
						return 0
					end
				end
				if t == client.char.slidespring then
					if k == "p" and menu:GetVal("Visuals", "Camera Visuals", "Show Sliding") then 
						return 0
					end
				end
				return result
			end)
		end
		menu.connections.button_pressed_pf = ButtonPressed.Event:Connect(function(tab, gb, name)
			if name == "Crash Server" then
				while wait() do
					for i = 1, 50 do
						local tid = 846964998 ^ math.random(-100, 100)
						
						client.net:send("changecamo", "Recon", "Secondary", "GLOCK 17", "Slot1", {
							BrickProperties = {
								Color = {
									r = math.random(0, 255),
									g = math.random(0, 255),
									b = math.random(0, 255),
								},
								BrickColor = "Black",
								Reflectance = math.random(0, 100),
							},
							TextureProperties = {
								Color = {
									r = math.random(0, 255),
									g = math.random(0, 255),
									b = math.random(0, 255),
								},
								OffsetStudsU = math.random(0, 4),
								OffsetStudsV = math.random(0, 4),
								StudsPerTileU = math.random(0, 4),
								StudsPerTileV = math.random(0, 4),
								TextureId = tid
							},
							Name = "",
							TextureId = tid
						})
					end
				end
			end
			if name == "Votekick" then
				local rank = client.rankcalculator(client.dirtyplayerdata.stats.experience)
				if not selectedPlayer then return end
				
				if rank >= 25 then
					client.net:send("modcmd", string.format("/votekick:%s", selectedPlayer.Name))
				else
					CreateNotification(string.format("Your account must be rank 25 or above to votekick! (Rank %d)", rank))
				end
			elseif name == "Spectate" then
				if menu.spectating ~= selectedPlayer and client.hud:isplayeralive(selectedPlayer) then
					client.cam:setspectate(selectedPlayer)
					menu.spectating = selectedPlayer
				else
					if client.char.alive then
						client.cam:setfirstpersoncam()
					else
						local lobby = workspace:FindFirstChild("MenuLobby")
						if lobby then
							client.cam:setmenucam(lobby)
						else
							client.menu:loadmenu()
						end
					end
					menu.spectating = false
				end
			end
		end)
		
		menu.connections.toggle_pressed_pf = TogglePressed.Event:Connect(function(tab, name, gb)
			if name == "Enabled" and tab == "Weapon Modifications" then
				client.animation.player = (gb[1] and menu:GetVal("Misc", "Weapon Modifications", "Remove Animations")) and animhook or client.animation.oldplayer
			end
			if name == "Remove Animations" then
				client.animation.player = (gb[1] and menu:GetVal("Misc", "Weapon Modifications", "Enabled")) and animhook or client.animation.oldplayer
			end
		end)
		local fakelagpos = Vector3.new()
		local fakelagtime = 0
		
		menu.connections.inputstart_pf = INPUT_SERVICE.InputBegan:Connect(function(input)
			if CHAT_BOX.Active then return end
			if input.UserInputType == Enum.UserInputType.MouseButton3 and INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftAlt) then
				local p = client.cam.basecframe.p
				local lv = client.cam.basecframe.lookVector.Unit

				local d = 0
				local bestplayer

				local checkTable = INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) and menu.priority or menu.friends

				for player, bodyparts in next, client.chartable do
					local lvToTorso = (bodyparts.torso.Position - p).Unit
					local dot = lv:Dot(lvToTorso)

					if dot > d then
						d = dot
						bestplayer = player
					end
				end

				if bestplayer then
					local pname = bestplayer.Name
					local existsInFriends = table.find(menu.friends, pname)
					if existsInFriends then
						table.remove(checkTable, existsInFriends)
						CreateNotification(string.format("Removed %s from the friends list.", pname))
					else
						table.insert(checkTable, pname)
						CreateNotification(string.format("Added %s as a friend.", pname))
					end
				end
			end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if menu:GetVal("Rage", "Extra", "Fake Lag") then
					if menu:GetVal("Rage", "Extra", "Manual Choke")
					and input.KeyCode == menu:GetVal("Rage", "Extra", "Manual Choke", "keybind") then
						keybindtoggles.fakelag = not keybindtoggles.fakelag
						NETWORK:SetOutgoingKBPSLimit(menu:GetVal("Rage", "Extra", "Fake Lag Amount"))
					end
				end
				
				
				if shitting_my_pants == false and (menu:GetVal("Misc", "Exploits", "Freeze Players") and input.KeyCode == menu:GetVal("Misc", "Exploits", "Freeze Players", "keybind") and not keybindtoggles.freeze) then
					keybindtoggles.freeze = true
				else
					if shitting_my_pants == true then
						CreateNotification("You may not use exploits while game administrators/moderators are in your server.")
					end
				end
				
				if shitting_my_pants == false and (menu:GetVal("Misc", "Exploits", "Super Invisibility") and input.KeyCode == menu:GetVal("Misc", "Exploits", "Super Invisibility", "keybind")) then
					CreateNotification("Attempting to make you invisible, may need multiple attempts to fully work.")
					for i = 1, 50 do
						local num = i % 2 == 0 and 2 ^ 127 + 1 or -(2 ^ 127 + 1)
						send(nil, "repupdate", client.cam.cframe.p, Vector3.new(num, num, num))
					end
				else
					if shitting_my_pants == true then
						CreateNotification("You may not use exploits while game administrators/moderators are in your server.")
					end
				end
				
				if menu:GetVal("Misc", "Exploits", "Rapid Kill") and input.KeyCode == menu:GetVal("Misc", "Exploits", "Rapid Kill", "keybind") then
					local team = LOCAL_PLAYER.Team.Name == "Phantoms" and game.Teams.Ghosts or game.Teams.Phantoms
					local i = 1
					for k,v in next, team:GetPlayers() do
						if i >= 4 then break end
						if client.hud:isplayeralive(v) then
							i += 1
							client.logic.gammo -= 1
							local curbodyparts = client.replication.getbodyparts(v)
							if not curbodyparts then return end
							local chosenpos = math.abs((curbodyparts.rootpart.Position - curbodyparts.torso.Position).Magnitude) > 10
							and curbodyparts.rootpart.Position or curbodyparts.head.Position
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
											a = Vector3.new(0/0),
											p0 = client.lastrepupdate or client.char.head.Position,
											rotv = Vector3.new()
										},
										{
											v0 = Vector3.new(),
											glassbreaks = {},
											t0 = 0,
											offset = Vector3.new(),
											rot0 = CFrame.new(),
											a = Vector3.new(0/0),
											p0 = Vector3.new(0/0),
											rotv = Vector3.new()
										},
										{
											v0 = Vector3.new(),
											glassbreaks = {},
											t0 = 0,
											offset = Vector3.new(),
											rot0 = CFrame.new(),
											a = Vector3.new(),
											p0 = chosenpos + Vector3.new(0, 3, 0),
											rotv = Vector3.new()
										}
									},
									time = tick(),
									curi = 1,
									blowuptime = 0
								}
							}
							
							send(client.net, "newgrenade", unpack(args))
							client.hud:updateammo("GRENADE")
						end
					end
				end
			end
		end)
		
		menu.connections.inputended_pf = INPUT_SERVICE.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if menu:GetVal("Rage", "Extra", "Fake Lag")
				and menu:GetVal("Rage", "Extra", "Manual Choke")
				and input.KeyCode == menu:GetVal("Rage", "Extra", "Manual Choke", "keybind") and keybindtoggles.fakelag then
					keybindtoggles.fakelag = not keybindtoggles.fakelag
					NETWORK:SetOutgoingKBPSLimit(0)
				end
				
				if shitting_my_pants == false and (menu:GetVal("Misc", "Exploits", "Freeze Players") and input.KeyCode == menu:GetVal("Misc", "Exploits", "Freeze Players", "keybind") and keybindtoggles.freeze) then
					keybindtoggles.freeze = false
				else
					if shitting_my_pants == true then
						CreateNotification("You may not use exploits while game administrators/moderators are in your server.")
					end
				end
			end
		end)
		
		--[[function misc:RoundFreeze()
			if textboxopen then
				client.roundsystem.lock = true
				return
			end
			if menu:GetVal("Misc", "Movement", "Ignore Round Freeze") then
				client.roundsystem.lock = false
			end
		end]]
		
		function misc:FlyHack()
			
			
			if menu:GetVal("Misc", "Movement", "Fly") and keybindtoggles.flyhack then
				local speed = menu:GetVal("Misc", "Movement", "Fly Speed")
				
				local travel = CACHED_VEC3
				local looking = Camera.CFrame.lookVector --getting camera looking vector
				local rightVector = Camera.CFrame.RightVector
				
				
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
					travel += looking
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
					travel -= looking
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
					travel += rightVector
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
					travel -= rightVector
				end
				
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
					travel += Vector3.new(0,1,0)
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
					travel -= Vector3.new(0,1,0)
				end
				
				if travel.Unit.x == travel.Unit.x then
					rootpart.Anchored = false
					rootpart.Velocity = travel.Unit * speed --multiply the unit by the speed to make
				else
					rootpart.Velocity = Vector3.new(0, 0, 0)
					rootpart.Anchored = true
				end
				
			elseif not keybindtoggles.flyhack then
				rootpart.Anchored = false
			end
		end
		
		function misc:SpeedHack()
			
			if keybindtoggles.flyhack then return end
			local type = menu:GetVal("Misc", "Movement", "Speed Type")
			if menu:GetVal("Misc", "Movement", "Speed Hack") then
				local speed = menu:GetVal("Misc", "Movement", "Speed Factor")
				
				local travel = CACHED_VEC3
				local looking = Camera.CFrame.LookVector
				local rightVector = Camera.CFrame.RightVector
				
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.W) then
					travel += looking
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.S) then
					travel -= looking
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.D) then
					travel += rightVector
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.A) then
					travel -= rightVector
				end
				
				travel = Vector2.new(travel.x, travel.Z).Unit
				
				if travel.x == travel.x then
					
					if type == 2 and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or not humanoid.Jump then
						return
					elseif type == 3 and not INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
						return
					end

					if IsKeybindDown("Misc", "Movement", "Speed Hack", true) then
						if type == 1 then
							rootpart.Velocity = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.y * speed)
						else
							rootpart.Velocity = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.y * speed)
						end
					end
				end
			end
			
			
		end
		
		function misc:AutoJump()
			
			
			if menu:GetVal("Misc", "Movement", "Auto Jump") and INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
				humanoid.Jump = true
			end
			
			
		end
		
		function misc:GravityShift()
			
			
			if menu:GetVal("Misc", "Movement", "Gravity Shift") then
				local scaling = menu:GetVal("Misc", "Movement", "Gravity Shift Percentage")
				local mappedGrav = map(scaling, -100, 100, -196.2, 196.2)
				workspace.Gravity = 196.2 + mappedGrav
			else
				workspace.Gravity = 196.2
			end
			
			
		end
		
		function misc:MainLoop()
			if keybindtoggles.crash then return end
			
			
			rootpart = LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.HumanoidRootPart
			rootpart = client.fakebodyroot or rootpart
			humanoid = LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Humanoid
			if rootpart and humanoid then
				if not CHAT_BOX.Active then
					misc:SpeedHack()
					misc:FlyHack()
					misc:AutoJump()
					misc:GravityShift()
					--misc:RoundFreeze()
				elseif keybindtoggles.flyhack then
					rootpart.Anchored = true
				end
			end
			
			
		end
		
		local stutterFrames = 0
		do--ANCHOR send hook
			client.net.send = function(self, ...)
				local args = {...}
				if args[1] == "spawn" then
					misc:ApplyGunMods()
				end
				if args[1] == "chatted" then
					local message = args[2]
					local commandLocation = string.find(message, "\\")
					if commandLocation == 1 then
						local i = 1
						local args = {}
						local func
						local name
						for f in message:gmatch("%w+") do
							if i == 1 then
								if CommandFunctions[f:lower()] then
									name = f:lower()
									func = CommandFunctions[f:lower()]
								end
							else
								table.insert(args, f)
							end
							i += 1
						end
						if name == "cmdlist" then
							return func(CommandFunctions, unpack(args))
						end
						return func(unpack(args))
					end
				end
				if args[1] == "bullethit" and menu:GetVal("Misc", "Extra", "Suppress Only") then return end
				if args[1] == "bullethit" then
					if table.find(menu.friends, args[2].Name) then return end
				end
				if args[1] == "stance" and menu:GetVal("Rage", "Anti Aim", "Force Stance") ~= 1 then return end
				if args[1] == "sprint" and menu:GetVal("Rage", "Anti Aim", "Lower Arms") then return end
				if args[1] == "falldamage" and menu:GetVal("Misc", "Movement", "Prevent Fall Damage") then return end
				if args[1] == "newgrenade" and menu:GetVal("Misc", "Exploits", "Grenade Teleport") then
					local closest = math.huge
					local part
					for i, player in pairs(Players:GetPlayers()) do
						if table.find(menu.friends, player.Name) then continue end
						if player.Team ~= LOCAL_PLAYER.Team and player ~= LOCAL_PLAYER then
							local bodyparts = client.replication.getbodyparts(player)
							if bodyparts then
								local fovToBone = camera:GetFOV(bodyparts.head)
								if fovToBone < closest then
									closest = fovToBone
									part = bodyparts.head
								end
							end
						end
					end
					
					if (closest and part) then
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
										p0 = client.lastrepupdate or client.char.head.Position,
										rotv = Vector3.new()
									},
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0,
										offset = Vector3.new(),
										rot0 = CFrame.new(),
										a = Vector3.new(0/0),
										p0 = Vector3.new(0/0),
										rotv = Vector3.new()
									},
									{
										v0 = Vector3.new(),
										glassbreaks = {},
										t0 = 0,
										offset = Vector3.new(),
										rot0 = CFrame.new(),
										a = Vector3.new(),
										p0 = part.Position + Vector3.new(0, 3, 0),
										rotv = Vector3.new()
									}
								},
								time = tick(),
								curi = 1,
								blowuptime = 0
							}
						}
						
						send(client.net, "newgrenade", unpack(args))
						client.hud:updateammo("GRENADE")
						return
					end
					
				end
				
				if args[1] == "newbullets" then
					if menu:GetVal("Misc", "Exploits", "Fake Equip") then
						send(self, "equip", client.logic.currentgun.id)
					end
					
					if shitting_my_pants == false and menu:GetVal("Misc", "Weapon Modifications", "Edit Bullet Speed") then
						local new_speed = menu:GetVal("Misc", "Weapon Modifications", "Bullet Speed")
						for k, bullet in pairs(args[2].bullets) do
							local old_velocity = bullet[1]
							bullet[1] = {unit = (old_velocity.Unit * new_speed) / client.logic.currentgun.data.bulletspeed}
						end
					end
					
					if legitbot.silentVector then
						for k, bullet in pairs(args[2].bullets) do
							bullet[1] = legitbot.silentVector
						end
					end
					
					if shitting_my_pants == false and keybindtoggles.freeze then
						for k, bullet in pairs(args[2].bullets) do
							bullet[1] = Vector2.new()
						end
						return send(self, unpack(args))
					end
					
					if ragebot.silentVector then
						-- duct tape fix or whatever the fuck its called for this its stupid
						args[2].firepos = ragebot.firepos
						if shitting_my_pants == false and menu:GetVal("Rage", "Anti Aim", "Noclip") and keybindtoggles.fakebody then
							args[2].camerapos = client.cam.cframe.p - Vector3.new(0, client.fakeoffset, 0)
						end
						local cachedtimedata = {}
						
						local hitpoint = ragebot.intersection ~= nil and Vector3.new(ragebot.intersection.X, ragebot.intersection.Y, ragebot.intersection.Z) or ragebot.targetpart.Position -- fuckkkkkkkkk
						-- i need to improve this intersection system a lot, because this can cause problems and nil out and not register the hit
						-- properly when you're using performance mode... fuggjegrnjeiar ngreoi greion agreino agrenoigenroino
						
						if menu:GetVal("Rage", "Hack vs. Hack", "Resolver Type") == 5 and ragebot.needsTP then
							send(self, "repupdate", client.char.head.Position + Vector3.new(0, 18, 0), client.cam.angles)
							send(self, "repupdate", client.char.head.Position + Vector3.new(0, 18, 0), client.cam.angles)
							ragebot.needsTP = false
						end
						
						if menu:GetVal("Rage", "Hack vs. Hack", "Resolver Type") == 7 and ragebot.repupdate then
							send(self, "repupdate", ragebot.repupdate, client.cam.angles)
							args[2].camerapos = ragebot.repupdate
							ragebot.repupdate = nil
						end
						local time
						for k, bullet in pairs(args[2].bullets) do
							if shitting_my_pants == false then
								local angle, bullet_time = client.trajectory(ragebot.firepos, GRAVITY, hitpoint, client.logic.currentgun.data.bulletspeed * 25)
								local new_angle = angle.Unit * client.logic.currentgun.data.bulletspeed * 25
								bullet[1] = {unit = new_angle} -- THIS IS SO FUCKING STUIPD THE FACT IT WORKS LMAO (ABUSING SHIT SERVER SIDE MISTAKE)
								-- BULLET SPEED CHEAT ^
								time = bullet_time
								--cachedtimedata[k] = bullet_time
							else
								local angle, bullet_time = client.trajectory(ragebot.firepos, GRAVITY, hitpoint, client.logic.currentgun.data.bulletspeed)
								bullet[1] = angle
								time = bullet_time
								--cachedtimedata[k] = bullet_time
							end
						end
						
						if menu:GetVal("Rage", "Extra", "Release Packets on Shoot") then
							keybindtoggles.fakelag = false
							syn.set_thread_identity(1) -- might lag...... idk probably not
							NETWORK:SetOutgoingKBPSLimit(0)
						end
						
						args[3] -= time
						send(self, unpack(args))
						
						for k, bullet in pairs(args[2].bullets) do
							local origin = args[2].firepos
							local attach_origin = Instance.new("Attachment", workspace.Terrain)
							attach_origin.Position = origin
							local ending = origin + bullet[1].unit.Unit * 300
							local attach_ending = Instance.new("Attachment", workspace.Terrain)
							attach_ending.Position = ending
							local beam = misc:CreateBeam(attach_origin, attach_ending)
							beam.Parent = workspace
							
							local hitinfo = {
								ragebot.target, hitpoint, ragebot.targetpart, bullet[2]
							}
							--send(self, 'bullethit', unpack(hitinfo))
							--[[if not client.instancetype.IsBanland() then
							delay(cachedtimedata[k], function()
								send(self, 'bullethit', unpack(hitinfo))
							end)
						else
							send(self, 'bullethit', unpack(hitinfo))
						end]]
						client.hud:firehitmarker(ragebot.targetpart.Name == "Head")
						client.sound.PlaySound("hitmarker", nil, 1, 1.5)
						send(self, 'bullethit', unpack(hitinfo))
					end
					if menu:GetVal("Misc", "Exploits", "Fake Equip") then
						local slot = menu:GetVal("Misc", "Exploits", "Fake Slot")
						send(self, "equip", slot)
					end
					-- for k, bullet in pairs(info.bullets) do
					-- 	send(gamenet, "bullethit", rageTarget, rageHitPos, rageHitbox, bullet[2])
					-- end
					return
				else
					if menu:GetVal("Visuals", "Misc Visuals", "Bullet Tracers") then
						for k, bullet in next, args[2].bullets do
							local origin = args[2].firepos
							local attach_origin = Instance.new("Attachment", workspace.Terrain)
							attach_origin.Position = origin
							local ending = origin + (type(bullet[1]) == "table" and bullet[1].unit.Unit or bullet[1].Unit) * 300
							local attach_ending = Instance.new("Attachment", workspace.Terrain)
							attach_ending.Position = ending
							local beam = misc:CreateBeam(attach_origin, attach_ending)
							beam.Parent = workspace
						end
					end
				end
				
				if menu:GetVal("Misc", "Exploits", "Fake Equip") then
					local slot = menu:GetVal("Misc", "Exploits", "Fake Slot")
					send(self, "equip", slot)
				end
			elseif args[1] == "stab" then
				syn.set_thread_identity(1)
				NETWORK:SetOutgoingKBPSLimit(0)
				keybindtoggles.fakelag = false
				if menu:GetVal("Rage", "Extra", "Knife Bot") and IsKeybindDown("Rage", "Extra", "Knife Bot", true) then
					if menu:GetVal("Rage", "Extra", "Knife Bot Type") == 1 then
						ragebot:KnifeTarget(ragebot:GetKnifeTargets()[1])
					end
				end
			elseif args[1] == "equip" then
				if client.fakecharacter then -- finally added knife showing on 3p shit after like month
					if args[2] ~= 3 then
						local gun = client.loadedguns[args[2]].name
						client.fakeupdater.equip(require(game:service("ReplicatedStorage").GunModules[gun]), game:service("ReplicatedStorage").ExternalModels[gun]:Clone())
					else
						local gun = client.logic.currentgun.name
						client.fakeupdater.equipknife(require(game:service("ReplicatedStorage").GunModules[gun]), game:service("ReplicatedStorage").ExternalModels[gun]:Clone())
					end
				end
				
				if menu:GetVal("Misc", "Exploits", "Fake Equip") then
					local slot = menu:GetVal("Misc", "Exploits", "Fake Slot")
					args[2] = slot
				end
			elseif args[1] == "repupdate" then
				client.lastrepupdate = args[2]
				if shitting_my_pants == false and menu:GetVal("Rage", "Anti Aim", "Noclip") and keybindtoggles.fakebody then
					if not client.fakeoffset then client.fakeoffset = 18 end
					
					local nextinc = client.fakeoffset + 9
					client.fakeoffset = nextinc <= 48 and nextinc or client.fakeoffset
				end
				if menu:GetVal("Rage", "Anti Aim", "Enabled") then
					--args[2] = ragebot:AntiNade(args[2])
					stutterFrames += 1
					local pitch = args[3].x
					local yaw = args[3].y
					local pitchChoice = menu:GetVal("Rage", "Anti Aim", "Pitch")
					local yawChoice = menu:GetVal("Rage", "Anti Aim", "Yaw")
					local spinRate = menu:GetVal("Rage", "Anti Aim", "Spin Rate")
					---"off,down,up,roll,upside down,random"
					--{"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random"} pitch
					
					if pitchChoice == 2 then
						pitch = -4
					elseif pitchChoice == 3 then
						pitch = 0
					elseif pitchChoice == 4 then
						pitch = 4.7
					elseif pitchChoice == 5 then
						pitch = -math.pi
					elseif pitchChoice == 6 then
						pitch = (tick() * spinRate) % 6.28
					elseif pitchChoice == 7 then
						pitch = (-tick() * spinRate) % 6.28
					elseif pitchChoice == 8 then
						pitch = math.random(99999)
					elseif pitchChoice == 9 then
						pitch = math.sin((tick() % 6.28) * spinRate)
					elseif pitchChoice == 10 then
						pitch = 2 ^ 127 + 1
					end
					
					--{"Off", "Backward", "Spin", "Random"} yaw
					if yawChoice == 2 then
						yaw += math.pi
					elseif yawChoice == 3 then
						yaw = (tick() * spinRate) % 12
					elseif yawChoice == 4 then
						yaw = math.random(99999)
					elseif yawChoice == 5 then
						yaw = 16478887
					elseif yawChoice == 6 then
						yaw = stutterFrames % (6 * (spinRate / 4)) >= ((6 * (spinRate / 4)) / 2) and 2 or -2
					end
					
					-- yaw += jitter
					local new_angles = Vector3.new(pitch, yaw, 0)
					args[3] = new_angles
					ragebot.angles = new_angles
				end
			end
			return send(self, unpack(args))
		end
		--Legitbot definition defines legit functions
		--Legitbot definition defines legit functions
		--Legitbot definition defines legit functions
		--Legitbot definition defines legit functions
		--Legitbot definition defines legit functions
		--Legitbot definition defines legit functions
		-- Not Rage Functons Dumbass
		
		do -- ANCHOR Legitbot definition defines legit functions
			legitbot.triggerbotShooting = false
			legitbot.silentAiming = false
			legitbot.silentVector = nil
			
			local function Move_Mouse(delta)
				local coef = client.cam.sensitivitymult * math.atan(math.tan(client.cam.basefov * (math.pi / 180) / 2) / 2.72 ^ client.cam.magspring.p) / (32 * math.pi)
				local x = client.cam.angles.x - coef * delta.y
				x = x > client.cam.maxangle and client.cam.maxangle or x < client.cam.minangle and client.cam.minangle or x
				local y = client.cam.angles.y - coef * delta.x
				local newangles = Vector3.new(x, y, 0)
				client.cam.delta = (newangles - client.cam.angles) / 0.016666666666666666
				client.cam.angles = newangles
			end
			
			
			function legitbot:MainLoop()
				legitbot.target = nil
				
				
				if not menu.open and INPUT_SERVICE.MouseBehavior ~= Enum.MouseBehavior.Default and client.logic.currentgun then
					--debug.profilebegin("Legitbot Main")
					if menu:GetVal("Legit", "Aim Assist", "Enabled") then
						local keybind = menu:GetVal("Legit", "Aim Assist", "Aimbot Key") - 1
						local fov = menu:GetVal("Legit", "Aim Assist", "Aimbot FOV")
						local sFov = menu:GetVal("Legit", "Bullet Redirection", "Silent Aim FOV")
						local dzFov = menu:GetVal("Legit", "Aim Assist", "Deadzone FOV")
						
						local hitboxPriority = menu:GetVal("Legit", "Aim Assist", "Hitscan Priority") == 1 and "head" or "torso"
						local hitscan = misc:GetParts(menu:GetVal("Legit", "Aim Assist", "Hitboxes"))
						
						if client.logic.currentgun.type ~= "KNIFE" and INPUT_SERVICE:IsMouseButtonPressed(keybind) or keybind == 2 then
							local targetPart, closest, player = legitbot:GetTargetLegit(hitboxPriority, hitscan)
							legitbot.target = player
							local smoothing = menu:GetVal("Legit", "Aim Assist", "Smoothing") + 2
							if targetPart then
								if closest < fov and closest > dzFov then
									legitbot:AimAtTarget(targetPart, smoothing)
								end
							end
						end
					end
					if menu:GetVal("Legit", "Bullet Redirection", "Silent Aim") then
						local fov = menu:GetVal("Legit", "Bullet Redirection", "Silent Aim FOV")
						local hnum = menu:GetVal("Legit", "Bullet Redirection", "Hitscan Priority")
						local hitboxPriority = hnum == 1 and "head" or hnum == 2 and "torso" or hnum == 3 and false
						local hitscan = misc:GetParts(menu:GetVal("Legit", "Bullet Redirection", "Hitboxes"))
						
						local targetPart, closest, player = legitbot:GetTargetLegit(hitboxPriority, hitscan)
						if targetPart and closest < fov then
							legitbot.silentVector = legitbot:SilentAimAtTarget(targetPart)
						else
							legitbot.silentVector = nil
						end
					end
					--debug.profileend("Legitbot Main")
				end
				
				
			end
			
			function legitbot:AimAtTarget(targetPart, smoothing)
				
				--debug.profilebegin("Legitbot AimAtTarget")
				if not targetPart then return end
				
				local Pos, visCheck
				
				if menu:GetVal("Legit", "Aim Assist", "Adjust for Bullet Drop") then
					Pos, visCheck = Camera:WorldToScreenPoint(camera:GetTrajectory(targetPart.Position + targetPart.Velocity, Camera.CFrame.Position))
				else
					Pos, visCheck = Camera:WorldToScreenPoint(targetPart.Position)
				end
				local randMag = menu:GetVal("Legit", "Aim Assist", "Randomization") * 5
				Pos += Vector3.new(math.noise(time()*0.1, 0.1) * randMag, math.noise(time()*0.1, 200) * randMag, 0)
				--TODO nate fix
				
				local gunpos2d = Camera:WorldToScreenPoint(client.logic.currentgun.aimsightdata[1].sightpart.Position)
				
				local rcs = Vector2.new(LOCAL_MOUSE.x - gunpos2d.x, LOCAL_MOUSE.y - gunpos2d.y)
				if client.logic.currentgun
				and client.logic.currentgun.type ~= "KNIFE"
				and INPUT_SERVICE:IsMouseButtonPressed(1)
				and client.logic.currentgun:isaiming() and menu:GetVal("Legit", "Recoil Control", "Weapon RCS") then
					local xo = menu:GetVal("Legit", "Recoil Control", "Recoil Control X")
					local yo = menu:GetVal("Legit", "Recoil Control", "Recoil Control Y")
					local rcsdelta = Vector3.new(rcs.x * xo/100, rcs.y * yo/100, 0)
					Pos += rcsdelta
				end
				local aimbotMovement = Vector2.new(Pos.x - LOCAL_MOUSE.x, (Pos.y) - LOCAL_MOUSE.y) / smoothing
				
				Move_Mouse(aimbotMovement)
				--debug.profileend("Legitbot AimAtTarget")
				
			end
			
			
			function legitbot:SilentAimAtTarget(targetPart)
				--debug.profilebegin("Legitbot SilentAimAtTarget")
				
				if not targetPart or not targetPart.Position or not client.logic.currentgun then
					return
				end
				if not client.logic.currentgun or not client.logic.currentgun.barrel then
					return
				end
				if client.logic.currentgun.type == "SHOTGUN" then
					local oldOrientation = client.logic.currentgun.barrel.Orientation
					local dir = (targetPart.Position - client.logic.currentgun.barrel.Position)
					local y, x = client.vectorutil.toanglesyx(dir)
					local vec = Vector3.new(y, x)
					client.logic.currentgun.barrel.Orientation = vec
					return 
				end
				if client.logic.currentgun.type == "KNIFE" then return end
				
				if math.random(0, 100) > menu:GetVal("Legit", "Bullet Redirection", "Hit Chance") then return end
				
				if not client.logic.currentgun.barrel then return end
				local origin = client.logic.currentgun.barrel.Position
				
				local target = targetPart.Position
				local dir = camera:GetTrajectory(target, origin) - origin
				dir = dir.Unit
				
				local offsetMult = map((menu:GetVal("Legit", "Bullet Redirection", "Accuracy") / 100 * -1 + 1), 0, 1, 0, 0.3)
				local offset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
				dir += offset * offsetMult
				
				--debug.profileend("Legitbot SilentAimAtTarget")
				return dir.Unit
			end
			
			local function isValidTarget(Bone, Player)
				if camera:IsVisible(Bone, Bone.Parent) then
					return Bone
				end
			end
			--[[
			if menu:GetVal("Legit", "Aim Assist", "Auto Wallbang") then
				local dir = camera:GetTrajectory(Bone.Position, client.cam.cframe.p) - client.cam.cframe.p
				if ragebot:CanPenetrate(LOCAL_PLAYER, Player, dir, Bone.Position)  then
					closest
				end
			elseif camera:IsVisible(Bone) then
				closest = camera:GetFOV(Bone)
				closestPart = Bone
				player = Player
			end
			]]
			function legitbot:GetTargetLegit(partPreference, hitscan, players)
				--debug.profilebegin("Legitbot GetTargetLegit")
				local closest, closestPart, player = math.huge
				partPreference = partPreference or 'what'
				hitscan = hitscan or {}
				players = players or game.Players:GetPlayers()
				
				if legitbot.target then
					local Parts = client.replication.getbodyparts(legitbot.target)
					if Parts then
						new_closest = closest
						for k, Bone in pairs(Parts) do
							if Bone.ClassName == "Part" and hitscan[k] then
								local fovToBone = camera:GetFOV(Bone, client.logic.currentgun:isaiming() and client.logic.currentgun.aimsightdata[1].sightpart)
								if fovToBone < closest then
									local validPart = isValidTarget(Bone, Player)
									if validPart then
										closest = fovToBone
										closestPart = Bone
										player = legitbot.target
										return closestPart, closest, player
									end
								end
							end
						end
					end
				end
				
				for i, Player in pairs(players) do
					if table.find(menu.friends, Player.Name) then continue end
					if Player.Team ~= LOCAL_PLAYER.Team and Player ~= LOCAL_PLAYER then
						local Parts = client.replication.getbodyparts(Player)
						if Parts then
							new_closest = closest
							for k, Bone in pairs(Parts) do
								if Bone.ClassName == "Part" and hitscan[k] then
									local fovToBone = camera:GetFOV(Bone)
									if fovToBone < closest then
										local validPart = isValidTarget(Bone, Player)
										if validPart then
											closest = fovToBone
											closestPart = Bone
											player = Player
										end
									end
								end
							end
						end
					end
				end
				
				if player and closestPart then
					local Parts = client.replication.getbodyparts(player)
					if partPreference then
						local PriorityBone = Parts[partPreference]
						if PriorityBone then
							local fov_to_bone = camera:GetFOV(PriorityBone)
							if  fov_to_bone and fov_to_bone < closest and camera:IsVisible(PriorityBone)  then
								closest = camera:GetFOV(PriorityBone)
								closestPart = PriorityBone
							end
						end
					end
				end
				--debug.profileend("Legitbot GetTargetLegit")
				return closestPart, closest, player
				
				
			end
			
			function legitbot:TriggerBot()
				-- i swear to god the capital GetVal makes me do Menu:GetVal
				if menu:GetVal("Legit", "Trigger Bot", "Enabled") and IsKeybindDown("Legit", "Trigger Bot", "Enabled", true) then
					local parts = misc:GetParts(menu:GetVal("Legit", "Trigger Bot", "Trigger Bot Hitboxes"))
					
					local gun = client.logic.currentgun
					if not gun then return end
					local dsrgposrdjiogjaiogjaoeihjoaiest = "data" -- it loves it
					
					local thebarrel = gun.barrel
					--debug.profilebegin("Legitbot Triggerbot")
					warn("logic", "currentgun", "data", "bulletspeed", gun.data.bulletspeed)
					local bulletspeed = gun.data.bulletspeed
					local isaiming = gun:isaiming()
					local zoomval = menu:GetVal("Legit", "Trigger Bot", "Aim Percentage") / 100
					--local shootallowed = menu:GetVal("Legit", "Trigger Bot", "Trigger When Aiming") and (isaiming and (client.zoommodspring.p > zoomval) or false) or true -- isaiming and (zoommodspring.p > zoomval) or false is somewhat redundant but oh well lmao
					local shootallowed
					
					if menu:GetVal("Legit", "Trigger Bot", "Trigger When Aiming") then
						shootallowed = isaiming and (client.zoommodspring.p >= zoomval) or false
					else
						shootallowed = true
					end
					
					if shootallowed then
						for player, bodyparts in next, getupvalue(client.replication.getallparts, 1) do
							if player.Team ~= LOCAL_PLAYER.Team then
								for bpartname, bodypart in next, bodyparts do
									if bodypart:IsA("Part") and bodypart.Transparency == 0 and parts[bpartname] then
										if camera:IsVisible(bodypart) then
											local barrel = isaiming and gun.aimsightdata[1].sightpart or thebarrel
											local delta = (bodypart.Position - barrel.Position)
											local direction = client.trajectory(barrel.Position, GRAVITY, bodypart.Position, bulletspeed).Unit
											local barrelLV = barrel.CFrame.LookVector
											local normalized = barrelLV.unit
											
											local dot = normalized:Dot(direction)
											
											if delta.magnitude > 2050 then
												if barrelLV.Y >= direction.Y then
													local dist = delta.magnitude ^ -2.3
													
													local dotthreshold = 1 - dist
													
													if dot >= dotthreshold then
														gun:shoot(true)
														legitbot.triggerbotShooting = true
														if isaiming then
															gun:setaim(false)
														end
													end
												end
											else
												local whitelist = {bodypart}
												
												if gun.type == "SHOTGUN" or gun.data.pelletcount then
													table.insert(whitelist, sphereHitbox)
													sphereHitbox.Position = bodypart.Position
												end
												
												local hit, hitpos = workspace:FindPartOnRayWithWhitelist(Ray.new(barrel.Position, normalized * 4000), whitelist)
												if hit and hit:IsDescendantOf(bodypart.Parent.Parent) or hit == sphereHitbox then
													local hitdir = (hitpos - barrel.Position).unit
													if hitdir:Dot(direction) > 0.9993 then
														gun:shoot(true)
														if isaiming then
															gun:setaim(false)
														end
													end
												end
											end
										end
									elseif legitbot.triggerbotShooting then
										gun:shoot(false)
										legitbot.triggerbotShooting = false
									end
								end
							end
						end
					end
					--[[local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(barrel.CFrame.Position, barrel.CFrame.LookVector*5000), {Camera, workspace.Players[LOCAL_PLAYER.Team.Name], workspace.Ignore})
					
					if hit and parts[hit.Name] then
						if not camera:IsVisible(hit) then return end
						client.logic.currentgun:shoot(true)
						legitbot.triggerbotShooting = true
					elseif legitbot.triggerbotShooting then
						client.logic.currentgun:shoot(false)
						legitbot.triggerbotShooting = false
					end]]
					--debug.profileend("Legitbot Triggerbot")
				end
				
				
			end
			
			
		end
		
		local newpart = client.particle.new
		client.particle.new = function(P)
			local new_speed
			
			if menu:GetVal("Misc", "Weapon Modifications", "Edit Bullet Speed") then
				new_speed = menu:GetVal("Misc", "Weapon Modifications", "Bullet Speed")
			end
			
			local mag = new_speed or P.velocity.Magnitude
			
			if not P.thirdperson then
				if menu:GetVal("Legit", "Bullet Redirection", "Silent Aim") and legitbot.silentVector then
					P.velocity = legitbot.silentVector.Unit * mag
				elseif menu:GetVal("Rage", "Aimbot", "Enabled") and ragebot.silentVector then
					local oldpos = P.position
					P.position = ragebot.firepos
					P.velocity = ragebot.silentVector.Unit * mag
					P.visualorigin = ragebot.firepos
					P.ontouch = nil -- paster gave me this idea it will probably help the ragebot not be detected and other shit
				else
					if new_speed then
						P.velocity = P.velocity.Unit * new_speed
					end
				end
			end

			return newpart(P)
		end
		
		
		--ADS Fov hook
		local crosshairColors
		local function renderVisuals()
			if menu.open then
				--debug.profilebegin("renderVisuals Char")
				client.char.unaimedfov = menu.options["Visuals"]["Camera Visuals"]["Camera FOV"][1]
				for i, frame in pairs(PLAYER_GUI.MainGui.GameGui.CrossHud:GetChildren()) do
					if not crosshairColors then crosshairColors = {
						inline = frame.BackgroundColor3,
						outline = frame.BorderColor3
					} 
				end -- MEOW -core 2021
				local inline = menu:GetVal("Visuals", "Misc Visuals", "Crosshair Color", "color1", true)
				local outline = menu:GetVal("Visuals", "Misc Visuals", "Crosshair Color", "color2", true)
				local enabled = menu:GetVal("Visuals", "Misc Visuals", "Crosshair Color")
				frame.BackgroundColor3 = enabled and inline or crosshairColors.inline
				frame.BorderColor3 = enabled and outline or crosshairColors.outline
				--debug.profileend()
			end
		end -- fun end!
		--------------------------------------world funnies
		--debug.profilebegin("renderVisuals World")
		if menu.options["Visuals"]["World Visuals"]["Force Time"][1] then
			game.Lighting.ClockTime = menu.options["Visuals"]["World Visuals"]["Custom Time"][1] 
		end
		if menu.options["Visuals"]["World Visuals"]["Ambience"][1] then
			game.Lighting.Ambient = RGB(menu.options["Visuals"]["World Visuals"]["Ambience"][5][1][1][1][1], menu.options["Visuals"]["World Visuals"]["Ambience"][5][1][1][1][2], menu.options["Visuals"]["World Visuals"]["Ambience"][5][1][1][1][3])
			game.Lighting.OutdoorAmbient = RGB(menu.options["Visuals"]["World Visuals"]["Ambience"][5][1][2][1][1], menu.options["Visuals"]["World Visuals"]["Ambience"][5][1][2][1][2], menu.options["Visuals"]["World Visuals"]["Ambience"][5][1][2][1][3])
		else
			game.Lighting.Ambient = game.Lighting.MapLighting.Ambient.Value
			game.Lighting.OutdoorAmbient = game.Lighting.MapLighting.OutdoorAmbient.Value
		end
		if menu.options["Visuals"]["World Visuals"]["Custom Saturation"][1] then
			game.Lighting.MapSaturation.TintColor = RGB(menu.options["Visuals"]["World Visuals"]["Custom Saturation"][5][1][1], menu.options["Visuals"]["World Visuals"]["Custom Saturation"][5][1][2], menu.options["Visuals"]["World Visuals"]["Custom Saturation"][5][1][3])
			game.Lighting.MapSaturation.Saturation = menu.options["Visuals"]["World Visuals"]["Saturation Density"][1]/50
		else
			game.Lighting.MapSaturation.TintColor = RGB(170,170,170)
			game.Lighting.MapSaturation.Saturation = -0.25
		end
		--debug.profileend("renderVisuals World")
		
		--debug.profilebegin("renderVisuals Player ESP Reset")
		-- TODO this reset may need to be improved to a large extent, it's taking up some time but idk if the frame times are becoming worse because of this
		for k, v in pairs(allesp) do
			for k1, v1 in pairs(v) do
				if type(v1) ~= "table" then continue end
				for k2, drawing in ipairs(v1) do
					drawing.Visible = false
				end
			end
		end
		
		for k, v in ipairs(allesp.skel) do
			for k1, v1 in ipairs(v) do
				v1.Visible = false
			end
		end
		
		for k, v in pairs(wepesp) do
			for k1, v1 in pairs(v) do
				v1.Visible = false
			end
		end
		
		for k, v in pairs(nadeesp) do
			for k1, v1 in pairs(v) do
				v1.Visible = false
			end
		end
		
		--debug.profileend("renderVisuals Player ESP Reset")
		
		----------
		--debug.profilebegin("renderVisuals Main")
		if client.cam.type ~= "menu" then
			
			local players = Players:GetPlayers()
			-- table.sort(players, function(p1, p2)
			-- 	return table.find(menu.priority, p2.Name) ~= table.find(menu.priority, p1.Name) and table.find(menu.priority, p2.Name) == true and table.find(menu.priority, p1.Name) == false
			-- end)
			local cam = Camera.CFrame
			
			local priority_color = menu:GetVal("ESP", "ESP Settings", "Highlight Priority", "color", true)
			local priority_trans = menu:GetVal("ESP", "ESP Settings", "Highlight Priority", "color")[4]/255
			
			local friend_color = menu:GetVal("ESP", "ESP Settings", "Highlight Friends", "color", true)
			local friend_trans = menu:GetVal("ESP", "ESP Settings", "Highlight Friends", "color")[4]/255
			
			local target_color = menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target", "color", true)
			local target_trans = menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target", "color")[4]/255
			
			for Index, Player in next, Players:GetPlayers() do
				
				if not client.hud:isplayeralive(Player) then continue end
				local parts = client.replication.getbodyparts(Player)
				
				if not parts then continue end
				
				local GroupBox = Player.Team == LOCAL_PLAYER.Team and "Team ESP" or "Enemy ESP"
				
				if not menu:GetVal("ESP", GroupBox, "Enabled") then continue end
				
				Player.Character = parts.rootpart.Parent
				
				
				local torso = parts.torso.CFrame
				
				--debug.profilebegin("renderVisuals Player ESP Box Calculation " .. Player.Name)
				
				local vTop = torso.Position + (torso.UpVector * 1.8) + cam.UpVector
				local vBottom = torso.Position - (torso.UpVector * 2.5) - cam.UpVector
				
				local top, topIsRendered = Camera:WorldToViewportPoint(vTop)
				local bottom, bottomIsRendered = Camera:WorldToViewportPoint(vBottom)
				
				-- local minY = math.abs(bottom.y - top.y)
				-- local sizeX = math.ceil(math.max(math.clamp(math.abs(bottom.x - top.x) * 2, 0, minY), minY / 2))
				-- local sizeY = math.ceil(math.max(minY, sizeX * 0.5))
				
				-- local boxSize = Vector2.new(sizeX, sizeY)
				local _width = math.floor(math.abs(top.x - bottom.x))
				local _height = math.floor(math.max(math.abs(bottom.y - top.y), _width/2))
				local boxSize = Vector2.new(math.floor(math.max(_height/1.5, _width)), _height)
				local boxPosition = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - boxSize.x * 0.5), math.floor(math.min(top.y, bottom.y)))
				
				--debug.profileend("renderVisuals Player ESP Box Calculation " .. Player.Name)
				
				local GroupBox = Player.Team == LOCAL_PLAYER.Team and "Team ESP" or "Enemy ESP"
				local health = math.ceil(client.hud:getplayerhealth(Player))
				local spoty = 0
				local boxtransparency = menu:GetVal("ESP", GroupBox, "Box", "color")[4] / 255
				
				local distance = math.floor((parts.rootpart.Position - client.cam.cframe.p).Magnitude/5)
				
				
				if (topIsRendered or bottomIsRendered) then
					if menu.options["ESP"][GroupBox]["Name"][1] then
						
						--debug.profilebegin("renderVisuals Player ESP Render Name " .. Player.Name)
						
						local name = tostring(Player.Name)
						if menu.options["ESP"]["ESP Settings"]["Text Case"][1] == 1 then
							name = string.lower(name)
						elseif menu.options["ESP"]["ESP Settings"]["Text Case"][1] == 3 then
							name = string.upper(name)
						end
						
						allesp.text.name[Index].Text = string_cut(name, menu:GetVal("ESP", "ESP Settings", "Max Text Length"))
						allesp.text.name[Index].Visible = true
						allesp.text.name[Index].Position = Vector2.new(boxPosition.x + boxSize.x * 0.5, boxPosition.y - 15)
						
						--debug.profileend("renderVisuals Player ESP Render Name " .. Player.Name)
						
					end
					
					if menu.options["ESP"][GroupBox]["Box"][1] then
						--debug.profilebegin("renderVisuals Player ESP Render Box " .. Player.Name)
						for i = -1, 1 do
							local box = allesp.box[i+2][Index]
							box.Visible = true
							box.Position = boxPosition + Vector2.new(i, i)
							box.Size = boxSize - Vector2.new(i*2, i*2)
							box.Transparency = boxtransparency
							
							if i ~= 0 then
								box.Color = RGB(20, 20, 20)
							end
							--box.Color = i == 0 and color or bColor:Add(bColor:Mult(color, 0.2), 0.1)
							
						end
						--debug.profileend("renderVisuals Player ESP Render Box " .. Player.Name)
					end
					
					
					if menu.options["ESP"][GroupBox]["Health Bar"][1] then
						
						--debug.profilebegin("renderVisuals Player ESP Render Health Bar " .. Player.Name)
						
						local ySizeBar = -math.floor(boxSize.y * health / 100)
						if menu.options["ESP"][GroupBox]["Health Number"][1] and health <= menu.options["ESP"]["ESP Settings"]["Max HP Visibility Cap"][1] then
							local hptext = allesp.hp.text[Index]
							hptext.Visible = true
							hptext.Text = tostring(health)
							
							local tb = hptext.TextBounds
							
							-- math.clamp(ySizeBar + boxSize.y - tb.y * 0.5, -tb.y, boxSize.y - tb.y )
							hptext.Position = boxPosition + Vector2.new(-tb.x - 7, math.clamp(ySizeBar + boxSize.y - tb.y * 0.5, -4, boxSize.y - 10))
							--hptext.Position = Vector2.new(boxPosition.x - 7 - tb.x, boxPosition.y + math.clamp(boxSize.y + ySizeBar - 8, -4, boxSize.y - 10))
							hptext.Color = menu:GetVal("ESP", GroupBox, "Health Number", "color", true)
							hptext.Transparency = menu.options["ESP"][GroupBox]["Health Number"][5][1][4] / 255

							--[[
							if menu:GetVal("Visuals", "Player ESP", "Health Number") then
								allesp.hptext[i].Text = tostring(health)
								local textsize = allesp.hptext[i].TextBounds
								allesp.hptext[i].Position = Vector2.new(boxtop.x - 7 - textsize.x, boxtop.y + math.clamp(boxsize.h + ySizeBar - 8, -4, boxsize.h - 10))
								allesp.hptext[i].Visible = true
							end
							]]
						end
						
						allesp.hp.outer[Index].Visible = true
						allesp.hp.outer[Index].Position = Vector2.new(math.floor(boxPosition.x) - 6, math.floor(boxPosition.y) - 1)
						allesp.hp.outer[Index].Size = Vector2.new(4, boxSize.y + 2)
						
						allesp.hp.inner[Index].Visible = true
						allesp.hp.inner[Index].Position = Vector2.new(math.floor(boxPosition.x) - 5, math.floor(boxPosition.y + boxSize.y))
						
						allesp.hp.inner[Index].Size = Vector2.new(2, ySizeBar)
						
						allesp.hp.inner[Index].Color = ColorRange(health, {
							[1] = {start = 0, color = menu:GetVal("ESP", GroupBox, "Health Bar", "color1", true)},
							[2] = {start = 100, color = menu:GetVal("ESP", GroupBox, "Health Bar", "color2", true)}
						})
						
						--debug.profileend("renderVisuals Player ESP Render Health Bar " .. Player.Name)
						
					elseif menu.options["ESP"][GroupBox]["Health Number"][1] and health <= menu.options["ESP"]["ESP Settings"]["Max HP Visibility Cap"][1] then
						--debug.profilebegin("renderVisuals Player ESP Render Health Number " .. Player.Name)
						
						local hptext = allesp.hp.text[Index]
						
						hptext.Visible = true
						hptext.Text = tostring(health)
						
						local tb = hptext.TextBounds
						
						hptext.Position = boxPosition + Vector2.new(-tb.x - 2, - 4)
						hptext.Color = menu:GetVal("ESP", GroupBox, "Health Number", "color", true)
						hptext.Transparency = menu.options["ESP"][GroupBox]["Health Number"][5][1][4]/255
						
						--debug.profileend("renderVisuals Player ESP Render Health Number " .. Player.Name)
					end
					
					
					if menu.options["ESP"][GroupBox]["Held Weapon"][1] then
						
						--debug.profilebegin("renderVisuals Player ESP Render Held Weapon " .. Player.Name)
						
						local charWeapon = _3pweps[Player]
						local wepname = charWeapon and charWeapon or "???"
						
						if menu.options["ESP"]["ESP Settings"]["Text Case"][1] == 1 then
							wepname = string.lower(wepname)
						elseif menu.options["ESP"]["ESP Settings"]["Text Case"][1] == 3 then
							wepname = string.upper(wepname)
						end
						
						local weptext = allesp.text.weapon[Index]
						
						spoty += 12
						weptext.Text = string_cut(wepname, menu:GetVal("ESP", "ESP Settings", "Max Text Length"))
						weptext.Visible = true
						weptext.Position = Vector2.new(boxPosition.x + boxSize.x * 0.5, boxPosition.y + boxSize.y)
						
						--debug.profileend("renderVisuals Player ESP Render Held Weapon " .. Player.Name)
						
					end
					
					if menu.options["ESP"][GroupBox]["Distance"][1] then
						
						--debug.profilebegin("renderVisuals Player ESP Render Distance " .. Player.Name)
						
						local disttext = allesp.text.distance[Index]
						
						disttext.Text = tostring(distance).."m"
						disttext.Visible = true
						disttext.Position = Vector2.new(boxPosition.x + boxSize.x * 0.5, boxPosition.y + boxSize.y + spoty)
						
						--debug.profileend("renderVisuals Player ESP Render Distance " .. Player.Name)
						
					end
					
					if menu.options["ESP"][GroupBox]["Skeleton"][1] then
						
						--debug.profilebegin("renderVisuals Player ESP Render Skeleton" .. Player.Name)
						
						local torso = Camera:WorldToViewportPoint(Player.Character.Torso.Position)
						for k2, v2 in ipairs(skelparts) do
							local line = allesp.skel[k2][Index]
							
							local posie = Camera:WorldToViewportPoint(Player.Character:FindFirstChild(v2).Position)
							line.From = Vector2.new(posie.x, posie.y)
							line.To = Vector2.new(torso.x, torso.y)
							line.Visible = true
							
						end
						--debug.profileend("renderVisuals Player ESP Render Skeleton" .. Player.Name)
					end
					--da colourz !!! :D 🔥🔥🔥🔥
					
					if menu:GetVal("ESP", "ESP Settings", "Highlight Priority") and table.find(menu.priority, Player.Name) then
						
						
						allesp.text.name[Index].Color = priority_color
						allesp.text.name[Index].Transparency = priority_trans
						
						allesp.box[2][Index].Color = priority_color
						
						allesp.text.weapon[Index].Color = priority_color
						allesp.text.weapon[Index].Transparency = priority_trans
						
						allesp.text.distance[Index].Color = priority_color
						allesp.text.distance[Index].Transparency = priority_trans
						
						for k2, v2 in ipairs(skelparts) do
							local line = allesp.skel[k2][Index]
							line.Color = priority_color
							line.Transparency = priority_trans
						end
						
						
					elseif menu:GetVal("ESP", "ESP Settings", "Highlight Friends") and table.find(menu.friends, Player.Name) then
						
						allesp.text.name[Index].Color = friend_color
						allesp.text.name[Index].Transparency = friend_trans
						
						allesp.box[2][Index].Color = friend_color
						
						allesp.text.weapon[Index].Color = friend_color
						allesp.text.weapon[Index].Transparency = friend_trans
						
						allesp.text.distance[Index].Color = friend_color
						allesp.text.distance[Index].Transparency = friend_trans
						
						for k2, v2 in ipairs(skelparts) do
							local line = allesp.skel[k2][Index]
							line.Color = friend_color
							line.Transparency = friend_trans
						end
					elseif menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target") and (Player == legitbot.target or Player == ragebot.target)  then
						
						allesp.text.name[Index].Color = target_color
						allesp.text.name[Index].Transparency = target_trans
						
						allesp.box[2][Index].Color = target_color
						
						allesp.text.weapon[Index].Color = target_color
						allesp.text.weapon[Index].Transparency = target_trans
						
						allesp.text.distance[Index].Color = target_color
						allesp.text.distance[Index].Transparency = target_trans
						
						for k2, v2 in ipairs(skelparts) do
							local line = allesp.skel[k2][Index]
							line.Color = target_color
							line.Transparency = target_trans
						end
					else
						
						
						allesp.text.name[Index].Color = menu:GetVal("ESP", GroupBox, "Name", "color", true) -- RGB(menu.options["ESP"][GroupBox]["Name"][5][1][1], menu.options["ESP"][GroupBox]["Name"][5][1][2], menu.options["ESP"][GroupBox]["Name"][5][1][3])
						allesp.text.name[Index].Transparency = menu:GetVal("ESP", GroupBox, "Name", "color")[4]/255
						
						allesp.box[2][Index].Color = menu:GetVal("ESP", GroupBox, "Box", "color", true)
						
						allesp.text.weapon[Index].Color = menu:GetVal("ESP", GroupBox, "Held Weapon", "color", true)
						allesp.text.weapon[Index].Transparency = menu:GetVal("ESP", GroupBox, "Held Weapon", "color")[4]/255
						
						allesp.text.distance[Index].Color = menu:GetVal("ESP", GroupBox, "Distance", "color", true)
						allesp.text.distance[Index].Transparency = menu:GetVal("ESP", GroupBox, "Distance", "color")[4]/255
						
						for k2, v2 in ipairs(skelparts) do
							local line = allesp.skel[k2][Index]
							line.Color = menu:GetVal("ESP", GroupBox, "Skeleton", "color", true)
							line.Transparency = menu:GetVal("ESP", GroupBox, "Skeleton", "color")[4]/255
						end
					end
					
				elseif GroupBox == "Enemy ESP" and menu:GetVal("ESP", "Enemy ESP", "Out of View") then
					--debug.profilebegin("renderVisuals Player ESP Render Out of View " .. Player.Name)
					local color = menu:GetVal("ESP", "Enemy ESP", "Out of View", "color", true)
					local color2 = bColor:Add(bColor:Mult(color, 0.2), 0.1)
					if menu:GetVal("ESP", "ESP Settings", "Highlight Priority") and table.find(menu.priority, Player.Name) then
						color = menu:GetVal("ESP", "ESP Settings", "Highlight Priority", "color", true)
						color2 = bColor:Mult(color, 0.6)
					elseif menu:GetVal("ESP", "ESP Settings", "Highlight Friends", "color") and table.find(menu.friends, Player.Name) then
						color = menu:GetVal("ESP", "ESP Settings", "Highlight Friends", "color", true)
						color2 = bColor:Mult(color, 0.6)
					elseif menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target") and (Player == legitbot.target or Player == ragebot.target) then
						color = menu:GetVal("ESP", "ESP Settings", "Highlight Aimbot Target", "color", true)
						color2 = bColor:Mult(color, 0.6)
					end
					for i = 1, 2 do
						local Tri = allesp.arrows[i][Index]
						
						local partCFrame = Player.Character.HumanoidRootPart.CFrame -- these HAVE to move now theres no way
						
						Tri.Visible = true
						
						local relativePos = Camera.CFrame:PointToObjectSpace(partCFrame.Position)
						local direction = math.atan2(-relativePos.y, relativePos.x)
						
						local distance = relativePos.Magnitude
						local arrow_size = menu:GetVal("ESP", "Enemy ESP", "Dynamic Arrow Size") and map(distance, 1, 100, 50, 15) or 15
						arrow_size = arrow_size > 50 and 50 or arrow_size < 15 and 15 or arrow_size
						
						direction = Vector2.new(math.cos(direction), math.sin(direction))
						
						local pos = (direction * SCREEN_SIZE.y * menu:GetVal("ESP", "Enemy ESP", "Arrow Distance")/200) + (SCREEN_SIZE * 0.5)
						
						Tri.PointA = pos
						Tri.PointB = pos - bVector2:getRotate(direction, 0.5) * arrow_size
						Tri.PointC = pos - bVector2:getRotate(direction, -0.5) * arrow_size
						
						Tri.Color = i == 1 and color or color2
						Tri.Transparency = menu:GetVal("ESP", "Enemy ESP", "Out of View", "color")[4] / 255
					end
					--debug.profileend("renderVisuals Player ESP Render Out of View " .. Player.Name)
				end
				
			end
			
			--ANCHOR weapon esp
			if menu:GetVal("ESP", "Dropped ESP", "Weapon Name") or menu:GetVal("ESP", "Dropped ESP", "Weapon Ammo") then
				--debug.profilebegin("renderVisuals Dropped ESP")
				local gunnum = 0
				for k, v in pairs(workspace.Ignore.GunDrop:GetChildren()) do
					CreateThread(function()
						if not client then return end
						if v.Name == "Dropped" then
							local gunpos = v.Slot1.Position
							local gun_dist = (gunpos - client.cam.cframe.p).Magnitude
							if gun_dist > 80 then return end
							local hasgun = false
							local gunpos2d, gun_on_screen = workspace.CurrentCamera:WorldToScreenPoint(gunpos)
							for k1, v1 in pairs(v:GetChildren()) do
								if tostring(v1) == "Gun" then
									hasgun = true
									break
								end
							end
							
							if gun_on_screen and gunnum <= 50 and hasgun then
								gunnum = gunnum + 1
								local gunclearness = 1
								if gun_dist >= 50 then
									local closedist = gun_dist - 50
									gunclearness = 1 - (1 * closedist/30)
								end
								
								if menu:GetVal("ESP", "Dropped ESP", "Weapon Name") then
									wepesp.name[gunnum].Text = v.Gun.Value
									wepesp.name[gunnum].Color = menu:GetVal("ESP", "Dropped ESP", "Weapon Name", "color", true)
									wepesp.name[gunnum].Transparency = menu:GetVal("ESP", "Dropped ESP", "Weapon Name", "color")[4] * gunclearness /255
									wepesp.name[gunnum].Visible = true
									wepesp.name[gunnum].Position = Vector2.new(math.floor(gunpos2d.x), math.floor(gunpos2d.y + 25))
								end
								if menu:GetVal("ESP", "Dropped ESP", "Weapon Ammo") then
									wepesp.ammo[gunnum].Text = "[ "..tostring(v.Spare.Value).." ]"
									wepesp.ammo[gunnum].Color = menu:GetVal("ESP", "Dropped ESP", "Weapon Ammo", "color", true)
									wepesp.ammo[gunnum].Transparency = menu:GetVal("ESP", "Dropped ESP", "Weapon Ammo", "color")[4] * gunclearness /255
									wepesp.ammo[gunnum].Visible = true
									wepesp.ammo[gunnum].Position = Vector2.new(math.floor(gunpos2d.x), math.floor(gunpos2d.y + 36))
								end
							end
						end
					end)
				end
				--debug.profileend("renderVisuals Dropped ESP")
			end
			
			--debug.profilebegin("renderVisuals Dropped ESP Nade Warning")
			if menu:GetVal("ESP", "Dropped ESP", "Nade Warning") then
				local nadenum = 0
				local health = client.char:gethealth()
				local color1 = menu:GetVal("ESP", "Dropped ESP", "Nade Warning", "color", true)
				local color2 = RGB(menu:GetVal("ESP", "Dropped ESP", "Nade Warning", "color")[1] - 20, menu:GetVal("ESP", "Dropped ESP", "Nade Warning", "color")[2] - 20, menu:GetVal("ESP", "Dropped ESP", "Nade Warning", "color")[3] - 20)
				for index, nade in pairs(menu.activenades) do
					local headpos = LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Head.Position or Vector3.new()
					local nade_dist = (nade.blowupat - headpos).Magnitude
					local nade_percent = (tick() - nade.start)/(nade.blowuptick - nade.start)
					
					if nade_dist <= 80 then
						
						local nadepos, nade_on_screen = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(nade.blowupat.x, nade.blowupat.y, nade.blowupat.z))
						
						if not nade_on_screen then
							
							local relativePos = Camera.CFrame:PointToObjectSpace(nade.blowupat)
							local angle = math.atan2(-relativePos.y, relativePos.x)
							local ox = math.cos(angle)
							local oy = math.sin(angle)
							local slope = (oy)/(ox)
							
							local h_edge = SCREEN_SIZE.x - 36
							local v_edge = SCREEN_SIZE.y - 72
							if oy < 0 then
								v_edge = 0
							end
							if ox < 0 then
								h_edge = 36
							end
							local y = (slope * h_edge) + (SCREEN_SIZE.y / 2) - slope * (SCREEN_SIZE.x / 2)
							if y > 0 and y < SCREEN_SIZE.y - 72 then
								nadepos = Vector2.new(h_edge, y)
							else
								nadepos = Vector2.new((v_edge - SCREEN_SIZE.y / 2 + slope * (SCREEN_SIZE.x / 2))/slope, v_edge)
							end
							
						end
						nadenum += 1
						--
						nadeesp.outer_c[nadenum].Visible = true
						nadeesp.outer_c[nadenum].Position = Vector2.new(math.floor(nadepos.x), math.floor(nadepos.y + 36))
						
						nadeesp.inner_c[nadenum].Visible = true
						nadeesp.inner_c[nadenum].Position = Vector2.new(math.floor(nadepos.x), math.floor(nadepos.y + 36))
						
						nadeesp.text[nadenum].Visible = true
						nadeesp.text[nadenum].Position = Vector2.new(math.floor(nadepos.x) - 10, math.floor(nadepos.y + 10))
						
						nadeesp.distance[nadenum].Visible = true
						nadeesp.distance[nadenum].Position = Vector2.new(math.floor(nadepos.x), math.floor(nadepos.y + 36))
						
						local d0 = 250 -- max damage
						local d1 = 15 -- min damage
						local r0 = 8 -- maximum range before the damage starts dropping off due to distance
						local r1 = 30 -- minimum range i think idk
						
						local damage = nade_dist < r0 and d0 or nade_dist < r1 and (d1-d0) / (r1-r0) * (nade_dist-r0) + d0 or 0
						
						local wall
						if damage > 0 then
							wall = workspace:FindPartOnRayWithWhitelist(Ray.new(headpos, (nade.blowupat - headpos)), client.roundsystem.raycastwhitelist)
							if wall then damage = 0 end
						end
						
						local str = damage == 0 and "Safe" or damage >= health and "LETHAL" or string.format("-%d hp", damage)
						nadeesp.distance[nadenum].Text = str
						
						nadeesp.outer_c[nadenum].Color = ColorRange(damage, {
							[1] = {start = 15, color = RGB(20, 20, 20)},
							[2] = {start = health, color = RGB(150, 20, 20)}
						})
						
						nadeesp.inner_c[nadenum].Color = ColorRange(damage, {
							[1] = {start = 15, color = RGB(50, 50, 50)},
							[2] = {start = health, color = RGB(220, 20, 20)}
						})
						
						nadeesp.bar_outer[nadenum].Visible = true
						nadeesp.bar_outer[nadenum].Position = Vector2.new(math.floor(nadepos.x) - 16, math.floor(nadepos.y + 50))
						
						nadeesp.bar_inner[nadenum].Visible = true
						nadeesp.bar_inner[nadenum].Position = Vector2.new(math.floor(nadepos.x) - 15, math.floor(nadepos.y + 51))
						
						--print(nade.blowuptick - nade.start)
						
						nadeesp.bar_moving_1[nadenum].Visible = true
						nadeesp.bar_moving_1[nadenum].Size = Vector2.new(30 * (1 - nade_percent), 2)
						nadeesp.bar_moving_1[nadenum].Position = Vector2.new(math.floor(nadepos.x) - 15, math.floor(nadepos.y + 51))
						nadeesp.bar_moving_1[nadenum].Color = color1
						
						nadeesp.bar_moving_2[nadenum].Visible = true
						nadeesp.bar_moving_2[nadenum].Size = Vector2.new(30 * (1 - nade_percent), 2)
						nadeesp.bar_moving_2[nadenum].Position = Vector2.new(math.floor(nadepos.x) - 15, math.floor(nadepos.y + 53))
						nadeesp.bar_moving_2[nadenum].Color = color2
						
						
						local tranz = 1
						if nade_dist >= 50 then
							local closedist = nade_dist - 50
							tranz = 1 - (1 * closedist/30)
						end
						
						for k, v in pairs(nadeesp) do
							v[nadenum].Transparency = tranz
						end
						
					end
					
				end
				
			end
			
			--debug.profileend("renderVisuals Dropped ESP Nade Warning")
			
			--debug.profilebegin("renderVisuals Local Visuals")
			
			CreateThread(function() -- hand chams and such
				if not client then return end
				local vm = workspace.Camera:GetChildren()
				if menu:GetVal("Visuals", "Local Visuals", "Arm Chams") then
					
					local material = menu:GetVal("Visuals", "Local Visuals", "Arm Material")
					
					for k, v in pairs(vm) do
						if v.Name == "Left Arm" or v.Name == "Right Arm" then
							for k1, v1 in pairs(v:GetChildren()) do
								v1.Color = menu:GetVal("Visuals", "Local Visuals", "Arm Chams", "color2", true)
								if not client.fakecharacter then
									v1.Transparency = 1 + (menu:GetVal("Visuals", "Local Visuals", "Arm Chams", "color2")[4]/-255)
								else
									v1.Transparency = 1
								end
								v1.Material = mats[material]
								if v1.ClassName == "MeshPart" or v1.Name == "Sleeve" then
									v1.Color = menu:GetVal("Visuals", "Local Visuals", "Arm Chams", "color1", true)
									if not client.fakecharacter then
										v1.Transparency = 1 + (menu:GetVal("Visuals", "Local Visuals", "Arm Chams", "color1")[4]/-255)
									else
										v1.Transparency = 1
									end
									if v1.TextureID and tostring(material) ~= "ForceField" then
										v1.TextureID = ""
									else
										v1.TextureID = "rbxassetid://2163189692"
									end
									v1:ClearAllChildren()
								end
							end
						end
					end
				end
				if menu:GetVal("Visuals", "Local Visuals", "Weapon Chams") then
					for k, v in pairs(vm) do
						if v.Name ~= "Left Arm" and v.Name ~= "Right Arm" and v.Name ~= "FRAG" then
							for k1, v1 in pairs(v:GetChildren()) do
								
								v1.Color = menu:GetVal("Visuals", "Local Visuals", "Weapon Chams", "color1", true)
								
								if v1.Transparency ~= 1 then
									v1.Transparency = 0.99999 + (menu:GetVal("Visuals", "Local Visuals", "Weapon Chams", "color1")[4]/-255) --- it works shut up + i don't wanna make a fucking table for this shit
								end
								
								if menu:GetVal("Visuals", "Local Visuals", "Remove Weapon Skin") then
									for i2, v2 in pairs(v1:GetChildren()) do
										if v2.ClassName == "Texture" or v2.ClassName == "Decal" then
											v2:Destroy()
										end
									end
								end
								
								local mat = mats[menu:GetVal("Visuals", "Local Visuals", "Weapon Material")]
								v1.Material = mat
								
								if v1:IsA("UnionOperation") then
									v1.UsePartColor = true
								end
								
								if v1.ClassName == "MeshPart" then
									v1.TextureID = mat == "ForceField" and "rbxassetid://5843010904" or ""
								end
								
								if v1.Name == "LaserLight" then
									local transparency = 1+(menu:GetVal("Visuals", "Local Visuals", "Weapon Chams", "color2")[4]/-255)
									v1.Color = menu:GetVal("Visuals", "Local Visuals", "Weapon Chams", "color2", true)
									v1.Transparency = (transparency / 2) + 0.5
									v1.Material = "ForceField"
									
								elseif v1.Name == "SightMark" then
									if v1:FindFirstChild("SurfaceGui") then
										local color = menu:GetVal("Visuals", "Local Visuals", "Weapon Chams", "color2", true)
										local transparency = 1+(menu:GetVal("Visuals", "Local Visuals", "Weapon Chams", "color2")[4]/-255)
										v1.SurfaceGui.Border.Scope.ImageColor3 = color
										v1.SurfaceGui.Border.Scope.ImageTransparency = transparency
										if v1.SurfaceGui:FindFirstChild("Margins") then
											v1.SurfaceGui.Margins.BackgroundColor3 = color
											v1.SurfaceGui.Margins.ImageColor3 = color
											v1.SurfaceGui.Margins.ImageTransparency = (transparency/5) + 0.7
										elseif v1.SurfaceGui:FindFirstChild("Border") then
											v1.SurfaceGui.Border.BackgroundColor3 = color
											v1.SurfaceGui.Border.ImageColor3 = color
											v1.SurfaceGui.Border.ImageTransparency = 1
										end
									end
								end
							end
						end
					end
				end
			end)
			
			--debug.profileend("renderVisuals Local Visuals")
			
			
		end
		--debug.profileend("renderVisuals Main")
		--debug.profilebegin("renderVisuals No Scope")
		do -- no scope pasted from v1 lol
			local gui = LOCAL_PLAYER:FindFirstChild("PlayerGui")
			local frame = gui.MainGui:FindFirstChild("ScopeFrame")
			if menu:GetVal("Visuals", "Camera Visuals", "No Scope Border") and frame then
				if frame:FindFirstChild("SightRear") then
					for k,v in pairs(frame.SightRear:GetChildren()) do
						if v.ClassName == "Frame" then
							v.Visible = false
						end
					end
					frame.SightFront.Visible = false
					frame.SightRear.ImageTransparency = 1
				end
			elseif frame then
				if frame:FindFirstChild("SightRear") then
					for k,v in pairs(frame.SightRear:GetChildren()) do
						if v.ClassName == "Frame" then
							v.Visible = true
						end
					end
					frame.SightFront.Visible = true
					frame.SightRear.ImageTransparency = 0
				end
			end
		end
		--debug.profileend("renderVisuals No Scope")
	end
	
	menu.connections.deadbodychildadded = workspace.Ignore.DeadBody.ChildAdded:Connect(function(newchild)
		if menu:GetVal("Visuals", "Misc Visuals", "Ragdoll Chams") then
			local children = newchild:GetChildren()
			for i = 1, #children do
				local curvalue = children[i]
				if not curvalue:IsA("Model") and curvalue.Name ~= "Humanoid" then
					
					local matname = menu:GetVal("Visuals", "Misc Visuals", "Ragdoll Material")
					
					matname = mats[matname]
					
					curvalue.Material = Enum.Material[matname]
					
					curvalue.Color = menu:GetVal("Visuals", "Misc Visuals", "Ragdoll Chams", "color", true)
					local vertexcolor = Vector3.new(curvalue.Color.R, curvalue.Color.G, curvalue.Color.B)
					local mesh = curvalue:FindFirstChild("Mesh")
					if mesh then
						mesh.VertexColor = vertexcolor -- color da texture baby  ! ! ! ! ! 👶👶
					end
					
					if curvalue:IsA("Pants") then curvalue:Destroy() end
					
					if matname ~= "ForceField" then
						local pant = curvalue:FindFirstChild("Pant")
						if mesh then mesh:Destroy() end
						if pant then pant:Destroy() end
					end
				end
			end
		end
	end)
	local chat_game = LOCAL_PLAYER.PlayerGui.ChatGame
	local chat_box = chat_game:FindFirstChild("TextBox")
	local oldpos = nil
	menu.connections.keycheck = INPUT_SERVICE.InputBegan:Connect(function(key)
		if chat_box.Active then return end
		if menu:GetVal("Visuals", "Local Visuals", "Third Person") and key.KeyCode == menu:GetVal("Visuals", "Local Visuals", "Third Person", "keybind") then
			keybindtoggles.thirdperson = not keybindtoggles.thirdperson
		end
		if menu:GetVal("Misc", "Movement", "Fly") and key.KeyCode == menu:GetVal("Misc", "Movement", "Fly", "keybind") then
			keybindtoggles.flyhack = not keybindtoggles.flyhack
		end
		if menu:GetVal("Rage", "Extra", "Teleport Up") and key.KeyCode == menu:GetVal("Rage", "Extra", "Teleport Up", "keybind") and client.char.alive then
			setfpscap(8)
			wait()
			client.char.rootpart.Position += Vector3.new(0, 38, 0) -- frame tp cheat tp up 38 studs wtf'
			setfpscap(300)
			wait()
		end
		if menu:GetVal("Rage", "Anti Aim", "Noclip") and key.KeyCode == menu:GetVal("Rage", "Anti Aim", "Noclip", "keybind") and client.char.alive then
			local ray = Ray.new(client.char.head.Position, Vector3.new(0, -90, 0) * 20)
			
			local hit, hitpos = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Map})
			
			if hit ~= nil and (not hit.CanCollide) or hit.Name == "Window" then
				CreateNotification("Attempting to enable noclip... (you may die)")
				keybindtoggles.fakebody = not keybindtoggles.fakebody
				client.fakeoffset = 18
			else
				CreateNotification("Unable to noclip. Do this as soon as you spawn or over glass. (be as close to ground as possible for best results)")
			end
		end
		if shitting_my_pants == false and (menu:GetVal("Misc", "Exploits", "Vertical Floor Clip") and key.KeyCode == menu:GetVal("Misc", "Exploits", "Vertical Floor Clip", "keybind") and client.char.alive) then
			local sign = not menu:modkeydown("alt", "left")
			local ray = Ray.new(client.char.head.Position, Vector3.new(0, sign and -90 or 90, 0) * 20)
			
			local hit, hitpos = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Map})
			
			if hit ~= nil and (not hit.CanCollide) or hit.Name == "Window" then
				client.char.rootpart.Position += Vector3.new(0, sign and -18 or 18, 0)
				CreateNotification("Clipped " .. (sign and "down" or "up") .. "!")
			else
				CreateNotification("Unable to floor clip!")
			end
		else
			if shitting_my_pants == true then
				CreateNotification("You may not use this exploit while game administrators/moderators are in your server.")
			end
		end
	end)
	
	menu.connections.renderstepped_pf = game.RunService.RenderStepped:Connect(function()
		MouseUnlockAndShootHook()
		--debug.profilebegin("Main BB Loop")
		--debug.profilebegin("Noclip Cheat check")
		if not client.char.alive then
			if keybindtoggles.fakebody then
				keybindtoggles.fakebody = false
				CreateNotification("Noclip automatically disabled due to death")
				client.fakeoffset = 18
			end
		end
		--debug.profileend("Noclip Cheat check")
		
		--debug.profilebegin("BB Rendering")
		do --rendering
			renderVisuals()
			if menu.open then
				setconstant(client.cam.step, 11, menu:GetVal("Visuals", "Camera Visuals", "No Camera Bob") and 0 or 0.5)
			end
		end
		--debug.profileend("BB Rendering")
		--debug.profilebegin("BB Legitbot")
		do--legitbot
			legitbot:TriggerBot()
			legitbot:MainLoop()
		end
		--debug.profileend("BB Legitbot")
		--debug.profilebegin("BB Misc.")
		do --misc
			misc:MainLoop()
			--debug.profilebegin("BB Ragebot KnifeBot")
			ragebot:KnifeBotMain()
			--debug.profileend("BB Ragebot KnifeBot")
		end
		--debug.profileend("BB Misc.")
		if not menu:GetVal("Rage", "Extra", "Performance Mode") then
			--debug.profilebegin("BB Ragebot (Non Performance)")
			do--ragebot
				ragebot:MainLoop()
			end
			--debug.profileend("BB Ragebot (Non Performance)")
		end

		if menu.spectating and not client.cam:isspectating() then
			if client.menu.isdeployed() then
				client.cam:setfirstpersoncam()
			elseif client.cam.type ~= "menu" then
				local lobby = workspace:FindFirstChild("MenuLobby")
				if lobby then
					client.cam:setmenucam(lobby)
				else
					--client.menu:loadmenu()
				end
			end
			menu.spectating = false
		end

		--debug.profileend("Main BB Loop")
	end)
	
	CreateThread(function() -- ragebot performance
		while wait() do
			if not menu then return end
			renderChams()
			
			
			if menu:GetVal("Rage", "Extra", "Performance Mode") then
				do--ragebot
					ragebot:MainLoop()
				end
			end
		end
	end)

	menu.connections.heartbeat_pf = game.RunService.Heartbeat:Connect(function()

		-- print("incoming: ", stats.DataReceiveKbps)
		-- print("outgoing: ", stats.DataSendKbps)

		for index, nade in pairs(menu.activenades) do
			local nade_percent = (tick() - nade.start)/(nade.blowuptick - nade.start)
			if nade_percent >= 1 then
				if menu.activenades[index] == nade then
					table.remove(menu.activenades, index)
				end
			end
		end
		
		--debug.profilebegin("BB No Gun Bob or Sway")
		
		if client.char.alive then
			for id, gun in next, client.loadedguns do
				if not gun.fucku then
					for k,v in next, getupvalues(gun.step) do
						if type(v) == "function" and getinfo(v).name:match("bob") then
							gun.fucku = true
							setupvalue(client.loadedguns[id].step, k, function(...)
								return (menu and menu:GetVal("Visuals", "Camera Visuals", "No Gun Bob or Sway")) and CFrame.new() or v(...)
							end)
						end
					end
				end
			end
			
			if client.logic.currentgun.type == "KNIFE" and not client.logic.currentgun.fucku then
				for k,v in next, getupvalues(client.logic.currentgun.step) do
					if type(v) == "function" and getinfo(v).name:match("bob") then
						client.logic.currentgun.fucku = true
						setupvalue(client.logic.currentgun.step, k, function(...)
							return (menu and menu:GetVal("Visuals", "Camera Visuals", "No Gun Bob or Sway")) and CFrame.new() or v(...)
						end)
					end
				end
			end
		end
		
		--debug.profileend()
		
		if menu:GetVal("Visuals", "Local Visuals", "Third Person") and keybindtoggles.thirdperson then -- do third person model
			if client.char.alive then
				--debug.profilebegin("Third Person")
				if not client.fakecharacter then
					client.fakecharacter = true
					local localchar = LOCAL_PLAYER.Character:Clone()
					
					for k,v in next, localchar:GetChildren() do
						if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
							v.Transparency = 0
						end
					end
					
					localchar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					
					localchar.Parent = workspace["Ignore"]
					
					client.fakerootpart = localchar.HumanoidRootPart
					localchar.HumanoidRootPart.Anchored = true
					
					local torso = localchar.Torso
					client.fakeupdater.updatecharacter({
						head = localchar.Head,
						torso = torso,
						neck = torso.Neck,
						rsh = torso["Right Shoulder"],
						lsh = torso["Left Shoulder"],
						lhip = torso["Left Hip"],
						rhip = torso["Right Hip"],
						rarm = localchar["Right Arm"],
						larm = localchar["Left Arm"],
						rleg = localchar["Right Leg"],
						lleg = localchar["Left Leg"],
						rootpart = localchar.HumanoidRootPart,
						rootjoint = localchar.HumanoidRootPart.RootJoint,
						char = localchar
					})
					
					client.fakeupdater.setstance(client.char.movementmode)
					
					local guntoequip = client.logic.currentgun.type == "KNIFE" and client.loadedguns[1].name or client.logic.currentgun.name -- POOP
					client.fakeupdater.equip(require(game:service("ReplicatedStorage").GunModules[guntoequip]), game:service("ReplicatedStorage").ExternalModels[guntoequip]:Clone())
					client.fake3pchar = localchar
				else
					if not keybindtoggles.fakelag then
						local fakeupdater = client.fakeupdater
						fakeupdater.step(3, true)
						
						local lchams = menu:GetVal("Visuals", "Local Visuals", "Local Player Chams")
						if lchams then
							local lchamscolor = menu:GetVal("Visuals", "Local Visuals", "Local Player Chams", "color", true)
							
							local lchamsmat = mats[menu:GetVal("Visuals", "Local Visuals", "Local Player Material")]
							
							local curchildren = client.fake3pchar:GetChildren()
							
							for i = 1, #curchildren do
								local curvalue = curchildren[i]
								if curvalue:IsA("BasePart") and curvalue.Name ~= "HumanoidRootPart" then
									curvalue.Material = Enum.Material[lchamsmat]
									curvalue.Color = lchamscolor
								end
							end
						end
						
						if menu:GetVal("Rage", "Anti Aim", "Enabled") then
							local angles = "angles" -- TODO SOMEONE FIGURE OUT WHY REMOVING THIS LINE MAKES RAGEBOT.ANGLES NIL???????????????????
							fakeupdater.setlookangles(ragebot.angles)
							fakeupdater.setstance(ragebot.stance)
							fakeupdater.setsprint(ragebot.sprint)
						else
							local silentangles = ragebot.silentVector and Vector3.new(CFrame.new(Vector3.new(), ragebot.silentVector):ToOrientation()) or nil
							fakeupdater.setlookangles(silentangles or client.cam.angles) -- TODO make this face silent aim vector at some point lol
							fakeupdater.setstance(client.char.movementmode)
							fakeupdater.setsprint(client.char:sprinting())
						end
						if client.logic.currentgun then
							if client.logic.currentgun.type ~= "KNIFE" then
								local bool = client.logic.currentgun:isaiming()
								fakeupdater.setaim(bool)
								for k,v in next, client.fake3pchar:GetChildren() do -- this is probably going to cause a 1 fps drop or some shit lmao
									if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
										v.Transparency = bool and 0.6 or 0
									end
									if v:IsA("Model") then
										for k,v in next, v:GetChildren() do
											v.Transparency = bool and 0.6 or 0
										end
									end
								end
							end
						end
						
						-- 3 am already wtf 🌃
						
						if client.char.rootpart then
							client.fakerootpart.CFrame = client.char.rootpart.CFrame
							local rootpartpos = client.char.rootpart.Position
							client.fake_upvs[4].p = rootpartpos
							client.fake_upvs[4].t = rootpartpos
							client.fake_upvs[4].v = Vector3.new()
						end
					end
				end
				--debug.profileend("Third Person")
			end
		else
			if client.fakecharacter then
				client.fakecharacter = false
				--client.replication.removecharacterhash(client.fakeplayer)
				for k,v in next, client.fake3pchar:GetChildren() do
					if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
						v.Transparency = 1
					end
					if v:IsA("Model") then
						for k,v in next, v:GetChildren() do
							v.Transparency = 1
						end
					end
				end
			end
		end
	end)

	menu.Initialize({
		{
			name = "Legit",
			content = {
				{
					name = "Aim Assist",
					autopos = "left",
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = true
						},
						{
							type = "slider",
							name = "Aimbot FOV",
							value = 20,
							minvalue = 0.1,
							maxvalue = 180,
							stradd = "°",
							rounded = false
						},
						{
							type = "slider",
							name = "Smoothing",
							value = 20,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "slider",
							name = "Randomization",
							value = 5,
							minvalue = 0,
							maxvalue = 20,
							custom = {[0] = "Off"}
						},
						{
							type = "slider",
							name = "Deadzone FOV",
							value = 1,
							minvalue = 0,
							maxvalue = 50,
							stradd = "°",
							rounded = false,
							custom = {[0] = "Off"}
						},
						{
							type = "dropbox",
							name = "Aimbot Key",
							value = 1,
							values = {"Mouse 1", "Mouse 2", "Always"}
						},
						{
							type = "dropbox",
							name = "Hitscan Priority",
							value = 1,
							values = {"Head", "Body"}
						},
						{
							type = "combobox",
							name = "Hitboxes",
							values = {{"Head", true}, {"Body", true}, {"Arms", false}, {"Legs", false}}
						},
						{
							type = "toggle",
							name = "Adjust for Bullet Drop",
							value = false
						},
						{
							type = "slider",
							name = "Enlarge Enemy Hitboxes",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						}
					}
				},
				{
					name = "Trigger Bot",
					autopos = "right",
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = false,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.M,
							}
						},
						{
							type = "combobox",
							name = "Trigger Bot Hitboxes",
							values = {{"Head", true}, {"Body", true}, {"Arms", false}, {"Legs", false}}
						},
						{
							type = "toggle",
							name = "Trigger When Aiming",
							value = false
						},
						{
							type = "slider",
							name = "Aim Percentage",
							minvalue = 0,
							maxvalue = 100,
							value = 90,
							stradd = "%",
							rounded = false
						}
						--[[
						{
							type = "toggle",
							name = "Magnet Triggerbot",
							value = false
						},
						{
							type = "slider",
							name = "Magnet FOV",
							value = 80,
							minvalue = 0,
							maxvalue = 180,
							stradd = "°"
						},
						{
							type = "slider",
							name = "Magnet Smoothing Factor",
							value = 20,
							minvalue = 0,
							maxvalue = 50,
							stradd = "%"
						},
						{
							type = "dropbox",
							name = "Magnet Priority",
							value = 1,
							values = {"Head", "Body"}
						},]]
					}
				},
				{
					name = "Bullet Redirection",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Silent Aim",
							value = false
						},
						{
							type = "slider",
							name = "Silent Aim FOV",
							value = 5,
							minvalue = 0.1,
							maxvalue = 180,
							stradd = "°",
							rounded = false,
						},
						{
							type = "slider",
							name = "Hit Chance",
							value = 30,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "slider",
							name = "Accuracy",
							value = 90,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "dropbox",
							name = "Hitscan Priority",
							value = 1,
							values = {"Head", "Body", "Closest"}
						},
						{
							type = "combobox",
							name = "Hitboxes",
							values = {{"Head", true}, {"Body", true}, {"Arms", false}, {"Legs", false}}
						},
					}
				},
				{
					name = "Recoil Control",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Weapon RCS",
							value = false
						},
						{
							type = "slider",
							name = "Recoil Control X",
							value = 10,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "slider",
							name = "Recoil Control Y",
							value = 10,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
					}
				}
			}
		},
		{
			name = "Rage",
			content = {
				{
					name = "Aimbot",
					autopos = "left",
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = false,
							extra = {
								type = "keybind",
							},
							unsafe = true
						},
						{
							type = "toggle",
							name = "Silent Aim",
							value = false
						},
						{
							type = "toggle",
							name = "Rotate Viewmodel",
							value = false
						},
						{
							type = "slider",
							name = "Aimbot FOV",
							value = 180,
							minvalue = 0,
							maxvalue = 181,
							stradd = "°",
							custom = {[181] = "Ignored"}
						},
						{
							type = "toggle",
							name = "Auto Wall",
							value = false
						},
						{
							type = "toggle",
							name = "Auto Shoot",
							value = false
						},
						{
							type = "combobox",
							name = "Hitscan Points",
							values = {{"Head", true}, {"Body", true}, {"Arms", false}, {"Legs", false}}
						},
						{
							type = "dropbox",
							name = "Hitscan Priority",
							value = 1,
							values = {"Head", "Body"}
						},
						{
							type = "toggle",
							name = "Target Only Priority Players",
							value = false
						},
					},
				},
				{
					name = "Hack vs. Hack",
					autopos = "right",
					content = {
						{
							type = "toggle",
							name = "Extend Penetration",
							value = false
						},
						{
							type = "slider",
							name = "Extra Penetration",
							value = 11,
							minvalue = 1,
							maxvalue = 20,
							stradd = " studs"
						}, -- fuck u json
						{
							type = "toggle",
							name = "Autowall Resolver",
							value = false,
							unsafe = true
						},
						{
							type = "dropbox",
							name = "Resolver Type",
							value = 2,
							values = {"Cubic", "Axis Shifting", "Random", "Teleport", "Axis + Hitbox Shifting"}
						},
						{
							type = "slider",
							name = "Autowall Resolver Step",
							value = 50,
							minvalue = 5,
							maxvalue = 100,
							stradd = " studs"
						},
						{
							type = "toggle",
							name = "Force Player Stances",
							value = false
						},
						{
							type = "dropbox",
							name = "Stance Choice",
							value = 1,
							values = {"Stand", "Crouch", "Prone"}
						}
					}
				},
				{
					name = "Extra",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Knife Bot",
							value = false,
							extra = {
								type = "keybind",
							},
							unsafe = true
						},
						{
							type = "dropbox",
							name = "Knife Bot Type",
							value = 2,
							values = {"Assist", "Multi Aura", "Flight Aura"}
						},
						{
							type = "toggle",
							name = "Performance Mode",
							value = true
						},
						{
							type = "toggle",
							name = "Fake Lag",
							value = false
						},
						{
							type = "slider",
							name = "Fake Lag Amount",
							value = 1,
							minvalue = 1,
							maxvalue = 1000,
							stradd = " kbps"
						},
						{
							type = "slider",
							name = "Fake Lag Distance",
							value = 1,
							minvalue = 1,
							maxvalue = 40,
							stradd = " studs"
						},
						{
							type = "toggle",
							name = "Manual Choke",
							extra = {
								type = "keybind"
							}
						},
						{
							type = "toggle",
							name = "Release Packets on Shoot",
							value = false
						},
						{
							type = "toggle",
							name = "Teleport Up",
							value = false,
							extra = {
								type = "keybind"
							}
						}
					},
				},
				{
					name = "Anti Aim",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = false,
							extra = {
								type = "keybind"
							},
						},
						{
							type = "dropbox",
							name = "Pitch",
							value = 4,
							values = {"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random", "Bob", "Glitch"}
						},
						{
							type = "dropbox",
							name = "Yaw",
							value = 2,
							values = {"Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin"}
						},
						{
							type = "slider",
							name = "Spin Rate",
							value = 10,
							minvalue = -100,
							maxvalue = 100,
							stradd = "°/s"
						},
						{
							type = "dropbox",
							name = "Force Stance",
							value = 4,
							values = {"Off", "Stand", "Crouch", "Prone"}
						},
						{
							type = "toggle",
							name = "Hide in Floor",
							value = true,
						},
						{
							type = "toggle",
							name = "Lower Arms",
							value = false,
						},
						{
							type = "toggle",
							name = "Tilt Neck",
							value = false
						},
						{
							type = "toggle",
							name = "Noclip",
							value = false,
							extra = {
								type = "keybind",
								key = nil
							},
							unsafe = true
						}
					}
				},
			}
		},
		{
			name = "ESP",
			content = {
				{
					name = "Enemy ESP",
					autopos = "left",
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = true
						},
						{
							type = "toggle",
							name = "Name",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Enemy Name",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Box",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Enemy Box",
								color = {255, 0, 0, 130}
							}
						},
						{
							type = "toggle",
							name = "Health Bar",
							value = true,
							extra = {
								type = "double colorpicker",
								name = {"Enemy Low Health", "Enemy Max Health"},
								color = {{255, 0, 0}, {0, 255, 0}}
							}
						},
						{
							type = "toggle",
							name = "Health Number",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Enemy Health Number",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Held Weapon",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Enemy Held Weapon",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Distance",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Enemy Distance",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Chams",
							value = true,
							extra = {
								type = "double colorpicker",
								name = {"Visible Enemy Chams", "Invisible Enemy Chams"},
								color = {{255, 0, 0, 200}, {100, 0, 0, 100}}
							}
						},
						{
							type = "toggle",
							name = "Skeleton",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Enemy skeleton",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Out of View",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Arrow Color",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "slider",
							name = "Arrow Distance",
							value = 50,
							minvalue = 10,
							maxvalue = 100,
							stradd = "%",
						},
						{
							type = "toggle",
							name = "Dynamic Arrow Size",
							value = true
						},
					}
				},
				{
					name = "Team ESP",
					autopos = "right",
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = true
						},
						{
							type = "toggle",
							name = "Name",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Team Name",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Box",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Team Box",
								color = {0, 255, 0, 255}
							}
						},
						{
							type = "toggle",
							name = "Health Bar",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Team Low Health", "Team Max Health"},
								color = {{255, 0, 0}, {0, 255, 0}}
							}
						},
						{
							type = "toggle",
							name = "Health Number",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Team Health Number",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Held Weapon",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Team Held Weapon",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Distance",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Team Distance",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Chams",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Visible Team Chams", "Invisible Team Chams"},
								color = {{0, 255, 0, 200}, {0, 100, 0, 100}}
							}
						},
						{
							type = "toggle",
							name = "Skeleton",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Team skeleton",
								color = {255, 255, 255, 255}
							}
						},
					}
				},
				{
					name = "ESP Settings",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "slider",
							name = "Max HP Visibility Cap",
							value = 90,
							minvalue = 50,
							maxvalue = 100,
							stradd = "hp"
						},
						{
							type = "dropbox",
							name = "Text Case",
							value = 2,
							values = {"lowercase", "Normal", "UPPERCASE"}
						},
						{
							type = "slider",
							name = "Max Text Length",
							value = 0,
							minvalue = 0,
							maxvalue = 32,
							custom = {[0] = "Unlimited"}
						},
						{
							type = "toggle",
							name = "Highlight Aimbot Target",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Aimbot Target",
								color = {255, 0, 0, 255}
							}
						},
						{
							type = "toggle",
							name = "Highlight Friends",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Friended Players",
								color = {0, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Highlight Priority",
							value = true,
							extra = {
								type = "single colorpicker",
								name = "Priority Players",
								color = {255, 210, 0, 255}
							}
						},
						
					}
				},
				{
					name = "Dropped ESP",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Weapon Name",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Weapon Name",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Weapon Ammo",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Weapon Ammo",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Nade Warning",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Slider Color",
								color = {68, 92, 227},
							}
						},
						{
							type = "toggle",
							name = "Grenade ESP",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Inner Color", "Outer Color"},
								color = {{195, 163, 255}, {123, 69, 224}},
							}
						},
					}
				},
			}
		},
		{
			name = "Visuals",
			content = {
				{
					name = "Local Visuals",
					autopos = "left",
					autofill = false,
					content = {
						{
							type = "toggle",
							name = "Arm Chams",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Sleeve Color", "Hand Color"},
								color = {{106, 136, 213, 255}, {181, 179, 253, 255}}
							}
						},
						{
							type = "dropbox",
							name = "Arm Material",
							value = 1,
							values = {"Plastic", "Ghost", "Neon", "Foil", "Glass"}
						},
						{
							type = "toggle",
							name = "Weapon Chams",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Weapon Color", "Lazer Color"},
								color = {{106, 136, 213, 255}, {181, 179, 253, 255}}
							}
						},
						{
							type = "dropbox",
							name = "Weapon Material",
							value = 1,
							values = {"Plastic", "Ghost", "Neon", "Foil", "Glass"}
						},
						{
							type = "toggle",
							name = "Remove Weapon Skin",
							value = false,
						},
						{
							type = "toggle",
							name = "Third Person",
							value = false,
							extra = {
								type = "keybind",
								key = nil
							}
						},
						{
							type = "slider",
							name = "Third Person Distance",
							value = 60,
							minvalue = 1,
							maxvalue = 150,
						},
						{
							type = "toggle",
							name = "Local Player Chams",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Local Player Chams",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "dropbox",
							name = "Local Player Material",
							value = 1,
							values = {"Plastic", "Ghost", "Neon", "Foil", "Glass"}
						},
						
					}
				},
				{
					name = "Camera Visuals",
					autopos = "right",
					content = {
						{
							type = "slider",
							name = "Camera FOV",
							value = 85,
							minvalue = 60,
							maxvalue = 120,
							stradd = "°"
						},
						{
							type = "toggle",
							name = "No Camera Bob",
							value = false
						},
						{
							type = "toggle",
							name = "No Scope Sway",
							value = false
						},
						{
							type = "toggle",
							name = "Disable ADS FOV",
							value = false,
						},
						{
							type = "toggle",
							name = "No Scope Border",
							value = false,
						},
						{
							type = "toggle",
							name = "No Visual Suppression",
							value = false,
						},
						{
							type = "toggle",
							name = "No Gun Bob or Sway",
							value = false
						},
						{
							type = "toggle",
							name = "Reduce Camera Recoil",
							value = false
						},
						{
							type = "slider",
							name = "Camera Recoil Reduction",
							value = 10,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "toggle",
							name = "Show Sliding",
							value = false
						}
					}
				},
				{
					name = "World Visuals",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Ambience",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Inside Ambience", "Outside Ambience"},
								color = {{255, 255, 255}, {255, 255, 255}}
							}
						},
						{
							type = "toggle",
							name = "Force Time",
							value = false
						},
						{
							type = "slider",
							name = "Custom Time",
							value = 0,
							minvalue = 0,
							maxvalue = 24,
							rounded = false
						},
						{
							type = "toggle",
							name = "Custom Saturation",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Saturation Tint",
								color = {255, 255, 255}
							}
						},
						{
							type = "slider",
							name = "Saturation Density",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%",
						},
					}
				},
				{
					name = "Misc Visuals",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Crosshair Color",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Inline", "Outline"},
								color = {{127, 72, 163}, {25, 25, 25}}
							}
						},
						{
							type = "toggle",
							name = "Ragdoll Chams",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Ragdoll Chams",
								color = {255, 255, 255, 255}
							},
						},
						{
							type = "dropbox",
							name = "Ragdoll Material",
							value = 1,
							values = {"Plastic", "Ghost", "Neon", "Foil", "Glass"}
						},
						{
							type = "toggle",
							name = "Bullet Tracers",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Bullet Tracers",
								color = {255, 255, 255, 255}
							},
						},
					}
				}
			}
		},
		{
			name = "Misc",
			content = {
				{
					name = "Movement",
					autopos = "left",
					content = {
						{
							type = "toggle",
							name = "Fly",
							value = false,
							unsafe = true,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.B
							}
						},
						{
							type = "slider",
							name = "Fly Speed",
							value = 70,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s"
						},
						{
							type = "toggle",
							name = "Auto Jump",
							value = false
						},
						{
							type = "toggle",
							name = "Speed Hack",
							value = false,
							unsafe = true,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.N
							}
						},
						{
							type = "dropbox",
							name = "Speed Type",
							value = 1,
							values = {"Always", "In Air", "On Hop"}
						},
						{
							type = "slider",
							name = "Speed Factor",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s"
						},
						{
							type = "toggle",
							name = "Circle Strafe",
							value = false,
							extra = {
								type = "keybind"
							}
						},
						{
							type = "toggle",
							name = "Gravity Shift",
							value = false
						},
						{
							type = "slider",
							name = "Gravity Shift Percentage",
							value = -50,
							minvalue = -100,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "toggle",
							name = "Prevent Fall Damage",
							value = false
						},
						{
							type = "toggle",
							name = "Ignore Round Freeze",
							value = false,
							unsafe = true
						}
					},
				},
				{
					name = "Extra",
					autopos = "right",
					content = {
						{
							type = "toggle",
							name = "Suppress Only",
							value = false
						},
						{
							type = "toggle",
							name = "Auto Vote",
							value = false
						},
						{
							type = "dropbox",
							name = "Vote Friends",
							value = 1,
							values = {"Off", "Yes", "No"}
						},
						{
							type = "dropbox",
							name = "Vote Priority",
							value = 1,
							values = {"Off", "Yes", "No"}
						},
						{
							type = "dropbox",
							name = "Default Vote",
							value = 1,
							values = {"Off", "Yes", "No"}
						},
						{
							type = "toggle",
							name = "Kill Sound",
							value = false
						},
						{
							type = "dropbox",
							name = "Chat Spam",
							value = 1,
							values = {"Off", "Original", "t0nymode", "Chinese Propaganda", "Emojis", "Deluxe", "Youtube Title", "Custom", "Custom Combination"}
						},
						{
							type = "toggle",
							name = "Chat Spam Repeat",
							value = false
						},
						{
							type = "slider",
							name = "Chat Spam Delay",
							minvalue = 1,
							maxvalue = 10,
							value = 5,
							stradd = " seconds"
						},
						{
							type = "toggle",
							name = "Auto Martyrdom",
							value = false
						},
					}
				},
				{
					name = "Exploits",
					autopos = "left",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Invisibility",
							extra = {
								type = "keybind"
							}
						},
						{
							type = "toggle",
							name = "Super Invisibility",
							value = false,
							extra = {
								type = "keybind"
							}
						},
						{
							type = "button",
							name = "Crash Server",
							doubleclick = true,
						},
						{
							type = "toggle",
							name = "Rapid Kill",
							value = false,
							extra = {
								type = "keybind"
							}
						},
						{
							type = "toggle",
							name = "Grenade Teleport",
							value = false
						},
						{
							type = "toggle",
							name = "Freeze Players",
							value = false,
							extra = {
								type = "keybind"
							},
							unsafe = true
						},
						{
							type = "toggle",
							name = "Vertical Floor Clip",
							value = false,
							extra = {
								type = "keybind"
							}
						},
						{
							type = "toggle",
							name = "Fake Equip",
							value = false
						},
						{
							type = "dropbox",
							name = "Fake Slot",
							values = {"Primary", "Secondary", "Melee"},
							value = 1
						}
					}
				},
				{
					name = "Weapon Modifications",
					autopos = "right",
					autofill = true,
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = false
						},
						{
							type = "slider",
							name = "Fire Rate Scale",
							value = 150,
							minvalue = 50,
							maxvalue = 500,
							stradd = "%"
						},
						{
							type = "slider",
							name = "Recoil Scale",
							value = 10,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%",
						},
						{
							type = "toggle",
							name = "Remove Animations",
							value = true
						},
						{
							type = "toggle",
							name = "Instant Equip",
							value = true
						},
						{
							type = "toggle",
							name = "Fully Automatic",
							value = true
						},
						{
							type = "toggle",
							name = "Run and Gun",
							value = false
						},
						{
							type = "toggle",
							name = "Edit Bullet Speed",
							value = false
						},
						{
							type = "slider",
							name = "Bullet Speed",
							value = 6000,
							minvalue = 80,
							maxvalue = 200000,
							stradd = " studs",
							stepsize = 100
						}
					},
				},
			}
		},
		{
			name = "Settings",
			content = {
				{
					name = "Player List",
					x = menu.columns.left,
					y = 66,
					width = 466,
					height = 328,
					content = {
						{
							type = "list",
							name = "Players",
							multiname = {"Name", "Team", "Status"},
							size = 9,
							colums = 3
						},
						{
							type = "image",
							name = "Player Info",
							text = "No Player Selected",
							size = 72
						},
						{
							type = "dropbox",
							name = "Player Status",
							x = 307,
							y = 314,
							w = 160,
							value = 1,
							values = {"None", "Friend", "Priority"}
						},
						{
							type = "button",
							name = "Votekick",
							doubleclick = true,
							x = 307,
							y = 356,
							w = 76,
						},
						{
							type = "button",
							name = "Spectate",
							x = 391,
							y = 356,
							w = 76,
						},
					}
				},
				{
					name = "Menu Settings",
					x = menu.columns.left,
					y = 400,
					width = menu.columns.width,
					height = 108,
					content = {
						{
							type = "toggle",
							name = "Menu Accent",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Accent Color",
								color = {127, 72, 163}
							}
						},
						{
							type = "toggle",
							name = "Watermark",
							value = true,
						},
						{
							type = "toggle",
							name = "Custom Menu Name",
							value = MenuName and true or false,
						},
						{
							type = "textbox",
							name = "MenuName",
							text = MenuName or "Bitch Bot"
						}
					}
				},
				{
					name = "Extra",
					x = menu.columns.left,
					y = 514,
					width = menu.columns.width,
					height = 119,
					content = {
						{
							type = "button",
							name = "Set Clipboard Game ID",
						},
						{
							type = "button",
							name = "Unload Cheat",
							doubleclick = true,
						},
						{
							type = "toggle",
							name = "Allow Unsafe Features",
							value = false,
						},
					}
				},
				{
					name = "Configuration",
					x = menu.columns.right,
					y = 400,
					width = menu.columns.width,
					height = 233,
					content = {
						{
							type = "textbox",
							name = "ConfigName",
							text = ""
						},
						{
							type = "dropbox",
							name = "Configs",
							value = 1,
							values = GetConfigs()
						},
						{
							type = "button",
							name = "Load Config",
							doubleclick = true,
						},
						{
							type = "button",
							name = "Save Config",
							doubleclick = true,
						},
						{
							type = "button",
							name = "Delete Config",
							doubleclick = true,
						},
					}
				}
			}
		},
	})
	do

		local plistinfo = menu.options["Settings"]["Player List"]["Player Info"][1]
		local plist = menu.options["Settings"]["Player List"]["Players"]
		local function updateplist()
			if not menu then return end
			local playerlistval = menu:GetVal("Settings", "Player List", "Players")
			local players = {}
			
			for i, team in pairs(TEAMS:GetTeams()) do
				local sorted_players = {}
				for i1, player in pairs(team:GetPlayers()) do
					table.insert(sorted_players, player.Name)
				end
				table.sort(sorted_players) -- why the fuck doesn't this shit work ...
				for i1, player_name in pairs(sorted_players) do
					table.insert(players, Players:FindFirstChild(player_name))
				end
			end
			local templist = {}
			for k, v in ipairs(players) do
				local plyrname = {v.Name, RGB(255, 255, 255)}
				local teamtext = {"None", RGB(255, 255, 255)}
				local plyrstatus = {"None", RGB(255, 255, 255)}
				if v.Team ~= nil then
					teamtext[1] = v.Team.Name
					teamtext[2] = v.TeamColor.Color
				end
				if v == LOCAL_PLAYER then
					plyrstatus[1] = "Local Player"
					plyrstatus[2] = RGB(66, 135, 245)
				elseif table.find(menu.friends, v.Name) then
					plyrstatus[1] = "Friend"
					plyrstatus[2] = RGB(0, 255, 0)
				elseif table.find(menu.priority, v.Name) then
					plyrstatus[1] = "Priority"
					plyrstatus[2] = RGB(255, 210, 0)
				end
				
				table.insert(templist, {plyrname, teamtext, plyrstatus})
			end
			plist[5] = templist
			if playerlistval ~= nil then
				for i, v in ipairs(players) do
					if v.Name == playerlistval then
						selectedPlayer = v
						break
					end
					if i == #players then
						selectedPlayer = nil
						menu.list.setval(plist, nil)
					end
				end
			end
			menu:SetMenuPos(menu.x, menu.y)
		end
		
		local function setplistinfo(player, textonly)
			if player ~= nil then
				local playerteam = "None"
				if player.Team ~= nil then
					playerteam = player.Team.Name
				end
				local playerhealth = "?"
				
				
				local alive = client.hud:isplayeralive(player)
				if alive then
					playerhealth = math.ceil(client.hud:getplayerhealth(player))
				else
					playerhealth = "Dead"
				end
				local playerdata = teamdata[1]:FindFirstChild(player.Name) or teamdata[2]:FindFirstChild(player.Name)
				local playerrank = playerdata.Rank.Text
				local kills = playerdata.Kills.Text
				local deaths = playerdata.Deaths.Text
				plistinfo[1].Text = string.format([[
Name: %s
Health: %s
Rank: %d
K/D: %d/%d
				]], player.Name, tostring(playerhealth), playerrank, kills, deaths)
				if textonly == nil then
					plistinfo[2].Data = BBOT_IMAGES[5]
					plistinfo[2].Data = game:HttpGet(Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100))
				end
			else
				plistinfo[2].Data = BBOT_IMAGES[5]
				plistinfo[1].Text = "No Player Selected"
			end
		end
		
		
		
		menu.list.removeall(menu.options["Settings"]["Player List"]["Players"])
		updateplist()
		setplistinfo()
		
		local oldslectedplyr = nil
		menu.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if menu.tabnames[menu.activetab] == "Settings" and menu.open then
					game.RunService.Stepped:wait()
					
					updateplist()
					
					if selectedPlayer ~= nil then
						--print(LOCAL_MOUSE.x - menu.x, LOCAL_MOUSE.y - menu.y)
						if menu:MouseInMenu(28, 68, 448, 238) then
							if table.find(menu.friends, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 2
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Friend"
							elseif table.find(menu.priority, selectedPlayer.Name) then
								menu.options["Settings"]["Player List"]["Player Status"][1] = 3
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "Priority"
							else
								menu.options["Settings"]["Player List"]["Player Status"][1] = 1
								menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
							end
						end
						
						for k, table_ in pairs({menu.friends, menu.priority}) do
							for index, plyrname in pairs(table_) do
								if selectedPlayer.Name == plyrname then
									table.remove(table_, index)
								end
							end
						end
						if menu:GetVal("Settings", "Player List", "Player Status") == 2 then
							if not table.find(menu.friends, selectedPlayer.Name) then
								table.insert(menu.friends, selectedPlayer.Name)
								WriteRelations()
							end
						elseif menu:GetVal("Settings", "Player List", "Player Status") == 3 then
							if not table.find(menu.priority, selectedPlayer.Name) then
								table.insert(menu.priority, selectedPlayer.Name)
								WriteRelations()
							end
						end
					else
						menu.options["Settings"]["Player List"]["Player Status"][1] = 1
						menu.options["Settings"]["Player List"]["Player Status"][4][1].Text = "None"
					end
					
					updateplist()
					
					if plist[1] ~= nil then
						if oldslectedplyr ~= selectedPlayer then
							setplistinfo(selectedPlayer)
							oldslectedplyr = selectedPlayer
						end
					else
						setplistinfo(nil)
					end
					
				end
			end
		end)
		
		menu.connections.renderstepped2 = game.RunService.RenderStepped:Connect(function()
			if menu.open then
				if menu.tabnames[menu.activetab] == "Settings" then
					if plist[1] ~= nil then
						setplistinfo(selectedPlayer, true)
					end
				end
			end
		end)
		
		menu.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
			updateplist()
			if plist[1] ~= nil then
				setplistinfo(selectedPlayer)
			else
				setplistinfo(nil)
			end
		end)
		
		menu.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
			updateplist()
			repupdates[player] = nil
		end)
	end
end --!SECTION PF END
end
end

do
	local wm = menu.watermark
	wm.textString = " | Dev Build | " .. os.date("%b. %d, %Y")
	wm.pos = Vector2.new(50, 9)
	wm.text = {}
	local fulltext = "Bitch Bot".. wm.textString 
	wm.width = (#fulltext) * 7 + 10
	wm.height = 19
	wm.rect = {}
	
	Draw:FilledRect(false, wm.pos.x, wm.pos.y + 1, wm.width, 2, {menu.mc[1] - 40, menu.mc[2] - 40, menu.mc[3] - 40, 255}, wm.rect)
	Draw:FilledRect(false, wm.pos.x, wm.pos.y, wm.width, 2, {menu.mc[1], menu.mc[2], menu.mc[3], 255}, wm.rect)
	Draw:FilledRect(false, wm.pos.x, wm.pos.y + 3, wm.width, wm.height-5, {50, 50, 50, 255}, wm.rect)
	for i = 0, wm.height-4 do
		Draw:FilledRect(false, wm.pos.x, wm.pos.y + 3 + i, wm.width, 1, {50 - i * 1.7, 50 - i * 1.7, 50 - i * 1.7, 255}, wm.rect)
	end
	Draw:OutlinedRect(false, wm.pos.x, wm.pos.y, wm.width, wm.height, {0, 0, 0, 255}, wm.rect)
	Draw:OutlinedText(fulltext, 2, false, wm.pos.x + 5, wm.pos.y + 3, 13, false, {255, 255, 255, 255}, {0, 0, 0, 255}, wm.text)
end
--ANCHOR watermak
for k, v in pairs(menu.watermark.rect) do
	v.Visible = true
end
menu.watermark.text[1].Visible = true

local textbox = menu.options["Settings"]["Configuration"]["ConfigName"]
local relconfigs = GetConfigs()
textbox[1] = relconfigs[menu.options["Settings"]["Configuration"]["Configs"][1]]
textbox[4].Text = textbox[1]

menu.load_time = math.floor((tick() - loadstart) * 1000)
CreateNotification(string.format("Done loading the ".. menu.game.. " cheat. (%d ms)", menu.load_time))
CreateNotification("Press DELETE to open and close the menu!")

loadingthing.Visible = false -- i do it this way because otherwise it would fuck up the Draw:UnRender function, it doesnt cause any lag sooooo
if not menu.open then
	menu.fading = true
	menu.fadestart = tick()
end

menu.Initialize = nil -- let me freeeeee
-- not lettin u free asshole bitch
-- i meant the program memory, alan...............  fuckyouAlan_iHateYOU from v1
-- im changing all the var names that had typos by me back to what they were now because of this.... enjoy hieght....
-- wut