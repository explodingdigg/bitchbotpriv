
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
		temptable.OutlineThickness = 2
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


-- local text = "The quick brown fox jumped over the lazy dogs"
-- local test = {}
-- Draw:Text(true, text, "smallest", Point2D.new(Vec2(10, 15)), false, RGB(255, 255, 255), 255, true, test)
-- Draw:Text(true, text, "norm", Point2D.new(Vec2(10, 25)), false, RGB(255, 255, 255), 255, true, test)
-- Draw:Text(true, text, "small", Point2D.new(Vec2(10, 40)), false, RGB(255, 255, 255), 255, true, test)

function Draw:OutlineRect(visible, pos, size, color, transparency, tablename)
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
--!SECTION Drawing shit end

local Menu = { --ANCHOR Menu table
    pos = Vec2(10, 10),
	point2d = Point2D.new(Vec2(10, 10)),
	open = true,
	fading = false,
	dragging = false,
	clickspot = Vec2(0, 0),
    w = 500,
    h = 600,
	mc = {127, 72, 163},
	connections = {},
	clrs = {
		norm = {},
		dark = {},
		togs = {},
	},

}

function Menu:MouseInMenu()
	return (LOCAL_MOUSE.x > Menu.pos.x and LOCAL_MOUSE.x < Menu.pos.x + Menu.w and LOCAL_MOUSE.y > Menu.pos.y - 32 and LOCAL_MOUSE.y < Menu.pos.y + Menu.h)
end

function Menu:MouseInMenuCenter()
	return (LOCAL_MOUSE.x > Menu.pos.x + 9 and LOCAL_MOUSE.x < Menu.pos.x + Menu.w - 9 and LOCAL_MOUSE.y > Menu.pos.y - 9 and LOCAL_MOUSE.y < Menu.pos.y + Menu.h - 47)
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

function Menu:SetPos(x, y)
	Menu.pos = Vec2(x, y)
	Menu.point2d.Point = UDim2.new(0, x, 0, y)
end

Menu:SetPos(math.floor((SCREEN_SIZE.x / 2) - (Menu.w / 2)), math.floor((SCREEN_SIZE.y / 2) - (Menu.h / 2)))

local mDraw = {
	zindex = 1
}

function mDraw:Text(visible, text, font, pos, centered, color, transparency, outline, tablename)
	local drawnobj = Draw:Text(visible, text, font, PointOffset.new(Menu.point2d, pos.X, pos.Y), centered, color, transparency, outline, tablename)
	drawnobj.ZIndex = mDraw.zindex
	return drawnobj
end

function mDraw:OutlineRect(visible, pos, size, color, transparency, tablename)
	local drawnobj = Draw:OutlineRect(visible, PointOffset.new(Menu.point2d, pos.X, pos.Y), size, color, transparency, tablename)
	drawnobj.ZIndex = mDraw.zindex
	return drawnobj
end

function mDraw:FilledRect(visible, pos, size, color, transparency, tablename)
	local drawnobj = Draw:FilledRect(visible, PointOffset.new(Menu.point2d, pos.X, pos.Y), size, color, transparency, tablename)
	drawnobj.ZIndex = mDraw.zindex
	return drawnobj
