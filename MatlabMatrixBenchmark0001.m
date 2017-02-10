function [ mRunTime ] = MatlabMatrixBenchmark0001( operationMode )
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

cRunTimeFunctions = {@MatrixGenerationRunTime, @MatrixAdditionRunTime, @MatrixMultiplicationRunTime, ...
    @MatrixQuadraticFormRunTime, @MatrixReductionsRunTime, @ElementWiseOperationsRunTime};

cFunctionString = {['Matrix Generation'], ['Matrix Addition'], ['Matrix Multiplication'], ...
    ['Matrix Quadratic Form'], ['Matrix Reductions'], ['Element Wise Operations']};

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

csvwrite('RunTimeMatlab0001.csv', mRunTime);


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

