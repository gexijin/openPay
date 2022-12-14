###################################
# Global variables. Data preprocess
##################################

library(tidyverse)



#Read in entire open payments data set
total_pay_data <- read_csv("data/Open_Payment_south_dakota_2013-18.csv")

#Make year column of when payments were made
total_pay_data$year <- substr(total_pay_data$date_of_payment, 1, 4)


## Jenna Start ##
## for donut plot
jennapayment <- read_csv("data/jennapayment.csv")
jennapayment$nature.of.payment <- as.factor(jennapayment$nature.of.payment)

cities <- list(
  "SIOUX FALLS", "RAPID CITY", "PIERRE", "WATERTOWN", "VERMILLION",
  "ABERDEEN", "CUSTER", "MITCHELL", "SPEARFISH", "BROOKINGS"
)

## for map plot
mapdata <- read_csv("data/zipcode_data.csv")
## Jenna End ##

Open_Hannah <- total_pay_data %>%
  filter(total_amount_of_payment_usdollars >= 1 & total_amount_of_payment_usdollars <= 50) %>%
  filter(recipient_city %in% c('SIOUX FALLS' , 'RAPID CITY','ABERDEEN', 'BROOKINGS','WATERTOWN'))

Open_Hannah$year <- substr(Open_Hannah$date_of_payment, 1, 4)
Open_Hannah$year <- as.factor(Open_Hannah$year)

## for Emma's tab
#get data
Emmapayment <- read.csv("data/Emmapayment.csv")
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


# Caleb Start
calebdf <- read_csv("data/calebpayment.csv") # only making payment country & payment total

# merge with jenna's df

calebdf2 <- cbind(calebdf, jennapayment)


# remove US
calebdf2 <- calebdf2 %>% 
  filter(applicable_manufacturer_or_applicable_gpo_making_payment_country != "United States")

# rename cols
names(calebdf2)[names(calebdf2) == 'applicable_manufacturer_or_applicable_gpo_making_payment_country'] <- 'Applicable_Manufacturer_or_GOP_Making_Payment_Country'
names(calebdf2)[names(calebdf2) == 'physician_primary_type'] <- 'Physician_Primary_Type'
names(calebdf2)[names(calebdf2) == 'form_of_payment_or_transfer_of_value'] <- 'Form_of_Payment_or_Transfer_of_Value'
names(calebdf2)[names(calebdf2) == 'charity_indicator'] <- 'Charity_Indicator'
names(calebdf2)[names(calebdf2) == 'related_product_indicator'] <- 'Related_Product_Indicator'
names(calebdf2)[names(calebdf2) == 'nature.of.payment'] <- 'Nature_of_Payment'
names(calebdf2)[names(calebdf2) == 'recipient_city'] <- 'Recipient_City'

# change data types
calebdf2$'Applicable_Manufacturer_or_GOP_Making_Payment_Country' <- as.factor(calebdf2$'Applicable_Manufacturer_or_GOP_Making_Payment_Country')
calebdf2$'Physician_Primary_Type' <- as.factor(calebdf2$'Physician_Primary_Type')
calebdf2$'Form_of_Payment_or_Transfer_of_Value' <- as.factor(calebdf2$'Form_of_Payment_or_Transfer_of_Value')
calebdf2$'Related_Product_Indicator' <- as.factor(calebdf2$'Related_Product_Indicator')
calebdf2$'Charity_Indicator' <- as.factor(calebdf2$'Charity_Indicator')

# list for UI
countrycol <- list(
  'Physician_Primary_Type', 'Related_Product_Indicator', 'Charity_Indicator',
  'Form_of_Payment_or_Transfer_of_Value'
)
# Caleb End



#for Natalie's bar graph
library(dplyr)
paymentdata_natalie <- read_csv("data/Open_Payment_south_dakota_2013-18.csv", 
      col_types = cols(
        total_amount_of_payment_usdollars = col_number(),
        program_year = col_number()
      )
)
payment_natalie <- paymentdata_natalie %>%
  filter(paymentdata_natalie$total_amount_of_payment_usdollars > 1)
payment_natalie$year <- substr(payment_natalie$date_of_payment, 1, 4) 

payment_natalie$physician_primary_type <- as.factor(payment_natalie$physician_primary_type)

################# Marie's code

# Fix typos in city variable

# Change recipient_city to factor and change case
total_pay_data$recipient_city <- as.factor(
  toupper(total_pay_data$recipient_city))

# Fix typos in key cities
levels(total_pay_data$recipient_city)[
  levels(total_pay_data$recipient_city) =="BOBRIDGE"] <- "MOBRIDGE"

levels(total_pay_data$recipient_city)[
  levels(total_pay_data$recipient_city) == "SIOUXFALLS"|
  levels(total_pay_data$recipient_city) == "SIOUS FALLS"|
  levels(total_pay_data$recipient_city) == "SIOUX FALLAS"|
  levels(total_pay_data$recipient_city) == "AVE SIOUX FALLS"|
  levels(total_pay_data$recipient_city) == "SIOUX FALL"] <- "SIOUX FALLS"

levels(total_pay_data$recipient_city)[
  levels(total_pay_data$recipient_city) == "RA[ID CITY"|
  levels(total_pay_data$recipient_city) == "RAPIID CITY"] <- "RAPID CITY"

levels(total_pay_data$recipient_city)[
  levels(total_pay_data$recipient_city) == "N SIOUX CITY"|
  levels(total_pay_data$recipient_city) == "NORTH SIOU"|
  levels(total_pay_data$recipient_city) == "SIOUX CITY"] <- "NORTH SIOUX CITY"

levels(total_pay_data$recipient_city)[
  levels(total_pay_data$recipient_city) == "400 22ND AVE"] <- "BROOKINGS"


### New variables for the physician totals
# Create single name variable
total_pay_data$physician_full_name <- 
  toupper(
    paste(
      total_pay_data$physician_first_name,
      total_pay_data$physician_last_name,
      sep = " "
    )
  )

# Total payments received by each physician
phys_amount <- aggregate(total_pay_data$total_amount_of_payment_usdollars, 
                         by = list(total_pay_data$physician_full_name,
                                   total_pay_data$recipient_city),
                         FUN = sum)

# Rename columns in physician amounts data frame
phys_amount <- phys_amount %>%
  rename(Physician = Group.1,
         City = Group.2,
         Total = x)

############# End Marie's code

###################
#Jakob's addition

jfpay <- read.csv("data/jfpay.csv", stringsAsFactors=TRUE)
jfpay3 <- jfpay[-c(1)]
jfpay3$date <- as.Date(jfpay3$date, "%Y-%m-%d")
jfpay3$year <- as.character(jfpay3$year)

##Luke's Addition
type <- total_pay_data[, c("physician_primary_type")]
type %>% drop_na(physician_primary_type)
type$physician_primary_type <- as.factor(type$physician_primary_type)

