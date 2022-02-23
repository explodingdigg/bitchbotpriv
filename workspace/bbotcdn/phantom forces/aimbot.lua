local timer = BBOT.timer
local hook = BBOT.hook
local config = BBOT.config
local network = BBOT.aux.network
local gamelogic = BBOT.aux.gamelogic
local math = BBOT.math
local vector = BBOT.vector
local char = BBOT.aux.char
local hud = BBOT.aux.hud
local log = BBOT.log
local draw = BBOT.draw
local replication = BBOT.aux.replication
local extras = BBOT.extras
local physics = BBOT.physics
local raycast = BBOT.aux.raycast
local roundsystem = BBOT.aux.roundsystem
local repupdate = BBOT.repupdate
local cam = BBOT.aux.camera
local localplayer = BBOT.service:GetService("LocalPlayer")
local userinputservice = BBOT.service:GetService("UserInputService")
local players = BBOT.service:GetService("Players")
local camera = BBOT.service:GetService("CurrentCamera")
local mouse = BBOT.service:GetService("Mouse")
local aux_camera = BBOT.aux.camera
local aimbot = {}

do
    local table = BBOT.table
    local receivers = network.receivers
    for netindex, callback in next, receivers do
        local const = debug.getconstants(callback)
        if table.quicksearch(const, "firepos") and table.quicksearch(const, "bullets") and table.quicksearch(const, "bulletcolor") and table.quicksearch(const, "penetrationdepth") then
            hook:Add("PreNetworkReceive", "BBOT:NewBullets.Network", function(netname, ...)
                if netname == netindex then
                    hook:Call("PreNewBullets", ...)
                end
            end)
            hook:Add("PostNetworkReceive", "BBOT:NewBullets.Network", function(netname, ...)
                if netname == netindex then
                    hook:Call("PostNewBullets", ...)
                end
            end)
        end
    end
end

do
    local function raycastbullet(p1)
        local instance = p1.Instance
        if instance.Name == "Window" then return true end
        return not instance.CanCollide or instance.Transparency == 1
    end

    local workspace = BBOT.service:GetService("Workspace")
    local v4 = RaycastParams.new();
    v4.IgnoreWater = true;
    function aimbot:fullcast(p7, p8, p9, p10, p11)
        local v3=nil;
        local calls = 0;
        v4.FilterDescendantsInstances = p9;
        while calls < 2000 do
            v3 = workspace:Raycast(p7, p8, v4);
            if not v3 or not p10(v3) then
                break;
            end;
            table.insert(p9, v3.Instance);
            v4.FilterDescendantsInstances = p9;
            calls = calls + 1
        end;
        return v3;
    end;

    local camera = BBOT.service:GetService("CurrentCamera")
    function aimbot:raycastbullet(vec, dir, extra, cb)
        return aimbot:fullcast(vec, dir, {camera, workspace.Terrain, localplayer.Character, workspace.Ignore, workspace.Players, extra}, cb or raycastbullet)
    end
end

-- This is for predicting the rocket travel
function aimbot:VelocityPrediction(startpos, endpos, vel, speed) -- Kinematics is fun
    if not vel then
        vel = Vector3.new()
    end
    local t = (endpos-startpos).Magnitude/speed
    return endpos + (vel * t)
end

do
    local rcast_params = RaycastParams.new()
    rcast_params.FilterType = Enum.RaycastFilterType.Whitelist
    rcast_params.IgnoreWater = true
    rcast_params.FilterDescendantsInstances = roundsystem.raycastwhitelist
    local player_ground = Vector3.new(0,3,0)
    function aimbot:ProjectileRaycasting(startpos, pred_results)
        startpos = Vector3.new(pred_results.X, startpos.Y, pred_results.Z)
        local results = workspace:Raycast(startpos, (pred_results-startpos)+player_ground, rcast_params)
        if results then
            return results.Position+player_ground
        end
        return pred_results
    end

    -- note: switch gravity to parabolic
    -- note: roblox gravity workspace seem incorrect, value aren't justified to their physics engine, maybe it's multiplied by mass?
    function aimbot:ProjectilePrediction(startpos, endpos, player_velocity, player_gravity, projectile_speed)
        player_velocity = player_velocity or Vector3.new()
        local t = (endpos-startpos).Magnitude/projectile_speed
        if player_gravity then
            --return self:ProjectileRaycasting(startpos, endpos + (player_velocity * t) + (.5*player_gravity*(t*t)))
            return endpos + (player_velocity * t)
        else
            return endpos + (player_velocity * t)
        end
    end
end

aimbot.bullet_gravity = Vector3.new(0, -196.2, 0) -- Todo: get the velocity from the game public settings

function aimbot:DropPrediction(startpos, finalpos, speed)
    local a, b = physics.trajectory(startpos, self.bullet_gravity, finalpos, speed)
    if a then
        return a
    else
        return (finalpos-startpos)
    end
end

function aimbot:CanBarrelPredict(gun)
    local stopon = self:GetLegitConfig("Ballistics", "Disable Barrel Comp While")
    if stopon["Scoping In"] then
        local sight = BBOT.weapons.GetToggledSight(gun)
        if sight and sight.sightspring and (sight.sightspring.p > 0.1 and sight.sightspring.p < 0.9) then
            return false
        end
    end
    if stopon["Fire Animation"] then
    end
    if stopon["Reloading"] then
        if debug.getupvalue(gun.reloadcancel, 1) then return false end
    end
    return true
end

function aimbot:BarrelPrediction(target, dir, gun)
    local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
    if part then
        return (((dir - part.CFrame.LookVector) * math.pi) - (dir - (target - part.CFrame.Position).Unit))
    end
end

function aimbot:GetParts(player)
    if not hud:isplayeralive(player) then return end
    return replication.getbodyparts(player)
end

local types = {
    -- Weapon Based
    ["E SHOTGUN"] = "Smg",

    -- Type Based
    ["PISTOL"] = "Pistol",
    ["REVOLVER"] = "Pistol",
    ["PDW"] = "Smg",
    ["DMR"] = "Rifle",
    ["LMG"] = "Rifle",
    ["CARBINE"] = "Rifle",
    ["ASSAULT"] = "Rifle",
    ["SHOTGUN"] = "Shotgun",
    ["SNIPER"] = "Sniper",

    -- Class Based
    ["ASSAULT RIFLE"] = "Rifle",
    DMR = "Rifle",
    ["BATTLE RIFLE"] = "Rifle",
    PDW = "Smg",
    LMG = "Rifle",
    ["SNIPER RIFLE"] = "Sniper",
    CARBINE = "Rifle",
    SHOTGUN = "Shotgun",
    PISTOLS = "Pistol",
    ["MACHINE PISTOLS"] = "Pistol"
}

aimbot.gun_type = "ASSAULT"
function aimbot:GetLegitConfig(...)
    local type = types[self.gun_type]
    if not type then
        type = "Rifle"
    end
    return config:GetValue("Main", "Legit", type, ...) 
end

function aimbot:GetLegitConfigR(...)
    local type = types[self.gun_type]
    if not type then
        type = "Rifle"
    end
    return config:GetRaw("Main", "Legit", type, ...) 
end

function aimbot:SetCurrentType(gun)
    if gun.name and types[gun.name] then
        self.gun_type = gun.name
        return
    end

    if not gun.___class or not types[gun.___class] then
        self.gun_type = gun.type
        return
    end
    self.gun_type = (gun.___class or gun.type)
end

function aimbot:GetRageConfig(...)
    return config:GetValue("Main", "Rage", ...)
end

local partstosimple = {
    ["head"] = "Head",
    ["torso"] = "Body",
    ["larm"] = "Arms",
    ["rarm"] = "Arms",
    ["lleg"] = "Legs",
    ["rleg"] = "Legs",
}

local function Move_Mouse(delta)
    local coef = cam.sensitivitymult * math.atan(
        math.tan(cam.basefov * (math.pi / 180) / 2) / 2.718281828459045 ^ cam.magspring.p
    ) / (32 * math.pi)
    local x = cam.angles.x - coef * delta.y
    x = x > cam.maxangle and cam.maxangle or x < cam.minangle and cam.minangle or x
    local y = cam.angles.y - coef * delta.x
    local newangles = Vector3.new(x, y, 0)
    cam.delta = (newangles - cam.angles) / 0.016666666666666666
    cam.angles = newangles
end

