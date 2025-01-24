using Revise
using Pesto

#sampling_fraction = 89/94
sampling_fraction = 0.234

phy = readtree("data/osteoglossomorpha.tre")
tree = Pesto.construct_tree(phy, sampling_fraction)
Pesto.assign_fossils!(tree, 0.1)

model = fit_FcBcDc(tree);

#rates = tree_rates(tree, model);
#sort!(rates, :edge)

#mean_lambda = sum(brlens .* rates[2:end,:mean_lambda]) / sum(brlens)
tl = treelength(tree)
#N_lambda    = tl * model.α

## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

#writenewick("output/osteoglossomorpha_FcBcDc.tre", data, rates)
