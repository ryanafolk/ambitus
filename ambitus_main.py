#!/usr/bin/env python3

import subprocess # To call on bash
import sys # To process arguments
import time # Keep track of runtime
import numpy # Used for random sampling 
import csv # To process tab-delimited files
import dendropy # To process trees

# Shorthand for a shell command. p.wait() and sys.stdout.flush() prevent clashing writes to log files due to buffering.
def shell_call(command):
	p = subprocess.Popen(command, shell=True)
	p.wait()
	sys.stdout.flush() 

# This function finds all internal non-root nodes in the tree, and recursively finds all of their descendent terminal taxa; this is necessary because BayesTraits identifies nodes by a MRCA method
def GenerateNodeList(totalnodenumber):
	print("Discovering all internal non-root nodes in the given plotting tree and listing their descendent terminal nodes.")
	print("This information is used by BayesTraits to perform ancestral reconstruction.")
	
	tree = dendropy.Tree.get(path="plottree.tre", schema="nexus", preserve_underscores=True)
	
	nodelist = []
	taxonlist = []
	
	for node in tree.preorder_node_iter():
		if node.parent_node is None: # We do not wish to reconstruct the basal node
			pass
		def childrecursive(taxonlist,node): # A recursive approach is necessary to iterate through children of children until we have arrived at all tips
			for child in node.child_node_iter():
				if child.is_leaf():
					taxonlist.append(child.taxon.label)
				elif child.is_internal():
					childrecursive(taxonlist,child) # Cannot use node from before, will get infinite recursion; must use child node
		childrecursive(taxonlist,node)
		if len(taxonlist) > 1:
			nodelist.append(" ".join(taxonlist))
		taxonlist = []
	
	totalnodenumber = len(nodelist)
	print("Found {0} internal non-root nodes.".format(totalnodenumber))
	print("Saving to BayesTraits command file.")
	
	with open('new_reconstruction.command', 'x+') as writefile:
		writer = csv.writer(writefile, delimiter=' ')	
		MRCA = "MRCA"
		nodenumber = 0
		nodename = ""
		for x in nodelist:
			nodenumber += 1
			nodename = "node{0}".format(nodenumber)
			writer.writerow([MRCA,nodename,x])
	
	shell_call('sed \'s/\"//g\' new_reconstruction.command > reconstructionnodelist.command') # Creates a command file for a given run; needed to prevent clashing writes to the .bin file
	shell_call('cat template_reconstruction.command reconstructionnodelist.command template2_reconstruction.command > reconstruction.command') # This round-about method is needed because the numerical arguments for BayesTraits have encoding issues
	shell_call("rm new_reconstruction.command") # Creates a command file for a given run; needed to prevent clashing writes to the .bin file
	return (totalnodenumber)

# DEPRECTATED: This function performs the ecological range sampling and outputs sampled character tsv files that BayesTraits can operate on
def UniformRangeSampling(process,bootstraptotal,runID):
	lowerboundlist = [] # This collects a list of lower range boundaries from column 2 of tsv files
	upperboundlist = [] # This collects a list of upper range boundaries from column 3 of tsv files
	specieslist = [] # This collects the taxon list from column 1 of tsv files
	samplelist = [] # This is temporary storage for values sampled from the given distribution
	bootstrapnum = 1 # This is a counter to keep track of the bootstrap number we are on; also informs file names
	variablenum = 1 # This is a counter to keep track of the variable number we are on; also informs file names
	print("Sampling procedure: Sampling with uniform distribution on variable ranges.")
	while variablenum <= process:
		while bootstrapnum <= bootstraptotal:
			# This reads climate data files as tab-delimited, harvesting columns as lists
			try:
				with open('character{0}_ranges.txt'.format(variablenum), 'r') as datafile:
					reader=csv.reader(datafile, delimiter='\t')
					for row in reader:
						lowerboundlist.append(row[1])
						upperboundlist.append(row[2])
						specieslist.append(row[0])
			except: 
				print("Error in parsing tab-delimited climate datafiles... If files were created on a Mac or Windows machine, verify that end-of-line characters are UNIX-compliant. Also ensure that you have the correct number of environmental variable files.")
				exit()
			
			for x, y in zip(lowerboundlist, upperboundlist):
				sample = numpy.random.uniform(x,y) # This is the actual sampling procedure
				samplelist.append(float(sample))
				
			with open('character{0}_boot{1}{2}.txt'.format(variablenum,bootstrapnum,runID), 'w+') as writefile:
				writer = csv.writer(writefile, delimiter='\t')
				for w, z in zip(specieslist, samplelist):
					writer.writerow([w,z])
				
			lowerboundlist = []
			upperboundlist = []
			specieslist = []
			samplelist = []
			bootstrapnum += 1
		print("Variable {0} finished.".format(variablenum))
		bootstrapnum = 1
		variablenum += 1
	return (process,bootstraptotal,runID)

