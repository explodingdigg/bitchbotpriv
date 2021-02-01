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
				if rawget(v1, "fetch") then
					client.network = v1
				elseif rawget(v1, "gammo") then
					client.logic = v1
				elseif rawget(v1, "unaimedfov") then
					client.char = v1
				elseif rawget(v1, "basecframe") then
					client.cam = v1
				elseif rawget(v1, "votestep") then
					client.hud = v1
				elseif rawget(v1, "getplayerhit") then
					client.replication = v1
				elseif rawget(v1, "play") then 
					client.sound = v1
				elseif rawget(v1, "checkkillzone") then
					client.roundsystem = v1
				end
			end
		end
	end
	if type(v) == "table" then
		if rawget(v, "deploy") then
			client.ui = v
		end
	end
end

client.NetworkEncode = require(game.ReplicatedFirst.SharedModules.Utilities.Network.NetworkEncode)


--[[wait(1)

local ray = Ray.new(client.char.head.Position, Vector3.new(0, -90, 0) * 10000)

local hit, hitpos = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Map})

client.network:send("chatted", hit.Name)

print((not hit.CanCollide) or hit.Name == "Window")

--client.char.rootpart.Parent.Humanoid.HipHeight = 0
client.char.rootpart.Position -= Vector3.new(0, 18, 0)]]

local oldsend = _G.send or client.network.send

if not _G.send then
	warn("thhththt")
	_G.send = client.network.send
end

--oldsend(nil, "changewep", "Equipment", "Primary", "INTERVENTION")

--[[local data = game.ReplicatedStorage.RemoteFunction:InvokeServer("knifehit", {
	game.Players["alx_ret11ard"],
	tick(),
	{Name = "Head", Position = Vector3.new(math.huge)}
})

warn(data)
for k,v in next, client.NetworkEncode.decode(data) do
	warn(k,v)
end]]

client.network.send = function(t, event, ...)
	local args = {...}

	if event == "knifehit" then
		local old = args[3]
	
		local dumbpos = (client.char.head.CFrame * CFrame.new(0, 0, 10)).p
		local vtorsolv = args[3].Parent.Torso.CFrame.LookVector
		local fuckinhack = -vtorsolv.Unit:Dot(workspace.CurrentCamera.CFrame.LookVector.Unit)
		local newpos = old.Position:Lerp(dumbpos, fuckinhack)
		t:send("chatted", tostring(fuckinhack))
		if (fuckinhack <= 0.6 and fuckinhack >= -0.6) then
			local sign = fuckinhack >= -0 and -1 or 1
			newpos += Vector3.new(0, 0, 10) * sign
		end

		args[3] = {Name = old.Name, Position = newpos}
	end

	--[[if event == "bullethit" then
		args[2] = game:service("Players").LocalPlayer.Character.Torso.Position
		local data = game.ReplicatedStorage.RemoteFunction:InvokeServer("bullethit", args)
		warn(data)
		for k,v in next, client.NetworkEncode.decode(data) do
			warn(k,v)
		end
		return
	end]]

	return oldsend(t, event, unpack(args))
end