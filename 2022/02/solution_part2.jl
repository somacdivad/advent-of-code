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

struct Strategy{S <: Shape, R <: Result}
    opponent::S
    result::R
end

struct Game{T <: Shape, S <: Shape}
    self::T
    opponent::S
end

play(::Game{Rock, Scissors}) = Win()
play(::Game{Paper, Rock}) = Win()
play(::Game{Scissors, Paper}) = Win()
play(::Game{T, T} where T <: Shape) = Draw()
play(::Game{<:Shape, <:Shape}) = Loss()
score(game::Game) = play(game).points + game.self.points

decode_letter(letter::Char, codex::Dict) = get(codex, letter, nothing)
parse_input(s::AbstractString) = split(s, "\n")

function parse_strategy(s::AbstractString, codex::Dict)
    decode(c::Char) = decode_letter(c, codex)
    codes = only.(split(s))
    decoded = decode.(codes)
    shape, result = decoded[1], decoded[2]
    return Strategy(shape, result)
end

parse_strategy_guide(s::AbstractString, codex::Dict) = [parse_strategy(strategy, codex) for strategy in parse_input(s)]

function calc_strategy_shape(strategy::Strategy)
    for shape in (Rock(), Paper(), Scissors())
        game = Game(shape, strategy.opponent)
        play(game) == strategy.result && return shape
    end
end

Base.convert(strategy::Strategy, ::Type{Game}) = Game(calc_strategy_shape(strategy), strategy.opponent)
score(strategy_guide::Vector{Strategy}) = sum(score.(convert.(strategy_guide, Game)))


# Validate on test data
test_data = read("test_data.txt", String)
test_strategy_guide = parse_strategy_guide(test_data, codex)
@assert test_strategy_guide == [Strategy(Rock(), Draw()), Strategy(Paper(), Loss()), Strategy(Scissors(), Win())]
@assert score(test_strategy_guide) == 12


# Solve challenge
data = read("data.txt", String)
strategy_guide = parse_strategy_guide(data, codex)
@show score(strategy_guide)