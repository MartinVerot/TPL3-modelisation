#!/bin/bash

#Fichier de lancement d'un script Gaussian au CBP 

#SCRIPT='CH3Cl_SP.com'
#script gaussian a executer ./gaussian.sh XXX.com 

if [ "$#" -ne 1 ]; then
  echo "Il manque le script gaussian"
  exit 1
fi

SCRIPT=$1
echo $SCRIPT
CURR_DIR=$PWD

#dossier de sortie
OUT_DIR=$CURR_DIR/${SCRIPT%.com}

#dossier de travail
WORK_DIR=/scratch/$USER/${SCRIPT%.com}
#creation du dossier de sortie et copie du fichier d'entrée.
mkdir -p $OUT_DIR
cp $SCRIPT $OUT_DIR

#creation du sous-dossier pour l'execution du script
mkdir -p $WORK_DIR
#Copie du script dans le repertoire de travail
cp $SCRIPT $WORK_DIR 

#Environnement pour Gaussian
export g09root=/opt
#Chargement de variable
. $g09root/g09/bsd/g09.profile
#definition du dossier de travail
export GAUSS_SCRDIR=$WORK_DIR



#execution du script
g09 $WORK_DIR/$SCRIPT

#rapatriement des fichiers dans le home
cp $WORK_DIR/*.log $OUT_DIR
cp $(basename $BASH_SOURCE) $OUT_DIR


for i in `ls $CURR_DIR/*.chk 2>/dev/null` ; do
if [ ! -e `basename $i .chk`.fchk ] ; then
/opt/g09/formchk $i 2>/dev/null
fi
done
