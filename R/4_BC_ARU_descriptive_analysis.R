

# library -----------------------------------------------------------------

library(tidyverse)
library(here)

library(RColorBrewer)
library(ggforce)


# functions ---------------------------------------------------------------

# function to get the threshold given desired precision for multiple species
get_species_thresholds <- function(species_list, precision_target, 
                                   validated_all, detections_2023_2024_focal) {
  
  # find precision given a threshold
  threshold2precision <- function(probability_data, threshold){
    threshold <- probability_data %>%
      filter(confidence > threshold) %>%
      pull(probability) %>%
      mean()
  }
  
  # function to determine the threshold given specified precision level
  precision2threshold <- function(threshold_table, precision){
    model <- glm(precision ~ threshold, 
                 data = threshold_table,
                 family = binomial)
    
    (log(precision/(1 - precision)) - model$coefficients[1])/model$coefficients[2]
  }
  
  # Initialize the vector to store results
  thresholds <- numeric(length(species_list))
  names(thresholds) <- species_list
  
  for (species in species_list) {
    
    # Attempt to fit the model and find threshold
    precision_table <- tryCatch(
      {
        model <- validated_all %>%
          filter(common_name == species) %>%
          glm(validation ~ confidence, 
              data = ., 
              family = binomial)
        
        probability <- detections_2023_2024_focal %>%
          filter(common_name == species) %>%
          mutate(probability = predict(model, newdata = ., type = "response"))
        
        tibble(threshold = seq(0, 1, 0.001)) %>%
          mutate(precision = map_dbl(.x = threshold, 
                                     .f = ~ threshold2precision(probability, .x))) 
      },
      
      warning = function(w) {
        message(paste("Warning for species:", species, "-", conditionMessage(w)))
        return(NULL)  # Return NULL for warning
      },
      
      error = function(e) {
        message(paste("Error for species:", species, "-", conditionMessage(e)))
        return(NULL)  # Return NULL for errors
      }
    )
    
    # Handle the result of tryCatch
    if (is.null(precision_table)) {
      message(paste("Skipping species due to model not converging:", species))
      thresholds[species] <- 1
      next  # Skip the rest of the loop for this species
    }
    
    # Assign the calculated threshold
    t_target <- precision2threshold(precision_table, precision_target)
    thresholds[species] <- t_target
  }
  
  return(thresholds)
}


# data input --------------------------------------------------------------

# filtered BirdNET detections for the 27 focal species
load(here("data", "BirdNET_detections", "detections_2023_2024_focal.rda"))

# bird list of BC
bc_list <- read_csv(here("data", "bird_list", "atlasdata_bc_birdlist.csv"))

# all validated data by Sunny, Remi and David
column_spec <- cols(
  date = col_character(),
  datetime = col_character(),
  start = col_double(),
  end = col_double(),
  scientific_name = col_character(),
  common_name = col_character(),
  confidence = col_double()
)

validated_all <- list.files(here("data", "validation_recordings", "z_finished_files"), 
                            full.name = TRUE) %>%
  map_dfr(read_csv, col_types = column_spec) %>%
  filter(validation != "U") %>%
  mutate(validation = ifelse(validation == "y", "Y", validation),
         validation = ifelse(validation == "Y", 1, 0)) %>%
  mutate(date = parse_date_time(date, orders = c("ymd", "mdy")),
         datetime = ymd_hms(datetime)) %>%
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
coul <- colorRampPalette(coul)(25)

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

species_list_zero <- validated_all %>%
  group_by(common_name) %>%
  summarise(all_zero = sum(validation)) %>%
  filter(all_zero == 0) %>%
  pull(common_name)

t_0.9 <- get_species_thresholds(species_list = species_list ,
                                precision_target = 0.9,
                                validated_all = validated_all,
                                detections_2023_2024_focal = detections_2023_2024_focal)

t_0.95 <- get_species_thresholds(species_list = species_list ,
                                 precision_target = 0.95,
                                 validated_all = validated_all,
                                 detections_2023_2024_focal = detections_2023_2024_focal)

t_0.99 <- get_species_thresholds(species_list = species_list ,
                                 precision_target = 0.99,
                                 validated_all = validated_all,
                                 detections_2023_2024_focal = detections_2023_2024_focal)

threshold_table <- tibble(common_name = species_list, 
                          t_0.9 = t_0.9,
                          t_0.95 = t_0.95,
                          t_0.99 = t_0.99) %>%
  mutate(across(c(t_0.9, t_0.95, t_0.99), ~ ifelse(. < 0.1, 0.1, ifelse(. > 1, 1, .)))) %>%
  mutate(across(c(t_0.9, t_0.95, t_0.99), ~ ifelse(common_name %in% species_list_zero, 1, .))) %>%
  mutate(across(c(t_0.9, t_0.95, t_0.99), \(x) round(x, digits = 3))) 


save(object = threshold_table, 
     file = here("docs", "tables", "threshold_table.rda"))


# preliminary analysis ------------------------------------------------------

# load(here("docs", "tables", "threshold_table.rda"))
vis_data <- detections_2023_2024_focal %>%
  mutate(hour = fct_inorder(factor(hour))) %>%
  left_join(threshold_table) %>%
  drop_na(t_0.95) %>%
  group_by(common_name) %>%
  filter(confidence > t_0.95)

my_colors <- colorRampPalette(brewer.pal(8, "Set2"))(26)


# daily activity
daily_pattern <- vis_data %>%
  ggplot() +
  geom_bar(aes(x = hour), stat = "count") +
  facet_wrap(~common_name, scales = "free_y", ncol = 4) +
  scale_x_discrete(labels = c("22", "", "00", "", "02", "", "04", 
                              "", "06", "", "08", "", "10")) +
  labs(title = "Number of species detections by time of the day (precision = 0.95)",
       x = "Time of a day",
       y = "Number of detections") +
  theme_bw() +
  theme(axis.text = element_text(size = 11),
        axis.title = element_text(size = 16))

ggsave(plot = daily_pattern,
       filename = here("docs", "figures", "daily_pattern_0.95.PNG"),
       width = 24,
       height = 18,
       units = "cm",
       dpi = 300)


# seasonal activity
seasonal_pattern <- vis_data %>% 
  ggplot() +
  geom_bar(aes(x = date, fill = common_name), stat = "count") +
  scale_x_date(date_breaks = "12 days",
               date_minor_breaks = "2 days",
               date_labels = "%b %d") +
  scale_fill_manual(values = my_colors) +
  facet_grid_paginate(common_name ~ year, 
                      scales = "free", ncol = 2, nrow = 4, page = 1) + # change the page num to view
  labs(x = "Day of year",
       y = "Number of detections") +
  theme_bw() +
  theme(legend.position = "none",
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 16),
        axis.title.x = element_text(margin = margin(t = 6)),  
        axis.title.y = element_text(margin = margin(r = 10)))

ggsave(plot = seasonal_pattern,
       filename = here("docs", "figures", "seasonal_pattern_0.95_1.PNG"),
       width = 24,
       height = 20,
       units = "cm",
       dpi = 300)







