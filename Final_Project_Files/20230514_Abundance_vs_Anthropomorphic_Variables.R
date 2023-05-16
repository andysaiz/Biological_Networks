#This script answers the question:
#Does P. copri abundance vary by age or sex?

library(dplyr)
library(ggplot2)
library(readxl)
library(ggpubr)
library(gridExtra)

#Reading in sepcies abundance data.
#The data was already scaled in the processing script.
abd <- read_excel("Abundance_species2.xlsx")

#Getting age metadata 
meta <- read_excel("TZ_metadata.xlsx")

#Merging abundance and metadata data frames
abd_meta <- full_join(abd, meta, by = "ID")

#Doing some preprocessing on the Drinking Water column to make the
#values more intuitive.
water_staus <- character(nrow(abd_meta))
for (i in 1:nrow(abd_meta)) {
  if (abd_meta$Drinking_Water[i] == "unboilled tape water(raw water)") {
    water_status[i] <- "unboiled"
  } else {
    water_status[i] <- "boiled"
  }
}
abd_meta$Drinking_Water <- water_status

#Grouping the data for plotting later
abd_meta <- abd_meta %>% group_by(Gender, Residency_Area, Drinking_Water)
abd_meta$Residency_Area <- ordered(abd_meta$Residency_Area, levels = c("Rural", "Urban"))

#General plotting items:
palette = c("lightsalmon2", "wheat4")

#Plotting distributions distributions of P. copri by different variables: 
#Age
  #x = age
  #y = P. copri relative abundance
  age <- ggplot(abd_meta, aes(x = Age, y = Prevotella.copri)) + 
    geom_point(color = "lightpink3")+ 
    scale_x_continuous(limits = c(0,70), expand = c(0, 0)) +
    scale_y_continuous(limits = c(0,80), expand = c(0, 0))+
    theme(legend.position = "none")+
    theme_minimal()+
    ylab("P. copri Abundance")+
    theme(axis.text = element_text(size = 12, face = "bold"),
          axis.title = element_text(size = 12, face = "bold"),
          axis.line = element_line(size = 1.0, color = "black"), 
          axis.ticks = element_line(size = 1.0, color = "black"))
  
#Male/female
  #Grouping the data by gender
  
  mf_boxplot <- ggboxplot(abd_meta, x = "Gender", y = "Prevotella.copri",
                          color = "Gender", 
                          palette =palette,
                          add = "jitter")+
                ylab("P. copri Abundance")+
                theme(legend.position = "none")+
                theme(axis.text = element_text(size = 12, face = "bold"),
                axis.title = element_text(size = 12, face = "bold"),
                axis.line = element_line(size = 1.0, color = "black"), 
                axis.ticks = element_line(size = 1.0, color = "black"))
  
#Performing Wilcoxon test (non-parametric)
  male_vals <- filter(abd_meta, Gender == "Male") %>% select(Prevotella.copri)
  female_vals <- filter(abd_meta, Gender == "Female") %>% select(Prevotella.copri)
  mf_wilcox <- wilcox.test(male_vals$Prevotella.copri, female_vals$Prevotella.copri)
  print(mf_wilcox)
  #It looks like there is a significant difference in P. copri abundance between 
  #males and females.


#Geographic area
  geo_boxplot <- ggboxplot(abd_meta, x = "Residency_Area", y = "Prevotella.copri",
                          color = "Residency_Area", 
                          palette =palette,
                          add = "jitter")+
    xlab("Residency Area")+
    ylab("P. copri Abundance")+
    theme(legend.position = "none")+
    theme(axis.text = element_text(size = 12, face = "bold"),
          axis.title = element_text(size = 12, face = "bold"),
          axis.line = element_line(size = 1.0, color = "black"), 
          axis.ticks = element_line(size = 1.0, color = "black"))
  
  #Performing Wilcoxon test (non-parametric)
  rural_vals <- filter(abd_meta, Residency_Area == "Rural") %>% select(Prevotella.copri)
  urban_vals <- filter(abd_meta, Residency_Area == "Urban") %>% select(Prevotella.copri)
  geo_wilcox <- wilcox.test(rural_vals$Prevotella.copri, urban_vals$Prevotella.copri)
  print(geo_wilcox)
  #It looks like there is a significant difference in P. copri abundance between
  #rural and urban environments. 
  #Rural is higher.

#Drinking water
  water_boxplot <- ggboxplot(abd_meta, x = "Drinking_Water", y = "Prevotella.copri",
                           color = "Drinking_Water", 
                           palette =palette,
                           add = "jitter")+
    xlab("Drinking Water")+
    ylab("P. copri Abundance")+
    theme(legend.position = "none")+
  theme(axis.text = element_text(size = 12, face = "bold"),
        axis.title = element_text(size = 12, face = "bold"),
        axis.line = element_line(size = 1.0, color = "black"), 
        axis.ticks = element_line(size = 1.0, color = "black"))
  
  #Wilcoxon test
  #Performing Wilcoxon test (non-parametric)
  boiled_vals <- filter(abd_meta, Drinking_Water == "boiled") %>% select(Prevotella.copri)
  unboiled_vals <- filter(abd_meta, Drinking_Water == "unboiled") %>% select(Prevotella.copri)
  water_wilcox <- wilcox.test(boiled_vals$Prevotella.copri, unboiled_vals$Prevotella.copri)
  print(water_wilcox)
  #It looks like there is a significant difference in P. copri abundance between
  #drinking boiled and unboiled tap water. 
  #Unboiled is higher.

gridExtra::grid.arrange(age, mf_boxplot, geo_boxplot, water_boxplot, ncol=2)
  


  