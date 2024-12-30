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
df=pd.read_csv('/Volumes/LASA/Aphasia_project/manuscripts/fMRI_SciRep/code_github/verbal_learning/visualisation/LASA_Trained_verbal_learning.csv',
               usecols=[0,1,2,3])
df.head()

# Create barplot and add individual data point
# Correct syllables
plt.figure(figsize = (4,4))
ax=sns.barplot(data=df, x="Session", y="Trained_Correct_syll", palette=('muted'),saturation=0.7, alpha=0.8, edgecolor='black', capsize = 0.2, lw = 2, errwidth = 1, errcolor = '0.2')
ax.set_yticks([0, 30, 60, 90])
ax.set_yticklabels(ax.get_yticks(), size = 16)

for axis in ['bottom', 'left']:
    ax.spines[axis].set_linewidth(2)
    ax.spines[axis].set_color('0.2')
    
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)


ax.set(
        title=None,
        ylabel='Trained Correct Syllables',
        xlabel=None,
        )


plt.savefig('LASA_TR_C_syll.jpg', bbox_inches='tight', dpi=300)
plt.show()

# Correct and almost correct syllables
plt.figure(figsize = (4,4))
ax=sns.barplot(data=df, x="Session", y="Trained_Correct_and_Almost_Correct_syll", palette=('muted'),saturation=0.7, alpha=0.8, edgecolor='black', capsize = 0.2, lw = 2, errwidth = 1, errcolor = '0.2')
ax.set_yticks([0, 30, 60, 90])
ax.set_yticklabels(ax.get_yticks(), size = 16)

for axis in ['bottom', 'left']:
    ax.spines[axis].set_linewidth(2)
    ax.spines[axis].set_color('0.2')
    
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)


ax.set(
        title=None,
        ylabel='Trained Correct and Almost Correct Syllables',
        xlabel=None,
        )


plt.savefig('LASA_TR_C_almost_C_syll.jpg', bbox_inches='tight', dpi=300)
plt.show()


# Correct Words
plt.figure(figsize = (4,4))
ax=sns.barplot(data=df, x="Session", y="Trained_Correct_words", palette=('muted'),saturation=0.7, alpha=0.8, edgecolor='black', capsize = 0.2, lw = 2, errwidth = 1, errcolor = '0.2')
ax.set_yticks([0, 15, 30, 45])
ax.set_yticklabels(ax.get_yticks(), size = 16)

for axis in ['bottom', 'left']:
    ax.spines[axis].set_linewidth(2)
    ax.spines[axis].set_color('0.2')
    
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)


ax.set(
        title=None,
        ylabel='Trained Correct Words',
        xlabel=None,
        )


plt.savefig('LASA_TR_C_words.jpg', bbox_inches='tight', dpi=300)
plt.show()