local notification = BBOT.notification
local userinputservice = BBOT.service:GetService("UserInputService")
local camera = BBOT.service:GetService("CurrentCamera")
local localplayer = BBOT.service:GetService("LocalPlayer")
local _players = BBOT.service:GetService("Players")
local hook = BBOT.hook
local math = BBOT.math
local timer = BBOT.timer
local config = BBOT.config
local roundsystem = BBOT.aux.roundsystem
local network = BBOT.aux.network
local char = BBOT.aux.char
local loop = BBOT.loop
local string = BBOT.string
local table = BBOT.table
local aux_camera = BBOT.aux.camera
local vector = BBOT.vector
local hud = BBOT.aux.hud
local replication = BBOT.aux.replication
local gamelogic = BBOT.aux.gamelogic
local gamemenu = BBOT.aux.menu
local repupdate = BBOT.repupdate
local misc = {}

local CACHED_VEC3 = Vector3.new()

do
    hook:Add("OnConfigChanged", "BBOT:Misc.KillCamTimer", function(steps, old, new)
        if not config:IsPathwayEqual(steps, "Main", "Visuals", "Extra", "KillCam Timer") then return end
        BBOT.menu:UpdateStatus("Kill Cam", "None", new)
    end)

    local kill_time, kill_name = 0, ""
    hook:Add("PreBigAward", "BBOT:Misc.KillCamTimer", function(type, entity, gunname, earnings)
        kill_time = tick() + 5
        kill_name = entity.Name
    end)

    hook:Add("RenderStepped", "BBOT:Misc.KillCamTimer", function()
        if not config:GetValue("Main", "Visuals", "Extra", "KillCam Timer") then return end
        if kill_time > tick() then
            BBOT.menu:UpdateStatus("Kill Cam", kill_name .. " [" .. math.round(kill_time-tick(), 1) .. "]")
        else
            BBOT.menu:UpdateStatus("Kill Cam", "None")
        end
    end)
end

do
    -- Removes camera bob lul
    local char_distance, char_speed = 0, 0
    hook:Add("PreCameraStep", "BBOT:Misc.NoCameraBob", function()
        if config:GetValue("Main", "Visuals", "Camera Visuals", "No Camera Bob") then
            char_distance = char.distance
            char_speed = char.speed
            char.distance = 0
            char.speed = 0
        end
    end)

    hook:Add("PostCameraStep", "BBOT:Misc.NoCameraBob", function()
        if config:GetValue("Main", "Visuals", "Camera Visuals", "No Camera Bob") then
            char.distance = char_distance
            char.speed = char_speed
        end
    end)
end

local virtualuser = BBOT.service:GetService("VirtualUser")
hook:Add("LocalPlayer.Idled", "BBOT:Misc.AntiAFK", function()
    if config:GetValue("Main", "Misc", "Extra", "Anti AFK") then
        virtualuser:CaptureController()
        virtualuser:ClickButton2(Vector2.new())
    end
end)

local wasalive = false
local last_alive = 0
hook:Add("OnAliveChanged", "BBOT:AutoDeath", function()
    wasalive = true
    last_alive = tick()
end)

local game_version

local streamermode_old = hud.streamermode
hook:Add("Unload", "BBOT:StreamerMode", function()
    hud.streamermode = streamermode_old
end)

function hud.streamermode()
    return streamermode_old() or config:GetValue("Main", "Misc", "Extra", "Streamer Mode")
end

hook:Add("OnConfigChanged", "BBOT:StreamerMode", function(steps, old, new)
    if not config:IsPathwayEqual(steps, "Main", "Misc", "Extra", "Streamer Mode") then return end
    local chatgame = localplayer.PlayerGui:FindFirstChild("ChatGame")
    if chatgame then
        local version = chatgame:FindFirstChild("Version")
        if new then
            if not game_version then
                game_version = version.Text
            end
            version.Text = "Streamer-Mode"
        elseif game_version then
            version.Text = game_version
        end
    end
end)

hook:Add("PreupdateStep", "BBOT:Misc.DeRenderAll", function(player, controller, renderscale, shouldrender)
    if config:GetValue("Main", "Misc", "Extra", "Simple Characters") then
        return 0, false
    end
end)

