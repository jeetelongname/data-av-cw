source("dataframes.R")
options(browser = "firefox")

library(ggplot2)
library(plotly)
library(htmlwidgets)

plot1 <- ggplot(data = image1) +
  geom_col(
    mapping = aes(x = year, y = number, fill = type),
    position = position_dodge()
  ) +
  ggtitle("Plot of average monthly, Incidents, Injuries and Deaths") +
  xlab("The year") +
  ylab("The number of incidents, injuries and deaths")

plot1_interactive <- ggplotly(plot1)

plot1_interactive |> saveWidget(
  file = "plot1.html", # the path & file name
  selfcontained = TRUE, # creates a single html file
  title = "Plot of yearly, Incidents, Injuries and Deaths"
)

ggsave(file = "plot1.pdf", plot = plot1)
