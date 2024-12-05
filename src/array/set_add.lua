--- https://github.com/Rayquaza01/enchanted-gemstones/blob/f47d430a438f28000076c1facb836fd4194bf083/enchanted-gemstones/3.p8.lua#L24
--- @param tbl table
--- @param v any
local function set_add(tbl, v)
	-- default pos at end of list
	local pos = #tbl + 1
	-- for each item in list
	for i = #tbl, 1, -1 do
		-- if item already in list, return early
		-- each item can only be in list once
		if (tbl[i] == v) then
			return
		end
		-- insert position is sorted
		if (v < tbl[i]) then
			pos = i
		end
		-- break if passed correct position
		if (v > tbl[i]) then
			break
		end
	end
	add(tbl, v, pos)
end

return set_add
