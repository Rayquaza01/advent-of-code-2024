local pph = require("pph")
local get_input = require("day02.input")

local amap = require("array.map")
local every = require("array.every")
local copy = require("array.copy")

local recordidx
local offset
local records
local safe
local safes
local diffs

local autoscroll

local function less_than_four(n)
	return n == "nil" or math.abs(n) < 4
end

local function positive(n)
	return n == "nil" or n > 0
end

local function negative(n)
	return n == "nil" or n < 0
end

local function _init()
	pph.pretty_printh("[fg=3]== Day 2 Part 2 Start ==[/fg]")

	window({
		width = 256, height = 128,
		title = "AoC Day 2 - Part 2"
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
		local line = records[recordidx]
		local lldiffs = {}

		local lok = false

		for i = 0, #line, 1 do
			-- pph.info("Skipping " .. i)
			local ldiffs = {}

			local lline = copy(line)
			lline[i] = "nil"

			for j = 1, #line - 1, 1 do
				if lline[j + 1] == "nil" then
					if j + 2 <= #line then
						local d = lline[j + 2] - lline[j]
						add(ldiffs, d)
					else
						add(ldiffs, "nil")
					end
				elseif lline[j] == "nil" then
					add(ldiffs, "nil")
				else
					local d = lline[j + 1] - lline[j]
					add(ldiffs, d)
				end
			end

			-- pph.info("Diffs")
			-- for k = 1, #ldiffs, 1 do
			-- 	printh(ldiffs[k])
			-- end

			-- pph.info(string.format("Less than four? %s", every(ldiffs, less_than_four) and "[fg=2]true[/fg]" or "[fg=1]false[/fg]"))
			-- pph.info(string.format("Same sign? %s", (every(ldiffs, positive) or every(ldiffs, negative)) and "[fg=2]true[/fg]" or "[fg=1]false[/fg]"))

			if every(ldiffs, less_than_four) and (every(ldiffs, positive) or every(ldiffs, negative)) then
				safe += 1
				add(safes, true)
				add(diffs, ldiffs)

				lok = true

				records[recordidx] = lline

				-- pph.info("Record " .. recordidx .. " OK")

				break
			end

			if not lok then
				add(lldiffs, ldiffs)
			end
		end

		if not lok then
			add(diffs, lldiffs[1])
			add(safes, false)

			-- pph.info("Record " .. recordidx .. " Failed")
		end

		recordidx += 1
	end

	if autoscroll then
		offset = mid(recordidx - 16, #records - 16, 0)
	end

	if btn(0) then
		offset = mid(offset - 1, #records - 16, 0)
		autoscroll = false
	elseif btn(1) then
		offset = mid(offset + 1, #records - 16, 0)
		autoscroll = false
	elseif btn(2) then
		offset = 0
		autoscroll = false
	elseif btn(3) then
		offset = #records - 16
		autoscroll = false
	end

	if btn(4) then
		autoscroll = true
	end

	offset = mid(offset, 0, #records - 1)
end

local function _draw()
	cls()

	print(string.format("Processed records: \fe%d\f7", #diffs), 128, 0, 7)
	print(string.format("Safe: \fe%d\f7", safe), 128, 8, 7)

	for i = 1, min(16, #records), 1 do
		local lstring = amap(records[i + offset] or {}, function (item)
			if item == "nil" then
				return "\f6--\f7"
			end
			return string.format("\fe%02d\f7", item)
		end)

		local issafe = "\fa?\f7"
		if safes[i + offset] ~= nil then
			if safes[i + offset] then
				issafe = "\f3\142\f7" -- O
			else
				issafe = "\f8\151\f7" -- X
			end
		end

		print(table.concat(lstring, " ") .. " " .. issafe, 0, (i - 1) * 8)

		local dstring = amap(diffs[i + offset] or {}, function (item)
			if item == "nil" then
				return "\f6-\f7"
			elseif item > 0 then
				return "\f3" .. tostr(item) .. "\f7"
			elseif item < 0 then
				return "\f8" .. tostr(-item) .. "\f7"
			elseif item == 0 then
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
