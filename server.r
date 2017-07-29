# FindUs.space: where should you relocate your government department?
# created for govhack 2017

library(shiny)
library(tidyverse)

library(leaflet)

town_data <- read_csv("data/town-locations.csv")
town_data$SSR_NAME11 <- factor(town_data$SSR_NAME11,
                               levels = rev(unique(town_data$SSR_NAME11))  # Not sure why this works, but it does...
                               )



# shinyServer: this gets called on page request and when reactive input
# values change. ui is in www/index.html
# input children are bound to the name attribute of elements in the html
# output children are bound to the id attribute of element in the html
# that has class "shiny-XXXX-output"
# more info on this structure at https://shiny.rstudio.com/articles/html-ui.html

get_started <- function() {
    removeUI(selector = "#panel-intro")
    insertUI(
        selector = "#author",
        where = "beforeBegin",
        ui = absolutePanel(top = 140, right = 30, width = 340,
            id = "panel-intro", class = "panel-absolute panel-controls",
            h4("What's in a move?"),
            p("Use the controls to select what matters to you."),
            sliderInput("netConnectivity", "How important is Internet Connectivity to you?",
                        min = 0, max = 10, value = 5),
            checkboxGroupInput("specialNeeds", "Special requirements?",
                               choices = c(
                                  "Low cost of living" = "livingCost",
                                  "Near the coast" = "coastal")
                               ),
            actionButton("devolveMe", "Devolve Me!")
        )
    )

}


# Create the map
map <- renderLeaflet({
  leaflet("map") %>%
    addTiles(
             urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
             attribution = 'Maps by <a href = "http://www.mapbox.com/">Mapbox</a>'
             ) %>%
  setView(lng = 145.416667, lat = -28, zoom = 4) %>%
  addCircleMarkers(lng = town_data$X, lat = town_data$Y,
                   radius = as.integer(town_data$SSR_NAME11) + 2,
                   color = "#000", weight = 0.5, opacity = 0.7, fillOpacity = 0.7,
                   fillColor = "#8be")
})


server <- function(input, output, session) {
  output$map <- map

  observeEvent(input$getStarted, get_started())
}
