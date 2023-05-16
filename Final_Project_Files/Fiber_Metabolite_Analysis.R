#Effect of dieterary fiber on succinate levels

#Data (Excel sheets) needed: 
  #diet
  #metabolite_data

setwd("~/Documents/MIT/Biological_Networks/Final_Project")

#Packages: 
library(dplyr)
library(ggplot2)
library(viridis)
library(readxl)
library(ggpubr)

#Question 1: Does higher dietary fiber correlate with higher succinate levels?**
  #Rationale: Dietary fiber is broken down into succinate by gut microbes. 
  #Hypothesis: High fiber diets will have higher succinate levels.
  #Test: Plot fiber intake vs succinate level

#Diet vs Succinate
#Rural will have a higher fiber intake than urban TZ
  #Calculate the fiber intake for each patient by summing the servings of
  #ugali, wheat, beans, vegetables, and fruits. 
  diet <- read_xlsx("Diet.xlsx")
  Fiber <- diet %>% group_by(ID) %>% 
    summarize(ID = ID, Fiber = sum(Ugali, Wheat, Beans, Vegetables, Fruits))
  write_xlsx(Fiber, "Fiber.xlsx")
  #Merging metadata containing geographic location with fiber data
  fiber_loc <- inner_join(select(TZ_meta, ID, Gender, Residency_Area), Fiber)
  #Plotting the average number of y = fibrous servings vs x = geographic region
  summary1 <- fiber_loc %>% group_by(Residency_Area) %>% summarize(Mean_Fiber = mean(Fiber))
  bar_colors <- c("#E69F00", "#56B4E9")

  p1 <- ggplot(summary1, aes(x = Residency_Area, y = Mean_Fiber, fill = Residency_Area)) + 
    geom_bar(stat = "identity", width = 0.2) + 
    ylab("Average Number of High-Fiber Servings per Week")+ 
    xlab("Residency Area")+
    theme_minimal()+
    scale_y_continuous(limits = c(0,25))+
    scale_fill_manual(values = bar_colors)+
    theme(axis.text = element_text(size = 12, face = "bold"),
          axis.title = element_text(size = 12),
          axis.line = element_line(size = 1.0, color = "black"), 
          axis.ticks = element_line(size = 1.0, color = "black"))+ 
    theme(legend.position = "none")+
    theme(plot.margin = unit(c(3, 10, 1, 0.5), "cm"))
  
  
#Fiber vs Succinate
  #Now we need to see the succinate levels from the metabolites data set.
  succ_code <- "mbx0048" #the metabolite code for succinate
  #The scale() function scales each column (or row) to have zero mean and unit 
  #variance, which is often useful in data analysis and modeling.
  met_scaled <- scale(TZmetab_data)
  #Saving the scaled metaoblite data set
  write.csv(met_scaled, "TZ_Scaled_Metabolites.csv")
  
  #Looking specifically at succinate
  log2succinate <- data.frame(met_scaled) %>% select(mbx0048) 
  succinate <- cbind.data.frame(ID = rownames(log2succinate), log2_succinate = log2succinate$mbx0048)
  #Adding rural vs urban data to succinate
  succ_geo <- left_join(succinate, TZ_meta)
  
#QUESTION: Do metabolite profiles cluster togehter by geographic region? 
  #Hypothesis: yes because they are exposed to similar environmental factors.
  #Approach: t-SNE
  
#QUESTION: Does succinate differ by geographic location? 
  #Hypothesis: yes, because their environmental exposures are different
  #and their metabolites clearly allow them to cluster together. 
  #Violin plot
  p3data <- select(succ_geo, ID, log2_succinate, Residency_Area)
  p3data$Residency_Area <- ordered(p3data$Residency_Area, levels = c("Urban", "Rural"))

  bar_colors <- c("#E69F00", "#56B4E9")
  
  histogram_check <- ggplot(p3data, aes(x = log2_succinate, fill = Residency_Area)) +
    geom_histogram()
  #From the histogram, we can see that the data are approximately normally distributed.
  #Therefore, it is appropriate to use a two-sample t-test.
  
  p3 <- ggplot(p3data, aes(x=Residency_Area, y=log2_succinate)) +
    geom_boxplot(color = bar_colors) +
    theme_minimal()+
    theme(legend.position="none") +
    coord_flip() + # This switch X and Y axis and allows to get the horizontal version
    stat_compare_means(method = "t.test", label.x = 1.5, label.y = 2)+
    xlab("") +
    ylab(expression('log'[2]*'(succinate)'))+
    theme(axis.text = element_text(size = 12, face = "bold"),
        axis.title = element_text(size = 12, face = "bold"),
        axis.line = element_line(size = 1.0, color = "black"), 
        axis.ticks = element_line(size = 1.0, color = "black"))
  p3
  #Hypothesis: High fiber will correlate to high succinate levels.
  #Plotting the distribution of succinate levels.
  #Do the ones that have the highest fiber content cluster together? Do they 
  #have similar metabolic profiles?

  

#Code to save all the plot objects as high resolution PDFs

p1 #barplot
  pdf("ResidencyArea_Fiber.pdf", width = 8, height = 5, pointsize = 12)
  print(p1)
  dev.off()
  
p3 #boxplot
  pdf("Boxplot_Succinate_Rural_vs_Urban")
  print(p3)
  dev.off()
  