end
--[[
			Draw:MenuOutlinedRect(true, 2, 2, menu.w - 3, 1, { 127, 72, 163, 255 }, bbmenu)
		table.insert(menu.clrs.norm, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 3, menu.w - 3, 1, { 87, 32, 123, 255 }, bbmenu)
		table.insert(menu.clrs.dark, bbmenu[#bbmenu])
		Draw:MenuOutlinedRect(true, 2, 4, menu.w - 3, 1, { 20, 20, 20, 255 }, bbmenu)
]]
function Menu:Initialize(menutable)
	local bbmenu = {}
	mDraw:OutlineRect(true, Vec2(0, 0), Vec2(Menu.w, Menu.h), RGB(0, 0, 0), 255, bbmenu)
	mDraw:OutlineRect(true, Vec2(1, 1), Vec2(Menu.w - 2, Menu.h - 2), RGB(20, 20, 20), 255, bbmenu)
	table.insert(Menu.clrs.norm, mDraw:OutlineRect(true, Vec2(2, 2), Vec2(Menu.w - 4, 1), RGB(self.mc[1], self.mc[2], self.mc[3]), 255, bbmenu))
	table.insert(Menu.clrs.dark, mDraw:OutlineRect(true, Vec2(2, 3), Vec2(Menu.w - 4, 1), RGB(self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40), 255, bbmenu))
	mDraw:OutlineRect(true, Vec2(2, 4), Vec2(Menu.w - 4, 1), RGB(20, 20, 20), 255, bbmenu)

	for i = 0, 19 do
		local tempdrawing = mDraw:FilledRect(true, Vec2(2, 5 + i), Vec2(Menu.w - 4, 1), RGB(20, 20, 20), 255, bbmenu)
		
		tempdrawing.Color = ColorRange(i, { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 20, color = RGB(35, 35, 35) } })
	end

	mDraw:FilledRect(true, Vec2(2, 25), Vec2(Menu.w - 4, Menu.h -27), RGB(35, 35, 35), 255, bbmenu)

	mDraw:Text(true, "Bitch Bot", "norm", Vec2(6, 4), false, RGB(255, 255, 255), 255, true, bbmenu)

	mDraw:OutlineRect(true, Vec2(8, 22), Vec2(Menu.w - 16, Menu.h - 30), RGB(0, 0, 0), 255, bbmenu)
	mDraw:OutlineRect(true, Vec2(9, 23), Vec2(Menu.w - 18, Menu.h - 32), RGB(20, 20, 20), 255, bbmenu)
	table.insert(Menu.clrs.norm, mDraw:OutlineRect(true, Vec2(10, 24), Vec2(Menu.w - 20, 1), RGB(self.mc[1], self.mc[2], self.mc[3]), 255, bbmenu))
	table.insert(Menu.clrs.dark, mDraw:OutlineRect(true, Vec2(10, 25), Vec2(Menu.w - 20, 1), RGB(self.mc[1] - 40, self.mc[2] - 40, self.mc[3] - 40), 255, bbmenu))
	mDraw:OutlineRect(true, Vec2(10, 26), Vec2(Menu.w - 20, 1), RGB(20, 20, 20), 255, bbmenu)

	for i = 0, 14 do
		local tempdrawing = mDraw:FilledRect(true, Vec2(10, 27 + (i * 2)), Vec2(Menu.w - 20, 2), RGB(35, 35, 35), 255, bbmenu)

		tempdrawing.Color = ColorRange(i, { [1] = { start = 0, color = RGB(50, 50, 50) }, [2] = { start = 15, color = RGB(35, 35, 35) } })
	end
	mDraw:FilledRect(true, Vec2(10, 57), Vec2(Menu.w - 20, Menu.h -67), RGB(35, 35, 35), 255, bbmenu)

	local MenuFuncs = {}

	function MenuFuncs:MouseButton1Down()
		if Menu:MouseInMenu() and not Menu:MouseInMenuCenter() then
			--print(LOCAL_MOUSE.x, Menu.pos.x)
			Menu.clickspot = Vec2(Menu.pos.x - LOCAL_MOUSE.x, Menu.pos.y - (LOCAL_MOUSE.y - 36))
			Menu.dragging = true
			
		end
	end

	Menu.connections["menu input"] = INPUT_SERVICE.InputBegan:Connect(function(input) 
		if Menu.open and not Menu.fading then
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				MenuFuncs:MouseButton1Down()
			end
		end
	end)

	Menu.connections["menu render stepped"] = game.RunService.RenderStepped:Connect(function(fdt)
		if Menu.open and not Menu.fading then
			if Menu.dragging then
				if INPUT_SERVICE:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
					Menu:SetPos(LOCAL_MOUSE.x + Menu.clickspot.x, (LOCAL_MOUSE.y - 36) + Menu.clickspot.y)
				else
					Menu.dragging = false
				end
			end
		end
	end)

	--[[

	]]
end

Menu:Initialize({})



wait(10)
Menu:Unload()
print("destroyed")
