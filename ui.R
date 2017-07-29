library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput("map", height="800"),
  p(),
  actionButton("recalc", "New points"),
  p("by teamsuperduper")
)
