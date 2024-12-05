local pph = require("pph")
local get_input = require("day05/input")

local copy = require("array.copy")
local every = require("array.every")

local amap = require("array.map")

local scroller = require("scroller")

local sort = require("mergesort")
local bsearch = require("binarysearch")

local offset

local co

local rules
local pages

local sum

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 5 - Part 1"
	})

	current_page = 1
	current_item = 1

	offset = 0

	co = nil

	sum = 0

	-- rules, pages = get_input("day05/p1test.txt")
	rules, pages = get_input("day05/p1data.txt")
end

local function _update()
	if co == nil then
		co = cocreate(handle_rules)
	end

	if costatus(co) ~= "dead" then
		coresume(co)
	end
end

local function _draw()
	cls()

	for i = 1, #pages, 1 do
		for j = 1, #pages[i], 1 do
			print(pages[i][j][1], (j - 1) * 15, (i - 1) * 8, pages[i][j][2])
		end
	end

	local i = 1
	for k, v in pairs(rules) do
		print(string.format("\fe%s\f7 < %s", k, table.concat(v, ",")), 128, (i - 1) * 8)
		i = i + 1
	end

	-- print(string.format("\fa%02d\f7", pages[current_page][current_item][1]), (current_item - 1) * 15, (current_page - 1) * 8)

	rectfill(120, 112, 256, 128, 0)
	print(string.format("\f7Sum: \fe%d\f7", sum), 128, 120)
end

local function apply_rule(a, b)
	local arules = rules[a[1]] or {}
	local brules = rules[b[1]] or {}

	-- if b is in a rules then a < b (return true)
	-- if a is in b rules the a > b (return false)
	return bsearch(arules, b[1]) > 0 or not (bsearch(brules, a[1]) > 0)
end

function handle_rules()
	for i = 1, #pages, 1 do
		current_page = i

		local cur = copy(pages[i])
		sort(cur, apply_rule)

		if every(pages[i], function (item, idx) return item == cur[idx] end) then
			local middle = math.ceil(#pages[i] / 2)
			sum += pages[i][middle][1]
			pages[i][middle][2] = 14
		end

		yield()
	end
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
