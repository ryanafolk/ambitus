#!/usr/bin/env python3

import subprocess # To call on bash
import sys # To process arguments


def bayesproc(commandargs):
	processID = commandargs[0]
	bootnum = commandargs[1]
	runID = commandargs[2]
	bootlabel = "_boot{0}".format(bootnum)
	print("Variable {0}, PNO sample {1}: Running continuous character model MCMC... ".format(processID,bootnum))
	p = subprocess.Popen("sed 's/SaveModels Ancestral.bin/SaveModels .\/temp\/Ancestral{0}{1}{2}.bin/' model.command > ./temp/model{0}{1}{2}.command".format(processID,bootlabel,runID),shell=True) # Creates a command file for a given run; needed to prevent clashing writes to the .bin file
	p.wait() # This forces these shell calls to be sequential
	sys.stdout.flush() # This forces emptying of the buffer, avoiding clashing logfile read/writes
	p = subprocess.Popen("./BayesTraitsV2 tree.tre ./temp/character{0}{1}{2}.txt < ./temp/model{0}{1}{2}.command > /dev/null".format(processID,bootlabel,runID),shell=True) # Run MCMC of model; throws away output but this could be useful for some
	p.wait() 
	sys.stdout.flush()
	p = subprocess.Popen("mv ./temp/character{0}{1}{2}.txt.log.txt ./output/character{0}{1}{2}.MODEL.log".format(processID,bootlabel,runID),shell=True) # Save log output; will be overwritten without this step
	p.wait() 
	sys.stdout.flush()
	p = subprocess.Popen("mv ./temp/character{0}{1}{2}.txt.log.txt.Schedule.txt ./output/character{0}{1}{2}.MODEL_ACCEPTANCE.log".format(processID,bootlabel,runID),shell=True) # Save log output; will be overwritten without this step
	p.wait() 
	sys.stdout.flush()
	print("Variable {0}, PNO sample {1}: Running ancestral reconstruction MCMC...".format(processID,bootnum))
	p = subprocess.Popen("sed 's/LoadModels Ancestral.bin/LoadModels .\/temp\/Ancestral{0}{1}{2}.bin/' reconstruction.command > ./temp/reconstruction{0}{1}{2}.command".format(processID,bootlabel,runID),shell=True) # Creates a command file for a given run; needed to prevent clashing writes to the .bin file
	p.wait() 
	sys.stdout.flush()
	p = subprocess.Popen("./BayesTraitsV2 tree.tre ./temp/character{0}{1}{2}.txt < ./temp/reconstruction{0}{1}{2}.command > ./temp/reconstruction{0}{1}{2}.out".format(processID,bootlabel,runID),shell=True) # Run MCMC of ancestral character reconstruction
	p.wait()
	sys.stdout.flush()
	p = subprocess.Popen("mv ./temp/character{0}{1}{2}.txt.log.txt ./output/character{0}{1}{2}.RECONSTRUCTION.log".format(processID,bootlabel,runID),shell=True) # Save log output; will be overwritten without this step
	p.wait() 
	sys.stdout.flush()
	p = subprocess.Popen("mv ./temp/character{0}{1}{2}.txt.log.txt.Schedule.txt ./output/character{0}{1}{2}.RECONSTRUCTION_ACCEPTANCE.log".format(processID,bootlabel,runID),shell=True) # Save log output; will be overwritten without this step
	p.wait() 
	sys.stdout.flush()
	p = subprocess.Popen("sed -e '1,/.*Harmonic Mean.*/ d' ./temp/reconstruction{0}{1}{2}.out | sed -e '$ d' > ./temp/reconstructionclean{0}{1}{2}.out".format(processID,bootlabel,runID),shell=True) # Trim output of BayesTraits to just the tab-delimited MCMC
	p.wait()
	sys.stdout.flush()
	print("Variable {0}, PNO sample {1}: Done.".format(processID,bootnum))
	print("Cleaning up output.")
	p = subprocess.Popen("rm ./temp/model{0}{1}{2}.command ./temp/character{0}{1}{2}.txt ./temp/Ancestral{0}{1}{2}.bin ./temp/reconstruction{0}{1}{2}.command ./temp/reconstruction{0}{1}{2}.out".format(processID,bootlabel,runID),shell=True) # Remove all intermediate files not needed for later steps, except the reconstruction log output; comment out to examine output if you are experiencing problems with BayesTraits
	p.wait()
	sys.stdout.flush()
