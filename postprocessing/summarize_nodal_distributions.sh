#!/usr/bin/env bash

### This is the main script for processing MCMC output of Ambitus for plotting nodal reconstructions on maps. There are also subsidiary R modules for processing dataframes.
# Intermediate files from Ambitus must be saved (decline to delete at the end of the script, or ignore the question and kill the program).
# Copy these scripts and all relevant "reconstructionclean" files from the temporary folder of a finished ambitus run to an empty folder before running these. For instance, if PNOs 1-4 are needed, only copy the "reconstructionclean" files numbered 1-4.
# This main script can be run in one go, but it may be helpful to copy and paste each step into a terminal and examine output.

# Concatenate individual MCMC chains across samples
# This step could fail for very large numbers of PNO samples -- this will vary depending on ARG_MAX -- in this case the following commands should be rewritten using find
cat reconstructionclean1_* > reconstruction_pnoclean1.tsv
cat reconstructionclean2_* > reconstruction_pnoclean2.tsv
cat reconstructionclean3_* > reconstruction_pnoclean3.tsv
cat reconstructionclean4_* > reconstruction_pnoclean4.tsv

mkdir original_reconstructions/
mv reconstructionclean* original_reconstructions/

# The output can be extremely large, a problem that is handled by thinning the MCMC.
# This command will subsample every 50th sample.
# With the BayesTraits settings for the Heuchera paper, this results in thinning to 100 samples per MCMC
awk 'NR == 1 || NR % 50 == 0' reconstruction_pnoclean1.tsv > reconstruction_pnoclean1_subsampled.tsv
awk 'NR == 1 || NR % 50 == 0' reconstruction_pnoclean2.tsv > reconstruction_pnoclean2_subsampled.tsv
awk 'NR == 1 || NR % 50 == 0' reconstruction_pnoclean3.tsv > reconstruction_pnoclean3_subsampled.tsv
awk 'NR == 1 || NR % 50 == 0' reconstruction_pnoclean4.tsv > reconstruction_pnoclean4_subsampled.tsv

# IMPORTANT -- must create a header by hand -- needed to identify nodes of interest.
# Use a RECONSTRUCTION log file from the output directory of ambitus to obtain a header for the reconstruction files, as the only line of correctheader.txt.
# The original header is the line immediately before MCMC output begins in the RECONSTRUCTION log.
# Then use the nodelist file in the main directory to find nodes of interest -- the numbering will change based on the tree shape.
# Rename the relevant columns of the header with "hybrid," "source" in correctheader.txt

cat correctheader.txt reconstruction_pnoclean1_subsampled.tsv > PNO_distribution_1.tsv
cat correctheader.txt reconstruction_pnoclean2_subsampled.tsv > PNO_distribution_2.tsv
cat correctheader.txt reconstruction_pnoclean3_subsampled.tsv > PNO_distribution_3.tsv
cat correctheader.txt reconstruction_pnoclean4_subsampled.tsv > PNO_distribution_4.tsv

# reconstruction_pnoclean*****tsv can be deleted at this point.
# The tsv files are the input for either the binary map or the binned probabilities map.

###################
# BINARY MAP CODE #
###################

# Create shell scripts for GDAL to calculate binary maps for each variable
chmod a+x pno_binary_calculator.r
./pno_binary_calculator.r

# Execute the GDAL shell scripts
chmod a+x BINARY_classify_pixels*sh
./BINARY_classify_pixels_source_pno1.sh
./BINARY_classify_pixels_source_pno2.sh
./BINARY_classify_pixels_source_pno3.sh
./BINARY_classify_pixels_source_pno4.sh
./BINARY_classify_pixels_hybrid_pno1.sh
./BINARY_classify_pixels_hybrid_pno2.sh
./BINARY_classify_pixels_hybrid_pno3.sh
./BINARY_classify_pixels_hybrid_pno4.sh

# Combine binary maps for each variable
# Test whether pixels = 4; i.e., pixels are 1 only if they are 1 for all four layers, i.e., the test is true for all four layers
gdal_calc.py -A binary_source_pno1.tif -B binary_source_pno2.tif -C binary_source_pno3.tif -D binary_source_pno4.tif --outfile BINARY_final_range_product_source.tif --calc="A*B*C*D"
gdal_calc.py -A binary_hybrid_pno1.tif -B binary_hybrid_pno2.tif -C binary_hybrid_pno3.tif -D binary_hybrid_pno4.tif --outfile BINARY_final_range_product_hybrid.tif --calc="A*B*C*D"

