local hook = BBOT.hook
local config = BBOT.config
local math = BBOT.math
local replication = BBOT.aux.replication
local menu = BBOT.menu
local aux_camera = BBOT.aux.camera
local vector = BBOT.aux.vector
local particle = BBOT.aux.particle
local runservice = BBOT.service:GetService("RunService")
local players = BBOT.service:GetService("Players")
local camera = BBOT.service:GetService("CurrentCamera")
local drawpather = BBOT.drawpather
local spectator = {}

spectator.spectating = false

function spectator:Spectate(player)
    self.spectating = player
    if player then
        menu:UpdateStatus("Spectator", player.Name, true)
        hook:Call("Spectator.Spectate", player)
        local updater = replication.getupdater(player)
        if not updater or not updater.alive then return end
        if updater.receivedPosition and updater.receivedLookAngles then
            self.repupdate_position = updater.receivedPosition
            self.repupdate_angles = updater.receivedLookAngles
            self.lookangle = updater.receivedLookAngles
            self.position = updater.receivedPosition
        end
    else
        menu:UpdateStatus("Spectator", nil, false)
        hook:Call("Spectator.Spectate", nil)
    end
end

function spectator:IsSpectating()
    return self.spectating
end

local offset_velocity = Vector3.new(0,-10000,0)
hook:Add("PostupdateReplication", "BBOT:Spectator.Offset", function(player, controller)
    if player ~= spectator:IsSpectating() then return end
    spectator.repupdate_position = controller.receivedPosition
    spectator.repupdate_angles = controller.receivedLookAngles
    controller.receivedPosition = Vector3.new(0,-10000,0)
end)

hook:Add("PreupdateStep", "BBOT:Spectator.RenderAll", function(player, controller, renderscale, shouldrender)
    if spectator:IsSpectating() or spectator.freecam_enabled then
        return 3, true
    end
end)

hook:Add("Postupdatespawn", "BBOT:Spectator.Reset", function(player, controller)
    if spectator:IsSpectating() ~= player then return end
    if controller.receivedPosition and controller.receivedLookAngles then
        spectator.lookangle = controller.receivedLookAngles
        spectator.position = controller.receivedPosition
    end
end)

do
    local getweaponpos_detour, particle_detour, particle_readonly
    hook:Add("PreNewBullets", "BBOT:Spectator.BulletOverride", function(data)
        if not data.player or spectator:IsSpectating() ~= data.player then return end
        local updater = replication.getupdater(data.player)
        if not updater or not updater.alive then return end
        getweaponpos_detour = updater.getweaponpos
        function updater.getweaponpos()
            return data.firepos
        end
        local duration = config:GetValue("Main", "Visuals", "Extra", "Spectator Bullet Duration")
        local hit_color, hit_opacity = config:GetValue("Main", "Visuals", "Extra", "Spectator Bullets", "Hit Color")
        local bullet_color, bullet_opacity = config:GetValue("Main", "Visuals", "Extra", "Spectator Bullets", "Trace Color")
        local player = data.player
        local team = (player.Team and player.Team.Name or "NA")
        local playerteamdata = workspace["Players"][(team == "Ghosts" and "Bright orange" or "Bright blue")]

        particle_readonly = isreadonly(particle)
        if particle_readonly then
            setreadonly(particle, false)
        end
        particle_detour = rawget(particle, "new")
        local function particle_new(bullet, ...)
            if config:GetValue("Main", "Visuals", "Extra", "Spectator Bullets") then
                local pather = drawpather:Create()
                pather:SetColor(bullet_color, bullet_opacity)
                pather:SetSize(1)
                pather:SetEndSize(3)
                pather:ShowEnd(true)
                pather:SetDuration(duration)
                local dir = bullet.velocity.Unit * 50000
                local firepos = bullet.position
                local raydata = BBOT.aimbot:raycastbullet(firepos, dir, playerteamdata)
                local final = raydata and raydata.Position or dir
                pather:Update({firepos, final})

                bullet.physicsignore = {workspace.Terrain, workspace.Ignore, camera}
                bullet.onplayerhit = function(self, pl, part, hitpos)
                    pather:SetColor(hit_color, hit_opacity)
                    pather:Update({firepos, hitpos})
                end
            end
            particle_detour(bullet, ...)
        end
        rawset(particle, "new", particle_new)
        if particle_readonly then
            setreadonly(particle, true)
        end
    end)

    hook:Add("PostNewBullets", "BBOT:Spectator.BulletOverride", function(data)
        if particle_detour then
            if particle_readonly then
                setreadonly(particle, false)
            end
            rawset(particle, "new", particle_detour)
            particle_detour = nil
            if particle_readonly then
                setreadonly(particle, true)
            end
        end
        local updater = replication.getupdater(data.player)
        if getweaponpos_detour and updater then
            updater.getweaponpos = getweaponpos_detour
            getweaponpos_detour = nil
        end
    end)
