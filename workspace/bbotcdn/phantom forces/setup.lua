local thread = BBOT.thread
local hook = BBOT.hook
local menu = BBOT.menu
local config = BBOT.config
local gui = BBOT.gui
local font = BBOT.font

local waited = 0
while true do
    if game:IsLoaded() then
        local lp = game:GetService("Players").LocalPlayer;
        local chatgame = lp.PlayerGui:FindFirstChild("ChatGame")
        if chatgame then
            local version = chatgame:FindFirstChild("Version")
            if version and not string.find(version.Text, "loading", 1, true) and not string.find(version.Text, "N/A", 1, true) then
                break
            end
        end
    end;
    waited = waited + 1
    if waited > 12 then
        BBOT:SetLoadingStatus("Something may be wrong... Contact the Demvolopers")
    elseif waited > 8 then
        BBOT:SetLoadingStatus("What the hell is taking so long?")
    end
    wait(1)
end;

local table = BBOT.table
local anims = {
    {
        type = "Toggle",
        name = "Enabled",
        value = false,
    },
    {
        type = "DropBox",
        name = "Type",
        value = 1,
        values = {"Additive", "Wave"},
    },
    {
        type = "Slider",
        name = "Offset",
        min = -1,
        max = 1,
        value = 0,
        decimal = 2,
        suffix = " stud(s)"
    },
    {
        type = "Slider",
        name = "Amplitude",
        min = -10,
        max = 10,
        value = 0,
        decimal = 2,
        suffix = "x"
    },
    {
        type = "Slider",
        name = "Speed",
        min = -10,
        max = 10,
        value = 0,
        decimal = 2,
        suffix = "x"
    },
}

local anims_color = {
    {
        type = "Toggle",
        name = "Enabled",
        value = false,
    },
    {
        type = "DropBox",
        name = "Type",
        value = 1,
        values = {"Fade", "Cycle"},
        extra = {
            {
                type = "ColorPicker",
                name = "Primary Color",
                color = { 255, 255, 255, 255 },
            },
            {
                type = "ColorPicker",
                name = "Secondary Color",
                color = { 0, 0, 0, 255 },
            },
        },
    },
    {
        type = "Slider",
        name = "Saturation",
        min = 0,
        max = 100,
        value = 0,
        decimal = 1,
        suffix = "%"
    },
    {
        type = "Slider",
        name = "Darkness",
        min = 0,
        max = 100,
        value = 0,
        decimal = 1,
        suffix = "%"
    },
    {
        type = "Slider",
        name = "Speed",
        min = -10,
        max = 10,
        value = 0,
        decimal = 2,
        suffix = "x"
    },
}

local skins_content = {
    {
        name = "Basics",
        pos = UDim2.new(0,0,0,0),
        size = UDim2.new(.5,-4,1/3,-4),
        type = "Panel",
        content = {
            {
                type = "Toggle",
                name = "Enabled",
                value = false,
                extra = {},
                tooltip = "Do note this is not server-sided!"
            },
            {
                type = "DropBox",
                name = "Material",
                value = 1,
                values = BBOT.config.enums.Material.List,
                extra = {
                    {
                        type = "ColorPicker",
                        name = "Brick Color",
                        color = { 255, 255, 255, 255 },
                        tooltip = "Changes the base color of the material, not the texture."
                    },
                },
            },
            {
                type = "Slider",
                name = "Reflectance",
                value = 0,
                min = 0,
                max = 200,
                suffix = "%",
                decimal = 1,
                extra = {},
                tooltip = "Gives the material reflectance, this may be buggy or not work on some materials."
            },
            {
                type = "Slider",
                name = "Color Modulation",
                value = 0,
                min = 1,
                max = 20,
                suffix = "x",
                decimal = 1,
                extra = {},
                tooltip = "Pushes the color system even further by multiplying it"
            },
        },
    },
    {
        name = "Texture",
        pos = UDim2.new(0,0,(1/3),4),
        size = UDim2.new(.5,-4,1-(1/3),-4),
        type = "Panel",
        content = {
            {
                type = "Toggle",
                name = "Enabled",
                value = false,
                extra = {},
            },
            {
                type = "Text",
                name = "Asset-Id",
                value = "3643887058",
                extra = {
                    {
                        type = "ColorPicker",
                        name = "Texture Color",
                        color = { 255, 255, 255, 255 },
                    },
                },
            },
            {
                type = "Slider",
                name = "Color Modulation",
                value = 0,
                min = 1,
                max = 20,
                suffix = "x",
                decimal = 1,
                extra = {},
                tooltip = "Pushes the color system even further by multiplying it"
            },
            {
                type = "Slider",
                name = "OffsetStudsU",
                value = 0,
                min = 0,
                max = 10,
                suffix = "studs",
                decimal = 1,
                extra = {},
            },
            {
                type = "Slider",
                name = "OffsetStudsV",
                value = 0,
                min = 0,
                max = 10,
                suffix = "studs",
                decimal = 1,
                extra = {},
            },
            {
                type = "Slider",
                name = "StudsPerTileU",
                value = 1,
                min = 0,
                max = 10,
                suffix = "studs/tile",
                decimal = 1,
                extra = {},
            },
            {
                type = "Slider",
                name = "StudsPerTileV",
                value = 1,
                min = 0,
                max = 10,
                suffix = "studs/tile",
                decimal = 1,
                extra = {},
            },
        },
    },
    {
        name = "Animations",
        pos = UDim2.new(.5,4,0,0),
        size = UDim2.new(.5,-4,1,0),
        type = "Panel",
        content = {
            {
                name = { "OSU", "OSV", "SPTU", "SPTV" },
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,.5,0),
                borderless = true,
                type = "Tabs",
                {
                    content = anims,
                    tooltip = "OffsetStuds changes the position of texture."
                },
                {
                    content = anims,
                    tooltip = "OffsetStuds changes the position of texture."
                },
                {
                    content = anims,
                    tooltip = "StudsPerTile changes the scale of texture."
                },
                {
                    content = anims,
                    tooltip = "StudsPerTile changes the scale of texture."
                },
            },
            {
                name = {"BC", "TC" },
                pos = UDim2.new(0,0,.5,0),
                size = UDim2.new(1,0,.5,0),
                borderless = true,
                type = "Tabs",
                {
                    content = anims_color,
                    tooltip = "Color change of brick color."
                },
                {
                    content = anims_color,
                    tooltip = "Color change of texture color."
                },
            },
        }
    },
}

