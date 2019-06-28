# Matlab & Julia Matrix Operations Benchmark

## Updated by Amin Yahyaabadi:
   * Julia language used is updated to V 1.1.1
   * Both Julia and Julia_MKL are tested.
   * Better benchmarking tools are used both in Julia and MATLAB
   * Many improvements and updates are made. For more details refer to changelog files: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Changelogs/

This is a small benchmark of some common Matrix Operations (Linear Algebra Oriented).  
The purpose of this Benchmark is to display Run Time of various commonly used operations by Signal / Image / Data Processing Algorithm Engineers. 
It was born from curiosity to to try Julia and if it will assist any user of Julia / MATLAB it served its purpose.
Better yet if it would assist Julia / MATLAB Developers to extract even better performance from their product it served its purpose twice.

## Results
This sections displays the results of the sub tests of the benchmark.
Each sub test is being executed several times and the median of run times is taken.  
The tests are divided into 3 sets.

### Matrix Generation

Generation of a Square Matrix using the `randn()` function and `rand()`.

 * MATLAB Code - `mA = randn(matrixSize, matrixSize)`, `mB = randn(matrixSize, matrixSize)`.
 * Julia Code - `mA = randn(matrixSize, matrixSize)`, `mB = randn(matrixSize, matrixSize)`.

![Matrix Generation][01]

### Matrix Addition

Addition of 2 square matrices where each is multiplied by a scalar.  

 * MATLAB Code - `mA = (scalarA .* mX) + (scalarB .* mY)`.
 * Julia Code - `mA = (scalarA .* mX) .+ (scalarB .* mY)` (Using the dot for [Loop Fusion][50]).

![Matrix Addition][02]

### Matrix Multiplication

Multiplication of 2 square matrices after a scalar is added to each. 

 * MATLAB Code - `mA = (scalarA + mX) * (scalarB + mY)`.
 * Julia Code - `mA = (scalarA .+ mX) * (scalarB .+ mY)` (Using the dot for [Loop Fusion][50]).

![Matrix Multiplication][03]

### Matrix Quadratic Form

Calculation of Matrix / Vector Quadratic Form.  

 * MATLAB Code - `mA = ((mX * vX).' * (mX * vX)) + (vB.' * vX) + sacalrC;`.
 * Julia Code - `	mA = (transpose(mX * vX) * (mX * vX)) .+ (transpose(vB) * vX) .+ scalarC;` (Using the dot for [Loop Fusion][50]).

![Matrix Quadratic Form][04]

### Matrix Reductions

Set of operations which reduce the matrix dimension (Works along one dimension).  
The operation is done on 2 different matrices on along different dimensions.  
The result is summed with broadcasting to generate a new matrix.
 * MATLAB Code - `mA = sum(mX, 1) + min(mY, [], 2);`.
 * Julia Code - `mA = sum(mX, dims=1) .+ minimum(mY, dims=2); ` (Using the dot for [Loop Fusion][50]).

![Matrix Reductions][05]

### Element Wise Operations
Set of operations which are element wise.

 * MATLAB Code - `mD = abs(mA) + sin(mB);`, `mE = exp(-(mA .^ 2));` and `mF = (-mB + sqrt((mB .^ 2) - (4 .* mA .* mC))) ./ (2 .* mA);`.
 * Julia Code - `mD = abs.(mA) .+ sin.(mB);`, `mE = exp.(-(mA .^ 2));` and `mF = (-mB .+ sqrt.((mB .^ 2) .- (4 .* mA .* mC))) ./ (2 .* mA);` (Using the dot for [Loop Fusion][50]).

![Element Wise Operations][06]

### Matrix Exponent

Calculation of Matrix Exponent.

 * MATLAB Code - `mA = expm(mX);`.
 * Julia Code - `mA = exp(mX);`.

![Matrix Exponent][07]

### Matrix Square Root

Calculation of Matrix Square Root.

 * MATLAB Code - `mA = sqrtm(mY);`.
 * Julia Code - `mA = sqrt(mY);`.


![Matrix Square Root][08]

### SVD

Calculation of all 3 SVD Matrices.

 * MATLAB Code - `[mU, mS, mV] = svd(mX)`.
 * Julia Code - `F = svd(mX, full = false); # F is SVD object`,`	mU, mS, mV = F;`.

