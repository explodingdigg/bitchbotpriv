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
				elseif rawget(v1, "new") and rawget(v1, "reset") then
					client.particle = v1
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

--[[local newpart = client.particle.new

client.particle.new = function(p)
	for k,v in next, p do
		warn(k,v)
	end

	return newpart(p)
end]]

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

--[[for i = 1, 5 do
	local str = "We have cheats, I'm not lying"
	
	if i % 2 == 0 then
		str = str .. string.char(1):rep(math.random(10))
	end

	client.network:send("chatted", str)
end]]

--[[game.ReplicatedStorage.RemoteFunction:InvokeServer("swapweapon", {
	workspace.Ignore.GunDrop.Dropped, 8
})

for k,v in next, getupvalue(client.char.unloadguns, 2) do
	warn(k,v)
end

warn(client.logic.currentgun.id)]]

local mt = getrawmetatable(game)

if not _G.newindex then
	_G.newindex = mt.__newindex
end

local currentcamera = workspace.CurrentCamera

local newindex = _G.newindex or mt.__newindex

setreadonly(mt, false)

mt.__newindex = function(t, p, v)

	if not checkcaller() and t == currentcamera and client.char.alive then
		if p == "CFrame" then
			local translatedcf = v + v.lookVector * -20
			return newindex(t, p, translatedcf)
		end
	end

	return newindex(t, p, v)
end

setreadonly(mt, true)

local ajax = 0

local renderStepped = game.RunService.RenderStepped
local stepWait = renderStepped.Wait

local debris = game:service("Debris")

local uberpart = workspace:FindFirstChild("uber")

if not uberpart then
	uberpart = Instance.new("Part", workspace)
	uberpart.Name = "uber"
	uberpart.Material = Enum.Material.Neon
	uberpart.Anchored = true
	uberpart.CanCollide = false
	uberpart.Size = Vector3.new(1, 1, 1)
end