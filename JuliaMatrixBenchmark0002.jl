# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark - Test Suite 0002
# Reference:
#   1. C.
# Remarks:
#   1.  W.
# TODO:
#   1.  A
#   Release Notes:
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

function JuliaMatrixBenchmark0002( operationMode = 2 )

  OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
  OPERATION_MODE_FULL     = 2;

  cRunTimeFunctions = [MatrixExpRunTime, MatrixSqrtRunTime, SvdRunTime, EigRunTime,
                      CholDecRunTime, MatInvRunTime];

  cFunctionString = ["Matrix Exponential", "Matrix Square Root", "SVD", "Eigen Decomposition",
                  "Cholesky Decomposition", "Matrix Inversion"]

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
    println("Matrix Size - $matrixSize");
    for jj = 1:length(cRunTimeFunctions)
      println("Processing $(cFunctionString[jj]) Matrix Size $matrixSize");
      for kk = 1:numIterations
        mA, mRunTime[ii, jj, kk] = cRunTimeFunctions[jj](matrixSize, mX);
      end
      println("Finished Processing $(cFunctionString[jj])");
    end
  end
  totalRunTime = toq();

  mRunTime = median(mRunTime, 3);
  mRunTime = squeeze(mRunTime, 3);

  println("Finished the Benchmark in $totalRunTime [Sec]");

  writecsv("RunTimeJulia0002.csv", mRunTime);

  return mRunTime;

end

function MatrixExpRunTime( matrixSize, mX )

  tic();
  mA = expm(mX);
  runTime = toq();

  return mA, runTime;
end

function MatrixSqrtRunTime( matrixSize, mX )

  mY = mX.' * mX;

  tic();
  mA = sqrtm(mY);
  runTime = toq();

  return mA, runTime;
end

function SvdRunTime( matrixSize, mX )

  tic();
  mU, mS, mV = svd(mX, thin = false);
  runTime = toq();

  mA = mU .+ mS .+ mV;

  return mA, runTime;
end

function EigRunTime( matrixSize, mX )

  tic();
  mD, mV = eig(mX);
  runTime = toq();

  mA = mD .+ mV;

  return mA, runTime;
end

function CholDecRunTime( matrixSize, mX )

  mY = mX.' * mX;

  tic();
  mA = chol(mY);
  runTime = toq();

  return mA, runTime;
end

function MatInvRunTime( matrixSize, mX )

    mY = mX.' * mX;

    tic();
    mA = inv(mY);
    mB = pinv(mX);
    runTime = toq();

    mA = mA .+ mB;

  return mA, runTime;
end
