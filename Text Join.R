# Load necessary libraries
library(tidyverse)
library(tidytext)

# Read the CSV files
class_df <- read.csv("class.csv") # Replace with your file path
mechanism_df <- read.csv("mechanism.csv") # Replace with your file path

# Step 2: Perform a left join to match Type toClass
joined_df <- mechanism_df %>%
  left_join(class_df, by = c("Type" = "Class")) %>%
  select(-"Class") # Remove the redundant column

# Step 3: Extract Action if matched, otherwise create "Unmatched" categories
joined_df <- joined_df %>%
  mutate(
    Action = if_else(is.na(Action), "Unmatched Action", `Action`),
    Type = if_else(is.na(Type), "Unmatched Type", `Type`)
  ) %>%
  select(Type, Action)

# Step 5: Create a new data frame with the results
result_df <- joined_df %>%
  group_by(Type, Action) %>%
  tally()

# Print or export the result_df as needed
print(result_df)

