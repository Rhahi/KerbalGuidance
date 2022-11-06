"""
thrust(stage, t)

Vaccum thrust of the model rocket.
"""
function thrust(stage::Stage, burn_time)
    burn_time > stage.duration && return 0.
    stage.vac
end

"""
thrust(stage, body, h)

Thrust of the model rocket, accounting for atmospheric affect.
Assume continuous burn since ignition.
"""
function thrust(stage::Stage, burn_time, body::CelestialBody.Body, altitude)
    if altitude > body.atmosphere
        return thrust(stage, burn_time)
    end
    burn_time > stage.duration && return 0.
    stage.vac - (stage.vac - stage.asl) * body.atm_scale(altitude)
end

"""
drag(stage, v, body, h, T)

Drag force the model rocket is experiencing.
"""
function drag(stage::Stage, velocity, B::CelestialBody.Body, altitude, temperature=300)
    if altitude > B.atmosphere
        return 0
    end
    0.5 * B.atm_density(altitude, temperature) * velocity^2 * stage.Cd * stage.area
end
