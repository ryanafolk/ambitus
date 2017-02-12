<span style="font-variant:small-caps;">Ambitus&mdash;Bayesian Ancestral Niche Reconstruction Pipeline</span>
=========

Overview
---------
This program is a wrapper for BayesTraits, integrating niche models for a clade with a phylogeny of these species, and summarizing BayesTraits output on trees that are formatted for producing publication-quality figures. Downstream analyses are also covered in subfolders, including creating geographic predictions from an ancestral niche reconstruction run

It is designed to incorporate large numbers of taxa, but be warned -- it is very processor-intensive for > 100 taxa. In view of this, the pipeline is designed to be automatically parallelized on a given number of processors. If you do not know the number of (logical) processors you have, you can query the Unix terminal (including the Mac OSX terminal) like so: 

```
$ nproc
```

Dependencies
---------
The pipeline is coded in python 3 and requires a UNIX-like machine (Linux, Mac OS-X, etc.) with a bash shell and the default tools. If you do not have python 3, you must install it, but it is important to understand that you will probably be installing coexisting versions. UNIX-like operating systems commonly depend on a default installation of python, which will typically be python 2. This will be the executable in your path called `python` when you type that in the shell. Using `$ python3`, on the other hand, will call on the proper version. Additionally, you will need a few libraries on which this program depends -- `dendropy` for phylogenetic functions, `numpy` for statistical functions, and `scipy`. These may be installed in various ways, but I recommend installing `pip` if you do not already have it. If there are issues with coexisting python instances, install using `$ python3 -m pip install dendropy` and `$ python3 -m pip install numpy`, &c., rather than calling directly on the `pip` executable.

Additionally, you should install `figtree`, which uses Java Runtime Environment, in order to visualize the phylogenetic output.

Those using OS-X should be aware that the script assumes and uses syntax of (superior) GNU tools rather than the default BSD tools. I handled this by replacing the default tools (especially sed). Another way to handle this would be using symlinks on coexisting versions (the default homebrew installation method) with a specially set-up path.

To use certain supplementary scripts, R will also be needed, with the required libraries found in those scripts.

Required files
---------
Several files come with this pipeline and must be in the working directory. There is one main python script (`ambitus.py`) and four additional python modules. Templates are provided for the command file for the character evolution modeling step in BayesTraits (`model.command`), and two templates for the command file for the ancestral reconstruction step in BayesTraits (`template_reconstruction.command` and `template2_reconstruction.command`). These can be modified to control the MCMC behavior of BayesTraits. Another set, ending in `default.command`, give the default, less thorough MCMC parameters that might be needed for larger datasets. Additionally, you must download an executable for the BayesTraits build most suited to your system. Obtaining a multicore build will not help since the parallelization implementation in this script is likely faster, but the quad precision build may be helpful for large trees (~1000 taxa or greater) and the OpenCL build may improve runtimes. The executable must be in the working directory and must be named `BayesTraitsV2` (case sensitive).

Finally -- the input data. Your input phylogeny must be in NEXUS format and must be named `tree.tre`. This is allowed to be a distribution of trees, but must have branch lengths. The phylogeny to plot the result on must be in the same format, but only a single tree, called `plottree.tre`. This allows a tree distribution to be plotted on an optimal tree. The PNO profiles are placed in the directory `pnos` and must be of the form `pno1_Genus_species.csv`, `pno2_Genus_species.csv`, etc. You must provide a species list (a list of all tips in your tree, easily generated from a NEXUS translate table).

Formatting input files
---------
BayesTraits is picky about input files. In particular, the tree must be a NEXUS file WITH a translate table. There may be no support values, but there must be branch lengths. Be careful with non-alphanumeric characters in taxon labels. I included a script (folder `Utils`) to convert a newick tree into a nexus format with the translate table using dendropy, but some manual formatting will still be necessary to remove support values and other extraneous information. If BayesTraits cannot read your tree properly, it may fail or report in the log file that most of your taxa are missing.

A note about trees -- BayesTraits has built-in support for incorporating phylogenetic uncertainty. If you wish, you may use a NEXUS file consisting of a sample of topologies with branch lengths from a bootstrap or MCMC. (Caution: trees from your bootstraps/MCMC samples may not have branch lengths [e.g. in RAxML]. You may add these by optimizing branch lengths on a fixed topology in RAxML, or plotting them during the bootstrap run in RAxML, for which see the manual.) Note that nodes are found for ancestral reconstruction by using an MRCA approach -- the node is the least inclusive common ancestor of the terminals indicated -- so awareness of this may be needed in interpreting reconstructions for poorly supported nodes. For such poorly supported nodes, when using an MCMC/bootstrap sample many of these MRCA searches will find the wrong node -- of course, this is because the right node is simply absent from some trees. This will bias nodal estimates towards more ancestral values.

