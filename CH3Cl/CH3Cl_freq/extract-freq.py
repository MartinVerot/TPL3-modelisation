#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Trouver les fréquences dans un fichier log créé par Gaussian

./extract-freq.py XXXX.log 
"""

# Importation of libraries 
import numpy as np
import argparse
import re 

# Functions 
# main program 
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--inputfile", type=str, help="fichier log")
    args = parser.parse_args()

    freqList = []
    if args.inputfile is not None:
        with open(args.inputfile) as f:
            #expression régulière pour trouver la ligne qui donne les fréquences
            #on cherche une ligne qui contient "Frequencies --" et de 1 à 3 fréquences 
            find_freq = re.compile('\s*Frequencies\s*--\s*([\d\.]+)?\s?\s*([\d\.]+)?\s?\s*([\d\.]+)?\s?')
            #pour chaque ligne
            for line in f:
                #on cherche si la ligne contient le motif cherché
                isFreq = find_freq.search(line)
                #si c'est le cas, alors on ajoute les fréquences au tableau 
                if isFreq:
                    for freq in isFreq.groups():
                        if freq is not None:
                            freqList.append(freq)
            #On affiche les fréquences
            print(freqList)
    else:
        print('no input file given')

        

