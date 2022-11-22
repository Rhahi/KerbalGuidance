using KerbalGuidance
using Unitful.DefaultSymbols
using KerbalGuidance: current_stage, NextStage, stage_mass
using Plots

function model(time)
    # XLR41
    time, s1 = KerbalGuidance.NextStage(time;
        massflow = ((62.08+80.0 +2.059)kg/s),
        m₀       = (14831kg),
        m₁       = (4298kg),
        duration = (70s),
        vac      = (333.0kN),
        asl      = (282.8kN),
        area     = (2.93666m^2),
        Cd       = (0.114)
    )
    # U2000
    time, s2 = KerbalGuidance.NextStage(time;
        massflow = (2.025+7.695+0.3281)kg/s,
        m₀       = 2213kg,
        m₁       = 1594kg,
        duration = 60s,
        vac      = 23kN,
        asl      = 19.6kN,
        area     = 0.669207m^2,
        Cd       = 0.114
    )
    # U2000
    time, s3 = KerbalGuidance.NextStage(time;
        massflow = (2.025+7.695+0.3281)kg/s,
        m₀       = 1163kg,
        m₁       = 459kg,
        duration = 60s,
        vac      = 23kN,
        asl      = 19.6kN,
        area     = 0.669207m^2,
        Cd       = 0.114
    )
    KerbalGuidance.HotStageRocket([s1, s2, s3])
end

function simulate_masscurve(tp)
    time = LinRange(0, 300, 30000)
    data_mass = []
    data_thrust = []
    data_burntime = []
    for t in time
        rocket = model(tp)
        stage, burntime = current_stage(rocket, t)
        push!(data_mass, stage_mass(stage, burntime))
        push!(data_thrust, thrust(stage, burntime))
        push!(data_burntime, burntime)
    end
    return time, data_mass, data_thrust, data_burntime
end

function plotdata(data, t0::Int=0, t1::Int=300)
    time, data_mass, data_thrust, data_burntime = data
    t0 *= 100
    t1 *= 100
    t0 = max(1, t0)
    t1 = min(30000, t1)
    pmass = plot(time[t0:t1], data_mass[t0:t1], title="mass")
    pth = plot(time[t0:t1], data_thrust[t0:t1], title="thrust")
    pbt = plot(time[t0:t1], data_burntime[t0:t1], title="stagetime")
    plot(pmass, pth, pbt, layout=(1,3), size=(1000,500))
end
