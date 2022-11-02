function binary_search(solver::Function, u_generator::Function, evaluate::Function;
        body, rocket, target, input_tolerance, output_tolerance, var_min, var_max, tf)
    @log_entry "begin binary search"
    var = (var_min+var_max)/2
    while true
        u = Vector(u_generator(var))
        error, sol = evaluate(solver(u, body, rocket, tf), target)
        @log_traceloop "searching... error: $(round(error)), angle: $(round(var; digits=5))"
        if abs(error) < output_tolerance
            @log_guidance "solution found"
            return sol, u
        end
        var_min, next_var, var_max = next_binary_search_point(var_min, var, var_max, error)
        if abs(next_var - var) < input_tolerance
            @warn "solution not found"
            return nothing, nothing
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
