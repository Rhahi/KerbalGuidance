module CelestialBody

using Unitful.DefaultSymbols
using Unitful: Length, Acceleration, Pressure
using Unitful: uconvert, ustrip
import Base: @kwdef

include("generic.jl")
include("planets.jl")

end
