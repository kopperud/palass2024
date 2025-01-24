library(treeio)
library(ggplot2)
library(ggtree)
library(ape)
library(patchwork)

library(deeptime)

setwd("~/projects/palass2024")

#tree1 <- read.beast.newick("output/osteoglossomorpha_FcBcDc.tre")
tree2 <- read.beast.newick("output/osteoglossomorpha_FcBhDc.tre")
tree3 <- read.beast.newick("output/osteoglossomorpha_FhBcDc.tre")
tree4 <- read.beast.newick("output/osteoglossomorpha_FhBhDc.tre")

tree1 <- tree2
tree1@data$mean_netdiv <- rep(0.26165380773128677 - 0.25305919941929744, length(tree1@data$mean_netdiv))
tree1@data$mean_psi <- rep(0.0011345264013193892, length(tree1@data$mean_psi))

trees <- list(tree1, tree2,tree3, tree4)

tl_extant <- sum(tree_extant@phylo$edge.length)
tl_total <- sum(tree_total@phylo$edge.length)

## set common color scale limits
min1 <- min(sapply(trees, function(tree) min(tree@data$mean_netdiv)))
max1 <- max(sapply(trees, function(tree) max(tree@data$mean_netdiv)))
extrema1 <- c(min1, max1)

min2 <- min(sapply(trees, function(tree) min(tree@data$mean_psi)))
max2 <- max(sapply(trees, function(tree) max(tree@data$mean_psi))) + 0.0001
extrema2 <- c(min2, max2)


fgcolor <- "black"
bgcolor <- "white"

th <- max(node.depth.edgelength(tree2@phylo))
scalexformat <- function(x) sprintf("%.0f", abs(th - round(x, 0)))

## node 124 is Mormyridae

ggtree(tree_total) +
  ggtree::geom_cladelab(node = 124, label = "Mormyridae")

p1a <- revts(ggtree(tree1, aes(color = mean_netdiv)) +
  scale_color_gradient(limits = extrema1, name = "netdiv") +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2()) +
  ggtitle("Model A")


p2a <- revts(ggtree(tree2, aes(color = mean_netdiv)) +
  scale_color_gradient(limits = extrema1, name = "netdiv") +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2()) +
  ggtitle("Model B")

p3a <- revts(ggtree(tree3, aes(color = mean_netdiv)) +
  scale_color_gradient(limits = extrema1, name = "netdiv") +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2()) +
  ggtitle("Model C")

p4a <- revts(ggtree(tree4, aes(color = mean_netdiv)) +
  scale_color_gradient(limits = extrema1, name = "netdiv") +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2()) +
  ggtitle("Model D")


p1b <- revts(ggtree(tree1, aes(color = mean_psi)) +
  scale_color_gradient(limits = extrema2, low = "black", high = "red", name = "fosl.") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

p2b <- revts(ggtree(tree2, aes(color = mean_psi)) +
  scale_color_gradient(limits = extrema2, low = "black", high = "red", name = "fosl.") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

p3b <- revts(ggtree(tree3, aes(color = mean_psi)) +
  scale_color_gradient(limits = extrema2, low = "black", high = "red", name = "fosl.") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

p3b <- revts(ggtree(tree3, aes(color = mean_psi)) +
  scale_color_gradient(limits = extrema2, low = "black", high = "red", name = "fosl.") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())

p4b <- revts(ggtree(tree4, aes(color = mean_psi)) +
  scale_color_gradient(limits = extrema2, low = "black", high = "red", name = "fosl.") +
  coord_geo(xlim = c(-206, 0), size = 3, ylim = c(-2, Ntip(tree_total)+2),
            neg = TRUE, abbrv = TRUE, height = unit(1, "line")) +
  scale_x_continuous(breaks = seq(-200, 0, 50), labels = abs(seq(-200, 0, 50))) +
  theme_tree2())


px <- p1a + p2a + p3a + p4a + 
  p1b + p2b + p3b + p4b + plot_layout(ncol = 4, guides = "collect")
px


#ggsave("figures/osteoglossomorpha.pdf", width = 160, height = 80, units = "mm")
ggsave("figures/osteoglossomorpha_4models.pdf", width = 160, height = 120, units = "mm")

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


