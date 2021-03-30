# Choosing survey sites
# Parameters:
    # Grassland only
    # Want maximal gradient of grass and forb cover
    # Need to include natural habitats and the "novel" ones created by restoration
    # Include points where birds will be surveyed
    # Include KD points as much as possible to prevent redundant effort


#### Package and library installation ####
# ——————————————————————————————————
packages_needed = c("tidyverse", "rjson", "bigrquery", "ggmap", "knitr")
packages_installed = packages_needed %in% rownames(installed.packages())
if (any(!packages_installed))
    install.packages(packages_needed[!packages_installed])
for (i in 1:length(packages_needed)) {
    library(packages_needed[i], character.only = T)
}


#### API keys ####
# ——————————————————————————————————
# Big Query
bq_auth(
    path = paste0(getwd(), "/mpg-data-warehouse-api_key-master.json"),
    cache = NULL
)
Sys.setenv(BIGQUERY_TEST_PROJECT = "mpg-data-warehouse")
billing <- bq_test_project()

# Google maps
mapKey <-
    fromJSON(file = paste0(getwd(), "/R_globalKeys.json"))$mapKey
register_google(key = mapKey)


#### Styles and functions ####
# ——————————————————————————————————
# Global themes and styles
source(paste0(getwd(), "/supplemental.R"))


#### Pull data from source ####
# ——————————————————————————————————
# Grid point metadata
gp_meta_sql <-
    "
  SELECT grid_point, lat, long
  FROM `mpg-data-warehouse.grid_point_summaries.location_position_classification`
  "
gp_meta_bq <- bq_project_query(billing, gp_meta_sql)
gp_meta_tb <- bq_table_download(gp_meta_bq)
gp_meta_df <- as.data.frame(gp_meta_tb)

# Bird survey points from 2020
bird_2020_sql <-
    "
    SELECT DISTINCT survey_year, survey_grid_point
    FROM `mpg-data-warehouse.bird_point_count_summaries.abundance_order`
    WHERE survey_year = 2020
    ORDER BY survey_grid_point
    "
bird_2020_bq <- bq_project_query(billing, bird_2020_sql)
bird_2020_tb <- bq_table_download(bird_2020_bq)
bird_2020_df <- as.data.frame(bird_2020_tb) 

# KD proposed survey points
# Old points
kd_pts <-
    read.csv(paste0(getwd(), "/2021_gp_targets.csv"),
             sep = ",",
             header = TRUE) %>%
    rename(Name = "kd_targets_2021")
# New points
kd_pts_new <-
    read.csv(paste0(getwd(), "/2021_gp_targets_new.csv"),
             sep = ",",
             header = TRUE) %>%
    rename(Name = "grid_point",
           Latitude = "lat",
           Longitude = "long")

# Vegetation cover data from 2016
veg_sql <- 
    "
    SELECT grid_point, type4_indicators_history, key_plant_code, plant_native_status, plant_life_cycle, plant_life_form, intercepts_pct
    FROM `mpg-data-warehouse.vegetation_gridVeg_summaries.gridVeg_foliar_cover_all`
    WHERE year = 2016
    AND type4_indicators_history IN ('uncultivated grassland native or degraded', 'forage grass restoration', 'forage grass diversification')
    "
veg_bq <- bq_project_query(billing, veg_sql)
veg_tb <- bq_table_download(veg_bq)
veg_df <- as.data.frame(veg_tb) %>% glimpse() 


#### Filter data to help select points ####
# ——————————————————————————————————
# The goal is to get a large gradient of grass and forb cover in restored, diversified, and uncultivated grassland
# Maximize these gradients
# Data from restoration areas is old, but luckily these areas are the easiest to choose

veg_df %>% 
  filter(plant_life_cycle == "perennial", plant_life_form %in% c("forb", "graminoid")) %>% 
  group_by(type4_indicators_history, plant_life_form, grid_point) %>% 
  summarize(cover_pct = sum(intercepts_pct), .groups = "drop_last") %>%
  mutate(rank = rank(cover_pct)) %>% 
  pivot_wider(names_from = plant_life_form, values_from = c(cover_pct, rank)) %>% 
  replace_na(list(cover_pct_forb = 0, cover_pct_graminoid = 0, rank_forb = 0, rank_graminoid = 0)) %>% 
  mutate(diff_rank = rank_graminoid - rank_forb) %>% 
  arrange(type4_indicators_history, diff_rank) %>% 
  write_csv(., file = paste0(getwd(), "/forb_grass_ranked.csv"))
