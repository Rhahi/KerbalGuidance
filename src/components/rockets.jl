abstract type Rocket end

struct Stage
    ṁ        ::Float64 # kg/s
    m₀       ::Float64 # kg
    m₁       ::Float64 # kg
    duration ::Float64 # s
    vac      ::Float64 # N
    asl      ::Float64 # N
    area     ::Float64 # m²
    Cd       ::Float64 # -
end
function NextStage(time=0; massflow, m₀, m₁, duration, vac, asl, area, Cd)
    ṁ        = convert(Float64, uconvert(kg/s, massflow) |> ustrip)
    m₀       = convert(Float64, uconvert(kg, m₀)         |> ustrip)
    m₁       = convert(Float64, uconvert(kg, m₁)         |> ustrip)
    duration = convert(Float64, uconvert(s, duration)    |> ustrip)
    m₀ = m₀ - min(ṁ*time, m₁)
    m₁ = m₁ - min(ṁ*time, 0)
    vac      = convert(Float64, uconvert(N, vac)         |> ustrip)
    asl      = convert(Float64, uconvert(N, asl)         |> ustrip)
    area     = convert(Float64, uconvert(m^2, area)      |> ustrip)
    Cd       = convert(Float64, Cd)
    max(0, time-duration), Stage(ṁ, m₀, m₁, duration, vac, asl, area, Cd)
end


"""Collection of rocket stages without any coasting."""
struct HotStageRocket <: Rocket
    stages::Array{Stage, 1}
end


function current_stage(rocket::HotStageRocket, time)
    burn_capability = 0
    previous_burn_time = 0
    stage = rocket.stages[end]
    burn_time = 0
    for s in rocket.stages
        burn_capability += s.duration
        if time > burn_capability
            # This stage has been dropped.
            previous_burn_time += s.duration
            continue
        end
        # this stage is the current stage
        stage = s
        break
    end
    burn_time = time - previous_burn_time
    return stage, burn_time
end


function stage_mass(stage::Stage, time)
    stage.m₀ - min(stage.m₁, stage.ṁ * (time)) # kg
end
