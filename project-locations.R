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




