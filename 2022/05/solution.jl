# Solution to AoC 2022 Day 5
# https://adventofcode.com/2022/day/5


# ======
# Part 1
# ======
module SupplyDepot
    Crate = Char
    StackOfCrates = Vector{Crate}
    Depot = Vector{StackOfCrates}

    function add_row_crates!(depot::Depot, row::AbstractString)
        crates = [char for (i, char) in enumerate(row) if i % 4 == 2]
        for (i, crate) in enumerate(crates)
            isletter(crate) && push!(depot[i], crate)
        end
        return depot
    end

    function parse_depot(diagram::AbstractString)
        rows = split(diagram, '\n'; keepempty=false)
        row_len = length(first(rows))
        n_stacks = div(row_len - 3, 4) + 1
        depot = [StackOfCrates() for _ in 1:n_stacks]
        for row in reverse(rows[begin:end-1])
            depot = add_row_crates!(depot, row)
        end
        return depot
    end

    export Depot
    export parse_depot
end


module Crane
    using ..SupplyDepot: Depot

    abstract type AbstractCrane end
    Instruction = Tuple{Int, Int, Int}
    Instructions = AbstractArray{Instruction}

    function parse_instruction(s::AbstractString)
        m = match(r"move (?<qty>\d+) from (?<src>\d+) to (?<dest>\d+)", s)
        return Instruction([parse(Int, char) for char in m.captures])
    end

    function parse_instructions(instruction_list::AbstractString)
        return parse_instruction.(split(instruction_list, "\n"; keepempty=false))
    end

    function move_crate!(::Type{<:AbstractCrane}, D::Depot, src::Int, dest::Int)
        !isempty(D[src]) && push!(D[dest], pop!(D[src]))
        return D
    end

    function move_crate!(D::Depot, src::Int, dest::Int)
        return move_crate!(AbstractCrane, D, src, dest)
    end

    function move_crates!(T::Type{<:AbstractCrane}, D::Depot, src::Int, dest::Int, qty::Int)
        for _ in 1:qty
            D = move_crate!(T, D, src, dest)
        end
        return D
    end

    function move_crates!(D::Depot, src::Int, dest::Int, qty::Int)
        return move_crates!(AbstractCrane, D, src, dest, qty)
    end

    function execute_instruction!(T::Type{<:AbstractCrane}, D::Depot, instruction::Instruction)
        qty, src, dest = instruction
        return move_crates!(T, D, src, dest, qty)
    end

    function execute_instruction!(D::Depot, instruction::Instruction)
        return execute_instruction!(AbstractCrane, D, instruction)
    end

    function execute_instructions!(T::Type{<:AbstractCrane}, D::Depot, instructions::Instructions)
        for instruction in instructions
            D = execute_instruction!(T, D, instruction)
        end
        return D
    end

    function execute_instructions!(D::Depot, instructions::Instructions)
        return execute_instructions!(AbstractCrane, D, instructions)
    end

    export parse_instructions
    export execute_instructions!
end


using .SupplyDepot
using .Crane


function parse_input(s::AbstractString)
    diagram, instruction_list = split(s, "\n\n"; keepempty=false)
    return parse_depot(diagram), parse_instructions(instruction_list)
end

make_message(D::Depot) = join(last.(D))

function part1(puzzle_input::AbstractString)
    depot, instructions = parse_input(puzzle_input)
    depot = execute_instructions!(depot, instructions)
    return make_message(depot)
end

# Validate on test input
test_input = """
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""
@show part1(test_input)
@assert part1(test_input) == "CMZ"

# Solve on puzzle input
puzzle_input = read("5.input", String)
@show part1(puzzle_input)


# ======
# Part 2
# ======
using .Crane: AbstractCrane

abstract type CrateMover9001 <: AbstractCrane end

function Crane.move_crates!(::Type{CrateMover9001}, D::Depot, src::Int, dest::Int, qty::Int)
    to_move = []
    for _ in 1:qty
        !isempty(D[src]) && push!(to_move, pop!(D[src]))
    end
    while !isempty(to_move)
        push!(D[dest], pop!(to_move))
    end
    return D
end

function part2(puzzle_input::AbstractString)
    depot, instructions = parse_input(puzzle_input)
    depot = execute_instructions!(CrateMover9001, depot, instructions)
    return make_message(depot)
end

# Validate on test input
@show part2(test_input)
@assert part2(test_input) == "MCD"

# Solve on puzzle input
@show part2(puzzle_input)
