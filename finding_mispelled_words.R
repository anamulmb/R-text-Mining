# Install and load the 'hunspell' package if you haven't already
install.packages("hunspell")
library(hunspell)

# Define a custom function to find misspelled words in all columns
find_misspelled_words_in_all_columns <- function(data_frame, dictionary = NULL) {
  misspelled_words_in_columns <- list()
  
  for (col_name in names(data_frame)) {
    column_data <- data_frame[[col_name]]
    column_data <- as.character(column_data[!is.na(column_data)])
    
    # Initialize the hunspell dictionary
    hunspell_dict <- hunspell(dictionary = dictionary)
    
    # Find misspelled words
    misspelled_words <- sapply(column_data, function(text) {
      words <- unlist(strsplit(text, "\\s+"))  # Split text into words
      misspelled <- words[!hunspell_dict$spell(words)]
      if (length(misspelled) > 0) {
        return(paste(misspelled, collapse = " "))
      } else {
        return(NULL)
      }
    })
    
    # Remove NULL entries (no misspelled words)
    misspelled_words <- misspelled_words[!sapply(misspelled_words, is.null)]
    
    misspelled_words_in_columns[[col_name]] <- misspelled_words
  }
  
  return(misspelled_words_in_columns)
}

# Use the function to find misspelled words in all columns of emp_df
misspelled_words_in_all_columns <- find_misspelled_words_in_all_columns(emp_df, dictionary = NULL)

# Print misspelled words in each column
for (col_name in names(misspelled_words_in_all_columns)) {
  cat("Misspelled words in column", col_name, ":\n")
  print(misspelled_words_in_all_columns[[col_name]])
  cat("\n")
}
