function [ mRunTime ] = MatlabMatrixBenchmark0003( operationMode )
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

cRunTimeFunctions = {@LinearSystemRunTime, @LeastSquaresRunTime, @CalcDistanceMatrixRunTime};

cFunctionString = {['Linear System Solution'], ['Linear Least Squares'], ['Squared Distance Matrix']};

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

csvwrite('RunTimeMatlab0003.csv', mRunTime);


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

