include("pph.lua")

function _init()
    info("Day 1 Part 2 Start")

	offset = 0

    window({
        width = 256, height = 128,
        title = "AoC Day 01 - Part 2"
    })

    list1 = {}
    list2 = {}

    -- local input = fetch("day01/p1test.txt")
    local input = fetch("day01/p1data.txt")
    info("Loaded input")
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

	similarity = 0

	freq = {}
	for i in all(list2) do
		if freq[i] == nil then
			freq[i] = 0
		end

		freq[i] += 1
	end

	for i in all(list1) do
		if freq[i] ~= nil then
			similarity += freq[i] * i
		end
	end
end

function _update()
end

function _draw()
    cls()

	i = 0
	for k, v in pairs(freq) do
		i += 1
		print(string.format("\f8%d\t\f3%d\f7", k, v), 0, (i - 1) * 8, 9)
	end

	print(string.format("Similarity: \f9%d\f7", similarity), 64, 0)
end
