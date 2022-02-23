local hook = BBOT.hook
local config = BBOT.config
local sound = BBOT.aux.sound
local table = BBOT.table
local string = BBOT.string
local asset = BBOT.asset
local cache = {
    ["Headshot Kill"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Headshot Kill") or ""),
    ["Kill"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Kill") or ""),
    ["Headshot"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Headshot") or ""),
    ["Hit"] = "rbxassetid://" .. (config:GetValue("Main", "Misc", "Sounds", "Hit") or ""),
    ["Fire"] = "",
}

hook:Add("OnConfigChanged", "BBOT:Sounds.Cache", function(path, old, new)
    local final = path[#path]
    local cacheid = cache[final]
    if cacheid and config:IsPathwayEqual(path, "Main", "Misc", "Sounds", final) then
        if new ~= "" and asset:IsFolder("sounds", new) then
            local o = cache[final]
            local files = {}
            local list = asset:ListFiles("sounds", new)
            for i=1, #list do
                files[#files+1] = asset:GetAsset("sounds", list[i])
            end
            cache[final] = table.fyshuffle(files)
        elseif asset:IsFile("sounds", new) then
            cache[final] = asset:GetAsset("sounds", new)
        else
            local snd = (new or "")
            if snd == "" then
                cache[final] = ""
            elseif snd:match("%a") then
                cache[final] = snd
            else
                cache[final] = "rbxassetid://" .. snd
            end
        end
    end
end)

local position = 0
local function play_sound(name, ...)
    if name == "" then return end
    local soundid = cache[name]
    if soundid == "" then return end
    if typeof(soundid) == "table" then
        position = position + 1
        local ssound = soundid[position]
        if not ssound then
            soundid = table.fyshuffle( soundid )
            position = 1
            ssound = soundid[1]
            cache[name] = soundid
        end
        sound.playid(ssound, ...)
    elseif string.find(soundid, "rbxasset", 1, true) then
        sound.playid(soundid, ...)
    end
    return true
end

hook:Add("SuppressSound", "BBOT:Sounds.Overrides", function(soundname, ...)
    if soundname == "headshotkill" then
        return play_sound("Headshot Kill", config:GetValue("Main", "Misc", "Sounds", "Headshot Kill Volume")/100)
    end
    if soundname == "killshot" then
        return play_sound("Kill", config:GetValue("Main", "Misc", "Sounds", "Kill Volume")/100)
    end
    if soundname == "hitmarker" and (cache["Headshot"] ~= "" or cache["Hit"] ~= "") then
        return true
    end
end)

hook:Add("WeaponModifyData", "BBOT:Sounds.Override", function(gundata)
    local snd = cache["Fire"]
    if snd ~= "" then
        gundata.firevolume = 0
    end
    --[[local snd = cache["Fire"]
    if snd ~= "" then
        gundata.firesoundid = snd
        gundata.firepitch = nil
    end
    local vol = config:GetValue("Main", "Misc", "Sounds", "Fire Volume")/100
    if vol < 1 then
        gundata.firevolume = vol
    end]]
end)

hook:Add("PostNetworkSend", "BBOT:Sounds.Kills", function(netname, Entity, HitPos, Part, bulletID)
    if netname == "newbullets" then
        local gun = BBOT.aux.gamelogic.currentgun
        if gun and gun.data and gun.data.barrel then
            play_sound("Fire", config:GetValue("Main", "Misc", "Sounds", "Fire Volume")/100, nil, gun.data.barrel)
        end
    elseif netname == "bullethit" then
        if Part == "Head" then
            play_sound("Headshot", config:GetValue("Main", "Misc", "Sounds", "Headshot Volume")/100)
        else
            play_sound("Hit", config:GetValue("Main", "Misc", "Sounds", "Hit Volume")/100)
        end
    end
end)