function aimbot:GetLegitTarget(fov, dzFov, hitscan_points, hitscan_priority, scan_part, multi, sticky)
    local mousePos = Vector3.new(mouse.x, mouse.y, 0)
    local cam_position = camera.CFrame.p
    local team = (localplayer.Team and localplayer.Team.Name or "NA")
    local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]
    local organizedPlayers = {}
    local plys = players:GetPlayers()
    for i=1, #plys do
        local v = plys[i]
        if v == localplayer then
            continue
        end

        local parts = self:GetParts(v)
        if not parts then continue end
    
        if v.Team and v.Team == localplayer.Team or config:GetPriority(v) < 0 then
            continue
        end

        local updater = replication.getupdater(v)
        local prioritize
        if hitscan_priority == "Head" then
            prioritize = replication.getbodyparts(v).head
        elseif hitscan_priority == "Body" then
            prioritize = replication.getbodyparts(v).torso
        end

        local inserted_priority
        if prioritize then
            local part = prioritize
            local pos = prioritize.Position
            local point, onscreen = camera:WorldToViewportPoint(pos)
            if onscreen then
                if (not fov or vector.dist2d(fov.Position, point) <= fov.Radius) then
                    local raydata = self:raycastbullet(cam_position,pos-cam_position,playerteamdata)
                    if not ((not raydata or not raydata.Instance:IsDescendantOf(updater.gethead().Parent)) and (raydata and raydata.Position ~= pos)) then
                        table.insert(organizedPlayers, {v, part, point, prioritize, (dzFov and vector.dist2d(dzFov.Position, point) < dzFov.Radius)})
                        inserted_priority = true
                    end
                end
            end
        end
        
        if not inserted_priority then
            for name, part in pairs(parts) do
                local name = partstosimple[name]
                if part == prioritize or not name or not hitscan_points[name] then continue end
                local pos = part.Position
                local point, onscreen = camera:WorldToViewportPoint(pos)
                if not onscreen then continue end
                if (fov and vector.dist2d(fov.Position, point) > fov.Radius) then continue end
                local raydata = self:raycastbullet(cam_position,pos-cam_position,playerteamdata)
                if (not raydata or not raydata.Instance:IsDescendantOf(updater.gethead().Parent)) and (raydata and raydata.Position ~= pos) then continue end
                table.insert(organizedPlayers, {v, part, point, name, (dzFov and vector.dist2d(dzFov.Position, point) < dzFov.Radius)})
            end
        end
    end

    if sticky then
        local founds = {}
        for i=1, #organizedPlayers do
            local v = organizedPlayers[i]
            if sticky[1] == v[1] then
                founds[#founds+1] = v
            end
        end
        if #founds > 0 then
            table.sort(founds, function(a, b)
                return (a[3] - mousePos).Magnitude < (b[3] - mousePos).Magnitude
            end)
            return (multi and founds or founds[1])
        end
    end
    
    table.sort(organizedPlayers, function(a, b)
        return (a[3] - mousePos).Magnitude < (b[3] - mousePos).Magnitude
    end)
    
    return (multi and organizedPlayers or organizedPlayers[1])
end

do
    local smoothing_incrimental = 0
    do
        local last_target
        hook:Add("RenderStepped", "BBOT:Aimbot.Assist.CalcSmoothing", function(delta)
            if not gamelogic.currentgun or not gamelogic.currentgun.data or not gamelogic.currentgun.data.bulletspeed then
                smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
                return
            end
            aimbot:SetCurrentType(gamelogic.currentgun)
            smoothing_incrimental = math.approach( smoothing_incrimental, aimbot:GetLegitConfig("Aim Assist", "End Smoothing"), aimbot:GetLegitConfig("Aim Assist", "Smoothing Increment") * delta )
        end)

        hook:Add("MouseBot.Changed", "BBOT:Aimbot.Assist.CalcSmoothing", function()
            smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
        end)

        function aimbot:MouseResetSmoothing()
            smoothing_incrimental = aimbot:GetLegitConfig("Aim Assist", "Start Smoothing")
        end
    end

    do
        local target_line = draw:Create("Line", "2V", "3D")
        target_line.Color = Color3.fromRGB(127, 72, 163)
        target_line.Thickness = 2
        target_line.ZIndex = 3
        target_line.Offset1 = Vector2.new()
        target_line.Point2 = Vector3.new()
        target_line.Visible = false
        target_line.Outlined = true
        target_line.OutlineColor = Color3.new(0,0,0)
        target_line.OutlineThickness = 1

        hook:Add("OnConfigChanged", "BBOT:Aimbot.MouseStep.Line", function(steps, old, new)
            if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Aim Assist Line", true) and not new then
                target_line.Visible = false
            elseif config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Aim Assist Line", "Color") then
                local color, opacity = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Line", "Color")
                target_line.Color = color
                target_line.Opacity = opacity
                target_line.OutlineOpacity = opacity
            end
        end)

        hook:Add("PreCalculateCrosshair", "BBOT:Aimbot.MouseStep.Line", function(screenpos, onscreen)
            if not config:GetValue("Main", "Visuals", "FOV", "Aim Assist Line") then return end
            local pos = Vector2.new(screenpos.X, screenpos.Y)
            local barrel_calc = aimbot:GetLegitConfig("Aim Assist", "Use Barrel")
            if not barrel_calc then
                pos = camera.ViewportSize/2
            end
            if char.alive and aimbot.mouse_target and aimbot.mouse_target[2] then
                target_line.Offset1 = pos
                target_line.Point2 = aimbot.mouse_target[2].Position
                target_line.Visible = true
            else
                target_line.Visible = false
            end
        end)
    end

    function aimbot:MouseChanged(target)
        if (target == nil and self.mouse_target) or (self.mouse_target == nil and target) or (target and self.mouse_target and target[1] ~= self.mouse_target[1]) then
            hook:Call("MouseBot.Changed", (target and unpack(target) or nil))
        end
    end

    function aimbot:MouseStep(gun)
        if not self:GetLegitConfig("Aim Assist", "Enabled") then
            self:MouseChanged()
            self.mouse_target = nil
            return
        end
        local aimkey = self:GetLegitConfig("Aim Assist", "Aimbot Key")
        if aimkey == "Mouse 1" or aimkey == "Mouse 2" then
            if not userinputservice:IsMouseButtonPressed((aimkey == "Mouse 1" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)) then
                self:MouseChanged()
                self.mouse_target = nil
                return
            end
        elseif aimkey == "Dynamic Always" then
            if not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                self:MouseChanged()
                self.mouse_target = nil
                return
            end
        end

        local hitscan_priority = self:GetLegitConfig("Aim Assist", "Hitscan Priority")
        local hitscan_points = self:GetLegitConfig("Aim Assist", "Hitscan Points")
        local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
        local barrel_calc = self:GetLegitConfig("Aim Assist", "Use Barrel")

        local previous_target = (self:GetLegitConfig("Aim Assist", "Lock Target") and self.mouse_target or nil)
        local target = self:GetLegitTarget(aimbot.fov_circle_last, aimbot.dzfov_circle_last, hitscan_points, hitscan_priority, (barrel_calc and part or nil), nil, previous_target)
        self:MouseChanged(target)
        self.mouse_target = target
        if not target or target[5] then return end

        if self:GetLegitConfig("Aim Assist", "Enable On Move") then
            local mouse_delta = userinputservice:GetMouseDelta()
            if mouse_delta.Magnitude == 0 then
                self:MouseResetSmoothing()
                return
            end
        end

        local position = target[2].Position
        local cam_position = camera.CFrame.p

        if self:GetLegitConfig("Ballistics", "Movement Prediction") then
            position = self:ProjectilePrediction(cam_position, position, replication.getupdater(target[1]).receivedVelocity, Vector3.new(0,-workspace.Gravity,0) * char.rootpart:GetMass(), gun.data.bulletspeed)
        end

        local dir = (position-cam_position).Unit
        local magnitude = (position-cam_position).Magnitude
        if self:GetLegitConfig("Ballistics", "Drop Prediction") then
            dir = self:DropPrediction(cam_position, position, gun.data.bulletspeed).Unit
        end

        if self:GetLegitConfig("Ballistics", "Barrel Compensation") and self:CanBarrelPredict(gun) then
            local X, Y = self:GetLegitConfig("Ballistics", "Barrel Comp X")/100, self:GetLegitConfig("Ballistics", "Barrel Comp Y")/100
            local correction_dir = self:BarrelPrediction(position, dir, gun)
            dir = dir + Vector3.new(correction_dir.X * X, correction_dir.Y * Y, 0)
            dir = dir.Unit
        end

        local pos, onscreen = camera:WorldToViewportPoint(cam_position + (dir*magnitude))
        if onscreen then
            local randMag = self:GetLegitConfig("Aim Assist", "Randomization")
            local smoothing = smoothing_incrimental * 5 + 5
            local inc = Vector2.new((pos.X - mouse.X + (math.noise(time() * 0.1, 0.1) * randMag)) / smoothing, (pos.Y - 36 - mouse.Y + (math.noise(time() * 0.1, 0.1) * randMag)) / smoothing)
            Move_Mouse(inc)
        end
    end
end

do
    do
        local target_line = draw:Create("Line", "2V", "3D")
        target_line.Color = Color3.fromRGB(163, 72, 127)
        target_line.Thickness = 2
        target_line.ZIndex = 3
        target_line.Offset1 = Vector2.new()
        target_line.Point2 = Vector3.new()
        target_line.Visible = false
        target_line.Outlined = true
        target_line.OutlineColor = Color3.new(0,0,0)
        target_line.OutlineThickness = 1

        hook:Add("OnConfigChanged", "BBOT:Aimbot.RedirectionStep.Line", function(steps, old, new)
            if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Bullet Redirect Line", true) and not new then
                target_line.Visible = false
            elseif config:IsPathwayEqual(steps, "Main", "Visuals", "FOV", "Bullet Redirect Line", "Color") then
                local color, opacity = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect Line", "Color")
                target_line.Color = color
                target_line.Opacity = opacity
                target_line.OutlineOpacity = opacity
            end
        end)

        hook:Add("PreCalculateCrosshair", "BBOT:Aimbot.RedirectionStep.Line", function(screenpos, onscreen)
            if not config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect Line") then return end
            local pos = Vector2.new(screenpos.X, screenpos.Y)
            local barrel_calc = aimbot:GetLegitConfig("Bullet Redirect", "Use Barrel")
            if not barrel_calc then
                pos = camera.ViewportSize/2
            end
            if char.alive and aimbot.redirection_target and aimbot.redirection_target[2] then
                target_line.Offset1 = pos
                target_line.Point2 = aimbot.redirection_target[2].Position
                target_line.Visible = true
            else
                target_line.Visible = false
            end
        end)
    end

    function aimbot:RedirectionChanged(target)
        if (target == nil and self.redirection_target) or (self.redirection_target == nil and target) or (target and self.redirection_target and target[1] ~= self.redirection_target[1]) then
            hook:Call("RedirectionBot.Changed", (target and unpack(target) or nil))
        end
    end

    function aimbot:RedirectionStep(gun)
        self.redirection_target = nil
        if not self:GetLegitConfig("Bullet Redirect", "Enabled") then
            self:RedirectionChanged()
            return
        end
        local aimkey = self:GetLegitConfig("Aim Assist", "Aimbot Key")
        if aimkey == "Mouse 1" or aimkey == "Mouse 2" then
            if not userinputservice:IsMouseButtonPressed((aimkey == "Mouse 1" and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2)) then
                self:RedirectionChanged()
                return
            end
        elseif aimkey == "Dynamic Always" then
            if not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                self:RedirectionChanged()
                return
            end
        end
        if math.random(0, 100) > self:GetLegitConfig("Bullet Redirect", "Hit Chance") then
            return
        end

        local hitscan_priority = self:GetLegitConfig("Bullet Redirect", "Hitscan Priority")
        local hitscan_points = self:GetLegitConfig("Bullet Redirect", "Hitscan Points")
        local barrel_calc = self:GetLegitConfig("Bullet Redirect", "Use Barrel")
        local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)

        local target = self:GetLegitTarget(aimbot.sfov_circle_last, nil, hitscan_points, hitscan_priority, (barrel_calc and part or nil))
        self:RedirectionChanged(target)
        if not target then return end
        self.redirection_target = target
        local position = target[2].Position
        local part_pos = part.Position

        if self:GetLegitConfig("Ballistics", "Movement Prediction") then
            position = self:ProjectilePrediction(part_pos, position, replication.getupdater(target[1]).receivedVelocity, Vector3.new(0,-workspace.Gravity,0) * char.rootpart:GetMass(), gun.data.bulletspeed)
        end

        local dir = (position-part_pos).Unit
        local magnitude = (position-part_pos).Magnitude
        if self:GetLegitConfig("Ballistics", "Drop Prediction") then
            dir = self:DropPrediction(part_pos, position, gun.data.bulletspeed).Unit
        end

        local X, Y = CFrame.new(part_pos, part_pos+dir):ToOrientation()
        
        local accuracy = math.remap(self:GetLegitConfig("Bullet Redirect", "Accuracy")/100, 0, 1, .3, 0)
        X += ((math.pi/2) * (math.random(-accuracy*1000, accuracy*1000)/1000))/100
        Y += ((math.pi/2) * (math.random(-accuracy*1000, accuracy*1000)/1000))/100

        self.silent_data = {part.Position, part.Orientation}
        part.Orientation = Vector3.new(math.deg(X), math.deg(Y), 0)
        self.silent = part
    end
end

do
    local assist_prediction_outline = draw:Create("Circle", "2V")
    assist_prediction_outline.Thickness = 6
    assist_prediction_outline.NumSides = 25
    assist_prediction_outline.Size = 4
    assist_prediction_outline.Filled = true
    local assist_prediction = draw:Create("Circle", "2V")
    assist_prediction.Thickness = 1
    assist_prediction.NumSides = 25
    assist_prediction.Size = 3
    assist_prediction.Filled = true

    hook:Add("RenderStepped", "BBOT:Aimbot.TriggerBot", function()
        local mycurgun = gamelogic.currentgun
        if mycurgun and mycurgun.data and mycurgun.data.bulletspeed then
            aimbot:SetCurrentType(mycurgun)
            if not aimbot:GetLegitConfig("Trigger Bot", "Enabled") then return end
            local col, transparency = aimbot:GetLegitConfig("Trigger Bot", "Enabled", "Dot Color")
            assist_prediction.Color = col
            assist_prediction.Opacity = transparency
            assist_prediction_outline.Opacity = transparency
        elseif assist_prediction.Visible then
            assist_prediction.Visible = false
            assist_prediction_outline.Visible = assist_prediction.Visible
        end
    end)

    hook:Add("OnAliveChanged", "BBOT:Aimbot.TriggerBot.Hide", function(isalive)
        if not isalive then
            assist_prediction.Visible = false
            assist_prediction_outline.Visible = assist_prediction.Visible
        end
    end)

    local isaiming, aimtime = nil, 0
    local firetime = 0
    local sprinttofiretime = 0
    function aimbot:TriggerBotStep(gun)
        self.trigger_target = nil
        if assist_prediction.Visible then
            assist_prediction.Visible = false
            assist_prediction_outline.Visible = assist_prediction.Visible
        end
        if not self:GetLegitConfig("Trigger Bot", "Enabled") then return end
        local aim_percentage = self:GetLegitConfig("Trigger Bot", "Aim In Time")
        if isaiming ~= gun.isaiming() then
            isaiming = gun.isaiming()
            aimtime = tick()
        end
        if self:GetLegitConfig("Trigger Bot", "Trigger When Aiming") and (not isaiming or (tick() - aimtime < aim_percentage)) then return end
        if char.sprinting() then
            sprinttofiretime = tick() + self:GetLegitConfig("Trigger Bot", "Sprint to Fire Time")
            return
        elseif sprinttofiretime > tick() then return end
        local hitscan_points = self:GetLegitConfig("Trigger Bot", "Trigger Bot Hitboxes")
        local multitarget = self:GetLegitTarget(aimbot.tfov_circle_last, nil, hitscan_points, nil, nil, true)
        local target_main = multitarget[1]

        if not target_main then return end
        self.trigger_target = target_main

        local cam_position = camera.CFrame.p
        local movement_prediction = self:GetLegitConfig("Ballistics", "Movement Prediction")
        local drop_prediction = self:GetLegitConfig("Ballistics", "Drop Prediction")
        local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
        local part_pos = part.Position
        local team = (localplayer.Team and localplayer.Team.Name or "NA")
        local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]
        local t = tick()
        local hit = false

        local velocity = replication.getupdater(target_main[1]).receivedVelocity
        local bulletspeed = gun.data.bulletspeed
        for i=1, #multitarget do
            local target = multitarget[i]
            if target[1] ~= target_main[1] then continue end
            local position = target[2].Position
            if movement_prediction then
                position = self:ProjectilePrediction(cam_position, position, velocity, Vector3.new(0,-workspace.Gravity,0) * char.rootpart:GetMass(), bulletspeed)
            end

            local dir = (position-cam_position).Unit
            local magnitude = (position-cam_position).Magnitude
            if drop_prediction then
                dir = self:DropPrediction(cam_position, position, bulletspeed).Unit
            end

            local trigger_position, onscreen = camera:WorldToViewportPoint(cam_position + (dir*magnitude))
            if onscreen then
                trigger_position = Vector2.new(trigger_position.X, trigger_position.Y)

                if i == 1 then
                    assist_prediction.Visible = true
                    assist_prediction_outline.Visible = assist_prediction.Visible
                    assist_prediction.Offset = trigger_position
                    assist_prediction_outline.Offset = assist_prediction.Offset
                end

                local radi = (target[4] == "Body" and 700 or 450)*(char.unaimedfov/camera.FieldOfView)/magnitude
                if gun.data.hipchoke and gun.data.hipchoke > 0 then
                    local o = radi
                    local mul = gun.data.crosssize * gun.data.hipchoke --(gun.data.aimchoke * p367 + gun.data.hipchoke * (1 - p367))
                    radi = (2.25 * (math.pi^2) * mul)
                    radi = radi * (char.unaimedfov/camera.FieldOfView)/magnitude
                    if magnitude < gun.data.range0 then
                        radi = radi * math.clamp(magnitude/gun.data.range0, .5, 1)
                    end
                    if radi < o then
                        radi = o
                    end
                end

                if i == 1 then
                    assist_prediction.Radius = radi
                    assist_prediction_outline.Radius = radi
                end

                local endpositon = part.CFrame.LookVector*70000
                local raydata = self:raycastbullet(part_pos,endpositon,playerteamdata)
                local pointhit
                if raydata and raydata.Position then
                    pointhit = raydata.Position
                else
                    pointhit = endpositon
                end

                local barrel_end_positon, onscreen = camera:WorldToViewportPoint(pointhit)
                barrel_end_positon = Vector2.new(barrel_end_positon.X, barrel_end_positon.Y)
                if onscreen and vector.dist2d(trigger_position, barrel_end_positon) <= radi then
                    hit = true
                    break
                end
            end
        end

        if hit then
            local rpm = self:GetLegitConfig("Trigger Bot", "RPM Limiter")
            if gamelogic.currentgun ~= self.trigger_lastgun then
                self.trigger_lastgun = gamelogic.currentgun
                self.trigger_nextfire = nil
            end
            if firetime < t and (rpm == 0 or not self.trigger_nextfire or self.trigger_nextfire < tick()) then
                aimbot.fire = true
                gun:shoot(true)
                self.trigger_nextfire = tick() + (60 / rpm)
            end
        else
            firetime = t + self:GetLegitConfig("Trigger Bot", "Fire Time")
        end
    end
