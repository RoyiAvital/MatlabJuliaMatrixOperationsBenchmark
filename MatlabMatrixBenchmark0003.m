function [ mRunTime ] = MatlabMatrixBenchmark0003( operationMode, vTestIdx )
% ----------------------------------------------------------------------------------------------- %
% MATLAB Matrix Operations Benchmark - Test Suite 0003
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
%       *   Added 'KMeansRunTime()'.
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
RUN_TIME_FILE_NAME      = 'RunTimeMatlab0003.csv';

OPERATION_MODE_PARTIAL  = 1; %<! For Testing (Runs Fast)
OPERATION_MODE_FULL     = 2;

cRunTimeFunctionsBase = {@LinearSystemRunTime, @LeastSquaresRunTime, @CalcDistanceMatrixRunTime, @KMeansRunTime};

cFunctionStringBase = {['Linear System Solution'], ['Linear Least Squares'], ['Squared Distance Matrix'], ['K-Means Run Time']};

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


function [ mA, runTime ] = LinearSystemRunTime( matrixSize, mX )

% mA = randn(matrixSize, matrixSize);
mB = randn(matrixSize, matrixSize);
vB = randn(matrixSize, 1);

tic();
vA = mX \ vB;
mA = mX \ mB;
runTime = toc();

mA = mA + vA;


end

function [ mA, runTime ] = LeastSquaresRunTime( matrixSize, mX )

% mA = randn(matrixSize, matrixSize);
mB = randn(matrixSize, matrixSize);
vB = randn(matrixSize, 1);

tic();
vA = (mX.' * mX) \ (mX.' * vB);
mA = (mX.' * mX) \ (mX.' * mB);
runTime = toc();

mA = mA + vA;


end

function [ mA, runTime ] = CalcDistanceMatrixRunTime( matrixSize, mX )

mY = randn(matrixSize, matrixSize);

tic();
mA = sum(mX .^ 2, 1).' - (2 .* mX.' * mY) + sum(mY .^ 2, 1);
runTime = toc();
  
  
end

function [ mA, runTime ] = KMeansRunTime( matrixSize, mX )

% Assuming Samples are slong Columns (Rows are features)
% mX              = randn(matrixSize, matrixSize);
numClusters     = max(round(matrixSize / 100), 1);
vClusterId      = zeros(matrixSize, 1);
numIterations   = 10;

tic();
mA          = mX(:, randperm(matrixSize, numClusters)); %<! Cluster Centroids

for ii = 1:numIterations
    [~, vClusterId(:)] = min(sum(mA .^ 2, 1).' - (2 .* mA.' * mX), [], 1);
    for jj = 1:numClusters
        mA(:, jj) = sum(mX(:, vClusterId == jj), 2) ./ sum(vClusterId == jj);
    end
    
end
runTime = toc();

mA = mA(:, 1) + mA(:, end).';

  
end

