#### Description ####
# ——————————————————————————————————





#### Package and library installation ####
# ——————————————————————————————————
packages_needed = c("tidyverse", "knitr", "rjson", "bigrquery", "ggmap")
packages_installed = packages_needed %in% rownames(installed.packages())
if (any(! packages_installed))
    install.packages(packages_needed[! packages_installed])
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
mapKey <- fromJSON(file = paste0(getwd(), "/R_globalKeys.json"))$mapKey
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
  SELECT *
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
read.csv(fromJSON(file = paste0(getwd(), "/R_globalKeys.json"))$kd_clust, sep = ",", header = TRUE)
# These aren't right, these are just the clustered points with all grid points. 

                 