#This script is to generate a plot comparing age and P. copri abundance.

#Inputs: "Microbiome_Ranked_for_Prevotella.xlsx"
#Outputs: xy scatter plot

#Dependencies:
import pandas as pd
import openpyxl
from scipy import stats
import numpy as np
import matplotlib.pyplot as plt

#Reading in the data
data = pd.read_excel("Microbiome_Ranked_for_Prevotella.xlsx")

#Subsetting only the "age" and "Prevotella_rank" columns
subset = data.loc[:,['Age', 'Prevotella_rank']]

#Plotting scatter plot
plt.scatter(subset.loc[:,'Prevotella_rank'], subset.loc[:,'Age'], color = 'gray')
plt.xlabel("Rank: Abundance of $\it{P. copri}$")
plt.ylabel('Age')
plt.show()
plt.savefig('XY_Scatter_Age_Prevotella_rank.pdf')



