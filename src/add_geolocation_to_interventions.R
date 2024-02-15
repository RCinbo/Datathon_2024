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