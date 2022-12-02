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
    self::T
    other::S
end

play(::Game{Rock, Scissors}) = Win()
play(::Game{Paper, Rock}) = Win()
play(::Game{Scissors, Paper}) = Win()
play(::Game{T, T} where T <: Shape) = Draw()
play(::Game{<:Shape, <:Shape}) = Loss()
score(game::Game) = play(game).points + game.self.points

decode_letter(letter::Char, codex::Dict) = get(codex, letter, nothing)
parse_input(s::AbstractString) = split(s, "\n")

function parse_game(s::AbstractString, codex::Dict)
    decode(c::Char) = decode_letter(c, codex)
    codes = only.(split(s))
    shapes = decode.(codes)
    other, self = shapes[1], shapes[2]
    return Game(self, other)
end

parse_strategy_guide(s::AbstractString, codex::Dict) = [parse_game(game, codex) for game in parse_input(s)]
score(strategy_guide::Vector{Game}) = sum(score.(strategy_guide))

# Validate on test data
test_data = read("test_data.txt", String)
test_strategy_guide = parse_strategy_guide(test_data, codex)
@assert test_strategy_guide == [Game(Paper(), Rock()), Game(Rock(), Paper()), Game(Scissors(), Scissors())]
@assert score(test_strategy_guide) == 15


# Solve challenge
data = read("data.txt", String)
strategy_guide = parse_strategy_guide(data, codex)
@show score(strategy_guide)