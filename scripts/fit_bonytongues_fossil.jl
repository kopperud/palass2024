using Revise
using Pesto


#sampling_fraction = 89/94
sampling_fraction = 0.234

phy = readtree("data/osteoglossomorpha.tre")
tree = construct_tree(phy, sampling_fraction)
Pesto.assign_fossils!(tree, 0.1)

optres, model, i = Pesto.optimize_hyperparameters2(tree; n = 8);

rates = tree_rates(tree, model);

## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

#writenewick("output/cetacea_extinct.tre", data, rates)
writenewick("output/osteoglossomorpha_extinct.tre", data, rates)
