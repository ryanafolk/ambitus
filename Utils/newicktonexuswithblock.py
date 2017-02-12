#!/usr/bin/env python3

import dendropy
import sys

try:
	filein = sys.argv[1]
	fileout = sys.argv[2]
except:
	print("This script takes two arguments: the input file and the output file.")
	quit()

tree = dendropy.Tree.get(path="{0}".format(filein), schema="newick", preserve_underscores=True)
tree.write(path="{0}".format(fileout), schema="nexus", translate_tree_taxa=True)