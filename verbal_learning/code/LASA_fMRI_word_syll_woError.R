# Load necessary libraries
library(dplyr)
library(ggplot2)
library(stats)

# Load data
data <- readxl::read_excel("data/LASA_Trained_audio_and_lyrics_CVA_TBI_N19_R.xlsx", sheet = "Hoja1")

# Calculate pre-post improvement for each condition
data <- data %>%
  mutate(
    Trained_Corr_syll_improvement = Trained_Correct_syll_post - Trained_Correct_syll_pre,
    Trained_Corr_Almost_syll_improvement = Trained_Correct_and_Almost_Correct_syll_post - Trained_Correct_and_Almost_Correct_syll_pre,
    Trained_Corr_words_improvement = Trained_Correct_words_post - Trained_Correct_words_pre,
    Untrained_improvement = Untrained_Correct_syll_post - Untrained_Correct_syll_pre,
    Untrained_Corr_Almost_syll_improvement = Untrained_Correct_and_Almost_Correct_syll_post - Untrained_Correct_and_Almost_Correct_syll_pre,
    Untrained_Corr_words_improvement = Untrained_Correct_words_post - Untrained_Correct_words_pre,
    Trained_vs_Untrained_improvement = TrainedvsUntrained_Correct_syll_post - TrainedvsUntrained_Correct_syll_pre,
    Trained_vs_Untrained_Corr_Almost_syll_improvement = TrainedvsUntrained_Correct_and_Almost_Correct_syll_post - TrainedvsUntrained_Correct_and_Almost_Correct_syll_pre,
    Trained_vs_Untrained_Corr_words_improvement = TrainedvsUntrained_Correct_words_post - TrainedvsUntrained_Correct_words_pre,
  )

# Perform Wilcoxon signed-rank tests and extract coefficients and degrees of freedom
wilcoxon_results <- data.frame(Metric = character(), W = numeric(), df = numeric(), p_value = numeric(), stringsAsFactors = FALSE)

# List of metrics to test
metrics <- list(
  "Trained_Correct_syll" = c("Trained_Correct_syll_pre", "Trained_Correct_syll_post"),
  "Trained_Correct_and_Almost_Correct_syll" = c("Trained_Correct_and_Almost_Correct_syll_pre", "Trained_Correct_and_Almost_Correct_syll_post"),
  "Trained_Correct_words" = c("Trained_Correct_words_pre", "Trained_Correct_words_post"),
  "Untrained_Correct_syll" = c("Untrained_Correct_syll_pre", "Untrained_Correct_syll_post"),
  "Untrained_Correct_and_Almost_Correct_syll" = c("Untrained_Correct_and_Almost_Correct_syll_pre", "Untrained_Correct_and_Almost_Correct_syll_post"),
  "Untrained_Correct_words" = c("Untrained_Correct_words_pre", "Untrained_Correct_words_post"),
  "TrainedvsUntrained_Correct_syll" = c("TrainedvsUntrained_Correct_syll_pre", "TrainedvsUntrained_Correct_syll_post"),
  "TrainedvsUntrained_Correct_and_Almost_Correct_syll" = c("TrainedvsUntrained_Correct_and_Almost_Correct_syll_pre", "TrainedvsUntrained_Correct_and_Almost_Correct_syll_post"),
  "TrainedvsUntrained_Correct_words" = c("TrainedvsUntrained_Correct_words_pre", "TrainedvsUntrained_Correct_words_post")
)

# Loop through metrics and calculate Wilcoxon test
for (metric_name in names(metrics)) {
  pre_post <- metrics[[metric_name]]
  metric_data <- data %>% select(all_of(pre_post)) %>% na.omit()
  
  test_result <- wilcox.test(metric_data[[1]], metric_data[[2]], paired = TRUE, exact = TRUE)
  
  # Extract W statistic, degrees of freedom (sample size - 1), and p-value
  W <- test_result$statistic
  df <- nrow(metric_data) - 1
  p_value <- test_result$p.value
  
  # Append results to data frame
  wilcoxon_results <- wilcoxon_results %>%
    add_row(Metric = metric_name, W = W, df = df, p_value = p_value)
}

# Apply FDR correction
wilcoxon_results <- wilcoxon_results %>%
  mutate(adjusted_p_value = p.adjust(p_value, method = "fdr"))

# Print results
print(wilcoxon_results)

# Save results to a file
write.csv(wilcoxon_results, "wilcoxon_results_woErrormetric.csv", row.names = FALSE)


