#Reading in the metabolomics data.
#Data was generated by the Broad Institute and available publicly

list.of.packages <- c("R.utils", "dplyr", "data.table", "gplots", "reshape2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(R.utils)
library(dplyr)
library(data.table)
library(gplots)
library(reshape2)

#Purpose: This script is used to reproduce the figure for PSET4.

#Background: The microbiome contains incredible diversity of miccoorganisms
#and has profound effects on human health. The 2019 study in Nature Medicine 
#(Poyet M, et al., Nat Med (2019)) sampled 

#The metabolomics dataset is in a text file
#File name: "Study_ST001192_ID_AN001984_metabolomics_pos_ion.txt"
  #For this figure, the data of interest starts at line 297, which is why 
  #as the table is read in, skip = 296 lines.
data <- fread("Data/Study_ST001192_ID_AN001984_metabolomics_pos_ion.txt", skip = 296)

clean_data <- function(df) {
  df[df == ""] <- NA
  
  #Adding diet label to each donor and transposing df frame. 
  #Tranposing makes each metabolite a column and each person/sample a row.
  line1 <- df[1,]
  diets <- gsub("Diet:", "", line1) 
  diets <- gsub("-", "Unknown", diets)
  df_clean <- rbind(as.list(diets), df) %>% t()
  
  #More cleaning...
  #Remove second column and add sample names as its own column.
  df_clean_2 <- df_clean[,-2]
  df_clean_3 <- cbind.data.frame(Samples = rownames(df_clean_2), df_clean_2)
  
  #Correcting column names and row names
  df_clean_3[1,"1"] <- c("Diet")
  df_clean_3[1,1] <- "Sample"
  rownames(df_clean_3) <- c(1:nrow(df_clean_3))
  colnames <- as.character(df_clean_3[1,])
  colnames(df_clean_3) <- colnames
  
  #Remove first row
  df_clean_4 <- df_clean_3[-1,]
  
  #Converting values to numeric
  numerics <- df_clean_4[,c(3:ncol(df_clean_4))] %>% mutate_if(is.character, as.numeric)
  df_clean_5 <- cbind(df_clean_4[,c(1:2)], numerics)
  
  #Normalize data to column mean
  df_clean_6 <- apply(df_clean_5[,-c(1:2)],2,function(x){x/mean(x, na.rm= TRUE)}) %>% data.frame()
  print("Data is now clean and normalized to the column mean!")
  final <- cbind(df_clean_5[,c(1:2)], df_clean_6)
  return(final)
}

data_for_csv <- clean_data(data)
write.csv(data_for_csv, file = "Data/Clean_Metabolmics_Data.csv", row.names = FALSE)
#You should now have clean metabolmics data!