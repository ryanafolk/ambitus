#!/usr/bin/env Rscript
write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_source_pno1.sh")
csv = read.csv("bins_source_pno1.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi1.tif --outfile=binned_source_pno1_', i, '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_source_pno1.sh", append = TRUE)
	output = ''
}

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_source_pno2.sh")
csv = read.csv("bins_source_pno2.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi7.tif --outfile=binned_source_pno2_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_source_pno2.sh", append = TRUE)
	output = ''
}

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_source_pno3.sh")
csv = read.csv("bins_source_pno3.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi12.tif --outfile=binned_source_pno3_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_source_pno3.sh", append = TRUE)
	output = ''
}

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_source_pno4.sh")
csv = read.csv("bins_source_pno4.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi17.tif --outfile=binned_source_pno4_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_source_pno4.sh", append = TRUE)
	output = ''
}

###############

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_hybrid_pno1.sh")
csv = read.csv("bins_hybrid_pno1.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi1.tif --outfile=binned_hybrid_pno1_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_hybrid_pno1.sh", append = TRUE)
	output = ''
}

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_hybrid_pno2.sh")
csv = read.csv("bins_hybrid_pno2.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi7.tif --outfile=binned_hybrid_pno2_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_hybrid_pno2.sh", append = TRUE)
	output = ''
}

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_hybrid_pno3.sh")
csv = read.csv("bins_hybrid_pno3.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi12.tif --outfile=binned_hybrid_pno3_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_hybrid_pno3.sh", append = TRUE)
	output = ''
}

write('#!/usr/bin/env bash', file = "GDAL_classify_pixels_hybrid_pno4.sh")
csv = read.csv("bins_hybrid_pno4.csv", header = TRUE, sep = ",")
for (i in 1:nrow(csv)) {
	output <- paste('gdal_calc.py -A cclgmbi17.tif --outfile=binned_hybrid_pno4_', i[1], '.tif --calc "logical_and((A >= ', csv$breaks.1[i], '), (A <  ', csv$breaks.2[i], '))*', csv$probability[i], '" --type=Float32 --NoDataValue=0 --overwrite', sep = "")
	write(output, file = "GDAL_classify_pixels_hybrid_pno4.sh", append = TRUE)
	output = ''
}
