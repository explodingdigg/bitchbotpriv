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
				elseif rawget(v1, "purecontroller") then
					client.inputtype = v1
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





















































































































local oldsend = _G.send or client.network.send

if not _G.send then
	warn("thhththt")
	_G.send = client.network.send
end

client.network.send = function(t, event, ...)
	local args = {...}

	if event == "changecamo" then
		--setclipboard(game:service("HttpService"):JSONEncode(args))
		args[5].BrickProperties.Material = "Pavement"
		args[5].BrickProperties.Reflectance = 1/0.1
		for k,v in next, args[5].BrickProperties do
			warn(k,v)
		end
	end

	return _G.send(t, event, unpack(args))
end