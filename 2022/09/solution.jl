# Solution to AoC 2022 Day 9
# https://adventofcode.com/2022/day/9


# ======
# Part 1
# ======
const up = [0, 1]
const down = [0, -1]
const left = [-1, 0]
const right = [1, 0]

struct Knot
    offset::Vector{Int}
end
Knot() = Knot([0, 0])
touching(k1::Knot, k2::Knot) = all(abs.(k1.offset - k2.offset) .<= [1, 1])
direction(from::Knot, to::Knot) = sign.(to.offset - from.offset)
move(knot::Knot, direction::Vector{Int}) = Knot(knot.offset + direction)
move(knot::Knot, towards::Knot) = touching(knot, towards) ? knot : move(knot, direction(knot, towards))

struct Rope
    knots::Vector{Knot}
end
Rope(n::Int) = Rope([Knot() for _ in 1:n])
head(rope::Rope) = first(rope.knots)
tail(rope::Rope) = last(rope.knots)

function move(rope::Rope, direction::Vector{Int})
    moved = [move(head(rope), direction)]
    for (i, knot) in enumerate(rope.knots[2:end])
        push!(moved, move(knot, moved[i]))
    end
    return Rope(moved)
end

function simulate(rope::Rope, instructions::Vector)
    ropes = [rope]
    for (direction, n) in instructions, _ in 1:n
        push!(ropes, move(last(ropes), direction))
    end
    return ropes
end

function draw(rope::Rope, gridsize::NTuple{2, Int}, start::NTuple{2, Int}=(1, 1))
    nknots = length(rope.knots)
    chars = ['H', map(d -> '0' + d, 1:nknots-1)...]
    grid = fill(' ', gridsize)
    for (knot, char) in Iterators.reverse(zip(rope.knots, chars))
        coords = [start...] + knot.offset
        grid[coords...] = char
    end
    grid = permutedims(grid)
    return join(join.(eachrow(grid)), '\n')
end

function animate(ropes::Vector{Rope}, fps::Int=30)
    offsets = [knot.offset for rope in ropes for knot in rope.knots]
    ncols = maximum(abs.(first.(offsets))) * 2 + 1
    nrows = maximum(abs.(last.(offsets))) * 2 + 1
    start = (div(ncols, 2), div(nrows, 2))
    @show ncols, nrows, start
    for rope in ropes
        run(`clear`)
        grid = draw(rope, (ncols, nrows), start)
        println(grid)
        sleep(1 / fps)
    end
end

function parse_instruction(s::AbstractString)
    directions = Dict("U" => up, "D" => down, "R" => right, "L" => left)
    direction, quantity = split(strip(s))
    return directions[direction], parse(Int, quantity)
end
parse_instructions(input::AbstractString) = parse_instruction.(split(input, '\n'; keepempty=false))

function part1(input::AbstractString)
    moves = parse_instructions(input)
    ropes = simulate(Rope(2), moves)
    visited_by_tail = unique(tail(r).offset for r in ropes)
    return length(visited_by_tail)
end

# Validate on test input
test_input = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""
@show part1(test_input)
@assert part1(test_input) == 13

# Solve on puzzle input
puzzle_input = read("9.input", String)
@show part1(puzzle_input)

# ======
# Part 2
# ======
function part2(input::AbstractString)
    instructions = parse_instructions(input)
    simulation = simulate(Rope(10), instructions)
    visited_by_tail = unique(tail(rope).offset for rope in simulation)
    animate(simulation)
    return length(visited_by_tail)
end

# Validate on test input
test_input = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""
@show part2(test_input)
@assert part2(test_input) == 36

# Solve on puzzle input
@show part2(puzzle_input)
