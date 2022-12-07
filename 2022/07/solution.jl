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

    struct Directory
        name::String
        files::Vector{File}
        parent::Union{Directory, Nothing}
        subdirectories::Dict{String, Directory}
    end

    Directory(name::AbstractString) = Directory(name, [], nothing, Dict())

    Base.sizeof(f::File) = f.size
    Base.sizeof(d::Directory) = sum(sizeof.(d.files)) + sum(sizeof.(values(d.subdirectories)); init=0)

    function makedir!(name::AbstractString, cwd::Directory)
        if name ∉ keys(cwd.subdirectories)
            cwd.subdirectories[name] = Directory(name, [], cwd, Dict())
        end
        return cwd
    end

    function traverse!(d::Directory, visited::Vector, by::Union{Function, Nothing})
        visited = isnothing(by) || by(d) ? push!(visited, d) : visited
        for dir in values(d.subdirectories)
            traverse!(dir, visited, by)
        end
    end

    function traverse(d::Directory; by::Union{Function, Nothing}=nothing)
        visited = []
        traverse!(d, visited, by)
        return visited
    end

    export File
    export Directory
    export makedir!
    export traverse
end

module Parser
    using ..FileSystem

    is_cmd(s::AbstractString) = startswith(s, r"\$")

    function parse_cd(arg::AbstractString, cwd::Directory)
        arg in keys(cwd.subdirectories) && return cwd.subdirectories[arg]
        arg == ".." && return cwd.parent
        return cwd
    end

    function parse_cmd(s::AbstractString, cwd::Directory)
        cmd, _, arg = match(r"\$ (?<cmd>\S+)(\s(?<arg>\S+))?", s)
        cmd == "cd" && return parse_cd(arg, cwd)
        return cwd
    end

    function parse_dir!(name::AbstractString, cwd::Directory)
        name ∉ keys(cwd.subdirectories) && return makedir!(name, cwd)
        return cwd
    end

    function parse_file!(info::AbstractString, name::AbstractString, cwd::Directory)
        f = File(name, parse(Int64, info))
        push!(cwd.files, f)
        return cwd
    end

    function parse_info!(info::AbstractString, name::AbstractString, cwd::Directory)
        info == "dir" && return parse_dir!(name, cwd)
        tryparse(Int, info) != nothing && return parse_file!(info, name, cwd)
        return cwd
    end

    function parse_output!(s::AbstractString, cwd::Directory)
        info, name = match(r"(?<info>\S+) (?<name>\S+)", s)
        return parse_info!(info, name, cwd)
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
    dirs = traverse(root; by=d -> sizeof(d) <= 100000)
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
    dirs = traverse(root; by=d -> (sizeof(d) + free) >= needed)
    return minimum(sizeof.(dirs))
end

# Validate on test input
@show part2(test_input)
@assert part2(test_input) == 24933642

# Solve on puzzle input
@show part2(puzzle_input)