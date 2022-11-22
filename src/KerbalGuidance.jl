module KerbalGuidance

using DifferentialEquations
using StaticArrays
using LinearAlgebra
using Unitful
using Unitful.DefaultSymbols
using Unitful: Time, Length, Force, Mass, MassFlow, Velocity, Temperature, Area
using KerbalMath
import Base: @kwdef

# export modules
export CelestialBody

# export structs
export Stage, Rocket, HotStageRocket

# export functions
export thrust, drag, gravity_acc

include("CelestialBody/CelestialBody.jl")
include("components/ugen.jl")
include("components/rockets.jl")
include("components/forces.jl")
include("components/accelerations.jl")
include("components/eom.jl")
include("algorithms/search.jl")

end # module
