# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark
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

function JuliaMatrixBenchmark( )

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

  return mRunTime;

end

function MatrixGenerationRunTime( matrixSize )

  tic();
  mA = randn(matrixSize, matrixSize);
  runTime = toq();

  return mA, runTime;
end

function MatrixAdditionRunTime( matrixSize )

  mX = randn(matrixSize, matrixSize)
  mY = randn(matrixSize, matrixSize)
  sacalrA = rand()
  sacalrB = rand()

  mA = similar(mX)
  runTime = @elapsed for i in eachindex(mA)
    mA[i] = (sacalrA * mX[i]) + (sacalrB * mY[i])
  end

  mA, runTime
end

function MatrixMultiplicationRunTime( matrixSize )

  mX = randn(matrixSize, matrixSize)
  mY = randn(matrixSize, matrixSize)
  sacalrA = rand()
  sacalrB = rand()
  
  runTime = @elapsed begin
    for i in eachindex(mX)
      mX[i] += sacalrA
      mY[i] += sacalrB
    end
    mA = mX * mY
  end

  return mA, runTime
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

    mX = randn(matrixSize, matrixSize);
    mY = randn(matrixSize, matrixSize);

    tic();
    mA = sqrt.(abs.(mX)) .+ sin.(mY);
    mB = exp.(-(mA .^ 2));
    runTime = toq();

    mA = mA .+ mB;

  return mA, runTime;
end

function SvdRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);

    tic();
    mU, mS, mV = svd(mX, thin = false);
    runTime = toq();

    mA = mU .+ mS .+ mV;

  return mA, runTime;
end

function EigRunTime( matrixSize )

  mX = randn(matrixSize, matrixSize);

  tic();
  mD, mV = eig(mX);
  runTime = toq();

  mA = mD .+ mV;

  return mA, runTime;
end

function MatInvRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mY = randn(matrixSize, matrixSize);
    mX = mX.' * mX;

    tic();
    mA = inv(mX);
    mB = pinv(mY);
    runTime = toq();

    mA = mA .+ mB;

  return mA, runTime;
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

function CholDecRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mX = mX.' * mX;

    tic();
    mA = chol(mX);
    runTime = toq();

  return mA, runTime;
end

function CalcDistanceMatrixRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mY = randn(matrixSize, matrixSize);

    tic();
    mA = sum(mX .^ 2, 1).' .- (2 .* mX.' .* mY) .+ sum(mY .^ 2, 1);
    runTime = toq();

  return mA, runTime;
end
