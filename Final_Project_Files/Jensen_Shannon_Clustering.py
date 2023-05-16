#This script is to perform Jensen-Shannon clustering on the microbiome data.

#Inputs: "Microbiome_data.xlsx", sheet = 5
#Outputs: Cluster dendrogram

#Dependencies
import pandas as pd
from scipy import stats
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster
from scipy.spatial.distance import squareform
import numpy as np
import matplotlib.pyplot as plt

#Reading in the data
data = pd.read_excel("Microbiome_data.xlsx", sheet_name = 'Fig. 2a')
dist_matrix = np.array(data.iloc[:,1:])

#Create dendrogram from distance matrix: WARD LINKAGE
#Here, I tried to reproduce the figure in the paper as closely as possible.
#They used "ward" distance.
#I modified the color_thresold (t) to be 1.8. The default is 0.7*max(Z[:,2]).
colors = ['slategray', 'thistle', 'burlywood', 'blue']
dists = squareform(dist_matrix)
linkage_matrix = linkage(dists, "ward") #selected 'complete' linkage method
dendrogram(linkage_matrix, color_threshold = 1.8)
plt.xlabel('Microbiome Sample')
plt.ylabel('Height')
plt.show()
plt.savefig("Cluster_Dendrogram_JSdist_wardLinkage.pdf")

#Create dendrogram from distance matrix: COMPLETE LINKAGE
dists = squareform(dist_matrix)
linkage_matrix = linkage(dists, "complete") #selected 'complete' linkage method
tree_complete = dendrogram(linkage_matrix)
plt.xlabel('Microbiome Sample')
plt.ylabel('Height')
plt.show()
plt.savefig("Cluster_Dendrogram_JSdist_completeLinkage.pdf")

#Making a data frame that contains the cluster information.
Sample = data.iloc[:,0]
Clustering_Order = pd.DataFrame(tree_complete['leaves'])
Cluster = pd.DataFrame(tree_ward['leaves_color_list'])
cluster_prelim = pd.concat([Clustering_Order, Cluster], axis = 1)
cluster_prelim.columns = ['Clustering_Order', 'Cluster']
cluster_prelim2 = cluster_prelim.sort_values('Clustering_Order')
#Now adding sample labels
cluster_df = pd.concat([Sample, cluster_prelim2.reset_index(drop = True)], axis = 1)
cluster_df.columns = ['Sample', 'Clustering_Order', 'Cluster']

#Writing as Excel file
cluster_df.to_excel("Samples_with_Cluster_Assignment.xlsx")
