local function get_input(filename)
	local input = fetch(filename)
	--- @cast input string

	local grid = {}

	for i, l in ipairs(split(input, "\n", false)) do
		if l == "" then
			break
		end

		grid[i] = {}

		for j, cell in ipairs(split(l, "", false)) do
			-- cell, color, visited
			add(grid[i], { cell, 7, false })
		end
	end

	return grid, #grid[1], #grid
end

return get_input
