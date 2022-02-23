local hook = BBOT.hook
local config = BBOT.config
local timer = BBOT.timer
local camera = BBOT.aux.camera
local char = BBOT.aux.char
local replication = BBOT.aux.replication
local gamelogic = BBOT.aux.gamelogic
local loop = BBOT.loop
local localplayer = BBOT.service:GetService("LocalPlayer")
local l3p = {}

function l3p:Init() -- Come on PF this is pathetic
    local localplayer_check = debug.getupvalue(replication._updater, 1)
    debug.setupvalue(replication._updater, 1, "_")
    self.controller = replication._updater(localplayer)
    self.player = localplayer
    debug.setupvalue(replication._updater, 1, localplayer_check)

    -- MAJOR NOTE: this is here because synapse 2.0 was being a dick with environments
    -- Synapse 3.0 has this fixed
    local lookangle_spring = debug.getupvalues(self.controller.getlookangles, 1)[1]
    local _update = lookangle_spring.update
    function lookangle_spring:update(...)
        _update(self, ...)
    end

    if config:GetValue("Main", "Visuals", "Local", "Enabled") then
        BBOT.esp:CreatePlayer(self.player, self.controller)
    end
end

hook:Add("PostInitialize", "BBOT:L3P.CreateUpdater", function()
    l3p:Init()
end)

function l3p:SetAlive(alive)
    if not self.controller then return end
    if not self.controller.alive and alive and self.enabled then
        if self.controller._weapon_slot then
            self.networking["equip"](l3p.controller, l3p.controller._weapon_slot)
        else
            self.networking["equip"](l3p.controller, -1)
        end
        local old_char
        if self.player == localplayer then
            old_char = self.player.Character
        end
        self.controller.spawn(char.rootpart.Position)
        self.controller.setsprint(char.sprinting())
        local mode = config:GetValue("Main", "Rage", "Anti Aim", "Fake Stance")
        if mode ~= "Off" then
            self.controller.setstance(string.lower(mode))
        else
            self.controller.setstance(char.movementmode)
        end
        if old_char then
            self.player.Character = old_char
        end
    elseif self.controller.alive then
        local objects = self.controller.died()
        if objects then
            objects:Destroy()
        end
    end
end

function l3p:GetCharacter()
    if self.controller and self.controller.alive then
        return self.controller.gethead().Parent
    end
end

function l3p:Enabled(on)
    l3p.enabled = on
    if char.alive and on then
        self:SetAlive(true)
    else
        self:SetAlive(false)
    end
end

hook:Add("Unload", "BBOT:L3P.Remove", function()
    if l3p.controller then l3p.controller.died() end
    l3p.controller = nil
    l3p.player = nil
end)

local vec0 = Vector3.new()
l3p.networking = {
    ["newbullets"] = function(controller)
        if not char.alive or not controller.alive then return end
        local gun = gamelogic.currentgun
        if not gun or not gun.data then return end
        local gundata = gun.data
        -- gundata.firevolume
        controller.kickweapon(gundata.hideflash, gundata.firesoundid, (gundata.firepitch and gundata.firepitch * (1 + 0.05 * math.random()) or nil), 0)
    end,
    ["stab"] = function(controller)
        if not char.alive or not controller.alive then return end
        controller.stab()
    end,
    ["equip"] = function(controller, slot)
        if not char.alive then return end
        controller._weapon_slot = slot
        local gun = gamelogic.currentgun.name
        local data = game:service("ReplicatedStorage").GunModules:FindFirstChild(gun)
        if not data then
            gun = "AK12"
            data = game:service("ReplicatedStorage").GunModules:FindFirstChild(gun)
        end
        local external = game:service("ReplicatedStorage").ExternalModels:FindFirstChild(gun)
        if not data or not external then return end
        local gundata, gunmodel = require(data), external:Clone()
        if gundata.type ~= "KNIFE" then
            controller.equip(gundata, gunmodel)
        else
            controller.equipknife(gundata, gunmodel)
        end
        controller.setaim(false)
    end,
    ["aim"] = function(controller, status)
        controller.setaim(status)
    end,
    ["sprint"] = function(controller, status)
        controller.setsprint(status)
    end,
    ["stance"] = function(controller, status)
        controller.setstance(status)
    end,
    ["repupdate"] = function(controller, pos, ang, timestep)
        if not char.alive or not controller.alive then return end
        local blank_vector = Vector3.new()
        local delta_position = blank_vector
        if not pos then
            pos = controller.receivedPosition
            if not pos then return end
        end
        if not ang then
            ang = controller.receivedLookAngles
            if not ang then return end
        end
        if controller.receivedPosition and controller.receivedFrameTime then
            delta_position = (pos - controller.receivedPosition) / (timestep - controller.receivedFrameTime);
        end;

        controller.receivedFrameTime = timestep;
        controller.receivedPosition = pos;
        controller.receivedVelocity = delta_position;
        controller.receivedDataFlag = true;
        controller.receivedLookAngles = ang;

        if config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Absolute") then
            delta_position = vec0
            controller.receivedVelocity = delta_position
            local u315 = debug.getupvalue(controller.getpos, 2)
            u315.t = pos
            u315.p = pos
            u315.v = vec0
            local u319 = debug.getupvalue(controller.step, 5)
            u319.t = pos
            u319.p = pos
            u319.v = pos
            local u320 = debug.getupvalue(controller.step, 6)
            u320._p0 = vec0
            u320._p1 = vec0
            u320._a0 = vec0
            u320._j0 = vec0
            u320._v0 = vec0
            u320._t0 = tick()
            controller.step(3, true)
        end

        if config:GetValue("Main", "Visuals", "Camera Visuals", "First Person Third") then
            local tick = debug.getupvalue(BBOT.aux.camera.step, 1)
            BBOT.aux.camera.step(tick)
        end
    end
}

