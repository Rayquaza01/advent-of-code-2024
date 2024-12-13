-- start aoc2024
cd(env().path)
local argv = env().argv or {}

rm("/ram/cart")
cp("/projects/advent-of-code-2024/src", "/ram/cart")
store("/ram/system/pwc.pod", "/projects/advent-of-code-2024/aoc2024.p64")
send_message(3, { event = "clear_project_workspaces" })

if argv[3] then
	argv[3] = fullpath(argv[3])
end

send_message(3, { event = "run_pwc", argv = argv, path = env().path })

notify("Running Advent of Code at " .. date("%Y-%m-%d %H:%M:%S"))