# This function reads the BayesTraits output and calculates CIs based on a simple percentile method, on a per-sample, per-variable basis
def CollateMCMC(process,bootstraptotal,runID,rownumber,nodelabelcounter):
	processcounter = 1
	bootstrapcounter = 1
	MCMCreaderlist = []
	rowposition = rownumber + 6 # This offset is needed to ignore columns that do not contain ancestral values. The numbering starts at zero, and this counter variable was initialized as one, hence the first nodal value is in the 8th column
	while processcounter <= process:
		processnames = []
		lowerpercentiles = []
		upperpercentiles = []
		weightedmidpoints = []
		while bootstrapcounter <= bootstraptotal:
			try:
				with open('./temp/reconstructionclean{0}_boot{1}{2}.out'.format(processcounter,bootstrapcounter,runID), 'r') as datafile:
					reader=csv.reader(datafile, delimiter='\t')
					for row in reader:
						MCMCreaderlist.append(float(row[rowposition]))
			except: 
				print("Error in parsing BayesTraits output. Ensure that the output files contain tab-delimited MCMC output. On file:")
				print('./temp/reconstructionclean{0}_boot{1}{2}.out'.format(processcounter,bootstrapcounter,runID))
				exit()
				
			processnames.append("variable{0}_boot{1}".format(processcounter,bootstrapcounter))
			lowerpercentiles.append(numpy.percentile(MCMCreaderlist, 2.5))
			weightedmidpoints.append(numpy.percentile(MCMCreaderlist, 50))
			upperpercentiles.append(numpy.percentile(MCMCreaderlist, 97.5))
			MCMCreaderlist = []
			
			nodename = "_node{0}".format(nodelabelcounter)
			with open('./temp/variable{0}_bootstrap_CIs{1}{2}.txt'.format(processcounter,nodename,runID), 'w+') as writefile:
				writer = csv.writer(writefile, delimiter='\t')
				for w, x, y, z in zip(processnames,lowerpercentiles,weightedmidpoints,upperpercentiles):
					writer.writerow([w, x, y, z])
			bootstrapcounter += 1
		processcounter += 1
		bootstrapcounter = 1

# This function consolidates the output of the previous function, and outputs a tsv with averages of MCMC summaries across all range samples, on a per-variable basis
def FindPlottingNumbers(totalnodenumber,totalvariablenumber,runID):
	currentnodenumber = 1		
	print("Averaging sampling output to plot on the tree.")
	while currentnodenumber <= totalnodenumber:
		currentvariablenumber = 1
		lowerboundlist = []
		weightedmidpoint = []
		upperboundlist = []
		CIdifference = []
		averagelowerboundlist = []
		averageweightedmidpointlist = []
		averageupperboundlist = []
		averageCIdifference = []
		while currentvariablenumber <= totalvariablenumber:
			try:
				with open('./temp/variable{0}_bootstrap_CIs_node{1}{2}.txt'.format(currentvariablenumber,currentnodenumber,runID), 'r') as datafile:
					reader=csv.reader(datafile, delimiter='\t')
					for row in reader:
						lowerboundlist.append(float(row[1]))
						weightedmidpoint.append(float(row[2]))
						upperboundlist.append(float(row[3]))
						CIdifference.append(float(row[3]) - float(row[1]))
			except: 
				print("Cannot find/read CIs for samples; confirm that the MCMC summary worked correctly. On file:")
				print('./temp/variable{0}_bootstrap_CIs_node{1}{2}.txt'.format(currentvariablenumber,currentnodenumber,runID))
				exit()
			averagelowerboundlist.append(numpy.mean(lowerboundlist))
			averageweightedmidpointlist.append(numpy.mean(weightedmidpoint))
			averageupperboundlist.append(numpy.mean(upperboundlist))
			averageCIdifference.append(numpy.mean(CIdifference))
			lowerboundlist = []
			weightedmidpoint = []
			upperboundlist = []
			CIdifference = []
			currentvariablenumber += 1
		
		with open('./temp/node{0}_annotations{1}.txt'.format(currentnodenumber, runID), 'w+') as writefile:
			writer = csv.writer(writefile, delimiter='\t')
			for x, y, z, w in zip(averagelowerboundlist,averageweightedmidpointlist,averageupperboundlist, averageCIdifference):
				writer.writerow([x, y, z, w])
		currentnodenumber += 1
		
