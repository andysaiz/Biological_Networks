#This script is to investigate the association of sex and age with
#Prevotella copri abundance in the microbiome.

#Input: "Microbiome_data.xlsx"
#Source: "https://doi.org/10.1038/s41467-021-25213-2" (SOURCE DATA)
#Outputs: CDF plot comparing males and females by rank of P. copri abundance.

#Dependencies:
import pandas as pd
import openpyxl
from scipy import stats
import numpy as np
import matplotlib.pyplot as plt

#Defining a function to clean the data. Output data frame
#has sample, age, sex, and bacterial abundance information.
def assign_age_sex(file):
    data_1e = pd.read_excel(file, sheet_name = 'Fig. 1e')
    rank_data = data_1e.iloc[:,[0,1,2,3]]
    #Gender info for NL cohort
    data_1c = pd.read_excel(file, sheet_name = 'Fig. 1c')
    metadata = data_1c.iloc[:,[0,1,2,3]]
    merged1 = pd.merge(rank_data, metadata, on = 'Sample')
    clean = merged1.iloc[:,1:]
    return(clean)

#Assigning age and sex metadata to each sample
data = assign_age_sex("Microbiome_data.xlsx")

#Defining funciton to separate only cases with Prevotella copri data.
#Note: many of the samples had undetected Prevotella copri, so they are tied for rank 0.
def select_prevotella(data_frame):
    subset = data_frame[data_frame['Feature'] == "Prevotella copri"]
    ordered = subset.sort_values('Rank')
    rank = list(range(0, len(ordered)))
    ordered['Prevotella_rank'] = rank
    return(ordered)

#Ranking all samples based on their abundance of Prevotella copri
ranked = select_prevotella(data)
ranked.to_excel("Microbiome_Ranked_for_Prevotella.xlsx")

#Separating male and female to calculate a CDF for each.
male = ranked[ranked['Gender'] == "Male"]
female = ranked[ranked['Gender'] == "Female"]

#Calculating cumulative frequency
seq_M = list(range(1,len(male)+1))
seq_F = list(range(1,len(female)+1))
decimals = 5
cumfreq_M = [round(elem/len(male), decimals) for elem in seq_M]
cumfreq_F = [round(elem/len(female), decimals) for elem in seq_F]

mf_ktest = stats.ks_2samp(cumfreq_M, cumfreq_F)

#Adding the cumulative frequencies to the male and female data frames.
#This is necessary becuase we want to plot y = cumfreq vs x = Prevotella rank
male.loc[:,'Cumulative_frequency'] = cumfreq_M
female.loc[:,'Cumulative_frequency'] = cumfreq_F

#Plot CDF: Male/Female
annotation = "p = " + str(mf_ktest.pvalue)
plt.plot(male.loc[:,"Prevotella_rank"], male.loc[:,"Cumulative_frequency"], color = 'blue', label = "Male")
plt.plot(female.loc[:,"Prevotella_rank"], female.loc[:,"Cumulative_frequency"], color = 'gold', label = "Female")
plt.legend()
plt.xlabel("Rank: Abundance of $\it{P. copri}$")
plt.ylabel("Cumulative Fraction")
plt.annotate(annotation, xy = (0,0.85), color = 'black')
plt.show()
plt.savefig('Male_Female_Prevotella_Rank_CDF.pdf')


