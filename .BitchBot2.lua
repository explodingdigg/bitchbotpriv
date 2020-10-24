local mp = { -- this is for menu stuffs n shi
	w = 500,
	h = 600,
	x = 200,
	y = 300,
	columns = {
		width = 230,
		left = 17,
		right = 253
	},
	activetab = 1, -- do not change this value please its not made to be fucked with sorry
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
	game = "uni",
	tabnum2str = {} -- its used to change the tab num to the string (did it like this so its dynamic if u add or remove tabs or whatever :D)
}




function CreateThread(func) 
   local thread = coroutine.create(func)
   coroutine.resume(thread)
   return thread
end

function MultiThreadList(obj)
	for i, v in pairs(obj) do
		CreateThread(v)
	end
end


local BBOT_IMAGES = {}
MultiThreadList({
	function() BBOT_IMAGES[1] = game:HttpGet("https://i.imgur.com/9NMuFcQ.png") end,
	function() BBOT_IMAGES[2] = game:HttpGet("https://i.imgur.com/jG3NjxN.png") end,
	function() BBOT_IMAGES[3] = game:HttpGet("https://i.imgur.com/2Ty4u2O.png") end,
	function() BBOT_IMAGES[4] = game:HttpGet("https://i.imgur.com/kNGuTlj.png") end,
	function() BBOT_IMAGES[5] = game:HttpGet("https://i.imgur.com/OZUR3EY.png") end
})

-- MULTITHREAD DAT LOADING SO FAST!!!!
do 
	local function Loopy_Image_Checky()
		for i = 1, 5 do
			local v = BBOT_IMAGES[i]
			if v == nil then 
				
				return true 
			end
		end
		return false
	end 
	while Loopy_Image_Checky() do
		wait(0)
	end

end
if game.PlaceId == 292439477 or game.PlaceId == 299659045 then
	mp.game = "pf"
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
			game.RunService.Heartbeat:wait()
		until net and not net.add
	end -- wait for framwork to load
end

-- nate i miss u D:

-- im back

game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)

setfpscap(300) -- nigga roblox

if not isfolder("bitchbot") then
	makefolder("bitchbot")
end

if not isfolder("bitchbot/pf") then
	makefolder("bitchbot/".. mp.game)
end

for i = 1, 6 do
	if not isfile("bitchbot/".. mp.game .."/config"..tostring(i)..".bb") then
		writefile("bitchbot/".. mp.game .."/config"..tostring(i)..".bb", "")
	end
end

local Players = game:GetService("Players")
local LOCAL_PLAYER = Players.LocalPlayer
local LOCAL_MOUSE = LOCAL_PLAYER:GetMouse()
local INPUT_SERVICE = game:GetService("UserInputService")
local GAME_SETTINGS = UserSettings():GetService("UserGameSettings")
local CACHED_VEC3 = Vector3.new()
local Camera = workspace.CurrentCamera

do -- table shitz
	setreadonly(table, false)

	table.contains = function(table, element)
		for _, value in pairs(table) do
			if value == element then
				return true
			end
		end
		return false
	end

	setreadonly(table, true)
end

do -- math stuffz
	setreadonly(math, false)

	math.map = function(X, A, B, C, D)
		return (X-A)/(B-A) * (D-C) + C
	end

	math.clamp = function(a, lowerNum, higher)
		if a > higher then
			return higher
		elseif a < lowerNum then
			return lowerNum
		else
			return a
		end
	end

	math.Lerp = function(delta, from, to)
		if (delta > 1) then
			return to
		end
		if (delta < 0) then
			return from
		end
		return from + ( to - from ) * delta
	end

	math.ColorRange = function(value, ranges) -- ty tony for dis function u a homie
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
		return Color3.new(math.Lerp( lerpValue, minColor.color.r, maxColor.color.r ), math.Lerp( lerpValue, minColor.color.g, maxColor.color.g ), math.Lerp( lerpValue, minColor.color.b, maxColor.color.b ))
	end

	setreadonly(math, true)
end

