

# library -----------------------------------------------------------------

library(tidyverse)
library(here)


# combine data ------------------------------------------------------------

dir <- "G:/Chilcotin_Cariboo_ARU_2023_2024_BirdNET_output"

dir <- "G:/Chilcotin_Cariboo_ARU_2023_2024_BirdNET_output/Chilcotin_Cariboo_ARU_2023_BirdNET_output/Axe Lake/ARU_7859 (Site 2)/Data"

all_csv_files <- list.files(path = dir, 
                            full.names = TRUE, 
                            pattern = "\\.csv$", 
                            recursive = TRUE)

filtered_csv_files <- all_csv_files[!grepl("nocturnal_random_selected", all_csv_files)]
filtered_csv_files

combined_data <- filtered_csv_files %>% 
  map_dfr(read_csv)
