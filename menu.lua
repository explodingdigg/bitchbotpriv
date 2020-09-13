if game.PlaceId ~= 292439477 and game.PlaceId ~= 299659045 then 
	--fuck off
	return 
end
local CanPenetrate


local Vector3new = Vector3.new()
local Vector2new = Vector2.new()

local Input = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MainPlayer = game.Players.LocalPlayer

setfpscap(1000)

--alan put this shit in the loader whenever u think it's ready for release
local waiting = Drawing.new("Text")
waiting.Visible = true
waiting.Transparency = 1
waiting.Color = Color3.fromRGB(150, 60, 190)
waiting.Size = 50
waiting.Text = "loading..."
waiting.Center = true
waiting.Outline = true
waiting.OutlineColor = Color3.fromRGB(90, 20, 130)
waiting.Font = 3
waiting.Position = Vector2.new(200,100)

wait(12-time())				
wait(3)
waiting:Remove()

local poop1 = workspace.MenuLobby:Clone()
poop1.Parent = workspace
for k, v in pairs(poop1:GetDescendants()) do 
    pcall(function()
        if v.Transparency > 0 then
            v.CanCollide = false
        end
	end)
end
poop1.GunStage.GunModel:Destroy()
poop1.GunStage.ThirdPM:Destroy()

for k, v in pairs(workspace.MenuLobby:GetChildren()) do
	if v:FindFirstChild("CamPos") then
		local a = Instance.new("Part", workspace)
		a.Size = Vector3.new(3,3,3)
		a.Position = v.CamPos.CFrame.Position
		a.Shape = 0
		a.Orientation = v.CamPos.Orientation
		a.Material = "SmoothPlastic"
		a.Anchored = true
		a.Color = Color3.new(1,1,1)
		a.CanCollide = false
	end
end

if not isfolder("bbconfigs") then 
	makefolder("bbconfigs")
end

for i = 1, 6 do 
	if not isfile("bbconfigs/config"..tostring(i)..".bb") then 
		writefile("bbconfigs/config"..tostring(i)..".bb", "")
	end
end

local frameCount = 0
local gamenet
local gamesound
local gamelogic
local gamechar
local gamecam
local gamehud
local gamereplication
local gamebulletcheck
local gametraj
local gamedeploy
local gameparticle
local gameround

local gameNetwork = game:GetService("NetworkClient")
local gameSettings = UserSettings():GetService("UserGameSettings")

-- use this to reverse gunmods note to self from nathan
-- this shit is driving me insane i am going to bed 🛌🏿
local oldGuns = {}
for k, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "camkickmax") and rawget(v, "name") then
    	oldGuns[v.name] = {}
    	for k1, v1 in pairs(v) do
    		oldGuns[v.name][tostring(k1)] = v1
    	end
    end
end
-- table.foreach(oldGuns,print)


local ignoreList = {}
function updateMap()
	ignoreList = {workspace.Camera}
	for k, v in pairs(workspace:GetDescendants()) do
		pcall(function()
			if v.Transparency >= 0.8 or v.CanCollide == false then
				ignoreList[v] = v
			end
		end)
	end
	print "[Bitch.Bot] Map Updated"
end



for k, v in pairs(getgc(true)) do
	if type(v) == "function" then
		if getinfo(v).name == "bulletcheck" then
			gamebulletcheck = v
		elseif getinfo(v).name == "trajectory" then
			gametraj = v
		end
		for k1, v1 in pairs(debug.getupvalues(v)) do
			if type(v1) == "table" then
				if rawget(v1, "send") then
					gamenet = v1
				elseif rawget(v1, "gammo") then
					gamelogic = v1
				elseif rawget(v1, "loadknife") then
					gamechar = v1
				elseif rawget(v1, "basecframe") then
					gamecam = v1
				elseif rawget(v1, "votestep") then
					gamehud = v1
				elseif rawget(v1, "getbodyparts") then
					gamereplication = v1
				elseif rawget(v1, "play") then
					gamesound = v1
				elseif rawget(v1, "checkkillzone") then
					gameround = v1
				end
			end
		end
	end
	if type(v) == "table" then
		if rawget(v, "deploy") then
			gamedeploy = v
		elseif rawget(v, "new") and rawget(v, "step") then
			gameparticle = v
		end
	end
end

local function table_contains(table, element) --copied from stack overflow, needed this beat to checks stuffs
	for _, value in pairs(table) do --copy == paster, just sayin 
		if value == element then
			return true
		end
	end
	return false
end

local camshake = gamecam.shake
local suppress = gamecam.suppress
local breakwindow
local send = gamenet.send 
local Cam = workspace.CurrentCamera
local chatGame = MainPlayer.PlayerGui.ChatGame
local chatBox = chatGame:FindFirstChild("TextBox")

local rageTarget, rageHitbox, rageAngles
local ragebotShootin = false
local triggerbotShootin = false
local sexTarget
local highlightedGuys = {}
local originPart = Instance.new("Part")

local flyToggle = false
drawcount = 0
local function draw_filled_rect(visible, pos_x, pos_y, width, height, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Square")
	tablename[varname].Visible = visible
	tablename[varname].Position = Vector2.new(pos_x, pos_y)
	tablename[varname].Size = Vector2.new(width, height)
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Filled = true
	tablename[varname].Thickness = 0
	tablename[varname].Transparency = a / 255
end

local function draw_outlined_rect(visible, pos_x, pos_y, width, height, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Square")
	tablename[varname].Visible = visible
	tablename[varname].Position = Vector2.new(pos_x, pos_y)
	tablename[varname].Size = Vector2.new(width, height)
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Filled = false
	tablename[varname].Thickness = 0
	tablename[varname].Transparency = a / 255
end

local function draw_text(text, font, visible, pos_x, pos_y, size, centered, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Text")
	tablename[varname].Text = text
	tablename[varname].Visible = visible
	tablename[varname].Position = Vector2.new(pos_x, pos_y)
	tablename[varname].Size = size
	tablename[varname].Center = centered
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Transparency = a / 255
	tablename[varname].Outline = false
	tablename[varname].Font = font
end

local function draw_outlined_text(text, font, visible, pos_x, pos_y, size, centered, r, g, b, a, r2, g2, b2, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Text")
	tablename[varname].Text = text
	tablename[varname].Visible = visible
	tablename[varname].Position = Vector2.new(pos_x, pos_y)
	tablename[varname].Size = size
	tablename[varname].Center = centered
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Transparency = a / 255
	tablename[varname].Outline = true
	tablename[varname].Font = font
	tablename[varname].OutlineColor = Color3.fromRGB(r2, g2, b2)
end

local function draw_line(visible, thickness, start_x, start_y, end_x, end_y, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Line")
	tablename[varname].Visible = visible
	tablename[varname].Thickness = thickness
	tablename[varname].From = Vector2.new(start_x, start_y)
	tablename[varname].To = Vector2.new(end_x, end_y)
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Transparency = a / 255
end

local function draw_circle(visible, pos_x, pos_y, size, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Circle")
	tablename[varname].Position = Vector2.new(pos_x, pos_y)
	tablename[varname].Visible = visible
	tablename[varname].Radius = size
	tablename[varname].Thickness = 1
	tablename[varname].NumSides = 20
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Transparency = a / 255
end

local function draw_tri(visible, pa_x, pa_y, pb_x, pb_y, pc_x, pc_y, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Triangle")
	tablename[varname].Visible = visible
	tablename[varname].Transparency = a/255
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Thickness = 3.8
	tablename[varname].PointA = Vector2.new(pa_x, pa_y)
	tablename[varname].PointB = Vector2.new(pb_x, pb_y)
	tablename[varname].PointC = Vector2.new(pc_x, pc_y)
	tablename[varname].Filled = false
end

local function draw_filled_tri(visible, pa_x, pa_y, pb_x, pb_y, pc_x, pc_y, r, g, b, a, tablename)
	drawcount = drawcount + 1
	varname = tostring(drawcount)
	tablename[varname] = Drawing.new("Triangle")
	tablename[varname].Visible = visible
	tablename[varname].Transparency = a/255
	tablename[varname].Color = Color3.fromRGB(r, g, b)
	tablename[varname].Thickness = 2
	tablename[varname].PointA = Vector2.new(pa_x, pa_y)
	tablename[varname].PointB = Vector2.new(pb_x, pb_y)
	tablename[varname].PointC = Vector2.new(pc_x, pc_y)
	tablename[varname].Filled = true
end

local vec3Gravity = Vector3.new(0, -196.2, 0) 


--da esp so it renders bellow the menu
local enemy_skel_head = {}
local enemy_skel_right_arm = {}
local enemy_skel_left_arm = {}
local enemy_skel_right_leg = {}
local enemy_skel_left_leg = {}
local enemy_skeleton = {enemy_skel_head, enemy_skel_torso, enemy_skel_right_arm, enemy_skel_left_arm, enemy_skel_right_leg, enemy_skel_left_leg}

local enemybox = {}
local enemy_outer_outline = {}
local enemy_inner_outline = {}
local enemy_outlines = {enemy_outer_outline, enemy_inner_outline}
local enemy_name_text = {}
local enemy_wep_text = {}
local enemy_dist_text = {}


local enemy_health_text = {}
local enemy_health_outer = {}
local enemy_health_back = {}
local enemy_health_inner = {}
local enemy_health = {enemy_health_outer, enemy_health_back, enemy_health_inner, enemy_health_text}

---------------------- DROPED ESP OR WHATEVA
local dropped_wep = {}
local dropped_wep_ammo = {}

local outline_boxes = {enemy_outer_outline, enemy_inner_outline}
local alltext = {enemy_name_text, enemy_wep_text, enemy_dist_text}
local allboxes = {enemybox, enemy_outer_outline, enemy_inner_outline}
local allvisualshit = 
{
	enemybox, enemy_outer_outline, enemy_inner_outline, enemy_name_text, enemy_wep_text, enemy_dist_text,
	enemy_health_outer, enemy_health_back, enemy_health_inner, enemy_health_text,
	enemy_skel_head, enemy_skel_torso, enemy_skel_right_arm, enemy_skel_left_arm, enemy_skel_right_leg, enemy_skel_left_leg,
	
	dropped_wep, dropped_wep_ammo
}

-- nate please fix how this looks its like 4 am please
-- what all this shit above here? EWWW
-- i didnt ask you to make fun of me i asked u to clean it up!!!!!!!!!!!!!!

drawcount = 0
for i = 1, 60 do 
	draw_outlined_text("nil", 2, false, 30, 30, 13, true, 255, 255, 255, 255, 0, 0, 0, dropped_wep)
end

drawcount = 0
for i = 1, 60 do 
	draw_outlined_text("nil", 2, false, 30, 30, 13, true, 255, 255, 255, 255, 0, 0, 0, dropped_wep_ammo)
end

for k, v in pairs(enemy_skeleton) do
	drawcount = 0
	for i = 1, 32 do
		draw_line(false, 1, 30, 30, 50, 50, 255, 255, 255, 255, v)
	end
end

for k, v in pairs(enemy_health) do
	drawcount = 0
	for i = 1, 32 do
		if v == enemy_health_outer then
			draw_outlined_rect(false, 30, 30, 30, 30, 0, 0, 0, 220, v)
		elseif v == enemy_health_text then
			draw_outlined_text("nil", 3, false, 30, 30, 13, true, 255, 255, 255, 255, 0, 0, 0, v)
		else
			draw_filled_rect(false, 30, 30, 30, 30, 40, 40, 40, 220, v)
		end 
	end
end

for k, v in pairs(alltext) do
	drawcount = 0
	for i = 1, 32 do
		draw_outlined_text("nil", 2, false, 30, 30, 13, true, 255, 255, 255, 255, 0, 0, 0, v)
	end
end

for k, v in pairs(allboxes) do
	drawcount = 0
	for i = 1, 32 do
		draw_outlined_rect(false, 30, 30, 30, 30, 255, 255, 255, 255, v)
	end
end

for k, v in pairs(outline_boxes) do
	for k1, v1 in pairs(v) do
		v1.Transparency = 220 / 255
		v1.Color = Color3.fromRGB(0, 0, 0)
	end
end

local mouse = MainPlayer:GetMouse()
local screen_w = mouse.ViewSizeX
local screen_h = mouse.ViewSizeY + 72
drawcount = 0 
local fovthingy = {} 
local magnetfov = {}
draw_circle(false, screen_w/2, screen_h/2, 100, 255, 255, 255, 255, fovthingy)
draw_circle(false, screen_w/2, screen_h/2, 100, 255, 255, 255, 255, magnetfov)

--mp stands for menu pos

local bbmenu = {}
local mp = {
	w = 603,
	h = 450,
	x = math.floor(screen_w/2 - 603/2),
	y = math.floor(screen_h/2 - 450/2)
}
local tab = 1
local menuclosing = false
local menuopen = true
local menualpha = 0

drawcount = 0
draw_filled_rect(true, mp.x, mp.y, mp.w, mp.h, 99, 54, 128, menualpha, bbmenu)
-- da frame
draw_outlined_rect(true, mp.x, mp.y, mp.w, mp.h, 25, 25, 25, menualpha, bbmenu)
draw_outlined_rect(true, mp.x + 1, mp.y + 1, mp.w - 2, mp.h - 2, 67, 67, 67, menualpha, bbmenu)
for i = 1, 3 do
	draw_outlined_rect(true, mp.x + 1 + i, mp.y + 1 + i, mp.w - 2 - (i * 2), mp.h - 2 - (i * 2), 40, 40, 40, menualpha, bbmenu)
end
draw_outlined_rect(true, mp.x + 5, mp.y + 5, mp.w - 10, mp.h - 10, 67, 67, 67, menualpha, bbmenu)
draw_outlined_rect(true, mp.x + 6, mp.y + 6, mp.w - 12, mp.h - 12, 25, 25, 25, menualpha, bbmenu)
draw_outlined_rect(true, mp.x + 7, mp.y + 7, mp.w - 14, mp.h - 14, 127, 72, 163, menualpha, bbmenu)
-- da inside
draw_outlined_rect(true, mp.x + 11, mp.y + 23, mp.w - 22, mp.h - 34, 127, 72, 163, menualpha, bbmenu)
draw_outlined_rect(true, mp.x + 12, mp.y + 24, mp.w - 24, mp.h - 36, 25, 25, 25, menualpha, bbmenu)
draw_outlined_rect(true, mp.x + 13, mp.y + 25, mp.w - 26, mp.h - 38, 67, 67, 67, menualpha, bbmenu)
draw_filled_rect(true, mp.x + 14, mp.y + 26, mp.w - 28, mp.h - 40, 40, 40, 40, menualpha, bbmenu)
draw_outlined_text("bitch bot", 2, true, mp.x + 20, mp.y + 8, 13, false, 255, 255, 255, menualpha, 0, 0, 0, bbmenu)

-- da tabs
for i = 1, 5 do
	draw_filled_rect(true, mp.x + 14 + ((i - 1) * 115), mp.y + 26, 115, 40, 50, 50, 50, menualpha, bbmenu)
end

for i = 1, 5 do
	draw_outlined_rect(true, mp.x + 14 + ((i - 1) * 115), mp.y + 26, 115, 40, 60, 60, 60, menualpha, bbmenu)
end
draw_outlined_rect(true, mp.x + 14, mp.y + 66, 575, 370, 60, 60, 60, menualpha, bbmenu)

for i = 1, 5 do
	draw_outlined_rect(false, mp.x + 14 + ((i - 1) * 115) + 1, mp.y + 65, 113, 2, 40, 40, 40, menualpha, bbmenu)
end
draw_outlined_text("legit", 2, true, mp.x + 72, mp.y + 38, 13, true, 255, 255, 255, menualpha, 0, 0, 0, bbmenu)
draw_outlined_text("rage", 2, true, mp.x + 72 + 115, mp.y + 38, 13, true, 255, 255, 255, menualpha, 0, 0, 0, bbmenu)
draw_outlined_text("visuals", 2, true, mp.x + 72 + 115 * 2, mp.y + 38, 13, true, 255, 255, 255, menualpha, 0, 0, 0, bbmenu)
draw_outlined_text("misc", 2, true, mp.x + 72 + 115 * 3, mp.y + 38, 13, true, 255, 255, 255, menualpha, 0, 0, 0, bbmenu)
draw_outlined_text("settings", 2, true, mp.x + 72 + 115 * 4, mp.y + 38, 13, true, 255, 255, 255, menualpha, 0, 0, 0, bbmenu)

local tab1 = {}
local tab2 = {}
local tab3 = {} --dont swear
local tab4 = {}
local tab5 = {}
local alltabs = {tab1, tab2, tab3, tab4, tab5}
local function set_tab_visible(tab) -- thanks wolfie for compressing
	for k, v in pairs(alltabs) do
		for k1, v1 in pairs(v) do
			v1.Transparency = 1
		end
	end
	if tab == 1 then
		for k, v in pairs(alltabs) do
			for k1, v1 in pairs(v) do
				if v == tab1 then
					v1.Visible = true
				else
					v1.Visible = false
				end
			end
		end
	elseif tab == 2 then
		for k, v in pairs(alltabs) do
			for k1, v1 in pairs(v) do
				if v == tab2 then
					v1.Visible = true
				else
					v1.Visible = false
				end
			end
		end
	elseif tab == 3 then
		for k, v in pairs(alltabs) do
			for k1, v1 in pairs(v) do
				if v == tab3 then
					v1.Visible = true
				else
					v1.Visible = false
				end
			end
		end
	elseif tab == 4 then
		for k, v in pairs(alltabs) do
			for k1, v1 in pairs(v) do
				if v == tab4 then
					v1.Visible = true
				else
					v1.Visible = false
				end
			end
		end
	elseif tab == 5 then
		for k, v in pairs(alltabs) do
			for k1, v1 in pairs(v) do
				if v == tab5 then
					v1.Visible = true
				else
					v1.Visible = false
				end
			end
		end
	end
end

-- this shit is here for reference and stuffs
-- draw_outlined_rect(true, 21, 21, 3, 3, 127, 72, 163, 0, bbmouse)
-- draw_text(text, font, visible, pos_x, pos_y, size, centered, r, g, b, a, tablename)
-- mp.x + 14, mp.y + 26, mp.w - 28, mp.h - 40
-- dark grey = 25, 25, 25
-- lighter grey = 60, 60, 60


local BlinkText = {}
--draw_outlined_text(text, font, visible, pos_x, pos_y, size, centered, r, g, b, a, r2, g2, b2, tablename)
draw_outlined_text("Blink", 3, true, 100, 100, 25, false, 60, 0, 120, 255, 20, 0, 40, BlinkText)
local tab1pos = {}
local tab2pos = {}
local tab3pos = {}
local tab4pos = {}
local tab5pos = {}
local allpostabs = {tab1pos, tab2pos, tab3pos, tab4pos, tab5pos}
drawcount = 0
dctn = 0 -- that means draw count table num

local function add_group_box(text, x, y, width, height, tab, postable) -- i made pos table a seprate table from the tab table because it would be kinda cleaner
	draw_outlined_rect(true, mp.x + 18 + x, mp.y + 75 + y, width, height, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 75 + y}
	
	draw_outlined_rect(true, mp.x + 19 + x, mp.y + 76 + y, width - 2, height - 2, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 76 + y}
	
	draw_text(text, 2, true, mp.x + 24 + x, mp.y + 63 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 24 + x, 63 + y}
end

local function add_text(text, x, y, tab, postable)
	draw_text(text, 2, true, mp.x + 18 + x, mp.y + 63 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y}
end

toggles = {}
local activetab = 0
local function add_toggle(valuename, on, text, x, y, tab, postable)
	draw_outlined_rect(true, mp.x + 18 + x, mp.y + 63 + y, 16, 16, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y}
	
	draw_outlined_rect(true, mp.x + 19 + x, mp.y + 64 + y, 14, 14, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 64 + y}
	
	draw_outlined_rect(true, mp.x + 20 + x, mp.y + 65 + y, 12, 12, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 20 + x, 65 + y}
	
	draw_filled_rect(true, mp.x + 21 + x, mp.y + 66 + y, 10, 10, 40, 40, 40, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 21 + x, 66 + y}
	
	for i = 1, 5 do
		if tab == alltabs[i] then
			activetab = i
		end
	end
	
	toggles[valuename] = {on, activetab, tab[tostring(drawcount - 1)], tab[tostring(drawcount)], 18 + x, 63 + y, 16, 16}
	
	draw_text(text, 2, true, mp.x + 38 + x, mp.y + 63 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 38 + x, 63 + y}
end

sliders = {}
local function add_slider(valuename, min, max, cur_value, text, x, y, tab, postable, xtra)
	if cur_value < min then
		cur_value = min
	elseif cur_value > max then
		cur_value = max
	end
	draw_text(text, 2, true, mp.x + 18 + x, mp.y + 63 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y}
	
	draw_outlined_rect(true, mp.x + 18 + x, mp.y + 81 + y, 165 + xtra, 16, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 81 + y}
	
	draw_outlined_rect(true, mp.x + 20 + x, mp.y + 83 + y, 165 + xtra - 4, 12, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 20 + x, 83 + y}
	
	draw_filled_rect(true, mp.x + 20 + x, mp.y + 83 + y, (165 + xtra - 4) * ((cur_value - min) / (max - min)), 12, 99, 54, 128, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 20 + x, 83 + y}
	
	draw_outlined_rect(true, mp.x + 20 + x, mp.y + 83 + y, (165 + xtra - 4) * ((cur_value - min) / (max - min)), 12, 127, 72, 163, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 20 + x, 83 + y}
	
	draw_outlined_rect(true, mp.x + 19 + x, mp.y + 82 + y, 165 + xtra - 2, 14, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 82 + y}
	
	draw_text(tostring(cur_value), 2, true, mp.x + 18 + x + ((165 + xtra) / 2), mp.y + 81 + y, 13, true, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x + ((165 + xtra) / 2), 81 + y}
	
	local activetab = 0
	for i = 1, 5 do
		if tab == alltabs[i] then
			activetab = i
		end
	end
	
	sliders[valuename] = {cur_value, min, max, activetab, tab[tostring(drawcount - 3)], tab[tostring(drawcount - 2)], 20 + x, 83 + y, 12, 161 + xtra, tab[tostring(drawcount)]}
end

buttons = {}
local function add_button(valuename, text, x, y, tab, postable, xtra, xtrah) --text, font, visible, pos_x, pos_y, size, centered, r, g, b, a, tablename
	draw_outlined_rect(true, mp.x + 30 + x, mp.y + 63 + y,  141 + xtra, 25 + xtrah, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 30 + x, 63 + y}
	
	draw_outlined_rect(true, mp.x + 31 + x, mp.y + 64 + y, 139 + xtra, 23 + xtrah, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 31 + x, 64 + y}
	
	draw_filled_rect(true, mp.x + 32 + x, mp.y + 65 + y, 137 + xtra, 21 + xtrah, 99, 54, 128, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 32 + x, 65 + y}
	
	draw_outlined_rect(true, mp.x + 32 + x, mp.y + 65 + y, 137 + xtra, 21 + xtrah, 127, 72, 163, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 32 + x, 65 + y}
	
	draw_text(text, 2, true, mp.x + 30 + x + ((141 + xtra) / 2), mp.y + 68 + y + math.floor(xtrah/2), 13, true, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 30 + x + ((141 + xtra) / 2), 68 + y + math.floor(xtrah/2)}
	
	local activetab = 0
	for i = 1, 5 do
		if tab == alltabs[i] then
			activetab = i
		end
	end
	
	buttons[valuename] = {activetab, x + 30, y + 63, 141 + xtra, 25 + xtrah, tab[tostring(drawcount - 2)], tab[tostring(drawcount - 1)]}
	
end

dropboxes = {}
local function add_dropbox(valuename, curoption, options, text, x, y, tab, postable, xtra)
	draw_text(text, 2, true, mp.x + 18 + x, mp.y + 63 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y}
	
	draw_filled_rect(true, mp.x + 18 + x, mp.y + 81 + y, 165 + xtra, 20, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 81 + y}
	
	draw_filled_rect(true, mp.x + 21 + x, mp.y + 84 + y, 165 + xtra - 6, 14, 50, 50, 50, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 21 + x, 84 + y}
	
	draw_outlined_rect(true, mp.x + 19 + x, mp.y + 82 + y, 165 + xtra - 2, 18, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 82 + y}
	
	draw_outlined_rect(true, mp.x + 164 + x + xtra, mp.y + 82 + y, 18, 18, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 164 + x + xtra, 82 + y}
	
	draw_outlined_text(">", 2, true, mp.x + 173 + x + xtra, mp.y + 83 + y, 13, true, 255, 255, 255, 255, 0, 0, 0, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 173 + x + xtra, 83 + y}
	local dropthingy = tab[tostring(drawcount)]
	
	local options = options .. ','
	local num = 0
	local optionss = {}
	for w in options:gmatch("(.-),") do 
		num = num + 1
		table.insert(optionss, w)
	end
	
	draw_text(optionss[curoption], 2, true, mp.x + 21 + x, mp.y + 83 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 21 + x, 83 + y}
	local wordz = tab[tostring(drawcount)]
	
	local boxez = {}
	
	draw_filled_rect(true, mp.x + 18 + x, mp.y + 101 + y, 165 + xtra, 20 * num, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 101 + y}
	table.insert(boxez, tab[tostring(drawcount)])
	
	for i = 1, num do
		draw_outlined_rect(true, mp.x + 19 + x, mp.y + 82 + y + (20 * i), 165 + xtra - 2, 18, 25, 25, 25, 255, tab)
		dctn + = 1
		postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 82 + (20 * i) + y}
		table.insert(boxez, tab[tostring(drawcount)])
		
		draw_filled_rect(true, mp.x + 21 + x, mp.y + 84 + y + (20 * i), 165 + xtra - 6, 14, 50, 50, 50, 255, tab)
		dctn + = 1
		postable[tostring(dctn)] = {tab[tostring(drawcount)], 21 + x, 84 + (20 * i) + y}
		table.insert(boxez, tab[tostring(drawcount)])
		
		draw_text(optionss[i], 2, true, mp.x + 21 + x, mp.y + 83 + y + (20 * i), 13, false, 255, 255, 255, 255, tab)
		dctn + = 1
		postable[tostring(dctn)] = {tab[tostring(drawcount)], 21 + x, 83 + y + (20 * i)}
		table.insert(boxez, tab[tostring(drawcount)])
	end
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 80 + y, 167 + xtra, 20 * (num + 1) + 2, 127, 72, 163, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 80 + y}
	table.insert(boxez, tab[tostring(drawcount)])
	
	for i = 1, 5 do
		if tab == alltabs[i] then
			activetab = i
		end
	end
	
	dropboxes[valuename] = {false, curoption, num, activetab, boxez, dropthingy, 18 + x, 82 + y, 16, 164 + xtra, wordz, optionss}
end



colorpickers = {}
local function add_colorpicker(valuename, text, x, y, r, g, b, a, tab, postable)
	
	draw_outlined_rect(true, mp.x + 18 + x, mp.y + 63 + y, 24, 16, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y}
	
	draw_outlined_rect(true, mp.x + 19 + x, mp.y + 64 + y, 22, 14, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 64 + y}
	
	local colorthingy = {}
	draw_filled_rect(true, mp.x + 20 + x, mp.y + 65 + y, 20, 12, r, g, b, a, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 20 + x, 65 + y}
	table.insert(colorthingy, tab[tostring(drawcount)])
	
	for i = 1, 2 do 
		draw_outlined_rect(true, mp.x + 19 + i + x, mp.y + 64 + i + y, 22 - (i * 2), 14 - (i * 2), r - 30, g - 30, b - 30, a, tab)
		dctn + = 1
		postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + i + x, 64 + i + y}
		table.insert(colorthingy, tab[tostring(drawcount)])
	end
	
	for i = 1, 5 do
		if tab == alltabs[i] then
			activetab = i
		end
	end
	
	colorpickers[valuename] = {activetab, 18 + x,  63 + y, 24, 16, r, g, b, a, colorthingy, false, text}
end
--:byte()

local keynamereturn = {
	["One"]    = "1",
	["Two"]    = "2", 
	["Three"]  = "3",
	["Four"]   = "4",
	["Five"]   = "5",
	["Six"]    = "6",
	["Seven"]  = "7",
	["Eight"]  = "8",
	["Nine"]   = "9",
	["Zero"]   = "0",
	["LeftBracket"] = "[",
	["RightBracket"] = "]",
	["Semicolon"] = ":",
	["BackSlash"] = "\\",
	["Slash"] = "/",
	["Minus"] = "-",
	["Equals"] = "=",
	["Return"] = "Enter",
	["Backquote"] = "`",
	["CapsLock"] = "Caps",
	["LeftShift"] = "LShift",
	["RightShift"] = "RShift",
	["LeftControl"] = "LCtrl",
	["RightControl"] = "RCtrl",
	["LeftAlt"] = "LAlt",
	["RightAlt"] = "RAlt",
	["Backspace"] = "Back",
	["Plus"] = "+",
	["Multiply"] = "x",
	["PageUp"] = "PgUp",
	["PageDown"] = "PgDown",
	["Delete"] = "Del",
	["Insert"] = "Ins",
	["NumLock"] = "NumL",
	["Comma"] = ",",
	["Period"] = "."
}

local function keyenum2name(key) -- did this all in a function cuz why not
	local _key = tostring(key.KeyCode).. "."
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
	if keyname == "Unknown" or key.KeyCode.Value == 27 then 
		return "None"
	end
	for k, v in pairs(keynamereturn) do 
		if keynamereturn[keyname]  then
			return keynamereturn[keyname]
		end
	end 
	return keyname
end

keybinds = {}
local none = Enum.KeyCode.Escape
local function add_keybind(valuename, keyenum, x, y, tab, postable) --sorry about the key enum thingy sowwy
	
	draw_outlined_rect(true, mp.x + 18 + x, mp.y + 63 + y, 48, 20, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y}
	local outerbox = tab[tostring(drawcount)]
	
	draw_outlined_rect(true, mp.x + 19 + x, mp.y + 64 + y, 46, 18, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 64 + y}
	
	local _key = tostring(keyenum).. "."
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
	if keyname == "Unknown" or keyenum.Value == 27 then 
		keyname = "None"
		keyenum = nil
	end
	for k, v in pairs(keynamereturn) do 
		if keynamereturn[keyname]  then
			return keynamereturn[keyname]
		end
	end
	
	draw_text(keyname, 2, true, mp.x + 42 + x, mp.y + 65 + y, 13, true, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 42 + x, 65 + y}
	local text = tab[tostring(drawcount)]
	
	for i = 1, 5 do
		if tab == alltabs[i] then
			activetab = i
		end
	end
	
	keybinds[valuename] = {activetab, 18 + x, 63 + y, 48, 20, text, outerbox, false, keyenum}
end

local plist_gui = {}
local function add_plist(x, y, tab, postable)
	local plist_squares = {}
	for i = 1, 11 do
		local everythin = {}
		draw_outlined_rect(true, mp.x + 18 + x, mp.y + 63 + y + ((i - 1) * 20), 366, 20, 60, 60, 60, 255, tab)
		dctn + = 1
		postable[tostring(dctn)] = {tab[tostring(drawcount)], 18 + x, 63 + y + ((i - 1) * 20)}
		local outerbox = tab[tostring(drawcount)]
		table.insert(everythin, tab[tostring(drawcount)])
		
		draw_outlined_rect(true, mp.x + 19 + x, mp.y + 64 + y + ((i - 1) * 20), 364, 18, 25, 25, 25, 255, tab)
		dctn + = 1
		postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x, 64 + y + ((i - 1) * 20)}
		table.insert(everythin, tab[tostring(drawcount)])
		
		local textz = {}
		for i1 = 1, 3 do
			if i1 ~= 3 then
				draw_outlined_rect(true, mp.x + 19 + x + math.floor((366/3)* i1), mp.y + 66 + y + ((i - 1) * 20), 1, 15, 25, 25, 25, 255, tab)
				dctn + = 1
				postable[tostring(dctn)] = {tab[tostring(drawcount)], 19 + x + math.floor((366/3)* i1), 66 + y + ((i - 1) * 20)}
				table.insert(everythin, tab[tostring(drawcount)])
			end
			
			if i1 == 1 then
				draw_text("poop", 2, true, mp.x + 23 + x , mp.y + 65 + y  + ((i - 1) * 20), 13, false, 255, 255, 255, 255, tab)
				dctn + = 1
				postable[tostring(dctn)] = {tab[tostring(drawcount)], 23 + x, 65 + y + ((i - 1) * 20)}
				table.insert(textz, tab[tostring(drawcount)])
				table.insert(everythin, tab[tostring(drawcount)])
			else
				draw_text("poop", 2, true, mp.x + 20 + x + math.floor((366/3)* i1) - ((366/3)/2), mp.y + 65 + y  + ((i - 1) * 20), 13, true, 255, 255, 255, 255, tab)
				dctn + = 1
				postable[tostring(dctn)] = {tab[tostring(drawcount)], 20 + x + math.floor((366/3)* i1) - ((366/3)/2), 65 + y + ((i - 1) * 20)}
				table.insert(textz, tab[tostring(drawcount)])
				table.insert(everythin, tab[tostring(drawcount)])
			end
		end
		table.insert(plist_squares, {outerbox, textz, everythin})
	end
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 283 + y, 369, 1, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 283 + y}
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 284 + y, 369, 1, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 284 + y}
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 285 + y, 369, 1, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 285 + y}
	
	draw_text("page 1 of 1", 2, true, mp.x + 204 + x, mp.y + 294 + y, 13, true, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 204 + x, 294 + y}
	local texty = tab[tostring(drawcount)]
	
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 318 + y, 369, 1, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 318 + y}
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 319 + y, 369, 1, 25, 25, 25, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 319 + y}
	
	draw_outlined_rect(true, mp.x + 17 + x, mp.y + 320 + y, 369, 1, 60, 60, 60, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 17 + x, 320 + y}
	
	draw_text("player name: ", 2, true, mp.x + 23 + x, mp.y + 324 + y, 13, false, 255, 255, 255, 255, tab)
	dctn + = 1
	postable[tostring(dctn)] = {tab[tostring(drawcount)], 23 + x, 324 + y}
	local ply_info = tab[tostring(drawcount)]
	
	plist_gui = {plist_squares, texty, ply_info}
