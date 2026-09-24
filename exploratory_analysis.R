library(tidyverse)

# Exploratory analysis used during development of the Shiny demonstration.
# This script preserves selected data-processing, summary-statistics,
# statistical-comparison, and standalone-visualization steps from the
# original development code. The public example data are synthetic/demo data.

input_file <- "data/gene_expression_table.csv"
long_file <- "data/mydata_long.csv"

# -----------------------------------------------------------------------------
# 1. Read the synthetic wide-format expression table
# -----------------------------------------------------------------------------
mydata <- read_csv(input_file, show_col_types = FALSE)

sample_columns <- setdiff(names(mydata), "gene_name")

if (length(sample_columns) != 6) {
  stop("This demonstration expects six sample columns in gene_expression_table.csv.")
}

group_1_samples <- sample_columns[1:3]
group_2_samples <- sample_columns[4:6]

# -----------------------------------------------------------------------------
# 2. Calculate per-gene group summaries and an exploratory two-sample t-test
# -----------------------------------------------------------------------------
wide_summary <- mydata %>%
  rowwise() %>%
  mutate(
    group_1_mean = mean(c_across(all_of(group_1_samples)), na.rm = TRUE),
    group_2_mean = mean(c_across(all_of(group_2_samples)), na.rm = TRUE),
    group_1_se = sd(c_across(all_of(group_1_samples)), na.rm = TRUE) /
      sqrt(sum(!is.na(c_across(all_of(group_1_samples))))),
    group_2_se = sd(c_across(all_of(group_2_samples)), na.rm = TRUE) /
      sqrt(sum(!is.na(c_across(all_of(group_2_samples))))),
    p_value = t.test(
      c_across(all_of(group_1_samples)),
      c_across(all_of(group_2_samples)),
      paired = FALSE
    )$p.value
  ) %>%
  ungroup()

print(wide_summary)

# -----------------------------------------------------------------------------
# 3. Read the long-format table and calculate descriptive statistics
# -----------------------------------------------------------------------------
mydata_long <- read_csv(long_file, show_col_types = FALSE)

summary_statistics <- mydata_long %>%
  group_by(gene_name, group) %>%
  summarise(
    n = sum(!is.na(expression)),
    mean = mean(expression, na.rm = TRUE),
    se = sd(expression, na.rm = TRUE) / sqrt(n),
    .groups = "drop"
  )

print(summary_statistics)

# -----------------------------------------------------------------------------
# 4. Exploratory per-gene statistical comparisons from the long-format table
# -----------------------------------------------------------------------------
gene_tests <- mydata_long %>%
  group_by(gene_name) %>%
  summarise(
    p_value = t.test(expression ~ group, paired = FALSE)$p.value,
    .groups = "drop"
  )

summary_with_p <- summary_statistics %>%
  left_join(gene_tests, by = "gene_name")

print(summary_with_p)

# -----------------------------------------------------------------------------
# 5. Generate a standalone plot for one example gene
# -----------------------------------------------------------------------------
selected_gene <- sort(unique(mydata_long$gene_name))[1]

p <- mydata_long %>%
  filter(gene_name == selected_gene) %>%
  ggplot(aes(x = group, y = expression, fill = group)) +
  stat_summary(fun = mean, geom = "bar", color = "black", width = 0.7) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.25) +
  labs(
    title = paste("Expression summary for", selected_gene),
    x = NULL,
    y = "Gene expression"
  ) +
  theme_classic() +
  theme(legend.position = "none")

print(p)

# Note: The t-tests above are retained to document the exploratory development
# process. They are demonstrations only and should not be interpreted as a
# general statistical strategy for omics studies or for the synthetic data.
