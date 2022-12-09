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
    pos::Vector{Int}
end
Knot() = Knot([0, 0])
touching(k1::Knot, k2::Knot) = all(abs.(k1.pos - k2.pos) .<= [1, 1])
direction(from::Knot, to::Knot) = sign.(to.pos - from.pos)
move(knot::Knot, direction::Vector{Int}) = Knot(knot.pos + direction)
move(knot::Knot, towards::Knot) = touching(knot, towards) ? knot : move(knot, direction(knot, towards))

struct Rope
    knots::Vector{Knot}
end
Rope(n::Int) = Rope([Knot() for _ in 1:n])
head(rope::Rope) = first(rope.knots)
tail(rope::Rope) = last(rope.knots)

function move(rope::Rope, direction::Vector{Int})
    new_head = move(head(rope), direction)
    rest = []
    leader = new_head
    for knot in rope.knots[2:end]
        moved = move(knot, leader)
        push!(rest, moved)
        leader = moved
    end
    return Rope([new_head, rest...])
end

function simulate(rope::Rope, instructions::Vector)
    ropes = [rope]
    for (direction, n) in instructions
        for _ in 1:n
            push!(ropes, move(last(ropes), direction))
        end
    end
    return ropes
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
    visited_by_tail = unique(tail(r).pos for r in ropes)
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
    moves = parse_instructions(input)
    steps = simulate(Rope(10), moves)
    visited_by_tail = unique(tail(rope).pos for rope in steps)
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