end 

--tab 1 (legit)
add_group_box("aim assist", 4, 6, 181, 347, tab1, tab1pos)
add_toggle("legit.aimbot.enabled", false, "aim assist", 12, 26, tab1, tab1pos)
add_slider("legit.aimbot.smooth", 0, 100, 10, "smoothing", 12, 48, tab1, tab1pos, 0)
add_slider("legit.aimbot.fov", 0, 500, 50, "aimbot fov", 12, 88, tab1, tab1pos, 0)
add_slider("legit.aimbot.random", 0, 20, 5, "randomization", 12, 128, tab1, tab1pos, 0)
add_toggle("legit.aimbot.static", false, "force priority", 12, 256, tab1, tab1pos)
add_slider("legit.aimbot.deadzone", 0, 20, 5, "deadzone", 12, 278, tab1, tab1pos, 0)
add_toggle("legit.aimbot.traj", true, "drop prediction", 12, 320, tab1, tab1pos)

add_dropbox("legit.aimbot.priority", 1, "closest,torso,head", "hitbox priority", 12, 214, tab1, tab1pos, 0)
add_dropbox("legit.aimbot.keybind", 3, "always,right mouse,left mouse,smart", "aimbot keybind", 12, 172, tab1, tab1pos, 0)


add_group_box("triggerbot", 192, 6, 182, 347, tab1, tab1pos)
add_toggle("legit.trigger.enabled", false, "triggerbot", 200, 26, tab1, tab1pos)
add_keybind("legit.trigger.key", Enum.KeyCode.M, 319, 24, tab1, tab1pos)
add_slider("legit.trigger.magnet.smooth", 0, 100, 10, "magnet smoothing", 200, 48, tab1, tab1pos,0)
add_slider("legit.trigger.magnet.fov", 0, 100, 25, "magnet fov", 200, 90, tab1, tab1pos,0)

add_group_box("recoil control", 381, 6, 182, 347, tab1, tab1pos)
add_toggle("legit.rcs.camera.enabled", false, "camera recoil", 389, 26, tab1, tab1pos)
add_slider("legit.rcs.camera.scale", 0, 10, 8, "scale", 389, 48, tab1, tab1pos, 0)
add_toggle("legit.rcs.gun.enabled",false,"weapon recoil", 389, 90, tab1, tab1pos)

--tab 2 (rage)
add_group_box("aimbot", 4, 6, 181, 347, tab2, tab2pos)
add_toggle("rage.aimbot.enabled", false, "aimbot", 12, 26, tab2, tab2pos)
add_keybind("rage.aimbot.enabled", none, 130, 24, tab2, tab2pos)

add_toggle("rage.aimbot.silent", false, "silent aim", 12, 48, tab2, tab2pos)
add_slider("rage.aimbot.fov", 0, 1000, 0, "ragebot fov", 12, 70, tab2, tab2pos, 0)

add_toggle("rage.aimbot.raytrace", false, "autowall", 12, 112, tab2, tab2pos)
add_toggle("rage.aimbot.autofire", false, "auto fire", 12, 134, tab2, tab2pos)
add_toggle("rage.aimbot.autoscope", false, "auto scope", 12, 156, tab2, tab2pos)
add_toggle("rage.aimbot.static", false, "force priority", 12, 222, tab2,tab2pos)
add_slider("rage.aimbot.step", 1, 144, 50, "autowall accuracy", 12, 262, tab2, tab2pos, 0)
--add_toggle("rage.aimbot.serverside", false, "shoot serverside", 12, 244, tab2, tab2pos)

add_dropbox("rage.aimbot.priority.part", 1, "head,torso", "hitbox priority", 12, 178, tab2, tab2pos, 1)

add_group_box("gun mods", 192, 6, 182, 347, tab2, tab2pos)-- gun mods
add_toggle("rage.gunmods.norecoil", false, "no recoil", 200, 26, tab2, tab2pos)
add_toggle("rage.gunmods.nospread", false, "no spread", 200, 48, tab2, tab2pos)
add_toggle("rage.gunmods.nosway", false, "no sway", 200, 70, tab2, tab2pos)
add_toggle("rage.gunmods.autofire", false, "fully automatic", 200, 92, tab2, tab2pos)
add_toggle("rage.gunmods.firerate", false, "fire rate (wip)", 200, 114, tab2, tab2pos)
add_slider("rage.gunmods.firerate", 0, 3000, 0, "", 200, 120, tab2, tab2pos, 1)
add_toggle("rage.gunmods.fastanim", false, "instant reload", 200, 162, tab2, tab2pos)
add_toggle("rage.gunmods.rungun", false, "run and gun", 200, 184, tab2, tab2pos)
add_toggle("rage.gunmods.crosshairsize", false, "shotgun nospread", 200, 206, tab2, tab2pos)

add_group_box("antiaim", 381, 6, 182, 347, tab2, tab2pos)
add_toggle("rage.antiaim", false, "antiaim", 389, 26, tab2, tab2pos)
add_keybind("rage.antiaim", none, 509, 24, tab2, tab2pos)
add_toggle("rage.antiaim.stance", false, "fake stance", 389, 48, tab2, tab2pos)
add_keybind("rage.antiaim.stancekey", none, 509, 46, tab2, tab2pos)
add_slider("rage.antiaim.spin", 0, 200, 100, "spin speed", 389, 196, tab2, tab2pos, 1)
add_slider("rage.antiaim.jitter", 0, 180, 0, "jitter range", 389, 236, tab2, tab2pos, 1)
add_toggle("rage.antiaim.infloor", false, "hide in floor", 389, 276, tab2, tab2pos)
add_toggle("rage.antiaim.fakesprint", true, "fake sprint", 389, 298, tab2, tab2pos)
add_toggle("rage.antiaim.blink", false, "blink", 389, 320, tab2, tab2pos)
add_keybind("rage.antiaim.blink", none, 509, 318, tab2, tab2pos)
add_toggle("rage.antiaim.fakeangles", false, "fake angles", 389, 342, tab2, tab2pos)
add_keybind("rage.antiaim.fakeangles", none, 509, 340, tab2, tab2pos)

add_dropbox("rage.antiaim.Y", 1, "forward,spin,random,back", "antiaim yaw", 389, 154, tab2, tab2pos, 1)
add_dropbox("rage.antiaim.X", 1, "off,down,up,roll,upside down,random","antiaim pitch", 389, 112, tab2, tab2pos, 1)
add_dropbox("rage.antiaim.stancetype", 3, "standing,crouch,prone,funny", "stance type", 389, 70, tab2, tab2pos, 1)

--tab 3 (visuals)
add_group_box("enemy esp", 4, 6, 181, 165, tab3, tab3pos) ------ ENEMY ESP SUB TAB
add_toggle("esp.enemy.name", false, "name", 12, 26, tab3, tab3pos)
add_colorpicker("esp.enemy.name", "enemy name", 152, 26, 255, 255, 255, 255, tab3, tab3pos)

add_toggle("esp.enemy.box", false, "box", 12, 48, tab3, tab3pos)
add_colorpicker("esp.enemy.box", "enemy box", 152, 48, 235, 64, 52, 255, tab3, tab3pos)

add_toggle("esp.enemy.healthbar", false, "health bar", 12, 70, tab3, tab3pos)
add_colorpicker("esp.enemy.hpmin", "enemy min health", 152, 70, 255, 0, 0, 255, tab3, tab3pos)
add_colorpicker("esp.enemy.hpmax", "enemy max health", 122, 70, 0, 255, 0, 255, tab3, tab3pos)

add_toggle("esp.enemy.weapon", false, "weapon", 12, 92, tab3, tab3pos)
add_colorpicker("esp.enemy.weapon", "enemy weapon", 152, 92, 255, 255, 255, 255, tab3, tab3pos)

add_toggle("esp.enemy.distance", false, "distance", 12, 114, tab3, tab3pos)
add_colorpicker("esp.enemy.distance", "ememy distance", 152, 114, 255, 255, 255, 255, tab3, tab3pos)

add_toggle("esp.enemy.chams", false, "chams", 12, 136, tab3, tab3pos)
add_colorpicker("esp.enemy.chamsvis", "enemy visible chams", 152, 136, 255, 0, 0, 200, tab3, tab3pos)
add_colorpicker("esp.enemy.chamsinvis", "ememy invisble chams", 122, 136, 255, 255, 255, 40, tab3, tab3pos)

add_toggle("esp.enemy.skeleton", false, "skeleton", 12, 158, tab3, tab3pos)
add_colorpicker("esp.enemy.skeleton", "enemy skelton", 152, 158, 255, 255, 255, 255, tab3, tab3pos)

add_group_box("team esp", 4, 188, 181, 165, tab3, tab3pos) ------ TEAM ESP SUB TAB
add_toggle("esp.team.name", false, "name", 12, 207, tab3, tab3pos)
add_colorpicker("esp.team.name", "team name", 152, 207, 255, 255, 255, 255, tab3, tab3pos)

add_toggle("esp.team.box", false, "box", 12, 230, tab3, tab3pos)
add_colorpicker("esp.team.box", "team box", 152, 230, 76, 235, 52, 255, tab3, tab3pos)

add_toggle("esp.team.healthbar", false, "health bar", 12, 252, tab3, tab3pos)
add_colorpicker("esp.team.hpmin", "team min health", 152, 252, 255, 0, 0, 255, tab3, tab3pos)
add_colorpicker("esp.team.hpmax", "team max health", 122, 252, 0, 255, 0, 255, tab3, tab3pos)

add_toggle("esp.team.weapon", false, "weapon", 12, 274, tab3, tab3pos)
add_colorpicker("esp.team.weapon", "team weapon", 152, 274, 255, 255, 255, 255, tab3, tab3pos)

add_toggle("esp.team.distance", false, "distance", 12, 296, tab3, tab3pos)
add_colorpicker("esp.team.distance", "team distance", 152, 296, 255, 255, 255, 255, tab3, tab3pos)

add_toggle("esp.team.chams", false, "chams", 12, 317, tab3, tab3pos)
add_colorpicker("esp.team.chamsvis", "team visible chams", 152, 317, 0, 255, 0, 200, tab3, tab3pos)
add_colorpicker("esp.team.chamsinvis", "team invisble chams", 122, 317, 255, 255, 255, 40, tab3, tab3pos)

add_toggle("esp.team.skeleton", false, "skeleton", 12, 340, tab3, tab3pos)
add_colorpicker("esp.team.skeleton", "team skeleton", 152, 340, 255, 255, 255, 255, tab3, tab3pos)

add_group_box("weapon esp", 192, 6, 182, 76, tab3, tab3pos) -- WEP ESP SUB TAB 
add_toggle("esp.weapon.name", false, "name", 200, 26, tab3, tab3pos)
add_colorpicker("esp.weapon.name", "weapon name", 341, 26, 255, 255, 255, 255, tab3, tab3pos)
add_toggle("esp.weapon.ammo", false, "ammo", 200, 48, tab3, tab3pos)
add_colorpicker("esp.weapon.ammo", "weapon ammo", 341, 48, 255, 255, 255, 255, tab3, tab3pos)
add_toggle("esp.weapon.nadeesp", false, "nade range", 200, 70, tab3, tab3pos)
add_colorpicker("esp.weapon.nadeesp", "nade range", 341, 70, 255, 0, 0, 255, tab3, tab3pos)

