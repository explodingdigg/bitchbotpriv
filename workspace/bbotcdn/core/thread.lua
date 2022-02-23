local thread = {}

function thread:Create(func, ...) -- improved... yay.
    local thread = coroutine.create(func)
    coroutine.resume(thread, ...)
    return thread
end

function thread:CreateMulti(obj, ...)
    local n = #obj
    if n > 0 then
        for i = 1, n do
            local t = obj[i]
            if type(t) == "table" then
                local d = #t
                assert(d ~= 0, "table inserted was not an array or was empty")
                assert(d < 3, ("invalid number of arguments (%d)"):format(d))
                local thetype = type(t[1])
                assert(
                    thetype == "function",
                    ("invalid argument #1: expected 'function', got '%s'"):format(tostring(thetype))
                )

                self:Create(t[1], unpack(t[2]))
            else
                self:Create(t, ...)
            end
        end
    else
        for i, v in pairs(obj) do
            self:Create(v, ...)
        end
    end
end

return thread