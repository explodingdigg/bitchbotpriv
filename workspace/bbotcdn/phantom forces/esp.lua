local hook = BBOT.hook
local timer = BBOT.timer
local config = BBOT.config
local font = BBOT.font
local gui = BBOT.gui
local draw = BBOT.draw
local log = BBOT.log
local spectator = BBOT.spectator
local math = BBOT.math
local string = BBOT.string
local service = BBOT.service
local loop = BBOT.loop
local esp = {
    registry = {}
}

local localplayer = service:GetService("LocalPlayer")
local playergui = service:GetService("PlayerGui")
local camera = BBOT.service:GetService("CurrentCamera")

esp.container = Instance.new("Folder")
esp.container.Name = string.random(8, 14) -- you gonna try that GetChildren attack anytime soon?
esp.container.Parent = playergui.MainGui

-- Adds an ESP object to the rendering query
function esp:Add(construct)
    local reg = self.registry
    for i=1, #reg do
        if reg[i].uniqueid == construct.uniqueid then return false end
    end
    reg[#reg+1] = construct
    if construct.OnCreate then
        construct:OnCreate()
    end
end

-- Use this to find an esp object
function esp:Find(uniqueid)
    local reg = self.registry
    for i=1, #reg do
        if reg[i].uniqueid == uniqueid then
            return reg[i], i
        end
    end
end

-- Self-explanitory
function esp:Remove(uniqueid)
    local reg = self.registry
    local c = 0
    for i=1, #reg do
        if reg[i-c].uniqueid == uniqueid then
            local v = reg[i-c]
            table.remove(reg, i-c)
            c=c+1
            if v.OnRemove then
                v:OnRemove()
            end
            break
        end
    end
end

hook:Add("Unload", "BBOT:ESP.Destroy", function()
    local reg = esp.registry
    for i=1, #reg do
        local v = reg[i]
        if v.OnRemove then
            v:OnRemove()
        end
    end
    esp.registry = {}
    esp.container:Destroy()
end)

function esp.Render(v)
    if v.IsValid and v:IsValid() then
        if v:CanRender() then
            if v.PreRender then
                v:PreRender()
            end
            if v.Render then
                v:Render()
            end
            if v.PostRender then
                v:PostRender()
            end
        end
    else
        return true
    end
end

function esp:Rebuild()
    timer:Create("BBOT:ESP.Rebuild", 0.05, 1, function() self:_Rebuild() end)
end

function esp:_Rebuild()
    local controllers = self.registry
    for i=1, #controllers do
        local v = controllers[i]
        if v.Rebuild then
            v:Rebuild()
        end
    end
end

function esp.EmptyTable( tab )
    for k, v in pairs( tab ) do
        tab[ k ] = nil
    end
end

function esp.GetBoundingBox(parts)

end

local errors = 0
local runservice = BBOT.service:GetService("RunService")
loop:Run("BBOT:ESP.Render", function()
    if errors > 20 then return end
    local controllers = esp.registry
    local istablemissalined = false
    local c = 0
    for i=1, #controllers do
        local v = controllers[i-c]
        if v then
            local ran, destroy = xpcall(esp.Render, debug.traceback, v)
            if not ran then
                log(LOG_ERROR, "ESP render error - ", destroy)
                log(LOG_ANON, "Object - ", v.uniqueid)
                log(LOG_WARN,"Auto removing to prevent error cascade!")
                table.remove(controllers, i-c)
                c = c + 1
                errors = errors + 1
                if (BBOT.notification) then
                    BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in ESP library.\nPlease check Synapse console!", 30):SetType("error")
                end
            elseif destroy then
                table.remove(controllers, i-c)
                c = c + 1
                if v.OnRemove then
                    v:OnRemove()
                end
            end
        else
            istablemissalined = true
        end
    end

    if istablemissalined then
        local sorted = {}
        for k, v in pairs(controllers) do
            sorted[#sorted+1] = v
        end
        esp.EmptyTable(controllers)
        for i=1, #sorted do
            controllers[i] = sorted[i]
        end
    end
end, runservice.RenderStepped)

hook:Add("OnConfigChanged", "BBOT:ESP.Reload", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Visuals") then
        esp:Rebuild()
    end
end)

hook:Add("Spectator.Spectate", "BBOT:ESP.Reload", function()
    esp:Rebuild()
end)

font:Create("ESP.Global", font:GetDefault(), 16)

hook:Add("OnConfigChanged", "BBOT:ESP.Global.Font", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Visuals", "ESP Settings", "ESP Text Font") then
        font:ChangeFont("ESP.Global", new)
    elseif config:IsPathwayEqual(steps, "Main", "Visuals", "ESP Settings", "ESP Text Size") then
        font:ChangeSize("ESP.Global", new)
    end
end)

-- players
do
    local workspace = BBOT.service:GetService("Workspace")
    local players = BBOT.service:GetService("Players")
    local replication = BBOT.aux.replication
    local hud = BBOT.aux.hud
    local aimbot = BBOT.aimbot
    local color = BBOT.color
    local vector = BBOT.vector
    local camera_aux = BBOT.aux.camera
    local updater = replication.getupdater
    local player_registry = replication.player_registry

    esp.playercontainer = Instance.new("Folder", esp.container)
    esp.playercontainer.Name = "Players"

    do
        local player_meta = {}
        esp.player_meta = {__index = player_meta}

        function player_meta:IsValid()
            return self.player:IsDescendantOf(players)
        end

        function player_meta:OnRemove()
            self:Destroy(true, true)
            self.removed = true
            log(LOG_DEBUG, "Player ESP: Removing ", self.player.Name)
        end

        function player_meta:CanRender()
            local alive = hud:isplayeralive(self.player)

            if alive ~= self.alive then
                self.alive = alive
                if self.alive then
                    self:Setup()
                else
                    self:Destroy()
                end
            end
            
            self:KillRender()

            if self.alive then
                return true
            else
                return false
            end
        end

        function player_meta:Cache(object)
            for i=1, #self.draw_cache do
                if self.draw_cache[i][1] == object then
                    self.draw_cache[i][2] = object.Opacity
                    self.draw_cache[i][3] = object.OutlineOpacity
                    return object
                end
            end
            self.draw_cache[#self.draw_cache+1] = {object, object.Opacity, object.OutlineOpacity}
            return object
        end

        local whitelisted_parts = {
            ["head"] = true,
            ["torso"] = false,
            ["larm"] = false,
            ["rarm"] = false,
            ["lleg"] = true,
            ["rleg"] = true,
        }

        local visible_only_parts = {
            "head",
            --"torso",
            --"larm",
            --"rarm",
            "lleg",
            "rleg"
        }

        -- for outofview stuff
        local size = math.floor(camera.ViewportSize.x * 0.0078125)
        local big_size = math.floor(camera.ViewportSize.x * 0.0260416666667)

        hook:Add("Camera.ViewportChanged", "BBOT:ESP.Players.OutofView", function(newport)
            size = math.floor(newport.x * 0.0078125)
            big_size = math.floor(newport.x * 0.0240416666667)
        end)

        local dot = Vector3.new().Dot
        function player_meta:Render(points)
            if not self.parts and not points then return end

            local flags = self:GetConfig("Flags")
            local visible_only = flags["Visible Only"]

            local points = points
            if not points then
                points = {}
                self._points = points
                local offset, absolute = Vector3.new(), false
                if flags.Resolved then
                    if self.player == localplayer and self.controller.receivedPosition then
                        offset, absolute = self.controller.receivedPosition, true
                    else
                        offset, absolute = BBOT.aimbot:GetResolvedPosition(self.player)
                    end
                end
                self.offset = offset
                self.absolute = absolute

                local torso_cf = self.parts.torso.CFrame
                local points_i = #points -- i did not know that # was a metamethod for a long time and that code snippet below taught me that, thank you cream
                
                for i = 1, 7 do -- 7 for accuracy also i just wanna be able to find this code with ctrl f lmao
                    -- we need to get a circle of points around the player basically and then it will be nice and static
                    local angle = (i - 1) * (math.pi * 2 / 7) -- there really should be a tau constant somewhere mayb?
                    local offset_v3 = Vector3.new(math.cos(angle), 0, math.sin(angle)) * 2
                    
                    if absolute then
                        points[points_i + i] = (CFrame.new(Vector3.new(), torso_cf.LookVector) * offset_v3) + offset
                    else
                        points[points_i + i] = (torso_cf * offset_v3) + offset
                    end

                end
                points_i = #points
                
                if absolute then
                    points[points_i] = (offset + torso_cf.UpVector * 2.8) -- above head
                    points[points_i+1] = (offset - torso_cf.UpVector * 3.5) -- below legs and shit
                else
                    points[points_i] = (torso_cf.Position + torso_cf.UpVector * 2.8) + offset -- above head
                    points[points_i+1] = (torso_cf.Position - torso_cf.UpVector * 3.5) + offset -- below legs and shit
                end
            end

            -- L, W, H
            --[[local points2d = worldtoscreen(points)

            local fail = 0
            for i=1, #points2d do
                local v = points2d[i]
                if v.Z <= 0 then
                    fail = fail + 1
                end
            end]]

            local fail = 0
            local points2d = {}
            for i=1, #points do
                local point, onscreen = camera:WorldToViewportPoint(points[i])
                if not onscreen then
                    fail = fail + 1
                end
                points2d[#points2d+1] = point
            end

            if fail >= #points then
                fail = true
            else
                fail = false
            end

            if visible_only and self.alive then
                local visible = false
                for i=1, #visible_only_parts do
                    local part_name = visible_only_parts[i]
                    local part = self.parts[part_name]
                    if not part then continue end
                    if not BBOT.aimbot:raycastbullet(camera.CFrame.p, part.CFrame.p-camera.CFrame.p) then
                        visible = true
                        break
                    end
                end
                if self.visible ~= visible then
                    self.visible = visible
                    self.visible_time = tick()
                end

                local fraction = math.timefraction(self.visible_time, self.visible_time+.1, tick())
                if not self.visible then
                    fraction = math.remap(fraction, 0, 1, 1, 0)
                end

                for i=1, #self.draw_cache do
                    local v = self.draw_cache[i]
                    if v[1].Visible then
                        v[1].Opacity = v[2]*fraction
                        v[1].OutlineOpacity = v[3]*fraction
                    end
                end

                if fraction <= 0 then
                    return
                end
            end

            local bounding_box = {x=0,y=0,w=0,h=0}
            if not fail then
                local left = points2d[1].X
                local top = points2d[1].Y
                local right = points2d[1].X
                local bottom = points2d[1].Y
                
                for i=1,#points2d do
                    if(points2d[i]) then
                        if (left > points2d[i].X) then
                            left = points2d[i].X
                        end
                        if (bottom < points2d[i].Y) then
                            bottom = points2d[i].Y
                        end
                        if (right < points2d[i].X) then
                            right = points2d[i].X
                        end
                        if (top > points2d[i].Y) then
                            top = points2d[i].Y
                        end
                    end
                end

                bounding_box.x = math.floor(left)
                bounding_box.y = math.floor(top)
                bounding_box.w = math.floor(right - left)
                bounding_box.h = math.floor(bottom - top)
            end

            local vectest, vectest2 = Vector2.new(bounding_box.x, bounding_box.y), Vector2.new(bounding_box.w, bounding_box.h)
            if vectest ~= vectest or vectest2 ~= vectest2 then
                return
            end

            local lefty, righty = 0, 0

            if self.box and self.box_enabled then
                if fail then
                    self.box_fill.Visible = false
                    self.box_outline.Visible = false
                    self.box.Visible = false
                else
                    self.box_fill.Visible = true
                    self.box_outline.Visible = true
                    self.box.Visible = true

                    local pos, size = Vector2.new(bounding_box.x, bounding_box.y), Vector2.new(bounding_box.w, bounding_box.h)

                    self.box_fill.Offset = pos
                    self.box_fill.Size = size
                    self.box_outline.Offset = pos
                    self.box_outline.Size = size
                    self.box.Offset = pos
                    self.box.Size = size
                end
            end

            if self.name and self.name_enabled then
                if fail then
                    self.name.Visible = false
                else
                    self.name.Visible = true
                    self.name.Offset = Vector2.new(bounding_box.x + (bounding_box.w/2) - (self.name.TextBounds.X/2), bounding_box.y - self.name.TextBounds.Y)
                end
            end

            local health = math.ceil(hud:getplayerhealth(self.player))
            self.health_lerp = math.lerp(BBOT.renderstepped_rate * 5, self.health_lerp, health)
            if self.healthbar and self.healthbar_enabled then
                if fail then
                    self.healthbar.Visible = false
                    self.healthbar_outline.Visible = false
                else
                    self.healthbar.Visible = true
                    self.healthbar_outline.Visible = true
                    self.healthbar.Color = color.range(self.health_lerp, {
                        [1] = {
                            start = 0,
                            color = self:GetConfig("Health Bar", "Color Low"),
                        },
                        [2] = {
                            start = 100,
                            color = self:GetConfig("Health Bar", "Color Max"),
                        },
                    })
                    self.healthbar.Offset = Vector2.new(bounding_box.x - 6, bounding_box.y + (bounding_box.h * math.clamp(1-(self.health_lerp/100), 0, 1))+1)
                    self.healthbar.Size = Vector2.new(2, bounding_box.h * math.clamp(self.health_lerp/100, 0, 1)-2)
                    self.healthbar_outline.Offset = Vector2.new(bounding_box.x - 6 - 1, bounding_box.y)
                    self.healthbar_outline.Size = Vector2.new(2+2, bounding_box.h)
                end
            end

            if self.healthtext and self.healthtext_enabled then
                if fail then
                    self.healthtext.Visible = false
                else
                    if math.round(self.health_lerp) >= 100 then
                        self.healthtext.Visible = false
                    else
                        self.healthtext.Visible = true
                        local offsety = (self.healthbar_enabled and (bounding_box.h * math.remap(math.clamp(self.health_lerp/100, 0, 1),0,1,1,0)) or lefty)
                        self.healthtext.Text = (self.healthbar_enabled and tostring(math.round(self.health_lerp)) or tostring(math.round(self.health_lerp)) .. "hp")
                        self.healthtext.Offset = Vector2.new(bounding_box.x - self.healthtext.TextBounds.X - (self.healthbar_enabled and 8 or 1), bounding_box.y + offsety - (self.healthbar_enabled and self.healthtext.TextBounds.Y/2 or 0))
                        lefty = lefty + self.healthtext.TextBounds.Y + 2
                    end
                end
            end

            if self.distance and self.distance_enabled then
                if fail then
                    self.distance.Visible = false
                else
                    self.distance.Visible = true
                    local pos = self.controller.receivedPosition or self.controller.gethead().Position
                    self.distance.Text = math.round((pos-camera.CFrame.p).Magnitude/5) .. "m"
                    self.distance.Offset = Vector2.new(bounding_box.x + bounding_box.w + 2, bounding_box.y + righty)
                    righty = righty + self.distance.TextBounds.Y + 2
                end
            end

            if self.frozen and self.frozen_enabled then
                local on = self.controller.__t_received and self.controller.__t_received + (BBOT.extras:getLatency()*2)+.25 < tick()
                if fail or not on then
                    self.frozen.Visible = false
                else
                    self.frozen.Visible = true
                    self.frozen.Offset = Vector2.new(bounding_box.x + bounding_box.w + 2, bounding_box.y + righty)
                    righty = righty + self.frozen.TextBounds.Y + 2
                end
            end

            if self.resolved and self.resolved_enabled then
                if fail or not self.offset then
                    self.resolved.Visible = false
                    self.resolved_background.Visible = false
                else
                    local pos
                    if self.absolute then
                        pos = camera:WorldToViewportPoint(self.offset)
                    elseif self.controller.getpos() then
                        pos = camera:WorldToViewportPoint(self.controller.getpos() + self.offset)
                    end
                    if pos then
                        self.resolved.Visible = true
                        self.resolved_background.Visible = true
                        
                        local x, y = pos.X, pos.Y
                        if x >= math.huge or x <= -math.huge or y >= math.huge or y <= -math.huge then
                            x = 0
                            y = 0
                        end

                        if Vector2.new(x, y) ~= Vector2.new(x, y) then
                            x = 0
                            y = 0
                        end

                        self.resolved.Offset = Vector2.new(x, y)
                        self.resolved_background.Offset = Vector2.new(x, y)
                    else
                        self.resolved.Visible = false
                        self.resolved_background.Visible = false
                    end
                end
            end

            if self.outofview and self.outofview_enabled then
                local soundsteps = self:GetConfig("Sound Arrows")
                local arrow_dist = self:GetConfig("Arrow Distance")
                if fail and self.controller.receivedPosition and arrow_dist then
                    self.outofview.Visible = true
                    self.outofview_outline.Visible = true
                    local position = self.controller.receivedPosition
                    if soundsteps then
                        if self.footstep_time and self.weaponstep_time then
                            if self.footstep_time > self.weaponstep_time then
                                position = self.footstep_position
                            else
                                position = self.weaponstep_position
                            end
                        elseif self.footstep_time then
                            position = self.footstep_position
                        elseif self.weaponstep_time then
                            position = self.weaponstep_position
                        end
                    end
                    if position then
                        local relativePos = camera.CFrame:PointToObjectSpace(position)
                        local angle = math.atan2(-relativePos.Y, relativePos.X)

                        local distance = dot(relativePos.Unit, relativePos)
                        local arrow_size = self:GetConfig("Dynamic Arrow Size") and math.remap(distance, 1, 100, big_size, size) or size
                        arrow_size = arrow_size > big_size and big_size or arrow_size < size and size or arrow_size

                        local direction = Vector2.new(math.cos(angle), math.sin(angle))
                        local SCREEN_SIZE = camera.ViewportSize
                        local pos
                        if arrow_dist ~= 101 then
                            pos = (direction * SCREEN_SIZE.X * arrow_dist / 200) + (SCREEN_SIZE * 0.5)
                        end
                        if not pos or pos.Y > SCREEN_SIZE.Y - 5 or pos.Y < 5 then
                            pos = camera:AngleToEdge(angle, 5)
                        end

                        self.outofview.Offset1 = pos
                        self.outofview.Offset2 = pos - vector.rotate(direction, 0.5) * arrow_size
                        self.outofview.Offset3 = pos - vector.rotate(direction, -0.5) * arrow_size

                        self.outofview_outline.Offset1 = pos + direction * 2
                        self.outofview_outline.Offset2 = pos - vector.rotate(direction, 0.52) * (arrow_size+2)
                        self.outofview_outline.Offset3 = pos - vector.rotate(direction, -0.52) * (arrow_size+2)

                        if soundsteps then
                            local mul_opacity = 0
                            if self.footstep_time then
                                mul_opacity = (1-math.clamp(math.timefraction(self.footstep_time, self.footstep_time+.25, tick()), 0, 1))
                                mul_opacity = mul_opacity * (1-math.clamp(self.footstep_distance/(128/1.25), 0, 1))
                            end

                            if self.weaponstep_time then
                                local _mul_opacity = 0
                                _mul_opacity = (1-math.clamp(math.timefraction(self.weaponstep_time, self.weaponstep_time+.3, tick()), 0, 1))
                                _mul_opacity = _mul_opacity * (1-math.clamp(self.weaponstep_distance/(512/1.75), 0, 1)) * self.weaponstep_volume
                                mul_opacity = mul_opacity + _mul_opacity
                            end

                            mul_opacity = math.clamp(mul_opacity, 0, 1)

                            local color, color_transparency = self:GetConfig("Out of View", "Arrow Color")
                            color_transparency = color_transparency or 0
                            self.outofview.Opacity = color_transparency * mul_opacity
                            self.outofview.OutlineOpacity = color_transparency * mul_opacity
                            self:Cache(self.outofview)
    
                            color, color_transparency = self:GetConfig("Out of View", "Outline Color")
                            color_transparency = color_transparency or 0
                            self.outofview_outline.Opacity = color_transparency * mul_opacity
                            self.outofview_outline.OutlineOpacity = color_transparency * mul_opacity
                            self:Cache(self.outofview_outline)
                        end
                    end
                else
                    self.outofview.Visible = false
                    self.outofview_outline.Visible = false
                end
            end

            if self.sounddot and self.sounddot_enabled then
                if self.controller.receivedPosition and (self.footstep_time or self.weaponstep_time) then
                    self.sounddot.Visible = true
                    local mul_opacity = 0
                    if self.footstep_time then
                        mul_opacity = (1-math.clamp(math.timefraction(self.footstep_time, self.footstep_time+.25, tick()), 0, 1))
                        mul_opacity = mul_opacity * (1-math.clamp(self.footstep_distance/(128/1.25), 0, 1))
                    end

                    if self.weaponstep_time then
                        local _mul_opacity = 0
                        _mul_opacity = (1-math.clamp(math.timefraction(self.weaponstep_time, self.weaponstep_time+.3, tick()), 0, 1))
                        _mul_opacity = _mul_opacity * (1-math.clamp(self.weaponstep_distance/(512/1.75), 0, 1)) * self.weaponstep_volume
                        mul_opacity = mul_opacity + _mul_opacity
                    end

                    mul_opacity = math.clamp(mul_opacity, 0, 1)

                    local position = self.controller.receivedPosition
                    if self.footstep_time and self.weaponstep_time then
                        if self.footstep_time > self.weaponstep_time then
                            position = self.footstep_position
                        else
                            position = self.weaponstep_position
                        end
                    elseif self.footstep_time then
                        position = self.footstep_position
                    elseif self.weaponstep_time then
                        position = self.weaponstep_position
                    end

                    if position then
                        local dist = (position - camera.CFrame.p).Magnitude
                        self.sounddot.Radius = math.clamp(math.remap(dist, 256, 0, 4, 10), 3, 12)
                        self.sounddot.Point = position
                    end

                    local color, color_transparency = self:GetConfig("Sound Dots", "Dot Color")
                    color_transparency = color_transparency or 0
                    self.sounddot.Opacity = color_transparency * mul_opacity
                    local color, color_transparency = self:GetConfig("Sound Dots", "Outline Color")
                    color_transparency = color_transparency or 0
                    self.sounddot.OutlineOpacity = color_transparency * mul_opacity
                    self:Cache(self.sounddot)
                else
                    self.sounddot.Visible = false
                end
            end
        end

        hook:Add("SuppressSound", "BBOT:ESP.Players.soundsteps", function(name, soundgroup, volume, pitch, pitchmin, pitchmax, part, max_distance, emitter_size, rolloffmode, playonremove, loop)
            if not part then return end
            local iswalk, isrun = string.find(name, "walk"), string.find(name, "run")
            if not iswalk and not isrun then return end
            for i, player in next, players:GetPlayers() do
                if player == localplayer then continue end
                local parts = replication.getbodyparts(player)
                if not parts then continue end
                local found = false
                for k, v in next, parts do
                    if v == part then
                        found = true
                        break
                    end
                end
                if found then
                    local object = esp:Find("PLAYER_" .. player.UserId)
                    if object and object.alive and object.parts and object.parts.torso and (object.parts.torso.CFrame.p - camera.CFrame.p).Magnitude < 128 then
                        object.footstep_time = tick()
                        object.footstep_volume = volume
                        object.footstep_distance = (object.parts.torso.CFrame.p - camera.CFrame.p).Magnitude
                        object.footstep_position = object.parts.torso.CFrame.p
                    end
                    break
                end
            end
        end)

        hook:Add("PreNewBullets", "BBOT:ESP.Players.WeaponSounds", function(data)
            if not data.player or spectator:IsSpectating() == data.player then return end
            local updater = replication.getupdater(data.player)
            if not updater or not updater.alive then return end
            local object = esp:Find("PLAYER_" .. data.player.UserId)
            if object and object.alive and object.parts and object.parts.torso then
                object.weaponstep_time = tick()
                object.weaponstep_volume = data.volume
                object.weaponstep_distance = (object.parts.torso.CFrame.p - camera.CFrame.p).Magnitude
                object.weaponstep_position = object.parts.torso.CFrame.p
            end
        end)

        function player_meta:GetConfig(...)
            local lp = localplayer
            local spectating = spectator:IsSpectating()
            if spectating then
                lp = spectating
            end
            if self.player == localplayer then
                return config:GetValue("Main", "Visuals", "Local", ...)
            elseif self.player and self.player.Team ~= lp.team then
                return config:GetValue("Main", "Visuals", "Enemy ESP", ...)
            else
                return config:GetValue("Main", "Visuals", "Team ESP", ...)
            end
        end

        -- draw:TextOutlined(text, font, x, y, size, centered, color, color2, transparency, visible)
        -- draw:BoxOutline(x, y, w, h, thickness, color, transparency, visible)
        local black = Color3.new(0,0,0)
        function player_meta:OnCreate()
            local color, color_transparency = self:GetConfig("Name", "Color")
            local name = draw:Create("Text", "2V")
            name.Color = color
            name.Text = self.player.name
            name.Outlined = true
            name.OutlineColor = Color3.fromRGB(0,0,0)
            name.OutlineThickness = 2
            name.Opacity = color_transparency
            name.OutlineOpacity = color_transparency
            name.XAlignment = XAlignment.Right
            name.YAlignment = YAlignment.Bottom
            font:AddToManager(name, "ESP.Global")
            self.name = self:Cache(name)

            color, color_transparency = self:GetConfig("Box", "Color Fill")

            local box_fill = draw:Create("Rect", "2V")
            box_fill.Color = color
            box_fill.Filled = true
            box_fill.Opacity = color_transparency
            box_fill.XAlignment = XAlignment.Right
            box_fill.YAlignment = YAlignment.Bottom
            self.box_fill = self:Cache(box_fill)

            color, color_transparency = self:GetConfig("Box", "Color Outline")
            local box_outline = draw:Clone(box_fill)
            box_outline.Color = color
            box_outline.Filled = false
            box_outline.Opacity = color_transparency
            box_outline.Thickness = 3
            self.box_outline = self:Cache(box_outline)

            color, color_transparency = self:GetConfig("Box", "Color Box")
            local box = draw:Clone(box_outline)
            box.Color = color
            box.Opacity = color_transparency
            box.Thickness = 1
            self.box = self:Cache(box)
            
            color, color_transparency = self:GetConfig("Health Bar", "Color Max")

            local healthbar_outline = draw:Clone(box_fill)
            healthbar_outline.Color = Color3.new(0,0,0)
            healthbar_outline.Opacity = color_transparency
            self.healthbar_outline = self:Cache(healthbar_outline)

            local healthbar = draw:Clone(healthbar_outline)
            healthbar.Color = color
            healthbar.Opacity = color_transparency
            self.healthbar = self:Cache(healthbar)
            
            color, color_transparency = self:GetConfig("Health Number", "Color")
            local healthtext = draw:Clone(name)
            healthtext.Color = color
            healthtext.Opacity = color_transparency
            healthtext.Text = "100"
            healthtext.OutlineOpacity = color_transparency
            font:AddToManager(healthtext, "ESP.Global")
            self.healthtext = self:Cache(healthtext)

            local distance = draw:Clone(name)
            distance.Color = color
            distance.Opacity = color_transparency
            distance.Text = "0 studs"
            distance.OutlineOpacity = color_transparency
            font:AddToManager(distance, "ESP.Global")
            self.distance = self:Cache(distance)

            local frozen = draw:Clone(name)
            frozen.Color = color
            frozen.Opacity = color_transparency
            frozen.Text = "FROZEN"
            frozen.OutlineOpacity = color_transparency
            font:AddToManager(frozen, "ESP.Global")
            self.frozen = self:Cache(frozen)

            local resolved_background = draw:Create("Circle", "2V")
            resolved_background.Radius = 4
            resolved_background.NumSides = 10
            resolved_background.Filled = true
            resolved_background.Color = Color3.new(0,0,0)
            self.resolved_background = self:Cache(resolved_background)

            local resolved = draw:Clone(resolved_background)
            resolved.Radius = 3
            self.resolved = self:Cache(resolved)

            color, color_transparency = self:GetConfig("Out of View", "Outline Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            local outofview_outline = draw:Create("PolyLine", "2V", "2V", "2V")
            outofview_outline.Color = color
            outofview_outline.Opacity = color_transparency
            outofview_outline.OutlineOpacity = color_transparency
            outofview_outline.FillType = PolyLineFillType.ConvexFilled
            self.outofview_outline = self:Cache(outofview_outline)

            color, color_transparency = self:GetConfig("Out of View", "Arrow Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            local outofview = draw:Create("PolyLine", "2V", "2V", "2V")
            outofview.Color = color
            outofview.Opacity = color_transparency
            outofview.OutlineOpacity = color_transparency
            outofview.FillType = PolyLineFillType.ConvexFilled
            self.outofview = self:Cache(outofview)

            local sounddot = draw:Create("Circle", "3D")
            sounddot.Radius = 4
            sounddot.NumSides = 10
            sounddot.Filled = true
            sounddot.Color = Color3.new(0,0,0)
            sounddot.Outlined = true
            sounddot.OutlineThickness = 1
            self.sounddot = self:Cache(sounddot)
        end

        function player_meta:GetColor(...)
            local color, color_transparency = self:GetConfig(...)
            local priority = config:GetPriority(self.player)
            if config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Target") and aimbot.rage_target and aimbot.rage_target[1] == self.player then
                color = config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Target", "Aimbot Target")
            elseif config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Friends") and priority and priority < 0 then
                color = config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Friends", "Friended Players")
            elseif config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Priority") and priority and priority > 0 then
                color = config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Priority", "Priority Players")
            end
            return color, color_transparency
        end

        function player_meta:Setup()
            self.begin_fading = false
            local parts = replication.getbodyparts(self.player)
            if not parts then return end

            local flags = self:GetConfig("Flags")
            self.model = parts.head.Parent
            self.parts = parts
            local esp_enabled = self:GetConfig("Enabled")
            local priority_level = config:GetPriority(self.player)
            if flags["Friends Only"] and flags["Priority Only"] then
                if priority_level == 0 then
                    esp_enabled = false
                end
            elseif (flags["Friends Only"] and priority_level >= 0) then
                esp_enabled = false
            elseif (flags["Priority Only"] and priority_level <= 0) then
                esp_enabled = false
            end
            local spectating = spectator:IsSpectating()
            if spectating == self.player then
                esp_enabled = false
            elseif spectating and hud:isplayeralive(self.player) then
                esp_enabled = true
            end
            
            local color, color_transparency = self:GetColor("Name", "Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.name_enabled = (esp_enabled and self:GetConfig("Name") or false)
            self.name.Visible = self.name_enabled
            self.name.Color = color
            self.name.Opacity = color_transparency
            self.name.OutlineOpacity = color_transparency
            self:Cache(self.name)

            self.box_enabled = (esp_enabled and self:GetConfig("Box") or false)
            self.box_fill.Visible = self.box_enabled
            self.box_outline.Visible = self.box_enabled
            self.box.Visible = self.box_enabled

            color, color_transparency = self:GetColor("Box", "Color Fill")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.box_fill.Color = color
            self.box_fill.Opacity = color_transparency

            color, color_transparency = self:GetConfig("Box", "Color Outline")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.box_outline.Color = color
            self.box_outline.Opacity = color_transparency

            color, color_transparency = self:GetColor("Box", "Color Box")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.box.Color = color
            self.box.Opacity = color_transparency
            self.box_outline.Opacity = color_transparency
            self:Cache(self.box)
            self:Cache(self.box_outline)
            self:Cache(self.box_fill)
            
            color, color_transparency = self:GetConfig("Health Bar", "Color Max")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.healthbar_enabled = (esp_enabled and self:GetConfig("Health Bar") or false)
            self.healthbar.Color = color
            self.healthbar.Opacity = color_transparency
            self.healthbar_outline.Opacity = color_transparency
            self.healthbar.Visible = self.healthbar_enabled
            self.healthbar_outline.Visible = self.healthbar_enabled
            self.health_lerp = 100
            self:Cache(self.healthbar)
            self:Cache(self.healthbar_outline)
            
            color, color_transparency = self:GetConfig("Health Number", "Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.healthtext_enabled = (esp_enabled and self:GetConfig("Health Number") or false)
            self.healthtext.Visible = self.healthtext_enabled
            self.healthtext.Color = color
            self.healthtext.Opacity = color_transparency
            self.healthtext.OutlineOpacity = color_transparency
            self:Cache(self.healthtext)

            self.distance_enabled = (esp_enabled and flags.Distance or false)
            self.distance.Visible = self.distance_enabled
            self.distance.Color = color
            self.distance.Opacity = color_transparency
            self.distance.OutlineOpacity = color_transparency
            self:Cache(self.distance)

            self.frozen_enabled = (esp_enabled and flags.Frozen or false)
            self.frozen.Visible = self.frozen_enabled
            self.frozen.Color = color
            self.frozen.Opacity = color_transparency
            self.frozen.OutlineOpacity = color_transparency
            self:Cache(self.frozen)

            color, color_transparency = self:GetColor("Box", "Color Box")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.resolved_enabled = (esp_enabled and flags.Resolved or false)
            self.resolved.Visible = self.resolved_enabled
            self.resolved_background.Visible = self.resolved_enabled
            self.resolved.Color = color
            self.resolved.Opacity = color_transparency
            self.resolved.OutlineOpacity = color_transparency
            self:Cache(self.resolved)

            color, color_transparency = self:GetConfig("Out of View", "Arrow Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.outofview_enabled = self:GetConfig("Out of View")
            self.outofview.Visible = false
            self.outofview.Color = color
            self.outofview.Opacity = color_transparency
            self.outofview.OutlineOpacity = color_transparency
            self:Cache(self.outofview)

            color, color_transparency = self:GetConfig("Out of View", "Outline Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.outofview_outline.Visible = false
            self.outofview_outline.Color = color
            self.outofview_outline.Opacity = color_transparency
            self.outofview_outline.OutlineOpacity = color_transparency
            self:Cache(self.outofview_outline)

            self.sounddot_enabled = self:GetConfig("Sound Dots")
            color, color_transparency = self:GetConfig("Sound Dots", "Dot Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.sounddot.Visible = false
            self.sounddot.Color = color
            self.sounddot.Opacity = color_transparency
            color, color_transparency = self:GetConfig("Sound Dots", "Outline Color")
            color = color or Color3.new(1,1,1)
            color_transparency = color_transparency or 0
            self.sounddot.OutlineColor = color
            self.sounddot.OutlineOpacity = color_transparency
            self:Cache(self.sounddot)

            if flags["Visible Only"] then
                for i=1, #self.draw_cache do
                    local v = self.draw_cache[i]
                    if v[1].Visible then
                        v[1].Opacity = v[2]
                        v[1].OutlineOpacity = v[3]
                    end
                end
            end

            if spectator:IsSpectating() == self.player then
                for i=1, #self.draw_cache do
                    local v = self.draw_cache[i]
                    if v[1].Visible then
                        v[1].Visible = false
                    end
                end
            end

            self:RemoveInstances()

            local container = Instance.new("Folder", esp.playercontainer)
            self.container = container
            container.Name = self.player.Name

            if self:GetConfig("Chams") then
                local visible, transparency = self:GetConfig("Chams", "Visible Chams")
                local invisible, itransparency = self:GetConfig("Chams", "Invisible Chams")
                local scale = 0.1
                local chams = {}
                self.chams = chams
                for k, v in pairs(parts) do
                    if k ~= "rootpart" then
                        local boxhandle
                        if v.Name ~= "Head" then
                            boxhandle = Instance.new("BoxHandleAdornment", Part)
                            chams[#chams+1] = {k, boxhandle, itransparency}
                            boxhandle.Size = (v.Size + Vector3.new(0.1, 0.1, 0.1))
                        else
                            boxhandle = Instance.new("CylinderHandleAdornment", Part)
                            chams[#chams+1] = {k, boxhandle, itransparency}
                            boxhandle.Height = v.Size.y + 0.3
                            boxhandle.Radius = v.Size.x * 0.5 + 0.2
                            boxhandle.Height -= 0.2
                            boxhandle.Radius -= 0.2
                            boxhandle.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 1, 0))
                        end
                        boxhandle.Parent = container
                        boxhandle.Name = "Chams_"..k
                        boxhandle.Adornee = v
                        boxhandle.AlwaysOnTop = true
                        boxhandle.Color3 = invisible
                        boxhandle.Transparency = 1-itransparency
                        boxhandle.Visible = true
                        boxhandle.ZIndex = 1
                    end
                end
                scale = 0.25
                for k, v in pairs(parts) do
                    if k ~= "rootpart" then
                        local boxhandle
                        if v.Name ~= "Head" then
                            boxhandle = Instance.new("BoxHandleAdornment", Part)
                            chams[#chams+1] = {k, boxhandle, transparency}
                            boxhandle.Size = (v.Size + Vector3.new(0.25, 0.25, 0.25))
                        else
                            boxhandle = Instance.new("CylinderHandleAdornment", Part)
                            chams[#chams+1] = {k, boxhandle, transparency}
                            boxhandle.Height = v.Size.y + 0.3
                            boxhandle.Radius = v.Size.x * 0.5 + 0.2
                            boxhandle.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 1, 0))
                        end
                        boxhandle.Parent = container
                        boxhandle.Name = "UChams_"..k
                        boxhandle.Adornee = v
                        boxhandle.AlwaysOnTop = false
                        boxhandle.Color3 = visible
                        boxhandle.Transparency = 1-transparency
                        boxhandle.Visible = true
                        boxhandle.ZIndex = 1
                    end
                end
            end

            log(LOG_DEBUG, "Player ESP: Now Alive ", self.player.Name)
        end

        function player_meta:Rebuild()
            self:Destroy(true)
            if self.alive then
                self:Setup()
            end
        end

        function player_meta:RemoveInstances()
            if self.chams then
                for i=1, #self.chams do
                    local v = self.chams[i]
                    if v[2] then
                        v[2]:Destroy()
                    end
                end
                self.chams = nil
            end
            
            if self.container then
                self.container:Destroy()
                self.container = nil
            end
        end

        function player_meta:KillRender()
            if self.alive or not self.timedestroyed or not self.begin_fading then return end
            local fadetime = config:GetValue("Main", "Visuals", "ESP Settings", "ESP Fade Time")
            local fraction = math.timefraction(self.timedestroyed, self.timedestroyed+fadetime, tick())

            if fraction > 1 then
                for i=1, #self.draw_cache do
                    local v = self.draw_cache[i]
                    if v[1].Visible then
                        v[1].Visible = false
                    end
                end

                self:RemoveInstances()
            else
                self:Render(self._points)

                fraction = math.remap(fraction, 0, 1, 1, 0)
                for i=1, #self.draw_cache do
                    local v = self.draw_cache[i]
                    if v[1].Visible and v[1].Opacity > 0 then
                        v[1].Opacity = v[2]*fraction
                        v[1].OutlineOpacity = v[3]*fraction
                    end
                end

                if self.chams then
                    for i=1, #self.chams do
                        local v = self.chams[i]
                        if v[2] then
                            v[2].Transparency = 1-(v[3]*fraction)
                        end
                    end
                end
            end
        end

        function player_meta:Destroy(forced, kill)
            self.timesdestroyed = self.timesdestroyed + 1
            self.timedestroyed = tick()
            self.fulldestroy = (forced or kill)
            self.begin_fading = not (forced or kill)

            for i=1, #self.draw_cache do
                local v = self.draw_cache[i][1]
                if draw:IsValid(v) then
                    if kill then
                        v:Remove()
                    elseif forced then
                        v.Visible = false
                    end
                end
            end

            if forced or kill then
                self:RemoveInstances()
            end

            self.parts = nil
            log(LOG_DEBUG, "Player ESP: Died ", self.player.Name)
        end
    end

    local localplayer = service:GetService("LocalPlayer")
    function esp:CreatePlayer(player, controller)
        local uid = "PLAYER_" .. player.UserId
        local esp_controller = setmetatable({
            draw_cache = {},
            position_cache = {},
            uniqueid = uid,
            player = player,
            players = players,
            controller = controller,
            parent = workspace.Players,
            timesdestroyed = 0,
        }, self.player_meta)
        self:Remove(uid)
        self:Add(esp_controller)

        log(LOG_DEBUG, "Player ESP: Created ", player.Name)
        return esp_controller
    end

    local last = ""
    hook:Add("RageBot.Changed", "BBOT:ESP.Players.Targeted", function(target)
        if not config:GetValue("Main", "Visuals", "ESP Settings", "Highlight Target") then return end
        local oldobject = esp:Find("PLAYER_" .. last)
        if oldobject then
            oldobject:Rebuild()
        end
        if target then
            local object = esp:Find("PLAYER_" .. target.UserId)
            last = target.UserId
            if object then
                object:Rebuild()
            end
        end
    end)

    hook:Add("OnPriorityChanged", "BBOT:ESP.Players.Changed", function(player, old_priority, priority)
        local object = esp:Find("PLAYER_" .. player.UserId)
        if object then
            object:Rebuild()
        end
    end)

    hook:Add("PostInitialize", "BBOT:ESP.Players.Load", function()
        timer:Create("esp.checkplayers", 5, 0, function()
            for player, controller in pairs(player_registry) do
                if controller.updater and player ~= localplayer and not esp:Find("PLAYER_" .. player.UserId) then
                    esp:CreatePlayer(player, controller.updater)
                end
            end
        end)

        hook:Add("PlayerAdded", "BBOT:ESP.Players", function(player)
            timer:Create("BBOT:ESP.Players."..player.UserId, 1, 0, function()
                if not player_registry[player] or not player_registry[player].updater then return end
                timer:Remove("BBOT:ESP.Players."..player.UserId)
                esp:CreatePlayer(player, player_registry[player].updater)
            end)
        end)

        hook:Add("PlayerRemoving", "BBOT:ESP.Players", function(player)
            timer:Remove("BBOT:ESP.Players."..player.UserId)
        end)

        hook:Add("CreateUpdater", "BBOT:ESP.Players", function(player)
            if player_registry[player] and player_registry[player].updater then
                timer:Remove("BBOT:ESP.Players."..player.UserId)
                esp:CreatePlayer(player, player_registry[player].updater)
            end
        end)
    end)
end

-- weapon drop ESP
do
    local icons = BBOT.icons
    local gamelogic = BBOT.aux.gamelogic
    local GunDataGetter = BBOT.aux.GunDataGetter
    do
        local drop_meta = {}
        esp.weapon_drop_meta = {__index = drop_meta}

        function drop_meta:IsValid()
            return self.object:IsDescendantOf(workspace.Ignore)
        end

        function drop_meta:CanRender()
            return true
        end

        function drop_meta:OnRemove()
            self:Destroy()
        end

        function drop_meta:Rebuild()
            self:Setup()
        end

        function drop_meta:Cache(object)
            for i=1, #self.draw_cache do
                if self.draw_cache[i][1] == object then
                    self.draw_cache[i][2] = object.Opacity
                    self.draw_cache[i][3] = object.OutlineOpacity
                    return object
                end
            end
            self.draw_cache[#self.draw_cache+1] = {object, object.Opacity, object.OutlineOpacity}
            return object
        end

        local function getguninformation(name)	
            local filename = GunDataGetter.getGunModule(name)
            if not filename then
                return
            end
            return require(filename)
        end

        local vec2_0 = Vector2.new(0, 0)
        function drop_meta:Render()
            local object_position = self.object.Slot1.Position
            self.object_point.Point = object_position -- I love meta tables & inheritances
            local visible = self.object_point.Visible
            if gamelogic.currentgun ~= self.last_current then
                self.last_current = gamelogic.currentgun

                if self.ammo then
                    local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo", "Weapon Ammo")
                    if self.last_current and self.last_current.data then
                        local gundata = self.last_current.data
                        local dropdata = getguninformation(self.object_name)
                        if dropdata and (gundata.ammotype == dropdata.ammotype or gundata.type == dropdata.type) then
                            color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo", "Same Weapon Ammo")
                        end
                    end

                    self.ammo.Color = color
                    self.ammo.Opacity = color_transparency
                    self.ammo.OutlineOpacity = color_transparency
                    self.ammo = self:Cache(self.ammo)
                end
            end

            if self.name then
                -- not really much to do here lmao
            end

            if self.ammo then
                self.ammo.Text = tostring(self.object.Spare.Value)
            end

            if self.image then
                if self.name and self.name.Visible then
                    self.image.Offset = Vector2.new(0, -self.name.TextBounds.Y)
                else
                    self.image.Offset = vec2_0
                end
            end

            local fraction = math.clamp(math.remap((object_position-camera.CFrame.p).Magnitude, 30, 75, 1, 0), 0, 1)
            for i=1, #self.draw_cache do
                local v = self.draw_cache[i]
                if v[1].Visible then
                    v[1].Opacity = v[2]*fraction
                    v[1].OutlineOpacity = v[3]*fraction
                end
            end
        end

        function drop_meta:OnCreate()
            --[[config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Highlighted Weapons")
            config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Weapon Names")
            config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons")
            config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo")
            config:GetValue("Main", "Visuals", "Weapons", "Dropped Weapon Chams")]]

            self.object_name = "Unknown"
            if self.object:FindFirstChild("Gun") then
                self.object_name = self.object.Gun.Value
            elseif self.object:FindFirstChild("Knife") then
                self.object_name = self.object.Knife.Value
            end

            self.object_point = draw:CreatePoint("3D")

            local name = draw:Create("Text", "Offset")
            name.Text = self.object_name
            name.Outlined = true
            name.OutlineColor = Color3.fromRGB(0,0,0)
            name.OutlineThickness = 2
            name.XAlignment = XAlignment.Center
            name.YAlignment = YAlignment.Top
            font:AddToManager(name, "ESP.Global")

            if self.object:FindFirstChild("Spare") then
                local ammo = draw:Clone(name)
                ammo.Text = tostring(self.object.Spare.Value)
                ammo.YAlignment = YAlignment.Bottom
                font:AddToManager(ammo, "ESP.Global")
                ammo.point.Point = self.object_point.point
                self.ammo = self:Cache(ammo)
            end

            name.point.Point = self.object_point.point
            self.name = self:Cache(name)

            local imagedata = icons:NameToIcon(self.object_name)
            if imagedata then
                local image = draw:Create("Image", "Offset")
                image.Image = imagedata[1]
                image.Size = image.ImageSize * 1
                image.XAlignment = XAlignment.Center
                image.YAlignment = YAlignment.Top
                image.point.Point = self.object_point.point
                self.image = self:Cache(image)
            end
            self:Setup()
            self:Render()
        end

        function drop_meta:Setup()
            self.name.Visible = config:GetValue("Main", "Visuals", "Weapons", "Weapon Names")
            local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Weapon Names")
            self.name.Color = color
            self.name.Opacity = color_transparency
            self.name.OutlineOpacity = color_transparency
            self.name = self:Cache(self.name)
            
            if self.ammo then
                self.ammo.Visible = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo")
                local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo", "Weapon Ammo")
                self.ammo.Color = color
                self.ammo.Opacity = color_transparency
                self.ammo.OutlineOpacity = color_transparency
                self.ammo = self:Cache(self.ammo)
            end

            if self.image then
                self.image.Visible = config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons")
                local color, color_transparency = config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons", "Weapon Icons")
                self.image.Color = color
                self.image.Opacity = color_transparency
                self.image.OutlineOpacity = color_transparency
                self.image = self:Cache(self.image)
            end
        end

        function drop_meta:Destroy()
            for i=1, #self.draw_cache do
                local v = self.draw_cache[i][1]
                if draw:IsValid(v) then
                    v:Remove()
                end
            end
        end
    end

    function esp:CreateWeaponDrop(object)
        local uid = "WEAPONDROP_" .. object:GetDebugId()
        local esp_controller = setmetatable({
            draw_cache = {},
            uniqueid = uid,
            object = object,
        }, self.weapon_drop_meta)
        self:Remove(uid)
        self:Add(esp_controller)
        return esp_controller
    end

    hook:Add("PostInitialize", "BBOT:ESP.WeaponDrops", function()
        local dropguns = workspace.Ignore.GunDrop
        local children = dropguns:GetChildren()
        for i=1, #children do
            local drop = children[i]
            if drop:FindFirstChild("Slot1") and (drop:FindFirstChild("Gun") or drop:FindFirstChild("Knife")) then
                esp:CreateWeaponDrop(drop)
            end
        end

        hook:Add("RenderStepped", "BBOT:ESP.WeaponDrops.Find", function()
            local children = dropguns:GetChildren()
            for i=1, #children do
                local drop = children[i]
                if not esp:Find("WEAPONDROP_" .. drop:GetDebugId()) and drop:FindFirstChild("Slot1") and (drop:FindFirstChild("Gun") or drop:FindFirstChild("Knife")) then
                    esp:CreateWeaponDrop(drop)
                end
            end
        end)
    end)
end

do
    local icons = BBOT.icons
    local color = BBOT.color
    local roundsystem = BBOT.aux.roundsystem
    local char = BBOT.aux.char
    local localplayer = service:GetService("LocalPlayer")
    do
        local grenade_meta = {}
        esp.grenade_meta = {__index = grenade_meta}

        --[[{
            curi = 1, 
            time = initiatetime, 
            blowuptime = delaytime - initiatetime, 
            frames = { {
                    t0 = 0, 
                    p0 = u195, 
                    v0 = u193, 
                    offset = Vector3.new(), 
                    a = gravity, 
                    rot0 = grenade_mainpart_cframe - grenade_mainpart_cframe.p,
                    timedelta = 0,
                    hit = false,
                    hitnormal = Vector3.new(0,1,0),
                    rotv = u197, 
                    glassbreaks = {}
                } }
        };]]

        function grenade_meta:IsValid()
            return self.object:IsDescendantOf(workspace.Ignore.Misc)
        end

        function grenade_meta:CanRender()
            return true
        end

        function grenade_meta:OnRemove()
            self:Destroy()
        end

        function grenade_meta:Rebuild()
            self:Setup()
        end

        function grenade_meta:Cache(object)
            for i=1, #self.draw_cache do
                if self.draw_cache[i][1] == object then
                    self.draw_cache[i][2] = object.Opacity
                    self.draw_cache[i][3] = object.OutlineOpacity
                    return object
                end
            end
            self.draw_cache[#self.draw_cache+1] = {object, object.Opacity, object.OutlineOpacity}
            return object
        end

        local col1 = Color3.fromRGB(20, 20, 20)
        local col2 = Color3.fromRGB(150, 20, 20)
        local col3 = Color3.fromRGB(50, 50, 50)
        local col4 = Color3.fromRGB(220, 20, 20)
        local camera = BBOT.service:GetService("CurrentCamera")
        local vec2_0 = Vector2.new(0, 0)
        function grenade_meta:Render()
            if not self.final_position or not config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning") then return end
            local position = self.final_position.p0
            local cam_position = camera.CFrame.p
            local point, onscreen = camera:WorldToViewportPoint(position)
            local screensize = camera.ViewportSize
            if not onscreen or point.x > screensize.x - 36 or point.y > screensize.y - 72 or point.y - 16 < 0 then
                local relativePos = camera.CFrame:PointToObjectSpace(position)
                local angle = math.atan2(-relativePos.y, relativePos.x)
                local ox = math.cos(angle)
                local oy = math.sin(angle)
                local slope = oy / ox

                local h_edge = screensize.x - 36
                local v_edge = screensize.y - 72
                if oy < 0 then
                    v_edge = 36
                end
                if ox < 0 then
                    h_edge = 36
                end
                local y = (slope * h_edge) + (screensize.y / 2) - slope * (screensize.x / 2)
                if y > 0 and y < screensize.y - 72 then
                    point = Vector2.new(h_edge, y)
                else
                    point = Vector2.new(
                        (v_edge - screensize.y / 2 + slope * (screensize.x / 2)) / slope,
                        v_edge
                    )
                end
            end
            local nade_dist = (position - cam_position).Magnitude

            local textbounds = self.warning.TextBounds
            self.background.Offset = Vector2.new(math.floor(point.x), math.floor(point.y))
            self.icon.Offset = Vector2.new(math.floor(point.x), math.floor(point.y))
            self.warning.Offset = Vector2.new(math.floor(point.x), math.floor(point.y + 18))

            local d0 = 250 -- max damage
            local d1 = 15 -- min damage
            local r0 = 8 -- maximum range before the damage starts dropping off due to distance
            local r1 = 30 -- minimum range i think idk
            local damage = nade_dist < r0 and d0 or nade_dist < r1 and (d1 - d0) / (r1 - r0) * (nade_dist - r0) + d0 or 0
            local wall
            if damage > 0 then
                wall = workspace:FindPartOnRayWithWhitelist(
                    Ray.new(cam_position, (position - cam_position)),
                    roundsystem.raycastwhitelist
                )
                if wall then
                    damage = 0
                end
            end

            local health = char:gethealth()
            local str = damage == 0 and "Safe" or damage >= health and "LETHAL" or string.format("-%d hp", damage)
            local nade_percent = math.clamp(math.timefraction(self.physics.time, self.physics.time + self.physics.blowuptime, tick()), 0, 1)
            self.warning.Text = str

            self.background.Color = color.range(damage, {
                [1] = { start = 15, color = col1 },
                [2] = { start = health, color = col2 },
            })

            self.background.OutlineColor = color.range(damage, {
                [1] = { start = 15, color = col3 },
                [2] = { start = health, color = col4 },
            })

            self.progress_container.Offset = Vector2.new(math.floor(point.x) - 16, math.floor(point.y + 18 + textbounds.Y + 2))
            self.progress_bar.Size = Vector2.new(30 * (1 - nade_percent), 4)
            self.progress_bar.Offset = Vector2.new(math.floor(point.x) - 15, math.floor(point.y + 18 + textbounds.Y + 3))

            local fraction = math.clamp(math.remap(nade_dist, 50, 70, 1, 0), 0, 1)
            for i=1, #self.draw_cache do
                local v = self.draw_cache[i]
                if v[1].Visible then
                    v[1].Opacity = v[2]*fraction
                    v[1].OutlineOpacity = v[3]*fraction
                end
            end

            if nade_percent == 1 then
                esp:Remove(self.uniqueid)
            end
        end

        function grenade_meta:OnCreate()
            if self.player ~= localplayer and self.player.Team == localplayer.Team then return end
            --[[config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Highlighted Weapons")
            config:GetValue("Main", "Visuals", "Weapons", "Weapon Names", "Weapon Names")
            config:GetValue("Main", "Visuals", "Weapons", "Weapon Icons")
            config:GetValue("Main", "Visuals", "Weapons", "Weapon Ammo")
            config:GetValue("Main", "Visuals", "Weapons", "Dropped Weapon Chams")]]

            self.final_position = self.physics.frames[#self.physics.frames]

            local background = draw:Create("Circle", "2V")
            background.Color = Color3.fromRGB(20, 20, 20)
            background.Radius = 15
            background.Filled = true
            background.NumSides = 20
            background.Outlined = true
            background.OutlineColor = Color3.fromRGB(50, 50, 50)
            background.OutlineThickness = 2
            background.XAlignment = XAlignment.Center
            background.YAlignment = YAlignment.Center
            self.background = self:Cache(background)

            local imagedata = icons:NameToIcon("FRAG")
            local icon = draw:Create("Image", "2V")
            icon.Color = Color3.new(1,1,1)
            icon.Image = imagedata[1]
            icon.Size = icon.ImageSize * 1.25
            icon.XAlignment = XAlignment.Center
            icon.YAlignment = YAlignment.Center
            self.icon = self:Cache(icon)

            local warning = draw:Create("Text", "2V")
            warning.Text = ""
            warning.Color = Color3.new(1,1,1)
            warning.Outlined = true
            warning.OutlineColor = Color3.fromRGB(0,0,0)
            warning.OutlineThickness = 2
            warning.XAlignment = XAlignment.Center
            warning.YAlignment = YAlignment.Bottom
            font:AddToManager(warning, "ESP.Global")
            self.warning = self:Cache(warning)

            local progress_container = draw:Create("Rect", "2V")
            progress_container.Size = Vector2.new(32, 6)
            progress_container.Color = Color3.fromRGB(30, 30, 30)
            progress_container.Filled = true
            progress_container.Outlined = true
            progress_container.OutlineColor = Color3.fromRGB(50, 50, 50)
            progress_container.OutlineThickness = 1
            progress_container.XAlignment = XAlignment.Right
            progress_container.YAlignment = YAlignment.Bottom
            self.progress_container = self:Cache(progress_container)

            local progress_bar = draw:Create("Gradient", "2V")
            progress_bar.OpacityUpperLeft = 1
            progress_bar.OpacityUpperRight = 1
            progress_bar.OpacityBottomLeft = 1
            progress_bar.OpacityBottomRight = 1
            progress_bar.XAlignment = XAlignment.Right
            progress_bar.YAlignment = YAlignment.Bottom
            self.progress_bar = self:Cache(progress_bar)

            self:Setup()
            self:Render()
        end

        function grenade_meta:Setup()
            if not self.final_position then return end
            local enabled = config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning")
            for i=1, #self.draw_cache do
                local v = self.draw_cache[i][1]
                v.Visible = enabled
            end

            local newcolor, transparency = config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning", "Warning Color")
            local colordark = color.darkness(newcolor, .7)
            local progress_bar = self.progress_bar
            progress_bar.ColorUpperLeft = newcolor
            progress_bar.ColorUpperRight = newcolor
            progress_bar.ColorBottomLeft = colordark
            progress_bar.ColorBottomRight = colordark
        end

        function grenade_meta:Destroy()
            for i=1, #self.draw_cache do
                local v = self.draw_cache[i][1]
                if draw:IsValid(v) then
                    v:Remove()
                end
            end
        end
    end

    function esp:CreateGrenade(object, player, name, physics)
        local uid = "GRENADE_" .. object.Name .. "_" .. object:GetDebugId()
        local esp_controller = setmetatable({
            draw_cache = {},
            uniqueid = uid,
            object = object,
            name = name,
            physics = physics,
            player = player
        }, self.grenade_meta)
        self:Remove(uid)
        self:Add(esp_controller)
        return esp_controller
    end

    hook:Add("GrenadeCreated", "BBOT:ESP.Grenade", function(object, player, name, physics)
        esp:CreateGrenade(object, player, name, physics)
    end)
end

return esp