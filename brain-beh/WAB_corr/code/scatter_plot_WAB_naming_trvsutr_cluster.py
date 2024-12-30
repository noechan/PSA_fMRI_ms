import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import spearmanr

# Load the dataset
file_path = "/Volumes/LASA/Aphasia_project/tb-fMRI/results/behaviour/cluster/mean/WAB/python/data/LASA_WAB_cluster_prepost.xlsx"  # Replace with your file path
data = pd.read_excel(file_path, sheet_name="LASA_Intervention_demo")

# Define the variables
x_var = "Cluster_TrainedvsUntrained_prepost"
y_var = "WAB_naming_postpre"

# Drop missing values for the relevant columns
data_cleaned = data[[x_var, y_var]].dropna()

# Compute Spearman correlation
rho, pval = spearmanr(data_cleaned[x_var], data_cleaned[y_var])

# Set Seaborn style
sns.set_style("darkgrid")  # Other options: "darkgrid", "white", "dark", "ticks"

# Plot the scatter plot with regression line
plt.figure(figsize=(6, 6))
sns.regplot(
    x=data_cleaned[x_var], 
    y=data_cleaned[y_var], 
    scatter_kws={'color': 'green', 's': 80},  # Increased marker size
    line_kws={'color': 'gray'},  
    ci=95
)

# Round numbers on the x-axis
plt.gca().xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{int(x)}'))

# Show the plot
plt.tight_layout()
plt.savefig("scatter_plot_wab_naming.png", dpi=300)
plt.show()
