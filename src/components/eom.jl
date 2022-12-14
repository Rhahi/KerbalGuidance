function nonrotating_rhs!(du, u, p, t)
    # states and parameters
    v̄ = norm(view(u, 1:3))
    r̄ = norm(view(u, 4:6))
    body, rocket, burn_start = p
    # time offset, so that solution can be directly retreived using MET
    # if burn_start is 0, assume that rocket was burning since time 0.
    # if burn_start is 10, rocket ignites at time 10.
    time = max(0, t - burn_start)
    altitude = max(0, r̄ - body.radius)
    stage, burn_time = current_stage(rocket, time)
    mass = stage_mass(stage, burn_time)

    # intermediates
    grav = -gravity_acc(body)
    f_thrust = thrust(stage, burn_time, body, altitude)
    f_drag = -drag(stage, v̄, body, altitude)
    dynamics = (f_thrust + f_drag) / mass

    # assignment
    du[1] = u[1]/v̄*dynamics + u[4]/r̄*grav
    du[2] = u[2]/v̄*dynamics + u[5]/r̄*grav
    du[3] = u[3]/v̄*dynamics + u[6]/r̄*grav
    du[4] = u[1]
    du[5] = u[2]
    du[6] = u[3]
end
