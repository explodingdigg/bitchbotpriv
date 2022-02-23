local statistics = BBOT.statistics
local hook = BBOT.hook

statistics:Create("stats", {
    kills = 0,
    deaths = 0,
    killed = {},
})

hook:Add("PreBigAward", "BBOT:Statistics.Kills", function(type, entity, gunname, earnings)
    local name = tostring(entity.Name)
    local stats = statistics:Get("stats")
    stats.kills = stats.kills + 1
    if not stats.killed[name] then
        stats.killed[name] = 0
    end
    stats.killed[name] = stats.killed[name] + 1
    statistics:Set("stats")
end)

hook:Add("LocalKilled", "BBOT:Statistics.Deaths", function(player)
    local stats = statistics:Get("stats")
    stats.deaths = stats.deaths + 1
    statistics:Set("stats")
end)