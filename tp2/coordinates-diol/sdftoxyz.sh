#!/bin/bash


#converti les fichiers sdf en xyz en utilisant openbabel


obabel -isdf -oxyz $1 -O ${1%.sdf}.xyz 
