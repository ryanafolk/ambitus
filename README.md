<span style="font-variant:small-caps;">Ancestral Niche Reconstruction Pipeline</span>
=========

Overview
---------
This program is both a wrapper for BayesTraits and a pipeline for importing niche occupancy profile data from an arbitrary number of species niche models, integrating these data with a phylogeny of these species, and summarizing BayesTraits output on trees that are formatted for producing publication-quality figures. 

It is designed to incorporate large numbers of taxa, but be warned -- it is very processor-intensive for > 100 taxa. In view of this, the pipeline is designed to be automatically parallelized on a given number of processors. If you do not know the number of processors you have, you can query the Unix terminal (including the Mac OSX terminal) like so: 

```
$ nproc
```

Dependencies
---------
The pipeline is coded in Python 3 and requires a UNIX-like machine (Linux, Mac OSX, etc.) with a bash shell and the default tools. If you do not have Python 3, you must install it, but it is important to understand that you will probably be installing coexisting versions. UNIX-like operating systems commonly depend on a default installation of Python, which will typically be Python 2. This will be the executable in your path called `python` when you type that in the shell. Using `$ python3`, on the other hand, will call on the proper version. Additionally, you will need a few libraries on which this program depends -- `dendropy` for phylogenetic functions and `numpy` for statistical functions. These may be installed in various ways, but I recommend installing `pip` if you do not already have it. Once again you will run into the issue of coexisting Python versions, so install using `$ python3 -m pip install dendropy` and `$ python3 -m pip install numpy` rather than calling directly on the `pip` executable.

Additionally, you should install `figtree` in order to visualize the phylogenetic output.

R will generally also be needed to handle ecological niche modeling.

Required files
---------
Several files come with this pipeline and must be in the working directory: three python scripts (`ancestralnichereconstruction-p.py`, `bayestraitscontroller.py`, and  `main.py`), a template for the command file for the character evolution modeling step in BayesTraits (`model.command`), and two templates for the command file for the ancestral reconstruction step in BayesTraits (`template_reconstruction.command` and `template2_reconstruction.command`). Additionally, you must download an executable for the BayesTraits build most suited to your system. Obtaining a multicore build will not help, but the quad precision build may be helpful for large trees (~1000 taxa or greater) and the OpenCL build may improve runtimes. The executable must be in the working directory and must be named `BayesTraitsV2` (case sensitive).

Finally -- the input data. Your input phylogeny must be in NEXUS format and must be named `tree.tre`. The PNO profiles must be of the form `character1_ranges.txt`, `character2_ranges.txt`, etc.

Formatting input files
---------
BayesTraits is picky about input files. In particular, the tree must be a NEXUS file WITH a translate table. There may be no support values, but there must be branch lengths. Be careful with non-alphanumeric characters in taxon labels. I included a script to convert a newick tree into a nexus format with the translate table using dendropy, but some manual formatting may still be necessary to remove support values. If BayesTraits cannot read your tree properly, it may fail or report in the log file that most of your taxa are missing.

A note about trees -- BayesTraits has built-in support for incorporating phylogenetic uncertainty. If you wish, you may use a NEXUS file consisting of a sample of topologies with branchlengths from a bootstrap or MCMC. (Caution: trees from your bootstraps/MCMC samples may not have branch lengths [e.g. in RAxML]. You may add these by optimizing branch lengths on a fixed topology in RAxML, for which see the manual.) However, there is a problem with the BayesTraits approach: nodes are found for ancestral reconstruction by using an MRCA approach -- the node is the least inclusive common ancestor of the terminals indicated. For a single optimal tree, this pipeline locates nodes with a list of all nodes and all daughter taxa for each of these nodes. For a poorly supported node, when using an MCMC/bootstrap sample many of these MRCA searches will find the wrong node -- of course, this is because the right node by definition is simply absent from many trees. This will bias nodal estimates towards more ancestral values. We will address this issue in the future, but for the moment use this feature with caution.

The parameters for running BayesTraits may be modified by using the command template files `model.command` and `template_reconstruction.command`; please refer to the BayesTraits manual.

How to run the pipeline
---------
This program is run through the command line. The first argument is an integer specifying the number of variables to be used (using a subset of your full variable set is useful for testing and troubleshooting). The second argument is the number of processors you would like to use. The third argument is the number of times you would like to sample from the predicted niche occupancy (PNO) distribution. For the fourth argument, in the style of RAxML, you should specify a run ID for identifying the output of a single run. Be warned, however, if you pick the same run ID in the same directory later, the previous output will be overwritten without warning.

For instance, on a small computer you might give the main script executable permissions (`$ chmod a+x ancestralnichereconstruction-p.py`), then run it as an executable like so:
```
$ ./ancestralnichereconstruction-p.py 20 4 100 some_run_name
```
This will do a run on 100 samples from each of 20 niche variables, using 4 processors, and output the results as XXXXXXXXsome_run_name.XXX. This will involve 2000 separate calls to BayesTraits, so if your tree is large make sure you have access to a powerful machine (specifically, a large number of cores, since the amount of RAM needed is trivial).

If this does not work, you might still be having trouble with permissions, or with how your terminal's environmental variables are set up -- it may not know where to find Python 3. Try running it in non-executable mode:
```
$ python3 ancestralnichereconstruction-p.py 20 4 100 some_run_name
```

How the pipeline works
---------
From a set of ecological niche models, predicted niche occupancy (PNO) profiles are obtained (some scripts included). These are probability distributions representing, for each ecological variable, the range occupied by a species. BayesTraits, the ancestral reconstruction approach used in this pipeline, cannot handle a range of values, much less a probability distribution. We add this functionality by statistically sampling from the PNO, and running independent instances of BayesTraits on these samples. The output files are then collated, credibility intervals and midpoints (actually 50th percentiles) are inferred, and these are plotted on the input tree.

This primarily involves parsing and creating thousands of input and output files and doing arithmetic on them; additionally, finding nodes requires tree traversal. 

Handling output files
---------
The pipeline outputs two tree files. One contains "midpoints" of ancestral reconstructions for each variable in order (actually they are 50th percentiles), followed by the difference of the average min and max values for the CIs (used for plotting uncertainty in FigTree; see below). The other contains ranges, corresponding to the average minimum and average maximum of credibility intervals across all samples from the PNO profile. 

The tree formatting is designed to work well with FigTree -- nodes can be colored based on the magnitude of ancestral niche values per variable, and their size can be proportional to the magnitude of the CI. Unfortunately, many phylogenetic visualization packages, such as those in R, deal poorly with importing and exporting nodal annotations, being intended to handle annotations produced internally, so it may not be straightforward to create figures in other graphics environments.