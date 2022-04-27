
  
// This program computes a simple version of matrix multiplication
// By: Nick from CoffeeBeforeArch

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <vector>

using std::cout;
using std::generate;
using std::vector;
using namespace std;
__global__ void matrixMul(const int *a, const int *b, int *c, int N) {
  // Compute each thread's global row and column index
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;

    if(row < N && col < N){
        // Iterate over row, and down column
        c[row * N + col] = 0;
        for (int k = 0; k < N; k++) {
            // Accumulate results for a single element
            c[row * N + col] += a[row * N + k] * b[k * N + col];
        }
    }
  
}

// Check result on the CPU
void verify_result(vector<int> &a, vector<int> &b, vector<int> &c, int N) {
  // For every row...
  for (int i = 0; i < N; i++) {
    // For every column...
    for (int j = 0; j < N; j++) {
      // For every element in the row-column pair
      int tmp = 0;
      for (int k = 0; k < N; k++) {
        // Accumulate the partial results
        tmp += a[i * N + k] * b[k * N + j];
      }
      cout << tmp << "\t";
    //   cout << c[i * N + j] << "\t";
      // Check against the CPU result
      assert(tmp == c[i * N + j]);
    }
    cout << endl;
  }
}

int main() {
  // Matrix size of 1024 x 1024;
  int N = 1024*4;
  // Size (in bytes) of matrix
  size_t bytes = N * N * sizeof(int);

  // Host vectors
  vector<int> h_a(N * N);
  vector<int> h_b(N * N);
  vector<int> h_c(N * N);

//   Initialize matrices
//   generate(h_a.begin(), h_a.end(), []() { return rand() % 100; });
//   generate(h_b.begin(), h_b.end(), []() { return rand() % 100; });

//   Initialize matrices    
    generate(h_a.begin(), h_a.end(), []() { return 1; });
    generate(h_b.begin(), h_b.end(), []() { return 2; });

    // for(int i = 0; i<N * N; i++){
    //         h_a[i]=1;
    //         h_b[i]=2;
    // }
    printf("%i\n",N);

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);  
  cudaEventRecord(start);

  // Allocate device memory
  int *d_a, *d_b, *d_c;
  cudaMalloc(&d_a, bytes);
  cudaMalloc(&d_b, bytes);
  cudaMalloc(&d_c, bytes);

  // Copy data to the device
  cudaMemcpy(d_a, h_a.data(), bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b.data(), bytes, cudaMemcpyHostToDevice);

  // Threads per CTA dimension
  int THREADS = 32;

  // Blocks per grid dimension (assumes THREADS divides N evenly)
  int BLOCKS = ceil (N / THREADS);
  printf("%i\n",BLOCKS);
  if(BLOCKS == 0) BLOCKS++;

  // Use dim3 structs for block  and grid dimensions
  dim3 threads(THREADS, THREADS);
  dim3 blocks(BLOCKS, BLOCKS);

  // Launch kernel
  matrixMul<<<blocks, threads>>>(d_a, d_b, d_c, N);

  // Copy back to the host
  cudaMemcpy(h_c.data(), d_c, bytes, cudaMemcpyDeviceToHost);
  cudaEventRecord(stop);
  // Check result
//   verify_result(h_a, h_b, h_c, N);

  cout << "COMPLETED SUCCESSFULLY\n";
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);
  printf("The elapsed time is %f seconds\n", milliseconds/1000);
  // Free memory on device
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;
}
