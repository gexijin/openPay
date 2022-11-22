library(shiny)
library(ggplot2)
library(plotly)
library(readr)
library(dplyr)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Open Payments SD Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("city",
                        h3("City of interest:"),
                        choices = c("SIOUX FALLS",
                                    "BROOKINGS",
                                    "ABERDEEN",
                                    "PINE RIDGE",
                                    "GROTON",
                                    "RAPID CITY"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlotly")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlotly <- renderPlotly({
        # initiate data values
        city <- input$city
    
        new.payments <- read.csv("new_open_payment_sd_MMoriarty.csv", header=T)
        
        phys_amount <- aggregate(new.payments$total_amount_of_payment_usdollars, 
                                 by = list(new.payments$physician_name,
                                           new.payments$recipient_city),
                                 FUN = sum)
        
        phys_amount <- phys_amount %>%
            dplyr::rename(Physician = Group.1,
                   City = Group.2,
                   Total = x)
        
        payment_totals <-
            ggplot(phys_amount, aes(Total, na.rm=TRUE)) +
            geom_histogram(data=subset(phys_amount, 
                                       City==city & 
                                       !is.na(Total) &
                                       Total > 0),
                           fill="blue", 
                           bins=10000) +
            labs(title="Total payments ($) received per physician") + 
            xlab("Total payments received ($)") 
        
        ggplotly(payment_totals)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
