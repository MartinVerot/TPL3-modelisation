#!/bin/bash


#Environnement pour Gaussian
export g09root=/opt
#Chargement de variable
. $g09root/g09/bsd/g09.profile
#definition du dossier de travail
export GAUSS_SCRDIR=$WORK_DIR

SCRIPT=$1
echo $SCRIPT
CURR_DIR=$PWD

#dossier de sortie
OUT_DIR=$CURR_DIR/${SCRIPT%.com}


#dossier de travail
WORK_DIR=/scratch/$USER/${SCRIPT%.com}

for i in $WORK_DIR/*.chk
do
    #conversion pour récupérer les coordonnées de la dernière optimisation au format xyz
	newzmat -ichk -oxyz -step 999 $i ${i%.chk}.opt
	cp *.opt $OUT_DIR
done
