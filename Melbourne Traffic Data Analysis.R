#In order to determine the working directory for where our test data is located, we use the function getwd().
#Running the function "getwd()" we get the response in the console: - "C:/Users/adeyi/OneDrive/Documents/R Series Sheet/Module One Project"
#The file path returned is: - "C:/Users/adeyi/OneDrive/Documents/R Series Sheet/Module One Project". This is not the actual location of the file.
#Since our test data is stored in the folder "Assessment 1" in our "My Document" Folder, identifying the path returns the url:- "C:\Users\adeyi\OneDrive\Documents\RMIT classes\Data Wrangling\Assessment 1". 
#To set our directory to the file path defined we use the "Setwd" function.

setwd("C:/Users/adeyi/OneDrive/Documents/RMIT classes/Data Wrangling/Assessment 1")

#We may also use  

setwd("~/RMIT classes/Data Wrangling/Assessment 1")

#Our file name is "Traffic_Data_2014_2017.xlsx" and its file extension ".XLSX". 

#To read and store the file into a dataframe we may take several steps/processes. 


#STEP ONE
#----------------------------------------
#We declare the "openxlsx" package which must already have been installed using: -

install.packages("openxlsx")

library("openxlsx")

#We declare the object - "trafficdata01". We then assign the data to the object defined. We can then list the structure of our dataset using the str()function.

trafficdata01 <- read.xlsx(xlsxFile = "Traffic_Data_2014_2017.xlsx", sheet = 1, skipEmptyRows = FALSE)
trafficdata01

#We declare the structure of our dataframe - "trafficdata01" using the str() function
str(trafficdata01)

#we use the "summary()" function for our dataframe - "trafficdata01" to declare our
summary(trafficdata01)


