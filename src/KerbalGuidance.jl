module KerbalGuidance

using SpaceLib
using DifferentialEquations
using Rotations
using StaticArrays
using LinearAlgebra
using Unitful
using Unitful.DefaultSymbols
import Unitful: Time, Length, Force, Mass, MassFlow, Velocity, Temperature, Area
import Base: @kwdef
import .CelestialBody: Body

# export modules
export CelestialBody

# export structs
export Stage, Rocket, HotStageRocket

# export functions
export thrust, drag, gravity_acc

include("CelestialBody/CelestialBody.jl")
include("components/rockets.jl")
include("vectors.jl")
include("components/forces.jl")
include("components/accelerations.jl")
include("components/eom.jl")
include("algorithms/search.jl")

end # module
