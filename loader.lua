local mp = { -- this is for menu stuffs n shi
    w = 350,
    h = 300,
    x = 200,
    y = 300,
    activetab = 1, -- do not change this value please its not made to be fucked with sorry
    open = false,
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
    unloaded = false,
    autoload = false,
    connections = {},
    tabnum2str = {} -- its used to change the tab num to the string (did it like this so its dynamic if u add or remove tabs or whatever :D)
}


mp.dir = "uni"

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


local imgurl = "https://i.imgur.com/4AwgJLw.png"

if game.PlaceId == 292439477 then
    imgurl = "https://i.imgur.com/efyiyuX.png"
end


local BBOT_IMAGES = {}
MultiThreadList({
    function() BBOT_IMAGES[1] = game:HttpGet("https://i.imgur.com/9NMuFcQ.png") end,
    function() BBOT_IMAGES[2] = game:HttpGet("https://i.imgur.com/jG3NjxN.png") end,
    function() BBOT_IMAGES[3] = game:HttpGet("https://i.imgur.com/2Ty4u2O.png") end,
    function() BBOT_IMAGES[4] = game:HttpGet("https://i.imgur.com/kNGuTlj.png") end,
    function() BBOT_IMAGES[5] = game:HttpGet("https://i.imgur.com/OZUR3EY.png") end,
    function() BBOT_IMAGES[6] = game:HttpGet(imgurl) end
})

-- MULTITHREAD DAT LOADING SO FAST!!!!
local loaded = {}
do
	local function Loopy_Image_Checky()
		for i = 1, 6 do
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

-- nate i miss u D:

-- im back

game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)

if not isfolder("bitchbot") then
    makefolder("bitchbot")
end

if not isfolder("bitchbot/pf") then
    makefolder("bitchbot/".. mp.dir)
end

if not isfile("bitchbot/settings.bb") then
    writefile("bitchbot/settings.bb", "")
end

local Players = game:GetService("Players")
local LOCAL_PLAYER = Players.LocalPlayer
local LOCAL_MOUSE = LOCAL_PLAYER:GetMouse()
local INPUT_SERVICE = game:GetService("UserInputService")
local GAME_SETTINGS = UserSettings():GetService("UserGameSettings")
local CACHED_VEC3 = Vector3.new()
local Camera = workspace.CurrentCamera
local SCREEN_SIZE = Camera.ViewportSize

