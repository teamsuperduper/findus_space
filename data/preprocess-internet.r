library(tidyverse)

towns = read_csv('town-locations.csv')
input = read_csv('abs-internet-sa2.csv')
  names(input) = c(
    'STRD_2016', 'dwelling_type', 'NEDD_2016', 'internet_type',
    'STATE', 'State', 'spatial_level', 'geography_level', 'code_sa2_2016', 'Region',
    'TIME', 'census_year', 'value', 'flag_codes', 'flags')
  input = input %>%
    select(dwelling_type, internet_type, spatial_level, code_sa2_2016, value) %>%
    filter(spatial_level == 'SA2') %>%
    filter(dwelling_type == 'Total') %>%
    mutate(internet_type = recode(internet_type,
      "Internet accessed from dwelling" = "has_internet_count",
      "Internet not accessed from dwelling" = "no_internet_count",
      "Not stated" = "unknown_count",
      "Total" = "total_count")) %>%
    spread(key = internet_type,  value = "value") %>%
    mutate(fraction_with_internet = has_internet_count / total_count) %>%
    filter(fraction_with_internet <= 1) %>%
    select(code_sa2_2016, has_internet_count, total_count,
      fraction_with_internet)