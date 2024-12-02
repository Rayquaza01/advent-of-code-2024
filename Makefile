SOURCEDIR := src
SOURCES   := $(shell find $(SOURCEDIR) -name '*.lua' -or -name '.info.pod' -or -name '*.txt')

build: aoc2024.p64

start:
	prt < scripts/start.lua

extract:
	prt cp -f /projects/advent-of-code-2024/aoc2024.p64 /projects/advent-of-code-2024/src

aoc2024.p64: $(SOURCES)
	prt cp -f /projects/advent-of-code-2024/src /projects/advent-of-code-2024/aoc2024.p64
