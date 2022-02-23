local hook = BBOT.hook
local string = BBOT.string
local httpservice = BBOT.service:GetService("HttpService")
local asset = {
    registry = {}
}

-- THIS IS INTERNAL, DO NOT CALL THIS!
function asset:Initialize()
    self.game = BBOT.game
    self.path = "bitchbot/"..self.game
end

-- registers a folder with an extensions whitelist
function asset:Register(class, extensions)
    if not self.registry[class] then
        if not extensions then
            self.registry[class] = {
                __extensions = true
            }
        else
            local invert = {}
            for i=1, #extensions do
                invert[extensions[i]] = true
            end
            self.registry[class] = {
                __extensions = invert
            }
        end
    end
    local path = self.path .. "/" .. class
    if not isfolder(path) then
        makefolder(path)
    end
end

-- get's the file in the form of a synapse asset Id
function asset:GetAsset(class, path)
    if not self.registry[class] then return end
    local reg = self.registry[class]
    local extension = string.match(path, "^.+(%..+)$")
    if reg.__extensions ~= true and not reg.__extensions[extension] then return false end
    if not reg[path] then
        if isfile(self.path .. "/" .. class .. "/" .. path) then
            reg[path] = getsynasset(self.path .. "/" .. class .. "/" .. path)
        else
            return false
        end
    end
    return reg[path]
end

-- get's the file name from a direct path
function asset:GetFileName(path)
    path = string.match(path, "([^/]+)$")
    if path then
        return string.match(path, "(.+)%..+")
    end
end

-- get's the extension of a file path
function asset:GetExtension(path)
    return string.match(path, "^.+(%..+)$")
end

-- is this a folder?
function asset:IsFolder(class, path)
    return isfolder(self.path .. "/" .. class .. "/" .. path)
end

-- is this a file?
function asset:IsFile(class, path)
    return isfile(self.path .. "/" .. class .. "/" .. path)
end

-- makes a god damn folder
function asset:MakeFolder(class, path)
    if not isfolder(self.path .. "/" .. class .. "/" .. path) then
        makefolder(self.path .. "/" .. class .. "/" .. path)
        return true
    end
    return false
end

-- get's the raw data of a file
function asset:Read(class, path)
    if not self.registry[class] then return end
    local reg = self.registry[class]
    local extension = string.match(path, "^.+(%..+)$")
    if reg.__extensions ~= true and not reg.__extensions[extension] then return false end
    if isfile(self.path .. "/" .. class .. "/" .. path) then
        return readfile(self.path .. "/" .. class .. "/" .. path)
    end
end

-- get's and converts a file to a table from j son format
function asset:ReadJSON(class, path)
    local data = asset:Read(class, path)
    if not data then return end
    return httpservice:JSONDecode(data)
end

-- writes a data to a file
function asset:Write(class, path, data)
    if not self.registry[class] then return end
    local reg = self.registry[class]
    local extension = string.match(path, "^.+(%..+)$")
    if not extension or (reg.__extensions ~= true and not reg.__extensions[extension]) then
        BBOT.log(LOG_ERROR, "Asset - Invalid extensions '" .. (extension or "UNK") .. "'\n" .. debug.traceback())
        return
    end
    writefile(self.path .. "/" .. class .. "/" .. path, data)
end

-- writes a table as a j son to a file
function asset:WriteJSON(class, path, data)
    data = httpservice:JSONEncode(data)
    return asset:Write(class, path, data)
end

-- lists all files in an asset's folder/sub-folder
function asset:ListFiles(class, path)
    if not self.registry[class] then return end
    local reg = self.registry[class]
    local extensions = reg.__extensions
    local ispath = (path ~= "" and path ~= nil)

    local files = {}
    local list = listfiles(self.path .. "/" .. class .. (ispath and "/" .. path or ""))
    for i=1, #list do
        local file = list[i]
        local filename = string.Explode("\\", file)
        filename = filename[#filename]
        local extension = string.match(filename, "^.+(%..+)$")
        if extensions == true or extensions[extension] then
            files[#files+1] = (ispath and path .. "/" or "") .. filename
        end
    end
    return files
end

hook:Add("PreStartup", "BBOT:Asset.Initialize", function()
    asset:Initialize()
    asset:Register("textures", {".png", ".jpg"})
    asset:Register("images", {".png", ".jpg"})
    asset:Register("sounds", {".ogg", ".mp3"})
    asset:Register("configs", {".json"})
    asset:Register("data")
end)

return asset