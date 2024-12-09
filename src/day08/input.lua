local function get_input(filename)
	local input = fetch(filename)
	--- @cast input string

	local positions = {}
	local grid = {}

	for i, l in ipairs(split(input, "\n", false)) do
		if l == "" then
			break
		end

		grid[i] = {}
		for j, cell in ipairs(split(l, "", false)) do
			col = 7
			if cell ~= "." then
				col = 11

				if positions[cell] == nil then
					positions[cell] = {}
				end

				add(positions[cell], vec(j, i))
			end

			add(grid[i], { cell, col })
		end
	end

	return grid, #grid[1], #grid, positions
end

return get_input
