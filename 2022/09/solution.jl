# Solution to AoC 2022 Day 9
# https://adventofcode.com/2022/day/9


# ======
# Part 1
# ======
module RopeSimulator
    Coordinates = Vector{Int}

    abstract type Direction end
    abstract type Up <: Direction end
    abstract type Down <: Direction end
    abstract type Left <: Direction end
    abstract type Right <: Direction end

    struct Knot
        pos::Coordinates
    end
    Knot() = Knot([0, 0])

    struct Rope
        knots::Vector{Knot}
    end

    head(rope::Rope) = first(rope.knots)
    tail(rope::Rope) = last(rope.knots)

    move(::Type{Up}, knot::Knot) = Knot(knot.pos + [0, 1])
    move(::Type{Down}, knot::Knot) = Knot(knot.pos + [0, -1])
    move(::Type{Left}, knot::Knot) = Knot(knot.pos + [-1, 0])
    move(::Type{Right}, knot::Knot) = Knot(knot.pos + [1, 0])

    touching(knot1::Knot, knot2::Knot) = all(abs.(knot1.pos - knot2.pos) .<= [1, 1])

    function follow(leader::Knot, follower::Knot)
        touching(leader, follower) && return follower
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

    export Knot, Rope
    export head, tail
    export Direction, Up, Down, Left, Right
    export move
end

module Parser
    using ..RopeSimulator 

    function parse_move(s::AbstractString)
        directions = Dict("U" => Up, "D" => Down, "R" => Right, "L" => Left)
        direction, quantity = split(strip(s))
        return directions[direction], parse(Int, quantity)
    end

    parse_moves(input::AbstractString) = parse_move.(split(strip(input), '\n'))

    export parse_moves
end

using .RopeSimulator
using .Parser

function part1(input::AbstractString)
    moves = parse_moves(input)
    rope = Rope([Knot(), Knot()])
    visited_by_tail = Set([tail(rope).pos])
    for (direction, n) in moves
        for _ in 1:n
            rope = move(direction, rope)
            push!(visited_by_tail, tail(rope).pos)
        end
    end
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
    moves = parse_moves(input)
    rope = Rope([Knot() for _ in 1:10])
    visited_by_tail = Set([tail(rope).pos])
    for (direction, n) in moves
        for _ in 1:n
            rope = move(direction, rope)
            push!(visited_by_tail, tail(rope).pos)
        end
    end
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
