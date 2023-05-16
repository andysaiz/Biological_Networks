#Instructions on how to load the Robj and save as xlsx

#Set your working directory: 
  #Session --> set working directory -->

#Run this block to install packages
list.of.packages <- c("writexl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

#load Robj
load("Robjfilename")

#Select which data you want
sheet_I_want <- obj$first_level_down$second_level_down$third_level_down
  #example: obj$assays$Kingdom$data

#Save my sheet as xlsx
writexl::write_xlsx(sheet_I_want, "filename.xlsx")

#Will save to your working directory as .xlsx