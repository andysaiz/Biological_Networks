#Reading in the clean metabolomics data.

library(gplots)
library(ggplot2)
library(dplyr)
library(readxl)
data <- read.csv("TZ_Scaled_Metabolites.csv")#data is already scaled
metadata <- read_excel("Metabolites_metadata.xlsx")

#Modifying data into numeric matrix for input into unsupervised clustering.
heatmap_data <- data %>% select(-c(1,2)) %>% as.matrix()
#Replacing NAs with 0
heatmap_data[is.na(heatmap_data)] <- 0

#Renaming metabolite codes as metabolite names. 
names <- metadata$label..bona.fide.
colnames(heatmap_data) <- names

#Make a color palette
palette <- viridis::viridis_pal(begin = 0, end = 1, option = "C")

#Question: Which patients have similar metabolite profiles? 
#Approach: Cluster only the rows, leave the columns unclustered.
tiff("Figures/heatmap_metabolomics_cluster_both_axes.tiff", units="in", width=10, height=6, res=300)

#Clustering both axes
heatmap.2(heatmap_data, hclustfun = function(x) hclust(x,method = 'ward.D'),
          dendrogram = "both", 
          col = palette, 
          trace = "none", 
          breaks = seq(0,5,0.2), 
          xlab = "Metabolite",
          ylab = "Sample",
          margins = c(4.5,3), 
          cexCol = 0.3,
          cexRow = 0.4,
          offsetCol = 0.01,
          offsetRow = 0.05,
          key.title = "Abundance",
          key.xlab = "Metab. Rel. Abund.")

dev.off()

#Heatmap clustering only the metabolites. The samples are grouped by
#urban vs rural.
heatmap.2(heatmap_data, hclustfun = function(x) hclust(x,method = 'ward.D'),
          dendrogram = "column",
          col = palette, 
          trace = "none", 
          breaks = seq(0,5,0.2), 
          xlab = "Metabolite",
          ylab = "Sample",
          margins = c(4.5,3), 
          cexCol = 0.3,
          cexRow = 0.4,
          offsetCol = 0.01,
          offsetRow = 0.05,
          key.title = "Abundance",
          key.xlab = "Metab. Rel. Abund.")

dev.off()


