library(ggplot2)
library(plotly)
library(tidyverse)
library(sf) ## Overall handling of sf objects
library(cartography) ## Plotting maps package
library(tigris) ## For downloading the zipcode map

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  
  
  ## Text Outputs
  
  output$txtOutput2 <- renderText({
    paste0("Nature of Payments: Categories describing what form or type 
           of payment was made.")
  })
  output$txtOutput3 <- renderText({
    paste0("Amount: For each zipcode, a cumulative total of the dollar amount
           from every payment over the years 2013-18.")
  })
  output$txtOutput4 <- renderText({
    paste0("List of countries, except the US, who made payments.")
  })
  
  
  output$Gracetxt <- renderText({
    paste0("Summary Payments: Summary statistics for payments in each category 
          of doctor for each year from 2013 to 2018.")
  })
  output$Emmatxt <- renderText({
    paste0("Total Payment Amount by Payment Type and Profession")
  })
  
  output$Abouttxt <- renderText({
    paste0("Open Payments: Payments that drug & medical device companies 
           make to covered recipients (physicians, nurses, etc). 
           Learn more at https://www.cms.gov/openpayments")
  })
  
  
  
  
  ## 'Select City' Output
  output$city <- renderUI({
    selectInput("city", "Select City", choices = cities)
  })
  
  
  
  
  ## Plot Outputs
  output$donut_plot <- renderPlotly({
    
    # this solves the error when starting up.
    # if this input is not available, do not try to generate the plot
    req(input$city) 
    
    ## using input for city
    donutdata <- filter(payment, recipient_city == input$city)
    
    ## create dataframe
    donutdata2 <- data.frame(
      cat = levels(donutdata$nature.of.payment),
      count = tapply(
        donutdata$nature.of.payment, donutdata$nature.of.payment,
        length
      )
    )
    donutdata3 <- donutdata2 %>% drop_na(count)
    
    ## compute ymax and ymin
    donutdata3$fraction <- donutdata3$count / sum(donutdata3$count)
    donutdata3$ymax <- cumsum(donutdata3$fraction)
    donutdata3$ymin <- c(0, head(donutdata3$ymax, n = -1))
    
    ## change font
    t <- list(family = "Arial", size = 16, color = "black")
    
    ## plotting
    donutdata3 <- donutdata3 %>% group_by(cat)
    fig <- donutdata3 %>%
      plot_ly(
        labels = ~cat, values = ~fraction,
        insidetextorientation = "radial"
      ) %>%
      add_pie(hole = 0.6) %>%
      layout(
        showlegend = T,
        legend = list(title = list(text = "Type:", font = t))
      )
  })
  
  
  
  
  output$sd_map <- renderPlot({
    
    ## create dataframe
    yourdata <- data.frame(
      ZCTA5CE10 = mapdata$zippy,
      Amount = mapdata$total_amount_of_payment_usdollars
    )
    
    ## download a shapefile (shp,gpkg,geojson...)
    options(tigris_use_cache = TRUE)
    geo <- st_as_sf(zctas(cb = FALSE, state = "South Dakota", year = 2010))
    
    ## overall shape of the state
    state <- st_as_sf(zctas(cb = FALSE, state = "South Dakota", year = 2010))
    state <- st_transform(state, st_crs(geo))
    
    ## merge the data
    yourdata.sf <- merge(geo, yourdata)
    
    ## plotting
    par(mar = c(1, 1, 1, 1))
    ghostLayer(yourdata.sf)
    plot(st_geometry(state), add = TRUE, border = "gray")
    choroLayer(yourdata.sf,
               var = "Amount",
               add = TRUE,
               border = NA,
               legend.pos = "n"
    )
    legendChoro(
      pos = "bottomleft", title.txt = "Amount",
      title.cex = 1.8, values.cex = 1.35, cex = 1.1,
      breaks = c(
        "$15", "$30", "$100", "$250", "$750", "$2,000",
        "$6,200", "$53,000", "$7,140,000"
      ),
      col = carto.pal(pal1 = "blue.pal", n1 = 8)
    )
  })
  
  
  
  output$country <- renderPlot({
    ggplot(df2, aes_string(input$predictors)) +
      geom_bar(aes(fill = df2$'Applicable_Manufacturer_or_GOP_Making_Payment_Country')) +
      theme(axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.title.x = element_blank(),
            axis.text.x = element_text(size = 12),
            legend.text = element_text(size = 19),
            legend.title = element_text(size = 20)) +
      guides(fill = guide_legend(title = "Country"))
    
  })
  
  
  ## Select Year Output
  output$SelectYear <- renderUI({
    selectInput("SelectYear", "Select Year", choices = 2013:2018)
  })
  
  output$Grace_table <- renderDataTable({
    
    req(input$SelectYear) 
    
    table_data <- filter(total_pay_data, year == input$SelectYear)
    
    #find sum of all payments for each doctor type
    totalPayPerType <- aggregate(
      total_amount_of_payment_usdollars ~ physician_primary_type,
      data = table_data,
      FUN = sum
    )
    
    medPayPerType <- aggregate(
      total_amount_of_payment_usdollars ~ physician_primary_type,
      data = table_data,
      FUN = median
    )
    
    
    maxPayPerType <- aggregate(
      total_amount_of_payment_usdollars ~ physician_primary_type,
      data = table_data,
      FUN = max
    )
    
    
    minPayPerType <- aggregate(
      total_amount_of_payment_usdollars ~ physician_primary_type,
      data = table_data,
      FUN = min
    )
    
    #Combine all columns into one
    fulltable <- merge(totalPayPerType, 
                       medPayPerType, 
                       by = "physician_primary_type") %>%
      merge(maxPayPerType, by = "physician_primary_type" ) %>%
      merge(minPayPerType, by = "physician_primary_type" )
    
    
    #Change column names
    colnames(fulltable) <- c("Physician Type",
                             "Total Payment Amount",
                             "Most Common Payment",
                             "Max Payment", 
                             "Min Payment")
    
    #Print as table
    datatable(fulltable,
              options = list(orderClasses = TRUE),
              rownames = FALSE) %>%
      formatCurrency(2:5) %>% 
      formatRound(2:5, 2)
    
  })
  
}