--- Adds 2d scroll controls
--- Returns whether autoscroll is enabled or disabled
--- @param offsetx integer
--- @param offsety integer
--- @param width integer
--- @param height integer
--- @param speed integer
--- @param autoscroll boolean
--- @return integer, integer, boolean
local function scroller(offsetx, offsety, width, height, speed, autoscroll)
	if btn(0) then
		offsetx = mid(offsetx - speed, width, 0)
		return offsetx, offsety, false
	elseif btn(1) then
		offsetx = mid(offsetx + speed, width, 0)
		return offsetx, offsety, false
	elseif btn(2) then
		offsety = mid(offsety - speed, height, 0)
		return offsetx, offsety, false
	elseif btn(3) then
		offsety = mid(offsety + speed, height, 0)
		return offsetx, offsety, false
	elseif btn(4) then
		return offsetx, offsety, true
	end

	return offsetx, offsety, autoscroll
end

return scroller