The parameters for running BayesTraits may be modified by using the command template files `model.command` and `template_reconstruction.command`; please refer to the BayesTraits manual or the provided examples.

How to run the pipeline
---------
This program is run through the command line. The first argument is an integer specifying the number of variables to be used (using a subset of your full variable set is useful for testing and troubleshooting). The second argument is the number of processors you would like to use. The third argument is the number of times you would like to sample from the predicted niche occupancy (PNO) distribution. For the fourth argument, in the style of RAxML, you should specify a run ID for identifying the output of a single run. Be warned, however, if you pick the same run ID in the same directory later, the previous output will be overwritten without warning. For an example of the argument format, execute the script without arguments.

For instance, on a small computer you might give the main script executable permissions (`$ chmod a+x ambitus.py`), then run it as an executable like so:
```
$ ./ambitus.py 20 4 100 some_run_name
```
This will do a run on 100 samples from each of 20 niche variables, using 4 processors, and output the results as XXXXXXXXsome_run_name.XXX. This will involve 2000 separate calls to BayesTraits, so if your tree is large make sure you have access to a powerful machine (specifically, a large number of cores, since the amount of RAM needed is trivial).

If this does not work, you might still be having trouble with permissions, or with how your terminal's environmental variables are set up -- it may not know where to find Python 3. Try running it in non-executable mode:
```
$ python3 ambitus.py 20 4 100 some_run_name
```

You may wish to verify the presence of sufficient harddrive space (`$ df -h`), since the output of this program tends to be several to hundreds of gigabytes.

How the pipeline works
---------
From a set of ecological niche models, predicted niche occupancy (PNO) profiles are obtained with pre-existing software in R, and exported in CSV format. PNOs are binned probability distributions representing, for each ecological variable, the distribution of occupancy in niche space. BayesTraits, the ancestral reconstruction approach used in this pipeline, cannot handle a range of values, much less a probability distribution. We add this functionality by statistically sampling from the PNO, and running independent instances of BayesTraits on these samples. The output files are then collated, credibility intervals and midpoints (actually 50th percentiles) are inferred, and these are plotted on the input tree.

This primarily involves parsing and creating thousands of input and output files and doing arithmetic on them, then finally summarizing these values in FigTree or BEAST-like format. 

Handling output files
---------
The pipeline outputs two tree files. One contains "midpoints" of ancestral reconstructions for each variable in order (actually they are 50th percentiles), followed by the difference of the average 2.5th and 97.5th percentiles (i.e. averaged credibility intervals, used for plotting uncertainty in FigTree; see below). The other contains the actual ranges of the credibility intervals. 

The tree formatting is designed to work well with FigTree -- nodes can be colored based on the magnitude of ancestral niche values per variable, and their size can be proportional to the magnitude of the CI. Unfortunately, many phylogenetic visualization packages, such as those in R, deal poorly with importing and exporting nodal annotations, being intended to handle annotations produced internally, so it may not be straightforward to create figures in other graphics environments.

At the very end of an `ambitus` run, it will ask whether to remove temporary files. These will need to be kept if you plan to run the downstream analyses provided.

Geographic projection of nodal distributions
---------
Provided in the postprocessing directory are scripts to reproduce the geographic and E-space overlap calculations; there are two shell scripts and several R scripts. R scripts use only base package functions; the shell script requires that `gdal` executables (`gdalbuildvrtgdalbuildvrt`, `gdal_translate`, `gdal_calc.py`) be present. The scripts are placed in the same directory as the `reconstructionclean...` files (which are batch copied into a new directory from the `temp` directory of an ambitus run. The whole script is meant to be run on four variables to reproduce the *Heuchera* analyses; more can be added by copy-paste. You will also have to create a new header line in `correctheader.txt`; this is how the nodes of interest (numbered according to `nodelist.txt` generated by an `ambitus` run) for reconstruction are identified. This pipeline was meant to compare two nodes; they should be called "hybrid" and "source". If there is interest, it would not take me long to rewrite these items for arbitrary numbers of nodes, and perhaps even create maps for all nodes in the tree.

First individual MCMC runs are concatenated; these are thinned and formatted. Several histogram and credibility interval calculations are done in R calls. Then these are applied to the raster layers with several gdal calls. This script takes about an hour on a MacBook Pro with a solid-state drive (lots of I/O) and is not parallelized.
