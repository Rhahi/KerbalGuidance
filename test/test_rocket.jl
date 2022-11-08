using KerbalGuidance
using KerbalGuidance: current_stage, NextStage
using Unitful.DefaultSymbols
using Test

function model(time)
    time, s1 = KerbalGuidance.NextStage(time;
        massflow = ((62.08+80.0 +2.059)kg/s),
        m₀       = (14778kg),
        m₁       = (4478kg),
        duration = (70s),
        vac      = (333.0kN),
        asl      = (282.8kN),
        area     = (2.93666m^2),
        Cd       = (0.114)
    )
    time, s2 = KerbalGuidance.NextStage(time;
        massflow = (4.961+15.23+0.2104)kg/s,
        m₀       = 1690kg,
        m₁       = 719kg,
        duration = 45s,
        vac      = 49.3kN,
        asl      = 39.2kN,
        area     = 0.669207m^2,
        Cd       = 0.114
    )
    KerbalGuidance.HotStageRocket([s1, s2])
end

@testset "stage switching test" begin
    m1 = model(0)
    @test m1.stages[1] == current_stage(m1, 0)[1]
    @test m1.stages[1] == current_stage(m1, 69.99)[1]
    @test m1.stages[2] == current_stage(m1, 70.00)[1]
    @test m1.stages[2] == current_stage(m1, 1000)[1]

    m2 = model(10)
    @test m2.stages[1] == current_stage(m2, 0)[1]
    @test m2.stages[1] == current_stage(m2, 59.99)[1]
    @test m2.stages[2] == current_stage(m2, 60.00)[1]
    @test m2.stages[2] == current_stage(m2, 1000)[1]

    m3 = model(80)
    @test m3.stages[2] == current_stage(m3, 0)[1]
    @test m3.stages[2] == current_stage(m3, 1000)[1]

    m4 = model(1000)
    @test m4.stages[2] == current_stage(m4, 0)[1]
    @test m4.stages[2] == current_stage(m4, 10000)[1]
end

@testset "stage mass test" begin
    m1 = model(0)
    m1s1 = m1.stages[1]
    m1s2 = m1.stages[2]
    @test current_stage(m1, 0)[3] == (m1s1.m₀ + m1s2.m₀)
    @test current_stage(m1, 69.999)[3] ≉ m1s2.m₀
    @test current_stage(m1, 70)[3] == m1s2.m₀
    @test current_stage(m1, 10)[3] > current_stage(m1, 20)[3]

    m2 = model(10)
    m2s1 = m2.stages[1]
    m2s2 = m2.stages[2]
    @test m2s1.m₀ != m1s1.m₀
    @test m2s1.m₁ == m1s1.m₁
    @test m2s2.m₀ == m1s2.m₀
    @test current_stage(m2, 0)[3] == (m2s1.m₀ + m2s2.m₀)
    @test current_stage(m2, 20)[3] == current_stage(m1, 30)[3]
    @test current_stage(m2, 59.999)[3] ≉ m2s2.m₀
    @test current_stage(m2, 60)[3] == m2s2.m₀
    @test current_stage(m2, 10)[3] > current_stage(m2, 20)[3]

    m3 = model(80)
    m3s1 = m3.stages[1]
    m3s2 = m3.stages[2]
    @test m3s1.m₀ == m3s1.m₁
    @test current_stage(m3, 0)[3] == m3s2.m₀
    @test current_stage(m3, 100)[3] == m3s2.m₁
    @test current_stage(m3, 10)[3] ≈ current_stage(m2, 80)[3]
end
