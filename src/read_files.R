library(rprojroot)
library(tidyverse)
library(arrow)
datafolder <- find_root_file("Data",
                             criterion = has_file("Datathon_2024.Rproj"))
interventions1 <- read_parquet(file = paste0(datafolder,
                                             "/interventions1.parquet"))
interventions2 <- read_parquet(file = paste0(datafolder,
                                             "/interventions2.parquet"))
interventions3 <- read_parquet(file = paste0(datafolder,
                                             "/interventions3.parquet"))
any(colnames(interventions1) != colnames(interventions2))
any(colnames(interventions3) != colnames(interventions2))#they all have the same colnames.

aed_loc <- read_parquet(
  file = paste0(datafolder, "/aed_locations.parquet.gzip"))
glimpse(aed_loc)
ambulance_loc <- read_parquet(
  file = paste0(datafolder, "/ambulance_locations.parquet.gzip"))
glimpse(ambulance_loc)
mug_loc <- read_parquet(
  file = paste0(datafolder, "/mug_locations.parquet.gzip"))
glimpse(mug_loc)
pit_loc <- read_parquet(
  file = paste0(datafolder, "/pit_locations.parquet.gzip"))
glimpse(pit_loc)
cad9 <- read_parquet(
  file = paste0(datafolder, "/cad9.parquet.gzip"))
glimpse(cad9)
interventions_bxl1 <- read_parquet(
  file = paste0(datafolder, "/interventions_bxl.parquet.gzip"))
glimpse(interventions_bxl1)
interventions_bxl2 <- read_parquet(
  file = paste0(datafolder, "/interventions_bxl2.parquet.gzip"))
glimpse(interventions_bxl2)
any(colnames(interventions_bxl1) != colnames(interventions_bxl2)) #they do not have the same column names
sum(colnames(interventions1) %in% colnames(interventions_bxl1)) #they do not have the same column names