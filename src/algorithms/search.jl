function binary_search(solver::Function, u_generator::Function, evaluate::Function;
    body, rocket, target, input_tolerance, output_tolerance, var_min, var_max, t₀, t₁
)
    @debug "begin binary search" _group=:guidance
    var = (var_min+var_max)/2
    while true
        u = Vector(u_generator(var))
        error, sol = evaluate(solver(u, body, rocket, t₀, t₁), target)
        @debug "searching... error: $(round(error)), θ: $(round(var; digits=5))" _group=:guidance
        if abs(error) < output_tolerance
            @debug "solution found" _group=:guidance
            return true, sol, u
        end
        var_min, next_var, var_max = next_binary_search_point(var_min, var, var_max, error)
        if abs(next_var - var) < input_tolerance
            @warn "solution not found: $(round(error)), θ: $(round(var; digits=5))" _group=:guidance
            return false, sol, u
        end
        var = next_var
        yield()
    end
end

function next_binary_search_point(var_min, var, var_max, error)
    if error < 0
        return var_min, (var_min+var)/2, var
    end
    return var, (var+var_max)/2, var_max
end
