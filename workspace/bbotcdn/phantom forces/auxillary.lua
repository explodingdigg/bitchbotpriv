BBOT:SetLoadingStatus("Loading Auxillary...", 20)
local math = BBOT.math
local table = BBOT.table
local hook = BBOT.hook
local debug = BBOT.debug
local timer = BBOT.timer
local localplayer = BBOT.service:GetService("LocalPlayer")
local remotefunc = BBOT.service:GetService("ReplicatedStorage").RemoteFunction -- for fetching shit
local remoteevent = BBOT.service:GetService("ReplicatedStorage").RemoteEvent
local aux = {
    pfremoteevent = remoteevent,
    pfremotefunc = remotefunc
}

-- This is my automated way of fetching and finding shared modules pf uses
-- How to access -> BBOT.aux.replication
local aux_tables = {
    {
        Name = "vector",
        Keys = {"random", "anglesyx"},
    },
    {
        Name = "animation",
        Keys = {"player", "reset"},
    },
    {
        Name = "particle",
        Sources = {
            ["new"] = "particle",
        },
        Keys = {"new", "step", "reset"},
    },
    {
        Name = "gamelogic",
        Keys = {"controllerstep", "setsprintdisable"},
    },
    {
        Name = "camera",
        Keys = {"setaimsensitivity", "magnify"},
    },
    {
        Name = "network",
        Keys = {"servertick", "send"},
    },
    {
        Name = "hud",
        Keys = {"addnametag"},
    },
    {
        Name = "roundsystem",
        Keys = {"lock", "raycastwhitelist"},
    },
    {
        Name = "playerdata",
        Keys = {"getattloadoutdata", "getgunattdata", "getattachdata", "updatesettings"},
    },
    {
        Name = "char",
        Keys = {"unloadguns", "getslidecondition", "sprinting"},
    },
    {
        Name = "replication",
        Keys = {"getplayerhit"},
    },
    {
        Name = "cframe",
        Keys = {"fromaxisangle", "toaxisangle", "direct"},
    },
    {
        Name = "sound",
        Keys = {"PlaySound", "play"},
    },
    {
        Name = "raycast",
        Keys = {"raycast", "raycastSingleExit"},
    },
    {
        Name = "menu",
        Keys = {"isdeployed"},
    },
    {
        Name = "ScreenCull",
        Keys = {"point", "sphere", "localSegment", "segment"},
    },
    {
        Name = "GunDataGetter",
        Keys = {"getGunModule", "getGunModel", "getGunList"}
    },
}

-- fetches by function name
-- index is the function you are finding
-- value is where to put it in aux
-- true = aux.bulletcheck, replication = aux.replication.bulletcheck
local aux_functions = {
    {
        Name = "bulletcheck",
        Store = "raycast",
    },
    {
        Name = "rankcalculator",
        Store = "playerdata",
    },
    {
        Name = "call",
    },
    {
        Name = "gunbob",
    },
    {
        Name = "gunsway",
    },
    {
        Name = "addplayer",
    },
    {
        Name = "removeplayer",
    },
    {
        Name = "loadplayer",
    },
    {
        Name = "updateplayernames",
    },
}

