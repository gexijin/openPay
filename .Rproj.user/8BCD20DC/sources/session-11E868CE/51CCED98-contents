phys_amount <- aggregate(payment$total_amount_of_payment_usdollars, 
                         by = list(new.payments$physician_name,
                                   new.payments$recipient_city),
                         FUN = sum)

# phys_amount <- phys_amount %>%
#   rename(Physician = Group.1,
#          City = Group.2,
#          Total = x)
# 
# payment_totals <-
#   ggplot(phys_amount, aes(Total, na.rm=TRUE)) +
#   geom_histogram(data=subset(phys_amount, 
#                              City=="SIOUX FALLS" & 
#                                !is.na(Total) & Total > 50000),
#                  fill="blue",
#                  bins=100) +
#   labs(title="Total payments ($) received per physician") + 
#   xlab("Total payments received ($)") 
# 
# ggplotly(payment_totals)
# 
# 
# 



##############################################################################################3