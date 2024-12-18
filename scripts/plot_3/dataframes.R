# types
library(lubridate)
# wrangle
library(readr)
library(dplyr)
library(tidyr)

# full data set
data <- read_csv("data/gun-violence-data.csv") |>
  mutate(
    incident_date = ymd(incident_date),
    n_killed = as.numeric(n_killed),
    n_injured = as.numeric(n_injured)
  ) |>
  filter(incident_date %within% interval(ymd("2015-01-01"), ymd("2019-01-01")))

# data for plot 2
us_population_data <- read_csv("data/nst-est2019-alldata.csv") |>
  select(
    "NAME",
    "POPESTIMATE2015",
    "POPESTIMATE2016",
    "POPESTIMATE2017",
    "POPESTIMATE2018",
  ) |>
  rename(
    state = NAME,
    y2015 = "POPESTIMATE2015",
    y2016 = "POPESTIMATE2016",
    y2017 = "POPESTIMATE2017",
    y2018 = "POPESTIMATE2018",
  ) |>
  slice(6:n())

# data for plot 3
# location of each death, with bigger bubbles for each location
image3 <- data |>
  select(
    "incident_date",
    "incident_id",
    "latitude",
    "longitude",
    "n_injured",
    "n_killed",
    "source_url",
    "state"
  ) |>
  mutate(
    latitude = as.numeric(latitude),
    year = year(incident_date)
  )
