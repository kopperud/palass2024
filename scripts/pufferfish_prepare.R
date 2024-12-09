library(ape)

#tr <- read.tree("data/cetacea/TimeTreeInference/Risky/Cetacea_Risky_Median.tre")
#tr <- read.tree("data/cetacea/TimeTreeInference/Dangerous/Cetacea_Dangerous_Median.tre")
extinct_tree <- read.nexus("data/SI_Dataset_S12_MrBayes_10k_datedPT_noplecto_outputMCC_TreeAnnotator.tre")

## replace 0.0 branch lenghts with 0.1
is_sampled_anc <- which(extinct_tree$edge.length < 0.001)
extinct_tree$edge.length[is_sampled_anc] <- 0.1

## remove the outgroup
ape::plot.phylo(extinct_tree, show.tip.label = F)
nodelabels()

get_tip_labels <- function(phy, node_index){
  if (node_index  <= length(phy$tip.label)){
    return(phy$tip.label[node_index])
  }else{
    descendant_edges <- which(phy$edge[,1] == node_index)
    descendant_nodes <- phy$edge[descendant_edges,2]
    
    r <- lapply(descendant_nodes, function(n) get_tip_labels(phy, n))
    tl <- do.call(c, r) 
  }
  return(tl)
}

ingroup <- get_tip_labels(extinct_tree, 246)
extinct_tree <- keep.tip(extinct_tree, ingroup)

write.tree(extinct_tree, file = "data/SI_Dataset_S12_MrBayes_10k_datedPT_noplecto_outputMCC_TreeAnnotator_extinct.tre")

nodeheights <- node.depth.edgelength(extinct_tree)
treeheight <- max(nodeheights)


ntips <- length(extinct_tree$tip.label)

is_extant <- abs(nodeheights[1:ntips] - treeheight) < 0.01
is_extinct <- !is_extant
extinct_species <- extinct_tree$tip.label[is_extinct]

extant_tree <- drop.tip(extinct_tree, extinct_species)
plot(extant_tree, show.tip.label = F)


ggtree(extinct_tree) + geom_tiplab(size = 1.5)


write.tree(extant_tree, file = "data/SI_Dataset_S12_MrBayes_10k_datedPT_noplecto_outputMCC_TreeAnnotator_extant.tre")
#write.tree(extinct_tree, file = "data/cetacea/cetacea_extinct.tre")



