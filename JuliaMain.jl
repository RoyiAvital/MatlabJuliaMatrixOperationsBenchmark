cd(dirname(@__FILE__))
clearconsole();

# ]add BenchmarkTools
# ]add MAT
using BenchmarkTools # for benchmark
const BenchmarkTools.DEFAULT_PARAMETERS.samples = 700;
const BenchmarkTools.DEFAULT_PARAMETERS.evals = 1;
using DelimitedFiles # for readdlm, writedlm
using Statistics # for median
using LinearAlgebra # for eigen, pinv, svd, cholesky
using Random # for randperm
using MAT

const operationMode = 2; # 0 for test only # 1 for partial benchmark # 2 for full benchmark

# Julia
include("JuliaBench.jl");
tRunTime, mRunTime= JuliaBench(operationMode);
# Main RunTime Table write
writedlm("RunTimeData\\RunTimeJulia$(BLAS.vendor())Table.csv", tRunTime,',');
# RunTime save
file = matopen("RunTimeData\\RunTimeJulia$(BLAS.vendor()).mat", "w")
write(file, "mRunTime", mRunTime)
close(file)

# Julia SIMD
include("JuliaBenchSIMD.jl")
tRunTime, mRunTime= JuliaBenchSIMD(operationMode);
# Main RunTime Table write
writedlm("RunTimeData\\RunTimeJulia$(BLAS.vendor())SIMDTable.csv", tRunTime,',');
# RunTime save
file = matopen("RunTimeData\\RunTimeJulia$(BLAS.vendor())SIMD.mat", "w")
write(file, "mRunTime", mRunTime)
close(file)

# # Debug and performance trace
# include("JuliaBench.jl");
# matrixSize = 20;
# mX = randn(matrixSize, matrixSize);
# mY = randn(matrixSize, matrixSize);
# allFunctions = [MatrixGeneration, MatrixAddition, MatrixMultiplication, MatrixQuadraticForm, MatrixReductions, ElementWiseOperations, MatrixExp, MatrixSqrt, Svd, Eig, CholDec, MatInv, LinearSystem, LeastSquares, CalcDistanceMatrix, KMeans];
# # debug the code
# # Juno.@enter allFunctions[2](matrixSize, mX, mY) # copy paste to REPL
# # timing and memory
# @time allFunctions[2](matrixSize, mX, mY)
# # bad practices used in coding
# # Juno.@trace allFunctions[1](matrixSize, mX, mY)
# # profiles the code
# # using Profile
# # Profile.clear();
# # @profile allFunctions[2](matrixSize, mX, mY)
# # Profile.print(combine = true)
# # profiletree=Juno.profiletree()
# # Juno.profiler()
# # advanced tool for diagnosing type-related problems
# # @code_warntype allFunctions[2](matrixSize, mX, mY)
