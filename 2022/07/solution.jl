# Solution to AoC 2022 Day 7
# https://adventofcode.com/2022/day/7


# ======
# Part 1
# ======
module FileSystem
    struct File
        name::String
        size::Int
    end
    Base.sizeof(f::File) = f.size

    struct Directory
        name::String
        parent::Union{Directory, Nothing}
        files::Dict{String, File}
        subdirectories::Dict{String, Directory}
    end
    Directory(name::AbstractString) = Directory(name, nothing, Dict(), Dict())
    Base.sizeof(d::Directory) = sum(sizeof.(values(d.files))) + sum(sizeof.(values(d.subdirectories)); init=0)

    function makefile!(name::AbstractString, size::Int, cwd::Directory)
        cwd.files[name] = File(name, size)
        return cwd
    end

    function makedir!(name::AbstractString, cwd::Directory)
        if name ∉ keys(cwd.subdirectories)
            cwd.subdirectories[name] = Directory(name, cwd, Dict(), Dict())
        end
        return cwd
    end

    function changedir(name::AbstractString, cwd::Directory)
        name in keys(cwd.subdirectories) && return cwd.subdirectories[name]
        name == ".." && return cwd.parent
        return cwd
    end

    function traverse(dir::Directory; filter_by::Union{Function, Nothing}=nothing)
        unvisited = [dir]
        filtered = []
        while !isempty(unvisited)
            d = pop!(unvisited)
            (isnothing(filter_by) || filter_by(d)) && push!(filtered, d)
            unvisited = vcat(unvisited, values(d.subdirectories)...)
        end
        return filtered
    end

    export File
    export Directory
    export makefile!
    export makedir!
    export changedir
    export traverse
end

module Parser
    using ..FileSystem

    is_cmd(s::AbstractString) = startswith(s, r"\$")

    function parse_cmd(s::AbstractString, cwd::Directory)
        cmd, _, arg = match(r"\$ (?<cmd>\S+)( (?<arg>\S+))?", s)
        cmd == "cd" && return changedir(arg, cwd)
        return cwd
    end

    function parse_output!(s::AbstractString, cwd::Directory)
        info, name = match(r"(?<info>\S+) (?<name>\S+)", s)
        info == "dir" && return makedir!(name, cwd)
        size = tryparse(Int, info)
        size != nothing && return makefile!(name, size, cwd)
        return cwd
    end

    function parse_terminal_output(s::AbstractString)
        root = Directory("/")
        cwd = root
        for line in split(s, '\n'; keepempty=false)
            cwd = is_cmd(line) ? parse_cmd(line, cwd) : parse_output!(line, cwd)
        end
        return root
    end

    export parse_terminal_output
end

using .FileSystem
using .Parser

function part1(puzzle_input::AbstractString)
    root = parse_terminal_output(puzzle_input)
    small_enough(dir::Directory) = sizeof(dir) <= 100000
    dirs = traverse(root; filter_by=small_enough)
    return sum(sizeof.(dirs))
end

# Validate on test input
test_input = raw"""
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

@show part1(test_input)
@assert part1(test_input) == 95437

# Solve on puzzle input
puzzle_input = read("7.input", String)
@show part1(puzzle_input)


# ======
# Part 2
# ======
function part2(puzzle_input::AbstractString)
    root = parse_terminal_output(puzzle_input)
    total = 70000000
    used = sizeof(root)
    free = total - used
    needed = 30000000
    large_enough(dir::Directory) = (sizeof(dir) + free) >= needed
    dirs = traverse(root; filter_by=large_enough)
    return minimum(sizeof.(dirs))
end

# Validate on test input
@show part2(test_input)
@assert part2(test_input) == 24933642

# Solve on puzzle input
@show part2(puzzle_input)