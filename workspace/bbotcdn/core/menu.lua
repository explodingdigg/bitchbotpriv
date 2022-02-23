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
local menu = {}

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

return menu