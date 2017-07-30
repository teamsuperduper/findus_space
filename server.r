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
    left_join(town_data, read_csv("data/prefs-internet.csv"),
        by = "UCL_CODE11") %>%
    left_join(., read_csv("data/prefs-coast.csv"),
        by = "UCL_CODE11") %>%
    left_join(., read_csv("data/prefs-rent.csv"),
        by = "UCL_CODE11") %>%
    left_join(., read_csv("data/prefs-votes.csv"),
        by = "UCL_CODE11")


###############################
# ALGORITHMIC FUNCTIONS
###############################

get_best_town <- function(inputs) {

    # calculate the weighted score
    results <- scores %>%
        mutate(score_weighted =
            (score_internet * inputs$prefs_netConnectivity) +
            (1 - abs(score_coast - inputs$prefs_coast)) +
            (score_rent * inputs$prefs_lowRent) +
            (score_votes * inputs$prefs_swing))

    if(
        !is.null(inputs$prefs_specialNeeds) &
        any(grepl('barnaby', inputs$prefs_specialNeeds)))
    {
        # if barnaby box is checked, just return armidale
        armidale = scores %>% filter(UCL_NAME11 == 'Armidale')
        name <- gsub(" \\(.*", "", armidale$UCL_NAME11[1])

        location <- list(
            "id" = armidale$UCL_NAME11[1],
            "name" = name,
            "state" = armidale$STE_NAME11,
            "lat" = armidale$Y[1],
            "lon" = armidale$X[1],
            "score_internet" = armidale$score_internet[1],
            "score_coast" = armidale$score_coast[1],
            "score_rent" = armidale$score_rent[1],
            "score_votes" = armidale$score_votes[1],
            "score_total" = 999,
            "population" = armidale$SSR_NAME11[1],
            "reason" = "you're Barnaby and it's Armidale.",
            "description" = paste(name, "is the future of Australia.",
                "The only future."))

    } else {

        bestish_town <- results %>%
            top_n(15, score_weighted) %>%   # grab top n scoring towns
            arrange(-score_weighted) %>%
            sample_n(1)                     # randomise the top result

        name <- gsub(" \\(.*", "", bestish_town$UCL_NAME11[1])

        location <- list(
            "id" = bestish_town$UCL_NAME11[1],
            "name" = name,
            "state" = bestish_town$STE_NAME11,
            "lat" = bestish_town$Y[1],
            "lon" = bestish_town$X[1],
            "score_internet" = bestish_town$score_internet[1],
            "score_coast" = bestish_town$score_coast[1],
            "score_rent" = bestish_town$score_rent[1],
            "score_total" = bestish_town$score_weighted[1],
            "population" = bestish_town$SSR_NAME11[1],
            "reason" = "it most closely aligns to your requirements.",
            "description" = paste(name, "is going to be a great fit! It's near the coast, has fast internet and reasonable house prices."))
    }

    return(list(location = location, all_scores = results$score_weighted))
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
               tags$style(type = "text/css", "
                 .irs-bar {width: 100%; height: 25px; background: black; border-top: 1px solid black; border-bottom: 1px solid black;}
                 .irs-bar-edge {background: black; border: 1px solid black; height: 25px; border-radius: 0px; width: 20px;}
                 .irs-line {border: 1px solid black; height: 25px; border-radius: 0px;}
                 .irs-grid-text {font-family: color: white; bottom: 17px; z-index: 1;}
                 .irs-grid-pol {display: none;}
                 .irs-max {font-family: 'arial'; color: black;}
                 .irs-min {font-family: 'arial'; color: black;}
                 .irs-single {color:black; background:#F2C94C;}
                 .irs-slider {width: 30px; height: 30px; top: 22px;}
               "),
            id = "panel-options", class = "panel-absolute panel-controls",
            h4("What's in a move?"),
            p(class="text-muted", "Use the controls to tell us what matters to you."),
            sliderInput(
                "prefs_netConnectivity",
                "How important is Internet access?",
                min = 0, max = 1, value = 0.5, step = 0.25),
            sliderInput(
                "prefs_coast",
                "How close to the coast would you like to be?",
                min = 0, max = 1, value = 0.5, step = 0.25),
            sliderInput(
                "prefs_lowRent",
                "How important is low rent to you?",
                min = 0, max = 1, value = 0.5, step = 0.25),
            sliderInput(
                "prefs_swing",
                "How important is a large swing last election?",
                min = 0, max = 1, value = 0.5, step = 0.25),
            checkboxGroupInput(
                "prefs_specialNeeds",
                "Any special requirements?",
                choices = c(
                    "Low cost of living 🏡️" = "livingCost",
                    "Easy access to childcare 👶" = "childcare",
                    "Good schools nearby 🎒" = "schools",
                    "I'm Barnaby Joyce 🤠" = "barnaby")),
            # this button calls the algorithm to find a place: go_find_us
            actionButton("devolveMe", "Relocate Me!")
        )
    )
}


