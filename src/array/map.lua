--- Maps a function over an array
--- @param arr table
--- @param cb function
local function map(arr, cb)
	local res = {}
	for k = 1, #arr, 1 do
		local v = arr[k]

		add(res, cb(v, k, arr))
	end

	return res
end

return map
