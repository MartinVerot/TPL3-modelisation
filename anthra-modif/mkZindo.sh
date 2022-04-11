#!/bin/bash





for i in *.opt
do
	echo "%chk=${i%.opt}-zindo" > ${i%.opt}-zindo.com
    	cat head $i bottom >> ${i%.opt}-zindo.com
done
