local pph = require("pph")

local g = require("grid.grid")
local bitw = require("bitw.bitw")

local get_input = require("day06.input")

local grid
local width
local height
local start

local offsetx = 0
local offsety = 0

local autoscroll

local visited_count

local symbols

local cor

local function navigate()
	local stack = { start }

	while #stack > 0 do
		local top = deli(stack)

		start = top

		local next_x, next_y = g.find_adjacent(top.x, top.y, top.direction)
		if g.is_in_bounds(next_x, next_y, width, height) then
			if grid[next_y][next_x][1] == "#" then
				top.direction += 2
				top.direction %= 8
				top.symbol = symbols[math.ceil(start.direction / 2)]

				add(stack, top)

				-- printh("Turning")
			else
				top.x = next_x
				top.y = next_y

				if grid[top.y][top.x][3] == 0 then
					visited_count += 1
				end

				grid[top.y][top.x][3] += 1 -- add visited

				add(stack, top)

				-- printh("Moving to " .. next_x .. "," .. next_y)
			end

			yield()
		end
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 6 - Part 1"
	})

	autoscroll = true

	visited_count = 1

	symbols = { "^", ">", "v", "<" }

	-- grid, width, height, start = get_input("day06/p1test.txt")
	grid, width, height, start = get_input("day06/p1data.txt")
end

local function _update()
	if cor == nil then
		cor = cocreate(navigate)
	end

	if costatus(cor) ~= "dead" then
		coresume(cor)
	end

	if autoscroll then
		offsetx = start.x - 16
		offsety = start.y - 8
	end

	if btn(0) then
		offsetx -= 1
		autoscroll = false
	end

	if btn(1) then
		offsetx += 1
		autoscroll = false
	end

	if btn(2) then
		offsety -= 1
		autoscroll = false
	end

	if btn(3) then
		offsety += 1
		autoscroll = false
	end

	if btn(4) then
		autoscroll = true
	end

	offsetx = mid(0, max(width - 32, 0), offsetx)
	offsety = mid(0, max(height - 16, 0), offsety)
end

local function _draw()
	cls()

	for i = 1, min(16, height), 1 do
		for j = 1, min(32, width), 1 do
			if i + offsety ~= start.y or j + offsetx ~= start.x then
				print(grid[i + offsety][j + offsetx][3] > 0 and "X" or grid[i + offsety][j + offsetx][1], (j - 1) * 8, (i - 1) * 8, grid[i + offsety][j + offsetx][2])
			end
		end
	end

	print(start.symbol, (start.x - offsetx - 1) * 8, (start.y - offsety - 1) * 8, 12)

	print(string.format("\f7Total Visited: \fe%d\f7", visited_count), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
