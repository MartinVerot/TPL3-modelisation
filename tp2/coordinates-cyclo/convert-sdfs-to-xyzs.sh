#!/bin/bash

for i in *.sdf
do
    ./sdftoxyz.sh $i
done
