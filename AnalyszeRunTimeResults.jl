cd(dirname(@__FILE__))
# using Pkg
# Pkg.add("Plots")
# Pkg.add("GR")

using DelimitedFiles
using LinearAlgebra
using Plots
gr()
include("AnalysisJuliaPlotter.jl");
AnalysisJuliaPlotter()
