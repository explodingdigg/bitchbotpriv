local log = BBOT.log
local hook = {
    registry = {},
    _registry_qa = {}
}

function hook:Add(name, ident, func) -- Adds a function to a hook array
    local hooks = self.registry
    
    log(LOG_DEBUG, 'Added hook "' .. name .. '" with identity "' .. ident .. '"')

    hooks[name] = hooks[name] or {}
    hooks[name][ident] = func

    local QA = {}
    for k, v in next, hooks[name] do
        QA[#QA+1] = {k, v}
    end
    self._registry_qa[name] = QA
end
function hook:Remove(name, ident) -- Removes a function from a hook array
    local hooks = self.registry
    if not hooks[name] then return end

    log(LOG_DEBUG, 'Removed hook "' .. name .. '" with identity "' .. ident .. '"')

    hooks[name][ident] = nil

    local QA = {}
    for k, v in next, hooks[name] do
        QA[#QA+1] = {k, v}
    end
    self._registry_qa[name] = QA
end
function hook:Clear(name) -- Clears an entire array of hooks
    local hooks = self.registry

    log(LOG_DEBUG, 'Cleared hook "' .. name .. '" callbacks')

    hooks[name] = nil
    self._registry_qa[name] = {}
end
function hook:AsyncCall(name, ...) -- Need async? no problem
    coroutine.resume(coroutine.create(hook.Call), hook, name, ...)
end
function hook:Call(name, ...) -- Calls an array of hooks, and returns anything if needed
    if self.killed then return end
    if not self.registry[name] then return end
    local tbl, tbln = self._registry_qa[name], self.registry[name]

    if tbln[name] then
        local func = tbln[name]
        local ret = {func(...)}
        if ret[1] ~= nil then
            return unpack(ret)
        end
    end

    local c = 0
    for l=1, #tbl do
        local k = l-c
        local v = tbl[k]
        if v[1] ~= name then
            local _name, func = v[1], v[2]
            if not func then 
                table.remove(tbl, k); c = c + 1; tbln[_name] = nil
            else
                if not _name then 
                    table.remove(tbl, k); c = c + 1; tbln[_name] = nil
                else
                    local ret = {func(...)}
                    if ret[1] then
                        return unpack(ret)
                    end
                end
            end
        end
    end
end

function hook.ProcessHook(hookdata, ...)
    local name = hookdata.name
    local registry = hookdata.registry
    local name_registry = hookdata.name_registry
    local len = #registry

    if hookdata.index < len then
        local _c = 0
        for l=hookdata.index+1, len do
            local k = l-_c
            hookdata.index = k
            local v = registry[k]
            if v[1] ~= name then
                local id, func = v[1], v[2]
                if not func then 
                    table.remove(registry, k)
                    _c = _c + 1
                    name_registry[id] = nil
                else
                    if not id then 
                        table.remove(registry, k)
                        _c = _c + 1
                        name_registry[id] = nil
                    else
                        hookdata.id = id
                        local ret = {func(...)}
                        if ret[1] then
                            hookdata.returns = ret
                            break
                        end
                    end
                end
            end
        end
    end

    hookdata.finished = true
end

function hook.CatchHook(err)
    local hookdata = hook.Processing
    if not hookdata then return end
    log(LOG_ERROR, "Hook Error - " .. hookdata.name .. " - " .. hookdata.id .. " ->\n" .. err)
    log(LOG_ERROR, debug.traceback())
    log(LOG_WARN, "Removing to prevent cascade!")
    table.remove(hookdata.registry, hookdata.index)
    hookdata.name_registry[hookdata.id] = nil
    if (BBOT.notification) then
        BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in hook library.\nPlease check Synapse console!", 30):SetType("error")
    end
end

function hook:CallP(name, ...) -- Same as @hook:Call, put with error isolation
    if self.killed then return end
    if not self.registry[name] then return end
    local tbl, tbln = self._registry_qa[name], self.registry[name]

    if tbln[name] then
        local func = tbln[name]
        local ret = {xpcall(func, debug.traceback, ...)}
        if not ret[1] then
            log(LOG_ERROR, "Hook Error - ", name, " - ", name)
            log(LOG_ERROR, ret[2])
            log(LOG_WARN, "Removing to prevent cascade!")
            for l=1, #tbl do
                local v = tbl[l]
                if v[1] == name then
                    table.remove(tbl, l); tbln[name] = nil
                    break
                end
            end
            if (BBOT.notification) then
                BBOT.notification:Create("!!!ERROR!!!\nAn error has occured in hook library.\nPlease check Synapse console!", 30):SetType("error")
            end
        elseif ret[2] then
            table.remove(ret, 1)
            return unpack(ret)
        end
    end

    local hookdata = {
        registry = tbl,
        name_registry = tbln,
        varargs = {...},
        index = 0,
        name = name,
        id = "",
    }
    local already_processing = self.Processing
    self.Processing = hookdata

    local count, max = 0, #tbl
    while true do
        count = count + 1
        xpcall(self.ProcessHook, self.CatchHook, hookdata, ...) -- instead of calling xpcall in a for loop, we invoke it only once
        if count >= max or hookdata.finished == true then break end
    end

    local returns = self.Processing.returns
    self.Processing = already_processing
    hookdata = nil
    if returns then
        return unpack(returns)
    end
end

function hook:GetTable() -- Need the table of hooks or no?
    return self.registry
end
local connections = {}
hook.connections = connections
function hook:bindEvent(event, name) -- Creates a hook instance for a roblox signal, only use this for permanent binds NOT temporary!
    local con = event:Connect(function(...)
        self:CallP(name, ...)
    end)
    table.insert(connections, con)
    return con
end
--[[
function original_func = hook:BindFunction(function func, string name, any extra [vararg])
- Automatically hooks a function and adds it to the hook registry
- hooks called: Pre[name], Post[name]
    - Pre: ran before the function, use this for pre stuff
    - Post: ran after the function, use this for post stuff

function original_func = hook:bindFunctionReturn(function func, string name, any extra)
- Automatically hooks a function and adds it to the hook registry with return override capabilities
- hooks called: Suppress[name], Pre[name], Post[name]
    - Suppress: ran before the function, by returning true, you will prevent anything else from running
    - Pre: ran before the function, by returning values in table format will override the inputs to the function
        ex: return {networkname, arguments_of_network}
    - Post: ran after the function, use this for post stuff
]]

local syn_error_bind = syn.on_error_report:Connect(function(thread, error_str, call_stack, options)
    if hook.binding_trace > 0 then
        hook.binding_trace = hook.binding_trace - 1
    end
end)

hook.bindings = {}
hook.binding_trace = 0
function hook:BindFunction(func, name, metafunction, ...)
    local t = {self, func, name, metafunction, {...}}
    t[2] = hookfunction(func, function(...)
        local hook = t[1]
        if hook.killed then return t[2](...) end
        local extra_add = {}
        local extra_len = #t[5]
        for i=1, extra_len do
            extra_add[i] = t[5][i]
        end
        local vararg = {...}
        for i=1, #vararg do
            extra_add[#extra_add+1] = vararg[i]
        end
        if t[4] then
            table.remove(extra_add, 1)
        end
        hook:CallP("Pre" .. t[3], unpack(extra_add))
        hook.binding_trace = hook.binding_trace + 1
        local args = {t[2](...)}
        hook.binding_trace = hook.binding_trace - 1
        if t[5] ~= nil then
            table.insert(args, 1, t[5])
        end
        for i=1, extra_len do
            table.insert(args, 1, t[5][extra_len-i+1])
        end
        for i=1, #vararg do
            args[#args+1] = vararg[i]
        end
        if t[4] then
            table.remove(args, 1)
        end
        hook:CallP("Post" .. t[3], unpack(args))
        return unpack(args)
    end)
    self.bindings[#self.bindings+1] = {name, func}
    return t[2]
end

function hook:BindFunctionOverride(func, name, metafunction, ...)
    local t = {self, func, name, metafunction, false, {...}}
    t[2] = hookfunction(func, function(...)
        local hook = t[1]
        if hook.killed then return t[2](...) end
        local extra_add = {}
        local extra_len = #t[6]
        for i=1, extra_len do
            extra_add[i] = t[6][i]
        end
        local vararg = {...}
        for i=1, #vararg do
            extra_add[#extra_add+1] = vararg[i]
        end
        local self_meta
        if t[4] then
            self_meta = vararg[1]
            table.remove(extra_add, 1)
        end
        if not t[5] then
            t[5] = true
            local s = hook:CallP("Suppress" .. t[3], unpack(extra_add))
            t[5] = false
            if s then return end
        end
        local override = {hook:CallP("Pre" .. t[3], unpack(extra_add))}
        local overwrite = override[1] == nil
        if overwrite then
            override = vararg
        elseif self_meta ~= nil then
            table.insert(override, 1, self_meta)
        end
        if overwrite then
            hook.binding_trace = hook.binding_trace + 1
        end
        local args = {t[2](unpack(override))}
        if overwrite then
            hook.binding_trace = hook.binding_trace - 1
        end
        local len = #override
        for i=1, len do
            table.insert(args, 1, override[len-i+1])
        end
        if self_meta ~= nil then
            table.remove(args, 1)
        end
        for i=1, extra_len do
            table.insert(args, 1, t[6][extra_len-i+1])
        end
        hook:CallP("Post" .. t[3], unpack(args))
        return unpack(args)
    end)
    self.bindings[#self.bindings+1] = {name, func}
    return t[2]
end

function hook:UnBindFunction(name)
    local bindings = self.bindings
    local c = 0
    for i=1, #bindings do
        local data = bindings[i-c]
        if data[1] == name then
            restorefunction(data[2])
            table.remove(bindings, i-c)
            c=c+1
        end
    end
end

return hook