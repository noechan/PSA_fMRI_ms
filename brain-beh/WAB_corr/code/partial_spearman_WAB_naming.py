import pandas as pd
from scipy.stats import spearmanr
from statsmodels.stats.multitest import multipletests
from sklearn.linear_model import LinearRegression
import numpy as np

# Load the dataset
file_path = "/Volumes/LASA/Aphasia_project/tb-fMRI/results/behaviour/cluster/mean/WAB/python/data/LASA_WAB_cluster_prepost.xlsx"  # Replace with your file path
data = pd.read_excel(file_path, sheet_name="LASA_Intervention_demo")

# Define variables of interest and nuisance covariates
variables_of_interest = ["WAB_naming_postpre", "Cluster_Trained_prepost", "Cluster_TrainedvsUntrained_prepost"]
nuisance_covariates = ["Age", "TIV_ml", "Lesionsize_acute"]

# Drop rows with missing values in relevant columns
relevant_columns = variables_of_interest + nuisance_covariates
data_cleaned = data[relevant_columns].dropna()

# Define a function to compute partial Spearman correlation
def partial_spearman(x, y, nuisances):
    # Regress out nuisance variables for x and y
    x_residuals = x - LinearRegression().fit(nuisances, x).predict(nuisances)
    y_residuals = y - LinearRegression().fit(nuisances, y).predict(nuisances)
    
    # Compute Spearman correlation between residuals
    rho, pval = spearmanr(x_residuals, y_residuals)
    return rho, pval

# Calculate partial Spearman correlations
results = []
for var in variables_of_interest[1:]:
    rho, pval = partial_spearman(
        data_cleaned[variables_of_interest[0]], 
        data_cleaned[var], 
        data_cleaned[nuisance_covariates]
    )
    results.append((variables_of_interest[0], var, rho, pval))

# Apply FDR correction to p-values
p_values = [result[3] for result in results]
_, fdr_corrected_p_values, _, _ = multipletests(p_values, method='fdr_bh')

# Compile results into a DataFrame
results_df = pd.DataFrame({
    "Variable1": [result[0] for result in results],
    "Variable2": [result[1] for result in results],
    "Partial_Spearman_Correlation": [result[2] for result in results],
    "P_Value": p_values,
    "FDR_Corrected_P_Value": fdr_corrected_p_values
})

# Display results
print(results_df)

# Save results in different formats
results_df.to_csv("partial_spearman_results.csv", index=False)
results_df.to_excel("partial_spearman_results.xlsx", index=False)
results_df.to_string("partial_spearman_results.txt", index=False)

