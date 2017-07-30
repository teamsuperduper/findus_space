library(shiny)
library(leaflet)

get_started_pane <- absolutePanel(
    id = "panel-intro", class = "panel-absolute panel-controls",
    h4("Get out of town"),
    p("They say change is as good as a holiday. Well, I hope you like holidays,
      because your employer has decided to relocate your office to regional Australia. How exciting!"),
    p("The good news is regional Australia offers some of the ",
a(href = "http://regional.gov.au/regional/publications/regions_2030/", "best amenities"),
     " for the modern knowledge worker and ",
      a(href = "http://findus.space", "findus.space"),
      " is here to help you make the best decision for your future. Time to find your new home. 🌞"),
    actionButton("getStarted", "Get Started!")
)

ui <- fluidPage(
  theme = "bootstrap.css",
  tags$head(
            tags$title("findus.space > relocate your life"),
            tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
            tags$link(rel="shortcut icon", href="favicon.ico", type="image/x-icon"),
            tags$link(rel="icon", href="favicon.ico", type="image/x-icon"),
            tags$link(rel = "stylesheet", href="https://fonts.googleapis.com/css?family=Rubik:900")
            ),
  mainPanel(width = 12, style = "padding-left: 0;",
    img(src = "img/logo_BW_long_w.svg", alt = "findus.space", class = "img-fluid float-left", style = "max-width: 90%;")
  ),
  mainPanel(width = "100%",
            leafletOutput("map", height = "82vh")
            ),
  get_started_pane,
  p("by teamsuperduper", id = "author")
)
