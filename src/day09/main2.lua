local pph = require("pph")

local amap = require("array.map")

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
		local col = 28
		if id == "." then
			col = 7
		end
		add(disk, { id, col, nums[i] })
	end

	yield()

	for i = #disk, 1, -1 do
		pph.info(string.format("Processing %d / %d (%.2f%%)", #disk - i, #disk, ((#disk - i) / #disk) * 100))

		for j = 1, i - 1, 1 do
			if disk[i][1] ~= "." and disk[j][1] == "." and disk[j][3] >= disk[i][3] then
				local block_len = disk[i][3]

				disk[j][3] -= block_len
				add(disk, disk[i], j)
				deli(disk, i + 1)
				add(disk, { ".", 7, block_len }, i)

				-- yield()
				break
			end
		end

		-- yield()
	end

	local disk_count = 0
	for i = 1, #disk, 1 do
		pph.info(string.format("Processing %d / %d (%.2f%%)", i, #disk, (i / #disk) * 100))
		for j = 1, disk[i][3], 1 do
			if disk[i][1] ~= "." then
				checksum += tonum(disk[i][1] * disk_count)
				disk[i][2] = 11
			end

			disk_count += 1
		end

		-- yield()
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

	offset = mid(0, max(#disk, #disk - 16), offset)
end

local function _draw()
	cls()

	for i = 1, min(#disk, 16), 1 do
		print(string.format("ID: %s, Length: %d", disk[i][1], disk[i][3]), 0, (i - 1) * 8)
	end

	print(string.format("\f7Checksum: \fe%d\f7", checksum), 128, 0)
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
