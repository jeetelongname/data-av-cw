library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)

source("dataframes.R")

ui <- fluidPage(
  titlePanel("Incidents over selected year in a selected state
or over the entire country"),
  selectInput("year", "select year", c(2015, 2016, 2017, 2018)),
  selectInput("state", "select state",
    choices = us_population_data$state
  ),
  checkboxInput("all_states",
    "show data over all states",
    value = FALSE
  ),
  hr(),
  plotlyOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderPlotly({
    year_in_question <- input$year
    state_in_question <- input$state
    all_states <- input$all_states

    dataframe <- image4 |>
      filter(year == year_in_question) |>
      filter(all_states | state == state_in_question) |>
      group_by(incident_date) |>
      summarise(
        incidents = n(),
        n_killed = sum(n_killed, na.rm = TRUE),
        n_injured = sum(n_injured, na.rm = TRUE)
      ) |>
      pivot_longer(
        cols = c(incidents, n_killed, n_injured),
        names_to = "type",
        values_to = "number",
      )

    plot <- ggplot(
      data = dataframe,
      mapping = aes(x = incident_date, y = number)
    ) +
      geom_smooth(mapping = aes(colour = type))

    ggplotly(plot)
  })
}

shinyApp(ui, server)
