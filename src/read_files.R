library(R.utils)
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

gunzip(paste0(datafolder,
              "/aed_locations.parquet.gzip"))