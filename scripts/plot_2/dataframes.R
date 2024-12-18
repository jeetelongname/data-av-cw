# types
library(lubridate)
# wrangle
library(readr)
library(dplyr)
library(tidyr)

options(browser = "firefox")

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

image2 <- data |>
  select("incident_id", "incident_date", "state", "n_killed", "n_injured") |>
  mutate(
    year = year(incident_date),
    month = month(incident_date)
  ) |>
  group_by(state) |>
  left_join(
    us_population_data,
    by = "state"
  )
