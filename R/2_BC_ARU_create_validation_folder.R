


# library -----------------------------------------------------------------

library(tidyverse)
library(here)

library(tuneR)
library(seewave)


# load data ---------------------------------------------------------------

load(here("data", "BirdNET_detections", "detections_2023_2024_focal.rda"))

# function for moving recordings to a given folder
move_recording <- function(id, filepath, start, end, 
                           buffer = 3, path = species_folder, ...){
  
  # load audio file
  audio <- readWave(filepath)
  
  # Trim the audio using start and end times in seconds
  trimmed_audio <- cutw(audio, f = audio@samp.rate, 
                        from = max(0, start - buffer), 
                        to =  min(length(audio@left) / audio@samp.rate, end + buffer), 
                        output = "Wave")
  
  # Save the trimmed audio if needed
  writeWave(trimmed_audio, file.path(path, 
                                     paste0(target_species, "_", id, ".wav")))
}

# isolate recording segments for validation -------------------------------

set.seed(2024)

species <- detections_2023_2024_focal %>%
  pull(common_name) %>% 
  unique() 

# loop through species 

for (target_species in species) {
  # manage species folder
  species_folder <- here("data", "validation_recordings", target_species)
  
  if (!dir.exists(species_folder)) {
    dir.create(species_folder, recursive = TRUE)
  }
  
  # validation table
  table <- detections_2023_2024_focal %>%
    filter(common_name == target_species) %>%
    mutate(category = cut(confidence, breaks = seq(0.1, 1, by = 0.05), right = FALSE)) %>%
    slice_sample(n = 10, by = category) 
  
  write_csv(table, file.path(species_folder, paste0(target_species, "_validation.csv")))
  
  # move recordings
  pmap(table, move_recording)          
}


# top recordings to test single species -----------------------------------

species <- "Yellow Rail"

# manage species folder
species_folder <- here("data", "individual_recordings", target_species)

if (!dir.exists(species_folder)) {
  dir.create(species_folder, recursive = TRUE)
}

# validation table
table <- detections_2023_2024_focal %>%
  filter(common_name == target_species) %>%
  slice_max(confidence, n = 40)

write_csv(table, file.path(species_folder, paste0(target_species, "_validation.csv")))

# move recordings
pmap(table, move_recording)   