end

local Resolver_NewBullet = {}
hook:Add("PreNewBullets", "BBOT:Aimbot.Resolver", function(data)
    local firepos, player = data.firepos, data.player
    local isalive = hud:isplayeralive(player)
    if isalive then
        local headpart = aimbot:GetParts(player).torso
        local mag = (firepos-headpart.Position).Magnitude
        if mag > 12 then
            Resolver_NewBullet[player.UserId] = (firepos-headpart.Position)
        else
            Resolver_NewBullet[player.UserId] = nil
        end
    end
end)

local vector_cache = Vector3.new()
local height_offset = Vector3.new(0,1.25,0)
function aimbot:GetResolvedPosition(player)
    if not self:GetRageConfig("Settings", "Resolver") then
        --[[local updater = replication.getupdater(player)
        if updater and updater.tickVelocity then
            local vel_resolver = aimbot:GetRageConfig("Settings", "Velocity Resolver")
            if vel_resolver == "Tick" and updater.tickVelocity then
                return height_offset+updater.tickVelocity
            elseif vel_resolver == "Ping" and updater.pingVelocity then
                return height_offset+updater.pingVelocity
            end
        end]]
        return height_offset
    end
    --[[local bodyparts, rootpart = aimbot:GetParts(player)
    local resolvedoffset = vector_cache
    -- method 1
    local root_cframe, torso_cframe = rootpart.CFrame, bodyparts.torso.CFrame
    if (root_cframe.Position - torso_cframe.Position).Magnitude > 18 then
        resolvedoffset = root_cframe.Position - torso_cframe.Position
    end
    return resolvedoffset]]
    local updater = replication.getupdater(player)
    local velocity_addition = vector_cache
    --[[if updater and updater.tickVelocity then
        local vel_resolver = aimbot:GetRageConfig("Settings", "Velocity Resolver")
        if vel_resolver == "Tick" and updater.tickVelocity then
            velocity_addition = updater.tickVelocity
        elseif vel_resolver == "Ping" and updater.pingVelocity then
            velocity_addition = updater.pingVelocity
        end
    end]]

    local parts = aimbot:GetParts(player)
    if updater and updater.receivedPosition and parts then
        --[[local offset = (updater.receivedPosition-updater.getpos())
        if offset.Magnitude >= 10000 or offset.Magnitude > math.huge or offset.Magnitude < -math.huge then
            return updater.receivedPosition + velocity_addition, true
        else
            return offset + velocity_addition
        end]]
        return updater.receivedPosition + velocity_addition, true
    end

    if Resolver_NewBullet[player.UserId] then
        return Resolver_NewBullet[player.UserId] + velocity_addition
    end

    return vector_cache + velocity_addition
end

function aimbot:GetDamage(data, distance, headshot)
    local r0, r1, d0, d1 = data.range0, data.range1, data.damage0, data.damage1
    return (distance < r0 and d0 or distance < r1 and (d1 - d0) / (r1 - r0) * (distance - r0) + d0 or d1)  * (headshot and data.multhead or 1)
end

-- This is broken because of the new ragebot... cba to fix this rn

--aimbot.predictedDamageDealt = {}
--aimbot.predictedLastHealth = {}
--aimbot.predictedDamageUpdate = {}
--aimbot.BulletQuery = {}
--hook:Add("PostNetworkSend", "BBOT:RageBot.DamagePrediction", function(netname, ...)
--	if netname == "bullethit" then
--		local curthread = syn.get_thread_identity()
--		syn.set_thread_identity(1)
--		local a = {...}
--		local Entity, HitPos, Part, bulletID = a[1], a[2], a[3], a[4]
--		if Entity and Entity:IsA("Player") and aimbot:GetRageConfig("Settings", "Damage Prediction") and aimbot.BulletQuery[bulletID] then
--			local bullet_data = aimbot.BulletQuery[bulletID]
--			local damageDealt = aimbot:GetDamage(bullet_data[1], (HitPos-bullet_data[2]).Magnitude, Part == "Head")
--			if not aimbot.predictedDamageDealt[Entity] then
--				aimbot.predictedDamageDealt[Entity] = (100-hud:getplayerhealth(Entity))
--			end
--			local limit = aimbot:GetRageConfig("Settings", "Damage Prediction Limit")
--			aimbot.predictedDamageDealt[Entity] += damageDealt
--			aimbot.predictedDamageUpdate[Entity] = tick() + (extras:getLatency() * 5)
--			if aimbot.predictedDamageDealt[Entity] >= limit then
--				hook:Call("RageBot.DamagePredictionKilled", Entity)
--			end
--		end
--		syn.set_thread_identity(curthread)
--	elseif netname == "newbullets" and gamelogic.currentgun and gamelogic.currentgun.data then
--		local args = {...}
--		local bullettable = args[1]
--		local dataset = {gamelogic.currentgun.data, bullettable.firepos}
--		for i=1, #bullettable.bullets do
--			local v = bullettable.bullets[i]
--			aimbot.BulletQuery[v[2]] = dataset
--		end
--		timer:Simple(1.5, function()
--			for i=1, #bullettable.bullets do
--				local v = bullettable.bullets[i]
--				aimbot.BulletQuery[v[2]] = nil
--			end
--		end)
--	end
--end)

--hook:Add("OnConfigChanged", "BBOT:RageBot.DamagePredictionReset", function(steps, old, new)
--	if config:IsPathwayEqual(steps, "Main", "Rage", "Settings", "Damage Prediction Limit") then
--		for k, v in next, players:GetPlayers() do
--			aimbot.predictedDamageDealt[v] = (100-hud:getplayerhealth(v))
--			aimbot.predictedLastHealth[v] = hud:getplayerhealth(v)
--		end
--	end
--end)

--hook:Add("OnAliveChanged", "BBOT:RageBot.DamagePredictionReset", function()
--	for k, v in next, players:GetPlayers() do
--		aimbot.predictedDamageDealt[v] = (100-hud:getplayerhealth(v))
--		aimbot.predictedLastHealth[v] = hud:getplayerhealth(v)
--	end
--end)

--hook:Add("Postupdatespawn", "BBOT:RageBot.DamagePredictionReset", function(player, controller)
--	aimbot.predictedLastHealth[player] = 100
--	aimbot.predictedDamageDealt[player] = 0
--	aimbot.predictedDamageUpdate[player] = tick() + (extras:getLatency() * 5)
--end)

--hook:Add("PlayerAdded", "BBOT:RageBot.DamagePredictionReset", function(player, controller)
--	aimbot.predictedLastHealth[player] = 100
--	aimbot.predictedDamageDealt[player] = 0
--	aimbot.predictedDamageUpdate[player] = tick() + (extras:getLatency() * 5)
--end)

--hook:Add("PlayerRemoving", "BBOT:RageBot.DamagePredictionReset", function(player, controller)
--	aimbot.predictedLastHealth[player] = nil
--	aimbot.predictedDamageDealt[player] = nil
--	aimbot.predictedDamageUpdate[player] = nil
--end)

--local dmg_last = 0

--hook:Add("RenderStepped", "BBOT:RageBot.DamagePrediction", function()
--	for index, time in next, aimbot.predictedDamageUpdate do
--		if time < tick() then
--			aimbot.predictedDamageDealt[index] = (100-hud:getplayerhealth(index))
--			aimbot.predictedLastHealth[index] = hud:getplayerhealth(index)
--			aimbot.predictedDamageUpdate[index] = nil
--		end
--	end

--	for index, time in next, aimbot.predictedDamageDealt do
--		local hpnew = hud:getplayerhealth(index)
--		if not aimbot.predictedLastHealth[index] then
--			aimbot.predictedLastHealth[index] = hpnew
--		end
--		if hpnew > aimbot.predictedLastHealth[index] then
--			aimbot.predictedLastHealth[index] = hpnew
--			if not aimbot.predictedDamageUpdate[index] then
--				aimbot.predictedDamageUpdate[index] = tick() + (extras:getLatency() * 5)
--			end
--		elseif hpnew < aimbot.predictedLastHealth[index] then
--			aimbot.predictedLastHealth[index] = hpnew
--			aimbot.predictedDamageUpdate[index] = tick() + (extras:getLatency() * 5)
--		end
--	end
--end)

local last_repupdate_position
hook:Add("PostNetworkSend", "BBOT:RageBot.LastPosition", function(netname, pos, ang, t)
    if netname ~= "repupdate" then return end
    last_repupdate_position = pos
end)

hook:Add("PreupdateReplication", "BBOT:Aimbot.updateReplication", function(player, controller)
    controller._receivedPosition = controller.receivedPosition
    controller._receivedVelocity = controller.receivedVelocity
    controller._receivedFrameTime = controller.receivedFrameTime
end)

local vec0 = Vector3.zero
hook:Add("PostupdateReplication", "BBOT:RageBot.CheckAlive", function(player, controller)
    local t, last_t = tick(), controller.__t_received
    if controller._receivedPosition and controller._receivedFrameTime and last_t then
        controller.tickVelocity = (controller.receivedPosition - controller._receivedPosition) * (last_t - t)/2;
        controller.pingVelocity = (controller.receivedPosition - controller._receivedPosition) * extras:getLatency()/2;
    end
    local vel_resolver = aimbot:GetRageConfig("Settings", "Velocity Modifications")
    if vel_resolver == "Zero" then
        controller.receivedVelocity = vec0
    elseif vel_resolver == "Tick" and controller.tickVelocity then
        controller.receivedVelocity = controller.tickVelocity
    elseif vel_resolver == "Ping" and controller.pingVelocity then
        controller.receivedVelocity = controller.pingVelocity
    end
    controller.__t_received = t
end)

hook:Add("Postupdatespawn", "BBOT:RageBot.CheckAlive", function(player, controller)
    controller.__t_received = tick()
end)

hook:Add("OnAliveChanged", "BBOT:RageBot.LastPosition", function()
    last_repupdate_position = nil
end)

