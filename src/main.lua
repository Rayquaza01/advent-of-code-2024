--[[pod_format="raw",created="2024-03-15 13:58:36",modified="2024-12-02 00:06:56",revision=39]]
-- Advent of Code 2024
-- by Arnaught

include("require.lua")

local SNOWFLAKES
local SNOWFLAKE_SPAWN_RATE
local AOC_DAYS_CODE
local LOADED
local SELECTION_TEXT

function _init()
	--- @type userdata[]
	SNOWFLAKES = {}
	SNOWFLAKE_SPAWN_RATE = 0.25

	window({
		width = 256, height = 128,
		title = "AoC 2024"
	})

	AOC_DAYS_CODE = {
		{ "day01/main1", "day01/main2" },
		{ "day02/main1", "day02/main2" },
		{ "day03/main1", "day03/main2" },
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

	if rnd() <= SNOWFLAKE_SPAWN_RATE then
		-- x, y, speed, sway speed
		add(SNOWFLAKES, vec(
			flr(rnd(288) - 32), -- x
			0,             -- y
			rnd(1.5) + .5, -- speed
			rnd(.5) + 1    -- sway speed
		))
	end

	for s in all(SNOWFLAKES) do
		local x, y, speed, sway = s:get(0, 4)

		--- @cast s userdata
		s:set(0, x + math.cos(t() * sway / 5) / 2, y + speed)

		-- delete snowflakes that fall offscreen
		if y + speed > 128 then
			del(SNOWFLAKES, s)
		end
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
	spr(1, 128, 0)
	print("Advent of Code 2024", 145, 4, 14)

	for s in all(SNOWFLAKES) do
		--- @cast s userdata
		local x, y = s:get(0, 2)

		pset(x, y, 7)
	end

	for i = 1, 25, 1 do
		if AOC_DAYS_CODE[i] ~= nil then
			print(
				string.format(
					"Day %s%02d\f7 (\fr%s\f7)",
					#AOC_DAYS_CODE[i] == 2 and "\fa" or "\f9",
					i, chr(i + 64)
				),
				((i > 16) and 64 or 0),
				(i - 1 - (i > 16 and 16 or 0)) * 8
			)
		else
			print(
				string.format(
					"\f6Day \f8%02d\f6 (\f8!\f6)\f7",
					i, chr(i + 64)
				),
				((i > 16) and 64 or 0),
				(i - 1 - (i > 16 and 16 or 0)) * 8
			)
		end
	end

	print("Type a \feday\f7\nand \fepart\f7 to\nstart.\n(e.g. \feA1\f7)")
end

function load_day(d, p)
	if AOC_DAYS_CODE[d] ~= nil and AOC_DAYS_CODE[d][p] ~= nil then
		LOADED = require(AOC_DAYS_CODE[d][p])
		LOADED._init()
	else
		notify(string.format("Script for day %s part %d not found!", d, p))
	end
end
