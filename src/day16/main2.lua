local pph = require("pph")

-- 473 - too high
-- THIS DOESN'T GET THE RIGHT OUTPUT
-- YOU HAVE TO MANUALLY REVIEW THE OUTPUT AND FIX IT

local copy = require("array.copy")
local set_add = require("array.bset_add")
local set_del = require("array.bset_del")
local sort = require("mergesort")
local bsearch = require("binarysearch")
local search = require("search")

local scroller = require("2dscroller")

local get_input = require("day16.input")

local g = require("grid.grid")

local grid, width, height
local s, e

local c_visited
local e_score
local e_scores

local currentx, currenty
local currentscore

local offsetx, offsety
local autoscroll

local cor

local function navigate_grid()
	local stack = { s }
	local v_stack = {}

	c_visited = v_stack


	while #stack > 0 do
		local front = deli(stack)
		local x, y, score = front.x, front.y, front.score

		currentx, currenty = x, y
		currentscore = score

		-- pph.info(string.format("Visited Count: %d; Current Visited: %d", #v_stack, front.visited))
		while #v_stack > front.visited - 1 do
			local v = deli(v_stack)
			-- mark grid as not visited
			local vx, vy = g.decode_pos(v, width, height)
			grid[vy][vx][4] = false
			-- pph.info(string.format("Removing %d, %d", g.decode_pos(v, width, height)))
		end

		add(v_stack, g.encode_pos(x, y, width, height))


		local dirs = {
			{front.d, 1},
			{(front.d + 2) % 8, 1001},
			{(front.d - 2) % 8, 1001}
		}

		for dir in all(dirs) do
			local d, dscore = table.unpack(dir)

			local ax, ay = g.find_adjacent(x, y, d)
			if g.is_in_bounds(ax, ay, width, height) then
				local acell, ascore = grid[ay][ax][1], grid[ay][ax][5][d]

				local new_score = score + dscore
				if (acell == "." or acell == "E") and new_score < ascore and new_score <= e_score then
					-- pph.info(string.format("Found adjacent %d, %d (%s) in direction %s", ax, ay, acell, g.Directions[d]))
					-- pph.info(string.format("Adjacent Score: %d, New Score: %d", ascore, new_score))

					-- if not visited
					if not grid[ay][ax][4] then
						-- pph.info(string.format("Adding %d, %d to queue", ax, ay))
						grid[ay][ax][4] = true
						grid[ay][ax][5][d] = new_score

						if acell ~= "E" then
							add(stack, { x = ax, y = ay, d = d, score = new_score, visited = #v_stack + 1 })
						end
					end
				end

				if new_score == ascore and bsearch(e_scores, g.encode_pos(ax, ay, width, height)) > 0 then
					pph.info("On Best Path")
					pph.info(string.format("New Score: %d, Adjacent Score: %d", new_score, ascore))
					yield()
					for i in all(v_stack) do
						set_add(e_scores, i)
					end
				end

				if acell == "E" then
					if e_score > new_score then
						e_score = new_score

						-- pph.info(string.format("Score: %d, New Score: %d; Replacing visited", ascore, new_score))
						e_scores = {}

						for i in all(v_stack) do
							set_add(e_scores, i)
						end
					elseif e_score == new_score then
						-- pph.info(string.format("Score: %d, New Score: %d; Adding to visited", ascore, new_score))
						for i in all(v_stack) do
							set_add(e_scores, i)
						end
					end

					yield()
				end
			end
		end

		-- yield()
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 16 - Part 2"
	})

	currentx, currenty = 1, 1
	currentscore = 0
	offsetx = 0
	offsety = 0

	e_score = math.maxinteger

	c_visited = {}
	e_scores = {}

	-- grid, width, height, s, e = get_input("day16/p1test.txt")
	-- e_score = 7036
	-- grid, width, height, s, e = get_input("day16/p1test2.txt")
	-- e_score = 11048
	grid, width, height, s, e = get_input("day16/p1data.txt")
	e_score = 72428
end

local function _update()
	if cor == nil then
		cor = cocreate(navigate_grid)
	end

	-- if costatus(cor) ~= "dead" then
	if costatus(cor) ~= "dead" and btnp(5) then
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
			local cell, col = grid[i + offsety][j + offsetx][1], grid[i + offsety][j + offsetx][2]
			print(cell, (j - 1) * 8, (i - 1) * 8, col)
		end
	end

	for i in all(e_scores) do
		local ex, ey = g.decode_pos(i, width, height)
		print("=", (ex - 1 - offsetx) * 8, (ey - 1 - offsety) * 8, 29)
	end

	for i in all(c_visited) do
		local ex, ey = g.decode_pos(i, width, height)
		print("!", (ex - 1 - offsetx) * 8, (ey - 1 - offsety) * 8, 18)
	end

	print("@", (currentx - 1 - offsetx) * 8, (currenty - 1 - offsety) * 8, 12)

	print(string.format("\f7Current Score: \fe%d\f7", currentscore), 128, 0)
	print(string.format("\f7Final Score: \fe%d\f7", e_score), 128, 8)
	print(string.format("\f7Best Paths: \fe%d\f7", #e_scores + 1), 128, 16)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
