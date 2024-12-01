function pretty_printh(s)
	s = s
		:gsub("%[fg=(#?%w+)]", function (c)
			if c:find("^%d+$") then
				return string.format("\27[38;5;%sm", c)
			end

			if c:find("^#[%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F]$") then
				return string.format(
					"\27[38;2;%d;%d;%dm",
					tonum("0x" .. c:sub(2, 3)),
					tonum("0x" .. c:sub(4, 5)),
					tonum("0x" .. c:sub(6, 7))
				)
			end
		end)
		:gsub("%[/fg]", "\27[39m")
		:gsub("%[bg=(#?%w+)]", function (c)
			if c:find("^%d+$") then
				return string.format("\27[48;5;%sm", c)
			end

			if c:find("^#[%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F]$") then
				return string.format(
					"\27[48;2;%d;%d;%dm",
					tonum("0x" .. c:sub(2, 3)),
					tonum("0x" .. c:sub(4, 5)),
					tonum("0x" .. c:sub(6, 7))
				)
			end
		end)
		:gsub("%[/bg]", "\27[49m")
		:gsub("%[u]", "\27[4m")
		:gsub("%[/u]", "\27[24m")
		:gsub("%[b]", "\27[1m")
		:gsub("%[/b]", "\27[22m")
		:gsub("%[i]", "\27[3m")
		:gsub("%[/i]", "\27[23m")

	printh(s .. "\27[0m")
end

function error(msg)
	pretty_printh("[fg=1][b][ERROR][/b][/fg]: " .. msg)
end

function warn(msg)
	pretty_printh("[fg=3][b][WARNING][/b][/fg]: " .. msg)
end

function info(msg)
	pretty_printh("[fg=4][b][INFO][/b][/fg]: " .. msg)
end
