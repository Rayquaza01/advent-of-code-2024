local pph = require("pph")
local sum = require("array.sum")
local amap = require("array.map")

local scroller = require("scroller")

local sort = require("mergesort")

local input
local matches
local autoscroll

local total

local offset

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 3 - Part 2"
	})

	offset = 0
	autoscroll = true

	-- input = fetch("day03/p2test.txt")
	input = fetch("day03/p1data.txt")
	--- @cast input string

	matches = {}

	local start = 1
	while start < #input do
		local s, e = input:find("do%(%)", start)
		if not s then
			break
		end

		start = e and e or #input
		add(matches, { s, true })
	end

	start = 1
	while start < #input do
		local s, e = input:find("don't%(%)", start)
		if not s then
			break
		end

		start = e and e or #input
		add(matches, { s, false })
	end

	start = 1
	while start < #input do
		local s, e, m1, m2 = input:find("mul%((%d+),(%d+)%)", start)
		if not s then
			break
		end

		-- pph.info(string.format("%d, %d", m1, m2))

		start = e and e or #input
		add(matches, { s, m1 * m2 })
	end

	sort(matches, function (a, b) return a[1] < b[1] end)

	local enabled = true
	total = sum(amap(matches, function (m)
		if type(m[2]) == "boolean" then
			enabled = m[2]
			return 0
		end
		return enabled and m[2] or 0
	end))
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

	for i = 1, min(16, #matches), 1 do
		local m = matches[i + offset]
		if type(m[2]) == "boolean" then
			print(m[2] and "\f3on\f7" or "\f8off\f7")
		else
			print(m[2])
		end
	end

	print(string.format("Total: \fe%d\f7", total), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
