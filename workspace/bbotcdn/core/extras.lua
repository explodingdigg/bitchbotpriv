local hook = BBOT.hook
local extras = {}

local PingStat = BBOT.service:GetService("Stats").PerformanceStats.Ping
local current_latency = 0
hook:Add("RenderStepped", "BBOT:extras.getlatency", function()
    current_latency = PingStat:GetValue() / 1000
end)

function extras:getLatency()
    return current_latency
end

return extras