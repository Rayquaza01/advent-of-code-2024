local function get_input(filename)
	local input = fetch(filename)
	--- @cast input string

	local grid = {}
	local trailheads = {}

	for i, l in ipairs(split(input, "\n", false)) do
		if l == "" then
			break
		end

		grid[i] = {}
		for j, cell in ipairs(split(l, "", false)) do
			if cell == "0" then
				add(trailheads, { x = j, y = i })
			end

			add(grid[i], { tonum(cell), 7, false })
		end
	end

	return grid, #grid[1], #grid, trailheads
end

return get_input
