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

# data for plot 1
# national deaths over the range
image1 <- data |>
  mutate(year = year(incident_date)) |>
  select("year", "n_killed", "n_injured") |>
  group_by(year) |>
  summarise(
    incidents = n(),
    n_killed = sum(n_killed, na.rm = TRUE),
    n_injured = sum(n_injured, na.rm = TRUE)
  ) |>
  pivot_longer(
    cols = c(incidents, n_killed, n_injured),
    names_to = "type",
    values_to = "number"
  )

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
  mutate(year = year(incident_date)) |>
  group_by(state) |>
  left_join(
    us_population_data,
    by = "state"
  )

# data for plot 3
# location of each death, with bigger bubbles for each location
image3 <- data |>
  select(
    "incident_id",
    "incident_date",
    "n_killed",
    "n_injured",
    "state",
    "latitude",
    "longitude"
  ) |>
  mutate(
    latitude = as.numeric(latitude),
    year = year(incident_date)
  )

image4 <- data |>
  mutate(year = year(incident_date)) |>
  select("year", "state", "incident_date", "n_killed", "n_injured")
