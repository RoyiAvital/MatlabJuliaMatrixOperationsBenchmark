# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark
# Reference:
#   1. C.
# Remarks:
#   1.  W.
# TODO:
#   1.  A
#   Release Notes:
#   -   1.0.001     09/02/2017  Royi Avital
#       *   Added 'MatrixExpRunTime()' and 'MatrixSqrtRunTime()'.
#       *   Added Quadratic Matrix Form Calculation 'MatrixQuadraticFormRunTime()'.
#       *   Added Univariate Quadratic Function Root to 'ElementWiseOperationsRunTime()'.
#       *   Updated 'MatrixGenerationRunTime()' to include Uniform Random Number Generation.
#       *   Fixed issue with 'CalcDistanceMatrixRunTime'.
#   -   1.0.000     09/02/2017  Royi Avital
#       *   First release version.
# ----------------------------------------------------------------------------------------------- #

function JuliaMatrixBenchmark0003( operationMode = 2 )

  OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
  OPERATION_MODE_FULL     = 2;

  cRunTimeFunctions = [LinearSystemRunTime, LeastSquaresRunTime, CalcDistanceMatrixRunTime];

  cFunctionString = ["Linear System Solution", "Linear Least Squares", "Squared Distance Matrix"]

  if(operationMode == OPERATION_MODE_PARTIAL)
    vMatrixSize = round(Int64, squeeze(readcsv("vMatrixSizePartial.csv"), 1));
    numIterations = round(Int64, squeeze(readcsv("numIterationsPartial.csv"), 1));
  elseif(operationMode == OPERATION_MODE_FULL)
    vMatrixSize = round(Int64, squeeze(readcsv("vMatrixSizeFull.csv"), 1));
    numIterations = round(Int64, squeeze(readcsv("numIterationsFull.csv"), 1));
  end

  numIterations = numIterations[1]; # It is 1x1 Array -> Scalar

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

  writecsv("RunTimeJulia0003.csv", mRunTime);

  return mRunTime;

end

function LinearSystemRunTime( matrixSize )

    mA = randn(matrixSize, matrixSize);
    mB = randn(matrixSize, matrixSize);
    vB = randn(matrixSize, 1);

    tic();
    vX = mA \ vB;
    mX = mA \ mB;
    runTime = toq();

    mA = mX .+ vX;

  return mA, runTime;
end

function LeastSquaresRunTime( matrixSize )

    mA = randn(matrixSize, matrixSize);
    mB = randn(matrixSize, matrixSize);
    vB = randn(matrixSize, 1);

    tic();
    vX = (mA.' * mA) \ (mA.' * vB);
    mX = (mA.' * mA) \ (mA.' * mB);
    runTime = toq();

    mA = mX .+ vX;

  return mA, runTime;
end

function CalcDistanceMatrixRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mY = randn(matrixSize, matrixSize);

    tic();
    mA = sum(mX .^ 2, 1).' .- (2 .* mX.' * mY) .+ sum(mY .^ 2, 1);
    runTime = toq();

  return mA, runTime;
end
