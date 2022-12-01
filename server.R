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
  
  
  output$Marietxt <- renderText({
    paste0("Total Payment Amounts received by each Physician for selected cities.")
  })
  

  output$Abouttxt <- renderText({
    paste0("Open Payments: Payments that drug & medical device companies 
           make to covered recipients (physicians, nurses, etc). 
           Learn more at https://www.cms.gov/openpayments")
  })
  
  
  output$Hannahtxt <- renderText({
    paste0("Payments Over the Years: Shows the distribution of payments from $0 to 
           $50 between five of the highest populated cities in South Dakota.")
  })






  ## 'Select City' Output
  output$city <- renderUI({
    selectInput("city", "Select City", choices = cities)
  })


  output$EmmaType <- renderUI({
    selectInput("EmmaType", "Select Physician Type", choices = PrimaryType)
  })
  

  ## 'Select Year' Output
  output$year <- renderUI({
    selectInput("year_Hannah", "Select Year", choices = 2013:2018)
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


  ##Beginning of Hannah's Code 
  output$violin_plot_Hannah <- renderPlot({
    
    # Make the years match up from data
    Filtered_Hannah <- filter(Open_Hannah, year %in% input$year_Hannah)
    
    # Add the violin plot
    ggplot(Filtered_Hannah, 
           aes_string(x = input$year_Hannah, y = "total_amount_of_payment_usdollars")) +
      geom_violin(aes(fill = recipient_city)) +
      labs(y = "Payment ($US)")+
      theme(axis.text.y = element_text(size = 15),
            axis.title.y = element_text(size = 20),
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            legend.text = element_text(size = 15),
            legend.title = element_text(size = 15))
  })
  ##End of Hannah's Code 

  output$Emma <- renderPlot({
    Emmaplot <- ggplot(data = subset(Emmapayment2, Emmapayment2$physician_primary_type == input$EmmaType), 
                       mapping = aes(x = nature_of_payment_or_transfer_of_value, y = total_amount_of_payment_usdollars)) +
      geom_boxplot(fill = 'light blue') + ggtitle("Boxplot for Total Payment and Payment Type") +
      theme(axis.text.x = element_text(angle = 30, hjust = 1)) + 
      xlab("Type of Payment") + ylab("Total Payment Amount (US Dollars)")
    plot(Emmaplot)
  }, height = 600, width = 1000)


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
  


  
    ## Interactive plotly for physician totals, Marie
  output$MariePlotly <- renderPlotly({
    # initiate data values
    city <- input$city_marie
    
    # Histogram of total payment per physician
    payment_totals <-
      ggplot(phys_amount, aes(Total, na.rm=TRUE)) +
      geom_histogram(data=subset(phys_amount, 
                                 City==city & 
                                   !is.na(Total) &
                                   Total > 1),
                     fill="blue", 
                     bins=10000) +
      labs(title="Total payments ($) received per physician") + 
      xlab("Total payments received ($)") 
    
    ggplotly(payment_totals)
  })
  
  
  
  ################
  #Jakob's Addition
  
  output$jfplot <- renderPlot({
    
    if(input$Year == 'All'){
      ggplot(jfpay3, aes(x=date, y=Payment)) + geom_point() + 
        xlab("Time") + scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
        theme(axis.title.x = element_text(size = 16),
              axis.text.x = element_text(size = 12),
              axis.title.y = element_text(size = 16),
              axis.text.y = element_text(size = 16))
    }
    else{
      
      tmpstart <- "-01-01"
      tmpend <- "-12-31"
      
      str1 <- paste(input$Year, tmpstart, sep="")
      str2 <- paste(input$Year, tmpend, sep="")
      
      row.storer = NULL
      
      for (i in 1:length(jfpay3$date)){
        if (jfpay3$date[i] > str1 && jfpay3$date[i] < str2){
          row.storer = c(row.storer, i)
        }
      }
      
      tmp <- jfpay3[row.storer,]
      
      ggplot(tmp, aes(x=date, y=Payment)) + geom_point() + 
        xlab(input$Year) + scale_x_date(date_labels = "%b", date_breaks = "1 month") +
        theme(axis.title.x = element_text(size = 16),
              axis.text.x = element_text(size = 16),
              axis.title.y = element_text(size = 16),
              axis.text.y = element_text(size = 16))
    }
    
  })
  
  output$jfdatatable <- renderTable({
    
    nearPoints(jfpay3, input$plot_click, xvar = "date", yvar = "Payment")
    
  })
  
    
    output$distPlot <- renderPlot({
      d = payment_natalie %>% filter(physician_primary_type %in% input$SelectDr)
      ggplot(data = d, mapping = 
               aes(x = d$year, fill = d$physician_primary_type)) +
        labs(x = "Years", y = "Payments Made to Physician(s)", 
             fill = "Physician(s)") +
        geom_bar(position = 'dodge')
    })
    
     output$type1 <- renderPlot({
   
   plot(type$physician_primary_type, xlab = "type", ylab = "amount",
        main = "Primary Type of Physician")
 })
   output$Luketxt <- renderText({
    paste0("Primary type of the Physician.
              Medical Doctor = 86,303
              Doctor of Osteopathy = 7866
              Doctor of Dentisty = 4131
              Doctor of Optometry  = 3256
              Doctor of Podiatric Medicine = 948
              Chiropractor = 37")
  })
    


}


