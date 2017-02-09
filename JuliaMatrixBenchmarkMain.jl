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

include("JuliaMatrixBenchmark.jl");

OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
OPERATION_MODE_FULL     = 2;

cRunTimeFunctions = [MatrixGenerationRunTime, MatrixAdditionRunTime, MatrixMultiplicationRunTime, MatrixReductionsRunTime,
                      ElementWiseOperationsRunTime, SvdRunTime, EigRunTime, MatInvRunTime, LinearSystemRunTime,
                      LeastSquaresRunTime, CholDecRunTime, CalcDistanceMatrixRunTime];

cFunctionString = ["Matrix Generation", "Matrix Addition", "Matrix Multiplication", "Matrix Reductions",
                  "Element Wise Operations", "SVD", "Eigen Decomposition", "Matrix Inversion",
                  "Linear System Solution", "Linear Least Squares", "Cholesky Decomposition", "Distance Matrix"]

operationMode = OPERATION_MODE_FULL;

if(operationMode == OPERATION_MODE_PARTIAL)
  vMatrixSize = vcat([2, 8, 16, 32, 64], collect(100:100:500));
  numIterations = 1;
elseif(operationMode == OPERATION_MODE_FULL)
  vMatrixSize = [2, 5, 10, 20, 50, 100, 200, 300, 500, 750, 1000, 2000, 3000, 4000];
  numIterations = 5;
end

mRunTime = zeros(length(vMatrixSize), length(cRunTimeFunctions), numIterations);

tic();
for ii = 1:length(vMatrixSize)
  matrixSize = vMatrixSize[ii];
  for jj = 1:length(cRunTimeFunctions)
    println("Processing $(cFunctionString[jj]) Matrix Size $matrixSize");
    for kk = 1:numIterations
      mA, mRunTime[ii, jj, kk] = cRunTimeFunctions[jj](matrixSize);
    end
    println("Finished Processing $(cFunctionString[jj]) Matrix Size $matrixSize");
  end
end
totalRunTime = toc();

mRunTime = median(mRunTime, 3);
mRunTime = squeeze(mRunTime, 3);

println("Finished the Benchmark in $totalRunTime [Sec]");

writecsv("RunTimeJulia.csv", mRunTime);
