local amap = require("array.map")

--- @param file string
--- @return table, integer, integer
local function load_input(file)
	if fstat(file) then
		local input = fetch(file)
		--- @cast input string

		local grid = amap(
			split(input, "\n", false),
			function (line)
				return amap(
					split(line, "", false),
					function (cell)
						return { cell, 7 }
					end
				)
			end
		)

		-- trim final newline
		deli(grid, #grid)

		local width = #grid[1]
		local height = #grid

		return grid, width, height
	end

	return {}, 0, 0
end

return load_input
