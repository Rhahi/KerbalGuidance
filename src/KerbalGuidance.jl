module KerbalGuidance

using DifferentialEquations
using Rotations
using StaticArrays
using LinearAlgebra
using Unitful
using Unitful.DefaultSymbols
using Unitful: Time, Length, Force, Mass, MassFlow, Velocity, Temperature, Area
import Base: @kwdef

# export modules
export CelestialBody

# export structs
export Stage, Rocket, HotStageRocket

# export functions
export thrust, drag, gravity_acc

include("vectors.jl")
include("CelestialBody/CelestialBody.jl")
include("components/rockets.jl")
include("components/forces.jl")
include("components/accelerations.jl")
include("components/eom.jl")
include("algorithms/search.jl")

end # module
