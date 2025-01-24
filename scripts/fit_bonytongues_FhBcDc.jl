using Revise
using Pesto


#sampling_fraction = 89/94
sampling_fraction = 0.234

phy = readtree("data/osteoglossomorpha.tre")
tree = construct_tree(phy, sampling_fraction)
Pesto.assign_fossils!(tree, 0.1)

#optres, model, i = Pesto.optimize_hyperparameters2(tree; n = 8);
optres, model, i = fit_FhBcDc(tree; n = 8);

rates = tree_rates(tree, model);
sort!(rates, :edge)

branches = get_branches(tree);
d = Dict{Int64, Float64}()
for branch in branches
    d[branch.index] = branch.time
end

brlens = Float64[]
for i in 1:length(branches)
    bl = d[i] 
    push!(brlens, bl)
end

#mean_lambda = sum(brlens .* rates[2:end,:mean_lambda]) / sum(brlens)
mean_psi = sum(brlens .* rates[2:end,:mean_psi]) / sum(brlens)

tl = treelength(tree)

N_psi    = tl * model.β


## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

writenewick("output/osteoglossomorpha_FhBcDc.tre", data, rates)