add_group_box("esp settings", 192, 99, 182, 141, tab3, tab3pos) -- ESP SETTINGS SUB TAB --250, 0, 0
add_toggle("esp.settings.showfriends", false, "show friends", 200, 161, tab3, tab3pos)
add_colorpicker("esp.settings.showfriends", "friend color", 341, 161, 52, 155, 235, 255, tab3, tab3pos)
add_toggle("esp.settings.showproirity", false, "show priority", 200, 183, tab3, tab3pos)
add_colorpicker("esp.settings.showproirity", "priority color", 341, 183, 245, 221, 7, 255, tab3, tab3pos)
add_toggle("esp.settings.showtarget", false, "show target", 200, 205, tab3, tab3pos)
add_colorpicker("esp.settings.showtarget", "target color", 341, 205, 250, 0, 0, 255, tab3, tab3pos)
add_toggle("esp.settings.dynoutline", false, "dynamic outlines", 200, 227, tab3, tab3pos)

add_dropbox("esp.settings.case", 1, "lowercase,Normal,UPPERCASE", "text settings", 200, 117, tab3, tab3pos, 1)

add_group_box("view model", 192, 257, 182, 96, tab3, tab3pos) -- VIEWMODEL VISUALS SUB TAB
add_toggle("esp.vm.handchams", false, "hand chams", 200, 277, tab3, tab3pos)
add_colorpicker("esp.vm.handchams", "hand color", 341, 277, 60, 0, 151, 255, tab3, tab3pos)
add_colorpicker("esp.vm.sleevechams", "sleeve color", 311, 277, 60, 0, 151, 50, tab3, tab3pos)
add_toggle("esp.vm.wepcolor", false, "gun chams", 200, 299, tab3, tab3pos)
add_colorpicker("esp.vm.wepcolor", "weapon color", 341, 299, 60, 0, 151, 255, tab3, tab3pos)
add_colorpicker("esp.vm.sightcolor", "sight color", 311, 299, 255, 255, 255, 255, tab3, tab3pos)

add_dropbox("esp.vm.mat", 1, "off,plastic,ghost,neon,foil,ice", "weapon cham mat", 200, 318, tab3, tab3pos, 1)

add_group_box("world visuals", 381, 6, 182, 136, tab3, tab3pos)
add_toggle("esp.world.forcetime", false, "force time", 389, 26, tab3, tab3pos)
add_slider("esp.world.forcetimenum", 0, 1400, 0, "world time", 389, 48, tab3, tab3pos, 1)
add_toggle("esp.world.ambience", false, "ambience", 389, 88, tab3, tab3pos)
add_colorpicker("esp.world.inisdeambience", "inside ambience", 531, 88, 255, 255, 255, 255, tab3, tab3pos)
add_colorpicker("esp.world.outsideambience", "outside ambience", 501, 88, 255, 255, 255, 255, tab3, tab3pos)
add_slider("esp.world.saturation", 0, 20, 0, "saturation", 389, 110, tab3, tab3pos, -30)
add_colorpicker("esp.world.saturation", "saturation tint", 531, 128, 170, 170, 170, 255, tab3, tab3pos)

add_group_box("misc", 381, 159, 182, 194, tab3, tab3pos) ------ MISC ESP SUB TAB
add_toggle("esp.misc.bloodcolor", false, "blood color", 389, 179, tab3, tab3pos)
add_colorpicker("esp.misc.bloodcolor", "blood color", 531, 179, 255, 0, 0, 255, tab3, tab3pos)
add_toggle("esp.misc.glow", false, "glow chams", 389, 201, tab3, tab3pos)
add_toggle("esp.misc.thinchams", true, "thin invis chams", 389, 223, tab3, tab3pos)
add_toggle("esp.misc.fovcircle", false, "fov circle", 389, 245, tab3, tab3pos)
add_colorpicker("esp.misc.fovcircle", "fov circle", 531, 245, 150, 60, 190, 255, tab3, tab3pos)
add_toggle("esp.misc.ragdollchams", false, "ragdoll chams", 389, 267, tab3, tab3pos)
add_colorpicker("esp.misc.ragdollchams", "ragdoll chams", 531, 267, 150, 60, 190, 255, tab3, tab3pos)
add_toggle("esp.misc.clearscope", false, "clear scope", 389, 289, tab3, tab3pos)
add_toggle("esp.misc.bullettracers", false, "bullet tracers", 389, 311, tab3, tab3pos)
add_colorpicker("esp.misc.bullettracers", "bullet tracers", 531, 311, 150, 60, 190, 255, tab3, tab3pos)
add_toggle("esp.misc.nosuppress",false,"no suppression", 389, 333, tab3, tab3pos)

--tab 4 (misc)
------ MOVEMENT SUB TAB this needs reworking 🤢🤢🤢
add_group_box("movement", 4, 6, 181, 347, tab4, tab4pos) 
add_toggle("misc.movement.fly", false, "butterfly", 12, 26, tab4, tab4pos)
add_keybind("misc.movement.fly", Enum.KeyCode.B, 130, 24, tab4, tab4pos)
add_slider("misc.movement.flyspeed", 0, 100, 70, "wing speed", 12, 46, tab4, tab4pos, 0)
add_toggle("misc.movement.boost", false, "long jump", 12, 88, tab4, tab4pos)
add_keybind("misc.movement.boost", Enum.KeyCode.M, 130, 86, tab4, tab4pos)
add_toggle("misc.movement.speed", false, "speedhack", 12, 110, tab4, tab4pos)
add_keybind("misc.movement.speedhack", none, 130, 108, tab4, tab4pos)
add_slider("misc.movement.speed", 0, 100, 40, "speed", 12, 130, tab4, tab4pos, 0)
add_slider("misc.movement.lowgrav", 0, 400, 0, "gravity", 12, 214, tab4, tab4pos, 0)

add_toggle("misc.movement.antifall", false, "no fall", 12, 294, tab4, tab4pos)
add_toggle("misc.movement.circle", false, "c strafe", 12, 318, tab4, tab4pos)
add_keybind("misc.movement.circlekey", Enum.KeyCode.E, 130, 316, tab4, tab4pos)
add_toggle("misc.movement.tppeek", false, "teleport up", 12, 342, tab4, tab4pos)
add_keybind("misc.movement.tppeek", none, 130, 340, tab4, tab4pos, 0)

add_dropbox("misc.movement.bhop", 1, "off,auto hop,speed hop,speed in air","bhop", 12, 252, tab4, tab4pos, 0)
add_dropbox("misc.movement.lowgrav", 1, "off,new,legacy", "gravity mod", 12, 170, tab4, tab4pos, -53)
add_keybind("misc.movement.lowgravkey", none, 130, 188, tab4, tab4pos)

add_group_box("other", 192, 6, 182, 165, tab4, tab4pos) -- OTHER
add_toggle("misc.other.autorespawn", false, "auto respawn", 200, 26, tab4, tab4pos)
add_toggle("misc.other.breakwindows", false, "break windows", 200, 48, tab4, tab4pos)
add_slider("misc.other.crosssize", 0, 20, 0, "custom crosshair", 200, 70,tab4, tab4pos, 0)
add_slider("misc.other.jumppower", 0, 400, 0, "jump power", 200, 114, tab4, tab4pos, -53)
add_keybind("misc.other.jumppower", none, 319, 128, tab4, tab4pos)

add_group_box("auto vote", 192, 188, 182, 165, tab4, tab4pos) -- AUTO VOTE
add_toggle("misc.avote.enabled", false, "enabled", 200, 207, tab4, tab4pos)

add_dropbox("misc.avote.none", 1, "off,yes,no", "no status", 200, 317, tab4, tab4pos, 1)
add_dropbox("misc.avote.priority", 2, "off,yes,no", "priority", 200, 273, tab4, tab4pos, 1)
add_dropbox("misc.avote.friends", 3, "off,yes,no", "friends", 200, 229, tab4, tab4pos, 1)

add_group_box("player", 381, 6, 182, 347, tab4, tab4pos) -- PLAYERzzzzzz
add_toggle("misc.player.lockplayers", false, "lock players", 389, 26, tab4, tab4pos)
add_keybind("misc.player.lockplayers", Enum.KeyCode.N, 508, 24, tab4, tab4pos)
add_toggle("misc.player.basefov", false, "disable ads fov",389, 48, tab4, tab4pos)
add_slider("misc.player.fov", 0, 120, 0, "fov", 389, 48+22, tab4, tab4pos, 1)
add_toggle("misc.player.grenaderefill", true, "grenade refill", 389, 132+22, tab4, tab4pos)
add_toggle("misc.player.grenadetime", false, "instant grenade", 389, 154+22, tab4, tab4pos)
add_slider("misc.player.grenadetime", 0, 50, 0, "custom grenade time", 389, 176+22, tab4, tab4pos, 1)
add_toggle("misc.player.grenadetp", false, "grenade teleport", 389, 218+22, tab4, tab4pos)
add_toggle("misc.player.scavenge", false, "scavenge ammo", 389, 240+22, tab4, tab4pos)
add_toggle("misc.player.chatspam.repeat", false, "chatspam repeat", 389,306+22,tab4,tab4pos)

add_dropbox("misc.player.chatspam", 1, "off,normal,t0nymode,######,stop talking,chinese propoganda,bad words,emojis,discord,ioncannon", "chat spam", 389, 262+22, tab4, tab4pos, 1)
add_dropbox("misc.player.knifebot", 1, "off,assist,aura", "knife bot", 389, 90+22, tab4, tab4pos, 1)

--tab 5 (SETTINGS)
-- im going to bed 
add_group_box("player list", 4, 6, 370, 347, tab5, tab5pos) ------ CONFIGS SUB TAB
add_plist(6, 20, tab5, tab5pos)
add_button("config.plist.back", "<", 0, 249, tab5, tab5pos, -121, -5)
add_button("config.plist.next", ">", 334, 249, tab5, tab5pos, -121, -5)
add_button("config.plist.vk", "vote kick", 213, 331, tab5, tab5pos, -40, 0)
add_button("config.plist.tp", "tp", 313, 331, tab5, tab5pos, -100, 0)

add_dropbox("config.plist.ptype", 1, "none,friend,priority", "player status", 224, 285, tab5, tab5pos, -23)

add_group_box("configs", 381, 6, 182, 165, tab5, tab5pos) ------ CONFIGS SUB TAB
add_button("config.configs.save", "save config", 389, 72, tab5, tab5pos, 1, 0)
add_button("config.configs.load", "load config", 389, 106, tab5, tab5pos, 1, 0)

add_dropbox("config.configs.configs", 1, "config 1,config 2,config 3,config 4,config 5,config 6", "configs", 389, 26, tab5, tab5pos, 0)

add_group_box("extra settings", 381, 187, 182, 166, tab5, tab5pos) ------ CREDITS SUB TAB
add_toggle("config.extra.logo", true, "bitchbot logo", 389, 207, tab5, tab5pos)
add_toggle("config.extra.friendlyfire", false, "allow friend damage", 389, 229, tab5, tab5pos)
add_toggle("config.extra.ragepriority", false, "rage force priority", 389, 251, tab5, tab5pos)
add_toggle("config.extra.levelup", false, "level up bot", 389, 273, tab5, tab5pos)
add_button("config.extra.tplobby", "lobby tp", 389, 299, tab5, tab5pos, 1, 0)
add_button("config.extra.godmode","god mode", 389, 329, tab5, tab5pos, 1, 0)
--add_keybind("config.extra.clickfriend", Enum.KeyCode.P, 389, 270, tab5, tab5pos)
--add_text("friend key", 440, 273, tab5, tab5pos)

--color picker 
local cpp = {
	x = 700,
	y = 300,
	w = 250,
	h = 310
} -- color picker pos and width
local colorpickeropen = true
local colorpicker = {}

drawcount = 0
draw_filled_rect(true, cpp.x, cpp.y, cpp.w, cpp.h, 99, 54, 128, 255, colorpicker)
-- da frame
draw_outlined_rect(true, cpp.x, cpp.y, cpp.w, cpp.h, 25, 25, 25, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 1, cpp.y + 1, cpp.w - 2, cpp.h - 2, 67, 67, 67, 255, colorpicker)
for i = 1, 3 do
	draw_outlined_rect(true, cpp.x + 1 + i, cpp.y + 1 + i, cpp.w - 2 - (i * 2), cpp.h - 2 - (i * 2), 40, 40, 40, 255, colorpicker)
end
draw_outlined_rect(true, cpp.x + 5, cpp.y + 5, cpp.w - 10, cpp.h - 10, 67, 67, 67, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 6, cpp.y + 6, cpp.w - 12, cpp.h - 12, 25, 25, 25, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 7, cpp.y + 7, cpp.w - 14, cpp.h - 14, 127, 72, 163, 255, colorpicker)
-- da inside
draw_outlined_rect(true, cpp.x + 11, cpp.y + 23, cpp.w - 22, cpp.h - 34, 127, 72, 163, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 12, cpp.y + 24, cpp.w - 24, cpp.h - 36, 25, 25, 25, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 13, cpp.y + 25, cpp.w - 26, cpp.h - 38, 67, 67, 67, 255, colorpicker)
draw_filled_rect(true, cpp.x + 14, cpp.y + 26, cpp.w - 28, cpp.h - 40, 40, 40, 40, 255, colorpicker)
draw_outlined_text("color picker", 2, true, cpp.x + 20, cpp.y + 8, 13, false, 255, 255, 255, 255, 0, 0, 0, colorpicker)
local colorpickertext = colorpicker[tostring(drawcount)]
draw_filled_rect(true, cpp.x + 24, cpp.y + 187, 96, 66, 255, 255, 255, 255, colorpicker)
draw_filled_rect(true, cpp.x + 24, cpp.y + 187, 96, 66, 255, 0, 0, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 24, cpp.y + 187, 96, 66, 220, 0, 0, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 25, cpp.y + 188, 94, 64, 220, 0, 0, 255, colorpicker)
local old_color = {colorpicker[tostring(drawcount - 2)], colorpicker[tostring(drawcount - 1)], colorpicker[tostring(drawcount)]}
draw_filled_rect(true, cpp.x + 130, cpp.y + 187, 96, 66, 255, 255, 255, 255, colorpicker)
draw_filled_rect(true, cpp.x + 130, cpp.y + 187, 96, 66, 255, 0, 0, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 130, cpp.y + 187, 96, 66, 220, 0, 0, 255, colorpicker)
draw_outlined_rect(true, cpp.x + 131, cpp.y + 188, 94, 64, 220, 0, 0, 255, colorpicker)
local new_color = {colorpicker[tostring(drawcount - 2)], colorpicker[tostring(drawcount - 1)], colorpicker[tostring(drawcount)]}

local colorpickerz = {}
local colorpickerpos = {}
add_slider("colorpicker.r", 0, 255, 100, "red", 2, -36, colorpickerz, colorpickerpos, 45)
add_slider("colorpicker.g", 0, 255, 100, "green", 2, 0, colorpickerz, colorpickerpos, 45)
add_slider("colorpicker.b", 0, 255, 100, "blue", 2, 36, colorpickerz, colorpickerpos, 45)
add_slider("colorpicker.a", 0, 255, 255, "alpha", 2, 72, colorpickerz, colorpickerpos, 45)

add_group_box("current", 4, 110, 100, 70, colorpickerz, colorpickerpos)
add_group_box("new", 110, 110, 100, 70, colorpickerz, colorpickerpos)
add_button("colorpicker.close", "close", -8, 198, colorpickerz, colorpickerpos, -41, 0)--(valuename, text, x, y, tab, postable, xtra)
add_button("colorpicker.apply", "apply", 99, 198, colorpickerz, colorpickerpos, -41, 0)

local function set_old_color(r, g, b, a)
	for k, v in pairs(old_color) do 
		if k == 1 then 
			v.Color = Color3.fromRGB(r, g, b)
			v.Transparency = a/255
		else
			v.Color = Color3.fromRGB(r - 30, g - 30, b - 30)
			v.Transparency = a/255
		end
	end
end


local function set_new_color(r, g, b, a)
	for k, v in pairs(new_color) do 
		if k == 1 then 
			v.Color = Color3.fromRGB(r, g, b)
			v.Transparency = a/255
		else
			v.Color = Color3.fromRGB(r - 30, g - 30, b - 30)
			v.Transparency = a/255
		end
		
	end
end 

local function set_cp_text(text)
	colorpickertext.Text = text
end

local function set_colorpicker_pos(x, y)
	colorpicker["1"].Position = Vector2.new(x, y)
	for i = 0, 7 do
		colorpicker[tostring(i + 2)].Position = Vector2.new(x + i, y + i)
	end
	for i = 0, 3 do
		colorpicker[tostring(i + 10)].Position = Vector2.new(x + 11 + i, y + 23 + i)
	end
	colorpicker["14"].Position = Vector2.new(x + 20, y + 8)
	colorpicker["15"].Position = Vector2.new(x + 24, y + 187)
	for k, v in pairs(old_color) do
		if k == 3 then
			v.Position = Vector2.new(x + 25, y + 188)
		else
			v.Position = Vector2.new(x + 24, y + 187)
		end
	end
	colorpicker["19"].Position = Vector2.new(x + 130, y + 187)
	for k, v in pairs(new_color) do
		if k == 3 then
			v.Position = Vector2.new(x + 131, y + 188)
		else
			v.Position = Vector2.new(x + 130, y + 187)
		end
	end
	
	for k, v in pairs(colorpickerpos) do
		v[1].Position = Vector2.new(v[2] + x, v[3] + y)
	end
	
	cpp.x = x
	cpp.y = y
end

local function set_colorpicker_visible(visible)
	for k, v in pairs(colorpicker) do 
		v.Visible = visible
	end
	for k, v in pairs(colorpickerpos) do
		v[1].Visible = visible 
	end
end

local function set_colorpicker(visible, pos_x, pos_y, r, g, b, a, text)
	colorpickeropen = visible 
	set_colorpicker_visible(visible)
	set_colorpicker_pos(pos_x, pos_y)
	set_old_color(r, g, b, a)
	set_new_color(r, g, b, a)
	
	for k, v in pairs(sliders) do
		if v[4] == 0 then
			if v == sliders["colorpicker.r"] then
				v[1] = r
			elseif v == sliders["colorpicker.g"] then
				v[1] = g
			elseif v == sliders["colorpicker.b"] then
				v[1] = b
			elseif v == sliders["colorpicker.a"] then
				v[1] = a
			end
			v[5].Size = Vector2.new((v[1] - v[2]) / (v[3] - v[2]) * v[10], 12)
			v[6].Size = Vector2.new((v[1] - v[2]) / (v[3] - v[2]) * v[10], 12)
			v[11].Text = tostring(v[1])
		end
	end
	set_cp_text(text)
end

set_colorpicker(false, 800, 300, 99, 54, 128, 255, "nashwhia a s ghhrejsdvgaasdnwhwet ge awelfgawhas dlsdgkas lwajfjkr")

-- this is the awesome mouse (crazy)
local bbmouse = {}
drawcount = 0
-- visible, pos_x, pos_y, width, height, r, g, b, a, tablename
local p1 = 300
local p2 = 300
draw_filled_tri(true, p1, p2, p1, p2 + 15, p1 + 10, p2 + 10, 99, 54, 128, 220, bbmouse)
draw_tri(true, p1 + 1, p2 + 2, p1 + 2, p2 + 13, p1 + 8, p2 + 8, 127, 72, 163, 255, bbmouse)
draw_tri(true, p1, p2, p1, p2 + 15, p1 + 10, p2 + 10, 25, 25, 25, 255, bbmouse)


drawcount = 0 
-- draw_filled_rect(true, 20, 20, 5, 5, 99, 54, 128, 0, bbmouse)
-- draw_outlined_rect(true, 21, 21, 3, 3, 127, 72, 163, 0, bbmouse)
-- draw_outlined_rect(true, 20, 20, 5, 5, 25, 25, 25, 0, bbmouse)


local function set_menu_mouse_pos(x, y)
	for k, v in pairs(bbmouse) do
		if v == bbmouse["2"] then
			v.PointA = Vector2.new(x + 1, y + 37)
			v.PointB = Vector2.new(x + 1, y + 36 + 13)
			v.PointC = Vector2.new(x + 8, y + 46)
		else
			v.PointA = Vector2.new(x, y + 36)
			v.PointB = Vector2.new(x, y + 36 + 15)
			v.PointC = Vector2.new(x + 10, y + 46)
		end
	end
end

gamecam.shake = function(...)
	local args = {...}
	
	if toggles["legit.rcs.camera.enabled"][1] then
		args[2] = args[2] * (sliders["legit.rcs.camera.scale"][1]/10)
	end
	
	return(camshake(unpack(args)))
end
gamecam.suppress = function(...)
	if toggles["esp.misc.nosuppress"][1] then
		return
	else
		return suppress(...)
	end
end

local menufadespeed = 50

local activetab = tab1
set_tab_visible(tab)
while menualpha < 255 do
	if menuclosing then
		break
	end
	wait(0)
	menualpha = menualpha + menufadespeed
	if menualpha > 255 then
		menualpha = 255
	end
	for k, v in pairs(bbmenu) do
		if v == bbmenu["1"] then
			v.Transparency = (menualpha - 20) / 255
		else
			v.Transparency = menualpha / 255
		end
	end
	for k, v in pairs(bbmouse) do
		if v == bbmouse["1"] then
			v.Transparency = (menualpha - 20) / 255
		else
			v.Transparency = menualpha / 255
		end
	end
	for k, v in pairs(colorpicker) do 
		if v == colorpicker["1"] then 
			v.Transparency = (menualpha - 20) / 255
		else
			v.Transparency = menualpha / 255
		end
	end
	for k, v in pairs(colorpickerpos) do
		v[1].Transparency = menualpha / 255
	end
	if tab == 1 then
		activetab = tab1--this is some fire coding skillz
	elseif tab == 2 then
		activetab = tab2
	elseif tab == 3 then
		activetab = tab3
	elseif tab == 4 then
		activetab = tab4
	elseif tab == 5 then
		activetab = tab5
	end
	for k, v in pairs(activetab) do
		v.Transparency = menualpha / 255
	end
