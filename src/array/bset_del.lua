local bsearch = require("binarysearch")

--- @param tbl table
--- @param val any
--- @param less_than? function
local function bset_del(tbl, val, less_than)
	local pos = bsearch(tbl, val, less_than)
	if pos > 1 then
		deli(tbl, pos)
	end
end

return bset_del
