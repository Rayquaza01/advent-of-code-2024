--- Maps a function over an array
--- @param arr table
--- @param cb function
local function map(arr, cb)
	local res = {}
	for k, v in ipairs(arr) do
		add(res, cb(v, k, arr))
	end

	return res
end

return map
