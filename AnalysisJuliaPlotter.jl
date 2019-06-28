function AnalysisJuliaPlotter()
    # Setting Enviorment Parameters
    generateImages=1;
    saveImages=1;

    # Loading Data
    tRunTimeMatlab = readdlm("RunTimeData\\RunTimeMatlabTable.csv", ',');
    mRunTimeMatlab=tRunTimeMatlab[2:end,2:end];
    vMatrixSizeMatlab=tRunTimeMatlab[1,2:end];
    sFunNameMatlab=tRunTimeMatlab[2:end,1];

    tRunTimeJulia = readdlm("RunTimeData\\RunTimeJuliaopenblas64Table.csv", ',');
    mRunTimeJulia=tRunTimeJulia[2:end,2:end];
    vMatrixSizeJulia=tRunTimeJulia[1,2:end];
    sFunNameJulia=tRunTimeJulia[2:end,1];

    tRunTimeJuliaSIMD = readdlm("RunTimeData\\RunTimeJuliaopenblas64SIMDTable.csv", ',');
    mRunTimeJuliaSIMD=tRunTimeJuliaSIMD[2:end,2:end];
    vMatrixSizeJuliaSIMD=tRunTimeJuliaSIMD[1,2:end];
    sFunNameJuliaSIMD=tRunTimeJuliaSIMD[2:end,1];

    tRunTimeJuliamkl = readdlm("RunTimeData\\RunTimeJuliamklTable.csv", ',');
    mRunTimeJuliamkl=tRunTimeJuliamkl[2:end,2:end];
    vMatrixSizeJuliamkl=tRunTimeJuliamkl[1,2:end];
    sFunNameJuliamkl=tRunTimeJuliamkl[2:end,1];

    tRunTimeJuliamklSIMD = readdlm("RunTimeData\\RunTimeJuliamklSIMDTable.csv", ',');
    mRunTimeJuliamklSIMD=tRunTimeJuliamklSIMD[2:end,2:end];
    vMatrixSizeJuliamklSIMD=tRunTimeJuliamklSIMD[1,2:end];
    sFunNameJuliamklSIMD=tRunTimeJuliamklSIMD[2:end,1];

    # Displaying Results
    ii=1;
    for fun in sFunNameMatlab

        plt=plot( vMatrixSizeMatlab,[ mRunTimeMatlab[ii,:], mRunTimeJulia[ii,:], mRunTimeJuliamkl[ii,:] ],
        labels=["MATLAB", "Julia", "Julia-MKL"],legend=:bottomright, markershape =:auto,markersize=2,
        xlabel="Matrix Size", ylabel="Run Time  [micro Seconds]", guidefontsize=10,
        title="$fun", titlefontsize=10, xscale=:log10, yscale=:log10,dpi=300 );

        plotJuliaSIMD=occursin.(fun,sFunNameJuliamklSIMD); # if 1 will plot Julia-SIMD
        if any(plotJuliaSIMD)
            plt=plot!(vMatrixSizeJuliamklSIMD,[ dropdims(mRunTimeJuliaSIMD[plotJuliaSIMD,:],dims=1),                 dropdims(mRunTimeJuliamklSIMD[plotJuliaSIMD,:],dims=1) ],
            labels=["Julia-SIMD" "Julia-MKL-SIMD"],markershape =:auto, markersize=2);
        end

        display(plt); # display in plot pane
        if(saveImages == 1)
            savefig("Figures\\Julia\\Figure$(ii).png");
        end

        ii=ii+1;
    end

    nothing
end
