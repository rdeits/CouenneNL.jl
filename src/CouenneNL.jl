__precompile__()

module CouenneNL

export CouenneNLSolver

using Lazy: @forward
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

struct CouenneNLMathProgModel <: AbstractMathProgModel
    model::AmplNLMathProgModel
end

struct CouenneNLLinearQuadraticModel <: AbstractLinearQuadraticModel
    model::AmplNLLinearQuadraticModel
end

LinearQuadraticModel(s::CouenneNLSolver) = CouenneNLLinearQuadraticModel(LinearQuadraticModel(s.solver))

struct CouenneNLNonlinearModel <: AbstractNonlinearModel
    model::AmplNLNonlinearModel
end

NonlinearModel(s::CouenneNLSolver) = CouenneNLNonlinearModel(NonlinearModel(s.solver))

@forward CouenneNLSolver.solver getsolvername
@forward CouenneNLNonlinearModel.model loadproblem!
@forward CouenneNLLinearQuadraticModel.model loadproblem!
@forward CouenneNLMathProgModel.model load_A!
@forward CouenneNLMathProgModel.model loadcommon!

@forward CouenneNLMathProgModel.model getvartype
@forward CouenneNLMathProgModel.model setvartype!
@forward CouenneNLMathProgModel.model getsense
@forward CouenneNLMathProgModel.model setsense!
@forward CouenneNLMathProgModel.model setwarmstart!
@forward CouenneNLMathProgModel.model optimize!
@forward CouenneNLMathProgModel.model status
@forward CouenneNLMathProgModel.model getsolution
@forward CouenneNLMathProgModel.model getobjval
@forward CouenneNLMathProgModel.model numvar
@forward CouenneNLMathProgModel.model numconstr
@forward CouenneNLMathProgModel.model getsolvetime
@forward CouenneNLMathProgModel.model get_solve_result
@forward CouenneNLMathProgModel.model get_solve_result_num
@forward CouenneNLMathProgModel.model get_solve_message
@forward CouenneNLMathProgModel.model get_solve_exitcode

@forward CouenneNLLinearQuadraticModel.model getvartype
@forward CouenneNLLinearQuadraticModel.model setvartype!
@forward CouenneNLLinearQuadraticModel.model getsense
@forward CouenneNLLinearQuadraticModel.model setsense!
@forward CouenneNLLinearQuadraticModel.model setwarmstart!
@forward CouenneNLLinearQuadraticModel.model optimize!
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

@forward CouenneNLNonlinearModel.model getvartype
@forward CouenneNLNonlinearModel.model setvartype!
@forward CouenneNLNonlinearModel.model getsense
@forward CouenneNLNonlinearModel.model setsense!
@forward CouenneNLNonlinearModel.model setwarmstart!
@forward CouenneNLNonlinearModel.model optimize!
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
