local pph = require("pph")

local load_input = require("day04.input")

local g = require("grid.grid")

local dbg

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

local function search_grid()
	for y = 1, height, 1 do
		for x = 1, width, 1 do
			position = { x = x, y = y }
			pph.info(string.format("Testing tile %d, %d", x, y))

			if grid[y][x][1] == "X" then
				-- pph.info("Found X")
				for d = 1, 8, 1 do
					-- pph.info("Testing Direction " .. d)
					-- list of items to be tested
					test = {{ x = x, y = y }}

					-- current letter
					local current = 1
					-- is pattern matching so far
					local valid = true

					while valid do
						if current > 3 then
							for item in all(test) do
								grid[item.y][item.x][2] = 11
							end

							-- why does this need to be reset to an inital value here here?
							-- it should reset in the outer loop???
							test = {{ x = x, y = y }}
							pph.info("Added matches")

							total += 1
							valid = false
							if dbg then yield() end
						end

						local nx, ny = g.find_adjacent(test[#test].x, test[#test].y, d)
						pph.info(string.format("Adjacent: %d, %d", nx, ny))
						if g.is_in_bounds(nx, ny, width, height) then
							if grid[ny][nx][1] == letters[current] then
								pph.info("Found " .. letters[current])
								add(test, { x = nx, y = ny })
								current += 1
								if dbg then yield() end
							else
								pph.warn("Letter doesn't match")
								-- break if doesn't match letter
								valid = false
								if dbg then yield() end
							end
						else
							pph.warn("OOB")
							-- break if oob
							valid = false
							if dbg then yield() end
						end
					end
				end
			end

			-- finished checking tile
			test = {}
			-- yield()
		end
	end
end

local function _init()
	dbg = false

	window({
		width = 256, height = 128,
		title = "AoC Day 4 - Part 1"
	})

	autoscroll = true

	-- grid, width, height = load_input("day04/p1test.txt")
	grid, width, height = load_input("day04/p1data.txt")

	total = 0
	test = {}

	position = { x = 1, y = 1 }

	cor = nil

	letters = { "M", "A", "S" }
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

	offsetx = mid(0, max(width - 32, 0), offsetx)
	offsety = mid(0, max(height - 16, 0), offsety)
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

	for t in all(test) do
		print(grid[t.y][t.x][1], (t.x - offsetx - 1) * 8, (t.y - offsety - 1) * 8, 28)
	end

	rectfill(0, 120, 64, 128, 0)
	print(string.format("\f7Total: \fe%d\f7", total), 0, 120)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
