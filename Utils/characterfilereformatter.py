#!/usr/bin/env python3

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# This is a simple script to reformat tsv files with point estimates for use.                                           #
# It creates a range of (-10% and + 10%) or any other value, around the point estimate.                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #



import sys # To process arguments
import csv # To process tab-delimited files

try:
	process = int(sys.argv[1])
	percent = float(sys.argv[2])
except: 
	print("This script requires two arguments: the number of variables to use, and the percentage to use for variance around the mean.")
	print("For instance, 'python3 characterfilereformatter.py 20 0.10' would find 20 variable files with point estimates and make 20 new tsv files with ranges +/- 10% of the point estimate.")
	quit()
	
variablenum = 1
lowerboundlist = []
upperboundlist = []
specieslist = []

while variablenum <= process:
	with open('character{0}.txt'.format(variablenum), 'r') as datafile:
		reader=csv.reader(datafile, delimiter='\t')
		for row in reader:
			lowerboundlist.append(float(row[1]))
			upperboundlist = lowerboundlist[:] # Slice due to mutable types
			specieslist.append(row[0])
	lowerboundlistpercent = []
	for l in lowerboundlist:
		l = l - (percent * l)
		lowerboundlistpercent.append(l)
	upperboundlistpercent = []
	for u in upperboundlist:
		u = u + (percent * u)
		upperboundlistpercent.append(u)
	with open('character{0}_ranges.txt'.format(variablenum), 'w+') as writefile:
		writer = csv.writer(writefile, delimiter='\t')
		for a, b, c in zip(specieslist, lowerboundlistpercent, upperboundlistpercent):
			writer.writerow([a, b, c])
	variablenum += 1
	lowerboundlist = []
	upperboundlist = []
	specieslist = []