end
local oldPos = Vector3new
local shooties = {}
local keycheck = Input.InputBegan:Connect(function(key)
	if gamelogic.currentgun and gamelogic.currentgun.shoot then
		local shootgun = gamelogic.currentgun.shoot
		if not shooties[gamelogic.currentgun.shoot] then
			gamelogic.currentgun.shoot = function(self, ...)
				if not menuopen then
					shootgun(self, ...)
				end
			end
		end
		shooties[gamelogic.currentgun.shoot] = true
	end
	if key.KeyCode == Enum.KeyCode.Delete then
		if not menuclosing then
			menuclosing = true
			while menualpha > 0 do
				if not menuclosing then
					break
				end
				wait(0)
				menualpha = menualpha - menufadespeed
				if menualpha < 0 then
					menualpha = 0
				end
				for k, v in pairs(bbmenu) do
					if v == bbmenu["1"] then
						v.Transparency = (menualpha - 20) / 255
					else
						v.Transparency = menualpha / 255
					end
				end
				
				if tab == 1 then
					activetab = tab1
				elseif tab == 2 then
					activetab = tab2
				elseif tab == 3 then
					activetab = tab3
				elseif tab == 4 then
					activetab = tab4 -----EWWWW WHY IS THIS A THING
				elseif tab == 5 then
					activetab = tab5
				end
				for k, v in pairs(activetab) do
					v.Transparency = menualpha / 255
				end
				
				for k, v in pairs(bbmouse) do
					if v == bbmouse["1"] then
						v.Transparency = (menualpha - 20) / 255
					else
						v.Transparency = menualpha / 255
					end
				end
				for k, v in pairs(colorpicker) do 
					if v == colorpicker["1"] then 
						v.Transparency = (menualpha - 20) / 255
					else
						v.Transparency = menualpha / 255
					end
				end
				for k, v in pairs(colorpickerpos) do
					v[1].Transparency = menualpha / 255
				end
			end
			menuopen = false
		elseif menuclosing then
			menuopen = true
			menuclosing = false
			while menualpha < 255 do
				if menuclosing then
					break
				end
				wait(0)
				menualpha = menualpha + menufadespeed
				if menualpha > 255 then
					menualpha = 255
				end
				for k, v in pairs(bbmenu) do
					if v == bbmenu["1"] then
						v.Transparency = (menualpha - 20) / 255
					else
						v.Transparency = menualpha / 255
					end
				end
				
				if tab == 1 then
					activetab = tab1
				elseif tab == 2 then
					activetab = tab2 --PLEASE
				elseif tab == 3 then
					activetab = tab3
				elseif tab == 4 then
					activetab = tab4
				elseif tab == 5 then --whyyyy
					activetab = tab5
				end
				for k, v in pairs(activetab) do
					v.Transparency = menualpha / 255
				end
				
				for k, v in pairs(bbmouse) do
					if v == bbmouse["1"] then
						v.Transparency = (menualpha - 20) / 255
					else
						v.Transparency = menualpha / 255
					end
				end
				for k, v in pairs(colorpicker) do 
					if v == colorpicker["1"] then 
						v.Transparency = (menualpha - 20) / 255
					else
						v.Transparency = menualpha / 255
					end
				end
				for k, v in pairs(colorpickerpos) do
					v[1].Transparency = menualpha / 255
				end
				
			end
		end
	end
	local cg = MainPlayer.PlayerGui.ChatGame
	local c = cg:FindFirstChild("TextBox")
	
	if keybinds["misc.movement.fly"][9] and key.KeyCode == keybinds["misc.movement.fly"][9] and MainPlayer.Character and MainPlayer.Character.Humanoid and not chatBox.Active then
		flyToggle = not flyToggle		
		MainPlayer.Character.HumanoidRootPart.Anchored = false
	end
	if toggles["rage.antiaim.fakeangles"][1] and keybinds["rage.antiaim.fakeangles"][9] and key.KeyCode == keybinds["rage.antiaim.fakeangles"][9] and MainPlayer.Character and MainPlayer.Character.Humanoid and not chatBox.Active then
		local asend = gamenet.send
		gamenet.send = function(self, ...)
			local args = {...}
			if args[1] == "newpos" then
				return
			end
			asend(self, unpack(args))
		end

		local root = MainPlayer.Character.HumanoidRootPart
		local offset = -15000000

		root.Anchored = false
		root.CFrame += Vector3.new(0,offset,0)
		wait(0)
		root.Anchored = true
		root.CFrame -= Vector3.new(0,offset,0)
		gamenet.send = asend
				
	end
	-- if keybinds["config.extra.clickfriend"][9]  and key.KeyCode == keybinds["config.extra.clickfriend"][9] then
	-- 	local newFriend = getBestPlayer("friend", true, true)
	-- 	selected_plyr = newFriend
	-- 	dropboxes["config.plist.ptype"][2] = 1
	-- end
	
	if toggles["misc.movement.tppeek"][1] and keybinds["misc.movement.tppeek"][9]  and key.KeyCode == keybinds["misc.movement.tppeek"][9] and toggles["misc.movement.tppeek"][1] and not menuopen and MainPlayer.Character and MainPlayer.Character.Humanoid and not chatBox.Active then
		rp = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
		oldPos = rp.Position
		local pa = RaycastParams.new()
		pa.FilterType = Enum.RaycastFilterType.Blacklist
		pa.FilterDescendantsInstances = {workspace.Camera,workspace.Players,workspace.Ignore}
		local result = workspace:Raycast(rp.Position,Vector3.new(0,100,0),pa)
		if result then
			rp.Position = result.Position - Vector3.new(0,2,0)
		else
			rp.Position += Vector3.new(0,100,0)
		end
	end
	
	if toggles["misc.movement.boost"][1] and keybinds["misc.movement.boost"][9]  and key.KeyCode == keybinds["misc.movement.boost"][9] and not chatBox.Active then
		if MainPlayer.Character and MainPlayer.Character.Humanoid and MainPlayer.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
			MainPlayer.Character:FindFirstChild("HumanoidRootPart").Position += Vector3.new(0,3,0)
			local looking = workspace.CurrentCamera.CFrame.lookVector
			if Vector3.new(rootpart.Velocity.X, 0, rootpart.Velocity.Z).magnitude < 70 then
				rootpart.Velocity = rootpart.Velocity + looking.Unit * 50
			end
			rootpart.Velocity = rootpart.Velocity + Vector3.new(0, 20, 0)

		end
	end
end)
	
local mouseup = true
local dragging = false 
local dontdrag = false
local clickspot_x, clickspot_y, original_menu_x, original_menu_y = 0, 0, 0, 0

local function mouse_pressed_in(x, y, width, height)
	if mouse.X > mp.x + x and mouse.X < mp.x + x + width and mouse.y > mp.y - 36 + y and mouse.Y < mp.y - 36 + y + height then
		return true
	else
		return false
	end
end

local function mouse_pressed_in_colorpicker(x, y, width, height)
	if mouse.X > cpp.x + x and mouse.X < cpp.x + x + width and mouse.y > cpp.y - 36 + y and mouse.Y < cpp.y - 36 + y + height then
		return true
	else
		return false
	end
end


local function set_menu_pos(x, y)
	bbmenu["1"].Position = Vector2.new(x, y)
	for i = 0, 7 do
		bbmenu[tostring(i + 2)].Position = Vector2.new(x + i, y + i)
	end
	for i = 0, 3 do
		bbmenu[tostring(i + 10)].Position = Vector2.new(x + 11 + i, y + 23 + i)
	end
	bbmenu["14"].Position = Vector2.new(x + 20, y + 8)
	for i = 1, 5 do
		bbmenu[tostring(i + 14)].Position = Vector2.new(x + 14 + ((i - 1) * 115), y + 26)
	end
	for i = 1, 5 do
		bbmenu[tostring(i + 19)].Position = Vector2.new(x + 14 + ((i - 1) * 115), y + 26)
	end
	bbmenu["25"].Position = Vector2.new(x + 14, y + 66)
	for i = 1, 5 do
		bbmenu[tostring(i + 25)].Position = Vector2.new(x + 14 + ((i - 1) * 115) + 1, y + 65)
	end
	for i = 1, 5 do
		bbmenu[tostring(i + 30)].Position = Vector2.new(x + 72 + (115 * (i - 1)), y + 38)
	end
	
	for k, v in pairs(allpostabs) do
		for k1, v1 in pairs(v) do
			v1[1].Position = Vector2.new(v1[2] + x, v1[3] + y)--why oh god why
		end
	end
end

local setmag = gamecam.setmagnification
local setsway = gamecam.setswayspeed

-- gamecam.setmagnification = function(self, v) 
-- 	setmag(self, toggles["misc.player.basefov"][1] and 0.5 or v)
-- 	gamecam.basefov = gamechar.unaimedfov
-- end

local mt = getraw

gamecam.setswayspeed = function(self,v)
	setsway(self, toggles["rage.gunmods.nosway"][1] and 0 or v)
end

oldGunMods = {
	toggles["rage.gunmods.norecoil"][1],
	toggles["rage.gunmods.nospread"][1],
	toggles["rage.gunmods.nosway"][1],
	toggles["rage.gunmods.autofire"][1],
	sliders["rage.gunmods.firerate"][1],
	toggles["rage.gunmods.fastanim"][1],
	toggles["rage.gunmods.rungun"][1],
	toggles["rage.gunmods.crosshairsize"][1]
}


function gunModsApply()
	local  l = {
		toggles["rage.gunmods.norecoil"][1],
		toggles["rage.gunmods.nospread"][1],
		toggles["rage.gunmods.nosway"][1],
		toggles["rage.gunmods.autofire"][1],
		sliders["rage.gunmods.firerate"][1],
		toggles["rage.gunmods.fastanim"][1],
		toggles["rage.gunmods.rungun"][1],
		toggles["rage.gunmods.crosshairsize"][1]
	}
	if oldGunMods ~= l then
		oldGunMods = l
		for i, data in pairs(getgc(true)) do
			if type(data) == "table" and rawget(data, "camkickmax") then
				for k1, v1 in pairs(data) do
					if data[k1] and oldGuns[data.name] and oldGuns[data.name][k1] then
						if type(oldGuns[data.name][k1]) == "table" then
							for k2, v2 in pairs(oldGuns[data.name][k1]) do
								data[k1][k2] = v2
							end
						else
							data[k1] = oldGuns[data.name][k1]
						end
					end
				end

				if toggles["rage.gunmods.norecoil"][1] then
					data.camkickmin = Vector3new
					data.camkickmax = Vector3new
					data.aimcamkickmin = Vector3new
					data.aimcamkickmax = Vector3new
					data.aimtranskickmin = Vector3new
					data.aimtranskickmax = Vector3new
					data.transkickmin = Vector3new
					data.transkickmax = Vector3new
					data.rotkickmin = Vector3new
					data.rotkickmax = Vector3new
					data.aimrotkickmin = Vector3new
					data.aimrotkickmax = Vector3new
				end
				if toggles["rage.gunmods.nospread"][1]  then
					data.hipfirespreadrecover = 100
					data.hipfirespread = 0
					data.hipfirestability = 0
				end
				if toggles["rage.gunmods.autofire"][1]  then
					if rawget(data,"firemodes") and type(data.firemodes) == "table" then
						for a, b in pairs(data.firemodes) do
							data.firemodes = {true, 3, 1}
						end
					end
				end
				if rawget(data, "firerate") and toggles["rage.gunmods.firerate"][1] then
					if rawget(data, "variablefirerate") then
						for k1, v1 in pairs(data.firerate) do
							data.firerate[k1] = sliders["rage.gunmods.firerate"][1]
						end
					else
						data.firerate = sliders["rage.gunmods.firerate"][1]
					end
				end
				if toggles["rage.gunmods.fastanim"][1] then
					data.equipspeed = 10
					data.magnifyspeed = 100
					if data.animations  and type(data.animations) == "table" then
						for o, p in pairs(data.animations) do
							if type(p) == "table" and p ~= rawget(data.animations, "inspect") then
								p.timescale = 0
								p.resettime = 0
								p.stdtimescale = 0
							end
						end
					end
				end
				if toggles["rage.gunmods.rungun"][1] then
					if type(data.sprintoffset) == "CFrame" then
						data.sprintoffset = CFrame.new()
					end
				end
				if toggles["rage.gunmods.crosshairsize"][1]  then
					data.crosssize = 0
					data.crossexpansion = 1
					data.crossspeed = 100
					data.crossdamper = 1
				end
			end
		end
	end
end
for k, v in pairs(dropboxes) do
	for k1, v1 in pairs(v[5]) do
		v1.Visible = false 
	end
end

local keyz = {}
for k, v in pairs(Enum.KeyCode:GetEnumItems()) do
	keyz[v.Value] = v
end

local function plist_page(pagenum, selected_plyr, priorityfellas, friendlyfellas)
	local amount = (pagenum - 1)* 11
	local times = 0
	local players = game.Players:GetPlayers()
	local maxplys = 0
	for k, v in pairs(players) do
		maxplys = k
	end
	local maxpages = math.ceil(maxplys/11)
	plist_gui[2].Text = "page "..pagenum.." of "..maxpages
	for k, v in pairs(plist_gui[1]) do
		if players[k + amount]  then
			for k1, v1 in pairs(v[3]) do
				v1.Visible = true
			end
			if string.len(players[k + amount].Name) > 15 then
				v[2][1].Text = string.sub(players[k + amount].Name, 0, 12) .. "..."
			else
				v[2][1].Text = players[k + amount].Name
			end
			v[2][2].Text = players[k + amount].Team.Name
			v[2][2].Color = players[k + amount].TeamColor.Color
			if players[k + amount] == MainPlayer then
				v[2][3].Text = "Local Player"
				v[2][3].Color = Color3.fromRGB(0, 128, 255)
			elseif table_contains(priorityfellas, players[k + amount]) then
				v[2][3].Text = "Priority"
				v[2][3].Color = Color3.fromRGB(252, 219, 3)
			elseif table_contains(friendlyfellas, players[k + amount]) then
				v[2][3].Text = "Friend"
				v[2][3].Color = Color3.fromRGB(10, 194, 0)
			else
				v[2][3].Text = "None"
				v[2][3].Color = Color3.fromRGB(255, 255, 255)
			end 
		else
			for k1, v1 in pairs(v[3]) do
				v1.Visible = false
			end
		end
		if selected_plyr  then
			if players[k + amount] == selected_plyr then
				v[1].Color = Color3.fromRGB(127, 72, 163)
			else
				v[1].Color = Color3.fromRGB(60, 60, 60)
			end
		else
			v[1].Color = Color3.fromRGB(60, 60, 60)
		end 
	end
	if selected_plyr == nil then
		plist_gui[3].Text = "no player selected"
	else
		local alivetext = "no"
		if gamehud:isplayeralive(selected_plyr) then 
			alivetext = "yes"
		end
		plist_gui[3].Text = "name: "..selected_plyr.Name.."\nteam: "..selected_plyr.Team.Name.."\nkills: ".."\ndeaths: ".."\nalive: ".. alivetext
	end
end
	
local priorityplyrs = {}
local friendplyrs = {}
local plist_pgnum = 1
local selected_plyr = nil
local plist_render = game.RunService.RenderStepped:Connect(function()
	if toggles["rage.aimbot.enabled"][1] then
		gameround.lock = false
	end
	if menuopen and tab == 5 then
		local players = game.Players:GetPlayers()
		local maxplys = 0
		for k, v in pairs(players) do
			maxplys = k
		end
		local maxpages = math.ceil(maxplys/11)
		if plist_pgnum > maxpages then
			plist_pgnum = 1
		end
		if plist_pgnum < 1 then
			plist_pgnum = maxpages
		end
		local foundselecply = false
		for k, v in pairs(players) do
			if v == selected_plyr then 
				foundselecply = true
			end
		end
		if not foundselecply then
			selected_plyr = nil
		end
		plist_page(plist_pgnum, selected_plyr, priorityplyrs, friendplyrs)
	end
end)
for k, v in pairs(toggles) do
	if v[1] == true then
		v[3].Color = Color3.fromRGB(127, 72, 163)
		v[4].Color = Color3.fromRGB(99, 54, 128)
	else
		v[3].Color = Color3.fromRGB(60, 60, 60)
		v[4].Color = Color3.fromRGB(40, 40, 40)
	end
end
	
