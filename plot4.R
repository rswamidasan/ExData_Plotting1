
##--------------------------------------------------------------------------##
##                                                                          ##
##                     Exploratory Data Analysis                            ##
##                                                                          ##
##                            Project 1                                     ##  
##                                                                          ##
##--------------------------------------------------------------------------##

##  Plot 4

##  This is a large file.  It has over 2 million rows, of which we need less
##  than 3,000.  So, steps have been taken to make the reading more efficient.

##  This script assumes that the unzipped data file or zipped archive is present
##  in the working directory.  If the unzipped file is not present, it is extracted 
##  from the archive.  read.csv.sql() cannot use unz() as an argument, unfortunately.

filName <- "household_power_consumption.txt"

if (!file.exists(filName))
  unzip("exdata-data-household_power_consumption.zip")

##  Read in 1 line of the file to determine column classes.

pData <- read.table(filName, header = TRUE, nrows = 1,
                    sep =";", as.is = TRUE, na.strings ="?")

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
                      header = TRUE, , sep = ";", 
                      colClasses = vClasses, nrows = maxLines)

pData$dateNTime <- strptime(paste(pData$Date, pData$Time),  format = "%d/%m/%Y %H:%M:%S")

png(file = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2), cex = 0.74)                    ## cex.lab = 1.1, cex.axis = 0.75)

with(pData, {
     plot(dateNTime, Global_active_power, type = "l",
                 xlab = "", 
                 ylab = "Global Active Power" )
     
     plot(dateNTime, Voltage, type = "l",
          xlab = "datetime", 
          ylab = "Voltage" )

     plot(dateNTime, Sub_metering_1, type = "l", lwd = 1.5,
          xlab = "", 
          ylab = "Energy sub metering" )
     
     lines(dateNTime, Sub_metering_2, type = "l", lwd = 1.5,
           col = "red", xlab = "", ylab = "" )
     
     lines (dateNTime, Sub_metering_3, type = "l", lwd = 1.5,
            col = "blue", xlab = "", ylab = "" )
     
     legend("topright", lty = c("31"), bty = "n", col = c("black", "red", "blue"), 
            legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
     
     plot(dateNTime, Global_reactive_power, type = "l",
          xlab = "datetime", )
     
    })

dev.off()

rm(pData)

##-------------------------------------------------------------------------##