function aux:_Scan()
    local core_aux, core_aux_sub = {}, {}

    BBOT.log(LOG_DEBUG, "Scanning...")
    BBOT:SetLoadingStatus(nil, 30)

    BBOT.log(LOG_DEBUG, "Scanning auxillaries...")

    for _=1, #aux_tables do
        local data = aux_tables[_]
        local name = data.Name
        local sources = data.Sources
        data.IgnoreSyn = true -- This should already be set to true[?] (as-per synv3 docs)
        local gc = filtergc("table", data)
        for i=1, #gc do
            local gc_data = gc[i]
            if sources then
                local success = false
                for fname, path in next, sources do
                    local value = rawget(gc_data, fname)
                    if typeof(value) == "function" and string.find(debug.getinfo(value).source, path, 1, true) then
                        success = true
                        break
                    end
                end
                if not success then continue end
            end
            if core_aux[name] ~= gc_data then
                if core_aux[name] ~= nil then
                    BBOT.log(LOG_WARN, 'Warning: Auxillary overload for "' .. name .. '"')
                    for kk, vv in pairs(core_aux[name]) do
                        if vv ~= rawget(gc_data, kk) then
                            return "Duplicate auxillary \"" .. name .. "\""
                        end
                    end
                    core_aux[name] = gc_data
                    BBOT.log(LOG_DEBUG, 'Found Auxillary "' .. name .. '"')
                else
                    core_aux[name] = gc_data
                    BBOT.log(LOG_DEBUG, 'Found Auxillary "' .. name .. '"')
                end
            end
        end
    end

    for _=1, #aux_functions do
        local data = aux_functions[_]
        local name = data.Name
        data.IgnoreSyn = true
        local gc = filtergc("function", data)
        for i=1, #gc do
            local gc_data = gc[i]
            BBOT.log(LOG_DEBUG, 'Found Auxillary Function "' .. name .. '"')
            core_aux_sub[name] = gc_data
        end
    end

    BBOT:SetLoadingStatus(nil, 40)

    BBOT.log(LOG_DEBUG, "Checking auxillaries...")
    for _=1, #aux_tables do
        local data = aux_tables[_]
        if not core_aux[data.Name] then
            return "Couldn't find auxillary \"" .. k ..  "\""
        end
    end

    for _=1, #aux_functions do
        local data = aux_functions[_]
        if not core_aux_sub[data.Name] then
            return "Couldn't find auxillary \"" .. k ..  "\""
        end
    end

    for k, v in next, core_aux do
        self[k] = v
    end

    for _=1, #aux_functions do
        local data = aux_functions[_]
        local k, v = data.Name, core_aux_sub[data.Name]
        local saveas = data.Store
        if saveas then
            if not self[saveas] then
                self[saveas] = {}
            end
            local t = self[saveas]
            rawset(t, k, v)
            hook:Add("Unload", "BBOT:Aux.RemoveAuxSub-" .. k, function()
                rawset(t, k, nil)
            end)
            BBOT.log(LOG_DEBUG, 'Auxillary Function "' .. k .. '" sorted into ' .. saveas)
        else
            self[k] = v
        end
    end

    local reg = getgc()
    for i=1, #reg do
        local v = reg[i]
        if typeof(v) == "function" then
            local dbg = debug.getinfo(v)
            if string.find(dbg.short_src, "network", 1, true) then
                local consts = debug.getconstants(v)
                if table.quicksearch(consts, "warn") and table.quicksearch(consts, "Tried to call a unregistered network event %s") then
                    local ups = debug.getupvalues(v)
                    if typeof(ups[1]) == "table" then
                        rawset(aux.network, "receivers", ups[1])
                    end
                    hook:BindFunctionOverride(v, "NetworkReceive")
                end
            end
        end
    end

    --[[local onclientevent_connections = getconnections(aux.pfremoteevent.OnClientEvent)
    for k, v in pairs(onclientevent_connections) do
        print(1, v)
        if not isluaconnection(v) then continue end
        print(2, v)
        local func = getconnectionfunction(v)
        if not func then continue end
        local dbg = debug.getinfo(func)
        print(dbg.short_src)
        if string.find(dbg.short_src, "network", 1, true) then
            hook:BindFunctionOverride(func, "NetworkReceive")
            local ups = debug.getupvalues(func)
            for k=1, #ups do
                local vv = ups[k]
                if typeof(vv) == "table" then
                    if rawget(vv, "ping") then -- yes, I grab ur network shit 😂😂😂
                        rawset(aux.network, "receivers", vv)
                        break
                    end
                end
            end
        end
    end]]

    if not aux.network.receivers then
        return "Couldn't find auxillary \"network.receivers\""
    end

    hook:Add("Unload", "BBOT:Aux.NetworkReceivers", function()
        rawset(aux.network, "receivers", nil)
    end)

    local function override_Position(controller)
        --[[if not controller.alive or not controller.receivedPosition then
            controller.__spawn_position = nil
        elseif controller.__spawn_position then
            controller.receivedPosition = controller.__spawn_absolute
            controller.__spawn_position = nil
        end]]
        if controller.__just_spawned then
            controller.__just_spawned = false
            hook:Call("updateReplicationJustSpawned", controller)
        end
    end

    local function override_spawn(controller, pos)
        if typeof(pos) == "Vector3" then
            controller.__spawn_position = pos
            controller.__spawn_absolute = controller.getpos()
            controller.receivedPosition = controller.__spawn_position
            controller.__t_received = tick()
        end
        controller.__spawn_time = tick()
        controller.__just_spawned = true
    end

    local function override_Updater(player, controller)
        if player == localplayer then
            hook:CallP("CreateUpdater", player)
            return
        end
        local upd_updateReplication = controller.updateReplication
        controller._upd_updateReplication = upd_updateReplication
        function controller.updateReplication(...)
            hook:CallP("PreupdateReplication", player, controller, ...)
            return upd_updateReplication(...), override_Position(controller), hook:CallP("PostupdateReplication", player, controller, ...)
        end
        local upd_spawn = controller.spawn
        controller._upd_spawn = upd_spawn
        function controller.spawn(pos, ...)
            hook:CallP("Preupdatespawn", player, controller, pos, ...)
            controller.__stance = "stand"
            return upd_spawn(pos, ...), override_spawn(controller, pos), hook:CallP("Postupdatespawn", player, controller, pos, ...)
        end
        local upd_step = controller.step
        controller._upd_step = upd_step
        function controller.step(renderscale, shouldrender, ...)
            local a, b = hook:CallP("PreupdateStep", player, controller, renderscale, shouldrender, ...)
            if a ~= nil then renderscale = a end
            if b ~= nil then shouldrender = b end
            return upd_step(renderscale, shouldrender, ...), hook:CallP("PostupdateStep", player, controller, renderscale, shouldrender, ...)
        end
        local upd_setstance = controller.setstance
        controller._upd_setstance = upd_setstance
        function controller.setstance(stance, ...)
            controller.__stance = stance
            return upd_setstance(stance, ...)
        end
        hook:CallP("CreateUpdater", player)
    end

    local updater = aux.replication.getupdater
    local ups = debug.getupvalues(aux.replication.getupdater)
    for k, v in pairs(ups) do
        if typeof(v) == "table" then
            rawset(aux.replication, "player_registry", v)
            for player, v in pairs(v) do
                if (localplayer ~= player and v.updater) then
                    local controller = v.updater
                    override_Updater(player, controller)
                end
            end
        elseif typeof(v) == "function" then
            local function createupdater(player)
                local controller = v(player)
                if (localplayer ~= player) then
                    override_Updater(player, controller)
                end
                return controller
            end
            rawset(aux.replication, "_updater", v)
            debug.setupvalue(updater, k, newcclosure(createupdater))
            hook:Add("Unload", "BBOT:Aux.Replication.UndoUpdaterDetour", function()
                debug.setupvalue(updater, k, v)
            end)
        end
    end

    hook:Add("Unload", "BBOT:Aux.Replication.Updater", function()
        for k, v in pairs(aux.replication.player_registry) do
            if v.updater and v.updater._upd_updateReplication then
                v.updater.updateReplication = v.updater._upd_updateReplication
                v.updater._upd_updateReplication = nil

                v.updater.spawn = v.updater._upd_spawn or v.updater.spawn
                v.updater._upd_spawn = nil

                v.updater.step = v.updater._upd_step or v.updater.step
                v.updater._upd_step = nil

                v.updater.setstance = v.updater._upd_setstance or v.updater.setstance
                v.updater._upd_setstance = nil
            end
        end
        aux.replication.player_registry[localplayer] = nil
        rawset(aux.replication, "player_registry", nil)
        rawset(aux.replication, "_updater", nil)
    end)

    if not aux.replication.player_registry then
        return "Couldn't find auxillary \"replication.player_registry\""
    end

    if not aux.replication._updater then
        return "Couldn't find auxillary \"replication._updater\""
    end
