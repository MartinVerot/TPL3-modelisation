#!/bin/bash

for i in *-pm3-opt/*.opt
do
	echo $i
	./make-freq-pm3.sh $i
done
