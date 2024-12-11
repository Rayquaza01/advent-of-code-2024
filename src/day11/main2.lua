local pph = require("pph")
local amap = require("array.map")

local cor

local current_count
local stones

local memoizer

local total_stones

local function process_individual_stone(stone)
	local s, count = table.unpack(stone)
	--- @cast s integer
	--- @cast count integer

	local initial_stone = s

	local total = 1

	-- pph.info(string.format("Stone: %d, Count: %d", s, count))

	if memoizer[initial_stone] == nil then
		memoizer[initial_stone] = {}
	end

	if memoizer[initial_stone][count] ~= nil then
		-- pph.info("Using memoized value")
		return memoizer[initial_stone][count]
	end

	for i = count, 1, -1 do
		-- current_count = i

		local str = tostr(s)
		local len = #str
		local mid = flr(len / 2)

		if s == 0 then
			-- pph.info("Was zero, now 1")
			s = 1
		elseif (len & 1) == 0 then
			-- pph.info("Split into two stones")
			s = tonum(sub(str, 1, mid))
			total += process_individual_stone({ tonum(sub(str, mid + 1, len)), i - 1 })
		else
			-- pph.info("Multiplied by 2024")
			s *= 2024
		end
	end

	-- pph.info(string.format("Memoizing %d, %d", initial_stone, count))
	memoizer[initial_stone][count] = total
	return total
end

local function process_stones()
	for i = 1, #stones, 1 do
		current_count = i
		total_stones += process_individual_stone(stones[i])
	end

	-- yield()
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 11 - Part 2"
	})

	memoizer = {}

	current_count = 0
	total_stones = 0

	-- local input = fetch("day11/p1test.txt")
	local input = fetch("day11/p1data.txt")
	--- @cast input string
	stones = amap(split(input, " ", false), function (item) return { tonum(item), 75 } end)
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
	-- print(table.concat(stones, " "), 0, 0)
	print(string.format("Total Stones: \fe%d\f7", total_stones))
	print(string.format("Current: \fe%d\f7", current_count))
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
