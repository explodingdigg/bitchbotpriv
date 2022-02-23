local localplayer = BBOT.service:GetService("LocalPlayer")
local camera = BBOT.service:GetService("CurrentCamera")
local config = BBOT.config
local network = BBOT.aux.network
local char = BBOT.aux.char
local roundsystem = BBOT.aux.roundsystem
local pathing = BBOT.pathing
local drawpather = BBOT.drawpather
local hook = BBOT.hook
local repupdate = {}
BBOT.repupdate = repupdate

local map = BBOT.service:GetService("Workspace"):FindFirstChild("Map")
local map_center, map_min, map_max
if map then
    local cf, bounds = map:GetBoundingBox()
    map_center = cf.p
    map_min = map_center - 0.5 * bounds
    map_max = map_center + 0.5 * bounds
end

-- Detour 'newmap' for restricting repupdate to the inside of map bounds
hook:Add("Initialize", "BBOT:Newmap.Detour", function()
    for hash, func in next, network.receivers do
        local consts = getconstants(func)
        if BBOT.table.quicksearch(consts, "AGMP") then
            -- we found newmap
            hook:BindFunction(func, "Newmap")
            -- hook onto it so we can do stuff
            hook:Add("PreNewmap", "BBOT:Newmap.SetBounds", function(map)
                local cf, bounds = map:GetBoundingBox()
                map_center = cf.p
                map_min = map_center - 0.5 * bounds
                map_max = map_center + 0.5 * bounds
            end)
            return
        end
    end
end)

-- this is the raycasting for replication, kinda like the server-side version
-- function -> repupdate:Raycast(origin, offset)
do
    local rcastparam = RaycastParams.new();
    rcastparam.IgnoreWater = true;

    -- this is the raycasting for replication, kinda like the server-side version
    function repupdate:Raycast(origin, offset, extra, callback)
        local whitelist = { workspace.Ignore, workspace.Players, extra }
        local results
        local calls = 0
        rcastparam.FilterDescendantsInstances = whitelist;
        while calls < 2000 do
            results = workspace:Raycast(origin, offset, rcastparam)
            if not results then break end
            local instance = results.Instance
            if instance.Name ~= "Window" and instance.CanCollide and instance.Transparency ~= 1 then
                break
            end
            if callback and not callback(results) then break end
            table.insert(whitelist, results.Instance)
            rcastparam.FilterDescendantsInstances = whitelist
            calls = calls + 1
        end;
        return results
    end
end

-- current position of our replication server-side
function repupdate:GetPosition()
    return self.position or char.rootpart.Position
end

-- check if position is within map bounds (used for teleporting and stuff)
function repupdate:IsPosWithinMapBounds(p)
    p = p or self:GetPosition()
    return p.x > map_min.x and p.x < map_max.x
        and p.y > map_min.y and p.y < map_max.y
        and p.z > map_min.z and p.z < map_max.z
end

-- return the closest point from 'p' to the map's bounding box
function repupdate:ClampPosToMapBounds(p)
    p = p or self:GetPosition()
    local x = p.x < map_min.x and map_min.x or math.min(p.x, map_max.x)
    local y = p.y < map_min.y and map_min.y or math.min(p.y, map_max.y)
    local z = p.z < map_min.z and map_min.z or math.min(p.z, map_max.z)
    return Vector3.new(x, y, z)
end

-- can we move to this position?
function repupdate:CanMoveTo(position)
    local lastpos = self:GetPosition()
    local stanceoffset = self:GetStanceOffset()
    local occupied = self:Raycast(lastpos+stanceoffset, position-lastpos+stanceoffset)
    if occupied then return false else return true end
end

-- if we cannot move to a position, find the minimum that we can travel (this is like a TP scanning thing)
function repupdate:FindMinimumMoveTo(position)
    local lastpos = self:GetPosition()
    local stanceoffset = self:GetStanceOffset()
    local offset = position-lastpos
    local results = self:Raycast(lastpos+stanceoffset, offset+stanceoffset)
    if results then
        return true, results.Position - (offset.Unit * 0.1) - stanceoffset, offset.Unit
    end
    return false, position, offset.Unit
end

local dot = Vector3.zero.Dot
-- moves the player to a position, basially teleport
function repupdate:MoveTo(position, move_char)
    if not char.alive then return end
    local current_position = self:GetPosition()
    if not self:CanMoveTo(position) then return end

    local diff = (position-current_position)

    if dot(diff, diff) > 81 --[[ diff.Magnitude > 8]] then
        local mag = diff.magnitude
        local unit = diff / mag
        for dt = 9, mag, 9 do
            network:send("repupdate", current_position + dt * unit, repupdate.angle or Vector2.new(), tick())
        end
        --[[local timescale = math.round(diff.Magnitude/8)+1
        local tdiff = diff/timescale
        for i=1, timescale do
            network:send("repupdate", current_position + (tdiff*i), repupdate.angle or Vector2.new(), tick())
        end]]
    end

    network:send("repupdate", position, repupdate.angle or Vector2.new(), tick())

    if move_char then
        char.rootpart.CFrame = CFrame.new(current_position + diff, char.rootpart.CFrame.LookVector)
    end
    self.position = position -- i cant believe this wasnt being set
