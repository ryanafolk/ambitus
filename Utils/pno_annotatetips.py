#!/usr/bin/env python3

import csv # To process tab-delimited files
import numpy # Used for random sampling 
import sys # To process arguments
import subprocess


binlist = [] # List of bins created by phyloclim
weightlist = [] # List of probabilities matched to bins, used for weighted average
midpointlist = [] # List of medians from pno distribution
specieslabellist = {}
specieslist = []
counter = 1

process = 12

try:
	with open('specieslist.csv', 'r') as speciesfile:
		reader=csv.reader(speciesfile, delimiter='\t')
		for row in reader:
			specieslist.append(row[0])
except:
	print("Could not open species list.")

for species in specieslist:
	while counter <= process:
		with open('pno{0}_{1}.csv'.format(process, species), 'r') as datafile:
			reader=csv.reader(datafile, delimiter=',')
			next(reader)
			for row in reader:
				binlist.append(float(row[1]))
				weightlist.append(float(row[2]))
		midpointlist.append('variable{0}={1}'.format(counter,numpy.average(binlist, weights = weightlist))) # Weighted average to get center of distribution
		counter += 1
	
	label = ""
	for x in midpointlist:
		label += (x + ",")
	label = "[&" + label + "]"

	specieslabellist[species] = label

print(specieslabellist)

p = subprocess.Popen('cp tree_labels_midpoints_cleantiplabels.tre tree_labels_midpointsandtips.tre',shell=True)
p.wait() # This forces these shell calls to be sequential 
sys.stdout.flush() # This forces emptying of the buffer, avoiding clashing logfile read/writes

for species in specieslist:
	specieslabel = specieslabellist[species]
	print(species)
	print(specieslabel)
	command = 'sed -i "s/{0}:/{0}{1}:/g" tree_labels_midpointsandtips.tre'.format(species,specieslabel)
	command = command.replace("&","\&")
	print(command)
	p = subprocess.Popen(command,shell=True)
	p.wait() # This forces these shell calls to be sequential 
	sys.stdout.flush() # This forces emptying of the buffer, avoiding clashing logfile read/writes
	


	
