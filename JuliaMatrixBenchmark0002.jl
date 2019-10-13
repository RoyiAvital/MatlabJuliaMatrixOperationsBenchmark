# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark - Test Suite 0002
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
#   -   1.0.001     09/02/2017  Royi Avital
#       *   Added 'MatrixExpRunTime()' and 'MatrixSqrtRunTime()'.
#       *   Added Quadratic Matrix Form Calculation 'MatrixQuadraticFormRunTime()'.
#       *   Added Univariate Quadratic Function Root to 'ElementWiseOperationsRunTime()'.
#       *   Updated 'MatrixGenerationRunTime()' to include Uniform Random Number Generation.
#       *   Fixed issue with 'CalcDistanceMatrixRunTime'.
#   -   1.0.000     09/02/2017  Royi Avital
#       *   First release version.
# ----------------------------------------------------------------------------------------------- #

function JuliaMatrixBenchmark0002( vTestIdx = [1, 2, 3, 4, 5, 6], vMatrixSize = [2, 5, 10, 20, 50, 100, 200, 300, 500, 750, 1000, 2000, 3000, 4000], numIterations = 7 )

  cRunTimeFunctionsBase = [MatrixExpRunTime, MatrixSqrtRunTime, SvdRunTime, EigRunTime,
                      CholDecRunTime, MatInvRunTime];

  cFunctionStringBase = ["Matrix Exponential", "Matrix Square Root", "SVD", "Eigen Decomposition",
                  "Cholesky Decomposition", "Matrix Inversion"]

  numTests = length(cRunTimeFunctionsBase);

  cRunTimeFunctions = cRunTimeFunctionsBase[vTestIdx];
  cFunctionString   = cFunctionStringBase[vTestIdx];

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

function MatrixExpRunTime( matrixSize, mX )

  runTime = @elapsed begin
  mA = exp(mX);
  end

  return mA, runTime;
end

function MatrixSqrtRunTime( matrixSize, mX )

  mY = mX' * mX;

  runTime = @elapsed begin
  mA = sqrt(mY);
  end

  return mA, runTime;
end

function SvdRunTime( matrixSize, mX )

  runTime = @elapsed begin
  mU, vS, mV = svd(mX, full = true);
  mS = diagm(vS);
  end

  mA = mU .+ mS .+ mV;

  return mA, runTime;
end

function EigRunTime( matrixSize, mX )

  runTime = @elapsed begin
  vD, mV = eigen(mX);
  mD = diagm(vD); # MATLAB allocates Matrix
  end

  mA = mD .+ mV;

  return mA, runTime;
end

function CholDecRunTime( matrixSize, mX )

  mY = mX' * mX;

  runTime = @elapsed begin
  mA = cholesky(mY);
  end

  return mA, runTime;
end

function MatInvRunTime( matrixSize, mX )

    mY = mX' * mX;

    runTime = @elapsed begin
    mA = inv(mY);
    mB = pinv(mX);
    end

    mA = mA .+ mB;

  return mA, runTime;
end
