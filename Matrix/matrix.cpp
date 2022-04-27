
/*
 * This C++ program can multiply any two square or rectangular matrices.
 * The below program multiplies two square matrices of size 4 * 4.
 * There is also an example of a rectangular matrix for the same code (commented below).
 * We can change the Matrix value with the number of rows and columns (from MACROs) for Matrix-1
 * and Matrix-2 for different dimensions.
 */
 
/*
 * Note:  i- The number of columns in Matrix-1 must be equal to the number of rows in Matrix-2.
 *       ii- Output of multiplication of Matrix-1 and Matrix-2, results with equal to the number
 *           of rows of Matrix-1 and the number of columns of Matrix-2 i.e. rslt[R1][C2].
 */
 
#include <iostream>
#include <time.h>       // for clock_t, clock(), CLOCKS_PER_SEC
 
using namespace std;
 
// Edit MACROs here, according to your Matrix Dimensions for mat1[R1][C1] and mat2[R2][C2]
#define R1 4            // number of rows in Matrix-1
#define C1 4            // number of columns in Matrix-1
#define R2 4            // number of rows in Matrix-2
#define C2 4            // number of columns in Matrix-2
 
void mulMat(int **mat1, int **mat2, int **rslt) {
 
    cout << "Multiplication of given two matrices is:\n" << endl;
 
    for (int i = 0; i < R1; i++) {
        for (int j = 0; j < R1; j++) {
            rslt[i][j] = 0;
 
            for (int k = 0; k < R1; k++) {
                rslt[i][j] += mat1[i][k] * mat2[k][j];
            }
 
            cout << rslt[i][j] << "\t";
        }
 
        cout << endl;
    }
}

int main(void) {
    // Square Matrices
    // R1 = 4, C1 = 4 and R2 = 4, C2 = 4 (Update these values in MACROs)
    
    
   
    int **mat1;
 
    int **mat2;
    int **rslt;
    // Reserva de Memoria 
	mat1 = (int **)malloc(R1*sizeof(int*)); 
	mat2 = (int **)malloc(R1*sizeof(int*)); 
	rslt = (int **)malloc(R1*sizeof(int*)); 
	
	for (int i=0;i<R1;i++){
		mat1[i] = (int*)malloc(R1*sizeof(int)); 
		mat2[i] = (int*)malloc(R1*sizeof(int)); 
		rslt[i] = (int*)malloc(R1*sizeof(int)); 

    }

    

    for(int i = 0; i<R1; i++){
        for(int j = 0; j<R1; j++){
            mat1[i][j]=1;
            mat2[i][j]=2;
        }
    }
    double time_spent = 0.0;
 
    clock_t begin = clock();
 
    mulMat(mat1, mat2,rslt);
    clock_t end = clock();
    time_spent += (double)(end - begin) / CLOCKS_PER_SEC;
    printf("The elapsed time is %f seconds\n", time_spent);
    return 0;
}