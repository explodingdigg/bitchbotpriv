local thread = BBOT.thread
local hook = BBOT.hook
local menu = BBOT.menu
local config = BBOT.config
local gui = BBOT.gui

BBOT.rootpath = "bitchbot"

-- Folder Generation
local function CreateFolder(path)
    if not isfolder(BBOT.rootpath .. "/" .. BBOT.game .. "/" .. path) then
        makefolder(BBOT.rootpath .. "/" .. BBOT.game .. "/" .. path)
    end
end
if not isfolder(BBOT.rootpath) then
    makefolder(BBOT.rootpath)
end
if not isfolder(BBOT.rootpath .. "/" .. BBOT.game) then
    makefolder(BBOT.rootpath .. "/" .. BBOT.game)
end
CreateFolder("configs")
CreateFolder("data")
CreateFolder("scripts")

local loading
function BBOT:SetLoadingText(txt)
    if loading then
        loading.msg:SetText(txt)
        local w, h = loading.msg:GetTextSize()
        w = w + 20
        h = h + 60
        if w < 270 then
            w = 270
        end
        gui:SizeTo(loading, UDim2.new(0, w, 0, h), 0.775, 0, 0.25)
        gui:MoveTo(loading, UDim2.new(.5, -w/2, .5, -h/2), 0.775, 0, 0.25)
    end
end

function BBOT:SetLoadingProgressBar(perc)
    if loading then
        loading.progress:SetPercentage(perc/100)
    end
end

function BBOT:SetLoadingStatus(txt, perc)
    if not loading then return end
    if txt then self:SetLoadingText(txt) end
    if perc then self:SetLoadingProgressBar(perc) end
    wait()
end

if menu and gui then
    loading = gui:Create("Panel")

    local message = gui:Create("Text", loading)
    loading.msg = message
    message:SetPos(.5, 0, .5, -20)
    message:SetXAlignment(XAlignment.Center)
    message:SetYAlignment(YAlignment.Center)
    message:SetText("Waiting for "..game.Name.."...")
    local w, h = message:GetTextSize()

    local progress = gui:Create("ProgressBar", loading)
    loading.progress = progress
    progress:SetPos(0, 10, .5, 10)
    progress:SetSize(1, -20, 0, 10)

    w = w + 20
    h = h + 50

    if w < 270 then
        w = 270
    end

    loading:SetSize(0, w, 0, h)
    loading:Center()
end

BBOT:SetLoadingStatus(nil, 5)

hook:Add("PreInitialize", "PreInitialize", function()
    BBOT:SetLoadingStatus("Pre-Initializing...", 65)
end)

hook:Add("Initialize", "Initialize", function()
    BBOT:SetLoadingStatus("Initializing...", 80)
end)

hook:Add("PostInitialize", "PostInitialize", function()
    BBOT:SetLoadingStatus("Post-Setups...", 100)
    if loading then
        loading:Remove()
        loading = nil
    end
end)

hook:Call("PreStartup")

local font = BBOT.font
local default_font = font:GetDefault()
local font_index = 1
for k, v in pairs(font:GetFonts()) do
    if v == default_font then
        font_index = k
    end
end

-- This is the setup table, I'm changing this to not be like this...
BBOT.configuration = {
    {
        -- The first layer here is the frame
        Id = "Main",
        name = "Bitch Bot",
        center = true,
        size = UDim2.new(0, 500, 0, 600),
        content = {
        }
    },
}