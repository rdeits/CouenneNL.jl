using CouenneNL
using JuMP
using Test

@testset "CouenneNL" begin
    @testset "installation" begin
        @test isfile(CouenneNL.couenne_executable)
        run(`$(CouenneNL.couenne_executable) --version`)
    end

    @testset "linear models" begin
        @testset "one variable" begin
            m = Model(solver=CouenneNLSolver())
            @variable m -1 <= x <= 1
            @objective m Min x
            solve(m)
            @test getvalue(x) ≈ -1
        end

        @testset "two variables" begin
            m = Model(solver=CouenneNLSolver())
            @variable m -1 <= x <= 1
            @variable m -1 <= y <= 1
            @constraint m x >= -0.5
            @constraint m y >= 0.1
            @objective m Min x + y
            solve(m)
            @test getvalue(x) ≈ -0.5
            @test getvalue(y) ≈ 0.1
        end
    end

    @testset "nonlinear models" begin
        @testset "convex quadratic constraint" begin
            m = Model(solver=CouenneNLSolver())
            @variable m -1 <= x <= 1
            @variable m -1 <= y <= 1
            @constraint m x >= -0.5
            @constraint m y >= 0.1
            @variable m z
            @NLconstraint m (x - -0.5)^2 + (y - -0.2)^2 <= z
            @objective m Min z
            solve(m)
            @test getvalue(x) ≈ -0.5 atol=1e-4
            @test getvalue(y) ≈ 0.1 atol=1e-4
        end

        @testset "nonconvex constraint" begin
            m = Model(solver=CouenneNLSolver())
            @variable m -2 <= x <= 2
            @variable m -2 <= y <= 2
            @NLconstraint m x^2 + y^2 == 1
            @NLobjective m Min (x - 0.1)^2 + (y - 0.1)^2
            solve(m)
            @test getvalue(x) ≈ 1/√2
            @test getvalue(y) ≈ 1/√2
        end
    end
end