end

hook:Add("PlayerRemoving", "BBOT:Spectator.Remove", function(player)
    if spectator.spectating == player then
        spectator.spectating = nil
        menu:UpdateStatus("Spectator", nil, false)
        hook:Call("Spectator.Spectate", nil)
    end
end)

local vector_blank = Vector3.new()
local stand, crouch, prone = Vector3.new(0,1.5,0), Vector3.new(0,0,0), Vector3.new(0,-1,0)

spectator.lookangle = Vector2.new()
spectator.position = Vector3.new()
spectator.freecam_angles = Vector3.new()
spectator.freecam_position = Vector3.new()
spectator.freecam_cframe = CFrame.new()
spectator.freecam_enabled = false
spectator.camera_final = CFrame.new()

local l__CFrame_Angles__14 = CFrame.Angles;
hook:Add("Mouse.OnMove", "BBOT:Spectator.FreeCam", function(mouse_delta)
    if config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam") and config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam", "KeyBind") then
        local sensitivity = aux_camera.sensitivity * aux_camera.sensitivitymult * math.atan(math.tan(aux_camera.basefov * (math.pi / 180) / 2) / 2.718281828459045 ^ aux_camera.magspring.p) / (32 * math.pi);
        local pitch_cos = math.cos(spectator.freecam_angles.x);
        local delta = Vector3.new(-sensitivity * mouse_delta.y * aux_camera.xinvert, -(sensitivity * (1 - (1 - pitch_cos) ^ (aux_camera.sensitivity * aux_camera.sensitivitymult * math.atan(math.tan(aux_camera.basefov * (math.pi / 180) / 2)) / (32 * math.pi) / sensitivity)) / pitch_cos) * mouse_delta.x, 0);
        
        local pitch = math.clamp(spectator.freecam_angles.x + delta.x, aux_camera.minangle, aux_camera.maxangle);
        local yaw = spectator.freecam_angles.y + delta.y
        spectator.freecam_angles = Vector3.new(pitch, yaw)
    end
end)

local userinputservice = BBOT.service:GetService("UserInputService")
local localplayer = BBOT.service:GetService("LocalPlayer")
function spectator.step()
    local self = spectator
    if config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam") and config:GetValue("Main", "Visuals", "Camera Visuals", "FreeCam", "KeyBind") then
        if not self.freecam_enabled then
            self.freecam_angles = Vector3.new(self.camera_final:ToEulerAnglesXYZ())
            self.freecam_position = self.camera_final.p
        end
        self.freecam_enabled = true
        userinputservice.MouseBehavior = Enum.MouseBehavior.LockCenter
        local look_cframe = CFrame.Angles(0, self.freecam_angles.Y, 0) * CFrame.Angles(self.freecam_angles.X, 0, 0)

        local LookVector = look_cframe.LookVector
        local RightVector = look_cframe.RightVector
        if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
            LookVector = LookVector * 2
            RightVector = RightVector * 2
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.W) then
            self.freecam_position += LookVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.S) then
            self.freecam_position -= LookVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.D) then
            self.freecam_position += RightVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.A) then
            self.freecam_position -= RightVector
        end

        local new_cframe = look_cframe + self.freecam_position
        spectator.freecam_cframe = new_cframe
        aux_camera.basecframe = new_cframe
        aux_camera.cframe = new_cframe
        camera.CFrame = new_cframe
    else
        self.freecam_enabled = false
        if not self.spectating then return end
        local target = self.spectating
        local updater = replication.getupdater(target)
        if not updater or not updater.alive then return end

        local stance = updater.__stance or "stand"
        local offset = vector_blank
        if stance == "stand" then
            offset = stand
        elseif stance == "crouch" then
            offset = crouch
        else
            offset = prone
        end
        if self.repupdate_position and self.repupdate_angles then
            local renderstep_tick = BBOT.renderstepped_rate
            self.position = math.lerp(renderstep_tick*25, self.position, self.repupdate_position+offset)
            camera.CFrame = CFrame.new(self.position)
            self.lookangle = math.lerp(renderstep_tick*25, self.lookangle, self.repupdate_angles)
            camera.CFrame *= CFrame.fromOrientation(self.lookangle.X,self.lookangle.Y,0)
        end
        aux_camera.basecframe = camera.CFrame
        aux_camera.cframe = camera.CFrame
    end
end

hook:Add("PreScreenCullStep", "BBOT:Spectator.Spectate", spectator.step)

hook:Add("PostScreenCullStep", "BBOT:Spectator.Spectate", function()
    spectator.camera_final = aux_camera.cframe
end)

return spectator