mouse.Button1Down:Connect(function()
	mouseup = false
	if menuopen then		
		for i = 1, 5 do
			if mouse_pressed_in(14 + ((i - 1) * 115), 26, 115, 40) and not colorpickeropen then
				tab = i
			end
		end
		
		set_tab_visible(tab)
		
		local dropboxopen = false
		local dropboxthatsopen = nil 
		for k, v in pairs(dropboxes) do
			if v[1] == true then
				dropboxopen = true
				dropboxthatsopen = v
				break 
			end
		end
		
		for k, v in pairs(toggles) do --toggles[valuename] = {on, activetab, tab[tostring(drawcount - 1)], tab[tostring(drawcount)], 18 + x, 63 + y, 16, 16}
			if tab == v[2] then
				if mouse_pressed_in(v[5], v[6], v[7], v[8]) and not dropboxopen and not colorpickeropen then
					v[1] = not v[1]
				end
			end
			if v[1] == true then
				v[3].Color = Color3.fromRGB(127, 72, 163)
				v[4].Color = Color3.fromRGB(99, 54, 128)
			else
				v[3].Color = Color3.fromRGB(60, 60, 60)
				v[4].Color = Color3.fromRGB(40, 40, 40)
			end
		end
		
		for k, v in pairs(dropboxes) do
			if tab == v[4] and not colorpickeropen then
				local localdpopen = false
				if dropboxopen and v == dropboxthatsopen then 
					localdpopen = true
				end
				if mouse_pressed_in(v[7], v[8], v[10], v[9]) then
					if v[1] == false then 
						if dropboxopen == false or (dropboxopen and localdpopen) then 
							v[1] = true 
							v[6].Text = "v"
						end
					else
						v[1] = false
						v[6].Text = ">"
					end
				else
					if v[1] then
						for i = 1, v[3] do
							if mouse_pressed_in(v[7], v[8] + (20 * i), v[10], v[9]) then
								v[2] = i
								v[11].Text = v[12][i]
								if k == "config.plist.ptype" then
									local fuck = {priorityplyrs, friendplyrs}
									if v[2] == 1 then
										for k1, v1 in pairs(fuck) do
											for k2, v2 in pairs(v1) do
												if v2 == selected_plyr then
													table.remove(v1, k2)
												end
											end
										end
									elseif v[2] == 2 then
										for k1, v1 in pairs(fuck) do
											for k2, v2 in pairs(v1) do
												if v2 == selected_plyr then
													table.remove(v1, k2)
												end
											end
										end
										table.insert(friendplyrs, selected_plyr)
									else
										for k1, v1 in pairs(fuck) do
											for k2, v2 in pairs(v1) do
												if v2 == selected_plyr then
													table.remove(v1, k2)
												end
											end
										end
										table.insert(priorityplyrs, selected_plyr)
									end
								end
							end
						end
						v[1] = false
						v[6].Text = ">"
					end
				end
			end
			if v[1] == false then 
				for k1, v1 in pairs(v[5]) do
					v1.Visible = false
				end
			end
		end
		
			--colorpickers[valuename] = {activetab, 18 + x,  63 + y, 24, 16, r, g, b, a, colorthingy, false}
		for k, v in pairs(colorpickers) do 
			if tab == v[1] and not colorpickeropen and not dropboxopen then 
				if mouse_pressed_in(v[2], v[3], v[4], v[5]) then
					v[11] = true 
					set_colorpicker(true, mouse.X - 1, mouse.Y + 35, v[6], v[7], v[8], v[9], v[12])
				end
			end
		end
		--60
		--keybinds[valuename] = {activetab, 18 + x, 63 + y, 48, 20, text, outerbox, false, keyenum}
		for k, v in pairs(keybinds) do 
			if tab == v[1] and not colorpickeropen and not dropboxopen then
				if mouse_pressed_in(v[2], v[3], v[4], v[5]) and not v[8] then
					v[8] = true
					v[7].Color = Color3.fromRGB(127, 72, 163)
				elseif v[8] == true then
					v[8] = false
					v[7].Color = Color3.fromRGB(60, 60, 60)
				end
			end
		end
	
		if tab == 5 then
			local amount1 = (plist_pgnum - 1)* 11
			local players1 = game.Players:GetPlayers()
			local maxplys1 = 0
			for k, v in pairs(players1) do
				maxplys1 = k
			end
			local plisty1 = {}
			local times1 = 0
			for k, v in pairs(players1) do
				times1 = times1 + 1
				if times1 > amount1 and times1 < amount1 + 12 then
					table.insert(plisty1, v)
				end
			end
			
			for i = 1, 11 do
				if mouse_pressed_in(24, 83 + ((i - 1) * 20), 366, 20) then
					if plisty1[i]  then
						selected_plyr = plisty1[i]
						if table_contains(friendplyrs, selected_plyr) then
							dropboxes["config.plist.ptype"][2] = 2
							dropboxes["config.plist.ptype"][11].Text = dropboxes["config.plist.ptype"][12][2]
						elseif table_contains(priorityplyrs, selected_plyr) then
							dropboxes["config.plist.ptype"][2] = 3
							dropboxes["config.plist.ptype"][11].Text = dropboxes["config.plist.ptype"][12][3]
						else
							dropboxes["config.plist.ptype"][2] = 1
							dropboxes["config.plist.ptype"][11].Text = dropboxes["config.plist.ptype"][12][1]
						end
					end
				end
			end
		end
		
		if colorpickeropen then
			if not mouse_pressed_in_colorpicker(0, 0, cpp.w, cpp.h) then
				for k1, v1 in pairs(colorpickers) do 
					if v1[11] then
						v1[11] = false
						set_colorpicker(false, 0, 0, 0, 0, 0, 255, "nigger")
					end
				end
			end
		end
		
		for k, v in pairs(buttons) do
			if tab == v[1] then
				if mouse_pressed_in(v[2], v[3], v[4], v[5]) and not colorpickeropen and not dropboxopen then--{activetab, x + 30, y + 63, 141 + xtra, 25, tab[tostring(drawcount - 2)], tab[tostring(drawcount - 1)]}
					if v == buttons["rage.gunmods.apply"] then
						gunModsRevert()
					end
					
					if v == buttons["config.extra.godmode"] then
						gamenet:send("changehealthx", -100, "BFG 50", nil, "", Vector3.new(-9,10,100))
					end
					if v == buttons["config.extra.tplobby"] then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
							245.04956054688,-198.13031005859,241.02880859375)
					end
					if v == buttons["config.plist.back"] then
						plist_pgnum = plist_pgnum - 1
					end 
					if v == buttons["config.plist.next"] then
						plist_pgnum = plist_pgnum + 1
					end 
					if v == buttons["config.plist.vk"] then
						if selected_plyr  then
							gamenet:send("modcmd", "/votekick:".. selected_plyr.Name)
						end
					end
					if v == buttons["config.plist.tp"] then
						if selected_plyr and gamereplication.getbodyparts(selected_plyr) then
							local rp = gamereplication.getbodyparts(selected_plyr).rootpart
							MainPlayer.Character.HumanoidRootPart.CFrame = rp.CFrame
						end
					end
					
					if v == buttons["config.configs.save"] then
						print("save config ".. dropboxes["config.configs.configs"][2])
						writefile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "bitch bot config\ncheat made by bitch, nate, and zarzel\n\n")
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "toggles {\n")
						for k, v in pairs(toggles) do
							local value = 0
							if v[1] then
								value = 1
							else
								value = 0
							end
							appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", k.." "..tostring(value).."\n")
						end
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "}\n")
						
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "sliders {\n")
						for k, v in pairs(sliders) do
							if k == "colorpicker.r" or k == "colorpicker.g" or k == "colorpicker.b" or k == "colorpicker.a" then
								--do notin ninna
							else
								appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", k.." "..tostring(v[1]).."\n")
							end
						end
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "}\n")
						
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "dropboxes {\n")
						for k, v in pairs(dropboxes) do
							if k ~= "config.configs.configs" and k ~= "config.plist.ptype" then
								appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", k.." "..tostring(v[2]).."\n")
							end
						end
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "}\n")
						
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "colorpickers {\n")
						for k, v in pairs(colorpickers) do
							appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", k.." "..tostring(v[6]).." "..tostring(v[7]).." "..tostring(v[8]).." "..tostring(v[9]).."\n")
						end
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "}\n")
						
						--keybinds[valuename] = {activetab, 18 + x, 63 + y, 48, 20, text, outerbox, false, keyenum}
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "keybinds {\n")
						for k, v in pairs(keybinds) do
							if v[9] == nil then
								appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", k.." nil\n")
							else
								appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", k.." "..tostring(v[9].Value).."\n")
							end
						end
						appendfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb", "}\n")
					end
					if v == buttons["config.configs.load"] then
						print("load config ".. dropboxes["config.configs.configs"][2])
						local loadedcfg = readfile("bbconfigs/config"..tostring(dropboxes["config.configs.configs"][2])..".bb")
						local lines = {}
						for s in loadedcfg:gmatch("[^\r\n]+") do
							table.insert(lines, s)
						end
						if lines[1] == "bitch bot config" then
							local toggleslinestart
							local toggleslinestop
							
							local sliderslinestart
							local sliderslinestop
							
							local dropboxeslinestart
							local dropboxeslinestop
							
							local colorpickerslinestart
							local colorpickerslinestop
							
							local keybindslinestart
							local keybindslinestop
							for k, v in pairs(lines) do
								if v == "toggles {" then
									toggleslinestart = k
								end 
								if v == "sliders {" then
									sliderslinestart = k
								end
								if v == "dropboxes {" then
									dropboxeslinestart = k
								end
								if v == "colorpickers {" then
									colorpickerslinestart = k
								end
								if v == "keybinds {" then
									keybindslinestart = k
								end
							end
							
							--------- toggles
							for i = toggleslinestart, table.getn(lines) do
								if lines[i] == "}" then
									toggleslinestop = i
									break
								end
							end
							for i = toggleslinestart + 1, toggleslinestop - 1 do
								local temp = {}
								for token in string.gmatch(lines[i], "[^%s]+") do
									table.insert(temp, token)
								end
								local onornot = false
								if temp[2] == "1" then
									onornot = true
								end
								if toggles[temp[1]]  then
									toggles[temp[1]][1] = onornot 
								end
							end
							for k, v in pairs(toggles) do
								if v[1] == true then
									v[3].Color = Color3.fromRGB(127, 72, 163)
									v[4].Color = Color3.fromRGB(99, 54, 128)
								else
									v[3].Color = Color3.fromRGB(60, 60, 60)
									v[4].Color = Color3.fromRGB(40, 40, 40)
								end
							end
							---------- sliders
							for i = sliderslinestart, table.getn(lines) do
								if lines[i] == "}" then
									sliderslinestop = i
									break
								end
							end
							for i = sliderslinestart + 1, sliderslinestop - 1 do
								local temp = {}
								for token in string.gmatch(lines[i], "[^%s]+") do
									table.insert(temp, token)
								end
								if sliders[temp[1]]  then
									sliders[temp[1]][1] = tonumber(temp[2])
									sliders[temp[1]][5].Size = Vector2.new((sliders[temp[1]][1] - sliders[temp[1]][2]) / (sliders[temp[1]][3] - sliders[temp[1]][2]) * sliders[temp[1]][10], 12)
									sliders[temp[1]][6].Size = Vector2.new((sliders[temp[1]][1] - sliders[temp[1]][2]) / (sliders[temp[1]][3] - sliders[temp[1]][2]) * sliders[temp[1]][10], 12)
									sliders[temp[1]][11].Text = tostring(sliders[temp[1]][1])
								end
							end
							--------- dropboxes
							for i = dropboxeslinestart, table.getn(lines) do
								if lines[i] == "}" then
									dropboxeslinestop = i
									break
								end
							end
							for i = dropboxeslinestart + 1, dropboxeslinestop - 1 do
								local temp = {}
								for token in string.gmatch(lines[i], "[^%s]+") do
									table.insert(temp, token)
								end
								if dropboxes[temp[1]]  and temp[1] ~= "config.configs.configs" and temp[1] ~= "config.plist.ptype" then
									dropboxes[temp[1]][2] = tonumber(temp[2])
									dropboxes[temp[1]][11].Text = dropboxes[temp[1]][12][tonumber(temp[2])]
								end
							end
							--------- colorpickers
							for i = colorpickerslinestart, table.getn(lines) do
								if lines[i] == "}" then
									colorpickerslinestop = i
									break
								end
							end
							for i = colorpickerslinestart + 1, colorpickerslinestop - 1 do
								local temp = {}
								for token in string.gmatch(lines[i], "[^%s]+") do
									table.insert(temp, token)
								end
								if colorpickers[temp[1]]  then
									colorpickers[temp[1]][6] = tonumber(temp[2])
									colorpickers[temp[1]][7] = tonumber(temp[3])
									colorpickers[temp[1]][8] = tonumber(temp[4])
									colorpickers[temp[1]][9] = tonumber(temp[5])
									
									colorpickers[temp[1]][10][1].Color = Color3.fromRGB(colorpickers[temp[1]][6], colorpickers[temp[1]][7], colorpickers[temp[1]][8])
									for i = 1, 2 do 
										colorpickers[temp[1]][10][1 + i].Color = Color3.fromRGB(colorpickers[temp[1]][6]- 30, colorpickers[temp[1]][7] - 30, colorpickers[temp[1]][8] - 30)
									end
								end
							end
							---------- keybinds --keybinds[valuename] = {activetab, 18 + x, 63 + y, 48, 20, text, outerbox, false, keyenum}
							for i = keybindslinestart, table.getn(lines) do
								if lines[i] == "}" then
									keybindslinestop = i
									break
								end
							end
							for i = keybindslinestart + 1, keybindslinestop - 1 do
								local temp = {}
								for token in string.gmatch(lines[i], "[^%s]+") do
									table.insert(temp, token)
								end
								
								if temp[2] ~= "nil" and keybinds[temp[1]]  then
									keybinds[temp[1]][9] = keyz[tonumber(temp[2])]
									local _key = tostring(keyz[tonumber(temp[2])]).. "."
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
									if keyname == "Unknown" then 
										keyname = "None"
										keyenum = nil
									end
									for k, v in pairs(keynamereturn) do 
										if keynamereturn[keyname]  then
											keyname = keynamereturn[keyname]
										end
									end
									keybinds[temp[1]][6].Text = keyname
								else
									keybinds[temp[1]][9] = nil
									keybinds[temp[1]][6].Text = "None"
								end
							end
						end
					end
					v[6].Color = Color3.fromRGB(109, 64, 138)
					v[7].Color = Color3.fromRGB(137, 82, 173)
					wait(0.2)
					v[6].Color = Color3.fromRGB(99, 54, 128)
					v[7].Color = Color3.fromRGB(127, 72, 163)
				end
			elseif v[1] == 0 and colorpickeropen then 
				if mouse_pressed_in_colorpicker(v[2], v[3], v[4], v[5]) then--{activetab, x + 30, y + 63, 141 + xtra, 25, tab[tostring(drawcount - 2)], tab[tostring(drawcount - 1)]}
					local cpthatison = nil
					for k1, v1 in pairs(colorpickers) do 
						if v1[11] then
							cpthatison = v1
						end
					end
					if v == buttons["colorpicker.close"] then 
						cpthatison[11] = false
						set_colorpicker(false, 0, 0, 0, 0, 0, 255, "nigger") --set_colorpicker(visible, pos_x, pos_y, r, g, b, a)
					elseif v == buttons["colorpicker.apply"] then
						set_old_color(sliders["colorpicker.r"][1], sliders["colorpicker.g"][1], sliders["colorpicker.b"][1], sliders["colorpicker.a"][1])
						cpthatison[6] = sliders["colorpicker.r"][1]
						cpthatison[7] = sliders["colorpicker.g"][1]
						cpthatison[8] = sliders["colorpicker.b"][1]
						cpthatison[9] = sliders["colorpicker.a"][1]
						
						cpthatison[10][1].Color = Color3.fromRGB(cpthatison[6], cpthatison[7], cpthatison[8])
						for i = 1, 2 do 
							cpthatison[10][1 + i].Color = Color3.fromRGB(cpthatison[6]- 30, cpthatison[7] - 30, cpthatison[8] - 30)
						end
					end
					
					v[6].Color = Color3.fromRGB(109, 64, 138)
					v[7].Color = Color3.fromRGB(137, 82, 173)
					wait(0.2)
					v[6].Color = Color3.fromRGB(99, 54, 128)
					v[7].Color = Color3.fromRGB(127, 72, 163)
				end	
			end
		end
	end
end)
	
local keybindsthing = Input.InputBegan:Connect(function(key)
	if menuopen then -- keybinds[valuename] = {activetab, 18 + x, 63 + y, 48, 20, text, outerbox, false, keyenum}
		for k, v in pairs(keybinds) do
			if v[8] then
				if key.KeyCode.Value == 0 then
					return
				else
					v[6].Text = tostring(keyenum2name(key))
					v[7].Color = Color3.fromRGB(60, 60, 60)
					v[8] = false
					if keyenum2name(key) == "None" then
						v[9] = nil
					else
						v[9] = key.KeyCode
					end
				end
			end
		end
	end
end)
	
mouse.Button1Up:Connect(function()
	mouseup = true
end)

local BLURY_EFFECT_OR_SOMETHING
--------------------------------------------------------------------draw hook
local dropboxopen = false
local fc = 0 
local wananabethinkhook = game.RunService.RenderStepped:Connect(function() 
	
	MainPlayer = game.Players.LocalPlayer
	Players = game:GetService("Players")
	
	for k, v in pairs(MainPlayer.PlayerGui.MainGui.GameGui.NameTag:GetChildren()) do
		if v.TextColor3.R == 1 then
			if toggles["esp.enemy.name"][1] then
				v.Visible = false
			end
		elseif v.TextColor3.G == 1 then
			if toggles["esp.team.name"][1] then
				v.Visible = false
			end
		end
	end
		
		
	
	local frame = MainPlayer.PlayerGui.MainGui.ScopeFrame
	if toggles["esp.misc.clearscope"][1] and frame then
		if frame:FindFirstChild("SightRear") then
			for k,v in pairs(frame.SightRear:GetChildren()) do
				if v.ClassName == "Frame" then
					v.Visible = false
				end
			end
			frame.SightFront.Visible = false
			frame.SightRear.ImageTransparency = 1
		end
	else
		if frame:FindFirstChild("SightRear") then
			local frame = MainPlayer.PlayerGui.MainGui.ScopeFrame
			for k,v in pairs(frame.SightRear:GetChildren()) do
				if v.ClassName == "Frame" then
					v.Visible = true
				end
			end
			frame.SightFront.Visible = true
			frame.SightRear.ImageTransparency = 0
		end
	end
	
	if toggles["misc.player.basefov"][1] then
		gamecam.basefov = gamechar.unaimedfov
	else
		gamecam.basefov = 80
	end

	if sliders["esp.world.saturation"][1] ~= 0 then
		local pp = colorpickers["esp.world.saturation"]
		game.Lighting.MapSaturation.TintColor = Color3.fromRGB(pp[6], pp[7], pp[8])
		game.Lighting.MapSaturation.Saturation = sliders["esp.world.saturation"][1]/5
	else
		game.Lighting.MapSaturation.TintColor = Color3.fromRGB(170,170,170)
		game.Lighting.MapSaturation.Saturation = -0.25
	end
	
	
	if toggles["rage.gunmods.rungun"][1] then 
		if gamelogic.currentgun and gamelogic.currentgun.type ~= "KNIFE" and gamelogic.currentgun.step ~= CFrame.new then
			debug.setupvalue(gamelogic.currentgun.step, 28, function() return CFrame.new() end)
		end
	end
	
	if toggles["esp.world.ambience"][1] then
		game.Lighting.Ambient = Color3.fromRGB(colorpickers["esp.world.inisdeambience"][6], colorpickers["esp.world.inisdeambience"][7], colorpickers["esp.world.inisdeambience"][8])
		game.Lighting.OutdoorAmbient = Color3.fromRGB(colorpickers["esp.world.outsideambience"][6], colorpickers["esp.world.outsideambience"][7], colorpickers["esp.world.outsideambience"][8])
	else 
		game.Lighting.Ambient = game.Lighting.MapLighting.Ambient.Value
		game.Lighting.OutdoorAmbient = game.Lighting.MapLighting.OutdoorAmbient.Value
	end
	-- yea make this numba biger!
	frameCount = frameCount + 1
	local localply = nil
	local players = workspace.Players.Ghosts:GetChildren()
	table.move(workspace.Players.Phantoms:GetChildren(), 1, #workspace.Players.Phantoms:GetChildren(), #players + 1, players)
	for k, v in pairs(players) do
		if v:FindFirstChild("Humanoid") then
			localply = v
			break
		end
	end
	if toggles["misc.player.grenaderefill"][1] and not localply then
		gamelogic.gammo = 3
	end
	if toggles["misc.player.lockplayers"][1] and keybinds["misc.player.lockplayers"][9]  and Input:IsKeyDown(keybinds["misc.player.lockplayers"][9]) then
		settings().Network.IncommingReplicationLag = 1000
	else 
		settings().Network.IncommingReplicationLag = 0
	end
	
	if sliders["misc.other.crosssize"][1] ~= 0 and not Input:IsMouseButtonPressed(1) then
		local a = sliders["misc.other.crosssize"][1]
		gamehud:setcrosssettings("SNIPER",a,10,0.9)
	end
	
	if menuopen then
		if workspace.Camera:FindFirstChild("Blur") then
			if BLURY_EFFECT_OR_SOMETHING.Size < 10 then
				BLURY_EFFECT_OR_SOMETHING.Size = BLURY_EFFECT_OR_SOMETHING.Size + 1
			end
		else
			BLURY_EFFECT_OR_SOMETHING = Instance.new("BlurEffect")
			BLURY_EFFECT_OR_SOMETHING.Parent = workspace.Camera
			BLURY_EFFECT_OR_SOMETHING.Size = 1
		end
		
		if sliders["misc.player.fov"][1] ~= 0 then
			gamechar.unaimedfov = sliders["misc.player.fov"][1]
		end
		
		if localply  then
			Input.MouseBehavior = Enum.MouseBehavior.Default
		else
			Input.MouseIconEnabled = false
		end
		if ((mouse.X > mp.x and mouse.X < mp.x + 600 and mouse.y > mp.y - 36 and mouse.Y < mp.y - 11) or dragging) and dontdrag == false and colorpickeropen == false then
			if mouseup == false then
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
		elseif mouseup == false then
			dontdrag = true
		elseif mouseup then
			dontdrag = false
		end
		
		if cpp.x < 0 then
			cpp.x = 0
		end
		if mouse.ViewSizeX - cpp.w < cpp.x then
			cpp.x = mouse.ViewSizeX - cpp.w
		end
		if cpp.y < 0 then
			cpp.y = 0
		end
		if (mouse.ViewSizeY + 72) - cpp.h < cpp.y then
			cpp.y = (mouse.ViewSizeY + 72) - cpp.h
		end
		
		set_colorpicker_pos(cpp.x, cpp.y)
		set_menu_mouse_pos(mouse.X, mouse.Y)
		
		
		for i = 1, 5 do
			if tab == i then
				bbmenu[tostring(14 + i)].Visible = false
				bbmenu[tostring(25 + i)].Visible = true
			else
				bbmenu[tostring(14 + i)].Visible = true
				bbmenu[tostring(25 + i)].Visible = false
			end
		end
		
		for k, v in pairs(sliders) do
			if tab == v[4] then
				if mouse_pressed_in(v[7] - 6, v[8], v[10] + 12, v[9]) and mouseup == false and colorpickeropen == false and dropboxopen == false then
					v[1] = math.floor( (((mouse.X - mp.x - v[7] + (v[2] * 2)) / v[10]) * (v[3] - v[2])))
					if v[1] < v[2] then
						v[1] = v[2]
					elseif v[1] > v[3] then
						v[1] = v[3]
					end
					v[5].Size = Vector2.new((v[1] - v[2]) / (v[3] - v[2]) * v[10], 12)
					v[6].Size = Vector2.new((v[1] - v[2]) / (v[3] - v[2]) * v[10], 12)
					v[11].Text = tostring(v[1])
				end
			elseif v[4] == 0 and colorpickeropen then
				if mouse_pressed_in_colorpicker(v[7] - 6, v[8], v[10] + 12, v[9]) and mouseup == false and colorpickeropen then
					v[1] = math.floor( (((mouse.X - cpp.x - v[7] + (v[2] * 2)) / v[10]) * (v[3] - v[2])))
					if v[1] < v[2] then
						v[1] = v[2]
					elseif v[1] > v[3] then
						v[1] = v[3]
					end
					v[5].Size = Vector2.new((v[1] - v[2]) / (v[3] - v[2]) * v[10], 12)
					v[6].Size = Vector2.new((v[1] - v[2]) / (v[3] - v[2]) * v[10], 12)
					v[11].Text = tostring(v[1])
					
					set_new_color(sliders["colorpicker.r"][1], sliders["colorpicker.g"][1], sliders["colorpicker.b"][1], sliders["colorpicker.a"][1])
				end
			end
		end
		
		local foundopendropbox = false
		for k, v in pairs(dropboxes) do
			if v[1] == true then
				dropboxopen = true
				foundopendropbox = true
				break 
			end
		end
		if foundopendropbox == false and dropboxopen then 
			fc = fc + 1
		end
		if fc == 50 then
			fc = 0
			dropboxopen = false
		end
	else
		if workspace.Camera:FindFirstChild("Blur") then
			if BLURY_EFFECT_OR_SOMETHING.Size > 0 then
				BLURY_EFFECT_OR_SOMETHING.Size = BLURY_EFFECT_OR_SOMETHING.Size - 1
			end
		else
			BLURY_EFFECT_OR_SOMETHING = Instance.new("BlurEffect")
			BLURY_EFFECT_OR_SOMETHING.Parent = workspace.Camera
			BLURY_EFFECT_OR_SOMETHING.Size = 0
		end
		
		if localply then
			Input.MouseBehavior = Enum.MouseBehavior.LockCenter
			Input.MouseIconEnabled = false
		else
			Input.MouseBehavior = Enum.MouseBehavior.Default
			Input.MouseIconEnabled = true
		end
	end
end)
	
local Camera = workspace.CurrentCamera

-- nice var names nathan, sincerely nathan
function getKnifeTarget()
	local c = 40
	local t = nil
	local tp = nil
	local lpp = MainPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position
	for k, v in pairs(Players:GetPlayers()) do
		local activate_shiv_awareness_protocol = true
		for fuckyouAlan_iHateYOU, GUY in pairs(friendplyrs) do 
			if v == GUY then
				activate_shiv_awareness_protocol = false
				break
			end
		end
		if toggles["config.extra.ragepriority"][1] then
			activate_shiv_awareness_protocol = false
			for fuckyouAlan_iHateYOU, GUY in pairs(priorityplyrs) do 
				if v == GUY then
					activate_shiv_awareness_protocol = true
				end
			end
		end
		if activate_shiv_awareness_protocol and v.Team ~= MainPlayer.Team and gamereplication.getbodyparts(v) then
			local p = gamereplication.getbodyparts(v).head
			local pc = (lpp - p.CFrame.Position).magnitude
			if pc < c then
				t = p
				c = pc
				tp = v
			end
		end
	end
	return t, tp
end

-- this sucks, next time make an individual get entity for each thing instead of making it one method, its more efficient this way
-- wait for rewrite fuck you :)


function getBestPlayer(atype, r3d, static)
	local players = {}
	local closest = math.huge
	if atype == "rage" and sliders["rage.aimbot.fov"][1] ~= 0 then
		closest = sliders["rage.aimbot.fov"][1]
	elseif atype == "legit" then
		closest = sliders["legit.aimbot.fov"][1]
	elseif atype == "trigger" then
		closest = sliders["legit.trigger.magnet.fov"][1]
	end
	local targetpart
	local targetplayer
	local targetpos = Vector2new
	local target3pos = Vector3new
	local targettraj = Vector3new
	local idealpart = "Closest"
	local Cam = workspace.CurrentCamera
	local m = MainPlayer:GetMouse()
	
	function getBestofType(hbtype)
		for i = 1, 2 do
			local playersUsed
			if i == 1 then
				playersUsed = priorityplyrs
			elseif targetpos == Vector2new then
				playersUsed = Players:GetPlayers()
			end 
			if playersUsed then
				for k, v in pairs(playersUsed) do
					local friendyguy = false
					for f0, f1 in pairs(friendplyrs) do
						if v == f1 then
							friendyguy = true
							break
						end
					end
					if v and gamehud:isplayeralive(v) and gamereplication.getbodyparts(v) and v.Team ~= MainPlayer.Team and not friendyguy then 
						for k1, v1 in pairs(gamereplication.getbodyparts(v)) do
							if v1.ClassName == "Part" and v1.Name ~= "HumanoidRootPart" and v1.Name ~= "Right Arm" and v1.Name ~= "Left Arm" and (v1.Name == hbtype or hbtype == "Closest") then
								
								local pos, vis = Cam:WorldToScreenPoint(v1.Position)
								
								local dist = Vector3.new(pos.X - mouse.X, pos.Y - mouse.Y, 0).magnitude
								if vis and dist < closest then
									local Part, partPos
									if atype ~= "nade" or atype == "friend" then
										Part, partPos = workspace:FindPartOnRayWithIgnoreList(Ray.new(gamecam.cframe.p, v1.Position - gamecam.cframe.p), {workspace.Camera--[[, workspace.Players[MainPlayer.Team.Name] ]]})
									end
									if Part == v1 or Part == nil then
										if toggles["legit.aimbot.traj"][1] then
											if gamelogic.currentgun and rawget(gamelogic.currentgun, "data") and rawget(gamelogic.currentgun.data, "bulletspeed") then
												targettraj = Cam.CFrame.Position + gametraj(Cam.CFrame.Position, Vector3new, Vector3.new(0,-192.6, 0), v1.Position, Vector3new, Vector3new, gamelogic.currentgun.data.bulletspeed)
												targetpos = Cam:WorldToScreenPoint(targettraj)
											else
												targetpos = Cam:WorldToScreenPoint(v1.Position)
											end
										else
											targetpos = Cam:WorldToScreenPoint(v1.Position)
										end
										
										if atype == "legit" or atype == "trigger" and toggles["legit.rcs.gun.enabled"][1] and Input:IsMouseButtonPressed(1) then
											local sightmark = Cam:FindFirstChild("SightMark", true)
											if sightmark then
												local centre = (Vector3.new(m.ViewSizeX,m.ViewSizeY,0)/2)
												local recoilcomp = Cam:WorldToScreenPoint(sightmark.CFrame.Position) - centre
												if (recoilcomp - centre).magnitude < 50 then
													targetpos = targetpos + recoilcomp
												end
											end
										end
										
										local rm = sliders["legit.aimbot.random"][1]/10
										if atype == "rage" then
											rm = 0
										end
										local rv = Vector2.new(math.random(-10,10),math.random(-10,10))
										
										targetpos = Vector2.new(targetpos.X + rv.X * rm, targetpos.Y + rv.Y * rm)
										
										closest = dist
										
										target3pos = v1.Position
										
										targetpart = v1
										
										targetplayer = v
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	getBestofType(idealpart)
	
	if targetpos == Vector2new and not static then
		getBestofType("Closest")
	end
	-- if atype == "friend" then
	-- 	return targetplayer
	-- else
	sexTarget = targetplayer
	-- end
	if r3d then
		return target3pos
	else
		return Vector2.new(targetpos.X, targetpos.Y + 36), targetpart
	end