do
    local function findplayer(name)
        local target = nil
        for k, v in pairs(_players:GetPlayers()) do
            if string.find(v.Name, name, 1, true) then
                target = v
                break
            end
        end
        return target
    end

    local httpservice = BBOT.service:GetService("HttpService")
    local path = "bitchbot/"..BBOT.game.."/data/accounts.json"
    local accounts, accounts_invert = {}, {}
    if isfile(path) then
        accounts = httpservice:JSONDecode(readfile(path))
    end
    
    accounts[BBOT.accountId] = BBOT.account or true
    for k, v in pairs(accounts) do accounts_invert[v] = k end
    writefile(path, httpservice:JSONEncode(accounts))

    loop:Run("BBOT:AutoFriendAccounts", function()
        if not isfile(path) then return end
        accounts = httpservice:JSONDecode(readfile(path))
        for k, v in pairs(accounts) do accounts_invert[v] = k end
    end, 5)

    hook:Add("GetPriority", "BBOT:AutoFriendAccounts", function(player)
        if not config:GetValue("Main", "Misc", "Extra", "Auto Friend Accounts") then return end
        if accounts[tostring(player.UserId)] then
            return -1, "Bot/Account"
        end
    end)

    hook:Add("Votekick.Start", "BBOT:AutoVoteNoOnFriends", function(target, delay, votesrequired)
        if target ~= localplayer.Name and config:GetPriority(findplayer(target)) < 0 and config:GetValue("Main", "Misc", "Extra", "Friends Votes No") then
            timer:Simple(.5, function() hud:vote("no") end)
        end
    end)

    hook:Add("Console", "BBOT:AutoVoteYesOnEnemy", function(message)
        if string.find(message, "has initiated a votekick on", 1, true) then
            local name = string.Explode(" ", message)
            name = name[1]
            if config:GetPriority(findplayer(name)) < 0 and config:GetValue("Main", "Misc", "Extra", "Assist Votekicks") then
                timer:Simple(math.random(2,15)/10, function() hud:vote("yes") end)
            end
        end
    end)

    hook:Add("PostInitialize", "BBOT:AutoHopOnFriends", function()
        local amount = config:GetValue("Main", "Misc", "Extra", "Auto Hop On Friends")
        if amount > 0 then
            local c = 0
            for k, v in pairs(_players:GetPlayers()) do
                local value, reason = config:GetPriority(v)
                if value == -1 then
                    c = c + 1
                end
            end
            if c >= amount then
                BBOT.serverhopper:RandomHop()
            end
        end
    end)
end

local runservice = BBOT.service:GetService("RunService")
local rendering3d_last = false
hook:Add("Heartbeat", "BBOT:3DRendering", function()
    local rendering = config:GetValue("Main", "Misc", "Extra", "Disable 3D Rendering")
    if rendering ~= rendering3d_last then
        runservice:Set3dRenderingEnabled(not rendering)
        rendering3d_last = rendering
    end
end)

setfpscap(144)
hook:Add("OnConfigChanged", "BBOT:FPSCap", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Misc", "Extra", "FPS Limiter") then
        if new == 300 then
            new = 1000
        end
        setfpscap(new)
    end
end)

local function checkaliveenemies()
    for player, controller in pairs(replication.player_registry) do
        if controller.updater and player ~= localplayer and player.Team ~= localplayer.Team and controller.updater.alive then
            if config:GetPriority(player) >= 0 then
                return true
            end
        end
    end
end

hook:Add("RenderStepped", "BBOT:AutoDeath", function()
    if wasalive and config:GetValue("Main", "Misc", "Extra", "Auto Death On Nades") and gamelogic.gammo < 1 and last_alive + .25 < tick() then
        hook:Call("AutoDeath")
        wasalive = false
        network:send("forcereset")
    elseif config:GetValue("Main", "Misc", "Extra", "Auto Spawn") and config:GetValue("Main", "Misc", "Extra", "Auto Spawn", "KeyBind") and not gamemenu.isdeployed() then
        local onalive = config:GetValue("Main", "Misc", "Extra", "Spawn On Alive")
        if not onalive or (onalive and checkaliveenemies()) then
            gamemenu:deploy()
            hook:Call("Spawn")
        end
    end
end)

hook:Add("Preupdatespawn", "BBOT:AutoDeath", function(player)
    if wasalive and player.Team ~= localplayer.Team and config:GetValue("Main", "Misc", "Extra", "Reset On Enemy Spawn") and config:GetPriority(player) >= 0 then
        hook:Call("AutoDeath")
        wasalive = false
        network:send("forcereset")
    end
end)

