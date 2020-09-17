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


local Input = game:GetService("UserInputService")
local MainPlayer = game.Players.LocalPlayer
local MainPlayerMouse = MainPlayer:GetMouse()

setreadonly(math, false)
math.map = function(X, A, B, C, D)
	return (X-A)/(B-A) * (D-C) + C
end
setreadonly(math, true)

local camera = {}
do
	camera.GetGun = function()
		for k, v in pairs(workspace.Camera:GetChildren()) do
			if v.Name ~= "Right Arm" and v.Name ~= "Left Arm" then
				return v
			end
		end
	end
end


local aimbot = {}
do
	function aimbot:AimAtTarget(targetPart)
		if not targetPart then return end
		local smoothing = 5

		local Pos, visCheck = workspace.Camera:WorldToScreenPoint(targetPart.Position)

		local aimbotMovement = Vector2.new(Pos.X - MainPlayerMouse.X, Pos.Y - MainPlayerMouse.Y)

		mousemoverel(aimbotMovement.X/smoothing, aimbotMovement.Y/smoothing)
	end

	function aimbot:GetFOV(Part, fov)
		local directional = CFrame.new(workspace.Camera.CFrame.Position, Part.Position)
	
		local ang = Vector3.new(directional:ToOrientation()) - Vector3.new(workspace.Camera.CFrame:ToOrientation())
		
		return math.deg(ang.Magnitude)
	end

	function aimbot:IsVisible(Part)
		local partsBetweenTarget = workspace.Camera:GetPartsObscuringTarget({Part}, {workspace.Camera, workspace.Players[MainPlayer.Team.Name], workspace.Ignore, Part.Parent})
		return #partsBetweenTarget > 0
	end

	function aimbot:GetTargetLegit(fov, partPreference, hitscan, players)
		local closest, closestPart = fov
		partPreference = partPreference or "head"
		hitscan = hitscan or false
		players = players or game.Players:GetPlayers()

		for i, Player in pairs(players) do

			if Player.Team ~= MainPlayer.Team then
				local Parts = client.repl.getbodyparts(Player)

				local Part

				if Parts then
					Part = Parts[partPreference]
					if hitscan then
						for i1, Part in pairs(Parts) do

							if Part.ClassName == "Part" then
								if aimbot:GetFOV(Part, closest) < closest and aimbot:IsVisible(Part) then
									closest = aimbot:GetFOV(Part, closest)
									closestPart = Part
								end
							end

						end
					elseif Part and aimbot:GetFOV(Part, closest) < closest then
						if aimbot:IsVisible(Part) then
							closest = aimbot:GetFOV(Part, closest)
							closestPart = Part
						end
					end
				end
			end
		end
		return closestPart, closest
	end
end

game.RunService.RenderStepped:Connect(function()
	if Input:IsKeyDown(Enum.KeyCode.Eight) then
		local targetPart = aimbot:GetTargetLegit(50, "head", true)
		if targetPart then
			aimbot:AimAtTarget(targetPart)
		end
	end
end)