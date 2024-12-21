local pph = require("pph")

-- not 1531 - too high
-- not 1529 - too low
-- output produces off by one, not sure why

local get_input = require("day20.input")

local g = require("grid.grid")

local current
local total_distance
local total_save_100

local grid, width, height, s, e

local cor

local function find_distances()
	local stack = { e }

	while #stack > 0 do
		local top = deli(stack)

		current = top

		for d in all({g.Directions.UP, g.Directions.DOWN, g.Directions.LEFT, g.Directions.RIGHT}) do
			local ax, ay = g.find_adjacent(top.x, top.y, d)
			if g.is_in_bounds(ax, ay, width, height) then
				if grid[ay][ax].cell ~= "#" and grid[ay][ax].distance == math.maxinteger then
					grid[ay][ax].distance = total_distance
					add(stack, { x = ax, y = ay })
				end
			end
		end

		total_distance += 1

		-- yield()
	end

	stack = { s }
	while #stack > 0 do
		local top = deli(stack, 1)

		current = top

		local cdist = top.current_distance
		local ccell = grid[top.y][top.x].cell
		for d in all({g.Directions.UP, g.Directions.DOWN, g.Directions.LEFT, g.Directions.RIGHT}) do
			local ax, ay = g.find_adjacent(top.x, top.y, d)
			if g.is_in_bounds(ax, ay, width, height) then
				local acell, avisited = grid[ay][ax].cell, grid[ay][ax].visited
				if acell == "#" and not top.cheated then
					local a = {
						x = ax, y = ay,
						cheated = true,
						current_distance = cdist + 1
					}
					grid[ay][ax].visited = true
					add(stack, a)
				end

				if acell ~= "#" and top.cheated and not avisited then
					local dist = top.current_distance + grid[ay][ax].distance + 1
					-- saved is consistently off by 2. unsure why?
					local saved = total_distance - dist - 2

					if saved >= 100 then
						total_save_100 += 1
					end
					-- pph.info(string.format("Current Distance: %d", top.current_distance))
					-- pph.info(string.format("Adjacent Distance: %d", grid[ay][ax].distance))
					-- pph.info(string.format("Total Distance: %d. Saves %d", dist, saved))
				elseif acell ~= "#" and not avisited then
					local a = {
						x = ax, y = ay,
						cheated = false,
						current_distance = cdist + 1
					}
					grid[ay][ax].visited = true
					add(stack, a)
				end
			end
		end

		-- yield()
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 20 - Part 1"
	})

	current = { x = 1, y = 1 }
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
end

local function _draw()
	cls()

	for i = 1, min(16, height), 1 do
		for j = 1, min(32, width), 1 do
			local cell, color = grid[i][j].cell, grid[i][j].color
			print(cell, (j - 1) * 8, (i - 1) * 8, color)
		end
	end

	print("@", (current.x - 1) * 8, (current.y - 1) * 8, 12)

	print(string.format("\f7Total Distance: \fe%d\f7", total_distance), 128, 0)
	print(string.format("\f7Fast Paths: \fe%d\f7", total_save_100), 128, 8)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
