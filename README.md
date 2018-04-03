# CouenneNL

[![Build Status](https://travis-ci.org/rdeits/CouenneNL.jl.svg?branch=master)](https://travis-ci.org/rdeits/CouenneNL.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/o325a04u65sd2hmk?svg=true)](https://ci.appveyor.com/project/rdeits/couennenl-jl)
[![codecov.io](http://codecov.io/github/rdeits/CouenneNL.jl/coverage.svg?branch=master)](http://codecov.io/github/rdeits/CouenneNL.jl?branch=master)

This package is a very thin wrapper on top of https://github.com/JuliaOpt/AmplNLWriter.jl that automatically downloads an appropriate Couenne solver binary from https://ampl.com/products/solvers/open-source/ . CouenneNL.jl provides the `CouenneNLSolver` type, which is a wrapper around the `AmplNLSolver` from AmplNLWriter.jl.

# Requirements

* Julia v0.6
* Windows, macOS, or Linux

# Installation

```
julia> Pkg.clone("https://github.com/rdeits/CounneNL.jl")

julia> Pkg.build("CouenneNL")
```

# Usage

```julia
using JuMP, CouenneNL

m = Model(solver=CouenneNLSolver())
@variable m -2 <= x <= 2
@variable m -2 <= y <= 2
@NLconstraint m x^2 + y^2 == 1
@NLobjective m Min (x - 0.1)^2 + (y - 0.1)^2
solve(m)
@test getvalue(x) ≈ 1/√2
@test getvalue(y) ≈ 1/√2
```
