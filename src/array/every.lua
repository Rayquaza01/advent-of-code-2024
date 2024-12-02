--- Returns true if every item in the array matches the condition
--- @param arr table
--- @param cond function
local function every(arr, cond)
	for k, v in ipairs(arr) do
		if not cond(v, k, arr) then
			return false
		end
	end

	return true
end

return every
