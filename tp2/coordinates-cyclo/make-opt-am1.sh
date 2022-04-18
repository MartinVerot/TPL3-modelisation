#!/bin/bash

#Converti un fichier xyz en input gaussian pour effectuer une optimisation de géométrie et un calcul d'énergie

if [ "$#" -ne 1 ]; then
  echo "Il manque le fichier de coordonnee apres optimisation"
  exit 1
fi
if ! [[ -f head-opt-am1 &&  -f  bottom ]]; then
    echo "Il manque le fichier head-opt ou bottom"
    exit 1
fi

SCRIPT=$1
SCRIPT_SHORT=$(basename $SCRIPT)
NAME=${SCRIPT_SHORT%.xyz}
echo $SCRIPT_SHORT


tail -n +3 $SCRIPT > $NAME.cut
echo "%chk=$NAME-opt" > $NAME-opt.com
cat head-opt-am1 $NAME.cut bottom >> $NAME-opt.com
rm $NAME.cut

