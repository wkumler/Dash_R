

# Setup things ----
library(shiny)
library(xml2)
library(tm)
library(dplyr)
library(ggplot2)
library(plotly)
library(httr)
library(png)
library(jpeg)




# Functions ----



# UI ----
ui <- navbarPage(
  title = "Back again?",
  tabPanel(
    titlePanel("Home"),
    mainPanel(
      fluidRow(
        column(width = 6,
               Sys.time() %>%
                 as.POSIXct() %>%
                 `attr<-`("tzone", "America/Los_Angeles") %>%
                 format("%I:%M %p<br>%B %e<br>%A") %>%
                 gsub(pattern = "^0", replacement = "", x = .) %>%
                 paste0("It's ", .) %>%
                 HTML() %>%
                 h3()
        )
      )
    )
  )
)



# Server ----
server <- function(input, output, session){
  
}



# Run app ----
shinyApp(ui = ui, server = server)