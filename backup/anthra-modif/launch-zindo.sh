#!/bin/bash

for i in *opt-zindo.com
do
	echo $i
	./gaussian.sh $i
done
