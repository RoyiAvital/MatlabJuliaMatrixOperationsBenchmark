function [ mRunTime ] = MatlabMatrixBenchmark(  )
% ----------------------------------------------------------------------------------------------- %
% MATLAB Matrix Operations Benchmark
% Reference:
%   1. C.
% Remarks:
%   1.  W.
% TODO:
%   1.  A
%   Release Notes:
%   -   1.0.001     09/02/2017  Royi Avital
%       *   Added 'MatrixExpRunTime()' and 'MatrixSqrtRunTime()'.
%       *   Added Quadratic Matrix Form Calculation 'MatrixQuadraticFormRunTime()'.
%       *   Added Univariate Quadratic Function Root to 'ElementWiseOperationsRunTime()'.
%       *   Updated 'MatrixGenerationRunTime()' to include Uniform Random Number Generation.
%       *   Fixed issue with 'CalcDistanceMatrixRunTime'.
%   -   1.0.000     09/02/2017  Royi Avital
%       *   First release version.
% ----------------------------------------------------------------------------------------------- %

OPERATION_MODE_PARTIAL  = 1; %<! For Testing (Runs Fast)
OPERATION_MODE_FULL     = 2;

% Disable multithreading
maxNumCompThreads(1)

cRunTimeFunctions = {@MatrixGenerationRunTime, @MatrixAdditionRunTime, @MatrixMultiplicationRunTime, ...
    @MatrixQuadraticFormRunTime, @MatrixReductionsRunTime, @MatrixExpRunTime, @MatrixSqrtRunTime, @ElementWiseOperationsRunTime, ...
    @SvdRunTime, @EigRunTime, @CholDecRunTime, @MatInvRunTime, ...
    @LinearSystemRunTime, @LeastSquaresRunTime, @CalcDistanceMatrixRunTime};

cFunctionString = {['Matrix Generation'], ['Matrix Addition'], ['Matrix Multiplication'], ['Matrix Quadratic Form'], ['Matrix Reductions'], ...
    ['Matrix Exponential'], ['Matrix Squared Root'], ['Element Wise Operations'], ['SVD'], ['Eigen Decomposition'], ['Cholesky Decomposition'], ...
    ['Matrix Inversion'], ['Linear System Solution'], ['Linear Least Squares'], ['Squared Distance Matrix']};

operationMode = OPERATION_MODE_FULL;

if(operationMode == OPERATION_MODE_PARTIAL)
    vMatrixSize = [2, 8, 16, 32, 64, 100:100:500];
    numIterations = 1;
elseif(operationMode == OPERATION_MODE_FULL)
    vMatrixSize = [2, 5, 10, 20, 50, 100, 200, 300, 500, 750, 1000, 2000, 3000, 4000];
    numIterations = 5;
end

mRunTime = zeros(length(vMatrixSize), length(cRunTimeFunctions), numIterations);

hTotelRunTimer = tic();
for ii = 1:length(vMatrixSize)
    matrixSize = vMatrixSize(ii);
    disp(['Matrix Size - ', num2str(matrixSize)]);
    for jj = 1:length(cRunTimeFunctions)
        disp(['Processing ', num2str(cFunctionString{jj}), ' Matrix Size ', num2str(matrixSize)]);
        for kk = 1:numIterations
            [mA, mRunTime(ii, jj, kk)] = cRunTimeFunctions{jj}(matrixSize);
        end
        disp(['Finished Processing ', num2str(cFunctionString{jj})]);
    end
end
totalRunTime = toc(hTotelRunTimer);

mRunTime = median(mRunTime, 3);

disp(['Finished the Benchmark in ', num2str(totalRunTime), ' [Sec]']);

csvwrite('RunTimeMatlab.csv', mRunTime);


end


function [ mA, runTime ] = MatrixGenerationRunTime( matrixSize )

tic();
mA = randn(matrixSize, matrixSize);
mB = rand(matrixSize, matrixSize);
runTime = toc();

mA = mA + mB;


end

function [ mA, runTime ] = MatrixAdditionRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mY = randn(matrixSize, matrixSize);
scalarA = rand(1);
scalarB = rand(1);

tic();
mA = (scalarA .* mX) + (scalarB .* mY);
runTime = toc();


end

function [ mA, runTime ] = MatrixMultiplicationRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mY = randn(matrixSize, matrixSize);
sacalrA = rand(1);
sacalrB = rand(1);

tic();
mA = (sacalrA + mX) * (sacalrB + mY);
runTime = toc();


end

function [ mA, runTime ] = MatrixQuadraticFormRunTime( matrixSize )

mA = randn(matrixSize, matrixSize);
vX = randn(matrixSize, 1);
vB = randn(matrixSize, 1);
sacalrC = rand(1);

tic();
mA = (vX.' * mA * vX) + (vB.' * vX) + sacalrC;
runTime = toc();


end

function [ mA, runTime ] = MatrixReductionsRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mY = randn(matrixSize, matrixSize);

tic();
mA = sum(mX, 1) + min(mY, [], 2);
runTime = toc();


end

function [ mA, runTime ] = MatrixExpRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);

tic();
mA = expm(mX);
runTime = toc();


end

function [ mA, runTime ] = MatrixSqrtRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mX = mX.' * mX;

tic();
mA = sqrtm(mX);
runTime = toc();


end

function [ mA, runTime ] = ElementWiseOperationsRunTime( matrixSize )

mA = rand(matrixSize, matrixSize);
mB = 3 + rand(matrixSize, matrixSize);
mC = rand(matrixSize, matrixSize);

tic();
mD = abs(mA) + sin(mB);
mE = exp(-(mA .^ 2));
mF = (-mB + sqrt((mB .^ 2) - (4 .* mA .* mC))) ./ (2 .* mA);
runTime = toc();

mA = mD + mE + mF;


end

function [ mA, runTime ] = SvdRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);

tic();
[mU, mS, mV] = svd(mX);
runTime = toc();

mA = mU + mS + mV;


end

function [ mA, runTime ] = EigRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);

tic();
[mD, mV] = eig(mX);
runTime = toc();

mA = mD + mV;


end

function [ mA, runTime ] = CholDecRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mX = mX.' * mX;

tic();
mA = chol(mX);
runTime = toc();

  
end

function [ mA, runTime ] = MatInvRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mY = randn(matrixSize, matrixSize);
mX = mX.' * mX;

tic();
mA = inv(mX);
mB = pinv(mY);
runTime = toc();

mA = mA + mB;


end

function [ mA, runTime ] = LinearSystemRunTime( matrixSize )

mA = randn(matrixSize, matrixSize);
mB = randn(matrixSize, matrixSize);
vB = randn(matrixSize, 1);

tic();
vX = mA \ vB;
mX = mA \ mB;
runTime = toc();

mA = mX + vX;


end

function [ mA, runTime ] = LeastSquaresRunTime( matrixSize )

mA = randn(matrixSize, matrixSize);
mB = randn(matrixSize, matrixSize);
vB = randn(matrixSize, 1);

tic();
vX = (mA.' * mA) \ (mA.' * vB);
mX = (mA.' * mA) \ (mA.' * mB);
runTime = toc();

mA = mX + vX;


end

function [ mA, runTime ] = CalcDistanceMatrixRunTime( matrixSize )

mX = randn(matrixSize, matrixSize);
mY = randn(matrixSize, matrixSize);

tic();
mA = sum(mX .^ 2, 1).' - (2 .* mX.' * mY) + sum(mY .^ 2, 1);
runTime = toc();
  
  
end