end

local profiling_tick = tick()
local error = aux:_Scan()
if error then
    BBOT.log(LOG_ERROR, error)
    BBOT.log(LOG_WARN, "For safety reasons this process has been halted")
    messagebox("For safety reasons this process has been halted\nError: " .. error .. "\nPlease contact the Demvolopers!", "BBOT: Critical Error", 0)
    return true
end

BBOT:SetLoadingStatus(nil, 45)

--[[do -- using rawget just in case...
    local send = rawget(aux.network, "send")
    local osend = rawget(aux.network, "_send")
    hook:Add("Unload", "BBOT:NetworkOverride", function()
        rawset(aux.network, "send", osend or send)
    end)
    local function sender(self, ...)
        local _BB = BBOT
        local _aux = _BB.aux
        local _hook, _send = _BB.hook, _aux.network._send -- something about synapses hooking system I tried...
        if not _aux.network_supressing then
            _aux.network_supressing = true
            if _hook:CallP("SuppressNetworkSend", ...) then
                _aux.network_supressing = false
                return
            end
            _aux.network_supressing = false
        end
        local override = {_hook:CallP("PreNetworkSend", ...)}
        if override[1] ~= nil then
            return _send(self, unpack(override)), _hook:CallP("PostNetworkSend", unpack(override))
        end
        return _send(self, ...), _hook:CallP("PostNetworkSend", ...)
    end
    local function newsend(self, netname, ...)
        local ran, a, b, c, d, e = xpcall(sender, debug.traceback, self, netname, ...)
        if not ran then
            BBOT.log(LOG_ERROR, "Networking Error - ", netname, " - ", a)
        else
            return a, b, c, d, e
        end
    end
    rawset(aux.network, "_send", send)
    rawset(aux.network, "send", newcclosure(newsend))
end]]

