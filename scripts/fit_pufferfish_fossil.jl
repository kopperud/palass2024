using Revise
using Pesto


n_extant_sp = 187
n_total = 433
sampling_fraction = n_extant_sp / n_total

phy = readtree("data/SI_Dataset_S12_MrBayes_10k_datedPT_noplecto_outputMCC_TreeAnnotator_extinct.tre")
tree = construct_tree(phy, sampling_fraction)
Pesto.assign_fossils!(tree, 0.1)

optres, model, i = Pesto.optimize_hyperparameters2(tree; n = 8);

rates = tree_rates(tree, model);

## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

#writenewick("output/cetacea_extinct.tre", data, rates)
writenewick("output/pufferfish_extinct.tre", data, rates)
