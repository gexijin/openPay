###################################
# Global variables. Data preprocess
##################################

library(tidyverse)


## for donut plot
payment <- read_csv("payment.csv")
payment$nature.of.payment <- as.factor(payment$nature.of.payment)

cities <- list(
  "SIOUX FALLS", "RAPID CITY", "PIERRE", "WATERTOWN", "VERMILLION",
  "ABERDEEN", "CUSTER", "MITCHELL", "SPEARFISH", "BROOKINGS"
)

## for map plot
mapdata <- read_csv("zippy.csv")

## for Emma's tab
#get data
Emmapayment <- read.csv("~/Github/openPay/Emmapayment.csv")
# filter to payments greater than $1
Emmapayment2 <- Emmapayment %>% filter(Emmapayment$total_amount_of_payment_usdollars > 1)
# filter to payments less than $1000
Emmapayment2 <- Emmapayment2 %>% filter(Emmapayment2$total_amount_of_payment_usdollars < 1000)
# subset the data to only contain rows that have physician_primary_type not equal to nothing
Emmapayment2 <- subset(Emmapayment2, physician_primary_type != "")
# set physician_primary_type and nature_of_payment as a factor
Emmapayment2$nature_of_payment_or_transfer_of_value <- as.factor(Emmapayment2$nature_of_payment_or_transfer_of_value)
# change the names of the nature of payments
levels(Emmapayment2$nature_of_payment_or_transfer_of_value) <- c('Charitable Contribution', 
                                                                 'Compensation - Services', 'Compensation - Faculty', 'Consulting Fee', 
                                                                 'Investment Interest', 'Education', 'Entertainment', 'Food and Beverage', 
                                                                 'Gift', 'Grant', 'Honoraria', 'Royalty/License', 'Space Rental', 'Travel/Lodging')

PrimaryType <- unique(Emmapayment2$physician_primary_type)