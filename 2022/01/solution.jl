# Solution to AoC 2022 Day 1
# https://adventofcode.com/2022/day/1

# ======
# Part 1
# ======
parse_input(s::AbstractString) = split(s, "\n\n")
parse_elf(s::AbstractString) = parse.(Int, split(s))
transform(s::AbstractString) = [sum(parse_elf(elf)) for elf in parse_input(s)]
top_elf_idx(data::Vector{Int}) = argmax(data)
top_elf_calories(data::Vector{Int}) = maximum(data)

# Check against test data
test_input = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""
test_data = transform(test_input)
@assert test_data == [6000, 4000, 11000, 24000, 10000]
@assert top_elf_idx(test_data) == 4
@assert top_elf_calories(test_data) == 24000

# Find answer on challenge data
challenge_data = transform(read("input.txt", String))
part1 = top_elf_calories(challenge_data)
@show part1  # 69177


# ======
# Part 2
# ======
ranked(data::Vector) = sort(data, rev=true)
top3(data::Vector) = data[1:3]
top3_total_calories(data::Vector{Int}) = sum(top3(ranked(data)))

# Check against test data
@assert top3_total_calories(test_data) == 45000

# Find answer on challenge data
part2 = top3_total_calories(challenge_data)
@show part2  # 207456