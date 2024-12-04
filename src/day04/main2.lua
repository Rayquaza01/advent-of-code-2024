local pph = require("pph")

local every = require("array.every")

local load_input = require("day04.input")

local g = require("grid.grid")

local grid
local position

local total
local matches

local width
local height

local offsetx = 0
local offsety = 0

local autoscroll

local cor

--- @param x integer
--- @param y integer
local function search_grid(x, y)
	-- pph.info(string.format("Testing tile %d, %d", x, y))

	if grid[y][x] == "A" then
		-- pph.info("Found an A")

		adjacents = {
			table.pack(g.find_adjacent(x, y, g.Directions.UP_LEFT)),
			table.pack(g.find_adjacent(x, y, g.Directions.DOWN_RIGHT)),
			table.pack(g.find_adjacent(x, y, g.Directions.UP_RIGHT)),
			table.pack(g.find_adjacent(x, y, g.Directions.DOWN_LEFT))
		}

		if every(adjacents, function (item) return g.is_in_bounds(item[1], item[2], width, height) end) then
			local ul = grid[adjacents[1][2]][adjacents[1][1]]
			local dr = grid[adjacents[2][2]][adjacents[2][1]]
			local ur = grid[adjacents[3][2]][adjacents[3][1]]
			local dl = grid[adjacents[4][2]][adjacents[4][1]]

			if ((ul == "S" and dr == "M") or (ul == "M" and dr == "S")) and
				((ur == "S" and dl == "M") or (ur == "M" and dl == "S")) then
				for item in all(adjacents) do
					add(matches, { x = item[1], y = item[2] })
					add(matches, { x = x, y = y })
				end
				total += 1

				-- pph.info("Found an X-MAS")
			else
				-- pph.warn(ul .. "A" .. dr)
				-- pph.warn(ur .. "A" .. dl)
				-- pph.warn("Not an X-MAS")
			end
		else
			-- pph.warn("OOB")
		end
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 4 - Part 2"
	})

	autoscroll = true

	-- grid, width, height = load_input("day04/p1test.txt")
	grid, width, height = load_input("day04/p1data.txt")

	total = 0
	matches = {}

	position = 0

	cor = nil
end

local function _update()
	local x, y = g.decode_pos(position, width, height)

	if cor == nil then
		cor = cocreate(search_grid)
	end

	if costatus(cor) ~= "dead" then
		coresume(cor, x, y)
	end

	if costatus(cor) == "dead" and position < width * height then
		cor = nil
		position += 1
	end

	if autoscroll then
		offsetx = x - 4
		offsety = y - 4
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

	offsetx = mid(0, width - 32, offsetx)
	offsety = mid(0, height - 16, offsety)
end

local function _draw()
	cls()

	local x, y = g.decode_pos(position, width, height)

	for i = 1, min(16, #grid), 1 do
		for j = 1, min(32, #grid[i]), 1 do
			print(grid[i + offsety][j + offsetx], (j - 1) * 8, (i - 1) * 8, 7)
		end
	end

	for m in all(matches) do
		if g.is_in_bounds((m.x - offsetx) * 8, (m.y - offsety) * 8, 256, 128) then
			print(grid[m.y][m.x], (m.x - offsetx - 1) * 8, (m.y - offsety - 1) * 8, 11)
		end
	end

	print(grid[y][x], (x - offsetx - 1) * 8, (y - offsety - 1) * 8, 10)

	rectfill(0, 120, 64, 128, 0)
	print(string.format("\f7Total: \fe%d\f7", total), 0, 120)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
