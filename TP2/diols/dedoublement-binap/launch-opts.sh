#!/bin/bash

for i in *-opt.com
do
	echo $i
	./gaussian.sh $i
done
