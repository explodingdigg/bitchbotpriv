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

local function Create_Beam(origin_att, ending_att)
	local beam = Instance.new("Beam")
	beam.Texture = "https://www.roblox.com/library/446111273/electro-beam?Category=Decals&SortType=Relevance&SortAggregation=AllTime&SearchKeyword=beam&CreatorId=0&Page=2&Position=35&SearchId=0bd13a93-205e-4b8e-8cb9-b61cc43807a4"
	beam.TextureMode = Enum.TextureMode.Wrap
	beam.TextureSpeed = 4
	beam.LightEmission = 1
	beam.LightInfluence = 0
	beam.FaceCamera = true
	beam.Enabled = true
	beam.Parent = workspace
	return beam
end

local oldsend = client.net.send
client.net.send = function(self, name, ...)
	local args = {...}
	if name == "newbullets" then
		local origin = args[1].firepos
		local attach_origin = Instance.new("Attachment", workspace.Terrain)
		attach_origin.Position = origin
		for k, bullet in pairs(args[1].bullets) do
			local ending = origin + bullet[1] * 1000
			local attach_ending = Instance.new("Attachment", workspace.Terrain)
			attach_ending.Position = ending
			local beam = Create_Beam(attach_origin, attach_ending)
			print(beam)
			beam.Parent = workspace
		end
	end	
	return oldsend(self, name, ...)
end