local log = BBOT.log
local hook = BBOT.hook
local loop = {
    registry = {}
}
hook:Add("Unload", "KillLoops", function()
    loop:KillAll()
end)
function loop:KillAll()
    local tbl = self:GetTable()
    for k, v in pairs(tbl) do
        self:Stop(k)
    end
end
function loop:IsRunning(name)
    return self.registry[name].running
end
function loop:Create(name, func, waitt, ...)
    local loops = self.registry
    if loops[name] ~= nil then return end

    log(LOG_DEBUG, 'Creating loop "' .. name .. '"')
    if not waitt then waitt = 1 end
    local isuserdata = (type(waitt) == "userdata")

    loops[name] = {
        running = false,
        destroy = false,
        varargs = {...},
        Loop = coroutine.create(function(...)
            local loop_data = loops[name]
            while true do
                if loop_data.running then
                    local ran, err = xpcall(func, debug.traceback, ...)
                    if not ran then
                        loops[name].destroy = true
                        log(LOG_ERROR, "Error in loop library - " .. tostring(name), err)
                        if (BBOT.notification) then
                            BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in loop library.\nPlease check Synapse console!", 30):SetType("error")
                        end
                        break
                    end
                end
                if loop_data.destroy then break end
                if isuserdata then
                    waitt:wait()
                else
                    task.wait(waitt)
                end
            end
        end)
    }
end
function loop:Run(name, func, waitt, ...)
    local loops = self.registry
    if loops[name] == nil then
        if func ~= nil then
            self:Create(name, func, waitt, ...)
        end
    end
    
    log(LOG_DEBUG, 'running loop "' .. name .. '"')

    loops[name].running = true
    local succ, out = coroutine.resume(loops[name].Loop, unpack(loops[name].varargs))
    if not succ then
        log(LOG_ERROR, "Error in loop library - " .. tostring(name) .. "\n" .. tostring(out))
        if (BBOT.notification) then
            BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in timer library.\nPlease check Synapse console!", 30):SetType("error")
        end
    end
end
function loop:Stop(name)
    local loops = self.registry
    if loops[name] == nil then return end

    log(LOG_DEBUG, 'Stopping loop "' .. name .. '"')

    loops[name].running = false
end
function loop:Remove(name)
    local loops = self.registry
    if loops[name] == nil then return end
    self:Stop(name)
    log(LOG_DEBUG, 'Removing loop "' .. name .. '"')
    loops[name].destroy = true
    loops[name] = nil
end
function loop:GetTable()
    return self.registry
end
return loop