mp.x = math.floor((SCREEN_SIZE.X/2) - (mp.w/2))
mp.y = math.floor((SCREEN_SIZE.Y/2) - (mp.h/2))


    contains = function(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end



    mathlerp = function(delta, from, to)
        if (delta > 1) then
            return to
        end
        if (delta < 0) then
            return from
        end
        return from + ( to - from ) * delta
    end

    colorrange = function(value, ranges) -- ty tony for dis function u a homie
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
        return Color3.new(mathlerp( lerpValue, minColor.color.r, maxColor.color.r ), mathlerp( lerpValue, minColor.color.g, maxColor.color.g ), mathlerp( lerpValue, minColor.color.b, maxColor.color.b ))
    end

do -- metatable additions strings and such

    local strMt = getrawmetatable("")

    strMt.__add = function(s1, s2)
        return s1 .. s2
    end
    strMt.__mul = function(s1, num)
        return string.rep(s1, num)
    end
    strMt.__unm = function(s1)
        return string.reverse(s1)
    end
    strMt.__div = function(s1, num)
        return num == 0 and s1 or string.sub(s1, 1, num)
    end
    strMt.__sub = function(s1, num)
        return string.sub(s1, 1, #s1-num)
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
        if not contains(allrender, tablename) then
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
        if not contains(allrender, tablename) then
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
        if not contains(allrender, tablename) then
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
        if not contains(allrender, tablename) then
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
        if not contains(allrender, tablename) then
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
        if not contains(allrender, tablename) then
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
        if not contains(allrender, tablename) then
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

function mp.BBMenuInit(menutable)
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

		Draw:MenuBigText("BitchBot Loader", true, false, 6, 6, bbmenu)

		

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



		function Draw:Button(name, x, y, length, tab)
			local temptable = {}

			for i = 0, 12 do
				Draw:MenuFilledRect(true, x + 2, y + 2 + (i * 2), length - 4, 2, {0, 0, 0, 255}, tab)
				tab[#tab].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 8, color = RGB(35, 35, 35)}})
				table.insert(temptable, tab[#tab])
			end

			Draw:MenuOutlinedRect(true, x, y, length, 30, {30, 30, 30, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 1, y + 1, length - 2, 28, {0, 0, 0, 255}, tab)
			Draw:MenuBigText(name, true, true, x + math.floor(length * 0.5), y + 8 , tab)

			return temptable
		end

		function Draw:ImageWithText(size, image, text, x, y, tab)
			local temptable = {}
			Draw:MenuOutlinedRect(true, x, y, size + 4, size + 4, {30, 30, 30, 255}, tab)
			Draw:MenuOutlinedRect(true, x + 1, y + 1, size + 2, size + 2, {0, 0, 0, 255}, tab)
			Draw:MenuFilledRect(true, x + 2, y + 2, size, size, {40, 40, 40, 255}, tab)

			Draw:MenuBigText(text, true, false, x + size + 8, y, tab)
			table.insert(temptable, tab[#tab])

			Draw:MenuImage(true, BBOT_IMAGES[6], x + 2, y + 2, size, size, 1, tab)
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
		if v.content ~= nil then
			for k1, v1 in pairs(v.content) do
				Draw:CoolBox(v1.name, v1.x, v1.y, v1.width, v1.height, tabz[k])
				mp.options[v.name][v1.name] = {}
				if v1.content ~= nil then
					local y_pos = 24
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
							y_pos += 39
						elseif v2.type == "button" then
							mp.options[v.name][v1.name][v2.name] = {}
							if v2.pos ~= nil then
								local poz = {x = v1.x + v2.pos.x, y = v1.y + v2.pos.y, w = v2.pos.w}
								mp.options[v.name][v1.name][v2.name][4] = Draw:Button(v2.name, poz.x, poz.y, poz.w, tabz[k])
								mp.options[v.name][v1.name][v2.name][3] = {poz.x, poz.y, poz.w}
							else
								mp.options[v.name][v1.name][v2.name][4] = Draw:Button(v2.name, v1.x + 8, v1.y + y_pos, v1.width - 16, tabz[k])
								mp.options[v.name][v1.name][v2.name][3] = {v1.x + 7, v1.y + y_pos - 1, v1.width - 16}
								y_pos += 38
							end
							mp.options[v.name][v1.name][v2.name][1] = false
							mp.options[v.name][v1.name][v2.name][2] = v2.type
						elseif v2.type == "image" then
							mp.options[v.name][v1.name][v2.name] = {}
							mp.options[v.name][v1.name][v2.name][1] = Draw:ImageWithText(v2.size, nil, v2.text, v1.x + 8, v1.y + y_pos, tabz[k])
							mp.options[v.name][v1.name][v2.name][2] = v2.type
						end
					end
				end
			end
		end
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

	function mp:set_menu_color(r, g, b)
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


	mp.loadbuttonpressed = false
	mp.loadbuttontick = 0
	function mp:setvals()
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
							if v2[5][2] == "single colorpicker" then
								v2[5][4][1].Color = RGB(v2[5][1][1], v2[5][1][2], v2[5][1][3])
								for i = 2, 3 do
									v2[5][4][i].Color = RGB(v2[5][1][1] - 40, v2[5][1][2] - 40, v2[5][1][3] - 40)
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
					end
				end
			end
		end
	end

	local simpcfgnamez = {"toggle", "slider", "dropbox"}
	local function buttonpressed(bp)
		if bp == mp.options["Main"]["Options"]["Exit"] then
			mp.unloaded = true
			mp.loadbuttonpressed = true
			mp.loadbuttontick = tick()
		end
		if bp == mp.options["Main"]["Options"]["Load"] then
			if mp:getval("Settings", "Configuration", "Custom FPS Cap") then
				setfpscap(mp:getval("Settings", "Configuration", "FPS Cap"))
				getgenv().maxfps = mp:getval("Settings", "Configuration", "FPS Cap")
			end
			mp.loadbuttonpressed = true
			mp.loadbuttontick = tick()
		end
		if bp == mp.options["Settings"]["Configuration"]["Save Settings"] then
			local figgy = "BitchBot v2\nmade with <3 from Nate, Bitch, and Classy Code\n\n"
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
			writefile("bitchbot/settings.bb", figgy)
		end
		if bp == mp.options["Settings"]["Configuration"]["Reset Settings"] then
			local opts = mp.options["Settings"]["Configuration"]
			opts["Custom FPS Cap"][1] = false
			opts["FPS Cap"][1] = 60
			opts["Auto Load"][1] = false
			opts["Auto Load Time"][1] = 10
			opts["Loader Accent"][1] = false
			opts["Loader Accent"][5][1] = {127, 72, 163}
			mp:setvals()
			mp.mc = {127, 72, 163}
			mp:set_menu_color(127, 72, 163)
		end
	end

	local function mousebutton1downfunc()
		if mp.open and mp.autoload then 
			if mp.autoloadtimeleft ~= 0 then
				mp.autoload = false
			end
		end

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
					if v2[2] == "toggle" then
						if v2[5] ~= nil then
							if v2[5][2] == "single colorpicker" then
								if v2[5][5] == true then
									if not mp:mouse_in_colorpicker(0, 0, cp.w, cp.h) then
										set_colorpicker(false, {255, 0, 0}, nil, false, "hahaha", 400, 200)
										v2[5][5] = false
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
							elseif v2[2] == "button" and not dropboxopen then
								if mp:mouse_in_menu(v2[3][1], v2[3][2], v2[3][3], 30) then
									if not v2[1] then
										buttonpressed(v2)
										for i = 0, 12 do
											v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(35, 35, 35)}, [2] = {start = 12, color = RGB(50, 50, 50)}})
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
		if mp.tabnum2str[mp.activetab] == "Settings" then
			if mp.options["Settings"]["Configuration"]["Loader Accent"][1] then
				local clr = mp.options["Settings"]["Configuration"]["Loader Accent"][5][1]
				mp.mc = {clr[1], clr[2], clr[3]}
			else
				mp.mc = {127, 72, 163}
			end
			mp:set_menu_color(mp.mc[1], mp.mc[2], mp.mc[3])
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
							for i = 0, 12 do
								v2[4][i + 1].Color = math.ColorRange(i, {[1] = {start = 0, color = RGB(50, 50, 50)}, [2] = {start = 12, color = RGB(35, 35, 35)}})
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

	mp:setmenutransparency(0)
	mp:setmenuvisibility(false)
	mp.open = false

	mp.autoloadonce = true
	mp.loadactivated = false
	local function renderSteppedMenu()
		---------------------------------------------------------------------i pasted the old menu working ingame shit from the old source nate pls fix ty
		-----------------------------------------------this is the really shitty alive check that we've been using since day one
		-- removed it :DDD
		if mp.loadbuttonpressed then
			if mp.loadbuttontick + 0.2 < tick() and not mp.loadactivated then
				mp.loadactivated = true
				mp.fading = true
				mp.fadestart = tick()
			end
		end

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
					if not mp.unloaded then
						--ANCHOR loader shit here, load strings and stuff
					end
					mp:unload()
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
					if mp.autoload then
						mp.autoloadendtime = tick() + mp:getval("Settings", "Configuration", "Auto Load Time")
					end
				else
					mp:setmenutransparency(fade_amount)
				end
			end
		end
		
		if mp == nil then return end

		if mp.open then
			if mp.autoload then
				mp.autoloadtimeleft = math.ceil(mp.autoloadendtime - tick())
				if mp.autoloadtimeleft < 0 then -- didnt do less then equals cuz it looks nicer this way
					mp.options["Main"]["Info"]["Cheat Info"][1][1].Text = mp.loadertext.. "\n\nAuto Loading Now"

					if mp.autoloadonce then
						if mp:getval("Settings", "Configuration", "Custom FPS Cap") then
							setfpscap(mp:getval("Settings", "Configuration", "FPS Cap"))
						end
						mp.loadbuttonpressed = true
						mp.loadbuttontick = tick()
						mp.autoloadonce = false
					end
				elseif mp.autoloadtimeleft == 0 then -- did this cuz it kept showing -0 instead of 0
					mp.options["Main"]["Info"]["Cheat Info"][1][1].Text = mp.loadertext.. "\n\nAuto Loading in 0s\nClick anywhere to stop"
				else 
					mp.options["Main"]["Info"]["Cheat Info"][1][1].Text = mp.loadertext.. "\n\nAuto Loading in ".. tostring(mp.autoloadtimeleft).. "s\nClick anywhere to stop"
				end
			else
				mp.options["Main"]["Info"]["Cheat Info"][1][1].Text = mp.loadertext
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

mp.loaderinfo = {
	username = "\%s",
	updated = "10/20/2020",
	ver = "2.0",
	expires = "Never",
	status = "Undetected",
	gamename = "Universal",
	image = nil
}

mp.loadertext = "Welcome, ".. mp.loaderinfo.username.. "!\n"..mp.loaderinfo.gamename .." \nVer: ".. mp.loaderinfo.ver.. "\nUpdated: ".. mp.loaderinfo.updated.. "\nExpires: ".. mp.loaderinfo.expires.. "\nStatus: ".. mp.loaderinfo.status

mp.BBMenuInit({
	{
		name = "Main",
		content = {
			{
				name = "Info",
				x = 17,
				y = 66,
				width = 316,
				height = 150,
				content = {
					{
						type = "image",
						name = "Cheat Info",
						text = mp.loadertext,
						size = 114
					}
				}
			},
			{
				name = "Options",
				x = 17,
				y = 222,
				width = 316,
				height = 62,
				content = {
					{
						type = "button",
						name = "Load",
						pos = {
							x = 8,
							y = 24,
							w = 147
						}
					},
					{
						type = "button",
						name = "Exit",
						pos = {
							x = 161,
							y = 24,
							w = 147
						}
					},
				}
			},
		}
	},
	{
		name = "Settings",
		content = {
			{
				name = "Configuration",
				x = 17,
				y = 66,
				width = 316,
				height = 218,
				content = {
					{
						type = "toggle",
						name = "Custom FPS Cap",
						value = false,
					},
					{
						type = "slider",
						name = "FPS Cap",
						value = 60,
						minvalue = 60,
						maxvalue = 300,
						stradd = "fps",
					},
					{
						type = "toggle",
						name = "Auto Load",
						value = false,
					},
					{
						type = "slider",
						name = "Auto Load Time",
						value = 10,
						minvalue = 5,
						maxvalue = 15,
						stradd = "s",
					},
					{
						type = "toggle",
						name = "Loader Accent",
						value = false,
						extra = {
							type = "single colorpicker",
							name = "Accent Color",
							color = {127, 72, 163}
						}
					},
					{
						type = "button",
						name = "Save Settings",
						pos = {
							x = 8,
							y = 180,
							w = 147
						}
					},
					{
						type = "button",
						name = "Reset Settings",
						pos = {
							x = 161,
							y = 180,
							w = 147
						}
					},
				}
			}
		}
	}
})

local loadedcfg = readfile("bitchbot/settings.bb")
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
end

mp:setvals()
if mp:getval("Settings", "Configuration", "Loader Accent") then
	local clr = mp:getval("Settings", "Configuration", "Loader Accent", "color")
	mp:set_menu_color(clr[1], clr[2], clr[3])
end

if mp:getval("Settings", "Configuration", "Auto Load") then
	mp.autoload = true
end

mp.fading = true
mp.fadestart = tick()
