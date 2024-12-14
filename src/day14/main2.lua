local pph = require("pph")

local robots
local seconds

local width
local height

-- local cor

-- local function my_func()
-- end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 14 - Part 2"
	})

	robots = {}
	seconds = 0

	-- local input = fetch("day14/p1test.txt")
	local input = fetch("day14/p1data.txt")
	--- @cast input string

	-- width = 11
	width = 101
	-- height = 7
	height = 103

	for px, py, vx, vy in input:gmatch("p=(%d+),(%d+) v=(-?%d+),(-?%d+)") do
		add(robots, {
			initial_x = tonum(px),
			initial_y = tonum(py),
			x = tonum(px),
			y = tonum(py),
			vx = tonum(vx),
			vy = tonum(vy)
		})
	end
end

local function _update()
	-- if cor == nil then
	-- 	cor = cocreate(my_func)
	-- end

	-- if costatus(cor) ~= "dead" then
	-- -- if costatus(cor) ~= "dead" and btnp(5) then
	-- 	coresume(cor)
	-- end

	if btn(1) or btnp(2) then
		seconds += 1
	end

	if btn(0) or btnp(3) then
		seconds -= 1
	end

	if btnp(4) then
		seconds += 101
	end

	if btnp(5) then
		seconds -= 101
	end

	for r in all(robots) do
		r.x = (r.initial_x + r.vx * seconds) % width
		r.y = (r.initial_y + r.vy * seconds) % height
	end
end

local function _draw()
	cls()

	for r in all(robots) do
		pset(r.x, r.y, 12)
	end

	print(string.format("Seconds: \fe%d\f7", seconds), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
