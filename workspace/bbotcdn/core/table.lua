local _rawset = rawset
local dcopy
dcopy = function( t, lookup_table )
	if ( t == nil ) then return nil end

	local copy = {}
	setmetatable( copy, debug.getmetatable( t ) )
	for i, v in pairs( t ) do
		if ( typeof( v ) ~= "table" ) then
			if v ~= nil then
				_rawset(copy, i, v)
			end
		else
			lookup_table = lookup_table or {}
			lookup_table[ t ] = copy
			if ( lookup_table[ v ] ) then
				_rawset(copy, i, lookup_table[ v ])
			else
				_rawset(copy, i, dcopy( v, lookup_table ))
			end
		end
	end
	return copy
end

local table = dcopy(table)
table.deepcopy = dcopy

function table.quicksearch(tbl, value)
	for i=1, #tbl do
		if tbl[i] == value then return true end
	end
	return false
end

-- reverses a numerical table
function table.reverse(tbl)
	local new_tbl = {}
	for i = 1, #tbl do
		new_tbl[#tbl + 1 - i] = tbl[i]
	end
	return new_tbl
end

function table.fyshuffle( tInput ) -- oh thats cool, fisher-yates shuffle (i think its called)
	local tReturn = {}
	for i = #tInput, 1, -1 do
		local j = math.random(i)
		tInput[i], tInput[j] = tInput[j], tInput[i]
		table.insert(tReturn, tInput[i])
	end
	return tReturn
end

function table.recursion( tbl, cb, pathway )
	pathway = pathway or {}
	for k, v in pairs( tbl ) do
		local newpathway = table.deepcopy(pathway)
		newpathway[#newpathway+1] = k
		if typeof( v ) == "table" and cb(newpathway, v) ~= false then
			table.recursion( v, cb, newpathway)
		else
			cb(newpathway, v)
		end
	end
end

function table.deeprestore(tbl)
	for k, v in next, tbl do
		if type(v) == "function" and is_synapse_function(v) then
			for k1, v1 in next, getupvalues(v) do
				if type(v1) == "function" and islclosure(v1) and not is_synapse_function(v1) then
					tbl[k] = v1
				end
			end
		end
		if type(v) == "table" then
			table.deeprestore(v)
		end
	end
end

function table.deepcleanup(tbl)
	local numTable = #tbl
	local isTableArray = numTable > 0
	if isTableArray then
		for i = 1, numTable do
			local entry = tbl[i]
			local entryType = type(entry)
			if entryType == "table" then
				table.deepcleanup(tbl)
			end
			tbl[i] = nil
		end
	else
		for k, v in next, tbl do
			if type(v) == "table" then
				table.deepcleanup(tbl)
			end
		end
		tbl[k] = nil
	end
end

local function keyValuePairs( state )
	state.Index = state.Index + 1
	local keyValue = state.KeyValues[ state.Index ]
	if ( not keyValue ) then return end
	return keyValue.key, keyValue.val
end

local function toKeyValues( tbl )
	local result = {}
	for k,v in pairs( tbl ) do
		table.insert( result, { key = k, val = v } )
	end
	return result
end

function table.sortedpairs( pTable, Desc )
	local sortedTbl = toKeyValues( pTable )
	if ( Desc ) then
		table.sort( sortedTbl, function( a, b ) return a.key > b.key end )
	else
		table.sort( sortedTbl, function( a, b ) return a.key < b.key end )
	end
	return keyValuePairs, { Index = 0, KeyValues = sortedTbl }
end

return table