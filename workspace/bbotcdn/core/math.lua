local table = BBOT.table
local math = table.deepcopy(math)

function math.lerp(delta, from, to) -- wtf why were these globals thats so exploitable!
    if (delta > 1) then
        return to
    end
    if (delta < 0) then
        return from
    end
    return from + (to - from) * delta
end

-- Remaps a value to new min and max
function math.remap( value, inMin, inMax, outMin, outMax ) -- ty gmod
    return outMin + ( ( ( value - inMin ) / ( inMax - inMin ) ) * ( outMax - outMin ) )
end

function math.round( num, idp ) -- ty gmod again
    local mult = 10 ^ ( idp or 0 )
    return math.floor( num * mult + 0.5 ) / mult
end

-- floor to nearest multiple of x
function math.multfloor( num, x )
    return num - (num % x)
end

-- ceil to nearest multiple of x
function math.multceil( num, x )
    return num + (num % x)
end

function math.average(t)
    local sum = 0
    for i=1, #t do -- Get the sum of all numbers in t
        sum = sum + t[i]
    end
    return sum / #t
end

function math.clamp(a, lowerNum, higher) -- DONT REMOVE this clamp is better then roblox's because it doesnt error when its not lower or heigher
    if a > higher then
        return higher
    elseif a < lowerNum then
        return lowerNum
    else
        return a
    end
end

function math.timefraction( Start, End, Current )
    return ( Current - Start ) / ( End - Start )
end

function math.approach( cur, target, inc )
    inc = math.abs( inc )
    if ( cur < target ) then
        return math.min( cur + inc, target )
    elseif ( cur > target ) then
        return math.max( cur - inc, target )
    end
    return target
end

local err = 1.0E-10;
local _1_3 = 1/3;
local _sqrt_3 = math.sqrt(3);

-- ax + b (real roots)
function math.linear(a, b) -- do I even need this? -- yea probably lol
    return -b / a;
end

-- ax^2 + bx + c (real roots)
function math.quadric(a, b, c)
    local k = -b / (2 * a);
    local u2 = k * k - c / a;
    if u2 > -err and u2 < err then
        return;
    else
        local u = u2 ^ 0.5;
        return k - u, k + u;
    end
end

-- ax^3 + bx^2 + cx + d (real roots)
function math.cubic(a, b, c, d)
    local k = -b / (3 * a);
    local p = (3 * a * c - b * b) / (9 * a * a);
    local q = (2 * b * b * b - 9 * a * b * c + 27 * a * a * d) / (54 * a * a * a);
    local r = p * p * p + q * q;
    local s = r ^ 0.5 + q;
    if s > -err and s < err then
        if q < 0 then
            return k + (-2 * q) ^ _1_3;
        else
            return k - (2 * q) ^ _1_3;
        end
    elseif r < 0 then
        local m = (-p) ^ 0.5
        local d = math.atan2((-r) ^ 0.5, q) / 3;
        local u = m * math.cos(d);
        local v = m * math.sin(d);
        return k - 2 * u, k + u - _sqrt_3 * v, k + u + _sqrt_3 * v;
    elseif s < 0 then
        local m = -(-s) ^ _1_3;
        return k + p / m - m;
    else
        local m = s ^ _1_3;
        return k + p / m - m;
    end
end

-- ax^4 + bx^3 + cx^2 + dx + e (real roots)
local quadric, cubic = math.quadric, math.cubic
function math.quartic(a, b, c, d, e)
    local k = -b / (4 * a);
    local p = (8 * a * c - 3 * b * b) / (8 * a * a);
    local q = (b * b * b + 8 * a * a * d - 4 * a * b * c) / (8 * a * a * a);
    local r = (16 * a * a * b * b * c + 256 * a * a * a * a * e - 3 * a * b * b * b * b - 64 * a * a * a * b * d) / (256 * a * a * a * a * a);
    local h0, h1, h2 = cubic(1, 2 * p, p * p - 4 * r, -q * q);
    local s = h2 or h0;
    if s < err then
        local f0, f1 = quadric(1, p, r);
        if not f1 or f1 < 0 then
            return;
        else
            local f = f1 ^ 0.5;
            return k - f, k + f;
        end
    else
        local h = s ^ 0.5;
        local f = (h * h * h + h * p - q) / (2 * h);
        if f > -err and f < err then
            return k - h, k;
        else
            local r0, r1 = quadric(1, h, f);
            local r2, r3 = quadric(1, -h, r / f);
            if r0 and r2 then
                return k + r0, k + r1, k + r2, k + r3;
            elseif r0 then
                return k + r0, k + r1;
            elseif r2 then
                return k + r2, k + r3;
            else
                return;
            end
        end
    end
end

return math