![SVD][09]

### Eigen Decomposition

Calculation of 2 Eigen Decomposition Matrices.

 * MATLAB Code - `[mD, mV] = eig(mX)`.
 * Julia Code - `	F  = eigen(mX); # F is eigen object`, `mD, mV = F;`.

![Eigen Decomposition][10]

### Cholesky Decomposition

Calculation of Cholseky Decomposition.

 * MATLAB Code - `mA = cholesky(mY)`.
 * Julia Code - `mA = cholesky(mY)`.

![Cholseky Decomposition][11]

### Matrix Inversion

Calculation of the Inverse and Pseudo Inverse of a matrix.

 * MATLAB Code - `mA = inv(mY)` and `mB = pinv(mX)`.
 * Julia Code - `mA = inv(mY)` and `mB = pinv(mX)`.

![Matrix Inversion][12]

### Linear System Solution

Solving a Vector Linear System and a Matrix Linear System.

 * MATLAB Code - `vX = mA \ vB` and `mX = mA \ mB`.
 * Julia Code - `vX = mA \ vB` and `mX = mA \ mB`.

![Linear System Solution][13]

### Linear Least Squares

Solving a Vector Least Squares and a Matrix Least Squares.  
This is combines Matrix Transpose, Matrix Multiplication (Done at onces), Matrix Inversion (Positive Definite) and Matrix Vector / Matrix Multiplication.

 * MATLAB Code - `vX = (mA.' * mA) \ (mA.' * vB)` and `mX = (mA.' * mA) \ (mA.' * mB)`.
 * Julia Code - 	`mXT=transpose(mX);	vA = ( mXT * mX) \ ( mXT * vB);	mA = ( mXT * mX) \ ( mXT * mB);`.

![Linear Least Squares][14]

### Squared Distance Matrix

Calculation of the Squared Distance Matrix between 2 sets of Vectors.  
Namely, each element in the matrix is the squared distance between 2 vectors.  
This is calculation is needed for instance in the K-Means algorithm.
It is composed of Matrix Reduction operation, Matrix Multiplication and Broadcasting. 

 * MATLAB Code - `mA = sum(mX .^ 2, 1).' - (2 .* mX.' * mY) + sum(mY .^ 2, 1)`.
 * Julia Code - `mA = transpose( sum(mX .^ 2, dims=1) ) .- (2 .* transpose(mX) * mY) .+ sum(mY .^ 2, dims=1);` (Using the dot for [Loop Fusion][50]).

![Squared Distance Matrix][15]

### K-Means Algorithm

Running 10 iterations of the K-Means Algorithm. 

 * MATLAB Code - See `MatlabBench.m` at `KMeans()`.
 * Julia Code - See `JuliaBench.jl` at `KMeans()`.

![K-Means Algorithm][16]


## System Configuration
 * System Model - Dell Latitude 5590 
 https://www.dell.com/en-ca/work/shop/dell-tablets/latitude-5590/spd/latitude-15-5590-laptop
 * CPU - Intel(R) Core(TM) i5-8250U @ 1.6 [GHz] 1800 Mhz, 4 Cores, 8 Logical Processors.
 * Memory - 1x8GB DDR4 2400MHz Non-ECC 
 * Windows 10 Professional 64 Bit.

 * MATLAB R2018b.
    * BLAS Version (`version -blas`) - `Intel(R) Math Kernel Library Version 2018.0.1 Product Build 20171007 for Intel(R) 64 architecture applications, CNR branch AVX2`
    * LAPACK Version (`version -lapack`) - `Intel(R) Math Kernel Library Version 2018.0.1 Product Build 20171007 for Intel(R) 64 architecture applications CNR branch AVX2  Linear Algebra PACKage Version 3.7.0`

