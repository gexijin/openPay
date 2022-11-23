###################################
# Global variables. Data preprocess
##################################

library(tidyverse)



#Read in entire open payments data set
total_pay_data <- read_csv("Open_Payment_south_dakota_2013-18.csv")

#Make year column of when payments were made
total_pay_data$year <- substr(total_pay_data$date_of_payment, 1, 4)



## for donut plot
payment <- read_csv("payment.csv")
payment$nature.of.payment <- as.factor(payment$nature.of.payment)

cities <- list(
  "SIOUX FALLS", "RAPID CITY", "PIERRE", "WATERTOWN", "VERMILLION",
  "ABERDEEN", "CUSTER", "MITCHELL", "SPEARFISH", "BROOKINGS"
)

## for map plot
mapdata <- read_csv("zippy.csv")


