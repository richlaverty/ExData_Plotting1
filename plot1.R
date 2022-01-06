# clean up the workspace

rm(list = ls())

# set the working directory and download the data, if necessary

setwd("/home/rich/Documents/programs/data_science/04_Exploratory_Data_Analysis/ExData_Plotting1")

if(!file.exists("data")){dir.create("data")}
if(!file.exists("./data/exdata_data_household_power_consumption.zip"))
{
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, destfile = "./data/exdata_data_household_power_consumption.zip")
  unzip("./data/exdata_data_household_power_consumption.zip", exdir = "./data/")
}

# Bring the data into R

rawfile <- "household_power_consumption.txt"
fullData <- read.csv2(paste("./data/",rawfile, sep = ""))

# fullData is a data frame containing more than 2,000,000 rows
# of data collected at a sampling rate of 1.0 minute, over a period
# of more than 4 years.  We are actually only interested 2 days in 
# February 2007.

library(dplyr)
fullData <- mutate(fullData, Date = as.character(Date))
fullData <- mutate(fullData, Date = strptime(Date, "%d/%m/%Y"))
attr(fullData,"tzone") <- "EST"

startDate <- as.POSIXlt("2007-02-01", tz = "EST")
endDate <- as.POSIXlt("2007-02-02", tz = "EST")

# Now, extract the data between startDate and endDate

twoDays <- filter(fullData, Date >= startDate & Date <= endDate)
twoDays <- mutate(twoDays, Global_active_power = as.numeric(Global_active_power))


