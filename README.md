# Open Payment South Dakota 2013-2018
Class project for SDSU STAT 442, FALL 2022. 
This website tracks payments and gifts to doctors in South Dakota. 

Deployed  [https://sdsucamp.shinyapps.io/Jenna/](https://sdsucamp.shinyapps.io/Jenna/).

# To contribute
Fork this repository first. Make changes. After testing, you can submit changes by creating Pull Requests to merge into the **Main branch**. The code at the **Deployed** branch are tested and deployed to the website.

# Bugs and ideas for improvements
File bug reports at the [Issues tab](https://github.com/gexijin/openPay/issues).  You can also write down any ideas for improvement. If you solve an issue, mark it so by closing the issue.

# Code Structure
Main files for the Shiny App:
1. **global.R**   This file contains global variables, which are usually created by reading in data files.
2. **ui.R**   This file defines user interface
3. **server.R** Server logic, such as functions to generate plots.

# Data files
1. **calebpayment.csv**
2. **Open_Payment_south_dakota_2013-18.csv**  
3. **payment.csv**               
4. **zippy.csv**
5. **jfpay.csv**         
6. **Open_Payment_south_dakota_2013-21.csv**
7. **updated_payment_data.csv**
