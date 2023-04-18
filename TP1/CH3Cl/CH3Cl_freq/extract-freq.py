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
    intensityList = []
    symmetryList = []
    linesList = []
    if args.inputfile is not None:
        lineNumber = 0
        with open(args.inputfile) as f:
            #expression régulière pour trouver la ligne qui donne les fréquences
            #on cherche une ligne qui contient "Frequencies --" et de 1 à 3 fréquences 
            find_freq = re.compile('\s*Frequencies\s*--\s*([\d\.]+)?\s?\s*([\d\.]+)?\s?\s*([\d\.]+)?\s?')
            #on cherche une ligne qui contient "IR Inten --" et de 1 à 3 intensité 
            find_intensity = re.compile('\s*IR Inten\s*--\s*([\d\.]+)?\s?\s*([\d\.]+)?\s?\s*([\d\.]+)?\s?')
            #pour chaque ligne
            find_Symmetry = re.compile('\s*\s*([\w\d\.]+)?\s?\s*([\w\d\.]+)?\s?\s*([\w\d\.]+)?\s?')
            lineNumber = 0
            for line in f:
                #on cherche si la ligne contient le motif cherché
                isFreq = find_freq.search(line)
                isIntensity = find_intensity.search(line) 
                #si c'est le cas, alors on ajoute les fréquences au tableau 
                if isFreq:
                    for freq in isFreq.groups():
                        if freq is not None:
                            freqList.append(freq)
                    linesList.append(lineNumber-1)
                if isIntensity:
                    for intensity in isIntensity.groups():
                        if intensity is not None:
                            intensityList.append(intensity)        
                lineNumber += 1   
        lineNumber = 0
        with open(args.inputfile) as f:
             for line in f:
                 if lineNumber in linesList:
                     isSymmetry = find_Symmetry.search(line)
                     for Symmetry in isSymmetry.groups():
                         symmetryList.append(Symmetry)
                 lineNumber += 1
        #On affiche les fréquences
        #print(symmetryList)
        #print(freqList)
        #print(intensityList)
        for i,symmetry in enumerate(symmetryList):
            print('{}\t{:>10} cm-1 \t {:>7}'.format(symmetry,freqList[i],intensityList[i]))
    else:
        print('no input file given')

        

