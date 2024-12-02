--- Makes a shallow copy of a table
--- @param arr table
--- @return table
local function copy(arr)
	local res = {}
	for k = 1, #arr, 1 do
		res[k] = arr[k]
	end

	return res
end

return copy
