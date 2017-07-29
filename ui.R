library(shiny)
library(leaflet)

get_started_pane <- absolutePanel(top = 140, right = 30, width = 340,
    id = "panel-intro", class = "panel-absolute panel-controls",
    h4("Time to get regional"),
    p("They say a change is as good as a holiday! Well, I hope you like holidays
      because your department has decided to relocate to regional Australia. We’re
      here to help you make the best decision for your future."),
    p("It’s time to find your new home."),
    actionButton("getStarted", "Get Started!")
)

ui <- fluidPage(
  theme = "bootstrap.css",
  tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
            ),
  headerPanel("FindUs.space", "FindUs.space: where should you send your government department next?"),
  mainPanel(width = "100%",
            leafletOutput("map", height = "85vh")
            ),
  get_started_pane,
  p("by teamsuperduper", id = "author")
)