end



function get_best_rage_player()
	local closest = sliders["rage.aimbot.fov"][1]
	local shouldCheckForFov = closest ~= 0
	
	if not gamelogic and not gamelogic.currentgun.data then
		return
	end
	
	local target, hitbox, angles
	function getPlayerInTable(playaz, Thingz)
		for k, v in pairs(playaz) do
			local activate_glizzy_awareness_protocol = true
			for k1, v1 in pairs(friendplyrs) do 
				if v == v1 then
					activate_glizzy_awareness_protocol = false
					break
				end
			end
			if activate_glizzy_awareness_protocol and gamehud:isplayeralive(v) and v.Team ~= MainPlayer.Team and gamereplication.getbodyparts(v) then
				local BodyParts = gamereplication.getbodyparts(v)
				
				for k1, v1 in pairs(BodyParts) do
					if (v1.Name == Thingz or Thingz == "all") and v1.ClassName == "Part" and v1.Name ~= "HumanoidRootPart" and v1.Name ~= "Right Arm" and v1.Name ~= "Left Arm"  then
						-- we dont need to calculate this if we want unlimited fov
						local dist = -1
						if closest ~= 0 then
							local pos, vis = Camera:WorldToScreenPoint(v1.Position)
							dist = Vector3.new(pos.X - mouse.X, pos.Y - mouse.Y, 0).magnitude
						end
						
						if dist < closest or not shouldCheckForFov then
							local CalculatedAngle = CFrame.new(gamecam.cframe.p, v1.Position).LookVector
							

							local Ignore = ignoreList
							--table.insert(Ignore, workspace.Players[MainPlayer.Team.Name])
							--table.insert(Ignore, workspace.Camera)
							--table.insert(Ignore, MainPlayer)
							Ignore["mp"] = MainPlayer
							Ignore["mc"] = workspace.Camera
							--Ignore["mf"] = workspace.Players[MainPlayer.Team.Name]

							local rayPart, rayPos = workspace:FindPartOnRayWithIgnoreList(Ray.new(gamecam.cframe.p, v1.Position - gamecam.cframe.p), Ignore)

							-- local rayParts = workspace.Camera:GetPartsObscuringTarget({v1.Position}, {workspace.Camera})
							-- local wallz = 0
							-- for k2, v2 in pairs(rayParts) do
							-- 	if v2.Transparency == 0 then
							-- 		wallz += 1
							-- 	end
							-- end
							-- print(wallz)

							if not toggles["rage.aimbot.raytrace"][1] and rayPart == v1 then
								closest = dist
								target = v
								hitbox = v1
								angles = CalculatedAngle
							else
								if gamelogic.currentgun and gamelogic.currentgun.data and gamelogic.currentgun.data.bulletspeed then
									-- lets autowall calc
									if CanPenetrate(MainPlayer, v, gamecam.cframe.p + gametraj(gamecam.cframe.p, Vector3new, Vector3.new(0,-192.6, 0), v1.Position, Vector3new, Vector3new, gamelogic.currentgun.data.bulletspeed)) then
										closest = dist
										target = v
										hitbox = v1
										angles = CalculatedAngle
									end
								end
							end
						end
					end
				end
			end
		end
	end
	local dir = dropboxes["rage.aimbot.priority.part"][2]
	local partz = "all"
	if dir == 1 then
		partz = "Head"
	else
		partz = "Torso"
	end
	getPlayerInTable(priorityplyrs, partz)
	if target == nil and not toggles["rage.aimbot.static"][1] then
		getPlayerInTable(priorityplyrs, "all")
	end
	if target == nil and not toggles["config.extra.ragepriority"][1] then
		getPlayerInTable(Players:GetPlayers(), partz)
		if target == nil and not toggles["rage.aimbot.static"][1] then
			getPlayerInTable(Players:GetPlayers(), "all")
		end
	end	
	return target, hitbox, angles
end
	
local v9 = Instance.new("Part") 
v9.Anchored = true 
v9.Transparency = 1 
v9.CanCollide = false 
v9.CastShadow = false 
v9.Size = Vector3new 
v9.CFrame = CFrame.new() 
v9.Parent = workspace 

local disableTargetEsp = game.RunService.RenderStepped:Connect(function()
	local lbot = false
	if toggles["legit.aimbot.enabled"][1] then
		if (dropboxes["legit.aimbot.keybind"][2] == 2 and Input:IsMouseButtonPressed(1)) or (dropboxes["legit.aimbot.keybind"][2] == 3 and Input:IsMouseButtonPressed(0)) or dropboxes["legit.aimbot.keybind"][2] == 1 or dropboxes["legit.aimbot.keybind"][2] == 4 then
			lbot = true
		end
	end
	if not ( toggles["legit.trigger.enabled"][1] and Input.MouseBehavior ~= Enum.MouseBehavior.Default and keybinds["legit.trigger.key"][9] and Input:IsKeyDown(keybinds["legit.trigger.key"][9]))
	and not lbot then
		sexTarget = nil
	end
end)


local trigger_bot = game.RunService.RenderStepped:Connect(function()
	if toggles["legit.trigger.enabled"][1] and keybinds["legit.trigger.key"][9] and Input:IsKeyDown(keybinds["legit.trigger.key"][9]) then
		
		local mouse = Input:GetMouseLocation()
		spawn(function()
			if Input.MouseBehavior ~= Enum.MouseBehavior.Default then
				local target, part = getBestPlayer("trigger", false, false)
				
				if target.X ~= 0 then
					local smoothing = sliders["legit.trigger.magnet.smooth"][1] + 2
					local inc = Vector2.new(target.X - mouse.X, target.Y - mouse.Y)
					if sliders["legit.trigger.magnet.smooth"][1] ~= 0 then
						mousemoverel(inc.X / smoothing / gameSettings.MouseSensitivity, inc.Y / smoothing / gameSettings.MouseSensitivity)	
					end
					local Flame = Cam:FindFirstChild("Flame", true).CFrame.LookVector
					if Flame:Dot(Cam.CFrame.LookVector) > 0.9998 then
						local ray = Ray.new(Cam.CFrame.Position, Cam.CFrame.lookVector * 5000)
						if  workspace:FindPartOnRay(ray, Cam).Parent.Name == part.Parent.Name then
							gamelogic.currentgun:shoot(true)
							triggerbotShootin = true
						end
					end
				elseif gamelogic.currentgun and triggerbotShootin then
					gamelogic.currentgun:shoot(false)
					triggerbotShootin = false
				end
			end
		end)
	end
end)

local legitbotz = game.RunService.RenderStepped:Connect(function()
	
	local aimtype = 0
	if (dropboxes["legit.aimbot.keybind"][2] == 2 and Input:IsMouseButtonPressed(1)) or (dropboxes["legit.aimbot.keybind"][2] == 3 and Input:IsMouseButtonPressed(0)) or dropboxes["legit.aimbot.keybind"][2] == 1 then
		aimtype = 1
	else
		aimtype = 0
	end
	if dropboxes["legit.aimbot.keybind"][2] == 4 then
		aimtype = 0.2
		if Input:IsMouseButtonPressed(0) then
			aimtype = aimtype + 0.4
		end
		if Input:IsMouseButtonPressed(1) then
			aimtype = aimtype + 0.4
		end
	end
	
	if toggles["legit.aimbot.enabled"][1] and aimtype > 0 then
		local mouse = Input:GetMouseLocation()
		local Cam = workspace.CurrentCamera
		spawn(function()
			if Input.MouseBehavior ~= Enum.MouseBehavior.Default then
				local target = getBestPlayer("legit", false, toggles["legit.aimbot.static"][1])
				
				if target.X ~= 0 then
					local smoothing = sliders["legit.aimbot.smooth"][1] + 2
					local inc = Vector2.new(target.X - mouse.X, target.Y - mouse.Y)
					if inc.magnitude >= 0 then
						mousemoverel(inc.X / smoothing * aimtype / gameSettings.MouseSensitivity, inc.Y/ smoothing * aimtype / gameSettings.MouseSensitivity)
					end
					--🔥🔥🔥🔥🔥
				end
				--🔥🔥🔥🔥🔥
			end
			--🔥🔥🔥🔥🔥
		end)
		--🔥🔥🔥🔥🔥
	end
	--🔥🔥🔥🔥🔥
end)

