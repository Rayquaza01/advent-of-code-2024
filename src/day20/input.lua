local function get_input(file)
	local input = fetch(file)
	--- @cast input string

	local grid = {}

	local s = { x = 1, y = 1, cheated = false, current_distance = 0 }
	local e = { x = 1, y = 1, cheated = false, current_distance = 0 }

	for i, l in ipairs(split(input, "\n", false)) do
		if l == "" then
			break
		end

		grid[i] = {}
		for j, cell in ipairs(split(l, "", false)) do
			local col = 6
			local distance = math.maxinteger
			local visited = false
			if cell == "S" then
				s.x, s.y = j, i
				col = 8
			elseif cell == "E" then
				e.x, e.y = j, i
				col = 3
				distance = 0
				visited = true
			elseif cell == "#" then
				col = 4
			end

			grid[i][j] = { cell = cell, color = col, visited = visited, distance = distance }
		end
	end

	return grid, #grid[1], #grid, s, e
end

return get_input
