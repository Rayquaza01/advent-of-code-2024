local pph = require("pph")

local t_ul
local t_ur
local t_dl
local t_dr
local total

local cor

local function my_func()
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 14 - Part 1"
	})

	total = 0

	-- local input = fetch("day14/p1test.txt")
	local input = fetch("day14/p1data.txt")
	--- @cast input string

	-- local width = 11
	local width = 101
	-- local height = 7
	local height = 103

	t_ul = 0
	t_ur = 0
	t_dl = 0
	t_dr = 0

	for px, py, vx, vy in input:gmatch("p=(%d+),(%d+) v=(-?%d+),(-?%d+)") do
		local final_x = (tonum(px) + tonum(vx) * 100) % width
		local final_y = (tonum(py) + tonum(vy) * 100) % height

		printh(string.format("Final %d, %d", final_x, final_y))

		if final_x >= 0 and final_x < math.floor(width / 2) then
			-- if in left half

			-- if in top half
			if final_y >= 0 and final_y < math.floor(height / 2) then
				pph.info("Up Left")
				t_ul += 1
			elseif final_y >= math.ceil(height / 2) and final_y <= height then
				pph.info("Down Left")
				t_dl += 1
			end
		elseif final_x >= math.ceil(width / 2) and final_x <= width then
			-- if in right half

			-- if in top half
			if final_y >= 0 and final_y < math.floor(height / 2) then
				pph.info("Up Right")
				t_ur += 1
			elseif final_y >= math.ceil(height / 2) and final_y <= height then
				pph.info("Down Right")
				t_dr += 1
			end
		end
	end

	total = t_ul * t_ur * t_dl * t_dr
end

local function _update()
	if cor == nil then
		cor = cocreate(my_func)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end
end

local function _draw()
	cls()

	print(string.format("Total Up Left: \fe%d\f7", t_ul))
	print(string.format("Total Up Right: \fe%d\f7", t_ur))
	print(string.format("Total Down Left: \fe%d\f7", t_dl))
	print(string.format("Total Down Right: \fe%d\f7", t_dr))
	print(string.format("Total: \fe%d\f7", total))
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
