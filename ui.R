library(shiny)
library(leaflet)

ui <- fluidPage(
  theme = "bootstrap.css",
  tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
            ),
  headerPanel("RoboJoyce: Relocate my Ministry"),
  mainPanel(width = "100%",
            leafletOutput("map", height = "85vh")
            ),
  absolutePanel(top = 140, right = 30, width = 340, padding = 20,
    id = "panel-intro", class = "panel-absolute",
    h4("Time to get regional"),
    p("They say a change is as good as a holiday! Well, I hope you like holidays
      because your employer has decided to relocate to regional Australia. We’re
      here to help you make the best decision for your future."),
    p("It’s time to find your new home."),
    actionButton("next", "Get Started!")
  ),
  p("by teamsuperduper", id = "author")
)