do
    function misc:TeleportToClosest()
        if BBOT.aimbot.tp_scanning then return end
        local players = {}
        for i, Player in pairs(_players:GetPlayers()) do
            if Player.Team == localplayer.Team then continue end
            local updater = replication.getupdater(Player)
            if updater and updater.alive then
                players[#players+1] = {Player, updater, updater.getpos()}
            end
        end

        if #players < 1 then return end

        local root_position = char.rootpart.Position
        table.sort(players, function(a, b)
            return (a[3] - root_position).Magnitude < (b[3] - root_position).Magnitude
        end)

        local points
        for i=1, #players do
            local player = players[i]
            if not char.alive or not player[2].alive then continue end
            local path, success = repupdate:TeleportTo(player[3], true)
            if success then
                local color, color_transparency = config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "Path Color")
                BBOT.drawpather:Simple(path, color, color_transparency, 4)
                return
            end
        end
    end

    function misc:IsPointInsidePart(part, point)
        local r = part.CFrame:PointToObjectSpace(point)
        local s = part.Size
        return math.abs(r.x) <= s.x/2 and math.abs(r.y) <= s.y/2 and math.abs(r.z) <= s.z/2
    end

    local mapRaycastParams = RaycastParams.new()
    mapRaycastParams.FilterType = Enum.RaycastFilterType.Whitelist
    mapRaycastParams.IgnoreWater = true

    -- direction must be unit
    -- literally only works sometimes but idfk
    function misc:GetNoclipSequence(origin, direction, stepDistance, maxSteps)
        mapRaycastParams.FilterDescendantsInstances = roundsystem.raycastwhitelist or {}

        local origin = origin or char.rootpart.Position
        local unit = direction
        local dir = unit * stepDistance

        local headheight = char.headheight
        -- for correcting stance bullshiz
        local headheightVec = Vector3.new(0, headheight)
        local correctedOrigin = origin + headheightVec
        local sequence = {correctedOrigin}

        local pass = true

        for _ = 1, maxSteps do
            local cast = workspace:Raycast(sequence[#sequence], dir, mapRaycastParams)
            if cast then
                local partHit = cast.Instance
                if partHit.ClassName == "Part" and partHit.Shape == Enum.PartType.Block and not partHit:FindFirstChildWhichIsA("Mesh") then
                    -- might need to add a congruency check
                    if misc:IsPointInsidePart(partHit, cast.Position) then
                        sequence[#sequence + 1] = cast.Position
                    else
                        -- point is probably just before the surface
                        pass = false
                        break
                    end
                else
                    -- cant pass through stupid slanted crazy looking ass parts
                    -- because roblox can solve those better and that function above
                    -- which tells if a point is inside of a part or not won't work on it 
                    -- as intended if it has a custom mesh (duh..)
                    pass = false
                    break
                end
            else
                sequence[#sequence + 1] = correctedOrigin + dir
            end
        end

        -- verify sequence isnt actually intersecting anything for some reason?? (roblo$$$raycasting$$)
        -- no, i shouldn't do this, but for some reason creams pathfinding shit isnt
        -- uber slow either??? even though it verifies paths like this

        for i = 1, #sequence - 1 do
            local current, next = sequence[i], sequence[i + 1]
            local diff = next - current
            if workspace:Raycast(current, diff, mapRaycastParams) then
                pass = false
                break
            end
        end

        return sequence, pass
    end

    local mouse = BBOT.service:GetService("Mouse")

    hook:Add("OnKeyBindChanged", "BBOT.Misc.ClickTP", function(steps, old, new)
        if char.alive and config:GetValue("Main", "Misc", "Exploits", "Click TP")
        and config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Click TP", "KeyBind") then
            local range = config:GetValue("Main", "Misc", "Exploits", "Click TP Range")
            local tp = BBOT.aimbot:raycastbullet(camera.CFrame.p, camera.CFrame.lookVector * (range == 0 and 2000 or range))
            if tp then
                repupdate:MoveTo(tp.Position - (camera.CFrame.lookVector * .5) + Vector3.new(0,3,0), true)
            elseif range ~= 0 then
                local pos = camera.CFrame.p + camera.CFrame.lookVector * range
                repupdate:MoveTo(pos - (camera.CFrame.lookVector * .5) + Vector3.new(0,3,0), true)
            end
        end
    end)

    hook:Add("OnKeyBindChanged", "BBOT.Misc.NoclipTest", function(steps, old, new)
        if char.alive and config:GetValue("Main", "Misc", "Exploits", "Noclip")
        and config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Noclip", "KeyBind") then
            -- (origin, direction, stepDistance, maxSteps)
            local directions = {
                -Vector3.xAxis,
                Vector3.xAxis,
                Vector3.zAxis,
                -Vector3.zAxis
            }

            local noclipSequence
            local rootPos = char.rootpart.Position

            for j = 1, #directions do
                local tempSequence, canNoclip = misc:GetNoclipSequence(rootPos, directions[j], 100, 16)

                if canNoclip then
                    noclipSequence = tempSequence
                    break
                end
            end

            if not noclipSequence then
                notification:Create("Noclip check failure")
                return
            else
                local camAngles = Vector2.new(BBOT.aux.camera.angles.x, BBOT.aux.camera.angles.y)
                if #noclipSequence > 2 then
                    local headheight = char.headheight
                    local headheightVec = Vector3.new(0, headheight)
                    BBOT.aux.network:send("repupdate", rootPos, camAngles, tick())
                    for i = 2, #noclipSequence do
                        local pos = noclipSequence[i] - headheightVec
                        repupdate:MoveTo(pos, false)
                    end

                    char.rootpart.Position = noclipSequence[#noclipSequence] - headheightVec
                    notification:Create("Noclip (probably) success")
                else
                    notification:Create("Not enough points in noclip sequence")
                end
            end
        end
    end)

    hook:Add("OnKeyBindChanged", "BBOT.Misc.Teleport", function(steps, old, new)
        if char.alive and config:GetValue("Main", "Misc", "Exploits", "Teleport to Player") and config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Teleport to Player", "KeyBind") then
            if BBOT.aimbot.tp_scanning then return end
            local players = {}
            for i, Player in pairs(_players:GetPlayers()) do
                if Player.Team == localplayer.Team then continue end
                local updater = replication.getupdater(Player)
                if updater and updater.alive then
                    local abspos = updater.getpos()
                    local pos, onscreen = camera:WorldToViewportPoint(abspos)
                    if onscreen then
                        players[#players+1] = {Player, pos, abspos, updater}
                    end
                end
            end

            local mousePos = Vector3.new(mouse.x, mouse.y + 36, 0)
            table.sort(players, function(a, b)
                return (a[2] - mousePos).Magnitude < (b[2] - mousePos).Magnitude
            end)

            local player = players[1]
            if not char.alive then return end
            local path, success = repupdate:TeleportTo(player[3], true)
            local color, color_transparency = config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "Path Color")
            BBOT.drawpather:Simple(path, color, color_transparency, 4)
        end
    end)
end

local next_teleport = 0
hook:Add("OnAliveChanged", "BBOT:Misc.AutoTeleport", function(alive)
    if alive and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport")["On Spawn"] and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "KeyBind") then
        next_teleport = tick() + 1
        misc:TeleportToClosest()
    end
end)

hook:Add("Postupdatespawn", "BBOT:Misc.AutoTeleport", function()
    if char.alive and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport")["On Enemy Spawn"] and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "KeyBind") then
        next_teleport = tick() + 1
        misc:TeleportToClosest()
    end
end)

hook:Add("RenderStepped", "BBOT:Misc.AutoTeleport", function()
    if char.alive and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport")["Enemies Alive"] and config:GetValue("Main", "Misc", "Exploits", "Auto Teleport", "KeyBind")  and next_teleport < tick() then
        next_teleport = tick() + 1
        misc:TeleportToClosest()
    end
end)

hook:Add("OnConfigChanged", "BBOT:Misc.Fly", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Misc", "Movement", "Fly") and not config:IsPathwayEqual(steps, "Main", "Misc", "Movement", "Fly", "KeyBind") then
        if not new and char.alive and misc.rootpart then
            misc.rootpart.Anchored = false
        end
    end
end)

hook:Add("OnKeyBindChanged", "BBOT:Misc.Fly", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Misc", "Movement", "Fly", "KeyBind") then
        if not new and char.alive and misc.rootpart then
            misc.rootpart.Anchored = false
        end
    end
end)

hook:Add("SuppressNetworkSend", "BBOT:Misc.Tweaks", function(networkname, Entity, HitPos, Part, bulletID, ...)
    if networkname == "falldamage" and config:GetValue("Main", "Misc", "Tweaks", "Prevent Fall Damage") then
        return true
    end
end)

function misc:Fly(delta)
    if not config:GetValue("Main", "Misc", "Movement", "Fly") or not config:GetValue("Main", "Misc", "Movement", "Fly", "KeyBind") then return end
    local speed = config:GetValue("Main", "Misc", "Movement", "Fly Speed")
    local rootpart = self.rootpart -- Invis compatibility

    local travel = CACHED_VEC3
    local looking = camera.CFrame.lookVector --getting camera looking vector
    local rightVector = camera.CFrame.RightVector
    if userinputservice:IsKeyDown(Enum.KeyCode.W) then
        travel += looking
    end
    if userinputservice:IsKeyDown(Enum.KeyCode.S) then
        travel -= looking
    end
    if userinputservice:IsKeyDown(Enum.KeyCode.D) then
        travel += rightVector
    end
    if userinputservice:IsKeyDown(Enum.KeyCode.A) then
        travel -= rightVector
    end
    if userinputservice:IsKeyDown(Enum.KeyCode.Space) then
        travel += Vector3.new(0, 1, 0)
    end
    if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
        travel -= Vector3.new(0, 1, 0)
    end

    if config:GetValue("Main", "Misc", "Movement", "Circle Strafe") and config:GetValue("Main", "Misc", "Movement", "Circle Strafe", "KeyBind") then
        if misc.speedDirection.x ~= misc.speedDirection.x then 
            misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
        end
        local origin = travel.Y
        misc.circleStrafeAngle = -0.1
        if userinputservice:IsKeyDown(Enum.KeyCode.D) then
            misc.circleStrafeAngle = 0.1
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.A) then
            misc.circleStrafeAngle = -0.1
        end
        local cd = Vector2.new(misc.speedDirection.x, misc.speedDirection.z)
        local scale = delta * config:GetValue("Main", "Misc", "Movement", "Circle Strafe Scale")
        cd = vector.rotate(cd, misc.circleStrafeAngle * scale)
        misc.speedDirection = Vector3.new(cd.x, travel.Y, cd.y)
        travel = misc.speedDirection
    end

    if travel.Unit.x == travel.Unit.x then
        rootpart.Anchored = false
        rootpart.Velocity = travel.Unit * speed --multiplaye the unit by the speed to make
    else
        rootpart.Velocity = Vector3.new(0, 0, 0)
        rootpart.Anchored = true
    end
end

misc.speedDirection = Vector3.new(1,0,0)
function misc:Speed(delta)
    if config:GetValue("Main", "Misc", "Movement", "Fly") and config:GetValue("Main", "Misc", "Movement", "Fly", "KeyBind") then return end
    local speedtype = config:GetValue("Main", "Misc", "Movement", "Speed Type")
    local rootpart = self.rootpart
    if config:GetValue("Main", "Misc", "Movement", "Speed") then
        local speed = config:GetValue("Main", "Misc", "Movement", "Speed Factor")

        local travel = CACHED_VEC3
        local looking = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector
        local moving = false
        if not config:GetValue("Main", "Misc", "Movement", "Circle Strafe") or not config:GetValue("Main", "Misc", "Movement", "Circle Strafe", "KeyBind") then
            if userinputservice:IsKeyDown(Enum.KeyCode.W) then
                travel += looking
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.S) then
                travel -= looking
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.D) then
                travel += rightVector
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.A) then
                travel -= rightVector
            end
            misc.speedDirection = Vector3.new(travel.x, 0, travel.z).Unit
            -- if misc.speedDirection.x ~= misc.speedDirection.x then 
            -- 	misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
            -- end
            misc.circleStrafeAngle = -0.1
        else
            if misc.speedDirection.x ~= misc.speedDirection.x then 
                misc.speedDirection = Vector3.new(looking.x, 0, looking.y)
            end
            travel = misc.speedDirection
            misc.circleStrafeAngle = -0.1
            
            if userinputservice:IsKeyDown(Enum.KeyCode.D) then
                misc.circleStrafeAngle = 0.1
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.A) then
                misc.circleStrafeAngle = -0.1
            end
            local cd = Vector2.new(misc.speedDirection.x, misc.speedDirection.z)
            local scale = delta * config:GetValue("Main", "Misc", "Movement", "Circle Strafe Scale")
            cd = vector.rotate(cd, misc.circleStrafeAngle * scale)
            misc.speedDirection = Vector3.new(cd.x, 0, cd.y)
        end

        travel = misc.speedDirection
        if config:GetValue("Main", "Misc", "Movement", "Avoid Collisions") and config:GetValue("Main", "Misc", "Movement", "Avoid Collisions", "KeyBind") then
            if config:GetValue("Main", "Misc", "Movement", "Circle Strafe") and config:GetValue("Main", "Misc", "Movement", "Circle Strafe", "KeyBind") then
                local scale = config:GetValue("Main", "Misc", "Movement", "Avoid Collisions Scale") / 1000
                local position = char.rootpart.CFrame.p
                local part, position, normal = workspace:FindPartOnRayWithWhitelist(
                    Ray.new(position, (travel * speed * scale)),
                    roundsystem.raycastwhitelist
                ) 
                if part then
                    for i = -10, 10 do
                        local cd = Vector2.new(travel.x, travel.z)
                        cd = vector.rotate(cd, misc.circleStrafeAngle * i * -1)
                        cd = Vector3.new(cd.x, 0, cd.y)
                        local part, position, normal = workspace:FindPartOnRayWithWhitelist(
                            Ray.new(position, (cd * speed * scale)),
                            roundsystem.raycastwhitelist
                        ) 
                        misc.normal = normal
                        if not part then 
                            travel = cd
                        end
                    end
                end
            else
                local position = char.rootpart.CFrame.p
                for i = 1, 10 do
                    local part, position, normal = workspace:FindPartOnRayWithWhitelist(
                        Ray.new(position, (travel * speed / 10) + Vector3.new(0,rootpart.Velocity.y/10,0)),
                        roundsystem.raycastwhitelist
                    ) 
                    misc.normal = normal
                    if part then 
                        local dot = normal.Unit:Dot((char.rootpart.CFrame.p - position).Unit)
                        misc.normalPositive = dot
                        if dot > 0 then
                            travel += normal.Unit * dot
                            travel = travel.Unit
                            if travel.x == travel.x then
                                misc.circleStrafeDirection = travel
                            end
                        end
                    end
                end
            end
        end
        local humanoid = self.humanoid
        if travel.x == travel.x and humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
            if speedtype == "In Air" and (humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or not humanoid.Jump) then
                return
            elseif speedtype == "On Hop" and not userinputservice:IsKeyDown(Enum.KeyCode.Space) then
                return
            end
        
            if config:GetValue("Main", "Misc", "Movement", "Speed", "KeyBind") then
                rootpart.Velocity = Vector3.new(travel.x * speed, rootpart.Velocity.y, travel.z * speed)
            end
        end
    end
