#!/bin/bash

#Fichier de lancement d'un script Gaussian au CBP 

#script gaussian a executer ./cubegen.sh XXX.fchk

if [ "$#" -ne 1 ]; then
  echo "Il manque le fichier fchk"
  exit 1
fi

SCRIPT=$1
echo $SCRIPT
CURR_DIR=$PWD

#dossier de sortie
OUT_DIR=$CURR_DIR/${SCRIPT%.fchk}

#dossier de travail
WORK_DIR=/scratch/$USER/${SCRIPT%.fchk}

mkdir -p $OUT_DIR
cp $SCRIPT $OUT_DIR

#creation du sous-dossier pour l'execution du script
#mkdir -p $WORK_DIR
#Copie du script dans le repertoire de travail
#cp $SCRIPT $WORK_DIR 

#Environnement pour Gaussian
export g09root=/opt
#Chargement de variable
. $g09root/g09/bsd/g09.profile
#definition du dossier de travail
export GAUSS_SCRDIR=$WORK_DIR



#execution du script
#https://gaussian.com/cubegen/
#cubegen 1 MO=Homo $CURR_DIR/$SCRIPT $WORK_DIR/Homo.cube -2 #peu de points
#cubegen 1 MO=Homo $CURR_DIR/$SCRIPT $WORK_DIR/Homo.cube -4 #bcp de points
cubegen 1 MO=Homo $CURR_DIR/$SCRIPT $WORK_DIR/Homo.cube
cubegen 1 MO=Lumo $CURR_DIR/$SCRIPT $WORK_DIR/Lumo.cube

#rapatriement des fichiers dans le home
cp $WORK_DIR/*.cube $OUT_DIR
#cp $(basename $BASH_SOURCE) $OUT_DIR


