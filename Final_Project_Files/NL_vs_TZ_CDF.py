#This script is to determine whether there is a higher abundance
#of Prevotella copri in one geographical region (Netherlands vs Tanzania).

#Reading in the data
ranked = pd.read_excel("Microbiome_Ranked_for_Prevotella.xlsx")

#Separating male and female to calculate a CDF for each.
NL = ranked[ranked['Cohort'] != "TZ"]
TZ = ranked[ranked['Cohort'] == "TZ"]

#Calculating cumulative frequency
seq_NL = list(range(1,len(NL)+1))
seq_TZ = list(range(1,len(TZ)+1))
decimals = 5
cumfreq_NL = [round(elem/len(NL), decimals) for elem in seq_NL]
cumfreq_TZ = [round(elem/len(TZ), decimals) for elem in seq_TZ]

NL_TZ_ktest = stats.ks_2samp(cumfreq_NL, cumfreq_TZ, method = 'auto')

#Adding the cumulative frequencies to the male and female data frames.
#This is necessary becuase we want to plot y = cumfreq vs x = Prevotella rank
NL.loc[:,'Cumulative_frequency'] = cumfreq_NL
TZ.loc[:,'Cumulative_frequency'] = cumfreq_TZ

#Plot CDF: Male/Female
annotation = "p = " + str(mf_ktest.pvalue)
plt.plot(NL.loc[:,"Prevotella_rank"], NL.loc[:,"Cumulative_frequency"], color = 'red', label = "Netherlands")
plt.plot(TZ.loc[:,"Prevotella_rank"], TZ.loc[:,"Cumulative_frequency"], color = 'green', label = "Tanzania")
plt.legend()
plt.xlabel("Rank: Abundance of $\it{P. copri}$")
plt.ylabel("Cumulative Fraction")
plt.annotate(annotation, xy = (0,0.85), color = 'black')
plt.show()
plt.savefig('NL_vs_TZ_Prevotella_Rank_CDF.pdf')