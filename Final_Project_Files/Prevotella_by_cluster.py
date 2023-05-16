#This script is to take sample+cluster_assignment data and add
#information about its prevotella abundance.

#Inputs: "Samples_with_Cluster_Assignment.xlsx", "Microbiome_Ranked_for_Prevotella.xlsx"

#Dependencies
import pandas as pd
from scipy import stats
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from statsmodels.stats.multicomp import pairwise_tukeyhsd

#Loading microbiome data with Prevotella abundance rank information
prevotella = pd.read_excel('Microbiome_Ranked_for_Prevotella.xlsx') #Contains both NL and TZ
subset = prevotella[prevotella['Cohort'] == "TZ"]

#Loading samples+cluster_assignments
cluster_df = pd.read_excel('Samples_with_Cluster_Assignment.xlsx') #All TZ samples with clusters assigned


#Merging 1) df containing Prevotella info with 2) df containing cluster assignments
merged = pd.merge(subset, cluster_df, on = 'Sample')

#Splitting the data frame up by cluster
grouped_df = merged.groupby('Cluster')
stored_groups = [grouped_df.get_group(x) for x in grouped_df.groups]

#Creating a data frame with the samples in each cluster
C1_ranks = list(stored_groups[0]['Rank'])
C2_ranks = list(stored_groups[1]['Rank'])
C3_ranks = list(stored_groups[2]['Rank'])

#We now have three lists corresponding to the three clusters.
#Each has the ranks of prevotella abundance for the samples in that cluster.
#We will compare the three of them using an ANOVA.
f_stat, p_value = stats.f_oneway(C1_ranks, C2_ranks, C3_ranks)
    #This ANOVA result tells us if there IS a difference, not which one.

#Now prepping data for post-hoc Tukey test to determine which one is different.
rank_cluster_only = merged.loc[:,['Rank', 'Cluster']]

#Performing Tukey test
tukey_results = pairwise_tukeyhsd(rank_cluster_only['Rank'], rank_cluster_only['Cluster'], alpha=0.05)

# set a grey background (use sns.set_theme() if seaborn version 0.11.0 or above)
sns.set(style="whitegrid")
bins = 50
annotation1 = "f-statistic = " + str(round(f_stat, 3))
annotation2 = "p-value = " + str(round(p_value, 3))
sns.histplot(data=C1_ranks, color='orange', label="Cluster 1", kde=True, bins = bins)
sns.histplot(data=C2_ranks, color="green", label="Cluster 2", kde=True, bins = bins)
sns.histplot(data = C3_ranks, color = "red", label = "Cluster 3", kde = True, bins = bins)
plt.annotate(annotation1, xy = (600, 23), color = "black")
plt.annotate(annotation2, xy = (600, 21), color = "black")
plt.legend()
plt.xlabel("Rank: Abundance of $\it{P. copri}$")
plt.show()
plt.savefig("Histogram_Prevotella_Rank_by_Cluster.pdf")


