local bsearch = require("binarysearch")

--- @param tbl table
--- @param val any
--- @param less_than? function
local function bset_add(tbl, val, less_than)
	local pos = bsearch(tbl, val, less_than)
	if pos < 0 then
		add(tbl, val, -pos)
	end
end

return bset_add
