###########################
# Assignment 10 Shiny App #
###########################

library(shiny)
library(plotly)
library(DT)

# Define UI for application that draws a histogram
fluidPage(


  # Application title


  titlePanel("Doctor's Payments In South Dakota (2013-2018)"),
  
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
                                 }}"),
        tags$style("#Marietxt{color: black;
                                 font-size: 17px;
                                 font-style: bold;
                                 font-family: Times New Roman;
                                 }}"),
        tags$style("#Marietxt_search{color: black;
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
          "Payment type",
          uiOutput("city"),
          plotlyOutput("donut_plot"),
          verbatimTextOutput("txtOutput2")
        ),
        tabPanel(
          "Map",
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
        tabPanel("Physician Types",
        sidebarLayout(
          sidebarPanel(
            selectInput(
              inputId = "SelectDr",
              label = "Select Desired Physician Type(s)",
              choices = unique(payment_natalie$physician_primary_type),
              selected = "Medical Doctor",
              multiple = TRUE
            )

          ),
          mainPanel(
            plotOutput("distPlot")
          )
        )
        ),
      tabPanel(
        "Summaries",
        uiOutput("SelectYear"),
        dataTableOutput("Grace_table"),
        verbatimTextOutput("Gracetxt")
      ),
        tabPanel(
          "Type",
          uiOutput("EmmaType"),
          plotOutput("Emma")

        ),
      
        ### Begin Marie tab
        tabPanel(
          "Distribution",
          verbatimTextOutput("Marietxt"),
          sidebarLayout(
            sidebarPanel(
              titlePanel("Total payments received per physician"),
              selectInput("city_marie",
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
        tabPanel(
          "Search",
          verbatimTextOutput("Marietxt_search"),
          DTOutput("distTable_marie")       
        ),
        ### End Marie tab        
        
        ###Jakob's Addition
        
        tabPanel("Sequence", 
                 sidebarLayout(
                   sidebarPanel(
                     
                     titlePanel("Payment Over Time"),
                     
                     selectInput("Year", h3("Years"),
                                 choices = c('All', '2013', '2014', '2015',
                                             '2016', '2017', '2018')),
                     h4("Click on the data points for more info.")
                   ),
                   mainPanel(plotOutput("jfplot", click = "plot_click"),
                   tableOutput("jfdatatable"))
                 )
        ),
        tabPanel(
        "Physician Type",
        plotOutput("type1"),
        verbatimTextOutput("Luketxt")
        
      ),
        

        tabPanel(
          "About",
          verbatimTextOutput("Abouttxt")

        )

      ),
    width = 12
    )

  )


