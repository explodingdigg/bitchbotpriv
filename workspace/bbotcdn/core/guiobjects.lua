local timer = BBOT.timer
local config = BBOT.config
local math = BBOT.math
local hook = BBOT.hook
local table = BBOT.table
local color = BBOT.color
local font = BBOT.font
local string = BBOT.string
local draw = BBOT.draw
local gui = BBOT.gui
local camera = BBOT.service:GetService("CurrentCamera")
local userinputservice = BBOT.service:GetService("UserInputService")
local v1, v2, v3 = Vector2.new(1,1), Vector2.new(2,2), Vector2.new(4,4)
local function default_panel_borders(self, pos, size)
    self.background_border.Offset = pos - v2
    self.background_outline.Offset = pos - v1
    self.background.Offset = pos
    self.background_border.Size = size + v3
    self.background_outline.Size = size + v2
    self.background.Size = size
end

local function default_panel_objects(self)

    -- create a rect with a Vector2 based point
    local border = draw:Create("Rect", "2V")
    border.Color = gui:GetColor("Border")
    border.Filled = true
    border.XAlignment = XAlignment.Right
    border.YAlignment = YAlignment.Bottom

    -- Clone from border (only properties not point data)
    local outline = draw:Clone(border)
    outline.Color = gui:GetColor("Outline")

    -- Clone again...
    local background = draw:Clone(border)
    background.Color = gui:GetColor("Background")

    self.background_border = self:Cache(border)
    self.background_outline = self:Cache(outline)
    self.background = self:Cache(background)
end

local function default_gradient(self)
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

    return gradient
end

-- enums
local enums = Enum.KeyCode:GetEnumItems()
local enumstable, enumtoID, IDtoenum = {}, {}, {}
for k, v in table.sortedpairs(enums) do
    local keyname = string.sub(tostring(v), 14)
    if not string.find( keyname, "World", 1, true ) then
        enumstable[#enumstable+1] = keyname
        enumtoID[keyname] = v
        IDtoenum[v] = keyname
    end
end

enumstable[#enumstable+1] = "MouseButton1"
enumtoID["MouseButton1"] = Enum.UserInputType.MouseButton1
IDtoenum[Enum.UserInputType.MouseButton1] = "MouseButton1"
enumstable[#enumstable+1] = "MouseButton2"
enumtoID["MouseButton2"] = Enum.UserInputType.MouseButton2
IDtoenum[Enum.UserInputType.MouseButton2] = "MouseButton2"
local enum_KeyCodes = {
    inverseId = IDtoenum,
    Id = enumtoID,
    List = enumstable
}

-- Box
do
    local GUI = {}
    function GUI:Init()
        default_panel_objects(self)
        self:SetMouseInputs(false)
    end
    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
    end
    gui:Register(GUI, "Box")
end

-- Mouse
do
    local GUI = {}

    function GUI:Init()
        if gui.mouse then
            gui.mouse:Remove()
        end
        gui.mouse = self
        self.mouse_mode = "normal"
        self.mouse_controller = draw:CreatePoint("Mouse")
        self:SetupMouse()
        self:SetZIndex(1000000)
        self:SetMouseInputs(false)

        local text = gui:Create("Text", self)
        text:SetPos(1,12,1,45)
        text:SetClipping(false)
        text:SetXAlignment(XAlignment.Right)
        text:SetYAlignment(YAlignment.Bottom)
        text:SetTextSize(16)
        text:SetText("?")
        text:SetOpacity(0)
        self.questionmark = text
    end

    function GUI:SetupMouse()
        local pos = self.absolutepos
        -- cache is a garbage collector for the draw library
        local mouse, mouse_outline

        mouse = draw:Create("PolyLine", "Offset", "Offset", "Offset", "Offset")
        mouse.Color = Color3.fromRGB(127, 72, 163)
        mouse.FillType = PolyLineFillType.ConvexFilled
        for i=1, #mouse.points do
            local point = mouse.points[i]
            point.Point = self.mouse_controller.point
        end

        mouse.Offset1 = Vector2.new(2, 2)
        mouse.Offset2 = Vector2.new(2, 15)
        mouse.Offset3 = Vector2.new(6, 11)
        mouse.Offset4 = Vector2.new(11, 11)

        mouse_outline = draw:Create("PolyLine", "Offset", "Offset", "Offset", "Offset")
        mouse_outline.FillType = PolyLineFillType.Closed
        for i=1, #mouse_outline.points do
            local point = mouse_outline.points[i]
            point.Point = self.mouse_controller.point
        end
        mouse_outline.Color = Color3.new(0,0,0)
        mouse_outline.ZIndex = mouse.ZIndex + 1

        mouse_outline.Offset1 = Vector2.new(1, 1)
        mouse_outline.Offset2 = Vector2.new(1, 16)
        mouse_outline.Offset3 = Vector2.new(6, 11)
        mouse_outline.Offset4 = Vector2.new(11, 11)

        self.mouse = self:Cache(mouse)
        self.mouse_outline = self:Cache(mouse_outline)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.mouse.Color = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.mouse.Color = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:SetMode(mode)
        self.mouse_mode = mode
        self:Destroy()
        self:SetupMouse()
        self:InvalidateLayout()
    end

    do
        local offset = Vector2.new(0,36)
        local selectable = Vector2.new(6,6)
        local pointa, pointb, pointc = Vector2.new(0, 0), Vector2.new(0, 15), Vector2.new(10, 10)
        function GUI:PerformLayout(pos, size)
            -- Calculate position and size changes here
            -- none cause of point system... :D
        end
    end

    local mouse = BBOT.service:GetService("Mouse")
    function GUI:Step()
        -- Step is equivilant to RenderStepped
        local ishoverobj = gui:IsHoveringAnObject()
        if ishoverobj ~= self.ishoverobject then
            if ishoverobj then
                self:SetOpacity(1)
            else
                self:SetOpacity(0)
            end
            self.ishoverobject = ishoverobj
        end

        local objecthover = gui.hovering
        if objecthover ~= self.hoveractive and BBOT.menu.tooltip then
            self.hoveractive = objecthover
            local tip = BBOT.menu.tooltip
            if objecthover and objecthover.tooltip then
                self.questionmark:SetOpacity(1)
                timer:Create("Cursor.ToolTip.QuestionMark", .5, 1, function()
                    if self.hoveractive ~= objecthover then return end
                    gui:OpacityTo(self.questionmark, 0, 1, 0, 0.5, function()
                        if self.hoveractive ~= objecthover then return end
                        tip:SetEnabled(true)
                        tip:SetTip(objecthover, objecthover.tooltip)
                        gui:OpacityTo(tip, 1, 0.5, 0, 0.25)
                    end)
                end)
            else
                timer:Remove("Cursor.ToolTip.QuestionMark")
                self.questionmark:SetOpacity(0)
                gui:OpacityTo(self.questionmark, 0, 0, 0, 0.25)
                gui:OpacityTo(tip, 0, 0.5, 0, 0.25, function()
                    tip:SetEnabled(false)
                end)
            end
        end

        if ishoverobj then
            self.pos = UDim2.new(0, mouse.X, 0, mouse.Y)
            userinputservice.MouseIconEnabled = not self._enabled
            -- Calling calculate will call performlayout & calculate parented GUI objects
            self:Calculate()
        end
    end

    -- Register this as a generatable object
    gui:Register(GUI, "Mouse")
end

-- ToolTip
do
    local GUI = {}
    
    function GUI:Init()
        self:SetMouseInputs(false)
        default_panel_objects(self)

        self.text = gui:Create("Text", self)
        self.text:SetPos(0, 6, .5, -1)
        self.text:SetClipping(false)
        self.text:SetXAlignment(XAlignment.Right)
        self.text:SetYAlignment(YAlignment.Center)
        self.text:SetText(" ")

        self.line = gui:Create("AstheticLine", self)
        self.line:SetPos(0, 1, 0, 1)
        self.line:SetSize(0, 2, 1, -2)
        self.line:SetAlignment("Left")
        
        self:SetOpacity(0)
        self:SetZIndex(900000)
        self.content = "LOL"
    end

    function GUI:SetTip(parent, text)
        local x, y = parent.absolutepos.X, parent.absolutepos.Y + parent.absolutesize.Y + 4
        local w = math.max(200, parent.absolutesize.X)
        self.content = text
        self.text:SetText(text)
        self.scalex, self.scaley = self.text:GetTextSize()
        if self.scalex > 200 then
            self.text:SetText(table.concat(string.WrapText(self.content, self.text.text.Font, self.text.text.Size, w), "\n"))
        end
        self.scalex, self.scaley = self.text:GetTextSize()
        self:SetSize(0, self.scalex+4, 0, self.scaley+4)
        self:SetPos(0, x, 0, y)
        self:Calculate()
        local pos, size = self.absolutepos, self.absolutesize
        if pos.X + size.X > camera.ViewportSize.X then
            local diff = (pos.X + size.X)-(camera.ViewportSize.X-10)
            local x = size.X - diff
            self:SetPos(0, pos.X - x, 0, y)
        end
        if pos.Y + size.Y > camera.ViewportSize.Y then
            local diff = (pos.Y + size.Y)-(camera.ViewportSize.Y-10)
            local y = size.Y - diff
            self:SetPos(0, pos.X, 0, pos.Y-y)
        end
    end

    function GUI:PerformLayout(pos, size)
        self.background.Offset = pos + Vector2.new(1, 1)
        self.background.Size = size - Vector2.new(2, 2)
        self.background_outline.Offset = pos
        self.background_outline.Size = size
        self.background_border.Offset = pos - Vector2.new(1, 1)
        self.background_border.Size = size + Vector2.new(2, 2)
    end

    gui:Register(GUI, "ToolTip")
end

-- Container
do
    local GUI = {}
    function GUI:Init()
        self:SetMouseInputs(false)
    end
    function GUI:PerformLayout(pos, size)
    end
    gui:Register(GUI, "Container")
end

-- AstheticLine
do
    local GUI = {}

    function GUI:Init()
        local background_outline = draw:Create("Rect", "2V")
        background_outline.Color = gui:GetColor("Outline")
        background_outline.Filled = true
        background_outline.XAlignment = XAlignment.Right
        background_outline.YAlignment = YAlignment.Bottom
        self.background_outline = self:Cache(background_outline)

        local asthetic_line = draw:Clone(background_outline)
        asthetic_line.Color = gui:GetColor("Accent")
        self.asthetic_line = self:Cache(asthetic_line)

        local hue, saturation, darkness = Color3.toHSV(gui:GetColor("Accent"))
        darkness = darkness / 2

        local asthetic_line_dark = draw:Clone(background_outline)
        asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)
        self.asthetic_line_dark = self:Cache(asthetic_line_dark)

        self:SetMouseInputs(false)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            self:SetColor(config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent"))
        end

        hook:Add("OnAccentChanged", "Menu.AstheticLine" .. self.uid, function(col, alpha)
            self.asthetic_line.Color = col
            local hue, saturation, darkness = Color3.toHSV(col)
            darkness = darkness / 2
            self.asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)
        end)

        self.alignment = "Top"
    end

    function GUI:SetAlignment(align)
        self.alignment = align
    end

    function GUI:SetColor(col)
        self.asthetic_line.Color = col
        local hue, saturation, darkness = Color3.toHSV(col)
        darkness = darkness / 2
        self.asthetic_line_dark.Color = Color3.fromHSV(hue, saturation, darkness)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu.AstheticLine" .. self.uid)
    end

    function GUI:PerformLayout(pos, size)
        self.asthetic_line.Offset = pos
        self.asthetic_line.Size = size
        local align = self.alignment
        if align == "Left" then
            self.asthetic_line_dark.Offset = pos + Vector2.new(size.X/2, 0)
            self.asthetic_line_dark.Size = Vector2.new(size.X/2, size.Y)
        else
            self.asthetic_line_dark.Offset = pos + Vector2.new(0, size.Y/2)
            self.asthetic_line_dark.Size = Vector2.new(size.X, size.Y/2)
        end
        self.background_outline.Offset = pos - Vector2.new(1,1)
        self.background_outline.Size = size + Vector2.new(2,2)
    end

    gui:Register(GUI, "AstheticLine")
end

-- Panel
do
    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)

        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient) -- 1

        self.asthetic_line = gui:Create("AstheticLine", self)
        self.asthetic_line:SetSize(1, 0, 0, 2)

        self.draggable = false
        self.sizable = false
        self:SetMouseInputs(true)
        self.autofocus = false

        self:Calculate()
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.gradient.Offset = pos + Vector2.new(-1,2)
        self.gradient.Size = Vector2.new(size.X+1, math.min(20, size.Y - 3))
    end

    function GUI:SetSizable(bool)
        self.sizable = bool
    end

    function GUI:SetDraggable(bool)
        self.draggable = bool
    end

    local last_focused = nil
    local mouse = BBOT.service:GetService("Mouse")
    function GUI:InputBegan(input)
        if self.draggable and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            local mousepos = Vector2.new(mouse.X, mouse.Y)
            self.dragging = mousepos
            self.dragging_origin = self:GetLocalTranslation()
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() and self.autofocus then
            if gui:IsValid(last_focused) then
                last_focused:SetFocused(false)
            end
            self:SetFocused(true)
            last_focused = self
        end
    end

    local camera = BBOT.service:GetService("CurrentCamera")
    function GUI:Step()
        if self.dragging then
            local pos = (self.dragging_origin - self.dragging) + Vector2.new(mouse.X, mouse.Y)
            local parent = self.parent
            local X, Y = pos.X, pos.Y
            X = math.max(X, 0)
            Y = math.max(Y, 0)
            local xs, ys = self.pos.X.Scale, self.pos.Y.Scale
            if parent then
                X = math.min(X+self.absolutesize.X, parent.absolutesize.X)-self.absolutesize.X
                Y = math.min(Y+self.absolutesize.Y, parent.absolutesize.Y)-self.absolutesize.Y
                self:SetPos(xs, X - (xs * parent.absolutesize.X), ys, Y - (ys * parent.absolutesize.Y))
            else
                X = math.min(X+self.absolutesize.X, camera.ViewportSize.X)-self.absolutesize.X
                Y = math.min(Y+self.absolutesize.Y, camera.ViewportSize.Y)-self.absolutesize.Y
                self:SetPos(xs, X - (xs * camera.ViewportSize.X), ys, Y - (ys * camera.ViewportSize.Y))
            end
        end

        if self.resizing then
            local pos = Vector2.new(mouse.X, mouse.Y)-self.resizing
            self:SetSize(pos.X, pos.Y)
        end
    end

    function GUI:InputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.dragging then
            self.dragging = nil
        end
    end

    gui:Register(GUI, "Panel")
