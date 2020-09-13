

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
  title = "Dash_R",
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
                 h2(),
               br(),
               Sys.time() %>%
                 as.POSIXct() %>%
                 `attr<-`("tzone", "America/Los_Angeles") %>%
                 `-`(strptime("1997-03-28", "%Y-%m-%d")) %>%
                 round() %>%
                 paste("You're", ., "days old today!") %>%
                 h3(),
               Sys.time() %>%
                 as.POSIXct() %>%
                 `attr<-`("tzone", "America/Los_Angeles") %>%
                 `-`(strptime("1997-03-28", "%Y-%m-%d")) %>%
                 as.numeric() %>%
                 `*`(24) %>%
                 round() %>%
                 paste0("(", ., " hours)") %>%
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