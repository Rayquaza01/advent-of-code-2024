local pph = require("pph")
local sort = require("mergesort")

local offset
local list1
local list2
local diffs
local sum

local function lt(a, b)
    return a < b
end

local function _init(file)
    pph.info("Day 1 Part 1 Start ")

	offset = 0

    window({
        width = 256, height = 128,
        title = "AoC Day 01 - Part 1"
    })

    list1 = {}
    list2 = {}

	if not file then
		-- file = "day01/p1test.txt"
		file = "day01/p1data.txt"
	end

    local input = fetch(file)
    pph.info("Loaded input")
    if type(input) ~= "string" then
        error("Invalid input")
    end

    local input_lines = split(input, "\n", false)
    for l in all(input_lines) do
        if l == "" then
            break
        end

        local n1, n2 = unpack(split(l, "\t", false))
        add(list1, tonumber(n1))
        add(list2, tonumber(n2))
    end

    sort(list1, lt)
    sort(list2, lt)

	diffs = {}
	sum = 0

	for i = 1, #list1, 1 do
		local d = math.abs(list1[i] - list2[i])
		add(diffs, d)
		sum += d
	end
end

function _update()
	offset = mid(offset + 16, #list1 - 16, 0)
end

function _draw()
    cls()

    for i = 1, #list1, 1 do
        print(list1[offset + i], 0, (i - 1) * 8, 8)
    end

    for i = 1, #list2, 1 do
        print(list2[offset + i], 32, (i - 1) * 8, 3)
    end

	for i = 1, #diffs, 1 do
		print(diffs[offset + i], 64, (i - 1) * 8, 9)
	end

	print(string.format("\f7Sum: \f9%d\f7", sum), 96, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw,
}
