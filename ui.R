library(shiny)
library(leaflet)

get_started_pane <- absolutePanel(top = 140, right = 30, width = 340,
    id = "panel-intro", class = "panel-absolute panel-controls",
    h4("Time to get regional"),
    p("They say change is as good as a holiday. Well, I hope you like holidays, because your employer has decided to relocate to regional Australia."),

    p(a(href="http://findus.space", "findus.space")," is here to help you make the best decision for your future. Time to find your new home."),
    actionButton("getStarted", "Get Started!"),

    tags$ul(class = "pager",
      tags$li(class = "next",
        tags$a(href="#", id ="getStarted", "Get Started!")
        ))

)

ui <- fluidPage(
  theme = "bootstrap.css",
  tags$head(
            tags$title("findus.space > relocate your life #govhack 2017"),
            tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
            ),
  headerPanel(
  img(src = "img/logo_BW_crop.png")
  ),
  mainPanel(width = "100%",


            leafletOutput("map", height = "85vh")
            ),
  get_started_pane,
  p("by teamsuperduper", id = "author")
)
