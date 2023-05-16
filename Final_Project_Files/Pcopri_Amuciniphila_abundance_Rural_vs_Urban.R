#QUESTION: Do rural and urban populations differ in their P. copri abundance?

setwd("~/Documents/MIT/Biological_Networks/Final_Project")

#Packages: 
library(dplyr)
library(ggplot2)
library(viridis)
library(readxl)
library(ggpubr)

#Sepcies data
data <- read_xlsx("Abundance_species2.xlsx")
#Rural/urban metadata
metadata <- read_xlsx("TZ_metadata.xlsx")

#Joining data to combine species info with rural/urban metadata. 
joined <- left_join(data, select(metadata, ID, Residency_Area))
joined$Residency_Area <- ordered(joined$Residency_Area, levels = c("Urban", "Rural"))

#First, let's visualize the distributions of the rural vs urban populations
hist(joined$Akkermansia.muciniphila)
hist(joined$Prevotella.copri)

#The data is definitely not normally distributed, so if we compare
#the distributions, we should use a nonparametric test.
bar_colors <- c("#E69F00", "#56B4E9")

p1 <- ggplot(joined, aes(x=Residency_Area, y=Prevotella.copri)) +
  geom_boxplot(color = bar_colors) +
  theme_minimal()+
  theme(legend.position="none") +
  coord_flip() + # This switch X and Y axis and allows to get the horizontal version
  stat_compare_means(method = "wilcox.test", label.x = 1.5, label.y = 40)+
  xlab("") +
  ylab(expression(paste("Relative Abundance: ",italic("P. Copri"))))+
  theme(axis.text = element_text(size = 12, face = "bold"),
        axis.title = element_text(size = 12, face = "bold"),
        axis.line = element_line(size = 1.0, color = "black"), 
        axis.ticks = element_line(size = 1.0, color = "black"))

p1

#QUESTION: How does P. copri relative bundance vary by age?





p1 #boxplot
pdf("Figures/Boxplot_Pcopri_Abundance_Rural_Urabn.pdf", width = 8, height = 5, pointsize = 12)
print(p1)
dev.off()




