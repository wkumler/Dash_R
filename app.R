

# Setup things ----
library(shiny)
library(xml2)
library(dplyr)




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
          htmlOutput("moonimage") %>%
            a(href="https://www.moongiant.com/phase/", target="_blank")
        ),
        
        verticalLayout(
          h2("Daylight"),
          "https://sunrise-sunset.org/us/seattle-wa" %>%
            read_html() %>%
            xml_find_all(xpath = '//div[@id="today"]//p[parent::div[@class="sunrise"]|parent::div[@class="sunset"]]') %>%
            xml_text() %>%
            paste0("<h4>", ., "</h4>", collapse = "<br/>") %>%
            HTML()
        ),
        
        verticalLayout(
          h2("APOD"),
          htmlOutput("APOD") %>%
            a(href="https://apod.nasa.gov/apod/astropix.html", target="_blank")
        ),
        
        verticalLayout(
          h2("Tides"),
          htmlOutput("tidechart") %>%
            a(href="http://tides.mobilegeographics.com/locations/7259.html", target="_blank")
        ),
        
        verticalLayout(
          h2("EarthSky"),
          htmlOutput("earthsky") %>%
            a(href="https://earthsky.org/tonight", target="_blank")
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
      img(src=., style="height: 200px") %>%
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
        img(src=., style="height: 200px") %>%
        as.character()
    }
  })
  output$tidechart <- renderText({
    Sys.Date() %>%
      as.POSIXct() %>%
      `attr<-`("tzone", "America/Los_Angeles") %>%
      format("http://tides.mobilegeographics.com/graphs/7259.png?y=%Y&m=%m&d=%d/") %>%
      img(src=., style="height:200px") %>%
      as.character()
  })
  output$earthsky <- renderText({
    "https://earthsky.org/tonight" %>%
      read_html() %>%
      xml_find_all('//div[@id="tonight"]//img') %>%
      xml_attr("src") %>%
      img(src=., style="height: 200px") %>%
      as.character()
  })
}



# Run app ----
shinyApp(ui = ui, server = server)