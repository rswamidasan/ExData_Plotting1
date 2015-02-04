
##--------------------------------------------------------------------------##
##                                                                          ##
##                     Exploratory Data Analysis                            ##
##                                                                          ##
##                            Project 1                                     ##  
##                                                                          ##
##--------------------------------------------------------------------------##

##  Plot 3

##  This is a large file.  It has over 2 million rows, of which we need less
##  than 3,000.  So, steps have been taken to make the reading more efficient.

##  This script assumes that the data set file and/or zipped folder is present
##  in the working directory.  If the unzipped file is not present, the zipped 
##  folder is unzipped.  read.csv.sql() cannot use unz(), unfortunately.

filName <- "household_power_consumption.txt"

if (!file.exists(filName))
  unzip("exdata-data-household_power_consumption.zip")

##  Read in 1 line of the file to determine column classes.

pData <- read.table(filName, header = T, nrows = 1,
                    sep =";", as.is = T, na.strings ="?")

vClasses <- sapply(pData, class)      ##  Store column classes

maxLines <- 2 * 24 * 60               ##  Maximum # of observations
##  = 2 (days) * 24 (hrs) * 60 (mins)

library(sqldf)                        ##  loading sqldf package

##  Reading file via SQLite, to select only those dates of interest 
##  Telling R the colClasses makes reading files into Data Frames faster.
##  Specifying the number of rows lets R allocate memory in advance.

pData <- read.csv.sql(filName, 
                      sql = "select * from file 
                      WHERE Date = '1/2/2007' OR Date = '2/2/2007'",
                      header = T, , sep = ";", colClasses = vClasses,
                      nrows = maxLines)

pData$dateNTime <- strptime(paste(pData$Date, pData$Time),  format = "%d/%m/%Y %H:%M:%S")

png(file = "plot3.png", width = 480, height = 480)

with(pData, {
     plot(dateNTime, Sub_metering_1, type = "l", lwd = 1.5,
     xlab = "", 
     ylab = "Energy sub metering" )
 
     lines(dateNTime, Sub_metering_2, type = "l", lwd = 1.5,
                 col = "red", xlab = "", ylab = "" )

     lines (dateNTime, Sub_metering_3, type = "l", lwd = 1.5,
                 col = "blue", xlab = "", ylab = "" )

     legend("topright", lty = c("31"), col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

     })

dev.off()

rm(pData)

##-------------------------------------------------------------------------##
