local network = BBOT.aux.network
local hook = BBOT.hook
local table = BBOT.table
local notification = BBOT.notification
local string = BBOT.string
local config = BBOT.config
local timer = BBOT.timer
local chat = {}

do
    local chat_netindex, console_netindex

    local receivers = network.receivers
    for netindex, callback in pairs(receivers) do
        local const = debug.getconstants(callback)
        if table.quicksearch(const, "Tag") and table.quicksearch(const, "rbxassetid://") then
            chat_netindex = netindex
        elseif table.quicksearch(const, "[Console]: ") and table.quicksearch(const, "Tag") then
            console_netindex = netindex
        end
    end

    hook:Add("PostNetworkReceive", "BBOT:Chat.Network", function(netname, ...)
        if netname == chat_netindex then
            hook:Call("Chatted", ...)
        elseif netname == console_netindex then
            hook:Call("Console", ...)
        end
    end)
end


-- This is now useless :D
--[[hook:Add("Initialize", "BBOT:ChatDetour", function()
    local receivers = network.receivers

    for k, v in pairs(receivers) do
        local const = debug.getconstants(v)
        if table.quicksearch(const, "Tag") and table.quicksearch(const, "rbxassetid://") then
            receivers[k] = function(p20, p21, p22, p23, p24)
                timer:Async(function() hook:CallP("Chatted", p20, p21, p22, p23, p24) end)
                return v(p20, p21, p22, p23, p24)
            end
            hook:Add("Unload", "ChatDetour." .. tostring(k), function()
                receivers[k] = v
            end)
        elseif table.quicksearch(const, "[Console]: ") and table.quicksearch(const, "Tag") then
            receivers[k] = function(p18)
                timer:Async(function() hook:CallP("Console", p18) end)
                return v(p18)
            end
            hook:Add("Unload", "ChatDetour." .. tostring(k), function()
                receivers[k] = v
            end)
        end
    end
end)]]

function chat:Say(str, un)
    if string.sub(str, 1, 1) == "/" then
        network:send("modcmd", str)
        return
    end
    network:send("chatted", str, un or false)
    chat.last_say = tick()
end

chat.commands = {}

function chat:AddCommand(name, callback, help)
    chat.commands[name] = {callback, help}
end

function chat:RemoveCommand(name)
    chat.commands[name] = nil
end

chat:AddCommand("rank", function(num)
    num = tonumber(num)
    if not num then return end
    notification:Create("Rank: " .. BBOT.aux.playerdata.rankcalculator(num))
end)

local players = BBOT.service:GetService("Players")
chat:AddCommand("priority", function(pl, level)
    if not level then return end
    local target = nil
    for k, v in pairs(players:GetPlayers()) do
        if string.find(v.Name, pl, 1, true) then
            target = v
            break
        end
    end

    if target then
        notification:Create("Set priority for " .. target.Name .. " to " .. level)
        config:SetPriority(target, level)
    else
        notification:Create("Player " .. pl .. " not found")
    end
end)

chat:AddCommand("help", function(...)
    notification:Create("WIP, please wait a bit!")
end, "Shows all command information.")

hook:Add("SuppressNetworkSend", "BBOT:Chat.Commands", function(netname, message)
    if netname ~= "chatted" then return end
    if string.sub(message, 1, 1) ~= "." or string.sub(message, 2, 2) == "." then return end
    local command_line = string.sub(message, 2)
    command_line = string.Explode(" ", command_line)
    local command = command_line[1]
    table.remove(command_line, 1)
    local args = command_line

    if chat.commands[command] then
        local cmd = chat.commands[command]
        local exec = cmd[1](unpack(args))
        if exec == nil then exec = true end
        return exec
    else
        notification:Create("Not a command, try \".help\" to see available commands.")
    end
    return true
end)

