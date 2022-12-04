# Solution to AoC 2022 Day 4
# https://adventofcode.com/2022/day/4

# ======
# Part 1
# ======
AssignmentPair = Tuple{Set{Int}, Set{Int}}
parse_int(s::AbstractString) = parse(Int, s)
parse_assignment(s::AbstractString) = Set(range(parse_int.(split(s, '-'))...))
parse_pair(s::AbstractString) = AssignmentPair(parse_assignment.(split(s, ",")))
parse_pairs(s::AbstractString) = parse_pair.(split(s; keepempty=false))
one_contains_other(pair::AssignmentPair) = union(pair...) in pair

# Validate on test input
test_input = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""
test_assignments = parse_pairs(test_input)
@assert test_assignments == [
    (Set(2:4), Set(6:8)),
    (Set(2:3), Set(4:5)),
    (Set(5:7), Set(7:9)),
    (Set(2:8), Set(3:7)),
    (Set(6:6), Set(4:6)),
    (Set(2:6), Set(4:8)),
]
@assert sum(one_contains_other.(test_assignments)) == 2


# Solve on puzzle input
puzzle_input = read("4.input", String)
@show sum(one_contains_other.(parse_pairs(puzzle_input)))

# ======
# Part 2
# ======
is_overlapping(pair::AssignmentPair) = !isempty(intersect(pair...))

# Validate on test input
@assert sum(is_overlapping.(test_assignments)) == 4

# Solve on puzzle input
@show sum(is_overlapping.(parse_pairs(puzzle_input)))