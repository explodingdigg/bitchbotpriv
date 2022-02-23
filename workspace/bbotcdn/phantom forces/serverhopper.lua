local config = BBOT.config
local hook = BBOT.hook
local votekick = BBOT.votekick
local log = BBOT.log
local timer = BBOT.timer
local table = BBOT.table
local notification = BBOT.notification
local statistics = BBOT.statistics
local asset = BBOT.asset
local TeleportService = game:GetService("TeleportService")
local localplayer = BBOT.service:GetService("LocalPlayer")
local httpservice = BBOT.service:GetService("HttpService")
local serverhopper = {}

statistics:Create("serverhopper", {
    redirects = 0,
    interacted = {}
})

serverhopper.file = "server-blacklist.json"
serverhopper.blacklist = {}
serverhopper.UserId = tostring(localplayer.UserId)

hook:Add("PostInitialize", "BBOT:ServerHopper.Load", function()
    if asset:IsFile("data", serverhopper.file) then
        serverhopper.blacklist = asset:ReadJSON("data", serverhopper.file) or {}
        local otime = os.time()
        for _, userblacklist in pairs(serverhopper.blacklist) do
            for k, v in pairs(userblacklist) do
                if otime > v then
                    userblacklist[k] = nil
                    log(LOG_NORMAL, "Removed server-hop blacklist " .. k)
                end
            end
        end
        asset:WriteJSON("data", serverhopper.file, serverhopper.blacklist)
        local plbllist = serverhopper.blacklist[serverhopper.UserId]
        if plbllist then
            local c = 0
            for k, v in pairs(plbllist) do
                c = c + 1
            end
            --BBOT.chat:Message("You have been votekicked from " .. c .. " server(s)!")
            log(LOG_NORMAL, "You have been votekicked from " .. c .. " server(s)!")
            notification:Create("You have been votekicked from " .. c .. " server(s)!")
        end
    end
end)

function serverhopper:ClearBlacklist()
    serverhopper.blacklist = {}
    asset:WriteJSON("data", serverhopper.file, serverhopper.blacklist)
    notification:Create("Server hop blacklist cleared!")
end

function serverhopper:IsBlacklisted(id)
    local plbllist = serverhopper.blacklist[self.UserId]
    if plbllist and plbllist[id] then
        return true
    end
end

function serverhopper:RandomHop()
    local delay = config:GetValue("Main", "Misc", "Server Hopper", "Hop Delay")
    if delay > 0 then
        notification:Create("Hopping in " .. delay .. "s")
    end
    timer:Simple(delay, function()
        log(LOG_NORMAL, "Commencing Server-Hop...")
        local data = httpservice:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
        local mode = config:GetValue("Main", "Misc", "Server Hopper", "Sort By")
        if mode == "Highest Players" then
            table.sort(data, function(a, b) return a.playing > b.playing end)
        elseif mode == "Lowest Players" then
            table.sort(data, function(a, b) return a.playing < b.playing end)
        else
            data = table.fyshuffle(data)
        end
        for _, s in pairs(data) do
            local id = s.id
            if not serverhopper:IsBlacklisted(id) and id ~= game.JobId then
                if s.playing < s.maxPlayers then
                    --syn.queue_on_teleport(<string> code)
                    log(LOG_NORMAL, "Hopping to server Id: " .. id .. "; Players: " .. s.playing .. "/" .. s.maxPlayers .. "; " .. s.ping .. " ms")
                    notification:Create("Hopping to new server -> Players: " .. s.playing .. "/" .. s.maxPlayers)
                    timer:Simple(1, function()
                        local data = statistics:Get("serverhopper")
                        data.redirects = data.redirects + 1
                        if data.interacted[id] then
                            data.interacted[id] = data.interacted[id] + 1
                        else
                            data.interacted[id] = 1
                        end
                        statistics:Save()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, id)
                        local connection
                        connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
                            connection:Disconnect()
                            data.redirects = data.redirects - 1
                            if data.interacted[id] then
                                data.interacted[id] = data.interacted[id] - 1
                            else
                                data.interacted[id] = 0
                            end
                            statistics:Save()
                        end)
                    end)
                    return
                end
            end
        end
        log(LOG_ERROR, "No servers to hop towards... Wow... You really got votekicked off every server now did ya? Impressive...")
    end)
