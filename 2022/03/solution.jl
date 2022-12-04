# ======
# Part 1
# ======
Rucksack = Tuple{Set{Char}, Set{Char}}
left_compartment(s::AbstractString) = Set(s[begin:div(end, 2)])
right_compartment(s::AbstractString) = Set(s[(div(end, 2) + 1):end])
parse_rucksack(s::AbstractString) = (left_compartment(s), right_compartment(s))
parse_rucksacks(s::AbstractString) = parse_rucksack.(split(s))
common_item(rucksack::Rucksack) = pop!(intersect(rucksack...))
priority(item::Char) = findfirst(item, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

# Validate on test input
test_input = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
test_rucksacks = parse_rucksacks(test_input)
@assert common_item.(test_rucksacks) == ['p', 'L', 'P', 'v', 't', 's']
@assert sum(priority.(common_item.(test_rucksacks)))== 157

# Solve on puzzle input
data = read("3.input", String)
rucksacks = parse_rucksacks(data)
@show sum(priority.(common_item.(rucksacks)))


# ======
# Part 2
# ======
Group = Vector{Rucksack}
groups(rucksacks::Vector{Rucksack}) = Group.(collect(Iterators.partition(rucksacks, 3)))
common_item(group::Group) = pop!(intersect([union(rucksack...) for rucksack in group]...))

# Validate on test input
@assert sum(priority.(common_item.(groups(test_rucksacks)))) == 70

# Solve on puzzle input
@show sum(priority.(common_item.(groups(rucksacks))))