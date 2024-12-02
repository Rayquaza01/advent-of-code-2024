-- local pph = require("pph")

--- Returns true if every item in the array matches the condition
--- @param arr table
--- @param cond function
local function every(arr, cond)
	for k = 1, #arr, 1 do
		local v = arr[k]

		local c = cond(v, k, arr)
		-- pph.info(string.format("%s=%s %s", k, v, c and "[fg=2]true[/fg]" or "[fg=1]false[/fg]"))

		if not c then
			-- pph.info("Failed Test")
			return false
		end
	end

	-- pph.info("Passed Test")
	return true
end

return every
