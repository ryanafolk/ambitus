#!/usr/bin/env python3

import csv # To process tab-delimited files
import numpy # Used for random sampling 
import sys # To process arguments

input = str(sys.argv[1]) # File name
print(input)
replicatenum = 100
counter = 1

binlist = [] # List of bins created by phyloclim
probabilitylist = [] # List of probabilities matched to bins
samplelist = [] # List of sampled points from distribution

try:
	with open(input, 'r') as datafile:
			reader=csv.reader(datafile, delimiter=',')
			next(reader)
			for row in reader:
				binlist.append(row[1])
				probabilitylist.append(row[2])
except: 
	print("Error in parsing tab-delimited climate datafiles... If files were created on a Mac or Windows machine, verify that end-of-line characters are UNIX-compliant. Also ensure that you have the correct number of environmental variable files.")
	exit()

sample = numpy.random.choice(binlist, size = 100, replace=True, p = probabilitylist) # This is the actual sampling procedure

print(sample)	
