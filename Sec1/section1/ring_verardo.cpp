#include <iostream>
#include <mpi.h>

int main(int argc, char **argv ){

    int irank,size;
    MPI_Comm comm1D;
    
    MPI_Init( &argc, &argv );
    
    
    MPI_Comm_size( MPI_COMM_WORLD, &size );
    MPI_Comm_rank( MPI_COMM_WORLD, &irank );
    

    int n_msg = 0; //counter for number messages
    int ndims = 1; //1D ring
    int dims[ndims], period[ndims];

    int tag, send_msgright, send_msgleft, recv_msgright=0, recv_msgleft=0;

    MPI_Status status[4];
    MPI_Request requests[4];

    period[0] = 1; //periodic shift is TRUE
    dims[0] = size; //processor dimension
    
    MPI_Cart_create( MPI_COMM_WORLD, ndims, dims, period, 1, &comm1D );
    
    int coords[1];
    MPI_Cart_coords(comm1D, irank, 1, coords);


    tag=irank*10;

    send_msgright = irank;
    send_msgleft = -irank;

    int dest, source;
    MPI_Cart_shift(comm1D, 1, 1, &source,&dest);


    

    MPI_Isend(&send_msgright, 1, MPI_INT, dest, tag, comm1D, &requests[0]); 
    MPI_Isend(&send_msgleft, 1, MPI_INT, source, tag, comm1D, &requests[2]); 

    MPI_Irecv(&recv_msgright, 1, MPI_INT, source, MPI_ANY_TAG, comm1D, &requests[1]);
    MPI_Irecv(&recv_msgleft, 1, MPI_INT, dest, MPI_ANY_TAG, comm1D, &requests[3]);

    //MPI_Waitall(size, requests, status);

    MPI_Wait(&requests[0], &status[0]);
    MPI_Wait(&requests[1], &status[1]);
    MPI_Wait(&requests[2], &status[2]);
    MPI_Wait(&requests[3], &status[3]);

    while(status[1].MPI_TAG!=tag && status[3].MPI_TAG!=tag){
        send_msgleft = recv_msgleft - irank;
        send_msgright = recv_msgright + irank;
        
        MPI_Isend(&send_msgright, 1, MPI_INT, dest, status[1].MPI_TAG, comm1D, &requests[0]); 
        MPI_Isend(&send_msgleft, 1, MPI_INT, source, status[3].MPI_TAG, comm1D, &requests[2]); 

        MPI_Irecv(&recv_msgright, 1, MPI_INT, source, MPI_ANY_TAG, comm1D, &requests[1]);
        MPI_Irecv(&recv_msgleft, 1, MPI_INT, dest, MPI_ANY_TAG, comm1D, &requests[3]);

        //MPI_Waitall(size, requests, status);

        MPI_Wait(&requests[0], &status[0]);
        MPI_Wait(&requests[1], &status[1]);
        MPI_Wait(&requests[2], &status[2]);
        MPI_Wait(&requests[3], &status[3]);

        n_msg++;

      }
      
      std::cout<<"I am process "<<irank<<" and I have received "<<n_msg<<" messages.";
      std::cout<<" My final messages have tag "<<status[1].MPI_TAG<<" and value "<<recv_msgright<<" AND tag "<<status[1].MPI_TAG<<" and value "<<recv_msgleft<<std::endl;
      
      MPI_Finalize();

      return 0;
}
