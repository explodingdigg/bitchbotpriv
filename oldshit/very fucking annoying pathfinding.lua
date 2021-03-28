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

function CreateThread(func, ...)
	local thread = coroutine.create(func)
	coroutine.resume(thread, ...)
	return thread
end

local mapRaycast = RaycastParams.new()
mapRaycast.FilterType = Enum.RaycastFilterType.Whitelist
mapRaycast.FilterDescendantsInstances = client.roundsystem.raycastwhitelist
mapRaycast.IgnoreWater = true

local pathfinding = game:service("PathfindingService")
local dot = Vector3.new().Dot

local currentPathIndex = 0
local lastSpawn
local traversingPath = false

local function startPath(ptorsopos, startidx)
    local spawnidx = startidx or 1
	if client.char.alive then

        if traversingPath then
            repeat game.RunService.RenderStepped:Wait() until not traversingPath
        end

		local mapspawns = client.roundsystem.raycastwhitelist[1]:FindFirstChild("Spawns")

		if mapspawns then
			local descendants = mapspawns:GetDescendants()

            local size_desc = #descendants

            spawnidx = 1 + spawnidx % size_desc

			for i = spawnidx, size_desc do
				local spawn = descendants[i]
				
				if spawn.ClassName:match("Part") then
					spawn.Transparency = 0
					local rootpart = client.char.rootpart
					local newpath = pathfinding:CreatePath()
					newpath:ComputeAsync(ptorsopos, spawn.Position)

					if newpath.Status == Enum.PathStatus.Success then
                        spawnidx = i
                        traversingPath = true
						lastSpawn = spawn
						newpath = newpath:GetWaypoints()
                        local startTick = tick()
						local pathSize = #newpath
                        local lastDelta
						for point = 2, pathSize do
							currentPathIndex = point
                            local pointFailFlags = 0
							local pathPoint = newpath[point]
							local nextPathPoint = newpath[point + 1]
                            local nextPathPointPos = nextPathPoint and nextPathPoint.Position or nil
                            local lastPoint = newpath[pathSize]
							local pointPosition = pathPoint.Position

							if nextPathPoint then
								local nextDelta = nextPathPoint.Position - pathPoint.Position
								if dot(nextDelta.Unit, nextDelta) < 3 then
									continue
								end

								if nextPathPoint.Action == Enum.PathWaypointAction.Jump then
                                    local d = pointPosition - rootpart.Position
                                    local raycastResult = workspace:Raycast(rootpart.Position, d)
                                    if raycastResult then
                                        warn("\n\n\n\nhit the fucking wallllll")
                                        local hitpos = raycastResult.Position
                                        local normal = raycastResult.Normal
                                        d = (hitpos + 0.08 * normal) - rootpart.Position
                                    end
                                    
									rootpart.Position += d
									wait()
								end

                                nextPathPointPos += Vector3.new(0, 2, 0)
							end

							local deltaToLast = lastPoint.Position - pointPosition

                            pointPosition += Vector3.new(0, 2, 0)

							local delta = pointPosition - rootpart.Position
							local unit = delta.Unit
							local velocity = unit * 70

							local initialmagnitude = dot(unit, delta)
							print("NEW POINT")
                            warn(spawnidx)
							if currentPathIndex >= pathSize then
								warn("NEW THREADDDDD")
								CreateThread(startPath, lastPoint.Position, spawnidx + 1)
							end
							warn(currentPathIndex, pathSize)

							warn(pathPoint.Action)

							warn(initialmagnitude)

                            local dotstuff = dot(unit, delta)

							if initialmagnitude == initialmagnitude then
								repeat
									rootpart.Velocity = velocity
									delta = pointPosition - rootpart.Position
									unit = delta.Unit
                                    if lastDelta then
                                        local DELTADELTALOL = lastDelta - delta
                                        local mag = dot(DELTADELTALOL.unit, DELTADELTALOL)
                                        if mag < 0.13 then
                                            warn("Possibly stuck (VL:", pointFailFlags, ")")
                                            pointFailFlags += 1
                                        end
                                    end

                                    dotstuff = dot(unit, delta)

                                    if dotstuff > 50 then
                                        wait(1)
                                        traversingPath = false
                                        CreateThread(startPath, rootpart.Position, spawnidx + 1)
										return
                                    end
                                    lastDelta = delta
                                    --print(dot(unit, delta))
									game.RunService.RenderStepped:Wait()
									if not client.char.alive or (tick() - startTick) > 20 or pointFailFlags >= 50 then
                                        traversingPath = false
                                        CreateThread(startPath, rootpart.Position, spawnidx + 1)
										return
									end
								until dotstuff < 3 or (nextPathPointPos and dot((nextPathPointPos - rootpart.Position).Unit, nextPathPointPos - rootpart.Position) < 3)
							else
								warn("NAN PROBLEM")
                                traversingPath = false
                                return
							end
						end
                        traversingPath = false
						break
					end
				end
			end
		end

	end
end

startPath(client.char.rootpart.Position)

--[[while true do

end]]