end

-- Text
do
    local GUI = {}

    function GUI:Init()
        local text = draw:Create("Text", "2V")
        text.Color = Color3.fromRGB(255,255,255)
        text.Outlined = true
        text.OutlineColor = Color3.fromRGB(0,0,0)
        text.OutlineThickness = 1
        text.TextXAlignment = XAlignment.Left
        self.text = self:Cache(text)
        self.font = font:GetDefault()
        self.textsize = 16

        text.Font = font:GetFont(self.font)
        text.Size = self.textsize

        self.content = ""
        self.fontmanager = nil
        self.offset = Vector2.new(0, 0)
        self.clipping = true
        self.clipping_offset = 0
        self.internal_offset = Vector2.new()

        self:SetXAlignment(XAlignment.Right)
        self:SetYAlignment(YAlignment.Bottom)
        self:SetTextXAlignment(XAlignment.Left)
        self:SetTextYAlignment(YAlignment.Top)
        self:SetFontManager("Menu.BodyMedium")
        self.mouseinputs = false
    end

    function GUI:SetClipping(clipping)
        self.clipping = clipping
    end

    function GUI:SetXAlignment(align)
        self.text.XAlignment = align
        self:ProcessClipping()
    end

    function GUI:SetYAlignment(align)
        self.text.YAlignment = align
        self:ProcessClipping()
    end

    function GUI:SetTextXAlignment(align)
        self.text.TextXAlignment = align
        self.TextXAlignment = align
    end

    function GUI:SetTextYAlignment(align)
        self.TextYAlignment = align
    end

    function GUI:SetFont(font)
        if self.fontmanager then return end
        self.text.Font = font
        self.font = font
        self:ProcessClipping()
    end

    function GUI:SetTextSize(size)
        if self.fontmanager then return end
        self.text.Size = size + 1
        self.textsize = size
        self:ProcessClipping()
    end

    function GUI:OnFontChanged(old, new)
        self:ProcessClipping()
    end

    function GUI:OnFontSizeChanged(old, new)
        self:ProcessClipping()
    end

    function GUI:SetFontManager(manager)
        font:RemoveFromManager(self.text, self.fontmanager)
        font:RemoveFromManager(self, manager)
        if manager then
            font:AddToManager(self.text, manager)
            font:AddToManager(self, manager)
        end
        self.fontmanager = manager
        self:ProcessClipping()
    end

    function GUI:GetText()
        return self.content or ""
    end

    function GUI:SetColor(col)
        self.text.Color = col
    end

    function GUI:SetText(txt)
        self.text.Text = txt
        self.content = txt
        self:ProcessClipping()
    end

    function GUI:GetOffsets()
        local offset_x, offset_y = 0, 0
        local w, h = self:GetTextSize()

        local size = self.absolutesize
        if self.parent and size.X <= 2 then
            size = self.parent.absolutesize
        end

        local extra = self:GetTextScale()
        if self.text.XAlignment == XAlignment.Center then
            offset_x = - (w/2) - (extra/2)
        elseif self.text.XAlignment == XAlignment.Left then
            offset_x = - w - (extra/2)
        elseif self.text.XAlignment == XAlignment.Right then
            offset_x = 0
        end

        if self.text.YAlignment == YAlignment.Center then
            offset_y = -h/2
        elseif self.text.YAlignment == YAlignment.Top then
            offset_y = -h
        end

        self.offset = Vector2.new(offset_x, offset_y)

        offset_x, offset_y = 0, 0

        if self.TextXAlignment == XAlignment.Center then
            offset_x = (size.X/2) - (w/2)
        elseif self.TextXAlignment == XAlignment.Left then
            offset_x = 0
        elseif self.TextXAlignment == XAlignment.Right then
            offset_x = size.X - w
        end

        if self.TextYAlignment == YAlignment.Center then
            offset_y = (size.Y/2) - (h/2)
        elseif self.TextYAlignment == YAlignment.Top then
            offset_y = 0
        elseif self.TextYAlignment == YAlignment.Bottom then
            offset_y = size.Y - h
        end

        self.internal_offset = Vector2.new(offset_x, offset_y)
    end

    function GUI:OnEnabledChanged()
        self:ProcessClipping()
    end

    function GUI:PerformLayout(pos, size, poschanged, sizechanged)
        self:ProcessPosition()
        if not sizechanged then return end
        self:ProcessClipping()
    end

    function GUI:ProcessPosition()
        local clipping_offset = self.clipping_offset
        if self.text.XAlignment == XAlignment.Center then
            clipping_offset = 0
        elseif self.text.XAlignment == XAlignment.Left then
            clipping_offset = -clipping_offset
        elseif self.text.XAlignment == XAlignment.Right then
            clipping_offset = clipping_offset
        end
        self.text.Offset = self.absolutepos + Vector2.new(clipping_offset, 0) + self.internal_offset
    end

    function GUI:ProcessClipping()
        local text = self.content
        local cursize = self.absolutesize
        local useparent = cursize.X <= 2
        local clipping_offset = 0
        if self.content and (self.parent or not useparent) and self.clipping then
            self:GetOffsets()
            local x = self:GetTextSize(self.content)
            local localpos = self:GetLocalTranslation()
            local psize = (useparent and self.parent.absolutesize or cursize)
            local posx = (useparent and localpos.X + self.offset.X or self.offset.X) + self.internal_offset.X
            text = ""
            local pretext = ""
            for i=1, #self.content do
                local v = string.sub(self.content, i, i)
                local incsize = self:GetTextSize(v)
                pretext = pretext .. v
                local prex = self:GetTextSize(pretext .. " ")
                if prex + posx - 4 < psize.X then
                    if prex + posx - 12 < 0 then
                        clipping_offset = clipping_offset + incsize
                    else
                        text = text .. v
                    end
                end
            end
        end
        self.clipping_offset = clipping_offset
        self:ProcessPosition()
        self.text.Text = text
    end

    function GUI:ParentPerformLayout(ppos, psize, poschanged, sizechanged)
        if not sizechanged then return end
        self:ProcessClipping()
    end

    function GUI:GetTextSize(text)
        text = text or self.content
        local font_data, size
        if self.fontmanager then
            font_data, size = font:Get(self.fontmanager)
        else
            font_data, size = font:GetFont(self.font), self.text.Size
        end
        if not font_data then
            return 0, 0
        end
        local vec = font_data:GetTextBounds(size, text)
        return vec.X, vec.Y
    end

    function GUI:GetTextScale()
        local font_data, size
        if self.fontmanager then
            font_data, size = font:Get(self.fontmanager)
        else
            font_data, size = font:GetFont(self.font), self.text.Size
        end
        if not font_data then
            return 0, 0
        end
        local vec = font_data:GetTextBounds(size, "A")
        return vec.X, vec.Y
    end

    gui:Register(GUI, "Text")
end

