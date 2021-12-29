#!/bin/sh

cd data

for i in {1..100}; do

scp tomve@orfeo:/u/dssc/tomve/fast/2021Assignement01/section1/ring_data/data_thin_core${i}.out /home/thomas/drive/Units/PRIMO\ ANNO/HPC/Assignment1/Sec1/section1/data

done