do -- metatable additions strings and such

	local strMt = getrawmetatable("")

	strMt.__mul = function(s1, num)
		return string.rep(s1, num)
	end
	strMt.__sub = function(s1, num)
		return string.sub(s1, 1, #s1-num)
	end

	function string_cut(s1, num)
		return num == 0 and s1 or string.sub(s1, 1, num)
	end

end

local keynamereturn = {
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
	Semicolon = ":",
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

local function keyenum2name(key) -- did this all in a function cuz why not
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

	for k, v in pairs(keynamereturn) do
		if keynamereturn[keyname] then
			return keynamereturn[keyname]
		end
	end
	return keyname
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
	function Draw:OutlinedRect(visible, pos_x, pos_y, width, hieght, clr, tablename)
		local temptable = Drawing.new("Square")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, hieght)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Filled = false
		temptable.Thickness = 0
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.contains(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:FilledRect(visible, pos_x, pos_y, width, hieght, clr, tablename)
		local temptable = Drawing.new("Square")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, hieght)
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Filled = true
		temptable.Thickness = 0
		temptable.Transparency = clr[4] / 255
		table.insert(tablename, temptable)
		if not table.contains(allrender, tablename) then
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
		if not table.contains(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:Image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
		local temptable = Drawing.new("Image")
		temptable.Visible = visible
		temptable.Position = Vector2.new(pos_x, pos_y)
		temptable.Size = Vector2.new(width, hieght)
		temptable.Transparency = transparency
		temptable.Data = imagedata
		table.insert(tablename, temptable)
		if not table.contains(allrender, tablename) then
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
		if not table.contains(allrender, tablename) then
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
		table.insert(tablename, temptable)
		if not table.contains(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:Triangle(visible, filled, pa, pb, pc, clr, tablename)
		local temptable = Drawing.new("Triangle")
		temptable.Visible = visible
		temptable.Transparency = clr[4]
		temptable.Color = RGB(clr[1], clr[2], clr[3])
		temptable.Thickness = 4.1
		temptable.PointA = Vector2.new(pa[1], pa[2])
		temptable.PointB = Vector2.new(pb[1], pb[2])
		temptable.PointC = Vector2.new(pc[1], pc[2])
		temptable.Filled = filled
		table.insert(tablename, temptable)
		if not table.contains(allrender, tablename) then
			table.insert(allrender, tablename)
		end
	end

	function Draw:MenuOutlinedRect(visible, pos_x, pos_y, width, hieght, clr, tablename)
		Draw:OutlinedRect(visible, pos_x + mp.x, pos_y + mp.y, width, hieght, clr, tablename)
		table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	function Draw:MenuFilledRect(visible, pos_x, pos_y, width, hieght, clr, tablename)
		Draw:FilledRect(visible, pos_x + mp.x, pos_y + mp.y, width, hieght, clr, tablename)
		table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	function Draw:MenuImage(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
		Draw:Image(visible, imagedata, pos_x + mp.x, pos_y + mp.y, width, hieght, transparency, tablename)
		table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	function Draw:MenuBigText(text, visible, centered, pos_x, pos_y, tablename)
		Draw:OutlinedText(text, 2, visible, pos_x + mp.x, pos_y + mp.y, 13, centered, {255, 255, 255, 255}, {0, 0, 0}, tablename)
		table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
	end
end



local function BBMenuInit(menutable)
	local bbmenu = {} -- this one is for the rendering n shi
	do
		Draw:MenuOutlinedRect(true, 0, 0, mp.w, mp.h, {0, 0, 0, 255}, bbmenu)  -- first gradent or whatever
		Draw:MenuOutlinedRect(true, 1, 1, mp.w - 2, mp.h - 2, {20, 20, 20, 255}, bbmenu)
		Draw:MenuOutlinedRect(true, 2, 2, mp.w - 3, 1, {127, 72, 163, 255}, bbmenu)
		table.insert(mp.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 3, mp.w - 3, 1, {87, 32, 123, 255}, bbmenu)
		table.insert(mp.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 4, mp.w - 3, 1, {20, 20, 20, 255}, bbmenu)

		for i = 0, 19 do
			Draw:MenuFilledRect(true, 2, 5 + i, mp.w - 4, 1, {20, 20, 20, 255}, bbmenu)
			bbmenu[6 + i].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 20, color = RGB(35, 35, 35)}})
		end
		Draw:MenuFilledRect(true, 2, 25, mp.w - 4, mp.h - 27, {35, 35, 35, 255}, bbmenu)

		Draw:MenuBigText("BitchBot", true, false, 6, 6, bbmenu)

		Draw:MenuOutlinedRect(true, 8, 22, mp.w - 16, mp.h - 30, {0, 0, 0, 255}, bbmenu)    -- all this shit does the 2nd gradent
		Draw:MenuOutlinedRect(true, 9, 23, mp.w - 18, mp.h - 32, {20, 20, 20, 255}, bbmenu)
		Draw:MenuOutlinedRect(true, 10, 24, mp.w - 19, 1, {127, 72, 163, 255}, bbmenu)
		table.insert(mp.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 10, 25, mp.w - 19, 1, {87, 32, 123, 255}, bbmenu)
		table.insert(mp.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 10, 26, mp.w - 19, 1, {20, 20, 20, 255}, bbmenu)

		for i = 0, 14 do
			Draw:MenuFilledRect(true, 10, 27 + (i * 2), mp.w - 20, 2, {45, 45, 45, 255}, bbmenu)
			bbmenu[#bbmenu].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 15, color = RGB(35, 35, 35)}})
		end
		Draw:MenuFilledRect(true, 10, 57, mp.w - 20, mp.h - 67, {35, 35, 35, 255}, bbmenu)
		function Draw:CoolBox(name, x, y, width, height, tab)
			Draw:MenuOutlinedRect(true, x, y, width, height, {0, 0, 0, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 1, y + 1, width - 2, height - 2, {20, 20, 20, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 2, y + 2, width - 3, 1, {127, 72, 163, 255}, tab)
			table.insert(mp.clrs.norm, tab[#tab])
			Draw:MenuOutlinedRect(true, x + 2, y + 3, width - 3, 1, {87, 32, 123, 255}, tab)
			table.insert(mp.clrs.dark, tab[#tab])
			Draw:MenuOutlinedRect(true, x + 2, y + 4, width - 3, 1, {20, 20, 20, 255}, tab)
			Draw:MenuBigText(name, true, false, x + 6, y + 5, tab)
		end

		function Draw:Toggle(name, value, x, y, tab)
			Draw:MenuOutlinedRect(true, x, y, 12, 12, {30, 30, 30, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 1, y + 1, 10, 10, {0, 0, 0, 255}, tab)

			local temptable = {}
			for i = 0, 3 do
				Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), 8, 2, {0, 0, 0, 255}, tab)
				table.insert(temptable, tab[#tab])
				if value then
					tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
				else
					tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
				end
			end

			Draw:MenuBigText(name, true, false, x + 16, y - 1, tab)
			table.insert(temptable, tab[#tab])
			return temptable
		end

		function Draw:Keybind(key, x, y, tab)
			local temptable = {}
			Draw:MenuFilledRect(true, x, y, 44, 16, {25, 25, 25, 255}, tab)
			Draw:MenuBigText(keyenum2name(key), true, true, x + 22, y + 1, tab)
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
				tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
			end

			local temptable = {}
			for i = 0, 3 do
				Draw:MenuFilledRect(true, x + 2, y + 14 + (i * 2), (length - 4) * ((value - minvalue) / (maxvalue - minvalue)), 2, {0, 0, 0, 255}, tab)
				table.insert(temptable, tab[#tab])
				tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
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
				tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
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
				tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
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
				tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
				table.insert(temptable, tab[#tab])
			end

			Draw:MenuOutlinedRect(true, x, y, length, 22, {30, 30, 30, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 20, {0, 0, 0, 255}, tab)
			Draw:MenuBigText(name, true, true, x + math.floor(length * 0.5), y + 4 , tab)

			return temptable
		end

		function Draw:List(name, x, y, length, maxamount, colums, tab)
			local temptable = {uparrow = {}, downarrow = {}, liststuff = {rows = {}, words = {}}}

			for i, v in ipairs(name) do
				Draw:MenuBigText(v, true, false, (math.floor(length/colums) * i) - math.floor(length/colums) + 30, y - 3, tab)
			end

			Draw:MenuOutlinedRect(true, x, y + 12, length, 22 * maxamount + 4, {30, 30, 30, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 1, y + 13, length - 2, 22 * maxamount + 2, {0, 0, 0, 255}, tab)

			Draw:MenuFilledRect(true, x + length - 7, y + 16, 1, 1, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, tab)
			table.insert(temptable.uparrow, tab[#tab])
			table.insert(mp.clrs.norm, tab[#tab])
			Draw:MenuFilledRect(true, x + length - 8, y + 17, 3, 1, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, tab)
			table.insert(temptable.uparrow, tab[#tab])
			table.insert(mp.clrs.norm, tab[#tab])
			Draw:MenuFilledRect(true, x + length - 9, y + 18, 5, 1, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, tab)
			table.insert(temptable.uparrow, tab[#tab])
			table.insert(mp.clrs.norm, tab[#tab])

			Draw:MenuFilledRect(true, x + length - 7, y + 16 + (22 * maxamount + 4) - 9, 1, 1, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, tab)
			table.insert(temptable.downarrow, tab[#tab])
			table.insert(mp.clrs.norm, tab[#tab])
			Draw:MenuFilledRect(true, x + length - 8, y + 16 + (22 * maxamount + 4) - 10, 3, 1, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, tab)
			table.insert(temptable.downarrow, tab[#tab])
			table.insert(mp.clrs.norm, tab[#tab])
			Draw:MenuFilledRect(true, x + length - 9, y + 16 + (22 * maxamount + 4) - 11, 5, 1, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, tab)
			table.insert(temptable.downarrow, tab[#tab])
			table.insert(mp.clrs.norm, tab[#tab])


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
	end
	-- ok now the cool part :D
	--ANCHOR menu stuffz

	local tabz = {}
	for i = 1, #menutable do
		tabz[i] = {}
	end

	local tabbies = {} -- i like tabby catz 🐱🐱🐱
	
	for k, v in pairs(menutable) do
		Draw:MenuFilledRect(true, 10 + ((k - 1) * math.floor((mp.w - 20)/#menutable)), 27, math.floor((mp.w - 20)/#menutable), 32, {30, 30, 30, 255}, bbmenu)
		Draw:MenuOutlinedRect(true, 10 + ((k - 1) * math.floor((mp.w - 20)/#menutable)), 27, math.floor((mp.w - 20)/#menutable), 32, {20, 20, 20, 255}, bbmenu)
		Draw:MenuBigText(v.name, true, true, 10 + ((k - 1) * math.floor((mp.w - 20)/#menutable)) + math.floor(math.floor((mp.w - 20)/#menutable)*0.5), 35, bbmenu)
		table.insert(tabbies, {bbmenu[#bbmenu - 2], bbmenu[#bbmenu - 1], bbmenu[#bbmenu]})
		table.insert(mp.tabnum2str, v.name)

		mp.options[v.name] = {}

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

				mp.options[v.name][v1.name] = {}
				if v1.content ~= nil then
					
					for k2, v2 in pairs(v1.content) do
						if v2.type == "toggle" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:Toggle(v2.name, v2.value, v1.x + 8, v1.y + y_pos, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = v2.value
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1}
							if v2.extra ~= nil then
								if v2.extra.type == "keybind" then
									mp.options[v.name][v1.name][v2.name][5] = {}
									mp.options[v.name][v1.name][v2.name][5][4] = Draw:Keybind(v2.extra.key, v1.x + v1.width - 52, y_pos + v1.y - 2, tabz[k])
									mp.options[v.name][v1.name][v2.name][5][1] = v2.extra.key
									mp.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
									mp.options[v.name][v1.name][v2.name][5][3] = {v1.x + v1.width - 52, y_pos + v1.y - 2}
									mp.options[v.name][v1.name][v2.name][5][5] = false
								elseif v2.extra.type == "single colorpicker" then
									mp.options[v.name][v1.name][v2.name][5] = {}
									mp.options[v.name][v1.name][v2.name][5][4] = Draw:ColorPicker(v2.extra.color, v1.x + v1.width - 38, y_pos + v1.y - 1, tabz[k])
									mp.options[v.name][v1.name][v2.name][5][1] = v2.extra.color
									mp.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
									mp.options[v.name][v1.name][v2.name][5][3] = {v1.x + v1.width - 38, y_pos + v1.y - 1}
									mp.options[v.name][v1.name][v2.name][5][5] = false
									mp.options[v.name][v1.name][v2.name][5][6] = v2.extra.name
								elseif v2.extra.type == "double colorpicker" then
									mp.options[v.name][v1.name][v2.name][5] = {}
									mp.options[v.name][v1.name][v2.name][5][1] = {}
									mp.options[v.name][v1.name][v2.name][5][1][1] = {}
									mp.options[v.name][v1.name][v2.name][5][1][2] = {}
									mp.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
									for i = 1, 2 do
										mp.options[v.name][v1.name][v2.name][5][1][i][4] = Draw:ColorPicker(v2.extra.color[i], v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1, tabz[k])
										mp.options[v.name][v1.name][v2.name][5][1][i][1] = v2.extra.color[i]
										mp.options[v.name][v1.name][v2.name][5][1][i][3] = {v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1}
										mp.options[v.name][v1.name][v2.name][5][1][i][5] = false
										mp.options[v.name][v1.name][v2.name][5][1][i][6] = v2.extra.name[i]
									end
								end
							end
							y_pos += 18
						elseif v2.type == "slider" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:Slider(v2.name, v2.stradd, v2.value, v2.minvalue, v2.maxvalue, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = v2.value
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							mp.options[v.name][v1.name][v2.name][5] = false
							mp.options[v.name][v1.name][v2.name][6] = {v2.minvalue, v2.maxvalue}
							y_pos += 30
						elseif v2.type == "dropbox" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:Dropbox(v2.name, v2.value, v2.values, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = v2.value
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							mp.options[v.name][v1.name][v2.name][5] = false
							mp.options[v.name][v1.name][v2.name][6] = v2.values
							y_pos += 40
						elseif v2.type == "combobox" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:Combobox(v2.name, v2.values, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = v2.values
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							mp.options[v.name][v1.name][v2.name][5] = false
							y_pos += 40
						elseif v2.type == "button" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:Button(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = false
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
							y_pos += 28
						elseif v2.type == "list" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:List(v2.multiname, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.colums, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = nil
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = 1
							mp.options[v.name][v1.name][v2.name][5] = {}
							mp.options[v.name][v1.name][v2.name][6] = v2.size
							mp.options[v.name][v1.name][v2.name][7] = v2.colums
							mp.options[v.name][v1.name][v2.name][8] = {v1.x + 8, v1.y + y_pos, v1.width - 16}
							y_pos += 22 + (22 * v2.size)
						elseif v2.type == "image" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][1] = Draw:ImageWithText(v2.size, nil, v2.text, v1.x + 8, v1.y + y_pos, tabz[k])
							mp.options[v.name][v1.name][v2.name][2] = v2.type
						end
					end
				end
				y_pos += 2
				if v1.autopos == nil then
					Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
				else
					if v1.autofill then
						y_pos = (mp.h - 17) - (v1.y)
					end
					Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, y_pos, tabz[k])
					y_offies[v1.autopos] += y_pos + 6
				end
			end
		end
	end

	mp.list.addval = function(list, option)
		table.insert(list[5], option)
	end

	mp.list.removeval = function(list, optionnum)
		if list[1] == optionnum then
			list[1] = nil
		end
		table.remove(list[5], optionnum)
	end

	mp.list.removeall = function(list)
		list[5] = {}
		for k, v in pairs(list[4].liststuff) do 
			for i, v1 in ipairs(v) do
				for i1, v2 in ipairs(v1) do
					v2.Visible = false
				end
			end
		end
	end

	mp.list.setval = function(list, value)
		list[1] = value
	end

	Draw:MenuOutlinedRect(true, 10, 59, mp.w - 20, mp.h - 69, {20, 20, 20, 255}, bbmenu)

	Draw:MenuOutlinedRect(true, 11, 58, math.floor((mp.w - 20)/#menutable) - 2, 2, {35, 35, 35, 255}, bbmenu)
	local barguy = {bbmenu[#bbmenu], mp.postable[#mp.postable]}

	local function set_barguy(slot)
		barguy[1].Position = Vector2.new((mp.x + 11 + (((math.floor((mp.w - 20)/#menutable) - 2)) * (slot - 1))) + ((slot - 1) * 2), mp.y + 58)
		barguy[2][2] = (11 + (((math.floor((mp.w - 20)/#menutable) - 2)) * (slot - 1))) + ((slot - 1) * 2)
		barguy[2][3] = 58

		for k, v in pairs(tabbies) do
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

	set_barguy(mp.activetab)

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

		dropboxthingy[1].Size = Vector2.new(length, 22 * (#values + 1) - 1)
		dropboxthingy[2].Size = Vector2.new(length - 2, (22 * (#values + 1)) - 3)
		dropboxthingy[3].Size = Vector2.new(length - 4, (22 * #values) - 3)

		if visible then
			for i = 1, #values do
				dropboxtexty[i].Position = Vector2.new(x + 6, y + 26 + ((i - 1) * 21) )
				dropboxtexty[i].Visible = true
				dropboxtexty[i].Text = values[i]
				if i == value then
					dropboxtexty[i].Color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])
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
					dropboxtexty[i].Color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])
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

	local colorpickerthingy = {}
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
		postable = {}
	}

	local function colorpicker_outlined_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)    -- doing all this shit to make it easier for me to make this beat look nice and shit ya fell dog :dog_head:
		Draw:OutlinedRect(visible, pos_x + cp.x, pos_y + cp.y, width, hieght, clr, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	local function colorpicker_filled_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)
		Draw:FilledRect(visible, pos_x + cp.x, pos_y + cp.y, width, hieght, clr, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	local function colorpicker_image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
		Draw:Image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	local function colorpicker_big_text(text, visible, centered, pos_x, pos_y, tablename)
		Draw:OutlinedText(text, 2, visible, pos_x + cp.x, pos_y + cp.y, 13, centered, {255, 255, 255, 255}, {0, 0, 0}, tablename)
		table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
	end

	colorpicker_filled_rect(false, 1, 1, cp.w, cp.h, {35, 35, 35, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 1, 1, cp.w, cp.h, {0, 0, 0, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 2, 2, cp.w - 2, cp.h - 2, {20, 20, 20, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 3, 3, cp.w - 3, 1, {127, 72, 163, 255}, colorpickerthingy)
	table.insert(mp.clrs.norm, colorpickerthingy[#colorpickerthingy])
	colorpicker_outlined_rect(false, 3, 4, cp.w - 3, 1, {87, 32, 123, 255}, colorpickerthingy)
	table.insert(mp.clrs.dark, colorpickerthingy[#colorpickerthingy])
	colorpicker_outlined_rect(false, 3, 5, cp.w - 3, 1, {20, 20, 20, 255}, colorpickerthingy)
	colorpicker_big_text("color picker :D", false, false, 7, 6, colorpickerthingy)

	colorpicker_outlined_rect(false, 10, 23, 160, 160, {30, 30, 30, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 11, 24, 158, 158, {0, 0, 0, 255}, colorpickerthingy)
	colorpicker_filled_rect(false, 12, 25, 156, 156, {0, 0, 0, 255}, colorpickerthingy)
	local maincolor = colorpickerthingy[#colorpickerthingy]
	colorpicker_image(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, colorpickerthingy)

	--https://i.imgur.com/jG3NjxN.png
	local alphabar = {}
	colorpicker_outlined_rect(false, 10, 189, 160, 14, {30, 30, 30, 255}, colorpickerthingy)
	table.insert(alphabar, colorpickerthingy[#colorpickerthingy])
	colorpicker_outlined_rect(false, 11, 190, 158, 12, {0, 0, 0, 255}, colorpickerthingy)
	table.insert(alphabar, colorpickerthingy[#colorpickerthingy])
	colorpicker_image(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, colorpickerthingy)
	table.insert(alphabar, colorpickerthingy[#colorpickerthingy])

	colorpicker_outlined_rect(false, 176, 23, 14, 160, {30, 30, 30, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 177, 24, 12, 158, {0, 0, 0, 255}, colorpickerthingy)
	--https://i.imgur.com/2Ty4u2O.png
	colorpicker_image(false, BBOT_IMAGES[3], 178, 25, 10, 156, 1, colorpickerthingy)

	colorpicker_big_text("New Color", false, false, 198, 23, colorpickerthingy)
	colorpicker_outlined_rect(false, 197, 37, 75, 40, {30, 30, 30, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 198, 38, 73, 38, {0, 0, 0, 255}, colorpickerthingy)
	colorpicker_image(false, BBOT_IMAGES[4], 199, 39, 71, 36, 1, colorpickerthingy)

	colorpicker_filled_rect(false, 199, 39, 71, 36, {255, 0, 0, 255}, colorpickerthingy)
	local newcolor = colorpickerthingy[#colorpickerthingy]

	colorpicker_big_text("Old Color", false, false, 198, 77, colorpickerthingy)
	colorpicker_outlined_rect(false, 197, 91, 75, 40, {30, 30, 30, 255}, colorpickerthingy)
	colorpicker_outlined_rect(false, 198, 92, 73, 38, {0, 0, 0, 255}, colorpickerthingy)
	colorpicker_image(false, BBOT_IMAGES[4], 199, 93, 71, 36, 1, colorpickerthingy)

	colorpicker_filled_rect(false, 199, 93, 71, 36, {255, 0, 0, 255}, colorpickerthingy)
	local oldcolor = colorpickerthingy[#colorpickerthingy]

	colorpicker_big_text("[ Apply ]", false, true, 235, cp.h - 23, colorpickerthingy)
	local applytext = colorpickerthingy[#colorpickerthingy]

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

	local dragbar_r = {}
	Draw:OutlinedRect(true, 30, 30, 16, 5, {0, 0, 0, 255}, colorpickerthingy)
	table.insert(dragbar_r, colorpickerthingy[#colorpickerthingy])
	Draw:OutlinedRect(true, 31, 31, 14, 3, {255, 255, 255, 255}, colorpickerthingy)
	table.insert(dragbar_r, colorpickerthingy[#colorpickerthingy])

	local dragbar_b = {}
	Draw:OutlinedRect(true, 30, 30, 5, 16, {0, 0, 0, 255}, colorpickerthingy)
	table.insert(dragbar_b, colorpickerthingy[#colorpickerthingy])
	table.insert(alphabar, colorpickerthingy[#colorpickerthingy])
	Draw:OutlinedRect(true, 31, 31, 3, 14, {255, 255, 255, 255}, colorpickerthingy)
	table.insert(dragbar_b, colorpickerthingy[#colorpickerthingy])
	table.insert(alphabar, colorpickerthingy[#colorpickerthingy])

	local dragbar_m = {}
	Draw:OutlinedRect(true, 30, 30, 5, 5, {0, 0, 0, 255}, colorpickerthingy)
	table.insert(dragbar_m, colorpickerthingy[#colorpickerthingy])
	Draw:OutlinedRect(true, 31, 31, 3, 3, {255, 255, 255, 255}, colorpickerthingy)
	table.insert(dragbar_m, colorpickerthingy[#colorpickerthingy])

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

	local colorpicker_alpha
	local function set_colorpicker(visible, color, value, alpha, text, x, y)
		for k, v in pairs(colorpickerthingy) do
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
					colorpickerthingy[i].Size = Vector2.new(cp.w, cp.h)
				end
				colorpickerthingy[3].Size = Vector2.new(cp.w - 2, cp.h - 2)
			else
				cp.hsv.a = color[4]
				cp.alpha = true
				set_newcolor(color[1], color[2], color[3], color[4])
				set_oldcolor(color[1], color[2], color[3], color[4])
				cp.h = 211
				for i = 1, 2 do
					colorpickerthingy[i].Size = Vector2.new(cp.w, cp.h)
				end
				colorpickerthingy[3].Size = Vector2.new(cp.w - 2, cp.h - 2)
				set_dragbar_b(cp.x + 12 + math.floor(156 * (color[4]/255)), cp.y + 188)
			end

			applytext.Position = Vector2.new(235 + cp.x, cp.y + cp.h - 23)
			maincolor.Color = Color3.fromHSV(h, 1, 1)
			colorpickerthingy[7].Text = text
		end
	end

	set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 0, 0)

	local bbmouse = {}
	local mousie = {
		x = 100,
		y = 240
	}
	Draw:Triangle(true, true, {mousie.x, mousie.y}, {mousie.x, mousie.y + 15}, {mousie.x + 10, mousie.y + 10}, {127, 72, 163, 255}, bbmouse)
	table.insert(mp.clrs.norm, bbmouse[#bbmouse])
	Draw:Triangle(true, false, {mousie.x, mousie.y}, {mousie.x, mousie.y + 15}, {mousie.x + 10, mousie.y + 10}, {0, 0, 0, 255}, bbmouse)

	local function set_mouse_pos(x, y)
		for k, v in pairs(bbmouse) do
			v.PointA = Vector2.new(x, y + 36)
			v.PointB = Vector2.new(x, y + 36 + 15)
			v.PointC = Vector2.new(x + 10, y + 46)
		end
	end

	local function set_menu_color(r, g, b)
		mp.watermark.rect[1].Color = RGB(r - 40, g - 40, b - 40)
		mp.watermark.rect[2].Color = RGB(r, g, b)

		for k, v in pairs(mp.clrs.norm) do
			v.Color = RGB(r, g, b)
		end
		for k, v in pairs(mp.clrs.dark) do
			v.Color = RGB(r - 40, g - 40, b - 40)
		end
		local menucolor = {r, g, b}
		for k, v in pairs(mp.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == "toggle" then
						if not v2[1] then
							for i = 0, 3 do
								v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
							end
						else
							for i = 0, 3 do
								v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3])}, [2] = {start = 3, color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40)}})
							end
						end
					elseif v2[2] == "slider" then
						for i = 0, 3 do
							v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(menucolor[1], menucolor[2], menucolor[3])}, [2] = {start = 3, color = RGB(menucolor[1] - 40, menucolor[2] - 40, menucolor[3] - 40)}})
						end
					end
				end
			end
		end
		
	end


	local dropboxopen = false
	local dropboxthatisopen = nil
	local colorpickeropen = false
	local colorpickerthatisopen = nil
	local shooties = {}

	function inputBeganMenu(key)
		if key.KeyCode == Enum.KeyCode.Delete then
			cp.dragging_m = false
			cp.dragging_r = false
			cp.dragging_b = false
			if mp.open and not mp.fading then
				for k, v in pairs(mp.options) do
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
										v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
									end
									v2[1] = false
								end
							end
						end
					end
				end
				set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
				colorpickerthatisopen = nil
				colorpickeropen = false
				set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
			end
			if not mp.fading then
				mp.fading = true
				mp.fadestart = tick()
			end
		end

		if mp.open and not mp.fading then
			for k, v in pairs(mp.options) do

				for k1, v1 in pairs(v) do

					for k2, v2 in pairs(v1) do

						if v2[2] == "toggle" then
							if v2[5] ~= nil then
								if v2[5][2] == "keybind" and v2[5][5] and key.KeyCode.Value ~= 0 then

									v2[5][4][2].Color = RGB(30, 30, 30)
									v2[5][4][1].Text = keyenum2name(key.KeyCode)
									if keyenum2name(key.KeyCode) == "None" then
										v2[5][1] = nil
									else
										v2[5][1] = key.KeyCode
									end
									v2[5][5] = false
								end
							end
						end

					end

				end

			end
		end
	end

	function mp:set_menu_pos(x, y)
		for k, v in pairs(mp.postable) do
			if v[1].Visible then
				v[1].Position = Vector2.new(x + v[2], y + v[3])
			end
		end
	end

	function mp:mouse_in_menu(x, y, width, height)
		if LOCAL_MOUSE.X > mp.x + x and LOCAL_MOUSE.X < mp.x + x + width and LOCAL_MOUSE.y > mp.y - 36 + y and LOCAL_MOUSE.Y < mp.y - 36 + y + height then
			return true
		else
			return false
		end
	end

	function mp:mouse_in_colorpicker(x, y, width, height)
		if LOCAL_MOUSE.X > cp.x + x and LOCAL_MOUSE.X < cp.x + x + width and LOCAL_MOUSE.y > cp.y - 36 + y and LOCAL_MOUSE.Y < cp.y - 36 + y + height then
			return true
		else
			return false
		end
	end

	local keyz = {}
	for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
		keyz[v.Value] = v
	end

	function mp:getval(...)
		local args = {...}

		if args[4] == nil then
			if mp.options[args[1]][args[2]][args[3]][2] ~= "combobox" then
				return mp.options[args[1]][args[2]][args[3]][1]
			else
				local temptable = {}
				for k, v in ipairs(mp.options[args[1]][args[2]][args[3]][1]) do
					table.insert(temptable, v[2])
				end
				return temptable
			end
		else
			if args[4] == "keybind" or args[4] == "color" then
				if args[5] then
					return RGB(mp.options[args[1]][args[2]][args[3]][5][1][1], mp.options[args[1]][args[2]][args[3]][5][1][2], mp.options[args[1]][args[2]][args[3]][5][1][3])
				else
					return mp.options[args[1]][args[2]][args[3]][5][1]
				end
			elseif args[4] == "color1" then
				if args[5] then
					return RGB(mp.options[args[1]][args[2]][args[3]][5][1][1][1][1], mp.options[args[1]][args[2]][args[3]][5][1][1][1][2], mp.options[args[1]][args[2]][args[3]][5][1][1][1][3])
				else
					return mp.options[args[1]][args[2]][args[3]][5][1][1][1]
				end
			elseif args[4] == "color2" then
				if args[5] then
					return RGB(mp.options[args[1]][args[2]][args[3]][5][1][2][1][1], mp.options[args[1]][args[2]][args[3]][5][1][2][1][2], mp.options[args[1]][args[2]][args[3]][5][1][2][1][3])
				else
					return mp.options[args[1]][args[2]][args[3]][5][1][2][1]
				end
			end
		end
	end


	local simpcfgnamez = {"toggle", "slider", "dropbox"}
	local function buttonpressed(bp)
		if bp == mp.options["Settings"]["Extra"]["Unload Cheat"] then
			mp:unload()
		elseif bp == mp.options["Settings"]["Extra"]["Set Clipboard Game ID"] then
			setclipboard(game.JobId)
		elseif bp == mp.options["Settings"]["Configuration"]["Save Config"] then
			local figgy = "BitchBot v2\nmade with <3 from Nate, Bitch, and Zarzel\n\n"

			for k, v in next, simpcfgnamez do
				figgy = figgy.. v.. "s {\n"
				for k1, v1 in pairs(mp.options) do
					for k2, v2 in pairs(v1) do
						for k3, v3 in pairs(v2) do
							if v3[2] == tostring(v) and k3 ~= "Configs" then
								figgy = figgy..k1.. "|".. k2.."|".. k3.."|"..tostring(v3[1]).. "\n"
							end
						end
					end
				end
				figgy = figgy.."}\n"
			end
			figgy = figgy.."comboboxes {\n"
			for k, v in pairs(mp.options) do
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
			for k, v in pairs(mp.options) do
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
			for k, v in pairs(mp.options) do
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
			for k, v in pairs(mp.options) do
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
			writefile("bitchbot/".. mp.game .."/config".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]).. ".bb", figgy)
		elseif bp == mp.options["Settings"]["Configuration"]["Load Config"] then

			local loadedcfg = readfile("bitchbot/".. mp.game .."/config".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]).. ".bb")
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
					if tt[4] == "true" then
						mp.options[tt[1]][tt[2]][tt[3]][1] = true
					else
						mp.options[tt[1]][tt[2]][tt[3]][1] = false
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
					mp.options[tt[1]][tt[2]][tt[3]][1] = tonumber(tt[4])
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
					mp.options[tt[1]][tt[2]][tt[3]][1] = tonumber(tt[4])
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
					local subs = string.split(tt[4], ",")

					for i, v in ipairs(subs) do
						local opt = string.gsub(v, " ", "")
						if opt == "true" then
							mp.options[tt[1]][tt[2]][tt[3]][1][i][2] = true
						else
							mp.options[tt[1]][tt[2]][tt[3]][1][i][2] = false
						end
						if i == #subs - 1 then break end
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
					if tt[4] == "nil" then
						mp.options[tt[1]][tt[2]][tt[3]][5][1] = nil
					else
						mp.options[tt[1]][tt[2]][tt[3]][5][1] = keyz[tonumber(tt[4])]
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
					local subs = string.split(tt[4], ",")

					for i, v in ipairs(subs) do
						if mp.options[tt[1]][tt[2]][tt[3]][5][1][i] == nil then
							break
						end
						local opt = string.gsub(v, " ", "")
						mp.options[tt[1]][tt[2]][tt[3]][5][1][i] = tonumber(opt)
						if i == #subs - 1 then break end
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
					local subs = {string.split(tt[4], ","), string.split(tt[5], ",")}

					for i, v in ipairs(subs) do
						for i1, v1 in ipairs(v) do
							if mp.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] == nil then
								break
							end
							local opt = string.gsub(v1, " ", "")
							mp.options[tt[1]][tt[2]][tt[3]][5][1][i][1][i1] = tonumber(opt)
							if i1 == #v - 1 then break end
						end
					end

				end

				for k, v in pairs(mp.options) do
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "toggle" then
								if not v2[1] then
									for i = 0, 3 do
										v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
									end
								else
									for i = 0, 3 do
										v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
									end
								end
								if v2[5] ~= nil then
									if v2[5][2] == "keybind" then

										v2[5][4][2].Color = RGB(30, 30, 30)
										v2[5][4][1].Text = keyenum2name(v2[5][1])
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

								v2[4][5].Text = tostring(v2[1]).. v2[4][6]

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
								v2[4][1].Text = textthing
							end
						end
					end
				end
			end
		end
	end

	local function mousebutton1downfunc()
		dropboxopen = false
		for k, v in pairs(mp.options) do
			for k1, v1 in pairs(v) do
				for k2, v2 in pairs(v1) do
					if v2[2] == "dropbox" and v2[5] then
						if not mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) then
							set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
							v2[5] = false
						else
							dropboxthatisopen = v2
							dropboxopen = true
						end
					end
					if v2[2] == "combobox" and v2[5] then
						if not mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) then
							set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
							v2[5] = false
						else
							dropboxthatisopen = v2
							dropboxopen = true
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
									if not mp:mouse_in_colorpicker(0, 0, cp.w, cp.h) then
										set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
										v2[5][5] = false
										colorpickerthatisopen = nil
										colorpickeropen = false
									end
								end
							elseif v2[5][2] == "double colorpicker" then
								for k3, v3 in pairs(v2[5][1]) do
									if v3[5] == true then
										if not mp:mouse_in_colorpicker(0, 0, cp.w, cp.h) then
											set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
											v3[5] = false
											colorpickerthatisopen = nil
											colorpickeropen = false
										end
									end
								end
							end
						end
					end
				end
			end
		end
		for i = 1, #menutable do
			if mp:mouse_in_menu(10 + ((i - 1) * math.floor((mp.w - 20)/#menutable)), 27, math.floor((mp.w - 20)/#menutable), 32) then
				mp.activetab = i
				set_barguy(mp.activetab)
				mp:set_menu_pos(mp.x, mp.y)
			end
		end
		if colorpickeropen then
			if mp:mouse_in_colorpicker(197, cp.h - 25, 75, 20) then
				local tempclr = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				colorpickerthatisopen[4][1].Color = tempclr
				for i = 2, 3 do
					colorpickerthatisopen[4][i].Color = RGB(math.floor(tempclr.R * 255) - 40, math.floor(tempclr.G * 255) - 40, math.floor(tempclr.B * 255) - 40)
				end
				if cp.alpha then
					colorpickerthatisopen[1] = {math.floor(tempclr.R * 255), math.floor(tempclr.G * 255), math.floor(tempclr.B * 255), cp.hsv.a}
				else
					colorpickerthatisopen[1] = {math.floor(tempclr.R * 255), math.floor(tempclr.G * 255), math.floor(tempclr.B * 255)}
				end
				colorpickeropen = false
				colorpickerthatisopen = nil
				set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
			end
			if mp:mouse_in_colorpicker(10, 23, 160, 160) then
				cp.dragging_m = true
			elseif mp:mouse_in_colorpicker(176, 23, 14, 160) then
				cp.dragging_r = true
			elseif mp:mouse_in_colorpicker(10, 189, 160, 14) and cp.alpha then
				cp.dragging_b = true
			end
		else
			for k, v in pairs(mp.options) do
				if mp.tabnum2str[mp.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "toggle" and not dropboxopen then
								if mp:mouse_in_menu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16) then
									if v2[1] then
										for i = 0, 3 do
											v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
										end
									else
										for i = 0, 3 do
											v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
										end
									end
									v2[1] = not v2[1]
								end
								if v2[5] ~= nil then
									if v2[5][2] == "keybind" then
										if mp:mouse_in_menu(v2[5][3][1], v2[5][3][2], 44, 16) then
											v2[5][4][2].Color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])
											v2[5][5] = true
										end
									elseif v2[5][2] == "single colorpicker" then
										if mp:mouse_in_menu(v2[5][3][1], v2[5][3][2], 28, 14) then
											v2[5][5] = true
											colorpickeropen = true
											colorpickerthatisopen = v2[5]
											if v2[5][1][4] ~= nil then
												set_colorpicker(true, v2[5][1], v2[5], true, v2[5][6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
											else
												set_colorpicker(true, v2[5][1], v2[5], false, v2[5][6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
											end
										end
									elseif v2[5][2] == "double colorpicker" then
										for k3, v3 in pairs(v2[5][1]) do
											if mp:mouse_in_menu(v3[3][1], v3[3][2], 28, 14) then
												v3[5] = true
												colorpickeropen = true
												colorpickerthatisopen = v3
												if v3[1][4] ~= nil then
													set_colorpicker(true, v3[1], v3, true, v3[6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
												else
													set_colorpicker(true, v3[1], v3, false, v3[6], LOCAL_MOUSE.x, LOCAL_MOUSE.y + 36)
												end
											end
										end
									end
								end
							elseif v2[2] == "slider" and not dropboxopen then
								if mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 28) then
									v2[5] = true
								end
							elseif v2[2] == "dropbox" then
								if dropboxopen then
									if v2 ~= dropboxthatisopen then
										continue
									end
								end
								if mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 36) then
									if not v2[5] then
										set_dropboxthingy(true, v2[3][1] + mp.x + 1, v2[3][2] + mp.y + 13, v2[3][3], v2[1], v2[6])
										v2[5] = true
									else
										set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
										v2[5] = false
									end
								elseif mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) and v2[5] then
									for i = 1, #v2[6] do
										if mp:mouse_in_menu(v2[3][1], v2[3][2] + 36 + ((i - 1) * 22), v2[3][3], 23) then
											v2[4][1].Text = v2[6][i]
											v2[1] = i
											set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
											v2[5] = false
										end
									end
								end
							elseif v2[2] == "combobox" then
								if dropboxopen then
									if v2 ~= dropboxthatisopen then
										continue
									end
								end
								if mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 36) then
									if not v2[5] then
										set_comboboxthingy(true, v2[3][1] + mp.x + 1, v2[3][2] + mp.y + 13, v2[3][3], v2[1], v2[6])
										v2[5] = true
									else
										set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
										v2[5] = false
									end
								elseif mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) and v2[5] then
									for i = 1, #v2[1] do
										if mp:mouse_in_menu(v2[3][1], v2[3][2] + 36 + ((i - 1) * 22), v2[3][3], 23) then
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
											v2[4][1].Text = textthing
											set_comboboxthingy(true, v2[3][1] + mp.x + 1, v2[3][2] + mp.y + 13, v2[3][3], v2[1], v2[6])
										end
									end
								end
							elseif v2[2] == "button" and not dropboxopen then
								if mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 22) then
									if not v2[1] then
										buttonpressed(v2)
										for i = 0, 8 do
											v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(35, 35, 35)}, [2] = {start = 8, color = RGB(50, 50, 50)}})
										end
										v2[1] = true
									end
								end
							elseif v2[2] == "list" then
								--[[
									mp.options[v.name][v1.name][v2.name] = {}
									mp.options[v.name][v1.name][v2.name][4] = Draw:List(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.colums, tabz[k])
									mp.options[v.name][v1.name][v2.name][1] = nil
									mp.options[v.name][v1.name][v2.name][2] = v2.type
									mp.options[v.name][v1.name][v2.name][3] = 1
									mp.options[v.name][v1.name][v2.name][5] = {}
									mp.options[v.name][v1.name][v2.name][6] = v2.size
									mp.options[v.name][v1.name][v2.name][7] = v2.colums
									mp.options[v.name][v1.name][v2.name][8] = {v1.x + 8, v1.y + y_pos, v1.width - 16}
								]]--
								if #v2[5] > v2[6] then
									for i = 1, v2[6] do
										if mp:mouse_in_menu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22) then
											if v2[1] == tostring(v2[5][i + v2[3] - 1][1][1]) then
												v2[1] = nil
											else
												v2[1] = tostring(v2[5][i + v2[3] - 1][1][1])
											end
										end
									end
								else
									for i = 1, #v2[5] do
										if mp:mouse_in_menu(v2[8][1], v2[8][2] + (i * 22) - 5, v2[8][3], 22) then
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
		if mp.tabnum2str[mp.activetab] == "Settings" then
			if mp.options["Settings"]["Menu Settings"]["Menu Accent"][1] then
				local clr = mp.options["Settings"]["Menu Settings"]["Menu Accent"][5][1]
				mp.mc = {clr[1], clr[2], clr[3]}
			else
				mp.mc = {127, 72, 163}
			end
			set_menu_color(mp.mc[1], mp.mc[2], mp.mc[3])

			local wme = mp:getval("Settings", "Menu Settings", "Watermark")
			for k, v in pairs(mp.watermark.rect) do
				v.Visible = wme
			end
			mp.watermark.text[1].Visible = wme
		end
	end

	local function mousebutton1upfunc()
		cp.dragging_m = false
		cp.dragging_r = false
		cp.dragging_b = false
		for k, v in pairs(mp.options) do
			if mp.tabnum2str[mp.activetab] == k then
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "slider" and v2[5] then
							v2[5] = false
						end
						if v2[2] == "button" and v2[1] then
							for i = 0, 8 do
								v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
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

	mp.connections.mwf = LOCAL_MOUSE.WheelForward:Connect(function()
		if mp.open then
			for k, v in pairs(mp.options) do
				if mp.tabnum2str[mp.activetab] == k then
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

	mp.connections.mwb = LOCAL_MOUSE.WheelBackward:Connect(function()
		if mp.open then
			for k, v in pairs(mp.options) do
				if mp.tabnum2str[mp.activetab] == k then
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

	function mp:setmenutransparency(transparency)
		for k, v in pairs(bbmouse) do
			v.Transparency = transparency/255
		end
		for k, v in pairs(bbmenu) do
			v.Transparency = transparency/255
		end
		for k, v in pairs(tabz[mp.activetab]) do
			v.Transparency = transparency/255
		end
	end

	function mp:setmenuvisibility(visible)
		for k, v in pairs(bbmouse) do
			v.Visible = visible
		end
		for k, v in pairs(bbmenu) do
			v.Visible = visible
		end
		for k, v in pairs(tabz[mp.activetab]) do
			v.Visible = visible
		end
	end

	local function renderSteppedMenu()
		---------------------------------------------------------------------i pasted the old menu working ingame shit from the old source nate pls fix ty
		-----------------------------------------------this is the really shitty alive check that we've been using since day one
		-- removed it :DDD


		if mp.open or mp.fading then
			for k, v in pairs(mp.options) do
				if mp.tabnum2str[mp.activetab] == k then
					for k1, v1 in pairs(v) do
						for k2, v2 in pairs(v1) do
							if v2[2] == "slider" and v2[5] then
								v2[1] = math.floor((v2[6][2] - v2[6][1]) * ((LOCAL_MOUSE.X - mp.x - v2[3][1])/v2[3][3])) + v2[6][1]
								if v2[1] < v2[6][1] then
									v2[1] = v2[6][1]
								elseif v2[1] > v2[6][2] then
									v2[1] = v2[6][2]
								end
								v2[4][5].Text = tostring(v2[1]).. v2[4][6]
								for i = 1, 4 do
									v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
								end
								--[[
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][4] = Draw:List(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, v2.size, v2.colums, tabz[k])
							mp.options[v.name][v1.name][v2.name][1] = nil
							mp.options[v.name][v1.name][v2.name][2] = v2.type
							mp.options[v.name][v1.name][v2.name][3] = 1
							mp.options[v.name][v1.name][v2.name][5] = {}
							mp.options[v.name][v1.name][v2.name][6] = v2.size
							mp.options[v.name][v1.name][v2.name][7] = v2.colums]]
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
												
												if mp.options["Settings"]["Menu Settings"]["Menu Accent"][1] then
													local clr = mp.options["Settings"]["Menu Settings"]["Menu Accent"][5][1]
													v2[4].liststuff.words[i][i1].Color = RGB(clr[1], clr[2], clr[3])
												else
													v2[4].liststuff.words[i][i1].Color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])
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
											mp:set_menu_pos(mp.x, mp.y)
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
											mp:set_menu_pos(mp.x, mp.y)
										end
									end
								end
							end
						end
					end
				end
			end

			if ((LOCAL_MOUSE.X > mp.x and LOCAL_MOUSE.X < mp.x + mp.w and LOCAL_MOUSE.y > mp.y - 32 and LOCAL_MOUSE.Y < mp.y - 11) or dragging) and not dontdrag then
				if mp.mousedown then
					if dragging == false then
						clickspot_x = LOCAL_MOUSE.X
						clickspot_y = LOCAL_MOUSE.Y - 36
						original_menu_X = mp.x
						original_menu_y = mp.y
						dragging = true
					end
					mp.x = (original_menu_X - clickspot_x) + LOCAL_MOUSE.X
					mp.y = (original_menu_y - clickspot_y) + LOCAL_MOUSE.Y - 36
					mp:set_menu_pos(mp.x, mp.y)
				else
					dragging = false
				end
			elseif mp.mousedown then
				dontdrag = true
			elseif not mp.mousedown then
				dontdrag = false
			end
			if colorpickeropen then
				if cp.dragging_m then
					set_dragbar_m(math.clamp(LOCAL_MOUSE.X, cp.x + 12, cp.x + 167) - 2, math.clamp(LOCAL_MOUSE.Y + 36, cp.y + 25, cp.y + 180) - 2)

					cp.hsv.s = (math.clamp(LOCAL_MOUSE.x, cp.x + 12, cp.x + 167) - cp.x - 12)/155
					cp.hsv.v = 1 - ((math.clamp(LOCAL_MOUSE.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
					newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				elseif cp.dragging_r then
					set_dragbar_r(cp.x + 175, math.clamp(LOCAL_MOUSE.Y + 36, cp.y + 23, cp.y + 178))

					maincolor.Color = Color3.fromHSV(1 - ((math.clamp(LOCAL_MOUSE.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155), 1, 1)

					cp.hsv.h = 1 - ((math.clamp(LOCAL_MOUSE.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
					newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
				elseif cp.dragging_b then
					set_dragbar_b(math.clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168 ), cp.y + 188)
					newcolor.Transparency = (math.clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158
					cp.hsv.a = math.floor(((math.clamp(LOCAL_MOUSE.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158) * 255)
				end
			end
		else
			if dragging then
				dragging = false
			end
		end

		if mp.open or mp.fading then
			set_mouse_pos(LOCAL_MOUSE.x, LOCAL_MOUSE.y)
		end

		if mp.fading then
			if mp.open then
				local timesincefade = tick() - mp.fadestart
				local fade_amount = 255 - math.floor((timesincefade * 10) * 255)
				mp:setmenutransparency(fade_amount)
				if fade_amount <= 0 then
					mp.open = false
					mp.fading = false
					mp:setmenutransparency(0)
					mp:setmenuvisibility(false)
				else
					mp:setmenutransparency(fade_amount)
				end
			else
				mp:setmenuvisibility(true)
				set_barguy(mp.activetab)
				local timesincefade = tick() - mp.fadestart
				local fade_amount = math.floor((timesincefade * 10) * 255)
				mp:setmenutransparency(fade_amount)
				if fade_amount >= 255 then
					mp.open = true
					mp.fading = false
					mp:setmenutransparency(255)
				else
					mp:setmenutransparency(fade_amount)
				end
			end
		end
	end

	mp.connections.inputstart = INPUT_SERVICE.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mp.mousedown = true
			if mp.open and not mp.fading then
				mousebutton1downfunc()
			end
		end
		inputBeganMenu(input)
	end)

	mp.connections.inputended = INPUT_SERVICE.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mp.mousedown = false
			if mp.open and not mp.fading then
				mousebutton1upfunc()
			end
		end
	end)

	mp.connections.renderstepped = game.RunService.RenderStepped:Connect(function()
		renderSteppedMenu()
	end)
	do
		local wm = mp.watermark
		wm.textString = "BitchBot | Developer | " .. os.date("%b. %d, %Y")
		wm.pos = Vector2.new(40, 10)
		wm.text = {}
		wm.width = (#wm.textString) * 7 + 10
		wm.rect = {}
	
		Draw:FilledRect(true, wm.pos.X, wm.pos.Y + 1, wm.width, 2, {mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[2] - 40, 255}, wm.rect)
		Draw:FilledRect(true, wm.pos.X, wm.pos.Y, wm.width, 2, {mp.mc[1], mp.mc[2], mp.mc[3], 255}, wm.rect)
		Draw:FilledRect(true, wm.pos.X, wm.pos.Y + 2, wm.width, 16, {50, 50, 50, 255}, wm.rect)
		for i = 0, 14 do
		  Draw:FilledRect(true, wm.pos.X, wm.pos.Y + 2 + i, wm.width, 1, {50 - i * 1.7, 50 - i * 1.7, 50 - i * 1.7, 255}, wm.rect)
		end
		Draw:OutlinedRect(true, wm.pos.X, wm.pos.Y, wm.width, 18, {0, 0, 0, 255}, wm.rect)
		Draw:OutlinedText(wm.textString, 2, true, wm.pos.X + 5, wm.pos.Y + 2, 13, false, {255, 255, 255, 255}, {0, 0, 0, 255}, wm.text)
	end
	function mp:unload()
		for k, v in pairs(self.connections) do
			v:Disconnect()
		end
		Draw:UnRender()
		allrender = nil
		mp = nil
		Draw = nil
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


if mp.game == "uni" then
	local allesp = {
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
		Draw:OutlinedRect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.outerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.innerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, {255, 255, 255, 255}, allesp.box)

		Draw:FilledRect(false, 20, 20, 4, 20, {10, 10, 10, 215}, allesp.healthouter)
		Draw:FilledRect(false, 20, 20, 20, 20, {255, 255, 255, 255}, allesp.healthinner)

		Draw:OutlinedText("", 2, false, 20, 20, 13, false, {255, 255, 255, 255}, {0, 0, 0}, allesp.hptext)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.distance)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.name)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.team)
	end

	BBMenuInit({
		{
			name = "Aimbot",
		},
		{
			name = "Visuals",
			content = {
				{
					name = "Player ESP",
					autopos = "left", 
					autofill = true,
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
					name = "ESP Settings",
					autopos = "right",
					content = {
						{
							type = "combobox",
							name = "Checks",
							values = {{"Alive", true}, {"Same Team", false}}
						},
						{
							type = "toggle",
							name = "Text Box Outlines",
							value = false,
						}
					}
				},
				{
					name = "Local Visuals",
					autopos = "right",
					autofill = true, 
					content = {
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
					x = 17,
					y = 66,
					width = 230,
					height = 332,
					content = {
						{
							type = "toggle",
							name = "Speed Hack",
							value = false
						},
						{
							type = "slider",
							name = "Speed",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s"
						},
						{
							type = "dropbox",
							name = "Speed Hack Method",
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
							name = "Fly Hack",
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
			}
		},
		{--ANCHOR Settings
			name = "Settings",
			content = {
				{
					name = "Player List",
					x = mp.columns.left,
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
						}
					}
				},
				{
					name = "Menu Settings",
					x = mp.columns.left,
					y = 400,
					width = mp.columns.width,
					height = 62,
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
					}
				},
				{
					name = "Extra",
					x = mp.columns.left,
					y = 468,
					width = mp.columns.width,
					height = 115,
					content = {
						{
							type = "button",
							name = "Set Clipboard Game ID"
						},
						{
							type = "button",
							name = "Unload Cheat"
						}
					}
				},
				{
					name = "Configuration",
					x = mp.columns.right,
					y = 400,
					width = mp.columns.width,
					height = 183,
					content = {
						{
							type = "dropbox",
							name = "Configs",
							value = 1,
							values = {"Config 1", "Config 2", "Config 3", "Config 4", "Config 5", "Config 6"}
						},
						{
							type = "button",
							name = "Load Config"
						},
						{
							type = "button",
							name = "Save Config"
						},
						{
							type = "button",
							name = "Delete Config"
						},
					}
				}
			}
		},
	})


	local selected_plyr = nil
	local plistinfo = mp.options["Settings"]["Player List"]["Player Info"][1]
	local plist = mp.options["Settings"]["Player List"]["Players"]
	local playerpictures = {}
	local function updateplist()
		local playerlistval = mp:getval("Settings", "Player List", "Players")
		local playerz = Players:GetPlayers()
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
			end
			table.insert(templist, {plyrname, teamtext, plyrstatus})
		end
		plist[5] = templist
		if playerlistval ~= nil then
			for i, v in ipairs(playerz) do
				if v.Name == playerlistval then
					selected_plyr = v
					break
				end
				if i == #playerz then
					selected_plyr = nil
					mp.list.setval(plist, nil)
				end
			end
		end
		mp:set_menu_pos(mp.x, mp.y)
	end

	local function cacheAvatars()
		for i, v in ipairs(Players:GetPlayers()) do
			if not table.contains(playerpictures, v) then
				local content = Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				playerpictures[v] = game:HttpGet(content)
			end
		end
	end

	local function setplistinfo(player, textonly)
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
				plistinfo[2].Data = playerpictures[player]
			end
		else
			plistinfo[2].Data = BBOT_IMAGES[5]	
			plistinfo[1].Text = "No Player Selected"
		end
	end

	mp.list.removeall(mp.options["Settings"]["Player List"]["Players"])
	updateplist()
	cacheAvatars()
	setplistinfo(nil)

	mp.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if mp.tabnum2str[mp.activetab] == "Settings" and mp.open then
				game.RunService.Stepped:wait()
				updateplist()
				if plist[1] ~= nil then
					setplistinfo(selected_plyr)
				else
					setplistinfo(nil)
				end
			end
		end
	end)

	mp.connections.renderstepped2 = game.RunService.RenderStepped:Connect(function()
		if mp.open then
			if mp.tabnum2str[mp.activetab] == "Settings" then
				if plist[1] ~= nil then
					setplistinfo(selected_plyr, true)
				end
			end
		end
		for k, v in pairs(allesp) do
			for k1, v1 in ipairs(v) do
				if v1.Visible then
					v1.Visible = false
				end
			end
		end
		for i, v in ipairs(Players:GetPlayers()) do
			if v == LOCAL_PLAYER then
				continue 
			end

			local player = v.Character
			if v.Character ~= nil and v.Character.HumanoidRootPart ~= nil  then

				local checks = mp:getval("Visuals", "ESP Settings", "Checks")
				if player:FindFirstChild("Humandoid") then
					print("hi")
					if checks[1] and player.Humanoid.Health <= 0 then
						continue
					end
				end
				if v.Team ~= nil then
					if checks[2] and v.Team == LOCAL_PLAYER.Team then
						continue
					end
				end
				local rootpart = v.Character.HumanoidRootPart.Position
				local top, top_isrendered = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(rootpart.x, rootpart.y + 2.5, rootpart.z))
				local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(rootpart.x, rootpart.y - 2.9, rootpart.z))
				local box_width = (bottom.y - top.y) / 2

				if top_isrendered or bottom_isrendered then
					local boxtop = {x = math.floor(bottom.x - box_width / 2), y = math.floor(top.y + 36)}
					local boxsize = {w = math.floor(box_width), h =  math.floor(bottom.y - top.y)}
					if mp:getval("Visuals", "Player ESP", "Box") then
						allesp.outerbox[i].Position = Vector2.new(boxtop.x - 1, boxtop.y - 1)
						allesp.outerbox[i].Size = Vector2.new(boxsize.w + 2, boxsize.h + 2)
						allesp.outerbox[i].Visible = true
						allesp.outerbox[i].Transparency = mp:getval("Visuals", "Player ESP", "Box", "color")[4]/255

						allesp.innerbox[i].Position = Vector2.new(boxtop.x + 1, boxtop.y + 1)
						allesp.innerbox[i].Size = Vector2.new(boxsize.w - 2, boxsize.h - 2)
						allesp.innerbox[i].Visible = true
						allesp.innerbox[i].Transparency = mp:getval("Visuals", "Player ESP", "Box", "color")[4]/255


						allesp.box[i].Position = Vector2.new(boxtop.x, boxtop.y)
						allesp.box[i].Size = Vector2.new(boxsize.w, boxsize.h)
						allesp.box[i].Visible = true
						allesp.box[i].Color = mp:getval("Visuals", "Player ESP", "Box", "color", true)
						allesp.box[i].Transparency = mp:getval("Visuals", "Player ESP", "Box", "color")[4]/255
					end
					if humanoid then
						local health = humanoid.Health
						local maxhealth = humanoid.MaxHealth
						if mp:getval("Visuals", "Player ESP", "Health Bar") then
							allesp.healthouter[i].Position = Vector2.new(boxtop.x - 6, boxtop.y - 1)
							allesp.healthouter[i].Size = Vector2.new(4, boxsize.h + 2)
							allesp.healthouter[i].Visible = true

							allesp.healthinner[i].Position = Vector2.new(boxtop.x - 5, boxtop.y)
							allesp.healthinner[i].Size = Vector2.new(2, boxsize.h)
							allesp.healthinner[i].Visible = true
						elseif mp:getval("Visuals", "Player ESP", "Health Number") then
							allesp.hptext[i].Text = tostring(health)
							local textsize = allesp.hptext[i].TextBounds
							allesp.hptext[i].Position = Vector2.new(boxtop.x - 1 - textsize.x, boxtop.y - 1)
							allesp.hptext[i].Visible = true
						end
					end
					if mp:getval("Visuals", "Player ESP", "Name") then
						allesp.name[i].Text = v.Name
						allesp.name[i].Position = Vector2.new(math.floor(bottom.x), math.floor(top.y + 22))
						allesp.name[i].Visible = true
						allesp.name[i].Color = mp:getval("Visuals", "Player ESP", "Name", "color", true)
						allesp.name[i].Transparency = mp:getval("Visuals", "Player ESP", "Name", "color")[4]/255
					end
					local y_spot = 0
					if mp:getval("Visuals", "Player ESP", "Team") then
						if v.Team == nil then
							allesp.team[i].Text = "None"
						else
							allesp.team[i].Text = v.Team.Name
						end
						if mp:getval("Visuals", "Player ESP", "Team Color Based") then
							if v.Team == nil then
								allesp.team[i].Color = RGB(255, 255, 255)
							else
								allesp.team[i].Color = v.TeamColor.Color
							end
						else
							allesp.team[i].Color = mp:getval("Visuals", "Player ESP", "Team", "color", true)
						end
						allesp.team[i].Transparency = mp:getval("Visuals", "Player ESP", "Team", "color")[4]/255
						allesp.team[i].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y + 36))
						allesp.team[i].Visible = true
						y_spot += 15
					end
					if mp:getval("Visuals", "Player ESP", "Distance") then
						allesp.distance[i].Text = tostring(math.ceil(LOCAL_PLAYER:DistanceFromCharacter(rootpart) / 5)).. "m"
						allesp.distance[i].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y + 36) + y_spot)
						allesp.distance[i].Visible = true
						allesp.distance[i].Color = mp:getval("Visuals", "Player ESP", "Distance", "color", true)
						allesp.distance[i].Transparency = mp:getval("Visuals", "Player ESP", "Distance", "color")[4]/255
					end
				end
			end
		end
	end)

	mp.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
		updateplist()
		cacheAvatars()
		if plist[1] ~= nil then
			setplistinfo(selected_plyr)
		else
			setplistinfo(nil)
		end
	end)
	 
	mp.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
		updateplist()
	end)	

elseif mp.game == "pf" then
	local allesp = {
		skel = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
		},
		outerbox = {},
		box = {},
		hpouter = {},
		hpinner = {},
		hptext = {},
		nametext = {},
		weptext = {},
		disttext = {},
		watermark = {},
	}

	for i = 1, 35 do
		for i_, v in ipairs(allesp.skel) do
			Draw:Line(false, 1, 30, 30, 50, 50, {255, 255, 255, 255}, v)
		end
		Draw:OutlinedRect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.outerbox)
		Draw:OutlinedRect(false, 20, 20, 20, 20, {255, 255, 255, 255}, allesp.box)
	
		Draw:FilledRect(false, 20, 20, 20, 20, {10, 10, 10, 215}, allesp.hpouter)
		Draw:FilledRect(false, 20, 20, 20, 20, {0, 255, 0, 255}, allesp.hpinner)
		Draw:OutlinedText("", 1, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.hptext)
	
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.disttext)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.weptext)
		Draw:OutlinedText("", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.nametext)
	end
	
	local client = {}
	
	for k, v in pairs(getgc(true)) do
		if type(v) == "function" then
			if getinfo(v).name == "bulletcheck" then
				client.bulletcheck = v
			elseif getinfo(v).name == "trajectory" then
				client.trajectory = v
			end
			for k1, v1 in pairs(debug.getupvalues(v)) do
				if type(v1) == "table" then
					if rawget(v1, "send") then
						client.net = v1
					elseif rawget(v1, "gammo") then
						client.logic = v1
					elseif rawget(v1, "loadknife") then
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
				client.deploy = v
			elseif rawget(v, "new") and rawget(v, "step") then
				client.particle = v
			end
		end
	end	
	local CHAT_GAME = LOCAL_PLAYER.PlayerGui.ChatGame
	local CHAT_BOX = CHAT_GAME:FindFirstChild("TextBox")

	local shooties = {}
	

	

	local selected_plyr = nil
	
	local playerz = {
		Enemy = {},
		Team = {}
	}
	
	local mats = {"SmoothPlastic", "ForceField", "Neon", "Foil", "Glass"}
	
	local skelparts = {"Head", "Right Arm", "Right Leg", "Left Leg", "Left Arm"}
	
	local function MouseUnlockAndShootHook()
		if client.logic.currentgun and client.logic.currentgun.shoot then
			local shootgun = client.logic.currentgun.shoot
			if not shooties[client.logic.currentgun.shoot] then
				client.logic.currentgun.shoot = function(self, ...)
					if mp.open then return end
					shootgun(self, ...)
				end
			end
			shooties[client.logic.currentgun.shoot] = true
		end
		if mp.open then
			if client.deploy.isdeployed() then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
			else
				INPUT_SERVICE.MouseIconEnabled = false
			end
		else
			if client.deploy.isdeployed() then
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.LockCenter
				INPUT_SERVICE.MouseIconEnabled = false
			else
				INPUT_SERVICE.MouseBehavior = Enum.MouseBehavior.Default
				INPUT_SERVICE.MouseIconEnabled = true
			end
		end
	end


	local function renderVisuals()
		--------------------------------------world funnies
		if mp.options["Visuals"]["World Visuals"]["Force Time"][1] then
			game.Lighting:SetMinutesAfterMidnight(mp.options["Visuals"]["World Visuals"]["Custom Time"][1])
		end
		if mp.options["Visuals"]["World Visuals"]["Ambience"][1] then
			game.Lighting.Ambient = RGB(mp.options["Visuals"]["World Visuals"]["Ambience"][5][1][1][1][1], mp.options["Visuals"]["World Visuals"]["Ambience"][5][1][1][1][2], mp.options["Visuals"]["World Visuals"]["Ambience"][5][1][1][1][3])
			game.Lighting.OutdoorAmbient = RGB(mp.options["Visuals"]["World Visuals"]["Ambience"][5][1][2][1][1], mp.options["Visuals"]["World Visuals"]["Ambience"][5][1][2][1][2], mp.options["Visuals"]["World Visuals"]["Ambience"][5][1][2][1][3])
		else
			game.Lighting.Ambient = game.Lighting.MapLighting.Ambient.Value
			game.Lighting.OutdoorAmbient = game.Lighting.MapLighting.OutdoorAmbient.Value
		end
		if mp.open then
			client.char.unaimedfov = mp.options["Visuals"]["Local Visuals"]["Camera FOV"][1]
	
			if mp.options["Visuals"]["World Visuals"]["Custom Saturation"][1] then
				game.Lighting.MapSaturation.TintColor = RGB(mp.options["Visuals"]["World Visuals"]["Custom Saturation"][5][1][1], mp.options["Visuals"]["World Visuals"]["Custom Saturation"][5][1][2], mp.options["Visuals"]["World Visuals"]["Custom Saturation"][5][1][3])
				game.Lighting.MapSaturation.Saturation = mp.options["Visuals"]["World Visuals"]["Saturation Density"][1]/50
			else
				game.Lighting.MapSaturation.TintColor = RGB(170,170,170)
				game.Lighting.MapSaturation.Saturation = -0.25
			end
		end
		if mp.options["Visuals"]["Local Visuals"]["Disable ADS FOV"][1] then
			client.cam.basefov = client.char.unaimedfov
		else
			client.cam.basefov = 80
		end
		for k, v in pairs(allesp) do
			for k1, v1 in ipairs(v) do
				if v1.Visible then
					v1.Visible = false
				end
			end
		end
		for k, v in ipairs(allesp.skel) do
			for k1, v1 in ipairs(v) do
				v1.Visible = false
			end
		end
	
	
		local localteam = LOCAL_PLAYER.Team
		playerz.Enemy = {}
		playerz.Team = {}
		for Index, Player in pairs(Players:GetPlayers()) do
			local Body = client.replication.getbodyparts(Player)
			if Body and typeof(Body) == 'table' and rawget(Body, 'rootpart') then
				Player.Character = Body.rootpart.Parent
				if Player.Team ~= localteam then
					table.insert(playerz.Enemy, Player)
				else
					table.insert(playerz.Team, Player)
				end
			end
		end
	
		local playernum = 0
		if client.deploy.isdeployed() then
			for k, v in pairs(playerz) do
	
				for k1, v1 in ipairs(v) do
	
					local playerTorso = v1.Character.Torso
	
					local vTop = playerTorso.CFrame.Position + playerTorso.CFrame.UpVector * 2.3
					local vBottom = playerTorso.CFrame.Position - playerTorso.CFrame.UpVector * 3
	
					local top, topIsRendered = Camera:WorldToViewportPoint(vTop)
					local bottom, bottomIsRendered = Camera:WorldToViewportPoint(vBottom)
	
					local fovMult = mp:getval("Visuals", "Local Visuals", "Camera FOV") / Camera.FieldOfView
	
					local sizeX = math.ceil(2000 / top.Z * fovMult)
					local sizeY = math.ceil(math.max(math.abs(bottom.Y - top.Y), sizeX))
	
					local boxSize = Vector2.new(sizeX, sizeY)
					local boxPosition = Vector2.new(math.floor(top.X * 0.5 + bottom.X * 0.5 - sizeX * 0.5), math.floor(top.Y))
	
					local teem = k .." ESP" -- I MISSPELLEDS IT ONPURPOSE NIGGA
					local health = math.ceil(client.hud:getplayerhealth(v1))
					local spoty = 0
	
	
	
					if (topIsRendered or bottomIsRendered) and client.hud:isplayeralive(v1) then
						playernum += 1
						if mp.options["ESP"][teem]["Name"][1] then
	
							local name = v1.Name
							if mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 1 then
								name = string.lower(name)
							elseif mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 3 then
								name = string.upper(name)
							end
	
							allesp.nametext[playernum].Text = string_cut(name, mp:getval("ESP", "ESP Settings", "Max Text Length"))
							allesp.nametext[playernum].Visible = true
							allesp.nametext[playernum].Position = Vector2.new(boxPosition.X + boxSize.X * 0.5, boxPosition.Y - 15)
							allesp.nametext[playernum].Color = RGB(mp.options["ESP"][teem]["Name"][5][1][1], mp.options["ESP"][teem]["Name"][5][1][2], mp.options["ESP"][teem]["Name"][5][1][3])
							allesp.nametext[playernum].Transparency = mp.options["ESP"][teem]["Name"][5][1][4]/255
	
						end
						if mp.options["ESP"][teem]["Box"][1] then
	
							local transparency = (mp.options["ESP"][teem]["Box"][5][1][4] - 40) / 255
	
							allesp.outerbox[playernum].Visible = true
							allesp.outerbox[playernum].Position = boxPosition
							allesp.outerbox[playernum].Size = boxSize
							allesp.outerbox[playernum].Thickness = 3
							allesp.outerbox[playernum].Transparency = transparency
	
							allesp.box[playernum].Visible = true
							allesp.box[playernum].Position = boxPosition
							allesp.box[playernum].Size = boxSize
							allesp.box[playernum].Color = RGB(mp.options["ESP"][teem]["Box"][5][1][1], mp.options["ESP"][teem]["Box"][5][1][2], mp.options["ESP"][teem]["Box"][5][1][3])
							allesp.box[playernum].Transparency = transparency
	
						end
						if mp.options["ESP"][teem]["Health Bar"][1] then
							local ySizeBar = -math.floor(boxSize.Y * health / 100)
							if mp.options["ESP"][teem]["Health Number"][1] and health <= mp.options["ESP"]["ESP Settings"]["Max HP Visibility Cap"][1] then
								allesp.hptext[playernum].Visible = true
								allesp.hptext[playernum].Text = tostring(health)
	
								local tb = allesp.hptext[playernum].TextBounds
	
								allesp.hptext[playernum].Position = boxPosition + Vector2.new(-tb.X, math.clamp(ySizeBar + boxSize.Y - tb.Y * 0.5, -tb.Y / 4, boxSize.Y - tb.Y))
								allesp.hptext[playernum].Color = RGB(mp.options["ESP"][teem]["Health Number"][5][1][1], mp.options["ESP"][teem]["Health Number"][5][1][2], mp.options["ESP"][teem]["Health Number"][5][1][3])
								allesp.hptext[playernum].Transparency = mp.options["ESP"][teem]["Health Number"][5][1][4]/255
							end
	
							allesp.hpouter[playernum].Visible = true
							allesp.hpouter[playernum].Position = Vector2.new(math.floor(boxPosition.X) - 6, math.floor(boxPosition.y) - 1)
							allesp.hpouter[playernum].Size = Vector2.new(4, boxSize.Y + 2)
	
							allesp.hpinner[playernum].Visible = true
							allesp.hpinner[playernum].Position = Vector2.new(math.floor(boxPosition.X) - 5, math.floor(boxPosition.y + boxSize.Y))
	
							allesp.hpinner[playernum].Size = Vector2.new(2, ySizeBar)
	
							allesp.hpinner[playernum].Color = math.ColorRange(health, {
								[1] = {start = 0, color = Color3.fromRGB(mp.options["ESP"][teem]["Health Bar"][5][1][1][1][1], mp.options["ESP"][teem]["Health Bar"][5][1][1][1][2], mp.options["ESP"][teem]["Health Bar"][5][1][1][1][3])},
								[2] = {start = 100, color = Color3.fromRGB(mp.options["ESP"][teem]["Health Bar"][5][1][2][1][1], mp.options["ESP"][teem]["Health Bar"][5][1][2][1][2], mp.options["ESP"][teem]["Health Bar"][5][1][2][1][3])}
							})
	
						elseif mp.options["ESP"][teem]["Health Number"][1] and health <= mp.options["ESP"]["ESP Settings"]["Max HP Visibility Cap"][1] then
							local hp_sub = 0
							if health < 100 then
								if health < 10 then
									hp_sub = 4
								else
									hp_sub = 2
								end
							end
							allesp.hptext[playernum].Visible = true
							allesp.hptext[playernum].Text = tostring(health)
							allesp.hptext[playernum].Position = Vector2.new(math.floor(bottom.x - sizeX * 0.5 - 1) - math.ceil(allesp.hptext[playernum].TextBounds.x) + 6 - hp_sub, math.floor(top.y - 4))
							allesp.hptext[playernum].Color = RGB(mp.options["ESP"][teem]["Health Number"][5][1][1], mp.options["ESP"][teem]["Health Number"][5][1][2], mp.options["ESP"][teem]["Health Number"][5][1][3])
							allesp.hptext[playernum].Transparency = mp.options["ESP"][teem]["Health Number"][5][1][4]/255
						end
						if mp.options["ESP"][teem]["Held Weapon"][1] then
							local charWeapon = v1.Character:GetChildren()[8]
							local wepname = charWeapon and charWeapon.Name or "KNIFE"
	
							if mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 1 then
								wepname = string.lower(wepname)
							elseif mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 3 then
								wepname = string.upper(wepname)
							end
	
							spoty += 12
							allesp.weptext[playernum].Text = string_cut(wepname, mp:getval("ESP", "ESP Settings", "Max Text Length"))
							allesp.weptext[playernum].Visible = true
							allesp.weptext[playernum].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y))
							allesp.weptext[playernum].Color = RGB(mp.options["ESP"][teem]["Held Weapon"][5][1][1], mp.options["ESP"][teem]["Held Weapon"][5][1][2], mp.options["ESP"][teem]["Held Weapon"][5][1][3])
							allesp.weptext[playernum].Transparency = mp.options["ESP"][teem]["Held Weapon"][5][1][4]/255
						end
						if mp.options["ESP"][teem]["Distance"][1] then
							allesp.disttext[playernum].Text = tostring(math.ceil(bottom.z / 5)).."m" --TODO alan i told you to make this not worldtoscreen based.
							allesp.disttext[playernum].Visible = true
							allesp.disttext[playernum].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y - 2) + spoty)
							allesp.disttext[playernum].Color = RGB(mp.options["ESP"][teem]["Distance"][5][1][1], mp.options["ESP"][teem]["Distance"][5][1][2], mp.options["ESP"][teem]["Distance"][5][1][3])
							allesp.disttext[playernum].Transparency = mp.options["ESP"][teem]["Distance"][5][1][4]/255
						end
						if mp.options["ESP"][teem]["Skeleton"][1] then
							local torso = Camera:WorldToViewportPoint(Vector3.new(v1.Character.Torso.Position.x, v1.Character.Torso.Position.y, v1.Character.Torso.Position.z))
							for k2, v2 in ipairs(skelparts) do
	
								local posie = Camera:WorldToViewportPoint(Vector3.new(v1.Character:FindFirstChild(v2).Position.x, v1.Character:FindFirstChild(v2).Position.y, v1.Character:FindFirstChild(v2).Position.z))
								allesp.skel[k2][playernum].From = Vector2.new(posie.x, posie.y)
								allesp.skel[k2][playernum].To = Vector2.new(torso.x, torso.y)
								allesp.skel[k2][playernum].Visible = true
								allesp.skel[k2][playernum].Color = RGB(mp.options["ESP"][teem]["Skeleton"][5][1][1], mp.options["ESP"][teem]["Skeleton"][5][1][2], mp.options["ESP"][teem]["Skeleton"][5][1][3])
								allesp.skel[k2][playernum].Transparency = mp.options["ESP"][teem]["Skeleton"][5][1][4]/255
	
							end
						end
					end
	
				end
	
			end
			--------------------------------------------------end of player esp!!!! now 4 da oder vizualz
			--poop
			--------------------------------------------------viewmodle shit hahahhaha
			local vm = Camera:GetChildren()
			if mp.options["Visuals"]["Local Visuals"]["Hand Chams"][1] then ---------------------------------------------view model shit
				for k, v in pairs(vm) do
					if v.Name == "Left Arm" or v.Name == "Right Arm" then
						for k1, v1 in pairs(v:GetChildren()) do
							v1.Color = RGB(mp.options["Visuals"]["Local Visuals"]["Hand Chams"][5][1][1], mp.options["Visuals"]["Local Visuals"]["Hand Chams"][5][1][2], mp.options["Visuals"]["Local Visuals"]["Hand Chams"][5][1][3])
							v1.Transparency = 1 + (mp.options["Visuals"]["Local Visuals"]["Hand Chams"][5][1][4]/-255)
							v1.Material = mats[mp.options["Visuals"]["Local Visuals"]["Hand Material"][1]]
	
							if mp.options["Visuals"]["Local Visuals"]["Custom Hand Reflectivity"][1] then
								v1.Reflectance = mp.options["Visuals"]["Local Visuals"]["Hand Reflectivity"][1]/100
							end
							if v1.ClassName == "MeshPart" then
								v1.TextureID = ""
							end
						end
					end
				end
			end
			if mp.options["Visuals"]["Local Visuals"]["Sleeve Chams"][1] then ---------------------------------------------view model shit
				for k, v in pairs(vm) do
	
					if v.Name == "Left Arm" or v.Name == "Right Arm" then
						for k1, v1 in pairs(v:GetChildren()) do
	
							if v1.ClassName == "MeshPart" or v1.Name == "Sleeve" then
								v1.Name = "Sleeve"
								v1.Color = RGB(mp.options["Visuals"]["Local Visuals"]["Sleeve Chams"][5][1][1], mp.options["Visuals"]["Local Visuals"]["Sleeve Chams"][5][1][2], mp.options["Visuals"]["Local Visuals"]["Sleeve Chams"][5][1][3])
								v1.Transparency = 1 + (mp.options["Visuals"]["Local Visuals"]["Sleeve Chams"][5][1][4]/-255)
								v1.Material = mats[mp.options["Visuals"]["Local Visuals"]["Sleeve Material"][1]]
								if mp.options["Visuals"]["Local Visuals"]["Custom Sleeve Reflectivity"][1] then
									v1.Reflectance = mp.options["Visuals"]["Local Visuals"]["Sleeve Reflectivity"][1]/100
								end
								v1:ClearAllChildren()
							end
						
						end
					end
				
				end
			end
			if mp.options["Visuals"]["Local Visuals"]["Weapon Chams"][1] then
				for k, v in pairs(vm) do
					if v.Name ~= "Left Arm" and v.Name ~= "Right Arm" and v.Name ~= "FRAG" then
						for k1, v1 in pairs(v:GetChildren()) do
	
							v1.Color = RGB(mp.options["Visuals"]["Local Visuals"]["Weapon Chams"][5][1][1], mp.options["Visuals"]["Local Visuals"]["Weapon Chams"][5][1][2], mp.options["Visuals"]["Local Visuals"]["Weapon Chams"][5][1][3])
	
							if v1.Transparency ~= 1 then
								v1.Transparency = 0.99999 + (mp.options["Visuals"]["Local Visuals"]["Weapon Chams"][5][1][4]/-255) --- it works shut up + i don't wanna make a fucking table for this shit
							end
							if mp.options["Visuals"]["Local Visuals"]["Remove Weapon Skin"][1] then
								for i2, v2 in pairs(v1:GetChildren()) do
									if v2.ClassName == "Texture" or v2.ClassName == "Decal" then
										v2:Destroy()
									end
								end
							end
							v1.Material = mats[mp.options["Visuals"]["Local Visuals"]["Weapon Material"][1]]
	
							if mp.options["Visuals"]["Local Visuals"]["Custom Weapon Reflectivity"][1] then
								v1.Reflectance = mp.options["Visuals"]["Local Visuals"]["Weapon Reflectivity"][1]/100
							end
						end
					end
				end
			end
			------------------------------------------------------ragdoll chasms
			if mp:getval("Visuals", "Misc Visuals", "Ragdoll Chams") then
				for k, v in ipairs(workspace.Ignore.DeadBody:GetChildren()) do
	
					for k1, v1 in pairs(v:GetChildren()) do
	
						if v1.Material ~= mats[mp:getval("Visuals", "Misc Visuals", "Ragdoll Material")] then
							if v1.Name == "Torso" and v1:FindFirstChild("Pant") then
								v1.Pant:Destroy()
							end
							v1.Color = mp:getval("Visuals", "Misc Visuals", "Ragdoll Chams", "color", true)
							v1.Transparency = 1+(mp:getval("Visuals", "Misc Visuals", "Ragdoll Chams", "color")[4]/-255)
							v1.Material = mats[mp:getval("Visuals", "Misc Visuals", "Ragdoll Material")]
							if v1:FindFirstChild("Mesh") then
								v1.Mesh:Destroy()
							end
						end
	
					end
	
				end
			end
	
			-- do --watermark shittiez
			-- 	local wme = mp:getval("Settings", "Menu Settings", "Watermark")
			-- 	for k, v in pairs(allesp.watermark.rect) do
			-- 		v.Visible = wme
			-- 	end
			-- 	allesp.watermark.text[1].Visible = wme
			-- end
		end
	end
	
	local function renderChams()
		for k, Player in pairs(Players:GetPlayers()) do
	
			local Body = client.replication.getbodyparts(Player)
			if Body then
				local enabled
				local col
				local vTransparency
	
				local xqz
				local ivTransparency
	
				if Player.Team ~= Players.LocalPlayer.Team then
					enabled = mp:getval("ESP", "Enemy ESP", "Chams")
					col = mp:getval("ESP", "Enemy ESP", "Chams", "color2", true)
					vTransparency = 1 - mp:getval("ESP", "Enemy ESP", "Chams", "color2")[4]/255
					xqz = mp:getval("ESP", "Enemy ESP", "Chams", "color1", true)
					ivTransparency = 1 - mp:getval("ESP", "Enemy ESP", "Chams", "color1")[4]/255
				else
					enabled = mp:getval("ESP", "Team ESP", "Chams")
					col = mp:getval("ESP", "Team ESP", "Chams", "color2", true)
					vTransparency = 1 - mp:getval("ESP", "Team ESP", "Chams", "color2")[4]/255
					xqz = mp:getval("ESP", "Team ESP", "Chams", "color1", true)
					ivTransparency = 1 - mp:getval("ESP", "Team ESP", "Chams", "color1")[4]/255
				end
	
	
				Player.Character = Body.rootpart.Parent
				for k1, Part in pairs(Player.Character:GetChildren()) do
	
					if Part.ClassName ~= "Model" and Part.Name ~= "HumanoidRootPart" then
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
									box.Height = Part.Size.Y + 0.3
									box.Radius = Part.Size.X * 0.5 + 0.2
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
								adorn.Color3 = i == 0 and col or xqz
								adorn.Visible = enabled
	
							end
						end
					end
	
				end
			end
		end
	end
	
	local keybindtoggles = { -- ANCHOR keybind toggles
		fly = false,
		thirdperson = false,
	}
	local send = client.net.send
	
	
	
	do --ANCHOR metatable hookz
	
		local mt = getrawmetatable(game)
	
		local oldNewIndex = mt.__newindex
		local oldIndex = mt.__index
	
		setreadonly(mt, false)
	
		mt.__newindex = newcclosure(function(self, id, val)
			if mp:getval("Visuals", "Local Visuals", "Third Person") and keybindtoggles.thirdperson and self == workspace.Camera and id == "CFrame" then
				local dist = mp:getval("Visuals", "Local Visuals", "Third Person Distance") / 10
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Blacklist
				params.FilterDescendantsInstances = {Camera, workspace.Ignore, workspace.Players}
	
				local hit = workspace:Raycast(val.p, -val.LookVector * dist, params)
				local mag = hit and (hit.Position - val.p).Magnitude or nil
	
				val *= CFrame.new(0, 0, mag and mag or dist)
			end
			return oldNewIndex(self, id, val)
		end)
		mt.__index = newcclosure(function(table, key)
			return oldIndex(table, key)
		end)
	
		setreadonly(mt, true)
	
	end
	
	local camera = {}
	do--ANCHOR camera function definitions.
	
		function camera:GetGun()
	
	
			for k, v in pairs(Camera:GetChildren()) do
	
				if v.Name ~= "Right Arm" and v.Name ~= "Left Arm" then
					return v
				end
	
			end
	
	
		end
	
		function camera:GetFOV(Part)
	
	
			local directional = CFrame.new(workspace.Camera.CFrame.Position, Part.Position)
			local ang = Vector3.new(directional:ToOrientation()) - Vector3.new(workspace.Camera.CFrame:ToOrientation())
			return math.deg(ang.Magnitude)
	
	
		end
	
		function camera:IsVisible(Part, origin)
	
	
			origin = origin or Camera.CFrame.Position
	
			local hit, position = workspace:FindPartOnRayWithIgnoreList(Ray.new(origin, Part.Position - origin), {Camera, workspace.Ignore, workspace.Players})
			--print(position, Part.Position)
			return position == Part.Position
	
	
		end
	
		function camera:GetTrajectory(pos, origin)
	
	
			origin = origin or Camera.CFrame.Position
	
			return origin + client.trajectory(origin, CACHED_VEC3, GRAVITY, pos, CACHED_VEC3, CACHED_VEC3, client.logic.currentgun.data.bulletspeed)
	
	
		end
	
	end
	
	local ragebot = {}
	do--ANCHOR ragebot definitions
		local tpIgnore = {workspace.Players, workspace.Ignore, workspace.CurrentCamera}
		local nadeSize = Vector3.new(0, 50, 0)
		local tpSelfDecreaseOffset = Vector3.new(0, 2, 0)
	
		function ragebot:AntiNade(pos)
	
	
			if mp:getval("Rage", "Anti Aim", "Anti Grenade Teleport") and mp:getval("Rage", "Anti Aim", "Enabled") then
				local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(char, nadeSize), tpIgnore, true, true)
				if hit then return pos end
				
				return pos + nadeSize
			end
	
	
		end
	
		function ragebot:GetKnifeTargets()

			local results = {}
	
			for i, ply in ipairs(Players:GetPlayers()) do
	
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
			if not client.deploy.isdeployed() then return end
			if not LOCAL_PLAYER.Character or not LOCAL_PLAYER.Character:FindFirstChild("HumanoidRootPart") then return end

			local key = mp:getval("Rage", "Extra", "Knife Bot", "keybind")
			if mp:getval("Rage", "Extra", "Knife Bot") and (key == nil or INPUT_SERVICE:IsKeyDown(key)) then
				local knifetype = mp:getval("Rage", "Extra", "Knife Bot Type")
				if knifetype == 2 then
					ragebot:KnifeAura()
				elseif knifetype == 3 then
					ragebot:FlightAura()
				elseif knifetype == 4 then 
					ragebot:TPAura()
				end
			end
		end
	
		function ragebot:FlightAura()
			local targets = ragebot:GetKnifeTargets()
			
			for i, target in pairs(targets) do
				if not target.insight then continue end
				
				LOCAL_PLAYER.Character.HumanoidRootPart.Velocity = target.direction.Unit * 200

				return ragebot:KnifeAura(targets)
			end
		end

		function ragebot:TPAura()
			local targets = ragebot:GetKnifeTargets()
			
			for i, target in pairs(targets) do
				if not target.insight then continue end
				
				LOCAL_PLAYER.Character:SetPrimaryPartCFrame(CFrame.new(target.tppos + Vector3.new(0,2,0)))

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
			send(client.net, "repupdate", cfc.p, client.cam.angles) -- Makes knife aura work with anti nade tp
			if stab then send(client.net, "stab") end
			send(client.net, "knifehit", target.player, tick(), target.part)
		end
	
	
		local lastTick
		function ragebot:StanceLoop()
	
	
			if LOCAL_PLAYER.Character and LOCAL_PLAYER.Character:FindFirstChild("Humanoid") then
				if mp:getval("Rage", "Anti Aim", "Hide in Floor") and mp:getval("Rage", "Anti Aim", "Enabled") then
					LOCAL_PLAYER.Character.Humanoid.HipHeight = -1.9
				else
					LOCAL_PLAYER.Character.Humanoid.HipHeight = 0
				end
			end
			local curTick = math.floor(tick())
			if curTick % 1 == 0 and curTick ~= lastTick then
				lastTick = curTick
				if mp:getval("Rage", "Anti Aim", "Enabled") then
					local stanceId = mp:getval("Rage", "Anti Aim", "Force Stance")
					if stanceId ~= 1 then
						local newStance = --ternary sex
							stanceId == 2 and "stand"
							or stanceId == 3 and "crouch"
							or stanceId == 4 and "prone"
	
						send(client.net, "stance", newStance)
					end
					if mp:getval("Rage", "Anti Aim", "Lower Arms") then
						send("sprint", true)
					end
				end
			end
	
	
		end
	
	
	end
	do--ANCHOR misc hooks
		--anti afk
		local VirtualUser = game:GetService("VirtualUser")
		LOCAL_PLAYER.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2new)
		end)
	
		local shake = client.cam.shake
		client.cam.shake = function(self, magnitude)
			if mp:getval("Legit", "Recoil Control", "Reduce Camera Recoil") then
				local scale = mp:getval("Legit", "Recoil Control", "Camera Recoil Amount") * 0.01
				magnitude *= scale
			end
			return shake(client.cam, magnitude)
		end
	
		local suppress = client.cam.suppress
		client.cam.suppress = function(...)
			if mp:getval("Visuals", "Local Visuals", "No Visual Suppression") then return end
			return suppress(...)
		end
	
	end
	
	do--ANCHOR send hook
		client.net.send = function(self, ...)
			local args = {...}
			if args[1] == "stance" and mp:getval("Rage", "Anti Aim", "Force Stance") ~= 1 then return end
			if args[1] == "sprint" and mp:getval("Rage", "Anti Aim", "Lower Arms") then return end
			if args[1] == "falldamage" and mp:getval("Misc", "Movement", "Prevent Fall Damage") then return end
			if args[1] == "stab" then
				local key = mp:getval("Rage", "Extra", "Knife Bot", "keybind")
				if mp:getval("Rage", "Extra", "Knife Bot") and not key or INPUT_SERVICE:IsKeyDown(key) then
					if mp:getval("Rage", "Extra", "Knife Bot Type") == 1 then
						ragebot:KnifeTarget(ragebot:GetKnifeTargets()[1])
					end
				end
			end
			if args[1] == "repupdate" and mp:getval("Rage", "Anti Aim", "Enabled") then
				args[2] = ragebot:AntiNade(args[2])
				local pitch = args[3].X
				local yaw = args[3].Y
	
				local pitchChoice = mp:getval("Rage", "Anti Aim", "Pitch")
				local yawChoice = mp:getval("Rage", "Anti Aim", "Yaw")
				---"off,down,up,roll,upside down,random"
				--{"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random"} pitch
				--{"Off", "Backward", "Spin", "Random"} yaw
	
				if pitchChoice == 2 then
					pitch = -4
				elseif pitchChoice == 3 then
					pitch = 0
				elseif pitchChoice == 4 then
					pitch = 4.7
				elseif pitchChoice == 5 then
					pitch = -math.pi
				elseif pitchChoice == 6 then
					pitch = tick() * 0.01
				elseif pitchChoice == 7 then
					pitch = -tick() * 0.01
				elseif pitchChoice == 8 then
					pitch = math.random(0)
				end
	
				if yawChoice == 2 then
					yaw += math.pi
				elseif yawChoice == 3 then
					yaw = (tick() * 0.01) % 12
				elseif yawChoice == 4 then
					yaw = math.random(0)
				end
	
				-- yaw += jitter
	
				args[3] = Vector3.new(pitch, yaw, 0)
			end
			return send(self, unpack(args))
		end
	end
	
	local legitbot = {}
	do -- ANCHOR Legitbot definition defines legit functions
	
		function legitbot:MainLoop()
	
	
			if not mp.open and INPUT_SERVICE.MouseBehavior ~= Enum.MouseBehavior.Default and mp:getval("Legit", "Aim Assist", "Enabled") and client.logic.currentgun then
				local keybind = mp:getval("Legit", "Aim Assist", "Aimbot Key") - 1
				local smoothing = (mp:getval("Legit", "Aim Assist", "Smoothing Factor") + 2) * 0.2 / GAME_SETTINGS.MouseSensitivity
				local fov = mp:getval("Legit", "Aim Assist", "Aimbot FOV")
				local sFov = mp:getval("Legit", "Bullet Redirection", "Silent Aim FOV")
	
				local hitboxPriority = mp:getval("Legit", "Aim Assist", "Hitscan Priority") == 1 and "head" or "torso"
				local hitscan = not mp:getval("Legit", "Aim Assist", "Force Priority Hitbox")
	
				if client.logic.currentgun.type ~= "KNIFE" and INPUT_SERVICE:IsMouseButtonPressed(keybind) or keybind == 2 then
					local targetPart, closest = legitbot:GetTargetLegit(hitboxPriority, hitscan) -- we will use the players parameter once player list is added.
					if targetPart and closest < fov then
						legitbot:AimAtTarget(targetPart, smoothing)
					end
					if targetPart and closest < sFov then
						legitbot:SilentAimAtTarget(targetPart)
					end
				end
			end
	
	
		end
	
		function legitbot:AimAtTarget(targetPart, smoothing)
	
	
			if not targetPart then return end
	
			local Pos, visCheck
	
			if mp:getval("Legit", "Aim Assist", "Adjust for Bullet Drop") then
				pos, visCheck = Camera:WorldToScreenPoint(camera:GetTrajectory(targetPart.Position + targetPart.Velocity, Camera.CFrame.Position))
			else
				Pos, visCheck = Camera:WorldToScreenPoint(targetPart.Position)
			end
			if mp:getval("Legit", "Aim Assist", "Enable Randomization") then
				local randMag = mp:getval("Legit", "Aim Assist", "Randomization") * 5
				Pos += Vector3.new(math.noise(time()*0.1, 0.1) * randMag, math.noise(time()*0.1,time()) * randMag, 0)
			end
	
			local aimbotMovement = Vector2.new(Pos.X - LOCAL_MOUSE.X, Pos.Y - LOCAL_MOUSE.Y)
	
			mousemoverel(aimbotMovement.X / smoothing, aimbotMovement.Y / smoothing)
	
	
		end
	
		function legitbot:SilentAimAtTarget(targetPart)
	
	
			if not targetPart then return end
	
	
	
		end
	
	
	
		function legitbot:GetTargetLegit(partPreference, hitscan, players)
	
	
			local closest, closestPart = math.huge
			partPreference = partPreference or "head"
			hitscan = hitscan or false
			players = players or game.Players:GetPlayers()
	
			for i, Player in pairs(players) do
	
				if Player.Team ~= LOCAL_PLAYER.Team then
					local Parts = client.replication.getbodyparts(Player)
					if Parts then
						if hitscan then
							for i1, Bone in pairs(Parts) do
	
								if Bone.ClassName == "Part" then
									if camera:GetFOV(Bone) < closest then
										if camera:IsVisible(Bone) then
											closest = camera:GetFOV(Bone)
											closestPart = Bone
										end
									end
								end
	
							end
						end
						local PriorityBone = Parts[partPreference]
						if PriorityBone and camera:GetFOV(PriorityBone) < closest then
							if camera:IsVisible(PriorityBone) then
								closest = camera:GetFOV(PriorityBone)
								closestPart = PriorityBone
							end
						end
					end
				end
	
			end
			return closestPart, closest
	
	
		end
	
		function legitbot:TriggerBot()
	
	
			if INPUT_SERVICE:IsKeyDown(mp:getval("Legit", "Trigger Bot", "Enabled", "keybind")) then
				local parts = mp:getval("Legit", "Trigger Bot", "Trigger Bot Hitboxes")
	
				parts["Head"] = parts[1]
				parts["Torso"] = parts[2]
				parts["Right Arm"] = parts[3]
				parts["Left Arm"] = parts[3]
				parts["Right Leg"] = parts[4]
				parts["Left Leg"] = parts[4]
	
				local gun = camera:GetGun()
				if not gun then return end
	
				local barrel = gun.Flame
				if barrel and client.logic.currentgun then
					local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(barrel.CFrame.Position, barrel.CFrame.LookVector*5000), {Camera, workspace.Players[LOCAL_PLAYER.Team.Name], workspace.Ignore})
	
					if hit and parts[hit.Name] then
						if not camera:IsVisible(hit) then return end
						client.logic.currentgun:shoot(true)
					else
						client.logic.currentgun:shoot(false)
					end
				end
			end
	
	
		end
	
	
	end
	
	local movement = {}
	do -- ANCHOR movement definitionz
		local rootpart
		local humanoid
	
		function movement:RoundFreeze()
			if mp:getval("Misc", "Movement", "Ignore Round Freeze") then
				client.roundsystem.lock = false
			end
		end
	
		function movement:FlyHack()
	
	
			if mp:getval("Misc", "Movement", "Fly Hack") and keybindtoggles.flyhack then
				local speed = mp:getval("Misc", "Movement", "Fly Hack Speed")
				
				local travel = CACHED_VEC3
				local looking = Camera.CFrame.lookVector --getting camera looking vector
				local upVector = Camera.CFrame.UpVector
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
					travel += upVector
				end
				if INPUT_SERVICE:IsKeyDown(Enum.KeyCode.LeftShift) then
					travel -= upVector
				end
				
				if travel.Unit.X == travel.Unit.X then
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
	
		function movement:SpeedHack()
	
	
			local type = mp:getval("Misc", "Movement", "Speed Hack")
			if type ~= 1 then
				local speed = mp:getval("Misc", "Movement", "Speed Hack Speed")
	
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
	
				travel = Vector2.new(travel.X, travel.Z).Unit
	
				if travel.X == travel.X then
					if type == 3 and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
						return
					elseif type == 4 and not humanoid.Jump then
						return
					end
					rootpart.Velocity = Vector3.new(travel.X * speed, rootpart.Velocity.Y, travel.Y * speed)
				end
			end
		
		
		end
		
		function movement:AutoJump()
	
	
			if mp:getval("Misc", "Movement", "Auto Jump") and INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space) then
				humanoid.Jump = true
			end
	
	
		end
	
		function movement:GravityShift()
	
	
			if mp:getval("Misc", "Movement", "Gravity Shift") then
				local scaling = mp:getval("Misc", "Movement", "Gravity Shift Percentage")
				local mappedGrav = math.map(scaling, -100, 100, 0, 196.2)
				workspace.Gravity = 196.2 + mappedGrav
			else
				workspace.Gravity = 196.2
			end
	
	
		end
	
		function movement:MainLoop()
	
	
			rootpart = LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.HumanoidRootPart
			humanoid = LOCAL_PLAYER.Character and LOCAL_PLAYER.Character.Humanoid
			if rootpart and humanoid then
				if not CHAT_BOX.Active then
					movement:FlyHack()
					movement:SpeedHack()
					movement:AutoJump()
					movement:GravityShift()
					movement:RoundFreeze()
				elseif keybindtoggles.flyhack then
					rootpart.Anchored = true
				end
			end
	
	
		end
	end
	
	local keycheck = INPUT_SERVICE.InputBegan:Connect(function(key)
		inputBeganMenu(key)
		if mp:getval("Visuals", "Local Visuals", "Third Person") and key.KeyCode == mp:getval("Visuals", "Local Visuals", "Third Person", "keybind") then
			keybindtoggles.thirdperson = not keybindtoggles.thirdperson
		end
		if mp:getval("Misc", "Movement", "Fly Hack") and key.KeyCode == mp:getval("Misc", "Movement", "Fly Hack", "keybind") then
			keybindtoggles.flyhack = not keybindtoggles.flyhack
		end
	end)
	
	local renderstepped = game.RunService.RenderStepped:Connect(function()
		MouseUnlockAndShootHook()
		do --rendering
			renderVisuals()
			renderChams()
		end
		do--legitbot
			legitbot:TriggerBot()
			legitbot:MainLoop()
		end
		do --movement
			movement:MainLoop()
		end
		do--ragebot
			ragebot:KnifeBotMain()
		end
	end)
	
	
	local heartbeat = game.RunService.Heartbeat:Connect(function()
		ragebot:StanceLoop()
	end)
	BBMenuInit({
		{--ANCHOR Legit
			name = "Legit",
			content = {
				{
					name = "Aim Assist",
					x = 17,
					y = 66,
					width = mp.columns.width,
					height = 332,
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
							minvalue = 0,
							maxvalue = 180,
							stradd = "°"
						},
						{
							type = "slider",
							name = "Smoothing Factor",
							value = 20,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
						{
							type = "toggle",
							name = "Enable Randomization",
							value = false
						},
						{
							type = "slider",
							name = "Randomization",
							value = 5,
							minvalue = 0,
							maxvalue = 20
						},
						{
							type = "toggle",
							name = "Enable Deadzone",
							value = false
						},
						{
							type = "slider",
							name = "Deadzone FOV",
							value = 5,
							minvalue = 0,
							maxvalue = 30,
							stradd = "°"
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
							type = "toggle",
							name = "Force Priority Hitbox",
							value = false
						},
						{
							type = "toggle",
							name = "Adjust for Bullet Drop",
							value = false
						},
						{
							type = "toggle",
							name = "Aim at Backtrack",
							value = false
						},
					}
				},
				{
					name = "Position Adjustment",
					x = mp.columns.left,
					y = 404,
					width = mp.columns.width,
					height = 76,
					content = {
						{
							type = "toggle",
							name = "Enable Backtrack",
							value = false
						},
						{
							type = "slider",
							name = "Backtrack Time",
							value = 1000,
							minvalue = 0,
							maxvalue = 5000,
							stradd = "ms"
						},
					},
				},
				{
					name = "Bullet Redirection",
					x = mp.columns.left,
					y = 486,
					width = mp.columns.width,
					height = 97,
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
							minvalue = 0,
							maxvalue = 180,
							stradd = "°"
						}
					}
				},
				{
					name = "Trigger Bot",
					x = mp.columns.right,
					y = 66,
					width = mp.columns.width,
					height = 254,
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
							name = "Trigger on Backtrack",
							value = false
						},
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
						},
						{
							type = "toggle",
							name = "Force Priority Hitbox",
							value = false
						},
					}
				},
				{
					name = "Recoil Control",
					x = mp.columns.right,
					y = 326,
					width = mp.columns.width,
					height = 257,
					content = {
						{
							type = "toggle",
							name = "Reduce Camera Recoil",
							value = false
						},
						{
							type = "slider",
							name = "Camera Recoil Amount",
							value = 10,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%"
						},
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
		{--ANCHOR Rage
			name = "Rage",
			content = {
				{
					name = "Aimbot",
					x = mp.columns.left,
					y = 66,
					width = mp.columns.width,
					height = 272,
					content = {
						{
							type = "toggle",
							name = "Enabled",
							value = false,
							extra = {
								type = "keybind",
							}
						},
						{
							type = "toggle",
							name = "Silent Aim",
							value = false,
						},
						{
							type = "slider",
							name = "Aimbot FOV",
							value = 90,
							minvalue = 0,
							maxvalue = 180,
							stradd = "°"
						},
						{
							type = "slider",
							name = "Min Damage",
							value = 50,
							minvalue = 1,
							maxvalue = 100,
							stradd = "hp"
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
							type = "toggle",
							name = "Auto Scope",
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
							name = "Force Priority Hitbox",
							value = false
						},
					},
				},
				{
					name = "Hack vs. Hack",
					x = mp.columns.right,
					y = 66,
					width = mp.columns.width,
					height = 156,
					content = {
						{
							type = "toggle",
							name = "Multipoint Resolver",
							value = false
						},
						{
							type = "slider",
							name = "Multipoint Size",
							value = 2,
							minvalue = 1,
							maxvalue = 10
						},
						{
							type = "toggle",
							name = "Autowall Resolver",
							value = false
						},
						{
							type = "slider",
							name = "Autowall Resolver Points",
							value = 0,
							minvalue = 0,
							maxvalue = 10,
							stradd = " points"
						},
						{
							type = "slider",
							name = "Autowall Resolver Step",
							value = 50,
							minvalue = 5,
							maxvalue = 100,
							stradd = " studs"
						}
					}
				},
				{
					name = "Extra",
					x = mp.columns.left,
					y = 344,
					width = mp.columns.width,
					height = 200,
					content = {
						{
							type = "toggle",
							name = "Knife Bot",
							value = false,
							extra = {
								type = "keybind",
							}
						},
						{
							type = "dropbox",
							name = "Knife Bot Type",
							value = 2,
							values = {"Assist", "Multi Aura", "Flight Aura", "Teleport Aura"}
						},
					},
				},
				{
					name = "Anti Aim",
					x = mp.columns.right,
					y = 228,
					width = mp.columns.width,
					height = 250,
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
							values = {"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random"}
						},
						{
							type = "dropbox",
							name = "Yaw",
							value = 2,
							values = {"Forward", "Backward", "Spin", "Random"}
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
							name = "Anti Grenade Teleport",
							value = false,
						},
					}
				},
			}
		},
		{--ANCHOR ESP
			name = "ESP",
			content = {
				{
					name = "Enemy ESP",
					x = mp.columns.left,
					y = 66,
					width = mp.columns.width,
					height = 224,
					content = {
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
							name = "Level",
							value = false,
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
							name = "Backtrack Chams",
							value = false,
							extra = {
								type = "double colorpicker",
								name = {"Late Backtrack Ticks", "Early Backtrack Ticks"},
								color = {{255, 0, 0, 255}, {255, 255, 255, 255}}
							}
						},
						{
							type = "toggle",
							name = "Show Only Last Backtack",
							value = false
						},
					}
				},
				{
					name = "Team ESP",
					x = mp.columns.right,
					y = 66,
					width = mp.columns.width,
					height = 188,
					content = {
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
							name = "Level",
							value = false,
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
					x = mp.columns.right,
					y = 260,
					width = mp.columns.width,
					height = 323,
					content = {
						{
							type = "toggle",
							name = "Box Text Outline",
							value = false,
						},
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
							maxvalue = 32
						},
						{
							type = "toggle",
							name = "Show Aimbotted Target",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Aimbot Target",
								color = {255, 0, 0, 255}
							}
						},
						{
							type = "toggle",
							name = "Show Friended Players",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Friended Players",
								color = {0, 255, 0, 255}
							}
						},
						{
							type = "toggle",
							name = "Show Priority Players",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Priority Players",
								color = {255, 210, 0, 255}
							}
						},
					}
				},
				{
					name = "Dropped Esp",
					x = mp.columns.left,
					y = 296,
					width = mp.columns.width,
					height = 287,
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
							name = "Nade Range",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Nade Range",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "toggle",
							name = "Nade Fuse Time",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Nade Fuse Time",
								color = {255, 255, 255, 255}
							}
						}
					}
				},
			}
		},
		{--ANCHOR Visuals
			name = "Visuals",
			content = {
				{
					name = "Local Visuals",
					x = mp.columns.left,
					y = 66,
					width = mp.columns.width,
					height = 517,
					content = {
						{
							type = "toggle",
							name = "Sleeve Chams",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Sleeve Chams",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "dropbox",
							name = "Sleeve Material",
							value = 1,
							values = {"Plastic", "Ghost", "Neon", "Foil", "Glass"}
						},
						{
							type = "toggle",
							name = "Custom Sleeve Reflectivity",
							value = false,
						},
						{
							type = "slider",
							name = "Sleeve Reflectivity",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%",
						},
						{
							type = "toggle",
							name = "Hand Chams",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Hand Chams",
								color = {255, 255, 255, 255}
							}
						},
						{
							type = "dropbox",
							name = "Hand Material",
							value = 1,
							values = {"Plastic", "Ghost", "Neon", "Foil", "Glass"}
						},
						{
							type = "toggle",
							name = "Custom Hand Reflectivity",
							value = false,
						},
						{
							type = "slider",
							name = "Hand Reflectivity",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%",
						},
						{
							type = "toggle",
							name = "Weapon Chams",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Weapon Chams",
								color = {255, 255, 255, 255}
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
							name = "Custom Weapon Reflectivity",
							value = false,
						},
						{
							type = "slider",
							name = "Weapon Reflectivity",
							value = 0,
							minvalue = 0,
							maxvalue = 100,
							stradd = "%",
						},
						{
							type = "toggle",
							name = "Remove Weapon Skin",
							value = false,
						},
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
						}

					}
				},
				{
					name = "World Visuals",
					x = mp.columns.right,
					y = 66,
					width = mp.columns.width,
					height = 175,
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
							maxvalue = 1400,
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
					x = mp.columns.right,
					y = 371,
					width = mp.columns.width,
					height = 212,
					content = {
						{
							type = "toggle",
							name = "Custom Blood Color",
							value = false,
							extra = {
								type = "single colorpicker",
								name = "Blood",
								color = {255, 255, 255, 255}
							},
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
		{--ANCHOR Misc
			name = "Misc",
			content = {
				{
					name = "Movement",
					x = mp.columns.left,
					y = 66,
					width = mp.columns.width,
					height = 517,
					content = {
						{
							type = "toggle",
							name = "Fly Hack",
							value = false,
							extra = {
								type = "keybind",
								key = Enum.KeyCode.B
							}
						},
						{
							type = "slider",
							name = "Fly Hack Speed",
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
							type = "dropbox",
							name = "Speed Hack",
							value = 1,
							values = {"Off", "Always", "In Air", "On Hop"}
						},
						{
							type = "slider",
							name = "Speed Hack Speed",
							value = 40,
							minvalue = 1,
							maxvalue = 200,
							stradd = " stud/s"
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
						},
					},
				},
			}
		},
		{--ANCHOR Settings
			name = "Settings",
			content = {
				{
					name = "Player List",
					x = mp.columns.left,
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
						}
					}
				},
				{
					name = "Menu Settings",
					x = mp.columns.left,
					y = 400,
					width = mp.columns.width,
					height = 62,
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
					}
				},
				{
					name = "Extra",
					x = mp.columns.left,
					y = 468,
					width = mp.columns.width,
					height = 115,
					content = {
						{
							type = "button",
							name = "Set Clipboard Game ID"
						},
						{
							type = "button",
							name = "Unload Cheat"
						}
					}
				},
				{
					name = "Configuration",
					x = mp.columns.right,
					y = 400,
					width = mp.columns.width,
					height = 183,
					content = {
						{
							type = "dropbox",
							name = "Configs",
							value = 1,
							values = {"Config 1", "Config 2", "Config 3", "Config 4", "Config 5", "Config 6"}
						},
						{
							type = "button",
							name = "Load Config"
						},
						{
							type = "button",
							name = "Save Config"
						},
						{
							type = "button",
							name = "Delete Config"
						},
					}
				}
			}
		},
	})
	do --TODO alan put this shit into a function so you don't have to copy paste it thanks
		local plistinfo = mp.options["Settings"]["Player List"]["Player Info"][1]
		local plist = mp.options["Settings"]["Player List"]["Players"]
		local playerpictures = {}
		local function updateplist()
			local playerlistval = mp:getval("Settings", "Player List", "Players")
			local playerz = Players:GetPlayers()
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
				end
				table.insert(templist, {plyrname, teamtext, plyrstatus})
			end
			plist[5] = templist
			if playerlistval ~= nil then
				for i, v in ipairs(playerz) do
					if v.Name == playerlistval then
						selected_plyr = v
						break
					end
					if i == #playerz then
						selected_plyr = nil
						mp.list.setval(plist, nil)
					end
				end
			end
			mp:set_menu_pos(mp.x, mp.y)
		end

		local function cacheAvatars()
			for i, v in ipairs(Players:GetPlayers()) do
				if not table.contains(playerpictures, v) then
					local content = Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
					playerpictures[v] = game:HttpGet(content)
				end
			end
		end

		local function setplistinfo(player, textonly)
			if player ~= nil then	
				local playerteam = "None"
				if player.Team ~= nil then
					playerteam = player.Team.Name
				end
				local playerhealth = "?"

				
				local humanoid = player:FindFirstChild("Humanoid")
				if humanoid ~= nil then 
					if humanoid.Health ~= nil then
						playerhealth = tostring(humanoid.Health).. "/".. tostring(humanoid.MaxHealth)
					else
						playerhealth = "No health found"
					end
				else
					playerhealth = "Humanoid not found"
				end

				plistinfo[1].Text = "Name: ".. player.Name.."\nTeam: ".. playerteam .."\nHealth: ".. playerhealth

				if textonly == nil then
					plistinfo[2].Data = playerpictures[player]
				end
			else
				plistinfo[2].Data = BBOT_IMAGES[5]	
				plistinfo[1].Text = "No Player Selected"
			end
		end

		mp.list.removeall(mp.options["Settings"]["Player List"]["Players"])
		updateplist()
		cacheAvatars()
		setplistinfo(nil)

		mp.connections.inputstart2 = INPUT_SERVICE.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if mp.tabnum2str[mp.activetab] == "Settings" and mp.open then
					game.RunService.Stepped:wait()
					updateplist()
					if plist[1] ~= nil then
						setplistinfo(selected_plyr)
					else
						setplistinfo(nil)
					end
				end
			end
		end)

		mp.connections.renderstepped2 = game.RunService.RenderStepped:Connect(function()
			if mp.open then
				if mp.tabnum2str[mp.activetab] == "Settings" then
					if plist[1] ~= nil then
						setplistinfo(selected_plyr, true)
					end
				end
			end
		end)

		mp.connections.playerjoined = Players.PlayerAdded:Connect(function(player)
			updateplist()
			cacheAvatars()
			if plist[1] ~= nil then
				setplistinfo(selected_plyr)
			else
				setplistinfo(nil)
			end
		end)
		
		mp.connections.playerleft = Players.PlayerRemoving:Connect(function(player)
			updateplist()
		end)
	end
end
