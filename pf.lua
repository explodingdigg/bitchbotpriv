

-- nate i miss u D:

setfpscap(300) -- nigga roblox

if not isfolder("bitchbot") then
	makefolder("bitchbot")
end

if not isfolder("bitchbot/pf") then
	makefolder("bitchbot/pf")
end

for i = 1, 6 do
	if not isfile("bitchbot/pf/config"..tostring(i)..".bb") then
		writefile("bitchbot/pf/config"..tostring(i)..".bb", "")
	end
end

local MainPlayer = game.Players.LocalPlayer
local Players = game:GetService("Players")
local mouse = MainPlayer:GetMouse()
local Input = game:GetService("UserInputService")

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
	if not table.contains(allrender, tablename) then
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
	if not table.contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

local function draw_line(visible, thickness, start_x, start_y, end_x, end_y, clr, tablename)
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

local function draw_image(visible, imagedata, pos_x, pos_y, width, hieght, transparency, tablename)
	local temptable = Drawing.new("Image")
	temptable.Visible = visible
	temptable.Position = Vector2.new(pos_x, pos_y)
	temptable.Size = Vector2.new(width, hieght)
	temptable.Transparency = transparency
	temptable.Data = game:HttpGet(imagedata)
	table.insert(tablename, temptable)
	if not table.contains(allrender, tablename) then
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
	if not table.contains(allrender, tablename) then
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
	if not table.contains(allrender, tablename) then
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
	if not table.contains(allrender, tablename) then
		table.insert(allrender, tablename)
	end
end

-- gonna put esp right here so it renders bellow everything
local allesp = {
	skel = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
		[5] = {},
	},
	outerbox = {},
	innerbox = {},
	box = {},
	hpouter = {},
	hpinner = {},
	hptext = {},
	nametext = {},
	weptext = {},
	disttext = {}

}

for i = 1, 35 do
	for i1, v in ipairs(allesp.skel) do
		draw_line(false, 1, 30, 30, 50, 50, {255, 255, 255, 255}, v)
	end
	draw_outlined_rect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.outerbox)
	draw_outlined_rect(false, 20, 20, 20, 20, {0, 0, 0, 220}, allesp.innerbox)
	draw_outlined_rect(false, 20, 20, 20, 20, {255, 255, 255, 255}, allesp.box)

	draw_filled_rect(false, 20, 20, 20, 20, {10, 10, 10, 215}, allesp.hpouter)
	draw_filled_rect(false, 20, 20, 20, 20, {0, 255, 0, 255}, allesp.hpinner)
	draw_outlined_text("100", 1, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.hptext)

	draw_outlined_text("fart nigga 420", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.disttext)
	draw_outlined_text("fart nigga 420", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.weptext)
	draw_outlined_text("fart nigga 420", 2, false, 20, 20, 13, true, {255, 255, 255, 255}, {0, 0, 0}, allesp.nametext)
end

local mp = { -- this is for menu stuffs n shi
w = 500,
h = 600,
x = 200,
y = 200,
activetab = 1, -- do not change this value please its not made to be fucked with sorry
open = true,
fadespeed = 10,
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
	bbmenu[6 + i].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 20, color = RGB(35, 35, 35)}})
end
menu_filled_rect(true, 2, 25, mp.w - 4, mp.h - 27, {35, 35, 35, 255}, bbmenu)

menu_big_text("BitchBot - Phantom Forces", true, false, 6, 6, bbmenu)

