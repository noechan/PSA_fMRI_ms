#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 22 14:29:50 2023

@author: noeliamartinezmolina
"""

import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

# Set plot style and frame
sns.set_theme(style="white")
plt.rcParams['xtick.bottom'] = False
plt.rcParams['xtick.labelbottom'] = True
plt.rcParams['xtick.major.pad'] = 20
plt.rcParams['ytick.left'] = True
plt.rcParams['font.family'] = 'Helvetica'


# Import data from singing performance
df=pd.read_csv('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/singing_performance/pyplot/sing_perf_barplot_TU_3ses.csv',
               usecols=[0,1,2,3])
df.head()

# Create violin plot and add individual data points
plt.figure(figsize = (4,4))
ax=sns.barplot(data=df, x="Trial", y="Performance",hue='Session', palette=('flare'),saturation=0.6, alpha=0.9, edgecolor='purple', capsize = 0.2, lw = 1, errwidth = 1, errcolor = '0.2')

for axis in ['bottom', 'left']:
    ax.spines[axis].set_linewidth(2)
    ax.spines[axis].set_color('0.2')
    
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.xticks(rotation = 35, rotation_mode = 'anchor')
ax.tick_params(size=6, width = 1, color = '0.2')
plt.ylim(0,100)


ax.set(
        title=None,
        ylabel=None,
        xlabel=None,
        )

leg = plt.legend() 
ax.get_legend().remove()
#plt.legend(frameon = False, prop = {'weight':'bold', 'size':14}, labelcolor = '0.2', loc="upper right")

plt.savefig('singing_perf_barplot_TU_ses3.jpg', bbox_inches='tight', dpi=300)
plt.show()