end

function serverhopper:AddToBlacklist(id, removaltime)
    self.blacklist = asset:ReadJSON("data", self.file) or self.blacklist
    local plbllist = self.blacklist[self.UserId]
    if not plbllist then
        plbllist = {}
        self.blacklist[self.UserId] = plbllist
    end
    plbllist[id] = (removaltime and removaltime + os.time() or -1)
    asset:WriteJSON("data", serverhopper.file, serverhopper.blacklist)
    log(LOG_NORMAL, "Added " .. game.JobId .. " to server-hop blacklist")
    notification:Create("Added " .. game.JobId .. " to server-hop blacklist")
end

function serverhopper:Hop(id)
    log(LOG_NORMAL, "Hopping to server " .. id)
    if serverhopper:IsBlacklisted(id) then
        log(LOG_NORMAL, "This server ID is blacklisted! Where you votekicked from here?")
        notification:Create("This server Id (" .. id .. ") is blacklisted! Where you votekicked from here?")
        return
    end
    local data = statistics:Get("serverhopper")
    data.redirects = data.redirects + 1
    if data.interacted[id] then
        data.interacted[id] = data.interacted[id] + 1
    else
        data.interacted[id] = 1
    end
    statistics:Save()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, id)
    local connection
    connection = TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
        connection:Disconnect()
        data.redirects = data.redirects - 1
        if data.interacted[id] then
            data.interacted[id] = data.interacted[id] - 1
        else
            data.interacted[id] = 0
        end
        statistics:Save()
    end)
end

BBOT.chat:AddCommand("hop", function(id)
    if not config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
        notification:Create("Cannot hop servers due to unsafe features being disabled!\n[Note: This feature is detected!]")
        return
    end
    if not id or id == "" then
        serverhopper:RandomHop()
        return
    end
    serverhopper:Hop(id)
end, "Hops to a server instance.")

BBOT.chat:AddCommand("blacklist", function(id)
    if not id or id == "" then
        return
    end
    serverhopper:AddToBlacklist(id, 86400)
end, "Adds a server instance to the blacklist.")

BBOT.chat:AddCommand("rejoin", function()
    if not config:GetValue("Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") then
        notification:Create("Cannot hop servers due to unsafe features being disabled!\n[Note: This feature is detected!]")
        return
    end
    BBOT.serverhopper:Hop(game.JobId)
end, "Rejoin the current server instance.")

local autohop = nil
hook:Add("InternalMessage", "BBOT:ServerHopper.HopOnKick", function(message)
    if not string.find(message, "Server Kick Message:", 1, true) or not string.find(message, "votekicked", 1, true) then return end
    if not serverhopper:IsBlacklisted(game.JobId) then
        serverhopper:AddToBlacklist(game.JobId, 86400)
    end
    if not config:GetValue("Main", "Misc", "Server Hopper", "Hop On Kick") then return end
    autohop = 0
end)

hook:Add("RenderStepped", "BBOT:ServerHopper.HopOnKick", function()
    if not autohop or autohop > tick() then return end
    serverhopper:RandomHop()
    autohop = tick() + 3
end)

hook:Add("OnKeyBindChanged", "BBOT:ServerHopper.Hop", function(steps)
    if config:IsPathwayEqual(steps, "Main", "Misc", "Server Hopper", "Hop On Kick", "Force Server Hop") and config:GetValue("Main", "Misc", "Server Hopper", "Hop On Kick") then
        serverhopper:RandomHop()
    end
end)

return serverhopper