

# library -----------------------------------------------------------------

library(tidyverse)
library(here)



# get a list of files -----------------------------------------------------

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


# create a list of all csv files in the directory
all_csv_files <- c(list.files(path = here("data", 
                                          "audio_output", 
                                          "Chilcotin_Cariboo_ARU_2023_BirdNET_output"),
                              full.names = TRUE,
                              pattern = "\\.csv$",
                              recursive = TRUE),
                   list.files(path = here("data", 
                                          "audio_output", 
                                          "Chilcotin_Cariboo_ARU_2024_BirdNET_output"),
                              full.names = TRUE,
                              pattern = "\\.csv$",
                              recursive = TRUE))

filtered_csv_files <- all_csv_files[!grepl("nocturnal_random_selected", all_csv_files)]



# finding effort ----------------------------------------------------------

effort_info <- tibble(filepath = filtered_csv_files) %>%
  mutate(filename = str_split_i(filepath, "/", -1),
         year = str_extract(filename, "202[34]"), 
         month = str_extract(filename, "(?<=202[34])\\d{2}"), 
         day = str_extract(filename, "(?<=202[34]\\d{2})\\d{2}"), 
         date = paste(year, month, day, sep = "-") %>% ymd() %>% as.Date()) %>%
  mutate(site = str_split_i(filepath, "/", 6),
         location = if_else(year == "2023", 
                       str_split_i(filepath, "/", 7),
                       str_split_i(site, " - ", 2)),
         site = str_split_i(site, " - ", 1)) %>%
  mutate(site_location = paste0(site, "_", location)) %>%
  distinct(site, location, site_location, date)

  
effort_wrangling <- effort_info %>%
  group_by(date) %>%
  summarize(ARUs = n_distinct(site_location)) %>%
  mutate(year = year(date),
         md = paste("1994", month(date), day(date), sep = "-") %>% ymd()) %>%
  select(-date) 

all <- effort_wrangling %>% expand(year, md)

effort_final <- effort_wrangling %>%
  right_join(all) %>%
  mutate(ARUs = replace_na(ARUs, 0)) 


save(object = effort_final, 
     file = here("data", "effort", "effort_final.rda"))


# visualization of effort -------------------------------------------------

effort_change <- ggplot(data = effort_final) +
  geom_line(aes(x = md, y = ARUs, colour = factor(year)), 
            linewidth = 1.5) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_date(date_labels = "%b %d", date_breaks = "15 days") +
  labs(x = "Day of a year", y = "No. of ARU", colour = "Year") +
  guides(colour = guide_legend(position = "inside")) + 
  
  theme_bw() +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 14),
        legend.position.inside = c(0.89, 0.82),
        axis.title.y = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)))  

effort_change

ggsave(plot = effort_change,
       filename = here("docs", "figures", "effort.PNG"),
       width = 24,
       height = 12,
       units = "cm",
       dpi = 300)

