
"""
Generate initial point, assuming positive and non-vertical velocity.
"""
function u_generator(v, r, d, ϕ)
    if norm(v) < 0.1
        @debug "using direction instead of velocity" _group=:guidance
        v = d/norm(d) # avoid zero velocity
    end
    if norm(v × r)/norm(v)/norm(r) < 0.1  # if we are facing up direction too much
        @debug "using azimuth mode" _group=:guidance
        return θ->[direction(v, θ, ϕ); r] # use azimuth during vertical ascent
    end
    @debug "using up vector as base" _group=:guidance
    θ->[planar_rotate(v, r, θ); r]
end

"""
    planar_rotate(vec, base, θ)

Rotate `vec` around `base` by angle θ, while staying in the same plane.
Clockwise rotation in game.
"""
function planar_rotate(vec, base, θ)
    axis = cross(base, vec)
    axial_rotate(vec, axis, -θ)
end

"""
    axial_rotate(vec, base, θ)

Rotate `vec` about `base` by angle θ.
Clockwise rotation in game.
"""
function axial_rotate(vec, axis, θ)
    â = axis / norm(axis)
    RotationVec((deg2rad(-θ)*â)...) * vec
end

"""
    direction(r, θ, ϕ)

A new vector pointing at azimuth ϕ, pitched down by θ from vertical.
"""
function direction(r, θ, ϕ)
    north = [0., 1., 0.]
    up = r/norm(r)
    east = north × up
    azi = axial_rotate(east, up, ϕ)
    planar_rotate(azi, up, θ-90°)
end
