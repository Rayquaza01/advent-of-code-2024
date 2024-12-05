local amap = require("array.map")
local set_add = require("array.set_add")

--- @param file string
--- @return table, table
local function get_input(file)
	if fstat(file) then
		local input = fetch(file)
		--- @cast input string

		local r = {}
		local p = {}

		local s, e = input:find("\n\n")
		if s and e then
			local rstr = sub(input, 1, s - 1)
			local pstr = sub(input, e + 1, #input)

			for rule in all(split(rstr, "\n", false)) do
				if rule ~= "" then
					local first, second = unpack(split(rule, "|", true))
					if r[first] == nil then
						r[first] = {}
					end

					set_add(r[first], second)
				end
			end

			for page in all(split(pstr, "\n", false)) do
				if page ~= "" then
					add(p, amap(split(page, ",", true), function (item) return {item, 7} end))
				end
			end

			return r, p
		end
	end

	notify("No input!")
	return {}, {}
end

return get_input
