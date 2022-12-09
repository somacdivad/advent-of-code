# Solution to AoC 2022 Day 9
# https://adventofcode.com/2022/day/9


# ======
# Part 1
# ======
abstract type Direction end
abstract type Up <: Direction end
abstract type Down <: Direction end
abstract type Left <: Direction end
abstract type Right <: Direction end
Coordinates = Vector{Int}

struct Knot
    pos::Coordinates
end
Knot() = Knot([0, 0])

struct Rope
    knots::Vector{Knot}
end
Rope(n::Int) = Rope([Knot() for _ in 1:n])

head(rope::Rope) = first(rope.knots)
tail(rope::Rope) = last(rope.knots)
move(::Type{Up}, knot::Knot) = Knot(knot.pos + [0, 1])
move(::Type{Down}, knot::Knot) = Knot(knot.pos + [0, -1])
move(::Type{Left}, knot::Knot) = Knot(knot.pos + [-1, 0])
move(::Type{Right}, knot::Knot) = Knot(knot.pos + [1, 0])

function follow(leader::Knot, follower::Knot)
    is_touching = all(abs.(leader.pos - follower.pos) .<= [1, 1])
    is_touching && return follower
    return Knot(follower.pos + sign.(leader.pos - follower.pos))
end

function move(T::Type{<:Direction}, rope::Rope)
    new_head = move(T, head(rope))
    rest = []
    leader = new_head
    for knot in rope.knots[2:end]
        moved = follow(leader, knot)
        push!(rest, moved)
        leader = moved
    end
    return Rope([new_head, rest...])
end

function simulate(rope::Rope, instructions::Vector)
    steps = [rope]
    for (direction, n) in instructions
        for _ in 1:n
            push!(steps, move(direction, last(steps)))
        end
    end
    return steps
end

function parse_instruction(s::AbstractString)
    directions = Dict("U" => Up, "D" => Down, "R" => Right, "L" => Left)
    direction, quantity = split(strip(s))
    return directions[direction], parse(Int, quantity)
end
parse_instructions(input::AbstractString) = parse_instruction.(split(input, '\n'; keepempty=false))

function part1(input::AbstractString)
    moves = parse_instructions(input)
    steps = simulate(Rope(2), moves)
    visited_by_tail = unique(tail(rope).pos for rope in steps)
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
