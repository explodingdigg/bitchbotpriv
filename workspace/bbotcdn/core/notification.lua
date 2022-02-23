local gui = BBOT.gui
local hook = BBOT.hook
local menu = BBOT.menu
local config = BBOT.config
local math = BBOT.math
local draw = BBOT.draw
local font = BBOT.font
local notification = {
    registry = {} -- contains all active notifications
}

do
    local meta = {}
    notification.meta = meta

    function meta:Cache(object)
        self.objects[#self.objects+1] = object
        return object
    end

    function meta:Init()
        local border = draw:Create("Rect", "2V")
        border.Color = gui:GetColor("Border")
        border.Filled = true
        border.XAlignment = XAlignment.Right
        border.YAlignment = YAlignment.Bottom

        local outline = draw:Clone(border)
        outline.Color = gui:GetColor("Outline")

        local background = draw:Clone(border)
        background.Color = gui:GetColor("Background")

        local asthetic_line_outline = draw:Clone(outline)
        local asthetic_line = draw:Clone(outline)

        local accent = gui:GetColor("Accent")
        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            accent = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
        end

        asthetic_line.Color = accent

        local hue, saturation, darkness = Color3.toHSV(accent)
        darkness = darkness / 2

        local asthetic_line_dark = draw:Clone(outline)
        asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)

        self.background_border = self:Cache(border)
        self.background_outline = self:Cache(outline)
        self.background = self:Cache(background)
        self.asthetic_line_outline = self:Cache(asthetic_line_outline)
        self.asthetic_line_dark = self:Cache(asthetic_line_dark)
        self.asthetic_line = self:Cache(asthetic_line)

        local gradient = draw:Create("Gradient", "2V")
        gradient.XAlignment = XAlignment.Right
        gradient.YAlignment = YAlignment.Bottom
        gradient.ColorUpperLeft = Color3.fromRGB(50,50,50)
        gradient.ColorUpperRight = Color3.fromRGB(50,50,50)
        gradient.ColorBottomLeft = Color3.fromRGB(35,35,35)
        gradient.ColorBottomRight = Color3.fromRGB(35,35,35)

        gradient.OpacityUpperLeft = 1
        gradient.OpacityUpperRight = 1
        gradient.OpacityBottomLeft = 1
        gradient.OpacityBottomRight = 1

        self.gradient = self:Cache(gradient)

        local text = draw:Create("Text", "2V")
        text.Outlined = true
        text.XAlignment = XAlignment.Right
        text.YAlignment = YAlignment.Bottom
        text.TextXAlignment = XAlignment.Left
        text.OutlineColor = Color3.fromRGB(0,0,0)
        text.OutlineThickness = 1
        text.Font = font:GetFont(font:GetDefault())
        text.Size = 16
        font:AddToManager(text, "Menu.BodyMedium")
        self.text = self:Cache(text)
    end

    hook:Add("OnAccentChanged", "BBOT:Nofitication.Accent", function(accent)
        local registry = notification.registry
        local hue, saturation, darkness = Color3.toHSV(accent)
        darkness = darkness / 2
        local dark_accent = Color3.fromHSV(hue, saturation, darkness)
        for i=1, #registry do
            local v = registry[i]
            v.asthetic_line.Color = accent
            v.asthetic_line_dark.Color = dark_accent
        end
    end)

    function meta:Setup(text, color, time)
        self.text.Color = color
        self.text.Text = text
        self.content = text
        self.starttime = tick()
        self.endtime = tick() + (time or 7)
        
        local vec = self.text.Font:GetTextBounds(self.text.Size, self.content)
        self.size = Vector2.new(10 + vec.X, vec.Y + 2)

        -- linear interpolation
        local registry = notification.registry
        local Y_Offset = 0
        for i=1, #registry do
            local v = registry[i]
            Y_Offset = Y_Offset + v.size.Y + 8
        end
        self.pos = Vector2.new(0, Y_Offset + 10 + 20 + 6) - Vector2.new(self.size.X + 8, 0)
        
        self:Step(self.pos.Y, 1)
    end

    function meta:SetType(type)
        self.type = type
    end

    local v1, v2, v3 = Vector2.new(1,1), Vector2.new(2,2), Vector2.new(4,4)
    local v0 = Vector2.new()
    function meta:Step(offset, deltatime)
        local vec = self.text.TextBounds
        self.size = Vector2.new(10 + vec.X, vec.Y + 2)
        local size = self.size

        -- animations
        local t = tick()
        local pos = Vector2.new(1, offset) + Vector2.new(51, 11 + 20 + 6)
        local fraction = math.timefraction(self.starttime, self.endtime, t)
        local tend = self.endtime - t
        local tstart = t - self.starttime
        if tstart < .5 then -- ease in
            local scale = math.clamp(tstart/.5, 0, 1)
            for i=1, #self.objects do
                local v = self.objects[i]
                if draw:IsValid(v) then
                    v.Opacity = scale
                    v.OutlineOpacity = scale
                end
            end
        elseif tend < .5 then -- ease out
            local scale = math.clamp((.5-tend)/.5, 0, 1)
            for i=1, #self.objects do
                local v = self.objects[i]
                if draw:IsValid(v) then
                    v.Opacity = 1-scale
                    v.OutlineOpacity = 1-scale
                end
            end
        else
            for i=1, #self.objects do
                local v = self.objects[i]
                if draw:IsValid(v) then
                    v.Opacity = 1
                    v.OutlineOpacity = 1
                end
            end
        end

        self.pos = math.lerp(deltatime*7, self.pos, pos)
        pos = self.pos

        self.text.Offset = pos + Vector2.new(7,0)
        self.background_border.Offset = pos - v2
        self.background_outline.Offset = pos - v1
        self.background.Offset = pos
        self.background_border.Size = size + v3
        self.background_outline.Size = size + v2
        self.background.Size = size

        self.asthetic_line.Offset = pos + Vector2.new(1, 0)
        self.asthetic_line.Size = Vector2.new(1, size.Y)
        self.asthetic_line_dark.Offset = pos + Vector2.new(2, 0)
        self.asthetic_line_dark.Size = Vector2.new(1, size.Y)
        self.asthetic_line_outline.Offset = pos
        self.asthetic_line_outline.Size = Vector2.new(5, size.Y)

        self.gradient.Offset = pos + Vector2.new(5,0)
        self.gradient.Size = Vector2.new(size.X-5, 15)

        if self.type == "error" then
            local alert_color = Color3.fromHSV(0, 1, (math.sin(t * 6)+1)/2)
            self.asthetic_line.Color = alert_color
            local hue, saturation, darkness = Color3.toHSV(alert_color)
            darkness = darkness / 2
            local dark_accent = Color3.fromHSV(hue, saturation, darkness)
            self.asthetic_line_dark.Color = dark_accent
        elseif self.type == "alert" then
            local alert_color = Color3.fromHSV(42.5/255, 1, (math.sin(t * 6)+1)/2)
            self.asthetic_line.Color = alert_color
            local hue, saturation, darkness = Color3.toHSV(alert_color)
            darkness = darkness / 2
            local dark_accent = Color3.fromHSV(hue, saturation, darkness)
            self.asthetic_line_dark.Color = dark_accent
        end
    end

    function meta:Remove()
        font:RemoveFromManager(self.text, "Menu.BodyMedium")
        for i=1, #self.objects do
            local v = self.objects[i]
            if draw:IsValid(v) then
                v:Remove()
            end
        end
    end
end

function notification:Create(message, duration)
    local construct = setmetatable({
        objects = {}
    }, {
        __index = self.meta
    })

    construct:Init()
    construct:Setup(message, Color3.new(1,1,1), duration)

    self.registry[#self.registry+1] = construct

    return construct
end

hook:Add("RenderStepped", "BBOT:Notification.Process", function(deltatime)
    local registry = notification.registry
    local t = tick()
    local Y_Offset, c = 0, 0
    for i=1, #registry do
        local v = registry[i-c]
        local timefrac = math.timefraction(v.starttime, v.endtime, t)
        if timefrac > 1 then
            table.remove(registry, i-c)
            c=c+1
            v:Remove()
            continue
        end
        v:Step(Y_Offset, deltatime)
        Y_Offset = Y_Offset + v.size.Y + 8
    end
end)

return notification