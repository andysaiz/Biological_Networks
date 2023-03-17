## Overview
This Repo (Biological_Networks) contains R Scripts to
reproduce the heatmap as a .tiff file. The executable scripts are:

1) Clean_Metabolomics_Data.R 
2) Heatmap.R

Instructions below on how to run scripts \>\>\>\>\>\>\>\> KEEP READING
\>\>\>\>\>

## Data
> Source: The data was generated using Orbitrap Mass-Spectrometry
and measured #various metabolites from stool samples of donors from the Boston area (Poyet M, et al, Nat Med. 2019 Sep;25(9):1442-1452. doi:
10.1038/s41591-019-0559-3). Data is publicly available and downloadable
from [Metabolomics Workbench](https://www.metabolomicsworkbench.org/data/DRCCMetadata.php?Mode=Study&StudyID=ST001192&>
StudyType=MS&ResultType=5)

>File name: "Study_ST001192_ID_AN001984_metabolomics_pos_ion.txt"

## Folder Structure 
### /Code 
>Clean_Metabolomics_Data.R (processes raw data
into tidy data, returns a CSV file called "Clean_Metabolomics_Data.csv")

> Heatmap.R (reads tidy data and outputs
heatmap as TIFF file) 

### /Data

> Study_ST001192_ID_AN001984_metabolomics_pos_ion.txt (raw data)

### /Figures

### /Everything_You_Need 
>Clean_Metabolomics_Data.R 

> Heatmap.R

> Study_ST001192_ID_AN001984_metabolomics_pos_ion.txt

## Instructions to Reproduce Figure 
1) Download the repo
"Everything_You_Need" 
2) Change your working directory on the command
line to the new, downloaded #repository subfolder called
"Everything_You_Need" #Run the following commands in the command line:

```
Rscript Clean_Metabolomics_Data.R 
```
```
Rscript Heatmap.R
```
```
#NOTE: you might run into issues with permissions, especially if the
repository #goes into your Downloads folder (Mac users). If that's the
case, you can run #each R script separately in R Studio.

##Dependencies: 
R\\4.2.1 

R Packages: 
R.utils 12.12.2 
dplyr 1.0.10
data.table 1.14.6 
gplots 3.1.3 
reshape2 1.4.4 
ggplot2 3.3.6
```