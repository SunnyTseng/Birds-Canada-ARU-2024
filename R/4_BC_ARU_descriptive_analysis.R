

# library -----------------------------------------------------------------

library(tidyverse)
library(here)

library(RColorBrewer)


# functions ---------------------------------------------------------------

# find precision given a threshold
threshold2precision <- function(probability_data, threshold){
  threshold <- probability_data %>%
    filter(confidence > threshold) %>%
    pull(probability) %>%
    mean()
}


# find the data ramained given a threshold
threshold2remain <- function(probability_data, threshold){
  remain <- probability_data %>%
    filter(confidence > threshold) %>%
    nrow()
  
  remain/nrow(probability_data)
}


# function to determine the threshold given specified precision level
precision2threshold <- function(threshold_table, precision){
  model <- glm(precision ~ threshold, 
               data = threshold_table,
               family = binomial)
  
  (log(precision/(1 - precision)) - model$coefficients[1])/model$coefficients[2]
  
}


# data imput --------------------------------------------------------------


load(here("data", "BirdNET_detections", "detections_2023_2024.rda"))
load(here("data", "BirdNET_detections", "detections_2023_2024_focal.rda"))

bc_list <- read_csv(here("data", "bird_list", "atlasdata_bc_birdlist.csv"))

validated_all <- list.files(here("data", "validation_recordings", "z_finished_files"), 
                            full.name = TRUE) %>%
  map_dfr(read_csv) %>%
  filter(validation != "U") %>%
  mutate(validation = ifelse(validation == "y", "Y", validation)) %>%
  mutate(validation = ifelse(validation == "Y", 1, 0)) %>%
  drop_na(validation, confidence, common_name)



# descriptive analysis ----------------------------------------------------

## how many sites are surveyed in 2023 and 2024? 
n_ARUs <- detections_2023_2024 %>%
  distinct(year, site, site_location) %>%
  group_by(year) %>%
  summarize(n_site = n_distinct(site),
            n_location = n())

## duration of the ARU survey?
duration <- detections_2023_2024 %>%
  pull(month) %>%
  unique()
  

## total number of species detected - how many of them are within BC list? 
species_total <- detections_2023_2024 %>%
  pull(common_name) %>%
  unique()

species_bc <- bc_list$Species

species_detected <- species_total[species_total %in% species_bc]


## site general info
site_info_bc <- detections_2023_2024 %>% 
  filter(common_name %in% bc_list$Species) %>%
  group_by(year, site) %>%
  summarize("No. location" = n_distinct(location),
            "Detections" = n(),
            "No. BC species" = n_distinct(common_name)) %>%
  ungroup()

save(object = site_info_bc, 
     file = here("docs", "tables", "site_info_bc.rda"))



# calibration curves ------------------------------------------------------

coul <- brewer.pal(12, "Paired") 
coul <- colorRampPalette(coul)(19)

g <- ggplot(validated_all, aes(x = confidence, 
                               y = validation, 
                               group = common_name,
                               colour = common_name)) + 
  geom_point(size = 2, alpha = 0.1) +
  geom_line(stat = "smooth",
            method = "glm", 
            se = FALSE, 
            method.args = list(family = binomial),
            linewidth = 1.5,
            alpha = 0.7) +
  scale_colour_manual(values = coul) +
  scale_x_continuous(limits = c(0.1, 1), expand = c(0, 0), breaks = seq(0.1, 1, by = 0.3)) +
  scale_y_continuous(limits = c(0, 1)) + 
  theme_bw() +
  labs(x = "BirdNET confidence", 
       y = "True positive rate",
       colour = "Species") +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        legend.title = element_blank(),
        legend.text = element_text(size = 12),
        legend.position = "bottom",
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)),
        plot.margin = margin(1, 1, 1, 1, "cm")) +
  guides(colour = guide_legend(ncol = 4)) 


ggsave(plot = g,
       filename = here("docs", "figures", "calibration_curves_logistic.PNG"),
       width = 24,
       height = 19,
       units = "cm",
       dpi = 300)



# species-specific thresholds ---------------------------------------------


species_list <- validated_all %>%
  pull(common_name) %>%
  unique()

threshold_0.9 <- c()
# Loop through each species
for (species in species_list) {
  
  result <- tryCatch({
    # Fit the model
    model <- validated_all %>% 
      filter(common_name == species) %>%
      glm(validation ~ confidence, 
          data = .,
          family = binomial)
    
    # Predict probabilities for the species
    probability <- detections_2023_2024_focal %>%
      filter(common_name == species) %>%
      mutate(probability = predict(model, newdata = ., type = "response")) 
    
    # Create a threshold table with precision and data retention
    threshold_table <- tibble(threshold = seq(0, 1, 0.001)) %>%
      mutate(data_remained = map_dbl(.x = threshold, 
                                     .f = ~ threshold2remain(probability, .x))) %>%
      mutate(precision = map_dbl(.x = threshold, 
                                 .f = ~ threshold2precision(probability, .x)))
    
    # Get the t_0.9 threshold
    t_0.9 <- precision2threshold(threshold_table, 0.9)
    
    # Return the calculated t_0.9
    t_0.9
  }, error = function(e) {
    # Return "Error" if an error occurs
    "Error"
  })
  
  # Append the result to the threshold_0.9 vector
  threshold_0.9 <- c(threshold_0.9, result)
}

threshold_0.9_table <- tibble(common_name = species_list, 
                              threshold = threshold_0.9) %>%
  mutate(threshold = ifelse(threshold <= 0.1, 0.1, threshold),
         threshold = ifelse(threshold >= 1, "Error", threshold))


# preliminary analysis ------------------------------------------------------













