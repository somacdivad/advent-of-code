# Solution to AoC 2022 Day 6
# https://adventofcode.com/2022/day/6


# ======
# Part 1
# ======
function find_marker(buffer::AbstractString, len::Int)
    for i in 1:length(buffer)-len+1
        start, stop = i, i + len - 1
        chars = buffer[start:stop]
        length(unique(chars)) == len && return stop
    end
end

part1(buffer::AbstractString) = find_marker(buffer, 4)

# Validate on test input
@assert part1("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
@assert part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
@assert part1("nppdvjthqldpwncqszvftbrmjlhg") == 6
@assert part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
@assert part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11

# Solve on puzzle input
puzzle_input = read("6.input", String)
@show part1(puzzle_input)


# ======
# Part 2
# ======
part2(buffer::AbstractString) = find_marker(buffer, 14)

# Validate on test input
@assert part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
@assert part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
@assert part2("nppdvjthqldpwncqszvftbrmjlhg") == 23
@assert part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
@assert part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26

# Solve on puzzle input
@show part2(puzzle_input)
