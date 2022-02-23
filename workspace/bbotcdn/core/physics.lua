local vec0 = Vector3.new()
local dot = vec0.Dot
local vector = BBOT.vector
local math = BBOT.math
local physics = {}

-- Used to determine the time of the bullet hitting, more like an assumption to be honest since you
-- have a range which is basically max > t > min
function physics.timehit(pos_f, v_i, g, pos_i)
    local delta_d = pos_f - pos_i;
    local roots = { math.quartic(dot(g, g), 3 * dot(g, v_i), 2 * (dot(g, delta_d) + dot(v_i, v_i)), 2 * dot(delta_d, v_i)) };
    local min = 0;
    local max = (1 / 0);
    for v37 = 1, #roots do
        local t = roots[v37];
        local t_max = (delta_d + t * v_i + t * t / 2 * g).magnitude;
        if min < t and t_max < max then
            min = t;
            max = t_max;
        end;
    end;
    return min, max;
end;

-- used to find a unit vector of theta in projectile motion of a 3D space
function physics.trajectory(pos_i, g, pos_f, v_i)
    local delta_d = pos_f - pos_i
    g = -g
    -- btw dot of itself is basically vector^2
    local r_1, r_2, r_3, r_4 = math.quartic(dot(g, g) / 4, 0, dot(g, delta_d) - v_i * v_i, 0, dot(delta_d, delta_d))
    if r_1 and r_1 > 0 then
        return g * r_1 / 2 + delta_d / r_1, r_1
    end;
    if r_2 and r_2 > 0 then
        return g * r_2 / 2 + delta_d / r_2, r_2
    end;
    if r_3 and r_3 > 0 then
        return g * r_3 / 2 + delta_d / r_3, r_3
    end;
    if not r_4 or not (r_4 > 0) then
        return;
    end;
    return g * r_4 / 2 + delta_d / r_4, r_4
end

return physics