menu_outlined_rect(true, 8, 22, mp.w - 16, mp.h - 30, {0, 0, 0, 255}, bbmenu)    -- all this shit does the 2nd gradent
menu_outlined_rect(true, 9, 23, mp.w - 18, mp.h - 32, {20, 20, 20, 255}, bbmenu)
menu_outlined_rect(true, 10, 24, mp.w - 19, 1, {127, 72, 163, 255}, bbmenu)
table.insert(mp.clrs.norm, bbmenu[#bbmenu])
menu_outlined_rect(true, 10, 25, mp.w - 19, 1, {87, 32, 123, 255}, bbmenu)
table.insert(mp.clrs.dark, bbmenu[#bbmenu])
menu_outlined_rect(true, 10, 26, mp.w - 19, 1, {20, 20, 20, 255}, bbmenu)

for i = 0, 14 do
	menu_filled_rect(true, 10, 27 + (i * 2), mp.w - 20, 2, {45, 45, 45, 255}, bbmenu)
	bbmenu[#bbmenu].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 15, color = RGB(35, 35, 35)}})
end
menu_filled_rect(true, 10, 57, mp.w - 20, mp.h - 67, {35, 35, 35, 255}, bbmenu)

-- ok now the cool part :D

local menutable = {
	{
		name = "Legit",
		content = {
			{
				name = "Aim Assist",
				x = 17,
				y = 66,
				width = 230,
				height = 332,
				content = {
					{
						type = "toggle",
						name = "Enabled",
						value = true
					},
					{
						type = "slider",
						name = "FOV",
						value = 80,
						minvalue = 0,
						maxvalue = 180,
						stradd = "°"
					},
					{
						type = "slider",
						name = "Smoothing Factor",
						value = 20,
						minvalue = 0,
						maxvalue = 50,
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
						values = {"Mouse 1", "Mouse 2", "Smart"}
					},
					{
						type = "dropbox",
						name = "Hitscan Priority",
						value = 1,
						values = {"Head", "Body"}
					},
					{
						type = "toggle",
						name = "Static Priority",
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
				x = 17,
				y = 404,
				width = 230,
				height = 179,
				content = {
					{
						type = "toggle",
						name = "Enable Backtrack",
						value = false
					},
					{
						type = "slider",
						name = "Backtrack Ammount",
						value = 1000,
						minvalue = 0,
						maxvalue = 5000,
						stradd = "ms"
					},
				},
			},
			{
				name = "Trigger Bot",
				x = 253,
				y = 66,
				width = 230,
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
						name = "Static Priority",
						value = false
					},
				}
			},
			{
				name = "Recoil Control",
				x = 253,
				y = 326,
				width = 230,
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
	{
		name = "Rage",
		content = {
			{
				name = "Aimbot",
				x = 17,
				y = 66,
				width = 230,
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
						name = "FOV",
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
						name = "Force Priority",
						value = false
					},
				}
			},
		}
	},
	{
		name = "ESP",
		content = {
			{
				name = "Enemy ESP",
				x = 17,
				y = 66,
				width = 230,
				height = 224,
				content = {
					{
						type = "toggle",
						name = "Name",
						value = false,
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
						value = false,
						extra = {
							type = "single colorpicker",
							name = "Enemy Box",
							color = {255, 0, 0, 130}
						}
					},
					{
						type = "toggle",
						name = "Health Bar",
						value = false,
						extra = {
							type = "double colorpicker",
							name = {"Enemy Low Health", "Enemy Max Health"},
							color = {{255, 0, 0}, {0, 255, 0}}
						}
					},
					{
						type = "toggle",
						name = "Health Number",
						value = false,
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
						value = false,
						extra = {
							type = "double colorpicker",
							name = {"Visible Enemy Chams", "Invisible Enemy Chams"},
							color = {{255, 0, 0, 255}, {255, 255, 255, 100}}
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
				x = 253,
				y = 66,
				width = 230,
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
						value = false,
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
							color = {{0, 255, 0, 255}, {255, 255, 255, 100}}
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
				x = 253,
				y = 260,
				width = 230,
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
						values = {"lowercase", "Normal", "CAPS"}
					},
					{
						type = "toggle",
						name = "Show Aimbot Target",
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
				x = 17,
				y = 296,
				width = 230,
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
	{
		name = "Visuals",
		content = {
			{
				name = "Local Visuals",
				x = 17,
				y = 66,
				width = 230,
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

				}
			},
			{
				name = "World Visuals",
				x = 253,
				y = 66,
				width = 230,
				height = 175,
				content = {
					{
						type = "toggle",
						name = "Ambience",
						value = false,
						extra = {
							type = "double colorpicker",
							name = {"Inside Ambience", "Outside Ambience"},
							color = {{255, 255, 255, 255}, {255, 255, 255, 100}}
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
							color = {255, 255, 255, 255}
						}
					},
					{
						type = "slider",
						name = "Saturation Density",
						value = 0,
						minvalue = 0,
						maxvalue = 20,
					},
				}
			},
			{
				name = "Misc Visuals",
				x = 253,
				y = 371,
				width = 230,
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
	{
		name = "Misc"
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
			tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
		else
			tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
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
		tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
	end

	local temptable = {}
	for i = 0, 3 do
		menu_filled_rect(true, x + 2, y + 14 + (i * 2), (length - 4) * ((value - minvalue) / (maxvalue - minvalue)), 2, {0, 0, 0, 255}, tab)
		table.insert(temptable, tab[#tab])
		tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
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
		tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
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
		tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 7, color = RGB(35, 35, 35)}})
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
		tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
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
							v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 3, color = RGB(30, 30, 30)}})
						end
					else
						for i = 0, 3 do
							v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
						end
					end
				elseif v2[2] == "slider" then
					for i = 0, 3 do
						v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(mp.mc[1], mp.mc[2], mp.mc[3])}, [2] = {start = 3, color = RGB(mp.mc[1] - 40, mp.mc[2] - 40, mp.mc[3] - 40)}})
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
local keycheck = Input.InputBegan:Connect(function(key)
	if client.logic.currentgun and client.logic.currentgun.shoot then
		local shootgun = client.logic.currentgun.shoot
		if not shooties[client.logic.currentgun.shoot] then
			client.logic.currentgun.shoot = function(self, ...)
				if not mp.open then
					shootgun(self, ...)
				end
			end
		end
		shooties[client.logic.currentgun.shoot] = true
	end
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
				game.RunService.Stepped:wait()
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
				game.RunService.Stepped:wait()
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
end)

local function set_menu_pos(x, y)
	for k, v in pairs(mp.postable) do
		if v[1].Visible then
			v[1].Position = Vector2.new(x + v[2], y + v[3])
		end
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
		writefile("bitchbot/pf/config".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]).. ".bb", figgy)
		print("save ".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]))
	elseif bp == mp.options["Settings"]["Configuration"]["Load Config"] then

		local loadedcfg = readfile("bitchbot/pf/config".. tostring(mp.options["Settings"]["Configuration"]["Configs"][1]).. ".bb")
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
			set_menu_pos(mp.x, mp.y)
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
										v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(35, 35, 35)}, [2] = {start = 8, color = RGB(50, 50, 50)}})
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
	if mp.activetab == 6 then
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
							v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
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
	---------------------------------------------------------------------i pasted the old menu working ingame shit from the old source nate pls fix ty
	local localply = nil  -----------------------------------------------this is the really shitty alive check that we've been using since day
	local players = workspace.Players.Ghosts:GetChildren()
	table.move(workspace.Players.Phantoms:GetChildren(), 1, #workspace.Players.Phantoms:GetChildren(), #players + 1, players)
	for k, v in pairs(players) do
		if v:FindFirstChild("Humanoid") then
			localply = v
			break
		end
	end

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
				set_dragbar_m(math.clamp(mouse.X, cp.x + 12, cp.x + 167) - 2, math.clamp(mouse.Y + 36, cp.y + 25, cp.y + 180) - 2)

				cp.hsv.s = (math.clamp(mouse.x, cp.x + 12, cp.x + 167) - cp.x - 12)/155
				cp.hsv.v = 1 - ((math.clamp(mouse.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
				newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
			elseif cp.dragging_r then
				set_dragbar_r(cp.x + 175, math.clamp(mouse.Y + 36, cp.y + 23, cp.y + 178))

				maincolor.Color = Color3.fromHSV(1 - ((math.clamp(mouse.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155), 1, 1)

				cp.hsv.h = 1 - ((math.clamp(mouse.Y + 36, cp.y + 23, cp.y + 178) - cp.y - 23)/155)
				newcolor.Color = Color3.fromHSV(cp.hsv.h, cp.hsv.s, cp.hsv.v)
			elseif cp.dragging_b then
				set_dragbar_b(math.clamp(mouse.x, cp.x + 10, cp.x + 168 ), cp.y + 188)
				newcolor.Transparency = (math.clamp(mouse.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158
				cp.hsv.a = math.floor(((math.clamp(mouse.x, cp.x + 10, cp.x + 168 ) - cp.x - 10)/158) * 255)
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
		if localply then
			Input.MouseBehavior = Enum.MouseBehavior.Default
		else
			Input.MouseIconEnabled = false
		end
	else
		if localply then
			Input.MouseBehavior = Enum.MouseBehavior.LockCenter
			Input.MouseIconEnabled = false
		else
			Input.MouseBehavior = Enum.MouseBehavior.Default
			Input.MouseIconEnabled = true
		end

		if dragging then
			dragging = false
		end
	end

	if mp.open or mp.fading then
		set_mouse_pos(mouse.x, mouse.y)
	end
end

local playerz = {
	Enemy = {},
	Team = {}
}

local mats = {"SmoothPlastic", "ForceField", "Neon", "Foil", "Glass"}

local skelparts = {"Head", "Right Arm", "Right Leg", "Left Leg", "Left Arm"}

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
			game.Lighting.MapSaturation.Saturation = mp.options["Visuals"]["World Visuals"]["Saturation Density"][1]/5
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

	local localply = nil
	local players = workspace.Players.Ghosts:GetChildren()
	table.move(workspace.Players.Phantoms:GetChildren(), 1, #workspace.Players.Phantoms:GetChildren(), #players + 1, players)
	for k, v in pairs(players) do
		if v:FindFirstChild("Humanoid") then
			localply = v
			break
		end
	end

	local localteam = MainPlayer.Team
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
	if localply ~= nil then
		for k, v in pairs(playerz) do
			for k1, v1 in ipairs(v) do
				local ply_pos = v1.Character.Torso.Position
				local top, top_isrendered = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(ply_pos.x, ply_pos.y + 2.5, ply_pos.z))
				local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(ply_pos.x, ply_pos.y - 2.9, ply_pos.z))
				local box_width = (bottom.y - top.y) / 2
				local teem = k.." ESP" -- I MISSPELLEDS IT ONPURPOSE NIGGA
				local health = math.ceil(client.hud:getplayerhealth(v1))
				local spoty = 0
				if (top_isrendered or bottom_isrendered) and client.hud:isplayeralive(v1) then
					playernum += 1
					if mp.options["ESP"][teem]["Name"][1] then
						local name = tostring(v1.Name)
						if mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 1 then
							name = string.lower(name)
						elseif mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 3 then
							name = string.upper(name)
						end

						allesp.nametext[playernum].Text = name
						allesp.nametext[playernum].Visible = true
						allesp.nametext[playernum].Position = Vector2.new(math.floor(bottom.x), math.floor(top.y + 21))
						allesp.nametext[playernum].Color = RGB(mp.options["ESP"][teem]["Name"][5][1][1], mp.options["ESP"][teem]["Name"][5][1][2], mp.options["ESP"][teem]["Name"][5][1][3])
						allesp.nametext[playernum].Transparency = mp.options["ESP"][teem]["Name"][5][1][4]/255
					end
					if mp.options["ESP"][teem]["Box"][1] then
						allesp.box[playernum].Visible = true
						allesp.box[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2), math.floor(top.y + 36))
						allesp.box[playernum].Size = Vector2.new(math.floor(box_width), math.floor(bottom.y - top.y))
						allesp.box[playernum].Color = RGB(mp.options["ESP"][teem]["Box"][5][1][1], mp.options["ESP"][teem]["Box"][5][1][2], mp.options["ESP"][teem]["Box"][5][1][3])
						allesp.box[playernum].Transparency = mp.options["ESP"][teem]["Box"][5][1][4]/255

						allesp.innerbox[playernum].Visible = true
						allesp.innerbox[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 + 1), math.floor(top.y + 37))
						allesp.innerbox[playernum].Size = Vector2.new(math.floor(box_width - 2), math.floor(bottom.y - top.y - 2))
						allesp.innerbox[playernum].Transparency = (mp.options["ESP"][teem]["Box"][5][1][4] - 40) /255

						allesp.outerbox[playernum].Visible = true
						allesp.outerbox[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1), math.floor(top.y + 35))
						allesp.outerbox[playernum].Size = Vector2.new(math.floor(box_width + 2), math.floor(bottom.y - top.y + 2))
						allesp.outerbox[playernum].Transparency = (mp.options["ESP"][teem]["Box"][5][1][4] - 40) /255
					end
					if mp.options["ESP"][teem]["Health Bar"][1] then
						if mp.options["ESP"][teem]["Health Number"][1] and health <= mp.options["ESP"]["ESP Settings"]["Max HP Visibility Cap"][1] then
							allesp.hptext[playernum].Visible = true
							allesp.hptext[playernum].Text = tostring(health)
							local hp_sub = 0
							if health < 100 then
								if health < 10 then
									hp_sub = 4
								else
									hp_sub = 2
								end
							end
							if math.floor(top.y + 31) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)) + 12 > bottom.y + 36 then
								allesp.hptext[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1) - math.ceil(allesp.hptext[playernum].TextBounds.x) - hp_sub, math.floor((top.y + 31) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)) - (math.floor(top.y + 31) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)) + 12 - (bottom.y + 36))))
							else
								allesp.hptext[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1) - math.ceil(allesp.hptext[playernum].TextBounds.x) - hp_sub, math.floor(top.y + 31) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)))
							end
							allesp.hptext[playernum].Color = RGB(mp.options["ESP"][teem]["Health Number"][5][1][1], mp.options["ESP"][teem]["Health Number"][5][1][2], mp.options["ESP"][teem]["Health Number"][5][1][3])
							allesp.hptext[playernum].Transparency = mp.options["ESP"][teem]["Health Number"][5][1][4]/255
						end

						allesp.hpouter[playernum].Visible = true
						allesp.hpouter[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1) - 6, math.floor(top.y + 35))
						allesp.hpouter[playernum].Size = Vector2.new(4, math.floor(bottom.y - top.y + 2))

						allesp.hpinner[playernum].Visible = true
						allesp.hpinner[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1) - 5, math.floor(top.y + 36) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)))
						allesp.hpinner[playernum].Color = math.ColorRange(health, {
							[1] = {start = 0, color = Color3.fromRGB(mp.options["ESP"][teem]["Health Bar"][5][1][1][1][1], mp.options["ESP"][teem]["Health Bar"][5][1][1][1][2], mp.options["ESP"][teem]["Health Bar"][5][1][1][1][3])},
							[2] = {start = 100, color = Color3.fromRGB(mp.options["ESP"][teem]["Health Bar"][5][1][2][1][1], mp.options["ESP"][teem]["Health Bar"][5][1][2][1][2], mp.options["ESP"][teem]["Health Bar"][5][1][2][1][3])}
						})
						allesp.hpinner[playernum].Size = Vector2.new(2, math.floor((bottom.y - top.y)*(health/100)))
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
						allesp.hptext[playernum].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1) - math.ceil(allesp.hptext[playernum].TextBounds.x) + 6 - hp_sub, math.floor(top.y + 32))
						allesp.hptext[playernum].Color = RGB(mp.options["ESP"][teem]["Health Number"][5][1][1], mp.options["ESP"][teem]["Health Number"][5][1][2], mp.options["ESP"][teem]["Health Number"][5][1][3])
						allesp.hptext[playernum].Transparency = mp.options["ESP"][teem]["Health Number"][5][1][4]/255
					end
					if mp.options["ESP"][teem]["Held Weapon"][1] then
						local wepname = "KNIFE"
						for k2, v2 in ipairs(v1.Character:GetChildren()) do
							if k2 == 8 then
								if v1.Name == nil then
									wepname = "KNIFE"
								else
									wepname = tostring(v2.Name)
								end
							end
						end
						if mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 1 then
							wepname = string.lower(wepname)
						elseif mp.options["ESP"]["ESP Settings"]["Text Case"][1] == 3 then
							wepname = string.upper(wepname)
						end
						spoty += 12
						allesp.weptext[playernum].Text = wepname
						allesp.weptext[playernum].Visible = true
						allesp.weptext[playernum].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y + 36))
						allesp.weptext[playernum].Color = RGB(mp.options["ESP"][teem]["Held Weapon"][5][1][1], mp.options["ESP"][teem]["Held Weapon"][5][1][2], mp.options["ESP"][teem]["Held Weapon"][5][1][3])
						allesp.weptext[playernum].Transparency = mp.options["ESP"][teem]["Held Weapon"][5][1][4]/255
					end
					if mp.options["ESP"][teem]["Distance"][1] then

						allesp.disttext[playernum].Text = tostring(math.ceil(bottom.z / 5)).."m"
						allesp.disttext[playernum].Visible = true
						allesp.disttext[playernum].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y + 34) + spoty)
						allesp.disttext[playernum].Color = RGB(mp.options["ESP"][teem]["Distance"][5][1][1], mp.options["ESP"][teem]["Distance"][5][1][2], mp.options["ESP"][teem]["Distance"][5][1][3])
						allesp.disttext[playernum].Transparency = mp.options["ESP"][teem]["Distance"][5][1][4]/255
					end
					if mp.options["ESP"][teem]["Skeleton"][1] then
						local torso = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v1.Character.Torso.Position.x, v1.Character.Torso.Position.y, v1.Character.Torso.Position.z))
						for k2, v2 in ipairs(skelparts) do
							local posie = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v1.Character:FindFirstChild(v2).Position.x, v1.Character:FindFirstChild(v2).Position.y, v1.Character:FindFirstChild(v2).Position.z))
							allesp.skel[k2][playernum].From = Vector2.new(posie.x, posie.y + 36)
							allesp.skel[k2][playernum].To = Vector2.new(torso.x, torso.y + 36)
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
		local vm = workspace.Camera:GetChildren()
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
							v1.Transparency = 0.99999+(mp.options["Visuals"]["Local Visuals"]["Weapon Chams"][5][1][4]/-255) --- it works shut up + i don't wanna make a fucking table for this shit
						end
						if mp.options["Visuals"]["Local Visuals"]["Remove Weapon Skin"][1] then
							for i2, v2 in pairs(v1:GetChildren()) do
								if v2:IsA("Texture") or v2:IsA("Decal") then
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
		if mp.getval("Visuals", "Misc Visuals", "Ragdoll Chams") then
			for k, v in ipairs(workspace.Ignore.DeadBody:GetChildren()) do
				for k1, v1 in pairs(v:GetChildren()) do
					if v1.Material ~= mats[mp.getval("Visuals", "Misc Visuals", "Ragdoll Material")] then
						if v1.Name == "Torso" and v1:FindFirstChild("Pant") then
							v1.Pant:Destroy()
						end
						v1.Color = mp.getval("Visuals", "Misc Visuals", "Ragdoll Chams", "color", true)
						v1.Transparency = 1+(mp.getval("Visuals", "Misc Visuals", "Ragdoll Chams", "color")[4]/-255)
						v1.Material = mats[mp.getval("Visuals", "Misc Visuals", "Ragdoll Material")]
						if v1:FindFirstChild("Mesh") then
							v1.Mesh:Destroy()
						end
					end
				end
			end
		end
	end
