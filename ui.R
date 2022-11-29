###########################
# Assignment 10 Shiny App #
###########################

library(shiny)
library(plotly)
library(DT)

# Define UI for application that draws a histogram
fluidPage(
  
  
  # Application title
  
  titlePanel("Doctor's Payments In South Dakota (2013-2018)"
  ),
  
  # Main Panel
  
  mainPanel(
    
    
    ## Text Output and Styles
    tags$head(
      tags$style("#txtOutput2{color: steelblue;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Arial;
                                 }"),
      tags$style("#txtOutput3{color: steelblue;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Arial;
                                 }"),
      tags$style("#txtOutput4{color: steelblue;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Arial;
                                 }"),
      tags$style("#city{font-size: 17px;}")
    ),
    
    
    ## Tabs Panel
    tags$head(
      tags$style(
        type = "text/css",
        ".nav-tabs {font-size: 18px} "
      )
    ),
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "City",
        uiOutput("city"),
        plotlyOutput("donut_plot"),
        verbatimTextOutput("txtOutput2")
      ),
      tabPanel(
        "Zipcode",
        plotOutput("sd_map"),
        verbatimTextOutput("txtOutput3")
      ),
      
      tabPanel("Country",
               sidebarLayout(
                 sidebarPanel(
                   titlePanel("Payments by Country"),
                   selectInput("predictors", h3("Select Variable"),
                               choices = c('Physician_Primary_Type',
                                           'Related_Product_Indicator',
                                           'Charity_Indicator',
                                           'Form_of_Payment_or_Transfer_of_Value')
                   )
                 ),
                 mainPanel(plotOutput("country"))
               ),
               verbatimTextOutput("txtOutput4")
      ),
      tabPanel(
        "Total & Type",
        verbatimTextOutput("Emmatxt")
      ),        
      tabPanel(
        "Summaries",
        uiOutput("SelectYear"),
        dataTableOutput("Grace_table"),
        verbatimTextOutput("Gracetxt")
      ),
      tabPanel(
        "About",
        verbatimTextOutput("Abouttxt")
      )
    ),
    width = 12
  )
)