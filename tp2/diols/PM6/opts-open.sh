#!/bin/bash

for i in *open-opt.com
do
	echo $i
	./gaussian.sh $i
done
