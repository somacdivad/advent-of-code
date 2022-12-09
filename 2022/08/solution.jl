# Solution to AoC 2022 Day 8
# https://adventofcode.com/2022/day/8


# ======
# Part 1
# ======
Tree = Int8
TreeGrid = Matrix{Tree}

abstract type Direction end
abstract type Up <: Direction end
abstract type Down <: Direction end
abstract type Left <: Direction end
abstract type Right <: Direction end

dimension(::Union{Type{Up}, Type{Down}}) = 1
dimension(::Union{Type{Left}, Type{Right}}) = 2

inbounds(::Union{Type{Up}, Type{Left}}, grid::TreeGrid, i::Int) = i > 1
inbounds(::Type{Down}, grid::TreeGrid, i::Int) = i < size(grid, 1)
inbounds(::Type{Right}, grid::TreeGrid, i::Int) = i < size(grid, 2)

next_index(::Type{Up}, i::Int, j::Int) = i - 1, j
next_index(::Type{Down}, i::Int, j::Int) = i + 1, j
next_index(::Type{Left}, i::Int, j::Int) = j, i - 1
next_index(::Type{Right}, i::Int, j::Int) = j, i + 1

function look(T::Type{<:Direction}, grid::TreeGrid, from::Tuple{Int,Int}; callback::Union{Function,Nothing}=nothing)
    height = grid[from...]
    i = from[dimension(T)]
    j = from[dimension(T)%2+1]
    blocked = false
    while !blocked && inbounds(T, grid, i)
        !isnothing(callback) && callback(blocked)
        next = next_index(T, i, j)
        blocked = grid[next...] >= height
        i = next[dimension(T)]
    end
    return !blocked
end

function parse_tree_grid(s::AbstractString)
    rows = []
    for line in split(s, '\n'; keepempty=false)
        push!(rows, parse.(Tree, collect(line)))
    end
    return mapreduce(permutedims, vcat, rows)
end

function part1(input::AbstractString)
    grid = parse_tree_grid(input)
    directions = (Up, Down, Left, Right)
    num_visible = 0
    for row in axes(grid, 1), col in axes(grid, 2)
        if any([look(direction, grid, (row, col)) for direction in directions])
            num_visible += 1
        end
    end
    return num_visible
end

# Validate on test input
test_input = raw"""
30373
25512
65332
33549
35390
"""

@show part1(test_input)
@assert part1(test_input) == 21

# Solve on puzzle input
puzzle_input = read("8.input", String)
@show part1(puzzle_input)

# ======
# Part 2
# ======
function part2(input::AbstractString)
    grid = parse_tree_grid(input)
    max_score = 0
    for row in axes(grid, 1), col in axes(grid, 2)
        scenic_score = 1
        for direction in (Up, Down, Left, Right)
            view_distance = 0 
            look(direction, grid, (row, col); callback=(x) -> view_distance += 1)
            scenic_score *= view_distance
        end
        max_score = scenic_score > max_score ? scenic_score : max_score
    end
    return max_score
end

# Validate on test input
@show part2(test_input)
@assert part2(test_input) == 8

# Solve on puzzle input
@show part2(puzzle_input)