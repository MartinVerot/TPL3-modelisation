#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Il manque le fichier de coordonnee apres optimisation"
  exit 1
fi
if ! [[ -f head-pm6-freq &&  -f  bottom ]]; then
    echo "Il manque le fichier head-zindo ou bottom"
    exit 1
fi

SCRIPT=$1
SCRIPT_SHORT=$(basename $SCRIPT)
echo $SCRIPT_SHORT

echo "%chk=${SCRIPT_SHORT%.opt}-freq" > ${SCRIPT_SHORT%.opt}-pm6-freq.com
cat head-pm6-freq $1 bottom >> ${SCRIPT_SHORT%.opt}-pm6-freq.com



