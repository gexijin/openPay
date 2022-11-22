###########################
# Assignment 10 Shiny App #
###########################

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
fluidPage(


  # Application title
  titlePanel(h1("Open Payments In South Dakota (2013-2018)",
    align = "center"
  )),


  # Sidebar with a select input for City
  sidebarLayout(


    sidebarPanel(width = 0),
    fluid = TRUE,
    mainPanel(


      ## Text Output and Styles
      verbatimTextOutput("txtOutput"),
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
              titlePanel("Test"),
              selectInput("predictors", h3("Select Variable"),
                          choices = c("Physician Primary Type",
                                      "Related Product Indicator",
                                      "Charity Indicator",
                                      "Form of Payment or Transfer of Value")
                          )
            ),
            mainPanel(plotOutput("country"))
          ),
          verbatimTextOutput("txtOutput4")
        )
      ),
      width = 12
    )
  )
)
