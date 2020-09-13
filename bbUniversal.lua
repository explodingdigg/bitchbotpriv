
-- nate i miss u D:

-- im back :D

setfpscap(300) -- nigga roblox

if not isfolder("bitchbot") then
	makefolder("bitchbot")
end

if not isfolder("bitchbot/uni") then
	makefolder("bitchbot/uni")
end

for i = 1, 6 do
	if not isfile("bitchbot/uni/config"..tostring(i)..".bb") then
		writefile("bitchbot/uni/config"..tostring(i)..".bb", "")
	end
end

local MainPlayer = game.Players.LocalPlayer
local mouse = MainPlayer:GetMouse()
local Input = game:GetService("UserInputService")

local function table_contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local function Clamp(a, lowerNum, higher)
    if a > higher then
        return higher
    elseif a < lowerNum then
        return lowerNum
    else
        return a
    end
end

local function Lerp(delta, from, to)
	if (delta > 1) then
		return to
	end
	if (delta < 0) then
		return from
	end
	return from + ( to - from ) * delta
end

local function ColorRange(value, ranges) -- ty tony for dis function u a homie
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

local allrender = {}
local function unrender()
	for k, v in pairs(allrender) do
		for k1, v1 in pairs(v) do
			v1:Remove()
		end
	end
end

local RGB = Color3.fromRGB

local function draw_outlined_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)
	local temptable = Drawing.new("Square")
	temptable.Visible = visible
	temptable.Position = Vector2.new(pos_x, pos_y)
	temptable.Size = Vector2.new(width, hieght)
	temptable.Color = RGB(clr[1], clr[2], clr[3])
	temptable.Filled = false
	temptable.Thickness = 0
	temptable.Transparency = clr[4] / 255
	table.insert(tablename, temptable)
	if not table_contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

local function draw_filled_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)
	local temptable = Drawing.new("Square")
	temptable.Visible = visible
	temptable.Position = Vector2.new(pos_x, pos_y)
	temptable.Size = Vector2.new(width, hieght)
	temptable.Color = RGB(clr[1], clr[2], clr[3])
	temptable.Filled = true
	temptable.Thickness = 0
	temptable.Transparency = clr[4] / 255
	table.insert(tablename, temptable)
	if not table_contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

local function draw_image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
	local temptable = Drawing.new("Image")
	temptable.Visible = visible
	temptable.Position = Vector2.new(pos_x, pos_y)
	temptable.Size = Vector2.new(width, hieght)
	temptable.Transparency = transparency
	temptable.Data = game:HttpGet(imagedata)
	table.insert(tablename, temptable)
	if not table_contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

local function draw_text(text, font, visible, pos_x, pos_y, size, centered, clr, tablename)
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
	if not table_contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

local function draw_outlined_text(text, font, visible, pos_x, pos_y, size, centered, clr, clr2, tablename)
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
	if not table_contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

local function draw_tri(visible, filled, pa, pb, pc, clr, tablename)
	local temptable = Drawing.new("Triangle")
	temptable.Visible = visible
	temptable.Transparency = clr[4]
	temptable.Color = RGB(clr[1], clr[2], clr[3])
	temptable.Thickness = 3.9
	temptable.PointA = Vector2.new(pa[1], pa[2])
	temptable.PointB = Vector2.new(pb[1], pb[2])
	temptable.PointC = Vector2.new(pc[1], pc[2])
	temptable.Filled = filled
	table.insert(tablename, temptable)
	if not table_contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end


local mp = { -- this is for menu stuffs n shi
	w = 500,
	h = 600,
	x = 200,
	y = 200,
	activetab = 1, -- do not change this value please its not made to be fucked with sorry
	open = true,
	fadespeed = 50,
	fading = false,
	postable = {},
	options = {},
	clrs = {
		norm = {},
		dark = {},
		togz = {}
	},
	mc = {127, 72, 163}
}

local function menu_outlined_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)
	draw_outlined_rect(visible, pos_x + mp.x, pos_y + mp.y, width, hieght, clr, tablename)
	table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
end

local function menu_filled_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)
	draw_filled_rect(visible, pos_x + mp.x, pos_y + mp.y, width, hieght, clr, tablename)
	table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
end

