#!/bin/bash

for i in *-am1-opt/*.opt
do
	echo $i
	./make-freq-am1.sh $i
done