local inputend = Input.InputEnded:Connect(function(key)
	if keybinds["rage.aimbot.enabled"][9]  and key.KeyCode == keybinds["rage.aimbot.enabled"][9] then
		if not Input:IsMouseButtonPressed(0) then
			gamelogic.currentgun:shoot(false)
		end
	end
	if keybinds["misc.other.jumppower"][9]  and key.KeyCode == keybinds["misc.other.jumppower"][9] then
		local localply = nil
		local players = workspace.Players.Ghosts:GetChildren()
		table.move(workspace.Players.Phantoms:GetChildren(), 1, #workspace.Players.Phantoms:GetChildren(), #players + 1, players)
		for k, v in pairs(players) do
			if v:FindFirstChild("Humanoid") then
				localply = v
				break
			end
		end
		if localply then
			localply:FindFirstChild("Humanoid").JumpPower = 40
		end
	end
	if toggles["misc.movement.tppeek"][1] and keybinds["misc.movement.tppeek"][9]  and key.KeyCode == keybinds["misc.movement.tppeek"][9] and toggles["misc.movement.tppeek"][1] and not menuopen and MainPlayer.Character and MainPlayer.Character.Humanoid and not chatBox.Active then
		rp = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
		oldPos = rp.Position
		local pa = RaycastParams.new()
		pa.FilterType = Enum.RaycastFilterType.Blacklist
		pa.FilterDescendantsInstances = {workspace.Camera,workspace.Players,workspace.Ignore}
		local result = workspace:Raycast(rp.Position,Vector3.new(0,-100,0),pa)
		if result then
			rp.Position = result.Position + Vector3.new(0,2,0)
		else
			rp.Position -= Vector3.new(0,100,0)
		end
	end
end)

newpart = gameparticle.new
gameparticle.new = function(P)
	if ragebotShootin and not P.thirdperson then
		local mag = P.velocity.Magnitude
		P.velocity = rageAngles * mag
	end
	newpart(P)
end

do
	local dot = Vector3.new().Dot
	local ignore
	local lifetime
	local velocity
	local acceleration
	local position
	local penetrationDepth
	local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
	local FindPartOnRayWithWhitelist = workspace.FindPartOnRayWithWhitelist

	local function BulletStep(deltaTime, curTick, targetParts)
		if lifetime and lifetime < curTick then
			return 1
		end
		local direction = deltaTime * velocity + deltaTime * deltaTime / 2 * acceleration
		local hitPartInstance, hitPartPos = FindPartOnRayWithIgnoreList(workspace, Ray.new(position, direction), ignore, true, true)
		if hitPartInstance then
			if targetParts[hitPartInstance] then return 0 end

			local partSize = hitPartInstance.Size.magnitude * direction.unit
			local hasPenetration = not hitPartInstance.CanCollide or hitPartInstance.Transparency == 1
			if hitPartInstance.Name == "killbullet" then
				return 2
			end
			if not hasPenetration then
				local _, otherSideOfPart = FindPartOnRayWithWhitelist(workspace, Ray.new(hitPartPos + partSize, -partSize), {hitPartInstance}, true)
				local penetrationAmount = dot(direction.unit, otherSideOfPart - hitPartPos)
				if penetrationAmount < penetrationDepth then
					penetrationDepth = penetrationDepth - penetrationAmount
				else
					return 3
				end
			end
			position = hitPartPos + 0.01 * direction.unit
			velocity = velocity + dot(direction, hitPartPos - position) / dot(direction, direction) * deltaTime * acceleration
			ignore[#ignore + 1] = hitPartInstance
		else
			position = position + direction
			velocity = velocity + deltaTime * acceleration
		end
	end

	local step = 1 / sliders["rage.aimbot.step"][1] 
	local maxSteps = 1000

	local function GetPartTable(ply)
		local tbl = {}
		for k, v in pairs(gamereplication.getbodyparts(ply)) do
			tbl[v] = true
		end
		return tbl
	end

	CanPenetrate = function(ply, target, targetPos)
		local targetParts = GetPartTable(target)
		local origin = gamecam.cframe.p

		ignore = {workspace.Terrain, workspace.Ignore, workspace.CurrentCamera, workspace.Players[ply.Team.Name]}
		lifetime = 1.5
		velocity = (targetPos - origin).Unit * gamelogic.currentgun.data.bulletspeed
		acceleration = vec3Gravity
		position = origin
		penetrationDepth = gamelogic.currentgun.data.penetrationdepth

		for i = 1, maxSteps do
			local ret = BulletStep(step, i * step, targetParts)

			if ret == 0 then
				return true
			elseif ret ~= nil then
				return false
			end
		end
	end
end
------------------------------------------------------------------------------DRAW HOOK AIM NOT XDD 😅😅😅😂😂😂🤣🤣🤣
local aimbotz = game.RunService.RenderStepped:Connect(function()--ragebot
	if toggles["rage.aimbot.enabled"][1] and Input.MouseBehavior ~= Enum.MouseBehavior.Default then
		local mouse = Input:GetMouseLocation()
		local Cam = workspace.CurrentCamera
		spawn(function()
			if keybinds["rage.aimbot.enabled"][9] == nil or (keybinds["rage.aimbot.enabled"][9]  and Input:IsKeyDown(keybinds["rage.aimbot.enabled"][9])) then
				local target, hitbox, angles = get_best_rage_player()
				if target then
					rageTarget = target
					sexTarget = target
					rageHitbox = hitbox
					rageAngles = angles
					
					-- recode this later 🔥🔥🔥🔥🔥
					
					if toggles["rage.aimbot.autofire"][1] and (toggles["rage.aimbot.silent"][1] or inc.magnitude < 15 ) then
						if gamelogic.currentgun and gamelogic.currentgun.type ~= "KNIFE" then
							gamelogic.currentgun:shoot(true)
							ragebotShootin = true
						end
					end
					if toggles["rage.aimbot.autoscope"][1] then
						if gamelogic.currentgun and gamelogic.currentgun.type ~= "KNIFE" then
							gamelogic.currentgun:setaim(true)
						end
					end
				else
					if toggles["rage.aimbot.autoscope"][1] then
						if gamelogic.currentgun and gamelogic.currentgun.isaiming() then
							gamelogic.currentgun:setaim(false)
						end
					end
					if toggles["rage.aimbot.autofire"][1] and ragebotShootin then
						if gamelogic.currentgun and gamelogic.currentgun.type ~= "KNIFE" then
							gamelogic.currentgun:shoot(false)
							ragebotShootin = false
						end
					end
				end
			end
		end)
	end
end)

local function Lerp(delta, from, to)
	if (delta > 1) then 
		return to
	end
	if (delta < 0) then 
		return from 
	end
	return from + ( to - from ) * delta
end

local function ColorRange(value, ranges, div) -- ty tony for dis function u a homie
	div = div or 1
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
	
	return Color3.new(
		Lerp(lerpValue, minColor.color.r, maxColor.color.r)/div, 
		Lerp(lerpValue, minColor.color.g, maxColor.color.g)/div,
		Lerp(lerpValue, minColor.color.b, maxColor.color.b)/div
	)
end

--"esp.team.hpmin"

local statuses = {friendplyrs, priorityplyrs}
-- functionz 4 da $$esp$$
local playeresp = game.RunService.RenderStepped:Connect(function()
	if toggles["esp.world.forcetime"][1] then 
		game.Lighting:SetMinutesAfterMidnight(sliders["esp.world.forcetimenum"][1])
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
	local enemy_t = {}
	local team_t = {}
	for Index, Player in pairs(Players:GetPlayers()) do
		local Body = gamereplication.getbodyparts(Player)
		if Body and typeof(Body) == 'table' and rawget(Body, 'rootpart') then
			Player.Character = Body.rootpart.Parent
			if not table_contains(priorityplyrs, Player) or not table_contains(friendplyrs, Player) or Player ~= sexTarget then
				if Player.Team ~= localteam then
					table.insert(enemy_t, Player)
				else
					table.insert(team_t, Player)
				end
			end
		end
	end
	
	for k, v in pairs(statuses) do
		for k1, v1 in pairs(v) do
			if v1.Team ~= localteam then
				table.insert(enemy_t, v1)
			else
				table.insert(team_t, v1)
			end
		end
	end
	
	local playerz = {}
	for k, v in pairs(team_t) do
		table.insert(playerz, v)
	end
	for k, v in pairs(enemy_t) do
		table.insert(playerz, v)
	end
	if sexTarget  then
		table.insert(playerz, sexTarget)
	end
	
	for k, v in pairs(allvisualshit) do
		for k1, v1 in pairs(v) do
			if v1.Visible == true then
				v1.Visible = false
			end
		end
	end
	
	local playernum = 0
	if localply then
		playernum = 0
		for k, v in pairs(playerz) do -------------------------------------------------------------- enemy
			if gamehud:isplayeralive(v) then
				playernum = playernum + 1
				local pns = tostring(playernum)

				local txtthingy = "enemy"
				if v.Team == localteam then
					txtthingy = "team"
				end

				local ply_pos = v.Character.Torso.Position
				local top, top_isrendered = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(ply_pos.x, ply_pos.y + 2.5, ply_pos.z))
				local bottom, bottom_isrendered = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(ply_pos.x, ply_pos.y - 2.9, ply_pos.z))
				local box_width = (bottom.y - top.y) / 2
				
				if top_isrendered or bottom_isrendered then
					if toggles["esp."..txtthingy..".name"][1] then
						local name = tostring(v.Name)
						
						if dropboxes["esp.settings.case"][2] == 1 then
							name = string.lower(name)
						elseif dropboxes["esp.settings.case"][2] == 3 then
							name = string.upper(name)
						end
						enemy_name_text[pns].Text = name
						enemy_name_text[pns].Position = Vector2.new(math.floor(bottom.x), math.floor(top.y + 22))
						enemy_name_text[pns].Visible = true
						if toggles["esp.settings.dynoutline"][1] then
							enemy_name_text[pns].OutlineColor = Color3.fromRGB(colorpickers["esp."..txtthingy..".name"][6]/5, colorpickers["esp."..txtthingy..".name"][7]/5, colorpickers["esp."..txtthingy..".name"][8]/5)
						else
							enemy_name_text[pns].OutlineColor = Color3.new(0,0,0)
						end
						
						enemy_name_text[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".name"][6], colorpickers["esp."..txtthingy..".name"][7], colorpickers["esp."..txtthingy..".name"][8])
						enemy_name_text[pns].Transparency = colorpickers["esp."..txtthingy..".name"][9]/255
					end
					if toggles["esp."..txtthingy..".box"][1] then
						enemybox[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2), math.floor(top.y + 36))
						enemybox[pns].Size = Vector2.new(math.floor(box_width), math.floor(bottom.y - top.y))
						enemybox[pns].Visible = true
						
						enemy_outer_outline[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2 - 1), math.floor(top.y + 35))
						enemy_outer_outline[pns].Size = Vector2.new(math.floor(box_width + 2), math.floor(bottom.y - top.y + 2))
						enemy_outer_outline[pns].Visible = true
						
						enemy_inner_outline[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2 + 1), math.floor(top.y + 37))
						enemy_inner_outline[pns].Size = Vector2.new(math.floor(box_width - 2), math.floor(bottom.y - top.y - 2))
						enemy_inner_outline[pns].Visible = true
						
						enemybox[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".box"][6], colorpickers["esp."..txtthingy..".box"][7], colorpickers["esp."..txtthingy..".box"][8])
						enemybox[pns].Transparency = colorpickers["esp."..txtthingy..".box"][9]/255
						if toggles["esp.settings.dynoutline"][1] then
							enemy_outer_outline[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".box"][6]/5, colorpickers["esp."..txtthingy..".box"][7]/5, colorpickers["esp."..txtthingy..".box"][8]/5)
							enemy_outer_outline[pns].Transparency = colorpickers["esp."..txtthingy..".box"][9]/255
							enemy_inner_outline[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".box"][6]/5, colorpickers["esp."..txtthingy..".box"][7]/5, colorpickers["esp."..txtthingy..".box"][8]/5)
							enemy_inner_outline[pns].Transparency = colorpickers["esp."..txtthingy..".box"][9]/255
						end
					end
					if toggles["esp."..txtthingy..".healthbar"][1] then
						local health = gamehud:getplayerhealth(v)
						enemy_health_outer[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2) - 6, math.floor(top.y + 35))
						enemy_health_outer[pns].Size = Vector2.new(4, math.floor(bottom.y - top.y) + 2)

						enemy_health_outer[pns].Visible = true
						
						enemy_health_back[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2) - 5, math.floor(top.y + 36))
						enemy_health_back[pns].Size = Vector2.new(2, math.floor(bottom.y - top.y))
						enemy_health_back[pns].Visible = true
						
						local hprange = {
							[1] = {start = 0, color = Color3.fromRGB(colorpickers["esp."..txtthingy..".hpmin"][6], colorpickers["esp."..txtthingy..".hpmin"][7], colorpickers["esp."..txtthingy..".hpmin"][8])},
							[2] = {start = 100, color = Color3.fromRGB(colorpickers["esp."..txtthingy..".hpmax"][6], colorpickers["esp."..txtthingy..".hpmax"][7], colorpickers["esp."..txtthingy..".hpmax"][8])}
						}
						
						enemy_health_inner[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2) - 5, math.floor(top.y + 36) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)))
						enemy_health_inner[pns].Size = Vector2.new(2, math.floor((bottom.y - top.y)*(health/100)))
						enemy_health_inner[pns].Color = ColorRange(health, hprange)
						enemy_health_inner[pns].Transparency = 1
						enemy_health_inner[pns].Visible = true

						if toggles["esp.settings.dynoutline"][1] then
							enemy_health_outer[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".hpmin"][6]*0.2, colorpickers["esp."..txtthingy..".hpmin"][7]*0.2, colorpickers["esp."..txtthingy..".hpmin"][8]*0.2)
						else
							enemy_health_outer[pns].Color = Color3.new(0,0,0)
						end
						
						if math.ceil(health) ~= 100 then 
							if toggles["esp.settings.dynoutline"][1] then
								enemy_health_outer[pns].Color = ColorRange(health, hprange, 5)
							end
							enemy_health_text[pns].Text = tostring(math.ceil(health))
							enemy_health_text[pns].Position = Vector2.new(math.floor(bottom.x - box_width / 2) - 4, math.floor(top.y + 36) + ((bottom.y - top.y) - (bottom.y - top.y)*(health/100)) - 8)
							enemy_health_text[pns].Visible = true
						end
					end
					local textpos = 0
					if toggles["esp."..txtthingy..".weapon"][1] then
						local wea_name = "Knife"
						local number = 0
						for k1, v1 in pairs(v.Character:GetChildren()) do
							number = number + 1
							if number == 8 then
								if v1.Name == nil then
									wea_name = "Knife"
								else
									wea_name = tostring(v1.Name)
								end
							end
						end
						if dropboxes["esp.settings.case"][2] == 1 then
							wea_name = string.lower(wea_name)
						elseif dropboxes["esp.settings.case"][2] == 3 then
							wea_name = string.upper(wea_name)
						end
						enemy_wep_text[pns].Text = wea_name
						enemy_wep_text[pns].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y + 36))
						enemy_wep_text[pns].Visible = true
						textpos = textpos + 12
						
						enemy_wep_text[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".weapon"][6], colorpickers["esp."..txtthingy..".weapon"][7], colorpickers["esp."..txtthingy..".weapon"][8])
						enemy_wep_text[pns].Transparency = colorpickers["esp."..txtthingy..".weapon"][9]/255
					end
					if toggles["esp."..txtthingy..".distance"][1] then
						local distance = math.ceil(bottom.z / 5)
						enemy_dist_text[pns].Text = tostring(distance.. "m")
						enemy_dist_text[pns].Position = Vector2.new(math.floor(bottom.x), math.floor(bottom.y + 36 + textpos))
						enemy_dist_text[pns].Visible = true
						
						enemy_dist_text[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".distance"][6], colorpickers["esp."..txtthingy..".distance"][7], colorpickers["esp."..txtthingy..".distance"][8])
						enemy_dist_text[pns].Transparency = colorpickers["esp."..txtthingy..".distance"][9]/255
					end
					if toggles["esp."..txtthingy..".skeleton"][1] then
						local head_pos = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Character.Head.Position.x, v.Character.Head.Position.y, v.Character.Head.Position.z))
						local torso_pos = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Character.Torso.Position.x, v.Character.Torso.Position.y, v.Character.Torso.Position.z))
						local right_arm_pos = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Character:FindFirstChild("Right Arm").Position.x, v.Character:FindFirstChild("Right Arm").Position.y, v.Character:FindFirstChild("Right Arm").Position.z))
						local left_arm_pos = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Character:FindFirstChild("Left Arm").Position.x, v.Character:FindFirstChild("Left Arm").Position.y, v.Character:FindFirstChild("Left Arm").Position.z))
						local right_leg_pos = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Character:FindFirstChild("Right Leg").Position.x, v.Character:FindFirstChild("Right Leg").Position.y, v.Character:FindFirstChild("Right Leg").Position.z))
						local left_leg_pos = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Character:FindFirstChild("Left Leg").Position.x, v.Character:FindFirstChild("Left Leg").Position.y, v.Character:FindFirstChild("Left Leg").Position.z))
						
						enemy_skel_head[pns].From = Vector2.new(head_pos.x, head_pos.y + 36)
						enemy_skel_right_arm[pns].From = Vector2.new(right_arm_pos.x, right_arm_pos.y + 36)
						enemy_skel_left_arm[pns].From = Vector2.new(left_arm_pos.x, left_arm_pos.y + 36)
						enemy_skel_right_leg[pns].From = Vector2.new(right_leg_pos.x, right_leg_pos.y + 36)
						enemy_skel_left_leg[pns].From = Vector2.new(left_leg_pos.x, left_leg_pos.y + 36)
						
						for k, v in pairs(enemy_skeleton) do
							v[pns].To = Vector2.new(torso_pos.x, torso_pos.y + 36)
							v[pns].Visible = true
							v[pns].Color = Color3.fromRGB(colorpickers["esp."..txtthingy..".skeleton"][6], colorpickers["esp."..txtthingy..".skeleton"][7], colorpickers["esp."..txtthingy..".skeleton"][8]) 
							v[pns].Transparency = colorpickers["esp."..txtthingy..".skeleton"][9]/255
						end
					end
					
					local customstatus = false
					local customcolor = {
						r = 255,
						g = 255,
						b = 255,
						a = 255
					}
					if v == sexTarget and toggles["esp.settings.showtarget"][1] then
						customstatus = true
						customcolor = {
							r = colorpickers["esp.settings.showtarget"][6],
							g = colorpickers["esp.settings.showtarget"][7],
							b = colorpickers["esp.settings.showtarget"][8],
							a = colorpickers["esp.settings.showtarget"][9]
						}
					elseif table_contains(priorityplyrs, v) and toggles["esp.settings.showproirity"][1] then
						customstatus = true
						customcolor = {
							r = colorpickers["esp.settings.showproirity"][6],
							g = colorpickers["esp.settings.showproirity"][7],
							b = colorpickers["esp.settings.showproirity"][8],
							a = colorpickers["esp.settings.showproirity"][9]
						}
					elseif table_contains(friendplyrs, v) and toggles["esp.settings.showfriends"][1] then
						customstatus = true
						customcolor = {
							r = colorpickers["esp.settings.showfriends"][6],
							g = colorpickers["esp.settings.showfriends"][7],
							b = colorpickers["esp.settings.showfriends"][8],
							a = colorpickers["esp.settings.showfriends"][9]
						}
					end
					
					if customstatus then
						enemy_name_text[pns].Color = Color3.fromRGB(customcolor.r, customcolor.g, customcolor.b)
						enemy_name_text[pns].Transparency = customcolor.a/255
						enemy_name_text[pns].OutlineColor = Color3.fromRGB(0, 0, 0)
						
						enemybox[pns].Color = Color3.fromRGB(customcolor.r, customcolor.g, customcolor.b)
						enemybox[pns].Transparency = customcolor.a/255
						
						enemy_inner_outline[pns].Color = Color3.fromRGB(0, 0, 0)
						enemy_inner_outline[pns].Transparency = 220/255
						enemy_outer_outline[pns].Color = Color3.fromRGB(0, 0, 0)
						enemy_outer_outline[pns].Transparency = 220/255
						
						
						enemy_wep_text[pns].Color = Color3.fromRGB(customcolor.r, customcolor.g, customcolor.b)
						enemy_wep_text[pns].Transparency = customcolor.a/255
						enemy_wep_text[pns].OutlineColor = Color3.fromRGB(0, 0, 0)
						
						enemy_dist_text[pns].Color = Color3.fromRGB(customcolor.r, customcolor.g, customcolor.b)
						enemy_dist_text[pns].Transparency = customcolor.a/255
						enemy_dist_text[pns].OutlineColor = Color3.fromRGB(0, 0, 0)
						
						for k, v in pairs(enemy_skeleton) do
							v[pns].Color = Color3.fromRGB(customcolor.r, customcolor.g, customcolor.b)
							v[pns].Transparency = customcolor.a/255
						end
					end
				end
			end
		end
		local gunz = {}
		for k, v in pairs(workspace.Ignore.GunDrop:GetChildren()) do
			if tostring(v) == "Dropped" then
				table.insert(gunz, v)
			end 
		end
		
		if toggles["esp.weapon.nadeesp"][1] then
			for k, v in pairs(workspace.Ignore.Misc:GetChildren()) do
				if tostring(v) == "Trigger" and not v:FindFirstChild("part") then
					local clr = Color3.fromRGB(colorpickers["esp.weapon.nadeesp"][6], colorpickers["esp.weapon.nadeesp"][7], colorpickers["esp.weapon.nadeesp"][8])
					local tp = 1+(colorpickers["esp.weapon.nadeesp"][9]/-255)
					local party = Instance.new("Part", v)
					party.Name = "part"
					party.CFrame = CFrame.new(v.Position)
					party.CanCollide = false
					ignoreList[party] = party
					local weldy = Instance.new("WeldConstraint", workspace)
					weldy.Part0 = v
					weldy.Part1 = party
					party.Shape = Enum.PartType.Ball
					party.Size = Vector3.new(44,44,44)
					party.Material = "ForceField"
					party.Transparency = tp
					party.Color = clr
				end 
			end 
		end
		gunnum = 0
		for k, v in pairs(gunz) do
			if (toggles["esp.weapon.name"][1] or toggles["esp.weapon.ammo"][1]) and v:FindFirstChild("Slot1") then
				local gunpos, gun_on_screen = workspace.CurrentCamera:WorldToScreenPoint(Vector3.new(v.Slot1.Position.x, v.Slot1.Position.y, v.Slot1.Position.z))
				local hasgun = false
				for k1, v1 in pairs(v:GetChildren()) do 
					if tostring(v1) == "Gun" then
						hasgun = true
						break
					end
				end 
				if gun_on_screen and gunpos.z <= 80 and gunnum <= 60 and hasgun then
					gunnum = gunnum + 1
					local gunclearness = 1
					if gunpos.z >= 50 then
						local closedist = gunpos.z - 50
						gunclearness = 1 - (1 * closedist/30)
					end
					local strGunNum = tostring(gunnum)
					if toggles["esp.weapon.name"][1] then
						local gunname = v.Gun.Value
						if dropboxes["esp.settings.case"][2] == 1 then
							gunname = string.lower(v.Gun.Value)
						elseif dropboxes["esp.settings.case"][2] == 3 then
							gunname = string.upper(v.Gun.Value)
						end
						
						dropped_wep[strGunNum].Text = gunname
						dropped_wep[strGunNum].Color = Color3.fromRGB(colorpickers["esp.weapon.name"][6], colorpickers["esp.weapon.name"][7], colorpickers["esp.weapon.name"][8])
						dropped_wep[strGunNum].Transparency = colorpickers["esp.weapon.name"][9] * gunclearness /255 
						dropped_wep[strGunNum].Visible = true
						dropped_wep[strGunNum].Position = Vector2.new(math.floor(gunpos.x), math.floor(gunpos.y + 25))
					end
					if toggles["esp.weapon.ammo"][1] then
						dropped_wep_ammo[strGunNum].Text = "[ "..tostring(v.Spare.Value).." ]"
						dropped_wep_ammo[strGunNum].Color = Color3.fromRGB(colorpickers["esp.weapon.ammo"][6], colorpickers["esp.weapon.ammo"][7], colorpickers["esp.weapon.ammo"][8])
						dropped_wep_ammo[strGunNum].Transparency = colorpickers["esp.weapon.ammo"][9] * gunclearness /255
						dropped_wep_ammo[strGunNum].Visible = true
						dropped_wep_ammo[strGunNum].Position = Vector2.new(math.floor(gunpos.x), math.floor(gunpos.y + 36))
					end
				end
			end
		end
	end
	if MainPlayer then
		local vm = workspace.Camera:GetChildren()
		if toggles["esp.vm.handchams"][1] then ---------------------------------------------view model shit
			for k, v in pairs(vm) do
				if v.Name == "Left Arm" or v.Name == "Right Arm" then
					for k1, v1 in pairs(v:GetChildren()) do
						v1.Color = Color3.fromRGB(colorpickers["esp.vm.handchams"][6], colorpickers["esp.vm.handchams"][7], colorpickers["esp.vm.handchams"][8])
						v1.Transparency = 1 + (colorpickers["esp.vm.handchams"][9]/-255)
						if v1.ClassName == "MeshPart" or v1.Name == "Sleeve" then
							v1.Name = "Sleeve"
							v1.Color = Color3.fromRGB(colorpickers["esp.vm.sleevechams"][6], colorpickers["esp.vm.sleevechams"][7], colorpickers["esp.vm.sleevechams"][8])
							v1.Transparency = 1 + (colorpickers["esp.vm.sleevechams"][9]/-255)
							v1.Material = "SmoothPlastic"
							for k2, v2 in pairs(v1:GetChildren()) do
								v2:Destroy()
							end
						end
					end
				end
			end
		end
		if toggles["esp.vm.wepcolor"][1] then
			for k, v in pairs(workspace.Ignore:GetChildren()) do
				if v.Name == "LaserDot" and v:FindFirstChild("BillboardGui") then
					local color = Color3.fromRGB(colorpickers["esp.vm.sightcolor"][6], colorpickers["esp.vm.sightcolor"][7], colorpickers["esp.vm.sightcolor"][8])
					local transparency = 1+(colorpickers["esp.vm.sightcolor"][9]/-255)
					v.BillboardGui.ImageLabel.ImageColor3 = color
					v.BillboardGui.ImageLabel.ImageTransparency = (transparency / 2) + 0.5
				end
			end
			for k, v in pairs(vm) do
				if v.Name ~= "Left Arm" and v.Name ~= "Right Arm" and v.Name ~= "FRAG" then
					for k1, v1 in pairs(v:GetChildren()) do
						if v1.Name == "SightMark" then
							if v1:FindFirstChild("SurfaceGui") then
								local color = Color3.fromRGB(colorpickers["esp.vm.sightcolor"][6], colorpickers["esp.vm.sightcolor"][7], colorpickers["esp.vm.sightcolor"][8])
								local transparency = 1+(colorpickers["esp.vm.sightcolor"][9]/-255)
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
						
						v1.Color = Color3.fromRGB(colorpickers["esp.vm.wepcolor"][6], colorpickers["esp.vm.wepcolor"][7], colorpickers["esp.vm.wepcolor"][8])
						
						if v1.Transparency ~= 1 then
							v1.Transparency = 0.99999+(colorpickers["esp.vm.wepcolor"][9]/-255) --- it works shut up + i don't wanna make a fucking table for this shit
						end
						
						if dropboxes["esp.vm.mat"][2] == 2 then -- plastic
							v1.Material = "SmoothPlastic"
						elseif dropboxes["esp.vm.mat"][2] == 3 then -- force field 
							v1.Material = "ForceField"
						elseif dropboxes["esp.vm.mat"][2] == 4 then -- neon
							v1.Material = "Neon"
						elseif dropboxes["esp.vm.mat"][2] == 5 then -- sand 
							v1.Material = "Foil"
						elseif dropboxes["esp.vm.mat"][2] == 6 then -- sand 
							v1.Material = "Ice"
						end
						
						if v1.Name == "LaserLight" then
							local color = Color3.fromRGB(colorpickers["esp.vm.sightcolor"][6], colorpickers["esp.vm.sightcolor"][7], colorpickers["esp.vm.sightcolor"][8])
							local transparency = 1+(colorpickers["esp.vm.sightcolor"][9]/-255)
							v1.Color = color
							v1.Transparency = (transparency / 2) + 0.5
							v1.Material = "ForceField"
						end
					end
				end
			end
		end
	end
	local deadbodies = workspace.Ignore.DeadBody:GetChildren()
	if toggles["esp.misc.ragdollchams"][1] then 
		for k, v in pairs(deadbodies) do
			for k1, v1 in pairs(v:GetChildren()) do 
				if v1.Name == "Torso" and v1:FindFirstChild("Pant") then
					v1.Pant:Destroy()
				end
				v1.Color = Color3.fromRGB(colorpickers["esp.misc.ragdollchams"][6], colorpickers["esp.misc.ragdollchams"][7], colorpickers["esp.misc.ragdollchams"][8])
				v1.Transparency = 1+(colorpickers["esp.misc.ragdollchams"][9]/-255)
				v1.Material = "ForceField"
				if v1:FindFirstChild("Mesh") then
					v1.Mesh:Destroy()
				end
			end
		end
	end
	if (localply  and toggles["esp.misc.fovcircle"][1]) or menuopen then
		local screen_w = mouse.ViewSizeX
		local screen_h = mouse.ViewSizeY + 72
		if toggles["legit.aimbot.enabled"][1] or toggles["rage.aimbot.enabled"][1] then 
			fovthingy["1"].Visible = true 
		else
			fovthingy["1"].Visible = false
		end
		-- if toggles["legit.trigger.enabled"][1] then
		-- 	magnetfov["1"].Visible = true
		-- 	magnetfov["1"].Position = Vector2.new(screen_w/2, screen_h/2)
		-- 	magnetfov["1"].Radius = sliders["legit.trigger.magnet.fov"][1]
		-- 	magnetfov["1"].Color = Color3.fromRGB(colorpickers["esp.misc.fovcircle"][6], colorpickers["esp.misc.fovcircle"][7], colorpickers["esp.misc.fovcircle"][8])
		-- end 
		-- tried to make triggerbot fov show but don't know how to do this shit ALAN DO IT FOR ME THANKS
		local fov = sliders["legit.aimbot.fov"][1]
		if toggles["rage.aimbot.enabled"][1] then
			fov = sliders["rage.aimbot.fov"][1] 
			if toggles["legit.aimbot.enabled"][1] then
				fov = sliders["legit.aimbot.fov"][1] 
			end
		end
		if menuopen then
			if tab == 1 then
				fov = sliders["legit.aimbot.fov"][1] 
			elseif tab == 2 then 
				fov = sliders["rage.aimbot.fov"][1]
			else
				fov = 0
			end
		end
		
		if fov == 0 then
			fovthingy["1"].Visible = false
		end
		
		fovthingy["1"].Position = Vector2.new(screen_w/2, screen_h/2)
		fovthingy["1"].Radius = fov
		fovthingy["1"].Color = Color3.fromRGB(colorpickers["esp.misc.fovcircle"][6], colorpickers["esp.misc.fovcircle"][7], colorpickers["esp.misc.fovcircle"][8])
		fovthingy["1"].Transparency = colorpickers["esp.misc.fovcircle"][9]/255	
	else
		fovthingy["1"].Visible = false
		--magnetfov["1"].Visible = false
	end
end)



local bulletTracers = {}
local function bulletTrace(args) -- this is ugly but it doesn't lag and rewrite so shut up
	if #bulletTracers > 10 then 
		for k = 0, #args[2].bullets do
			bulletTracers[1][1]:Destroy()
			table.remove(bulletTracers,1)
		end
	end
	for k, v in pairs(args[2].bullets) do
		local p = Instance.new("Part", workspace.Camera)
		local cpos = workspace.Camera:FindFirstChild("Flame",true).CFrame.Position
		p.CFrame = CFrame.new(cpos, cpos+v[1])
		p.Position = p.Position + p.CFrame.LookVector.Unit * 500
		p.Anchored = true
		p.CanCollide = false
		p.Size = Vector3.new(0.01,0.01,1000)
		p.Color = Color3.fromRGB(
		colorpickers["esp.misc.bullettracers"][6],
		colorpickers["esp.misc.bullettracers"][7],
		colorpickers["esp.misc.bullettracers"][8])
		p.Transparency = 1+(colorpickers["esp.misc.bullettracers"][9]/-255)
		p.Material = "ForceField"
		table.insert(bulletTracers,{p,1})
	end
end

