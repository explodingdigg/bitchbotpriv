local config = BBOT.config
local hook = BBOT.hook
local timer = BBOT.timer
local math = BBOT.math
local notification = BBOT.notification
local table = BBOT.table
local statistics = BBOT.statistics
local hud = BBOT.aux.hud
local playerdata = BBOT.aux.playerdata
local char = BBOT.aux.char
local localplayer = BBOT.service:GetService("LocalPlayer")
local votekick = {}
BBOT.votekick = votekick
votekick.CallDelay = 90
votekick.NextCall = 0
votekick.Called = 3

statistics:Create("votekick", {
    calls = 0,
    kicks = 0,
    kicked = {}
})

do
    local startvotekick_netindex
    local receivers = BBOT.aux.network.receivers
    for netindex, callback in pairs(receivers) do
        local consts = debug.getconstants(callback)
        for i=1, #consts do
            local vv = consts[i]
            if typeof(vv) == "string" and string.find(vv, "Votekick", 1, true) then
                startvotekick_netindex = netindex
                function votekick:GetVotes()
                    return debug.getupvalue(callback, 9)
                end
            end
        end
    end

    hook:Add("PostNetworkReceive", "BBOT:Votekick.Network", function(netname, ...)
        if netname == startvotekick_netindex then
            hook:Call("Votekick.Start", ...)
        end
    end)
end

local invote = false
hook:Add("Votekick.Start", "Votekick.Start", function(target, delay, votesrequired)
    delay = tonumber(delay)
    timer:Create("Votekick.Tick", delay, 1, function()
        hook:Remove("RenderStepped", "Votekick.Step")
        hook:Call("Votekick.End", target, delay, votesrequired, false)
    end)
    hook:Add("RenderStepped", "Votekick.Step", function()
        if votekick:GetVotes() >= votesrequired then
            hook:Remove("RenderStepped", "Votekick.Step")
            timer:Remove("Votekick.Tick")
            hook:Call("Votekick.End", target, delay, votesrequired, true)
        end
    end)
    if config:GetValue("Main", "Misc", "Votekick", "Anti Votekick") then
        timer:Simple(delay+2, function()
            votekick.called_user = nil
            votekick:RandomCall()
        end)
    end

    if target == localplayer.Name then
        timer:Simple(.5, function() hud:vote("no") end)
    end

    invote = votesrequired
    notification:Create("Votekick called on " .. target .. "; time till end: " .. delay .. "; votes required: " .. votesrequired)
    if votekick.Called == 1 then
        votekick.Called = 2
        votekick.NextCall = tick() + votekick.CallDelay + delay
    elseif votekick.Called == 2 or votekick.Called == 0 then
        votekick.Called = 3
        votekick.called_user = nil
        votekick.NextCall = tick() + votekick.CallDelay + delay
    end
end)

hook:Add("Console", "BBOT:Votekick.AntiVotekick", function(msg)
    if string.find(msg, "has been kicked out", 1, true) then
        if votekick.called_user then
            local data = statistics:Get("votekick")
            data.kicks = data.kicks + 1
            if data.kicked[votekick.called_user] then
                data.kicked[votekick.called_user] = data.kicked[votekick.called_user] + 1
            else
                data.kicked[votekick.called_user] = 1
            end
            statistics:Set("votekick")
        end
        votekick.called_user = nil
    elseif string.find(msg, "The last votekick was initiated by you", 1, true) then
        if votekick.NextCall <= tick() then
            votekick.Called = 2
            votekick.called_user = nil
            BBOT.menu:UpdateStatus("Anti-Votekick", "!!! Kickable !!! (Unknown duration)")
        end
    elseif string.find(msg, "seconds before initiating a votekick", 1, true) then
        votekick.Called = 0
        votekick.called_user = nil
        votekick.NextCall = tick() + (tonumber(string.match(msg, "%d+")) or 0)-(.5+BBOT.extras:getLatency())
    end
end)

function votekick:IsVoteActive()
    return debug.getupvalue(BBOT.aux.hud.votestep, 2)
end

