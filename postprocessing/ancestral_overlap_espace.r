#!/usr/bin/env Rscript
# Breaks: Need n+1 to give a fencepost
# The tsv files of course do not actually have to be called twice and the second call in each pair can be skipped
# It is possible one might wish to call on different tsvs

# Assumes MCMC output has been pre-processed for the geographic projection step, i.e. concatenated and thinned
# Although this is set up as a shell executable, run in R console.

csv = read.csv("PNO_distribution_1.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_2.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_3.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_4.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_5.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_6.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_7.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_8.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_9.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_10.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_11.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)

#########

csv = read.csv("PNO_distribution_12.tsv", header = TRUE, sep = "\t")

breaks <- seq(from = min(c(csv$source,csv$hybrid)), to = max(c(csv$source,csv$hybrid)), length.out = 51) 

h_source <- hist(csv$source, breaks = breaks, plot=FALSE)
h_source$counts=h_source$counts/sum(h_source$counts)
breaklimits_source <- embed(h_source$breaks, 2)[, 2:1]
data_source <- data.frame(breaks = breaklimits_source, probability = h_source$counts)


h_hybrid <- hist(csv$hybrid, breaks = breaks, plot=FALSE)
h_hybrid$counts=h_hybrid$counts/sum(h_hybrid$counts)
breaklimits_hybrid <- embed(h_hybrid$breaks, 2)[, 2:1]
data_hybrid <- data.frame(breaks = breaklimits_hybrid, probability = h_hybrid$counts)

minimum <- pmin(data_source$probability, data_hybrid$probability)
Reduce("+", minimum)
