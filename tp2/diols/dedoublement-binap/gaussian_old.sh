#!/bin/bash

#Fichier de lancement d'un script Gaussian au CBP 

SCRIPT='CH3Cl_SP.com'
CURR_DIR=$PWD

#dossier de sortie
OUT_DIR=$CURR_DIR/${SCRIPT%.com}

#dossier de travail
WORK_DIR=/scratch/$USER/${SCRIPT%.com}

#Creation de l'alias
#alias g09='/scratch/ssteinma/g09'
unalias g09
#alias
#commande pour que les alias marchent
#shopt -s expand_aliases

mkdir -p $OUT_DIR
cp $SCRIPT $OUT_DIR

#creation du sous-dossier pour l'execution du script
mkdir -p $WORK_DIR
#Copie du script dans le repertoire de travail
cp $SCRIPT $WORK_DIR 

#Environnement pour Gaussian
export g09root=/opt
. $g09root/g09/bsd/g09.profile
export GAUSS_SCRDIR=$WORK_DIR



#execution du script
g09 $WORK_DIR/$SCRIPT

#rapatriement des fichiers dans le home
cp $WORK_DIR/*.log $OUT_DIR
cp $(basename $BASH_SOURCE) $OUT_DIR

