abstract type Shape end
Base.@kwdef struct Rock <: Shape points::Int8 = 1 end
Base.@kwdef struct Paper <: Shape points::Int8 = 2 end
Base.@kwdef struct Scissors <: Shape points::Int8 = 3 end

abstract type Result end
Base.@kwdef struct Win <: Result points::Int8 = 6 end
Base.@kwdef struct Draw <: Result points::Int8 = 3 end
Base.@kwdef struct Loss <: Result points::Int8 = 0 end

codex = Dict{Char, Union{Shape, Result}}(
    'A' => Rock(),
    'B' => Paper(),
    'C' => Scissors(),
    'X' => Loss(),
    'Y' => Draw(),
    'Z' => Win(),
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

struct Strategy{S <: Shape, R <: Result}
    opponent::S
    result::R
end

choose(s::Strategy{Rock, Win}) = Paper()
choose(s::Strategy{Rock, Loss}) = Scissors()
choose(s::Strategy{Paper, Win}) = Scissors()
choose(s::Strategy{Paper, Loss}) = Rock()
choose(s::Strategy{Scissors, Win}) = Rock()
choose(s::Strategy{Scissors, Loss}) = Paper()
choose(s::Strategy{<:Shape, Draw}) = s.opponent

score(s::Strategy) = score(Game(s.opponent, choose(s)))
score(guide::Vector{Strategy}) = sum(score.(guide))

parse_input(s::AbstractString) = split(s, "\n"; keepempty=false)
parse_letter(letter::Char, codex::Dict) = codex[letter]
parse_code(code::Char) = parse_letter(code, codex)
parse_strategy(s::AbstractString) = Strategy(parse_code.(only.(split(s)))...)
parse_strategy_guide(s::AbstractString) = parse_strategy.(parse_input(s))


# Validate on test data
test_data = """
A Y
B X
C Z
"""
test_strategy_guide = parse_strategy_guide(test_data)
@assert test_strategy_guide == [Strategy(Rock(), Draw()), Strategy(Paper(), Loss()), Strategy(Scissors(), Win())]
@assert score(test_strategy_guide) == 12


# Solve challenge
data = read("2.input", String)
strategy_guide = parse_strategy_guide(data)
@show score(strategy_guide)
