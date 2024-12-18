# display
library(shiny)
library(plotly)
library(ggplot2)
# wrangle
library(dplyr)
library(glue)
# map
library(USA.state.boundaries)
library(sf)

source("dataframes.R")

ui <- fluidPage(
  titlePanel("Location of each incident in selected state"),
  selectInput("year", "select year", c(2015, 2016, 2017, 2018)),
  selectInput("state", "select state",
    choices = us_population_data$state
  ),
  hr(),
  plotlyOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderPlotly({
    year_in_question <- input$year
    state_in_question <- input$state

    plotframe <- filter(
      image3,
      state == state_in_question,
      year == year_in_question
    )

    map <- state_boundaries_wgs84 |>
      filter(NAME == state_in_question) |>
      select(NAME, Shape)

    plot <- ggplot() +
      geom_sf(data = map) +
      coord_sf() +
      geom_point(data = plotframe, mapping = aes(
        x = longitude, y = latitude,
        colour = n_killed + n_injured,
        text = glue("
Incident ID: {incident_id},
Incident date: {incident_date},
No. killed: {n_killed},
No. injured: {n_injured},
URL: {source_url}")
      ))

    plot |> ggplotly()
  })
}

shinyApp(ui, server)
