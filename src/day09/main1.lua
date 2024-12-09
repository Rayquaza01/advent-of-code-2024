local pph = require("pph")

local amap = require("array.map")

-- too low 5597065249

local autoscroll
local offset

local current

local nums
local free_spaces
local disk

local checksum

local cor

function generate_disk()
	for i = 1, #nums, 1 do
		local id = "."
		if (i & 1) == 1 then
			id = tostr(flr(i / 2))
		end

		-- pph.info(string.format("id: %s, count: %d", id, nums[i]))
		for j = 1, nums[i], 1 do
			local col = 28
			if id == "." then
				col = 7
				add(free_spaces, #disk + 1)
			end
			add(disk, { id, col })
			-- yield()
		end
	end

	yield()

	for i = #disk, 1, -1 do
		pph.info(string.format("Processing %d / %d (%.2f%%)", #disk - i, #disk, ((#disk - i) / #disk) * 100))

		current = i - 42
		if disk[i][1] ~= "." then
			local top = free_spaces[1]
			if top < i then
				deli(free_spaces, 1)
				disk[top], disk[i] = disk[i], disk[top]
			else
				pph.info("Finished sorting")
				break
			end

			-- yield()
		end
	end

	for i = 1, #disk, 1 do
		pph.info(string.format("Processing %d / %d (%.2f%%)", i, #disk, (i / #disk) * 100))
		if disk[i][1] == "." then
			break
		end

		-- yield()
		checksum += tonum(disk[i][1]) * (i - 1)
		disk[i][2] = 11
	end
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 9 - Part 1"
	})

	offset = 0
	autoscroll = true

	-- local input = fetch("day09/p1test.txt")
	local input = fetch("day09/p1data.txt")
	--- @cast input string

	checksum = 0

	disk = {}
	free_spaces = {}

	nums = amap(split(input, "", false), function (item) return tonum(item) end)
end

local function _update()
	if cor == nil then
		cor = cocreate(generate_disk)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end

	-- if autoscroll then
	-- 	offset = mid(0, #disk - 42, current)
	-- end

	offset = mid(0, max(#disk, #disk - 42), offset)
end

local function _draw()
	cls()

	for i = 1, min(#disk, 42), 1 do
		print(disk[i + offset][1], (i - 1) * 6, 0, disk[i + offset][2])
	end

	print(string.format("\f7Checksum: \fe%d\f7", checksum), 0, 8)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
