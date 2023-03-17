#Purpose: This script is used to reproduce the figure for PSET4.
#Reading in the clean metabolomics data.
library(gplots)
library(colorRamps)
library(ggplot2)
library(dplyr)
data <- read.csv("Clean_Metabolmics_Data.csv")

#Modifying data into numeric matrix for input into unsupervised clustering.
heatmap_data <- data %>% select(-c(1,2)) %>% as.matrix()
#Replacing NAs with 0
heatmap_data[is.na(heatmap_data)] <- 0

#Make a color palette
palette <- viridis::viridis_pal(begin = 0, end = 1, option = "C")

#Question: Which patients have similar metabolite profiles? 
#Approach: Cluster only the rows, leave the columns unclustered.
tiff("heatmap_metabolomics.tiff", units="in", width=10, height=6, res=300)

heatmap.2(heatmap_data, hclustfun = function(x) hclust(x,method = 'complete'),
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