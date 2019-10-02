clc;clear;

operationMode=2;% 0 for test only # 1 for partial benchmark # 2 for full benchmark

[ mRunTime,tRunTime ] = MatlabBench(operationMode);

writetable(tRunTime,fullfile('RunTimeData', 'RunTimeMatlabTable.csv'),'WriteVariableNames',false);
save(fullfile('RunTimeData', 'RunTimeMatlab.mat'),'mRunTime')