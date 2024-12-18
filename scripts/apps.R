library(shiny)
# Number of national deaths due to guns over time
# A bar graph that shows the incidents, deaths and injuries each year

library(rsconnect)
# Number of deaths in each state
# DONE: scaled to population
# DONE: turn it into an interactive diagram that goes through each year
runApp("scripts/plot_2")
rsconnect::deployApp("plot_2")
# Focus in on the District of Columbia
## where are the incidents taking place
runApp("scripts/plot_3")
rsconnect::deployApp("plot_3")
## When incidents are taking place
runApp("scripts/plot_4")
rsconnect::deployApp("plot_4")
# see where that takes us

# if not check out the gun type and or a correlation
# between gun type and casulalties