end

function misc:AutoJump()
    if config:GetValue("Main", "Misc", "Movement", "Auto Jump") and userinputservice:IsKeyDown(Enum.KeyCode.Space) then
        misc.humanoid.Jump = true
    end
end

local CHAT_GAME = localplayer.PlayerGui.ChatGame
local CHAT_BOX = CHAT_GAME:FindFirstChild("TextBox")

function misc:BypassSpeedCheck()
    local val = config:GetValue("Main", "Misc", "Exploits", "Bypass Speed Checks")
    local character = localplayer.Character
    if not character then return end
    local rootpart = character:FindFirstChild("HumanoidRootPart")
    if not rootpart then
        return
    end
    rootpart.Anchored = false
    self.oldroot = rootpart

    if val and char.alive and not self.newroot then
        copy = rootpart:Clone()
        copy.Parent = character
        self.newroot = copy
    elseif self.newroot then
        if ((not val) or (not gamelogic.currentgun) or (not char.alive) or (not gamemenu.isdeployed())) then
            self.newroot:Destroy()
            self.newroot = nil
        else
            -- client.char.rootpart.CFrame = self.newroot.CFrame
            --idk if i can manipulate this at all
        end
    end
end

do
    local oldjump = char.jump
    function char:jump(height)
        height = config:GetValue("Main", "Misc", "Tweaks", "Jump Power") and (height * config:GetValue("Main", "Misc", "Tweaks", "Jump Power Percentage") / 100) or height
        return oldjump(self, height)
    end

    hook:Add("Unload", "BBOT:Misc.JumpPower", function()
        char.jump = oldjump
    end)
