local function get_input(file)
	local reports = {}

	if fstat(file) then
		local input = fetch(file)
		if type(input) == "string" then
			local lines = split(input, "\n", false)
			for l in all(lines) do
				if l ~= "" then
					add(reports, split(l, " ", true))
				end
			end

			return reports
		else
			stop("Invalid input")
		end
	else
		stop("Input file not found")
	end
end

return get_input
