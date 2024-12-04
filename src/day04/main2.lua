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

local function search_grid()
	for y = 1, height, 1 do
		for x = 1, width, 1 do
			-- pph.info(string.format("Testing tile %d, %d", x, y))

			position = { x = x, y = y }

			if grid[y][x][1] == "A" then
				-- pph.info("Found an A")

				adjacents = {
					table.pack(g.find_adjacent(x, y, g.Directions.UP_LEFT)),
					table.pack(g.find_adjacent(x, y, g.Directions.DOWN_RIGHT)),
					table.pack(g.find_adjacent(x, y, g.Directions.UP_RIGHT)),
					table.pack(g.find_adjacent(x, y, g.Directions.DOWN_LEFT))
				}

				if every(adjacents, function (item) return g.is_in_bounds(item[1], item[2], width, height) end) then
					local ul = grid[adjacents[1][2]][adjacents[1][1]][1]
					local dr = grid[adjacents[2][2]][adjacents[2][1]][1]
					local ur = grid[adjacents[3][2]][adjacents[3][1]][1]
					local dl = grid[adjacents[4][2]][adjacents[4][1]][1]

					if ((ul == "S" and dr == "M") or (ul == "M" and dr == "S")) and
						((ur == "S" and dl == "M") or (ur == "M" and dl == "S")) then
						for item in all(adjacents) do
							grid[item[2]][item[1]][2] = 11
							grid[y][x][2] = 11
						end
						total += 1

						-- pph.info("Found an X-MAS")
						-- yield()
					else
						-- pph.warn(ul .. "A" .. dr)
						-- pph.warn(ur .. "A" .. dl)
						-- pph.warn("Not an X-MAS")
						-- yield()
					end
				else
					-- pph.warn("OOB")
					-- yield()
				end
			end
			yield()
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

	position = { x = 1, y = 1 }

	cor = nil
end

local function _update()
	local x, y = position.x, position.y

	if cor == nil then
		cor = cocreate(search_grid)
	end

	if costatus(cor) ~= "dead" then
		coresume(cor)
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

	local x, y = position.x, position.y

	for i = 1, min(16, height), 1 do
		for j = 1, min(32, width), 1 do
			print(grid[i + offsety][j + offsetx][1], (j - 1) * 8, (i - 1) * 8, grid[i + offsety][j + offsetx][2])
		end
	end

	print(grid[y][x][1], (x - offsetx - 1) * 8, (y - offsety - 1) * 8, 10)

	rectfill(0, 120, 64, 128, 0)
	print(string.format("\f7Total: \fe%d\f7", total), 0, 120)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
