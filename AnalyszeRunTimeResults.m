close all; clear; clc;

%% Figure Parameters

figPosSt=struct('default',[100, 100, 0560, 0420],'small',[100, 100, 0400, 0300],'medium',[100, 100, 0800, 0600],'large',[100, 100, 0960, 0720],'xlarge',[100, 100, 1100, 0825],'x2large',[100, 100, 1200, 0900],'x3larg',[100, 100, 1400, 1050]);
figPos=figPosSt.medium; % fig position identifier
lineWidthSt=struct('thin',1,'normal',3,'thick',4);
lineWidth=lineWidthSt.thin; % line width identifier
saveImage=0; % save image or not

%% Loading Data

tRunTimeMatlab = readtable(fullfile('RunTimeData\', 'RunTimeMatlabTable.csv'));
mRunTimeMatlab=table2array(tRunTimeMatlab(2:end,2:end));
vMatrixSizeMatlab=table2array(tRunTimeMatlab(1,2:end));
sFunNameMatlab=table2array(tRunTimeMatlab(2:end,1));

tRunTimeJulia = readtable(fullfile('RunTimeData\', 'RunTimeJuliaopenblas64Table.csv'));
mRunTimeJulia=table2array(tRunTimeJulia(2:end,2:end));
vMatrixSizeJulia=table2array(tRunTimeJulia(1,2:end));
sFunNameJulia=table2array(tRunTimeJulia(2:end,1));

tRunTimeJuliaSIMD = readtable(fullfile('RunTimeData\', 'RunTimeJuliaopenblas64SIMDTable.csv'));
mRunTimeJuliaSIMD=table2array(tRunTimeJuliaSIMD(2:end,2:end));
vMatrixSizeJuliaSIMD=table2array(tRunTimeJuliaSIMD(1,2:end));
sFunNameJuliaSIMD=table2array(tRunTimeJuliaSIMD(2:end,1));

tRunTimeJuliamkl = readtable(fullfile('RunTimeData\', 'RunTimeJuliamklTable.csv'));
mRunTimeJuliamkl=table2array(tRunTimeJuliamkl(2:end,2:end));
vMatrixSizeJuliamkl=table2array(tRunTimeJuliamkl(1,2:end));
sFunNameJuliamkl=table2array(tRunTimeJuliamkl(2:end,1));

tRunTimeJuliamklSIMD = readtable(fullfile('RunTimeData\', 'RunTimeJuliamklSIMDTable.csv'));
mRunTimeJuliamklSIMD=table2array(tRunTimeJuliamklSIMD(2:end,2:end));
vMatrixSizeJuliamklSIMD=table2array(tRunTimeJuliamklSIMD(1,2:end));
sFunNameJuliamklSIMD=table2array(tRunTimeJuliamklSIMD(2:end,1));

%% Displaying Results
figureIdx           = 0;

for ii = 1:size(mRunTimeMatlab,1)

    figureIdx   = figureIdx + 1;
    hFigure     = figure('Position', figPos);
    hAxes       = axes();

    loglog(vMatrixSizeMatlab,mRunTimeMatlab(ii,:),'-o','LineWidth',lineWidth,'MarkerFaceColor','b'); hold on;
    loglog(vMatrixSizeJulia,mRunTimeJulia(ii,:),'-s','LineWidth',lineWidth,'MarkerFaceColor','r'); hold on;
    loglog(vMatrixSizeJuliamkl,mRunTimeJuliamkl(ii,:),'-p','LineWidth',lineWidth,'MarkerFaceColor','g'); hold on;

    plotJuliaSIMD=ismember( sFunNameJuliamklSIMD, sFunNameMatlab{ii} ); % if 1 will plot Julia-SIMD
    if any(plotJuliaSIMD)
    	  loglog(vMatrixSizeJuliaSIMD,mRunTimeJuliaSIMD(plotJuliaSIMD,:),'-d','LineWidth',lineWidth,'MarkerFaceColor',[0.5,0,0.5]); hold on;
        h=loglog(vMatrixSizeJuliamklSIMD,mRunTimeJuliamklSIMD(plotJuliaSIMD,:),'-h','LineWidth',lineWidth,'MarkerFaceColor',[0.5,0.5,0]); hold on;

        legend('MATLAB','Julia','Julia-MKL','Julia-SIMD','Julia-MKL-SIMD','Location','southeast')
    else
        legend('MATLAB','Julia','Julia-MKL','Location','southeast')
    end
    hold off;
    title(num2str(sFunNameMatlab{ii}));
    xlabel('Matrix Size');
    ylabel('Run Time  [micro Seconds]');

    if(saveImage == 1)
        set(hAxes, 'LooseInset', [0.05, 0.05, 0.05, 0.05]);
        saveas(hFigure,['Figures\Figure', num2str(figureIdx), '.png']);
    end

end