end

-- this only moves the character (roblox) and not repupdate
function repupdate:MoveCharTo(position)
    if not char.alive then return end
    local current_position = self:GetPosition()
    if not self:CanMoveTo(position) then return end
    local diff = (position-current_position)
    char.rootpart.CFrame = CFrame.new(current_position + diff, char.rootpart.CFrame.LookVector)
end

do
    local rcastparam = RaycastParams.new()
    rcastparam.IgnoreWater = true
    rcastparam.FilterType = Enum.RaycastFilterType.Blacklist

    local pather = pathing.new()
    pather:SetWaypointSpacing(8)
    pather:SetRaycastParameter(rcastparam)
    pather:SetRaycastCallback(function(results)
        local p = results.Instance
        if p.Name:lower() == "killwall" then
            return false
        end
        if not p.CanCollide then
            return true
        end
        if p.Name ~= "Window" then
            return false
        end
        return true
    end)

    function repupdate:TeleportTo(position, move_char)
        if not char.alive then return end
        rcastparam.FilterDescendantsInstances = {workspace.Terrain, localplayer.Character, workspace.Ignore, workspace.Players}
        local current_position = self:GetPosition()
        local stanceoffset = self:GetStanceOffset()
        pather:SetRaycastOffset(stanceoffset)
        pather:SetFrom(current_position)
        pather:SetTo(position)
        local path, success = pather:Calculate()
        if success then
            for i=1, #path do
                repupdate:MoveTo(path[i]-stanceoffset, move_char)
            end
        end
        return path, success
    end
end

