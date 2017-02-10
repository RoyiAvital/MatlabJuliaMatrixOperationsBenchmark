function [ mRunTime ] = MatlabMatrixBenchmark0002( operationMode )
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

FALSE   = 0;
TRUE    = 1;
OFF     = 0;
ON      = 1;

OPERATION_MODE_PARTIAL  = 1; %<! For Testing (Runs Fast)
OPERATION_MODE_FULL     = 2;

if(exist('operationMode', 'var') == FALSE)
    operationMode = OPERATION_MODE_FULL;
end

cRunTimeFunctions = {@MatrixExpRunTime, @MatrixSqrtRunTime, ...
    @SvdRunTime, @EigRunTime, @CholDecRunTime, @MatInvRunTime};

cFunctionString = {['Matrix Exponential'], ['Matrix Square Root'], ['SVD'], ...
    ['Eigen Decomposition'], ['Cholesky Decomposition'], ['Matrix Inversion']};

if(operationMode == OPERATION_MODE_PARTIAL)
    vMatrixSize = csvread('vMatrixSizePartial.csv');
    numIterations = csvread('numIterationsPartial.csv');
elseif(operationMode == OPERATION_MODE_FULL)
    vMatrixSize = csvread('vMatrixSizeFull.csv');
    numIterations = csvread('numIterationsFull.csv');
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

csvwrite('RunTimeMatlab0002.csv', mRunTime);


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

