# ----------------------------------------------------------------------------------------------- #
# Julia Matrix Operations Benchmark - Test Suite 0001
# Reference:
#   1. C.
# Remarks:
#   1.  W.
# TODO:
#   1.  A
#   Release Notes:
#   -   2.0.001     14/10/2019  Royi Avital
#       *   Fixed missing `.` before `-` in `mE = exp.(-(mA .^ 2));`.
#   -   2.0.000     13/10/2019  Royi Avital
#       *   Update for compatibility for Julia 1.2.
#   -   1.0.004     12/02/2017  Royi Avital
#       *   Ability to run only some of the tests.
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

function JuliaMatrixBenchmark0001( vTestIdx = [1, 2, 3, 4, 5, 6], vMatrixSize = [2, 5, 10, 20, 50, 100, 200, 300, 500, 750, 1000, 2000, 3000, 4000], numIterations = 7 )

  cRunTimeFunctionsBase = [MatrixGenerationRunTime, MatrixAdditionRunTime, MatrixMultiplicationRunTime,
    MatrixQuadraticFormRunTime, MatrixReductionsRunTime, ElementWiseOperationsRunTime];

  cFunctionStringBase = ["Matrix Generation", "Matrix Addition", "Matrix Multiplication", "Matrix Quadratic Form",
                    "Matrix Reductions", "Element Wise Operations"];

  numTests = length(cRunTimeFunctionsBase);

  cRunTimeFunctions = cRunTimeFunctionsBase[vTestIdx];
  cFunctionString   = cFunctionStringBase[vTestIdx];

  mRunTime = zeros(length(vMatrixSize), length(cRunTimeFunctions), numIterations);

  startTime = time();
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
  endTime = time();
  totalRunTime = endTime - startTime;

  mRunTime = median(mRunTime, dims = 3);
  mRunTime = dropdims(mRunTime, dims = 3);

  println("Finished the Benchmark in $totalRunTime [Sec]");

  return mRunTime;

end

function MatrixGenerationRunTime( matrixSize, mX, mY )

  runTime = @elapsed begin
  mA = randn(matrixSize, matrixSize);
  mB = rand(matrixSize, matrixSize);
  end

  mA = mA .+ mB;

  return mA, runTime;
end

function MatrixAdditionRunTime( matrixSize, mX, mY )

  scalarA = rand();
  scalarB = rand();

  runTime = @elapsed begin
  mA = (scalarA .* mX) .+ (scalarB .* mY);
  end

  return mA, runTime;
end

function MatrixMultiplicationRunTime( matrixSize, mX, mY )

  scalarA = rand();
  scalarB = rand();

  runTime = @elapsed begin
  mA = (scalarA .+ mX) * (scalarB .+ mY);
  end

  return mA, runTime;
end

function MatrixQuadraticFormRunTime( matrixSize, mX, mY )

  vX = randn(matrixSize);
  vB = randn(matrixSize);
  sacalrC = rand();

  runTime = @elapsed begin
  mA = ((mX * vX)' * (mX * vX)) .+ (vB' * vX) .+ sacalrC;
  end

  return mA, runTime;
end

function MatrixReductionsRunTime( matrixSize, mX, mY )

  runTime = @elapsed begin
  mA = sum(mX, dims = 1) .+ minimum(mY, dims = 2); #Broadcasting
  end

  return mA, runTime;
end

function ElementWiseOperationsRunTime( matrixSize, mX, mY )

  mA = rand(matrixSize, matrixSize);
  mB = 3 .+ rand(matrixSize, matrixSize);
  mC = rand(matrixSize, matrixSize);

  runTime = @elapsed begin
  mD = abs.(mA) .+ sin.(mB);
  mE = exp.(.-(mA .^ 2));
  mF = (-mB .+ sqrt.((mB .^ 2) .- (4 .* mA .* mC))) ./ (2 .* mA);
  end

  mA = mD .+ mE .+ mF;

  return mA, runTime;
end
