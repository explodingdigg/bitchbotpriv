
--ANCHOR Variable and functions setup
local Vec2 = Vector2.new
local RGB = Color3.fromRGB

local Players = game:GetService("Players")
local LIGHTING = game:GetService("Lighting")
local stats = game:GetService("Stats")
local LOCAL_PLAYER = Players.LocalPlayer
local LOCAL_MOUSE = LOCAL_PLAYER:GetMouse()
local TEAMS = game:GetService("Teams")
local INPUT_SERVICE = game:GetService("UserInputService")
--local GAME_SETTINGS = UserSettings():GetService("UserGameSettings")
local CACHED_VEC3 = Vector3.new()
local Camera = workspace.CurrentCamera
local SCREEN_SIZE = Camera.ViewportSize

local function Lerp(delta, from, to) -- wtf why were these globals thats so exploitable!
	if (delta > 1) then
		return to
	end
	if (delta < 0) then
		return from
	end
	return from + (to - from) * delta
end

local function ColorRange(value, ranges) -- ty tony for dis function u a homie
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
		Lerp(lerpValue, minColor.color.r, maxColor.color.r),
		Lerp(lerpValue, minColor.color.g, maxColor.color.g),
		Lerp(lerpValue, minColor.color.b, maxColor.color.b)
	)
end

