#!/usr/bin/env bash

# Multiply across variables for combined probabilities
gdal_calc.py -A final_range_product_source.tif -B final_range_product_hybrid.tif --outfile intersected_probabilities.tif --calc="minimum(A,B)"

# Then use the zonal statistics plugin of qGIS

# Here is the binary version; multiplying is equivalent to the minimum in this case
gdal_calc.py -A BINARY_final_range_product_source.tif -B BINARY_final_range_product_hybrid.tif --outfile BINARY_intersected_probabilities.tif --calc="A*B"
