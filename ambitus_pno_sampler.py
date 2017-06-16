#!/usr/bin/env python3

import csv # To process tab-delimited files
import numpy # Used for random sampling 
import sys # To process arguments
from ambitus_main import shell_call as shell_call

def SampleDistribution(process,bootstraptotal,runID,species):
	input = './pnos/pno{0}_{1}.csv'.format(process,species)
	
	binlist = [] # List of bins created by phyloclim
	probabilitylist = [] # List of probabilities matched to bins
	
	try:
		with open(input, 'r') as datafile:
				reader=csv.reader(datafile, delimiter=',')
				next(reader)
				for row in reader:
					binlist.append(float(row[1]))
					probabilitylist.append(float(row[2]))
	except: 
		print('PNO {0} file not found for the species {1}.'.format(process,species))
		print('Ensure that you have named these correctly; they will be treated as missing data.')
		return
	
	# The following code handles rounding error of bin probabilities, which can be fairly high in phyloclim, and fixes probabilities by spreading the error evenly across bins
	sum = numpy.sum(probabilitylist)
	if sum > 1:
		correction = (sum - 1) / len(probabilitylist) # Calculate how much probabilities observed exceed one and calculate a correction value
		if correction > 1e-10: # Check if rounding error is outside of tolerances
			probabilitylistfixed = []
			for x in probabilitylist:
				y = x - correction
				probabilitylistfixed.append(y)
		else: 
			probabilitylistfixed = probabilitylist 
	elif sum < 1:
		correction = (1 - sum) / len(probabilitylist) # Calculate how much probabilities observed fall short of one and calculate a correction value
		if correction > 1e-10: # Check if rounding error is outside of tolerances
			probabilitylistfixed = []
			for x in probabilitylist:
				y = x + correction
				probabilitylistfixed.append(y)
		else:
			probabilitylistfixed = probabilitylist
	else:
		probabilitylistfixed = probabilitylist	
	
	for index, value in enumerate(probabilitylistfixed):
		if value < 0: 
			probabilitylistfixed[index] = 0
			probabilitylistfixed[probabilitylistfixed.index(max(probabilitylistfixed))] += value # This code is to deal with rounding error correction when it causes a negative value... add difference to highest bin
	
	sample = numpy.random.choice(binlist, size = bootstraptotal, replace=True, p = probabilitylistfixed) # This is the actual sampling procedure

	with open('./sampled_pnos/pno{0}_sampled_{1}{2}.txt'.format(process,species,runID), 'w+') as writefile:
		writer = csv.writer(writefile, delimiter='\t')
		for w in sample:
			writer.writerow([w])
			
def RearrangePNOs(process,bootstraptotal,runID,specieslist):
	counterprocess = 1 
	pnodata = {}
	while counterprocess <= process:
		counterboot = 1
		while counterboot <= bootstraptotal:
			pnodata = {}
			for species in specieslist:
				with open('./sampled_pnos/pno{0}_sampled_{1}{2}.txt'.format(counterprocess,species,runID), 'r') as datafile:
					datafilelist = []
					reader=csv.reader(datafile, delimiter=',')
					for row in reader:
						row = "".join(row)
						datafilelist.append(row)
					pnodata[species] = datafilelist[counterboot - 1] # Subtract one since indices start at zero.
				with open('./temp/character{0}_boot{1}{2}.txt'.format(counterprocess,counterboot,runID), 'a') as writefile:
					datapoint = pnodata[species]
					writer = csv.writer(writefile, delimiter='\t')
					writer.writerow([species,datapoint])
			counterboot += 1
		counterprocess += 1
		
