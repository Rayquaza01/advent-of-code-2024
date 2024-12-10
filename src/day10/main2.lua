local pph = require("pph")

local scroller = require("2dscroller")

local get_input = require("day10.input")

local g = require("grid.grid")

local grid
local width
local height
local trailheads

local total

local offsetx
local offsety
local autoscroll

local cor

local function clear_grid()
	for i = 1, height, 1 do
		for j = 1, width, 1 do
			grid[i][j][2] = 7
			grid[i][j][3] = false
		end
	end
end


local function travel_trail()
	printh(string.format("Total Trailheads: %d", #trailheads))
	for trailhead in all(trailheads) do
		clear_grid()

		yield()

		local stack = { trailhead }

		while #stack > 0 do
			local top = deli(stack)
			local x, y = top.x, top.y

			grid[y][x][2] = 12
			grid[y][x][3] = true

			if grid[y][x][1] == 9 then
				total += 1
			end

			for d in all({g.Directions.UP, g.Directions.RIGHT, g.Directions.DOWN, g.Directions.LEFT}) do
				local ax, ay = g.find_adjacent(x, y, d)
				if g.is_in_bounds(ax, ay, width, height) then
					-- if next tile is 1 above current
					if grid[ay][ax][1] - grid[y][x][1] == 1 then
						add(stack, { x = ax, y = ay })
					end
				end
			end

			yield()
		end
	end

	clear_grid()
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 10 - Part 2"
	})

	offsetx = 0
	offsety = 0
	autoscroll = true

	total = 0

	-- grid, width, height, trailheads = get_input("day10/p1test.txt")
	grid, width, height, trailheads = get_input("day10/p1data.txt")
end

local function _update()
	if cor == nil then
		cor = cocreate(travel_trail)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end

	offsetx, offsety, autoscroll = scroller(offsetx, offsety, width - 32, height - 16, 1, autoscroll)

	offsetx = mid(offsetx, 0, max(width - 32, width))
	offsety = mid(offsety, 0, max(height - 16, height))
end

local function _draw()
	cls()

	for i = 1, min(height, 16), 1 do
		for j = 1, min(width, 32), 1 do
			local cell = grid[i + offsety][j + offsetx]
			print(cell[1], (j - 1) * 8, (i - 1) * 8, cell[2])
		end
	end

	rectfill(0, 120, 128, 128, 0)
	print(string.format("\f7Total: \fe%d\f7", total), 0, 120)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