local function menu_big_text(text, visible, centered, pos_x, pos_y, tablename)
	draw_outlined_text(text, 2, visible, pos_x + mp.x, pos_y + mp.y, 13, centered, {255, 255, 255, 255}, {0, 0, 0}, tablename)
	table.insert(mp.postable, {tablename[#tablename], pos_x, pos_y})
end

local bbmenu = {} -- this one is for the rendering n shi
menu_outlined_rect(true, 0, 0, mp.w, mp.h, {0, 0, 0, 255}, bbmenu)  -- first gradent or whatever
menu_outlined_rect(true, 1, 1, mp.w - 2, mp.h - 2, {20, 20, 20, 255}, bbmenu)
menu_outlined_rect(true, 2, 2, mp.w - 3, 1, {127, 72, 163, 255}, bbmenu)
table.insert(mp.clrs.norm, bbmenu[#bbmenu])
menu_outlined_rect(true, 2, 3, mp.w - 3, 1, {87, 32, 123, 255}, bbmenu)
table.insert(mp.clrs.dark, bbmenu[#bbmenu])
menu_outlined_rect(true, 2, 4, mp.w - 3, 1, {20, 20, 20, 255}, bbmenu)

for i = 0, 19 do
	menu_filled_rect(true, 2, 5 + i, mp.w - 4, 1, {20, 20, 20, 255}, bbmenu)
	bbmenu[6 + i].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 20, color = RGB(35, 35, 35)}})
end
menu_filled_rect(true, 2, 25, mp.w - 4, mp.h - 27, {35, 35, 35, 255}, bbmenu)

menu_big_text("BitchBot - Universal", true, false, 6, 6, bbmenu)

menu_outlined_rect(true, 8, 22, mp.w - 16, mp.h - 30, {0, 0, 0, 255}, bbmenu)    -- all this shit does the 2nd gradent
menu_outlined_rect(true, 9, 23, mp.w - 18, mp.h - 32, {20, 20, 20, 255}, bbmenu)
menu_outlined_rect(true, 10, 24, mp.w - 19, 1, {127, 72, 163, 255}, bbmenu)
table.insert(mp.clrs.norm, bbmenu[#bbmenu])
menu_outlined_rect(true, 10, 25, mp.w - 19, 1, {87, 32, 123, 255}, bbmenu)
table.insert(mp.clrs.dark, bbmenu[#bbmenu])
menu_outlined_rect(true, 10, 26, mp.w - 19, 1, {20, 20, 20, 255}, bbmenu)

for i = 0, 14 do
	menu_filled_rect(true, 10, 27 + (i * 2), mp.w - 20, 2, {45, 45, 45, 255}, bbmenu)
	bbmenu[#bbmenu].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 15, color = RGB(35, 35, 35)}})
end
menu_filled_rect(true, 10, 57, mp.w - 20, mp.h - 67, {35, 35, 35, 255}, bbmenu)

-- ok now the cool part :D
-- ANCHOR menu table
local menutable = {
	{
		name = "Aimbot",
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
			{
				name = "Local Visuals",
				x = 253,
				y = 66,
				width = 230,
				height = 332,
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
			}
		}
	},
	{
		name = "Settings",
		content = {
			{
				name = "Menu Settings",
				x = 17,
				y = 66,
				width = 230,
				height = 170,
				content = {
					{
						type = "toggle",
						name = "Menu Accent",
						value = false,
						extra = {
							type = "single colorpicker",
							name = "Menu Accent",
							color = {127, 72, 163}
						}
					}
				}
			},
			{
				name = "Configuration",
				x = 253,
				y = 66,
				width = 230,
				height = 170,
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
				}
			}
		}
	},
}
--SECTION ignore
local tabz = {}
for i = 1, #menutable do
	tabz[i] = {}
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

local function cool_box(name, x, y, width, height, tab)
	menu_outlined_rect(true, x, y, width, height, {0, 0, 0, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 1, width - 2, height - 2, {20, 20, 20, 255}, tab)
 	menu_outlined_rect(true, x + 2, y + 2, width - 3, 1, {127, 72, 163, 255}, tab)
 	table.insert(mp.clrs.norm, tab[#tab])
	menu_outlined_rect(true, x + 2, y + 3, width - 3, 1, {87, 32, 123, 255}, tab)
	table.insert(mp.clrs.dark, tab[#tab])
	menu_outlined_rect(true, x + 2, y + 4, width - 3, 1, {20, 20, 20, 255}, tab)
	menu_big_text(name, true, false, x + 6, y + 5, tab)
end

local function draw_tog(name, value, x, y, tab)
	menu_outlined_rect(true, x, y, 12, 12, {30, 30, 30, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 1, 10, 10, {0, 0, 0, 255}, tab)

	local temptable = {}
	for i = 0, 3 do
		menu_filled_rect(true, x + 2, y + 2 + (i * 2), 8, 2, {0, 0, 0, 255}, tab)
		table.insert(temptable, tab[#tab])
		if value then
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
		else
			tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
		end
	end

	menu_big_text(name, true, false, x + 16, y - 1, tab)
	table.insert(temptable, tab[#tab])
	return temptable
end

local function draw_keybind(key, x, y, tab)
	local temptable = {}
	menu_filled_rect(true, x, y, 44, 16, {25, 25, 25, 255}, tab)
	menu_big_text(keyenum2name(key), true, true, x + 22, y + 1, tab)
	table.insert(temptable, tab[#tab])
	menu_outlined_rect(true, x, y, 44, 16, {30, 30, 30, 255}, tab)
	table.insert(temptable, tab[#tab])
	menu_outlined_rect(true, x + 1, y + 1, 42, 14, {0, 0, 0, 255}, tab)

	return temptable
end

local function draw_colorpicker(color, x, y, tab)
	local temptable = {}

	menu_outlined_rect(true, x, y, 28, 14, {30, 30, 30, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 1, 26, 12, {0, 0, 0, 255}, tab)

	menu_filled_rect(true, x + 2, y + 2, 24, 10, {color[1], color[2], color[3], 255}, tab)
	table.insert(temptable, tab[#tab])
	menu_outlined_rect(true, x + 2, y + 2, 24, 10, {color[1] - 40, color[2] - 40, color[3] - 40, 255}, tab)
	table.insert(temptable, tab[#tab])
	menu_outlined_rect(true, x + 3, y + 3, 22, 8, {color[1] - 40, color[2] - 40, color[3] - 40, 255}, tab)
	table.insert(temptable, tab[#tab])

	return temptable
end

local function draw_slider(name, stradd, value, minvalue, maxvalue, x, y, length, tab)
	menu_big_text(name, true, false, x, y - 3, tab)

	for i = 0, 3 do
		menu_filled_rect(true, x + 2, y + 14 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
		tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
	end

	local temptable = {}
	for i = 0, 3 do
		menu_filled_rect(true, x + 2, y + 14 + (i * 2), (length - 4) * ((value - minvalue) / (maxvalue - minvalue)), 2, {0, 0, 0, 255}, tab)
		table.insert(temptable, tab[#tab])
		tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
	end
	menu_outlined_rect(true, x, y + 12, length, 12, {30, 30, 30, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 13, length - 2, 10, {0, 0, 0, 255}, tab)

	if stradd == nil then
		stradd = ""
	end
	menu_big_text(tostring(value).. stradd, true, true, x + (length / 2) , y + 11 , tab)
	table.insert(temptable, tab[#tab])
	table.insert(temptable, stradd)
	return temptable
end

local function draw_dropbox(name, value, values, x, y, length, tab)
	local temptable = {}
	menu_big_text(name, true, false, x, y - 3, tab)

	for i = 0, 7 do
		menu_filled_rect(true, x + 2, y + 14 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
		tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
	end

	menu_outlined_rect(true, x, y + 12, length, 22, {30, 30, 30, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 13, length - 2, 20, {0, 0, 0, 255}, tab)

	menu_big_text(tostring(values[value]), true, false, x + 6, y + 16 , tab)
	table.insert(temptable, tab[#tab])

	menu_big_text("-", true, false, x - 17 + length, y + 16, tab)
	table.insert(temptable, tab[#tab])

	return temptable
end

local function draw_combobox(name, values, x, y, length, tab)
	local temptable = {}
	menu_big_text(name, true, false, x, y - 3, tab)

	for i = 0, 7 do
		menu_filled_rect(true, x + 2, y + 14 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
		tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
	end

	menu_outlined_rect(true, x, y + 12, length, 22, {30, 30, 30, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 13, length - 2, 20, {0, 0, 0, 255}, tab)
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
	menu_big_text(textthing, true, false, x + 6, y + 16 , tab)
	table.insert(temptable, tab[#tab])

	menu_big_text("...", true, false, x - 27 + length, y + 16, tab)
	table.insert(temptable, tab[#tab])

	return temptable
end

local function draw_button(name, x, y, length, tab)
	local temptable = {}

	for i = 0, 8 do
		menu_filled_rect(true, x + 2, y + 2 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
		tab[#tab].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
		table.insert(temptable, tab[#tab])
	end

	menu_outlined_rect(true, x, y, length, 22, {30, 30, 30, 255}, tab)
	menu_outlined_rect(true, x + 1, y + 1, length - 2, 20, {0, 0, 0, 255}, tab)
	menu_big_text(name, true, true, x + math.floor(length / 2), y + 4 , tab)

	return temptable
end

local tabbies = {} -- i like tabby catz 🐱🐱🐱
local tabnum2str = {} -- its used to change the tab num to the string (did it like this so its dynamic if u add or remove tabs or whatever :D)
for k, v in pairs(menutable) do
	menu_filled_rect(true, 10 + ((k - 1) * math.floor((mp.w - 20)/#menutable)), 27, math.floor((mp.w - 20)/#menutable), 32, {30, 30, 30, 255}, bbmenu)
	menu_outlined_rect(true, 10 + ((k - 1) * math.floor((mp.w - 20)/#menutable)), 27, math.floor((mp.w - 20)/#menutable), 32, {20, 20, 20, 255}, bbmenu)
	menu_big_text(v.name, true, true, 10 + ((k - 1) * math.floor((mp.w - 20)/#menutable)) + math.floor(math.floor((mp.w - 20)/#menutable)/2), 35, bbmenu)
	table.insert(tabbies, {bbmenu[#bbmenu - 2], bbmenu[#bbmenu - 1], bbmenu[#bbmenu]})
	table.insert(tabnum2str, v.name)

	mp.options[v.name] = {}
	if v.content ~= nil then
		for k1, v1 in pairs(v.content) do
			cool_box(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
			mp.options[v.name][v1.name] = {}
			if v1.content ~= nil then
				local y_pos = 24
				for k2, v2 in pairs(v1.content) do
					if v2.type == "toggle" then
						mp.options[v.name][v1.name][v2.name] = {}
						mp.options[v.name][v1.name][v2.name][4] = draw_tog(v2.name, v2.value, v1.x + 8, v1.y + y_pos, tabz[k])
						mp.options[v.name][v1.name][v2.name][1] = v2.value
						mp.options[v.name][v1.name][v2.name][2] = v2.type
						mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1}
						if v2.extra ~= nil then
							if v2.extra.type == "keybind" then
								mp.options[v.name][v1.name][v2.name][5] = {}
								mp.options[v.name][v1.name][v2.name][5][4] = draw_keybind(v2.extra.key, v1.x + v1.width - 52, y_pos + v1.y - 2, tabz[k])
								mp.options[v.name][v1.name][v2.name][5][1] = v2.extra.key
								mp.options[v.name][v1.name][v2.name][5][2] = v2.extra.type
								mp.options[v.name][v1.name][v2.name][5][3] = {v1.x + v1.width - 52, y_pos + v1.y - 2}
								mp.options[v.name][v1.name][v2.name][5][5] = false
							elseif v2.extra.type == "single colorpicker" then
								mp.options[v.name][v1.name][v2.name][5] = {}
								mp.options[v.name][v1.name][v2.name][5][4] = draw_colorpicker(v2.extra.color, v1.x + v1.width - 38, y_pos + v1.y - 1, tabz[k])
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
									mp.options[v.name][v1.name][v2.name][5][1][i][4] = draw_colorpicker(v2.extra.color[i], v1.x + v1.width - 38 - ((i - 1) * 34), y_pos + v1.y - 1, tabz[k])
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
						mp.options[v.name][v1.name][v2.name][4] = draw_slider(v2.name, v2.stradd, v2.value, v2.minvalue, v2.maxvalue, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
						mp.options[v.name][v1.name][v2.name][1] = v2.value
						mp.options[v.name][v1.name][v2.name][2] = v2.type
						mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
						mp.options[v.name][v1.name][v2.name][5] = false
						mp.options[v.name][v1.name][v2.name][6] = {v2.minvalue, v2.maxvalue}
						y_pos += 30
					elseif v2.type == "dropbox" then
						mp.options[v.name][v1.name][v2.name] = {}
						mp.options[v.name][v1.name][v2.name][4] = draw_dropbox(v2.name, v2.value, v2.values, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
						mp.options[v.name][v1.name][v2.name][1] = v2.value
						mp.options[v.name][v1.name][v2.name][2] = v2.type
						mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
						mp.options[v.name][v1.name][v2.name][5] = false
						mp.options[v.name][v1.name][v2.name][6] = v2.values
						y_pos += 39
					elseif v2.type == "combobox" then
						mp.options[v.name][v1.name][v2.name] = {}
						mp.options[v.name][v1.name][v2.name][4] = draw_combobox(v2.name, v2.values, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
						mp.options[v.name][v1.name][v2.name][1] = v2.values
						mp.options[v.name][v1.name][v2.name][2] = v2.type
						mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
						mp.options[v.name][v1.name][v2.name][5] = false
						y_pos += 39
					elseif v2.type == "button" then
						mp.options[v.name][v1.name][v2.name] = {}
						mp.options[v.name][v1.name][v2.name][4] = draw_button(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
						mp.options[v.name][v1.name][v2.name][1] = false
						mp.options[v.name][v1.name][v2.name][2] = v2.type
						mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
						y_pos += 28
					end
				end
			end
		end
	end
end

menu_outlined_rect(true, 10, 59, mp.w - 20, mp.h - 69, {20, 20, 20, 255}, bbmenu)

menu_outlined_rect(true, 11, 58, math.floor((mp.w - 20)/#menutable) - 2, 2, {35, 35, 35, 255}, bbmenu)
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

draw_outlined_rect(false, 20, 20, 100, 22, {20, 20, 20, 255}, dropboxthingy)
draw_outlined_rect(false, 21, 21, 98, 20, {0, 0, 0, 255}, dropboxthingy)
draw_filled_rect(false, 22, 22, 96, 18, {45, 45, 45, 255}, dropboxthingy)

for i = 1, 30 do
	draw_outlined_text("nigga balls", 2, false, 20, 20, 13, false, {255, 255, 255, 255}, {0, 0, 0}, dropboxtexty)
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
	draw_outlined_rect(visible, pos_x + cp.x, pos_y + cp.y, width, hieght, clr, tablename)
	table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
end

local function colorpicker_filled_rect(visible, pos_x, pos_y, width, hieght, clr, tablename)
	draw_filled_rect(visible, pos_x + cp.x, pos_y + cp.y, width, hieght, clr, tablename)
	table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
end

local function colorpicker_image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
	draw_image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
	table.insert(cp.postable, {tablename[#tablename], pos_x, pos_y})
end

local function colorpicker_big_text(text, visible, centered, pos_x, pos_y, tablename)
	draw_outlined_text(text, 2, visible, pos_x + cp.x, pos_y + cp.y, 13, centered, {255, 255, 255, 255}, {0, 0, 0}, tablename)
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
colorpicker_image(false, "https://i.imgur.com/9NMuFcQ.png", 12, 25, 156, 156, 1, colorpickerthingy)

--https://i.imgur.com/jG3NjxN.png
local alphabar = {}
colorpicker_outlined_rect(false, 10, 189, 160, 14, {30, 30, 30, 255}, colorpickerthingy)
table.insert(alphabar, colorpickerthingy[#colorpickerthingy])
colorpicker_outlined_rect(false, 11, 190, 158, 12, {0, 0, 0, 255}, colorpickerthingy)
table.insert(alphabar, colorpickerthingy[#colorpickerthingy])
colorpicker_image(false, "https://i.imgur.com/jG3NjxN.png", 12, 191, 159, 10, 1, colorpickerthingy)
table.insert(alphabar, colorpickerthingy[#colorpickerthingy])

colorpicker_outlined_rect(false, 176, 23, 14, 160, {30, 30, 30, 255}, colorpickerthingy)
colorpicker_outlined_rect(false, 177, 24, 12, 158, {0, 0, 0, 255}, colorpickerthingy)
--https://i.imgur.com/2Ty4u2O.png
colorpicker_image(false, "https://i.imgur.com/2Ty4u2O.png", 178, 25, 10, 156, 1, colorpickerthingy)

colorpicker_big_text("New Color", false, false, 198, 23, colorpickerthingy)
colorpicker_outlined_rect(false, 197, 37, 75, 40, {30, 30, 30, 255}, colorpickerthingy)
colorpicker_outlined_rect(false, 198, 38, 73, 38, {0, 0, 0, 255}, colorpickerthingy)
colorpicker_image(false, "https://i.imgur.com/kNGuTlj.png", 199, 39, 71, 36, 1, colorpickerthingy)

colorpicker_filled_rect(false, 199, 39, 71, 36, {255, 0, 0, 255}, colorpickerthingy)
local newcolor = colorpickerthingy[#colorpickerthingy]

colorpicker_big_text("Old Color", false, false, 198, 77, colorpickerthingy)
colorpicker_outlined_rect(false, 197, 91, 75, 40, {30, 30, 30, 255}, colorpickerthingy)
colorpicker_outlined_rect(false, 198, 92, 73, 38, {0, 0, 0, 255}, colorpickerthingy)
colorpicker_image(false, "https://i.imgur.com/kNGuTlj.png", 199, 93, 71, 36, 1, colorpickerthingy)

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
draw_outlined_rect(true, 30, 30, 16, 5, {0, 0, 0, 255}, colorpickerthingy)
table.insert(dragbar_r, colorpickerthingy[#colorpickerthingy])
draw_outlined_rect(true, 31, 31, 14, 3, {255, 255, 255, 255}, colorpickerthingy)
table.insert(dragbar_r, colorpickerthingy[#colorpickerthingy])

local dragbar_b = {}
draw_outlined_rect(true, 30, 30, 5, 16, {0, 0, 0, 255}, colorpickerthingy)
table.insert(dragbar_b, colorpickerthingy[#colorpickerthingy])
table.insert(alphabar, colorpickerthingy[#colorpickerthingy])
draw_outlined_rect(true, 31, 31, 3, 14, {255, 255, 255, 255}, colorpickerthingy)
table.insert(dragbar_b, colorpickerthingy[#colorpickerthingy])
table.insert(alphabar, colorpickerthingy[#colorpickerthingy])

local dragbar_m = {}
draw_outlined_rect(true, 30, 30, 5, 5, {0, 0, 0, 255}, colorpickerthingy)
table.insert(dragbar_m, colorpickerthingy[#colorpickerthingy])
draw_outlined_rect(true, 31, 31, 3, 3, {255, 255, 255, 255}, colorpickerthingy)
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

		set_dragbar_r(cp.x + 175, cp.y + 23 + math.floor((1 - h)*156 ))
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
draw_tri(true, true, {mousie.x, mousie.y}, {mousie.x, mousie.y + 15}, {mousie.x + 10, mousie.y + 10}, {127, 72, 163, 255}, bbmouse)
table.insert(mp.clrs.norm, bbmouse[#bbmouse])
draw_tri(true, false, {mousie.x, mousie.y}, {mousie.x, mousie.y + 15}, {mousie.x + 10, mousie.y + 10}, {0, 0, 0, 255}, bbmouse)

local function set_mouse_pos(x, y)
	for k, v in pairs(bbmouse) do
		v.PointA = Vector2.new(x, y + 36)
		v.PointB = Vector2.new(x, y + 36 + 15)
		v.PointC = Vector2.new(x + 10, y + 46)
	end
end

local function set_menu_color(r, g, b)
	for k, v in pairs(mp.clrs.norm) do
		v.Color = RGB(r, g, b)
	end
	for k, v in pairs(mp.clrs.dark) do
		v.Color = RGB(r - 40, g - 40, b - 40)
	end
	mp.mc = {r, g, b}
	for k, v in pairs(mp.options) do
		for k1, v1 in pairs(v) do
			for k2, v2 in pairs(v1) do
				if v2[2] == "toggle" then
					if not v2[1] then
						for i = 0, 3 do
							v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
						end
					else
						for i = 0, 3 do
							v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
						end
					end
				elseif v2[2] == "slider" then
					for i = 0, 3 do
						v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
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
--!SECTION
-- ANCHOR InputBegan

function keyCheck (key)
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
									v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
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
			mp.fading = true
			while mp.open do
				for k, v in pairs(bbmouse) do
					v.Transparency = (v.Transparency * 255 - mp.fadespeed)/ 255
					if v.Transparency <= 0 then
						v.Transparency = 0
					end
				end
				for k, v in pairs(bbmenu) do
					v.Transparency = (v.Transparency * 255 - mp.fadespeed)/ 255
					if v.Transparency <= 0 then
						v.Transparency = 0
						mp.open = false
					end
				end
				for k, v in pairs(tabz[mp.activetab]) do
					v.Transparency = (v.Transparency * 255 - mp.fadespeed)/ 255
					if v.Transparency <= 0 then
						v.Transparency = 0
						mp.open = false
					end
				end
				wait(0)
			end
			for k, v in pairs(bbmenu) do
			 	v.Visible = false
			end
			for k, v in pairs(tabz) do
				for k1, v1 in pairs(v) do
					v1.Visible = false
				end
			end
			mp.fading = false
		elseif not mp.open and not mp.fading then
			mp.fading = true
			for k, v in pairs(bbmenu) do
			 	v.Visible = true
			end
			set_barguy(mp.activetab)
			while not mp.open do
				for k, v in pairs(bbmouse) do
					v.Transparency = (v.Transparency * 255 + mp.fadespeed)/ 255
					if v.Transparency >= 1 then
						v.Transparency = 1
					end
				end
				for k, v in pairs(bbmenu) do
					v.Transparency = (v.Transparency * 255 + mp.fadespeed)/ 255
					if v.Transparency >= 1 then
						v.Transparency = 1
						mp.open = true
					end
				end
				for k, v in pairs(tabz[mp.activetab]) do
					v.Transparency = (v.Transparency * 255 + mp.fadespeed)/ 255
					if v.Transparency >= 1 then
						v.Transparency = 1
						mp.open = true
					end
				end
				wait(0)
			end
			mp.fading = false
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

local function set_menu_pos(x, y)
	for k, v in pairs(mp.postable) do
		v[1].Position = Vector2.new(x + v[2], y + v[3])
	end
end

local function mouse_pressed_in_menu(x, y, width, height)
	if mouse.X > mp.x + x and mouse.X < mp.x + x + width and mouse.y > mp.y - 36 + y and mouse.Y < mp.y - 36 + y + height then
		return true
	else
		return false
	end
end

local function mouse_pressed_in_colorpicker(x, y, width, height)
	if mouse.X > cp.x + x and mouse.X < cp.x + x + width and mouse.y > cp.y - 36 + y and mouse.Y < cp.y - 36 + y + height then
		return true
	else
		return false
	end
end

local keyz = {}
for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
	keyz[v.Value] = v
end

mp.getval = function(...)
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
			return mp.options[args[1]][args[2]][args[3]][5][1]
		elseif args[4] == "color1" then
			return mp.options[args[1]][args[2]][args[3]][5][1][1][1]
		elseif args[4] == "color2" then
			return mp.options[args[1]][args[2]][args[3]][5][1][2][1]
		end
	end
end


local simpcfgnamez = {"toggle", "slider", "dropbox"}
local function buttonpressed(bp)
	if bp == mp.options["Settings"]["Configuration"]["Save Config"] then
		local figgy = "BitchBot v2\nmade with <3 by Nate, Bitch, and Zarzel\n\n"

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
		writefile("bitchbot/uni/config".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]).. ".bb", figgy)
		print("save ".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]))
	elseif bp == mp.options["Settings"]["Configuration"]["Load Config"] then

		local loadedcfg = readfile("bitchbot/uni/config".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]).. ".bb")
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
					print(i)
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
									v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
								end
							else
								for i = 0, 3 do
									v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
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
		print("load")
	end
end

local function mousebutton1downfunc()
	dropboxopen = false
	for k, v in pairs(mp.options) do
		for k1, v1 in pairs(v) do
			for k2, v2 in pairs(v1) do
				if v2[2] == "dropbox" and v2[5] then
					if not mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) then
						set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
						v2[5] = false
					else
						dropboxthatisopen = v2
						dropboxopen = true
					end
				end
				if v2[2] == "combobox" and v2[5] then
					if not mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) then
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
								if not mouse_pressed_in_colorpicker(0, 0, cp.w, cp.h) then
									set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
									v2[5][5] = false
									colorpickerthatisopen = nil
									colorpickeropen = false
								end
							end
						elseif v2[5][2] == "double colorpicker" then
							for k3, v3 in pairs(v2[5][1]) do
								if v3[5] == true then
									if not mouse_pressed_in_colorpicker(0, 0, cp.w, cp.h) then
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
		if mouse_pressed_in_menu(10 + ((i - 1) * math.floor((mp.w - 20)/#menutable)), 27, math.floor((mp.w - 20)/#menutable), 32) then
			mp.activetab = i
			set_barguy(mp.activetab)
		end
	end
	if colorpickeropen then
		if mouse_pressed_in_colorpicker(197, cp.h - 25, 75, 20) then
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
		if mouse_pressed_in_colorpicker(10, 23, 160, 160) then
			cp.dragging_m = true
		elseif mouse_pressed_in_colorpicker(176, 23, 14, 160) then
			cp.dragging_r = true
		elseif mouse_pressed_in_colorpicker(10, 189, 160, 14) and cp.alpha then
			cp.dragging_b = true
		end
	else
		for k, v in pairs(mp.options) do
			if tabnum2str[mp.activetab] == k then
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "toggle" and not dropboxopen then
							if mouse_pressed_in_menu(v2[3][1], v2[3][2], 30 + v2[4][5].TextBounds.x, 16) then
								if v2[1] then
									for i = 0, 3 do
										v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
									end
								else
									for i = 0, 3 do
										v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
									end
								end
								v2[1] = not v2[1]
							end
							if v2[5] ~= nil then
								if v2[5][2] == "keybind" then
									if mouse_pressed_in_menu(v2[5][3][1], v2[5][3][2], 44, 16) then
										v2[5][4][2].Color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])
										v2[5][5] = true
									end
								elseif v2[5][2] == "single colorpicker" then
									if mouse_pressed_in_menu(v2[5][3][1], v2[5][3][2], 28, 14) then
										v2[5][5] = true
										colorpickeropen = true
										colorpickerthatisopen = v2[5]
										if v2[5][1][4] ~= nil then
											set_colorpicker(true, v2[5][1], v2[5], true, v2[5][6], mouse.x, mouse.y + 36)
										else
											set_colorpicker(true, v2[5][1], v2[5], false, v2[5][6], mouse.x, mouse.y + 36)
										end
									end
								elseif v2[5][2] == "double colorpicker" then
									for k3, v3 in pairs(v2[5][1]) do
										if mouse_pressed_in_menu(v3[3][1], v3[3][2], 28, 14) then
											v3[5] = true
											colorpickeropen = true
											colorpickerthatisopen = v3
											if v3[1][4] ~= nil then
												set_colorpicker(true, v3[1], v3, true, v3[6], mouse.x, mouse.y + 36)
											else
												set_colorpicker(true, v3[1], v3, false, v3[6], mouse.x, mouse.y + 36)
											end
										end
									end
								end
							end
						elseif v2[2] == "slider" and not dropboxopen then
							if mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 28) then
								v2[5] = true
							end
						elseif v2[2] == "dropbox" then
							if dropboxopen then
								if v2 ~= dropboxthatisopen then
									continue
								end
							end
							if mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 36) then
								if not v2[5] then
									set_dropboxthingy(true, v2[3][1] + mp.x + 1, v2[3][2] + mp.y + 13, v2[3][3], v2[1], v2[6])
									v2[5] = true
								else
									set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
									v2[5] = false
								end
							elseif mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[6] + 1) + 3) and v2[5] then
								for i = 1, #v2[6] do
									if mouse_pressed_in_menu(v2[3][1], v2[3][2] + 36 + ((i - 1) * 22), v2[3][3], 23) then
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
							if mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 36) then
								if not v2[5] then
									set_comboboxthingy(true, v2[3][1] + mp.x + 1, v2[3][2] + mp.y + 13, v2[3][3], v2[1], v2[6])
									v2[5] = true
								else
									set_dropboxthingy(false, 400, 200, 160, 1, {"HI q", "HI q", "HI q"})
									v2[5] = false
								end
							elseif mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 24 * (#v2[1] + 1) + 3) and v2[5] then
								for i = 1, #v2[1] do
									if mouse_pressed_in_menu(v2[3][1], v2[3][2] + 36 + ((i - 1) * 22), v2[3][3], 23) then
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
							if mouse_pressed_in_menu(v2[3][1], v2[3][2], v2[3][3], 22) then
								if not v2[1] then
									buttonpressed(v2)
									for i = 0, 8 do
										v2[4][i + 1].Color = ColorRange(i, {[1] = {start = 0, color = RGB(35, 35, 35)}, [2] = {start = 8, color = RGB(50, 50, 50)}})
									end
									v2[1] = true
								end
							end
						end
					end
				end
			end
		end
	end
	if tabnum2str[mp.activetab] == "Settings" then
		if mp.options["Settings"]["Menu Settings"]["Menu Accent"][1] then
			local clr = mp.options["Settings"]["Menu Settings"]["Menu Accent"][5][1]
			set_menu_color(clr[1], clr[2], clr[3])
		else
			set_menu_color(127, 72, 163)
		end
	end
end

local mousedown = false
mouse.Button1Down:Connect(function()
	mousedown = true
	if mp.open and not mp.fading then
		mousebutton1downfunc()
	end
end)

local function mousebutton1upfunc()
	cp.dragging_m = false
	cp.dragging_r = false
	cp.dragging_b = false
	for k, v in pairs(mp.options) do
		if tabnum2str[mp.activetab] == k then
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

mouse.Button1Up:Connect(function()
	mousedown = false
	if mp.open and not mp.fading then
		mousebutton1upfunc()
	end
end)

local dragging = false
local dontdrag = false
local clickspot_x, clickspot_y, original_menu_x, original_menu_y = 0, 0, 0, 0

local function rendersteppedfunc()
if mp.open then
		if ((mouse.X > mp.x and mouse.X < mp.x + mp.w and mouse.y > mp.y - 32 and mouse.Y < mp.y - 11) or dragging) and not dontdrag then
			if mousedown then
				if dragging == false then
					clickspot_x = mouse.X
					clickspot_y = mouse.Y - 36
					original_menu_X = mp.x
					original_menu_y = mp.y
					dragging = true
				end
				mp.x = (original_menu_X - clickspot_x) + mouse.X
				mp.y = (original_menu_y - clickspot_y) + mouse.Y - 36
				set_menu_pos(mp.x, mp.y)
			else
				dragging = false
			end
		elseif mousedown then
			dontdrag = true
		elseif not mousedown then
			dontdrag = false
		end
		if colorpickeropen then
			if cp.dragging_m then
				set_dragbar_m(Clamp(mouse.X, cp.x + 12, cp.x + 167) - 2, Clamp(mouse.Y + 36, cp.y + 25, cp.y + 180) - 2)

				cp.hsv.s = (Clamp(mouse.x, cp.x + 12, cp.x + 167) - cp.x - 12)/155
				cp.hsv.v = 1 - ((Clamp(mouse.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
				newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
			elseif cp.dragging_r then
				set_dragbar_r(cp.x + 175, Clamp(mouse.Y + 36, cp.y + 23, cp.y + 178))

				maincolor.Color = Color3.fromHSV(1 - ((Clamp(mouse.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155), 1, 1)

				cp.hsv.h = 1 - ((Clamp(mouse.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
				newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
			elseif cp.dragging_b then
				set_dragbar_b(Clamp(mouse.x, cp.x + 10, cp.x + 168 ), cp.y + 188)
				newcolor.Transparency = (Clamp(mouse.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158
				cp.hsv.a = math.floor(((Clamp(mouse.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158) * 255)
			end
		end

		for k, v in pairs(mp.options) do
			if tabnum2str[mp.activetab] == k then
				for k1, v1 in pairs(v) do
					for k2, v2 in pairs(v1) do
						if v2[2] == "slider" and v2[5] then
							v2[1] = math.floor((v2[6][2] - v2[6][1]) * ((mouse.X - mp.x - v2[3][1])/v2[3][3])) + v2[6][1]
							if v2[1] < v2[6][1] then
								v2[1] = v2[6][1]
							elseif v2[1] > v2[6][2] then
								v2[1] = v2[6][2]
							end
							v2[4][5].Text = tostring(v2[1]).. v2[4][6]
							for i = 1, 4 do
								v2[4][i].Size = Vector2.new((v2[3][3] - 4) * ((v2[1] - v2[6][1]) / (v2[6][2] - v2[6][1])), 2)
							end
						end
					end
				end
			end
		end
	else
		if dragging then
			dragging = false
		end
	end

	if mp.open or mp.fading then
		set_mouse_pos(mouse.x, mouse.y)
	end
end


local cachedValues = {}
spawn(function() -- getting original valuez

	cachedValues.WalkSpeed =	MainPlayer.Character:WaitForChild("Humanoid").WalkSpeed
	cachedValues.FieldOfView = workspace.CurrentCamera.FieldOfView
	cachedValues.FlyToggle = false

end)

local function SpeedHack()

	local speed = mp.options["Misc"]["Movement"]["Speed"][1]
	local MainPlayer = game.Players.LocalPlayer

	if mp.options["Misc"]["Movement"]["Speed Hack"][1] and MainPlayer.Character and MainPlayer.Character.Humanoid then

		if mp.options["Misc"]["Movement"]["Speed Hack Method"][1] == 1 then

			local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")

			local travel = Vector3.new()
			local looking = Workspace.CurrentCamera.CFrame.lookVector
			if Input:IsKeyDown(Enum.KeyCode.W) then
				travel += Vector3.new(looking.X,0,looking.Z)
			end
			if Input:IsKeyDown(Enum.KeyCode.S) then
				travel -= Vector3.new(looking.X,0,looking.Z)
			end
			if Input:IsKeyDown(Enum.KeyCode.D) then
				travel += Vector3.new(-looking.Z, 0, looking.X)
			end
			if Input:IsKeyDown(Enum.KeyCode.A) then
				travel += Vector3.new(looking.Z, 0, -looking.X)
			end

			travel = travel.Unit

			local newDir = Vector3.new(travel.X * speed, rootpart.Velocity.Y, travel.Z * speed)

			if travel.Unit.X == travel.Unit.X then
				rootpart.Velocity = newDir
			end

		else

			MainPlayer.Character.Humanoid.WalkSpeed = speed

		end
	elseif MainPlayer.Character.Humanoid.WalkSpeed == speed then

		MainPlayer.Character.Humanoid.WalkSpeed = cachedValues.WalkSpeed

	end

end
local	function FlyHack()

	if mp.options["Misc"]["Movement"]["Fly Hack"][1] then

		local rootpart = MainPlayer.Character.HumanoidRootPart


		if mp.options["Misc"]["Movement"]["Fly Method"][1] == 2 then

			for lI, lV in pairs(MainPlayer.Character:GetDescendants()) do
				if lV:IsA("BasePart") then
					lV.CanCollide = false
				end
				
			end

		end

		if cachedValues.FlyToggle then

			local speed = mp.options["Misc"]["Movement"]["Fly Speed"][1]

			local travel = Vector3.new()
			local looking = workspace.CurrentCamera.CFrame.lookVector --getting camera looking vector

			do
				if Input:IsKeyDown(Enum.KeyCode.W)         then travel += looking                               end
				if Input:IsKeyDown(Enum.KeyCode.S)         then travel -= looking                               end
				if Input:IsKeyDown(Enum.KeyCode.D)         then travel += Vector3.new(-looking.Z, 0, looking.X) end
				if Input:IsKeyDown(Enum.KeyCode.A)         then travel += Vector3.new(looking.Z, 0, -looking.X) end

				if Input:IsKeyDown(Enum.KeyCode.Space)     then travel += Vector3.new(0, 1, 0)                  end
				if Input:IsKeyDown(Enum.KeyCode.LeftShift) then travel -= Vector3.new(0, 1, 0)                  end
			end

			if travel.Unit.X == travel.Unit.X then
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

local function CameraFOV()

	local fov = mp.options["Misc"]["Local Visuals"]["Camera FOV"][1]

	if fov ~= 60 then

		workspace.CurrentCamera.FieldOfView = fov

	end

end



local function KeyBinds(key)

	if mp.options["Misc"]["Movement"]["Fly Hack"][1] and key.KeyCode == mp.options["Misc"]["Movement"]["Fly Hack"][5][1] then
		cachedValues.FlyToggle = not cachedValues.FlyToggle
		MainPlayer.Character.HumanoidRootPart.Anchored = false
	end

	if mp.options["Misc"]["Movement"]["Mouse Teleport"][1] and key.KeyCode == mp.options["Misc"]["Movement"]["Mouse Teleport"][5][1] then
		local targetPos = mouse.Hit.p
		local RP = MainPlayer.Character.HumanoidRootPart
		RP.CFrame = CFrame.new(targetPos + Vector3.new(0,7,0))
	end

end

local keycheck = Input.InputBegan:Connect(function(key) -- put this into a functoin alan!

	KeyBinds(key)

	keyCheck(key)
	
end)

--ANCHOR renderstepped

local renderstepped = game.RunService.RenderStepped:Connect(function()

	rendersteppedfunc()

	SpeedHack()

	FlyHack()

	CameraFOV()

end)



-- wait(20)
-- unrender()