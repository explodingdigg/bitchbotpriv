local math = BBOT.math
local string = BBOT.table.deepcopy(string)

function string.cut(s1, num)
    return num == 0 and s1 or string.sub(s1, 1, num)
end

function string.random(len, len2)
    local str, length = "", (len2 and math.random(len, len2) or len)
    for i = 1, length do
        local typo = math.random(1, 3)
        if typo == 1 then
            str = str.. string.char(math.random(97, 122))
        elseif typo == 2 then
            str = str.. string.char(math.random(65, 90))
        elseif typo == 3 then
            str = str.. string.char(math.random(49, 57))
        end
    end
    return str
end

local _string_rep = string.rep
local _string_len = string.len
local _string_sub = string.sub
local _table_concat = table.concat
local _tostring = tostring
local _string_find = string.find
function string.Explode(separator, str, withpattern)
    if ( withpattern == nil ) then withpattern = false end

    local ret = {}
    local current_pos = 1

    for i = 1, _string_len( str ) do
        local start_pos, end_pos = _string_find( str, separator, current_pos, not withpattern )
        if ( not start_pos ) then break end
        ret[ i ] = _string_sub( str, current_pos, start_pos - 1 )
        current_pos = end_pos + 1
    end

    ret[ #ret + 1 ] = _string_sub( str, current_pos )

    return ret
end

function string.Replace( str, tofind, toreplace )
    local tbl = string.Explode( tofind, str )
    if ( tbl[ 1 ] ) then return _table_concat( tbl, toreplace ) end
    return str
end

function string.WrapText(text, font, size, width)
    local font_system = BBOT.font
    local font_data = font
    if tostring(font_data) ~= "Font" then
        font_data = font_system:GetFont(font_data)
    end
    local font_size = font_data:GetTextBounds(size, ' ')
    if not font_size then return {text} end
    local sw = font_size.X

    local ret = {}

    local t2 = string.Explode('\n', text, false)
    for k=1, #t2 do
        local v = t2[k]
        ret[#ret + 1] = v
    end

    local ret_proccessed = {}

    local w = 0
    local s = ''
    for k=1, #ret do
        local text = ret[k]

        local t2 = string.Explode(' ', text, false)
        for i2 = 1, #t2 do
            local neww = font_data:GetTextBounds(size, t2[i2]).X
            
            if (w + neww >= width) then
                ret_proccessed[#ret_proccessed + 1] = s
                w = neww + sw
                s = t2[i2] .. ' '
            else
                s = s .. t2[i2] .. ' '
                w = w + neww + sw
            end
        end
        ret_proccessed[#ret_proccessed + 1] = s
        w = 0
        s = ''
        
        if (s ~= '') then
            ret_proccessed[#ret_proccessed + 1] = s
        end
    end

    return ret_proccessed
end

return string