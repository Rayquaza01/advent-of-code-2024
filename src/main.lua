--[[pod_format="raw",created="2024-03-15 13:58:36",modified="2024-12-01 04:19:09",revision=30]]
-- Advent of Code 2024
-- by Arnaught

include("require.lua")

function _init()
	window({
		width = 256, height = 128,
		title = "AoC 2024"
	})

	AOC_DAYS_CODE = {
		{ "day01/main1", "day01/main2" },
		-- { "day02/main1", "day02/main2" },
		-- { "day03/main1", "day03/main2" },
		-- { "day04/main1", "day04/main2" },
		-- { "day05/main1", "day05/main2" },
		-- { "day06/main1", "day06/main2" },
		-- { "day07/main1", "day07/main2" },
		-- { "day08/main1", "day08/main2" },
		-- { "day09/main1", "day09/main2" },
		-- { "day10/main1", "day10/main2" },
		-- { "day11/main1", "day11/main2" },
		-- { "day12/main1", "day12/main2" },
		-- { "day13/main1", "day13/main2" },
		-- { "day14/main1", "day14/main2" },
		-- { "day15/main1", "day15/main2" },
		-- { "day16/main1", "day16/main2" },
		-- { "day17/main1", "day17/main2" },
		-- { "day18/main1", "day18/main2" },
		-- { "day19/main1", "day19/main2" },
		-- { "day20/main1", "day20/main2" },
		-- { "day21/main1", "day21/main2" },
		-- { "day22/main1", "day22/main2" },
		-- { "day23/main1", "day23/main2" },
		-- { "day24/main1", "day24/main2" },
		-- { "day25/main1", "day25/main2" },
	}

	LOADED = nil

	SELECTION_TEXT = ""

	-- load_day(1, 1)
end

function _update()
	if LOADED ~= nil then
		return LOADED._update()
	end

	if peektext() then
		local t = readtext()

		SELECTION_TEXT = string.upper(SELECTION_TEXT .. t)
	end

	if #SELECTION_TEXT > 2 then
		SELECTION_TEXT = string.sub(SELECTION_TEXT, -2)
	end

	local sn = ord(SELECTION_TEXT, 1, 1)
	local sp = tonumber(SELECTION_TEXT[2])
	if sn ~= nil and sn > ord("A") - 1 and sn < ord("Z") then
		if sp == 1 or sp == 2 then
			printh(string.format("Loading Day %02d, Part %d", sn - 64, sp))
			load_day(sn - 64, sp)
		end
	end
end

function _draw()
	if LOADED ~= nil then
		return LOADED._draw()
	end

	cls()
	for i = 1, min(#AOC_DAYS_CODE, 25), 1 do
		print(
			string.format(
				"Day \f8%02d\f7 (%s%s\f7)",
				i, "\fr", chr(i + 64)
			),
			((i > 16) and 64 or 0),
			(i - 1 - (i > 16 and 16 or 0)) * 8
		)
	end
end

function load_day(d, p)
	LOADED = require(AOC_DAYS_CODE[d][p])
	LOADED._init()
end

-- uncomment the code you want to run

-- include("day01/main.lua")
-- include("day01/main2.lua")
