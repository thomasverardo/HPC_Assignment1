#!/bin/sh

#PBS -q dssc_gpu
#PBS -l nodes=2:ppn=2
#PBS -l walltime=00:30:00    



cd bench_output/bench_openmpi/

rm *.out

cd /u/dssc/tomve/fast/mpi-benchmarks/src_c


BACK="/u/dssc/tomve/tmp/test/bench_output/bench_openmpi/"


module load openmpi-4.0.5+gnu-9.3.0  
make clean
make

for i in {1..10}; do
mpirun -np 2  --map-by node  ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^\$ >> ${BACK}node_normal.out
done

#^uct because uct(ucx) is not commonly used for MPI point-to-points operation
for i in {1..10}; do
mpirun -np 2 --map-by node --mca pml ucx --mca btl ^uct -x UCX_NET_DEVICES=ib0 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}node_ib0.out
done

for i in {1..10}; do
mpirun -np 2 --map-by node --mca pml ucx --mca btl ^uct -x UCX_NET_DEVICES=br0 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}node_br0.out
done

for i in {1..10}; do
mpirun -np 2 --map-by node --mca pml ucx -mca btl ^uct -x UCX_NET_DEVICES=mlx5_0:1 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}node_mlx5_0.out
done

for i in {1..10}; do
mpirun -np 2 --map-by node --mca pml ob1 --mca btl tcp,self --mca btl_tcp_if_include br0 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}node_tcp.out
done
#(where 0 in UCX_NET_DEVICES=mlx5_0:1 is the InfiniBand interface number; 
#needs to be set for each process running on a specific GPU so they know the closest IB interface to use)
#With UCX_NET_DEVICES you specify the Ethernet port





for i in {1..10}; do
mpirun -np 2 --map-by core ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}core_normal.out
#This is the same with using --mca pml ucx, because ucx (infiniband) is the dafault configuration
done

for i in {1..10}; do
mpirun -np 2 --map-by core --mca pml ob1 --mca btl tcp,self --mca btl_tcp_if_include br0 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}core_tcp.out
done

for i in {1..10}; do
mpirun -np 2 --map-by core --mca pml ob1 --mca btl vader,self ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}core_vader.out
done


for i in {1..10}; do
mpirun -np 2 --map-by socket ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}socket_normal.out
done
#This is the same with using --mca pml ucx, because ucx (infiniband) is the dafault configuration

for i in {1..10}; do
mpirun -np 2 --map-by socket --mca pml ob1 --mca btl tcp,self --mca btl_tcp_if_include br0 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}socket_tcp.out
done

for i in {1..10}; do
mpirun -np 2 --map-by socket --mca pml ob1 --mca btl vader,self ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^$ >> ${BACK}socket_vader.out
done
