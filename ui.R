###########################
# Assignment 10 Shiny App #
###########################

library(shiny)
library(plotly)
library(DT)

# Define UI for application that draws a histogram
fluidPage(


  # Application title

  titlePanel("Open Payments In South Dakota (2013-2018)"
  ),
  
  # Sidebar with a select input for City
  sidebarLayout(


    sidebarPanel(verbatimTextOutput("txtOutput"), width = 0),
    mainPanel(


      ## Text Output and Styles
      tags$head(
        tags$style("#txtOutput{color: steelblue;
                                 font-size: 18px;
                                 font-style: bold;
                                 font-family: Arial;
                                 }"),
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
          "Nature of Payments, by City",
          uiOutput("city"),
          plotlyOutput("donut_plot"),
          verbatimTextOutput("txtOutput2")
        ),
        tabPanel(
          "Totaled Payment Amounts, by Zipcode",
          plotOutput("sd_map"),
          verbatimTextOutput("txtOutput3")
        ),

        tabPanel("Payments by Country",
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
         )
        tabPanel(
          "Total Payment and Payment Type",
          verbatimTextOutput("Emmatxt")
        ),        
        tabPanel(
          "Payment Summaries",
          verbatimTextOutput("Gracetxt")
        )
      ),
      width = 12
    )
  )
)
