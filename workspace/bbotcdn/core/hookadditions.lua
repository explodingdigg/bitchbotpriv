-- From wholecream
-- If you find that you need to make another connection, do add it here with a hook
-- You never know if your gonna need to reuse it either way...
local hook = BBOT.hook
local service = BBOT.service
local localplayer = service:GetService("LocalPlayer")
local runservice = service:GetService("RunService")
local userinputservice = service:GetService("UserInputService")
local mouse = service:GetService("Mouse")
hook:Add("Unload", "Unload", function() -- Reloading the cheat? no problem.
    -- disconnect all rbx based connections
    local connections = hook.connections
    for i=1, #connections do
        connections[i]:Disconnect()
    end
    hook.connections = {}
    
    -- restore all hookfunction connections
    local bindings = hook.bindings
    for i=1, #bindings do
        restorefunction(bindings[i][2])
    end
    hook.bindings = {}

    -- assign a killed action to coroutine wrappers
    hook.killed = true

    -- wait and kill entire hook library
    coroutine.wrap(function()
        task.wait(1)
        hook.registry = {}
        hook._registry_qa = {}
    end)()
end)


hook:bindEvent(userinputservice.InputBegan, "InputBegan")
hook:bindEvent(userinputservice.InputEnded, "InputEnded")

local isholdingmouse1, isholdingmouse2 = false, false
hook:Add("InputBegan", "InputBegan", function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isholdingmouse1 = true
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        isholdingmouse2 = true
    end
end)

hook:Add("InputEnded", "InputEnded", function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isholdingmouse1 = false
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        isholdingmouse2 = false
    end
end)

function hook:IsMouse1Down()
    return isholdingmouse1
end

function hook:IsMouse2Down()
    return isholdingmouse2
end

local lastMousePos = Vector2.new()
hook:Add("RenderStepped", "Mouse.Move", function()
    local x, y = mouse.X, mouse.Y
    hook:Call("Mouse.Move", lastMousePos ~= Vector2.new(x, y), x, y)
    lastMousePos = Vector2.new(x, y)
end)

hook:bindEvent(userinputservice.InputChanged, "InputChanged")

hook:Add("InputChanged", "InputChanged", function(userinput)
    if userinput.UserInputType.Name == "MouseMovement" then
        hook:Call("Mouse.OnMove", userinput.Delta)
    end
end)

local camera = service:GetService("CurrentCamera")
local vport = camera.ViewportSize
hook:Add("RenderStepped", "ViewportSize.Changed", function()
    if camera.ViewportSize ~= vport then
        vport = camera.ViewportSize
        hook:Call("Camera.ViewportChanged", vport)
    end
end)

hook:bindEvent(mouse.WheelForward, "WheelForward")
hook:bindEvent(mouse.WheelBackward, "WheelBackward")

hook:bindEvent(runservice.Stepped, "Stepped")
hook:bindEvent(runservice.Heartbeat, "Heartbeat")
hook:bindEvent(runservice.RenderStepped, "RenderStepped")

local players = service:GetService("Players")
hook:bindEvent(players.PlayerAdded, "PlayerAdded")
hook:bindEvent(players.PlayerRemoving, "PlayerRemoving")
hook:bindEvent(localplayer.Idled, "LocalPlayer.Idled")

BBOT.renderstepped_rate = 0
hook:Add("RenderStepped", "BBOT:Internal.Framerate", function(rate)
    BBOT.renderstepped_rate = rate
end)