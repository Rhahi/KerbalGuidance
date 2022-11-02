import Base: @kwdef

@kwdef struct Body
    radius       ::Float64
    atmosphere   ::Float64
    grav         ::Float64
    atm_pressure ::Function
    atm_scale    ::Function
    atm_density  ::Function

    function Body(radius::Length, atmosphere::Length, grav::Acceleration, atm_source::Function, Rgas)
        r = convert(Float64, uconvert(m, radius)     |> ustrip)
        a = convert(Float64, uconvert(m, atmosphere) |> ustrip)
        g = convert(Float64, uconvert(m/s^2, grav)   |> ustrip)
        R = convert(Float64, uconvert(J/kg/K, Rgas)  |> ustrip)
        ap = h     -> pressure(atm_source, h, a)
        as = h     -> scale(atm_source, h, a)
        ad = (h,t) -> density(atm_source, h, t, R, a)
        new(r, a, g, ap, as, ad)
    end
end

function pressure(source::Function, altitude, atmosphere)
    altitude > atmosphere && return 0.
    source(altitude) # Pa
end

function density(source::Function, altitude, temperature, Rₛₚ, atmosphere)
    altitude > atmosphere && return 0.
    source(altitude) / Rₛₚ / temperature # kg/m³
end

function scale(source::Function, altitude, atmosphere)
    altitude > atmosphere && return 0.
    source(altitude) / source(0) # Unitless
end
