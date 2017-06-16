#!/usr/bin/env python3

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# This program controls calls to BayesTraits in a parallel fashion by sampling from niche occupancy over                #
#       single variables.                                                                                               #
# It produces numerous temporary files and a few permanent files of the format XXXXX_runID-YYY.ZZZ.                     #
# All output files contain "_runID-YYY", and may be removed easily with glob expansion.                                 #
# It depends on Python3 and the availability of a bash shell as well as basic UNIX tools like GNU sed.                  #
# Non-default libraries required are: numpy, dendropy.                                                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

import subprocess # To call on bash
import sys # To process arguments
import time # Keep track of runtime
import numpy # Used for random sampling 
import csv # To process tab-delimited files
import multiprocessing # Library for multiprocess functions

import ambitus_main # Main functions for this script
from ambitus_main import shell_call as shell_call
import ambitus_bayestraitscontroller # Module for controlling individual runs of BayesTraits
import ambitus_pno_sampler
import ambitus_pno_annotatetips

print("Ambitus -- software for Bayesian ancestral niche reconstruction.\n")

commands = []

starttime = time.time()

try: # Parse command line arguments
	process = int(sys.argv[1]) # Number of niche variables, = number of runs of BayesTraits per bootstrap
	processortotalnum = int(sys.argv[2]) # Total number of processors available
	bootstraptotal = int(sys.argv[3]) # Number of times to sample random points in variable occupancy ranges
	runID = sys.argv[4] # Run ID to keep track of voluminous outputs
	runID = "_runID-{0}".format(runID)
except: # Handle incorrect argument passing
	print("Error, four arguments must be provided: the number of variables, the number of processors you wish to use, the number of samples for each variable range, and an arbitrary runID string to keep track of outputs.")
	print("Example: python3 ambitus.py 12 4 100 foobar")
	sys.exit()

totalnodenumber = 0	# This will be updated by the GenerateNodeList function
totalnodenumber = ambitus_main.GenerateNodeList(totalnodenumber) # Create BayesTraits command file for the ancestral reconstruction step; this requires that we identify all internal nodes by their terminal descendents

shell_call('mkdir pnos; mkdir output; mkdir sampled_pnos; mkdir temp') 

specieslist = []
try:
	with open('specieslist.csv', 'r') as speciesfile:
		reader=csv.reader(speciesfile, delimiter='\t')
		for row in reader:
			specieslist.append(row[0])
except: 
	print("Error in parsing species list... If files were created on a Mac or Windows machine, verify that end-of-line characters are UNIX-compliant. Also ensure that you have the correct number of environmental variable files.")
	exit()

print("\nPerforming sampling from PNO distributions.")

for x in specieslist:
	processcounter = 1
	while processcounter <= process:
		ambitus_pno_sampler.SampleDistribution(processcounter,bootstraptotal,runID,x) # This runs a function to sample from ecological variable ranges using a uniform distribution
		processcounter += 1

print("Sampling complete.")
print("Time taken: {0} seconds.".format(time.time() - starttime))

print("Formatting sampling output; this could take a while.")

ambitus_pno_sampler.RearrangePNOs(process,bootstraptotal,runID,specieslist)

print("Finished formatting samples for BayesTraits.")
print("Time taken: {0} seconds.".format(time.time() - starttime))

# Enumerate arguments that keep track of file names for parallelization
commandargs = []
x = 1
y = 1
while x <= bootstraptotal:
	while y <= process:
		commandargs.append([y,x,runID])
		y += 1
	y = 1
	x += 1

print("This job will require a total of {0} processes.".format(len(commandargs)))

# This part calls on BayesTraits in parallel	
taskpool = multiprocessing.Pool(processes=processortotalnum)
taskpool.map(ambitus_bayestraitscontroller.bayesproc, commandargs)
taskpool.close()
taskpool.join()

print("Reconstructions completed.")
print("Time taken: {0} seconds.".format(time.time() - starttime))

# The rest of this code calls on functions to summarize the output of BayesTraits
print("Calculating and collating credibility intervals for ecological variables. Currently on internal node (out of {0}):".format(totalnodenumber))
nodelabelcounter = totalnodenumber
rowcounter = 1
while nodelabelcounter >= 1:
	print(nodelabelcounter)
	ambitus_main.CollateMCMC(process,bootstraptotal,runID,rowcounter,nodelabelcounter) # Run a function to calculate CIs (percentile method) and write a tsv for each variable
	nodelabelcounter -= 1 # We count nodes backwards because they are listed backwards in BayesTraits output
	rowcounter += 1

print("Collation complete.")
print("Time taken: {0} seconds.".format(time.time() - starttime))

print("Plotting trees with ancestral and tip values.")
	
ambitus_main.FindPlottingNumbers(totalnodenumber,process,runID) # Average bootstrap output, make tsv for plotting on best tree

ambitus_main.PlotTrees(totalnodenumber,runID) # Average CIs, plot on best tree

ambitus_pno_annotatetips.AnnotateTips(process)

print("Collation complete.")
print("Time taken: {0} seconds.".format(time.time() - starttime))

print("Removing extraneous output files.")

print("Everything is complete.")
print("Time taken: {0} seconds.".format(time.time() - starttime))

answer = input("Remove intermediate files? (y/n): ")
if answer == "y":
	shell_call('rm ./temp/reconstructionclean*{0}.out && rm ./temp/variable*{0}.txt && rm ./temp/node*annotations*{0}.txt'.format(runID)) 
