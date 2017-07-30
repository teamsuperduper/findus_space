# FindUs.space: where should you relocate your government department?
# created for govhack 2017

library(shiny)
library(tidyverse)

library(leaflet)

###############################
# Data Loading
###############################

town_data <- read_csv("data/town-locations.csv")
town_data$SSR_NAME11 <- factor(town_data$SSR_NAME11,
                               levels = rev(unique(town_data$SSR_NAME11))  # Not sure why this works, but it does...
                               )
scores <-
    left_join(town_data, read_csv('data/prefs-internet.csv'),
        by = 'UCL_CODE11') %>%
    # left_join(., read_csv('data/prefs-centreofaus.csv'),
    #     by = 'UCL_CODE11') %>%
    left_join(., read_csv('data/prefs-coast.csv'),
        by = 'UCL_CODE11') %>%

print(head(scores))


###############################
# ALGORITHMIC FUNCTIONS
###############################

get_best_town <- function(inputs) {
    
    # calculated the weighted score
    result <- scores %>%
        mutate(score_weighted =
            (score_internet * inputs$prefs_netConnectivity) +
            # TODO - nearly everyone's coast score is 0.9–1; maybe dial it down?
            (1 - abs(score_coast - inputs$prefs_coast))
            ) %>%
        top_n(15, score_weighted) %>%    # grab top n scoring towns
        arrange(-score_weighted) %>%
        sample_n(1)                     # randomise the top result
    location <- list(
        "name" = result$UCL_NAME11[1],
        "lat" = result$Y[1],
        "lon" = result$X[1],
        "score_internet" = result$score_internet[1],
        "score_coast" = result$score_coast[1],
        "score_total" = result$score_weighted[1],
        "reason" = "it's near the beach, stupid.",
        "description" = paste(
            result$UCL_NAME11[1], "has lots of beaches and old people."))
    return(location)
}

###############################
# SERVER FUNCTIONS
###############################

# this panel has the sliders corresponding to our dataset inputs
get_started <- function() {
    removeUI(selector = ".panel-controls")
    insertUI(
        selector = "#author",
        where = "beforeBegin",
        ui = absolutePanel(
            id = "panel-options", class = "panel-absolute panel-controls",
            h4("What's in a move?"),
            p("Use the controls to select what matters to you."),
            sliderInput(
                "prefs_netConnectivity",
                "How important is Internet access?",
                min = 0, max = 1, value = 0.5),
            # sliderInput(
            #     "prefs_centreofaus",
            #     "How close to the centre of Australia do you want to be?",
            #     min = 0, max = 1, value = 0.5),
            sliderInput(
                "prefs_coast",
                "How close to the beach would you like to be? 🏖",
                min = 0, max = 1, value = 0.5),
            checkboxGroupInput(
                "prefs_specialNeeds",
                "Special requirements?",
                choices = c(
                    "Low cost of living" = "livingCost")),
            # this button calls the algorithm to find a place: go_find_us
            actionButton("devolveMe", "Devolve Me!")
        )
    )
}


# pass selected preferences to the algorithm. it returns a selected town,
# and we move the move to it and update the pane with some info.
go_find_us <- function(inputs) {
    removeUI(selector = ".panel-controls")
    results <- get_best_town(inputs)
    location <- results[1]
    all_scores <- results[2]
    leafletProxy('map') %>%
        setView(lat = location$lat, lng = location$lon, zoom = 12)
    insertUI(
        selector = "#author",
        where = "beforeBegin",
        ui = absolutePanel(
            id = "panel-destination", class = "panel-absolute panel-controls",
            h4("Welcome to", location$name),
            p(paste0("We think ", location$name, ", with a score of ",
                format(location$score_total * 100, digits = 2),
                ", is suitable for your department, because ",
                location$reason)),
            p(location$description),
            actionButton("backToSelector", "< Back"),
            actionButton("exploreData", "Explore Data")
        )
    )
}


# Create the map
map <- renderLeaflet({
    leaflet("map") %>%
        addTiles(
            urlTemplate = "http://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png",
            attribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            ) %>%
        setView(lng = 149.1300, lat = -35.2809, zoom = 13) %>%
        addCircleMarkers(lng = town_data$X, lat = town_data$Y,
            radius = as.integer(town_data$SSR_NAME11) + 2,
            color = "#000", weight = 0.5, opacity = 0.7, fillOpacity = 0.7,
            fillColor = "#f2c94c")
})


# server: this gets called on page request and when reactive input
# values change.
# ui is in ui.R

server <- function(input, output, session) {
  output$map <- map

  observeEvent(input$getStarted, get_started())
  observeEvent(input$devolveMe, go_find_us(input))
  observeEvent(input$backToSelector, get_started())
}
