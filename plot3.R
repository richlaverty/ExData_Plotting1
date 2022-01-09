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
# Cast the Global_active_power as numeric (it is imported as factor)

twoDays <- filter(fullData, Date >= startDate & Date <= endDate)
twoDays <- mutate(twoDays, Global_active_power = as.numeric(as.character(Global_active_power)))
twoDays <- mutate(twoDays, DateTime = as.POSIXlt(paste(Date, Time)))

# line plots of the 3 Sub_metering columns as a function of the
# time, but label the days of the week on the horizontal axis

# the difference between DateTime and startDate will be given in
# seconds, and we want it in days, thus the division.
xValues <- as.numeric(twoDays$DateTime - startDate)/(24 * 60 * 60)
y1Values <- as.numeric(as.character(twoDays$Sub_metering_1))
y2Values <- as.numeric(as.character(twoDays$Sub_metering_2))
y3Values <- as.numeric(as.character(twoDays$Sub_metering_3))

# 1st, clear any currently running graphics devices
while(dev.cur() > 1) { dev.off() }

x11()
plot(xValues, y1Values, type = "l", col = "black", bg = "white", 
     main = "",
     xlab = "",
     ylab = "Energy sub metering",
     xaxp = c(0, 2, 2),
     xaxt = "n")
lines(xValues, y2Values, type = "l", col = "red")
lines(xValues, y3Values, type = "l", col = "blue")
axis(side = 1, at = c(0, 1, 2), labels = c("Thu", "Fri", "Sat"))
legend("topright",lty = c(1, 1, 1), col = c("black", "red", "blue", cex = 0.9),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, file = "plot3.png", height = 480, width = 480, units = "px")
dev.off() # writes the file, but leaves the screen device open

