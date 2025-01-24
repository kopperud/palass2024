using Revise
using Pesto


n_extant_sp = 187
n_total = 433
sampling_fraction = n_extant_sp / n_total

phy = readtree("data/SI_Dataset_S12_MrBayes_10k_datedPT_noplecto_outputMCC_TreeAnnotator_extinct.tre")
tree = Pesto.construct_tree(phy, sampling_fraction)
#Pesto.assign_fossils!(tree, 0.05)

optres, model, i = fit_FhBhDc(
              tree; 
              lower = [1e-5, 1e-5, 1e-4, 1e-20, 1e-20], 
              upper = [0.4, 0.3, 0.5, 0.3, 0.3], 
              n = 9);

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

mean_lambda = sum(brlens .* rates[2:end,:mean_lambda]) / sum(brlens)
mean_psi = sum(brlens .* rates[2:end,:mean_psi]) / sum(brlens)

tl = treelength(tree)

N_lambda = tl * model.α
N_psi    = tl * model.β


## steal the data object so we can print the newick string
data = SSEdata(phy, sampling_fraction)

writenewick("output/pufferfish_FhBhDc.tre", data, rates)
