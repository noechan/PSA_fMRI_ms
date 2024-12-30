#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 21 11:28:19 2023

@author: noeliamartinezmolina
"""

import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np


# Set plot style and frame
sns.set_theme(style="whitegrid")
plt.rcParams['xtick.bottom'] = False
plt.rcParams['ytick.left'] = True
plt.rcParams['font.family'] = 'Helvetica'


# Import data from motion outliers
df=pd.read_csv('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code/motion outliers/pyplots/motion_outliers.csv')
df.head()

# Create violin plot and add individual data points
ax=sns.violinplot(data=df, x='Session',y='Outliers', width=0.7,linewidth=1, palette=['lightskyblue','royalblue'],saturation=0.8, alpha=0.05)

ax=sns.swarmplot(data=df, x='Session', y='Outliers', color='black', alpha=0.8, size=3)


# Customize plot for publication
for axis in ['bottom', 'left']:
    ax.spines[axis].set_linewidth(2.5)
    ax.spines[axis].set_color('0.2')
    
    for axis in ['bottom', 'left']:
        ax.spines[axis].set_linewidth(2)
        ax.spines[axis].set_color('0.2')
        
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)


    plt.yticks(ticks=np.arange(-5,21,4))
    ax.tick_params(size=6,width = 1)


ax.set(
        title=None,
        ylabel=None,
        xlabel=None,
        )
sns.despine(left=False, bottom=False)
plt.savefig('motion_outliers.png', bbox_inches='tight', dpi=300)
plt.show()
