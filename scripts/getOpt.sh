#!/bin/bash


#Environnement pour Gaussian
export g16root=/opt
#Chargement de variable
. $g09root/g16/bsd/g16.profile
#definition du dossier de travail
export GAUSS_SCRDIR=$WORK_DIR

SCRIPT=$1
echo $SCRIPT
CURR_DIR=$PWD

#dossier de sortie
OUT_DIR=$CURR_DIR/${SCRIPT%.com}


#dossier de travail
WORK_DIR=/scratch/$USER/${SCRIPT%.com}

cd $WORK_DIR

echo $WORK_DIR

for i in `ls $WORK_DIR/*.chk 2>/dev/null` 
do
	echo $i
    #conversion pour recuperer les coordonnees de la derniere optimisation au format xyz
	newzmat -ichk -oxyz -step 999 $i ${i%.chk}.opt
done

cp ${WORK_DIR}/*.opt ${OUT_DIR}
cd $CURR_DIR
