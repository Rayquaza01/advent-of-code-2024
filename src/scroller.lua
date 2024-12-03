--- Adds scroll controls
--- Returns whether autoscroll is enabled or disabled
--- @param offset integer
--- @param max integer
--- @param speed integer
--- @param autoscroll boolean
--- @return integer, boolean
local function scroller(offset, max, speed, autoscroll)
	if btn(0) then
		offset = mid(offset - speed, max, 0)
		return offset, false
	elseif btn(1) then
		offset = mid(offset + speed, max, 0)
		return offset, false
	elseif btn(2) then
		offset = 0
		return offset, false
	elseif btn(3) then
		offset = max
		return offset, false
	elseif btn(4) then
		return offset, true
	end

	return offset, autoscroll
end

return scroller
