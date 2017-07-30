library(tidyverse)

# remap_scores: function to normalise a vector of values to a new range
# (for comparing different calculated factors)
remap_scores = function(scores, from = 0, to = 1)
{
    return(
        (scores - min(scores)) /
        max(scores - min(scores)) *
        (to - from) + from)
}

process_internet = function()
{
  # read in the town data and the internet data
  towns = read_csv('../town-locations.csv',
    col_types = cols(
      .default = col_character(),
      X = col_double(),
      Y = col_double(),
      UCL_CODE11 = col_integer(),
      SSR_CODE11 = col_integer(),
      SOS_CODE11 = col_integer(),
      STE_CODE11 = col_integer(),
      AREA_SQKM = col_double()))
  input = read_csv('abs-internet-sa2.csv',
    col_types = cols(
      .default = col_character(),
      Value = col_integer()))

  # tidy the internet data up
  names(input) = c(
    'STRD_2016', 'dwelling_type', 'NEDD_2016', 'internet_type',
    'STATE', 'State', 'spatial_level', 'geography_level', 'SA2_MAIN16', 'Region',
    'TIME', 'census_year', 'value', 'flag_codes', 'flags')
  input = input %>%
    select(dwelling_type, internet_type, spatial_level, SA2_MAIN16, value) %>%
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
    select(SA2_MAIN16, fraction_with_internet)

  # join the two frames so we have a list of towns and internet scores
  result = inner_join(towns, input, by = 'SA2_MAIN16')
  result$score_internet = remap_scores(result$fraction_with_internet,
    from = 0, to = 1)
  result = result %>%
    select(UCL_CODE11, score_internet)

  write_csv(result, '../prefs-internet.csv')
}

process_centreofaus = function()
{
  input = read_csv('gis-distance-centreofaus.csv',
    col_types = cols(
      .default = col_character(),
      UCL_CODE11 = col_integer(),
      HubDist = col_double()))
  input$score_centreofaus = remap_scores(input$HubDist,
    from = 1, to = 0)
  result = input %>% select(UCL_CODE11, score_centreofaus)
  write_csv(result, '../prefs-centreofaus.csv')
}

process_coast = function()
{
  input = read_csv('gis-distance-coast.csv',
    col_types = cols(
      .default = col_integer(),
      Distance = col_double()))
  input$Distance = remap_scores(input$Distance ** (1/3),  # less coastal bias
    from = 1, to = 0)
  input = input %>% select(InputID, Distance)
  names(input) = c('UCL_CODE11', 'score_coast')
  write_csv(input, '../prefs-coast.csv')
}