hook:Add("RenderStepped", "BBOT:L3P.Render", function(delta)
    if not l3p.controller or not l3p.controller.alive then return end
    if config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Absolute") then
        local l__angles__1304 = BBOT.aux.camera.angles;
        l3p.networking["repupdate"](l3p.controller, char.rootpart.CFrame.p, nil, tick())
    end
    l3p.controller.step(3, true)
end)

hook:Add("SuppressNetworkSend", "BBOT:L3P.StopReplication", function(netname, ...)
    local args = {...} -- I was going to use this for something else...
    if netname == "state" and (args[1] == localplayer or args[1] == l3p.player) then return true end
end)

hook:Add("OnAliveChanged", "BBOT:L3P.UpdateDeath", function(alive)
    if alive then l3p:SetAlive(alive) end
end)

local connection = char.ondied:connect(function()
    l3p:SetAlive(false)
end);

hook:Add("Unload", "BBOT:L3P.RemoveOnDied", function()
    connection:disconnect()
end)

hook:Add("PostNetworkSend", "BBOT:L3P.UpdateStates", function(netname, ...)
    if not l3p.controller or not l3p.enabled then return end
    if not l3p.networking[netname] then return end
    l3p.networking[netname](l3p.controller, ...)
end)

hook:Add("OnKeyBindChanged", "BBOT:L3P.Enable", function(steps, old, new)
    if not config:IsPathwayEqual(steps, "Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind") then return end
    if config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person") then l3p:Enabled(new) end
end)

hook:Add("OnConfigChanged", "BBOT:L3P.Enable", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Visuals", "Local", "Enabled") then
        if not l3p.controller then return end
        if new then
            BBOT.esp:CreatePlayer(l3p.player, l3p.controller)
        else
            BBOT.esp:Remove("PLAYER_"..l3p.player.UserId)
        end
    elseif config:IsPathwayEqual(steps, "Main", "Visuals", "Camera Visuals", "Third Person", true) then
        if new then
            timer:Async(function()
                l3p:Enabled(new and config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind"))
            end)
        else
            l3p:Enabled(false)
        end
    end
end)

do
    local camera = BBOT.service:GetService("CurrentCamera")
    -- P.S this is broken, find a replacement to hide weapons on thirdperson
    --[[local function hideweapon()
        if not char.alive then return end
        if not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person") or not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind") then
            if gamelogic.currentgun.___ta then
                gamelogic.currentgun.___ta = nil
                gamelogic.currentgun:show()
            end
            return
        end
        if gamelogic.currentgun and gamelogic.currentgun.hide then
            gamelogic.currentgun:show()
            gamelogic.currentgun:hide(true)
            gamelogic.currentgun.___ta = true
        end
    end

    hook:Add("PreWeaponStep", "BBOT:Misc.Thirdperson", hideweapon)
    hook:Add("PreKnifeStep", "BBOT:Misc.Thirdperson", hideweapon)]]
    hook:Add("PreScreenCullStep", "BBOT:Misc.Thirdperson", function()
        if not char.alive or not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person") or not config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person", "KeyBind") then return end
        if BBOT.spectator and BBOT.spectator:IsSpectating() then return end
        if config:GetValue("Main", "Visuals", "Camera Visuals", "First Person Third") and BBOT.l3p_player and BBOT.l3p_player.controller then
            local head = BBOT.l3p_player.controller.gethead()
            if not head then return end
            local p, y, rr = camera.CFrame:ToOrientation()
            camera.CFrame = CFrame.new(head.CFrame.Position)
            local _, __, r = head.CFrame:ToOrientation()
            camera.CFrame *= CFrame.fromOrientation(p,y,r)
        end
        local val = camera.CFrame
        local dist = Vector3.new(
            config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person X Offset"),
            config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Y Offset"),
            config:GetValue("Main", "Visuals", "Camera Visuals", "Third Person Distance")
        )/10
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = { camera, workspace.Ignore, localplayer.Character, workspace.Players }
        local hit = workspace:Raycast(val.p, (val * CFrame.new(dist)).p-val.p, params)
        val *= CFrame.new(hit and dist*((hit.Position - val.p).Magnitude/dist.Magnitude) or dist)
        camera.CFrame = val
    end)
end

return l3p