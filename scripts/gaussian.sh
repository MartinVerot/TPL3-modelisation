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

mkdir -p $OUT_DIR
cp $SCRIPT $OUT_DIR

#creation du sous-dossier pour l'execution du script
mkdir -p $WORK_DIR
#Copie du script dans le repertoire de travail
cp $SCRIPT $WORK_DIR 

#Environnement pour Gaussian
export g16root=/opt
#Chargement de variable
. $g16root/g16/bsd/g16.profile
#definition du dossier de travail
export GAUSS_SCRDIR=$WORK_DIR



#execution du script
cd $WORK_DIR
g16 $WORK_DIR/$SCRIPT

cd $CURR_DIR


#rapatriement des fichiers dans le home
cp $WORK_DIR/*.log $OUT_DIR
cp $(basename $BASH_SOURCE) $OUT_DIR


for i in `ls $WORK_DIR/*.chk 2>/dev/null` ; do
#if [ ! -e `basename $i .chk`.fchk ] ; then
/opt/g16/formchk $i 2>/dev/null
#fi
done
cp $WORK_DIR/*.fchk $OUT_DIR
#suppression du fichier .chk pour eviter d'encombrer le scratch
#rm $WORK_DIR/*.chk

