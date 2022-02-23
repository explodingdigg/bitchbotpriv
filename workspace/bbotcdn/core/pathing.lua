local vector = BBOT.vector
local pathing = {}

function pathing.distance(a, b)
    local d = b - a
    return math.max(math.abs(d.x), math.abs(d.y), math.abs(d.z))
end

function pathing.sortbygoal(l, r)
    return l.global_goal < r.global_goal
end

function pathing.raycast(origin, direction, parameter, callback)
    local filter = parameter.FilterDescendantsInstances
    local whitelist = {}
    for i=1, #filter do
        whitelist[i] = filter[i]
    end
    local results
    local calls = 0
    while calls < 2000 do
        results = workspace:Raycast(origin, direction, parameter)
        if not results then break end
        if callback and callback(results) then
            table.insert(whitelist, results.Instance)
            parameter.FilterDescendantsInstances = whitelist
            calls = calls + 1
        else
            break 
        end
    end
    parameter.FilterDescendantsInstances = filter
    return results
end

do
    local blank_vector = Vector3.new()
    local meta = {}
    pathing.meta = {__index = meta}

    function meta:Init()
        self.path = {}
        self.success = false
        self.directions = {
            Vector3.xAxis,
            -Vector3.xAxis,
            Vector3.zAxis,
            -Vector3.zAxis,
            Vector3.yAxis,
            -Vector3.yAxis,
        }
        self.waypoint_spacing = 9
        self.distance_required = 9
        self.max_steps = 128
        self.from = blank_vector
        self.to = blank_vector
        self.node_query = {}
        self.node_recursion = {}
        self.raycast_parameter = RaycastParams.new()
        self.raycast_offset = Vector3.new()
    end

    function meta:Calculate()
        local raycast_parameter = self.raycast_parameter
        local raycast_callback = self.raycast_callback
        local node_recursion = self.node_recursion
        local node_query = self.node_query
        local directions = self.directions
        local waypoint_spacing = self.waypoint_spacing
        local distance_required = self.distance_required
        local to = self.to

        -- This is known as a best-first search (i think at least)
        -- https://en.wikipedia.org/wiki/Best-first_search
        node_query = {
            { pos = self.from, visited = false, local_goal = 0, global_goal = pathing.distance(self.from, to), parent = nil }
        }
        node_recursion = {}

        self.node_query = node_query
        self.node_recursion = node_recursion
        self.success = false

        local path = {}
        for steps = 1, self.max_steps do
            if #node_query == 0 then
                break
            end
            table.sort(node_query, pathing.sortbygoal)

            local node = table.remove(node_query, 1)
            -- yeah.. i didnt put this in before for whatever reason
            while node.visited and #node_query > 0 do
                node = table.remove(node_query, 1)
            end
            node.visited = true

            if pathing.distance(node.pos, to) <= distance_required then
                while node.parent do
                    table.insert(path, 1, node.pos)
                    node = node.parent
                end
                table.insert(path, 1, node.pos)
                self.success = true
                break
            end

            local node_pos = node.pos
            for i = 1, #directions do
                local dir = directions[i]
                local result = pathing.raycast(node_pos + self.raycast_offset, dir * waypoint_spacing, raycast_parameter, raycast_callback)
                if not result then
                    local neighbor_pos = node_pos + waypoint_spacing * dir
                    local floored = vector.floor(neighbor_pos, waypoint_spacing)
                    local node_neighbor = node_recursion[floored]
                    if not node_neighbor then
                        local global = pathing.distance(neighbor_pos, to)
                        -- This was not being used, and I have already
                        -- fiddled with this before and it doesn't seem
                        -- to change the contour of paths at all (at least,
                        -- not in this implementation.)

                        -- I'll leave it commented out for now, but
                        -- generally the algorithm I implemented for
                        -- pathfinding here is behaving as it should,
                        -- so I don't think we'll need the local goal
                        
                        --local localg = pathing.distance(node_pos, to)
                        node_neighbor = { pos = neighbor_pos, visited = false, --[[local_goal = localg,]] global_goal = global, parent = node }
                        node_recursion[floored] = node_neighbor
                    end
                    if not node_neighbor.visited then
                        table.insert(node_query, node_neighbor)
                    end
                end
            end
        end

        self.path = path
        return path, self.success
    end

    -- acessors
    function meta:GetPath()
        return self.path, self.success
    end

    -- mutators
    function meta:SetWaypointSpacing(spacing)
        self.waypoint_spacing = spacing
    end

    -- Distance to target required for the pather
    -- to assume a valid path was found
    function meta:SetDistanceRequired(dist)
        self.distance_required = dist
    end

    function meta:SetFrom(from)
        self.from = from
    end

    function meta:SetTo(to)
        self.to = to
    end

    -- Max steps before the pather gives up
    function meta:SetMaxSteps(steps)
        self.max_steps = steps
    end

    function meta:SetRaycastParameter(param)
        self.raycast_parameter = param
    end

    function meta:SetRaycastCallback(func)
        self.raycast_callback = func
    end

    function meta:SetRaycastOffset(offset)
        self.raycast_offset = offset
    end
end

function pathing.new(from, to)
    local pather = setmetatable({}, pathing.meta)
    pather:Init()
    if from then pather:SetFrom(from) end
    if to then pather:SetTo(to) end
    return pather
end

function pathing.instant(from, to, waypoint_spacing, parameter, parameter_callback)
    local pather = pathing.new(from, to)
    pather:SetWaypointSpacing(waypoint_spacing)
    pather:SetRaycastParameter(parameter)
    pather:SetRaycastCallback(parameter_callback)
    return pather:Calculate()
end

return pathing