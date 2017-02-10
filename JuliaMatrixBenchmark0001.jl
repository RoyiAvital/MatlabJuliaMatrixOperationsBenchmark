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

function JuliaMatrixBenchmark0001( operationMode = 2 )

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

  print("C");

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

  writecsv("RunTimeJulia0001.csv", mRunTime);

  return mRunTime;

end

function MatrixGenerationRunTime( matrixSize )

  tic();
  mA = randn(matrixSize, matrixSize);
  mB = rand(matrixSize, matrixSize);
  runTime = toq();

  mA = mA .+ mB;

  return mA, runTime;
end

function MatrixAdditionRunTime( matrixSize )

  mX = randn(matrixSize, matrixSize);
  mY = randn(matrixSize, matrixSize);
  sacalrA = rand(1);
  sacalrB = rand(1);

  tic();
  mA = (sacalrA .* mX) .+ (sacalrB .* mY);
  runTime = toq();

  return mA, runTime;
end

function MatrixMultiplicationRunTime( matrixSize )

  mX = randn(matrixSize, matrixSize);
  mY = randn(matrixSize, matrixSize);
  sacalrA = rand(1);
  sacalrB = rand(1);

  tic();
  mA = (sacalrA .+ mX) * (sacalrB .+ mY);
  runTime = toq();

  return mA, runTime;
end

function MatrixQuadraticFormRunTime( matrixSize )

  mA = randn(matrixSize, matrixSize);
  vX = randn(matrixSize, 1);
  vB = randn(matrixSize, 1);
  sacalrC = rand(1);

  tic();
  mA = (vX.' * mA * vX) .+ (vB.' * vX) .+ sacalrC;
  runTime = toq();

  return mA, runTime;
end

function MatrixReductionsRunTime( matrixSize )

  mX = randn(matrixSize, matrixSize);
  mY = randn(matrixSize, matrixSize);

  tic();
  mA = sum(mX, 1) .+ minimum(mY, 2); #Broadcasting
  runTime = toq();

  return mA, runTime;
end

function ElementWiseOperationsRunTime( matrixSize )

  mA = rand(matrixSize, matrixSize);
  mB = 3 .+ rand(matrixSize, matrixSize);
  mC = rand(matrixSize, matrixSize);

  tic();
  mD = abs.(mA) .+ sin.(mB);
  mE = exp.(-(mA .^ 2));
  mF = (-mB .+ sqrt.((mB .^ 2) .- (4 .* mA .* mC))) ./ (2 .* mA);
  runTime = toq();

  mA = mD .+ mE .+ mF;

  return mA, runTime;
end
