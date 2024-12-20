local pph = require("pph")

local amap = require("array.map")
local every = require("array.every")

local interpreter = require("day17.interpreter")

local initial_a
local current_a
local max_a

local program
local iprog

local cor

local function math_prog(A)
	local digits = flr(math.log(A, 8) + 1)

	local B = 0
	local C = 0

	local sum = 0

	for n = 0, digits, 1 do
		local nA = flr(A / (8 ^ n))
		B = nA % 8
		B = B ~ 5
		C = flr(nA / (2 ^ B))
		B = B ~ C
		B = B ~ 6

		sum += flr((B % 8) * (10 ^ (digits - n - 1)))

		n += 1
	end

	return sum
end

function reverse_prog(output)
	local digits = #output

	for n = digits, 0, -1 do
		local nA = flr(A / (8 ^ n))
		local B = n * 8 -- reverse the mod 8 from OUT
		B = B ~ 6 -- XOR is its own inverse
	end
end

function find_digit(A, n)
	local digits = flr(math.log(A, 8) + 1)
	if n >= digits then
		return 0
	end

	local nA = flr(A / (8 ^ n))
	B = nA % 8
	B = B ~ 5
	C = flr(nA / (2 ^ B))
	B = B ~ C
	B = B ~ 6

	return B % 8
end

local function run_program()
	initial_a = flr(10 ^ ((#program - 1) * math.log(8, 10)))
	-- max_a = flr(10 ^ ((#program) * math.log(8, 10)))
	-- current_a = initial_a


	current_a = 105553116266496
	max_a     = 140737488355328

	current_a += 100000000000 + 45000000000
	-- 900000000000/2 = 450000000000

	-- current_a = 1
	-- current_a = 117430
	-- max_a = math.maxinteger
	-- max_a = 200000

	-- local delta = 1
	-- local counter = 1

	-- local last_digit = 0

	while current_a < max_a do
		if current_a % 10000 == 0 then
			yield()
		end

		-- local n_digit = math_prog(current_a) % 8
		-- if n_digit ~= last_digit then
		-- 	last_digit = n_digit
			printh(string.format("%d,%d", current_a, n_digit))
		-- end
		--

		local ok = true

		for i = 0, #program, 1 do
			if find_digit(current_a, i) ~= program[i + 1] then
				ok = false
				break
			end
		end

		if ok then
			break
		end

		-- if math_prog(current_a) == iprog then
		-- 	break
		-- end

		-- yield()

		-- interpreter.INITIALIZE(current_a, 0, 0)

		-- local INS_PTR = 0

		-- while INS_PTR < #program do
		-- 	-- pph.info(string.format("Instruction Pointer: %d, Program Length: %d", INS_PTR, #program))

		-- 	local op_code = program[INS_PTR + 1]
		-- 	local operand = program[INS_PTR + 2]

		-- 	-- pph.info(string.format("Op Code: %d, Operand: %d", op_code, operand))

		-- 	local ret = interpreter[op_code](operand)
		-- 	if ret ~= nil then
		-- 		INS_PTR = ret
		-- 	else
		-- 		INS_PTR += 2
		-- 	end

		-- 	-- yield()
		-- end

		-- yield()

		-- local out = interpreter.GET_RAW_OUTPUT()
		-- local n_digit = out[1]
		-- if n_digit ~= last_digit then
		-- 	last_digit = n_digit
		-- 	printh(string.format("%d,%d", current_a, n_digit))
		-- end

		-- if every(program, function (i, idx) return i == out[idx] end) then
		-- 	pph.info("Everything matches!")
		-- 	break
		-- end

		current_a += 1

		-- current_a += delta
		-- counter += 1

		-- if counter >= 6 and counter % 6 == 0 then
		-- 	delta *= 2
		-- end

		-- if counter >= 6 and counter % 6 == 1 then
		-- 	delta *= 4
		-- end
	end


	pph.info("HALT")
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 17 - Part 2"
	})

	initial_a = 1
	current_a = 1
	max_a = 1

	-- local input = fetch("day17/p2test.txt")
	local input = fetch("day17/p1data.txt")
	--- @cast input string

	for a, b, c, prog in input:gmatch("Register A: (%d+)\nRegister B: (%d+)\nRegister C: (%d+)\n\nProgram: ([%d,]+)") do
		interpreter.INITIALIZE(a, b, c)
		program = amap(split(prog, ",", false), function (i) return tonum(i) end)
		iprog = tonum(table.concat(program, ""))

		pph.info(string.format("A: %s, B: %s, C: %s", a, b, c))
		pph.info(string.format("Program: %s", pod(program)))
		pph.info(string.format("Program as integer: %s", iprog))
	end

	-- local csv = {}
	-- for i = 1, 100, 1 do
	-- 	local row = {}
	-- 	add(row, i)
	-- 	for j = 0, 7, 1 do
	-- 		add(row, find_digit(i, j))
	-- 	end

	-- 	add(csv, table.concat(row, ","))
	-- end
	-- store("/projects/advent-of-code-2024/src/day17/data.csv", table.concat(csv, "\n"))
end

local function _update()
	if cor == nil then
		cor = cocreate(run_program)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end
end

local function _draw()
	cls()

	-- print(interpreter.GET_OUTPUT(), 0, 0)
	print(string.format("Current: \fc%016d\f7", math_prog(current_a)), 0, 0)
	print(string.format("Program: \fc%016d\f7", iprog), 0, 8)
	print(string.format("Current A: \fe%d\f7", current_a), 0, 16)
	print(string.format("Max A:     \fe%d\f7", max_a), 0, 24)
	-- print(string.format("Progress: %.2f%%", ((current_a - initial_a) / (max_a - initial_a)) * 100), 0, 24)

-- 	for i = 0, #program, 1 do
-- 		print(find_digit(current_a, i))
-- 	end
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
