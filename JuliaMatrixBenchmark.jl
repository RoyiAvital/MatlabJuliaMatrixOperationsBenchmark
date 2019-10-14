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
using LinearAlgebra;
using Statistics;
using Random;
using DelimitedFiles;

numPhysicalCpu = 6; # Should be updated per system
LinearAlgebra.BLAS.set_num_threads(numPhysicalCpu);
libBlasString = LinearAlgebra.BLAS.vendor();

RUN_TIME_DATA_FOLDER = "RunTimeData";
if(occursin("mkl", "$libBlasString"))
    cRunTimeFileName = ["RunTimeJulia0001MKL.csv", "RunTimeJulia0002MKL.csv", "RunTimeJulia0003MKL.csv"];
else
    cRunTimeFileName = ["RunTimeJulia0001.csv", "RunTimeJulia0002.csv", "RunTimeJulia0003.csv"];
end

  include("JuliaMatrixBenchmark0001.jl");
  include("JuliaMatrixBenchmark0002.jl");
  include("JuliaMatrixBenchmark0003.jl");

  OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
  OPERATION_MODE_FULL     = 2;

  cBenchmarks = [JuliaMatrixBenchmark0001, JuliaMatrixBenchmark0002, JuliaMatrixBenchmark0003]

  # User Settings
  vTestFlag = [1, 0, 0] .== 1; #<! 1 to run the i-th test
  operationMode = OPERATION_MODE_FULL;
  vTestIdx = [1, 2, 3, 4, 5, 6];
  # vMatrixSize = [2, 5, 10, 20, 50, 100, 200, 300, 500, 750, 1000, 2000, 3000, 4000];
  # numIterations = 7;

  if(operationMode == OPERATION_MODE_PARTIAL)
    vMatrixSize = dropdims(readdlm("vMatrixSizePartial.csv", ',', Int64), dims = 1);
    numIterations = dropdims(readdlm("numIterationsPartial.csv", ',', Int64), dims = 1);
  elseif(operationMode == OPERATION_MODE_FULL)
    vMatrixSize = dropdims(readdlm("vMatrixSizeFull.csv", ',', Int64), dims = 1);
    numIterations = dropdims(readdlm("numIterationsFull.csv", ',', Int64), dims = 1);
  end
  numIterations = numIterations[1]; # It is 1x1 Array -> Scalar

  # vMatrixSize = [2, 5, 10, 20, 50, 100];

  for testIdx in eachindex(cBenchmarks)
      if(vTestFlag[testIdx])
          mRunTime = cBenchmarks[testIdx](vTestIdx, vMatrixSize, numIterations);
          if(operationMode == OPERATION_MODE_FULL)
            runTimeFilePath = joinpath(RUN_TIME_DATA_FOLDER, cRunTimeFileName[testIdx]);
            writedlm(runTimeFilePath, mRunTime, ',');
          end
      end
  end

  # testIdx = 1;
  # mRunTime = JuliaMatrixBenchmark0001(vTestIdx, vMatrixSize, numIterations);
  # testIdx = 2;
  # mRunTime = JuliaMatrixBenchmark0002(vTestIdx, vMatrixSize, numIterations);
  # testIdx = 3;
  # mRunTime = JuliaMatrixBenchmark0003(vTestIdx, vMatrixSize, numIterations);
  #
  #
  # if(operationMode == OPERATION_MODE_FULL)
  #   runTimeFilePath = joinpath(RUN_TIME_DATA_FOLDER, cRunTimeFileName[testIdx]);
  #   writedlm(runTimeFilePath, mRunTime, ',');
  # end