end

misc.beams = {}
local debris = BBOT.service:GetService("Debris")
local tween = BBOT.service:GetService("TweenService")
function misc:CreateBeam(origin_att, ending_att, texture)
    local beam = Instance.new("Beam")
    beam.Texture = texture or "http://www.roblox.com/asset/?id=446111271"
    beam.TextureMode = Enum.TextureMode.Wrap
    beam.TextureSpeed = 8
    beam.LightEmission = 1
    beam.LightInfluence = 1
    beam.TextureLength = 12
    beam.FaceCamera = true
    beam.Enabled = true
    beam.ZOffset = -1
    beam.Transparency = NumberSequence.new(0,0)
    beam.Color = ColorSequence.new(config:GetValue("Main", "Visuals", "Misc", "Bullet Tracers", "Tracer Color"), Color3.new(0, 0, 0))
    beam.Attachment0 = origin_att
    beam.Attachment1 = ending_att
    debris:AddItem(beam, 3)
    debris:AddItem(origin_att, 3)
    debris:AddItem(ending_att, 3)

    local speedtween = TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
    tween:Create(beam, speedtween, { TextureSpeed = 2 }):Play()
    beam.Parent = workspace
    table.insert(misc.beams, { beam = beam, time = tick() })
    return beam
end

function misc:UpdateBeams()
    local time = tick()
    for i = #self.beams, 1, -1 do
        if self.beams[i].beam  then
            local transparency = (time - self.beams[i].time) - 2
            self.beams[i].beam.Transparency = NumberSequence.new(transparency, transparency)
        else
            table.remove(self.beams, i)
        end
    end