do
    local oplay = rawget(aux.sound, "PlaySound")
    local oplayid = rawget(aux.sound, "PlaySoundId")
    hook:Add("Unload", "BBOT:Aux.SoundDetour", function()
        rawset(aux.sound, "PlaySound", oplay)
        rawset(aux.sound, "PlaySoundId", oplayid)
    end)
    local supressing = false
    local function newplay(...)
        if supressing then return oplay(...) end
        supressing = true
        if hook:CallP("SuppressSound", ...) then
            supressing = false
            return
        end
        supressing = false
        return oplay(...)
    end
    local supressing = false
    local function newplayid(...)
        if supressing then return oplayid(...) end
        supressing = true
        if hook:CallP("SuppressSoundId", ...) then
            supressing = false
            return
        end
        supressing = false
        return oplayid(...)
    end
    aux.sound._play = oplay
    aux.sound._playid = oplayid
    function aux.sound.playid(p39, p40, p41, p42, p43, p44)
        aux.sound._playid(p39, p40, p41, nil, nil, p42, nil, nil, nil, p43, p44);
    end
    rawset(aux.sound, "PlaySound", newcclosure(newplay))
    rawset(aux.sound, "PlaySoundId", newcclosure(newplayid))
end

local ups = debug.getupvalues(aux.replication.getupdater)
for k, v in pairs(ups) do
    if typeof(v) == "function" then
        local name = debug.getinfo(v).name
        if name == "loadplayer" then
            hook:BindFunction(v, "LoadPlayer")
        end
    end
end

local players = BBOT.service:GetService("Players")
hook:Add("Initialize", "BBOT:Aux.SetupPlayerReplication", function()
    for i, v in next, players:GetChildren() do
        local controller = aux.replication.getupdater(v)
        if controller and not controller.setup then
            hook:Call("PostLoadPlayer", controller)
        end
    end
end)

hook:Add("Initialize", "BBOT:Aux.BigRewardDetour", function()
    local receivers = aux.network.receivers
    for k, v in pairs(receivers) do
        local a = debug.getupvalues(v)[1]
        if typeof(a) == "function" then
            local run, consts = pcall(debug.getconstants, a)
            if run then
                if table.quicksearch(consts, "killshot") and table.quicksearch(consts, "kill") then
                    hook:BindFunction(receivers[k], "BigAward")
                end
            end
        end
    end
end)

local isalive = false
hook:Add("RenderStepped", "BBOT:Aux.IsAlive", function()
    if isalive ~= aux.char.alive then
        isalive = aux.char.alive
        hook:Call("OnAliveChanged", (isalive and true or false))
    end
end)

--hook:BindFunctionOverride(aux.network.send, "NetworkSend")
hook:Add("PostNetworkSend", "BBOT:Aux.FrameworkLogging", function(net, ...)
    if net == "logmessage" or net == "debug" then
        local args = {...}
        local message = ""
        for i = 1, #args - 1 do
            message ..= tostring(args[i]) .. ", "
        end
        message ..= tostring(args[#args])
        BBOT.log(LOG_WARN, "Framework Internal Message -> " .. message)
        hook:Call("InternalMessage", message)
    end

    if BBOT.Debug.internal and net ~= "ping" then
        BBOT.log(LOG_DEBUG, net, ...)
    end
end)

hook:BindFunctionOverride(aux.network.send, "NetworkSend", true)
hook:BindFunction(aux.char.updatecharacter, "LoadCharacter")
hook:BindFunction(aux.ScreenCull.step, "ScreenCullStep")
hook:BindFunction(aux.char.step, "CharacterStep")
hook:BindFunction(aux.camera.step, "CameraStep")

--[[hook:Add("Initialize", "FindnewBullet", function()
    local receivers = network.receivers

    local function quickhasvalue(tbl, value)
        for i=1, #tbl do
            if tbl[i] == value then return true end
        end
        return false
    end

    for k, v in pairs(receivers) do
        local ran, const = pcall(debug.getconstants, v)
        if ran and quickhasvalue(const, "firepos") and quickhasvalue(const, "bullets") and quickhasvalue(const, "bulletcolor") and quickhasvalue(const, "penetrationdepth") then
            receivers[k] = function(data)
                hook:CallP("PreNewBullets", data)
                v(data)
                hook:CallP("PostNewBullets", data)
            end
            hook:Add("Unload", "BBOT:NewBullet.Ups." .. tostring(k), function()
                receivers[k] = v
            end)
        end
    end
end)]]

local dt = tick() - profiling_tick
BBOT.log(LOG_NORMAL, "Took " .. math.round(dt, 2) .. "s to load auxillary")
BBOT:SetLoadingStatus(nil, 50)

return aux