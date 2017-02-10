# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark (Main)
# Reference:
#   1. C.
# Remarks:
#   1.  W.
# TODO:
#   1.  A
#   Release Notes:
#   -   1.0.000     09/02/2017  Royi Avital
#       *   First release version.
# ----------------------------------------------------------------------------------------------- #

  include("JuliaMatrixBenchmark0001.jl");
  include("JuliaMatrixBenchmark0002.jl");
  include("JuliaMatrixBenchmark0003.jl");

  OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
  OPERATION_MODE_FULL     = 2;

  operationMode = 2;

  mRunTime = JuliaMatrixBenchmark0001(operationMode);
  mRunTime = JuliaMatrixBenchmark0002(operationMode);
  mRunTime = JuliaMatrixBenchmark0003(operationMode);