end

function misc:RollCases()
    local inventoryData = BBOT.aux.playerdata.getdata().settings.inventorydata
    local availableCases = {}
    local availableCaseKeys = {}

    for i = 1, #inventoryData do
        local data = inventoryData[i]
        local type = data.Type
        if type:match("^Case") then
            local dataName = data.Name
            local isKey = type:match("Key$") ~= nil
            local insertingInto = isKey and availableCaseKeys or availableCases
            if not insertingInto[dataName] then
                insertingInto[dataName] = {}
            end
            local array = insertingInto[dataName]
            array[#array + 1] = data
        end
    end

    local casesRolled = {}

    for caseName, cases in next, availableCases do
        local caseKeys = availableCaseKeys[caseName]
        local keyAmount = caseKeys and #caseKeys or 0
        if keyAmount > 0 then
            casesRolled[caseName] = keyAmount
        end
    end

    local casesRolledNum = 0
    for caseName, caseRollAmount in next, casesRolled do
        casesRolledNum += caseRollAmount
        for _ = 1, caseRollAmount do
            BBOT.aux.network:send("startrollrequest", caseName)
        end
    end

    if casesRolledNum > 0 then
        BBOT.notification:Create(string.format("Rolled %d case%s from inventory", casesRolledNum, casesRolledNum > 1 and "s" or ""), 10)
    else
        BBOT.notification:Create("No cases available", 5)
    end
end

function misc:SellSkins()
    local inventoryData = BBOT.aux.playerdata.getdata().settings.inventorydata
    
    local skinsSold = 0
    for i = 1, #inventoryData do 
        local data = inventoryData[i]
        if data.Type == "Skin" then
            BBOT.aux.network:send("sellskinrequest", data.Name, data.Wep)
            skinsSold += 1
        end
    end

    if skinsSold > 0 then
        BBOT.notification:Create(string.format("Sold %d skin%s", skinsSold, skinsSold > 1 and "s" or ""), 10)
    else
        BBOT.notification:Create("You don't seem to have skins on this account!", 5)
    end
end

local bullet_query = {}
hook:Add("PostNetworkSend", "BBOT:Misc.BulletTracer", function(networkname, ...)
    if networkname == "newbullets" then
        if not config:GetValue("Main", "Visuals", "Misc", "Bullet Tracers") then return end
        local args = {...}
        if not args[1] then return end
        local reg = args[1]
        local bullettable = reg.bullets
        for i=1, #bullettable do
            local v = bullettable[i]
            bullet_query[v[2]] = reg.firepos
        end
    elseif networkname == "bullethit" then
        local args = {...}
        local Entity, HitPos, Part, bulletID = args[1], args[2], args[3], args[4]
        if bullet_query[bulletID] then
            local attach_origin = Instance.new("Attachment", workspace.Terrain)
            attach_origin.Position = bullet_query[bulletID]
            local attach_ending = Instance.new("Attachment", workspace.Terrain)
            attach_ending.Position = HitPos
            local beam = misc:CreateBeam(attach_origin, attach_ending)
            beam.Parent = workspace
        end
    end
end)

hook:Add("RenderStepped", "BBOT:Misc.Calculate", function(delta)
    misc:UpdateBeams()
    misc:BypassSpeedCheck()
    if not char.alive then
        misc.humanoid = nil
        misc.rootpart = nil
        return
    end
    if not misc.humanoid then
        misc.humanoid = localplayer.Character:FindFirstChild("Humanoid")
        misc.rootpart = localplayer.Character:FindFirstChild("HumanoidRootPart")
    end
    misc.rootpart = (misc.newroot or misc.oldroot)
    char.rootpart = misc.rootpart
    if not CHAT_BOX.Active then
        misc:Fly(delta)
        misc:Speed(delta)
        misc:AutoJump(delta)
    end
end)

function misc:GrenadeTP(position)
    if gamelogic.gammo < 1 then return end
    local args = {
        "FRAG",
        {
            frames = {
                {
                    v0 = Vector3.new(),
                    glassbreaks = {},
                    t0 = 0,
                    offset = Vector3.new(),
                    rot0 = CFrame.new(),
                    a = Vector3.new(0 / 0),
                    p0 = char.rootpart.Position,
                    rotv = Vector3.new(),
                },
                {
                    v0 = Vector3.new(),
                    glassbreaks = {},
                    t0 = 0.002,
                    offset = Vector3.new(),
                    rot0 = CFrame.new(),
                    a = Vector3.new(0 / 0),
                    p0 = Vector3.new(0 / 0),
                    rotv = Vector3.new(),
                },
                {
                    v0 = Vector3.new(),
                    glassbreaks = {},
                    t0 = 0.003,
                    offset = Vector3.new(),
                    rot0 = CFrame.new(),
                    a = Vector3.new(),
                    p0 = position,
                    rotv = Vector3.new(),
                },
            },
            time = tick(),
            blowuptime = 0.003,
        },
    }
    gamelogic.gammo = gamelogic.gammo - 1
    hud:updateammo("GRENADE");
    network:send("newgrenade", unpack(args))
end

hook:Add("LocalKilled", "BBOT:RevengeGrenade", function(player)
    if player == localplayer then return end
    if not config:GetValue("Main", "Misc", "Exploits", "Revenge Grenade") then return end
    local controller = replication.getupdater(player)
    misc:GrenadeTP(controller.receivedPosition or controller.getpos())
end)

function misc:AutoGrenadeFrozen()
    if not char.alive then return end
    if gamelogic.gammo < 1 then return end
    local autonade = config:GetValue("Main", "Misc", "Extra", "Auto Nade Spam")
    if not autonade and not config:GetValue("Main", "Misc", "Exploits", "Auto Nade Frozen") then return end
    local t = config:GetValue("Main", "Misc", "Exploits", "Auto Nade Wait")
    for player, v in pairs(replication.player_registry) do
        if player ~= localplayer and player.Team and localplayer.Team and player.Team.Name ~= localplayer.Team.Name then
            local priority = config:GetPriority(player)
            if priority and priority < 0 then continue end
            local controller = v.updater
            if controller.alive and (autonade or (controller.__t_received and controller.__t_received + t < tick())) then
                misc:GrenadeTP(controller.receivedPosition or controller.getpos())
            end
        end
    end
end

hook:Add("Postupdatespawn", "BBOT:Misc.AutoGrandeFrozen", function()
    misc:AutoGrenadeFrozen()
end)

hook:Add("OnAliveChanged", "BBOT:Misc.AutoGrandeFrozen", function()
    misc:AutoGrenadeFrozen()
end)

timer:Create("BBOT:Misc.AutoGrenadeFrozen", 1, 0, function()
    misc:AutoGrenadeFrozen()
end)

hook:Add("AutoDeath", "BBOT:Misc.AutoGrenadeFrozen", function()
    misc:AutoGrenadeFrozen()
end)

hook:Add("Spawn", "BBOT:Misc.AutoGrenadeFrozen", function()
    misc:AutoGrenadeFrozen()
end)

do -- note: move this to aux?
    local killed_netindex

    local receivers = network.receivers
    for netindex, callback in pairs(receivers) do
        local const = debug.getconstants(callback)
        if table.quicksearch(const, "setfixedcam") and table.quicksearch(const, "setspectate") and table.quicksearch(const, "isplayeralive") and table.quicksearch(const, "Killer") then
            killed_netindex = netindex
        end
    end

    hook:Add("PostNetworkReceive", "BBOT:LocalKilled.Network", function(netname, ...)
        if netname == killed_netindex then
            hook:Call("LocalKilled", ...)
        end
    end)
end

--Disable Collisions
hook:Add("OnKeyBindChanged", "NoCollisionsChanged", function(steps, old, new)
    if not config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
    if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions") then return end
    if not char.alive then return end
    local v1057 = localplayer:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = (new == true and false or true)
        end
    end
    local v1057 = localplayer.Character:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = (new == true and false or true)
        end
    end
end)
hook:Add("OnConfigChanged", "NoCollisionsChanged", function(steps, old, new)
    if not config:IsPathwayEqual(steps, "Main", "Misc", "Exploits", "Disable Collisions") then return end
    if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
    if not char.alive then return end
    local v1057 = localplayer:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = (new == true and false or true)
        end
    end
    local v1057 = localplayer.Character:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = (new == true and false or true)
        end
    end
end)

hook:Add("PostLoadCharacter", "NoCollisions", function(char, pos)
    if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions") or not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
    local v1057 = localplayer:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = false
        end
    end
    local v1057 = localplayer.Character:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = false
        end
    end
end)

hook:Add("Stepped", "CollisionOverride", function()
    if not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions") or not config:GetValue("Main", "Misc", "Exploits", "Disable Collisions", "KeyBind") then return end
    if not char.alive then return end
    local v1057 = localplayer:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = false
        end
    end
    local v1057 = localplayer.Character:GetDescendants()
    for v1058 = 1, #v1057 do
        local object = v1057[v1058]
        if object:IsA("BasePart") then
            object.CanCollide = false
        end
    end
end)

return misc