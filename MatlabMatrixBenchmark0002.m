function [ mRunTime ] = MatlabMatrixBenchmark0002( operationMode, vTestIdx )
% ----------------------------------------------------------------------------------------------- %
% MATLAB Matrix Operations Benchmark - Test Suite 0002
% Reference:
%   1. C.
% Remarks:
%   1.  Keep 'mX' "Read Only" within the functions to match Julia (Pass by Address).
% TODO:
%   1.  A
%   Release Notes:
%	- 	1.0.003 	12/02/2017	Royi Avital
% 		* 	Ability to run only some of the tests.
%   -   1.0.002     10/02/2017  Royi Avital
%       *   Added generation of 'mX' once outside the functions.
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

RUN_TIME_DATA_FOLDER    = 'RunTimeData';
RUN_TIME_FILE_NAME      = 'RunTimeMatlab0002.csv';

OPERATION_MODE_PARTIAL  = 1; %<! For Testing (Runs Fast)
OPERATION_MODE_FULL     = 2;

cRunTimeFunctionsBase = {@MatrixExpRunTime, @MatrixSqrtRunTime, ...
    @SvdRunTime, @EigRunTime, @CholDecRunTime, @MatInvRunTime};

cFunctionStringBase = {['Matrix Exponential'], ['Matrix Square Root'], ['SVD'], ...
    ['Eigen Decomposition'], ['Cholesky Decomposition'], ['Matrix Inversion']};

numTests = length(cRunTimeFunctionsBase);

if(operationMode == OPERATION_MODE_PARTIAL)
    vMatrixSize = csvread('vMatrixSizePartial.csv');
    numIterations = csvread('numIterationsPartial.csv');
elseif(operationMode == OPERATION_MODE_FULL)
    vMatrixSize = csvread('vMatrixSizeFull.csv');
    numIterations = csvread('numIterationsFull.csv');
end

cRunTimeFunctions = cRunTimeFunctionsBase(vTestIdx);
cFunctionString = cFunctionStringBase(vTestIdx);

mRunTime = zeros(length(vMatrixSize), length(cRunTimeFunctions), numIterations);

hTotelRunTimer = tic();
for ii = 1:length(vMatrixSize)
    matrixSize = vMatrixSize(ii);
    mX = randn(matrixSize, matrixSize);
    disp(['Matrix Size - ', num2str(matrixSize)]);
    for jj = 1:length(cRunTimeFunctions)
        disp(['Processing ', num2str(cFunctionString{jj}), ' Matrix Size ', num2str(matrixSize)]);
        for kk = 1:numIterations
            [mA, mRunTime(ii, jj, kk)] = cRunTimeFunctions{jj}(matrixSize, mX);
        end
        disp(['Finished Processing ', num2str(cFunctionString{jj})]);
    end
end
totalRunTime = toc(hTotelRunTimer);

mRunTime = median(mRunTime, 3);

disp(['Finished the Benchmark in ', num2str(totalRunTime), ' [Sec]']);

runTimeFilePath = fullfile(RUN_TIME_DATA_FOLDER, RUN_TIME_FILE_NAME);

mRunTimeBase = 0;
if(exist(runTimeFilePath, 'file'))
    mRunTimeBase = csvread(runTimeFilePath);
end

if(any(size(mRunTimeBase) ~= [length(vMatrixSize), numTests]))
    % Previous Data has incompatible dimensions
    mRunTimeBase = zeros([length(vMatrixSize), numTests]);
end

mRunTimeBase(:, vTestIdx) = mRunTime;

if(operationMode == OPERATION_MODE_FULL)
    csvwrite(runTimeFilePath, mRunTimeBase);
end


end


function [ mA, runTime ] = MatrixExpRunTime( matrixSize, mX )

tic();
mA = expm(mX);
runTime = toc();


end

function [ mA, runTime ] = MatrixSqrtRunTime( matrixSize, mX )

mY = mX.' * mX;

tic();
mA = sqrtm(mY);
runTime = toc();


end

function [ mA, runTime ] = SvdRunTime( matrixSize, mX )

tic();
[mU, mS, mV] = svd(mX);
runTime = toc();

mA = mU + mS + mV;


end

function [ mA, runTime ] = EigRunTime( matrixSize, mX )

tic();
[mD, mV] = eig(mX);
runTime = toc();

mA = mD + mV;


end

function [ mA, runTime ] = CholDecRunTime( matrixSize, mX )

mY = mX.' * mX;

tic();
mA = chol(mY);
runTime = toc();

  
end

function [ mA, runTime ] = MatInvRunTime( matrixSize, mX )

mY = mX.' * mX;

tic();
mA = inv(mY);
mB = pinv(mX);
runTime = toc();

mA = mA + mB;


end

