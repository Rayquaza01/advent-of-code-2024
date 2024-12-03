local pph = require("pph")
local sum = require("array.sum")

local scroller = require("scroller")

local input
local matches

local total

local offset
local autoscroll

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 3 - Part 1"
	})

	offset = 0
	autoscroll = true

	-- input = fetch("day03/p1test.txt")
	input = fetch("day03/p1data.txt")
	--- @cast input string

	matches = {}
	for m1, m2 in input:gmatch("mul%((%d+),(%d+)%)") do
		add(matches, m1 * m2)
	end

	total = sum(matches)
end

local function _update()
	if autoscroll then
		offset = mid(offset + 1, #matches - 16, 0)
	end

	offset, autoscroll = scroller(offset, #matches - 16, 1, autoscroll)

	offset = mid(offset, 0, #matches - 1)
end

local function _draw()
	cls()

	for i = 1, 16, 1 do
		print(matches[i + offset])
	end
	print(string.format("Total: \fe%d\f7", total), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
