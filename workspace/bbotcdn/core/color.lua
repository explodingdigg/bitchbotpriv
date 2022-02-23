local math = BBOT.math
local table = BBOT.table
local string = BBOT.string
local color = {}

function color.range(value, ranges) -- ty tony for dis function u a homie
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
        math.lerp(lerpValue, minColor.color.r, maxColor.color.r),
        math.lerp(lerpValue, minColor.color.g, maxColor.color.g),
        math.lerp(lerpValue, minColor.color.b, maxColor.color.b)
    )
end

-- I also wish we could just add this to the Color3 metatable...
function color.mul(col, mult)
    return Color3.new(col.R * mult, col.G * mult, col.B * mult)
end

function color.add(col, num)
    return Color3.new(col.R + num, col.G + num, col.B + num)
end

function color.darkness(col, scale)
    local h, s, v = Color3.toHSV(col)
    return Color3.fromHSV(h, s, v*scale)
end

function color.tostring(col, trans)
    return math.round(col.r*255) .. ", " .. math.round(col.g*255) .. ", " .. math.round(col.b*255) .. ", " .. math.round((trans or 1)*255)
end

function color.fromstring(str)
    local color_table = string.Explode(",", str)
    local r, g, b, a = tonumber(color_table[1]), tonumber(color_table[2]), tonumber(color_table[3]), (tonumber(color_table[4]) or 255)/255
    if not r or not g or not b then
        return false
    end
    r = math.clamp(r, 0, 255)
    g = math.clamp(g, 0, 255)
    b = math.clamp(b, 0, 255)
    a = math.clamp(a, 0, 255)
    return Color3.fromRGB(r, g, b), a
end

function color.tohex(col)
    return string.format("#%02X%02X%02X", col.r * 255, col.g * 255, col.b * 255)
end

function color.fromhex(hex)
    local r, g, b = string.match(hex, "^#?(%w%w)(%w%w)(%w%w)$")
    if not r or not g or not b then return false end
    return Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end

return color