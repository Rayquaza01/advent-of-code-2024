local pph = require("pph")

local matrices

local total

local cor

local function str_round(val)
	return tonum(tostr(val))
end

local function is_integer(val)
	return math.floor(val) == math.ceil(val)
end

-- https://www.tutorialspoint.com/cplusplus-program-to-implement-gauss-jordan-elimination
local function gje_tp(A, m, n)
	for j = 1, n - 1, 1 do
		for i = 1, n - 1, 1 do
			if i ~= j then
				local b = A[i][j] / A[j][j]
				for k = 1, n, 1 do
					A[i][k] = A[i][k] - b * A[j][k]
				end
			end
		end
	end

	local vals = {}
	for i = 1, m, 1 do
		add(vals, A[i][n] / A[i][i])
	end

	return vals
end

local function solve_matrices()
	for i, m in ipairs(matrices) do
		local a, b = table.unpack(gje_tp(m, 2, 3))
		a = str_round(a)
		b = str_round(b)

		if is_integer(a) and is_integer(b) then
			pph.info(string.format("Solution for %d: a=%f, b=%f", i, a, b))
			total += 3 * a + b
		else
			pph.info("No solution")
		end
	end
end

local function _init(file)
	window({
		width = 256, height = 128,
		title = "AoC Day 13 - Part 1"
	})

	total = 0

	if not file then
		-- file = "day13/p1test.txt"
		file = "day13/p1data.txt"
	end

	local input = fetch(file)
	--- @cast input string

	matrices = {}

	local err = 10000000000000
	for ax, ay, bx, by, px, py in input:gmatch("Button A: X%+(%d+), Y%+(%d+)\nButton B: X%+(%d+), Y%+(%d+)\nPrize: X=(%d+), Y=(%d+)") do
		local m = {{ax, bx, px + err}, {ay, by, py + err}}
		add(matrices, m)
	end
end

local function _update()
	if cor == nil then
		cor = cocreate(solve_matrices)
	end

	if costatus(cor) ~= "dead" then
		-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end
end

local function _draw()
	cls()

	print(string.format("\f7Total: \fe%d\f7", total))
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
