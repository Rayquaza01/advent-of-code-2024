--- Search a table for a given value. Returns -1 if not in table
--- @param tbl table
--- @param val any
--- @return integer
local function search(tbl, val)
	for i = 1, #tbl, 1 do
		if tbl[i] == val then
			return i
		end
	end

	return -1
end

return search
