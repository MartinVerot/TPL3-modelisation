#!/bin/bash


#Environnement pour Gaussian
export g09root=/opt
#Chargement de variable
. $g09root/g09/bsd/g09.profile
#definition du dossier de travail
export GAUSS_SCRDIR=$WORK_DIR



for i in *.chk
do
	newzmat -ichk -oxyz -step 999 $i ${i%.chk}.opt
done
