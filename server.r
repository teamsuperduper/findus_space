# robojoyce: where should you relocate your government department?
# created for govhack 2017

library(shiny)
library(tidyverse)

# shinyServer: this gets called on page request and when reactive input
# values change. ui is in www/index.html
# input children are bound to the name attribute of elements in the html
# output children are bound to the id attribute of element in the html
# that has class "shiny-XXXX-output"
# more info on this structure at https://shiny.rstudio.com/articles/html-ui.html
shinyServer(function(input, output)
{
  # we want to do some algorithmic stuff here depending on the input. not sure
  # if we'll have updates as soon as values change or a 'spin' sort of button.

  if (some.condition)
  {
    # answer = 1
    output$answer = renderText({'Yuuuup'})
    output$comment = renderText({"This is one comment"})
  } else
  {
    # answer = 0
    output$answer = renderText({'Naaaah'})
    output$comment = renderText({"This is an alternate comment"})
  }
})

