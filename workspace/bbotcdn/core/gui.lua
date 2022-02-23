-- WholeCream's Drawing Library to GUI Library
-- Extremely versatile and immediate!
local hook = BBOT.hook
local draw = BBOT.draw
local math = BBOT.math
local mouse = BBOT.service:GetService("Mouse")
local log = BBOT.log
local gui = {
    registry = {}, -- contains all gui objects
    active = {}, -- contains only enabled gui objects
    classes = {}
}

if BBOT.Debug.menu then
    local dbg = draw:Create("Rect", "2V")
    gui.drawing_debugger = dbg
    dbg.XAlignment = XAlignment.Right
    dbg.YAlignment = YAlignment.Bottom
    dbg.Color = Color3.new(1,1,1)
    dbg.Visible = false
    dbg.ZIndex = 2000000

    local dbgtext = draw:Create("Text", "2V")
    gui.drawing_debugger_text = dbgtext
    dbgtext.Color = Color3.fromRGB(255,255,255)
    dbgtext.Outlined = true
    dbgtext.XAlignment = XAlignment.Right
    dbgtext.YAlignment = YAlignment.Bottom
    dbgtext.TextXAlignment = XAlignment.Left
    dbgtext.OutlineColor = Color3.fromRGB(0,0,0)
    dbgtext.OutlineThickness = 2
    dbgtext.Visible = false
    dbgtext.ZIndex = 2000000

    local mouse = draw:CreatePoint("Mouse")
    local dbgtext = draw:Create("Text", "Offset")
    gui.drawing_debugger_actives = dbgtext
    dbgtext.Color = Color3.fromRGB(255,255,255)
    dbgtext.Outlined = true
    dbgtext.XAlignment = XAlignment.Right
    dbgtext.YAlignment = YAlignment.Bottom
    dbgtext.TextXAlignment = XAlignment.Left
    dbgtext.OutlineColor = Color3.fromRGB(0,0,0)
    dbgtext.OutlineThickness = 2
    dbgtext.Visible = true
    dbgtext.ZIndex = 2000000
    dbgtext.Offset = Vector2.new(10, 10)
    dbgtext.point.Point = mouse.point
end

gui.colors = {
    ["Default"] = Color3.new(1,1,1),
    ["Accent"] = Color3.fromRGB(127, 72, 163),
    ["Border"] = Color3.fromRGB(0,0,0),
    ["Outline"] = Color3.fromRGB(20,20,20),
    ["Outline-Light"] = Color3.fromRGB(30,30,30),
    ["Background"] = Color3.fromRGB(35,35,35),
    ["Background-Light"] = Color3.fromRGB(40,40,40),
}

function gui:GetColor(color)
    return gui.colors[color] or gui.colors["Default"]
end

