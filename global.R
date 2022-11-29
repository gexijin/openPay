###################################
# Global variables. Data preprocess
##################################

library(tidyverse)


## for donut plot
payment <- read_csv("payment.csv")
payment$nature.of.payment <- as.factor(payment$nature.of.payment)

total_pay_data <- read_csv("Open_Payment_south_dakota_2013-18.csv")

cities <- list(
  "SIOUX FALLS", "RAPID CITY", "PIERRE", "WATERTOWN", "VERMILLION",
  "ABERDEEN", "CUSTER", "MITCHELL", "SPEARFISH", "BROOKINGS"
)

## for map plot
mapdata <- read_csv("zippy.csv")

Open_Hannah <- total_pay_data %>%
  filter(total_amount_of_payment_usdollars >= 1 & total_amount_of_payment_usdollars <= 50) %>%
  filter(recipient_city %in% c('SIOUX FALLS' , 'RAPID CITY','ABERDEEN', 'BROOKINGS','WATERTOWN'))

Open_Hannah$year <- substr(Open_Hannah$date_of_payment, 1, 4)
Open_Hannah$year <- as.factor(Open_Hannah$year)
