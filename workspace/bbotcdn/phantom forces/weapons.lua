local weapons = {}
local hook = BBOT.hook
local math = BBOT.math
local table = BBOT.table
local timer = BBOT.timer
local config = BBOT.config
local char = BBOT.aux.char
local gamelogic = BBOT.aux.gamelogic
local network = BBOT.aux.network

weapons.WeaponDB = require(game:GetService("ReplicatedStorage").AttachmentModules.GunDatabase)

function weapons.GetToggledSight(weapon)
    local updateaimstatus = debug.getupvalue(weapon.toggleattachment, 3)
    return debug.getupvalue(updateaimstatus, 1)
end

-- Welcome to my hell.
-- ft. debug.setupvalue
local upvaluemods = {} -- testing? no problem reloading the script...
hook:Add("Unload", "BBOT:WeaponModifications", function()
    for i=1, #upvaluemods do
        local v = upvaluemods[i]
        debug.setupvalue(unpack(v))
    end
end)

local function DetourKnifeLoader(related_func, index, knifeloader)
    local newfunc = function(...)
        hook:CallP("PreLoadKnife", ...)
        local knifedata = knifeloader(...)
        hook:CallP("PostLoadKnife", knifedata, ...)
        return knifedata
    end
    upvaluemods[#upvaluemods+1] = {related_func, index, knifeloader}
    debug.setupvalue(related_func, index, newcclosure(newfunc))
end

local function DetourGunLoader(related_func, index, gunloader)
    local newfunc = function(...)
        hook:CallP("PreLoadGun", ...)
        local gundata = gunloader(...)
        hook:CallP("PostLoadGun", gundata, ...)
        return gundata
    end
    upvaluemods[#upvaluemods+1] = {related_func, index, gunloader}
    debug.setupvalue(related_func, index, newcclosure(newfunc))
end

local done = false -- Causes synapse to crash LOL
local function DetourWeaponRequire(related_func, index, getweapoondata)
    --[[if done then return end
    done = true
    local newfunc = function(...)
        local modifications = getweapoondata(...)
        modifications = BBOT.CopyTable(modifications)
        hook:Call("GetWeaponData", modifications)
        return modifications
    end
    upvaluemods[#upvaluemods+1] = {related_func, index, getweapoondata}
    debug.setupvalue(related_func, index, newfunc)]]
end

local function DetourModifyData(related_func, index, modifydata)
    local newfunc = function(...)
        local modifications = modifydata(...)
        hook:CallP("WeaponModifyData", modifications)
        return modifications
    end
    upvaluemods[#upvaluemods+1] = {related_func, index, modifydata}
    debug.setupvalue(related_func, index, newcclosure(newfunc))
end

local done = false
local function DetourGunSway(related_func, index, gunmovement)
    if done then return end
    done = true
    local newfunc = function(...)
        local cf = gunmovement(...)
        local mul = 1 -- sway factor config here
        if mul == 0 then
            return CFrame.new()
        end
        local x, y, z = cf:GetComponents()
        x = x * mul
        y = y * mul
        z = z * mul
        local pitch, yaw, roll = cf:ToEulerAnglesYXZ()
        pitch, yaw, roll = pitch * mul, yaw * mul, roll * mul
        cf = CFrame.Angles(pitch, yaw, roll) + Vector3.new(x, y, z)
        return cf
    end
    upvaluemods[#upvaluemods+1] = {related_func, index, gunmovement}
    debug.setupvalue(related_func, index, newcclosure(newfunc))
end

local u41 = CFrame.new
local u11 = math.pi;
local u21 = u11 * 2;
local u13 = math.sin;
local u61 = math.cos;
local cframe = BBOT.aux.cframe

-- u174(0.7 - 0.3 * l__p__958, 1 - 0.8 * l__p__958)
-- l__p__958 = aimspring.p
local slidespring_lerp = 0
local function gunbob_old(p272, p273)
    local v714 = nil;
    local v715 = nil;
    -- what is dis?
    -- a way of not relying on springs for procedural velocity animations :)
    local char_multi = math.clamp(math.remap(char.speed, -5, 13, 0, 1)^3,0,1)
    
    -- just some base multipliers
    local v716 = 0.7 * char_multi -- the Y offset movement
    local v717 = 1 * char_multi -- angular movement
    v714 = char.distance * u21 * 3 / 4;
    v715 = -char.velocity;
    local v718 = char.speed * (1 - char.slidespring.p * 0.9) -- make sliding not look stupid lol

    -- the mmmmm formula
    local swap = char.slidespring.p
    local cf_pos_x = math.remap(swap, 1, 0, v718, (5 * v718 - 56))
    local cf_ang_xy = math.remap(swap, 1, 0, 1, v718 / 20 * u21)
    local cf_ang_z = math.remap(swap, 1, 0, 1, (5 * v718 - 56) / 20 * u21)
    local cf_ang = math.remap(swap, 1, 0, v718 / 20 * u21, 1)

    return u41(v717 * u61(v714 / 8 - 1) * cf_pos_x / (196/((char_multi+.5)/2)), 1.25 * v716 * u13(v714 / 4) * v718 / 512, 0)
    * cframe.fromaxisangle(
        Vector3.new(
            (v717 * u13(v714 / 4 - 1) / 256 + v717 * (u13(v714 / 64) - v717 * v715.z / 4) / 512) * cf_ang_xy,
            (v717 * u61(v714 / 128) / 256 - v717 * u61(v714 / 8) / 256) * cf_ang_xy,
            v717 * u13(v714 / 8) / 128 * cf_ang_z + v717 * v715.x / 1024
        ) * cf_ang
    );
end;

local function DetourGunBob(related_func, index, gunmovement)
    local newfunc = function(...)
        local cf
        if config:GetValue("Weapons", "Stats Changer", "Movement", "OG Bob") then
            local ran, _cf = pcall(gunbob_old, ...)
            if not ran then
                BBOT.log(LOG_ERROR, _cf)
                cf = gunmovement(...)
            end
            cf = _cf
        else
            cf = gunmovement(...)
        end

        local mul = config:GetValue("Weapons", "Stats Changer", "Movement", "Bob Scale")/100 -- bob factor config here
        if mul == 0 then
            return CFrame.new()
        end
        local style = config:GetValue("Weapons", "Stats Changer", "Movement", "Weapon Style")
        if style == "Doom" then
            local mul2 = (math.clamp(char.velocity.Magnitude, 0, 30)/25)
            cf = CFrame.Angles((math.sin(tick()*5.5)^2) * (mul*mul2)/16, -math.sin(tick()*5.5) * (mul*mul2)/8, 0) + Vector3.new(math.sin(tick()*5.5) * mul/6, (math.sin(tick()*5.5)^2) * mul/6, 0)*mul2
            return cf
        elseif style == "Quake III" then
            local mul2 = (math.clamp(char.velocity.Magnitude, 0, 30)/25)
            cf = CFrame.Angles(0, -math.sin(tick()*8) * (mul*mul2)/8, 0) + Vector3.new(math.sin(tick()*8) * mul/5, -(math.sin(tick()*8)^2) * mul/5, 0)*mul2
            return cf
        elseif style == "Half-Life" then
            cf = CFrame.Angles(0, 0, 0) + Vector3.new(0, 0, (math.sin(tick()*8) * mul/6))*(math.clamp(char.velocity.Magnitude, 0, 35)/30)
            return cf
        else
            local x, y, z = cf:GetComponents()
            x = x * mul
            y = y * mul
            z = z * mul
            local pitch, yaw, roll = cf:ToEulerAnglesYXZ()
            pitch, yaw, roll = pitch * mul, yaw * mul, roll * mul
            cf = CFrame.Angles(pitch, yaw, roll) + Vector3.new(x, y, z)
            return cf
        end
    end
    upvaluemods[#upvaluemods+1] = {related_func, index, gunmovement}
    debug.setupvalue(related_func, index, newcclosure(newfunc))
end

local workspace = BBOT.service:GetService("Workspace")
hook:Add("Initialize", "BBOT:Weapons.Detour", function()
    local receivers = network.receivers
    for k, v in pairs(receivers) do
        local const = debug.getconstants(v)
        if table.quicksearch(const, "Trigger") and table.quicksearch(const, "Indicator") and table.quicksearch(const, "Ticking") then
            local thingy
            hook:Add("PreNetworkReceive", "BBOT:Weapons.Grenades", function(netindex, player, grenadename, animtable)
                if netindex ~= k then return end
                thingy = workspace.Ignore.Misc.DescendantAdded:Connect(function(descendant)
                    if descendant.Name ~= "Trigger" then return end
                    timer:Async(function() hook:Call("GrenadeCreated", descendant, player, grenadename, animtable) end)
                end)
            end)
            hook:Add("PostNetworkReceive", "BBOT:Weapons.Grenades", function(netindex, player, grenadename, animtable)
                if netindex ~= k then return end
                thingy:Disconnect()
            end)
        end
        local ups = debug.getupvalues(v)
        for upperindex, related_func in pairs(ups) do
            if typeof(related_func) == "function" then
                local funcname = debug.getinfo(related_func).name
                if funcname == "loadgun" then
                    local _ups = debug.getupvalues(related_func)
                    for index, modifydata in pairs(_ups) do
                        if typeof(modifydata) == "function" then
                            -- this also contains "gunbob" and "gunsway"
                            -- we can change these as well...
                            local name = debug.getinfo(modifydata).name
                            if name == "gunrequire" then
                                DetourWeaponRequire(related_func, index, modifydata)
                            elseif name == "modifydata" then
                                DetourModifyData(related_func, index, modifydata) -- Stats modification
                            elseif name == "gunbob" then
                                DetourGunBob(related_func, index, modifydata)
                            elseif name == "gunsway" then
                                DetourGunSway(related_func, index, modifydata)
                            end
                        end
                    end
                    DetourGunLoader(v, upperindex, related_func) -- this will allow us to modify before and after events of gun loading
                    -- Want rainbow guns? well there ya go
                elseif funcname == "loadknife" then
                    local _ups = debug.getupvalues(related_func)
                    for index, modifydata in pairs(_ups) do
                        if typeof(modifydata) == "function" then
                            -- this also contains "gunbob" and "gunsway"
                            -- we can change these as well...
                            local name = debug.getinfo(modifydata).name
                            if name == "gunbob" then
                                DetourGunBob(related_func, index, modifydata)
                            elseif name == "gunsway" then
                                DetourGunSway(related_func, index, modifydata)
                            end
                        end
                    end

                    DetourKnifeLoader(v, upperindex, related_func)
                end
            end
        end
    end

    do
        local ogrenadeloader = rawget(char, "loadgrenade")
        hook:Add("Unload", "UndoWeaponDetourGrenades", function()
            rawset(char, "loadgrenade", ogrenadeloader)
        end)
        local function loadgrenadee(self, ...)
            hook:CallP("PreLoadGrenade", ...)
            local gundata = ogrenadeloader(self, ...)
            hook:CallP("PostLoadGrenade", gundata)
            return gundata
        end
        rawset(char, "loadgrenade", newcclosure(loadgrenadee))
    end
end)

-- setup of our detoured controllers
hook:Add("PostLoadKnife", "PostLoadKnife", function(gundata, gunname)
    local ups = debug.getupvalues(gundata.destroy)
    for k, v in pairs(ups) do
        local t = typeof(v)
        if t == "Instance" and v.ClassName == "Model" then
            gundata._model = v
        end
    end


    local ups = debug.getupvalues(gundata.playanimation)
    for k, v in pairs(ups) do
        local t = typeof(v)
        if t == "table" and v.camodata and typeof(v.larm) == "table" and v.larm.basec0 then
            gundata._anims = v
        end
    end

    local oldstep = gundata.step
    function gundata.step(...)
        hook:CallP("PreKnifeStep", gundata)
        local a, b, c, d = oldstep(...)
        hook:CallP("PostKnifeStep", gundata)
        return a, b, c, d
    end
end)

hook:Add("PostLoadGun", "PostLoadGun", function(gundata, gunname)
    local oldstep = gundata.step
    local ups = debug.getupvalues(gundata.playanimation)
    for k, v in pairs(ups) do
        local t = typeof(v)
        if t == "table" and v.camodata and typeof(v.larm) == "table" and v.larm.basec0 then
            gundata._anims = v
        end
    end

    local ups = debug.getupvalues(gundata.destroy)
    for k, v in pairs(ups) do
        local t = typeof(v)
        if t == "Instance" and v.ClassName == "Model" then
            gundata._model = v
        end
    end

    local ups = debug.getupvalues(gundata.setequipped)
    for k, v in pairs(ups) do
        if typeof(v) == "function" then
            local name = debug.getinfo(v).name
            if name == "updatefiremodestability" then
                local ups = debug.getupvalues(v)
                for kk, vv in pairs(ups) do
                    if typeof(vv) == "number" then
                        if kk == 4 and vv == 1 then
                            function gundata:getfiremode()
                                local mode = debug.getupvalue(v, kk) or 1
                                local rate
                                if typeof(self.data.firerate) == "table" then
                                    rate = self.data.firerate[mode]
                                else
                                    rate = self.data.firerate
                                end
                                return self.data.firemodes[mode], rate
                            end
                        end
                    end
                end
            end
        end
    end

    local ups = debug.getupvalues(oldstep)
    for k, v in pairs(ups) do
        if typeof(v) == "function" then
            local ran, consts = pcall(debug.getconstants, v)
            if ran and table.quicksearch(consts, "onfire") and table.quicksearch(consts, "pullout") and table.quicksearch(consts, "straightpull") and table.quicksearch(consts, "zoom") and table.quicksearch(consts, "zoompullout") then
                local function replacement(...)
                    hook:CallP("PreFireStep", gundata)
                    local a, b, c, d = v(...)
                    hook:CallP("PostFireStep", gundata)
                    return a, b, c, d
                end
                debug.setupvalue(oldstep, k, replacement)
                gundata.firestep = replacement
            end
        end
    end

    function gundata.step(...)
        -- this is where the aimbot controller will be
        hook:CallP("PreWeaponStep", gundata)
        local a, b, c, d = oldstep(...)
        hook:CallP("PostWeaponStep", gundata)
        return a, b, c, d
    end

    for class, v in pairs(weapons.WeaponDB.weplist) do
        for i=1, #v do
            if v[i] == gunname then
                gundata.___class = class
                return
            end
        end
    end
end)

-- Grenades Wow
-- config:GetValue("Main", "Visuals", "Grenades", "Grenade Warning")

do
    local camera = BBOT.service:GetService("CurrentCamera")
    local localplayer = BBOT.service:GetService("LocalPlayer")
    local char = BBOT.aux.char
    local roundsystem = BBOT.aux.roundsystem
    local cframe = BBOT.aux.cframe
    local draw = BBOT.draw
    local grenade_prediction_lines = {}

    local function CalculateGrenadePathway(grenade_mainpart, grenadedata, delaytime)
        local initiatetime = 0
    
        local me_HumanoidRootPart = localplayer.Character:FindFirstChild("HumanoidRootPart")
        local u193 = char.alive and (camera.CFrame * CFrame.Angles(math.rad(grenadedata.throwangle and 0), 0, 0)).lookVector * grenadedata.throwspeed + me_HumanoidRootPart.Velocity or Vector3.new(math.random(-3, 5), math.random(0, 2), math.random(-3, 5));
        local u195 = char.deadcf and char.deadcf.p or grenade_mainpart.CFrame.p;
        local u197 = (camera.CFrame - camera.CFrame.p) * Vector3.new(19.539, -5, 0);
        local u198 = grenade_mainpart.CFrame - grenade_mainpart.CFrame.p;
        local grenade_mainpart_cframe = grenade_mainpart.CFrame;
        local gravity = Vector3.new(0, -80, 0)
        local windowsbroken = 0
        local u202 = Vector3.new()
        local u146 = u202.Dot
        local u203 = false
        local timedelta = 0.016666666666666666
        local pathtable = {
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
        };
        local timedeltaacc = (timedelta ^ 2)*0.5
        for v765 = 1, (delaytime - initiatetime) / timedelta + 1 do
            local v766 = u195 + timedelta * u193 + timedeltaacc * gravity; -- kinematics basically
            local v767, v768, v769 = workspace:FindPartOnRayWithWhitelist(Ray.new(u195, v766 - u195 - 0.05 * u202),roundsystem.raycastwhitelist);
            local v770 = timedelta * v765;
            if v767 and v767.Name ~= "Window" and v767.Name ~= "Col" then
                u198 = grenade_mainpart.CFrame - grenade_mainpart.CFrame.p;
                u202 = 0.2 * v769;
                u197 = v769:Cross(u193) / 0.2;
                local v771 = v768 - u195;
                local v772 = 1 - 0.001 / v771.magnitude;
                if v772 < 0 then
                    local v773 = 0;
                else
                    v773 = v772;
                end;
                u195 = u195 + v773 * v771 + 0.05 * v769;
                local v774 = u146(v769, u193) * v769;
                local v775 = u193 - v774;
                local v776 = -u146(v769, gravity);
                local v777 = -1.2 * u146(v769, u193);
                local v778 = 0;
                if v776 < 0 then
                    v778 = 0;
                else
                    v778 = v776;
                end;
                local v779 = 0;
                if v777 < 0 then
                    v779 = 0;
                else
                    v779 = v777;
                end;
                local v780 = 1 - 0.08 * (10 * v778 * timedelta + v779) / v775.magnitude;
                local v781 = 0;
                if v780 < 0 then
                    v781 = 0;
                else
                    v781 = v780;
                end;
                u193 = v781 * v775 - 0.2 * v774;
                if u193.magnitude < 1 then
                    local l__frames__782 = pathtable.frames;
                    l__frames__782[#l__frames__782 + 1] = {
                        t0 = v770 - timedelta * (v766 - v768).magnitude / (v766 - u195).magnitude, 
                        p0 = u195, 
                        v0 = u161, 
                        a = u161, 
                        rot0 = cframe.fromaxisangle (v770 * u197) * u198, 
                        offset = 0.2 * v769, 
                        rotv = u161,
                        hitnormal = v769,
                        hit = true,
                        timedelta = timedelta * v765,
                        glassbreaks = {}
                    };
                    break;
                end;
                local l__frames__783 = pathtable.frames;
                l__frames__783[#l__frames__783 + 1] = {
                    t0 = v770 - timedelta * (v766 - v768).magnitude / (v766 - u195).magnitude, 
                    p0 = u195, 
                    v0 = u193, 
                    a = u203 and u161 or gravity, 
                    rot0 = cframe.fromaxisangle (v770 * u197) * u198, 
                    offset = 0.2 * v769, 
                    rotv = u197,
                    timedelta = timedelta * v765,
                    hitnormal = v769,
                    hit = true,
                    glassbreaks = {}
                };
                u203 = true;
            else
                u195 = v766;
                u193 = u193 + timedelta * gravity;
                u203 = false;
                local l__frames__783 = pathtable.frames;
                l__frames__783[#l__frames__783 + 1] = {
                    t0 = v770 - timedelta * (v766 - v768).magnitude / (v766 - u195).magnitude, 
                    p0 = u195, 
                    v0 = u193, 
                    a = u203 and u161 or gravity, 
                    rot0 = cframe.fromaxisangle (v770 * u197) * u198, 
                    offset = 0.2 * v769, 
                    rotv = u197,
                    timedelta = timedelta * v765,
                    hitnormal = Vector3.new(0,1,0),
                    hit = false,
                    glassbreaks = {}
                };
                --[[if v767 and v767.Name == "Window" and windowsbroken < 5 then
                    windowsbroken = windowsbroken + 1;
                    local l__frames__784 = pathtable.frames;
                    local l__glassbreaks__785 = l__frames__784[#l__frames__784].glassbreaks;
                    l__glassbreaks__785[#l__glassbreaks__785 + 1] = {
                        t = v770, 
                        part = v767
                    };
                end;]]
            end;
        end;
        return pathtable
    end

    local pather = BBOT.drawpather:Create()
    pather:ShowEnd(true)
    
    hook:Add("OnConfigChanged", "BBOT:GrenadePrediction", function(steps, old, new)
        if config:IsPathwayEqual(steps, "Main", "Visuals", "Grenades", "Grenade Prediction", "Prediction Color") then
            pather:SetColor(config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction", "Prediction Color"))
        elseif config:IsPathwayEqual(steps, "Main", "Visuals", "Grenades", "Grenade Prediction", true) and not new then
            pather:Clear()
        end
    end)

    hook:Add("OnAliveChanged", "BBOT:GrenadePrediction", function(alive)
        if not alive then
            pather:Clear()
        end
    end)
    
    local dark = Color3.new(0,0,0)

    hook:Add("PostLoadGrenade", "PostLoadGrenade", function(grenadehandler)
        local ups = debug.getupvalues(grenadehandler.throw)
        local createnade, createnadeid
        for k, v in pairs(ups) do
            if typeof(v) == "function" then
                local name = debug.getinfo(v).name
                if name == "createnade" then
                    createnade = v
                    createnadeid = k
                end
            end
        end

        local mainpart = debug.getupvalue(createnade, 2)
        if typeof(mainpart) ~= "Instance" then
            mainpart = nil
        end

        local pull = grenadehandler.pull
        local ups = debug.getupvalues(pull)
        local grenadedataindex
        local grenadedata
        for k, v in pairs(ups) do
            if typeof(v) == "table" then
                if v.throwspeed then
                    grenadedata = v
                    grenadedata = table.deepcopy(grenadedata)
                    grenadedataindex = k
                    debug.setupvalue(pull, k, grenadedata)
                end
            end
        end

        grenadedata.createnade = createnade

        hook:Call("MakeGrenade", grenadedata, grenadehandler)

        hook:BindFunction(createnade, "ThrowGrenade", false, mainpart, grenadedata, grenadehandler)
        hook:BindFunction(grenadehandler.step, "GrenadeStep", false, mainpart, grenadedata, grenadehandler)
    end)

    hook:Add("MakeGrenade", "MakeGrenade", function(grenadedata, grenadehandler)
        if config:GetValue("Main", "Misc", "Tweaks", "Insta Throw Grenades") then
            grenadedata.animations = table.deepcopy(grenadedata.animations)
            for i, v in next, grenadedata.animations do
                if string.find(string.lower(i), "pull") then
                    grenadedata.animations[i].timescale = 0.001
                end
            end
        end

        local speed = config:GetValue("Main", "Misc", "Tweaks", "Grenade Speed")

        grenadedata._throwspeed = grenadedata.throwspeed
        local ups = debug.getupvalues(grenadedata.createnade)
        for k, v in pairs(ups) do
            if typeof(v) == "number" then
                if v == grenadedata.throwspeed then
                    grenadedata._throwspeedindex = k
                end
            end
        end

        if speed ~= 100 then
            grenadedata.throwspeed = grenadedata.throwspeed * (speed/100)
            debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, grenadedata.throwspeed)
        end
    end)

    hook:Add("PreThrowGrenade", "PreThrowGrenade", function()
        hook:UnBindFunction("GrenadeStep")
    end)

    hook:Add("PostThrowGrenade", "PostThrowGrenade", function()
        timer:Async(function()
            hook:UnBindFunction("ThrowGrenade")
        end)
    end)

    hook:Add("PreThrowGrenade", "BBOT:Weapons.Grenades.ShowPath", function(mainpart, grenadedata, grenadehandler)
        local pull = grenadehandler.pull
        local ups = debug.getupvalues(pull)
        local blowuptimeindex = #ups
        local blowtime = debug.getupvalue(pull, blowuptimeindex)-tick()

        local speed = config:GetValue("Main", "Misc", "Tweaks", "Grenade Speed")
        if config:GetValue("Main", "Misc", "Tweaks", "Grenade Distance Speed") then
            local raycastdata = BBOT.aimbot:raycastbullet(camera.CFrame.p, camera.CFrame.LookVector * 2000)
            if raycastdata then
                local newspeed = (raycastdata.Position-camera.CFrame.p).Magnitude * (speed/100) * 2
                debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
                grenadedata.throwspeed = newspeed
            else
                local newspeed = 2000 * (speed/100)
                debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
                grenadedata.throwspeed = newspeed
            end
        end

        pather:Clear()
        local frames = CalculateGrenadePathway(mainpart, grenadedata, blowtime).frames
        if config:GetValue("Main", "Misc", "Tweaks", "Impact Grenades") then
            for i=1, #frames do
                local v = frames[i]
                if v.hit then
                    blowtime = v.timedelta
                    blowtime = math.clamp(blowtime + config:GetValue("Main", "Misc", "Tweaks", "Impact Grenade Time"), 0, 5)
                    debug.setupvalue(pull, blowuptimeindex, blowtime+tick())
                    break
                end
            end
        end
        if config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction") then
            local pathway = {}
            for i=1, #frames do
                if not frames[i].p0 or frames[i].timedelta > blowtime then break end
                if i%2 == 0 then continue end
                pathway[#pathway+1] = frames[i].p0
            end
            local a, b = config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction", "Prediction Color")
            BBOT.drawpather:SimpleWithEnd(pathway, a, b, blowtime)
        end
    end)

    hook:Add("PostGrenadeStep", "BBOT:Weapons.Grenades.ShowPath", function(mainpart, grenadedata, grenadehandler)
        if not mainpart then return end
        local pull = grenadehandler.pull
        local ups = debug.getupvalues(pull)
        local blowuptimeindex = #ups
        local blowtime = debug.getupvalue(pull, blowuptimeindex)-tick()

        local speed = config:GetValue("Main", "Misc", "Tweaks", "Grenade Speed")
        if config:GetValue("Main", "Misc", "Tweaks", "Grenade Distance Speed") then
            local raycastdata = BBOT.aimbot:raycastbullet(camera.CFrame.p, camera.CFrame.LookVector * 2000)
            if raycastdata then
                local newspeed = (raycastdata.Position-camera.CFrame.p).Magnitude * (speed/100) * 2
                debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
                grenadedata.throwspeed = newspeed
            else
                local newspeed = 2000 * (speed/100)
                debug.setupvalue(grenadedata.createnade, grenadedata._throwspeedindex, newspeed)
                grenadedata.throwspeed = newspeed
            end
        end

        if config:GetValue("Main", "Misc", "Tweaks", "Safety Grenades") then
            local throwinhandindex = #ups-2
            debug.setupvalue(pull, throwinhandindex, tick() + 10)
        end

        local impact = config:GetValue("Main", "Misc", "Tweaks", "Impact Grenades")
        if impact then
            blowtime = (grenadedata.fusetime or 5)
            debug.setupvalue(pull, blowuptimeindex, blowtime+tick())
        end
        local frames = CalculateGrenadePathway(mainpart, grenadedata, blowtime).frames
        if impact then
            for i=1, #frames do
                local v = frames[i]
                if v.hit then
                    blowtime = v.timedelta
                    blowtime = math.clamp(blowtime + config:GetValue("Main", "Misc", "Tweaks", "Impact Grenade Time"), 0, 5)
                    break
                end
            end
        end
        if config:GetValue("Main", "Visuals", "Grenades", "Grenade Prediction") then
            local pathway = {}
            for i=1, #frames do
                if not frames[i].p0 or frames[i].timedelta > blowtime then break end
                if i%2 == 0 then continue end
                pathway[#pathway+1] = frames[i].p0
            end
            pather:Update(pathway)
        end
    end)
end

-- Modifications
hook:Add("WeaponModifyData", "ModifyWeapon.Recoil", function(modifications)
    local rot = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Rotation Kick")/100
    local trans = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Displacement Kick")/100
    local cam = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Camera Kick")/100
    local aim = 1
    modifications.rotkickmin = modifications.rotkickmin * rot;
    modifications.rotkickmax = modifications.rotkickmax * rot;
    
    modifications.transkickmin = modifications.transkickmin * trans;
    modifications.transkickmax = modifications.transkickmax * trans;
    
    modifications.camkickmin = modifications.camkickmin * cam;
    modifications.camkickmax = modifications.camkickmax * cam;
    
    modifications.aimrotkickmin = modifications.aimrotkickmin * rot * aim;
    modifications.aimrotkickmax = modifications.aimrotkickmax * rot * aim;
    
    modifications.aimtranskickmin = modifications.aimtranskickmin * trans * aim;
    modifications.aimtranskickmax = modifications.aimtranskickmax * trans * aim;
    
    modifications.aimcamkickmin = modifications.aimcamkickmin * cam * aim;
    modifications.aimcamkickmax = modifications.aimcamkickmax * cam * aim;

    local hchoke = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Hip Choke")/100
    local achoke = config:GetValue("Weapons", "Stats Changer", "Accuracy", "Aim Choke")/100

    if modifications.hipchoke then
        modifications.hipchoke = modifications.hipchoke * hchoke
    end

    if modifications.aimchoke then
        modifications.aimchoke = modifications.aimchoke * achoke
    end

    if config:GetValue("Weapons", "Stats Changer", "Accuracy", "No Scope Sway") then
        modifications.swayamp = 0
    end

    if config:GetValue("Weapons", "Stats Changer", "Accuracy", "Straight Bolt Pull") then
        modifications.pullout = false
        modifications.zoompullout = true
    end

    --[[local cks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "CamKickSpeed")
    local acks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "AimCamKickSpeed")
    local mks = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelKickSpeed")
    local mrs = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelRecoverSpeed")
    local mkd = config:GetValue("Weapons", "Stat Modifications", "Recoil", "ModelKickDamper")

    modifications.camkickspeed = modifications.camkickspeed * cks;
    modifications.aimcamkickspeed = modifications.aimcamkickspeed * acks;
    modifications.modelkickspeed = modifications.modelkickspeed * mks;
    modifications.modelrecoverspeed = modifications.modelrecoverspeed * mrs;
    modifications.modelkickdamper = modifications.modelkickdamper * mkd;]]
end)

hook:Add("WeaponModifyData", "ModifyWeapon.Burst", function(modifications)
    modifications.burstlock = modifications.burstlock or config:GetValue("Weapons", "Stats Changer", "Ballistics", "Burst-Lock");
    local cap = config:GetValue("Weapons", "Stats Changer", "Ballistics", "Burst Cap")
    if cap > 0 then
        modifications.firecap = cap;
    end
end)

hook:Add("WeaponModifyData", "ModifyWeapon.FireModes", function(modifications)
    local firemodes = table.deepcopy(modifications.firemodes)
    local firerates = (typeof(modifications.firerate) == "table" and table.deepcopy(modifications.firerate) or nil)
    local firerates_addition = config:GetValue("Weapons", "Stats Changer", "Ballistics", "Fire Modes")
    local single = firerates_addition["Semi-Auto"] and 1 or nil
    if single and not table.quicksearch(firemodes, single) then
        table.insert(firemodes, 1, single)
    end
    local burst2 = firerates_addition["Burst-2"] and 2 or nil
    if burst2 and not table.quicksearch(firemodes, burst2) then
        table.insert(firemodes, 1, burst2)
    end
    local burst3 = firerates_addition["Burst-3"] and 3 or nil
    if burst3 and not table.quicksearch(firemodes, burst3) then
        table.insert(firemodes, 1, burst3)
    end
    local burst4 = firerates_addition["Burst-4"] and 4 or nil
    if burst4 and not table.quicksearch(firemodes, burst4) then
        table.insert(firemodes, 1, burst4)
    end
    local burst5 = firerates_addition["Burst-5"] and 5 or nil
    if burst5 and not table.quicksearch(firemodes, burst5) then
        table.insert(firemodes, 1, burst5)
    end
    local auto = firerates_addition["Full-Auto"] and true or nil
    if auto and not table.quicksearch(firemodes, auto) then
        table.insert(firemodes, 1, auto)
    end

    modifications.firemodes = firemodes
    if firerates and #firerates < #firemodes then
        local default = firerates[#firerates]
        for i=1, #firemodes-#firerates do
            table.insert(firerates, 1, default)
        end
        modifications.firerate = firerates
    end
    local mul = config:GetValue("Weapons", "Stats Changer", "Ballistics", "Firerate")/100
    if firerates then
        for i=1, #firerates do
            firerates[i] = firerates[i] * mul
        end
        modifications.firerate = firerates
    else
        modifications.firerate = modifications.firerate * mul;
    end
end)

hook:Add("WeaponModifyData", "ModifyWeapon.Reload", function(modifications)
    --if not config:GetValue("Weapons", "Stat Modifications", "Enable") then return end
    local timescale = config:GetValue("Weapons", "Stats Changer", "Animations", "Reload Scale")/100
    for i, v in next, modifications.animations do
        if string.find(string.lower(i), "reload") then
            if typeof(modifications.animations[i]) == "table" and modifications.animations[i].timescale then
                modifications.animations[i].timescale = (modifications.animations[i].timescale or 1) * timescale
            end
        end
    end
end)

hook:Add("PreKnifeStep", "BBOT:Weapon.SwaySpring", function()
    local swayspring = debug.getupvalue(BBOT.aux.char.reloadsprings, 6)
    swayspring.t = swayspring.t*(config:GetValue("Weapons", "Stats Changer", "Movement", "Swing Scale")/100)
end)

hook:Add("PreWeaponStep", "BBOT:Weapon.SwaySpring", function()
    local swayspring = debug.getupvalue(BBOT.aux.char.reloadsprings, 6)
    swayspring.t = swayspring.t*(config:GetValue("Weapons", "Stats Changer", "Movement", "Swing Scale")/100)
end)

hook:Add("WeaponModifyData", "ModifyWeapon.OnFire", function(modifications)
    local timescale = config:GetValue("Weapons", "Stats Changer", "Animations", "OnFire Scale")/100
    for i, v in next, modifications.animations do
        if string.find(string.lower(i), "onfire") then
            if typeof(modifications.animations[i]) == "table" and modifications.animations[i].timescale then
                modifications.animations[i].timescale = (modifications.animations[i].timescale or 1) * timescale
            end
        end
    end
end)

hook:Add("WeaponModifyData", "ModifyWeapon.Offsets", function(modifications)
    local style = config:GetValue("Weapons", "Stats Changer", "Movement", "Weapon Style")
    if style == "Doom" or style == "Quake III" or style == "Rambo" then
        local ang = Vector3.new(0, 0, 0)
        modifications.mainoffset = CFrame.new(Vector3.new(0,-1.5,-1.25)) * CFrame.Angles(ang.X, ang.Y, ang.Z)

        local ang = Vector3.new(-0.479, 0.610, 0.779)
        modifications.sprintoffset = CFrame.new(Vector3.new(0.1,0,-0.25)) * CFrame.Angles(ang.X, ang.Y, ang.Z)

        local ang = Vector3.new(0, 0, 0)
        modifications.crouchoffset = CFrame.new(Vector3.new(0.25,0.25,0.25)) * CFrame.Angles(ang.X, ang.Y, ang.Z)
    end
end)

hook:Add("WeaponModifyData", "ModifyWeapon.Speeds", function(modifications)
    modifications.hipfirespread = modifications.hipfirespread * (config:GetValue("Weapons", "Stats Changer", "Handling", "Hip Spread")/100)
    modifications.aimspeed = modifications.aimspeed * (config:GetValue("Weapons", "Stats Changer", "Handling", "Aiming Speed")/100)
    modifications.equipspeed = modifications.equipspeed * (config:GetValue("Weapons", "Stats Changer", "Handling", "Equip Speed")/100)
    modifications.sprintspeed = modifications.sprintspeed * (config:GetValue("Weapons", "Stats Changer", "Handling", "Ready Speed")/100)
end)

do -- no scope pasted from v1 lol -- yes... omg
    local localplayer = BBOT.service:GetService("LocalPlayer")
    local gui = localplayer.PlayerGui
    local frame = gui.NonScaled.ScopeFrame
    --[[hook:Add("OnConfigChanged", "BBOT:Misc.NoScopeBorders", function(steps, old, new)
        if config:IsPathwayEqual(steps, "Main", "Visuals", "Camera Visuals", "No Scope Border") then return end
        if not frame then return end
        local sightRear = frame:FindFirstChild("SightRear")
        if not sightRear then return end
        if new then
            local children = sightRear:GetChildren()
            for i = 1, #children do
                local thing = children[i]
                if thing.ClassName == "Frame" then
                    thing.Visible = false
                end
            end
            frame.SightFront.Visible = false
            sightRear.ImageTransparency = 1
        else
            local children = sightRear:GetChildren()
            for i = 1, #children do
                local thing = children[i]
                if thing.ClassName == "Frame" then
                    thing.Visible = true
                end
            end
            frame.SightFront.Visible = true
            sightRear.ImageTransparency = 0
        end
    end)]]

    hook:Add("RenderStepped", "BBOT:Weapons.ScopeBorders", function()
        local new = config:GetValue("Main", "Visuals", "Camera Visuals", "No Scope Border")
        if not frame then return end
        local sightRear = frame:FindFirstChild("SightRear")
        if not sightRear then return end
        if new then
            local children = sightRear:GetChildren()
            for i = 1, #children do
                local thing = children[i]
                if thing.ClassName == "Frame" then
                    thing.Visible = false
                end
            end
            frame.SightFront.Visible = false
            sightRear.ImageTransparency = 1
        else
            local children = sightRear:GetChildren()
            for i = 1, #children do
                local thing = children[i]
                if thing.ClassName == "Frame" then
                    thing.Visible = true
                end
            end
            frame.SightFront.Visible = true
            sightRear.ImageTransparency = 0
        end
    end)
end

-- Skins
do
    local texture_animtypes = {
        ["OffsetStudsU"] = true,
        ["OffsetStudsV"] = true,
        ["StudsPerTileU"] = true,
        ["StudsPerTileV"] = true,
        ["Transparency"] = true,
    }

    local animation_to_simple = {
        ["OSU"] = "OffsetStudsU",
        ["OSV"] = "OffsetStudsV",
        ["SPTU"] = "StudsPerTileU",
        ["SPTV"] = "StudsPerTileV",
        ["BC"] = "BrickColor",
        ["TC"] = "TextureColor",
    }

    function weapons:SetupAnimations(reg, objects, type, animtable, extra)
        for k, v in pairs(reg) do
            if typeof(v) == "table" and v.Enabled then
                k = animation_to_simple[k] or k
                if texture_animtypes[k] and type == "Texture" then
                    if v.Type.value == "Additive" then
                        animtable[#animtable+1] = {
                            t = "Additive",
                            s = v.Speed,
                            p0 = -1,
                            min = -1,
                            max = 1,
                            objects = objects,
                            property = k
                        }
                    else
                        animtable[#animtable+1] = {
                            t = "Wave",
                            a = v.Amplitude,
                            o = v.Offset,
                            s = v.Speed,
                            objects = objects,
                            property = k
                        }
                    end
                elseif (k == "BrickColor" and type ~= "Texture") or (k == "TextureColor" and type == "Texture") then
                    local col = (type == "Texture" and "Color3" or "Color")
                    if v.Type.self.value == "Fade" then
                        animtable[#animtable+1] = {
                            t = "Fade",
                            s = v.Speed,
                            c0 = Color3.fromRGB(unpack(v.Type["Primary Color"].value)),
                            c1 = Color3.fromRGB(unpack(v.Type["Secondary Color"].value)),
                            m = extra or 1,
                            objects = objects,
                            property = col
                        }
                    else
                        animtable[#animtable+1] = {
                            t = "Cycle",
                            s = v.Speed,
                            m = extra or 1,
                            sa = v.Saturation/100,
                            da = v.Darkness/100,
                            objects = objects,
                            property = col
                        }
                    end
                end
            end
        end
    end

    local color = BBOT.color
    function weapons:RenderAnimations(animtable, delta)
        for i=1, #animtable do
            local anim = animtable[i]
            local position
            if anim.t == "Wave" then
                position = anim.o + math.sin(anim.s * tick()) * anim.a
            elseif anim.t == "Additive" then
                position = anim.p0 + anim.s * delta
                if position > anim.max then
                    position = position - anim.max
                    position = position + anim.min
                end
                anim.p0 = position
            elseif anim.t == "Fade" then
                local pos = math.sin(anim.s * tick())
                local c0, c1 = anim.c0, anim.c1
                c0, c1 = Vector3.new(c0.r, c0.g, c0.b), Vector3.new(c1.r, c1.g, c1.b)
                local dc = math.remap(pos, -1, 1, c0, c1)
                position = Color3.new(dc.x, dc.y, dc.z)
                position = color.mul(position, anim.m)
            elseif anim.t == "Cycle" then
                position = Color3.fromHSV(((tick() * anim.s) % 90) / 90, anim.sa, anim.da)
                position = color.mul(position, anim.m)
            end
            if position then
                for i=1, #anim.objects do
                    local object = anim.objects[i]
                    object[anim.property] = position or object[anim.property]
                end
            end
        end
    end

    local asset = BBOT.asset
    function weapons:CreateSkin(skin_databank, config_data, gun_objects, gun_data)
        skin_databank.objects = gun_objects
        local textures = {}
        for i=1, #gun_objects do
            local object = gun_objects[i]
            object.Color = color.mul(Color3.fromRGB(unpack(config_data.Basics["Material"]["Brick Color"].value)), config_data.Basics["Color Modulation"])
            object.Material = config.enums.Material.Id[config_data.Basics["Material"]["self"].value]
            object.Reflectance = config_data.Basics["Reflectance"]/100
            if object:IsA("UnionOperation") then
                object.UsePartColor = true
            end
            local texture = config_data["Texture"]
            if texture.Enabled and object.Transparency < 1 and not object:FindFirstChild("OtherHide") and texture["Asset-Id"] ~= "" and (object:IsA("MeshPart") or object:IsA("UnionOperation")) then
                for i=0, 5 do
                    local itexture = Instance.new("Texture")
                    itexture.Parent = object
                    itexture.Face = i
                    itexture.Name = "Slot1"
                    itexture.Color3 = color.mul(Color3.fromRGB(unpack(texture["Asset-Id"]["Texture Color"].value)), texture["Color Modulation"])

                    local trueassetid = ""
                    local assetid = texture["Asset-Id"].self
                    if asset:IsFile("textures", assetid) then
                        trueassetid = asset:GetAsset("textures", assetid)
                    else
                        trueassetid = "rbxassetid://" .. assetid
                    end

                    itexture.Texture = trueassetid
                    itexture.Transparency = 1-(texture["Asset-Id"]["Texture Color"].value[4]/255)
                    itexture.OffsetStudsU = texture.OffsetStudsU
                    itexture.OffsetStudsV = texture.OffsetStudsV
                    itexture.StudsPerTileU = texture.StudsPerTileU
                    itexture.StudsPerTileV = texture.StudsPerTileV
                    if gun_data then
                        if not gun_data._anims.camodata[object] then
                            gun_data._anims.camodata[object] = {}
                        end
                        gun_data._anims.camodata[object][itexture] = {
                            Transparency = itexture.Transparency
                        }
                    end
                    skin_databank.textures[#skin_databank.textures+1] = {object, itexture}
                    textures[#textures+1] = itexture
                end
            end
        end
        self:SetupAnimations(config_data.Animations, textures, "Texture", skin_databank.animations, config_data["Texture"]["Color Modulation"])
        self:SetupAnimations(config_data.Animations, gun_objects, "Part", skin_databank.animations, config_data.Basics["Color Modulation"])
    end

    function weapons:ApplySkin(reg, gundata, slot1, slot2)
        local skins = {
            slot1 = {
                objects = {},
                textures = {},
                animations = {}
            },
            slot2 = {
                objects = {},
                textures = {},
                animations = {}
            },
        }
        if gundata then
            gundata._skins = skins
        end
        local slot1_data = reg["Slot1"]
        if slot1_data.Basics.Enabled then
            self:CreateSkin(skins.slot1, slot1_data, slot1, gundata)
        end

        local slot2_data = reg["Slot2"]
        if slot2_data.Basics.Enabled then
            self:CreateSkin(skins.slot2, slot2_data, slot2, gundata)
        end

        return skins
    end

    hook:Add("PreInitialize", "BBOT:Weapons.SkinDB", function()
        local receivers = network.receivers
        for k, v in pairs(receivers) do
            local ups = debug.getupvalues(v)
            for kk, vv in pairs(ups) do
                if typeof(vv) == "function" then
                    local ran, consts = pcall(debug.getconstants, vv)
                    if ran and table.quicksearch(consts, " times this month)") then
                        weapons.skindatabase = debug.getupvalue(vv, 4)
                    end
                end
            end
        end
    end)

    do
        weapons.weaponstorage = debug.getupvalue(char.unloadguns, 2)

        hook:Add("OnConfigChanged", "Skin.LiveChanger", function(steps, old, new)
            if config:IsPathwayEqual(steps, "Weapons", "Skins") then
                local reg = config:GetValue("Weapons", "Skins")
                if not reg.Enabled then return end
                for k, v in pairs(weapons.weaponstorage) do
                    weapons:SkinApplyGun(v)
                end
            end
        end)
    end

    function weapons:SkinApplyGun(gundata, slot)
        local slot = slot or gundata.gunnumber
        local model = gundata._model
        if not model then return end
        local reg = config:GetValue("Weapons", "Skins")
        if not reg.Enabled then return end
        local slot1, slot2 = weapons:PrepareSkins(model)
        weapons:ApplySkin(reg, gundata, slot1, slot2)
    end

    function weapons:PrepareSkins(model)
        local descendants = model:GetDescendants()
        local slot1, slot2 = {}, {}
        for k, v in pairs(descendants) do
            if v.ClassName == 'Texture' and (v.Name == "Slot1" or v.Name == "Slot2") then
                v:Destroy()
            end
        end

        for k, v in pairs(descendants) do
            if v.ClassName == 'Part' or v.ClassName == 'MeshPart' or v.ClassName == 'UnionOperation' then
                if v:FindFirstChild("Slot1") then
                    slot1[#slot1+1] = v
                elseif v:FindFirstChild("Slot2") then
                    slot2[#slot2+1] = v
                end
            end
        end

        return slot1, slot2
    end

    hook:Add("PostLoadGun", "Skin.Apply", function(gundata, name)
        weapons:SkinApplyGun(gundata)
    end)

    hook:Add("PostInitialize", "Skin.LiveApply", function()
        local workspace = BBOT.service:GetService("Workspace")
        local gunstage_connection_add = false
        local gunstage_connection_remove = false

        hook:Add("Unload", "BBOT:Skins.StagePreview", function()
            if gunstage_connection_add then
                gunstage_connection_add:Disconnect()
                gunstage_connection_add = nil
            end
            if gunstage_connection_remove then
                gunstage_connection_remove:Disconnect()
                gunstage_connection_remove = nil
            end
        end)

        local function performchanges(gunmodel)
            local model = gunmodel:GetChildren()[1]
            if not model then return end
            local reg = config:GetValue("Weapons", "Skins")
            if not reg.Enabled then return end

            local slot1, slot2 = weapons:PrepareSkins(model)
            local applied = weapons:ApplySkin(reg, nil, slot1, slot2)
            
            hook:Add("RenderStepped", "Skin.Preview.Animations", function(delta)
                if not reg.Enabled then return end
                weapons:RenderAnimations(applied.slot1.animations, delta)
                weapons:RenderAnimations(applied.slot2.animations, delta)
            end)
        end


        local changing = false
        hook:Add("Skins.GunStageChanged", "Skins.GunStageChanged", function(gunmodel)
            timer:Create("Skins.ReloadStage", 0, 1, function()
                changing = true
                performchanges(gunmodel)
                changing = false
            end)
        end)

        local function refresh()
            if not workspace:FindFirstChild("MenuLobby") then return end
            if not workspace.MenuLobby:FindFirstChild("GunStage") then return end
            if not workspace.MenuLobby.GunStage:FindFirstChild("GunModel") then return end
            local gunmodel = workspace.MenuLobby.GunStage.GunModel
            
            if gunstage_connection_add then
                gunstage_connection_add:Disconnect()
                gunstage_connection_add = nil
            end

            if gunstage_connection_remove then
                gunstage_connection_remove:Disconnect()
                gunstage_connection_remove = nil
            end

            gunstage_connection_add = gunmodel.DescendantAdded:Connect(function()
                if changing then return end

                changing = true
                hook:CallP("Skins.GunStageChanged", gunmodel)
                changing = false
            end)

            gunstage_connection_remove = gunmodel.DescendantRemoving:Connect(function()
                if changing then return end

                changing = true
                hook:CallP("Skins.GunStageChanged", gunmodel)
                changing = false
            end)

            changing = true
            performchanges(gunmodel)
            changing = false
        end

        hook:Add("OnConfigChanged", "Skin.Preview", function(steps, old, new)
            if not config:IsPathwayEqual(steps, "Weapons", "Skins") then return end
            refresh()
        end)

        timer:Async(refresh)
    end)

    hook:Add("PostLoadKnife", "Skin.Apply", function(gundata, name)
        local model = gundata._model
        gundata._isknife = true
        if not model then return end
        local reg = config:GetValue("Weapons", "Skins")
        if not reg.Enabled then return end

        local slot1, slot2 = weapons:PrepareSkins(model)

        weapons:ApplySkin(reg, gundata, slot1, slot2)
    end)

    hook:Add("PostWeaponStep", "Skin.Animation", function(gundata, partdata)
        if not gundata._skins then return end
        local reg = config:GetValue("Weapons", "Skins")
        if not reg.Enabled then return end
        if not gundata._skinlast then
            gundata._skinlast = tick()
            return
        end
        local delta = tick()
        weapons:RenderAnimations(gundata._skins.slot1.animations, delta-gundata._skinlast)
        weapons:RenderAnimations(gundata._skins.slot2.animations, delta-gundata._skinlast)
        gundata._skinlast = delta
    end)

    hook:Add("PostKnifeStep", "Skin.Animation", function(gundata, partdata)
        if not gundata._skins then return end
        local reg = config:GetValue("Weapons", "Skins")
        if not reg.Enabled then return end
        if not gundata._skinlast then
            gundata._skinlast = tick()
            return
        end
        local delta = tick()
        weapons:RenderAnimations(gundata._skins.slot1.animations, delta-gundata._skinlast)
        weapons:RenderAnimations(gundata._skins.slot2.animations, delta-gundata._skinlast)
        gundata._skinlast = delta
    end)
end

return weapons