local pph = require("pph")

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day 2 - Part 2"
	})
end

local function _update()
end

local function _draw()
	cls()
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
