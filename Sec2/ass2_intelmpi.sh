#!/bin/bash 
 
#PBS -q dssc_gpu
#PBS -l nodes=2:ppn=2
#PBS -l walltime=0:20:00 
 
cd /u/dssc/tomve/fast/mpi-benchmarks/src_c
make clean 
module load intel 
make

#cd $PBS_O_WORKDIR 
#mkdir -p intel_lib
BACK="/u/dssc/tomve/tmp/test/bench_output/bench_intelmpi"

rm {$BACK}/*.out

#Run on close sockets:
#2)mpirun -np 2 -ppn=2 -env I_MPI_DEBUG 5 -genv I_MPI_PIN_PROCESSOR_LIST 0,1 ./IMB-MPI1 PingPong -msglog 4
#-> latency 0.43 -> better openMpi (0.4)
#
#Run on same socket:
#3)mpirun -np 2 -ppn=2 -env I_MPI_DEBUG 5 -genv I_MPI_PIN_PROCESSOR_LIST 0,2 ./IMB-MPI1 PingPong -msglog 4
#-> latency 0.23
#
#Run on 2 nodes:
#4)mpirun -np 2 -f $PBS_NODEFILE -env I_MPI_DEBUG 5 ./IMB-MPI1 PingPong -msglog 4
#-> latency 0.23



#	LEGEND		#
# -f specifies the path to the host file listing the cluster nodes; alternatively, you can use the -hosts option to specify a comma-separated list of nodes; if hosts are not specified, the local node is used
# -ppn sets the number of processes to launch on each node; if the option is not specified, processes are assigned to the physical cores on the first node; if the number of cores is exceeded, the next node is used
# -env I_MPI_DEBUG for debug information
# -genv to set up the enviroment variable to a specified value in all processor
# -genv I_MPI_PIN_PROCESSOR_LIST --> Define a processor subset and the mapping rules for MPI processes within this subset.


for i in {1..10}; do 
    #Default configuration
    mpirun -np 2 -ppn=1 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^\$ >> ${BACK}/def.out
    #Run on 2 nodes:
    mpirun -np 2 -f $PBS_NODEFILE ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^\$ >> ${BACK}/node.out 
    #Run on close sockets:
    mpirun -np 2 -ppn=2 -genv I_MPI_PIN_PROCESSOR_LIST 0,1 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^\$ >> ${BACK}/socket.out 
    #Run on same socket:
    mpirun -np 2 -ppn=2 -genv I_MPI_PIN_PROCESSOR_LIST 0,2 ./IMB-MPI1 PingPong | grep -v ^\# | grep -v ^\$ >> ${BACK}/core.out 
 
done 
cat $PBS_NODEFILE >> ${BACK}/thin_resources_used.out