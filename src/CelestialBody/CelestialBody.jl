module CelestialBody

import Unitful: Length, Acceleration, Pressure
import Unitful: uconvert, ustrip
using Unitful.DefaultSymbols

include("generic.jl")
include("planets.jl")

end # module Body
