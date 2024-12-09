library(treeio)
library(ggplot2)
library(ggtree)
library(ape)
library(patchwork)

library(deeptime)

tree_extant <- read.beast.newick("output/osteoglossomorpha_extant.tre")
tree_total <- read.beast.newick("output/osteoglossomorpha_extinct.tre")

tl_extant <- sum(tree_extant@phylo$edge.length)
tl_total <- sum(tree_total@phylo$edge.length)

## set common color scale limits
min1 <- min(c(min(tree_extant@data$mean_netdiv), min(tree_total@data$mean_netdiv)))
max1 <- max(c(max(tree_extant@data$mean_netdiv), max(tree_total@data$mean_netdiv)))
extrema <- c(min1, max1)

fgcolor <- "black"
bgcolor <- "white"

th <- max(node.depth.edgelength(tree_total@phylo))
scalexformat <- function(x) sprintf("%.0f", abs(th - round(x, 0)))

## node 124 is Mormyridae

ggtree(tree_total) +
  ggtree::geom_cladelab(node = 124, label = "Mormyridae")

p1 <- revts(ggtree(tree_extant, aes(color = mean_netdiv)) +
  scale_color_gradient(limits = extrema, name = "") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

p2 <- revts(ggtree(tree_total, aes(color = mean_netdiv)) +
  scale_color_gradient(limits = extrema, name = "") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

p3 <- revts(ggtree(tree_total, aes(color = mean_psi)) +
  scale_color_gradient(low = "black", high = "red", name = "") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

px <- p1 + p2 + p3 + plot_layout(guides = "collect")

px

ggsave("figures/osteoglossomorpha.pdf", width = 160, height = 80, units = "mm")

mean(tree_extant@data$mean_mu)
mean(tree_total@data$mean_mu)


df <- tibble(
  "tree" = c("extant", "extant+extinct"),
  "mu" = c(0.048, 0.126),
  )

p_extinction <- ggplot(df, aes(x = tree, y = mu)) + 
  geom_bar(stat = "identity", fill = "orange") +
  theme_classic() +
  labs(y = "extinction rate", x = "")
ggsave("figures/bonytongues_mu.pdf", p_extinction, width = 70, height = 80, units = "mm")





alpha_total <- 0.00027152494141362537
alpha_total * tl_total

alpha_extant <- 0.001812075711739776
alpha_extant * tl_extant

beta_total <- 0.00859605770454397
beta_total * tl_total