end

local camera = {}
local aimbot = {}


do
	camera.GetGun = function()
		for k, v in pairs(workspace.Camera:GetChildren()) do
			if v.Name ~= "Right Arm" and v.Name ~= "Left Arm" then
				return v
			end
		end
	end

	aimbot.GetBodyParts = function()

		local BodyParts = {}

		for i, Player in ipairs(game.Players:GetPlayers()) do
			if Player.Team ~= MainPlayer.Team then
				local PlayerBodyParts = client.replication.getbodyparts(Player)
				if PlayerBodyParts then
					for i1, Part in ipairs(PlayerBodyParts) do
						if partInterperet[Part.Name] then
							BodyParts[Part] = Part
						end
					end
				end
			end
		end

		return BodyParts
	end

	aimbot.GetTargetLegit = function(fov, partPreference, hitscan)
		local closest, closestPart = math.map(fov, 0, 180, 1, -1)
		partPreference = partPreference and partPreference or "head"
		hitscan = hitscan and true or false

		for i, Player in pairs(game.Players:GetPlayers()) do
			if Player.Team == MainPlayer.Team then continue end
			local Parts = client.replication.getbodyparts(Player)
			if Parts then
				local dot = client.cam.cframe.LookVector:Dot((Parts[partPreference].Position - client.cam.cframe.p).Unit)
				if dot > closest then
					closest = dot
					closestPart = Parts.head
				end
			end
		end

		return closestPart, math.map(closest, -1, 1, 180, 0)
	end

	aimbot.TriggerBot = function()
		if Input:IsKeyDown(mp.getval("Legit", "Trigger Bot", "Enabled", "keybind")) then
			--table.foreach(mp.getval("Legit", "Trigger Bot", "Trigger Bot Hitboxes"), print)
			--print("Key Is Down")
			local parts = mp.getval("Legit", "Trigger Bot", "Trigger Bot Hitboxes")

			parts["Head"] = parts[1]
			parts["Torso"] = parts[2]
			parts["Right Arm"] = parts[3]
			parts["Left Arm"] = parts[3]
			parts["Right Leg"] = parts[4]
			parts["Left Leg"] = parts[4]

			local gun = camera.GetGun()
			if gun then
				local barrel = gun.Flame
				if barrel and client.logic.currentgun and client.logic.currentgun.type ~= "KNIFE" then
					local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(barrel.CFrame.Position, barrel.CFrame.LookVector*5000), {workspace.Camera, workspace.Players[MainPlayer.Team.Name]})
					client.logic.currentgun:shoot(parts[hit.Name])
				end
			end
		end
	end
end

local renderstepped = game.RunService.RenderStepped:Connect(function()
	rendersteppedfunc()
	renderVisuals()
	aimbot.TriggerBot()
end)
-- wait(20)
-- unrender()
