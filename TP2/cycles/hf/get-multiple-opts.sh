#!/bin/bash

for i in *-opt.com
do
	echo $i
	./getOpt.sh $i
done
