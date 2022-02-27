[![Visitors](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FRoyiAvital%2FStackExchangeCodes&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors+%28Daily+%2F+Total%29&edge_flat=false)](https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark)
<a href="https://liberapay.com/Royi/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>

# MATLAB & Julia Matrix Operations Benchmark

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

Belongs to set 0001.

![Matrix Generation][01]

### Matrix Addition

Addition of 2 square matrices where each is multiplied by a scalar.  
 * MATLAB Code - `mA = (scalarA .* mX) + (scalarB .* mY)`.
 * Julia Code - `mA = (scalarA .* mX) .+ (scalarB .* mY)` (Using the dot for [Loop Fusion][50]).

Belongs to set 0001.

![Matrix Addition][02]

### Matrix Multiplication

Multiplication of 2 square matrices after a scalar is added to each.  
 * MATLAB Code - `mA = (scalarA + mX) * (scalarB + mY)`.
 * Julia Code - `mA = (scalarA .+ mX) * (scalarB .+ mY)` (Using the dot for [Loop Fusion][50]).

Belongs to set 0001.

![Matrix Multiplication][03]

### Matrix Quadratic Form

Calculation of Matrix / Vector Quadratic Form.  
 * MATLAB Code - `mA = ((mX * vX).' * (mX * vX)) + (vB.' * vX) + scalarC;`.
 * Julia Code - `mA = ((mX * vX)' * (mX * vX)) .+ (vB' * vX) .+ scalarC;` (Using the dot for [Loop Fusion][50]).

Belongs to set 0001.

![Matrix Quadratic Form][04]

### Matrix Reductions

Set of operations which reduce the matrix dimension (Works along one dimension).  
The operation is done on 2 different matrices on along different dimensions.  
The result is summed with broadcasting to generate a new matrix.

 * MATLAB Code - `mA = (scalarA + mX) * (scalarB + mY)`.
 * Julia Code - `mA = sum(mX, dims = 1) .+ minimum(mY, dims = 2);` (Using the dot for [Loop Fusion][50]).

Belongs to set 0001.

![Matrix Reductions][05]

### Element Wise Operations
Set of operations which are element wise.

 * MATLAB Code - `mD = abs(mA) + sin(mB);`, `mE = exp(-(mA .^ 2));` and `mF = (-mB + sqrt((mB .^ 2) - (4 .* mA .* mC))) ./ (2 .* mA);`.
 * Julia Code - `mD = abs.(mA) .+ sin.(mB);`, `mE = exp.(-(mA .^ 2));` and `mF = (-mB .+ sqrt.((mB .^ 2) .- (4 .* mA .* mC))) ./ (2 .* mA);` (Using the dot for [Loop Fusion][50]).

Belongs to set 0001.

![Element Wise Operations][06]

### Matrix Exponent

Calculation of Matrix Exponent.

 * MATLAB Code - `mA = expm(mX);`.
 * Julia Code - `mA = exp(mX);`.

Belongs to set 0002.

![Matrix Exponent][07]

### Matrix Square Root

Calculation of Matrix Square Root.

 * MATLAB Code - `mA = sqrtm(mX);`.
 * Julia Code - `mA = sqrt(mX);`.

Belongs to set 0002.

![Matrix Square Root][08]

### SVD

Calculation of all 3 SVD Matrices.

 * MATLAB Code - `[mU, mS, mV] = svd(mX);`.
 * Julia Code - `mU, vS, mV = svd(mX, full = true); mS = diagm(vS);`.

Belongs to set 0002.

![SVD][09]

### Eigen Decomposition

Calculation of 2 Eigen Decomposition Matrices.

 * MATLAB Code - `[mD, mV] = eig(mX);`.
 * Julia Code - `vD, mV = eigen(mX); mD = diagm(vD);`.

Belongs to set 0002.

![Eigen Decomposition][10]

### Cholesky Decomposition