local movemint = game.RunService.RenderStepped:Connect(function() -- AHAHAHH FUNNY MOVEMINT HAHAH h
	if not chatBox.Active then
		if toggles["rage.antiaim.blink"][1] and keybinds["rage.antiaim.blink"][9] and Input:IsKeyDown(keybinds["rage.antiaim.blink"][9]) then
			game:GetService("NetworkClient"):SetOutgoingKBPSLimit(1)
			BlinkText["36"].Visible = true
		elseif BlinkText["36"].Visible then
			game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
			BlinkText["36"].Visible = false
		end
		-- you can tell it's my code because it has semicolons xd 
		-- is there something wrong with not using semicolons??????????? FUCK YOU NATE also i made kinda a ducktape fix for ur laggy shit
		-- because of you alan, i don't even use semicolons anymore. FUCK YOU ALAN also i made kinda a ducktape fix for ur BUTTHOLE XDDDD
		
		local localply = nil
		local players = workspace.Players.Ghosts:GetChildren()
		table.move(workspace.Players.Phantoms:GetChildren(), 1, #workspace.Players.Phantoms:GetChildren(), #players + 1, players)
		for k, v in pairs(players) do
			if v:FindFirstChild("Humanoid") then
				localply = v
			end
		end
		
		if localply then
			if dropboxes["misc.movement.bhop"][2] ~= 1 and Input:IsKeyDown(Enum.KeyCode.Space) then
				MainPlayer.Character.Humanoid.Jump = true
			end
			if (keybinds["misc.other.jumppower"][9] == nil or Input:IsKeyDown(keybinds["misc.other.jumppower"][9])) and sliders["misc.other.jumppower"][1] ~= 0 then
				MainPlayer.Character.Humanoid.JumpPower = sliders["misc.other.jumppower"][1]
			end
		end
		
		if localply then
			spawn(function()
				local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart") -- root part of player for movement
				
				if toggles["misc.movement.speed"][1] and (keybinds["misc.movement.speedhack"][9] == nil or Input:IsKeyDown(keybinds["misc.movement.speedhack"][9])) then
					local speed = sliders["misc.movement.speed"][1]
					local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
					local travel = Vector3new
					local looking = workspace.CurrentCamera.CFrame.lookVector
					if Input:IsKeyDown(Enum.KeyCode.W) then
						travel = travel + looking
					end
					if Input:IsKeyDown(Enum.KeyCode.S) then
						travel = travel - looking
					end
					if Input:IsKeyDown(Enum.KeyCode.D) then
						travel = travel + Vector3.new(-looking.Z, 0, looking.X)
					end
					if Input:IsKeyDown(Enum.KeyCode.A) then
						travel = travel + Vector3.new(looking.Z, 0, -looking.X)
					end
					local travel2d = Vector2.new(travel.X, travel.Z)
					if travel.Unit.X == travel.Unit.X then
						if dropboxes["misc.movement.bhop"][2] == 3 and Input:IsKeyDown(Enum.KeyCode.Space) then
							rootpart.Velocity = Vector3.new(travel2d.Unit.X * speed, rootpart.Velocity.Y, travel2d.Unit.Y * speed)
						elseif dropboxes["misc.movement.bhop"][2] == 4 
						and (MainPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall 
						or Input:IsKeyDown(Enum.KeyCode.Space)) then
							rootpart.Velocity = Vector3.new(travel2d.Unit.X * speed, rootpart.Velocity.Y, travel2d.Unit.Y * speed)
						elseif not (dropboxes["misc.movement.bhop"][2] >= 3) then
							rootpart.Velocity = Vector3.new(travel2d.Unit.X * speed, rootpart.Velocity.Y, travel2d.Unit.Y * speed)
						end
					end
				end
				
				if toggles["misc.movement.fly"][1] and flyToggle then
					local speed = sliders["misc.movement.flyspeed"][1]
					
					local travel = Vector3new
					local looking = workspace.CurrentCamera.CFrame.lookVector--getting camera looking vector
					
					if Input:IsKeyDown(Enum.KeyCode.W) then
						travel = travel + looking
					end
					if Input:IsKeyDown(Enum.KeyCode.S) then
						travel = travel - looking
					end
					if Input:IsKeyDown(Enum.KeyCode.D) then
						travel + = Vector3.new(-looking.Z, 0, looking.X)
					end
					if Input:IsKeyDown(Enum.KeyCode.A) then
						travel + = Vector3.new(looking.Z, 0, -looking.X)
					end
					
					if Input:IsKeyDown(Enum.KeyCode.Space) then
						travel + = Vector3.new(0, 1, 0)
					end
					if Input:IsKeyDown(Enum.KeyCode.LeftShift) then
						travel + = Vector3.new(0, -1, 0)
					end
					
					if travel.Unit.X == travel.Unit.X then
						rootpart.Anchored = false
						rootpart.Velocity = travel.Unit * speed --multiply the unit by the speed to make
					else
						rootpart.Velocity = Vector3.new(0, 0, 0)
						rootpart.Anchored = true
					end
				elseif flyToggle then
					rootpart.Anchored = false
				end
				
				workspace.Gravity = 196.2
				
				if keybinds["misc.movement.lowgravkey"][9] == nil or Input:IsKeyDown(keybinds["misc.movement.lowgravkey"][9]) then
					if dropboxes["misc.movement.lowgrav"][2] == 3 then
						if MainPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
							local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
							local grav = sliders["misc.movement.lowgrav"][1] / 20
							rootpart.Velocity = Vector3.new(rootpart.Velocity.X, rootpart.Velocity.Y + grav, rootpart.Velocity.Z)
						end
					elseif dropboxes["misc.movement.lowgrav"][2] == 2 then
						if MainPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
							workspace.Gravity = sliders["misc.movement.lowgrav"][1]
						end
					end
				end
				
				if toggles["misc.movement.circle"][1] and keybinds["misc.movement.circlekey"][9] and Input:IsKeyDown(keybinds["misc.movement.circlekey"][9]) then
					local speed = sliders["misc.movement.speed"][1]
					local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
					rootpart.Velocity = Vector3.new(math.sin(tick() * speed/10) * speed, rootpart.Velocity.Y, math.cos(tick() * speed/10) * speed)
				end
				
			end)
		end
		
	end
	if (keybinds["rage.antiaim"][9] == nil or keybinds["rage.antiaim"][9] and Input:IsKeyDown(keybinds["rage.antiaim"][9])) and toggles["rage.antiaim"][1] and toggles["rage.antiaim.infloor"][1] and MainPlayer.Character and MainPlayer.Character.Humanoid and MainPlayer.Character.Humanoid.FloorMaterial ~= "Air" and not MainPlayer.Character.Humanoid.Jump then
		local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not rootpart.Anchored then
			rootpart.Velocity = Vector3.new(rootpart.Velocity.X,-100,rootpart.Velocity.Z)
		end
	end
	if toggles["config.extra.levelup"][1] then
		if MainPlayer.Character then
			local rootpart = MainPlayer.Character:FindFirstChild("HumanoidRootPart")
			if rootpart then
				if rootpart.CFrame.Position.Y > -500 then
					gamenet:send("changehealthx", -100, "BFG 50", nil, "", Vector3.new(-9,10,100))
				end
				rootpart.CFrame = CFrame.new(0, -1000, 0)
				rootpart.Velocity = Vector3new
				local dogTag = workspace.Ignore.GunDrop:FindFirstChild("DogTag")
				if dogTag then
					rootpart.CFrame = dogTag.Tag.CFrame
					gamenet:send("capturedogtag", dogTag)
				end
				local points = workspace.Map:FindFirstChild("AGMP")
				if points then 
					for k, v in pairs(points:GetChildren()) do
						if v.TeamColor and v.TeamColor.Value ~= MainPlayer.TeamColor then
							rootpart.CFrame = CFrame.new(v.Base.Position - Vector3.new(1,0.1,0))
							break
						end
					end
				end
			end
		elseif workspace.Ignore.GunDrop:FindFirstChild("DogTag") or workspace.Map:FindFirstChild("AGMP") then
			if spawnAttempt then
				spawnAttempt = false
				spawn(function()
					repeat 
					wait(1)
					until not gamedeploy.isdeployed()
					gamedeploy.deploy()
					spawnAttempt = true
				end)
			end
		end		
	end
end)

--bloods n crips

local bloodcolor = game.RunService.RenderStepped:Connect(function()
	--spawn(function()
	if frameCount % 100 == 0 then
		for k, v in pairs(workspace.Ignore.Blood:GetChildren()) do
			if v.Color and toggles["esp.misc.bloodcolor"][1] then
				v.Color = Color3.fromRGB(colorpickers["esp.misc.bloodcolor"][6] , colorpickers["esp.misc.bloodcolor"][7], colorpickers["esp.misc.bloodcolor"][8])
				v.Transparency = 1+(-colorpickers["esp.misc.bloodcolor"][9] / 255)
			elseif v.Color then
				v.Color = Color3.fromRGB(151,0,0)
				v.Transparency = 0
			end
		end
	end
	--end)
end)


local autovote = game.RunService.RenderStepped:Connect(function()
	if toggles["misc.avote.enabled"][1] and math.floor(tick()) % 5 == 0 then
		local vk = Players.LocalPlayer.PlayerGui.ChatGame.Votekick
		local vkt = vk.Title.Text
		
		local avote = {
			n = dropboxes["misc.avote.none"][2],
			f = dropboxes["misc.avote.friends"][2],
			p = dropboxes["misc.avote.priority"][2]
		}
		
		for k, v in pairs(avote) do
			if v == 2 then
				avote[k] = "yes"
			elseif v == 3 then
				avote[k] = "no"
			end
		end
		
		for k, v in pairs(Players:GetPlayers()) do
			if string.match(vkt,v.Name) then
				if v == MainPlayer then
					gamehud:vote("no")
					break
				end
				for k1, v1 in pairs(priorityplyrs) do
					if v1 == v and avote.p ~= 1 then
						gamehud:vote(avote.p)
						break
					end
				end
				for k1, v1 in pairs(friendplyrs) do
					if v1 == v and avote.f ~= 1 then
						gamehud:vote(avote.f)
						break
					end
				end
				if avote.n ~= 1 then
					gamehud:vote(avote.n)
					break
				end
			end
		end
	end
end)



--sexy chamz mod :DDDD
local chamzzzz = game.RunService.RenderStepped:Connect(function() 
	
	for Index, Player in pairs(Players:GetPlayers()) do
		local Body = gamereplication.getbodyparts(Player)
		if Body and typeof(Body) == 'table' and rawget(Body, 'rootpart') then
			local highlightedGuy
			for k6, v6 in pairs(highlightedGuys) do
				if Player == v6 then
					highlightedGuy = v6
				end
			end
			local teamcham = toggles["esp.team.chams"][1]
			local enemycham = toggles["esp.enemy.chams"][1]
			local lteam = MainPlayer.Team
			if (
				(Player.Team == lteam and teamcham) 
				or (Player.Team ~= lteam and enemycham) 
				or Player == sexTarget 
				or (highlightedGuy and ((highlightedGuy.Team == lteam and teamcham) or (highlightedGuy.Team ~= lteam and enemycham)))
			) then
				local color
				local colorxqz
				local opacity
				local opacityxqz
				if Player.Team == Players.LocalPlayer.Team then
					color = Color3.fromRGB(colorpickers["esp.team.chamsvis"][6] , colorpickers["esp.team.chamsvis"][7], colorpickers["esp.team.chamsvis"][8]) 
					colorxqz = Color3.fromRGB(colorpickers["esp.team.chamsinvis"][6] , colorpickers["esp.team.chamsinvis"][7], colorpickers["esp.team.chamsinvis"][8])
					opacity = (-colorpickers["esp.team.chamsvis"][9] / 255) + 1
					opacityxqz = (-colorpickers["esp.team.chamsinvis"][9] / 255) + 1
				else
					color = Color3.fromRGB(colorpickers["esp.enemy.chamsvis"][6] , colorpickers["esp.enemy.chamsvis"][7], colorpickers["esp.enemy.chamsvis"][8]) 
					colorxqz = Color3.fromRGB(colorpickers["esp.enemy.chamsinvis"][6] , colorpickers["esp.enemy.chamsinvis"][7], colorpickers["esp.enemy.chamsinvis"][8])
					opacity = -(colorpickers["esp.enemy.chamsvis"][9] / 255) + 1
					opacityxqz = -(colorpickers["esp.enemy.chamsinvis"][9] / 255) + 1
				end
				
				for k2, v2 in pairs(priorityplyrs) do
					if Player == v2 and toggles["esp.settings.showfriends"][1] then
						color = Color3.fromRGB(colorpickers["esp.settings.showproirity"][6],colorpickers["esp.settings.showproirity"][7],colorpickers["esp.settings.showproirity"][8])
						colorxqz = Color3.fromRGB(colorpickers["esp.settings.showproirity"][6]*0.6,colorpickers["esp.settings.showproirity"][7]*0.6,colorpickers["esp.settings.showproirity"][8]*0.6)
					end
				end
				
				for k2, v2 in pairs(friendplyrs) do
					if Player == v2 and toggles["esp.settings.showfriends"][1] then
						color = Color3.fromRGB(colorpickers["esp.settings.showfriends"][6],colorpickers["esp.settings.showfriends"][7],colorpickers["esp.settings.showfriends"][8])
						colorxqz = Color3.fromRGB(colorpickers["esp.settings.showfriends"][6]*0.6,colorpickers["esp.settings.showfriends"][7]*0.6,colorpickers["esp.settings.showfriends"][8]*0.6)
					end
				end
				
				if toggles["esp.settings.showtarget"][1] and Player == sexTarget then
					color = Color3.fromRGB(colorpickers["esp.settings.showtarget"][6],colorpickers["esp.settings.showtarget"][7],colorpickers["esp.settings.showtarget"][8])
					colorxqz = Color3.fromRGB(colorpickers["esp.settings.showtarget"][6]*0.6,colorpickers["esp.settings.showtarget"][7]*0.6,colorpickers["esp.settings.showtarget"][8]*0.6)
					table.insert(highlightedGuys, Player)
				end
				
				Player.Character = Body.rootpart.Parent
				for a, b in pairs(Player.Character:GetChildren()) do
					if b.ClassName ~= "Model" and b.Name ~= "HumanoidRootPart" and (not b:FindFirstChild("box1") or menuopen or Player == sexTarget or highlightedGuy) then
						if b:FindFirstChild("box1") then
							b.box1:Destroy()
							b.box2:Destroy()
						end
						for i = 1, 2 do
							if b.Name ~= "Head" then
								box = Instance.new("BoxHandleAdornment", b)
								box.Size = b.Size + Vector3.new(0.1,0.1,0.1)
								if i == 2 and toggles["esp.misc.thinchams"][1] then
									box.Size = box.Size - Vector3.new(0.25,0.25,0.25)
								end
							else
								box = Instance.new("CylinderHandleAdornment", b)
								box.Height = b.Size.Y + 0.3
								box.Radius = b.Size.X / 2 + 0.2
								box.CFrame = CFrame.new(Vector3new, Vector3.new(0,1,0))
								if i == 2 and toggles["esp.misc.thinchams"][1] then
									box.Radius = box.Radius - 0.2
									box.Height = box.Height - 0.2
								end
							end
							box.Adornee = b
							
							box.ZIndex = 1
							
							if i == 1 then
								if toggles["esp.misc.glow"][1] then
									box.ZIndex = -1
									box.AlwaysOnTop = true	
								else
									box.AlwaysOnTop = false
								end
								box.Name = "box1"
								box.Color3 = color
								box.Transparency = opacity
							else 
								box.Name = "box2"
								box.AlwaysOnTop = true
								box.Color3 = colorxqz
								box.Transparency = opacityxqz
							end
						end
					end
				end
			elseif Player.Character then
				for a, b in pairs(Player.Character:GetChildren()) do
					if b:FindFirstChild("box1") then
						b.box1:Destroy()
						b.box2:Destroy()
					end	
				end
			end
		end
	end
end)

--anti afk
MainPlayer.Idled:Connect(function()
	game:GetService("VirtualUser"):CaptureController()
	game:GetService("VirtualUser"):ClickButton2(Vector2new)
end)
--auto respawn
local deployHook = gamedeploy.deploy
gamedeploy.deploy = function()
	updateMap()
	deployHook()
end
local spawnAttempt = true
game.RunService.Heartbeat:Connect(function()
	if toggles["misc.other.autorespawn"][1] and spawnAttempt then
		spawnAttempt = false
		spawn(function()
			repeat 
			wait(1)
			until not gamedeploy.isdeployed()
			gamedeploy.deploy()
			spawnAttempt = true
		end)
	end
end)

local loadgrenade = gamechar.loadgrenade
gamechar.loadgrenade = function(self,...)
	local args = {...}
	if toggles["misc.player.grenadetime"][1] then
		args[1].animations.pull = {}
		args[1].animations.throw = {}
	end
	return loadgrenade(self,unpack(args))
end


local blinkArray = {}
gamenet.send = function(self, ...)
	local args = {...}
	math.randomseed(frameCount)
	if args[1] == "closeconnection" then
		return 
	end
	if args[1] == "sprint" and (keybinds["rage.antiaim"][9] == nil or keybinds["rage.antiaim"][9] and Input:IsKeyDown(keybinds["rage.antiaim"][9])) and toggles["rage.antiaim"][1] and toggles["rage.antiaim.fakesprint"][1] then
		args[2] = true
	end
	if args[1] == "lookangles" and (keybinds["rage.antiaim"][9] == nil or keybinds["rage.antiaim"][9] and Input:IsKeyDown(keybinds["rage.antiaim"][9])) and toggles["rage.antiaim"][1] then
		local pitch = args[2].X
		local yaw = args[2].Y
		
		local a = dropboxes["rage.antiaim.X"][2]
		
		if a == 2 then
			pitch = 35.5
		elseif a == 3 then 
			pitch = 64.64
		elseif a == 4 then
			pitch = (frameCount / 10) % 100
		elseif a == 5 then
			pitch = math.pi * 7
		elseif a == 6 then
			pitch = math.random(-100,100)
		end
		
		local a = dropboxes["rage.antiaim.Y"][2]
		
		if a == 2 then
			yaw = (frameCount * (sliders["rage.antiaim.spin"][1] * 0.01)) % 100
		elseif a == 3 then
			yaw = math.random(-100,100)
		elseif a == 4 then
			yaw = yaw + 3.14
		end

		local jitter = sliders["rage.antiaim.jitter"][1] * 3.14/180
		if frameCount % 2 == 0 then
			jitter *= -1
		end
		
		yaw += jitter
		
		args[2]= Vector3.new(pitch, yaw, 0)
	elseif args[1] == "changehealthx" and args[3] ~= "BFG 50" and toggles["misc.movement.antifall"][1] then
		return false
	elseif args[1] == "newgrenade" and toggles["misc.player.grenadetp"][1] then
		local bestPlayer = getBestPlayer("nade", true, true)
		local ya = Vector3.new(0,2,0)
		if bestPlayer ~= Vector3new then
			args[3].blowuptime = 0
			for k, v in pairs(args[3].frames) do
				v.v0 = Vector3new
				v.p0 = bestPlayer + ya
			end
		end
	elseif args[1] == "newgrenade" and sliders["misc.player.grenadetime"][1] ~= 0 then
		args[3].blowuptime = sliders["misc.player.grenadetime"][1]/10
	elseif args[1] == "bullethit" and not toggles["config.extra.friendlyfire"][1] then
		local friendyguy = false
		for k, v in pairs(friendplyrs) do
			if args[2] == v then
				friendyguy = true
			end
		end
		if friendyguy then
			return 
		end
	elseif args[1] == "knifehit" and not toggles["config.extra.friendlyfire"][1] then
		local friendyguy = false
		for k, v in pairs(friendplyrs) do
			if args[2] == v then
				friendyguy = true
			end
		end
		if friendyguy then
			return
		end
	elseif args[1] == "newbullets" and toggles["rage.aimbot.enabled"][1] and
	(keybinds["rage.aimbot.enabled"][9] == nil or
	(keybinds["rage.aimbot.enabled"][9]  and Input:IsKeyDown(keybinds["rage.aimbot.enabled"][9]))) then
		--local targetPlayer, targettedPart = getBestPlayer("rage", false, toggles["rage.aimbot.static"][1], true)
		if rageTarget and gamelogic and gamelogic.currentgun.data.bulletspeed then
			local trajectory = gametraj(gamecam.cframe.p, Vector3new, Vector3.new(0,-192.6, 0), rageHitbox.Position, Vector3new, Vector3new, gamelogic.currentgun.data.bulletspeed)
			if trajectory then
				rageAngles += trajectory
			end
			for k2, v2 in pairs(args[2].bullets) do 
				args[2].bullets[k2][1] = rageAngles
			end
			do --playsounds and shit
				local sound = Instance.new("Sound")
				sound.PlayOnRemove = true
				sound.SoundId = "rbxassetid://424002310"
				sound.Volume = 2
				sound.Parent = workspace
				sound:Destroy()
				gamehud:firehitmarker(rageHitbox.Name == "Head")
				gamesound.PlaySound("hitmarker", nil, 1, 1.5)
			end
			-- sends updated pos to the server (works better?)
			send(self, "newpos", gamechar.torso.Position, gamecam.basecframe)
			
			args[2].firepos = gamecam.cframe.p
			args[2].pitch = 1
			send(self, unpack(args)) 
			if toggles["esp.misc.bullettracers"][1] then
				bulletTrace(args)
			end
			local tick = tick()
			for k, v in pairs(args[2].bullets) do
				send(self, "bullethit", rageTarget, tick - 0.01, tick, rageHitbox.Position, rageHitbox, args[2].bullets[k][2]) 
			end
			rageTarget = nil
			return
		end
	end
	if args[1] == "newbullets" then
		if toggles["esp.misc.bullettracers"][1] then
			bulletTrace(args)
		end
	end
	if args[1] == "stab" and dropboxes["misc.player.knifebot"][2] ~= 1 then
		local targettedPart, targetPlayer = getKnifeTarget()
		if targettedPart then
			send(self, "stab")
			send(self, "knifehit", targetPlayer, tick(), targettedPart)
		end
		return
	elseif args[1] == "spawn" then
		if toggles["misc.other.breakwindows"][1] then
			for k, v in pairs(getgc(true)) do
				if type(v) == "table" and rawget(v, "effects") then
					if v.effects and v.effects.module and v.effects.module.breakwindow then
						breakwindow = v.effects.module.breakwindow
					end
				end	
			end	
			if breakwindow then
				spawn(function()
					for i,v in pairs(workspace.Map:GetDescendants()) do
						if v:IsA("BasePart") and v.Name == "Window" then
							breakwindow(v, v, nil, true, true, nil, nil, nil)
						end
					end
				end)
			end
		end
		gunModsApply()
		if toggles["misc.player.scavenge"][1] then
			for i, data in pairs(getgc(true)) do
				if type(data) == "table" and rawget(data, "ammotype") then
					data.ammotype = ".44 Magnum"
				end
			end
		end
	end
	
	return send(self, unpack(args))
end

local bullettracing = game.RunService.RenderStepped:Connect(function()
	-- if gamechar.spawned then
	-- 	send(gamenet.send, "newpos", gamechar.torso.Position, gamecam.basecframe)
	-- end
	spawn(function()
		local sp = 0.003
		for k, v in pairs(bulletTracers) do
			if v[1] then
				v[2] = v[2] - sp
				v[1].Transparency = v[1].Transparency + sp
				if v[2] <= 0 then
					v[1]:Destroy()
				end
			end
		end
		if not MainPlayer.Character then
			bulletTracers = {}
		end
	end)
end)

local autoknife = game.RunService.RenderStepped:Connect(function()
	if dropboxes["misc.player.knifebot"][2] == 3 and MainPlayer.Character then
		gamenet.send(gamenet.send, "stab")
	end
end)

local stanceloop = game.RunService.RenderStepped:Connect(function()
	if (keybinds["rage.antiaim"][9] == nil or keybinds["rage.antiaim"][9] and Input:IsKeyDown(keybinds["rage.antiaim"][9])) and toggles["rage.antiaim"][1] and toggles["rage.antiaim.stance"][1] and
	(keybinds["rage.antiaim.stancekey"][9] == nil or Input:IsKeyDown(keybinds["rage.antiaim.stancekey"][9])) and gamechar.movementmode then
		
		a = dropboxes["rage.antiaim.stancetype"][2]
		local stance
		if a == 4 then
			a = math.floor(math.random(1,3.99))
		end
		if a == 3 then
			stance = "prone"
		elseif a == 2 then
			stance = "crouch"
		elseif a == 1 then
			stance = "stand"
		end
		gamenet.send(gamenet.send, "stance", stance)
	elseif gamechar.movementmode then
		gamenet.send(gamenet.send, "stance", gamechar.movementmode)
	end
end)

chatspam = {
	["tik"] = 0,
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
		string.rep("#", 250),
	},
	[5] = {
		"SH∪T UP ",
		"STOP TALKING ",
		"SHUT THE HELL UP ",
		"SHUT YOUR DAMN MOUTH ",
		"PLEASE SH∪T ∪P ",
		"STFUHOE "
	},
	[6] = {
		"音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
		"持有毁灭性的神经重景气游行脸红青铜色类别创意案",
		"诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
		"完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
		"庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇", 
	},
	[7] = {
		"n象gger ",
		"n上gger ",
		"n卜gger ",
		"㭁itch ",
		"f㕣ggot ",
		"f婴cktards ",
		"n卜gger R㕣PE child P㔾RN ",
	},
	[8] = {
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
	[9] = {
		"discoard.gg/WkEYr2 ",
	},
	[10] = {
		"gEt OuT oF tHe GrOuNd 🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡 ",
		"brb taking a nap 💤💤💤 ",
		"gonna go take a walk 🚶‍♂️🚶‍♀️🚶‍♂️🚶‍♀️ ",
		"low orbit ion cannon booting up ",
		"how does it feel to not have bbot 🤣🤣🤣😂😂😹😹😹 ",
		"im a firing my laza! 🙀🙀🙀 "
  },
}
local chatSpam = game.RunService.RenderStepped:Connect(function()
	local m = dropboxes["misc.player.chatspam"][2]
	local mi = chatspam[m]
	if mi then
		local tik = math.floor(tick())
		if tik % 3 == 0 and tik ~= chatspam["tik"] then
			chatspam["tik"] = tik
			local message = mi[math.floor(math.random(#mi))]
			if toggles["misc.player.chatspam.repeat"][1] then
				message = string.rep(message, 100)
			end
			gamenet:send("chatted",message)
		end
	end
end)

local logo = game.RunService.RenderStepped:Connect(function()
	if toggles["config.extra.logo"][1] then
		if chatBox.Active then
			chatBox.PlaceholderText = ""
			chatBox.PlaceholderColor3 = Color3.fromRGB(255,255,255)
			chatBox.TextXAlignment = Enum.TextXAlignment.Left
			chatBox.TextScaled = false
		else
			chatBox.Text = ""
			chatBox.PlaceholderText = "bitchbot.fun"
			chatBox.PlaceholderColor3 = Color3.fromRGB(150,80,190)
			chatBox.TextXAlignment = Enum.TextXAlignment.Center
			chatBox.TextScaled = true
			chatGame:FindFirstChild("Version").Visible = false
		end
	else
		chatBox.PlaceholderText = ""
		chatBox.TextXAlignment = Enum.TextXAlignment.Left
		chatBox.TextScaled = false
		chatGame:FindFirstChild("Version").Visible = true
	end
end)

