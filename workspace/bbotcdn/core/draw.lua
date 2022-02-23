local hook = BBOT.hook
local timer = BBOT.timer
local log = BBOT.log
local draw = {}
draw.registry = {}
draw.classes = {}
draw.point_registry = {}
draw.point_classes = {}

--[[
    Property Identities
    0 - get
    1 - set
    2 - get, set
]]
draw.base_properties = {
    ["Visible"] = 2,
    ["ZIndex"] = 2,
    ["Opacity"] = 2,
    ["Color"] = 2,
    ["Outlined"] = 2,
    ["OutlineColor"] = 2,
    ["OutlineOpacity"] = 2,
    ["OutlineThickness"] = 2,
}

draw.base_pointproperties = {
    ["ScreenPos"] = 0,
    ["Visible"] = 0,
}

-- Metamethods are fun
-- Use this to add some fancy stuff to all your drawing objects
do
    local base_metamethods = {}
    draw.base_metamethods = base_metamethods

    function base_metamethods:Init() end

    function base_metamethods:IsPoint()
        return false
    end

    -- Since it is reference based :)
    local registry = draw.registry
    function base_metamethods:Remove()
        self.__INVALID = true
        -- 10/10 garbage collection ez
        if self.dynamic then
            self.dynamic.Visible = false
        end
        self.dynamic = nil
        self.point = nil
        self.points = nil
        for i=1, #registry do
            local v = registry[i]
            if v == self then
                table.remove(registry, i)
                break
            end
        end
    end

    -- Completely desintegrates everything
    function base_metamethods:Destroy()
        self.__INVALID = true
        if self.dynamic then
            self.dynamic.Visible = false
        end
        self.dynamic = nil
        self.point = nil
        local points = self.points
        for i=1, #points do
            local v = points[i]
            v:Remove()
        end
        self.points = nil
        for i=1, #registry do
            local v = registry[i]
            if v == self then
                table.remove(registry, i)
                break
            end
        end
    end
end

-- Metamethods are fun
-- Use this to add some fancy stuff to all your point objects
do
    local base_pointmetamethods = {}
    draw.base_pointmetamethods = base_pointmetamethods

    function base_pointmetamethods:Init() end

    function base_pointmetamethods:IsPoint()
        return true
    end

    -- Since it is reference based :)
    local registry = draw.point_registry
    function base_pointmetamethods:Remove()
        self.__INVALID = true
        self.point = nil
        for i=1, #registry do
            local v = registry[i]
            if v == self then
                table.remove(registry, i)
                break
            end
        end
    end
end

-- Registers a drawing dynamic system to this sub-system
-- See examples bellow
function draw:Register(generator, class, properties, metamethods, pointers)
    pointers = pointers or 1
    if properties then
        for k, v in pairs(self.base_properties) do
            if not properties[k] then
                properties[k] = v
            end
        end
    else
        properties = self.base_properties
    end
    if metamethods then
        metamethods = setmetatable(metamethods, {__index = self.base_metamethods})
    else
        metamethods = self.base_metamethods
    end
    self.classes[class] = {
        generator = generator,
        metamethods = metamethods,
        properties = properties,
        pointers = pointers
    }
end

-- Registers a point system to this sub-system
-- See examples bellow
function draw:RegisterPoint(generator, class, properties, metamethods)
    if properties then
        for k, v in pairs(self.base_pointproperties) do
            if not properties[k] then
                properties[k] = v
            end
        end
    else
        properties = self.base_pointproperties
    end
    if metamethods then
        metamethods = setmetatable(metamethods, {__index = self.base_metamethods})
    else
        metamethods = self.base_metamethods
    end
    local class_information = {
        generator = generator,
        metamethods = metamethods,
        properties = properties
    }
    self.point_classes[class] = class_information
    return class_information
end