do
    local base = {}
    gui.base = base

    -- this is usually overwritten, called when the panel is created
    function base:Init()
        self:Calculate()
    end

    -- set's the position of the panel, you can put a UDim2 or just raw values for this
    function base:SetPos(xs, xo, ys, yo)
        if typeof(xs) == "UDim2" then
            self.pos = xs
        else
            self.pos = UDim2.new(xs, xo, ys, yo)
        end
        self:Calculate()
    end

    -- set's the size of the panel, you can put a UDim2 or just raw values for this
    function base:SetSize(ws, wo, hs, ho)
        if typeof(ws) == "UDim2" then
            self.size = ws
        else
            self.size = UDim2.new(ws, wo, hs, ho)
        end
        self:Calculate()
    end

    -- size constraints forces the panel to restrict it's size depending on it's length or width
    function base:SetSizeConstraint(type)
        self.sizeconstraint = type
    end

    -- returns a Vector2 of it's position local to it's parent
    function base:GetPos()
        return self.pos
    end

    -- PerformLayout is called when the panel changes it's position or size, use this for drawing objects
    function base:PerformLayout(pos, size)
    end

    -- Centers the panel to's parent
    function base:Center()
        self:SetPos(.5, -self.absolutesize.X/2, .5, -self.absolutesize.Y/2)
    end

    -- Get's the absolute position and size in screen space
    local camera = BBOT.service:GetService("CurrentCamera")
    function base:GetLocalTranslation()
        local psize = (self.parent and self.parent.absolutesize or camera.ViewportSize)

        local X = math.round(self.pos.X.Offset + (self.pos.X.Scale * psize.X))
        local Y = math.round(self.pos.Y.Offset + (self.pos.Y.Scale * psize.Y))
        local W = math.round(self.size.X.Offset + (self.size.X.Scale * psize.X))
        local H = math.round(self.size.Y.Offset + (self.size.Y.Scale * psize.Y))

        if self.sizeconstraint == "Y" and W > H then
            W = H
        elseif self.sizeconstraint == "X" and H > W then
            H = W
        end

        -- this is fucking retarded
        local ppos = (self.parent and self.parent.absolutepos or Vector2.new())
        if X > math.huge or X < -math.huge then
            X = self.absolutepos.X - ppos.X
        end

        if Y > math.huge or Y < -math.huge then
            Y = self.absolutepos.Y - ppos.Y
        end

        if W > math.huge or W < -math.huge then
            W = self.absolutesize.X
        end

        if H > math.huge or H < -math.huge then
            H = self.absolutesize.Y
        end

        return Vector2.new(X, Y), Vector2.new(W, H)
    end

    -- Forces a calculation of PerformLayout, put in positionshift or sizeshift to let em know if there was a change
    function base:InvalidateLayout(positionshift, sizeshift)
        self:PerformLayout(self.absolutepos, self.absolutesize, positionshift, sizeshift)
    end

    -- Recursively does layout recaluclations, same purpose of InvalidateLayout just recursive
    function base:InvalidateAllLayouts(positionshift, sizeshift)
        self:InvalidateLayout(positionshift, sizeshift)
        local children = self.children
        for i=1, #children do
            local v = children[i]
            if gui:IsValid(v) then
                v:InvalidateAllLayouts(positionshift, sizeshift)
            end
        end
    end

    -- Calculate is responsible for everything the panel needs to do, try not to override this ok?
    function base:Calculate()
        if self.__INVALID then return end
        local t = tick()
        local last_opacity, last_zind, last_vis = self._opacity, self._zindex, self._visible
        local wasenabled = self._enabled

        if self.parent then
            if not self.parent._enabled then
                self._enabled = false
            else
                self._enabled = self.enabled
            end
            if not self.parent._visible then
                self._visible = false
            else
                self._visible = self.visible
            end
            self._opacity = self.parent._opacity * self.opacity
            self._zindex = self.parent._zindex + self.zindex + (self.focused and 10000 or 0)
        else
            self._enabled = self.enabled
            self._visible = self.visible
            self._opacity = self.opacity
            self._zindex = self.zindex + (self.focused and 10000 or 0)
        end

        local positionshift, sizeshift = false, false
        do
            local ppos = (self.parent and self.parent.absolutepos or Vector2.new())
            local pos, size = self:GetLocalTranslation()
            local a = pos + ppos
            if self.absolutepos ~= a then
                self.absolutepos = a
                positionshift = true
            end
            if self.absolutesize ~= size then
                self.absolutesize = size
                sizeshift = true
            end
        end

        local changed = last_opacity ~= self._opacity or last_zind ~= self.zindex or last_vis ~= self._visible or wasenabled ~= self._enabled or positionshift or sizeshift
        if self._enabled and changed then
            self:InvalidateLayout(positionshift, sizeshift)
        end
        
        if changed then
            self:PerformDrawings()
        end

        if self.OnVisibleChanged and last_vis ~= self._visible then
            self:OnVisibleChanged(self._visible)
        end

        if self.OnZIndexChanged and last_zind ~= self.zindex then
            self:OnZIndexChanged(self.zindex)
        end

        if self.OnOpacityChanged and last_opacity ~= self._opacity then
            self:OnOpacityChanged(self._opacity)
        end

        if self.OnEnabledChanged and wasenabled ~= self._enabled then
            self:OnEnabledChanged(self._enabled)
        end

        -- Partly why this is expensive is recursion, we need to do this to make sure all sub panels inherit properties
        if (self._enabled or wasenabled) and changed then
            local children = self.children
            for i=1, #children do
                local v = children[i]
                if v.Calculate then
                    v:Calculate()
                end
                if v.ParentPerformLayout and self._enabled and changed then
                    v:ParentPerformLayout(self.absolutepos, self.absolutesize, positionshift, sizeshift)
                end
            end
        end

        self._absolutepos = self.absolutepos
        self._absolutesize = self.absolutesize

        if self._enabled ~= wasenabled then
            local actives_list = gui.active
            if self._enabled then
                actives_list[#actives_list+1] = self
            else
                for i=1, #actives_list do
                    if actives_list[i] == self then
                        table.remove(actives_list, i)
                        break
                    end
                end
            end
        end
        self._profile_calculate = tick() - t
    end

    -- This calculate all of the drawing object's behavior
    function base:PerformDrawings()
        local cache = self.objects
        for i=1, #cache do
            local v = cache[i]
            if v.object and draw:IsValid(v.object) then
                local drawing = v.object
                drawing.Opacity = v.opacity * self._opacity
                drawing.OutlineOpacity = v.outlineopacity * self._opacity
                drawing.ZIndex = v.zindex + self._zindex
                if not v.visible or not self._enabled then
                    drawing.Visible = false
                elseif v.visible then
                    if self._visible then
                        drawing.Visible = self.local_visible
                    else
                        drawing.Visible = false
                    end
                end
            end
        end
    end

    -- Set's what the parented panel should be, putting nil will remove the parent
    function base:SetParent(object)
        if not object and self.parent then
            local parent_children = self.parent.children
            local c=0
            for i=1, #parent_children do
                local v = parent_children[i-c]
                if v == object then
                    table.remove(parent_children, i-c)
                    c=c+1
                end
            end
            self.parent:Calculate()
            self.parent = nil
            self:Calculate()
        elseif object then
            self.parent = object
            local parent_children = self.parent.children
            parent_children[#parent_children+1] = self
            local c=0
            for i=1, #parent_children do
                local v = parent_children[i-c]
                if v.parent ~= object then
                    table.remove(parent_children, i-c)
                    c=c+1
                end
            end
            self:Calculate()
        end
    end

    -- Get's every single child and sub children of a panel to a numerical table
    function base:RecursiveToNumeric(children, destination)
        destination = destination or {}
        children = children or self.children
        for i=1, #children do
            local v = children[i]
            if v ~= self then
                v:RecursiveToNumeric(v.children, destination)
            end
            destination[#destination+1] = v
        end
        return destination
    end

    -- I do not need to explain this
    function base:IsHovering()
        return self.ishovering == true
    end

    function base:IsAbsoluteHovering() -- absolute disregards priorities of ZIndexes
        return self.absoluteishovering == true
    end

    -- Called when a mouse enters the panel's bounds
    function base:OnMouseEnter() end
    function base:OnAbsoluteMouseEnter() end -- absolute disregards priorities of ZIndexes
    -- Called when a mouse leaves the panel's bounds
    function base:OnMouseExit() end
    function base:OnAbsoluteMouseExit() end -- absolute disregards priorities of ZIndexes

    -- Called the same way as "RenderStepped"
    function base:Step() end
    function base:Cache(object, opacity, outlineopacity, zindex, visible)
        if self.__INVALID then return end
        local objects = self.objects
        local exists = false
        for i=1, #objects do
            local v = objects[i]
            if v.object == object then
                v.opacity = opacity or object.Opacity
                v.outlineopacity = outlineopacity or object.OutlineOpacity
                v.zindex = zindex or object.ZIndex
                v.visible = visible or object.Visible
                object.Opacity = object.Opacity * self._opacity
                object.ZIndex = object.ZIndex + self._zindex
                if not object.Visible or not self._enabled then
                    object.Visible = false
                elseif object.Visible then
                    if self._visible then
                        object.Visible = self.local_visible
                    else
                        object.Visible = false
                    end
                end
                return object
            end
        end
        self.objects[#self.objects+1] = {
            object = object,
            opacity = object.Opacity,
            outlineopacity = object.OutlineOpacity,
            zindex = object.ZIndex,
            visible = object.Visible
        }
        object.Opacity = object.Opacity * self._opacity
        object.ZIndex = object.ZIndex + self._zindex
        if not object.Visible or not self._enabled then
            object.Visible = false
        elseif object.Visible then
            if self._visible then
                object.Visible = self.local_visible
            else
                object.Visible = false
            end
        end
        return object
    end

    -- Calling Destroy will remove all drawing objects associated with the panel
    function base:PreDestroy() end
    function base:PostDestroy() end
    function base:Destroy()
        self:PreDestroy()
        local objects = self.objects
        while true do
            local v = objects[1]
            if not v then break end
            v = v.object
            if draw:IsValid(v) then
                v:Remove()
            end
            table.remove(objects, 1)
        end
        self:PostDestroy()
    end

    -- Calling Remove will destory the panel and all drawing object associated
    function base:PreRemove() end
    function base:PostRemove() end
    function base:Remove()
        self:SetVisible(false)
        self.__INVALID = true
        self:SetParent(nil)
        self:PreRemove()
        self:Destroy()
        local reg = gui.registry
        local c = 0
        for i=1, #reg do
            local v = reg[i-c]
            if v == self then
                table.remove(reg, i-c)
                c = c + 1
            end
        end
        c = 0
        local actives_list = gui.active
        for i=1, #actives_list do
            local v = actives_list[i-c]
            if v == self then
                table.remove(actives_list, i-c)
                c = c + 1
            end
        end
        local children = self.children
        for i=1, #children do
            local v = children[i]
            if v.Remove then
                v:Remove()
            end
        end
        self:PostRemove()
    end

    -- !!!!Absolute returns what the panel's total whatever is from it's parent!!!! --

    function base:GetAbsoluteOpacity()
        return self._opacity
    end
    function base:GetOpacity()
        return self.opacity
    end
    function base:SetOpacity(t)
        self.opacity = t
        self:Calculate()
    end

    function base:GetAbsoluteZIndex() -- the true zindex of the rendering objects
        return self._zindex
    end
    function base:GetZIndex() -- get the zindex duhh
        return self.zindex
    end
    function base:SetZIndex(index) -- sets both the mouse, keyboard and rendering zindex
        self.zindex = index -- This controls both mouse inputs and rendering
        self:Calculate() -- Re-calculate ZIndex for drawings in cache
    end

    function base:GetAbsoluteEnabled()
        return self._enabled
    end
    function base:GetEnabled()
        return self.enabled
    end
    function base:SetEnabled(bool)
        self.enabled = bool
        self:Calculate()
    end

    function base:GetAbsoluteVisible()
        return self._visible
    end
    function base:GetVisible()
        return self.visible
    end
    function base:SetVisible(bool)
        self.visible = bool
        self:Calculate()
    end
    function base:SetLocalVisible(bool)
        self.local_visible = bool
        self:Calculate()
    end

    -- Focus is used to force the panel's ZIndex to be higher than others
    -- This is hover pretty shittily done
    function base:SetFocused(focus)
        self.focused = focus
        self:Calculate()
    end
    function base:SetMouseInputs(inputs)
        self.mouseinputs = inputs
    end
end

-- Use register to add a new panel class for creation, similar to like how base is done
function gui:Register(tbl, class, base)
    base = (base and self.classes[base] or self.base)
    if not base then base = self.base end
    setmetatable(tbl, {__index = base})
    tbl.class = class
    tbl.super = base
    self.classes[class] = tbl
end

-- Create just makes the panel... Of course from the ones you have registered
local uid = 0
function gui:Create(class, parent)
    if not self.classes[class] then
        error("gui:Create - No Such Class: " .. class)
        return
    end
    local struct = {
        uid = uid,
        objects = {},
        parent = parent,
        children = {},
        isgui = true,
        mouseinputs = true,
        class = class,
        traceback = debug.traceback(),

        -- If only there was a better way of inheriting variables
        enabled = true,
        _enabled = true,
        visible = true,
        _visible = true,
        local_visible = true,
        opacity = 1,
        _opacity = 1,
        zindex = 1,
        _zindex = 1,
        pos = UDim2.new(),
        absolutepos = Vector2.new(),
        size = UDim2.new(),
        absolutesize = Vector2.new(),
    }
    uid = uid + 1
    setmetatable(struct, {
        __index = self.classes[class],
        __tostring = function(self)
            return "GUI: " .. self.class .. "-" .. self.uid
        end
    })
    self.registry[#self.registry+1] = struct
    self.active[#self.active+1] = struct
    if struct.Init then
        struct:Init()
    end
    if parent then
        struct:SetParent(parent)
    end
    return struct
end

-- Use this to check if a panel has been destroyed
function gui:IsValid(object)
    if object and not object.__INVALID then
        return true
    end
end

local ScheduledObjects = {}

function gui:IsInAnimation(object)
    for i=1, #ScheduledObjects do
        local v = ScheduledObjects[i]
        if v.object == object then
            return true, v.type
        end
    end
end

do
    local function positioningfunc(data, fraction)
        local diff = data.target - data.origin
        local XDim = diff.X
        local YDim = diff.Y
        data.object:SetPos(data.origin + UDim2.new(XDim.Scale * fraction, XDim.Offset * fraction, YDim.Scale * fraction, YDim.Offset * fraction))
    end

    -- Moves a GUI object to a certain UDim2 location
    function gui:MoveTo(object, pos, length, delay, ease, callback)
        for i=1, #ScheduledObjects do
            local v = ScheduledObjects[i]
            if v.type == "MoveTo" and v.object == object then
                table.remove(ScheduledObjects, i)
                break
            end
        end

        ScheduledObjects[#ScheduledObjects+1] = {
            object = object,
            type = "MoveTo",

            starttime = tick()+delay,
            endtime = tick()+delay+length,

            origin = object.pos,
            target = pos,

            ease = ease or 1,
            callback = callback,
            step = positioningfunc
        }
    end
end

do
    local function scalingfunc(data, fraction)
        local diff = data.target - data.origin
        local XDim = diff.X
        local YDim = diff.Y
        data.object:SetSize(data.origin + UDim2.new(XDim.Scale * fraction, XDim.Offset * fraction, YDim.Scale * fraction, YDim.Offset * fraction))
    end

    -- Sizes a GUI object to a certain UDim2 size
    function gui:SizeTo(object, size, length, delay, ease, callback)
        for i=1, #ScheduledObjects do
            local v = ScheduledObjects[i]
            if v.type == "SizeTo" and v.object == object then
                table.remove(ScheduledObjects, i)
                break
            end
        end

        ScheduledObjects[#ScheduledObjects+1] = {
            object = object,
            type = "SizeTo",

            starttime = tick()+delay,
            endtime = tick()+delay+length,

            origin = object.size,
            target = size,

            ease = ease or 1,
            callback = callback,
            step = scalingfunc
        }
    end
end

do
    local function step(data, fraction)
        local diff = data.target - data.origin
        data.object:SetOpacity(data.origin + (diff * fraction))
    end

    function gui:OpacityTo(object, opacity, length, delay, ease, callback)
        for i=1, #ScheduledObjects do
            local v = ScheduledObjects[i]
            if v.type == "OpacityTo" and v.object == object then
                table.remove(ScheduledObjects, i)
                break
            end
        end

        ScheduledObjects[#ScheduledObjects+1] = {
            object = object,
            type = "OpacityTo",

            starttime = tick()+delay,
            endtime = tick()+delay+length,

            origin = object:GetOpacity(),
            target = opacity,

            ease = ease or 1,
            callback = callback,
            step = step
        }
    end
end

hook:Add("RenderStepped", "BBOT:GUI.Animation", function()
    local c = 0
    for a = 1, #ScheduledObjects do
        local i = a-c
        local data = ScheduledObjects[i]
        if not data.object or not gui:IsValid(data.object) then
            table.remove(ScheduledObjects, i)
            c = c + 1
        elseif tick() >= data.starttime then
            local fraction = math.timefraction( data.starttime, data.endtime, tick() )
            if fraction > 1 then fraction = 1 elseif fraction < 0 then fraction = 0 end

            if data.step then
                local frac = fraction ^ data.ease
                if ( data.ease < 0 ) then
                    frac = fraction ^ ( 1.0 - ( ( fraction - 0.5 ) ) )
                elseif ( data.ease > 0 and data.ease < 1 ) then
                    frac = 1 - ( ( 1 - fraction ) ^ ( 1 / data.ease ) )
                end

                data.step( data, frac )
            end

            if fraction == 1 then
                table.remove(ScheduledObjects, i)
                c = c + 1

                if data.callback then
                    data.callback(data.object)
                end
            end
        end
    end
end)

-- Checks if the panel is being hovered over
function gui:IsHovering(object)
    if not object._enabled then return end
    return mouse.X > object.absolutepos.X and mouse.X < object.absolutepos.X + object.absolutesize.X and mouse.Y > object.absolutepos.Y - 36 and mouse.Y < object.absolutepos.Y + object.absolutesize.Y - 36
end

-- Check is the mouse is hovering any panel
function gui:IsHoveringAnObject()
    return #gui.objects_hovering > 0
end

local function V2ToString(vec)
    return "V("..vec.X..", "..vec.Y..")"
end

local function UDToString(udim)
    return "D(".. udim.X.Scale ..",".. udim.X.Offset ..",".. udim.Y.Scale ..",".. udim.Y.Offset ..")"
end

gui.objects_hovering = {}
gui.objects_keyhovering = {}
hook:Add("RenderStepped", "BBOT:GUI.Hovering", function()
    local objects_hovering = gui.objects_hovering
    local objects_keyhovering = gui.objects_keyhovering
    local reg = gui.active
    local changed = false
    local c = 0
    for i=1, #objects_hovering do
        local k = i - c
        local v = objects_hovering[k]
        if (not v or v.__INVALID or not gui:IsHovering(v)) then
            if v.absoluteishovering ~= false then
                v.absoluteishovering = false
                if v.OnAbsoluteMouseExit then
                    v:OnAbsoluteMouseExit(mouse.X, mouse.Y)
                end
            end
            objects_keyhovering[v] = nil
            table.remove(objects_hovering, k)
            c=c+1
            changed = true
        end
    end

    for i=1, #reg do
        local v = reg[i]
        if v and not objects_keyhovering[v] and not v.__INVALID and v.class ~= "Mouse" and v.class ~= "Container" and gui:IsHovering(v) then
            if v.absoluteishovering ~= true then
                v.absoluteishovering = true
                if v.OnAbsoluteMouseEnter then
                    v:OnAbsoluteMouseEnter(mouse.X, mouse.Y)
                end
            end
            objects_keyhovering[v] = true
            objects_hovering[#objects_hovering+1] = v
            changed = true
        end
    end

    if changed then
        table.sort(objects_hovering, function(a, b) return a._zindex > b._zindex end)

        local set = false
        for i=1, #objects_hovering do
            local v = objects_hovering[i]
            if v.mouseinputs then
                if v ~= gui.hovering then
                    if gui.hovering then
                        gui.hovering.ishovering = false
                        if gui.hovering.OnMouseExit then
                            gui.hovering:OnMouseExit(mouse.X, mouse.Y)
                        end
                    end
                    gui.hovering = v
                    if gui.hovering then
                        gui.hovering.ishovering = true
                        if gui.hovering.OnMouseEnter then
                            gui.hovering:OnMouseEnter(mouse.X, mouse.Y)
                        end
                    end
                end
                set = true
                break
            end
        end

        if not set then
            if gui.hovering ~= nil then
                if gui.hovering then
                    gui.hovering.ishovering = false
                    if gui.hovering.OnMouseExit then
                        gui.hovering:OnMouseExit(mouse.X, mouse.Y)
                    end
                end
                gui.hovering = nil
            end
        end
    end

    if gui.drawing_debugger then
        local result = objects_hovering[1]

        if result then
            gui.drawing_debugger.Visible = true
            gui.drawing_debugger.Offset = result.absolutepos
            gui.drawing_debugger.Size = result.absolutesize

            gui.drawing_debugger_text.Offset = result.absolutepos + Vector2.new(0, result.absolutesize.Y)
            gui.drawing_debugger_text.Visible = true
            local dbgmsg = tostring(result) .. "\n" ..
            "Position: " .. UDToString(result.pos) .. " - " .. V2ToString(result.absolutepos) .. "\n" ..
            "Size: " .. UDToString(result.size) .. " - " .. V2ToString(result.absolutesize) .. "\n" ..
            "Children: " .. #result.children .. " (" .. #result:RecursiveToNumeric() .. ")\n" ..
            "Calculate: " .. math.round((result._profile_calculate or 0) * 1000, 4) .. " ms\n" ..
            "Step: " .. math.round((result._step_profile or 0) * 1000, 4) .. " ms"

            gui.drawing_debugger_text.Text = dbgmsg
            gui.drawing_debugger_actives.Visible = false
        else
            gui.drawing_debugger.Visible = false
            gui.drawing_debugger_text.Visible = false
            gui.drawing_debugger_actives.Visible = true
        end
    end
end)

hook:Add("WheelForward", "BBOT:GUI.Input", function()
    local reg = gui.active
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID then
            if v.WheelForward then
                v:WheelForward()
            end
        end
    end
end)

hook:Add("WheelBackward", "BBOT:GUI.Input", function()
    local reg = gui.active
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID then
            if v.WheelBackward then
                v:WheelBackward()
            end
        end
    end
end)

hook:Add("Camera.ViewportChanged", "BBOT:GUI.Transform", function()
    local reg = gui.active
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID and not v.parent then
            v:Calculate()
        end
    end
end)

hook:Add("RenderStepped", "BBOT:GUI.Render", function(delta)
    
    local tt = tick()
    local mouse_reg = 0
    local reg = gui.active
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID then
            if v.Step then
                local t = tick()
                v:Step(delta)
                v._step_profile = tick() - t
            end
            if v.mouseinputs then
                mouse_reg = mouse_reg + 1
            end
        end
    end
    tt = tick() - tt

    if gui.drawing_debugger_actives then
        gui.drawing_debugger_actives.Text = "IGUI Debugger\nObjects: " .. #gui.registry ..
        "\nActive: " .. #gui.active ..
        "\nInput: " .. mouse_reg ..
        "\nStep: " .. math.round(tt * 1000, 4) .. " ms"
    end
end)

hook:Add("InputBegan", "BBOT:GUI.Input", function(input)
    local reg = gui.active
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID then
            if v.InputBegan then
                v:InputBegan(input)
            end
        end
    end
end)

hook:Add("InputEnded", "BBOT:GUI.Input", function(input)
    local reg = gui.active
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID then
            if v.InputEnded then
                v:InputEnded(input)
            end
        end
    end
end)

hook:Add("Unload", "BBOT:GUI.Remove", function()
    local reg = gui.registry
    for i=1, #reg do
        local v = reg[i]
        if v and not v.__INVALID then
            v:Remove()
        end
    end
end)

return gui