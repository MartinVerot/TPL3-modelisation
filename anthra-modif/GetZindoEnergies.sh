#!/bin/bash





for i in *-zindo.com
do
	echo $i
	./energies-zindo.sh ${i%.com}/${i%.com}.log
done
