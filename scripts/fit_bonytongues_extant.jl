using Revise
using Pesto


#sampling_fraction = 89/94
sampling_fraction = 0.234

#phy = readtree("data/cetacea/cetacea_extant.tre")
phy = readtree("data/osteoglossomorpha_extant.tre")
tree = construct_tree(phy, sampling_fraction)
#assign_fossils!(tree, 0.5)

optres, model, i = Pesto.optimize_hyperparameters2_zeropsi(tree; n = 8);

rates = tree_rates(tree, model);

## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

#writenewick("output/cetacea_extant.tre", data, rates)
writenewick("output/osteoglossomorpha_extant.tre", data, rates)
