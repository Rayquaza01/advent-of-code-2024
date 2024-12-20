local REGISTER_A = 0
local REGISTER_B = 0
local REGISTER_C = 0

local OUTPUT = {}

--- @param a integer | string
--- @param b integer | string
--- @param c integer | string
local function INITIALIZE(a, b, c)
	OUTPUT = {}
	REGISTER_A = tonum(a)
	REGISTER_B = tonum(b)
	REGISTER_C = tonum(c)
end

--- Looks up the value of a combo operand
--- Combo operands 0 through 3 represent literal values 0 through 3.
--- Combo operand 4 represents the value of register A.
--- Combo operand 5 represents the value of register B.
--- Combo operand 6 represents the value of register C.
--- Combo operand 7 is reserved and will not appear in valid programs.
--- @param combo integer
--- @return integer
function LOOKUP_COMBO_OPERAND(combo)
	if combo >= 0 and combo <= 3 then
		return combo
	elseif combo == 4 then
		return REGISTER_A
	elseif combo == 5 then
		return REGISTER_B
	elseif combo == 6 then
		return REGISTER_C
	else
		printh("Invalid operand")
		return 7
	end
end

--- The adv instruction (opcode 0) performs division.
--- The numerator is the value in the A register.
--- The denominator is found by raising 2 to the power of the instruction's combo operand.
--- (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.)
--- The result of the division operation is truncated to an integer and then written to the A register.
--- @param combo integer
local function ADV(combo)
	-- printh("ADV")
	REGISTER_A = flr(REGISTER_A / (2 ^ LOOKUP_COMBO_OPERAND(combo)))
end

--- The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal
--- operand, then stores the result in register B.
--- @param literal integer
local function BXL(literal)
	-- printh("BXL")
	REGISTER_B = REGISTER_B ~ literal
end

--- The bst instruction (opcode 2) calculates the value of its combo operand modulo 8
--- (thereby keeping only its lowest 3 bits), then writes that value to the B register.
--- @param combo integer
local function BST(combo)
	-- printh("BST")
	REGISTER_B = LOOKUP_COMBO_OPERAND(combo) % 8
end

--- The jnz instruction (opcode 3) does nothing if the A register is 0.
--- However, if the A register is not zero, it jumps by setting the instruction pointer
--- to the value of its literal operand; if this instruction jumps, the instruction pointer
--- is not increased by 2 after this instruction.
--- @param literal integer
local function JNZ(literal)
	-- printh("JNZ")
	if REGISTER_A ~= 0 then
		return literal
	else
		return nil
	end
end

--- The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C,
--- then stores the result in register B. (For legacy reasons, this instruction reads an
--- operand but ignores it.)
--- @param _? integer
local function BXC(_)
	-- printh("BXC")
	REGISTER_B = REGISTER_B ~ REGISTER_C
end

--- The out instruction (opcode 5) calculates the value of its combo operand modulo 8,
--- then outputs that value. (If a program outputs multiple values,
--- they are separated by commas.)
--- @param combo integer
local function OUT(combo)
	-- printh("OUT")
	-- printh(LOOKUP_COMBO_OPERAND(combo) % 8)
	add(OUTPUT, LOOKUP_COMBO_OPERAND(combo) % 8)
end

--- The bdv instruction (opcode 6) works exactly like the adv instruction except that the result
--- is stored in the B register. (The numerator is still read from the A register.)
--- @param combo integer
local function BDV(combo)
	-- printh("BDV")
	REGISTER_B = flr(REGISTER_A / (2 ^ LOOKUP_COMBO_OPERAND(combo)))
end

--- The cdv instruction (opcode 7) works exactly like the adv instruction except that the result
--- is stored in the C register. (The numerator is still read from the A register.)
--- @param combo integer
local function CDV(combo)
	-- printh("CDV")
	REGISTER_C = flr(REGISTER_A / (2 ^ LOOKUP_COMBO_OPERAND(combo)))
end

--- @return string
local function GET_OUTPUT()
	return table.concat(OUTPUT, ",")
end

local function GET_RAW_OUTPUT()
	return OUTPUT
end

return {
	[0] = ADV,
	BXL,
	BST,
	JNZ,
	BXC,
	OUT,
	BDV,
	CDV,
	GET_OUTPUT = GET_OUTPUT,
	GET_RAW_OUTPUT = GET_RAW_OUTPUT,
	INITIALIZE = INITIALIZE
}
