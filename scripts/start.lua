-- start aoc2024
rm("/ram/cart")
cp("/projects/advent-of-code-2024/src", "/ram/cart")
store("/ram/system/pwc.pod", "/projects/advent-of-code-2024/aoc2024.p64")
send_message(3, { event = "clear_project_workspaces" })
send_message(3, { event = "run_pwc", argv = env().argv, path = env().path })

notify("Running Advent of Code at " .. date())
