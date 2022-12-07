function binary_search(solver::Function, ugen::Function, evaluate::Function;
    p=nothing, target, θ_min, θ_max, t₀, t₁,
    search_resolution, acceptable_error_low, acceptable_error_high, returnable_error,
)
    @info "begin binary search" _group=:guidance
    θ = (θ_min+θ_max)/2
    solution = nothing
    solution_u = nothing
    last_solution = nothing
    last_u = nothing
    best_error = Inf
    while true
        u = Vector(ugen(θ))
        error, sol = evaluate(solver(u, p, t₀, t₁), target)
        @info "searching... error: $(round(error)), θ: $(round(θ; digits=5))" _group=:guidance
        if acceptable_error_low < error < acceptable_error_high
            if abs(error) < abs(best_error)
                solution = sol
                solution_u = u
                best_error = error
                abs(error) < returnable_error && break
            end
        end
        θ_min, next, θ_max = next_binary_search_point(θ_min, θ, θ_max, error)
        if abs(next - θ) < search_resolution
            last_solution = sol
            last_u = u
            break
        end
        θ = next
        yield()
    end
    isnothing(solution) && return false, last_solution, last_u
    return true, solution, solution_u
end

function next_binary_search_point(var_min, var, var_max, error)
    if error < 0
        return var_min, (var_min+var)/2, var
    end
    return var, (var+var_max)/2, var_max
end
