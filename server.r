# robojoyce: where should you relocate your government department?
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

function(input, output, session) {
  # Create the map
  output$map <- renderLeaflet({
    leaflet("map") %>%
      addTiles(
               urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
               attribution = 'Maps by <a href = "http://www.mapbox.com/">Mapbox</a>'
               ) %>%
    setView(lng = 145.416667, lat = -24.25, zoom = 5) %>%
    addCircleMarkers(lng = town_data$X, lat = town_data$Y,
                     radius = as.integer(town_data$SSR_NAME11),
                     color = "#000", weight = 0.5, opacity = 0.7, fillOpacity = 0.7,
                     fillColor = "#8be")


  })

}
