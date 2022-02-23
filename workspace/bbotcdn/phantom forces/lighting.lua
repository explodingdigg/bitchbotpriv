local math = BBOT.math
local color = BBOT.color
local vector = BBOT.vector
local config = BBOT.config
local hook = BBOT.hook
local timer = BBOT.timer
local loop = BBOT.loop
local lighting = {}

function lighting.step()
    if not game.Lighting then return end
    if config:GetValue("Main", "Visuals", "World", "Force Time") then
        game.Lighting.ClockTime = config:GetValue("Main", "Visuals", "World", "Custom Time")
    end

    if config:GetValue("Main", "Visuals", "World", "Ambience") then
        game.Lighting.Ambient = config:GetValue("Main", "Visuals", "World", "Ambience", "Inside Ambience")
        game.Lighting.OutdoorAmbient = config:GetValue("Main", "Visuals", "World", "Ambience", "Outside Ambience")
    else
        game.Lighting.Ambient = game.Lighting.MapLighting.Ambient.Value
        game.Lighting.OutdoorAmbient = game.Lighting.MapLighting.OutdoorAmbient.Value
    end

    --[[if config:GetValue("Main", "Visuals", "World", "Specular") then
        game.Lighting.EnvironmentSpecularScale = config:GetValue("Main", "Visuals", "World", "Specular Scale")/100
    end]]
    
    --[[if config:GetValue("Main", "Visuals", "World", "Custom Saturation") and game.Lighting.MapSaturation then
        game.Lighting.MapSaturation.TintColor = config:GetValue("Main", "Visuals", "World", "Custom Saturation", "Saturation Tint")
        game.Lighting.MapSaturation.Saturation = config:GetValue("Main", "Visuals", "World", "Saturation Density") / 50
    end]]
end

local runservice = BBOT.service:GetService("RunService")
loop:Run("BBOT:Lighting.Step", lighting.step, runservice.RenderStepped)

return lighting