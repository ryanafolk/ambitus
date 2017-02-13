#!/usr/bin/env Rscript
# Breaks: Need n+1 to give a fencepost


csv = read.csv("PNO_distribution_1.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$source), to = max(csv$source), length.out = 51) 
h <- hist(csv$source, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_source_pno1.csv")

csv = read.csv("PNO_distribution_2.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$source), to = max(csv$source), length.out = 51) 
h <- hist(csv$source, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_source_pno2.csv")

csv = read.csv("PNO_distribution_3.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$source), to = max(csv$source), length.out = 51) 
h <- hist(csv$source, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_source_pno3.csv")

csv = read.csv("PNO_distribution_4.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$source), to = max(csv$source), length.out = 51) 
h <- hist(csv$source, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_source_pno4.csv")

#########

csv = read.csv("PNO_distribution_1.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$hybrid), to = max(csv$hybrid), length.out = 51) 
h <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_hybrid_pno1.csv")

csv = read.csv("PNO_distribution_2.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$hybrid), to = max(csv$hybrid), length.out = 51) 
h <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_hybrid_pno2.csv")

csv = read.csv("PNO_distribution_3.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$hybrid), to = max(csv$hybrid), length.out = 51) 
h <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_hybrid_pno3.csv")

csv = read.csv("PNO_distribution_4.tsv", header = TRUE, sep = "\t")
breaks <- seq(from = min(csv$hybrid), to = max(csv$hybrid), length.out = 51) 
h <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h$counts=h$counts/sum(h$counts)
breaklimits <- embed(h$breaks, 2)[, 2:1]
data <- data.frame(breaks = breaklimits, probability = h$counts)
write.csv(data, file = "bins_hybrid_pno4.csv")
