#!/bin/bash

#PBS -q dssc
#PBS -l nodes=1:ppn=24
#PBS -l walltime=00:40:00

module load openmpi-4.1.1+gnu-9.3.0

cd /u/dssc/tomve/fast/2021Assignement01/section1/matrix

# rm data_matrix.out
rm data_matrix.csv
mpicc matrix.c -o matrix

for i in {1..24}; do

for j in {1..10}; do

    mpirun -np ${i} matrix 2400 100 100 >> data_matrix.csv

done

done

for i in {1..24}; do

for j in {1..10}; do

    mpirun -np ${i} matrix 1200 200 100 >> data_matrix.csv

done

done

for i in {1..24}; do

for j in {1..10}; do

    mpirun -np ${i} matrix 800 300 100 >> data_matrix.csv

done

done