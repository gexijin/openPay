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

## new changes
