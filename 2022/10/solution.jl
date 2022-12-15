# Solution to AoC 2022 Day 10
# https://adventofcode.com/2022/day/10


# ======
# Part 1
# ======
function parse_instruction(instruction::AbstractString, cycles::Vector{Int})
    args = split(instruction)
    op = args[1]
    x = last(cycles)
    op == "noop" && return [cycles..., x]
    op == "addx" && return [cycles..., x, x + parse(Int, args[2])]
    return cycles
end

function execute(program::AbstractString)
    instructions = split(program, '\n'; keepempty=false)
    cycles = [1]
    for instruction in instructions
        cycles = parse_instruction(instruction, cycles)
    end
    return cycles
end

signal_strength(cycles::Vector{Int}) = [i * x for (i, x) in enumerate(cycles)]

function part1(program::AbstractString)
    cycles = execute(program)
    signal = signal_strength(cycles)
    return sum(signal[20:40:220])
end

# Validate on test input
test_input = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

@show part1(test_input)
@assert part1(test_input) == 13140

# Solve on puzzle input
puzzle_input = read("10.input", String)
@show part1(puzzle_input)

# ======
# Part 2
# ======
is_visible(sprite::Int, pixel::Int) = pixel in (sprite-1):(sprite+1)
draw_pixel(pixel::Int, sprite::Int) = is_visible(sprite, pixel) ? '#' : '.'

function render(cycles::Vector{Int})
    chars = [draw_pixel(mod(i-1, 40), x) for (i, x) in enumerate(cycles)]
    rows = join.(Iterators.partition(chars, 40))
    return join(rows[begin:end-1], '\n')
end

function part2(program::AbstractString)
    cycles = execute(program)
    screen = render(cycles)
    return screen
end

# Validate on test input
@show println(part2(test_input))
@assert part2(test_input) == """
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."""

# Solve on puzzle input
@show println(part2(puzzle_input))
