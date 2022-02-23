local iterators = {}

function iterators.Wrapback(a, i, amt)
    -- a = the array being passed into the iterator
    -- i = current index to start at
    -- amt = the amount of times to return shit
    i -= 1
    local j = 0
    local s = #a
    return function()
        -- TODO: optimize this into a for loop instead
        -- idk why its a while loop rn lol
        while j < amt do
            i = i % s + 1
            j = j + 1
            return i, a[i]
        end
        return nil
    end
end

return iterators