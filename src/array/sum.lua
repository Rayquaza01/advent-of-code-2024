--- Sums the values in a table
--- @param arr table
--- @return number
local function sum(arr)
	local s = 0
	for i = 1, #arr, 1 do
		s += arr[i]
	end

	return s
end

return sum
