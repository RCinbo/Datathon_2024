#https://stackoverflow.com/questions/71560603/is-it-possible-to-parallelize-the-geocode-function-from-the-tidygeocoder-package
library(tictoc)
library(git2rdata)
address_list <- interventions$full_address_permanence %>%
  unique() %>%
  as.list()
plan(strategy = "multisession", workers = availableCores() - 1)
tic()
address_geodata <-
  future_map(.x = address_list,
             ~ geo(address = .x, method = 'osm', lat = latitude_permanence,
                   long = longitude_permanence)) %>% 
  # puts the lists back together into a dataframe/tibble
  bind_rows()
toc()

write_vc(address_geodata, file = "interventions_permanence_geodata",
         root = datafolder, sorting = "address")


###----------------Add geolocation to AED machine addresses------------------###
aed_loc <- read_parquet(
  file = paste0(datafolder, "/aed_locations.parquet.gzip")) %>%
  mutate(full_address = paste(address, number, postal_code, municipality)) %>%
  mutate(full_address = str_remove_all(full_address, "NA"))
address_list <- aed_loc$full_address %>%
  unique() %>%
  as.list()

plan(strategy = "multisession", workers = availableCores() - 1)
tic()
address_geodata <-
  future_map(.x = address_list,
             ~ geo(address = .x, method = 'osm', lat = latitude,
                   long = longitude)) %>% 
  # puts the lists back together into a dataframe/tibble
  bind_rows()
toc()

write_vc(address_geodata, file = "aed_geodata",
         root = datafolder, sorting = "address")
address_geodata <- read_vc(file = "aed_geodata",
                           root = datafolder)
leftover <- address_geodata %>%
  filter(is.na(longitude))
address_list <- leftover$address %>%
  unique() %>%
  as.list()
plan(strategy = "multisession", workers = availableCores() - 1)
tic()
address_geodata <-
  future_map(.x = address_list,
             ~ geo(address = .x, method = 'bing', lat = latitude,
                   long = longitude)) %>% 
  # puts the lists back together into a dataframe/tibble
  bind_rows()
toc()
address_geodata2 <- read_vc(file = "aed_geodata",
                           root = datafolder) %>%
  left_join(address_geodata, by = "address") %>%
  mutate(longitude = ifelse(is.na(longitude.x),
                            longitude.y,
                            longitude.x),
         latitude = ifelse(is.na(latitude.x),
                            latitude.y,
                            latitude.x)
  ) %>%
  dplyr::select(-contains("."))

