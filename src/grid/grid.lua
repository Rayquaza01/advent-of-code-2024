-- https://github.com/Rayquaza01/enchanted-gemstones/blob/master/enchanted-gemstones/3.p8.lua

dy = {-1, -1, 0, 1, 1, 1, 0, -1}
dx = {0, 1, 1, 1, 0, -1, -1, -1}

--- Enum of directions for find_adjacent
local Directions = {
	UP         = 1,
	UP_RIGHT   = 2,
	RIGHT      = 3,
	DOWN_RIGHT = 4,
	DOWN       = 5,
	DOWN_LEFT  = 6,
	LEFT       = 7,
	UP_LEFT    = 8,
	"UP",
	"UP_RIGHT",
	"RIGHT",
	"DOWN_RIGHT",
	"DOWN",
	"DOWN_LEFT",
	"LEFT",
	"UP_LEFT"
}

--- Check if a position is in bounds
--- @param x integer
--- @param y integer
--- @param width integer
--- @param height integer
--- @return boolean
local function is_in_bounds(x, y, width, height)
	return x >= 1 and x <= width and y >= 1 and y <= height
end


--- Find an adjacent tile
--- @param x integer
--- @param y integer
--- @param d integer
--- @return integer, integer
local function find_adjacent(x, y, d)
	return x + dx[d], y + dy[d]
end

local function encode_pos(x, y, width, height)
	return y - 1 + width * (x - 1 + height) - width * height
end

local function decode_pos(pos, width, height)
	pos += width * height
	local x = pos % width + 1
	pos = flr(pos / width)
	local y = pos % height + 1

	return x, y
end


return {
	is_in_bounds = is_in_bounds,
	find_adjacent = find_adjacent,
	encode_pos = encode_pos,
	decode_pos = decode_pos,
	Directions = Directions
}
