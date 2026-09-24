library(tidyverse)

# This script converts the synthetic wide-format demonstration table into
# the long-format table consumed by app.R.

input_file <- "data/gene_expression_table.csv"
output_file <- "data/mydata_long.csv"

mydata <- read_csv(input_file, show_col_types = FALSE)

sample_columns <- setdiff(names(mydata), "gene_name")

# The demonstration dataset contains six samples: the first three belong to
# group_1 and the next three belong to group_2. For a real dataset, replace
# this metadata with the appropriate sample-to-group mapping.
sample_metadata <- tibble(
  sample = sample_columns,
  group = c(rep("group_1", 3), rep("group_2", 3))
)

mydata_long <- mydata %>%
  pivot_longer(
    cols = all_of(sample_columns),
    names_to = "sample",
    values_to = "expression"
  ) %>%
  left_join(sample_metadata, by = "sample")

write_csv(mydata_long, output_file)
