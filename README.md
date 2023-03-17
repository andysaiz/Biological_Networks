##Overview: 
  #This Repo (Biological_Networks) contains R Scripts to reproduce the heatmap
  #as a .tiff file. The executable scripts are:

  #1) Clean_Metabolomics_Data.R
  #2) Heatmap.R
  
  #Instructions below on how to run scripts >>>>>>>> KEEP READING >>>>>

##Data
#Source:
  #The data was generated using Orbitrap Mass-Spectrometry and measured
  #various metabolites from stool samples of donors from the Boston area (
  #Poyet M, et al, Nat Med. 2019 Sep;25(9):1442-1452. doi: 10.1038/s41591-019-0559-3.
  #Data is publicly available and downloadable from Metabolomics Workbench 
  #(https://www.metabolomicsworkbench.org/data/DRCCMetadata.php?Mode=Study&StudyID=ST001192&   StudyType=MS&ResultType=5)

  #File name: "Study_ST001192_ID_AN001984_metabolomics_pos_ion.txt"

##Folder Structure
  #This repo contains:
  #1) README.md (this file)

  #2) Clean_Metabolomics_Data.R (processes raw data into tidy data, returns
  #a CSV file called "Clean_Metabolomics_Data.csv")

  #3) Heatmap.R (reads tidy data and outputs heatmap as TIFF file)

##Instructions to Reproduce Figure
#Download the repo (two R scripts and one .txt file) and run these commands
#in the command line: 

Rscript Clean_Metabolomics_Data.R
Rscript Heatmap.R
