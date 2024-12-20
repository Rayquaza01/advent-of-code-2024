local pph = require("pph")

local amap = require("array.map")

local interpreter = require("day17.interpreter")

local program

local cor

local function run_program()
	local INS_PTR = 0

	while INS_PTR < #program do
		pph.info(string.format("Instruction Pointer: %d, Program Length: %d", INS_PTR, #program))

		local op_code = program[INS_PTR + 1]
		local operand = program[INS_PTR + 2]

		pph.info(string.format("Op Code: %d, Operand: %d", op_code, operand))

		local ret = interpreter[op_code](operand)
		if ret ~= nil then
			INS_PTR = ret
		else
			INS_PTR += 2
		end

		yield()
	end

	set_clipboard(interpreter.GET_OUTPUT())

	pph.info("HALT")
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 17 - Part 1"
	})

	local input = fetch("day17/p1data.txt")
	--- @cast input string

	for a, b, c, prog in input:gmatch("Register A: (%d+)\nRegister B: (%d+)\nRegister C: (%d+)\n\nProgram: ([%d,]+)") do
		interpreter.INITIALIZE(a, b, c)
		program = amap(split(prog, ",", false), function (i) return tonum(i) end)

		pph.info(string.format("A: %s, B: %s, C: %s", a, b, c))
		pph.info(string.format("Program: %s", pod(program)))
	end
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

	print(interpreter.GET_OUTPUT())
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
