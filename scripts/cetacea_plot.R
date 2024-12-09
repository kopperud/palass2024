
setwd("/home/bkopper/projects/palass2024/")


library(ape)

#tr <- read.tree("data/cetacea/TimeTreeInference/Risky/Cetacea_Risky_Median.tre")
#tr <- read.tree("data/cetacea/TimeTreeInference/Dangerous/Cetacea_Dangerous_Median.tre")
extinct_tree <- read.tree("data/cetacea/TimeTreeInference/Safe/Cetacea_Safe_Median.tre")

ape::plot.phylo(extinct_tree, show.tip.label = F)

nodeheights <- node.depth.edgelength(extinct_tree)
treeheight <- max(nodeheights)


ntips <- length(extinct_tree$tip.label)

is_extant <- abs(nodeheights[1:ntips] - treeheight) < 0.01

is_extinct <- !is_extant

extinct_species <- extinct_tree$tip.label[is_extinct]

extant_tree <- drop.tip(extinct_tree, extinct_species)

plot(extant_tree, show.tip.label = F)


write.tree(extant_tree, file = "data/cetacea/cetacea_extant.tre")
write.tree(extinct_tree, file = "data/cetacea/cetacea_extinct.tre")



