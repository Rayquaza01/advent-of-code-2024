local pph = require("pph")

-- not 1494618 - too high

local get_input = require("day12.input")

local scroller = require("2dscroller")

local autoscroll
local offsetx
local offsety

local g = require("grid.grid")

local coloridx = -1
local colors = { 8, 9, 10, 11, 12, 18, 24, 25, 26, 27, 28, 29 }

local grid
local width
local height

local current_area
local current_perim
local current_symbol
local total

local cor

local function find_perims()
	for i = 1, height, 1 do
		for j = 1, width, 1 do

			local stack = {{ x = j, y = i }}

			current_symbol = nil
			current_area = 0
			current_perim = 0

			while #stack > 0 do
				local top = deli(stack)
				local x, y = top.x, top.y

				local cell, color, visited = table.unpack(grid[y][x])

				if not visited and current_symbol == nil then
					coloridx += 1
					coloridx %= #colors
				end

				current_symbol = cell

				-- pph.info(string.format("Current Cell: %s", cell))

				-- only run checks if current cell isn't visited
				if not visited then
					current_area += 1
					grid[y][x][2] = colors[coloridx + 1]
					grid[y][x][3] = true -- set as visited

					for d in all({ g.Directions.UP, g.Directions.RIGHT, g.Directions.DOWN, g.Directions.LEFT }) do
						local ax, ay = g.find_adjacent(x, y, d)
						-- pph.info(string.format("Checking adjacent cell %d, %d in direction %d", x, y, d))

						if g.is_in_bounds(ax, ay, width, height) then
							local acell, acolor, avisited = table.unpack(grid[ay][ax])
							-- pph.info(string.format("Adjacent: %s", acell))

							-- pph.info(acell)
							-- pph.info(acolor)
							-- pph.info(avisited and "true" or "false")

							if cell ~= acell then
								current_perim += 1
							else
								if not avisited then
									-- pph.info("Not visited, adding to stack")
									add(stack, { x = ax, y = ay })
								end
							end
						else
							-- count oob as a perimeter
							-- pph.warn("OOB")
							current_perim += 1
						end

						-- yield()
					end

					-- yield()
				end
			end

			total += current_perim * current_area
		end
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 12 - Part 1"
	})

	offsetx = 0
	offsety = 0

	total = 0
	current_perim = 0
	current_area = 0

	-- grid, width, height = get_input("day12/p1test.txt")
	-- grid, width, height = get_input("day12/p1test1.txt")
	-- grid, width, height = get_input("day12/p1test2.txt")
	grid, width, height = get_input("day12/p1data.txt")
end

local function _update()
	if cor == nil then
		cor = cocreate(find_perims)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end

	offsetx, offsety = scroller(offsetx, offsety, width - 32, height - 16, 1, false)
end

local function _draw()
	cls()

	for i = 1, min(height, 16), 1 do
		for j = 1, min(width, 32), 1 do
			local cell, color, visited = table.unpack(grid[i + offsety][j + offsetx])
			print(cell, (j - 1) * 8, (i - 1) * 8, color)
		end
	end

	rectfill(128, 0, 256, 32, 0)
	print(string.format("\f7Current Symbol: \fe%s\f7", current_symbol or "nil"), 128, 0)
	print(string.format("\f7Current Area: \fe%d\f7", current_area), 128, 8)
	print(string.format("\f7Current Perimeter: \fe%d\f7", current_perim), 128, 16)
	print(string.format("\f7Total: \fe%d\f7", total), 128, 24)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
