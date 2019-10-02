function JuliaBenchSIMD( operationMode )

    allFunctions = [MatrixAddition, MatrixMultiplication, ElementWiseOperations]; # only SIMD functions to run


    allFunctionsString = [ "Matrix Addition", "Matrix Multiplication", "Element Wise Operations"];

    if (operationMode == 1) # partial benchmark
        vMatrixSize =  dropdims(DelimitedFiles.readdlm("Inputs\\vMatrixSizePartial.csv", ',',Int64), dims=1);
        numIterations = dropdims(DelimitedFiles.readdlm("Inputs\\numIterationsPartial.csv", ',',Int64), dims=1);

    elseif (operationMode == 2) # full benchmark
        vMatrixSize = dropdims(readdlm("Inputs\\vMatrixSizeFull.csv", ',',Int64), dims=1);
        numIterations =  dropdims(readdlm("Inputs\\numIterationsFull.csv", ',',Int64), dims=1);

    elseif (operationMode == 0) # Test benchmark
        vMatrixSize = 2;
        numIterations =  1;

    end

    numIterations = numIterations[1]; # It is 1x1 Array -> Scalar

    mRunTime = zeros(length(vMatrixSize), length(allFunctions), numIterations);
    tRunTime= Array{Any}(undef,length(allFunctions)+1,length(vMatrixSize)+1)# a table containing all the information
	tRunTime[1,1]="FunctionName\\MatrixSize";

    for ii = 1:length(vMatrixSize)
        matrixSize = vMatrixSize[ii];
        mX = randn(matrixSize, matrixSize);
        mY = randn(matrixSize, matrixSize);
        println("Matrix Size - $matrixSize");

        jj=1;
        for fun in allFunctions
            println("Processing $(allFunctionsString[jj]) - MatrixSize= $matrixSize");

            for kk = 1:numIterations;

                benchIJK =@benchmark $fun($matrixSize, $mX, $mY)
                # t =@benchmarkable $fun($matrixSize, $mX, $mY);
                # tune!(t)
                # run(t)

                mRunTime[ii, jj, kk]=median(benchIJK).time/1e3;
                # println("$(mRunTime[ii, jj, kk])")

            end
			tRunTime[jj+1,1]="$(allFunctionsString[jj])";
			tRunTime[1,ii+1]="$matrixSize";
			tRunTime[jj+1,ii+1]=mean(mRunTime[ii, jj,:]);
            jj+=1;
        end

    end

    return tRunTime, mRunTime;
end


function MatrixGeneration( matrixSize, mX, mY )

  mA = randn(matrixSize, matrixSize);
  mB = rand(matrixSize, matrixSize);

  return mA;
end

function MatrixAddition( matrixSize, mX, mY )

  scalarA = rand();
  scalarB = rand();

  # mA = (scalarA .* mX) .+ (scalarB .* mY);
  mA = Array{Float64}(undef, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mA[ii] = (scalarA * mX[ii]) + (scalarB * mY[ii]);
  end

  return mA;
end

function MatrixMultiplication( matrixSize, mX, mY )

  scalarA = rand();
  scalarB = rand();

  # mA = (scalarA .+ mX) * (scalarB .+ mY);
  mA = Array{Float64}(undef, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mA[ii] = (scalarA + mX[ii]) * (scalarB + mY[ii]);
  end

  return mA;
end

function MatrixQuadraticForm( matrixSize, mX, mY )

  vX = randn(matrixSize);
  vB = randn(matrixSize);
  sacalrC = rand();

  mA = (transpose(mX * vX) * (mX * vX)) .+ (transpose(vB) * vX) .+ sacalrC;

  return mA;
end

function MatrixReductions( matrixSize, mX, mY )

  mA = sum(mX, dims=1) .+ minimum(mY, dims=2); #Broadcasting

  return mA;
end

function ElementWiseOperations( matrixSize, mX, mY )

  mA = rand(matrixSize, matrixSize);
  mB = 3 .+ rand(matrixSize, matrixSize);
  mC = rand(matrixSize, matrixSize);

  # mD = abs.(mA) .+ sin.(mA);
  mD = Array{Float64}(undef, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mD[ii] = abs(mA[ii]) + sin(mA[ii]);
  end

  # mE = exp.(-(mA .^ 2));
  mE = Array{Float64}(undef, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mE[ii] = exp(- (mA[ii] * mA[ii]));
  end

  # mF = (-mB .+ sqrt.((mB .^ 2) .- (4 .* mA .* mC))) ./ (2 .* mA);
  mF = Array{Float64}(undef, matrixSize, matrixSize);
  @simd for ii = 1:(matrixSize * matrixSize)
    @inbounds mF[ii] = (-mB[ii] + sqrt( (mB[ii] * mB[ii]) - (4 * mA[ii] * mC[ii]) )) ./ (2 * mA[ii]);
  end

  mA = mD .+ mE .+ mF;

  return mA;
end


function MatrixExp( matrixSize, mX, mY )

    mA = exp(mX);

    return mA;
end

function MatrixSqrt( matrixSize, mX, mY )


    mY = transpose(mX) * mX;

    mA = sqrt(mY);


  return mA;
end

function Svd( matrixSize, mX, mY )

    F = svd(mX, full = false); # F is SVD object
    mU, mS, mV = F;

    return mA=0;
end

function Eig( matrixSize, mX, mY )

    F  = eigen(mX); # F is eigen object
    mD, mV = F;

    return mA=0;
end

function CholDec( matrixSize, mX, mY )

  mY = transpose(mX) * mX;

  mA = cholesky(mY);

  return mA;
end

function MatInv( matrixSize, mX, mY )

  mY = transpose(mX) * mX;

  mA = inv(mY);
  mB = pinv(mX);

  mA = mA .+ mB;

  return mA;
end

function LinearSystem( matrixSize, mX, mY )

  mB = randn(matrixSize, matrixSize);
  vB = randn(matrixSize);

  vA = mX \ vB;
  mA = mX \ mB;

  mA = mA .+ vA;

  return mA;
end

function LeastSquares( matrixSize, mX, mY )

  mB = randn(matrixSize, matrixSize);
  vB = randn(matrixSize);

  vA = (transpose(mX) * mX) \ (transpose(mX) * vB);
  mA = (transpose(mX) * mX) \ (transpose(mX) * mB);

  mA = mA .+ vA;

  return mA;
end

function CalcDistanceMatrix( matrixSize, mX, mY )

  mY = randn(matrixSize, matrixSize);

  mA = transpose(sum(mX .^ 2, dims=1)) .- (2 .* transpose(mX) * mY) .+ sum(mY .^ 2, dims=1);

  return mA;
end

function KMeans( matrixSize, mX, mY )

    # Assuming Samples are slong Columns (Rows are features)
    numClusters  = Int64( max( round(matrixSize / 100), 1 ) ); # % max between 1 and round(...)
    numIterations = 10;

    # http://stackoverflow.com/questions/36047516/julia-generating-unique-random-integer-array
    mA = mX[:, randperm(matrixSize)[1:numClusters]]; #<! Cluster Centroids

    for ii = 1:numIterations
        vMinDist, mClusterId = findmin( transpose(sum(mA .^ 2, dims=1)) .- (2 .* transpose(mA)* mX), dims=1); #<! Is there a `~` equivalent in Julia?
        vClusterId = LinearIndices( dropdims(mClusterId, dims=1) ); # to be able to access it later

        for jj = 1:numClusters
            mA[:, jj] = mean( mX[:, vClusterId .== jj ], dims=2 );
        end
    end

    mA = mA[:, 1] .+ transpose(mA[:, end]);

  return mA;
end
