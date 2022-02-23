local service = {
    registry = {}
}

function service:GetService(name)
    local services = self.registry
    if not services[name] then
        services[name] = game:GetService(name)
    end
    return services[name]
end

function service:AddToServices(name, service)
    self.registry[name] = service
end

local localplayer = service:GetService("Players").LocalPlayer
service:AddToServices("LocalPlayer", localplayer)
service:AddToServices("CurrentCamera", service:GetService("Workspace").CurrentCamera)
service:AddToServices("PlayerGui", localplayer:FindFirstChild("PlayerGui") or localplayer:WaitForChild("PlayerGui"))
service:AddToServices("Mouse", localplayer:GetMouse())

return service