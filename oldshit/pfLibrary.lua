local client = {}

for k, v in pairs(getgc(true)) do
	if type(v) == "function" then
		if getinfo(v).name == "bulletcheck" then
			client.bulletcheck = v
		elseif getinfo(v).name == "trajectory" then
			client.trajectory = v
		elseif getinfo(v).name == "call" then
			client.call = v
		elseif getinfo(v).name == "loadplayer" then
			client.loadplayer = v
		elseif getinfo(v).name == "rankcalculator" then
			client.rankcalculator = v
		end
		for k1, v1 in pairs(debug.getupvalues(v)) do
			if type(v1) == "table" then
				if rawget(v1, "send") then
					client.net = v1
				elseif rawget(v1, "gammo") then
					client.logic = v1
				elseif rawget(v1, "setbasewalkspeed") then
					client.char = v1
				elseif rawget(v1, "basecframe") then
					client.cam = v1
				elseif rawget(v1, "votestep") then
					client.hud = v1
				elseif rawget(v1, "getbodyparts") then
					client.replication = v1
				elseif rawget(v1, "play") then
					client.sound = v1
				elseif rawget(v1, "checkkillzone") then
					client.roundsystem = v1
				end
			end
		end
	end
end
local sent = false
local oldsend = client.net.send
client.net.send=function(self,e,...)
	local args = {...}
	if not sent and e == "newbullets" then
		table.foreach(args[1].bullets[1], print)
	end
	oldsend(self,e,...)
end

-- table.foreach(client.cam, print)

-- local oldsend = client.net.send


-- client.net.send = function(self, name, ...)
-- 	local args = {...}
-- 	if name == "modcmd" then
-- 		local command = args[1]

-- 		local start, ending = command:find('/fpsmax ')
-- 		if ending then
-- 			local numbah = command:sub(ending + 1)
-- 			setfpscap(numbah)
-- 			print(numbah)
-- 		end
-- 	end
-- end

-- local input = game:GetService"UserInputService"
-- _G.fart = true
-- local d = 0.3
-- while wait() and _G.fart do
-- 	if input:IsKeyDown(Enum.KeyCode.E) then
-- 		wait(d)
-- 		client.net:send("modcmd", "/switch:p")
-- 		wait(d)
-- 		client.net:send("modcmd", "/switch:g")
-- 	end
-- end

-- local g = true
-- input.InputBegan:Connect(function(key)
-- 	if key.KeyCode == Enum.KeyCode.P then
-- 		if g then
-- 			client.net:send("modcmd", "/switch:p")
-- 			g = false
-- 		else
-- 			client.net:send("modcmd", "/switch:g")
-- 			g = true
-- 		end
-- 	end
-- end)
-- for k, player in pairs(game.Players:children()) do
-- 	local parts = client.replication.getbodyparts(player)
-- 	if parts then
-- 		print(parts.rootpart.Parent:GetBoundingBox())
-- 		break
-- 	end	
-- end
-- local gun = debug.getupvalues(client.logic.currentgun.toggleattachment)[2][client.logic.currentgun.gunnumber]
-- gun.firerate = 5000

-- local stances = {}

-- game.RunService.RenderStepped:Connect(function()
-- 	local amountChanged = 0
-- 	for k, Player in pairs(game.Players:children()) do
-- 		if not client.hud:isplayeralive(Player) then continue end
-- 		local updater = client.replication.getupdater(Player)
-- 		if updater.hooked then return end
-- 		local oldStance = updater.setstance
-- 		updater.setstance = function(...)
-- 			amountChanged += 1
-- 			return(updater.setstance(...))
-- 		end
-- 	end
-- 	print(amountChanged)
-- end)