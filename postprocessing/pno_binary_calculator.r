#!/usr/bin/env Rscript

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_source_pno1.sh")
csv = read.csv("PNO_distribution_1.tsv", header = TRUE, sep = "\t")
source_lower <- mean(csv$source) - (sd(csv$source) * 2) 
source_upper <- mean(csv$source) + (sd(csv$source) * 2) 
output <- paste('gdal_calc.py -A cclgmbi1.tif --outfile=binary_source_pno1.tif --calc "logical_and((A >= ', source_lower, '), (A <=  ', source_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_source_pno1.sh", append = TRUE)

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_source_pno2.sh")
csv = read.csv("PNO_distribution_2.tsv", header = TRUE, sep = "\t")
source_lower <- mean(csv$source) - (sd(csv$source) * 2) 
source_upper <- mean(csv$source) + (sd(csv$source) * 2) 
output <- paste('gdal_calc.py -A cclgmbi7.tif --outfile=binary_source_pno2.tif --calc "logical_and((A >= ', source_lower, '), (A <=  ', source_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_source_pno2.sh", append = TRUE)

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_source_pno3.sh")
csv = read.csv("PNO_distribution_3.tsv", header = TRUE, sep = "\t")
source_lower <- mean(csv$source) - (sd(csv$source) * 2) 
source_upper <- mean(csv$source) + (sd(csv$source) * 2) 
output <- paste('gdal_calc.py -A cclgmbi12.tif --outfile=binary_source_pno3.tif --calc "logical_and((A >= ', source_lower, '), (A <=  ', source_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_source_pno3.sh", append = TRUE)

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_source_pno4.sh")
csv = read.csv("PNO_distribution_4.tsv", header = TRUE, sep = "\t")
source_lower <- mean(csv$source) - (sd(csv$source) * 2) 
source_upper <- mean(csv$source) + (sd(csv$source) * 2) 
output <- paste('gdal_calc.py -A cclgmbi17.tif --outfile=binary_source_pno4.tif --calc "logical_and((A >= ', source_lower, '), (A <=  ', source_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_source_pno4.sh", append = TRUE)

###########

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_hybrid_pno1.sh")
csv = read.csv("PNO_distribution_1.tsv", header = TRUE, sep = "\t")
hybrid_lower <- mean(csv$hybrid) - (sd(csv$hybrid) * 2) 
hybrid_upper <- mean(csv$hybrid) + (sd(csv$hybrid) * 2) 
output <- paste('gdal_calc.py -A cclgmbi1.tif --outfile=binary_hybrid_pno1.tif --calc "logical_and((A >= ', hybrid_lower, '), (A <=  ', hybrid_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_hybrid_pno1.sh", append = TRUE)

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_hybrid_pno2.sh")
csv = read.csv("PNO_distribution_2.tsv", header = TRUE, sep = "\t")
hybrid_lower <- mean(csv$hybrid) - (sd(csv$hybrid) * 2) 
hybrid_upper <- mean(csv$hybrid) + (sd(csv$hybrid) * 2) 
output <- paste('gdal_calc.py -A cclgmbi7.tif --outfile=binary_hybrid_pno2.tif --calc "logical_and((A >= ', hybrid_lower, '), (A <=  ', hybrid_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_hybrid_pno2.sh", append = TRUE)

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_hybrid_pno3.sh")
csv = read.csv("PNO_distribution_3.tsv", header = TRUE, sep = "\t")
hybrid_lower <- mean(csv$hybrid) - (sd(csv$hybrid) * 2) 
hybrid_upper <- mean(csv$hybrid) + (sd(csv$hybrid) * 2) 
output <- paste('gdal_calc.py -A cclgmbi12.tif --outfile=binary_hybrid_pno3.tif --calc "logical_and((A >= ', hybrid_lower, '), (A <=  ', hybrid_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_hybrid_pno3.sh", append = TRUE)

write('#!/usr/bin/env bash', file = "BINARY_classify_pixels_hybrid_pno4.sh")
csv = read.csv("PNO_distribution_4.tsv", header = TRUE, sep = "\t")
hybrid_lower <- mean(csv$hybrid) - (sd(csv$hybrid) * 2) 
hybrid_upper <- mean(csv$hybrid) + (sd(csv$hybrid) * 2) 
output <- paste('gdal_calc.py -A cclgmbi17.tif --outfile=binary_hybrid_pno4.tif --calc "logical_and((A >= ', hybrid_lower, '), (A <=  ', hybrid_upper, '))"  --type=Float32 --NoDataValue=0 --overwrite', sep = "")
write(output, file = "BINARY_classify_pixels_hybrid_pno4.sh", append = TRUE)