local weapon_legit = {
    {
        name = "Aim Assist",
        pos = UDim2.new(0,0,0,0),
        size = UDim2.new(.5,-4,1,0),
        type = "Panel",
        content = {
            {
                type = "Toggle",
                name = "Enabled",
                value = true,
                tooltip = "Aim assistance only moves your mouse towards targets"
            },
            {
                type = "Slider",
                name = "Aimbot FOV",
                min = 0,
                max = 100,
                suffix = "°",
                value = 20
            },
            {
                type = "Toggle",
                name = "Dynamic FOV",
                value = false,
                tooltip = "Changes all FOV to change depending on the magnification."
            },
            {
                type = "Toggle",
                name = "Use Barrel",
                value = false,
                tooltip = "Instead of calculating the FOV from the camera, it uses the weapon barrel's direction."
            },
            {
                type = "Toggle",
                name = "Lock Target",
                value = true,
                tooltip = "Doesn't swap targets when you are targeting someone."
            },
            {
                type = "Toggle",
                name = "Enable On Move",
                value = false,
                tooltip = "Aim assistance only activates when moving your mouse."
            },
            {
                type = "Slider",
                name = "Start Smoothing",
                value = 120,
                min = 0,
                max = 200,
                suffix = "%",
            },
            {
                type = "Slider",
                name = "End Smoothing",
                min = 0,
                max = 200,
                suffix = "%",
                value = 20
            },
            {
                type = "Slider",
                name = "Smoothing Increment",
                min = 0,
                max = 300,
                suffix = "%/s",
                value = 220
            },
            {
                type = "Slider",
                name = "Randomization",
                value = 5,
                min = 0,
                mas = 20,
                suffix = "",
                custom = { [0] = "Off" },
            },
            {
                type = "Slider",
                name = "Deadzone FOV",
                value = 1,
                min = 0,
                max = 50,
                suffix = "°",
                decimal = 1,
                custom = { [0] = "Off" },
            },
            {
                type = "DropBox",
                name = "Aimbot Key",
                value = 1,
                values = { "Mouse 1", "Mouse 2", "Always", "Dynamic Always" },
            },
            {
                type = "DropBox",
                name = "Hitscan Priority",
                value = 1,
                values = { "Head", "Body", "Closest" },
            },
            {
                type = "ComboBox",
                name = "Hitscan Points",
                values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
            },
        },
    },
    {
        name = "Ballistics",
        pos = UDim2.new(.5,4,0,0),
        size = UDim2.new(.5,-4,4/10,-4),
        type = "Panel",
        content = {
            {
                type = "Toggle",
                name = "Barrel Compensation",
                value = true,
                tooltip = "Attempts to aim based on the direction of the barrel",
                extra = {}
            },
            {
                type = "ComboBox",
                name = "Disable Barrel Comp While",
                values = { { "Fire Animation", true }, { "Scoping In", true }, { "Reloading", true } }
            },
            {
                type = "Slider",
                name = "Barrel Comp X",
                value = 100,
                min = 0,
                max = 1000,
                suffix = "%",
                decimal = 1,
                custom = { [0] = "Off" },
            },
            {
                type = "Slider",
                name = "Barrel Comp Y",
                value = 100,
                min = 0,
                max = 1000,
                suffix = "%",
                decimal = 1,
                custom = { [0] = "Off" },
            },
            {
                type = "Toggle",
                name = "Drop Prediction",
                value = true,
            },
            {
                type = "Toggle",
                name = "Movement Prediction",
                value = true,
            },
        }
    },
    {
        name = {"Bullet Redirect", "Trigger Bot"},
        pos = UDim2.new(.5,4,4/10,4),
        size = UDim2.new(.5,-4,6/10,-4),
        type = "Panel",
        {content = {
            {
                type = "Toggle",
                name = "Enabled",
                value = false,
                unsafe = true,
            },
            {
                type = "Toggle",
                name = "Use Barrel",
                value = true,
                tooltip = "Instead of calculating the FOV from the camera, it uses the weapon barrel's direction."
            },
            {
                type = "Slider",
                name = "Redirection FOV",
                value = 5,
                min = 0,
                max = 180,
                suffix = "°",
            },
            {
                type = "Slider",
                name = "Hit Chance",
                value = 30,
                min = 0,
                max = 100,
                suffix = "%",
            },
            {
                type = "Slider",
                name = "Accuracy",
                value = 90,
                min = 0,
                max = 100,
                suffix = "%",
            },
            {
                type = "DropBox",
                name = "Hitscan Priority",
                value = 1,
                values = { "Head", "Body", "Closest" },
            },
            {
                type = "ComboBox",
                name = "Hitscan Points",
                values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
            },
        }},
        {content = {
            {
                type = "Toggle",
                name = "Enabled",
                value = false,
                extra = {
                    {
                        type = "ColorPicker",
                        name = "Dot Color",
                        color = { 255, 0, 0, 255 },
                    },
                    {
                        type = "KeyBind",
                        key = nil,
                        toggletype = 2,
                    },
                },
            },
            {
                type = "ComboBox",
                name = "Trigger Bot Hitboxes",
                values = { { "Head", true }, { "Body", true }, { "Arms", false }, { "Legs", false } },
            },
            {
                type = "Toggle",
                name = "Deadly Mode",
                value = false,
                indev = true,
                tooltip = "This feature is currently in the works!"
            },
            {
                type = "Toggle",
                name = "Trigger When Aiming",
                value = false,
            },
            {
                type = "Slider",
                name = "RPM Limiter",
                min = 0,
                max = 2000,
                value = 600,
                decimal = 0,
                suffix = " RPM",
                custom = {
                    [0] = "Instant"
                },
                tooltip = "Fires at a specific RPM"
            },
            {
                type = "Slider",
                name = "Trigger FOV",
                min = 0,
                max = 100,
                suffix = "°",
                value = 20,
                tooltip = "Prevents the trigger bot from targeting those outside of a viewpoint"
            },
            {
                type = "Slider",
                name = "Aim In Time",
                min = 0,
                max = 2,
                value = .75,
                decimal = 2,
                suffix = "s",
                tooltip = "Time it takes to activate trigger bot by aiming in"
            },
            {
                type = "Slider",
                name = "Fire Time",
                min = 0,
                max = .5,
                value = .1,
                decimal = 3,
                suffix = "s",
                tooltip = "How long you need to stay in the circle to fire"
            },
            {
                type = "Slider",
                name = "Sprint to Fire Time",
                min = 0,
                max = .5,
                value = .1,
                decimal = 3,
                suffix = "s",
                tooltip = "Time from sprinting to the ability to fire"
            },
        }},
    },
}

