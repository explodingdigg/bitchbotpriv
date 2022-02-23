local hook = BBOT.hook
local service = BBOT.service
local asset = BBOT.asset
local loop = BBOT.loop
local log = BBOT.log
local statistics = {
    registry = {}
}

function statistics:Read()
    if asset:IsFile("data", self.path) then
        self.registry = asset:ReadJSON("data", self.path)
    end
end

function statistics:Write()
    asset:WriteJSON("data", self.path, self.registry)
end

function statistics:Initialize()
    self.game = BBOT.game
    self.session = BBOT.account

    self.path = self.session.."/statistics.json"
    asset:MakeFolder("data", self.session)

    self:Read()
end

function statistics:Create(Id, default)
    if self.registry[Id] then
        local data = self.registry[Id]
        if typeof(data) ~= typeof(default) then
            self.registry[Id] = default
        elseif typeof(default) == "table" then
            for k, v in pairs(default) do
                if data[k] == nil then
                    data[k] = v
                end
            end
            for k, v in pairs(data) do
                if default[k] == nil then
                    data[k] = nil
                end
            end
        end
    else
        self.registry[Id] = (default ~= nil and default or {})
    end
    self.modified = true
end

function statistics:Get(Id)
    return self.registry[Id] or {}
end

function statistics:Set(Id, new)
    self.modified = true
    if new == nil then return end
    self.registry[Id] = new
end

function statistics:Save()
    self.modified = false
    asset:WriteJSON("data", self.path, self.registry)
end

loop:Run("Statistics.Save", function(statistics)
    if not statistics.modified then return end
    statistics:Save()
end, 0.1, statistics)

hook:Add("PostStartup", "BBOT:Statistics.Initialize", function()
    statistics:Initialize()
end)

return statistics