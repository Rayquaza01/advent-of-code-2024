local pph = require("pph")
local amap = require("array.map")

local cor

local count

local stones

local function process_stones()
	for i = 1, 25, 1 do
		count = i

		yield()

		local new_stones = {}

		for j = 1, #stones, 1 do
			local str = tostr(stones[j])
			local len = #str
			local mid = flr(len / 2)

			if stones[j] == 0 then
				add(new_stones, 1)
			elseif (len & 1) == 0 then
				add(new_stones, tonum(sub(str, 1, mid)))
				add(new_stones, tonum(sub(str, mid + 1, len)))
			else
				add(new_stones, stones[j] * 2024)
			end
			-- yield()
		end

		stones = new_stones
	end

	yield()
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 11 - Part 1"
	})

	count = 0

	-- local input = fetch("day11/p1test.txt")
	local input = fetch("day11/p1data.txt")
	--- @cast input string
	stones = amap(split(input, " ", false), function (item) return tonum(item) end)
end

local function _update()
	if cor == nil then
		cor = cocreate(process_stones)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end
end

local function _draw()
	cls()
	print(table.concat(stones, " "), 0, 0)
	print(string.format("Total Stones: \fe%d\f7", #stones))
	print(string.format("Current: \fe%d\f7", count))
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