local players = BBOT.service:GetService("Players")
function votekick:GetTargets()
    local targetables = {}
    for i, v in pairs(players:GetPlayers()) do
        local inpriority = config:GetPriority(v)
        if (not inpriority or inpriority >= 0) and v ~= localplayer then
            targetables[#targetables+1] = v
        end
    end
    return targetables
end

function votekick:CanCall(target, reason)
    if self:IsVoteActive() then return false, "VoteActive" end
    if self.NextCall > tick() or (self.Called > 0 and self.Called < 3) then return false, "RateLimit" end
    return true
end

function votekick:Call(target, reason)
    BBOT.chat:Say("/votekick:"..target..":"..reason)
    local data = statistics:Get("votekick")
    data.calls = data.calls + 1
    statistics:Set("votekick")
    self.called_user = target
    if self.Called ~= 2 and self.NextCall <= tick() then
        self.Called = 1
        self.NextCall = 0
        BBOT.menu:UpdateStatus("Anti-Votekick", "Server response...")
    end
end

function votekick:RandomCall()
    local targets = votekick:GetTargets()
    local target = table.fyshuffle(targets)[1]
    votekick:Call(target.Name, config:GetValue("Main", "Misc", "Votekick", "Reason"))
end

local totalkills = 0
hook:Add("PreBigAward", "BBOT:Votekick.Kills", function()
    totalkills = totalkills + 1
end)

hook:Add("OnConfigChanged", "BBOT:Votekick.AntiVotekick", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Misc", "Votekick", "Anti Votekick") then
        if playerdata.rankcalculator(playerdata:getdata().stats.experience) < 25 then
            BBOT.menu:UpdateStatus("Anti-Votekick", "Rank 25 required", new)
        else
            local state = BBOT.menu:GetStatus("Anti-Votekick")
            BBOT.menu:UpdateStatus("Anti-Votekick", (state and state[2] or "Waiting..."), new)
        end
    end
end)

function votekick:IsCalling()
    if not config:GetValue("Main", "Misc", "Votekick", "Anti Votekick") then return end
    if not votekick.WasAlive then return end
    if playerdata.rankcalculator(playerdata:getdata().stats.experience) < 25 then return end
    if votekick.Called == 3 or votekick.Called == 0 then
        return votekick.NextCall-tick()
    end
end

hook:Add("OnConfigOpened", "BBOT:Votekick.AntiVotekick", function()
    votekick.WasAlive = false
end)

local hop_called = 0
hook:Add("RenderStepped", "BBOT:Votekick.AntiVotekick", function()
    if not config:GetValue("Main", "Misc", "Votekick", "Anti Votekick") then return end
    if char.alive == true then
        votekick.WasAlive = true
    end
    if not votekick.WasAlive then return end
    if playerdata.rankcalculator(playerdata:getdata().stats.experience) < 25 then return end
    if votekick.Called == 3 or votekick.Called == 0 then
        local t = votekick.NextCall-tick()
        if t < 0 then
            BBOT.menu:UpdateStatus("Anti-Votekick", "Waiting for server...")
        else
            BBOT.menu:UpdateStatus("Anti-Votekick", "Calling in " .. math.round(votekick.NextCall-tick()) .. "s")
        end
    elseif votekick.Called == 2 then
        local t = votekick.NextCall-tick()
        local amount = ""
        for i=1, math.round(tick()%4) do
            amount = amount .. "!"
        end
        if t < 0 then
            BBOT.menu:UpdateStatus("Anti-Votekick", "Kickable" .. amount)
        else
            BBOT.menu:UpdateStatus("Anti-Votekick", "Kickable in " .. math.round(t) .. "s" .. (t < 15 and amount or ""))
        end

        if hop_called < tick() and config:GetValue("Main", "Misc", "Votekick", "Auto Hop") and config:GetValue("Main", "Misc", "Votekick", "Hop Trigger Time") > t then
            BBOT.serverhopper:RandomHop()
            hop_called = tick() + 1
        end
    end
    if votekick:CanCall() then
        local kills = config:GetValue("Main", "Misc", "Votekick", "Votekick On Kills")
        if kills == 0 or totalkills >= kills then
            votekick:RandomCall()
        elseif kills > 0 then
            BBOT.menu:UpdateStatus("Anti-Votekick", (kills - totalkills) .. " kills remaining")
        end
    end
end)

return votekick