do
    local auto_wall = aimbot:GetRageConfig("Aimbot", "Auto Wallbang")
    local hitscan_priority = aimbot:GetRageConfig("Aimbot", "Hitscan Priority")
    local aimbot_fov = aimbot:GetRageConfig("Aimbot", "Aimbot FOV")
    
    local hitbox_shift_points = aimbot:GetRageConfig("HVH", "Hitbox Hitscan Points")
    local hitbox_shift_distance = aimbot:GetRageConfig("HVH", "Hitbox Shift Distance")
    local max_players = aimbot:GetRageConfig("Settings", "Max Players")
    local relative_only = aimbot:GetRageConfig("Settings", "Relative Points Only")
    local cross_relative_only = aimbot:GetRageConfig("Settings", "Cross Relative Points Only")
    
    local hitbox_points, hitbox_points_name = {}, {}
    hitbox_points[#hitbox_points+1] = CFrame.new(0,0,0) hitbox_points_name[#hitbox_points_name+1] = "Origin"

    local firepos_shift_points = aimbot:GetRageConfig("HVH", "FirePos Hitscan Points")
    local firepos_shift_distance = aimbot:GetRageConfig("HVH", "FirePos Shift Distance")
    local firepos_shift_multi = aimbot:GetRageConfig("HVH", "FirePos Shift Multi-Point")
    
    local firepos_points, firepos_points_name = {}, {}
    firepos_points[#firepos_points+1] = CFrame.new(0,0,0) firepos_points_name[#firepos_points_name+1] = "Origin"
    
    local tp_scanning_points = #firepos_points
    local points_allowed = aimbot:GetRageConfig("HVH", "TP Scanning Points")
    local tp_scan_dist = aimbot:GetRageConfig("HVH", "TP Scanning Distance")
    local tp_scan_multi = aimbot:GetRageConfig("HVH", "TP Scanning Multi-Point")
    local tp_scan_shift = aimbot:GetRageConfig("HVH", "TP Scanning Shift")
    --[[if aimbot:GetRageConfig("HVH", "TP Scanning") then
        local points_allowed = aimbot:GetRageConfig("HVH", "TP Scanning Points")
        local tp_scan_dist = aimbot:GetRageConfig("HVH", "TP Scanning Distance")
        local tp_scan_multi = aimbot:GetRageConfig("HVH", "TP Scanning Multi-Point")
        for i=1, tp_scan_multi do
            local scan_dist = (tp_scan_dist/tp_scan_multi)*i
            if points_allowed.Up then firepos_points[#firepos_points+1] = CFrame.new(0,scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Up" end
            if points_allowed.Down then firepos_points[#firepos_points+1] = CFrame.new(0,-scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Down" end
            if points_allowed.Left then firepos_points[#firepos_points+1] = CFrame.new(-scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Left" end
            if points_allowed.Right then firepos_points[#firepos_points+1] = CFrame.new(scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Right" end
            if points_allowed.Forward then firepos_points[#firepos_points+1] = CFrame.new(0,0,-scan_dist) firepos_points_name[#firepos_points_name+1] = "Forward" end
            if points_allowed.Backward then firepos_points[#firepos_points+1] = CFrame.new(0,0,scan_dist) firepos_points_name[#firepos_points_name+1] = "Backward" end
        end
    end]]
    
    local damage_prediction = aimbot:GetRageConfig("Settings", "Damage Prediction")
    local damage_prediction_limit = aimbot:GetRageConfig("Settings", "Damage Prediction Limit")

    local hitbox_random = 0
    local firepos_random = 0

    hook:Add("OnConfigChanged", "BBOT:RageBot.CacheConfig", function(steps)
        if not config:IsPathwayEqual(steps, "Main", "Rage") then return end
        local self = aimbot
        auto_wall = self:GetRageConfig("Aimbot", "Auto Wallbang")
        hitscan_priority = self:GetRageConfig("Aimbot", "Hitscan Priority")
        aimbot_fov = self:GetRageConfig("Aimbot", "Aimbot FOV")
        
        hitbox_shift_points = self:GetRageConfig("HVH", "Hitbox Hitscan Points")
        hitbox_shift_distance = self:GetRageConfig("HVH", "Hitbox Shift Distance")
        max_players = self:GetRageConfig("Settings", "Max Players")
        relative_only = self:GetRageConfig("Settings", "Relative Points Only")
        cross_relative_only = self:GetRageConfig("Settings", "Cross Relative Points Only")
        
        hitbox_points, hitbox_points_name = {}, {}
        if hitbox_shift_points.Origin then hitbox_points[#hitbox_points+1] = CFrame.new(0,0,0) hitbox_points_name[#hitbox_points_name+1] = "Origin" end
        if hitbox_shift_points.Forward then hitbox_points[#hitbox_points+1] = CFrame.new(0,0,-hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Forward" end
        if hitbox_shift_points.Backward then hitbox_points[#hitbox_points+1] = CFrame.new(0,0,hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Backward" end
        if hitbox_shift_points.Up then hitbox_points[#hitbox_points+1] = CFrame.new(0,hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Up" end
        if hitbox_shift_points.Down then hitbox_points[#hitbox_points+1] = CFrame.new(0,-hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Down" end
        if hitbox_shift_points.Left then hitbox_points[#hitbox_points+1] = CFrame.new(-hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Left" end
        if hitbox_shift_points.Right then hitbox_points[#hitbox_points+1] = CFrame.new(hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Right" end

        local hitbox_shift_static_points = self:GetRageConfig("HVH Extras", "Hitbox Static Points")
        if hitbox_shift_static_points.Forward then hitbox_points[#hitbox_points+1] = Vector3.new(0,0,-hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Any" end
        if hitbox_shift_static_points.Backward then hitbox_points[#hitbox_points+1] = Vector3.new(0,0,hitbox_shift_distance) hitbox_points_name[#hitbox_points_name+1] = "Any" end
        if hitbox_shift_static_points.Up then hitbox_points[#hitbox_points+1] = Vector3.new(0,hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end
        if hitbox_shift_static_points.Down then hitbox_points[#hitbox_points+1] = Vector3.new(0,-hitbox_shift_distance,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end
        if hitbox_shift_static_points.Left then hitbox_points[#hitbox_points+1] = Vector3.new(-hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end
        if hitbox_shift_static_points.Right then hitbox_points[#hitbox_points+1] = Vector3.new(hitbox_shift_distance,0,0) hitbox_points_name[#hitbox_points_name+1] = "Any" end

        firepos_shift_points = self:GetRageConfig("HVH", "FirePos Hitscan Points")
        firepos_shift_distance = self:GetRageConfig("HVH", "FirePos Shift Distance")
        firepos_shift_multi = self:GetRageConfig("HVH", "FirePos Shift Multi-Point")
        
        firepos_points, firepos_points_name = {}, {}
        if firepos_shift_points.Origin then firepos_points[#firepos_points+1] = CFrame.new(0,0,0) firepos_points_name[#firepos_points_name+1] = "Origin" end
        if firepos_shift_points.Forward then firepos_points[#firepos_points+1] = CFrame.new(0,0,-firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Forward" end
        if firepos_shift_points.Backward then firepos_points[#firepos_points+1] = CFrame.new(0,0,firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Backward" end

        local firepos_shift_static_points = self:GetRageConfig("HVH Extras", "FirePos Static Points")
        if firepos_shift_static_points.Up then firepos_points[#firepos_points+1] = Vector3.new(0,firepos_shift_distance,0) firepos_points_name[#firepos_points_name+1] = "Any" end
        if firepos_shift_static_points.Down then firepos_points[#firepos_points+1] = Vector3.new(0,-firepos_shift_distance,0) firepos_points_name[#firepos_points_name+1] = "Any" end
        if firepos_shift_static_points.Left then firepos_points[#firepos_points+1] = Vector3.new(-firepos_shift_distance,0,0) firepos_points_name[#firepos_points_name+1] = "Any" end
        if firepos_shift_static_points.Right then firepos_points[#firepos_points+1] = Vector3.new(firepos_shift_distance,0,0) firepos_points_name[#firepos_points_name+1] = "Any" end
        if firepos_shift_static_points.Forward then firepos_points[#firepos_points+1] = Vector3.new(0,0,-firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Any" end
        if firepos_shift_static_points.Backward then firepos_points[#firepos_points+1] = Vector3.new(0,0,firepos_shift_distance) firepos_points_name[#firepos_points_name+1] = "Any" end

        for i=1, firepos_shift_multi do
            local scale = (firepos_shift_distance/firepos_shift_multi)*i
            if firepos_shift_points.Up then firepos_points[#firepos_points+1] = CFrame.new(0,scale,0) firepos_points_name[#firepos_points_name+1] = "Up" end
            if firepos_shift_points.Down then firepos_points[#firepos_points+1] = CFrame.new(0,-scale,0) firepos_points_name[#firepos_points_name+1] = "Down" end
            if firepos_shift_points.Left then firepos_points[#firepos_points+1] = CFrame.new(-scale,0,0) firepos_points_name[#firepos_points_name+1] = "Left" end
            if firepos_shift_points.Right then firepos_points[#firepos_points+1] = CFrame.new(scale,0,0) firepos_points_name[#firepos_points_name+1] = "Right" end
        end

        hitbox_random = #hitbox_points
        local hitbox_randompoints = self:GetRageConfig("HVH Extras", "Hitbox Random Points")
        for i=1, hitbox_randompoints do
            hitbox_points[#hitbox_points+1] = CFrame.new(0,0,0)
            hitbox_points_name[#hitbox_points_name+1] = "Random"
        end

        firepos_random = #firepos_points
        local firepos_randompoints = self:GetRageConfig("HVH Extras", "FirePos Random Points")
        for i=1, firepos_randompoints do
            firepos_points[#firepos_points+1] = CFrame.new(0,0,0)
            firepos_points_name[#firepos_points_name+1] = "Random"
        end

        tp_scanning_points = #firepos_points
        points_allowed = self:GetRageConfig("HVH", "TP Scanning Points")
        tp_scan_dist = self:GetRageConfig("HVH", "TP Scanning Distance")
        tp_scan_multi = self:GetRageConfig("HVH", "TP Scanning Multi-Point")
        tp_scan_shift = aimbot:GetRageConfig("HVH", "TP Scanning Shift")
        for i=1, tp_scan_multi do
            scan_dist = (tp_scan_dist/tp_scan_multi)*i
            if points_allowed.Up then firepos_points[#firepos_points+1] = CFrame.new(0,scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Up" end
            if points_allowed.Down then firepos_points[#firepos_points+1] = CFrame.new(0,-scan_dist,0) firepos_points_name[#firepos_points_name+1] = "Down" end
            if points_allowed.Left then firepos_points[#firepos_points+1] = CFrame.new(-scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Left" end
            if points_allowed.Right then firepos_points[#firepos_points+1] = CFrame.new(scan_dist,0,0) firepos_points_name[#firepos_points_name+1] = "Right" end
            if points_allowed.Forward then firepos_points[#firepos_points+1] = CFrame.new(0,0,-scan_dist) firepos_points_name[#firepos_points_name+1] = "Forward" end
            if points_allowed.Backward then firepos_points[#firepos_points+1] = CFrame.new(0,0,scan_dist) firepos_points_name[#firepos_points_name+1] = "Backward" end
        end
        
        damage_prediction = self:GetRageConfig("Settings", "Damage Prediction")
        damage_prediction_limit = self:GetRageConfig("Settings", "Damage Prediction Limit")
    end)
    
    local cross_relatives = {
        ["Up"] = "Down",
        ["Down"] = "Up",
        ["Left"] = "Right",
        ["Right"] = "Left",
        ["Forward"] = "Backward",
        ["Backward"] = "Forward",
    }

    aimbot.ragebot_next = {}
    aimbot.ragebot_prioritynext = {}

    hook:Add("OnPriorityChanged", "BBOT:RageBot.Organize", function(player, old, new)
        if new and new > 0 then
            local found = false
            local c = 0
            for i=1, #aimbot.ragebot_next do
                local v = aimbot.ragebot_next[i-c]
                if v == player then
                    table.remove(aimbot.ragebot_next, i-c)
                    c=c+1
                    found = true
                end
            end
            if found then
                aimbot.ragebot_prioritynext[#aimbot.ragebot_prioritynext+1] = player
            end
        else
            local found = false
            local c = 0
            for i=1, #aimbot.ragebot_prioritynext do
                local v = aimbot.ragebot_prioritynext[i-c]
                if v == player then
                    table.remove(aimbot.ragebot_prioritynext, i-c)
                    c=c+1
                    found = true
                end
            end
            c = 0
            for i=1, #aimbot.ragebot_next do
                local v = aimbot.ragebot_next[i-c]
                if v == player then
                    table.remove(aimbot.ragebot_next, i-c)
                    c=c+1
                end
            end
            if found and (not new or new == 0) then
                aimbot.ragebot_next[#aimbot.ragebot_next+1] = player
            end
        end
    end)

    hook:Add("PostInitialize", "BBOT:RageBot.Organize", function()
        hook:Add("PlayerAdded", "BBOT:RageBot.Organize", function(player)
            local inpriority = config:GetPriority(player)
            if inpriority > 0 then
                aimbot.ragebot_prioritynext[#aimbot.ragebot_prioritynext+1] = player
            elseif inpriority == 0 then
                aimbot.ragebot_next[#aimbot.ragebot_next+1] = player
            end
        end)

        hook:Add("PlayerRemoving", "BBOT:RageBot.Organize", function(player)
            local c = 0
            for i=1, #aimbot.ragebot_prioritynext do
                local v = aimbot.ragebot_prioritynext[i-c]
                if v == player then
                    table.remove(aimbot.ragebot_prioritynext, i-c)
                    c=c+1
                end
            end
            c = 0
            for i=1, #aimbot.ragebot_next do
                local v = aimbot.ragebot_next[i-c]
                if v == player then
                    table.remove(aimbot.ragebot_next, i-c)
                    c=c+1
                end
            end
        end)

        local p = players:GetPlayers()
        for i=1, #p do
            local v = p[i]
            local priority = config:GetPriority(v) or 0
            if priority > 0 then
                aimbot.ragebot_prioritynext[#aimbot.ragebot_prioritynext+1] = v
            elseif priority == 0 then
                aimbot.ragebot_next[#aimbot.ragebot_next+1] = v
            end
        end
    end)

    local last_prioritized = nil
    hook:Add("OnConfigChanged", "BBOT:Aimbot.PriorityAuto", function(steps, old, new)
        if not config:IsPathwayEqual(steps, "Main", "Rage", "Settings", "Priority Last") then return end
        for i, v in pairs(players:GetPlayers()) do
            if v == last_prioritized then
                hook:Call("OnPriorityChanged", last_prioritized, 10, config:GetPriority(last_prioritized))
                break
            end
        end
        last_prioritized = nil
    end)

    hook:Add("LocalKilled", "BBOT:Aimbot.PriorityLast", function(player)
        if not aimbot:GetRageConfig("Settings", "Priority Last") then return end
        if not player then return end
        local old, lastpriority = last_prioritized, config:GetPriority(player)
        last_prioritized = player
        hook:Call("OnPriorityChanged", player, lastpriority, 10)
        for i, v in pairs(players:GetPlayers()) do
            if v == old then
                hook:Call("OnPriorityChanged", old, 10, config:GetPriority(old))
                break
            end
        end
    end)

    hook:Add("GetPriority", "BBOT:Aimbot.PriorityAuto", function(player)
        if not aimbot:GetRageConfig("Settings", "Priority Last") then return end
        if player == last_prioritized then
            return 10, "Auto"
        end
    end)
end

-------------------------------------
-- Ragebot
-------------------------------------
do
    local replication   = BBOT.aux.replication
    local char          = BBOT.aux.char
    local caster        = BBOT.aux.raycast
    local network       = BBOT.aux.network
    local sound         = BBOT.aux.sound

    local localplayer   = BBOT.service:GetService("LocalPlayer")
    local repupdate     = BBOT.repupdate
    local pathing       = BBOT.pathing
    local vector        = BBOT.vector
    local wrapback      = BBOT.iterators.Wrapback

    local phantoms      = game.Teams.Phantoms
    local ghosts        = game.Teams.Ghosts

    local charsbyplayer = getupvalue(replication.getallparts, 1)

    local dot = Vector3.zero.Dot

    -- a better implementation for profiling should be made later lol
    --[[profiles = {};]] 
    local pather = pathing.new()
    pather:SetRaycastCallback(function(data) -- collision filter
        local p = data.Instance
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
    local ragebot = { tpmethods = {}; hitboxshiftmethods = {}; next_shot = -1;
                        pather = pathing.new() }

    local cardinals = {
        -- Used for cardinal scanning
        Vector3.yAxis, -Vector3.yAxis,
        Vector3.xAxis, -Vector3.xAxis,
        -Vector3.zAxis, Vector3.zAxis
        --[[
            The cardinals covered
            (pretend the slashes next to the vertical bars are z-axis)

                \|/
            ----
            /|\
        ]]
    }

    local function bullet_filter(p)
        if not p.CanCollide then
            return true
        end
        if p.Transparency == 1 then
            return true
        end
        if p.Name ~= "Window" then
            return
        end
        return true
    end

    -- Does not use destination
    function aimbot:BulletCheck(origin, init_velocity, time, acceleration, penetration, step)
        if --[[coolmath.isNaN(time, true) or]] time > 1.5 then
            return
        end

        local ignore_env = { workspace.Players, workspace.Ignore }
        local reaches_target = true
        local passed = 0
        local step = step or (1 / 30)
        local bullet_pos = origin
        local bullet_vel = init_velocity
        local pen_power = penetration

        while passed < time do
            local dt = math.min(step, time - passed)
            local step_vel = dt * bullet_vel + 0.5 * acceleration * dt * dt
            -- vec, dir, extra, cb
            local enter_data = caster.raycast(bullet_pos, step_vel, ignore_env, bullet_filter, true)

            if enter_data then
                local unit = step_vel.Unit
                local enter = enter_data.Position
                local hit = enter_data.Instance

                local exit_data = caster.raycastSingleExit(enter, hit.Size.magnitude * unit, hit)
                if exit_data then
                    local dist = dot(unit, exit_data.Position - enter)
                    pen_power = pen_power - dist
                    if pen_power < 0 then
                        reaches_target = false
                        break
                    end
                end
                
                local true_dt = dot(step_vel, enter - bullet_pos) / dot(step_vel, step_vel) * dt
                bullet_pos = enter + 0.01 * unit
                bullet_vel = bullet_vel + true_dt * acceleration
                passed = passed + true_dt
                ignore_env[#ignore_env + 1] = hit
            else
                bullet_pos = bullet_pos + step_vel
                bullet_vel = bullet_vel + dt * acceleration
                passed = passed + dt
            end
        end

        return reaches_target
    end

    -------------------------------------
    -- TP scan methods
    -------------------------------------

    -- All TP method functions should
    -- at the very least take two arguments:
    -- from: Vector3, to: Vector3

    -- This ensures that they will work in compliance
    -- with the ragebot system
    do
        function ragebot.tpmethods.pathfinding(from, to)
            pather:SetFrom(from)
            pather:SetTo(to)
            return pather:Calculate()
        end

        -- I'm not sure how configurating the "resolution"
        -- of Frisbee scanning is going to work, but for
        -- all intents and purposes 5 is generally enough,
        -- plus the randomization...
        local angles = {}

        do
            local frisbee_res = 5
            -- horizontal
            for angle = -math.pi, math.pi, math.pi/frisbee_res do
                angles[#angles + 1] = Vector3.new(math.sin(angle), 0, math.cos(angle))
            end
            -- vertical	
            for angle = -math.pi, math.pi, math.pi/frisbee_res do
                angles[#angles + 1] = Vector3.new(0, math.sin(angle))
            end
        end

        -- This is called "frisbee" since it behaves somewhat
        -- like a frisbee: you toss the frisbee into multiple
        -- directions and measure how far the frisbee traveled
        -- in each direction, and choose the direction which
        -- ran the furthest distance.  

        -- This works very well for peeking outdoors and for
        -- moving to random locations on the map
        function ragebot.tpmethods.frisbee(from, to, steps)
            local path = { from }
            local last_dir
            for step = 1, (steps or 8) do
                local best_dist = -1/0
                local best_pos
                local rand_dist = math.random(9, 500)
                local cur_pos = path[#path]
                for i = 1, #angles do
                    local unit = angles[i] + 0.08 * vector.randomspherepoint(1)
                    if (not last_dir) or dot(unit, last_dir) > -0.5 then
                        local hit = repupdate:Raycast(cur_pos, unit * rand_dist)
                        local next_pos = hit and hit.Position - 0.1 * unit or cur_pos + (rand_dist - 5) * unit
                        local diff = next_pos - cur_pos
                        local dist_sq = dot(diff, diff)
                        if dist_sq > best_dist then
                            best_dist = dist_sq
                            best_pos = next_pos
                            last_dir = unit
                        end
                    end
                end
                if best_pos then
                    path[#path + 1] = best_pos
                end
            end
            return path
        end

        --[[function ragebot.tpmethods.spiralUpwards(from, to)
            local path = { from }

            local angle = 2 * math.random() * tau
            local yAngle = 0

            do
                local unit = Vector3.new(sin(angle), 0, cos(angle))
                local initialDirection = unit * 2048
                local cast = raycast.cast(from, initialDirection, {workspace.Players, workspace.Ignore}, collisionFilter)
                if not cast then
                    return
                end
                path[#path + 1] = cast.Position - 0.01 * unit
            end

            for i = 1, 16 do
                angle += rad(65)
                yAngle += 0.02
                local unit = Vector3.new(sin(angle), yAngle, cos(angle))
                local direction = unit * 4096
                local cast = raycast.cast(path[#path], direction, {workspace.Players, workspace.Ignore}, collisionFilter)
                path[#path + 1] = cast and cast.Position - unit or path[#path] + direction
            end

            return path
        end]]
    end

    -------------------------------------
    -- Hitbox shift methods
    -------------------------------------

    -- All hitbox shift method functions should
    -- at the very least take three arguments:
    -- from: Vector3, to: Vector3, dist: number
    do
        -- This attempts to return the closest position of visibility
        -- so that the first obstructing wall from "to" to "from"
        -- is visible to a potential second wall, or visible to "from"
        function ragebot.hitboxshiftmethods.raycasting(from, to, dist)
            local dir = from - to
            local cast = caster.raycast(to, dir, { workspace.Players, workspace.Ignore }, bullet_filter)
            return cast and to - dist * cast.Normal or to - dist * dir.Unit
        end

        -- Theres probably a better name for this one(?)
        function ragebot.hitboxshiftmethods.clamping(from, to, dist)
            local diff = from - to
            local shift = Vector3.new(diff.x > 0 and 1 or -1, diff.y > 0 and 1 or -1, diff.z > 0 and 1 or -1)
            return to + dist * shift.unit
        end

        function ragebot.hitboxshiftmethods.random(from, to, dist)
            return to + dist * vector.randomspherepoint(1)
        end

        local cardinal_cursor = 1
        function ragebot.hitboxshiftmethods.cardinals(from, to, dist)
            local offset = cardinals[cardinal_cursor]
            cardinal_cursor = (cardinal_cursor - 1) % #cardinals + 1
            return to + dist * offset
        end

        -- Pushes "to" towards "from" by "dist" studs
        function ragebot.hitboxshiftmethods.push(from, to, dist)
            return to + dist * (from - to).unit
        end
    end

    -- This WILL BE REQUIRED for ensuring players do not go outside
    -- of the map bounds (the default method preventing people from
    -- getting extremely far from the map)

    -- This method is present on every map in the game, so we will need
    -- to set this up later.

    function ragebot.fixPath(path)
        for i = 1, #path do
            local pos = path[i]
            if not repupdate:IsPosWithinMapBounds(pos) then
                path[i] = repupdate:ClampPosToMapBounds(pos)
            end
        end
    end

    -------------------------------------
    -- Method management
    -------------------------------------

    local tp_method_order = {}
    local hb_shift_method_order = {}

    for name, func in next, ragebot.tpmethods do
        tp_method_order[#tp_method_order + 1] = { name = name; func = func; success = false; successfulattempts = 0 }
    end

    for name, func in next, ragebot.hitboxshiftmethods do
        hb_shift_method_order[#hb_shift_method_order + 1] = { name = name; func = func; success = false; successfulattempts = 0 }
    end

    -- The above is done to minimize wasting time using
    -- methods that are not expedient to use at a given position.
    -- (implementation for sorting is in scanTargetSingle)

    -- Ex: one method may work better indoors than the other, so
    -- this will make sure that method will be used more supremely
    -- The moment a method fails, another method may be used which could work more often

    local function method_sort_predicate(l, r)
        local left_score = (l.success and 2 or 1) * l.successfulattempts
        local right_score = (r.success and 2 or 1) * r.successfulattempts
        return left_score > right_score
    end

    local function rage_target_sort_predicate(l, r)
        local server_pos = repupdate:GetPosition()

        local left_pos, right_pos = l.position, r.position

        local l_delta = left_pos  - server_pos
        local r_delta = right_pos - server_pos

        -- On most maps, getting very high in the sky means
        -- less walls will be obstructing the target, so we 
        -- want to make sure we are getting rid of these idiots first

        -- However, we still prefer also having the closest
        -- people in the list first, so we also consider
        -- horizontal distance
        local left_score  = math.abs( l_delta.x * l_delta.x  +  l_delta.z * l_delta.z ) + math.abs( l_delta.y ^ 4 )
        local right_score = math.abs( r_delta.x * r_delta.x  +  r_delta.z * r_delta.z ) + math.abs( r_delta.y ^ 4 )

        -- TODO: Add spawn time as a heuristic to maximize spawn-killing
        -- TODO: Add priority

        return right_score > left_score
    end

    -- Start actual ragebot scanning stuff

    -- Cream, do your organization magic (make this not super weird)
    local cardinal_cursor     = 1 -- Used for wrapback iteration
    local tp_method_cursor    = 1
    local hb_method_cursor    = 1
    local ticket              = -1 -- Used for sending bullets
    local next_teleport       = -1 -- Used for throttling teleport scanning
    local flip                = true -- Used for other things that occur every other frame or check (?) i guess

    function aimbot:ScanRageTargetSingle(origin, gun, target, target_data)
        --[[
            Target information structure
                {
                    firepos = <Vector3> position
                    waypoints = Array<Vector3>? waypoints
                targets = {
                    an array of these kinds of tables
                    {
                        player = <Player> player
                        launchvelocity = <Vector3> velocity
                        hitpos = <Vector3> position
                        traveltime = <number> duration
                    }, ...
                }
            }
        ]]

        local multipoint_amt           = 3
        local tp_methods_per_player    = 2
        local max_teleports_per_second = 8
        local waypoint_skip            = 2

        local data = gun.data

        local hb_shift_method              = hb_shift_method_order[hb_method_cursor]
        local hitbox_pos                   = flip and hb_shift_method.func(origin, target.position, 5) or target.position
        -- This is corrected for the bullet congruency check
        local firepos                      = target_data and target_data.firepos or origin + 0.01 * (hitbox_pos - origin).unit
        -- Check normally
        local launch_velocity, travel_time = physics.trajectory(firepos, self.bullet_gravity, hitbox_pos, data.bulletspeed)
        local reaches_target               = self:BulletCheck(firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
        if reaches_target then
            if target_data then
                target_data.targets[#target_data.targets + 1] = {
                    player         = target.player,
                    hitpos         = hitbox_pos,
                    launchvelocity = launch_velocity,
                    traveltime     = travel_time
                }
            end

            return target_data or {
                firepos = firepos,
                targets = {
                    {
                        player         = target.player,
                        hitpos         = hitbox_pos,
                        launchvelocity = launch_velocity,
                        traveltime     = travel_time
                    }
                }
            }
        elseif not target_data then
            -- Proceed with alternative techniques

            -- This is where the ragebot becomes unsafe to use without being banned
            if flip then
                -- Try a bunch of random points

                -- Cream - you'll probably just condense these into something
                -- like the old loop over the points setup in the rage config
                for i = 1, multipoint_amt do
                    local new_firepos = origin + 9.9 * vector.randomspherepoint(1)
                    local new_hitpos = flip and hb_shift_method.func(new_firepos, target.position, 5) or hitbox_pos
                    local launch_velocity, travel_time = physics.trajectory(new_firepos, self.bullet_gravity, new_hitpos, data.bulletspeed)
                    local reaches_target = self:BulletCheck(new_firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
                    if reaches_target then
                        return {
                            firepos = new_firepos,
                            --hitboxmethod = flip and hb_shift_method.name or nil,
                            targets = {
                                {
                                    player = target.player,
                                    hitpos = new_hitpos,
                                    launchvelocity = launch_velocity,
                                    traveltime = travel_time
                                }
                            }
                        }
                    end
                end
            else
                -- Good old cardinal scanning
                for j, vec in wrapback(cardinals, cardinal_cursor, multipoint_amt) do
                    local new_firepos = origin + 9.9 * vec
                    local new_hitpos = flip and hb_shift_method.func(new_firepos, target.position, 5) or hitbox_pos
                    local launch_velocity, travel_time = physics.trajectory(new_firepos, self.bullet_gravity, new_hitpos, data.bulletspeed)
                    local reaches_target = self:BulletCheck(new_firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
                    if reaches_target then
                        return {
                            firepos = new_firepos,
                            --hitboxmethod = flip and hb_shift_method.name or nil,
                            targets = {
                                {
                                    player = target.player,
                                    hitpos = new_hitpos,
                                    launchvelocity = launch_velocity,
                                    traveltime = travel_time
                                }
                            }
                        }
                    end
                end

                cardinal_cursor += multipoint_amt -- not wrapped around
            end

            -- It probably still didn't hit, lets teleport scan
            -- Are we on a cooldown?
            local now = os.clock()
            if now > next_teleport then
                table.sort(tp_method_order, method_sort_predicate) -- sort first

                for j, method_data in wrapback(tp_method_order, tp_method_cursor, tp_methods_per_player) do
                    local path = method_data.func(origin, hitbox_pos)
                    if (not path) or #path == 0 then
                        method_data.success = false
                        continue
                    end
                    ragebot.fixPath(path) -- fucking annoying that i have to do this
                    for k = 2, #path, waypoint_skip + 1 do
                        local new_firepos = path[k]
                        local new_hitpos = flip and hb_shift_method.func(new_firepos, target.position, 5) or hitbox_pos
                        local launch_velocity, travel_time = physics.trajectory(new_firepos, self.bullet_gravity, new_hitpos, data.bulletspeed)
                        local reaches_target = self:BulletCheck(new_firepos, launch_velocity, travel_time, self.bullet_gravity, data.penetrationdepth)
                        method_data.success = reaches_target

                        if reaches_target then
                            method_data.successfulattempts += 1
                            if hb_shift_method then
                                hb_shift_method.successfulattempts += 1
                            end
                            next_teleport = now + (1/max_teleports_per_second)
                            return {
                                firepos = new_firepos,
                                waypoints = table.pack(table.unpack(path, 1, k)), -- Trimming the path from 1 to k (where we are on the path)
                                --[[method = method_data.name, 		This was just some debug stuff in my hack to see which methods were used
                                hitboxmethod = flip and hb_shift_method.name or nil,]]
                                targets = {
                                    {
                                        player = target.player,
                                        hitpos = new_hitpos,
                                        launchvelocity = launch_velocity,
                                        traveltime = travel_time
                                    }
                                }
                            }
                        else
                            if method_data.successfulattempts > 0 then
                                method_data.successfulattempts -= 1
                            end
                            if flip and hb_shift_method.successfulattempts > 0 then
                                hb_shift_method.successfulattempts -= 1
                            end
                        end
                    end
                end

                tp_method_cursor += tp_methods_per_player
                if flip then
                    hb_method_cursor = hb_method_cursor % #hb_shift_method_order + 1
                end
            end
        end
    end

    function aimbot:GetRageTargets(gun)
        local valid_targets = {}
        do
            local other_team = localplayer.Team == phantoms and ghosts or phantoms
            local p_list = other_team:GetPlayers()

            for i = 1, #p_list do
                local player = p_list[i]
                local updater = replication.getupdater(player)

                if updater and updater.alive then
                    -- TODO: change the backup position to something that will fail less
                    table.insert(valid_targets, {
                        player = player,
                        position = updater.receivedPosition or charsbyplayer[player].torso.Position,
                        updater = updater
                    })
                end
            end
        end

        if #valid_targets == 0 then
            return
        end
        -- there's no real reason to sort when theres only one guy
        if #valid_targets > 1 then
            -- sort the targets using the predicate
            table.sort(valid_targets, rage_target_sort_predicate)
        end

        --local playersScanned = math.min(#valid_targets, menu.flags.aimbot_ppf)

        -- There is an exception to this value
        -- which will be explained further down
        -- in the targetting scheme
        local players_scanned = #valid_targets -- fuck
        local target_data
        local origin = repupdate:GetPosition()
        for i = 1, players_scanned do
            local target = valid_targets[i]
            target_data = self:ScanRageTargetSingle(origin, gun, target)

            if target_data then
                -- Might add this back later
                --[[if (i + 1 + menu.flags.aimbot_maxbulktargets) <= #valid_targets then
                    for ii = i+1, i + 1 + menu.flags.aimbot_maxbulktargets do
                        local other_target = valid_targets[ii]
                        self:ScanRageTargetSingle(origin, gun, other_target, target_data)
                    end
                end]]
                break
            end
        end

        return target_data
    end

    function aimbot:RageStep(gun)
        local now = os.clock()
        if now >= ragebot.next_shot then
            local target_data = self:GetRageTargets(gun)
            if target_data then
                -- teleport if needs be
                if target_data.waypoints then
                    local headheight_vec = Vector3.new(0, char.headheight)
                    -- I have to do this for now
                    for i = 1, #target_data.waypoints do
                        repupdate:MoveTo(target_data.waypoints[i] - headheight_vec)
                    end
                    --pathway, col, opacity, time
                    BBOT.drawpather:Simple(target_data.waypoints, Color3.new(1, 1), 1, 5)
                end

                local data = gun.data
                local server_pos = repupdate:GetPosition()

                do
                    local circ = BBOT.draw:Create("Circle", "3D")
                    circ.Point = server_pos
                    circ.Visible = true
                    circ.Thickness = 2
                    circ.Radius = 10
                    circ.Opacity = 0.8
                    circ.NumSides = 10
                    circ.Filled = false
                    circ.Color = Color3.new(0.262745, 0.960784, 0.262745)

                    BBOT.timer:Simple(5, function()
                        circ:Remove()
                    end)

                    local circ = BBOT.draw:Create("Circle", "3D")
                    circ.Point = target_data.firepos
                    circ.Visible = true
                    circ.Thickness = 2
                    circ.Radius = 10
                    circ.Opacity = 0.8
                    circ.NumSides = 10
                    circ.Filled = false
                    circ.Color = Color3.new(1.0, 0.0, 0.298039)

                    BBOT.timer:Simple(5, function()
                        circ:Remove()
                    end)
                end

                -- shoot bullets
                for i = 1, #target_data.targets do
                    local target_info = target_data.targets[i]
                    local bullets = {}
                    local packets = {}
                    local new_ticket = ticket - ((data.pelletcount or 1)-1)
                    for id = ticket, new_ticket, -1 do
                        bullets[#bullets + 1] = { target_info.launchvelocity, id }
                        packets[#packets + 1] = { target_info.player, target_info.hitpos, "Head", id }
                    end

                    network:send("newbullets", {
                        firepos = target_data.firepos,
                        camerapos = server_pos, -- If you don't do this you will just dump
                        bullets = bullets
                    }, tick())
                    -- Hit
                    for j = 1, #packets do
                        network:send("bullethit", unpack(packets[j]))
                    end
                    -- I'll send the timestamp even though
                    -- they don't really use it anymore(?)
                    -- better safe than sorry

                    ticket = new_ticket - 1
                end

                local firerate = typeof(data.firerate) == "number" and data.firerate or data.firerate[1]
                ragebot.next_shot = math.min(now + (#target_data.targets * (60 / (firerate * 3))), now + 1) -- cool

                -- teleport back if needs be
                if target_data.waypoints then
                    local headheight_vec = Vector3.new(0, char.headheight)
                    -- I have to do this for now
                    for i = #target_data.waypoints, 1, -1 do
                        repupdate:MoveTo(target_data.waypoints[i] - headheight_vec)	
                    end
                end

                -- Play fire sound just for auditory feedback
                sound.PlaySoundId(data.firesoundid, data.firevolume, data.firepitch, nil, nil, 0, 0.05)
            end
        end
    end
end

function aimbot:LegitStep(gun)
    if not gun or gun.knife or not gun.data.bulletspeed then return end
    --local profilename = "BBOT.Aimbot:LegitStep[" .. gun.name .. "]"
    --debug.profilebegin(profilename)

    --debug.profilebegin("SetCurrentType")
    self:SetCurrentType(gun)
    --debug.profileend()

    --debug.profilebegin("MouseStep")
    self:MouseStep(gun)
    --debug.profileend()

    --debug.profilebegin("TriggerBotStep")
    self:TriggerBotStep(gun)
    --debug.profileend()

    --debug.profilebegin("RedirectionStep")
    self:RedirectionStep(gun)
    --debug.profileend()

    --debug.profileend()
end

do
    --(visible, pos_x, pos_y, size, thickness, sides, clr, tablename)
    --[[Draw:Circle(false, 20, 20, 10, 3, 20, { 10, 10, 10, 215 }, menu.fovcircle)
    Draw:Circle(false, 20, 20, 10, 1, 20, { 255, 255, 255, 255 }, menu.fovcircle)]]
    local draw = BBOT.draw
    --(x, y, size, thickness, sides, color, transparency, visible)
    local fov = draw:Create("Circle", "2V") -- draw:Circle(0, 0, 1, 3, 314, { 10, 10, 10, 215 }, 1, false)
    fov.Radius = 1
    fov.NumSides = 314
    fov.Thickness = 1
    fov.Outlined = true
    fov.OutlineColor = Color3.new(0,0,0)
    fov.OutlineThickness = 1
    fov.Color = Color3.new(1,1,1)

    aimbot.fov_circle = fov
    aimbot.fov_circle_last = {Position = Vector2.new(), Radius = 0}

    local dzfov = draw:Clone(fov)
    aimbot.dzfov_circle = dzfov
    aimbot.dzfov_circle_last = {Position = Vector2.new(), Radius = 0}

    local sfov = draw:Clone(fov)
    aimbot.sfov_circle = sfov
    aimbot.sfov_circle_last = {Position = Vector2.new(), Radius = 0}

    local rfov = draw:Clone(fov)
    aimbot.rfov_circle = rfov
    aimbot.rfov_circle_last = {Position = Vector2.new(), Radius = 0}

    local tfov = draw:Clone(fov)
    aimbot.tfov_circle = tfov
    aimbot.tfov_circle_last = {Position = Vector2.new(), Radius = 0}

    hook:Add("Initialize", "BBOT:Visuals.Aimbot.FOV", function()
        local color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist", "Color")
        fov.Color = color
        fov.Opacity = transparency
        fov.OutlineOpacity = transparency
        color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone", "Color")
        dzfov.Color = color
        dzfov.Opacity = transparency
        dzfov.OutlineOpacity = transparency
        color, transparency = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect", "Color")
        sfov.Color = color
        sfov.Opacity = transparency
        sfov.OutlineOpacity = transparency
        color, transparency = config:GetValue("Main", "Visuals", "FOV", "Ragebot", "Color")
        rfov.Color = color
        rfov.Opacity = transparency
        rfov.OutlineOpacity = transparency
        color, transparency = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot", "Color")
        tfov.Color = color
        tfov.Opacity = transparency
        tfov.OutlineOpacity = transparency
    end)
    
    hook:Add("OnConfigChanged", "BBOT:Visuals.Aimbot.FOV", function(steps, old, new)
        if config:IsPathwayEqual(steps, "Main", "Visuals", "FOV") or config:IsPathwayEqual(steps, "Main", "Legit") or config:IsPathwayEqual(steps, "Main", "Rage", "Aimbot") then
            local center = camera.ViewportSize/2
            fov.Offset = center
            dzfov.Offset = center
            sfov.Offset = center
            tfov.Offset = center
            rfov.Offset = center

            local color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist", "Color")
            fov.Color = color
            fov.Opacity = transparency
            fov.OutlineOpacity = transparency
            color, transparency = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone", "Color")
            dzfov.Color = color
            dzfov.Opacity = transparency
            dzfov.OutlineOpacity = transparency
            color, transparency = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect", "Color")
            sfov.Color = color
            sfov.Opacity = transparency
            sfov.OutlineOpacity = transparency
            color, transparency = config:GetValue("Main", "Visuals", "FOV", "Ragebot", "Color")
            rfov.Color = color
            rfov.Opacity = transparency
            rfov.OutlineOpacity = transparency
            color, transparency = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot", "Color")
            tfov.Color = color
            tfov.Opacity = transparency
            tfov.OutlineOpacity = transparency

            fov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist")
            dzfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone")
            sfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect")
            tfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot")
            rfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Ragebot")

            local yport = camera.ViewportSize.y
            
            if not char.alive and config:IsPathwayEqual(steps, "Main", "Legit") and steps[3] then
                local _fov = config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Aimbot FOV")
                local _dzfov = config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Deadzone FOV")
                local _sfov = config:GetValue("Main", "Legit", steps[3], "Bullet Redirect", "Redirection FOV")
                local _tfov = config:GetValue("Main", "Legit", steps[3], "Trigger Bot", "Trigger FOV")
                if config:GetValue("Main", "Legit", steps[3], "Aim Assist", "Dynamic FOV") then
                    _fov = camera.FieldOfView / char.unaimedfov * _fov
                    _dzfov = camera.FieldOfView / char.unaimedfov * _dzfov
                    _sfov = camera.FieldOfView / char.unaimedfov * _sfov
                    _tfov = camera.FieldOfView / char.unaimedfov * _tfov
                end
                fov.Radius = _fov / camera.FieldOfView  * yport
                aimbot.fov_circle_last.Radius = _fov / camera.FieldOfView  * yport

                dzfov.Radius = _dzfov / camera.FieldOfView  * yport
                aimbot.dzfov_circle_last.Radius = _dzfov / camera.FieldOfView  * yport

                sfov.Radius = _sfov / camera.FieldOfView  * yport
                aimbot.sfov_circle_last.Radius = _sfov / camera.FieldOfView  * yport

                tfov.Radius = _tfov / camera.FieldOfView  * yport
                aimbot.tfov_circle_last.Radius = _tfov / camera.FieldOfView  * yport
            end

            
            local _rfov = config:GetValue("Main", "Rage", "Aimbot", "Aimbot FOV")
            _rfov = camera.FieldOfView / char.unaimedfov * _rfov
            rfov.Radius = _rfov / camera.FieldOfView  * yport
            aimbot.rfov_circle_last.Radius = _rfov / camera.FieldOfView  * yport
            aimbot.rfov_circle_last = {Position = center, Radius = rfov.Radius}

            if not config:GetValue("Main", "Visuals", "FOV", "Enabled") then
                fov.Visible = false
                dzfov.Visible = false
                sfov.Visible = false
                rfov.Visible = false
                tfov.Visible = false
            end
        end
    end)
    
    local alive, curgun = false, false
    hook:Add("PreCalculateCrosshair", "BBOT:Visuals.Aimbot.FOV", function(position_override, onscreen)
        local enabled = config:GetValue("Main", "Visuals", "FOV", "Enabled")
        position_override = Vector2.new(position_override.X, position_override.Y)
        local set = false
        if enabled and alive ~= char.alive then
            alive = char.alive
            local bool = (alive and true or false)
            fov.Visible = bool
            dzfov.Visible = bool
            sfov.Visible = bool
            rfov.Visible = bool
            tfov.Visible = bool
            set = true
        end
    
        local mycurgun = gamelogic.currentgun
        if enabled and mycurgun and mycurgun.data and mycurgun.data.bulletspeed then
            aimbot:SetCurrentType(mycurgun)
            local _fov = aimbot:GetLegitConfig("Aim Assist", "Aimbot FOV")
            local _dzfov = aimbot:GetLegitConfig("Aim Assist", "Deadzone FOV")
            local _sfov = aimbot:GetLegitConfig("Bullet Redirect", "Redirection FOV")
            local _tfov = aimbot:GetLegitConfig("Trigger Bot", "Trigger FOV")
            if aimbot:GetLegitConfig("Aim Assist", "Dynamic FOV") then
                _fov = camera.FieldOfView / char.unaimedfov * _fov
                _dzfov = camera.FieldOfView / char.unaimedfov * _dzfov
                _sfov = camera.FieldOfView / char.unaimedfov * _sfov
                _tfov = camera.FieldOfView / char.unaimedfov * _tfov
            end

            local yport = camera.ViewportSize.y
            fov.Radius = _fov / camera.FieldOfView  * yport
            dzfov.Radius = _dzfov / camera.FieldOfView  * yport
            sfov.Radius = _sfov / camera.FieldOfView  * yport
            tfov.Radius = _tfov / camera.FieldOfView  * yport

            
            aimbot.fov_circle_last.Radius = fov.Radius
            aimbot.dzfov_circle_last.Radius = dzfov.Radius
            aimbot.sfov_circle_last.Radius = sfov.Radius
            aimbot.tfov_circle_last.Radius = tfov.Radius

            if aimbot:GetLegitConfig("Aim Assist", "Use Barrel") then
                fov.Offset = position_override
                dzfov.Offset = position_override
                aimbot.fov_circle_last.Position = position_override
                aimbot.dzfov_circle_last.Position = position_override
            else
                local center = camera.ViewportSize/2
                fov.Offset = center
                dzfov.Offset = center
                aimbot.fov_circle_last.Position = center
                aimbot.dzfov_circle_last.Position = center
            end

            if aimbot:GetLegitConfig("Bullet Redirect", "Use Barrel") then
                sfov.Offset = position_override
                aimbot.sfov_circle_last.Position = position_override
            else
                local center = camera.ViewportSize/2
                sfov.Offset = center
                aimbot.sfov_circle_last.Position = center
            end

            local center = camera.ViewportSize/2
            tfov.Offset = center
            aimbot.tfov_circle_last.Position = center
        end
        
        if enabled and curgun ~= gamelogic.currentgun or set then
            curgun = gamelogic.currentgun
            if curgun and curgun.data and curgun.data.bulletspeed then
                aimbot:SetCurrentType(curgun)

                local _fov_enabled = aimbot:GetLegitConfig("Aim Assist", "Enabled")
                local _sfov_enabled = aimbot:GetLegitConfig("Bullet Redirect", "Enabled")
                local _tfov_enabled = aimbot:GetLegitConfig("Trigger Bot", "Enabled")

                fov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist") and _fov_enabled
                dzfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Aim Assist Deadzone") and _fov_enabled
                sfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Bullet Redirect") and _sfov_enabled
                tfov.Visible = config:GetValue("Main", "Visuals", "FOV", "Trigger Bot") and _tfov_enabled
            else
                local bool = false
                fov.Visible = bool
                dzfov.Visible = bool
                sfov.Visible = bool
                tfov.Visible = bool
            end
        end
    end)
end

do -- Crosshair
    --draw:Box(x, y, w, h, thickness, color, transparency, visible)
    --draw:Line(thickness, start_x, start_y, end_x, end_y, color, transparency, visible)\
    --[[
    object.Visible = visible
    object.Thickness = thickness
    object.From = Vector2.new(start_x, start_y)
    object.To = Vector2.new(end_x, end_y)
    object.Color = self:VerifyColor(color)
    object.Transparency = transparency 
    ]]

    local center_outline = draw:Create("Rect", "2V")
    center_outline.XAlignment = XAlignment.Right
    center_outline.YAlignment = YAlignment.Bottom
    center_outline.Color = Color3.new(1,1,1)

    local top_outline = draw:Create("Line", "2V", "2V")
    top_outline.Color = Color3.new(1,1,1)
    top_outline.Thickness = 2

    local top = draw:Create("Line", "2V", "2V")
    top.Color = Color3.new(0,0,0)

    local crosshair_objects = {
        center_outline = center_outline,
        top_outline = top_outline,
        bottom_outline = draw:Clone(top_outline),
        left_outline = draw:Clone(top_outline),
        right_outline = draw:Clone(top_outline),
        center = draw:Clone(center_outline),
        top = top,
        bottom = draw:Clone(top),
        left = draw:Clone(top),
        right = draw:Clone(top),
    }

    hook:Add("OnConfigChanged", "BBOT:Crosshair.Changed", function(steps, old, new)
        if config:IsPathwayEqual(steps, "Main", "Visuals", "Crosshair") then
            local enabled = config:GetValue("Main", "Visuals", "Crosshair", "Enabled")
            local inner, inner_transparency = config:GetValue("Main", "Visuals", "Crosshair", "Enabled", "Inner")
            local outter, outter_transparency = config:GetValue("Main", "Visuals", "Crosshair", "Enabled", "Outter")
            local width = config:GetValue("Main", "Visuals", "Crosshair", "Width")
            local height = config:GetValue("Main", "Visuals", "Crosshair", "Height")
            if not enabled then
                for k, v in pairs(crosshair_objects) do
                    v.Visible = false
                end
            else
                for k, v in pairs(crosshair_objects) do
                    if string.find(k, "outline", 1, true) then
                        v.Color = outter
                        v.Transparency = outter_transparency
                    else
                        v.Color = inner
                        v.Transparency = inner_transparency
                    end
                end

                local setup = config:GetValue("Main", "Visuals", "Crosshair", "Setup")
                crosshair_objects.center.Visible = setup.Center
                crosshair_objects.top.Visible = setup.Top
                crosshair_objects.bottom.Visible = setup.Bottom
                crosshair_objects.left.Visible = setup.Left
                crosshair_objects.right.Visible = setup.Right

                crosshair_objects.center_outline.Visible = setup.Center
                crosshair_objects.top_outline.Visible = setup.Top
                crosshair_objects.bottom_outline.Visible = setup.Bottom
                crosshair_objects.left_outline.Visible = setup.Left
                crosshair_objects.right_outline.Visible = setup.Right


                crosshair_objects.center.Size = Vector2.new(2, 2)
                crosshair_objects.top.Thickness = width
                crosshair_objects.bottom.Thickness = width
                crosshair_objects.left.Thickness = width
                crosshair_objects.right.Thickness = width

                width, height = width+2, height+2
                crosshair_objects.center_outline.Size = Vector2.new(2+2, 2+2)
                crosshair_objects.top_outline.Thickness = width
                crosshair_objects.bottom_outline.Thickness = width
                crosshair_objects.left_outline.Thickness = width
                crosshair_objects.right_outline.Thickness = width
            end
        end
    end)

    local lastrot = 0
    function aimbot:CrosshairStep(delta, gun)
        local enabled = config:GetValue("Main", "Visuals", "Crosshair", "Enabled")
        local positionoverride, ondascreen
        if gun then
            local part = (gun.isaiming() and BBOT.weapons.GetToggledSight(gun).sightpart or gun.barrel)
            if part then
                if enabled then
                    for k, v in pairs(crosshair_objects) do
                        v.Visible = false
                    end
                end
                ondascreen = false

                local raycastdata = self:raycastbullet(camera.CFrame.Position,part.CFrame.Position-camera.CFrame.Position)
                if raycastdata and raycastdata.Position then
                    local point, onscreen = camera:WorldToViewportPoint(raycastdata.Position)
                    positionoverride = point
                else
                    raycastdata = self:raycastbullet(part.CFrame.Position,part.CFrame.LookVector * 10000)
                    if raycastdata and raycastdata.Position then
                        local point, onscreen = camera:WorldToViewportPoint(raycastdata.Position)
                        positionoverride = point
                    else
                        local point, onscreen = camera:WorldToViewportPoint(part.CFrame.Position + part.CFrame.LookVector * 10000)
                        positionoverride = point
                    end
                end
                if positionoverride then
                    if enabled then
                        for k, v in pairs(crosshair_objects) do
                            v.Visible = true
                        end
                    end
                    ondascreen = true
                end
            end
        end

        hook:Call("PreCalculateCrosshair", (positionoverride and positionoverride or (camera.ViewportSize/2)), ondascreen)
        if not enabled then return end

        local setup = config:GetValue("Main", "Visuals", "Crosshair", "Setup")
        local gap = config:GetValue("Main", "Visuals", "Crosshair", "Gap")
        local width = config:GetValue("Main", "Visuals", "Crosshair", "Width")
        local height = config:GetValue("Main", "Visuals", "Crosshair", "Height")

        local addrot = 0
        if config:GetValue("Main", "Visuals", "Crosshair", "Animations") then
            local type = config:GetValue("Main", "Visuals", "Crosshair", "Animation Type")
            if type == "Wave" then
                addrot = math.sin(config:GetValue("Main", "Visuals", "Crosshair", "Animation Speed") * tick()) * config:GetValue("Main", "Visuals", "Crosshair", "Animation Amplitude")
            else
                addrot = lastrot + config:GetValue("Main", "Visuals", "Crosshair", "Animation Speed") * delta
                if addrot > 360 then
                    addrot = addrot - 360
                end
                lastrot = addrot
            end
        end
        
        local rot = 0 + addrot
        local rad = math.rad(rot)
        local cs, sn = math.cos(rad), math.sin(rad)
        local outline_vec = Vector2.new(1,1)
        
        if setup.Center then
            local part = crosshair_objects.center
            local part_outline = crosshair_objects.center_outline
            if positionoverride then
                part.Offset = Vector2.new(positionoverride.x-part.Size.X/2,positionoverride.y-part.Size.Y/2)
            else
                part.Offset = (camera.ViewportSize/2) + Vector2.new(-part.Size.X/2,-part.Size.Y/2)
            end
            part_outline.Offset = part.Offset-outline_vec
            --part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot
        elseif crosshair_objects.center_outline.Visible then
            crosshair_objects.center.Visible = false
            crosshair_objects.center_outline.Visible = false
        end
        
        local addgap = 0
        --[[if config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Enable") then
            local type = config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Type")
            if type == "Wave" then
                addgap = math.sin(config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Speed") * tick()) * config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Amplitude")
            else
                addgap = lastgap + config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Speed") * DeltaTime
                if addgap > config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Max") then
                    addgap = addgap - config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Max")
                    addgap = addgap + config:GetValue("Visuals", "Crosshair", "Animation", "Gap", "Min")
                end
                lastgap = addgap
            end
        end]]
        
        gap = gap + addgap
        
        if setup.Top then
            local part = crosshair_objects.top
            local part_outline = crosshair_objects.top_outline
            local gapx = 0 * cs - (-gap) * sn;
            local gapy = 0 * sn + (-gap) * cs;
            local heightx = 0 * cs - (-height) * sn;
            local heighty = 0 * sn + (-height) * cs;
        
            if positionoverride then
                part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
            else
                part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
            end
            part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
            local outlinex = 0 * cs - (-1) * sn;
            local outliney = 0 * sn + (-1) * cs;
            part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
            part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
            
            --part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot
        elseif crosshair_objects.top_outline.Visible then
            crosshair_objects.top.Visible = false
            crosshair_objects.top_outline.Visible = false
        end
        
        if setup.Bottom then
            local part = crosshair_objects.bottom
            local part_outline = crosshair_objects.bottom_outline
            local gapx = 0 * cs - (gap) * sn;
            local gapy = 0 * sn + (gap) * cs;
            local heightx = 0 * cs - (height) * sn;
            local heighty = 0 * sn + (height) * cs;
        
            if positionoverride then
                part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
            else
                part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
            end
            part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
            local outlinex = 0 * cs - (1) * sn;
            local outliney = 0 * sn + (1) * cs;
            part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
            part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
            
            --part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot - 180
        elseif crosshair_objects.bottom_outline.Visible then
            crosshair_objects.bottom.Visible = false
            crosshair_objects.bottom_outline.Visible = false
        end
        
        if setup.Left then
            local part = crosshair_objects.left
            local part_outline = crosshair_objects.left_outline
            local gapx = (-gap) * cs - 0 * sn;
            local gapy = (-gap) * sn + 0 * cs;
            local heightx = (-height) * cs - 0 * sn;
            local heighty = (-height) * sn + 0 * cs;
        
            if positionoverride then
                part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
            else
                part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
            end
            part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
            local outlinex = (-1) * cs - 0 * sn;
            local outliney = (-1) * sn + 0 * cs;
            part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
            part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
            
            --part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot - 90
        elseif crosshair_objects.left_outline.Visible then
            crosshair_objects.left.Visible = false
            crosshair_objects.left_outline.Visible = false
        end
        
        if setup.Right then
            local part = crosshair_objects.right
            local part_outline = crosshair_objects.right_outline
            local gapx = (gap) * cs - 0 * sn;
            local gapy = (gap) * sn + 0 * cs;
            local heightx = (height) * cs - 0 * sn;
            local heighty = (height) * sn + 0 * cs;
        
            if positionoverride then
                part.Offset1 = Vector2.new(positionoverride.x+gapx,positionoverride.y+gapy)
            else
                part.Offset1 = (camera.ViewportSize/2) + Vector2.new(gapx,gapy)
            end
            part.Offset2 = part.Offset1 + Vector2.new(heightx, heighty)
            local outlinex = (1) * cs - 0 * sn;
            local outliney = (1) * sn + 0 * cs;
            part_outline.Offset1 = part.Offset1 - Vector2.new(outlinex, outliney)
            part_outline.Offset2 = part.Offset2 + Vector2.new(outlinex, outliney)
            
            --part.Rotation = config:GetValue("Visuals", "Crosshair", "Outter", "Rotation") + rot + 90
        elseif crosshair_objects.right_outline.Visible then
            crosshair_objects.right.Visible = false
            crosshair_objects.right_outline.Visible = false
        end
    end
end

local t = 0
hook:Add("RenderStepped", "BBOT:Aimbot.CrosshairStep", function(DeltaTime)
    if gamelogic.currentgun and gamelogic.currentgun.data and gamelogic.currentgun.data.bulletspeed then return end
    t = tick()
    aimbot:CrosshairStep(DeltaTime)
end)

-- Do aimbot stuff here
hook:Add("PreFireStep", "BBOT:Aimbot.Calculate", function(gun)
    if config:GetValue("Main", "Rage", "Aimbot", "Rage Bot") then
        aimbot:RageStep(gun)
    else
        aimbot:LegitStep(gun)
    end
end)

-- If the aimbot stuff before is persistant, use this to restore
hook:Add("PostFireStep", "BBOT:Aimbot.Calculate", function(gun)
    if aimbot.silent and aimbot.silent.Parent then
        if aimbot.silent_data then
            aimbot.silent.Position = aimbot.silent_data[1]
            aimbot.silent.Orientation = aimbot.silent_data[2]
        else
            aimbot.silent.Orientation = aimbot.silent.Parent.Trigger.Orientation
        end
        aimbot.silent_data = false
        aimbot.silent = false
    end

    if aimbot.fire then
        if gun.getfiremode then
            local mode, rate = gun:getfiremode()
            if mode == true and not hook:IsMouse1Down() then
                gun:shoot(false)
            end
        else
            gun:shoot(false)
        end
        aimbot.fire = nil
    end

    aimbot:CrosshairStep(tick()-t, gun)
    t = tick()
end)

-- Knife Aura --
function aimbot:kniferaycast(campos,diff,playerteamdata)
    return self:raycastbullet(campos,diff,playerteamdata,function(p1)
        local instance = p1.Instance
        if instance.Name == "Window" then return true end
        return not instance.CanCollide or instance.Transparency == 1
    end)
end

function aimbot:GetKnifeTarget()
    local mousePos = Vector3.new(mouse.x, mouse.y - 36, 0)
    local cam_position = camera.CFrame.p
    local team = (localplayer.Team and localplayer.Team.Name or "NA")
    local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]
    local aura_type = config:GetValue("Main", "Rage", "Extra", "Knife Bot Type")
    local hitscan_points = config:GetValue("Main", "Rage", "Extra", "Knife Hitscan")
    local visible_only = config:GetValue("Main", "Rage", "Extra", "Knife Visible Only")
    local range = config:GetValue("Main", "Rage", "Extra", "Knife Range")
    local priority_only = self:GetRageConfig("Settings", "Priority Only")

    local organizedPlayers = {}
    local plys = players:GetPlayers()
    local isteleport
    for i=1, #plys do
        local v = plys[i]
        if v == localplayer then
            continue
        end

        local parts = self:GetParts(v)
        if not parts then continue end
    
        if v.Team and v.Team == localplayer.Team then
            continue
        end

        local priority, reason = config:GetPriority(v)
        if priority_only and priority <= 0 then continue end

        local updater = replication.getupdater(v)

        if not updater.alive or not updater.receivedPosition then continue end

        local pos = updater.receivedPosition
        if (pos-cam_position).Magnitude > range then
            continue
        end

        if visible_only then
            local raydata = self:kniferaycast(cam_position,pos-cam_position,playerteamdata)
            if (not raydata or not raydata.Instance:IsDescendantOf(parts.head.Parent)) and (raydata and raydata.Position ~= pos) then continue end
        end

        for name, part in pairs(parts) do
            local name = partstosimple[name]
            if not name or hitscan_points ~= name then continue end
            table.insert(organizedPlayers, {v, part, name, pos})
        end
    end

    return organizedPlayers
end

local nextstab, block_equip = tick(), false
hook:Add("RenderStepped", "KnifeAura", function()
    if not char.alive or not config:GetValue("Main", "Rage", "Extra", "Knife Bot") or not config:GetValue("Main", "Rage", "Extra", "Knife Bot", "KeyBind") then return end
    local target = aimbot:GetKnifeTarget()
    if not target or not target[1] then return end
    if nextstab > tick() then return end
    block_equip = true
    local lastequipped = aimbot.equipped
    if lastequipped ~= 3 then
        network:send("equip", 3);
    end
    network:send("stab");
    for i=1, #target do
        local v = target[i]
        network:send("knifehit", v[1], tick(), v[2].Name)
    end
    if lastequipped ~= 3 then
        network:send("equip", lastequipped);
    end
    block_equip = false
    nextstab = tick() + config:GetValue("Main", "Rage", "Extra", "Knife Delay")
end)

aimbot.equipped = 1
hook:Add("PostNetworkSend", "Aimbot.Equipped", function(netname, slot)
    if netname ~= "equip" or block_equip then return end
    aimbot.equipped = slot
end)

return aimbot