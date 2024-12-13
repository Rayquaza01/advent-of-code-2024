local pph = require("pph")

local cor

local function my_func()
end

local function _init()
	window({
		width = 256, height = 128,
		title = "AoC Day N - Part K"
	})
end

local function _update()
	if cor == nil then
		cor = cocreate(my_func)
	end

	if costatus(cor) ~= "dead" then
	-- if costatus(cor) ~= "dead" and btnp(5) then
		coresume(cor)
	end
end

local function _draw()
	cls()
end

return {
	_init   = _init,
	_update = _update,
	_draw   = _draw
}
