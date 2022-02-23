local hook = BBOT.hook
local draw = BBOT.draw
local gui = BBOT.gui
local string = BBOT.string
local asset = BBOT.asset
local log = BBOT.log
local font = {
    registry = {},
    managers = {}
}

function font:GetFonts()
    local list = {}
    for k, v in pairs(font.registry) do
        list[#list+1] = k
    end
    table.sort(list, function(a, b) return a < b end)
    return list
end

-- { Bold = true, Italics = true }
function font:Register(font_name, font_data, font_arguments)
    if not font:CanRegister(font_name, font_data) then return end
    local font_object = Font.Register(font_data, font_arguments or {})
    self.registry[font_name] = font_object
    return font_object
end

function font:CanRegister(font_name, font_data)
    if self.registry[font_name] then return false end
    return true
end

function font:Create(category, font, size)
    local reg = self.registry[font]
    if not reg then return end
    log(LOG_DEBUG, "Created font-manager '" .. category .. "' with font '" .. font .. "' and size '" .. size .. "'")
    self.managers[category] = {
        font = font,
        size = size,
        handles = {},
    }
end

function font:Get(category)
    local reg = self.managers[category]
    if not reg then return end
    local font_object = self.registry[reg.font]
    if not font_object then return end
    return font_object, reg.size
end

function font:GetFont(name)
    return self.registry[name]
end

function font:GetTextBounds(category, text)
    local font_registry = self.managers[category]
    if not font_registry then return end
    local font, size = font_registry.font, font_registry.size
    local font_object = self.registry[font]
    if not font_object then return end
    return font_object:GetTextBounds(size, text)
end

function font:AddToManager(object, category)
    local manager = self.managers[category]
    if not manager then return end
    manager.handles[#manager.handles+1] = object
    if object.isdraw then
        local font, size = font:Get(category)
        object.Font = font
        object.Size = size
    end
end

function font:RemoveFromManager(object, category)
    local manager = self.managers[category]
    if not manager then return end
    for i=1, #manager.handles do
        local v = manager.handles[i]
        if v == object then
            table.remove(manager.handles, i)
            break
        end
    end
end

function font:ChangeFont(category, new)
    local new_font = self.registry[new]
    if not new_font then return end
    local manager = self.managers[category]
    if not manager then return end
    log(LOG_DEBUG, "Changed font-manager '" .. category .. "' to '" .. new .. "'")
    local old = manager.font
    manager.font = new
    local handles = manager.handles
    local c = 0
    for i=1, #handles do
        local v = handles[i-c]
        if rawget(v, "isdraw") and draw:IsValid(v) then
            v.Font = new_font
        elseif rawget(v, "isgui") and gui:IsValid(v) then
            if v.OnFontChanged then
                v:OnFontChanged(old, new)
            end
        else
            table.remove(handles, i-c)
            c=c+1
        end
    end
    hook:Call("OnFontTypeChanged", category, old, new)
end

function font:ChangeSize(category, new)
    local manager = self.managers[category]
    if not manager then return end
    log(LOG_DEBUG, "Changed font-manager size '" .. category .. "' to '" .. new .. "'")
    local old = manager.size
    manager.size = new
    local handles = manager.handles
    local c = 0
    for i=1, #handles do
        local v = handles[i-c]
        if rawget(v, "isdraw") and draw:IsValid(v) then
            v.Size = new
        elseif rawget(v, "isgui") and gui:IsValid(v) then
            if v.OnFontSizeChanged then
                v:OnFontSizeChanged(old, new)
            end
        else
            table.remove(handles, i-c)
            c=c+1
        end
    end
    hook:Call("OnFontSizeChanged", category, old, new)
end

function font:GetDefault()
    return "IBMPlexMono Medium"
end

local defaults = Font.ListDefault()
for i=1, #defaults do
    local font_name = defaults[i]
    local lower = string.lower(font_name)
    if string.find(lower, "italic")
        or string.find(lower, "thin")
        or string.find(lower, "light")
    then continue end
    local font_object = Font.RegisterDefault(font_name, {})
    if not font_object then continue end
    font_name = string.Replace( font_name, "_", " " )
    font.registry[font_name] = font_object
end

function font:RegisterAssets()
    local registered = false
    local list = asset:ListFiles("fonts", "")
    for i=1, #list do
        local fontdata = asset:Read("fonts", list[i])
        local name = asset:GetFileName(list[i])
        if font:CanRegister(name, fontdata) then
            font:Register(name, fontdata)
            registered = true
        end
    end
    return registered
end

hook:Add("Startup", "BBOT:Font.Setup", function()
    asset:Register("fonts", {".ttf", ".otf"})
    font:RegisterAssets()
end)

return font