BBOT.configuration = {
    {
        -- The first layer here is the frame
        Id = "Main",
        name = "Bitch Bot",
        center = true,
        size = UDim2.new(0, 500, 0, 600),
        content = {
            {
                name = "Legit",
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,1,0),
                borderless = true,
                innerborderless = true,
                topbarsize = 40,
                type = "Tabs",
                content = {
                    {
                        name = "Pistol",
                        icon = "PISTOL",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(1,0,1,0),
                        type = "Container",
                        content = weapon_legit
                    },
                    {
                        name = "Smg",
                        icon = "SMG",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(1,0,1,0),
                        type = "Container",
                        content = weapon_legit
                    },
                    {
                        name = "Rifle",
                        icon = "RIFLE",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(1,0,1,0),
                        type = "Container",
                        content = weapon_legit
                    },
                    {
                        name = "Shotgun",
                        icon = "SHOTGUN",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(1,0,1,0),
                        type = "Container",
                        content = weapon_legit
                    },
                    {
                        name = "Sniper",
                        icon = "SNIPER",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(1,0,1,0),
                        type = "Container",
                        content = weapon_legit
                    },
                }
            },
            {
                name = "Rage",
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,1,0),
                type = "Container",
                content = {
                    {
                        name = "Aimbot",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(.5,-4,3.5/10,-4),
                        type = "Panel",
                        content = {
                            {
                                type = "Toggle",
                                name = "Rage Bot",
                                value = false,
                                unsafe = true,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    },
                                }
                            },
                            {
                                type = "Slider",
                                name = "Aimbot FOV",
                                value = 180,
                                min = 0,
                                max = 181,
                                suffix = "°",
                                custom = { [181] = "Ignored" },
                            },
                            {
                                type = "Toggle",
                                name = "Auto Wallbang",
                                value = false
                            },
                            {
                                type = "Slider",
                                name = "Auto Wallbang Scale",
                                value = 100,
                                min = 0,
                                max = 121,
                                suffix = "%",
                                custom = { [121] = "Screw Walls" },
                            },
                            {
                                type = "Toggle",
                                name = "Auto Shoot",
                                value = false,
                                tooltip = "Automatically shoots players when a target is found."
                            },
                            {
                                type = "DropBox",
                                name = "Hitscan Priority",
                                value = 1,
                                values = { "Head", "Body" },
                            },
                        }
                    },
                    {
                        name = {"HVH", "HVH Extras"},
                        pos = UDim2.new(0,0,3.5/10,4),
                        size = UDim2.new(.5,-4,1-(3.5/10),-4),
                        type = "Panel",
                        {content = {
                            {
                                type = "ComboBox",
                                name = "Hitbox Hitscan Points",
                                values = {
                                    { "Up", false },
                                    { "Down", false },
                                    { "Left", false },
                                    { "Right", false },
                                    { "Forward", false },
                                    { "Backward", false },
                                    { "Origin", true },
                                },
                                tooltip = "You do not need to turn these all on, points are rotated relative to the direction of the ragebot",
                            },
                            {
                                type = "Slider",
                                name = "Hitbox Shift Distance",
                                value = 4,
                                min = 1,
                                max = 12,
                                suffix = " studs",
                                tooltip = "As of PF update 5.6.2k, I suggest you use 4-5 shift for the best hit chances",
                            },
                            {
                                type = "ComboBox",
                                name = "FirePos Hitscan Points",
                                values = {
                                    { "Up", false },
                                    { "Down", false },
                                    { "Left", false },
                                    { "Right", false },
                                    { "Forward", false },
                                    { "Backward", false },
                                    { "Origin", true },
                                },
                                tooltip = "You do not need to turn these all on, points are rotated relative to the direction of the ragebot",
                            },
                            {
                                type = "Slider",
                                name = "FirePos Shift Distance",
                                value = 9,
                                min = 1,
                                max = 12,
                                suffix = " studs",
                                tooltip = "As of PF update 5.6.2k, I suggest you use 8-10 shift for the best hit chances",
                            },
                            {
                                type = "Slider",
                                name = "FirePos Shift Multi-Point",
                                value = 1,
                                min = 1,
                                max = 10,
                                decimal = 0,
                                suffix = "x",
                                tooltip = "Checks 'x' amount of points in between the origin and the shift position",
                            },
                            {
                                type = "ComboBox",
                                name = "TP Scanning Points",
                                values = {
                                    { "Up", false },
                                    { "Down", false },
                                    { "Left", false },
                                    { "Right", false },
                                    { "Forward", false },
                                    { "Backward", false },
                                },
                            },
                            {
                                type = "Slider",
                                name = "TP Scanning Multi-Point",
                                min = 1,
                                max = 8,
                                suffix = "x",
                                decimal = 0,
                                value = 1,
                                custom = {},
                                tooltip = "Creates multiple points to teleport towards",
                            },
                            {
                                type = "Slider",
                                name = "TP Scanning Distance",
                                min = 2,
                                max = 300,
                                suffix = " studs",
                                decimal = 1,
                                value = 25,
                                custom = {},
                            },
                            {
                                type = "Toggle",
                                name = "TP Scanning Shift",
                                value = false,
                                tooltip = "Uses FirePos shift in conjuction to TP scanning",
                            },
                        }},
                        {content={
                            {
                                type = "Slider",
                                name = "Hitbox Random Points",
                                min = 0,
                                max = 8,
                                suffix = " point(s)",
                                decimal = 0,
                                value = 0,
                                custom = {
                                    [0] = "Off"
                                },
                                tooltip = "Points that are placed randomly",
                            },
                            {
                                type = "ComboBox",
                                name = "Hitbox Static Points",
                                values = {
                                    { "Up", false },
                                    { "Down", false },
                                    { "Left", false },
                                    { "Right", false },
                                    { "Forward", false },
                                    { "Backward", false },
                                },
                                tooltip = "Points that do not rotate towards the target, in otherwords, static points",
                            },
                            {
                                type = "Slider",
                                name = "FirePos Random Points",
                                min = 0,
                                max = 8,
                                suffix = " point(s)",
                                decimal = 0,
                                value = 0,
                                custom = {
                                    [0] = "Off"
                                },
                                tooltip = "Points that are placed randomly",
                            },
                            {
                                type = "ComboBox",
                                name = "FirePos Static Points",
                                values = {
                                    { "Up", false },
                                    { "Down", false },
                                    { "Left", false },
                                    { "Right", false },
                                    { "Forward", false },
                                    { "Backward", false },
                                },
                                tooltip = "Points that do not rotate towards the target, in otherwords, static points",
                            },
                            {
                                type = "Toggle",
                                name = "Scan for Collaterals",
                                tooltip = "Sends hit packets for other enemies within 5 studs of the position you hit a target at.",
                                value = false
                            },
                        }}
                    },
                    {
                        name = { "Anti Aim", "Fake Lag" },
                        pos = UDim2.new(.5,4,0,0),
                        size = UDim2.new(.5,-4,1-(5.5/10),-4),
                        {content = {
                            {
                                type = "Toggle",
                                name = "Enabled",
                                value = false,
                                unsafe = true,
                                tooltip = "When this is enabled, your server-side yaw, pitch and stance are set to the values in this tab.",
                            },
                            {
                                type = "DropBox",
                                name = "Pitch",
                                value = 4,
                                values = {
                                    "Off",
                                    "Up",
                                    "Zero",
                                    "Down",
                                    "Upside Down",
                                    "Roll Forward",
                                    "Roll Backward",
                                    "Random",
                                    "Bob",
                                    "Glitch",
                                },
                            },
                            {
                                type = "DropBox",
                                name = "Yaw",
                                value = 2,
                                values = { "Forward", "Backward", "Spin", "Random", "Glitch Spin", "Stutter Spin", "Invisible" },
                            },
                            {
                                type = "Slider",
                                name = "In Floor",
                                value = 0,
                                min = 0,
                                max = 5,
                                suffix = " studs",
                                custom = {[0] = "Disabled"},
                                unsafe = true,
                                tooltip = "Puts you into the floor kinda..."
                            },
                            {
                                type = "DropBox",
                                name = "Fake Stance",
                                value = 1,
                                unsafe = true,
                                values = {"Off", "Stand", "Crouch", "Prone"},
                                tooltip = "Changes your stance server-side for others."
                            },
                        }},
                        {content = {}},
                    },
                    {
                        name = { "Extra", "Settings" },
                        pos = UDim2.new(.5,4,1-(5.5/10),4),
                        size = UDim2.new(.5,-4,(5.5/10),-4),
                        {content = {
                            {
                                type = "Toggle",
                                name = "Knife Bot",
                                value = false,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    }
                                },
                                unsafe = true,
                            },
                            {
                                type = "DropBox",
                                name = "Knife Bot Type",
                                value = 1,
                                values = { "Multi Aura" },
                            },
                            {
                                type = "DropBox",
                                name = "Knife Hitscan",
                                value = 1,
                                values = { "Head", "Body" },
                            },
                            {
                                type = "Toggle",
                                name = "Knife Visible Only",
                                value = false,
                            },
                            {
                                type = "Slider",
                                name = "Knife Range",
                                value = 26,
                                min = 1,
                                max = 26,
                                custom = {[26] = "Max"},
                                suffix = " studs",
                            },
                            {
                                type = "Slider",
                                name = "Knife Delay",
                                value = 0,
                                min = 0,
                                max = 1,
                                decimal = 2,
                                custom = {[0] = "Knife Party"},
                                suffix = "s",
                            },
                        }},
                        {content = {
                            {
                                type = "Toggle",
                                name = "Damage Prediction",
                                value = true,
                            },
                            {
                                type = "Slider",
                                name = "Damage Prediction Limit",
                                value = 100,
                                min = 0,
                                max = 300,
                                custom = {[0] = "What even is the point?"},
                                suffix = "hp",
                            },
                            {
                                type = "Toggle",
                                name = "Damage Prediction Spare",
                                value = true,
                                tooltip = "Hits them just enough to not kill them."
                            },
                            {
                                type = "Slider",
                                name = "Max Players",
                                value = 2,
                                min = 1,
                                max = 100,
                                decimal = 0,
                                custom = {[100] = "Are you good?"},
                                suffix = " player(s)",
                                tooltip = "The maximum amount of players to scan for each frame."
                            },
                            {
                                type = "Toggle",
                                name = "Relative Points Only",
                                value = true,
                                tooltip = "Makes the firepos and hitbox points align, so less calculations.",
                            },
                            {
                                type = "Toggle",
                                name = "Cross Relative Points Only",
                                value = true,
                                tooltip = "Makes the firepos and hitbox points align by cross, so less calculations.",
                            },
                            {
                                type = "Toggle",
                                name = "Resolver",
                                value = false,
                                unsafe = true,
                                tooltip = "Rage aimbot attempts to resolve player offsets and positions, Disable if you are having issues with resolver.",
                            },
                            {
                                type = "DropBox",
                                name = "Velocity Modifications",
                                value = 1,
                                unsafe = true,
                                values = { "Off", "Zero", "Tick", "Ping" },
                                tooltip = "Corrects velocity of players.",
                            },
                            {
                                type = "Toggle",
                                name = "Priority Only",
                                value = false,
                                tooltip = "Aimbot only targets prioritized players.",
                            },
                            {
                                type = "Toggle",
                                name = "Priority Last",
                                value = false,
                                tooltip = "Aimbot automatically prioritized the last player who killed you.",
                            },
                        }},
                    }
                },
            },
            {
                name = "Visuals",
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,1,0),
                type = "Container",
                content = {
                    {
                        name = { "Enemy ESP", "Team ESP", "Local" },
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(.5,-4,11/20,-4),
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Enabled",
                                    value = false,
                                    tooltip = "Enables 2D rendering, disabling this could improve performance. Does not affect Chams."
                                },
                                {
                                    type = "Toggle",
                                    name = "Name",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 200 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Box",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color Outline",
                                            color = { 0, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Fill",
                                            color = { 255, 0, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Box",
                                            color = { 255, 0, 0, 150 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Health Bar",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color Low",
                                            color = { 255, 0, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Max",
                                            color = { 0, 255, 0, 150 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Health Number",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 255 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Held Weapon",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 200 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Held Weapon Icon",
                                    value = false,
                                },
                                {
                                    type = "ComboBox",
                                    name = "Flags",
                                    values = { { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }, { "Backtrack", false }, { "Visible Only", false }, { "Priority Only", false }, { "Friends Only", false }  },
                                },
                                {
                                    type = "Toggle",
                                    name = "Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Visible Chams",
                                            color = { 255, 0, 0, 200 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Invisible Chams",
                                            color = { 100, 0, 0, 100 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Out of View",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Outline Color",
                                            color = { 0, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Arrow Color",
                                            color = { 255, 255, 255, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Slider",
                                    name = "Arrow Distance",
                                    value = 50,
                                    min = 10,
                                    max = 101,
                                    custom = { [101] = "Max" },
                                    suffix = "%",
                                },
                                {
                                    type = "Toggle",
                                    name = "Dynamic Arrow Size",
                                    value = false,
                                },
                                {
                                    type = "Toggle",
                                    name = "Sound Arrows",
                                    value = false,
                                    tooltip = "These arrows only appear when certain audio is played."
                                },
                                {
                                    type = "Toggle",
                                    name = "Sound Dots",
                                    value = false,
                                    tooltip = "Shows where the sound was played from on screen.",
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Outline Color",
                                            color = { 0, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Dot Color",
                                            color = { 255, 0, 0, 255 },
                                        },
                                    },
                                },
                            },
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Enabled",
                                    value = false,
                                    tooltip = "Enables 2D rendering, disabling this could improve performance. Does not affect Chams."
                                },
                                {
                                    type = "Toggle",
                                    name = "Name",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 200 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Box",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color Outline",
                                            color = { 0, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Fill",
                                            color = { 0, 255, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Box",
                                            color = { 0, 255, 0, 150 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Health Bar",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color Low",
                                            color = { 255, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Max",
                                            color = { 0, 255, 0, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Health Number",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Held Weapon",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 200 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Held Weapon Icon",
                                    value = false,
                                },
                                {
                                    type = "ComboBox",
                                    name = "Flags",
                                    values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }, { "Priority Only", false }, { "Friends Only", false } },
                                },
                                {
                                    type = "Toggle",
                                    name = "Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Visible Chams",
                                            color = { 0, 255, 0, 200 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Invisible Chams",
                                            color = { 0, 100, 0, 100 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Skeleton",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Team skeleton",
                                            color = { 255, 255, 255, 120 },
                                        },
                                    },
                                },
                            },
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Enabled",
                                    value = false,
                                    tooltip = "Enables 2D rendering, disabling this could improve performance. Does not affect Chams."
                                },
                                {
                                    type = "Toggle",
                                    name = "Name",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 200 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Box",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color Outline",
                                            color = { 0, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Fill",
                                            color = { 127, 72, 163, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Box",
                                            color = { 127, 72, 163, 150 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Health Bar",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color Low",
                                            color = { 255, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Color Max",
                                            color = { 0, 255, 0, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Health Number",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Held Weapon",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 255, 255, 200 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Held Weapon Icon",
                                    value = false,
                                },
                                {
                                    type = "ComboBox",
                                    name = "Flags",
                                    values = { { "Use Large Text", false }, { "Level", false }, { "Distance", false }, { "Frozen", true }, { "Resolved", false }  },
                                },
                                {
                                    type = "Toggle",
                                    name = "Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Visible Chams",
                                            color = { 127, 72, 163, 200 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Invisible Chams",
                                            color = { 127, 72, 163, 100 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Skeleton",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Team skeleton",
                                            color = { 255, 255, 255, 120 },
                                        },
                                    },
                                },
                            }
                        },
                    },
                    {
                        name = {"ESP Settings", "Crosshair"},
                        pos = UDim2.new(0,0,11/20,4),
                        size = UDim2.new(.5,-4,9/20,-4),
                        type = "Panel",
                        {content = {
                            {
                                type = "DropBox",
                                name = "ESP Text Font",
                                value = font_index,
                                values = font:GetFonts(),
                                onopen = function(dropbox)
                                    font:RegisterAssets()
                                    local fonts = font:GetFonts()
                                    local cfgdata = config:GetRaw(unpack(dropbox.path))
                                    cfgdata.values = fonts
                                    dropbox:SetOptions(fonts)
                                end
                            },
                            {
                                type = "Slider",
                                name = "ESP Text Size",
                                value = 14,
                                min = 10,
                                max = 30,
                                decimal = 0,
                                custom = {},
                                suffix = "",
                            },
                            {
                                type = "Slider",
                                name = "ESP Fade Time", 
                                value = 0.5,
                                min = 0,
                                max = 2,
                                suffix = "s",
                                decimal = 1,
                                custom = { [0] = "Off" }
                            },
                            {
                                type = "Toggle",
                                name = "Highlight Target",
                                value = false,
                                extra = {
                                    {
                                        type = "ColorPicker",
                                        name = "Aimbot Target",
                                        color = { 255, 0, 0, 255 },
                                    }
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Highlight Friends",
                                value = true,
                                extra = {
                                    {
                                        type = "ColorPicker",
                                        name = "Friended Players",
                                        color = { 0, 255, 255, 255 },
                                    }
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Highlight Priority",
                                value = true,
                                extra = {
                                    {
                                        type = "ColorPicker",
                                        name = "Priority Players",
                                        color = { 255, 210, 0, 255 },
                                    }
                                },
                            },
                        }},
                        {content={
                            {
                                type = "Toggle",
                                name = "Enabled",
                                value = false,
                                extra = {
                                    {
                                        type = "ColorPicker",
                                        name = "Outter",
                                        color = { 0, 0, 0, 255 },
                                    },
                                    {
                                        type = "ColorPicker",
                                        name = "Inner",
                                        color = { 127, 72, 163, 255 },
                                    },
                                },
                            },
                            {
                                type = "ComboBox",
                                name = "Setup",
                                values = {{"Top",true},{"Bottom",true},{"Left",true},{"Right",true},{"Center",true}}
                            },
                            {
                                type = "Slider",
                                name = "Width",
                                value = 2,
                                min = 1,
                                max = 200,
                                decimal = 0,
                                suffix = "px",
                            },
                            {
                                type = "Slider",
                                name = "Height",
                                value = 15,
                                min = 1,
                                max = 200,
                                decimal = 0,
                                suffix = "px",
                            },
                            {
                                type = "Slider",
                                name = "Gap",
                                value = 25,
                                min = 0,
                                max = 200,
                                decimal = 0,
                                suffix = "px",
                            },
                            {
                                type = "Toggle",
                                name = "Animations",
                                value = false,
                            },
                            {
                                type = "DropBox",
                                name = "Animation Type",
                                value = 1,
                                values = { "Additive", "Wave" },
                            },
                            {
                                type = "Slider",
                                name = "Animation Speed",
                                value = 20,
                                min = -500,
                                max = 500,
                                custom = { [0] = "Nothing..." },
                                suffix = "",
                            },
                            {
                                type = "Slider",
                                name = "Animation Amplitude",
                                value = 5,
                                min = -100,
                                max = 100,
                                custom = { [0] = "Nothing..." },
                                suffix = "",
                            },
                        }}
                    },
                    {
                        name = {"Camera Visuals", "Extra"},
                        pos = UDim2.new(.5,4,0,0),
                        size = UDim2.new(.5,-8,1/2,-4),
                        {
                            content = {
                                {
                                    type = "Slider",
                                    name = "Camera FOV",
                                    value = 80,
                                    min = 60,
                                    max = 120,
                                    suffix = "°",
                                },
                                {
                                    type = "Toggle",
                                    name = "No Camera Bob",
                                    value = false,
                                    extra = {},
                                    tooltip = "Disables the camera bob.",
                                },
                                {
                                    type = "Toggle",
                                    name = "No Scope Border",
                                    value = false,
                                    extra = {},
                                    tooltip = "Disables scope borders.",
                                },
                                {
                                    type = "Toggle",
                                    name = "Third Person",
                                    value = false,
                                    extra = {
                                        {
                                            type = "KeyBind",
                                            key = nil,
                                            toggletype = 2,
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Third Person Absolute",
                                    value = false,
                                    extra = {},
                                    tooltip = "Forces the L3P character to be exactly on you.",
                                },
                                {
                                    type = "Toggle",
                                    name = "First Person Third",
                                    value = false,
                                    extra = {},
                                    tooltip = "See through the eyes of L3P",
                                },
                                {
                                    type = "Slider",
                                    name = "Third Person Distance",
                                    value = 60,
                                    min = -10,
                                    max = 150,
                                },
                                {
                                    type = "Slider",
                                    name = "Third Person X Offset",
                                    value = 0,
                                    min = -50,
                                    max = 50,
                                },
                                {
                                    type = "Slider",
                                    name = "Third Person Y Offset",
                                    value = 0,
                                    min = -50,
                                    max = 50,
                                },
                                {
                                    type = "Toggle",
                                    name = "FreeCam",
                                    value = false,
                                    extra = {
                                        {
                                            type = "KeyBind",
                                            key = nil,
                                            toggletype = 2,
                                        },
                                    },
                                },
                            },
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Show Keybinds",
                                    value = false,
                                    extra = {},
                                },
                                {
                                    type = "Toggle",
                                    name = "Log Keybinds",
                                    value = false
                                },
                                {
                                    type = "Toggle",
                                    name = "Arm Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Sleeve Color",
                                            color = { 106, 136, 213, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Hand Color",
                                            color = { 181, 179, 253, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "DropBox",
                                    name = "Arm Material",
                                    value = 1,
                                    values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                                },
                                {
                                    type = "Toggle",
                                    name = "Remove Weapon Skin",
                                    value = false,
                                    tooltip = "If a loaded weapon has a skin, it will remove it.",
                                },
                                {
                                    type = "Toggle",
                                    name = "KillCam Timer",
                                    value = false,
                                    tooltip = "Shows a timer when killcams stop spectating.",
                                },
                                {
                                    type = "Toggle",
                                    name = "Spectator Bullets",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Hit Color",
                                            color = { 255, 0, 0, 255 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Trace Color",
                                            color = { 255, 255, 255, 255 },
                                        },
                                    },
                                    tooltip = "Shows the path of bullets when spectating"
                                },
                                {
                                    type = "Slider",
                                    name = "Spectator Bullet Duration",
                                    value = .5,
                                    min = .1,
                                    max = 2,
                                    decimal = 1,
                                    suffix = "s",
                                },
                            },
                        },
                    },
                    {
                        name = {"World", "Misc", "FOV"},
                        pos = UDim2.new(.5,4,1/2,4),
                        size = UDim2.new(.5,-8,(12/20)/2,-8),
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Ambience",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Inside Ambience",
                                            color = { 117, 76, 236 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Outside Ambience",
                                            color = { 117, 76, 236 },
                                        }
                                    },
                                    tooltip = "Changes the map's ambient colors to your defined colors.",
                                },
                                {
                                    type = "Toggle",
                                    name = "Force Time",
                                    value = false,
                                    tooltip = "Forces the time to the time set by your below.",
                                },
                                {
                                    type = "Slider",
                                    name = "Custom Time",
                                    value = 0,
                                    min = 0,
                                    max = 24,
                                    decimal = 1,
                                    suffix = "hr",
                                },
                                {
                                    type = "Toggle",
                                    name = "Custom Saturation",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Saturation Tint",
                                            color = { 255, 255, 255 },
                                        },
                                    },
                                    tooltip = "Adds custom saturation the image of the game.",
                                },
                                {
                                    type = "Slider",
                                    name = "Saturation Density",
                                    value = 0,
                                    min = 0,
                                    max = 100,
                                    suffix = "%",
                                },
                            },
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Ragdoll Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Ragdoll Chams",
                                            color = { 106, 136, 213, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "DropBox",
                                    name = "Ragdoll Material",
                                    value = 1,
                                    values = { "Plastic", "Ghost", "Neon", "Foil", "Glass" },
                                },
                                {
                                    type = "Toggle",
                                    name = "Bullet Tracers",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Tracer Color",
                                            color = { 201, 69, 54, 255 },
                                        },
                                    },
                                }
                            },
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Enabled",
                                    value = true,
                                },
                                {
                                    type = "Toggle",
                                    name = "Aim Assist",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 127, 72, 163, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Aim Assist Line",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 127, 72, 163, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Aim Assist Deadzone",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 50, 50, 50, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Bullet Redirect",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 163, 72, 127, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Bullet Redirect Line",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 163, 72, 127, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Trigger Bot",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 0, 68, 255, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Ragebot",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Color",
                                            color = { 255, 210, 0, 255 },
                                        },
                                    },
                                },
                            },
                        },
                    },
                    {
                        name = {"Weapons", "Grenades", "Pickups"},
                        pos = UDim2.new(.5,4,(1/2) + ((12/20)/2),4),
                        size = UDim2.new(.5,-8,(8/20)/2,-4),
                        type = "Tabs",
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Weapon Names",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Weapon Names",
                                            color = { 255, 255, 255, 255 },
                                        },
                                    },
                                    tooltip = "Displays dropped weapons as you get closer to them, Highlights the weapon with the same ammo type as what you are holding.",
                                },
                                {
                                    type = "Toggle",
                                    name = "Weapon Icons",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Weapon Icons",
                                            color = { 255, 255, 255, 255 },
                                        },
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Weapon Ammo",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Same Weapon Ammo",
                                            color = { 0, 240, 0, 150 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Weapon Ammo",
                                            color = { 61, 168, 235, 150 },
                                        },
                                    },
                                },
                            }
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "Grenade Warning",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Warning Color",
                                            color = { 68, 92, 227 },
                                        }
                                    },
                                    tooltip = "Displays where grenades that will deal damage to you will land and the damage they will deal.",
                                },
                                {
                                    type = "Toggle",
                                    name = "Grenade Prediction",
                                    value = true,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Prediction Color",
                                            color = { 68, 92, 227 },
                                        }
                                    },
                                    tooltip = "Shows where your grenades may land before throwing it.",
                                },
                            },
                        },
                        {
                            content = {
                                {
                                    type = "Toggle",
                                    name = "DogTags",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Enemy Color",
                                            color = { 240, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Friendly Color",
                                            color = { 0, 240, 240 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "DogTag Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Enemy Color",
                                            color = { 240, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Friendly Color",
                                            color = { 0, 240, 240 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Flags",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Enemy Color",
                                            color = { 240, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Friendly Color",
                                            color = { 0, 240, 240 },
                                        }
                                    },
                                },
                                {
                                    type = "Toggle",
                                    name = "Flag Chams",
                                    value = false,
                                    extra = {
                                        {
                                            type = "ColorPicker",
                                            name = "Enemy Color",
                                            color = { 240, 0, 0 },
                                        },
                                        {
                                            type = "ColorPicker",
                                            name = "Friendly Color",
                                            color = { 0, 240, 240 },
                                        }
                                    },
                                },
                            },
                        }
                    },
                },
            },
            {
                name = "Misc",
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,1,0),
                type = "Container",
                content = {
                    {
                        name = {"Movement", "Tweaks", "Chat Spam"},
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(.5,-4,5.5/10,-4),
                        type = "Panel",
                        {content = {
                            {
                                type = "Toggle",
                                name = "Fly",
                                value = false,
                                unsafe = true,
                                tooltip = "Manipulates your velocity to make you fly.\nUse 60 speed or below to never get flagged.",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        key = "B",
                                        toggletype = 2,
                                    }
                                },
                            },
                            {
                                type = "Slider",
                                name = "Fly Speed",
                                min = 0,
                                max = 400,
                                suffix = " stud/s",
                                decimal = 1,
                                value = 55,
                                custom = {
                                    [400] = "Absurdly Fast",
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Auto Jump",
                                value = false,
                                tooltip = "When you hold the spacebar, it will automatically jump repeatedly, ignoring jump delay.",
                            },
                            {
                                type = "Toggle",
                                name = "Speed",
                                value = false,
                                unsafe = true,
                                tooltip = "Manipulates your velocity to make you move faster, unlike fly it doesn't make you fly.\nUse 60 speed or below to never get flagged.",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        key = nil,
                                        toggletype = 4,
                                    }
                                },
                            },
                            {
                                type = "DropBox",
                                name = "Speed Type",
                                value = 1,
                                values = { "Always", "In Air", "On Hop" },
                            },
                            {
                                type = "Slider",
                                name = "Speed Factor",
                                value = 40,
                                min = 1,
                                max = 400,
                                suffix = " stud/s",
                            },
                            {
                                type = "Toggle",
                                name = "Avoid Collisions",
                                value = false,
                                tooltip = "Attempts to stops you from running into obstacles\nfor Speed and Circle Strafe.",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 4,
                                    }
                                }
                            },
                            {
                                type = "Slider",
                                name = "Avoid Collisions Scale",
                                value = 100,
                                min = 0,
                                max = 100,
                                suffix = "%",
                            },
                            {
                                type = "Toggle",
                                name = "Circle Strafe",
                                value = false,
                                tooltip = "When you hold this keybind, it will strafe in a perfect circle.\nSpeed of strafing is borrowed from Speed Factor.",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        key = nil,
                                        toggletype = 2,
                                    }
                                },
                            },
                            {
                                type = "Slider",
                                name = "Circle Strafe Scale",
                                value = 20,
                                min = 0,
                                max = 100,
                                suffix = "x",
                            },
                        }},
                        {content = {
                            {
                                type = "Toggle",
                                name = "Jump Power",
                                value = false,
                                tooltip = "Shifts movement jump power by X%.",
                                unsafe = true
                            },
                            {
                                type = "Slider",
                                name = "Jump Power Percentage",
                                value = 150,
                                min = 0,
                                max = 1000,
                                suffix = "%",
                            },
                            {
                                type = "Toggle",
                                name = "Prevent Fall Damage",
                                value = false,
                                unsafe = true
                            },
                            {
                                type = "Toggle",
                                name = "Impact Grenades",
                                value = false,
                                unsafe = true
                            },
                            {
                                type = "Slider",
                                name = "Impact Grenade Time",
                                value = 0,
                                min = 0,
                                max = 2,
                                suffix = "s",
                                tooltip = "Adds a little bit more time before an exploding"
                            },
                            {
                                type = "Toggle",
                                name = "Safety Grenades",
                                value = false,
                                unsafe = true
                            },
                            {
                                type = "Toggle",
                                name = "Insta Throw Grenades",
                                value = false,
                                unsafe = true
                            },
                            {
                                type = "Toggle",
                                name = "Grenade Distance Speed",
                                value = false,
                                unsafe = true,
                                tooltip = "Modifies the speed based on distance"
                            },
                            {
                                type = "Slider",
                                name = "Grenade Speed",
                                value = 100,
                                min = 0,
                                max = 600,
                                unsafe = true,
                                suffix = "%",
                            },
                        }},
                        {content = {
                            {
                                type = "Toggle",
                                name = "Enabled",
                                value = false,
                                tooltip = "Try not to turn this on when playing legit :)\nWARNING: This could make anti-votekick break due to chat limitations!",
                                unsafe = true
                            },
                            {
                                type = "DropBox",
                                name = "Presets",
                                value = 1,
                                values = {"Bitch Bot", "Chinese Propaganda", "Youtube Title", "Emojis", "Deluxe", "t0nymode", "Douchbag", "ni shi zhong guo ren ma?", "Custom"},
                            },
                            {
                                type = "Slider",
                                name = "Spam Delay",
                                min = 2,
                                max = 10,
                                suffix = "s",
                                decimal = 1,
                                value = 1.5,
                                custom = {},
                            },
                            {
                                type = "Slider",
                                name = "Newline Mixer",
                                min = 4,
                                max = 50,
                                suffix = " sets",
                                decimal = 0,
                                value = 5,
                                custom = {
                                    [4] = "Disabled",
                                },
                                tooltip = "Instead of showing each line, it mixes lines together.",
                            },
                            {
                                type = "Toggle",
                                name = "Newline Mixer Spaces",
                                value = false,
                                tooltip = "Adds spaces in-between newline based chat spams",
                            },
                            {
                                type = "Toggle",
                                name = "Spam On Kills",
                                value = true,
                                tooltip = "Makes the chat spammer only spam per kill, extra synatxes are added such as {weapon}, {player}, {hitpart}",
                            },
                            {
                                type = "Slider",
                                name = "Minimum Kills",
                                min = 0,
                                max = 15,
                                suffix = " kill(s)",
                                decimal = 0,
                                value = 0,
                                custom = {
                                    [0] = "Spam Immediately",
                                },
                            },
                            {
                                type = "Slider",
                                name = "Start Delay",
                                min = 0,
                                max = 10,
                                suffix = "s",
                                decimal = 1,
                                value = 0,
                                custom = {
                                    [0] = "Spam Immediately",
                                },
                            },
                        }}
                    },
                    {
                        name = {"Server Hopper", "Votekick"},
                        pos = UDim2.new(0,0,5.5/10,4),
                        size = UDim2.new(.5,-4,1-(5.5/10),-4),
                        type = "Panel",
                        {content = {
                            {
                                type = "Toggle",
                                name = "Hop On Kick",
                                value = false,
                                unsafe = true,
                                tooltip = "This will auto-hop you to your desired servers when kicked.",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        name = "Force Server Hop",
                                        toggletype = 4,
                                        tooltip = "This will hop you when you press this."
                                    }
                                }
                            },
                            {
                                type = "Slider",
                                name = "Hop Delay",
                                min = 0,
                                max = 20,
                                suffix = "s",
                                decimal = 1,
                                value = 0,
                                custom = {},
                                tooltip = "Delays server hopper by a certain amount of seconds."
                            },
                            {
                                type = "DropBox",
                                name = "Sorting",
                                value = 1,
                                values = {"Lowest Players", "Highest Players", "Shuffle"},
                            },
                            {
                                type = "Button",
                                name = "Get JobId",
                                confirm = "Are you sure?",
                                clicked = "Copied to clipboard!",
                                callback = function()
                                    setclipboard(game.JobId)
                                end
                            },
                            {
                                type = "Button",
                                name = "Clear Blacklist",
                                confirm = "Are you sure 100%?",
                                tooltip = "This will clear the server blacklist, careful as this would mean you may join votekicked servers!",
                                callback = function()
                                    BBOT.serverhopper:ClearBlacklist()
                                end
                            },
                            {
                                type = "Button",
                                name = "Rejoin",
                                confirm = "Are you sure?",
                                unsafe = true,
                                callback = function()
                                    BBOT.serverhopper:Hop(game.JobId)
                                end
                            },
                            {
                                type = "Button",
                                name = "Hop",
                                confirm = "Are you sure?",
                                unsafe = true,
                                callback = function()
                                    BBOT.serverhopper:RandomHop()
                                end
                            },
                        }},
                        {content = {
                            {
                                type = "Toggle",
                                name = "Anti Votekick",
                                value = false,
                                unsafe = true,
                                tooltip = "WARNING: This requires 2 or more rank 25 accounts to work! You can do 1 rank 25 but it would only delay a votekick by ~90-120 seconds",
                            },
                            {
                                type = "Text",
                                name = "Reason",
                                value = "Aimbot",
                            },
                            {
                                type = "Slider",
                                name = "Votekick On Kills",
                                min = 0,
                                max = 30,
                                suffix = " kills",
                                decimal = 0,
                                value = 4,
                                custom = {
                                    [0] = "Instantaneous Kick",
                                },
                                tooltip = "Delays votekick once at a certain amount of kills."
                            },
                            {
                                type = "Toggle",
                                name = "Auto Hop",
                                value = false,
                                tooltip = "Server hops you just before they get a chance to place a votekick.",
                                extra = {}
                            },
                            {
                                type = "Slider",
                                name = "Hop Trigger Time",
                                min = 5,
                                max = 40,
                                suffix = "s",
                                decimal = 0,
                                value = 12,
                                custom = {},
                                tooltip = "The time at which a hop should be triggered"
                            },
                        }},
                    },
                    {
                        name = {"Extra", "Sounds", "Exploits"},
                        pos = UDim2.new(.5,4,0,0),
                        size = UDim2.new(.5,-4,1,0),
                        type = "Panel",
                        {content = {
                            {
                                type = "Toggle",
                                name = "Auto Nade Spam",
                                value = false,
                                unsafe = true,
                                tooltip = "Spams grenades regardless."
                            },
                            {
                                type = "Toggle",
                                name = "Auto Death On Nades",
                                value = false,
                                unsafe = true,
                                tooltip = "Resets yourself when nades are depleted."
                            },
                            {
                                type = "Toggle",
                                name = "Disable 3D Rendering",
                                value = false,
                                extra = {},
                            },
                            {
                                type = "Slider",
                                name = "FPS Limiter",
                                min = 5,
                                max = 300,
                                suffix = " fps",
                                decimal = 0,
                                value = 144,
                                custom = {
                                    [5] = "Slide Show",
                                    [300] = "Unlimited"
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Auto Spawn",
                                value = false,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    }
                                }
                            },
                            {
                                type = "Toggle",
                                name = "Spawn On Alive",
                                value = false,
                                unsafe = true,
                                tooltip = "Auto Spawn only spawns when enemies are present."
                            },
                            {
                                type = "Toggle",
                                name = "Streamer Mode",
                                value = false,
                                tooltip = "Hides critical information to prevent moderators from identifying your server."
                            },
                            {
                                type = "Toggle",
                                name = "Auto Friend Accounts",
                                value = true,
                                tooltip = "Automatically friends accounts that you have used."
                            },
                            {
                                type = "Toggle",
                                name = "Friends Votes No",
                                value = false,
                                tooltip = "Automatically votes no on votekicks on friends."
                            },
                            {
                                type = "Toggle",
                                name = "Assist Votekicks",
                                value = false,
                                tooltip = "Assists friend's votekicks by voting yes."
                            },
                            {
                                type = "Slider",
                                name = "Auto Hop On Friends",
                                min = 0,
                                max = 4,
                                suffix = " friends",
                                decimal = 0,
                                value = 0,
                                custom = {
                                    [0] = "Disabled",
                                },
                                unsafe = true,
                                tooltip = "hops if a server contains a certain amount of friends, useful for botting."
                            },
                            {
                                type = "Toggle",
                                name = "Reset On Enemy Spawn",
                                value = false,
                                unsafe = true,
                                tooltip = "Resets when an enemy spawns in, useful for botting."
                            },
                            {
                                type = "Toggle",
                                name = "Anti AFK",
                                value = false,
                                unsafe = true,
                            },
                            {
                                type = "Toggle",
                                name = "Simple Characters",
                                value = false,
                                unsafe = true,
                                tooltip = "Disables higher-end character rendering."
                            },
                            {
                                type = "Button",
                                name = "Banlands",
                                confirm = "Are you 100% sure?",
                                unsafe = true,
                                callback = function()
                                    BBOT.aux.network:send("logmessage", "Fuck this shit I'm out")
                                end,
                                tooltip = "Yeets you to the banlands private server, (DOING THIS WILL BAN YOUR ACCOUNT)"
                            },
                            {
                                type = "Button",
                                name = "Roll All Cases",
                                confirm = "Are you sure?",
                                callback = function()
                                    BBOT.misc:RollCases()
                                end,
                                tooltip = "Automatically rolls all cases in your inventory that has case keys for it. This could lag your game if you have many cases in your inventory!"
                            },
                            {
                                type = "Button",
                                name = "Sell All Skins",
                                confirm = "Are you sure?",
                                callback = function()
                                    BBOT.misc:SellSkins()
                                end,
                                tooltip = "Sells all skins in your inventory. Use this with caution, as it rolls *any and all* skins. While this is a quick way to gain some easy money, this could lag your game if you have many skins in your inventory!"
                            },
                            { -- TODO: Auto Roll Cases & Auto Sell Skins
                                type = "Toggle",
                                name = "Auto Roll Cases",
                                tooltip = "Automatically rolls cases when you receive them.",
                                indev = true
                            },
                            {
                                type = "Toggle",
                                name = "Auto Sell Skins",
                                tooltip = "Automatically sells skins when they are rolled.",
                                indev = true
                            }
                        }},
                        {content = {
                            {
                                type = "Text",
                                name = "Hit",
                                value = "6229978482",
                                tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
                            },
                            {
                                type = "Slider",
                                name = "Hit Volume",
                                min = 0,
                                max = 300,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                custom = {},
                            },
                            {
                                type = "Text",
                                name = "Headshot",
                                value = "6229978482",
                                tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
                            },
                            {
                                type = "Slider",
                                name = "Headshot Volume",
                                min = 0,
                                max = 300,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                custom = {},
                            },
                            {
                                type = "Text",
                                name = "Kill",
                                value = "6229978482",
                                tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
                            },
                            {
                                type = "Slider",
                                name = "Kill Volume",
                                min = 0,
                                max = 300,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                custom = {},
                            },
                            {
                                type = "Text",
                                name = "Headshot Kill",
                                value = "6229978482",
                                tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
                            },
                            {
                                type = "Slider",
                                name = "Headshot Kill Volume",
                                min = 0,
                                max = 300,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                custom = {},
                            },
                            {
                                type = "Text",
                                name = "Fire",
                                value = "",
                                tooltip = "The Roblox sound ID or file inside of synapse workspace to play when Kill Sound is on."
                            },
                            {
                                type = "Slider",
                                name = "Fire Volume",
                                min = 0,
                                max = 300,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                custom = {},Fire
                            },
                        }},
                        {content = {
                            --[[{
                                type = "Toggle",
                                name = "Bypass Speed Checks",
                                value = false,
                                tooltip = "Attempts to bypass maximum speed limit on the server."
                            },]]
                            {
                                type = "Toggle",
                                name = "Spaz Attack",
                                value = false,
                                unsafe = true,
                                tooltip = "Literally makes you look like your having a stroke.",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    },
                                }
                            },
                            {
                                type = "Slider",
                                name = "Spaz Attack Intensity",
                                min = 0.1,
                                max = 20,
                                suffix = "",
                                decimal = 1,
                                value = 3,
                                custom = {
                                    [8] = "Unbearable",
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Click TP",
                                value = false,
                                unsafe = true,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        key = nil,
                                        toggletype = 4
                                    }
                                },
                                tooltip = "Ez clap TP",
                            },
                            {
                                type = "Slider",
                                name = "Click TP Range",
                                min = 0,
                                max = 200,
                                suffix = " studs",
                                decimal = 1,
                                value = 50,
                                custom = {
                                    [0] = "Fucking Insane",
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Teleport to Player",
                                value = false,
                                unsafe = true,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        key = nil,
                                        toggletype = 4--? i'm not sure
                                    }
                                },
                            },
                            {
                                type = "ComboBox",
                                name = "Auto Teleport",
                                values = {
                                    { "On Spawn", false },
                                    { "On Enemy Spawn", false },
                                    { "Enemies Alive", false },
                                },
                                unsafe = true,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        key = nil,
                                        toggletype = 2--? i'm not sure
                                    },
                                    {
                                        type = "ColorPicker",
                                        name = "Path Color",
                                        color = { 127, 72, 163, 150 },
                                    }
                                },
                            },
                            {
                                type = "Toggle",
                                name = "Noclip",
                                value = false,
                                unsafe = true,
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2 -- what
                                    }
                                }
                            },
                            --[[{
                                type = "Toggle",
                                name = "Invisibility",
                                value = false,
                                tooltip = "Wtf where did he go?",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    }
                                }
                            },
                            {
                                type = "Toggle",
                                name = "Client Crasher",
                                value = false,
                                tooltip = "Dear god...",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    }
                                }
                            },]]
                            {
                                type = "Button",
                                name = "Crash Server",
                                value = false,
                                unsafe = true,
                                bl = true,
                                confirm = "DDoS the Server?",
                                tooltip = "Forces the server to send ~3 MB of data back to the client repeatedly. A message will be sent to the console menu when the bloat request completes, meaning that the server will imminently crash; this may take a while depending on internet connection speed.",
                                callback = function()
                                    -- yes, the method is very stupid.
                                    -- raspi$$code$$
                                    BBOT.log(LOG_NORMAL, "Sending bloat request, this may take a while!")
                                    thread:Create(function() -- theres probably a better way in this new hack to create thread?
                                        BBOT.aux.pfremotefunc:InvokeServer("updatesettings", {table.create(3e6, "a")}) -- fetch so we know when it has went thru
                                        BBOT.log(LOG_WARN, "Bloat request has completed. Why did you do this anyway?")
                                        local service = BBOT.service:GetService("GuiService")
                                        while service:GetErrorCode() ~= Enum.ConnectionError.DisconnectTimeout do -- eh idk
                                            -- ugh this is stupid looking
                                            coroutine.resume(coroutine.create(BBOT.aux.pfremotefunc.InvokeServer), BBOT.aux.pfremotefunc, "loadplayerdata", {}) -- hahahahah 🚶‍♀️🚶‍♀️🧨
                                            task.wait(2)
                                        end
                                        BBOT.log(LOG_WARN, "Server beamage is official: you were disconnected for timeout")
                                    end)
                                end
                            },
                            {
                                type = "Toggle",
                                name = "Invisibility",
                                value = false,
                                unsafe = true,
                                tooltip = "Invisibility by j son. Yes. We back at it again.",
                            },
                            {
                                type = "Toggle",
                                name = "Tick Manipulation",
                                value = false,
                                unsafe = true,
                                tooltip = "Makes your velocity go 10^n m/s, god why raspi you fucking idiot",
                            },
                            {
                                type = "Slider",
                                name = "Tick Division Scale",
                                min = 0,
                                max = 8,
                                suffix = "^10 studs/s",
                                decimal = 1,
                                value = 3,
                                custom = {},
                                tooltip = "Each value here is tick/10^n, so velocity go *wait what the fuck*",
                            },
                            {
                                type = "Toggle",
                                name = "Higher Division",
                                value = false,
                                unsafe = true,
                                tooltip = "Turns tick/10^n into tick/10^(n*10)",
                            },
                            {
                                type = "Toggle",
                                name = "Revenge Grenade",
                                value = false,
                                unsafe = true,
                                tooltip = "Automatically teleports a grenade to the person who killed you.",
                            },
                            {
                                type = "Toggle",
                                name = "Auto Nade Frozen",
                                value = false,
                                unsafe = true,
                                tooltip = "Automatically teleports a grenade to people frozen, useful against semi-god users.",
                            },
                            {
                                type = "Slider",
                                name = "Auto Nade Wait",
                                min = 1,
                                max = 12,
                                suffix = "s",
                                decimal = 1,
                                value = 6,
                                custom = {},
                                tooltip = "Time till auto nade should send",
                            },
                            {
                                type = "Toggle",
                                name = "Blink",
                                value = false,
                                unsafe = true,
                                tooltip = "Enables when you are standing still. Staying longer than 8 seconds may result in a auto-slay when you move. Grenades and knives still affect you!",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    },
                                    {
                                        type = "ColorPicker",
                                        name = "Path Color",
                                        color = { 127, 72, 163, 150 },
                                    }
                                }
                            },
                            {
                                type = "Toggle",
                                name = "Blink On Fire",
                                value = false,
                                tooltip = "Forces an update when you fire your gun, perfect for being a dick.",
                            },
                            {
                                type = "Slider",
                                name = "Blink Min Buffer",
                                min = 0,
                                max = 12,
                                suffix = "s",
                                decimal = 1,
                                value = 7,
                                custom = {
                                    [0] = "Invulnerable",
                                },
                                tooltip = "Attempts to allow movement when in temp-god when needed, WARNING: This can make you vulnerable for a split second",
                            },
                            {
                                type = "Slider",
                                name = "Blink Max Buffer",
                                min = 0,
                                max = 12,
                                suffix = "s",
                                decimal = 1,
                                value = 7,
                                custom = {
                                    [0] = "Invulnerable",
                                },
                                tooltip = "Attempts to allow movement when in temp-god when needed, WARNING: This can make you vulnerable for a split second",
                            },
                            {
                                type = "Toggle",
                                name = "Floor TP",
                                value = false,
                                unsafe = true,
                                tooltip = "Spawns you into the floor, so you can get out of the map.",
                            },
                            {
                                type = "Toggle",
                                name = "Disable Collisions",
                                value = false,
                                unsafe = true,
                                tooltip = "Useful for Floor TP",
                                extra = {
                                    {
                                        type = "KeyBind",
                                        toggletype = 2,
                                    },
                                }
                            },
                            --[[{
                                type = "Toggle",
                                name = "Anti Grenade TP",
                                value = false,
                                unsafe = true,
                                tooltip = "Moves you right after a kill, to hopefully... HOPEFULLY. Avoid a grenade TP.",
                            },
                            {
                                type = "ComboBox",
                                name = "Anti Grenade TP Points",
                                values = {
                                    { "Up", true },
                                    { "Down", true },
                                    { "Left", false },
                                    { "Right", false },
                                    { "Forward", true },
                                    { "Backward", true },
                                },
                            },
                            {
                                type = "Slider",
                                name = "Anti Grenade TP Distance",
                                min = 2,
                                max = 100,
                                suffix = " studs",
                                decimal = 1,
                                value = 25,
                                custom = {},
                            },]]
                        }},
                    },
                },
            },
        }
    },
    {
        Id = "Weapons",
        name = "Weapon Customization",
        pos = UDim2.new(.75, 0, 0, 100),
        size = UDim2.new(0, 425, 0, 575),
        type = "Tabs",
        content = {
            {
                name = "Stats Changer",
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,1,0),
                type = "Container",
                content = {
                    {
                        name = "Accuracy",
                        pos = UDim2.new(0,0,0,0),
                        size = UDim2.new(.5,-4,5/10,-4),
                        type = "Panel",
                        content = {
                            {
                                type = "Slider",
                                name = "Camera Kick",
                                min = 0,
                                max = 600,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Displacement Kick",
                                min = 0,
                                max = 600,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Rotation Kick",
                                min = 0,
                                max = 600,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Hip Choke",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Aim Choke",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Toggle",
                                name = "No Scope Sway",
                                value = false,
                                unsafe = true,
                            },
                            {
                                type = "Toggle",
                                name = "Straight Bolt Pull",
                                value = false,
                                unsafe = true,
                            }
                        }
                    },
                    {
                        name = "Handling",
                        pos = UDim2.new(0,0,5/10,4),
                        size = UDim2.new(.5,-4,5/10,-4),
                        type = "Panel",
                        content = {
                            {
                                type = "Slider",
                                name = "Crosshair Spread",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                                tooltip = "This does affect the spread of your guns by the ways..."
                            },
                            {
                                type = "Slider",
                                name = "Hip Spread",
                                min = 0,
                                max = 100,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Aiming Speed",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Equip Speed",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Ready Speed",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                                tooltip = "The time it takes to go from a sprinting stance to a \"ready to fire\" stance"
                            },
                        }
                    },
                    {
                        name = "Ballistics",
                        pos = UDim2.new(.5,4,0,0),
                        size = UDim2.new(.5,-4,1/3,-4),
                        type = "Panel",
                        content = {
                            {
                                type = "ComboBox",
                                name = "Fire Modes",
                                values = {
                                    { "Semi-Auto", false },
                                    { "Burst-2", false },
                                    { "Burst-3", false },
                                    { "Burst-4", false },
                                    { "Burst-5", false },
                                    { "Full-Auto", false },
                                },
                                unsafe = true,
                            },
                            {
                                type = "Toggle",
                                name = "Burst-Lock",
                                value = false,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Firerate",
                                min = 0,
                                max = 2000,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "Burst Cap",
                                min = 0,
                                max = 2000,
                                suffix = " RPM",
                                decimal = 0,
                                value = 0,
                                custom = {
                                    [0] = "Disabled"
                                },
                                unsafe = true,
                            },
                        }
                    },
                    {
                        name = "Movement",
                        pos = UDim2.new(.5,4,1/3,4),
                        size = UDim2.new(.5,-4,4/10,-4),
                        type = "Panel",
                        content = {
                            {
                                type = "DropBox",
                                name = "Weapon Style",
                                value = 1,
                                values = {"Off", "Rambo", "Doom", "Quake III", "Half-Life"}
                            },
                            {
                                type = "Toggle",
                                name = "OG Bob",
                                value = false,
                            },
                            {
                                type = "Slider",
                                name = "Bob Scale",
                                min = -200,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100
                            },
                            {
                                type = "Slider",
                                name = "Sway Scale",
                                min = -200,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100
                            },
                            {
                                type = "Slider",
                                name = "Swing Scale",
                                min = -200,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100
                            },
                        }
                    },
                    {
                        name = "Animations",
                        pos = UDim2.new(.5,4,1/3 + 4/10,8),
                        size = UDim2.new(.5,-4,1-(1/3 + 4/10),-8),
                        type = "Panel",
                        content = {
                            {
                                type = "Slider",
                                name = "Reload Scale",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                            {
                                type = "Slider",
                                name = "OnFire Scale",
                                min = 0,
                                max = 200,
                                suffix = "%",
                                decimal = 1,
                                value = 100,
                                unsafe = true,
                            },
                        }
                    },
                }
            },
            {
                name = "Skins",
                pos = UDim2.new(0,0,0,0),
                size = UDim2.new(1,0,1,0),
                type = "Container",
                content = {
                    {
                        type = "Toggle",
                        name = "Enabled",
                        value = false,
                        extra = {},
                        tooltip = "Do note this is not server-sided!"
                    },
                    {
                        name = { "Slot1", "Slot2", "SkinDB" },
                        pos = UDim2.new(0,0,0,21),
                        size = UDim2.new(1,0,1,-21),
                        borderless = true,
                        type = "Tabs",
                        {content=skins_content},
                        {content=skins_content},
                        {
                            content = {
                                {
                                    name = "SkinDBList", -- No type means auto-set to panel
                                    pos = UDim2.new(0,0,0,0),
                                    size = UDim2.new(1,0,1,0),
                                    type = "Custom",
                                    callback = function()
                                        local container = gui:Create("Container")
                                        local search = gui:Create("TextEntry", container)
                                        search:SetTextSize(13)
                                        search:SetText("")
                                        search:SetSize(1,0,0,16)

                                        local skinlist = gui:Create("List", container)
                                        skinlist:SetPos(0,0,0,16+4)
                                        skinlist:SetSize(1,0,1,-16-4)

                                        skinlist:AddColumn("Name")
                                        skinlist:AddColumn("AssetId")
                                        skinlist:AddColumn("Case")
                                        
                                        --[[if not BBOT.weapons or not BBOT.weapons.skindatabase then return container end

                                        for name, skinId in next, BBOT.weapons.skindatabase do
                                            local a, b, c = tostring(name), tostring(skinId.TextureId or "Unknown"), tostring(skinId.Case or "Unknown")
                                            local line = skinlist:AddLine(a, b, c)
                                            line.searcher = a .. " " .. b .. " " .. c
                                        end

                                        local function Refresh_List()
                                            if not BBOT.weapons.skindatabase then return end
                                            local tosearch = search:GetText()
                                            for i, v in next, skinlist.scrollpanel.canvas.children do
                                                if tosearch == "" or string.find(string.lower(v.searcher), string.lower(tosearch), 1, true) then
                                                    v:SetVisible(true)
                                                else
                                                    v:SetVisible(false)
                                                end
                                            end
                                            skinlist:PerformOrganization()
                                        end

                                        function search:OnValueChanged()
                                            Refresh_List()
                                        end

                                        Refresh_List()]]
                                        return container
                                    end,
                                    content = {}
                                }
                            }
                        },
                    }
                }
            },
        }
    },
}

hook:Call("Startup")