-- ScrollPanel
do
    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background.Color = gui:GetColor("Accent")
        
        self.color = gui:GetColor("Accent")
        self:SetMouseInputs(true)
        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.color = col
            self.background.Color = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.color = col
            self.background.Color = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
    end

    function GUI:Scrolled()
        local canvas_size = self.parent:GetTall()
        local scroll_position = self.parent:GetTall(self.parent.Y_scroll-1)
        self.heightRatio = self.parent.absolutesize.Y / canvas_size
        self.height = math.max(math.ceil(self.heightRatio * self.parent.absolutesize.Y), 20)

        if self.height/self.parent.absolutesize.Y > 1 then
            self:SetEnabled(false)
        else
            self:SetEnabled(true)
        end

        self:SetSize(0, self.size.X.Offset, self.height/self.parent.absolutesize.Y, -6)
        if (scroll_position/canvas_size) + (self.height/self.parent.absolutesize.Y) > 1 then
            self:SetPos(1, -self.size.X.Offset-1, 1-(self.height/self.parent.absolutesize.Y), 4)
        else
            self:SetPos(1, -self.size.X.Offset-1, scroll_position/canvas_size, 4)
        end
    end

    gui:Register(GUI, "ScrollBar")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)

        self.scrollbar = gui:Create("ScrollBar", self)
        self.scrollbar:SetSize(0,2,0,1)
        self.scrollbar:SetPos(1,-2,0,0)
        self.scrollbar:SetZIndex(10)

        self.canvas = gui:Create("Container", self)
        self.canvas:SetSize(1,0,1,0)

        self.Y_scroll = 0 -- for now this is by object
        self.Y_scroll_delta = 0
        self.Spacing = 2
        self.Padding = 0
        self.lastsize = Vector2.new(0,0)
    end

    function GUI:SetPadding(num) -- Padding is the idents around the panels
        self.Padding = num
        self:PerformOrganization()
    end

    function GUI:SetSpacing(num) -- The spacing in-between panels
        self.Spacing = num
        self:PerformOrganization()
    end

    function GUI:ScrollBarMargin(bool)
        self.scrollbarmargin = bool
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        if size ~= self.lastsize then
            self.lastsize = size
            self:PerformOrganization()
        end
    end

    function GUI:GetCanvas()
        return self.canvas
    end

    function GUI:GetTall(max)
        local children = self.canvas.children
        local max_childs = #children
        max = max or max_childs
        max = math.min(max, max_childs)
        local remainder = max % 1
        local tosearch = max
        if remainder < .5 then tosearch = tosearch + .5 end
        tosearch = math.round(tosearch)
        local y_axis, count, count_children = 0, 0, 0
        while count < tosearch and count_children < max_childs do
            count_children = count_children + 1
            local v = children[count_children]
            if not gui:IsValid(v) then continue end
            if not v:GetVisible() then continue end
            count = count + 1
            local spacing = v.absolutesize.Y + self.Spacing
            if count == tosearch and remainder ~= 0 and remainder ~= 1 then
                spacing = spacing * remainder
            end
            y_axis = y_axis + spacing
        end
        return y_axis
    end

    function GUI:PerformOrganization()
        local max_h = self.absolutesize.Y
        local children = self.canvas.children
        if #children < 1 then return end
        local y_axis = 0

        local count, onpage = 0, 0
        local c = 0
        for i=1, #children do
            local v = children[i]
            if not gui:IsValid(v) then c=c+1 continue end
            if not v:GetVisible() then c=c+1 continue end
            i = i - c
            count = count + 1

            local sizeY = v.absolutesize.Y
            if i >= self.Y_scroll then
                if y_axis + sizeY + self.Spacing <= max_h then
                    onpage = onpage + 1
                end
                y_axis = y_axis + sizeY + self.Spacing
            end
        end

        if self.Y_scroll > count-onpage then
            self.Y_scroll = math.max(0, count-onpage)
            self.Y_scroll_delta = self.Y_scroll
        end

        if self.Y_scroll > count then
            self.Y_scroll = 0
        end

        y_axis = 0
        c = 0

        for i=1, #children do
            local v = children[i]
            if not gui:IsValid(v) then c=c+1 continue end
            local enabled = v:GetEnabled()
            if not v:GetVisible() then
                c=c+1
                if enabled then
                    v:SetEnabled(false)
                end
                continue
            end
            i=i-c
            local sizeY = v.absolutesize.Y

            if i <= self.Y_scroll then
                if enabled then
                    v:SetPos(0, self.Padding+2, 0, -sizeY-4)
                    v:SetEnabled(false)
                end
            else
                if y_axis + sizeY + self.Spacing > max_h then
                    if enabled then
                        v:SetEnabled(false)
                    end
                else
                    if not enabled then
                        v:SetEnabled(true)
                    end
                    v:SetPos(0, self.Padding+2, 0, y_axis + self.Spacing)
                end
                y_axis = y_axis + sizeY + self.Spacing
            end

            if enabled then
                v:SetSize(1, -4-self.Padding*2, 0, sizeY)
            end
        end

        self.scrollbar:Scrolled()

        if self.scrollbarmargin and self.scrollbar:GetEnabled() then
            self.canvas:SetSize(1,-6,1,0)
        else
            self.canvas:SetSize(1,0,1,0)
        end

        self:OnPerformOrganization()

        --self:InvalidateLayout(true, true)
    end

    function GUI:IsAtStart(index)
        return index-1 <= self.Y_scroll
    end

    function GUI:IsAtEnd(index)
        local children = self.canvas.children
        local object = children[index]
        if not object or object.__INVALID then return false end
        local max_h = self.absolutesize.Y
        local lsize = object.absolutesize.Y
        local lpos = object:GetLocalTranslation().Y
        if (lpos + lsize < max_h) and (lpos + lsize*2 > max_h) then
            return true
        end
    end

    function GUI:OnPerformOrganization()

    end

    function GUI:WheelForward()
        if not gui:IsHovering(self) then return end
        self.Y_scroll = math.max(0, self.Y_scroll - 1)
        self:PerformOrganization()
    end

    function GUI:WheelBackward()
        if not gui:IsHovering(self) then return end
        self.Y_scroll = math.min(#self.canvas.children, self.Y_scroll + 1)
        self:PerformOrganization()
    end

    function GUI:Add(object) -- Add GUI objects here to add to the canvas
        object:SetParent(self.canvas)
    end

    gui:Register(GUI, "ScrollPanel")
end

-- Sliding Text
do
    local GUI = {}

    function GUI:Step()
        local w, h = self:GetTextSize()
        local size = self.absolutesize
        if self.parent and size.X <= 2 then
            size = self.parent.absolutesize
        end
        if w + 2 > size.X then
            self:ProcessClipping()
        end
    end

    function GUI:GetOffsets()
        self.super.GetOffsets(self)
        local w, h = self:GetTextSize()
        local size = self.absolutesize
        local object = self
        if self.parent and size.X <= 2 then
            size = self.parent.absolutesize
            object = self.parent
        end

        local sweep = 0
        local wide = size.X
        if wide < w and object:IsAbsoluteHovering() then
            local speed = math.max((w - wide)/50, 1.5)
            sweep = (math.sin(tick() / speed) * (5 + (w - wide)/2))
            if self.text.XAlignment == XAlignment.Left then
                sweep = sweep + ((w-wide)/2) + 4
            elseif self.text.XAlignment == XAlignment.Right then
                sweep = sweep - ((w-wide)/2) - 4
            end
            self.offset = Vector2.new(sweep, self.offset.Y)
        end
        self.sweep = sweep
    end

    function GUI:ProcessPosition()
        self.super.ProcessPosition(self)
        self.text.Offset = self.text.Offset + Vector2.new(self.sweep or 0, 0)
    end

    gui:Register(GUI, "SlidingText", "Text")
end

-- Text Entry
do
    local GUI = {}


    local keyNames = { One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0", LeftBracket = "[", RightBracket = "]", Semicolon = ";", BackSlash = "\\", Slash = "/", Minus = "-", Equals = "=", Backquote = "`", Plus = "+", Multiplaye = "x", Comma = ",", Period = ".", }
    local keymodifiernames = { ["`"] = "~", ["1"] = "!", ["2"] = "@", ["3"] = "#", ["4"] = "$", ["5"] = "%", ["6"] = "^", ["7"] = "&", ["8"] = "*", ["9"] = "(", ["0"] = ")", ["-"] = "_", ["="] = "+", ["["] = "{", ["]"] = "}", ["\\"] = "|", [";"] = ":", ["'"] = '"', [","] = "<", ["."] = ".", ["/"] = "?", }

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")

        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient)

        self.whitelist = {}
        for i=string.byte('A'), string.byte('Z') do
            self.whitelist[string.char(i)] = true
        end
        for k, v in pairs(keyNames) do
            self.whitelist[k] = v
        end

        local text = draw:Create("Text", "2V")
        text.Color = Color3.fromRGB(255,255,255)
        text.ZIndex = 2
        text.Outlined = true
        text.XAlignment = XAlignment.Right
        text.YAlignment = YAlignment.Bottom
        text.TextXAlignment = XAlignment.Left
        text.OutlineColor = Color3.fromRGB(0,0,0)
        text.OutlineThickness = 2
        self.text = self:Cache(text)
        self.font = font:GetDefault()
        self.textsize = 16

        text.Font = font:GetFont(self.font)
        text.Size = self.textsize

        self.content = ""
        self.content_position = 1 -- I like scrolling text
        self.fontmanager = nil
        self.offset = Vector2.new(0, 0)
        self.clipping = true

        local cursor = draw:Create("Rect", "2V")
        cursor.Color = gui:GetColor("Border")
        cursor.Visible = false
        cursor.Filled = true
        cursor.XAlignment = XAlignment.Right
        cursor.YAlignment = YAlignment.Center
        cursor.Color = Color3.fromRGB(127, 72, 163)
        cursor.ZIndex = 4

        local cursor_outline = draw:Clone(cursor)
        cursor_outline.Color = Color3.new(0,0,0)
        cursor_outline.ZIndex = 3

        self.cursor = self:Cache(cursor)
        self.cursor_outline = self:Cache(cursor_outline)


        self.editable = true
        self.highlightable = true
        self.mouseinputs = true
        self.placeholder = ""

        self.input_repeater_start = 0
        self.input_repeater_key = nil
        self.input_repeater_delay = 0
        self.texthighlight = Color3.fromRGB(127, 72, 163)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.texthighlight = col
            self.cursor.Color = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.texthighlight = col
            self.cursor.Color = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:SetPlaceholder(text)
        self.placeholder = text
        if self:GetText() == "" and not self.editing then
            self.text.Text = self.placeholder
        end
    end

    function GUI:SetTextSize(size)
        self.textsize = size
        self.text.Size = size
        self.cursor.Size = Vector2.new(1, size)
    end

    local mouse = BBOT.service:GetService("Mouse")
    function GUI:ProcessClipping()
        if self:GetText() == "" and not self.editing then
            self.text.Text = self.placeholder
        else
            self.text.Text = self:AutoTruncate()
        end
    end

    function GUI:AutoTruncate()
        local position = self.content_position
        local pos, size = self:GetLocalTranslation()
        local scalew = self:GetTextSize()
        if scalew >= size.X then
            local text = ""
            for i=position, #self.content do
                local v = string.sub(self.content, i, i)
                local pretext = text .. v
                local prew = self:GetTextSize(pretext)
                if prew > size.X then
                    return text, position
                end
                text = pretext 
            end
        end
        return string.sub(self.content, position), position
    end

    function GUI:DetermineTextCursorPosition(X)
        local text, offset = self:AutoTruncate()
        local pre, post = "", ""
        for i=1, #text do
            post = post .. string.sub(text, i, i)
            local min = self:GetTextSize(pre)
            min = min + 3
            local max = self:GetTextSize(post)
            max = max + 3

            if X >= min and X <= max then
                return offset + i - 1
            end
            pre = post
        end
        return offset + #text - 1
    end

    function GUI:PerformLayout(pos, size, poschanged, sizechanged)
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = size + Vector2.new(1, 1)
        local w, h = self:GetTextSize(self.content)
        self.text.Offset = Vector2.new(pos.X+3,pos.Y - (h/2) + (size.Y/2))
        self.cursor.Size = Vector2.new(0,size.Y-4)
        self.cursor_outline.Size = Vector2.new(2,size.Y-2)
        default_panel_borders(self, pos, size)
        if sizechanged then
            self:ProcessClipping()
        end
    end

    function GUI:SetValue(value)
        self:SetText(value)
    end
    
    function GUI:OnValueChanged() end

    function GUI:SetEditable(bool)
        self.editable = bool
        if not bool then
            self.editing = nil
            self.text.Color = Color3.fromRGB(255, 255, 255)
            self.cursor.Visible = false
            self.cursor_outline.Visible = false
            self:Cache(self.cursor)
            self:Cache(self.cursor_outline)
        end
    end

    local inputservice = BBOT.service:GetService("UserInputService")
    function GUI:ProcessInput(text, keycode)
        local cursorpos = self.cursor_position
        local rtext = string.sub(text, cursorpos+1)
        local ltext = string.sub(text, 1, cursorpos)
        local set = false
        local enums = enum_KeyCodes
        if keycode == Enum.KeyCode.Backspace then
            ltext = string.sub(ltext, 0, #ltext - 1)
            set = true
        elseif keycode == Enum.KeyCode.Space then
            ltext ..= " "
            set = true
        elseif enums.inverseId[keycode] and self.whitelist[enums.inverseId[keycode]] then
            local key = enums.inverseId[keycode]
            if self.whitelist[key] ~= true then
                key = self.whitelist[key]
            end
            if not inputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                key = string.lower(key)
            elseif keymodifiernames[key] then
                key = keymodifiernames[key]
            end
            ltext ..= key
            set = true
        end
        text = ltext .. rtext
        return text, set, ltext
    end

    function GUI:DetermineFittable()
        local w = self:GetTextScale() -- this is wrong lel...
        return math.round((self.absolutesize.X-18)/w)
    end

    function GUI:InputBegan(input)
        if not self.editable or not self._enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.editing = true
            self.cursor.Visible = true
            self.cursor_outline.Visible = true
            self:Cache(self.cursor)
            self:Cache(self.cursor_outline)
            self.text.Color = self.texthighlight
            self.cursor_position = self:DetermineTextCursorPosition(mouse.X - self.absolutepos.X)
            self:ProcessClipping()
        elseif self.editing then
            if input.UserInputType == Enum.UserInputType.MouseButton1 and (not self:IsHovering() or (input.UserInputType == Enum.UserInputType.Keyboard and input.UserInputType == Enum.KeyCode.Return)) then
                self.editing = nil
                self.text.Color = Color3.fromRGB(255, 255, 255)
                self.cursor.Visible = false
                self.cursor_outline.Visible = false
                self:Cache(self.cursor)
                self:Cache(self.cursor_outline)
                if self:GetText() == "" then
                    self.text.Text = self.placeholder
                end
            elseif input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Left then
                    self.cursor_position -= 1
                    if self.cursor_position < 0 then
                        self.cursor_position = 0
                    end
                    self.input_repeater_start = tick() + .5
                    self.input_repeater_key = input.KeyCode
                elseif input.KeyCode == Enum.KeyCode.Right then
                    self.cursor_position += 1
                    if self.cursor_position > #self.content then
                        self.cursor_position -= 1
                    end
                    self.input_repeater_start = tick() + .5
                    self.input_repeater_key = input.KeyCode
                else
                    local current_text = self:GetText()
                    local original_text = current_text
                    local new_text, success, ltext = self:ProcessInput(current_text, input.KeyCode)
                    if success then
                        self.input_repeater_start = tick() + .5
                        self.input_repeater_key = input.KeyCode
                        self:SetText(new_text)
                        self:OnValueChanged(new_text)
                        self.cursor_position = #ltext
                    end
                end

                local fittable = self:DetermineFittable()
                if self.cursor_position < 4 then
                    self.content_position = 1
                elseif self.cursor_position > self.content_position-1 + fittable then
                    self.content_position = self.cursor_position - fittable
                elseif self.cursor_position-3 < self.content_position-1 then
                    self.content_position = self.cursor_position+1-3
                end
                if self.content_position < 1 then
                    self.content_position = 1
                end
                self:ProcessClipping()
            end
        end
    end

    function GUI:InputEnded(input)
        if self.editing and input.UserInputType == Enum.UserInputType.Keyboard then
            if self.input_repeater_key == input.KeyCode then
                self.input_repeater_key = nil
            end
        end
    end

    function GUI:Step()
        if self.editing then
            local t = tick()
            local text_viewable = string.sub(self.text.Text, 1, (self.cursor_position-(self.content_position-1)))
            local wscale, hscale = self:GetTextSize(text_viewable)
            self.cursor.Opacity = math.sin(t * 8)
            self.cursor_outline.Opacity = self.cursor.Opacity
            self.cursor.Offset = self.absolutepos + Vector2.new(wscale+6, (self.absolutesize.Y)/2)
            self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1,0)
            self:Cache(self.cursor)
            self:Cache(self.cursor_outline)
            if self.input_repeater_key and self.input_repeater_start < t then
                if self.input_repeater_delay < t then
                    self.input_repeater_delay = t + .025
                    if self.input_repeater_key == Enum.KeyCode.Left then
                        self.cursor_position -= 1
                        if self.cursor_position < 0 then
                            self.cursor_position = 0
                        end
                    elseif self.input_repeater_key == Enum.KeyCode.Right then
                        self.cursor_position += 1
                        if self.cursor_position > #self.content then
                            self.cursor_position -= 1
                        end
                    else
                        local current_text = self:GetText()
                        local original_text = current_text
                        local new_text, success, ltext = self:ProcessInput(current_text, self.input_repeater_key)
                        if success then
                            self:SetText(new_text)
                            self:OnValueChanged(new_text)
                            self.cursor_position = #ltext
                        end
                    end
                    local fittable = self:DetermineFittable()
                    if self.cursor_position < 4 then
                        self.content_position = 1
                    elseif self.cursor_position > self.content_position-1 + fittable then
                        self.content_position = self.cursor_position - fittable
                    elseif self.cursor_position-3 < self.content_position-1 then
                        self.content_position = self.cursor_position+1-3
                    end
                    if self.content_position < 1 then
                        self.content_position = 1
                    end
                    self:ProcessClipping()
                end
            end
        end
    end

    gui:Register(GUI, "TextEntry", "Text")
end

-- Drop Box
do
    local GUI = {}

    function GUI:Init()
        self.super.Init(self)
        self.mouseinputs = true
    end

    function GUI:OnClick() end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self:OnClick()
        end
    end

    gui:Register(GUI, "TextButton", "Text")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")

        self.scrollpanel = gui:Create("ScrollPanel", self)
        self.scrollpanel:SetPadding(3)
        self.scrollpanel:SetSpacing(2)
        self.scrollpanel:SetSize(1,0,1,0)
        self.scrollpanel:SetLocalVisible(false)

        self.options = {}
        self.buttons = {}
        self.max_length = 8
        self.Id = 0
        self.selectcolor = Color3.fromRGB(127, 72, 163)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.selectcolor = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.selectcolor = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
    end

    function GUI:SetOptions(options)
        for i=1, #self.buttons do
            local v = self.buttons[i]
            v:Remove()
        end
        self.options = options
        for i=1, #options do
            local v = options[i]
            local button = gui:Create("TextButton")
            self.buttons[#self.buttons+1] = button
            local _, scaley = button:GetTextSize(v)
            button:SetPos(0, 0, 0, 0)
            button:SetSize(1, 0, 0, scaley)
            button:SetText(v)
            function button.OnClick()
                self.parent:SetOption(i)
                self.parent:OnValueChanged(v)
                self.parent:Close()
            end
            self.scrollpanel:Add(button)
        end

        self:SetSize(1, 0, 0, self.scrollpanel:GetTall(8) + 5)
        self.scrollpanel:PerformOrganization()
    end

    function GUI:IsHoverTotal()
        if self:IsHovering() then return true end
        local buttons = self.buttons
        for i=1, #buttons do
            if buttons[i]:IsHovering() then return true end
        end
    end

    function GUI:SetOption(Id)
        self.Id = Id
        local button = self.buttons[Id]
        if not button then return end
        button:SetColor(self.selectcolor)
    end

    gui:Register(GUI, "DropBoxSelection")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")

        local gradient = default_gradient(self)
        gradient.Size = Vector2.new(0,10)
        self.gradient = self:Cache(gradient)

        local text = gui:Create("SlidingText", self)
        self.text = text
        text:SetPos(0, 4, .5, 0)
        text:SetSize(1, 0, 1, 0)
        text:SetXAlignment(XAlignment.Right)
        text:SetYAlignment(YAlignment.Center)
        text:SetText("")

        local dropicon = gui:Create("Text", self)
        self.dropicon = dropicon
        dropicon:SetPos(1, -10, .5, 0)
        dropicon:SetXAlignment(XAlignment.Center)
        dropicon:SetYAlignment(YAlignment.Center)
        dropicon:SetText("-")
        self.mouseinputs = true

        self.Id = 0
        self.options = {}
        self.option = ""
    end

    function GUI:GetOption()
        return self.option, self.Id
    end

    function GUI:SetOption(num)
        local opt = self.options[num]
        if not opt then return end
        self.Id = num
        self.text:SetText(opt)
        self.option = opt
    end

    function GUI:SetValue(value)
        local num = 1
        for i=1, #self.options do
            if self.options[i] == value then
                num = i
                break
            end
        end
        self:SetOption(num)
    end

    function GUI:AddOption(txt)
        self.options[#self.options+1] = txt
    end

    function GUI:SetOptions(options)
        self.options = options
        if self.Id == 0 then return end
        for i=1, #self.options do
            if self.options[i] == self.option then
                self:SetOption(i)
                break
            end
        end
    end

    function GUI:PerformLayout(pos, size)
        self.gradient.Offset = pos + Vector2.new(-1, -1)
        self.gradient.Size = size + Vector2.new(1, 1)
        default_panel_borders(self, pos, size)
    end

    function GUI:OnValueChanged(i) end
    function GUI:OnOpen() end
    function GUI:OnClose() end

    function GUI:Open()
        if self.selection then
            self.selection:Remove()
            self.selection = nil
        end
        self:OnOpen()
        local box = gui:Create("DropBoxSelection", self)
        self.selection = box
        box:SetPos(0,0,1,2)
        box:SetOptions(self.options)
        box:SetOption(self.Id)
        box:SetZIndex(100)
        self.open = true
    end

    function GUI:Close()
        if self.selection then
            self.selection:Remove()
            self.selection = nil
        end
        self.open = false
        self:OnClose()
    end

    function GUI:InputBegan(input)
        if not self._enabled then return end
        if not self.open and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self:Open()
        elseif self.open and (not self.selection or not self.selection:IsHoverTotal()) then
            self:Close()
        end
    end

    gui:Register(GUI, "DropBox")
end

-- Combo Box
do 
    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")

        self.scrollpanel = gui:Create("ScrollPanel", self)
        self.scrollpanel:SetPadding(3)
        self.scrollpanel:SetSpacing(2)
        self.scrollpanel:SetSize(1,0,1,0)
        self.scrollpanel:SetLocalVisible(false)

        self.options = {}
        self.buttons = {}
        self.Id = 0
        self.selectcolor = Color3.fromRGB(127, 72, 163)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.selectcolor = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.selectcolor = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
    end

    function GUI:SetOptions(options)
        for i=1, #self.buttons do
            local v = self.buttons[i]
            v:Remove()
        end
        local offset = 0
        self.options = options
        for i=1, #options do
            local v = options[i]
            local button = gui:Create("TextButton", self)
            self.buttons[#self.buttons+1] = button
            local _, scaley = button:GetTextSize(v[1])
            button:SetPos(0, 0, 0, 0)
            button:SetSize(1, 0, 0, scaley)
            button:SetText(v[1])
            button:SetColor(v[2] and self.selectcolor or Color3.new(1,1,1))
            function button.OnClick()
                self.parent:SetOption(i, not v[2])
                button:SetColor(v[2] and self.selectcolor or Color3.new(1,1,1))
            end
            self.scrollpanel:Add(button)
        end
        self:SetSize(1, 0, 0, self.scrollpanel:GetTall(8) + 5)
        self.scrollpanel:PerformOrganization()
    end

    function GUI:IsHoverTotal()
        if self:IsHovering() then return true end
        local buttons = self.buttons
        for i=1, #buttons do
            if buttons[i]:IsHovering() then return true end
        end
    end

    gui:Register(GUI, "ComboBoxSelection")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")
        local gradient = default_gradient(self)
        gradient.Size = Vector2.new(0,10)
        self.gradient = self:Cache(gradient)

        self.textcontainer = gui:Create("Container", self)

        local text = gui:Create("SlidingText", self.textcontainer)
        self.text = text
        text:SetPos(0, 4, .5, 0)
        text:SetSize(1, 0, 1, 0)
        text:SetXAlignment(XAlignment.Right)
        text:SetYAlignment(YAlignment.Center)
        text:SetText("")

        local dropicon = gui:Create("Text", self)
        self.dropicon = dropicon
        dropicon:SetPos(1, -2, .5, 0)
        dropicon:SetClipping(false)
        dropicon:SetXAlignment(XAlignment.Left)
        dropicon:SetYAlignment(YAlignment.Center)
        dropicon:SetText("...")
        local w = dropicon:GetTextSize()
        self.textcontainer:SetSize(1, -w - 12, 1, 0)
        self.mouseinputs = true

        self.options = {}
    end

    function GUI:GetOptions()
        return self.option, self.Id
    end

    function GUI:Refresh()
        local options = self.options
        local text = ""
        local c = 0
        for i=1, #options do
            local v = options[i]
            if v[2] then
                c = c + 1
                text = text .. (c~=1 and ", " or "") .. v[1]
            end
        end
        self.text:SetText(text)
    end

    function GUI:SetOption(num, value)
        local opt = self.options[num]
        if not opt then return end
        opt[2] = value
        self:OnValueChanged(self.options)
        self:Refresh()
    end

    function GUI:SetOptions(options)
        self.options = table.deepcopy(options)
        self:Refresh()
    end

    function GUI:SetValue(options)
        self:SetOptions(options)
    end

    function GUI:PerformLayout(pos, size)
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = Vector2.new(size.X+1, 11)
        default_panel_borders(self, pos, size)
    end

    function GUI:OnValueChanged() end
    function GUI:OnOpen() end
    function GUI:OnClose() end

    function GUI:Open()
        if self.selection then
            self.selection:Remove()
            self.selection = nil
        end
        self:OnOpen()
        local box = gui:Create("ComboBoxSelection", self)
        self.selection = box
        box:SetPos(0,0,1,2)
        box:SetOptions(self.options)
        box:SetZIndex(100)
        self.open = true
    end

    function GUI:Close()
        if self.selection then
            self.selection:Remove()
            self.selection = nil
        end
        self.open = false
        self:OnClose()
    end

    function GUI:InputBegan(input)
        if not self._enabled then return end
        if not self.open and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self:Open()
        elseif self.open and (not self.selection or not self.selection:IsHoverTotal()) then
            self:Close()
        end
    end

    gui:Register(GUI, "ComboBox")
end

-- Image
do
    local GUI = {}
    local icons = BBOT.icons

    function GUI:Init()
        local image = draw:Create("Image", "2V")
        image.XAlignment = XAlignment.Right
        image.YAlignment = YAlignment.Bottom
        self.image = self:Cache(image)
        self.image_dimensions = Vector2.new(50,50)
        self.image_scale = 1
        self.mouseinputs = false
    end

    function GUI:SetImage(img)
        self.image.Image = img
        self:InvalidateLayout()
    end

    function GUI:SetImageSize(x, y)
        self.image.ImageSize = Vector2.new(x, y)
        self.image_dimensions = Vector2.new(x, y)
        self:InvalidateLayout()
    end

    function GUI:PreserveDimensions(bool)
        self.preservedim = bool
        self:InvalidateLayout()
    end

    function GUI:SetRounding(rounding)
        self.image.Rounding = rounding
        self:InvalidateLayout()
    end

    function GUI:SetIcon(icon)
        local ico = icons:NameToIcon(icon)
        if not ico then return end
        self:SetImage(ico[1])
        self.image_dimensions = self.image.ImageSize
        self:InvalidateLayout()
    end

    function GUI:ScaleToFit(bool)
        self.scaletofit = bool
        self:InvalidateLayout()
    end

    function GUI:SetScale(scale)
        self.image_scale = scale
        self:InvalidateLayout()
    end

    function GUI:PerformLayout(pos, size)
        if self.image and draw:IsValid(self.image) then
            if self.preservedim then
                if self.scaletofit then
                    local scalex, scaley = 1, 1
                    if self.image_dimensions.X < size.X then
                        scalex = size.X/self.image_dimensions.X
                    end
                    if self.image_dimensions.Y < size.Y then
                        scaley = size.Y/self.image_dimensions.Y
                    end
                    if scalex > scaley then
                        scalex = scaley
                    end
                    if scaley > scalex then
                        scaley = scalex
                    end
                    self.image.Size = self.image_dimensions * self.image_scale * Vector2.new(scalex, scaley)
                else
                    self.image.Size = self.image_dimensions * self.image_scale
                end
                self.image.Offset = pos - (self.image.Size/2) + size/2
            else
                self.image.Offset = pos
                self.image.Size = size * self.image_scale
            end
        end
    end

    gui:Register(GUI, "Image")
end

-- Tabs
do
    local GUI = {}

    function GUI:Init()
        self:SetMouseInputs(true)
        default_panel_objects(self)
        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient)

        self.text = gui:Create("Text", self)
        self.text:SetPos(.5, -2, .5, 0)
        self.text:SetClipping(false)
        self.text:SetXAlignment(XAlignment.Center)
        self.text:SetYAlignment(YAlignment.Center)
        self.text:SetText("")
        self.text:SetTextSize(13)

        local s = self
        function self.text:OnFontChanged(old, new)
            self:InvalidateLayout()
            s.controller:CalculateTabs()
        end

        local darken = gui:Create("Container", self)
        darken:SetPos(0,0,0,0)
        darken:SetSize(1,0,1,2)
        darken.background = draw:Create("Rect", "2V")
        function darken:PerformLayout(pos, size)
            self.background.Offset = pos
            self.background.Size = size
        end
        darken.background.Filled = true
        darken.background.Visible = true
        darken.background.Opacity = 1
        darken.background.ZIndex = 0
        darken.background.Color = Color3.new(0,0,0)
        darken.background.XAlignment = XAlignment.Right
        darken.background.YAlignment = YAlignment.Bottom
        darken:Cache(darken.background)
        darken:SetOpacity(.25)
        self.darken = darken
    end

    function GUI:PerformLayout(pos, size)
        self.background_border.Offset = pos - Vector2.new(2,2)
        self.background_outline.Offset = pos - Vector2.new(1,1)
        self.background.Offset = pos
        self.background_border.Size = size + Vector2.new(4,4)
        self.background_outline.Size = size + Vector2.new(2,2)
        if self.parent and self.parent.borderless then
            self.background.Size = size
        else
            self.background.Size = size + (self.activated and Vector2.new(0,4) or Vector2.new())
        end
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = Vector2.new(size.X+1, 21)
    end

    -- :Cache(object, opacity, outlineopacity, zindex, visible)

    function GUI:SetBorderless(bool)
        self.borderless = bool
        if bool then
            self.darken:SetOpacity(0)
            if self.activated then
                if self.icon then
                    self.icon:SetOpacity(1)
                else
                    self.text:SetOpacity(1)
                end
            else
                if self.icon then
                    self.icon:SetOpacity(.5)
                else
                    self.text:SetOpacity(.5)
                end
            end
            self.background_border.Visible = false
            self:Cache(self.background_border, 1, 1, 0, false)
            self.background_outline.Visible = false
            self:Cache(self.background_outline, 1, 1, 0, false)
            self.background.Visible = false
            self:Cache(self.background, 1, 1, 0, false)
            self.gradient.Visible = false
            self:Cache(self.gradient, 1, 1, 0, false)
        else
            if self.icon then
                self.icon:SetOpacity(1)
            else
                self.text:SetOpacity(1)
            end
            if self.activated then
                self.darken:SetOpacity(0)
            else
                self.darken:SetOpacity(.25)
            end
            self.background_border.Visible = true
            self:Cache(self.background_border, 1, 1, 0, true)
            self.background_outline.Visible = true
            self:Cache(self.background_outline, 1, 1, 0, true)
            self.background.Visible = true
            self:Cache(self.background, 1, 1, 0, true)
            self.gradient.Visible = true
            self:Cache(self.gradient, 1, 1, 0, true)
        end
    end

    function GUI:SetActive(value)
        self.activated = value
        if self.borderless then
            if self.icon then
                gui:OpacityTo(self.icon, (value and 1 or .5), 0.2, 0, 0.25)
            else
                gui:OpacityTo(self.text, (value and 1 or .5), 0.2, 0, 0.25)
            end
        else
            gui:OpacityTo(self.darken, (value and 0 or .25), 0.2, 0, 0.25)
        end
        self:InvalidateLayout()
    end

    function GUI:SetIcon(icon)
        if not icon then return end
        if not self.icon then
            self.icon = gui:Create("Image", self)
            self.icon:SetZIndex(0)
            self.icon:SetSize(1, 0, 1, 0)
            self.text:SetOpacity(0)
        end
        self.icon:PreserveDimensions(true)
        self.icon:ScaleToFit(true)
        self.icon:SetScale(0.75)
        self.icon:SetIcon(icon)
        self.icon_perfered = self.icon.image.Size
    end

    function GUI:SetText(text)
        self.content = text
        self.text:SetText(text)
    end

    function GUI:SetPanel(panel)
        self.panel = panel
    end

    function GUI:InputBegan(input)
        if not self._enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.controller:SetActive(self.Id)
        end
    end

    gui:Register(GUI, "Tab")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)

        local container = gui:Create("Container", self)
        container:SetPos(0,8,0,36+8)
        container:SetSize(1,-16,1,-36-16)
        self.top_margin = 36
        self.container = container

        local tablist = gui:Create("Container", self)
        tablist:SetPos(0,0,0,2)
        tablist:SetSize(1,0,0,36-2)

        local gradient = default_gradient(tablist)
        gradient.Visible = false
        tablist.gradient = tablist:Cache(gradient)

        function tablist:PerformLayout(pos, size)
            self.gradient.Offset = pos + Vector2.new(-1,-1)
            self.gradient.Size = Vector2.new(size.X+1, 21)
        end
        
        self.tablist = tablist

        local background = gui:Create("Container", tablist)
        background:SetPos(0,0,0,0)
        background:SetSize(1,0,1,-1)
        background:SetZIndex(0)
        background.background = draw:Create("Rect", "2V")
        function background:PerformLayout(pos, size)
            self.background.Offset = pos
            self.background.Size = size
        end
        background.background.Filled = true
        background.background.Visible = true
        background.background.Opacity = .25
        background.background.ZIndex = 0
        background.background.XAlignment = XAlignment.Right
        background.background.YAlignment = YAlignment.Bottom
        background.background.Color = Color3.new(0,0,0)
        background:Cache(background.background)

        local line = gui:Create("Container", tablist)
        line:SetPos(0,0,1,-1)
        line:SetSize(1,0,0,1)
        line.background = draw:Create("Rect", "2V")
        function line:PerformLayout(pos, size)
            self.background.Offset = pos
            self.background.Size = size
        end
        line.background.Filled = true
        line.background.Visible = true
        line.background.Color = gui:GetColor("Border")
        line.background.Opacity = 1
        line.background.ZIndex = 0
        line.background.XAlignment = XAlignment.Right
        line.background.YAlignment = YAlignment.Bottom
        line:Cache(line.background)
        self.line = line

        local astheticline = gui:Create("AstheticLine", self)
        astheticline:SetPos(0,0,0,0)
        astheticline:SetSize(1, 0, 0, 2)
        astheticline:SetZIndex(2)

        self.registry = {}
        self.activeId = 0
    end

    function GUI:SetTopBarMargin(margin)
        self.top_margin = margin
        self.container:SetPos(0,8,0,margin+8)
        self.container:SetSize(1,-16,1,-margin-16)
        self.tablist:SetPos(0,0,0,2)
        self.tablist:SetSize(1,0,0,margin-2)
    end

    function GUI:PerformLayout(pos, size, poschanged, sizechanged)
        if self.borderless then
            self.background_border.Offset = pos - Vector2.new(2,2)
            self.background_outline.Offset = pos - Vector2.new(1,1)
            self.background.Offset = pos
            self.background_border.Size = Vector2.new(size.X, self.top_margin) + Vector2.new(4,2)
            self.background_outline.Size = Vector2.new(size.X, self.top_margin) + Vector2.new(2,1)
            self.background.Size = Vector2.new(size.X, self.top_margin)
        else
            self.background_border.Offset = pos - Vector2.new(2,2)
            self.background_outline.Offset = pos - Vector2.new(1,1)
            self.background.Offset = pos
            self.background_border.Size = size + Vector2.new(4,4)
            self.background_outline.Size = size + Vector2.new(2,2)
            self.background.Size = size
        end
        if sizechanged then
            self:CalculateTabs()
        end
    end

    function GUI:SetInnerBorderless(bool)
        self.innerborderless = bool
        if bool then
            self.tablist.gradient.Visible = true
            self.tablist:Cache(self.tablist.gradient, 1, 1, 0, true)
        else
            self.tablist.gradient.Visible = false
            self.tablist:Cache(self.tablist.gradient, 1, 1, 0, false)
        end
    end

    function GUI:SetBorderless(bool)
        self.borderless = bool
        if bool then
            self.container:SetPos(0,0,0,self.top_margin+8)
            self.container:SetSize(1,0,1,-self.top_margin-8)
            self.tablist.borderless = bool
        else
            self.container:SetPos(0,8,0,self.top_margin+8)
            self.container:SetSize(1,-16,1,-self.top_margin-16)
            self.tablist.borderless = bool
        end

        self.tablist:InvalidateLayout(true, true)
    end

    function GUI:GetActive()
        return self.registry[self.activeId]
    end

    function GUI:SizeByContent(bool)
        self.scalebycontent = bool
        self:CalculateTabs()
    end

    function GUI:SetActive(num)
        if self.activeId == num then return end
        local new = self.registry[num]
        if not new then return end
        local active = self:GetActive()
        if active then
            active[1]:SetActive(false)
            local pnl = active[2]
            gui:OpacityTo(active[2], 0, 0.2, 0, 0.25, function()
                pnl:SetEnabled(false)
            end)
        end
        new[1]:SetActive(true)
        new[2]:SetEnabled(true)
        new[2]:InvalidateLayout(true, true)
        gui:OpacityTo(new[2], 1, 0.2, 0, 0.25)
        self.activeId = num
    end

    function GUI:CalculateTabs()
        local r = self.registry
        local l = #r
        local x = 0
        for i=1, l do
            local v = r[i]
            if self.scalebycontent then
                local sizex = v[1].text:GetTextSize() + 12
                v[1]:SetSize(0,sizex,1,-2)
                v[1]:SetPos(0,x,0,0)
                x += sizex
            elseif v[1].icon_perfered then
                local sizex = v[1].icon_perfered.X + 6
                v[1]:SetSize(0,sizex,1,-2)
                v[1]:SetPos(0,x,0,0)
                x += sizex
            else
                v[1]:SetSize(1/l,0,1,-2)
                v[1]:SetPos((1/l)*(i-1),0,0,0)
            end
        end

        if x < self.tablist.absolutesize.X then
            local extra = self.tablist.absolutesize.X - x
            local x = 0
            for i=1, l do
                local v = r[i]
                if v[1].icon_perfered then
                    local sizex = v[1].icon_perfered.X + 6 + (extra/l)
                    v[1]:SetSize(0,sizex,1,-2)
                    v[1]:SetPos(0,x,0,0)
                    x += sizex
                end
            end
        end
    end

    function GUI:Add(name, icon, object)
        object:SetParent(self.container)
        object:SetOpacity(0)
        object:SetEnabled(false)
        local tab = gui:Create("Tab", self.tablist)
        local r = self.registry
        tab.Id = #r+1
        tab.controller = self
        tab:SetText(name)
        tab:SetPanel(object)
        tab:SetIcon(icon)
        tab:SetBorderless(self.innerborderless)
        r[#r+1] = {tab, object}
        self:CalculateTabs()
        if tab.Id == 1 then
            self:SetActive(tab.Id)
        end
        return tab
    end

    gui:Register(GUI, "Tabs")
end

-- Button
do
    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")

        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient)

        self.text = gui:Create("Text", self)
        self.text:SetXAlignment(XAlignment.Center)
        self.text:SetYAlignment(YAlignment.Center)
        self.text:SetPos(.5, 0, .5, -1)
        self.defaultcolor = Color3.new(1,1,1)

        self.confirmation = false
        self.confirmcolor = gui:GetColor("Accent")
        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.confirmcolor = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.confirmcolor = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = Vector2.new(size.X+1, 16)
    end

    function GUI:SetColor(color)
        self.defaultcolor = color
        self.text:SetColor(color)
    end

    function GUI:SetText(txt)
        self.content = txt
        self.text:SetText(txt)
    end

    function GUI:SetConfirmation(txt)
        self.confirmation = txt
    end

    function GUI:OnClick() end

    function GUI:CanClick() return true end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() and self:CanClick() then
            if self.confirmation and not self.confirm then
                self.confirm = true
                self.text:SetText(self.confirmation)
                self.text:SetColor(self.confirmcolor)
                timer:Simple(1, function()
                    if not gui:IsValid(self) then return end
                    self.text:SetText(self.content)
                    self.text:SetColor(self.defaultcolor)
                    self.confirm = nil
                end)
            elseif (not self.confirmation or (self.confirmation and self.confirm)) then
                self:OnClick()
            end
        end
    end

    gui:Register(GUI, "Button")
end

-- Toggle
do
    local GUI = {}

    function GUI:Init()
        self.button = gui:Create("Button", self)
        self.button:SetSizeConstraint("Y")
        self.button:SetSize(1,0,1,0)
        function self.button:PerformLayout(pos, size, poschanged, sizechanged)
            default_panel_borders(self, pos, size)
            self.gradient.Offset = pos + Vector2.new(-1,-1)
            self.gradient.Size = Vector2.new(size.X+1, 9)
            if not sizechanged then return end
            self.parent.text:SetPos(0, self.absolutesize.X + 7, .5, -1)
        end
        self.button:SetMouseInputs(false)

        self.text = gui:Create("Text", self)
        self.text:SetYAlignment(YAlignment.Center)
        self.text:SetPos(0, 0, .5, 0)
        self.text:SetTextSize(13)

        self.toggle = false
        local col = Color3.fromRGB(127, 72, 163)
        self.on = {col, color.darkness(col, .5)}
        self.off = {self.button.gradient.ColorUpperLeft, self.button.gradient.ColorBottomLeft}

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.on = {col, color.darkness(col, .5)}
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.on = {col, color.darkness(col, .5)}
            local colors = self.off
            if self.toggle then
                colors = self.on
            end
            self:SetGradientColor(unpack(colors))
        end)
    end

    function GUI:SetGradientColor(top, bottom)
        self.button.gradient.ColorUpperLeft = top
        self.button.gradient.ColorUpperRight = top
        self.button.gradient.ColorBottomLeft = bottom
        self.button.gradient.ColorBottomRight = bottom
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged","Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:SetText(txt)
        self.text:SetText(txt)
        self:InvalidateLayout()
    end

    function GUI:SetTextColor(col)
        self.text:SetColor(col)
    end
    
    function GUI:PerformLayout(pos, size, poschanged, sizechanged)
    end

    function GUI:OnClick()
        self.toggle = not self.toggle
        local colors = self.off
        if self.toggle then
            colors = self.on
        end
        self:SetGradientColor(unpack(colors))
        self:OnValueChanged(self.toggle)
    end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self:OnClick()
        end
    end

    function GUI:SetValue(value)
        self.toggle = value
        local colors = self.off
        if self.toggle then
            colors = self.on
        end
        self:SetGradientColor(unpack(colors))
    end

    function GUI:OnValueChanged() end

    gui:Register(GUI, "Toggle")
end

-- KeyBind
do
    local GUI = {}
    local keybind_registry = {}

    function GUI:Init()
        local background_border = draw:Create("Rect", "2V")
        background_border.Filled = true
        background_border.Color = gui:GetColor("Border")
        background_border.XAlignment = XAlignment.Right
        background_border.YAlignment = YAlignment.Bottom
        local background = draw:Clone(background_border)
        background.Color = gui:GetColor("Outline")
        self.background_border = self:Cache(background_border)
        self.background = self:Cache(background)

        self.text = gui:Create("Text", self)
        self.text:SetXAlignment(XAlignment.Center)
        self.text:SetYAlignment(YAlignment.Center)
        self.text:SetPos(.5, 0, .5, -1)
        self.text:SetClipping(true)
        self.text:SetTextSize(13)
        self.text:SetText("None")

        self.key = nil
        self.value = false
        self.toggletype = 1
        self.config = {}
        self.name = "KeyBind"

        keybind_registry[#keybind_registry+1] = self
    end

    function GUI:SetToggleType(type)
        self.toggletype = type
    end

    function GUI:SetConfigurationPath(path)
        self.config = path
    end

    function GUI:SetAlias(alias)
        self.name = alias
    end

    function GUI:PostRemove()
        local c = 0
        for i=1, #keybind_registry do
            local v = keybind_registry[i-c]
            if v == self then
                table.remove(keybind_registry, i-c)
                c=c+1
            end
        end
    end

    function GUI:GetRelatedConfig()
        local cfg = table.deepcopy(self.config)
        cfg[#cfg] = nil
        return cfg
    end
    
    function GUI:PerformLayout(pos, size)
        self.background_border.Offset = pos - Vector2.new(1,1)
        self.background.Offset = pos
        self.background_border.Size = size + Vector2.new(2,2)
        self.background.Size = size
    end

    function GUI:InputBegan(input)
        if not self.editting and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.editting = true
            self.text:SetText("...")
        elseif self.editting and input.UserInputType == Enum.UserInputType.MouseButton1 and not self:IsHovering() then
            self.editting = false
            self.key = nil
            self:OnValueChanged(nil)
            self.text:SetText((self.key and (config.enums.KeyCode.inverseId[self.key] or "Unk") or "None"))
        elseif self.editting and input.UserInputType == Enum.UserInputType.Keyboard then
            self.editting = false
            self.key = input.KeyCode
            self.value = false
            local name = config.enums.KeyCode.inverseId[self.key]
            self.text:SetText(name)
            self:OnValueChanged(name)
        end
    end

    function GUI:SetValue(key)
        if key == nil then
            self.key = nil
            self.text:SetText("None")
            return
        end
        local name = key
        key = config.enums.KeyCode.Id[key]
        self.key = key
        self.text:SetText(name)
    end

    function GUI:OnValueChanged() end

    hook:Add("OnConfigChanged", "BBOT:Menu.KeyBinds", function(steps)
        for i=1, #keybind_registry do
            local v = keybind_registry[i]
            local cfg = table.deepcopy(v.config)
            cfg[#cfg] = nil
            local parentoption = config:GetRaw(unpack(cfg))
            local nick = (v.name ~= "KeyBind" and v.name or nil)
            if not nick then
                local cfg = table.deepcopy(v.config)
                cfg[#cfg] = nil
                nick = cfg[#cfg]
            end
            if (typeof(parentoption) == "boolean" and not parentoption) or not v.key then
                BBOT.menu:UpdateStatus(nick, nil, false, v.text:GetText())
            elseif v.toggletype == 4 then
                BBOT.menu:UpdateStatus(nick, nil, true, v.text:GetText())
            else
                local state = BBOT.menu:GetStatus(cfg[#cfg])
                BBOT.menu:UpdateStatus(nick, (state and state[2] or "Disabled"), true, v.text:GetText())
            end
        end
    end)

    hook:Add("InputBegan", "BBOT:Menu.KeyBinds", function(input)
        --if not config:GetValue("Main", "Visuals", "Extra", "Enabled") then return end
        if not BBOT.menu or not BBOT.menu.main or userinputservice:GetFocusedTextBox() or BBOT.menu.main:GetAbsoluteEnabled() then
            return
        end
        for i=1, #keybind_registry do
            local v = keybind_registry[i]
            if input and input.KeyCode == v.key then
                local last = v.value
                if input and input.KeyCode == v.key then
                    if v.toggletype == 2 then
                        v.value = not v.value
                    elseif v.toggletype == 1 then
                        v.value = true
                    elseif v.toggletype == 3 then
                        v.value = false
                    end
                elseif v.toggletype == 4 then
                    v.value = true
                end
                if last ~= v.value or v.toggletype == 4 then
                    local nick = (v.name ~= "KeyBind" and v.name or nil)
                    if not nick then
                        local cfg = table.deepcopy(v.config)
                        cfg[#cfg] = nil
                        nick = cfg[#cfg]
                    end
                    if v.toggletype == 4 then
                        BBOT.menu:UpdateStatus(nick, nil, true)
                    else
                        BBOT.menu:UpdateStatus(nick, (v.value and "Enabled" or "Disabled"), true)
                    end
                    config:GetRaw(unpack(v.config)).toggle = v.value
                    hook:Call("OnKeyBindChanged", v.config, last, v.value, v.toggletype)
                    if v.toggletype == 4 then
                        v.value = false
                    end
                    config:GetRaw(unpack(v.config)).toggle = v.value
                end
            end
        end
    end)

    hook:Add("InputEnded", "BBOT:Menu.KeyBinds", function(input)
        --if not config:GetValue("Main", "Visuals", "Extra", "Enabled") then return end
        if not BBOT.menu.main or userinputservice:GetFocusedTextBox() or BBOT.menu.main:GetAbsoluteEnabled() then
            return
        end
        for i=1, #keybind_registry do
            local v = keybind_registry[i]
            if input and input.KeyCode == v.key then
                local last = v.value
                if input.KeyCode == v.key then
                    if v.toggletype == 1 then
                        v.value = false
                    elseif v.toggletype == 3 then
                        v.value = true
                    end
                end
                if last ~= v.value then
                    local nick = (v.name ~= "KeyBind" and v.name or nil)
                    if not nick then
                        local cfg = table.deepcopy(v.config)
                        cfg[#cfg] = nil
                        nick = cfg[#cfg]
                    end
                    BBOT.menu:UpdateStatus(nick, (v.value and "Enabled" or "Disabled"), true)
                    config:GetRaw(unpack(v.config)).toggle = v.value
                    hook:Call("OnKeyBindChanged", v.config, last, v.value, v.toggletype)
                end
            end
        end
    end)

    --[[local ignorenotify = false
    hook:Add("OnConfigChanged", "BBOT:Menu.KeyBinds.Reset", function(step, old, new)
        if config:IsPathwayEqual(step, "Main", "Visuals", "Extra", "Enabled") then
            if new == false then
                local guis = gui.registry
                for i=1, #guis do
                    local v = guis[i]
                    if gui:IsValid(v) and v.class == "KeyBind" then
                        if v.value ~= true then
                            config:GetRaw(unpack(v.config)).toggle = true
                            ignorenotify = true
                            hook:Call("OnKeyBindChanged", v.config, v.value, true)
                            ignorenotify = false
                            v.value = true
                        end
                    end
                end
            else
                local guis = gui.registry
                for i=1, #guis do
                    local v = guis[i]
                    if gui:IsValid(v) and v.class == "KeyBind" then
                        if v.value ~= false then
                            config:GetRaw(unpack(v.config)).toggle = false
                            ignorenotify = true
                            hook:Call("OnKeyBindChanged", v.config, last, false)
                            ignorenotify = false
                            v.value = false
                        end
                    end
                end
            end
        end
    end)]]

    hook:Add("OnKeyBindChanged", "BBOT:Notify", function(steps, old, new, toggletype)
        if ignorenotify then return end
        
        if config:GetValue("Main", "Visuals", "Extra", "Log Keybinds") and toggletype ~= 4 then
            local name = steps[#steps]
            if name == "KeyBind" then
                name = steps[#steps-1]
            end
            BBOT.notification:Create(name .. " has been " .. (new and "enabled" or "disabled"))
        end
    end)

    gui:Register(GUI, "KeyBind")
end

-- Progress Bar
do
    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient)
        local col = Color3.fromRGB(127, 72, 163)
        self.basecolor = {col, color.darkness(col, .5)}
        self:SetGradientColor(unpack(self.basecolor))
        self.percentage = 0
        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.basecolor = {col, color.darkness(col, .5)}
            self:SetGradientColor(unpack(self.basecolor))
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.basecolor = {col, color.darkness(col, .5)}
            self:SetGradientColor(unpack(self.basecolor))
        end)
    end

    function GUI:SetGradientColor(top, bottom)
        self.gradient.ColorUpperLeft = top
        self.gradient.ColorUpperRight = top
        self.gradient.ColorBottomLeft = bottom
        self.gradient.ColorBottomRight = bottom
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:SetPercentage(perc)
        self.percentage = perc
        self:InvalidateLayout()
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.gradient.Offset = pos + Vector2.new(-1, -1)
        self.gradient.Size = Vector2.new((size.X+1)*self.percentage, size.Y+1)
    end

    gui:Register(GUI, "ProgressBar")
end

-- Slider
do
    local GUI = {}

    local userinputservice = BBOT.service:GetService("UserInputService")

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")
        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient)


        local bar = default_gradient(self)
        self.bar = self:Cache(bar)
        local col = Color3.fromRGB(127, 72, 163)
        self.basecolor = {col, color.darkness(col, .5)}
        self:SetGradientColor(unpack(self.basecolor))
        self.percentage = math.random(0,1000)/1000

        self.buttoncontainer = gui:Create("Container", self)

        local onhover = Color3.fromRGB(127, 72, 163)
        local idle = Color3.new(1,1,1)

        self.add = gui:Create("TextButton", self.buttoncontainer)
        self.add:SetText("+")
        self.add:SetClipping(true)
        self.add:SetTextXAlignment(XAlignment.Right)
        self.add:SetXAlignment(XAlignment.Right)
        self.add:SetYAlignment(YAlignment.Bottom)
        local w, h = 10, 12
        self.add:SetPos(1, -w + 2, 0, 0)
        self.add:SetSize(0, w, 0, h)
        
        function self.add.OnClick()
            local value = 1
            if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                value = value / (10^self.decimal)
            end
            self:_SetValue(self:GetValue()+value)
        end

        function self.add:Step()
            local hover = (self:IsHovering())
            if hover ~= self.hover then
                self.hover = hover
                if hover then
                    self:SetColor(onhover)
                else
                    self:SetColor(idle)
                end
            end
        end

        self.deduct = gui:Create("TextButton", self.buttoncontainer)
        self.deduct:SetText("-")
        self.deduct:SetClipping(false)
        self.deduct:SetTextXAlignment(XAlignment.Right)
        self.deduct:SetXAlignment(XAlignment.Right)
        self.deduct:SetYAlignment(YAlignment.Bottom)
        local ww, hh = 10, 12
        self.deduct:SetPos(1, -w -ww + 2, 0, 0)
        self.deduct:SetSize(0, w, 0, h)
        self.deduct.Step = self.add.Step
        function self.deduct.OnClick()
            local value = 1
            if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
                value = value / (10^self.decimal)
            end
            self:_SetValue(self:GetValue()-value)
        end
        self.buttoncontainer.add = self.add
        self.buttoncontainer.deduct = self.deduct

        self.buttoncontainer:SetSize(0, w + ww, 0, h + 2)
        self.buttoncontainer:SetPos(1, -(w + ww), 0, - (h + 3))
        self.buttoncontainer:SetOpacity(0)

        function self.add:OnFontChanged(old, new)
            self:InvalidateLayout()
            local w, h = self.add.text:GetTextSize()
            self.add:SetPos(1, -w + 2, 0, 0)
            self.add:SetSize(0, w, 0, 8)
            local ww, hh = self.deduct.text:GetTextSize()
            self.deduct:SetPos(1, -w -ww - 2, 0, 0)
            self.deduct:SetSize(0, w, 0, 8)
        end

        function self.add:OnFontSizeChanged(old, new)
            self:InvalidateLayout()
            local w, h = self.add.text:GetTextSize()
            self.add:SetPos(1, -w + 2, 0, 0)
            self.add:SetSize(0, w, 0, 8)
            local ww, hh = self.deduct.text:GetTextSize()
            self.deduct:SetPos(1, -w -ww - 2, 0, 0)
            self.deduct:SetSize(0, w, 0, 8)
        end

        function self.buttoncontainer:Step()
            local hover = (self:IsHovering() or self.add:IsHovering() or self.deduct:IsHovering())
            if hover ~= self.hover then
                self.hover = hover
                if hover then
                    gui:OpacityTo(self, 1, 0.2, 0, 0.25)
                else
                    gui:OpacityTo(self, 0, 0.2, 0, 0.25)
                end
            end
        end

        self.text = gui:Create("Text", self)
        self.text:SetXAlignment(XAlignment.Center)
        self.text:SetYAlignment(YAlignment.Center)
        self.text:SetTextSize(13)
        self.text:SetPos(.5,0,.5,-1)
        self.text:SetText("0%")

        self.suffix = "%"
        self.min = 0
        self.max = 100
        self.decimal = 1
        self.custom = {}
        self.mouseinputs = true

        self:SetPercentage(self.percentage)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            self.basecolor = {col, color.darkness(col, .5)}
            self:SetGradientColor(unpack(self.basecolor))
            onhover = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            self.basecolor = {col, color.darkness(col, .5)}
            self:SetGradientColor(unpack(self.basecolor))
            onhover = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:SetGradientColor(top, bottom)
        self.bar.ColorUpperLeft = top
        self.bar.ColorUpperRight = top
        self.bar.ColorBottomLeft = bottom
        self.bar.ColorBottomRight = bottom
    end

    function GUI:SetPercentage(perc)
        self.percentage = perc
        local value = math.round(math.remap(perc, 0, 1, self.min, self.max), self.decimal)
        if self.custom[value] then
            self.text:SetText(self.custom[value])
        else
            self.text:SetText(value .. self.suffix)
        end
        self.bar.Size = Vector2.new((self.absolutesize.X+1)*self.percentage, self.absolutesize.Y+1)
    end

    function GUI:_SetValue(value)
        self:SetPercentage(math.remap(math.clamp(value, self.min, self.max), self.min, self.max, 0, 1))
        self:OnValueChanged(self:GetValue())
    end

    function GUI:GetValue()
        return math.round(math.remap(self.percentage, 0, 1, self.min, self.max), self.decimal)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = size + Vector2.new(1,1)
        self.bar.Offset = pos + Vector2.new(-1,-1)
        self.bar.Size = Vector2.new((size.X+1)*self.percentage, size.Y+1)
    end

    function GUI:CalculateValue(X)
        local APX = self.absolutepos.X
        local ASX = self.absolutesize.X
        local position = math.clamp(X, APX, APX + ASX )
        local last = self:GetValue()
        self:SetPercentage((position - APX)/ASX)
        local new = self:GetValue()
        if last ~= new then
            self:OnValueChanged(new)
        end
    end

    local mouse = BBOT.service:GetService("Mouse")
    function GUI:Step()
        if self.down then
            self:CalculateValue(mouse.X)
        end
    end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.down = true
        end
    end

    function GUI:InputEnded(input)
        if self.down and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.down = false
        end
    end

    function GUI:SetValue(value)
        self:SetPercentage(math.remap(math.clamp(value, self.min, self.max), self.min, self.max, 0, 1))
    end

    function GUI:OnValueChanged() end

    gui:Register(GUI, "Slider")
end

-- List
do
    do
        local GUI = {}
        function GUI:Init()
            local borderleft = draw:Create("Line", "2V", "2V")
            borderleft.Color = gui:GetColor("Border")
            borderleft.Thickness = 1

            local borderright = draw:Clone(borderleft)
            local bordertop = draw:Clone(borderleft)
            local borderbottom = draw:Clone(borderleft)

            self.borderleft = self:Cache(borderleft)
            self.borderright = self:Cache(borderright)
            self.bordertop = self:Cache(bordertop)
            self.borderbottom = self:Cache(borderbottom)

            self:SetMouseInputs(false)
        end
        function GUI:SetLeftVisible(bool)
            self.borderleft.Visible = bool
            self:Cache(self.borderleft, 1, 1, 0, bool)
        end
        function GUI:SetRightVisible(bool)
            self.borderright.Visible = bool
            self:Cache(self.borderright, 1, 1, 0, bool)
        end
        function GUI:SetTopVisible(bool)
            self.bordertop.Visible = bool
            self:Cache(self.bordertop, 1, 1, 0, bool)
        end
        function GUI:SetBottomVisible(bool)
            self.borderbottom.Visible = bool
            self:Cache(self.borderbottom, 1, 1, 0, bool)
        end
        function GUI:PerformLayout(pos, size)
            self.borderleft.Offset1 = pos + Vector2.new(0,3)
            self.borderleft.Offset2 = pos + Vector2.new(0, size.Y-3)

            self.borderright.Offset1 = pos + Vector2.new(size.X, 3)
            self.borderright.Offset2 = pos + size + Vector2.new(0,-3)

            self.bordertop.Offset1 = pos
            self.bordertop.Offset2 = pos + Vector2.new(size.X, 0)

            self.borderbottom.Offset1 = pos + Vector2.new(0, size.Y)
            self.borderbottom.Offset2 = pos + size
        end
        gui:Register(GUI, "ListContainer")
    end

    local GUI = {}
    local icons = BBOT.icons

    function GUI:Init()
        default_panel_objects(self)
        self:SetMouseInputs(true)

        local gradient = default_gradient(self)
        gradient.ZIndex = 1
        self.gradient = self:Cache(gradient)

        self.title = gui:Create("Text", self)
        self.title:SetXAlignment(XAlignment.Center)
        self.title:SetYAlignment(YAlignment.Center)
        self.title:SetPos(.5,0,.5,-1)
        self.title:SetText("")

        local sort_arrow = draw:Create("Image", "2V")
        sort_arrow.Image = icons:NameToIcon("SORTARROW")[1]
        sort_arrow.Color = Color3.fromRGB(127, 72, 163)
        sort_arrow.Size = sort_arrow.ImageSize
        sort_arrow.XAlignment = XAlignment.Right
        sort_arrow.YAlignment = YAlignment.Center
        sort_arrow.Visible = false
        sort_arrow.ZIndex = 2
        self.sort_arrow = self:Cache(sort_arrow)

        if config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent") then
            local col = config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Menu Accent", "Accent")
            sort_arrow.Color = col
        end

        hook:Add("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid, function(col, alpha)
            sort_arrow.Color = col
        end)
    end

    function GUI:PreRemove()
        hook:Remove("OnAccentChanged", "Menu." .. self.class .. "." .. self.uid)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = Vector2.new(size.X+1, 21)
        local ww, hh = self.title:GetTextSize()
        self.sort_arrow.Offset = pos + (size/2) + Vector2.new((ww/2) + 3, 0)
    end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            local descending = false
            if self.last_sorting == self.position then
                if self.last_decending then
                    descending = false
                else
                    descending = true
                end
            end
            self.parent:ChangeSorting(self.position, descending)
        end
    end

    function GUI:OnSortingChanged(position, descending)
        self.last_sorting = position
        self.last_decending = descending
        if self.position ~= position then
            self.sort_arrow.Visible = false
        elseif descending then
            self.sort_arrow.Visible = true
            self.sort_arrow.Size = Vector2.new(self.sort_arrow.ImageSize.X, -self.sort_arrow.ImageSize.Y)
        else
            self.sort_arrow.Visible = true
            self.sort_arrow.Size = Vector2.new(self.sort_arrow.ImageSize.X, self.sort_arrow.ImageSize.Y)
        end
    end

    gui:Register(GUI, "ListColumn")

    local GUI = {}

    function GUI:Init()
        
    end

    function GUI:PerformLayout(pos, size)

    end

    function GUI:SetTopLineVisible(bool)
        local columns = self.controller.columns
        for i=1, #columns do
            local child = self.children[i]
            local col = columns[i]
            child:SetTopVisible(bool)
        end
    end

    function GUI:SetBottomLineVisible(bool)
        local columns = self.controller.columns
        for i=1, #columns do
            local child = self.children[i]
            local col = columns[i]
            child:SetBottomVisible(bool)
        end
    end

    function GUI:Calibrate()
        local columns = self.controller.columns
        for i=1, #columns do
            local child = self.children[i]
            local col = columns[i]
            child:SetPos(col.pos.X.Scale, 0, 0, 0)
            child:SetSize(col.size.X.Scale, 0, 0, 20)
        end
    end

    function GUI:SetOptions(...)
        local options = {...}
        for i=1, #options do
            local container = gui:Create("ListContainer", self)

            if i == 1 then
                container:SetLeftVisible(false)
            end
            if i == #options then
                container:SetRightVisible(false)
            end

            local row_column = gui:Create("SlidingText", container)
            container.text = row_column
            row_column:SetXAlignment(XAlignment.Right)
            row_column:SetYAlignment(YAlignment.Center)
            row_column:SetPos(0,4,.5,0)
            row_column:SetText(options[i])
        end
        self:Calibrate()
    end

    function GUI:OnClick() end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self:OnClick()
        end
    end

    gui:Register(GUI, "ListRow")

    local GUI = {}

    function GUI:Init()
        self.scrollpanel = gui:Create("ScrollPanel", self)
        self.scrollpanel:SetPos(0,0,0,22)
        self.scrollpanel:SetSize(1,0,1,-22)
        self.scrollpanel:SetPadding(0)
        self.scrollpanel:SetSpacing(0)
        self.scrollpanel.scrollbar:SetZIndex(50)

        function self.scrollpanel:OnPerformOrganization()
            local children = self.canvas.children
            local len = #children
            for i=1, len do
                local v = children[i]
                if self:IsAtStart(i) then
                    v:SetTopLineVisible(false)
                    v:SetBottomLineVisible(true)
                elseif self:IsAtEnd(i) then
                    v:SetTopLineVisible(true)
                    v:SetBottomLineVisible(false)
                else
                    v:SetTopLineVisible(true)
                    v:SetBottomLineVisible(true)
                end
            end
        end

        self.columns = {}
    end

    function GUI:PerformLayout() end

    function GUI:Recalibrate()
        self:RecalibrateColumns()
    end

    function GUI:RecalibrateColumns()
        local columns_len = #self.columns
        if ( columns_len == 0 ) then return end
        local ideal_wide = 1/columns_len

        for i=1, columns_len do
            local v = self.columns[i]
            v:SetPos(ideal_wide*(i-1), 0, 0, 0)
            v:SetSize(ideal_wide, 0, 0, 20)
        end
    end

    function GUI:AddLine(...)
        local row = gui:Create("ListRow")
        row.controller = self
        row:SetOptions(...)
        row:SetSize(1,0,0,20)
        row:SetZIndex(0)
        function row.OnClick(s)
            self:OnSelected(s)
        end
        self.scrollpanel:Add(row)
        if self.sort_position then
            self:ChangeSorting(self.sort_position, self.sort_descending)
        end
        return row
    end

    function GUI:OnSelected(row) end

    function GUI:PerformOrganization()
        self.scrollpanel:PerformOrganization()
    end

    function GUI:AddColumn(name, pos, wide)
        local newcolumn = gui:Create("ListColumn", self)
        newcolumn.title:SetText(name)
        newcolumn.name = name
        newcolumn.position = pos or (#self.columns+1)
        newcolumn.wide = wide
        self.columns[#self.columns+1] = newcolumn
        self:Recalibrate()
        return newcolumn
    end

    function GUI:ChangeSorting(position, descending)
        self.sort_position = position
        self.sort_descending = descending
        table.sort(self.scrollpanel.canvas.children, function(a, b)
            if descending then
                return a.children[position].text:GetText() > b.children[position].text:GetText()
            else
                return a.children[position].text:GetText() < b.children[position].text:GetText()
            end
        end)
        self.scrollpanel:PerformOrganization()
        for i=1, #self.columns do
            self.columns[i]:OnSortingChanged(position, descending)
        end
    end

    gui:Register(GUI, "List")
end

-- Color Picker
do
    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")
        
        --(imagedata, x, y, w, h, transparency, visible)


        local color_fade = draw:Create("Rect", "2V")
        color_fade.Color = Color3.new(0,0,0)
        color_fade.XAlignment = XAlignment.Right
        color_fade.YAlignment = YAlignment.Bottom
        color_fade.Filled = true

        local white_black_fade = draw:Create("Image", "2V")
        white_black_fade.XAlignment = XAlignment.Right
        white_black_fade.YAlignment = YAlignment.Bottom
        white_black_fade.Image = BBOT.menu.images[1]

        local cursor_outline = draw:Clone(color_fade)
        cursor_outline.Filled = false
        cursor_outline.Size = Vector2.new(6,6)
        cursor_outline.Color = Color3.new(0,0,0)

        local cursor = draw:Clone(color_fade)
        cursor.Filled = false
        cursor.Size = Vector2.new(4,4)
        cursor.Color = Color3.new(1,1,1)


        self.color_fade = self:Cache(color_fade)
        self.white_black_fade = self:Cache(white_black_fade)
        self.cursor_outline = self:Cache(cursor_outline)
        self.cursor = self:Cache(cursor)
        self.cursor_position = Vector2.new(2,2)
        self:SetMouseInputs(true)

        --(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
        --[[
            ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
            ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
            ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
        ]]
    end

    function GUI:SetColor(color, transparency)
        local h, s, v = Color3.toHSV(color)
        self.color_fade.Color = Color3.fromHSV(h, 1, 1)
        self.h = h
        self.s = s
        self.v = v
        self.t = transparency
        self.cursor_position = Vector2.new(self.s, 1-self.v) * self.absolutesize
        self:MoveCursor()
    end

    function GUI:MoveCursor()
        self.cursor.Offset = self.absolutepos + self.cursor_position - Vector2.new(2, 2)
        self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1, 1)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.color_fade.Offset = pos
        self.color_fade.Size = size
        self.white_black_fade.Offset = pos - Vector2.new(1,1)
        self.white_black_fade.Size = size + Vector2.new(1,1)
        self:MoveCursor()
    end

    function GUI:CalculateValue(X, Y)
        local APX = self.absolutepos.X
        local ASX = self.absolutesize.X
        local APY = self.absolutepos.Y
        local ASY = self.absolutesize.Y
        local newX = math.clamp(X, APX, APX + ASX )
        local newY = math.clamp(Y, APY, APY + ASY )
        local new_position = Vector2.new(newX-APX, newY-APY)
        self.cursor_position = new_position
        self:MoveCursor()

        -- calculate new color
        self.s = math.clamp(new_position.X/self.absolutesize.X, 0, 1)
        self.v = math.clamp(1-(new_position.Y/self.absolutesize.Y), 0, 1)

        self:OnValueChanged(Color3.fromHSV(self.h, self.s, self.v), self.t)
    end

    local mouse = BBOT.service:GetService("Mouse")
    function GUI:Step()
        if self.down then
            self:CalculateValue(mouse.X, mouse.Y+36)
        end
    end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.down = true
        end
    end

    function GUI:InputEnded(input)
        if self.down and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.down = false
        end
    end

    function GUI:OnValueChanged(color, transparency)
        
    end

    gui:Register(GUI, "ColorPallet")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")
        
        --(imagedata, x, y, w, h, transparency, visible)
        local color_fade = draw:Create("Image", "2V")
        color_fade.XAlignment = XAlignment.Right
        color_fade.YAlignment = YAlignment.Bottom
        color_fade.Image = BBOT.menu.images[3]

        local cursor_outline = draw:Create("Rect", "2V")
        cursor_outline.XAlignment = XAlignment.Right
        cursor_outline.YAlignment = YAlignment.Bottom
        cursor_outline.Color = Color3.new(0,0,0)

        local cursor = draw:Clone(cursor_outline)
        cursor.Color = Color3.new(1,1,1)

        self.color_fade = self:Cache(color_fade)
        self.cursor_outline = self:Cache(cursor_outline)
        self.cursor = self:Cache(cursor)
        self.cursor_position = Vector2.new(2,2)
        self:SetMouseInputs(true)

        --(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
        --[[
            ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
            ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
            ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
        ]]
    end

    function GUI:SetColor(color, transparency)
        local h, s, v = Color3.toHSV(color)
        self.h = h
        self.s = s
        self.v = v
        self.t = transparency
        self.cursor_position = Vector2.new(0, 1-self.h) * self.absolutesize
        self:MoveCursor()
    end

    function GUI:MoveCursor()
        self.cursor.Offset = self.absolutepos + self.cursor_position - Vector2.new(2, 2)
        self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1, 1)
        self.cursor.Size = Vector2.new(self.absolutesize.X+4, 4)
        self.cursor_outline.Size = Vector2.new(self.absolutesize.X+6, 6)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.color_fade.Offset = pos - Vector2.new(1,1)
        self.color_fade.Size = size + Vector2.new(1,1)
        self:MoveCursor()
    end

    function GUI:CalculateValue(X, Y)
        local APY = self.absolutepos.Y
        local ASY = self.absolutesize.Y
        local newY = math.clamp(Y, APY, APY + ASY )
        self.cursor_position = Vector2.new(0, newY-APY)
        self:MoveCursor()

        -- calculate new color
        self.h = math.clamp(1-(self.cursor_position.Y/self.absolutesize.Y), 0, 1)
        self:OnValueChanged(Color3.fromHSV(self.h, self.s, self.v), self.t)
    end

    local mouse = BBOT.service:GetService("Mouse")
    function GUI:Step()
        if self.down then
            self:CalculateValue(mouse.X, mouse.Y+36)
        end
    end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.down = true
        end
    end

    function GUI:InputEnded(input)
        if self.down and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.down = false
        end
    end

    function GUI:OnValueChanged(color, transparency)
        
    end

    gui:Register(GUI, "ColorSlider")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")
        self.background.Color = Color3.new(1,1,1)
        
        --(imagedata, x, y, w, h, transparency, visible)
        local color_fade = draw:Create("Image", "2V")
        color_fade.XAlignment = XAlignment.Right
        color_fade.YAlignment = YAlignment.Bottom
        color_fade.Image = BBOT.menu.images[1]

        local cursor_outline = draw:Create("Rect", "2V")
        cursor_outline.XAlignment = XAlignment.Right
        cursor_outline.YAlignment = YAlignment.Bottom
        cursor_outline.Color = Color3.new(0,0,0)

        local cursor = draw:Clone(cursor_outline)
        cursor.Color = Color3.new(1,1,1)

        self.color_fade = self:Cache(color_fade)
        self.cursor_outline = self:Cache(cursor_outline)
        self.cursor = self:Cache(cursor)
        self.cursor_position = Vector2.new(2,2)
        self:SetMouseInputs(true)

        --(visible, imagedata, pos_x, pos_y, width, height, transparency, tablename)
        --[[
            ColorpickerRect(false, 12, 25, 156, 156, { 0, 0, 0, 255 }, cp.drawings)
            ColorpickerImage(false, BBOT_IMAGES[1], 12, 25, 156, 156, 1, cp.drawings)
            ColorpickerImage(false, BBOT_IMAGES[2], 12, 191, 159, 10, 1, cp.drawings)
        ]]
    end

    function GUI:SetColor(color, transparency)
        local h, s, v = Color3.toHSV(color)
        self.h = h
        self.s = s
        self.v = v
        self.t = transparency
        self.cursor_position = Vector2.new(0, 1-transparency) * self.absolutesize
        self:MoveCursor()
    end

    function GUI:MoveCursor()
        self.cursor.Offset = self.absolutepos + self.cursor_position - Vector2.new(2, 2)
        self.cursor_outline.Offset = self.cursor.Offset - Vector2.new(1, 1)
        self.cursor.Size = Vector2.new(self.absolutesize.X+4, 4)
        self.cursor_outline.Size = Vector2.new(self.absolutesize.X+6, 6)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.color_fade.Offset = pos - Vector2.new(1,1)
        self.color_fade.Size = size + Vector2.new(1,1)
        self:MoveCursor()
    end

    function GUI:CalculateValue(X, Y)
        local APY = self.absolutepos.Y
        local ASY = self.absolutesize.Y
        local newY = math.clamp(Y, APY, APY + ASY )
        self.cursor_position = Vector2.new(0, newY-APY)
        self:MoveCursor()

        -- calculate new color
        self.t = math.clamp(1-(self.cursor_position.Y/self.absolutesize.Y), 0, 1)
        self:OnValueChanged(Color3.fromHSV(self.h, self.s, self.v), self.t)
    end

    local mouse = BBOT.service:GetService("Mouse")
    function GUI:Step()
        if self.down then
            self:CalculateValue(mouse.X, mouse.Y+36)
        end
    end

    function GUI:InputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self.down = true
        end
    end

    function GUI:InputEnded(input)
        if self.down and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.down = false
        end
    end

    function GUI:OnValueChanged(color, transparency)
        
    end

    gui:Register(GUI, "AlphaSlider")

    local GUI = {}

    function GUI:Init()
        default_panel_objects(self)
        self.background_border.Color = gui:GetColor("Outline-Light")
        self.background_outline.Color = gui:GetColor("Border")
        --(imagedata, x, y, w, h, transparency, visible)
        local transparency_background = draw:Create("Image", "2V")
        transparency_background.XAlignment = XAlignment.Right
        transparency_background.YAlignment = YAlignment.Bottom
        transparency_background.Image = BBOT.menu.images[5]
        self.transparency_background = self:Cache(transparency_background)
    end

    function GUI:SetColor(col, transparency)
        self.background.Color = col
        self.background.Opacity = transparency
        self:Cache(self.background)
    end

    function GUI:PerformLayout(pos, size, shiftpos, shiftsize)
        default_panel_borders(self, pos, size)
        self.transparency_background.Offset = pos - Vector2.new(1,1)
        self.transparency_background.Size = size + Vector2.new(1,1)
    end

    gui:Register(GUI, "ColorPreview")

    local GUI = {}
    local _color = color
    function GUI:Init()
        default_panel_objects(self)

        local gradient = default_gradient(self)
        self.gradient = self:Cache(gradient)

        local title = gui:Create("Text", self)
        self.title = title
        self.title_content = ""
        title:SetPos(0, 3, 0, 3)
        title:SetText("")

        self.pallet = gui:Create("ColorPallet", self)
        self.pallet:SetPos(0, 6, 0, 21)
        self.pallet:SetSize(1, -14-22*2, 1, -21-6-22)
        --self.pallet:SetSizeConstraint("Y")

        self.hslider = gui:Create("ColorSlider", self)
        self.hslider:SetPos(1, -22-17-6, 0, 21)
        self.hslider:SetSize(0, 16, 1, -21-6-22)

        self.tslider = gui:Create("AlphaSlider", self)
        self.tslider:SetPos(1, -22, 0, 21)
        self.tslider:SetSize(0, 16, 1, -21-6-22)

        self.hexbox = gui:Create("TextEntry", self)
        self.hexbox:SetText(color.tohex(Color3.new(1,1,1)))
        self.hexbox:SetPos(0, 6, 1, -22)
        self.hexbox:SetSize(0,60,0,16)
        self.hexbox:SetTextSize(13)

        self.rgbabox = gui:Create("TextEntry", self)
        self.rgbabox:SetText("")
        self.rgbabox:SetPos(0, 6+66, 1, -22)
        self.rgbabox:SetSize(1,-13-22-66,0,16)
        self.rgbabox:SetTextSize(13)

        self.colorpreview = gui:Create("ColorPreview", self)
        self.colorpreview.tooltip = "This is the preview of the chosen color"
        self.colorpreview:SetPos(1, -22, 1, -22)
        self.colorpreview:SetSize(0, 16, 0, 16)

        local s = self
        function self.pallet:OnValueChanged(color, transparency)
            s.hslider:SetColor(color, transparency)
            s.tslider:SetColor(color, transparency)
            s:OnChanged(color, transparency)
            s.hexbox:SetText(_color.tohex(color))
            s.rgbabox:SetText(_color.tostring(color, transparency))
            s.colorpreview:SetColor(color, transparency)
        end
        function self.hslider:OnValueChanged(color, transparency)
            s.pallet:SetColor(color, transparency)
            s.tslider:SetColor(color, transparency)
            s:OnChanged(color, transparency)
            s.hexbox:SetText(_color.tohex(color))
            s.rgbabox:SetText(_color.tostring(color, transparency))
            s.colorpreview:SetColor(color, transparency)
        end
        function self.tslider:OnValueChanged(color, transparency)
            s.pallet:SetColor(color, transparency)
            s.hslider:SetColor(color, transparency)
            s:OnChanged(color, transparency)
            s.hexbox:SetText(_color.tohex(color))
            s.rgbabox:SetText(_color.tostring(color, transparency))
            s.colorpreview:SetColor(color, transparency)
        end
        function self.hexbox:OnValueChanged(hex)
            local color = _color.fromhex(hex)
            local transparency = s.tslider.t
            if not color then return end
            s.pallet:SetColor(color, transparency)
            s.hslider:SetColor(color, transparency)
            s:OnChanged(color, transparency)
            s.rgbabox:SetText(_color.tostring(color, transparency))
            s.colorpreview:SetColor(color, transparency)
        end
        function self.rgbabox:OnValueChanged(textcolor)
            local color, transparency = _color.fromstring(textcolor)
            if not color then return end
            s.pallet:SetColor(color, transparency)
            s.hslider:SetColor(color, transparency)
            s.tslider:SetColor(color, transparency)
            s:OnChanged(color, transparency)
            s.hexbox:SetText(_color.tohex(color))
            s.colorpreview:SetColor(color, transparency)
        end

        self:SetOpacity(0)
        gui:OpacityTo(self, 1, 0.2, 0, 0.25)
    end

    function GUI:PerformLayout(pos, size)
        default_panel_borders(self, pos, size)
        self.gradient.Offset = pos + Vector2.new(-1,-1)
        self.gradient.Size = Vector2.new(size.X+1, 21)
    end

    function GUI:Close()
        gui:OpacityTo(self, 0, 0.2, 0, 0.25, function()
            self:Remove()
        end)
    end

    function GUI:SetTitle(txt)
        self.title_content = txt
        self.title:SetText(txt)
    end

    function GUI:SetColor(color, transparency)
        self.pallet:SetColor(color, transparency)
        self.hslider:SetColor(color, transparency)
        self.tslider:SetColor(color, transparency)
        self.hexbox:SetText(_color.tohex(color))
        self.rgbabox:SetText(_color.tostring(color, transparency))
        self.colorpreview:SetColor(color, transparency)
    end

    function GUI:OnChanged() end

    function GUI:IsHoverTotal()
        if self:IsHovering() then return true end
        local buttons = self.buttons
        for i=1, #buttons do
            if buttons[i]:IsHovering() then return true end
        end
    end

    gui:Register(GUI, "ColorPickerChange")

    local GUI = {}

    function GUI:Init()
        local border = draw:Create("Rect", "2V")
        border.Color = gui:GetColor("Border")
        border.Filled = true
        border.XAlignment = XAlignment.Right
        border.YAlignment = YAlignment.Bottom

        local nocolor = draw:Create("Image", "2V")
        nocolor.Image = BBOT.menu.images[4]
        nocolor.XAlignment = XAlignment.Right
        nocolor.YAlignment = YAlignment.Bottom

        local outline = draw:Clone(border)
        outline.Color = gui:GetColor("Border")

        local background = draw:Clone(border)
        background.Color = gui:GetColor("Background")
        background.ZIndex = 1

        self.background_border = self:Cache(border)
        self.background_nocolor = self:Cache(nocolor)
        self.background_outline = self:Cache(outline)
        self.background = self:Cache(background)
    end

    function GUI:PerformLayout(pos, size)
        self.background.Offset = pos + Vector2.new(2, 2)
        self.background.Size = size - Vector2.new(4, 4)
        self.background_outline.Offset = pos
        self.background_outline.Size = size
        self.background_nocolor.Offset = pos - Vector2.new(1,1)
        self.background_nocolor.Size = size + Vector2.new(1,1)
        self.background_border.Offset = pos - Vector2.new(1, 1)
        self.background_border.Size = size + Vector2.new(2, 2)
    end

    function GUI:SetColor(col, transparency)
        self.background.Color = col
        self:Cache(self.background_outline, transparency, 1, 0, true)
        self.background_outline.Color = color.darkness(col, .75)
        self:PerformDrawings()
        self.color_transparency = transparency
    end

    function GUI:SetTitle(txt)
        self.title = txt
    end

    function GUI:Open()
        if self.selection then
            self.selection:Remove()
            self.selection = nil
        end
        local picker = gui:Create("ColorPickerChange", self)
        self.picker = picker
        picker:SetPos(.5,0,.5,0)
        picker:SetSize(0, 240, 0, 211)
        picker:SetTitle(self.title)
        picker:SetColor(self.background.Color, self.color_transparency)
        picker:SetZIndex(100)
        function picker.OnChanged(s, rgb, alpha)
            self:SetColor(rgb, alpha)
            self:OnValueChanged({rgb.R*255, rgb.G*255, rgb.B*255, alpha*255})
        end
        self.open = true
    end

    function GUI:Close()
        if self.picker then
            self.picker:Close()
            self.picker = nil
        end
        self.open = false
    end

    function GUI:InputBegan(input)
        if not self._enabled then return end
        if not self.open and input.UserInputType == Enum.UserInputType.MouseButton1 and self:IsHovering() then
            self:Open()
        elseif self.open and (not self.picker or not gui:IsHovering(self.picker)) then
            self:Close()
        end
    end

    function GUI:SetValue(col)
        self:SetColor(Color3.fromRGB(unpack(col)), col[4] and (col[4]/255) or 1)
    end

    function GUI:OnValueChanged() end

    gui:Register(GUI, "ColorPicker", "Button")
end

-- Line Graph
do
    local GUI = {}

    function GUI:Init()

    end

    function GUI:PerformLayout(pos, size, poschanged, sizechanged)

    end

    gui:Register(GUI, "LineGraph")
end