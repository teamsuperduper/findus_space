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
  p("by teamsuperduper", id = "author")
)
