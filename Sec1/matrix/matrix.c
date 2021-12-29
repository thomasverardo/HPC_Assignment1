#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>  
#include <time.h>

void matrixPopulation(int x, int y, int z, double matrix[][y][z]){

    srand(time(NULL));

    for(int i=0; i<x; i++){
        for(int j=0; j<y; j++){
            for(int k=0; k<z; k++){
                matrix[i][j][k] = (double)(rand() % 10000)/(double)(rand() % 100);
            }
        }
    }
}

int main(int argc, char **argv){

    
    int irank, size, root = 0;
    MPI_Init( &argc, &argv );

    MPI_Comm_size( MPI_COMM_WORLD, &size );
    MPI_Comm_rank( MPI_COMM_WORLD, &irank );

    
    int x, y, z, ndims, split_dim;
    // if(irank == root){
        x = atoi(argv[1]);
        y = atoi(argv[2]);
        z = atoi(argv[3]);
        split_dim = (x*y*z)/size;
    // }else{
    //     x = (atoi(argv[1])*atoi(argv[2])*atoi(argv[3]))/size;
    //     y = 0;
    //     z = 0;
    //     split_dim = x;
    // }
    
    
    
    ndims = 3; //3D
    
    int dim[3] = {size, 1, 1}; //x * y * z
    int periods[3] = {1, 1, 1};
    
    double recv_mat1[split_dim], recv_mat2[split_dim], sum_mat[split_dim];
    double mat1[x][y][z], mat2[x][y][z], final_mat[x][y][z];
    int reorder = 1; // Let MPI assign arbitrary ranks if it seems it necessary


    MPI_Dims_create( size , ndims , dim);
    
    MPI_Comm comm_cart; // Create a communicator
    
    MPI_Cart_create( MPI_COMM_WORLD, ndims, dim, periods, reorder, &comm_cart);

    if(irank == root){
        matrixPopulation(x,y,z,mat1);
        matrixPopulation(x,y,z,mat2);
    }

    double time1, time2, time3, time4, total_time;

    MPI_Barrier(MPI_COMM_WORLD);
    time1 = MPI_Wtime();
    
    MPI_Scatter( &mat1 , split_dim , MPI_DOUBLE , &recv_mat1 , split_dim , MPI_DOUBLE , root , MPI_COMM_WORLD);
    MPI_Scatter( &mat2 , split_dim , MPI_DOUBLE , &recv_mat2 , split_dim , MPI_DOUBLE , root , MPI_COMM_WORLD); //comm_cart

    //time2 = MPI_Wtime();

    for(int i=0; i<split_dim; i++){
        sum_mat[i] = recv_mat1[i] + recv_mat2[i];
    }

    //time3 = MPI_Wtime();

    MPI_Gather(&sum_mat, split_dim, MPI_DOUBLE, &final_mat, split_dim, MPI_DOUBLE, root, MPI_COMM_WORLD);

    time4 = MPI_Wtime();

    // if(irank == root){
    //     for(int i=0; i<x; i++){
    //         for(int j=0; j<y; j++){
    //             for(int k=0; k<z; k++){
    //                 //printf("final_mat[%d][%d][%d]: %f", i, j, k, final_mat[i][j][k]);
    //                 printf("%f ", final_mat[i][j][k]);
    //             }
    //             printf("\n");
    //         }
    //         printf("\n");
    //     }
    //     printf("\n");
    // }

    total_time = time4 - time1;
    if(irank == root){
        printf("%d,%f\n",size,total_time);
    }
        

    MPI_Finalize();
    

return 0;
}