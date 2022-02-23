local vec0 = Vector3.new()
local dot = vec0.Dot
local math = BBOT.math
local vector = {}

-- I also wish we could just add this to the Vector3 metatable...
function vector.rotate(Vec, Rads)
    local vec = Vec.Unit
    --x2 = cos β x1 − sin β y1
    --y2 = sin β x1 + cos β y1
    local sin = math.sin(Rads)
    local cos = math.cos(Rads)
    local x = (cos * vec.x) - (sin * vec.y)
    local y = (sin * vec.x) + (cos * vec.y)

    return Vector2.new(x, y).Unit * Vec.Magnitude
end

-- msg from cream - this is called pythagorean theorem btw, the guy you found it from doesn't know math...
function vector.dist2d ( pos1, pos2 )
    local dx = pos1.X - pos2.X
    local dy = pos1.Y - pos2.Y
    return math.sqrt ( dx * dx + dy * dy )
end

-- creates a random point around a sphere
function vector.randomspherepoint(radius)
    local theta = math.random() * 2 * math.pi
    local phi = math.acos(2 * math.random() - 1)
    return Vector3.new(radius * math.sin(phi) * math.cos(theta), radius * math.sin(phi) * math.sin(theta), radius * math.cos(phi))
end

-- clamps the vector to a desired magnitude
function vector.clamp(vec, min, max)
    if not max then
        max = min
        min = -math.huge
    end
    local unit = vec.Unit
    local magnitude = vec.Magnitude
    if magnitude < min then
        vec = unit * min
    elseif magnitude > max then
        vec = unit * max
    end
    return vec
end

function vector.floor(vec, spacing)
    return Vector3.new(vec.x - (vec.x % spacing), vec.y - (vec.y % spacing), vec.z - (vec.z % spacing))
end

return vector