local function reverse_table(tbl) -- THANKS FINI <33333
    local new_tbl = {}
    for i = 1, #tbl do
        new_tbl[#tbl + 1 - i] = tbl[i]
    end
    return new_tbl
end

local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function average(t)
	local sum = 0
	for _, v in pairs(t) do -- Get the sum of all numbers in t
		sum = sum + v
	end
	return sum / #t
end

local function clamp(a, lowerNum, higher) -- DONT REMOVE this clamp is better then roblox's because it doesnt error when its not lower or heigher
	if a > higher then
		return higher
	elseif a < lowerNum then
		return lowerNum
	else
		return a
	end
end

local function CreateThread(func, ...) -- improved... yay.
	local thread = coroutine.create(func)
	coroutine.resume(thread, ...)
	return thread
end

local function MultiThreadList(obj, ...)
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

				CreateThread(t[1], unpack(t[2]))
			else
				CreateThread(t, ...)
			end
		end
	else
		for i, v in pairs(obj) do
			CreateThread(v, ...)
		end
	end
end

local Draw = {
    allrender = {},
	fonts = {}
} -- SECTION Drawing shit start

function Draw:UnRender()
    for k, v in pairs(self.allrender) do
        for k1, v1 in pairs(v) do
            v1.Visible = false
        end
        v = nil
    end

    self = nil
end

function Draw:RegisterFont(name, font, size, pixel_scale)
	self.fonts[name] = {
		font = DrawFont.Register(font, pixel_scale == nil and size or pixel_scale),
		size = size,
	}
end

function Draw:Text(visible, text, font, pos, centered, color, transparency, outline, tablename)
    local temptable = TextDynamic.new()
	temptable.Visible = visible
	temptable.Position = pos
	temptable.Text = text
	temptable.Font = Draw.fonts[font].font
	temptable.Size = Draw.fonts[font].size
	temptable.Color = color
	temptable.Opacity = transparency/255

	if centered then
		temptable.XAlignment = XAlignment.Center
	else
		temptable.XAlignment = XAlignment.Left
    	temptable.YAlignment = YAlignment.Top
	end 

	if outline then
		temptable.Outlined = true
		temptable.OutlineColor = RGB(0, 0, 0)
		temptable.OutlineThickness = 1
		temptable.OutlineOpacity = transparency/255
	end
    
    if not table.find(self.allrender, tablename) then
        table.insert(self.allrender, tablename)
    end

    if tablename ~= nil then
        table.insert(tablename, temptable)
    end
    
    return temptable
end

Draw:RegisterFont("smallest", readfile("smallest_pixel-7.ttf"), 10)
Draw:RegisterFont("small", readfile("ProggyTinySZ.ttf"), 16)
Draw:RegisterFont("norm", readfile("ProggyCleanSZ.ttf"), 16)

function Draw:OutlinedRect(visible, pos, size, color, transparency, tablename)
    local temptable = RectDynamic.new()
    temptable.Visible = visible
    temptable.Filled = false
    temptable.Thickness = 1
    temptable.Size = size
    temptable.Color = color
    temptable.Opacity = transparency/255
    temptable.Position = pos

    temptable.XAlignment = XAlignment.Right
    temptable.YAlignment = YAlignment.Bottom
    
    if not table.find(self.allrender, tablename) then
        table.insert(self.allrender, tablename)
    end

    if tablename ~= nil then
        table.insert(tablename, temptable)
    end
    
    return temptable
end

function Draw:FilledRect(visible, pos, size, color, transparency, tablename)
    local temptable = RectDynamic.new()
    temptable.Visible = visible
    temptable.Filled = true
    temptable.Thickness = 1
    temptable.Size = size
    temptable.Color = color
    temptable.Opacity = transparency/255
    temptable.Position = pos

    temptable.XAlignment = XAlignment.Right
    temptable.YAlignment = YAlignment.Bottom
    
    if not table.find(self.allrender, tablename) then
        table.insert(self.allrender, tablename)
    end

    if tablename ~= nil then
        table.insert(tablename, temptable)
    end
    
    return temptable
end

function Draw:Poly(visible, points, color, transparency, outline, tablename)
	local temptable = PolyLineDynamic.new()
    temptable.Visible = visible
	temptable.FillType = PolyLineFillType.Filled
    temptable.Thickness = 1
    temptable.Color = color
    temptable.Opacity = transparency/255
    temptable.Points = points

	if outline ~= false then
		temptable.Outlined = true
		temptable.OutlineColor = outline
		temptable.OutlineThickness = 1.5
		temptable.OutlineOpacity = transparency/255
	end
    
    if not table.find(self.allrender, tablename) then
        table.insert(self.allrender, tablename)
    end

    if tablename ~= nil then
        table.insert(tablename, temptable)
    end
    
    return temptable
end
--!SECTION Drawing shit end



--[[
	pos = Vec2(10, 10),
	point2d = Point2D.new(Vec2(10, 10)),
	open = true,
	fading = false,
	dragging = false,
	clickspot = Vec2(0, 0),
	w = 500,
	h = 600,
]]
local Menu = { --ANCHOR Menu table
	Funcs = {},
	windows = {},
	window_order = {},
	selected_window = nil,
	Curmenu = nil,
	open = false,
	fading = false,
	fadestart = tick(),
	mc = {127, 72, 163},
	Cursor = {},
	CursorPoint2D = PointMouse.new(),
	connections = {},
	clrs = {
		norm = {},
		dark = {},
		togs = {},
	},
}

table.insert(Menu.clrs.norm, Draw:Poly(true, {PointOffset.new(Menu.CursorPoint2D, 1, 1), PointOffset.new(Menu.CursorPoint2D, 1, 16), PointOffset.new(Menu.CursorPoint2D, 5, 11), PointOffset.new(Menu.CursorPoint2D, 11, 11)}, RGB(Menu.mc[1], Menu.mc[2], Menu.mc[3]), 255, RGB(0, 0, 0), Menu.Cursor))
Menu.Cursor[1].ZIndex = 10000 --lol


function Menu:MouseInMenu(window)
	local tabbie = Menu.windows[window]
	return (LOCAL_MOUSE.x > tabbie.pos.x and LOCAL_MOUSE.x < tabbie.pos.x + tabbie.w and LOCAL_MOUSE.y > tabbie.pos.y - 32 and LOCAL_MOUSE.y < tabbie.pos.y + tabbie.h)
end

function Menu:MouseInMenuCenter(window)
	local tabbie = Menu.windows[window]
	return (LOCAL_MOUSE.x > tabbie.pos.x + 9 and LOCAL_MOUSE.x < tabbie.pos.x + tabbie.w - 9 and LOCAL_MOUSE.y > tabbie.pos.y - 9 and LOCAL_MOUSE.y < tabbie.pos.y + tabbie.h - 47)
end

function Menu:SetPos(x, y)
	Menu.Curmenu.pos = Vec2(x, y)
	Menu.Curmenu.point2d.Point = UDim2.new(0, x, 0, y)
end

function Menu:SetVisible(visible)
	Menu.Cursor[1].Visible = visible
	for window_name, window_val in pairs(Menu.windows) do
		for k, v in pairs(window_val.bbmenu) do
			v.Visible = visible
		end
	end
end

function Menu:SetVisible(visible)
	Menu.Cursor[1].Visible = visible
	for window_name, window_val in pairs(Menu.windows) do
		for k, v in pairs(window_val.bbmenu) do
			v.Visible = visible
		end
	end
end

function Menu:SetOpacity(transparency)

	local opacity = transparency/255
	Menu.Cursor[1].Opacity = opacity
	Menu.Cursor[1].OutlineOpacity = opacity

	for window_name, window_val in pairs(Menu.windows) do
		for k, v in pairs(window_val.bbmenu) do
			v.Opacity = opacity
			if v.Outlined then
				v.OutlineOpacity = opacity
			end
		end
	end
end

function Menu:SetSelectedWindow(window)
	local tabbie = Menu.windows[window]

	local newtable = {}
	for i, v in ipairs(self.window_order) do
		if v ~= window then
			table.insert(newtable, v)
		end
	end
	table.insert(newtable, window)
	self.window_order = newtable 

	
	for g_index, windowname in ipairs(self.window_order) do
		local curwindow = Menu.windows[windowname]

		local indexadd = 10 * g_index - 10
		for zindex, menuobjs in ipairs(curwindow.zindexs) do
			
			local setindex = indexadd + zindex
			for i, obj in ipairs(menuobjs) do
				obj.ZIndex = setindex
			end
		end
	end

	self.selected_window = window
	self.Curmenu = tabbie
end

function Menu:Unload()
	for k, conn in next, self.connections do
		if not getrawmetatable(conn) then
			conn()
		else
			conn:Disconnect()
		end
		self.connections[k] = nil
	end

	Draw:UnRender()
	
	Menu = nil 
	mDraw = nil
	Draw = nil
end


function Menu.Funcs:MouseButton1Down()
	if Menu:MouseInMenu(Menu.selected_window) and not Menu:MouseInMenuCenter(Menu.selected_window) then

		Menu.Curmenu.clickspot = Vec2(Menu.Curmenu.pos.x - LOCAL_MOUSE.x, Menu.Curmenu.pos.y - (LOCAL_MOUSE.y - 36))
		Menu.Curmenu.dragging = true
		
	end
end

function Menu.Funcs:KeyPressed(key)
	if key.KeyCode == Enum.KeyCode.End then
		Menu:Unload()
		print("destroyed")
	end
end

Menu.connections["menu input"] = INPUT_SERVICE.InputBegan:Connect(function(input)
	if not Menu.fading then
		if input.KeyCode == Enum.KeyCode.Delete then

			if Menu.fading == false then
	
				Menu.fadestart = tick()
				Menu.fading = true
				Menu.Curmenu.dragging = false
				if Menu.open == false then
					Menu:SetVisible(true)
				end
			end
		end
	end
	if Menu.open and not Menu.fading and Menu.selected_window ~= nil then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then	

			for window_index, window_name in ipairs(reverse_table(Menu.window_order)) do
				if Menu:MouseInMenu(window_name) then

					if window_name ~= Menu.selected_window then
						Menu:SetSelectedWindow(window_name)
					end

					break
				end
			end

			Menu.Funcs:MouseButton1Down()
		else
			Menu.Funcs:KeyPressed(input)
		end
	end
end)

Menu.connections["menu render stepped"] = game.RunService.RenderStepped:Connect(function(fdt)
	if Menu.fading then
		if Menu.open then
			local timesincefade = tick() - Menu.fadestart
			local fade_amount = 255 - math.floor((timesincefade * 10) * 255)
			Menu:SetOpacity(fade_amount)
			if fade_amount <= 0 then
				Menu.open = false
				Menu.fading = false
				Menu:SetOpacity(0)
				Menu:SetVisible(false)
			end
		else

			local timesincefade = tick() - Menu.fadestart
			local fade_amount = math.floor((timesincefade * 10) * 255)
			Menu:SetOpacity(fade_amount)
			if fade_amount >= 255 then
				Menu.open = true
				Menu.fading = false
				Menu:SetOpacity(255)
			end
		end
	end

	if Menu.open and not Menu.fading and Menu.selected_window ~= nil then
		if Menu.Curmenu.dragging then
			if INPUT_SERVICE:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				Menu:SetPos(LOCAL_MOUSE.x + Menu.Curmenu.clickspot.x, (LOCAL_MOUSE.y - 36) + Menu.Curmenu.clickspot.y)
			else
				Menu.Curmenu.dragging = false
			end
		end
	end
end)

function Menu:Create(menuname, menuprops, menutable)


	self.windows[menuname] = {
		zindexs = {},
		pos = Vec2(menuprops.pos.x, menuprops.pos.y),
		point2d = Point2D.new(menuprops.pos),
		dragging = false,
		clickspot = Vec2(0, 0),
		w = menuprops.w,
		h = menuprops.h,
		bbmenu = {},
	}

	table.insert(self.window_order, menuname)

	local curmenu = self.windows[menuname]
	
	self.selected_window = menuname
	self.Curmenu = curmenu

	for i = 1, 10 do
		table.insert(curmenu.zindexs, {})
	end

	

	local mDraw = {
		addindex = 10 * #self.window_order - 10,
		zindex = 1
	}
	
	function mDraw:Text(visible, text, font, pos, centered, color, transparency, outline, tablename)
		local drawnobj = Draw:Text(visible, text, font, PointOffset.new(curmenu.point2d, pos.X, pos.Y), centered, color, transparency, outline, tablename)
		drawnobj.ZIndex = mDraw.zindex + mDraw.addindex
		table.insert(curmenu.zindexs[mDraw.zindex], drawnobj)
		return drawnobj
	end
	
	function mDraw:OutlinedRect(visible, pos, size, color, transparency, tablename)
		local drawnobj = Draw:OutlinedRect(visible, PointOffset.new(curmenu.point2d, pos.X, pos.Y), size, color, transparency, tablename)
		drawnobj.ZIndex = mDraw.zindex + mDraw.addindex
		table.insert(curmenu.zindexs[mDraw.zindex], drawnobj)
		return drawnobj
	end
	
	function mDraw:FilledRect(visible, pos, size, color, transparency, tablename)
		local drawnobj = Draw:FilledRect(visible, PointOffset.new(curmenu.point2d, pos.X, pos.Y), size, color, transparency, tablename)
		drawnobj.ZIndex = mDraw.zindex + mDraw.addindex
		table.insert(curmenu.zindexs[mDraw.zindex], drawnobj)
		return drawnobj
	end
	
	bbmenu = curmenu.bbmenu
	mDraw:OutlinedRect(true, Vec2(0, 0), Vec2(curmenu.w, curmenu.h), RGB(0, 0, 0), 255, bbmenu)
	mDraw:OutlinedRect(true, Vec2(1, 1), Vec2(curmenu.w - 2, curmenu.h - 2), RGB(20, 20, 20), 255, bbmenu)
	table.insert(Menu.clrs.norm, mDraw:OutlinedRect(true, Vec2(2, 2), Vec2(curmenu.w - 4, 1), RGB(self.mc[1], self.mc[2], self.mc[3]), 255, bbmenu))
	table.insert(Menu.clrs.dark, mDraw:OutlinedRect(true, Vec2(2, 3), Vec2(curmenu.w - 4, 1), RGB(self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40), 255, bbmenu))
	mDraw:OutlinedRect(true, Vec2(2, 4), Vec2(curmenu.w - 4, 1), RGB(20, 20, 20), 255, bbmenu)

	for i = 0, 19 do
		local tempdrawing = mDraw:FilledRect(true, Vec2(2, 5 + i), Vec2(curmenu.w - 4, 1), RGB(20, 20, 20), 255, bbmenu)
		
		tempdrawing.Color = ColorRange(i, { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 20, color = RGB(35, 35, 35) } })
	end

	mDraw:FilledRect(true, Vec2(2, 25), Vec2(curmenu.w - 4, curmenu.h -27), RGB(35, 35, 35), 255, bbmenu)

	mDraw:Text(true, menuprops.name, "norm", Vec2(6, 4), false, RGB(255, 255, 255), 255, true, bbmenu)

	mDraw:OutlinedRect(true, Vec2(8, 22), Vec2(curmenu.w - 16, curmenu.h - 30), RGB(0, 0, 0), 255, bbmenu)
	mDraw:OutlinedRect(true, Vec2(9, 23), Vec2(curmenu.w - 18, curmenu.h - 32), RGB(20, 20, 20), 255, bbmenu)
	table.insert(Menu.clrs.norm, mDraw:OutlinedRect(true, Vec2(10, 24), Vec2(curmenu.w - 20, 1), RGB(self.mc[1], self.mc[2], self.mc[3]), 255, bbmenu))
	table.insert(Menu.clrs.dark, mDraw:OutlinedRect(true, Vec2(10, 25), Vec2(curmenu.w - 20, 1), RGB(self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40), 255, bbmenu))
	mDraw:OutlinedRect(true, Vec2(10, 26), Vec2(curmenu.w - 20, 1), RGB(20, 20, 20), 255, bbmenu)

	for i = 0, 14 do
		local tempdrawing = mDraw:FilledRect(true, Vec2(10, 27 + (i * 2)), Vec2(curmenu.w - 20, 2), RGB(35, 35, 35), 255, bbmenu)

		tempdrawing.Color = ColorRange(i, { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 15, color = RGB(35, 35, 35) } })
	end
	mDraw:FilledRect(true, Vec2(10, 57), Vec2(curmenu.w - 20, curmenu.h -67), RGB(35, 35, 35), 255, bbmenu)

end

Menu:Create("main", {
	tabstyle = 1,
	name = "Bitch Bot",
	pos = Vec2(10, 100),
	w = 500,
	h = 600,
}, {

})

Menu:Create("plyrlist", {
	tabstyle = 1,
	name = "Player List",
	pos = Vec2(520, 100),
	w = 600,
	h = 500,
}, {

})
-- Menu:SetVisible(false)
Menu:SetOpacity(0)
Menu.fading = true
Menu.fadestart = tick()

print("done making menus")