Calculation of Cholseky Decomposition.

 * MATLAB Code - `mA = chol(mX);`.
 * Julia Code - `mA = cholesky(mY);`.

Belongs to set 0002.

![Cholseky Decomposition][11]

### Matrix Inversion

Calculation of the Inverse and Pseudo Inverse of a matrix.

 * MATLAB Code - `mA = inv(mX);` and `mB = pinv(mY);`.
 * Julia Code - `mA = inv(mX);` and `mB = pinv(mY);`.

Belongs to set 0002.

![Matrix Inversion][12]

### Linear System Solution

Solving a Vector Linear System and a Matrix Linear System.

 * MATLAB Code - `vX = mA \ vB;` and `mX = mA \ mB;`.
 * Julia Code - `vX = mA \ vB;` and `mX = mA \ mB;`.

Belongs to set 0003.

![Linear System Solution][13]

### Linear Least Squares

Solving a Vector Least Squares and a Matrix Least Squares.  
This is combines Matrix Transpose, Matrix Multiplication (Done at onces), Matrix Inversion (Positive Definite) and Matrix Vector / Matrix Multiplication.

 * MATLAB Code - `vX = (mA.' * mA) \ (mA.' * vB);` and `mX = (mA.' * mA) \ (mA.' * mB);`.
 * Julia Code - `vX = (mA.' * mA) \ (mA.' * vB);` and `mX = (mA.' * mA) \ (mA.' * mB);`.

Belongs to set 0003.

![Linear Least Squares][14]

### Squared Distance Matrix

Calculation of the Squared Distance Matrix between 2 sets of Vectors.  
Namely, each element in the matrix is the squared distance between 2 vectors.  
This is calculation is needed for instance in the K-Means algorithm.
It is composed of Matrix Reduction operation, Matrix Multiplication and Broadcasting. 

 * MATLAB Code - `mA = sum(mX .^ 2, 1).' - (2 .* mX.' * mY) + sum(mY .^ 2, 1);`.
 * Julia Code - `mA = sum(mX .^ 2, dims = 1)' .- (2 .* mX' * mY) .+ sum(mY .^ 2, dims = 1);` (Using the dot for [Loop Fusion][50]).

Belongs to set 0003.

![Squared Distance Matrix][15]

### K-Means Algorithm

Running 10 iterations of the K-Means Algorithm. 

 * MATLAB Code - See `MatlabMatrixBenchmark0003.m` at `KMeansRunTime()`.
 * Julia Code - See `JuliaMatrixBenchmark0003.jl` at `KMeansRunTime()`.

Belongs to set 0003.

![K-Means Algorithm][16]


