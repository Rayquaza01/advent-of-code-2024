local function is_set(value, mask)
	return (value & mask) == mask
end

local function set(value, mask)
	return value | mask
end

return {
	is_set = is_set,
	set = set,
}
