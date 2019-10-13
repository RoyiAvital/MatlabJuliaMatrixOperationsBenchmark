# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark - Test Suite 0003
# Reference:
#   1. C.
# Remarks:
#   1.  W.
# TODO:
#   1.  A
#   Release Notes:
#   -   2.0.000     13/10/2019  Royi Avital
#       *   Update for compatibility for Julia 1.2.
#   -   1.0.004     12/02/2017  Royi Avital
#       *   Ability to run only some of the tests.
#   -   1.0.002     10/02/2017  Royi Avital
#       *   Added generation of 'mX' once outside the functions.
#       *   Optimized creation of scalars and vectors.
#   -   1.0.001     09/02/2017  Royi Avital
#       *   Added 'MatrixExpRunTime()' and 'MatrixSqrtRunTime()'.
#       *   Added Quadratic Matrix Form Calculation 'MatrixQuadraticFormRunTime()'.
#       *   Added Univariate Quadratic Function Root to 'ElementWiseOperationsRunTime()'.
#       *   Updated 'MatrixGenerationRunTime()' to include Uniform Random Number Generation.
#       *   Fixed issue with 'CalcDistanceMatrixRunTime'.
#   -   1.0.000     09/02/2017  Royi Avital
#       *   First release version.
# ----------------------------------------------------------------------------------------------- #

function JuliaMatrixBenchmark0003( vTestIdx = [1, 2, 3, 4, 5, 6], vMatrixSize = [2, 5, 10, 20, 50, 100, 200, 300, 500, 750, 1000, 2000, 3000, 4000], numIterations = 7 )

  cRunTimeFunctionsBase = [LinearSystemRunTime, LeastSquaresRunTime, CalcDistanceMatrixRunTime, KMeansRunTime];

  cFunctionStringBase = ["Linear System Solution", "Linear Least Squares", "Squared Distance Matrix", "K-Means"]

  numTests = length(cRunTimeFunctionsBase);

  vTestIdx = vTestIdx[1:numTests];

  cRunTimeFunctions = cRunTimeFunctionsBase[vTestIdx];
  cFunctionString   = cFunctionStringBase[vTestIdx];

  numIterations = numIterations[1]; # It is 1x1 Array -> Scalar

  mRunTime = zeros(length(vMatrixSize), length(cRunTimeFunctions), numIterations);

  startTime = time();
  for ii = 1:length(vMatrixSize)
    matrixSize = vMatrixSize[ii];
    mX = randn(matrixSize, matrixSize);
    println("Matrix Size - $matrixSize");
    for jj = 1:length(cRunTimeFunctions)
      println("Processing $(cFunctionString[jj]) Matrix Size $matrixSize");
      for kk = 1:numIterations
        mA, mRunTime[ii, jj, kk] = cRunTimeFunctions[jj](matrixSize, mX);
      end
      println("Finished Processing $(cFunctionString[jj])");
    end
  end
  endTime = time();
  totalRunTime = endTime - startTime;

  mRunTime = median(mRunTime, dims = 3);
  mRunTime = dropdims(mRunTime, dims = 3);

  println("Finished the Benchmark in $totalRunTime [Sec]");

  return mRunTime;

end

function LinearSystemRunTime( matrixSize, mX )

  mB = randn(matrixSize, matrixSize);
  vB = randn(matrixSize);

  runTime = @elapsed begin
  vA = mX \ vB;
  mA = mX \ mB;
  end

  mA = mA .+ vA;

  return mA, runTime;
end

function LeastSquaresRunTime( matrixSize, mX )

  mB = randn(matrixSize, matrixSize);
  vB = randn(matrixSize);

  runTime = @elapsed begin
  vA = (mX' * mX) \ (mX' * vB);
  mA = (mX' * mX) \ (mX' * mB);
  end

  mA = mA .+ vA;

  return mA, runTime;
end

function CalcDistanceMatrixRunTime( matrixSize, mX )

  mY = randn(matrixSize, matrixSize);

  runTime = @elapsed begin
  mA = sum(mX .^ 2, dims = 1)' .- (2 .* mX' * mY) .+ sum(mY .^ 2, dims = 1);
  end

  return mA, runTime;
end

function KMeansRunTime( matrixSize, mX )

  # Assuming Samples are slong Columns (Rows are features)
  numClusters     = Int64(max(round(matrixSize / 100), 1));
  vClusterId      = zeros(matrixSize);
  numIterations   = 10;

  runTime = @elapsed begin
  # http://stackoverflow.com/questions/36047516/julia-generating-unique-random-integer-array
  mA          = mX[:, randperm(matrixSize)[1:numClusters]]; #<! Cluster Centroids

  for ii = 1:numIterations
    vClusterId[:] = map(ii -> ii[2], argmin(sum(mA .^ 2, dims = 1)' .- (2 .* mA' * mX), dims = 1)); #<! Is there a `~` equivalent in Julia?
    for jj = 1:numClusters
      mA[:, jj] = sum(mX[:, vClusterId .== jj], dims = 2) ./ sum(vClusterId .== jj);
    end
  end

  end

  mA = mA[:, 1] .+ mA[:, end]';

  return mA, runTime;
end
