#Strazar et al. provides access to their study data in the form of an R object.
#After downloading the R object, it can be loaded into R. 
#Data format: list within list within list

#Packages: 
library(writexl)

#Loading data
  #Loading Netherlands (NL) R object
  setwd("~/Documents/MIT/Biological_Networks/Final_Project/R_Object_Data/data")
  load("data.NL.Robj")
  NL <- obj
  
  #Loading Tanzania (TZ) R object
  load("data.TZ.Robj")
  TZ <- obj
  rm(obj) #remove original object to save memory
  
  #Quantification of bacteria, archea, eukarya per sample
  TZkingdom <- data.frame(TZ$assays$Kingdom$data)
  TZgenus <- data.frame(TZ$assays$Genus$data)
  TZspecies <- data.frame(TZ$assays$Species$data)
  TZspecies_2 <- data.frame(TZ$assays$Species_from_lm$data)
  TZdiet <- data.frame(TZ$assays$Diet$data)
  TZcytokine <- data.frame(TZ$assays$Cytokines$data)
  TZeukaryota <- data.frame(TZ$assays$Eukaryota$data)
  TZmetab <- data.frame(TZ$assays$Metabolites$metadata)
  TZmetab_data <- data.frame(TZ$assays$Metabolites$data)
  TZ_metadata <- data.frame(TZ$metadata)

#Broad question: How does P. copri affect the immune system differently in 
#different regions?

###Cleaning Data###
  #A. muciniphila and P. copri is contained within TZspecies_2
  #I am unclear on what the difference is between the lists "Species"
  #and "Species_from_lm" in the original R object.
  Sp2_alph <- TZspecies_2[, order(names(TZspecies_2))] #relative abundance info
  Sp2_alph <- cbind(ID = rownames(Sp2_alph), Sp2_alph) #Adding the patient
  #ID as a column
  
  #Cleaning diet data 
  TZdiet_cl <- cbind(ID = rownames(TZdiet), TZdiet)

  #Cleaning metadata
  TZ_meta <- cbind(ID = rownames(TZ_metadata), TZ_metadata)
  
#Saving Data
  #Species
  setwd("~/Documents/MIT/Biological_Networks/Final_Project")
  writexl::write_xlsx(species2, "Abundance_species2.xlsx")
  #Diet
  writexl::write_xlsx(TZdiet_cl, "Diet.xlsx")
  #Metadata
  writexl::write_xlsx(TZ_meta, "TZ_metadata.xlsx")
  #Metabolites
  writexl::write_xlsx(TZmetab_data, "TZ_metabolites.xlsx")









