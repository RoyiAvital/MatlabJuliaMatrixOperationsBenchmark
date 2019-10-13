function [  ] = MatlabMatrixBenchmark( operationMode )
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

vTestIdx = [1:6];
mRunTime = MatlabMatrixBenchmark0001(operationMode, vTestIdx);
mRunTime = MatlabMatrixBenchmark0002(operationMode, vTestIdx);
vTestIdx = [1:4];
mRunTime = MatlabMatrixBenchmark0003(operationMode, vTestIdx);


end

