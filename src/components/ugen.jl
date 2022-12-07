"""
Generate initial point, assuming positive and non-vertical velocity.
Angle unit in degrees.
"""
function u_generatorₗ(v, r, d, ϕ; planar_threshold=10, initial_velocity=20)
    if norm(v) < 1
        @info "using direction fallback"
        # v = d/norm(d) # avoid zero velocity
        v = r/norm(r)
    end
    if (∠θ(v, r) |> rad2deg) < planar_threshold
        @info "using direction method"
        return θ->[initial_velocity*angle_directionₗ(v, 90-θ, ϕ); r]
    end
    return θ->[planar_rotate(v, r, -θ); r]
end
function u_generator(v, r, d, ϕ; planar_threshold=10)
    if norm(v) < 1
        v = d/norm(d)
    end
    if (∠θ(v, r) |> rad2deg) < planar_threshold
        return θ->[angle_direction(v, θ, ϕ); r]
    end
    return θ->[planar_rotate(v, r, -θ); r]
end
