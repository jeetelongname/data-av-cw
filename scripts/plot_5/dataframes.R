# In this file we have all of the dataframes.
# Some are larger than others because the amount
# of static processing we can do before we introduce
# the dynamic shiny variables is limited.

This file contains all of the dataframe scripts,
in each folder it will contain a subset of these files
# types
library(lubridate)
# wrangle
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(tibble)

options(browser = "firefox")

# full data set
data <- read_csv("data/gun-violence-data.csv") |>
  mutate(
    incident_date = ymd(incident_date),
    n_killed = as.numeric(n_killed),
    n_injured = as.numeric(n_injured)
  ) |>
  filter(incident_date %within% interval(ymd("2015-01-01"), ymd("2019-01-01")))

write_csv(data, file = "data/gun-violence-revised.csv")

image5 <- data |>
  select(
    "incident_date",
    "participant_age_group",
  ) |>
  filter(participant_age_group != "NA") |>
  mutate(
    year = year(incident_date),
    month = month(incident_date),
    participant_age_group = strsplit(participant_age_group, "\\|\\|") |>
      map(\(str) str_replace(str, "\\d::", ""))
  ) |>
  group_by(year, month) |>
  summarise(
    adult = length(
      participant_age_group[participant_age_group == "Adult 18+"]
    ),
    teen = length(
      participant_age_group[participant_age_group == "Teen 12-17"]
    ),
    child = length(
      participant_age_group[participant_age_group == "Child 0-11"]
    ),
    .groups = "drop_last"
  ) |>
  summarise(
    adult = mean(adult),
    teen = mean(teen),
    child = mean(child),
  ) |>
  pivot_longer(
    cols = c(adult, teen, child),
    names_to = "demographic",
    values_to = "number"
  )

