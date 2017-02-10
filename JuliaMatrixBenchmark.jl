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

function JuliaMatrixBenchmark( )

  OPERATION_MODE_PARTIAL  = 1; # For Testing (Runs Fast)
  OPERATION_MODE_FULL     = 2;

  cRunTimeFunctions = [MatrixGenerationRunTime, MatrixAdditionRunTime, MatrixMultiplicationRunTime,
    MatrixQuadraticFormRunTime, MatrixReductionsRunTime, MatrixExpRunTime, MatrixSqrtRunTime, ElementWiseOperationsRunTime,
    SvdRunTime, EigRunTime, CholDecRunTime, MatInvRunTime,
    LinearSystemRunTime, LeastSquaresRunTime, CalcDistanceMatrixRunTime];

  cFunctionString = ["Matrix Generation", "Matrix Addition", "Matrix Multiplication", "Matrix Quadratic Form", "Matrix Reductions",
                  "Matrix Exponential", "Matrix Squared Root", "Element Wise Operations", "SVD", "Eigen Decomposition",
                  "Cholesky Decomposition", "Matrix Inversion", "Linear System Solution", "Linear Least Squares", "Squared Distance Matrix"]

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
  mB = rand(matrixSize, matrixSize);
  runTime = toq();

  mA = mA .+ mB;

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

function MatrixExpRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);

    tic();
    mA = expm(mX);
    runTime = toq();

  return mA, runTime;
end

function MatrixSqrtRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mX = mX.' * mX;

    tic();
    mA = sqrtm(mX);
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

function CholDecRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mX = mX.' * mX;

    tic();
    mA = chol(mX);
    runTime = toq();

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

function CalcDistanceMatrixRunTime( matrixSize )

    mX = randn(matrixSize, matrixSize);
    mY = randn(matrixSize, matrixSize);

    tic();
    mA = sum(mX .^ 2, 1).' .- (2 .* mX.' * mY) .+ sum(mY .^ 2, 1);
    runTime = toq();

  return mA, runTime;
end
