

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
      flowLayout(
        verticalLayout(
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
        ),
        verticalLayout(
          h2("Moon phase"),
          htmlOutput("moonimage")
        )
      )
    )
  )
)



# Server ----
server <- function(input, output, session){
  output$moonimage <- renderText({
    Sys.Date() %>%
      format("%m/%d/%Y") %>%
      paste0("https://www.moongiant.com/phase/", .) %>%
      gsub(pattern = "/0", replacement = "/", x = .) %>%
      read_html() %>%
      xml_find_all(xpath = '//*[@id="todayMoonContainer"]') %>%
      xml_child() %>%
      xml_attr("src") %>%
      paste0("https://www.moongiant.com", .) %>%
      img(src=.) %>%
      as.character()
  })
}



# Run app ----
shinyApp(ui = ui, server = server)