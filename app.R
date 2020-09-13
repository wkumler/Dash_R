

# Setup things ----
library(shiny)
library(xml2)
library(dplyr)




# Functions ----




# UI ----
ui <- function(req){navbarPage(theme = "solar.css",
  title = "Dash_R",
  tabPanel(
    titlePanel("Home"),
    fluidPage(
      fluidRow(
        column(
          width=3,
          wellPanel(
            Sys.time() %>%
              as.POSIXct() %>%
              `attr<-`("tzone", "America/Los_Angeles") %>%
              format("%I:%M %p<br>%B %e<br>%A") %>%
              gsub(pattern = "^0", replacement = "", x = .) %>%
              paste0("It's ", .) %>%
              HTML() %>%
              h1(),
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
        ),
        column(
          width=3,
          h1("Moon phase"),
          htmlOutput("moonimage") %>%
            a(href="https://www.moongiant.com/phase/", target="_blank")
        ),
        column(
          width=3,
          wellPanel(
            h1("Daylight"),
            "https://sunrise-sunset.org/us/seattle-wa" %>%
              read_html() %>%
              xml_find_all(xpath = '//div[@id="today"]//p[parent::div[@class="sunrise"]|parent::div[@class="sunset"]]') %>%
              xml_text() %>%
              paste0("<h3>", ., "</h3>", collapse = "<br/>") %>%
              HTML()
          )
        ),
        column(
          width=3,
          h1("APOD"),
          htmlOutput("APOD") %>%
            a(href="https://apod.nasa.gov/apod/astropix.html", target="_blank")
          
        )
      ),
      fluidRow(
        column(
          width=9,
          h1("Tides"),
          htmlOutput("tidechart") %>%
            a(href="http://tides.mobilegeographics.com/locations/7259.html", target="_blank")
        ),
        column(
          width=3,
          h1("EarthSky"),
          htmlOutput("earthsky") %>%
            a(href="https://earthsky.org/tonight", target="_blank")
        )
      )
    )
  )
)}



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
      img(src=., style="width: 100%; max-height: 30vh; max-width: 30vh") %>%
      as.character()
  })
  output$APOD <- renderText({
    img_url <- "https://apod.nasa.gov/apod/astropix.html" %>%
      read_html() %>%
      xml_find_all('//img') %>%
      xml_attr("src")
    if(!nchar(img_url)){
      "It's a video today!" %>%
        p() %>%
        as.character()
    } else {
      img_url %>%
        paste0("https://apod.nasa.gov/apod/", .) %>%
        img(src=., style="width: 100%; max-height: 30vh; max-width: 30vh") %>%
        as.character()
    }
  })
  output$tidechart <- renderText({
    Sys.Date() %>%
      as.POSIXct() %>%
      `attr<-`("tzone", "America/Los_Angeles") %>%
      format("http://tides.mobilegeographics.com/graphs/7259.png?y=%Y&m=%m&d=%d/") %>%
      img(src=., style="width: 100%; max-height: 30vh; max-width: 100vh") %>%
      as.character()
  })
  output$earthsky <- renderText({
    "https://earthsky.org/tonight" %>%
      read_html() %>%
      xml_find_all('//div[@id="tonight"]//img') %>%
      xml_attr("src") %>%
      img(src=., style="width: 100%; max-height: 30vh; max-width: 30vh") %>%
      as.character()
  })
}



# Run app ----
shinyApp(ui = ui, server = server)