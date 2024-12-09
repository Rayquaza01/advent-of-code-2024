local pph = require("pph")
local amap = require("array.map")

-- 932137732557 - too low

local scroller = require("scroller")

local possible_rows

local offset
local autoscroll

local current
local sum
local data

local cor

local function try_symbols(n, max)
	local tbl = {}
	for i = 1, n, 1 do
		tbl[i] = 1
	end

	local stop = math.floor(max ^ n)

	local i = 0

	return function()
		if i == 0 then
			i += 1
			return tbl
		elseif i == stop then
			return nil
		else
			i += 1
			tbl[1] += 1
			for j = 1, #tbl, 1 do
				if tbl[j] > max then
					tbl[j] = 1
					if j + 1 <= #tbl then
						tbl[j + 1] += 1
					end
				else
					break
				end
			end

			return tbl
		end
	end

end

local function find_possible()
	for i = 1, #data, 1 do
		current = i

		pph.info(string.format("Testing Line %d / %d (%.2f%%)", i, #data, i / #data * 100))
		for symbols in try_symbols(#data[i] - 2, 3) do
			-- pph.info(pod(symbols))

			local try_sum = data[i][2]
			for j, symbol in ipairs(symbols) do
				if symbol == 1 then
					try_sum += data[i][3 + j - 1]
				elseif symbol == 2 then
					try_sum *= data[i][3 + j - 1]
				elseif symbol == 3 then
					try_sum = tonumber(tostr(try_sum) .. tostr(data[i][3 + j - 1]))
				end
			end

			-- pph.info(string.format("Trying Symbols %s. Target: %d, Actual %d", pod(symbols), data[i][1], try_sum))
			if try_sum == data[i][1] then
				-- pph.info("Matched!")
				possible_rows[i] = 1
				sum += data[i][1]
				break
			end

			-- yield()
		end

		yield()
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 7 - Part 2"
	})

	current = 1

	offset = 0
	autoscroll = true

	-- local input = fetch("day07/p1test.txt")
	local input = fetch("day07/p1data.txt")
	--- @cast input string

	try_sum = 0
	possible_rows = {}
	sum = 0
	data = {}

	for l in all(split(input, "\n", false)) do
		if l == "" then
			break
		end

		add(data, amap(split(l:gsub(":", ""), " ", false), function (item) return tonumber(item) end))
	end
end

local function _update()
	if cor == nil then
		cor = cocreate(find_possible)
	end

	if costatus(cor) ~= "dead" then
		coresume(cor)
	end

	if autoscroll then
		offset = mid(0, #data - 16, current - 16)
	end

	offset, autoscroll = scroller(offset, #data - 16, 1, autoscroll)

	offset = mid(offset, 0, max(#data - 16, #data))
end

local function _draw()
	cls()

	for i = 1, min(#data, 16), 1 do
		print(table.concat(data[i + offset], ", "), 0, (i - 1) * 8, possible_rows[i + offset] and 11 or 8)
	end

	print(string.format("\f7Sum: \fe%d\f7", sum), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
