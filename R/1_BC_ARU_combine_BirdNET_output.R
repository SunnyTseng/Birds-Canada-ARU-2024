

# library -----------------------------------------------------------------

library(tidyverse)
library(here)
library(ggbreak)


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
detections_2023_2024 <- filtered_csv_files %>% 
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

# Save the combined data to a rda file
save(object = detections_2023_2024, file = here("data", "detections_2023_2024.rda"))





# filter data only for target species -------------------------------------

project_focal_species <- read_csv(here("data", "NEW ARU Focal Species List.csv"))
load(file = here("data", "detections_2023_2024.rda"))

detections_2023_2024_filter <- detections_2023_2024 %>% 
  filter(common_name %in% project_focal_species$`Species name`) 

# double-check that the White-winged scoter is not detected
project_focal_species$`Species name`[!project_focal_species$`Species name` %in% detections_2023_2024_filter$common_name]
"Melanitta deglandi" %in% detections_2023_2024$scientific_name

# mutate necessary columns
detections_2023_2024_focal <- detections_2023_2024_filter %>% 
  mutate(filename = str_split_i(filepath, "\\\\", -1),
         year = str_extract(filename, "202[34]"),         # Matches years from 2020 to 2099
         month = str_extract(filename, "(?<=202[34])\\d{2}"), # Extracts 2 digits after the year for the month
         day = str_extract(filename, "(?<=202[34]\\d{2})\\d{2}"), # Extracts 2 digits after year and month for the day)
         hour = str_extract(filename, "(?<=202[34]\\d{4}.{1})\\d{2}"), # Extracts 2 digits after year, month, and day for the hour
         minute = str_extract(filename, "(?<=202[34]\\d{4}.{3})\\d{2}"), # Extracts 2 digits after year, month, day, and hour for the minute
         second = str_extract(filename, "(?<=202[34]\\d{4}.{5})\\d{2}"), # Extracts 2 digits after year, month, day, hour, and minute for the second
         datetime = paste(year, month, day, hour, minute, second, sep = "-") %>% ymd_hms(),
         date = as.Date(datetime)) %>% 
  mutate(site = str_split_i(filepath, "\\\\", 3),
         location = if_else(year == "2023", 
                            str_split_i(filepath, "\\\\", 4),
                            str_split_i(site, " - ", 2))) %>%
  mutate(site = str_split_i(site, " - ", 1)) %>% 
  select(site, location, date, datetime, year, month, day, hour, minute,
         start, end, scientific_name, common_name, confidence, filepath) 



# Save the combined data to a rda file
save(object = detections_2023_2024_focal, file = here("data", "detections_2023_2024_focal.rda"))





# visualization of number of detections across time ------------------------

load("G:/Birds-Canada-ARU-2024/data/detections_2023_2024_focal.rda")

detections_2023_2024_focal %>% 
  ggplot() +
  geom_bar(aes(x = date), stat = "count") +
  scale_x_break(c(ymd("2023-06-22"), ymd("2024-05-25")))
  










