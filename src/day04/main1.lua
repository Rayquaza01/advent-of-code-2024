-- local pph = require("pph")

local load_input = require("day04.input")

local g = require("grid.grid")

local grid
local position

local total
local matches

local test
local letters

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

	if grid[y][x] == "X" then
		-- pph.info("Found X")
		for d = 1, 8, 1 do
			-- pph.info("Testing Direction " .. d)
			test = {{ x = x, y = y }}

			local current = 1
			local valid = true

			while valid do
				if current > 3 then
					for item in all(test) do
						add(matches, item)
					end

					-- why does this need to be reset to an inital value here here?
					-- it should reset in the outer loop???
					test = {{ x = x, y = y }}
					-- pph.info("Added matches")

					total += 1
					valid = false
					-- yield()
				end

				local nx, ny = g.find_adjacent(test[#test].x, test[#test].y, d)
				-- pph.info(string.format("Adjacent: %d, %d", nx, ny))
				if g.is_in_bounds(nx, ny, width, height) then
					if grid[ny][nx] == letters[current] then
						-- pph.info("Found " .. letters[current])
						add(test, { x = nx, y = ny })
						current += 1
						-- yield()
					else
						-- pph.warn("Letter doesn't match")
						-- break if doesn't match letter
						test = {}
						valid = false
						-- yield()
					end
				else
					-- pph.warn("OOB")
					-- break if oob
					test = {}
					valid = false
					-- yield()
				end
			end
		end
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 4 - Part 1"
	})

	autoscroll = true

	-- grid, width, height = load_input("day04/p1test.txt")
	grid, width, height = load_input("day04/p1data.txt")

	total = 0
	test = {}
	matches = {}

	position = 0

	cor = nil

	letters = { "M", "A", "S" }
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

	for t in all(test) do
		if g.is_in_bounds((t.x - offsetx - 1) * 8, (t.y - offsety - 1) * 8, 256, 128) then
			print(grid[t.y][t.x], (t.x - offsetx - 1) * 8, (t.y - offsety - 1) * 8, 28)
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
