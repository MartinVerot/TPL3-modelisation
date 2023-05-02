#!/usr/bin/python

from sys import argv
import numpy as np
import matplotlib.pyplot as plt

periodic_table = {1:'H', 2:'He', 
                  3:'Li', 4:'Be', 5:'B', 6:'C', 7:'N', 8:'O', 9:'F', 10:'Ne',
                  11:'Na', 12:'Mg', 13:'Al', 14:'Si', 15:'P', 16:'S', 17:'Cl', 18:'Ar',
                  19:'K', 20:'Ca', 21:'Sc', 22:'Ti', 23:'V', 24:'Cr', 25:'Mn', 26:'Fe', 27:'Co', 28:'Ni', 29:'Cu', 30:'Zn', 31:'Ga', 32:'Ge', 33:'As', 34:'Se', 35:'Br', 36:'Kr',
                  37:'Rb', 38:'Sr', 39:'Y', 40:'Zr', 41:'Nb', 42:'Mo', 43:'Tc', 44:'Ru', 45:'Rh', 46:'Pd', 47:'Ag', 48:'Cd', 49:'In', 50:'Sn', 51:'Sb', 52:'Te', 53:'I', 54:'Xe',
                  55:'Cs', 56:'Ba', 57:'La', 
                  58:'Ce', 59:'Pr', 60:'Nd', 61:'Pm', 62:'Sm', 63:'Eu', 64:'Gd', 65:'Tb', 66:'Dy', 67:'Ho', 68:'Er', 69:'Tm', 70:'Yb', 71:'Lu',
                  72:'Hf', 73:'Ta', 74:'W', 75:'Re', 76:'Os', 77:'Ir', 78:'Pt', 79:'Au', 80:'Hg', 81:'Tl', 82:'Pb', 83:'Bi', 84:'Po', 85:'At', 86:'Rn',
                  87:'Fr', 88:'Ra', 89:'Ac',
                  90:'Th', 91:'Pa', 92:'U', 93:'Np', 94:'Pu', 95:'Am', 96:'Cm', 97:'Bk', 98:'Cf', 99:'Es', 100:'Fm', 101:'Md', 102:'No', 103:'Lr',
                  104:'Rf', 105:'Db', 106:'Sg', 107:'Bh', 108:'Hs', 109:'Mt', 110:'Ds', 111:'Rg', 112:'Cn', 113:'Nh', 114:'Fl', 115:'Mc', 116:'Lv', 117:'Ts', 118:'Og'}

input_file = argv[1]