#############################
# BINNED PROBABILITIES CODE #
#############################

# Calculate bins and export as CSV.
chmod a+x pno_binned_probabilities_calculator.r 
./pno_binned_probabilities_calculator.r 

# Create a shell script to run GDAL on each bin.
chmod a+x pno_binned_probabilities_calculator_step2.r 
./pno_binned_probabilities_calculator_step2.r 

# Run the GDAL scripts
chmod a+x GDAL_classify_pixels_*.sh
./GDAL_classify_pixels_source_pno1.sh
./GDAL_classify_pixels_source_pno2.sh
./GDAL_classify_pixels_source_pno3.sh
./GDAL_classify_pixels_source_pno4.sh
./GDAL_classify_pixels_hybrid_pno1.sh
./GDAL_classify_pixels_hybrid_pno2.sh
./GDAL_classify_pixels_hybrid_pno3.sh
./GDAL_classify_pixels_hybrid_pno4.sh

mkdir binned_source_pno1/
mkdir binned_source_pno2/
mkdir binned_source_pno3/
mkdir binned_source_pno4/
mkdir binned_hybrid_pno1/
mkdir binned_hybrid_pno2/
mkdir binned_hybrid_pno3/
mkdir binned_hybrid_pno4/
mv binned_source_pno1* binned_source_pno1/
mv binned_source_pno2* binned_source_pno2/
mv binned_source_pno3* binned_source_pno3/
mv binned_source_pno4* binned_source_pno4/
mv binned_hybrid_pno1* binned_hybrid_pno1/
mv binned_hybrid_pno2* binned_hybrid_pno2/
mv binned_hybrid_pno3* binned_hybrid_pno3/
mv binned_hybrid_pno4* binned_hybrid_pno4/

# Combine individual bin slices as a virtual raster for each variable in GDAL
gdalbuildvrt virtual_source_pno1.vrt binned_source_pno1/*.tif
gdalbuildvrt virtual_source_pno2.vrt binned_source_pno2/*.tif
gdalbuildvrt virtual_source_pno3.vrt binned_source_pno3/*.tif
gdalbuildvrt virtual_source_pno4.vrt binned_source_pno4/*.tif
gdalbuildvrt virtual_hybrid_pno1.vrt binned_hybrid_pno1/*.tif
gdalbuildvrt virtual_hybrid_pno2.vrt binned_hybrid_pno2/*.tif
gdalbuildvrt virtual_hybrid_pno3.vrt binned_hybrid_pno3/*.tif
gdalbuildvrt virtual_hybrid_pno4.vrt binned_hybrid_pno4/*.tif

# Convert virtual raster into combined GEOtiff
gdal_translate -of GTiff virtual_source_pno1.vrt combined_source_pno1.tif
gdal_translate -of GTiff virtual_source_pno2.vrt combined_source_pno2.tif
gdal_translate -of GTiff virtual_source_pno3.vrt combined_source_pno3.tif
gdal_translate -of GTiff virtual_source_pno4.vrt combined_source_pno4.tif
gdal_translate -of GTiff virtual_hybrid_pno1.vrt combined_hybrid_pno1.tif
gdal_translate -of GTiff virtual_hybrid_pno2.vrt combined_hybrid_pno2.tif
gdal_translate -of GTiff virtual_hybrid_pno3.vrt combined_hybrid_pno3.tif
gdal_translate -of GTiff virtual_hybrid_pno4.vrt combined_hybrid_pno4.tif

# Multiply across variables for combined probabilities
gdal_calc.py -A combined_source_pno1.tif -B combined_source_pno2.tif -C combined_source_pno3.tif -D combined_source_pno4.tif --outfile final_range_product_source.tif --calc="A*B*C*D"
gdal_calc.py -A combined_hybrid_pno1.tif -B combined_hybrid_pno2.tif -C combined_hybrid_pno3.tif -D combined_hybrid_pno4.tif --outfile final_range_product_hybrid.tif --calc="A*B*C*D"
