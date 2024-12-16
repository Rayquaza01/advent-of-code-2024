local g = require("grid.grid")

local function get_input(file)
	local input = fetch(file)
	--- @cast input string

	local grid = {}

	local s = { x = 1, y = 1, d = g.Directions.RIGHT, score = 0, visited = 1 }
	local e = { x = 1, y = 1 }

	for i, l in ipairs(split(input, "\n", false)) do
		if l == "" then
			break
		end

		grid[i] = {}

		for j, cell in ipairs(split(l, "", false)) do
			local score = math.maxinteger
			local col = 6
			local visited = false
			if cell == "S" then
				col = 8
				depth = 0
				s.x, s.y = j, i
				visited = true
			elseif cell == "E" then
				col = 11
				e.x, e.y = j, i
			elseif cell == "#" then
				col = 4
			end

			add(grid[i], { cell, col, score, visited, { [1] = score, [3] = score, [5] = score, [7] = score } })
		end
	end

	return grid, #grid[1], #grid, s, e
end

return get_input
