__precompile__()

module CouenneNL

export CouenneNLSolver

using Lazy: @forward
using AmplNLWriter
using AmplNLWriter: AmplNLMathProgModel, AmplNLNonlinearModel, AmplNLLinearQuadraticModel
using MathProgBase
using MathProgBase.SolverInterface


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

SolverInterface.LinearQuadraticModel(s::CouenneNLSolver) = CouenneNLLinearQuadraticModel(LinearQuadraticModel(s.solver))

struct CouenneNLNonlinearModel <: AbstractNonlinearModel
    model::AmplNLNonlinearModel
end

SolverInterface.NonlinearModel(s::CouenneNLSolver) = CouenneNLNonlinearModel(NonlinearModel(s.solver))

@forward CouenneNLSolver.solver AmplNLWriter.getsolvername
@forward CouenneNLNonlinearModel.model SolverInterface.loadproblem!
@forward CouenneNLLinearQuadraticModel.model SolverInterface.loadproblem!
@forward CouenneNLMathProgModel.model AmplNLWriter.load_A!
@forward CouenneNLMathProgModel.model AmplNLWriter.loadcommon!

@forward CouenneNLMathProgModel.model SolverInterface.getvartype
@forward CouenneNLMathProgModel.model SolverInterface.setvartype!
@forward CouenneNLMathProgModel.model SolverInterface.getsense
@forward CouenneNLMathProgModel.model SolverInterface.setsense!
@forward CouenneNLMathProgModel.model SolverInterface.setwarmstart!
@forward CouenneNLMathProgModel.model SolverInterface.optimize!
@forward CouenneNLMathProgModel.model SolverInterface.status
@forward CouenneNLMathProgModel.model SolverInterface.getsolution
@forward CouenneNLMathProgModel.model SolverInterface.getobjval
@forward CouenneNLMathProgModel.model SolverInterface.numvar
@forward CouenneNLMathProgModel.model SolverInterface.numconstr
@forward CouenneNLMathProgModel.model SolverInterface.getsolvetime
@forward CouenneNLMathProgModel.model AmplNLWriter.get_solve_result
@forward CouenneNLMathProgModel.model AmplNLWriter.get_solve_result_num
@forward CouenneNLMathProgModel.model AmplNLWriter.get_solve_message
@forward CouenneNLMathProgModel.model AmplNLWriter.get_solve_exitcode

@forward CouenneNLLinearQuadraticModel.model SolverInterface.getvartype
@forward CouenneNLLinearQuadraticModel.model SolverInterface.setvartype!
@forward CouenneNLLinearQuadraticModel.model SolverInterface.getsense
@forward CouenneNLLinearQuadraticModel.model SolverInterface.setsense!
@forward CouenneNLLinearQuadraticModel.model SolverInterface.setwarmstart!
@forward CouenneNLLinearQuadraticModel.model SolverInterface.optimize!
@forward CouenneNLLinearQuadraticModel.model SolverInterface.status
@forward CouenneNLLinearQuadraticModel.model SolverInterface.getsolution
@forward CouenneNLLinearQuadraticModel.model SolverInterface.getobjval
@forward CouenneNLLinearQuadraticModel.model SolverInterface.numvar
@forward CouenneNLLinearQuadraticModel.model SolverInterface.numconstr
@forward CouenneNLLinearQuadraticModel.model SolverInterface.getsolvetime
@forward CouenneNLLinearQuadraticModel.model AmplNLWriter.get_solve_result
@forward CouenneNLLinearQuadraticModel.model AmplNLWriter.get_solve_result_num
@forward CouenneNLLinearQuadraticModel.model AmplNLWriter.get_solve_message
@forward CouenneNLLinearQuadraticModel.model AmplNLWriter.get_solve_exitcode

@forward CouenneNLNonlinearModel.model SolverInterface.getvartype
@forward CouenneNLNonlinearModel.model SolverInterface.setvartype!
@forward CouenneNLNonlinearModel.model SolverInterface.getsense
@forward CouenneNLNonlinearModel.model SolverInterface.setsense!
@forward CouenneNLNonlinearModel.model SolverInterface.setwarmstart!
@forward CouenneNLNonlinearModel.model SolverInterface.optimize!
@forward CouenneNLNonlinearModel.model SolverInterface.status
@forward CouenneNLNonlinearModel.model SolverInterface.getsolution
@forward CouenneNLNonlinearModel.model SolverInterface.getobjval
@forward CouenneNLNonlinearModel.model SolverInterface.numvar
@forward CouenneNLNonlinearModel.model SolverInterface.numconstr
@forward CouenneNLNonlinearModel.model SolverInterface.getsolvetime
@forward CouenneNLNonlinearModel.model AmplNLWriter.get_solve_result
@forward CouenneNLNonlinearModel.model AmplNLWriter.get_solve_result_num
@forward CouenneNLNonlinearModel.model AmplNLWriter.get_solve_message
@forward CouenneNLNonlinearModel.model AmplNLWriter.get_solve_exitcode

end # module
