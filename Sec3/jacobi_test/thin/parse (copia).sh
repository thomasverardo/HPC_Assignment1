#!/bin/bash

#thin_core, thin_socket

name="core";

#rm thin_${name}.cvs

echo "#np,nx,ny,nz,mlup" > thin_${name}.csv

for filename in ./thin_${name}*; do
	#cat $(basename "$filename") | grep -v ^\# | grep -v '^$' | sed -r 's/^\s+//;s/\s+/,/g' > $(basename "$filename")
	python visualize.py  $(basename "$filename") >> thin_${name}.csv
	#echo  $(basename "$filename" .out).csv
done

