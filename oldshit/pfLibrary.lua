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

client.network:send("stripclothing")

--[[local funcs = getupvalue(client.call, 1)

local playertospawnon = nil

local oldsend = client.network.send

client.network.send = function(t, event, ...)
	local args = {...}

	if event == "spawn" then
		args[1] = playertospawnon
	end

	return oldsend(t, event, unpack(args))
end

local lplayer = game.Players.LocalPlayer

local runservice = game:service("RunService")
local rs = runservice.RenderStepped
local stepwait = rs.Wait

local spawnallowed = true

client.char.ondied:connect(function()
	spawnallowed = true
end)

for hash, func in next, funcs do
	local c = getconstants(func)
	local bodyparts = table.find(c, "updatecharacter")
	local killed = table.find(c, "setfixedcam")
	local lookangles = table.find(c, "setlookangles")
	local stance = table.find(c, "setstance")
	local aim = table.find(c, "setaim")
	local sprint = table.find(c, "setsprint")

	if bodyparts then
		funcs[hash] = function(player, bodyparts)
			if not client.char.spawned and player.Team == lplayer.Team and spawnallowed then
				playertospawnon = player
				client.ui:deploy(player)
				local r = bodyparts.rootpart
				coroutine.wrap(function()
					repeat wait() until client.char.spawned
					local rootpart = client.char.rootpart
					while client.char.spawned do
						rootpart.Position = r.Position
						stepwait(rs)
					end
					return
				end)()
			end
			return func(player, bodyparts)
		end
	end

	if killed then
		funcs[hash] = function(...)
			spawnallowed = false
			return func(...)
		end
	end

	if lookangles then
		funcs[hash] = function(player, newangles)
			if client.char.spawned and playertospawnon and player == playertospawnon then
				client.cam.angles = newangles
			end
			return func(player, newangles)
		end
	end

	if stance then
		funcs[hash] = function(player, newstance)
			if client.char.spawned and playertospawnon and player == playertospawnon then
				client.char:setmovementmode(newstance)
			end
			return func(player, newstance)
		end
	end

	if aim then
		funcs[hash] = function(player, newaim)
			if client.char.spawned and playertospawnon and player == playertospawnon then
				client.logic.currentgun:setaim(newaim)
			end
			return func(player, newaim)
		end
	end

	if sprint then
		funcs[hash] = function(player, newsprint)
			if client.char.spawned and playertospawnon and player == playertospawnon then
				client.char:setsprint(newsprint)
			end
			return func(player, newsprint)
		end
	end
end]]