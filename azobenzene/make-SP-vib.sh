#!/bin/bash





for i in *.opt
do
	echo "%chk=${i%.opt}-SP" > ${i%.opt}-SP.com
    	cat head-SP $i bottom >> ${i%.opt}-SP.com
done
