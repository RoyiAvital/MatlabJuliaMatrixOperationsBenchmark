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

function MatrixGenerationRunTime( matrixSize )

  tic();
  mA = randn(matrixSize, matrixSize);
  runTime = toq();

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
