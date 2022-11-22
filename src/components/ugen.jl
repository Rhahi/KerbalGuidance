"""
Generate initial point, assuming positive and non-vertical velocity.
Angle unit in degrees.
"""
function u_generatorₗ(v, r, d, ϕ; planar_threshold=10)
    if norm(v) < 0.1
        v = d/norm(d) # avoid zero velocity
    end
    if (∠θ(v, r) |> rad2deg) < planar_threshold
        return θ->[angle_directionₗ(v, 90-θ, ϕ); r]
    end
    return θ->[planar_rotate(v, r, -θ); r]
end
function u_generator(v, r, d, ϕ; planar_threshold=10)
    if norm(v) < 0.1
        v = d/norm(d)
    end
    if (∠θ(v, r) |> rad2deg) < planar_threshold
        return θ->[angle_direction(v, θ, ϕ); r]
    end
    return θ->[planar_rotate(v, r, -θ); r]
end
