local pph = require("pph")

local scroller = require("2dscroller")
local autoscroll
local offsetx
local offsety

local get_input = require("day08.input")

local g = require("grid.grid")

local grid
local width
local height
local tower_positions

local total_antinodes

local current_towers
local current_vec

local cor

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 8 - Part 1"
	})

	autoscroll = true
	offsetx = 0
	offsety = 0

	total_antinodes = 0

	-- grid, width, height, tower_positions = get_input("day08/p1test.txt")
	grid, width, height, tower_positions = get_input("day08/p1data.txt")
end

local function find_antinodes()
	-- pph.info(pod(tower_positions))

	for freq, towers in pairs(tower_positions) do
		--- @cast towers userdata[]

		pph.info("Checking " .. freq)
		for i = 1, #towers, 1 do
			for j = i + 1, #towers, 1 do
				current_towers = { towers[i], towers[j] }

				-- local ix, iy = towers[i]:get(0, 2)
				-- local jx, jy = towers[j]:get(0, 2)

				-- pph.info(string.format("Tower 1: %d, %d", ix, iy))
				-- pph.info(string.format("Tower 2: %d, %d", jx, jy))

				-- get vector from tower i to tower j
				local diff = towers[j] - towers[i]
				--- @cast diff userdata
				current_vec = diff

				yield()

				-- local dx, dy = diff:get(0, 2)
				-- pph.info(string.format("Diff: %d, %d", dx, dy))

				local x1, y1 = (towers[i] - diff):get(0, 2)
				if g.is_in_bounds(x1, y1, width, height) then
					if grid[y1][x1][1] ~= "#" then
						grid[y1][x1][1] = "#"
						grid[y1][x1][2] = 8
						total_antinodes += 1
					end
				end

				yield()

				local x2, y2 = (towers[j] + diff):get(0, 2)
				if g.is_in_bounds(x2, y2, width, height) then
					if grid[y2][x2][1] ~= "#" then
						grid[y2][x2][1] = "#"
						grid[y2][x2][2] = 9
						total_antinodes += 1
					end
				end

				yield()
			end
		end
	end

	pph.info("Finished")
	current_towers = nil
end

local function _update()
	if cor == nil then
		cor = cocreate(find_antinodes)
	end

	if costatus(cor) ~= "dead" and btnp(5) then
	-- if costatus(cor) ~= "dead" then
		coresume(cor)
	end

	offsetx, offsety, autoscroll = scroller(offsetx, offsety, width - 32, height - 16, 1, autoscroll)

	offsetx = mid(offsetx, 0, max(width - 32, width))
	offsety = mid(offsety, 0, max(height - 16, width))
end

local function _draw()
	cls()

	for i = 1, min(height, 16) do
		for j = 1, min(width, 32) do
			local cell, col = unpack(grid[i + offsety][j + offsetx])
			print(cell, (j - 1) * 8, (i - 1) * 8, col)
		end
	end

	if current_towers and #current_towers == 2 then
		local x1, y1 = current_towers[1]:get(0, 2)
		local x2, y2 = current_towers[2]:get(0, 2)
		print(grid[y1][x1][1], (x1 - offsetx - 1) * 8, (y1 - offsety - 1) * 8, 28)
		print(grid[y2][x2][1], (x2 - offsetx - 1) * 8, (y2 - offsety - 1) * 8, 28)

		line((x1 - offsetx) * 8 - 6, (y1 - offsety) * 8 - 4, (x2 - offsetx) * 8 - 5, (y2 - offsety) * 8 - 4, 28)

		local dx, dy = current_vec:get(0, 2)
		line((x1 - offsetx) * 8 - 6, (y1 - offsety) * 8 - 4, (x1 - dx - offsetx) * 8 - 5, (y1 - dy - offsety) * 8 - 4, 8)
		line((x2 - offsetx) * 8 - 6, (y2 - offsety) * 8 - 4, (x2 + dx - offsetx) * 8 - 5, (y2 + dy - offsety) * 8 - 4, 9)
	end

	print(string.format("\f7Total Antinodes: \fe%d\f7", total_antinodes), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