if input_file.endswith(".log"):
    input_log = open(input_file, 'r')
    basename = input_file.split('.')[0]
    log_lines = input_log.readlines()
    input_log.close()
    
    # Starting atom variables empty to avoid 'NameError'
    scan_param = '0.0'
    mod_atom_sym1 = '0.0'
    mod_atom_sym2 = '0.0'
    mod_atom_sym3 = '0.0'
    mod_atom_sym4 = '0.0'
    atom1 = '0.0'
    atom2 = '0.0'
    atom3 = '0.0'
    atom4 = '0.0'

    coord_data = [ ]
    coord_data_LoL = [ ]
    scf_data = [ ]
    
    # Flags start 'off'.
    mod_flag = 0
    xyz_flag = 0
    dash_flag = 0

    for line in log_lines:
        if 'ModRedundant' in line:
            mod_flag = 1
        if mod_flag == 1 and 'ModRedundant' not in line:
            mod_info = line.split()
            mod_flag = 0
            if len(mod_info) == 6:
                scan_param = 'distance'
                atom1 = int(mod_info[1])
                atom2 = int(mod_info[2])
            elif len(mod_info) == 7:
                scan_param = 'angle'
                atom1 = int(mod_info[1])
                atom2 = int(mod_info[2])
                atom3 = int(mod_info[3])
            elif len(mod_info) == 8:
                scan_param = 'dihedral'
                atom1 = int(mod_info[1])
                atom2 = int(mod_info[2])
                atom3 = int(mod_info[3])
                atom4 = int(mod_info[4])
        if 'Coordinates (Angstroms)' in line:
        # Anchor point in log file.
            xyz_flag = 1
            coord_data = [ ]
        if xyz_flag == 1 and '---' in line:
            if dash_flag == 0:
            # First dashed line after anchor and before coordinates.
                dash_flag = 1
            elif dash_flag == 1:
            # Second dashed line after anchor and coords, turn flags off.
                xyz_flag = 0
                dash_flag = 0
        if xyz_flag == 1 and dash_flag == 1 and '---' not in line:
            coord_data = coord_data + [line]

        if 'SCF Done' in line:
            energy = float(line.split()[4])

        if 'Optimization completed' in line:
        # Only grab SCF energy for optimized structure.
            scf_data = scf_data + [energy]
            coord_data_LoL = coord_data_LoL + [coord_data]
            # Reset geometry list.
            coord_data = [ ]
    
    counter = 1
    for geom in coord_data_LoL:
        if counter < 10: counter = '0' + str(counter) output_name = basename + '_step-' + str(counter) + '.xyz' # Will overwrite xyz files with this exact name. output_xyz = open(output_name,'w') output_xyz.write(str(len(geom)) + '\n') output_xyz.write(basename + '_step-' + str(counter) + '.xyz' + ' SCF Energy = ' + str(scf_data[int(counter) - 1]) + '\n') for atom in geom: atom_num = atom.split()[0] if scan_param == 'distance': if atom_num == str(atom1): mod_atom_sym1 = periodic_table[int(atom.split()[1])] if atom_num == str(atom2): mod_atom_sym2 = periodic_table[int(atom.split()[1])] elif scan_param == 'angle': if atom_num == str(atom1): mod_atom_sym1 = periodic_table[int(atom.split()[1])] if atom_num == str(atom2): mod_atom_sym2 = periodic_table[int(atom.split()[1])] if atom_num == str(atom3): mod_atom_sym3 = periodic_table[int(atom.split()[1])] elif scan_param == 'dihedral': if atom_num == str(atom1): mod_atom_sym1 = periodic_table[int(atom.split()[1])] if atom_num == str(atom2): mod_atom_sym2 = periodic_table[int(atom.split()[1])] if atom_num == str(atom3): mod_atom_sym3 = periodic_table[int(atom.split()[1])] if atom_num == str(atom4): mod_atom_sym4 = periodic_table[int(atom.split()[1])] atom_sym = periodic_table[int(atom.split()[1])] X_coord = '%10.5f' % float(atom.split()[3]) Y_coord = '%10.5f' % float(atom.split()[4]) Z_coord = '%10.5f' % float(atom.split()[5]) # Padding the xyz lines to match Gaussian input format. XYZ_string = '%-3s' '%16s' '%16s' '%16s' % (atom_sym, X_coord, Y_coord, Z_coord) # Writing optimized .xyz files. output_xyz.write(XYZ_string + '\n') counter = int(counter) + 1 # Writing output .csv file if steps have been taken. if len(scf_data) > 0:
        output_csv = open(basename + '.csv','w')
        output_csv.write('Scan step' + ',' + 'SCF Energy' + '\n')
        for i in range(len(scf_data)):
            output_csv.write(str(i + 1) + ',' + str(scf_data[i]) + '\n')
   	
	# Creating matplotlib data.
	steps = range(0, len(scf_data))
	plt.plot(steps, scf_data,'ro')
	plt.axis([0, len(scf_data) + 1, 1.00001 * min(scf_data), 0.99999 * max(scf_data)])
	# Turn offset 'off' since y axis is large numbers not changing much.
	# This is needed to show y axis tick marks correctly.
	plt.ticklabel_format(useOffset = False)
	plt.grid(True)
	plt.xlabel('Step number')
	plt.ylabel('SCF energy (hartrees)')
	# Sets the plot perfectly in the view window.
	plt.tight_layout()
	plt.show()
    
	# Printing information to screen.
    print ''
    print 'Parsing through input log file: ' + input_file
    if len(scf_data) == 0:
        print 'No optimization steps found'
    else:
        print str(len(scf_data)) + ' optimizations completed.'
    if scan_param == 'distance':
        print 'Extracting all optimized geometries and SCF energies for the distance scan between ' + mod_atom_sym1 + str(atom1) + ' - ' + mod_atom_sym2 + str(atom2)
    elif scan_param == 'angle':
        print 'Extracting all optimized geometries and SCF energies for the angle scan between ' + mod_atom_sym1 + str(atom1) + ' - ' + mod_atom_sym2 + str(atom2) + ' - ' + mod_atom_sym3 + str(atom3)
    elif scan_param == 'dihedral':
        print 'Extracting all optimized geometries and SCF energies for the dihedral scan between ' + mod_atom_sym1 + str(atom1) + ' - ' + mod_atom_sym2 + str(atom2) + ' - ' + mod_atom_sym3 + str(atom3) + ' - ' + mod_atom_sym4 + str(atom4)
    print ''

else:
    print ''
    print 'Please provide a Gaussian .log file from a modredundant scan as input.'
    print ''
 
