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
        tags$style("#txtOutput2{color: black;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Times New Roman;
                                 }"),
        tags$style("#txtOutput3{color: black;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Times New Roman;
                                 }"),

        tags$style("#txtOutput_Hannah{color: black;
                                      font-size: 17px;
                                      font-style: bold;
                                      font-family: Times New Roman;
                                      }"),

        tags$style("#txtOutput4{color: black;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Times New Roman;
                                 }"),

        tags$style("#city{color: black;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Times New Roman;
                                 }}")
      ),


      ## Tabs Panel
      tags$head(
        tags$style(
          type = "text/css",
          ".nav-tabs {color: black;
                                 font-size: 19px;
                                 font-style: bold;
                                 font-family: Times New Roman;
                                 }} "
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

        tabPanel(
          "Years",
          uiOutput("year"),
          plotOutput("violin_plot"),
          verbatimTextOutput("txtOutput_Hannah")
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
          "Payments by Physician",
          verbatimTextOutput("Marietxt"),
          sidebarLayout(
            sidebarPanel(
              titlePanel("Total payments received per physician"),
              selectInput("city",
                          h3("City of interest:"),
                          choices = c("SIOUX FALLS",
                                      "BROOKINGS",
                                      "ABERDEEN",
                                      "PINE RIDGE",
                                      "GROTON",
                                      "RAPID CITY"))
              ),
              mainPanel(plotlyOutput("MariePlotly"))
          )
          

        ),
        
        
        ###Jakob's Addition
        
        tabPanel("Payment Over Time", 
                 sidebarLayout(
                   sidebarPanel(
                     
                     titlePanel("Payment Over Time"),
                     
                     selectInput("Year", h3("Years"),
                                 choices = c('All', '2013', '2014', '2015',
                                             '2016', '2017', '2018'))
                   ),
                   mainPanel(plotOutput("jfplot", click = "plot_click"),
                   tableOutput("jfdatatable"))
                 )
        ),
        

        tabPanel(
          "About",
          verbatimTextOutput("Abouttxt")

        )

      ),
      width = 12
    )
)


