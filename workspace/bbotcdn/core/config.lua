local hook = BBOT.hook
local table = BBOT.table
local string = BBOT.string
local timer = BBOT.timer
local asset = BBOT.asset
local userinputservice = BBOT.service:GetService("UserInputService")
local localplayer = BBOT.service:GetService("LocalPlayer")
local config = {
    registry = {}, -- storage of the current configuration
    enums = {}
}
config.storage_extension = ".json"

-- priorities are stored like so
-- ["player.UserId"] = -1 -> inf
-- -1 is friendly, > 0 is priority
config.priority = {}

function config:SetPriority(pl, level)
    local last = config:GetPriority(pl)
    local new = tonumber(level)
    self.priority[pl.UserId] = new
    asset:WriteJSON("data", "priorities.json", self.priority)
    hook:Call("OnPriorityChanged", pl, last, config:GetPriority(pl))
end

function config:GetPriority(pl)
    if not pl then return end
    if pl == localplayer then return 0 end
    local level, reason = 0, nil
    if self.priority[pl.UserId] then
        level = self.priority[pl.UserId]
        if level == nil then level = 0 end
        if level ~= 0 then
            return level, reason
        end
    end
    level, reason = hook:Call("GetPriority", pl)
    if level == nil then level = 0 end
    return level, reason
end

hook:Add("PlayerAdded", "BBOT:Configs.SetupPriority", function(pl)
    local priority = config:GetPriority(pl)
    if priority == 0 then return end
    hook:Call("OnPriorityChanged", pl, 0, priority)
end)

hook:Add("PostInitialize", "BBOT:Configs.SetupPriority", function()
    local players = BBOT.service:GetService("Players")
    for k, pl in next, players:GetPlayers() do
        local priority = config:GetPriority(pl)
        if priority == 0 then return end
        hook:Call("OnPriorityChanged", pl, 0, priority)
    end
end)

