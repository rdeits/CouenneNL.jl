__precompile__()

module CouenneNL

export CouenneNLSolver

using Lazy: @forward
using Suppressor: @capture_out
using AmplNLWriter
using AmplNLWriter: AmplNLMathProgModel, AmplNLNonlinearModel, AmplNLLinearQuadraticModel
using MathProgBase
importall MathProgBase.SolverInterface


const depsjl = joinpath(dirname(dirname(@__FILE__)), "deps", "deps.jl")
if !isfile(depsjl)
    error("CMakeWrapper not properly installed. Please run\nPkg.build(\"CouenneNL\")")
else
    include(depsjl)
end


struct CouenneNLSolver <: AbstractMathProgSolver
    solver::AmplNLSolver
end

function CouenneNLSolver(options::Vector{String}=String[], filename::String="")
    CouenneNLSolver(AmplNLSolver(couenne_executable, options, filename))
end

mutable struct CouenneNLLinearQuadraticModel <: AbstractLinearQuadraticModel
    model::AmplNLLinearQuadraticModel
    objective_bound::Float64
end

LinearQuadraticModel(s::CouenneNLSolver) = CouenneNLLinearQuadraticModel(LinearQuadraticModel(s.solver), NaN)

mutable struct CouenneNLNonlinearModel <: AbstractNonlinearModel
    model::AmplNLNonlinearModel
    objective_bound::Float64
end

NonlinearModel(s::CouenneNLSolver) = CouenneNLNonlinearModel(NonlinearModel(s.solver), NaN)

@forward CouenneNLSolver.solver getsolvername

function optimize!(model::Union{CouenneNLLinearQuadraticModel, CouenneNLNonlinearModel})
    inner = model.model.inner
    output = @capture_out begin
        optimize!(inner)
    end
    if inner.status == :Optimal || inner.status == :UserLimit
        println(output)
        lower_bound = parse(Float64, match(r"\nLower bound:\s*([^\s]*)", output)[1])
        m = match(r"\nUpper bound:\s*([^\s]*)\s+\(gap: ([^\s%]*)%\)", output)
        upper_bound = parse(Float64, m[1])
        gap = parse(Float64, m[2])
        @assert lower_bound <= upper_bound
        if inner.sense == :Min
            @assert isapprox(upper_bound, getobjval(model), rtol=1e-3)
            model.objective_bound = lower_bound
        elseif inner.sense == :Max
            @assert isapprox(lower_bound, getobjval(model), rtol=1e-3)
            model.objective_bound = upper_bound
        end
    end
end

getobjbound(m::Union{CouenneNLLinearQuadraticModel, CouenneNLNonlinearModel}) = m.objective_bound
getobjgap(m::Union{CouenneNLLinearQuadraticModel, CouenneNLNonlinearModel}) = abs(getobjval(m) - getobjbound(m)) / abs(getobjval(m))

@forward CouenneNLLinearQuadraticModel.model loadproblem!
@forward CouenneNLLinearQuadraticModel.model getvartype
@forward CouenneNLLinearQuadraticModel.model setvartype!
@forward CouenneNLLinearQuadraticModel.model getsense
@forward CouenneNLLinearQuadraticModel.model setsense!
@forward CouenneNLLinearQuadraticModel.model setwarmstart!
@forward CouenneNLLinearQuadraticModel.model status
@forward CouenneNLLinearQuadraticModel.model getsolution
@forward CouenneNLLinearQuadraticModel.model getobjval
@forward CouenneNLLinearQuadraticModel.model numvar
@forward CouenneNLLinearQuadraticModel.model numconstr
@forward CouenneNLLinearQuadraticModel.model getsolvetime
@forward CouenneNLLinearQuadraticModel.model get_solve_result
@forward CouenneNLLinearQuadraticModel.model get_solve_result_num
@forward CouenneNLLinearQuadraticModel.model get_solve_message
@forward CouenneNLLinearQuadraticModel.model get_solve_exitcode

@forward CouenneNLNonlinearModel.model loadproblem!
@forward CouenneNLNonlinearModel.model getvartype
@forward CouenneNLNonlinearModel.model setvartype!
@forward CouenneNLNonlinearModel.model getsense
@forward CouenneNLNonlinearModel.model setsense!
@forward CouenneNLNonlinearModel.model setwarmstart!
@forward CouenneNLNonlinearModel.model status
@forward CouenneNLNonlinearModel.model getsolution
@forward CouenneNLNonlinearModel.model getobjval
@forward CouenneNLNonlinearModel.model numvar
@forward CouenneNLNonlinearModel.model numconstr
@forward CouenneNLNonlinearModel.model getsolvetime
@forward CouenneNLNonlinearModel.model get_solve_result
@forward CouenneNLNonlinearModel.model get_solve_result_num
@forward CouenneNLNonlinearModel.model get_solve_message
@forward CouenneNLNonlinearModel.model get_solve_exitcode

end # module
