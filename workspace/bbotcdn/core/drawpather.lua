local camera = BBOT.service:GetService("CurrentCamera")
local math = BBOT.math
local table = BBOT.table
local hook = BBOT.hook
local draw = BBOT.draw
local color = BBOT.color 
local drawpather = {
    registry = {},
}

-- metamethods
do
    local meta = {}
    drawpather.meta = meta

    function meta:Init()
        self.t0 = tick()
        self.outlined = false
        self.size = 2
        self.endsize = 6
    end

    function meta:Remove()
        self.__INVALID = true
        local objects = self.objects
        for k=1, #objects do
            local v = objects[k][1]
            if draw:IsValid(v) then
                v:Destroy()
            end
        end
    end

    function meta:ValidateCache()
        local objects = self.objects
        local c = 0
        for k=1, #objects do
            k = k - c
            local v = objects[k][1]
            if not draw:IsValid(v) then
                table.remove(objects, k)
                c=c+1
            end
        end
    end

    function meta:SetOpacity(opacity)
        self.opacity = opacity
    end

    function meta:SetOutlined(bool)
        self.outlined = bool
        local rendered = self.rendered
        for i=1, #rendered do
            local v = rendered[i]
            v.Outlined = bool
        end
        if self.object_end then
            self.object_end.Outlined = bool
        end
    end

    function meta:SetSize(num)
        self.size = num
        local rendered = self.rendered
        for i=1, #rendered do
            local v = rendered[i]
            v.Thickness = num
        end
    end

    function meta:SetEndSize(num)
        self.endsize = num
        if self.object_end then
            self.object_end.Radius = num
        end
    end

    function meta:SetOutlineSize(num)
        self.outlinesize = num
        local rendered = self.rendered
        for i=1, #rendered do
            local v = rendered[i]
            v.OutlineThickness = num
        end
        if self.object_end then
            self.object_end.OutlineThickness = num
        end
    end

    function meta:SetColor(col, alpha)
        local dark = color.darkness(col, .25)
        local rendered = self.rendered
        for i=1, #rendered do
            local v = rendered[i]
            v.Color = col
            v.OutlineColor = dark
        end

        if self.object_end then
            self.object_end.Color = col
            self.object_end.Visible = false
        end

        self.color = col
        self.color_dark = dark

        if alpha then
            self:SetOpacity(alpha)
        end
    end

    function meta:Clear()
        local rendered = self.rendered
        for i=1, #rendered do
            local v = rendered[i]
            v:Destroy()
        end

        if self.object_end then
            self.object_end.Visible = false
        end

        self.rendered = {}
        self.frames = {}
    end

    function meta:Update(frames)
        local rendered = self.rendered
        self.frames = frames

        local rendered_len, frame_len = #rendered, #frames

        if rendered_len < frame_len then
            local creates = frame_len - rendered_len
            for i=1, creates do
                local line = draw:Create("Line", "3D", "3D")
                line.Color = self.color
                line.Thickness = 2
                line.Outlined = self.outlined
                line.OutlineColor = self.color_dark
                line.OutlineThickness = 2
                rendered[#rendered+1] = self:Cache(line)
            end
        elseif rendered_len > frame_len then
            local c = 0
            for i=frame_len, rendered_len do
                if rendered[i-c] then
                    if draw:IsValid(rendered[i-c]) then
                        rendered[i-c]:Destroy()
                    end
                    table.remove(rendered, i-c)
                    c=c+1
                end
            end
        end

        self:ShowEnd(self.showend)

        local last_frame = frames[1]
        if last_frame then
            for i=2, #frames do
                local current_frame = frames[i]
                local object = rendered[i-1]
                object.Point1 = last_frame
                object.Point2 = current_frame
                last_frame = current_frame
            end

            if self.object_end then
                self.object_end.Point = last_frame
            end
        end

        self:ValidateCache()
    end

    function meta:Cache(object)
        self.objects[#self.objects+1] = {object, object.Opacity, object.OutlineOpacity}
        return object
    end

    function meta:ShowEnd(bool)
        self.showend = bool
        if bool then
            if self.object_end then return end
            local circle = draw:Create("Circle", "3D")
            circle.Color = self.color
            circle.Radius = self.endsize
            circle.NumSides = 20
            circle.Filled = true
            circle.Outlined = self.outlined
            circle.OutlineColor = self.color_dark
            circle.OutlineThickness = 2
            circle.ZIndex = 1
            self.object_end = self:Cache(circle)
        elseif self.object_end then
            self.object_end:Destroy()
            self.object_end = nil
        end
    end

    function meta:ShouldRemove()
        if self.duration then
            return self.t0 + self.duration - tick() < 0
        else
            return false
        end
    end

    function meta:SetDuration(time)
        self.duration = time
    end

    function meta:Render()
        local frames = self.frames
        local objects = self.rendered
        if not frames[1] or not frames[2] then
            return
        end
        local opacity = 1
        if self.duration then
            local deltat = math.clamp(math.timefraction(self.t0, self.t0 + self.duration, tick()), 0, 1)
            opacity = math.remap(deltat,0,1,1,0) * self.opacity
        end

        -- 3D
        for k=1, #objects do
            local line = objects[k]
            line.Opacity = opacity
            line.OutlineOpacity = opacity
        end

        local object_end = self.object_end
        if object_end then
            object_end.Opacity = opacity
            object_end.OutlineOpacity = opacity
        end
    end
end

-- managed pathing system
local creationid = 0
function drawpather:Create()
    local construct = setmetatable({
        uid = creationid,
        cache = {},
        rendered = {},
        frames = {},
        objects = {},
    }, {
        __index = self.meta
    })
    construct:Init()
    construct:SetColor(Color3.new(), 1)
    self.registry[#self.registry+1] = construct
    return construct
end

function drawpather:Simple(pathway, col, opacity, time)
    local length = #pathway
    if length < 2 then return end
    local pather = self:Create()
    pather:SetColor(col)
    pather:SetOpacity(opacity)
    pather:SetDuration(time)
    pather:Update(pathway)
    return pather
end

function drawpather:SimpleWithEnd(pathway, col, opacity, time)
    local length = #pathway
    if length < 2 then return end
    local pather = self:Create()
    pather:SetColor(col)
    pather:ShowEnd(true)
    pather:SetOpacity(opacity)
    pather:SetDuration(time)
    pather:Update(pathway)
    return pather
end

hook:Add("RenderStepped", "BBOT:DrawPather.render", function(deltatime)
    local reg = drawpather.registry
    local c = 0
    for i=1, #reg do
        i=i-c
        local pather = reg[i]
        if pather:ShouldRemove() then
            table.remove(reg, i);c=c+1;
            pather:Remove()
            continue
        end
        pather:Render(deltatime)
    end
end)

return drawpather