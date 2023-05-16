#PHATE Clustering
#I am wondering if metabolite metabolite profiles alone can distinguish rural from urban TZ.

import phate
import numpy as np
import pandas as pd
import scprep
import matplotlib.pyplot as plt
import seaborn as sns

#READING IN THE DATA
#Reading in the species relative abundance info.
abundance = pd.read_excel("Abundance_species2.xlsx")
#Read in scaled metabolites
sc_metab_og = pd.read_csv("TZ_Scaled_Metabolites.csv")
sc_metab_og = sc_metab_og.rename(columns = {'Unnamed: 0': 'ID'})
#Getting P. copri information
Pcopri = abundance.loc[:,['ID', 'Prevotella.copri']]
sc_metab_smol = pd.merge(Pcopri, sc_metab_og, how = "left")
    #Contains the sample identifiers in the first column, so we will remove the first column.
sc_metab = sc_metab_og.drop(sc_metab_og.columns[0], axis=1)
abridged = sc_metab_smol.drop(sc_metab_smol.columns[0:2], axis = 1)
#Getting metabolites metadata
metab_meta = pd.read_excel("Metabolites_Metadata.xlsx")
#Reading in metadata to get rural/urban info.
TZ_meta = pd.read_excel("TZ_metadata.xlsx")


#PERFORMING PHATE
#Now we will cluster the metabolites with PHATE and color by rural and urban.
phate_op = phate.PHATE()
Y = phate_op.fit_transform(sc_metab)
#Plotting results of PHATE in 2D
scprep.plot.scatter2d(Y, ticks=None, label_prefix='PHATE', figsize=(5,5))
#Coloring results by different variables
#1) Coloring by rural/urban
fig, ax = plt.subplots(1, figsize=(4.4,3))
location_cdict = {'Rural':'#1a3263',
                   'Urban':'#f5564e'}
scprep.plot.scatter2d(Y, ax=ax, c=TZ_meta['Residency_Area'], cmap=location_cdict,
                      title='Geographic Location', ticks=False, label_prefix='PHATE',
                     legend_anchor=(1,1))
fig.tight_layout()
plt.savefig('PHATE_geographic_region.pdf')


#2) Coloring by gender
fig, ax = plt.subplots(1, figsize=(4.4,3))
gender_cdict = {'Male':'#1a3263',
                   'Female':'#f5564e'}
scprep.plot.scatter2d(Y, ax=ax, c=TZ_meta['Gender'], cmap=gender_cdict,
                      title='Gender', ticks=False, label_prefix='PHATE',
                     legend_anchor=(1,1))
fig.tight_layout()
plt.savefig("PHATE_gender.pdf")

#Coloring by age
# Plotting libsize
fig, ax = plt.subplots(1, figsize=(3.6,3))
scprep.plot.scatter2d(Y, ax=ax, c=TZ_meta['Age'],
                      title='Age', ticks=False, label_prefix='PHATE')
fig.tight_layout()
plt.savefig("PHATE_age.pdf")

#Coloring by P. copri relative abundance.
#I performed clustering on a slightly different matrix here because the P. copri abundance dta set had fewer
#rows, so I merged the data frames and ended up with a slightly smaller data set.
Z = phate_op.fit_transform(abridged)

fig, ax = plt.subplots(1, figsize=(3.6,3))
scprep.plot.scatter2d(Z, ax=ax, c=sc_metab_smol['Prevotella.copri'],
                      title='P. copri Abundance', ticks=False, label_prefix='PHATE')
fig.tight_layout()
plt.savefig("PHATE_Pcopri.pdf")


#Plotting kernel density estimate (KDE) plot
#This should allow us to better distinguish how many clusters there are.
# Perform PHATE clustering
phate_op = phate.PHATE()
Y = phate_op.fit_transform(sc_metab)

#I found that it is important to specify "x = " and "y = " or else the plot won't render.
fig, ax = plt.subplots(1, figsize=(4,4))
sns.kdeplot(x = Y[:,0], y = Y[:,1], n_levels=100, fill=True, cmap='inferno', zorder=0, ax=ax)

ax.set_xticks([])
ax.set_yticks([])

ax.set_xlabel('PHATE 1', fontsize=18)
ax.set_ylabel('PHATE 2', fontsize=18)

ax.set_title('PHATE KDE Plot: Metabolomics Data', fontsize=14)

fig.tight_layout()
plt.savefig("PHATE_KDE.pdf")

#Now I want to cluster the samples based upon the KDE map.
#n clusters = 3.
clusters = phate.cluster.kmeans(phate_op, n_clusters=3)

scprep.plot.scatter2d(Y, c=clusters, cmap=sns.husl_palette(3), s=1,
                      figsize=(4.3,4), ticks=None, label_prefix='PHATE',
                     legend_anchor=(1,1), fontsize=12, title='PHATE clusters')

fig.tight_layout()
plt.savefig("PHATE_Kmeans_clusters.pdf")

#I want to know about the relative importance of the features in the data set, so I will plot the loadings.
#Clustering Y: metabolites only
# plot loadings
fig, ax = plt.subplots(figsize=(8, 6))
phate.plot.plot(embedding, data=phate_op.embedding_, ax=ax, color=list(sc_metab.index), s=20, cmap='rainbow')
ax.set_xlabel("PHATE 1")
ax.set_ylabel("PHATE 2")
ax.set_title("PHATE Clustering Loadings")
plt.show()



