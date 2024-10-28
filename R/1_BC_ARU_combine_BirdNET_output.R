

# library -----------------------------------------------------------------

library(tidyverse)
library(here)


# combine data ------------------------------------------------------------

# define column types for read_csv
column_spec <- cols(
  filepath = col_character(),
  start = col_double(),
  end = col_double(),
  scientific_name = col_character(),
  common_name = col_character(),
  confidence = col_double(),
  lat = col_double(),
  lon = col_double(),
  week = col_double(),
  overlap = col_double(),
  sensitivity = col_double(),
  min_conf = col_double(),
  species_list = col_character(),
  model = col_character()
)

# define directory
dir <- "G:/Chilcotin_Cariboo_ARU_2023_2024_BirdNET_output"


# create a list of all csv files in the directory
all_csv_files <- list.files(path = dir, 
                            full.names = TRUE, 
                            pattern = "\\.csv$", 
                            recursive = TRUE)

filtered_csv_files <- all_csv_files[!grepl("nocturnal_random_selected", all_csv_files)]

# Initialize a vector to store any files that cause errors
error_files <- c()

# Use map_dfr with tryCatch to handle errors gracefully
combined_data <- filtered_csv_files %>% 
  map_dfr(~ {
    tryCatch(
      read_csv(.x, col_types = column_spec),
      error = function(e) {
        # Store the filename that caused the error
        error_files <<- c(error_files, .x)
        
        # Return an empty tibble with the same column structure to continue
        tibble(
          filepath = character(), start = double(), end = double(), 
          scientific_name = character(), common_name = character(), 
          confidence = double(), lat = double(), lon = double(), 
          week = double(), overlap = double(), sensitivity = double(), 
          min_conf = double(), species_list = character(), model = character()
        )
      }
    )
  })

# Print the names of any files that caused errors
if (length(error_files) > 0) {
  message("The following files caused errors and were skipped:")
  print(error_files)
} else {
  message("All files loaded successfully.")
}

# Save the combined data to a .csv file
write_csv(combined_data, "combined_data.csv")