Two version of Julia was used:

 * JuliaMKL: Julia 1.1.1 + MKL.
     * Julia Version (`versioninfo()`) - `Julia Version 1.1.1 Commit 55e36cc308 (2019-05-16 04:10 UTC)`;
     * BLAS Version - `LinearAlgebra.BLAS.vendor(): Intel MKL `. https://github.com/JuliaComputing/MKL.jl , For tutrial to instal: https://github.com/aminya/MKL.jl/tree/patch-1
     * LAPACK Version - `libopenblas64_`.
     * LIBM Version - `libopenlibm`.
     * LLVM Version - `libLLVM-6.0.1 (ORCJIT, skylake)`.
     * JULIA_EDITOR = "C:\~\atom\app-1.38.1\atom.exe"  -a
     * JULIA_NUM_THREADS = 4

 * Julia: JuliaPro 1.1.1.1
     * Julia Version (`versioninfo()`) - `Julia Version 1.1.1 Commit 55e36cc308 (2019-05-16 04:10 UTC)`;
     * BLAS Version - `LinearAlgebra.BLAS.vendor(): openBlas64 `.
     * LAPACK Version - `libopenblas64_`.
     * LIBM Version - `libopenlibm`.
     * LLVM Version - `libLLVM-6.0.1 (ORCJIT, skylake)`.
     * JULIA_EDITOR = "C:\JuliaPro-1.1.1.1\app-1.36.0\atom.exe"  -a
     * JULIA_NUM_THREADS = 4

## How to Run
### Run the Benchmark - Julia
Download `JuliaMain.jl`and `JuliaBench.jl`
From console:
```
include("JuliaMain.jl");
```

### Run the Benchmark - MATLAB
Download `MatlabMain.m`and `MatlabBench.m`
From MATLAB command line :
```
MatlabMain
```

### Run The Analysis In MATLAB
 * Download `AnalyszeRunTimeResults.m`.
 * Run both MATLAB and Julia Benchmark to create the CSV files.
 * From MATLAB command line `AnalyszeRunTimeResults`.
 * Images of the performance test will be created and displayed.

### Run The Analysis In Julia
 * Download `AnalysisJuliaPlotter.jl`and `AnalyszeRunTimeResults.jl`.
 * Run both MATLAB and Julia Benchmark to create the CSV files.
 * From Julia command line `include("AnalyszeRunTimeResults.jl");`.
 * Images of the performance test will be created and displayed.

## To Do:
 * Check if Julia code is efficient. using https://github.com/JunoLab/Traceur.jl and https://docs.julialang.org/en/v1/manual/performance-tips/index.html
 
 * Add more tests (Some real world algorithms)
     * Orthogonal Matching Pursuit.
     * Reweighted Iterative Least Squares.

 * Add Python (NumPy): Code has been converted from MATLAB to python using smop. Still needs working https://github.com/aminya/smop
 * Add Octave.

## Discourse Discusion Forum:
https://discourse.julialang.org/t/benchmark-matlab-julia-for-matrix-operations/2000
 
  [01]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure1.png
  [02]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure2.png
  [03]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure3.png
  [04]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure4.png
  [05]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure5.png
  [06]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure6.png
  [07]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure7.png
  [08]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure8.png
  [09]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure9.png
  [10]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure10.png
  [11]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure11.png
  [12]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure12.png
  [13]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure13.png
  [14]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure14.png
  [15]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure15.png
  [16]: https://github.com/aminya/MatlabJuliaMatrixOperationsBenchmark/blob/master/Figures/Figure16.png
  [50]: http://julialang.org/blog/2017/01/moredots

## Old Royi Remarks
 * I'm not an expert in Julia (Actually this was my first time coding Julia). Hence, if there are ways to improve the run time, please share with me. I did took advise from [More Dots: Syntactic Loop Fusion in Julia][50].
 * This is only a small sub set of operations. I will expand it with time. If you have ideas for small micro benchmark to be added, please share.
 * For each function the output was set to dependent on the calculation which was timed to prevent JIT optimizations which excludes the calculation (MATLAB infers the calculation has no effect on the output and doesn't run it).
 * The MATLAB code uses Broadcasting which is a feature added on MATLAB R2016b. Hence the test requires this version or one must adjust the code (Use `bsxfun()`).
 * There is no perfect test and this is far from being one. All it tried to do is measure run time of few common operations done by Signal / Image / Data Processing Algorithm Engineers. If it can assist MATLAB and Julia creators to improve performance and tune their implementation it served it purpose.