chat.buffer = {}
local lasttext = ""
function chat:AddToBuffer(msg)
    local spaces = ""
    if msg == lasttext then
        for i=1, a do
            spaces = spaces .. "."
        end
        a = a + 1
        if a > 1 then a = 0 end
    else
        a = 0
        lasttext = msg
    end
    local msgquery = self.buffer
    msgquery[#msgquery+1] = msg .. spaces
    chat:BufferStep()
end

function chat:CheckIfValid(msg)
    for i=1, #msg do
        local str = string.sub(msg, i, i)
        if str ~= "\n" or str ~= " " then
            return true
        end
    end
end

chat.spammer_presets = {
    ["Bitch Bot"] = {
        "BBOT ON TOP ",
        "BBOT ON TOP 🔥🔥🔥🔥",
        "BBot top i think ",
        "bbot > all ",
        "BBOT > ALL🧠 ",
        "WHAT SCRIPT IS THAT???? BBOT! ",
        "日工tch ",
        ".gg/bbot",
    },
    ["Chinese Propaganda"] = {
        "音频少年公民记忆欲求无尽 heywe 僵尸强迫身体哑集中排水",
        "持有毁灭性的神经重景气游行脸红青铜色类别创意案",
        "诶比西迪伊艾弗吉艾尺艾杰开艾勒艾马艾娜哦屁吉吾",
        "完成与草屋两个苏巴完成与草屋两个苏巴完成与草屋",
        "庆崇你好我讨厌你愚蠢的母愚蠢的母庆崇",
        "坐下，一直保持着安静的状态。 谁把他拥有的东西给了他，所以他不那么爱欠债务，却拒��参加锻炼，这让他爱得更少了",
        ", yīzhí bǎochízhe ānjìng de zhuàngtài. Shéi bǎ tā yǒngyǒu de dōngxī gěile tā, suǒyǐ tā bù nàme ài qiàn zhàiwù, què jùjué cānjiā duànliàn, z",
        "他，所以他不那r给了他东西给了他爱欠s，却拒绝参加锻炼，这让他爱得更UGT少了",
        "bbot 有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
        "wocky slush他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼",
        "坐下，一直保持着安静的状态bbot 谁把他拥有的东西给了他，所以他不那rblx trader captain么有的东西给了他爱欠债了他他squilliam拥有的东西给爱欠绝参加锻squidward炼，务，却拒绝参加锻炼，这让他爱得更UGT少了",
        "免费手榴弹bbot hack绕过作弊工作Phantom Force roblox aimbot瞄准无声目标绕过2020工作真正免费下载和使用",
        "zal發明了roblox汽車貿易商的船長ro blocks，並將其洩漏到整個宇宙，還修補了虛假的角神模式和虛假的身體，還發明了基於速度的AUTOWALL和無限制的自動壁紙遊戲 ",
        "彼が誤って禁止されたためにファントムからautowallgamingを禁止解除する請願とそれはでたらめですそれはまったく意味がありませんなぜあなたは合法的なプレーヤーを禁止するのですか ",
        "ジェイソンは私が神に誓う女性的な男の子ではありません ",
        "傑森不是我向上帝發誓女性男孩 ",
    },
    ["Youtube Title"] = { 
        "Hack", "Unlock", "Cheat", "Roblox", "Mod Menu", "Mod", "Menu", "God Mode", "Kill All", "Silent", "Silent Aim", "X Ray", "Aim", "Bypass", "Glitch", "Wallhack", "ESP", "Infinite", "Infinite Credits",
        "XP", "XP Hack", "Infinite Credits", "Unlook All", "Server Backdoor", "Serverside", "2021", "Working", "(WORKING)", "瞄准无声目标绕过", "Gamesense", "Onetap", "PF Exploit", "Phantom Force",
        "Cracked", "TP Hack", "PF MOD MENU", "DOWNLOAD", "Paste Bin", "download", "Download", "Teleport", "100% legit", "100%", "pro", "Professional", "灭性的神经",
        "No Virus All Clean", "No Survey", "No Ads", "Free", "Not Paid", "Real", "REAL 2020", "2020", "Real 2017", "BBot", "Cracked", "BBOT CRACKED by vw", "2014", "desuhook crack",
        "Aimware", "Hacks", "Cheats", "Exploits", "(FREE)", "🕶😎", "😎", "😂", "😛", "paste bin", "bbot script", "hard code", "正免费下载和使", "SERVER BACKDOOR",
        "Secret", "SECRET", "Unleaked", "Not Leaked", "Method", "Minecraft Steve", "Steve", "Minecraft", "Sponge Hook", "Squid Hook", "Script", "Squid Hack",
        "Sponge Hack", "(OP)", "Verified", "All Clean", "Program", "Hook", "有毁灭", "desu", "hook", "Gato Hack", "Blaze Hack", "Fuego Hack", "Nat Hook",
        "vw HACK", "Anti Votekick", "Speed", "Fly", "Big Head", "Knife Hack", "No Clip", "Auto", "Rapid Fire",
        "Fire Rate Hack", "Fire Rate", "God Mode", "God", "Speed Fly", "Cuteware", "Knife Range", "Infinite XRay", "Kill All", "Sigma", "And", "LEAKED",
        "🥳🥳🥳", "RELEASE", "IP RESOLVER", "Infinite Wall Bang", "Wall Bang", "Trickshot", "Sniper", "Wall Hack", "😍😍", "🤩", "🤑", "😱😱", "Free Download EHUB", "Taps", "Owns",
        "Owns All", "Trolling", "Troll", "Grief", "Kill", "弗吉艾尺艾杰开", "Nata", "Alan", "JSON", "BBOT Developers", "Logic", "And", "and", "Glitch", 
        "Server Hack", "Babies", "Children", "TAP", "Meme", "MEME", "Laugh", "LOL!", "Lol!", "ROFLSAUCE", "Rofl", ";p", ":D", "=D", "xD", "XD", "=>", "₽", "$", "8=>", "😹😹😹", "🎮🎮🎮", "🎱", "⭐", "✝", 
        "Ransomware", "Malware", "SKID", "Pasted vw", "Encrypted", "Brute Force", "Cheat Code", "Hack Code", ";v", "No Ban", "Bot", "Editing", "Modification", "injection", "Bypass Anti Cheat",
        "铜色类别创意", "Cheat Exploit", "Hitbox Expansion", "Cheating AI", "Auto Wall Shoot", "Konami Code", "Debug", "Debug Menu", "🗿", "£", "¥", "₽", "₭", "€", "₿", "Meow", "MEOW", "meow",
        "Under Age", "underage", "UNDER AGE", "18-", "not finite", "Left", "Right", "Up", "Down", "Left Right Up Down A B Start", "Noclip Cheat", "Bullet Check Bypass",
        "client.char:setbasewalkspeed(999) SPEED CHEAT.", "diff = dot(bulletpos, intersection - step_pos) / dot(bulletpos, bulletpos) * dt", "E = MC^2", "Beyond superstring theory", 
        "It is conceivable that the five superstring theories are approximated to a theory in higher dimensions possibly involving membranes.",
    },
    ["Emojis"] = {
        "🔥🔥🔥🔥🔥🔥🔥🔥",
        "😅😅😅😅😅😅😅😅",
        "😂😂😂😂😂😂😂😂",
        "😹😹😹😹😹😹😹😹",
        "😛😛😛😛😛😛😛😛",
        "🤩🤩🤩🤩🤩🤩🤩🤩",
        "🌈🌈🌈🌈🌈🌈🌈🌈",
        "😎😎😎😎😎😎😎😎",
        "🤠🤠🤠🤠🤠🤠🤠🤠",
        "😔😔😔😔😔😔😔😔",
    },
    ["Deluxe"] = {
        "gEt OuT oF tHe GrOuNd 🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡 ",
        "brb taking a nap 💤💤💤 ",
        "gonna go take a walk 🚶‍♂️🚶‍♀️🚶‍♂️🚶‍♀️ ",
        "low orbit ion cannon booting up ",
        "how does it feel to not have bbot 🤣🤣🤣😂😂😹😹😹 ",
        "im a firing my laza! 🙀🙀🙀 ",
        "😂😂😂😂😂GAMING CHAIR😂😂😂😂😂",
        "retardheadass",
        "can't hear you over these kill sounds ",
        "i'm just built different yo 🧱🧱🧱 ",
        "📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈📈",
        "OFF📈THE📈CHART📈",
        "KICK HIM 🦵🦵🦵",
        "THE AMOUNT THAT I CARE --> 🤏 ",
        "🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏🤏",
        "SORRY I HURT YOUR ROBLOX EGO BUT LOOK -> 🤏 I DON'T CARE ",
        'table.find(charts, "any other script other than bbot") -> nil 💵💵💵',
        "LOL WHAT ARE YOU SHOOTING AT BRO ",
        "🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
        "BRO UR SHOOTING AT LIKE NOTHING LOL UR A CLOWN",
        "🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
        "ARE U USING EHUB? 🤡🤡🤡🤡🤡",
        "'EHUB IS THE BEST' 🤡 PASTED LINES OF CODE WITH UNREFERENCED AND UNINITIALIZED VARIABLES AND PEOPLE HAVE NO IDEA WHY IT'S NOT WORKING ",
        "LOL",
        "GIVE UP ",
        "GIVE UP BECAUSE YOU'RE NOT GOING TO BE ABLE TO KILL ME OR WIN LOL",
        "Can't hear you over these bands ",
        "I’m better than you in every way 🏆",
        "I’m smarter than you (I can verify this because I took an online IQ test and got 150) 🧠",
        "my personality shines and it’s generally better than your personality. Yours has flaws",
        "I’m more ambitious than you 🏆💰📣",
        "I’m more funny than you (long shot) ",
        "I’m less turbulent and more assertive and calm than you (proof) 🎰",
        "I’m stronger than you 💪 🦵 ",
        "my attention span is greater and better than yours (proven from you not reading entire list) ",
        "I am more creative and expressive than you will ever be 🎨 🖌️",
        "I’m a faster at typing than you 💬 ",
        "In 30 minutes, I will have lifted more weights than you can solve algebraic equations 📓 ",
        "By the time you have completed reading this very factual and groundbreaking evidence that I am truly more superior, thoughtful, and presentable than you are, I will have prospered (that means make negotiable currency or the American Dollar) more than your entire family hierarchy will have ever made in its time span 💰",
        "I am more seggsually stable and better looking than you are 👨",
        "I get along with women easier than you do 👩‍🚀", -- end
        "I am very good at debating 🗣️🧑‍⚖️ ",
        "I hit more head than you do 🏆", -- end
        "I win more hvh than you do 🏆", -- end yes this is actually how im going to fix this stupid shit
        "I am more victorious than you are 🏆",
        "Due to my agility, I am better than you at basketball, and all of your favorite sports or any sport for that matter (I will probably break your ankles in basketball by pure accident) ",
        "WE THE BEST CHEATS 🔥🔥🔥🔥 ",
        "Phantom Force Hack Unlook Gun And Aimbot ",
        "banlands 🔨 🗻 down 🏚️  ⏬ STOP CRASHING BANLANDS!! 🤣",
        "antares hack client isn't real ",
        "squidhook.xyz 🦑 ",
        "squidhook > all ",
        "spongehook 🤣🤣🤣💕",
        "retardheadass ",
        "interpolation DWORD* C++ int 32 bit programming F# c# coding",
        "Mad?",
        "are we in a library? 🤔 📚 cause you're 👉 in hush 🤫 mode 🤣 😂",
        "please help, my name is john escopetta, normally I would not do this, but under the circumstances I must ask for assistance, please send 500 United States dollars to my paypal, please",
        "🏀🏀 did i break your ankles brother ",
        "he has access to HACK SERVER AND CHANGE WEIGHTS!!!!! STOOOOOOP 😡😒😒😡😡😡😡😡",
        '"cmon dude don\'t use that" you asked for it LOL ',
        "ima just quit mid hvh 🚶‍♀️ ",
        "BABY 😭",
        "BOO HOO 😢😢😭😭😭 STOP CRYING D∪MBASS",
        "BOO HOO 😢😢😭😭😭 STOP CRYING ",
        "🤏",
        "🤏 <-- just to elaborate that i have no care for this situation or you at all, kid (not that you would understand anyways, you're too stupid to understand what i'm saying to begin with)",
        "before bbot 😭 📢				after bbot 😁😁😜					don't be like the person who doesn't have bbot",
        "							MADE YOU LOOK ",
        "							LOOK BRO LOOK LOOK AT ME ",
        "			B		B		O		T	",
        "																																																																																																																								I HAVE AJAX YALL BETTER WATCH OUT OR YOU'LL DIE, WATCH WHO YOU'RE SHOOTING",
        "																																																																																																																								WATCH YOUR STEP KID",
        "BROOOO HE HAS																										GOD MODE BRO HE HAS GOD MODE 🚶‍♀️🚶‍♀️🚶‍♀️😜😂😂🤦‍♂️🤦‍♂️😭😭😭👶",
        '"guys what hub has auto shooting" 																										',
        "god i wish i had bbot..... 🙏🙏🥺🥺🥺													plzzzzz brooooo 🛐 GIVE IT🛐🛐",
        "buh bot 												",
        "votekick him!!!!!!! 😠 vk VK VK VK VOTEKICK HIM!!!!!!!!! 😠 😢 VOTE KICK !!!!! PRESS Y WHY DIDNT U PRESS Y LOL!!!!!! 😭 ", -- shufy made this
        "Bbot omg omggg omggg its BBot its BBOt OMGGG!!!  🙏🙏🥺🥺😌😒😡",
        "HOw do you get ACCESS to this BBOT ", -- end
        "I NEED ACCESS 🔑🔓 TO BBOT 🤖📃📃📃 👈 THIS THING CALLED BBOT SCRIPT, I NEED IT ",
        '"this god mode guy is annoying", Pr0blematicc says as he loses roblox hvh ',
        "you can call me crimson chin 🦹‍♂️🦹‍♂️ cause i turned your screen red 🟥🟥🟥🟥 									",
        "clipped that 🤡 ",
        "Clipped and Uploaded. 🤡",
        "nodus client slime castle crashers minecraft dupeing hack wizardhax xronize grief ... Tlcharger minecraft crack Oggi spiegheremo come creare un ip grabber!",
        "Off synonyme syls midge, smiled at mashup 2 mixed in key free download procom, ... Okay, love order and chaos online gameplayer hack amber forcen ahdistus",
        "ˢᵗᵃʸ ᵐᵃᵈ ˢᵗᵃʸ ᵇᵇᵒᵗˡᵉˢˢ $ ",
        "bbot does not relent ",
    },
    ["t0nymode"] = {
        "but doctor prognosis: OWNED ",
        "but doctor results: 🔥",
        "looks like you need to talk to your doctor ",
        "speak to your doctor about this one ",
        "but analysis: PWNED ",
        "but diagnosis: OWND ",
    },
    ["Douchbag"] = {
        "BBot - Drool Bot ver 1.0.0, making people face reality with uncomfortable jokes",
        "I love it when your mom takes my wood with extra syrup 😚",
        "I know you guys love it when I come in with my massive oak log 😋",
        "I have like 200 extra rounds of juice in my barrel 😋, want some?",
        "Please eat my barrel, it's so long and filled with rounds, I even have a muzzle booster on it 😚",
        "Your complaints just makes my wood turn into a 12 inch log",
        "Mmmmm, take my wood a put right in that hole you got 😚",
        "MMMmmm, let's touch barrels 😚, we bouta makes a whole new team if you know what I mean",
        "Take my entire mag, I know you love it when it gets unloaded right in your face 😌",
        "I'm bouta make a whole new category in the weapons menu with you 😌",
        "You better gobble up all my rounds, body bag 😋",
        "I want you to take my wood personally, we bouta make a whole new team 😋",
        "I heard you drop your mag when I came in, and honestly it made my wood hard",
        "I love the fact you guys are enjoying this, my barrel hasn't been this straight in ages",
        "I want you to eat my barrel like it was a family dinner my kitten 😋",
        "My barrel has not been this hard since I was banlands",
        "Eat my barrel pretty please daddy 😋, I put 9mm on it for extra action",
        "Take my barrel please daddy 😋, my bfg 50 can't take it much longer",
        "I love it when you take in my bfg 50 .17 wildcat, it makes me drool 😋",
        "I know you love it when I spread you open with my remington 870 😚",
        "I'm gonna make you spill your rounds all over me 😚",
        "Take my wood kitten, you will enjoy my delicious log",
    },
    ["ni shi zhong guo ren ma?"] = {
        "诶",
        "比",
        "西",
        "迪",
        "伊",
        "艾",
        "弗",
        "吉",
        "艾",
        "尺",
        "艾",
        "杰",
        "开",
        "艾",
        "勒",
        "艾",
        "马",
        "艾",
        "娜",
        "哦",
        "屁",
        "吉",
        "吾",
        "艾",
        "儿",
        "艾"
    }
}

chat.spammer_delay = 0
chat.spammer_startdelay = 0
chat.spammer_kills = 0
chat.spammer_alive = false
chat.spammer_lines = chat.spammer_presets["Bitch Bot"]

hook:Add("PostInitialize", "BBOT:Chat.Spam", function()
    timer:Async(function()
        local preset = chat.spammer_presets[config:GetValue("Main", "Misc", "Chat Spam", "Presets")]
        if not preset then return end
        chat.spammer_lines = preset
    end)
end)

hook:Add("OnConfigChanged", "BBOT:Chat.Spam", function(steps, old, new)
    if not config:IsPathwayEqual(steps, "Main", "Misc", "Chat Spam", "Presets") then return end
    local preset = chat.spammer_presets[new]
    if not preset then return end
    chat.spammer_lines = preset
end)

function chat:SpamStep(ignore_delay)
    if not self.spammer_alive then return end
    if self.spammer_startdelay and self.spammer_startdelay > tick() then return end
    if self.spammer_kills < config:GetValue("Main", "Misc", "Chat Spam", "Minimum Kills") then return end
    if #self.buffer > 20 then return end
    if not ignore_delay and self.spammer_delay > tick() then return end
    local msg
    local mixer = config:GetValue("Main", "Misc", "Chat Spam", "Newline Mixer")
    if mixer > 4 then
        local allow_spaces = config:GetValue("Main", "Misc", "Chat Spam", "Newline Mixer Spaces")
        local words = self.spammer_lines
        local message = ""
        for i = 1, mixer do
            message = message .. (allow_spaces and " " or "") .. words[math.random(#words)]
        end
        msg = message
    else
        msg = self.spammer_lines[math.random(1, #self.spammer_lines)]
    end
    if not msg then return end
    if not ignore_delay then self.spammer_delay = tick() + config:GetValue("Main", "Misc", "Chat Spam", "Spam Delay") end
    self:AddToBuffer(msg)
end

hook:Add("PreBigAward", "BBOT:Chat.Spam", function()
    chat.spammer_kills = chat.spammer_kills + 1
    if not config:GetValue("Main", "Misc", "Chat Spam", "Enabled") or not config:GetValue("Main", "Misc", "Chat Spam", "Spam On Kills") then return end
    --chat:SpamStep(true)
end)

hook:Add("RenderStepped", "BBOT:Chat.Spam", function()
    if not config:GetValue("Main", "Misc", "Chat Spam", "Enabled") then return end
    if config:GetValue("Main", "Misc", "Chat Spam", "Spam On Kills") then return end
    chat:SpamStep()
end)

hook:Add("OnAliveChanged", "BBOT:Chat.Spam", function(alive)
    if alive and not chat.spammer_alive then
        chat.spammer_startdelay = tick() + config:GetValue("Main", "Misc", "Chat Spam", "Start Delay")
        chat.spammer_alive = true
    end
end)

hook:Add("OnConfigOpened", "BBOT:Chat.Spam", function()
    chat.spammer_alive = false
end)

--[[
local lastkillsay = ""
local killsay = lastkillsay
while killsay == lastkillsay do
    killsay = math.random(#customKillSay)
end
lastkillsay = killsay
local message = customKillSay[killsay]
message = message:gsub("%[hitbox%]", head and "head" or "body")
message = message:gsub("%[name%]", victim.Name)
message = message:gsub("%[weapon%]", weapon)
chat:AddToBuffer(message)
]]

chat.last_say = 0

hook:Add("PostNetworkSend", "BBOT:Chat.Query", function(netname, msg)
    if netname ~= "chatted" then return end
    chat.last_say = tick()
end)

function chat:BufferStep()
    if self.last_say + 2 > tick() then return end
    local msg = self.buffer[1]
    if not msg then return end
    table.remove(self.buffer, 1)
    local vkinprogress = BBOT.votekick:IsCalling()
    if not vkinprogress or vkinprogress > 5 then
        self:Say(msg)
    end
end

hook:Add("RenderStepped", "BBOT:Chat.Query", function()
    chat:BufferStep()
end)

return chat