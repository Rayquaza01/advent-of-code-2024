local g = require("grid.grid")
local gsplit = require("string.gsplit")

local dirmap = {
	["^"] = g.Directions.UP,
	["v"] = g.Directions.DOWN,
	["<"] = g.Directions.LEFT,
	[">"] = g.Directions.RIGHT
}

local function get_input(file)
	local input = fetch(file)
	--- @cast input string

	local ginput, dinput
	for a, b in input:gmatch("(.-)\n\n(.+)") do
		ginput, dinput = a, b
	end

	printh(ginput)
	printh(dinput)


	local start = { x = 1, y = 1 }
	local grid = {}
	for i, l in ipairs(split(ginput, "\n", false)) do
		if l == "" then
			break
		end

		grid[i] = {}

		for j, cell in ipairs(split(l, "", false)) do
			local col = 6
			if cell == "@" then
				start = { x = j, y = i }
				col = 12
			elseif cell == "O" then
				col = 3
			elseif cell == "#" then
				col = 8
			end

			grid[i][j] = { cell, col }
		end
	end

	local directions = {}
	for l in all(split(dinput, "\n", false)) do
		if l == "" then
			break
		end

		for dir in all(split(l, "", false)) do
			add(directions, dirmap[dir])
		end
	end

	return grid, #grid[1], #grid, start, directions
end

return get_input
