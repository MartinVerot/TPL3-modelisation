#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Il manque le fichier de coordonnee apres optimisation"
  exit 1
fi
if ! [[ -f head-zindo &&  -f  bottom ]]; then
    echo "Il manque le fichier head-zindo ou bottom"
    exit 1
fi

SCRIPT=$1
SCRIPT_SHORT=$(basename $SCRIPT)
echo $SCRIPT_SHORT

echo "%chk=${SCRIPT_SHORT%.opt}-zindo" > ${SCRIPT_SHORT%.opt}-zindo.com
cat head-zindo $1 bottom >> ${SCRIPT_SHORT%.opt}-zindo.com



