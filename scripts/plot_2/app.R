library(shiny)
library(plotly)
library(ggplot2)

library(glue)
library(tidyr)
library(dplyr)

source("dataframes.R")


ui <- fluidPage(
  titlePanel("Mean Number of Incidents, Deaths and Injuries
              per 100,000 people"),
  p("All states shown are above the average amount of incidents per 100,000."),
  selectInput(
    inputId = "year",
    label = "Select Year",
    choices = c(2015, 2016, 2017, 2018)
  ),
  checkboxInput(
    inputId = "all_states",
    label = "show all states",
    value = FALSE
  ),
  hr(),
  plotlyOutput("plot")
)


server <- function(input, output) {
  output$plot <- renderPlotly({
    year_in_question <- input$year
    year_col <- glue("y{year_in_question}")

    state_stats <- image2 |>
      filter(year == year_in_question) |>
      select(
        pop = year_col,
        "state", "year", "month",
        "n_killed", "n_injured"
      ) |>
      group_by(state, month) |>
      summarise(
        incidents = n(),
        n_killed = sum(n_killed, na.rm = TRUE),
        n_injured = sum(n_injured, na.rm = TRUE),
        pop = unique(pop), # HACK
        .groups = "drop_last"
      ) |>
      mutate(
        incidents_per_100_000 = (incidents / pop) * 100000,
        n_killed_per_100_000 = (n_killed / pop) * 100000,
        n_injured_per_100_000 = (n_injured / pop) * 100000
      ) |>
      summarise(
        incidents_per_100_000 = mean(incidents_per_100_000),
        n_killed_per_100_000 = mean(n_killed_per_100_000),
        n_injured_per_100_000 = mean(n_injured_per_100_000),
      )

    mean_incidents <- summarise(state_stats,
      mean = mean(incidents_per_100_000)
    )$mean

    if (!input$all_states) {
      state_stats <- filter(
        state_stats,
        incidents_per_100_000 >= mean_incidents
      )
    }

    plotframe <- state_stats |>
      pivot_longer(
        cols = c(
          "incidents_per_100_000",
          "n_killed_per_100_000",
          "n_injured_per_100_000"
        ),
        names_to = "type",
        values_to = "number"
      ) |>
      select("state", "type", "number")

    plot2 <- ggplot(data = plotframe) +
      geom_col(
        mapping = aes(x = state, y = number, fill = type),
        position = position_dodge()
      ) +
      coord_cartesian(ylim = c(0, 15)) +
      theme_classic() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.5)) +
      xlab("State") +
      ylab("Number")

    plot2 |> ggplotly()
  })
}

shinyApp(ui, server)
