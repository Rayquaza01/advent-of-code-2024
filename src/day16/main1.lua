local pph = require("pph")

local scroller = require("2dscroller")

local get_input = require("day16.input")

local g = require("grid.grid")

local grid, width, height
local s, e

local currentx, currenty
local currentscore

local offsetx, offsety
local autoscroll

local cor

local function navigate_grid()
	local queue = { s }

	while #queue > 0 do
		local front = deli(queue, 1)
		local x, y, score = front.x, front.y, front.score

		currentx, currenty = x, y
		currentscore = score

		local dirs = {
			{front.d, 1},
			{(front.d + 2) % 8, 1001},
			{(front.d - 2) % 8, 1001}
		}

		for dir in all(dirs) do
			local d, dscore = table.unpack(dir)

			local ax, ay = g.find_adjacent(x, y, d)
			if g.is_in_bounds(ax, ay, width, height) then
				local acell, ascore = grid[ay][ax][1], grid[ay][ax][3]

				-- pph.info(string.format("Found adjacent %d, %d (%s) in direction %s", ax, ay, acell, g.Directions[d]))
				-- pph.info(string.format("Adjacent Score: %d, New Score: %d", ascore, score + dscore))

				if acell == "." or acell == "E" then
					local new_score = score + dscore
					if ascore > new_score then
						-- pph.info(string.format("Adding %d, %d to queue", ax, ay))
						grid[ay][ax][3] = new_score
						add(queue, { x = ax, y = ay, d = d, score = new_score })
					end
				end
			end
		end

		-- yield()
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 16 - Part 1"
	})

	currentx, currenty = 1, 1
	currentscore = 0
	offsetx = 0
	offsety = 0

	-- grid, width, height, s, e = get_input("day16/p1test.txt")
	-- grid, width, height, s, e = get_input("day16/p1test2.txt")
	grid, width, height, s, e = get_input("day16/p1data.txt")
end

local function _update()
	if cor == nil then
		cor = cocreate(navigate_grid)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end

	offsetx, offsety, autoscroll = scroller(offsetx, offsety, width - 32, height - 16, 1, autoscroll)
end

local function _draw()
	cls()

	for i = 1, min(16, height), 1 do
		for j = 1, min(32, width), 1 do
			local cell, col = grid[i + offsety][j + offsetx][1], grid[i + offsety][j + offsetx][2]
			print(cell, (j - 1) * 8, (i - 1) * 8, col)
		end
	end

	print("@", (currentx - 1) * 8 - offsetx, (currenty - 1) * 8 - offsety, 12)

	print(string.format("\f7Current Score: \fe%d\f7", currentscore), 128, 0)
	print(string.format("\f7Final Score: \fe%d\f7", grid[e.y][e.x][3]), 128, 8)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