update_map <- function(location, all_scores) {
    map_proxy <- leafletProxy("map")
    map_proxy %>% setView(lat = location$lat, lng = location$lon, zoom = 12)

    palette <- colorNumeric(palette = c("#544412", "#ffcd36"),
                            domain = range(all_scores, na.rm = TRUE))

    map_proxy %>% addCircleMarkers(
        lng = scores$X, lat = scores$Y,
        layerId = scores$UCL_CODE11,
        radius = as.integer(scores$SSR_NAME11) + 2,
        color = "#000", weight = 0.5, opacity = 0.7, fillOpacity = 0.7,
        fillColor = palette(all_scores))
}


# pass selected preferences to the algorithm. it returns a selected town,
# and we move the move to it and update the pane with some info.
go_find_us <- function(inputs) {
    removeUI(selector = ".panel-controls")

    results <- get_best_town(inputs)
    location <- results$location
    all_scores <- results$all_scores

    # Recenter map
    update_map(location, all_scores)

    insertUI(
        selector = "#author",
        where = "beforeBegin",
        ui = absolutePanel(
            id = "panel-destination", class = "panel-absolute panel-controls",
            h4("Welcome to", location$name),
            p(paste0("We've crunched all the data and think ", location$name, ", ", location$state, ", with a findus.space score of ",
                format(location$score_total * 100, digits = 2),
                " and a population of ", location$population,
                ", is suitable for your department, because ",
                location$reason)),
            p(location$description),
            actionButton("backToSelector", "< Back"),
            actionButton("exploreData", "Explore Data")
        )
    )
}


# Show a popup at the given location
show_town_popup <- function(id, lat, lng) {
    town <- scores[scores$UCL_CODE11 == id, ]
    content <- as.character(tagList(
        tags$h6(gsub(" \\(.*", "", town$UCL_NAME11[1])),
        p("population: ", as.character(town$SSR_NAME11),
          "electorate: ", town$Elect_div, br(),
          "internet: ", town$score_internet, br(),
          "coast: ", town$score_coast, br(),
          "rent: ", town$score_rent, br(),
          "votes: ", town$score_votes)
        ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = 'popup')
}

check_map_click <- function(map_click) {
    leafletProxy("map") %>% clearPopups()
    event <- map_click
    if (is.null(event))
        return()

    isolate({
        show_town_popup(event$id, event$lat, event$lng)
    })
}

# Create the map
map <- renderLeaflet({
    leaflet("map") %>%
        addTiles(
            urlTemplate = "http://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.png",
            attribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            ) %>%
        setView(lng = 149.1300, lat = -35.2809, zoom = 11) %>%
        addCircleMarkers(
            lng = scores$X, lat = scores$Y,
            layerId = scores$UCL_CODE11,
            radius = as.integer(scores$SSR_NAME11) + 2,
            color = "#000", weight = 0.5, opacity = 0.7, fillOpacity = 0.7,
            fillColor = "#f2c94c"
        )
})


# server: this gets called on page request and when reactive input
# values change.
# ui is in ui.R

server <- function(input, output, session) {
    output$map <- map

    observeEvent(input$getStarted, get_started())
    observeEvent(input$devolveMe, go_find_us(input))
    observeEvent(input$backToSelector, get_started())

    observe(check_map_click(input$map_marker_click))
}
