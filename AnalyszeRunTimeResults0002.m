% ----------------------------------------------------------------------------------------------- %
% Analyze MATLAB & Julia Run Time Results
% Reference:
%   1. C.
% Remarks:
%   1.  W.
% TODO:
%   1.  A
%   Release Notes:
%   -   1.0.000     09/02/2017  Royi Avital
%       *   First release version.
% ----------------------------------------------------------------------------------------------- %

%% Setting Enviorment Parameters

run('InitScript.m');

MATLAB_IDX  = 1;
JULIA_IDX   = 2;

MATLAB_RUN_TIME_FILE_NAME   = 'RunTimeMatlab0002.csv';
JULIA_RUN_TIME_FILE_NAME    = 'RunTimeJulia0002.csv';

cLegendString = {['MATLAB'], ['Julia']};

figureIdx           = 6;
figureCounterSpec   = '%04d';

vMatrixSize = csvread('vMatrixSizeFull.csv');
cFunctionString = {['Matrix Exponential'], ['Matrix Square Root'], ['SVD'], ...
    ['Eigen Decomposition'], ['Cholesky Decomposition'], ['Matrix Inversion']};


%% Setting Parameters

generateImages = ON;


%% Loading Data

mRutnTimeMatlab = csvread(MATLAB_RUN_TIME_FILE_NAME);
mRutnTimeJulia  = csvread(JULIA_RUN_TIME_FILE_NAME);

numTests    = length(cFunctionString);
numMatSize  = length(vMatrixSize);

if(any(size(mRutnTimeMatlab) ~= size(mRutnTimeJulia)))
    error(['Run Time Data Dimensions Don''t Match']);
end

if(size(mRutnTimeMatlab, 2) ~= numTests)
    error(['Run Time Data Has Incompatible Number of Tests']);
end

if(size(mRutnTimeMatlab, 1) ~= numMatSize)
    error(['Run Time Data Has Incompatible Number of Matrix Size']);
end


%% Displaying Results

for ii = 1:numTests
    
    figureIdx   = figureIdx + 1;
    hFigure     = figure('Position', figPosMedium);
    hAxes       = axes();
    set(hAxes, 'NextPlot', 'add');
    hLineSeries = plot(vMatrixSize, [mRutnTimeMatlab(:, ii), mRutnTimeJulia(:, ii)]);
    set(hLineSeries, 'LineWidth', lineWidthNormal);
    set(get(hAxes, 'Title'), 'String', ['Test - ', cFunctionString{ii}], ...
        'FontSize', fontSizeTitle);
    set(get(hAxes, 'XLabel'), 'String', 'Matrix Size', ...
        'FontSize', fontSizeAxis);
    set(get(hAxes, 'YLabel'), 'String', 'Run Time  [Sec]', ...
        'FontSize', fontSizeAxis);
    hLegend = ClickableLegend(cLegendString);
    
    if(generateImages == ON)
        set(hAxes, 'LooseInset', [0.05, 0.05, 0.05, 0.05]);
        saveas(hFigure,['Figure', num2str(figureIdx, figureCounterSpec), '.png']);
    end

end


%% Restoring Defaults

% set(0, 'DefaultFigureWindowStyle', 'normal');
% set(0, 'DefaultAxesLooseInset', defaultLooseInset);

