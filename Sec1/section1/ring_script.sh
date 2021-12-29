#!/bin/sh

#PBS -q dssc
#PBS -l nodes=1:ppn=24
#PBS -l walltime=00:30:00

rm ring_script.sh.*

module load openmpi-4.1.1+gnu-9.3.0

cd /u/dssc/tomve/fast/2021Assignement01/section1/ring_data


mpic++ ring_stats.cpp -o ring_stats

#rm data_thin.out
#rm data_gpu.out
#rm data_core.out
for j in {1..100}; do

for i in {1..24}; do

mpirun -np ${i} --map-by socket ring_stats >> data_thin_socket${j}.out

done

done

