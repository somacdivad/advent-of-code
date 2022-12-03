abstract type Shape end
Base.@kwdef struct Rock <: Shape points::Int8 = 1 end
Base.@kwdef struct Paper <: Shape points::Int8 = 2 end
Base.@kwdef struct Scissors <: Shape points::Int8 = 3 end

abstract type Result end
Base.@kwdef struct Win <: Result points::Int8 = 6 end
Base.@kwdef struct Draw <: Result points::Int8 = 3 end
Base.@kwdef struct Loss <: Result points::Int8 = 0 end

codex = Dict{Char, Shape}(
    'A' => Rock(),
    'B' => Paper(),
    'C' => Scissors(),
    'X' => Rock(),
    'Y' => Paper(),
    'Z' => Scissors(),
)

struct Game{T <: Shape, S <: Shape}
    opponent::T
    self::S
end

play(::Game{Scissors, Rock}) = Win()
play(::Game{Rock, Paper}) = Win()
play(::Game{Paper, Scissors}) = Win()
play(::Game{T, T} where T <: Shape) = Draw()
play(::Game{<:Shape, <:Shape}) = Loss()
score(game::Game) = play(game).points + game.self.points

parse_input(s::AbstractString) = split(s, "\n"; keepempty=false)
parse_letter(letter::Char, codex::Dict) = get(codex, letter, nothing)
parse_code(code::Char) = parse_letter(code, codex)
parse_game(s::AbstractString) = Game(parse_code.(only.(split(s)))...)
parse_strategy_guide(s::AbstractString, codex::Dict) = parse_game.(parse_input(s))
score(strategy_guide::Vector{Game}) = sum(score.(strategy_guide))


# Validate on test data
test_data = """
A Y
B X
C Z
"""
test_strategy_guide = parse_strategy_guide(test_data, codex)
@assert test_strategy_guide == [Game(Rock(), Paper()), Game(Paper(), Rock()), Game(Scissors(), Scissors())]
@assert score(test_strategy_guide) == 15


# Solve challenge
data = read("2.input", String)
strategy_guide = parse_strategy_guide(data, codex)
@show score(strategy_guide)