using Revise
using Pesto

n_extant_sp = 187
n_total = 433
sampling_fraction = n_extant_sp / n_total

phy = readtree("data/SI_Dataset_S12_MrBayes_10k_datedPT_noplecto_outputMCC_TreeAnnotator_extinct.tre")
tree = Pesto.construct_tree(phy, sampling_fraction)
#Pesto.assign_fossils!(tree, 0.05)

model = fit_FcBcDc(tree);

#rates = tree_rates(tree, model);
#sort!(rates, :edge)

#mean_lambda = sum(brlens .* rates[2:end,:mean_lambda]) / sum(brlens)
tl = treelength(tree)
#N_lambda    = tl * model.α

## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

#writenewick("output/pufferfish_FcBcDc.tre", data, rates)