# This function plots support values at nodes and exports two tree in Nexus format: one with 50th percentiles and one with ranges
def PlotTrees(totalnodenumber,runID):

	tree = dendropy.Tree.get(path="plottree.tre", schema="nexus", preserve_underscores=True, rooting='force-rooted') # Forcing rooting takes care of issue in early versions where the root was collapsed to a trifurcation

	# This reads the all the nodes and their respective descendents, created earlier for BayesTraits
	NODElist = []
	MRCAlist = []
	rownumber = 1
	try:
		with open('reconstructionnodelist.command', 'r') as datafile:
			reader=csv.reader(datafile, delimiter=' ')
			for row in reader:
				for r in row:
					MRCAlist.append(r)
				rownumber += 1
				NODElist.append(MRCAlist[2:])
				MRCAlist = []
	except: 
		print("Cannot find/read ancestral node list (reconstructionnodelist.command). Confirm that this file is intact and nonempty.")
		exit()

	nodecounter = 1
	midpointlist = []
	rangelist = []
	midpointlistALLNODES = []
	rangelistALLNODES = []

	while nodecounter <= totalnodenumber: 
		try:
			with open('./temp/node{0}_annotations{1}.txt'.format(nodecounter,runID), 'r') as datafile:
				reader=csv.reader(datafile, delimiter='\t')
				for row in reader:
					midpointlist.append([row[1],row[3]])
					rangelist.append("{" + row[0] + "," + row[2] + "}")
				midpointlistALLNODES.append(midpointlist[:])
				rangelistALLNODES.append(rangelist[:])
				midpointlist = []
				rangelist = []	
		except: 
			print("Cannot find/read tsv file corresponding to node annotations. On file:")
			print('./temp/node{0}_annotations{1}.txt'.format(nodecounter,runID))
			exit()
		nodecounter += 1

	# This is a sanity check: If these lists do not have the same number of elements, then tree annotation will be incorrect but will appear to work
	if len(NODElist) != totalnodenumber:
		print("The number of nodes does not match the number of MRCA list elements!")
		exit()
	if len(midpointlistALLNODES) != totalnodenumber:
		print("The number of nodes does not match the number of midpoint annotation elements!")
		exit()	
	if len(rangelistALLNODES) != totalnodenumber:
		print("The number of nodes does not match the number of range annotation elements!")
		exit()	
	
	print("Building labeled trees with ancestral midpoint values.")
	# BUILD LABELED TREES WITH MIDPOINTS
	# This gives us a FigTree-formatted tree file with multiple labels per node
	midpointlabellist = []
	midpointlabel = ""
	for m in midpointlistALLNODES:
		labelcounter = 1
		for a in m:
			midpointlabel += ("variable{0}=".format(labelcounter) + str(a[0]) + "," + "CI{0}=".format(labelcounter) + str(a[1]) + ",")
			labelcounter += 1
		midpointlabel = "[&" + midpointlabel + "]"
		midpointlabellist.append(midpointlabel)
		midpointlabel = ""

	for (node,midpoint) in zip(NODElist,midpointlabellist):
		MRCA = tree.mrca(taxon_labels=node)
		MRCA.label = midpoint

	tree.write_to_path("tree_labels_midpoints.tre", schema="nexus")

	print("Building labeled trees with ancestral CIs.")
	# BUILD LABELED TREES WITH RANGES
	# This gives us a FigTree-formatted tree file with multiple labels per node
	rangelabellist = []
	rangelabel = ""
	for m in rangelistALLNODES:
		labelcounter = 1
		for a in m:
			rangelabel += ("variable{0}=".format(labelcounter) + str(a) + ",")
			labelcounter += 1
		rangelabel = "[&" + rangelabel + "]"
		rangelabellist.append(rangelabel)
		rangelabel = ""

	for (node,range) in zip(NODElist,rangelabellist):
		MRCA = tree.mrca(taxon_labels=node)
		MRCA.label = range

	tree.write_to_path("tree_labels_ranges.tre", schema="nexus")

	# CLEAN UP LABELED TREES FOR FIGTREE
	shell_call('''sed "s/'//g" tree_labels_midpoints.tre > tree_labels_midpoints_clean.tre''') 
	shell_call('''sed "s/'//g" tree_labels_ranges.tre > tree_labels_ranges_clean.tre''') 
	shell_call('''sed "s/'//g" tree_labels_midpoints.tre > tree_labels_midpoints_clean.tre''') 
	shell_call('''sed "s/'//g" tree_labels_ranges.tre > tree_labels_ranges_clean.tre''')
