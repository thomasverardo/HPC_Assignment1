In this section there are two folder: "matrix" folder with the code of the 1.2 exercise and the "section1" folder with the 1.1 exercise (ring)

To compile them 
```
mpic++ section1/ring_verardo.cpp -o ring_stats
mpicc matrix/matrix1D.c -o matrix
mpicc matrix/matrix2D.c -o matrix
mpicc matrix/matrix3D.c -o matrix
```

To execute
```
#specify the number of processors
mpirun -np (nprocs) ./ring_verardo
mpirun -np (nprocs) ./matrix1D 2400 100 100
mpirun -np (nprocs) ./matrix2D 2400 100 100
mpirun -np (nprocs) ./matrix3D 2400 100 100
```