-- If you want a class to have specific metamethods:
--[[
    local extramethods = {}

    function extramethods:Init()
        print("the line is created!")
    end

    draw:Register(LineDynamic.new, "Line", {
        ["Thickness"] = 2,
    }, extramethods, 2)
]]
draw:RegisterPoint(function(...)
    return PointOffset.new(Point2D.new(...))
end, "2V", {
    ["Offset"] = 2,
})
draw:RegisterPoint(Point2D.new, "2D", {
    ["PointVec2"] = 1,
    ["Point"] = 2,
})
draw:RegisterPoint(Point3D.new, "3D", {
    ["Point"] = 2,
})
draw:RegisterPoint(PointInstance.new, "Instance", {
    ["Instance"] = 2,
    ["Offset"] = 2,
    ["IgnoreRotation"] = 2,
    ["WorldPos"] = 2,
})
draw:RegisterPoint(PointMouse.new, "Mouse")
draw:RegisterPoint(PointOffset.new, "Offset", {
    ["Point"] = 2,
    ["Offset"] = 2,
})

draw:Register(LineDynamic.new, "Line", {
    ["Thickness"] = 2,
}, nil, 2)
draw:Register(PolyLineDynamic.new, "PolyLine", {
    ["Points"] = 2,
    ["FillType"] = 2,
    ["ReTriangulate"] = 0,
}, nil, math.huge)
draw:Register(TextDynamic.new, "Text", {
    ["Text"] = 2,
    ["TextBounds"] = 0,
    ["Size"] = 2,
    ["Position"] = 2,
    ["Font"] = 2,
    ["XAlignment"] = 2,
    ["YAlignment"] = 2,
    ["TextXAlignment"] = 2,
})
draw:Register(CircleDynamic.new, "Circle", {
    ["Thickness"] = 2,
    ["Radius"] = 2,
    ["NumSides"] = 2,
    ["Edge"] = 2,
    ["Filled"] = 2,
    ["Position"] = 2,
    ["XAlignment"] = 2,
    ["YAlignment"] = 2,
})
draw:Register(RectDynamic.new, "Rect", {
    ["Thickness"] = 2,
    ["Size"] = 2,
    ["Filled"] = 2,
    ["Rounding"] = 2,
    ["XAlignment"] = 2,
    ["YAlignment"] = 2,
})
draw:Register(GradientRectDynamic.new, "Gradient", {
    ["Thickness"] = 2,
    ["Size"] = 2,
    ["XAlignment"] = 2,
    ["YAlignment"] = 2,
    ["ColorUpperLeft"] = 2,
    ["ColorUpperRight"] = 2,
    ["ColorBottomLeft"] = 2,
    ["ColorBottomRight"] = 2,
})
draw:Register(ImageDynamic.new, "Image", {
    ["Image"] = 2,
    ["ImageSize"] = 0,
    ["Size"] = 2,
    ["Position"] = 2,
    ["Rounding"] = 2,
    ["XAlignment"] = 2,
    ["YAlignment"] = 2,
})

-- Hello are you around?
function draw:IsValid(object)
    return object and not object.__INVALID
end

