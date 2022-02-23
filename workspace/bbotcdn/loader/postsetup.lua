local thread = BBOT.thread
local hook = BBOT.hook
local menu = BBOT.menu
local config = BBOT.config
local gui = BBOT.gui

local main_panel = BBOT.configuration[1].content
main_panel[#main_panel+1] = {
    name = "Settings",
    pos = UDim2.new(0,0,0,0),
    size = UDim2.new(1,0,1,0),
    borderless = true,
    innerborderless = true,
    topbarsize = 50,
    type = "Tabs",
    content = {
        {
            name = "Saves",
            icon = "SAVE",
            pos = UDim2.new(0,0,0,0),
            size = UDim2.new(1,0,1,0),
            type = "Container",
            content = {
                {
                    name = "Configs",
                    pos = UDim2.new(0,0,0,0),
                    size = UDim2.new(.5,-4,1,-4),
                    type = "Panel",
                    content = {
                        {
                            type = "Text",
                            name = "Config Name",
                            value = "Default",
                            extra = {},
                        },
                        {
                            type = "DropBox",
                            name = "Configs",
                            value = 1,
                            values = {"Default"}
                        },
                        {
                            type = "Button",
                            name = "Save",
                            confirm = "Are you sure?",
                            callback = function()
                                local s = BBOT.config:GetValue("Main", "Settings", "Saves", "Configs", "Config Name")
                                BBOT.config:Save(s)
                                BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autosave File")
                                BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autoload File")
                                local configs = BBOT.config:Discover()
                                BBOT.config:GetRaw("Main", "Settings", "Saves", "Configs", "Configs").list = configs
                                menu.config_pathways[table.concat({"Main", "Settings", "Saves", "Configs", "Configs"}, ".")]:SetOptions(configs)
                                BBOT.notification:Create("Saved config: " .. s)
                            end
                        },
                        {
                            type = "Button",
                            name = "Load",
                            confirm = "Are you sure?",
                            callback = function()
                                local s = BBOT.config:GetValue("Main", "Settings", "Saves", "Configs", "Configs")
                                BBOT.config:Open(s)
                                BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Config Name")
                                BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autosave File")
                                BBOT.config:SetValue(s, "Main", "Settings", "Saves", "Configs", "Autoload File")
                                local configs = BBOT.config:Discover()
                                BBOT.config:GetRaw("Main", "Settings", "Saves", "Configs", "Configs").list = configs
                                menu.config_pathways[table.concat({"Main", "Settings", "Saves", "Configs", "Configs"}, ".")]:SetOptions(configs)
                                BBOT.notification:Create("Loaded config: " .. s)
                            end
                        },
                        {
                            type = "Toggle",
                            name = "Auto Save Config",
                            value = false,
                            extra = {},
                        },
                        {
                            type = "Text",
                            name = "Autosave File",
                            value = "Default",
                            extra = {},
                        },
                        {
                            type = "Toggle",
                            name = "Auto Load Config",
                            value = false,
                            extra = {},
                        },
                        {
                            type = "Text",
                            name = "Autoload File",
                            value = "Default",
                            extra = {},
                        },
                    }
                },
                {
                    name = "Cheat Settings",
                    pos = UDim2.new(.5,4,0,0),
                    size = UDim2.new(.5,-4,1/2,-4),
                    type = "Panel",
                    content = {
                        {
                            type = "Toggle",
                            name = "Menu Accent",
                            value = false,
                            extra = {
                                {
                                    type = "ColorPicker",
                                    name = "Accent",
                                    color = { 127, 72, 163, 255 },
                                }
                            },
                        },
                        {
                            type = "Toggle",
                            name = "Open Menu On Boot",
                            value = true,
                            extra = {},
                        },
                        {
                            type = "Toggle",
                            name = "Background",
                            value = false,
                            extra = {
                                {
                                    type = "ColorPicker",
                                    name = "Color",
                                    color = { 0, 0, 0, 255 },
                                }
                            },
                        },
                        {
                            type = "Text",
                            name = "Custom Menu Name",
                            value = "Bitch Bot",
                            extra = {},
                            tooltip = "Changes the menu name, not the watermark"
                        },
                        {
                            type = "Text",
                            name = "Custom Watermark",
                            value = "Bitch Bot",
                            extra = {},
                            tooltip = "Changes the watermark at the top left, there are text arguments as well such as {username}, {version}, {date}, {time} and {fps}"
                        },
                        {
                            type = "Text",
                            name = "Custom Logo",
                            value = "Bitch Bot",
                            extra = {
                                {
                                    type = "ColorPicker",
                                    name = "Color",
                                    color = { 255, 255, 255, 255 },
                                }
                            },
                            tooltip = "Use can use either a file, or an imgur image Id, for the imgur image Id you will need this -> https://i.imgur.com/g2k0at.png, only input the 'g2k0at' part! Changing this to a blank box will remove the logo."
                        },
                        {
                            type = "Toggle",
                            name = "Allow Unsafe Features",
                            value = false,
                            extra = {},
                        },
                        {
                            type = "Button",
                            name = "Unload Cheat",
                            confirm = "Are you sure?",
                            callback = function()
                                BBOT.hook:Call("Unload")
                                BBOT.Unloaded = true
                            end
                        }
                    },
                },
                {
                    name = "Menus",
                    pos = UDim2.new(.5,4,1/2,4),
                    size = UDim2.new(.5,-4,2/10,-4),
                    type = "Panel",
                    content = {
                        {
                            type = "Toggle",
                            name = "Weapon Customization",
                            value = false,
                            extra = {},
                        },
                    }
                },
            }
        },
        {
            name = "Environment",
            icon = "PLAYERS",
            pos = UDim2.new(0,0,0,0),
            size = UDim2.new(1,0,1,0),
            type = "Container",
            content = {
                {
                    name = "Player List", -- No type means auto-set to panel
                    pos = UDim2.new(0,0,0,0),
                    size = UDim2.new(1,0,1,0),
                    type = "Custom",
                    callback = function()
                        local gui = BBOT.gui
                        local container = gui:Create("Container")
                        local search = gui:Create("TextEntry", container)
                        search:SetFontManager("Menu.BodySmall")
                        search:SetText("")
                        search:SetSize(1,0,0,16)
                        search:SetPlaceholder("Search Here")

                        local playerbox_size = 115
                        local playerlist = gui:Create("List", container)
                        playerlist:SetPos(0,0,0,16+6)
                        playerlist:SetSize(1,0,1,-16-6-playerbox_size-8)

                        playerlist:AddColumn("Name")
                        playerlist:AddColumn("State")
                        playerlist:AddColumn("Team")
                        playerlist:AddColumn("Priority")

                        local function Refresh_List()
                            local tosearch = search:GetText()
                            local table = BBOT.table
                            local players = BBOT.service:GetService("Players")
                            local localplayer = BBOT.service:GetService("LocalPlayer")
                            local checked = {}

                            for i, v in next, players:GetChildren() do
                                if v == localplayer then continue end
                                local children = playerlist.scrollpanel.canvas.children
                                for i=1, #children do
                                    if children[i].player == v then
                                        checked[v] = true
                                        break 
                                    end
                                end
                                if not checked[v] then
                                    local state = "Neutral"
                                    local priority, extra = config:GetPriority(v)
                                    if priority then
                                        if extra then
                                            state = extra .. " (" .. priority .. ")"
                                        elseif priority > 0 then
                                            state = "Priority (" .. priority .. ")"
                                        elseif priority < 0 then
                                            state = "Friendly (" .. (-priority) .. ")"
                                        end
                                    end
                                    local line = playerlist:AddLine(v.Name, "Unknown", v.Team.Name, state)
                                    line.player = v

                                    local team_line = line.children[3]
                                    function team_line:Step()
                                        if not self:GetAbsoluteVisible() then return end
                                        local pl = self.parent.player
                                        if pl and pl.Team and pl.Team.TeamColor and pl.Team.TeamColor.Color then
                                            if pl.Team.Name ~= self.parent.team then
                                                self.text:SetColor(pl.Team.TeamColor.Color)
                                                self.text:SetText(pl.Team.Name)
                                                self.parent.team = pl.Team.Name
                                            end
                                        end
                                    end

                                    local state_line = line.children[2]
                                    function state_line:Step()
                                        local pl = self.parent.player
                                        if pl and BBOT.aux then
                                            local updater = BBOT.aux.replication.getupdater(pl)
                                            if updater then
                                                local hp = (updater.alive and math.round(BBOT.aux.hud:getplayerhealth(pl)) or 0)
                                                if updater.alive ~= self.alive or hp ~= self.hp then
                                                    self.alive = updater.alive
                                                    self.hp = hp
                                                    if self.alive then
                                                        self.text:SetColor(Color3.new(0,1,0))
                                                        self.text:SetText(math.round(hp) .. " HP")
                                                    else
                                                        self.text:SetColor(Color3.new(1,0,0))
                                                        self.text:SetText("Dead")
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    checked[v] = true
                                end
                            end

                            for i, v in next, playerlist.scrollpanel.canvas.children do
                                if not v.player or not checked[v.player] then
                                    v:Remove()
                                elseif tosearch == "" or string.find(string.lower(v.children[1].text:GetText()), string.lower(tosearch), 1, true) then
                                    v:SetVisible(true)
                                else
                                    v:SetVisible(false)
                                end
                            end

                            playerlist:PerformOrganization()
                        end

                        function search:OnValueChanged()
                            Refresh_List()
                        end

                        local target = nil

                        BBOT.timer:Simple(.1, Refresh_List)

                        local playerbox = gui:Create("Box", container)
                        playerbox:SetPos(0,0,1,-playerbox_size)
                        playerbox:SetSize(1,0,0,playerbox_size)

                        local draw = BBOT.draw
                        local aline = gui:Create("Container", playerbox)
                        local background_border = draw:Create("Rect", "2V")
                        background_border.Color = gui:GetColor("Border")
                        background_border.Filled = true
                        background_border.XAlignment = XAlignment.Right
                        background_border.YAlignment = YAlignment.Bottom
                        aline.background_border = aline:Cache(background_border)
                        function aline:PerformLayout(pos, size)
                            self.background_border.Offset = pos
                            self.background_border.Size = size
                        end
                        aline:SetPos(.7,-1,0,2)
                        aline:SetSize(0,2,1,-4)

                        local image_container = gui:Create("Box", playerbox)
                        image_container:SetPos(0, 4, 0, 4)
                        image_container:SetSize(0, playerbox_size-8, 0, playerbox_size-8)

                        local player_image = gui:Create("Image", image_container)
                        player_image:SetPos(0, 0, 0, 0)
                        player_image:SetSize(1, 0, 1, 0)
                        player_image:SetImage(BBOT.menu.images[5])

                        local player_name = gui:Create("Text", playerbox)
                        player_name:SetPos(0, playerbox_size+4, 0, 2)
                        player_name:SetText("No Player Selected")

                        local w, h = player_name:GetTextSize()
                        local player_state = gui:Create("Text", playerbox)
                        player_state:SetPos(0, playerbox_size+4, 0, 2 + (2 + h))
                        player_state:SetText("State: Disconnected")

                        local player_rank = gui:Create("Text", playerbox)
                        player_rank:SetPos(0, playerbox_size+4, 0, 2 + (4 + h*2))
                        player_rank:SetText("Rank: N/A")

                        local player_kd = gui:Create("Text", playerbox)
                        player_kd:SetPos(0, playerbox_size+4, 0, 2 + (6 + h*3))
                        player_kd:SetText("KD: N/A")

                        local options_container = gui:Create("Container", playerbox)
                        options_container:SetPos(.7, 6, 0, 4)
                        options_container:SetSize(.3, -10, 1, -8)

                        local Y = 0
                        -- priority
                        local player_priority
                        do
                            local cont = gui:Create("Container", options_container)
                            local text = gui:Create("Text", cont)
                            text:SetPos(0, 0, 0, 0)
                            text:SetTextSize(13)
                            text:SetText("Status")
                            local dropbox = gui:Create("DropBox", cont)
                            player_priority = dropbox
                            local _, tall = text:GetTextScale()
                            dropbox:SetPos(0, 0, 0, tall+4)
                            dropbox:SetSize(1, 0, 0, 16)
                            dropbox:SetOptions({"None", "Friendly", "Priority"})
                            dropbox:SetValue(1)
                            dropbox.tooltip = "Change the priority of an individual"
                            cont:SetPos(0, 0, 0, Y-2)
                            cont:SetSize(1, 0, 0, tall+4+16)
                            function dropbox:OnValueChanged(new)
                                if not target then return end
                                local level = 0
                                if new == "None" then
                                    level = 0
                                elseif new == "Friendly" then
                                    level = -1
                                elseif new == "Priority" then
                                    level = 1
                                end
                                config:SetPriority(target, level)
                            end
                            Y=Y+16+4+16+2
                        end

                        -- Spectate
                        do
                            local button = gui:Create("Button", options_container)
                            button:SetPos(0, 0, 0, Y)
                            button:SetSize(1, 0, 0, 16)
                            button:SetText("Spectate")
                            button.OnClick = function()
                                local spectator = BBOT.spectator
                                if not target then
                                    if spectator:IsSpectating() then
                                        spectator:Spectate(nil)
                                    end
                                    return
                                end
                                if spectator:IsSpectating() == target then
                                    spectator:Spectate(nil)
                                    return
                                end
                                spectator:Spectate(target)
                            end
                            hook:Add("Spectator.Spectate", "BBOT:Menu.SpectateButton-" .. button.uid, function(target)
                                if target then
                                    button:SetText("Stop Spectating")
                                else
                                    button:SetText("Spectate")
                                end
                            end)
                            Y=Y+16+7
                        end

                        -- VoteKick
                        do
                            local button = gui:Create("Button", options_container)
                            button:SetPos(0, 0, 0, Y)
                            button:SetSize(1, 0, 0, 16)
                            button:SetText("Votekick")
                            button:SetConfirmation("Are you sure?")
                            button.OnClick = function()
                                if not target then return end
                                BBOT.votekick:Call(target.Name, "cheating")
                            end
                            Y=Y+16+7
                        end

                        -- Get UID
                        do
                            local button = gui:Create("Button", options_container)
                            button:SetPos(0, 0, 0, Y)
                            button:SetSize(1, 0, 0, 16)
                            button:SetText("Get UserId")
                            button:SetConfirmation("Are you sure?")
                            button.OnClick = function()
                                if not target then return end
                                setclipboard(tostring(target.UserId))
                            end
                            Y=Y+16+7
                        end

                        function playerlist:OnSelected(row)
                            target = row.player
                            local selected = target
                            player_name:SetText("Name: " .. target.Name)
                            player_state:SetText("State: In-Lobby")

                            --[[local data = BBOT.aux:GetPlayerData(target.Name)
                            local playerrank = playerdata.Rank.Text
                            local kills = playerdata.Kills.Text
                            local deaths = playerdata.Deaths.Text

                            player_rank:SetText("Rank: " .. playerrank)
                            player_kd:SetText("KD: " .. kills .. "/" .. deaths)]]

                            local uid = target.UserId
                            local level = config.priority[uid] or 0
                            if level == 0 then
                                player_priority:SetValue("None")
                            elseif level == -1 then
                                player_priority:SetValue("Friendly")
                            elseif level == 1 then
                                player_priority:SetValue("Priority")
                            end
                            BBOT.thread:Create(function()
                                local data = game:HttpGet(string.format(
                                    "https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=100&height=100&format=png",
                                    uid
                                ))
                                if not gui:IsValid(player_image) or target ~= selected then return end
                                player_image:SetImage(ImageRef.new(data))
                            end)
                        end

                        hook:Add("PlayerAdded", "BBOT:PlayerManager.Add", function(player)
                            Refresh_List()
                        end)

                        hook:Add("PlayerRemoving", "BBOT:PlayerManager.Add", function(player)
                            if target == player then
                                target = nil
                                player_state:SetText("State: Disconnected")
                                player_rank:SetText("Rank: N/A")
                            end
                            Refresh_List()
                        end)

                        local wasalive, nextcheck = false, 0
                        hook:Add("RenderStepped", "BBOT:PlayerManager.Tick", function()
                            if nextcheck > tick() then return end
                            nextcheck = tick() + .05
                            if not target then return end
                            local updater = BBOT.aux.replication.getupdater(target)
                            if updater.alive ~= wasalive then
                                wasalive = updater.alive
                                if wasalive then
                                    player_state:SetText("State: In-Game")
                                else
                                    player_state:SetText("State: In-Lobby")
                                end
                            end
                        end)

                        hook:Add("OnPriorityChanged", "BBOT:PlayerManager.Changed", function(player, old_priority, priority)
                            local state = "Neutral"
                            if priority then
                                local priority, extra = config:GetPriority(player)
                                if extra then
                                    state = extra .. " (" .. priority .. ")"
                                elseif priority > 0 then
                                    state = "Priority (" .. priority .. ")"
                                elseif priority < 0 then
                                    state = "Friendly (" .. (-priority) .. ")"
                                end
                            end
                            for i, v in next, playerlist.scrollpanel.canvas.children do
                                if v.player == player then
                                    v.children[4].text:SetText(state)
                                    break
                                end
                            end
                        end)

                        return container
                    end,
                    content = {},
                },
            }
        },
        {
            name = "Lua",
            icon = "LUA",
            pos = UDim2.new(0,0,0,0),
            size = UDim2.new(1,0,1,0),
            type = "Container",
            content = {
                {
                    name = "Lua Stuff",
                    pos = UDim2.new(0,0,0,0),
                    size = UDim2.new(1,0,1,0),
                    type = "Custom",
                    callback = function()
                        local gui = BBOT.gui
                        local asset = BBOT.asset
                        local scripts = BBOT.scripts
                        local table = BBOT.table

                        local container = gui:Create("Container")
                        local search = gui:Create("TextEntry", container)
                        search:SetFontManager("Menu.BodySmall")
                        search:SetText("")
                        search:SetSize(1,0,0,16)
                        search:SetPlaceholder("Search Here")

                        local scriptbox_size = 90
                        local lualist = gui:Create("List", container)
                        lualist:SetPos(0,0,0,16+6)
                        lualist:SetSize(1,0,1,-16-6-scriptbox_size-8)

                        lualist:AddColumn("File Name")
                        lualist:AddColumn("State")
                        lualist:AddColumn("AutoExec")

                        local function Refresh_List()
                            local tosearch = search:GetText()
                            local checked = {}

                            for i, v in next, scripts:GetAll() do
                                local children = lualist.scrollpanel.canvas.children
                                for i=1, #children do
                                    if children[i].path == v then
                                        checked[v] = true
                                        break 
                                    end
                                end
                                if not checked[v] then
                                    local autoexec = "No"
                                    local autoexec_id = scripts:IsAutoExec(v)
                                    if autoexec_id then
                                        autoexec = "ID " .. autoexec_id
                                    end
                                    local line = lualist:AddLine(v, scripts:GetState(v), autoexec )
                                    line.path = v
                                    checked[v] = true
                                end
                            end

                            for i, v in next, lualist.scrollpanel.canvas.children do
                                if not v.path or not checked[v.path] then
                                    v:Remove()
                                elseif tosearch == "" or string.find(string.lower(v.children[1].text:GetText()), string.lower(tosearch), 1, true) then
                                    v:SetVisible(true)
                                else
                                    v:SetVisible(false)
                                end
                            end

                            lualist:PerformOrganization()
                        end

                        function search:OnValueChanged()
                            Refresh_List()
                        end

                        BBOT.timer:Simple(.1, Refresh_List)
                        
                        local scriptbox = gui:Create("Box", container)
                        scriptbox:SetPos(0,0,1,-scriptbox_size)
                        scriptbox:SetSize(1,0,0,scriptbox_size)

                        local draw = BBOT.draw
                        local aline = gui:Create("Container", scriptbox)
                        local background_border = draw:Create("Rect", "2V")
                        background_border.Color = gui:GetColor("Border")
                        background_border.Filled = true
                        background_border.XAlignment = XAlignment.Right
                        background_border.YAlignment = YAlignment.Bottom
                        aline.background_border = aline:Cache(background_border)
                        function aline:PerformLayout(pos, size)
                            self.background_border.Offset = pos
                            self.background_border.Size = size
                        end
                        aline:SetPos(.7,-1,0,2)
                        aline:SetSize(0,2,1,-4)

                        local script_name = gui:Create("Text", scriptbox)
                        script_name:SetPos(0, 4, 0, 2)
                        script_name:SetText("No Script Selected")
                        script_name:SetFontManager("Menu.BodyBig")

                        local w, h = script_name:GetTextSize()
                        local script_state = gui:Create("Text", scriptbox)
                        script_state:SetPos(0, 4, 0, 2 + (2 + h))
                        script_state:SetText("State: N/A")
                        script_state:SetFontManager("Menu.BodyBig")

                        local script_size = gui:Create("Text", scriptbox)
                        script_size:SetPos(0, 4, 0, 2 + (4 + h*2))
                        script_size:SetText("Size: N/A")
                        script_size:SetFontManager("Menu.BodyBig")

                        local options_container = gui:Create("Container", scriptbox)
                        options_container:SetPos(.7, 6, 0, 4)
                        options_container:SetSize(.3, -10, 1, -8)

                        local script = ""
                        local Y = 0

                        -- Execute
                        local execute_button
                        do
                            local button = gui:Create("Button", options_container)
                            execute_button = button
                            button:SetPos(0, 0, 0, Y)
                            button:SetSize(1, 0, 0, 16)
                            button:SetText("Execute")
                            button.OnClick = function()
                                if script ~= "" then
                                    local state = scripts:GetState(script)
                                    if state ~= "Running" then
                                        scripts:Run(script)
                                    else
                                        scripts:Unload(script)
                                    end
                                end
                            end
                            Y=Y+16+7
                        end

                        -- Auto Exec
                        local autoexec_button
                        do
                            local button = gui:Create("Button", options_container)
                            autoexec_button = button
                            button:SetPos(0, 0, 0, Y)
                            button:SetSize(1, 0, 0, 16)
                            button:SetText("Add AutoExec")
                            button.OnClick = function()
                                if script ~= "" then
                                    if scripts:IsAutoExec(script) then
                                        scripts:RemoveFromAutoExec(script)
                                    else
                                        scripts:AddToAutoExec(script, 1)
                                    end
                                    
                                    local autoexecon = scripts:IsAutoExec(script)
                                    if autoexecon then
                                        autoexec_button:SetText("Remove AutoExec")
                                    else
                                        autoexec_button:SetText("Add AutoExec")
                                    end

                                    for i, v in next, lualist.scrollpanel.canvas.children do
                                        local autoexecstate = scripts:IsAutoExec(v.path)
                                        v.children[3].text:SetText(autoexecstate and "ID " .. autoexecstate or "No")
                                    end
                                end
                            end
                            Y=Y+16+7
                        end

                        function lualist:OnSelected(row)
                            if script == row.path then
                                script = ""
                                script_name:SetText("No Script Selected")
                                script_state:SetText("State: N/A")
                                execute_button:SetText("Execute")
                                autoexec_button:SetText("Add AutoExec")
                                return
                            end
                            script = row.path

                            local state = scripts:GetState(script)
                            if state ~= "Running" then
                                execute_button:SetText("Execute")
                            elseif state == "Running" then
                                execute_button:SetText("Unload")
                            end
                            
                            if scripts:IsAutoExec(script) then
                                autoexec_button:SetText("Remove AutoExec")
                            else
                                autoexec_button:SetText("Add AutoExec")
                            end

                            script_name:SetText("Script: " .. script)
                            script_state:SetText("State: " .. scripts:GetState(script))
                        end

                        hook:Add("Scripts.Run", "BBOT:Menu.Scripts", function(name, func, state)
                            Refresh_List()
                            if script == name then
                                local state = scripts:GetState(script)
                                script_state:SetText("State: " .. state)
                                if state ~= "Running" then
                                    execute_button:SetText("Execute")
                                elseif state == "Running" then
                                    execute_button:SetText("Unload")
                                end
                                for i, v in next, lualist.scrollpanel.canvas.children do
                                    if v.path == name then
                                        v.children[2].text:SetText(state)
                                        break
                                    end
                                end
                            end
                        end)

                        hook:Add("Scripts.Unload", "BBOT:Menu.Scripts", function(name, func, state)
                            Refresh_List()
                            if script == name then
                                script_state:SetText("State: Idle")
                                execute_button:SetText("Execute")
                                for i, v in next, lualist.scrollpanel.canvas.children do
                                    if v.path == name then
                                        v.children[2].text:SetText("Idle")
                                        break
                                    end
                                end
                            end
                        end)

                        return container
                    end,
                    content = {},
                },
            }
        },
    }
}

hook:Call("PostStartup")

BBOT.timer:Async(function()
    local loadtime = (BBOT.math.round(tick()-BBOT.start_time, 6))
    local dbgfeatures = {}
    for k, v in next, BBOT.Debug do
        if v then
            dbgfeatures[#dbgfeatures+1] = k
        end
    end

    if #dbgfeatures > 0 then
        BBOT.notification:Create("!!! WARNING !!!\nThe following debugging features are enabled:\n" .. table.concat(dbgfeatures, "\n"), 30):SetType("alert")
    end

    BBOT.notification:Create("!!! IMPORTANT !!!\nThis is the Synapse 3.0 version,\nthere may be a lot of internal issues!\nReport any issues to WholeCream!", 30):SetType("alert")
    BBOT.notification:Create("!!! IMPORTANT !!!\nScripts system has been enabled, you have full access to the bitch bot environment!", 10):SetType("alert")
    if _BBOT then
        BBOT.notification:Create("There was an already active version of bbot running, this has been unloaded")
    end
    BBOT.notification:Create(string.format("Done loading the " .. BBOT.game .. " cheat. (%d ms)", loadtime*1000))
    BBOT.notification:Create("Press DELETE to open and close the menu!")
end)