function repupdate:PathTo(path, move_char, reverse)
    for i = (reverse and #path or 1), (reverse and 1 or #path), (reverse and -1 or 1) do
        repupdate:MoveTo(path[i], move_char)
    end
end

-- forces the replication system to update regardless
function repupdate:Force(pos, ang)
    local l__angles__1304 = BBOT.aux.camera.angles;
    network:send("repupdate", pos or char.rootpart.Position, ang or Vector2.new(l__angles__1304.x, l__angles__1304.y), tick())
end

local invis_set, invis_time = false, 0
hook:Add("OnAliveChanged", "BBOT:RepUpdate.Invis", function(alive)
    if not alive then
        invis_set = true
        invis_time = 0
    end
end)

-- get's the tick or manipulates the input tick [t] to repupdate's tick
function repupdate:Tick(t)
    t = t or tick()
    if config:GetValue("Main", "Misc", "Exploits", "Invisibility") then
        if invis_set then
            invis_time = t
            invis_set = false
        end
        t = (t - invis_time) * (0.1^128) -- ^ -99 is wat we want
    elseif config:GetValue("Main", "Misc", "Exploits", "Tick Manipulation") then
        local scalar = (config:GetValue("Main", "Misc", "Exploits", "Higher Division") and 10 or 1)
        return (t/(10^(config:GetValue("Main", "Misc", "Exploits", "Tick Division Scale")*scalar)))
    end
    return t
end	

-- stances
do
    local fake_stance = false
    hook:Add("SuppressNetworkSend", "BBOT:RepUpdate.Stance", function(netname, mode)
        if netname == "stance" and config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance") ~= "Off" and not fake_stance then
            return true
        end
    end)

    hook:Add("OnConfigChanged", "BBOT:RepUpdate.Stance", function(steps, old, new)
        if not char.alive then return end
        if not config:IsPathwayEqual(steps, "Main", "Rage", "Anti Aim", "Fake Stance") then return end
        if new ~= "Off" then
            if char.movementmode ~= "prone" then
                fake_stance = true
                network:send("stance", string.lower(new));
                fake_stance = false
            end
        elseif char.movementmode ~= string.lower(new) then
            network:send("stance", char.movementmode);
        end
    end)

    hook:Add("OnAliveChanged", "BBOT:RepUpdate.Stance", function(alive)
        if not alive then return end
        local stance = config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance")
        if stance ~= "Off" then
            fake_stance = true
            network:send("stance", string.lower(stance))
            fake_stance = false
        end
    end)

    function repupdate:GetStance()
        local stance = config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance")
        if stance ~= "Off" then
            return string.lower(stance)
        end
        return char.movementmode
    end

    local vec0 = Vector3.new(0,0,0)
    local stand = Vector3.new(0,1.5,0) -- those values were not right bruh????????
    local crouch = Vector3.new(0,0,0)
    local prone = Vector3.new(0,-1.5,0)
    function repupdate:GetStanceOffset()
        local stance = self:GetStance()
        if stance == "stand" then
            return stand
        elseif stance == "crouch" then
            return crouch
        elseif stance == "prone" then
            return prone
        end
        return vec0
    end
end

-- blink (internal, we recommend scripts to not touch these)
repupdate.blink_record = {}
repupdate.blink_sending = false
repupdate.blink_ignore = false
repupdate.blink_active = false
repupdate.blink_last = 0

function repupdate:BlinkUpdate()
    self.blink_sending = true
    local blink_record = self.blink_record
    if #blink_record > 0 then
        local a = {}
        local len = #blink_record
        for i=1, len do
            network:send("repupdate", blink_record[i][1], blink_record[i][2], blink_record[i][3])
            a[#a+1]=blink_record[i][1]
        end
        local col, transparency = config:GetValue("Main", "Misc", "Exploits", "Blink", "Path Color")
        if transparency > 0 then
            drawpather:Simple(a, col, transparency, 4)
        end
    end
    self.blink_record = {}
    self.blink_sending = false
    self.blink_active = false
    self.blink_nextbuffer = math.random(config:GetValue("Main", "Misc", "Exploits", "Blink Min Buffer")*10000, config:GetValue("Main", "Misc", "Exploits", "Blink Max Buffer")*10000)/10000
end

hook:Add("Aimbot.NewBullets", "BBOT:RepUpdate.Blink.OnFire", function()
    if repupdate.blink_active and config:GetValue("Main", "Misc", "Exploits", "Blink On Fire") then
        BBOT.menu:UpdateStatus("Blink", "Buffering...")
        repupdate:BlinkUpdate()
    end
end)

hook:Add("PreNetworkSend", "BBOT:RepUpdate.Blink.OnFire", function(netname)
    if netname == "newbullets" then
        if repupdate.blink_active and config:GetValue("Main", "Misc", "Exploits", "Blink On Fire") then
            BBOT.menu:UpdateStatus("Blink", "Buffering...")
            repupdate:BlinkUpdate()
        end
    end
end)

-- spaz attack
hook:Add("OnKeyBindChanged", "BBOT:RepUpdate.SpazAttack", function(steps, old, new)
    if not config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Spaz Attack", "KeyBind") then return end
    if new then return end
    if not char.alive then return end
    repupdate:MoveTo(char.rootpart.Position)
end)

-- calculations
hook:Add("SuppressNetworkSend", "BBOT:RepUpdate.Calculate", function(netname, pos, ang, time)
    if netname ~= "repupdate" then return end
    if not repupdate.alive then
        repupdate.blink_record = {}
        repupdate.blink_sending = false
        repupdate.blink_active = false
        repupdate.blink_last = tick()
        repupdate.blink_nextbuffer = nil
        return
    end

    if config:GetValue("Main", "Misc", "Exploits", "Blink") and config:GetValue("Main", "Misc", "Exploits", "Blink", "KeyBind") then
        if BBOT.aimbot.tp_scanning then
            if repupdate.blink_active then
                repupdate:BlinkUpdate()
                repupdate.blink_active = false
                repupdate.blink_nextbuffer = nil
            end
            return
        end

        if not repupdate.blink_ignore and not repupdate.blink_sending then
            local t = repupdate.blink_nextbuffer or config:GetValue("Main", "Misc", "Exploits", "Blink Min Buffer")
            if repupdate.blink_record[1] and repupdate.blink_last + t < tick() and t > 0 then
                BBOT.menu:UpdateStatus("Blink", "Buffering...")
                repupdate:BlinkUpdate()
                repupdate.blink_sending = true
                network:send(netname, pos, ang, time)
                repupdate.blink_sending = false
                repupdate.blink_last = tick()
                repupdate.blink_active = false
                repupdate.blink_nextbuffer = math.random(config:GetValue("Main", "Misc", "Exploits", "Blink Min Buffer")*10000, config:GetValue("Main", "Misc", "Exploits", "Blink Max Buffer")*10000)/10000
            else
                BBOT.menu:UpdateStatus("Blink", "Active"
                .. (t > 0 and " [" .. math.abs(math.round(repupdate.blink_last+t-tick(),1)) .. "s]" or "")
                .. (allowmove and " [" .. math.round((pos-repupdate:GetPosition()).Magnitude, 1) .. " studs]" or ""))
                repupdate.blink_active = true
                local blink_record = repupdate.blink_record
                blink_record[#blink_record+1] = {pos, ang, time}
            end
            return true
        end
    elseif #repupdate.blink_record > 0 then
        repupdate:BlinkUpdate()
        repupdate.blink_last = tick()
        repupdate.blink_active = false
    else
        repupdate.blink_last = tick()
        repupdate.blink_active = false
        repupdate.blink_nextbuffer = nil
    end
end)

repupdate.spaz_active = false
repupdate.antiaim_stutterframes = 0
hook:Add("PreNetworkSend", "BBOT:RepUpdate.Calculate", function(netname, pos, ang, time)
    if netname ~= "repupdate" then return end
    local modified, tick_changed = false, false
    if not BBOT.aimbot.in_ragebot and not BBOT.aimbot.tp_scanning then
        if config:GetValue("Main", "Misc", "Exploits", "Spaz Attack") and config:GetValue("Main", "Misc", "Exploits", "Spaz Attack", "KeyBind") and not repupdate.spaz_active then
            local intensity = config:GetValue("Main", "Misc", "Exploits", "Spaz Attack Intensity")
            local offset = Vector3.new(math.random(-1000,1000)/1000, math.random(-1000,1000)/1000, math.random(-1000,1000)/1000)*config:GetValue("Main", "Misc", "Exploits", "Spaz Attack Intensity")
            local results = BBOT.aimbot:raycastbullet(pos, offset)
            if results then
                offset = offset - (offset.Unit * 2)
            end
            pos = pos + offset
            repupdate.spaz_active = true
            repupdate:MoveTo(pos - (offset.Unit/100))
            repupdate.spaz_active = false
            time = repupdate:Tick()
            tick_changed = true
            modified = true
        end

        local infloor = config:GetValue("Main", "Rage", "Anti Aim", "In Floor")
        if infloor > 0 then
            pos = pos + Vector3.new(0,-infloor,0)
            modified = true
        end
    end
    
    if config:GetValue("Main", "Rage", "Anti Aim", "Enabled") then
        repupdate.antiaim_stutterframes += 1
        local pitch = ang.x
        local yaw = ang.y
        local pitchChoice = config:GetValue("Main", "Rage", "Anti Aim", "Pitch")
        local yawChoice = config:GetValue("Main", "Rage", "Anti Aim", "Yaw")
        local spinRate = config:GetValue("Main", "Rage", "Anti Aim", "Spin Rate")

        ---"off,down,up,roll,upside down,random"
        --"Off", "Up", "Zero", "Down", "Upside Down", "Roll Forward", "Roll Backward", "Random", "Bob", "Glitch",
        local new_angles
        if pitchChoice == "Up" then
            pitch = -4
        elseif pitchChoice == "Zero" then
            pitch = 0
        elseif pitchChoice == "Down" then
            pitch = 4.7
        elseif pitchChoice == "Upside Down" then
            pitch = -math.pi
        elseif pitchChoice == "Roll Forward" then
            pitch = (tick() * spinRate) % 6.28
        elseif pitchChoice == "Roll Backward" then
            pitch = (-tick() * spinRate) % 6.28
        elseif pitchChoice == "Random" then
            pitch = math.random(-99999,99999)/99999
            pitch = pitch*1.47262156
        elseif pitchChoice == "Bob" then
            pitch = math.sin((tick() % 6.28) * spinRate)
        elseif pitchChoice == "Glitch" then
            pitch = 2 ^ 127 + 1
        end

        --"Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin"
        if yawChoice == "Backward" then
            yaw += math.pi
        elseif yawChoice == "Spin" then
            yaw = (tick() * spinRate) % 360
        elseif yawChoice == "Random" then
            yaw = math.random(-99999,99999)
        elseif yawChoice == "Glitch Spin" then
            yaw = 16478887
        elseif yawChoice == "Invisible" then
            yaw = (2.0^127) + 2
        elseif yawChoice == "Stutter Spin" then
            yaw = repupdate.antiaim_stutterframes % (6 * (spinRate / 4)) >= ((6 * (spinRate / 4)) / 2) and 2 or -2
        end

        ang = Vector2.new(math.clamp(pitch, -1.47262156, 1.47262156), yaw)
        modified = true
    end

    if modified then
        return netname, pos, ang, (tick_changed and time or repupdate:Tick(time))
    else
        return netname, pos, ang, repupdate:Tick(time)
    end
end)

hook:Add("OnAliveChanged", "BBOT:RepUpdate.Alive", function(alive)
    if not alive then
        repupdate.position = nil
        repupdate.angle = nil
        repupdate.time = nil
        repupdate.alive = false
    end
end)

hook:Add("PostNetworkSend", "BBOT:RepUpdate.Calculate", function(netname, pos, ang, time)
    if netname ~= "repupdate" then return end
    repupdate.position = pos
    repupdate.angle = ang
    repupdate.time = time
    repupdate.alive = true
end)