local point_uniqueid = -1
-- Creates a point
function draw:CreatePoint(class, ...)
    local class_object = self.point_classes[class]
    if not class_object then
        error("draw:CreatePoint - No Such Class: " .. class)
        return
    end
    point_uniqueid = point_uniqueid + 1
    local meta = class_object.metamethods
    local properties = class_object.properties
    local object = setmetatable({
        point = class_object.generator(...),
        properties = properties,
        uniqueid = point_uniqueid,
        class = class,
        ispoint = true,
        traceback = debug.traceback()
    }, {
        __index = function(self, key)
            if in_index or rawget(self, "__INVALID") then return end

            local accessor = "get" .. key
            if meta[accessor] then
                if (properties[key] == 0 or properties[key] == 2) then
                    local ret = {meta[accessor](self, 0)}
                    return meta[accessor](self, 0)
                end
            elseif meta[key] then
                return meta[key]
            end

            local point = rawget(self, "point")
            if point and (properties[key] == 0 or properties[key] == 2) then return point[key] end
        end,
        __newindex = function(self, key, value)
            if rawget(self, "__INVALID") then return end
            local point = rawget(self, "point")
            if point and (properties[key] == 1 or properties[key] == 2) then
                if typeof(value) == 'Vector2' then
                    if value.Magnitude ~= value.Magnitude then
                        log(LOG_WARN, "WARNING - " .. tostring(self) .. " setting an invalid Vector2! (NAN)\nCREATE TR - " .. rawget(self, "traceback") .. "\nDIRECT TR - " .. debug.traceback())
                        return
                    end
                    if value.Magnitude >= math.huge then
                        log(LOG_WARN, "WARNING - " .. tostring(self) .. " setting an invalid Vector2! (INF)\nCREATE TR - " .. rawget(self, "traceback") .. "\nDIRECT TR - " .. debug.traceback())
                        return
                    end
                    if value.Magnitude <= -math.huge then
                        log(LOG_WARN, "WARNING - " .. tostring(self) .. " setting an invalid Vector2! (-INF)\nCREATE TR - " .. rawget(self, "traceback") .. "\nDIRECT TR - " .. debug.traceback())
                        return
                    end
                end
                local mutator = "set".. key
                if meta[mutator] then
                    meta[mutator](self, value)
                else
                    point[key] = value
                end
            end
            if not properties[key] then
                rawset(self, key, value)
            end
        end,
        __tostring = function(self)
            return "Point: " .. self.class .. "#" .. self.uniqueid
        end
    })
    local registry = draw.point_registry
    registry[#registry+1] = object
    object:Init()
    return object
end

-- Creates a drawing dynamic object
-- Example,
--[[
    local line = draw:Create("Line", "2V", "2V")
    line.Color = Color3.new(1,1,1)
    -- note how Point is renamed to Point1 and Point2
    -- if there is more than one point in the dynamic, it will do this
    line.Point1 = UDim2.new(0,0,.5,0)
    line.Point2 = UDim2.new(.5,0,.5,0)

    -- PolyLine can have as many points, so this goes on... and on...
    local poly = draw:Create("PolyLine", "2V", "2V", "2V")
    poly.Point1 = UDim2.new(0,0,.5,0)
    poly.Point2 = UDim2.new(.5,0,.5,0)
    poly.Point3 = UDim2.new(.5,0,0,0)

    -- if you need to iterate through points,
    for i=1, #poly.points do
        local point = poly.points[i]
        -- this is now the point objects
        -- so you can access with the numbers at the end like so
        -- point.Point = whatever the fuck
    end

    -- want to remove?
    wait(5)
    poly:Remove()
    line:Remove()
]]

local uniqueid = -1
function draw:Create(class, ...)
    local class_object = self.classes[class]
    if not class_object then
        error("draw:Create - No Such Class: " .. class)
        return
    end
    uniqueid = uniqueid + 1
    local meta = class_object.metamethods
    local properties = class_object.properties
    local pointers = class_object.pointers

    local object = {
        uniqueid = uniqueid,
        class = class,
        properties = properties,
        pointers = pointers,
        isdraw = true,
        traceback = debug.traceback()
    }

    local args = {...}
    if pointers > 1 then
        local args_sub = {}
        for i=pointers+1, #args do
            args_sub[#args_sub+1] = args[i]
        end
        local points = {}
        local points_ = {}
        for i=1, pointers do
            local pointer_class = args[i]
            if not pointer_class then break end
            local point = self:CreatePoint(pointer_class, unpack(args_sub))
            object["point" .. i] = point
            points_[#points_+1] = point
            points[#points+1] = point.point
        end
        object.points = points_
        if class == "PolyLine" then
            object.dynamic = class_object.generator(points)
        else
            object.dynamic = class_object.generator(unpack(points))
        end
    else
        local pointer_class = args[1]
        local args_sub = {}
        for i=2, #args do
            args_sub[#args_sub+1] = args[i]
        end
        local point = self:CreatePoint(args[1], unpack(args_sub))
        object.point = point
        object.points = {point}
        object.dynamic = class_object.generator(point.point)
    end

    object = setmetatable(object, {
        __index = function(self, key)
            if rawget(self, "__INVALID") then return end

            local accessor = "get" .. key
            if meta[accessor] then
                if (properties[key] == 0 or properties[key] == 2) then
                    local ret = {meta[accessor](self, 0)}
                    return meta[accessor](self, 0)
                end
            elseif meta[key] then
                return meta[key]
            end

            local dynamic = rawget(self, "dynamic")
            if dynamic and (properties[key] == 0 or properties[key] == 2) then return dynamic[key] end
            local point
            if pointers > 1 then
                point = rawget(self, "point" .. string.sub(key, #key))
                key = string.sub(key, 1, #key-1)
            else
                point = rawget(self, "point")
            end
            if point and point[key] ~= nil then return point[key] end
        end,
        __newindex = function(self, key, value)
            if rawget(self, "__INVALID") then return end
            local dynamic = rawget(self, "dynamic")
            if dynamic and (properties[key] == 1 or properties[key] == 2) then
                local mutator = "set".. key
                if meta[mutator] then
                    meta[mutator](self, value)
                else
                    dynamic[key] = value
                end
                return
            end
            local point
            if pointers > 1 then
                point = rawget(self, "point" .. string.sub(key, #key))
                key = string.sub(key, 1, #key-1)
            else
                point = rawget(self, "point")
            end
            if point and point[key] ~= nil then
                point[key] = value
                return
            end
            if not properties[key] then
                rawset(self, key, value)
            end
        end,
        __tostring = function(self)
            return "Draw: " .. self.class .. "#" .. self.uniqueid
        end
    })

    local registry = self.registry
    registry[#registry+1] = object
    object:Init()
    return object
end

-- Creates a new object with the same properties with new similar points
-- DOES NOT COPY POINT PROPERTIES
function draw:Clone(object)
    local point_classes = {}
    local pointers = object.points
    for i=1, #pointers do
        point_classes[#point_classes+1] = pointers[i].class
    end
    local new_object = self:Create(object.class, unpack(point_classes))
    for k, v in pairs(object.properties) do
        if v ~= 2 then continue end
        if k == "Point" or k == "Points" or k == "Position" then continue end
        new_object.dynamic[k] = object.dynamic[k]
    end
    return new_object
end

-- Creates a new object with the same properties and copies properties of points
-- NOT TESTED DUE TO SYN 2021 BEING DOWN REEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
function draw:DeepClone(object)
    local point_classes = {}
    local point_properties = {}
    local pointers = object.points
    for i=1, #pointers do
        local point = pointers[i]
        point_classes[#point_classes+1] = point.class
        local properties = {}
        for k, v in pairs(point.properties) do
            if v ~= 2 then continue end
            properties[k] = point.point[k]
        end
        point_properties[#point_properties+1] = properties
    end
    local new_object = self:Create(object.class, unpack(point_classes))
    local len = #point_properties
    if len > 1 then
        for i=1, len do
            local properties = point_properties[i]
            local point = new_object["point" .. i]
            for k, v in pairs(properties) do
                point.point[k] = v
            end
        end
    else
        local properties = point_properties[1]
        local point = new_object["point"]
        for k, v in pairs(properties) do
            point.point[k] = v
        end
    end
    for k, v in pairs(object.properties) do
        if v ~= 2 then continue end
        new_object.dynamic[k] = object.dynamic[k]
    end
    return new_object
end

-- Allow hot-loading the script over and over...
-- Replace this with your own way of doing this
hook:Add("Unload", "BBOT:Draw.Remove", function()
    local registry = draw.registry
    local schedule_remove = {}
    for i=1, #registry do
        local v = registry[i]
        if v.__INVALID then continue end
        schedule_remove[#schedule_remove+1] = v
    end

    registry = draw.point_registry
    for i=1, #registry do
        local v = registry[i]
        if v.__INVALID then continue end
        schedule_remove[#schedule_remove+1] = v
    end

    for i=1, #schedule_remove do
        local v = schedule_remove[i]
        if not v or v.__INVALID then continue end
        v:Remove()
    end
end)

return draw