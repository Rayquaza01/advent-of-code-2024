local pph = require("pph")
local get_input = require("day02.input")

local amap = require("array.map")
local every = require("array.every")

local recordidx
local offset
local records
local safe
local safes
local diffs

local function less_than_four(n)
	return math.abs(n) < 4
end

local function positive(n)
	return n > 0
end

local function negative(n)
	return n < 0
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 2 - Part 1"
	})

	-- records = get_input("day02/p1test.txt")
	records = get_input("day02/p1data.txt")

	recordidx = 1
	offset = 1
	diffs = {}
	safes = {}

	safe = 0
end

local function _update()
	if recordidx <= #records then
		local ldiffs = {}
		local line = records[recordidx]

		for i = 1, #line - 1, 1 do
			local d = line[i + 1] - line[i]
			add(ldiffs, d)
		end

		if every(ldiffs, less_than_four) and (every(ldiffs, positive) or every(ldiffs, negative)) then
			safe += 1
			add(safes, true)
		else
			add(safes, false)
		end

		add(diffs, ldiffs)

		recordidx += 1
	end

	offset = mid(recordidx - 16, #records - 16, 0)
	if offset < 0 then offset = 0 end
end

local function _draw()
	cls()

	print(string.format("Processed records: \fe%d\f7", #diffs), 128, 0, 7)
	print(string.format("Safe: \fe%d\f7", safe), 128, 8, 7)

	for i = 1, min(16, #records), 1 do
		local lstring = amap(records[i + offset] or {}, function (item)
			return string.format("%02d", item)
		end)

		local issafe = "\fa?\f7"
		if safes[i + offset] ~= nil then
			if safes[i + offset] then
				issafe = "\f3\142\f7" -- O
			else
				issafe = "\f8\151\f7" -- X
			end
		end

		print(table.concat(lstring, " ") .. " " .. issafe, 0, (i - 1) * 8, 14)

		local dstring = amap(diffs[i + offset] or {}, function (item)
			if item > 0 then
				return "\f3" .. tostr(item) .. "\f7"
			elseif item < 0 then
				return "\f8" .. tostr(-item) .. "\f7"
			else
				return tostr(item)
			end
		end)

		print("  " .. table.concat(dstring, "  "), 0, (i - 1) * 8)
	end
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
