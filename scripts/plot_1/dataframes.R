# types
library(lubridate)
# wrangle
library(readr)
library(dplyr)
library(tidyr)
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

# data for plot 1
image1 <- data |>
  mutate(
    year = year(incident_date),
    month = month(incident_date)
  ) |>
  group_by(year, month) |>
  summarise(
    incidents = n(),
    n_killed = sum(n_killed, na.rm = TRUE),
    n_injured = sum(n_injured, na.rm = TRUE),
  ) |>
  select("year", "incidents", "n_killed", "n_injured") |>
  summarise(
    incidents = mean(incidents),
    n_killed = mean(n_killed),
    n_injured = mean(n_injured)
  ) |>
  pivot_longer(
    cols = c(incidents, n_killed, n_injured),
    names_to = "type",
    values_to = "number"
  )
