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

##Caleb
### for box plot
df <- read_csv("calebpayment.csv") # only making payment country & payment total

# merge with jenna's df
df2 <- cbind(df, payment)

# remove US
df2 <- df2 %>% 
  filter(applicable_manufacturer_or_applicable_gpo_making_payment_country != "United States")

# rename cols
names(df2)[names(df2) == 'applicable_manufacturer_or_applicable_gpo_making_payment_country'] <- 'Applicable_Manufacturer_or_GOP_Making_Payment_Country'
names(df2)[names(df2) == 'physician_primary_type'] <- 'Physician_Primary_Type'
names(df2)[names(df2) == 'form_of_payment_or_transfer_of_value'] <- 'Form_of_Payment_or_Transfer_of_Value'
names(df2)[names(df2) == 'charity_indicator'] <- 'Charity_Indicator'
names(df2)[names(df2) == 'related_product_indicator'] <- 'Related_Product_Indicator'
names(df2)[names(df2) == 'nature.of.payment'] <- 'Nature_of_Payment'
names(df2)[names(df2) == 'recipient_city'] <- 'Recipient_City'
df2$'Applicable_Manufacturer_or_GOP_Making_Payment_Country' <- as.factor(df2$'Applicable_Manufacturer_or_GOP_Making_Payment_Country')
df2$'Physician_Primary_Type' <- as.factor(df2$'Physician_Primary_Type')
df2$'Form_of_Payment_or_Transfer_of_Value' <- as.factor(df2$'Form_of_Payment_or_Transfer_of_Value')
df2$'Related_Product_Indicator' <- as.factor(df2$'Related_Product_Indicator')
df2$'Charity_Indicator' <- as.factor(df2$'Charity_Indicator')


#for Natalie's bar graph
library(dplyr)
paymentdata <- read_csv("Open_Payment_south_dakota_2013-18.csv", 
      col_types = cols(total_amount_of_payment_usdollars = col_number(), 
      program_year = col_number()))
payment <- paymentdata %>%
  filter(paymentdata$total_amount_of_payment_usdollars > 1)
payment$year <- substr(payment$date_of_payment, 1, 4) 
min(payment$year)
payment$physician_primary_type <- as.factor(payment$physician_primary_type)