# Matlab & Julia Matrix Operations Benchmark

This is a small benchmark of some common Matrix Operations (Linear Algebra Oriented).  

## Results
This sections displays the results of the sub tests of the benchmark.

### Matrix Generation

Generation of a Square Matrix using the `randn()` function.
 * MATLAB Code - `mA = randn(matrixSize, matrixSize)`.
 * Julia Code - `mA = randn(matrixSize, matrixSize)`. 

![Matrix Generation][01]

### Matrix Addition

Addition of 2 square matrices where each is multiplied by a scalar.  
 * MATLAB Code - `mA = (scalarA .* mX) + (scalarB .* mY)`.
 * Julia Code - `mA = (scalarA .* mX) .+ (scalarB .* mY)` (Using the dot for [Loop Fusion][20]).

![Matrix Addition][02]

### Matrix Multiplication

Multiplication of 2 square matrices after a scalar is added to each.  
 * MATLAB Code - `mA = (scalarA + mX) * (scalarB + mY)`.
 * Julia Code - `mA = (scalarA .+ mX) * (scalarB .+ mY)` (Using the dot for [Loop Fusion][20]).

![Matrix Multiplication][03]

### Matrix Reductions

Set of operations which reduce the matrix dimension (Works along one dimension).  
The operation is done on 2 different matrices on along different dimensions.  
The result is summed with broadcasting to generate a new matrix.

 * MATLAB Code - `mA = sum(mX, 1) + min(mY, [], 2)`.
 * Julia Code - `mA = sum(mX, 1) .+ minimum(mY, 2)` (Using the dot for [Loop Fusion][20]).

![Matrix Reductions][04]
 
### Element Wise Operations
Set of operations which are element wise.

 * MATLAB Code - `mmA = sqrt(abs(mX)) + sin(mY)` and `mB = exp(-(mA .^ 2))`.
 * Julia Code - `mA = sqrt.(abs.(mX)) .+ sin.(mY)` and `mB = exp.(-(mA .^ 2))` (Using the dot for [Loop Fusion][20]). 

![Element Wise Operations][05]

### SVD

Calculation of all 3 SVD Matrices.

 * MATLAB Code - `[mU, mS, mV] = svd(mX)`.
 * Julia Code - `mU, mS, mV = svd(mX, thin = false)`.

![SVD][06]

### Eigen Decomposition

Calculation of 2 Eigen Decomposition Matrices.

 * MATLAB Code - `[mD, mV] = eig(mX)`.
 * Julia Code - `mD, mV = eig(mX)`.

![Eigen Decomposition][07]

### Matrix Inversion

Calculation of the Inverse and Pseudo Inverse of a matrix.

 * MATLAB Code - `mA = inv(mX)` and `mB = pinv(mY)`.
 * Julia Code - `mA = inv(mX)` and `mB = pinv(mY)`.

![Matrix Inversion][08]

### Linear System Solution

Solving a Vector Linear System and a Matrix Linear System.

 * MATLAB Code - `vX = mA \ vB` and `mX = mA \ mB`.
 * Julia Code - `vX = mA \ vB` and `mX = mA \ mB`.

![Linear System Solution][09]

### Linear Least Squares

Solving a Vector Least Squares and a Matrix Least Squares.  
This is combines Matrix Transpose, Matrix Multiplication (Done at onces), Matrix Inversion (Positive Definite) and Matrix Vector / Matrix Multiplication.

 * MATLAB Code - `vX = (mA.' * mA) \ (mA.' * vB)` and `mX = (mA.' * mA) \ (mA.' * mB)`.
 * Julia Code - `vX = (mA.' * mA) \ (mA.' * vB)` and `mX = (mA.' * mA) \ (mA.' * mB)`.

![Linear Least Squares][10]

### Cholesky Decomposition

Calculation of Cholseky Decomposition.

 * MATLAB Code - `mA = chol(mX)`.
 * Julia Code - `mA = chol(mX)`.

![Cholseky Decomposition][11]

### Squared Distance Matrix

Calculation of the Squared Distance Matrix between 2 sets of Vectors.  
Namely, each element in the matrix is the squared distance between 2 vectors.  
This is calculation is needed for instance in the K-Means algorithm.
It is composed of Matrix Reduction operation, Matrix Multiplication and Broadcasting. 

 * MATLAB Code - `mA = sum(mX .^ 2, 1).' - (2 .* mX.' .* mY) + sum(mY .^ 2, 1)`.
 * Julia Code - `mA = sum(mX .^ 2, 1).' .- (2 .* mX.' .* mY) .+ sum(mY .^ 2, 1)` (Using the dot for [Loop Fusion][20]).

![Squared Distance Matrix][12]


## System Configuration
 * CPU - Intel Core I7 6800K @ 3.4 [GHz].
 * Memory - 4 * 8 [GB] 2166 [MHz] (G.Skill F4 2800C-16-8GRK).
 * Mother Board - ASRock X99 Killer (BIOS Version P3.20).

## TODO
 * Check if Julia code is efficient.
 * Add Python (NumPy).
 * Add more tests.

## Remarks
 * I'm not an expert in Julia (Actually was my first time). Hence, if there are way to improve run time, please share. I did took advise from [More Dots: Syntactic Loop Fusion in Julia][20].
 * This is only a small sub set of operations. I will expand it with time. If you have ideas, please share.
 * For each function the output was set to dependent on the calculation which was timed to prevent JIT optimizations which excludes the calculation (MATLAB infers the calculation has no effect on the output and doesn't run it).

 
  [01]: http://imgur.com/jQu6I7d.png
  [02]: http://imgur.com/c9tcpxe.png
  [03]: http://imgur.com/FhiMQuU.png
  [04]: http://imgur.com/d05Zw6r.png
  [05]: http://imgur.com/XRzgznb.png
  [06]: http://imgur.com/yq1F1u9.png
  [07]: http://imgur.com/WppCB1v.png
  [08]: http://imgur.com/WppCB1v.png
  [09]: http://imgur.com/XRzgznb.png
  [10]: http://imgur.com/yq1F1u9.png
  [11]: http://imgur.com/WppCB1v.png
  [12]: http://imgur.com/WppCB1v.png
  [20]: http://julialang.org/blog/2017/01/moredots
