# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark - Test Suite 0001
# Reference:
#   1. C.
# Remarks:
#   1.  This is optimized version of Julia Benchmark.
# TODO:
#   1.  A
#   Release Notes:
#   -   1.0.003     11/02/2017  Royi Avital
#       *   Optimized some operations into loop based calculation.
#   -   1.0.002     10/02/2017  Royi Avital
#       *   Added generation of 'mX' and 'mY' once outside the functions.
#       *   Fixed issue with the Quadratic Form.
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

function JuliaMatrixBenchmarkOpt0001( operationMode = 2 )

  OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
  OPERATION_MODE_FULL     = 2;

  cRunTimeFunctions = [MatrixGenerationRunTime, MatrixAdditionRunTime, MatrixMultiplicationRunTime,
    MatrixQuadraticFormRunTime, MatrixReductionsRunTime, ElementWiseOperationsRunTime];

  cFunctionString = ["Matrix Generation", "Matrix Addition", "Matrix Multiplication", "Matrix Quadratic Form",
                    "Matrix Reductions", "Element Wise Operations"];

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
    mX = randn(matrixSize, matrixSize);
    mY = randn(matrixSize, matrixSize);
    println("Matrix Size - $matrixSize");
    for jj = 1:length(cRunTimeFunctions)
      println("Processing $(cFunctionString[jj]) Matrix Size $matrixSize");
      for kk = 1:numIterations
        mA, mRunTime[ii, jj, kk] = cRunTimeFunctions[jj](matrixSize, mX, mY);
      end
      println("Finished Processing $(cFunctionString[jj])");
    end
  end
  totalRunTime = toq();

  mRunTime = median(mRunTime, 3);
  mRunTime = squeeze(mRunTime, 3);

  println("Finished the Benchmark in $totalRunTime [Sec]");

  writecsv("RunTimeJuliaOpt0001.csv", mRunTime);

  return mRunTime;

end

function MatrixGenerationRunTime( matrixSize, mX, mY )

  tic();
  mA = randn(matrixSize, matrixSize);
  mB = rand(matrixSize, matrixSize);
  runTime = toq();

  mA = mA .+ mB;

  return mA, runTime;
end

function MatrixAdditionRunTime( matrixSize, mX, mY )

  scalarA = rand();
  scalarB = rand();

  tic();
  # mA = (scalarA .* mX) .+ (scalarB .* mY);
  mA = Array(Float64, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mA[ii] = (scalarA * mX[ii]) + (scalarB * mY[ii]);
  end
  runTime = toq();

  return mA, runTime;
end

function MatrixMultiplicationRunTime( matrixSize, mX, mY )

  scalarA = rand();
  scalarB = rand();

  tic();
  # mA = (scalarA .+ mX) * (scalarB .+ mY);
  mA = Array(Float64, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mA[ii] = (scalarA + mX[ii]) * (scalarB + mY[ii]);
  end
  runTime = toq();

  return mA, runTime;
end

function MatrixQuadraticFormRunTime( matrixSize, mX, mY )

  vX = randn(matrixSize);
  vB = randn(matrixSize);
  sacalrC = rand();

  tic();
  mA = ((mX * vX).' * (mX * vX)) .+ (vB.' * vX) .+ sacalrC;
  runTime = toq();

  return mA, runTime;
end

function MatrixReductionsRunTime( matrixSize, mX, mY )

  tic();
  mA = sum(mX, 1) .+ minimum(mY, 2); #Broadcasting
  runTime = toq();

  return mA, runTime;
end

function ElementWiseOperationsRunTime( matrixSize, mX, mY )

  mA = rand(matrixSize, matrixSize);
  mB = 3 .+ rand(matrixSize, matrixSize);
  mC = rand(matrixSize, matrixSize);

  tic();
  # mD = abs.(mA) .+ sin.(mA);
  mD = Array(Float64, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mD[ii] = abs(mA[ii]) + sin(mA[ii]);
  end

  # mE = exp.(-(mA .^ 2));
  mE = Array(Float64, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mE[ii] = exp(- (mA[ii] * mA[ii]));
  end

  # mF = (-mB .+ sqrt.((mB .^ 2) .- (4 .* mA .* mC))) ./ (2 .* mA);
  mF = Array(Float64, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mF[ii] = (-mB[ii] + sqrt( (mB[ii] * mB[ii]) - (4 * mA[ii] * mC[ii]) )) ./ (2 * mA[ii]);
  end
  runTime = toq();

  mA = mD .+ mE .+ mF;

  return mA, runTime;
end
