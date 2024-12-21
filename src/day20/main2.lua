local pph = require("pph")

-- not 497592 - too low

local get_input = require("day20.input")
local set_add = require("array.bset_add")

local g = require("grid.grid")

local scroller = require("2dscroller")

local function coord_compare(a, b)
	if a.y < b.y then
		return true
	elseif a.y == b.y then
		return a.x < b.x
	else
		return false
	end
end

local current
local current2
local total_distance
local total_save_100

local offsetx, offsety, autoscroll

local grid, width, height, s, e

local cor

local function find_distances()
	local stack = { e }

	local valid_tiles = {}
	set_add(valid_tiles, g.encode_pos(s.x, s.y, width, height))
	set_add(valid_tiles, g.encode_pos(e.x, e.y, width, height))

	while #stack > 0 do
		local top = deli(stack)

		current = top

		for d in all({g.Directions.UP, g.Directions.DOWN, g.Directions.LEFT, g.Directions.RIGHT}) do
			local ax, ay = g.find_adjacent(top.x, top.y, d)
			if g.is_in_bounds(ax, ay, width, height) then
				if grid[ay][ax].cell ~= "#" and grid[ay][ax].distance == math.maxinteger then
					grid[ay][ax].distance = total_distance
					add(stack, { x = ax, y = ay })
					set_add(valid_tiles, g.encode_pos(ax, ay, width, height))
				end
			end
		end

		total_distance += 1

		-- yield()
	end

	for i = 1, #valid_tiles, 1 do
		yield()
		local ix, iy = g.decode_pos(valid_tiles[i], width, height)
		local i_dist = grid[iy][ix].distance

		current = { x = ix, y = iy }

		for j = i + 1, #valid_tiles, 1 do
			local jx, jy = g.decode_pos(valid_tiles[j], width, height)
			local j_dist = grid[jy][jx].distance

			current2 = { x = jx, y = jy }

			local diff = math.abs(jy - iy) + math.abs(jx - ix)
			local dist = total_distance

			if diff <= 20 then
				if i_dist > j_dist then
					dist = total_distance - i_dist + j_dist + diff
				else
					dist = total_distance - j_dist + i_dist + diff
				end
			end

			-- pph.info(string.format("Distance: %d, Saved: %d", dist, total_distance - dist))

			if total_distance - dist >= 100 then
				total_save_100 += 1
				-- pph.info(total_save_100)
				-- yield()
			end

			-- yield()
		end
	end

end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 20 - Part 2"
	})

	offsetx = 0
	offsety = 0
	autoscroll = false

	current = { x = 1, y = 1 }
	current2 = { x = 1, y = 1 }
	total_distance = 1
	total_save_100 = 0

	-- grid, width, height, s, e = get_input("day20/p1test.txt")
	grid, width, height, s, e = get_input("day20/p1data.txt")
end

local function _update()
	if cor == nil then
		cor = cocreate(find_distances)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end

	offsetx, offsety, autoscroll = scroller(offsetx, offsety, width - 32, height - 16, 1, autoscroll)

	offsetx = mid(0, offsetx, max(width - 32, width))
	offsety = mid(0, offsety, max(height - 16, height))
end

local function _draw()
	cls()

	for i = 1, min(16, height), 1 do
		for j = 1, min(32, width), 1 do
			local cell, color = grid[i + offsety][j + offsetx].cell, grid[i + offsety][j + offsetx].color
			print(cell, (j - 1) * 8, (i - 1) * 8, color)
		end
	end

	print("@", (current.x - offsetx - 1) * 8, (current.y - offsety - 1) * 8, 12)
	print("$", (current2.x - offsetx - 1) * 8, (current2.y - offsety - 1) * 8, 13)

	print(string.format("\f7Total Distance: \fe%d\f7", total_distance), 128, 0)
	print(string.format("\f7Fast Paths: \fe%d\f7", total_save_100), 128, 8)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
