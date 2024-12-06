local amap = require("array.map")
local g = require("grid.grid")

local function get_input(filename)
	local input = fetch(filename)
	--- @cast input string

	local grid = {}
	local start = { direction = g.Directions.UP, symbol = "^" }

	local lines = split(input, "\n", false)
	for i, l in ipairs(lines) do
		if l == "" then
			break
		end

		local row = amap(split(l, "", false), function (item, j)
			local col = 7
			local visited = 0
			local visited_bitmap = 0
			if item == "^" then
				start.x = j
				start.y = i
				item = " "
				visited = 1
			elseif item == "#" then
				col = 4
			end
			return { item, col, visited, visited_bitmap }
		end)

		add(grid, row)
	end

	local height = #grid
	local width = #grid[1]

	return grid, width, height, start
end

return get_input
