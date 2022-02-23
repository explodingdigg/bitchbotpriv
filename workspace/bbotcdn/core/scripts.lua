local asset = BBOT.asset
local log = BBOT.log
local hook = BBOT.hook
local scripts = {
    registry = {},
}

hook:Add("PreInitialize", "BBOT:Scripts.Initialize", function()
    asset:Register("scripts", {".json", ".lua"}) -- creates scripts folder and wl files
end)

hook:Add("PostInitialize", "BBOT:Scripts.Initialize", function()

    scripts.pre_run = [[local _={...};local BBOT=_[1];local script_name=_[2];]]

    local libraries = {}
    for k, v in pairs(BBOT) do
        if typeof(v) == "table" and not string.match(k, "%s") then
            scripts.pre_run = scripts.pre_run .. "local " .. k .. "=BBOT." .. k .. ";"
        end
    end

    if asset:IsFile("scripts", "autoexec.json") then
        local autoexec = asset:ReadJSON("scripts", "autoexec.json")

        local c = 0
        for i=1, #autoexec do
            local k = i-c
            local name = autoexec[k]
            if not asset:IsFile("scripts", name) then
                table.remove(autoexec, k)
                c = c + 1
                continue
            end
            scripts:Run(name)
        end

        asset:WriteJSON("scripts", "autoexec.json", autoexec)

        scripts.autoexec = autoexec
    else
        asset:Write("scripts", "autoexec.json", "[]")
        scripts.autoexec = {}
    end
end)

function scripts:AddToAutoExec(name, index)
    local autoexec = self.autoexec
    if not asset:IsFile("scripts", name) then return end
    if index > #autoexec then
        index = #autoexec+1
    end
    table.insert(autoexec, index, name)
    asset:WriteJSON("scripts", "autoexec.json", autoexec)
end

function scripts:RemoveFromAutoExec(name)
    local autoexec = self.autoexec
    for i=1, #autoexec do
        local v = autoexec[i]
        if v == name then
            table.remove(autoexec, i)
            break
        end
    end
    asset:WriteJSON("scripts", "autoexec.json", autoexec)
end

-- get's a script from with-in bitchbot/[gamehere]/scripts/*
function scripts:Get(name)
    if asset:IsFile("scripts", name) then
        return asset:Read("scripts", name)
    end
end

function scripts:GetAll(path)
    local files = asset:ListFiles("scripts", path)
    local c = 0
    for i=1, #files do
        local v = files[i-c]
        if asset:GetExtension(v) ~= ".lua" then
            table.remove(files, i-c)
            c=c+1
        end
    end
    return files
end

-- runs it? duh?
function scripts:Run(name)
    if asset:IsFile("scripts", name) then
        if self.registry[name] then
            log(LOG_WARN, "Script \"" .. name .. "\" is already running! Attempting unload...")
            hook:CallP(name .. ".Unload")
            log(LOG_NORMAL, "Re-running script -> " .. name)
        else
            log(LOG_NORMAL, "Running script -> " .. name)
        end
        local script = asset:Read("scripts", name)
        local func, err = loadstring(self.pre_run .. script)
        if not func then
            local msg = "An error occured executing script \"" .. name .. "\",\n" .. (err or "Unknown Error!")
            log(LOG_ERROR, msg)
            BBOT.notification:Create(msg, 20):SetType("error")
            self.registry[name] = {callback = func, state = "Compile Error"}
            hook:CallP("Scripts.Run", name, func, "Compile Error")
            return
        end
        setfenv(func, getfenv())
        local ran, err = xpcall(func, debug.traceback, BBOT, name) -- i forgot what to do here
        if not ran then
            hook:CallP(name .. ".Unload")
            local msg = "An error occured running script \"" .. name .. "\",\n" .. (err or "Unknown Error!")
            log(LOG_ERROR, msg)
            BBOT.notification:Create(msg, 20):SetType("error")
            self.registry[name] = {callback = func, state = "Execution Error"}
            hook:CallP("Scripts.Run", name, func, "Execution Error")
            return
        end
        BBOT.notification:Create("Executed script " .. name)
        self.registry[name] = {callback = func, state = "Running"}
        hook:CallP("Scripts.Run", name, func, "Running")
    end
end

function scripts:GetState(name)
    return (self.registry[name] ~= nil and self.registry[name].state or "Idle")
end

function scripts:IsAutoExec(name)
    local autoexec = self.autoexec
    for i=1, #autoexec do
        local v = autoexec[i]
        if v == name then
            return i
        end
    end
end

function scripts:Unload(name)
    if self.registry[name] then
        hook:CallP(name .. ".Unload")
        BBOT.notification:Create("Unloaded script " .. name)
        hook:CallP("Scripts.Unload", name)
        self.registry[name] = nil
    end
end

hook:Add("Unload", "BBOT:Scripts.Unload", function()
    for name, data in next, scripts.registry do
        hook:CallP(name .. ".Unload")
    end
end)

return scripts