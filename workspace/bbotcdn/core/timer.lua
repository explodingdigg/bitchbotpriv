local loop = BBOT.loop
local log = BBOT.log
local timer = {
    registry = {}
}

function timer:Get(ident)
    local reg = self.registry
    for i=1, #reg do
        if reg[i].identifier == ident then
            return reg[i], i
        end
    end
end

timer.ToCreate = {}
function timer:Create(ident, delay, reps, func)
    self:Remove(ident)

    if self.incalls then
        self.ToCreate[#self.ToCreate+1] = {ident, delay, reps, func}
    else
        local reg = self.registry
        local index = #reg+1
        reg[index] = {
            identifier = ident,
            delay = delay,
            repetitions = reps,
            callback = func,
            ticks = tick(),
            timesran = 0,
            paused = false
        }
    end
end

timer.ToRemove = {}
function timer:Remove(identifier)
    if self.incalls then
        self.ToRemove[#self.ToRemove+1] = identifier
    else
        local t, index = timer:Get(identifier)
        if t then
            table.remove(timer.registry, index)
        end
    end
end

local T_Simple = 0
function timer:Simple(delay, func)
    self:Create("__T_Simple" .. T_Simple, delay, 1, func)
    T_Simple = T_Simple + 1
end

function timer:Adjust(ident, delay, repetitions, func)
    local t = self:Get(ident)
    if not t then return end
    t.delay = t.delay or delay
    t.repetitions = t.repetitions or repetitions
    t.callback = t.callback or func
end

function timer:Exists(ident)
    return self:Get(ident) ~= nil
end

function timer:Pause(ident)
    local t = self:Get(ident)
    if not t then return end
    t.paused = tick()
end

function timer:UnPause(ident)
    local t = self:Get(ident)
    if not t then return end
    t.paused = false
end

function timer:Start(ident)
    local t = self:Get(ident)
    if not t then return end
    t.ticks = tick()
    t.paused = false
end

function timer:Stop(ident)
    local t = self:Get(ident)
    if not t then return end
    t.paused = tick()
    t.ticks = t.paused
end

function timer:Toggle(ident)
    local t = self:Get(ident)
    if not t then return end
    if t.paused then
        t.paused = false
    else
        t.paused = tick()
    end
end

function timer:TimeLeft(ident)
    local t = self:Get(ident)
    if not t then return end
    return (t.ticks + t.delay - tick())
end

function timer:RepsLeft(ident)
    local t = self:Get(ident)
    if not t then return end
    return t.repetitions - t.timesran
end

function timer:Async(f)
    self:Simple(0,f)
end

function timer:Step()
    local c, ticks, timers = 0, tick(), self.registry

    self.incalls = true
    for i=1, #timers do
        local v = timers[i-c]
        if v.paused then
            v.ticks = (v.paused - ticks) + ticks
        else
            if v.ticks + v.delay < ticks then
                v.timesran = v.timesran + 1
                local ran, err = xpcall(v.callback, debug.traceback)
                if ran then
                    v.ticks = ticks
                    if v.repetitions > 0 and v.timesran >= v.repetitions then
                        table.remove(timers, i-c)
                        c = c + 1
                    end
                else
                    log(LOG_ERROR, "Error in timer library! - ", err)
                    table.remove(timers, i-c)
                    c = c + 1
                    if (BBOT.notification) then
                        BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in timer library.\nPlease check Synapse console!", 30):SetType("error")
                    end
                end
            end
        end
    end
    self.incalls = false
    
    for i=1, #self.ToRemove do
        local t, index = self:Get(self.ToRemove[i])
        if t then
            table.remove(self.registry, index)
            log(LOG_DEBUG, "Removed timer '" .. t.identifier .. "'")
        end
    end
    
    self.ToRemove = {}
    
    for i=1, #self.ToCreate do
        self:Create(unpack(self.ToCreate[i]))
    end
    
    self.ToCreate = {}
end

local runservice = BBOT.service:GetService("RunService")
loop:Run("BBOT:Timer.Step", function()
    timer:Step()
end)

return timer