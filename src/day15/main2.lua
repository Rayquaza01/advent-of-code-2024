local pph = require("pph")

-- 1528453
-- not 1533021 - too high

local scroller = require("2dscroller")

local g = require("grid.grid")
local get_input = require("day15/input2")

local grid
local width
local height
local start
local directions

local gps_score

local offsetx
local offsety
local autoscroll

local cor

local function is_movable(x, y, d)
	local ax, ay = g.find_adjacent(x, y, d)
	if g.is_in_bounds(ax, ay, width, height) then
		local acell = grid[ay][ax][1]

		if acell == "." then
			-- if adjacent is air, then movable
			return true
		elseif acell == "[" or acell == "]" then
			if d == g.Directions.UP or d == g.Directions.DOWN then
				local bx, by
				if acell == "[" then
					bx, by = g.find_adjacent(ax, ay, g.Directions.RIGHT)
				else
					bx, by = g.find_adjacent(ax, ay, g.Directions.LEFT)
				end

				-- if adjacent is left box, and direction is up/down
				-- only movable if right box is also movable

				return is_movable(ax, ay, d) and is_movable(bx, by, d)
			else
				-- if direction is left/right, movable if adjacent is movable

				return is_movable(ax, ay, d)
			end
		end

		return false
	else
		return false
	end
end

--- Moves items in on the grid. If test is set, only check if items are moveable
--- @param x integer
--- @param y integer
--- @param d integer
local function move_item_in_grid(x, y, d)
	local ax, ay = g.find_adjacent(x, y, d)

	if g.is_in_bounds(ax, ay, width, height) then
		local acell = grid[ay][ax][1]

		if acell == "#" then
			pph.info("Found wall, can't move")
			-- can't move walls
			return false
		elseif acell == "[" or acell == "]" then
			if d == g.Directions.UP or d == g.Directions.DOWN then
				local bx, by
				if acell == "[" then
					bx, by = g.find_adjacent(ax, ay, g.Directions.RIGHT)
				else
					bx, by = g.find_adjacent(ax, ay, g.Directions.LEFT)
				end

				if is_movable(ax, ay, d) and is_movable(bx, by, d) then
					move_item_in_grid(ax, ay, d)
					move_item_in_grid(bx, by, d)

					pph.info("Moved both box components")
					grid[ay][ax], grid[y][x] = grid[y][x], grid[ay][ax]
					return true
				else
					pph.info("Couldn't move both box components")
					return false
				end
			else
				if move_item_in_grid(ax, ay, d) then
					pph.info("Adjacent boxes moved, swapped current cell with air")

					grid[ay][ax], grid[y][x] = grid[y][x], grid[ay][ax]

					return true
				else
					pph.info("Couldn't move adjacent boxes")
				end
			end

			return false
		elseif acell == "." then
			pph.info("Swapped current cell with air")

			grid[ay][ax], grid[y][x] = grid[y][x], grid[ay][ax]
			return true
		end
	else
		pph.warn("OOB")
		-- if oob, cant move
		return false
	end
end

local function navigate()
	local x, y = start.x, start.y

	for d in all(directions) do
		pph.info("Direction: " .. g.Directions[d])
		if move_item_in_grid(x, y, d) then
			x, y = g.find_adjacent(x, y, d)
			start = { x = x, y = y }
		end

		-- yield()
	end

	for i = 1, height, 1 do
		for j = 1, width, 1 do
			local cell = grid[i][j][1]
			if cell == "[" then
				gps_score += 100 * (i - 1) + (j - 1)
			end
		end
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 15 - Part 2"
	})

	gps_score = 0

	offsetx = 0
	offsety = 0
	autoscroll = true

	-- grid, width, height, start, directions = get_input("day15/p1test.txt")
	grid, width, height, start, directions = get_input("day15/p1data.txt")
end

local function _update()
	if cor == nil then
		cor = cocreate(navigate)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end

	-- if keyp("a") then
	-- 	local x, y = start.x, start.y
	-- 	local d = g.Directions.LEFT
	-- 	if move_item_in_grid(x, y, d) then
	-- 		x, y = g.find_adjacent(x, y, d)
	-- 		start = { x = x, y = y }
	-- 	end
	-- end
	-- if keyp("d") then
	-- 	local x, y = start.x, start.y
	-- 	local d = g.Directions.RIGHT
	-- 	if move_item_in_grid(x, y, d) then
	-- 		x, y = g.find_adjacent(x, y, d)
	-- 		start = { x = x, y = y }
	-- 	end
	-- end
	-- if keyp("w") then
	-- 	local x, y = start.x, start.y
	-- 	local d = g.Directions.UP
	-- 	if move_item_in_grid(x, y, d) then
	-- 		x, y = g.find_adjacent(x, y, d)
	-- 		start = { x = x, y = y }
	-- 	end
	-- end
	-- if keyp("s") then
	-- 	local x, y = start.x, start.y
	-- 	local d = g.Directions.DOWN
	-- 	if move_item_in_grid(x, y, d) then
	-- 		x, y = g.find_adjacent(x, y, d)
	-- 		start = { x = x, y = y }
	-- 	end
	-- end

	if autoscroll then
		offsetx = mid(0, width - 33, flr(start.x / 32) * 32)
		offsety = mid(0, height - 17, flr(start.y / 16) * 16)
	end

	offsetx, offsety, autoscroll = scroller(offsetx, offsety, width - 32, height - 16, 1, autoscroll)

	offsetx = mid(offsetx, 0, max(width - 33, width))
	offsety = mid(offsety, 0, max(height - 17, height))
end

local function _draw()
	cls()

	for i = 1, min(16, height), 1 do
		for j = 1, min(32, width), 1 do
			local cell, col = table.unpack(grid[i + offsety][j + offsetx])
			print(cell, (j - 1) * 8, (i - 1) * 8, col)
		end
	end

	print(string.format("\f7GPS Score: \fe%d\f7", gps_score), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
