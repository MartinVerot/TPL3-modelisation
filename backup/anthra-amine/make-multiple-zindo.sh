#!/bin/bash

for i in *-opt/*.opt
do
	echo $i
	./make-zindo.sh $i
done
