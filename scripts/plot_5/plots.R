source("dataframes.R")
options(browser = "firefox")

library(ggplot2)
library(plotly)
library(htmlwidgets)

plot5 <- ggplot(data = image5) +
  geom_col(
    mapping = aes(x = year, y = number, fill = demographic),
    position = position_fill()
  ) +
  ggtitle("Proportion of age groups associated with gun incidents") +
  ylab("Proportion of people in age group")

ggsave(file = "plot5.pdf", plot = plot5)

plot5 |>
  ggplotly() |>
  saveWidget(
    file = "plot5.html", # the path & file name
    selfcontained = TRUE, # creates a single html file
    title = "Plot of yearly, Incidents, Injuries and Deaths"
  )
