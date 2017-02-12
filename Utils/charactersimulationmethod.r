library(ape)
library(geiger)
tree <- read.nexus("tree.tre")

# 5 examples with slower evolution and higher starting values
treesim1 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 10)
write.table(treesim1, file = "character1.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim2 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 10)
write.table(treesim2, file = "character2.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim3 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 10)
write.table(treesim3, file = "character3.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim4 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 10)
write.table(treesim4, file = "character4.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim5 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 10)
write.table(treesim5, file = "character5.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)


# 5 examples with slower evolution and lower starting values
treesim6 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 5)
write.table(treesim6, file = "character6.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim7 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 5)
write.table(treesim7, file = "character7.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim8 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 5)
write.table(treesim8, file = "character8.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim9 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 5)
write.table(treesim9, file = "character9.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim10 <- sim.char(tree, 0.05, nsim = 1, model = ("BM"), root = 5)
write.table(treesim10, file = "character10.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)


# 5 examples with faster evolution and higher starting values
treesim11 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 10)
write.table(treesim11, file = "character11.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim12 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 10)
write.table(treesim12, file = "character12.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim13 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 10)
write.table(treesim13, file = "character13.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim14 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 10)
write.table(treesim14, file = "character14.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim15 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 10)
write.table(treesim15, file = "character15.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)


# 5 examples with faster evolution and lower starting values
treesim16 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 5)
write.table(treesim16, file = "character16.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim17 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 5)
write.table(treesim17, file = "character17.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim18 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 5)
write.table(treesim18, file = "character18.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim19 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 5)
write.table(treesim19, file = "character19.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)
treesim20 <- sim.char(tree, 0.1, nsim = 1, model = ("BM"), root = 5)
write.table(treesim20, file = "character20.txt", append = FALSE, sep = "\t", row.names = TRUE, col.names=FALSE)

