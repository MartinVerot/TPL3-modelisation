#!/bin/bash

for i in *-pm6-opt/*.opt
do
	echo $i
	./make-freq-pm6.sh $i
done
