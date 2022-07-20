library(shiny)
require(readr)
library(ggplot2)

#citibike <- read_csv("https://firebasestorage.googleapis.com/v0/b/citybike-claudia-solis.appspot.com/o/citibike-tripdata.csv?alt=media&token=f2b325cd-c612-4623-b87b-a0e5f7f71ac7")


setwd("C:/Users/Casa/Documents/Diplomado/Módulo 6")
citibike <- read_csv("citibike-tripdata.csv")

ui <- shinyUI(pageWithSidebar(
  
  headerPanel("Citibike"),
  sidebarPanel( 
    dateRangeInput("date_range", "Rango de fechas:",
                   start  = "2021-09-01",
                   end    = "2021-09-30",
                   min    = "2021-09-01",
                   max    = "2021-09-30",
                   format = "dd/mm/yyyy",
                   separator = "-"),
    
    submitButton(text="Consultar")
  ),
  
  mainPanel(plotOutput("myplot")
  )
)
)

server <- shinyServer(function (input, output) {
  data.r = reactive({
    cb = subset(citibike, as.Date(started_at) >= input$date_range[1] & 
                  as.Date(started_at) <= input$date_range[2])
    return(cb)
  })
  
  output$myplot = renderPlot({
    dd<-data.r()
    print(ggplot(dd, aes(x=start_station_name, fill = rideable_type))  
          + geom_bar() 
          + theme(legend.position = "bottom") +
            theme(axis.text.x = element_text(angle = 90))  )
  })
})

shinyApp(ui = ui, server = server)