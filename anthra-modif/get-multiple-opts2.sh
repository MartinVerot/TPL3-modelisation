#!/bin/bash


#Environnement pour Gaussian
export g09root=/opt
#Chargement de variable
. $g09root/g09/bsd/g09.profile
#definition du dossier de travail




CURR_DIR=$PWD


for i in `ls *-opt.com 2>/dev/null` 
do
	#dossier de travail
	SHORT=${i%.com}
	WORK_DIR=/scratch/$USER/$SHORT
	echo $WORK_DIR
	echo $WORK_DIR/$SHORT.chk
	echo ''
	export GAUSS_SCRDIR=$WORK_DIR
    #conversion pour recuperer les coordonnees de la derniere optimisation au format xyz
	echo "newzmat -ichk -oxyz -step 999 $WORK_DIR/${SHORT}.chk $WORK_DIR/${SHORT}.opt"
	#newzmat -ichk -oxyz -step 999 $WORK_DIR/${SHORT}.chk $WORK_DIR/${SHORT}.opt
	newzmat -ichk -oxyz -step 999 /scratch/mverot/anthracene-2-7-opt/anthracene-2-7-opt.chk /scratch/mverot/anthracene-2-7-opt/anthracene-2-7-opt.opt
	cp $WORK_DIR/*.opt $CURR_DIR
done

cd $CURR_DIR
