#!/bin/bash



for i in *-opt/ 
do
	echo $i
    #conversion pour recuperer les coordonnees de la derniere optimisation au format xyz
    cp $i/*.com .

done