do -- key binds
    local enums = Enum.KeyCode:GetEnumItems()
    local enumstable, enumtoID, IDtoenum = {}, {}, {}
    for k, v in table.sortedpairs(enums) do
        local keyname = string.sub(tostring(v), 14)
        if not string.find( keyname, "World", 1, true ) then
            enumstable[#enumstable+1] = keyname
            enumtoID[keyname] = v
            IDtoenum[v] = keyname
        end
    end

    enumstable[#enumstable+1] = "MouseButton1"
    enumtoID["MouseButton1"] = Enum.UserInputType.MouseButton1
    IDtoenum[Enum.UserInputType.MouseButton1] = "MouseButton1"
    enumstable[#enumstable+1] = "MouseButton2"
    enumtoID["MouseButton2"] = Enum.UserInputType.MouseButton2
    IDtoenum[Enum.UserInputType.MouseButton2] = "MouseButton2"
    config.enums.KeyCode = {
        inverseId = IDtoenum,
        Id = enumtoID,
        List = enumstable
    }
end

do -- materials
    local mats, matstoid = {}, {}
    local enums = Enum.Material:GetEnumItems()
    for k, v in table.sortedpairs(enums) do
        local keyname = string.sub(tostring(v), 15)
        mats[#mats+1] = keyname
        matstoid[keyname] = v
    end

    config.enums.Material = {
        Id = matstoid,
        List = mats
    }
end

-- EX:
--[[
    hook:Add("OnConfigChanged", "BBOT:ChamsChanged", function(path, old, new)
        if config:IsPathwayEqual(path, "Visuals", "Chams") then
            chams:Rebuild()
        end
    end)
]]
function config:IsPathwayEqual(pathway, ...)
    local steps = {...}
    local isabsolute = steps[#steps]
    if isabsolute == true then
        for i=1, #steps-1 do
            if pathway[i] ~= steps[i] then
                return false
            end
        end
        if #pathway ~= #steps-1 then return false end
    else
        for i=1, #steps do
            if pathway[i] ~= steps[i] then
                return false
            end
        end
    end
    return true
end

function config:GetKeyID(...)
    local key = self:GetNormal(...)
    return config.enums.KeyCode.Id[key]
end

local userinputservice = BBOT.service:GetService("UserInputService")
function config:IsKeyDown(...)
    local keyid = self:GetKeyID(...)
    if not keyid then return false end

    if keyid == Enum.UserInputType.MouseButton1 or keyid == Enum.UserInputType.MouseButton2 then
        return userinputservice:IsMouseButtonPressed(keyid)
    end

    return userinputservice:IsKeyDown(keyid)
end

function config:InputIsKeyDown(input, ...)
    local keyid = self:GetKeyID(...)
    if not keyid then return false end

    if keyid == Enum.UserInputType.MouseButton1 or keyid == Enum.UserInputType.MouseButton2 then
        if input.UserInputType == keyid then
            return true
        end
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == keyid then
            return true
        end
    end
    return false
end

-- EX: config:GetValue("Aimbot", "Rage", "Silent Aim")
-- You can also return a raw table for easier iteration of data
local valuetypetoconfig = {
    ["KeyBind"] = function(reg)
        if reg.value ~= nil then
            return reg.toggle
        else
            return true
        end
    end,
    ["ComboBox"] = function(reg)
        local t, v = {}, reg.value
        for i=1, #v do local c = v[i]; t[c[1]] = c[2]; end
        return t
    end,
    ["ColorPicker"] = function(reg) return Color3.fromRGB(unpack(reg.value)), (reg.value[4]or 255)/255 end,
}

function config:GetValue(...)
    local steps = {...}
    local reg = self.registry
    for i=1, #steps do
        reg = reg[steps[i]]
        if reg == nil then break end
    end
    if reg == nil then return end
    if typeof(reg) == "table" then
        if reg.self ~= nil then
            local s = reg.self
            if typeof(s) == "table" and s.type and s.type ~= "Button" then
                local valuet = valuetypetoconfig[s.type]
                if valuet then
                    return valuet(s)
                end
                return s.value
            end
            return s
        end
        if reg.type and reg.type ~= "Button" then
            local valuet = valuetypetoconfig[reg.type]
            if valuet then
                return valuet(reg)
            end
            return reg.value
        end
    end
    return reg
end

function config:GetNormal(...)
    local steps = {...}
    local reg = self.registry
    for i=1, #steps do
        reg = reg[steps[i]]
        if reg == nil then break end
    end
    if reg == nil then return end
    if typeof(reg) == "table" then
        if reg.self ~= nil then
            local s = reg.self
            if typeof(s) == "table" and reg.type and reg.type ~= "Button" then
                return s.value
            end
            return s
        end
        if reg.type and reg.type ~= "Button" then
            return reg.value
        end
    end
    return reg
end

function config:GetRaw(...)
    local steps = {...}
    local reg = self.registry
    for i=1, #steps do
        reg = reg[steps[i]]
        if reg == nil then break end
    end
    if reg == nil then return end
    if typeof(reg) == "table" then
        if reg.self ~= nil then
            local s = reg.self
            if typeof(s) == "table" and reg.type and reg.type ~= "Button" then
                return s
            end
            return s
        end
        if reg.type and reg.type ~= "Button" then
            return reg
        end
    end
    return reg
end

-- EX: config:SetValue(true, "Aimbot", "Rage", "Silent Aim")
function config:SetValue(value, ...)
    local steps = {...}
    local reg, len = self.registry, #steps
    for i=1, len-1 do
        reg = reg[steps[i]]
        if reg == nil then break end
    end
    local final = steps[len]
    if reg[final] == nil then return false end
    local old = reg[final]
    if typeof(old) == "table" then
        if old.self ~= nil then
            local o = old.self
            if typeof(o) == "table" then
                if o.type and o.type ~= "Button" then
                    local oo = o.value
                    o.value = value
                    hook:Call("OnConfigChanged", steps, oo, value)
                end
            else
                old.self = value
                hook:Call("OnConfigChanged", steps, o, value)
            end
        elseif old.type and old.type ~= "Button" then
            local o = old.value
            old.value = value
            hook:Call("OnConfigChanged", steps, o, value)
        end
        return true
    end
    reg[final] = value
    hook:Call("OnConfigChanged", steps, old, value)
    return true
end

-- Habbit, fuck off.
function config:GetTable()
    return self.registry
end


--"ComboBox", "Toggle", "KeyBind", "DropBox", COLORPICKER, DOUBLE_COLORPICKER, "Slider", BUTTON, LIST, IMAGE, TEXTBOX 
config.parsertovalue = {
    ["Text"] = function(v) return v.value end,
    ["Toggle"] = function(v) return v.value end,
    ["Slider"] = function(v) return v.value end,
    ["KeyBind"] = function(v) return {type = "KeyBind", value = v.key, toggle = false} end,
    ["DropBox"] = function(v) return {type = "DropBox", value = v.values[v.value], list = v.values} end,
    ["ColorPicker"] = function(v)
        if not v.color[4] then
            v.color[4] = 255
        end
        return {type = "ColorPicker", value = v.color}
    end,
    ["ComboBox"] = function(v) return {type = "ComboBox", value = v.values} end,
}

config.unsafe_paths = {}

-- Converts a setup table (which is a mix of menu params and config) into a config quick lookup table
function config:ParseSetupToConfig(tbl, source, path)
    path = path or ""
    for i=1, #tbl do
        local v = tbl[i]
        if v.content or v[1] then
            local ismulti = typeof(v.name) == "table"
            for i=1, (ismulti and #v.name or 1) do
                local name = (ismulti and v.name[i] or (v.Id or v.name))
                source[name] = {}
                self:ParseSetupToConfig((ismulti and v[i].content or v.content), source[name], path .. (path ~= "" and "." or "") .. name)
            end
        elseif v.type and self.parsertovalue[v.type] then
            if not v.name then v.name = v.type end
            local name = v.Id or v.name
            local _path = path .. (path ~= "" and "." or "") .. name
            local conversion = self.parsertovalue[v.type]
            if conversion then
                source[name] = conversion(v)
                if v.unsafe then
                    config.unsafe_paths[#config.unsafe_paths+1] = _path
                end
            end
            if v.extra then
                local extra = v.extra
                if extra[1] then
                    source[name] = {
                        ["self"] = source[name]
                    }
                    for c=1, #extra do
                        local extra = extra[c]
                        if extra.type and self.parsertovalue[extra.type] then
                            if not extra.name then extra.name = extra.type end
                            local ismulti = typeof(extra.name) == "table"
                            for i=1, (ismulti and #extra.name or 1) do
                                local _name = (ismulti and extra.name[i] or (extra.Id or extra.name))
                                local conversion = self.parsertovalue[extra.type]
                                if conversion then
                                    source[name][_name] = conversion(extra, i)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Setup for the config system to start it's managing process
function config:Setup(configtable)
    local raw = table.deepcopy(configtable)
    self.raw = raw
    local reg = {}
    self:ParseSetupToConfig(raw, reg)
    self.registry = reg
    self._base_registry = table.deepcopy(reg)
end

function config:GetTableValue(tbl, ...)
    local steps = {...}
    for i=1, #steps do
        if typeof(tbl) ~= "table" then return end
        tbl = tbl[steps[i]]
        if tbl == nil then break end
    end
    if tbl == nil then return end
    return tbl
end

function config:ConfigToSaveable(reg)
    table.recursion( reg, function(pathway, value)
        local optionname = pathway[#pathway]
        if typeof(value) == "table" then
            if optionname == "configuration" then return false end
            if value.type == "Button" then
                return false
            elseif value.type then
                if value.type == "Message" then return false end
                local pathway = table.deepcopy(pathway)
                pathway[#pathway] = nil
                local val = value.value
                local type = typeof(val)
                if value.type == "ComboBox" then
                    config:GetTableValue(reg, unpack(pathway))[optionname] = {
                        T = "ComboBox",
                        V = val
                    }
                elseif value.type == "ColorPicker" then
                    config:GetTableValue(reg, unpack(pathway))[optionname] = {
                        T = "ColorPicker",
                        V = val
                    }
                elseif type == "Color3" then
                    config:GetTableValue(reg, unpack(pathway))[optionname] = {
                        T = "Color3",
                        R = val.R,
                        G = val.G,
                        B = val.B,
                    }
                elseif type == "Vector3" then
                    config:GetTableValue(reg, unpack(pathway))[optionname] = {
                        T = "Vector3",
                        X = val.X,
                        Y = val.Y,
                        Z = val.Z,
                    }
                else
                    config:GetTableValue(reg, unpack(pathway))[optionname] = value.value
                end
                return false
            end
            if value.T then return false end
        end
    end)
    return reg
end

function config:Discover()
    local list = asset:ListFiles("configs")
    local c=0
    for i=1, #list do
        local v = list[i-c]
        local file = string.Explode(".", v)[1]
        list[i-c]=file
    end
    return list
end

function config:Save(file)
    local reg = table.deepcopy( self.registry )
    reg["Main"]["Settings"]["Saves"]["Configs"] = nil
    reg = self:ConfigToSaveable(reg)
    asset:WriteJSON("configs", file .. self.storage_extension, reg)
    hook:Call("OnConfigSaved", file)
end

function config:ProcessOpen(target, path, newconfig)
    return xpcall(function(target, path, newconfig) table.recursion( target, function(pathway, value)
        local optionname = pathway[#pathway]
        local isself = false
        if optionname == "self" then
            isself = true
            optionname = pathway[#pathway-1]
        end
        local natural_path = pathway
        if path then
            local newpath = {}
            for i=#path+1, #pathway do
                newpath[#newpath+1] = pathway[i]
            end
            natural_path = newpath
        end
        if isself then
            pathway = table.deepcopy(pathway)
            pathway[#pathway] = nil
        end
        local T = typeof(value)
        if T == "Vector3" then
            local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
            if not newvalue or typeof(newvalue) ~= "table" or not newvalue.X then return end
            config:SetValue(Vector3.new(newvalue.X, newvalue.Y, newvalue.Z), unpack(pathway))
            return false
        elseif T == "Color3" then
            local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
            if not newvalue or typeof(newvalue) ~= "table" or not newvalue.R then return end
            config:SetValue(Color3.new(newvalue.R, newvalue.G, newvalue.B), unpack(pathway))
            return false
        elseif T=="table" then
            if value.type then
                if value.type == "Message" then return false end
                local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
                if value.type == "KeyBind" then
                    config:SetValue(newvalue, unpack(pathway))
                    return false
                end
                if newvalue == nil then return false end
                if value.type == "ColorPicker" and newvalue.T == "ColorPicker" then
                    newvalue = newvalue.V
                elseif value.type == "ComboBox" and newvalue.T == "ComboBox" and #newvalue.V == #value.value then
                    newvalue = newvalue.V
                    for i=1, #value.value do
                        if typeof(value.value[i]) ~= typeof(newvalue[i]) then
                            newvalue = nil
                            break
                        elseif value.value[i][1] ~= newvalue[i][1] then
                            newvalue = nil
                            break
                        end
                    end
                elseif value.type == "DropBox" then
                    if not table.quicksearch(value.list, newvalue) then
                        newvalue = value.value
                    end
                elseif value.type == "Slider" then
                    if typeof(newvalue) ~= "number" then
                        newvalue = value.value
                    elseif newvalue > value.max then
                        newvalue = value.max
                    elseif newvalue < value.min then
                        newvalue = value.min
                    end
                else
                    newvalue = nil
                end
                if newvalue ~= nil then
                    config:SetValue(newvalue, unpack(pathway))
                end
                return false
            end
            return true
        end
        local newvalue = config:GetTableValue(newconfig, unpack(natural_path))
        if newvalue == nil then return end
        if typeof(newvalue) ~= typeof(config:GetValue(unpack(pathway))) then return end
        config:SetValue(newvalue, unpack(pathway))
    end, path) end, debug.traceback, target, path, newconfig)
end

function config:Open(file)
    local path = file .. self.storage_extension
    if asset:IsFile("configs", path) then
        local configsection = self.registry["Main"]["Settings"]["Saves"]["Configs"]
        local old = table.deepcopy(self.registry)
        local newconfig = asset:ReadJSON("configs", path)
        self.Opening = true
        local ran, err = self:ProcessOpen(self.registry, nil, newconfig)
        if not ran then
            BBOT.log(LOG_WARN, "Error loading config '" .. file .. "', did you break something in it?")
            BBOT.log(LOG_ERROR, err)
            self.registry = old
            return
        end
        self.registry["Main"]["Settings"]["Saves"]["Configs"] = configsection
        hook:Call("OnConfigOpened", file)
        self.Opening = nil
    end
end

function config:SaveBase()
    local reg = table.deepcopy( self.registry["Main"]["Settings"]["Saves"]["Configs"] )
    reg = self:ConfigToSaveable(reg)
    asset:WriteJSON("data", "configs.json", reg)
end

function config:OpenBase()
    local path = "configs.json"
    if asset:IsFile("data", path) then
        local old = table.deepcopy(self.registry["Main"]["Settings"]["Saves"]["Configs"])
        local newconfig = asset:ReadJSON("data", path)
        self.Opening = true
        local ran, err = self:ProcessOpen(self.registry["Main"]["Settings"]["Saves"]["Configs"], {"Main", "Settings", "Saves", "Configs"}, newconfig)
        if not ran then
            BBOT.log(LOG_WARN, "Error loading base '" .. path .. "', did you break something in it?")
            BBOT.log(LOG_ERROR, err)
            self.registry["Main"]["Settings"]["Saves"]["Configs"] = old
            return
        end
        self.Opening = nil
    end
end

hook:Add("OnConfigChanged", "BBOT:config.autosave", function(steps)
    if config.Opening or config.Busy then return end
    config:SaveBase()
    if config:GetValue("Main", "Settings", "Saves", "Configs", "Auto Save Config") and not config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Configs") then
        local file = config:GetValue("Main", "Settings", "Saves", "Configs", "Autosave File")
        BBOT.log(LOG_NORMAL, "Autosaving config -> " .. file)
        config:Save(file)
    end
end)

hook:Add("Menu.PostGenerate", "BBOT:config.setup", function()
    local configs = BBOT.config:Discover()
    BBOT.config:GetRaw("Main", "Settings", "Saves", "Configs", "Configs").list = configs
    BBOT.menu.config_pathways[table.concat({"Main", "Settings", "Saves", "Configs", "Configs"}, ".")]:SetOptions(configs)
end)

function config:BaseGetNormal(...)
    local steps = {...}
    local reg = self._base_registry
    for i=1, #steps do
        reg = reg[steps[i]]
        if reg == nil then break end
    end
    if reg == nil then return end
    if typeof(reg) == "table" then
        if reg.self ~= nil then
            local s = reg.self
            if typeof(s) == "table" and s.type and s.type ~= "Button" then
                return s.value
            end
            return s
        end
        if reg.type and reg.type ~= "Button" then
            return reg.value
        end
    end
    return reg
end

hook:Add("OnConfigChanged", "BBOT:config.unsafefeatures", function(steps, old, new)
    if config:IsPathwayEqual(steps, "Main", "Settings", "Saves", "Cheat Settings", "Allow Unsafe Features") and not new then
        timer:Async(function()
            config.Busy = true
            for i=1, #config.unsafe_paths do
                local path = string.Explode(".", config.unsafe_paths[i])
                config:SetValue(config:BaseGetNormal(unpack(path)), unpack(path))
            end
            config.Busy = false
        end)
    end
end)


hook:Add("PreInitialize", "BBOT:config.setup", function()
    config:Setup(BBOT.configuration)

    if asset:IsFile("data", "priorities.json") then
        local tbl = asset:ReadJSON("data", "priorities.json")
        for k, v in pairs(tbl) do
            config.priority[tonumber(k)] = v
        end
    end

    config:OpenBase()
    if config:GetValue("Main", "Settings", "Saves", "Configs", "Auto Load Config") then
        local file = config:GetValue("Main", "Settings", "Saves", "Configs", "Autoload File")
        BBOT.log(LOG_NORMAL, "Autoloading config -> " .. file)
        BBOT.notification:Create("Auto loaded config: " .. file)
        config:Open(file)
    end
end)

return config