#!/usr/bin/env python3

import subprocess # To call on bash
import sys # To process arguments
from ambitus_main import shell_call as shell_call

def bayesproc(commandargs):
	processID = commandargs[0]
	bootnum = commandargs[1]
	runID = commandargs[2]
	bootlabel = "_boot{0}".format(bootnum)
	print("Variable {0}, PNO sample {1}: Running continuous character model MCMC... ".format(processID,bootnum))
	shell_call("sed 's/SaveModels Ancestral.bin/SaveModels .\/temp\/Ancestral{0}{1}{2}.bin/' model.command > ./temp/model{0}{1}{2}.command".format(processID,bootlabel,runID)) # Creates a command file for a given run; needed to prevent clashing writes to the .bin file
	shell_call("./BayesTraitsV2 tree.tre ./temp/character{0}{1}{2}.txt < ./temp/model{0}{1}{2}.command > /dev/null".format(processID,bootlabel,runID)) # Run MCMC of model; throws away output but this could be useful for some
	shell_call("mv ./temp/character{0}{1}{2}.txt.log.txt ./output/character{0}{1}{2}.MODEL.log".format(processID,bootlabel,runID)) # Save log output; will be overwritten without this step
	shell_call("mv ./temp/character{0}{1}{2}.txt.log.txt.Schedule.txt ./output/character{0}{1}{2}.MODEL_ACCEPTANCE.log".format(processID,bootlabel,runID)) # Save log output; will be overwritten without this step
	print("Variable {0}, PNO sample {1}: Running ancestral reconstruction MCMC...".format(processID,bootnum))
	shell_call("sed 's/LoadModels Ancestral.bin/LoadModels .\/temp\/Ancestral{0}{1}{2}.bin/' reconstruction.command > ./temp/reconstruction{0}{1}{2}.command".format(processID,bootlabel,runID)) # Creates a command file for a given run; needed to prevent clashing writes to the .bin file
	shell_call("./BayesTraitsV2 tree.tre ./temp/character{0}{1}{2}.txt < ./temp/reconstruction{0}{1}{2}.command > ./temp/reconstruction{0}{1}{2}.out".format(processID,bootlabel,runID)) # Run MCMC of ancestral character reconstruction
	shell_call("mv ./temp/character{0}{1}{2}.txt.log.txt ./output/character{0}{1}{2}.RECONSTRUCTION.log".format(processID,bootlabel,runID)) # Save log output; will be overwritten without this step
	shell_call("mv ./temp/character{0}{1}{2}.txt.log.txt.Schedule.txt ./output/character{0}{1}{2}.RECONSTRUCTION_ACCEPTANCE.log".format(processID,bootlabel,runID)) # Save log output; will be overwritten without this step
	shell_call("sed '1,/.*Harmonic Mean.*/ d' ./temp/reconstruction{0}{1}{2}.out | sed '$ d' > ./temp/reconstructionclean{0}{1}{2}.out".format(processID,bootlabel,runID)) # Trim output of BayesTraits to just the tab-delimited MCMC
	print("Variable {0}, PNO sample {1}: Done.".format(processID,bootnum))
	print("Cleaning up output.")
	shell_call("rm ./temp/model{0}{1}{2}.command ./temp/character{0}{1}{2}.txt ./temp/Ancestral{0}{1}{2}.bin ./temp/reconstruction{0}{1}{2}.command ./temp/reconstruction{0}{1}{2}.out".format(processID,bootlabel,runID)) # Remove all intermediate files not needed for later steps, except the reconstruction log output; comment out to examine output if you are experiencing problems with BayesTraits