## System Configuration
 * CPU - Intel Core I7 6800K @ 3.4 [GHz].
 * Memory - 4 * 8 [GB] @ 1400 [MHz] - G.Skill F4 2800C-16-8GRK.
 * Mother Board - ASRock X99 Killer (BIOS Version P3.20).
 * MATLAB R2019b:
    * BLAS Version (`version -blas`) - `Intel(R) Math Kernel Library Version 2018.0.3 Product Build 20180406 for Intel(R) 64 architecture applications, CNR branch AVX2`.
    * LAPACK Version (`version -lapack`) - `Intel(R) Math Kernel Library Version 2018.0.3 Product Build 20180406 for Intel(R) 64 architecture applications, CNR branch AVX2
     Linear Algebra PACKage Version 3.7.0`.  
 * Julia Pro 1.2.0.1:
     * Julia Version (`versioninfo()`) - `Julia Version 1.2.0; Commit c6da87ff4b (2019-08-20 00:03 UTC)`;
     * OpenBLAS Version - `OpenBLAS 0.3.5  USE64BITINT DYNAMIC_ARCH NO_AFFINITY Haswell MAX_THREADS=16`.
	 * MKL Version - `MKL.v2019.0.117.x86_64-w64-mingw32.tar.gz` from ([`buildMKL.jl](https://github.com/JuliaComputing/MKL.jl/blob/e8780f9c3826cce167cf03ebbdcc72f328bf2e1d/deps/build_MKL.jl) on [MKL.jl](https://github.com/JuliaComputing/MKL.jl) at the time of the test).
     * LAPACK Version - `libopenblas64_`.
     * LIBM Version - `libopenlibm`.
     * LLVM Version - `libLLVM-6.0.1 (ORCJIT, broadwell)`.
 * Windows 10 Professional 64 Bit (Build `10.0.18362`).

At the time of the test no other application is running (Anti Virus is disabled).  
**Remark**: Pay attention that MATLAB uses the CNR branch of MKL. This branch is for ensuring reproducibility.  
This means that MKL can deliver even better performance for those who can prioritize speed over reproducibility.


## How to Run
### Run the Benchmark - Julia
Download `JuliaMatrixBenchmark.jl`, `JuliaMatrixBenchmark0001.jl`, `JuliaMatrixBenchmark0002.jl` and `JuliaMatrixBenchmark0003.jl`.  
From console:
```
include("JuliaMatrixBenchmark.jl");
```

### Run the Benchmark - MATLAB
Download `MatlabMatrixBenchmark.m`, `MatlabMatrixBenchmark0001.m`, `MatlabMatrixBenchmark0002.m` and `MatlabMatrixBenchmark0003.m`.  
From console:
```
mRunTime = JuliaMatrixBenchmark();
```

### Run The Analysis
 * Download `InitScript.m`, `ClickableLegend.m`, `AnalyszeRunTimeResults0001.m`, `AnalyszeRunTimeResults0002.m` and `AnalyszeRunTimeResults0003.m`.
 * Run both MATLAB and Julia Benchmark to create the CSV data files. Make sure all data and files are in the same folder.
 * From MATLAB command line `run('AnalyszeRunTimeResults0001.m')` / `run('AnalyszeRunTimeResults0002.m')` / `run('AnalyszeRunTimeResults0003.m')`.
 * Images of the performance test will be created and displayed.

## Remarks
 * I'm not an expert in Julia (Actually this was my first time coding Julia). Hence, if there are ways to improve the run time, please share with me. I did took advise from [More Dots: Syntactic Loop Fusion in Julia][50].
 * This is only a small sub set of operations. I will expand it with time. If you have ideas for small micro benchmark to be added, please share.
 * For each function the output was set to dependent on the calculation which was timed to prevent JIT optimizations which excludes the calculation (MATLAB infers the calculation has no effect on the output and doesn't run it).
 * The MATLAB code uses Broadcasting which is a feature added on MATLAB R2016b. Hence the test requires this version or one must adjust the code (Use `bsxfun()`).
 * There is no perfect test and this is far from being one. All it tried to do is measure run time of few common operations done by Signal / Image / Data Processing Algorithm Engineers. If it can assist MATLAB and Julia creators to improve performance and tune their implementation it served it purpose.

## ToDo
 * Check if Julia code is efficient.
 * Add Python (NumPy).
 * Add Octave.
 * Add more tests (Some real world algorithms)
     * 	Orthogonal Matching Pursuit.
     * 	Reweighted Iterative Least Squares.
	 *	Prox based L1 Regularized Least Squares.

 
  [01]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0001.png
  [02]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0002.png
  [03]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0003.png
  [04]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0004.png
  [05]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0005.png
  [06]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0006.png
  [07]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0007.png
  [08]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0008.png
  [09]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0009.png
  [10]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0010.png
  [11]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0011.png
  [12]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0012.png
  [13]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0013.png
  [14]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0014.png
  [15]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0015.png
  [16]: https://github.com/RoyiAvital/MatlabJuliaMatrixOperationsBenchmark/raw/master/Figures/Figure0016.png
  [50]: http://julialang.org/blog/2017/01/moredots
