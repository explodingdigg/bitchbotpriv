local client = {
	net,
	logic,
	char,
	cam,
	hud,
	repl,
	bulletcheck,
	traj,
	menu,
	particle,
	roundsystem,
}


for k, v in pairs(getgc(true)) do
	if type(v) == "function" then
		if getinfo(v).name == "bulletcheck" then
			client.bulletcheck = v
		end
		if getinfo(v).name == "trajectory" then
			client.traj = v
		end
		for k1, v1 in pairs(debug.getupvalues(v)) do
			if type(v1) == "table" then
				if rawget(v1, "send") then
					client.net = v1
				elseif rawget(v1, "gammo") then
					client.logic = v1
				elseif rawget(v1, "loadknife") then
					client.char = v1
				elseif rawget(v1, "basecframe") then
					client.cam = v1
				elseif rawget(v1, "votestep") then
					client.hud = v1
				elseif rawget(v1, "getbodyparts") then
					client.repl = v1
				elseif rawget(v1, "checkkillzone") then
					client.roundsystem = v1
				end
			end
		end
	elseif type(v) == "table" then
		if rawget(v, "deploy") then
			client.menu = v
		elseif rawget(v, "new") and rawget(v, "step") then
			client.particle = v
		end
	end
end
do 
	local sway = client.cam.setsway
	client.cam.setsway = function(self, v)
		return sway(self, 0)
	end
	local swayspeed = client.cam.setswayspeed
	client.cam.setswayspeed = function(self, v)
		return swayspeed(self, 0)
	end

end
print()
local function print_tables(t, key, i)
	i = i or 0
	local indent = string.rep("   ", i)
	print(indent, key, t)
	for k, v in pairs(t) do
		if type(v) == "table" then
			print_tables(v, k, i + 1)
		else
			print(indent, k, v)
		end
	end
end
local xw = true
local fr = false
if fr then
	local spring = debug.getupvalue(client.char.setsprint, 9)
	local mt = getrawmetatable(spring)
	local old_index = mt.__index
	setreadonly(mt, false)
	mt.__index = newcclosure(function(t, k)
		local result = old_index(t, k)
		if k == "p" then 
			return 0 
		end
		return result
	end)
end
